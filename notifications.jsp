<%@page import="com.crm.common.CRMConstants"%>
<%@page import="com.silkworm.util.DateAndTimeControl"%>
<%@page import="com.crm.db_access.NotificationsMgr"%>
<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*, com.tracker.common.*, java.util.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants"%>
<%@ page import="com.silkworm.common.TimeServices"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page pageEncoding="UTF-8" %>

<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();

    String stat = (String) request.getSession().getAttribute("currentMode");

    SecurityUser securityUser = (SecurityUser) session.getAttribute("securityUser");
    Map<String, String> withinIntervals = securityUser.getWithinIntervals();
    int within = 1;
    if (request.getParameter("withinNotification") != null) {
        within = new Integer(request.getParameter("withinNotification"));
        withinIntervals.put("withinNotification", "" + within);
    } else if (withinIntervals.containsKey("withinNotification")) {
        within = (new Integer(withinIntervals.get("withinNotification")));
    }

    WebBusinessObject loggedUser = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
    NotificationsMgr notificationsMgr = NotificationsMgr.getInstance();
    ArrayList<WebBusinessObject> notifications;

    //Check if User is a manager
    EmpRelationMgr empRelationMgr = EmpRelationMgr.getInstance();
    WebBusinessObject empWbo = empRelationMgr.getOnSingleKey("key1", loggedUser.getAttribute("userId").toString());

    if (empWbo != null) {
        System.out.println("is a manager");
        notifications = new ArrayList<>(notificationsMgr.getNotificationsByGroupMgr(loggedUser.getAttribute("userId").toString(), within));
    } else {
        System.out.println("is an... employee");
        notifications = new ArrayList<>(notificationsMgr.getNotificationsByIssueCreator((String) loggedUser.getAttribute("userId"), (String) loggedUser.getAttribute("userId"), within));
    }
    String align = null;
    String dir = null;

    if (stat.equals("En")) {
        align = "center";
        dir = "LTR";
    } else {
        align = "center";
        dir = "RTL";
    }
%>
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Expires" CONTENT="0">

