<%@page import="com.maintenance.common.UserDepartmentConfigMgr"%>
<%@page import="com.maintenance.common.ParseSideMenu"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@page import="org.apache.catalina.startup.WebAnnotationSet"%>
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

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<HTML>
     <c:set var="loc" value="en"/>
    <c:if test="${!(empty sessionScope.currentMode)}">
      <c:set var="loc" value="${sessionScope.currentMode}"/>
    </c:if>
    <fmt:setLocale value="${loc}"  />
    <fmt:setBundle basename="Languages.Sales_Market.Sales_Market"  />

    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();

        String stat = (String) request.getSession().getAttribute("currentMode");

        SecurityUser securityUser = (SecurityUser) session.getAttribute("securityUser");
        Map<String, String> withinIntervals = securityUser.getWithinIntervals();
        int within = 24;
        if (request.getParameter("withinNotification") != null) {
            within = new Integer(request.getParameter("withinNotification"));
            withinIntervals.put("withinNotification", "" + within);
        } else if (withinIntervals.containsKey("withinNotification")) {
            within = (new Integer(withinIntervals.get("withinNotification")));
        }
        
        metaMgr.setMetaData("xfile.jar");
        ParseSideMenu parseSideMenu = new ParseSideMenu();
        Hashtable logos = new Hashtable();
        logos = parseSideMenu.getCompanyLogo("configration" + metaMgr.getCompanyName() + ".xml");
        String weeksNo = logos.get("weeksNo").toString();
        int dayOfBack = new Integer(weeksNo).intValue() * 7;
        
        Calendar weekCalendar = Calendar.getInstance();
        Calendar beginWeekCalendar = Calendar.getInstance();
        Calendar endWeekCalendar = Calendar.getInstance();

        int dayOfWeekValue = weekCalendar.getTime().getDay();
        Calendar beginSecondWeekCalendar = Calendar.getInstance();
        Calendar endSecondWeekCalendar = Calendar.getInstance();
        beginSecondWeekCalendar = (Calendar) weekCalendar.clone();
        endSecondWeekCalendar = (Calendar) weekCalendar.clone();
        
        beginSecondWeekCalendar.add(beginWeekCalendar.DATE, -dayOfWeekValue - dayOfBack);
        endSecondWeekCalendar.add(endWeekCalendar.DATE, -dayOfWeekValue);
        java.sql.Date beginSecondInterval = new java.sql.Date(beginSecondWeekCalendar.getTimeInMillis());
        java.sql.Date endSecondInterval = new java.sql.Date(endSecondWeekCalendar.getTimeInMillis());
        String beginDate = null;
        String endDate = null;
        
        DateFormat sqlDateParser = new SimpleDateFormat("yyyy/MM/dd");
        beginDate = sqlDateParser.format(beginSecondInterval);
        endDate = sqlDateParser.format(endSecondInterval);
        
        securityUser = (SecurityUser) session.getAttribute("securityUser");
        withinIntervals = securityUser.getWithinIntervals();
        Calendar cal = Calendar.getInstance();
        String timeFormat = "yyyy/MM/dd";
        SimpleDateFormat sdf = new SimpleDateFormat(timeFormat);
        String nowTime = sdf.format(cal.getTime());
        String toDateVal = nowTime;
        if(request.getParameter("toDate") != null) {
            toDateVal = request.getParameter("toDate");
            withinIntervals.put("toDate", "" + toDateVal);
        } else if (withinIntervals.containsKey("toDate")) {
            toDateVal = withinIntervals.get("toDate");
        }
        cal.add(Calendar.DAY_OF_MONTH, -1);
        nowTime = sdf.format(cal.getTime());
        String fromDateVal = nowTime;
        if(request.getParameter("fromDate") != null) {
            fromDateVal = request.getParameter("fromDate");
            withinIntervals.put("fromDate", "" + fromDateVal);
        } else if (withinIntervals.containsKey("fromDate")) {
            fromDateVal = withinIntervals.get("fromDate");
        }
        
        
        NotificationsMgr notificationsMgr = NotificationsMgr.getInstance();
        WebBusinessObject loggedUser = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
        UserDepartmentConfigMgr userDepartmentConfigMgr = UserDepartmentConfigMgr.getInstance();
        ArrayList<WebBusinessObject> usrDprtmntCnfgLst = userDepartmentConfigMgr.getUserDeptartmentConfig(loggedUser.getAttribute("userId").toString());
        ArrayList<WebBusinessObject> notifications = notificationsMgr.getAllNotifications(fromDateVal, toDateVal, usrDprtmntCnfgLst);
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
        $(function () {
            $("#fromDate,#toDate").datepicker({
                maxDate: "+d",
                changeMonth: true,
                changeYear: true,
                dateFormat: 'yy/mm/dd'
            });
        });
        
        var oTable;
        var users = new Array();
        $(document).ready(function() {
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
            document.NOTIFICATION_FORM.action = "<%=context%>/SearchServlet?op=searchForVendor&searchBy=" + value + "&searchByValue=" + searchByValue;
            document.NOTIFICATION_FORM.submit();
            $("#notifications").css("display", "");
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
            document.NOTIFICATION_FORM.action = "<%=context%>/SearchServlet?op=searchSPInSchedule";
            document.NOTIFICATION_FORM.submit();
        }

        function createExtractIssue(clientId, comments, note, callType) {
            document.NOTIFICATION_FORM.action = "<%=context%>/IssueServlet?op=newExtractIssue&clientId=" + clientId + "&comments=" + comments + "&note=" + note + "&callType=" + callType;
            document.NOTIFICATION_FORM.submit();
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
                success: function(jsonString) {
                    var info = $.parseJSON(jsonString);
                    if (info.status == 'Ok') {
                        alert("تم تغيير الحالة");
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

        .attched {
            background-color: #78935C;
            color: #000000;
            width: 8%
        }

        .comment {
            background-color: #5C85FF;
            color: #000000;
            width: 8%
        }

        .closure {
            background-color: #B84D4D;
            color: #000000;
            width: 8%
        }

        .finish {
            background-color: #FFFF99;
            color: #000000;
            width: 8%
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
        <div id="show_comm"   style="width: 80% !important;display: none;position: fixed ;">
<%=loggedUser%>
        </div>
        <div id="show_attached_files"   style="width: 70% !important;display: none;position: fixed ;">

        </div>
        <FIELDSET class="set" style="width:96%;" >
        <form name="within_form" style="direction:<fmt:message key="direction"/>">
                <table class="blueBorder" id="code2" align="center" dir="<fmt:message key="direction"/>" width="650" cellspacing="2" cellpadding="1"
                       style="border-width:1px;border-color:white;display: block;">
                    <tr class="head">
                        <td class="blueHeaderTD" style="text-align: center; font-size: 14px; border-width: 1px; border-color: white; width: 325px;">
                            <b><font size=3 color="white"><fmt:message key="fromDate"/></font></b>
                        </td>
                        <td class="blueHeaderTD" style="text-align: center; font-size: 14px; border-width: 1px; border-color: white; width: 325px;">
                            <b><font size=3 color="white"><fmt:message key="toDate"/></font></b>
                        </td>
                        <td style="text-align: center; font-size: 14px; border-width: 1px; border-color: white; width: 250px;" bgcolor="#EEEEEE" valign="middle" rowspan="2">
                            <button type="submit" class="button" style="width: 170px;"><fmt:message key="search"/><img height="15" src="images/search.gif"/></button>
                            <br/>
                            <br/>
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
                </table>
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
        </fieldset>
    </BODY>
</HTML>     
