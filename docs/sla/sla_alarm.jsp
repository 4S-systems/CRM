<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="com.maintenance.common.AutomationConfigurationMgr"%>
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
        long interval = automation.getSLAAlarmDelayInterval();
    %>

    <script>
        setInterval(doSLANotificationAjax, <%=interval%>);
        function doSLANotificationAjax() {
            $.ajax({
                type: "POST",
                url: "<%=context%>/NotificationServlet?op=getSLANotificationAjax",
                success: function (data) {
                    doSLANotificationTheCounter(data);
                }
            });
        }

        function doSLANotificationTheCounter(data) {

            if (data !== "") {
                var notifications = $.parseJSON(data);
                var notification, type = "success";
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
                                acceptSLA(this.toastrId);
                            },
                            "showDuration": "30000",
                            "hideDuration": "30000",
                            "timeOut": "30000",
                            "extendedTimeOut": "30000",
                            "showEasing": "swing",
                            "hideEasing": "linear",
                            "showMethod": "fadeIn",
                            "hideMethod": "fadeOut"
                        };
                        toastr.options = options;
                        toastr.toastrId = notification.id;
                        toastr[type]("العميل: " + notification.clientName, "باقى على الطلب : " + notification.businessID + "/" + notification.businessIDbyDate + "<br/>" + "ساعة " + notification.timeRemainingMinutes);
                    }
                }
            }
        }

        function acceptSLA(id) {
            $.ajax({
                type: "POST",
                url: "<%=context%>/NotificationServlet?op=acceptSLANotification",
                data: {
                    notificationId: id
                },
                success: function (data) {
                    goToTask(id);
                }
            });
        }

        function goToTask(id) {
            document.SLA_ALARM_FORM.action = "<%=context%>/NotificationServlet?op=openSLANotification&id=" + id;
            document.SLA_ALARM_FORM.submit();
        }
    </script>

    <form name="SLA_ALARM_FORM" method="POST">

    </form>
</HTML>     
