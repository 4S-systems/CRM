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
        ArrayList<WebBusinessObject> prvType = new ArrayList();
        prvType = securityUser.getComplaintMenuBtn();
        ArrayList<String> privilegesList = new ArrayList<String>();
        for (WebBusinessObject wboTemp : prvType) {
            if (wboTemp != null && wboTemp.getAttribute("prevCode") != null) {
                privilegesList.add((String) wboTemp.getAttribute("prevCode"));
            }
        }
        
        ArrayList<WebBusinessObject> ratesList = new ArrayList<>();
        ProjectMgr projectMgr = ProjectMgr.getInstance();
        ratesList = new ArrayList<>(projectMgr.getOnArbitraryKeyOracle("CL-RATE", "key6"));
        WebBusinessObject clientWbo = (WebBusinessObject) request.getAttribute("clientWbo");
        WebBusinessObject ownerUserWbo = (WebBusinessObject) request.getAttribute("ownerUserWbo");
        WebBusinessObject loggerWbo = (WebBusinessObject) request.getAttribute("loggerWbo");
        String showHeader = (String) request.getAttribute("showHeader");
        String button = (String) request.getAttribute("button");
        ArrayList<WebBusinessObject> clientsRecommendedList = (ArrayList<WebBusinessObject>) request.getAttribute("clientsRecommendedList");
        ArrayList<WebBusinessObject> campaignsList = (ArrayList<WebBusinessObject>) request.getAttribute("campaignsList");
        ArrayList<WebBusinessObject> clientCampaignsList = (ArrayList<WebBusinessObject>) request.getAttribute("clientCampaignsList");
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
        calendar.add(Calendar.YEAR, 1);
        int currentDay = calendar.get(Calendar.DAY_OF_MONTH);
        int currentYear = calendar.get(Calendar.YEAR);
        int currentMonth = calendar.get(Calendar.MONTH);

        WebBusinessObject userWbo = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
        BookmarkMgr bookmarkMgr = BookmarkMgr.getInstance();
        Vector bookmarksList = new Vector();
        String bookmarkId = "";
        String bookmarkDetails = "";
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
        String socketMsg = "Your Client "+clientWbo.getAttribute("name").toString()+" with Client Number ("+clientWbo.getAttribute("clientNO")+") has a new Comment";
              
        String hasCallCenter = metaMgr.getHasCallCenter();

        String stat = (String) request.getSession().getAttribute("currentMode");
        String align, xAlign, dir, style, noClientExistMsg, successMsg, failMsg, sendEmail, client, possible, chance, oncontact, notfound,
                yes, no, addBy, addTm, dltErrMsg, chkMsg;
        if (stat.equals("En")) {
            align = "left";
            xAlign = "left";
            dir = "LTR";
            style = "text-align:left";
            noClientExistMsg = "No Client Exist for this Number or Number is not Valid or you have no Authority to view client's details";
            client = "Client";
            possible = "Possible";
            chance = "Chance";
            oncontact = "On Contact";
            notfound = "Not Found";
            yes = "Yes";
            no = "No";
            sendEmail = "Send Email";
            successMsg = "Message Sent Successfully";
            failMsg = "Fail to Send Message";
            addBy = " Added By ";
            addTm = " Addition Time ";
            dltErrMsg = " Not Removed ";
            chkMsg = " Please, Choose Campaign You Want To Ramove It. ";
        } else {
            align = "right";
            xAlign = "left";
            dir = "RTL";
            style = "text-align:Right";
            noClientExistMsg = "لا يوجد عميل لهذا الرقم أو رقم خطأ أو لا يوجد لك صلاحية لمشاهدة تفاصيل العميل";
            client = "عميل";
            possible = "محتمل";
            chance = "فرصة";
            oncontact = "على اتصال";
            notfound = "لا يوجد";
            yes = "نعم";
            no = "لا";
            sendEmail = "أرسال رسالة ألكترونية";
            successMsg = "تم أرسال الرسالة";
            failMsg = "لم يتم أرسال الرسالة";
            addBy = " أضيفت بواسطة ";
            addTm = " تاريخ الإضافة ";
            dltErrMsg = " Not Removed ";
            chkMsg =  " من فضلك إختر الحملات التى تريد حذفها . ";
        }

        ArrayList callResLst = (ArrayList) request.getAttribute("callResLst");
        String issueID = (String) request.getAttribute("issueID");
    %>
    
    <head>
        <meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
        <meta HTTP-EQUIV="Expires" CONTENT="0"/>

        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css"/>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery-ui-timepicker-addon.css"/>
        <link rel="stylesheet" type="text/css" href="css/msdropdown/dd.css" />
        <link rel="stylesheet" type="text/css" href="js/w2ui/w2ui-1.5.rc1.min.css" />

        <script type="text/javascript" src="jquery-ui/jquery-1.6.2.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.widget.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.mouse.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.slider.js"></script>  
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>   
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.dialog.js"></script>   
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.position.js"></script>  
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <script type="text/javascript" src="js/msdropdown/jquery.dd.min.js"></script>

        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.easing.1.3.js"></script>
        <script type="text/javascript" src="js/w2ui/w2ui-1.5.rc1.min.js"></script>

        <script type="text/javascript">
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
            });
            
            var minDateS = '<%=nowTime%>';
            function appCallResultChange() {
                if ($("#appCallResult option:selected").text() == "Other Date"){
                    $("#otherdate").show();
                } else {
                    $("#otherdate").hide();
                }
            }

            function callResultsChange() {
                var selectedValue = $("#nextAction option:selected").val();
                if (selectedValue === "Follow" || selectedValue === "meeting" || selectedValue === "Wait" || selectedValue === "Done"
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
                if (callResult == "meeting") {
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
                    $("#meetingDateTD").css("display", "none");
                    $("#meetresaultlbl").css("display", "none");
                    $("#nextAction").append('<option value="not answered" selected>not answered</option>');
                    $("#callResultTD").css("display", "none");
                    $("#nextAction").css("display", "none");
                    $("#timeflag").val("3");
                } else {
                    $("#callResultTD").css("display", "none");
                    $("#nextAction").css("display", "none");
                    $("#meetresaultlbl").css("display", "none");
                    $("#meetingDateTD").css("display", "none");
                    $("#timeflag").val("3");
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
                
                $("#meetingDate").datetimepicker({
                    changeMonth: true,
                    changeYear: true,
                    minDate: new Date(minDateS),
                    maxDate: '<%=currentYear%>' + '/' + '<%=currentMonth + 1%>' + '/' + '<%=currentDay%>',
                    dateFormat: "yy/mm/dd",
                    timeFormat: "HH:mm"
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
                        bookmarkText: details
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
                            var url = "<%=context%>/EmailServlet?op=viewDocument&docID=" + jsonString + "&docType=pdf";
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
            
            function  popupMailBox(){
                var clientid = "<%=clientWbo != null ? clientWbo.getAttribute("clientNO") : ""%>";
                var clientname = "<%=clientWbo != null ? clientWbo.getAttribute("name") : ""%>";
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
            
            function showAttachedFiles(){
                var url = "<%=context%>/SeasonServlet?op=showAttachedFiles&clientID=" + $("#clientId").val();
                jQuery('#show_attached_files').load(url);
                $('#show_attached_files').css("display", "block");
                $('#show_attached_files').bPopup();
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
            
            function popupAddCampaign() {
                var divTag = $("#addCampaign");
                divTag.dialog({
                    modal: true,
                    title: "Add Campaign",
                    show: "blind",
                    hide: "explode",
                    width: 800,
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
                                }
                        <%
                            }
                        %>
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
                var divTag = $("#appointments");
                $.ajax({
                    type: "post",
                    url: '<%=context%>/AppointmentServlet?op=getClientAppointments',
                    data: {
                        clientID: '<%=clientWbo != null ? clientWbo.getAttribute("id") : ""%>'
                    }, success: function (data) {
                        divTag.html(data).dialog({
                            modal: true,
                            title: "متابعات العميل",
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
            
            function changeClientRate(clientID) {
                var rateID = $("#clientRate option:selected").val();
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
		if($("#clntCmpCkBxAll").val() == "off"){
		    $("input[name='clntCmpCkBx']").each(function(){
			$(this).prop("checked", true);
		    });
		    
		    $("#clntCmpCkBxAll").val("on");
		} else if($("#clntCmpCkBxAll").val() == "on"){
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
                
                if(clntCmpCkBx.length <= 0 ){
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
        </script>
                    
        <style>
            table label {
                float: right;
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
                background: #FFF
            }
            
            tr:nth-child(odd) td.dataTD {
                background: #f1f1f1
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
                margin-bottom: 30px;
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
            
            .edit-icon {
                content:url('images/user_red_edit.png');
            }
            
            .print-icon {
                content:url('images/pdf_icon.gif');
            }
            
            .unbookmark-icon {
                content:url('images/star1.jpg');
            }
            
            .bookmark-icon {
                content:url('images/star2.jpg');
            }
            
            .finical-icon {
                content:url('images/finical-rebort.png');
            }
            
            .contract-icon {
                content:url('images/contract_icon.jpg');
            }
            
            .attach-icon {
                content:url('images/attach.png');
            }
            
            .view-file-icon {
                content:url('images/Foldericon.png');
            }
            
            .recommend-icon {
                content:url('images/recommend_client.gif');
            }
            
            .view-client-icon {
                content:url('images/client_vip.png');
            }
            
            .delete-icon {
                content:url('images/icons/delete_ready.png');
            }
            
            .reserved-icon {
                content:url('images/reserved_house.JPG');
            }
            
            .details-icon {
                content:url('images/communication.png');
            }
            
            .followup-icon {
                content:url('images/icons/follow_up.png');
            }
            
            .comment-icon {
                content:url('images/dialogs/comment_public.ico');
            }
            
            .view-comment-icon {
                content:url('images/dialogs/comment_channel.png');
            }
            
            .appointment-icon {
                content:url('images/dialogs/planning.png');
            }
            
            .view-appointment-icon {
                content:url('images/icons/calendar-256.png');
            }
            
            .mailbox-icon {
                content:url('images/dialogs/mailbox.png');
            }
            
            .campaign-icon {
                content:url('images/icons/add_event2.png');
            }
            
            .view-request-icon {
                content:url('images/icons/listing.png');
            }
            
            .session-icon {
                content:url('images/session-icon.png');
            }
            
            .request-icon {
                content:url('images/icons/icon-claims.png');
            }
            
            .unit-icon {
                content:url('images/icons/units.png');
            }
            
            .email-icon {
                content:url('images/icons/email.png');
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
                    
                    function popupAttach() {
                        $("#attachMessage").html("");
                        count = 1;
                        $("#addFile").removeAttr("disabled");
                        $("#counterFile").val("0");
                        $("#listAttachFile").html("");
                        $('#attach_file').show();
                        $('#attach_file').bPopup({
                            easing: 'easeInOutSine',
                            speed: 400,
                            transition: 'slideDown'
                        });
                    }
                    
                    var count = 1;
                    var validName = false;
                    var validPhoneMobile = false;
                    function addFiles(obj) {
                        if ((count * 1) == 4) {
                            $("#addFile").removeAttr("disabled");
                        }
                        
                        if (count >= 1 & count <= 4) {
                            $("#listAttachFile").append("<input type='file' style='float: right;text-align:right;font-size:12px;margin:1.5px;' name='file" + count + "' id='file" + count + "'  maxlength='60'/>");
                                $("#counterFile").val(count);
                                count = Number(count * 1 + 1);
                        } else {
                            $("#addFile").attr("disabled", true);
                        }
                    }
                    
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
                        $("#saveClient").hide();
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
                        $("#appTitle").val("");
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
                            if ($(obj).parent().parent().parent().find($("#appTitle")).val() !== null) {
                                title = $(obj).parent().parent().parent().find($("#appTitle")).val();
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
                            var timeflag=$("#timeflag").val();
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
                                                dd.destroy();
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
                                                        
                                                    case "Not Suitable":
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
                                                }

                                                var Exists = false, Statustxt;
                                                switch (callStatus) {
                                                    case "wrong number":
                                                        Exists = false;
                                                    case "answered":
                                                        Exists = false;
                                                    case "not answered":
                                                        Statustxt = "Unreachable";
                                                        Exists = true;
                                                        break;
                                                }
    //                                        });
                                                if (isExists) {
                                                $("#clientRate option:contains(" + rateText + ")").attr('selected', true);
                                                    changeClientRate('<%=clientWbo.getAttribute("id")%>');
                                                } else if (Exists) {
                                                    $("#clientRate option:contains(" + Statustxt + ")").attr('selected', true);
                                                    changeClientRate('<%=clientWbo.getAttribute("id")%>');
                                                }
                                                
                                                $("#clientRate").msDropdown();
                                            } catch (err) {}
                                        } else if (eqpEmpInfo.status == 'no') {
                                            $(obj).parent().parent().parent().parent().find("#progress").show();
                                            $(obj).parent().parent().parent().parent().find("#appMsg").html("لم يتم التسجيل او هذا العميل غير موزع").show();
                                        }
                                        resetfollowup();
                                    }
                                });
                            } else {
                                $("#appTitleMsg").css("color", "white");
                                $("#appTitleMsg").text("أدخل عنوان المقابلة");
                            }
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
                        $(obj).parent().parent().parent().parent().find("#progress").show();
                        $.ajax({
                            type: "post",
                            url: "<%=context%>/CommentsServlet?op=saveComment",
                            data: {
                                clientId: clientId,
                                type: type,
                                comment: comment,
                                businessObjectType: businessObjectType
                            }, success: function (jsonString) {
                                var eqpEmpInfo = $.parseJSON(jsonString);
                                if (eqpEmpInfo.status == 'ok') {
                                    $(obj).parent().parent().parent().parent().find("#commMsg").show();
                                    $(obj).parent().parent().parent().parent().find("#progress").hide();
                                    $('#add_comments').css("display", "none");
                                    $('#add_comments').bPopup().close();
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
                    
                    function popupShowComments() {
                        var url = "<%=context%>/CommentsServlet?op=showClientComments&clientId=" + "<%=clientWbo.getAttribute("id")%>" + "&objectType=1&random=" + (new Date()).getTime();
                        jQuery('#show_comments').load(url);
                        $('#show_comments').css("display", "block");
                        $('#show_comments').bPopup();
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
                                                    var html = '<a href="#"><img style="height:35px;" class="edit-icon" title="Edit" onclick="JavaScript: updateClientInformation();"/></a>';
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
                                                    var html = '<a href="#"><img style="height:35px;" class="print-icon" title="Datasheet" onclick="JavaScript: printClientInformation(this);"/></a>';
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
                                                    var html = '<a href="#"><img style="height:35px;" class="unbookmark-icon" title="Bookmark" onclick="JavaScript: popupCreateBookmark(this, \x27<%=clientWbo.getAttribute("id")%>\x27);"/></a>';
                                                    return html;
                                                }
                                            }, {
                                                type: 'html',
                                                id: 'bookmarked',
                                                hidden: <%=bookmarksList != null && bookmarksList.isEmpty()%>,
                                                html: function (item) {
                                                    var html = '<a href="#"><img style="height:35px;" class="bookmark-icon" title="Bookmark Details" onclick="JavaScript: deleteBookmark(this, \x27<%=bookmarkId%>\x27, \x27<%=clientWbo.getAttribute("id")%>\x27);"/></a>';
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
                                                    var html = '<a href="#"><img style="height:35px;" class="finical-icon" title="Financials" onclick="JavaScript: printClientFincancial(this);"/></a>';
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
                                                    var html = '<a href="#"><img style="height:35px;" class="contract-icon" title="Contracts" onclick="JavaScript: viewClientContract();"/></a>';
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
                                                    var html = '<a href="#"><img style="height:35px;" class="attach-icon" title="Attach File" onclick="JavaScript: popupAttach();"/></a>';
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
                                                    var html = '<a href="#"><img style="height:35px;" class="view-file-icon" title="View Files" onclick="JavaScript: showAttachedFiles();"/></a>';
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
                                                    var html = '<a href="#"><img style="height:35px;" class="recommend-icon" title="Recommend Client" onclick="JavaScript: popupCreateClient();"/></a>';
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
                                                    var html = '<a href="#"><img style="height:35px;" class="view-client-icon" title="Clients" onclick="JavaScript: popupClientsList();"/></a>';
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
                                                    var html = '<a href="<%=context%>/ClientServlet?op=ConfirmDeleteClient&clientID=<%=clientWbo.getAttribute("id")%>&clientName=<%=clientWbo.getAttribute("name")%>&clientNo=<%=clientWbo.getAttribute("clientNO")%>&fromPage=customSearch"><img style="height:35px;" class="delete-icon" title="Delete"/></a>';
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
                                                    var html = '<a href="#"><img style="height:35px;" class="reserved-icon" title="Reserved"/></a>';
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
                                                    var html = '<a href="#"><img style="height:35px;" class="details-icon" title="Client\x27s Details" onclick="JavaScript: viewClientCommunications();"/></a>';
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
                                                    var html = '<a href="<%=context%>/ClientServlet?op=ViewClientMenu&clientNo=<%=clientWbo.getAttribute("clientNO")%>&clientID=<%=clientWbo.getAttribute("id")%>&button=directCall"><img style="height:35px;" class="followup-icon" title="Direct Call"/></a>';
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
                                                    var html = '<a href="#"><img style="height:35px;" class="comment-icon" title="Comment" onclick="JavaScript: popupAddComment();"/></a>';
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
                                                    var html = '<a href="#"><img style="height:35px;" class="view-comment-icon" title="List Comments" onclick="JavaScript: popupShowComments();"/></a>';
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
                                                    var html = '<a href="#"><img style="height:35px;" class="appointment-icon" title="Plan Appointment" onclick="JavaScript: popupAddPlanningAppointment();"/></a>';
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
                                                    var html = '<a href="#"><img style="height:35px;" class="view-appointment-icon" title="List Appointments" onclick="JavaScript: popupClientAppointments();"/></a>';
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
                                                    var html = '<a href="#"><img style="height:35px;" class="mailbox-icon" title="MailBox" onclick="JavaScript: popupMailBox();"/></a>';
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
                                                    var html = '<a href="#"><img style="height:35px;" class="campaign-icon" title="Add Campaign" onclick="JavaScript: popupAddCampaign();"/></a>';
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
                                                    var html = '<a href="#"><img style="height:35px;" class="view-request-icon" title="View Client\x27s Requests" onclick="JavaScript: popupViewComplaints();"/></a>';
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
                                                    var html = '<a href="<%=context%>/ClientServlet?op=ViewClientMenu&clientNo=<%=clientWbo.getAttribute("clientNO")%>&clientID=<%=clientWbo.getAttribute("id")%>"><img style="height:35px;" class="session-icon" title="Open Session"/></a>';
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
                                                    var html = '<a href="#"><img style="height:35px;" class="request-icon" title="New Request / inquiry" onclick="JavaScript: openInNewWindow(\x27<%=context%>/ClientServlet?op=getNewRequest&clientID=<%=clientWbo.getAttribute("id")%>\x27);"/></a>';
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
                                                    var html = '<a href="#"><img style="height:35px;" class="unit-icon" title="Units" onclick="JavaScript: openInNewWindow(\x27<%=context%>/IssueServlet?op=clientUnits&clientID=<%=clientWbo.getAttribute("id")%>\x27);"/></a>';
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
                                                    var html = '<a href="#"><img style="height:35px;" class="email-icon" title="Send Email" onclick="JavaScript: openEmailDialog(\x27<%=clientWbo.getAttribute("name")%>\x27,\x27<%=clientWbo.getAttribute("email")%>\x27,\x27<%=sendEmail%>\x27);"/></a>';
                                                    return html;
                                                }
                                            }, {
                                                type: 'break'
                                            }
                                    <%
                                        }
                                    %>
                                ], onClick: function (event) {}
                            });
                        });
                    </script>

                    <input type="hidden" id="clntNm" value="<%=clientWbo.getAttribute("name")%>">
                        
                    <table  border="0px" dir="<%=dir%>" class="table" style="width:<fmt:message key="width"/>;text-align: right;margin-bottom: 10px !important;margin-left: auto;margin-right: auto;" >
                        <tr>
                            <td class="td" colspan="2" style="text-align: center;">
                                   
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="td">
                                <table style="width: 100%;">
                                    <tr>
                                        <td class="td titleTD">
                                            <fmt:message key="clientRating" /> 
                                        </td>

                                        <td  style="text-align:right;">
                                            <%
                                                if (privilegesList.contains("CLIENT_RATING")) {
                                            %>
                                                    <select name="clientRate" id="clientRate" style="width: 200px; direction: rtl;"
                                                    onchange="JavaScript: changeClientRate('<%=clientWbo.getAttribute("id")%>');" <%=clientRateWbo == null ? "disabled" : ""%>>
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
                                        <td class="td titleTD">
                                             <fmt:message key="clientid" /> 
                                        </td>
                                        
                                        <td class="td dataTD">
                                            <label >
                                                 <%=clientWbo.getAttribute("clientNO")%> 
                                            </label>
                                        </td>
                                            
                                        <td class="td titleTD">
                                             <fmt:message key="phone"/> 
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
                                    </tr>
                                        
                                    <tr>
                                        <td class="td titleTD">
                                             <fmt:message key="clientname" /> 
                                        </td>
                                        
                                        <td class="td dataTD">
                                            <label>
                                                 <%=clientWbo.getAttribute("name")%> 
                                            </label>
                                            
                                            <input type="hidden" id="hideName" value="<%=clientWbo.getAttribute("name")%>" />
                                            <% 
                                                String mail = "";
                                                if (clientWbo.getAttribute("email") != null) {
                                                    mail = (String) clientWbo.getAttribute("email");
                                                }
                                            %>
                                            
                                            <input type="hidden" id="hideEmail" value="<%=mail%>" />
                                            <input type="hidden" id="clientId" name="clientId" value="<%=clientWbo.getAttribute("id")%>"/>
                                        </td>
                                        
                                        <td class="td titleTD">
                                             <fmt:message key="mobile"/> 
                                        </td>
                                        
                                        <td class="td dataTD">
                                            <%
                                                if (hasCallCenter.equals("1")) {
                                            %>
                                                    <a href="zoiper://<%=mobile%>" style="font-size: 14px;" title="<fmt:message key="call"/>"><%=mobile%><img src="images/icons/click_to_call.png" style="height: 20px; float: left;" title="<fmt:message key="call"/>"/></a>
                                            <%
                                                } else {
                                            %>
                                                    <a href="#" onclick="JavaScript: noCallCenter();" style="font-size: 14px;"><%=mobile%>&nbsp;<img src="images/icons/click_to_call.png" style="height: 20px; float: left;" title="<fmt:message key="call"/>"/></a>
                                            <%
                                                }
                                            %>
                                        </td>
                                    </tr>

                                    <tr>
                                        <td class="td titleTD" nowrap>
                                             <fmt:message key="wifehusband" /> 
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
                                            
                                        <td class="td titleTD">
                                             <fmt:message key="internumber"/> 
                                        </td>
                                        
                                        <td class="td dataTD">
                                            <%
                                                if (hasCallCenter.equals("1")) {
                                            %>
                                                    <a href="zoiper://<%=interPhone%>" style="font-size: 14px;" title="<fmt:message key="call"/>"><%=interPhone%><img src="images/icons/click_to_call.png" style="height: 20px; float: left;" title="<fmt:message key="call"/>"/></a>
                                            <%
                                                } else {
                                            %>
                                                    <a href="#" onclick="JavaScript: noCallCenter();" style="font-size: 14px;"><%=interPhone%>&nbsp;<img src="images/icons/click_to_call.png" style="height: 20px; float: left;" title="<fmt:message key="call"/>"/></a>
                                            <%
                                                }
                                            %>
                                        </td>
                                    </tr>
                                        
                                    <TR>
                                        <td class="td titleTD">
                                             <fmt:message key="birthdate" /> 
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
                                            
                                        <td class="td titleTD">
                                             <fmt:message key="knowUs"/> 
                                        </td>
                                        
                                        <td class="td dataTD">
                                             <%=clientSeasonWbo != null ? clientSeasonWbo.getAttribute("arabicName") : ""%> 
                                        </td>
                                    </TR>  
                                        
                                    <TR>
                                        <td class="td titleTD">
                                             <fmt:message key="gender" /> 
                                        </td>
                                        <td class="td dataTD">
                                            <label>
                                                 <%=clientWbo.getAttribute("gender")%> 
                                            </label>
                                        </td>
                                            
                                        <td class="td titleTD">
                                             <fmt:message key="address" /> 
                                        </td>
                                        
                                        <td class="td dataTD">
                                            <label>
                                                 <%=clientWbo.getAttribute("address") != null && !clientWbo.getAttribute("address").equals("UL") ? clientWbo.getAttribute("address") : ""%> 
                                            </label>
                                        </td>
                                    </TR>
                                            
                                    <TR>
                                        <td class="td titleTD">
                                             <fmt:message key="socialstatus" /> 
                                        </td>
                                        
                                        <td class="td dataTD">
                                            <label>
                                                 <%=clientWbo.getAttribute("matiralStatus")%> 
                                            </label>
                                        </td>

                                        <td class="td titleTD" nowrap>
                                             <fmt:message key="email" /> 
                                        </td>
                                        
                                        <td class="td dataTD">
                                            <label>
                                                 <%=clientWbo.getAttribute("email") != null && !clientWbo.getAttribute("email").equals("UL") ? clientWbo.getAttribute("email") : ""%> 
                                            </label>
                                        </td>
                                    </TR>
                                            
                                    <tr>
                                        <td class="td titleTD">
                                             <fmt:message key="id" /> 
                                        </td>
                                        
                                        <td class="td dataTD">
                                            <label>
                                                 <%=clientWbo.getAttribute("clientSsn") != null && !clientWbo.getAttribute("clientSsn").equals("UL") ? clientWbo.getAttribute("clientSsn") : ""%> 
                                            </label>
                                        </td>
                                            
                                        <td class="td titleTD">
                                             <fmt:message key="isworkabroad" /> 
                                        </td>
                                        
                                        <td class="td dataTD">
                                            <label>
                                                 <%=clientWbo.getAttribute("option1") != null && clientWbo.getAttribute("option1").equals("1") ? yes : no%> 
                                            </label>
                                        </td>
                                    </tr>
                                            
                                    <tr>
                                        <td class="td titleTD">
                                             <fmt:message key="job" /> 
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
                                            
                                        <td class="td titleTD">
                                            <!--<fmt:message key="isrelativabroad" />-->
                                        </td>
                                        
                                        <td class="td dataTD">
                                            <!--<label><%=clientWbo.getAttribute("option2") != null && clientWbo.getAttribute("option2").equals("1") ? yes : no%></label>-->
                                        </td>
                                    </tr>
                                        
                                    <tr>
                                        <td class="td titleTD">
                                             <fmt:message key="region" /> 
                                        </td>
                                        
                                        <td class="td dataTD" >
                                            <%
                                                String regionName = "";
                                                WebBusinessObject wbo_ = new WebBusinessObject();
                                                wbo_ = projectMgr.getOnSingleKey((String) clientWbo.getAttribute("region"));
                                                if (wbo_ != null) {
                                                    regionName = (String) wbo_.getAttribute("projectName");
                                                }
                                            %>
                                            
                                            <label>
                                                 <%=regionName%> 
                                            </label>
                                        </td>
                                        <td class="td titleTD">
                                             <fmt:message key="branch" /> 
                                        </td>
                                        
                                        <td class="td dataTD" >
                                            <label>
                                                 <%=clientWbo.getAttribute("branchName") != null ? clientWbo.getAttribute("branchName") : ""%> 
                                            </label> 
                                        </td>
                                    </tr>
                                            
                                    <tr>
                                        <td class="td titleTD" >
                                             <fmt:message key="notes" /> 
                                        </td>
                                        
                                        <td class="td dataTD" style="text-align: <fmt:message key="align" /> " colspan="3">
                                            <textarea readonly rows="8" cols="55"><%= clientWbo.getAttribute("description") != null && !((String) clientWbo.getAttribute("description")).equals("UL") ? clientWbo.getAttribute("description") : "&nbsp;"%></textarea>
                                        </td>
                                    </tr>
                                        
                                    <tr>
                                        <td class="td titleTD">
                                             <fmt:message key="mail2" /> 
                                        </td>
                                        
                                        <td class="td dataTD" style="vertical-align: top;">
                                            <table width="100%">
                                                <%
                                                    if (emailsList != null && emailsList.size() > 0) {
                                                        for (WebBusinessObject email : emailsList) {
                                                %>
                                                            <tr>
                                                                <td class="td dataTD">
                                                                     <%=email.getAttribute("communicationValue")%> 
                                                                </td>
                                                            </tr>
                                                <%
                                                        }
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
                                            
                                        <td class="td titleTD">
                                             <fmt:message key="phone2" /> 
                                        </td>
                                        
                                        <td class="td dataTD" style="vertical-align: top;">
                                            <table width="100%">
                                                <%
                                                    if (phonesList != null && phonesList.size() > 0) {
                                                        for (WebBusinessObject phone : phonesList) {
                                                %>
                                                            <tr>
                                                                <td class="td dataTD">
                                                                     <%=phone.getAttribute("communicationValue")%> 
                                                                </td>
                                                            </tr>
                                                <%
                                                        }
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
                                            
                                    <tr class="titleRow">
                                        <td class="td" colspan="2" style="text-align: right;">
                                             <fmt:message key="Custmmov" /> 
                                        </td>
                                        <!--<td class="td" colspan="2" style="text-align: left;">Customer Dynamics</td>-->
                                    </tr>
                                    <%
                                        UserMgr userMgr = UserMgr.getInstance();
                                        if (clientWbo != null) {
                                            if (clientWbo.getAttribute("currentStatus") != null) {
                                                String currentStatus = (String) clientWbo.getAttribute("currentStatus");
                                                if (currentStatus.equals("11")) {
                                                    currentStatus = client;
                                                } else if (currentStatus.equals("12")) {
                                                    currentStatus = possible;
                                                } else if (currentStatus.equals("13")) {
                                                    currentStatus = chance;
                                                } else if (currentStatus.equals("14")) {
                                                    currentStatus = oncontact;
                                                }
                                    %>
                                                <tr>
                                                    <td class="td detailTD">
                                                         <fmt:message key="status" /> 
                                                    </td>

                                                    <td class="td dataDetailTD">
                                                         <%=currentStatus%> 
                                                    </td>

                                                    <td class="td dataDetailTD" colspan="2">

                                                    </td>
                                                </tr>
                                            <%
                                                }
                                                userWbo = userMgr.getOnSingleKey((String) clientWbo.getAttribute("createdBy"));
                                                String createdBy = userWbo != null ? (String) userWbo.getAttribute("fullName") : "";
                                            %>
                                            <tr>
                                                <td class="td detailTD">
                                                     <fmt:message key="source" /> 
                                                </td>
                                                
                                                <td class="td dataDetailTD">
                                                     <%=createdBy%> 
                                                </td>
                                                
                                                <td class="td detailTD">
                                                     <fmt:message key="signindate" /> 
                                                </td>
                                                
                                                <td class="td dataDetailTD">
                                                     <%=clientWbo.getAttribute("creationTime")%> 
                                                </td>
                                            </tr>
                                    <% 
                                        }
                                        if (ownerUserWbo != null) {
                                    %>
                                            <tr>
                                                <td class="td detailTD">
                                                     <fmt:message key="employee" /> 
                                                </td>
                                                
                                                <td class="td dataDetailTD">
                                                     <%=ownerUserWbo.getAttribute("fullName")%> 
                                                </td>
                                                
                                                <td class="td dataDetailTD" colspan="2">
                                                       
                                                </td>
                                            </tr>
                                    <%
                                        }
                                        String lastUpdate = notfound;
                                        String createdBy = notfound;
                                        if (loggerWbo != null) {
                                            lastUpdate = (String) loggerWbo.getAttribute("eventTime");
                                            userWbo = userMgr.getOnSingleKey((String) loggerWbo.getAttribute("userId"));
                                            createdBy = userWbo != null ? (String) userWbo.getAttribute("fullName") : "";
                                        }
                                    %>
                                    <tr>
                                        <td class="td detailTD">
                                             <fmt:message key="lastedit" /> 
                                        </td>
                                        
                                        <td class="td dataDetailTD">
                                             <%=createdBy%> 
                                        </td>
                                        
                                        <td class="td detailTD">
                                             <fmt:message key="editdate" /> 
                                        </td>
                                        
                                        <td class="td dataDetailTD">
                                             <%=lastUpdate%> 
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                    <%
                        if (showHeader != null && showHeader.equals("true")) {
                    %>
                </fieldset>
                
                <div id="attach_file" style="width: 30%; display: none; position: fixed; margin-left: auto; margin-right: auto;">
                    <div style="clear: both; margin-left: 90%; margin-top: 0px; margin-bottom: -40px;">
                        <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat; -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                                                                                        -moz-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                                                                                        box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                                                                                        -webkit-border-radius: 20px; -moz-border-radius: 20px;
                                                                                        border-radius: 20px;" onclick="closePopup(this)"/>
                    </div>
                    
                    <div class="login" style="width: 90%;text-align: center">
                        <form id="attachForm" action="<%=context%>/EmailServlet?op=attachFile" method="post" enctype="multipart/form-data">
                            <table class="table " style="width:100%;">
                                <tr>
                                    <td style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 30%;">
                                        <lable>
                                             إرفاق ملف 
                                        </lable>
                                        
                                        <input type="button" id="addFile" onclick="addFiles(this)" value="+" />
                                        
                                        <input id="counterFile" value="" type="hidden" name="counter"/>
                                        
                                        <input id="projectId" name="projectId" value="" type="hidden" />
                                    </td>
                                    
                                    <td style="text-align:right;width: 70%;" id="listAttachFile"> 
                                    </td>
                                </tr>
                            </table>
                            
                            <div style="width: 30%;text-align: center;margin-left: auto;margin-right: auto;" id="statusFile">
                                
                            </div>
                            
                            <div id="attachMessage" style="margin-left: auto;margin-right: auto;text-align: center">
                                
                            </div>
                            
                            <input type="submit" value="تحميل"  class="login-submit" style="margin-left: auto; margin-right: auto; text-align: center;" onclick="sendMailByAjax(this)" />
                        </form>
                        <div id="progressx2" style="display: none;">
                            <img src="images/Loading2.gif" width="32px" height="32px;" style="background-repeat: no-repeat;margin-left: auto;margin-right: auto"/>
                        </div>
                    </div>
                </div>
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
                        <table  border="0px"  style="width:100%;"  class="table">
                            <tr>
                                <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 40%;">اسم العميل</td>
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
                                <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;">تليفون</td>
                                <td style="text-align: left;" >
                                    <input type="text" name="phone" id="phone" value=""
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
                                <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;">مويايل</td>
                                <td style="text-align: left;" >
                                    <input type="text" name="clientMobile" id="clientMobile" value=""
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
                        <div style="text-align: center;margin-left: auto;margin-right: auto;clear: both" > <input type="button" value="حفظ"   onclick="JavaScript:createClient();" id="saveClient"class="login-submit"/></div>                             </form>
                        <div id="progressClient" style="display: none;">
                            <img src="images/Loading2.gif" width="32px" height="32px;" style="background-repeat: no-repeat;margin-left: auto;margin-right: auto"/>
                        </div>
                        <div style="margin: 0 auto;width: 90%;text-align: center;color: white;font-size: 16px;font-weight: bold;" id="createClientMsg">
                            تم إضافة العميل
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
                        <table  border="0px"  style="width:100%;"  class="table">
                            <tr>
                                <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 30%;">ملخص</td>
                                <td style="width: 70%; text-align: left;" >
                                    <input name="title" id="title" value="" readonly style="width: 250px;"/>
                                </td>
                            </tr> 
                            <tr>
                                <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 30%;">تفاصيل</td>
                                <td style="width: 70%;" >
                                    <textarea  placeholder="" style="width: 100%;height: 80px;" id="details" > </textarea>
                                </td>
                            </tr> 
                        </table>
                        <div style="text-align: center;margin-left: auto;margin-right: auto;clear: both" > <input type="button" value="حفظ"   onclick="JavaScript:createBookmark(this, '<%=clientWbo.getAttribute("id")%>');" id="saveBookmark"class="login-submit"/></div>                             </form>
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
                                <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 30%;">التعليق</td>
                                <td style="width: 70%;" >
                                    <textarea  placeholder="" style="width: 100%;height: 80px;" id="addCommentArea" name="addCommentArea" > </textarea>
                                </td>
                            </tr> 
                        </table>
                        <div style="text-align: center;margin-left: auto;margin-right: auto;clear: both" > 
                            <input type="button" value="حفظ"   onclick="saveComment(this)" id="saveComm"class="login-submit"/></div></form>
                    <div id="progress" style="display: none;">
                        <img src="images/Loading2.gif" width="32px" height="32px;" style="background-repeat: no-repeat;margin-left: auto;margin-right: auto"/>
                    </div>
                    <div style="margin: 0 auto;display: none; width: 90%;text-align: center;color: white;font-size: 16px;font-weight: bold" id="commMsg">
                        تم إضافة التعليق
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
                                    <b id="appClientName"><%=clientWbo.getAttribute("name")%></b>
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
                                                        <option value="Other">Other</option>
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
                                            <h1 align="center" style="vertical-align: middle">متابعة العميل <b id="appClientName" style="font-weight: bold; font-size: 20px"></b> &nbsp;&nbsp;&nbsp;<img src="images/dialogs/phone.png" alt="phone" width="24px"/></h1>
                                            <div style="text-align: left;margin-left: 2%;margin-right: auto;" > 
                                                <span id="timer" style="font-size: 30px; font-weight: bolder; color: black; padding-left: 20px;"></span>
                                                <button type="button" onclick="javascript: saveFollowUp(this);" style="font-size: 14px; font-weight: bold; width: 150px">حفظ<img style="height:20px; width: 20px" src="images/icons/follow_up.png" title="Follow up"/></button>
                                            </div>
                                            <br />
                                            <table class="table">
                                                <tr>
                                                    <td style="color: #f1f1f1; font-size: 16px; font-weight: bold; text-align: <%=xAlign%>;">الهدف : </td>
                                                    <td style="text-align:right">
                                                        <select id="appTitle" name="appTitle" STYLE="width: 225px;font-size: medium; font-weight: bold;">
                                                            <sw:WBOOptionList wboList='<%=meetings%>' displayAttribute = "projectName" valueAttribute="projectName" />
                                                        </select>
                                                    </td>
                                                </tr>

                                                <tr>
                                                    <td style="color: #f1f1f1; font-size: 16px; font-weight: bold; text-align: <%=xAlign%>;">نوع المتابعة : </td>
                                                    <td td style="text-align:right">
                                                        <select id="callResult" name="callResult" STYLE="width: 225px;font-size: medium; font-weight: bold;" onchange="JavaScript: callResultsChng()">
                                                            <option value="<%=CRMConstants.CALL_RESULT_MEETING%>">Meeting</option>
                                                            <option value="<%=CRMConstants.CALL_RESULT_INBOUNDCALL%>">In-Bound Call</option>
                                                            <option value="<%=CRMConstants.CALL_RESULT_OUTBOUNDCALL%>" selected>Out-Bound Call</option>
                                                            <option value="<%=CRMConstants.CALL_RESULT_INTERNET%>">Night Call</option>
                                                            <option value="<%=CRMConstants.CALL_RESULT_INTERNET%>">Internet</option>
                                                            <option value="<%=CRMConstants.CALL_RESULT_DIRECT_VISIT%>">Direct Visit</option>
                                                        </select>
                                                    </td>
                                                </tr>

                                                <tr>
                                                    <td id="callStatusTd" style="color: #f1f1f1; font-size: 16px; font-weight: bold; text-align: <%=xAlign%>;">حالة المتابعة : </td>
                                                    <td id="callStatusTd" style="text-align:right" >
                                                        <select id="callStatus" name="callStatus" STYLE="width: 225px;font-size: medium; font-weight: bold;" onchange="Javascript: callStatusChange();">
                                                            <option value="not answered">not answered</option>
                                                            <option value="answered" selected>answered</option>
                                                        </select>
                                                    </td>
                                                </tr>

                                                <tr>
                                                    <td style="color: #f1f1f1; font-size: 16px; font-weight: bold; text-align: <%=xAlign%>;">المدة : </td>
                                                    <td style="text-align: right;">
                                                        <input type="number" name="callDuration" id="callDuration" value="1" min="1"
                                                               style="width: 80px;"/> دقيقة
                                                    </td>
                                                </tr>

                                                <tr>
                                                    <td id="callResultTD" style="color: #f1f1f1; font-size: 16px; font-weight: bold; text-align: <%=xAlign%>;">نتيجة المتابعة : </td>
                                                    <td td style="text-align:right;" id="callResultTD">
                                                        <select id="nextAction" name="nextAction" STYLE="width: 225px;font-size: medium; font-weight: bold;" onchange="JavaScript: callResultsChange()">
                                                            <option value="">choose</option>
                                                            <option value="Follow">Follow</option>
                                                            <option value="meeting">Visit</option>
                                                            <option value="Send Email">Send Email</option>
                                                            <option value="Send SMS">Send SMS</option>
                                                            <option value="Send Offer">Send Offer</option>
                                                            <option value="Closed">Closed</option>
                                                            <option value="Not Interested">Not Interested</option>
                                                            <option value="Not Serious">Not Serious</option>
                                                            <option value="Not Suitable">Not Suitable</option>
                                                            <option value="Existing Owner">Existing Owner</option>
                                                            <option value="Wait">Wait</option>
                                                            <option value="Wrong Number">Wrong Number</option>
                                                            <option value="Needs Ready Unit">Needs Ready Unit</option>
                                                            <%-- <sw:WBOOptionList wboList='<%=callResLst%>' displayAttribute = "projectName" valueAttribute="projectName" />--%>
                                                        </select>
                                                    </td>
                                                </tr>

                                                <tr>
                                                    <td id="meetresaultlbl" style="color:#f1f1f1; font-size: 16px; font-weight: bold; text-align: <%=xAlign%>; display:none">وقت المقابلة:  </td>
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
                                                    <td id="appointmentPlacelbl" style="color:#f1f1f1; font-size: 16px; font-weight: bold; text-align: <%=xAlign%>; display:none">الفرع : </td>
                                                    <td>
                                                        <table>
                                                            <tr>
                                                                <td id ="appointmentPlaceDDL" style="text-align:right; display:none">
                                                                    <select id="appointmentPlace" name="appointmentPlace" style="margin-top: 7px;width:200px;font-size: medium;">
                                                                        <sw:WBOOptionList wboList='<%=userProjects%>' displayAttribute = "projectName" valueAttribute="projectName" />
                                                                        <option value="Other">Other</option>
                                                                    </select>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>

                                                <tr>
                                                    <td style="color:#f1f1f1; font-size: 16px;font-weight: bold; text-align: <%=xAlign%>;">تعليق : <br/></td>
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
                                                    <td class="td">
                                                        <select style="width: 100%;" id="campaignID" name="campaignID">
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
                                    </BODY>

                                    </html>
