<%@page import="com.maintenance.db_access.GroupPrevMgr"%>
<%@page import="com.tracker.db_access.ProjectMgr"%>
<%@page import="com.tracker.db_access.CampaignMgr"%>
<%@page import="com.crm.common.CRMConstants"%>
<%@page import="com.crm.common.CalendarUtils"%>
<%@page import="com.crm.common.CalendarUtils.Day"%>
<%@page import="com.clients.db_access.AppointmentNotificationMgr"%>
<%@page import="com.maintenance.db_access.ScheduleMgr"%>
<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.DistributedItemsMgr,java.util.*,java.text.*,com.maintenance.common.ParseSideMenu"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<%@page pageEncoding="UTF-8" %>
<HTML>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        Map<String, Map<String, WebBusinessObject>> data = (Map<String, Map<String, WebBusinessObject>>) request.getAttribute("data");
        Map<String, String> clientMobile = (Map<String, String>) request.getAttribute("clientMobile");
        List<Integer> years = (List<Integer>) request.getAttribute("years");
        List<CalendarUtils.Month> months = (List<CalendarUtils.Month>) request.getAttribute("months");
        List<CalendarUtils.Day> days = (List<CalendarUtils.Day>) request.getAttribute("days");
        ArrayList<WebBusinessObject> typesList = (ArrayList<WebBusinessObject>) request.getAttribute("typesList");
        List<WebBusinessObject> userProjects = new ArrayList<WebBusinessObject>(ProjectMgr.getInstance().getOnArbitraryKeyOracle("1365240752318", "key2"));
        String type = (String) request.getAttribute("type");
        String reportType = request.getAttribute("reportType") != null ? (String) request.getAttribute("reportType") : "";
        Integer selectedYear = (Integer) request.getAttribute("selectedYear");
        Integer selectedMonth = (Integer) request.getAttribute("selectedMonth");
        
        String selectedDate =request.getAttribute("selectedDate")==null? "":(String)request.getAttribute("selectedDate");
        
        //-- get previligies list
          WebBusinessObject userWbo = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
          GroupPrevMgr groupPrevMgr = GroupPrevMgr.getInstance();
        Vector groupPrev = groupPrev = groupPrevMgr.getOnArbitraryKey(userWbo.getAttribute("groupID").toString(), "key1");
        ArrayList<String> userPrevList = new ArrayList<String>();
        WebBusinessObject wbo;
        for (int i = 0; i < groupPrev.size(); i++) {
            wbo = (WebBusinessObject) groupPrev.get(i);
            userPrevList.add((String) wbo.getAttribute("prevCode"));
        }

        //--
        Calendar calendar = Calendar.getInstance();
        String timeFormat = "yyyy/MM/dd HH:mm";
        SimpleDateFormat sdf = new SimpleDateFormat(timeFormat);
        String nowTime = sdf.format(calendar.getTime());
        String future=(String )request.getAttribute("future")==null?"0":(String )request.getAttribute("future");
        String cMode = (String) request.getSession().getAttribute("currentMode");
        String stat = cMode, align = null, dir = null;
        String PL, titleRow, xAlign, cared, plsEntrCmmnt, nRnD, viewApntmntWthn, mnth, yr, typ, all, updt, gud;
	String sDn, futr, tDo, dFllwUp, nglctd, clntFllwUp, clnt, cmmnt, nDir, nt, lstApp, target, mechanism, Adate, call, meeting, place, save, Aalign, ndir, mobile;
        int xAxis, yAxis;
        if (stat.equals("En")) {
            xAxis = 0;
            yAxis = 0;
            align = "center";
            dir = "LTR";
            ndir = "RTL";
            PL = "Customer " + (reportType.equals("call") ? "Calls" : "Appoientment");
            titleRow = "Client Name";
            xAlign = "right";
	    cared = " CARED ";
	    plsEntrCmmnt = " Please, Enter Comment ";
	    nRnD = " Appointment Not Saved Or The Client Is Not Distributed ";
	    viewApntmntWthn = " INTERVAL ";
	    mnth = " MONTH ";
	    yr = " YEAR ";
	    typ = " TYPE ";
	    all = " ALL ";
	    updt = " UPDATE ";
	    gud = " Guide ";
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
            mobile = "Mobile";
        } else {
            xAxis = 1100;
            yAxis = 0;
            align = "center";
            dir = "RTL";
            ndir = "LTR";
            PL = (reportType.equals("call") ? "مكالمات" : "مقابلات") + " العملاء";
            titleRow = "اسم العميل";
            xAlign = "left";
	    cared = " معتنى بها ";
	    plsEntrCmmnt = " من فضلك, أدخل تعليق ";
	    nRnD = " لم يتم التسجيل أو العميل غير موزع ";
	    viewApntmntWthn = " خلال ";
	    mnth = " شهر ";
	    yr = " سنة ";
	    typ = " النوع ";
	    all = " الكل ";
	    updt = " تحديث ";
	    gud = " الدليل ";
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
            mobile = "الموبايل";
        }
    %>
    <head>
        <link rel="stylesheet" href="js/custom_popup/jquery-ui.css" />
        
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script src="js/custom_popup/jquery-ui.js"></script>
        <script src="js/jquery-ui.js" type="text/javascript"></script>

        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.easing.1.3.js"></script>

        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.slider.js"></script> 
        
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery-ui-timepicker-addon.css"/>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>
        
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        
        
        <script type="text/javascript" src="js/msdropdown/jquery.dd.min.js"></script>
        
        
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css">
        <link rel="stylesheet" type="text/css" href="css/msdropdown/dd.css" />
        
        <link rel="stylesheet" type="text/css" href="css/tooltip.css"/>
        
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        
        
<!-- Start of Async Callbell Code 
<script>
  window.callbellSettings = {
    token: "9UimfvNQMoED7TTCwSAA4THA"
  };
