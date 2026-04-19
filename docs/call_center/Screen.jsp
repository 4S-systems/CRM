<%@page import="com.maintenance.common.AutomationConfigurationMgr"%>
<%@page import="java.util.Calendar"%>

<%@page import="java.text.SimpleDateFormat"%>
<%@ page import="com.silkworm.business_objects.*,com.maintenance.db_access.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.tracker.db_access.*,com.tracker.db_access.IssueMgr"%>
<%@page pageEncoding="UTF-8" %>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld"%> 

<%
    AutomationConfigurationMgr automation = AutomationConfigurationMgr.getCurrentInstance();
    long interval = automation.getDefaultRefreshPageInterval();
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String showCalendar = metaMgr.getShowCalendar();
    Calendar calendar = Calendar.getInstance();
    String timeFormat = "yyyy/MM/dd HH:mm";
    SimpleDateFormat sdf = new SimpleDateFormat(timeFormat);
    String nowTime = sdf.format(calendar.getTime());

    SecurityUser securityUser = (SecurityUser) session.getAttribute("securityUser");

    WebBusinessObject clientWbo = (WebBusinessObject) request.getAttribute("client");
    String clientId = (String) clientWbo.getAttribute("id");

    String enableService = (String) request.getAttribute("enableServic");
    String call_status = (String) request.getAttribute("call_status");
    String entryDate = (String) request.getAttribute("entryDate");

    int currentDay = calendar.get(calendar.DAY_OF_MONTH);
    int currentYear = calendar.get(calendar.YEAR);
    int currentMonth = calendar.get(calendar.MONTH);

    ArrayList<WebBusinessObject> complaints = (ArrayList<WebBusinessObject>) request.getAttribute("complaintsList");
    if (complaints == null) {
        complaints = new ArrayList();
    } else {
        for(int i = complaints.size() - 1; i >= 0; i--) {
            WebBusinessObject tempWbo = complaints.get(i);
            if("0".equals(tempWbo.getAttribute("mainProjId"))) {
                complaints.remove(tempWbo);
                break;
            }
        }
    }
    ArrayList<WebBusinessObject> requests = (ArrayList<WebBusinessObject>) request.getAttribute("requestsList");
    if (requests == null) {
        requests = new ArrayList();
    } else {
        for(int i = requests.size() - 1; i >= 0; i--) {
            WebBusinessObject tempWbo = requests.get(i);
            if("0".equals(tempWbo.getAttribute("mainProjId"))) {
                requests.remove(tempWbo);
                break;
            }
        }
    }

    ArrayList<WebBusinessObject> inquiries = (ArrayList<WebBusinessObject>) request.getAttribute("inquiriesList");
    if (inquiries == null) {
        inquiries = new ArrayList();
    } else {
        for(int i = inquiries.size() - 1; i >= 0; i--) {
            WebBusinessObject tempWbo = inquiries.get(i);
            if("0".equals(tempWbo.getAttribute("mainProjId"))) {
                inquiries.remove(tempWbo);
                break;
            }
        }
    }

    ArrayList categories = (ArrayList) request.getAttribute("categories");
    ArrayList inquiryCategories = (ArrayList) request.getAttribute("inquiryCategories");

    if (call_status == null) {
        call_status = "";
    }

    WebBusinessObject issueWbo = (WebBusinessObject) request.getAttribute("issueWbo");

    ProjectMgr projectMgr = ProjectMgr.getInstance();

    String locationType = "div";
    projectMgr = ProjectMgr.getInstance();
    Vector departments = projectMgr.getOnArbitraryKey(locationType, "key6");
    ArrayList complaintList = new ArrayList();
    for (Object department : departments) {
        complaintList.add(department);
    }
    String context = metaMgr.getContext();

    WebBusinessObject client = (WebBusinessObject) request.getAttribute("client");
    String status = (String) request.getAttribute("status");
    String stat = (String) request.getSession().getAttribute("currentMode");
    String style = null;
    String calenderTip;

    if (stat.equals("En")) {
        style = "text-align:left";
        calenderTip = "click inside text box to opn calender window";
    } else {
        style = "text-align:Right";
        calenderTip = "&#1575;&#1590;&#1594;&#1591; &#1583;&#1575;&#1582;&#1604; &#1575;&#1604;&#1605;&#1587;&#1578;&#1591;&#1610;&#1604; &#1604;&#1603;&#1609; &#1610;&#1592;&#1607;&#1585; &#1604;&#1603; &#1606;&#1575;&#1601;&#1584;&#1607; &#1604;&#1571;&#1582;&#1578;&#1610;&#1575;&#1585; &#1575;&#1604;&#1578;&#1575;&#1585;&#1610;&#1582;";
    }
%>

<link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css">

<script type="text/javascript" src="jquery-ui/jquery-1.6.2.js"></script>

<script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
<script type="text/javascript" src="jquery-ui/ui/jquery.effects.core.js"></script>
<script type="text/javascript" src="jquery-ui/ui/jquery.ui.widget.js"></script>
<script type="text/javascript" src="jquery-ui/ui/jquery.effects.drop.js"></script>
<script type="text/javascript" src="jquery-ui/ui/jquery.effects.fold.js"></script>
<script type="text/javascript" src="jquery-ui/ui/jquery.ui.mouse.js"></script>
<script type="text/javascript" src="jquery-ui/ui/jquery.ui.slider.js"></script>
<script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
<script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>
<script type="text/javascript" src="js/jquery.chained.remote.min.js"></script>  
<script type="text/javascript" src="js/wz_tooltip.js"></script>
<script type="text/javascript" src="js/tip_balloon.js"></script>

