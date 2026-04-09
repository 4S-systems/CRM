<%@page import="com.tracker.db_access.CampaignMgr"%>
<%@page import="com.crm.common.CRMConstants"%>
<%@page import="com.crm.common.CalendarUtils"%>
<%@page import="com.crm.common.CalendarUtils.Day"%>
<%@page import="com.clients.db_access.AppointmentNotificationMgr"%>
<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.DistributedItemsMgr,java.util.*,java.text.*,com.maintenance.common.ParseSideMenu"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<%@page pageEncoding="UTF-8" %>
<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
        String loggegUserId = (String) loggedUser.getAttribute("userId");

        Map<String, Map<String, WebBusinessObject>> data = (Map<String, Map<String, WebBusinessObject>>) request.getAttribute("data");
        List<Integer> years = (List<Integer>) request.getAttribute("years");
        List<CalendarUtils.Month> months = (List<CalendarUtils.Month>) request.getAttribute("months");
        List<CalendarUtils.Day> days = (List<CalendarUtils.Day>) request.getAttribute("days");
        Integer selectedYear = (Integer) request.getAttribute("selectedYear");
        Integer selectedMonth = (Integer) request.getAttribute("selectedMonth");

        ArrayList<WebBusinessObject> departments = (ArrayList<WebBusinessObject>) request.getAttribute("departments");
        String departmentID = request.getAttribute("departmentID") != null ? (String) request.getAttribute("departmentID") : "";

        String cMode = (String) request.getSession().getAttribute("currentMode");
        String stat = cMode;
        String align = null;
        String dir = null;
        String PL, titleRow, xAlign, viewApntmntWthn, mnth, yr, dprtmnt, all, updt, gud, sDn, futr, tDo, dFllwUp, nglctd, clntFllwUp, clnt,
                cmmnt, nDir, nt, lstApp, target, mechanism, Adate, call, meeting, place, save, Aalign, ndir, cared;
        int xAxis, yAxis;
        if (stat.equals("En")) {
            xAxis = 0;
            yAxis = 0;
            align = "center";
            dir = "LTR";
            PL = "Customer Appoientment";
            titleRow = "Client Name";
            xAlign = "right";
            
            viewApntmntWthn = " INTERVAL ";
            mnth = " MONTH ";
	    yr = " YEAR ";
	    dprtmnt = " DEPARTMENT ";
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
            cared = " CARED ";
        } else {
            xAxis = 1100;
            yAxis = 0;
            align = "center";
            dir = "RTL";
            PL = "مقابلات العملاء";
            titleRow = "إسم العميل";
            xAlign = "left";
            
            viewApntmntWthn = " خلال ";
	    mnth = " شهر ";
	    yr = " سنة ";
	    dprtmnt = " الأدارة ";
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
            cared = " معتنى بها ";
        }
    %>
    <head>
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
                document.part_form.action = "<%=context%>/CalendarServlet?op=genericAppointmentCalendar&selectedYear=" + selectedYear + "&selectedMonth=" + selectedMonth;
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
                    success: function(data) {
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
                                        Ok: function() {
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
            
            function openInNewWindow(url) {
                var win = window.open(url, '_blank');
                win.focus();
            }
            
            function exportToExcel() {
                console.log($("#departmentID option:selected").val());
                openInNewWindow("<%=context%>/CalendarServlet?op=getFutureAppToEmpExcel&type=manager&departmentID="+$("#departmentID option:selected").val());
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
                display: block;
            }
        </style>
    </head>
    
    <body onload="window.scrollTo(<%=xAxis%>,<%=yAxis%>)">
        <div style="width: 100%"></div>
        <div style="width: 100%; text-align: center;">
        <button type="button" style="color: #000;font-size:15px;font-weight:bold; width: 90px; height: 30px; vertical-align: top; margin-bottom: 3px;"
                title="Export Future Appointments to Excel" onclick="exportToExcel();">Excel &nbsp;<img height="15" src="images/icons/excel.png" />
        </button>
        </div>
        <FORM NAME="part_form" METHOD="POST">
            <TABLE dir="<%=dir%>" CELLPADDING="0" CELLSPACING="0" STYLE="border: 2px solid #d3d5d4; width: 100%;">
                <TR style="width: 100%;">
		    <TD STYLE="text-align: <%=dir%>; color: blue; font-size: 14px; border-left-width: 0px; width: 50%;" nowrap CLASS="silver_even_main" >
                        <TABLE ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="98%" CELLPADDING="0" CELLSPACING="0" STYLE="border: 2px solid #d3d5d4">
                            <TR>
                                <TD width="8%" STYLE="text-align: center; color: blue; font-size: 16px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
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
					 <%=dprtmnt%> : 
				    </font>
				</TD>
                                
                                <TD STYLE="text-align: <%=dir%>; color: blue; font-size: 14px; border-left-width: 0px; width: 13%;" nowrap CLASS="silver_even_main" >
                                    <select id="departmentID" name="departmentID" style="font-size: 14px; width: 100%;">
                                        <sw:WBOOptionList wboList="<%=departments%>" displayAttribute="projectName" valueAttribute="projectID" scrollToValue="<%=departmentID%>" />
                                    </select>
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
                    </TD>
                    
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
                </TR>
                
                <TR dir="<%=dir%>" style="width: 100%; border: none;">
		    <td dir="<%=dir%>" colspan="2" style=" border: none; width: 100%;">
                        <font size="1" dir="<%=dir%>" style="float: <%=xAlign%>; color: blue; text-align: <%=dir%>">
			     <%=nt%> 
			</font>
                    </TD>
                </TR>
            </TABLE>
                        
            <br>
                                
            <TABLE ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="98%" CELLPADDING="0" CELLSPACING="0" STYLE="border: 2px solid #d3d5d4">
                <TR>
                    <TD class="blueBorder blueHeaderTD" COLSPAN="<%=(days.size() + 2)%>" bgcolor="#669900" STYLE="text-align:center;color:white;font-size:14px">
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
                    
                    <TD rowspan="2" class="silver_footer" bgcolor="#808000" STYLE="width: 200px;text-align:center;color:black;font-size:14px">
                        <b><font color="#000080" style="text-align: center;"><%=titleRow%></font></b>
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
                <TR>
                    <TD STYLE="text-align: center" BGCOLOR="#DDDD00" nowrap  CLASS="<%=bgColorm%>" >
                        <DIV>
                            <%=flipper%>
                        </DIV>
                    </TD>
                    
                    <TD STYLE="text-align: center" BGCOLOR="#DDDD00" nowrap  CLASS="<%=bgColorm%>" >
                        <DIV>
                            <%--<a href="JavaScript: openInNewWindow('<%=context%>/ClientServlet?op=clientDetails&amp;clientId=<%=clientWbo.getAttribute("id")%>');">--%>
                            <a href="JavaScript: openInNewWindow('<%=context%>/ClientServlet?op=clientDetails&clientId=<%=clientId%>&showHeader=true');"><%=clientName%></a>
                        </DIV>
                    </TD>
                    
                    <DIV id="coloredcircles">
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
                                    } /*else if (CRMConstants.APPOINTMENT_STATUS_DIRECT_FOLLOW_UP.equalsIgnoreCase(currentStatusCode)) {
                                        imageName = CRMConstants.APPOINTMENT_STATUS_IMAGES.get(CRMConstants.APPOINTMENT_STATUS_DIRECT_FOLLOW_UP);
                                    } */else if (timeRemaining >= -(12 * 60) && CRMConstants.APPOINTMENT_STATUS_OPEN.equalsIgnoreCase(currentStatusCode)) {
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

                            <TD id="<%=imageName%>" STYLE="text-align: center" BGCOLOR="#DDDD00" nowrap  CLASS="<%=bgColorm%> imageNametd" >
                            <DIV>
                                <%
                                    if(imageName != CRMConstants.APPOINTMENT_STATUS_IMAGES.get(CRMConstants.APPOINTMENT_STATUS_IMAGE_DEFAULT)){
                                %>
                                        <img class="imageName" id="<%=date%>" src="images/icons/<%=imageName%>" onclick="<%=clickAction%>" width="24" height="24" style="vertical-align: middle; cursor: <%=cursor%> ; display: block"/>
                                <%
                                    }
                                %>
                            </DIV>
                        </TD>
                        <% }%>
                    </DIV>
                <TR>
                    <% }%>
            </TABLE>
        </FORM>
        <div class="modal"><!-- Place at bottom of page --></div>
    </body>
</html>
