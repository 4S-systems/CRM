<%@page import="java.util.List"%>
<%@page import="com.tracker.db_access.CampaignMgr"%>
<%@page import="com.crm.common.CRMConstants"%>
<%@page import="com.silkworm.util.DateAndTimeControl"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.DateFormat"%>
<%@page import="com.clients.db_access.ClientComplaintsMgr"%>
<%@page import="com.silkworm.common.UserMgr"%>
<%@page import="com.tracker.db_access.ProjectMgr"%>
<%@page import="com.silkworm.common.SecurityUser"%>
<%@page import="java.util.Calendar"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="com.silkworm.international.TouristGuide"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page pageEncoding="UTF-8"%>
<%
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    int iTotal = 0;
    ArrayList<WebBusinessObject> data = (ArrayList<WebBusinessObject>) request.getAttribute("data");
    ArrayList<WebBusinessObject> usersList = (ArrayList<WebBusinessObject>) request.getAttribute("usersList");
    ArrayList<WebBusinessObject> branchesList = (ArrayList<WebBusinessObject>) request.getAttribute("branchesList");
    String beDate = (String) request.getAttribute("beginDate");
    String eDate = (String) request.getAttribute("endDate");
    String senderID = (String) request.getAttribute("senderID");
    String branchID = (String) request.getAttribute("branchID");
    Calendar cal = Calendar.getInstance();
    String jDateFormat = "yyyy/MM/dd HH:mm";
    SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
    String nowTime = sdf.format(cal.getTime());
    cal = Calendar.getInstance();
    cal.add(Calendar.MONTH, -1);
    int a = cal.get(Calendar.YEAR);
    int b = (cal.get(Calendar.MONTH)) + 1;
    int d = cal.get(Calendar.DATE);
    String prev = a + "/" + b + "/" + d + " 00:00";
    SecurityUser securityUser = (SecurityUser) session.getAttribute("securityUser");
    ProjectMgr projectMgr = ProjectMgr.getInstance();
    ArrayList<WebBusinessObject> arrayOfProjects = projectMgr.getProjectWithUserCreated(securityUser.getUserId());
    String timeFormat = "yyyy/MM/dd HH:mm";
    sdf = new SimpleDateFormat(timeFormat);
    String appNowTime = sdf.format(cal.getTime());
    String defaultCampaign = "";
    if (securityUser != null && securityUser.getDefaultCampaign() != null && !securityUser.getDefaultCampaign().isEmpty()) {
        defaultCampaign = securityUser.getDefaultCampaign();
        CampaignMgr campaignMgr = CampaignMgr.getInstance();
        WebBusinessObject campaignWbo = campaignMgr.getOnSingleKey(defaultCampaign);
        if (campaignWbo != null) {
            defaultCampaign = (String) campaignWbo.getAttribute("campaignTitle");
        } else {
            defaultCampaign = "";
        }
    }
    List<WebBusinessObject> callResults = (List<WebBusinessObject>) request.getAttribute("callResults");
    List<WebBusinessObject> meetings = (List<WebBusinessObject>) request.getAttribute("meetings");
    List<WebBusinessObject> userProjects = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKeyOracle("1365240752318", "key2"));
    String stat = "Ar";
    String dir = null;
    String title, beginDate, endDate;
    String complaintNo, customerName, complaint;
    String sat, sun, mon, tue, wed, thu, fri, PN, noResponse, ageComp;
    String complStatus, fullName = null;
    String sDate, sTime = null;
    if (stat.equals("En")) {
        dir = "LTR";
        title = "Complaints Reprot";
        beginDate = "From Date";
        endDate = "To Date";
        complaintNo = "Order No.";
        customerName = "Customer name";
        complaint = "Complaint";
        sat = "Sat";
        sun = "Sun";
        mon = "Mon";
        tue = "Tue";
        wed = "Wed";
        thu = "Thu";
        fri = "Fri";
        noResponse = "&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1578;&#1583;&#1575;&#1608;&#1604;";
        ageComp = "A.C(day)";
        PN = "Requests No.";
    } else {
        dir = "RTL";
        title = "بحث عن عميل جديد بالفرع";
        PN = "عدد الطلبات";
        beginDate = "&#1605;&#1606; &#1578;&#1575;&#1585;&#1610;&#1582;";
        endDate = "&#1575;&#1604;&#1609; &#1578;&#1575;&#1585;&#1610;&#1582;";
        complaintNo = "&#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1578;&#1575;&#1576;&#1593;&#1577;";
        customerName = "&#1575;&#1587;&#1605; &#1575;&#1604;&#1593;&#1605;&#1610;&#1604;";
        complaint = "&#1575;&#1604;&#1591;&#1604;&#1576;";
        sat = "&#1575;&#1604;&#1587;&#1576;&#1578;";
        sun = "&#1575;&#1604;&#1575;&#1581;&#1583;";
        mon = "&#1575;&#1604;&#1575;&#1579;&#1606;&#1610;&#1606;";
        tue = "&#1575;&#1604;&#1579;&#1604;&#1575;&#1579;&#1575;&#1569;";
        wed = "&#1575;&#1604;&#1575;&#1585;&#1576;&#1593;&#1575;&#1569;";
        thu = "&#1575;&#1604;&#1582;&#1605;&#1610;&#1587;";
        fri = "&#1575;&#1604;&#1580;&#1605;&#1593;&#1577;";
        noResponse = "&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1578;&#1583;&#1575;&#1608;&#1604;";
        ageComp = "&#1593;.&#1591; (&#1610;&#1608;&#1605;)";
    }