<script type="text/javascript">
    function submitForm()
    {
        document.CLIENT_COMPLAINT_FORM.action = "<%=context%>/IssueServlet?op=insertNewCmpl&type=call";
        document.CLIENT_COMPLAINT_FORM.submit();
    }

    function saveCall() {
        var x = $("#note").val()
        if (x.length == 0) {
            alert("من فضلك أدخل تعليق عن المكالمة");
            return false;
        }
        if ($("#note").val().length > 0) {
            $("#pursuanceNO").html("<img src='images/icons/spinner.gif'/>");
            var call_status = $("#call_status:checked").val();
            var note = $("#note:checked").val();
            var entryDate = $("#entryDate").val();
            var clientId = <%=clientId%>;

            $.ajax({
                type: "post",
                url: "<%=context%>/IssueServlet?op=insertNewCmpl",
                data: {
                    call_status: call_status,
                    note: note,
                    entryDate: entryDate,
                    clientId: clientId,
                    type: note
                },
                success: function(jsonString) {
                    var info = $.parseJSON(jsonString);
                    if (info.status == 'success') {
                        $("#save_info").remove();
                        $("#businessId").val(info.businessID)
                        $("#pursuanceNO").html("");
                        $("#pursuanceNO").html('<lable id="busNumber"><font color="red" size="3">' + info.businessID + '/</font><font color="blue" size="3" >' + info.businessIDbyDate + '</font></lable>');

                    } else {
                        $("#pursuanceNO").html("");
                        $("#pursuanceNO").html('<font color="red" size="3">Save Failed!/</font>');
                    }
                }
            });
            return false;
        }
    }

    function cancelForm() {
        document.CLIENT_COMPLAINT_FORM.action = "<%=context%>/SearchServlet?op=searchForClient";
        document.CLIENT__FORM.submit();
    }

    function addCmp() {
        var projectId = document.getElementById("DepCmp").selectedValue;
        var url2 = "<%=context%>/IssueServlet?op=insertCmpl&projectId=" + projectId;
        if (window.XMLHttpRequest) {
            req = new XMLHttpRequest();
        } else if (window.ActiveXObject) {
            req = new ActiveXObject("Microsoft.XMLHTTP");
        }

        req.open("post", url2, true);
        req.send(null);
    }

    function saveOrder(obj) {
        var comment = $(obj).parent().parent().parent().find('#order').val();
        var userId = $(obj).parent().parent().find('#department option:selected').val();
        var subject = $(obj).parent().parent().parent().find('#subject').val();
        var ticketType = "25";
        var orderUrgency = $(obj).parent().parent().parent().find("input[name=orderUrgency]:checked").val();
        var category = $(obj).parent().parent().parent().find('#category').val();
        if (validateOrderFiled2(obj)) {
            $.ajax({
                type: "post",
                url: "<%=context%>/IssueServlet?op=saveOrder",
                data: {
                    userId: userId,
                    comment: comment,
                    subject: subject,
                    ticketType: ticketType,
                    clientId: '<%=clientId%>',
                    orderUrgency: orderUrgency,
                    category: category
                },
                success: function(jsonString) {
                    var info = $.parseJSON(jsonString);
                    if (info.status == 'Ok') {
                        // change update icon state
                        $(obj).html("");
                        $(obj).css("background-position", "top");
                        $(obj).attr("onclick", "");
                        $(obj).attr("onclick", "showMsg()");
                        $(obj).parent().parent().parent().find(".status").removeAttr("onclick");
                        $(obj).parent().parent().parent().find(".user").removeAttr("onclick");
                        $(obj).parent().parent().parent().find(".status").attr("onclick", "showMsg()");
                        $(obj).parent().parent().parent().find(".user").attr("onclick", "showMsg()");
                        $(obj).parent().parent().parent().find("#sendOrder").removeAttr("onclick");
                        $(obj).parent().parent().parent().find("#user").removeAttr("onclick");
                        $(obj).parent().parent().parent().find("#unknownBtn").removeAttr("onclick");
                        $(obj).parent().parent().parent().find("#sendOrder").css("background-image", "url(images/icons/notavailable.png)");
                    }
                }
            });
        }
    }

    function sendOrderToEmployee(obj) {
        var comment = $(obj).parent().parent().parent().parent().find('#order').val();
        var managerId = $(obj).parent().parent().parent().parent().find('#department option:selected').val();
        var userId = $(obj).parent().parent().parent().parent().find('#empl option:selected').val();
        var subject = $(obj).parent().parent().parent().parent().find('#subject').val();
        var orderUrgency = $(obj).parent().parent().parent().find("input[name=orderUrgency]:checked").val();
        var category = $(obj).parent().parent().parent().parent().find('#category').val();
        var ticketType = "25";
        if (validateOrderFiled2(obj)) {
            $.ajax({
                type: "post",
                url: "<%=context%>/IssueServlet?op=sendOrderTOEmployee",
                data: {userId: userId,
                    comment: comment,
                    subject: subject,
                    ticketType: ticketType,
                    mgrId: managerId,
                    clientId: '<%=clientId%>',
                    orderUrgency: orderUrgency,
                    category: category},
                success: function(jsonString) {
                    var info = $.parseJSON(jsonString);
                    if (info.status == 'Ok') {

                        // change update icon state
                        $(obj).html("");
                        $(obj).css("background-position", "top");
                        $(obj).removeAttr("onclick");
                        $(obj).attr("onclick", "showMsg()");
                        $(obj).parent().parent().parent().find(".status").removeAttr("onclick");
                        $(obj).parent().parent().parent().find(".user").removeAttr("onclick");
                        $(obj).parent().parent().parent().find(".status").attr("onclick", "showMsg()");
                        $(obj).parent().parent().parent().find(".user").attr("onclick", "showMsg()");
                        $(obj).parent().parent().parent().find("#mgrBtn").removeAttr("onclick");
                        $(obj).parent().parent().parent().find("#user").removeAttr("onclick");
                        $(obj).parent().parent().parent().find("#unknownBtn").removeAttr("onclick");
                        $(obj).parent().parent().parent().find("#mgrBtn").css("background-image", "url(images/icons/notavailable.png)");
                    }
                }
            });
        }
    }

    function sendClaimToEmployee(obj) {
        var comment = $(obj).parent().parent().parent().parent().find('#complaint').val();
        var managerId = $(obj).parent().parent().parent().parent().find('#department option:selected').val();
        var userId = $(obj).parent().parent().parent().parent().find('#empl option:selected').val();
        var subject = $(obj).parent().parent().parent().parent().find('#subject').val();
        var orderUrgency = $(obj).parent().parent().parent().parent().find("input[name=orderUrgency]:checked").val();
        var category = $(obj).parent().parent().parent().parent().find('#category').val();
        var ticketType = "1";
        if (validateComplaintFiled2(obj)) {
            $.ajax({
                type: "post",
                url: "<%=context%>/IssueServlet?op=sendOrderTOEmployee",
                data: {userId: userId,
                    comment: comment,
                    subject: subject,
                    ticketType: ticketType,
                    mgrId: managerId,
                    clientId: '<%=clientId%>',
                    orderUrgency: orderUrgency,
                    category: category},
                success: function(jsonString) {
                    var info = $.parseJSON(jsonString);
                    if (info.status == 'Ok') {
                        $(obj).parent().parent().parent().parent().find('#complaint').html(comment);
                        $(obj).parent().parent().parent().find('#subjectContent').html(subject);
                        $(obj).parent().parent().parent().find('#subjectContent').css("display", "");
                        $(obj).parent().parent().parent().find('#subject').remove();
                        // change update icon state
                        $(obj).html("");
                        $(obj).css("background-position", "top");
                        $(obj).removeAttr("onclick");
                        $(obj).attr("onclick", "showMsg()");
                        $(obj).parent().parent().parent().find(".status").removeAttr("onclick");
                        $(obj).parent().parent().parent().find(".user").removeAttr("onclick");
                        $(obj).parent().parent().parent().find(".status").attr("onclick", "showMsg()");
                        $(obj).parent().parent().parent().find(".user").attr("onclick", "showMsg()");
                        $(obj).parent().parent().parent().find("#mgrBtn").removeAttr("onclick");
                        $(obj).parent().parent().parent().find("#user").removeAttr("onclick");
                        $(obj).parent().parent().parent().find("#unknownBtn").removeAttr("onclick");
                        $(obj).parent().parent().parent().find("#mgrBtn").css("background-image", "url(images/icons/notavailable.png)");
//                        $(obj).parent().parent().parent().find("#user").css("background-image", "url(images/icons/notavailable.png)");
                    }
                }
            });
        }
    }

    function sendQueryToEmployee(obj) {
        var comment = $(obj).parent().parent().parent().find('#query').val();
        var managerId = $(obj).parent().parent().parent().find('#department option:selected').val();
        var userId = $(obj).parent().parent().parent().find('#empl option:selected').val();
        var subject = $(obj).parent().parent().parent().find('#subject').val();
        var category = $(obj).parent().parent().parent().find('#category').val();
        var ticketType = "3";
        if (validateQueryFiled2(obj)) {
            $.ajax({
                type: "post",
                url: "<%=context%>/IssueServlet?op=sendOrderTOEmployee",
                data: {userId: userId,
                    comment: comment,
                    subject: subject,
                    ticketType: ticketType,
                    mgrId: managerId,
                    clientId: '<%=clientId%>',
                    category: category},
                success: function(jsonString) {
                    var info = $.parseJSON(jsonString);
                    if (info.status == 'Ok') {

                        // change update icon state
                        $(obj).html("");
                        $(obj).css("background-position", "top");
                        $(obj).removeAttr("onclick");
                        $(obj).attr("onclick", "showMsg()");
                        $(obj).parent().parent().parent().find(".status").removeAttr("onclick");
                        $(obj).parent().parent().parent().find(".user").removeAttr("onclick");
                        $(obj).parent().parent().parent().find(".status").attr("onclick", "showMsg()");
                        $(obj).parent().parent().parent().find(".user").attr("onclick", "showMsg()");
                        $(obj).parent().parent().parent().find("#mgrBtn").removeAttr("onclick");
                        $(obj).parent().parent().parent().find("#user").removeAttr("onclick");
                        $(obj).parent().parent().parent().find("#unknownBtn").removeAttr("onclick");
                        $(obj).parent().parent().parent().find("#mgrBtn").css("background-image", "url(images/icons/notavailable.png)");
                    }
                }
            });
        }
    }

    function saveQuery(obj) {
        var comment = $(obj).parent().parent().parent().find('#query').val();
        var userId = $(obj).parent().parent().find('#department option:selected').val();
        var subject = $(obj).parent().parent().parent().find('#subject').val();
        var category = $(obj).parent().parent().parent().find('#category').val();
        var ticketType = "3";
        if (validateQueryFiled2(obj)) {
            $.ajax({
                type: "post",
                url: "<%=context%>/IssueServlet?op=saveQuery",
                data: {userId: userId,
                    comment: comment,
                    subject: subject,
                    ticketType: ticketType,
                    clientId: '<%=clientId%>',
                    category: category},
                success: function(jsonString) {
                    var info = $.parseJSON(jsonString);
                    if (info.status == 'Ok') {

                        // change update icon state
                        $(obj).html("");
                        $(obj).css("background-position", "top");
                        $(obj).removeAttr("onclick");
                        $(obj).attr("onclick", "showMsg()");
                        $(obj).parent().parent().parent().find(".status").removeAttr("onclick");
                        $(obj).parent().parent().parent().find(".user").removeAttr("onclick");
                        $(obj).parent().parent().parent().find(".status").attr("onclick", "showMsg()");
                        $(obj).parent().parent().parent().find(".user").attr("onclick", "showMsg()");
                        $(obj).parent().parent().parent().find("#user").removeAttr("onclick");
                        $(obj).parent().parent().parent().find("#empBtn").removeAttr("onclick");
                        $(obj).parent().parent().parent().find("#unknownBtn").removeAttr("onclick");
                        $(obj).parent().parent().parent().find("#empBtn").css("background-image", "url(images/icons/notavailable.png)");
                    }
                }
            });
        }
    }

    function showMsg() {
        alert("لقد تم الإرسال");
    }

    function saveComplaint(obj) {
        var ticketType = "1";
        var comment = $(obj).parent().parent().parent().find('#complaint').val();
        var userId = $(obj).parent().parent().find('#department option:selected').val();
        var subject = $(obj).parent().parent().parent().find('#subject').val();
        var orderUrgency = $(obj).parent().parent().parent().find("input[name=orderUrgency]:checked").val();
        var category = $(obj).parent().parent().parent().find("#category").val();
        if (validateComplaintFiled2(obj)) {
            $.ajax({
                type: "post",
                url: "<%=context%>/IssueServlet?op=saveCmpl",
                data: {userId: userId,
                    comment: comment,
                    subject: subject,
                    ticketType: ticketType,
                    clientId: '<%=clientId%>',
                    orderUrgency: orderUrgency,
                    category: category},
                success: function(jsonString) {
                    var info = $.parseJSON(jsonString);
                    if (info.status == 'Ok') {
                        $(obj).parent().parent().parent().find('#subjectContent').html(subject);
                        $(obj).parent().parent().parent().find('#subjectContent').css("display", "");
                        $(obj).parent().parent().parent().find('#subject').remove();
                        $(obj).parent().parent().parent().find('#clientCompId').val(info.clientCompId);
                        // change update icon state
                        $(obj).html("");
                        $(obj).css("background-position", "top");
                        $(obj).removeAttr("onclick");
                        $(obj).attr("onclick", "showMsg()");
                        $(obj).parent().parent().parent().find(".status").removeAttr("onclick");
                        $(obj).parent().parent().parent().find(".user").removeAttr("onclick");
                        $(obj).parent().parent().parent().find(".status").attr("onclick", "showMsg()");
                        $(obj).parent().parent().parent().find(".user").attr("onclick", "showMsg()");
                        $(obj).parent().parent().parent().find("#user").removeAttr("onclick");
                        $(obj).parent().parent().parent().find("#empBtnc").removeAttr("onclick");
                        $(obj).parent().parent().parent().find("#unknownBtn").removeAttr("onclick");
                        $(obj).parent().parent().parent().find("#empBtnc").css("background-image", "url(images/icons/notavailable.png)");
                        $(obj).parent().parent().parent().find("#user").css("background-image", "url(images/icons/notavailable.png)");
                    }
                }
            });
        }
    }

    function saveComplaintEmp(obj) {
        var ticketType = "1";
        var comment = $("#compTitle").val();
        var managerId = $("#managerId").val();
        var subject = $("#compContent").val();
        var userId = $("#empId").val();
        $.ajax({
            type: "post",
            url: "<%=context%>/IssueServlet?op=saveComp2",
            data: {userId: userId,
                comment: comment,
                subject: subject,
                ticketType: ticketType,
                managerId: managerId,
                clientId: '<%=clientId%>'},
            success: function(jsonString) {
                var info = $.parseJSON(jsonString);
                if (info.status == 'Ok') {

                    // change update icon state
                    $(obj).html("");
                    $(obj).css("background-position", "top");
                    $(obj).removeAttr("onclick");
                    $(obj).attr("onclick", "showMsg()");
                    $(obj).attr("yy", "yy");
                    $(obj).parent().parent().find(".save").removeAttr("onclick");
                    $(obj).parent().parent().find(".user").removeAttr("onclick");
                        $(obj).parent().parent().parent().find("#unknownBtn").removeAttr("onclick");
                    $(obj).parent().parent().find(".save").attr("onclick", "showMsg()");
                    $(obj).parent().parent().find(".user").attr("onclick", "showMsg()");
                }
            }
        });
    }

    function saveOrderEmp(obj) {
        var ticketType = "25";
        var comment = $("#compTitle").val();
        var managerId = $("#managerId").val();
        var subject = $("#compContent").val();
        var userId = $(obj).parent().parent().find("#empId").val();
        $.ajax({
            type: "post",
            url: "<%=context%>/IssueServlet?op=saveComp2",
            data: {userId: userId,
                comment: comment,
                subject: subject,
                ticketType: ticketType,
                managerId: managerId,
                clientId: '<%=clientId%>'},
            success: function(jsonString) {
                var info = $.parseJSON(jsonString);
                if (info.status == 'Ok') {

                    // change update icon state
                    $(obj).html("");
                    $(obj).css("background-position", "top");
                    $(obj).attr("xx", "xx");
                    $(obj).parent().parent().find(".save").removeAttr("onclick");
                    $(obj).parent().parent().find(".user").removeAttr("onclick");
                        $(obj).parent().parent().parent().find("#unknownBtn").removeAttr("onclick");
                    $(obj).parent().parent().find(".save").attr("onclick", "showMsg()");
                    $(obj).parent().parent().find(".user").attr("onclick", "showMsg()");
                }
                else if (info.status == 'noManager') {
                    alert("الموظف غير مرتبط بمدير");
                }
            }
        });
    }

    function saveOrderCurrentUser(obj) {
        var ticketType = "25";
        var comment = $(obj).parent().parent().find('#order').val();
        var managerId = $(obj).parent().parent().find('#department option:selected').val();
        var subject = $(obj).parent().parent().find('#subject').val();
        if (validateOrderFiled(obj)) {
            $.ajax({
                type: "post",
                url: "<%=context%>/IssueServlet?op=saveComp3",
                data: {
                    comment: comment,
                    subject: subject,
                    ticketType: ticketType,
                    clientId: '<%=clientId%>'},
                success: function(jsonString) {
                    var info = $.parseJSON(jsonString);
                    if (info.status == 'Ok') {

                        // change update icon state
                        $(obj).css("background-position", "top");
                        $(obj).attr("onclick", "");
                        $(obj).html("");
                        $(obj).attr("onclick", "showMsg()");
                        $(obj).parent().parent().find(".save").removeAttr("onclick");
                        $(obj).parent().parent().find(".status").removeAttr("onclick");
                        $(obj).parent().parent().find(".save").attr("onclick", "showMsg()");
                        $(obj).parent().parent().find(".status").attr("onclick", "showMsg()");
                        $(obj).parent().parent().parent().find("#unknownBtn").removeAttr("onclick");
                        $(obj).parent().parent().find("#empBtn").removeAttr("onclick");
                        $(obj).parent().parent().find("#mgrBtn").removeAttr("onclick");
                    }

                    if (info.status == 'noManager') {
                        alert("هذة الخاصية غير متاحة ");
                    }

                }
            });
        }
    }

    function saveComplaintCurrentUser(obj) {
        var ticketType = "1";
        var comment = $(obj).parent().parent().find('#complaint').val();
        var subject = $(obj).parent().parent().find('#subject').val();
        var businessId = $('#businessId').val();
        if (validateComplaintFiled(obj)) {
            $.ajax({
                type: "post",
                url: "<%=context%>/IssueServlet?op=saveComp3",
                data: {
                    comment: comment,
                    subject: subject,
                    ticketType: ticketType,
                    clientId: '<%=clientId%>',
                    businessId: businessId
                },
                success: function(jsonString) {
                    var info = $.parseJSON(jsonString);
                    if (info.status == 'Ok') {
                        $(obj).parent().parent().find('#complaint').html(comment);
                        $(obj).parent().parent().find('#subjectContent').html(subject);
                        $(obj).parent().parent().find('#subjectContent').css("display", "");
                        $(obj).parent().parent().find('#subject').remove();
                        $(obj).css("background-position", "top");
                        $(obj).attr("onclick", "");
                        $(obj).html("");
                        $(obj).attr("onclick", "showMsg()");
                        $(obj).parent().parent().find(".save").removeAttr("onclick");
                        $(obj).parent().parent().find(".status").removeAttr("onclick");
                        $(obj).parent().parent().find(".save").attr("onclick", "showMsg()");
                        $(obj).parent().parent().find(".status").attr("onclick", "showMsg()");
                        $(obj).parent().parent().find("#empBtnc").removeAttr("onclick");
                        $(obj).parent().parent().find("#mgrBtn").removeAttr("onclick");
                        $(obj).parent().parent().parent().find("#unknownBtn").removeAttr("onclick");
                        $(obj).parent().parent().parent().find("#empBtnc").css("background-image", "url(images/icons/notavailable.png)");
                        $(obj).parent().parent().parent().find("#mgrBtn").css("background-image", "url(images/icons/notavailable.png)");
                    } else if (info.status == 'failStatus') {
                        alert("لم يتم انهاء الشكوى");
                    } else {
                        alert("لم يتم الحفظ");
                    }
                }
            });
        }
    }

    function saveServiceCurrentUser(obj) {
        var ticketType = "4";
        var comment = $(obj).parent().parent().find('#service').val();
        var area_id = $(obj).parent().find('#area_id').val();
        var subject = $(obj).parent().parent().find('#subject').val();
        if (validateServiceFiled(obj)) {
            $.ajax({
                type: "post",
                url: "<%=context%>/IssueServlet?op=saveService",
                data: {
                    area_id: area_id,
                    comment: comment,
                    subject: subject,
                    ticketType: ticketType,
                    clientId: '<%=clientId%>'},
                success: function(jsonString) {
                    var info = $.parseJSON(jsonString);
                    if (info.status == 'Ok') {
                        $(obj).parent().parent().find('#clientCompId').val(info.clientCompId);
                        $(obj).parent().parent().find('#supervisorId').val(info.supervisorId);
                        $(obj).parent().parent().find('#complaint').html(comment);
                        $(obj).parent().parent().find('#subjectContent').html(subject);
                        $(obj).parent().parent().find('#subjectContent').css("display", "");
                        $(obj).parent().parent().find('#subject').remove();
                        $(obj).css("background-position", "top");
                        $(obj).attr("onclick", "");
                        $(obj).html("");
                        $(obj).attr("onclick", "showMsg()");
                        $(obj).parent().parent().find(".save").removeAttr("onclick");
                        $(obj).parent().parent().find(".status").removeAttr("onclick");
                        $(obj).parent().parent().find(".save").attr("onclick", "showMsg()");
                        $(obj).parent().parent().find(".status").attr("onclick", "showMsg()");
                        $(obj).parent().parent().find("#empBtn").removeAttr("onclick");
                        $(obj).parent().parent().find("#mgrBtn").removeAttr("onclick");
                        $(obj).parent().parent().parent().find("#unknownBtn").removeAttr("onclick");
                        $(obj).parent().parent().find("#calendar").css("display", "");
                        $(obj).parent().parent().parent().parent().find("#calendar").css("display", "");
                    }

                    if (info.status == 'noManager') {
                        alert("هذة الخاصية غير متاحة ");
                    }

                }
            });
        }
    }

    function saveQueryCurrentUser(obj) {
        var ticketType = "3";
        var comment = $(obj).parent().parent().find('#query').val();
        var managerId = $(obj).parent().parent().find('#department option:selected').val();
        var subject = $(obj).parent().parent().find('#subject').val();
        if (validateQueryFiled(obj)) {
            $.ajax({
                type: "post",
                url: "<%=context%>/IssueServlet?op=saveComp3",
                data: {
                    comment: comment,
                    subject: subject,
                    ticketType: ticketType,
                    clientId: '<%=clientId%>'},
                success: function(jsonString) {
                    var info = $.parseJSON(jsonString);
                    if (info.status == 'Ok') {
                        $(obj).parent().parent().find('#query').html(comment);
                        $(obj).parent().parent().find('#subject').html(subject);
                        $("#query_division").find("#tableDATA").html($("#query_division").find("#tableDATA").html());
                        // change update icon state
                        $(obj).css("background-position", "top");
                        $(obj).attr("onclick", "");
                        $(obj).html("");
                        $(obj).attr("onclick", "showMsg()");
                        $(obj).parent().parent().find(".save").removeAttr("onclick");
                        $(obj).parent().parent().find(".status").removeAttr("onclick");
                        $(obj).parent().parent().find(".save").attr("onclick", "showMsg()");
                        $(obj).parent().parent().find(".status").attr("onclick", "showMsg()");
                        $(obj).parent().parent().parent().find("#unknownBtn").removeAttr("onclick");
                        $(obj).parent().parent().find("#empBtn").removeAttr("onclick");
                        $(obj).parent().parent().find("#mgrBtn").removeAttr("onclick");
                    }

                    if (info.status == 'noManager') {
                        alert("هذة الخاصية غير متاحة ");
                    }

                }
            });
        }
    }
    function sendToUnknown(obj, ticketType) {
        var type;
        if(ticketType === '1') {
            type = 'complaint';
        } else if(ticketType === '25') {
            type = 'order';
        } else if(ticketType === '3') {
            type = 'query';
        }
        var comment = $(obj).parent().parent().parent().parent().find('#' + type).val();
        var managerId = $(obj).parent().parent().parent().parent().find('#department option:selected').val();
        var userId = $(obj).parent().parent().parent().parent().find('#empl option:selected').val();
        var subject = $(obj).parent().parent().parent().parent().find('#subject').val();
        var orderUrgency = $(obj).parent().parent().parent().find("input[name=orderUrgency]:checked").val();
        var category = $(obj).parent().parent().parent().parent().find('#category').val();
        if (validateUnknownFields(obj, type)) {
            $.ajax({
                type: "post",
                url: "<%=context%>/IssueServlet?op=saveUnknownComplaint",
                data: {
                    userId: userId,
                    comment: comment,
                    subject: subject,
                    ticketType: ticketType,
                    mgrId: managerId,
                    clientId: '<%=clientId%>',
                    orderUrgency: orderUrgency,
                    category: category
                },
                success: function(jsonString) {
                    var info = $.parseJSON(jsonString);
                    if (info.status == 'Ok') {

                        // change update icon state
                        $(obj).html("");
                        $(obj).removeAttr("onclick");
                        $(obj).attr("onclick", "showMsg()");
                        $(obj).css("background-image", "url(images/icons/unknown-done.png)");
                        $(obj).parent().parent().parent().find(".status").removeAttr("onclick");
                        $(obj).parent().parent().parent().find(".user").removeAttr("onclick");
                        $(obj).parent().parent().parent().find(".status").attr("onclick", "showMsg()");
                        $(obj).parent().parent().parent().find(".user").attr("onclick", "showMsg()");
                        $(obj).parent().parent().parent().find("#mgrBtn").removeAttr("onclick");
                        $(obj).parent().parent().parent().find("#empBtnc").removeAttr("onclick");
                        $(obj).parent().parent().parent().find("#empBtn").removeAttr("onclick");
                        $(obj).parent().parent().parent().find("#user").removeAttr("onclick");
                        $(obj).parent().parent().parent().find("#sendOrder").removeAttr("onclick");
                        $(obj).parent().parent().parent().find("#mgrBtn").css("background-image", "url(images/icons/notavailable.png)");
                        $(obj).parent().parent().parent().find("#empBtnc").css("background-image", "url(images/icons/notavailable.png)");
                        $(obj).parent().parent().parent().find("#empBtn").css("background-image", "url(images/icons/notavailable.png)");
                        $(obj).parent().parent().parent().find("#sendOrder").css("background-image", "url(images/icons/notavailable.png)");
                    }
                }
            });
        }
    }
    function validateUnknownFields(obj, type) {
        var comment = $(obj).parent().parent().parent().find('#' + type).val();
        var subject = $(obj).parent().parent().parent().find('#subject').val();
        var x = false;
        var y = false;
        var result = false;
        if (subject <= 0) {
            $(obj).parent().parent().parent().find('#subject').css("background-color", "#FFDAE2");
            $(obj).parent().parent().parent().find('#subject').val("مطلوب");
        } else {
            if ($(obj).parent().parent().parent().find('#subject').val() === "مطلوب") {
            } else {
                x = true;
            }
        }
        if (comment <= 0) {
            $(obj).parent().parent().parent().find('#' + type).css("background-color", "#FFDAE2");
            $(obj).parent().parent().parent().find('#' + type).val("من فضلك أدخل المحتوى");
        } else {
            if ($(obj).parent().parent().parent().find('#' + type).val() === "من فضلك أدخل المحتوى") {
            } else {
                y = true;
            }
        }
        if (x === true & y === true) {
            result = true;
        }
        return result;
    }
    function clearValidate(obj) {

        $(obj).css("background-color", "");
        $(obj).html("");
        $(obj).val("");
    }
    function validateQueryFiled(obj) {
        var comment = $(obj).parent().parent().find('#query').val();
        var managerId = $(obj).parent().parent().find('#department option:selected').val();
        var subject = $(obj).parent().parent().find('#subject').val();
        var x = false;
        var y = false;
        var result = false;
        if (subject <= 0) {
            $(obj).parent().parent().find('#subject').css("background-color", "#FFDAE2");
            $(obj).parent().parent().find('#subject').val("مطلوب");
        } else {
            if ($(obj).parent().parent().find('#subject').val() == "مطلوب") {
            } else {
                x = true;
            }

        }
        if (comment <= 0) {

            $(obj).parent().parent().find('#query').css("background-color", "#FFDAE2");
            $(obj).parent().parent().find('#query').val("من فضلك أدخل محتوى الإستعلام");
        } else {
            if ($(obj).parent().parent().find('#query').val() == "من فضلك أدخل محتوى الإستعلام") {
            } else {
                y = true;
            }
        }
        if (x == true & y == true) {
            result = true;
        }
        return result;
    }
    function validateComplaintFiled(obj) {
        var comment = $(obj).parent().parent().find('#complaint').val();
        var managerId = $(obj).parent().parent().find('#department option:selected').val();
        var subject = $(obj).parent().parent().find('#subject').val();
        var x = false;
        var y = false;
        var result = false;
        if (subject <= 0) {
            $(obj).parent().parent().find('#subject').css("background-color", "#FFDAE2");
            $(obj).parent().parent().find('#subject').val("مطلوب");
        } else {
            if ($(obj).parent().parent().find('#subject').val() == "مطلوب") {
            } else {
                x = true;
            }

        }
        if (comment <= 0) {

            $(obj).parent().parent().find('#complaint').css("background-color", "#FFDAE2");
            $(obj).parent().parent().find('#complaint').val("من فضلك أدخل محتوى الشكوى");
        } else {
            if ($(obj).parent().parent().find('#complaint').val() == "من فضلك أدخل محتوى الشكوى") {
            } else {
                y = true;
            }
        }
        if (x == true & y == true) {
            result = true;
        }
        return result;
    }
    function validateServiceFiled(obj) {
        var comment = $(obj).parent().parent().find('#complaint').val();
        var subject = $(obj).parent().parent().find('#subject').val();
        var x = false;
        var y = false;
        var result = false;
        if (subject <= 0) {
            $(obj).parent().parent().find('#subject').css("background-color", "#FFDAE2");
            $(obj).parent().parent().find('#subject').val("مطلوب");
        } else {
            if ($(obj).parent().parent().find('#subject').val() == "مطلوب") {
            } else {
                x = true;
            }

        }
        if (comment <= 0) {

            $(obj).parent().parent().find('#complaint').css("background-color", "#FFDAE2");
            $(obj).parent().parent().find('#complaint').val("أدخل تفاصيل الخدمة");
        } else {
            if ($(obj).parent().parent().find('#complaint').val() == "أدخل تفاصيل الخدمة") {
            } else {
                y = true;
            }
        }
        if (x == true & y == true) {
            result = true;
        }
        return result;
    }
    function validateOrderFiled(obj) {
        var comment = $(obj).parent().parent().find('#order').val();
        var managerId = $(obj).parent().parent().find('#department option:selected').val();
        var subject = $(obj).parent().parent().find('#subject').val();
        var x = false;
        var y = false;
        var result = false;
        if (subject <= 0) {
            $(obj).parent().parent().find('#subject').css("background-color", "#FFDAE2");
            $(obj).parent().parent().find('#subject').val("مطلوب");
        } else {
            if ($(obj).parent().parent().find('#subject').val() == "مطلوب") {
            } else {
                x = true;
            }

        }
        if (comment <= 0) {

            $(obj).parent().parent().find('#order').css("background-color", "#FFDAE2");
            $(obj).parent().parent().find('#order').val("من فضلك أدخل محتوى الطلب");
        } else {
            if ($(obj).parent().parent().find('#order').val() == "من فضلك أدخل محتوى الطلب") {
            } else {
                y = true;
            }
        }
        if (x == true & y == true) {
            result = true;
        }
        return result;
    }
    // validate differnt parent

    function validateQueryFiled2(obj) {

        var comment = $(obj).parent().parent().parent().find('#query').val();
        //        var managerId = $(obj).parent().parent().parent().parent().parent().find('#department option:selected').val();
        //        var userId = $(obj).parent().parent().parent().parent().parent().find('#empl option:selected').val();
        var subject = $(obj).parent().parent().parent().find('#subject').val();
        var x = false;
        var y = false;
        var result = false;
        if (subject <= 0) {
            $(obj).parent().parent().parent().find('#subject').css("background-color", "#FFDAE2");
            $(obj).parent().parent().parent().find('#subject').val("مطلوب");
        } else {
            if ($(obj).parent().parent().parent().find('#subject').val() == "مطلوب") {
            } else {
                x = true;
            }

        }
        if (comment <= 0) {

            $(obj).parent().parent().parent().find('#query').css("background-color", "#FFDAE2");
            $(obj).parent().parent().parent().find('#query').val("من فضلك أدخل محتوى الإستعلام");
        } else {
            if ($(obj).parent().parent().parent().find('#query').val() == "من فضلك أدخل محتوى الإستعلام") {
            } else {
                y = true;
            }
        }
        if (x == true & y == true) {
            result = true;
        }
        return result;
    }
    function validateComplaintFiled2(obj) {


        var comment = $(obj).parent().parent().parent().find('#complaint').val();
        var subject = $(obj).parent().parent().parent().find('#subject').val();
        var x = false;
        var y = false;
        var result = false;
        if (subject <= 0) {
            $(obj).parent().parent().parent().find('#subject').css("background-color", "#FFDAE2");
            $(obj).parent().parent().parent().find('#subject').val("مطلوب");
        } else {
            if ($(obj).parent().parent().parent().find('#subject').val() == "مطلوب") {
            } else {
                x = true;
            }

        }
        if (comment <= 0) {

            $(obj).parent().parent().parent().find('#complaint').css("background-color", "#FFDAE2");
            $(obj).parent().parent().parent().find('#complaint').val("من فضلك أدخل محتوى الشكوى");
        } else {
            if ($(obj).parent().parent().parent().find('#complaint').val() == "من فضلك أدخل محتوى الشكوى") {
            } else {
                y = true;
            }
        }
        if (x == true & y == true) {
            result = true;
        }
        return result;
    }
    function validateOrderFiled2(obj) {
        var comment = $(obj).parent().parent().parent().find('#order').val();
        var subject = $(obj).parent().parent().parent().find('#subject').val();
        var x = false;
        var y = false;
        var result = false;
        if (subject <= 0) {
            $(obj).parent().parent().parent().find('#subject').css("background-color", "#FFDAE2");
            $(obj).parent().parent().parent().find('#subject').val("مطلوب");
        } else {
            if ($(obj).parent().parent().parent().find('#subject').val() == "مطلوب") {
            } else {
                x = true;
            }

        }
        if (comment <= 0) {

            $(obj).parent().parent().parent().find('#order').css("background-color", "#FFDAE2");
            $(obj).parent().parent().parent().find('#order').val("من فضلك أدخل محتوى الطلب");
        } else {
            if ($(obj).parent().parent().parent().find('#order').val() == "من فضلك أدخل محتوى الطلب") {
            } else {
                y = true;
            }
        }
        if (x == true & y == true) {
            result = true;
        }
        return result;
    }
    ///////////////////////////////////////////////////////////
    function getDepartmentEmployees(obj) {
        var x = $("#orderTable tr");
        $(x).each(function(index, row) {
            //            alert($(row).html())
            if ($(row).find("#empl").attr("id") == "empl") {
                $(row).find("#empl").attr("id", "employees");
            }

        })

        var departmentId = $(obj).val();
        $.ajax({
            type: "post",
            url: "<%=context%>/IssueServlet?op=getDepartmentEmployees",
            data: {
                departmentId: departmentId
            },
            success: function(jsonString) {
                var info = $.parseJSON(jsonString);
                if (info.responseText != 'empty') {
                    //                    alert($(obj).val());

                    $(obj).parent().parent().parent().find("#employees").attr("id", "empl");
                    var brand = document.getElementById('empl');
                    //                    $(brand).html("");
                    //                    alert(brand)
                    var result = info.responseText;
                    //                    alert(result);
                    $(brand).html("");
                    if (result != "empty") {
                        if ($("#empl").attr("disabled") == "disabled") {
                            $("#empl").removeAttr("disabled");
                        }
                        $(obj).parent().parent().parent().find("#saveemp").show();
                        var data = result.split("<element>");
                        var idAndName = "";
                        //                    brand.options[brand.options.length] = new Option("--", "");
                        for (var i = 0; i < data.length; i++) {
                            idAndName = data[i].split("<subelement>");
                            brand.options[brand.options.length] = new Option(idAndName[1], idAndName[0]);
                        }

                    }
                }
                else {
                    $(obj).parent().parent().parent().find("#employees").attr("id", "empl");
                    $(obj).parent().parent().parent().find("#saveemp").hide();
                    var brand = document.getElementById('empl');
                    $("#empl").attr("disabled", "disabled");
                    $(brand).html("<option>لايوجد موظفين</option>");
                }
            }
        });
    }

    function saveQueryEmp(obj) {
        var ticketType = "3";
        var comment = $("#compTitle").val();
        var managerId = $("#managerId").val();
        var subject = $("#compContent").val();
        var userId = $("#empId").val();
        $.ajax({
            type: "post",
            url: "<%=context%>/IssueServlet?op=saveComp2",
            data: {userId: userId,
                comment: comment,
                subject: subject,
                ticketType: ticketType,
                managerId: managerId,
                clientId: '<%=clientId%>'},
            success: function(jsonString) {
                var info = $.parseJSON(jsonString);
                if (info.status == 'Ok') {

                    // change update icon state
                    $(obj).html("");
                    $(obj).css("background-position", "top");
                    //                    $(obj).removeAttr("onclick");
                    //                    $(obj).attr("onclick", "showMsg()");
                    $(obj).attr("zz", "zz");
                    $(obj).parent().parent().find(".save").removeAttr("onclick");
                    $(obj).parent().parent().find(".user").removeAttr("onclick");
                    $(obj).parent().parent().find(".save").attr("onclick", "showMsg()");
                    $(obj).parent().parent().find(".user").attr("onclick", "showMsg()");
                }
            }
        });
    }
    function remove(obj) {

        $(obj).parent().parent().remove();
    }

    function openCalendarr(obj) {
        var clientCompId = $(obj).parent().parent().parent().parent().find('#clientCompId').val();
        var supervisorId = $(obj).parent().parent().parent().parent().find('#supervisorId').val();

    }

