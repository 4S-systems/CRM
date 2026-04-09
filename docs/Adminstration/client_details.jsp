<%@page import="com.clients.db_access.ClientProductMgr"%>
<%@page import="com.silkworm.common.UserGroupMgr"%>
<%@page import="com.silkworm.db_access.PersistentSessionMgr"%>
<%@page import="com.android.business_objects.LiteWebBusinessObject"%>
<%@page import="com.maintenance.db_access.IssueByComplaintUniqueMgr"%>
<%@page import="com.silkworm.common.ApplicationSessionRegistery"%>
<%@page import="com.clients.db_access.ClientRatingMgr"%>
<%@page import="com.maintenance.db_access.GroupPrevMgr"%>
<%@page import="com.maintenance.db_access.GroupPrevMgr"%>
<%@page import="com.tracker.db_access.CampaignMgr"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="com.crm.common.CRMConstants"%>
<%@page import="com.silkworm.common.SecurityUser"%>
<%@page import="java.util.List"%>
<%@page import="com.silkworm.common.UserMgr"%> 
<%@page import="com.clients.db_access.ClientMgr"%>
<%@page import="com.silkworm.common.BookmarkMgr"%>
<%@page import="com.maintenance.db_access.TradeMgr"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="java.util.ArrayList"%>
<%@ page import="com.silkworm.business_objects.WebBusinessObject,java.util.Vector,com.tracker.db_access.ProjectMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld"%> 

