<%@page import="com.maintenance.common.UserDepartmentConfigMgr"%>
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

        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css"/>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery-ui-timepicker-addon.css"/>
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css"/>
        <link rel="stylesheet" href="css/demo_table.css"/>
        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/default/easyui.css"/>
        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/icon.css"/>
        <link rel="stylesheet" href="js/custom_popup/jquery-ui.css" />
        <link rel="stylesheet" href="js/vis-4.21.0/vis.css" />
        <link rel="stylesheet" href="js/jquery-ui-timepicker-addon.css" />
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <script type="text/javascript" src="jquery-easyui/easyloader.js"></script>
        <script type="text/javascript" language="javascript" src="js/vis-4.21.0/vis.js"></script>
        <script src="js/custom_popup/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery-ui-timepicker-addon.js"></script> 
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
        Calendar calendar = Calendar.getInstance();
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
        cal.add(Calendar.DAY_OF_MONTH, -3);
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
        List<WebBusinessObject> userProjects = new ArrayList<>(ProjectMgr.getInstance().getOnArbitraryKeyOracle(CRMConstants.PROJECT_TYPE_BRANCH_ID, "key2"));
        ArrayList<WebBusinessObject> usersList = UserMgr.getInstance().getAllDistributionUsers((String) ((WebBusinessObject) request.getSession().getAttribute("loggedUser")).getAttribute("userId"));
        ArrayList<WebBusinessObject> departments = new ArrayList<WebBusinessObject>();
        ProjectMgr projectMgr=ProjectMgr.getInstance();
        UserDepartmentConfigMgr  userDepartmentConfigMgr = UserDepartmentConfigMgr.getInstance();
        WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
        ArrayList<WebBusinessObject> userDepartments = new ArrayList<WebBusinessObject>(userDepartmentConfigMgr.getOnArbitraryKeyOracle((String) loggedUser.getAttribute("userId"), "key2"));
        for (WebBusinessObject userDepartmentWbo : userDepartments) {
            if(projectMgr.getOnSingleKey((String) userDepartmentWbo.getAttribute("department_id")) != null){
                departments.add(projectMgr.getOnSingleKey((String) userDepartmentWbo.getAttribute("department_id")));
            }
        }
        WebBusinessObject userWbo = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
        AppointmentNotificationMgr notificationMgr = AppointmentNotificationMgr.getInstance();
        List<WebBusinessObject> appointments =new ArrayList<WebBusinessObject>();
        
        appointments= notificationMgr.getAppointmentsByDateOrdered(CRMConstants.CALL_RESULT_MEETING,
         (String) userWbo.getAttribute("userId"), new java.sql.Date(sdf.parse(fromDateVal).getTime()), new java.sql.Date(sdf.parse(toDateVal).getTime()), null,request.getParameter("departmentID")==null?" ":request.getParameter("departmentID").toString());
        String departmentID = request.getParameter("departmentID") != null ? (String) request.getParameter("departmentID") : "";
        UserMgr userMgr = UserMgr.getInstance();
        List<WebBusinessObject> employees = userMgr.getUsersByGroupAndBranch(securityUser.getDefaultNewClientDistribution(), securityUser.getBranchesAsArray());

         projectMgr = ProjectMgr.getInstance();
        List<WebBusinessObject> callResults = projectMgr.getCallResultsProjects();
        
        //Privileges
        ArrayList<String> privilegesList = GroupPrevMgr.getInstance().getGroupPrivilegeCodes((String) ((WebBusinessObject) request.getSession().getAttribute("loggedUser")).getAttribute("groupID"));

        String state = (String) request.getSession().getAttribute("currentMode");
        String dir, xAlign, sAlign;
        String customerName, title, mobile, note, appointmentPlace, appointmentDate, timeRemaining, action, action2, employeeName, responsibleName,department;
        if (state.equals("En")) {
            xAlign = "right";
            sAlign ="left";
            dir = "LTR";
            customerName = "Customer name";
            title = "Goal";
            note = "Note";
            appointmentPlace = "Place";
            appointmentDate = "Appointment Date";
            timeRemaining = "Time Remaining";
            action = "Redirect";
            action2 = "Neglected";
            employeeName = "Employee";
            mobile = "Mobile";
            responsibleName = "Responsible";
            department="Department";
        } else {
            xAlign = "left";
            sAlign = "right";
            dir = "RTL";
            customerName = "اسم العميل";
            title = "الهدف";
            note = "ملاحظات";
            appointmentPlace = "المكان";
            appointmentDate = "تاريخ المقابلة";
            timeRemaining = "الوقت المتبقى";
            action = "توجـية";
            action2 = "تعـــديل";
            employeeName = "الموظف";
            mobile = "الموبايل";
            responsibleName = "المسؤول";
            department="اﻷدارة";
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
            $("#userMeetingDate").datetimepicker({
                changeMonth: true,
                changeYear: true,
                minDate: 0,
                maxDate: "+1m",
                dateFormat: "yy/mm/dd",
                timeFormat: "HH:mm"
            });
        });
        function redirectAppointment(id) {
            var issueId = document.getElementById('issueId' + id).value;
            var clientComplaintId = document.getElementById('clientComplaintId' + id).value;
            var employeeId = document.getElementById('employeeId' + id);
console.log("dfjkghjkdf");
            hideAllIcon(id);


            $.ajax({
                type: "post",
                url: "<%=context%>/AppointmentServlet?op=redirectAppointment",
                data: {
                    appointmentId: id,
                    issueId: issueId,
                    clientComplaintId: clientComplaintId,
                    employeeId: employeeId.value,
                    ticketType: '<%=CRMConstants.CLIENT_COMPLAINT_TYPE_CLIENT_VISIT%>',
                    comment: 'Create Appointment For You',
                    subject: 'TS Client Visit',
                    notes: 'TS Client Visit'
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

            var buttonCallResult = document.getElementById('buttonCallResult' + id);
            var iconDone2 = document.getElementById('icon2' + id);
            var iconLoading2 = document.getElementById('loading2' + id);

            employeeId.style.display = "none";
            buttonRedirect.style.display = "none";
            iconDone.style.display = "none";
            iconLoading.style.display = "block";

            <%
                if (privilegesList.contains("DIRECT_APPOINTMENT")) {
            %>
                    try {
                        buttonCallResult.style.display = "none";
                        iconDone2.style.display = "none";
                        iconLoading2.style.display = "block";
                    } catch (err) {
                    }
            <%
                }
            %>
        }

        function handelIconStatus(id, status) {
            var employeeId = document.getElementById('employeeId' + id);
            var buttonRedirect = document.getElementById('button' + id);
            var iconDone = document.getElementById('icon' + id);
            var iconLoading = document.getElementById('loading' + id);

            var buttonCallResult = document.getElementById('buttonCallResult' + id);
            var iconDone2 = document.getElementById('icon2' + id);
            var iconLoading2 = document.getElementById('loading2' + id);

                if (status == "ok") {
                    employeeId.style.display = "none";
                    buttonRedirect.style.display = "none";
                    iconDone.style.display = "block";
                    iconLoading.style.display = "none";

                    buttonCallResult.style.display = "none";
                    iconDone2.style.display = "block";
                    iconLoading2.style.display = "none";
                } else {
                    employeeId.style.display = "block";
                    buttonRedirect.style.display = "block";
                    iconDone.style.display = "none";
                    iconLoading.style.display = "none";

                    buttonCallResult.style.display = "block";
                    iconDone2.style.display = "none";
                    iconLoading2.style.display = "none";
                }
        }

        function ignoreAppointment(id) {
            var issueId = document.getElementById('issueId' + id).value;
            var clientComplaintId = document.getElementById('clientComplaintId' + id).value;

            hideAllIcon(id);

            $.ajax({
                type: "post",
                url: "<%=context%>/AppointmentServlet?op=changeStatusAppointment",
                data: {
                    appointmentId: id,
                    issueId: issueId,
                    clientComplaintId: clientComplaintId,
                    callResult: ''
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
        function popupUserAppointment(appointmentID, userID, clientID, appointmentDate) {
            $("#appointmentID").val(appointmentID);
            $("#userID").val(userID);
            $("#clientID").val(clientID);
            $("#userMeetingDate").val(appointmentDate);
            $('#user_appointment').css("display", "block");
            $('#user_appointment').bPopup();
        }
        
        function saveUserAppointment() {
            if ($("#userID").val() === null || $("#userID").val() === ""){
                alert("<fmt:message key="selectEmployeeMsg" />");
            } else if ($("#userComment").val() === null || $("#userComment").val() === ""){
                alert("<fmt:message key="commentRequiresMsg" />");
            } else {
                var clientID = $("#clientID").val();
                var meetingDate = $("#userMeetingDate").val();
                var appointmentPlace = $("#userAppointmentPlace").val();
                var comment = $("#userComment").val();
                $.ajax({
                    type: "post",
                    url: "<%=context%>/ClientServlet?op=saveUserAppointment",
                    data: {
                        clientID: clientID,
                        userID: $("#userID").val(),
                        appointmentPlace: appointmentPlace,
                        comment: comment,
                        meetingDate: meetingDate,
                        appointmentID: $("#appointmentID").val()
                    }, success: function (jsonString) {
                        var result = $.parseJSON(jsonString);
                        if (result.status === 'ok') {
                            $("#userProgress").hide();
                            $('#user_appointment').css("display", "none");
                            $('#user_appointment').bPopup().close();
                            location.reload();
                        } else if (result.status === 'no') {
                            $("#userProgress").show();
                            $("#userAppointmentMsg").html("<fmt:message key="failMsg" />").show();
                        }
                        $("#userID").val("");
                        $("#userComment").val("");
                        $("#appointmentNo").html("0");
                    }
                });
            }
        }
        function getAppointmentsNo() {
            var userID = $("#userID").val();
            var meetingDate = $("#userMeetingDate").val();
            if (userID !== '') {
                $.ajax({
                    type: "post",
                    url: "<%=context%>/AppointmentServlet?op=getAppointmentsCountAjax",
                    data: {
                        userID: userID,
                        meetingDate: meetingDate.substring(0, 10)
                    }, success: function (jsonString) {
                        var result = $.parseJSON(jsonString);
                        $("#appointmentNo").html(result.appointmentNo);
                    }
                });
            }
        }
        function cancelAppointment() {
            var comment = $("#userComment").val();
            if (comment === null || comment === ""){
                alert("<fmt:message key="commentRequiresMsg" />");
            } else {
                var r = confirm("Are you sure?");
                if (r) {
                    $.ajax({
                        type: "post",
                        url: "<%=context%>/ClientServlet?op=cancelAppointment",
                        data: {
                            comment: comment,
                            appointmentID: $("#appointmentID").val()
                        }, success: function (jsonString) {
                            var result = $.parseJSON(jsonString);
                            if (result.status === 'ok') {
                                location.reload();
                            } else if (result.status === 'no') {
                                $("#userProgress").show();
                                $("#userAppointmentMsg").html("<fmt:message key="failMsg" />").show();
                            }
                            $("#userID").val("");
                            $("#userComment").val("");
                            $("#appointmentNo").html("0");
                        }
                    });
                }
            }
        }
        function closePopup(obj) {
            $(obj).parent().parent().bPopup().close();
        }
        function openDailog(userId, date) {
            var divTag = $("<div></div>");
            $.ajax({
                type: "post",
                url: '<%=context%>/AppointmentServlet?op=showAppointmentsForUser',
                data: {
                    userId: userId,
                    date: date
                },
                success: function(data) {
                    divTag.html(data)
                            .dialog({
                                modal: true,
                                title: "",
                                show: "blind",
                                hide: "explode",
                                width: 1200,
                                dialogClass: "no-close",
                                closeOnEscape: false,
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
    </SCRIPT>
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
        body { font-size: 62.5%; }
        .no-close .ui-dialog-titlebar-close {display: none;}
    </style>

    <BODY>
    <CENTER>
        <FIELDSET class="set" style="width:100%;" >
            <%--<FORM name="within_secretary_details_form">
                <b style="font-size: medium;">عرض المقابلات :</b>
                <SELECT name="withinSecretaryDetails" STYLE="width:125px; font-size: medium; font-weight: bold;" onchange="JavaScript: submitSecretaryDetails();">
                    <OPTION value="1" <%=withinSecretaryDetails == 1 ? "selected" : ""%>>بعد ساعة</OPTION>
                    <OPTION value="2" <%=withinSecretaryDetails == 2 ? "selected" : ""%>>بعد ساعتان</OPTION>
                    <OPTION value="3" <%=withinSecretaryDetails == 3 ? "selected" : ""%>>بعد 3 ساعات</OPTION>
                    <OPTION value="24" <%=withinSecretaryDetails == 24 ? "selected" : ""%>>اليوم</OPTION>
                    <OPTION value="48" <%=withinSecretaryDetails == 48 ? "selected" : ""%>>بعد يومان</OPTION>
                    <OPTION value="72" <%=withinSecretaryDetails == 72 ? "selected" : ""%>>بعد 3 أيام</OPTION>
                    <OPTION value="168" <%=withinSecretaryDetails == 168 ? "selected" : ""%>>بعد أسبوع</OPTION>
                    <OPTION value="10000" <%=withinSecretaryDetails == 10000 ? "selected" : ""%>>غير محدد</OPTION>
                </SELECT>
            </FORM>--%>
            <div id="user_appointment" style="width: 70% !important;display: none;position: fixed">
                <div style="clear: both;margin-left: 80%;margin-top: 0px;margin-bottom: -38px;z-index: -10000000;">
                    <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                                                 -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                                                 box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                                                 -webkit-border-radius: 100px;
                                                 -moz-border-radius: 100px;
                                                 border-radius: 100px;" onclick="closePopup(this)"/>
                </div>
                <div class="login" style="width: 60%;margin-bottom: 10px;margin-left: auto;margin-right: auto;">
                    <h1 align="center" style="background-color: #ff9a98; vertical-align: middle"><fmt:message key="upadteAppointment" /> &nbsp;&nbsp;&nbsp;<img src="images/icons/meeting.png" alt="phone" width="24px"/></h1>
                    <div style="text-align: left;margin-left: 2%;margin-right: auto;" > 
                        <span style="font-size: 20px; font-weight: bolder; color: black; padding-left: 10px;"><fmt:message key="appointmentNo" /> :</span>
                        <span id="appointmentNo" style="font-size: 30px; font-weight: bolder; color: black; padding-left: 10px;">0</span>
                    </div>
                    <br />
                    <table class="table" dir="<%=dir%>">
                        <tr>
                            <td style="color: #f1f1f1; font-size: 16px; font-weight: bold; text-align: <%=xAlign%>;"><fmt:message key="employee" /> :</td>
                            <td td style="text-align:<%=sAlign%>" id="callResultTD">
                                <select id="userID" name="userID" style="width: 180px; font-size: medium; font-weight: bold;"
                                        onchange="JavaScript: getAppointmentsNo();">
                                    <option value="">choose</option>
                                    <sw:WBOOptionList wboList="<%=usersList%>" displayAttribute="fullName" valueAttribute="userId" />
                                </select>
                                <input type="hidden" name="appointmentID" id="appointmentID" />
                                <input type="hidden" name="clientID" id="clientID" />
                            </td>
                        </tr>
                        <tr>
                            <td style="color:#f1f1f1; font-size: 16px; font-weight: bold; text-align: <%=xAlign%>;"><fmt:message key="appointmentDate"/> :  </td>
                            <td td style="text-align:<%=sAlign%>">
                                <input name="userMeetingDate" id="userMeetingDate" type="text" maxlength="50" value="<%=nowTime%>" style="width: 180px;"
                                       onchange="JavaScript: getAppointmentsNo();"/>
                            </td>
                        </tr>
                        <tr>
                            <td style="color:#f1f1f1; font-size: 16px; font-weight: bold; text-align: <%=xAlign%>;"><fmt:message key="branch" /> : </td>
                            <td td style="text-align:<%=sAlign%>">
                                <select id="userAppointmentPlace" name="userAppointmentPlace" style="margin-top: 7px;width:180px;font-size: medium;">
                                    <sw:WBOOptionList wboList='<%=userProjects%>' displayAttribute = "projectName" valueAttribute="projectName" />
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td style="color:#f1f1f1; font-size: 16px;font-weight: bold; text-align: <%=xAlign%>;"><fmt:message key="comment" /> : <br/></td>
                            <td colspan="2" style="text-align:right">
                                <textarea cols="26" rows="10" id="userComment" style="width: 99%; background-color: #FFF7D6;"></textarea>
                            </td>
                        </tr>
                    </table>
                    <div style="text-align: left;margin-left: 2%;margin-right: auto;" > 
                        <button type="button" onclick="javascript: saveUserAppointment();" style="font-size: 14px; font-weight: bold; width: 120px"><fmt:message key="update" /><img style="height:20px; width: 20px" src="images/icons/meeting.png"/></button>
                        <button type="button" onclick="javascript: cancelAppointment();" style="font-size: 14px; font-weight: bold; width: 120px"><fmt:message key="cancel" /><img style="height:20px; width: 20px" src="images/cancel.png"/></button>
                    </div>
                    <div id="userProgress" style="display: none;">
                        <img src="images/Loading2.gif" width="32px" height="32px;" style="background-repeat: no-repeat;margin-left: auto;margin-right: auto"/>
                    </div>
                    <div style="margin: 0 auto;display: none; width: 90%;text-align: center;color: white;font-size: 16px;font-weight: bold" id="userAppointmentMsg"></div>
                </div>  
            </div>
            
            <form name="within_form2" style="margin-left: auto; margin-right: auto;">
                <table class="blueBorder" id="code2" align="center" dir="<fmt:message key='direction'/>" width="650" cellspacing="2" cellpadding="1"
                       style="border-width:1px;border-color:white;display: block;">
                    <tr class="head">
                        <td class="blueHeaderTD" style="text-align: center; font-size: 14px; border-width: 1px; border-color: white; width: 325px;">
                            <b><font size=3 color="white"><fmt:message key="fromDate"/></font></b>
                        </td>
                        <td class="blueHeaderTD" style="text-align: center; font-size: 14px; border-width: 1px; border-color: white; width: 325px;">
                            <b><font size=3 color="white"><fmt:message key="toDate"/></font></b>
                        </td>
                        
                    </tr>
                    <tr>
                        <td style="text-align: center; font-size: 14px; border-width: 1px; border-color: white;" bgcolor="#EEEEEE" valign="middle">
                            <input id="fromDate" name="fromDate" type="text" value="<%=fromDateVal%>" readonly/><img src="images/showcalendar.gif"/>
                            <br/><br/>
                        </td>
                        <td style="text-align: center; font-size: 14px; border-width: 1px; border-color: white;" bgcolor="#EEEEEE" style="text-align:right" valign="middle">
                            <input id="toDate" name="toDate" type="text" value="<%=toDateVal%>" readonly/><img src="images/showcalendar.gif"/>
                            <br/><br/>
                        </td>
                    </tr>
                    <tr>
                        <td class="blueHeaderTD" style="text-align: center; font-size: 14px; border-width: 1px; border-color: white; width: 325px;">
                            <%=department%>
                        </td>
                         <td style="text-align: center; font-size: 14px; border-width: 1px; border-color: white; width: 250px;" bgcolor="#EEEEEE" valign="middle" rowspan="2">
                            <button type="submit" class="button" style="width: 170px;"><fmt:message key="search"/><img height="15" src="images/search.gif"/></button>
                            <br/>
                            <br/>
                        </td>
                    </TR>
                    <tr>
                        <td bgcolor="#dedede" valign="middle" colspan="1" id="nclssTrSlc">
                            <select id="departmentID" name="departmentID" style="font-size: 14px; font-weight: bold; width: 300px;"
                                        >
                                <% if( departments != null) { %>
                                    <sw:WBOOptionList wboList="<%=departments%>" displayAttribute="projectName" valueAttribute="projectID" scrollToValue="<%=departmentID%>" />
                                <% } %>
                            </select>
                        </td>
                        
                    </tr>
                </table>             
            </form>
            
            <TABLE id="appointments" align="center" DIR="<%=dir%>" WIDTH="100%" CELLPADDING="0" cellspacing="0" style="display: none;">
                <thead>
                    <TR>
                        <TH><img src="images/icons/client.png" width="20" height="20" /><b style="font-weight: bold; font-size: 13px; color: black"> <%=customerName%></b></TH>
                        <TH><b style="font-weight: bold; font-size: 13px; color: black"> <%=mobile%></b></TH>
                        <TH><b style="font-weight: bold; font-size: 13px; color: black"> <%=employeeName%></b></TH>
                        <TH><b style="font-weight: bold; font-size: 13px; color: black"> <%=responsibleName%></b></TH>
                        <TH><img src="images/icons/place.png" width="20" height="20" /><b style="font-weight: bold; font-size: 13px; color: black"> <%=appointmentPlace%></b></TH>
                        <TH><img src="images/icons/appointment.png" width="20" height="20" /><b style="font-weight: bold; font-size: 13px; color: black"> <%=timeRemaining%></b></TH>
                        <TH><img src="images/icons/appointment.png" width="20" height="20" /><b style="font-weight: bold; font-size: 13px; color: black"> <%=appointmentDate%></b></TH>
                        <%
                            if (privilegesList.contains("DIRECT_APPOINTMENT")) {
                        %>
                        <TH><img src="images/icons/distribute.png" style="padding-top: 5px" width="30" height="30" /></TH>
                        <%
                            }
                            if (privilegesList.contains("UPDATE_APPOINTMENT")) {
                        %>
                        <TH><img src="images/icons/trash.png" style="padding-top: 5px" width="30" height="30" /></TH>
                        <%
                        }
                        %>
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

                            if (CRMConstants.APPOINTMENT_STATUS_DONE.equalsIgnoreCase(currentStatusCode)) {
                                done = true;
                            } else if (CRMConstants.APPOINTMENT_STATUS_OPEN.equalsIgnoreCase(currentStatusCode) && (remaining > - 24 * 60)) {
                                redirect = true;
                            } else if (CRMConstants.APPOINTMENT_STATUS_OPEN.equalsIgnoreCase(currentStatusCode) && (remaining >= -(24 * 60))) {
                                update = true;
                            } else if (CRMConstants.APPOINTMENT_STATUS_OPEN.equalsIgnoreCase(currentStatusCode)) {
                                expired = true;
                            }
                            update = update || redirect;
                    %>
                    <%
                        if ((issueId != null) && (clientComplaintId != null)) {
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
                        <TD><a href="<%=context%>/ClientServlet?op=clientDetails&clientId=<%=appointment.getAttribute("clientId")%>"><b><%=appointment.getAttribute("clientName")%></b></a></TD>
                        <TD><b><%=appointment.getAttribute("mobile")%></b></TD>
                        <TD><b><%=appointment.getAttribute("createdByName")%></b></TD>
                        <TD><a href="JavaScript: openDailog('<%=userId%>', '<%=dateArr[0] + "/" + dateArr[1] + "/" + dateArr[2]%>');"><b><%=appointment.getAttribute("userName")%></b></a></TD>
                        <TD><b><%=appointment.getAttribute("appointmentPlace")%></b></TD>
                        <TD><b><%=(remaining <= 0 || done) ? "---" : DateAndTimeControl.getTimeRemainingFormatted((String) appointment.getAttribute("timeRemaining"), DateAndTimeControl.TimeType.MINUTES, state)%></b></TD>
                        <TD><font color="red"><%=formattedTime.getAttribute("day")%> - </font><b><%=formattedTime.getAttribute("time")%></b></TD>
                        <%
                            if (privilegesList.contains("DIRECT_APPOINTMENT")) {
                        %>
                        <TD style="text-align: center">
                            <input type="hidden" id="issueId<%=appointment.getAttribute("id")%>" name="issueId<%=appointment.getAttribute("id")%>" value="<%=issueId%>"/>
                            <input type="hidden" id="clientComplaintId<%=appointment.getAttribute("id")%>" name="clientComplaintId<%=appointment.getAttribute("id")%>" value="<%=clientComplaintId%>"/>
                            <%
                                if(appointment.getAttribute("grpID") != null && !appointment.getAttribute("grpID").toString().isEmpty() && metaMgr.getTelesalesID().contains((String) appointment.getAttribute("grpID"))){
                            %>
                                    <select id="employeeId<%=appointment.getAttribute("id")%>" name="employeeId<%=appointment.getAttribute("id")%>" style="font-weight: bold; width: 100px; height: 22px; margin-bottom: 5px; vertical-align: middle; <%if (!redirect) {%>display: none<%}%>">
                                        <% for (WebBusinessObject employee : employees) {%>
                                        <option value="<%=employee.getAttribute("userId")%>"><%=employee.getAttribute("fullName")%></option>
                                        <% }%>
                                    </select>
                                    &ensp;
                                    <button type="button" id="button<%=appointment.getAttribute("id")%>" onclick="JavaScript: redirectAppointment('<%=appointment.getAttribute("id")%>');" style="margin-bottom: 5px;  <%if (!redirect) {%>display: none<%}%>"><%=action%><img src="images/icons/forward.png" width="15" height="15" /></button>
                                    &ensp;
                            <%
                                }
                            %>
                <center>
                    <img id="icon<%=appointment.getAttribute("id")%>" src="images/icons/star.png" width="24" height="24" style="padding-top: 0px; padding-bottom: 5px; <%if (!done) {%>display: none<%}%>"/>
                    <img id="loading<%=appointment.getAttribute("id")%>" src="images/icons/loading.gif" width="24" height="24" style="padding-top: 0px; padding-bottom: 5px; vertical-align: middle; display: none"/>
                    <img id="expired<%=appointment.getAttribute("id")%>" src="images/icons/appointment_expired.png" width="24" height="24" style="padding-top: 0px; padding-bottom: 5px; vertical-align: middle; <%if (!expired) {%>display: none<%}%>" title="This appointment is out of date"/>
                </center>
                </TD>
                <%
                    }
                    if (privilegesList.contains("UPDATE_APPOINTMENT")) {
                %>
                <TD style="text-align: center">
                    <button type="button" id="buttonCallResult<%=appointment.getAttribute("id")%>" onclick="JavaScript: popupUserAppointment('<%=appointment.getAttribute("id")%>', '<%=appointment.getAttribute("userId")%>', '<%=appointment.getAttribute("clientId")%>', '<%=((String) appointment.getAttribute("appointmentDate")).substring(0, 16).replaceAll("-", "/")%>');" style="margin-bottom: 5px;  <%if (!update) {%>display: none<%}%>"><%=action2%><img src="images/icons/update_ready.png" width="15" height="15" /></button>
                    &ensp;
                <center>
                    <img id="icon2<%=appointment.getAttribute("id")%>" src="images/icons/star.png" width="24" height="24" style="padding-top: 0px; padding-bottom: 5px; <%if (!done) {%>display: none<%}%>"/>
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