</script>


<script src='ChangeLang.js' type='text/javascript'></script>
<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>Untitled Document</title>
        <link href="css/bootstrap.min.css" rel="stylesheet" media="screen">
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css">
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.core.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.widget.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.drop.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.fold.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.mouse.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.slider.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.dialog.js"></script>
        <link rel="stylesheet" type="text/css" href="js/countdown/jquery.countdown.css"> 
        <script type="text/javascript" src="js/countdown/jquery.countdown-ar.js"></script>
        <script type="text/javascript">
    $(function() {
        var count = 50;
        var sec = parseInt(count % 60);
        var min = parseInt(count / 60);
        countdown = setInterval(function() {
            if (min === 0 & sec === 0) {
                window.location.href = window.location.href;
            }
            if (min > 0 & sec > 0) {
                min--;
                sec--;
                $("#min").val(min);
                $("#sec").val(sec);
            }

        }, <%=interval%>);
    });
    $(function() {
        $("#entryDate").datetimepicker({
            maxDate: '<%=currentYear%>' + '/' + '<%=currentMonth + 1%>' + '/' + '<%=currentDay%>',
            changeMonth: true,
            changeYear: true,
            timeFormat: 'hh:mm',
            dateFormat: 'yy/mm/dd'
        });
    });
    
    function showCalendar(display) {
        if(display) {
            $("#add_service").css("display", "");
        } else {
            $("#add_service").css("display", "none");
        }
    }

    $(document).ready(function() {

        function repeateScroll() {
            window.scroll(0, scrollMaxY);
        }

        $("#add_claim").click(function(e) {

            if ($("#save_info").attr("id") == "save_info") {
                alert("يجب إدخال رقم المتابعة أولا");
            }
            else {

                $("#claim_division").find("#tableDATA").append($("#claimROW"));
                var text = $("#claim_division").html();
                $("#getDIV").css("background", "#FFDAE2");
                $("#getDIV").css("margin-top", "5px");
                $("#getDIV").css("border-radius", "5px");
                $("#getDIV").html(text.valueOf()).slideDown();
                repeateScroll();
            }


        });
        $("#add_service").click(function(e) {

            if ($("#save_info").attr("id") == "save_info") {
                alert("يجب إدخال رقم المتابعة أولا");
            }
            else {
                var url = "<%=context%>/ProjectServlet?op=listAllWorkerInArea&areaID=<%=client.getAttribute("region")%>&clientID=<%=clientId%>";
                jQuery('#getDIV').load(url); 
                $('#getDIV').css("display", "block");
//                $("#service_division").find("#tableDATA").append($("#serviceROW")).append($("#separateRow"));
//                var text = $("#service_division").html();
                $("#getDIV").css("background", "#FFFFFF");
//                $("#service_division").find("#tableDATA").append($("#serviceROW")).append($("#separateRow"));
//                var text = $("#service_division").html();
//                $("#getDIV").css("background", "#FFEEA2");
//                $("#getDIV").css("margin-top", "5px");
//                $("#getDIV").css("border-radius", "5px");
//                $("#getDIV").html(text.valueOf()).slideDown();
//                repeateScroll();
            }


        });
        $("#add_order").click(function() {
            if ($("#save_info").attr("id") == "save_info") {
                alert("يجب إدخال رقم المتابعة أولا");
            }
            else {
                //                     $("#orderTable #orderROW .employees").removeAttr("id");
                $("#order_division").find("#orderTable").append($("#orderROW"));
                var text = $("#order_division").html();
                $("#getDIV").css("background", "#CBF7DC");
                $("#getDIV").css("margin-top", "5px");
                $("#getDIV").css("border-radius", "5px");
                $("#getDIV").html(text.valueOf()).slideDown();
                repeateScroll();
            }
        });
        $("#add_query").click(function() {

            if ($("#save_info").attr("id") == "save_info") {
                alert("يجب إدخال رقم المتابعة أولا");
            }
            else {

                $("#query_division").find("#tableDATA").append($("#queryROW"));
                var text = $("#query_division").html();
                $("#getDIV").css("background", "#D6E5FF");
                $("#getDIV").css("margin-top", "5px");
                $("#getDIV").css("border-radius", "5px");
                $("#getDIV").html(text.valueOf()).slideDown();
                repeateScroll();
            }
        });
    });</script>
    </head>

    <style>
        textarea{
            resize:none;
        }
        .table td{
            padding:5px;
            text-align:center;
            font-family:Georgia, "Times New Roman", Times, serif;
            font-size:14px;
            font-weight: bold;
            height:20px;
            border: none;
        }

        #claim_division {

            width: 90%;
            display: none;
            margin:3px auto;
            border: 1px solid #999;
        }
        #service_division {

            width: 90%;
            display: none;
            margin:3px auto;
            border: 1px solid #FFC70A;
        }
        #order_division{

            width: 90%;
            display: none;
            margin:3px auto;
            border: 1px solid #999;
        }
        label{
            font: Georgia, "Times New Roman", Times, serif;
            font-size:14px;
            font-weight:bold;
            color:#005599;
        }
        .div{

            direction: rtl;
        }

        #call_center{
            direction:rtl;
            padding:0px;
            margin-top: 5px;
            margin-left: auto;
            margin-right: auto;
            margin-bottom: 5px;
            color:#005599;
            /*            height:600px;*/
            width:100%;
            position:relative;
            border:none;
            font:Verdana, Geneva, sans-serif;
            font-size:18px;
            font-weight:bold;

        }
        #title{padding:10px;
               margin:0px 10px;
               height:30px;
               width:95%;
               clear: both;
               text-align:center;

        }
        #changeRate{
            width: 32px;height: 32px;background-image: url(images/user_male_edit.png);background-repeat: no-repeat;display: inline; 
        }
        .save3{
            width:20px;
            height:20px;
            background-image:url(images/icons/icon-32-publish.png);
            background-repeat: no-repeat;
            background-position: bottom;
            cursor: pointer;
            background-color:transparent;
            border:none;    

        }
        .text-success{
            font-family:Verdana, Geneva, sans-serif;
            font-size:24px;
            font-weight:bold;
        }

        /*        #unit_division {
                    width:46%;
                    float:left;
                    border: 1px solid red;
                                height:200px;
        
                    margin-top: 0px;
                    margin-right: 5px;
                    margin-bottom: 5px;
                    margin-left: 5px;
                                padding-top: 10px;
                                padding-right: 10px;
                                padding-bottom: 10px;
                                padding-left: 10px;
        
                }*/
        /*        #customer_division {
                    width:46%;
                    border: 1px solid red;
        
                                height:200px;
                    margin-top: 0px;
                    margin-right: 0px;
                    margin-bottom: 0px;
                    margin-left: 46%;
                                padding-top: 10px;
                                padding-right: 10px;
                                padding-bottom: 10px;
                                padding-left: 10px;
        
                }*/
        /*        #information { 
                    padding:10px;
                    width: 96%;
                    margin: 5px auto;
                    height:220px;
                }*/
        #tableDATA th{

            font-size: 15px;
        }

        .save {
            width:16px;
            height:16px;
            background-image:url(images/icons/check.png);
            background-repeat: no-repeat;
            cursor: pointer;
        }
        .user{

            width:32px;
            height:32px;
            background-image:url(images/icons/status.png);
            background-repeat: no-repeat;
            cursor: pointer;
        }
        .removeRow {
            width:32px;
            height:32px;
            margin: 4px;
            background-repeat: no-repeat;
            cursor: pointer;
            background-image:url(images/icons/remove.png);

        }
        .calendar {
            width:32px;
            height:32px;
            margin: 4px;
            background-repeat: no-repeat;
            cursor: pointer;
            background-image:url(images/icons/calendar-add-icon.png);

        }
        .button_order {
            width:104px;
            height:40px;
            /*            margin: 4px;*/
            background-repeat: no-repeat;
            cursor: pointer;
            border: none;
            background-position: right top ;
            display: inline-block;
            background-color: transparent;
            background-image:url(images/buttons/request_.png);
        }
        .button_claim {
            width:104px;
            height:40px;
            /*            margin: 4px;*/
            background-repeat: no-repeat;
            cursor: pointer;
            border: none;
            background-position: right top ;
            display: inline-block;
            background-color: transparent;
            background-image:url(images/buttons/claimm.png);
        }
        .button_service {
            width:104px;
            height:40px;
            /*            margin: 4px;*/
            background-repeat: no-repeat;
            cursor: pointer;
            border: none;
            background-position: right top ;
            display: inline-block;
            background-color: transparent;
            background-image:url(images/buttons/speedMaint.png);
        }
        .button_query{
            width:104px;
            height:40px;
            /*            margin: 4px;*/
            background-repeat: no-repeat;
            cursor: pointer;
            border: none;
            background-position: right top ;
            display: inline-block;
            background-color: transparent;
            background-image:url(images/buttons/query_.png);
        }
        .button_close{
            width:76px;
            height:35px;
            /*            margin: 4px;*/
            background-repeat: no-repeat;
            cursor: pointer;
            border: none;
            background-position: right top ;
            display: inline-block;
            background-color: transparent;
            background-image:url(images/buttons/close_.png);
        }
        .button_record{
            width:145px;
            height:31px;
            /*            margin: 4px;*/
            background-repeat: no-repeat;
            cursor: pointer;
            border: none;
            background-position: right top ;
            display: block;
            background-color: transparent;
            background-image:url(images/buttons/Number.png);
        }
        .unknown{
            width: 30px;
            height: 30px;
            background-image: url(images/icons/unknown.png);
            background-repeat: no-repeat;
            background-size: 100%;
            cursor: pointer;
            background-color: transparent;
            border: none;    

        }
    </style>
    <body>
        <FORM ID="CLIENT_COMPLAINT_FORM" NAME="CLIENT_COMPLAINT_FORM" METHOD="POST">
            <input type="hidden" id="clientId" name="clientId" value="<%=clientId%>"/>
            <input type="hidden" id="businessId" name="businessId" value=""/>

            <div  id="call_center" class="div" >
                <div style="width: 100%;margin: 0px;border: none;" id="loadPage">
                    <%
                        String page2 = (String) request.getAttribute("includePage");
                        if (null == page2) {
                            page2 = securityUser.getDefaultPage();
                        }
                        try {
                    %>
                    <div>
                        <jsp:include page="<%=page2%>" flush="true"/>
                        <% } catch (Exception ex) { %>
                        <% out.println(ex.getMessage());
                            }%>
                    </div>
                </div>
                <% if (enableService != null && enableService.equals("enable")) {%>
                <div style="width: 100%;margin-left: auto;margin-right: auto;border: none;">
                    <div style="width: 90%;margin-left: auto;margin-right:auto;margin-top: 0px;border: none;">
                        <fieldset  style="">
                            <legend style="color: #FF3300 ;"><span> المكالمة / المقابلة </span></legend>
                            <table style="width: 98%;" class="table">
                                <tr>
                                    <td style="border-left: none;width: 50%;">
                                        <table width="100%"   dir="rtl" height="100%" style="border-left:0px;">
                                            <tr>
                                                <td  width="30%" style="color: #27272A;" class="excelentCell formInputTag"  >رقم المتابعة</td>
                                                <td style="<%=style%>">
                                                    <div id="pursuanceNO"></div>  
                                                </td>
                                            </tr>
                                            <tr>
                                                <td  style="color: #27272A;" class="excelentCell formInputTag" >نوع الإتصال  </td>
                                                <td style="text-align:right;" nowrap>
                                                    <% if (status != null && status.equalsIgnoreCase("success") && issueWbo.getAttribute("issueDesc") != null) {%>
                                                    <%} else {%>
                                                    <input name="note" type="radio" value="call" checked="" id="note">
                                                    <label><img src="images/dialogs/phone.png" alt="phone" width="24px">مكالمة </label>
                                                    <input name="note" type="radio" value="meeting" id="note" style="margin-right: 10px;">
                                                    <label><img src="images/dialogs/handshake.png" alt="meeting" width="24px"> مقابلة</label>
                                                    <input name="note" type="radio" value="internet" id="note" style="margin-right: 10px;">
                                                    <label> <img src="images/dialogs/internet-icon.png" alt="internet" width="24px"> أنترنت</label>
                                                        <% }%>
                                            </tr>
                                        </table>
                                    </td>
                                    <td  style="border-right: none;width: 50%;">
                                        <table border="1px" width="100%" class="table">
                                            <tr>
                                                <td width="30%"  style="color: #27272A;" class="excelentCell ">إتجاة المكالمة/المقابلة</td>
                                                <%if (status != null && status.equalsIgnoreCase("success")) {%>
                                                <td style="text-align:right;">
                                                    <input  name="call_status" id="call_status"type="radio" value="incoming" <%if (call_status.equals("incoming")) {%> checked <%}%> />
                                                    <label><img src="images/dialogs/call-incoming.png" width="24px"/>واردة</label>
                                                    <input name="call_status" id="call_status" type="radio" value="out_call" style="margin-right: 10px;" <%if (call_status.equals("out_call")) {%> checked <%}%>/>
                                                    <label><img src="images/dialogs/call-outgoing.png" width="24px"/>صادرة</label>
                                                </td>
                                                <% } else {%>
                                                <td style="text-align:right;">
                                                    <input  name="call_status" id="call_status" type="radio" value="incoming" checked />
                                                    <label><img src="images/dialogs/call-incoming.png" width="24px"/>واردة</label>
                                                    <input name="call_status" id="call_status" type="radio" value="out_call" style="margin-right: 10px;"/>
                                                    <label><img src="images/dialogs/call-outgoing.png" width="24px"/>صادرة</label>
                                                </td>
                                                <% }%>
                                            </tr>
                                            <tr>
                                                <td  style="color: #27272A;" class="excelentCell formInputTag">التاريخ</td>
                                                <td dir="ltr" style="<%=style%>"> <input name="entryDate" id="entryDate" type="text" size="50" maxlength="50" style="width: 50%;" value="<%=(entryDate == null) ? nowTime : entryDate%>"/><img alt=""  style="margin-right: 5px;" src="images/showcalendar.gif" onMouseOver="Tip('<%=calenderTip%>', CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#FFFF99', FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT, 'BOLD', SHADOW, true, SHADOWWIDTH, 7, TITLE, 'Display Calender Help', TITLEALIGN, 'center', TITLEFONTCOLOR, 'black', TITLEBGCOLOR, '#6699FF')" onMouseOut="UnTip()"  /></td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr style="border: 0px solid red;">
                                    <td  colspan="2" style="color: #27272A;">
                                        <% if (status != null && status.equalsIgnoreCase("success")) {%>
                                        <% } else { %>
                                        <div style="text-align:center;width:20%;margin-left: auto;margin-right: auto" id="saveCall">  
                                            <input  name="save_info" type="button" onclick="JavaScript: saveCall();" id ="save_info"class="button_record"/>
                                        </div>
                                        <% }%>
                                    </td>
                                </tr>
                            </table>
                    </div>
                    <div style="width:90%;text-align:right;margin-left: auto;margin-right: auto ;margin-top: 10px;"class="div">
                        <input type="button" name="add_order" id="add_order" class="button_order"/>
                        &ensp;
                        <input type="button" name="add_claim" id="add_claim"  class="button_claim"/>
                        &ensp;
                        <input type="button"  name="add_claim" id="add_query" class="button_query" />
                        <% if (showCalendar != null && !showCalendar.equals("") && showCalendar.equals("0")) { %>
                        &ensp;
                        <input type="button" name="add_claim" id="add_service"  class="button_service" />
                        <% }%>
                    </div>
                    <div id="getDIV" style="width:90%; clear: both;margin: auto;"class="div"></div>
                    <div style="clear: both;"></div>

                    <div id="claim_division" style="display: none;text-align: right;" class="div">
                        <table width="99%;" border="1px" style="margin-top: 10px;" id="tableDATA">
                            <tr>
                                <th   style="width: 10%;">عنوان الشكوى</th>
                                <th   style="width: 45%;">الشكوى</th>
                                <th   style="width: 31%;">الإدارة المختصة</th>
                                <th  style="width: 7%;" id="">خ.ع</th>
                            </tr>
                            <tr id="claimROW">
                                <td>
                                    <table width="99%;" border="0" style="">
                                        <tr>
                                            <td colspan="3" style="border: 0px;">
                                                <SELECT id="subject" name="subject" STYLE="width:200px;font-size: medium; font-weight: bold;"onchange="getDepartmentEmployees(this);"  >
                                                    <sw:WBOOptionList wboList='<%=complaints%>' displayAttribute = "projectName" valueAttribute="projectName" />
                                                </SELECT>
                                        <lable id="subjectContent"style="display: none;width: 100%;float: right;clear: both;"></lable>
                                </td>
                            </tr>
                            <tr>
                                <td style="border: 0px; font-size: medium; padding-top: 10px; padding-bottom: 10px;">درجة الأهمية</td>
                                <td style="border: 0px; font-size: medium; padding-top: 10px; padding-bottom: 10px;"><input type="radio" name="orderUrgency" value="1" checked>عادي</input></td>
                                <td style="border: 0px; font-size: medium; padding-top: 10px; padding-bottom: 10px;"><input type="radio" name="orderUrgency" value="2">عاجل</input></td>
                            </tr>
                            <tr>
                                <td style="border: 0px; font-size: medium;">الوحدة</td>
                                <td style="border: 0px; font-size: medium;" colspan="2">
                                    <SELECT id="category" name="category" STYLE="width:100px;font-size: medium; font-weight: bold;"onchange="getDepartmentEmployees(this);"  >
                                        <sw:WBOOptionList wboList='<%=categories%>' displayAttribute = "projectName" valueAttribute="projectID" />
                                    </SELECT>
                                </td>
                            </tr>
                        </table>
                        <input type="hidden" id="clientCompId" value=""/>
                        </td>
                        <td ><textarea rows="3" id="complaint" style="width: 98%;" onmousedown="clearValidate(this)"></textarea></td>
                        <td  >
                            <div >
                                <div style="display: block;float: right;width: 80%;">
                                    <SELECT id="department" name="department" STYLE="width:100%;font-size: medium; font-weight: bold;"onchange="getDepartmentEmployees(this);"  >
                                        <sw:WBOOptionList wboList='<%=complaintList%>' displayAttribute = "projectName" valueAttribute="optionOne" />
                                    </SELECT> 
                                </div>
                                <input type="button" class='save3'id="mgrBtn" style="background-color: transparent;display: block;margin-right: auto;margin-left: auto;"  onclick='saveComplaint(this)'/>
                            </div>
                            <div style="">
                                <div style="display: block;float: right;width: 80%;">
                                    <SELECT id="employees" name="employees" STYLE="width:100%;font-size: medium; font-weight: bold; margin-top: 5px;" >

                                    </SELECT>
                                </div>
                                <input type="button" class='save3' id="empBtnc" style="background-color: transparent;display: block;margin-right: auto;margin-left: auto;margin-top:5px;"  onclick='sendClaimToEmployee(this)'/>
                            </div>          
                            <div style="">
                                <input type="button" class='unknown' id="unknownBtn" style="background-color: transparent;display: block;margin-right: auto;margin-left: auto;margin-top:5px;"  onclick='sendToUnknown(this, "1")' title="غير معلوم الأدارة"/>
                            </div>          
                        </td>
                        <td id="">
                            <div id='user' class='user' style='background-position: bottom;margin-left: auto;margin-right: auto;' onclick='saveComplaintCurrentUser(this)'></div>
                        </td>
                        </tr>
                        </table> 
                        <input name="close" id="close" type="button" class="button_close" onClick="$('#getDIV').slideUp();"/>
                    </div>
                </div>

                <div id="service_division" style="display: none;text-align: right;" class="div">
                    <table width="99%;" border="0px" style="margin-top: 10px;" id="tableDATA">
                        <tr>
                            <th style="width: 10%; border-width: 0px"></th>
                            <th style="width: 45%; border-width: 0px">الخدمة</th>
                            <th style="width: 7%; border-width: 0px" id="">حفظ</th>
                            <th id="calendar" style="width: 7%;display: block; border-width: 0px" id="">الحجز</th>
                        </tr>
                        <tr>
                            <td colspan="4" style="border-width: 0px">
                                <hr style="width: 100%; background-color: black" />
                            </td>
                        </tr>
                        <tr id="serviceROW">
                            <td style="width: 10%; border-width: 0px">
                                <input type="text"id="subject" name="subject" value="" maxlength="30" onmousedown="clearValidate(this)"/>
                        <lable id="subjectContent"style="display: none;width: 100%;float: right;clear: both;"></lable>
                        <input type="hidden" id="clientCompId" value=""/>
                        <input type="hidden" id="supervisorId" value=""/>
                        </td>
                        <td style="border-width: 0px"><textarea rows="3" id="service" style="width: 98%;" onmousedown="clearValidate(this)"></textarea></td>
                        <td style="border-width: 0px" id="">
                            <input type="hidden" id="area_id" value='<%=client.getAttribute("region")%>' />
                            <div id='user' class='user' style='background-position: bottom;margin-left: auto;margin-right: auto;' onclick='saveServiceCurrentUser(this)'></div>
                        </td>
                        <td id="calendar" style="display: block; border-width: 0px">
                            <div  class="calendar" style='margin-left: auto;margin-right: auto;' onclick="openCalendarr(this)"></div>
                        </td>
                        </tr>
                        <tr id="separateRow">
                            <td colspan="4" style="border-width: 0px">
                                <hr style="width: 100%; background-color: black" />
                            </td>
                        </tr>
                    </table>
                    <div style="margin:10px;">
                        <input name="close" id="close" type="button" class="button_close" onClick="$('#getDIV').slideUp();"/>
                    </div>
                </div>
                <div id="order_division" style="display: none;"class="div">
                    <table width="99%;" border="1px" style="margin-top: 10px;" id="tableDATA" >
                        <tr>
                            <th   style="width: 10%;">عنوان الطلب</th>
                            <th   style="width: 45%;">الطلب</th>

                            <th   style="width: 31%;">الإدارة المختصة</th>
                            <!--<th  style="width: 10%;">للمدير</th>-->
                            <!--<th  style="width:5%;" id="removeTd">للموظف المختص</th>-->
                            <th  style="width: 7%;" id="">خ.ع</th>
                            <!--th  style="width: 7%;">حذف</th-->
                        </tr>

                        <tr id="orderROW">
                            <td>
                                <table width="99%;" border="0" style="">
                                    <tr>
                                        <td colspan="3" style="border: 0px;">
                                            <SELECT id="subject" name="subject" STYLE="width:200px;font-size: medium; font-weight: bold;"onchange="getDepartmentEmployees(this);"  >
                                                <sw:WBOOptionList wboList='<%=requests%>' displayAttribute = "projectName" valueAttribute="projectName" />
                                            </SELECT> 
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="border: 0px; font-size: medium; padding-top: 10px; padding-bottom: 10px;">درجة الأهمية</td>
                                        <td style="border: 0px; font-size: medium; padding-top: 10px; padding-bottom: 10px;"><input type="radio" name="orderUrgency" value="1" checked>عادي</input></td>
                                        <td style="border: 0px; font-size: medium; padding-top: 10px; padding-bottom: 10px;"><input type="radio" name="orderUrgency" value="2">عاجل</input></td>
                                    </tr>
                                    <tr>
                                        <td style="border: 0px; font-size: medium;">الوحدة</td>
                                        <td style="border: 0px; font-size: medium;" colspan="2">
                                            <SELECT id="category" name="category" STYLE="width:100px;font-size: medium; font-weight: bold;"onchange="getDepartmentEmployees(this);"  >
                                                <sw:WBOOptionList wboList='<%=categories%>' displayAttribute = "projectName" valueAttribute="projectID" />
                                            </SELECT>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td ><textarea  rows="3"    style="width: 100%;" id="order" onmousedown="clearValidate(this)"></textarea></td>
                            <td  style="">
                                <div style="">
                                    <div style="display: block;float: right;width: 80%;">
                                        <SELECT id="department" name="department" STYLE="width:100%;font-size: medium; font-weight: bold;"onchange="getDepartmentEmployees(this);"  >
                                            <sw:WBOOptionList wboList='<%=complaintList%>' displayAttribute = "projectName" valueAttribute="optionOne" />
                                        </SELECT> 
                                    </div>
                                    <input type="button" id="mgrBtn" class='save3' style="background-color: transparent;display: block;margin-right: auto;margin-left: auto;"  onclick='saveOrder(this)'/>
                                    <!--<div id='save' class='save' style='background-position: bottom;display: block' ></div>-->
                                </div>
                                <div style="">
                                    <div style="display: block;float: right;width: 80%;">
                                        <SELECT id="employees" name="employees" STYLE="width:100%;font-size: medium; font-weight: bold; margin-top: 5px;" >

                                        </SELECT>
                                    </div>
                                    <input type="button" class='save3' style="background-color: transparent;display: block;margin-right: auto;margin-left: auto;margin-top:5px;" id="sendOrder" onclick='sendOrderToEmployee(this)'/>
                                    <!--<div id='saveemp' class='save' style='margin-top:5px;background-position: bottom;display: block' ></div>-->
                                </div>         
                                <div style="">
                                    <input type="button" class='unknown' id="unknownBtn" style="background-color: transparent;display: block;margin-right: auto;margin-left: auto;margin-top:5px;"  onclick='sendToUnknown(this, "2")' title="غير معلوم الأدارة"/>
                                </div>          

                            </td>

                            <!--                           
                            <td id="removeTd">
                                <div id='status' class='status' style='background-position: bottom;margin-left: auto;margin-right: auto;' onclick='view1(this)'></div>
                            </td>
                            -->
                            <td id="">
                                <div id='user' class='user' style='background-position: bottom;margin-left: auto;margin-right: auto;' onclick='saveOrderCurrentUser(this)'></div>
                            </td>
                            <!--td>
                                <div  class="removeRow" style='margin-left: auto;margin-right: auto;' onclick="remove(this)"></div>
                            </td-->

                        </tr>


                    </table>
                    <div style="margin:10px;">

                        <!--<input name="close" id="closeTab" type="button" value="إغلاق" class="btn btn-danger" onClick="$('#getDIV').slideUp();"/>-->
                        <input name="close" id="close" type="button" class="button_close" onClick="$('#getDIV').slideUp();"/>
                    </div>
                </div>
                <div id="query_division" style="display: none;"class="div">
                    <table width="99%;" border="1px" style="margin-top: 10px;" id="tableDATA">
                        <tr>
                            <th   style="width: 10%;">عنوان الاستعلام</th>
                            <th   style="width: 45%;">الإستعلام</th>
                            <th   style="width: 31%;">الإدارة المختصة</th>
                            <!--<th  style="width: 10%;">للمدير</th>-->
                            <!--<th  style="width:5%;" id="removeTd">للموظف المختص</th>-->
                            <th  style="width: 7%;" id="">خ.ع</th>
                            <!--th  style="width: 7%;">حذف</th-->
                        </tr>

                        <tr id="queryROW">
                            <td >
                                <table width="99%;" border="0" style="">
                                    <tr>
                                        <td colspan="2" style="border: 0px;">
                                            <SELECT id="subject" name="subject" STYLE="width:200px;font-size: medium; font-weight: bold;"onchange="getDepartmentEmployees(this);"  >
                                                <sw:WBOOptionList wboList='<%=inquiries%>' displayAttribute = "projectName" valueAttribute="projectName" />
                                            </SELECT>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="border: 0px; font-size: medium;">المشروع</td>
                                        <td style="border: 0px; font-size: medium;">
                                            <SELECT id="category" name="category" STYLE="width:120px;font-size: medium; font-weight: bold;"onchange="getDepartmentEmployees(this);"  >
                                                <sw:WBOOptionList wboList='<%=inquiryCategories%>' displayAttribute = "projectName" valueAttribute="projectID" />
                                            </SELECT>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td ><textarea  rows="3"    style="width: 98%;" id="query"  onmousedown="clearValidate(this)"></textarea></td>
                            <td  >
                                <div >
                                    <div style="display: block;float: right;width: 80%;">
                                        <SELECT id="department" name="department" STYLE="width:100%;font-size: medium; font-weight: bold;"onchange="getDepartmentEmployees(this);"  >
                                            <sw:WBOOptionList wboList='<%=complaintList%>' displayAttribute = "projectName" valueAttribute="optionOne" />
                                        </SELECT> 
                                    </div>
                                    <input type="button" id="mgrBtn" class='save3' style="background-color: transparent;display: block;margin-right: auto;margin-left: auto;"  onclick='saveQuery(this)'/>
                                    <!--<div id='save' class='save' style='background-position: bottom;display: block'></div>-->
                                </div>
                                <div style="">
                                    <div style="display: block;float: right;width: 80%;">
                                        <SELECT id="employees" name="employees" STYLE="width:100%;font-size: medium; font-weight: bold; margin-top: 5px;" >

                                        </SELECT>
                                    </div>
                                    <!--<div id='saveemp' class='save3' style='background-position: bottom;display: block;margin-top:5px;' onclick='sendQueryToEmployee(this)'>-->

                                    <input type="button" class='save3' id="empBtn" style="background-color: transparent;display: block;;margin-right: auto;margin-left: auto;margin-top:5px;" onclick='sendQueryToEmployee(this)'/>
                                    <!--</div>-->
                                </div>          
                                <div style="">
                                    <input type="button" class='unknown' id="unknownBtn" style="background-color: transparent;display: block;margin-right: auto;margin-left: auto;margin-top:5px;"  onclick='sendToUnknown(this, "3")' title="غير معلوم الأدارة"/>
                                </div>         

                            </td>

                            <td id="">
                                <div id='user' class='user' style='background-position: bottom;margin-left: auto;margin-right: auto;' onclick='saveQueryCurrentUser(this)'></div>
                            </td>
                            <!--td>
                                <div   id="remove" class="removeRow" style='margin-left: auto;margin-right: auto;' onclick="remove(this)"></div>
                            </td-->

                        </tr>


                    </table>

                    <div style="margin:10px;">

                        <!--//   <input name="close" id="closeTab" type="button" value="إغلاق" class="btn btn-danger" onClick="$('#getDIV').slideUp();"/>-->
                        <input name="close" id="close" type="button" class="button_close" onClick="$('#getDIV').slideUp();"/>
                    </div>

                </div>
            </div>
            <% }%>

        </div>

    </FORM>
</body>
</html>