<%@ page pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/tr/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html>
    <c:set var="loc" value="en"/>
    <c:if test="${!(empty sessionScope.currentMode)}">
        <c:set var="loc" value="${sessionScope.currentMode}"/>
    </c:if>
    <fmt:setLocale value="${loc}"  />
    <fmt:setBundle basename="Languages.Client.client"  />

    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();

        String context = metaMgr.getContext();
        SecurityUser securityUser = (SecurityUser) request.getSession().getAttribute("securityUser");

        session = request.getSession();
        String remoteAccess = session.getId();
        WebBusinessObject persistentUser = (WebBusinessObject) PersistentSessionMgr.getInstance().getOnSingleKey(remoteAccess);
        String userID = persistentUser.getAttribute("userId").toString();
        UserMgr userMgr = UserMgr.getInstance();
        String ufullName = userMgr.getFullName(userID);
        UserGroupMgr userGroupMgr = UserGroupMgr.getInstance();
        Vector showCommPrv = userGroupMgr.getOnArbitraryDoubleKey("1363766204934", "key7", userID, "key6");
        boolean privilege = showCommPrv.size() > 0;
        ArrayList<WebBusinessObject> prvType = new ArrayList();
        prvType = securityUser.getComplaintMenuBtn();
        ArrayList<String> privilegesList = new ArrayList<String>();
        for (WebBusinessObject wboTemp : prvType) {
            if (wboTemp != null && wboTemp.getAttribute("prevCode") != null) {
                privilegesList.add((String) wboTemp.getAttribute("prevCode"));
            }
        }
        String interests = "";
        ArrayList<WebBusinessObject> intersLst = (ArrayList<WebBusinessObject>) request.getAttribute("intersLst");
        ArrayList<WebBusinessObject> ratesList = new ArrayList<>();
        ProjectMgr projectMgr = ProjectMgr.getInstance();
        ratesList = new ArrayList<>(projectMgr.getOnArbitraryKeyOracle("CL-RATE", "key6"));
        WebBusinessObject clientWbo = (WebBusinessObject) request.getAttribute("clientWbo");
        WebBusinessObject ownerUserWbo = (WebBusinessObject) request.getAttribute("ownerUserWbo");
        WebBusinessObject loggerWbo = (WebBusinessObject) request.getAttribute("loggerWbo");
        WebBusinessObject lockWbo = (WebBusinessObject) request.getAttribute("lockWbo");
        String showHeader = (String) request.getAttribute("showHeader");
        String button = (String) request.getAttribute("button");
        ArrayList<WebBusinessObject> clientsRecommendedList = (ArrayList<WebBusinessObject>) request.getAttribute("clientsRecommendedList");
        ArrayList<WebBusinessObject> campaignsList = (ArrayList<WebBusinessObject>) request.getAttribute("campaignsList");
        ArrayList<WebBusinessObject> typeWifi = (ArrayList<WebBusinessObject>) ClientMgr.getInstance().getTypeWifi();
        ArrayList<WebBusinessObject> clientCampaignsList = (ArrayList<WebBusinessObject>) request.getAttribute("clientCampaignsList");
        ArrayList<WebBusinessObject> questionsList = (ArrayList<WebBusinessObject>) request.getAttribute("questionsList");
        ArrayList<LiteWebBusinessObject> clientSurveyList = (ArrayList<LiteWebBusinessObject>) request.getAttribute("clientSurveyList");
        ArrayList<LiteWebBusinessObject> usersList = (ArrayList<LiteWebBusinessObject>) request.getAttribute("usersList");
        Integer reservedUnitsNo = (Integer) request.getAttribute("reservedUnitsNo");
        List<WebBusinessObject> callResults = (List<WebBusinessObject>) request.getAttribute("callResults");
        List<WebBusinessObject> meetings = (List<WebBusinessObject>) request.getAttribute("meetings");
        boolean isRecommend = false;
        if (clientsRecommendedList != null && clientsRecommendedList.size() > 0) {
            isRecommend = true;
        }

        boolean hasReservation = false;
        if (reservedUnitsNo != null && reservedUnitsNo.intValue() > 0) {
            hasReservation = true;
        }

        ClientRatingMgr clientRatingMgr = ClientRatingMgr.getInstance();
        WebBusinessObject clientRateWbo = clientRatingMgr.getOnSingleKey("key1", (String) clientWbo.getAttribute("id"));
        WebBusinessObject rateTempWbo = null;
        if (clientRateWbo != null) {
            rateTempWbo = projectMgr.getOnSingleKey((String) clientRateWbo.getAttribute("rateID"));
        }

        ArrayList<WebBusinessObject> emailsList = (ArrayList<WebBusinessObject>) request.getAttribute("emailsList");
        ArrayList<WebBusinessObject> phonesList = (ArrayList<WebBusinessObject>) request.getAttribute("phonesList");

        Calendar calendar = Calendar.getInstance();
        String timeFormat = "yyyy/MM/dd HH:mm";
        SimpleDateFormat sdf = new SimpleDateFormat(timeFormat);
        calendar.add(Calendar.HOUR, 1);
        String nowTime = sdf.format(calendar.getTime());

        String timeFormat1 = "yyyy/MM/dd";
        SimpleDateFormat sdf1 = new SimpleDateFormat(timeFormat1);
        calendar.add(Calendar.HOUR, 1);
        String nowTime1 = sdf1.format(calendar.getTime());
        calendar.add(Calendar.YEAR, 1);
        int currentDay = calendar.get(Calendar.DAY_OF_MONTH);
        int currentYear = calendar.get(Calendar.YEAR);
        int currentMonth = calendar.get(Calendar.MONTH);

        WebBusinessObject userWbo = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
        BookmarkMgr bookmarkMgr = BookmarkMgr.getInstance();
        Vector bookmarksList = new Vector();
        String bookmarkId = "";
        String bookmarkDetails = "";
        String writeMsg, Send, Sent, sendsmsT, confirm;
        if (clientWbo != null) {
            bookmarksList = bookmarkMgr.getOnArbitraryDoubleKeyOracle((String) clientWbo.getAttribute("id"), "key1", (String) userWbo.getAttribute("userId"), "key2");
        }

        if (bookmarksList != null && bookmarksList.size() > 0) {
            bookmarkId = (String) ((WebBusinessObject) bookmarksList.get(0)).getAttribute("bookmarkId");
            bookmarkDetails = (String) ((WebBusinessObject) bookmarksList.get(0)).getAttribute("bookmarkText");
        }

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

        GroupPrevMgr groupPrevMgr = GroupPrevMgr.getInstance();
        Vector groupPrev = groupPrev = groupPrevMgr.getOnArbitraryKey(userWbo.getAttribute("groupID").toString(), "key1");
        ArrayList<String> userPrevList = new ArrayList<String>();
        WebBusinessObject wbo;
        for (int i = 0; i < groupPrev.size(); i++) {
            wbo = (WebBusinessObject) groupPrev.get(i);
            userPrevList.add((String) wbo.getAttribute("prevCode"));
        }

        List<WebBusinessObject> userProjects = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKeyOracle("1365240752318", "key2"));
        ArrayList<WebBusinessObject> dataArray = (ArrayList<WebBusinessObject>) request.getAttribute("dataArray");
        String departmentID = (String) request.getAttribute("departmentID");
        WebBusinessObject clientSeasonWbo = (WebBusinessObject) request.getAttribute("clientSeasonWbo");

        String phoneNo = clientWbo != null && clientWbo.getAttribute("phone") != null && !clientWbo.getAttribute("phone").equals("UL") ? (String) clientWbo.getAttribute("phone") : "";
        String mobile = clientWbo != null && clientWbo.getAttribute("mobile") != null && !clientWbo.getAttribute("mobile").equals("UL") ? (String) clientWbo.getAttribute("mobile") : "";
        String dialPhone = clientWbo != null && clientWbo.getAttribute("option3") != null && !clientWbo.getAttribute("option3").equals("UL") && !((String) clientWbo.getAttribute("option3")).equalsIgnoreCase("ON") ? (String) clientWbo.getAttribute("option3") : "";
        String interPhone = clientWbo != null && clientWbo.getAttribute("interPhone") != null && !clientWbo.getAttribute("interPhone").equals("UL") ? (String) clientWbo.getAttribute("interPhone") : "";

        IssueByComplaintUniqueMgr issueByCompalintMgr = IssueByComplaintUniqueMgr.getInstance();
        WebBusinessObject issueByCompalintWbo = issueByCompalintMgr.getOnSingleKey("key2", (String) clientWbo.getAttribute("id"));
        WebBusinessObject userWBO = issueByCompalintWbo != null ? UserMgr.getInstance().getOnSingleKey((String) issueByCompalintWbo.getAttribute("currentOwnerId")) : null;
        String socketMsg = "Your Client " + clientWbo.getAttribute("name").toString() + " with Client Number (" + clientWbo.getAttribute("clientNO") + ") has a new Comment";

        String hasCallCenter = metaMgr.getHasCallCenter();
        ArrayList<WebBusinessObject> getClientsWithLegal = (ArrayList<WebBusinessObject>) ClientMgr.getInstance().getClientsWithLegalDisputeForClient((String) clientWbo.getAttribute("id"));
        WebBusinessObject mergedWebBusinessObject = new WebBusinessObject();
        String legalClient = "";
        for (WebBusinessObject webBusinessObject : getClientsWithLegal) {

            legalClient = webBusinessObject.getAttribute("STATUS_NOTE").toString();
        }

        String stat = (String) request.getSession().getAttribute("currentMode");
        String align, xAlign, dir, sAlign, style, noClientExistMsg, successMsg, failMsg, sendEmail, client, possible, chance, oncontact, notfound,
                yes, no, addBy, addTm, dltErrMsg, chkMsg, onlyNo, clntInfo, clnt,
                age, noKids, clntSchool, confirmed, religion, favSport, favMusic, clubMemb, desc, save, noteMessage, marriageD, legalDispute1, legalDispute, chooseReason;
        String localWhatsapp, interWhatsapp;
        if (stat.equals("En")) {
            align = "left";
            xAlign = "right";
            sAlign = "left";
            dir = "ltr";
            style = "text-align:left";
            noClientExistMsg = "No Client Exist for this Number or Number is not Valid or you have no Authority to view client's details";
            client = "Customer";
            possible = "Lead";
            chance = "Block";
            oncontact = "Visit";
            notfound = "Not Found";
            yes = "Yes";
            no = "No";
            Send = "Send";
            Sent = "your message was sent";
            sendEmail = "Send Email";
            successMsg = "Message Sent Successfully";
            failMsg = "Fail to Send Message";
            addBy = " Added By ";
            sendsmsT = "Send SMS";
            addTm = " Addition Time ";
            writeMsg = "Write Your Message";
            dltErrMsg = " Not Removed ";
            chkMsg = " Please, Choose Campaign You Want To Ramove It. ";
            onlyNo = "You Can Insert Only Numbers";
            clntInfo = "Client Extra Info";
            clnt = "Client";
            age = "Age";
            noKids = "# Of Kids";
            clntSchool = "School";
            religion = "Religion";
            favSport = "Favourite Sport";
            favMusic = "Favourite Music";
            clubMemb = "Club Membership";
            desc = "General Description";
            save = "Save";
            noteMessage = "تنبيه: يجب التأكد من تقييم العميل حسب المتابعة<br/>إذا لم يتم تقييم العميل أتصل بمسؤول ال IT";
            confirm = "Confirm";
            marriageD = "Marriage Date";
            legalDispute1 = "confirm Existence of legal Dispute";
            legalDispute = "Legal Dispute";
            chooseReason = "Please choose Reason";
            confirmed = "Confirmed";
            localWhatsapp = "Local Whatsapp";
            interWhatsapp = "International Whatsapp";
        } else {
            align = "right";
            xAlign = "left";
            sAlign = "right";
            dir = "rtl";
            style = "text-align:Right";
            noClientExistMsg = "لا يوجد عميل لهذا الرقم أو رقم خطأ أو لا يوجد لك صلاحية لمشاهدة تفاصيل العميل";
            client = "عميل";
            possible = "محتمل";
            chance = "بلوك";
            writeMsg = "ادخل نص الرساله";
            oncontact = "زيارة";
            notfound = "لا يوجد";
            yes = "نعم";
            Send = "ارسل";
            no = "لا";
            sendsmsT = "ارسل رسالة قصيرة";
            sendEmail = "أرسال رسالة ألكترونية";
            successMsg = "تم أرسال الرسالة";
            failMsg = "لم يتم أرسال الرسالة";
            addBy = " أضيفت بواسطة ";
            addTm = " تاريخ الإضافة ";
            dltErrMsg = " Not Removed ";
            Sent = "تم ارسال رسالتك";
            chkMsg = " من فضلك إختر الحملات التى تريد حذفها . ";
            onlyNo = "ارقام فقط";
            clntInfo = "معلومات العميل الاضافية";
            clnt = "العميل";
            age = "العمر";
            confirm = "تأكيد";
            noKids = "عدد الاطفال";
            clntSchool = "الدراسة";
            religion = "الديانة";
            favSport = "الرياضة المفضلة";
            favMusic = "الموسيقى المفضلة";
            clubMemb = "عضوية النادى";
            desc = "وصف عام";
            save = "حفظ";
            marriageD = "تاريخ الزواج";
            legalDispute = "نزاع قانونى";
            legalDispute1 = "تأكيد وجود نزاع قانوني";
            chooseReason = "من فضلك اختر السبب";
            confirmed = "تم التأكيد";
            noteMessage = "تنبيه: يجب التأكد من تقييم العميل حسب المتابعة<br/>إذا لم يتم تقييم العميل أتصل بمسؤول ال IT";
            localWhatsapp = "واتساب محلى ";
            interWhatsapp = "واتساب دولى";
        }

        ArrayList callResLst = (ArrayList) request.getAttribute("callResLst");
        String issueID = (String) request.getAttribute("issueID");
    %>

    <head>
        <meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
        <meta HTTP-EQUIV="Expires" CONTENT="0"/>

        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css"/>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery-ui-timepicker-addon.css"/>
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css"/>
        <link rel="stylesheet" type="text/css" href="css/msdropdown/dd.css" />
        <link rel="stylesheet" type="text/css" href="js/w2ui/w2ui-1.5.rc1.min.css" />
        <link href="js/twitter-bootstrap-wizard-master/prettify.css" rel="stylesheet"/>
        <link rel="stylesheet" href="js/rateit/rateit.css"/>
        <link rel="stylesheet" href="css/chosen.css"/>
        <link href="https://fonts.googleapis.com/css2?family=Cairo:wght@200..1000&display=swap" rel="stylesheet">

        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script> 
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <script type="text/javascript" src="js/msdropdown/jquery.dd.min.js"></script>

        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.easing.1.3.js"></script>
        <script type="text/javascript" src="js/w2ui/w2ui-1.5.rc1.min.js"></script>
        <script src="js/twitter-bootstrap-wizard-master/bootstrap/js/bootstrap.min.js"></script>
        <script src="js/twitter-bootstrap-wizard-master/jquery.bootstrap.wizard.js"></script>
        <script src="js/twitter-bootstrap-wizard-master/prettify.jsprettify.js"></script>
        <script type="text/javascript" language="javascript" src="js/rateit/jquery.rateit.min.js"></script>
        <script src="js/chosen.jquery.js" type="text/javascript"></script>
        <script src="js/docsupport/prism.js" type="text/javascript" charset="utf-8"></script>

        <script type="text/javascript">
                    jQuery.browser = {};
                    (function () {
                    jQuery.browser.msie = false;
                            jQuery.browser.version = 0;
                            if (navigator.userAgent.match(/MSIE ([0-9]+)\./)) {
                    jQuery.browser.msie = true;
                            jQuery.browser.version = RegExp.$1;
                    }
                    })();
                    function sendMessageByUser(userName, msg) {
                    alert(userName);
                            var id = [userName];
                            var notificationMsg = {
                            msg: msg,
                                    action: 'NOTIFY',
                                    users: id
                            };
                            var socket = new WebSocket("ws://" + window.location.host + "<%=context%>/notify");
                            socket.send(JSON.stringify(notificationMsg));
                    }

            $(document).ready(function(){
            $("#timeflag").val("1");
                    if ("<%=button%>" == "directCall"){
            popupFollowUp();
            }
            $('#rootwizard').bootstrapWizard({onTabClick: function(tab, navigation, index) {
            var currentIndex = $('#rootwizard').bootstrapWizard('currentIndex');
                    if (index > 1) {
            if ($("#rate" + (currentIndex + 1)).val() === '') {
            alert("You have to answer question to procced.");
                    return false;
            }
            }
            },
                    'tabClass': 'nav nav-pills',
                    'onNext': function(tab, navigation, index) {
                    if ($("#rate" + index).val() === '') {
                    alert("You have to answer question to procced.");
                            return false;
                    }
                    }});
            });
                    var minDateS = '<%=nowTime%>';
                    function appCallResultChange() {
                    if ($("#appCallResult option:selected").text() == "Other Date"){
                    $("#otherdate").show();
                    } else {
                    $("#otherdate").hide();
                    }
                    }

            function closeRentPopup(obj) {
            $("#send_sms").bPopup().close();
                    $("#send_sms").css("display", "none");
            }

            function closeDisputePopup(obj) {
            $("#legal_dispute").bPopup().close();
                    $("#legal_dispute").css("display", "none");
            }

            function closeDisputeClientPopup(obj) {
            $("#statusClient").bPopup().close();
                    $("#statusClient").css("display", "none");
            }
            
            function closeWifi(obj) {
            $("#sentClientWifi").bPopup().close();
                    $("#sentClientWifi").css("display", "none");
            }

            function callResultsChange() {
            var selectedValue = $("#nextAction option:selected").val();
                    if (selectedValue === "Follow" || selectedValue === "meeting" || selectedValue === "Wait" || selectedValue === "Done" || selectedValue === "not answered"
                            || selectedValue === "Send Email" || selectedValue === "Send SMS" || selectedValue === "Send Offer"){
            $("#meetresaultlbl").css("display", "block");
                    $("#meetingDateTD").css("display", "block");
                    $("#timeflag").val("2");
            } else {
            $("#meetresaultlbl").css("display", "none");
                    $("#meetingDateTD").css("display", "none");
                    $("#timeflag").val("3");
            }

            if (selectedValue == "meeting"){
            $("#appointmentPlacelbl").css("display", "block");
                    $("#appointmentPlaceDDL").css("display", "block");
            } else {
            $("#appointmentPlacelbl").css("display", "none");
                    $("#appointmentPlaceDDL").css("display", "none");
            }
            }

            function callResultsChng() {
            var callResult = $("#callResult option:selected").val();
                    if (callResult == "meeting" || callResult == "direct-visit") {
            $("#callStatusTd").css("display", "none");
                    $("#callStatus").css("display", "none"); //callStatus                
            } else if (callResult == "inboundcall") {
            $("#callStatusTd").css("display", "block");
                    $("#callStatus").css("display", "block");
            } else if (callResult == "outbouncall") {
            $("#callStatusTd").css("display", "block");
                    $("#callStatus").css("display", "block");
            } else if (callResult == "internet") {
            $("#callStatusTd").css("display", "block");
                    $("#callStatus").css("display", "block");
            } else {
            $("#callStatusTd").css("display", "block");
                    $("#callStatus").css("display", "block");
            }
            }

            function callStatusChange() {
            var selectedValue = $("#callStatus option:selected").val();
                    if (selectedValue == "answered"){
            $("#callResultTD").css("display", "block");
                    $("#nextAction").css("display", "block");
                    $("#nextAction option[value='not answered']").remove();
                    $("#nextAction option[value='wrong number']").remove();
            } else if (selectedValue == "not answered"){
            $("#appointmentPlacelbl").css("display", "none");
                    $("#appointmentPlaceDDL").css("display", "none");
                    $("#meetingDateTD").css("display", "block");
                    $("#meetresaultlbl").css("display", "block");
                    $("#timeflag").val("2");
            } else {
            $("#timeflag").val("3");
                    $("#callResultTD").css("display", "none");
                    $("#nextAction").css("display", "none");
                    $("#meetresaultlbl").css("display", "none");
                    $("#meetingDateTD").css("display", "none");
                    $("#appointmentPlacelbl").css("display", "none");
                    $("#appointmentPlaceDDL").css("display", "none");
                    $("#nextAction").append('<option value="wrong number" selected> wrong number </option>');
            }
            }
            $(function () {
            $("#emailbox_popup").dialog({
            autoOpen: false,
                    width: 600,
                    modal: true,
                    buttons: {
                    Cancel: function () {
                    $(this).dialog("close");
                    }
                    }
            });
                    $("#meetingDate, #userMeetingDate").datetimepicker({
            changeMonth: true,
                    changeYear: true,
                    minDate: new Date(minDateS),
                    maxDate: '<%=currentYear%>' + '/' + '<%=currentMonth + 1%>' + '/' + '<%=currentDay%>',
                    dateFormat: "yy/mm/dd",
                    timeFormat: "HH:mm"
            });
                    $("#marriageDate").datepicker({
            changeMonth: true,
                    changeYear: true,
                    maxDate: '<%=currentYear%>' + '/' + '<%=currentMonth + 1%>' + '/' + '<%=currentDay%>',
                    dateFormat: "yy/mm/dd",
            });
                    $("#calldate").datetimepicker({
            dateFormat: 'yy/mm/dd',
                    minDate: new Date()
            });
                    $("#palnningDate").datetimepicker({
            minDate: 0,
                    changeMonth: true,
                    changeYear: true,
                    timeFormat: 'HH:mm',
                    dateFormat: 'yy/mm/dd'
            });
                    $('#clientCampaigns').dataTable({
            bJQueryUI: true,
                    "bPaginate": false,
                    "bProcessing": true,
                    "bFilter": false
            }).fadeIn(2000);
                    try {
                    $("#clientRate").msDropDown();
                    } catch (e) {
            alert(e.message);
            }
            });
                    function popupCreateBookmark(obj, clientId) {
                    $("#createMsg").hide();
                            $("#saveBookmark").show();
                            $('#createBookmark').find("#title").val($("#clntNm").val());
                            $('#createBookmark').find("#details").val("");
                            $('#createBookmark').css("display", "block");
                            $('#createBookmark').bPopup({
                    easing: 'easeInOutSine', //uses jQuery easing plugin
                            speed: 400,
                            transition: 'slideDown'
                    });
                    }



            function createBookmark(obj, clientId) {
            var title = $(obj).parent().parent().parent().find('#title').val();
                    var details = $(obj).parent().parent().parent().find('#details').val();
                    $.ajax({
                    type: "post",
                            url: "<%=context%>/BookmarkServlet?op=CreateAjax&issueId=" + clientId + "&issueType=CLIENT",
                            data: {
                            issueId: clientId,
                                    issueTitle: title,
                                    bookmarkText: '<%=((String) clientWbo.getAttribute("name")).replaceAll("\'", "").replaceAll("\"", "")%> ' + details
                            }, success: function (jsonString) {
                    var info = $.parseJSON(jsonString);
                            if (info.status == 'ok') {
                    $("#createMsg").show();
                            $("#createMsg").css("display", "block");
                            $("#bookmarkedImg").prop('title', details);
                            $("#saveBookmark").hide();
                            $("#bookmarked").removeAttr("onclick");
                            $("#bookmarked").click(function () {
                    deleteBookmark(this, info.bookmarkId, clientId);
                    });
                            $('#tb_toolbar_item_bookmarked').show();
                            $('#tb_toolbar_item_unbookmarked').hide();
                    } else { }
                    }
                    });
            }

            function deleteBookmark(obj, bookmarkId, clientId) {
            $.ajax({
            type: "post",
                    url: "<%=context%>/BookmarkServlet?op=DeleteAjax&key=" + bookmarkId,
                    data: {
                    }, success: function (jsonString) {
            var info = $.parseJSON(jsonString);
                    if (info.status == 'ok') {
            $('#tb_toolbar_item_bookmarked').hide();
                    $('#tb_toolbar_item_unbookmarked').show();
            }
            }
            });
            }

            function SendSmsforClient (){

            var msgText = $('#SmsText').val();
                    var mob =<%=clientWbo.getAttribute("id")%>;
                    $.ajax({
                    type: "post",
                            url:"<%=context%>/SmsSenderServlet?op=sendSmsforClient",
                            data: {
                            msgText: msgText,
                                    mob : mob,
                            }, success: function (jsonString) {
                    var info = $.parseJSON(jsonString);
                            if (info.status == 'ok') {
                    alert('<%=Sent%>');
                    }
                    }});
                    closeRentPopup(this);
            }

            function confirmLegalDisputeExs (){

            var reason = $('#disputeReason').val();
                    var clientID =<%=clientWbo.getAttribute("id")%>;
                    $.ajax({
                    type: "post",
                            url:"<%=context%>/ClientServlet?op=confirmClientLegalDispute",
                            data: {
                            reason: reason,
                                    clientID: clientID,
                                    issueId : <%=issueID%>
                            }, success: function (jsonString) {
                    var info = $.parseJSON(jsonString);
                            if (info.status == 'ok') {
                    alert('<%=confirmed%>');
                            changeClientRate1(clientID, '1563706638213');
                            location.reload();
                    }
                    }});
                    closeDisputePopup(this);
            }

            function confirmLegalDisputeExsStatus (){

            var newStatusCode = $('#disputeReasonStatus').val();
                    var clientId =<%=clientWbo.getAttribute("id")%>;
                    $.ajax({
                    type: "post",
                            url:"<%=context%>/ProjectServlet?op=clientStatusNew",
                            data: {
                            clientId: clientId,
                                    newStatusCode : newStatusCode
                            }, success: function (jsonString) {
                    var info = $.parseJSON(jsonString);
                            if (info.status == 'ok') {
                    alert('<%=confirmed%>');
                            changeClientRate1(clientId, '1563706638213');
                            location.reload();
                    }
                    }});
                    closeDisputePopup(this);
            }

            function confirmWifi() {
    var newStatusCode = $('#disputeReasonStatus').val();
    var clientId = <%=clientWbo.getAttribute("id")%>;
    var selectedWifi = $('#wifiID').val();
    var selectedPrice = $('#priceDisplay').text().replace('Price: ', '');
    
    $.ajax({
        type: "post",
        url: "<%=context%>/UnitServlet?op=updateWifi",
        data: {
            clientId: clientId,
            wifiId: selectedWifi,
            price: selectedPrice
        }, 
        success: function(jsonString) {
            var info = $.parseJSON(jsonString);
            if (info.status == 'ok') {
                alert('<%=confirmed%>');
                changeClientRate1(clientId, '1563706638213');
                location.reload();
            }
            else if (info.status == 'phone') {
                alert('هذا الهاتف مسجل من قبل وسيتم اضافة خدمة جديدة له ام ترك الخدمة القديمة');
                changeClientRate1(clientId, '1563706638213');
                location.reload();
            }
        }
    });
    closeDisputePopup(this);
}

            function printClientInformation(obj) {
            var url = "<%=context%>/PDFReportServlet?op=clientDataSheet&clientId=" + $("#clientId").val() + "&objectType=client";
                    openWindow(url);
            }

            function printClientFincancial() {
            var url = "<%=context%>/ExternalDatabaseServlet?op=viewClientFinancialReport&clientId=" + $("#clientId").val();
                    window.open(url, "_blank", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=no, copyhistory=no, width=1200, height=500");
            }

            function updateClientInformation() {
            var url = "<%=context%>/ClientServlet?op=getUpdateClientForm&clientId=" + $("#clientId").val();
                    openWindow(url);
            }

            function viewClientCommunications() {
            var url = "<%=context%>/ClientServlet?op=viewClientCommunications&clientId=" + $("#clientId").val();
                    openWindow(url);
            }

            function openWindow(url) {
            window.open(url, "_blank", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=no, copyhistory=no, width=700, height=600");
            }

            function viewClientContract() {
            $.ajax({
            type: "post",
                    url: "./EmailServlet?op=getContractID&clientID=" + <%=clientWbo != null ? clientWbo.getAttribute("id") : ""%>,
                    success: function (jsonString) {
                    if (jsonString != '') {
                    var url = "<%=context%>/UnitDocReaderServlet?op=viewDocument&docType=pdf&docID=" + jsonString + "&metaType=application/pdf";
                            window.open(url);
                    }
                    }, error: function (){
            alert('لا يوجد عقد مرفق');
            }
            });
            }

            function closePopup(obj) {
            $(obj).parent().parent().bPopup().close();
            }

            function popupClientsList(obj, clientId) {
            $('#displayClients').css("display", "block");
                    $('#displayClients').bPopup({
            easing: 'easeInOutSine', //uses jQuery easing plugin
                    speed: 400,
                    transition: 'slideDown'});
            }

            function noCallCenter() {
            alert("Must purchase Communication Server.\nPlease call 4S-Company for details.");
            }

            function openSmsDialoge()
            {
            $('#send_sms').css("display", "block");
                    $('#send_sms').bPopup();
            }
            function openLegalDisputeDialoge()
            {
            $('#legal_dispute').css("display", "block");
                    $('#legal_dispute').bPopup();
            }

            function openStatusClientDialoge()
            {
            $('#statusClient').css("display", "block");
                    $('#statusClient').bPopup();
            }

            function sentClientWifi()
            {
            $('#sentClientWifi').css("display", "block");
                    $('#sentClientWifi').bPopup();
            }

            function  popupMailBox(){
            var clientid = "<%=clientWbo != null ? clientWbo.getAttribute("clientNO") : ""%>";
                    var clientname = "<%=clientWbo != null ? ((String) clientWbo.getAttribute("name")).replaceAll("\'", "").replaceAll("\"", "").trim() : ""%>";
                    var clientemail = "<%=clientWbo != null ? clientWbo.getAttribute("email") : ""%>";
                    var url = "<%=context%>/ClientServlet?op=getmailbox&clientemail=" + clientemail + "&clientname=" + clientname;
                    $('#emailbox_popup').css("display", "block");
                    $("#emailbox_popup").dialog("open");
                    $.ajax({
                    url: "<%=context%>/ClientServlet?op=getmailbox",
                            data: {
                            clientemail: clientemail,
                                    clientname: clientname
                            }, success: function (response, textStatus, jqXHR) {
                    jQuery('#emailbox_popup').html(response);
                    }, error: function (jqXHR, textStatus, errorThrown) {}
                    });
            }

            function showAttachedFiles(businessObjectId) {
            divAttachmentTag = $("div[name='divAttachmentTag']");
                    $.ajax({
                    type: "post",
                            url: '<%=context%>/FileUploadServlet?op=viewDocuments',
                            data: {
                            businessObjectId: businessObjectId
                            },
                            success: function (data) {
                            divAttachmentTag.html(data)
                                    .dialog({
                                    modal: true,
                                            title: "View File",
                                            show: "fade",
                                            hide: "explode",
                                            width: 700,
                                            position: {
                                            my: 'center',
                                                    at: 'center'
                                            },
                                            buttons: {
                                            Done: function () {
                                            divAttachmentTag.dialog('destroy').hide();
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

            function viewClientDocument(obj) {
            var docID = $(obj).parent().find('#docID').val();
                    var docType = $(obj).parent().find('#documentType').val();
                    if (docType == ('jpg')) {
            $.ajax({
            type: "post",
                    url: "<%=context%>/EmailServlet?op=viewDocument",
                    data: {
                    docID: docID,
                            docType: docType
                    }, success: function (jsonString) {
            var info = $.parseJSON(jsonString);
                    if (info.status == 'ok') {
            $("#docImage").attr("src", info.imagePath);
                    $('#showImage').bPopup();
            }
            }
            });
            } else {
            var hiddenIFrameID = 'hiddenDownloader',
                    iframe = document.getElementById(hiddenIFrameID);
                    var url = "<%=context%>/EmailServlet?op=viewDocument&docID=" + docID + "&docType=" + docType;
                    if (iframe === null) {
            iframe = document.createElement('iframe');
                    iframe.id = hiddenIFrameID;
                    iframe.style.display = 'none';
                    document.body.appendChild(iframe);
            }

            iframe.src = url;
            }
            }

            function openGalleryDialog() {
            var divTag = $("<div></div>");
                    $.ajax({
                    type: "post",
                            url: '<%=context%>/FileUploadServlet?op=getGalleryDialog',
                            data: {
                            businessObjectId: $("#clientId").val(),
                                    objectType: 'client'
                            },
                            success: function (data) {
                            divTag.html(data)
                                    .dialog({
                                    modal: true,
                                            title: "View Image",
                                            show: "fade",
                                            hide: "explode",
                                            width: 950,
                                            dialogClass: 'no-close',
                                            position: {
                                            my: 'center',
                                                    at: 'center'
                                            },
                                            buttons: {
                                            Cancel: function () {
                                            divTag.dialog('destroy').close();
                                            },
                                                    Done: function () {
                                                    divTag.dialog('destroy').close();
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

            function popupAddCampaign() {
            var divTag = $("#addCampaign");
                    divTag.dialog({
                    modal: true,
                            title: "Add Campaign",
                            show: "blind",
                            hide: "explode",
                            width: 800,
                            height: 600,
                            overflow: 'auto',
                            position: {
                            my: 'center',
                                    at: 'center'
                            }, buttons: {
            <%
                if (privilegesList.contains("add_client_campaign")) {
            %>
                    Add: function () {
                    saveClientCampaign();
                    }
            <%
                }
                if (privilegesList.contains("add_client_campaign") && privilegesList.contains("DELETE_CLIENTS")) {
            %>
                    ,
            <%
                }
                if (privilegesList.contains("DELETE_CLIENTS")) {
            %>
                    Remove: function () {
                    removeClientCampaign();
                    },
            <%
                }
            %>
                    Close: function () {
                    $("#addCampaign").dialog("destroy").dialog("close");
                    }
                    }
                    }).dialog('open');
            }

            function saveClientCampaign() {
            $.ajax({
            type: 'POST',
                    url: "<%=context%>/ClientServlet?op=saveClientCampaign",
                    data: {
                    clientID: '<%=clientWbo != null ? clientWbo.getAttribute("id") : ""%>',
                            campaignID: $("#campaignID").val()
                    }, success: function (data) {
            var jsonString = $.parseJSON(data);
                    if (jsonString.status === 'ok') {
            location.reload();
            } else {
            alert('<fmt:message key="failMsg" />');
            }
            }
            });
            }

            var sec = - 1;
                    function pad(val) {
                    return val > 9 ? val : "0" + val;
                    }

            setInterval(function () {
            $("#timer").html(pad(parseInt(sec / 3600, 10)) + ":" + pad(parseInt(sec / 60, 10) % 60) + ":" + pad(++sec % 60));
            }, 1000);
                    var divTag;
                    function popupViewComplaints() {
                    divTag = $("#clientComplaints");
                            $.ajax({
                            type: "post",
                                    url: '<%=context%>/ClientServlet?op=getMyClientComplaints',
                                    data: {
                                    clientID: '<%=clientWbo != null ? clientWbo.getAttribute("id") : ""%>',
                                            issueID : <%=issueID%>
                                    }, success: function (data) {
                            divTag.html(data).dialog({
                            modal: true,
                                    title: "طلبات العميل",
                                    show: "fade",
                                    hide: "explode",
                                    width: 950,
                                    position: {
                                    my: 'center',
                                            at: 'center'
                                    }, buttons: {
                            'Close': function () {
                            $(this).dialog('close');
                            }
                            }
                            }).dialog('open');
                                    $('#clientCampaignsPopup').dataTable({
                            bJQueryUI: true,
                                    "bPaginate": false,
                                    "bProcessing": true,
                                    "bFilter": false
                            }).fadeIn(2000);
                            }, error: function (data) {
                            alert(data);
                            }
                            });
                    }

            function openInNewWindow(url) {
            var win = window.open(url, '_blank');
                    win.focus();
            }

            function popupClientAppointments() {
            var userID = '<%=userID%>';
                    var priv = '<%=privilege%>';
                    var divTag = $("#appointments");
                    $.ajax({
                    type: "post",
                            url: '<%=context%>/AppointmentServlet?op=getClientAppointments',
                            data: {
                            clientID: '<%=clientWbo != null ? clientWbo.getAttribute("id") : ""%>'
                            }, success: function (data) {
                    divTag.html(data).dialog({
                    modal: true,
                            title: "Follow Client",
                            show: "fade",
                            hide: "explode",
                            width: 950,
                            position: {
                            my: 'center',
                                    at: 'center'
                            }, buttons: {
                    'Close': function () {
                    $(this).dialog('close');
                    }
                    }
                    }).dialog('open');
                            $('#clientAppointmentsPopup').dataTable({
                    bJQueryUI: true,
                            "bPaginate": false,
                            "bProcessing": true,
                            "aaSorting": [[ 1, "desc" ]],
                            "bFilter": false,
                            "order": [[ 2, "asc" ]],
                            "columnDefs": [
                            {
                            "targets": 2,
                                    "visible": false
                            }],
                            "drawCallback": function (settings) {
                            var api = this.api();
                                    var rows = api.rows({page: 'current'}).nodes();
                                    var last = null;
                                    api.column(2, {page: 'current'}).data().each(function (group, i) {
                            if (last !== group) {
                            $(rows).eq(i).before(
                                    '<tr class="group"><td style="font-size: 14px; background-color: lightgray; border: 1px solid gray;" colspan="1">Agent</td><td style="font-size: 16px; border: 1px solid gray; color: #700016;" colspan="4">'
                                    + group + '</td></tr>'
                                    );
                                    last = group;
                            }
                            });
                            }
                    }).fadeIn(2000);
                    }, error: function (data) {
                    alert(data);
                    }
                    });
            }

            function popupMyClientAppointments() {
            var divTag = $("#appointments");
                    $.ajax({
                    type: "post",
                            url: '<%=context%>/AppointmentServlet?op=getClientAppointments',
                            data: {
                            clientID: '<%=clientWbo != null ? clientWbo.getAttribute("id") : ""%>',
                                    type: 'personal'
                            }, success: function (data) {
                    divTag.html(data).dialog({
                    modal: true,
                            title: "متابعاتي",
                            show: "fade",
                            hide: "explode",
                            width: 950,
                            position: {
                            my: 'center',
                                    at: 'center'
                            }, buttons: {
                    'Close': function () {
                    $(this).dialog('close');
                    }
                    }
                    }).dialog('open');
                            $('#clientAppointmentsPopup').dataTable({
                    bJQueryUI: true,
                            "bPaginate": false,
                            "bProcessing": true,
                            "aaSorting": [[ 1, "desc" ]],
                            "bFilter": false
                    }).fadeIn(2000);
                    }, error: function (data) {
                    alert(data);
                    }
                    });
            }

            function popupFutureClientAppointments() {
            var divTag = $("#appointments");
                    $.ajax({
                    type: "post",
                            url: '<%=context%>/AppointmentServlet?op=getFutureClientAppointments',
                            data: {
                            clientID: '<%=clientWbo != null ? clientWbo.getAttribute("id") : ""%>'
                            }, success: function (data) {
                    divTag.html(data).dialog({
                    modal: true,
                            title: "متابعات العميل المستقبلية",
                            show: "fade",
                            hide: "explode",
                            width: 950,
                            position: {
                            my: 'center',
                                    at: 'center'
                            }, buttons: {
                    'Close': function () {
                    $(this).dialog('close');
                    }
                    }
                    }).dialog('open');
                            $('#clientFutureAppointmentsPopup').dataTable({
                    bJQueryUI: true,
                            "bPaginate": false,
                            "bProcessing": true,
                            "aaSorting": [[ 1, "desc" ]],
                            "bFilter": false
                    }).fadeIn(2000);
                    }, error: function (data) {
                    alert(data);
                    }
                    });
            }

            function changeClientRate(clientID,rateID) {
            
                    $.ajax({
                    type: "post",
                            url: "<%=context%>/ClientServlet?op=changeClientRate",
                            data: {
                            rateID: rateID,
                                    clientID: clientID
                            }, success: function (jsonString) {
                    var info = $.parseJSON(jsonString);
                            if (info.status == 'ok') {
                    //alert("تم التقييم");
                    } else {
                    alert("خطأ لم يتم التقييم");
                    }
                    }
                    });
            }

            function changeClientRate1(clientID, rateId) {
            var rateID = rateId;
                    $.ajax({
                    type: "post",
                            url: "<%=context%>/ClientServlet?op=changeClientRate",
                            data: {
                            rateID: rateID,
                                    clientID: clientID
                            }, success: function (jsonString) {
                    var info = $.parseJSON(jsonString);
                            if (info.status == 'ok') {
                    //alert("تم التقييم");
                    } else {
                    alert("خطأ لم يتم التقييم");
                    }
                    }
                    });
            }

            function loading(val) {
            if (val === "none") {
            $('#loading').fadeOut(2000, function () {
            $('#loading').css("display", val);
            });
            } else {
            $('#loading').fadeIn("fast", function () {
            $('#loading').css("display", val);
            });
            }
            }

            function openEmailDialog(clientName, clientEmail, title) {
            loading("block");
                    divCommentsTag = $("div[name='divCommentsTag']");
                    count = 1
                    $.ajax({
                    type: "post",
                            url: '<%=context%>/EmailServlet?op=getEmailPopupClient',
                            data: {
                            clientName: clientName,
                                    clientEmail: clientEmail,
                                    title: title,
                            }, success: function (data) {
                    divCommentsTag.html(data).dialog({
                    modal: true,
                            title: "<%=sendEmail%>",
                            show: "fade",
                            hide: "explode",
                            width: 650,
                            height: 620,
                            position: {
                            my: 'center',
                                    at: 'center'
                            }, buttons: {
                    Close: function () {
                    divCommentsTag.dialog('destroy').hide();
                    }, Send: function () {
                    sendMailByAjax2();
                    }
                    }
                    }).dialog('open');
                    }, error: function (data) {
                    alert('Data Error = ' + data);
                    }
                    });
                    loading("none");
            }

            function sendMailByAjax2() {
            $("#progressx").css("display", "block");
                    $("#progressx").show();
                    $("#emailStatus").html("");
                    $("#progressx").css("display", "block");
                    var formData = new FormData($("#emailForm")[0]);
                    var obj = $("#listFile");
                    $.each($(obj).find("input[type='file']"), function (i, tag) {
                    $.each($(tag)[0].files, function (i, file) {
                    formData.append(tag.name, file);
                    });
                    });
                    formData.append("to", $("#to").val());
                    formData.append("title", $("#subject").val());
                    formData.append("subject", $("#subject2").val());
                    formData.append("counter", $("#emailCounter").val());
                    formData.append("message", $("#mailBody").val());
                    $.ajax({
                    url: '<%=context%>/EmailServlet?op=sendByAjaxClient',
                            type: 'POST',
                            data: formData,
                            async: false,
                            success: function (data) {
                            var result = $.parseJSON(data);
                                    $("#progressx").html('');
                                    $("#progressx").css("display", "none");
                                    if (result.status == 'ok') {
                            $("#emailStatus").html("<font color='green'><%=successMsg%></font>");
                            } else if (result.status == 'error') {
                            $("#emailStatus").html("<font color='red'><%=failMsg%></font>");
                            }
                            }, error: function (){
                    $("#emailStatus").html("<font color='red'><%=failMsg%></font>");
                    }, cache: false,
                            contentType: false,
                            processData: false
                    });
                    return false;
            }

            var count = 1;
                    function addEmailFiles(obj) {
                    if ((count * 1) == 4) {
                    $("#addEmailFile").removeAttr("disabled");
                    }

                    if (count >= 1 & count <= 4) {
                    $("#listFile").append("<input type='file' style='text-align:right;font-size:12px;margin:1.5px;' name='file" + count + "' id='file2'  maxlength='60'/>");
                            $("#emailCounter").val(count);
                            count = Number(count * 1 + 1)
                    } else {
                    $("#addEmailFile").attr("disabled", true);
                    }
                    }

            function selectAllClntCmpCkBx() {
            if ($("#clntCmpCkBxAll").val() == "off"){
            $("input[name='clntCmpCkBx']").each(function(){
            $(this).prop("checked", true);
            });
                    $("#clntCmpCkBxAll").val("on");
            } else if ($("#clntCmpCkBxAll").val() == "on"){
            $("input[name='clntCmpCkBx']").each(function(){
            $(this).prop("checked", false);
            });
                    $("#clntCmpCkBxAll").val("off");
            }
            }

            function removeClientCampaign() {
            var clntCmpCkBx = [];
                    $("input[name=clntCmpCkBx]:checked").each(function() {
            clntCmpCkBx.push($(this).val());
            });
                    if (clntCmpCkBx.length <= 0){
            alert('<%=chkMsg%>');
            } else {
            $.ajax({
            type: 'POST',
                    url: "<%=context%>/ClientServlet?op=removeClientCampaign",
                    data: {
                    clntCmpIDs: clntCmpCkBx.join()
                    }, success: function (data) {
            var jsonString = $.parseJSON(data);
                    if (jsonString.status === 'ok') {
            location.reload();
            } else {
            alert('<%=dltErrMsg%>');
            }
            }
            });
            }
            }

            function openClientSurveyPopup() {
            var divTag = $("#clientSurvey");
                    divTag.dialog({
                    modal: true,
                            title: "أسئلة أستقصائية",
                            show: "fade",
                            hide: "explode",
                            width: 600,
                            position: {
                            my: 'center',
                                    at: 'center'
                            }, buttons: {
                    'Close': function () {
                    $(this).dialog('close');
                    },
                            'Save' : function () {
                            saveClientSurvey();
                            }
                    }
                    }).dialog('open');
            }

            function saveClientSurvey() {
            var rateVal = '';
                    var questionID = '';
                    for (i = 1; i <= <%=questionsList.size()%>; i++) {
            if ($("#rate" + i).val() === '') {
            alert("You have to answer all questions to save.");
                    return false;
            }
            rateVal += $("#rate" + i).val() + ',';
                    questionID += $("#questionID" + i).val() + ',';
            }
            if (questionID !== '') {
            questionID = questionID.substring(0, questionID.length - 1);
            }
            if (rateVal !== '') {
            rateVal = rateVal.substring(0, rateVal.length - 1);
            }
            $.ajax({
            type: "post",
                    url: "<%=context%>/CommentsServlet?op=saveClientSurveyAjax",
                    data: {
                    rateVal: rateVal,
                            questionID: questionID,
                            clientID: '<%=clientWbo.getAttribute("id")%>'
                    }, success: function (jsonString) {
            var info = $.parseJSON(jsonString);
                    if (info.status == 'ok') {
            location.reload();
            } else {
            alert("خطأ لم يتم التقييم");
            }
            }
            });
            }

            function isNumber(evt) {
            var iKeyCode = (evt.which) ? evt.which : evt.keyCode;
                    if (iKeyCode != 46 && iKeyCode > 31 && (iKeyCode < 48 || iKeyCode > 57)) {
            alert("<%=onlyNo%>");
                    return false;
            }
            return true;
            }
        </script>

        <style>
            table label {
                text-align:  center;
                font-weight: bold;
            }

            td {
                border: none;
                padding-bottom: 10px;
            }

            .toolBox {
                width:45px;
                height: 40px;
                float:right;
                margin: 0px;
                padding: 0px;
                border: 1px solid black;
            }

            .toolBox a img {
                width: 40px important;
                height: 40px important;
                float: right;
                margin: 0px;
                padding: 0px;
                text-align: right;
            }

            .titleTD {
                text-align:center;
                font-weight: bold;
                font-size: 16px;
                color: black;
                background-color:#b9d2ef;
            }

            .dataTD {
                text-align:right;
                border: none;
                font-weight: bold;
                font-size: 16px;
                color: black;
            }

            tr:nth-child(even) td.dataTD {
                background: #FFF;
                width: 40%;
            }

            tr:nth-child(odd) td.dataTD {
                background: #f1f1f1;
                width: 40%;
            }

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
            }

            .titleRow {
                background-color: orange;
            }

            .detailTD {
                text-align:center;
                font-weight: bold;
                font-size: 16px;
                color: black;
                background-color: #FCC90D;
            }

            .dataDetailTD {
                text-align:right;
                border: none;
                font-weight: bold;
                font-size: 16px;
                color: black;
            }

            tr:nth-child(even) td.dataDetailTD {
                background: #FFF19F
            }

            tr:nth-child(odd) td.dataDetailTD {
                background: #FFF19F
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

            .ddlabel {
                float: left;
            }

            .fnone {
                margin-right: 5px;
            }

            .w2ui-grid .w2ui-grid-toolbar {
                padding: 14px 5px;
                height: 150px;
            }

            .w2ui-grid .w2ui-grid-header {
                padding: 14px;
                font-size: 20px;
                height: 150px;
            }

            .ui-dialog-titlebar-close {
                visibility: hidden;
            }
        </style>
    </head>

    <BODY>
        <input type="hidden" id="userSocket" value="<%=userWBO != null ? userWBO.getAttribute("fullName") : ""%>" />

        <input type="hidden" id="msgSocket" value="<%=socketMsg%>" />

        <div name="divAttachmentTag"></div>

        <div name="divCommentsTag"></div>

        <%
            if (showHeader != null && showHeader.equals("true")) {
        %>
        <script type="text/javascript">
            function sendMailByAjax(obj) {
            $(obj).parent().find("#progressx").css("display", "block");
                    $('#attachForm').submit(function (e) {
            $("#projectId").val($("#clientId").val());
                    $.ajax({
                    url: '<%=context%>/EmailServlet?op=attachFile',
                            type: 'POST',
                            data: new FormData(this),
                            processData: false,
                            contentType: false,
                            beforeSend: function (){
                            $("#progressx2").show();
                                    $("#attachMessage").html("");
                                    $("#progressx2").css("display", "block");
                            }, uploadProgress: function (event, position, total, percentComplete){
                    $("#bar").width(percentComplete + '%');
                            $("#percent").html(percentComplete + '%');
                    }, success: function (){
                    $("#progressx2").html('');
                            $("#progressx2").css("display", "none");
                    }, complete: function (response){
                    $("#attachMessage").html("<font color='white'>تم رفع الملفات</font>");
                    }, error: function (){
                    $("#attachMessage").html("<font color='red'>لم يتم رفع الملفات</font>");
                    }
                    });
                    e.preventDefault();
            });
            }

            var divAttachmentTag;
                    function openAttachmentDialog(businessObjectId, objectType) {
                    divAttachmentTag = $("div[name='divAttachmentTag']");
                            $.ajax({
                            type: "post",
                                    url: '<%=context%>/FileUploadServlet?op=getUploadDialog',
                                    data: {
                                    businessObjectId: businessObjectId,
                                            objectType: objectType
                                    },
                                    success: function (data) {
                                    divAttachmentTag.html(data)
                                            .dialog({
                                            modal: true,
                                            title: "ارفاق مستندات",
                                                    show: "fade",
                                                    hide: "explode",
                                                    width: 480,
                                                    position: {
                                                    my: 'center',
                                                            at: 'center'
                                                    },
                                                    buttons: {
                                                    Done: function () {
                                                    divAttachmentTag.dialog('destroy').hide();
                                                    location.reload();
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

            var count = 1;
                    var validName = false;
                    var validPhoneMobile = false;
                    
                    function popupCreateClient() {
                    $("#nameMSG").hide();
                            $("#nameWarning").css("display", "none");
                            $("#nameOk").css("display", "none");
                            $("#telMSG").css("display", "none");
                            $("#telWarning").css("display", "none");
                            $("#telOk").css("display", "none");
                            $("#mobMSG").hide();
                            $("#mobWarning").css("display", "none");
                            $("#mobOk").css("display", "none");
                            $("#createClientMsg").hide();
                            $("#saveClient").css("display", "inline-flex");
                            $('#clientName').val("");
                            $('#phone').val("");
                            $('#clientMobile').val("");
                            $('#createClient').css("display", "block");
                            $('#createClient').bPopup({
                    easing: 'easeInOutSine', //uses jQuery easing plugin
                            speed: 400,
                            transition: 'slideDown'
                    });
                    }

            function createClient() {
            var clientName = $('#clientName').val();
                    var phone = $('#phone').val();
                    var clientMobile = $('#clientMobile').val();
                    checkClientName();
                    checkClientPhone();
                    checkClientMobile();
                    if (validPhoneMobile && validName) {
            $.ajax({
            type: "post",
                    url: "<%=context%>/ClientServlet?op=SaveClientByAjax",
                    data: {
                    oldClientID: $("#clientId").val(),
                            clientName: clientName,
                            phone: phone,
                            clientMobile: clientMobile,
                            gender: 'UL',
                            matiralStatus: 'UL',
                            automatedClientNo: 'true',
                            birthDate: '',
                            age: "30-40"
                    }, success: function (jsonString) {
            $("#saveClient").hide();
                    location.reload();
                    //                            var info = $.parseJSON(jsonString);
                    //                            if (info.status == 'Ok') {
                    //                                $("#createClientMsg").show();
                    //                                $("#createClientMsg").css("display", "block");
                    //                                $("#saveClient").hide();
                    //                                location.reload();
                    //                            }
                    //                            else {
                    //                                alert("لم يتم تسجيل العميل");
                    //                            }
            }
            });
            }
            }

            function checkClientPhone() {
            if (!validateData2("numeric", document.getElementById("phone"))) {
            $("#telMSG").show();
                    $("#telMSG").text("ارقام فقط");
                    $("#telMSG").css("color", "red");
                    $("#telOk").css("display", "none");
                    validPhoneMobile = false;
                    $("#saveClient").hide();
                    checkClientMobile();
                    return false;
            } else if (document.getElementById("phone").value.length < 8 && (document.getElementById("clientMobile").value == '' || document.getElementById("clientMobile").value.length < 11)) {
            $("#telMSG").show();
                    $("#telMSG").text("8 أرقام علي اﻷقل");
                    $("#telMSG").css("color", "red");
                    $("#telOk").css("display", "none");
                    validPhoneMobile = false;
                    $("#saveClient").hide();
                    return false;
            }

            var phone = $("#phone").val();
                    if (phone.length > 0) {
            $.ajax({
            type: "post",
                    url: "<%=context%>/ClientServlet?op=getClientPhone",
                    data: {
                    phone: phone
                    }, success: function (jsonString) {
            var info = $.parseJSON(jsonString);
                    if (info.status == 'No') {
            $("#telMSG").css("color", "green");
                    $("#telMSG").css("text-align", "left");
                    $("#telMSG").css("display", "inline");
                    $("#telMSG").text(" متاح");
                    $("#telMSG").removeClass("error");
                    $("#telWarning").css("display", "none");
                    $("#telOk").css("display", "inline");
                    validPhoneMobile = true;
                    if (validName && validPhoneMobile) {
            $("#saveClient").show();
            }

            return true;
            } else if (info.status == 'Ok') {
            $("#telMSG").css("color", "red");
                    $("#telMSG").css("display", "inline");
                    $("#telMSG").css("font-size", "12px");
                    $("#telMSG").text(" محجوز");
                    $("#telMSG").addClass("error");
                    $("#telWarning").css("display", "inline");
                    $("#telOk").css("display", "none");
                    validPhoneMobile = false;
                    $("#saveClient").hide();
                    return false;
            }
            }
            });
            }
            }

            function checkClientMobile() {
            var phone = $("#clientMobile").val();
                    if (!validateData2("numeric", document.getElementById("clientMobile"))) {
            $("#mobMSG").show();
                    $("#mobMSG").text("ارقام فقط");
                    $("#mobMSG").css("color", "red");
                    $("#mobOk").css("display", "none");
                    validPhoneMobile = false;
                    $("#saveClient").hide();
                    checkClientPhone();
                    return false;
            } else if (document.getElementById("clientMobile").value.length < 11 && (document.getElementById("phone").value == '' || document.getElementById("phone").value.length < 8)) {
            $("#mobMSG").show();
                    $("#mobMSG").text("11 أرقام علي اﻷقل");
                    $("#mobMSG").css("color", "red");
                    $("#mobMSG").css("display", "none");
                    validPhoneMobile = false;
                    $("#saveClient").hide();
                    return false;
            }

            if (phone.length > 0) {
            $.ajax({
            type: "post",
                    url: "<%=context%>/ClientServlet?op=getClientMobile",
                    data: {
                    mobile: phone
                    }, success: function (jsonString) {
            $("#mobMSG").show();
                    var info = $.parseJSON(jsonString);
                    if (info.status == 'No') {
            $("#mobMSG").css("color", "green");
                    $("#mobMSG").css(" text-align", "left");
                    $("#mobMSG").text(" متاح");
                    $("#mobMSG").removeClass("error");
                    $("#mobWarning").css("display", "none");
                    $("#mobOk").css("display", "inline");
                    validPhoneMobile = true;
                    if (validName && validPhoneMobile) {
            $("#saveClient").show();
            }

            return true;
            } else if (info.status == 'Ok') {
            $("#mobMSG").css("color", "red");
                    $("#mobMSG").css("font-size", "12px");
                    $("#mobMSG").text(" محجوز");
                    $("#mobMSG").addClass("error");
                    $("#mobWarning").css("display", "inline");
                    $("#mobOk").css("display", "none");
                    validPhoneMobile = false;
                    $("#saveClient").hide();
                    return false;
            }
            }
            });
            }
            }

            function checkClientName() {
            var clientName = $("#clientName").val();
                    if (clientName.length > 0) {
            $.ajax({
            type: "post",
                    url: "<%=context%>/ClientServlet?op=getClientName",
                    data: {
                    clientName: clientName
                    }, success: function (jsonString) {
            $("#nameMSG").show();
                    var info = $.parseJSON(jsonString);
                    if (info.status == 'No') {
            $("#nameMSG").css("color", "green");
                    $("#nameMSG").css(" text-align", "left");
                    $("#nameMSG").text(" متاح")
                    $("#nameMSG").removeClass("error");
                    $("#nameWarning").css("display", "none");
                    $("#nameOk").css("display", "inline");
                    validName = true;
                    if (validName && validPhoneMobile) {
            $("#saveClient").show();
            }
            return true;
            } else if (info.status == 'Ok') {
            $("#nameMSG").css("color", "red");
                    $("#nameMSG").css("font-size", "12px");
                    $("#nameMSG").text(" محجوز");
                    $("#nameMSG").addClass("error");
                    $("#nameWarning").css("display", "inline")
                    $("#nameOk").css("display", "none");
                    validName = false;
                    $("#saveClient").hide();
                    return false;
            }
            }
            });
            } else {
            $("#nameMSG").text("");
                    $("#nameWarning").css("display", "none");
                    $("#nameOk").css("display", "none");
            }
            }

            function popupFollowUp() {
            sec = - 1;
                    $("#appTitleMsg").css("color", "");
                    $("#appTitleMsg").text("");
                    $("#appNote").val("");
                    $("#appMsg").hide();
                    $(".submenu1").hide();
                    $("#appClientName").text($("#hideName").val());
                    $(".button_pointment").attr('id', '0');
                    $('#follow_up_content').css("display", "block");
                    $('#follow_up_content').bPopup({
            easing: 'easeInOutSine', //uses jQuery easing plugin
                    speed: 400,
                    transition: 'slideDown'
            });
            }

            function saveFollowUp(obj) {
            if ($("#nextAction option:selected").val() == null || $("#nextAction option:selected").val() == "" || $("#nextAction option:selected").val() == " "){
            alert("Choose Call Result");
            } else if ($("#comment").val() == null || $("#comment").val() == "" || $("#comment").val() == " "){
            alert(" يجب إضافة تعليق ");
            } else {
            $("#appTitleMsg").css("color", "");
                    $("#appTitleMsg").text("");
                    var clientId = $("#clientId").val();
                    var title = '';
                    if ($("#appTitle").val() !== null) {
            title = $("#appTitle").val();
            }

            var callResult = $("#callResult").val();
                    var nextAction = $("#nextAction").val();
                    var resultValue = "";
                    var appCallResult = $(obj).parent().parent().parent().find($("#nextAction")).val();
                    var meetingDate = $(obj).parent().parent().parent().find($("#meetingDate")).val();
                    var note = '<%=CRMConstants.CALL_RESULT_FOLLOWUP%>';
                    var privacy = $('input[name=privacy]:checked').val();
                    var callDuration = $(obj).parent().parent().parent().find($("#callDuration")).val();
                    var callStatus = $("#callStatus").val();
                    var meetingDate = $("#meetingDate").val();
                    var timeflag = $("#timeflag").val();
                    var timer = $("#timer").html();
                    if (nextAction === '<%=CRMConstants.CALL_RESULT_MEETING%>') {
            resultValue = meetingDate;
                    note = "meeting";
            } else if (nextAction === '<%=CRMConstants.CALL_RESULT_NO_ACTION%>') {
            resultValue = appCallResult;
                    note = "No Action";
            } else /*if (callResult === '<%=CRMConstants.CALL_RESULT_CALL%>')*/{
            resultValue = appCallResult;
                    note = $("#nextAction option:selected").text();
            }

            var appType = '<%=CRMConstants.CALL_RESULT_FOLLOWUP%>';
                    /*if (note == "Not Interested" || note == "No Answer")
                     {*/
                    appType = callResult;
                    //}

                    var appointmentPlace = $(obj).parent().parent().parent().find("#appointmentPlace").val();
                    var comment = $("#comment").val();
                    if (comment == "") {
            $("#comment").val = "";
                    comment = "";
            }

            if (callResult == "meeting") {
            callStatus = "attended";
            }

            if (callStatus == "not answered"){
            nextAction = $("#nextAction option:selected").text();
                    note = $("#nextAction option:selected").text();
                    resultValue = "not answered";
            }

            if (title.length > 0) {
            $(obj).parent().parent().parent().parent().find("#progress").show();
                    $.ajax({
                    type: "post",
                            url: "<%=context%>/ClientServlet?op=saveFollowUpAppointment",
                            data: {
                            clientId: clientId,
                                    title: title,
                                    callResult: callResult,
                                    nextAction: nextAction,
                                    resultValue: resultValue,
                                    note: note,
                                    appType: callResult,
                                    appointmentPlace: appointmentPlace,
                                    comment: comment,
                                    privacy: privacy,
                                    callDuration: callDuration,
                                    callresultdate: $("#calldate").val(),
                                    callStatus: callStatus,
                                    meetingDate: meetingDate,
                                    timeflag: timeflag,
                                    timer: timer
                            }, success: function (jsonString) {
                    var eqpEmpInfo = $.parseJSON(jsonString);
                            if (eqpEmpInfo.status == 'ok') {
//                                  $(obj).parent().parent().parent().parent().find("#appMsg").html("تم التسجيل بنجاح").show();
                    $(obj).parent().parent().parent().parent().find("#progress").hide();
                            $('#follow_up_content').css("display", "none");
                            $('#follow_up_content').bPopup().close();
                            try {
                            var isExists = false, rateText;                     
                            var dd = $("#clientRate").msDropdown().data("dd");
                            var nextActionText = $("#nextAction option:selected").text();
                            var callStatus = $("#callStatus option:selected").text();                 
                            //dd.destroy();
    //                                        $("#clientRate option").each(function(i){
    //                                            if(nextActionText === $(this).text()) {
    //                                                rateText = $(this).text();
    //                                                isExists = true;
    //                                            }                
            switch (nextActionText) {
                            case "Follow":
                                    case "Visit":
                                    case "Send Email":
                                    case "Send SMS":
                                    case "Send Offer":
                                    rateText = "Following up";
                                    isExists = true;
                                    break;
                                                        
                                    case "Wait":
                                    rateText = "Wait";
                                    isExists = true;
                                    break;
                                                        
                                    case "Hold":
                                    rateText = "Hold";
                                    isExists = true;
                                    break;
                                                        
                                    case "Wrong Number":
                                    rateText = "Wrong Number";
                                    isExists = true;
                                    break;
                                                        
                                    case "Closed":
                                    case "Not Serious":
                                    rateText = "Closed";
                                    isExists = true;
                                    break;
                                                        
                                    case "Not Interested":
                                    rateText = "Not interested";
                                    isExists = true;
                                    break;
                                                    
                                    case "Out of segment":
                                    rateText = "Out of segment";
                                    isExists = true;
                                    break;
                                                        
                                    case "Existing Owner":
                                    rateText = "Existing Owner";
                                    isExists = true;
                                    break;
                                                        
                                    case "Needs Ready Unit":
                                    rateText = "Needs Ready Unit";
                                    isExists = true;
                                    break;
                                                        
                                    case "Unreachable":
                                    rateText = "Unreachable";
                                    isExists = true;
                                    break;
                                    case "Unreachable WTS":
                                    rateText = "Unreachable WTS";
                                    isExists = true;
                                    break;
                                    case "Out of budget":
                                    rateText = "Out of budget";
                                    isExists = true;
                                    break;
                                    case "not answered":
                                    rateText = "not answered";
                                    isExists = true;
                                    break;
                                    
                                    case "No Answer":
                                    rateText = "No Answer";
                                    isExists = true;
                                    break;
                                    
                                    case "Fresh leads":
                                    rateText = "Fresh leads";
                                    isExists = true;
                                    break;
                                    
                                    case "RTM":
                                    rateText = "RTM";
                                    isExists = true;
                                    break;
                                    
                                    case "Interested":
                                    rateText = "Interested";
                                    isExists = true;
                                    break;
                                    
                                    case "Schedule meeting":
                                    rateText = "Schedule meeting";
                                    isExists = true;
                                    break;
                                    
                                    case "Follow after meeting":
                                    rateText = "Follow after meeting";
                                    isExists = true;
                                    break;
                                    
                                    case "Not clear":
                                    rateText = "Not clear";
                                    isExists = true;
                                    break;
                                    
                                    case "Reservation":
                                    rateText = "Reservation";
                                    isExists = true;
                                    break;
                                    
                                    case "Done deal":
                                    rateText = "Done deal";
                                    isExists = true;
                                    break;
                            }

                            var Exists = false, Statustxt;
                                    switch (callStatus) {
                            case "wrong number":
                                    Exists = false;
                                    break;
                                    case "answered":
                                    Exists = false;
                                    break;
                                    case "not answered":
                                    Statustxt = "Unreachable";
                                    Exists = true;
                                    break;
                            }
//                                        });
                            if (isExists){ 
                                    changeClientRate('<%=clientWbo.getAttribute("id")%>',rateText);
                            } else if (Exists) {
                            $("#clientRate option:contains(" + Statustxt + ")").attr('selected', true);
                                    changeClientRate('<%=clientWbo.getAttribute("id")%>',Statustxt);
                            }

                            $("#clientRate").msDropdown();
                            } catch (err) {}
                    } else if (eqpEmpInfo.status == 'no') {
                    $(obj).parent().parent().parent().parent().find("#progress").show();
                            $(obj).parent().parent().parent().parent().find("#appMsg").html("لم يتم التسجيل او هذا العميل غير موزع").show();
                    }
                    window.location.href = 'main.jsp';
                    }
                    });
            } else {
            $("#appTitleMsg").css("color", "white");
                    $("#appTitleMsg").text("أدخل عنوان المقابلة");
            }
            }
            obj.style.display = 'none';
            }
            function popupUserAppointment() {
            $('#user_appointment').css("display", "block");
                    $('#user_appointment').bPopup({
            easing: 'easeInOutSine',
                    speed: 400,
                    transition: 'slideDown'
            });
            }
            function saveUserAppointment(obj) {
            if ($("#userID").val() === null || $("#userID").val() === ""){
            alert("أختر موظف");
            } else if ($("#userComment").val() === null || $("#userComment").val() === ""){
            alert(" يجب إضافة تعليق ");
            } else {
            var clientID = $("#clientId").val();
                    var meetingDate = $("#userMeetingDate").val();
                    var appointmentPlace = $("#userAppointmentPlace").val();
                    var comment = $("#userComment").val();
                    $(obj).parent().parent().parent().parent().find("#progress").show();
                    $.ajax({
                    type: "post",
                            url: "<%=context%>/ClientServlet?op=saveUserAppointment",
                            data: {
                            clientID: clientID,
                                    userID: $("#userID").val(),
                                    appointmentPlace: appointmentPlace,
                                    comment: comment,
                                    meetingDate: meetingDate
                            }, success: function (jsonString) {
                    var result = $.parseJSON(jsonString);
                            if (result.status == 'ok') {
                    $("#userProgress").hide();
                            $('#user_appointment').css("display", "none");
                            $('#user_appointment').bPopup().close();
                    } else if (result.status == 'no') {
                    $("#userProgress").show();
                            $("#userAppointmentMsg").html("لم يتم التسجيل او هذا العميل غير موزع").show();
                    }
                    $("#userID").val("");
                            $("#userComment").val("");
                            $("#appointmentNo").html("0");
                    }
                    });
            }
            }
            function getAppointmentsNo() {
            var userID = $("#userID").val();
                    var meetingDate = $("#userMeetingDate").val();
                    if (userID !== '') {
            $.ajax({
            type: "post",
                    url: "<%=context%>/AppointmentServlet?op=getAppointmentsCountAjax",
                    data: {
                    userID: userID,
                            meetingDate: meetingDate.substring(0, 10)
                    }, success: function (jsonString) {
            var result = $.parseJSON(jsonString);
                    $("#appointmentNo").html(result.appointmentNo);
            }
            });
            }
            }

            function  resetfollowup(){
            $("#comment").val("");
                    //$("#callResult").val("<%=CRMConstants.CALL_RESULT_MEETING%>");
                    $('#callResult option["مقابلة"]').attr("checked", true);
            }

            function switchValue(displaied, hidded, displaiedlbl, hiddedlbl) {
            $("#" + displaied).show();
                    $("#" + hidded).hide();
                    $("#" + displaiedlbl).show();
                    $("#" + hiddedlbl).hide();
            }

            function hideAll(obj1, obj2, lbl1, lbl2) {
            $("#" + obj1).hide();
                    $("#" + obj2).hide();
                    $("#" + lbl1).hide();
                    $("#" + lbl2).hide();
            }

            function popupAddComment() {
            $(".submenu").hide();
                    $(".button_commen").attr('id', '0');
                    $("#commMsg").hide();
                    $("#addCommentArea").val("");
                    $('#add_comments').css("display", "block");
                    $('#add_comments').bPopup({
            easing: 'easeInOutSine',
                    speed: 400,
                    transition: 'slideDown'
            });
            }

            function saveComment(obj) {
            var clientId = $("#clientId").val();
                    var type = $(obj).parent().parent().parent().find($("#commentType")).val();
                    var comment = $("#addCommentArea").val();
                    var businessObjectType = $(obj).parent().parent().parent().find($("#businessObjectType")).val();
                    var title = $("#commentTitlePopup").val();
                    comment = title !== '' ? title + " " + comment : comment;
                    title = title !== '' ? title : "UL";
                    $(obj).parent().parent().parent().parent().find("#progress").show();
                    $.ajax({
                    type: "post",
                            url: "<%=context%>/CommentsServlet?op=saveComment",
                            data: {
                            clientId: clientId,
                                    type: type,
                                    comment: comment,
                                    businessObjectType: businessObjectType,
                                    option2: title,
                                    option1: '<%=ownerUserWbo != null ? (userWbo.getAttribute("userId").equals(ownerUserWbo.getAttribute("userId")) ? "UL" : ownerUserWbo.getAttribute("userId")) : "UL"%>' // option1 --> equal current owner id only if it is commented by anyone but owner
                            }, success: function (jsonString) {
                    var eqpEmpInfo = $.parseJSON(jsonString);
                            if (eqpEmpInfo.status == 'ok') {
                    $(obj).parent().parent().parent().parent().find("#commMsg").show();
                            $(obj).parent().parent().parent().parent().find("#progress").hide();
                            $('#add_comments').css("display", "none");
                            $('#add_comments').bPopup().close();
                            location.reload();
                    } else if (eqpEmpInfo.status == 'no') {
                    $(obj).parent().parent().parent().parent().find("#progress").show();
                    }
                    sendMessageByUser($("#userSocket").val(), $("#msgSocket").val());
                     
                    }
                    });
            }

            function popupAddPlanningAppointment() {
            $("#palnningTitleMsg").css("color", "");
                    $("#palnningTitleMsg").text("");
                    $("#palnningTitle").val("");
                    $("#palnningComment").val("");
                    $("#palnningMsg").hide();
                    $('#appointment_content').css("display", "block");
                    $('#appointment_content').bPopup({
            easing: 'easeInOutSine', //uses jQuery easing plugin
                    speed: 400,
                    transition: 'slideDown'
            });
            }

            function addClientEtcInfo() {
            $("#clntAge").val("");
                    $("#noOfKids").val("");
                    $("#school").val("");
                    $("#relg").val("");
                    $("#fSport").val("");
                    $("#fMusic").val("");
                    $("#ClubMem").val("");
                    $("#generalDesc").val("");
                    $('#clients-etc_info').css("display", "block");
                    $('#clients-etc_info').bPopup({
            easing: 'easeInOutSine', //uses jQuery easing plugin
                    speed: 400,
                    transition: 'slideDown'
            });
            }

            function saveAppoientment(obj) {
            var clientId = $("#clientId").val();
                    $("#palnningTitleMsg").css("color", "");
                    $("#palnningTitleMsg").text("");
                    var title = $(obj).parent().parent().parent().find($("#palnningTitle")).val();
                    var date = $(obj).parent().parent().parent().find($("#palnningDate")).val();
                    var appType = $(obj).parent().parent().parent().find("#note:checked").val();
                    var appointmentPlace = $(obj).parent().parent().parent().find("#appointmentPlace").val();
                    var comment = $(obj).parent().parent().parent().find("#palnningComment").val();
                    var note = "UL";
                    if (title.length > 0) {
            $.ajax({
            type: "post",
                    url: "<%=context%>/ClientServlet?op=saveAppointment",
                    data: {
                    clientId: clientId,
                            title: title,
                            date: date,
                            note: note,
                            appType: appType,
                            type: "1",
                            appointmentPlace: appointmentPlace,
                            comment: comment
                    }, success: function (jsonString) {
            var eqpEmpInfo = $.parseJSON(jsonString);
                    if (eqpEmpInfo.status == 'ok') {
            $('#overlay').hide();
                    $('#appointment_content').css("display", "none");
                    $('#appointment_content').bPopup().close();
            } else if (eqpEmpInfo.status == 'no') {
            $(obj).parent().parent().parent().parent().find("#progress").show();
                    $(obj).parent().parent().parent().parent().find("#palnningMsg").html("لم يتم التسجيل او هذا العميل غير موزع").show();
            }
            }
            });
            } else {
            $("#palnningTitleMsg").css("color", "white");
                    $("#palnningTitleMsg").text("أدخل عنوان المقابلة");
            }
            }

            function saveClientInfo(obj) {
            var clientId = $("#clientId").val();
                    var clntAge = $("#clntAge").val();
                    var noOfKids = $("#noOfKids").val();
                    var school = $("#school option:selected").val();
                    var relg = $("#relg option:selected").val();
                    var fSport = $("#fSport option:selected").val();
                    var fMusic = $("#fMusic option:selected").val();
                    var ClubMem = $("#ClubMem option:selected").val();
                    var marriageD = $("#marriageDate").val();
                    var generalDesc = $("#generalDesc").val();
                    $.ajax({
                    type: "post",
                            url: "<%=context%>/ClientServlet?op=saveExtraInfo",
                            data: {
                            clientId: clientId,
                                    clntAge: clntAge,
                                    noOfKids: noOfKids,
                                    school: school,
                                    relg: relg,
                                    fSport: fSport,
                                    fMusic: fMusic,
                                    ClubMem: ClubMem,
                                    generalDesc: generalDesc,
                                    marriageD: marriageD
                            }, success: function (jsonString) {
                    var eqpEmpInfo = $.parseJSON(jsonString);
                            if (eqpEmpInfo.status == 'ok') {
                    alert("Info Added Successfully");
                            location.reload();
                    } else if (eqpEmpInfo.status == 'no') {
                    alert("Info Not Saved");
                    }
                    }
                    });
            }

            function popupShowComments() {
            var url = "<%=context%>/CommentsServlet?op=showClientComments&clientId=" + "<%=clientWbo.getAttribute("id")%>" + "&objectType=1&random=" + (new Date()).getTime();
                    jQuery('#show_comments').load(url);
                    $('#show_comments').css("display", "block");
                    $('#show_comments').bPopup();
            }

            function getRateDate(obj) {
            $.ajax({
            type: "post",
                    url: "<%=context%>/ReportsServletThree?op=getRateDateAjax",
                    data: {
                    clientID: $("#clientId").val(),
                            rateID: $(obj).val()
                    }, success: function (jsonString) {
            var info = $.parseJSON(jsonString);
                    if (info.status == 'ok') {
            $("#clientRate_msdd").attr("title", info.date);
            } else {
            $("#clientRate_msdd").removeAttr("title");
            }
            }
            });
            }
            function openLocationsDialog(){
            divTag = $("#clientLocations");
                    $.ajax({
                    type: "post",
                            url: '<%=context%>/StoreServlet?op=getMyClientLocations',
                            data: {
                            clientID:'<%=clientWbo != null ? clientWbo.getAttribute("id") : ""%>',
                            }, success: function (data) {
                    divTag.html(data).dialog({
                    modal: true,
                            title: "مواقع العميل",
                            show: "fade",
                            hide: "explode",
                            width: 950,
                            position: {
                            my: 'center',
                                    at: 'center'
                            }, buttons: {
                    'Add Location':function(){
                    openInsertMapDialog('<%=clientWbo != null ? clientWbo.getAttribute("id") : ""%>');
                    },
                            'Close': function () {
                            $(this).dialog('close');
                            }

                    }
                    }).dialog('open');
                            $('#clientLocationPopup').dataTable({
                    bJQueryUI: true,
                            "bPaginate": false,
                            "bProcessing": true,
                            "bFilter": false
                    }).fadeIn(2000);
                    }, error: function (data) {
                    alert(data);
                    }
                    });
            }
            function openInsertMapDialog(clientID) {

            $.ajax({
            type: "POST",
                    url: "<%=context%>/ProjectServlet",
                    data: "op=insertClientLocation&clientID=" + clientID + "&type=add",
                    success: function (msg) {
                    var url = '<%=context%>/ProjectServlet?op=insertClientLocation&clientID=' + clientID + '';
                            var wind = window.open(url, '<fmt:message key="showmaps" />', "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no");
                            wind.focus();
                    }
            });
            }

        </script>

        <fieldset align=center class="set" style="width: 90%">
            <legend align="center">
                <font color="blue" size="6">
                    <fmt:message key="details" /> 
                </font>
            </legend>
            <%
                }

                if (clientWbo == null) {
            %>
            <b style="color: red">
                <%=noClientExistMsg%> 
            </b>
            <%
            } else {
            %>
            <div id="clientComplaints"></div>
            <div id="clientLocations"></div>

            <div style="margin-left: auto; margin-right: auto; width: 1100px;">
                <div id="toolbar" dir="<fmt:message key="dir"/>" style="padding: 4px; border: 1px solid #dfdfdf; border-radius: 3px; width: 1100px;">
                </div>
            </div>

            <script type="text/javascript">
                $(function () {
                $('#toolbar').w2toolbar({
                name: 'toolbar',
                        items: [
                <%
                    if (userPrevList.contains("EDIT")) {
                %>
                        {
                        type: 'html',
                                id: 'editClient',
                                html: function (item) {
                                var html = '<a href="#"><img style="height:35px;" src="images/user_red_edit.png" title="Edit" onclick="JavaScript: updateClientInformation();"/></a>';
                                        return html;
                                }
                        }, {
                        type: 'break'
                        },
                <%
                    }
                    if (userPrevList.contains("DATASHEET")) {
                %>
                        {
                        type: 'html',
                                id: 'printClient',
                                html: function (item) {
                                var html = '<a href="#"><img style="height:35px;" src="images/pdf_icon.gif" title="Datasheet" onclick="JavaScript: printClientInformation(this);"/></a>';
                                        return html;
                                }
                        }, {
                        type: 'break'
                        },
                <%
                    }
                    if (userPrevList.contains("STAR")) {
                %>
                        {
                        type: 'html',
                                id: 'unbookmarked',
                                hidden: <%=bookmarksList == null || !bookmarksList.isEmpty()%>,
                                html: function (item) {
                                var html = '<a href="#"><img style="height:35px;" src="images/star1.jpg" title="Bookmark" onclick="JavaScript: popupCreateBookmark(this, \x27<%=clientWbo.getAttribute("id")%>\x27);"/></a>';
                                        return html;
                                }
                        }, {
                        type: 'html',
                                id: 'bookmarked',
                                hidden: <%=bookmarksList != null && bookmarksList.isEmpty()%>,
                                html: function (item) {
                                var html = '<a href="#"><img style="height:35px;" src="images/star2.jpg" title="Bookmark Details" onclick="JavaScript: deleteBookmark(this, \x27<%=bookmarkId%>\x27, \x27<%=clientWbo.getAttribute("id")%>\x27);"/></a>';
                                        return html;
                                }
                        }, {
                        type: 'break'
                        },
                <%
                    }
                    if (userPrevList.contains("VIEW_FINANCIALS")) {
                %>
                        {
                        type: 'html',
                                id: 'finical',
                                html: function (item) {
                                var html = '<a href="#"><img style="height:35px;" src="images/finical-rebort.png" title="Financials" onclick="JavaScript: printClientFincancial(this);"/></a>';
                                        return html;
                                }
                        }, {
                        type: 'break'
                        },
                <%
                    }
                    if (userPrevList.contains("VIEW_CONTRACT")) {
                %>
                        {
                        type: 'html',
                                id: 'contract',
                                html: function (item) {
                                var html = '<a href="#"><img style="height:35px;" src="images/contract_icon.jpg" title="Contracts" onclick="JavaScript: viewClientContract();"/></a>';
                                        return html;
                                }
                        }, {
                        type: 'break'
                        },
                <%
                    }
                    if (userPrevList.contains("ATTACH_FILE")) {
                %>
                        {
                        type: 'html',
                                id: 'attachFile',
                                html: function (item) {
                                var html = '<a href="#"><img style="height:35px;" src="images/attach.png" title="Attach File" onclick="JavaScript: openAttachmentDialog(\x27<%=clientWbo.getAttribute("id")%>\x27, \x27client\x27);"/></a>';
                                        return html;
                                }
                        }, {
                        type: 'break'
                        },
                <%
                    }
                    if (userPrevList.contains("sms")) {
                %>
                        {
                        type: 'html',
                                id: 'sendSms1',
                                html: function (item) {
                                var html = '<a href="#" onclick="JavaScript: openSmsDialoge();"><img src="images/sms.png"style="height:35px;" title="<%=sendsmsT%>"/></a>';
                                        return html;
                                }
                        }, {
                        type: 'break'
                        },
                <%
                    }
                    if (userPrevList.contains("VIEW_GALLERY")) {
                %>
                        {
                        type: 'html',
                                id: 'gallery',
                                html: function (item) {
                                var html = '<a href="#"><img style="height:35px;" src="images/gallery.png" title="View Image" onclick="JavaScript: openGalleryDialog();"/></a>';
                                        return html;
                                }
                        }, {
                        type: 'break'
                        },
                <%
                    }
                    if (userPrevList.contains("RECOMMEND_CLIENT")) {
                %>
                        {
                        type: 'html',
                                id: 'recommend',
                                html: function (item) {
                                var html = '<a href="#"><img style="height:35px;" src="images/recommend_client.gif" title="Recommend Client" onclick="JavaScript: popupCreateClient();"/></a>';
                                        return html;
                                }
                        }, {
                        type: 'break'
                        },
                <%
                    }
                    if (isRecommend) {
                %>
                        {
                        type: 'html',
                                id: 'viewClient',
                                html: function (item) {
                                var html = '<a href="#"><img style="height:35px;" src="images/client_vip.png" title="Clients" onclick="JavaScript: popupClientsList();"/></a>';
                                        return html;
                                }
                        }, {
                        type: 'break'
                        },
                <%
                    }
                    if (userPrevList.contains("DELETE_CLIENT")) {
                %>
                        {
                        type: 'html',
                                id: 'deleteClient',
                                html: function (item) {
                                var html = '<a href="<%=context%>/ClientServlet?op=ConfirmDeleteClient&clientID=<%=clientWbo.getAttribute("id")%>&clientName=<%=((String) clientWbo.getAttribute("name")).replaceAll("\'", "").replaceAll("\"", "").trim()%>&clientNo=<%=clientWbo.getAttribute("clientNO")%>&fromPage=customSearch"><img style="height:35px;" src="images/icons/delete_ready.png" title="Delete"/></a>';
                                        return html;
                                }
                        }, {
                        type: 'break'
                        },
                <%
                    }
                    if (hasReservation) {
                %>
                        {
                        type: 'html',
                                id: 'reserved',
                                html: function (item) {
                                var html = '<a href="#"><img style="height:35px;" src="images/reserved_house.JPG" title="Reserved"/></a>';
                                        return html;
                                }
                        }, {
                        type: 'break'
                        },
                <%
                    }
                    if (userPrevList.contains("CLIENT_DETAILS")) {
                %>
                        {
                        type: 'html',
                                id: 'details',
                                html: function (item) {
                                var html = '<a href="#"><img style="height:35px;" src="images/communication.png" title="Client\x27s Details" onclick="JavaScript: viewClientCommunications();"/></a>';
                                        return html;
                                }
                        }, {
                        type: 'break'
                        },
                <%
                    }
                    if (userPrevList.contains("DIRECT_CALL")) {
                %>
                        {
                        type: 'html',
                                id: 'followup',
                                html: function (item) {
                                var html = '<a href="<%=context%>/ClientServlet?op=ViewClientMenu&clientNo=<%=clientWbo.getAttribute("clientNO")%>&clientID=<%=clientWbo.getAttribute("id")%>&button=directCall" ><img style="height:35px;" src="images/icons/follow_up.png" title="Direct Call"></a>';
                                        return html;
                                }
                        }, {
                        type: 'break'
                        },
                <%
                    }
                    if (userPrevList.contains("USER_APPOINTMENT")) {
                %>
                        {
                        type: 'html',
                                id: 'userAppointment',
                                html: function (item) {
                                var html = '<a href="JavaScript: popupUserAppointment();"><img style="height:25px;" src="images/icons/meeting.png" title="User Appointment"/></a>';
                                        return html;
                                }
                        }, {
                        type: 'break'
                        },
                <%
                    }
                    if (userPrevList.contains("ADD_COMMENT") && (userPrevList.contains("COMMENT_All_EMPLOYEES")
                            || (ownerUserWbo != null && userWbo.getAttribute("userId").equals(ownerUserWbo.getAttribute("userId"))))) {
                %>
                        {
                        type: 'html',
                                id: 'comment',
                                html: function (item) {
                                var html = '<a href="#"><img style="height:35px;" src="images/dialogs/comment_public.ico" title="Comment" onclick="JavaScript: popupAddComment();"/></a>';
                                        return html;
                                }
                        }, {
                        type: 'break'
                        },
                <%
                    }
                    if (userPrevList.contains("VIEW_COMMENTS")) {
                %>
                        {
                        type: 'html',
                                id: 'viewComment',
                                html: function (item) {
                                var html = '<a href="#"><img style="height:35px;" src="images/dialogs/comment_channel.png" title="List Comments" onclick="JavaScript: popupShowComments();"/></a>';
                                        return html;
                                }
                        }, {
                        type: 'break'
                        },
                <%
                    }
                    if (userPrevList.contains("CLIENT_APPOINTMENT")) {
                %>
                        {
                        type: 'html',
                                id: 'appointment',
                                html: function (item) {
                                var html = '<a href="#"><img style="height:35px;" src="images/dialogs/planning.png" title="Plan Appointment" onclick="JavaScript: popupAddPlanningAppointment();"/></a>';
                                        return html;
                                }
                        }, {
                        type: 'break'
                        },
                <%
                    }
                    if (userPrevList.contains("LIST_APPOINTMENTS")) {
                %>
                        {
                        type: 'html',
                                id: 'viewAppointment',
                                html: function (item) {
                                var html = '<a href="#"><img style="height:35px;" src="images/icons/calendar-256.png" title="List Appointments" onclick="JavaScript: popupClientAppointments();"/></a>';
                                        return html;
                                }
                        }, {
                        type: 'break'
                        },
                <%
                    }
                %>
                        //  {
                        //      type: 'html',
                        //      id: 'myAppointment',
                        //      html: function (item) {
                        //          var html = '<a href="#"><img style="height:35px;" src="images/icons/my-appointments.png" title="My Appointments" onclick="JavaScript: popupMyClientAppointments();"/></a>';
                        //          return html;
                        //      }
                        //  }, {
                        //      type: 'break'
                        //  },
                <%
                    if (userPrevList.contains("FUTURE_APPOINTMENTS")) {
                %>
                        {
                        type: 'html',
                                id: 'futureAppointment',
                                html: function (item) {
                                var html = '<a href="#"><img style="height:35px;" src="images/icons/future_appointment.png" title="List Future Appointments" onclick="JavaScript: popupFutureClientAppointments();"/></a>';
                                        return html;
                                }
                        }, {
                        type: 'break'
                        },
                <%
                    }
                    if (userPrevList.contains("MAIL_BOX")) {
                %>
                        {
                        type: 'html',
                                id: 'mailbox',
                                html: function (item) {
                                var html = '<a href="#"><img style="height:35px;" src="images/dialogs/mailbox.png" title="MailBox" onclick="JavaScript: popupMailBox();"/></a>';
                                        return html;
                                }
                        }, {
                        type: 'break'
                        },
                <%
                    }
                    if (userPrevList.contains("ADD_CAMPAIGN")) {
                %>
                        {
                        type: 'html', id: 'campaign',
                                html: function (item) {
                                var html = '<a href="#"><img style="height:35px;" src="images/icons/add_event2.png" title="Add Campaign" onclick="JavaScript: popupAddCampaign();"/></a>';
                                        return html;
                                }
                        }, {
                        type: 'break'
                        },
                <%
                    }
                    if (userPrevList.contains("CLIENT_REQUESTS")) {
                %>
                        {
                        type: 'html', id: 'requests',
                                html: function (item) {
                                var html = '<a href="#"><img style="height:35px;" src="images/icons/listing.png" title="View Client\x27s Requests" onclick="JavaScript: popupViewComplaints();"/></a>';
                                        return html;
                                }
                        }, {
                        type: 'break'
                        },
                <%
                    }
                    if (userPrevList.contains("OPEN_CLIENT")) {
                %>
                        {
                        type: 'html', id: 'session',
                                html: function (item) {
                                var html = '<a href="<%=context%>/ClientServlet?op=ViewClientMenu&clientNo=<%=clientWbo.getAttribute("clientNO")%>&clientID=<%=clientWbo.getAttribute("id")%>"><img style="height:35px;" src="images/session-icon.png" title="Open Session"/></a>';
                                        return html;
                                }
                        }, {
                        type: 'break'
                        },
                <%
                    }
                    if (userPrevList.contains("NEW_REQUEST")) {
                %>
                        {
                        type: 'html', id: 'newRequest',
                                html: function (item) {
                                var html = '<a href="#"><img style="height:35px;" src="images/icons/icon-claims.png" title="New Request / inquiry" onclick="JavaScript: openInNewWindow(\x27<%=context%>/ClientServlet?op=getNewRequest&clientID=<%=clientWbo.getAttribute("id")%>\x27);"/></a>';
                                        return html;
                                }
                        }, {
                        type: 'break'
                        },
                <%
                    }
                    if (userPrevList.contains("VIEW_UNITS")) {
                %>
                        {
                        type: 'html', id: 'unit',
                                html: function (item) {
                                var html = '<a href="#"><img style="height:35px;" src="images/icons/units.png" title="Units" onclick="JavaScript: window.location.href = \x27<%=context%>/IssueServlet?op=clientUnits&clientID=<%=clientWbo.getAttribute("id")%>\x27;"/></a>';
                                        return html;
                                }
                        }, {
                        type: 'break'
                        },
                <%
                    }
                    if (userPrevList.contains("LEGAL_DISPUTE")) {
                %>

                        {
                        type: 'html', id: 'legaldispute',
                                html: function (item) {
                                var html = '<a href="#" onclick="JavaScript: openLegalDisputeDialoge();"><img src="images/legaldispute1.png"style="height:35px;" title="<%=legalDispute%>"/></a>';
                                        return html;
                                }
                        }, {
                        type: 'break'
                        },
                <%                
                    }
                    if (userPrevList.contains("client_status_change")) {
                %>

                        {
                        type: 'html', id: 'statusClient',
                                html: function (item) {
                                var html = '<a href="#" onclick="JavaScript: openStatusClientDialoge();"><img src="images/change.png"style="height:35px;" title="Client Status"/></a>';
                                        return html;
                                }
                        }, {
                        type: 'break'
                        },
                
                <%                
                    }
                    if (userPrevList.contains("client_status_change")) {
                %>

                        {
                        type: 'html', id: 'sentClientWifi',//openStatusClientDialoge
                                html: function (item) {
                                var html = '<a href="#" onclick="JavaScript: sentClientWifi();"><img src="images/change.png"style="height:35px;" title="Client Status"/></a>';
                                        return html;
                                }
                        }, {
                        type: 'break'
                        },
                
                <%
                    }
                    if (userPrevList.contains("CLIENT_EMAIL")) {
                %>
                        {
                        type: 'html', id: 'email',
                                html: function (item) {
                                var html = '<a href="#"><img style="height:35px;" src="images/icons/email.png" title="Send Email" onclick="JavaScript: openEmailDialog(\x27<%=((String) clientWbo.getAttribute("name")).replaceAll("\'", "").replaceAll("\"", "").trim()%>\x27,\x27<%=clientWbo.getAttribute("email")%>\x27,\x27<%=sendEmail%>\x27);"/></a>';
                                        return html;
                                }
                        }, {
                        type: 'break'
                        },
                <%
                    }
                    if (userPrevList.contains("CLIENT_ETC")) {
                %>
                        {
                        type: 'html', id: 'etcInfo',
                                html: function (item) {
                                var html = '<a href="#"><img style="height:35px;" src="images/icons/etc.png" title="Client Closer Lock" onclick="JavaScript: addClientEtcInfo();"/></a>';
                                        return html;
                                }
                        }, {
                        type: 'break'
                        },
                <%
                    }
                    if (userPrevList.contains("VIEW_FILES")) {
                %>
                        {
                        type: 'html',
                                id: 'viewFiles',
                                html: function (item) {
                                var html = '<a href="#"><img style="height:35px;" src="images/Foldericon.png" title="View Files" onclick="JavaScript: showAttachedFiles(\x27<%=clientWbo.getAttribute("id")%>\x27);"/></a>';
                                        return html;
                                }
                        }, {
                        type: 'break'
                        },
                <%
                    }

                    if (userPrevList.contains("CLIENT_SURVEY")) {
                %>
                        {
                        type: 'html', id: 'survey',
                                html: function (item) {
                                var html = '<a href="#"><img style="height:35px;" src="images/icons/question.png" title="Client Survey" onclick="JavaScript: openClientSurveyPopup();"/></a>';
                                        return html;
                                }
                        }, {
                        type: 'break'
                        },
                <%
                    }
                    if (userPrevList.contains("CLIENT_LOCATIONS")) {
                %>
                        {
                        type: 'html', id: 'newMap',
                                html: function (item) {
                                var html = '<a href="#"><img style="height:35px;" src="images/icons/region.png"  title="<fmt:message key="showmaps" />" onclick="JavaScript:openLocationsDialog();"/></a>';
                                        return html;
                                }
                        }, {
                        type: 'break'
                        },
                <%
                    }
                %>
                        ], onClick: function (event) {}
                });
                });                </script>
            <input type="hidden" id="clntNm" value="<%=((String) clientWbo.getAttribute("name")).trim()%>">

                <table id="myTable" border="0px" dir="<%=dir%>" class="table" style="width:<fmt:message key="width"/>;text-align: right;margin-bottom: 10px !important;margin-left: auto;margin-right: auto;" >
                    <tr>
                        <td class="td" colspan="2" style="text-align: center;">

                        </td>
                    </tr>

                    <tr>
                        <td class="td">
                            <table style="width: 100%;">
                                <tr >
                                    <td class="td titleTD" colspan="4" style="padding: 10px 0px 10px 10px ;border-radius: 5px;background-color: #dfdfdf;text-align: left;color: #000;font-size: 20px;font-weight: bold">
                                        Information Client 
                                    </td>
                                </tr>
                                   <tr>
                                    <td></td>
                                </tr> 
                                <tr>
                                    <td class="td titleTD" style="background-color: #dfdfdf;text-align: center;color: white;border: 3px solid white;">
                                        <p class="cairo" style="width: 120px;vertical-align: middle;font-weight: bold;margin: 0px"><fmt:message key="clientRating" /> </p>
                                    </td>

                                    <td>
                                        <%
                                            if (privilegesList.contains("CLIENT_RATING")) {
                                        %>
                                        <select name="clientRate" id="clientRate" style="width: 200px; direction: rtl;"
                                                onchange="JavaScript: changeClientRate('<%=clientWbo.getAttribute("id")%>');" <%=clientRateWbo == null ? "disabled" : ""%>
                                                onmouseover="JavaScript: getRateDate(this);">
                                            <option value="">Select Client Rate</option>
                                            <%
                                                for (WebBusinessObject rateWbo : ratesList) {
                                            %>
                                            <option value="<%=rateWbo.getAttribute("projectID")%>" <%=clientRateWbo != null && rateWbo.getAttribute("projectID").equals(clientRateWbo.getAttribute("rateID")) ? "selected" : ""%>  data-image="images/msdropdown/<%="UL".equals(rateWbo.getAttribute("optionThree")) ? "black" : rateWbo.getAttribute("optionThree")%>.png"><%=rateWbo.getAttribute("projectName")%></option>
                                            <%
                                                }
                                            %>
                                        </select>
                                        <%
                                        } else {
                                            if (clientRateWbo != null && rateTempWbo != null) {
                                        %>
                                        <%=rateTempWbo.getAttribute("projectName")%> <img src="images/msdropdown/<%="UL".equals(rateTempWbo.getAttribute("optionThree")) ? "black" : rateTempWbo.getAttribute("optionThree")%>.png"/> 
                                        <%
                                        } else {
                                        %>
                                        <fmt:message key="noRating" /> 
                                        <%
                                                }
                                            }
                                        %>
                                    </td>
                                    
                                </tr>

                                <tr>
                                    <%if (!legalClient.equals("")) {%>
                                    <td class="td titleTD" style="vertical-align: middle;background-color: #dfdfdf;text-align: center;color: black;border: 3px solid white">
                                        <p class="cairo" style="width: 120px;vertical-align: middle;font-weight: bold;margin: 0px">Legal</p>
                                    </td>
                                    <%
                                        String styleEr = "";
                                        if (!legalClient.equals("")) {
                                            styleEr = "background-color: crimson";
                                            }%>
                                    <td class="td dataTD" style="<%=styleEr%>">
                                        <label STYLE="    font-size: x-large;color: white;line-height: normal;">
                                            <%=legalClient%> 
                                        </label>
                                    </td>
                                        <% } %>

                                    <td class="td titleTD" style="vertical-align: middle;background-color: #dfdfdf;text-align: center;color: black;border: 3px solid white">
                                        <p class="cairo" style="width: 120px;vertical-align: middle;font-weight: bold;margin: 0px">Client Status </p>
                                    </td>

                                    <td class="td dataTD">
                                        <% String currentStatusImg = (String) clientWbo.getAttribute("currentStatus");
                                           if (currentStatusImg.equals("11")) {%>
                                        <img src="images/icons/userData.png"style="height:35px;" title="<%=client%>"/>
                                        <% } else if (currentStatusImg.equals("12")) {%>
                                        <img src="images/client.png"style="height:35px;" title="<%=possible%>"/>
                                        <% } else if (currentStatusImg.equals("86")) {%>
                                        <img src="images/no_contract.png"style="height:35px;" title="<%=chance%>"/>
                                        <% } else if (currentStatusImg.equals("87")) {%>
                                        <img src="images/icons/negotiation.png"style="height:35px;" title="<%=oncontact%>"/>
                                        <% }%>
                                    </td>
                                </tr>

                                <tr>
                                     <td class="td titleTD" style="background-color: #dfdfdf;text-align: center;color: white;border: 3px solid white;">
                                        <p class="cairo" style="width: 120px;vertical-align: middle;font-weight: bold;margin: 0px"><fmt:message key="clientname" /></p>
                                    </td>

                                    <td class="td dataTD">
                                        <label>
                                            <%=clientWbo.getAttribute("name")%> 
                                        </label>

                                        <input type="hidden" id="hideName" value="<%=((String) clientWbo.getAttribute("name")).trim()%>" />
                                        <%
                                            String mail = "";
                                            if (clientWbo.getAttribute("email") != null) {
                                                mail = (String) clientWbo.getAttribute("email");
                                            }
                                        %>

                                        <input type="hidden" id="hideEmail" value="<%=mail%>" />
                                        <input type="hidden" id="clientId" name="clientId" value="<%=clientWbo.getAttribute("id")%>"/>
                                    </td>

                                     <td class="td titleTD" style="background-color: #dfdfdf;text-align: center;color: white;border: 3px solid white;">
                                         <p class="cairo" style="width: 120px;vertical-align: middle;font-weight: bold;margin: 0px"><fmt:message key="clientid" /> </p>
                                    </td>

                                    <td class="td dataTD">
                                        <label >
                                            <%=clientWbo.getAttribute("clientNO")%> 
                                        </label>
                                    </td>
                                </tr>
                                        
                                <tr>
                                    <td class="td titleTD" style="vertical-align: middle;background-color: #dfdfdf;text-align: center;color: black;border: 3px solid white">
                                        <p class="cairo" style="width: 120px;vertical-align: middle;font-weight: bold;margin: 0px"><fmt:message key="mobile"/></p>
                                    </td>

                                    <td class="td dataTD">
                                        <%
                                            if (hasCallCenter.equals("1")) {
                                        %>
                                        <a href="zoiper://<%=mobile%>" style="font-size: 14px;" title="<fmt:message key="call"/>"><%=mobile%><img src="images/icons/click_to_call.png" style="height: 20px; float: left;" title="<fmt:message key="call"/>"/></a>
                                        <a href="https://web.whatsapp.com/send?phone=2<%=mobile%>" target="_blank" title="<%=localWhatsapp%>"><img style="float: left;margin-left: 7;" width="5%" src="images/whatsappIcon.png"/></a>
                                        <%
                                        } else {
                                        %>
                                        <a href="tel:+02 <%=mobile%>" style="font-size: 14px;"><%=mobile%>&nbsp;<img src="images/icons/click_to_call.png" style="height: 20px; float: left;" title="<fmt:message key="call"/>"/></a>
                                        <a href="https://web.whatsapp.com/send?phone=2<%=mobile%>" target="_blank" title="<%=localWhatsapp%>"><img style="float: left;margin-left: 7" width="5%" src="images/whatsappIcon.png"/></a>

                                        <%
                                            }
                                        %>
                                    </td>
                                    <td class="td titleTD" style="vertical-align: middle;background-color: #dfdfdf;text-align: center;color: black;border: 3px solid white">
                                        <p class="cairo" style="width: 120px;vertical-align: middle;font-weight: bold;margin: 0px">International No.</p>
                                    </td>

                                    <td class="td dataTD">
                                        <%
                                            if (hasCallCenter.equals("1")) {
                                        %>
                                        <a href="zoiper://<%=interPhone%>" style="font-size: 14px;" title="<fmt:message key="call"/>"><%=interPhone%><img src="images/icons/click_to_call.png" style="height: 20px; float: left;" title="<fmt:message key="call"/>"/></a>
                                        <% if (!interPhone.isEmpty() && !interPhone.equalsIgnoreCase("ul") && !interPhone.equals(mobile)) {%><a href="https://web.whatsapp.com/send?phone=<%=interPhone.isEmpty() ? "" : interPhone.substring(2, interPhone.length())%>" target="_blank" title="<%=interWhatsapp%>"></a><img style="float: left;margin-left: 7;" width="5%" src="images/whatsappIcon2.png"/><%}%>
                                        <%
                                        } else {
                                        %>
                                        <a href="#" onclick="JavaScript: noCallCenter();" style="font-size: 14px;"><%=interPhone%>&nbsp;<img src="images/icons/click_to_call.png" style="height: 20px; float: left;" title="<fmt:message key="call"/>"/></a>
                                        <% if (!interPhone.isEmpty() && !interPhone.equalsIgnoreCase("ul") && !interPhone.equals(mobile)) {%><a href="https://web.whatsapp.com/send?phone=<%=interPhone.substring(2, interPhone.length())%>" target="_blank" title="<%=interWhatsapp%>"></a><img style="float: left;margin-left: 7;" width="5%" src="images/whatsappIcon2.png"/><%}%>
                                        <%
                                            }
                                        %>
                                    </td>    
                                </tr>
                                <TR>
                                    <td class="td titleTD" style="background-color: #dfdfdf;text-align: center;color: white;border: 3px solid white;">
                                        <p class="cairo" style="width: 120px;vertical-align: middle;font-weight: bold;margin: 0px"><fmt:message key="phone"/></p>
                                    </td>

                                    <td class="td dataTD">
                                        <%
                                            if (hasCallCenter.equals("1")) {
                                        %>
                                        <a href="zoiper://<%=phoneNo%>" style="font-size: 14px;" title="<fmt:message key="call"/>"><%=phoneNo%><img src="images/icons/click_to_call.png" style="height: 20px; float: left;" title="<fmt:message key="call"/>"/></a>
                                        <%
                                        } else {
                                        %>
                                        <a href="#" onclick="JavaScript: noCallCenter();" style="font-size: 14px;"><%=phoneNo%>&nbsp;<img src="images/icons/click_to_call.png" style="height: 20px; float: left;" title="<fmt:message key="call"/>"/></a>
                                        <%
                                            }
                                        %>
                                    </td>
                                    
                                    <td class="td titleTD" style="background-color: #dfdfdf;text-align: center;color: white;border: 3px solid white;">
                                        <p class="cairo" style="width: 120px;vertical-align: middle;font-weight: bold;margin: 0px"><fmt:message key="gender" /></p>
                                    </td>
                                    <td class="td dataTD">
                                        <label>
                                            <%=clientWbo.getAttribute("gender")%> 
                                        </label>
                                    </td>
                                </tr>
                                        
                                <tr> 
                                    <td class="td titleTD" style="vertical-align: middle;background-color: #dfdfdf;text-align: center;color: black;border: 3px solid white">
                                        <p class="cairo" style="width: 120px;vertical-align: middle;font-weight: bold;margin: 0px"><fmt:message key="address" /></p>
                                    </td>

                                    <td class="td dataTD">
                                        <label>
                                            <%=clientWbo.getAttribute("address") != null && !clientWbo.getAttribute("address").equals("UL") ? clientWbo.getAttribute("address") : ""%> 
                                        </label>
                                    </td>
                                        
                                        <td class="td titleTD" style="vertical-align: middle;background-color: #dfdfdf;text-align: center;color: black;border: 3px solid white">
                                            <p class="cairo" style="width: 120px;vertical-align: middle;font-weight: bold;margin: 0px">National ID</p>
                                    </td>

                                    <td class="td dataTD">
                                        <label>
                                            <%=clientWbo.getAttribute("clientSsn") != null && !clientWbo.getAttribute("clientSsn").equals("UL") ? clientWbo.getAttribute("clientSsn") : ""%> 
                                        </label>
                                    </td>
                                </tr>
                                        
                                <TR>
                                    <td class="td titleTD" style="background-color: #dfdfdf;text-align: center;color: white;border: 3px solid white;">
                                        <p class="cairo" style="width: 120px;vertical-align: middle;font-weight: bold;margin: 0px"><fmt:message key="birthdate" /></p>
                                    </td>
                                    <td class="td dataTD">
                                        <%
                                            String birthDateStr = "";
                                            if (clientWbo.getAttribute("birthDate") != null) {
                                                birthDateStr = ((String) clientWbo.getAttribute("birthDate")).split(" ")[0];
                                            }
                                        %>

                                        <label>
                                            <%=birthDateStr%> 
                                        </label>
                                    </td>
                                        
                                    <td class="td titleTD" style="background-color: #dfdfdf;text-align: center;color: white;border: 3px solid white;">
                                        <p class="cairo" style="width: 120px;vertical-align: middle;font-weight: bold;margin: 0px"><fmt:message key="job" /> </p>
                                    </td>

                                    <td class="td dataTD">
                                        <%
                                            String jobName = "";
                                            TradeMgr tradeMgr = TradeMgr.getInstance();
                                            if (clientWbo.getAttribute("job") != null && !clientWbo.getAttribute("job").equals("")) {
                                                String jobCode = (String) clientWbo.getAttribute("job");
                                                WebBusinessObject wbo5 = new WebBusinessObject();
                                                wbo5 = tradeMgr.getOnSingleKey(jobCode);
                                                if (wbo5 != null) {
                                                    jobName = (String) wbo5.getAttribute("tradeName");
                                                } else {
                                                    if (stat.equals("En")) {
                                                        jobName = "No choice";
                                                    } else {
                                                        jobName = "لم يتم الإختيار";
                                                    }
                                                }
                                            }
                                        %>
                                        <label>
                                            <%=jobName%> 
                                        </label>
                                    </td>
                                </TR>  

                                <tr>
                                    <td class="td titleTD" style="vertical-align: middle;background-color: #dfdfdf;text-align: center;color: black;border: 3px solid white">
                                        <p class="cairo" style="width: 120px;vertical-align: middle;font-weight: bold;margin: 0px"><fmt:message key="email" /></p>
                                    </td>

                                    <td class="td dataTD">
                                        <label>
                                            <%=clientWbo.getAttribute("email") != null && !clientWbo.getAttribute("email").equals("UL") ? clientWbo.getAttribute("email") : ""%> 
                                        </label>
                                    </td>

                                    <td class="td titleTD" style="vertical-align: middle;background-color: #dfdfdf;text-align: center;color: black;border: 3px solid white">
                                            <p class="cairo" style="width: 120px;vertical-align: middle;font-weight: bold;margin: 0px"><fmt:message key="region" /> 
                                    </td>

                                    <td class="td dataTD" >
                                        <%
                                            String regionName = "";
                                            WebBusinessObject wbo_ = new WebBusinessObject();
                                            wbo_ = projectMgr.getOnSingleKey((String) clientWbo.getAttribute("region"));
                                            if (wbo_ != null) {
                                                regionName = (String) wbo_.getAttribute("projectName");
                                            } else {
                                                regionName = (String) clientWbo.getAttribute("region");
                                            }
                                        %>

                                        <label>
                                            <%=regionName%> 
                                        </label>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="td titleTD" style="background-color: #dfdfdf;text-align: center;color: white;border: 3px solid white;">
                                        <p class="cairo" style="width: 120px;vertical-align: middle;font-weight: bold;margin: 0px"><fmt:message key="notes" /></p>
                                    </td>

                                    <td class="td dataTD" style="text-align: <fmt:message key="align" /> ">
                                        <p><%= clientWbo.getAttribute("description") != null && !((String) clientWbo.getAttribute("description")).equals("UL") ? clientWbo.getAttribute("description") : "&nbsp;"%></p>
                                    </td>
                                </tr>
                                <tr>
                                    <td></td>
                                </tr>        
                                        
                                <tr>
                                    <td class="td titleTD" colspan="4" style="padding: 10px 0px 10px 10px ;border-radius: 5px;background-color: #dfdfdf;text-align: left;color:  #000;font-size: 20px;font-weight: bold">
                                        Related Client
                                    </td>
                                </tr>
                                <tr>
                                    <td></td>
                                </tr>
                                <tr>
                                     <td class="td titleTD" style="background-color: #dfdfdf;text-align: center;color: white;border: 3px solid white;">
                                        <p class="cairo" style="width: 120px;vertical-align: middle;font-weight: bold;margin: 0px"><fmt:message key="clientname" /></p>
                                    </td>

                                    <td class="td dataTD">
                                        <% String clientId2 = ClientMgr.getInstance().getByKeyColumnValue("key6", clientWbo.getAttribute("id").toString(), "key");
                                           String client2 = ClientMgr.getInstance().getByKeyColumnValue("key6", clientWbo.getAttribute("id").toString(), "key5"); 
                                           String phone2 = ClientMgr.getInstance().getByKeyColumnValue("key6", clientWbo.getAttribute("id").toString(), "key4"); 
                                           
                                        %>
                                        <% if(client2 != null){ %>
                                        <a href="<%=context%>/ClientServlet?op=clientDetails&clientId=<%=clientId2%>" target="_black">
                                            <%=client2%>
                                        </a>
                                         <% } else { %>
                                         No Data
                                         <% } %>
                                    </td>

                                     <td class="td titleTD" style="background-color: #dfdfdf;text-align: center;color: white;border: 3px solid white;">
                                         <p class="cairo" style="width: 120px;vertical-align: middle;font-weight: bold;margin: 0px"><fmt:message key="clientid" /> </p>
                                    </td>

                                    <td class="td dataTD">
                                        <% if(phone2 != null){ %>
                                        <a href="<%=context%>/ClientServlet?op=clientDetails&clientId=<%=clientId2%>" target="_black">
                                            <%=phone2%>
                                        </a>
                                         <% } else { %>
                                         No Data
                                         <% } %>
                                    </td>
                                </tr>    
                                    
                                <tr>
                                    <td></td>
                                </tr>        
                                        
                                <tr>
                                    <td class="td titleTD" colspan="4" style="padding: 10px 0px 10px 10px ;border-radius: 5px;background-color: #dfdfdf;text-align: left;color: #000;font-size: 20px;font-weight: bold">
                                        Information Know Us / Broker / Personal /Social Media / Campaign
                                    </td>
                                </tr>
                                <tr>
                                    <td></td>
                                </tr>

                                <tr>
                                    <td class="td titleTD" style="background-color: #dfdfdf;text-align: center;color: white;border: 3px solid white;">
                                        <p class="cairo" style="width: 120px;vertical-align: middle;font-weight: bold;margin: 0px">Name</p> 
                                    </td>

                                    <td class="td dataTD">
                                        <label>
                                            <%
                                                if (clientWbo.getAttribute("partner") != null && !clientWbo.getAttribute("partner").equals("") && !clientWbo.getAttribute("partner").equals("UL")) {
                                            %>
                                            <%=clientWbo.getAttribute("partner")%> 
                                            <%
                                            } else {
                                            %>

                                            <%
                                                }
                                            %>
                                        </label>
                                    </td>

                                    <td class="td titleTD" style="background-color: #dfdfdf;text-align: center;color: white;border: 3px solid white;">
                                        <p class="cairo" style="width: 120px;vertical-align: middle;font-weight: bold;margin: 0px">Phone</p>
                                    </td>


                                    <td class="td dataTD">
                                        <label>
                                            <%=clientWbo.getAttribute("matiralStatus")%> 
                                        </label>
                                    </td>

                                </tr>

                                <tr>
                                    
                                    <td class="td titleTD" style="vertical-align: middle;background-color: #dfdfdf;text-align: center;color: black;border: 3px solid white">
                                        <p class="cairo" style="width: 120px;vertical-align: middle;font-weight: bold;margin: 0px"><fmt:message key="knowUs"/></p>
                                    </td>

                                    <td class="td dataTD">
                                        <%=clientSeasonWbo != null ? clientSeasonWbo.getAttribute("arabicName") : ""%> 
                                    </td>
                                    
                                    <td class="td titleTD" style="vertical-align: middle;background-color: #dfdfdf;text-align: center;color: black;border: 3px solid white">
                                        <p class="cairo" style="width: 120px;vertical-align: middle;font-weight: bold;margin: 0px">Campaign/Broker</p>
                                    </td>

                                    <td class="td dataTD">
                                        <label>
                                            <%
                                                if (clientCampaignsList != null) {
                                                    for (WebBusinessObject clientCampaign : clientCampaignsList) {
                                            %>
                                            <%=clientCampaign.getAttribute("campaignTitle")%>
                                            <%
                                                    }
                                                }
                                            %>
                                        </label>
                                    </td>
                                </tr>
                                  
                                <tr>
                                    <td></td>
                                </tr>        
                                        
                                <tr>
                                    <td class="td titleTD" colspan="4" style="padding: 10px 0px 10px 10px ;border-radius: 5px;background-color: #dfdfdf;text-align: left;color:  #000;font-size: 20px;font-weight: bold">
                                        Comments
                                    </td>
                                </tr>
                                <tr>
                                    <td></td>
                                </tr>        

                                <tr>
                                    <td class="td titleTD" style="background-color: #dfdfdf;text-align: center;color: white;border: 3px solid white;">
                                        <p class="cairo" style="width: 120px;vertical-align: middle;font-weight: bold;margin: 0px">Last Comment Emp.</p> 
                                    </td>

                                    <td class="td dataTD" style="vertical-align: top;">
                                        <table width="100%">
                                            <%
                                                String lastAppointment = ClientMgr.getInstance().getLastAppointment(clientWbo.getAttribute("id").toString());
                                                if (lastAppointment == null) {
                                            %>
                                            <tr>
                                                <td class="td dataTD">
                                                    <fmt:message key="nodata"/>
                                                </td>
                                            </tr>
                                            <%
                                            } else {
                                            %>
                                            <tr>
                                                <td class="td dataTD">
                                                     <%=lastAppointment%>
                                                </td>
                                            </tr>
                                            <%
                                                }
                                            %>
                                        </table>
                                    </td>
                                    
                                    <td class="td titleTD" style="background-color: #dfdfdf;text-align: center;color: white;border: 3px solid white;">
                                        <p class="cairo" style="width: 120px;vertical-align: middle;font-weight: bold;margin: 0px">Last Comment CS.</p>
                                    </td>

                                    <td class="td dataTD" style="vertical-align: top;">
                                        <table width="100%">
                                            <%
                                                String lastComment = ClientMgr.getInstance().getLastComment(clientWbo.getAttribute("id").toString());
                                                if (lastComment != null) {
                                            %>
                                            <tr>
                                                <td class="td dataTD" style="direction: rtl;">
                                                    <%=lastComment%> 
                                                </td>
                                            </tr>
                                            <%
                                            } else {
                                            %>
                                            <tr>
                                                <td class="td dataTD">
                                                    <fmt:message key="nodata"/> 
                                                </td>
                                            </tr>
                                            <%
                                                }
                                            %>
                                        </table>
                                    </td>
                                </tr>
                                        
                                <tr>
                                    <td></td>
                                </tr>        
                                        
                                <tr>
                                    <td class="td titleTD" colspan="4" style="padding: 10px 0px 10px 10px ;border-radius: 5px;background-color: #dfdfdf;text-align: left;color:  #000;font-size: 20px;font-weight: bold">
                                        Customer Dynamics
                                    </td>
                                </tr>
                                <tr>
                                    <td></td>
                                </tr>         
                                        
                                <%
                                    userMgr = UserMgr.getInstance();
                                    if (clientWbo != null) {
                                        if (clientWbo.getAttribute("currentStatus") != null) {
                                            String currentStatus = (String) clientWbo.getAttribute("currentStatus");
                                            if (currentStatus.equals("11")) {
                                                currentStatus = client;
                                            } else if (currentStatus.equals("12")) {
                                                currentStatus = possible;
                                            } else if (currentStatus.equals("86")) {
                                                currentStatus = chance;
                                            } else if (currentStatus.equals("87")) {
                                                currentStatus = oncontact;
                                            }
                                %>
                                
                                <%
                                    }
                                    userWbo = userMgr.getOnSingleKey((String) clientWbo.getAttribute("createdBy"));
                                    String createdBy = userWbo != null ? (String) userWbo.getAttribute("fullName") : "";
                                %>
                                <tr>
                                    <td class="td titleTD" style="background-color: #dfdfdf;text-align: center;color: white;border: 3px solid white;">
                                        <p class="cairo" style="width: 120px;vertical-align: middle;font-weight: bold;margin: 0px"><fmt:message key="source" /></p>
                                    </td>

                                    <td class="td dataTD">
                                        <%=createdBy%> 
                                    </td>

                                    <td class="td titleTD" style="background-color: #dfdfdf;text-align: center;color: white;border: 3px solid white;">
                                        <p class="cairo" style="width: 120px;vertical-align: middle;font-weight: bold;margin: 0px"><fmt:message key="signindate" /></p>
                                    </td>

                                    <td class="td dataTD">
                                        <%=clientWbo.getAttribute("creationTime").toString().split(" ")[0]%> 
                                        <%=clientWbo.getAttribute("creationTime").toString().split(" ")[1].substring(0, 5)%> 
                                    </td>
                                </tr>
                                <%
                                    }
                                %>
                                <tr>
                                    <td class="td titleTD" style="vertical-align: middle;background-color: #dfdfdf;text-align: center;color: black;border: 3px solid white">
                                        <p class="cairo" style="width: 120px;vertical-align: middle;font-weight: bold;margin: 0px"><fmt:message key="employee" /></p>
                                    </td>

                                    <td class="td dataTD">
                                        <%=ownerUserWbo != null && ownerUserWbo.getAttribute("fullName") != null ? ownerUserWbo.getAttribute("fullName") : notfound%>
                                    </td>
                                    </td>

                                    <td class="td dataTD" style="background-color: white" colspan="2">

                                    </td>
                                </tr>
                                <%

                                    String lastUpdate = notfound;
                                    String createdBy = notfound;
                                    if (loggerWbo != null) {
                                        lastUpdate = (String) loggerWbo.getAttribute("eventTime");
                                        userWbo = userMgr.getOnSingleKey((String) loggerWbo.getAttribute("userId"));
                                        createdBy = userWbo != null ? (String) userWbo.getAttribute("fullName") : "";
                                    }
                                %>
                                <tr>
                                    <td class="td titleTD" style="background-color: #dfdfdf;text-align: center;color: white;border: 3px solid white;">
                                        <p class="cairo" style="width: 120px;vertical-align: middle;font-weight: bold;margin: 0px"><fmt:message key="lastedit" /></p>
                                    </td>

                                    <td class="td dataTD">
                                        <%=createdBy%> 
                                    </td>

                                    <td class="td titleTD" style="background-color: #dfdfdf;text-align: center;color: white;border: 3px solid white;">
                                        <p class="cairo" style="width: 120px;vertical-align: middle;font-weight: bold;margin: 0px"><fmt:message key="editdate" /></p>
                                    </td>

                                    <td class="td dataTD">
                                        <%=lastUpdate%> 
                                    </td>
                                </tr>
                                <!--tr>
                                    <td class="td detailTD">
                                <fmt:message key="lockDate" /> 
                           </td>
                           
                           <td class="td dataDetailTD">
                                <%=lockWbo != null && lockWbo.getAttribute("lockDate") != null ? lockWbo.getAttribute("lockDate") : notfound%>
                            </td>
                            
                            <td class="td dataDetailTD" colspan="2">
                                &nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td class="td detailTD">
                                <fmt:message key="lockedTo" /> 
                           </td>
                           
                           <td class="td dataDetailTD">
                                <%=lockWbo != null && lockWbo.getAttribute("lockedToName") != null ? lockWbo.getAttribute("lockedToName") : notfound%>
                            </td>
                            
                            <td class="td detailTD">
                                <fmt:message key="lockedBy" /> 
                           </td>
                           
                           <td class="td dataDetailTD">
                                <%=lockWbo != null && lockWbo.getAttribute("lockedByName") != null ? lockWbo.getAttribute("lockedByName") : notfound%>
                            </td>
                        </tr-->
                        <tr>
                                    <td></td>
                                </tr>        
                                        
                                <tr>
                                    <td class="td titleTD" colspan="4" style="padding: 10px 0px 10px 10px ;border-radius: 5px;background-color: #dfdfdf;text-align: left;color:  #000;font-size: 20px;font-weight: bold">
                                        Reserved
                                    </td>
                                </tr>
                                <tr>
                                    <td></td>
                                </tr>         
                                   
                                <tr>
                                    <td colspan="4">
                                  <TABLE id="reservedUnit" class="blueBorder" ALIGN="center" dir="<%=dir%>"  width="95%" cellpadding="0" cellspacing="0" style="margin-top: 10px;margin-right: 3%;">
                                <TR>
                                    <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap ><b>Project Code</b></TD>
                                    <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap ><b>Project Name</b></TD>
                                    <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap ><b>BUILDING_CODE</b></TD>
                                    <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap ><b>BUILDING_DESCRIPTION</b></TD>
                                    <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap ><b>Unit Name</b></TD>
                                    <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap ><b>Details</b></TD>
                                    <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap><b>Code Reserved</b></TD>
                                </TR>
                                <%
                                    ArrayList<WebBusinessObject> clientProjectRe = ClientMgr.getInstance().getUnitValueFive((String) clientWbo.getAttribute("id")) ;
                                    if (!clientProjectRe.equals("No Data")) {
                                    for (WebBusinessObject wboUnit : clientProjectRe) {    
				    ArrayList<WebBusinessObject> reservedUnit = (ArrayList<WebBusinessObject>) ClientMgr.getInstance().getClientsReserve((String) clientWbo.getAttribute("name"),(String) clientWbo.getAttribute("mobile"),(String) wboUnit.getAttribute("PRODUCT_CATEGORY_ID"));
                                    for (WebBusinessObject wbo1 : reservedUnit) {
                                %>
                                <TR style="padding: 1px;">

                                    <TD style="text-align:center;background: #f1f1f1;font-size: 14px;">
                                        <b><%=wbo1.getAttribute("STAGE_CODE")%></b>
                                    </TD>
                                     <TD style="text-align:center;background: #f1f1f1;font-size: 14px;">
                                        <b><%=wbo1.getAttribute("STAGE_DESCRIPTION")%></b>
                                    </TD>
                                     <TD style="text-align:center;background: #f1f1f1;font-size: 14px;">
                                        <b><%=wbo1.getAttribute("BUILDING_CODE")%></b>
                                    </TD>
                                    <TD style="text-align:center;background: #f1f1f1;font-size: 14px;">
                                        <b><%=wbo1.getAttribute("BUILDING_DESCRIPTION")%></b>
                                    </TD>
                                    <TD style="text-align:center;background: #f1f1f1;font-size: 14px;">
                                        <b><%=wbo1.getAttribute("UNIT_NAME")%></b>
                                    </TD>
                                    <TD style="text-align:center;background: #f1f1f1;font-size: 14px;">
                                        <b><%=wbo1.getAttribute("DESCDETAILS")%></b>
                                    </TD>
                                    <TD style="text-align:center;background: #f1f1f1;font-size: 14px;">
                                        <b><%=wbo1.getAttribute("RESERVED").toString().split(" ")[0]%></b>
                                    </TD>
                                </TR>
			            <% }} }%>
                            </TABLE>
                                    </td>
                                </tr>
                            <tr>
                                    <td></td>
                                </tr>        
                                        
                                <tr>
                                    <td class="td titleTD" colspan="4" style="padding: 10px 0px 10px 10px ;border-radius: 5px;background-color: #dfdfdf;text-align: left;color:  #000;font-size: 20px;font-weight: bold">
                                        Sold
                                    </td>
                                </tr>
                                <tr>
                                    <td></td>
                                </tr>         
                                   
                                <tr>
                                    <td colspan="4">
                                  <TABLE id="reservedUnit" class="blueBorder" ALIGN="center" dir="<%=dir%>"  width="95%" cellpadding="0" cellspacing="0" style="margin-top: 10px;margin-right: 3%;">
                                <TR>
                                    <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap ><b>Project Code</b></TD>
                                    <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap ><b>Project Name</b></TD>
                                    <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap ><b>BUILDING CODE</b></TD>
                                    <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap ><b>DESCRIPTION</b></TD>
                                    <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap ><b>Unit Name In Real-Estate</b></TD>
                                    <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap ><b>Details</b></TD>
                                    <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap><b>Code Sold</b></TD>
                                </TR>
                                <%
                                    ArrayList<WebBusinessObject> clientProject = ClientMgr.getInstance().getUnitValueFive((String) clientWbo.getAttribute("id")) ;
                                    if (!clientProject.equals("No Data")) {
                                    for (WebBusinessObject wboUnit : clientProject) {    
				    ArrayList<WebBusinessObject> soldUnit = (ArrayList<WebBusinessObject>) ClientMgr.getInstance().getClientsBuyer((String) clientWbo.getAttribute("name"),(String) clientWbo.getAttribute("mobile"),(String) wboUnit.getAttribute("PRODUCT_CATEGORY_ID"));
                                    for (WebBusinessObject wbo1 : soldUnit) {
                                %>
                                <TR style="padding: 1px;">

                                    <TD style="text-align:center;background: #f1f1f1;font-size: 14px;">
                                        <b><%=wbo1.getAttribute("STAGE_CODE")%></b>
                                    </TD>
                                     <TD style="text-align:center;background: #f1f1f1;font-size: 14px;">
                                        <b><%=wbo1.getAttribute("STAGE_DESCRIPTION")%></b>
                                    </TD>
                                     <TD style="text-align:center;background: #f1f1f1;font-size: 14px;">
                                        <b><%=wbo1.getAttribute("BUILDING_CODE")%></b>
                                    </TD>
                                    <TD style="text-align:center;background: #f1f1f1;font-size: 14px;">
                                        <b><%=wbo1.getAttribute("BUILDING_DESCRIPTION")%></b>
                                    </TD>
                                    <TD style="text-align:center;background: #f1f1f1;font-size: 14px;">
                                        <b><%=wbo1.getAttribute("UNIT_NAME")%></b>
                                    </TD>
                                    <TD style="text-align:center;background: #f1f1f1;font-size: 14px;">
                                        <b><%=wbo1.getAttribute("DESCDETAILS")%></b>
                                    </TD>
                                    <TD style="text-align:center;background: #f1f1f1;font-size: 14px;">
                                        <b><%=wbo1.getAttribute("SOLD").toString().split(" ")[0]%></b>
                                    </TD>
                                </TR>
					<% }} } %>
                            </TABLE>
                                    </td>
                                </tr>
                </table>
                <%
                    if (showHeader != null && showHeader.equals("true")) {
                %>
        </fieldset>

        <div id="createClient"  style="width: 40% ;margin-right: auto ;margin-left: auto;display: none;position: fixed;top: 0%;">
            <div style="clear: both;margin-left: 88%;margin-bottom: -38px;z-index: -10000000;">
                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                     -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                     box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                     -webkit-border-radius: 100px;
                     -moz-border-radius: 100px;
                     border-radius: 100px;" onclick="closePopup(this)"/>
            </div>
            <div class="login" style="width: 85%;margin-bottom: 10px;margin-left: auto;margin-right: auto;">
                <table  border="0px" dir="<%=dir%>"  style="width:100%;"  class="table">
                    <tr>
                        <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 40%;">Client Name</td>
                        <td style="width: 40%; text-align: left;" >
                            <input type="text" name="clientName" id="clientName" value=""
                                   onblur="checkClientName()" onkeypress="checkClientName()"/>
                        </td>
                        <td nowrap style="width: 20%;">
                            <div id="nameWarning"style="display: none;width: 20px;height: 20px; border: none;">
                                <img src="images/warning.png"  width="16px" height="16px;" style="background-color: transparent;border: none;background-image: url(images/warning.png);background-repeat: no-repeat;" />
                            </div>
                            <div id="nameOk"style="display: none;width: 20px;height: 20px;border: none;">
                                <img src="images/warning.png" width="16px" height="16px;" style="background-color: transparent;border: none;background-image: url(images/ok2.png);background-repeat: no-repeat;" />
                            </div>
                            <label id="nameMSG" ></label>
                        </td>
                    </tr>
                    <tr>
                        <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;">Tele-Phone</td>
                        <td style="text-align: left;" >
                            <input type="text" name="phone" id="phone" value="" maxlength="10"
                                   onblur="checkClientPhone()" onkeypress="checkClientPhone()"/>
                        </td>
                        <td nowrap>
                            <div id="telWarning"style="display: none;width: 20px;height: 20px; border: none;">
                                <img src="images/warning.png" width="16px" height="16px;" style="background-color: transparent;border: none;background-image: url(images/warning.png);background-repeat: no-repeat;" />
                            </div>
                            <div id="telOk"style="display: none;width: 20px;height: 20px;border: none;">
                                <img src="images/warning.png" width="16px" height="16px;" style="background-color: transparent;border: none;background-image: url(images/ok2.png);background-repeat: no-repeat;" />
                            </div>
                            <label id="telMSG" ></label>
                        </td>
                    </tr>
                    <tr>
                        <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;">Mobile</td>
                        <td style="text-align: left;" >
                            <input type="text" name="clientMobile" id="clientMobile" value="" maxlength="11"
                                   onblur="checkClientMobile()" onkeypress="checkClientMobile()"/>
                        </td>
                        <td nowrap>
                            <div id="mobWarning"style="display: none;width: 20px;height: 20px; border: none;">
                                <img src="images/warning.png" width="16px" height="16px;" style="background-color: transparent;border: none;background-image: url(images/warning.png);background-repeat: no-repeat;" />
                            </div>
                            <div id="mobOk"style="display: none;width: 20px;height: 20px;border: none;">
                                <img src="images/warning.png" width="16px" height="16px;" style="background-color: transparent;border: none;background-image: url(images/ok2.png);background-repeat: no-repeat;" />
                            </div>
                            <label id="mobMSG" ></label>
                        </td>
                    </tr>
                </table>
                <div style="text-align: center;margin-left: auto;margin-right: auto;clear: both" > 
                    <input type="button" value="Save"   onclick="JavaScript:createClient();" id="saveClient"class="login-submit"/>
                </div>                             </form>
                <div id="progressClient" style="display: none;">
                    <img src="images/Loading2.gif" width="32px" height="32px;" style="background-repeat: no-repeat;margin-left: auto;margin-right: auto"/>
                </div>
                <div style="margin: 0 auto;width: 90%;text-align: center;color: white;font-size: 16px;font-weight: bold;" id="createClientMsg">
                    Added Client
                </div>
            </div>
        </div>
        <%
            }
        %>
        <div id="createBookmark"  style="width: 30% ;margin-right: auto ;margin-left: auto;display: none;position: fixed;top: 0%;">
            <div style="clear: both;margin-left: 88%;margin-bottom: -38px;z-index: -10000000;">
                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                     -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                     box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                     -webkit-border-radius: 100px;
                     -moz-border-radius: 100px;
                     border-radius: 100px;" onclick="closePopup(this)"/>
            </div>
            <div class="login" style="width: 85%;margin-bottom: 10px;margin-left: auto;margin-right: auto;">
                <table  border="0px" dir="<%=dir%>"  style="width:100%;"  class="table">
                    <tr>
                        <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 30%;">Summary</td>
                        <td style="width: 70%; text-align: left;" >
                            <select name="title" id="title" style="width: 250px;">
                                <option value="<%=clientWbo.getAttribute("name")%>"><%=clientWbo.getAttribute("name")%></option>
                                <option value="Hot Client">Hot Client</option>
                                <option value="Unit & Project data missing">Unit & Project data missing</option>
                                <option value="No Payment Plan">No Payment Plan</option>
                                <option value="Poor Client Communication">Poor Client Communication</option>
                                <option value="Visit Support">Visit Support</option>
                                <option value="Other">Other</option>
                                <option value="whatsapp">Whatsapp</option>
                            </select>
                        </td>
                    </tr> 
                    <tr>
                        <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 30%;">Details</td>
                        <td style="width: 70%;" >
                            <textarea  placeholder="" style="width: 100%;height: 80px;" id="details" > </textarea>
                        </td>
                    </tr> 
                </table>
                <div style="text-align: center;margin-left: auto;margin-right: auto;clear: both" > <input type="button" value="Save"   onclick="JavaScript:createBookmark(this, '<%=clientWbo.getAttribute("id")%>');" id="saveBookmark"class="login-submit"/></div>                             </form>
                <div id="progressBookmark" style="display: none;">
                    <img src="images/Loading2.gif" width="32px" height="32px;" style="background-repeat: no-repeat;margin-left: auto;margin-right: auto"/>
                </div>
                <div style="margin: 0 auto;width: 90%;text-align: center;color: white;font-size: 16px;font-weight: bold" id="createMsg">
                    تم إضافة العلامة
                </div>
            </div>
        </div>
        <div id="displayClients"  style="width: 30% ;margin-right: auto ;margin-left: auto;display: none;position: fixed;top: 0%;">
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
                    <tr>
                        <td nowrap STYLE="<%=style%>;padding:3px;background-image: url('images/gradient.gif');background-repeat: repeat-x; text-align: center; font-size: 13px; font-weight: bold; width: 50%;">
                            اسم العميل
                        </td>
                        <td nowrap STYLE="<%=style%>;padding:3px;background-image: url('images/gradient.gif');background-repeat: repeat-x; text-align: center; font-size: 13px; font-weight: bold; width: 25%;">
                            تليفون
                        </td>
                        <td nowrap STYLE="<%=style%>;padding:3px;background-image: url('images/gradient.gif');background-repeat: repeat-x; text-align: center; font-size: 13px; font-weight: bold; width: 25%;">
                            موبايل
                        </td>
                    </tr> 

                    <%
                        for (WebBusinessObject clientCampaignTemp : clientsRecommendedList) {
                            ClientMgr clientMgr = ClientMgr.getInstance();
                            WebBusinessObject clientTemp = clientMgr.getOnSingleKey((String) clientCampaignTemp.getAttribute("clientId"));
                    %>
                    <tr>
                        <td WIDTH="100%" STYLE="<%=style%>;background-image: url('images/gradient.gif');background-repeat: repeat-x; text-align: center;">
                            <%=clientTemp.getAttribute("name")%>
                        </td>
                        <td WIDTH="100%" STYLE="<%=style%>;background-image: url('images/gradient.gif');background-repeat: repeat-x; text-align: center;">
                            <%=clientTemp.getAttribute("phone")%>
                        </td>
                        <td WIDTH="100%" STYLE="<%=style%>;background-image: url('images/gradient.gif');background-repeat: repeat-x; text-align: center;">
                            <%=clientTemp.getAttribute("mobile")%>
                        </td>
                    </tr>     
                    <%
                        }
                    %>
                </table>
            </div>
        </div>
        <div id="add_comments"  style="width: 400px ;margin-right: auto ;margin-left: auto;display: none;position: fixed;top: 0%;"><!--class="popup_appointment" -->
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
                        <td style="color: #f1f1f1; font-size: 16px; font-weight: bold; width: 30%;">Title</td>
                        <td style="width: 70%;" >
                            <select id="commentTitlePopup" name="commentTitlePopup" style="width: 100%;">
                                <option value=""></option>
                                <option value="Whatsapp">Whatsapp</option>
                                <option value="call">Call</option>
                            <option value="email">Email</option>
                            <option value="meeting">Meeting</option>
                            <option value="تسليم مبدأي">تسليم مبدأي</option>
                            <option value="تسليم نهائي">تسليم نهائي</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 30%;">Comment</td>
                        <td style="width: 70%;" >
                            <textarea  placeholder="" style="width: 100%;height: 80px;" id="addCommentArea" name="addCommentArea" > </textarea>
                        </td>
                    </tr> 
                </table>
                <div style="text-align: center;margin-left: auto;margin-right: auto;clear: both" > 
                    <input type="button" value="Save"   onclick="saveComment(this)" id="saveComm"class="login-submit"/></div></form>
                <div id="progress" style="display: none;">
                    <img src="images/Loading2.gif" width="32px" height="32px;" style="background-repeat: no-repeat;margin-left: auto;margin-right: auto"/>
                </div>
                <div style="margin: 0 auto;display: none; width: 90%;text-align: center;color: white;font-size: 16px;font-weight: bold" id="commMsg">
                    Added Comment
                </div>
            </div>  
        </div>
        <div id="appointment_content" style="width: 40% !important;display: none;position: fixed"><!--class="popup_appointment" -->
            <div style="clear: both;margin-left: 88%;margin-top: 0px;margin-bottom: -38px;z-index: -10000000;">
                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                     -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                     box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                     -webkit-border-radius: 100px;
                     -moz-border-radius: 100px;
                     border-radius: 100px;" onclick="closePopup(this)"/>
            </div>
            <div class="login" style="width: 85%;margin-bottom: 10px;margin-left: auto;margin-right: auto;">
                <h1>متابعة عميل</h1>
                <table style="width:90%;">
                    <tr>
                        <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 30%;" >
                            العميل                           
                        </td>
                        <td width="70%"style="text-align:right;">
                            <b id="appClientName"><%=((String) clientWbo.getAttribute("name")).trim()%></b>
                        </td>
                    </tr>
                    <tr>
                        <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 30%;">الهدف </td>
                        <td style="text-align:right;width: 70%;">
                            <select id="palnningTitle" name="palnningTitle" STYLE="width:200px;font-size: medium; font-weight: bold;">
                                <sw:WBOOptionList wboList='<%=dataArray%>' displayAttribute = "projectName" valueAttribute="projectName" />
                            </select>
                            <label id="palnningTitleMsg"></label>
                        </td>
                    </tr>
                    <tr>
                        <td style="color:#f1f1f1;   font-size: 16px;width: 30%;">الالية </td>
                        <td style="text-align:right;width: 70%;">
                            <input name="note" type="radio" value="call" checked="" id="note" >
                                <label><img src="images/dialogs/phone.png" alt="phone" width="24px">مكالمة </label>
                                <%
                                    if (!departmentID.equals(CRMConstants.DEPARTMENT_CALL_CENTER_ID)) {
                                %>
                                <input name="note" type="radio" value="meeting" id="note" style="margin-right: 10px;" >
                                    <label><img src="images/dialogs/handshake.png" alt="meeting" width="24px"> مقابلة</label>
                                    <%
                                        }
                                    %>
                                    </td>
                                    </tr>
                                    <tr>
                                        <td style="color:#f1f1f1;font-size: 16px;font-weight: bold;width: 30%;">التاريخ</td>
                                        <td style="text-align:right;width: 70%;" >
                                            <input class="login-input" name="palnningDate" id="palnningDate" type="text" size="50" maxlength="50" style="width:200px;font-size: medium; " value="<%=nowTime%>"/>
                                        </td>
                                    </tr> 
                                    <tr>
                                        <td style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 30%;">
                                            المكان
                                            <br>
                                        </td>
                                        <td style="text-align:right;width: 70%;">
                                            <select id="appointmentPlace" name="appointmentPlace" style="margin-top: 7px;width:200px;font-size: medium;">
                                                <sw:WBOOptionList wboList='<%=userProjects%>' displayAttribute = "projectName" valueAttribute="projectName" />
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 30%;">
                                            تعليق
                                        </td>
                                        <td style="text-align:right;width: 70%;">
                                            <textarea cols="26" rows="3" id="palnningComment">
                                            </textarea>
                                        </td>
                                    </tr>
                                    </table>
                                    <div style="text-align: center;margin-left: auto;margin-right: auto;" > 
                                        <input type="submit" value="حفظ" onclick="javascript: saveAppoientment(this)" class="login-submit" style="background: #FF9900;"/>
                                    </div>
                                    <div id="progress" style="display: none;">
                                        <img src="images/Loading2.gif" width="32px" height="32px;" style="background-repeat: no-repeat;margin-left: auto;margin-right: auto"/>
                                    </div>
                                    <div style="margin: 0 auto;display: none; width: 90%;text-align: center;color: white;font-size: 16px;font-weight: bold" id="palnningMsg">تم إضافة المقابلة </>
                                    </div>
                                    </div>  
                                    </div>
                                    <% }%>
                                    <div id="follow_up_content" style="width: 70% !important;display: none;position: fixed">
                                        <div style="clear: both;margin-left: 80%;margin-top: 0px;margin-bottom: -38px;z-index: -10000000;">
                                            <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                                                 -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                                                 box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                                                 -webkit-border-radius: 100px;
                                                 -moz-border-radius: 100px;
                                                 border-radius: 100px;" onclick="closePopup(this)"/>
                                        </div>
                                        <div class="login" style="width: 60%;margin-bottom: 10px;margin-left: auto;margin-right: auto;">
                                            <h1 align="center" style="vertical-align: middle"><fmt:message key="followcl" /><b id="appClientName" style="font-weight: bold; font-size: 20px"></b> &nbsp;&nbsp;&nbsp;<img src="images/dialogs/phone.png" alt="phone" width="24px"/></h1>
                                            <div style="text-align: left;margin-left: 2%;margin-right: auto;" > 
                                                <span id="timer" style="font-size: 30px; font-weight: bolder; color: black; padding-left: 20px;"></span>
                                                <button type="button" onclick="javascript: saveFollowUp(this);" style="font-size: 14px; font-weight: bold; width: 150px">Save<img style="height:20px; width: 20px" src="images/icons/follow_up.png" title="Follow up"/></button>
                                            </div>
                                            <br />
                                            <input type="hidden" id="appTitle" name="appTitle" value="FOLLOW UP" />
                                            <table class="table" dir="<%=dir%>">
                                                <tr>
                                                    <td style="color: #f1f1f1; font-size: 16px; font-weight: bold; text-align: <%=xAlign%>;"><fmt:message key="followa1" /> :</td>
                                                    <td td style="text-align:<%=sAlign%>">
                                                        <select id="callResult" name="callResult" STYLE="width: 225px;font-size: medium; font-weight: bold;" onchange="JavaScript: callResultsChng()">
                                                            <option value="<%=CRMConstants.CALL_RESULT_MEETING%>">Meeting</option>
                                                            <option value="<%=CRMConstants.CALL_RESULT_INBOUNDCALL%>">In-Bound Call</option>
                                                            <option value="<%=CRMConstants.CALL_RESULT_OUTBOUNDCALL%>" selected>Out-Bound Call</option>
                                                            <option value="<%=CRMConstants.CALL_RESULT_CALL%>">Internet</option>
                                                            <option value="<%=CRMConstants.CALL_RESULT_DIRECT_VISIT%>">Direct Visit</option>
                                                        </select>
                                                    </td>
                                                </tr>

                                                <tr>
                                                    <!--td id="callStatusTd" style="color: #f1f1f1; font-size: 16px; font-weight: bold; text-align: <1%=xAlign%>;"><1fmt:message key="followb1" /> :</td>
                                                    <td id="callStatusTd" style="text-align:<1%=sAlign%>" >
                                                        <select id="callStatus" name="callStatus" STYLE="width: 225px;font-size: medium; font-weight: bold;" onchange="Javascript: callStatusChange();">
                                                            <option value="not answered">not answered</option>
                                                            <option value="answered" selected>answered</option>
                                                        </select>
                                                    </td-->
                                                    <input type="hidden" name="callStatus" id="callStatus" value="answered"
                                                           style="width: 80px;"/> <!--fmt:message key="followg1" /-->

                                                </tr>

                                                <tr>
                                                    <!--td style="color: #f1f1f1; font-size: 16px; font-weight: bold; text-align: <1%=xAlign%>;"><1fmt:message key="followd1" /> :</td-->
                                                    <td style="text-align:<%=sAlign%>">
                                                        <input type="hidden" name="callDuration" id="callDuration" value="1" min="1"
                                                               style="width: 80px;"/> <!--fmt:message key="followg1" /-->
                                                    </td>
                                                </tr>

                                                <tr>
                                                    <td id="callResultTD" style="color: #f1f1f1; font-size: 16px; font-weight: bold; text-align: <%=xAlign%>;"><fmt:message key="followe1" /> :</td>
                                                    <td td style="text-align:<%=sAlign%>" id="callResultTD">
                                                        <select id="nextAction" name="nextAction" STYLE="width: 225px;font-size: medium; font-weight: bold;" onchange="JavaScript: callResultsChange()">
                                                            <option value="">choose</option>
<% if (userPrevList.contains("CLOSED")) { %><option value="Closed">Closed</option><% } %>
<% if (userPrevList.contains("Done deal")) { %><option value="Done deal">Done deal</option><% } %>
<% if (userPrevList.contains("EXISTING_OWNER")) { %><option value="Existing Owner">Existing Owner</option><% } %>
<% if (userPrevList.contains("First call")) { %><option value="First call">First call</option><% } %>
<% if (userPrevList.contains("FOLLOW")) { %><option value="Follow">Follow</option><% } %>
<% if (userPrevList.contains("Follow after meeting")) { %><option value="Follow after meeting">Follow after meeting</option><% } %>
<% if (userPrevList.contains("Fresh leads")) { %><option value="Fresh leads">Fresh leads</option><% } %>
<% if (userPrevList.contains("HOLD")) { %><option value="Hold">Hold</option><% } %>
<% if (userPrevList.contains("NEEDS_READY_UNIT")) { %><option value="Needs Ready Unit">Needs Ready Unit</option><% } %>
<% if (userPrevList.contains("No Answer")) { %><option value="No Answer">No Answer</option><% } %>
<% if (userPrevList.contains("NOT_INTERESTED")) { %><option value="Not Interested">Not Interested</option><% } %>
<% if (userPrevList.contains("Not clear")) { %><option value="Not clear">Not clear</option><% } %>
<% if (userPrevList.contains("OUT_OF_BUDGET")) { %><option value="Out of Budget">Out of Budget</option><% } %>
<% if (userPrevList.contains("RTM")) { %><option value="RTM">RTM</option><% } %>
<% if (userPrevList.contains("Reservation")) { %><option value="Reservation">Reservation</option><% } %>
<% if (userPrevList.contains("Schedule meeting")) { %><option value="Schedule meeting">Schedule meeting</option><% } %>
<% if (userPrevList.contains("Send Offer")) { %><option value="Send Offer">Send Offer</option><% } %>
<% if (userPrevList.contains("Send SMS")) { %><option value="Send SMS">Send SMS</option><% } %>
<% if (userPrevList.contains("VISIT")) { %><option value="Visit">Visit</option><% } %>
<% if (userPrevList.contains("WRONG_NUMBER")) { %><option value="Wrong Number">Wrong Number</option><% } %>
                                                            <%-- <sw:WBOOptionList wboList='<%=callResLst%>' displayAttribute = "projectName" valueAttribute="projectName" />--%>
                                                        </select>
                                                    </td>
                                                </tr>

                                                <tr>
                                                    <td id="meetresaultlbl" style="color:#f1f1f1; font-size: 16px; font-weight: bold; text-align: <%=xAlign%>; display:none">Follow Date: </td>
                                                    <td>
                                                        <table>
                                                            <tr>

                                                                <td style="text-align:right; display: none" id="meetingDateTD"><input name="meetingDate" id="meetingDate" type="text"   maxlength="50" value="<%=nowTime%>"/></td>
                                                                <input type="hidden" name="timeflag" id="timeflag"/>

                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>

                                                <tr>
                                                    <td id="appointmentPlacelbl" style="color:#f1f1f1; font-size: 16px; font-weight: bold; text-align: <%=xAlign%>; display:none">Branch : </td>
                                                    <td>
                                                        <table>
                                                            <tr>
                                                                <td id ="appointmentPlaceDDL" style="text-align:right; display:none">
                                                                    <select id="appointmentPlace" name="appointmentPlace" style="margin-top: 7px;width:200px;font-size: medium;">
                                                                        <sw:WBOOptionList wboList='<%=userProjects%>' displayAttribute = "projectName" valueAttribute="projectName" />
                                                                    </select>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>

                                                <tr>
                                                    <td style="color:#f1f1f1; font-size: 16px;font-weight: bold; text-align: <%=xAlign%>;"><fmt:message key="followf1" /> : <br/></td>
                                                    <td colspan="2" style="text-align:right">
                                                        <textarea cols="26" rows="10" id="comment" style="width: 99%; background-color: #FFF7D6;"></textarea>
                                                    </td>
                                                </tr>
                                            </table>

                                            <!--div style="text-align: left;margin-left: 2%;margin-right: auto;" > 
                                                <button type="button" onclick="javascript: saveFollowUp(this);" style="font-size: 14px; font-weight: bold; width: 150px">Save<img style="height:20px; width: 20px" src="images/icons/follow_up.png" title="Follow up"/></button>
                                            </div-->
                                            <div id="progress" style="display: none;">
                                                <img src="images/Loading2.gif" width="32px" height="32px;" style="background-repeat: no-repeat;margin-left: auto;margin-right: auto"/>
                                            </div>
                                            <div style="margin: 0 auto;display: none; width: 90%;text-align: center;color: white;font-size: 16px;font-weight: bold" id="appMsg">Visit Added</div>
                                        </div>  
                                    </div>
                                    <div id="user_appointment" style="width: 70% !important;display: none;position: fixed">
                                        <div style="clear: both;margin-left: 80%;margin-top: 0px;margin-bottom: -38px;z-index: -10000000;">
                                            <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                                                 -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                                                 box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                                                 -webkit-border-radius: 100px;
                                                 -moz-border-radius: 100px;
                                                 border-radius: 100px;" onclick="closePopup(this)"/>
                                        </div>
                                        <div class="login" style="width: 60%;margin-bottom: 10px;margin-left: auto;margin-right: auto;">
                                            <h1 align="center" style="background-color: #ff9a98; vertical-align: middle"><fmt:message key="userAppointment" /> &nbsp;&nbsp;&nbsp;<img src="images/icons/meeting.png" alt="phone" width="24px"/></h1>
                                            <div style="text-align: left;margin-left: 2%;margin-right: auto;" > 
                                                <span style="font-size: 20px; font-weight: bolder; color: black; padding-left: 10px;">عدد المقابلات :</span>
                                                <span id="appointmentNo" style="font-size: 30px; font-weight: bolder; color: black; padding-left: 10px;">0</span>
                                            </div>
                                            <br />
                                            <table class="table" dir="<%=dir%>">
                                                <tr>
                                                    <td style="color: #f1f1f1; font-size: 16px; font-weight: bold; text-align: <%=xAlign%>;"><fmt:message key="theEmployee" /> :</td>
                                                    <td td style="text-align:<%=sAlign%>" id="callResultTD">
                                                        <select id="userID" name="userID" style="width: 180px; font-size: medium; font-weight: bold;"
                                                                onchange="JavaScript: getAppointmentsNo();">
                                                            <option value="">choose</option>
                                                            <sw:WBOOptionList wboList="<%=usersList%>" displayAttribute="fullName" valueAttribute="userId" />
                                                        </select>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="color:#f1f1f1; font-size: 16px; font-weight: bold; text-align: <%=xAlign%>;">Follow Date:  </td>
                                                    <td td style="text-align:<%=sAlign%>">
                                                        <input name="userMeetingDate" id="userMeetingDate" type="text" maxlength="50" value="<%=nowTime%>" style="width: 180px;"
                                                               onchange="JavaScript: getAppointmentsNo();"/>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="color:#f1f1f1; font-size: 16px; font-weight: bold; text-align: <%=xAlign%>;">Branch : </td>
                                                    <td td style="text-align:<%=sAlign%>">
                                                        <select id="userAppointmentPlace" name="userAppointmentPlace" style="margin-top: 7px;width:180px;font-size: medium;">
                                                            <sw:WBOOptionList wboList='<%=userProjects%>' displayAttribute = "projectName" valueAttribute="projectName" />
                                                        </select>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="color:#f1f1f1; font-size: 16px;font-weight: bold; text-align: <%=xAlign%>;"><fmt:message key="followf1" /> : <br/></td>
                                                    <td colspan="2" style="text-align:right">
                                                        <textarea cols="26" rows="10" id="userComment" style="width: 99%; background-color: #FFF7D6;"></textarea>
                                                    </td>
                                                </tr>
                                            </table>
                                            <div style="text-align: left;margin-left: 2%;margin-right: auto;" > 
                                                <button type="button" onclick="javascript: saveUserAppointment(this);" style="font-size: 14px; font-weight: bold; width: 150px">حفظ<img style="height:20px; width: 20px" src="images/icons/meeting.png" title="Follow up"/></button>
                                            </div>
                                            <div id="userProgress" style="display: none;">
                                                <img src="images/Loading2.gif" width="32px" height="32px;" style="background-repeat: no-repeat;margin-left: auto;margin-right: auto"/>
                                            </div>
                                            <div style="margin: 0 auto;display: none; width: 90%;text-align: center;color: white;font-size: 16px;font-weight: bold" id="userAppointmentMsg">تم إضافة المقابلة </div>
                                        </div>  
                                    </div>
                                    <div id="show_attached_files" style="width: 70% !important; display: none; position: fixed ;">

                                    </div>
                                    <div id="showImage" style="width: 40% !important;display: none;position: fixed ;border:  1px solid red">
                                        <img id="docImage" name='docImage' alt='document image' height="300px" width="100%" style="margin-left: auto;margin-right: auto;">
                                    </div>
                                    <div id="emailbox_popup" title="MailBox" style="display: none">
                                        mail box                     
                                    </div>
                                    <div id="addCampaign" style="display: none; text-align: center;">
                                        <h2><fmt:message key="clientCampaigns" /></h2>
                                        <table align="center" dir="rtl" id="clientCampaigns" style="width: 100%; border: 1px solid;">
                                            <thead>
                                                <th><input id="clntCmpCkBxAll" name="clntCmpCkBxAll" type="checkbox" onchange="selectAllClntCmpCkBx()" value="off"></th>
                                                <th>
                                                    <b><fmt:message key="campaignTitle" /></b>
                                                </th>

                                                <th>
                                                    <b> <%=addBy%> </b>
                                                </th>

                                                <th>
                                                    <b> <%=addTm%> </b>
                                                </th>
                                            </thead>
                                            <tbody>
                                                <%
                                                    if (clientCampaignsList != null) {
                                                        for (WebBusinessObject clientCampaign : clientCampaignsList) {
                                                %>
                                                <tr>
                                                    <td class="dataTD"><input id="clntCmpCkBx" name="clntCmpCkBx" type="checkbox" value="<%=clientCampaign.getAttribute("clntCmpID")%>"></td>
                                                    <td class="dataTD"><%=clientCampaign.getAttribute("campaignTitle")%></td>
                                                    <td class="dataTD"><%=clientCampaign.getAttribute("createdByName")%></td>
                                                    <td class="dataTD"><%=clientCampaign.getAttribute("clntCmpCreationTime") != null ? ((String) clientCampaign.getAttribute("clntCmpCreationTime")).substring(0, 16) : ""%></td>
                                                </tr>
                                                <%
                                                        }
                                                    }
                                                %>
                                            </tbody>
                                        </table>
                                        <br />
                                        <%
                                            if (privilegesList.contains("add_client_campaign")) {
                                        %>
                                        <h2><fmt:message key="addCampaign" /></h2>

                                        <table class="blueBorder" align="center" dir="<fmt:message key="direction"/>" width="90%" style="border-width: 1px; border-color: white; display: block;">
                                            <tr>
                                                <td class="ui-dialog-titlebar ui-widget-header" style="width: 50%;">
                                                    <b>
                                                        <fmt:message key="campaignTitle"/>
                                                    </b>
                                                </td>
                                                <td class="td" style="width: 50%;">
                                                    <select id="campaignID" name="campaignID" class="chosen-select-campaign">
                                                        <option value="">All</option>
                                                        <sw:WBOOptionList displayAttribute="campaignTitle" valueAttribute="id" wboList="<%=campaignsList%>" />
                                                    </select>
                                                </td>
                                            </tr>
                                        </table>
                                        <%}%>
                                    </div>
                                    <div id="appointments" style="display: none;">
                                    </div>
                                    <div id="show_comments" style="width: 50% !important;display: none;position: fixed ;">
                                    </div>
                                    <div id="clients-etc_info" style="width: 40% !important;display: none;position: fixed" dir="<%=dir%>"><!--class="popup_appointment" -->
                                        <div style="clear: both;margin-left: 88%;margin-top: 0px;margin-bottom: -38px;z-index: -10000000;">
                                            <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                                                 -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                                                 box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                                                 -webkit-border-radius: 100px;
                                                 -moz-border-radius: 100px;
                                                 border-radius: 100px;" onclick="closePopup(this)"/>
                                        </div>
                                        <div class="login" style="width: 85%;margin-bottom: 10px;margin-left: auto;margin-right: auto;">
                                            <h1><%=clntInfo%></h1>
                                            <table style="width:90%;">
                                                <div style="text-align: center;margin-left: auto;margin-right: auto;" > 
                                                    <input type="submit" value="<%=save%>" onclick="javascript: saveClientInfo(this)" class="login-submit" style="background: #FF9900;"/>
                                                    <input type="hidden" id="clientId" name="clientId" value="<%=clientWbo.getAttribute("id")%>"/>
                                                </div>
                                                <tr>
                                                    <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 30%;" >
                                                        <%=clnt%> 
                                                    </td>
                                                    <td width="70%"style="text-align:right;">
                                                        <b id="appClientName"><%=clientWbo.getAttribute("name")%></b>
                                                    </td>
                                                </tr>
                                                <tr style="display: none;">
                                                    <td style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 30%;">
                                                        <%=age%>
                                                    </td>
                                                    <td style="text-align:right;width: 70%;">
                                                        <input maxlength="3" style="width: 40%;" type="text" id="clntAge" name="clntAge" onkeypress="javascript: return isNumber(event);"/>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 30%;">
                                                        <%=marriageD%>
                                                    </td>
                                                    <td style="text-align:right;width: 70%;" >
                                                        <input name="marriageDate" id="marriageDate" type="text"   maxlength="50" value="<%=nowTime1%>"/>
                                                    </td>
                                                </tr>    
                                                <tr>
                                                    <td style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 30%;">
                                                        <%=noKids%>
                                                    </td>
                                                    <td style="text-align:right;width: 70%;">
                                                        <input maxlength="3"  style="width: 20%;" type="text" id="noOfKids" name="noOfKids" onkeypress="javascript: return isNumber(event);"/>
                                                    </td>
                                                </tr>     
                                                <tr>
                                                    <td style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 20%;">
                                                        <%=clntSchool%>
                                                    </td>
                                                    <td style="text-align:right;width: 70%;">
                                                        <select id="school" name="school" style="width: 65%;">
                                                            <option value="UL">None</option>
                                                            <option value="Arabic">Arabic</option>
                                                            <option value="English">English</option>
                                                            <option value="French">French</option>
                                                            <option value="Germany">Germany</option>
                                                        </select>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 30%;">
                                                        <%=religion%>
                                                    </td>
                                                    <td style="text-align:right;width: 70%;">
                                                        <select id="relg" name="relg" style="width: 65%;">
                                                            <option value="Muslim">Muslim</option>
                                                            <option value="Christian">Christian</option>
                                                            <option value="None">None</option>
                                                        </select>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 30%;">
                                                        <%=favSport%>
                                                    </td>
                                                    <td style="text-align:right;width: 70%;">
                                                        <select id="fSport" name="fSport" style="width: 65%;">
                                                            <option value="UL">None</option>
                                                            <option value="Football">Football</option>
                                                            <option value="HandBall">HandBall</option>
                                                            <option value="Basketball">Basketball</option>
                                                            <option value="Swimming">Swimming</option>
                                                            <option value="Tennis">Tennis</option>
                                                            <option value="Karate">Karate</option>
                                                        </select>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 30%;">
                                                        <%=favMusic%>
                                                    </td>
                                                    <td style="text-align:right;width: 70%;">
                                                        <select id="fMusic" name="fMusic" style="width: 65%;">
                                                            <option value="UL">None</option>
                                                            <option value="Classic">Classic</option>
                                                            <option value="Hip Hop">Hip Hop</option>
                                                            <option value="House">House</option>
                                                            <option value="Jazz">Jazz</option>
                                                            <option value="Rap">Rap</option>
                                                        </select>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 30%;">
                                                        <%=clubMemb%>
                                                    </td>
                                                    <td style="text-align:right;width: 70%;">
                                                        <select id="ClubMem" name="ClubMem" style="width: 65%;">
                                                            <option value="UL">None</option>
                                                            <option value="النادى الاهلى">النادى الاهلى</option>
                                                            <option value="نادى الزمالك">نادى الزمالك</option>
                                                            <option value="نادى وادى دجله">نادى وادى دجله</option>
                                                            <option value="نادى الصيد">نادى الصيد</option>
                                                            <option value="نادى الجزيره">نادى الجزيره</option>
                                                            <option value="نادى القطاميه الرياضى ">نادى القطاميه الرياضى </option>
                                                            <option value="نادى بالم هيلز">نادى بالم هيلز </option>
                                                            <option value="نادى الزهور الرياضى">نادى الزهور الرياضى</option>
                                                            <option value="نادى دريم لاند للجولف ">نادى دريم لاند للجولف </option>
                                                            <option value="نادى الجونه">نادى الجونه</option>
                                                            <option value="نادى المعادى الرياضى ">نادى المعادى الرياضى </option>
                                                            <option value="نادى 6 اكتوبر">نادى 6 اكتوبر</option>
                                                            <option value="نادى طلعت حرب الرياضى">نادى طلعت حرب الرياضى</option>
                                                            <option value="نادى المعلمين">نادى المعلمين</option>
                                                            <option value="نادى الرمايه للقوات المسلحه">نادى الرمايه للقوات المسلحه </option>
                                                            <option value="نادى الشمس الرياضى">نادى الشمس الرياضى</option>
                                                        </select>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 30%;">
                                                        <%=desc%>
                                                    </td>
                                                    <td style="text-align:right;width: 70%;">
                                                        <textarea id="generalDesc" name="generalDesc" cols="30" rows="4"></textarea>
                                                    </td>
                                                </tr>    
                                            </table>
                                            <div style="text-align: center;margin-left: auto;margin-right: auto;" > 
                                                <input type="submit" value="<%=save%>" onclick="javascript: saveClientInfo(this)" class="login-submit" style="background: #FF9900;"/>
                                                <input type="hidden" id="clientId" name="clientId" value="<%=clientWbo.getAttribute("id")%>"/>
                                            </div>
                                        </div>
                                        <div id="progress" style="display: none;">
                                            <img src="images/Loading2.gif" width="32px" height="32px;" style="background-repeat: no-repeat;margin-left: auto;margin-right: auto"/>
                                        </div>
                                        <div style="margin: 0 auto;display: none; width: 90%;text-align: center;color: white;font-size: 16px;font-weight: bold" id="palnningMsg">تم إضافة المقابلة </>
                                        </div>
                                        <div id="clientSurvey" style="display: none; text-align: center;">
                                            <div class='container' style="width: 100%;">
                                                <section id="wizard">
                                                    <div id="rootwizard">
                                                        <%
                                                            if (questionsList != null && !questionsList.isEmpty()) {
                                                        %>
                                                        <div class="navbar">
                                                            <div class="navbar-inner">
                                                                <div class="container">
                                                                    <ul>
                                                                        <%
                                                                            for (int i = 1; i <= questionsList.size(); i++) {
                                                                        %>
                                                                        <li><a href="#tab<%=i%>" data-toggle="tab">#<%=i%></a></li>
                                                                            <%
                                                                                }
                                                                            %>
                                                                    </ul>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div id="send_sms"  style="width: 25%;display: none;position: fixed; margin-left: auto;margin-right: auto" >

                                                            <div style="clear: both;margin-left: 90%;margin-top: 0px;margin-bottom: -40px;">
                                                                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                                                                     -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                                                                     box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                                                                     -webkit-border-radius: 20px;
                                                                     -moz-border-radius: 20px;
                                                                     border-radius: 20px;" onclick="closeRentPopup(this)"/>
                                                            </div>
                                                            <div class="login" style="width: 90%;text-align: center">
                                                                <table style="width:100%;">
                                                                    <tr>
                                                                        <td colspan="2"><%=writeMsg%></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td colspan="2">
                                                                            <TEXTAREA id="SmsText" name="SmsText" rows="3"></TEXTAREA>
                                                </td>
                                               
                                                
                                            </tr>
                                           
                                        </table>
                                  <button onclick="SendSmsforClient()"><%=Send%></button>
                                    </div>
                                </div>
                        <div id="legal_dispute"  style="width: 30%;display: none;position: fixed; margin-left: auto;margin-right: auto" >
                                    
                                  <div style="clear: both;margin-left: 90%;margin-top: 0px;margin-bottom: -40px;">
                                  <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                                                                     -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                                                                     box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                                                                     -webkit-border-radius: 20px;
                                                                     -moz-border-radius: 20px;
                                                                     border-radius: 20px;" onclick="closeDisputePopup(this)"/>
                              </div>
                              <div class="login" style="width: 90%;text-align: center">
                                  <table style="width:100%;">
                                            <tr>
                                                <td colspan="2"><%=legalDispute1%></td>
                                            </tr>
                                            <tr>
                                                <td style="width:40px"><%=chooseReason%></td>
                                                <td style="width:60px">
                                                    <select id="disputeReason" name="disputeReason"> 
														<option value="تم تحويل الملف">تم تحويل الملف</option>
														<option value="انذار سداد">انذار سداد</option>
                                                        <option value="انذار فسخ">انذار فسخ</option>
                                                        <option value="فسخ بالتراضي">فسخ بالتراضي</option>
                                                        <option value="رفع دعوى">رفع دعوى</option>
                                                        <option value="تحديد جلسات">تحديد جلسات</option>    
                                                        <option value="">تم حل والدفع</option>                                                   
							<option value="">استمرار الاقساط</option>                                                   
                                                    </select>
                                                </td>
                                               
                                                
                                            </tr>
                                           
                                        </table>
                                  <button onclick="confirmLegalDisputeExs()"><%=confirm%></button>
                                    </div>
                                </div>
                                    
                                    <div id="statusClient"  style="width: 30%;display: none;position: fixed; margin-left: auto;margin-right: auto" >
                                    
                                  <div style="clear: both;margin-left: 90%;margin-top: 0px;margin-bottom: -40px;">
                                  <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                                                                     -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                                                                     box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                                                                     -webkit-border-radius: 20px;
                                                                     -moz-border-radius: 20px;
                                                                     border-radius: 20px;" onclick="closeDisputeClientPopup(this)"/>
                              </div>
                              <div class="login" style="width: 90%;text-align: center">
                                  <table style="width:100%;">
                                            <tr>
                                                <td colspan="2">Client Status</td>
                                            </tr>
                                            <tr>
                                                <td style="width:40px">Choose Status</td>
                                                <td style="width:60px">
                                                    <select id="disputeReasonStatus" name="disputeReasonStatus"> 
                                                        <option value="12">Lead</option>
                                                        <option value="11">Customer</option>
                                                        <option value="87">Visit</option>
                                                        <option value="86">Block</option>
                                                    </select>
                                                </td>
                                               
                                                
                                            </tr>
                                           
                                        </table>
                                  <button onclick="confirmLegalDisputeExsStatus()"><%=confirm%></button>
                                    </div>
                                </div>

                               

                                    
                        <div id="sentClientWifi"  style="width: 30%;display: none;position: fixed; margin-left: auto;margin-right: auto" >
                                    
                                  <div style="clear: both;margin-left: 90%;margin-top: 0px;margin-bottom: -40px;">
                                  <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                                                                     -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                                                                     box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                                                                     -webkit-border-radius: 20px;
                                                                     -moz-border-radius: 20px;
                                                                     border-radius: 20px;" onclick="closeWifi(this)"/>
                              </div>
                              <div class="login" style="width: 90%;text-align: center;direction: ltr">
                                  <table style="width:100%;">
                                            <tr>
                                                <td colspan="2">Client Status</td>
                                            </tr>
                                            <tr>
                                                <td style="width:40px">Choose Status</td>
                                                <td style="width:60px">
                                                    <select id="wifiID" name="wifiID" class="chosen-select-campaign">
                                                        <option value="">All</option>
                                                        <sw:WBOOptionList displayAttribute="ITEMNAME" valueAttribute="ITEM_CODE" wboList="<%=typeWifi%>" />
                                                    </select>
                                                </td>
                                                    
                                            </tr>
                                                    <tr>
                                                        <td style="width:40px">
                                                    </td>
                                                    <td style="width:60px">
                                                        <div id="priceDisplay"></div>
                                                    </td>

                                                <script>
                                                    // تحويل قائمة Java إلى JavaScript
                                                    var itemData = [
                                                        <% 
                                                            for (WebBusinessObject item : typeWifi) { 
                                                        %>
                                                        {
                                                            ITEM_CODE: "<%= item.getAttribute("ITEM_CODE") %>",
                                                            ITEMNAME: "<%= item.getAttribute("ITEMNAME") %>",
                                                            SALE_PRICE: "<%= item.getAttribute("SALE_PRICE") %>"
                                                        },
                                                        <% } %>
                                                    ];

                                                    $(document).ready(function () {
                                                        $('#wifiID').change(function () {
                                                            var selectedItem = $(this).val();
                                                            var price = "No Data";

                                                            // البحث عن المنتج المختار
                                                            itemData.forEach(function (item) {
                                                                if (item.ITEM_CODE === selectedItem) {
                                                                    price = item.SALE_PRICE || "No Data";
                                                                }
                                                            });

                                                            // تحديث السعر في الـ div
                                                            $('#priceDisplay').text('Price: ' + price);
                                                        });
                                                    });
                                                </script>
                                                    </tr>
                                        </table>
                                  <button onclick="confirmWifi()"><%=confirm%></button>
                                    </div>
                                </div>
<div class="tab-content">
                                                            <%
                                                                String selectedRate, questionsID;
                                                                for (int i = 0; i < questionsList.size(); i++) {
                                                                    selectedRate = "";
                                                                    questionsID = (String) questionsList.get(i).getAttribute("projectID");
                                                                    for (LiteWebBusinessObject tempWbo : clientSurveyList) {
                                                                        if (questionsID.equals((String) tempWbo.getAttribute("questionID"))) {
                                                                            selectedRate = tempWbo.getAttribute("rate") + "";
                                                                            break;
                                                                        }
                                                                    }
                                                            %>
                                            <div class="tab-pane" id="tab<%=i + 1%>">
                                                                <%=questionsList.get(i).getAttribute("projectName")%>
                                                <select id="rate<%=i + 1%>" name="rating">
                                                    <option value=""></option>
                                                                    <%
                                                                        for (int j = 1; j <= 5; j++) {
                                                                    %>
                                                    <option value="<%=j%>" <%=selectedRate.equals(j + "") ? "selected" : ""%>><%=j%></option>
                                                                    <%
                                                                        }
                                                                    %>
                                                </select>
                                                <br/>
                                                <div class="rateit" data-rateit-backingfld="#rate<%=i + 1%>" data-rateit-resetable="false"></div>
                                                <input type="hidden" id="questionID<%=i + 1%>" value="<%=questionsID%>" />
                                            </div>
                                                            <%
                                                                }
                                                            %>
                                            <ul class="pager wizard">
                                                <li class="previous first" style="display:none;"><a href="#">First</a></li>
                                                <li class="previous"><a href="#">Previous</a></li>
                                                <li class="next last" style="display:none;"><a href="#">Last</a></li>
                                                <li class="next"><a href="#">Next</a></li>
                                            </ul>
                                        </div>
                                                        <%
                                                            }
                                                        %>
                                    </div>
                                </section>
                            </div>
                        </div>
        <script>
                                                    var config = {
                                                    '.chosen-select-campaign': {no_results_text: 'No campaign found with this name!', width:"300px"}
                                                    };
                                                    for (var selector in config) {
                                            $(selector).chosen(config[selector]);
                                            }
                                                                        </script>
    </BODY>
</html>
