<%@page import="com.silkworm.db_access.PersistentSessionMgr"%>
<%@page import="com.maintenance.db_access.IssueByComplaintUniqueMgr"%>
<%@page import="com.maintenance.db_access.GroupPrevMgr"%>
<%@page import="com.maintenance.db_access.GroupPrevMgr"%>
<%@page import="com.maintenance.common.Tools"%>
<%@page import="com.crm.common.CRMConstants"%>
<%@page import="com.maintenance.db_access.IssueDocumentMgr"%>
<%@page import="com.maintenance.db_access.ProjectsByGroupMgr"%>
<%@page import="com.clients.db_access.ClientComplaintsMgr"%>
<%@page import="com.maintenance.db_access.IssueByComplaintAllCaseMgr"%>
<%@page import="java.text.DateFormat"%>
<%@page import="com.silkworm.util.DateAndTimeControl"%>
<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*,com.tracker.app_constants.*, com.tracker.common.*, java.util.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants"%>
<%@ page import="com.silkworm.common.TimeServices,com.silkworm.jsptags.*,com.contractor.db_access.MaintainableMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page pageEncoding="UTF-8"%>
<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    session = request.getSession();
            String remoteAccess = session.getId();
            WebBusinessObject persistentUser = (WebBusinessObject) PersistentSessionMgr.getInstance().getOnSingleKey(remoteAccess);
            String userID = persistentUser.getAttribute("userId").toString();
        
    String newTap = metaMgr.getNewTap();
    List<WebBusinessObject> data = (ArrayList<WebBusinessObject>) request.getAttribute("data");
    List<WebBusinessObject> users = (ArrayList<WebBusinessObject>) request.getAttribute("users");
    String from = (String) request.getAttribute("from");
    String to = (String) request.getAttribute("to");
    String createdBy = (String) request.getAttribute("createdBy");

    List<WebBusinessObject> userProjects = (List<WebBusinessObject>) request.getAttribute("userProjects");
    List<WebBusinessObject> callResults = (List<WebBusinessObject>) request.getAttribute("callResults");
    List<WebBusinessObject> meetings = (List<WebBusinessObject>) request.getAttribute("meetings");
    ArrayList<WebBusinessObject> ratesList = (ArrayList<WebBusinessObject>) request.getAttribute("ratesList");
    ArrayList<WebBusinessObject> campaignList=new ArrayList<>();
    UserMgr userMgr=UserMgr.getInstance();
    List<WebBusinessObject> employees=userMgr.getUsersByDistributionGroup(userID);
    ArrayList<WebBusinessObject> requestTypes=new ArrayList<>(ProjectMgr.getInstance().getOnArbitraryKey("RQ-TYPE", "key4"));
    if (campaignList!=null){
     campaignList =(ArrayList<WebBusinessObject>) request.getAttribute("campaignList");
    }
    
    String campaignId=new String();
    if (campaignId!=null){
    campaignId=(String)request.getAttribute("campaignId");
    }
    String defaultCampaign = (String) request.getAttribute("defaultCampaign");

    Calendar calendar = Calendar.getInstance();
    String timeFormat = "yyyy/MM/dd HH:mm";
    SimpleDateFormat sdf = new SimpleDateFormat(timeFormat);
    String nowTime = sdf.format(calendar.getTime());
    String jDateFormat = "yyyy/MM/dd";
    sdf = new SimpleDateFormat(jDateFormat);
    if (from == null || to == null) {
        createdBy = "";
        to = sdf.format(calendar.getTime());
        calendar = Calendar.getInstance();
        calendar.add(Calendar.MONTH, -1);
        int yaer = calendar.get(Calendar.YEAR);
        int month = (calendar.get(Calendar.MONTH)) + 1;
        int day = calendar.get(Calendar.DATE);
        from = yaer + "/" + month + "/" + day;
    }

    String stat = "Ar";
    String dir = null,  xAlign;
    String title, beginDate, endDate, source, dep, classification,clientEntryDate, campaign;
    if (stat.equals("En")) {
        dir = "LTR";
        title = "Last Appointment for Clients";
        beginDate = "From Date";
        endDate = "To Date";
        source = "Source";
        xAlign = "left";
        dep = " Department ";
        classification = "Classification";
        clientEntryDate="Client entry date";
        campaign = "Campaign";
    } else {
        dir = "RTL";
        title = "أخر المتابعات للعملاء";
        beginDate = "&#1605;&#1606; &#1578;&#1575;&#1585;&#1610;&#1582;";
        endDate = "&#1575;&#1604;&#1609; &#1578;&#1575;&#1585;&#1610;&#1582;";
        source = "المصــــــــــــدر";
        xAlign = "left";
        dep = " الإدارة ";
        classification = "التصنيف";
        clientEntryDate="تاريخ دخول العميل";
        campaign = "الحملة";
    }
    
        int currentDay = calendar.get(Calendar.DAY_OF_MONTH);
        int currentYear = calendar.get(Calendar.YEAR);
        int currentMonth = calendar.get(Calendar.MONTH);
        
        ArrayList<WebBusinessObject> departments = (ArrayList<WebBusinessObject>) request.getAttribute("departments");
        String departmentID = request.getAttribute("departmentID") != null ? (String) request.getAttribute("departmentID") : "";
        
        WebBusinessObject userWbo = (WebBusinessObject) request.getSession().getAttribute("loggedUser");

        GroupPrevMgr groupPrevMgr = GroupPrevMgr.getInstance();
        Vector groupPrev = groupPrev = groupPrevMgr.getOnArbitraryKey(userWbo.getAttribute("groupID").toString(), "key1");

    ArrayList<String> userPrevList = new ArrayList<String>();
        WebBusinessObject wboPrev;
        for (int i = 0; i < groupPrev.size(); i++) {
            wboPrev = (WebBusinessObject) groupPrev.get(i);
            userPrevList.add((String) wboPrev.getAttribute("prevCode"));
        }
