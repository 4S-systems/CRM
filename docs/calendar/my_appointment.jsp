<%@page import="com.tracker.db_access.CampaignMgr"%>
<%@page import="com.crm.common.CRMConstants"%>
<%@page import="com.crm.common.CalendarUtils"%>
<%@page import="com.crm.common.CalendarUtils.Day"%>
<%@page import="com.clients.db_access.AppointmentNotificationMgr"%>
<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.DistributedItemsMgr,java.util.*,java.text.*,com.maintenance.common.ParseSideMenu"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page pageEncoding="UTF-8" %>
<html>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        Map<String, Map<String, WebBusinessObject>> data = (Map<String, Map<String, WebBusinessObject>>) request.getAttribute("data");
        List<Integer> years = (List<Integer>) request.getAttribute("years");
        List<CalendarUtils.Month> months = (List<CalendarUtils.Month>) request.getAttribute("months");
        List<CalendarUtils.Day> days = (List<CalendarUtils.Day>) request.getAttribute("days");
        Integer selectedYear = (Integer) request.getAttribute("selectedYear");
        Integer selectedMonth = (Integer) request.getAttribute("selectedMonth");

        String stat = (String) request.getSession().getAttribute("currentMode");
        String align = null;
        String dir = null;
        String title, titleRow, xAlign, interval, monthStr, yearStr, update, succeed, future, today, neglected, notes, cared;
        int xAxis, yAxis;
        if (stat.equals("En")) {
            xAxis = 0;
            yAxis = 0;
            align = "center";
            dir = "LTR";
            title = "My Appoientments";
            titleRow = "Client Name";
            xAlign = "right";
            interval = " INTERVAL ";
            monthStr = " MONTH ";
            yearStr = " YEAR ";
            update = " UPDATE ";
            succeed = " SUCCEED ";
            future = " FUTURISTIC ";
            today = " TO DO ";
            neglected = " FORGETTEN ";
            notes = " APPOINTMENTS NOT FOLLOWED UP WILL BE MARKED AS NEGLECTED AFTER 12 HOURS ";
            cared = " CARED ";
        } else {
            xAxis = 1100;
            yAxis = 0;
            align = "center";
            dir = "RTL";
            title = "متابعاتى";
            titleRow = "إسم العميل";
            xAlign = "left";
            interval = " خلال ";
            monthStr = " شهر ";
            yearStr = " سنة ";
            update = " تحديث ";
            succeed = " تمت بنجاح ";
            future = " مستقبلية ";
            today = " اليوم ";
            neglected = " أهملت ";
            notes = " سيتم وضع المتابعات مهملة إذا لم تتم متابعتها بعد 12 ساعة ";
            cared = " معتنى بها ";
        }
    %>
    <head>
        <meta http-equiv="Pragma" content="no-cache"/>
        <meta http-equiv="Expires" content="0"/>
        <link rel="stylesheet" href="js/custom_popup/jquery-ui.css" />
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script src="js/custom_popup/jquery-ui.js"></script>
        <style>
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
            function showCalendar(obj) {
                var selectedMonth = document.getElementById("selectedMonth").value;
                var selectedYear = document.getElementById("selectedYear").value;
                document.part_form.action = "<%=context%>/CalendarServlet?op=getMyAppointments&selectedYear=" + selectedYear + "&selectedMonth=" + selectedMonth;
                document.part_form.submit();
            }

            function openDailog(clientId, clientName, date) {
                var divTag = $("<div></div>");
                $.ajax({
                    type: "post",
                    url: '<%=context%>/AppointmentServlet?op=showAppointmentsForClient',
                    data: {
                        clientId: clientId,
                        date: date
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
                                            location.reload();
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

            function showToDayTommorowTasks(event, mainsrc) {
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

                if (tglStatue === 'off') {
                    for (i; i < allImg.length; i++) {
                        var imgDate = $(allImg[i]).attr('id').split(" ", 1);
                        if ($(allImg[i]).attr('src').indexOf(mainsrc) === -1) {
                            allImg[i].style.display = 'none';
                        } else {
                            if (imgDate === toTay) {
                                allImg[i].style.display = 'block';
                            } else {
                                allImg[i].style.display = 'none';
                            }
                        }
                    }

                    $(".tglToday").attr('name', 'on');
                    tglStatue = 'on';
                } else if (tglStatue === 'on') {
                    for (i; i < allImg.length; i++) {
                        allImg[i].style.display = 'block';
                    }

                    $(".tglToday").attr('name', 'off');
                    tglStatue = 'off';
                }
            }

            function  showfuturetasks(event, mainsrc) {
                var allTds = $(".imageName");
                var i = 0;
                var tglStatue = $(".tgl").attr('name');
                if (tglStatue === 'off') {
                    for (i; i < allTds.length; i++) {
                        if ($(allTds[i]).attr('src').indexOf(mainsrc) === -1) {
                            allTds[i].style.display = 'none';
                        } else {
                            allTds[i].style.display = 'block';
                        }
                    }
                    $(".tgl").attr('name', 'on');
                    tglStatue = 'on';
                } else if (tglStatue === 'on') {
                    for (i; i < allTds.length; i++) {
                        allTds[i].style.display = 'block';
                    }
                    $(".tgl").attr('name', 'off');
                    tglStatue = 'off';
                }
            }

            function openInNewWindow(url) {
                var win = window.open(url, '_blank');
                win.focus();
            }

            function exportToExcel() {
                console.log($("#departmentID option:selected").val());
                openInNewWindow("<%=context%>/CalendarServlet?op=getFutureAppToEmpExcel&type=manager&departmentID=" + $("#departmentID option:selected").val());
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

    <body onload="window.scrollTo(<%=xAxis%>,<%=yAxis%>)">
        <div style="width: 100%"></div>
        <form name="part_form" method="POST">
            <table dir="<%=dir%>" cellpadding="0" cellspacing="0" style="border: 2px solid #d3d5d4; width: 100%;">
                <tr style="width: 100%;">
                    <td style="text-align: <%=dir%>; color: blue; font-size: 14px; border-left-width: 0px; width: 50%;" nowrap class="silver_even_main" >
                        <table align="<%=align%>" dir="<%=dir%>" width="98%" cellpadding="0" cellspacing="0" style="border: 2px solid #d3d5d4">
                            <tr>
                                <td width="8%" style="text-align: center; color: blue; font-size: 16px; padding-left: 5px; border-left-width: 0px" nowrap class="silver_even_main" >
                                    <div> 
                                        <font size="3">
                                        <%=interval%> :
                                        </font>
                                    </div>
                                </td>

                                <td style="text-align: <%=dir%>; color: black; font-size: 14px; border-left-width: 0px; width: 12%;" class="silver_even_main" >
                                    <font size="2">
                                    <%=monthStr%> : 
                                    </font>
                                </td>

                                <td style="text-align: <%=dir%>; color: blue; font-size: 14px; border-left-width: 0px; width: 13%;" nowrap class="silver_even_main" >
                                    <select id="selectedMonth" name="selectedMonth" style="font-size: 14px; width: 100%">
                                        <% for (CalendarUtils.Month month : months) {%>
                                        <option style="font-weight: bold" value="<%=month.getNumber()%>" <%= (month.getNumber() == selectedMonth) ? "selected" : ""%>><%=month.getName()%></option>
                                        <% }%>
                                    </select>
                                </td>

                                <td style="text-align: <%=dir%>; color: black; font-size: 14px; border-left-width: 0px; width: 12%;" nowrap class="silver_even_main" >
                                    <font size="2">
                                    <%=yearStr%> : 
                                    </font>
                                </td>

                                <td style="text-align: <%=dir%>; color: blue; font-size: 14px; border-left-width: 0px; width: 13%;" nowrap class="silver_even_main" >
                                    <select id="selectedYear" name="selectedYear" style="font-size: 14px; width: 100%">
                                        <% for (Integer year : years) {%>
                                        <option style="font-weight: bold" value="<%=year%>" <%= (year.equals(selectedYear)) ? "selected" : ""%>><%=year%></option>
                                        <% }%>
                                    </select>
                                </td>

                                <td style="text-align: <%=dir%>; color: blue; font-size: 14px; border-left-width: 0px; width: 13%;" nowrap class="silver_even_main" >
                                    <button style="width: 100%" type="button" onclick="showCalendar(this)"><b style="font-weight: bold; font-size: 14px; vertical-align: middle">
                                            <font size="2">
                                            <%=update%> 
                                            </font>
                                            <img src="images/icons/refresh.png" width="20" height="20" style="vertical-align: middle"/>
                                    </button>
                                </td>
                            </tr>
                        </table>
                    </td>

                    <td style="text-align: <%=dir%>; color: blue; font-size: 14px; border-left-width: 0px; width: 50%;" nowrap class="silver_even_main" >
                        <table dir="<%=dir%>" cellpadding="0" cellspacing="0" style="border: 2px solid #d3d5d4; width: 100%;">
                            <tr style="width: 100%;">
                                <td style="text-align: <%=dir%>; color: purple; font-size: 14px; padding-left: 10px; border-left-width: 0px; width: 19%;" nowrap class="silver_even_main" >
                                    <img src="images/icons/<%=CRMConstants.APPOINTMENT_STATUS_IMAGES.get(CRMConstants.APPOINTMENT_STATUS_DONE)%>" width="20" height="20" style="vertical-align: middle"/>
                                    <font size="1">
                                    <%=succeed%> 
                                    </font>
                                </td>

                                <td style="text-align: <%=dir%>; color: purple; font-size: 14px; border-left-width: 0px; width: 19%;" nowrap class="silver_even_main" >
                                    <table style="width: 100%">
                                        <tr style="width: 100%">
                                            <td style="border: none ; width: 34%;">
                                                <label class="switch">
                                                    <input class="tgl" type="checkbox" onclick="showfuturetasks(event, 'calendar_circle_yellow');" name="off">
                                                    <div class="slider"></div>
                                                </label>
                                            </td>

                                            <td style="border: none ; width: 33%;">
                                                <img src="images/icons/<%=CRMConstants.APPOINTMENT_STATUS_IMAGES.get(CRMConstants.APPOINTMENT_STATUS_OPEN)%>" width="20" height="20" />
                                            </td>

                                            <td style="border: none ; width: 33%; color: purple;">
                                                <font size="1">
                                                <%=future%> 
                                                </font>
                                            </td>
                                        </tr>
                                    </table>
                                </td>

                                <td style="text-align: <%=dir%>; color: purple; font-size: 14px; border-left-width: 0px; width: 19%;" nowrap class="silver_even_main" >
                                    <table style="width: 100%">
                                        <tr style="width: 100%">
                                            <td style="border: none ; width: 34%">
                                                <label class="switch">
                                                    <input class="tglToday" type="checkbox" onclick="showToDayTommorowTasks(event, 'calendar_circle_yellow');" name="off">
                                                    <div class="slider"></div>
                                                </label>
                                            </td>
                                            <td style="border: none ; width: 33%">
                                                <img src="images/icons/<%=CRMConstants.APPOINTMENT_STATUS_IMAGES.get(CRMConstants.APPOINTMENT_STATUS_OPEN)%>" width="20" height="20" />
                                            </td>
                                            <td style="border: none ; width: 33%; color: purple;">
                                                <font size="1">
                                                <%=today%>
                                                </font>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                                <td style="text-align: <%=dir%>; color: purple; font-size: 14px; border-left-width: 0px; width: 19%;" nowrap class="silver_even_main" >
                                    <img src="images/icons/<%=CRMConstants.APPOINTMENT_STATUS_IMAGES.get(CRMConstants.APPOINTMENT_STATUS_CARED)%>" width="20" height="20" style="vertical-align: middle"/>
                                    <font size="1">
                                    <%=cared%> 
                                    </font> 
                                </td>
                                <td style="text-align: <%=dir%>; color: purple; font-size: 14px; border-left-width: 0px; width: 20%;" nowrap class="silver_even_main" >
                                    <img src="images/icons/<%=CRMConstants.APPOINTMENT_STATUS_IMAGES.get(CRMConstants.APPOINTMENT_STATUS_NEGLECTED)%>" width="20" height="20" style="vertical-align: middle"/>
                                    <font size="1">
                                    <%=neglected%> 
                                    </font>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>

                <tr dir="<%=dir%>" style="width: 100%; border: none;">
                    <td dir="<%=dir%>" colspan="2" style=" border: none; width: 100%;">
                        <font size="1" dir="<%=dir%>" style="float: <%=xAlign%>; color: blue; text-align: <%=dir%>">
                        <%=notes%> 
                        </font>
                    </td>
                </tr>
            </table>

            <br/>

            <table align="<%=align%>" dir="<%=dir%>" width="98%" cellpadding="0" cellspacing="0" style="border: 2px solid #d3d5d4">
                <tr>
                    <td class="blueBorder blueHeadertd" COLSPAN="<%=(days.size() + 2)%>" bgcolor="#669900" style="text-align:center;color:white;font-size:14px">
                        <div>
                            <b>
                                <%=title%>
                            </b>
                        </div>
                    </td>
                </tr>

                <tr>
                    <td rowspan="2" style="text-align: center" bgcolor="#DDDD00" nowrap class="silver_odd_main">
                        <b><font size="2" color="#000080" style="text-align: center;">#</font></b>
                    </td>

                    <td rowspan="2" class="silver_footer" bgcolor="#808000" style="width: 200px;text-align:center;color:black;font-size:14px">
                        <b><font color="#000080" style="text-align: center;"><%=titleRow%></font></b>
                    </td>
                </tr>

                <tr>
                    <% for (Day day : days) {%>
                    <td style="text-align: center" bgcolor="#DDDD00" nowrap  class="silver_odd_main dateTd" name="<%=day.getDay()%>" id="<%=day.getDay()%>">
                        <p class="dateTdChild"><font color="red"><%=day.getName()%></font>
                            <br/>
                            <b><%=day.getDay()%></b></P>
                    </td>
                    <%}%>
                </tr>
                <%
                    String clientId, clientName, currentStatusCode, imageName, bgColorm;
                    String cursor, clickAction, date;
                    Integer timeRemaining;
                    Map<String, WebBusinessObject> dayInfo;
                    WebBusinessObject appointment;
                    int flipper = 0;
                    for (Map.Entry<String, Map<String, WebBusinessObject>> entry : data.entrySet()) {
                        clientId = entry.getKey().split("@@")[0];
                        clientName = entry.getKey().split("@@")[1];
                        dayInfo = entry.getValue();
                        if ((flipper % 2) == 1) {
                            bgColorm = "silver_odd_main";
                        } else {
                            bgColorm = "silver_even_main";
                        }
                        flipper++;
                %>
                <tr>
                    <td style="text-align: center" bgcolor="#DDDD00" nowrap class="<%=bgColorm%>" >
                        <div>
                            <%=flipper%>
                        </div>
                    </td>

                    <td style="text-align: center" bgcolor="#DDDD00" nowrap class="<%=bgColorm%>" >
                        <div>
                            <a href="JavaScript: openInNewWindow('<%=context%>/ClientServlet?op=clientDetails&clientId=<%=clientId%>&showHeader=true');"><%=clientName%></a>
                        </div>
                    </td>

                <div id="coloredcircles">
                    <%
                        for (Day day : days) {
                            imageName = CRMConstants.APPOINTMENT_STATUS_IMAGES.get(CRMConstants.APPOINTMENT_STATUS_IMAGE_DEFAULT);
                            cursor = "default";
                            clickAction = "";
                            date = "";
                            appointment = dayInfo.get(day.getDay() + "");
                            if (appointment != null) {
                                currentStatusCode = (String) appointment.getAttribute("currentStatusCode");
                                timeRemaining = Integer.parseInt((String) appointment.getAttribute("timeRemaining"));

                                if (CRMConstants.APPOINTMENT_STATUS_DONE.equalsIgnoreCase(currentStatusCode)) {
                                    imageName = CRMConstants.APPOINTMENT_STATUS_IMAGES.get(CRMConstants.APPOINTMENT_STATUS_DONE);
                                } else if (CRMConstants.APPOINTMENT_STATUS_CARED.equalsIgnoreCase(currentStatusCode)) {
                                    imageName = CRMConstants.APPOINTMENT_STATUS_IMAGES.get(CRMConstants.APPOINTMENT_STATUS_CARED);
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
                                clickAction = "JavaScript: openDailog('" + clientId + "', '" + clientName + "', " + "'" + selectedYear + "/" + (selectedMonth + 1) + "/" + day.getDay() + "');";
                            }
                    %>

                    <td id="<%=imageName%>" style="text-align: center" bgcolor="#DDDD00" nowrap class="<%=bgColorm%> imageNametd" >
                        <div>
                            <%
                                if (imageName != CRMConstants.APPOINTMENT_STATUS_IMAGES.get(CRMConstants.APPOINTMENT_STATUS_IMAGE_DEFAULT)) {
                            %>
                            <img class="imageName" id="<%=date%>" src="images/icons/<%=imageName%>" onclick="<%=clickAction%>" width="24" height="24" style="vertical-align: middle; cursor: <%=cursor%> ; display: block"/>
                            <%
                                }
                            %>
                        </div>
                    </td>
                    <% }%>
                </div>
                <tr>
                    <% }%>
            </table>
        </form>
        <div class="modal"><!-- Place at bottom of page --></div>
    </body>
</html>
