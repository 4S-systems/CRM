<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page pageEncoding="UTF-8"%>

<HTML>
    <%
        ArrayList<WebBusinessObject> usersList = (ArrayList<WebBusinessObject>) request.getAttribute("usersList");
        WebBusinessObject campaignWbo = (WebBusinessObject) request.getAttribute("campaignWbo");
        String type = (String) request.getAttribute("type");
        int totalUsersCount = 0;
        if (request.getAttribute("totalUsersCount") != null) {
            totalUsersCount = (Integer) request.getAttribute("totalUsersCount");
        }
        String jsonText = (String) request.getAttribute("jsonText");
        String stat = (String) request.getSession().getAttribute("currentMode");
        String align, dir, style, title, name, count, total, nonDistributed;
        if (stat.equals("En")) {
            align = "center";
            dir = "LTR";
            style = "text-align:left";
            title = "Clients Rates for Campaign ";
            name = "source".equals(type) ? "Source" : "Responsible";
            count = "Count";
            total = "Total";
            nonDistributed = "Non Distributed";
        } else {
            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            title = "نسب العملاء للحملة ";
            name = "source".equals(type) ? "المصدر" : "المسؤول";
            count = "عدد العملاء";
            total = "أجمالي";
            nonDistributed = "غير موزع";
        }
    %>
    <head>
        <script type="text/javascript" src="jquery-ui/jquery-1.7.1.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <SCRIPT type="text/javascript" src="js/json2.js"></SCRIPT>
        <script type="text/javascript" src="js/highcharts.js"></script>
        <script type="text/javascript">
            /* preparing pie chart */
            var chart = null;
            $(document).ready(function () {
                chart = new Highcharts.Chart({
                    chart: {
                        renderTo: 'containerPopup',
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
                    series: [{
                            type: 'pie',
                            data: <%=jsonText%>
                        }]
                });
            });
            /* -preparing pie chart */
        </script>
    </head>
    <body>
        <fieldset align=center class="set" style="width: 80%;">
            <legend align="center"> 
                <table dir=" <%=dir%>" align="<%=align%>">
                    <tr>
                        <td class="td">
                            <font color="blue" size="6"><%=title%><%=campaignWbo != null ? campaignWbo.getAttribute("campaignTitle") : ""%></font>
                        </td>
                    </tr>
                </table>
            </legend>
            <div id="containerPopup" style="height: 300px; margin: 0 ;"></div>
            <br />
            <%
                if (usersList != null) {
            %>
            <table width="600" align="<%=align%>" dir="<%=dir%>" cellpadding="0" cellspacing="0" >
                <tr bgcolor="#C8D8F8">
                    <td>
                        <%=name%>
                    </td>
                    <td>
                        <%=count%>
                    </td>
                </tr>
                <%
                    for (WebBusinessObject wbo : usersList) {
                %>
                <tr>
                    <td>
                        <%=wbo.getAttribute("name") != null ? wbo.getAttribute("name") : nonDistributed%>
                    </td>
                    <td>
                        <%=wbo.getAttribute("total")%>
                    </td>
                </tr>      
                <%
                    }
                %>
                <tr>
                    <td>
                        <%=total%>
                    </td>
                    <td>
                        <%=totalUsersCount%>
                    </td>
                </tr>
            </table>
            <%
                }
            %>
            <br/>
            <br/>
        </fieldset>
        <br/>
        <br/>
    </body>
</html>     
