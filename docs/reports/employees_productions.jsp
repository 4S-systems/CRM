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

        List<WebBusinessObject> departments = (List) request.getAttribute("departments");
        List<WebBusinessObject> groups = (List) request.getAttribute("groups");
        List<WebBusinessObject> loads = (List) request.getAttribute("loads");
        WebBusinessObject user = (WebBusinessObject) session.getAttribute("loggedUser");
        // get current date and Time
        Calendar cal = Calendar.getInstance();
        String jDateFormat = user.getAttribute("javaDateFormat").toString();
        SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
        String nowDate = sdf.format(cal.getTime());
        String cMode = (String) request.getSession().getAttribute("currentMode");
        String stat = cMode;
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
            title = "Employees Productions";
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
            title = "الأنتاجية المجمعة";
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
                        text: 'عدد العملاء'
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
                            text: 'العملاء',
                            align: 'high'
                        }
                    },
                    tooltip: {
                        formatter: function () {
                            return ' ' + 'العملاء' + ' ' + this.y + ' ';
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
                            name: 'العملاء',
                            color: 'red',
                            pointWidth: 20,
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
        var dp_cal1, dp_cal12;
        window.onload = function () {
            dp_cal1 = new Epoch('epoch_popup', 'popup', document.getElementById('beginDate'));
            dp_cal12 = new Epoch('epoch_popup', 'popup', document.getElementById('endDate'));
        };
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
            id = $("#groupId").val();
            name = $("#groupId option:selected").text();
            document.EmployeesLoads.action = "<%=context%>/ReportsServlet?op=getEmployeeProductions&id=" + id;
            document.EmployeesLoads.submit();
        }

        function cancelForm() {
            document.Stat.action = "<%=context%>/SearchServlet?op=Projects";
            document.Stat.submit();
        }

        function callbackFillreload() {
            if (req.readyState == 4)
            {
                if (req.status == 200)
                {
                    window.location.reload();
                }
            }
        }

        function switchSearch() {
            if (document.getElementById('searchByDepartment').checked == true) {
                document.getElementById('searchByGroup').checked = false;
                $("#departmentId").removeAttr('disabled');
                $("#groupId").attr('disabled', 'disabled');
            } else {
                document.getElementById('searchByDepartment').checked = false;
                $("#groupId").removeAttr('disabled');
                $("#departmentId").attr('disabled', 'disabled');
            }
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
                <TABLE class="blueBorder" ALIGN="center" DIR="RTL" ID="code" CELLPADDING="0" CELLSPACING="0" width="85%" STYLE="border-width:1px;border-color:white;" >
                    <TR>
                        <TD colspan="4" style="text-align:right" bgcolor="#dedede"  valign="MIDDLE" >
                            المجموعة  
                            <%if (groups.size() > 0 && groups != null) {%>
                            <select style="width: 50%; font-weight: bold; font-size: 13px;" id="groupId" name="groupId">
                                <sw:WBOOptionList displayAttribute="groupName" valueAttribute="groupID" wboList="<%=groups%>" scrollToValue='<%=request.getParameter("groupId")%>' />
                            </select>
                            <% } else {%>
                            <select style="width: 50%; font-weight: bold; font-size: 13px;" id="groupId" name="groupId">
                                <option>لاشئ</option>
                            </select>
                            <%}%>
                        </TD>
                    </TR>
                    <TR>
                        <TD style="text-align:right" bgcolor="#dedede"  valign="MIDDLE" ><%=beginDate%></TD>
                        <TD style="text-align:right" bgcolor="#dedede"  valign="MIDDLE" >
                            <%
                                String url = request.getRequestURL().toString();
                                String subURL = url.substring(0, url.indexOf(metaMgr.getContext()));
                                Calendar c = Calendar.getInstance();
                                String sBDate = (String) request.getAttribute("bDate");
                                String sEDate = (String) request.getAttribute("eDate");
                                String startDate = null;
                                String toDate = null;
                                if (sBDate != null && !sBDate.equals("")) {
                                    startDate = sBDate;
                                } else {
                                    startDate = nowDate;
                                }
                                if (sEDate != null && !sEDate.equals("")) {
                                    toDate = sEDate;
                                } else {
                                    toDate = nowDate;
                                }
                            %>
                            <input id="beginDate" name="beginDate" type="text" value="<%=startDate%>"><img src="images/showcalendar.gif" > 
                            <br><br>
                        </TD>

                        <TD style="text-align:right" bgcolor="#dedede"  valign="MIDDLE" ><%=endDate%></TD>
                        <td  bgcolor="#dedede"  style="text-align:right" valign="middle">
                            <input id="endDate" name="endDate" type="text" value="<%=toDate%>"><img src="images/showcalendar.gif" > 
                            <br><br>
                        </td>
                    </TR>
                    <TR>
                        <td colspan="4" bgcolor="#dedede"  style="text-align:center; padding-bottom: 5px; padding-top: 5px" valign="middle">
                            <button  onclick="JavaScript: submitForm();" STYLE="color: #27272A;font-size:15px;font-weight:bold;height: 35px"><%=print%> <IMG HEIGHT="15" SRC="images/search.gif"> </button>
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
                                        if (wbo_.getAttribute("noTicket") != null && !wbo_.getAttribute("noTicket").equals("")) {
                                            total += Integer.parseInt((String) wbo_.getAttribute("noTicket"));
                                        }
                                    } catch (NumberFormatException ne) {
                                    }
                            %>
                            <tr style="cursor: pointer" id="row">
                                <TD>
                                    <%if (wbo_.getAttribute("currentOwnerFullName") != null) {%>
                                    <b><%=wbo_.getAttribute("currentOwnerFullName")%></b>
                                    <% }%>
                                </TD>

                                <TD>
                                    <%if (wbo_.getAttribute("noTicket") != null) {%>
                                    <b><%=wbo_.getAttribute("noTicket")%></b>
                                    <%} else {%>
                                    <b>0</b>
                                    <%}%>
                                </TD>
                            </tr>
                            <% }%>
                        </tbody>  
                        <tfoot>
                            <tr>
                                <th style="color: #005599 !important;font-size: 14px; font-weight: bold;">أجمالي العملاء</th>
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
