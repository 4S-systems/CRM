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
        ArrayList<WebBusinessObject> campaignClientsCounts = (ArrayList<WebBusinessObject>) request.getAttribute("campaignClientsCounts");
        ArrayList<WebBusinessObject> employees = (ArrayList<WebBusinessObject>) request.getAttribute("employees");
        int totalClientsCount = 0;
        if (request.getAttribute("totalClientsCount") != null) {
            totalClientsCount = (Integer) request.getAttribute("totalClientsCount");
        }
        String jsonText = (String) request.getAttribute("jsonText");
        String startDateVal = request.getAttribute("startDate") == null ? "" : (String) request.getAttribute("startDate");
        String endDateVal = request.getAttribute("endDate") == null ? "" : (String) request.getAttribute("endDate");
        String employeeID = request.getAttribute("employeeID") == null ? "" : (String) request.getAttribute("employeeID");

        String stat = (String) request.getSession().getAttribute("currentMode");
        String align = null;
        String dir = null;
        String style = null;
        String lang, langCode, title, clientsCountStr, campaignStr, startDate, endDate, display, employee;
        if (stat.equals("En")) {
            align = "center";
            dir = "LTR";
            style = "text-align:left";
            lang = "   &#1593;&#1585;&#1576;&#1610;    ";
            langCode = "Ar";
            title = "Agent's Ratio per Campaigns";
            campaignStr = "Campaign";
            clientsCountStr = "Clients Count";
            startDate = "Start Date";
            endDate = "End Date";
            display = "Display";
            employee = "Employee";
        } else {
            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            lang = "English";
            langCode = "En";
            title = "نسب أستحواذ الموظفين";
            campaignStr = "الحملة";
            clientsCountStr = "عدد العملاء";
            startDate = "من تاريخ";
            endDate = "ألي تاريخ";
            display = "أعرض التقرير";
            employee = "الموظف";
        }
    %>
    <head>
        <link rel="stylesheet" type="text/css" href="CSS.css"/>
        <link rel="stylesheet" type="text/css" href="Button.css"/>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css"/>
        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/icon.css"/>
        <link rel="stylesheet" type="text/css" href="jquery-easyui/demo/demo.css"/>
        <link rel="stylesheet" href="css/chosen.css"/>

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
        <script src="js/chosen.jquery.js" type="text/javascript"></script>
        <script src="js/docsupport/prism.js" type="text/javascript" charset="utf-8"></script>
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
                document.Stat.action = "<%=context%>/ReportsServletThree?op=campaignAgentClientsReport";
                document.Stat.submit();
            }
        </script>
    </head>
    <body>
        <script type="text/javascript" src="js/wz_tooltip.js"></script>
        <form name="Stat" action="post">
            <div align="left" STYLE="color:blue;">
                <input type="button" value="<%=display%>" onclick="submitForm()" class="button">
                <input type="hidden" name="op" value="campaignAgentClientsReport">
            </div>  
            <br/><br/>
            <fieldset align=center class="set" >
                <legend align="center"> 
                    <table dir=" <%=dir%>" align="<%=align%>">
                        <tr>
                            <td class="td">
                                <font color="blue" size="6"><%=title%></font>
                            </td>
                        </tr>
                    </table>
                </legend>
                <table class="blueBorder" align="center" dir="rtl" id="code" cellpadding="0" cellspacing="0" width="650" style="border-width: 1px; border-color: white; display: block;">
                    <tr>
                        <td  class="blueBorder blueHeaderTD" style="font-size:18px;" width="325px">
                            <b><font size=3 color="white"> <%=startDate%></b>
                        </td>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="325px">
                            <b><font size=3 color="white"> <%=endDate%></b>
                        </td>
                    </tr>
                    <tr>
                        <td bgcolor="#dedede" valign="middle">
                            <input type="TEXT" style="width:190px" ID="startDate" name="startDate" size="20" maxlength="100" readonly="true"
                                   value="<%=startDateVal%>"/>
                        </td>
                        <td  bgcolor="#dedede" valign="middle">
                            <input type="TEXT" style="width:190px" ID="endDate" name="endDate" size="20" maxlength="100" readonly="true"
                                   value="<%=endDateVal%>"/>
                        </td>
                    </tr>
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" colspan="2">
                            <b><font size=3 color="white"> <%=employee%></b>
                        </td>
                    </tr>
                    <tr>
                        <td bgcolor="#dedede" valign="middle" colspan="2">
                            <select id="employeeID" name="employeeID" style="width: 200px;" class="chosen-select-user">
                                <sw:WBOOptionList wboList="<%=employees%>" displayAttribute="fullName" valueAttribute="userId" scrollToValue="<%=employeeID%>"/>
                            </select>
                        </td>
                    </tr>
                </table>
                <br/>
                <center> <font size="3" color="red"><b> <%=clientsCountStr%> : <%=totalClientsCount%></b> </font></center>
                <br/><br/>
                <center>
                    <div id="container" style="width: 600px; height: 300px; margin: 0 auto"></div>
                    <br/><br/>
                    <%
                        if (campaignClientsCounts != null) {
                    %>
                    <table width="400" align="<%=align%> " dir="<%=dir%>" cellpadding="0" cellspacing="0" >
                        <tr  bgcolor="#C8D8F8">
                            <td>
                                <%=campaignStr%>
                            </td>
                            <td>
                                <%=clientsCountStr%>
                            </td>
                        </tr>
                        <%
                            for (WebBusinessObject wbo : campaignClientsCounts) {
                        %>
                        <tr>
                            <td>
                                <a href="<%=context%>/ClientServlet?op=getEmployeeClientsWithCampaign&employeeID=<%=employeeID%>&campaignID=<%=wbo.getAttribute("campaignID")%>&beginDate=<%=startDateVal%>&endDate=<%=endDateVal%>"><%=wbo.getAttribute("campaignTitle")%></a>
                            </td>
                            <td>
                                <a href="<%=context%>/ClientServlet?op=getEmployeeClientsWithCampaign&employeeID=<%=employeeID%>&campaignID=<%=wbo.getAttribute("campaignID")%>&beginDate=<%=startDateVal%>&endDate=<%=endDateVal%>"><%=wbo.getAttribute("clientCount")%></a>
                            </td>
                        </tr>      
                        <%
                            }
                        %>
                    </table>
                    <%
                        }
                    %>
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
        <script>
            var config = {
                '.chosen-select-user': {no_results_text: 'No user was this name!'}
            };
            for (var selector in config) {
                $(selector).chosen(config[selector]);
            }
        </script>
    </body>
</html>     
