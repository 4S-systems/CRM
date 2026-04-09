<%@page import="java.text.SimpleDateFormat"%>
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

        SecurityUser securityUser = (SecurityUser) session.getAttribute("securityUser");
        Map<String, String> withinIntervals = securityUser.getWithinIntervals();
        Calendar cal = Calendar.getInstance();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
        String toDateVal = sdf.format(cal.getTime());
        if(request.getParameter("toDateProjectNotification") != null) {
            toDateVal = request.getParameter("toDateProjectNotification");
            withinIntervals.put("toDateProjectNotification", "" + toDateVal);
        } else if (withinIntervals.containsKey("toDateProjectNotification")) {
            toDateVal = withinIntervals.get("toDateProjectNotification");
        }
        cal.add(Calendar.DAY_OF_MONTH, -1);
        String fromDateVal = sdf.format(cal.getTime());
        if(request.getParameter("fromDateProjectNotification") != null) {
            fromDateVal = request.getParameter("fromDateProjectNotification");
            withinIntervals.put("fromDateProjectNotification", "" + fromDateVal);
        } else if (withinIntervals.containsKey("fromDateProjectNotification")) {
            fromDateVal = withinIntervals.get("fromDateProjectNotification");
        }

        ArrayList<WebBusinessObject> notifications = new ArrayList<WebBusinessObject>();

        WebBusinessObject loggedUser = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
        String isManager = UserMgr.getInstance().getIsManager((String) loggedUser.getAttribute("userId"));
        EmpRelationMgr empRelationMgr = EmpRelationMgr.getInstance();
        NotificationsMgr notificationsMgr = NotificationsMgr.getInstance();
        if (isManager != null && isManager.equals("1")) {
            ArrayList<WebBusinessObject> employeesList = empRelationMgr.getOnArbitraryKey2((String) loggedUser.getAttribute("userId"), "key1");

            for (WebBusinessObject employeeWbo : employeesList) {
                notifications.addAll(new ArrayList<WebBusinessObject>(notificationsMgr.getNotificationsByIssueCreator((String) employeeWbo.getAttribute("empId"), (String) loggedUser.getAttribute("userId"),
                        new java.sql.Date(sdf.parse(fromDateVal).getTime()), new java.sql.Date(sdf.parse(toDateVal).getTime()))));
            }
            notifications.addAll(new ArrayList<WebBusinessObject>(notificationsMgr.getNotificationsByOwner((String) loggedUser.getAttribute("userId"), (String) loggedUser.getAttribute("userId"),
                    new java.sql.Date(sdf.parse(fromDateVal).getTime()), new java.sql.Date(sdf.parse(toDateVal).getTime()))));//, 
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
            $("#projectNotifications").css("display", "none");
            oTable = $('#projectNotifications').dataTable({
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
            document.PROJECT_NOTIFICATION_FORM.action = "<%=context%>/SearchServlet?op=searchForVendor&searchBy=" + value + "&searchByValue=" + searchByValue;
            document.PROJECT_NOTIFICATION_FORM.submit();
            $("#projectNotifications").css("display", "");
            $("#showClients").val("show");
            //            } else {
            //                $("#info").html("أدخل محتوى البحث");
            //                $("#searchValue").focus();
            //                $("#searchValue").css("border", "1px solid red");
            //            }
        }
    </script>
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
        function submitForm()
        {
            document.PROJECT_NOTIFICATION_FORM.action = "<%=context%>/SearchServlet?op=searchSPInSchedule";
            document.PROJECT_NOTIFICATION_FORM.submit();
        }

        function createExtractIssue(clientId, comments, note, callType) {
            document.PROJECT_NOTIFICATION_FORM.action = "<%=context%>/IssueServlet?op=newExtractIssue&clientId=" + clientId + "&comments=" + comments + "&note=" + note + "&callType=" + callType;
            document.PROJECT_NOTIFICATION_FORM.submit();
        }

        function cancelForm()
        {
            document.PROJECT_NOTIFICATION_FORM.action = "main.jsp";
            document.PROJECT_NOTIFICATION_FORM.submit();
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
                success: function(jsonString) {
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

        function submitWithInProjectForm()
        {
            document.within_project_notification_form.submit();
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
    <script src='ChangeLang.js' type='text/javascript'></script>
    <BODY>
        <FIELDSET class="set" style="width:96%;" >
            <form name="within_project_notification_form">
                <table class="blueBorder" id="code2" align="center" dir="<%=dir%>" width="650" cellspacing="2" cellpadding="1"
                       style="border-width:1px;border-color:white;display: block;">
                       <tr class="head">
                        <td class="blueHeaderTD" style="text-align: center; font-size: 14px; border-width: 1px; border-color: white; width: 325px;">
                            <b><font size=3 color="white" title="تاريخ الأشعار">من تاريخ</font></b>
                        </td>
                        <td class="blueHeaderTD" style="text-align: center; font-size: 14px; border-width: 1px; border-color: white; width: 325px;">
                            <b><font size=3 color="white" title="تاريخ الأشعار">إلي تاريخ</font></b>
                        </td>
                        <td style="text-align: center; font-size: 14px; border-width: 1px; border-color: white; width: 250px;" bgcolor="#EEEEEE" valign="middle" rowspan="2">
                            <button type="submit" class="button" style="width: 170px;">بحث<img height="15" src="images/search.gif"/></button>
                            <br/>
                            <br/>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: center; font-size: 14px; border-width: 1px; border-color: white;" bgcolor="#EEEEEE" valign="middle">
                            <input class="fromToDate" id="fromDateProjectNotification" name="fromDateProjectNotification" type="text" title="تاريخ الأشعار" value="<%=fromDateVal%>" readonly/><img src="images/showcalendar.gif"/>
                            <br/><br/>
                        </td>
                        <td style="text-align: center; font-size: 14px; border-width: 1px; border-color: white;" bgcolor="#EEEEEE" style="text-align:right" valign="middle">
                            <input class="fromToDate" id="toDateProjectNotification" name="toDateProjectNotification" type="text" title="تاريخ الأشعار" value="<%=toDateVal%>" readonly/><img src="images/showcalendar.gif"/>
                            <br/><br/>
                        </td>
                    </tr>
                </table>
            </form>
            <FORM NAME="PROJECT_NOTIFICATION_FORM" METHOD="POST">
                <%if (notifications != null && !notifications.isEmpty()) {%>
                <div style="width: 85%;margin-right: auto;margin-left: auto;" id="showClients">
                    <TABLE ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="100%" id="projectNotifications" style="">
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
                        <tbody >  
                            <%
                                for (WebBusinessObject wbo : notifications) {
                                    String className = "readRow";
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
                                    } else if (wbo.getAttribute("alertTypeId").equals(CRMConstants.ALERT_TYPE_ID_CREATE_SLA) || wbo.getAttribute("alertTypeId").equals(CRMConstants.ALERT_TYPE_ID_UPDATE_SLA)) {
                                        clazz = "slaBg";
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
                            </tr>
                            <% }%>
                        </tbody>  
                    </TABLE>
                    <BR />
                </div>
                <% } else {%>
                <div style="width: 85%;margin-right: auto;margin-left: auto;" id="showClients">
                    <table ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="100%" id="projectNotifications" style="">
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
        </fieldset>
    </BODY>
</HTML>     
