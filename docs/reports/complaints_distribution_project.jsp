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

        ArrayList<WebBusinessObject> complaintsDistributionCounts = (ArrayList<WebBusinessObject>) request.getAttribute("complaintsDistributionCounts");
        ArrayList<WebBusinessObject> projectPerformanceCounts = (ArrayList<WebBusinessObject>) request.getAttribute("projectPerformanceCounts");
        ArrayList<WebBusinessObject> projectsList = (ArrayList<WebBusinessObject>) request.getAttribute("projectsList");
        ArrayList<WebBusinessObject> ticketTypes = (ArrayList<WebBusinessObject>) request.getAttribute("ticketTypes");
        int totalComplaintsCount = 0;
        if (request.getAttribute("totalComplaintsCount") != null) {
            totalComplaintsCount = (Integer) request.getAttribute("totalComplaintsCount");
        }
        int totalPerformanceCount = 0;
        if (request.getAttribute("totalPerformanceCount") != null) {
            totalPerformanceCount = (Integer) request.getAttribute("totalPerformanceCount");
        }
        String projectID = "";
        if (request.getAttribute("projectID") != null) {
            projectID = (String) request.getAttribute("projectID");
        }

        String ticketType = "";
        if (request.getAttribute("ticketType") != null) {
            ticketType = (String) request.getAttribute("ticketType");
        }
        String jsonText = (String) request.getAttribute("jsonText");
        String jsonPerformanceText = (String) request.getAttribute("jsonPerformanceText");

        String cMode = (String) request.getSession().getAttribute("currentMode");
        String stat = cMode;
        String align = null;
        String dir = null;
        String style = null;
        String title, complaintsCountStr, complaintStr, startDate, endDate, display, project, ticketTypeTitle;

        if (stat.equals("En")) {

            align = "center";
            dir = "LTR";
            style = "text-align:left";
            title = "Statistical Analysis For Project's Complaints";
            complaintStr = "Statistical Element";
            complaintsCountStr = "Total";
            startDate = "Start Date";
            endDate = "End Date";
            display = "Display";
            project = "Project";
            ticketTypeTitle = "Ticket Type";
        } else {

            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            title = "التحليل الاحصائي لشكاوي المشروع";
            complaintStr = "العنصر أﻷحصائي";
            complaintsCountStr = "العدد الكلي";
            startDate = "من تاريخ";
            endDate = "ألي تاريخ";
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
        <link rel="stylesheet" href="css/chosen.css"/>
        <script src="js/chosen.jquery.js" type="text/javascript"></script>
        <script src="js/docsupport/prism.js" type="text/javascript" charset="utf-8"></script>
        <script type="text/javascript">
            $(function() {
                $("#startDate,#endDate").datepicker({
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
                                html: '',
                                style: {
                                    left: '0px',
                                    top: '0px'
                                }},
                            {
                                html: '',
                                style: {
                                    left: '600px',
                                    top: '0px'
                                }}]
                    },
                    series: [{
                            type: 'pie',
                            data: <%=jsonText%>,
                            center: ['25%']
                        }, {
                            type: 'pie',
                            data: <%=jsonPerformanceText%>,
                            center: ['75%']
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
            document.Stat.action = "<%=context%>/ReportsServletThree?op=complaintsProjectReport";
            document.Stat.submit();
        }
    </script>
    <BODY>
        <script type="text/javascript" src="js/wz_tooltip.js"></script>
        <FORM name="Stat" action="post">
            <DIV align="left" STYLE="color:blue;">
                <input type="button"  value="<%=display%>"  onclick="submitForm()" class="button">
                <input type="hidden" name="op" value="complaintsProjectReport">
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
                            <b><font size=3 color="white"> <%=startDate%></b>
                        </TD>
                        <TD  class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="325px">
                            <b><font size=3 color="white"> <%=endDate%></b>
                        </TD>
                    </TR>
                    <TR>
                        <td  bgcolor="#dedede" valign="middle">
                            <input type="TEXT" style="width:190px" ID="startDate" name="startDate" size="20" maxlength="100" readonly="true"
                                   value="<%=request.getAttribute("startDate") == null ? "" : request.getAttribute("startDate")%>"/>
                        </td>
                        <td  bgcolor="#dedede" valign="middle">
                            <input type="TEXT" style="width:190px" ID="endDate" name="endDate" size="20" maxlength="100" readonly="true"
                                   value="<%=request.getAttribute("endDate") == null ? "" : request.getAttribute("endDate")%>"/>
                        </td>
                    </TR>
                    <TR>
                        <TD class="blueBorder blueHeaderTD" style="font-size:18px;">
                            <b><font size=3 color="white"> <%=project%></b>
                        </TD>
                        <TD class="blueBorder blueHeaderTD" style="font-size:18px;">
                            <b><font size=3 color="white"> <%=ticketTypeTitle%></b>
                        </TD>
                    </TR>
                    <TR>
                        <td  bgcolor="#dedede" valign="middle">
                            <SELECT name='projectID' id='projectID' style='width:200px;font-size:16px;'
                                    class="chosen-select-project">
                                <option>----</option>
                                <sw:WBOOptionList wboList="<%=projectsList%>" displayAttribute="projectName" valueAttribute="projectID" scrollToValue="<%=projectID%>"/>
                            </select>
                        </td>
                        <td  bgcolor="#dedede" valign="middle">
                            <SELECT name='ticketType' id='ticketType' style='width:200px;font-size:16px;'>
                                <sw:WBOOptionList wboList='<%=ticketTypes%>' displayAttribute = "type_name" valueAttribute="type_id" scrollToValue="<%=ticketType%>" />
                            </select>
                        </td>
                    </TR>
                </TABLE>
                <BR>
                <center> <font size="3" color="red"><b> <%=complaintsCountStr%> : <%=totalComplaintsCount%></b> </font></center>
                <br><br>
                <CENTER>
                    <div id="container" style="width: 1200px; height: 300px; margin: 0 auto"></div>
                    <br><br>
                    <%
                        if (complaintsDistributionCounts != null) {
                    %>
                    <TABLE WIDTH="400" align="left" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" style="margin-left: 170px; margin-bottom: 50px;">
                        <TR  bgcolor="#C8D8F8">
                            <TD>
                                <%=complaintStr%>
                            </TD>
                            <TD>
                                <%=complaintsCountStr%>
                            </TD>
                        </TR>
                        <%
                            for (WebBusinessObject wbo : complaintsDistributionCounts) {
                        %>
                        <TR>
                            <TD>
                                <%=wbo.getAttribute("complaint")%>
                            </TD>
                            <TD>
                                <%=wbo.getAttribute("complaintCount")%>
                            </TD>
                        </TR>      
                        <%
                            }
                        %>
                    </TABLE>
                    <%
                        }
                    %>
                    <%
                        if (projectPerformanceCounts != null) {
                    %>
                    <TABLE WIDTH="400" align="right" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" style="margin-right: 170px; margin-bottom: 50px;">
                        <TR  bgcolor="#C8D8F8">
                            <TD>
                                <%=complaintStr%>
                            </TD>
                            <TD>
                                <%=complaintsCountStr%>
                            </TD>
                        </TR>
                        <%
                            for (WebBusinessObject wbo : projectPerformanceCounts) {
                        %>
                        <TR>
                            <TD>
                                <%=wbo.getAttribute("urgency") != null && ((String) wbo.getAttribute("urgency")).equalsIgnoreCase("1") ? "Normal" : ""%>
                                <%=wbo.getAttribute("urgency") != null && ((String) wbo.getAttribute("urgency")).equalsIgnoreCase("2") ? "Urgent" : ""%>
                            </TD>
                            <TD>
                                <%=wbo.getAttribute("complaintCount")%>
                            </TD>
                        </TR>      
                        <%
                            }
                        %>
                    </TABLE>
                    <%
                        }
                    %>
                <br/><br/>
                </CENTER>
            </FIELDSET>
        </FORM>
        <script>
            var config = {
                '.chosen-select-project': {no_results_text: 'No project found with this name!'}
            };
            for (var selector in config) {
                $(selector).chosen(config[selector]);
            }
        </script>
    </BODY>
</HTML>     
