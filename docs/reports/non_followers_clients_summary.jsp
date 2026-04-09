<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Set"%>
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
        Map<String, ArrayList<WebBusinessObject>> dataResult = (HashMap<String, ArrayList<WebBusinessObject>>) request.getAttribute("dataResult");
        Map<String, WebBusinessObject> employeeResult = (HashMap<String, WebBusinessObject>) request.getAttribute("employeeResult");
        WebBusinessObject user = (WebBusinessObject) session.getAttribute("loggedUser");
        String reportType = "brief";
        if (request.getAttribute("reportType") != null) {
            reportType = (String) request.getAttribute("reportType");
        }
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
            title = "Non-followers Clients Summary";
            print = "get report";
            fromDate = "From Date";
            toDate = "To Date";
        } else {
            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            lang = "English";
            langCode = "En";
            title = "كشف حساب عملاء غير متابعين";
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
                document.EmployeesLoads.action = "<%=context%>/ReportsServletTwo?op=getNonFollowersClientSummary";
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
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;">
                            <b><font size=3 color="white">المجموعة</b>
                        </td>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;">
                            <b><font size=3 color="white">نوع التقرير</b>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align:center" bgcolor="#dedede" valign="MIDDLE">
                            <select style="width: 200px; font-weight: bold; font-size: 13px; margin-top: 5px;" id="groupId" name="groupId">
                                <sw:WBOOptionList displayAttribute="groupName" valueAttribute="groupID" wboList="<%=groups%>" scrollToValue='<%=(String) request.getAttribute("groupId")%>' />
                            </select>
                            <br/><br/>
                        </td>
                        <td style="text-align:center" bgcolor="#dedede" valign="middle">
                            <input type="radio" name="reportType" value="brief" <%=reportType.equals("brief") ? "checked" : ""%>/>ملخص
                            <input type="radio" name="reportType" value="detail" <%=reportType.equals("detail") ? "checked" : ""%>/>تفصيلي
                        </td>
                    </tr>
                </table>
                <br>
                <% if (!"detail".equals(reportType) && summary != null && summary.size() > 0) {%>
                <center><hr style="width: 85%" /></center>
                <div style="width: 85%;margin-right: auto;margin-left: auto;" id="showClients">
                    <table ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="100%" id="clients" style="">
                        <thead>
                            <tr>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;">اسم الموظف</th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;">عدد العملاء</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                int totalClients = 0;
                                for (WebBusinessObject wbo_ : summary) {
                                    try {
                                        if (wbo_.getAttribute("clientCount") != null && !wbo_.getAttribute("clientCount").equals("")) {
                                            totalClients += Integer.parseInt((String) wbo_.getAttribute("clientCount"));
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
                                    <%if (wbo_.getAttribute("clientCount") != null) {%>
                                    <%=wbo_.getAttribute("clientCount")%>
                                    <%} else {%>
                                    0
                                    <%}%>
                                </td>
                            </tr>
                            <% }%>
                        </tbody>  
                        <tfoot>
                            <tr>
                                <th style="color: #005599 !important;font-size: 14px; font-weight: bold;">أجمالي </th>
                                <th style="color: #005599 !important;font-size: 14px; font-weight: bold;"><%=totalClients%></th>
                            </tr>
                        </tfoot>
                    </table>
                </div>
                <br/>
                <%
                } else {
                    int total = 0;
                    if (employeeResult != null) {
                %>
                <table align="center" dir="rtl" width="95%" cellpadding="0" cellspacing="0" style="border: 2px solid #d3d5d4">
                    <tbody>  
                        <%
                            Set<String> keys = employeeResult.keySet();
                            for (String userID : keys) {
                                WebBusinessObject userWbo = employeeResult.get(userID);
                                ArrayList<WebBusinessObject> clientsList = dataResult.get(userID);
                                total += clientsList.size();
                        %>
                        <tr>
                            <td class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px" colspan="2"><b>اسم الموظف</b></td>
                            <td><b style="cursor: hand;" onclick="JavaScript: popupClientStatistics('<%=userID%>', '<%=userWbo.getAttribute("fullName")%>')"><%=userWbo.getAttribute("fullName")%></b></td>
                            <td class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px"><b>أجمالي العملاء</b></td>
                            <td colspan="2"><b><%=clientsList.size()%></b></td>
                        </tr>
                        <%
                            if (reportType.equals("detail")) {
                        %>
                        <tr>
                            <td class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px"><span><img src="images/icons/Numbers.png" width="20" height="20" /><b>المتابعة العامة</b></span></td>
                            <td class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px"><span><b> كود اﻷدارة</b></span></td>
                            <td class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px"><span><img src="images/icons/client.png" width="20" height="20" /><b>اسم العميل</b></span></td>
                            <td class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px"><span><b>رقم الموبايل</b></span></td>
                            <td class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px"><span><b>الدولي</b></span></td>
                            <td class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px"><span><b>المصدر</b></span></td>
                        </tr>
                        <%
                            int counter = 0;
                            String clazz;
                            if (clientsList != null && !clientsList.isEmpty()) {
                                for (WebBusinessObject wbo : clientsList) {
                                    if ((counter % 2) == 1) {
                                        clazz = "silver_odd_main";
                                    } else {
                                        clazz = "silver_even_main";
                                    }
                                    counter++;
                                    String compStyle = "";
                        %>
                        <tr class="<%=clazz%>">
                            <%
                                if (wbo.getAttribute("ticketType").toString().equals("1")) {
                                    compStyle = "comp";
                                } else if (wbo.getAttribute("ticketType").toString().equals("2")) {
                                    compStyle = "order";
                                } else if (wbo.getAttribute("ticketType").toString().equals("3")) {
                                    compStyle = "query";
                                } else if (wbo.getAttribute("ticketType").toString().equals("5")) {
                                    compStyle = "order";
                                } else if (wbo.getAttribute("ticketType").toString().equals("6")) {
                                    compStyle = "order";
                                } else if (wbo.getAttribute("ticketType").toString().equals("7")) {
                                    compStyle = "order";
                                }
                            %>
                            <td style="cursor: pointer" onmouseover="this.className = '<%=compStyle%>'" onmouseout="this.className = ''">
                                <a href="<%=context%>/IssueServlet?op=getCompl3&issueId=<%=wbo.getAttribute("issue_id")%>&compId=<%=wbo.getAttribute("clientComId")%>&statusCode=<%=wbo.getAttribute("statusCode")%>&receipId=<%=wbo.getAttribute("receipId")%>&senderID=<%=wbo.getAttribute("senderId")%>&clientType=<%=wbo.getAttribute("age")%>&currentOwnerId=<%=wbo.getAttribute("currentOwnerId")%>"> <font color="red"><%=wbo.getAttribute("businessID").toString()%></font><font color="blue">/<%=wbo.getAttribute("businessIDbyDate").toString()%></font>
                                </a>
                                <input type="hidden" id="issue_id" value="<%=wbo.getAttribute("issue_id")%>" />
                                <input type="hidden" id="comp_Id" value="<%=wbo.getAttribute("clientComId")%>" />
                                <input type="hidden" id="receip_id" value="<%=wbo.getAttribute("receipId")%>" />
                                <input type="hidden" id="sender_id" value="<%=wbo.getAttribute("senderId")%>" />
                            </td>
                            <td style="cursor: pointer" onmouseover="this.className = '<%=compStyle%>'" onmouseout="this.className = ''">
                                <font color="green"><%=wbo.getAttribute("businessCompId")%></font>
                            </td>
                            <td><b><%=wbo.getAttribute("customerName").toString()%></b>
                                <a href="<%=context%>/ClientServlet?op=clientDetails&clientId=<%=wbo.getAttribute("customerId")%>">
                                    <img src="images/client_details.jpg" width="30" style="float: left;" title="تفاصيل"/>
                                </a>
                            </td>
                            <td><% String mobile = null;
                                if (wbo.getAttribute("clientMobile") == null || wbo.getAttribute("clientMobile").equals(" ") || wbo.getAttribute("clientMobile").equals("")) {
                                    mobile = "--------";
                                } else {
                                    mobile = (String) wbo.getAttribute("clientMobile");
                                }%><b><%=mobile%></b>
                            </td>
                            <td nowrap><b><%=wbo.getAttribute("interPhone") != null && !"UL".equals(wbo.getAttribute("interPhone")) ? wbo.getAttribute("interPhone") : "---"%></b></td>
                            <td nowrap><b><%=wbo.getAttribute("senderName")%></b></td>
                        </tr>
                        <%
                            }
                        } else {
                        %>
                        <tr>
                            <td colspan="6"><b>لايوجد عملاء</b></td>
                        </tr>
                        <%
                                }
                            }
                        %>
                        <tr>
                            <td colspan="6" class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px"><b>&nbsp;</b></td>
                        </tr>
                        <%
                            }
                        %>
                        <tr>
                            <td colspan="6"><b>&nbsp;</b></td>
                        </tr>
                        <tr>
                            <td colspan="3" class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px"><b>إجمالي العملاء</b></td>
                            <td colspan="3"><b><%=total%></b></td>
                        </tr>
                    </tbody>
                </table>
                <br />
                <%
                        }
                    }
                %>
                <br/>
            </fieldset>
        </form>
    </body>
</html>     
