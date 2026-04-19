<%@page import="java.text.SimpleDateFormat"%>
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
        String fromDate = "";
        if (request.getAttribute("fromDate") != null) {
            fromDate = (String) request.getAttribute("fromDate");
        }
        String toDate = "";
        if (request.getAttribute("toDate") != null) {
            toDate = (String) request.getAttribute("toDate");
        }
        String requestType = "";
        if (request.getAttribute("requestType") != null) {
            requestType = (String) request.getAttribute("requestType");
        }
        String stat = (String) request.getSession().getAttribute("currentMode");
        String align = null;
        String dir = null;
        String style = null;
        String lang, langCode, groupByStr, print, title, status, beginDate, endDate;
        if (stat.equals("En")) {
            align = "center";
            dir = "LTR";
            style = "text-align:left";
            lang = "   &#1593;&#1585;&#1576;&#1610;    ";
            langCode = "Ar";
            groupByStr = "&#1575;&#1604;&#1602;&#1587;&#1605; ";
            title = "Department Productions";
            print = "get report";
            status = "Status";
            beginDate = "From Date";
            endDate = "To Date";
        } else {
            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            lang = "English";
            langCode = "En";
            groupByStr = "&#1575;&#1604;&#1602;&#1587;&#1605; ";
            title = "أنتاجية القسم";
            print = "&#1605;&#1588;&#1575;&#1607;&#1583;&#1607; &#1575;&#1604;&#1578;&#1602;&#1585;&#1610;&#1585; ";
            status = "&#1575;&#1604;&#1581;&#1575;&#1604;&#1607;";
            beginDate = "&#1605;&#1606; &#1578;&#1575;&#1585;&#1610;&#1582;";
            endDate = "&#1575;&#1604;&#1609; &#1578;&#1575;&#1585;&#1610;&#1582;";
        }
    %>

    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Employees Load</TITLE>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css">
        <link rel="stylesheet" href="css/demo_table.css">

        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="js/jquery.min.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <SCRIPT type="text/javascript" src="js/json2.js"></SCRIPT>
        <script type="text/javascript" src="js/highcharts.js"></script>
        <script type="text/javascript">
            var oTable;

            /* preparing bar chart */
            var chart;
            $(document).ready(function () {
                $("#clients").css("display", "none");
                oTable = $('#clients').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                    iDisplayLength: 25,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true
                }).fadeIn(2000);
                chart = new Highcharts.Chart({
                    chart: {
                        renderTo: 'container',
                        defaultSeriesType: 'bar'
                    },
                    title: {
                        text: 'عدد الطلبات'
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
                                    out.write("'" + (String) wbo_.getAttribute("userName") + "'");
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
                            text: 'الطلبات',
                            align: 'high'
                        }
                    },
                    tooltip: {
                        formatter: function () {
                            return ' ' + 'الطلبات' + ' ' + this.y + ' ';
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
                            color: 'red',
                            pointWidth: 20,
                            data: [<% if (loads != null) {
                                    for (int i = 0; i < loads.size(); i++) {
                                        WebBusinessObject wbo_ = loads.get(i);
                                        if (i > 0) {
                                            out.write(",");
                                        }
                                        out.write((String) wbo_.getAttribute("total"));
                                    }
                                }%>]
                        }]
                });
            });
            /* -preparing bar chart */

        </script>

    </HEAD>
    <script language="javascript" type="text/javascript">
        var dp_cal1, dp_cal12;
        window.onload = function () {
            dp_cal1 = new Epoch('epoch_popup', 'popup', document.getElementById('fromDate'));
            dp_cal12 = new Epoch('epoch_popup', 'popup', document.getElementById('toDate'));
        };

        function submitForm()
        {
            document.EmployeesLoads.action = "<%=context%>/ReportsServletTwo?op=getEngEmployeeProductions";
            document.EmployeesLoads.submit();
        }

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

    <BODY>
        <FORM name="EmployeesLoads" method="post">
            <FIELDSET class="set" style="width:85%;border-color: #006699">
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
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="50%">
                            <b><font size=3 color="white">من تاريخ</b>
                        </td>
                        <td   class="blueBorder blueHeaderTD" style="font-size:18px;"WIDTH="50%">
                            <b> <font size=3 color="white">إلي تاريخ</b>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align:center" bgcolor="#dedede"  valign="MIDDLE">
                            <input id="fromDate" name="fromDate" type="text" value="<%=fromDate%>">
                            <br/><br/>
                        </td>
                        <td  bgcolor="#dedede"  style="text-align:center" valign="middle">
                            <input id="toDate" name="toDate" type="text" value="<%=toDate%>" >
                            <br/><br/>
                        </td>
                    </tr>
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="50%">
                            <b><font size=3 color="white">النوع</b>
                        </td>
                        <td   class="blueBorder blueHeaderTD" style="font-size:18px;"WIDTH="50%">
                            &nbsp;
                        </td>
                    </tr>
                    <TR>
                        <td style="text-align:center" bgcolor="#dedede"  valign="MIDDLE">
                            <select name="requestType" id="requestType" style="width: 200px; font-size: larger;">
                                <option value="5" <%=requestType.equals("5") ? "selected" : ""%>>مستخلص</option>
                                <option value="6" <%=requestType.equals("6") ? "selected" : ""%>>طلب تسليم</option>
                            </select>
                            <br/>
                            <br/>
                        </td>
                        <td style="text-align:center" bgcolor="#dedede"  valign="MIDDLE">
                            <button  onclick="JavaScript: submitForm();" STYLE="color: #27272A;font-size:15px;font-weight:bold;"><%=print%> <IMG HEIGHT="15" SRC="images/search.gif"> </button>
                            <br/>
                            <br/>
                        </td>
                    </TR>
                </TABLE>
                <br>
                <% if (loads != null && loads.size() > 0) {%>
                <center><hr style="width: 85%" /></center>
                <div style="width: 85%;margin-right: auto;margin-left: auto;" id="showClients">
                    <TABLE ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="100%" id="clients" style="">
                        <thead>
                            <tr>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;">اسم الموظف</th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;">العدد</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                int total = 0;
                                for (WebBusinessObject wbo_ : loads) {
                                    try {
                                        if (wbo_.getAttribute("total") != null && !wbo_.getAttribute("total").equals("")) {
                                            total += Integer.parseInt((String) wbo_.getAttribute("total"));
                                        }
                                    } catch (NumberFormatException ne) {
                                    }
                            %>
                            <tr style="cursor: pointer" id="row">
                                <TD>
                                    <%if (wbo_.getAttribute("userName") != null) {%>
                                    <b><%=wbo_.getAttribute("userName")%></b>
                                    <% }%>
                                </TD>

                                <TD>
                                    <%if (wbo_.getAttribute("total") != null) {%>
                                    <b><%=wbo_.getAttribute("total")%></b>
                                    <%} else {%>
                                    <b>0</b>
                                    <%}%>
                                </TD>
                            </tr>
                            <% }%>
                        </tbody>  
                        <tfoot>
                            <tr>
                                <th style="color: #005599 !important;font-size: 14px; font-weight: bold;">أجمالي</th>
                                <th style="color: #005599 !important;font-size: 14px; font-weight: bold;"><%=total%></th>
                            </tr>
                        </tfoot>
                    </TABLE>
                </div>
                <br/>
                <center><hr style="width: 85%" /></center>
                <div id="container" style="width: 100%; height: 50%; margin: 0 auto"></div>
                <br/>
                <center><hr style="width: 85%" /></center>
                    <%}%>
                <br/>
            </FIELDSET>
        </FORM>
    </BODY>
</HTML>     
