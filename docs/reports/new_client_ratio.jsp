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

        ArrayList<WebBusinessObject> complaintsCounts = (ArrayList<WebBusinessObject>) request.getAttribute("complaintsCounts");
        int totalComplaintsCount = 0;
        if (request.getAttribute("totalComplaintsCount") != null) {
            totalComplaintsCount = (Integer) request.getAttribute("totalComplaintsCount");
        }
        String jsonText = (String) request.getAttribute("jsonText");

        String fromDateS = "";
        if (request.getAttribute("fromDate") != null) {
            fromDateS = (String) request.getAttribute("fromDate");
        }
        String toDateS = "";
        if (request.getAttribute("toDate") != null) {
            toDateS = (String) request.getAttribute("toDate");
        }

        String stat = (String) request.getSession().getAttribute("currentMode");
        String align = null;
        String dir = null;
        String style = null;
        String title, complaintsCountStr, complaintStr, fromDate, toDate, display, project, ticketTypeTitle;

        if (stat.equals("En")) {

            align = "center";
            dir = "LTR";
            style = "text-align:left";
            title = "Performance Analysis For Project";
            complaintStr = "Statistical Element";
            complaintsCountStr = "Total";
            fromDate = "Start Date";
            toDate = "End Date";
            display = "Display";
            project = "Project";
            ticketTypeTitle = "Ticket Type";
        } else {

            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            title = "النسب اﻷحصائية لحالة العملاء الجدد";
            complaintStr = "العنصر أﻷحصائي";
            complaintsCountStr = "العدد الكلي";
            fromDate = "من تاريخ";
            toDate = "ألي تاريخ";
            display = "أعرض التقرير";
            project = "المشروع";
            ticketTypeTitle = "النوع";
        }
    %>

    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Equipment Statistics</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
        <SCRIPT type="text/javascript" src="js/json2.js"></SCRIPT>
        <script type="text/javascript" src="js/highcharts.js"></script>
        <script type="text/javascript" src="jquery-ui/jquery-1.7.1.js"></script>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css">
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.widget.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.drop.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.fold.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.mouse.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.slider.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/icon.css">
        <link rel="stylesheet" type="text/css" href="jquery-easyui/demo/demo.css">
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <script type="text/javascript">
            $(function () {
                $("#fromDate,#toDate").datepicker({
                    maxDate: "+d",
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: 'yy/mm/dd'
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
        </script>

    </HEAD>
    <script language="javascript" type="text/javascript">
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
        function submitForm()
        {
            document.Stat.action = "<%=context%>/ReportsServletTwo?op=getNewClientRatio";
            document.Stat.submit();
        }
    </script>
    <BODY>
        <script type="text/javascript" src="js/wz_tooltip.js"></script>
        <FORM name="Stat" action="post">
            <DIV align="left" STYLE="color:blue;">
                <input type="button"  value="<%=display%>"  onclick="submitForm()" class="button">
                <input type="hidden" name="op" value="getNewClientRatio">
            </DIV>  
            <br><br>
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
                            <b><font size=3 color="white"> <%=fromDate%></b>
                        </TD>
                        <TD  class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="325px">
                            <b><font size=3 color="white"> <%=toDate%></b>
                        </TD>
                    </TR>
                    <TR>
                        <td  bgcolor="#dedede" valign="middle">
                            <input type="TEXT" style="width:190px" ID="fromDate" name="fromDate" size="20" maxlength="100" readonly="true"
                                   value="<%=fromDateS%>"/>
                        </td>
                        <td  bgcolor="#dedede" valign="middle">
                            <input type="TEXT" style="width:190px" ID="toDate" name="toDate" size="20" maxlength="100" readonly="true"
                                   value="<%=toDateS%>"/>
                        </td>
                    </TR>
                </TABLE>
                <BR>
                <center> <font size="3" color="red"><b> <%=complaintsCountStr%> : <%=totalComplaintsCount%></b> </font></center>
                <br><br>
                <CENTER>
                    <div id="container" style="width: 600px; height: 300px; margin: 0 auto"></div>
                    <br><br>
                    <%
                        if (complaintsCounts != null) {
                    %>
                    <TABLE WIDTH="400" ALIGN="<%=align%> " DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" >
                        <TR  bgcolor="#C8D8F8">
                            <TD>
                                <%=complaintStr%>
                            </TD>
                            <TD>
                                <%=complaintsCountStr%>
                            </TD>
                        </TR>
                        <%
                            for (WebBusinessObject wbo : complaintsCounts) {
                        %>
                        <TR>
                            <TD>
                                <%=wbo.getAttribute("statusNameAr")%>
                            </TD>
                            <TD>
                                <%=wbo.getAttribute("total")%>
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