%>
<HTML>
    <head>
        <META HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
        <META HTTP-EQUIV="Expires" CONTENT="0"/>   

        <link rel="stylesheet" type="text/css" href="js/jquery/api/jquery-ui.css" />
        <link rel="stylesheet" type="text/css" href="js/jquery/api/jquery-ui.min.css" />
        <link rel="stylesheet" type="text/css" href="js/jquery/api/jquery-ui.structure.css" />
        <link rel="stylesheet" type="text/css" href="js/jquery/api/jquery-ui.structure.min.css" />
        <link rel="stylesheet" type="text/css" href="js/jquery/api/jquery-ui.theme.css" />
        <link rel="stylesheet" type="text/css" href="js/jquery/api/jquery-ui.theme.min.css" />
        <link rel="stylesheet" type="text/css" href="js/jquery/api/jquery.datetimepicker.css" />
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css" />
        <link type='text/css' rel='stylesheet' href='jquery-ui/themes/base/jquery-ui-timepicker-addon.css' />
        <link rel="stylesheet" type="text/css" href="css/tooltip.css"/>
        <link rel="stylesheet" type="text/css" href="css/msdropdown/dd.css" />
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>
        
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.easing.1.3.js"></script>
        <script type="text/javascript" src="js/msdropdown/jquery.dd.min.js"></script>

        <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
            
            
                
            $(function () {
                
                
                
                $("#from").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: "yy/mm/dd"
                });

                $("#to").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: "yy/mm/dd"
                });

                $("#meetingDate").datetimepicker({
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: "yy/mm/dd",
                    formatTime: 'H:i',
                    defaultTime: '10:00',
                    timepickerScrollbar: false,
                    step: 5
                });
                
                $( "#meetingDateDialog" ).datetimepicker({
                    changeMonth: true,
                    changeYear: true,
                    minDate: new Date(),
                    dateFormat: "yy/mm/dd",
                    timeFormat: "HH:mm"
                });

                $("[title]").tooltip({
                    position: {
                        my: "left top",
                        at: "right+5 top-5"
                    }
                });
                try {
                    $(".clientRate").msDropDown();
                    $("#departmentID").msDropDown();
                    $("#campaignId").msDropDown();
                } catch (e) {
                }
            });

            $(document).ready(function () {
                $("#requests").dataTable({
                    "order": [[7, "desc"]],
                    "language": {
                        "url": "js/datatable/Arabic.json"
                    },
                    "destroy": true
                }).fadeIn(2000);
            });

            function getComplaints() {
                var from = $("#from").val();
                var to = $("#to").val();
                var createdBy = $("#createdBy").val();
                var campaignId=$("#campaignId").val();
                if (from === null || from === "") {
                    alert("من فضلك أدخل تاريخ البداية");
                } else if (to === null || to === "") {
                    alert("من فضلك أدخل تاريخ النهاية");
                } else if (createdBy === null || createdBy === "") {
                    alert("من فضلك أختر المصدر");
                } else {
                    document.COMP_FORM.action = "<%=context%>/AppointmentServlet?op=getLastAppointmentWithClient&createdBy=" + createdBy + "&from=" + from + "&to=" + to+"&campaignId="+ campaignId;
                    document.COMP_FORM.submit();
                }
            }
            
            function popupFollowUp2(clientName, clientId) {
                $("#appTitleMsg").css("color", "");
                $("#appTitleMsg").text("");
                $("#appTitle").val("");

                $("#appNote").val("");
                $("#appMsgDialog").hide();
                $(".submenu1").hide();
                $("#appClientName").html(clientName);
                //new hidden input
                $("#clientId").val(clientId);
                $(".button_pointment").attr('id', '0');
                $('#follow_up_content').css("display", "block");

                $('#follow_up_content').bPopup({easing: 'easeInOutSine', //uses jQuery easing plugin
                    speed: 400,
                    transition: 'slideDown'});
            }
            
            function popupFollowUp(clientID) {
                sec = -1;
                $("#appTitleMsg").css("color", "");
                $("#appTitleMsg").text("");
                $("#appTitle").val("");
                
                $("#clientId").val(clientID);

                $("#appNote").val("");
                $("#appMsg").hide();
                $(".submenu1").hide();
                $("#appClientName").text($("#hideName").val());
                $(".button_pointment").attr('id', '0');
                $('#follow_up_content').css("display", "block");

                $('#follow_up_content').bPopup({easing: 'easeInOutSine', //uses jQuery easing plugin
                    speed: 400,
                    transition: 'slideDown'});
            }

            function switchValue(id) {
                if (id === 'callResultMetting') {
                    $("#meetingDateDiv").css("display", "block");
                    $("#appCallResult").css("display", "none");
                } else if (id === 'callResultPhone') {
                    $("#meetingDateDiv").css("display", "none");
                    $("#appCallResult").css("display", "block");
                } else {
                    $("#meetingDateDiv").css("display", "none");
                    $("#appCallResult").css("display", "none");
                }
            }

            function saveFollowUp2() {
                
                $("#appTitleMsg").css("color", "");
                $("#appTitleMsg").text("");

                var clientId = $("#clientId").val();
                var title = '';
                if ($("#appTitleDialog").val() !== null) {
                    title = $("#appTitleDialog").val();
                }

                var clientId = $("#clientId").val();
                var title = '';
                if ($("#appTitleDialog").val() !== null) {
                    title = $("#appTitleDialog").val();
                }
                var nextAction = $("input[name=nextAction]:checked").val();
                var callResult = $("#callResult:checked").val();
                var resultValue = "";
                var appCallResult = $("#appCallResult").val();
                console.log($("#meetingDateDialog").val());
                var meetingDateDialog = $("#meetingDateDialog").val();
                var note = '<%=CRMConstants.CALL_RESULT_FOLLOWUP.toUpperCase()%>';
                 var privacy=$('input[name=privacy]:checked').val();
                 var callDuration = $("#callDuration").val();
                 if (nextAction === '<%=CRMConstants.CALL_RESULT_MEETING%>') {
                    resultValue = meetingDateDialog;
                     note = "meeting";
                } else if (nextAction === '<%=CRMConstants.CALL_RESULT_NO_ACTION%>') {
                    resultValue = appCallResult;
                    note = "No Action";
                }
                else 
                {
                    resultValue = appCallResult;
                     note = $("#appCallResult option:selected").text();
                }
                if (callResult === '<%=CRMConstants.CALL_RESULT_CALL%>') {
                    resultValue = appCallResult;
                } else if (callResult === '<%=CRMConstants.CALL_RESULT_MEETING%>') {
                    resultValue = meetingDateDialog;
                }

                var appType = '<%=CRMConstants.CALL_RESULT_FOLLOWUP%>';
                if(note == "Not Interested" ||  note == "No Answer")
                {
                    appType=callResult;
                }
                
                var appointmentPlace = $("#appointmentPlace").val();
                var commentDialog = $("#commentDialog").val();
                

                 if (title.length > 0) {
                    $("#progress").show();
                    $.ajax({
                        type: "post",
                        url: "<%=context%>/ClientServlet?op=saveFollowUpAppointment",
                        data: {
                            clientId: clientId,
                            title: title,
                            callResult: callResult,
                            resultValue: resultValue,
                            note: note,
                            appType: callResult,
                            appointmentPlace: appointmentPlace,
                            commentDialog: commentDialog,
                            privacy : privacy,
                            callDuration: callDuration,
                            callresultdate : $("#calldate").val(),
                             nextAction: nextAction
                        },
                        success: function (jsonString) {
                            var eqpEmpInfo = $.parseJSON(jsonString);
                            if (eqpEmpInfo.status == 'ok') {
                                $("#progress").hide();
                                $('#follow_up_content').css("display", "none");
                                $('#follow_up_content').bPopup().close();
                            } else if (eqpEmpInfo.status == 'no') {
                                $("#progress").show();
                                $("#appMsgDialog").html("لم يتم التسجيل او هذا العميل غير موزع").show();
                            }
                            $("#commentDialog:").val("");
     //$("#callResult").val("<%=CRMConstants.CALL_RESULT_MEETING%>");
     $('#callResult option["مقابلة"]').attr("checked", true);
                        }
                    });
                } else {
                    $("#appTitleMsg").css("color", "white");
                    $("#appTitleMsg").text("أدخل عنوان المقابلة");
                }
            }
            
            function callResultsChng() {
                var callResult = $("#callResult option:selected").val();
                if (callResult == "meeting") {
                    $("#callStatusTd").css("display", "none");
                    $("#callStatus").css("display", "none"); //callStatus                
                } else if (callResult == "inboundcall") {
                    $("#callStatusTd").css("display", "block");
                    $("#callStatus").css("display", "block");
                } else if (callResult == "outbouncall") {
                    $("#callStatusTd").css("display", "block");
                    $("#callStatus").css("display", "block");
                } else if (callResult == "internet") {
                    $("#callStatusTd").css("display", "block");
                    $("#callStatus").css("display", "block");
                } else {
                    $("#callStatusTd").css("display", "block");
                    $("#callStatus").css("display", "block");
                }
            }
            
            function callResultsChange() {
                var selectedValue = $("#nextAction option:selected").val();
                if (selectedValue == "Follow" || selectedValue == "Visit" || selectedValue == "Waiting")
                {
                    $("#meetresaultlbl").css("display", "block");
                    $("#meetingDateTD").css("display", "block");
                }
                else
                {
                    $("#meetresaultlbl").css("display", "none");
                    $("#meetingDateTD").css("display", "none");
                }

                if (selectedValue == "Visit")
                {
                    $("#appointmentPlacelbl").css("display", "block");
                    $("#appointmentPlaceDDL").css("display", "block");
                } else {
                    $("#appointmentPlacelbl").css("display", "none");
                    $("#appointmentPlaceDDL").css("display", "none");
                }
            }
            
            function callStatusChange() {
                var selectedValue = $("#callStatus option:selected").val();

                if (selectedValue == "answered")
                {
                    $("#callResultTD").css("display", "block");
                    $("#nextAction").css("display", "block");
                }
                else
                {
                    $("#callResultTD").css("display", "none");
                    $("#nextAction").css("display", "none");

                    $("#meetresaultlbl").css("display", "none");
                    $("#meetingDateTD").css("display", "none");

                    $("#appointmentPlacelbl").css("display", "none");
                    $("#appointmentPlaceDDL").css("display", "none");
                }
            }
            
            function saveFollowUp(obj) {
                $("#appTitleMsg").css("color", "");
                $("#appTitleMsg").text("");

                var clientId = $("#clientId").val();
                var title = '';
                if ($(obj).parent().parent().parent().find($("#appTitle")).val() !== null) {
                    title = $(obj).parent().parent().parent().find($("#appTitle")).val();
                }else{
                    title = "Follow up";
                }
                var callResult = $("#callResult").val();
                var nextAction = $("#nextAction").val();
                var resultValue = "";
                var appCallResult = $(obj).parent().parent().parent().find($("#nextAction")).val();
                var meetingDate = $(obj).parent().parent().parent().find($("#meetingDate")).val();
                var note = '<%=CRMConstants.CALL_RESULT_FOLLOWUP.toUpperCase()%>';
                var privacy = $('input[name=privacy]:checked').val();
                var callDuration = $(obj).parent().parent().parent().find($("#callDuration")).val();
                var callStatus = $("#callStatus").val();
                var meetingDate = $("#meetingDate").val();
                var timer = $("#timer").html();

                if (nextAction === '<%=CRMConstants.CALL_RESULT_MEETING%>') {
                    resultValue = meetingDate;
                } else if (nextAction === '<%=CRMConstants.CALL_RESULT_NO_ACTION%>') {
                    resultValue = appCallResult;
                    note = "No Action";
                }
                else /*if (callResult === '<%=CRMConstants.CALL_RESULT_CALL%>')*/
                {
                    resultValue = appCallResult;
                    note = $("#nextAction option:selected").text();
                }

                var appType = '<%=CRMConstants.CALL_RESULT_FOLLOWUP%>';
                /*if (note == "Not Interested" || note == "No Answer")
                 {*/
                appType = callResult;
                //}

                var appointmentPlace = $(obj).parent().parent().parent().find("#appointmentPlace").val();
                var comment = $("#commentFlwUp").val();

                if (comment == "") {
                    $("#commentFlwUp").val = "لايوجد";
                    comment = "لايوجد";
                }

                if (callResult == "meeting") {
                    callStatus = "attended";
                }

                if (title.length > 0) {
                    $(obj).parent().parent().parent().parent().find("#progress").show();

                    $.ajax({
                        type: "post",
                        url: "<%=context%>/ClientServlet?op=saveFollowUpAppointment",
                        data: {
                            clientId: clientId,
                            title: title,
                            callResult: callResult,
                            nextAction: nextAction,
                            resultValue: resultValue,
                            note: note,
                            appType: callResult,
                            appointmentPlace: appointmentPlace,
                            comment: comment,
                            privacy: privacy,
                            callDuration: callDuration,
                            callresultdate: $("#calldate").val(),
                            callStatus: callStatus,
                            meetingDate: meetingDate,
                            timer: timer
                        },
                        success: function (jsonString) {
                            var eqpEmpInfo = $.parseJSON(jsonString);
                            if (eqpEmpInfo.status == 'ok') {
//                                $(obj).parent().parent().parent().parent().find("#appMsg").html("تم التسجيل بنجاح").show();
                                $(obj).parent().parent().parent().parent().find("#progress").hide();
                                $('#follow_up_content').css("display", "none");
                                $('#follow_up_content').bPopup().close();
                            } else if (eqpEmpInfo.status == 'no') {
                                $(obj).parent().parent().parent().parent().find("#progress").show();
                                $(obj).parent().parent().parent().parent().find("#appMsg").html("لم يتم التسجيل او هذا العميل غير موزع").show();
                            }
                            resetfollowup();

                        }
                    });
                } else {
                    $("#appTitleMsg").css("color", "white");
                    $("#appTitleMsg").text("أدخل عنوان المقابلة");
                }
            }
            
            function  resetfollowup()
            {
                $("#comment").val("");
                //$("#callResult").val("<%=CRMConstants.CALL_RESULT_MEETING%>");
                $('#callResult option["مقابلة"]').attr("checked", true);

            }
            
            function closePopup(obj) {
                $(obj).parent().parent().bPopup().close();
            }

            function openCommentDailog(clientId) {
                var divTag = $("#commentDailog");
                divTag.dialog({
                    modal: true,
                    title: 'التعليق',
                    show: "blind",
                    hide: "explode",
                    width: 500,
                    position: {
                        my: 'center',
                        at: 'center'
                    },
                    buttons: {
                        Cancel: function () {
                            $(this).dialog('close');
                        },
                        Save: function () {
                            saveComment(clientId);
                        }
                    }

                }).dialog('open');
            }

            function saveComment(clientId) {
                loadingComment("block");
                var comment = $("#comment").val();
                var type = 0;
                var businessObjectType = 1;
                if (comment.length > 0) {
                    $.ajax({
                        type: "post",
                        url: "<%=context%>/CommentsServlet?op=saveComment",
                        data: {
                            clientId: clientId,
                            type: type,
                            comment: comment,
                            businessObjectType: businessObjectType
                        }
                        ,
                        success: function (jsonString) {
                            var eqpEmpInfo = $.parseJSON(jsonString);
                            if (eqpEmpInfo.status === 'ok') {
                                $("#commentMsg").css("color", "green");
                                $("#commentMsg").text(" تمت الأضافة بنجاح");
                                $('#commentMsg').fadeIn("fast", function () {
                                    $('#commentMsg').css("display", "block");
                                });
                                $('#commentMsg').fadeOut(3000, function () {
                                    $('#commentMsg').css("display", "none");
                                });
                                window.location.href = window.location.href;
                            } else if (eqpEmpInfo.status === 'no') {
                                alert("لم تتم الأضافة")
                            }
                        }
                    });
                } else {
                    $('#commentMsg').css("display", "block");
                    $("#commentMsg").css("color", "red");
                    $("#commentMsg").text("أدخل التعليق");
                }
                loadingComment("none");
            }

            function loading(val) {
                if (val === "none") {
                    $('#loading').fadeOut(2000, function () {
                        $('#loading').css("display", val);
                    });
                } else {
                    $('#loading').fadeIn("fast", function () {
                        $('#loading').css("display", val);
                    });
                }
            }

            function loadingComment(val) {
                if (val === "none") {
                    $('#loadingComment').fadeOut(2000, function () {
                        $('#loadingComment').css("display", val);
                    });
                } else {
                    $('#loadingComment').fadeIn("fast", function () {
                        $('#loadingComment').css("display", val);
                    });
                }
            }
            function exportToExcel() {
                var createdBy = $("#createdBy").val();
                var to = $("#to").val();
                var from = $("#from").val();
                var departmentID = $("#departmentID").val();
                var campaignId=$("#campaignId").val();
                var clientRate = $("#clientRate").val();
                var departmentDisp = $("#departmentID option:selected").text()
                var campaignDisp=$("#campaignId option:selected").text();
                var clientRateDisp = $("#clientRate option:selected").text();
                var url = "<%=context%>/AppointmentServlet?op=getLastAppointmentWithClientExel&createdBy=" + createdBy + "&to=" + to + "&from=" + from + "&departmentID=" + departmentID + "&clientRate=" + clientRate+"&campaignId="+campaignId
                +"&departmentDisp="+departmentDisp+"&campaignDisp="+campaignDisp+"&clientRateDisp="+clientRateDisp;
                window.open(url, "_blank", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width=500, height=500");
            }
            var sec = -1;
            function pad(val) { return val > 9 ? val : "0" + val; }
            setInterval(function () {
                $("#timer").html(pad(parseInt(sec / 3600, 10)) + ":" + pad(parseInt(sec / 60, 10) % 60) + ":" + pad(++sec % 60));
            }, 1000);
            function showFirstAppointment(obj, clientID) {
                $.ajax({
                    type: "post",
                    url: "<%=context%>/AppointmentServlet?op=getFirstAppointmentAjax",
                    data: {
                        clientID: clientID
                    },
                    success: function (jsonString) {
                        var info = $.parseJSON(jsonString);
                        $(obj).tooltip({
                            content: function () {
                                return "<table class='appointment_table' border='0' dir='<%=dir%>'><tr><td class='appointment_header' colspan='2'>أول متابعة</td></tr>\n\
                                <tr><td class='appointment_title'>المتابع</td><td class='appointment_data'>"+info.appointmentBy+"</td></tr>\n\
                                <tr><td class='appointment_title' nowrap>تاريخ المتابعة</td><td class='appointment_data'>"+info.appointmentDate+"</td></tr>\n\
                                <tr><td class='appointment_title' nowrap>نوع المتابعة</td><td class='appointment_data'>"+info.appointmentType+"</td></tr>\n\
                                <tr><td class='appointment_title'>التعليق</td><td class='appointment_data'>"+info.comment+"</td></tr>\n\
                                </table>";
                            }
                        });
                    }
                });
            }
            function showRedirectTask(issueId,name,phone) {
                $("#issueId").val(issueId);
                $("#clientNamePopup").html("<font color='white' size='3'> اسم العميل/ المحمول</font> : <font size='3'>" +name+" /"+phone+"</font>");
                $('#redirectClient').show();
                $('#redirectClient').bPopup({easing: 'easeInOutSine', //uses jQuery easing plugin
                    speed: 400,
                    transition: 'slideDown'});
            }
            function deleteRedirectTask() {
                if($("#requestType").val() === '') {
                    alert("You must select a request type to create new request");
                    return;
                }
                if($("#employeeID").val() === '') {
                    alert("You must select an employee to distrubite new request to it");
                    return;
                }
                var r = confirm("Are You Sure You want to redistribute this client !.","Confirm");
                if (r === true)                {
                    
                    
                    $.ajax({
                         type: "post",
                        url:  "<%=context%>/DatabaseControllerServlet?op=dragFromAppointment",
                        data: {
                            employeeID:$("#employeeID").val(),
                            requestType:$("#requestType").val(),
                            issueId:$("#issueId").val()
                        },success:function(jsonString){
                            //location.reload();
                            var info=$.parseJSON(jsonString);
                            
                            if (info.status==='ok'){
                                $("#tableResult").show();
                                $("#dragResult").html("<font size='3' color='blue'>تم السحب بنجاح</font>");
                            }else{
                                $("#tableResult").show();
                                $("#dragResult").html("<font size='3' color='red'>لم يتم السحب</font>");
                            
                            }
                           $("#redirectClient").bPopup().close();
                        }
                       
                    });
                    
                }
            }
        </script>

        <style type="text/css">
            .confirmed {
                background-color: #EBB462;
                color: black;
                font-size: 14px;
                font-weight: bold;
                -ms-filter: "progid:DXImageTransform.Microsoft.Shadow(Strength=2, Direction=135, Color='#999999')";
                filter: progid:DXImageTransform.Microsoft.Shadow(Strength=2,Direction=135,Color='#999999');
                -webkit-border-radius: 6px 6px 6px 6px;
                -moz-border-radius: 6px 6px 6px 6px;
            }
            .titlebar {
                height: 30px;
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
            #row:hover{
                cursor: pointer;
                background-color: #D3E3EB !important;
            }
            .container {width: 100px; margin: 0 auto; overflow: hidden;}
            .contentBar {width:100px; margin:0 auto; padding-top:0px; padding-bottom:0px;}
            .barlittle {
                background-color:#2187e7;  
                background-image: -moz-linear-gradient(45deg, #2187e7 25%, #a0eaff); 
                background-image: -webkit-linear-gradient(45deg, #2187e7 25%, #a0eaff);
                border-left:1px solid #111; border-top:1px solid #111; border-right:1px solid #333; border-bottom:1px solid #333; 
                width:10px;
                height:10px;
                float:left;
                margin-left:5px;
                opacity:0.1;
                -moz-transform:scale(0.7);
                -webkit-transform:scale(0.7);
                -moz-animation:move 1s infinite linear;
                -webkit-animation:move 1s infinite linear;
            }
            #block_1{
                -moz-animation-delay: .4s;
                -webkit-animation-delay: .4s;
            }
            #block_2{
                -moz-animation-delay: .3s;
                -webkit-animation-delay: .3s;
            }
            #block_3{
                -moz-animation-delay: .2s;
                -webkit-animation-delay: .2s;
            }
            #block_4{
                -moz-animation-delay: .3s;
                -webkit-animation-delay: .3s;
            }
            #block_5{
                -moz-animation-delay: .4s;
                -webkit-animation-delay: .4s;
            }
            @-moz-keyframes move{
                0%{-moz-transform: scale(1.2);opacity:1;}
                100%{-moz-transform: scale(0.7);opacity:0.1;}
            }
            @-webkit-keyframes move{
                0%{-webkit-transform: scale(1.2);opacity:1;}
                100%{-webkit-transform: scale(0.7);opacity:0.1;}
            }
            
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
             .table label {float: right;}
             .table td {border: none; padding-bottom: 10px;}
             
             #hideANDseek{ display: none;}          
            .appointment_table {
                padding: 10px 20px;
                color: white;
                border-radius: 20px;
                font: bold 16px "Helvetica Neue", Sans-Serif;
                box-shadow: 0 0 7px black;
            }
            .appointment_header {
                background-color: #d18080;
                padding: 5px;
            }
            .appointment_title {
                background-color: #abc0e5;
                padding: 5px;
            }
            .appointment_data {
                background-color: white;
                padding: 5px;
            }
            .ddlabel {
                padding-right: 10px;
            }
            .fnone {
                margin-right: 5px;
            }
            .ddChild, .ddTitle {
                text-align: right;
            }
        </style>
    </head>
    <body>
        <form name="COMP_FORM" method="post">
            <table align="center" width="98%">
                <tr>
                    <td class="td">
                        <FIELDSET class="set" style="width:98%;border-color: #006699">
                            <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                                <tr>
                                    <td class="titlebar" style="text-align: center">
                                        <font color="#005599" size="4"><%=title%></font>
                                    </td>
                                </tr>
                            </table>
                            <br/>
                            <table align="center" dir="rtl" width="99%" cellspacing="2" cellpadding="1">
                                <tr>
                                    <td class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="30%">
                                        <b><font size=3 color="white"> <%=beginDate%></b>
                                    </td>
                                    <td class="blueBorder blueHeaderTD" style="font-size:18px;"WIDTH="30%">
                                        <b> <font size=3 color="white"> <%=endDate%> </b>
                                    </td>
                                    <td class="blueBorder blueHeaderTD" style="font-size:18px;"WIDTH="20%">
                                        <b> <font size=3 color="white"> <%=dep%> </b>
                                    </td>
                                    <td class="blueBorder blueHeaderTD" style="font-size:18px;"WIDTH="20%">
                                        <b> <font size=3 color="white"> <%=campaign%> </b>
                                    </td>
                                    <td class="blueBorder blueHeaderTD" style="font-size:18px;"WIDTH="20%" id="hideANDseek">
                                        <b> <font size=3 color="white"> <%=source%> </b>
                                    </td>
                                    <td class="blueBorder blueHeaderTD" style="font-size:18px;"WIDTH="20%">
                                        <b> <font size=3 color="white"> <%=classification%> </b>
                                    </td>
                                    <td style="text-align:center; margin-bottom: 5px; margin-top: 5px" bgcolor="#dedede" rowspan="2">
                                        <button type="button" onclick="JavaScript: getComplaints();" style="color: #27272A;font-size:15px;margin-top: 8px;margin-bottom: 8px;font-weight:bold; width: 150px">بحث<IMG HEIGHT="15" SRC="images/search.gif" ></button>  
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align:center" bgcolor="#dedede"  valign="MIDDLE" >
                                        <input title="<%=clientEntryDate%>"  id="from" readonly name="from" type="text" value="<%=from%>" style="width: 180px; cursor: hand" />                 
                                        <br><br>
                                    </td>
                                    <td  bgcolor="#dedede"  style="text-align:center" valign="middle">
                                        <input title="<%=clientEntryDate%>" id="to" readonly name="to" type="text" value="<%=to%>" style="width: 180px; cursor: hand" />
                                        <br><br>
                                    </td>
                                    <td style="text-align:center" bgcolor="#dedede"  valign="MIDDLE" >
                                        <select id="departmentID" name="departmentID" style="font-size: 14px; width: 200px">
                                    <sw:WBOOptionList wboList="<%=departments%>" displayAttribute="projectName" valueAttribute="projectID" scrollToValue="<%=departmentID%>" />
                                </select>
                                    </td>
                                    <td style="text-align:center" bgcolor="#dedede"  valign="MIDDLE">
                                        <select id="campaignId" name="campaignId" style="font-size: 14px;font-weight: bold; width: 180px;" >
                                            <option value="">All</option>
                                            <sw:WBOOptionList wboList='<%=campaignList%>' valueAttribute="id" displayAttribute="campaignTitle" scrollToValue="<%=campaignId%>" />
                                        </select>
                                    </td>
                                    <td style="text-align:center" bgcolor="#dedede"  valign="MIDDLE" id="hideANDseek">
                                        <select id="createdBy" name="createdBy" style="font-size: 14px;font-weight: bold; width: 180px;" >
                                            <option value="-">الكل</option>
                                            <sw:WBOOptionList wboList='<%=users%>' displayAttribute="fullName" valueAttribute="userId" scrollToValue="<%=createdBy%>"/>
                                        </select>
                                    </td>
                                    <td style="text-align:center" bgcolor="#dedede"  valign="MIDDLE">
                                        <select class="clientRate" name="clientRate" id="clientRate" style="width: 200px; direction: rtl;">
                                            <option value="">All</option>
                                            <option value="1" <%="1".equals(request.getAttribute("clientRate")) ? "selected" : ""%>>UnRated</option>
                                            <%
                                                for (WebBusinessObject rateWbo : ratesList) {
                                            %>
                                            <option value="<%=rateWbo.getAttribute("projectID")%>" <%=rateWbo.getAttribute("projectID").equals(request.getAttribute("clientRate")) ? "selected" : ""%>  data-image="images/msdropdown/<%="UL".equals(rateWbo.getAttribute("optionThree")) ? "black" : rateWbo.getAttribute("optionThree")%>.png"><%=rateWbo.getAttribute("projectName")%></option>
                                            <%
                                                }
                                            %>
                                        </select>
                                    </td>
                                </tr>
                            </table>
                            <br/>
                             <br>
                             <table id="tableResult" align="center" dir="<%=dir%>" WIDTH="70%" style="display:none;">
                            <tr>
                                <td id="dragResult" class="backgroundHeader">
                                    
                                     </td>
                            </tr>
                        </table>
                            <% if (data != null) {%>
                            <center>
                                <button type="button" STYLE="display: <%=userPrevList.contains("EXCEL") ? "" : "none"%>; color: #27272A;font-size:15;margin-top: 20px;font-weight:bold;"
                                        onclick="exportToExcel()" title="Export to Excel">Excel<IMG HEIGHT="15" SRC="images/search.gif" />
                                </button>
                                <br/>
                                <br/>
                                <div style="width: 99%">
                                    <table class="display" id="requests" align="center" DIR="<%=dir%>" WIDTH="100%" CELLPADDING="0" cellspacing="0">
                                        <thead>
                                            <tr>
                                                <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "14px" : "16px"%>; font-weight: bold" width="5%">رقم العميل</TH>  
                                                <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "14px" : "16px"%>; font-weight: bold" width="7%"><b>اسم العميل</b></TH>
                                                <%--<TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "14px" : "16px"%>; font-weight: bold" width="4%"></TH>
                                                <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "14px" : "16px"%>; font-weight: bold" width="5%"><b>التليفون</b></TH>--%>
                                                <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "14px" : "16px"%>; font-weight: bold" width="5%"><b>المحمول</b></TH>
                                                <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "14px" : "16px"%>; font-weight: bold" width="8%"><b>الرقم الدولى</b></TH>
                                                <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "14px" : "16px"%>; font-weight: bold" width="8%"><b>التصنيف</b></TH>
                                                <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "14px" : "16px"%>; font-weight: bold" width="8%"><b><%=campaign%></b></TH>
                                                <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "14px" : "16px"%>; font-weight: bold" width="10%"><b>اخر متابع</b></TH>
                                                <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "14px" : "16px"%>; font-weight: bold" width="10%"><b> تاريخ دخول العميل</b></TH>
                                                <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "14px" : "16px"%>; font-weight: bold" width="12%"><b>تاريخ أخر متابعة</b></TH>
                                                <%--<TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "14px" : "16px"%>; font-weight: bold" width="10%"><b>نوع المتابعة</b></TH>
                                                <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "14px" : "16px"%>; font-weight: bold" width="5%"><b> المدة </b></TH>%>
                                                <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "14px" : "16px"%>; font-weight: bold" width="26%"><b>نتيجة اول المتابعة</b></TH--%>
                                                <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "14px" : "16px"%>; font-weight: bold" width="26%"><b>نتيجة أخر متابعة</b></TH>
                                                 <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "14px" : "16px"%>; font-weight: bold" width="26%"><b> اعادة التوزيع </b></TH>
                                            </tr> 
                                        </thead> 
                                        <tbody>
                                            <%
                                                WebBusinessObject formatted;
                                                WebBusinessObject formatted2;
                                                String customerName, lastCommenter, phone, mobile, interPhone, description, note, appointmentDate, appointmentType, appointmentResult, callDuration, FappointmentResult, rateName;
                                                for (WebBusinessObject wbo : data) {
                                                    formatted = DateAndTimeControl.getFormattedDateTime((String) wbo.getAttribute("creationTime"), stat);
                                                    formatted2 = DateAndTimeControl.getFormattedDateTime((String) wbo.getAttribute("clientCreationTime"), stat);
                                                    phone = (wbo.getAttribute("phone") != null && !wbo.getAttribute("phone").toString().equalsIgnoreCase("UL")) ? (String) wbo.getAttribute("phone") : "";
                                                    mobile = (wbo.getAttribute("mobile") != null && !wbo.getAttribute("mobile").toString().equalsIgnoreCase("UL")) ? (String) wbo.getAttribute("mobile") : "";
                                                    interPhone = (wbo.getAttribute("interPhone") != null && !wbo.getAttribute("interPhone").toString().equalsIgnoreCase("UL")) ? (String) wbo.getAttribute("interPhone") : "";
                                                    description = (wbo.getAttribute("description") != null && !wbo.getAttribute("description").toString().equalsIgnoreCase("UL")) ? (String) wbo.getAttribute("description") : "";
                                                    note = (wbo.getAttribute("note") != null && !wbo.getAttribute("note").toString().equalsIgnoreCase("UL")) ? (String) wbo.getAttribute("note") : "لا يوجد";
                                                    appointmentType = (wbo.getAttribute("option2") != null && !wbo.getAttribute("option2").toString().equalsIgnoreCase("UL")) ? (String) wbo.getAttribute("option2") : "لا يوجد";
//                                                    FappointmentResult = (wbo.getAttribute("FCom") != null && !wbo.getAttribute("FCom").toString().equalsIgnoreCase("UL")) ? (String) wbo.getAttribute("FCom") : "لا يوجد";
                                                    appointmentResult = (wbo.getAttribute("comment") != null && !wbo.getAttribute("comment").toString().equalsIgnoreCase("UL")) ? (String) wbo.getAttribute("comment") : "لا يوجد";
                                                    appointmentDate = wbo.getAttribute("appointmentDate") != null ? (String) wbo.getAttribute("appointmentDate") : "";
                                                    callDuration = wbo.getAttribute("callDuration") != null ? (String) wbo.getAttribute("callDuration") : "";
                                                    rateName = wbo.getAttribute("rateName") != null ? (String) wbo.getAttribute("rateName") : "";
                                                    
                                                    if(appointmentDate.length() > 10) {
                                                        appointmentDate = appointmentDate.substring(0, appointmentDate.indexOf(" "));
                                                    }
                                                    switch (note) {
                                                        case "INSTANCE-FOLLOW-UP":
                                                            note = "متابعة مباشرة";
                                                            break;
                                                        case "meeting":
                                                            note = "تحديد مقابلة بتاريخ " + appointmentDate;
                                                            break;
                                                    }
                                                    customerName = Tools.checkLength((String) wbo.getAttribute("name"), 25);
                                                    lastCommenter = Tools.checkLength((String) wbo.getAttribute("createdByName"), 15);
                                            %>
                                            <tr id="row">
                                                <td width="5%">
                                                    <b><%=wbo.getAttribute("clientNO")%></b>
                                                    <%if (newTap.equalsIgnoreCase("true")){%>
                                                        <a href="#" onclick="JavaScript: openInNewWindow('<%=context%>/ClientServlet?op=clientDetails&clientId=<%=wbo.getAttribute("id")%>');">
                                                            <img src="images/client_details.jpg" width="30" style="float: left;" title="تفاصيل"/>
                                                        </a>
                                                    <%} else {%>
                                                        <a target="details" href="<%=context%>/ClientServlet?op=clientDetails&clientId=<%=wbo.getAttribute("id")%>">
                                                            <img src="images/client_details.jpg" width="30" style="float: left;" title="تفاصيل"/>
                                                        </a>
                                                    <%}%>
                                                </td>
                                                <td width="10%"><b title="<%=description%>"><%=customerName%></b></td>   
                                                <%--<td width="4%">
                                                    <img src="images/comment_no.png" title="أضافة تعليق" onclick="JavaScript: openCommentDailog('<%=wbo.getAttribute("id")%>');" height="25" style="cursor: hand;"/>
                                                </td>  
                                                <td width="5%"><b><%=phone%></b></td>  --%>  
                                                <td width="5%"><b><%=mobile%></b></td>
                                                <td width="8%"><b><%=interPhone%></b></td>     
                                                <td width="8%"><b><%=rateName%></b></td>     
                                                <td width="8%"><b><%=wbo.getAttribute("campaignTitle")%></b></td>     
                                                <td width="10%"><b><%=lastCommenter%></b></td> 
                                                <td width="12%"><font color="red"><%=formatted2.getAttribute("day")%> - </font><b><%=formatted2.getAttribute("time")%></b></td>
                                                <td width="12%"><font color="red"><%=formatted.getAttribute("day")%> - </font><b><%=formatted.getAttribute("time")%></b></td>
                                                <%--<td width="10%"><b><%=appointmentType%></b></td>  
                                                <td width="5%"><b><%=callDuration%> Min</b></td> %>
                                                <td width="26%" class="confirmed"><b><%=FappointmentResult%></b></td--%>  
                                                <td width="26%" class="" <%--onmouseover="JavaScript: showFirstAppointment(this, '<%=wbo.getAttribute("id")%>');" title="<%=appointmentResult%>"--%>><b><%=appointmentResult%></b></td>  
                                                <!--<td class="confirmed"><b><%=note%></b></td>-->
                                                <td width="26%">
                                                    <%
                                                        IssueByComplaintUniqueMgr issueByComplaintUniqueMgr = IssueByComplaintUniqueMgr.getInstance();

                                                        ArrayList<WebBusinessObject> list = new ArrayList<>(issueByComplaintUniqueMgr.getOnArbitraryKeyOracle(wbo.getAttribute("id").toString(), "key2"));
                                                        if(!list.isEmpty() && list!=null){
                                                        String busId = list.get(0).getAttribute("businessID").toString();
                                                        IssueMgr issueMgr = IssueMgr.getInstance();
                                                        String IssueID = issueMgr.getClearErrorTasksByBusiness(busId).get(0).getAttribute("id").toString();
                                                    %>
                                                    
                                                    <a href="JavaScript: showRedirectTask('<%=IssueID%>','<%=customerName%>','<%=mobile%>');"><img width="35%" src="images/icons/refresh3.png"/></a>
                                                    <%}else{%>
                                                    <font color="black"> لا يوجد طلبات</font>
                                                    <%}%>
                                                </td>
                                            </tr>
                                            <% } %>
                                        </tbody>
                                    </table>
                                </div>
                            </center>
                            <br/>
                            <br/>
                            <% }%>
                        </fieldset>
                    </td>
                </tr>
            </table>
                        <div id="redirectClient" style="width: 40% ;margin-right: auto ;margin-left: auto;display: none;position: fixed;top: 500px;">
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
                        <td colspan="2" dir="rtl">
                            <div style="text-align: center;color: #06066d;font-weight: bold;" id='clientNamePopup'></DIV></td>
                    </tr>
                    <tr>
                        <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 30%;">نوع الطلب</td>
                        <td style="width: 70%;">
                            <select name="requestType" id="requestType" style="width: 200px;">
                                <option value="">أختر</option>
                                <sw:WBOOptionList wboList="<%=requestTypes%>" displayAttribute="projectName" valueAttribute="projectName" />
                            </select>
                        </td>
                    </tr> 
                    <tr>
                        <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 30%;">الموظف</td>
                        <td style="width: 70%;">
                            <select name="employeeID" id="employeeID" style="width: 200px;">
                                <option value="">أختر</option>
                                <sw:WBOOptionList wboList="<%=employees%>" displayAttribute="fullName" valueAttribute="userId" />
                            </select>
                            <input type="hidden" name="issueId" id="issueId" />
                            <input type="hidden" name="searchValue" id="searchValue"/>
                        </td>
                    </tr> 
                </table>
                <div style="text-align: center;margin-left: auto;margin-right: auto;clear: both" > <input type="submit" value="سحب وتوزيع" onclick="JavaScript: deleteRedirectTask();" id="redirectClient" class="login-submit"/></div>
            </div>
        </div>

                        
                        <div id="follow_up_content" style="width: 70% !important;display: none;position: fixed">
                                        <div style="clear: both;margin-left: 80%;margin-top: 0px;margin-bottom: -38px;z-index: -10000000;">
                                            <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                                                 -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                                                 box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                                                 -webkit-border-radius: 100px;
                                                 -moz-border-radius: 100px;
                                                 border-radius: 100px;" onclick="closePopup(this)"/>
                                        </div>
                                        <div class="login" style="width: 60%;margin-bottom: 10px;margin-left: auto;margin-right: auto;">
                                            <h1 align="center" style="vertical-align: middle">متابعة العميل <b id="appClientName" style="font-weight: bold; font-size: 20px"></b> &nbsp;&nbsp;&nbsp;<img src="images/dialogs/phone.png" alt="phone" width="24px"/></h1>
                                            <input type="hidden" id="clientId" name="clientId" value="" />
                                            <div style="text-align: left;margin-left: 2%;margin-right: auto;" > 
                                                <span id="timer" style="font-size: 30px; font-weight: bolder; color: black; padding-left: 20px;"></span>
                                                <button type="button" onclick="javascript: saveFollowUp(this);" style="font-size: 14px; font-weight: bold; width: 150px">حفظ<img style="height:20px; width: 20px" src="images/icons/follow_up.png" title="Follow up"/></button>
                                            </div>
                                            <br />
                                            <table class="table">
                                                <tr>
                                                    <td style="color: #f1f1f1; font-size: 16px; font-weight: bold; text-align: <%=xAlign%>;">الهدف : </td>
                                                    <td style="text-align:right">
                                                        <select id="appTitle" name="appTitle" STYLE="width: 225px;font-size: medium; font-weight: bold;">
                                                            <sw:WBOOptionList wboList='<%=meetings%>' displayAttribute = "projectName" valueAttribute="projectName" />
                                                        </select>
                                                    </td>
                                                </tr>

                                                <tr>
                                                    <td style="color: #f1f1f1; font-size: 16px; font-weight: bold; text-align: <%=xAlign%>;">نوع المتابعة : </td>
                                                    <td td style="text-align:right">
                                                        <select id="callResult" name="callResult" STYLE="width: 225px;font-size: medium; font-weight: bold;" onchange="JavaScript: callResultsChng()">
                                                            <option value="<%=CRMConstants.CALL_RESULT_MEETING%>">Meeting</option>
                                                            <option value="<%=CRMConstants.CALL_RESULT_INBOUNDCALL%>">In-Bound Call</option>
                                                            <option value="<%=CRMConstants.CALL_RESULT_OUTBOUNDCALL%>" selected>Out-Bound Call</option>
                                                            <option value="<%=CRMConstants.CALL_RESULT_INTERNET%>">Night Call</option>
                                                            <option value="<%=CRMConstants.CALL_RESULT_INTERNET%>">Internet</option>
                                                        </select>
                                                    </td>
                                                </tr>

                                                <tr>
                                                    <td id="callStatusTd" style="color: #f1f1f1; font-size: 16px; font-weight: bold; text-align: <%=xAlign%>;">حالة المتابعة : </td>
                                                    <td id="callStatusTd" style="text-align:right" >
                                                        <select id="callStatus" name="callStatus" STYLE="width: 225px;font-size: medium; font-weight: bold;" onchange="Javascript: callStatusChange();">
                                                            <option value="wrong number">wrong number</option>
                                                            <option value="not answered">not answered</option>
                                                            <option value="answered" selected>answered</option>
                                                        </select>
                                                    </td>
                                                </tr>

                                                <tr>
                                                    <td style="color: #f1f1f1; font-size: 16px; font-weight: bold; text-align: <%=xAlign%>;">المدة : </td>
                                                    <td style="text-align: right;">
                                                        <input type="number" name="callDuration" id="callDuration" value="1" min="1"
                                                               style="width: 80px;"/> دقيقة
                                                    </td>
                                                </tr>

                                                <tr>
                                                    <td id="callResultTD" style="color: #f1f1f1; font-size: 16px; font-weight: bold; text-align: <%=xAlign%>;">نتيجة المتابعة : </td>
                                                    <td td style="text-align:right;" id="callResultTD">
                                                        <select id="nextAction" name="nextAction" STYLE="width: 225px;font-size: medium; font-weight: bold;" onchange="JavaScript: callResultsChange()">
                                                            <option value="Follow">Follow</option>
                                                            <option value="Visit">Visit</option>
                                                            <option value="Waiting" selected>Waiting</option>
                                                            <option value="Don’t Call Me Any More" selected>Don’t Call Me Any More</option>
                                                            <option value="Done" selected>Done</option>
                                                            <option value="Not Interested" selected>Not Interested</option>
                                                            <option value="Not Serious" selected>Not Serious</option>
                                                            <option value="Not Suitable" selected>Not Suitable</option>
                                                            <option value="Pending" selected>Pending</option>
                                                            <option value="Transfer To international" selected>Transfer To international</option>
                                                            <option value="Transfer To Other Agent" selected>Transfer To Other Agent</option>
                                                            <option value="Transfer To Other Area" selected>Transfer To Other Area</option>
                                                        </select>
                                                    </td>
                                                </tr>

                                                <tr>
                                                    <td id="meetresaultlbl" style="color:#f1f1f1; font-size: 16px; font-weight: bold; text-align: <%=xAlign%>; display:none">وقت المقابلة:  </td>
                                                    <td>
                                                        <table>
                                                            <tr>
                                                                <td style="text-align:right; display: none" id="meetingDateTD"><input name="meetingDate" id="meetingDate" type="text"   maxlength="50" value="<%=nowTime%>"/></td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>

                                                <tr>
                                                    <td id="appointmentPlacelbl" style="color:#f1f1f1; font-size: 16px; font-weight: bold; text-align: <%=xAlign%>; display:none">الفرع : </td>
                                                    <td>
                                                        <table>
                                                            <tr>
                                                                <td id ="appointmentPlaceDDL" style="text-align:right; display:none">
                                                                    <select id="appointmentPlace" name="appointmentPlace" style="margin-top: 7px;width:200px;font-size: medium;">
                                                                        <sw:WBOOptionList wboList='<%=userProjects%>' displayAttribute = "projectName" valueAttribute="projectName" />
                                                                        <option value="Other">Other</option>
                                                                    </select>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>

                                                <tr>
                                                    <td style="color:#f1f1f1; font-size: 16px;font-weight: bold; text-align: <%=xAlign%>;">تعليق : <br/></td>
                                                    <td colspan="2" style="text-align:right">
                                                        <textarea cols="26" rows="10" id="commentFlwUp" style="width: 99%; background-color: #FFF7D6;">لايوجد</textarea>
                                                    </td>
                                                </tr>
                                            </table>

                                            <div style="text-align: left;margin-left: 2%;margin-right: auto;" > 
                                                <button type="button" onclick="javascript: saveFollowUp(this);" style="font-size: 14px; font-weight: bold; width: 150px">حفظ<img style="height:20px; width: 20px" src="images/icons/follow_up.png" title="Follow up"/></button>
                                            </div>
                                            <div id="progress" style="display: none;">
                                                <img src="images/Loading2.gif" width="32px" height="32px;" style="background-repeat: no-repeat;margin-left: auto;margin-right: auto"/>
                                            </div>
                                            <div style="margin: 0 auto;display: none; width: 90%;text-align: center;color: white;font-size: 16px;font-weight: bold" id="appMsg">تم إضافة المقابلة </div>
                                        </div>  
                                    </div>
                            <%--    
            <div id="addFollowUpContent" style="width: 95%;margin-bottom: 10px;margin-left: auto;margin-right: auto; display: none">
                <h1 align="center" style="vertical-align: middle">متابعة العميل <b id="appClientName" style="font-weight: bold; font-size: 20px; color: #005599"></b> &nbsp;&nbsp;&nbsp;<img src="images/dialogs/phone.png" alt="phone" width="24px"/></h1>
                <input type="hidden" id="clientId" name="clientId" value="" />
                <table class="table" dir="rtl" style="width:100%; border-width: 2px" bgcolor="#dedede" cellspacing="0" cellpadding="0">
                    <tr style="display: <%=!defaultCampaign.isEmpty() ? "" : "none"%>">
                        <td colspan="3" style="color: black; font-size: 16px;font-weight: bold; border-width: 0px; border-bottom-width: 2px">
                            <table align="center" width="100%" style="border-width: 0px">
                                <tr>
                                    <td style="text-align: left; font-size: 16px;font-weight: bold; border-width: 0px">
                                        <%=defaultCampaign%>
                                    </td>
                                    <td style="color: black; font-size: 16px;font-weight: bold; border-width: 0px">
                                        : 
                                    </td>
                                    <td style="text-align: right; color: black; font-size: 16px;font-weight: bold; border-width: 0px">
                                        Active Campaign  
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td style="color: black; font-size: 16px;font-weight: bold; border-width: 0px; border-bottom-width: 2px">الهدف : </td>
                        <td width="15%" style="text-align:right; border-width: 0px; border-bottom-width: 2px">
                            <select id="appTitle" name="appTitle" STYLE="width: 100%;font-size: 14px; font-weight: bold;">
                                <sw:WBOOptionList wboList='<%=meetings%>' displayAttribute = "projectName" valueAttribute="projectName" />
                            </select>
                        </td>
                        <td style="text-align:right; border-width: 0px; border-bottom-width: 2px">
                            <label id="appTitleMsg"></label>
                        </td>
                    </tr>
                    <tr>
                        <td width="10%" rowspan="3" style="color: black; font-size: 16px;font-weight: bold; border-width: 0px; border-bottom-width: 2px">النتيجة:  </td>
                        <td style="text-align:right; border-width: 0px; border-bottom-width: 2px">
                            <input type="radio" id="callResultMetting" name="callResult" value="<%=CRMConstants.CALL_RESULT_MEETING%>" checked onchange="JavaScript: switchValue(this.id);"/>
                            <label><img src="images/icons/meeting.png" alt="meeting" width="24px"/> مقابلة</label>
                        </td>
                        <td style="text-align:right; border-width: 0px; border-bottom-width: 2px">
                            <div id="meetingDateDiv">
                                <input name="meetingDate" id="meetingDate" readonly type="text" size="50" maxlength="50" style="width:40%;font-size: medium" value="<%=nowTime%>"/>
                                <img id="meetingDateIcon" src="images/icons/calendar-icon.png" alt="phone" width="16"/>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align:right; border-width: 0px; border-bottom-width: 2px" width="15%">
                            <input type="radio" id="callResultPhone" name="callResult" value="<%=CRMConstants.CALL_RESULT_CALL%>" onchange="JavaScript: switchValue(this.id);"/>
                            <label><img src="images/icons/call.png" alt="phone" width="24px"/>مكالمة </label>
                        </td>
                        <td style="text-align:right; border-width: 0px; border-bottom-width: 2px" width="75%">
                            <select id="appCallResult" name="appCallResult" STYLE="font-size: medium; font-weight: bold; width: 40%; display: none">
                                <sw:WBOOptionList wboList='<%=callResults%>' displayAttribute = "projectName" valueAttribute="projectID" />
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align:right; border-width: 0px; border-bottom-width: 2px" width="25%">
                            <input type="radio" id="callResultNotRespone" name="callResult" value="<%=CRMConstants.CALL_RESULT_FAIL%>" onchange="JavaScript: switchValue(this.id);" />
                            <label><img src="images/icons/call_failed.png" alt="phone" width="24px"/>لايوجد رد</label>
                        </td>
                        <td style="text-align:right; border-width: 0px; border-bottom-width: 2px">
                            &ensp;
                        </td>
                    </tr>
                    <tr>
                        <td style="color: black; font-size: 16px;font-weight: bold; border-width: 0px; border-bottom-width: 2px">الفرع : </td>
                        <td style="text-align:right; border-width: 0px; border-bottom-width: 2px">
                            <select id="appointmentPlace" name="appointmentPlace" style="margin-top: 7px;width:200px;font-size: medium;">
                                <sw:WBOOptionList wboList='<%=userProjects%>' displayAttribute = "projectName" valueAttribute="projectName" />
                                <option value="Other">Other</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td style="color: black; font-size: 16px;font-weight: bold; border-width: 0px; border-bottom-width: 2px">تعليق : </td>
                        <td colspan="2" style="text-align:right; border-width: 0px; border-bottom-width: 2px">
                            <textarea cols="26" rows="10" id="appointmentComment" style="width: 99%; background-color: #FFF7D6;"></textarea>
                        </td>
                    </tr>
                </table>
                <div id="loading" class="container" style="float: right; width: auto; margin-right: 4px; margin-bottom: 5px;; margin-top: 5px; display: none">
                    <div class="contentBar">
                        <div id="block_1" class="barlittle"></div>
                        <div id="block_2" class="barlittle"></div>
                        <div id="block_3" class="barlittle"></div>
                        <div id="block_4" class="barlittle"></div>
                        <div id="block_5" class="barlittle"></div>
                    </div>
                </div>
                <div style="float: left; width: 40%; margin-left: 4px; margin-bottom: 5px; text-align: left;color: black;font-size: 16px;font-weight: bold; color: green; display: none" id="appMsg">تم إضافة المقابلة </div>
            </div>--%>
            <div id="commentDailog" style="width: 40%;display: none;">
                <div class="login" style="width:100%;margin-left: auto;margin-right: auto;">
                    <TABLE class="backgroundTable" width="100%" CELLPADDING="0" CELLSPACING="8" ALIGN="RIGHT" DIR="rtl">
                        <tr>
                            <td style="width: 30%;" class="backgroundHeader"><font color="black" size="3">التعليق : </font></TD>
                            <td style="width: 70%;"><TEXTAREA cols="40" rows="5" name="comment" id="comment" style="width: 100%"></TEXTAREA></TD>
                        </TR>
                    </table>
                    <div id="loadingComment" class="container" style="float: right; width: auto; margin-right: 4px; margin-bottom: 5px;; margin-top: 5px; display: none">
                        <div class="contentBar">
                            <div id="block_1" class="barlittle"></div>
                            <div id="block_2" class="barlittle"></div>
                            <div id="block_3" class="barlittle"></div>
                            <div id="block_4" class="barlittle"></div>
                            <div id="block_5" class="barlittle"></div>
                        </div>
                    </div>
                    <div style="float: left; width: 40%; margin-left: 4px; margin-bottom: 5px; text-align: left;color: black;font-size: 16px;font-weight: bold; color: green; display: none" id="commentMsg">تم إضافة المقابلة </div>
                </div>
            </div>
        </form>
    </body>
</html>     