<HTML>
    <HEAD>
        <TITLE>Doc Viewer- Select Project and Status</TITLE>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css"/>
        <link rel="stylesheet" href="css/demo_table.css"/>
        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/default/easyui.css"/>

        <script type="text/javascript" src="jquery-ui/jquery-1.6.2.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <script type="text/javascript" src="js/jshaker.js"></script>
        <script type="text/javascript" src="jquery-easyui/easyloader.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.widget.js"></script>
        <script type="text/javascript" src="js/jquery.easing.1.3.js"></script>
        <script src='ChangeLang.js' type='text/javascript'></script>
    </HEAD>

    <script type="text/javascript">
        var oTable;
        var users = new Array();
        $(document).ready(function () {
            $("#notifications").css("display", "none");
            oTable = $('#notifications').dataTable({
                bJQueryUI: true,
                sPaginationType: "full_numbers",
                "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                iDisplayLength: 25,
                iDisplayStart: 0,
                "bPaginate": true,
                "bProcessing": true,
                "aaSorting": [[6, "desc"]]

            }).fadeIn(2000);

        });

        function getVendorInfo(obj) {
            var searchByValue = '';
            var value = $(obj).parent().parent().parent().parent().find("input[name=search]:checked").attr("id");
            $("#info").html("");
            //            if ($(obj).parent().find("#searchValue").val().length > 0) {

            if (value == 'clientNo') {
                searchByValue = $(obj).parent().parent().find("#searchValue").val();
            } else {
                searchByValue = $(obj).parent().parent().find("#searchValue").val();
            }
            document.NOTIFICATION_FORM.action = "<%=context%>/SearchServlet?op=searchForVendor&searchBy=" + value + "&searchByValue=" + searchByValue;
            document.NOTIFICATION_FORM.submit();
            $("#notifications").css("display", "");
            $("#showClients").val("show");
        }

        function submitForm()
        {
            document.NOTIFICATION_FORM.action = "<%=context%>/SearchServlet?op=searchSPInSchedule";
            document.NOTIFICATION_FORM.submit();
        }

        function createExtractIssue(clientId, comments, note, callType) {
            document.NOTIFICATION_FORM.action = "<%=context%>/IssueServlet?op=newExtractIssue&clientId=" + clientId + "&comments=" + comments + "&note=" + note + "&callType=" + callType;
            document.NOTIFICATION_FORM.submit();
        }

        function cancelForm()
        {
            document.NOTIFICATION_FORM.action = "main.jsp";
            document.NOTIFICATION_FORM.submit();
        }
        function changeStatus(status, type, id, note, actionCode) {
            $.ajax({
                type: "post",
                url: "<%=context%>/IssueServlet?op=changeNotificationStatusAjax",
                data: {
                    id: id,
                    status: status,
                    note: note,
                    actionCode: actionCode
                }
                ,
                success: function (jsonString) {
                    var info = $.parseJSON(jsonString);
                    if (info.status == 'Ok') {
//                        alert("تم تغيير الحالة");
                        $("#currentStatus" + id).html(info.currentStatusName);
                        if (type == 'read') {
                            $("#read" + id).parent().parent().toggleClass("unreadRow");
                            $("#read" + id).parent().parent().toggleClass("readRow");
                            $("#read" + id).css("display", "none");
                            $("#unread" + id).css("display", "");
                        } else if (type == 'unread') {
                            $("#read" + id).parent().parent().toggleClass("unreadRow");
                            $("#read" + id).parent().parent().toggleClass("readRow");
                            $("#read" + id).css("display", "");
                            $("#unread" + id).css("display", "none");
                        } else if (type == 'action') {
                            $("#read" + id).parent().parent().removeClass("actionRow");
                            $("#read" + id).parent().parent().addClass("actionRow");
                            $("#read" + id).css("display", "none");
                            $("#unread" + id).css("display", "none");
                            $("#actionRead" + id).css("display", "");
                            $("#add_action").bPopup().close();
                        }
                    } else if (info.status == 'failed') {
                        alert("لم يتم تغيير الحالة");
                    }
                }
            });
        }

        function submitWithInForm()
        {
            document.within_notification_form.submit();
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

        #row.unreadRow {
            background-color: #FFDDED;
        }

        #row.readRow {
            background-color: #FFFFFF;
        }

        #row.actionRow {
            background-color: #C3CFB7;
        }

    </style>


    <BODY>
        <FIELDSET class="set" style="width:96%;" >
            <form name="within_notification_form">
                <b style="font-size: medium;">عرض منذ :</b>
                <SELECT name="withinNotification" id="within" STYLE="width:125px; font-size: medium; font-weight: bold;" onchange="JavaScript: submitWithInForm();">
                    <OPTION value="1" <%=within == 1 ? "selected" : ""%>>ساعة</OPTION>
                    <OPTION value="2" <%=within == 2 ? "selected" : ""%>>ساعتان</OPTION>
                    <OPTION value="3" <%=within == 3 ? "selected" : ""%>>3 ساعات</OPTION>
                    <OPTION value="24" <%=within == 24 ? "selected" : ""%>>يوم</OPTION>
                    <OPTION value="48" <%=within == 48 ? "selected" : ""%>>يومان</OPTION>
                    <OPTION value="72" <%=within == 72 ? "selected" : ""%>>3 أيام</OPTION>
                    <OPTION value="168" <%=within == 168 ? "selected" : ""%>>أسبوع</OPTION>
                    <OPTION value="720" <%=within == 720? "selected": ""%>>شهر</OPTION>
                    <OPTION value="1440" <%=within == 1440? "selected": ""%>>شهران</OPTION>
                    <OPTION value="10000" <%=within >= 10000 ? "selected" : ""%>>غير محدد</OPTION>
                </SELECT>
            </form>

            <FORM NAME="NOTIFICATION_FORM" METHOD="POST">
                <%if (notifications != null && !notifications.isEmpty()) {%>
                <div style="width: 85%;margin-right: auto;margin-left: auto;" id="showClients">
                    <TABLE ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="100%" id="notifications" style="">
                        <thead>
                            <tr>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;">كود الطلب</th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;">رقم المتابعة</th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;">اسم العميل</th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;">النوع</th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;">اسم الحدث</th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;">اسم المصدر</th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;">التاريخ</th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;" width="5px"></th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;" width="5px"></th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;" width="5px"></th>
                            </tr>
                        <thead>
                        <tbody>
                            <%
                                for (WebBusinessObject wbo : notifications) {
                                    String className = "";
                                    String statusCode = wbo.getAttribute("statusCode") != null ? (String) wbo.getAttribute("statusCode") : "";
                                    if (statusCode.equals("37")) {
                                        className = "unreadRow";
                                    } else if (statusCode.equals("38")) {
                                        className = "readRow";
                                    } else if (statusCode.equals("39")) {
                                        className = "actionRow";
                                    }
                                    String alertID = (String) wbo.getAttribute("alertID");
                            %>
                            <tr style="cursor: pointer" id="row" class="<%=className%>">
                                <TD>
                                    <% if (wbo.getAttribute("businessComplaintId") != null) {%>
                                    <a href="<%=context%>/IssueServlet?op=viewComplaint&clientComplaintId=<%=wbo.getAttribute("clientComplaintId")%>"><font color="blue"><b><%=wbo.getAttribute("businessComplaintId")%></b></font></a>
                                            <% }%>
                                </TD>
                                <TD>
                                    <font color="red"><%=wbo.getAttribute("businessID")%></font><font color="blue">/<%=wbo.getAttribute("businessIDByDate")%></font>
                                </TD>
                                <TD>
                                    <b><%=wbo.getAttribute("clientName")%></b>
                                </TD>
                                <TD >
                                    <%if (wbo.getAttribute("complaintTypeName") != null) {%>
                                    <b><%=wbo.getAttribute("complaintTypeName")%></b>
                                    <%}%>
                                </TD>
                                <%
                                    String clazz;
                                    if (wbo.getAttribute("alertTypeId").equals(CRMConstants.ALERT_TYPE_ID_ATTACH_FILE)) {
                                        clazz = "attchedBg";
                                    } else if (wbo.getAttribute("alertTypeId").equals(CRMConstants.ALERT_TYPE_ID_ADD_COMMENT)) {
                                        clazz = "commentBg";
                                    } else if (wbo.getAttribute("alertTypeId").equals(CRMConstants.ALERT_TYPE_ID_ADD_REVIEW_COMMENT)) {
                                        clazz = "commentReviewBg";
                                    } else if (wbo.getAttribute("alertTypeId").equals(CRMConstants.ALERT_TYPE_ID_ADD_REPLAY_COMMENT)) {
                                        clazz = "commentReplayBg";
                                    } else if (wbo.getAttribute("alertTypeId").equals(CRMConstants.ALERT_TYPE_ID_FINISH_TICKET) || wbo.getAttribute("alertTypeId").equals(CRMConstants.ALERT_TYPE_ID_ACCEPT_TICKET)) {
                                        clazz = "finishBg";
                                    } else {
                                        clazz = "closeBg";
                                    }
                                %>
                                <TD class="<%=clazz%>">
                                    <%if (wbo.getAttribute("alertTypeName") != null) {%>
                                    <b><%=wbo.getAttribute("alertTypeName")%></b>
                                    <% } %>
                                </TD>
                                <TD >
                                    <%if (wbo.getAttribute("alertCreatedByName") != null) {%>
                                    <b><%=wbo.getAttribute("alertCreatedByName")%></b>
                                    <%}%>
                                </TD>
                                <TD >
                                    <%if (wbo.getAttribute("alertCreationTime") != null) {%>
                                    <%
                                        WebBusinessObject fomatted = DateAndTimeControl.getFormattedDateTime(wbo.getAttribute("alertCreationTime").toString(), stat);
                                    %>
                                    <font color="red"><%=fomatted.getAttribute("day")%> - </font><b><%=fomatted.getAttribute("time")%></b>
                                        <%}%>
                                </TD>
                                <TD>
                                    <img src="images/green.gif" style="display: <%=statusCode.equals("37") ? "" : "none"%>; cursor: hand;" width="20px"
                                         id="read<%=alertID%>" onclick="JavaScript: changeStatus('38', 'read', '<%=alertID%>', 'UL', 'UL');" title="علم"/>
                                    <img src="images/red.gif" style="display: <%=statusCode.equals("38") ? "" : "none"%>; cursor: hand;" width="20px"
                                         id="unread<%=alertID%>" onclick="JavaScript: changeStatus('37', 'unread', '<%=alertID%>', 'UL', 'UL');" title="لم تقروء"/>
                                </TD>
                                <TD>

                                </TD>
                                <TD>

                                </TD>
                            </tr>
                            <% }%>
                        </tbody>
                    </TABLE>
                    <br/>
                </DIV>
                <% } else {%>
                <div style="width: 85%;margin-right: auto;margin-left: auto;" id="showClients">
                    <table ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="100%" id="notifications" style="">
                        <thead>
                            <tr>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;">كود الطلب</th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;">رقم المتابعة</th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;">اسم العميل</th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;">النوع</th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;">اسم الحدث</th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;">اسم المصدر</th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;">التاريخ</th>
                            </tr>
                        <thead>
                    </table>
                    <BR />
                </div>
                <% }%>
            </form>
        </FIELDSET>
    </BODY>
</HTML>     
