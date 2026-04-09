<%-- 
    Document   : customer_servies_agenda_details
    Created on : Aug 7, 2017, 4:46:13 PM
    Author     : fatma
--%>

<%@page import="com.crm.common.CRMConstants"%>
<%@page import="com.clients.db_access.AppointmentNotificationMgr"%>
<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="com.tracker.engine.IssueStatusFactory, com.tracker.engine.*,java.text.*,com.docviewer.db_access.*, com.maintenance.db_access.*,com.maintenance.common.ParseSideMenu"%>

<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %> 

<%@ page contentType="text/HTML; charset=UTF-8" %>

<%@ page pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<HTML>
    <c:set var="loc" value="en"/>
    <c:if test="${!(empty sessionScope.currentMode)}">
      <c:set var="loc" value="${sessionScope.currentMode}"/>
    </c:if>
    
    <fmt:setLocale value="${loc}"  />
    <fmt:setBundle basename="Languages.employee_agenda.employee_agenda"  />
    
    <meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <meta HTTP-EQUIV="Expires" CONTENT="0">
    <head>
        <title>Secretary Agenda Details</title>

        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css"/>
        <link rel="stylesheet" href="css/demo_table.css"/>
        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/default/easyui.css"/>
        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/icon.css"/>
        
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>
        <script type="text/javascript" src="jquery-easyui/easyloader.js"></script>
        
        <script type="text/javascript">
            var oTable;
            
            $(document).ready(function() {
                oTable = $('#appointments').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[20, 25, 50, -1], [20, 25, 50, "All"]],
                    iDisplayLength: 20,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true,
                    "aaSorting": [[9, "asc"]]

                }).fadeIn(2000);
            });
        </script>
    </head>

    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();

        SecurityUser securityUser = (SecurityUser) session.getAttribute("securityUser");
        int withinSecretaryDetails = 24;
        Map<String, String> withinIntervals = securityUser.getWithinIntervals();
        if (request.getParameter("withinSecretaryDetails") != null) {
            withinSecretaryDetails = new Integer(request.getParameter("withinSecretaryDetails"));
            withinIntervals.put("withinSecretaryDetails", "" + withinSecretaryDetails);
        } else if (withinIntervals.containsKey("withinSecretaryDetails")) {
            withinSecretaryDetails = (new Integer(withinIntervals.get("withinSecretaryDetails")));
        }

        String timeFormat = "yyyy/MM/dd";
        SimpleDateFormat sdf = new SimpleDateFormat(timeFormat);
        Calendar cal = Calendar.getInstance();
        String nowTime = sdf.format(cal.getTime());
        String toDateVal = nowTime;
        cal.add(Calendar.DAY_OF_MONTH, -1);
        nowTime = sdf.format(cal.getTime());
        String fromDateVal = nowTime;
        if(request.getParameter("fromDate") != null) {
            fromDateVal = request.getParameter("fromDate");
            withinIntervals.put("fromDate", "" + fromDateVal);
        } else if (withinIntervals.containsKey("fromDate")) {
            fromDateVal = withinIntervals.get("fromDate");
        }
        
        if(request.getParameter("toDate") != null) {
            toDateVal = request.getParameter("toDate");
            withinIntervals.put("toDate", "" + toDateVal);
        } else if (withinIntervals.containsKey("toDate")) {
            toDateVal = withinIntervals.get("toDate");
        }
        
        WebBusinessObject userWbo = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
        AppointmentNotificationMgr notificationMgr = AppointmentNotificationMgr.getInstance();
        List<WebBusinessObject> appointments = notificationMgr.getAppointmentsByDepartmentOrdered(CRMConstants.CALL_RESULT_MEETING, "1491999749425", new java.sql.Date(sdf.parse(fromDateVal).getTime()), new java.sql.Date(sdf.parse(toDateVal).getTime()));
        
       appointments.addAll(notificationMgr.getAppointmentsByDepartmentOrdered(CRMConstants.CALL_RESULT_CALL, "1491999749425", new java.sql.Date(sdf.parse(fromDateVal).getTime()), new java.sql.Date(sdf.parse(toDateVal).getTime())));
        
        UserMgr userMgr = UserMgr.getInstance();
        List<WebBusinessObject> employees = userMgr.getUsersByGroupAndBranch(securityUser.getDefaultNewClientDistribution(), securityUser.getBranchesAsArray());

        ProjectMgr projectMgr = ProjectMgr.getInstance();
        List<WebBusinessObject> callResults = projectMgr.getCallResultsProjects();

        String state = (String) request.getSession().getAttribute("currentMode");
        String dir;
        String customerName, title, note, appointmentPlace, appointmentDate, timeRemaining, action, action2, employeeName, appType;
        if (state.equals("En")) {
            dir = "LTR";
            customerName = "Customer name";
            appType = " Appointment Type ";
            title = "Goal";
            note = "Note";
            appointmentPlace = "Place";
            appointmentDate = "Appointment Date";
            timeRemaining = "Time Remaining";
            action = "Redirect";
            action2 = "Neglected";
            employeeName = "Employee";
        } else {
            dir = "RTL";
            customerName = "اسم العميل";
            appType = " نوع المتابعة ";
            title = "الهدف";
            note = "ملاحظات";
            appointmentPlace = "المكان";
            appointmentDate = "تاريخ المقابلة";
            timeRemaining = "الوقت المتبقى";
            action = "توجـية";
            action2 = "تعـــديل";
            employeeName = "الموظف";
        }
        
        
    %>

    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
        $(function () {
            $("#toDate").datepicker({
                changeMonth: true,
                changeYear: true,
                dateFormat: 'yy/mm/dd'
            });
            
            $("#fromDate").datepicker({
                maxDate: "+d",
                changeMonth: true,
                changeYear: true,
                dateFormat: 'yy/mm/dd'
            });
        });
        
        function redirectAppointment(id, appType) {
            var issueId = document.getElementById('issueId' + id).value;
            var clientComplaintId = document.getElementById('clientComplaintId' + id).value;
            var employeeId = document.getElementById('employeeId' + id);

            hideAllIcon(id);

            var ticketType, subject, notes;
            if(appType == "meeting"){
                ticketType = <%=CRMConstants.CLIENT_COMPLAINT_TYPE_CLIENT_VISIT%>;
                subject = 'TS Client Visit';
                notes = 'TS Client Visit';
            } else if(appType == "call"){
                ticketType = <%=CRMConstants.CLIENT_COMPLAINT_TYPE_CALL%>;
                subject = 'Call';
                notes = 'Call';
            }
            
            $.ajax({
                type: "post",
                url: "<%=context%>/AppointmentServlet?op=redirectAppointment",
                data: {
                    appointmentId: id,
                    issueId: issueId,
                    clientComplaintId: clientComplaintId,
                    employeeId: employeeId.value,
                    ticketType: ticketType,
                    comment: 'Create Appointment For You',
                    subject: subject,
                    notes: notes
                },
                success: function(jsonString) {
                    var info = $.parseJSON(jsonString);
                    handelIconStatus(id, info.status);
                }, error: function(jsonString) {
                    handelIconStatus(id, "no");
                    alert(jsonString);
                }
            });
        }

        function hideAllIcon(id) {
            var employeeId = document.getElementById('employeeId' + id);
            var buttonRedirect = document.getElementById('button' + id);
            var iconDone = document.getElementById('icon' + id);
            var iconLoading = document.getElementById('loading' + id);

            var callResult = document.getElementById('callResult' + id);
            var buttonCallResult = document.getElementById('buttonCallResult' + id);
            var iconDone2 = document.getElementById('icon2' + id);
            var iconLoading2 = document.getElementById('loading2' + id);

            employeeId.style.display = "none";
            buttonRedirect.style.display = "none";
            iconDone.style.display = "none";
            iconLoading.style.display = "block";

            callResult.style.display = "none";
            buttonCallResult.style.display = "none";
            iconDone2.style.display = "none";
            iconLoading2.style.display = "block";
        }

        function handelIconStatus(id, status) {
            var employeeId = document.getElementById('employeeId' + id);
            var buttonRedirect = document.getElementById('button' + id);
            var iconDone = document.getElementById('icon' + id);
            var iconLoading = document.getElementById('loading' + id);

            var callResult = document.getElementById('callResult' + id);
            var buttonCallResult = document.getElementById('buttonCallResult' + id);
            var iconDone2 = document.getElementById('icon2' + id);
            var iconLoading2 = document.getElementById('loading2' + id);

            if (status == "ok") {
                employeeId.style.display = "none";
                buttonRedirect.style.display = "none";
                iconDone.style.display = "block";
                iconLoading.style.display = "none";

                callResult.style.display = "none";
                buttonCallResult.style.display = "none";
                iconDone2.style.display = "block";
                iconLoading2.style.display = "none";
            } else {
                employeeId.style.display = "block";
                buttonRedirect.style.display = "block";
                iconDone.style.display = "none";
                iconLoading.style.display = "none";

                callResult.style.display = "block";
                buttonCallResult.style.display = "block";
                iconDone2.style.display = "none";
                iconLoading2.style.display = "none";
            }
        }

        function ignoreAppointment(id) {
            var issueId = document.getElementById('issueId' + id).value;
            var clientComplaintId = document.getElementById('clientComplaintId' + id).value;
            var callResult = document.getElementById('callResult' + id);

            hideAllIcon(id);

            $.ajax({
                type: "post",
                url: "<%=context%>/AppointmentServlet?op=changeStatusAppointment",
                data: {
                    appointmentId: id,
                    issueId: issueId,
                    clientComplaintId: clientComplaintId,
                    callResult: callResult.value
                },
                success: function(jsonString) {
                    var info = $.parseJSON(jsonString);
                    handelIconStatus(id, info.status);
                }, error: function(jsonString) {
                    handelIconStatus(id, "no");
                    alert(jsonString);
                }
            });
        }

        function submitSecretaryDetails() {
            document.within_secretary_details_form.submit();
        }
        
        function submitform2()
        {
            document.within_form2.submit();
        }
    </SCRIPT>

    <BODY>
    <CENTER>
        <FIELDSET class="set" style="width:100%;" >
            <form name="within_form2" style="margin-left: auto; margin-right: auto;">
                <table class="blueBorder" id="code2" align="center" dir="<fmt:message key='direction'/>" width="650" cellspacing="2" cellpadding="1"
                       style="border-width:1px;border-color:white;display: block;">
                    <tr class="head">
                        <td class="blueHeaderTD" style="text-align: center; font-size: 14px; border-width: 1px; border-color: white; width: 325px;">
                            <b>
                                <font size=3 color="white">
                                    <fmt:message key="fromDate"/>
                                </font>
                            </b>
                        </td>
                        
                        <td class="blueHeaderTD" style="text-align: center; font-size: 14px; border-width: 1px; border-color: white; width: 325px;">
                            <b>
                                <font size=3 color="white">
                                    <fmt:message key="toDate"/>
                                </font>
                            </b>
                        </td>
                        
                        <td style="text-align: center; font-size: 14px; border-width: 1px; border-color: white; width: 250px;" bgcolor="#EEEEEE" valign="middle" rowspan="2">
                            <button type="submit" class="button" style="width: 170px;">
                                <fmt:message key="search"/>
                                <img height="15" src="images/search.gif"/>
                            </button>
                            
                            <br/>
                            <br/>
                        </td>
                    </tr>
                    
                    <tr>
                        <td style="text-align: center; font-size: 14px; border-width: 1px; border-color: white;" bgcolor="#EEEEEE" valign="middle">
                            <input id="fromDate" name="fromDate" type="text" value="<%=fromDateVal%>" readonly/>
                            <img src="images/showcalendar.gif"/>
                            
                            <br/>
                            <br/>
                        </td>
                        
                        <td style="text-align: center; font-size: 14px; border-width: 1px; border-color: white;" bgcolor="#EEEEEE" style="text-align:right" valign="middle">
                            <input id="toDate" name="toDate" type="text" value="<%=toDateVal%>" readonly/>
                            <img src="images/showcalendar.gif"/>
                            
                            <br/>
                            <br/>
                        </td>
                    </tr>
                </table>             
            </form>
            
            <TABLE id="appointments" align="center" DIR="<%=dir%>" WIDTH="100%" CELLPADDING="0" cellspacing="0" style="display: none;margin-top: 10px;">
                <thead>
                    <TR>
                        <TH>
                            <SPAN>
                                <img src="images/icons/client.png" width="20" height="20" />
                                <b style="font-weight: bold; font-size: 13px; color: black">
                                    <%=customerName%>
                                </b>
                            </SPAN>
                        </TH>
                        
                        <TH>
                            <SPAN>
                                <b style="font-weight: bold; font-size: 13px; color: black" title="Appointment Taker">
                                    <%=employeeName%>
                                </b>
                            </SPAN>
                        </TH>
                        
                        <TH>
                            <SPAN>
                                <b style="font-weight: bold; font-size: 13px; color: black">
                                    <%=appType%>
                                </b>
                            </SPAN>
                        </TH>
                        
                        <TH>
                            <SPAN>
                                <b style="font-weight: bold; font-size: 13px; color: black">
                                    <%=title%>
                                </b>
                            </SPAN>
                        </TH>
                        
                        <TH>
                            <SPAN>
                                <img src="images/icons/place.png" width="20" height="20" />
                                <b style="font-weight: bold; font-size: 13px; color: black">
                                    <%=appointmentPlace%>
                                </b>
                            </SPAN>
                        </TH>
                        
                        <TH>
                            <SPAN>
                                <img src="images/icons/appointment.png" width="20" height="20" />
                                <b style="font-weight: bold; font-size: 13px; color: black">
                                    <%=timeRemaining%>
                                </b>
                            </SPAN>
                        </TH>
                        
                        <TH>
                            <SPAN>
                                <img src="images/icons/appointment.png" width="20" height="20" />
                                <b style="font-weight: bold; font-size: 13px; color: black">
                                    <%=appointmentDate%>
                                </b>
                            </SPAN>
                        </TH>
                        
                        <TH>
                            <SPAN>
                                <img src="images/icons/distribute.png" style="padding-top: 5px" width="30" height="30" />
                            </SPAN>
                        </TH>
                        
                        <%if (metaMgr.isIsSsecretaryFullOption()) {%>
                            <TH>
                                <SPAN>
                                    <img src="images/icons/trash.png" style="padding-top: 5px" width="30" height="30" />
                                </SPAN>
                            </TH>
                        <%}%>
                    </TR>
                </thead>
                
                <tbody>  
                    <%
                        WebBusinessObject formattedTime;
                        String clientComplaintId, issueId, createdBy, userId, currentStatusCode;
                        int remaining;
                        boolean redirect, done, expired, update;
                        for (WebBusinessObject appointment : appointments) {
                            redirect = false;
                            done = false;
                            expired = false;
                            update = false;
                            clientComplaintId = (String) appointment.getAttribute("clientComplaintId");
                            issueId = (String) appointment.getAttribute("issueId");
                            userId = (String) appointment.getAttribute("userId");
                            createdBy = (String) appointment.getAttribute("createdBy");
                            remaining = Integer.parseInt((String) appointment.getAttribute("timeRemaining"));
                            currentStatusCode = (String) appointment.getAttribute("currentStatusCode");

                            if (CRMConstants.APPOINTMENT_STATUS_DONE.equalsIgnoreCase(currentStatusCode) || CRMConstants.APPOINTMENT_STATUS_CARED.equalsIgnoreCase(currentStatusCode)) {
                                done = true;
                            } else if (CRMConstants.APPOINTMENT_STATUS_OPEN.equalsIgnoreCase(currentStatusCode) && (remaining > - 24 * 60)) {
                                redirect = true;
                            } else if (CRMConstants.APPOINTMENT_STATUS_OPEN.equalsIgnoreCase(currentStatusCode) && (remaining >= -(24 * 60))) {
                                update = true;
                            } else if (CRMConstants.APPOINTMENT_STATUS_OPEN.equalsIgnoreCase(currentStatusCode)) {
                                expired = true;
                            }
                            update = update || redirect;
                            
                            if ((issueId != null) || (clientComplaintId != null)) {
                                String date = (String) appointment.getAttribute("appointmentDate");
                                String tempDate = date.split(" ")[0];
                                String[] dateArr = tempDate.contains("-") ? tempDate.split("-") : tempDate.split("/");
                                if (dateArr.length == 3) {
                                    if (dateArr[0].length() == 4) {
                                        date = dateArr[2] + "/" + dateArr[1] + "/" + dateArr[0] + " " + date.split(" ")[1];
                                    } else {
                                        date = dateArr[0] + "/" + dateArr[1] + "/" + dateArr[2] + " " + date.split(" ")[1];
                                    }
                                }
                                formattedTime = DateAndTimeControl.getFormattedDateTime2(date, state);
                    %>
                                    <TR>
                                        <TD>
                                            <a href="<%=context%>/ClientServlet?op=clientDetails&clientId=<%=appointment.getAttribute("clientId")%>">
                                                <b>
                                                    <%=appointment.getAttribute("clientName")%>
                                                </b>
                                            </a>
                                        </TD>
                                        
                                        <TD>
                                            <b>
                                                <%=appointment.getAttribute("createdByName")%>
                                            </b>
                                        </TD>
                                        
                                        <TD>
                                            <b>
                                                <%=appointment.getAttribute("option2")%>
                                            </b>
                                        </TD>
                                        
                                        <TD>
                                            <b>
                                                <%=appointment.getAttribute("title")%>
                                            </b>
                                        </TD>
                                        
                                        <TD>
                                            <b>
                                                <%=appointment.getAttribute("appointmentPlace")%>
                                            </b>
                                        </TD>
                                        
                                        <TD>
                                            <b>
                                                <%=(remaining <= 0 || done) ? "---" : DateAndTimeControl.getTimeRemainingFormatted((String) appointment.getAttribute("timeRemaining"), DateAndTimeControl.TimeType.MINUTES, state)%>
                                            </b>
                                        </TD>
                                        
                                        <TD>
                                            <font color="red">
                                            <%=formattedTime.getAttribute("day")%> - 
                                            </font>
                                            <b>
                                                <%=formattedTime.getAttribute("time")%>
                                            </b>
                                        </TD>
                                        
                                        <TD style="text-align: center">
                                            <input type="hidden" id="issueId<%=appointment.getAttribute("id")%>" name="issueId<%=appointment.getAttribute("id")%>" value="<%=issueId%>"/>
                                            
                                            <input type="hidden" id="clientComplaintId<%=appointment.getAttribute("id")%>" name="clientComplaintId<%=appointment.getAttribute("id")%>" value="<%=clientComplaintId%>"/>
                                            
                                            <select id="employeeId<%=appointment.getAttribute("id")%>" name="employeeId<%=appointment.getAttribute("id")%>" style="font-weight: bold; width: 100px; height: 22px; margin-bottom: 5px; vertical-align: middle; <%if (!redirect) {%>display: none<%}%>">
                                                <% for (WebBusinessObject employee : employees) {%>
                                                    <option value="<%=employee.getAttribute("userId")%>"><%=employee.getAttribute("fullName")%></option>
                                                <% }%>
                                            </select>
                                            
                                            &ensp;
                                            
                                            <button type="button" id="button<%=appointment.getAttribute("id")%>" onclick="JavaScript: redirectAppointment('<%=appointment.getAttribute("id")%>', '<%=appointment.getAttribute("option2")%>');" style="margin-bottom: 5px;  <%if (!redirect) {%>display: none<%}%>">
                                                <%=action%>
                                                <img src="images/icons/forward.png" width="15" height="15" />
                                            </button>
                                            
                                                &ensp;
                                            
                                            <center>
                                            <img id="icon<%=appointment.getAttribute("id")%>" src="images/icons/done.png" width="24" height="24" style="padding-top: 0px; padding-bottom: 5px; <%if (!done) {%>display: none<%}%>"/>
                                            <img id="loading<%=appointment.getAttribute("id")%>" src="images/icons/loading.gif" width="24" height="24" style="padding-top: 0px; padding-bottom: 5px; vertical-align: middle; display: none"/>
                                            <img id="expired<%=appointment.getAttribute("id")%>" src="images/icons/appointment_expired.png" width="24" height="24" style="padding-top: 0px; padding-bottom: 5px; vertical-align: middle; <%if (!expired) {%>display: none<%}%>" title="This appointment is out of date"/>
                                            </center>
                                        </TD>
                                
                                        <%if (metaMgr.isIsSsecretaryFullOption()) {%>
                                
                                            <TD style="text-align: center">
                                                <select id="callResult<%=appointment.getAttribute("id")%>" name="callResult<%=appointment.getAttribute("id")%>" style="font-weight: bold; width: 100px; height: 22px; margin-bottom: 5px; vertical-align: middle; <%if (!update) {%>display: none<%}%>">
                                                    <% for (WebBusinessObject callResult : callResults) {%>
                                                        <option value="<%=callResult.getAttribute("projectID")%>"><%=callResult.getAttribute("projectName")%></option>
                                                    <% }%>
                                                </select>
                                                
                                                &ensp;
                                                
                                                <button type="button" id="buttonCallResult<%=appointment.getAttribute("id")%>" onclick="JavaScript: ignoreAppointment('<%=appointment.getAttribute("id")%>');" style="margin-bottom: 5px;  <%if (!update) {%>display: none<%}%>">
                                                    <%=action2%>
                                                    <img src="images/icons/update_ready.png" width="15" height="15" />
                                                </button>
                                                
                                                    &ensp;
                                                <center>
                                                    <img id="icon2<%=appointment.getAttribute("id")%>" src="images/icons/done.png" width="24" height="24" style="padding-top: 0px; padding-bottom: 5px; <%if (!done) {%>display: none<%}%>"/>
                                                    <img id="loading2<%=appointment.getAttribute("id")%>" src="images/icons/loading.gif" width="24" height="24" style="padding-top: 0px; padding-bottom: 5px; vertical-align: middle; display: none"/>
                                                    <img id="expired2<%=appointment.getAttribute("id")%>" src="images/icons/appointment_expired.png" width="24" height="24" style="padding-top: 0px; padding-bottom: 5px; vertical-align: middle; <%if (!expired) {%>display: none<%}%>" title="This appointment is out of date"/>
                                                </center>
                                            </TD>
                                        <%}%>
                                    </TR>
                                <% }%>
                            <% }%>
                    </tbody>
                </TABLE>
            </FIELDSET>
        </CENTER>
    </BODY>
</HTML>