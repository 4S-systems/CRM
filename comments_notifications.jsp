<%-- 
    Document   : appointment_infuture
    Created on : Oct 26, 2021, 2:14:22 PM
    Author     : mariam
--%>

<%@page import="com.maintenance.common.AutomationConfigurationMgr"%>
<%@page import="com.clients.db_access.AppointmentNotificationMgr"%>
<%@page import="com.crm.common.CRMConstants"%>
<%@page import="com.silkworm.util.DateAndTimeControl"%>
<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*, com.tracker.common.*, java.util.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants"%>
<%@ page import="com.silkworm.common.TimeServices"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page pageEncoding="UTF-8" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<HTML>
      <c:set var="loc" value="en"/>
    <c:if test="${!(empty sessionScope.currentMode)}">
      <c:set var="loc" value="${sessionScope.currentMode}"/>
    </c:if>
<fmt:setLocale value="${loc}"  />
<fmt:setBundle basename="Languages.employee_agenda.employee_agenda"  />
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        
        AutomationConfigurationMgr automation = AutomationConfigurationMgr.getCurrentInstance();
        long interval = automation.getAlarmDelayInterval();

        String stat = (String) request.getSession().getAttribute("currentMode");

        AppointmentNotificationMgr notificationMgr = AppointmentNotificationMgr.getInstance();
        WebBusinessObject loggedUser = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
        List<WebBusinessObject> notifications = notificationMgr.getTodayAppointmentsForUser(loggedUser.getAttribute("userId").toString());
 
    %>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Doc Viewer- Select Project and Status</TITLE>
    </HEAD>
    <script type="text/javascript">

        var oTable;
        var users = new Array();
        $(document).ready(function() {
            $("#appointmentInToday").css("display", "none");
            oTable = $('#appointmentInToday').dataTable({
                bJQueryUI: true,
                sPaginationType: "full_numbers",
                "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                iDisplayLength: 25,
                iDisplayStart: 0,
                "bPaginate": true,
                "bProcessing": true

            }).fadeIn(2000);

        });

        $(function() {
            $("input[name=search]").change(function() {
                var value = $("input[name=search]:checked").attr("id");
                if (value == 'clientNo') {
                    $("#searchValue").val("");
                    $("#searchValue").attr("placeholder", "رقم المقاول");
                    $("#msgT").html("");
                    $("#msgM").html("");
                    $("#msgNo").html("");
                    $("#info").html("");
                    $("#msgNa").html("");
                    $("#searchValue").css("border", "");
                    $("#showClients").css("display", "none");
                } else if (value == 'clientName') {
                    $("#searchValue").val("");
                    $("#searchValue").attr("placeholder", "اسم المقاول");
                    $("#msgT").html("");
                    $("#msgM").html("");
                    $("#msgNo").html("");
                    $("#msgNa").html("");
                    $("#info").html("");
                    $("#searchValue").css("border", "");
                    $("#showClients").css("display", "none");
                }
            })

        })
        function clearAlert() {
            $("#msgT").html("");
            $("#msgM").html("");
            $("#msgNo").html("");
            $("#info").html("");
            $("#msgNa").html("");
            $("#searchValue").css("border", "");
            $("#showClients").css("display", "none");
        }
    </script>

    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
        function submitForm()
        {
            document.APPOINTMENT_NOTIFICATION_FORM.action = "<%=context%>/SearchServlet?op=searchSPInSchedule";
            document.APPOINTMENT_NOTIFICATION_FORM.submit();
        }

        function createExtractIssue(clientId, comments, note, callType) {
            document.APPOINTMENT_NOTIFICATION_FORM.action = "<%=context%>/IssueServlet?op=newExtractIssue&clientId=" + clientId + "&comments=" + comments + "&note=" + note + "&callType=" + callType;
            document.APPOINTMENT_NOTIFICATION_FORM.submit();
        }

        function cancelForm()
        {
            document.APPOINTMENT_NOTIFICATION_FORM.action = "main.jsp";
            document.APPOINTMENT_NOTIFICATION_FORM.submit();
        }
    </SCRIPT>
    <style>  
        .titlebar {
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
        label{
            font: Georgia, "Times New Roman", Times, serif;
            font-size:14px;
            font-weight:bold;
            color:#005599;
            margin-right: 5px;
        }
        #row:hover{
            background-color: #EEEEEE;
        }

        .attched {
            background-color: green;
            color: #ffffff;
            width: 8%
        }

        .comment {
            background-color: #000080;
            color: #ffffff;
            width: 8%
        }

        .closure {
            background-color: red;
            color: #ffffff;
            width: 8%
        }

        .finish {
            background-color: yellow;
            color: #000000;
            width: 8%
        }

        .high {
            color: black;
            font-weight: bold;
            background-color: green;
        }

        .meduim {
            color: black;
            font-weight: bold;
            background-color: yellow;
        }

        .low {
            color: black;
            font-weight: bold;
            background-color: red;
        }
    </style>
    <BODY>
        <FORM NAME="APPOINTMENT_NOTIFICATION_FORM" METHOD="POST">
            <div style="margin-left: auto;margin-right: auto;width: 96%" class="set">
                <%if (notifications != null && !notifications.isEmpty()) {%>
                <div style="width: 85%;margin-right: auto;margin-left: auto;" id="showClients">
                    <img id="loadingImage" src="images/ajax-loader_blue.gif" alt="Loading" style="visibility: hidden;"/>
                    <TABLE ALIGN=<fmt:message key="align"/> dir=<fmt:message key="direction"/> WIDTH="100%" id="appointmentInToday" style="">
                        <thead>
                            <tr>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;"><fmt:message key="clientname"/></th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;"><fmt:message key="address"/></th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;"><fmt:message key="notes"/></th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;"><fmt:message key="appointmentdate"/></th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;"><fmt:message key="remaintime"/></th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;">Call</th>
                            </tr>
                        <thead>
                        <tbody >  
                            <%
                                String style;
                                int timeRemaining;
                                int timeRemainInDays=0;
                                int timeRemainInHrs=0;
                                for (int index = 0; index < notifications.size(); index++) {
                                    style = "high";
                                    String date=notifications.get(index).getAttribute("appointmentDate").toString().split(" ")[0];
                                    String time=notifications.get(index).getAttribute("appointmentDate").toString().split(" ")[1].substring(0,5);
                                    try {
                                        timeRemaining = Integer.parseInt(notifications.get(index).getAttribute("timeRemaining").toString());
                                        timeRemainInDays=timeRemaining/(60*24);
                                        timeRemainInHrs=(timeRemaining/60)-(timeRemainInDays*24);
                                        if (timeRemaining <= 15) {
                                            style = "low";
                                        } else if (timeRemaining <= 30) {
                                            style = "meduim";
                                        }
                                    } catch (Exception ex) {
                                    }
                            %>
                        <input type="hidden" id="input<%=notifications.get(index).getAttribute("id")%>" value="<%=index%>" />
                        <tr style="cursor: pointer" id="row">
                            <TD>
                                <% if (notifications.get(index).getAttribute("clientName") != null) {%>
                                <font color="blue"><b><%=notifications.get(index).getAttribute("clientName")%></b></font>
                                    <% } %>
                                <a href="#" onclick="JavaScript: openInNewWindow('<%=context%>/ClientServlet?op=clientDetails&clientId=<%=notifications.get(index).getAttribute("clientId")%>');">
                                <img src="images/client_details.jpg" width="30" style="float: left;" title="تفاصيل"/>
                            </a>
                            </TD>
                            <TD>
                                <%if (notifications.get(index).getAttribute("title") != null) {%>
                                <b><%=notifications.get(index).getAttribute("title")%></b>
                                <% } %>
                            </TD>
                            <TD >
                                <%if (notifications.get(index).getAttribute("note") != null ) {%>
                                <%if (!notifications.get(index).getAttribute("note").toString().equalsIgnoreCase("UL")){%>
                                <b><%=notifications.get(index).getAttribute("note")%></b>
                                <%}else{%>
                                <b>---</b>
                                <%}}%>
                            </TD>
                            <td>  
                                <b><%=date%>   <%=time%> Hours</b>
                            </td>
                            <TD id="td<%=notifications.get(index).getAttribute("id")%>" >
                                <%if (notifications.get(index).getAttribute("timeRemaining") != null) {%>
                                <b><label id="time<%=notifications.get(index).getAttribute("id")%>" style="color: black; font-weight: bold"><%=timeRemainInDays%> Day <%=timeRemainInHrs%> Hours</b>
                                <% } %>
                            </TD>
                            <td>
                                 <a href="<%=context%>/ClientServlet?op=ViewClientMenu&clientNo=<%=notifications.get(index).getAttribute("clientNo")%>&clientID=<%=notifications.get(index).getAttribute("clientId")%>&button=directCall" ><img style="height:35px;" src="images/icons/follow_up.png" title="Direct Call"></a>
                            </td>
                        </tr>
                        <% } %>
                        </tbody>  
                    </TABLE>
                    <BR />
                </div>
                <% } else {%>
                <div style="width: 85%;margin-right: auto;margin-left: auto;" id="showClients">
                    <table ALIGN=<fmt:message key="align"/> dir=<fmt:message key="direction"/> WIDTH="100%" id="appointmentInToday" style="">
                        <thead>
                            <tr>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;"><fmt:message key="clientname"/></th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;"><fmt:message key="address"/></th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;"><fmt:message key="notes"/></th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;"><fmt:message key="appointmentdate"/></th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;"> <fmt:message key="remaintime"/></th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;">Call</th>
                            </tr>
                        <thead>
                    </table>
                    <BR />
                </div>
                <% }%>

                <script>
                setInterval(doUpdateAppointmentNotificationTableAjax, <%=interval%>);
                function doUpdateAppointmentNotificationTableAjax() {
                    var loadingImage = document.getElementById('loadingImage');
                    loadingImage.style.visibility = 'visible';

                    $.ajax({
                        type: "POST",
                        url: "<%=context%>/AppointmentServlet?op=getAppointmentsAjax",
                        success: function(data) {
                            doUpdateAppointmentNotificationTable(data);
                        }
                    });
                    loadingImage.style.visibility = 'hidden';
                }

                function doUpdateAppointmentNotificationTable(data) {
                    var insertedTable = document.getElementById('appointmentInToday');

                    var notifications = $.parseJSON(data);
                    var notification;

                    if (notifications != null) {
                        for (i = 0; i < notifications.length; i++) {
                            notification = notifications[i];

                            if (document.getElementById("td" + notification.id) == null) {
                                var row = insertedTable.insertRow(-1);

                                var cell0 = row.insertCell(0);
                                cell0.innerHTML = "<input type=\"hidden\" id=\"input" + notification.id + "\" value=\"" + (insertedTable.rows.length - 1) + "\" />" +
                                        "<font color=\"blue\"><b>" + notification.clientName + "</b></font>";

                                var cell1 = row.insertCell(1);
                                cell1.innerHTML = "<font color=\"black\"><b>" + notification.title + "</b></font>";

                                var cell2 = row.insertCell(2);
                                cell2.innerHTML = "<font color=\"black\"><b>" + notification.note + "</b></font>";

                                var cell3 = row.insertCell(3);
                                cell3.setAttribute("id", "td" + notification.id);
                                if (notification.timeRemaining <= 15) {
                                    cell3.setAttribute("class", "low");
                                } else if (notification.timeRemaining <= 30) {
                                    cell3.setAttribute("class", "meduim");
                                } else {
                                    cell3.setAttribute("class", "high");
                                }
                                cell3.innerHTML = "<b><label id=\"time" + notification.id + "\" style=\"color: black; font-weight: bold\">" + notification.timeRemaining + " دقيقة</label></b>";
                            } else {
                                var tdElement = document.getElementById("td" + notification.id);
                                var lblTime = document.getElementById("time" + notification.id);
                                if (notification.timeRemaining <= 15) {
                                    tdElement.className = "low";
                                } else if (notification.timeRemaining <= 30) {
                                    tdElement.className = "meduim";
                                } else {
                                    tdElement.className = "high";
                                }
                                lblTime.innerHTML = notification.timeRemaining + " دقيقة";
                            }
                        }
                    }
                }
                </script>
            </div>
        </FORM>
    </BODY>
</HTML>     
