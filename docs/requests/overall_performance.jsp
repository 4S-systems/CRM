<%@page import="com.crm.common.CRMConstants"%>
<%@page import="com.maintenance.db_access.IssueDocumentMgr"%>
<%@page import="com.maintenance.db_access.ProjectsByGroupMgr"%>
<%@page import="com.clients.db_access.ClientComplaintsMgr"%>
<%@page import="com.maintenance.db_access.IssueByComplaintAllCaseMgr"%>
<%@page import="java.text.DateFormat"%>
<%@page import="com.silkworm.util.DateAndTimeControl"%>
<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*,com.tracker.app_constants.*, com.tracker.common.*, java.util.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants"%>
<%@ page import="com.silkworm.common.TimeServices,com.silkworm.jsptags.*,com.contractor.db_access.MaintainableMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page pageEncoding="UTF-8"%>
<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    ArrayList<WebBusinessObject> contractorsList = (ArrayList<WebBusinessObject>) request.getAttribute("contractorsList");
    ArrayList<WebBusinessObject> engineersList = (ArrayList<WebBusinessObject>) request.getAttribute("engineersList");
    ArrayList<WebBusinessObject> itemsList = (ArrayList<WebBusinessObject>) request.getAttribute("itemsList");
    ArrayList<WebBusinessObject> projectsList = (ArrayList<WebBusinessObject>) request.getAttribute("projectsList");
    List<WebBusinessObject> data = (ArrayList<WebBusinessObject>) request.getAttribute("data");
    String beDate = (String) request.getAttribute("beginDate");
    String eDate = (String) request.getAttribute("endDate");
    Calendar calendar = Calendar.getInstance();
    String jDateFormat = "yyyy/MM/dd";
    SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
    String today = sdf.format(calendar.getTime());
    if (beDate == null || eDate == null) {
        eDate = sdf.format(calendar.getTime());
        calendar = Calendar.getInstance();
        calendar.add(Calendar.MONTH, -1);
        int yaer = calendar.get(Calendar.YEAR);
        int month = (calendar.get(Calendar.MONTH)) + 1;
        int day = calendar.get(Calendar.DATE);
        beDate = yaer + "/" + month + "/" + day;
    }

    String engineerID = "";
    if (request.getAttribute("engineerID") != null) {
        engineerID = (String) request.getAttribute("engineerID");
    }
    String contractorID = "";
    if (request.getAttribute("contractorID") != null) {
        contractorID = (String) request.getAttribute("contractorID");
    }
    String itemID = "";
    if (request.getAttribute("itemID") != null) {
        itemID = (String) request.getAttribute("itemID");
    }
    String projectID = "";
    if (request.getAttribute("projectID") != null) {
        projectID = (String) request.getAttribute("projectID");
    }
    int totalIssuesCount = request.getAttribute("totalIssuesCount") != null ? (Integer) request.getAttribute("totalIssuesCount") : 0;
    String jsonText = (String) request.getAttribute("jsonText");
    String stat = "Ar";
    String dir = null;
    String title, beginDate, endDate;
    if (stat.equals("En")) {
        dir = "LTR";
        title = "Overall Performance";
        beginDate = "From Date";
        endDate = "To Date";
    } else {
        dir = "RTL";
        title = "اﻷداء العام";
        beginDate = "من تاريخ";
        endDate = "ألي تاريخ";
    }
