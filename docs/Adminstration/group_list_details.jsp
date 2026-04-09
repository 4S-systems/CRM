<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<%@ page contentType="text/HTML; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8"%>

<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    Vector clients= (Vector) request.getAttribute("data");

        WebBusinessObject wbo = null;
   /*     
    //List<WebBusinessObject> clients = (List<WebBusinessObject>) request.getAttribute("clients");
    List<WebBusinessObject> usersList = (List<WebBusinessObject>) request.getAttribute("usersList");
    List<WebBusinessObject> distributionsList = (List<WebBusinessObject>) request.getAttribute("distributionsList");
    List<WebBusinessObject> salesEmployees = (List<WebBusinessObject>) request.getAttribute("salesEmployees");
    List<WebBusinessObject> campaignsList = (List<WebBusinessObject>) request.getAttribute("campaignsList");
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
    String status = (String) request.getAttribute("status");*/
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
        <link href="js/select2.min.css" rel="stylesheet">

        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/default/easyui.css">
        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/icon.css">
        <link rel="stylesheet" type="text/css" href="jquery-easyui/demo/demo.css">
        <script type="text/javascript" src="jquery-easyui/easyloader.js"></script>
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
                
                $("#clientsssss").dataTable({
                    "bJQueryUI": true,
                    "destroy": true,
                    "aLengthMenu": [[10, 25, 50, 100, -1], [10, 25, 50, 100, "All"]],
                    //"order": [[ 8, "asc" ]],
                    "order": [[ 0, "asc" ]],
                    "columnDefs": [
                        {
                            "targets": 0,
                            "visible": false
                        }, {
                            "targets": [1,2],
                            "orderable": false
                        }],
                    "drawCallback": function (settings) {
                        var api = this.api();
                        var rows = api.rows({page: 'current'}).nodes();
                        var last = null;
                        //api.column(8, {page: 'current'}).data().each(function (group, i) {
                        api.column(0, {page: 'current'}).data().each(function (group, i) {
                            if (last !== group) {
                                $(rows).eq(i).before(
                                        //'<tr class="group"><td class="blueBorder blueBodyTD" style="font-size: 14px; background-color: lightgray;" colspan="4">المجموعة</td><td class="blueBorder blueBodyTD" style="font-size: 16px;" colspan="4">'
                                        //+ group + '</td><td class="blueBorder blueBodyTD" colspan="2"></td></tr>'
                                        '<tr class="group"><td class="blueBorder blueBodyTD" style="font-size: 14px; background-color: lightgray;" >المجموعة</td><td class="blueBorder blueBodyTD" style="font-size: 16px; background-color: lightgray;">'
                                        + group + '</td><td class="blueBorder blueBodyTD" ></td></tr>'
                                        );
                                last = group;
                            }
                        });
                    }
                }).fadeIn(2000);
            });

            function distribution(mode) {
                $("#manualBTN").attr("disabled", "true");
                $("#autoBtn").attr("disabled", "true");
                var employeeId = document.getElementById('employeeId').value;
                document.UNHANDLED_CLIENT_FORM.action = "<%=context%>/AutoPilotModeServlet?op=distributeLeadCustomers&employeeId=" + employeeId + "&mode=" + mode + "&fromURL=unHandledClients";
                document.UNHANDLED_CLIENT_FORM.submit();
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
        </script>
    </head>

    <body>

        <fieldset class="set" style="border-color: #006699; width: 90%;margin-top: 10px;border-radius: 5px;">
            <form name="SEARCH_CLIENT_FORM" action="<%=context%>/ClientServlet?op=unHandledClients" method="POST">
                <%--<table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <tr>
                        <td width="100%" class="titlebar">
                            <font color="#005599" size="4">توزيع عملاء الحملة</font>
                        </td>
                    </tr>
                </table>
                <br/>
                <%
                  //  if ("saved".equalsIgnoreCase(status)) {
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
                //    }
                %>
                <table ALIGN="center" DIR="RTL" WIDTH="75%" CELLSPACING=2 CELLPADDING=1>
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="27%">
                            <b><font size=3 color="white">من تاريخ</b>
                        </td>
                        <td   class="blueBorder blueHeaderTD" style="font-size:18px;"WIDTH="27%">
                            <b> <font size=3 color="white">إلي تاريخ</b>
                        </td>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="27%">
                            <b><font size=3 color="white">Hash Tag</b>
                        </td>
                        <td STYLE="text-align:center" bgcolor="#dedede" rowspan="4" WIDTH="20%">  
                            <button type="submit" onclick="JavaScript: search();"  STYLE="color: #000;font-size:15px;margin-top: 20px;font-weight:bold; width: 70%; ">بحث<IMG HEIGHT="15" SRC="images/search.gif" ></button>
                        </td>
                    </tr>--%>
                <%--<tr>
                        <td style="text-align:center" bgcolor="#dedede"  valign="MIDDLE">
                            <%--  <input id="beginDate" name="beginDate" type="text" value="<%=beginDate%>">--%>
                            <%--        <br/><br/>
                        </td>
                        <td  bgcolor="#dedede"  style="text-align:center" valign="middle">
                           <%-- <input id="endDate" name="endDate" type="text" value="<%=endDate%>" >--%>
                           <%--   <br/><br/>
                        </td>
                        <td style="text-align:center" bgcolor="#dedede" valign="MIDDLE">
                           <%-- <input id="description" name="description" type="text" value="<%=description%>" />--%>
                           <%--<br/><br/>
                        </td
                   <%-- </tr>
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="27%">
                            <b><font size=3 color="white">المصدر</b>
                        </td>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="27%">
                            <b><font size=3 color="white">الحملة</b>
                        </td>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="27%">
                            <b><font size=3 color="white">نوع العميل</b>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align:center" bgcolor="#dedede" valign="MIDDLE">
                            <select style="font-size: 14px;font-weight: bold; width: 170px;" id="createdBy" name="createdBy" >
                                <option value="">الكل</option>
                                <%--  <sw:WBOOptionList wboList='<%=usersList%>' displayAttribute="fullName" valueAttribute="userId" scrollToValue="<%=createdBy%>"/>--%>
                                <%-- </select>
                            <br/><br/>
                        </td>
                        <td style="text-align:center" bgcolor="#dedede" valign="MIDDLE">
                            <select style="font-size: 14px;font-weight: bold; width: 170px;" id="campaignID" name="campaignID" >
                                <option value="">الكل</option>
                                <%--<sw:WBOOptionList wboList='<%=campaignsList%>' displayAttribute="campaignTitle" valueAttribute="id" scrollToValue="<%=campaignID%>"/>--%>
                                <%--    </select>
                            <br/><br/>
                        </td>
                        <td style="text-align:center" bgcolor="#dedede" valign="MIDDLE">
                            <select style="font-size: 14px;font-weight: bold; width: 170px;" name="clientType" >
                                <option value="">الكل</option>
                                <%--<option value="11" <%="11".equals(clientType) ? "selected" : ""%>>Customer</option>
                                <option value="12" <%="12".equals(clientType) ? "selected" : ""%>>Lead</option>--%>
                                <%--    </select>
                            <br/><br/>
                        </td>
                    </tr>
                </table>
            </form>
            <br/>--%>
            <form name="UNHANDLED_CLIENT_FORM" method="POST">
                <%if (!clients.isEmpty()) {%>
                <%-- <table ALIGN="center" DIR="RTL" bgcolor="#dedede" WIDTH="85%" CELLSPACING=2 CELLPADDING=1>
                    <tr>
                        <td style="font-size:18px; text-align: right" WIDTH="50%">
                            <button id="autoBtn" type="button" onclick="JavaScript: distribution('auto');" value="" style="margin-left: 5%; text-align: center; width: 150px; font-size: 16px; color: blue; font-weight: bold;">
                                Auto-Pilot
                                <img src="images/icons/plane_icon.png" height="24" width="24" alt="distribute client" style="vertical-align: middle" />
                            </button>
                        </td>
                        <td style="font-size:18px; text-align: left; border-left-width: 0px" WIDTH="20%">
                            <button id="manualBTN" type="button" onclick="JavaScript: distribution('manual');" value="" style="margin-left: 5%; text-align: center; width: 150px; font-size: 16px; color: blue; font-weight: bold;">
                                Manual
                                <img src="images/icons/manual_pilot.png" height="24" width="24" alt="distribute client" style="vertical-align: middle" />
                            </button>
                        </td>
                        <td style="font-size:16px; color: blue; text-align: right; border-right-width: 0px; border-left-width: 0px" WIDTH="20%">
                            <select name="employeeId" id="employeeId" style="font-size: 14px;font-weight: bold; width: 99%; height: 25px">
                                <%--<sw:WBOOptionList wboList='<%=distributionsList%>' displayAttribute="fullName" valueAttribute="userId"/>--%>
                                <%--    </select>
                            <select name="employeeId" id="salesEmployeeId" style="font-size: 14px;font-weight: bold; width: 99%; height: 25px; display: none">
                               <%-- <sw:WBOOptionList wboList='<%=salesEmployees%>' displayAttribute="fullName" valueAttribute="userId"/>--%>
                               <%--     </select>
                        </td>
                    </tr>
                </table>--%>
                <br>
                <br>
                <%}%>
                <div style="width: 99%;margin-right: auto;margin-left: auto;" id="showClients">
                <TABLE style="display" id="clientsssss" ALIGN="center" dir="rtl" WIDTH="100%" CELLPADDING="0" CELLSPACING="0" STYLE="border: 2px solid #d3d5d4;">
                    <thead>                
                        <tr>
                           <%-- <th STYLE="text-align:center; color:white; font-size:14px">
                                <input type="checkbox" name="checkAll" onchange="selectAll(this);"/>
                            </th>
                            <th STYLE="text-align:center; font-size:14px"><b>م</b></th>--%>
                            <th STYLE="text-align:center; font-size:14px"><b>  المجموعة</b></th>
                            <th STYLE="text-align:center; font-size:14px"><b>إسم العميل</b></th>
                            <th STYLE="text-align:center; font-size:14px"><b>المجموعة</b></th>
                            <%--<th STYLE="text-align:center; font-size:14px"><b>رقم الموبايل</b></th>
                            <th STYLE="text-align:center; font-size:14px"><b>رقم التليفون</b></th>
                            <th STYLE="text-align:center; font-size:14px"><b>البريد الإلكترونى</b></th>
                            <th STYLE="text-align:center; font-size:14px"><b>المصدر</b></th>
                            <th STYLE="text-align:center; font-size:14px"><b>تاريخ الأدخال</b></th>--%>
                        </tr>
                    </thead>
                    <tbody>
                        <%  int counter = 0;
                            String clazz = "";
                            String creationTime = "";
                            Enumeration e = clients.elements();
                            while(e.hasMoreElements()){
                            //for (WebBusinessObject wbo : clients) {
//                                if ((counter % 2) == 1) {
//                                    clazz = "silver_odd_main";
//                                } else {
//                                    clazz = "silver_even_main";
//                                }
                                counter++;
                               // if(wbo.getAttribute("creationTime") != null) {
                               //     creationTime = ((String) wbo.getAttribute("creationTime"));
                                //    creationTime = creationTime.substring(0, 16);
                                //}
                            wbo = (WebBusinessObject) e.nextElement();
                        %>
                        <tr class="<%=clazz%>" style="cursor: pointer" onMouseOver="this.className = ''" onMouseOut="this.className = '<%=clazz%>'">
                            <%--<TD STYLE="text-align: center; width: 5%" nowrap>
                                <DIV>                   
                                    <%-- <input type="checkbox" name="customerId" value="<%=(String) wbo.getAttribute("id")%>" />--%>
                             <%--   </DIV>
                            </TD>
                            <TD STYLE="text-align: center; width: 5%" nowrap>
                                <DIV>                   
                                    <b><%=counter%></b>
                                </DIV>
                            </TD>--%>
                            <TD STYLE="text-align: center" nowrap>
                                <DIV>
                                    <%--  <b> <%=wbo.getAttribute("campaigntittle")%></b>--%>
                                    <%=wbo.getAttribute("groupName")%>
                                </DIV>
                            </TD>
                            <TD STYLE="text-align: center" nowrap>
                                <DIV>                           
                                    <%--     <b><%=wbo.getAttribute("name")%></b>--%>
                                    <%=wbo.getAttribute("userName")%>
                                </DIV>
                            </TD>
                            <TD STYLE="text-align: center" nowrap>
                                <DIV>                  
                                    <%--  <b style="color: <%="lead".equals(wbo.getAttribute("statusNameEn")) ? "red" : "black"%>;"><%=wbo.getAttribute("statusNameEn")%></b>--%>
                                </DIV>
                            </TD>
                            <%--<TD STYLE="text-align: center" nowrap>
                                <DIV>                   
                                    <%--  <b><%=(wbo.getAttribute("mobile") != null ? wbo.getAttribute("mobile") : "")%></b>--%>
                            <%--    </DIV>
                            </TD>
                            <TD STYLE="text-align: center" nowrap>
                                <DIV>                   
                                    <%--    <b><%=(wbo.getAttribute("phone") != null ? wbo.getAttribute("phone") : "")%></b>--%>
                            <%--    </DIV>
                            </TD>
                            <TD STYLE="text-align: center">
                                <DIV>                   
                                    <%--     <b><%=(wbo.getAttribute("email") != null) ? wbo.getAttribute("email") : ""%></b>--%>
                            <%--    </DIV>
                            </TD>
                            <TD STYLE="text-align: center" nowrap>
                                <DIV>                           
                                    <%--   <b><%=wbo.getAttribute("createdByName") != null ? wbo.getAttribute("createdByName") : ""%></b>--%>
                            <%--    </DIV>
                            </TD>
                            <TD STYLE="text-align: center" nowrap>
                                <DIV>                           
                                    <%-- <b><%=creationTime%></b>--%>
                            <%--    </DIV>
                            </TD>--%>
                        </tr>
                        <%}%>
                    </tbody>
                </table>
                </div>
                <br/>
                <br/>
            </form>
        </fieldset>
    </body>
</html>
