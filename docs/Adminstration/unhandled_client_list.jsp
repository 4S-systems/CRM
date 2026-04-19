<%-- 
    Document   : Unhandled_Client_List
    Created on : Oct 7, 2014, 12:46:07 PM
    Author     : walid
--%>


<%@page import="java.util.Vector"%>
<%@page import="com.maintenance.db_access.GroupPrevMgr"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<!DOCTYPE html>
<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    List<WebBusinessObject> clients = (List<WebBusinessObject>) request.getAttribute("clients");
    List<WebBusinessObject> usersList = (List<WebBusinessObject>) request.getAttribute("usersList");
    List<WebBusinessObject> distributionsList = (List<WebBusinessObject>) request.getAttribute("distributionsList");
    List<WebBusinessObject> salesEmployees = (List<WebBusinessObject>) request.getAttribute("salesEmployees");
    List<WebBusinessObject> campaignsList = (List<WebBusinessObject>) request.getAttribute("campaignsList");
    ArrayList<WebBusinessObject> requestTypes = (ArrayList<WebBusinessObject>) request.getAttribute("requestTypes");
    ArrayList<WebBusinessObject> projectsList = (ArrayList<WebBusinessObject>) request.getAttribute("projectsList");
    ArrayList<WebBusinessObject> departments = (ArrayList<WebBusinessObject>) request.getAttribute("departments");
    List<String> usersIDsList = (List<String>) request.getAttribute("usersIDsList");
    String beginDate = "";
    if (request.getAttribute("beginDate") != null) {
        beginDate = (String) request.getAttribute("beginDate");
    }
    String endDate = "";
    if (request.getAttribute("endDate") != null) {
        endDate = (String) request.getAttribute("endDate");
    }
    String description = "";
    if (request.getAttribute("description") != null) {
        description = (String) request.getAttribute("description");
    }
    String createdBy = "";
    if (request.getAttribute("createdBy") != null) {
        createdBy = (String) request.getAttribute("createdBy");
    }
    String campaignID = "";
    if (request.getAttribute("campaignID") != null) {
        campaignID = (String) request.getAttribute("campaignID");
    }
    String clientType = "";
    if (request.getAttribute("clientType") != null) {
        clientType = (String) request.getAttribute("clientType");
    }
    String phoneNo = "";
    if (request.getAttribute("phoneNo") != null) {
        phoneNo = (String) request.getAttribute("phoneNo");
    }
    String projectID = "";
    if (request.getAttribute("projectID") != null) {
        projectID = (String) request.getAttribute("projectID");
    }
    String preDepartmentID = "";
    if (request.getAttribute("preDepartmentID") != null) {
        preDepartmentID = (String) request.getAttribute("preDepartmentID");
    }
    String status = (String) request.getAttribute("status");
    
    WebBusinessObject userWbo = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
    GroupPrevMgr groupPrevMgr = GroupPrevMgr.getInstance();
    Vector groupPrev = groupPrev = groupPrevMgr.getOnArbitraryKey(userWbo.getAttribute("groupID").toString(), "key1");
    ArrayList<String> userPrevList = new ArrayList<String>();
    WebBusinessObject wboo;
    for (int i = 0; i < groupPrev.size(); i++) {
	wboo = (WebBusinessObject) groupPrev.get(i);
	userPrevList.add((String) wboo.getAttribute("prevCode"));
    }
            String stat = (String) request.getSession().getAttribute("currentMode");
            String align, dir, style,Requesttype,search,Distributecampaigncustomers,all,cam,clientname,clientstatus,InternationalNumber,Phone,Email,EntryDate,fromdate, todate, mobilecLIENT, Managment, Resource, Project, ClientType;
        if (stat.equals("En")) {
            align = "center";
            dir = "LTR";
            style = "text-align:left";
            Distributecampaigncustomers = "Distribute Clients";
            search = "search";
            Requesttype = "Request Type";
            cam = "Campaign";
            all = "All";
            fromdate = "From Date";
            todate = "To Date";
            mobilecLIENT = "Mobile";
            Managment = "Managment";
            Resource = "Resource";
            Project = "Project";
            ClientType = "Client Type";
            clientname = "Client Name";
            clientstatus = "Client Status";
            InternationalNumber ="International Number";
            Phone = "Phone";
            Email = "Email";
            EntryDate = "Entry Date";
        } else {
            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            cam = "الحمله";
            Requesttype = "نوع الطلب";
            all = "الكل";
            fromdate = "من تاريخ";
            todate = "الى تاريخ";
            mobilecLIENT = "موبايل";
            Managment = "الاداره";
            Resource = "المصدر";
            Project = "المشروع";
            ClientType = "نوع العميل";
            clientname = "اسم العميل";
            clientstatus = "حاله العميل";
            InternationalNumber ="الرقم الدولى";
            Phone = "التليفون";
            Email = "الايميل";
            EntryDate = "تاريخ الادخال";
            Distributecampaigncustomers = "توزيع عملاء الحملة";
            search = "بحث";
            
        }

