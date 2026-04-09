<%@page import="com.clients.db_access.ClientMgr"%>
<%@page import="com.clients.db_access.ClientComplaintsMgr"%>
<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="com.tracker.engine.IssueStatusFactory, com.tracker.engine.*,java.text.*,com.docviewer.db_access.*, com.maintenance.db_access.*,com.maintenance.common.ParseSideMenu"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %> 
<%@ page contentType="text/HTML; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8"%>
<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    ClientMgr clientMgr = ClientMgr.getInstance();
    Calendar cal = Calendar.getInstance();
    String timeFormat = "yyyy/MM/dd HH:mm";
    SimpleDateFormat sdf = new SimpleDateFormat(timeFormat);
    String nowTime = sdf.format(cal.getTime());
    String count;
    count = clientMgr.getCounter();
%>
<HTML>
    <meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <meta HTTP-EQUIV="Expires" CONTENT="0">
    <head>
        <title>Weekly Manager Agenda</title>

        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css">
        <link rel="stylesheet" href="css/demo_table.css">
        <!--<script type="text/javascript" src="jquery-ui/jquery-1.6.2.js"></script>-->

        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>


        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/default/easyui.css">
        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/icon.css">
        <link rel="stylesheet" type="text/css" href="jquery-easyui/demo/demo.css">
        <script type="text/javascript" src="jquery-easyui/easyloader.js"></script>
        <!--<meta http-equiv="refresh" content="60" />-->
        <script type="text/javascript">
            $(function() {
                $("#beginDate, #endDate").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    minDate: "+d",
                    maxDate: 0,
                    dateFormat: "yy/mm/dd"
                });
                $("#closedEndDate").datetimepicker({
                    changeMonth: true,
                    changeYear: true,
                    minDate: "+d",
                    maxDate: 0,
                    dateFormat: "yy/mm/dd",

                    timeFormat: "hh:mm:ss"
                });
            }); 
    
         
  
            //            window.onload = $('#incomingMsg').hide();
           
            var minDateFilter;
            var maxDateFilter; var time;
            //            $.fn.dataTableExt.afnFiltering.push(
            //            function(oSettings, aData, iDataIndex){
            //                var dateStart = parseDateValue($("#min").val())*1;
            //               
            //                var dateEnd = parseDateValue($("#max").val())*1;
            //                 
            //                // aData represents the table structure as an array of columns, so the script access the date value 
            //                // in the first column of the table via aData[0]
            //                var evalDate= parseDateValue(aData[9])*1;
            //                if (dateStart=="undefinedundefined"&&dateEnd=="undefinedundefined") {
            //                    return true;
            //                }
            //                else if (evalDate == dateStart&&dateEnd=="undefinedundefined") {
            //                    return true;
            //                }else if (evalDate == dateEnd&&dateStart=="undefinedundefined") {
            //                    return true;
            //                }
            //                else if (evalDate >= dateStart && evalDate <= dateEnd) {
            //                    return true;
            //                }else if (evalDate > dateStart && evalDate <= dateEnd) {
            //                    return true;
            //                }
            //               
            //                else {
            //                    return false;
            //                }
            //                return true;
            //            });
            //            function parseDateValue(rawDate) {
            //                var dateArray= rawDate.split("/");
            //                var parsedDate= dateArray[2] + dateArray[0] + dateArray[1];
            //               
            //                return parsedDate;
            //            }
            var users = new Array();
            $(document).ready(function() {

                //                if ($("#tblData").attr("class") == "blueBorder") {
                //                    $("#tblData").bPopup();
                //                }
                var buttonPlaceholder = $("#buttonPlaceholder").html("<button>Test</button>");
                $("#tblData").css("display", "none");
                var oTable = $('#incomingMsg').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]],
                    iDisplayLength: 10,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true, 
                    "aaSorting": [[ 5, "desc" ]]

                }).show();
                  
                //                $('#min').keyup( function() { oTable.fnDraw(); } );
                //              
                //                $('#max').keyup( function() { oTable.fnDraw(); } );
                $("#min").keyup ( function() { oTable.fnDraw(); } );
                $("#min").change( function() { oTable.fnDraw(); } );
                $("#max").keyup ( function() { oTable.fnDraw(); } );
                $("#max").change( function() { oTable.fnDraw(); } );

            });
        
            function removeInMsg() {
                var selectedMsg = $("#incomingMsg").find(":checkbox:checked");
                var rowCount = $('#incomingMsg tr').length - 2;
                //                if (selectedMsg.length > 0 & rowCount > 0) {
                var ids = "";
                $(selectedMsg).each(function(index, obj) {

                    //                    alert(index)
                    ;
                    var id = $(obj).val();

                    ids = ids + id + ",";

                })
                //                alert(ids)
                //                    }
                $.ajax({
                    type: "post",
                    url: "<%=context%>/ComplaintEmployeeServlet?op=removeSelectedComp",
                    data: {
                        selectedId: ids
                    },
                    success: function(jsonString) {
                        var info = $.parseJSON(jsonString);

                        if (info.status == 'ok') {
                            //                            alert("done");
                            //                                $(selectedMsg).parent().parent().remove();
                            $(selectedMsg).parent().parent().parent().each(function(index, obj) {
                                var pos = oTable.fnGetPosition(obj);
                                oTable.fnDeleteRow(pos);
                            })
                        }
                    }
                });
            }
            //                else {
            //                    alert("لاتوجد بيانات للتعامل معها");
            //                }

            //            }
            //          
            //          
            //          
            //          
            //          
            //          
            //          
            //          
            //            $("#tblData").keypress(function(e) {
            //                if (e.keyCode == 27) {
            ////                    $("#tblData").fadeOut(500);
            ////                    //or
            ////                    $("#tblData").clo
            //                    window.close();
            //                }
            //            });
            function test() {
                $("#tblData").bPopup();
                $("#tblData").css("display", "block");
            }
            function saveComplaintEmp(c, x) {
                //alert('entered ');
                //                var complaintId = $("#complaintId").val();
                //                alert("df");
                var selectedMsg = $("#incomingMsg").find(".case:checkbox:checked");
                var empIdArr = $('input[name=empId]');
                var empId = $(empIdArr[x - 1]).val();
                var commentsArr = $('input[name=comments]');
                var comments = $(commentsArr[x - 1]).val();
                var responsibleArr = $('select[name=responsible]');
                var clientCompId = $("#clientCompId").val();
                //                var complaintComment = $("#complaintComment").val();
                var compSubject = $("#compSubject").val();
                var selectedId = $("#ids").val();
                //                alert(selectedId);
                var responsible = $(responsibleArr[x - 1]).val();
                //alert('res= '+responsible);
                $("#save" + x).html("<img src='images/icons/spinner.gif'/>");

                $.ajax({
                    type: "post",
                    url: "<%=context%>/ComplaintEmployeeServlet?op=saveComplaintEmp",
                    data: {
                        selectedId: selectedId,
                        empId: empId,
                        comments: comments,
                        responsible: responsible,
                        clientCompId: clientCompId,
                        //                        complaintComment: complaintComment,
                        compSubject: compSubject
                    },
                    success: function(jsonString) {
                        var eqpEmpInfo = $.parseJSON(jsonString);

                        if (eqpEmpInfo.status == 'Ok') {
                            $("#save" + x).html("");
                            $("#save" + x).css("background-position", "top");
                            $("#save" + x).removeAttr("onclick");
                            $(selectedMsg).parent().parent().parent().each(function(index, obj) {
                                var pos = oTable.fnGetPosition(obj);
                                oTable.fnDeleteRow(pos);
                            }
                        )
                        }
                    }
                });

            }

            function remove(t, index) {
                //alert;

                if ($(t).parent().parent().parent().parent().attr('rows').length != 1) {
                    $(t).parent().parent().remove();
                    if ($("#empOne").val() != t.id) {
                        users[t.id] = 0;
                    }

                    var check = document.getElementsByName('order');
                    var index_ = document.getElementsByName('index');
                    //alert(check.length);
                    for (var i = 0; i < check.length; i++) {
                        //alert(i+1);
                        check[i].innerHTML = i + 1;
                        index_[i].value = i + 1;
                        //alert(index_[i].id);
                        index_[i].id = 'index' + (i + 1);
                        //alert(index_[i].id);
                        //$('#order'+index).val(i+1);
                    }

                }
                else {
                    $(t).parent().parent().parent().parent().parent().parent().remove();
                    segment[t.title] = 0;
                    var check = document.getElementsByName('order');
                    var index_ = document.getElementsByName('index');
                    //alert(check.length);
                    for (var i = 0; i < check.length; i++) {
                        //alert(i+1);
                        check[i].innerHTML = i + 1;
                        index_[i].value = i + 1;
                        //alert(index_[i].id);
                        index_[i].id = 'index' + (i + 1);
                        //alert(index_[i].id);
                        //$('#order'+index).val(i+1);
                    }

                }
            }
        </script>
        <script type="text/javascript">
            function closeAlert(obj){
              
                $("#closeNote").window('close');
            }
            $(function() {
                var currentRow = ($("#incomingMsg tr").length);
                //                alert(currentRow);
                var current = currentRow - 2;
                var count =<%=count%>;
                //                alert(current);
                //                alert(count);
                //                alert(x - 1);
                if (current > count) {

                    var diff = current - count;
                    $("#comingMsg").text(diff);
                    //                    alert("عدد الرسائل الواردة " + diff);
                    $.ajax({
                        type: "post",
                        url: "<%=context%>/ClientServlet?op=updateCounter",
                        data: {count: current},
                        success: function(jsonString) {
                            var info = $.parseJSON(jsonString);

                            if (info.status == 'ok') {

                            }
                        }
                    });
                } else if (current < count) {

                    var diff = count - current;
                    $("#comingMsg").text("0");
                    //                    alert("عدد الرسائل الواردة " + diff);
                    $.ajax({
                        type: "post",
                        url: "<%=context%>/ClientServlet?op=updateCounter",
                        data: {count: current},
                        success: function(jsonString) {
                            var info = $.parseJSON(jsonString);

                            if (info.status == 'ok') {

                            }
                        }
                    });
                } else if (current == count) {


                    $("#comingMsg").text("0");
                    ////                    alert("عدد الرسائل الواردة " + diff);
                    //                    $.ajax({
                    //                        type: "post",
                    //                        url: "<%=context%>/ClientServlet?op=updateCounter",
                    //                        data: {count: current},
                    //                        success: function(jsonString) {
                    //                            var info = $.parseJSON(jsonString);
                    //
                    //                            if (info.status == 'ok') {
                    //
                    //                            }
                    //                        }
                    //                    });
                }

            })
            //saveCount(x-1);

            function saveCount(o) {

                //                alert(o)
                var count = $(o).val();

                $.ajax({
                    type: "post",
                    url: "<%=context%>/ClientServlet?op=getCount",
                    data: {count: count},
                    success: function(jsonString) {
                        var info = $.parseJSON(jsonString);

                        if (info.status == 'ok') {

                            // change update icon state
                            //                            $(obj).html("");
                            //                            $(obj).css("background-position", "top");
                            //                            $(obj).removeAttr("onclick");


                        }
                    }
                });

            }
            function getCount() {


                $.ajax({
                    type: "post",
                    url: "<%=context%>/ClientServlet?op=getCounter",
                    data: {count: count},
                    success: function(jsonString) {
                        var info = $.parseJSON(jsonString);

                        if (info.status == 'ok') {

                            alert("count = " + info.count);

                        }
                    }
                });

            }
            var TableIDvalue = "incomingMsg";

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
        EmployeeViewMgr employeeViewMgr = EmployeeViewMgr.getInstance();
        // issuesVector = issueMgr.getIssuesListInRangeByEmg(new java.sql.Date(beginWeekCalendar.getTimeInMillis()), new java.sql.Date(endWeekCalendar.getTimeInMillis()),session);
        WebBusinessObject userWbo = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
        String[] key = new String[2];
        String[] value = new String[2];
        key[0] = "key3";
        key[1] = "key8";
        value[0] = userWbo.getAttribute("userId").toString();
        value[1] = "2";

        String bDate = beginInterval.toString().substring(8, 10) + "-" + beginInterval.toString().substring(5, 7) + "-" + beginInterval.toString().substring(0, 4);
        String day = endInterval.toString().substring(8, 10);
        int endDay = Integer.parseInt(day) + 1;
        String eDate = endDay + "-" + endInterval.toString().substring(5, 7) + "-" + endInterval.toString().substring(0, 4);
        String resp = "1";
