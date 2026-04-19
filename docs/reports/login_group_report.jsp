<%@page import="java.util.ArrayList"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.List"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page pageEncoding="UTF-8"%>
<html>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();

        List<WebBusinessObject> groups = (List) request.getAttribute("groups");
        ArrayList<WebBusinessObject> data = (ArrayList<WebBusinessObject>) request.getAttribute("data");
        WebBusinessObject user = (WebBusinessObject) session.getAttribute("loggedUser");
        Calendar cal = Calendar.getInstance();
        String jDateFormat = user.getAttribute("javaDateFormat").toString();
        SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
        String sBDate = (String) request.getAttribute("fromDate");
        String sEDate = (String) request.getAttribute("toDate");
        String groupID = request.getAttribute("groupID") != null ? (String) request.getAttribute("groupID") : "";

        String startDate = null;
        String toDateValue = null;
        if (sEDate != null && !sEDate.equals("")) {
            toDateValue = sEDate;
        } else {
            toDateValue = sdf.format(cal.getTime());
        }
        if (sBDate != null && !sBDate.equals("")) {
            startDate = sBDate;
        } else {
            cal.add(Calendar.MONTH, -1);
            startDate = sdf.format(cal.getTime());
        }
        String stat = (String) request.getSession().getAttribute("currentMode");
        String align = null;
        String dir = null;
        String style, print, title, fromDate, toDate, group, employeeName, noOfDays;
        if (stat.equals("En")) {
            align = "center";
            dir = "LTR";
            style = "text-align:left";
            title = "Attendance Statistics Report";
            print = "View Report";
            fromDate = "From Date";
            toDate = "To Date";
            group = "Group";
            employeeName = "Employee Name";
            noOfDays = "No. of Days";
        } else {
            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            title = "تقرير أحصائي للحضور";
            print = "مشاهده التقرير";
            fromDate = "من تاريخ";
            toDate = "الى تاريخ";
            group = "المجموعة";
            employeeName = "الموظف";
            noOfDays = "عدد الأيام";
        }
    %>
    <head>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css"/>
        <link rel="stylesheet" href="css/demo_table.css"/>

        <script type="text/javascript" src="js/json2.js"></script>
        <script type="text/javascript" src="js/highcharts.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript">
            function submitForm() {
                document.EmployeesLoads.action = "<%=context%>/ReportsServletThree?op=attendanceStatisticsReport";
                document.EmployeesLoads.submit();
            }
            
            /* preparing bar chart */
            var chart;
            $(document).ready(function() {
                chart = new Highcharts.Chart({
                    chart: {
                        renderTo: 'container',
                        defaultSeriesType: 'bar'
                    },
                    title: {
                        text: 'أيام الحضور'
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
                        categories: [<% if (data != null) {
                                for (int i = 0; i < data.size(); i++) {
                                    WebBusinessObject wbo_ = data.get(i);
                                    if (i > 0) {
                                        out.write(",");
                                    }
                                    out.write("'" + (String) wbo_.getAttribute("employeeName") + "'");
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
                            text: 'عدد الأيام',
                            align: 'high'
                        }
                    },
                    tooltip: {
                        formatter: function() {
                            return ' ' + 'أيام' + ' ' + this.y + ' ';
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
                            name: 'عدد الأيام',
                            data: [<% if (data != null) {
                                    for (int i = 0; i < data.size(); i++) {
                                        WebBusinessObject wbo_ = data.get(i);
                                        if (i > 0) {
                                            out.write(",");
                                        }
                                        out.write((String) wbo_.getAttribute("noOfDays"));
                                    }
                                }%>]
                        }]
                });
                $("#fromDate, #toDate").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    maxDate: 0,
                    dateFormat: "yy/mm/dd"
                });
            });
            /* -preparing bar chart */
        </script>
        <style>

            label{
                font: Georgia, "Times New Roman", Times, serif;
                font-size:14px;
                font-weight:bold;
                color:#005599;
                margin-right: 5px;
            }
            #row:hover{
                background-color: #EEEEEE;
            }
            .client_btn {
                width:145px;
                height:31px;
                margin: 4px;
                background-repeat: no-repeat;
                cursor: pointer;
                border: none;
                background-position: right top ;
                display: inline-block;
                background-color: transparent;
                background-image:url(images/buttons/addclient.png);
            }
            .company_btn {
                width:145px;
                height:31px;
                margin: 4px;
                background-repeat: no-repeat;
                cursor: pointer;
                border: none;
                background-position: right top ;
                display: inline-block;
                background-color: transparent;
                background-image:url(images/buttons/addCompany.png);
            }
            .enter_call {
                width:145px;
                height:31px;
                margin: 4px;
                background-repeat: no-repeat;
                cursor: pointer;
                border: none;
                background-position: right top ;
                display: inline-block;
                background-color: transparent;
                background-image:url(images/buttons/Number.png);
            }
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
    </head>
    <body>
        <form name="EmployeesLoads" method="post"> 
            <br/>
            <fieldset class="set" style="width:85%;border-color: #006699">
                <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <tr>
                        <td width="100%" class="titlebar">
                            <font color="#005599" size="4"><%=title%></font>
                        </td>
                    </tr>
                </table>
                <br/>
                <table ALIGN="center" DIR="RTL" WIDTH="60%" CELLSPACING=2 CELLPADDING=1>
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="40%">
                            <b><font size=3 color="white"><%=fromDate%></b>
                        </td>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;"WIDTH="40%">
                            <b> <font size=3 color="white"><%=toDate%></b>
                        </td>
                        <td STYLE="text-align:center" bgcolor="#dedede" rowspan="4" WIDTH="20%">
                            <button onclick="JavaScript: submitForm();" STYLE="color: #27272A;font-size:15px;font-weight:bold;height: 35px"><%=print%> <IMG HEIGHT="15" SRC="images/search.gif"/> </button>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align:center" bgcolor="#dedede" valign="middle">
                            <input id="fromDate" name="fromDate" type="text" readonly value="<%=startDate%>"/><img src="images/showcalendar.gif"/> 
                            <br/><br/>
                        </td>
                        <td bgcolor="#dedede" style="text-align:center" valign="middle">
                            <input id="toDate" name="toDate" type="text" readonly value="<%=toDateValue%>"/><img src="images/showcalendar.gif"/>
                            <br/><br/>
                        </td>
                    </tr>
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" colspan="2">
                            <b><font size=3 color="white"><%=group%></b>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align:center" bgcolor="#dedede" valign="MIDDLE" colspan="2">
                            <select style="width: 200px; font-weight: bold; font-size: 13px; margin-top: 5px;" id="groupID" name="groupID">
                                <sw:WBOOptionList displayAttribute="groupName" valueAttribute="groupID" wboList="<%=groups%>" scrollToValue="<%=groupID%>" />
                            </select>
                            <br/><br/>
                        </td>
                    </tr>
                </table>
                <br/>
                <center>
                    <div id="container" style="width: 600px; height: 300px; margin: 0 auto; display: <%=data != null ? "" :"none"%>;"></div>
                    <br><br>
                    <%
                        if (data != null) {
                    %>
                    <table width="400" align="<%=align%>" dir="<%=dir%>" cellpadding="0" cellspacing="0">
                        <tr bgcolor="#C8D8F8">
                            <td>
                                <%=employeeName%>
                            </td>
                            <td>
                                <%=noOfDays%>
                            </td>
                        </tr>
                        <%
                            for (WebBusinessObject wbo : data) {
                        %>
                        <tr>
                            <td>
                                <a href="<%=context%>/ReportsServletThree?op=attendanceDetailsReport&userID=<%=wbo.getAttribute("userID")%>&fromDate=<%=startDate%>&toDate=<%=toDateValue%>"><%=wbo.getAttribute("employeeName")%></a>
                            </td>
                            <td>
                                <%=wbo.getAttribute("noOfDays")%>
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
                    <br/>
                </center>
            </fieldset>
        </form>
    </body>
</html>
