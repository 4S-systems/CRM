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
        List<WebBusinessObject> loads = (List) request.getAttribute("loads");
        WebBusinessObject user = (WebBusinessObject) session.getAttribute("loggedUser");
        // get current date and Time
        Calendar cal = Calendar.getInstance();
        String jDateFormat = user.getAttribute("javaDateFormat").toString();
        SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
        String nowDate = sdf.format(cal.getTime());
        String statusCode = "";
        if (request.getAttribute("statusCode") != null) {
            statusCode = (String) request.getAttribute("statusCode");
        }
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
            title = "Closure Notes Productions";
            print = "get report";
            fromDate = "From Date";
            toDate = "To Date";
        } else {
            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            lang = "English";
            langCode = "En";
            title = "تعليقات الأغلاق المجمعة";
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

            /* preparing bar chart */
            var chart;
            $(document).ready(function () {
                chart = new Highcharts.Chart({
                    chart: {
                        renderTo: 'container',
                        defaultSeriesType: 'bar'
                    },
                    title: {
                        text: 'عدد التعليقات'
                    },
                    subtitle: {
                        text: ''
                    },
                    xAxis: {
                        labels: {
                            style: {
                                color: '#0059FF',
                                fontWeight: 'bold'
                            }
                        },
                        categories: [<% if (loads != null) {
                                for (int i = 0; i < loads.size(); i++) {
                                    WebBusinessObject wbo_ = loads.get(i);
                                    if (i > 0) {
                                        out.write(",");
                                    }
                                    out.write("'" + (String) wbo_.getAttribute("userName") + "'");
                                }
                            }%>],
                        title: {
                            text: null
                        }
                    },
                    yAxis: {
                        allowDecimals: false,
                        min: 0,
                        labels: {
                            style: {
                                fontWeight: 'bold'
                            }
                        },
                        title: {
                            text: 'التعليقات',
                            align: 'high'
                        }
                    },
                    tooltip: {
                        formatter: function () {
                            return ' ' + 'التعليقات' + ' ' + this.y + ' ';
                        }
                    },
                    plotOptions: {
                        bar: {
                            dataLabels: {
                                enabled: true
                            }
                        }
                    },
                    legend: {
                        layout: 'vertical',
                        align: 'right',
                        verticalAlign: 'top',
                        x: -100,
                        y: 100,
                        floating: true,
                        borderWidth: 1,
                        backgroundColor: '#FFFFFF',
                        shadow: true
                    },
                    credits: {
                        enabled: false
                    },
                    series: [{
                            name: 'التعليقات',
                            color: '#0059FF',
                            pointWidth: 20,
                            data: [<% if (loads != null) {
                                    for (int i = 0; i < loads.size(); i++) {
                                        WebBusinessObject wbo_ = loads.get(i);
                                        if (i > 0) {
                                            out.write(",");
                                        }
                                        out.write((String) wbo_.getAttribute("total"));
                                    }
                                }%>]
                        }]
                });
            });
            /* -preparing bar chart */
            
            var dp_cal1, dp_cal12;
            window.onload = function () {
                dp_cal1 = new Epoch('epoch_popup', 'popup', document.getElementById('fromDate'));
                dp_cal12 = new Epoch('epoch_popup', 'popup', document.getElementById('toDate'));
            };
            function submitForm()
            {
                document.EmployeesLoads.action = "<%=context%>/ReportsServletTwo?op=getClosureNotesProductions";
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
                            <b><font size=3 color="white">الحالة</b>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align:center" bgcolor="#dedede" valign="MIDDLE">
                            <select style="width: 200px; font-weight: bold; font-size: 13px;" id="groupId" name="groupId">
                                <sw:WBOOptionList displayAttribute="groupName" valueAttribute="groupID" wboList="<%=groups%>" scrollToValue='<%=(String) request.getAttribute("groupId")%>' />
                            </select>
                            <br/><br/>
                        </td>
                        <td style="text-align:center" bgcolor="#dedede" valign="MIDDLE">
                            <select style="font-size: 14px;font-weight: bold; width: 200px;" name="statusCode">
                                <option value="6" <%=statusCode.equals("6") ? "selected" : ""%>>منهي</option>
                                <option value="7" <%=statusCode.equals("7") ? "selected" : ""%>>مغلق</option>
                            </select>
                            <br/><br/>
                        </td>
                    </tr>
                </table>
                <br>
                <% if (loads != null && loads.size() > 0) {%>
                <center><hr style="width: 85%" /></center>
                <div style="width: 85%;margin-right: auto;margin-left: auto;" id="showClients">
                    <table ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="100%" id="clients" style="">
                        <thead>
                            <tr>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;">اسم الموظف</th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;">العدد</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                int total = 0;
                                for (WebBusinessObject wbo_ : loads) {
                                    try {
                                        if (wbo_.getAttribute("total") != null && !wbo_.getAttribute("total").equals("")) {
                                            total += Integer.parseInt((String) wbo_.getAttribute("total"));
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
                                    <%if (wbo_.getAttribute("total") != null) {%>
                                    <b><%=wbo_.getAttribute("total")%></b>
                                    <%} else {%>
                                    <b>0</b>
                                    <%}%>
                                </td>
                            </tr>
                            <% }%>
                        </tbody>  
                        <tfoot>
                            <tr>
                                <th style="color: #005599 !important;font-size: 14px; font-weight: bold;">أجمالي التعليقات</th>
                                <th style="color: #005599 !important;font-size: 14px; font-weight: bold;"><%=total%></th>
                            </tr>
                        </tfoot>
                    </table>
                </div>
                <br/>
                <center><hr style="width: 85%" /></center>
                <div id="container" style="width: 100%; height: 50%; margin: 0 auto"></div>
                <br/>
                <center><hr style="width: 85%" /></center>
                    <%}%>
                <br/>
            </fieldset>
        </form>
    </body>
</html>     
