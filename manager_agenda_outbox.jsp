<%@page import="com.crm.common.CRMConstants"%>
<%@page import="com.clients.db_access.ClientComplaintsMgr"%>
<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="com.tracker.engine.IssueStatusFactory, com.tracker.engine.*,java.text.*,com.docviewer.db_access.*, com.maintenance.db_access.*,com.maintenance.common.ParseSideMenu"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %> 
<%@ page contentType="text/HTML; charset=UTF-8" %>
<HTML>
    <meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <meta HTTP-EQUIV="Expires" CONTENT="0">
    <head>
        <title>Weekly Manager Agenda</title>

        <!--<script type="text/javascript" src="jquery-ui/jquery-1.7.1.js"></script>-->
        <!--<meta http-equiv="refresh" content="60" />-->
        <script type="text/javascript">
            $(document).ready(function() {
                $('#outbox').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                    iDisplayLength: 25,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true,
                    "aaSorting": [[ 10, "asc" ]]



                });
            });
            //          
        </script>
        <script type="text/javascript">



            var TableIDvalue = "indextable";

            //
            //////////////////////////////////////
            var TableLastSortedColumn = -1;
            function SortTable() {
                var sortColumn = parseInt(arguments[0]);
                var type = arguments.length > 1 ? arguments[1] : 'T';
                var dateformat = arguments.length > 2 ? arguments[2] : '';
                var table = document.getElementById(TableIDvalue);
                var tbody = table.getElementsByTagName("tbody")[0];
                var rows = tbody.getElementsByTagName("tr");
                var arrayOfRows = new Array();
                type = type.toUpperCase();
                dateformat = dateformat.toLowerCase();
                for (var i = 0, len = rows.length; i < len; i++) {
                    arrayOfRows[i] = new Object;
                    arrayOfRows[i].oldIndex = i;
                    var celltext = rows[i].getElementsByTagName("td")[sortColumn].innerHTML.replace(/<[^>]*>/g, "");
                    if (type == 'D') {
                        arrayOfRows[i].value = GetDateSortingKey(dateformat, celltext);
                    }
                    else {
                        var re = type == "N" ? /[^\.\-\+\d]/g : /[^a-zA-Z0-9]/g;
                        arrayOfRows[i].value = celltext.replace(re, "").substr(0, 25).toLowerCase();
                    }
                }
                if (sortColumn == TableLastSortedColumn) {
                    arrayOfRows.reverse();
                }
                else {
                    TableLastSortedColumn = sortColumn;
                    switch (type) {
                        case "N" :
                            arrayOfRows.sort(CompareRowOfNumbers);
                            break;
                        case "D" :
                            arrayOfRows.sort(CompareRowOfNumbers);
                            break;
                        default  :
                            arrayOfRows.sort(CompareRowOfText);
                    }
                }
                var newTableBody = document.createElement("tbody");
                for (var i = 0, len = arrayOfRows.length; i < len; i++) {
                    newTableBody.appendChild(rows[arrayOfRows[i].oldIndex].cloneNode(true));
                }
                table.replaceChild(newTableBody, tbody);
            } // function SortTable()

            function CompareRowOfText(a, b) {
                var aval = a.value;
                var bval = b.value;
                return(aval == bval ? 0 : (aval > bval ? 1 : -1));
            } // function CompareRowOfText()

            function CompareRowOfNumbers(a, b) {
                var aval = /\d/.test(a.value) ? parseFloat(a.value) : 0;
                var bval = /\d/.test(b.value) ? parseFloat(b.value) : 0;
                return(aval == bval ? 0 : (aval > bval ? 1 : -1));
            } // function CompareRowOfNumbers()

            function GetDateSortingKey(format, text) {
                if (format.length < 1) {
                    return "";
                }
                format = format.toLowerCase();
                text = text.toLowerCase();
                text = text.replace(/^[^a-z0-9]*/, "", text);
                text = text.replace(/[^a-z0-9]*$/, "", text);
                if (text.length < 1) {
                    return "";
                }
                text = text.replace(/[^a-z0-9]+/g, ",", text);
                var date = text.split(",");
                if (date.length < 3) {
                    return "";
                }
                var d = 0, m = 0, y = 0;
                for (var i = 0; i < 3; i++) {
                    var ts = format.substr(i, 1);
                    if (ts == "d") {
                        d = date[i];
                    }
                    else if (ts == "m") {
                        m = date[i];
                    }
                    else if (ts == "y") {
                        y = date[i];
                    }
                }
                if (d < 10) {
                    d = "0" + d;
                }
                if (/[a-z]/.test(m)) {
                    m = m.substr(0, 3);
                    switch (m) {
                        case "jan" :
                            m = 1;
                            break;
                        case "feb" :
                            m = 2;
                            break;
                        case "mar" :
                            m = 3;
                            break;
                        case "apr" :
                            m = 4;
                            break;
                        case "may" :
                            m = 5;
                            break;
                        case "jun" :
                            m = 6;
                            break;
                        case "jul" :
                            m = 7;
                            break;
                        case "aug" :
                            m = 8;
                            break;
                        case "sep" :
                            m = 9;
                            break;
                        case "oct" :
                            m = 10;
                            break;
                        case "nov" :
                            m = 11;
                            break;
                        case "dec" :
                            m = 12;
                            break;
                        default    :
                            m = 0;
                    }
                }
                if (m < 10) {
                    m = "0" + m;
                }
                y = parseInt(y);
                if (y < 100) {
                    y = parseInt(y) + 2000;
                }
                return "" + String(y) + "" + String(m) + "" + String(d) + "";
            } // function GetDateSortingKey()
        </script>


    </head>

    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        Calendar weekCalendar = Calendar.getInstance();
        Calendar beginWeekCalendar = Calendar.getInstance();
        Calendar endWeekCalendar = Calendar.getInstance();

        metaMgr.setMetaData("xfile.jar");
        ParseSideMenu parseSideMenu = new ParseSideMenu();
        Hashtable logos = new Hashtable();
        logos = parseSideMenu.getCompanyLogo("configration" + metaMgr.getCompanyName() + ".xml");
        String weeksNo = logos.get("weeksNo").toString();

        int dayOfBack = new Integer(weeksNo).intValue() * 7;

        int dayOfWeekValue = weekCalendar.getTime().getDay();
        Calendar beginSecondWeekCalendar = Calendar.getInstance();
        Calendar endSecondWeekCalendar = Calendar.getInstance();
        beginSecondWeekCalendar = (Calendar) weekCalendar.clone();
        endSecondWeekCalendar = (Calendar) weekCalendar.clone();

        beginSecondWeekCalendar.add(beginWeekCalendar.DATE, -dayOfWeekValue - dayOfBack);
        endSecondWeekCalendar.add(endWeekCalendar.DATE, -dayOfWeekValue);

        java.sql.Date beginSecondInterval = new java.sql.Date(beginSecondWeekCalendar.getTimeInMillis());
        java.sql.Date endSecondInterval = new java.sql.Date(endSecondWeekCalendar.getTimeInMillis());
        String beginDate = null;
        String endDate = null;

        DateFormat sqlDateParser = new SimpleDateFormat("yyyy/MM/dd");
        beginDate = sqlDateParser.format(beginSecondInterval);
        endDate = sqlDateParser.format(endSecondInterval);

        session = request.getSession();
        IssueMgr issueMgr = IssueMgr.getInstance();
        UnitScheduleMgr unitScheduleMgr = UnitScheduleMgr.getInstance();

        Vector<WebBusinessObject> issuesVector = new Vector();
        WebIssue webIssue = null;
        WebBusinessObject unitScheduleWbo = null;

        String context = metaMgr.getContext();
        String issueID = null;
        String MaintenanceTitle = null;
        String ScheduleUnitId = null;

        int iTotal = 0;

        beginWeekCalendar = (Calendar) weekCalendar.clone();
        endWeekCalendar = (Calendar) weekCalendar.clone();

        beginWeekCalendar.add(beginWeekCalendar.DATE, -dayOfWeekValue);
        endWeekCalendar.add(endWeekCalendar.DATE, 6 - dayOfWeekValue);

        java.sql.Date beginInterval = new java.sql.Date(beginWeekCalendar.getTimeInMillis());
        java.sql.Date endInterval = new java.sql.Date(endWeekCalendar.getTimeInMillis());
        IssueByComplaintMgr issueByComplaintMgr = IssueByComplaintMgr.getInstance();
        // issuesVector = issueMgr.getIssuesListInRangeByEmg(new java.sql.Date(beginWeekCalendar.getTimeInMillis()), new java.sql.Date(endWeekCalendar.getTimeInMillis()),session);
        WebBusinessObject userWbo = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
        String[] key = new String[3];
        String[] value = new String[3];
        key[0] = "key3";
        key[1] = "key8";
        value[0] = userWbo.getAttribute("userId").toString();
        value[1] = "4";
        value[2] = "3";
        String bDate = beginInterval.toString().substring(8, 10) + "-" + beginInterval.toString().substring(5, 7) + "-" + beginInterval.toString().substring(0, 4);
        String day = endInterval.toString().substring(8, 10);
        int endDay = Integer.parseInt(day) + 1;
        String eDate = endDay + "-" + endInterval.toString().substring(5, 7) + "-" + endInterval.toString().substring(0, 4);
        String resp = "1";
        
        SecurityUser securityUser = (SecurityUser) session.getAttribute("securityUser");
        Map<String, String> withinIntervals = securityUser.getWithinIntervals();
        Calendar cal = Calendar.getInstance();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
        String nowTime = sdf.format(cal.getTime());
        String toDateVal = nowTime;
        if(request.getParameter("toDateOut") != null) {
            toDateVal = request.getParameter("toDateOut");
            withinIntervals.put("toDateOut", "" + toDateVal);
        } else if (withinIntervals.containsKey("toDateOut")) {
            toDateVal = withinIntervals.get("toDateOut");
        }
        cal.add(Calendar.DAY_OF_MONTH, -1);
        nowTime = sdf.format(cal.getTime());
        String fromDateVal = nowTime;
        if(request.getParameter("fromDateOut") != null) {
            fromDateVal = request.getParameter("fromDateOut");
            withinIntervals.put("fromDateOut", "" + fromDateVal);
        } else if (withinIntervals.containsKey("fromDateOut")) {
            fromDateVal = withinIntervals.get("fromDateOut");
        }
        issuesVector = issueByComplaintMgr.getComplaintsWithoutDate2(3, value, key, "key7", resp, null, new java.sql.Date(sdf.parse(fromDateVal).getTime()), new java.sql.Date(sdf.parse(toDateVal).getTime()));
        
        String stat = (String) request.getSession().getAttribute("currentMode");
        String title, from, to, align, dir, style, Indicators, Quick, important, expectedBegin, expectedEnd, totalTasks;
        String viewD, scheduleCase, executionCase, onHoldCase, fontSize, issueNo, issueTit, equip, issueStatus;
        String complaintNo, customerName, complaintDate, complaint;
        String sat, sun, mon, tue, wed, thu, fri, view, complaintCode, type, compStatus, compSender, noResponse, ageComp;
        String complStatus, senderName = null, fullName = null, fromDate, toDate, search;
        if (stat.equals("En")) {
            title = "(Current Manager Agenda (Weekly";
            from = "From";
            to = "To";
            align = "left";
            dir = "LTR";
            style = "text-align:left";
            Indicators = "Helping";
            Quick = "Quick Summary";
            important = "Important Data";
            issueNo = "Job Order number";
            issueTit = "Title";
            equip = "Equipment Name";
            issueStatus = "Status";
            expectedBegin = "Expected Begin Date";
            expectedEnd = "Expected End Date";
            totalTasks = "Total Job Order(s)";
            viewD = "View Details";
            scheduleCase = "Not start yet";
            executionCase = "under execution";
            onHoldCase = "On hold";
            fontSize = "3";
            complaintNo = "Order No.";
            customerName = "Customer name";
            complaintDate = "Date";
            complaint = "Complaint";
            sat = "Sat";
            sun = "Sun";
            mon = "Mon";
            tue = "Tue";
            wed = "Wed";
            thu = "Thu";
            fri = "Fri";
            view = "View";
            complaintCode = "Complaint code";
            type = "Type";
            compStatus = "Staus";
            compSender = "Responsible";
            noResponse = "&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1578;&#1583;&#1575;&#1608;&#1604;";
            ageComp = "A.C(day)";
            fromDate = "From Date";
            toDate = "To Date";
            search = "Search";
        } else {
            title = "&#1575;&#1604;&#1571;&#1580;&#1606;&#1583;&#1607; &#1575;&#1604;&#1571;&#1587;&#1576;&#1608;&#1593;&#1610;&#1607; &#1575;&#1604;&#1581;&#1575;&#1604;&#1610;&#1607;";
            from = "&#1605;&#1606;";
            to = "&#1573;&#1604;&#1609;";
            align = "right";
            dir = "RTL";
            style = "text-align:Right";
            Indicators = "&#1605;&#1587;&#1575;&#1593;&#1583;&#1577;";
            Quick = "&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1587;&#1585;&#1610;&#1593;&#1577;";
            important = "&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1607;&#1575;&#1605;&#1577;";
            issueNo = "&#1585;&#1602;&#1605; &#1575;&#1604;&#1591;&#1604;&#1576;";
            issueTit = "&#1593;&#1606;&#1608;&#1575;&#1606; &#1575;&#1604;&#1591;&#1604;&#1576;";
            equip = "&#1573;&#1587;&#1605; &#1575;&#1604;&#1593;&#1605;&#1610;&#1604;";
            issueStatus = "&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1591;&#1604;&#1576;";
            expectedBegin = "&#1608;&#1602;&#1578; &#1575;&#1604;&#1576;&#1583;&#1575;&#1610;&#1577;";
            expectedEnd = "&#1608;&#1602;&#1578; &#1575;&#1604;&#1575;&#1606;&#1578;&#1607;&#1575;&#1569;";
            totalTasks = "&#1605;&#1580;&#1605;&#1608;&#1593; &#1575;&#1604;&#1591;&#1604;&#1576;&#1575;&#1578; &#1602;&#1610;&#1583; &#1575;&#1604;&#1605;&#1578;&#1575;&#1576;&#1593;&#1577;";
            viewD = "&#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1575;&#1604;&#1578;&#1601;&#1575;&#1589;&#1610;&#1604;";
            scheduleCase = "&#1604;&#1605; &#1610;&#1576;&#1583;&#1571; &#1576;&#1593;&#1583;";
            executionCase = "&#1578;&#1581;&#1578; &#1575;&#1604;&#1578;&#1606;&#1601;&#1610;&#1584;";
            onHoldCase = "&#1578;&#1581;&#1578; &#1575;&#1604;&#1573;&#1585;&#1580;&#1575;&#1569;";
            fontSize = "4";
            complaintNo = "&#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1578;&#1575;&#1576;&#1593;&#1577;";
            customerName = "&#1575;&#1587;&#1605; &#1575;&#1604;&#1593;&#1605;&#1610;&#1604;";
            complaintDate = "التاريخ";
            complaint = "&#1575;&#1604;&#1591;&#1604;&#1576;";
            sat = "&#1575;&#1604;&#1587;&#1576;&#1578;";
            sun = "&#1575;&#1604;&#1575;&#1581;&#1583;";
            mon = "&#1575;&#1604;&#1575;&#1579;&#1606;&#1610;&#1606;";
            tue = "&#1575;&#1604;&#1579;&#1604;&#1575;&#1579;&#1575;&#1569;";
            wed = "&#1575;&#1604;&#1575;&#1585;&#1576;&#1593;&#1575;&#1569;";
            thu = "&#1575;&#1604;&#1582;&#1605;&#1610;&#1587;";
            fri = "&#1575;&#1604;&#1580;&#1605;&#1593;&#1577;";
            view = "&#1605;&#1588;&#1575;&#1607;&#1583;&#1577;";
            complaintCode = "&#1603;&#1608;&#1583; &#1575;&#1604;&#1591;&#1604;&#1576;";
            type = "النوع";
            compStatus = "&#1575;&#1604;&#1581;&#1575;&#1604;&#1577;";
            compSender = "&#1575;&#1604;&#1605;&#1587;&#1574;&#1608;&#1604;";
            noResponse = "&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1578;&#1583;&#1575;&#1608;&#1604;";
            ageComp = "&#1593;.&#1591; (&#1610;&#1608;&#1605;)";
            fromDate = "من تاريخ";
            toDate = "إلي تاريخ";
            search = "بحث";
        }
        String sDate, sTime = null;
    %>
    <style type="text/css">

        .popup_conten{ 

            border: none;

            direction:rtl;
            padding:0px;
            margin-top: 10px;
            border: 1px solid tomato;
            background-color: #f1f1f1;
            margin-bottom: 5px;
            width: 30%;

            /*position:absolute;*/

            font:Verdana, Geneva, sans-serif;
            font-size:18px;
            font-weight:bold;
            display: none;
        }
    </style>


    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
        function changePage(url) {
            window.navigate(url);
        }



        function compId(x) {
        }
        function changeMode(name) {
            if (document.getElementById(name).style.display == 'none') {
                document.getElementById(name).style.display = 'block';
            } else {
                document.getElementById(name).style.display = 'none';
            }
        }

        function showLaterOrders() {
            var beginDate = document.getElementById("beginDate").value;
            var endDate = document.getElementById("endDate").value;
            var projectName = document.getElementById("projectName").value;
            var statusName = 'Schedule';

            window.navigate('<%=context%>/SearchServlet?op=StatusProjectList&beginDate=' + beginDate + '&endDate=' + endDate + '&projectName=' + projectName + '&statusName=' + statusName);
        }

        function showLaterClosedOrders() {
            var beginDate = document.getElementById("beginDate").value;
            var endDate = document.getElementById("endDate").value;
            var projectName = document.getElementById("projectName").value;
            var statusName = 'Finished';

            window.navigate('<%=context%>/SearchServlet?op=getJobOrdersByLateClosed&beginDate=' + beginDate + '&endDate=' + endDate + '&projectName=' + projectName + '&statusName=' + statusName);
        }

        function getComplaint(issueId, compId,statusCode,receipId,senderID) {
           
            window.navigate('<%=context%>/IssueServlet?op=getCompl&issueId=' + issueId +'&compId=' + compId+ '&statusCode=' + statusCode+ '&receipId=' + receipId+ '&senderID=' + senderID);
        }
        function closeComp(issueId, compId) {
            window.navigate('<%=context%>/IssueServlet?op=closeComp&issueId=' + issueId + '&compId=' + compId);
        }
        function removeComp(issueId, compId) {
            window.navigate('<%=context%>/IssueServlet?op=removeComp&issueId=' + issueId + '&compId=' + compId);
        }
        function submitformOut()
        {
            document.within_form_out.submit();
        }
        function viewRequest(issueId, clientComplaintId) {
            var url = '<%=context%>/IssueServlet?op=requestComments&issueId=' + issueId + '&clientComplaintId=' + clientComplaintId + '&showPopup=true';
            var wind = window.open(url, "", "toolbar=no,height=" + screen.height + ",width=" + screen.width + ", location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no,navigationbar=no");
            wind.focus();
        }
    </SCRIPT>
    <BODY>
    <CENTER>
        <FIELDSET class="set" style="width:100%;" >
            <!--            <table class="blueBorder" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                            <tr>
                                <td style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD">
                                    <font color="#006699" size="4"><%=title%></font>
                                </td>
                            </tr>
                        </table>-->
            <DIV align="<%=align%>" style="padding:<%=align%>; ">
                        <!--                <TABLE class="blueBorder" DIR="<%=dir%>" CELLPADDING="0" cellspacing="0" style="padding-top: 2px; padding-bottom: 4px; padding-left: 10px; padding-right: 10px; margin-top: 10px; width: auto">
                                            <TR>
                                                <TD class="backgroundTable" style="border: none">
                                                    <Font COLOR="FF385C" FACE="verdana" SIZE="<%=fontSize%>"><%=from%></Font>
                                                    <Font COLOR="black" FACE="verdana" SIZE="2">&ensp;<b><%=beginInterval.toString().substring(0, 4)%> - <%=beginInterval.toString().substring(5, 7)%> - <%=beginInterval.toString().substring(8, 10)%></b>&ensp;</Font>
                                                    <Font COLOR="FF385C" FACE="verdana" SIZE="<%=fontSize%>"><%=to%></Font>
                                                    <Font COLOR="black" FACE="verdana" SIZE="2">&ensp;<b><%=endInterval.toString().substring(0, 4)%> - <%=endInterval.toString().substring(5, 7)%> - <%=endInterval.toString().substring(8, 10)%></b></Font>
                                                </TD>
                                            </TR>
                                        </TABLE>-->
            </DIV><br />
            <form name="within_form_out">
                <table class="blueBorder" id="code2" align="center" dir="<%=dir%>" width="650" cellspacing="2" cellpadding="1"
                       style="border-width:1px;border-color:white;display: block;">
                    <tr class="head">
                        <td class="blueHeaderTD" style="text-align: center; font-size: 14px; border-width: 1px; border-color: white; width: 325px;">
                            <b><font size=3 color="white"><%=fromDate%></font></b>
                        </td>
                        <td class="blueHeaderTD" style="text-align: center; font-size: 14px; border-width: 1px; border-color: white; width: 325px;">
                            <b><font size=3 color="white"><%=toDate%></font></b>
                        </td>
                        <td style="text-align: center; font-size: 14px; border-width: 1px; border-color: white; width: 250px;" bgcolor="#EEEEEE" valign="middle" rowspan="2">
                            <button type="submit" class="button" style="width: 170px;"><%=search%><img height="15" src="images/search.gif"/></button>
                            <br/>
                            <br/>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: center; font-size: 14px; border-width: 1px; border-color: white;" bgcolor="#EEEEEE" valign="middle">
                            <input class="fromToDate" id="fromDateOut" name="fromDateOut" type="text" value="<%=fromDateVal%>" readonly/><img src="images/showcalendar.gif"/>
                            <br/><br/>
                        </td>
                        <td style="text-align: center; font-size: 14px; border-width: 1px; border-color: white;" bgcolor="#EEEEEE" style="text-align:right" valign="middle">
                            <input class="fromToDate" id="toDateOut" name="toDateOut" type="text" value="<%=toDateVal%>" readonly/><img src="images/showcalendar.gif"/>
                            <br/><br/>
                        </td>
                    </tr>
                </table>
            </form>
            <TABLE   id="outbox" align="center" DIR="<%=dir%>" WIDTH="100%" CELLPADDING="0" cellspacing="0">
                <thead><TR>
                        <TH   ><SPAN ></SPAN></TH>
                        <TH   ><SPAN ><img src="images/icons/Numbers.png" width="20" height="20" /><b> <%=complaintNo%></b></SPAN></TH>
                        <TH   ><SPAN><img src="images/icons/client.png" width="20" height="20" /><b> <%=customerName%></b></SPAN></TH>
                        <TH   ><SPAN><b><%=type%></b></SPAN></TH>
                        <TH  ><SPAN><img src="images/icons/list_.png" width="20" height="20" /><b> <%=complaint%></b></SPAN></TH>
                        <TH><SPAN><b>مصدر الطلب</b></SPAN></TH>
                        <TH   ><SPAN><img src="images/icons/key.png" width="20" height="20" /><b> <%=complaintCode%></b></SPAN></TH>
                        <TH  ><SPAN><img src="images/icons/status_.png" width="18" height="18" /><b> <%=compStatus%></b></SPAN></TH>
                        <TH   ><SPAN><img src="images/icons/manager.png" width="18" height="18" /><b> <%=compSender%></b></SPAN></TH>
                        <TH  ><img src="images/icons/Time.png" width="20" height="20" /><b> <%=complaintDate%></b></TH>
                        <TH  ><b> علم الوصول</b></TH>
                        <TH   ><b><%=ageComp%></b></TH>
                    </TR></thead>
                <tbody >  
                    <%
                        boolean showInvoice;
                        Date date = new Date();
                        for (WebBusinessObject wbo : issuesVector) {
                            showInvoice = false;

                            iTotal++;
                            String compStyle = "";
                    %>
                    <TR>
                        <% WebBusinessObject clientCompWbo = null;
                            ClientComplaintsMgr clientComplaintsMgr = ClientComplaintsMgr.getInstance();
                            clientCompWbo = clientComplaintsMgr.getOnSingleKey(wbo.getAttribute("clientComId").toString());
                            if (CRMConstants.CLIENT_COMPLAINT_TYPE_COMPLAINT.equalsIgnoreCase(clientCompWbo.getAttribute("ticketType").toString())) {
                                compStyle = "comp";
                            } else if (CRMConstants.CLIENT_COMPLAINT_TYPE_ORDER.equalsIgnoreCase(clientCompWbo.getAttribute("ticketType").toString())) {
                                compStyle = "order";
                            } else if (CRMConstants.CLIENT_COMPLAINT_TYPE_QUERY.equalsIgnoreCase(clientCompWbo.getAttribute("ticketType").toString())) {
                                compStyle = "query";
                            } else if (CRMConstants.CLIENT_COMPLAINT_TYPE_EXTRACT.equalsIgnoreCase(clientCompWbo.getAttribute("ticketType").toString())) {
                                compStyle = "order";
                            } else if (CRMConstants.CLIENT_COMPLAINT_TYPE_REQUEST_EXTRADITION.equalsIgnoreCase(clientCompWbo.getAttribute("ticketType").toString())) {
                                compStyle = "order";
                            } else if (CRMConstants.CLIENT_COMPLAINT_TYPE_REQUEST_FINANCIAL.equalsIgnoreCase(clientCompWbo.getAttribute("ticketType").toString())) {
                                compStyle = "order";
                                showInvoice = true;
                            } else if (CRMConstants.CLIENT_COMPLAINT_TYPE_CLIENT_VISIT.equalsIgnoreCase(clientCompWbo.getAttribute("ticketType").toString())) {
                                compStyle = "order";
                            } else if (CRMConstants.CLIENT_COMPLAINT_TYPE_DELIVERY_OF_QUALITY.equalsIgnoreCase(clientCompWbo.getAttribute("ticketType").toString())) {
                                compStyle = "order";
                            }
                        %>
                        <TD style="background-color: transparent;width: 5%;">
                            <SPAN style="display: inline-block;height: 20px;"><INPUT type="checkbox" id="compId" value="<%=wbo.getAttribute("clientComId")%>" name="selectedIssue" />

                                <%--
                                    WebBusinessObject wbo2 = new WebBusinessObject();
                                    BookmarkMgr bookmarkMgr = BookmarkMgr.getInstance();
                                    wbo2 = bookmarkMgr.getOnSingleKey("key1", (String) wbo.getAttribute("clientComId"));

                                    if (wbo2 != null) {
                                        String note = (String) wbo2.getAttribute("bookmarkText");
                                        String bookmarkId = (String) wbo2.getAttribute("bookmarkId");
                                %>
                                <div style="display: inline;">
                                    <%if (wbo2.getAttribute("flag").equals("marked")) {%>

                                    <IMG id="bookmarkImg" value="<%=bookmarkId%>" onclick="deleteBookmark(this)" width="19px" height="19px" src="images/icons/bookmark_selected.png" style="margin: -4px 0" onMouseOver="Tip('<%=note%>', CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#FFFF99', FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT, 'BOLD', TITLEALIGN, 'center', TITLEFONTCOLOR, 'black', TITLEBGCOLOR, '#6699FF')" onMouseOut="UnTip()"/>
                                    <%}
                                    } else {%>

                                    <IMG id="bookmarkImg"  onclick="mark(<%=wbo.getAttribute("clientComId")%>, this)" width="19px" height="19px" src="images/icons/bookmark_uns.png"  style="margin: -4px 0"/>
                                    <%}%>
                                </div>--%></SPAN>

                        </TD>


                        <TD    style="cursor: pointer;width: 12%;" onmouseover="this.className = '<%=compStyle%>'" onmouseout="this.className = ''">
                            <a href="<%=context%>/IssueServlet?op=getCompl&issueId=<%=wbo.getAttribute("issue_id")%>&compId=<%=wbo.getAttribute("clientComId")%>&statusCode=<%=wbo.getAttribute("statusCode")%>&receipId=<%=wbo.getAttribute("receipId")%>&senderID=<%=wbo.getAttribute("senderId")%>&clientType=<%=wbo.getAttribute("age")%>"
                               onmouseover="JavaScript: getRequestsCount('<%=wbo.getAttribute("issue_id")%>', this);"> <font color="red"><%=wbo.getAttribute("businessID").toString()%></font><font color="blue">/<%=wbo.getAttribute("businessIDbyDate").toString()%></font>
                            </a>

                        </TD>
                        <TD  style="width: 10%;" ><b><%=wbo.getAttribute("customerName").toString()%></b>
                            <a href="<%=context%>/ClientServlet?op=clientDetails&clientId=<%=wbo.getAttribute("customerId")%>">
                                <img src="images/client_details.jpg" width="30" style="float: left;" title="تفاصيل"
                                     onmouseover="JavaScript: changeCommentCounts('<%=wbo.getAttribute("customerId")%>', this);"/>
                            </a>
                        </TD>

                        <TD  style="width: 5%;" ><b><%=wbo.getAttribute("typeName")%></b></TD>
                        <TD  STYLE="text-align:center; padding: 5px; font-size: 12px;" width="20%"><b>
                        <% String sCompl = " ";
                            if (wbo.getAttribute("compSubject") != null && !wbo.getAttribute("compSubject").equals("")) {
                                sCompl = (String) wbo.getAttribute("compSubject");
                                if (sCompl.length() > 10) {
                        %>
                            <%=sCompl%>
                        <% } else { %>
                            <%=sCompl%>
                        <% } %>
                        <% } else { %>
                            <%=sCompl%>
                        <%}%>
                        </b>
                        <% 
                            String complaintId = (String) wbo.getAttribute("compId");
                            IssueDocumentMgr documentMgr = IssueDocumentMgr.getInstance();
                            String documentID = documentMgr.getDocument(complaintId, "client_complaint");
                            if (documentID != null) {
                        %>
                        <a href="<%=context%>/DocumentServlet?op=downloadDocument&documentId=<%=documentID%>">
                        <IMG value="" onclick="" width="19px" height="19px" src="images/down_16.png" style="margin: 0px 0"/>
                        </a>
                        <% }
                            if(wbo.getAttribute("ticketType") != null && (((String) wbo.getAttribute("ticketType")).equals(CRMConstants.CLIENT_COMPLAINT_TYPE_REQUEST_EXTRADITION)
                                    || ((String) wbo.getAttribute("ticketType")).equals(CRMConstants.CLIENT_COMPLAINT_TYPE_DELIVERY_OF_QUALITY))) {
                        %>
                            <a href="#" onclick="JavaScript: viewRequest('<%=wbo.getAttribute("issue_id")%>','<%=wbo.getAttribute("clientComId")%>');">
                                <IMG value="" onclick="" height="25px" src="images/icons/checklist-icon.png" style="margin: 0px 0; float: left;" title="مشاهدة طلب تسليم"/>
                            </a>
                        <%
                            }
                            if (showInvoice) {
                        %>
                        <a href="#" onclick="JavaScript: viewInvoice('<%=wbo.getAttribute("issue_id")%>','<%=wbo.getAttribute("businessID")%>', '<%=wbo.getAttribute("businessIDbyDate")%>');">
                            <IMG value="" onclick="" height="25px" src="images/invoice.jpg" style="margin: 0px 0; float: left;" title="مشاهدة بنود مستخلص"/>
                        </a>
                        <%
                            }
                        %>
                        </TD>
                        <TD nowrap><b><%=wbo.getAttribute("senderName")%></b></TD>
                        <TD style="width: 8%;"  ><b><%=wbo.getAttribute("businessCompId")%></b></TD>
                        <% if (stat.equals("En")) {
                                complStatus = (String) wbo.getAttribute("statusEnName");
                            } else {
                                complStatus = (String) wbo.getAttribute("statusArName");;
                            }
                        %>
                        <TD  style="width:5%;" ><b><%=complStatus%></b></TD>
                        <% if (wbo.getAttribute("currentOwner") != null && !wbo.getAttribute("currentOwner").equals("")) {
                                fullName = (String) wbo.getAttribute("currentOwner");
                            } else {
                                fullName = "";
                            }
                        %>
                        <TD style="width: 10%;"  ><b><%=fullName%></b></TD>
                        <% Calendar c = Calendar.getInstance();
                            DateFormat formatter;
                            formatter = new SimpleDateFormat("dd/MM/yyyy");
                            String[] arrDate = wbo.getAttribute("entryDate").toString().split(" ");
                            sDate = arrDate[0];
                            sTime = arrDate[1];
                            String[] arrTime = sTime.split(":");
                            sTime = arrTime[0] + ":" + arrTime[1];
                            sDate = sDate.replace("-", "/");
                            arrDate = sDate.split("/");
                            sDate = arrDate[2] + "/" + arrDate[1] + "/" + arrDate[0];
                            c.setTime((Date) formatter.parse(sDate));
                            int dayOfWeek = c.get(Calendar.DAY_OF_WEEK);
                            String currentDate = formatter.format(date);
                            String sDay = null;
                            if (dayOfWeek == 7) {
                                sDay = sat;
                            } else if (dayOfWeek == 1) {
                                sDay = sun;
                            } else if (dayOfWeek == 2) {
                                sDay = mon;
                            } else if (dayOfWeek == 3) {
                                sDay = tue;
                            } else if (dayOfWeek == 4) {
                                sDay = wed;
                            } else if (dayOfWeek == 5) {
                                sDay = thu;
                            } else if (dayOfWeek == 6) {
                                sDay = fri;
                            }
                        %>

                        <%if (currentDate.equals(sDate)) {%>
                        <TD nowrap><font color="red">Today - </font><b><%=sTime%></b></TD>
                                <%} else {%>

                        <TD nowrap  ><font color="red"><%=sDay%> - </font><b><%=sDate + " " + sTime%></b></TD>
                                <%}%>
                            <% if (wbo.getAttribute("statusCode").equals("3")) {%>
                        <td  style="background-color: green;color: #ffffff;width: 8%">
                            <b>Acknowledge</b>
                        </td>
                        <%} else {%>
                        <td style="background-color: red;color: #ffffff;width: 8%">
                            <b>Pending</b>
                        </td>
                        <%}%>
                        <td style="border-left:0px; border-right:0px; border-bottom: 1px black; width: 3%">
                            <%
                                try {
                                    out.write( DateAndTimeControl.getDelayTime(wbo.getAttribute("entryDate").toString(), "Ar"));
                                } catch (Exception E) {
                                    out.write(noResponse );
                                }
                            %>
                        </td>
                    </TR>
                    <% }%>
                </tbody>

            </TABLE>
            <input type="hidden" name="beginDate" id="beginDate" value="<%=beginDate%>">
            <input type="hidden" name="endDate" id="endDate" value="<%=endDate%>">
            <input type="hidden" name="projectName" id="projectName" value="All">
            <input type="hidden" name="statusName" id="statusName" value="Schedule">
            <BR>
        </FIELDSET>
    </CENTER>

</BODY>
</HTML>