%>
<html>
    <head>
        <META HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
        <META HTTP-EQUIV="Expires" CONTENT="0"/>   

        <LINK REL="stylesheet" type="text/css" href="css/CSS.css"/>
        <script src='ChangeLang.js' type='text/javascript'></script>
        <script type="text/javascript" src="jquery-ui/jquery-1.6.2.js"></script>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css"/>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.widget.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.drop.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.fold.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.mouse.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.slider.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>
        <script type="text/javascript" src="js/jquery.easing.1.3.js"></script>
        <script type="text/javascript" src="js/wz_tooltip.js"></script>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery-ui-timepicker-addon.css"/>

        <SCRIPT LANGUAGE="JavaScript" type="text/javascript">
            function assignClientComplaintToProject() {
                var projectId = $("#toFolder").val();
                var clientComplaintIds = $("#moveTo:checked").map(function() {
                    return $(this).val();
                }).get();
                if (clientComplaintIds == '') {
                    $('#saveToFileMsg').html('Please select at least one request.');
                    return;
                }
                $.ajax({
                    type: 'POST',
                    url: "<%=context%>/ProjectServlet?op=addClientComplaintIntoProject",
                    data: {clientComplaintIds: clientComplaintIds.join(","), projectId: projectId},
                    success: function(data) {
                        var jsonString = $.parseJSON(data);
                        if (jsonString.status === 'ok') {
                            $('#saveToFileMsg').html('Save To Folder Done');
                        } else if (jsonString.status === 'failed') {
                            $('#saveToFileMsg').html('Problem at Saving To Folder , Please Contact Administrator');
                        }
                    }
                });
            }
            $(function() {
                $("#beginDate, #endDate").datetimepicker({
                    changeMonth: true,
                    changeYear: true,
                    maxDate: 0,
                    dateFormat: "yy/mm/dd",
                    timeFormat: "HH:mm"
                });
            });
            $(document).ready(function() {
                $('#indextable').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[20, 40, 70, 100, -1], [20, 40, 70, 100, "All"]],
                    iDisplayLength: 20,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true,
                    "aaSorting": [[0, "asc"]]
                }).show();
                $(".dataTables_length, .dataTables_info").css("float", "left");
                $(".dataTables_filter, .dataTables_paginate").css("float", "right");
            });
            var minDateS = '<%=appNowTime%>';
            $(function() {
                $("#meetingDate").datetimepicker({
                    changeMonth: true,
                    changeYear: true,
                    minDate: new Date(minDateS),
                    maxDate: '<%=a%>' + '/' + '<%=b + 1%>' + '/' + '<%=d%>',
                    dateFormat: "yy/mm/dd",
                    timeFormat: "HH:mm:ss"
                });
            });
            function getComplaints() {
                var beginDate = $("#beginDate").val();
                var endDate = $("#endDate").val();
                var senderID = $("#senderID").val();
                var branchID = $("#branchID").val();
                if ((beginDate == null || beginDate == "")) {
                    alert("من فضلك أدخل تاريخ البداية");
                }
                else if ((endDate == null || endDate == "")) {
                    alert("من فضلك أدخل تاريخ النهاية");

                } else {
                    document.COMP_FORM.action = "<%=context%>/SearchServlet?op=searchNewClientsByBranch&beginDate=" + beginDate + "&endDate=" + endDate + "&senderID=" + senderID + "&branchID=" + branchID;
                    document.COMP_FORM.submit();
                }
            }
            function popupAddComment(obj, clientId) {
                $("#clientId").val(clientId);
                $("#commentAreaForSave").val("");
                $("#commentType").val("0")
                $("#commMsg").hide();
                $('#add_comments').css("display", "block");
                $('#add_comments').bPopup({easing: 'easeInOutSine',
                    speed: 400,
                    transition: 'slideDown'});
            }
            function saveComment(obj) {
                var clientId = $("#clientId").val();
                var type = $("#commentType").val();
                var comment = $("#commentAreaForSave").val();
                var businessObjectType = $(obj).parent().parent().parent().find($("#businessObjectType")).val();
                $(obj).parent().parent().parent().parent().find("#progress").show();
                $.ajax({
                    type: "post",
                    url: "<%=context%>/CommentsServlet?op=saveComment",
                    data: {
                        clientId: clientId,
                        type: type,
                        comment: comment,
                        businessObjectType: businessObjectType
                    }
                    ,
                    success: function(jsonString) {
                        var eqpEmpInfo = $.parseJSON(jsonString);
                        if (eqpEmpInfo.status == 'ok') {
                            $(obj).parent().parent().parent().parent().find("#commMsg").show();
                            $(obj).parent().parent().parent().parent().find("#progress").hide();
                            $('#comment' + clientId).html(parseInt($('#comment' + clientId).html()) + 1);
                            $('#add_comments').css("display", "none");
                            $('#add_comments').bPopup().close();
                        } else if (eqpEmpInfo.status == 'no') {
                            $(obj).parent().parent().parent().parent().find("#progress").show();
                        }
                    }
                });
            }
            function closePopup(obj) {
                $(obj).parent().parent().bPopup().close();
            }
            function popupFollowUp(clientId) {
                $("#clientId").val(clientId);
                $("#appTitleMsg").css("color", "");
                $("#appTitleMsg").text("");
                $("#appTitle").val("");
                $("#comment").val("");
                $("#appMsg").hide();
                $(".submenu1").hide();
                $("#appClientName").text($("#hideName").val());
                $(".button_pointment").attr('id', '0');
                $('#follow_up_content').css("display", "block");
                $('#follow_up_content').bPopup({easing: 'easeInOutSine', //uses jQuery easing plugin
                    speed: 400,
                    transition: 'slideDown'});
            }
            function saveFollowUp(obj) {
                $("#appTitleMsg").css("color", "");
                $("#appTitleMsg").text("");
                var clientId = $("#clientId").val();
                var title = '';
                if ($(obj).parent().parent().parent().find($("#appTitle")).val() !== null) {
                    title = $(obj).parent().parent().parent().find($("#appTitle")).val();
                }
                var callResult = $(obj).parent().parent().parent().find($("#callResult:checked")).val();
                var resultValue = "";
                var appCallResult = $(obj).parent().parent().parent().find($("#appCallResult")).val();
                var meetingDate = $(obj).parent().parent().parent().find($("#meetingDate")).val();
                if (callResult === '<%=CRMConstants.CALL_RESULT_CALL%>') {
                    resultValue = appCallResult;
                } else if (callResult === '<%=CRMConstants.CALL_RESULT_MEETING%>') {
                    resultValue = meetingDate;
                }
                var appType = '<%=CRMConstants.CALL_RESULT_FOLLOWUP%>';
                var appointmentPlace = $(obj).parent().parent().parent().find("#appointmentPlace").val();
                var comment = $(obj).parent().parent().parent().find("#comment").val();
                var note = '<%=CRMConstants.CALL_RESULT_FOLLOWUP.toUpperCase()%>';
                if (title.length > 0) {
                    $(obj).parent().parent().parent().parent().find("#progress").show();
                    $.ajax({
                        type: "post",
                        url: "<%=context%>/ClientServlet?op=saveFollowUpAppointment",
                        data: {
                            clientId: clientId,
                            title: title,
                            callResult: callResult,
                            resultValue: resultValue,
                            note: note,
                            appType: appType,
                            appointmentPlace: appointmentPlace,
                            comment: comment
                        },
                        success: function(jsonString) {
                            var eqpEmpInfo = $.parseJSON(jsonString);
                            if (eqpEmpInfo.status == 'ok') {
                                $(obj).parent().parent().parent().parent().find("#progress").hide();
                                $('#appointment' + clientId).html(parseInt($('#appointment' + clientId).html()) + 1);
                                $('#follow_up_content').css("display", "none");
                                $('#follow_up_content').bPopup().close();
                            } else if (eqpEmpInfo.status == 'no') {
                                $(obj).parent().parent().parent().parent().find("#progress").show();
                                $(obj).parent().parent().parent().parent().find("#appMsg").html("لم يتم التسجيل او هذا العميل غير موزع").show();
                            }
                        }
                    });
                } else {
                    $("#appTitleMsg").css("color", "white");
                    $("#appTitleMsg").text("أدخل عنوان المقابلة");
                }
            }
            function switchValue(displaied, hidded) {
                $("#" + displaied).css("display", "block");
                $("#" + hidded).css("display", "none");
            }
            function popupShowComments(clientId) {
                var url = "<%=context%>/CommentsServlet?op=showComments&clientId=" + clientId + "&objectType=1&random=" + (new Date()).getTime();
                jQuery('#show_comments').load(url);
                $('#show_comments').css("display", "block");
                $('#show_comments').bPopup({easing: 'easeInOutSine', //uses jQuery easing plugin
                    speed: 400,
                    transition: 'slideDown'});

            }
            function popupShowAppointment(clientId) {
                var url = "<%=context%>/AppointmentServlet?op=showClientAppointment&clientId=" + clientId + "&cach=" + (new Date()).getTime();
                $('#show_appointment').load(url);
                $('#show_appointment').css("display", "block");
                $('#show_appointment').bPopup({easing: 'easeInOutSine', //uses jQuery easing plugin
                    speed: 400,
                    transition: 'slideDown'});
            }
        </script>
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
            .titleRow {
                background-color: orange;
            }
            .login  h1 {
                font-size: 16px;
                font-weight: bold;
                padding-top: 10px;
                padding-bottom: 10px;
                text-shadow: 0 -1px rgba(0, 0, 0, 0.4);
                text-align: center;
                width: 96%;
                margin-left: auto;
                margin-right: auto;
                text-height: 30px;
                color: black;
                text-shadow: 0 1px rgba(255, 255, 255, 0.3);
                background: #FFBB00;
                /*background: #cc0000;*/
                background-clip: padding-box;
                border: 1px solid #284473;
                border-bottom-color: #223b66;
                border-radius: 4px;
                cursor: pointer;
            }
            .num{background: #ffc578; /* Old browsers */
                 background: -moz-linear-gradient(top,  #ffc578 0%, #fb9d23 100%); /* FF3.6+ */
                 background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#ffc578), color-stop(100%,#fb9d23)); /* Chrome,Safari4+ */
                 background: -webkit-linear-gradient(top,  #ffc578 0%,#fb9d23 100%); /* Chrome10+,Safari5.1+ */
                 background: -o-linear-gradient(top,  #ffc578 0%,#fb9d23 100%); /* Opera 11.10+ */
                 background: -ms-linear-gradient(top,  #ffc578 0%,#fb9d23 100%); /* IE10+ */
                 background: linear-gradient(to bottom,  #ffc578 0%,#fb9d23 100%); /* W3C */
                 filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#ffc578', endColorstr='#fb9d23',GradientType=0 ); /* IE6-9 */
                 font-weight: bold
            }
        </style>
    </head>
    <body>
        <form NAME="COMP_FORM" METHOD="POST">
            <table align="center" width="80%">
                <tr>
                    <td class="td">
                        <fieldset >
                            <legend align="center">
                                <table dir="rtl" align="center">
                                    <tr>
                                        <td class="td">
                                            <font color="blue" size="6"> <%=title%>
                                            </font>
                                        </td>
                                    </tr>
                                </table>
                            </legend>
                            <table align="center" dir="rtl" width="570" cellspacing="2" cellpadding="1">
                                <tr>
                                    <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="50%">
                                        <b><font size=3 color="white"> <%=beginDate%></b>
                                    </td>
                                    <td   class="blueBorder blueHeaderTD" style="font-size:18px;"width="50%">
                                        <b> <font size=3 color="white"> <%=endDate%> </b>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align:center" bgcolor="#dedede"  valign="MIDDLE" >
                                        <%
                                            Calendar c = Calendar.getInstance();
                                        %>
                                        <% if (beDate != null && !beDate.isEmpty()) {%>

                                        <input id="beginDate" name="beginDate" type="text" value="<%=beDate%>" readonly /><img src="images/showcalendar.gif" > 
                                        <%} else {%>
                                        <input id="beginDate" name="beginDate" type="text" value="<%=prev%>" readonly /><img src="images/showcalendar.gif" > 
                                        <%}%>
                                        <br><br>
                                    </td>
                                    <td bgcolor="#dedede" style="text-align:center" valign="middle">
                                        <% if (eDate != null && !eDate.isEmpty()) {%>
                                        <input id="endDate" name="endDate" type="text" value="<%=eDate%>" readonly /><img src="images/showcalendar.gif" > 
                                        <%} else {%>
                                        <input id="endDate" name="endDate" type="text" value="<%=nowTime%>" readonly /><img src="images/showcalendar.gif" > 
                                        <%}%>
                                        <br><br>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="50%">
                                        <b><font size=3 color="white">الموزع</b>
                                    </td>
                                    <td   class="blueBorder blueHeaderTD" style="font-size:18px;"width="50%">
                                        <b> <font size=3 color="white">الفرع</b>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align:center" bgcolor="#dedede"  valign="MIDDLE" >
                                        <select style="font-size: 14px;font-weight: bold;" id="senderID" >
                                            <option value="">الكل</option>
                                            <sw:WBOOptionList wboList='<%=usersList%>' displayAttribute = "fullName" valueAttribute="userId" scrollToValue="<%=senderID%>"/>
                                        </select>
                                        <br/><br/>
                                    </td>
                                    <td bgcolor="#dedede" style="text-align:center" valign="middle">
                                        <select style="font-size: 14px;font-weight: bold;" id="branchID" >
                                            <option value="none">غير محدد</option>
                                            <sw:WBOOptionList wboList='<%=branchesList%>' displayAttribute = "projectName" valueAttribute="projectID" scrollToValue="<%=branchID%>"/>
                                        </select>
                                        <br/><br/>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align:center" class="td" colspan="3">
                                        <br/><br/>
                                        <button  onclick="JavaScript: getComplaints();" style="color: #000;font-size:15;margin-top: 20px;font-weight:bold; ">بحث<IMG HEIGHT="15" SRC="images/search.gif" ></button>  
                                    </td>
                                </tr>
                            </table>
                        </fieldset>
                </tr></td ></table>
        </form>
        <% if (data != null && !data.isEmpty()) {%>
        <table align="center" dir="rtl" width="600" cellspacing="2" cellpadding="1">
            <tr>
                <td class="td" nowrap>
                    <b style="font-size: medium;">حفظ فى ملف </b>
                </td>
                <td class="td">
                    <select name="toFolder" id="toFolder" style="width:180px; font-size: medium; font-weight: bold;">
                        <%for (int i = 0; i < arrayOfProjects.size(); i++) {
                                WebBusinessObject mFolderWbo = (WebBusinessObject) arrayOfProjects.get(i);
                        %>
                        <OPTION value="<%=(String) mFolderWbo.getAttribute("projectID")%>"><%=(String) mFolderWbo.getAttribute("projectName")%></OPTION>
                            <%}%>
                    </select>
                    &nbsp;
                    <input type="button" onclick="assignClientComplaintToProject()" class="button" value="Save into Folder"
                           style="width: 180px; background: url(images/tree_folder.gif) no-repeat 5px center;"></input>
                    <label id="saveToFileMsg"></label>
                </td>
            </tr>
        </table>
    <center> <b> <font size="3" color="red"> <%=PN%> : <%=data.size()%> </font></b></center> 
    <table class="display" id="indextable" align="center" dir="<%=dir%>" width="100%" cellpadding="0" cellspacing="0">
        <thead>
            <tr>
                <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="4%"><b>#</b></th>
                <th ><input type="checkbox" id="ToggleTo" name="ToggleTo"></th>                
                <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="10%"><img src="images/icons/Numbers.png" width="20" height="20" /><b> <%=complaintNo%></b></th>
                <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="10%"><img src="images/icons/client.png" width="20" height="20" /><b> <%=customerName%></b></th>
                <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="1%">&nbsp;</th>
                <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="7%"><b>رقم التليفون</b></th>
                <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="7%"><b>الموبايل</b></th>
                <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="7%"><b>الرقم الطالب</b></th>
                <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="7%"><b>الرقم الدولي</b></th>
                <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="8%"><b>المصدر</b></th>
                <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="8%"><b>المرسل</b></th>
                <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="10%"><b>الحاله</b></th>
                <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="10%"><b>تاريخ الطلب</b></th>
                <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="10%"><b>المسئول</b></th>
                <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="10%"><b><%=ageComp%></b></th>
            </tr>
        </thead> 
        <tbody  id="planetData2">  
            <%
                String compStyle = "";
                String clientDescription;
                for (WebBusinessObject wbo : data) {
                    iTotal++;
                    WebBusinessObject senderInf = null;
                    UserMgr userMgr = UserMgr.getInstance();
                    senderInf = userMgr.getOnSingleKey(wbo.getAttribute("senderId").toString());
                    WebBusinessObject clientCompWbo = null;
                    String compType = "";
                    ClientComplaintsMgr clientComplaintsMgr = ClientComplaintsMgr.getInstance();
                    clientCompWbo = clientComplaintsMgr.getOnSingleKey(wbo.getAttribute("clientComId").toString());
                    if (clientCompWbo.getAttribute("ticketType").toString().equals("1")) {
                        compType = "شكوى";
                        compStyle = "comp";
                    } else if (clientCompWbo.getAttribute("ticketType").toString().equals("2")) {
                        compType = "طلب";
                        compStyle = "order";
                    } else if (clientCompWbo.getAttribute("ticketType").toString().equals("3")) {
                        compType = "استعلام";
                        compStyle = "query";
                    }
                    clientDescription = (String) wbo.getAttribute("description");
                    if (clientDescription == null || clientDescription.equalsIgnoreCase("UL")) {
                        clientDescription = "";
                    }
            %>
            <tr style="padding: 1px;">
                <td>
                    <%=iTotal%>
                </td>
                <td>
                    <input type="checkbox" id="moveTo" name="moveTo" value="<%=wbo.getAttribute("clientComId")%>">
                </td>
                <td style="cursor: pointer" onmouseover="this.className = '<%=compStyle%>'" onmouseout="this.className = ''">
                    <%if (wbo.getAttribute("issue_id") != null) {%>
                    <a href="<%=context%>/IssueServlet?op=getCompl3&issueId=<%=wbo.getAttribute("issue_id")%>&compId=<%=wbo.getAttribute("clientComId")%>&statusCode=<%=wbo.getAttribute("statusCode")%>&receipId=<%=wbo.getAttribute("receipId")%>&senderID=<%=wbo.getAttribute("senderId")%>"> <font color="red"><%=wbo.getAttribute("businessID").toString()%></font><font color="blue">/<%=wbo.getAttribute("businessIDbyDate").toString()%></font>
                    </a>
                    <%}
                    %>
                </td>
                <td>
                    <%if (wbo.getAttribute("customerName") != null) {%>
                    <b title="<%=clientDescription%>" style="cursor: hand"><%=wbo.getAttribute("customerName")%></b>
                    <%}%>
                </td>
                <td>
                    <img src="images/comment_no.png" title="أضافة تعليق" onclick="JavaScript: popupAddComment(this, '<%=wbo.getAttribute("customerId")%>')" height="25" style="cursor: hand;"/>
                    <img src="images/user_appointments.png" title="أضافة متابعة" onclick="JavaScript: popupFollowUp('<%=wbo.getAttribute("customerId")%>')" height="20" style="cursor: hand;"/>
                    <div style="float: left; width: 35px;height: 20px;border-radius: 3px 3px 3px 3px;text-align: center;" class="num">
                        <a href="JavaScript: popupShowComments('<%=wbo.getAttribute("customerId")%>');">
                            <b title="عدد التعليقات" style="color: blue;" id="comment<%=wbo.getAttribute("customerId")%>">
                                <%=wbo.getAttribute("totalComments") != null ? wbo.getAttribute("totalComments") : "0"%>
                            </b>
                        </a>
                        &nbsp;
                        <a href="JavaScript: popupShowAppointment('<%=wbo.getAttribute("customerId")%>');">
                            <b title="عدد المتابعات" style="color: red;" id="appointment<%=wbo.getAttribute("customerId")%>">
                                <%=wbo.getAttribute("totalAppointments") != null ? wbo.getAttribute("totalAppointments") : "0"%>
                            </b>
                        </a>
                        &nbsp;
                    </div>
                </td>
                <td>
                    <%if (wbo.getAttribute("clientPhone") != null && !((String) wbo.getAttribute("clientPhone")).equalsIgnoreCase("UL")) {%>
                    <b><%=wbo.getAttribute("clientPhone")%></b>
                    <%}%>
                </td>
                <td>
                    <%if (wbo.getAttribute("clientMobile") != null && !((String) wbo.getAttribute("clientMobile")).equalsIgnoreCase("UL")) {%>
                    <b><%=wbo.getAttribute("clientMobile")%></b>
                    <%}%>
                </td>
                <td>
                    <%if (wbo.getAttribute("otherPhone") != null && !((String) wbo.getAttribute("otherPhone")).equalsIgnoreCase("UL")) {%>
                    <b><%=wbo.getAttribute("otherPhone")%></b>
                    <%}%>
                </td>
                <td>
                    <%if (wbo.getAttribute("interPhone") != null) {%>
                    <b><%=wbo.getAttribute("interPhone")%></b>
                    <%}%>
                </td>
                <td>
                    <%if (wbo.getAttribute("createdByName") != null) {%>
                    <b><%=wbo.getAttribute("createdByName")%></b>
                    <%}%>
                </td>
                <td>
                    <%if (wbo.getAttribute("senderFullName") != null) {%>
                    <b><%=wbo.getAttribute("senderFullName")%></b>
                    <%}%>
                </td>
                <% if (stat.equals("En")) {
                        complStatus = (String) wbo.getAttribute("statusEnName");
                    } else {
                        complStatus = (String) wbo.getAttribute("statusArName");
                    }
                %>
                <td><b><%=complStatus%></b></td>
                        <%  c = Calendar.getInstance();
                            DateFormat formatter;
                            formatter = new SimpleDateFormat("dd/MM/yyyy");
                            String[] arrDate = wbo.getAttribute("entryDate").toString().split(" ");
                            Date date = new Date();
                            sDate = arrDate[0];
                            sTime = arrDate[1];
                            String[] arrTime = sTime.split(":");
                            sTime = arrTime[0] + ":" + arrTime[1];
                            sDate = sDate.replace("-", "/");
                            arrDate = sDate.split("/");
                            sDate = arrDate[2] + "/" + arrDate[1] + "/" + arrDate[0];
                            c.setTime((Date) formatter.parse(sDate));
                            int dayOfWeek = c.get(Calendar.DAY_OF_WEEK);
                            String currentDate = formatter.format(date);
                            String sDay = null;
                            if (dayOfWeek == 7) {
                                sDay = sat;
                            } else if (dayOfWeek == 1) {
                                sDay = sun;
                            } else if (dayOfWeek == 2) {
                                sDay = mon;
                            } else if (dayOfWeek == 3) {
                                sDay = tue;
                            } else if (dayOfWeek == 4) {
                                sDay = wed;
                            } else if (dayOfWeek == 5) {
                                sDay = thu;
                            } else if (dayOfWeek == 6) {
                                sDay = fri;
                            }
                        %>
                        <%if (currentDate.equals(sDate)) {%>
                <td nowrap  ><font color="red">Today - </font><b><%=sTime%></b></td>
                        <%} else {%>
                <td nowrap  ><font color="red"><%=sDay%> - </font><b><%=sDate + " " + sTime%></b></td>
                        <%}%>
                        <% if (wbo.getAttribute("currentOwner") != null && !wbo.getAttribute("currentOwner").equals("")) {
                                fullName = (String) wbo.getAttribute("currentOwner");
                            } else {
                                fullName = "";
                            }
                        %>
                <td style="width: 10%;"  ><b><%=fullName%></b></td>
                <td>
                    <%
                        try {
                            out.write("<b>" + DateAndTimeControl.getDelayTime(wbo.getAttribute("entryDate").toString(), "Ar") + "</b>");
                        } catch (Exception E) {
                            out.write("<b>" + noResponse + "</b>");
                        }
                    %>
                </td>
            </tr>
            <%
                }
            } else if (data != null && data.isEmpty()) {
            %>
        <b style="color: red; font-size: x-large;">لا يوجد نتائج للبحث</b>
        <%
            }
        %>
    </tbody>
</table>
<div id="add_comments"  style="width: 30% ;margin-right: auto ;margin-left: auto;display: none;position: fixed;top: 0%;"><!--class="popup_appointment" -->
    <div style="clear: both;margin-left: 88%;margin-bottom: -38px;z-index: -10000000;">
        <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
             -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
             box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
             -webkit-border-radius: 100px;
             -moz-border-radius: 100px;
             border-radius: 100px;" onclick="closePopup(this)"/>
    </div>
    <div class="login" style="width: 85%;margin-bottom: 10px;margin-left: auto;margin-right: auto;">
        <table  border="0px"  style="width:100%;"  class="table">
            <%
                if (metaMgr.getShowCommentType().equalsIgnoreCase("1")) {
            %>
            <tr>
                <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 30%;">نوع التعليق</td>
                <td style="width: 70%;" >
                    <select style="float: right;width: 30%; font-size: 14px;" id="commentType">
                        <option value="0">عام</option>
                        <option value="1">خاص</option>
                    </select>
                    <input type="hidden" id="businessObjectType" value="1"/>
                </td>

            </tr>
            <%
            } else {
            %>
            <input type="hidden" id="commentType" name="commentType" value="0"/>
            <input type="hidden" id="businessObjectType" value="1"/>
            <%
                }
            %>
            <tr>
                <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 30%;">التعليق</td>
                <td style="width: 70%;" >
                    <textarea  placeholder="" style="width: 100%;height: 80px;" id="commentAreaForSave" name="commentAreaForSave" > </textarea>
                </td>
            </tr> 
        </table>
        <div style="text-align: center;margin-left: auto;margin-right: auto;clear: both" > 
            <input type="button" value="حفظ"   onclick="saveComment(this)" id="saveComm"class="login-submit"/></div>                             </form>
        <div id="progress" style="display: none;">
            <img src="images/Loading2.gif" width="32px" height="32px;" style="background-repeat: no-repeat;margin-left: auto;margin-right: auto"/>
        </div>
        <div style="margin: 0 auto;display: none; width: 90%;text-align: center;color: white;font-size: 16px;font-weight: bold" id="commMsg">
            تم إضافة التعليق
        </div>
    </div>  
</div>
<div id="follow_up_content" style="width: 70% !important;display: none;position: fixed">
    <div style="clear: both;margin-left: 95%;margin-top: 0px;margin-bottom: -38px;z-index: -10000000;">
        <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
             -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
             box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
             -webkit-border-radius: 100px;
             -moz-border-radius: 100px;
             border-radius: 100px;" onclick="closePopup(this)"/>
    </div>
    <div class="login" style="width: 95%;margin-bottom: 10px;margin-left: auto;margin-right: auto;">
        <h1 align="center" style="vertical-align: middle">متابعة العميل <b id="appClientName" style="font-weight: bold; font-size: 20px"></b> &nbsp;&nbsp;&nbsp;<img src="images/dialogs/phone.png" alt="phone" width="24px"/></h1>
        <table class="table " style="width:100%;">
            <tr style="display: <%=!defaultCampaign.isEmpty() ? "" : "none"%>">
                <td width="20%" style="color:#f1f1f1; font-size: 16px;font-weight: bold">
                    &nbsp;
                </td>
                <td width="20%" style="color:#f1f1f1; font-size: 16px;font-weight: bold">
                    &nbsp;
                </td>
                <td width="60%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;">
                    <table style="float: left;">
                        <tr>
                            <td style="font-size: 16px;font-weight: bold;">
                                <%=defaultCampaign%>
                            </td>
                            <td style="color:#f1f1f1; font-size: 16px;font-weight: bold;">
                                : 
                            </td>
                            <td style="color:#f1f1f1; font-size: 16px;font-weight: bold;">
                                Active Campaign  
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold">الهدف : </td>
                <td width="15%" style="text-align:right">
                    <select id="appTitle" name="appTitle" STYLE="width: 100%;font-size: medium; font-weight: bold;">
                        <sw:WBOOptionList wboList='<%=meetings%>' displayAttribute = "projectName" valueAttribute="projectName" />
                    </select>
                </td>
                <td style="text-align:right;">
                    <label id="appTitleMsg"></label>
                </td>
            </tr>
            <tr>
                <td width="10%" rowspan="3" style="color:#f1f1f1; font-size: 16px;font-weight: bold">النتيجة:  </td>
                <td style="text-align:right">
                    <input type="radio" id="callResult" name="callResult" value="<%=CRMConstants.CALL_RESULT_MEETING%>" checked onchange="JavaScript: switchValue('meetingDate', 'appCallResult');"/>
                    <label><img src="images/icons/meeting.png" alt="meeting" width="24px"/> مقابلة</label>
                </td>
                <td style="text-align:right">
                    <input name="meetingDate" id="meetingDate" type="text" size="50" maxlength="50" style="width:40%;font-size: medium" value="<%=appNowTime%>"/>
                </td>
            </tr>
            <tr>
                <td style="text-align:right" width="15%">
                    <input type="radio" id="callResult" name="callResult" value="<%=CRMConstants.CALL_RESULT_CALL%>" onchange="JavaScript: switchValue('appCallResult', 'meetingDate');"/>
                    <label><img src="images/icons/call.png" alt="phone" width="24px"/>مكالمة </label>
                </td>
                <td style="text-align:right" width="75%">
                    <select id="appCallResult" name="appCallResult" STYLE="font-size: medium; font-weight: bold; width: 40%; display: none">
                        <sw:WBOOptionList wboList='<%=callResults%>' displayAttribute = "projectName" valueAttribute="projectID" />
                    </select>
                </td>
            </tr>
            <tr>
                <td style="text-align:right" width="25%">
                    <input type="radio" id="callResult" name="callResult" value="<%=CRMConstants.CALL_RESULT_FAIL%>" />
                    <label><img src="images/icons/call_failed.png" alt="phone" width="24px"/>لايوجد رد</label>
                </td>
                <td style="text-align:right;">
                    &ensp;
                </td>
            </tr>
            <tr>
                <td style="color:#f1f1f1; font-size: 16px; font-weight: bold;">الفرع : </td>
                <td style="text-align:right;">
                    <select id="appointmentPlace" name="appointmentPlace" style="margin-top: 7px;width:200px;font-size: medium;">
                        <sw:WBOOptionList wboList='<%=userProjects%>' displayAttribute = "projectName" valueAttribute="projectName" />
                        <option value="Other">Other</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td style="color:#f1f1f1; font-size: 16px;font-weight: bold">تعليق : </td>
                <td colspan="2" style="text-align:right">
                    <textarea cols="26" rows="10" id="comment" style="width: 99%; background-color: #FFF7D6;"></textarea>
                </td>
            </tr>
        </table>
        <div style="text-align: left;margin-left: 2%;margin-right: auto;" > 
            <button type="button" onclick="javascript: saveFollowUp(this);" style="font-size: 14px; font-weight: bold; width: 150px">حفظ<img style="height:20px; width: 20px" src="images/icons/follow_up.png" title="Follow up"/></button>
        </div>
        <div id="progress" style="display: none;">
            <img src="images/Loading2.gif" width="32px" height="32px;" style="background-repeat: no-repeat;margin-left: auto;margin-right: auto"/>
        </div>
        <div style="margin: 0 auto;display: none; width: 90%;text-align: center;color: white;font-size: 16px;font-weight: bold" id="appMsg">تم إضافة المقابلة </div>
    </div>  
</div>
<div id="show_comments"   style="width: 50% !important;display: none;position: fixed ;">

</div>
<div id="show_appointment"  style="width: 97% !important;display: none;margin-left: auto;margin-right: auto;text-align: center;position: fixed ;">

</div>
<input type="hidden" id="clientId" value="1"/>
</body>
</html>     
