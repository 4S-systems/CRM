<%@page import="com.silkworm.common.SecurityUser"%>
<%@page import="com.clients.db_access.ClientRatingMgr"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.tracker.db_access.ProjectMgr"%>
<%@page import="com.tracker.db_access.CampaignMgr"%>
<%@page import="com.silkworm.util.DateAndTimeControl"%>
<%@page import="com.crm.common.CRMConstants"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld"%> 
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        
        <script src="js/custom_popup/jquery-1.10.2.js"></script>
        <script src="js/custom_popup/jquery-ui.js"></script>
        <script type="text/javascript" src="jquery-ui/jquery-1.6.2.js"></script>
        <script src="js/jquery-ui.js" type="text/javascript"></script>
        
        <link rel="stylesheet" href="js/custom_popup/jquery-ui.css" />

        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.easing.1.3.js"></script>
        
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery-ui-timepicker-addon.css"/>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>
        
        <title>JSP Page</title>
        <%
            MetaDataMgr metaMgr = MetaDataMgr.getInstance();
            String context = metaMgr.getContext();
            int numberOfRows = 3;
            List<WebBusinessObject> appointments = (List<WebBusinessObject>) request.getAttribute("appointments");
            List<WebBusinessObject> userProjects = (List<WebBusinessObject>) request.getAttribute("userProjects");    
            String clientId = (String) request.getAttribute("clientId");
            String clientName = (String) request.getAttribute("clientName");
            
            SecurityUser securityUser = (SecurityUser) request.getSession().getAttribute("securityUser");
            String rateID = null;
             
             
            
            Calendar calendar = Calendar.getInstance();
            String timeFormat = "yyyy/MM/dd HH:mm";
            SimpleDateFormat sdf = new SimpleDateFormat(timeFormat);
            String nowTime = sdf.format(calendar.getTime());

            String stat = (String) request.getSession().getAttribute("currentMode");
            String dir = null, align, plsEntrCmmnt, plsEntrBrnch, cared, mtng, dFllwUp, cll, ntFnd, sDn, futr;
	    String nglctd, cmpnNm, appSbj, typ, brnch, resEmp, crtBy, drctBy, dateStr, cllDrtn, xalign, cllRst, tDo,
                    clntFllwUp, clnt, cmmnt, nDir, nt, lstApp, target, mechanism, Adate, call,
                    meeting, place, save, Aalign, ndir, xAlign, nRnD,
                    newApp, AppTyp, AppDate;
            if (stat.equals("En")) {
                dir = "LTR";
                align = "right";
		plsEntrCmmnt = " Please, Enter Comment ";
		plsEntrBrnch = " Please, SElect Branch ";
		cared = " Cared ";
		mtng = " Meeting ";
		dFllwUp = " Direct Follow-Up ";
		cll = " Call ";
		ntFnd = " Not Found ";
		sDn = " Successfully Done ";
		futr = " Futuristic ";
		tDo =  " To Do ";
		dFllwUp = " Direct Follow-Up ";
		nglctd = " Neglected ";
		cmpnNm = " Campaign Name ";
		appSbj = " Appointment Subject ";
		typ = " Type ";
		brnch = " Branch ";
		resEmp = " Responsible Employee ";
		crtBy = " Created By ";
		drctBy = " Directed By ";
		dateStr =  " Date ";
		cllDrtn = " Call Duration ";
		cmmnt = " Comment ";
		xalign = "left";
		cllRst = " Call Result ";
                align = "center";
                dir = "LTR";
                ndir = "RTL";
                cared = " CARED ";
                plsEntrCmmnt = " Please, Enter Comment ";
                typ = " TYPE ";
                sDn = " SUCCEED ";
                futr = " FUTURISTIC ";
                tDo =  " TO DO ";
                dFllwUp = " DIRECT ";
                nglctd = " FORGETTEN ";
                clntFllwUp = " Client Following-Up ";
                clnt = " CLient ";
                cmmnt = " Comment ";
                nDir = "right";
                nt = " APPOINTMENTS NOT FOLLOWED UP WILL BE MARKED AS NEGLECTED AFTER 12 HOURS ";
                lstApp = " Based On Last Appointment";
                target = "Target";
                mechanism = "Mechanism";
                Adate = "Date";
                call = "Call";
                meeting = "Meeting";
                place = "Place";
                save = "Save";
                Aalign = "left";
                xAlign = "right";
                nRnD = " Appointment Not Saved Or The Client Is Not Distributed ";
                newApp = "Create New Appointment ";
                AppTyp = "Appointment Type";
                AppDate = "Appointment Date";
            } else {
                dir = "RTL";
                align = "left";
		 plsEntrCmmnt = " من فضلك, أدخل تعليق ";
		 plsEntrBrnch = " من فضلك, أختر فرع ";
		 cared = " معتنى بها ";
		 mtng = " مقابلة ";
		 dFllwUp = " متابعة مباشرة ";
		 cll = " مكالمة ";
		 ntFnd = " لا يوجد ";
		 sDn = " تمت بنجاح ";
		futr = " مستقبلية ";
		tDo = " اليوم ";
		dFllwUp = " متابعة مبتشرة ";
		nglctd = " أهملت ";
		cmpnNm = " إسم الحملة ";
		appSbj = " موضوع الحملة ";
		typ = " النوع ";
		brnch = " الفرع ";
		resEmp = " الموظف المسئول ";
		crtBy = " أنشأت بواسطة ";
		drctBy = " وجهت بواسطة ";
		dateStr = " التاريخ ";
		cllDrtn = " مدة المكالمة ";
		cmmnt = " التعليق ";
		xalign= "right";
		cllRst = " نتيجة المكالمة ";
                align = "center";
                dir = "RTL";
                ndir = "LTR";
                plsEntrCmmnt = " من فضلك, أدخل تعليق ";
                typ = " النوع ";
                sDn = " تمت بنجاح ";
                futr = " مستقبلية ";
                tDo = " اليوم ";
                dFllwUp = " متابعة مباشرة ";
                nglctd = " أهملت ";
                clntFllwUp = " متابعة العميل ";
                clnt = " العميل ";
                cmmnt = " التعليق ";
                nDir = "left";
                nt = " سيتم وضع المتابعات مهملة إذا لم تتم متابعتها بعد 12 ساعة ";
                lstApp =  " بناءا على اخر متابعه";
                target = " الهدف";
                mechanism = "الاليه";
                Adate = "التاريخ";
                call = "مكالمه";
                meeting = "مقابله";
                place = "المكان";
                save = "حفظ";
                Aalign = "right";
                xAlign = "left";
                nRnD = " لم يتم التسجيل أو العميل غير موزع ";
                newApp = "متابعه جديده ";
                AppTyp = "نوع المتابعه"; 
                AppDate = "تاريخ المتابعه";
            }
            
            ArrayList<WebBusinessObject> ratesList = new ArrayList<>();
            ProjectMgr projectMgr = ProjectMgr.getInstance();
            ratesList = new ArrayList<>(projectMgr.getOnArbitraryKeyOracle("CL-RATE", "key6"));
            
            ClientRatingMgr clientRatingMgr = ClientRatingMgr.getInstance();
            WebBusinessObject clientRateWbo = clientRatingMgr.getOnSingleKey("key1", clientId);
            WebBusinessObject rateTempWbo = null;
            if (clientRateWbo != null) {
                rateTempWbo = projectMgr.getOnSingleKey((String) clientRateWbo.getAttribute("rateID"));
            }
            
            String groupID = (String) securityUser.getUserGroupId();
