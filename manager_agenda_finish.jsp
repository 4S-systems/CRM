<%@page import="com.maintenance.common.ClosureConfigMgr"%>
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
        <!--<meta http-equiv="refresh" content="60" />-->
        <script type="text/javascript">
            $(document).ready(function() {
                $('#finishMsg').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]],
                    iDisplayLength: 10,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true,
                    "aaSorting": [[8, "asc"]]

                });
                $("#closedEndDate").datetimepicker({
                    changeMonth: true,
                    changeYear: true,
                    minDate: '0',
                    maxDate: '0',
                    dateFormat: "yy/mm/dd",
                    timeFormat: "hh:mm"
                });
                $('#employeesListF').dataTable({
                    bJQueryUI: true,
                        sPaginationType: "full_numbers",
                        "aLengthMenu": [[10, 25, -1], [10, 25, "All"]],
                        iDisplayLength: 10,
                        iDisplayStart: 0,
                        "bPaginate": true,
                        "bProcessing": true, 
                        "aaSorting": [[ 5, "desc" ]]
                }).show();
                
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
        <style>
            .close_button{
                width:135px;
                height:40px;
                float: right;
                margin: 0px;
                /*margin-right: 90px;*/
                border: none;
                background-repeat: no-repeat;
                cursor: pointer;
                margin-top: 3px;
                background-position: right top ;
                /*display: inline-block;*/
                background-color: transparent;
                background-image:url(images/buttons/close.png);
            }
            .login {
                /*display: none;*/
                direction: rtl;
                margin: 20px auto;
                padding: 10px 5px;
                /*        width:30%;*/
                background: #3f65b7;
                background-clip: padding-box;
                border: 1px solid #ffffff;
                border-bottom-color: #ffffff;
                border-radius: 5px;
                color: #ffffff;

                background: #7abcff; /* Old browsers */
                /* IE9 SVG, needs conditional override of 'filter' to 'none' */
                /*background: url(data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiA/Pgo8c3ZnIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgd2lkdGg9IjEwMCUiIGhlaWdodD0iMTAwJSIgdmlld0JveD0iMCAwIDEgMSIgcHJlc2VydmVBc3BlY3RSYXRpbz0ibm9uZSI+CiAgPGxpbmVhckdyYWRpZW50IGlkPSJncmFkLXVjZ2ctZ2VuZXJhdGVkIiBncmFkaWVudFVuaXRzPSJ1c2VyU3BhY2VPblVzZSIgeDE9IjAlIiB5MT0iMCUiIHgyPSIwJSIgeTI9IjEwMCUiPgogICAgPHN0b3Agb2Zmc2V0PSIwJSIgc3RvcC1jb2xvcj0iIzdhYmNmZiIgc3RvcC1vcGFjaXR5PSIxIi8+CiAgICA8c3RvcCBvZmZzZXQ9IjEwMCUiIHN0b3AtY29sb3I9IiM0MDk2ZWUiIHN0b3Atb3BhY2l0eT0iMSIvPgogIDwvbGluZWFyR3JhZGllbnQ+CiAgPHJlY3QgeD0iMCIgeT0iMCIgd2lkdGg9IjEiIGhlaWdodD0iMSIgZmlsbD0idXJsKCNncmFkLXVjZ2ctZ2VuZXJhdGVkKSIgLz4KPC9zdmc+);*/
                background: -moz-linear-gradient(top, #7abcff 0%, #4096ee 100%); /* FF3.6+ */
                background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#7abcff), color-stop(100%,#4096ee)); /* Chrome,Safari4+ */
                background: -webkit-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* Chrome10+,Safari5.1+ */
                background: -o-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* Opera 11.10+ */
                background: -ms-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* IE10+ */
                background: linear-gradient(to bottom, #7abcff 0%,#4096ee 100%); /* W3C */
                filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#7abcff', endColorstr='#4096ee',GradientType=0 ); /* IE6-8 */
            }
            .table td{
                padding:5px;
                text-align:center;
                font-family:Georgia, "Times New Roman", Times, serif;
                font-size:14px;
                font-weight: bold;
                border: none;
                margin-bottom: 30px;
            }
        </style>


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
        IssueByComplaint2Mgr issueByComplaint2Mgr = IssueByComplaint2Mgr.getInstance();
        // issuesVector = issueMgr.getIssuesListInRangeByEmg(new java.sql.Date(beginWeekCalendar.getTimeInMillis()), new java.sql.Date(endWeekCalendar.getTimeInMillis()),session);
        WebBusinessObject userWbo = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
        String[] key = new String[2];
        String[] value = new String[2];
        key[0] = "key3";
        key[1] = "key8";
        value[0] = userWbo.getAttribute("userId").toString();
        value[1] = "6";

        String bDate = beginInterval.toString().substring(8, 10) + "-" + beginInterval.toString().substring(5, 7) + "-" + beginInterval.toString().substring(0, 4);
        String day = endInterval.toString().substring(8, 10);
        int endDay = Integer.parseInt(day) + 1;
        String eDate = endDay + "-" + endInterval.toString().substring(5, 7) + "-" + endInterval.toString().substring(0, 4);
        String resp = "1";
        ArrayList<WebBusinessObject> actionsList = new ArrayList<>();
        ProjectMgr projectMgr = ProjectMgr.getInstance();
        String managerId, departmentId = "";
        WebBusinessObject departmentInfo = projectMgr.getManagerByEmployee((String) userWbo.getAttribute("userId"));
        if ((departmentInfo != null) && (departmentInfo.getAttribute("optionOne") != null) && (departmentInfo.getAttribute("eqNO") != null)) { //Has Manager
            managerId = (String) departmentInfo.getAttribute("optionOne");
            departmentInfo = projectMgr.getOnSingleKey("key5", managerId);
            departmentId = (String) departmentInfo.getAttribute("projectID");
            actionsList = new ArrayList<>(projectMgr.getOnArbitraryDoubleKeyOracle(departmentId, "key2", "action", "key4"));
        } else { // May be he is a manager
            departmentInfo = projectMgr.getOnSingleKey("key5", (String) userWbo.getAttribute("userId"));
            if ((departmentInfo != null) && (departmentInfo.getAttribute("optionOne") != null) && (departmentInfo.getAttribute("eqNO") != null)) { //Has Manager
                departmentId = (String) departmentInfo.getAttribute("projectID");
                actionsList = new ArrayList<>(projectMgr.getOnArbitraryDoubleKeyOracle(departmentId, "key2", "action", "key4"));
            }
        }
        List<WebBusinessObject> userUnderManager = UserMgr.getInstance().getEmployeeByDepartmentId(departmentId, null, null);

        SecurityUser securityUser = (SecurityUser) session.getAttribute("securityUser");
        Map<String, String> withinIntervals = securityUser.getWithinIntervals();
        Calendar cal = Calendar.getInstance();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
        String nowTime = sdf.format(cal.getTime());
        String toDateVal = nowTime;
        if(request.getParameter("toDateFinish") != null) {
            toDateVal = request.getParameter("toDateFinish");
            withinIntervals.put("toDateFinish", "" + toDateVal);
        } else if (withinIntervals.containsKey("toDateFinish")) {
            toDateVal = withinIntervals.get("toDateFinish");
        }
        cal.add(Calendar.DAY_OF_MONTH, -1);
        nowTime = sdf.format(cal.getTime());
        String fromDateVal = nowTime;
        if(request.getParameter("fromDateFinish") != null) {
            fromDateVal = request.getParameter("fromDateFinish");
            withinIntervals.put("fromDateFinish", "" + fromDateVal);
        } else if (withinIntervals.containsKey("fromDateFinish")) {
            fromDateVal = withinIntervals.get("fromDateFinish");
        }
        issuesVector = issueByComplaint2Mgr.getComplaintsWithoutDate(2, value, key, "key7", resp, null, new java.sql.Date(sdf.parse(fromDateVal).getTime()), new java.sql.Date(sdf.parse(toDateVal).getTime()));//.getOnArbitraryKeyOrdered(userWbo.getAttribute("userId").toString(), "key3", "key7");
        
        ClosureConfigMgr userClosureConfigMgr = ClosureConfigMgr.getInstance();
        ArrayList closureActionsList = userClosureConfigMgr.getClosuresByUser(userWbo.getAttribute("userId").toString());
        sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm");
        nowTime = sdf.format(Calendar.getInstance().getTime());        

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
            compSender = "Sender";
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


    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
        function changePage(url) {
            window.navigate(url);
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

        function getComplaint(issueId, compId) {
            window.navigate('<%=context%>/IssueServlet?op=getCompl&issueId=' + issueId + '&compId=' + compId);
        }
        function closeComp(issueId, compId) {
            window.navigate('<%=context%>/IssueServlet?op=closeComp&issueId=' + issueId + '&compId=' + compId);
        }
        function removeComp(issueId, compId) {
            window.navigate('<%=context%>/IssueServlet?op=removeComp&issueId=' + issueId + '&compId=' + compId);
        }
        function submitformFinish()
        {
            document.within_form_finish.submit();
        }
        function popupClose() {
            if ($(".caseClose:checked").length > 0 && $(".caseClose:checked").length < 11) {
                $('#closeNote').bPopup();
                $('#closeNote').css("display", "block");
            } else if($(".caseClose:checked").length > 10) {
                alert("لا يمكن أغلاق أكثر من 10 طلبات في المرة الواحدة");
            } else {
                alert("أختر علي اﻷقل طلب لأغلاقه");
            }
        }
        function closeComplaints(obj){
            $(obj).attr("disabled", "true");
            var selectedMsg = "";
            var note = "";
            var ids = [];
            var issueIDs = [];
            selectedMsg = $("#finishMsg").find(".caseClose:checkbox:checked");
            note = $("#closureNotes").val();
            $(selectedMsg).each(function(index, obj) {
                var temp = $(obj).val().split(",");
                ids.push(temp[0]);
                issueIDs.push(temp[1]);
            });
            var endDate = $('#closedEndDate').val();
            var actionTaken = $('#closedActionTaken').val();
            $.ajax({
                type: "post",
                url: "<%=context%>/ComplaintEmployeeServlet?op=closeMultiComplaintsAjax",
                data: {
                    ids: ids.join(),
                    issueIDs: issueIDs.join(),
                    note: note,
                    endDate: endDate,
                    actionTaken: actionTaken
                },
                success: function(jsonString) {
                    var info = $.parseJSON(jsonString);
                    if (info.status === 'ok') {
                        alert("تم الأغلاق بنجاح");
                        location.reload();
                    } else if (info.status === 'error') {
                        alert("لم يتم الأغلاق");
                        $(obj).removeAttr("disabled");
                        $("#closeNote").bPopup().close();
                    }
                }
            });
            return false;
        }
        function popupFinishBookmark(obj) {
            if ($(".caseClose:checked").length > 0 && $(".caseClose:checked").length < 11) {
                $('#bookmarkFinishDiv').bPopup();
                $('#bookmarkFinishDiv').css("display", "block");
            } else if($(".caseClose:checked").length > 10) {
                alert("لا يمكن أختيار أكثر من 10 طلبات في المرة الواحدة");
            } else {
                alert("أختر علي اﻷقل طلب واحد");
            }
        }
        function bookmarkFinishComplaints(obj) {
            $(obj).attr("disabled", "true");
            var selectedMsg = "";
            var note = "";
            var title = "";
            var ids = [];
            selectedMsg = $("#finishMsg").find(".caseClose:checkbox:checked");
            note = $("#bookmarkFinishNote").val();
            title = $("#bookmarkFinishTitle").val();
            $(selectedMsg).each(function(index, obj) {
                var temp = $(obj).val().split(",");
                ids.push(temp[0]);
            });
            $.ajax({
                type: "post",
                url: "<%=context%>/BookmarkServlet?op=bookmarkMultiComplaintsAjax",
                data: {
                    ids: ids.join(),
                    title: title,
                    note: note
                },
                success: function(jsonString) {
                    var info = $.parseJSON(jsonString);
                    if (info.status === 'ok') {
                        alert("تم التسجيل بنجاح");
                        $(obj).removeAttr("disabled");
                        $("#finishMsg").find(".caseClose:checkbox:checked").prop('checked', false);
                        $("#bookmarkFinishDiv").bPopup().close();
                    } else if (info.status === 'error') {
                        alert("لم يتم التسجيل");
                        $(obj).removeAttr("disabled");
                        $("#bookmarkFinishDiv").bPopup().close();
                    }
                }
            });
            return false;
        }
        function showDistributionFormF() {
            if ($(".caseClose:checked").length === 1) {
                $("#distributionMsg").text("");
                $('#distributionFormF').bPopup();
                $('#distributionFormF').css("display", "block");
            } else if($(".caseClose:checked").length > 1) {
                alert("لا يمكن أختيار أكثر من طلب واحد في المرة الواحدة");
            } else {
                alert("أختر طلب");
            }
        }
        function distributeToEmployeeF(obj) {
            var employeeId = $('#employeesListF').find(':input:checked');
            if (employeeId.val() !== null) {
                var ids = [];
                var issueIDs = [];
                var businessIDs = [];
                var selectedMsg = $(".caseClose:checkbox:checked");
                $(selectedMsg).each(function(index, obj) {
                    var temp = $(obj).val().split(",");
                    ids.push(temp[0]);
                    issueIDs.push(temp[1]);
                    businessIDs.push(temp[2]);
                });
                var subject = ids.length > 0 ? $("#subjectFDiv" + ids[0]).html() : "";
                $("#redistBtnF").hide();
                $.ajax({
                    type: "post",
                    url: "<%=context%>/IssueServlet?op=distributionToEmployee",
                    data: {
                        employeeId: employeeId.val(),
                        ids: ids.join(),
                        issueIDs: issueIDs.join(),
                        businessIDs: businessIDs.join(),
                        comment:  subject,
                        subject:  subject
                    },
                    success: function(jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.status === 'ok') {
                            location.reload();
                        }
                        if (info.status === 'error') {
                            $("#redistBtnF").show();
                            $("#distributionMsgF").css("display", "block");
                            $("#distributionMsgF").css("color", "red");
                            $("#distributionMsgF").css("font-size", "15px");
                            $("#distributionMsgF").text("لم يتم التوزيع");
                        }
                    }, error: function(jsonString) {
                        alert(jsonString);
                    }
                });
            } else {
                $("#distributionMsgF").css("display", "block");
                $("#distributionMsgF").css("color", "red");
                $("#distributionMsgF").css("font-size", "15px");
                $("#distributionMsgF").text("يجب اختيار موظف");
            }
        }
    </SCRIPT>
    <BODY>
    <CENTER>
        <div id="distributionFormF"  style="width:40%;display: none;">
            <div style="clear: both;margin-left: 89%;margin-top: 0px;margin-bottom: -35px;z-index: -10;">
                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;" onclick="closePopup(this)"/>
            </div>
            <div class="login" style="width: 90%;float: left;margin-bottom: 3px;">
                <table id="employeesListF" align="center" WIDTH="100%" CELLPADDING="0" cellspacing="0" style="">
                    <thead>
                        <TR>
                            <TH><SPAN style=""></SPAN></TH>
                            <TH><SPAN><img src="images/icons/client.png" width="20" height="20" /><b>اسم الموظف</b></SPAN></TH>
                        </TR>
                    </thead>
                    <tbody  >  
                        <%
                            if (userUnderManager != null) {
                                for (WebBusinessObject wbo : userUnderManager) {
                                    if(!wbo.getAttribute("userId").equals(userWbo.getAttribute("userId"))) {
                        %>
                        <TR id="empRow">
                            <TD style="background-color: transparent;">
                                <SPAN style="display: inline-block;height: 20px;background: transparent;">
                                    <INPUT type="radio" id="empId" class="case" value="<%=wbo.getAttribute("userId")%>" name="selectedEmp"/>
                                    <input type="hidden" id="employeeId" value="<%=wbo.getAttribute("userId")%>" />
                                </SPAN>
                            </TD>
                            <TD style="background-color: transparent;">
                                <%=wbo.getAttribute("fullName")%>
                            </TD>
                        </TR>
                        <%
                                    }
                                }
                            }
                        %>
                    </tbody>
                </table>
                <div style="width: 100%;text-align: center;margin-left: auto;margin-right: auto;">
                    <input type="button" id="redistBtnF" onclick="JavaScript: distributeToEmployeeF();" class="managerBt" value="" style="margin-top: 15px;font-family: sans-serif;">
                    <b id="distributionMsgF"></b>
                </div>
            </div>
        </div>
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
            </DIV>
            <form name="within_form_finish" style="margin-left: 200px;">
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
                            <input class="fromToDate" id="fromDateFinish" name="fromDateFinish" type="text" value="<%=fromDateVal%>" readonly/><img src="images/showcalendar.gif"/>
                            <br/><br/>
                        </td>
                        <td style="text-align: center; font-size: 14px; border-width: 1px; border-color: white;" bgcolor="#EEEEEE" style="text-align:right" valign="middle">
                            <input class="fromToDate" id="toDateFinish" name="toDateFinish" type="text" value="<%=toDateVal%>" readonly/><img src="images/showcalendar.gif"/>
                            <br/><br/>
                        </td>
                    </tr>
                </table>
            </form>
            <div style="float: right;margin: 0px;" id="actionBtn">
                <div class="close_button" onclick="popupClose(this);"></div>
            </div>
            <div style="float: right;margin: 0px;" id="bookmarkBtn">
                <div class="bookmark_button" onclick="popupFinishBookmark(this);"></div>
            </div>
            <div style="float: right;margin: 0px;" id="distBtn">
                <div class="managerBt" onclick="showDistributionFormF();"></div>
            </div>
            <TABLE   id="finishMsg" align="center" DIR="<%=dir%>" WIDTH="100%" CELLPADDING="0" cellspacing="0">
                <thead><TR>
                        <TH  ><SPAN ></SPAN></TH>
                        <TH ><SPAN ><img src="images/icons/Numbers.png" width="20" height="20" /><b> <%=complaintNo%></b></SPAN></TH>
                        <TH  ><SPAN><img src="images/icons/client.png" width="20" height="20" /><b> <%=customerName%></b></SPAN></TH>
                        <TH ><SPAN><b><%=type%></b></SPAN></TH>
                        <TH ><SPAN><img src="images/icons/list_.png" width="20" height="20" /><b> <%=complaint%></b></SPAN></TH>
                        <TH><SPAN><b>المصدر</b></SPAN></TH>
                        <TH><SPAN><img src="images/icons/manager.png" width="18" height="18" /><b> <%=compSender%></b></SPAN></TH>
                        <TH><SPAN><img src="images/icons/key.png" width="20" height="20" /><b> <%=complaintCode%></b></SPAN></TH>
                        <TH  ><SPAN><img src="images/icons/status_.png" width="18" height="18" /><b> <%=compStatus%></b></SPAN></TH>
                        <%--TH  ><SPAN><img src="images/icons/manager.png" width="18" height="18" /><b> المرسل</b></SPAN></TH--%>
                        <TH  width="9%"><img src="images/icons/Time.png" width="20" height="20" /><b> <%=complaintDate%></b></TH>
                        <TH  width="10%"><b><%=ageComp%></b></TH>
                    </TR></thead>
                <tbody  >  
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
                        <TD style="background-color: transparent;">
                            <SPAN style="display: inline-block;height: 20px;">
                                <input type="checkbox" class="caseClose" value="<%=wbo.getAttribute("clientComId") + "," + wbo.getAttribute("issue_id") + "," + wbo.getAttribute("businessID")%>" name="selectedIssue" />

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


                        <TD    style="cursor: pointer" onmouseover="this.className = '<%=compStyle%>'" onmouseout="this.className = ''">
                            <a href="<%=context%>/IssueServlet?op=getCompl2&issueId=<%=wbo.getAttribute("issue_id")%>&compId=<%=wbo.getAttribute("clientComId")%>&statusCode=<%=wbo.getAttribute("statusCode")%>&receipId=<%=wbo.getAttribute("receipId")%>&senderID=<%=wbo.getAttribute("senderId")%>&clientType=<%=wbo.getAttribute("age")%>"
                               onmouseover="JavaScript: getRequestsCount('<%=wbo.getAttribute("issue_id")%>', this);"> <font color="red"><%=wbo.getAttribute("businessID").toString()%></font><font color="blue">/<%=wbo.getAttribute("businessIDbyDate").toString()%></font>
                            </a>

                        </TD>
                        <TD   ><b><%=wbo.getAttribute("customerName")%></b>
                            <a href="<%=context%>/ClientServlet?op=clientDetails&clientId=<%=wbo.getAttribute("customerId")%>">
                                <img src="images/client_details.jpg" width="30" style="float: left;" title="تفاصيل"
                                     onmouseover="JavaScript: changeCommentCounts('<%=wbo.getAttribute("customerId")%>', this);"/>
                            </a>
                        </TD>

                        <TD  ><b><%=wbo.getAttribute("typeName")%></b></TD>
                        <TD  STYLE="text-align:center; padding: 5px; font-size: 12px;" width="20%">
                        <% String sCompl = " ";
                            if (wbo.getAttribute("compSubject") != null && !wbo.getAttribute("compSubject").equals("")) {
                                sCompl = (String) wbo.getAttribute("compSubject");
                                if (sCompl.length() > 10) {
                                    //sCompl = sCompl.substring(0,23) + "....";
%>
                        <b id="subjectFDiv<%=wbo.getAttribute("clientComId")%>"><%=sCompl%></b>
                                <% } else {%>
                        <b id="subjectFDiv<%=wbo.getAttribute("clientComId")%>"><%=sCompl%></b>
                                <% }%>
                                <% } else {%>
                        <b id="subjectFDiv<%=wbo.getAttribute("clientComId")%>"><%=sCompl%></b>
                        <%}
                        if(clientCompWbo.getAttribute("ticketType") != null && (((String) clientCompWbo.getAttribute("ticketType")).equals(CRMConstants.CLIENT_COMPLAINT_TYPE_REQUEST_EXTRADITION)
                                || ((String) clientCompWbo.getAttribute("ticketType")).equals(CRMConstants.CLIENT_COMPLAINT_TYPE_DELIVERY_OF_QUALITY))) {
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
                        <TD style="width: 10%;"><b><%=wbo.getAttribute("currentOwner") != null && !wbo.getAttribute("currentOwner").equals("") ? wbo.getAttribute("currentOwner") : ""%></b></TD>
                        <TD  ><b><%=wbo.getAttribute("businessCompId")%></b></TD>
                                <% if (stat.equals("En")) {
                                        complStatus = (String) wbo.getAttribute("statusEnName");
                                    } else {
                                        complStatus = (String) wbo.getAttribute("statusArName");;
                                    }
                                %>
                        <TD  ><b><%=complStatus%></b></TD>
                        <%--TD  ><b><%=sender%></b></TD--%>
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
                        <td style="border-left:0px; border-right:0px; border-bottom: 1px black; ">
                            <%
                                try {
                                    out.write(DateAndTimeControl.getDelayTime(wbo.getAttribute("entryDate").toString(), "Ar"));
                                } catch (Exception E) {
                                    out.write(noResponse);
                                }
                            %>
                        </td>
                    </TR>
                    <% }%>
                </tbody>
                <!--                <center>
                                    <TR>
                                        <TD CLASS="blueBorder blueBodyTD" BGCOLOR="#808080" COLSPAN="7" STYLE="text-align:center;color:white;font-size:16px;">
                                            <b><%=totalTasks%></b>
                                        </TD>
                                        <TD CLASS="blueBorder blueBodyTD" BGCOLOR="#808080" colspan="2" STYLE="text-align:center;color:white;font-size:14px;">
                                            <B><%=iTotal%></B>
                                        </TD>
                                    </TR>
                                </center>-->
            </TABLE>
            <input type="hidden" name="beginDate" id="beginDate" value="<%=beginDate%>">
            <input type="hidden" name="endDate" id="endDate" value="<%=endDate%>">
            <input type="hidden" name="projectName" id="projectName" value="All">
            <input type="hidden" name="statusName" id="statusName" value="Schedule">
            <BR>
        </FIELDSET>
    </CENTER>
    <div id="closeNote"  style="width: 40%;display: none; position: fixed">
        <div style="clear: both;margin-left: 93%;margin-top: 0px;margin-bottom: -38px;z-index: -10000000;">
            <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);background-color: transparent;
                 -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                 box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                 -webkit-border-radius: 100px;
                 -moz-border-radius: 100px;
                 border-radius: 100px;" onclick="closePopup(this)"/>
        </div>

        <!--<h1>رسالة قصيرة</h1>-->
        <div class="login" style="width:90%;margin-left: auto;margin-right: auto;">
            <table  border="0px" class="table" style="width:100%;text-align: right;margin-bottom: 10px !important;margin-left: auto;margin-right: auto;" >

                <tr>
                    <td style="width: 40%;"> <label style="width: 100px;">اﻷجراء المحدد</label></td>
                    <td style="width: 60%;">
                        <select id="closedActionTaken" name="closedActionTaken" STYLE="width:175px;font-size: small;text-align: right;float: right">
                            <sw:WBOOptionList wboList='<%=closureActionsList%>' displayAttribute = "title" valueAttribute="id" />
                            <option value="100" selected>لا شيئ</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td style="width: 40%;"> <label style="width: 100px;">ملاحظات الإغلاق</label></TD>
                    <td style="width: 60%;"><TEXTAREA cols="40" rows="5" name="notes" id="closureNotes"></TEXTAREA></TD>
                </TR>
                <tr>
                    <td style="width: 40%;"> <label style="width: 100px;">التاريخ</label></TD>
                    <td style="width: 60%;">  <input name="closedEndDate" id="closedEndDate" type="text" size="40" maxlength="50" style="width:50%;float: right;font-size: 12px;" value="<%=nowTime%>"/></TD>
                </TR>
                <tr>
                    <td colspan="2" > 
                        <input type="button"  onclick="JavaScript:closeComplaints(this);" class="close_button" style="float: none !important;"/>
                    </TD>
                </tr>
                <tr>
                    <%
                        String msg = "\u062A\u0645 \u0627\u0644\u0623\u063A\u0644\u0627\u0642 \u0628\u0646\u062C\u0627\u062D";
                        if (MetaDataMgr.getInstance().getSendMail() != null && MetaDataMgr.getInstance().getSendMail().equalsIgnoreCase("1")) {
                            msg += " \u0648 \u0623\u0631\u0633\u0627\u0644 \u0625\u0645\u064A\u0644 \u0628\u0630\u0644\u0643";
                    %>

                    <% }%>
                    <td colspan="2" >
                        <div style="margin: 0 auto;display: none; width: 90%;text-align: center;color: white" id="closedMsg"><%=msg%></div>
                    </td>
                </tr>
            </TABLE>
        </div>
    </div>
    <div id="bookmarkFinishDiv"  style="width: 30% ;margin-right: auto ;margin-left: auto;display: none;position: fixed;top: 0%;">
        <div style="clear: both;margin-left: 88%;margin-bottom: -38px;z-index: -10000000;">
            <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                -webkit-border-radius: 100px;
                -moz-border-radius: 100px;
                border-radius: 100px;" onclick="closePopup(this)"/>
        </div>
        <div class="login" style="width: 85%;margin-bottom: 10px;margin-left: auto;margin-right: auto;">
            <table  border="0px"  style="width:100%;"  class="table">
                <tr>
                    <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 30%;">العنوان</td>
                    <td style="width: 70%; text-align: left;" >
                        <input name="bookmarkFinishTitle" id="bookmarkFinishTitle" value="" style="width: 100%;"/>
                    </td>
                </tr> 
                <tr>
                    <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 30%;">التفاصيل</td>
                    <td style="width: 70%;" >
                        <textarea  placeholder="" style="width: 100%;height: 80px;" id="bookmarkFinishNote" > </textarea>
                    </td>
                </tr> 
            </table>
            <div style="text-align: center;margin-left: auto;margin-right: auto;clear: both" >
                <input type="button"  onclick="JavaScript: bookmarkFinishComplaints(this);" class="bookmark_button" style="float: none !important;"/>
            </div>
        </div>  
    </div>
</BODY>
</HTML>