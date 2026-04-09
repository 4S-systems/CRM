<%@page import="com.crm.common.CRMConstants"%>
<%@page import="com.maintenance.common.Tools"%>
<%@page import="com.tracker.engine.CrmIssueStatus"%>
<%@page import="com.clients.db_access.ClientComplaintsMgr"%>
<%@page import="com.clients.db_access.ClientComplaintsMgr"%>
<%@page import="java.text.DateFormat"%>
<%@page import="com.maintenance.common.UserPrev"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page import="com.silkworm.business_objects.*,com.maintenance.db_access.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.tracker.db_access.*,com.tracker.db_access.IssueMgr"%>
<%@page pageEncoding="UTF-8" %>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld"%> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<HTML>
    <c:set var="loc" value="en"/>
    <c:if test="${!(empty sessionScope.currentMode)}">
        <c:set var="loc" value="${sessionScope.currentMode}"/>
    </c:if>
    <fmt:setLocale value="${loc}"  />
    <fmt:setBundle basename="Languages.Issue.getCompl3"  />

    <%
        String stat = (String) request.getSession().getAttribute("currentMode");
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        SecurityUser securityUser = (SecurityUser) session.getAttribute("securityUser");
        Calendar cal = Calendar.getInstance();
        int currentDay = cal.get(cal.DAY_OF_MONTH);
        int currentYear = cal.get(cal.YEAR);
        int currentMonth = cal.get(cal.MONTH);
        String timeFormat = "yyyy/MM/dd HH:mm";
        SimpleDateFormat sdf = new SimpleDateFormat(timeFormat);
        String nowTime = sdf.format(cal.getTime());
        String status = (String) request.getAttribute("status");
        String issueId = (String) request.getAttribute("issueId");
        List<WebBusinessObject> allEmployees = new ArrayList();
        ArrayList<WebBusinessObject> dependOnIssuesList = (ArrayList<WebBusinessObject>) request.getAttribute("dependOnIssuesList");
        allEmployees = (ArrayList) request.getAttribute("allEmployees");
        List<WebBusinessObject> userUnderManager = (ArrayList) request.getAttribute("userUnderManager");
        IssueMgr issueMgr = IssueMgr.getInstance();
        WebBusinessObject issueWbo = (WebBusinessObject) issueMgr.getOnSingleKey(issueId);

        String sourceName = "";
        String issueType = "";
        String age = "";
        if (issueWbo != null) {
            ClientComplaintsMgr comcomplaintsMgr = ClientComplaintsMgr.getInstance();
            int numOfOrders = comcomplaintsMgr.getNumberOfAppropriations(issueId);
            issueWbo.setAttribute("numOfOrders", numOfOrders);

            WebBusinessObject user = UserMgr.getInstance().getOnSingleKey((String) issueWbo.getAttribute("userId"));
            sourceName = (String) user.getAttribute("userName");
            if (issueWbo.getAttribute("issueTitle").toString().equalsIgnoreCase("Extracting")) {
                issueType = "مستخلص رقم: " + (String) issueWbo.getAttribute("projectName");
            }
            String creationTime = issueMgr.getColumnDateTime(issueId, "creation_time");
            age = DateAndTimeControl.getDelayTimeByDay(creationTime, stat);
        }
        Vector<WebBusinessObject> clientCompVector = new Vector();
        String clientCompId = (String) request.getParameter("compId");
        clientCompVector = IssueByComplaintUniqueMgr.getInstance().getOnArbitraryKey(request.getParameter("compId").toString(), "key4");
        String complaintId = (String) request.getAttribute("complaintId");
        ClientComplaintsMgr clientComplaintsMgr = ClientComplaintsMgr.getInstance();
        WebBusinessObject wb = new WebBusinessObject();
        wb = clientComplaintsMgr.getCurrentOwner(clientCompId);

        String call_status = (String) issueWbo.getAttribute("callType");
        String entryDate = (String) issueWbo.getAttribute("currentStatusSince");
        entryDate = entryDate.substring(0, 10);
        entryDate = entryDate.replace("-", "/");
        if (call_status == null) {
            call_status = "";

        }
        ArrayList<WebBusinessObject> actionsList = (ArrayList<WebBusinessObject>) request.getAttribute("actionsList");
        ArrayList<WebBusinessObject> closureActionsList = (ArrayList<WebBusinessObject>) request.getAttribute("closureActionsList");

        String context = metaMgr.getContext();
        ArrayList employeesx = (ArrayList) request.getAttribute("employeesx");
        //Privileges
        ArrayList<WebBusinessObject> prvType = new ArrayList();
        prvType = securityUser.getComplaintMenuBtn();
        ArrayList<String> privilegesList = new ArrayList();
        for (WebBusinessObject wboTemp : prvType) {
            if (wboTemp != null && wboTemp.getAttribute("prevCode") != null) {
                privilegesList.add((String) wboTemp.getAttribute("prevCode"));
            }
        }

        // Issue owner and manager
        boolean isOwner = (Boolean) request.getAttribute("isOwner");
        boolean isOwnerManager = (Boolean) request.getAttribute("isOwnerManager");

        clientComplaintsMgr = ClientComplaintsMgr.getInstance();
        WebBusinessObject clientCompWbo = clientComplaintsMgr.getOnSingleKey(clientCompId);

        String viewDocuments, photoGallery, viewRequest, viewFinishCloseComments, viewAllComments;
        String complaint, req, inquiry, extract;
        if (stat.equals("En")) {

            complaint = "complaint";
            req = "Request";
            inquiry = "Inquiry";
            extract = "Extract";
            viewDocuments = "View Documents";
            photoGallery = "Photo Gallery";
            viewRequest = "View Request";
            viewFinishCloseComments = "View Finish-Close Comments";
            viewAllComments = "View All Comments";
        } else {

            complaint = "شكوى";
            req = "طلب";
            inquiry = "استعلام";
            extract = "مستخلص";
            viewDocuments = "مشاهدة ";
            photoGallery = "عرض الصور";
            viewRequest = "مشاهدة طلب تسليم";
            viewFinishCloseComments = "مشاهدة تعليقات اﻷنهاء-اﻷغلاق";
            viewAllComments = "مشاهدة كل التعليقات";
        }
        String clientId = (String) request.getAttribute("clientId");
        WebBusinessObject userWbo = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
        UserStoresMgr userStoresMgr = UserStoresMgr.getInstance();
        GroupPrevMgr groupPrevMgr = GroupPrevMgr.getInstance();
        Vector groupPrev = new Vector();
        groupPrev = groupPrevMgr.getOnArbitraryKey(userWbo.getAttribute("groupID").toString(), "key1");
        Vector userPrev = new Vector();
        userPrev = userStoresMgr.getOnArbitraryKey(userWbo.getAttribute("userId").toString(), "key1");
        UserPrev userPrevObj = new UserPrev();
        WebBusinessObject userPrevWbo = null;
        userPrevObj.setUserId(userWbo.getAttribute("userId").toString());
        if (groupPrev.size() > 0) {
            for (int x = 0; x < groupPrev.size(); x++) {
                userPrevWbo = new WebBusinessObject();
                userPrevWbo = (WebBusinessObject) groupPrev.get(x);
                if (userPrevWbo.getAttribute("prevCode").equals("COMMENT")) {
                    userPrevObj.setComment(true);
                } else if (userPrevWbo.getAttribute("prevCode").equals("FORWARD")) {
                    userPrevObj.setForward(true);
                } else if (userPrevWbo.getAttribute("prevCode").equals("CLOSE")) {
                    userPrevObj.setClose(true);
                } else if (userPrevWbo.getAttribute("prevCode").equals("FINISHED")) {
                    userPrevObj.setFinish(true);
                } else if (userPrevWbo.getAttribute("prevCode").equals("BOOKMARK")) {
                    userPrevObj.setBookmark(true);
                }
            }
        } else {
            for (int x = 0; x < userPrev.size(); x++) {
                userPrevWbo = new WebBusinessObject();
                userPrevWbo = (WebBusinessObject) userPrev.get(x);
                if (userPrevWbo.getAttribute("prevCode").equals("COMMENT")) {
                    userPrevObj.setComment(true);
                } else if (userPrevWbo.getAttribute("prevCode").equals("FORWARD")) {
                    userPrevObj.setForward(true);
                } else if (userPrevWbo.getAttribute("prevCode").equals("CLOSE")) {
                    userPrevObj.setClose(true);
                } else if (userPrevWbo.getAttribute("prevCode").equals("FINISHED")) {
                    userPrevObj.setFinish(true);
                } else if (userPrevWbo.getAttribute("prevCode").equals("BOOKMARK")) {
                    userPrevObj.setBookmark(true);
                }
            }
        }

        String finRequestSubject = "مطالبة مالية";
        String finRequestComment = "مطالبة مالية";

        String compType = "";

        boolean showDetails = true;
        if (clientCompWbo.getAttribute("ticketType").toString().equals("1")) {
            compType = complaint;
        } else if (clientCompWbo.getAttribute("ticketType").toString().equals("2")) {
            compType = req;
        } else if (clientCompWbo.getAttribute("ticketType").toString().equals("3")) {
            compType = inquiry;
        } else if (clientCompWbo.getAttribute("ticketType").toString().equals("5")) {
            compType = extract;
            showDetails = false;
        } else if (clientCompWbo.getAttribute("ticketType").toString().equals("6")) {
            compType = "ط. تسليم";
            showDetails = false;
        } else if (clientCompWbo.getAttribute("ticketType").toString().equals("7")) {
            compType = "م. مالية";
            showDetails = false;
        } else if (clientCompWbo.getAttribute("ticketType").toString().equals("12")) {
            compType = "أمر تشغيل";
            showDetails = false;
        }
    %>



    <!DOCTYPE html>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>Untitled Document</title> 
        
        <script type="text/javascript" src="jquery-ui/jquery-1.6.2.js"></script>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css">
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.widget.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.drop.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.fold.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.mouse.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.slider.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <script type="text/javascript" src="js/wz_tooltip.js"></script>
        <script type="text/javascript" src="js/tip_balloon.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/default/easyui.css">
        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/icon.css">
        <script type="text/javascript" src="jquery-easyui/easyloader.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.widget.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.mouse.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.slider.js"></script>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery-ui-timepicker-addon.css"/>
        <link rel="stylesheet" href="css/viewComp3.css"/>

        <script type="text/javascript">
            function assigntaskstatus(status)
            {
                if (status === "2" || status === "3" || status === "4")
                {
                    $("#opened").addClass("label-warning");
                } else if (status === "5")
                {
                    $("#canceled").addClass("label-warning");
                } else if (status === "6")
                {
                    $("#finished").addClass("label-warning");
                } else if (status === "7")
                {
                    $("#closed").addClass("label-warning");
                }
            }

            var d = new Date();
            var month = d.getMonth();
            var day = d.getDate();
            var year = d.getFullYear();
            var minDateS = '<%=entryDate%>';
            $(function () {
                $("#closedEndDate,#finishEndDate,#rejectedEndDate").datetimepicker({
                    changeMonth: true,
                    changeYear: true,
                    minDate: new Date(minDateS),
                    maxDate: '<%=currentYear%>' + '/' + '<%=currentMonth + 1%>' + '/' + '<%=currentDay%>',
                    dateFormat: "yy/mm/dd",
                    timeFormat: "hh:mm"
                });
            });
            $(function () {

                var height = $("#cc").height();
                $("#line").css("height", height);
            })
   $(function() {
           $("#ShowEditC").click(function(){
                  $("#complaintComment").hide();
                  $("#complaintTA").show();
                   $("#SaveEditedComment").show();
                   $("#ShowEditC").hide();
                  
                    });
          });
            $(function () {

                $('#employeesTable').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]],
                    iDisplayLength: 10,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true,
                    "aaSorting": [[5, "desc"]]

                }).show();
            });

            //    (function($) {
            //
            //        // DOM Ready
            //        $(function() {
            //
            //            // Binding a click event
            //            // From jQuery v.1.7.0 use .on() instead of .bind()
            //            $('#showDetails').on('click', function(e) {
            //
            //                // Prevents the default action to be triggered. 
            //                e.preventDefault();
            //
            //                $('#call_center').bPopup({
            //                    modal: true,
            //                    fadeSpeed: 'fast', //can be a string ('slow'/'fast') or int
            //                    followSpeed: 'fast', //can be a string ('slow'/'fast') or int
            //                    modalColor: 'white'
            //                });
            //            });
            //
            //        });
            //
            //    })(jQuery);

            function getClientComplaintWithComments(complaintId)
            {
                var url = "<%=context%>/ReportsServlet?op=clientComplaintWithComments&complaintId=" + complaintId + "&objectType=" + $("#businessObjectType2").val();
                openWindow(url);
            }
