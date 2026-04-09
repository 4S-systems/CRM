<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Vector"%>
<%@page import="com.maintenance.db_access.GroupPrevMgr"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page pageEncoding="UTF-8" %>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<html>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        ArrayList<WebBusinessObject> projectsLst = (ArrayList<WebBusinessObject>) request.getAttribute("projects");
        String projectID = request.getAttribute("projectID") != null ? (String) request.getAttribute("projectID") : "";
        String stat = (String) request.getSession().getAttribute("currentMode");
        WebBusinessObject userWbo = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
        GroupPrevMgr groupPrevMgr = GroupPrevMgr.getInstance();
        Vector groupPrev = groupPrev = groupPrevMgr.getOnArbitraryKey(userWbo.getAttribute("groupID").toString(), "key1");
        ArrayList<String> userPrevList = new ArrayList<>();
        WebBusinessObject wbo1;
        for (int i = 0; i < groupPrev.size(); i++) {
            wbo1 = (WebBusinessObject) groupPrev.get(i);
            userPrevList.add((String) wbo1.getAttribute("prevCode"));
        }
        ArrayList<WebBusinessObject> units = (ArrayList<WebBusinessObject>) request.getAttribute("unitsArr");
        String align, dir, style, sTitle, view, project, unitCode, clientName, deliveryDateStr, deliveryStatus, contract,
                noDateSpecified, delivered, toBeDelivered, noAttachedContract;
        if (stat.equals("En")) {
            align = "center";
            dir = "LTR";
            style = "text-align:left";
            sTitle = "Units Delivery";
            view = "view";
            project = "Project";
            unitCode = "Unit No.";
            clientName = "Client Name";
            deliveryDateStr = "Delivery Date";
            deliveryStatus = "Delivery Status";
            contract = "Contract";
            noDateSpecified = "No Date Specified";
            delivered = "Delivered";
            toBeDelivered = "To be Delivered";
            noAttachedContract = "No Attached Contract";
        } else {
            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            sTitle = "تسليم الوحدات";
            view = "عرض";
            project = "المشروع";
            unitCode = "رقم الوحدة";
            clientName = "اسم العميل";
            deliveryDateStr = "تاريخ التسليم";
            deliveryStatus = "حالة التسليم";
            contract = "العقد";
            noDateSpecified = "لم يتم تحديد موعد";
            delivered = "تم التسليم";
            toBeDelivered = "سيتم التسليم في تاريخ";
            noAttachedContract = "لا يوجد عقد مرفق";
        }
    %>
    <head>
        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/default/easyui.css"/>
        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/icon.css"/>
        <link rel="stylesheet" type="text/css" href="jquery-easyui/demo/demo.css"/>
        <link rel="stylesheet" type="text/css" href="js/jquery.datatables.css"/>
        <link rel="stylesheet" href="css/chosen.css"/>

        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" language="javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" language="javascript" src="jquery-ui/ui/jquery.effects.core.js"></script>
        <script type="text/javascript" src="jquery-easyui/easyloader.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <script src="js/chosen.jquery.js" type="text/javascript"></script>
        <script src="js/docsupport/prism.js" type="text/javascript" charset="utf-8"></script>
        <script type="text/javascript">
            var otable;
            var users = new Array();
            $(document).ready(function () {
                otable = $('#clients').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                    iDisplayLength: 25,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true

                }).fadeIn(2000);
            });

            function viewClientContract(clientID) {
                $.ajax({
                    type: "post",
                    url: "./EmailServlet?op=getContractID&clientID=" + clientID,
                    success: function (jsonString) {
                        if (jsonString !== '') {
                            var url = "<%=context%>/EmailServlet?op=viewDocument&docID=" + jsonString + "&docType=pdf";
                            window.open(url);
                        }
                    },
                    error: function () {
                        alert('لا يوجد عقد مرفق');
                    }
                });
            }
            function view(obj) {
                document.UNIT_FORM.action = "<%=context%>/SearchServlet?op=viewUnitDeliveryReport";
                document.UNIT_FORM.submit();
            }
            function printProjectInformation(mainProjID) {
                document.UNIT_FORM.action = "<%=context%>/SearchServlet?op=projectInformation&mainProjID=" + mainProjID;
                document.UNIT_FORM.submit();
            }
        </script>
        <style>
            input { font-size: 18px; }
            .table td{
                padding:5px;
                text-align:center;
                font-family:Georgia, "Times New Roman", Times, serif;
                font-size:14px;
                font-weight: bold;
                /*height:20px;*/
                border: none;
            }
        </style>
        <script src='ChangeLang.js' type='text/javascript'></script>
    </head>
    <body>
        <form name="UNIT_FORM" method="post">
            <fieldset class="set" style="width:85%;border-color: #006699" >
                <table align="center" width="100%" cellpadding="0" cellspacing="0">
                    <tr>
                        <td width="100%" class="titlebar">
                            <font color="#005599" size="4"><%=sTitle%></font>
                        </td>
                    </tr>
                </table>
                <br />
                <table align="center" dir="<%=dir%>" cellpadding="0" cellspacing="0" border="0" style="margin-right: auto;margin-left: auto; width: 400px;">
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" colspan="2">
                            <b>
                                <font size="3" color="white">
                                <%=project%>
                                </font>
                            </b>
                        </td>
                    </tr>
                    <tr>
                        <td style="border: none" width="70%">
                            <table width="100%" cellpadding="0" cellspacing="0" align="center">
                                <tr>
                                    <td style="<%=style%>" class='td' nowrap>
                                        <select name="projectID" id="projectID" style="width: 250px;" class="chosen-select-project">
                                            <sw:WBOOptionList wboList="<%=projectsLst%>" displayAttribute="projectName" valueAttribute="projectID" scrollToValue="<%=projectID%>" />
                                        </select>
                                    </td>
                                    <td style="<%=style%>" class='td' nowrap>
                                        <input type="button" value="<%=view%>" style="display: inline" class="" width="150px" onclick="view(this)"/>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
                <br />
                <br />
                <%
                    if (units != null) {
                %>
                <div style="width: 95%;margin-right: auto;margin-left: auto;" id="showClients">
                    <table align="<%=align%>" dir="<%=dir%>" width="100%" id="clients">
                        <thead>
                            <tr>
                                <th style="color: #005599 !important; font-weight: bold; width: 9%;"><%=unitCode%></th>
                                <th style="color: #005599 !important; font-weight: bold; width: 9%;"><%=clientName%></th>
                                <th style="color: #005599 !important; font-weight: bold; width: 9%;"><%=deliveryStatus%></th>
                                <th style="color: #005599 !important; font-weight: bold; width: 9%;"><%=deliveryDateStr%></th>
                                <th style="color: #005599 !important; font-weight: bold; width: 9%;"><%=contract%></th>
                            </tr>
                        <thead>
                        <tbody >
                            <%
                                String deliveryDate;
                                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                                for (WebBusinessObject wbo : units) {
                                    deliveryDate = wbo.getAttribute("deliveryDate") != null ? ((String) wbo.getAttribute("deliveryDate")).substring(0, 10) : "";
                            %>
                            <tr style="cursor: pointer" id="row">
                                <td>
                                    <%
                                        if (wbo.getAttribute("projectName") != null) {
                                    %>
                                    <a target="blank" href="<%=context%>/UnitDocWriterServlet?op=viewUnitData&projectId=<%=wbo.getAttribute("projectID")%>&searchBy=<%=request.getAttribute("searchBy")%>&searchValue=<%=request.getAttribute("searchValue")%>&ownerID=<%=wbo.getAttribute("ownerID")%>">
                                        <b><%=wbo.getAttribute("projectName")%></b>
                                    </a>
                                    <%
                                        }
                                    %>
                                </td>
                                <td>
                                    <a target="blank" href="<%=context%>/IssueServlet?op=newComplaint&type=call&clientId=<%=wbo.getAttribute("ownerID")%>&clientType=30-40">
                                        <b><%=wbo.getAttribute("clientName")%></b>
                                    </a>
                                    <a target="blank" href="<%=context%>/IssueServlet?op=newComplaint&type=call&clientId=<%=wbo.getAttribute("ownerID")%>&clientType=30-40">
                                        <img src="images/icons/eHR.gif" width="30" style="float: left;" title="Details"/>
                                    </a>
                                    <a target="blank" href="<%=context%>/ClientServlet?op=clientDetails&clientId=<%=wbo.getAttribute("ownerID")%>">
                                        <img src="images/client_details.jpg" width="30" style="float: left;" title="Client Data"/>
                                    </a>
                                </td>
                                <td>
                                    <%
                                        if (deliveryDate.isEmpty()) {
                                    %>
                                    <%=noDateSpecified%>
                                    <%
                                    } else if ((new Date()).after(sdf.parse(deliveryDate))) {
                                    %>
                                    <%=delivered%>
                                    <%
                                    } else {
                                    %>
                                    <%=toBeDelivered%>
                                    <%
                                        }
                                    %>
                                </td>
                                <td>
                                    <%=deliveryDate%>
                                </td>
                                <td style="text-align:center;padding: 5px; font-size: 12px;">
                                    <a href="JavaScript: <%=wbo.getAttribute("documentID") != null ? "viewClientContract('" + wbo.getAttribute("ownerID") + "')" : "alert('" + noAttachedContract + "')"%>;">
                                        <img src="images/<%=wbo.getAttribute("documentID") != null ? "contract_icon.jpg" : "no_contract.png"%>" style="height: 30px" title="<%=contract%>"/>
                                    </a>
                                </td>
                            </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                    <br />
                </div>
                <%
                    }
                %>
            </fieldset>
        </form>
        <script>
            var config = {
                '.chosen-select-project': {no_results_text: 'No project found with this name!'}
            };
            for (var selector in config) {
                $(selector).chosen(config[selector]);
            }
        </script>
    </body>
</html>