%>
<HTML>
    <head>
        <META HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
        <META HTTP-EQUIV="Expires" CONTENT="0"/>
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

        <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
            $(function () {
                $("#beginDate, #endDate").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    maxDate: new Date('<%=today%>'),
                    dateFormat: "yy/mm/dd"
                });
            });
            function getReport() {
                var beginDate = $("#beginDate").val();
                var endDate = $("#endDate").val();
                if ((beginDate == null || beginDate == "")) {
                    alert("من فضلك أدخل تاريخ البداية");
                } else if ((endDate == null || endDate == "")) {
                    alert("من فضلك أدخل تاريخ النهاية");
                } else {
                    var contractorID = $("#contractorID").val();
                    var engineerID = $("#engineerID").val();
                    var itemID = $("#itemID").val();
                    var projectID = $("#projectID").val();
                    document.REPORT_FORM.action = "<%=context%>/ReportsServletTwo?op=getOverallPerformance&beginDate=" + beginDate + "&endDate=" + endDate + "&engineerID=" + engineerID + "&contractorID=" + contractorID + "&itemID=" + itemID + "&projectID=" + projectID;
                    document.REPORT_FORM.submit();
                }
            }
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
        <style type="text/css">

        </style>
    </head>
    <body>
        <form name="REPORT_FORM" method="post">
            <table align="center" width="98%">
                <tr>
                    <td class="td">
                        <FIELDSET class="set" style="width:98%;border-color: #006699">
                            <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                                <tr>
                                    <td class="titlebar" style="text-align: center">
                                        <img width="40" height="40" src="images/icons/request.png" style="vertical-align: middle;"/> &nbsp;<font color="#005599" size="4"><%=title%></font>
                                    </td>
                                </tr>
                            </table>
                            <br/>
                            <table align="center" style="margin-left: 20%; margin-right: 20%;" dir="rtl" width="60%" cellspacing="3" cellpadding="10">
                                <tr>
                                    <td class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="50%">
                                        <b><font size=3 color="white"> <%=beginDate%></b>
                                    </td>
                                    <td class="blueBorder blueHeaderTD" style="font-size:18px;"WIDTH="50%">
                                        <b> <font size=3 color="white"> <%=endDate%> </b>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align:center" bgcolor="#dedede"  valign="MIDDLE" >
                                        <input id="beginDate" readonly name="beginDate" type="text" value="<%=beDate%>" /><img src="images/showcalendar.gif" >                 
                                    </td>
                                    <td  bgcolor="#dedede"  style="text-align:center" valign="middle">
                                        <input id="endDate" readonly name="endDate" type="text" value="<%=eDate%>" ><img src="images/showcalendar.gif" > 
                                    </td>
                                </tr>
                                <tr>
                                    <td class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="50%">
                                        <b><font size=3 color="white"> اسم المقاول </b>
                                    </td>
                                    <td class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="50%">
                                        <b> <font size=3 color="white"> المهندس </b>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align:center" class="excelentCell"  valign="MIDDLE" >
                                        <select style="font-size: 14px;font-weight: bold; width: 250px;" id="contractorID" >
                                            <option value="all">الكل</option>
                                            <sw:WBOOptionList wboList='<%=contractorsList%>' displayAttribute="name" valueAttribute="id" scrollToValue="<%=contractorID%>"/>
                                        </select>
                                    </td>
                                    <td  class="excelentCell"  style="text-align:center" valign="middle">
                                        <select style="font-size: 14px; font-weight: bold; width: 250px;" id="engineerID" >
                                            <option value="all">الكل</option>
                                            <sw:WBOOptionList wboList='<%=engineersList%>' displayAttribute="fullName" valueAttribute="userId" scrollToValue="<%=engineerID%>"/>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="blueBorder blueHeaderTD" style="font-size:18px;">
                                        <b><font size=3 color="white"> المشروع</b>
                                    </td>
                                    <td class="blueBorder blueHeaderTD" style="font-size:18px;">
                                        <b><font size=3 color="white"> بند اﻷعمال </b>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align:center" class="excelentCell"  valign="MIDDLE">
                                        <select style="font-size: 14px;font-weight: bold; width: 250px;" id="projectID" >
                                            <option value="all">الكل</option>
                                            <sw:WBOOptionList wboList='<%=projectsList%>' displayAttribute="projectName" valueAttribute="projectID" scrollToValue="<%=projectID%>"/>
                                        </select>
                                    </td>
                                    <td style="text-align:center" class="excelentCell"  valign="MIDDLE">
                                        <select style="font-size: 14px;font-weight: bold; width: 250px;" id="itemID" >
                                            <option value="all">الكل</option>
                                            <sw:WBOOptionList wboList='<%=itemsList%>' displayAttribute="projectName" valueAttribute="projectID" scrollToValue="<%=itemID%>"/>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align:center;" bgcolor="#dedede" colspan="2">
                                        <button type="button" onclick="JavaScript: getReport();" style="color: #27272A;font-size:15px;margin-top: 2px;margin-bottom: 2px;font-weight:bold; width: 150px">بحث<IMG HEIGHT="15" SRC="images/search.gif" ></button>  
                                    </td>
                                </tr>
                            </table>
                            <br/>
                            <% if (data != null) {%>
                            <br/>
                            <center> <font size="3" color="red"><b> أجمالي عدد الطلبات : <%=totalIssuesCount%></b> </font></center>
                            <br/>
                            <center>
                                <div style="width: 97%">
                                    <div id="container" style="width: 600px; height: 300px; margin: 0 auto"></div>
                                    <br/><br/>
                                    <table width="400" dir="<%=dir%>" cellpadding="0" cellspacing="0">
                                        <tr bgcolor="#C8D8F8">
                                            <TD>
                                                الحالة
                                            </TD>
                                            <TD>
                                                العدد
                                            </TD>
                                        </tr>
                                        <%
                                            for (WebBusinessObject wbo : data) {
                                        %>
                                        <tr>
                                            <td>
                                                <%=wbo.getAttribute("statusName")%>
                                            </td>
                                            <td>
                                                <%=wbo.getAttribute("totalNo")%>
                                            </td>
                                        </tr>      
                                        <%
                                            }
                                        %>
                                    </table>
                                    <br/><br/>
                                </div>
                            </center>
                            <% }%>
                        </fieldset>
                    </td>
                </tr>
            </table>
        </form>
    </body>
</html>     
