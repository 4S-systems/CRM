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
        ArrayList<WebBusinessObject> employeesSalesAmountList = request.getAttribute("employeesSalesAmountList") != null ? (ArrayList<WebBusinessObject>) request.getAttribute("employeesSalesAmountList") : new ArrayList<WebBusinessObject>();
        ArrayList<WebBusinessObject> employeesSalesCountList = request.getAttribute("employeesSalesCountList") != null ? (ArrayList<WebBusinessObject>) request.getAttribute("employeesSalesCountList") : new ArrayList<WebBusinessObject>();
                
        long totalAmountCount = request.getAttribute("totalAmountCount") != null ? (Long) request.getAttribute("totalAmountCount") : 0L;
        long totalCount = request.getAttribute("totalAmountCount") != null ? (Long) request.getAttribute("totalCount") : 0L;
        String jsonAmountText = (String) request.getAttribute("jsonAmountText");
        String jsonCountText = (String) request.getAttribute("jsonCountText");
        String stat = (String) request.getSession().getAttribute("currentMode");
        DecimalFormat decimalFormat = new DecimalFormat("###,###.##");
        String align = null;
        String dir = null;
        String style = null;
        String lang, langCode, title, totalAmountTitle, totalCountTitle, employeeName, fromDate, toDate, display;
        if (stat.equals("En")) {
            align = "center";
            dir = "LTR";
            style = "text-align:left";
            lang = "   &#1593;&#1585;&#1576;&#1610;    ";
            langCode = "Ar";
            title = "Sales Chart Report";
            totalAmountTitle = "Total Sales ";
            employeeName = "Employee";
            totalCountTitle = "Total Units";
            fromDate = "From Date";
            toDate = "To Date";
            display = "Display";
        } else {
            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            lang = "English";
            langCode = "En";
            title = "نسب توزيع المبيعات";
            totalAmountTitle = "أجمالي مبيعات";
            employeeName = "الموظف";
            totalCountTitle = "أجمالي وحدات";
            fromDate = "من تاريخ";
            toDate = "ألي تاريخ";
            display = "أعرض التقرير";
        }
    %>
    <head>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css"/>
        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/icon.css"/>
        <link rel="stylesheet" type="text/css" href="jquery-easyui/demo/demo.css"/>
        <script type="text/javascript" src="js/json2.js"></script>
        <script type="text/javascript" src="js/highcharts.js"></script>
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
            /* preparing pie chart */
            var chart;
            var chartCount;
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
                            color: 'red',
                            fontSize: '20px',
                            fontWeight: 'bold'
                        },
                        items: [{
                                html: 'أجمالي المبيعات',
                                style: {
                                    left: '0px',
                                    top: '0px'
                                }},
                            {
                                html: 'أجمالي الوحدات',
                                style: {
                                    left: '600px',
                                    top: '0px'
                                }}]
                    },
                    series: [{
                            type: 'pie',
                            data: <%=jsonAmountText%>,
                            center: ['25%']
                        }, {
                            type: 'pie',
                            data: <%=jsonCountText%>,
                            center: ['75%']
                        }]
                });

            });
            /* -preparing pie chart */

            function changePage(url) {
                window.navigate(url);
            }

            function reloadAE(nextMode) {

                var url = "<%=context%>/ajaxGetItrmName?key=" + nextMode;
                if (window.XMLHttpRequest)
                {
                    req = new XMLHttpRequest();
                }
                else if (window.ActiveXObject)
                {
                    req = new ActiveXObject("Microsoft.XMLHTTP");
                }
                req.open("Post", url, true);
                req.onreadystatechange = callbackFillreload;
                req.send(null);

            }
            function cancelForm() {
                document.Stat.action = "<%=context%>/SearchServlet?op=Projects";
                document.Stat.submit();
            }
            function callbackFillreload() {
                if (req.readyState === 4)
                {
                    if (req.status === 200)
                    {
                        window.location.reload();
                    }
                }
            }
            function submitForm() {
                document.Stat.action = "<%=context%>/ReportsServletThree?op=getSalesChartReport";
                document.Stat.submit();
            }
        </script>
    </head>
    <body>
        <form name="Stat" action="post">
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
                <table class="blueBorder" align="center" dir="RTL" id="code" cellpadding="0" cellspacing="0" width="650" style="border-width:1px; border-color:white; display: block;" >
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="50%">
                            <b><font size=3 color="white"> <%=fromDate%></b>
                        </td>
                        <td  class="blueBorder blueHeaderTD" style="font-size:18px;" width="50%">
                            <b><font size=3 color="white"> <%=toDate%></b>
                        </td>
                    </tr>
                    <tr>
                        <td bgcolor="#dedede" valign="middle">
                            <input type="TEXT" style="width:190px" ID="fromDate" name="fromDate" size="20" maxlength="100" readonly="true"
                                   value="<%=request.getAttribute("fromDate") == null ? "" : request.getAttribute("fromDate")%>"/>
                        </td>
                        <td bgcolor="#dedede" valign="middle">
                            <input type="TEXT" style="width:190px" ID="toDate" name="toDate" size="20" maxlength="100" readonly="true"
                                   value="<%=request.getAttribute("toDate") == null ? "" : request.getAttribute("toDate")%>"/>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" class="td" style="text-align: center;">
                            <input type="button" value="<%=display%>" onclick="submitForm()" class="button"/>
                            <input type="hidden" name="op" value="getSalesChartReport"/>
                        </td>
                    </tr>
                </table>
                <br/>
                <center>
                    <font size="3" color="red" style="margin-left: 250px; float: left;"><b> <%=totalAmountTitle%> : <%=decimalFormat.format(totalAmountCount)%></b> </font>
                    <font size="3" color="red" style="margin-right: 350px; float: right;"><b> <%=totalCountTitle%> : <%=decimalFormat.format(totalCount)%></b> </font>
                </center>
                <br><br>
                <center>
                    <div id="container" style="width: 1200px; height: 300px; margin: 0 auto"></div>
                    <br><br>
                    <table width="400" align="left" dir="RTL" cellpadding="0" cellspacing="0" style="margin-left: 170px;">
                        <tr bgcolor="#C8D8F8">
                            <td>
                                <%=employeeName%>
                            </td>
                            <td>
                                <%=totalAmountTitle%>
                            </td>
                        </tr>
                        <%
                            for (WebBusinessObject wbo : employeesSalesAmountList) {
                        %>
                        <tr>
                            <td>
                                <%=wbo.getAttribute("employeeName")%>
                            </td>
                            <td>
                                <%=wbo.getAttribute("totalValue") != null ? decimalFormat.format(decimalFormat.parse((String) wbo.getAttribute("totalValue"))) : 0%>
                            </td>
                        </tr>      
                        <%
                            }
                        %>
                    </table>
                    <table width="400" align="right" dir="RTL" cellpadding="0" cellspacing="0" style="margin-right: 170px;">
                        <tr bgcolor="#C8D8F8">
                            <td>
                                <%=employeeName%>
                            </td>
                            <td>
                                <%=totalCountTitle%>
                            </td>
                        </tr>
                        <%
                            for (WebBusinessObject wbo : employeesSalesCountList) {
                        %>
                        <tr>
                            <td>
                                <%=wbo.getAttribute("employeeName")%>
                            </td>
                            <td>
                                <%=wbo.getAttribute("totalNo") != null ? decimalFormat.format(decimalFormat.parse((String) wbo.getAttribute("totalNo"))) : 0%>
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
