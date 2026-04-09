
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page pageEncoding="UTF-8"%>

<html>
    <%

        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();

        ArrayList<WebBusinessObject> leadsCountList = (ArrayList<WebBusinessObject>) request.getAttribute("leadsCountList");
        int totalLeadsCount = (Integer) request.getAttribute("totalLeadsCount");
        String leadsJsonText = (String) request.getAttribute("leadsJsonText");

        ArrayList<WebBusinessObject> customersCountList = (ArrayList<WebBusinessObject>) request.getAttribute("customersCountList");
        int totalCustomersCount = (Integer) request.getAttribute("totalCustomersCount");
        String customersJsonText = (String) request.getAttribute("customersJsonText");
        Map<String, String> tradesMap = (HashMap<String, String>) request.getAttribute("tradesMap");

        String stat = (String) request.getSession().getAttribute("currentMode");
        String align, dir, style, title, totalClients, clientsCountStr, jobStr, leads, customers;
        if (stat.equals("En")) {
            align = "center";
            dir = "LTR";
            style = "text-align:left";
            title = "Customer Jobs Statistics";
            totalClients = "Total Customers";
            jobStr = "Job";
            clientsCountStr = "Customers Count";
            leads = "Potential Customers";
            customers = "Current Customers";
        } else {
            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            title = "أحصائيات مهن العملاء";
            totalClients = "أجمالي العملاء";
            jobStr = "المهنة";
            clientsCountStr = "عدد العملاء";
            leads = "العملاء المحتملين";
            customers = "العملاء الحاليين";
        }
    %>
    <head>
        <script type="text/javascript" src="js/json2.js"></script>
        <script type="text/javascript" src="js/jquery.min.js"></script>
        <script type="text/javascript" src="js/highcharts.js"></script>
        <script type="text/javascript">

            /* preparing pie chart */
            var chart;
            $(document).ready(function () {
                chart = new Highcharts.Chart({
                    chart: {
                        renderTo: 'container',
                        plotBackgroundColor: null,
                        plotBorderWidth: null,
                        plotShadow: false
                    },
                    title: {
                        text: null
                    },
                    tooltip: {
                        formatter: function () {
                            return '<b>' + this.point.name + '</b>: ' + '%' + Highcharts.numberFormat(this.percentage, 2);
                        }
                    },
                    plotOptions: {
                        pie: {
                            allowPointSelect: true,
                            cursor: 'pointer',
                            dataLabels: {
                                enabled: true,
                                color: '#000000',
                                connectorColor: '#000000',
                                formatter: function () {
                                    return '<b>' + this.point.name + '</b>: ' + '%' + Highcharts.numberFormat(this.percentage, 2);
                                }
                            }
                        }
                    },
                    labels: {
                        style: {
                            color: 'blue',
                            fontSize: '20px',
                            fontWeight: 'bold'
                        },
                        items: [{
                                html: '<%=leads%>',
                                style: {
                                    left: '300px',
                                    top: '0px'
                                }},
                            {
                                html: '<%=customers%>',
                                style: {
                                    left: '800px',
                                    top: '0px'
                                }}]
                    },
                    series: [{
                            type: 'pie',
                            data: <%=leadsJsonText%>,
                            center: ['25%']
                        }, {
                            type: 'pie',
                            data: <%=customersJsonText%>,
                            center: ['75%']
                        }]
                });
            });
            /* -preparing pie chart */
            
            function exportToExcel(type){
            
            var url="<%=context%>/ReportsServletThree?op=getClientJobStatisticsExcel&type="+type;
             window.open(url, "_blank", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width=700, height=700");
           
            }

        </script>
    </head>
    <body>
        <form name="JOB_RATES" action="post">
            <fieldset align=center class="set" style="width: 95%;">
                <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <tr>
                        <td width="100%" class="titlebar">
                            <font color="#005599" size="4">
                            <%=title%>
                            </font>
                        </td>
                    </tr>
                </table>
                <br/>
                <br/><br/>
                <center>
                    <div id="container" style="width: 1000px; height: 300px; margin: 0 auto;"></div>
                    <br/><br/>
                    <table width="400" align="<%=align%>" dir="<%=dir%>" cellpadding="0" cellspacing="0" style="float: left; margin-left: 10%; margin-bottom: 25px;">
                        <tr><td  style="border:0px;" colspan="2">
                                <img title="Export To Excel" onClick="JavaScript:exportToExcel('customers');" src="images/excelIcon.png" width="12%"/><br></br>
                            </td>
                        </tr>
                        <tr bgcolor="#98cdfe">
                            <td style="font-size: 18px;">
                                <%=totalClients%>
                            </td>
                            <td style="font-size: 18px;">
                                <%=totalLeadsCount%>
                            </td>
                        </tr>
                        <tr bgcolor="#c6e1f9">
                            <td>
                                <%=jobStr%>
                            </td>
                            <td>
                                <%=clientsCountStr%>
                            </td>
                        </tr>
                        <%
                            for (WebBusinessObject wbo : leadsCountList) {
                        %>
                        <tr>
                            <td>
                                <%=wbo.getAttribute("jobName")%>
                            </td>
                            <td>
                                <%
                                    if (tradesMap.containsKey(wbo.getAttribute("jobName"))) {
                                %>
                                <a target="tradeClients" href="ReportsServletThree?op=getTradeClients&tradeID=<%=tradesMap.get(wbo.getAttribute("jobName"))%>&isCustomer=false">
                                    <%=wbo.getAttribute("clientCount")%>
                                </a>
                                <%
                                } else {
                                %>
                                <%=wbo.getAttribute("clientCount")%>
                                <%
                                    }
                                %>
                            </td>
                        </tr>
                        <%
                            }
                        %>
                    </table>
                    <table width="400" align="<%=align%>" dir="<%=dir%>" cellpadding="0" cellspacing="0" style="float: right; margin-right: 10%; margin-bottom: 25px;">
                        <tr><td  style="border:0px;" colspan="2">
                                <img title="Export To Excel" onClick="JavaScript:exportToExcel('leads');" src="images/excelIcon.png" width="12%"/><br></br>
                            </td>
                        </tr>
                        <tr bgcolor="#98cdfe">
                            <td style="font-size: 18px;">
                                <%=totalClients%>
                            </td>
                            <td style="font-size: 18px;">
                                <%=totalCustomersCount%>
                            </td>
                        </tr>
                        <tr bgcolor="#c6e1f9">
                            <td>
                                <%=jobStr%>
                            </td>
                            <td>
                                <%=clientsCountStr%>
                            </td>
                        </tr>
                        <%
                            for (WebBusinessObject wbo : customersCountList) {
                        %>
                        <tr>
                            <td>
                                <%=wbo.getAttribute("jobName")%>
                            </td>
                            <td>
                                <%
                                    if (tradesMap.containsKey(wbo.getAttribute("jobName"))) {
                                %>
                                <a target="tradeClients" href="ReportsServletThree?op=getTradeClients&tradeID=<%=tradesMap.get(wbo.getAttribute("jobName"))%>&isCustomer=true">
                                    <%=wbo.getAttribute("clientCount")%>
                                </a>
                                <%
                                } else {
                                %>
                                <%=wbo.getAttribute("clientCount")%>
                                <%
                                    }
                                %>
                            </td>
                        </tr>
                        <%
                            }
                        %>
                    </table>
                    <br/>
                    <table width="400" align="<%=align%>" dir="<%=dir%>" cellpadding="0" cellspacing="0" >
                        <tr>
                            <td class="td">
                                &nbsp;
                            </td>
                        </tr>
                    </table>
                </center>
            </fieldset>
        </form>
    </body>
</html>