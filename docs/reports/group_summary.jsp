<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.List"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page pageEncoding="UTF-8"%>
<html>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();

        List<WebBusinessObject> groups = (List) request.getAttribute("groups");
        List<WebBusinessObject> summary = (List) request.getAttribute("summary");
        WebBusinessObject user = (WebBusinessObject) session.getAttribute("loggedUser");
        // get current date and Time
        Calendar cal = Calendar.getInstance();
        String jDateFormat = user.getAttribute("javaDateFormat").toString();
        SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
        String nowDate = sdf.format(cal.getTime());
        String stat = (String) request.getSession().getAttribute("currentMode");
        String align = null;
        String dir = null;
        String style = null;
        String lang, langCode, print, title, fromDate, toDate;
        if (stat.equals("En")) {
            align = "center";
            dir = "LTR";
            style = "text-align:left";
            lang = "   &#1593;&#1585;&#1576;&#1610;    ";
            langCode = "Ar";
            title = "Group Summary";
            print = "get report";
            fromDate = "From Date";
            toDate = "To Date";
        } else {
            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            lang = "English";
            langCode = "En";
            title = "كشف حساب";
            print = "&#1605;&#1588;&#1575;&#1607;&#1583;&#1607; &#1575;&#1604;&#1578;&#1602;&#1585;&#1610;&#1585; ";
            fromDate = "&#1605;&#1606; &#1578;&#1575;&#1585;&#1610;&#1582;";
            toDate = "&#1575;&#1604;&#1609; &#1578;&#1575;&#1585;&#1610;&#1582;";
        }
    %>
    <head>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css"/>
        <link rel="stylesheet" href="css/demo_table.css"/>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="js/jquery.min.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <SCRIPT type="text/javascript" src="js/json2.js"></SCRIPT>
        <script type="text/javascript" src="js/highcharts.js"></script>
        <script type="text/javascript">
            var oTable;
            $(document).ready(function () {
                $("#clients").css("display", "none");
                oTable = $('#clients').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                    iDisplayLength: 25,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true
                }).fadeIn(2000);
            });
            
            var dp_cal1, dp_cal12;
            window.onload = function () {
                dp_cal1 = new Epoch('epoch_popup', 'popup', document.getElementById('fromDate'));
                dp_cal12 = new Epoch('epoch_popup', 'popup', document.getElementById('toDate'));
            };
            function submitForm()
            {
                document.EmployeesLoads.action = "<%=context%>/ReportsServletTwo?op=getGroupEmplyeeSummary";
                document.EmployeesLoads.submit();
            }
        </script>
        <style>

            label{
                font: Georgia, "Times New Roman", Times, serif;
                font-size:14px;
                font-weight:bold;
                color:#005599;
                margin-right: 5px;
            }
            #row:hover{
                background-color: #EEEEEE;
            }
            .client_btn {
                width:145px;
                height:31px;
                margin: 4px;
                background-repeat: no-repeat;
                cursor: pointer;
                border: none;
                background-position: right top ;
                display: inline-block;
                background-color: transparent;
                background-image:url(images/buttons/addclient.png);
            }
            .company_btn {
                width:145px;
                height:31px;
                margin: 4px;
                background-repeat: no-repeat;
                cursor: pointer;
                border: none;
                background-position: right top ;
                display: inline-block;
                background-color: transparent;
                background-image:url(images/buttons/addCompany.png);
            }
            .enter_call {
                width:145px;
                height:31px;
                margin: 4px;
                background-repeat: no-repeat;
                cursor: pointer;
                border: none;
                background-position: right top ;
                display: inline-block;
                background-color: transparent;
                background-image:url(images/buttons/Number.png);
            }
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
    </head>
    <body>
        <form name="EmployeesLoads" method="post"> 
            <br/>
            <fieldset class="set" style="width:85%;border-color: #006699">
                <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <tr>
                        <td width="100%" class="titlebar">
                            <font color="#005599" size="4"><%=title%></font>
                        </td>
                    </tr>
                </table>
                <br/>
                <table ALIGN="center" DIR="RTL" WIDTH="60%" CELLSPACING=2 CELLPADDING=1>
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="40%">
                            <b><font size=3 color="white"><%=fromDate%></b>
                        </td>
                        <td   class="blueBorder blueHeaderTD" style="font-size:18px;"WIDTH="40%">
                            <b> <font size=3 color="white"><%=toDate%></b>
                        </td>
                        <td STYLE="text-align:center" bgcolor="#dedede" rowspan="4" WIDTH="20%">  
                            <button  onclick="JavaScript: submitForm();" STYLE="color: #000;font-size:15px;font-weight:bold;height: 35px"><%=print%> <IMG HEIGHT="15" SRC="images/search.gif"/> </button>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align:center" bgcolor="#dedede"  valign="MIDDLE">
                            <%
                                String sBDate = (String) request.getAttribute("fromDate");
                                String sEDate = (String) request.getAttribute("toDate");

                                String startDate = null;
                                String toDateValue = null;
                                if (sBDate != null && !sBDate.equals("")) {
                                    startDate = sBDate;
                                } else {
                                    cal.add(Calendar.MONTH, -1);
                                    startDate = sdf.format(cal.getTime());
                                }
                                if (sEDate != null && !sEDate.equals("")) {
                                    toDateValue = sEDate;
                                } else {
                                    toDateValue = nowDate;
                                }
                            %>
                            <input id="fromDate" name="fromDate" type="text" value="<%=startDate%>"/><img src="images/showcalendar.gif"/> 
                            <br/><br/>
                        </td>
                        <td  bgcolor="#dedede"  style="text-align:center" valign="middle">
                            <input id="toDate" name="toDate" type="text" value="<%=toDateValue%>"/><img src="images/showcalendar.gif"/>
                            <br/><br/>
                        </td>
                    </tr>
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" colspan="2">
                            <b><font size=3 color="white">المجموعة</b>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align:center" bgcolor="#dedede" valign="MIDDLE" colspan="2">
                            <select style="width: 200px; font-weight: bold; font-size: 13px; margin-top: 5px;" id="groupId" name="groupId">
                                <sw:WBOOptionList displayAttribute="groupName" valueAttribute="groupID" wboList="<%=groups%>" scrollToValue='<%=(String) request.getAttribute("groupId")%>' />
                            </select>
                            <br/><br/>
                        </td>
                    </tr>
                </table>
                <br>
                <% if (summary != null && summary.size() > 0) {%>
                <center><hr style="width: 85%" /></center>
                <div style="width: 85%;margin-right: auto;margin-left: auto;" id="showClients">
                    <table ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="100%" id="clients" style="">
                        <thead>
                            <tr>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;">اسم الموظف</th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;">العملاء</th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;">التعليقات</th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;">المتابعات</th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;">اﻷنهاء</th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;">اﻷغلاق</th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold; width: 80px;">حجز مؤكد</th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold; width: 80px;">حجز غير مؤكد</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                int totalClients = 0;
                                int totalComments = 0;
                                int totalAppointments = 0;
                                int totalFinish = 0;
                                int totalClosure = 0;
                                int totalConfirmed = 0;
                                int totalNonConfirmed = 0;
                                for (WebBusinessObject wbo_ : summary) {
                                    try {
                                        if (wbo_.getAttribute("totalClients") != null && !wbo_.getAttribute("totalClients").equals("")) {
                                            totalClients += Integer.parseInt((String) wbo_.getAttribute("totalClients"));
                                        }
                                    } catch (NumberFormatException ne) {
                                    }
                                    try {
                                        if (wbo_.getAttribute("totalComments") != null && !wbo_.getAttribute("totalComments").equals("")) {
                                            totalComments += Integer.parseInt((String) wbo_.getAttribute("totalComments"));
                                        }
                                    } catch (NumberFormatException ne) {
                                    }
                                    try {
                                        if (wbo_.getAttribute("totalAppointments") != null && !wbo_.getAttribute("totalAppointments").equals("")) {
                                            totalAppointments += Integer.parseInt((String) wbo_.getAttribute("totalAppointments"));
                                        }
                                    } catch (NumberFormatException ne) {
                                    }
                                    try {
                                        if (wbo_.getAttribute("totalFinish") != null && !wbo_.getAttribute("totalFinish").equals("")) {
                                            totalFinish += Integer.parseInt((String) wbo_.getAttribute("totalFinish"));
                                        }
                                    } catch (NumberFormatException ne) {
                                    }
                                    try {
                                        if (wbo_.getAttribute("totalClosure") != null && !wbo_.getAttribute("totalClosure").equals("")) {
                                            totalClosure += Integer.parseInt((String) wbo_.getAttribute("totalClosure"));
                                        }
                                    } catch (NumberFormatException ne) {
                                    }
                                    try {
                                        if (wbo_.getAttribute("totalConfirmed") != null && !wbo_.getAttribute("totalConfirmed").equals("")) {
                                            totalConfirmed += Integer.parseInt((String) wbo_.getAttribute("totalConfirmed"));
                                        }
                                    } catch (NumberFormatException ne) {
                                    }
                                    try {
                                        if (wbo_.getAttribute("totalNonConfirmed") != null && !wbo_.getAttribute("totalNonConfirmed").equals("")) {
                                            totalNonConfirmed += Integer.parseInt((String) wbo_.getAttribute("totalNonConfirmed"));
                                        }
                                    } catch (NumberFormatException ne) {
                                    }
                            %>
                            <tr style="cursor: pointer" id="row">
                                <td>
                                    <%if (wbo_.getAttribute("userName") != null) {%>
                                    <b><%=wbo_.getAttribute("userName")%></b>
                                    <% }%>
                                </td>
                                <td>
                                    <%if (wbo_.getAttribute("totalClients") != null) {%>
                                    <b><%=wbo_.getAttribute("totalClients")%></b>
                                    <%} else {%>
                                    <b>0</b>
                                    <%}%>
                                </td>
                                <td>
                                    <%if (wbo_.getAttribute("totalComments") != null) {%>
                                    <b><%=wbo_.getAttribute("totalComments")%></b>
                                    <%} else {%>
                                    <b>0</b>
                                    <%}%>
                                </td>
                                <td>
                                    <%if (wbo_.getAttribute("totalAppointments") != null) {%>
                                    <b><%=wbo_.getAttribute("totalAppointments")%></b>
                                    <%} else {%>
                                    <b>0</b>
                                    <%}%>
                                </td>
                                <td>
                                    <%if (wbo_.getAttribute("totalFinish") != null) {%>
                                    <b><%=wbo_.getAttribute("totalFinish")%></b>
                                    <%} else {%>
                                    <b>0</b>
                                    <%}%>
                                </td>
                                <td>
                                    <%if (wbo_.getAttribute("totalClosure") != null) {%>
                                    <b><%=wbo_.getAttribute("totalClosure")%></b>
                                    <%} else {%>
                                    <b>0</b>
                                    <%}%>
                                </td>
                                <td style="background-color: #7DDE7D; width: 80px;">
                                    <%if (wbo_.getAttribute("totalConfirmed") != null) {%>
                                    <b><%=wbo_.getAttribute("totalConfirmed")%></b>
                                    <%} else {%>
                                    <b>0</b>
                                    <%}%>
                                </td>
                                <td style="background-color: #FFFF89; width: 80px;">
                                    <%if (wbo_.getAttribute("totalNonConfirmed") != null) {%>
                                    <b><%=wbo_.getAttribute("totalNonConfirmed")%></b>
                                    <%} else {%>
                                    <b>0</b>
                                    <%}%>
                                </td>
                            </tr>
                            <% }%>
                        </tbody>  
                        <tfoot>
                            <tr>
                                <th style="color: #005599 !important;font-size: 14px; font-weight: bold;">أجمالي </th>
                                <th style="color: #005599 !important;font-size: 14px; font-weight: bold;"><%=totalClients%></th>
                                <th style="color: #005599 !important;font-size: 14px; font-weight: bold;"><%=totalComments%></th>
                                <th style="color: #005599 !important;font-size: 14px; font-weight: bold;"><%=totalAppointments%></th>
                                <th style="color: #005599 !important;font-size: 14px; font-weight: bold;"><%=totalFinish%></th>
                                <th style="color: #005599 !important;font-size: 14px; font-weight: bold;"><%=totalClosure%></th>
                                <th style="color: #005599 !important;font-size: 14px; font-weight: bold;"><%=totalConfirmed%></th>
                                <th style="color: #005599 !important;font-size: 14px; font-weight: bold;"><%=totalNonConfirmed%></th>
                            </tr>
                        </tfoot>
                    </table>
                </div>
                <br/>
                    <%}%>
                <br/>
            </fieldset>
        </form>
    </body>
</html>     