</script>
<script>
  (function(){var w=window;var ic=w.callbell;if(typeof ic==="function"){ic('reattach_activator');ic('update',callbellSettings);}else{var d=document;var i=function(){i.c(arguments)};i.q=[];i.c=function(args){i.q.push(args)};w.Callbell=i;var l=function(){var s=d.createElement('script');s.type='text/javascript';s.async=true;s.src='https://dash.callbell.eu/include/'+window.callbellSettings.token+'.js';var x=d.getElementsByTagName('script')[0];x.parentNode.insertBefore(s,x);};if(w.attachEvent){w.attachEvent('onload',l);}else{w.addEventListener('load',l,false);}}})()
</script>
 End of Async Callbell Code -->



        <style>
             .table td {border: none; padding-bottom: 10px;}
             
            .switch {
                position: relative;
                display: inline-block;
                width: 30px;
                height: 20px;
            }

            /* Hide default HTML checkbox */
            .switch input {display:none;}

            /* The slider */
            .slider {
                position: absolute;
                cursor: pointer;
                top: 0px;
                left: 0;
                right: 0;
                bottom: -5;
                background-color: #ccc;
                -webkit-transition: .4s;
                transition: .4s;
            }

            .slider:before {
                position: absolute;
                content: "";
                height: 20px;
                width: 12px;
                top: 2px;
                left: 4px;
                bottom: 4px;
                background-color: white;
                -webkit-transition: .4s;
                transition: .4s;
            }

            input:checked + .slider {
                background-color: #2196F3;
            }

            input:focus + .slider {
                box-shadow: 0 0 1px #2196F3;
            }

            input:checked + .slider:before {
                -webkit-transform: translateX(12px);
                -ms-transform: translateX(12px);
                transform: translateX(12px);
            }

            /* Rounded sliders */
            .slider.round {
                border-radius: 20px;
            }

            .slider.round:before {
                border-radius: 50%;
            }
            body { font-size: 62.5%; }
            label, input { display:block; }
            input.text { margin-bottom:12px; width:95%; padding: .4em; }
            fieldset { padding:0; border:0; margin-top:25px; }
            h1 { font-size: 1.2em; margin: .6em 0; }
            div#users-contain { width: 350px; margin: 20px 0; }
            div#users-contain table { margin: 1em 0; border-collapse: collapse; width: 100%; }
            div#users-contain table td, div#users-contain table th { border: 1px solid #eee; padding: .6em 10px; text-align: left; }
            .ui-dialog .ui-state-error { padding: .3em; }
            .validateTips { border: 1px solid transparent; padding: 0.3em; }

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
        </style>
        <script type="text/javascript">
            $body = $("body");

            $(document).on({
                ajaxStart: function () {
                    $body.addClass("loading");
                },
                ajaxStop: function () {
                    $body.removeClass("loading");
                }
            });
	    $(document).ready(function(){
		$("#lstApp").attr('checked', false);
                
                $('.login-input').datetimepicker({
                    minDate: 0,
                    changeMonth: true,
                    changeYear: true,
                    timeFormat: 'HH:mm',
                    dateFormat: 'yy/mm/dd'
                }).attr('readonly', 'readonly');
                 //$('.login-input').datepicker("setDate", currentDate);
	    });
            
            function popupMyClientAppointments(clientID) {
                var divTag = $("#appointmentsNew");
                $.ajax({
                    type: "post",
                    url: '<%=context%>/AppointmentServlet?op=getClientAppointments',
                    data: {
                        clientID:clientID,
                        type: 'personal'
                    }, success: function (data) {
                        divTag.html(data).dialog({
                            modal: true,
                            title: "متابعاتي",
                            show: "fade",
                            hide: "explode",
                            width: 950,
                            position: {
                                my: 'center',
                                at: 'center'
                            }, buttons: {
                                'Close': function () {
                                    $(this).dialog('close');
                                }
                            }
                        }).dialog('open');
                        
                        $('#clientAppointmentsPopup').dataTable({
                            bJQueryUI: true,
                            "bPaginate": false,
                            "bProcessing": true,
                            "aaSorting": [[ 1, "desc" ]],
                            "bFilter": false
                        }).fadeIn(2000);
                    }, error: function (data) {
                        alert(data);
                    }
                });
            }
            
            function  showfuturetasks(event, mainsrc) {
                var allTds = $(".imageName");
                var i = 0;
                var tglStatue = $(".tgl").attr('name');
                if (tglStatue == 'off') {
                    for (i; i < allTds.length; i++) {
                        if ($(allTds[i]).attr('src').indexOf(mainsrc) === -1) {
                            allTds[i].style.display = 'none';
                        } else {
                            allTds[i].style.display = 'block';
                        }
                    }
                    $(".tgl").attr('name', 'on');
                    tglStatue = 'on';
                } else if (tglStatue == 'on') {
                    for (i; i < allTds.length; i++) {
                        allTds[i].style.display = 'block';
                    }
                    $(".tgl").attr('name', 'off');
                    tglStatue = 'off';
                }
            }

            function  showToDayTommorowTasks(event, mainsrc) {
                var allImg = $(".imageName");
                var i = 0;
                var tglStatue = $(".tglToday").attr('name');

                var today = new Date();
                var dd = today.getDate();
                var mm = today.getMonth() + 1;
                var yyyy = today.getFullYear();
                if (dd < 10) {
                    dd = '0' + dd;
                }
                if (mm < 10) {
                    mm = '0' + mm;
                }
                var toTay = dd + '/' + mm + '/' + yyyy;

                if (tglStatue == 'off') {
                    for (i; i < allImg.length; i++) {
                        var imgDate = $(allImg[i]).attr('id').split(" ", 1);
                        if ($(allImg[i]).attr('src').indexOf(mainsrc) === -1) {
                            allImg[i].style.display = 'none';
                        } else {
                            if (imgDate == toTay) {
                                allImg[i].style.display = 'block';
                            } else {
                                allImg[i].style.display = 'none';
                            }
                        }
                    }
                    $(".tglToday").attr('name', 'on');
                    tglStatue = 'on';
                } else if (tglStatue == 'on') {
                    for (i; i < allImg.length; i++) {
                        allImg[i].style.display = 'block';
                    }
                    $(".tglToday").attr('name', 'off');
                    tglStatue = 'off';
                }
            }

            function showCalendar(obj) {
                var selectedMonth = document.getElementById("selectedMonth").value;
                var selectedYear = document.getElementById("selectedYear").value;
                document.part_form.action = "<%=context%>/CalendarServlet?op=<%=reportType.equals("call") ? "getUsersCallsCalendar" : reportType.equals("meeting") ? "getUsersMeetingsCalendar" : "getAppointmentsForUser"%>&selectedYear=" + selectedYear + "&selectedMonth=" + selectedMonth;
                document.part_form.submit();
            }
            function openDailog(clientId, clientName, date) {
                var divTag = $("<div></div>");
                console.log("ggggggggg");
                $.ajax({
                    type: "post",
                    url: '<%=context%>/AppointmentServlet?op=showAppointmentsForClient',
                    data: {
                        clientId: clientId,
                        date: date,
                        clientName: clientName
                    },
                    success: function (data) {
                        divTag.html(data)
                                .dialog({
                                    modal: true,
                                    title: clientName,
                                    show: "blind",
                                    hide: "explode",
                                    width: 600,
                                    position: {
                                        my: 'center',
                                        at: 'center'
                                    },
                                    buttons: {
                                        Ok: function () {
                                            //$(this).dialog('destroy');
                                            location.reload();
                                            //popupAddPlanningAppointment(clientId);
                                            //openDailog(clientId, clientName, date)
                                        }
                                    }

                                })
                                .dialog('open');
                    }
                });
            }
            function openWindow(url) {
                var win = window.open(url, "clientDetails", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=no, copyhistory=no, width=790, height=600");
                win.focus();
            }
            function showComment(id) {
                $("#commentText" + id).hide();
                $("#commentDiv" + id).show();
            }
            function closeComment(id) {
                $("#commentText" + id).show();
                $("#commentDiv" + id).hide();
            }
            function updateComment(id, type) {
                var comment = $("#commentValue" + id).val().trim();
                if (comment !== '') {
                    $.ajax({
                        type: "post",
                        url: "<%=context%>/AppointmentServlet?op=appointmentDone",
                        data: {
                            appointmentID: id,
                            comment: comment
                        },
                        success: function (jsonString) {
                            var info = $.parseJSON(jsonString);
			    var cared = ' <%=cared%> ';
                            if (info.status === 'ok') {
                                $("#commentText" + id).html(comment);
                                $("#popup-title-icon" + id).attr("src", "images/icons/calendar_circle_green.png");
                                $("#popup-title-text" + id).html(type + cared);
                                closeComment(id);
                            }
                        }, error: function (jsonString) {
                        }
                    });
                } else {
		    var plsEntrCmmnt = ' <%=plsEntrCmmnt%> ';
                    alert(plsEntrCmmnt);
                    $("#commentValue" + id).focus();
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
            
            
            function popupClientAppointments(clientID) {
                var divTag = $("#appointments");
                $.ajax({
                    type: "post",
                    url: '<%=context%>/AppointmentServlet?op=getClientAppointments',
                    data: {
                        clientID: clientID
                    },
                    success: function (data) {
                        divTag.html(data).dialog({
                            modal: true,
                            title: "متابعات العميل",
                            show: "fade",
                            hide: "explode",
                            width: 950,
                            position: {
                                my: 'center',
                                at: 'center'
                            },
                            buttons: {
                                'Close': function () {
                                    $(this).dialog('close');
                                }
                            }
                        }).dialog('open');
                        $('#clientAppointmentsPopup').dataTable({
                            bJQueryUI: true,
                            "bPaginate": false,
                            "bProcessing": true,
                            "aaSorting": [[ 1, "desc" ]],
                            "bFilter": false
                        }).fadeIn(2000);
                        },
                    error: function (data) {
                        alert(data);
                    }
                });
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
                //} else {
                    //$("#palnningTitleMsg").css("color", "white");
                    //$("#palnningTitleMsg").text("أدخل عنوان المقابلة");
               // }
            }
	    
	    function getLastComment(clientID){
		var lstApp = $("#lstApp").val();
		if(lstApp == 'off'){
		    $("#lstApp").val('on');
		    $('#lstApp').attr('checked', true);
		    $.ajax({
                        type: "post",
                        url: "<%=context%>/CommentsServlet?op=getLastComment",
                        data: {
                            clientID: clientID,
                        },
                        success: function (jsonString) {
                            var eqpEmpInfo = $.parseJSON(jsonString);
			    
			    $.each(eqpEmpInfo, function () {
				$("label#palnningLstComment").text(this.lstComment);
				$("input#LstCommentId").val(this.appID);
			    });
                            $("tr#lstCmntTr").fadeIn();
                            /*$('.login-input').datetimepicker({
                                minDate: 0,
                                changeMonth: true,
                                changeYear: true,
                                timeFormat: 'HH:mm',
                                dateFormat: 'yy/mm/dd'
                            });*/
                        }
                    });
		} else if (lstApp == 'on') {
		    $("#lstApp").val('off');
		    $("#lstApp").attr('checked', false);
		    $("tr#lstCmntTr").fadeOut();
		}
	    }
            function closePopup(obj) {
                //$('#appointment_content' + clientId).css("display", "none");
                $(obj).parent().parent().bPopup().close();
                $("#lstApp").val('off');
                $("#lstApp").attr('checked', false);
                $("label#palnningLstComment").text("");
            }
            function openInNewWindow(url) {
                var win = window.open(url, '_blank');
                win.focus();
            }
        </script>
        <style type="text/css">
            /* Start by setting display:none to make this hidden.
            Then we position it in relation to the viewport window
            with position:fixed. Width, height, top and left speak
            for themselves. Background we set to 80% white with
            our animation centered, and no-repeating */
            .modal {
                display:    none;
                position:   fixed;
                z-index:    1000;
                top:        0;
                left:       0;
                height:     100%;
                width:      135%;
                background: rgba( 255, 255, 255, .8 ) 
                    url('images/loading.gif') 
                    50% 50% 
                    no-repeat;
            }
            
            

            /* When the body has the loading class, we turn
               the scrollbar off with overflow:hidden */
            body.loading {
                overflow: hidden;   
            }

            /* Anytime the body has the loading class, our
               modal element will be visible */
            body.loading .modal {
                display: none;
            }
        </style>
    </head>
    <body style="overflow-x: hidden;" onload="window.scrollTo(<%=xAxis%>,<%=yAxis%>)">
        <div style="width: 100%"></div>
        <div id="appointmentsNew" style="display: none;">
        </div>
        <div style="width: 100%; text-align: center;">
        
            <a href="<%=context%>/CalendarServlet?op=showCalendar" title="Calendar">
                <img src="images/icons/calendar.png"/>
            </a>
                
            <a href="<%=context%>/CalendarServlet?op=getFutureAppToEmpExcel&type=user&selectedYear=<%=selectedYear%>&selectedMonth=<%=selectedMonth%>&future=<%=future%>" title="Future Appointment">
                <button type="button" style="color: #000;font-size:15px;font-weight:bold; width: 90px; height: 30px; vertical-align: top;"
                        title="Export Future Appointments to Excel">Excel &nbsp;<img height="15" src="images/icons/excel.png" />
                </button>
            </a>
        </div>
        <FORM NAME="part_form" METHOD="POST">
            <TABLE dir="<%=dir%>" CELLPADDING="0" CELLSPACING="0" STYLE="border: 2px solid #d3d5d4; width: 100%;">
                <TR style="width: 100%;">
		    <TD STYLE="text-align: <%=dir%>; color: blue; font-size: 14px; border-left-width: 0px; width: 50%;" nowrap CLASS="silver_even_main" >
                        <TABLE dir="<%=dir%>" CELLPADDING="0" CELLSPACING="0" STYLE="border: 2px solid #d3d5d4; width: 100%;">
			    <tr>
				<TD STYLE="text-align: <%=dir%>; color: blue; font-size: 16px; border-left-width: 0px; width: 12%;" CLASS="silver_even_main" >
				    <DIV> 
					<font size="3">
					     <%=viewApntmntWthn%> :
					</font>
				    </DIV>
				</TD>

				<TD STYLE="text-align: <%=dir%>; color: black; font-size: 14px; border-left-width: 0px; width: 12%;" CLASS="silver_even_main" >
				    <font size="2">
					 <%=mnth%> : 
				    </font>
				</TD>
				<TD STYLE="text-align: <%=dir%>; color: blue; font-size: 14px; border-left-width: 0px; width: 13%;" nowrap CLASS="silver_even_main" >
				    <select id="selectedMonth" name="selectedMonth" style="font-size: 14px; width: 100%">
					<% for (CalendarUtils.Month month : months) {%>
					<option style="font-weight: bold" value="<%=month.getNumber()%>" <%= (month.getNumber() == selectedMonth) ? "selected" : ""%>><%=month.getName()%></option>
					<% } %>
				    </select>
				</TD>
				<TD STYLE="text-align: <%=dir%>; color: black; font-size: 14px; border-left-width: 0px; width: 12%;" nowrap CLASS="silver_even_main" >
				    <font size="2">
					 <%=yr%> : 
				    </font>
				</TD>
				<TD STYLE="text-align: <%=dir%>; color: blue; font-size: 14px; border-left-width: 0px; width: 13%;" nowrap CLASS="silver_even_main" >
				    <select id="selectedYear" name="selectedYear" style="font-size: 14px; width: 100%">
					<% for (Integer year : years) {%>
					<option style="font-weight: bold" value="<%=year%>" <%= (year.equals(selectedYear)) ? "selected" : ""%>><%=year%></option>
					<% }%>
				    </select>
				</TD>
				<TD STYLE="text-align: <%=dir%>; color: black; font-size: 14px; border-left-width: 0px; width: 12%;" nowrap CLASS="silver_even_main" >
				    <font size="2">
					 <%=typ%> : 
				    </font>
				</TD>
				<TD STYLE="text-align: <%=dir%>; color: blue; font-size: 14px; border-left-width: 0px; width: 13%;" nowrap CLASS="silver_even_main" >
				    <select id="type" name="type" style="font-size: 14px; width: 100%;">
					<option value=""> <%=all%> </option>
					<sw:WBOOptionList wboList="<%=typesList%>" displayAttribute="projectName" valueAttribute="projectName" scrollToValue="<%=type%>" />
				    </select>
                                    <input type="hidden" id="reportType" name="reportType" value="<%=reportType%>"/>
				</TD>
				<TD STYLE="text-align: <%=dir%>; color: blue; font-size: 14px; border-left-width: 0px; width: 13%;" nowrap CLASS="silver_even_main" >
				    <button style="width: 100%" type="button" onclick="showCalendar(this)"><b style="font-weight: bold; font-size: 14px; vertical-align: middle">
					<font size="2">
					     <%=updt%> 
					</font>
					<img src="images/icons/refresh.png" width="20" height="20" style="vertical-align: middle"/>
				    </button>
				</TD>
			    </TR>
			</TABLE>
		    </td>
		    <TD STYLE="text-align: <%=dir%>; color: blue; font-size: 14px; border-left-width: 0px; width: 50%;" nowrap CLASS="silver_even_main" >
			<TABLE dir="<%=dir%>" CELLPADDING="0" CELLSPACING="0" STYLE="border: 2px solid #d3d5d4; width: 100%;">
			    <TR style="width: 100%;">
				<TD STYLE="text-align: <%=dir%>; color: purple; font-size: 14px; padding-left: 10px; border-left-width: 0px; width: 19%;" nowrap CLASS="silver_even_main" >
				    <img src="images/icons/<%=CRMConstants.APPOINTMENT_STATUS_IMAGES.get(CRMConstants.APPOINTMENT_STATUS_DONE)%>" width="20" height="20" style="vertical-align: middle"/>
				    <font size="1">
					 <%=sDn%> 
				    </font>
				</TD>
                                
				<TD STYLE="text-align: <%=dir%>; color: purple; font-size: 14px; border-left-width: 0px; width: 19%;" nowrap CLASS="silver_even_main" >
				    <TABLE style="width: 100%">
					<TR style="width: 100%">
					    <TD style="border: none ; width: 34%;">
						<label class="switch">
						    <input class="tgl" type="checkbox" onclick="showfuturetasks(event, 'calendar_circle_yellow');" name="off">
						    <div class="slider"></div>
						</label>
					    </TD>

					    <TD style="border: none ;  width: 33%;">
						<img src="images/icons/<%=CRMConstants.APPOINTMENT_STATUS_IMAGES.get(CRMConstants.APPOINTMENT_STATUS_OPEN)%>" width="20" height="20" />
					    </TD>

					    <TD style="border: none ;  width: 33%; color: purple;">
						<font size="1">
						     <%=futr%> 
						</font>
					    </TD>
					</TR>
				    </TABLE>
				</TD>
                                
				<TD STYLE="text-align: <%=dir%>; color: purple; font-size: 14px; border-left-width: 0px; width: 19%;" nowrap CLASS="silver_even_main" >
				    <TABLE style="width: 100%">
					<TR style="width: 100%">
					    <TD style="border: none ; width: 34%">
						<label class="switch">
						    <input class="tglToday" type="checkbox" onclick="showToDayTommorowTasks(event, 'calendar_circle_yellow');" name="off">
						    <div class="slider"></div>
						</label>
					    </TD>
					    <TD style="border: none ; width: 33%">
						<img src="images/icons/<%=CRMConstants.APPOINTMENT_STATUS_IMAGES.get(CRMConstants.APPOINTMENT_STATUS_OPEN)%>" width="20" height="20" />
					    </TD>
					    <TD style="border: none ; width: 33%; color: purple;">
						<font size="1">
						     <%=tDo%>
						</font>
					    </TD>
					</TR>
				    </TABLE>
				</TD>
                                
				<TD STYLE="text-align: <%=dir%>; color: purple; font-size: 14px; border-left-width: 0px; width: 19%;" nowrap CLASS="silver_even_main" >
				    <img src="images/icons/<%=CRMConstants.APPOINTMENT_STATUS_IMAGES.get(CRMConstants.APPOINTMENT_STATUS_CARED)%>" width="20" height="20" style="vertical-align: middle"/>
				    <font size="1">
					 <%=cared%> 
				    </font> 
				</TD>
				<%--<TD STYLE="text-align: <%=dir%>; color: purple; font-size: 14px; border-left-width: 0px; width: 16%;" nowrap CLASS="silver_even_main" >
				    <img src="images/icons/<%=CRMConstants.APPOINTMENT_STATUS_IMAGES.get(CRMConstants.APPOINTMENT_STATUS_DIRECT_FOLLOW_UP)%>" width="20" height="20" style="vertical-align: middle"/>
				    <font size="1">
					 <%=dFllwUp%> 
				    </font>
				</TD>--%>
				<TD STYLE="text-align: <%=dir%>; color: purple; font-size: 14px; border-left-width: 0px; width: 20%;" nowrap CLASS="silver_even_main" >
				    <img src="images/icons/<%=CRMConstants.APPOINTMENT_STATUS_IMAGES.get(CRMConstants.APPOINTMENT_STATUS_NEGLECTED)%>" width="20" height="20" style="vertical-align: middle"/>
				    <font size="1">
					 <%=nglctd%> 
				    </font>
				</TD>
				<%--<TD STYLE="text-align: right; color: purple; font-size: 14px; padding-left: 10px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
				    <img src="images/icons/<%=CRMConstants.APPOINTMENT_STATUS_IMAGES.get(CRMConstants.APPOINTMENT_STATUS_IMAGE_DEFAULT)%>" width="20" height="20" style="vertical-align: middle"/>
				    لا يوجد
				</TD>--%>
			    </TR>
			</TABLE>
		    </TD>
		</tr>
		<TR dir="<%=dir%>" style="width: 100%; border: none;">
		    <td dir="<%=dir%>" colspan="2" style=" border: none; width: 100%;">
                        <font size="1" dir="<%=dir%>" style="float: <%=xAlign%>; color: blue; text-align: <%=dir%>">
			     <%=nt%> 
			</font>
                    </TD>
                </TR>
            </TABLE>
            <%if(future.equalsIgnoreCase("0") && reportType.equals("meeting")){%>
            <p style="font-size: large;font-weight: 600;">During the month During The Month<img width="35px" height="35px" src="images/dialogs/handshake.png"/></p>
            <%}else if(future.equalsIgnoreCase("yes")){%>
            <p style="font-size: large;font-weight: 600;">Calls & Visits in The Future<img width="35px" height="35px" src="images/future_appointment.png"/></p>
            <%}else if(future.equalsIgnoreCase("no")){%>
            <p style="font-size: large;font-weight: 600;"> During the month  in The Past <img width="35px" height="35px" src="images/appointment_expired.png"/></p>
            <%}else if(future.equalsIgnoreCase("today")){%>
            <p style="font-size: large;font-weight: 600;">Calls & Visits in Day <img width="35px" height="35px" src="images/future_appointment1.png"/></p>
            <%}else if(future.equalsIgnoreCase("selectedDate")){%>
            <p style="font-size: large;font-weight: 600;">Calls & Visits in Day: <%=selectedDate%><img width="35px" height="35px" src="images/future_appointment1.png"/></p>
            <%}%>
            <br>
            <TABLE ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="98%" CELLPADDING="0" CELLSPACING="0" STYLE="border: 2px solid #d3d5d4">
                <TR>
                    <TD class="blueBorder blueHeaderTD" COLSPAN="<%=(days.size() + 4)%>" bgcolor="#669900" STYLE="text-align:center;color:white;font-size:14px">
                        <DIV>
                            <B>
                                <%=PL%>
                            </B>
                        </DIV>
                    </TD>
                </TR>
                <TR>
                    <TD rowspan="2" STYLE="text-align: center" BGCOLOR="#DDDD00" nowrap  CLASS="silver_odd_main">
                        <b><font size="2" color="#000080" style="text-align: center;">#</font></b>
                    </TD>
                    <TD rowspan="2" STYLE="text-align: center" BGCOLOR="#DDDD00" nowrap  CLASS="silver_odd_main">
                        <b><font size="2" color="#000080" style="text-align: center;"></font></b>
                    </TD>
                    <TD rowspan="2" class="silver_footer" bgcolor="#808000" STYLE="width: 200px;text-align:center;color:black;font-size:14px">
                        <b><font color="#000080" style="text-align: center;"><%=titleRow%></font></b>
                    </TD>
                    <TD rowspan="2" class="silver_footer" bgcolor="#808000" STYLE="width: 200px;text-align:center;color:black;font-size:14px">
                        <b><font color="#000080" style="text-align: center;"><%=mobile%></font></b>
                    </TD>
                </TR>
                <TR>
                    <% for (Day day : days) {%>
                    <TD STYLE="text-align: center" BGCOLOR="#DDDD00" nowrap  CLASS="silver_odd_main dateTd" name="<%=day.getDay()%>" id="<%=day.getDay()%>">
                        <p class="dateTdChild"><font color="red"><%=day.getName()%></font>
                            <br>
                            <B><%=day.getDay()%></B></P>
                    </TD>
                    <%}%>
                </TR>
                <%
                    String clientId, clientName, currentStatusCode, imageName, bgColorm;
                    String cursor, clickAction, date = "";
                    Integer timeRemaining;
                    Map<String, WebBusinessObject> dayInfo;
                    WebBusinessObject appointment;
                    int flipper = 0;
                    for (Map.Entry<String, Map<String, WebBusinessObject>> entry : data.entrySet()) {
                        clientId = entry.getKey().split("@@")[0];
                        clientName = entry.getKey().split("@@")[1];
                        if(Character.isWhitespace(clientName.charAt(0))){
                            clientName = clientName.substring(1, clientName.length());
                        }
                        dayInfo = entry.getValue();
                        if ((flipper % 2) == 1) {
                            bgColorm = "silver_odd_main";
                        } else {
                            bgColorm = "silver_even_main";
                        }
                        flipper++;
                %>
                <TR>
                    <TD STYLE="text-align: center" BGCOLOR="#DDDD00" nowrap  CLASS="<%=bgColorm%>" >
                        <DIV>
                            <%=flipper%>
                        </DIV>
                    </TD>
                    <td>
                        <div style="padding: 2px 2px 2px 0px; border-right-width: 0px;">
                            <%--<a href="#" onclick="JavaScript: popupAddPlanningAppointment(<%=clientId%>);"><img style="height:20px;" src="images/dialogs/planning.png" title="Plan Appointment"/></a>--%>
                               <% if (userPrevList.contains("LIST_APPOINTMENTS")) {%>
                            <a href="JavaScript: popupClientAppointments('<%=clientId%>');">
                                <img class="icon" src="images/icons/calendar-256.png" height="20" style="float: left;" title="Client Appointments"/>
                            </a>
                                <%}else{%>
                     <a href="#"><img style="height:20px;" src="images/icons/my-appointments.png" title="My Appointments" onclick="JavaScript: popupMyClientAppointments( <%=clientId%>);"/></a>
                      <%}%>
                        </div>
                        <div id="appointment_content<%=clientId%>" style="width: 40% !important;display: none;position: fixed"><!--class="popup_appointment" -->
                            <div style="clear: both;margin-left: 88%;margin-top: 0px;margin-bottom: -38px;z-index: -10000000;">
                                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                                     -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                                     box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                                     -webkit-border-radius: 100px;
                                     -moz-border-radius: 100px;
                                     border-radius: 100px;" onclick="closePopup(this)"/>
                            </div>
                            <div class="login" style="width: 85%;margin-bottom: 10px;margin-left: auto;margin-right: auto;">
                                <h1> <%=clntFllwUp%> </h1>
				
				<div style="text-align: <%=xAlign%>;margin-left: 2%;margin-right: auto;" > 
				    <span id="timer" style="font-size: 30px; font-weight: bolder; color: black; padding-left: 20px;"></span>
				    <button type="button" onclick="javascript: saveAppoientment(this, <%=clientId%>)" style="font-size: 14px; font-weight: bold; width: 150px"><%=save%><img style="height:20px; width: 20px" src="images/icons/follow_up.png" title="Follow up"/></button>
				</div>
				
                                <table class="table" style="width:100%; border: none" dir="<%=ndir%>">
                                    <TR style="display: none;">
					<TD width="85%"style="text-align:<%=Aalign%>;">
					    <%=lstApp%>
					</TD>
					<TD width="15%" style="color:#f1f1f1; float: left; font-size: 16px;font-weight: bold; text-align:<%=Aalign%>;">
					    <input name="note" type="checkbox" value="off" id="lstApp" style="float: left;" onchange="getLastComment('<%=clientId%>')">
					</TD>
				    </TR>
                                    <tr>
                                        <td width="85%"style="text-align:<%=Aalign%>;">
                                            <b id="appClientName"><%=clientName%></b>
                                        </td>
                                        <td width="15%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 30%;" >
                                             <%=clnt%>                            
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="text-align:<%=Aalign%>;width: 85%;">
                                            <select id="palnningTitle<%=clientId%>" name="palnningTitle" STYLE="width:200px;font-size: medium; font-weight: bold;">
                                                <OPTION value="FOLLOW UP">FOLLOW UP</OPTION>
                                            </select>
                                            <label id="palnningTitleMsg"></label>
                                        </td>
                                        <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 15%;"> <%=target%> </td>
                                    </tr>
                                    <tr>
                                        <td style="text-align:<%=Aalign%>;width: 85%;">
                                            <label><img src="images/dialogs/phone.png" alt="phone" width="24px"><%=call%> </label>
                                            <input name="note" type="radio" value="call" checked="" id="note" style="float:<%=Aalign%>" >

                                            <label><img src="images/dialogs/handshake.png" alt="meeting" width="24px"> <%=meeting%></label>
                                            <input name="note" type="radio" value="meeting" id="note" style="margin-right: 10px; float:<%=Aalign%>;">
                                        </td>
                                        <td style="color:#f1f1f1;   font-size: 16px;width: 15%;"><%=mechanism%> </td>
                                        
                                    </tr>
                                    <tr>
                                        <td style="text-align:<%=Aalign%>;width: 85%;" >
                                            <input class="login-input" name="palnningDate<%=clientId%>" id="palnningDate<%=clientId%>" type="text" size="50" maxlength="50" style="width:200px;font-size: medium; float: <%=Aalign%>" value="<%=nowTime%>"/>
                                        </td>
                                        <td style="color:#f1f1f1;font-size: 16px;font-weight: bold;width: 15%; text-align:  <%=Aalign%>"><%=Adate%></td>
                                    </tr>
                                    <tr>
                                        <td style="text-align:<%=Aalign%>;width: 85%;">
                                            <select id="appointmentPlace" name="appointmentPlace" style="margin-top: 7px;width:200px;font-size: medium;">
                                                <sw:WBOOptionList wboList='<%=userProjects%>' displayAttribute = "projectName" valueAttribute="projectName" />
                                                <option value="Other">Other</option>
                                            </select>
                                        </td>
                                        <td style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 15%;">
                                            <%=place%>
                                            <br>
                                        </td>
                                    </tr>
				    <tr id="lstCmntTr" style="display: none;">
                                        <td style="text-align:<%=Aalign%>;width: 85%;">
                                            <label id="palnningLstComment" style="font-weight: bold;"></label>
					    
					    <input id="LstCommentId" type="hidden" value="UL"/>
                                        </td>
                                        <td style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 15%;">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="text-align:<%=Aalign%>;width: 85%;">
                                            <textarea cols="26" rows="3" id="palnningComment">
                                            </textarea>
                                        </td>
                                        <td style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 15%;">
                                             <%=cmmnt%> 
                                        </td>
                                    </tr>
                                </table>
					
				<div style="text-align: <%=xAlign%>;margin-left: 2%;margin-right: auto;" > 
				    <span id="timer" style="font-size: 30px; font-weight: bolder; color: black; padding-left: 20px;"></span>
				    <button type="button" onclick="javascript: saveAppoientment(this, <%=clientId%>)" style="font-size: 14px; font-weight: bold; width: 150px"><%=save%><img style="height:20px; width: 20px" src="images/icons/follow_up.png" title="Follow up"/></button>
				</div>
                                <div id="progress" style="display: none;">
                                    <img src="images/Loading2.gif" width="32px" height="32px;" style="background-repeat: no-repeat;margin-left: auto;margin-right: auto"/>
                                </div>
                                <div style="margin: 0 auto;display: none; width: 90%;text-align: center;color: white;font-size: 16px;font-weight: bold" id="palnningMsg">تم إضافة المقابلة </>
                                </div>
                            </div>  
                        </div>
                    </TD>
                    <TD STYLE="text-align: center" BGCOLOR="#DDDD00" nowrap  CLASS="<%=bgColorm%>" >
                        <DIV>
                            <%--<a href="JavaScript: openInNewWindow('<%=context%>/ClientServlet?op=clientDetails&amp;clientId=<%=clientWbo.getAttribute("id")%>');">--%>
                            <a href="JavaScript: openInNewWindow('<%=context%>/ClientServlet?op=clientDetails&clientId=<%=clientId%>');"
                               title="Mobile No.: <%=clientMobile!= null && clientMobile.containsKey(clientId) ? clientMobile.get(clientId) : ""%>"><%=clientName%></a>
                        </DIV>
                    </TD>
                    <TD STYLE="text-align: center" BGCOLOR="#DDDD00" nowrap  CLASS="<%=bgColorm%>" >
                        <DIV>
                            <%=clientMobile!= null && clientMobile.containsKey(clientId) ? clientMobile.get(clientId) : ""%>
                        </DIV>
                    </TD>
                <DIV id="coloredcircles">
                    <%
                        for (Day day : days) {
                            imageName = CRMConstants.APPOINTMENT_STATUS_IMAGES.get(CRMConstants.APPOINTMENT_STATUS_IMAGE_DEFAULT);
                            cursor = "default";
                            clickAction = "";
                            appointment = dayInfo.get(day.getDay() + "");
                            if (appointment != null &&future.equals("yes")) {
                               
                                currentStatusCode = (String) appointment.getAttribute("currentStatusCode");
                                timeRemaining = Integer.parseInt((String) appointment.getAttribute("timeRemaining"));
                                  if (CRMConstants.APPOINTMENT_STATUS_DIRECT_FOLLOW_UP.equalsIgnoreCase(currentStatusCode)) {
                                    imageName = CRMConstants.APPOINTMENT_STATUS_IMAGES.get(CRMConstants.APPOINTMENT_STATUS_DIRECT_FOLLOW_UP);
                                } else if (timeRemaining >= -(12 * 60) && CRMConstants.APPOINTMENT_STATUS_OPEN.equalsIgnoreCase(currentStatusCode)) {
                                    imageName = CRMConstants.APPOINTMENT_STATUS_IMAGES.get(CRMConstants.APPOINTMENT_STATUS_OPEN);
                                } 
                                cursor = "hand";
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
                                clickAction = "JavaScript: openDailog('" + clientId + "', '" + clientName.toString().replace(" ", "") + "', " + "'" + selectedYear + "/" + (selectedMonth + 1) + "/" + day.getDay() + "');";
                            } 
                          else  if (appointment != null &&future.equals("no")) {
                               currentStatusCode = (String) appointment.getAttribute("currentStatusCode");
                                timeRemaining = Integer.parseInt((String) appointment.getAttribute("timeRemaining"));
                                if (CRMConstants.APPOINTMENT_STATUS_DONE.equalsIgnoreCase(currentStatusCode)) {
                                    imageName = CRMConstants.APPOINTMENT_STATUS_IMAGES.get(CRMConstants.APPOINTMENT_STATUS_DONE);
                                } else if (CRMConstants.APPOINTMENT_STATUS_CARED.equalsIgnoreCase(currentStatusCode)) {
                                    imageName = CRMConstants.APPOINTMENT_STATUS_IMAGES.get(CRMConstants.APPOINTMENT_STATUS_CARED);
                                } else if (CRMConstants.APPOINTMENT_STATUS_DIRECT_FOLLOW_UP.equalsIgnoreCase(currentStatusCode)) {
                                  imageName = CRMConstants.APPOINTMENT_STATUS_IMAGES.get(CRMConstants.APPOINTMENT_STATUS_DIRECT_FOLLOW_UP);

                                } else if (timeRemaining >= -(12 * 60) && CRMConstants.APPOINTMENT_STATUS_OPEN.equalsIgnoreCase(currentStatusCode)) {
                                  imageName = CRMConstants.APPOINTMENT_STATUS_IMAGES.get(CRMConstants.APPOINTMENT_STATUS_OPEN);

                                } else {
                                    imageName = CRMConstants.APPOINTMENT_STATUS_IMAGES.get(CRMConstants.APPOINTMENT_STATUS_NEGLECTED);
                                }

                                cursor = "hand";
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
                                clickAction = "JavaScript: openDailog('" + clientId + "', '" + clientName.toString().replace(" ", "") + "', " + "'" + selectedYear + "/" + (selectedMonth + 1) + "/" + day.getDay() + "');";
                            } 
                           else if (appointment != null) {
                                currentStatusCode = (String) appointment.getAttribute("currentStatusCode");
                                timeRemaining = Integer.parseInt((String) appointment.getAttribute("timeRemaining"));
                                if (CRMConstants.APPOINTMENT_STATUS_DONE.equalsIgnoreCase(currentStatusCode)) {
                                    imageName = CRMConstants.APPOINTMENT_STATUS_IMAGES.get(CRMConstants.APPOINTMENT_STATUS_DONE);
                                } else if (CRMConstants.APPOINTMENT_STATUS_CARED.equalsIgnoreCase(currentStatusCode)) {
                                    imageName = CRMConstants.APPOINTMENT_STATUS_IMAGES.get(CRMConstants.APPOINTMENT_STATUS_CARED);
                                } else if (CRMConstants.APPOINTMENT_STATUS_DIRECT_FOLLOW_UP.equalsIgnoreCase(currentStatusCode)) {
                                    imageName = CRMConstants.APPOINTMENT_STATUS_IMAGES.get(CRMConstants.APPOINTMENT_STATUS_DIRECT_FOLLOW_UP);
                                } else if (timeRemaining >= -(12 * 60) && CRMConstants.APPOINTMENT_STATUS_OPEN.equalsIgnoreCase(currentStatusCode)) {
                                    imageName = CRMConstants.APPOINTMENT_STATUS_IMAGES.get(CRMConstants.APPOINTMENT_STATUS_OPEN);
                                } else {
                                    imageName = CRMConstants.APPOINTMENT_STATUS_IMAGES.get(CRMConstants.APPOINTMENT_STATUS_NEGLECTED);
                                }

                                cursor = "hand";
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
                                clickAction = "JavaScript: openDailog('" + clientId + "', '" + clientName.toString().replace(" ", "") + "', " + "'" + selectedYear + "/" + (selectedMonth + 1) + "/" + day.getDay() + "');";
                            }
                            //SimpleDateFormat formatter = new SimpleDateFormat("dd");
                            //String noDay = formatter.format(date);
                    %>

                    <TD   id="<%=imageName%>" STYLE="text-align: center" BGCOLOR="#DDDD00" nowrap  CLASS="<%=bgColorm%> imageNametd" >
                        <% if(imageName != CRMConstants.APPOINTMENT_STATUS_IMAGES.get(CRMConstants.APPOINTMENT_STATUS_IMAGE_DEFAULT)){%>
                            <img class="imageName" id="<%=date%>" src="images/icons/<%=imageName%>" onclick="<%=clickAction%>" width="24" height="24" style="vertical-align: middle; cursor: <%=cursor%> ; display: block"/>
                        <%}%>
                    </TD>
                    <% }%>
                </DIV>
                <TR>
                    <% }%>
            </TABLE>
        </FORM>
        <div class="modal"><!-- Place at bottom of page --></div>
        <div id="appointments" style="display: none;"></div>
    </body>
</html>
