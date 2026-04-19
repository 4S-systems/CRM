<%@page import="java.math.BigDecimal"%>
<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*, com.tracker.common.*, java.util.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants, com.silkworm.persistence.relational.*"%>
<%@ page import="com.silkworm.common.TimeServices, java.lang.Math"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page pageEncoding="UTF-8"%>
<html>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        List<WebBusinessObject> users = (List) request.getAttribute("users");
        List<WebBusinessObject> commentsList = (List) request.getAttribute("commentsList");
        ArrayList<String> years = (ArrayList<String>) request.getAttribute("years");
        Calendar c = Calendar.getInstance();
        String year = request.getAttribute("year") != null ? (String) request.getAttribute("year") : c.get(Calendar.YEAR) + "";
        String quarter = request.getAttribute("quarter") != null ? (String) request.getAttribute("quarter") : "1";
        String cMode = (String) request.getSession().getAttribute("currentMode");
        String stat = cMode;
        String align = null;
        String dir = null;
        String style = null;
        String print, title;
        if (stat.equals("En")) {
            align = "center";
            dir = "LTR";
            style = "text-align:left";
            title = "Employee's Appointments";
            print = "get report";
        } else {
            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            title = "تعليقات الموظف";
            print = "&#1605;&#1588;&#1575;&#1607;&#1583;&#1607; &#1575;&#1604;&#1578;&#1602;&#1585;&#1610;&#1585; ";
        }
    %>
    <head>
        <meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
        <meta HTTP-EQUIV="Expires" CONTENT="0"/>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css"/>
        <link rel="stylesheet" href="css/demo_table.css"/>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="js/jquery.min.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <script type="text/javascript" src="js/json2.js"></script>
        <script type="text/javascript" src="js/highcharts.js"></script>
        <script type="text/javascript">
            var oTable;
            $(document).ready(function() {
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
            $(document).ready(function() {
                chart = new Highcharts.Chart({
                    chart: {
                        renderTo: 'container',
                        defaultSeriesType: 'bar',
                        width: 900,
                        height: 500
                    },
                    title: {
                        text: 'تعليقات "' + $("#userId option:selected").text() + '" في الربع ' + $("#quarter option:selected").text() + ' لعام ' + $("#year option:selected").text()
                    },
                    subtitle: {
                        text: ''
                    },
                    xAxis: {
                        labels: {
                            style: {
                                color: '#6D869F',
                                fontWeight: 'bold'
                            }
                        },
                        categories: [<% if (commentsList != null) {
                                for (int i = 0; i < commentsList.size(); i++) {
                                    WebBusinessObject wbo_ = commentsList.get(i);
                                    if (i > 0) {
                                        out.write(",");
                                    }
                                    out.write("'" + "Week " + (i + 1) + " (" + (String) wbo_.getAttribute("startDate") + ")'");
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
                            text: 'عدد التعليقات',
                            align: 'high'
                        }
                    },
                    tooltip: {
                        formatter: function() {
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
                            color: 'red',
                            pointWidth: 20,
                            data: [<% if (commentsList != null) {
                                    for (int i = 0; i < commentsList.size(); i++) {
                                        WebBusinessObject wbo_ = commentsList.get(i);
                                        if (i > 0) {
                                            out.write(",");
                                        }
                                        out.write(((BigDecimal) wbo_.getAttribute("total")).toString());
                                    }
                                }%>]
                        }]
                });
            });
            /* -preparing bar chart */

            function submitForm()
            {
                var id = $("#userId").val();
                document.ProductivityByUser.action = "<%=context%>/ReportsServletThree?op=getCommentsByUserReport&id=" + id;
                document.ProductivityByUser.submit();
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
        <form name="ProductivityByUser" method="post">
            <fieldset class="set" style="width:85%;border-color: #006699">
                <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <tr>
                        <td width="100%" class="titlebar">
                            <font color="#005599" size="4"><%=title%></font>
                        </td>
                    </tr>
                </table>
                <br/>
                <table class="blueBorder" ALIGN="center" DIR="RTL" ID="code" CELLPADDING="0" CELLSPACING="0" width="70%" STYLE="border-width:1px;border-color:white;" >
                    <tr>
                        <td  class="blueBorder blueHeadertd" style="font-size:18px;" WIDTH="33%">
                            <b><font size=3 color="white">الربع</b>
                        </td>
                        <td  class="blueBorder blueHeadertd" style="font-size:18px;" WIDTH="33%">
                            <b><font size=3 color="white">السنة</b>
                        </td>
                        <td  class="blueBorder blueHeadertd" style="font-size:18px;" WIDTH="33%">
                            <b><font size=3 color="white">الموظف</b>
                        </td>
                    </tr>
                    <tr>
                        <td  bgcolor="#dedede" valign="middle">
                            <select style="width: 50%; font-weight: bold; font-size: 13px;" id="quarter" name="quarter">
                                <option value="1" <%=quarter.equals("1") ? "selected" : ""%>>اﻷول</option>
                                <option value="2" <%=quarter.equals("2") ? "selected" : ""%>>الثاني</option>
                                <option value="3" <%=quarter.equals("3") ? "selected" : ""%>>الثالث</option>
                                <option value="4" <%=quarter.equals("4") ? "selected" : ""%>>الرابع</option>
                            </select>
                        </td>
                        <td  bgcolor="#dedede" valign="middle">
                            <select name="year" id="year" style="width: 50%; font-weight: bold; font-size: 13px;" onchange="JavaScript:changeMonth(this);">
                                <sw:OptionList optionList="<%=years%>" scrollTo="<%=year%>" />
                            </select>
                        </td>
                        <td  bgcolor="#dedede" valign="middle">
                            <select style="width: 50%; font-weight: bold; font-size: 13px;" id="userId" name="userId">
                                <sw:WBOOptionList displayAttribute="fullName" valueAttribute="userId" wboList="<%=users%>" scrollToValue='<%=request.getParameter("userId")%>' />
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td bgcolor="#dedede" style="text-align:center; padding-bottom: 5px; padding-top: 5px" valign="middle" colspan="3">
                            <button onclick="JavaScript: submitForm();" STYLE="color: #27272A;font-size:15px;font-weight:bold;height: 35px"><%=print%> <IMG HEIGHT="15" SRC="images/search.gif"> </button>
                        </td>
                    </tr>
                </table>
                <br>
                <% if (commentsList != null && commentsList.size() > 0) {%>
                <center><hr style="width: 85%" /></center>
                <div style="width: 85%;margin-right: auto;margin-left: auto;" id="showClients">
                    <table ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="100%" id="clients" style="">
                        <thead>
                            <tr>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;">من تاريخ</th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;">إلي تاريخ</th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;">العدد</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                            int total = 0;
                            for (WebBusinessObject wbo_ : commentsList) {
                                try {
                                    if(wbo_.getAttribute("total") != null && !wbo_.getAttribute("total").equals("")) {
                                        total += ((BigDecimal) wbo_.getAttribute("total")).intValue();
                                    }
                                } catch(NumberFormatException ne) {
                                }
                            %>
                            <tr style="cursor: pointer" id="row">
                                <td>
                                    <%if (wbo_.getAttribute("startDate") != null) {%>
                                    <b><%=wbo_.getAttribute("startDate")%></b>
                                    <% }%>
                                </td>
                                <td>
                                    <%if (wbo_.getAttribute("endDate") != null) {%>
                                    <b><%=wbo_.getAttribute("endDate")%></b>
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
                                <th style="color: #005599 !important;font-size: 14px; font-weight: bold;" colspan="2">أجمالي التعليقات</th>
                                <th style="color: #005599 !important;font-size: 14px; font-weight: bold;"><%=total%></th>
                            </tr>
                        </tfoot>
                    </table>
                </div>
                <br/>
                <center><hr style="width: 85%" /></center>
                <div id="container" style="width: 100%; height: 500px; margin: 0 auto;"></div>
                <br/>
                <center><hr style="width: 85%" /></center>
                    <%}%>
                <br/>
            </fieldset>
        </form>
    </body>
</html>     