function updateComplaintComment(clientComId) {
                
                    var newComment = $("#complaintTA").val();
                    $.ajax({
                        type: "post",
                        url: "<%=context%>/IssueServlet?op=updateCommentByAjax",
                        data: {
                            newCode: newComment,
                            clientComplaintID: clientComId
                        },
                        success: function (jsonString) {
                            var info = $.parseJSON(jsonString);
                            if (info.status === 'ok') {
                               location.reload();
                        }
                    }});
              }
            function openWindow(url) {
                window.open(url, "_blank", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=no, copyhistory=no, width=750, height=400");
            }
            function openWindowTasks(url)
            {
                window.open(url, "_blank", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=no, copyhistory=no,width=800,height=400");
            }
            function getComment()
            {
                console.log("getcomment");
                $(".submenux").hide();
                $(".button_commx").attr('id', '0');
                $('#add_comm').find($("#uploadedFile")).replaceWith($('#uploadedFile').clone());
                $('#add_comm').css("display", "block");
                $('#add_comm').bPopup();
            }
            function showComments()
            {
                $(".submenux").hide();
                $(".button_commx").attr('id', '0');
                var url = "<%=context%>/CommentsServlet?op=showComments&clientId=" + $("#clientCompId").val() + "&objectType=" + $("#businessObjectType2").val() + "&random=" + (new Date()).getTime();
                jQuery('#show_comm').load(url);
                $('#show_comm').css("display", "block");
                $('#show_comm').bPopup();
            }

            function showAttachedFiles()
            {
                //            $(".submenux").hide();
                //            $(".button_commx").attr('id', '0');

                var url = "<%=context%>/DocumentServlet?op=showAttachedFiles&compId=" + <%=clientCompId%>;
                jQuery('#show_attached_files').load(url);
                $('#show_attached_files').css("display", "block");
                $('#show_attached_files').bPopup();
            }
            $(document).keyup(function (e) {

                //            if (e.keyCode == 13) { $('.save').click(); }     // enter
                if (e.keyCode == 27) {
                    $("#report").window('close')
                }   // esc
            });
            function comp_Report(obj) {
                $(".submenux").hide();
                $(".button_commx").attr('id', '0');
                var url = "<%=context%>/ClientServlet?op=showStagesOfRequest&clientComplaintId=" + $("#clientCompId").val();
                jQuery('#complaintReport').load(url);
                $('#complaintReport').css("display", "block");
                $('#complaintReport').bPopup();
            }
            var count = 1;
            function popupAttach(obj) {
                $("#info").html("");
                count = 1;
                $("#addFile2").removeAttr("disabled");
                $("#counter2").val("0");
                $("#listFile2").html("");
                $('#attach_content').show();
                $('#attach_content').bPopup();
            }
            function addFiles2(obj) {
                if ((count * 1) == 4) {
                    $("#addFile2").removeAttr("disabled");
                }

                if (count >= 1 & count <= 4) {
                    $("#listFile2").append("<input type='file' style='float: right;text-align:right;font-size:12px;margin:1.5px;' name='file" + count + "' id='file2'  maxlength='60'/>");
                    $("#counter2").val(count);
                    count = Number(count * 1 + 1)

                } else {
                    $("#addFile2").attr("disabled", true);
                }
            }
            function submitFile() {
                $("#complaintFileForm").find("#progressx").css("display", "block");
                $("#progressx").show();
                $("#message").html("");
                $("#progressx").css("display", "block");
                var formData = new FormData($("#complaintFileForm")[0]);

                $.ajax({
                    url: '<%=context%>/DocumentServlet?op=saveMultiFiles',
                    type: 'POST',
                    data: formData,
                    async: false,
                    success: function (data) {
                        var result = $.parseJSON(data);
                        $("#progressx").html('');
                        $("#progressx").css("display", "none");
                        if (result.status == 'success') {
                            $("#info").html("<font color='white'>تم رفع الملفات</font>");
                        } else if (result.status == 'failed') {
                            $("#info").html("<font color='red'>لم يتم رفع الملفات</font>");
                        }
                    },
                    error: function ()
                    {
                        $("#info").html("<font color='red'>لم يتم رفع الملفات</font>");
                    },
                    cache: false,
                    contentType: false,
                    processData: false
                });

                return false;
            }

            function redirectComplaintToEmployee(obj) {
                //        alert('order');
                //        var comment = $(obj).parent().parent().find('#order').val();
                //        var userId = $(obj).parent().parent().find('#department option:selected').val();
                //            var notes = $(obj).parent().parent().parent().find('#notes').val();
                var empId = $("#department").val();
                var responsibleEmp = $("#department :selected").text();
                //            var note = $("#redirectNote").val();

                $.ajax({
                    type: "post",
                    url: "<%=context%>/IssueServlet?op=redirectComplaintToEmployee",
                    data: {
                        empId: empId,
                        compId:<%=clientCompId%>,
                        issueId:<%=issueId%>


                    },
                    success: function (jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.status == 'ok') {
                            $("#responsibleEmp").html(responsibleEmp);
                            $("#redirectMsg").text("تم التحويل");
                            //                        setTimeout(
                            //                        function() {
                            //                            $('#redirectComp').bPopup().close();
                            ////                            parent.history.back();
                            //                        }
                            //                        , 0000
                            //                    );
                            //                    $('#redirectComp').css("display", "none");
                        }
                        if (info.status == 'error') {
                            $("#redirectMsg").css("color", "red");
                            $("#redirectMsg").text("لم يتم التحويل");
                        }

                    }
                });
            }
            function redirectComplaint(obj) {
                //        alert('order');
                //        var comment = $(obj).parent().parent().find('#order').val();
                //        var userId = $(obj).parent().parent().find('#department option:selected').val();
                var notes = $(obj).parent().parent().parent().find('#notes').val();
                var department = $("#department").val();
                var note = $("#redirectNote").val();
                $.ajax({
                    type: "post",
                    url: "<%=context%>/IssueServlet?op=redirectComplaint&issueId=<%=issueId%>&compId=<%=clientCompId%>",
                                data: {
                                    department: department,
                                    note: note,
                                    clientId: <%=clientId%>
                                },
                                success: function (jsonString) {
                                    var info = $.parseJSON(jsonString);
                                    if (info.status == 'ok') {


                                        setTimeout(
                                                function () {
                                                    $('#redirectComp').bPopup().close();
                                                    parent.history.back();
                                                }
                                        , 0000
                                                );
                                        //                    $('#redirectComp').css("display", "none");
                                    } else {

                                    }
                                }
                            });
                        }
                        function finishComplaint(obj) {
                            //        alert('order');
                            //        var comment = $(obj).parent().parent().find('#order').val();
                            //        var userId = $(obj).parent().parent().find('#department option:selected').val();
                            var notes = $(obj).parent().parent().parent().find('#notes').val();
                            var endDate = $(obj).parent().parent().parent().find('#finishEndDate').val();
                            var actionTaken = $(obj).parent().parent().parent().find('#actionTaken').val();
                            $.ajax({
                                type: "post",
                                url: "<%=context%>/ComplaintEmployeeServlet?op=finishComp&issueId=<%=issueId%>&compId=<%=clientCompId%>",
                                            data: {
                                                notes: notes,
                                                clientId: <%=clientId%>,
                                                endDate: endDate,
                                                actionTaken: actionTaken
                                            },
                                            success: function (jsonString) {



                                                var info = $.parseJSON(jsonString);
                                                if (info.status == 'ok') {
                                                    $("#finishMsg").show();
                                                    $(obj).removeAttr("onclick");
                                                    location.reload();
                                                } else {


                                                }
                                            }
                                        });
                                    }

                                    function addCommentChannel() {
                                        $(".submenux").hide();
                                        $(".button_commx").attr('id', '0');
                                        var url = "<%=context%>/ClientServlet?op=addCommentChannel&clientComplaintId=" + $("#clientCompId").val();
                                        jQuery('#addChannelComment').load(url);
                                        $('#addChannelComment').css("display", "block");
                                        $('#addChannelComment').bPopup();
                                    }

                                    function closeComplaint(obj) {
                                        //        alert('order');
                                        //        var comment = $(obj).parent().parent().find('#order').val();
                                        //        var userId = $(obj).parent().parent().find('#department option:selected').val();
                                        var notes = $(obj).parent().parent().parent().find('#notes').val();
                                        var endDate = $(obj).parent().parent().parent().find('#closedEndDate').val();
                                        var actionTaken = $(obj).parent().parent().parent().find('#actionTaken').val();
                                        //            alert(endDate);
                                        $.ajax({
                                            type: "post",
                                            url: "<%=context%>/ComplaintEmployeeServlet?op=closeComp&issueId=<%=issueId%>&compId=<%=clientCompId%>&subject=<%=finRequestSubject%>&comment=<%=finRequestComment%>&complaintId=<%=clientCompId%>&objectType=" + $("#businessObjectType2").val(),
                                            data: {
                                                notes: notes,
                                                clientId: <%=clientId%>,
                                                endDate: endDate,
                                                actionTaken: actionTaken
                                            },
                                            success: function (jsonString) {



                                                var info = $.parseJSON(jsonString);
                                                if (info.status == 'ok') {
                                                    $("#closedMsg").show();
                                                    $(obj).removeAttr("onclick");
                                                    location.reload();
                                                } else {

                                                }
                                            }
                                        });
                                    }
                                    function    rejectedComplaint(obj) {
                                        var notes = $(obj).parent().parent().parent().find('#notes').val();
                                        var endDate = $(obj).parent().parent().parent().find('#rejectedEndDate').val();
                                        $.ajax({
                                            type: "post",
                                            url: "<%=context%>/ComplaintEmployeeServlet?op=rejectedComplaint&issueId=<%=issueId%>&compId=<%=clientCompId%>",
                                                        data: {
                                                            notes: notes,
                                                            clientId: <%=clientId%>,
                                                            endDate: endDate
                                                        },
                                                        success: function (jsonString) {



                                                            var info = $.parseJSON(jsonString);
                                                            if (info.status == 'ok') {
                                                                $("#rejectedMsg").html("تم الإلغاء بنجاح");
                                                                $("#rejectedMsg").show();
                                                                $(obj).removeAttr("onclick");
                                                                location.reload();
                                                            } else {

                                                            }
                                                        }
                                                    });
                                                }

                                                function clientOperation() {
                                                    window.navigate("IssueServlet?op=clientOperation&clientId=<%=clientId%>&issueId=<%=clientId%>&compId=<%=clientCompId%>");
                                                }
                                                function viewFinishCloseComments(issueID) {
                                                    var url = "<%=context%>/CommentsServlet?op=viewFinishCloseComments&issueID=" + issueID;
                                                    jQuery('#show_attached_files').load(url);
                                                    $('#show_attached_files').css("display", "block");
                                                    $('#show_attached_files').bPopup();
                                                }
                                                function viewAllComments(issueID) {
                                                    var url = "<%=context%>/CommentsServlet?op=viewAllComments&issueID=" + issueID;
                                                    jQuery('#show_attached_files').load(url);
                                                    $('#show_attached_files').css("display", "block");
                                                    $('#show_attached_files').bPopup();
                                                }
        </script>
        <script type="text/javascript">

            var users = new Array();
            var form = null;
            function cancelForm(url)
            {
                window.navigate(url);
            }

            function clearUnitId() {
                users[$("#empOne").val()] = 0;
                $("#empOne").val('');
            }

            function saveComplaintEmployee(c, x) {


                //alert('entered ');
                //            alert("dllllllllllf")
                var complaintId = $("#complaintId").val();
                var empIdArr = $('input[name=empId]');
                var empId = $(empIdArr[x - 1]).val();
                var commentsArr = $('input[name=comments]');
                var comments = $(commentsArr[x - 1]).val();
                var responsibleArr = $('select[name=responsible]');
                var clientCompId = $("#clientCompId").val();
                //            alert("complaintComment");
                var complaintComment = $("#complaintComment").html();
                //            alert(complaintComment);
                var compSubject = $("#compSubject").val();
                //            alert(compSubject)
                var responsible = 1;
                //alert('res= '+responsible);
                $("#save" + x).html("<img src='images/icons/spinner.gif'/>");
                $.ajax({
                    type: "post",
                    url: "<%=context%>/ComplaintEmployeeServlet?op=saveComplaintEmployee",
                    data: {
                        complaintId: complaintId,
                        empId: empId,
                        comments: comments,
                        responsible: responsible,
                        clientCompId: clientCompId,
                        complaintComment: complaintComment,
                        compSubject: compSubject
                    },
                    success: function (jsonString) {
                        var eqpEmpInfo = $.parseJSON(jsonString);
                        if (eqpEmpInfo.status == 'Ok') {

                            $("#save" + x).html("");
                            $("#save" + x).css("background-position", "top");
                            $("#save" + x).removeAttr("onclick");
                            $("#statusCode").val("4");
                            $("#tblDataDiv").hide();
                            $("#closeImg").hide();
                            $(".button_redirec").removeAttr("onclick");
                            $(".button_redirec").click(function () {
                                notAllowed('تم التوزيع مسبقا');
                            });
                        }
                    }
                });
            }
            function notAllowed(obj) {

                alert(obj);
            }
            function remove(t, index) {
                //alert;

                if ($(t).parent().parent().parent().parent().attr('rows').length != 1) {
                    $(t).parent().parent().remove();
                    if ($("#empOne").val() != t.id) {
                        users[t.id] = 0;
                    }

                    var check = document.getElementsByName('order');
                    var index_ = document.getElementsByName('index');
                    //alert(check.length);
                    for (var i = 0; i < check.length; i++) {
                        //alert(i+1);
                        check[i].innerHTML = i + 1;
                        index_[i].value = i + 1;
                        //alert(index_[i].id);
                        index_[i].id = 'index' + (i + 1);
                        //alert(index_[i].id);
                        //$('#order'+index).val(i+1);
                    }

                } else {
                    $(t).parent().parent().parent().parent().parent().parent().remove();
                    segment[t.title] = 0;
                    var check = document.getElementsByName('order');
                    var index_ = document.getElementsByName('index');
                    //alert(check.length);
                    for (var i = 0; i < check.length; i++) {
                        //alert(i+1);
                        check[i].innerHTML = i + 1;
                        index_[i].value = i + 1;
                        //alert(index_[i].id);
                        index_[i].id = 'index' + (i + 1);
                        //alert(index_[i].id);
                        //$('#order'+index).val(i+1);
                    }

                }
            }

            //            function getEmpName(){
            //               // alert('---');
            //                empNameShown=$("#empName").val();
            //                $("#empNameShown").val()=empNameShown;
            //              //  alert('-siteNameShown--'+siteNameShown);
            //            }


            //    $(function() {
            //        $("#showDetails").click(function() {
            //            if ($("#call_center").attr("class") === "hide") {
            //
            //                $("#call_center").removeClass("hide");
            //                $("#call_center").addClass("show");
            //            }
            //            else {
            //                $("#call_center").removeClass("show");
            //                $("#call_center").addClass("hide");
            //            }
            //
            //        });
            //    });
            function submitForm() {
                document.CLIENT_COMPLAINT_FORM.action = "<%=context%>/WFTaskServlet?op=getAddCommentForm&objectType=complaint&businessObjectId=<%=issueId%>";
                        document.CLIENT_COMPLAINT_FORM.submit();
                    }

                    function cancelForm() {
                        document.CLIENT_COMPLAINT_FORM.action = "<%=context%>/SearchServlet?op=searchForClient";
                        document.CLIENT__FORM.submit();
                    }

                    function addCmp() {
                        var projectId = document.getElementById("DepCmp").selectedValue;
                        var comment = document.getElementById("claim_content").value;
                        var url2 = "<%=context%>/IssueServlet?op=insertCmpl&projectId=" + projectId;
                        if (window.XMLHttpRequest) {
                            req = new XMLHttpRequest();
                        } else if (window.ActiveXObject) {
                            req = new ActiveXObject("Microsoft.XMLHTTP");
                        }

                        req.open("post", url2, true);
                        req.send(null);
                    }

                    function saveComplaint(obj) {
                        var comment = $(obj).parent().parent().find('#complaint').val();
                        var userId = $(obj).parent().parent().find('#department option:selected').val();
                        $.ajax({
                            type: "post",
                            url: "<%=context%>/IssueServlet?op=saveCmpl",
                            data: {userId: userId,
                                comment: comment,
                                clientId: '<%=clientId%>'},
                            success: function (jsonString) {
                                var info = $.parseJSON(jsonString);
                                if (info.status == 'Ok') {

                                    // change update icon state
                                    $(obj).html("");
                                    $(obj).css("background-position", "top");
                                }
                            }
                        });
                    }
                    function viewDocument(obj) {
                        var docID = $(obj).parent().find('#docID').val();
                        var docType = $(obj).parent().find('#documentType').val();
                        if (docType == ('jpg')) {
                            $.ajax({
                                type: "post",
                                url: "<%=context%>/DocumentServlet?op=viewDocument",
                                data: {docID: docID,
                                    docType: docType
                                },
                                success: function (jsonString) {
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
                            var url = "<%=context%>/DocumentServlet?op=viewDocument&docID=" + docID + "&docType=" + docType;
                            if (iframe === null) {
                                iframe = document.createElement('iframe');
                                iframe.id = hiddenIFrameID;
                                iframe.style.display = 'none';
                                document.body.appendChild(iframe);
                            }
                            iframe.src = url;
                        }
                    }

                    function testTeleCom() {
                        $.ajax({
                            type: "post",
                            url: "<%=context%>/TeleComServlet?op=testCall",
                            data: {},
                            success: function (jsonString) {
                                var info = $.parseJSON(jsonString);
                                alert(info.status);
                            }
                        });
                    }
                    function showClosedMessage(obj) {
                        var compId =<%=clientCompId%>;
                        $.ajax({
                            type: "post",
                            url: "<%=context%>/IssueServlet?op=showClosedMsg",
                            data: {compId: compId},
                            success: function (jsonString) {
                                var info = $.parseJSON(jsonString);
                                if (info.status == 'ok') {
                                    var closedMsg = info.message;
                                    $("#compNotes").val(closedMsg);
                                    $("#compStatus").html($("#statusCode").val());
                                    $("#compStatus").css("color", "white");
                                    //   $("#compStatus").css("background-color","red");
                                    $("#showNotes").css("display", "block")
                                    $("#showNotes").bPopup();
                                }
                                if (info.status == 'no') {
                                    alert("لاتوجد ملاحظات إنهاء");
                                }
                            }
                        });
                    }

                    function showFinishedMessage(obj) {
                        var compId =<%=clientCompId%>;
                        $.ajax({
                            type: "post",
                            url: "<%=context%>/IssueServlet?op=showFinishedMsg",
                            data: {compId: compId},
                            success: function (jsonString) {
                                var info = $.parseJSON(jsonString);
                                if (info.status == 'ok') {
                                    var closedMsg = info.message;
                                    $("#compNotes").val(closedMsg);
                                    $("#compStatus").html($("#statusCode").val());
                                    $("#compStatus").css("color", "white");
                                    //   $("#compStatus").css("background-color","red");
                                    $("#showNotes").css("display", "block")
                                    $("#showNotes").bPopup();
                                }
                                if (info.status == 'no') {
                                    alert("لاتوجد ملاحظات إنهاء");
                                }
                            }
                        });
                    }


                    function showRejectedMsg(obj) {
                        var compId =<%=clientCompId%>;
                        $.ajax({
                            type: "post",
                            url: "<%=context%>/IssueServlet?op=showRejectedMessage",
                            data: {compId: compId},
                            success: function (jsonString) {
                                var info = $.parseJSON(jsonString);
                                if (info.status == 'ok') {
                                    var closedMsg = info.message;
                                    $("#compNotes").val(closedMsg);
                                    $("#compStatus").html($("#statusCode").val());
                                    $("#compStatus").css("color", "white");
                                    $("#showNotes").css("display", "block")
                                    $("#showNotes").bPopup();
                                }
                                if (info.status == 'no') {
                                    alert("لاتوجد ملاحظات إنهاء");
                                }
                            }
                        });
                    }
                    function remove(obj) {

                        $(obj).parent().parent().remove();
                    }
                    $(function () {
                        $(".button_commx").click(function ()
                        {
                            var X = $(this).attr('id');
                            if (X == 1)
                            {
                                $(".submenux").hide();
                                $(this).attr('id', '0');
                            } else
                            {
                                $(".submenux").show();
                                $(this).attr('id', '1');
                            }

                        });
                        //Mouse click on sub menu
                        $(".submenux").mouseup(function ()
                        {
                            return false
                        });
                        $(".submenux").mouseout(function ()
                        {
                            return false
                        });
                        $(".button_commx").mouseout(function ()
                        {
                            return false
                        });
                        //Mouse click on my account link
                        $(".button_commx").mouseup(function ()
                        {
                            return false
                        });
                        $(document).mouseup(function ()
                        {
                            $(".submenux").hide();
                            $(".button_commx").attr('id', '');
                        });
                        $(document).mouseout(function ()
                        {
                            $(".submenux").hide();
                            $(".button_commx").attr('id', '');
                        });
                        $(document).mouseleave(function ()
                        {
                            $(".submenux").hide();
                            $(".button_commx").attr('id', '');
                        }
                        )
                    })

                    $(function () {
                        $(".attach_button").click(function ()
                        {
                            var X = $(this).attr('id');
                            if (X == 1)
                            {
                                $(".submenuxx").hide();
                                $(this).attr('id', '0');
                            } else
                            {
                                $(".submenuxx").show();
                                $(this).attr('id', '1');
                            }

                        });
                        //Mouse click on sub menu
                        $(".submenuxx").mouseup(function ()
                        {
                            return false
                        });
                        $(".submenuxx").mouseout(function ()
                        {
                            return false
                        });
                        $(".attach_button").mouseout(function ()
                        {
                            return false
                        });
                        //Mouse click on my account link
                        $(".attach_button").mouseup(function ()
                        {
                            return false
                        });
                        $(document).mouseup(function ()
                        {
                            $(".submenuxx").hide();
                            $(".attach_button").attr('id', '');
                        });
                        $(document).mouseout(function ()
                        {
                            $(".submenuxx").hide();
                            $(".attach_button").attr('id', '');
                        });
                        $(document).mouseleave(function ()
                        {
                            $(".submenuxx").hide();
                            $(".attach_button").attr('id', '');
                        }
                        )
                    })
                    /*function closePopup(obj) {
                     console.log("closepopup called arabic");
                     $(obj).bPopup().close();
                     }*/
                    function saveComplaintComment(obj) {
                        // clientId represent business object id in database
                        var clientId = $("#clientCompId").val();
                        var type = $(obj).parent().parent().parent().find($("#commentType2")).val();
                        var comment = $(obj).parent().parent().parent().find($("#comment2")).val();
                        var businessObjectType = $(obj).parent().parent().parent().find($("#businessObjectType2")).val();
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
                            success: function (jsonString) {
                                var eqpEmpInfo = $.parseJSON(jsonString);
                                //                        alert(jsonString);
                                //                        alert(eqpEmpInfo);
                                if (eqpEmpInfo.status == 'ok') {
                                    alert("تم التسجيل بنجاح");
                                    $(obj).parent().parent().parent().parent().find($("#comment2")).html("");
                                    //                        $(obj).parent().parent().parent().parent().find($("#uploadedFile")).replaceWith($('#uploadedFile').clone());

                                    $(obj).parent().parent().parent().parent().find($("#add_comm")).css("display", "none");
                                    $("#add_comm").bPopup().close();
                                } else if (eqpEmpInfo.status == 'no') {

                                    alert("error");
                                }


                            }
                        });
                    }

                    function notificationComp(obj) {
                        $("#notificationMsg").text("");
                        $('#notificationComp').bPopup();
                        $('#notificationComp').css("display", "block");
                    }

                    function notificationComplaintToEmployee(obj) {

                        var selectedEmpsId = $('#employeesTable').find(':checkbox:checked');
                        var employeeId;
                        var ids = "";
                        $(selectedEmpsId).each(function (index, empId) {
                            employeeId = $(empId).parent().find('#employeeId').val();
                            ids += employeeId + ",";


                        })
                        var comment = $("#notificationComment").val();
                        var subject = $("#subject").val();
                        $.ajax({
                            type: "post",
                            url: "<%=context%>/IssueServlet?op=notificationComplaintToEmployee",
                            data: {
                                empIds: ids,
                                clientComplaintId:<%=clientCompId%>,
                                comment: comment,
                                subject: subject
                            },
                            success: function (jsonString) {
                                var info = $.parseJSON(jsonString);
                                if (info.status == 'ok') {
    //                                $("#responsibleEmp").html(responsibleEmp);
                                    $("#notificationMsg").text("تم الإعــــــــــــلام");
                                }
                                if (info.status == 'error') {
                                    $("#notificationMsg").css("color", "red");
                                    $("#notificationMsg").text("لم يتم الإعــــــــــــلام");
                                }
                            }
                        });
                    }

                    function popupUpdateCode() {
                        $('#update_code').bPopup();
                        $('#update_code').css("display", "block");
                    }

                    function updateCode() {
                        var newCode = $("#newCode").val();
                        $.ajax({
                            type: "post",
                            url: "<%=context%>/IssueServlet?op=updateCodeAjax",
                            data: {
                                newCode: newCode,
                                clientComplaintID: '<%=clientCompId%>'
                            },
                            success: function (jsonString) {
                                var info = $.parseJSON(jsonString);
                                if (info.status === 'ok') {
                                    $("#businessCode").html(newCode);
                                    $("#update_code").bPopup().close();
                                }
                            }
                        });
                    }
    //                function notificationComplaintToEmployee(obj) {
    //                    var employeeId = $("#employeeNotification").val();
    //                    var responsibleEmp = $("#employeeNotification :selected").text();
    //                    var comment = $("#comment").val();
    //                    var subject = $("#subject").val();
    //                    $.ajax({
    //                        type: "post",
    //                        url: "<%=context%>/IssueServlet?op=notificationComplaintToEmployee",
    //                        data: {
    //                            employeeId: employeeId,
    //                            clientComplaintId:<%=clientCompId%>,
    //                            comment: comment,
    //                            subject: subject
    //                        },
    //                        success: function(jsonString) {
    //                            var info = $.parseJSON(jsonString);
    //                            if (info.status == 'ok') {
    //                                $("#responsibleEmp").html(responsibleEmp);
    //                                $("#notificationMsg").text("تم الإعــــــــــــلام");
    //                            }
    //                            if (info.status == 'error') {
    //                                $("#notificationMsg").css("color", "red");
    //                                $("#notificationMsg").text("لم يتم الإعــــــــــــلام");
    //                            }
    //                        }
    //                    });
    //                }

        </script>

        <script type="text/javascript">
            function popupCloseO(obj) {
                $("#closedMsg").hide();
                $('#closeNote').find("#notes").val("");
                $('#closeNote').css("display", "block");
                $('#closeNote').bPopup();
            }
            function popupFinishO(obj) {
                $("#finishMsg").hide();
                $('#finishNote').find("#notes").val("");
                $('#finishNote').css("display", "block");
                $('#finishNote').bPopup();
            }
            function rejectedComp(obj) {

                $('#rejectedNote').find("#notes").val("");
                $("#rejectedMsg").text("");
                $('#rejectedNote').css("display", "block");
                $('#rejectedNote').bPopup();
            }
            function redirectComp(obj) {
                $("#redirectMsg").text("");
                $('#redirectComp').bPopup();
                $('#redirectComp').css("display", "block");
            }

            function viewDocuments(issueId) {
                var url = '<%=context%>/IssueDocServlet?op=ListAttachedDocs&issueId=' + issueId + '';
                var wind = window.open(url, "عرض المستندات", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no");
                wind.focus();
            }

            function viewImages(issueId) {
                var url = '<%=context%>/IssueDocServlet?op=ViewIssueImages&issueId=' + issueId + '';
                var wind = window.open(url, "عرض الصور", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no");
                wind.focus();
            }

            function redistributionComp(obj) {
                $("#redistributionComplaintMSG").text("");
                $('#redistributionComp').bPopup();
                $('#redistributionComp').css("display", "block");
            }

            function redistributionComplaintToEmployee(obj) {

                var employeeId = $('#employeesTable2').find(':input:checked');
                if (employeeId.val() != null) {
                    $("#redistBtn").hide();
                    var comment = $("#redistributionComment").val();
                    var subject = $("#subject").val();
                    $.ajax({
                        type: "post",
                        url: "<%=context%>/IssueServlet?op=redistributionComplaintToEmployee",
                        data: {
                            employeeId: employeeId.val(),
                            clientComplaintId:<%=clientCompId%>,
                            issueId: <%=issueId%>,
                            businessId: <%=issueWbo.getAttribute("businessID")%>,
                            comment: "اعادة توجيه من <%=securityUser.getFullName()%>",
                            subject: "اعادة توجيه من <%=securityUser.getFullName()%>"
                        },
                        success: function (jsonString) {
                            var info = $.parseJSON(jsonString);
                            if (info.status == 'ok') {
                                //$("#responsibleEmp").html(employeeId.innerHTML);
                                $("#redistributionComplaintMSG").css("display", "block");
                                $("#redistributionComplaintMSG").css("color", "blue");
                                $("#redistributionComplaintMSG").css("font-size", "15px");
                                $("#redistributionComplaintMSG").text("تم التوجيه");
                            }
                            if (info.status == 'error') {
                                $("#redistBtn").show();
                                $("#redistributionComplaintMSG").css("display", "block");
                                $("#redistributionComplaintMSG").css("color", "red");
                                $("#redistributionComplaintMSG").css("font-size", "15px");
                                $("#redistributionComplaintMSG").text("لم يتم التوجيه");
                            }
                        }, error: function (jsonString) {
                            alert(jsonString);
                        }
                    });
                } else {
                    $("#redistributionComplaintMSG").css("display", "block");
                    $("#redistributionComplaintMSG").css("color", "red");
                    $("#redistributionComplaintMSG").css("font-size", "15px");
                    $("#redistributionComplaintMSG").text("يجب اختيار موظف");
                }
            }

            $(function () {
                $('#employeesTable2').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]],
                    iDisplayLength: 10,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true,
                    "aaSorting": [[5, "desc"]]
                }).show();
            });

            function viewRequest(issueId, clientComplaintId) {
                var url = '<%=context%>/IssueServlet?op=requestComments&issueId=' + issueId + '&clientComplaintId=' + clientComplaintId + '&showPopup=true';
                var wind = window.open(url, "", "toolbar=no,height=" + screen.height + ",width=" + screen.width + ", location=0, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no,navigationbar=0");
                wind.focus();
            }


            function deleteComplaint(issueId, clientComplaintId) {
                window.location.href = '<%=context%>/IssueServlet?op=deleteComplaint&issueId=' + issueId + '&clientComplaintId=' + clientComplaintId;
            }
        </script>
    </head>
    <body>
        <FORM NAME="CLIENT_COMPLAINT_FORM" METHOD="POST">
            <input type="hidden" id="clientId" name="clientId" value="<%=clientId%>"/>
            <input type="hidden" name="complaintId" id="complaintId" value="<%=complaintId%>"/>
            <input type="hidden" name="clientCompId" id="clientCompId" value="<%=clientCompId%>"/>

            <table align="center" width="90%" cellpadding="0" cellspacing="0" style="">
                <tr>
                    <td width="100%" class="titlebar">
                        <font color="#005599" size="4">
                        مركز التحكم والمتابعه
                        </font>
                    </td>
                </tr>
            </table>

            <FIELDSET class="set" style="width:90%;border-color: #006699" >

                <fieldset  class="set" style="width:95%; border-color: #006699;  background-color: #b9d2ef; ">
                    <legend align='center' style="color: #FF3300;  ">
                        <font color="#005599" size="4" >
                        بيانات الاتصال
                        </font>
                    </legend>

                    <TABLE style="width:95%; "dir='<fmt:message key="direction" />'>
                        <TR>
                            <TD style="width:60%; border:none;">
                                <TABLE class='subtable' width="80%" align="center" dir='<fmt:message key="direction" />'  >
                                    <TR>
                                        <TD nowrap CLASS="silver_footer">
                                            <fmt:message key="folloNo"/>
                                        </TD>
                                        <TD width='30%' style="border:none">
                                            <b>
                                                <font color="red" size="3"><%=issueWbo.getAttribute("businessID")%></font>/<font color="blue" size="3" ><%=issueWbo.getAttribute("businessIDbyDate")%></font>
                                            </b>
                                        </TD>
                                        <%if (!issueType.isEmpty() || issueType != null) {%>

                                        <TD nowrap CLASS="silver_footer">
                                            <fmt:message key="topic"/> 
                                        </TD>
                                        <TD width='30%' style="border:none">
                                            <strong><%=issueType%></strong>
                                        </TD>
                                        <%}%>
                                    </TR>
                                    <TR>
                                        <TD nowrap CLASS="silver_footer">
                                            <fmt:message key="source"/>
                                        </TD>
                                        <TD style="border: none">
                                            <strong><%=sourceName%></strong>
                                        </TD>
                                        <TD nowrap CLASS="silver_footer">

                                            <fmt:message key="callage"/>
                                        </TD>
                                        <TD style="border: none">
                                            <strong><%=age%></strong>
                                        </TD>
                                    </TR>
                                    <TR>
                                        <TD nowrap CLASS="silver_footer">
                                            عدد المعتمدات 
                                        </TD>
                                        <TD style="border: none">
                                            <b>
                                                <a href="<%=context%>/IssueServlet?op=getCompUnderIssue&issueId=<%=issueId%>"><font color="red" size="3"><%=issueWbo.getAttribute("numOfOrders")%></font></a>
                                            </b>
                                        </TD>
                                        <TD nowrap CLASS="silver_footer">

                                            <fmt:message key="regdate"/>
                                        </TD>
                                        <TD style="border: none">
                                            <strong><%=issueWbo.getAttribute("creationTime").toString().substring(0, 10)%></strong>
                                        </TD>
                                    </TR>
                                    <%
                                        if (dependOnIssuesList != null && !dependOnIssuesList.isEmpty()) {
                                    %>
                                    <TR>
                                        <TD nowrap CLASS="silver_footer">المعتمدات الاضافية</TD>
                                        <TD>
                                            <b><a href="<%=context%>/IssueServlet?op=getDepOnIssues&issueId=<%=issueId%>"><font color="red" size="3"><%=dependOnIssuesList.size()%></font></a></b>
                                        </TD>

                                    </TR>
                                    <%}%>
                                </TABLE>
                            </TD>
                            <TD style="width:40%; border:none;">
                                <TABLE align="center" width="100%" style="background-color: #e7e7e7;border-radius: 30px">
                                    <TR style="height: 50px"> 
                                        <%if (issueWbo.getAttribute("issueDesc") != null && !((String) issueWbo.getAttribute("issueDesc")).equalsIgnoreCase("internal")) {%>

                                        <td style="border-color: #b9d2ef">
                                            <%if (issueWbo.getAttribute("issueDesc").toString().equals("call")) {%>
                                            <img src="images/dialogs/phone.png" width="30px" height="34px" title="call"/>
                                            <%} else if (issueWbo.getAttribute("issueDesc").toString().equals("internet")) {%>
                                            <img src="images/dialogs/internet-icon.png" width="30px" height="34px" title="Internet"/>
                                            <%} else if (issueWbo.getAttribute("issueDesc").toString().equals("meeting")) {%>
                                            <img src="images/dialogs/handshake.png" width="30px" height="34px" title="Meeting"/>
                                            <%}%>
                                        </td>

                                        <td style="border-color: #b9d2ef">
                                            <%if (issueWbo.getAttribute("callType") != null && issueWbo.getAttribute("callType").toString().equals("incoming")) {%>
                                            <img src="images/dialogs/call-incoming.png" width="30px" height="34px" title="Incoming"/>

                                            <% } else {%>

                                            <img src="images/dialogs/call-outgoing.png" width="30px" height="34px" title="Outgoing"/>
                                            <%}%>
                                        </td>

                                        <%}%>


                                        <%
                                            if (privilegesList.contains("ALL_COMMENTS")) {
                                        %>

                                        <td>

                                            <a href='JavaScript: viewAllComments("<%=issueId%>")'>
                                                <img src="images/list_comments.jpg" height="34" title="<%=viewAllComments%>" />
                                            </a>
                                        </td>

                                        <%
                                            }
                                            if (privilegesList.contains("FINISH_CLOSE_COMMENTS")) {
                                        %>

                                        <td>

                                            <a href='JavaScript: viewFinishCloseComments("<%=issueId%>")'>
                                                <img src="images/finish_comments.png" height="34" title="<%=viewFinishCloseComments%>" />
                                            </a>
                                        </td>

                                        <%
                                            }
                                        %>
                                        <td style="border-color: #b9d2ef">

                                            <a href='JavaScript:viewDocuments("<%=issueId%>")'>
                                                <img src="images/Foldericon.png" width="30" height="34" title="<%=viewDocuments%>" />
                                            </a>
                                        </td>


                                        <td style="border-color: #b9d2ef">
                                            <a href='JavaScript:viewImages("<%=issueId%>")'>
                                                <img src="images/jpgImageIcon.png" width="30" height="34" title="<%=photoGallery%>" />
                                            </a>
                                        </td>


                                        <%
                                            if (privilegesList.contains("FORCE_CHANGE")) {
                                        %>

                                        <td   onclick="JavaScript: popupUpdateCode();" style="cursor: pointer">
                                            <img src="images/change.png" width="30" height="34" title="Force Change" onclick="JavaScript: popupUpdateCode();"/>
                                        </td>

                                        <%
                                            }
                                            if (((String) clientCompWbo.getAttribute("ticketType")).equals(CRMConstants.CLIENT_COMPLAINT_TYPE_REQUEST_EXTRADITION)
                                                    || ((String) clientCompWbo.getAttribute("ticketType")).equals(CRMConstants.CLIENT_COMPLAINT_TYPE_DELIVERY_OF_QUALITY)
                                                    || ((String) clientCompWbo.getAttribute("ticketType")).equals(CRMConstants.CLIENT_COMPLAINT_TYPE_DELIVERY_SUCCESSFUL)) {
                                        %>
                                        <td>
                                            <a href='JavaScript:viewRequest("<%=issueId%>", "<%=clientCompId%>")'>
                                                <img src="images/icons/checklist-icon.png" height="35" title="<%=viewRequest%>" />
                                            </a>
                                        </td>

                                        <%
                                            }
                                        %>

                                    </TR>

                                </TABLE>


                            </TD>

                        </TR>
                    </TABLE>
                    <br>
                </fieldset>

                <%
                    WebBusinessObject wbo = new WebBusinessObject();
                    if (clientCompVector != null && !clientCompVector.isEmpty()) {
                        wbo = clientCompVector.get(0);
                %>
                <br>
                <fieldset  class="set" style="width:95%; border-color: #006699; background-color: #fff0e0  ">
                    <legend align='center' style="color: #FF3300;  ">
                        <font color="#005599" size="4" >
                        <%=compType%>
                        </font>
                    </legend>

                    <TABLE style="width:100%; "dir='<fmt:message key="direction" />'>
                        <TR>
                            <TD style="width:60%; border:none;">
                                <TABLE width="100%"  dir='<fmt:message key="direction" />' >
                                    <TR>
                                        <TD id="datacolumn" style="border: none;width:100%;">
                                            <TABLE class='subtable' width="95%" align="center" dir='<fmt:message key="direction" />'  >
                                                <tr>
                                                    <td nowrap  class="silver_footer"> <fmt:message key="code" /> </td>
                                                    <td  >

                                                        <b>

                                                            <font color="blue" size="3" id="businessCode"><%=wbo.getAttribute("businessCompId")%></font>
                                                        </b>
                                                    </td>
                                                    <td nowrap  class="silver_footer"><fmt:message key="address" /> </td>
                                                    <td >
                                                        <font color="green"  size="3" ><%=wbo.getAttribute("typeName")%></font>
                                                    </td>
                                                </tr>

                                                <tr style="display: <%=showDetails ? "" : "none"%>">
                                                    <td nowrap  class="silver_footer"><b><%=compType%></b></TD>
                                                    <TD >
                                                        <%
                                                            String sCompl = " ";
                                                            if (wbo.getAttribute(
                                                                    "comments") != null && !wbo.getAttribute("comments").equals("")) {
                                                                sCompl = (String) wbo.getAttribute("comments");
                                                        %>


                                                        <font  id="complaintComment" size="3"><%=sCompl%></font>
                                                         <textarea rows="3" id="complaintTA"  hidden="true" style="width: 50%;" ><%=sCompl%></textarea>
                                                         <img src="images/ok2.png"  hidden="true" height="15px" title="save" id="SaveEditedComment" onclick="updateComplaintComment('<%=wbo.getAttribute("clientComId")%>')" /> 
                                                         <img src="images/icons/edit.png"  height="15px" title="edit Comment" id="ShowEditC" /> 
                                           
                                                        <% }%>

                                                    </TD>

                                                    <td nowrap  class="silver_footer"> <fmt:message key="status" /></td>
                                                    <td  >
                                                        <%
                                                            String statusName = "";
                                                            String statusCode2 = (String) request.getAttribute("statusCode");
                                                            if (statusCode2 != null) {
                                                                if (statusCode2.equalsIgnoreCase("2")) {
                                                                    statusName = "مرسلة";
                                                                } else if (statusCode2.equalsIgnoreCase("4")) {
                                                                    statusName = "تم التوزيع";
                                                                } else if (statusCode2.equalsIgnoreCase("3")) {
                                                                    statusName = "تم العلم";
                                                                } else if (statusCode2.equalsIgnoreCase("5")) {
                                                                    statusName = "تم الإلغاء";
                                                                } else if (statusCode2.equalsIgnoreCase("6")) {
                                                                    statusName = "تم الإنهاء";
                                                                } else if (statusCode2.equalsIgnoreCase("7")) {
                                                                    statusName = "تم الإغلاق ";
                                                                } else {
                                                                    statusName = "";
                                                                }
                                                            }
                                                        %>
                                                        <%=statusName%>

                                                    </td> 
                                                </tr>

                                                <tr>
                                                    <td nowrap  class="silver_footer"> <fmt:message key="manager" /></td>
                                                    <td >
                                                        <%
                                                            String managerName = (String) request.getAttribute("managerName");
                                                            String managerId = (String) request.getAttribute("managerId");
                                                            String loggedUserId = securityUser.getUserId();
                                                        %>
                                                        <%=managerName%>
                                                    </td>
                                                    <td nowrap  class="silver_footer"><fmt:message key="responsilbe" /></td>
                                                    <td   id="responsibleEmp">
                                                        <%
                                                            String receipName = "";
                                                            receipName = (String) request.getAttribute("receipName");
                                                        %>
                                                        <%=receipName%>
                                                    </td>
                                                </tr>
                                                <td nowrap  class="silver_footer"> <fmt:message key="taskstatus" /></td>
                                                <td   colspan="3">
                                                    <span id='opened' class="label label-default" style="font-size: 16px;">Opened</span>
                                                    <span id='closed' class="label label-default"  style="font-size: 16px;">Closed</span>
                                                    <span id='finished' class="label label-default"  style="font-size: 16px;">Finished</span>
                                                    <span id='canceled' class="label label-default"  style="font-size: 16px;">Canceled</span>
                                                </td> 
                                                <script >
                                         var status =<%=request.getAttribute("statusCode")%>;
                                         assigntaskstatus(status);
                                                </script>
                                                <tr>

                                                </tr>
                                                <tr>
                                                <input type="hidden" value="<%=statusName%>" id="statusCode" />
                                                <input type="hidden" id="compSubject" value="<%=wbo.getAttribute("compSubject")%>" />
                                    </tr>

                                </TABLE>
                            </TD>
                        </TR>
                    </TABLE>
                    </TD>
                    <%   if (prvType.size() > 0) {
                            CrmIssueStatus crmIssueStatus = new CrmIssueStatus();
                            boolean canNotificate = false;
                            if (privilegesList.contains("NOTIFICATIONS")) {
                                canNotificate = true;
                            }
                            boolean canClose = false;
                            boolean isClosed = false;
                            boolean notFinished = false;
                            if (privilegesList.contains("CLOSE")) {
                                if (crmIssueStatus.canClose(clientCompId) && !crmIssueStatus.canFinish(clientCompId)) {
                                    canClose = true;
                                } else if (!crmIssueStatus.canClose(clientCompId)) {
                                    isClosed = true;
                                } else {
                                    notFinished = true;
                                }
                            }
                            boolean canComment = false;
                            if (privilegesList.contains("COMMENT")) {
                                canComment = true;
                            }
                            boolean canDistribute = false;
                            boolean isDistributed = false;
                            if (privilegesList.contains("FORWARD") && isOwnerManager) {
                                if (crmIssueStatus.canAssign(clientCompId)) {
                                    canDistribute = true;
                                } else {
                                    isDistributed = true;
                                }
                            }
                            boolean canFinish = false;
                            boolean isFinished = false;
                            if (privilegesList.contains("FINISHED")) {
                                if (crmIssueStatus.canFinish(clientCompId)) {
                                    canFinish = true;
                                } else {
                                    isFinished = true;
                                }
                            }
                            boolean canAssign = false;
                            boolean withEmployee = false;
                            boolean orderInAction = false;
                            boolean notDistributed = false;
                            if (privilegesList.contains("ASSIGN") && isOwnerManager) {
                                if ((loggedUserId.equalsIgnoreCase(managerId)) && (statusCode2.equalsIgnoreCase("6"))) {
                                    canAssign = true;
                                } else {
                                    notDistributed = true;
                                }
                            }
                            boolean canCancel = false;
                            if (privilegesList.contains("CANCEL")) {
                                canCancel = true;
                            }
                            boolean canAttach = false;
                            if (privilegesList.contains("ATTACH FILE")) {
                                canAttach = true;
                            }
                            boolean viewOrderPhases = false;
                            if (privilegesList.contains("ORDER PHASES")) {
                                viewOrderPhases = true;
                            }
                            boolean printComplaint = false;
                            if (privilegesList.contains("PRINT COMPLAINT")) {
                                printComplaint = true;
                            }
                            boolean deleteComplaint = false;
                            if (privilegesList.contains("DELETE COMPLAINT")) {
                                deleteComplaint = true;
                            }
                            boolean reFinishComplaint = false;
                            if (privilegesList.contains("RE_FINISH_COMPLAINT")) {
                                reFinishComplaint = true;
                            }
                    %> 
                    <TD style="width:40%; border:none;">
                        <TABLE width="100%">
                            <TR style="" dir='<fmt:message key="direction" />'>
                                <TD id="btnscolumn" style="display : <%=canNotificate ? "" : "none"%> ; border: none; width:30%;padding:0px 15px 5px 0px">
                                    <input type="button" onclick="notificationComp(this);" class="button_notification button2 <fmt:message key="css-notify" />" value='<fmt:message key="notify" />'  />
                                </TD>
                                <TD id="btnscolumn" style="border: none; width:30%; display : <%=canClose ? "" : "none"%>;padding:0px 15px 5px 0px">
                                    <input type="button" onclick="popupCloseO(this);" class="  button2 <fmt:message key="css-close" />" value='<fmt:message key="close" />'/>
                                </TD>
                                <TD id="btnscolumn" style="border: none; width:30%; display : <%=isClosed ? "" : "none"%>;padding:0px 15px 5px 0px">
                                    <input type="button" onclick="notAllowed('تم الإغلاق مسبقا')" class="  button2 <fmt:message key="css-close" />" value='<fmt:message key="close" />'/>
                                </TD>

                                <TD id="btnscolumn" style="border: none; width:30%; display : <%=notFinished ? "" : "none"%>;padding:0px 15px 5px 0px">
                                    <input type="button"c class="  button2 <fmt:message key="css-close" />" value='<fmt:message key="close" />'/>
                                </TD>


                                <TD id="btnscolumn" style="display: inline-table;  border: none; width:30%; display : <%=canComment ? "" : "none"%>">
                                    <div class="dropdown" >
                                        <input type="button" class="button_commx button2 <fmt:message key="css-comment" />" value='<fmt:message key="comment" />' />
                                        <div class="submenux" style="z-index: 100;">
                                            <ul class="root">
                                                <li ><a href="#" style="text-align: right"  onclick="JavaScript: getComment();">إضافة تعليق</a></li>
                                                <li ><a href="#" style="text-align: right"  onclick="JavaScript:addCommentChannel()">إضافة تعليق قناة</a></li>
                                                <li ><a href="#" style="text-align: right" onclick="showComments(this)">مشاهدة التعليقات</a></li>
                                            </ul>
                                        </div>
                                    </div>
                                </TD>


                            </TR>

                            <TR style=" " dir='<fmt:message key="direction" />'>
                                <TD id="btnscolumn" style="border: none;  display : <%=canDistribute ? "" : "none"%>;padding:0px 15px 5px 0px">
                                    <input type="button" class="button_redirec button2 <fmt:message key="css-distribution" />" value='<fmt:message key="distribution" />' onclick="return getDataInPopup('ComplaintEmployeeServlet?op=usersUnderManager&formName=CLIENT_COMPLAINT_FORM&selectionType=multi&complaintId=' + $('#complaintId').val() + '&managerID=<%=userWbo.getAttribute("userId")%>')"/>
                                </TD>

                                <TD id="btnscolumn" style="border: none;  display : <%=isDistributed ? "" : "none"%>;padding:0px 15px 5px 0px">
                                    <input type="button" class="button_redirec button2 <fmt:message key="css-distribution" />" value='<fmt:message key="distribution" />' onclick="notAllowed('تم التوزيع مسبقا')"/>
                                </TD>

                                <TD id="btnscolumn" style="border: none; display : <%=canAssign ? "" : "none"%>;border: none;padding:0px 15px 5px 0px">
                                    <input type="button" onclick="redistributionComp(this)" class="managerBt button2 <fmt:message key="css-redistribution" />" value='<fmt:message key="re-distribution" />'/>
                                </TD>

                                <TD id="btnscolumn" style="display : <%=withEmployee ? "" : "none"%> ;border: none;padding:0px 15px 5px 0px ">
                                    <input type="button" onclick="notAllowed('الطلب مع الموظف المختص')" class="managerBt button2 <fmt:message key="css-redistribution" />" value='<fmt:message key="re-distribution" />'/>
                                </TD>

                                <TD id="btnscolumn" style="display : <%=orderInAction ? "" : "none"%> ; border: none; padding:0px 15px 5px 0px">
                                    <input type="button" onclick="notAllowed('تم التعامل مع الطلب من قبل')" class="managerBt button2 <fmt:message key="css-redistribution" />" value='<fmt:message key="re-distribution" />'/>
                                </TD>

                                <TD id="btnscolumn" style="display : <%=notDistributed ? "" : "none"%> ;border: none; padding:0px 15px 5px 0px">
                                    <input type="button" onclick="notAllowed('لا يمكن اجراء هذا الطلب الأن')" class="managerBt button2 <fmt:message key="css-redistribution" />" value='<fmt:message key="re-distribution" />'/>
                                </TD>


                                <TD id="btnscolumn" style="border: none;  display : <%=canCancel && !request.getAttribute("statusCode").equals("5") ? "" : "none"%>;padding:0px 15px 5px 0px">
                                    <input type="button" onclick="rejectedComp(this)" class="rejectedBtn button2 <fmt:message key="css-cancle" />" value='<fmt:message key="cancle" />' />
                                </TD>

                                <TD id="btnscolumn" style="border: none;  display : <%=request.getAttribute("statusCode").equals("5") ? "" : "none"%>;padding:0px 15px 5px 0px">
                                    <input type="button" onclick="notAllowed(' تم الألغاء مسبقا')" class="rejectedBtn button2 <fmt:message key="css-cancle" />" value='<fmt:message key="cancle" />' />
                                </TD>

                            </TR>
                            <TR>
                                <TD id="btnscolumn" style="display: inline-table; border: none; display : <%=canAttach ? "" : "none"%>;padding:0px 15px 5px 0px ">
                                    <div class="dropdown"  >
                                        <input type="button" onclick="return false;" class="attach_button button2 <fmt:message key="css-attach" />" value='<fmt:message key="attachments" />' />
                                        <div class="submenuxx">
                                            <ul class="root">
                                                <li ><a href="#" style="text-align: right"  onclick="JavaScript: popupAttach(this);">إضافة ملف</a></li>
                                                <li ><a href="#" style="text-align: right" onclick="JavaScript: showAttachedFiles(this);">مشاهدة الملفات</a></li>
                                            </ul>
                                        </div>
                                    </div>
                                </TD>
                                <TD id="btnscolumn" style="display : <%=viewOrderPhases ? "" : "none"%> ;border: none;padding:0px 15px 5px 0px  ">
                                    <input type="button" onclick="comp_Report(this)" class="order_phases_btn button2 <fmt:message key="css-requsetstages" />" value='<fmt:message key="requeststages" />' />
                                </TD>

                                <TD id="btnscolumn" style="display : <%=printComplaint ? "" : "none"%> ;border: none;padding:0px 15px 5px 0px  ">
                                    <input type="button" onclick="getClientComplaintWithComments('<%=clientCompId%>'); return false;" class="print_complaint_btn button2 <fmt:message key="css-print" />" value='<fmt:message key="print" />' />
                                </TD>

                            </TR>
                            <TR> 
                                <TD id="btnscolumn" style="border: none; display : <%=deleteComplaint ? "" : "none"%>;padding:0px 15px 5px 0px ">
                                    <input type="button" onclick="deleteComplaint('<%=issueId%>', '<%=clientCompId%>'); return false;" class="button2 <fmt:message key="css-delete" />" value='<fmt:message key="delete" />' />
                                </TD>
                                <TD id="btnscolumn" style="display : <%=reFinishComplaint ? "" : "none"%> ;border: none;padding:0px 15px 5px 0px  ">
                                    <input type="button" onclick="popupFinishO(this);
                                                           return false;" class="button2  "style="width:150px" value='Re-Finish' />
                                </TD>
                            </TR>
                        </TABLE>
                    </TD>
                    <%}%>
                    </TR>
                    </TABLE>


                </fieldset>

                <%   String page5 = (String) request.getAttribute("includePage");%>
                <jsp:include page="<%=page5%>" flush="true"/>
                <%}%>

            </FIELDSET>


            <div id="PopUps">

                <div id="complaintReport" style="display: none;width: 80%; height: 80%;"></div>
                <div id="addChannelComment" style="display: none;width: 80%; height: auto"></div>
                <div id="redirectComp"  style="width: 30%;display: none;">
                    <div style="clear: both;margin-left: 89%;margin-top: 0px;margin-bottom: -35px;z-index: -10;">
                        <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;" onclick="closePopup(this)"/>
                    </div>
                    <div class="login" style="width: 90%;float: left;margin-bottom: 3px;">
                        <table class="" style="width:100%;text-align: right;border: none;margin-bottom: 3px;"  class="table" cellspacing="10px;">

                            <tr>
                                <td style="width: 40%;"> <label style="width: 100px;">إسم الموظف</label></TD>
                                <td  style="text-align: right;">
                                    <SELECT id="department" name="department" STYLE="width:80%;font-size: small;text-align: right;float: right">
                                        <sw:WBOOptionList wboList='<%=employeesx%>' displayAttribute = "userName" valueAttribute="userId" />

                                    </SELECT>
                                </td>
                            </TR>
                            <tr>
                                <td colspan="2" > <input type="button"  onclick="JavaScript:redirectComplaintToEmployee(this);" value="تحويل" style="margin-top: 15px;font-family: sans-serif"></TD>
                            </tr>
                            <tr>
                                <td colspan="2" style="text-align: center;">
                                    <b id="redirectMsg" style="text-align: center;color: white;font-size: 15px;"></b>
                                </td>
                            </tr>
                        </TABLE>
                    </div>
                </div>

                <div id="notificationComp"  style="width:40%;display: none;">
                    <div style="clear: both;margin-left: 89%;margin-top: 0px;margin-bottom: -35px;z-index: -10;">
                        <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;" onclick="closePopup(this)"/>
                    </div>
                    <div class="login" style="width: 90%;float: left;margin-bottom: 3px;">
                        <!--                
                                      notificationComp
                                      allEmployees
                        -->
                        <table id="employeesTable"  align="center" WIDTH="100%" CELLPADDING="0" cellspacing="0" style="">
                            <thead>
                                <TR>
                                    <TH><SPAN style=""></SPAN></TH>
                                    <TH><SPAN ><img src="images/icons/Numbers.png" width="20" height="20" /><b>Employee Id </b></SPAN></TH>
                                    <TH><SPAN><img src="images/icons/client.png" width="20" height="20" /><b>Employee Name </b></SPAN></TH>

                                </TR>
                            </thead>
                            <tbody  >  
                                <%
                                    for (WebBusinessObject emplwbo : allEmployees) {
                                %>
                                <TR id="empRow">

                                    <TD style="background-color: transparent;">
                                        <SPAN style="display: inline-block;height: 20px;background: transparent;"><INPUT type="checkbox" id="empId" class="case" value="<%=emplwbo.getAttribute("userId")%>" name="selectedEmp"/>
                                            <input type="hidden" id="employeeId" value="<%=emplwbo.getAttribute("userId")%>" />
                                        </SPAN>
                                    </TD>

                                    <TD style="background-color: transparent;">
                                        <%=emplwbo.getAttribute("userName")%>
                                    </TD>
                                    <TD style="background-color: transparent;">
                                        <%=emplwbo.getAttribute("fullName")%>
                                    </TD>
                                </TR>
                                <% }%>
                            </tbody>
                        </table>
                        <div style="width: 100%;text-align: center;margin-left: auto;margin-right: auto;">

                            <input type="text" id="notificationComment" style="width: 100%" /> </br>
                            <input type="button" onclick="JavaScript:notificationComplaintToEmployee(this);" value="إعــــــــلام" style="margin-top: 15px;font-family: sans-serif">
                            <br/><span type="text" id="notificationMsg" style="width: 100%; font-size: large; color: black; font-weight: bold;" /> 
                            <input type="hidden" id="comment" name="comment" value="إعلام من <%=securityUser.getFullName()%>" />
                            <input type="hidden" id="subject" name="subject" value="إعلام من <%=securityUser.getFullName()%>" />
                        </div>
                    </div>
                </div>


                <div id="closeNote"  style="width: 40%;display: none; position: fixed">

                    <div style="clear: both;margin-left: 93%;margin-top: 0px;margin-bottom: -38px;z-index: -10000000;">
                        <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);background-color: transparent;
                             -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                             box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                             -webkit-border-radius: 100px;
                             -moz-border-radius: 100px;
                             border-radius: 100px;" onclick="closePopup(this)"/>
                    </div>

                    <!--<h1>رسالة قصيرة</h1>-->
                    <div class="login" style="width:90%;margin-left: auto;margin-right: auto;">
                        <table  border="0px" class="table" style="width:100%;text-align: right;margin-bottom: 10px !important;margin-left: auto;margin-right: auto;" >

                            <tr>
                                <td style="width: 40%;"> <label style="width: 100px;">اﻷجراء المحدد</label></td>
                                <td style="width: 60%;">
                                    <select id="actionTaken" name="actionTaken" STYLE="width:175px;font-size: small;text-align: right;float: right">
                                        <sw:WBOOptionList wboList='<%=closureActionsList%>' displayAttribute = "title" valueAttribute="id" />
                                        <option value="100" selected>لا شيئ</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 40%;"> <label style="width: 100px;">ملاحظات الإغلاق</label></TD>
                                <td style="width: 60%;"><TEXTAREA cols="40" rows="5" name="notes" id="notes"></TEXTAREA></TD>
                    </TR>
                    <tr>
                        <td style="width: 40%;"> <label style="width: 100px;">التاريخ</label></TD>
                        <td style="width: 60%;">  <input name="closedEndDate" id="closedEndDate" type="text" size="40" maxlength="50" style="width:50%;float: right;font-size: 12px;" value="<%=nowTime%>"/></TEXTAREA></TD>
                    </TR>
                    <tr>
                        <td colspan="2" > <input type="button"  onclick="JavaScript:closeComplaint(this);" class="button_close">

                        </TD>
                    </tr>
                    <tr>
                                <%
                                    String msg = "\u062A\u0645 \u0627\u0644\u0623\u063A\u0644\u0627\u0642 \u0628\u0646\u062C\u0627\u062D";
                                    if (MetaDataMgr.getInstance().getSendMail() != null && MetaDataMgr.getInstance().getSendMail().equalsIgnoreCase("1")) {
                                        msg += " \u0648 \u0623\u0631\u0633\u0627\u0644 \u0625\u0645\u064A\u0644 \u0628\u0630\u0644\u0643";
                                %>
                        
                                <% }%>
                        <td colspan="2" >
                            <div style="margin: 0 auto;display: none; width: 90%;text-align: center;color: white" id="closedMsg"><%=msg%></div>
                        </td>
                    </tr>
                </TABLE>
            </div>
        </div>                       
       
        <div id="redistributionComp"  style="width:40%;display: none;">
            <div style="clear: both;margin-left: 89%;margin-top: 0px;margin-bottom: -35px;z-index: -10;">
                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;" onclick="closePopup(this)"/>
            </div>
            <div class="login" style="width: 90%;float: left;margin-bottom: 3px;">
                <table id="employeesTable2"  align="center" WIDTH="100%" CELLPADDING="0" cellspacing="0" style="">
                    <thead>
                        <TR>
                            <TH><SPAN style=""></SPAN></TH>
                            <TH><SPAN><img src="images/icons/client.png" width="20" height="20" /><b>اسم الموظف</b></SPAN></TH>
                        </TR>
                    </thead>
                    <tbody  >  
                                <%
                                    if (userUnderManager != null) {
                                        for (WebBusinessObject userUnderManagerwbo : userUnderManager) {
                                %>
                        <TR id="empRow">
                            <TD style="background-color: transparent;">
                                <SPAN style="display: inline-block;height: 20px;background: transparent;">
                                    <INPUT type="radio" id="empId" class="case" value="<%=userUnderManagerwbo.getAttribute("userId")%>" name="selectedEmp"/>
                                    <input type="hidden" id="employeeId" value="<%=userUnderManagerwbo.getAttribute("userId")%>" />
                                </SPAN>
                            </TD>
                            <TD style="background-color: transparent;">
                                        <%=userUnderManagerwbo.getAttribute("fullName")%>
                            </TD>
                        </TR>
                                <%
                                        }
                                    }
                                %>
                    </tbody>
                </table>
                <div style="width: 100%;text-align: center;margin-left: auto;margin-right: auto;">
                    <input type="text" id="redistributionComment" style="width: 100%; display: none" /> </br>
                    <input type="button" id="redistBtn" onclick="JavaScript:redistributionComplaintToEmployee(this);" class="managerBt" value="" style="margin-top: 15px;font-family: sans-serif">
                    <input type="hidden" id="comment" name="comment" value="اعادة توجيه من <%=securityUser.getFullName()%>" />
                    <input type="hidden" id="subject" name="subject" value="اعادة توجيه من <%=securityUser.getFullName()%>" />
                    <b id="redistributionComplaintMSG"></b>
                </div>
            </div>
        </div>
        
        <div id="rejectedNote"  style="width: 40%;display: none; position: fixed">

            <div style="clear: both;margin-left: 93%;margin-top: 0px;margin-bottom: -38px;z-index: -10000000;">
                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);background-color: transparent;
                             -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                             box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                             -webkit-border-radius: 100px;
                             -moz-border-radius: 100px;
                             border-radius: 100px;" onclick="closePopup(this)"/>
            </div>

            <!--<h1>رسالة قصيرة</h1>-->
            <div class="login" style="width:90%;margin-left: auto;margin-right: auto;">
                <table  border="0px" class="table" style="width:100%;text-align: right;margin-bottom: 10px !important;margin-left: auto;margin-right: auto;" >

                    <tr>
                        <td style="width: 40%;"> <label style="width: 100px;">ملاحظات الإلغاء</label></TD>
                        <td style="width: 60%;"><TEXTAREA cols="40" rows="5" name="notes" id="notes"></TEXTAREA></TD>
                    </TR>
                    <tr>
                        <td style="width: 40%;"> <label style="width: 100px;">التاريخ</label></TD>
                        <td style="width: 60%;">  <input name="rejectedEndDate" id="rejectedEndDate" type="text" size="40" maxlength="50" style="width:50%;float: right;font-size: 12px;" value="<%=nowTime%>"/></TEXTAREA></TD>
                    </TR>
                    <tr>
                        <td colspan="2" > <input type="button"  onclick="JavaScript:rejectedComplaint(this);" class="rejectedBtn">

                        </TD>
                    </tr>
                    <tr>
                    <tr>
                        <td colspan="2" >
                            <div style="margin: 0 auto;display: none; width: 90%;text-align: center;color: white" id="rejectedMsg">  </>
                        </td>
                    </tr>
                    </tr>
                </TABLE>
            </div>
        </div>
        <div id="finishNote"  style="width: 40%;display: none;position: fixed">

            <div style="clear: both;margin-left: 93%;margin-top: 0px;margin-bottom: -38px;z-index: -10000000;">
                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);background-color: transparent;
                             -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                             box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                             -webkit-border-radius: 100px;
                             -moz-border-radius: 100px;
                             border-radius: 100px;" onclick="closePopup(this)"/>
            </div>

            <!--<h1>رسالة قصيرة</h1>-->
            <div class="login" style="width:90%;margin-left: auto;margin-right: auto;">
                <table  border="0px" class="table" style="width:100%;text-align: right;margin-bottom: 10px !important;margin-left: auto;margin-right: auto;" >                



                    <tr>
                        <td style="width: 40%;"> <label style="width: 100px;">اﻷجراء المحدد</label></td>
                        <td style="width: 60%;">
                            <select id="actionTaken" name="actionTaken" STYLE="width:175px;font-size: small;text-align: right;float: right">
                                        <sw:WBOOptionList wboList='<%=actionsList%>' displayAttribute = "projectName" valueAttribute="projectID" />
                                <option value="100" selected>Other</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 40%;"> <label style="width: 100px;">ملاحظات الإنهاء</label></TD>
                        <td style="width: 60%;"><TEXTAREA cols="40" rows="5" name="notes" id="notes"></TEXTAREA></TD>
                    </TR>
                    <tr>
                        <td style="width: 40%;"> <label style="width: 100px;">التاريخ</label></TD>
                        <td style="width: 60%;">  <input name="finishEndDate" id="finishEndDate" type="text" size="40" maxlength="50" style="width:50%;float: right;font-size: 12px;" value="<%=nowTime%>"/></TEXTAREA></TD>
                    </TR>
                    <tr>
                        <td colspan="2" > <input type="button"  onclick="JavaScript: finishComplaint(this);" class="button_finis"></TD>
                    </tr>
                    <tr>
                        <td colspan="2" >
                            <div style="margin: 0 auto;display: none; width: 90%;text-align: center;color: white" id="finishMsg">تم الإنهاء بنجاح</>
                        </td>
                    </tr>


                </TABLE>
            </div>

        </div>

        <div id="show_attached_files"   style="width: 70% !important;display: none;position: fixed ;"></div>
 <div id="showDiv" style="width: 80% !important;margin-left: auto;margin-right: auto;display: none">
                    <div style="clear: both;margin-left: 89%;margin-top: 0px;margin-bottom: -15px;z-index: -10000000;">&nbsp;
                        <img id="closeImg" src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;" onclick="closeDiv(this)"/>
                    </div>
                    <DIV id="tblDataDiv" style="width: 90%;margin-left: auto;margin-right: auto;">

                        <TABLE id="tblData" class="blueBorder" ALIGN="center" dir=<fmt:message key="direction"/> width="100%" >
                            <TR>
                                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="5%"><b>#</b></TD>
                                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="10%" ><b><fmt:message key="code" /></b></TD>
                                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="20%" id="empNameShown" value=""><b><fmt:message key="emplname" /></b></TD>
                                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="10%"><b><<fmt:message key="notes" /></b></TD>
                                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="5%"><b><fmt:message key="save"/></b></TD>
                                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="5%"><b><fmt:message key="delete" /></b></TD>
                            </TR>
                        </TABLE>
                    </DIV>
                </div>       
                       
         <div id="add_comm"  style="width: 30% ;margin-right: auto ;margin-left: auto;display: none;position: fixed"><!--class="popup_appointment" -->

            <div style="clear: both;margin-left: 88%;margin-top: 0px;margin-bottom: -38px;z-index: -10000000;">
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
                        <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 30%;">حالة التعليق</td>
                        <td style="width: 70%;" >
                            <select style="float: right;width: 30%; font-size: 14px;" id="commentType2">
                                <option value="0">عام</option>
                                <option value="1">خاص</option>
                            </select>
                            <input type="hidden" id="businessObjectType2" value="2"/>
                        </td>

                    </tr> 
                            <%
                            } else {
                            %>
                    <input type="hidden" id="commentType2" name="commentType2" value="0"/>
                    <input type="hidden" id="businessObjectType2" value="2"/>
                            <%
                                }
                            %>
                    <tr>
                        <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 30%;">التعليق</td>
                        <td style="width: 70%;" >

                            <textarea  placeholder="" style="width: 100%;height: 80px;" id="comment2" >
                            </textarea>
                        </td>

                    </tr> 
                </table>
                <div style="text-align: center;margin-left: auto;margin-right: auto;" > <input type="button" value="حفظ"   onclick="saveComplaintComment(this)" id="saveComm"class="login-submit"/>
                </div>                           
            </div>

                    <div id="show_comm"   style="width: 80% !important;display: none;position: fixed ;"></div>
                    <div id="attach_content"  style="width: 30%;display: none;position: fixed;margin-left: auto;margin-right: auto">

            <div style="clear: both;margin-left: 90%;margin-top: 0px;margin-bottom: -40px;">
                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                                 -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                                 box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                                 -webkit-border-radius: 20px;
                                 -moz-border-radius: 20px;
                                 border-radius: 20px;" onclick="closePopup(this)"/>
            </div>

            <!--<h1>رسالة قصيرة</h1>-->
            <div class="login" style="width: 90%;text-align: center">
                <form id="complaintFileForm" action="<%=context%>/DocumentServlet?op=saveMultiFiles" method="post" enctype="multipart/form-data">
                    <table class="table " style="width:100%;">
                        <tr>
                            <td style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 30%;"><lable>إرفاق ملف</lable>
                        <input type="button" id="addFile2" onclick="addFiles2(this)" value="+" />

                        <input id="counter2" value="" type="hidden" name="counter"/>
                        <input name="compId" value="<%=clientCompId%>" type="hidden" />
                        </td>
                        <td style="text-align:right;width: 70%;" id="listFile2"> 
                        </td>

                        </tr>

                    </table>
                    <div style="width: 30%;text-align: center;margin-left: auto;margin-right: auto;" id="status"></div>

                    <div id="info" style="margin-left: auto;margin-right: auto;text-align: center"></div>
                    <button type="button" value=""  class="login-submit" style="margin-left: auto;margin-right: auto;text-align: center" onclick="submitFile()" >
                        تحميل
                    </button>

                </form>
                <div id="progressx" style="display: none;">
                    <img src="images/Loading2.gif" width="32px" height="32px;" style="background-repeat: no-repeat;margin-left: auto;margin-right: auto"/>
                </div>
            </div>

        </div>  
        </div>  
  </div>
    </FORM>
                    <STYLE>
            .silver_footer{
                height:30px;
                width:20%;
            }
                    </style>
</body>
       
</html>
