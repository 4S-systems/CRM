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

<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Doc Viewer- Select Project and Status</TITLE>
    </HEAD>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        AutomationConfigurationMgr automation = AutomationConfigurationMgr.getCurrentInstance();
        long interval = automation.getAlarmDelayInterval();
    %>

    <script>
        setInterval(doNotificationAlarmAjax, <%=interval%>);
        function doNotificationAlarmAjax() {
            $.ajax({
                type: "POST",
                url: "<%=context%>/AppointmentServlet?op=getAppointmentsAjax",
                success: function (data) {
                    doNotificationAlarmTheCounter(data);
                }
            });
        }

        function doNotificationAlarmTheCounter(data) {

            if (data !== "") {
                var notifications = $.parseJSON(data);
                var notification, type = "info";
                var options;
                if (notifications !== null) {
                    for (i = 0; i < notifications.length; i++) {
                        notification = notifications[i];
                        options = {
                            "toastrId": notification.id,
                            "closeButton": false,
                            "debug": false,
                            "newestOnTop": false,
                            "progressBar": true,
                            "positionClass": "toast-bottom-right",
                            "preventDuplicates": false,
                            "onclick": function () {
                                acceptAppointment(this.toastrId);
                            },
                            "showDuration": "300000",
                            "hideDuration": "300000",
                            "timeOut": "300000",
                            "extendedTimeOut": "300000",
                            "showEasing": "swing",
                            "hideEasing": "linear",
                            "showMethod": "fadeIn",
                            "hideMethod": "fadeOut"
                        };
                        toastr.options = options;
                        toastr.toastrId = notification.id;
                        toastr[type]("العميل: <a target='_SELF' href='<%=context%>/ClientServlet?op=clientDetails&clientId=" + notification.clientId + "'>" + notification.clientName + "</a> - النوع: " + notification.title, "يوجد مقابلة لك بعد : " + notification.timeRemaining + " دقيقة fahd");
                    }
                }
            }
        }
        
        function acceptAppointment(id) {
            $.ajax({
                type: "POST",
                url: "<%=context%>/AppointmentServlet?op=acceptAppointment",
                data: {
                    appointmentId: id 
                },
                success: function (data) {
                    
                }
            });
        }
    </script>
</HTML>     
