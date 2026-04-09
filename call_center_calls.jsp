<%@page import="com.clients.db_access.ClientComplaintsMgr"%>
<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="com.tracker.engine.IssueStatusFactory, com.tracker.engine.*,java.text.*,com.docviewer.db_access.*, com.maintenance.db_access.*,com.maintenance.common.ParseSideMenu"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %> 
<%@ page contentType="text/HTML; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<HTML>
     <c:set var="loc" value="en"/>
    <c:if test="${!(empty sessionScope.currentMode)}">
      <c:set var="loc" value="${sessionScope.currentMode}"/>
    </c:if>
    <fmt:setLocale value="${loc}"  />
    <fmt:setBundle basename="Languages.Sales_Market.Sales_Market"  />
    <meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <meta HTTP-EQUIV="Expires" CONTENT="0">
    <head>
        <title>Weekly Manager Agenda</title>
        <script type="text/javascript">

            $(document).ready(function() {
                $('#calls').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[20, 40, 70, 100, -1], [20, 40, 70, 100, "All"]],
                    iDisplayLength: 20,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true,
                    "aaSorting": [[0, "desc"]],
                    "aaSorting": [[3, "asc"]]

                }).show();
            });

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
        IssueByComplaintAllCaseMgr issueByComplaintAllCaseMgr = IssueByComplaintAllCaseMgr.getInstance();
        // issuesVector = issueMgr.getIssuesListInRangeByEmg(new java.sql.Date(beginWeekCalendar.getTimeInMillis()), new java.sql.Date(endWeekCalendar.getTimeInMillis()),session);
        WebBusinessObject userWbo = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
        String[] key = new String[1];
        String[] value = new String[1];

        key[0] = "key8";

        value[0] = "7";

        String bDate = beginInterval.toString().substring(8, 10) + "-" + beginInterval.toString().substring(5, 7) + "-" + beginInterval.toString().substring(0, 4);
        String day = endInterval.toString().substring(8, 10);
        int endDay = Integer.parseInt(day) + 1;
        String eDate = endDay + "-" + endInterval.toString().substring(5, 7) + "-" + endInterval.toString().substring(0, 4);
        String resp = "1";
        issueMgr = IssueMgr.getInstance();

        SecurityUser securityUser = (SecurityUser) session.getAttribute("securityUser");
        int withinCalls = 24;
        Map<String, String> withinIntervals = securityUser.getWithinIntervals();
        if (request.getParameter("withinCalls") != null) {
            withinCalls = new Integer(request.getParameter("withinCalls"));
            withinIntervals.put("withinCalls", "" + withinCalls);
        } else if (withinIntervals.containsKey("withinCalls")) {
            withinCalls = (new Integer(withinIntervals.get("withinCalls")));
        }
        
        securityUser = (SecurityUser) session.getAttribute("securityUser");
        withinIntervals = securityUser.getWithinIntervals();
        Calendar cal = Calendar.getInstance();
        String timeFormat = "yyyy/MM/dd";
        SimpleDateFormat sdf = new SimpleDateFormat(timeFormat);
        String nowTime = sdf.format(cal.getTime());
        String toDateVal2 = nowTime;
        if(request.getParameter("toDate2") != null) {
            toDateVal2 = request.getParameter("toDate2");
            withinIntervals.put("toDate2", "" + toDateVal2);
        } else if (withinIntervals.containsKey("toDate2")) {
            toDateVal2 = withinIntervals.get("toDate2");
        }
        cal.add(Calendar.DAY_OF_MONTH, -1);
        nowTime = sdf.format(cal.getTime());
        String fromDateVal2 = nowTime;
        if(request.getParameter("fromDate2") != null) {
            fromDateVal2 = request.getParameter("fromDate2");
            withinIntervals.put("fromDate2", "" + fromDateVal2);
        } else if (withinIntervals.containsKey("fromDate2")) {
            fromDateVal2 = withinIntervals.get("fromDate2");
        }
        
        issuesVector = issueMgr.getIssues(withinCalls, (String) userWbo.getAttribute("userId"), fromDateVal2, toDateVal2);

        //.getOnArbitraryKeyOrdered(userWbo.getAttribute("userId").toString(), "key3", "key7");
        String stat = (String) request.getSession().getAttribute("currentMode");
        String title, from, to, align, dir, style, Indicators, Quick, important, expectedBegin, expectedEnd, totalTasks;
        String viewD, scheduleCase, executionCase, onHoldCase, fontSize, issueNo, issueTit, equip, issueStatus;
        String complaintNo, customerName, complaintDate, complaint;
        String sat, sun, mon, tue, wed, thu, fri, view, complaintCode, type, compStatus, compSender, noResponse, ageComp;
        String complStatus, senderName = null, fullName = null, viewDocuments, photoGallery,
                callNo, noReq, callTyp, cDir, callDate, clntNo;
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
            complaintDate = "Calling date";
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
            viewDocuments = "View Documents";
            photoGallery = "Photo Gallery";
            callNo = "Contact No";
            noReq = "No Of Requests/Calls";
            callTyp = "Contact Type";
            cDir = "Contact direction";
            callDate = "Contact Date";
            clntNo = "Client No";
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
            complaintDate = "&#1608;&#1602;&#1578; &#1575;&#1604;&#1575;&#1578;&#1589;&#1575;&#1604;";
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
            viewDocuments = "مشاهدة المرفقات";
            photoGallery = "عرض الصور";
            callNo = "رقم الاتصال";
            noReq = "عددالطلبات/المكالمات";
            callTyp = "نوع الاتصال";
            cDir = "اتجاه الاتصال";
            callDate = "تاريخ المكالمه";
            clntNo = "رقم العميل";
        }
        String sDate, sTime = null;


    %>

    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
        $(function () {
            $("#fromDate2,#toDate2").datepicker({
                maxDate: "+d",
                changeMonth: true,
                changeYear: true,
                dateFormat: 'yy/mm/dd'
            });
        });
        
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

        function updateCallType(obj) {
            $(obj).parent().parent().find("#showContent").css("display", "none");
            $(obj).parent().parent().find("#showContent1").css("display", "block");
        }
        function removeCallType(obj) {
            $(obj).parent().parent().find("#showContent1").css("display", "none");
            $(obj).parent().parent().find("#showContent").css("display", "block");
        }
        function removeCallDir(obj) {

            $(obj).parent().parent().find("#showContent3").css("display", "none");
            $(obj).parent().parent().find("#showContent2").css("display", "block");

        }
        function updateCallType2(obj) {

            $(obj).parent().parent().find("#showContent3").css("display", "block");
            $(obj).parent().parent().find("#showContent2").css("display", "none");

        }
        function updateDirections(obj) {

            var direction = $(obj).parent().find("#direction:checked").val();


            var x = "";
            if (direction == "incoming") {
                x = "واردة";
            }
            if (direction == "out_call") {
                x = "صادرة";
            }

            var issueId = $(obj).parent().parent().parent().find("#issueId").val();
            $.ajax({
                type: "post",
                url: "<%=context%>/IssueServlet?op=updateCallDirection",
                data: {
                    direction: direction,
                    issueId: issueId
                },
                success: function(jsonString) {
                    var info = $.parseJSON(jsonString);

                    if (info.status == 'ok') {
                        $(obj).parent().parent().find("#showContent2").css("display", "block");
                        $(obj).parent().parent().find("#showContent3").css("display", "none");

                        $(obj).parent().parent().find("#callType").html(x);
                    }
                    if (info.status == 'no') {
                        $(obj).parent().parent().find("#showContent2").css("display", "none");
                        $(obj).parent().parent().find("#showContent3").css("display", "block");
                        alert("وقع خطأ فى التحديث");
                    }
                    if (info.status == 'noChoose') {
                        $(obj).parent().parent().find("#showContent2").css("display", "none");
                        $(obj).parent().parent().find("#showContent3").css("display", "block");
                        alert("إختر اولا ثم قم بالتعديل");
                    }

                }
            });



        }
        function updateType(obj) {
            //            var x= $(obj).parent().find("#note").val();
            //            alert(x.length)
            //            if(x.length>0){

            var callType = $(obj).parent().find("#note:checked").val();
            var issueId = $(obj).parent().parent().parent().find("#issueId").val();
            $.ajax({
                type: "post",
                url: "<%=context%>/IssueServlet?op=updateCallType",
                data: {
                    callType: callType,
                    issueId: issueId
                },
                success: function(jsonString) {
                    var info = $.parseJSON(jsonString);

                    if (info.status == 'ok') {
                        $(obj).parent().parent().find("#showContent").css("display", "block");
                        $(obj).parent().parent().find("#showContent1").css("display", "none");

                        $(obj).parent().parent().find("#callType").html(callType);
                    }
                    if (info.status == 'no') {
                        $(obj).parent().parent().find("#showContent").css("display", "none");
                        $(obj).parent().parent().find("#showContent1").css("display", "block");
                        alert("وقع خطأ فى التحديث");
                    }
                    if (info.status == 'noChoose') {
                        $(obj).parent().parent().find("#showContent2").css("display", "none");
                        $(obj).parent().parent().find("#showContent3").css("display", "block");
                        alert("إختر اولا ثم قم بالتعديل");
                    }
                }
            });
            //            }else{alert("قم بالإختيار للتعديل")}


        }

        function viewDocuments(issueId) {
            var url = '<%=context%>/IssueDocServlet?op=ListAttachedDocs&issueId=' + issueId + '';
            var wind = window.open(url, "عرض المستندات", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no");
            wind.focus();
        }

        function viewImages(issueId) {
            var url = '<%=context%>/IssueDocServlet?op=ViewIssueImages&issueId=' + issueId + '';
            var wind = window.open(url, "عرض الصور", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no");
            wind.focus();
        }
        function submitformCalls()
        {
            document.within_form2.submit();
        }
    </SCRIPT>
    <style type="text/css">
        #link :hover{

            background: #f9f9f9;
        }
        .save__{
            width:20px;
            height:20px;
            background-image:url(images/icons/icon-32-publish.png);
            background-repeat: no-repeat;
            background-position: bottom;
            cursor: pointer;
            display: inline-block;
            margin-right: 3px;

        }
        .update__{
            width:20px;
            height:20px;
            background-image:url(images/icons/icon-32-unpublish.png);
            background-repeat: no-repeat;
            background-color: transparent;
            background-position: top;
            cursor: pointer;

        }
        .remove__{
            width:20px;
            height:20px;
            background-image:url(images/icons/icon-32-remove.png);
            background-repeat: no-repeat;
            background-color: transparent;
            background-position: top;
            cursor: pointer;
            display: inline-block
        }
    </style>
    <script src='ChangeLang.js' type='text/javascript'></script>
    <BODY>
    <CENTER>
        <FIELDSET class="set" style="width:96%;" >

            <DIV align="<%=align%>" style="padding:<%=align%>; ">

            </DIV><br />
            <form name="within_form" style="direction:<fmt:message key="direction"/>">
                <table class="blueBorder" id="code2" align="center" dir="<fmt:message key="direction"/>" width="650" cellspacing="2" cellpadding="1"
                       style="border-width:1px;border-color:white;display: block;">
                    <tr class="head">
                        <td class="blueHeaderTD" style="text-align: center; font-size: 14px; border-width: 1px; border-color: white; width: 325px;">
                            <b><font size=3 color="white"><fmt:message key="fromDate"/></font></b>
                        </td>
                        <td class="blueHeaderTD" style="text-align: center; font-size: 14px; border-width: 1px; border-color: white; width: 325px;">
                            <b><font size=3 color="white"><fmt:message key="toDate"/></font></b>
                        </td>
                        <td style="text-align: center; font-size: 14px; border-width: 1px; border-color: white; width: 250px;" bgcolor="#EEEEEE" valign="middle" rowspan="2">
                            <button type="submit" class="button" style="width: 170px;"><fmt:message key="search"/><img height="15" src="images/search.gif"/></button>
                            <br/>
                            <br/>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: center; font-size: 14px; border-width: 1px; border-color: white;" bgcolor="#EEEEEE" valign="middle">
                            <input id="fromDate2" name="fromDate2" type="text" value="<%=fromDateVal2%>" readonly/><img src="images/showcalendar.gif"/>
                            <br/><br/>
                        </td>
                        <td style="text-align: center; font-size: 14px; border-width: 1px; border-color: white;" bgcolor="#EEEEEE" style="text-align:right" valign="middle">
                            <input id="toDate2" name="toDate2" type="text" value="<%=toDateVal2%>" readonly/><img src="images/showcalendar.gif"/>
                            <br/><br/>
                        </td>
                    </tr>
                </table>
            </form>
            <div style="width:70%;margin-right: auto;margin-left: auto;">
                <TABLE class="blueBorder"  id="calls" align="center" DIR="<%=dir%>" WIDTH="100%" CELLPADDING="0" cellspacing="0" style="display: none;">
                    <thead>
                        <TR>
                            <TH  style="font-size: 13px;" ><img src="images/icons/Numbers.png" width="20" height="20" /><b> <%=callNo%></b></TH>
                            <TH  style="font-size: 13px;" ><b><%=noReq%></b></TH>
                            <TH  style="font-size: 13px;" ><b><%=callTyp%></b></TH>
                            <TH  style="font-size: 13px;" ><b><%=cDir%></b></TH>
                            <TH style="font-size: 13px;"  ><b><%=callDate%></b></TH>
                            <TH  style="font-size: 13px;" ><b><%=clntNo%></b></TH>
                            <TH style="font-size: 13px;"  ><img src="images/icons/client.png" width="20" height="20" /><b> <%=customerName%></b></TH>
                        </TR>
                    </thead>
                    <tbody>  
                        <%
                            for (WebBusinessObject wbo : issuesVector) {

                                iTotal++;
                                String compStyle = "";
                        %>
                        <TR>

                            <TD id="link">
                                <a href='JavaScript:viewImages("<%=wbo.getAttribute("issueId")%>")'>
                                    <img src="images/imicon.gif" width="17" height="17" title="<%=photoGallery%>" />
                                </a>
                                <a href='JavaScript:viewDocuments("<%=wbo.getAttribute("issueId")%>")'>
                                    <img src="images/view.png" width="17" height="17" title="<%=viewDocuments%>" />
                                </a>
                                <%
                                    if (wbo.getAttribute("numOfOrders").equals("empty")) {
                                %>
                                <a style="color: red"><%=wbo.getAttribute("busId")%></a>
                                <%} else {%>

                                <a href="<%=context%>/IssueServlet?op=getCompUnderIssue&issueId=<%=wbo.getAttribute("issueId")%>" style="color: blue">
                                    <%=wbo.getAttribute("busId")%>
                                </a> 
                                <%}%>
                                <input type="hidden" id="issueId" value="<%=wbo.getAttribute("issueId")%>" />
                            </TD>
                            <TD style="width: 10%;">
                                <% if (wbo.getAttribute("numOfOrders").equals("empty")) {
                                %>

                                <LABEL style="color: #000">0</LABEL>
                                    <%} else {%>
                                <LABEL style="color: #000"><%=wbo.getAttribute("numOfOrders")%></LABEL>
                                    <%}%>

                            </TD>
                            <TD nowrap>
                                <div id="showContent" style="display: block">
                                    <b id="callType" <% if (!wbo.getAttribute("callType").equals("internal")) { %> onclick="updateCallType(this)" style="cursor: pointer"
                                       onMouseOver="Tip('تعديل', LEFT, true, OFFSETX, 0, BGCOLOR, '#FFFF99', FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT, 'BOLD', TITLEALIGN, 'center', TITLEFONTCOLOR, 'black', TITLEBGCOLOR, '#6699FF')" onMouseOut="UnTip()" <% }%>>
                                        <img src="images/dialogs/phone.png" alt="call" width="20px" style="display: <%=((String) wbo.getAttribute("issueDesc")).equalsIgnoreCase("call") ? "" : "none"%>"/>
                                        <img src="images/dialogs/handshake.png" alt="meeting" width="20px" style="display: <%=((String) wbo.getAttribute("issueDesc")).equalsIgnoreCase("meeting") ? "" : "none"%>"/>
                                        <img src="images/dialogs/internet-icon.png" alt="internet" width="20px" style="display: <%=((String) wbo.getAttribute("issueDesc")).equalsIgnoreCase("internet") ? "" : "none"%>"/>
                                        <%=wbo.getAttribute("issueDesc")%></b>
                                    <!-- <div  class="update__" onclick="updateCallType(this)" ></div>
                                    -->
                                </div>
                                <div id="showContent1" style="display: none">
                                    <input  name="note" type="radio" value="call"  id="note" />
                                    <label><img src="images/dialogs/phone.png" alt="phone" width="20px"/>مكالمة</label>
                                    <input name="note" type="radio" value="meeting" id="note" style="margin-right: 10px;"/>
                                    <label><img src="images/dialogs/handshake.png" alt="meeting" width="20px"/>مقابلة</label>
                                    <input name="note" type="radio" value="internet" id="note" style="margin-right: 10px;">
                                    <label> <img src="images/dialogs/internet-icon.png" alt="internet" width="20px"> أنترنت</label>
                                    <div class="save__" onclick="updateType(this)"></div>
                                    <div class="remove__" onclick="removeCallType(this)"></div>
                                </div>
                            </TD>
                            <TD nowrap>

                                <% String callType = "";
                                    String creationTime = (String) wbo.getAttribute("creationTime");
                                    creationTime = creationTime != null ? creationTime.substring(0, creationTime.lastIndexOf(":")) : "";
                                    if (wbo.getAttribute("callType").equals("incoming")) {

                                        callType = "واردة";%>
                                <%
                                } else if (wbo.getAttribute("callType").equals("out_call")) {
                                    callType = "صادرة";%>

                                <%} else if (wbo.getAttribute("callType").equals("") || wbo.getAttribute("callType").equals("null")) {
                                    callType = "";%>

                                <%}%>
                                <div id="showContent2">
                                    <b id="callType" onclick="updateCallType2(this)" style="cursor: pointer"
                                       onMouseOver="Tip('تعديل', LEFT, true, OFFSETX, 0, BGCOLOR, '#FFFF99', FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT, 'BOLD', TITLEALIGN, 'center', TITLEFONTCOLOR, 'black', TITLEBGCOLOR, '#6699FF')" onMouseOut="UnTip()">
                                        <img src="images/dialogs/call-incoming.png" width="20px" style="display: <%=wbo.getAttribute("callType").equals("incoming") ? "" : "none"%>"/>
                                        <img src="images/dialogs/call-outgoing.png" width="20px" style="display: <%=wbo.getAttribute("callType").equals("out_call") ? "" : "none"%>"/><%=callType%></b>
                                    <!--<div  class="update__" onclick="updateCallType2(this)"></div>-->

                                </div>
                                <div id="showContent3"  style="display: none">
                                    <input  name="direction" type="radio" value="incoming"  id="direction" />
                                    <label><img src="images/dialogs/call-incoming.png" width="24px"/>واردة</label>
                                    <input name="direction" type="radio" value="out_call" id="direction" style="margin-right: 10px;"/>
                                    <label><img src="images/dialogs/call-outgoing.png" width="24px"/>صادرة</label>
                                    <div class="save__" onclick="updateDirections(this)"></div>
                                    <div class="remove__" onclick="removeCallDir(this)"></div>
                                </div>



                            </TD>


                            <TD ><b><%=creationTime%></b></TD>
                            <TD ><%=wbo.getAttribute("clientNo")%></TD>
                            <TD ><b><%=wbo.getAttribute("clientName")%></b></TD>


                        </TR>
                        <% }%>
                    </tbody>

                </TABLE>
            </div>
            <input type="hidden" name="beginDate" id="beginDate" value="<%=beginDate%>">
            <input type="hidden" name="endDate" id="endDate" value="<%=endDate%>">
            <input type="hidden" name="projectName" id="projectName" value="All">
            <input type="hidden" name="statusName" id="statusName" value="Schedule">
            <BR>
        </FIELDSET>
    </CENTER>
</BODY>
</HTML>