%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>

        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" language="javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" language="javascript" src="jquery-ui/ui/jquery.effects.core.js"></script>
        <script src="js/select2.min.js"></script>
        <script src="js/chosen.jquery.js" type="text/javascript"></script>
        <script src="js/docsupport/prism.js" type="text/javascript" charset="utf-8"></script>
        <link href="js/select2.min.css" rel="stylesheet">

        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/default/easyui.css">
        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/icon.css">
        <link rel="stylesheet" type="text/css" href="jquery-easyui/demo/demo.css">
        <script type="text/javascript" src="jquery-easyui/easyloader.js"></script>
        <link rel="stylesheet" href="css/chosen.css"/>
        <style type="text/css">
            .titlebar {
                background-image: url(images/title_bar.png);
                background-position-x: 50%;
                background-position-y: 50%;
                background-size: initial;
                background-repeat-x: repeat;
                background-repeat-y: no-repeat;
                background-attachment: initial;
                background-origin: initial;
                background-clip: initial;
                background-color: rgb(204, 204, 204);
            }
        </style>
        <script  type="text/javascript">
            function selectAll(obj) {
                $("input[name='customerId']").prop('checked', $(obj).is(':checked'));
            }
            $(function() {
                $("#beginDate, #endDate").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    maxDate: 0,
                    dateFormat: "yy/mm/dd"
                });
            });
            $(document).ready(function () {
                $("#createdBy").select2();
                
                $("#campaignID").select2();
                
                $("#usrID").select2();
                
                $("#clientsssss").dataTable({
                    "bJQueryUI": true,
                    "destroy": true,
                    "aLengthMenu": [[10, 25, 50, 100, -1], [10, 25, 50, 100, "All"]],
                    "order": [[ 8, "asc" ]],
                    "drawCallback": function (settings) {
                        var api = this.api();
                        var rows = api.rows({page: 'current'}).nodes();
                        var last = null;
                        api.column(8, {page: 'current'}).data().each(function (group, i) {
                            if (last !== group) {
                                $(rows).eq(i).before(
                                        '<tr class="group"><td class="blueBorder blueBodyTD" style="font-size: 14px; background-color: lightgray;" colspan="3"><%=Resource%></td><td class="blueBorder blueBodyTD" style="font-size: 16px;" colspan="4">'
                                        + group + '</td><td class="blueBorder blueBodyTD" colspan="3"></td></tr>'
                                        );
                                last = group;
                            }
                        });
                    }
                }).fadeIn(2000);
            });

            function distribution(mode) {
                if (!validateData("req", document.UNHANDLED_CLIENT_FORM.requestType, "من فضلك اختار نوع الطلب...")) {
                    $("#requestType").focus();
                } else {
                    $("#manualBTN").attr("disabled", "true");
                    $("#autoBtn").attr("disabled", "true");
                    var loggedOnly = $("#loggedOnly").is(":checked");
                    document.UNHANDLED_CLIENT_FORM.action = "<%=context%>/AutoPilotModeServlet?op=distributeLeadCustomers&mode=" + mode + "&fromURL=unHandledClients" + "&loggedOnly=" + loggedOnly
                    + "&requestType=" + $("#requestType").val();
                    document.UNHANDLED_CLIENT_FORM.submit();
                }
            }
	    
	    function deleteClients() {
		 if ($("input[name=customerId]:checked").length <= 0 ) {
                    alert(" Choose At Least One Client To Delete ");
                } else {
		    document.UNHANDLED_CLIENT_FORM.action = "<%=context%>/ClientServlet?op=deleteClients";
		    document.UNHANDLED_CLIENT_FORM.submit();
		}

	    }

            function salesEmployeeBox() {
                if (document.getElementById('salesEmployee').checked === true) {
                    document.getElementById('salesEmployeeId').style.display = "block";
                    document.getElementById('employeeId').style.display = "none";
                } else {
                    document.getElementById('salesEmployeeId').style.display = "none";
                    document.getElementById('employeeId').style.display = "block";
                }
            }
            function getProjects(obj) {
                $.ajax({
                    type: "post",
                    url: '<%=context%>/CampaignServlet?op=getProjectsAjax',
                    data: {
                        campaignID: $(obj).val()
                    },
                    success: function (dataStr) {
                        var result = $.parseJSON(dataStr);
                        var options = [];
                        options.push("<option value=''>", "الكل", "</option>");
                        try {
                            $.each(result, function () {
                                if (this.projectName) {
                                    options.push('<option value="', this.projectID, '">', this.projectName, '</option>');
                                }
                            });
                        } catch (err) {
                        }
                        $("#projectID").html(options.join(''));
                    }
                });
            }
            function openWindow(url) {
                window.open(url, "_blank", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=no, copyhistory=no, width=700, height=600");
            }
            function updateClientInformation(clientID) {
                var url = "<%=context%>/ClientServlet?op=getUpdateClientForm&clientId=" + clientID;
                openWindow(url);
            }
        </script>
    </head>

    <body>

        <fieldset class="set" style="border-color: #006699; width: 90%;margin-top: 10px;border-radius: 5px;">
            <form name="SEARCH_CLIENT_FORM" action="<%=context%>/ClientServlet?op=unHandledClients" method="POST">
                <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <tr>
                        <td width="100%" class="titlebar">
                            <font color="#005599" size="4"><%=Distributecampaigncustomers%></font>
                        </td>
                    </tr>
                </table>
                <br/>
                <%
                    if ("saved".equalsIgnoreCase(status)) {
                %>
                <table>
                    <tr>
                        <td class="td"> 
                            <b>
                                <font size="4" style="color: green;">
                                تم الحفظ بنجاح
                                </font>
                            </b>
                        </td>
                    </tr>
                </table>
                <br/>
                <%
                    }
                %>
                <table ALIGN="center" DIR="RTL" WIDTH="75%" CELLSPACING=2 CELLPADDING=1>
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="22%">
                            <b><font size=3 color="white"><%=fromdate%></b>
                        </td>
                        <td   class="blueBorder blueHeaderTD" style="font-size:18px;"WIDTH="22%">
                            <b> <font size=3 color="white"><%=todate%></b>
                        </td>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="22%">
                            <b><font size=3 color="white">Hash Tag</b>
                        </td>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="22%">
                            <b><font size=3 color="white"><%=mobilecLIENT%></b>
                        </td>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="22%">
                            <b><font size=3 color="white"><%=Managment%></b>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align:center" bgcolor="#dedede"  valign="MIDDLE">
                            <input id="beginDate" name="beginDate" type="text" value="<%=beginDate%>">
                            <br/><br/>
                        </td>
                        <td  bgcolor="#dedede"  style="text-align:center" valign="middle">
                            <input id="endDate" name="endDate" type="text" value="<%=endDate%>" >
                            <br/><br/>
                        </td>
                        <td style="text-align:center" bgcolor="#dedede" valign="MIDDLE">
                            <input id="description" name="description" type="text" value="<%=description%>" />
                            <br/><br/>
                        </td>
                        <td style="text-align:center" bgcolor="#dedede" valign="MIDDLE">
                            <input id="phoneNo" name="phoneNo" type="text" value="<%=phoneNo%>" />
                            <br/><br/>
                        </td>
                        <td style="text-align:center" bgcolor="#dedede" valign="MIDDLE">
                            <select id="preDepartmentID" name="preDepartmentID" style="font-size: 14px; font-weight: bold; width: 170px;">
                                <option value=""><%=all%></option>
                                <sw:WBOOptionList wboList="<%=departments%>" displayAttribute="projectName" valueAttribute="projectID" scrollToValue="<%=preDepartmentID%>" />
                            </select>
                            <br/><br/>
                        </td>
                    </tr>
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;">
                            <b><font size=3 color="white"><%=Resource%></b>
                        </td>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;">
                            <b><font size=3 color="white"><%=cam%></b>
                        </td>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;">
                            <b><font size=3 color="white"><%=Project%></b>
                        </td>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;">
                            <b><font size=3 color="white"><%=ClientType%></b>
                        </td>
                        <td STYLE="text-align:center" bgcolor="#dedede" rowspan="2">  
                            <button type="submit" onclick="JavaScript: search();"  STYLE="color: #27272A;font-size:15px;margin-top: 20px;font-weight:bold; width: 70%; "><%=search%><IMG HEIGHT="15" SRC="images/search.gif" ></button>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align:center" bgcolor="#dedede" valign="MIDDLE">
                            <select style="font-size: 14px;font-weight: bold; width: 170px;" id="createdBy" name="createdBy" >
                                <option value=""><%=all%></option>
                                <sw:WBOOptionList wboList='<%=usersList%>' displayAttribute="fullName" valueAttribute="userId" scrollToValue="<%=createdBy%>"/>
                            </select>
                            <br/><br/>
                        </td>
                        <td style="text-align:center" bgcolor="#dedede" valign="MIDDLE">
                            <select style="font-size: 14px;font-weight: bold; width: 170px;" id="campaignID" name="campaignID" 
                                    onchange="JavaScript: getProjects(this);">
                                <option value=""><%=all%></option>
                                <sw:WBOOptionList wboList='<%=campaignsList%>' displayAttribute="campaignTitle" valueAttribute="id" scrollToValue="<%=campaignID%>"/>
                            </select>
                            <br/><br/>
                        </td>
                        <td style="text-align:center" bgcolor="#dedede" valign="MIDDLE">
                            <select style="font-size: 14px;font-weight: bold; width: 170px;" id="projectID" name="projectID" >
                                <option value=""><%=all%></option>
                                <sw:WBOOptionList wboList='<%=projectsList%>' displayAttribute="projectName" valueAttribute="projectID" scrollToValue="<%=projectID%>"/>
                            </select>
                            <br/><br/>
                        </td>
                        <td style="text-align:center" bgcolor="#dedede" valign="MIDDLE">
                            <select style="font-size: 14px;font-weight: bold; width: 170px;" name="clientType" >
                                <option value=""><%=all%></option>
                                <option value="11" <%="11".equals(clientType) ? "selected" : ""%>>Customer</option>
                                <option value="12" <%="12".equals(clientType) || request.getAttribute("clientType") == null ? "selected" : ""%>>Lead</option>
                            </select>
                            <br/><br/>
                        </td>
                    </tr>
                </table>
            </form>
            <br/>
            <form name="UNHANDLED_CLIENT_FORM" method="POST">
                <%if (!clients.isEmpty()) {%>
                <table ALIGN="center" DIR="RTL" bgcolor="#dedede" WIDTH="85%" CELLSPACING=2 CELLPADDING=1>
                    <tr>
                        <td style="font-size:18px; text-align: right;" WIDTH="33%">
                            <button id="autoBtn" type="button" onclick="JavaScript: distribution('auto');" value="" style="margin-left: 5%; text-align: center; width: 150px; font-size: 16px; color: blue; font-weight: bold; display: none;">
                                Auto-Pilot
                                <img src="images/icons/plane_icon.png" height="24" width="24" alt="distribute client" style="vertical-align: middle" />
                            </button>
                            <input type="checkbox" id="loggedOnly" value="1" style="display: none;"/> <span style="display: none;">Logged Only</span>
                        </td>
                        <td style="font-size:18px; text-align: right;" WIDTH="56%">
                            <select name="requestType" id="requestType" style="width: 30%; font-size: 18px;">
                                <option value="" style="color: blue;"><%=Requesttype%></option>
                                <sw:WBOOptionList wboList="<%=requestTypes%>" displayAttribute="projectName" valueAttribute="projectName" />
                            </select>
                            <select name="employeeId" id="employeeId" style="font-size: 14px;font-weight: bold; width: 30%; height: 25px" class="chosen-select-employee" multiple>
                                <%
                                    for (WebBusinessObject userWboo : distributionsList) {
                                %>
                                <option value="<%=userWboo.getAttribute("userId")%>" style="<%=usersIDsList.contains(userWboo.getAttribute("userId")) ? "color: red; font-weight: bold;" : ""%>"><%=userWboo.getAttribute("fullName")%></option>
                                <%
                                    }
                                %>
                            </select>
                            <select name="salesEmployeeId" id="salesEmployeeId" style="font-size: 14px;font-weight: bold; width: 30%; height: 25px; display: none">
                                <sw:WBOOptionList wboList='<%=salesEmployees%>' displayAttribute="fullName" valueAttribute="userId"/>
                            </select>
                            <button id="manualBTN" type="button" onclick="JavaScript: distribution('manual');" value="" style="margin-left: 5%; text-align: center; width: 30%; font-size: 16px; color: blue; font-weight: bold;">
                                Manual
                                <img src="images/icons/manual_pilot.png" height="24" width="24" alt="distribute client" style="vertical-align: middle" />
                            </button>
                        </td>
			<td style="font-size:14px; text-align: center; display: <%=userPrevList.contains("DELETE_CLIENT") ? "block" : "none"%> " WIDTH="10%">
                            <button id="manualBTN" type="button" onclick="JavaScript: deleteClients('manual');" value="" style="margin-left: 5%; text-align: center; width: 90%; font-size: 16px; color: blue; font-weight: bold;">
                                Delete
                            </button>
                        </td>
                    </tr>
                </table>
                <br>
                <br>
                <%}%>
                <div style="width: 99%;margin-right: auto;margin-left: auto;" id="showClients">
                <TABLE style="display" id="clientsssss" ALIGN="center" dir="rtl" WIDTH="100%" CELLPADDING="0" CELLSPACING="0" STYLE="border: 2px solid #d3d5d4;">
                    <thead>                
                        <tr>
                            <th STYLE="text-align:center; color:white; font-size:14px">
                                <input type="checkbox" name="checkAll" onchange="selectAll(this);"/>
                            </th>
                            <th STYLE="text-align:center; font-size:14px"><b>م</b></th>
                            <th STYLE="text-align:center; font-size:14px; width: 290px;"><b><%=clientname%></b></th>
                            <th STYLE="text-align:center; font-size:14px"><b><%=clientstatus%></b></th>
                            <th STYLE="text-align:center; font-size:14px"><b><%=mobilecLIENT%></b></th>
                            <th STYLE="text-align:center; font-size:14px"><b><%=InternationalNumber%></b></th>
                            <th STYLE="text-align:center; font-size:14px"><b><%=Phone%></b></th>
                            <th STYLE="text-align:center; font-size:14px"><b><%=Email%></b></th>
                            <th STYLE="text-align:center; font-size:14px"><b><%=Resource%></b></th>
                            <th STYLE="text-align:center; font-size:14px"><b><%=EntryDate%></b></th>
                        </tr>
                    </thead>
                    <tbody>
                        <%  int counter = 0;
                            String clazz = "";
                            String creationTime = "";
                            boolean isMobileValid;
                            String mobile;
                            for (WebBusinessObject wbo : clients) {
//                                if ((counter % 2) == 1) {
//                                    clazz = "silver_odd_main";
//                                } else {
//                                    clazz = "silver_even_main";
//                                }
                                counter++;
                                if(wbo.getAttribute("creationTime") != null) {
                                    creationTime = ((String) wbo.getAttribute("creationTime"));
                                    creationTime = creationTime.substring(0, 16);
                                }
                                isMobileValid = false;
                                mobile = (String) wbo.getAttribute("mobile");
                                if (mobile != null && mobile.length() == 11) {
                                    try {
                                        if (Long.parseLong(mobile) > 0) {
                                            isMobileValid = true;
                                        }
                                    } catch (NumberFormatException nfe) {

                                    }
                                }
                        %>
                        <tr class="<%=clazz%>" style="cursor: pointer; background-color: <%=isMobileValid ? "" : "#fed8d6"%>;" onMouseOver="this.className = ''" onMouseOut="this.className = '<%=clazz%>'">
                            <TD STYLE="text-align: center; width: 5%" nowrap>
                                <DIV>                   
                                    <input type="checkbox" name="customerId" value="<%=(String) wbo.getAttribute("id")%>" />
                                </DIV>
                            </TD>
                            <TD STYLE="text-align: center; width: 5%" nowrap>
                                <DIV>                   
                                    <b><%=counter%></b>
                                </DIV>
                            </TD>
                            <TD STYLE="text-align: center" nowrap>
                                <DIV>                           
                                    <b><%=wbo.getAttribute("name")%></b>
                                    <%
                                        if (!isMobileValid) {
                                    %>
                                    <img src="images/user_male_edit.png" style="width: 20px; float: left;" title="تعديل بيانات العميل"
                                         onclick="JavaScript: updateClientInformation('<%=wbo.getAttribute("id")%>');"/>
                                    <%
                                        }
                                    %>
                                </DIV>
                            </TD>
                            <TD STYLE="text-align: center" nowrap>
                                <DIV>                  
                                    <b style="color: <%="lead".equals(wbo.getAttribute("statusNameEn")) ? "red" : "black"%>;"><%=wbo.getAttribute("statusNameEn")%></b>
                                </DIV>
                            </TD>
                            <TD STYLE="text-align: center" nowrap>
                                <DIV>                   
                                    <b><%=(wbo.getAttribute("mobile") != null && !"UL".equals(wbo.getAttribute("mobile")) ? wbo.getAttribute("mobile") : "")%></b>
                                </DIV>
                            </TD>
                            <TD STYLE="text-align: center" nowrap>
                                <DIV>                   
                                    <b><%=(wbo.getAttribute("interPhone") != null && !"UL".equals(wbo.getAttribute("interPhone")) ? wbo.getAttribute("interPhone") : "")%></b>
                                </DIV>
                            </TD>
                            <TD STYLE="text-align: center" nowrap>
                                <DIV>                   
                                    <b><%=(wbo.getAttribute("phone") != null && !"UL".equals(wbo.getAttribute("phone")) ? wbo.getAttribute("phone") : "")%></b>
                                </DIV>
                            </TD>
                            <TD STYLE="text-align: center">
                                <DIV>                   
                                    <b><%=(wbo.getAttribute("email") != null) ? wbo.getAttribute("email") : ""%></b>
                                </DIV>
                            </TD>
                            <TD STYLE="text-align: center" nowrap>
                                <DIV>                           
                                    <b><%=wbo.getAttribute("createdByName") != null ? wbo.getAttribute("createdByName") : ""%></b>
                                </DIV>
                            </TD>
                            <TD STYLE="text-align: center" nowrap>
                                <DIV>                           
                                    <b><%=creationTime%></b>
                                </DIV>
                            </TD>
                        </tr>
                        <%}%>
                    </tbody>
                </table>
                </div>
                <br/>
                <br/>
            </form>
        </fieldset>
        <script>
            var config = {
                '.chosen-select-employee': {no_results_text: 'No employee found with this name!'},
            };
            for (var selector in config) {
                $(selector).chosen(config[selector]);
            }
        </script>
    </body>
</html>
