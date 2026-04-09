<%@page import="java.util.Calendar"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page pageEncoding="UTF-8"%>
<html>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        ArrayList<String> salesTotalList = (ArrayList<String>) request.getAttribute("salesTotalList");
        long totalAmountCount = request.getAttribute("totalAmountCount") != null ? (Long) request.getAttribute("totalAmountCount") : 0L;
        String jsonText = request.getAttribute("jsonText") != null ? (String) request.getAttribute("jsonText") : "[]";
        String year = request.getAttribute("year") != null ? (String) request.getAttribute("year") : "0";
        String stat = (String) request.getSession().getAttribute("currentMode");
        String[] monthsArr = {"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"};
        DecimalFormat decimalFormat = new DecimalFormat("##,###,###,###.##");
        String align = null;
        String dir = null;
        String style = null;
        String lang, langCode, title, totalTitle, month, yearTitle, display, select;
        if (stat.equals("En")) {
            align = "center";
            dir = "LTR";
            style = "text-align:left";
            lang = "   &#1593;&#1585;&#1576;&#1610;    ";
            langCode = "Ar";
            title = "Sales Total Reprot";
            totalTitle = "Total Sales ";
            month = "Month";
            yearTitle = "Year";
            display = "Display Report";
            select = "Select";
        } else {
            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            lang = "English";
            langCode = "En";
            title = "تقرير أجمالي المبيعات";
            totalTitle = "أجمالي مبيعات";
            month = "الشهر";
            yearTitle = "السنة";
            display = "أعرض التقرير";
            select = "أختر";
        }
    %>
    <head>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css"/>
        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/icon.css"/>
        <link rel="stylesheet" type="text/css" href="jquery-easyui/demo/demo.css"/>
        <script type="text/javascript" src="js/json2.js"></script>
        <script type="text/javascript" src="js/highcharts-4.2.4.js"></script>
        <script type="text/javascript" src="jquery-ui/jquery-1.7.1.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.widget.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.drop.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.fold.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.mouse.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.slider.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <script type="text/javascript" src="js/wz_tooltip.js"></script>
        <script type="text/javascript" language="javascript">
            $(function () {
                $("#fromDate,#toDate").datepicker({
                    maxDate: "+d",
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: 'yy-mm-dd'
                });
            });
            /* preparing column chart */
            var chart;
            var chartCount;
            $(document).ready(function () {
                Highcharts.chart('container', {
                    chart: {
                        type: 'column'
                    },
                    title: {
                        text: 'Sales Total Amount'
                    },
                    xAxis: {
                        categories: [
                            'Jan',
                            'Feb',
                            'Mar',
                            'Apr',
                            'May',
                            'Jun',
                            'Jul',
                            'Aug',
                            'Sep',
                            'Oct',
                            'Nov',
                            'Dec'
                        ],
                        crosshair: true
                    },
                    yAxis: {
                        min: 0,
                        title: {
                            text: 'Sales'
                        }
                    },
                    tooltip: {
                        headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
                        pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
                                '<td style="padding:0"><b>{point.y}</b></td></tr>',
                        footerFormat: '</table>',
                        shared: true,
                        useHTML: true
                    },
                    plotOptions: {
                        column: {
                            pointPadding: 0.2,
                            borderWidth: 0
                        }
                    },
                    series: [{
                            name: 'Month',
                            data: <%=jsonText.replaceAll("\"", "")%>

                        }]
                });

            });
            /* -preparing column chart */
            function submitForm() {
                document.Stat.submit();
            }
        </script>
        <style>
            div.highcharts-tooltip td {
                white-space: nowrap;
                border: 0px;
            }
        </style>
    </head>
    <body>
        <form name="Stat" action="<%=context%>/ReportsServletThree" >
            <fieldset align=center class="set">
                <legend align="center"> 
                    <table dir=" <%=dir%>" align="<%=align%>">
                        <tr>
                            <td class="td">
                                <font color="blue" size="6"><%=title%></font>
                            </td>
                        </tr>
                    </table>
                </legend >
                <div align="left" style="color:blue;">

                </div>  
                <br/>
                <table class="blueBorder" align="center" dir="RTL" id="code" cellpadding="0" cellspacing="0" width="450" style="border-width:1px; border-color:white; display: block;" >
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="450">
                            <b><font size=3 color="white"> <%=yearTitle%></b>
                        </td>
                    </tr>
                    <tr>
                        <td bgcolor="#dedede" valign="middle">
                            <select style="width:190px" ID="year" name="year">
                                <option value=""><%=select%></option>
                                <%
                                    int thisYear = Calendar.getInstance().get(Calendar.YEAR);
                                    for (int i = thisYear - 10; i < thisYear + 10; i++) {
                                %>
                                <option value="<%=i%>" <%=Integer.valueOf(year) == i ? "selected" : ""%>><%=i%></option>
                                <%
                                    }
                                %>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td class="td" style="text-align: center;">
                            <input type="button" value="<%=display%>" onclick="submitForm()" class="button" style="width: 250px;"/>
                            <input type="hidden" name="op" value="viewSalesTotalByYear"/>
                        </td>
                    </tr>
                </table>
                <br/>
                <center>
                    <font size="3" color="red"><b> <%=totalTitle%> : <%=decimalFormat.format(totalAmountCount)%></b> </font>
                </center>
                <br><br>
                <center>
                    <div id="container" style="width: 1000px; height: 500px; margin: 0 auto"></div>
                    <br><br>
                    <table width="400" align="center" dir="RTL" cellpadding="0" cellspacing="0" style="margin-left: auto; margin-right: auto;">
                        <tr bgcolor="#C8D8F8">
                            <td>
                                <%=month%>
                            </td>
                            <td>
                                <%=totalTitle%>
                            </td>
                        </tr>
                        <%
                            for (int i = 0; i < salesTotalList.size(); i++) {
                        %>
                        <tr>
                            <td>
                                <%=monthsArr[i]%>
                            </td>
                            <td>
                                <%=decimalFormat.format(Long.valueOf(salesTotalList.get(i)))%>
                            </td>
                        </tr>      
                        <%
                            }
                        %>
                    </table>
                    <br/><br/>
                </center>
            </fieldset>
        </form>
    </body>
</html>     
