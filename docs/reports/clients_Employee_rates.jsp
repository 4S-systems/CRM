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

        ArrayList<WebBusinessObject> clientsRatesCounts = (ArrayList<WebBusinessObject>) request.getAttribute("clientsRatesCounts");
        ArrayList<WebBusinessObject> EmployeesList = (ArrayList<WebBusinessObject>) request.getAttribute("EmployeeList");
        String user = request.getAttribute("userId").toString();

        int totalClientsCount = 0;
        if (request.getAttribute("totalClientsCount") != null) {
            totalClientsCount = (Integer) request.getAttribute("totalClientsCount");
        }
        String jsonText = (String) request.getAttribute("jsonText");
        String cMode = (String) request.getSession().getAttribute("currentMode");
        String stat = cMode;
        String align = null;
        String dir = null;
        String style = null;
        String emp = null;
        String lang, langCode, title, clientsCountStr, rateStr, display;

        if (stat.equals("En")) {

            align = "center";
            dir = "LTR";
            style = "text-align:left";
            lang = "   &#1593;&#1585;&#1576;&#1610;    ";
            langCode = "Ar";
            title = "Clients Rates";
            rateStr = "Rate";
            clientsCountStr = "Clients Count";
            display = "View Report";
            emp = "Employee Name";
        } else {
            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            lang = "English";
            langCode = "En";
            title = "نسب العملاء ";
            rateStr = "المعدلات";
            clientsCountStr = "عدد العملاء";
            display = "عرض التقرير";
            emp = "اسم الموظف";
        }
    %>

    <head>
        <link rel="stylesheet" type="text/css" href="CSS.css"/>
        <link rel="stylesheet" type="text/css" href="Button.css"/>
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
        <script type="text/javascript">
            $(function () {
                $("#startDate,#endDate").datepicker({
                    maxDate: "+d",
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: 'yy-mm-dd'
                });
            });
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
                    series: [{
                            type: 'pie',
                            data: <%=jsonText%>
                        }]
                });
            });
            /* -preparing pie chart */
            function changePage(url) {
                window.navigate(url);
            }
            function reloadAE(nextMode) {
                var url = "<%=context%>/ajaxGetItrmName?key=" + nextMode;
                if (window.XMLHttpRequest) {
                    req = new XMLHttpRequest();
                } else if (window.ActiveXObject) {
                    req = new ActiveXObject("Microsoft.XMLHTTP");
                }
                req.open("Post", url, true);
                req.onreadystatechange = callbackFillreload;
                req.send(null);
            }
            function submitForm() {
                document.Stat.action = "<%=context%>/ReportsServletThree?op=clientEmployeeRateReport&userID=" + $("#userID").val();
                document.Stat.submit();
            }
            function getProPDFUrl(){
                var url = "<%=context%>/ProjectServlet?op=getClientsRatesPDF";
                $('#briefPDF').attr("href", url);
            }
        </script>
    </head>
    <body>
        <script type="text/javascript" src="js/wz_tooltip.js"></script>
        <form name="Stat" method="post">
            <div align="left" STYLE="color:blue;">
                <input type="button" value="<%=display%>" onclick="submitForm()" class="button">
                <!--<a id="briefPDF" href="JavaScript: getProPDFUrl();">
                    <img style="margin: 3px" src="images/customer-service.jpg" width="24" height="24"/>
                </a>-->
                <input type="hidden" name="op" value="clientEmployeeRateReport">
            </div>  
            <br/><br/>

            <FIELDSET align=center class="set" >
                <legend align="center"> 
                    <table dir=" <%=dir%>" align="<%=align%>">
                        <tr>
                            <td class="td">
                                <font color="blue" size="6"><%=title%></font>
                            </td>
                        </tr>
                    </table>
                </legend>

                <TABLE class="blueBorder" ALIGN="CENTER" DIR="RTL" ID="code" CELLPADDING="0" CELLSPACING="0" width="650" STYLE="border-width:1px;border-color:white;display: block;" >
                    <TR>
                        <TD  class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="325px">
                            <b><font size=3> <%=emp%></b>
                        </TD>
                        <td  bgcolor="#dedede" valign="middle" width="325px">
                            <select style="float: right;width: 230px; font-size: 14px;" id="userID">
                                <sw:WBOOptionList wboList="<%=EmployeesList%>" displayAttribute="fullName" valueAttribute="userId" scrollToValue='<%=user%>'/>                               
                            </select>
                        </TD>
                    </TR>
                </TABLE>

                <br>
                <center> <font size="3" color="red"><b> <%=clientsCountStr%> : <%=totalClientsCount%></b> </font></center>
                <br><br>

                <CENTER>
                    <div id="container" style="width: 600px; height: 300px; margin: 0 auto"></div>
                    <br><br>

                    <%
                        if (clientsRatesCounts != null) {
                    %>
                    <TABLE WIDTH="400" ALIGN="<%=align%> " DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" >
                        <TR  bgcolor="#C8D8F8">
                            <TD>
                                <%=rateStr%>
                            </TD>
                            <TD>
                                <%=clientsCountStr%>
                            </TD>
                        </TR>

                        <%
                            for (WebBusinessObject wbo : clientsRatesCounts) {
                        %>
                        <TR>
                            <TD>
                                <%=wbo.getAttribute("rateName")%>
                            </TD>
                            <TD>
                                <%=wbo.getAttribute("clientCount")%>
                            </TD>
                        </TR>      
                        <%
                            }
                        %>
                    </TABLE>
                    <%
                        }
                    %>

                    <BR>
                    <TABLE WIDTH="400" ALIGN="<%=align%> " DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" >
                        <TR>
                            <TD CLASS="td">
                                &nbsp;
                            </TD>
                        </TR>
                    </TABLE>
                </CENTER>
            </FIELDSET>
        </FORM>
    </BODY>
</HTML>