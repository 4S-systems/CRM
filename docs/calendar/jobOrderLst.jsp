<%-- 
    Document   : jobOrderLst
    Created on : Aug 14, 2017, 12:37:27 PM
    Author     : fatma
--%>

<%@page import="com.clients.db_access.AppointmentMgr"%>
<%@page import="java.util.Vector"%>
<%@page import="com.maintenance.db_access.GroupPrevMgr"%>
<%@page import="com.silkworm.common.SecurityUser"%>
<%@page import="java.util.List"%>
<%@page import="com.tracker.db_access.ProjectMgr"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@page import="com.silkworm.util.DateAndTimeControl"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.DateFormat"%>
<%@page import="com.clients.db_access.ClientComplaintsMgr"%>
<%@page import="com.silkworm.common.UserMgr"%>
<%@page import="java.util.Calendar"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="java.text.SimpleDateFormat"%>

<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    int iTotal = 0;
    
    AppointmentMgr appointmentMgr = AppointmentMgr.getInstance();
    
    Calendar cal = Calendar.getInstance();
    String jDateFormat = "yyyy/MM/dd";
    SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
    String nowTime = sdf.format(cal.getTime());
    cal.add(Calendar.DAY_OF_MONTH, -3);
    String beDate = request.getAttribute("beginDate") != null ? (String) request.getAttribute("beginDate") : sdf.format(cal.getTime());
    String eDate = request.getAttribute("endDate") != null ? (String) request.getAttribute("endDate") : nowTime;
    
    WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
    String loggegUserId = (String) loggedUser.getAttribute("userId");
    
    ArrayList<WebBusinessObject> data = request.getAttribute("data") != null ? (ArrayList<WebBusinessObject>) request.getAttribute("data")  : appointmentMgr.getJobOrdersList(beDate, eDate, null, loggegUserId,/* areaID, */ null);
    
    WebBusinessObject areaWbo = (WebBusinessObject) request.getAttribute("areaWbo");
    ArrayList<WebBusinessObject> techniciansList = (ArrayList<WebBusinessObject>) request.getAttribute("techniciansList");
    String areaName = areaWbo != null && areaWbo.getAttribute("projectName") != null ? (String) areaWbo.getAttribute("projectName") : "";
    
    jDateFormat = "yyyy/MM/dd HH:mm";
    
    String stat = (String) request.getSession().getAttribute("currentMode");
    String dir = null;
    String title, beginDate, endDate, search;
    String complaintNo, customerName, branch;
    String sat, sun, mon, tue, wed, thu, fri;
    String complStatus;
    String sDate, close, usr, status, ordrDate;
    if (stat.equals("En")) {
        dir = "LTR";
        title = " Zone Manager Desktop ";
        beginDate = " From Date ";
        endDate = " To Date ";
        complaintNo = "Order No.";
        customerName = "Customer name";
        branch = " Branch ";
        sat = "Sat";
        sun = "Sun";
        mon = "Mon";
        tue = "Tue";
        wed = "Wed";
        thu = "Thu";
        fri = "Fri";
        close = "Close";
        search = " Search ";
        usr = " Requested By ";
        status = " Status ";
        ordrDate = " Order Date ";
    } else {
        dir = "RTL";
        title = " Zone Manager Desktop ";
        beginDate = "&#1605;&#1606; &#1578;&#1575;&#1585;&#1610;&#1582;";
        endDate = "&#1575;&#1604;&#1609; &#1578;&#1575;&#1585;&#1610;&#1582;";
        complaintNo = "&#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1578;&#1575;&#1576;&#1593;&#1577;";
        customerName = "&#1575;&#1587;&#1605; &#1575;&#1604;&#1593;&#1605;&#1610;&#1604;";
        branch = " الفرع ";
        sat = "&#1575;&#1604;&#1587;&#1576;&#1578;";
        sun = "&#1575;&#1604;&#1575;&#1581;&#1583;";
        mon = "&#1575;&#1604;&#1575;&#1579;&#1606;&#1610;&#1606;";
        tue = "&#1575;&#1604;&#1579;&#1604;&#1575;&#1579;&#1575;&#1569;";
        wed = "&#1575;&#1604;&#1575;&#1585;&#1576;&#1593;&#1575;&#1569;";
        thu = "&#1575;&#1604;&#1582;&#1605;&#1610;&#1587;";
        fri = "&#1575;&#1604;&#1580;&#1605;&#1593;&#1577;";
        close = "إغلاق كل الأوامر المختارة";
        search = " بحث ";
        usr = " عامل الإتصال ";
        status = " الحالة ";
        ordrDate = " تاريخ الأمر ";
    }
    
    String clientID = request.getAttribute("clientID") != null ? (String) request.getAttribute("clientID") : null;
    
    ProjectMgr projectMgr = ProjectMgr.getInstance();
    WebBusinessObject userWbo = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
    String managerId, departmentId = "";
    ArrayList<WebBusinessObject> actionsList = new ArrayList<>();
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
    
    GroupPrevMgr groupPrevMgr = GroupPrevMgr.getInstance();
    Vector groupPrev = groupPrev = groupPrevMgr.getOnArbitraryKey(userWbo.getAttribute("groupID").toString(), "key1");
    ArrayList<String> userPrevList = new ArrayList<String>();
    WebBusinessObject wboPrev;
    for (int i = 0; i < groupPrev.size(); i++) {
        wboPrev = (WebBusinessObject) groupPrev.get(i);
        userPrevList.add((String) wboPrev.getAttribute("prevCode"));
    }
