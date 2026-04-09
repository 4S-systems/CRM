<%@page import="java.util.Calendar"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page pageEncoding="UTF-8"%>
<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    ArrayList<WebBusinessObject> contractorsList = (ArrayList<WebBusinessObject>) request.getAttribute("contractorsList");
    ArrayList<WebBusinessObject> engineersList = (ArrayList<WebBusinessObject>) request.getAttribute("engineersList");
    ArrayList<WebBusinessObject> projectsList = (ArrayList<WebBusinessObject>) request.getAttribute("projectsList");
    ArrayList<WebBusinessObject> data = (ArrayList<WebBusinessObject>) request.getAttribute("data");
    String categoryStr = request.getAttribute("categoryStr") != null ? (String) request.getAttribute("categoryStr") : "[]";
    String dataStr = request.getAttribute("dataStr") != null ? (String) request.getAttribute("dataStr") : "[]";
    String beDate = (String) request.getAttribute("beginDate");
    String eDate = (String) request.getAttribute("endDate");
    Calendar calendar = Calendar.getInstance();
    String jDateFormat = "yyyy/MM/dd";
    SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
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
    String projectID = "";
    if (request.getAttribute("projectID") != null) {
        projectID = (String) request.getAttribute("projectID");
    }
    String stat = "Ar";
    String dir = null;
    String title, beginDate, endDate, engineerName, contractorName, projectName, all;
    if (stat.equals("En")) {
        dir = "LTR";
        title = "Recurring Curve for Work Items";
        beginDate = "From Date";
        endDate = "To Date";
        engineerName = "Engineer";
        contractorName = "Contractor Name";
        projectName = "Project Name";
        all = "All";
    } else {
        dir = "RTL";
        title = "المنحني التكراري لبنود الأعمال";
        beginDate = "من تاريخ";
        endDate = "ألى تاريخ";
        engineerName = "المهندس";
        contractorName = "المقاول";
        projectName = "المشروع";
        all = "الكل";
    }
%>
<html>
    <head>
        <link REL="stylesheet" TYPE="text/css" HREF="CSS.css"/>
        <link REL="stylesheet" TYPE="text/css" HREF="Button.css"/>
        <script type="text/javascript" src="js/json2.js"></script>
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
        <script LANGUAGE="JavaScript" TYPE="text/javascript">
            $(function () {
                $("#beginDate, #endDate").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    maxDate: '0',
                    dateFormat: "yy/mm/dd"
                });
            });
            var oTable;
            $(document).ready(function () {
                $("#items").css("display", "none");
                oTable = $('#items').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                    iDisplayLength: 25,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true
                }).fadeIn(2000);
            });
            /* preparing bar chart */
            var chart;
            $(document).ready(function () {
                chart = new Highcharts.Chart({
                    chart: {
                        renderTo: 'container',
                        defaultSeriesType: 'bar'
                    },
                    title: {
                        text: 'بنود الأعمال'
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
                        categories: <%=categoryStr%>,
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
                            text: 'عدد البنود',
                            align: 'high'
                        }
                    },
                    tooltip: {
                        formatter: function () {
                            return ' ' + 'بنود' + ' ' + this.y + ' ';
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
                            name: 'البنود',
                            data: <%=dataStr%>
                        }]
                });
            });
            /* -preparing bar chart */
            function submitForm() {
                document.REPORT_FORM.action = "<%=context%>/ReportsServletThree?op=getWorkItemsRecurringCurve";
                document.REPORT_FORM.submit();
            }
        </script>
        <style type="text/css">
        </style>
    </head>
    <body>
        <form name="REPORT_FORM" method="post">
            <table align="center" width="98%">
                <tr>
                    <td class="td">
                        <fieldset class="set" style="width:98%;border-color: #006699">
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
                                        <b><font size=3 color="white"><%=contractorName%></b>
                                    </td>
                                    <td class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="50%">
                                        <b> <font size=3 color="white"> <%=engineerName%> </b>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align:center" class="excelentCell"  valign="MIDDLE" >
                                        <select style="font-size: 14px;font-weight: bold; width: 250px;" id="contractorID" name="contractorID" >
                                            <option value="all"><%=all%></option>
                                            <sw:WBOOptionList wboList='<%=contractorsList%>' displayAttribute="name" valueAttribute="id" scrollToValue="<%=contractorID%>"/>
                                        </select>
                                    </td>
                                    <td  class="excelentCell"  style="text-align:center" valign="middle">
                                        <select style="font-size: 14px; font-weight: bold; width: 250px;" id="engineerID" name="engineerID" >
                                            <option value="all"><%=all%></option>
                                            <sw:WBOOptionList wboList='<%=engineersList%>' displayAttribute="fullName" valueAttribute="userId" scrollToValue="<%=engineerID%>"/>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="blueBorder blueHeaderTD" style="font-size:18px;" colspan="2">
                                        <b><font size=3 color="white"><%=projectName%></b>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align:center" class="excelentCell"  valign="MIDDLE" colspan="2">
                                        <select style="font-size: 14px;font-weight: bold; width: 250px;" id="projectID" name="projectID" >
                                            <option value="all"><%=all%></option>
                                            <sw:WBOOptionList wboList='<%=projectsList%>' displayAttribute="projectName" valueAttribute="projectID" scrollToValue="<%=projectID%>"/>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align:center;" bgcolor="#dedede" colspan="2">
                                        <button type="button" onclick="JavaScript: submitForm();" style="color: #000;font-size:15px;margin-top: 2px;margin-bottom: 2px;font-weight:bold; width: 150px">بحث<IMG HEIGHT="15" SRC="images/search.gif" ></button>  
                                    </td>
                                </tr>
                            </table>
                            <br/>
                        </fieldset>
                    </td>
                </tr>
            </table>
        </form>
        <% if (data != null && data.size() > 0) {%>
        <div style="width: 85%;margin-right: auto;margin-left: auto;" id="showClients">
            <table dir="<%=dir%>" width="100%" id="items">
                <thead>
                    <tr>
                        <th style="color: #005599 !important;font-size: 14px; font-weight: bold;">بند العمل</th>
                        <th style="color: #005599 !important;font-size: 14px; font-weight: bold;">العدد</th>
                    </tr>
                <thead>
                <tbody>
                    <% for (WebBusinessObject wbo : data) {%>
                    <tr style="cursor: pointer" id="row">
                        <td>
                            <b><%=wbo.getAttribute("itemName") != null ? wbo.getAttribute("itemName") : ""%></b>
                        </td>

                        <td>
                            <%=wbo.getAttribute("total") != null ? wbo.getAttribute("total") : "0"%>
                        </td>
                    </tr>
                    <% }%>
                </tbody>  
            </table>
        </div>
        <br/>
        <hr style="width: 85%; margin-left: auto; margin-right: auto;" />
        <div id="container" style="width: 100%; height: 500px; margin: 0 auto"></div>
        <br/>
        <hr style="width: 85%; margin-left: auto; margin-right: auto;" />
        <%} else {%>
        <br/>
        <b style="font-size: x-large; color: red;">لا يوجد بيانات</b>
        <br/>
        <br/>
        <%}%>
    </body>
</html>     