//            if(groupID != null && (groupID.equalsIgnoreCase("1528286021839") || groupID.equalsIgnoreCase("1528877486714")) ){
//                rateID = "Interested";
//             }
        %>
        <script type="text/javascript">
            
            $(document).ready(function(){
                $('.login-input').datetimepicker({
                    minDate: 0,
                    changeMonth: true,
                    changeYear: true,
                    changeDay: true,
                    timeFormat: 'HH:mm',
                    dateFormat: 'yy/mm/dd'
                }).attr('readonly', 'readonly');
                $("td#newAppAjax").fadeIn();
            });
            function showComment(id) {
//                $("#commentText" + id).hide();
                $("#dateText" + id).hide();
                $("#commentDiv" + id).show();
                $("#commentValue" + id).val("");
            }
            function closeComment(id) {
//                $("#commentText" + id).show();
                $("#dateText" + id).show();
                $("#commentDiv" + id).hide();
            }
            function updateComment(id, type) {
                var branch = $("#branchValue" + id).val().trim();
                var comment = "&#13;&#10;" + $("#commentValue" + id).val().trim();
                var duration = $("#durationValue" + id).val().trim();

                if (comment !== '') {
                    $.ajax({
                        type: "post",
                        url: "<%=context%>/AppointmentServlet?op=appointmentDone",
                        data: {
                            appointmentID: id,
                            branch: branch,
                            comment: comment,
                            duration : duration
                        },
                        success: function (jsonString) {
                            var info = $.parseJSON(jsonString);
                            if (info.status === 'ok') {
                                getAppointmentComment(id);
//                                $("#popup-title-icon" + id).attr("src", "images/icons/calendar_circle_green.png");
//                                $("#popup-title-text" + id).html(type + " معتنى بها");
                                closeComment(id);
                            }
                        }, error: function (jsonString) {
                        }
                    });
                } else {
		    var plsEntrCmmnt = ' <%=plsEntrCmmnt%> ';
                    alert( plsEntrCmmnt );
                    $("#commentValue" + id).focus();
                }
            }
            function showBranch(id) {
                $("#branchTxt" + id).hide();
                $("#branchDiv" + id).show();
            }
            function closeBranch(id) {
                $("#branchTxt" + id).show();
                $("#branchDiv" + id).hide();
            }
            function updateBranch(id, type) {
               var branch = $("#branchValue" + id).val().trim();
                var comment = $("#commentValue" + id).val().trim();
                var duration = $("#durationValue" + id).val().trim();
                if (branch !== '') {
                    $.ajax({
                        type: "post",
                        url: "<%=context%>/AppointmentServlet?op=appointmentDone",
                        data: {
                            appointmentID: id,
                            branch: branch,
                            comment: comment,
                            duration : duration
                        },
                        success: function (jsonString) {
                            var info = $.parseJSON(jsonString);
                            if (info.status === 'ok') {
                                $("#branchTxt" + id).html(branch);
//                                $("#popup-title-icon" + id).attr("src", "images/icons/calendar_circle_green.png");
//                                $("#popup-title-text" + id).html(type + " معتنى بها");
                                closeBranch(id);
                            }
                        }, error: function (jsonString) {
                        }
                    });
                } else {
		    var plsEntrBrnch = ' <%=plsEntrBrnch%> ';
                    alert( plsEntrBrnch );
                    $("#branchValue" + id).focus();
                }
            }
            
            function showDuration(id) {
                $("#durationTxt" + id).hide();
                $("#durationDiv" + id).show();
            }
            function closeDuration(id) {
                $("#durationTxt" + id).show();
                $("#durationDiv" + id).hide();
            }
            function updateDuration(id, type) {
                var branch = $("#branchValue" + id).val().trim();
                var comment = $("#commentValue" + id).val().trim();
                var duration = $("#durationValue" + id).val().trim();
                if (duration !== '') {
                    $.ajax({
                        type: "post",
                        url: "<%=context%>/AppointmentServlet?op=appointmentDone",
                        data: {
                            appointmentID: id,
                            branch: branch,
                            comment: comment,
                            duration : duration
                        },
                        success: function (jsonString) {
                            var info = $.parseJSON(jsonString);
                            if (info.status === 'ok') {
                                $("#durationTxt" + id).html(duration);
//                                $("#popup-title-icon" + id).attr("src", "images/icons/calendar_circle_green.png");
//                                $("#popup-title-text" + id).html(type + " معتنى بها");
                                closeDuration(id);
                            }
                        }, error: function (jsonString) {
                        }
                    });
                } else {
                    $("#durationValue" + id).focus();
                }
            }
            
            function popupAddPlanningAppointment(clientId) {
                $("#palnningTitleMsg").css("color", "");
                $("#palnningTitleMsg").text("");
                $("#palnningTitle").val("");
                $("#palnningComment").val("");
                $("#palnningMsg").hide();
                $('#appointment_content' + clientId).css("display", "block");
                $('#appointment_content' + clientId).bPopup({easing: 'easeInOutSine', //uses jQuery easing plugin
                    speed: 400,
                    transition: 'slideDown'});
            }
            
            function updateResult(id, type, clientId) {
                var result = $("#result" + id + " option:selected").val();
                var nextAction = $("#nextAction" + id + " option:selected").val();
		
                if (result !== '' && nextAction !== '') {
                    $.ajax({
                        type: "post",
                        url: "<%=context%>/AppointmentServlet?op=updateAppointmentResult",
                        data: {
                            appointmentID: id,
                            result: result,
                            nextAction:nextAction,
                            clientID: clientId
                        },
                        success: function (jsonString) {
                            var info = $.parseJSON(jsonString);
                            if (info.status === 'ok') {
                                alert("Updated Successfully");
                                $("#appointment-result" + id).hide();
                                $("#popup-title-icon" + id).attr("src", "images/icons/calendar_circle_green.png");
                                var cared = ' <%=cared%> ';
				$("#popup-title-text" + id).html( type + cared );
                                //popupAddPlanningAppointment(clientId);
                                changeClientRateN(id, clientId);
                            }
                        }, error: function (jsonString) {
                        }
                    });
                } else {
                    if (result === '') {
                        $("#result" + id).focus();
                    }
                    if (nextAction === '') {
                        $("#nextAction" + id).focus();
                    }
                }
            }
            
            
            function saveAppoientment(obj, clientId) {
                var clientId = clientId;
		var appID = $("#LstCommentId").val();
                $("#palnningTitleMsg").css("color", "");
                $("#palnningTitleMsg").text("");
                var title = $(obj).parent().parent().parent().find($("#palnningTitle" + clientId)).val();
                var date = $(obj).parent().parent().parent().find($("#palnningDate" + clientId)).val();
                var appType = $(obj).parent().parent().parent().find("#note:checked").val();
                var appointmentPlace = $(obj).parent().parent().parent().find("#appointmentPlace").val();
                var comment = $(obj).parent().parent().parent().find("#palnningComment").val();
                var note = "UL";
                    $.ajax({
                        type: "post",
                        url: "<%=context%>/ClientServlet?op=saveAppointment",
                        data: {
                            clientId: clientId,
                            title: title,
                            date: date,
                            note: note,
                            appType: appType,
                            type: "1",
                            appointmentPlace: appointmentPlace,
                            comment: comment,
			    appID: appID
                        },
                        success: function (jsonString) {
                            var eqpEmpInfo = $.parseJSON(jsonString);
                            if (eqpEmpInfo.status == 'ok') {
                                $('#overlay').hide();
                                $('#appointment_content' + clientId).css("display", "none");
                                $('#appointment_content' + clientId).bPopup().close();
                                window.location.reload();
                            } else if (eqpEmpInfo.status == 'no') {
                                $(obj).parent().parent().parent().parent().find("#progress").show();
				var nRnD = ' <%=nRnD%> ';
                                $(obj).parent().parent().parent().parent().find("#palnningMsg").html( nRnD ).show();
                            }
                        }
                    });
            }
            function getAppointmentComment(appointmentID) {
                $.ajax({
                    type: "post",
                    url: "<%=context%>/AppointmentServlet?op=getAppointmentCommentAjax",
                    data: {
                        appointmentID: appointmentID
                    },
                    success: function (jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.status === 'ok') {
                            $("#commentTextPre" + appointmentID).html(info.comment);
                        }
                    }
                });
            }
            
            function createNewApp(appID, clntID){
                var newApp = $("#newApp").val();
                if(newApp == 'off'){
                    $("#newApp").val('on');
		    $('#newApp').attr('checked', true);
                    
                    $("tr#AppTyp").fadeIn();
                    $("tr#AppDate").fadeIn();
                    
                    $('#clientRate' + appID + ' option:contains(Following up)').attr('selected', true);
                    changeClientRate(appID, clntID);
                } else {
                    $("#newApp").val('off');
		    $("#newApp").attr('checked', false);
                    
                    $("tr#AppTyp").fadeOut();
                    $("tr#AppDate").fadeOut();
                }
            } 
            
            function newAppAjax(appID, clientId) {
                var clientId = clientId;
		var appID = appID;
                
                var title = $("#appointment-title").text();
                //console.log("title "+ title);
                
                var date = $("#nwAppDate").val();
                //console.log("date "+ date);
                
                var appType = $('input[name=AppTyp]:checked').val();
                //console.log("appType "+ appType);
                
                var appointmentPlace = $("#appointment-for").text();
                //console.log("appointmentPlace "+ appointmentPlace);
                
                var comment = $("#commentTextPre" + appID).text();
                //console.log("comment "+ comment);
                var note = "UL";
               // if (title.length > 0) {
                    $.ajax({
                        type: "post",
                        url: "<%=context%>/ClientServlet?op=saveAppointment",
                        data: {
                            clientId: clientId,
                            title: title,
                            date: date,
                            note: note,
                            appType: appType,
                            type: "2",
                            appointmentPlace: appointmentPlace,
                            comment: comment,
			    appID: appID
                        },
                        success: function (jsonString) {
                            var eqpEmpInfo = $.parseJSON(jsonString);
                            if (eqpEmpInfo.status == 'ok') {
                                alert("AppointMent Has Been Created ");
                                $("td#newAppAjax").fadeOut();
                            } else if (eqpEmpInfo.status == 'no') {
                                alert("Please End This Appointment And Try Again ");
                            }
                        }
                    });
                //} else {
                    //$("#palnningTitleMsg").css("color", "white");
                    //$("#palnningTitleMsg").text("أدخل عنوان المقابلة");
               // }
            }
            
            function changeClientRateSelect(appID, clntID){
                var isExists = false, rateText;
                var nextActionText = $("#nextAction" + appID + " option:selected").val();
                var newApp = $("#newApp:checked").val();         
                switch (nextActionText) {
                    case "Follow":
                    case "Visit":
                    case "Send Email":
                    case "Send SMS":
                    case "Send Offer":
                        rateText = "Following up";
                        isExists = true;
                        break;

                    case "Wait":
                        rateText = "Wait";
                        isExists = true;
                        break;
                    case "Hold":
                        rateText = "Hold";
                        isExists = true;
                        break;

                    case "Wrong Number":
                        rateText = "Wrong Number";
                        isExists = true;
                        break;

                    case "Closed":
                    case "Not Serious":
                        rateText = "Closed";
                        isExists = true;
                        break;

                    case "Not Interested":
                        rateText = "Not interested";
                        isExists = true;
                        break;
                        
                    case "Interested":
                        rateText = "Interested";
                        isExists = true;
                        break;
                    
                    case "Unreachable":
                        rateText = "Unreachable";
                        isExists = true;
                        break;
                    
                    case "Unreachable WTS":
                        rateText = "Unreachable WTS";
                        isExists = true;
                        break;
                    case "Out of budget":
                        rateText = "Out of budget";
                        isExists = true;
                        break;
                                   
                    case "Out of segment":
                        rateText = "Out of segment";
                        isExists = true;
                        break;

                    case "Existing Owner":
                        rateText = "Existing Owner";
                        isExists = true;
                        break;

                    case "Needs Ready Unit":
                        rateText = "Needs Ready Unit";
                        isExists = true;
                        break;  
                    
                    case "not answered":
                        rateText = "not answered";
                        isExists = true;
                        break; 
                }
                if (isExists) {
                    $("#clientRate" + appID + " option").removeAttr("selected");
                    $("#clientRate" + appID + " option").filter(function () {
                        return $(this).text().trim() === rateText.trim();
                    }).attr('selected', true);
//                    changeClientRate(appID, clntID);
                }
                
            }
            
            function changeClientRate(appID, clientID){
                var rateID = $("#clientRate" + appID + " option:selected").val();
//                var groupID = '<%=groupID%>';
//                if(groupID != null && (groupID=="1528286021839" || groupID=="1528877486714") ){
//                    rateID = '<%=rateID%>';
//                }
                console.log("rateID "+ rateID);
                console.log($("#clientRate" + appID + " option:selected").val());
                console.log($("#clientRate" + appID + " option:selected").text());
                $.ajax({
                    type: "post",
                    url: "<%=context%>/ClientServlet?op=changeClientRate",
                    data: {
                        rateID: rateID,
                        clientID: clientID
                    }, success: function (jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.status == 'ok') {
                            //alert("تم التقييم");
                        } else {
                            alert("خطأ لم يتم التقييم");
                        }
                    }
                });
            }
            
            function changeClientRateN(appID, clientID){
                var rateID = $("#clientRate" + appID + " option:selected").val();
                console.log($("#clientRate" + appID + " option:selected").val());
                console.log($("#clientRate" + appID + " option:selected").text());
                $.ajax({
                    type: "post",
                    url: "<%=context%>/ClientServlet?op=changeClientRate",
                    data: {
                        rateID: rateID,
                        clientID: clientID
                    }, success: function (jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.status == 'ok') {
                            //alert("تم التقييم");
                        } else {
                            alert("خطأ لم يتم التقييم");
                        }
                    }
                });
            }
        </script>
        <style>
            .ui-dialog-titlebar-close{
                display: none;
            }
	    
	    *>*{
		vertical-align: middle;
	    }
        </style>
    </head>
    <body style="width: 100%">
	
    <center>
        <TABLE width="90%" CELLPADDING="0" ALIGN="CENTER" style="border-width: 0px" DIR="<%=dir%>">
            <%
                String popupTitle, title, creator, responsible, date, type, option2, directedByName, currentStatusCode, imageName, campaignName, comment;
                WebBusinessObject appointment, formattedTime, branch;
                int timeRemaining, counter = 0, index, duration = 0;
                boolean showMeetingList = false, showCallList = false;
                while (counter < appointments.size()) {
                    index = 1;
            %>
		<%
			    while (((index % (numberOfRows + 1)) != 0) && (counter < appointments.size())) {
				index++;
				appointment = appointments.get(counter++);
				timeRemaining = Integer.parseInt((String) appointment.getAttribute("timeRemaining"));
				currentStatusCode = (String) appointment.getAttribute("currentStatusCode");
				option2 = (String) appointment.getAttribute("option2");
				System.out.println("call result --> " + appointment.getAttribute("option2"));
				if (CRMConstants.CALL_RESULT_MEETING.equalsIgnoreCase(option2)
					|| CRMConstants.CALL_RESULT_VISIT.equalsIgnoreCase(option2)) {
				    type = mtng;
				} else if (CRMConstants.CALL_RESULT_FOLLOWUP.equalsIgnoreCase(option2)) {
				    type = dFllwUp;
				} else {
				    type = cll;
				}

				if ((String) appointment.getAttribute("callDuration") != null) {
				    duration = Integer.parseInt((String) appointment.getAttribute("callDuration"));
				}

				String mybranch = ntFnd;
				if ((String) appointment.getAttribute("appointmentPlace") != null) {
				    mybranch = mybranch = (String) appointment.getAttribute("appointmentPlace");
				}

				if (CRMConstants.APPOINTMENT_STATUS_DONE.equalsIgnoreCase(currentStatusCode)) {
				    imageName = CRMConstants.APPOINTMENT_STATUS_IMAGES.get(CRMConstants.APPOINTMENT_STATUS_DONE);
				    popupTitle = sDn;
				} else if (CRMConstants.APPOINTMENT_STATUS_CARED.equalsIgnoreCase(currentStatusCode)) {
				    imageName = CRMConstants.APPOINTMENT_STATUS_IMAGES.get(CRMConstants.APPOINTMENT_STATUS_CARED);
				    if (stat.equals("En")) {
					popupTitle = cared + type;
				    } else {
					popupTitle = type + cared;
				    }
				} else if (CRMConstants.APPOINTMENT_STATUS_DIRECT_FOLLOW_UP.equalsIgnoreCase(currentStatusCode)) {
				    imageName = CRMConstants.APPOINTMENT_STATUS_IMAGES.get(CRMConstants.APPOINTMENT_STATUS_DIRECT_FOLLOW_UP);
				    popupTitle = dFllwUp;
				} else if (timeRemaining >= -(12 * 60) && CRMConstants.APPOINTMENT_STATUS_OPEN.equalsIgnoreCase(currentStatusCode)) {
				    imageName = CRMConstants.APPOINTMENT_STATUS_IMAGES.get(CRMConstants.APPOINTMENT_STATUS_OPEN);
				    if (stat.equals("En")) {
					popupTitle = futr + type;
				    } else {
					popupTitle = type + futr;
				    }
				    if (CRMConstants.CALL_RESULT_MEETING.equalsIgnoreCase(option2)
					|| CRMConstants.CALL_RESULT_VISIT.equalsIgnoreCase(option2)) {
					showMeetingList = true;
					showCallList = false;
				    } else {
					showMeetingList = false;
					showCallList = true;
				    }
				} else {
				    imageName = CRMConstants.APPOINTMENT_STATUS_IMAGES.get(CRMConstants.APPOINTMENT_STATUS_NEGLECTED);
					popupTitle = type + nglctd;
				    if (CRMConstants.CALL_RESULT_MEETING.equalsIgnoreCase(option2)
					|| CRMConstants.CALL_RESULT_VISIT.equalsIgnoreCase(option2)) {
					showMeetingList = true;
					showCallList = false;
				    } else {
					showMeetingList = false;
					showCallList = true;
				    }
				}

				directedByName = "---";
				if (appointment.getAttribute("directedByName") != null) {
				    directedByName = (String) appointment.getAttribute("directedByName");
				}

				title = (String) appointment.getAttribute("title");
                                
				creator = (String) appointment.getAttribute("createdByName");
				responsible = (String) appointment.getAttribute("userName");
				date = (String) appointment.getAttribute("appointmentDate");
				String tempDate = date.split(" ")[0];
				String[] dateArr = tempDate.contains("-") ? tempDate.split("-") : tempDate.split("/");
				if (dateArr.length == 3) {
				    if (dateArr[0].length() == 4) {
					date = dateArr[2] + "/" + dateArr[1] + "/" + dateArr[0] + " " + date.split(" ")[1];
				    } else {
					date = dateArr[0] + "/" + dateArr[1] + "/" + dateArr[2] + " " + date.split(" ")[1];
				    }
				}
				campaignName = ntFnd;
				formattedTime = DateAndTimeControl.getFormattedDateTime2(date, stat);
				if (appointment.getAttribute("option5") != null && !((String) appointment.getAttribute("option5")).equalsIgnoreCase("UL")) {
				    CampaignMgr campaignMgr = CampaignMgr.getInstance();
				    WebBusinessObject campaignWbo = campaignMgr.getOnSingleKey((String) appointment.getAttribute("option5"));
				    if (campaignWbo != null) {
					campaignName = (String) campaignWbo.getAttribute("campaignTitle");
				    }
				}
				if (appointment.getAttribute("comment") != null) {
				    comment = (String) appointment.getAttribute("comment");
				} else {
				    comment = ntFnd;
				}

                            projectMgr = ProjectMgr.getInstance();
			%>
		    <TR style="border-width: 0px" width="100%">
			
			<TD style="border-width: 0px;" width="100%">
			    <h3 class="popup-title" style="text-align: <%=xalign%>">                        
				<img id="popup-title-icon<%=appointment.getAttribute("id")%>" src="images/icons/<%=imageName%>" width="24" height="24" style="vertical-align: middle"/>
				<b id="popup-title-text<%=appointment.getAttribute("id")%>" style="font-size: 16px"><%=popupTitle%></b>
			    </h3>
			    <TABLE class="backgroundTable" width="100%" CELLPADDING="0" CELLSPACING="8" ALIGN="CENTER" DIR="<%=dir%>">
				<TR>
				    <TD class="backgroundHeader" style="text-align: <%=xalign%>" width="50%">
					<p>
					    <b style="margin-left: 5px;margin-left: 5px;font-weight: bold;">
						 <%=cllRst%> : 
					    </b>
				    </TD>
				    <TD id="campaign-name" style="border-width: 0px; text-align: <%=xalign%>" width="40%">
					<select id="result<%=appointment.getAttribute("id")%>">
					    <%
					    if(showMeetingList) {
					    %>
					    <option value="">Meeting Result</option>
					    <option value="attended" style="font-weight: bold;" <%="attend".equals(appointment.getAttribute("option9")) ? "selected" : ""%>>Attended</option>
					    <option value="not attended" style="font-weight: bold;" <%="not attend".equals(appointment.getAttribute("option9")) ? "selected" : ""%>>Not Attended</option>
					    <%
					    } else if(showCallList) {
					    %>
					    <option value="">Call Result</option>
					    <%--<option value="wrong number" style="font-weight: bold;" <%="wrong number".equals(appointment.getAttribute("option9")) ? "selected" : ""%>>Wrong Number</option>--%>
					    <option value="not answered" style="font-weight: bold;" <%="not answered".equals(appointment.getAttribute("option9")) ? "selected" : ""%>>Not Answered</option>
					    <option value="answered" style="font-weight: bold;" <%="answered".equals(appointment.getAttribute("option9")) ? "selected" : ""%>>Answered</option>
					    <%
					    }
					    %>
                                        </select>
                                            <select id="nextAction<%=appointment.getAttribute("id")%>" style="width: 100px;" onchange="changeClientRateSelect('<%=appointment.getAttribute("id")%>', '<%=clientId%>');">
                                            <option value="">Next Action</option>
                                            <option value="No Action" selected>No Action</option>
                                            <option value="Interested" style="font-weight: bold;">Interested</option>
                                            <option value="Send Email" style="font-weight: bold;">Send Email</option>
                                            <option value="Send SMS" style="font-weight: bold;">Send SMS</option>
                                            <option value="Send Offer" style="font-weight: bold;">Send Offer</option>
                                            <option value="Closed" style="font-weight: bold;">Closed</option>
                                            <option value="Not Interested" style="font-weight: bold;">Not Interested</option>
                                            <option value="Not Serious" style="font-weight: bold;">Not Serious</option>
                                            <option value="Out of segment" style="font-weight: bold;">Out of segment</option>
                                            <option value="Existing Owner" style="font-weight: bold;">Existing Owner</option>
                                            <option value="Wait" style="font-weight: bold;">Wait</option>
                                            <option value="Wrong Number" style="font-weight: bold;">Wrong Number</option>
                                            <option value="Needs Ready Unit" style="font-weight: bold;">Needs Ready Unit</option>
                                            <option value="not answered" style="font-weight: bold;">not answered</option>
                                            <option value="Unreachable" style="font-weight: bold;">Unreachable</option>
                                            <option value="Unreachable WTS" style="font-weight: bold;">Unreachable WTS</option>
                                            <option value="Hold" style="font-weight: bold;">Hold</option>
                                            <option value="Out of budget"  style="font-weight: bold;">Out of budget</option>
                                        </select>
                                            
                                        <select name="clientRate" id="clientRate<%=appointment.getAttribute("id")%>" style="width: 200px; direction: rtl; display: none;">
                                            <option value="">Select Client Rate</option>
                                            <%
                                                for (WebBusinessObject rateWbo : ratesList) {
                                            %>
                                            <option value="<%=rateWbo.getAttribute("projectID")%>" <%=clientRateWbo != null && rateWbo.getAttribute("projectID").equals(clientRateWbo.getAttribute("rateID")) ? "selected" : ""%> ><%=rateWbo.getAttribute("projectName")%></option>
                                            <%
                                                }
                                            %>
                                        </select>
				    </TD>
				    
				    <TD id="appointment-result<%=appointment.getAttribute("id")%>" style="border-width: 0px; text-align: <%=xalign%>; height: 50px;" width="10%">
					<div style="display: <%=showMeetingList || showCallList ? "" : "none"%>; margin-<%=align%>: 20px; vertical-align: bottom;" id="resultDiv<%=appointment.getAttribute("id")%>">
					   <img src="images/ok_white.png" style="cursor: hand; height: 20px; vertical-align: bottom;" title="Update"
						 onclick="JavaScript: updateResult('<%=appointment.getAttribute("id")%>', '<%=type%>', <%=clientId%>);"/>
					</div>
				    </TD>
				</TR>
                                
                                <TR>
                                    <TD class="backgroundHeader" style="text-align: <%=xalign%>" width="50%">
                                        <span style="margin-left: 5px;"><%=newApp%></span>
                                    </TD>
                                    <TD style="border-width: 0px; text-align: <%=xalign%>; height: 50px;" width="50%">
                                        <input name="newApp" type="checkbox" value="off" id="newApp" style="float: <%=xalign%>;margin-right: 30px;" onchange="createNewApp('<%=appointment.getAttribute("id")%>', '<%=clientId%>')">
                                    </TD>
				</TR>
                                
                                <tr id="AppTyp" style="display: none;background-color: lightgrey;">
                                    <TD class="backgroundHeader" style="text-align: <%=xalign%>; background-color: lightgrey;" width="50%">
                                        <span style="margin-left: 5px;"><%=AppTyp%></span>
                                    </TD>
                                    <TD style="border-width: 0px; text-align: <%=xalign%>; background-color: lightgrey;width:20%;">
                                        <input name="AppTyp" type="radio" value="call" checked="" id="AppTypC" style="float:<%=Aalign%>;" >
                                        <label style="width:50px;"><%=call%> </label>
                                        
                                        <input name="AppTyp" type="radio" value="meeting" id="AppTypM" style="float:<%=Aalign%>;">
                                        <label style="width:50px; float: left;"><%=meeting%></label>
                                        
                                    </TD>
                                    <TD style="border-width: 0px; text-align: <%=xalign%>; background-color: lightgrey;width:10%;">
                                    </TD> 
                                    
                                    <TD style="border: none; width: 30%">
                                        <input type="hidden"/>
                                    </TD>
                                </tr>
                                <tr id="AppDate" style="display: none;background-color: lightgrey;">
                                    <TD class="backgroundHeader" style="text-align: <%=xalign%>;background-color: lightgrey;" width="50%">
                                        <span style="margin-left: 5px;"><%=AppDate%></span>
                                    </TD>
                                    <TD style="border-width: 0px; text-align: <%=xalign%>;background-color: lightgrey; width: 40%" colspan="2">
                                        <input class="login-input" name="nwAppDate" id="nwAppDate" type="text" size="50" maxlength="50" style="width:150px;font-size: medium; float: left; margin-top: 5px;" value="<%=nowTime%>"/>
                                    </TD>
                                    <TD id="newAppAjax" style="border-width: 0px; text-align: <%=xalign%>; width: 10%" colspan="2">
                                        <img src="images/ok_white.png" style="cursor: hand; height: 20px; vertical-align: bottom;" title="Update"
						 onclick="JavaScript: newAppAjax('<%=appointment.getAttribute("id")%>', <%=clientId%>);"/>
                                    </TD>
                                </tr>
                                
				<TR>
				    <TD class="backgroundHeader" style="text-align: <%=xalign%>" width="50%">
					<p>
					    <b style="margin-left: 5px;margin-left: 5px;font-weight: bold;"> <%=cmpnNm%> : </b>
				    </TD>
				    <TD id="campaign-name" style="border-width: 0px; text-align: <%=xalign%>" width="50%"><%=campaignName%></TD>
				    <TD id="appointment-result<%=appointment.getAttribute("id")%>" style="border-width: 0px; text-align: <%=xalign%>; height: 50px;" width="10%">
					
				    </TD>
				</TR>
				<TR>
				    <TD class="backgroundHeader" style="text-align: <%=xalign%>" width="50%">
					<p><b style="margin-left: 5px;margin-left: 5px;font-weight: bold"> <%=appSbj%> : </b>
				    </TD>
				    <TD id="appointment-title" style="border-width: 0px; text-align: <%=xalign%>" width="50%"><%=title%></TD>
				</TR>
				<TR>
				    <TD class="backgroundHeader" style="text-align: <%=xalign%>" width="50%">
					<p><b style="margin-left: 5px;margin-left: 5px;font-weight: bold"> <%=typ%> : </b>
				    </TD>
				    <TD id="appointment-type" style="border-width: 0px; text-align: <%=xalign%>" width="50%"><%=type%></TD>
				</TR>

				<TR>
				    <TD class="backgroundHeader" style="text-align: <%=xalign%>" width="20%">
					<p><b style="margin-left: 5px;margin-left: 5px;font-weight: bold"> <%=brnch%> : </b>
				    </TD>
				    <TD id="appointment-for" style="border-width: 0px; text-align: <%=xalign%>" width="50%"> <%=mybranch%> </TD>
				     <TD id="appointment-branch<%=appointment.getAttribute("id")%>" style="border-width: 0px; text-align: <%=xalign%>; height: 50px;" width="30%">
					<div id="branchTxt<%=appointment.getAttribute("id")%>">
					    <img src="images/icons/edit.png" style="cursor: hand; height: 30px; float: <%=align%>; padding-<%=align%>: 20px;"
						 onclick="JavaScript: showBranch('<%=appointment.getAttribute("id")%>');" title="Edit"/>
					</div>
					<div style="display: none; margin-<%=align%>: 20px; vertical-align: bottom;" id="branchDiv<%=appointment.getAttribute("id")%>">
					    <select id="branchValue<%=appointment.getAttribute("id")%>" name="appointmentPlace" style="margin-top: 7px;width:200px;font-size: medium;">
						<sw:WBOOptionList wboList='<%=userProjects%>' displayAttribute = "projectName" valueAttribute="projectName" />
						<option value="<%=mybranch%>"><%=mybranch%></option>
					    </select>
					    <img src="images/ok_white.png" style="cursor: hand; height: 20px; vertical-align: bottom;" title="Update"
						 onclick="JavaScript: updateBranch('<%=appointment.getAttribute("id")%>', '<%=type%>');"/>
					    <img src="images/icons/delete_ready.png" style="cursor: hand; height: 20px; vertical-align: bottom;" title="Close"
						 onclick="JavaScript: closeBranch('<%=appointment.getAttribute("id")%>');"/>
					</div>
				    </TD>
				</TR>

				<TR>
				    <TD class="backgroundHeader" style="text-align: <%=xalign%>" width="50%">
					<p><b style="margin-left: 5px;margin-left: 5px;font-weight: bold"> <%=resEmp%> : </b>
				    </TD>
				    <TD id="appointment-for" style="border-width: 0px; text-align: <%=xalign%>" width="50%"><%=responsible%></TD>
				</TR>
				<TR>
				    <TD class="backgroundHeader" style="text-align: <%=xalign%>" width="50%">
					<p><b style="margin-left: 5px;margin-left: 5px;font-weight: bold"> <%=crtBy%> : </b>
				    </TD>
				    <TD id="appointment-creator" style="border-width: 0px; text-align: <%=xalign%>" width="50%"><%=creator%></TD>
				</TR>
				<TR>
				    <TD class="backgroundHeader" style="text-align: <%=xalign%>" width="50%">
					<p><b style="margin-left: 5px;margin-left: 5px;font-weight: bold"> <%=drctBy%> : </b>
				    </TD>
				    <TD id="appointment-directed-by" style="border-width: 0px; text-align: <%=xalign%>" width="50%"><%=directedByName%></TD>
				</TR>
				<TR>
				    <TD class="backgroundHeader" style="text-align: <%=xalign%>" width="50%">
					<p><b style="margin-left: 5px;margin-left: 5px;font-weight: bold"> <%=dateStr%> : </b>
				    </TD>
				    <TD id="appointment-date" style="border-width: 0px; text-align: <%=xalign%>" width="50%"><font color="red"><%=formattedTime.getAttribute("day")%> - </font><b><%=formattedTime.getAttribute("time")%></b></TD>
				</TR>

				<TR>
				    <TD class="backgroundHeader" style="text-align: <%=xalign%>" width="50%">
					<p><b style="margin-left: 5px;margin-left: 5px;font-weight: bold"> <%=cllDrtn%> : </b>
				    </TD>
				    <TD id="appointment-date" style="border-width: 0px; text-align: <%=xalign%>" width="25%">
					<div id="durationTxt<%=appointment.getAttribute("id")%>">
					    <font color="red"></font><b>  <%=duration%> Minutes </b>
					</div>
				    </TD>
				    <TD id="appointment-duration<%=appointment.getAttribute("id")%>" style="border-width: 0px; text-align: <%=xalign%>; height: 50px;" width="25%">
					<div id="durationTxt<%=appointment.getAttribute("id")%>">
					    <img src="images/icons/edit.png" style="cursor: hand; height: 30px; float: <%=align%>; padding-<%=align%>: 20px;"
						 onclick="JavaScript: showDuration('<%=appointment.getAttribute("id")%>');" title="Edit"/>
					</div>
					<div style="display: none; margin-<%=align%>: 20px; vertical-align: bottom;" id="durationDiv<%=appointment.getAttribute("id")%>">
					    <input type="number" name="callDuration" id="durationValue<%=appointment.getAttribute("id")%>" value="<%=new Integer(duration).toString().equals("0") ? "0" : duration%>" min="1" style="width: 80px;"/>
					   <img src="images/ok_white.png" style="cursor: hand; height: 20px; vertical-align: bottom;" title="Update"
						 onclick="JavaScript: updateDuration('<%=appointment.getAttribute("id")%>', '<%=type%>');"/>
					    <img src="images/icons/delete_ready.png" style="cursor: hand; height: 20px; vertical-align: bottom;" title="Close"
						 onclick="JavaScript: closeDuration('<%=appointment.getAttribute("id")%>');"/>
					</div>
				    </TD>

				</TR>

				<TR>
				    <TD class="backgroundHeader" style="text-align: <%=xalign%>" width="50%">
					<p><b style="margin-left: 5px;margin-left: 5px;font-weight: bold"> <%=cmmnt%> : </b>
				    </TD>
				    <TD id="appointment-comment<%=appointment.getAttribute("id")%>" style="border-width: 0px; text-align: <%=xalign%>; height: 50px;" width="40%">
					<div id="commentText<%=appointment.getAttribute("id")%>">
					    <pre id="commentTextPre<%=appointment.getAttribute("id")%>" style="width: 240px;"><%=comment.equals("لا يوجد")||comment.equals("")||comment == null ? "لا يوجد" : comment%></pre>
					</div>
					<div style="display: none; margin-<%=align%>: 20px; vertical-align: bottom;" id="commentDiv<%=appointment.getAttribute("id")%>">
					    <textarea cols="30" rows="5" id="commentValue<%=appointment.getAttribute("id")%>" style="display: inline-block;"></textarea>
					    <img src="images/ok_white.png" style="cursor: hand; height: 20px; vertical-align: bottom;" title="Update"
						 onclick="JavaScript: updateComment('<%=appointment.getAttribute("id")%>', '<%=type%>');"/>
					    <img src="images/icons/delete_ready.png" style="cursor: hand; height: 20px; vertical-align: bottom;" title="Close"
						 onclick="JavaScript: closeComment('<%=appointment.getAttribute("id")%>');"/>
					</div>
				    </TD>
				    
				    <TD id="appointment-comment<%=appointment.getAttribute("id")%>" style="border-width: 0px; text-align: <%=xalign%>; height: 50px;" width="10%">
					<img src="images/icons/edit.png" style="cursor: hand; height: 30px; float: <%=align%>; padding-<%=align%>: 20px;"
						 onclick="JavaScript: showComment('<%=appointment.getAttribute("id")%>');" title="Edit"/>
				    </TD>
				</TR>
			    </TABLE>
			    <br/>
			</TD>
			
		    <TR>
			<%}%>
                <%}%>
        </TABLE>
    </center>
    </body>
</html>