%>

<html>
    <head>  
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery-ui-timepicker-addon.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css">
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css">
        
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        
        <script LANGUAGE="JavaScript" type="text/javascript">
            $(function () {
                $("#beginDate, #endDate").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: "yy/mm/dd"
                });
                
                $("#closedEndDate").datetimepicker({
                    changeMonth: true,
                    changeYear: true,
                    maxDate: '<%=nowTime%>',
                    dateFormat: "yy/mm/dd",
                    timeFormat: "hh:mm"
                });
            });
            
            $(document).ready(function () {
                $('#indextable').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                    iDisplayLength: 25,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true,
                    "bAutoWidth": true,
                    "aaSorting": [[0, "asc"]]
                }).fadeIn(2000);
                
                $(".dataTables_length, .dataTables_info").css("float", "left");
                $(".dataTables_filter, .dataTables_paginate").css("float", "right");
                
                $('#employeesList').dataTable({
                    'bSort': false,
                    'aoColumns': [ 
                          { sWidth: "5%", bSearchable: false, bSortable: false }, 
                          { sWidth: "95%", bSearchable: false, bSortable: false }
                    ],
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[10, 25, -1], [10, 25, "All"]],
                    iDisplayLength: 10,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true
                }).fadeIn(2000);
            });
            
            function closePopup(obj) {
                $(obj).parent().parent().bPopup().close();
            }
            
            function popupClose(obj) {
                if ($("input[name='moveTo']:checked").not(":disabled").length > 0) {
                    $("#closedMsg").hide();
                    $('#closeNote').find("#notes").val("");
                    $('#closeNote').css("display", "block");
                    $('#closeNote').bPopup({easing: 'easeInOutSine', //uses jQuery easing plugin
                        speed: 400,
                        transition: 'slideDown'});
                } else {
                    alert(" Choose One Order At Least ");
                }
            }
            
            function selectAll(obj) {
                $("input[name='moveTo']").prop('checked', $(obj).is(':checked'));
            }
            
            function closeComplaint(obj) {
                var notes = $('#notes').val();
                var endDate = $('#closedEndDate').val();
                var actionTaken = $('#actionTaken').val();
                $("input[name='moveTo']:checked").not(":disabled").each(function () {
                    var clientComplanitID = $(this).val();
                    var issueID = $("#issueID" + clientComplanitID).val();
                    var clientID = $("#clientID" + clientComplanitID).val();
                    $.ajax({
                        type: "post",
                        url: "<%=context%>/ComplaintEmployeeServlet?op=closeComp&issueId=" + issueID + "&compId=" + clientComplanitID + "&subject=Job Order&comment=Job Order&complaintId=" + clientComplanitID + "&objectType=" + $("#businessObjectType2").val(),
                        data: {
                            notes: notes,
                            clientId: clientID,
                            endDate: endDate,
                            actionTaken: actionTaken
                        },
                        success: function (jsonString) {
                            var info = $.parseJSON(jsonString);
                            if (info.status == 'ok') {
                                $("#closedMsg").show();
                                $(obj).removeAttr("onclick");
                            }
                            else {
                            }
                        }
                    });
                });
            }
            
            function viewAppointment(appointmentID) {
                var url = "<%=context%>/AppointmentServlet?op=viewAppointment&appointmentID=" + appointmentID;
                jQuery('#view_joborder').load(url);
                $('#view_joborder').bPopup({easing: 'easeInOutSine', //uses jQuery easing plugin
                    speed: 400,
                    transition: 'slideDown'});
            }
            
            function getComplaints(){
                if(<%=clientID%> == null ){
                    document.COMP_FORM.action = "<%=context%>/AppointmentServlet?op=listJobOrders&pg=2&my=1";
                } else {
                    document.COMP_FORM.action = "<%=context%>/AppointmentServlet?op=listJobOrders&pg=2&clientID=" + <%=clientID%> + "&my=1";
                }
                document.COMP_FORM.submit();
            }
            
            function popupFinish(obj) {
                if ($("#moveTo:checked").length > 0 && $("#moveTo:checked").length < 11) {
                    $('#finishNote').bPopup();
                    $('#finishNote').css("display", "block");
                } else if($("#moveTo:checked").length > 10) {
                    alert(" Can`t Finish More Than 10 Job Order At A Time ");
                } else {
                    alert(" Choose At Least One Job Order To Finish It ");
                }
            }
            
            function finishComp(obj) {
                $(obj).attr("disabled", "true");
                var note = "";
                var moveTo = [];
                note = $("#notesFinish").val();
               $("input[name=moveTo]:checked").each(function() {
                   moveTo.push($(this).val());
                });
                var endDate = $('#finishEndDate').val();
                var actionTaken = $('#actionTakenFinish').val();
                $.ajax({
                    type: "post",
                    url: "<%=context%>/ComplaintEmployeeServlet?op=finishMultiComplaintsAjax",
                    data: {
                        ids: moveTo.join(),
                        note: note,
                        endDate: endDate,
                        actionTaken: actionTaken
                    },
                    success: function(jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.status === 'ok') {
                            alert(" Finish Done Successfully ");
                            location.reload();
                        } else if (info.status === 'error') {
                            alert(" Not Finished ");
                            $(obj).removeAttr("disabled");
                            $("#finishNote").bPopup().close();
                        }
                    }
                });
                return false;
            }
            
            function popupBookmark(obj) {
                if ($("#moveTo:checked").length > 0 && $("#moveTo:checked").length < 11) {
                    $('#bookmarkDiv').bPopup();
                    $('#bookmarkDiv').css("display", "block");
                } else if($("#moveTo:checked").length > 10) {
                    alert(" Can`t Bookmark More Than 10 Job Order At A Time ");
                } else {
                    alert(" Choose At Least One Job Order To Bookmark It ");
                }
            }
            
            function bookmarkComplaints(obj) {
                $(obj).attr("disabled", "true");
                var note = "";
                var title = "";
                var moveTo = [];
                note = $("#bookmarkNote").val();
                title = $("#bookmarkTitle").val();
                $("input[name=moveTo]:checked").each(function() {
                   moveTo.push($(this).val());
                });
                $.ajax({
                    type: "post",
                    url: "<%=context%>/BookmarkServlet?op=bookmarkMultiComplaintsAjax",
                    data: {
                        ids: moveTo.join(),
                        title: title,
                        note: note
                    },
                    success: function(jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.status === 'ok') {
                            alert(" Added To Bookmark List Successfully ");
                            $(obj).removeAttr("disabled");
                            $("#incomingMsg").find("#moveTo:checkbox:checked").prop('checked', false);
                            $("#bookmarkDiv").bPopup().close();
                        } else if (info.status === 'error') {
                            alert(" Not Added To BookMark List ");
                            $(obj).removeAttr("disabled");
                            $("#bookmarkDiv").bPopup().close();
                        }
                    }
                });
                return false;
            }
            
            function showDistributionForm() {
                if ($("#moveTo:checked").length > 0 && $("#moveTo:checked").length < 11) {
                    $("#distributionMsg").text("");
                    $('#distributionForm').bPopup();
                    $('#distributionForm').css("display", "block");
                } else if($("#moveTo:checked").length > 10) {
                    alert(" Can`t Distribute More Than 10 Job Order At A Time ");
                } else {
                    alert(" Choose At Least One Job Order To Distribute It ");
                }
            }

            function distributeToEmployee(obj) {
                var employeeId = $('#employeesList').find(':input:checked');
                if (employeeId.val() !== null) {
                    var moveTo = [];
                    var businessIDs = [];
                    $("input[name=moveTo]:checked").each(function() {
                       moveTo.push($(this).val());
                    });
                    $("#redistBtn").hide();
                    $.ajax({
                        type: "post",
                        url: "<%=context%>/IssueServlet?op=distributionToEmployee",
                        data: {
                            employeeId: employeeId.val(),
                            ids: moveTo.join(),
                            comment:  "اعادة توجيه من <%=securityUser.getFullName()%>",
                            subject:  "اعادة توجيه من <%=securityUser.getFullName()%>"
                        },
                        success: function(jsonString) {
                            var info = $.parseJSON(jsonString);
                            if (info.status === 'ok') {
                                location.reload();
                            }
                            if (info.status === 'error') {
                                $("#redistBtn").show();
                                $("#distributionMsg").css("display", "block");
                                $("#distributionMsg").css("color", "red");
                                $("#distributionMsg").css("font-size", "15px");
                                $("#distributionMsg").text("لم يتم التوجيه");
                            }
                        }, error: function(jsonString) {
                            alert(jsonString);
                        }
                    });
                } else {
                    $("#distributionMsg").css("display", "block");
                    $("#distributionMsg").css("color", "red");
                    $("#distributionMsg").css("font-size", "15px");
                    $("#distributionMsg").text(" You Should Choose Employee ");
                }
            }
        </script>
        
        <style>
            .login {
                direction: rtl;
                margin: 20px auto;
                padding: 10px 5px;
                background: #3f65b7;
                background-clip: padding-box;
                border: 1px solid #ffffff;
                border-bottom-color: #ffffff;
                border-radius: 5px;
                color: #ffffff;
                background: #7abcff; /* Old browsers */
                /* IE9 SVG, needs conditional override of 'filter' to 'none' */
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
            
            .titleRow {
                background-color: orange;
            }
            
            .login  h1 {
                font-size: 16px;
                font-weight: bold;
                padding-top: 10px;
                padding-bottom: 10px;
                text-shadow: 0 -1px rgba(0, 0, 0, 0.4);
                text-align: center;
                width: 96%;
                margin-left: auto;
                margin-right: auto;
                text-height: 30px;
                color: black;
                text-shadow: 0 1px rgba(255, 255, 255, 0.3);
                background: #FFBB00;
                /*background: #cc0000;*/
                background-clip: padding-box;
                border: 1px solid #284473;
                border-bottom-color: #223b66;
                border-radius: 4px;
                cursor: pointer;
            }
            
            .num{background: #ffc578; /* Old browsers */
                 background: -moz-linear-gradient(top,  #ffc578 0%, #fb9d23 100%); /* FF3.6+ */
                 background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#ffc578), color-stop(100%,#fb9d23)); /* Chrome,Safari4+ */
                 background: -webkit-linear-gradient(top,  #ffc578 0%,#fb9d23 100%); /* Chrome10+,Safari5.1+ */
                 background: -o-linear-gradient(top,  #ffc578 0%,#fb9d23 100%); /* Opera 11.10+ */
                 background: -ms-linear-gradient(top,  #ffc578 0%,#fb9d23 100%); /* IE10+ */
                 background: linear-gradient(to bottom,  #ffc578 0%,#fb9d23 100%); /* W3C */
                 filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#ffc578', endColorstr='#fb9d23',GradientType=0 ); /* IE6-9 */
                 font-weight: bold
            }
            
            .button_close {
                width:135px;
                height:29px;
                margin: 4px;
                background-repeat: no-repeat;
                cursor: pointer;
                border: none;
                background-position: right top ;
                display: inline-block;
                background-color: transparent;
                background-image:url(images/buttons/close.png);
            }
            
            .button_action_items {
                width:100px;
                height:20px;
                margin: 4px;
                background-size: 100%;
                background-repeat: no-repeat;
                cursor: pointer;
                border: none;
                background-position: right top ;
                display: inline-block;
                background-color: transparent;
                background-image:url(images/buttons/action_items.png);
            }
            
            .button_raw_materials {
                width:100px;
                height:20px;
                margin: 4px;
                background-size: 100%;
                background-repeat: no-repeat;
                cursor: pointer;
                border: none;
                background-position: right top ;
                display: inline-block;
                background-color: transparent;
                background-image:url(images/buttons/raw_materials.png);
            }
            
            .button_spare_parts {
                width:100px;
                height:20px;
                margin: 4px;
                background-size: 100%;
                background-repeat: no-repeat;
                cursor: pointer;
                border: none;
                background-position: right top ;
                display: inline-block;
                background-color: transparent;
                background-image:url(images/buttons/spare_parts.png);
            }
            
            .button_worker {
                width:100px;
                height:20px;
                margin: 4px;
                background-size: 100%;
                background-repeat: no-repeat;
                cursor: pointer;
                border: none;
                background-position: right top ;
                display: inline-block;
                background-color: transparent;
                background-image:url(images/buttons/worker.png);
            }
            
            .button_work_items {
                width:100px;
                height:20px;
                margin: 4px;
                background-size: 100%;
                background-repeat: no-repeat;
                cursor: pointer;
                border: none;
                background-position: right top ;
                display: inline-block;
                background-color: transparent;
                background-image:url(images/buttons/work_items.png);
            }
            
            * > * {
                vertical-align : middle;
            }
        
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
            
            .dist_button{
                width:135px;
                height:40px;
                margin: 0px;
                /*margin-right: 90px;*/
                border: none;
                background-repeat: no-repeat;
                cursor: pointer;
                margin-top: 3px;
                background-position: right top ;
                /*display: inline-block;*/
                background-color: transparent;
                background-image:url(images/buttons/redi.png);
            }
        </style>
    </head>
    <body>
        <div id="view_joborder" style="width: 40% !important;display: none;position: fixed; z-index: 10000;">
        </div>
        
        <div id="closeNote"  style="width: 40%;display: none; position: fixed">
            <div style="clear: both;margin-left: 93%;margin-top: 0px;margin-bottom: -38px;z-index: -10000000;">
                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat; -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0); background-color: transparent;
                                                                                -moz-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0); box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                                                                                -webkit-border-radius: 100px; -moz-border-radius: 100px; border-radius: 100px;" onclick="closePopup(this)"/>
            </div>

            <!--<h1>رسالة قصيرة</h1>-->
            <div class="login" style="width:80%;margin-left: auto;margin-right: auto;">
                <table  border="0px" class="table" style="width:100%;text-align: right;margin-bottom: 10px !important;margin-left: auto;margin-right: auto;" >
                    <tr>
                        <td style="width: 40%;">
                            <label style="width: 100px;">
                                 ملاحظات الإغلاق 
                            </label>
                        </td>
                        
                        <td style="width: 60%;"><TEXTAREA cols="40" rows="5" name="notes" id="notes"></TEXTAREA>
                            <input type="hidden" name="actionTaken" id="actionTaken" value=""/>
                        </td>
                    </tr>

                    <tr>
                        <td style="width: 40%;">
                            <label style="width: 100px;">
                                 التاريخ 
                            </label>
                        </td>

                        <td style="width: 60%;">
                            <input name="closedEndDate" id="closedEndDate" type="text" size="40" maxlength="50" style="width:50%; float: right; font-size: 12px;" value="<%=nowTime%>"/>
                        </td>
                    </tr>
                    
                    <tr>
                        <td colspan="2" >
                            <input type="button" onclick="JavaScript:closeComplaint(this);" class="button_close">
                        </td>
                    </tr>
                    
                    <tr>
                        <%
                            String msg = "\u062A\u0645 \u0627\u0644\u0623\u063A\u0644\u0627\u0642 \u0628\u0646\u062C\u0627\u062D";
                            if (MetaDataMgr.getInstance().getSendMail() != null && MetaDataMgr.getInstance().getSendMail().equalsIgnoreCase("1")) {
                                msg += " \u0648 \u0623\u0631\u0633\u0627\u0644 \u0625\u0645\u064A\u0644 \u0628\u0630\u0644\u0643";
                        %>
                        
                        <% }%>
                        <td colspan="2" >
                            <div style="margin: 0 auto; display: none; width: 90%; text-align: center; color: white" id="closedMsg">
                                 <%=msg%> 
                            </div>
                        </td>
                    </tr>
                </TABLE>
            </div>
        </div>
                        
        <div id="finishNote"  style="width: 40%;display: none;position: fixed">
            <div style="clear: both;margin-left: 93%;margin-top: 0px;margin-bottom: -38px;z-index: -10000000;">
                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat; -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0); background-color: transparent;
                                                                                -moz-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0); box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                                                                                -webkit-border-radius: 100px; -moz-border-radius: 100px; border-radius: 100px;" onclick="closePopup(this)"/>
            </div>
            <!--<h1>رسالة قصيرة</h1>-->
            <div class="login" style="width:90%; margin-left: auto; margin-right: auto;">
                <table border="0px" class="table" style="width:100%; text-align: right; margin-bottom: 10px !important; margin-left: auto; margin-right: auto;" >                
                    <tr>
                        <td style="width: 40%;">
                            <label style="width: 100px;">
                                 اﻷجراء المحدد 
                            </label>
                        </td>
                        
                        <td style="width: 60%;">
                            <select id="actionTakenFinish" name="actionTakenFinish" STYLE="width:175px; font-size: small; text-align: right; float: right;">
                                <sw:WBOOptionList wboList='<%=actionsList%>' displayAttribute = "projectName" valueAttribute="projectID" />
                                <option value="100" selected>Other</option>
                            </select>
                        </td>
                    </tr>
                    
                    <tr>
                        <td style="width: 40%;">
                            <label style="width: 100px;">
                                 ملاحظات الإنهاء 
                            </label>
                        </TD>
                        
                        <td style="width: 60%;">
                            <TEXTAREA cols="40" rows="5" name="notesFinish" id="notesFinish"></TEXTAREA>
                        </TD>
                    </TR>
                    
                    <tr>
                        <td style="width: 40%;">
                            <label style="width: 100px;">
                                 التاريخ 
                            </label>
                        </TD>
                        
                        <td style="width: 60%;">
                            <input name="finishEndDate" id="finishEndDate" type="text" size="40" maxlength="50" style="width:50%; float: right; font-size: 12px;" value="<%=nowTime%>"/>
                        </TD>
                    </TR>
                    
                    <tr>
                        <td colspan="2">
                            <input type="button" onclick="JavaScript:finishComp(this);" class="turn_off" style="float: none !important;">
                        </TD>
                    </tr>
                    
                    <tr>
                        <td colspan="2">
                            <div style="margin: 0 auto; display: none; width: 90%; text-align: center; color: white" id="finishMsgDiv">
                                 تم الإنهاء بنجاح 
                            </div>
                        </td>
                    </tr>
                </TABLE>
            </div>
        </div>
                        
        <div id="bookmarkDiv" style="width: 30%; margin-right: auto; margin-left: auto; display: none; position: fixed; top: 0%;">
            <div style="clear: both; margin-left: 88%; margin-bottom: -38px; z-index: -10000000;">
                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat; -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                                                                                -moz-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                                                                                box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0); -webkit-border-radius: 100px;
                                                                                -moz-border-radius: 100px; border-radius: 100px;" onclick="closePopup(this)"/>
            </div>
            
            <div class="login" style="width: 85%; margin-bottom: 10px; margin-left: auto; margin-right: auto;">
                <table border="0px" style="width:100%;" class="table">
                    <tr>
                        <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 30%;">
                             العنوان 
                        </td>
                        
                        <td style="width: 70%; text-align: left;" >
                            <input name="bookmarkTitle" id="bookmarkTitle" value="" style="width: 100%;"/>
                        </td>
                    </tr>
                    
                    <tr>
                        <td style="color:#f1f1f1; font-size: 16px; font-weight: bold; width: 30%;">
                             التفاصيل 
                        </td>
                        
                        <td style="width: 70%;" >
                            <textarea  placeholder="" style="width: 100%; height: 80px;" id="bookmarkNote"></textarea>
                        </td>
                    </tr> 
                </table>
                <div style="text-align: center;margin-left: auto;margin-right: auto;clear: both" >
                    <input type="button" onclick="JavaScript: bookmarkComplaints(this);" class="bookmark_button" style="float: none !important;"/>
                </div>
            </div>  
        </div>
                        
        <div id="distributionForm" style="width:40%; display: none;">
            <div style="clear: both; margin-left: 89%; margin-top: 0px; margin-bottom: -35px; z-index: -10;">
                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;" onclick="closePopup(this)"/>
            </div>
            
            <div class="login" style="width: 90%;float: left;margin-bottom: 3px;">
                <table id="employeesList" align="center" WIDTH="100%" CELLPADDING="0" cellspacing="0" style="">
                    <thead>
                        <TR>
                            <TH>
                                <SPAN style=""></SPAN>
                            </TH>
                            <TH>
                                <SPAN>
                                    <img src="images/icons/client.png" width="20" height="20" />
                                    <b>
                                         اسم الموظف 
                                    </b>
                                </SPAN>
                            </TH>
                        </TR>
                    </thead>
                    <tbody>  
                        <%
                            if (userUnderManager != null) {
                                for (WebBusinessObject wbo : userUnderManager) {
                                    if(!wbo.getAttribute("userId").equals(userWbo.getAttribute("userId"))) {
                        %>
                                        <TR id="empRow">
                                            <TD style="background-color: transparent;">
                                                <SPAN style="display: inline-block; height: 20px; background: transparent;">
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
                    
                <div style="width: 100%; text-align: center; margin-left: auto; margin-right: auto;">
                    <input type="button" id="redistBtn" onclick="JavaScript: distributeToEmployee();" class="dist_button" value="" style="margin-top: 15px; font-family: sans-serif;">
                    <b id="distributionMsg"></b>
                </div>
            </div>
        </div>
                        
        <form NAME="COMP_FORM" METHOD="POST">
            <fieldset class="set" style="width: 95%; padding-bottom: 20px;">
                <legend align="center">
                    <font color="blue" size="6">
                        <%=title%>
                    </font>
                </legend>
                
                <table align="center" style="direction: <%=dir%>; width: 60%;" cellspacing="2" cellpadding="1">
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px; width: 37%;" width="33%">
                            <font size=3 color="white">
                                 <%=beginDate%> 
                        </td>
                        
                        <td class="blueBorder blueHeaderTD" style="font-size:18px; width: 37%; height: 100%;">
                            <font size=3 color="white">
                                 <%=endDate%> 
                        </td>
                        
                        
                        <td bgcolor="#F7F6F6" style="text-align:center; width: 26%; height: 100%; border: none;" valign="middle" rowspan="2">
                            <button class="button" onclick="JavaScript: getComplaints();" style="width: 50%; color: #000; font-size:15; font-weight:bold;">
                                 <%=search%> 
                                 <IMG HEIGHT="15" SRC="images/search.gif" >
                            </button>  
                        </td>
                    </tr>
                    
                    <tr>
                        <td style="text-align:center; height: 100%; padding: 10px;  border: none;" bgcolor="#F7F6F6" valign="MIDDLE" >
                            <input id="beginDate" name="beginDate" type="text" value="<%=beDate != null && !beDate.isEmpty() ? beDate : ""%>" readonly />
                            <img src="images/showcalendar.gif" > 
                        </td>
                        
                        <td bgcolor="#F7F6F6" style="text-align:center; height: 100%; padding: 10px;  border: none;" valign="middle">
                            <input id="endDate" name="endDate" type="text" value="<%=eDate != null && !eDate.isEmpty() ? eDate : ""%>" readonly />
                            <img src="images/showcalendar.gif" >
                        </td>
                    </tr>
                </table>

                <%
                    if (data != null && !data.isEmpty()) {
                %>
                        <table style="width: 50%; padding-top: 5%; border: none;" align="center">
                            <tr style="border: none;">
                                <td style="border: none;">
                                    <button class="button" onclick="popupFinish(this)" style="width: 20%; color: #000; font-size: 15; font-weight: bold; margin-left: 5%;">
                                         Finish 
                                         <IMG HEIGHT="25" widht="25" SRC="images/icon.png" >
                                    </button>
                                
                                    <button class="button" onclick="popupBookmark(this)" style="width: 20%; color: #000; font-size: 15; font-weight: bold; margin-left: 5%;">
                                         Bookmark 
                                         <IMG HEIGHT="25" widht="25" SRC="images/bookmarks.png" >
                                    </button>
                                    
                                    <button class="button" onclick="popupClose()" style="width: 20%; color: #000; font-size: 15; font-weight: bold; margin-left: 5%;">
                                         Close 
                                         <IMG HEIGHT="25" widht="25" SRC="images/icons/quit.png" >
                                    </button>
                                </td>
                            </tr>
                        </table>

                        <div style="width: 95%; padding-top: 2%;">
                            <table class="display" id="indextable" align="center" cellpadding="0" cellspacing="0" style="direction: <%=dir%>;">
                                <thead>
                                    <tr>
                                        <th style="text-align:center; font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px; width: 1%;">
                                            <b>
                                                #
                                            </b>
                                        </th>

                                        <th style="width: 1%;">
                                            <input type="checkbox" id="ToggleTo" name="ToggleTo" onchange="JavaScript: selectAll(this);"/>
                                        </th>   

                                        <th style="text-align:center; font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="10%">
                                            <img src="images/icons/Numbers.png" width="20" height="20" />
                                            <b>
                                                 <%=complaintNo%> 
                                            </b>
                                        </th>

                                        <th style="text-align:center; font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="30%">
                                            <img src="img/branch.png" width="20" height="20" />
                                            <b>
                                                <%=customerName%> 
                                            </b>
                                        </th>

                                        <th style="width: 1%;">
                                        </th>

                                        <th style="text-align:center; font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="30%">
                                            <b>
                                                <%=branch%> 
                                            </b>
                                        </th>

                                        <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="10%">
                                            <b>
                                                 <%=usr%> 
                                            </b>
                                        </th>

                                        <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="5%">
                                            <b>
                                                 <%=status%>
                                            </b>
                                        </th>

                                        <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="11%">
                                            <b>
                                                 <%=ordrDate%> 
                                            </b>
                                        </th>
                                    </tr>
                                </thead> 
                            <tbody  id="planetData2">  
                                <%
                                    String compStyle = "";
                                    String clientDescription;
                                    String disabled;
                                    Calendar c = Calendar.getInstance();
                                    for (WebBusinessObject wbo : data) {
                                        iTotal++;
                                        clientDescription = (String) wbo.getAttribute("description");
                                        if (clientDescription == null || clientDescription.equalsIgnoreCase("UL")) {
                                            clientDescription = "";
                                        }
                                        disabled = "";
                                        if (wbo.getAttribute("statusCode") != null && wbo.getAttribute("statusCode").equals("7")) {
                                            disabled = "disabled";
                                        }
                                %>
                                <tr style="padding: 1px; background-color: <%=wbo.getAttribute("trColor")%>;">
                                    <td>
                                        <%=iTotal%>
                                    </td>
                                    <td>
                                        <input type="checkbox" id="moveTo" name="moveTo" value="<%=wbo.getAttribute("clientComplaintId")%>" <%=disabled%>/>
                                        <input type="hidden" id="issueID<%=wbo.getAttribute("clientComplaintId")%>" value="<%=wbo.getAttribute("issueId")%>"/>
                                        <input type="hidden" id="clientID<%=wbo.getAttribute("clientComplaintId")%>" value="<%=wbo.getAttribute("clientId")%>"/>
                                    </td>
                                    <td style="cursor: pointer" onmouseover="this.className = '<%=compStyle%>'" onmouseout="this.className = ''">
                                        <%if (wbo.getAttribute("issueId") != null) {%>
                                        <a href="#" onclick="JavaScript: viewAppointment('<%=wbo.getAttribute("id")%>')"> <font color="red"><%=wbo.getAttribute("businessID").toString()%></font><font color="blue">/<%=wbo.getAttribute("businessIDByDate").toString()%></font>
                                        </a>
                                        <%}
                                        %>
                                    </td>
                                    <td>
                                        <%if (wbo.getAttribute("clientName") != null) {%>
                                            <b title="<%=clientDescription%>" style="cursor: hand;">
                                                 <%=wbo.getAttribute("clientName")%> 
                                            </b>
                                        <%}%>
                                    </td>
                                    <td>
                                        <b title="<%=clientDescription%>" style="cursor: hand;">
                                            <a target="_blanck" href="<%=context%>/ClientServlet?op=clientDetailsOrder&clientId=<%=wbo.getAttribute("clientId")%>&issueId=<%=wbo.getAttribute("clientComplaintId")%>">
                                                <img src="images/tools.png" width="40" height="40"/>
                                            </a>
                                        </b>
                                    </td>
                                    <td>
                                        <%if (wbo.getAttribute("branchName") != null) {%>
                                            <b style="cursor: hand;">
                                                 <%=wbo.getAttribute("branchName") != null ? wbo.getAttribute("branchName") : ""%> 
                                            </b>
                                        <%}%>
                                    </td>
                                    <td>
                                        <%if (wbo.getAttribute("createdByName") != null) {%>
                                        <b><%=wbo.getAttribute("createdByName")%></b>
                                        <%}%>
                                    </td>
                                    <% if (stat.equals("En")) {
                                            complStatus = (String) wbo.getAttribute("statusEnName");
                                        } else {
                                            complStatus = (String) wbo.getAttribute("statusArName");
                                        }
                                    %>
                                    <td><b><%=complStatus%></b></td>
                                    <%  c = Calendar.getInstance();
                                        DateFormat formatter;
                                        formatter = new SimpleDateFormat("dd/MM/yyyy");
                                        String[] arrDate = wbo.getAttribute("creationTime").toString().split(" ");
                                        Date date = new Date();
                                        sDate = arrDate[0];
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
                                    <td nowrap  ><font color="red">Today</font></td>
                                            <%} else {%>
                                    <td nowrap  ><font color="red"><%=sDay%> - </font><b><%=sDate%></b></td>
                                            <%}%>
                                </tr>
                                <%
                                    }
                                %>
                            </tbody>
                        </table>
                        </div>
                <%
                } else if (data != null && data.isEmpty()) {
                %>
                <b style="color: red; font-size: x-large;">لا يوجد نتائج للبحث</b>
                <%
                    }
                %>
                <input type="hidden" id="clientId" value="1"/>
            </fieldset>
        </form>
    </body>
</html>
