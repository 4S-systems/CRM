<%-- 
    Document   : Unhandled_Client_List
    Created on : Oct 7, 2014, 12:46:07 PM
    Author     : walid
--%>

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
    ArrayList<WebBusinessObject> requestTypes = (ArrayList<WebBusinessObject>) request.getAttribute("requestTypes");
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
    String clientTyp = "";
    if (request.getAttribute("clientTyp") != null) {
        clientTyp = (String) request.getAttribute("clientTyp");
    }
    String phoneNo = "";
    if (request.getAttribute("phoneNo") != null) {
        phoneNo = (String) request.getAttribute("phoneNo");
    }
    String status = (String) request.getAttribute("status");

    String cMode = (String) request.getSession().getAttribute("currentMode");
    String stat = cMode;
    String align = "center";
    String call_number, client_ssn, client_total_salary, regist;
    String interPhone;
    String style = null;
    String arName,regionName;
    String automated;
    String fStatus;
    String sStatus, msgErrorExtConn,dir, birthDate, search, add, back, area,fromDate,toDate,
            clientNo,clientName,clientStatus,total;
    
    if (stat.equals("En")) {

        style = "left";
        dir = "LTR";
        client_ssn = "UnDistributed Clients";
        fromDate="From Date";
        toDate="To Date";
        sStatus = "Client Saved Successfully";
        fStatus = "Please, Select Type Request";
        msgErrorExtConn = "Phone Number";
        search = "Search";
        regist = "Registration";
        clientNo="Client Number";
        clientName="Client Name";
        clientStatus="Client Status";
        total = "Total";

    } else {

        style = "Right";
        dir = "RTL";
        client_ssn = "عملاء غير موزعين";
        fromDate="من تاريخ	";
        toDate="إلي تاريخ		";
        msgErrorExtConn = "رقم الهاتف	";
        fStatus = "من فضلك اختار نوع الطلب";
        sStatus = "تم تسجيل العميل بنجاح";
        search = "بحث";
        regist = "تسجيل";
        clientNo="رقم العميل	";
        clientName="إسم العميل	";
        clientStatus="حالة العميل	";
        total = "العدد الكلي";
        
    }
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link rel="stylesheet" href="css/CSS.css"/>
        <link rel="stylesheet" href="css/chosen.css"/>
        <script src='ChangeLang.js' type='text/javascript'></script>
        <script type="text/javascript" src="/jquery-ui/jquery-1.7.1.js"></script>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css">
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.widget.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>
        <script src="js/select2.min.js"></script>
        <script src="js/chosen.jquery.js" type="text/javascript"></script>
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
            $(document).ready(function () {
                var str = '<%=clientTyp%>';
                if (str === "lead") {
                    $("#clientTyp option[value='lead']").prop("selected", true);
                } else if (str === "cust") {
                    $("#clientTyp option[value='cust']").prop("selected", true);
                }
            });
            function selectAll(obj) {
                $("input[name='customerId']").prop('checked', $(obj).is(':checked'));
            }
            $(function () {
                $("#beginDate, #endDate").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    maxDate: 0,
                    dateFormat: "yy/mm/dd"
                });
            });
            function distribution(mode) {
                if (!validateData("req", document.UNHANDLED_CLIENT_FORM.requestType, "<%=fStatus%>...")) {
                    $("#requestType").focus();
                } else {
                    $("#manualBtn").attr("disabled", "true");
                    $("#autoBtn").attr("disabled", "true");
                    var loggedOnly = $("#loggedOnly").is(":checked");
                    document.UNHANDLED_CLIENT_FORM.action = "<%=context%>/AutoPilotModeServlet?op=distributeLeadCustomers&mode=" + mode + "&fromURL=myUnhandledClients" + "&loggedOnly=" + loggedOnly
                            + "&requestType=" + $("#requestType").val();
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
            <form name="SEARCH_CLIENT_FORM" action="<%=context%>/ClientServlet?op=myUnhandledClients" method="POST">
                <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <tr>
                        <td width="100%" class="titlebar">
                            <font color="#005599" size="4"><%=client_ssn%></font>
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
                                <%=sStatus%>
                                </font>
                            </b>
                        </td>
                    </tr>
                </table>
                <br/>
                <%
                    }
                %>
                <table ALIGN="center" DIR="<%=dir%>" WIDTH="85%" CELLSPACING=2 CELLPADDING=1>
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="15%">
                            <b><font size=3 color="white"><%=fromDate%></b>
                        </td>
                        <td   class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="15%">
                            <b> <font size=3 color="white"><%=toDate%></b>
                        </td>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="15%">
                            <b><font size=3 color="white">Hash Tag</b>
                        </td>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="22%">
                            <b><font size=3 color="white"><%=msgErrorExtConn%></b>
                        </td>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="15%">
                            <b><font size=3 color="white">Clients Type</b>
                        </td>
                        <td STYLE="text-align:center" bgcolor="#dedede" rowspan="4" WIDTH="15%">  
                            <button type="submit" onclick="JavaScript: search();"  STYLE="color: #27272A;font-size:15px;margin-top: 20px;font-weight:bold; width: 70%; "><%=search%><IMG HEIGHT="15" SRC="images/search.gif" ></button>
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
                            <select name="clientTyp" id="clientTyp" style="font-size: 14px;font-weight: bold; width: 85%; height: 25px">
                                <option value="cust">Customer</option>
                                <option value="lead" selected>Lead</option>
                            </select>
                            <br/><br/>
                        </td>
                    </tr>
                </table>
            </form>
            <br/>
            <form name="UNHANDLED_CLIENT_FORM" method="POST">
                <%if (!clients.isEmpty()) {%>
                <table ALIGN="center" DIR="<%=dir%>" bgcolor="#dedede" WIDTH="85%" CELLSPACING=2 CELLPADDING=1>
                    <tr>
                        <td style="font-size:18px; text-align: right" WIDTH="30%">
                            <button id="autoBtn" type="button" onclick="JavaScript: distribution('auto');" value="" style="margin-left: 5%; text-align: center; width: 150px; font-size: 16px; color: blue; font-weight: bold; display: none;">
                                Auto-Pilot
                                <img src="images/icons/plane_icon.png" height="24" width="24" alt="distribute client" style="vertical-align: middle" />
                            </button>
                            <input type="checkbox" id="loggedOnly" value="1" style="display: none;"/> <span style="display: none;">Logged Only</span>
                        </td>
                        <td style="font-size:18px; text-align: right" WIDTH="20%">
                            <select name="requestType" id="requestType" style="width: 200px; font-size: 18px;">
                                <option value="" style="color: blue;">Select</option>
                                <sw:WBOOptionList wboList="<%=requestTypes%>" displayAttribute="projectName" valueAttribute="projectName" />
                            </select>
                        </td>
                        <td style="font-size:18px; text-align: <%=style%>; border-left-width: 0px" WIDTH="20%">
                            <button id="manualBtn" type="button" onclick="JavaScript: distribution('manual');" value="" style="margin-left: 5%; text-align: center; width: 150px; font-size: 16px; color: blue; font-weight: bold;">
                                Manual
                                <img src="images/icons/manual_pilot.png" height="24" width="24" alt="distribute client" style="vertical-align: middle" />
                            </button>
                        </td>
                        <td style="font-size:16px; color: blue; text-align: <%=style%>; border-right-width: 0px; border-left-width: 0px" WIDTH="20%">
                            <select name="employeeId" id="employeeId" style="font-size: 14px;font-weight: bold; width: 200px; height: 25px" class="chosen-select-employee" multiple>
                                <%
                                    for (WebBusinessObject userWboo : distributionsList) {
                                %>
                                <option value="<%=userWboo.getAttribute("userId")%>" style="<%=usersIDsList.contains(userWboo.getAttribute("userId")) ? "color: red; font-weight: bold;" : ""%>"><%=userWboo.getAttribute("fullName")%></option>
                                <%
                                    }
                                %>
                            </select>
                            <select name="salesEmployeeId" id="salesEmployeeId" style="font-size: 14px;font-weight: bold; width: 99%; height: 25px; display: none">
                                <sw:WBOOptionList wboList='<%=salesEmployees%>' displayAttribute="fullName" valueAttribute="userId"/>
                            </select>
                        </td>
                        <td style="font-size:16px; color: blue; text-align: right; border-right-width: 0px" WIDTH="10%">
                            <input type="checkbox" id="salesEmployee" name="salesEmployee" value="" onchange="JavaScript: salesEmployeeBox();"/>المبيعات 
                        </td>
                    </tr>
                </table>
                <br/>
                <br/>
                <%}%>
                <TABLE ALIGN="center" dir="<%=dir%>" WIDTH="85%" CELLPADDING="0" CELLSPACING="0" STYLE="border: 2px solid #d3d5d4">
                    <thead>                
                    <TD class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px">
                        <input type="checkbox" name="checkAll" onchange="selectAll(this);"/>
                    </TD>
                    <TD class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px"><b>#</b></TD>
                    <TD class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px"><b><%=clientNo%></b></TD>
                    <TD class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px"><b><%=clientName%></b></TD>
                    <TD class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px"><b><%=clientStatus%></b></TD>
                    <TD class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px"><b><%=msgErrorExtConn%></b></TD>
                    <TD class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px"><b>Date</b></TD>
                    </thead>
                    <tbody>
                        <%  int counter = 0;
                            String clazz;
                            boolean isMobileValid;
                            String mobile;
                            for (WebBusinessObject wbo : clients) {
                                if ((counter % 2) == 1) {
                                    clazz = "silver_odd_main";
                                } else {
                                    clazz = "silver_even_main";
                                }
                                counter++;
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
                        <tr style="cursor: pointer; background-color: <%=isMobileValid ? "" : "#fed8d6"%>;">
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
                                    <b><%=wbo.getAttribute("clientNO")%></b>
                                </DIV>
                            </TD>
                            <TD STYLE="text-align: center" nowrap>
                                <DIV>                           
                                    <b><%=wbo.getAttribute("name")%></b>
                                </DIV>
                                <%
                                    if (!isMobileValid) {
                                %>
                                <img src="images/user_male_edit.png" style="width: 20px; float: left;" title="تعديل بيانات العميل"
                                     onclick="JavaScript: updateClientInformation('<%=wbo.getAttribute("id")%>');"/>
                                <%
                                    }
                                %>
                            </TD>
                            <TD STYLE="text-align: center" nowrap>
                                <DIV>                  
                                    <b style="color: <%="lead".equals(wbo.getAttribute("statusNameEn")) ? "red" : "black"%>;"><%=wbo.getAttribute("statusNameEn")%></b>
                                </DIV>
                            </TD>
                            <TD STYLE="text-align: center">
                                <DIV>                   
                                    <b><%=(wbo.getAttribute("mobile") != null ? wbo.getAttribute("mobile") : "")%></b>
                                </DIV>
                            </TD>
                            <TD STYLE="text-align: center" nowrap>
                                <DIV>
                                    <b><%=wbo.getAttribute("creationTime")%></b>
                                </DIV>
                            </TD>
                        </tr>
                        <%}%>
                        <tr>   
                            <TD CLASS="silver_footer" colspan="3" BGCOLOR="#808080" STYLE="text-align: center; padding-left:5px; border-right-width:1px; font-size:16px">
                                <B><%=total%> : </B>
                            </TD>
                            <TD CLASS="silver_footer" colspan="3" BGCOLOR="#808080" STYLE="text-align: center; padding-left:5px; border-right-width:1px; font-size:14px">
                                <B><%=clients.size()%></B>
                            </TD>
                        </tr>
                    </tbody>
                </table>
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
