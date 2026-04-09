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
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();

        String userId = (String) request.getAttribute("userId");
        Hashtable<String, String> data = (Hashtable<String, String>) request.getAttribute("data");

        String stat = (String) request.getSession().getAttribute("currentMode");
        String startPeriodDayName = "";
        String cellValue = "";
        Calendar calendar = Calendar.getInstance();
        int currentDay = calendar.get(calendar.DAY_OF_MONTH);
        int currentYear = calendar.get(calendar.YEAR);

        String[] monthName = {"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"};
        String[] dayName = {"Saturday", "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday"};

        //Get Month Data
        WebBusinessObject monthWbo = (WebBusinessObject) request.getAttribute("month");

        //Calendar Calculation
        boolean gotCell = false;

        Calendar periodicalCalendar = Calendar.getInstance();

        int year = 0;
        int currentMonth = new Integer(monthWbo.getAttribute("id").toString()).intValue();
        int minDate = 0;
        int maxDate = 0;
        int calRowsNumber = 0;
        int reminder = 0;
        int startPeriodDay = 0;

        year = periodicalCalendar.getTime().getYear() + 1900;
        periodicalCalendar.set(Calendar.MONTH, currentMonth);
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
        String align;

        if (stat.equals("En")) {
            align = "center";
        } else {
            align = "center";
        }

        int weekStartDay = 6;
    %>

    <head>
        <title>User Calendar</title>

        <script type="text/javascript" src="jquery-ui/jquery-1.7.1.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.easing.1.3.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.widget.js"></script>
        <script type="text/javascript" src="js/wz_tooltip.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.mouse.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.slider.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>
        <link rel="stylesheet" href="css/demo_table.css">
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css">

        <script language="javascript" type="text/javascript">

            function changeMonth(obj) {
                var month = $(obj).val();
                document.CALENDAR_FORM.action = "<%=context%>/CalendarServlet?op=showCalendar&month=" + month;
                document.CALENDAR_FORM.submit();
            }

            $(function() {
                centerDiv("show_appointment");
            });

            function centerDiv(div) {
                $("#" + div).css("position", "fixed");
                $("#" + div).css("top", Math.max(0, (($(window).height() - $("#" + div).outerHeight()) / 2) +
                        $(window).scrollTop()) + "px");
                $("#" + div).css("left", Math.max(0, (($(window).width() - $("#" + div).outerWidth()) / 2) +
                        $(window).scrollLeft()) + "px");
            }

            function popupShowAppointment(value)
            {
                divID = "show_appointment";
                var month = $("#currentMonth").val();
                var day = value;
                var year = $("#currentYear").val();
                var currentMonth = (month * 1) + 1;
                var date = year + "/" + currentMonth + "/" + day;

                var url = "<%=context%>/AppointmentServlet?op=showAppointmentsByDate&date=" + date;
                $('#show_appointment').load(url);
                $('#overlay').show();
                $('#show_appointment').css("display", "block");
                $('#show_appointment').dialog();
            }

            function closeOverlay() {
                $("#" + divID).hide();
                $("#overlay").hide();
            }

            function closePopup(formID) {
                window.location.href = window.location.href;
                $("#" + formID).hide();
                $('#overlay').hide();
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
                background-image: linear-gradient(to bottom, #CCCCCC 100%, #EEF0ED 100%, #FFFFFF 100%);
            }

            .save_app{
                width:32px;
                height:32px;
                background-image:url(images/icons/calendar.png);
                background-repeat: no-repeat;
                cursor: pointer;
                margin-right:10px;
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
            .dayBackColor {
                font-size:14px;border-width:1px;border-color:white;height:75px;background: rgb(178,225,255); /* Old browsers */
                background: -moz-linear-gradient(top,  rgba(178,225,255,1) 0%, rgba(102,182,252,1) 100%); /* FF3.6+ */
                background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,rgba(178,225,255,1)), color-stop(100%,rgba(102,182,252,1))); /* Chrome,Safari4+ */
                background: -webkit-linear-gradient(top,  rgba(178,225,255,1) 0%,rgba(102,182,252,1) 100%); /* Chrome10+,Safari5.1+ */
                background: -o-linear-gradient(top,  rgba(178,225,255,1) 0%,rgba(102,182,252,1) 100%); /* Opera 11.10+ */
                background: -ms-linear-gradient(top,  rgba(178,225,255,1) 0%,rgba(102,182,252,1) 100%); /* IE10+ */
                background: linear-gradient(to bottom,  rgba(178,225,255,1) 0%,rgba(102,182,252,1) 100%); /* W3C */
                filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#b2e1ff', endColorstr='#66b6fc',GradientType=0 ); /* IE6-9 */
            }
            .dayBackColorStartWeek {font-size:14px;border-width:1px;border-color:white;height:75px;
                                    background: rgb(178,225,255); /* Old browsers */
                                    background: -moz-linear-gradient(top,  rgba(178,225,255,1) 0%, rgba(102,182,252,1) 100%); /* FF3.6+ */
                                    background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,rgba(178,225,255,1)), color-stop(100%,rgba(102,182,252,1))); /* Chrome,Safari4+ */
                                    background: -webkit-linear-gradient(top,  rgba(0,225,255,1) 0%,rgba(0,182,252,1) 100%); /* Chrome10+,Safari5.1+ */
                                    background: -o-linear-gradient(top,  rgba(178,225,255,1) 0%,rgba(102,182,252,1) 100%); /* Opera 11.10+ */
                                    background: -ms-linear-gradient(top,  rgba(178,225,255,1) 0%,rgba(102,182,252,1) 100%); /* IE10+ */
                                    background: linear-gradient(to bottom,  rgba(0,225,255,1) 0%,rgba(0,182,252,1) 100%); /* W3C */
                                    filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#b2e1ff', endColorstr='#66b6fc',GradientType=0 ); /* IE6-9 */
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
        </style>

    </head>
    <body>
        <input type="hidden" value="<%=currentYear%>" id="currentYear"/>

        <FORM NAME="CALENDAR_FORM" METHOD="POST">

            <div id="overlay" class="overlayClass" onclick="JavaScript: closeOverlay();">

            </div>
            <div id="show_appointment"  style="width: 70% !important;display: none;margin-left: auto;margin-right: auto;text-align: center;position: fixed ;">

            </div>
            <div style="width: 100%;clear: both;height: 100%;
                 background: #deefff; /* Old browsers */
                 background: -moz-linear-gradient(top,  #deefff 0%, #98bede 100%); /* FF3.6+ */
                 background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#deefff), color-stop(100%,#98bede)); /* Chrome,Safari4+ */
                 background: -webkit-linear-gradient(top,  #deefff 0%,#98bede 100%); /* Chrome10+,Safari5.1+ */
                 background: -o-linear-gradient(top,  #deefff 0%,#98bede 100%); /* Opera 11.10+ */
                 background: -ms-linear-gradient(top,  #deefff 0%,#98bede 100%); /* IE10+ */
                 background: linear-gradient(to bottom,  #deefff 0%,#98bede 100%); /* W3C */
                 filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#deefff', endColorstr='#98bede',GradientType=0 ); /* IE6-9 */">
                <br />
                <br />
                <br />
                <TABLE ALIGN="<%=align%>" WIDTH="80%" DIR="LTR" CELLPADDING="0" CELLSPACING="0" STYLE="border-width: 1px;border-color:white;background: rgba(255,255,255,1);
                       background: -moz-linear-gradient(left, rgba(255,255,255,1) 0%, rgba(255,255,255,1) 0%, rgba(255,255,255,1) 47%, rgba(255,255,255,1) 100%);
                       background: -webkit-gradient(left top, right top, color-stop(0%, rgba(255,255,255,1)), color-stop(0%, rgba(255,255,255,1)), color-stop(47%, rgba(255,255,255,1)), color-stop(100%, rgba(255,255,255,1)));
                       background: -webkit-linear-gradient(left, rgba(255,255,255,1) 0%, rgba(255,255,255,1) 0%, rgba(255,255,255,1) 47%, rgba(255,255,255,1) 100%);
                       background: -o-linear-gradient(left, rgba(255,255,255,1) 0%, rgba(255,255,255,1) 0%, rgba(255,255,255,1) 47%, rgba(255,255,255,1) 100%);
                       background: -ms-linear-gradient(left, rgba(255,255,255,1) 0%, rgba(255,255,255,1) 0%, rgba(255,255,255,1) 47%, rgba(255,255,255,1) 100%);
                       background: linear-gradient(to right, rgba(255,255,255,1) 0%, rgba(255,255,255,1) 0%, rgba(255,255,255,1) 47%, rgba(255,255,255,1) 100%);
                       filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#ffffff', endColorstr='#ffffff', GradientType=1 );">
                    <TR>
                        <TD BGCOLOR="#ccddff" STYLE="font-size:14px;border-width:1px;border-color:white; height: 30px" WIDTH="10%"><font color="black"><b>Saturday</b></font></TD>
                        <TD BGCOLOR="#ccddff" STYLE="font-size:14px;border-width:1px;border-color:white" WIDTH="10%"><font color="black"><b>Sunday</b></font></TD>
                        <TD BGCOLOR="#ccddff" STYLE="font-size:14px;border-width:1px;border-color:white" WIDTH="10%"><font color="black"><b>Monday</b></font></TD>
                        <TD BGCOLOR="#ccddff" STYLE="font-size:14px;border-width:1px;border-color:white" WIDTH="10%"><font color="black"><b>Tuesday</b></font></TD>
                        <TD BGCOLOR="#ccddff" STYLE="font-size:14px;border-width:1px;border-color:white" WIDTH="10%"><font color="black"><b>Wednesday</b></font></TD>
                        <TD BGCOLOR="#ccddff" STYLE="font-size:14px;border-width:1px;border-color:white" WIDTH="10%"><font color="black"><b>Thursday</b></font></TD>
                        <TD BGCOLOR="#ccddff" STYLE="font-size:14px;border-width:1px;border-color:white" WIDTH="10%"><font color="black"><b>Friday</b></font></TD>
                        <TD BGCOLOR="#ccddff" STYLE="font-size:14px;border-width:1px;border-color:white" WIDTH="16%" COLSPAN="2">&nbsp;</TD>
                    </TR>

                    <TR>
                        <%
                            int x;
                            String dayBackColorStartWeek;
                            boolean displayCountAppointment;
                            String numberAppointment;
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

                                    x = Integer.parseInt(cellValue);

                                    if (i == weekStartDay) {
                                        dayBackColorStartWeek = "dayBackColorStartWeek";
                                    } else {
                                        dayBackColorStartWeek = "dayBackColor";
                                    }

                                    displayCountAppointment = false;
                                    numberAppointment = "";
                                    if (!cellValue.equalsIgnoreCase("0") && data.containsKey(cellValue) && !data.get(cellValue).equalsIgnoreCase("0")) {
                                        displayCountAppointment = true;
                                        numberAppointment = data.get(cellValue);
                                    }

                                    if (x >= currentDay) {
                        %>
                        <TD class="<%=dayBackColorStartWeek%>" onclick="popupShowAppointment(<%=cellValue%>);">
                            <div style="float: right; margin-top: 0px; width: 35px;height: 20px;border-radius: 3px 3px 3px 3px;text-align: center;display: <%if (displayCountAppointment) { %>block <% } else { %>none<%}%>"  class="num" id="number"><%=numberAppointment%></div>
                            <div style="width: 100%;padding-top: 10px;height: 45%;">
                                <% String num = "";
                                    if (cellValue.equals("0")) {%>
                                <b id="day"><%=num%></b>
                                <%} else {%>
                                <b id="day"><%=cellValue%></b>
                                <%}%>
                            </div>
                            <div style="width: 100%;height: 55%;" id="div1">
                                <div  class="save_app" onclick="" style="margin-left: auto;margin-right: auto;" ></div>
                            </div>
                        </TD>
                        <%
                        } else {
                            if (i == weekStartDay) {
                                dayBackColorStartWeek = "dayBackColorStartWeek";
                            } else {
                                dayBackColorStartWeek = "backColor";
                            }
                        %>
                        <TD class="<%=dayBackColorStartWeek%>" <% if (!cellValue.equals("0")) {%> onmouseover="this.style.cursor='pointer'" onclick="popupShowAppointment(<%=cellValue%>);"<% } %> STYLE="font-size:14px;border-width:1px;border-color:white;height:75px;" background="images/schedule.jpg">
                            <div style="float: right; margin-top: 0px; width: 35px;height: 20px;border-radius: 3px 3px 3px 3px;text-align: center;display: <%if (displayCountAppointment) { %>block <% } else { %>none<%}%>" class="num" id="number"><%=numberAppointment%></div>
                            <div style="width: 100%;padding-top: 30px;height: 45%;">
                                <% String num = "";
                                    if (cellValue.equals("0")) {%>
                                <b id="day"><%=num%></b>
                                <%} else {%>
                                <b id="day"><%=cellValue%></b>
                                <%}%>
                            </div>
                            <div style="width: 100%;height: 55%;"></div>
                        </TD>
                        <%}%>
                        <%
                        } else {
                        %>

                        <TD STYLE="font-size:16;border-width:1px;border-color:white;" ROWSPAN="<%=calRowsNumber%>" BGCOLOR="#ddeeff"><b><%=year%></b></TD>
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
                                x = Integer.parseInt(cellValue);

                                if (i == weekStartDay) {
                                    dayBackColorStartWeek = "dayBackColorStartWeek";
                                } else {
                                    dayBackColorStartWeek = "dayBackColor";
                                }

                                displayCountAppointment = false;
                                numberAppointment = "";
                                if (!cellValue.equalsIgnoreCase("0") && data.containsKey(cellValue) && !data.get(cellValue).equalsIgnoreCase("0")) {
                                    displayCountAppointment = true;
                                    numberAppointment = data.get(cellValue);
                                }
                                if (x >= currentDay) {%>
                        <TD class="<%=dayBackColorStartWeek%>" onclick="popupShowAppointment(<%=cellValue%>);">
                            <div style="float: right; margin-top: 0px; width: 35px;height: 20px;border-radius: 3px 3px 3px 3px;text-align: center;display: <%if (displayCountAppointment) { %>block <% } else { %>none<%}%>" class="num" id="number"><%=numberAppointment%></div>
                            <div style="width: 100%;padding-top: 10px;height: 45%;">
                                <% String num = "";
                                    if (cellValue.equals("0")) {%>
                                <b id="day"><%=num%></b>
                                <%} else {%>
                                <b id="day"><%=cellValue%></b>
                                <%}%>
                            </div>
                            <div style="width: 100%;height: 55%;" id="div1">
                                <div class="save_app" onclick="" style="margin-left: auto;margin-right: auto;"></div>
                            </div>
                        </TD>
                        <%
                        } else {
                            if (i == weekStartDay) {
                                dayBackColorStartWeek = "dayBackColorStartWeek";
                            } else {
                                dayBackColorStartWeek = "backColor";
                            }
                        %>
                        <TD class="<%=dayBackColorStartWeek%>" <% if (!cellValue.equals("0")) {%> onmouseover="this.style.cursor='pointer'" onclick="popupShowAppointment(<%=cellValue%>);"<% } %> STYLE="font-size:14px;border-width:1px;border-color:white;height:75px;" background="images/schedule.jpg">
                            <div style="float: right; margin-top: 0px; width: 35px;height: 20px;border-radius: 3px 3px 3px 3px;text-align: center;display: <%if (displayCountAppointment) { %>block <% } else { %>none<%}%>" class="num" id="number"><%=numberAppointment%></div>
                            <div style="width: 100%;padding-top: 10px;height: 45%;">
                                <% String num = "";
                                    if (cellValue.equals("0")) {%>
                                <b id="day"><%=num%></b>
                                <%} else {%>
                                <b id="day"><%=cellValue%></b>
                                <%}%>
                            </div>
                            <div style="width: 100%;height: 55%;">
                            </div>
                        </TD>
                        <%}%>
                        <%}%>
                        <TD STYLE="font-size:14px;border-width:1px;border-color:white;" ROWSPAN="<%=calRowsNumber%>" BGCOLOR="#ccddee">
                            <select name="currentMonth" id="currentMonth" style="width: 130px;height: 35px;color: blue;font-weight: bold; font-size: 16px" onchange="JavaScript:changeMonth(this);">
                                <% for (int i = 0; i < monthName.length; i++) {%>
                                <option value="<%=i%>" style="color: black;font-weight: bold; font-size: 13px" <%= (currentMonth == i) ? "selected" : ""%>><%=monthName[i]%></option>
                                <% } %>
                            </select>
                        </TD>
                    </TR>

                    <% for (int i = 0; i < calRowsNumber - 2; i++) { %>
                    <TR>
                        <%
                            for (int j = 0; j < 7; j++) {
                                if (minDate <= maxDate) {
                                    cellValue = new Integer(minDate).toString();
                                    minDate = minDate + 1;
                                } else {
                                    cellValue = "0";
                                }

                                x = Integer.parseInt(cellValue);

                                if (j == weekStartDay) {
                                    dayBackColorStartWeek = "dayBackColorStartWeek";
                                } else {
                                    dayBackColorStartWeek = "dayBackColor";
                                }

                                displayCountAppointment = false;
                                numberAppointment = "";
                                if (!cellValue.equalsIgnoreCase("0") && data.containsKey(cellValue) && !data.get(cellValue).equalsIgnoreCase("0")) {
                                    displayCountAppointment = true;
                                    numberAppointment = data.get(cellValue);
                                }

                                if (x >= currentDay) {%>
                        <TD class="<%=dayBackColorStartWeek%>" onclick="popupShowAppointment(<%=cellValue%>);">
                            <div style="float: right; margin-top: 0px; width: 35px;height: 20px;border-radius: 3px 3px 3px 3px;text-align: center;display: <%if (displayCountAppointment) { %>block <% } else { %>none<%}%>" class="num" id="number"><%=numberAppointment%></div>
                            <div style="width: 100%;padding-top: 10px;height: 45%;" >
                                <% String num = "";
                                    if (cellValue.equals("0")) {%>
                                <b id="day"><%=num%></b>
                                <%} else {%>
                                <b id="day"><%=cellValue%></b>
                                <% } %>
                            </div>
                            <div style="width: 100%;height: 55%;" id="div1">
                                <div  class="save_app" onclick="" style="margin-left: auto;margin-right: auto;" ></div>
                            </div>
                        </TD>

                        <%
                        } else {
                            if (j == weekStartDay) {
                                dayBackColorStartWeek = "dayBackColorStartWeek";
                            } else {
                                dayBackColorStartWeek = "backColor";
                            }
                        %>
                        <TD class="<%=dayBackColorStartWeek%>" STYLE="font-size:14px;border-width:1px;border-color:white;height:75px;">
                            <div style="width: 100%;padding-top: 10px;height: 45%;">
                                <% String num = "";
                                    if (cellValue.equals("0")) {%>
                                <b id="day"><%=num%></b>
                                <%} else {%>
                                <b id="day"><%=cellValue%></b>
                                <%}%>
                            </div>
                            <div style="width: 100%;height: 55%;">
                            </div>
                        </TD>
                        <%}%>
                        <%}%>
                    </TR>
                    <%}%>
                </TABLE>
                <br />
                <input type="hidden" name="peroid" id="peroid" value="other">
                </center>
            </div>
        </FORM>
    </body>
</html>


