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


<HTML>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();

        String stat = (String) request.getSession().getAttribute("currentMode");

        NotificationsMgr notificationsMgr = NotificationsMgr.getInstance();
        WebBusinessObject loggedUser = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
        Vector notifications = new Vector();

        SecurityUser securityUser = (SecurityUser) session.getAttribute("securityUser");
        int withinNotification = 24;
        Map<String, String> withinIntervals = securityUser.getWithinIntervals();
        if (request.getParameter("withinNotification") != null) {
            withinNotification = new Integer(request.getParameter("withinNotification"));
            withinIntervals.put("withinNotification", "" + withinNotification);
        } else if (withinIntervals.containsKey("withinNotification")) {
            withinNotification = (new Integer(withinIntervals.get("withinNotification")));
        }

        ProjectMgr projectMgr = ProjectMgr.getInstance();
        String projectCode = projectMgr.getByKeyColumnValue("key5", loggedUser.getAttribute("userId").toString(), "key3");
        if (projectCode != null && !projectCode.isEmpty()) {
            notifications = notificationsMgr.getNotificationsByComplaintCode(projectCode, withinNotification);
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

    <HEAD>
    </HEAD>
    <script type="text/javascript">

        var oTable;
        var users = new Array();
        $(document).ready(function() {
            $("#clients").css("display", "none");
            oTable = $('#clients').dataTable({
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
            document.CLIENT_FORM.action = "<%=context%>/SearchServlet?op=searchForVendor&searchBy=" + value + "&searchByValue=" + searchByValue;
            document.CLIENT_FORM.submit();
            $("#clients").css("display", "");
            $("#showClients").val("show");
            //            } else {
            //                $("#info").html("أدخل محتوى البحث");
            //                $("#searchValue").focus();
            //                $("#searchValue").css("border", "1px solid red");
            //            }
        }
    </script>
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
        function submitformNotifications()
        {
            document.within_form_notifications.submit();
        }
        function showComments(clientCompId) {
            var url = "<%=context%>/CommentsServlet?op=showComments&clientId=" + clientCompId + "&objectType=2&random=" + (new Date()).getTime();
            jQuery('#show_comm').load(url);
            $('#show_comm').css("display", "block");
            $('#show_comm').bPopup();
        }
        function showAttachedFiles(clientCompId) {
            var url = "<%=context%>/DocumentServlet?op=showAttachedFiles&compId=" + clientCompId;
            jQuery('#show_attached_files').load(url);
            $('#show_attached_files').css("display", "block");
            $('#show_attached_files').bPopup();
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
    </style>
    <script src='ChangeLang.js' type='text/javascript'></script>
    <BODY>
    <CENTER>
        <div id="show_comm"   style="width: 80% !important;display: none;position: fixed ;">

        </div>
        <div id="show_attached_files"   style="width: 70% !important;display: none;position: fixed ;">

        </div>
        <FIELDSET class="set" style="width:96%;height: auto" >
            <form name="within_form_notifications">
                <b style="font-size: medium;">عرض منذ :</b>
                <SELECT name="withinNotification" STYLE="width:125px; font-size: medium; font-weight: bold;" onchange="JavaScript: submitformNotifications();">
                    <OPTION value="1" <%=withinNotification == 1 ? "selected" : ""%>>ساعة</OPTION>
                    <OPTION value="2" <%=withinNotification == 2 ? "selected" : ""%>>ساعتان</OPTION>
                    <OPTION value="3" <%=withinNotification == 3 ? "selected" : ""%>>3 ساعات</OPTION>
                    <OPTION value="24" <%=withinNotification == 24 ? "selected" : ""%>>يوم</OPTION>
                    <OPTION value="48" <%=withinNotification == 48 ? "selected" : ""%>>يومان</OPTION>
                    <OPTION value="72" <%=withinNotification == 72 ? "selected" : ""%>>3 أيام</OPTION>
                    <OPTION value="168" <%=withinNotification == 168 ? "selected" : ""%>>أسبوع</OPTION>
                    <OPTION value="1000" <%=withinNotification == 1000 ? "selected" : ""%>>غير محدد</OPTION>
                </SELECT>
            </form>
            <div style="margin-left: auto;margin-right: auto;width: 96%" class="set">
                <%if (notifications != null && !notifications.isEmpty()) {%>
                <div style="width: 85%;margin-right: auto;margin-left: auto;" id="showClients">
                    <TABLE ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="100%" id="clients" style="">
                        <thead>
                            <tr>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;">كود الطلب</th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;">النوع</th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;">اسم الحدث</th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;">اسم المصدر</th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;">الموظف المسؤول</th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;">التاريخ</th>
                            </tr>
                        <thead>
                        <tbody >  
                            <%
                                Enumeration e = notifications.elements();
                                WebBusinessObject wbo = new WebBusinessObject();
                                while (e.hasMoreElements()) {
                                    wbo = (WebBusinessObject) e.nextElement();
                            %>
                            <tr style="cursor: pointer" id="row">
                                <TD>
                                    <% if (wbo.getAttribute("businessComplaintId") != null) {%>
                                    <a href="<%=context%>/IssueServlet?op=viewComplaint&clientComplaintId=<%=wbo.getAttribute("clientComplaintId")%>"><font color="blue"><b><%=wbo.getAttribute("businessComplaintId")%></b></font></a>
                                            <% }%>
                                </TD>
                                <TD >
                                    <%if (wbo.getAttribute("complaintTypeName") != null) {%>
                                    <b><%=wbo.getAttribute("complaintTypeName")%></b>
                                    <%}%>
                                </TD>
                                <%
                                    String clazz, icon = "", method = "", title = "";
                                    if (wbo.getAttribute("alertTypeId").equals(CRMConstants.ALERT_TYPE_ID_ATTACH_FILE)) {
                                        clazz = "attched";
                                        icon = "Foldericon.png";
                                        method = "showAttachedFiles('" + wbo.getAttribute("clientComplaintId") + "')";
                                    } else if (wbo.getAttribute("alertTypeId").equals(CRMConstants.ALERT_TYPE_ID_ADD_COMMENT)) {
                                        clazz = "comment";
                                        icon = "icons/comments.png";
                                        method = "showComments('" + wbo.getAttribute("clientComplaintId") + "')";
                                        title = "مشاهدة التعليقات";
                                    } else if (wbo.getAttribute("alertTypeId").equals(CRMConstants.ALERT_TYPE_ID_FINISH_TICKET)) {
                                        clazz = "finish";
                                    } else {
                                        clazz = "closure";
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
                                    <img src="images/<%=icon%>" style="float: left; height: 30px; display: <%=icon.isEmpty() ? "none" : ""%>; cursor: hand;"
                                         title="<%=title%>" onclick="JavaScript: <%=method%>"/>
                                </TD>
                                <TD >
                                    <%if (wbo.getAttribute("complaintCurrentOwner") != null) {%>
                                    <b><%=wbo.getAttribute("complaintCurrentOwner")%></b>
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
                            </tr>
                            <% }%>
                        </tbody>  
                    </TABLE>
                    <BR />
                </div>
                <% } else {%>
                <div style="width: 85%;margin-right: auto;margin-left: auto;" id="showClients">
                    <table ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="100%" id="clients" style="">
                        <thead>
                            <tr>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;">كود الطلب</th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;">اسم الحدث</th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;">اسم المستخدم</th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;">التاريخ</th>
                            </tr>
                        <thead>
                    </table>
                    <BR />
                </div>
                <% }%>
            </div>
        </FIELDSET>
    </CENTER>
</BODY>
</HTML>     
