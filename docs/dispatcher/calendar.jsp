<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.clients.db_access.AppointmentMgr"%>
<%@page import="com.clients.db_access.CustomerGradesMgr"%>
<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*, com.contractor.db_access.*"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants, java.util.Hashtable"%>
<%@ page import="com.silkworm.common.TimeServices,com.silkworm.jsptags.*, java.lang.Integer"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page pageEncoding="UTF-8" %>

<html>
    <meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <meta HTTP-EQUIV="Expires" CONTENT="0">

    <%
        TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        Calendar eqpSchedulesCal = Calendar.getInstance();

        String context = metaMgr.getContext();
        String cMode = (String) request.getSession().getAttribute("currentMode");

        Calendar cal = Calendar.getInstance();
        String timeFormat = "yyyy/MM/dd HH:mm";
        SimpleDateFormat sdf = new SimpleDateFormat(timeFormat);
        String nowTime = sdf.format(cal.getTime());
        String stat = cMode;
        String startPeriodDayName = "";
        String cellValue = "";
        Calendar calendar = Calendar.getInstance();
        int currentDay = calendar.get(calendar.DAY_OF_MONTH);
        int currentYear = calendar.get(calendar.YEAR);
        int currentMonth = calendar.get(calendar.MONTH);

        String[] monthName = {"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"};
        String[] dayName = {"Saturday", "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday"};
        String connectByRealEstate = metaMgr.getConnectByRealEstate();
        //Get Basic Data

        //Get Equipment Data
        //Get Month Data
        //GetEquipment Schedules
        int month = 0;
        int year = 0;
        int minDate = 0;
        int maxDate = 0;
        Calendar monthCal = Calendar.getInstance();
        year = monthCal.getTime().getYear();
        minDate = monthCal.getActualMinimum(monthCal.DATE);
        maxDate = monthCal.getActualMaximum(monthCal.DATE);

        java.sql.Date beginDate = new java.sql.Date(year, month, minDate);
        java.sql.Date endDate = new java.sql.Date(year, month, maxDate);

        HttpSession s = request.getSession();
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        String userId = (String) waUser.getAttribute("userId");

        Vector eqpSchedules = new Vector();
        AppointmentMgr appointmentMgr = AppointmentMgr.getInstance();
        eqpSchedules = appointmentMgr.getAppointmentsDates(userId, beginDate, endDate);

        Vector eqpSchedulesDays = new Vector();
        String user_id = (String) request.getAttribute("userId");
        for (int i = 0; i < eqpSchedules.size(); i++) {

            WebBusinessObject wbo = new WebBusinessObject();
            wbo = (WebBusinessObject) eqpSchedules.elementAt(i);
            java.sql.Date bDate = (java.sql.Date) wbo.getAttribute("date");

            eqpSchedulesCal.setTimeInMillis(bDate.getTime());
            eqpSchedulesDays.addElement(new Integer(eqpSchedulesCal.getTime().getDate()));
            System.out.println("Begin Date = " + bDate.toString());
            System.out.println("Date day month is " + eqpSchedulesCal.getTime().getDate());
        }

        //Calendar Calculation
        boolean gotCell = false;

        Calendar periodicalCalendar = Calendar.getInstance();
        Calendar beginPeriodCalendar = null;
        Calendar endPeriodCalendar = null;

        int date = 0;
        int day = 0;

        int calRowsNumber = 0;
        int reminder = 0;
        int startPeriodDay = 0;

        year = periodicalCalendar.getTime().getYear() + 1900;
        date = periodicalCalendar.getTime().getDate();

        minDate = periodicalCalendar.getActualMinimum(Calendar.DATE);
        maxDate = periodicalCalendar.getActualMaximum(Calendar.DATE);
        periodicalCalendar.set(periodicalCalendar.WEEK_OF_MONTH, 1);
        periodicalCalendar.set(periodicalCalendar.DATE, 1);
        startPeriodDay = periodicalCalendar.getTime().getDay();
        if (startPeriodDay == 6) {
            startPeriodDayName = dayName[0];
        } else {
            startPeriodDayName = dayName[startPeriodDay + 1];
        }

        calRowsNumber = maxDate / 7;
        reminder = maxDate % 7;

        if (reminder > 0) {
            calRowsNumber = calRowsNumber + 1;
        }

        if (startPeriodDay == 4 || (startPeriodDay == 5 && maxDate >= 30)) {
            calRowsNumber = calRowsNumber + 1;
        }

        //Page Language Defaults
        String align, dir, style, lang, langCode, cancel, equipments, noEqps, periods, title, between, sCancel, pageTitle, pageTitleTip;

        if (stat.equals("En")) {
            align = "center";
            dir = "LTR";
            style = "text-align:center";
            lang = "   &#1593;&#1585;&#1576;&#1610;    ";
            langCode = "Ar";
            cancel = "Cancel";
            equipments = "Equipments";
            noEqps = "The System has no equipments";
            periods = "Months";
            title = "Listing Equipment";
            between = "Maintenance Schedules during month of ";
            sCancel = "Cancel";
            pageTitle = "RPT-TIMETABLE-MNTNC-7";
            pageTitleTip = "Timetable Maintenance Report";
        } else {
            align = "center";
            dir = "RTL";
            style = "text-align:center";
            lang = "English";
            langCode = "En";
            cancel = "&#1575;&#1604;&#1593;&#1608;&#1583;&#1577;&nbsp; &#1575;&#1604;&#1609; &#1575;&#1604;&#1589;&#1601;&#1581;&#1577; &#1575;&#1604;&#1585;&#1574;&#1610;&#1587;&#1610;&#1577;";
            equipments = "الفنيين";
            noEqps = "&#1604;&#1575;&#1610;&#1608;&#1580;&#1583; &#1605;&#1593;&#1583;&#1575;&#1578; &#1601;&#1610; &#1575;&#1604;&#1606;&#1592;&#1575;&#1605;";
            periods = "&#1575;&#1604;&#1571;&#1588;&#1607;&#1585;";
            title = "&#1593;&#1585;&#1590; &#1580;&#1583;&#1575;&#1608;&#1604; &#1589;&#1610;&#1575;&#1606;&#1577; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577;";
            between = "&#1582;&#1604;&#1575;&#1604; &#1588;&#1607;&#1585;";
            sCancel = "&#1575;&#1604;&#1594;&#1575;&#1569;";
            pageTitle = "RPT-TIMETABLE-MNTNC-7";
            pageTitleTip = "&#1578;&#1602;&#1585;&#1610;&#1585; &#1575;&#1604;&#1580;&#1583;&#1608;&#1604; &#1575;&#1604;&#1586;&#1605;&#1606;&#1610; &#1604;&#1605;&#1593;&#1585;&#1601;&#1577; &#1605;&#1610;&#1593;&#1575;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1607; &#1575;&#1604;&#1588;&#1607;&#1585;&#1610;&#1607;";

        }
    %>


    <head>
        <title>User Calendar</title>

        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css">
        <script type="text/javascript" src="jquery-ui/jquery-1.7.1.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.easing.1.3.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.widget.js"></script>

        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.mouse.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.slider.js"></script>
        <link rel="stylesheet" href="css/demo_table.css">

        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>
    </head>
    <script language="javascript" type="text/javascript">
        $(function() {
            $("#users option[value='" +<%=user_id%> + "']").prop("selected", true);
        })
        $(function() {
            //            alert(minDateS)
            //alert('mindate'+minDateS)
            $("#finishEndDate").datetimepicker({
                changeMonth: true,
                changeYear: true,
                dateFormat: "yy/mm/dd",
                timeFormat: "hh:mm:ss"
            });
        });

        function cancelForm() {
            document.EQUIPMENT_CALENDAR_FORM.action = "<%=context%>/main.jsp";
            document.EQUIPMENT_CALENDAR_FORM.submit();
        }
        function cancelFormToMainReport() {
            document.EQUIPMENT_CALENDAR_FORM.action = "<%=context%>/ReportsServlet?op=mainPage";
            document.EQUIPMENT_CALENDAR_FORM.submit();
        }

        $(function() {
            $("#appTime").timepicker({
                controlType: 'select',
                timeFormat: "h:mm TT",
                ampm: true
            });
        });
        function popupShowAppointment(obj) {

            $(".submenu1").hide();
            $(".button_pointment").attr('id', '0');
            var month = $("#currentMonth").val();
            var day = $(obj).parent().parent().find("#day").text();
            var pageType = $(obj).parent().find("#pageType").val();
            var year = $("#currentYear").val();
            var currentMonth = (month * 1) + 1;
            var date = year + "/" + currentMonth + "/" + day;

            var url = "<%=context%>/ClientServlet?op=userAppo&userId=" +<%=userId%> + "&date=" + date + "&pageType=" + pageType;
            $('#show_appointment').load(url);
            $('#show_appointment').css("display", "block");

            $('#show_appointment').bPopup({easing: 'easeInOutSine', //uses jQuery easing plugin
                speed: 400,
                transition: 'slideDown', modalColor: 'black'});


        }
        function popupShowClient(obj) {
            $(".hidex").css("display", "none");
            $(".showx").css("display", "block");
            var clientId = $(obj).find("#clientId").val();

            var url = "<%=context%>/ClientServlet?op=showClientInformation&clientId=" + clientId;
            $('#show_client_information').load(url);
            $('#show_client_information').css("display", "block");
            $('#show_client_information').bPopup({easing: 'easeInOutSine', //uses jQuery easing plugin
                speed: 400,
                transition: 'slideDown', modalColor: 'black'});
        }
        var issueId, compID, client_id;
        function popupFinishO(obj) {
            $("#finishMsg").hide();


            issueId = $(obj).parent().parent().parent().find("#issueId").val();
            compID = $(obj).parent().parent().parent().find("#compId").val();
            client_id = $(obj).parent().parent().parent().find("#clientId").val();

            $('#finish_Note').find("#notes").val("");
            $('#finish_Note').css("display", "block");
            $('#finish_Note').bPopup({easing: 'easeInOutSine', //uses jQuery easing plugin
                speed: 400,
                transition: 'slideDown'});


        }
        function finishCom(obj) {
            var notes = $(obj).parent().parent().parent().find('#notes').val();
            var endDate = $(obj).parent().parent().parent().find('#finishEndDate').val();
            $.ajax({
                type: "post",
                url: "<%=context%>/ComplaintEmployeeServlet?op=finishComp&issueId=" + issueId + "&compId=" + compID,
                data: {
                    notes: notes,
                    clientId: client_id,
                    endDate: endDate
                },
                success: function(jsonString) {



                    var info = $.parseJSON(jsonString);

                    if (info.status == 'ok') {
                        $("#finishMsg").show();
                        $(obj).removeAttr("onclick");

                    }
                    else {


                    }
                }
            });

        }
        function popupApp(obj) {

            //            if($(obj).attr("id")==="active"){
            //                $(obj).removeAttr("id");
            //            }else{
            //                $(obj).attr("id", "active");
            //            }

            var users = $("#users").val();
            if (users == "000") {
                alert("قم بإختيار أحد الفنيين");
                $("#users").focus();
            } else {
                $("#appTitleMsg").css("color", "");
                $("#appTitleMsg").text("");
                //                $("#appTitle").val("");

                //        alert($(obj).parent().parent().find("#day").text());

                var month = $("#currentMonth").val();
                var day = $(obj).parent().parent().find("#day").text();
                var year = $("#currentYear").val();
                var currentMonth = (month * 1) + 1;
                var date = year + "/" + currentMonth + "/" + day;

                $("#appDate").val(date);
                $("#appNote").val("");
                $("#appMsg").hide();
                $(".submenu1").hide();
                $("#progress").hide();
                $("#appClientName").text($("#clientName").val());
                $(".button_pointment").attr('id', '0');
                $('#appointment_content').css("display", "block");

                $('#appointment_content').bPopup({easing: 'easeInOutSine', //uses jQuery easing plugin
                    speed: 400,
                    transition: 'slideDown'});

            }

        }
        function popupApp2(obj) {

            if ($(obj).attr("id") === "active") {
                $(obj).removeAttr("id");
            }
            $(obj).attr("id", "active");


            var users = $("#users").val();
            if (users == "000") {
                alert("قم بإختيار أحد الفنيين");
                $("#users").focus();
            } else {
                $("#appTitleMsg").css("color", "");
                $("#appTitleMsg").text("");
                //                $("#appTitle").val("");

                //        alert($(obj).parent().parent().find("#day").text());

                var month = $("#currentMonth").val();
                var day = $(obj).parent().parent().find("#day").text();
                var year = $("#currentYear").val();
                var currentMonth = (month * 1) + 1;
                var date = year + "/" + currentMonth + "/" + day;

                $("#appDate").val(date);
                $("#appNote").val("");
                $("#appMsg").hide();
                $(".submenu1").hide();
                $("#progress").hide();
                $("#appClientName").text($("#clientName").val());
                $(".button_pointment").attr('id', '0');
                $('#appointment_content').css("display", "block");

                $('#appointment_content').bPopup({easing: 'easeInOutSine', //uses jQuery easing plugin
                    speed: 400,
                    transition: 'slideDown'});

            }

        }
        function closePopup(obj) {

            $(obj).parent().parent().bPopup().close();


        }
        function saveAppo(obj) {



            var clientId = $("#clientId").val();

            $("#appTitleMsg").css("color", "");
            $("#appTitleMsg").text("");

            var title = $(obj).parent().parent().find($("#appTitle")).val();

            var date = $("#appDate").val();

            var note = $(obj).parent().parent().parent().find($("#appNote")).val();
            var time = $(obj).parent().parent().parent().find($("#appTime")).val();

            $(obj).parent().parent().parent().parent().find("#progress").hide();
            var userId = $("#users").val();
            var clientCompId = $("#clientCompId").val();
            var supervisorId = $("#supervisorId").val();
            var unitId = $("#units").val();

            if (title.length > 0) {
                $(obj).parent().parent().parent().parent().find("#progress").show();
                $.ajax({
                    type: "post",
                    url: "<%=context%>/ClientServlet?op=saveAppointment",
                    data: {
                        clientIdx: clientId,
                        title: title,
                        date: date,
                        note: note,
                        type: "0",
                        userId: userId,
                        clientCompId: clientCompId,
                        time: time,
                        unitId: unitId,
                        supervisorId: supervisorId
                    },
                    success: function(jsonString) {
                        var eqpEmpInfo = $.parseJSON(jsonString);
                        //                        alert(jsonString);
                        //                        alert(eqpEmpInfo);
                        if (eqpEmpInfo.status == 'ok') {
                            //                        alert("تم الحفظ");
                            $(obj).parent().parent().parent().parent().find("#appMsg").html("تم التسجيل بنجاح").show();
                            $(obj).parent().parent().parent().parent().find("#progress").hide();


                            if ($("#active").parent().parent().find("#div1")) {

                                $("#active").parent().parent().find("#div2").show();
                                $("#active").parent().parent().find("#div1").remove();
                            } else {


                            }
                        } else if (eqpEmpInfo.status == 'no') {

                            $(obj).parent().parent().parent().parent().find("#progress").show();
                            $(obj).parent().parent().parent().parent().find("#appMsg").html("لم يتم التسجيل او هذا العميل غير موزع").show();

                        }


                    }



                });
            } else {
                $("#appTitleMsg").css("color", "white");
                $("#appTitleMsg").text("أدخل عنوان المقابلة");

            }




        }
        function clientInformation(obj) {
            $(".hidex").css("display", "none");
            $(".showx").css("display", "block");
            $('#clientInformation').css("display", "block");
            $("#updateBtn").css("display", "none");
            $("#editBtn").css("display", "block");

            $('#clientInformation').bPopup({easing: 'easeInOutSine', //uses jQuery easing plugin
                speed: 400,
                transition: 'slideDown'});
        }
    </script>

    <script type="text/javascript">

        function get_Count(obj, value) {

            var month = $("#currentMonth").val();
            var day = value;
            var year = $("#currentYear").val();
            var currentMonth = (month * 1) + 1;
            var date = year + "/" + currentMonth + "/" + day;
            $("#appDate").val(date);

            $.ajax({
                type: "post",
                url: "<%=context%>/ClientServlet?op=userAppoNumber",
                data: {
                    userId: <%=userId%>,
                    date: date

                },
                success: function(jsonString) {
                    var eqpEmpInfo = $.parseJSON(jsonString);
                    //                        alert(jsonString);
                    //                        alert(eqpEmpInfo);

                    //                 
                    //                                                                               $(".save_app").html(eqpEmpInfo.number);
                    $(obj).find("#number").html(eqpEmpInfo.number).show();


                }
            });
        }
        function get_Count2(obj, value) {

            var month = $("#currentMonth").val();
            var day = value;
            var year = $("#currentYear").val();
            var currentMonth = (month * 1) + 1;
            var date = year + "/" + currentMonth + "/" + day;
            $("#appDate").val(date);

            $.ajax({
                type: "post",
                url: "<%=context%>/ClientServlet?op=userAppoNumber",
                data: {
                    userId: <%=userId%>,
                    date: date

                },
                success: function(jsonString) {
                    var eqpEmpInfo = $.parseJSON(jsonString);
                    //                        alert(jsonString);
                    //                        alert(eqpEmpInfo);

                    //                 
                    //                                                                               $(".save_app").html(eqpEmpInfo.number);
                    $(obj).parent().find("#number").html(eqpEmpInfo.number).show();


                }
            });
        }

    </script>
    <style type="text/css">
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

            -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 0.67);
            -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 0.67);
            box-shadow:         0px 0px 17px rgba(255, 255, 255, 0.67);
            -webkit-border-radius: 20px;
            -moz-border-radius: 20px;
            border-radius: 20px;
        }
        .login1{
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
            background-image: -webkit-gradient(
                linear,
                left top,
                left bottom,
                color-stop(1, #CCCCCC),
                color-stop(1, #EEF0ED),
                color-stop(1, #FFFFFF)
                );
            background-image: -o-linear-gradient(bottom, #CCCCCC 100%, #EEF0ED 100%, #FFFFFF 100%);
            background-image: -moz-linear-gradient(bottom, #CCCCCC 100%, #EEF0ED 100%, #FFFFFF 100%);
            background-image: -webkit-linear-gradient(bottom, #CCCCCC 100%, #EEF0ED 100%, #FFFFFF 100%);
            background-image: -ms-linear-gradient(bottom, #CCCCCC 100%, #EEF0ED 100%, #FFFFFF 100%);
            background-image: linear-gradient(to bottom, #CCCCCC 100%, #EEF0ED 100%, #FFFFFF 100%);}
        .save_app{
            width:32px;
            height:32px;
            background-image:url(images/icons/add_event.png);
            background-repeat: no-repeat;
            cursor: pointer;

            float:right;
            margin-right:10px;

        }
        .save_app2{
            width:32px;
            height:32px;
            background-image:url(images/icons/add_event.png);
            background-repeat: no-repeat;
            cursor: pointer;



        }
        .show_app{
            width:32px;
            height:32px;
            background-image:url(images/icons/show_event.png);
            background-repeat: no-repeat;
            cursor: pointer;
            margin-left:10px;




        }
        .backColor{background: rgb(238,238,238); /* Old browsers */
                   background: -moz-linear-gradient(top,  rgba(238,238,238,1) 0%, rgba(204,204,204,1) 75%); /* FF3.6+ */
                   background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,rgba(238,238,238,1)), color-stop(75%,rgba(204,204,204,1))); /* Chrome,Safari4+ */
                   background: -webkit-linear-gradient(top,  rgba(238,238,238,1) 0%,rgba(204,204,204,1) 75%); /* Chrome10+,Safari5.1+ */
                   background: -o-linear-gradient(top,  rgba(238,238,238,1) 0%,rgba(204,204,204,1) 75%); /* Opera 11.10+ */
                   background: -ms-linear-gradient(top,  rgba(238,238,238,1) 0%,rgba(204,204,204,1) 75%); /* IE10+ */
                   background: linear-gradient(to bottom,  rgba(238,238,238,1) 0%,rgba(204,204,204,1) 75%); /* W3C */
                   filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#eeeeee', endColorstr='#cccccc',GradientType=0 ); /* IE6-9 */

        }
        #appointmentTable tbody tr.even:hover, #appointmentTable tbody tr.even td.highlighted {
            background-color: #ECFFB3;
        }

        #appointmentTable tbody tr.odd:hover, #appointmentTable tbody tr.odd td.highlighted {
            background-color: #E6FF99;
        }

        #appointmentTable tr.even:hover {
            background-color: #ECFFB3;
        }

        #appointmentTable tr.even:hover td.sorting_1 {
            background-color: #DDFF75;
        }

        #appointmentTable tr.even:hover td.sorting_2 {
            background-color: #E7FF9E;
        }

        #appointmentTable tr.even:hover td.sorting_3 {
            background-color: #E2FF89;
        }

        #appointmentTable tr.odd:hover {
            background-color: #E6FF99;
        }

        #appointmentTable tr.odd:hover td.sorting_1 {
            background-color: #D6FF5C;
        }

        #appointmentTable tr.odd:hover td.sorting_2 {
            background-color: #E0FF84;
        }

        #appointmentTable tr.odd:hover td.sorting_3 {
            background-color: #DBFF70;
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
        #ta tr td{
            border: none
        }
        .button_finis{
            width:135px;
            height:29px;
            margin: 4px;
            background-repeat: no-repeat;
            cursor: pointer;
            border: none;
            background-position: right top ;
            display: inline-block;
            background-color: transparent;
            background-image:url(images/buttons/finish.png);
        }
    </style>
    <body >

        <div id="finish_Note"  style="width: 40%;display: none;position: fixed">

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
                <table  border="0px" id="ta" style="width:100%;text-align: right;margin-bottom: 10px !important;margin-left: auto;margin-right: auto;" >                



                    <tr>
                        <td style="width: 40%;"> <label style="width: 100px;">ملاحظات الإنهاء</label></TD>
                        <td style="width: 60%;"><TEXTAREA cols="40" rows="5" name="notes" id="notes"></TEXTAREA></TD>
                    </TR>
                    <tr>
                        <td style="width: 40%;"> <label style="width: 100px;">التاريخ</label></TD>
                        <td style="width: 60%;">  <input name="finishEndDate" id="finishEndDate" type="text" size="40" maxlength="50" style="width:50%;float: right;font-size: 12px;" value="<%=nowTime%>"/></TEXTAREA></TD>
                    </TR>
                    <tr>
                        <td colspan="2" > <input type="button"  onclick="JavaScript:finishCom(this);" class="button_finis"></TD>
                    </tr>
                    <tr>
                        <td colspan="2" >
                            <div style="margin: 0 auto;display: none; width: 90%;text-align: center;color: white" id="finishMsg">تم الإنهاء بنجاح</>
                        </td>
                    </tr>


                </TABLE>
            </div>

        </div>

        <script type="text/javascript" src="js/wz_tooltip.js"></script>
    <CENTER>
        <FIELDSET class="set" style="width:100%;" >

            <FORM NAME="EQUIPMENT_CALENDAR_FORM" METHOD="POST">
                <input type="hidden" value="<%=currentMonth%>" id="currentMonth"/>
                <input type="hidden" value="<%=currentYear%>" id="currentYear"/>
                <div style="width: 100%;clear: both">


                    <div id="show_appointment"  style="width: 80% !important;display: none;margin-left: auto;margin-right: auto;text-align: center;position: fixed ;">

                    </div>
                    <div id="show_client_information"  style="width: 60% !important;display: none;margin-left: auto;margin-right: auto;text-align: center;position: fixed ;">

                    </div>

                    <div style="clear: both"></div>

                    <TABLE ALIGN="<%=align%>" DIR="LTR" CELLPADDING="5" CELLSPACING="2" STYLE="background: rgba(255,255,255,1);
                           background: -moz-linear-gradient(left, rgba(255,255,255,1) 0%, rgba(255,255,255,1) 0%, rgba(255,255,255,1) 47%, rgba(255,255,255,1) 100%);
                           background: -webkit-gradient(left top, right top, color-stop(0%, rgba(255,255,255,1)), color-stop(0%, rgba(255,255,255,1)), color-stop(47%, rgba(255,255,255,1)), color-stop(100%, rgba(255,255,255,1)));
                           background: -webkit-linear-gradient(left, rgba(255,255,255,1) 0%, rgba(255,255,255,1) 0%, rgba(255,255,255,1) 47%, rgba(255,255,255,1) 100%);
                           background: -o-linear-gradient(left, rgba(255,255,255,1) 0%, rgba(255,255,255,1) 0%, rgba(255,255,255,1) 47%, rgba(255,255,255,1) 100%);
                           background: -ms-linear-gradient(left, rgba(255,255,255,1) 0%, rgba(255,255,255,1) 0%, rgba(255,255,255,1) 47%, rgba(255,255,255,1) 100%);
                           background: linear-gradient(to right, rgba(255,255,255,1) 0%, rgba(255,255,255,1) 0%, rgba(255,255,255,1) 47%, rgba(255,255,255,1) 100%);
                           filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#ffffff', endColorstr='#ffffff', GradientType=1 );">
                        <TR>
                            <TD BGCOLOR="#ccddff" STYLE="font-size:14;" WIDTH="100"><font color="black"><b>Saturday</b></font></TD>
                            <TD BGCOLOR="#ccddff" STYLE="font-size:14;" WIDTH="100"><font color="black"><b>Sunday</b></font></TD>
                            <TD BGCOLOR="#ccddff" STYLE="font-size:14;" WIDTH="100"><font color="black"><b>Monday</b></font></TD>
                            <TD BGCOLOR="#ccddff" STYLE="font-size:14;" WIDTH="100"><font color="black"><b>Tuesday</b></font></TD>
                            <TD BGCOLOR="#ccddff" STYLE="font-size:14;" WIDTH="100"><font color="black"><b>Wednesday</b></font></TD>
                            <TD BGCOLOR="#ccddff" STYLE="font-size:14;" WIDTH="100"><font color="black"><b>Thursday</b></font></TD>
                            <TD BGCOLOR="#ccddff" STYLE="font-size:14;" WIDTH="100"><font color="black"><b>Friday</b></font></TD>
                            <TD BGCOLOR="#ccddff" STYLE="font-size:14;" WIDTH="50" COLSPAN="2">&nbsp;</TD>
                        </TR>

                        <TR>
                            <%
                                for (int i = 0; i < 8; i++) {
                                    if (i < 7) {
                                        if (gotCell == true) {
                                            cellValue = new Integer(minDate).toString();
                                            minDate = minDate + 1;
                                        } else if (startPeriodDayName.equalsIgnoreCase(dayName[i]) && minDate <= maxDate) {
                                            gotCell = true;
                                            cellValue = new Integer(minDate).toString();
                                            minDate = minDate + 1;
                                        } else {
                                            cellValue = "0";
                                        }
                            %>
                            <%
                                int x;

                                x = Integer.parseInt(cellValue);

                                if (x >= currentDay) {%>
                            <TD  STYLE="font-size:14;;height:75px;background: rgb(178,225,255); /* Old browsers */
                                 background: -moz-linear-gradient(top,  rgba(178,225,255,1) 0%, rgba(102,182,252,1) 100%); /* FF3.6+ */
                                 background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,rgba(178,225,255,1)), color-stop(100%,rgba(102,182,252,1))); /* Chrome,Safari4+ */
                                 background: -webkit-linear-gradient(top,  rgba(178,225,255,1) 0%,rgba(102,182,252,1) 100%); /* Chrome10+,Safari5.1+ */
                                 background: -o-linear-gradient(top,  rgba(178,225,255,1) 0%,rgba(102,182,252,1) 100%); /* Opera 11.10+ */
                                 background: -ms-linear-gradient(top,  rgba(178,225,255,1) 0%,rgba(102,182,252,1) 100%); /* IE10+ */
                                 background: linear-gradient(to bottom,  rgba(178,225,255,1) 0%,rgba(102,182,252,1) 100%); /* W3C */
                                 filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#b2e1ff', endColorstr='#66b6fc',GradientType=0 ); /* IE6-9 */


                                 " WIDTH="100"
                            <%if (eqpSchedulesDays.contains(new Integer(minDate - 1))) {%> background="images/schedule.jpg"<%} else {%> background="" <%}%>
                                 >
                                <%if (eqpSchedulesDays.contains(new Integer(minDate - 1))) {%> 
                                <div style="width: 100%;margin-top: 0px;height: 45%;" onmouseover="get_Count2(this,<%=cellValue%>)" >
                                    <% String num = "";
                                        if (cellValue.equals("0")) {%>
                                    <b id="day"><%=num%></b>
                                    <%} else {%>
                                    <b id="day"><%=cellValue%></b>
                                    <%}%>
                                    <div style="float: right;width: 18px;height: 18px;border-radius: 3px 3px 3px 3px;text-align: center;display: none"class="num"id="number">

                                    </div> 
                                </div>
                                <div style="width: 100%;height: 55%;
                                     " onmouseover="get_Count2(this,<%=cellValue%>)">


                                    <input type="hidden" id="pageType" value="1"/> 
                                    <div class="show_app" onclick="popupShowAppointment(this)"> </div>

                                </div>
                                <%} else {%>
                                <div style="width: 100%;margin-top: 0px;height: 45%;" onmouseover="get_Count2(this,<%=cellValue%>)">
                                    <% String num = "";
                                        if (cellValue.equals("0")) {%>
                                    <b id="day"><%=num%></b>
                                    <%} else {%>
                                    <b id="day"><%=cellValue%></b>
                                    <%}%>
                                    <!--<input  type="button" value="show" onclick="popupShowAppointment(this)"/>-->
                                    <!--                                                                <div style="float: right;width: 18px;height: 18px;border-radius: 3px 3px 3px 3px;text-align: center;display: none"class="num"id="number">
                                                                    
                                                                                                    </div>-->

                                </div>
                                <div style="width: 100%;height: 55%;" id="div1">


                                </div>
                                <div style="width: 100%;height: 55%;display: none" onmouseover="get_Count2(this,<%=cellValue%>)" id="div2">





                                    <input type="hidden" id="pageType" value="1"/> 
                                    <div class="show_app" onclick="popupShowAppointment(this)"> </div>

                                </div>
                                <%}%>

                            </TD>

                            <%} else {%>
                            <TD class="backColor" STYLE="font-size:14;;height:75px;" WIDTH="100"
                            <%if (eqpSchedulesDays.contains(new Integer(minDate - 1))) {%> background="images/schedule.jpg"<%} else {%> background="" <%}%>
                                >

                                <%if (eqpSchedulesDays.contains(new Integer(minDate - 1))) {%> 
                                <div style="width: 100%;margin-top: 0px;height: 45%;" onmouseover="get_Count2(this,<%=cellValue%>)">
                                    <% String num = "";
                                        if (cellValue.equals("0")) {%>
                                    <b id="day"><%=num%></b>
                                    <%} else {%>
                                    <b id="day"><%=cellValue%></b>
                                    <%}%>
                                    <div style="float: right;width: 18px;height: 18px;border-radius: 3px 3px 3px 3px;text-align: center;display: none"class="num"id="number">

                                    </div>
                                </div>
                                <div style="width: 100%;height: 55%;" onmouseover="get_Count2(this,<%=cellValue%>)">
                                    <input type="hidden" id="pageType" value="0"/> 
                                    <div  class="show_app" onclick="popupShowAppointment(this)"></div>

                                </div>
                                <%} else {%>
                                <div style="width: 100%;margin-top: 0px;height: 45%;" onmouseover="get_Count2(this,<%=cellValue%>)">
                                    <% String num = "";
                                        if (cellValue.equals("0")) {%>
                                    <b id="day"><%=num%></b>
                                    <%} else {%>
                                    <b id="day"><%=cellValue%></b>
                                    <%}%>

                                </div>
                                <div style="width: 100%;height: 55%;" onmouseover="get_Count2(this,<%=cellValue%>)">
                                    <!--<input type="button" value="adds" onclick="popupApp(this)"/>-->

                                </div>
                                <%}%>


                            </TD>
                            <%}%>
                            <%
                            } else {
                            %>

                            <TD STYLE="font-size:16;;writing-mode:tb-rl" WIDTH="25" ROWSPAN="<%=calRowsNumber%>" BGCOLOR="#ddeeff"><b><%=year%></b></TD>
                                    <%
                                            }
                                        }
                                    %>
                        </TR>

                        <TR>
                            <%
                                for (int i = 0; i < 7; i++) {
                                    if (minDate <= maxDate) {
                                        cellValue = new Integer(minDate).toString();
                                        minDate = minDate + 1;
                                    } else {
                                        cellValue = "&nbsp;";
                                    }
                            %>
                            <%
                                int x;

                                x = Integer.parseInt(cellValue);

                                if (x >= currentDay) {%>
                            <TD  STYLE="font-size:14;;height:75px;background: rgb(178,225,255); /* Old browsers */
                                 background: -moz-linear-gradient(top,  rgba(178,225,255,1) 0%, rgba(102,182,252,1) 100%); /* FF3.6+ */
                                 background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,rgba(178,225,255,1)), color-stop(100%,rgba(102,182,252,1))); /* Chrome,Safari4+ */
                                 background: -webkit-linear-gradient(top,  rgba(178,225,255,1) 0%,rgba(102,182,252,1) 100%); /* Chrome10+,Safari5.1+ */
                                 background: -o-linear-gradient(top,  rgba(178,225,255,1) 0%,rgba(102,182,252,1) 100%); /* Opera 11.10+ */
                                 background: -ms-linear-gradient(top,  rgba(178,225,255,1) 0%,rgba(102,182,252,1) 100%); /* IE10+ */
                                 background: linear-gradient(to bottom,  rgba(178,225,255,1) 0%,rgba(102,182,252,1) 100%); /* W3C */
                                 filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#b2e1ff', endColorstr='#66b6fc',GradientType=0 ); /* IE6-9 */


                                 " WIDTH="100"
                            <%if (eqpSchedulesDays.contains(new Integer(minDate - 1))) {%> background="images/schedule.jpg"<%} else {%> background="" <%}%>
                                 >
                                <%if (eqpSchedulesDays.contains(new Integer(minDate - 1))) {%> 
                                <div style="width: 100%;margin-top: 0px;height: 45%;" onmouseover="get_Count2(this,<%=cellValue%>)">
                                    <% String num = "";
                                        if (cellValue.equals("0")) {%>
                                    <b id="day"><%=num%></b>
                                    <%} else {%>
                                    <b id="day"><%=cellValue%></b>
                                    <%}%>
                                    <div style="float: right;width: 18px;height: 18px;border-radius: 3px 3px 3px 3px;text-align: center;display: none"class="num"id="number">

                                    </div>
                                </div>
                                <div style="width: 100%;height: 55%;
                                     " onmouseover="get_Count2(this,<%=cellValue%>)">


                                    <input type="hidden" id="pageType" value="1"/> 
                                    <div class="show_app" onclick="popupShowAppointment(this)"> </div>

                                </div>
                                <%} else {%>
                                <div style="width: 100%;margin-top: 0px;height: 45%;" onmouseover="get_Count2(this,<%=cellValue%>)">
                                    <% String num = "";
                                        if (cellValue.equals("0")) {%>
                                    <b id="day"><%=num%></b>
                                    <%} else {%>
                                    <b id="day"><%=cellValue%></b>
                                    <%}%>
                                    <!--<input  type="button" value="show" onclick="popupShowAppointment(this)"/>-->

                                </div>
                                <div style="width: 100%;height: 55%;" id="div1">


                                </div>
                                <div style="width: 100%;height: 55%;display: none" onmouseover="get_Count2(this,<%=cellValue%>)" id="div2">





                                    <input type="hidden" id="pageType" value="1"/> 
                                    <div class="show_app" onclick="popupShowAppointment(this)"> </div>

                                </div>
                                <%}%>

                            </TD>

                            <%} else {%>
                            <TD class="backColor" STYLE="font-size:14;;height:75px;" WIDTH="100"
                            <%if (eqpSchedulesDays.contains(new Integer(minDate - 1))) {%> background="images/schedule.jpg"<%} else {%> background="" <%}%>
                                >

                                <%if (eqpSchedulesDays.contains(new Integer(minDate - 1))) {%> 
                                <div style="width: 100%;margin-top: 0px;height: 45%;" onmouseover="get_Count2(this,<%=cellValue%>)">
                                    <% String num = "";
                                        if (cellValue.equals("0")) {%>
                                    <b id="day"><%=num%></b>
                                    <%} else {%>
                                    <b id="day"><%=cellValue%></b>
                                    <%}%>
                                    <div style="float: right;width: 18px;height: 18px;border-radius: 3px 3px 3px 3px;text-align: center;display: none"class="num"id="number">

                                    </div>
                                </div>
                                <div style="width: 100%;height: 55%;" onmouseover="get_Count2(this,<%=cellValue%>)">
                                    <input type="hidden" id="pageType" value="0"/> 
                                    <div  class="show_app" onclick="popupShowAppointment(this)"></div>

                                </div>
                                <%} else {%>
                                <div style="width: 100%;margin-top: 0px;height: 45%;" onmouseover="get_Count2(this,<%=cellValue%>)">
                                    <% String num = "";
                                        if (cellValue.equals("0")) {%>
                                    <b id="day"><%=num%></b>
                                    <%} else {%>
                                    <b id="day"><%=cellValue%></b>
                                    <%}%>

                                </div>
                                <div style="width: 100%;height: 55%;" onmouseover="get_Count2(this,<%=cellValue%>)">
                                    <!--<input type="button" value="adds" onclick="popupApp(this)"/>-->

                                </div>
                                <%}%>


                            </TD>
                            <%}%>
                            <%}%>
                            <TD STYLE="font-size:14;;writing-mode:tb-rl" WIDTH="25" ROWSPAN="<%=calRowsNumber%>" BGCOLOR="#ccddee"><font color="black"><b><%=monthName[month]%></b></font></TD>
                        </TR>

                        <%
                            for (int i = 0; i < calRowsNumber - 2; i++) {
                        %>
                        <TR>
                            <%
                                for (int j = 0; j < 7; j++) {
                                    if (minDate <= maxDate) {
                                        cellValue = new Integer(minDate).toString();
                                        minDate = minDate + 1;
                                    } else {
                                        cellValue = "0";
                                    }
                            %>
                            <%
                                int x;

                                x = Integer.parseInt(cellValue);

                                if (x >= currentDay) {%>
                            <TD   STYLE="font-size:14;;height:75px;background: rgb(178,225,255); /* Old browsers */
                                  background: -moz-linear-gradient(top,  rgba(178,225,255,1) 0%, rgba(102,182,252,1) 100%); /* FF3.6+ */
                                  background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,rgba(178,225,255,1)), color-stop(100%,rgba(102,182,252,1))); /* Chrome,Safari4+ */
                                  background: -webkit-linear-gradient(top,  rgba(178,225,255,1) 0%,rgba(102,182,252,1) 100%); /* Chrome10+,Safari5.1+ */
                                  background: -o-linear-gradient(top,  rgba(178,225,255,1) 0%,rgba(102,182,252,1) 100%); /* Opera 11.10+ */
                                  background: -ms-linear-gradient(top,  rgba(178,225,255,1) 0%,rgba(102,182,252,1) 100%); /* IE10+ */
                                  background: linear-gradient(to bottom,  rgba(178,225,255,1) 0%,rgba(102,182,252,1) 100%); /* W3C */
                                  filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#b2e1ff', endColorstr='#66b6fc',GradientType=0 ); /* IE6-9 */


                                  " WIDTH="100"
                            <%if (eqpSchedulesDays.contains(new Integer(minDate - 1))) {%> background="images/schedule.jpg"<%} else {%> background="" <%}%>
                                  >


                                <%if (eqpSchedulesDays.contains(new Integer(minDate - 1))) {%> 

                                <div style="width: 100%;margin-top: 0px;height: 45%;" onmouseover="get_Count(this,<%=cellValue%>)">
                                    <% String num = "";
                                        String number = "";
                                        if (cellValue.equals("0")) {%>
                                    <b id="day"><%=num%></b>
                                    <%} else {%>
                                    <b id="day"><%=cellValue%></b>
                                    <%}%>
                                    <div style="float: right;width: 18px;height: 18px;border-radius: 3px 3px 3px 3px;text-align: center;display: none"class="num"id="number">

                                    </div>
                                </div>
                                <div style="width: 100%;height: 55%;" onmouseover="get_Count2(this,<%=cellValue%>)">





                                    <input type="hidden" id="pageType" value="1"/> 
                                    <div class="show_app" onclick="popupShowAppointment(this)"> </div>

                                </div>

                                <%} else {%>



                                <div style="width: 100%;margin-top: 0px;height: 45%;" >
                                    <% String num = "";
                                        if (cellValue.equals("0")) {%>
                                    <b id="day"><%=num%></b>
                                    <%} else {%>
                                    <b id="day"><%=cellValue%></b>
                                    <%}%>
                                    <div style="float: right;width: 18px;height: 18px;border-radius: 3px 3px 3px 3px;text-align: center;display: none"class="num"id="number">

                                    </div>
                                    <!--<input  type="button" value="show" onclick="popupShowAppointment(this)"/>-->
                                </div>
                                <div style="width: 100%;height: 55%;" id="div1">


                                </div>
                                <div style="width: 100%;height: 55%;display: none" onmouseover="get_Count2(this,<%=cellValue%>)" id="div2">





                                    <input type="hidden" id="pageType" value="1"/> 
                                    <div class="show_app" onclick="popupShowAppointment(this)"> </div>

                                </div>

                                <%}%>

                            </TD>

                            <%} else {%>
                            <TD class="backColor" STYLE="font-size:14;;height:75px;" WIDTH="100"
                            <%if (eqpSchedulesDays.contains(new Integer(minDate - 1))) {%> background="images/schedule.jpg"<%} else {%> background="" <%}%>
                                >

                                <%if (eqpSchedulesDays.contains(new Integer(minDate - 1))) {%> 

                                <div style="width: 100%;margin-top: 0px;height: 45%;" onmouseover="get_Count2(this,<%=cellValue%>)">
                                    <% String num = "";
                                        if (cellValue.equals("0")) {%>
                                    <b id="day"><%=num%></b>
                                    <%} else {%>
                                    <b id="day"><%=cellValue%></b>
                                    <%}%>
                                    <div style="float: right;width: 18px;height: 18px;border-radius: 3px 3px 3px 3px;text-align: center;display: none"class="num"id="number">

                                    </div>
                                </div>
                                <div style="width: 100%;height: 55%;" onmouseover="get_Count2(this,<%=cellValue%>)">
                                    <input type="hidden" id="pageType" value="0"/> 
                                    <div  class="show_app" onclick="popupShowAppointment(this)" onmouseover="get_Count2(this,<%=cellValue%>)"></div>

                                </div>


                                <%} else {%>
                                <div style="width: 100%;margin-top: 0px;height: 45%;" onmouseover="get_Count2(this,<%=cellValue%>)">
                                    <% String num = "";
                                        if (cellValue.equals("0")) {%>
                                    <b id="day"><%=num%></b>
                                    <%} else {%>
                                    <b id="day"><%=cellValue%></b>
                                    <%}%>

                                </div>
                                <div style="width: 100%;height: 55%;">
                                    <!--<input type="button" value="adds" onclick="popupApp(this)"/>-->

                                </div>
                                <%}%>


                            </TD>
                            <%}%>

                            <%}%>
                        </TR>

                        <%}%>
                    </TABLE>

                    <input type="hidden" name="peroid" id="peroid" value="other">
                    </center>
                </div>

                </div>
            </FORM>
        </FIELDSET>
    </center>
</body>
</html>


