<%@page import="com.crm.common.CRMConstants"%>
<%@page import="com.clients.db_access.ClientMgr"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject,com.tracker.db_access.ProjectMgr"%>
<%@page pageEncoding="UTF-8"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/tr/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String showCalendar = metaMgr.getShowCalendar();
        Calendar calendar = Calendar.getInstance();
        String timeFormat = "yyyy/MM/dd HH:mm";
        SimpleDateFormat sdf = new SimpleDateFormat(timeFormat);
        String nowTime = sdf.format(calendar.getTime());
        ProjectMgr projectMgr = ProjectMgr.getInstance();
        ArrayList<WebBusinessObject> departmentsList = new ArrayList<>(projectMgr.getOnArbitraryKey("div", "key6"));
        String entryDate = (String) request.getAttribute("entryDate");
        int currentDay = calendar.get(calendar.DAY_OF_MONTH);
        int currentYear = calendar.get(calendar.YEAR);
        int currentMonth = calendar.get(calendar.MONTH);
        ArrayList<WebBusinessObject> complaints = new ArrayList(projectMgr.getOnArbitraryKeyOracle("cmplnt", "key6"));
        ArrayList<WebBusinessObject> requests = new ArrayList(projectMgr.getOnArbitraryKeyOracle("rqst", "key6"));
        ArrayList<WebBusinessObject> categories = new ArrayList<>(projectMgr.getOnArbitraryKeyOracle("44", "key6"));
        ArrayList<WebBusinessObject> inquiries = new ArrayList<>(projectMgr.getOnArbitraryKeyOracle("nqry", "key6"));
        if (complaints == null) {
            complaints = new ArrayList();
        } else {
            for (int i = complaints.size() - 1; i >= 0; i--) {
                WebBusinessObject tempWbo = complaints.get(i);
                if ("0".equals(tempWbo.getAttribute("mainProjId"))) {
                    complaints.remove(tempWbo);
                    break;
                }
            }
        }
        if (requests == null) {
            requests = new ArrayList();
        } else {
            for (int i = requests.size() - 1; i >= 0; i--) {
                WebBusinessObject tempWbo = requests.get(i);
                if ("0".equals(tempWbo.getAttribute("mainProjId"))) {
                    requests.remove(tempWbo);
                    break;
                }
            }
        }
        if (inquiries == null) {
            inquiries = new ArrayList();
        } else {
            for (int i = inquiries.size() - 1; i >= 0; i--) {
                WebBusinessObject tempWbo = inquiries.get(i);
                if ("0".equals(tempWbo.getAttribute("mainProjId"))) {
                    inquiries.remove(tempWbo);
                    break;
                }
            }
        }
        String context = metaMgr.getContext();
        String stat = (String) request.getSession().getAttribute("currentMode");
        String dir, style, title, selectClient;
        String calenderTip;
        if (stat.equals("En")) {
            dir = "LTR";
            style = "text-align:left";
            title = "Create Complaint / Request";
            calenderTip = "click inside text box to opn calender window";
            selectClient = "Select Client";
        } else {
            dir = "RTL";
            style = "text-align:Right";
            title = "إنشاء شكوي / طلب";
            calenderTip = "&#1575;&#1590;&#1594;&#1591; &#1583;&#1575;&#1582;&#1604; &#1575;&#1604;&#1605;&#1587;&#1578;&#1591;&#1610;&#1604; &#1604;&#1603;&#1609; &#1610;&#1592;&#1607;&#1585; &#1604;&#1603; &#1606;&#1575;&#1601;&#1584;&#1607; &#1604;&#1571;&#1582;&#1578;&#1610;&#1575;&#1585; &#1575;&#1604;&#1578;&#1575;&#1585;&#1610;&#1582;";
            selectClient = "أختر عميل";
        }
    %>
    <head>
        <meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
        <meta HTTP-EQUIV="Expires" CONTENT="0"/>
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css"/>
        <link rel="stylesheet" type="text/css" href="js/jquery/api/jquery.datetimepicker.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css"/>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery.datetimepicker.js"/>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script LANGUAGE="JavaScript" TYPE="text/javascript">
            $(function () {
                $("#entryDate").datetimepicker({
                    maxDate: '<%=currentYear%>' + '/' + '<%=currentMonth + 1%>' + '/' + '<%=currentDay%>',
                    changeMonth: true,
                    changeYear: true,
                    timeFormat: 'hh:mm',
                    dateFormat: 'yy/mm/dd'
                });
            });
            $(document).ready(function () {
                $("#add_claim").click(function (e) {
                    if ($("#pursuanceNO").html() === "") {
                        alert("يجب إدخال رقم المتابعة أولا");
                    }
                    else {
                        $("#claim_division").find("#tableDATA").append($("#claimROW"));
                        var text = $("#claim_division").html();
                        $("#getDIV").css("background", "#FFDAE2");
                        $("#getDIV").css("margin-top", "5px");
                        $("#getDIV").css("border-radius", "5px");
                        $("#getDIV").html(text.valueOf()).slideDown();
                    }
                });
                $("#add_service").click(function (e) {
                    if ($("#pursuanceNO").html() === "") {
                        alert("يجب إدخال رقم المتابعة أولا");
                    }
                    else {
                        var url = "<%=context%>/ProjectServlet?op=listAllWorkerInArea&areaID=" + $("#area_id").val() + "&clientID=" + $("#clientId").val();
                        jQuery('#getDIV').load(url);
                        $('#getDIV').css("display", "block");
                        $("#getDIV").css("background", "#FFFFFF");
                    }
                });
                $("#add_order").click(function () {
                    if ($("#pursuanceNO").html() === "") {
                        alert("يجب إدخال رقم المتابعة أولا");
                    }
                    else {
                        $("#order_division").find("#tableDATA").append($("#orderROW"));
                        var text = $("#order_division").html();
                        $("#getDIV").css("background", "#CBF7DC");
                        $("#getDIV").css("margin-top", "5px");
                        $("#getDIV").css("border-radius", "5px");
                        $("#getDIV").html(text.valueOf()).slideDown();
                    }
                });
                $("#add_query").click(function () {
                    if ($("#pursuanceNO").html() === "") {
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
            });
            function saveCall() {
                var x = $("#note").val();
                if (x.length === 0) {
                    alert("من فضلك أدخل تعليق عن المكالمة");
                    return false;
                }
                if ($("#clientId").val() === '') {
                    alert("أختر عميل أولا");
                    openClientsDailog();
                    return;
                }
                if ($("#note").val().length > 0) {
                    $("#pursuanceNO").html("<img src='images/icons/spinner.gif'/>");
                    var call_status = $("#call_status:checked").val();
                    var note = $("#note").val();
                    var entryDate = $("#entryDate").val();
                    var clientId = $("#clientId").val();

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
                        success: function (jsonString) {
                            var info = $.parseJSON(jsonString);
                            if (info.status === 'success') {
//                                $("#save_info").remove();
                                $("#businessId").val(info.businessID);
                                $("#issueId").val(info.issueId);
                                $("#uploadFile").show();
                                $("#pursuanceNO").html("");
                                $("#pursuanceNO").html('<lable id="busNumber"><font color="red" size="3">' + info.businessID + '/</font><font color="blue" size="3" >' + info.businessIDbyDate + '</font></lable>');
                                $("#getDIV").html("");

                            } else {
                                $("#pursuanceNO").html("");
                                $("#pursuanceNO").html('<font color="red" size="3">Save Failed!/</font>');
                            }
                        }
                    });
                    return false;
                }
            }
            function getDepartmentEmployees(obj) {
                var x = $("#orderTable tr");
                $(x).each(function (index, row) {
                    if ($(row).find("#empl").attr("id") === "empl") {
                        $(row).find("#empl").attr("id", "employees");
                    }
                });
                var departmentId = $(obj).val();
                $.ajax({
                    type: "post",
                    url: "<%=context%>/IssueServlet?op=getDepartmentEmployees",
                    data: {
                        departmentId: departmentId
                    },
                    success: function (jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.responseText !== 'empty') {
                            $(obj).parent().parent().parent().find("#employees").attr("id", "empl");
                            var brand = document.getElementById('empl');
                            var result = info.responseText;
                            $(brand).html("");
                            if (result !== "empty") {
                                if ($("#empl").attr("disabled") === "disabled") {
                                    $("#empl").removeAttr("disabled");
                                }
                                $(obj).parent().parent().parent().find("#saveemp").show();
                                var data = result.split("<element>");
                                var idAndName = "";
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
            function getComplaintsRequests(obj, type) {
                var x = $("#orderTable tr");
                $(x).each(function (index, row) {
                    if ($(row).find("#empl").attr("id") === "empl") {
                        $(row).find("#empl").attr("id", "employees");
                    }
                });
                var departmentId = $(obj).val();
                var subject = $(obj).parent().parent().parent().parent().find('#subject');
                subject.removeAttr("disabled");
                subject.html("");
                $.ajax({
                    type: "post",
                    url: "<%=context%>/IssueServlet?op=getComplaintsRequests",
                    data: {
                        departmentId: departmentId,
                        type: type
                    },
                    success: function (jsonString) {
                        var data = $.parseJSON(jsonString);
                        var rowData;
                        if (data !== null) {
                            var len = data.length;
                            for (var i = 0; i < len; i++) {
                                rowData = data[i];
                                subject.html(subject.html() + "<option value='" + rowData.projectName + "'>" + rowData.projectName + "</option>");
                            }
                        } else {
                            subject.attr("disabled", "disabled");
                            subject.html("<option>لايوجد</option>");
                        }
                    }
                });
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
                            clientId: $("#clientId").val(),
                            orderUrgency: orderUrgency,
                            category: category
                        },
                        success: function (jsonString) {
                            var info = $.parseJSON(jsonString);
                            if (info.status === 'Ok') {
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
                            clientId: $("#clientId").val(),
                            orderUrgency: orderUrgency,
                            category: category},
                        success: function (jsonString) {
                            var info = $.parseJSON(jsonString);
                            if (info.status === 'Ok') {
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
                                $(obj).parent().parent().parent().find("#mgrBtn").css("background-image", "url(images/icons/notavailable.png)");
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
                            clientId: $("#clientId").val(),
                            category: category},
                        success: function (jsonString) {
                            var info = $.parseJSON(jsonString);
                            if (info.status === 'Ok') {

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
                            clientId: $("#clientId").val(),
                            category: category},
                        success: function (jsonString) {
                            var info = $.parseJSON(jsonString);
                            if (info.status === 'Ok') {

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
                            clientId: $("#clientId").val(),
                            orderUrgency: orderUrgency,
                            category: category},
                        success: function (jsonString) {
                            var info = $.parseJSON(jsonString);
                            if (info.status === 'Ok') {
                                $(obj).parent().parent().parent().find('#subjectContent').html(subject);
                                $(obj).parent().parent().parent().find('#subjectContent').css("display", "");
                                $(obj).parent().parent().parent().find('#subject').remove();
                                $(obj).parent().parent().parent().find('#clientCompId').val(info.clientCompId);
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
                                $(obj).parent().parent().parent().find("#empBtnc").css("background-image", "url(images/icons/notavailable.png)");
                                $(obj).parent().parent().parent().find("#user").css("background-image", "url(images/icons/notavailable.png)");
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
                            clientId: $("#clientId").val(),
                            businessId: businessId
                        },
                        success: function (jsonString) {
                            var info = $.parseJSON(jsonString);
                            if (info.status === 'Ok') {
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
                                $(obj).parent().parent().parent().find("#empBtnc").css("background-image", "url(images/icons/notavailable.png)");
                                $(obj).parent().parent().parent().find("#mgrBtn").css("background-image", "url(images/icons/notavailable.png)");
                            } else if (info.status === 'failStatus') {
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
                            clientId: $("#clientId").val()},
                        success: function (jsonString) {
                            var info = $.parseJSON(jsonString);
                            if (info.status === 'Ok') {
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

                            if (info.status === 'noManager') {
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
                            clientId: $("#clientId").val()},
                        success: function (jsonString) {
                            var info = $.parseJSON(jsonString);
                            if (info.status === 'Ok') {
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

                            if (info.status === 'noManager') {
                                alert("هذة الخاصية غير متاحة ");
                            }

                        }
                    });
                }
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
                    if ($(obj).parent().parent().find('#subject').val() === "مطلوب") {
                    } else {
                        x = true;
                    }

                }
                if (comment <= 0) {

                    $(obj).parent().parent().find('#query').css("background-color", "#FFDAE2");
                    $(obj).parent().parent().find('#query').val("من فضلك أدخل محتوى الإستعلام");
                } else {
                    if ($(obj).parent().parent().find('#query').val() === "من فضلك أدخل محتوى الإستعلام") {
                    } else {
                        y = true;
                    }
                }
                if (x === true & y === true) {
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
                    if ($(obj).parent().parent().find('#subject').val() === "مطلوب") {
                    } else {
                        x = true;
                    }

                }
                if (comment <= 0) {

                    $(obj).parent().parent().find('#complaint').css("background-color", "#FFDAE2");
                    $(obj).parent().parent().find('#complaint').val("من فضلك أدخل محتوى الشكوى");
                } else {
                    if ($(obj).parent().parent().find('#complaint').val() === "من فضلك أدخل محتوى الشكوى") {
                    } else {
                        y = true;
                    }
                }
                if (x === true & y === true) {
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
                    if ($(obj).parent().parent().find('#subject').val() === "مطلوب") {
                    } else {
                        x = true;
                    }

                }
                if (comment <= 0) {

                    $(obj).parent().parent().find('#complaint').css("background-color", "#FFDAE2");
                    $(obj).parent().parent().find('#complaint').val("أدخل تفاصيل الخدمة");
                } else {
                    if ($(obj).parent().parent().find('#complaint').val() === "أدخل تفاصيل الخدمة") {
                    } else {
                        y = true;
                    }
                }
                if (x === true & y === true) {
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
                    if ($(obj).parent().parent().find('#subject').val() === "مطلوب") {
                    } else {
                        x = true;
                    }

                }
                if (comment <= 0) {

                    $(obj).parent().parent().find('#order').css("background-color", "#FFDAE2");
                    $(obj).parent().parent().find('#order').val("من فضلك أدخل محتوى الطلب");
                } else {
                    if ($(obj).parent().parent().find('#order').val() === "من فضلك أدخل محتوى الطلب") {
                    } else {
                        y = true;
                    }
                }
                if (x === true & y === true) {
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
                    if ($(obj).parent().parent().parent().find('#subject').val() === "مطلوب") {
                    } else {
                        x = true;
                    }

                }
                if (comment <= 0) {

                    $(obj).parent().parent().parent().find('#query').css("background-color", "#FFDAE2");
                    $(obj).parent().parent().parent().find('#query').val("من فضلك أدخل محتوى الإستعلام");
                } else {
                    if ($(obj).parent().parent().parent().find('#query').val() === "من فضلك أدخل محتوى الإستعلام") {
                    } else {
                        y = true;
                    }
                }
                if (x === true & y === true) {
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
                    if ($(obj).parent().parent().parent().find('#subject').val() === "مطلوب") {
                    } else {
                        x = true;
                    }

                }
                if (comment <= 0) {

                    $(obj).parent().parent().parent().find('#complaint').css("background-color", "#FFDAE2");
                    $(obj).parent().parent().parent().find('#complaint').val("من فضلك أدخل محتوى الشكوى");
                } else {
                    if ($(obj).parent().parent().parent().find('#complaint').val() === "من فضلك أدخل محتوى الشكوى") {
                    } else {
                        y = true;
                    }
                }
                if (x === true & y === true) {
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
                    if ($(obj).parent().parent().parent().find('#subject').val() === "مطلوب") {
                    } else {
                        x = true;
                    }

                }
                if (comment <= 0) {

                    $(obj).parent().parent().parent().find('#order').css("background-color", "#FFDAE2");
                    $(obj).parent().parent().parent().find('#order').val("من فضلك أدخل محتوى الطلب");
                } else {
                    if ($(obj).parent().parent().parent().find('#order').val() === "من فضلك أدخل محتوى الطلب") {
                    } else {
                        y = true;
                    }
                }
                if (x === true & y === true) {
                    result = true;
                }
                return result;
            }
            ///////////////////////////////////////////////////////////
            function getDepartmentEmployees(obj) {
                var x = $("#orderTable tr");
                $(x).each(function (index, row) {
                    //            alert($(row).html())
                    if ($(row).find("#empl").attr("id") === "empl") {
                        $(row).find("#empl").attr("id", "employees");
                    }

                });

                var departmentId = $(obj).val();
                $.ajax({
                    type: "post",
                    url: "<%=context%>/IssueServlet?op=getDepartmentEmployees",
                    data: {
                        departmentId: departmentId
                    },
                    success: function (jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.responseText !== 'empty') {
                            //                    alert($(obj).val());

                            $(obj).parent().parent().parent().find("#employees").attr("id", "empl");
                            var brand = document.getElementById('empl');
                            //                    $(brand).html("");
                            //                    alert(brand)
                            var result = info.responseText;
                            //                    alert(result);
                            $(brand).html("");
                            if (result !== "empty") {
                                if ($("#empl").attr("disabled") === "disabled") {
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
                            clientId: $("#clientId").val(),
                            orderUrgency: orderUrgency,
                            category: category},
                        success: function (jsonString) {
                            var info = $.parseJSON(jsonString);
                            if (info.status === 'Ok') {
                                $(obj).parent().parent().parent().parent().find('#complaint').html(comment);
                                $(obj).parent().parent().parent().find('#subjectContent').html(subject);
                                $(obj).parent().parent().parent().find('#subjectContent').css("display", "");
                                $(obj).parent().parent().parent().find('#subject').remove();
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
                                $(obj).parent().parent().parent().find("#mgrBtn").css("background-image", "url(images/icons/notavailable.png)");
                            }
                        }
                    });
                }
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
                    if ($(obj).parent().parent().parent().find('#subject').val() === "مطلوب") {
                    } else {
                        x = true;
                    }
                }
                if (comment <= 0) {
                    $(obj).parent().parent().parent().find('#complaint').css("background-color", "#FFDAE2");
                    $(obj).parent().parent().parent().find('#complaint').val("من فضلك أدخل محتوى الشكوى");
                } else {
                    if ($(obj).parent().parent().parent().find('#complaint').val() === "من فضلك أدخل محتوى الشكوى") {
                    } else {
                        y = true;
                    }
                }
                if (x === true & y === true) {
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
                    if ($(obj).parent().parent().parent().find('#subject').val() === "مطلوب") {
                    } else {
                        x = true;
                    }
                }
                if (comment <= 0) {

                    $(obj).parent().parent().parent().find('#order').css("background-color", "#FFDAE2");
                    $(obj).parent().parent().parent().find('#order').val("من فضلك أدخل محتوى الطلب");
                } else {
                    if ($(obj).parent().parent().parent().find('#order').val() === "من فضلك أدخل محتوى الطلب") {
                    } else {
                        y = true;
                    }
                }
                if (x === true & y === true) {
                    result = true;
                }
                return result;
            }
            var divAttachmentTag;
            function openAttachmentDialog(objectType) {
                divAttachmentTag = $("div[name='divAttachmentTag']");
                var issueId = $("#issueId").val();
                $.ajax({
                    type: "post",
                    url: '<%=context%>/FileUploadServlet?op=getUploadDialog',
                    data: {
                        businessObjectId: issueId,
                        objectType: objectType
                    },
                    success: function (data) {
                        divAttachmentTag.html(data)
                                .dialog({
                                    modal: true,
                                    title: "ارفاق مستندات",
                                    show: "fade",
                                    hide: "explode",
                                    width: 800,
                                    position: {
                                        my: 'center',
                                        at: 'center'
                                    },
                                    buttons: {
                                        Cancel: function () {
                                            divAttachmentTag.dialog('close');
                                        },
                                        Done: function () {
                                            divAttachmentTag.dialog('close');
                                        }
                                    }
                                })
                                .dialog('open');
                    },
                    error: function (data) {
                        alert(data);
                    }
                });
            }

            function openClientsDailog() {
                var divTag = $("<div></div>");
                $.ajax({
                    type: "post",
                    url: '<%=context%>/ClientServlet?op=listClientsPopup',
                    data: {},
                    success: function (data) {
                        divTag.html(data).dialog({
                            modal: true,
                            title: "<%=selectClient%>",
                            show: "fade",
                            hide: "explode",
                            width: 600,
                            position: {
                                my: 'center',
                                at: 'center'
                            },
                            buttons: {
                                Cancel: function () {
                                    $(this).dialog('close').dialog('destroy');
                                },
                                Done: function () {
                                    $(this).find(':radio:checked').each(function () {
                                        $("#clientId").val(this.value);
                                        $("#clientName").val($(divTag.html()).find('#clientName' + this.value).val());
                                        $("#area_id").val($(divTag.html()).find('#clientRegion' + this.value).val());
                                        $("#clientMobile").val($(divTag.html()).find('#clientMobile' + this.value).val());
                                        $("#address").val($(divTag.html()).find('#clientAddress' + this.value).val());
                                    });
                                    $(this).dialog('close').dialog('destroy');
                                }
                            }
                        }).dialog('open');
                    }
                });
            }
            function closePopupDialog(formID) {
                try {
                    $('#' + formID).bPopup().close();
                } catch (err) {
                }
                try {
                    $("#" + formID).hide();
                    $('#overlay').hide();
                } catch (err) {
                }
            }
        </script>
        <style>
            .titlebar {
                height: 30px;
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
            #tableDATA th{
                font-size: 15px;
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
                padding-bottom: 3px;
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
                background-image:url(images/buttons/technicalSupport.png);
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
                width:130px;
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
        </style>
    </head>    
    <body>
        <div name="divAttachmentTag"></div>
        <form NAME="UNIT_LIST_FORM" METHOD="POST">
            <fieldset class="set" style="width:98%;border-color: #006699">
                <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <tr>
                        <td class="titlebar" style="text-align: center">
                            <font color="#005599" size="4"><%=title%></font>
                        </td>
                    </tr>
                </table>
                <br/>
                <div style="width:99%;margin-right: auto;margin-left: auto;">
                    <div style="width: 100%;margin-left: auto;margin-right: auto;border: none;">
                        <div style="width: 90%;margin-left: auto;margin-right:auto;margin-top: 0px;border: none;">
                            <table style="width: 60%;" class="table">
                                <tr>
                                    <td style="border-left: none;width: 50%;">
                                        <table width="100%"   dir="rtl" height="100%" style="border-left:0px;">
                                            <tr>
                                                <td width="20%" style="color: #27272A;" class="excelentCell formInputTag">العميل</td>
                                                <td class="cell" bgcolor="#EEEEEE" style="text-align:center;font-size:14px;border-width:1px;border-color:white;" id="data" colspan="2">
                                                    <input type="text" dir="<%=dir%>" autocomplete="off" value="" id="clientName" name="clientName" onclick="openClientsDailog();" readonly/>
                                                    <input type="hidden" id="clientId" name="clientId" value=""/>
                                                    <input type="hidden" id="clientMobile" name="clientMobile" value=""/>
                                                    <input type="hidden" id="address" name="address" value=""/>
                                                    <input type="button" name=" search" onclick="openClientsDailog();" id=" search" value="   بحث   "></TD>
                                                </td>
                                                <td width="20%" style="color: #27272A;" class="excelentCell formInputTag">رقم المتابعة
                                                    <input name="note" type="hidden" value="call" id="note"/>
                                                    <input name="call_status" id="call_status" type="hidden" value="incoming" />
                                                </td>
                                                <td width="20%" style="<%=style%>">
                                                    <div id="pursuanceNO"></div>
                                                    <input type="hidden" id="issueId" />
                                                </td>
                                                <td width="20%" style="color: #27272A;" class="excelentCell formInputTag">التاريخ</td>
                                                <td width="40%" dir="ltr" style="<%=style%>">
                                                    <input name="entryDate" id="entryDate" type="text" size="50" maxlength="50" style="width: 180px;" value="<%=(entryDate == null) ? nowTime : entryDate%>"/><img alt=""  style="margin-right: 5px;" src="images/showcalendar.gif" onMouseOver="Tip('<%=calenderTip%>', CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#FFFF99', FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT, 'BOLD', SHADOW, true, SHADOWWIDTH, 7, TITLE, 'Display Calender Help', TITLEALIGN, 'center', TITLEFONTCOLOR, 'black', TITLEBGCOLOR, '#6699FF')" onMouseOut="UnTip()"  />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr style="border: 1px solid red;">
                                    <td  colspan="2" style="color: #27272A;">
                                        <table width="100%"   dir="rtl" height="100%" style="border-left:0px;">
                                            <tr>
                                                <td style="width: 70%;">
                                                    <div style="text-align:center;width:20%;margin-left: 50px;margin-right: auto; float: left;" id="saveCall">  
                                                        <input  name="save_info" type="button" onclick="JavaScript: saveCall();" id ="save_info"class="button_record"/>
                                                    </div>
                                                </td>
                                                <td style="width: 30%;">
                                                    <a href="JavaScript: openAttachmentDialog('issue');" id="uploadFile"
                                                       style="display: none; float: right;" title="أرفاق مستند">
                                                        <img style="margin: 3px" src="images/icons/attachment.png" width="24" height="24">
                                                    </a>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div style="width:90%;text-align:right;margin-left: auto;margin-right: auto ;margin-top: 10px;"class="div">
                            <input type="button" name="add_order" id="add_order" class="button_order"/>
                            &ensp;
                            <input type="button" name="add_claim" id="add_claim" class="button_claim"/>
                            &ensp;
                            <input type="button" name="add_claim" id="add_query" class="button_query"/>
                            <% if (showCalendar != null && showCalendar.equals("0")) { %>
                            &ensp;
                            <input type="button" name="add_service" id="add_service"  class="button_service" />
                            <% }%>
                        </div>
                        <div id="getDIV" style="width:90%; clear: both;margin: auto;"class="div"></div>
                        <div style="clear: both;"></div>
                        <div id="claim_division" style="display: none;text-align: right;" class="div">
                            <table width="99%;" border="1px" style="margin-top: 10px;" id="tableDATA">
                                <tr>
                                    <th   style="width: 31%;">الإدارة المختصة</th>
                                    <th   style="width: 10%;">عنوان الشكوى</th>
                                    <th   style="width: 45%;">الشكوى</th>
                                    <th  style="width: 7%;" id="">خ.ع</th>
                                </tr>
                                <tr id="claimROW">
                                    <td>
                                        <div>
                                            <div style="display: block;float: right;width: 80%;">
                                                <SELECT id="department" name="department" STYLE="width:100%;font-size: medium; font-weight: bold;"onchange="getDepartmentEmployees(this);"  >
                                                    <sw:WBOOptionList wboList='<%=departmentsList%>' displayAttribute = "projectName" valueAttribute="optionOne" />
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
                                    </td>
                                    <td>
                                        <table width="99%;" border="0" style="">
                                            <tr>
                                                <td colspan="3" style="border: 0px;">
                                                    <SELECT id="subject" name="subject" STYLE="width:200px;font-size: medium; font-weight: bold;" >
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
                                                <td style="border: 0px; font-size: medium;">المشروع</td>
                                                <td style="border: 0px; font-size: medium;" colspan="2">
                                                    <SELECT id="category" name="category" STYLE="width:100px;font-size: medium; font-weight: bold;" >
                                                        <sw:WBOOptionList wboList='<%=categories%>' displayAttribute = "projectName" valueAttribute="projectID" />
                                                    </SELECT>
                                                </td>
                                            </tr>
                                        </table>
                                        <input type="hidden" id="clientCompId" value=""/>
                                    </td>
                                    <td><textarea rows="3" id="complaint" style="width: 98%;" onmousedown="clearValidate(this)"></textarea></td>
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
                                    <input type="hidden" id="area_id" value='' />
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
                                <th   style="width: 31%;">الإدارة المختصة</th>
                                <th   style="width: 10%;">عنوان الطلب</th>
                                <th   style="width: 45%;">الطلب</th>
                                <th  style="width: 7%;" id="">خ.ع</th>
                            </tr>
                            <tr id="orderROW">
                                <td  style="">
                                    <div style="">
                                        <div style="display: block;float: right;width: 80%;">
                                            <SELECT id="department" name="department" STYLE="width:100%;font-size: medium; font-weight: bold;"onchange="getDepartmentEmployees(this);"
                                                    getComplaintsRequests(this, 'rqst');""  >
                                                    <sw:WBOOptionList wboList='<%=departmentsList%>' displayAttribute = "projectName" valueAttribute="optionOne" />
                                        </SELECT> 
                                    </div>
                                    <input type="button" id="mgrBtn" class='save3' style="background-color: transparent;display: block;margin-right: auto;margin-left: auto;"  onclick='saveOrder(this)'/>
                                </div>
                                <div style="">
                                    <div style="display: block;float: right;width: 80%;">
                                        <SELECT id="employees" name="employees" STYLE="width:100%;font-size: medium; font-weight: bold; margin-top: 5px;" >
                                        </SELECT>
                                    </div>
                                    <input type="button" class='save3' style="background-color: transparent;display: block;margin-right: auto;margin-left: auto;margin-top:5px;" id="sendOrder" onclick='sendOrderToEmployee(this)'/>
                                </div>          

                            </td>
                            <td>
                                <table width="99%;" border="0" style="">
                                    <tr>
                                        <td colspan="3" style="border: 0px;">
                                            <SELECT id="subject" name="subject" STYLE="width:200px;font-size: medium; font-weight: bold;" >
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
                                        <td style="border: 0px; font-size: medium;">المشروع</td>
                                        <td style="border: 0px; font-size: medium;" colspan="2">
                                            <SELECT id="category" name="category" STYLE="width:100px;font-size: medium; font-weight: bold;" >
                                                <sw:WBOOptionList wboList='<%=categories%>' displayAttribute = "projectName" valueAttribute="projectID" />
                                            </SELECT>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td ><textarea rows="3" style="width: 100%;" id="order" onmousedown="clearValidate(this)"></textarea></td>
                            <td id="">
                                <div id='user' class='user' style='background-position: bottom;margin-left: auto;margin-right: auto;' onclick='saveOrderCurrentUser(this)'></div>
                            </td>
                        </tr>
                    </table>
                    <div style="margin:10px;">
                        <input name="close" id="close" type="button" class="button_close" onClick="$('#getDIV').slideUp();"/>
                    </div>
                </div>
                <div id="query_division" style="display: none;"class="div">
                    <table width="99%;" border="1px" style="margin-top: 10px;" id="tableDATA">
                        <tr>
                            <th   style="width: 31%;">الإدارة المختصة</th>
                            <th   style="width: 10%;">عنوان الاستعلام</th>
                            <th   style="width: 45%;">الإستعلام</th>
                            <th  style="width: 7%;" id="">خ.ع</th>
                        </tr>
                        <tr id="queryROW">
                            <td>
                                <div >
                                    <div style="display: block;float: right;width: 80%;">
                                        <SELECT id="department" name="department" STYLE="width:100%;font-size: medium; font-weight: bold;"onchange="getDepartmentEmployees(this);"  >
                                            <sw:WBOOptionList wboList='<%=departmentsList%>' displayAttribute = "projectName" valueAttribute="optionOne" />
                                        </SELECT> 
                                    </div>
                                    <input type="button" id="mgrBtn" class='save3' style="background-color: transparent;display: block;margin-right: auto;margin-left: auto;"  onclick='saveQuery(this)'/>
                                </div>
                                <div style="">
                                    <div style="display: block;float: right;width: 80%;">
                                        <SELECT id="employees" name="employees" STYLE="width:100%;font-size: medium; font-weight: bold; margin-top: 5px;" >
                                        </SELECT>
                                    </div>
                                    <input type="button" class='save3' id="empBtn" style="background-color: transparent;display: block;;margin-right: auto;margin-left: auto;margin-top:5px;" onclick='sendQueryToEmployee(this)'/>
                                </div>        
                            </td>
                            <td>
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
                                                <sw:WBOOptionList wboList='<%=categories%>' displayAttribute = "projectName" valueAttribute="projectID" />
                                            </SELECT>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td><textarea  rows="3"    style="width: 98%;" id="query"  onmousedown="clearValidate(this)"></textarea></td>
                            <td id="">
                                <div id='user' class='user' style='background-position: bottom;margin-left: auto;margin-right: auto;' onclick='saveQueryCurrentUser(this)'></div>
                            </td>
                        </tr>
                    </table>
                    <div style="margin:10px;">
                        <input name="close" id="close" type="button" class="button_close" onClick="$('#getDIV').slideUp();"/>
                    </div>
                </div>
            </div>
            <br/>
        </fieldset>
    </form>
</body>
</html>