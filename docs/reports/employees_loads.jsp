<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*, com.tracker.common.*, java.util.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants, com.silkworm.persistence.relational.*"%>
<%@ page import="com.silkworm.common.TimeServices, java.lang.Math"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page pageEncoding="UTF-8"%>

<HTML>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        List<WebBusinessObject> loads = (List) request.getAttribute("loads");

        String stat = (String) request.getSession().getAttribute("currentMode");
        String lang, langCode, title;
        if (stat.equals("En")) {
            lang = "   &#1593;&#1585;&#1576;&#1610;    ";
            langCode = "Ar";
            title = "Employees Load";
        } else {
            lang = "English";
            langCode = "En";
            title = "أحمال الموظفين";
        }
    %>

    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Employees Load</TITLE>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css">

        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="js/jquery.min.js"></script>
        <script type="text/javascript" src="js/highcharts.js"></script>
        <script type="text/javascript">
            <%
                if (request.getAttribute("redirect") != null) {
            %>
                    location.href = "<%=context%>/EmployeesLoadsServlet?op=employeesLoads";
            <%
                }
            %>
            /* preparing bar chart */
            var chart;
            $(document).ready(function() {
                chart = new Highcharts.Chart({
                    chart: {
                        renderTo: 'container',
                        defaultSeriesType: 'bar'
                    },
                    title: {
                        text: 'الطلبات الغير منتهيه'
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
                        categories: [<% if (loads != null) {
                                for (int i = 0; i < loads.size(); i++) {
                                    WebBusinessObject wbo_ = loads.get(i);
                                    if (i > 0) {
                                        out.write(",");
                                    }
                                    out.write("'" + (String) wbo_.getAttribute("currentOwnerFullName") + "'");
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
                            text: 'عدد الطلبات',
                            align: 'high'
                        }
                    },
                    tooltip: {
                        formatter: function() {
                            return ' ' + 'طلبات' + ' ' + this.y + ' ';
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
                            name: 'الطلبات',
                            data: [<% if (loads != null) {
                                    for (int i = 0; i < loads.size(); i++) {
                                        WebBusinessObject wbo_ = loads.get(i);
                                        if (i > 0) {
                                            out.write(",");
                                        }
                                        out.write((String) wbo_.getAttribute("noTicket"));
                                    }
                                }%>]
                        }]
                });
            });
            /* -preparing bar chart */

        </script>

    </HEAD>
    <script language="javascript" type="text/javascript">
    </script>
    <style>
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

    <BODY>
        <FORM name="EmployeesLoads" method="post">
            <DIV align="left" STYLE="color:blue;">
                <input type="button"  value="<%=lang%>"  onclick="reloadAE('<%=langCode%>')" class="button">
            </DIV>  
            <br>
            <FIELDSET class="set" style="width:85%;border-color: #006699">
                <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <tr>
                        <td width="100%" class="titlebar">
                            <font color="#005599" size="4"><%=title%></font>
                        </td>
                    </tr>
                </table>
                <br/>
                <br>
                <center><hr style="width: 85%" /></center>
                <div id="container" style="width: 100%; height: 50%; margin: 0 auto"></div>
                <br/>
                <center><hr style="width: 85%" /></center>
                <br/>
            </FIELDSET>

        </FORM>
    </BODY>
</HTML>     
