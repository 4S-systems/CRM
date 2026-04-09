<%@page import="com.crm.common.CRMConstants"%>
<%@page import="com.clients.db_access.ClientComplaintsMgr"%>
<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="com.tracker.engine.IssueStatusFactory, com.tracker.engine.*,java.text.*,com.docviewer.db_access.*, com.maintenance.db_access.*,com.maintenance.common.ParseSideMenu"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %> 
<%@ page contentType="text/HTML; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page import="com.crm.common.CRMConstants"%>

<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    String newTap = metaMgr.getNewTap();
%>

<HTML>
    <c:set var="loc" value="en"/>
    <c:if test="${!(empty sessionScope.currentMode)}">
      <c:set var="loc" value="${sessionScope.currentMode}"/>
    </c:if>
<fmt:setLocale value="${loc}"  />
<fmt:setBundle basename="Languages.employee_agenda.employee_agenda"  />
    <meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <meta HTTP-EQUIV="Expires" CONTENT="0">
    <head>
        <title>Weekly Manager Agenda</title>
        <!--<meta http-equiv="refresh" content="60" />-->
        <script type="text/javascript">
            var oTable;
            $(document).ready(function(){
                $(".fromToDate").datepicker({
                    maxDate: "+d",
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: 'yy/mm/dd'
                });
                oTable = $('#inboxMsg').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[20, 25, 50, -1], [20, 25, 50, "All"]],
                    iDisplayLength: 20,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true

                }).fadeIn(2000);
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
        metaMgr = MetaDataMgr.getInstance();
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

        context = metaMgr.getContext();
       

        int iTotal = 0;

        beginWeekCalendar = (Calendar) weekCalendar.clone();
        endWeekCalendar = (Calendar) weekCalendar.clone();

        beginWeekCalendar.add(beginWeekCalendar.DATE, -dayOfWeekValue);
        endWeekCalendar.add(endWeekCalendar.DATE, 6 - dayOfWeekValue);

        java.sql.Date beginInterval = new java.sql.Date(beginWeekCalendar.getTimeInMillis());
        java.sql.Date endInterval = new java.sql.Date(endWeekCalendar.getTimeInMillis());
        EmployeeViewMgr employeeViewMgr = EmployeeViewMgr.getInstance();
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
        String timeFormat = "yyyy/MM/dd";
        SimpleDateFormat sdf = new SimpleDateFormat(timeFormat);
        String nowTime = sdf.format(cal.getTime());
        String toDateVal = nowTime;
        if(request.getParameter("toDateDetails") != null) {
            toDateVal = request.getParameter("toDateDetails");
            withinIntervals.put("toDateDetails", "" + toDateVal);
        } else if (withinIntervals.containsKey("toDateDetails")) {
            toDateVal = withinIntervals.get("toDateDetails");
        }
        cal.add(Calendar.DAY_OF_MONTH, -1);
        nowTime = sdf.format(cal.getTime());
        String fromDateVal = nowTime;
        if(request.getParameter("fromDateDetails") != null) {
            fromDateVal = request.getParameter("fromDateDetails");
            withinIntervals.put("fromDateDetails", "" + fromDateVal);
        } else if (withinIntervals.containsKey("fromDateDetails")) {
            fromDateVal = withinIntervals.get("fromDateDetails");
        }
        issuesVector = employeeViewMgr.getComplaintsWithoutDate2(3, value, key, "key7", resp, null,
                new java.sql.Date(sdf.parse(fromDateVal).getTime()), new java.sql.Date(sdf.parse(toDateVal).getTime()));//.getOnArbitraryKeyOrdered(userWbo.getAttribute("userId").toString(), "key3", "key7");
        //Privileges
        ArrayList<String> privilegesList = GroupPrevMgr.getInstance().getGroupPrivilegeCodes((String) ((WebBusinessObject) request.getSession().getAttribute("loggedUser")).getAttribute("groupID"));
        
        ArrayList<WebBusinessObject> actionsList = new ArrayList<>();
        ProjectMgr projectMgr = ProjectMgr.getInstance();
        String managerId, departmentId;
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
        sdf.applyPattern("yyyy/MM/dd HH:mm");
        nowTime = sdf.format(Calendar.getInstance().getTime());
        
        String stat = (String) request.getSession().getAttribute("currentMode");
        
        
        String sat, sun, mon, tue, wed, thu, fri, noResponse, ageComp, xAlign;
       
        if (stat.equals("En")) {
            
                  sat = "Sat";
            sun = "Sun";
            mon = "Mon";
            tue = "Tue";
            wed = "Wed";
            thu = "Thu";
            fri = "Fri";
           
              noResponse = "&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1578;&#1583;&#1575;&#1608;&#1604;";
            ageComp = "A.C(day)";
            xAlign = "right";
             
        } else {
            sat = "&#1575;&#1604;&#1587;&#1576;&#1578;";
            sun = "&#1575;&#1604;&#1575;&#1581;&#1583;";
            mon = "&#1575;&#1604;&#1575;&#1579;&#1606;&#1610;&#1606;";
            tue = "&#1575;&#1604;&#1579;&#1604;&#1575;&#1579;&#1575;&#1569;";
            wed = "&#1575;&#1604;&#1575;&#1585;&#1576;&#1593;&#1575;&#1569;";
            thu = "&#1575;&#1604;&#1582;&#1605;&#1610;&#1587;";
            fri = "&#1575;&#1604;&#1580;&#1605;&#1593;&#1577;";
             
              noResponse = "&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1578;&#1583;&#1575;&#1608;&#1604;";
            ageComp = "&#1593;.&#1591; (&#1610;&#1608;&#1605;)";
            xAlign = "left";
        }
        String sDate, sTime = null;
        
        List<WebBusinessObject> meetings = projectMgr.getMeetingProjects();
        projectMgr = ProjectMgr.getInstance();
        List<WebBusinessObject> userProjects = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKeyOracle("1365240752318", "key2"));
    %>


    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
        $(function () {
            $("#finishEndDate").datetimepicker({
                changeMonth: true,
                changeYear: true,
                minDate: '0',
                maxDate: '0',
                dateFormat: "yy/mm/dd",
                timeFormat: "hh:mm"
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

        function getComplaintss(issueId, compId, senderId,statusCode,receipId,senderID) {
            window.navigate('<%=context%>/IssueServlet?op=getCompl&issueId=' + issueId + '&senderId=' + senderId + '&compId=' + compId+ '&statusCode=' + statusCode+ '&receipId=' + receipId+ '&senderID=' + senderID);
            
        }
        function closeComp(issueId, compId) {
            window.navigate('<%=context%>/IssueServlet?op=closeComp&issueId=' + issueId + '&compId=' + compId);
        }
        function removeComp(issueId, compId) {
            window.navigate('<%=context%>/IssueServlet?op=removeComp&issueId=' + issueId + '&compId=' + compId);
        }
        function popupFinish(obj) {
            //                alert("popup begin");
            if ($(".case:checked").length > 0 && $(".case:checked").length < 11) {
                $('#finishNote').bPopup();
                $('#finishNote').css("display", "block");
            } else if($(".case:checked").length > 10) {
                alert("لا يمكن أنهاء أكثر من 10 طلبات في المرة الواحدة");
            } else {
                alert("أختر علي اﻷقل طلب لأنهاؤه");
            }
        }
        function finishComp(obj) {
            $(obj).attr("disabled", "true");
            var selectedMsg = "";
            var note = "";
            var ids = [];
            var issueIDs = [];
            selectedMsg = $("#inboxMsg").find(".case:checkbox:checked");
            note = $("#notes").val();
            $(selectedMsg).each(function(index, obj) {
                var temp = $(obj).val().split(",");
                ids.push(temp[0]);
                issueIDs.push(temp[1]);
            });
            var endDate = $('#finishEndDate').val();
            var actionTaken = $('#actionTaken').val();
            $.ajax({
                type: "post",
                url: "<%=context%>/ComplaintEmployeeServlet?op=finishMultiComplaintsAjax",
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
                        alert("تم الأنهاء بنجاح");
                        location.reload();
                    } else if (info.status === 'error') {
                        alert("لم يتم الأنهاء");
                        $(obj).removeAttr("disabled");
                        $("#finishNote").bPopup().close();
                    }
                }
            });
            return false;
        }
        function finishComp(obj) {
            $(obj).attr("disabled", "true");
            var selectedMsg = "";
            var note = "";
            var ids = [];
            var issueIDs = [];
            selectedMsg = $("#inboxMsg").find(".case:checkbox:checked");
            note = $("#notes").val();
            $(selectedMsg).each(function(index, obj) {
                var temp = $(obj).val().split(",");
                ids.push(temp[0]);
                issueIDs.push(temp[1]);
            });
            var endDate = $('#finishEndDate').val();
            var actionTaken = $('#actionTaken').val();
            $.ajax({
                type: "post",
                url: "<%=context%>/ComplaintEmployeeServlet?op=finishMultiComplaintsAjax",
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
                        alert("تم الأنهاء بنجاح");
                        location.reload();
                    } else if (info.status === 'error') {
                        alert("لم يتم الأنهاء");
                        $(obj).removeAttr("disabled");
                        $("#finishNote").bPopup().close();
                    }
                }
            });
            return false;
        }
        function openSession(clientID) {
          
            $.ajax({
                type: "post",
                url: "<%=context%>/ClientServlet?op=ViewClientMenu",
                data: {
                    clientID: clientID,
                },
                success: function(jsonString) {
                    
                }
            });
            return false;
        }
        function popupBookmark(obj) {
            if ($(".case:checked").length > 0 && $(".case:checked").length < 11) {
                $('#bookmarkDiv').bPopup();
                $('#bookmarkDiv').css("display", "block");
            } else if($(".case:checked").length > 10) {
                alert("لا يمكن أختيار أكثر من 10 طلبات في المرة الواحدة");
            } else {
                alert("أختر علي اﻷقل طلب واحد");
            }
        }
        function bookmarkComplaints(obj) {
            $(obj).attr("disabled", "true");
            var selectedMsg = "";
            var note = "";
            var title = "";
            var ids = [];
            selectedMsg = $("#inboxMsg").find(".case:checkbox:checked");
            note = $("#bookmarkNote").val();
            title = $("#bookmarkTitle").val();
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
                        $("#inboxMsg").find(".case:checkbox:checked").prop('checked', false);
                        $("#bookmarkDiv").bPopup().close();
                    } else if (info.status === 'error') {
                        alert("لم يتم التسجيل");
                        $(obj).removeAttr("disabled");
                        $("#bookmarkDiv").bPopup().close();
                    }
                }
            });
            return false;
        }
        function submitform2()
        {
            document.within_form2.submit();
        }
        
        function selectAll(obj) {
                $("input[name='selectedIssue']").prop('checked', $(obj).is(':checked'));
            }
    </SCRIPT>
    <script src='ChangeLang.js' type='text/javascript'></script>
    <style type="text/css">
         .turn_off{
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
            background-image:url(images/buttons/finish.png);
        }
        .bookmark_button{
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
            background-image:url(images/buttons/bookmarked.png);
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
    <BODY>
    <CENTER>
        <FIELDSET class="set" style="width:100%;" >
            
            <DIV align=<fmt:message key="align"/> style="padding-<fmt:message key="align"/>: 2.5%">
     </DIV>
            <form name="within_form2" style="margin-left: auto; margin-right: auto;">
                <table class="blueBorder" id="code2" align="center" dir="<fmt:message key="direction"/>" width="650" cellspacing="2" cellpadding="1"
                       style="border-width:1px;border-color:white;display: block;">
                    <tr class="head">
                        <td class="blueHeaderTD" style="text-align: center; font-size: 14px; border-width: 1px; border-color: white; width: 325px;">
                            <b><font size=3 color="white" title="<fmt:message key="distdate"/>"><fmt:message key="fromDate"/></font></b>
                        </td>
                        <td class="blueHeaderTD" style="text-align: center; font-size: 14px; border-width: 1px; border-color: white; width: 325px;">
                            <b><font size=3 color="white" title="<fmt:message key="distdate"/>"><fmt:message key="toDate"/></font></b>
                        </td>
                        <td style="text-align: center; font-size: 14px; border-width: 1px; border-color: white; width: 250px;" bgcolor="#EEEEEE" valign="middle" rowspan="2">
                            <button type="submit" class="button" style="width: 170px;"><fmt:message key="search"/><img height="15" src="images/search.gif"/></button>
                            <br/>
                            <br/>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: center; font-size: 14px; border-width: 1px; border-color: white;" bgcolor="#EEEEEE" valign="middle">
                            <input class="fromToDate" id="fromDateDetails" name="fromDateDetails" type="text" value="<%=fromDateVal%>" readonly/><img src="images/showcalendar.gif"/>
                            <br/><br/>
                        </td>
                        <td style="text-align: center; font-size: 14px; border-width: 1px; border-color: white;" bgcolor="#EEEEEE" style="text-align:right" valign="middle">
                            <input class="fromToDate" id="toDateDetails" name="toDateDetails" type="text" value="<%=toDateVal%>" readonly/><img src="images/showcalendar.gif"/>
                            <br/><br/>
                        </td>
                    </tr>
                </table>
                <%
                    if (privilegesList.contains("MULTI_FINISH")) {
                %>
                <div style="float: right;margin: 0px;" id="actionBtn">
                    <div class="turn_off" onclick="popupFinish(this);"></div>
                </div>
                <%
                    }
                    if (privilegesList.contains("MULTI_BOOKMARK")) {
                %>
                <div style="float: right;margin: 0px;" id="bookmarkBtn">
                    <div class="bookmark_button" onclick="popupBookmark(this);"></div>
                </div>
                <%
                    }
                %>             
            </form>
            <br/>
            <TABLE id="inboxMsg" align="center" DIR=<fmt:message key="direction"/> WIDTH="100%" CELLPADDING="0" cellspacing="0" style="display: none;margin-top: 10px;">
                <thead><TR>
                        <TH><input type="checkbox" class="allCase" name="selectedAllIssue" onchange="selectAll(this)"/></TH>
                        <TH  ><SPAN ><img src="images/icons/Numbers.png" width="20" height="20" /><b> <fmt:message key="requestno"/></b></SPAN></TH>
                        <TH  ><SPAN><img src="images/icons/client.png" width="20" height="20" /><b> <fmt:message key="clientname"/></b></SPAN></TH>
                        <TH  ><SPAN><b> <fmt:message key="mobile"/></b></SPAN></TH>
                        <TH  ><SPAN><b><fmt:message key="type"/></b></SPAN></TH>
                        <TH  ><SPAN><img src="images/icons/list_.png" width="20" height="20" /><b> <fmt:message key="request"/></b></SPAN></TH>
                        <TH  ><SPAN><img src="images/icons/manager.png" width="18" height="18" /><b><fmt:message key="sender"/></b></SPAN></TH>
                        <TH  ><SPAN><img src="images/icons/manager.png" width="18" height="18" /><b> <fmt:message key="source"/></b></SPAN></TH>
                        <TH  ><SPAN><img src="images/icons/key.png" width="20" height="20" /><b> <fmt:message key="requestcode"/></b></SPAN></TH>
                        <TH  ><img src="images/icons/Time.png" width="20" height="20" /><b> <fmt:message key="callingdate"/></b></TH>
                        <TH   ><b><%=ageComp%></b></TH>
                    </TR></thead>
                <tbody>  
                    <%
                        for (WebBusinessObject wbo : issuesVector) {
                           
                            iTotal++;
                            String compStyle = "";
                            WebBusinessObject senderInf = null;
                            UserMgr userMgr = UserMgr.getInstance();
                            senderInf = userMgr.getOnSingleKey(wbo.getAttribute("senderId").toString());

                    %>

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
                            } else if (CRMConstants.CLIENT_COMPLAINT_TYPE_CLIENT_VISIT.equalsIgnoreCase(clientCompWbo.getAttribute("ticketType").toString())) {
                                compStyle = "order";
                            } else if (CRMConstants.CLIENT_COMPLAINT_TYPE_CLIENT_REQUEST.equalsIgnoreCase(clientCompWbo.getAttribute("ticketType").toString())) {
                                compStyle = "order";
                            }
                    %>
                    <TR id="row<%=wbo.getAttribute("clientComId")%>">
                        <td style="cursor: pointer" onmouseover="this.className = '<%=compStyle%>'" onmouseout="this.className = ''">
                            <input type="checkbox" class="case" value="<%=wbo.getAttribute("clientComId") + "," + wbo.getAttribute("issue_id")%>" name="selectedIssue" />
                        </td>
                        <TD    style="cursor: pointer" onmouseover="this.className = '<%=compStyle%>'" onmouseout="this.className = ''">
                            <a href="<%=context%>/IssueServlet?op=getCompl&issueId=<%=wbo.getAttribute("issue_id")%>&compId=<%=wbo.getAttribute("clientComId")%>&senderId=<%=wbo.getAttribute("senderId")%>&statusCode=<%=wbo.getAttribute("statusCode")%>&receipId=<%=wbo.getAttribute("currentOwnerId")%>&senderID=<%=wbo.getAttribute("senderId")%>&clientType=<%=wbo.getAttribute("age")%>"> <font color="red"><%=wbo.getAttribute("businessID").toString()%></font><font color="blue">/<%=wbo.getAttribute("businessIDbyDate").toString()%></font>
                            </a>

                        </TD>
                        <TD   >
                            <b><%=wbo.getAttribute("customerName").toString()%></b>
                            <%if (newTap.equalsIgnoreCase("true")){%>
                                <a href="#" onclick="JavaScript: openInNewWindow('<%=context%>/ClientServlet?op=clientDetails&issueID=<%=wbo.getAttribute("issue_id")%>&clientId=<%=wbo.getAttribute("customerId")%><%=wbo.getAttribute("statusCode").equals("4") ? "&clientComplaintID=" + wbo.getAttribute("clientComId") + "&issueID=" + wbo.getAttribute("issue_id") : ""%>');">
                                    <img src="images/client_details.jpg" width="30" style="float: left;" title="تفاصيل"
                                         onmouseover="JavaScript: changeCommentCounts('<%=wbo.getAttribute("customerId")%>', this);"/>
                                </a>
                            <%} else {%>
                                <a href="<%=context%>/ClientServlet?op=clientDetails&issueID=<%=wbo.getAttribute("issue_id")%>&clientId=<%=wbo.getAttribute("customerId")%><%=wbo.getAttribute("statusCode").equals("4") ? "&clientComplaintID=" + wbo.getAttribute("clientComId") + "&issueID=" + wbo.getAttribute("issue_id") : ""%>">
                                    <img src="images/client_details.jpg" width="30" style="float: left;" title="تفاصيل"
                                         onmouseover="JavaScript: changeCommentCounts('<%=wbo.getAttribute("customerId")%>', this);"/>
                                </a>
                            <%}%>    
                            <a onclick="JavaScript: openSession('<%=wbo.getAttribute("customerId")%>');" href="#" onclick="JavaScript: popupExecutionPeriod('<%=wbo.getAttribute("clientComId")%>', '<%=wbo.getAttribute("customerName")%>')">
                                <img src="images/timer.png" style="float: left; height: 20px;" title="مدة التنفيذ"/>
                            </a>
                            <a href="#" onclick="JavaScript: printClientInformation('<%=wbo.getAttribute("customerId")%>')">
                                <img src="images/pdf_icon.gif" style="float: left; height: 20px;" title="Datasheet"/>
                            </a>
                        </TD>

                        <TD  ><b><%=wbo.getAttribute("clientMobile")%></b></TD>
                        <TD  ><b><%=wbo.getAttribute("typeName")%></b></TD>




                        <TD  STYLE="text-align:center;padding-<fmt:message key="align"/>: 5px; font-size: 12px;" width="20%"><b>
                                <% String sCompl = " ";
                                    if (wbo.getAttribute("compSubject") != null && !wbo.getAttribute("compSubject").equals("")) {
                                        sCompl = (String) wbo.getAttribute("compSubject");
                                        if (sCompl.length() > 10) {
                                            //sCompl = sCompl.substring(0,23) + "....";
%>
                                <%=sCompl%>
                                <% } else {%>
                                <%=sCompl%>
                                <% }%>
                                <% } else {%>
                                <%=sCompl%>
                                <%}%>
                                <b>
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
                                        if(clientCompWbo.getAttribute("ticketType") != null && (((String) clientCompWbo.getAttribute("ticketType")).equals(CRMConstants.CLIENT_COMPLAINT_TYPE_REQUEST_EXTRADITION)
                                                || ((String) clientCompWbo.getAttribute("ticketType")).equals(CRMConstants.CLIENT_COMPLAINT_TYPE_DELIVERY_OF_QUALITY))) {
                                    %>
                                        <a href="#" onclick="JavaScript: viewRequest('<%=wbo.getAttribute("issue_id")%>','<%=wbo.getAttribute("clientComId")%>');">
                                            <IMG value="" onclick="" height="25px" src="images/icons/checklist-icon.png" style="margin: 0px 0; float: left;" title="مشاهدة طلب تسليم"/>
                                        </a>
                                    <%
                                        }
                                    %>
                                </b></TD>
                        <TD>
                            <b><%=wbo.getAttribute("senderName")%> </b></TD>
                        <TD>
                            <b><%=wbo.getAttribute("displayCreatedBy")%></b></TD>
                        <TD  ><b><%=wbo.getAttribute("businessCompId")%></b></TD>
                        <% Calendar c = Calendar.getInstance();
                            DateFormat formatter;
                            formatter = new SimpleDateFormat("dd/MM/yyyy");
                            String[] arrDate = wbo.getAttribute("entryDate").toString().split(" ");
                            Date date = new Date();
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
                        <TD nowrap  ><font color="red">Today - </font><b><%=sTime%></b></TD>
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
                
            </TABLE>
            <input type="hidden" id="businessCompId" />
            <input type="hidden" name="beginDate" id="beginDate" value="<%=beginDate%>">
            <input type="hidden" name="endDate" id="endDate" value="<%=endDate%>">
            <input type="hidden" name="projectName" id="projectName" value="All">
            <input type="hidden" name="statusName" id="statusName" value="Schedule">
            <BR>
        </FIELDSET>
    </CENTER>
    <div id="finishNote"  style="width: 40%;display: none;position: fixed">
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
                        <select id="actionTaken" name="actionTaken" STYLE="width:175px;font-size: small;text-align: right;float: right">
                            <sw:WBOOptionList wboList='<%=actionsList%>' displayAttribute = "projectName" valueAttribute="projectID" />
                            <option value="100" selected>Other</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td style="width: 40%;"> <label style="width: 100px;">ملاحظات الإنهاء</label></TD>
                    <td style="width: 60%;"><TEXTAREA cols="40" rows="5" name="notes" id="notes"></TEXTAREA></TD>
                </TR>
                <tr>
                    <td style="width: 40%;"> <label style="width: 100px;">التاريخ</label></TD>
                    <td style="width: 60%;">  <input name="finishEndDate" id="finishEndDate" type="text" size="40" maxlength="50" style="width:50%;float: right;font-size: 12px;" readonly value="<%=nowTime%>"/></TEXTAREA></TD>
                </TR>
                <tr>
                    <td colspan="2" > <input type="button"  onclick="JavaScript:finishComp(this);" class="turn_off" style="float: none !important;"></TD>
                </tr>
                <tr>
                    <td colspan="2" >
                        <div style="margin: 0 auto;display: none; width: 90%;text-align: center;color: white" id="finishMsg">تم الإنهاء بنجاح</DIV>
                    </td>
                </tr>
            </TABLE>
        </div>

    </div>
    <div id="bookmarkDiv"  style="width: 30% ;margin-right: auto ;margin-left: auto;display: none;position: fixed;top: 0%;">
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
                        <select id="bookmarkTitle" name="bookmarkTitle" style="width: 100%;">
                            <option value=""></option>
                            <option value="Hot Client">Hot Client</option>
                            <option value="Unit & Project data missing">Unit & Project data missing</option>
                            <option value="No Payment Plan">No Payment Plan</option>
                            <option value="Poor Client Communication">Poor Client Communication</option>
                            <option value="Visit Support">Visit Support</option>
                            <option value="Other">Other</option>
                        </select>
                    </td>
                </tr> 
                <tr>
                    <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 30%;">التفاصيل</td>
                    <td style="width: 70%;" >
                        <textarea  placeholder="" style="width: 100%;height: 80px;" id="bookmarkNote" > </textarea>
                    </td>
                </tr> 
            </table>
            <div style="text-align: center;margin-left: auto;margin-right: auto;clear: both" >
                <input type="button"  onclick="JavaScript: bookmarkComplaints(this);" class="bookmark_button" style="float: none !important;"/>
            </div>
        </div>  
    </div>
</BODY>
</HTML>