//        issuesVector = issueByComplaintMgr.getComplaintsWithEntryDate(2, value, key, "key7", bDate, eDate, resp);
        issuesVector = employeeViewMgr.getComplaintsWithoutDate(2, value, key, "key7", resp, null, null, null);
        String stat = (String) request.getSession().getAttribute("currentMode");
        String title, from, to, align, dir, style, Indicators, Quick, important, expectedBegin, expectedEnd, totalTasks;
        String viewD, scheduleCase, executionCase, onHoldCase, fontSize, issueNo, issueTit, equip, issueStatus;
        String complaintNo, customerName, complaintDate, complaint;
        String sat, sun, mon, tue, wed, thu, fri, view, complaintCode, type, compStatus, compSender, noResponse, ageComp;
        String complStatus, senderName = null;
        String codeStr, projectStr, distanceStr, deleteStr, responsibleStr, save;
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
            save = "Save";
            complaintCode = "Complaint code";
            type = "Type";
            compStatus = "Staus";
            compSender = "Sender";
            noResponse = "&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1578;&#1583;&#1575;&#1608;&#1604;";
            ageComp = "A.C(day)";
            codeStr = "Code";
            projectStr = "Employee name";
            distanceStr = "Notes";
            deleteStr = "Delete";
            responsibleStr = "Responsibility";
        } else {
            save = "&#1578;&#1587;&#1580;&#1610;&#1604;";
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
            compSender = "&#1575;&#1604;&#1605;&#1585;&#1587;&#1604;";
            noResponse = "&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1578;&#1583;&#1575;&#1608;&#1604;";
            ageComp = "&#1593;.&#1591; (&#1610;&#1608;&#1605;)";
            codeStr = "&#1575;&#1604;&#1603;&#1608;&#1583;";
            projectStr = "&#1575;&#1587;&#1605; &#1575;&#1604;&#1605;&#1608;&#1592;&#1601;";
            distanceStr = "&#1605;&#1604;&#1575;&#1581;&#1592;&#1575;&#1578;";
            deleteStr = "&#1581;&#1584;&#1601;";
            responsibleStr = "&#1575;&#1604;&#1605;&#1587;&#1574;&#1608;&#1604;";
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
        function cancelComp() {
            var selectedProductArr = $('#incomingMsg').find(':checkbox:checked');
            var x = "";
            var compId;
            $(selectedProductArr).each(function(index, complaint) {
                //                productId = $(product).val();
                compId = $(complaint).parent().find('#compId').val();
                x = x + compId + ",";
            });
            $.ajax({
                type: "post",
                url: "<%=context%>/ComplaintEmployeeServlet?op=cancelComp",
                data: {
                    selectedId: x
                },
                success: function(jsonString) {
                    var info = $.parseJSON(jsonString);

                    if (info.status == 'ok') {
                        $(selectedProductArr).parent().parent().parent().remove();
                    }
                }
            });
        }
        
        function close_comp(obj) {
            var selectedMsg = "";
            var note = "";
            var ids = "";
            selectedMsg = $("#incomingMsg").find(".case:checkbox:checked");

            note = $(obj).parent().parent().parent().parent().find("#notes").val();
            var endDate = $(obj).parent().parent().parent().parent().find('#closedEndDate').val();
          
            if($(selectedMsg).length>0){
                $(selectedMsg).each(function(index, obj) {
                    var id = $(obj).val();

                    ids = ids + id + ",/";

                });
                $("#ids").val(ids);
            }else{ ids=$("#ids").val(); }
          
        
            $.ajax({
                type: "post",
                //                url: "<%=context%>/ComplaintEmployeeServlet?op=closeSelectedComp",
                url: "<%=context%>/ComplaintEmployeeServlet?op=closeMultiComp",
                data: {
                    selectedId: ids,
                    note: note,
                    endDate:endDate
                },
                success: function(jsonString) {
                    var info = $.parseJSON(jsonString);

                    if (info.status == 'ok') {

                        $(selectedMsg).parent().parent().parent().each(function(index, obj) {
                            var pos = oTable.fnGetPosition(obj);
                            oTable.fnDeleteRow(pos);
                            //                            oTable.fnDraw(true);

                        });
                        $('#closeNote').window("close");
                   
                        $("#actionBtn").css("display", "none");
                        $("#selectAll").removeAttr("checked");
                        $(obj).parent().parent().parent().find("#notes").val("");
                     

                    }
                    if (info.status == 'error') {
                        $('#closeNote').window("close");

                        alert("error");
                    }
                }
            });
            return false;
        }
 
        function saveMultiBookmark(obj) {
            
            //            $("#businessCompId").val(obj);
            $("#emptyNote").text("");
            $("#ids").val('');
      
            $('#bookmark').window('open');
        
            var selectedMsg = "";
            var note = $(obj).parent().parent().parent().parent().find("#notes").val();
            var ids = "";
            selectedMsg = $("#incomingMsg").find(".case:checkbox:checked");
          
            if($(selectedMsg).length>0){
                $(selectedMsg).each(function(index, obj) {
                    var id = $(obj).val();
                  
                    var x=  id.split(',');
                 
                    $(obj).parent().attr("id", "bookmarkDiv");
                    ids = ids + x[0] + ",";
                 
                });
               
            
                $.ajax({
                    type: "post",
                    //                url: "<%=context%>/ComplaintEmployeeServlet?op=closeSelectedComp",
                    url: "<%=context%>/IssueServlet?op=multiBookmark",
                    data: {
                        selectedId: ids,
                        note: note,
                        endDate:endDate
                    },
                    success: function(jsonString) {
                        var info = $.parseJSON(jsonString);

                        if (info.status == 'ok') {

                            $(selectedMsg).parent().parent().parent().each(function(index, obj) {
                               
                                $("#bookmarkDiv").find("#bookmarkImg").attr("class","tt");
                                $("#bookmarkDiv").find(".tt").attr("src", "images/icons/bookmark_selected.png");
                                //                                $("#bookmarkDiv").find("#bookmarkImg").removeAttr("onclick");
                                $("#bookmarkDiv").find("#bookmarkImg").attr("onclick","deleteBookmark("+info.bookmarkId+",this)");
                                //                         $("#bookmarkDiv").find("#bookmarkImg").attr("onclick","deleteBookmark()");
                                $("#bookmarkDiv").find(".tt").attr("onmouseover", "Tip('" + note+ "', CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#FFFF99', FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT, 'BOLD', TITLEALIGN, 'center', TITLEFONTCOLOR, 'black', TITLEBGCOLOR, '#6699FF')");
                                $("#bookmarkDiv").find(".tt").attr("onMouseOut", "UnTip()");
                                $("#incomingMsg").find(".case:checkbox:checked").attr("checked",false);
                                $("#bookmarkDiv").attr("id", "");
                                $("#notes").val("");
                                $("#businessCompId").val();
                            });
                         
                            $('#bookmark').window('close');
                          
                      
                        }
                        if (info.status == 'error') {
                            $('#closeNote').window("close");

                            alert("error");
                        }
                    }
                });
            }else{
                alert("please select only one");
            }
            return false;
        }
        function redirect() {
  
            $("#ids").val();
            var ids = "";
            var selectedMsg = "";
            selectedMsg = $("#incomingMsg").find(".case:checkbox:checked");

            $(selectedMsg).each(function(index, obj) {
                var id = $(obj).val();

                //                alert(id);
                ids = ids + id + ",/";

            });
            //            alert(ids)

            $("#ids").val(ids);

            return getDataInPopup('ComplaintEmployeeServlet?op=getEmpByGroup2&formName=CLIENT_COMPLAINT_FORM&selectionType=multi&complaintId=' + $('#complaintId').val())
        }
        function closeComplaint(obj){
            $("#ids").val(obj);
        }
        function redirectOnly(obj){
           
            $("#ids").val(obj);
           
           
            return getDataInPopup('ComplaintEmployeeServlet?op=getEmpByGroup2&formName=CLIENT_COMPLAINT_FORM&selectionType=multi&complaintId=' + $('#complaintId').val())
        }
        //        function redirectOnlyOne() {
        //            
        //            return getDataInPopup('ComplaintEmployeeServlet?op=getEmpByGroup2&formName=CLIENT_COMPLAINT_FORM&selectionType=multi&complaintId=' + $('#COMPID').val())
        //        }
        function popupCloseO(obj) {
            if ($(".case:checked").length > 0) {
                $('#closeNote').bPopup();
                $('#closeNote').css("display", "block");
            } else {
                alert("select first!");
            }
        }
        $("#selectAll").click(function() {
            $(".case").attr("checked", this.checked)
            if ($(".case").attr("checked")) {
                $("#actionBtn").css("display", "block");
                //                $("#actionBtn").toggle(1000);

            } else {

                $("#actionBtn").css("display", "none");
            }
        });
        //        $(".case").click(function() {
        //            if ($(".case").length == $(".case:checked").length) {
        //                $("#selectAll").attr("checked", "checked");
        //
        //            } else {
        //                $("#selectAll").removeAttr("checked");
        //                //                $("#selectAll").css("background","images/icons/mi.png");
        //            }
        //            if ($(".case:checked").length > 0) {
        //                $("#actionBtn").css("display", "block");
        //                //                $("#actionBtn").toggle(1000);
        //            } else {
        //                $("#actionBtn").css("display", "none");
        //                //                $("#actionBtn").fadeIn(1000);
        //            }
        //        })

    </SCRIPT>
    <script type="text/javascript">
   
    
        function menuHandler(item){

            if(item.name=="new"){
                var url="<%=context%>/IssueServlet?op=getCompl&issueId="+$("#ISSUEID").val()+"&compId="+$("#COMPID").val()+"&statusCode="+""+"&receipId="+$("#RECID").val()+"&senderID="+$("#SENDERID").val();
                window.location=url;
            }
            if(item.name=="save"){
                    
                var url="<%=context%>/IssueServlet?op=getCompl&issueId="+$("#ISSUEID").val()+"&compId="+$("#COMPID").val()+"&statusCode="+""+"&receipId="+$("#RECID").val()+"&senderID="+$("#SENDERID").val();
                window.location=url;
            }

            if(item.name=="selectAll"){

                $("#incomingMsg tr #compId").prop("checked", true);
                if($("#incomingMsg tr #compId").prop("checked")== true){
                    $("#unselect").css("display","block");
                }
            
                var checked=$("#incomingMsg").find('.case:checkbox:checked');
                if($(checked).length>1){
                    $("#completeRemove").css("display", "block");
                    $("#completeMove").css("display", "block");
                    $("#simpleRemove").css("display", "none");
                    $("#simpleMove").css("display", "none");
                    $("#multiBookmark").css("display", "block");
                    $("#view").css("display", "none");   
                    $("#multiMark").show();
                    $("#insertBookmark").hide();
                }else{
                    $("#completeRemove").css("display", "none");
                    $("#completeMove").css("display", "none");
                    $("#simpleRemove").css("display", "block");
                    $("#simpleMove").css("display", "block");
                    $("#multiBookmark").css("display", "none");
                    $("#view").css("display", "block"); 
                    $("#multiMark").css("display", "none");
                    $("#insertBookmark").css("display", "block");
                }
           
            }
            if(item.name=="unselect"){
                            
                $("#incomingMsg tr #compId").prop("checked", false);
                if($("#incomingMsg tr #compId").prop("checked")==false){
                    $("#unselect").css("display","none");
                    $("#completeRemove").css("display", "none");
                    $("#completeMove").css("display", "none");
                    $("#simpleRemove").css("display", "block");
                    $("#simpleMove").css("display", "block");
                    $("#view").css("display", "block"); 
                }                     
            }
            if(item.name=="removeSelected"){

            }
            if(item.name=="moveSelected"){
                redirect();
            }

            if(item.name=="removeFile"){

                $('#singleFile').window('open');
            }
            if(item.name=="multiMark"){
             
                $('#bookmark').window('open');
            }
            if(item.name=="moveFile"){
                var id=$("#COMPID").val()+","+$("#ISSUEID").val()+",/"
                redirectOnly(id);
                //                    $('#moveFile').window('open');
                //                    $("#mainProjectName").val("");
            }
            if(item.name=="closeComplaint"){
                var id=$("#COMPID").val()+","+$("#ISSUEID").val()+",/"
                //                    closeComplaint(id);
                $("#ids").val(id);
                $('#closeNote').window('open');
                //                    $('#moveFile').window('open');
                //                    $("#mainProjectName").val("");
            }
            if(item.name=="mark"){
                var id=$("#COMPID").val();
                mark(id,this);

            }
                    
            if(item.name=="closeMultiComplaint"){
                   
                $("#ids").val("");
                $('#closeNote').window('open');
                //                    $('#moveFile').window('open');
                //                    $("#mainProjectName").val("");
            }
            if(item.name=="removeAllSelected"){
                $("#incomingMsg tr #check").prop("checked", true);
                $('#w').window('open');
           
        
            }
       
        }
        $(function(){
  
            $("#incomingMsg tr").mouseup(function(){
                $("#incomingMsg tr").css("background-color","");
            })
            $("#incomingMsg tr").bind('contextmenu',function(e){
                e.preventDefault();
                
                if($("#incomingMsg").find(':checkbox:checked').length>1){
                                
                    $("#completeRemove").css("display", "block");
                    $("#completeMove").css("display", "block");
                    $("#simpleRemove").css("display", "none");
                    $("#simpleMove").css("display", "none");
                    $("#multiBookmark").css("display", "block");
                    
                    $("#multiMark").show();
                    $("#insertBookmark").hide();
              
              
                    $("#incomingMsg tr").css("background-color","");
                    $("#multiMark").show();
                    $("#insertBookmark").hide();
                    $('#menu').menu('show', {
                    
                        left: e.pageX,
                        top: e.pageY
                    });
                }else{
                    
                    $("#completeRemove").css("display", "none");
                    $("#completeMove").css("display", "none");
                    $("#simpleRemove").css("display", "block");
                    $("#simpleMove").css("display", "block");
                    $("#multiBookmark").css("display", "none");
                    $("#multiMark").css("display", "none");
                    $("#insertBookmark").css("display", "block");
                    
                    $("#multiMark").hide();
                    $("#insertBookmark").show();
                    $('#menu').menu('show', {
                    
                        left: e.pageX,
                        top: e.pageY
                    });
                    $("#incomingMsg tr").css("background-color","");
                    $(this).css("background-color","#005599");
                    //                    $("#incomingMsg tr").find(".case").attr("checked", false);
                    //                    $(this).find(".case").attr("checked", true);
                } 
                $("#ISSUEID").val($(this).find("#issue_id").val());
                $("#COMPID").val($(this).find("#comp_Id").val());
                $("#RECID").val($(this).find("#receip_id").val());
                $("#SENDERID").val($(this).find("#sender_id").val());
                 
                      
            
              
            });
        });
    </script>
    <!--<script src='ChangeLang.js' type='text/javascript'></script>-->
    <BODY>
    <CENTER>
        <div style="display: none">
            <div id="menu" class="easyui-menu" data-options="onClick:menuHandler" style="width:120px;height: auto;">

                <div data-options="name:'save',iconCls:'icon-search'" id="view">مشاهدة</div>
                <div data-options="name:'closeComplaint',iconCls:'icon-cancel'" id="simpleRemove">
                    <span>إغلاق</span>
                </div>
                <div data-options="name:'remove',iconCls:'icon-cancel'" data-options="onClick:menuHandler" id="completeRemove" style="display: none;">
                    <span>إغلاق</span>
                    <div style="height: auto;">


                        <div data-options="name:'closeMultiComplaint',iconCls:'icon-ok'" id="removeSelected">المحدد</div>
                        <!--<div data-options="name:'removeAllSelected'"id="removeAllSelected" >الكل</div>-->
                    </div>

                </div>
                <div data-options="name:'moveFile',iconCls:'icon-reload'" id="simpleMove">
                    <span>توزيع</span>
                </div>
                <div data-options="name:'move',iconCls:'icon-reload'" style="display: none;" id="completeMove">
                    <span>توزيع</span>
                    <div style="height: auto;">


                        <div data-options="name:'moveSelected',iconCls:'icon-ok'" id="moveSelected"    >المحدد</div>
                        <!--<div data-options="name:'removeAllSelected'"id="removeAllSelected" >الكل</div>-->
                    </div>

                </div>

                <div data-options="name:'',iconCls:'icon-tip'" style="display: none;" id="multiBookmark">
                    <span>علامة</span>
                    <div style="height: auto;">


                        <div data-options="name:'multiMark',iconCls:'icon-ok'">للمحدد</div>
                        <!--<div data-options="name:'removeAllSelected'"id="removeAllSelected" >الكل</div>-->
                    </div>

                </div>
                <!--<div data-options="name:'new'">تفاصيل أكثر</div>-->
                <div data-options="name:'selectAll',iconCls:'icon-ok'">تحديد الكل</div>
                <div data-options="name:'unselect',iconCls:'icon-pen'" id="unselect" style="display: none;">إزالة التحديد</div>
                <!--<div class="menu-sep"></div>-->
                <!--<div data-options="name:'exit'">Exit</div>-->
            </div>

            <!--<div id="singleFile" class="easyui-window" title="حذف  ملف " data-options="modal:true,closed:true,iconCls:'icon-save'" style="width:300px;height:auto;padding:10px;text-align: right;">-->
            <div id="closeNote" class="easyui-window" data-options="modal:true,closed:true" title="إغلاق الطلبات" style="width:500px;height:auto;padding:10px;text-align: right;">
                <div style="">

                    <table class="table" style="width:100%;border: none;margin-right: auto;margin-left: auto" dir="rtl" id="data">


                        <tr>
                            <td style="width: 40%;"> <label style="width: 100px;">ملاحظات الإغلاق</label></TD>
                            <td style="width: 60%;"><TEXTAREA cols="40" rows="5" name="notes" id="notes"></TEXTAREA></TD>
                        </TR>
                        <tr>
                            <td style="width: 40%;"> <label style="width: 100px;">التاريخ</label></TD>
                            <td style="width: 60%;">  <input name="closedEndDate" id="closedEndDate" type="text" size="40" maxlength="50" style="width:50%;float: right;font-size: 12px;" value="<%=nowTime%>"/></TEXTAREA></TD>
                        </TR>
                        <tr>
                            <td colspan="2">
                                <div data-options="region:'south',border:false" style="text-align:center;padding:5px 0 0;">
                                    <a class="easyui-linkbutton" data-options="name:'removeOk',iconCls:'icon-ok'" href="javascript:void(0)" onclick="JavaScript:close_comp(this);">حفظ</a>
                                    <a class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" href="javascript:void(0)" onclick="javascript:closeAlert(this)">إلغاء</a>


                                </div>
                            </td>
                        </tr>
                    </table>

                </div>

            </div>
        </div>
        <FIELDSET  class="set" style="width:100%;" >
            <DIV align="<%=align%>" style="padding:<%=align%>; display: inline;width: 100%;margin-bottom: 10px;">
                <TABLE class="blueBorder" dir="rtl" style="width: 100%;margin-right: 52%;padding-top: 10px; padding-bottom: 4px; padding-left: 10px; padding-right: 10px; margin-top: 15px;border: none !important;" border="0">
                    <tr style="border: none;">
                        <TD class="backgroundTable" style="border: none;background-color: transparent;text-align: left;">
                            <LABEL style="font-size: 16px;color: blue;"> الوارد حديثا : </LABEL><b id="comingMsg" style="color: red;font-size: 16px;">0</b>
                        </td>
                    </tr>
                </TABLE>

            </DIV>

            <DIV style="width: 50%;display: none;float: right;margin: 0px;" id="actionBtn">

                <div class="turn_off"onclick="popupCloseO(this);"></DIV>
                <div style="float: right;margin-top: 3px;"> <input type="button"  onclick="redirect()" class="button_redirec"></div>
                <div style="float: right;margin-top: 3px;">    <INPUT type="button" value="" onclick="removeInMsg()"class="button_remove"/></div>
            </div>

            <TABLE   id="incomingMsg"  align="center" WIDTH="100%" CELLPADDING="0" cellspacing="0" style="display: none;">
                <thead>

                    <TR>
                        <TH  > <SPAN style=""></SPAN></TH>
                        <TH  ><SPAN ><img src="images/icons/Numbers.png" width="20" height="20" /><b> <%=complaintNo%></b></SPAN></TH>
                        <TH  ><SPAN><img src="images/icons/client.png" width="20" height="20" /><b> <%=customerName%></b></SPAN></TH>
                        <TH  ><SPAN><b><%=type%></b></SPAN></TH>
                        <TH  ><SPAN><img src="images/icons/list_.png" width="20" height="20" /><b> <%=complaint%></b></SPAN></TH>
                        <TH  ><SPAN><img src="images/icons/key.png" width="20" height="20" /><b> <%=complaintCode%></b></SPAN></TH>
                        <TH  ><SPAN><img src="images/icons/status_.png" width="18" height="18" /><b> <%=compStatus%></b></SPAN></TH>
                        <TH   ><SPAN><img src="images/icons/manager.png" width="18" height="18" /><b> <%=compSender%></b></SPAN></TH>

                        <TH  ><img src="images/icons/Time.png" width="20" height="20" /><b> <%=complaintDate%></b></TH>
                        <TH  ><b><%=ageComp%></b></TH>

                    </TR>

                </thead>
                <tbody  >  
                    <%
                        for (WebBusinessObject wbo : issuesVector) {

                            iTotal++;
                            String compStyle = "";
                            //    if (wbo.getAttribute("option3") == null) {

                    %>
                    <TR id="xx">
                        <% WebBusinessObject clientCompWbo = null;
                            String compType = "";
                            ClientComplaintsMgr clientComplaintsMgr = ClientComplaintsMgr.getInstance();
                            clientCompWbo = clientComplaintsMgr.getOnSingleKey(wbo.getAttribute("clientComId").toString());
                            if (clientCompWbo.getAttribute("ticketType").toString().equals("1")) {
                                compType = "شكوى";
                                compStyle = "comp";
                            } else if (clientCompWbo.getAttribute("ticketType").toString().equals("2")) {
                                compType = "طلب";
                                compStyle = "order";
                            } else if (clientCompWbo.getAttribute("ticketType").toString().equals("3")) {
                                compType = "استعلام";
                                compStyle = "query";
                            }
                        %>
                        <TD style="background-color: transparent;">
                            <SPAN style="display: inline-block;height: 20px;background: transparent;"><INPUT type="checkbox" id="compId" class="case" value="<%=wbo.getAttribute("clientComId") + "," + wbo.getAttribute("issue_id")%>" name="selectedIssue"  onchange="showSubMenu(this)"/>
                                <input type="hidden" id="selectedId" value="<%=wbo.getAttribute("clientComId")%>" />
                                <%
                                    WebBusinessObject wbo2 = new WebBusinessObject();
                                    BookmarkMgr bookmarkMgr = BookmarkMgr.getInstance();
                                    wbo2 = bookmarkMgr.getOnSingleKey("key1", (String) wbo.getAttribute("clientComId"));

                                    if (wbo2 != null) {
                                        String note = (String) wbo2.getAttribute("bookmarkText");
                                        String bookmarkId = (String) wbo2.getAttribute("bookmarkId");
                                %>

                                <div style="display: inline;background: transparent;">
                                    <%if (wbo2.getAttribute("bookmarkText").equals("open")) {%>
                                    <IMG id="bookmarkImg" value="<%=wbo.getAttribute("clientComId")%>" width="19px" height="19px" src="images/icons/bookmark_uns.png"  style="margin: -4px 0;background-color: transparent;"/>

                                    <%}
                                    } else {%>
                                    <IMG id="bookmarkImg" class="<%=wbo.getAttribute("clientComId")%>" width="19px" height="19px" src="images/icons/bookmark_selected.png" style="margin: -4px 0;background-color: transparent;" />

                                    <%}%>

                                </div></SPAN>

                        </TD>

                        <TD    style="cursor: pointer" onmouseover="this.className = '<%=compStyle%>'" onmouseout="this.className = ''">
                            <a href="<%=context%>/IssueServlet?op=getSupervisorComp&issueId=<%=wbo.getAttribute("issue_id")%>&compId=<%=wbo.getAttribute("clientComId")%>&statusCode=<%=wbo.getAttribute("statusCode")%>&receipId=<%=wbo.getAttribute("receip_id")%>&senderID=<%=wbo.getAttribute("senderId")%>&clientType=<%=wbo.getAttribute("age")%>" > <font color="red"><%=wbo.getAttribute("businessID").toString()%></font><font color="blue">/<%=wbo.getAttribute("businessIDbyDate").toString()%></font>
                            </a>
                            <input type="hidden" id="issue_id" value="<%=wbo.getAttribute("issue_id")%>" />
                            <input type="hidden" id="comp_Id" value="<%=wbo.getAttribute("clientComId")%>" />
                            <input type="hidden" id="receip_id" value="<%=wbo.getAttribute("receipId")%>" />
                            <input type="hidden" id="sender_id" value="<%=wbo.getAttribute("senderId")%>" />
                        </TD>
                        <TD   ><b><%=wbo.getAttribute("customerName").toString()%></b></TD>

                        <TD  ><b><%=compType%></b></TD>

                        <% String sCompl = " ";
                            if (wbo.getAttribute("compSubject") != null && !wbo.getAttribute("compSubject").equals("")) {
                                sCompl = (String) wbo.getAttribute("compSubject");
                                if (sCompl.length() > 10) {
                                    //sCompl = sCompl.substring(0,23) + "....";
                        %>
                        <TD  STYLE="text-align:center;padding: 5px; font-size: 12px;" width="20%"><b><%=sCompl%></b></TD>
                        <% } else {%>
                        <TD  ><b><%=sCompl%></b></TD>
                        <% }%>
                        <% } else {%>
                        <TD  ><b><%=sCompl%></b></TD>
                        <%}%>
                        <TD  ><b><%=wbo.getAttribute("businessCompId")%></b></TD>
                        <% if (stat.equals("En")) {
                                complStatus = (String) wbo.getAttribute("statusEnName");
                            } else {
                                complStatus = (String) wbo.getAttribute("statusArName");
                            }
                        %>
                        <TD  ><b><%=complStatus%></b></TD>
                        <% if (wbo.getAttribute("senderName") != null && !wbo.getAttribute("senderName").equals("")) {
                                senderName = (String) wbo.getAttribute("senderName");
                            } else {
                                senderName = "";
                            }
                        %>
                        <TD  ><b><%=senderName%></b></TD>
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
                    <% //} else {
                            //  }
                        }%>
                </tbody>

            </TABLE>
            <input type="hidden" name="beginDate" id="beginDate" value="<%=beginDate%>">
            <input type="hidden" name="endDate" id="endDate" value="<%=endDate%>">
            <input type="hidden" name="projectName" id="projectName" value="All">
            <input type="hidden" name="statusName" id="statusName" value="Schedule">
            <BR>
        </FIELDSET>

        <TABLE id="tblData" class="blueBorder"  ALIGN="center" dir="<%=dir%>" width="50%" cellpadding="0" cellspacing="0" style="display: none;margin:auto;">
            <TR>
                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="5%"><b>#</b></TD>
                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="10%" ><b><%=codeStr%></b></TD>
                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="20%" id="empNameShown" value=""><b><%=projectStr%></b></TD>
                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="10%"><b><%=distanceStr%></b></TD>
                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="10%"><b><%=responsibleStr%></b></TD>
                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="5%"><b><%=save%></b></TD>
                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="5%"><b><%=deleteStr%></b></TD>
            </TR>
        </TABLE>

        <INPUT type="hidden" id="ids" />
        <input type="hidden" id="ISSUEID" value="" />
        <input type="hidden" id="COMPID" value="" />
        <input type="hidden" id="RECID" value="" />
        <input type="hidden" id="SENDERID" value="" />

    </CENTER>
    <!--<DIV id="tblDataDiv" style="width: 50%;margin-right: auto;margin-left: auto;">-->

    <!--</DIV>-->


</BODY>
</HTML>