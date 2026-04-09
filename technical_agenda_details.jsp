<%@page import="com.clients.db_access.ClientComplaintsMgr"%>
<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="com.tracker.engine.IssueStatusFactory, com.tracker.engine.*,java.text.*,com.docviewer.db_access.*, com.maintenance.db_access.*,com.maintenance.common.ParseSideMenu"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %> 
<%@ page contentType="text/HTML; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8"%>
<HTML>
    <meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <meta HTTP-EQUIV="Expires" CONTENT="0">
    <head>
        <title>Weekly Manager Agenda</title>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css">
        <link rel="stylesheet" href="css/demo_table.css">
        <script type="text/javascript" src="jquery-ui/jquery-1.6.2.js"></script>

        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <!--<meta http-equiv="refresh" content="60" />-->
        <script type="text/javascript">
            var oTable;
            $(document).ready(function() {

                oTable = $('#inboxMsg').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[20, 25, 50, -1], [20, 25, 50, "All"]],
                    iDisplayLength: 20,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true,
                    "aaSorting": [[ 9, "asc" ]]

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
        EmployeeViewMgr employeeViewMgr = EmployeeViewMgr.getInstance();
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
        issuesVector = employeeViewMgr.getComplaintsWithoutDate2(3, value, key, "key7", resp, null, null, null);//.getOnArbitraryKeyOrdered(userWbo.getAttribute("userId").toString(), "key3", "key7");
        String stat = (String) request.getSession().getAttribute("currentMode");
        String title, from, to, align, dir, style, Indicators, Quick, important, expectedBegin, expectedEnd, totalTasks;
        String viewD, scheduleCase, executionCase, onHoldCase, fontSize, issueNo, issueTit, equip, issueStatus;
        String complaintNo, customerName, complaintDate, complaint;
        String sat, sun, mon, tue, wed, thu, fri, view, complaintCode, type, compStatus, compSender, noResponse, ageComp;
        String complStatus, senderName = null;
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
            compSender = "&#1575;&#1604;&#1605;&#1585;&#1587;&#1604;";
            noResponse = "&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1578;&#1583;&#1575;&#1608;&#1604;";
            ageComp = "&#1593;.&#1591; (&#1610;&#1608;&#1605;)";
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

        function getComplaintss(issueId, compId, senderId,statusCode,receipId,senderID) {
            window.navigate('<%=context%>/IssueServlet?op=getCompl&issueId=' + issueId + '&senderId=' + senderId + '&compId=' + compId+ '&statusCode=' + statusCode+ '&receipId=' + receipId+ '&senderID=' + senderID);
            
        }
        function closeComp(issueId, compId) {
            window.navigate('<%=context%>/IssueServlet?op=closeComp&issueId=' + issueId + '&compId=' + compId);
        }
        function removeComp(issueId, compId) {
            window.navigate('<%=context%>/IssueServlet?op=removeComp&issueId=' + issueId + '&compId=' + compId);
        }
        $(function() {

            $("#selectAll").click(function() {

                $(".case").attr("checked", this.checked)
                if ($(".case").attr("checked")) {
                    $("#actionBtn").css("display", "block");
                    //                $("#actionBtn").toggle(1000);

                } else {

                    $("#actionBtn").css("display", "none");
                }
            });
            $(".case").click(function() {
                if ($(".case").length == $(".case:checked").length) {
                    $("#selectAll").attr("checked", "checked");

                } else {
                    $("#selectAll").removeAttr("checked");
                    //                $("#selectAll").css("background","images/icons/mi.png");
                }
                if ($(".case:checked").length > 0) {
                    $("#actionBtn").css("display", "block");
                    //                $("#actionBtn").toggle(1000);
                } else {
                    $("#actionBtn").css("display", "none");
                    //                $("#actionBtn").fadeIn(1000);
                }
            });







        });
        function popupFinish(obj) {
            //                alert("popup begin");
            if ($(".case:checked").length > 0) {
                $('#finishNote').bPopup();
                $('#finishNote').css("display", "block");
            } else {
                alert("select first!");
            }
        }
        function finishComp(obj) {
            var selectedMsg = "";
            var note = "";
            var ids = "";
            selectedMsg = $("#inboxMsg").find(".case:checkbox:checked");

            note = $(obj).parent().parent().parent().find("#notes").val();



            $(selectedMsg).each(function(index, obj) {
                var id = $(obj).val();

                //                alert(id);
                ids = ids + id + ",/";

            });
            //            alert(ids)
            //            alert($("#ids").val());
            $("#ids").val(ids);
            //            alert($("#ids").val());
            $.ajax({
                type: "post",
                //                url: "<%=context%>/ComplaintEmployeeServlet?op=closeSelectedComp",
                url: "<%=context%>/ComplaintEmployeeServlet?op=finishSelectedComp",
                data: {
                    selectedId: ids,
                    note: note
                },
                success: function(jsonString) {
                    var info = $.parseJSON(jsonString);

                    if (info.status == 'ok') {

                        //                        var url = "<%=context%>/ClientServlet?op=show2&cach=" + (new Date()).getTime();
                        //                        jQuery('#con3').load(url);
                        //                        $(selectedMsg).parent().parent().parent().remove();



                        $(selectedMsg).parent().parent().parent().each(function(index, obj) {
                            var pos = oTable.fnGetPosition(obj);
                            oTable.fnDeleteRow(pos);
                            //                            oTable.fnDraw(true);

                        });
                        $('#finishNote').css("display", "none");
                        //                        $(selectedMsg).parent().parent().parent().fadeOut("slow", function() {
                        //                            var pos = oTable.fnGetPosition(selectedMsg);
                        //                            oTable.fnDeleteRow(pos);
                        //                            oTable.fnDraw(true);
                        //                        });
                        // Re-draw the table - you wouldn't want to do it here, but it's an example :-)
                        $("#actionBtn").css("display", "none");
                        $("#selectAll").removeAttr("checked");
                        $(obj).parent().parent().parent().find("#notes").val("");
                        //                        var esc = $.Event("keydown", { keyCode: 27 });




                        //                        var e = jQuery.Event("keyup"); // or keypress/keydown
                        //                        e.keyCode = 27; // for Esc
                        //                        $(document).trigger(e); // trigger it on document


                    }
                    if (info.status == 'error') {
                        $('#finishNote').css("display", "none");

                        alert("error");
                    }
                }
            });
            return false;
        }
    </SCRIPT>
    <script src='ChangeLang.js' type='text/javascript'></script>
    <style type="text/css">
        /*        .button_redirec{
                    width:85px;
                    height:40px;
                    margin-right: 90px;
                    border: none;
                    background-repeat: no-repeat;
                    cursor: pointer;
        
                    background-position: right top ;
                    display: inline-block;
                    background-color: transparent;
                    background-image:url(images/buttons/button2.png);
                }
                .button_remove{
                    width:85px;
                    height:40px;
                    margin: 0px;
        
                    margin-right: 90px;
                    border: none;
                    background-repeat: no-repeat;
                    cursor: pointer;
        
                    background-position: right top ;
                    display: inline-block;
                    background-color: transparent;
                    background-image:url(images/buttons/button3.png);
                }*/
        .turn_off{
            width:85px;
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
            background-image:url(images/buttons/button7.png);
        }
    </style>
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
            <DIV align="<%=align%>" style="padding-<%=align%>: 2.5%">
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
            <DIV style="width: 50%;display: none;float: right;margin: 0px;" id="actionBtn">

                <div class="turn_off"onclick="popupFinish(this);"></DIV>
                <!--<div style="float: right;margin-top: 3px;"> <input type="button"  onclick="redirect()" class="button_redirec"></div>
   <div style="float: right;margin-top: 3px;">    <INPUT type="button" value="" onclick="removeInMsg()"class="button_remove"/></div>-->
            </div>

            <TABLE id="inboxMsg" align="center" DIR="<%=dir%>" WIDTH="100%" CELLPADDING="0" cellspacing="0" style="display: none;margin-top: 10px;">
                <thead><TR>
                        <TH  ><SPAN > <input type="checkbox" id="selectAll" /></SPAN></TH>
                        <TH  ><SPAN ><img src="images/icons/Numbers.png" width="20" height="20" /><b> <%=complaintNo%></b></SPAN></TH>
                        <TH  ><SPAN><img src="images/icons/client.png" width="20" height="20" /><b> <%=customerName%></b></SPAN></TH>
                        <TH  ><SPAN><b><%=type%></b></SPAN></TH>
                        <TH  ><SPAN><img src="images/icons/list_.png" width="20" height="20" /><b> <%=complaint%></b></SPAN></TH>
                        <TH  ><SPAN><img src="images/icons/manager.png" width="18" height="18" /><b> <%=compSender%></b></SPAN></TH>
                        <TH  ><SPAN><img src="images/icons/key.png" width="20" height="20" /><b> <%=complaintCode%></b></SPAN></TH>
                        <TH  ><SPAN><b> الحالة</b></SPAN></TH>
                        <TH  ><img src="images/icons/Time.png" width="20" height="20" /><b> <%=complaintDate%></b></TH>
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

                    <% String id = (String) wbo.getAttribute("senderId");
                        WebBusinessObject wbo2 = new WebBusinessObject();
                        UserMgr us = UserMgr.getInstance();
                        wbo2 = us.getOnSingleKey(id);
                        String senderN = (String) wbo2.getAttribute("userName");
                    %>
                    <TR>
                        <TD style="background-color: transparent;">
                            <SPAN style="display: inline-block;height: 20px;"><INPUT type="checkbox" id="compId" class="case" value="<%=wbo.getAttribute("clientComId") + "," + wbo.getAttribute("issue_id")%>" name="selectedIssue" />
                                <input type="hidden" id="selectedId" value="<%=wbo.getAttribute("clientComId")%>" />
                                <%
                                    WebBusinessObject wbo3 = new WebBusinessObject();
                                    BookmarkMgr bookmarkMgr = BookmarkMgr.getInstance();
                                    wbo3 = bookmarkMgr.getOnSingleKey("key1", (String) wbo.getAttribute("clientComId"));

                                    if (wbo3 != null) {
                                        String note = (String) wbo3.getAttribute("bookmarkText");
                                        String bookmarkId = (String) wbo3.getAttribute("bookmarkId");
                                %>
                                <div style="display: inline;">
                                    <%if (wbo3.getAttribute("flag").equals("marked")) {%>

                                    <IMG id="bookmarkImg" value="<%=bookmarkId%>" onclick="deleteBookmark(this)" width="19px" height="19px" src="images/icons/bookmark_selected.png" style="margin: -4px 0;background-color: transparent;border: none;box-shadow: none;" onMouseOver="Tip('<%=note%>', CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#FFFF99', FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT, 'BOLD', TITLEALIGN, 'center', TITLEFONTCOLOR, 'black', TITLEBGCOLOR, '#6699FF')" onMouseOut="UnTip()"/>
                                    <%}
                                    } else {%>

                                    <IMG id="bookmarkImg"  onclick="mark(<%=wbo.getAttribute("clientComId")%>, this)" width="19px" height="19px" src="images/icons/bookmark_uns.png"  style="margin: -4px 0;background-color: transparent;"/>
                                    <%}%>
                                </div></SPAN>

                        </TD>


                        <TD    style="cursor: pointer" onmouseover="this.className = '<%=compStyle%>'" onmouseout="this.className = ''">
                            <a href="<%=context%>/IssueServlet?op=getSupervisorComp&issueId=<%=wbo.getAttribute("issue_id")%>&compId=<%=wbo.getAttribute("clientComId")%>&senderId=<%=wbo2.getAttribute("userId")%>&statusCode=<%=wbo.getAttribute("statusCode")%>&receipId=<%=wbo.getAttribute("currentOwnerId")%>&senderID=<%=wbo.getAttribute("senderId")%>&clientType=<%=wbo.getAttribute("age")%>"> <font color="red"><%=wbo.getAttribute("businessID").toString()%></font><font color="blue">/<%=wbo.getAttribute("businessIDbyDate").toString()%></font>
                            </a>

                        </TD>
                        <TD   ><b><%=wbo.getAttribute("customerName").toString()%></b></TD>

                        <TD  ><b><%=compType%></b></TD>





                        <% String sCompl = " ";
                            if (wbo.getAttribute("comments") != null && !wbo.getAttribute("comments").equals("")) {
                                sCompl = (String) wbo.getAttribute("comments");
                                if (sCompl.length() > 10) {
                                    //sCompl = sCompl.substring(0,23) + "....";
%>
                        <TD  STYLE="text-align:center;padding-<%=align%>: 5px; font-size: 12px;" width="20%"><b><%=sCompl%></b></TD>
                        <% } else {%>
                        <TD  ><b><%=sCompl%></b></TD>
                        <% }%>
                        <% } else {%>
                        <TD  ><b><%=sCompl%></b></TD>
                        <%}%>                                                                                                          
                        <TD  >



                            <b><%=senderN%> </b></TD>
                            <% if (stat.equals("En")) {
                                    complStatus = (String) wbo.getAttribute("statusEnName");
                                } else {
                                    complStatus = (String) wbo.getAttribute("statusArName");;
                                }
                            %>
                        <TD  ><b><%=wbo.getAttribute("businessCompId")%></b></TD>
                        <% if (wbo.getAttribute("statusCode").equals("3")) {%>
                        <td  style="background-color: green;color: #ffffff">
                            <b>open</b>
                        </td>
                        <%} else {%>
                        <td style="background-color: red;color: #ffffff">
                            <b>pending</b>
                        </td>
                        <%}%>
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
                <!--                <center>
                                    <TR>
                                        <TD CLASS="blueBorder blueBodyTD" BGCOLOR="#808080" COLSPAN="5" STYLE="text-align:center;color:white;font-size:16px;">
                                            <b><%=totalTasks%></b>
                                        </TD>
                                        <TD CLASS="blueBorder blueBodyTD" BGCOLOR="#808080" colspan="2" STYLE="text-align:center;color:white;font-size:14px;">
                                            <B><%=iTotal%></B>
                                        </TD>
                                    </TR>
                                </center>-->
            </TABLE>
            <input type="hidden" id="businessCompId" />
            <input type="hidden" name="beginDate" id="beginDate" value="<%=beginDate%>">
            <input type="hidden" name="endDate" id="endDate" value="<%=endDate%>">
            <input type="hidden" name="projectName" id="projectName" value="All">
            <input type="hidden" name="statusName" id="statusName" value="Schedule">
            <BR>
        </FIELDSET>
    </CENTER>
    <div class="popup_conten" id="finishNote" style="display: none;">
        <TABLE dir="rtl" width="100%;" border="0px" style="border: none;">
            <tr>
                <td style="width: 40%;"> <label style="width: 100px;">ملاحظات الإنهاء</label></TD>
                <td style="width: 60%;"><TEXTAREA cols="40" rows="5" name="notes" id="notes"></TEXTAREA></TD>
            </TR>
            <tr>
                <td colspan="2"> <div style="margin-left: auto;margin-right: auto;"><input type="button"  onclick="JavaScript:finishComp(this);" class="turn_off" style="float: none !important;"></DIV></TD>
            </tr>
        </TABLE>

    </div>
</BODY>
</HTML>