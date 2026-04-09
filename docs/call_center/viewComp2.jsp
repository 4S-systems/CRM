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

<%
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
    List<WebBusinessObject> allEmployees = (ArrayList) request.getAttribute("allEmployees");
    ArrayList<WebBusinessObject> dependOnIssuesList = (ArrayList<WebBusinessObject>) request.getAttribute("dependOnIssuesList");
    List<WebBusinessObject> userUnderManager = (ArrayList) request.getAttribute("userUnderManager");
    IssueMgr issueMgr = IssueMgr.getInstance();
    WebBusinessObject issueWbo = (WebBusinessObject) issueMgr.getOnSingleKey(issueId);
    String sourceName = "";
    String issueType = "";
    String age = "";
    if (issueWbo != null) {

        /**
         * to get the number of Tickets inside the Issues Haytham
         */
        /**
         * to get the number of Tickets inside the Issues Haytham
         */
        ClientComplaintsMgr comcomplaintsMgr = ClientComplaintsMgr.getInstance();
        int numOfOrders = comcomplaintsMgr.getNumberOfAppropriations(issueId);
        issueWbo.setAttribute("numOfOrders", numOfOrders);
        
        WebBusinessObject user = UserMgr.getInstance().getOnSingleKey((String) issueWbo.getAttribute("userId"));
        sourceName = (String) user.getAttribute("userName");
        if (issueWbo.getAttribute("issueTitle").toString().equalsIgnoreCase("Extracting")) {
            issueType = "مستخلص رقم: " + (String) issueWbo.getAttribute("projectName");
        }
        String creationTime = issueMgr.getColumnDateTime(issueId, "creation_time");
        age = DateAndTimeControl.getDelayTimeByDay(creationTime, "Ar");
    }

    IssueByComplaint2Mgr issueByComplaint2Mgr = IssueByComplaint2Mgr.getInstance();
    Vector<WebBusinessObject> clientCompVector = new Vector();
    String clientCompId = (String) request.getParameter("compId");
    clientCompVector = IssueByComplaintUniqueMgr.getInstance().getOnArbitraryKey(request.getParameter("compId").toString(), "key4");
    String complaintId = (String) request.getAttribute("complaintId");
    ClientComplaintsMgr clientComplaintsMgr = ClientComplaintsMgr.getInstance();
    WebBusinessObject wb = new WebBusinessObject();
    wb = clientComplaintsMgr.getCurrentOwner(clientCompId);

    Vector products = (Vector) request.getAttribute("products");

    String call_status = (String) issueWbo.getAttribute("callType");
    String entryDate = (String) request.getAttribute("entryDate");
    entryDate = entryDate.substring(0, 10);
    entryDate = entryDate.replace("-", "/");
//    Vector<WebBusinessObject> clientCompVector = new Vector();
//    IssueByComplaintMgr issueByComplaintMgr = IssueByComplaintMgr.getInstance();
//    WebBusinessObject userWbo1 = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
//    clientCompVector = issueByComplaintMgr.getOnArbitraryKey(userWbo1.getAttribute("clientComId").toString(), "key5");

    if (call_status == null) {
        call_status = "";

    }

    ProjectMgr projectMgr = ProjectMgr.getInstance();
    ArrayList complaintList = projectMgr.getSubProjectsByCode("cmp");
    
    ArrayList<WebBusinessObject> actionsList = (ArrayList<WebBusinessObject>) request.getAttribute("actionsList");
    ArrayList<WebBusinessObject> closureActionsList = (ArrayList<WebBusinessObject>) request.getAttribute("closureActionsList");

    String context = metaMgr.getContext();
    ArrayList employeesx = (ArrayList) request.getAttribute("employeesx");

//Get request data
    Vector DepComp = (Vector) request.getAttribute("DepComp");

    String filterName = (String) request.getAttribute("filterName");
    String filterValue = (String) request.getAttribute("filterValue");

    WebBusinessObject client = (WebBusinessObject) request.getAttribute("client");

    Boolean isCstatushecked = false;

    //Privileges
    ArrayList<WebBusinessObject> prvType = new ArrayList();
    prvType = securityUser.getComplaintMenuBtn();
    ArrayList<String> privilegesList = new ArrayList<String>();
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

    String stat = (String) request.getSession().getAttribute("currentMode");
    String align = null;
    String dir = null;
    String style = null;
    String cellAlign = null;
    String message = null;
    String printTask, lang, langCode, calenderTip, cancel, save, title, JOData, JONo, forEqp, task, complaint, entryTime, notes, add, delete, noComplaints, M, M2;
    String close, finish, forward, comment, bookmark;
    String complaintNo, customerName, complaintDate;
    int iTotal = 0;
    String viewD, scheduleCase, executionCase, onHoldCase, fontSize, issueNo, issueTit, equip, issueStatus, clientOperation;
    String sat, sun, mon, tue, wed, thu, fri, view;
    String codeStr, projectStr, distanceStr, deleteStr, responsibleStr, viewDocuments, photoGallery, viewRequest, viewFinishCloseComments, viewAllComments;
    if (stat.equals("En")) {
        align = "center";
        dir = "LTR";
        style = "text-align:left";
        lang = "   &#1593;&#1585;&#1576;&#1610;    ";
        langCode = "Ar";
        cellAlign = "left";

        printTask = "Print Task ";
        cancel = "Back";
        save = "Save";
        title = "Relate complaints to tasks";
        JOData = "Job Order Data";
        JONo = "Job Order Number";
        forEqp = "Equipment Name";
        task = "Task Name";
        complaintNo = "Order No.";
        customerName = "Customer name";
        complaintDate = "Calling date";
        complaint = "Complaint";
        sat = "Sat";
        sun = "Sun";
        mon = "Mon";
        tue = "Tue";
        wed = "Wed";
        thu = "Thu";
        fri = "Fri";
        view = "View";
        entryTime = "Entry date";
        notes = "Recommendations";
        add = "Select";
        delete = "Delete Selection";
        noComplaints = "No complaints related to this job order";
        M = "Data Had Been Saved Successfully";
        M2 = "Saving Failed ";
        calenderTip = "click inside text box to opn calender window";
        close = "Close";
        finish = "Finish";
        forward = "Forward";
        comment = "Comment";
        bookmark = "Bookmark";
        codeStr = "Code";
        projectStr = "Employee name";
        distanceStr = "Notes";
        deleteStr = "Delete";
        responsibleStr = "Responsibility";
        clientOperation = "client operation";
        viewDocuments = "View Documents";
        photoGallery = "Photo Gallery";
        viewRequest = "View Request";
        viewFinishCloseComments = "View Finish-Close Comments";
        viewAllComments = "View All Comments";
    } else {
        align = "center";
        dir = "RTL";
        style = "text-align:Right";
        lang = "English";
        langCode = "En";
        cellAlign = "right";

        printTask = "طباعة المهمة";
        cancel = "&#1593;&#1600;&#1600;&#1600;&#1600;&#1608;&#1583;&#1577;";
        save = "&#1578;&#1587;&#1580;&#1610;&#1604;";
        title = "&#1593;&#1585;&#1590; &#1608;&#1578;&#1581;&#1604;&#1610;&#1604; &#1575;&#1604;&#1588;&#1603;&#1575;&#1608;&#1609;";
        JOData = "&#1576;&#1610;&#1575;&#1606;&#1575;&#1578; &#1571;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
        JONo = "&#1585;&#1602;&#1605; &#1571;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
        forEqp = "&#1575;&#1587;&#1605; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577;";
        task = "&#1576;&#1606;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
        complaintNo = "&#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1603;&#1575;&#1604;&#1605;&#1577;";
        customerName = "&#1575;&#1587;&#1605; &#1575;&#1604;&#1593;&#1605;&#1610;&#1604;";
        complaintDate = "&#1608;&#1602;&#1578; &#1575;&#1604;&#1575;&#1578;&#1589;&#1575;&#1604;";
        complaint = "&#1575;&#1604;&#1588;&#1603;&#1608;&#1609; / &#1575;&#1604;&#1591;&#1604;&#1576;";
        sat = "&#1575;&#1604;&#1587;&#1576;&#1578;";
        sun = "&#1575;&#1604;&#1575;&#1581;&#1583;";
        mon = "&#1575;&#1604;&#1575;&#1579;&#1606;&#1610;&#1606;";
        tue = "&#1575;&#1604;&#1579;&#1604;&#1575;&#1579;&#1575;&#1569;";
        wed = "&#1575;&#1604;&#1575;&#1585;&#1576;&#1593;&#1575;&#1569;";
        thu = "&#1575;&#1604;&#1582;&#1605;&#1610;&#1587;";
        fri = "&#1575;&#1604;&#1580;&#1605;&#1593;&#1577;";
        view = "&#1605;&#1588;&#1575;&#1607;&#1583;&#1577;";
        entryTime = "&#1578;&#1575;&#1585;&#1610;&#1582; &#1583;&#1582;&#1608;&#1604; &#1575;&#1604;&#1588;&#1603;&#1608;&#1609;";
        notes = "&#1578;&#1608;&#1589;&#1610;&#1575;&#1578; &#1575;&#1604;&#1578;&#1606;&#1601;&#1610;&#1584;";
        add = "&#1575;&#1582;&#1578;&#1585;";
        delete = "&#1581;&#1584;&#1601; &#1575;&#1604;&#1575;&#1582;&#1578;&#1610;&#1575;&#1585;";
        noComplaints = "&#1604;&#1575;&#1610;&#1608;&#1580;&#1583; &#1588;&#1603;&#1575;&#1608;&#1609; &#1605;&#1585;&#1578;&#1576;&#1591;&#1577; &#1576;&#1571;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
        M = "&#1578;&#1605; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604; &#1576;&#1606;&#1580;&#1575;&#1581;";
        M2 = "&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
        calenderTip = "&#1575;&#1590;&#1594;&#1591; &#1583;&#1575;&#1582;&#1604; &#1575;&#1604;&#1605;&#1587;&#1578;&#1591;&#1610;&#1604; &#1604;&#1603;&#1609; &#1610;&#1592;&#1607;&#1585; &#1604;&#1603; &#1606;&#1575;&#1601;&#1584;&#1607; &#1604;&#1571;&#1582;&#1578;&#1610;&#1575;&#1585; &#1575;&#1604;&#1578;&#1575;&#1585;&#1610;&#1582;";
        close = "&#1573;&#1594;&#1604;&#1575;&#1602;";
        finish = "&#1573;&#1606;&#1607;&#1575;&#1569;";
        forward = "&#1573;&#1593;&#1575;&#1583;&#1577; &#1578;&#1608;&#1580;&#1610;&#1607;";
        comment = "&#1578;&#1593;&#1604;&#1610;&#1602;";
        bookmark = "&#1593;&#1604;&#1575;&#1605;&#1577;";
        codeStr = "&#1575;&#1604;&#1603;&#1608;&#1583;";
        projectStr = "&#1575;&#1587;&#1605; &#1575;&#1604;&#1605;&#1608;&#1592;&#1601;";
        distanceStr = "&#1605;&#1604;&#1575;&#1581;&#1592;&#1575;&#1578;";
        deleteStr = "&#1581;&#1584;&#1601;";
        responsibleStr = "&#1575;&#1604;&#1605;&#1587;&#1574;&#1608;&#1604;";
        clientOperation = "&#1593;&#1605;&#1604;&#1610;&#1575;&#1578; &#1575;&#1604;&#1593;&#1605;&#1610;&#1604;";
        viewDocuments = "مشاهدة المرفقات";
        photoGallery = "عرض الصور";
        viewRequest = "مشاهدة طلب تسليم";
        viewFinishCloseComments = "مشاهدة تعليقات اﻷنهاء-اﻷغلاق";
        viewAllComments = "مشاهدة كل التعليقات";
    }
    String vertLineHeight;
    //String prevType ="1";
    String clientId = (String) request.getAttribute("clientId");
    WebBusinessObject userWbo = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
    UserStoresMgr userStoresMgr = UserStoresMgr.getInstance();
    GroupPrevMgr groupPrevMgr = GroupPrevMgr.getInstance();
    Vector groupPrev = new Vector();
    String dd = (String) userWbo.getAttribute("groupID");
    groupPrev = groupPrevMgr.getOnArbitraryKey(userWbo.getAttribute("groupID").toString(), "key1");
    Vector userPrev = new Vector();
    userPrev = userStoresMgr.getOnArbitraryKey(userWbo.getAttribute("userId").toString(), "key1");
    UserPrev userPrevObj = new UserPrev();
    WebBusinessObject userPrevWbo = null;
    userPrevObj.setUserId(userWbo.getAttribute("userId").toString());

    String finReqSubject = "مطالبة مالية";
    String finReqComment = "مطالبة مالية";
    String qualityReqSubject = "طلب تسليم جودة";
    String qualityReqComment = "طلب تسليم جودة";

%>


<script src='ChangeLang.js' type='text/javascript'></script>
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
    <!--<script type="text/javascript" src="js/jquery.chained.remote.min.js"></script>  -->
    <script type="text/javascript" src="js/wz_tooltip.js"></script>
    <script type="text/javascript" src="js/tip_balloon.js"></script>
    <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>


    <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/default/easyui.css">
    <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/icon.css">
    <link rel="stylesheet" type="text/css" href="jquery-easyui/demo/demo.css">
    <script type="text/javascript" src="jquery-easyui/easyloader.js"></script>
    <link rel="stylesheet" href="jquery-ui/themes/base/jquery-ui-timepicker-addon.css"/>
    <style>
        .show{
            display: block;
        }
        .hide{
            display: none;
        }
    </style>
    <script type="text/javascript">
        var d = new Date();
        var month = d.getMonth();
        var day = d.getDate();
        var year = d.getFullYear();
        var minDateS = '<%=entryDate%>';
        $(function() {
            $("#closedEndDate,#finishEndDate,#rejectedEndDate").datetimepicker({
                changeMonth: true,
                changeYear: true,
                minDate: new Date(minDateS),
                maxDate: '<%=currentYear%>' + '/' + '<%=currentMonth + 1%>' + '/' + '<%=currentDay%>',
                dateFormat: "yy/mm/dd",
                //                showSecond: true,

                timeFormat: "hh:mm"
            });
        });
        //         $("#finishEndDate,closedEndDate").datepicker('option',{minDate:minDateS
        //               , maxDate:0 });

        $(function() {

            var height = $("#cc").height();

            $("#line").css("height", height);

        })


        function getClientComplaintWithComments(complaintId)
        {
            var url = "<%=context%>/ReportsServlet?op=clientComplaintWithComments&complaintId=" + complaintId + "&objectType=" + $("#businessObjectType2").val();
            openWindow(url);
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
        //
        //    function showCloseNote()
        //    {
        //        $("#closeNote").css("display", "block");
        //        //        openWindowTasks("");
        //        //        document.CLIENT_COMPLAINT_FORM.action = "<%=context%>/ComplaintEmployeeServlet?op=closeComp&issueId=<%=issueId%>&compId=<%=clientCompId%>";
        //        //        document.CLIENT_COMPLAINT_FORM.submit();
        //    }
        $(document).keyup(function(e) {
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
        function notAllowed(obj) {

            alert(obj);
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
        function submitFile(){
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
                    if(result.status == 'success') {
                        $("#info").html("<font color='white'>تم رفع الملفات</font>");
                    } else if(result.status == 'failed') {
                        $("#info").html("<font color='red'>لم يتم رفع الملفات</font>");
                    }
                },
                error: function()
                {
                    $("#info").html("<font color='red'>لم يتم رفع الملفات</font>");
                },
                cache: false,
                contentType: false,
                processData: false
            });

            return false;
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
                    success: function(jsonString) {
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

        $(function() {
            $(".attach_button").click(function()
            {
                var X = $(this).attr('id');
                if (X == 1)
                {
                    $(".submenuxx").hide();
                    $(this).attr('id', '0');
                }
                else
                {
                    $(".submenuxx").show();
                    $(this).attr('id', '1');
                }

            });
            //Mouse click on sub menu
            $(".submenuxx").mouseup(function()
            {
                return false
            });
            $(".submenuxx").mouseout(function()
            {
                return false
            });
            $(".attach_button").mouseout(function()
            {
                return false
            });

            //Mouse click on my account link
            $(".attach_button").mouseup(function()
            {
                return false
            });
            $(document).mouseup(function()
            {
                $(".submenuxx").hide();
                $(".attach_button").attr('id', '');
            });
            $(document).mouseout(function()
            {
                $(".submenuxx").hide();
                $(".attach_button").attr('id', '');
            });
            $(document).mouseleave(function()
            {
                $(".submenuxx").hide();
                $(".attach_button").attr('id', '');
            }
            )
        })

        function addCommentChannel() {
            $(".submenux").hide();
            $(".button_commx").attr('id', '0');

            var url = "<%=context%>/ClientServlet?op=addCommentChannel&clientComplaintId=" + $("#clientCompId").val();
            jQuery('#addChannelComment').load(url);

            $('#addChannelComment').css("display", "block");
            $('#addChannelComment').bPopup();
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
                success: function(jsonString) {
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
                            success: function(jsonString) {
                                var info = $.parseJSON(jsonString);

                                if (info.status == 'ok') {


                                    setTimeout(
                                            function() {
                                                $('#redirectComp').bPopup().close();
                                                parent.history.back();
                                            }
                                    , 0000
                                            );
                                    //                    $('#redirectComp').css("display", "none");
                                }
                                else {

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
                                        success: function(jsonString) {



                                            var info = $.parseJSON(jsonString);

                                            if (info.status == 'ok') {
                                                $("#finishMsg").show();
                                                $(obj).removeAttr("onclick");
                                                location.reload();
                                            }
                                            else {


                                            }
                                        }
                                    });

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
                                        url: "<%=context%>/ComplaintEmployeeServlet?op=closeComp&issueId=<%=issueId%>&compId=<%=clientCompId%>&subject=<%=finReqSubject%>&comment=<%=finReqComment%>&qualitySubject=<%=qualityReqSubject%>&qualityComment=<%=qualityReqComment%>&complaintId=<%=clientCompId%>&objectType=" + $("#businessObjectType2").val(),
                                        data: {
                                            notes: notes,
                                            clientId: <%=clientId%>,
                                            endDate: endDate,
                                            actionTaken: actionTaken
                                        },
                                        success: function(jsonString) {
                                            var info = $.parseJSON(jsonString);

                                            if (info.status == 'ok') {
                                                $("#closedMsg").show();
                                                location.reload();
                                            }
                                        },
                                        error: function(){
                                            alert('failure to close');
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
                                                    success: function(jsonString) {



                                                        var info = $.parseJSON(jsonString);

                                                        if (info.status == 'ok') {
                                                            $("#rejectedMsg").html("تم الإلغاء بنجاح");
                                                            $("#rejectedMsg").show();
                                                            $(obj).removeAttr("onclick");
                                                            location.reload();
                                                        }
                                                        else {

                                                        }
                                                    }
                                                });

                                            }

                                            function clientOperation() {
                                                window.navigate("IssueServlet?op=clientOperation&clientId=<%=clientId%>&issueId=<%=clientId%>&compId=<%=clientCompId%>");

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
                success: function(jsonString) {
                    var eqpEmpInfo = $.parseJSON(jsonString);

                    if (eqpEmpInfo.status == 'Ok') {

                        $("#save" + x).html("");
                        $("#save" + x).css("background-position", "top");
                        $("#save" + x).removeAttr("onclick");
                        $("#statusCode").val("4");
                        $("#tblDataDiv").hide();
                        $("#closeImg").hide();
                        $(".button_redirec").removeAttr("onclick");
                        $(".button_redirec").click(function(){ notAllowed('تم التوزيع مسبقا'); });
                    }
                }
            });

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

            }
            else {
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
                        req = new XMLHttpRequest( );
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
                        success: function(jsonString) {
                            var info = $.parseJSON(jsonString);

                            if (info.status == 'Ok') {

                                // change update icon state
                                $(obj).html("");
                                $(obj).css("background-position", "top");

                            }
                        }
                    });

                }

                function testTeleCom() {
                    $.ajax({
                        type: "post",
                        url: "<%=context%>/TeleComServlet?op=testCall",
                        data: {},
                        success: function(jsonString) {
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
                        success: function(jsonString) {
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
                        success: function(jsonString) {
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
                        success: function(jsonString) {
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
                $(function() {
                    $(".button_commx").click(function()
                    {
                        var X = $(this).attr('id');
                        if (X == 1)
                        {
                            $(".submenux").hide();
                            $(this).attr('id', '0');
                        }
                        else
                        {
                            $(".submenux").show();
                            $(this).attr('id', '1');
                        }

                    });
                    //Mouse click on sub menu
                    $(".submenux").mouseup(function()
                    {
                        return false
                    });
                    $(".submenux").mouseout(function()
                    {
                        return false
                    });
                    $(".button_commx").mouseout(function()
                    {
                        return false
                    });

                    //Mouse click on my account link
                    $(".button_commx").mouseup(function()
                    {
                        return false
                    });
                    $(document).mouseup(function()
                    {
                        $(".submenux").hide();
                        $(".button_commx").attr('id', '');
                    });
                    $(document).mouseout(function()
                    {
                        $(".submenux").hide();
                        $(".button_commx").attr('id', '');
                    });
                    $(document).mouseleave(function()
                    {
                        $(".submenux").hide();
                        $(".button_commx").attr('id', '');
                    }
                    )
                })

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
                        success: function(jsonString) {
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

                    //                document.MainType_Form.action = "<%=context%>/ProjectServlet?op=saveAvailableUnits";


                }
    </script>
    <script type="text/javascript">
        //        function popupCloseO(obj) {
        //          
        //            $(obj).bind('click', function(e) {
        //            
        //                //                    alert($(this).parent().parent().find("#msg").html());
        //                //                    alert($(this).parent().parent().find("#proId").val());
        //                  alert(e);
        //                $('#closeNote').bPopup();
        //                $('#closeNote').css("display", "block");
        //    
        //            });
        //        }
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
        function notificationComp(obj) {
            $("#notificationMsg").text("");
            $('#notificationComp').bPopup();
            $('#notificationComp').css("display", "block");
        }

        function notificationComplaintToEmployee(obj) {

            var selectedEmpsId = $('#employeesTable').find(':checkbox:checked');
            var employeeId;
            var ids = "";
            $(selectedEmpsId).each(function(index, empId) {
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
                success: function(jsonString) {
                    var info = $.parseJSON(jsonString);
                    if (info.status == 'ok') {
//                        $("#responsibleEmp").html(responsibleEmp);
                        $("#notificationMsg").text("تم الإعــــــــــــلام");
                    }
                    if (info.status == 'error') {
                        $("#notificationMsg").css("color", "red");
                        $("#notificationMsg").text("لم يتم الإعــــــــــــلام");
                    }
                }
            });
        }
        $(function() {

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
                        clientComplaintId: <%=clientCompId%>,
                        issueId: <%=issueId%>,
                        businessId: <%=issueWbo.getAttribute("businessID")%>,
                        comment: "اعادة توجيه من <%=securityUser.getFullName()%>",
                        subject: "اعادة توجيه من <%=securityUser.getFullName()%>"
                    },
                    success: function(jsonString) {
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
                    }, error: function(jsonString) {
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

        $(function() {
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
            var wind = window.open(url, "", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no,navigationbar=no,fullscreen=yes");
            wind.focus();
        }
                                                    
        function deleteComplaint(issueId, clientComplaintId) {
            window.location.href = '<%=context%>/IssueServlet?op=deleteComplaint&issueId=' + issueId + '&clientComplaintId=' + clientComplaintId;
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
    <style type="text/css">
        .remove{

            width:20px;
            height:20px;
            margin: 4px;
            background-repeat: no-repeat;
            cursor: pointer;
            background-image:url(images/icons/icon-32-remove.png);

        }
        #showHide{
            /*background: #0066cc;*/
            border: none;
            padding: 10px;
            font-size: 16px;
            font-weight: bold;
            color: #0066cc;
            cursor: pointer;
            padding: 5px;
        }
        #dropDown{
            position: relative;
        }
        .backStyle{
            border-bottom-width:0px;
            border-left-width:0px;
            border-right-width:0px;
            border-top-width:0px
        }

        .datepick {}

        .save {
            width:20px;
            height:20px;
            background-image:url(images/icons/icon-32-publish.png);
            background-repeat: no-repeat;
            cursor: pointer;
        }
        .silver_odd_main,.silver_even_main {
            text-align: center;
        }

        input { font-size: 18px; }

    </style>
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
        /*height:20px;*/
        border: none;
    }

    #claim_division {

        width: 97%;
        display: none;
        margin:3px auto;
        border: 1px solid #999;
    }
    #order_division{

        width: 97%;
        display: none;
        margin:3px auto;
        border: 1px solid #999;
    }
    label{
        font:Verdana, Geneva, sans-serif;
        font-size:14px;
        font-weight:bold;
        color:#005599;
    }
    .login {
        /*display: none;*/
        direction: rtl;
        margin: 20px auto;
        padding: 10px 5px;
        /*        width:30%;*/
        background: #3f65b7;
        background-clip: padding-box;
        border: 1px solid #ffffff;
        border-bottom-color: #ffffff;
        border-radius: 5px;
        color: #ffffff;

        background: #7abcff; /* Old browsers */
        /* IE9 SVG, needs conditional override of 'filter' to 'none' */
        /*background: url(data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiA/Pgo8c3ZnIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgd2lkdGg9IjEwMCUiIGhlaWdodD0iMTAwJSIgdmlld0JveD0iMCAwIDEgMSIgcHJlc2VydmVBc3BlY3RSYXRpbz0ibm9uZSI+CiAgPGxpbmVhckdyYWRpZW50IGlkPSJncmFkLXVjZ2ctZ2VuZXJhdGVkIiBncmFkaWVudFVuaXRzPSJ1c2VyU3BhY2VPblVzZSIgeDE9IjAlIiB5MT0iMCUiIHgyPSIwJSIgeTI9IjEwMCUiPgogICAgPHN0b3Agb2Zmc2V0PSIwJSIgc3RvcC1jb2xvcj0iIzdhYmNmZiIgc3RvcC1vcGFjaXR5PSIxIi8+CiAgICA8c3RvcCBvZmZzZXQ9IjEwMCUiIHN0b3AtY29sb3I9IiM0MDk2ZWUiIHN0b3Atb3BhY2l0eT0iMSIvPgogIDwvbGluZWFyR3JhZGllbnQ+CiAgPHJlY3QgeD0iMCIgeT0iMCIgd2lkdGg9IjEiIGhlaWdodD0iMSIgZmlsbD0idXJsKCNncmFkLXVjZ2ctZ2VuZXJhdGVkKSIgLz4KPC9zdmc+);*/
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
    .dropdown 
    {
        color: #555;

        /*margin: 3px -22px 0 0;*/
        width: 128px;
        position: relative;
        height: 17px;
        text-align:left;
    }
    .dropdown li a 
    {
        color: #555555;
        display: block;
        font-family: arial;
        font-weight: bold;
        padding: 6px 15px;
        cursor: pointer;
        text-decoration:none;
    }
    .dropdown li a:hover
    {
        background:#155FB0;
        color:yellow;
        text-decoration: none;
    }
    .submenux
    {

        background:#FFFFCC;
        position: absolute;
        top: 30px;
        left:0px;
        /*left: 0px;*/
        /*        z-index: 1000;*/
        width: 120px;
        display: none;
        margin-left: 0px;;
        padding: 0px 0 5px;
        border-radius: 6px;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.45);
        z-index: 1000;
    }

    #call_center{
        direction:rtl;
        padding:0px;
        margin-top: 10px;
        /*        background-color: #dedede;*/
        margin-left: auto;
        margin-right: auto;
        margin-bottom: 5px;
        color:#005599;
        /*            height:600px;*/
        width:98%;
        /*position:absolute;*/
        border:1px solid #f1f1f1;
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
    .text-success{
        font-family:Verdana, Geneva, sans-serif;
        font-size:24px;
        font-weight:bold;
    }

    #tableDATA th{

        font-size: 15px;
    }

    .save {
        width:32px;
        height:32px;
        background-image:url(images/icons/check.png);
        background-repeat: no-repeat;
        cursor: pointer;
    }
    .status{

        width:32px;
        height:32px;
        background-image:url(images/icons/status.png);
        background-repeat: no-repeat;
        cursor: pointer;
    }
    .remove {
        width:32px;
        height:32px;
        margin: 4px;
        background-repeat: no-repeat;
        cursor: pointer;
        background-image:url(images/icons/remove.png);

    }
    .button_commx {
        width:135px;
        height:29px;
        margin: 4px;
        background-repeat: no-repeat;
        cursor: pointer;
        border: none;
        /**/
        background-position: right top ;
        display: inline-block;
        background-color: transparent;
        background-image:url(images/buttons/comm.png);
    }
    .button_attach{
        width:135px;
        height:29px;
        margin: 4px;
        background-repeat: no-repeat;
        cursor: pointer;
        border: none;
        /**/
        background-position: right top ;
        display: inline-block;
        background-color: transparent;
        background-image:url(images/buttons/attach.png);
    }
    .button_bookmar {
        width:135px;
        height:29px;
        margin: 4px;
        background-repeat: no-repeat;
        cursor: pointer;
        border: none;
        background-position: right top ;
        display: inline-block;
        background-color: transparent;
        background-image:url(images/buttons/bookmark.png);
    }

    .button_redirec{
        width:135px;
        height:29px;
        margin: 4px;
        background-repeat: no-repeat;
        cursor: pointer;
        border: none;
        background-position: right top ;
        display: inline-block;
        background-color: transparent;
        background-image:url(images/buttons/redi.png);
    }

    .button_finis{
        width:135px;
        height:29px;
        margin: 4px;
        background-repeat: no-repeat;
        cursor: pointer;
        border: none;
        background-position: right top ;
        display: inline-block;
        background-color: transparent;
        background-image:url(images/buttons/finish.png);
    }
    .button_notification {
        width:135px;
        height:29px;
        margin: 4px;
        background-repeat: no-repeat;
        cursor: pointer;
        border: none;
        background-position: right top ;
        display: inline-block;
        background-color: transparent;
        background-image:url(images/buttons/notification.png);
    }
    .rejectedBtn{
        width:135px;
        height:29px;
        margin: 4px;
        background-repeat: no-repeat;
        cursor: pointer;
        border: none;
        background-position: right top ;
        display: inline-block;
        background-color: transparent;
        background-image:url(images/buttons/button5.png);
    }

    .button_clos {
        width:135px;
        height:29px;
        margin: 4px;
        background-repeat: no-repeat;
        cursor: pointer;
        border: none;
        background-position: right top ;
        display: inline-block;
        background-color: transparent;
        background-image:url(images/buttons/close.png);
    }

    .button_clientO{
        width:135px;
        height:29px;
        margin: 4px;
        background-repeat: no-repeat;
        cursor: pointer;
        border: none;
        background-position: right top ;
        display: inline-block;
        background-color: transparent;
        background-image:url(images/buttons/clientO.png);
        /*        background-position: top right;*/
    }.managerBt{
        width:135px;
        height:29px;
        margin: 4px;
        background-repeat: no-repeat;
        cursor: pointer;
        border: none;
        background-position: right top ;
        display: inline-block;
        background-color: transparent;
        background-image:url(images/buttons/manager.png);
        /*        background-position: top right;*/
    }
    .popup_conten{ 

        border: none;

        direction:rtl;
        padding:0px;
        margin-top: 10px;
        border: 1px solid tomato;
        background-color: #f1f1f1;
        margin-bottom: 5px;
        width: 300px;

        /*position:absolute;*/

        font:Verdana, Geneva, sans-serif;
        font-size:18px;
        font-weight:bold;
        display: none;
    }

    .submenuxx
    {

        background:#FFFFCC;
        position: absolute;
        top: 30px;
        left:30px;
        /*left: 0px;*/
        /*        z-index: 1000;*/
        width: 120px;
        display: none;
        margin-left: 0px;;
        padding: 0px 0 5px;
        border-radius: 6px;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.45);
            z-index: 1000;
    }

    .attach_button{
        width:135px;
        height:29px;
        margin: 4px;
        background-repeat: no-repeat;
        cursor: pointer;
        border: none;
        background-position: right top ;
        display: inline-block;
        background-color: transparent;
        background-image:url(images/buttons/attachF.png);
    }
    .buttons-input {
        width:350px;
    }

    .buttons-input ul {
        margin:0px;
        padding:0px;
    }

    .buttons-input ul li {
        display:inline-block;
    }
    .order_phases_btn{
        width:135px;
        height:29px;
        margin: 4px;
        background-repeat: no-repeat;
        cursor: pointer;
        border: none;
        background-position: right top ;
        display: inline-block;
        background-color: transparent;
        background-image:url(images/buttons/9.png);
    }
    .print_complaint_btn{
        width:135px;
        height:29px;
        margin: 4px;
        background-repeat: no-repeat;
        cursor: pointer;
        border: none;
        background-position: right top ;
        display: inline-block;
        background-color: transparent;
        background-image:url(images/buttons/8.png);
    }
    .re-open{
            width:135px;
            height:29px;
            margin: 4px;
            background-repeat: no-repeat;
            cursor: pointer;
            border: none;
            background-position: right top ;
            display: inline-block;
            background-color: transparent;
            background-image:url(images/buttons/re.png);
        }
        .re-delete{
            width:135px;
            height:29px;
            margin: 4px;
            background-repeat: no-repeat;
            cursor: pointer;
            border: none;
            background-position: right top ;
            display: inline-block;
            background-color: transparent;
            background-image:url(images/buttons/delete.png);
        }
</style>
<body>
    <div id="update_code"  style="display: none;width: 250px;position: fixed; z-index: 1000;"><!--class="popup_appointment" -->
        <div style="clear: both;margin-left: 148%;margin-bottom: -38px;z-index: -10000000;">
            <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
             -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
             box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
             -webkit-border-radius: 100px;
             -moz-border-radius: 100px;
             border-radius: 100px;" onclick="closePopup(this)"/>
        </div>
        <div class="login" style="width: 150%;margin-bottom: 10px;margin-left: auto;margin-right: 10%;">
            <table  border="0px"  style="width:100%;"  class="table">
                <tr>
                    <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 30%;">الكود الجديد</td>
                    <td style="width: 70%;" >
                        <input id="newCode" value="<%=clientCompWbo.getAttribute("businessCompID")%>" style="width: 180px;"/>
                    </td>
                </tr> 
            </table>
            <div style="text-align: center;margin-left: auto;margin-right: auto;clear: both"> 
                <input type="button" value="حفظ"   onclick="updateCode(this)" id="saveComm"class="login-submit"/>
            </div>
        </div>  
    </div>
    <FORM NAME="CLIENT_COMPLAINT_FORM" METHOD="POST">
        <input type="hidden" id="clientId" name="clientId" value="<%=clientId%>"/>
        <input type="hidden" name="complaintId" id="complaintId" value="<%=complaintId%>"/>
        <input type="hidden" name="clientCompId" id="clientCompId" value="<%=clientCompId%>"/>
        <!--<button onclick="JavaScript: submitForm();" class="button_comment" style="border: none;" >-->

        <!--</button>-->
        <!--<DIV align="left" STYLE="color:blue;margin-bottom: 30px;background-color: #f1f1f1;width: 975px;margin-top:15px;">-->

        <!--            <%if (wb != null) {%>
                    <label><%=wb.getAttribute("userName")%></label>
        <%}%>
        -->



        <!--</DIV>-->

<!--<a href="IssueServlet?op=clientOperation&clientId=<%=clientId%>&issueId=<%=clientId%>&compId=<%=clientCompId%>"><%=clientOperation%></a>-->
        <%            if (null != status) {
                if (status.equalsIgnoreCase("ok")) {
        %>  
        <script type="text/javascript">
            $(function() {
                //            $("#productsBtn").css("display", "inline-block");

                //  alert("dffffffff");
                //            $("#redirectCust").css("display", "inline-block");
            });

        </script>
        <%}
            }%>



        <div id="complaintReport" style="display: none;width: 80%; height: 80%;">

        </div>

        <div id="addChannelComment" style="display: none;width: 80%; height: auto">

        </div>
        <div id="redirectComp"  style="width: 30%;display: none;">


            <div style="clear: both;margin-left: 89%;margin-top: 0px;margin-bottom: -35px;z-index: -10;">
                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;" onclick="closePopup(this)"/>
            </div>

            <!--<h1>رسالة قصيرة</h1>-->
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
                    <!--                    <tr>
                                            <td style="width: 40%;"> <label style="width: 100px;">سبب التوجيه</label></TD>
                                            <td  ><%
                                                String note = "إدارة غير مختصة";
                    %>
                    <SELECT id="redirectNote" name="redirectNote" STYLE="width:80%;font-size: small;">
                        <option value="<%=note%>" style="text-align: right;">إدارة غير مختصة</option>
                    </SELECT>
                </td>
            </tr>-->
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
                            for (WebBusinessObject wbo : allEmployees) {
                        %>
                        <TR id="empRow">

                            <TD style="background-color: transparent;">
                                <SPAN style="display: inline-block;height: 20px;background: transparent;"><INPUT type="checkbox" id="empId" class="case" value="<%=wbo.getAttribute("userId")%>" name="selectedEmp"/>
                                    <input type="hidden" id="employeeId" value="<%=wbo.getAttribute("userId")%>" />
                                </SPAN>
                            </TD>

                            <TD style="background-color: transparent;">
                                <%=wbo.getAttribute("userName")%>
                            </TD>
                            <TD style="background-color: transparent;">
                                <%=wbo.getAttribute("fullName")%>
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
                                for (WebBusinessObject wbo : userUnderManager) {
                        %>
                        <TR id="empRow">
                            <TD style="background-color: transparent;">
                                <SPAN style="display: inline-block;height: 20px;background: transparent;">
                                    <INPUT type="radio" id="empId" class="case" value="<%=wbo.getAttribute("userId")%>" name="selectedEmp"/>
                                    <input type="hidden" id="employeeId" value="<%=wbo.getAttribute("userId")%>" />
                                </SPAN>
                            </TD>
                            <TD style="background-color: transparent;">
                                <%=wbo.getAttribute("fullName")%>
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
                        <td colspan="2" > <input type="button"  onclick="JavaScript:finishComplaint(this);" class="button_finis"></TD>
                    </tr>
                    <tr>
                        <td colspan="2" >
                            <div style="margin: 0 auto;display: none; width: 90%;text-align: center;color: white" id="finishMsg">تم الإنهاء بنجاح</>
                        </td>
                    </tr>


                </TABLE>
            </div>

        </div>
        <div  id="call_center" class="show">

            <div style="width: 90%;">
                <table style="width: 100%;margin-top: 7px;margin-bottom: 10px;" class="table">
                    <tr algin="center">
                        <td colspan="2" class="blueBorder blueHeaderTD" style="font-size:17px;">مركز التحكم والإتصال</td>
                    </tr>
                </table>
                <div id="showDiv"    style="width: 80% !important;margin-left: auto;margin-right: auto;display: none">
                    <div style="clear: both;margin-left: 89%;margin-top: 0px;margin-bottom: -15px;z-index: -10000000;">&nbsp;
                        <img id="closeImg" src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;" onclick="closeDiv(this)"/>
                    </div>
                    <DIV id="tblDataDiv" style="width: 90%;margin-left: auto;margin-right: auto;">

                        <TABLE id="tblData" class="blueBorder" ALIGN="center" dir="<%=dir%>" width="100%" >
                            <TR>
                                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="5%"><b>#</b></TD>
                                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="10%" ><b><%=codeStr%></b></TD>
                                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="20%" id="empNameShown" value=""><b><%=projectStr%></b></TD>
                                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="10%"><b><%=distanceStr%></b></TD>
                                <!--<TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="10%"><b><%=responsibleStr%></b></TD>-->
                                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="5%"><b><%=save%></b></TD>
                                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="5%"><b><%=deleteStr%></b></TD>
                            </TR>
                        </TABLE>
                    </DIV>
                </div>
                <div style="width: 100%;">
                    <fieldset style="width:97.5%;background-color:#b9d2ef;">
                        <legend style="color: #FF3300;">نقطةالمتابعة الرئيسى</legend>

                        <table width="100%" dir="rtl" style="border-left:0px;" class="table"">
                            <tbody>
                            <tr>
                               <td>
                                   <table width="70%" dir="rtl" style="border-left:0px;background: #f9f9f9" class="table">
                                       <tbody>
                                           <tr>
                                             <td  style="text-align: right"   >رقم المتابعة</td>
                                    <td style="<%=style%>;padding-right: 30px">
                                        <b>
                                            <font color="red" size="3"><%=issueWbo.getAttribute("businessID")%></font>/<font color="blue" size="3" ><%=issueWbo.getAttribute("businessIDbyDate")%></font> </b>
                                    </td>
                                    <td style="text-align: right" > الموضوع</td>
                                    <td style="text-align:right;padding-right: 30px">
                                        <strong><%=issueType%></strong>
                                    </td>
                                    <td  ></td>
                                    
                                           </tr>
                                           <tr>
                                                <td style="text-align: right" >المصدر</td>
                                    <td style="text-align:right;padding-right: 30px">
                                        <strong><%=sourceName%></strong>
                                    </td>
                                    
                                    <td style="text-align: right" >عمر الاتصال</td>
                                    <td style="text-align:right;padding-right: 30px">
                                        <strong><%=age%></strong>
                                    </td>
                                     <td  ></td>
                                               
                                           </tr>
                                           <tr>
                                              <td  style="text-align: right"   >عدد المعتمدات</td> 
                                              <td style="<%=style%>;padding-right: 30px">
                                        <b>
                                            <a href="<%=context%>/IssueServlet?op=getCompUnderIssue&issueId=<%=issueId%>"><font color="red" size="3"><%=issueWbo.getAttribute("numOfOrders")%></font></a></b>
                                    </td>
                                    <td style="text-align: right" >تاريخ التسجيل</td>
                                    <td style="text-align:right;padding-right: 30px">
                                        <strong><%=issueWbo.getAttribute("creationTime").toString().substring(0, 10)%></strong>
                                    </td>
                                     <td  ></td>
                                           </tr>
                                    <%
                                    if (dependOnIssuesList != null && !dependOnIssuesList.isEmpty()) {
                                    %>
                                    <tr>
                                        <td style="text-align: right"> المعتمدات الاضافية</td> 
                                        <td style="<%=style%>;padding-right: 30px">
                                            <b><a href="<%=context%>/IssueServlet?op=getDepOnIssues&issueId=<%=issueId%>"><font color="red" size="3"><%=dependOnIssuesList.size()%></font></a></b>
                                        </td>
                                        <td style="text-align: right">
                                            &nbsp;
                                        </td>
                                        <td style="text-align:right;padding-right: 30px">
                                            &nbsp;
                                        </td>
                                        <td>
                                            &nbsp;
                                        </td>
                                    </tr>
                                    <%
                                    }
                                    %>
                                       </tbody>
                                   </table>
                               </td>
                               <td style="text-align:right;padding-right: 30px">
                                   <table >
                                            <tbody>
                                                <tr>
                                                  <td style="display: <%=issueWbo.getAttribute("issueDesc") != null && !((String) issueWbo.getAttribute("issueDesc")).equalsIgnoreCase("internal") ? "" : "none"%>">
                                                        <%if (issueWbo.getAttribute("issueDesc") != null && issueWbo.getAttribute("issueDesc").toString().equals("call")) {%>
                                                        <img src="images/dialogs/phone.png" width="30px" height="34px" title="call"/>
                                                        <%} else if (issueWbo.getAttribute("issueDesc") != null && issueWbo.getAttribute("issueDesc").toString().equals("internet")) {%>
                                                        <img src="images/dialogs/internet-icon.png" width="30px" height="34px" title="Internet"/>
                                                        <%} else if (issueWbo.getAttribute("issueDesc") != null && issueWbo.getAttribute("issueDesc").toString().equals("meeting")) {%>
                                                        <img src="images/dialogs/handshake.png" width="30px" height="34px" title="Meeting"/>
                                                        <%}%>
                                                    </td>   
                                  
                                                    <td style="display: <%=issueWbo.getAttribute("issueDesc") != null && !((String) issueWbo.getAttribute("issueDesc")).equalsIgnoreCase("internal") ? "" : "none"%>">
                                                        <%if (issueWbo.getAttribute("callType") != null && issueWbo.getAttribute("callType").toString().equals("incoming")) {%>
                                                        <img src="images/dialogs/call-incoming.png" width="30px" height="34px" title="Incoming"/>
                                                        
                                                        <% } else {%>
                                                        
                                                        <img src="images/dialogs/call-outgoing.png" width="30px" height="34px" title="Outgoing"/>
                                                        <%}%>
                                                    </td>
                                                    <td style="display: <%=issueWbo.getAttribute("issueDesc") != null && !((String) issueWbo.getAttribute("issueDesc")).equalsIgnoreCase("internal") ? "" : "none"%>">
                                                        
                                                        <div style="width: 100%; border-left-style: solid; border-left-color: rgb(153, 153, 153); border-left-width: 1px; float: right;height:30px" ></div>
                                                        
                                                    </td>
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
                                                    <td>
                                        <a href='JavaScript:viewDocuments("<%=issueId%>")'>
                                            <img src="images/Foldericon.png" width="30" height="34" title="<%=viewDocuments%>" />
                                        </a>
                                                     </td>
                                                   <td>
                                        <a href='JavaScript:viewImages("<%=issueId%>")'>
                                            <img src="images/jpgImageIcon.png" width="30" height="34" title="<%=photoGallery%>" />
                                        </a>
                                                   </td>
                                                    <%
                                                       if (privilegesList.contains("FORCE_CHANGE")) {
                                                   %>
                                                   <td style="width: 30px; height: 30px; cursor: hand;" onclick="JavaScript: popupUpdateCode();">
                                                       <img src="images/change.png" width="30" height="34" title="Force Change" />
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
                                                    </tr>
                                            </tbody>
                                            
                                        </table>
                               </td>
                            </tr>
                        

                        </tbody>
                        </table>
                        <%-- <input type="button" id="compReport" value="مراحل الطلب" style="float: right;" onclick="comp_Report(this)"/>
                         <button onclick="getClientComplaintWithComments('<%=clientCompId%>'); return false;" class="button">
                             <%=printTask%><img src="<%=context%>/images/pdf_icon.gif" HEIGHT="20">
                         </button>--%>
                    </fieldset>

                </div>
                <!--<tr style="">-->
                <!--//         <td style="border-left: none;width: 35%;">-->
                <div style="width: 100%;">
                    <div style="width: 35%;float: right;display: block;">
                        <!--<fieldset style="width:100%;padding: 10px;">-->
                        <%--
                        <fieldset style="width:97.5%;background-color:99FFFF">
                            <legend style="color: #FF3300;">بيانات الاتصال</legend>

                            <table width="100%"   dir="rtl" style="border-left:0px;" class="table">
                                <tr>
                                    <td  width="30%" style="background-color:#A0A0A0;"   >رقم المتابعة</td>
                                    <td style="<%=style%>">
                                        <b><font color="red" size="3"><%=issueWbo.getAttribute("businessID")%></font>/<font color="blue" size="3" ><%=issueWbo.getAttribute("businessIDbyDate")%></font> </b>
                                    </td>
                                </tr>
                                <tr>
                                    <td width="30%"  style="background-color:#A0A0A0;" >المصدر</td>
                                    <td style="text-align:right;">
                                        <strong><%=sourceName%></strong>
                                    </td>
                                </tr>
                                <tr>
                                    <td width="30%"  style="background-color:#A0A0A0;" > النوع</td>
                                    <td style="text-align:right;">
                                        <strong><%=issueType%></strong>
                                    </td>
                                </tr>
                                <tr>
                                    <td width="30%"  style="background-color:#A0A0A0;" >العمر باليوم</td>
                                    <td style="text-align:right;">
                                        <strong><%=age%></strong>
                                    </td>
                                </tr>
                                <tr>
                                    <td width="30%"  style="background-color:#A0A0A0;" > نوع المكالمة</td>
                                    <td style="text-align:right;">
                                           <input name="call_status" type="radio" value="incoming" <%if (issueWbo.getAttribute("callType") != null && issueWbo.getAttribute("callType").toString().equals("incoming")) {%> checked <%}%>/>
                                        <label><img src="images/dialogs/call-incoming.png" width="24px"/>واردة</label>
                                               <input name="call_status" type="radio" value="out_call" <%if (issueWbo.getAttribute(
                                                           "callType") != null && issueWbo.getAttribute("callType").toString().equals("out_call")) {%> checked <%}%>/>
                                        <label><img src="images/dialogs/call-outgoing.png" width="24px"/>صادرة</label>

                                </tr>
                                <tr>
                                    <td  style="background-color:#A0A0A0;"  >تعليق مركز الإتصال </td>
                                    <td style="text-align:right;"><textarea rows="5" cols="10" style="width:100%;" resize="false" ><%=issueWbo.getAttribute("issueDesc")%></textarea></td>
                                </tr>
                                <tr>
                                    <td  style="background-color:#A0A0A0;"  ><%=viewDocuments%></td>
                                    <td style="text-align:right;">
                                        <a href='JavaScript:viewDocuments("<%=issueId%>")'>
                                            <img src="images/view.png" width="17" height="17" title="<%=viewDocuments%>" />
                                        </a>
                                    </td>
                                </tr>
                                
                                <tr>
                                    <td  style="background-color:#A0A0A0;"  ><%=photoGallery%></td>
                                    <td style="text-align:right;">
                                        <a href='JavaScript:viewImages("<%=issueId%>")'>
                                            <img src="images/imicon.gif" width="17" height="17" title="<%=photoGallery%>" />
                                        </a>
                                    </td>
                                </tr>
                            </table>
                        </fieldset>
                        --%>
                    </div>
                    <!--</td>-->
                    <!--<td  style="border-right: none;width: 50%;">-->
                    <% 
                        String compType = "";
                        String comp_details = "";
                        boolean showDetails = true;
                        if (clientCompWbo.getAttribute("ticketType").toString().equals("1")) {
                            compType = " الشكوى";
                            comp_details = "تفاصيل الشكوى";
                        } else if (clientCompWbo.getAttribute("ticketType").toString().equals("2")) {
                            compType = " الطلب";
                            comp_details = "تفاصيل الطلب";
                        } else if (clientCompWbo.getAttribute("ticketType").toString().equals("3")) {
                            compType = " الإستعلام";
                            comp_details = "تفاصيل الشكوى";
                        } else if (clientCompWbo.getAttribute("ticketType").toString().equals("5")) {
                            compType = "مستخلص";
                            comp_details = "تفاصيل المستخلص";
                            showDetails = false;
                        } else if (clientCompWbo.getAttribute("ticketType").toString().equals("6")) {
                            compType = "ط. تسليم";
                            comp_details = "تفاصيل الطلب";
                            showDetails = false;
                        } else if (clientCompWbo.getAttribute("ticketType").toString().equals("7")) {
                            compType = "م. مالية";
                            comp_details = "تفاصيل المطالبة";
                            showDetails = false;
                        } else if (clientCompWbo.getAttribute("ticketType").toString().equals("12")) {
                            compType = "أمر تشغيل";
                            comp_details = "أمر تشغيل";
                            showDetails = false;
                        }
                        WebBusinessObject wbo = new WebBusinessObject();
                        if (clientCompVector != null && !clientCompVector.isEmpty()) {
                            wbo = clientCompVector.get(0);
                    %>
                    <div style="width: 100%;display: block;float: left;" id="section">
                        <fieldset style="width: 97.5%;background-color: FFFF99;" >
                            <legend style="color: #FF3300;"><%=compType%></legend>

                            <div style="width: 41.2%;float: right;">
                                <table border="1px" width="100%" class="table" align="right" style="float: right;margin: 0px !important;">
                                    
                                    <tr>
                                                <td style="text-align: left;" colspan="3">
                                                    <label style="font-size: smaller;">TASK STATUS</label>
                                                    <table align="right"  class="table" cellpadding="0" cellspacing="0" style="border: 0px black solid;">
                                                        <tr>
                                                            
                                                            
                                                            <td  style="text-align:center; background: #f1f1f1; text-align:center;margin-left: 10px;">
                                                                <img src="images/client/close-Yellow.jpg" height="30px"
                                                                     style="display:<%=request.getAttribute("statusCode").equals("7") ? "block" : "none"%>; "/>
                                                                <img src="images/client/close.jpg" height="30px"
                                                                     style="display:<%=request.getAttribute("statusCode").equals("7") ? "none" : "block"%>; "/>
                                                            </td>
                                                            <td style="text-align:center; background: #f1f1f1;">
                                                                <img src="images/client/finish-Yellow.jpg" height="30px"
                                                                     style="display: <%=request.getAttribute("statusCode").equals("6") ? "block" : "none"%>; text-align:center;"/>
                                                                <img src="images/client/finish.jpg" height="30px"
                                                                     style="display: <%=request.getAttribute("statusCode").equals("6") ? "none" : "block"%>; text-align:center;"/>
                                                            </td>
                                                            <td style="text-align:center; background: #f1f1f1;">
                                                                <img src="images/client/cancel-Yellow.jpg" height="30px"
                                                                     style="display: <%=request.getAttribute("statusCode").equals("5") ? "block" : "none"%>; text-align:center;"/>
                                                                <img src="images/client/cancel.jpg" height="30px"
                                                                     style="display: <%=request.getAttribute("statusCode").equals("5") ? "none" : "block"%>; text-align:center;"/>
                                                            </td>
                                                            <td style="text-align:center; background: #f1f1f1;">
                                                                <img src="images/client/open-Yellow.jpg" height="30px"
                                                                     style="display: <%=(request.getAttribute("statusCode").equals("2") || request.getAttribute("statusCode").equals("3") || request.getAttribute("statusCode").equals("4")) ? "block" : "none"%>; text-align:center;"/>
                                                                <img src="images/client/open.jpg" height="30px"
                                                                     style="display: <%=(request.getAttribute("statusCode").equals("2") || request.getAttribute("statusCode").equals("3") || request.getAttribute("statusCode").equals("4")) ? "none" : "block"%>; text-align:center;"/>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                               
                                            </tr>
                                    
                                    
                                    
                                    <tr>
                                        <td  style="text-align: right"  >كـــــــــود </td>
                                        <td style="text-align:right;padding-right: 30px">

                                            <b>
                                                <font color="blue" size="3" id="businessCode"><%=wbo.getAttribute("businessCompId")%></font>
                                            </b>
                                        </td>
                                        <td>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="text-align: right;width:1%;" >عنـــــوان </td>
                                        <td style="text-align:right;padding-right: 30px">

                                            <b style="">
                                                <font color="green"  size="3" ><%=wbo.getAttribute("typeName")%></font>
                                            </b>
                                        </td>
                                        <td>
                                        </td>
                                    </tr>
                                    <tr style="display: <%=showDetails ? "" : "none"%>">


                                        <TD style="text-align: right;width:1%;" ><b><%=compType%></b></TD>


                                        <% String sCompl = " ";

                                            if (wbo.getAttribute(
                                                    "comments") != null && !wbo.getAttribute("comments").equals("")) {
                                                sCompl = (String) wbo.getAttribute("comments");

                                                //sCompl = sCompl.substring(0,23) + "....";
%>
                                        <TD style="text-align:right;width: 60%;padding-right: 30px">
                                            <div id="complaintComment" style="width: 450px; font-size: larger; background-color: white; border: #005599 thin inset; padding: 5px;"><%=sCompl%></div></TD>
                                    <input type="hidden" id="compSubject" value="<%=wbo.getAttribute("compSubject")%>" />

                                    <% }%>
                                    <td >
                                        <!--
                                        <% if (request.getAttribute("statusCode") != null && request.getAttribute("statusCode").equals("7")) {%>
                                    <input type="button" id="showClosedMsg" value="ملاحظات الإغلاق" style="float: right;" onclick="showClosedMessage()"/>
                                        <% }%>
                                        <% if (request.getAttribute("statusCode") != null && request.getAttribute("statusCode").equals("6")) {%>
                                    <input type="button" id="showFinishedMsg" value="ملاحظات الإنهاء" style="float: right;" onclick="showFinishedMessage()"/>
                                        <% }%>
                                        <% if (request.getAttribute("statusCode") != null && request.getAttribute("statusCode").equals("5")) {%>
                                    <input type="button" id="showRejectedMessage" value="ملاحظات الإلغاء" style="float: right;" onclick="showRejectedMsg()"/>
                                        <% }%>
                                        -->
                                </td>
                                    </tr>
                                    <tr>
                                        <td   style="text-align: right;width:1%;"  >الحــــــالة</td>

                                <td style="<%=style%>;padding-right: 30px">
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
                                    <input type="hidden" value="<%=statusName%>" id="statusCode" />
                                </td>
                                    </tr>
                                    
                                    <tr>
                                        
                                        <td  style="text-align: right;width:1%;"   >المــــــدير</td>
                                <td style="<%=style%>;padding-right: 30px">
                                            <%
                                                String managerName = (String) request.getAttribute("managerName");
                                                String managerId = (String) request.getAttribute("managerId");
                                                String loggedUserId = securityUser.getUserId();
                                            %>
                                            <%=managerName%>
                                </td>
                                    </tr>
                                    
                                    <tr>
                                        <td  style="text-align: right;width:1%;min-width: 100px"   >المسئــول</td>
                                <td style="<%=style%>;padding-right: 30px" id="responsibleEmp">
                                            <%
                                                String receipName = "";
                                                receipName = (String) request.getAttribute("receipName");
                                            %>
                                            <%=receipName%>
                                </td>
                                    </tr>
                                    <%--
                                     <tr>
                                          <td >

                                            <% if (request.getAttribute("statusCode") != null && request.getAttribute("statusCode").equals("7")) {%>
                                    <input type="button" id="showClosedMsg" value="ملاحظات الإغلاق" style="float: right;" onclick="showClosedMessage()"/>
                                            <% }%>
                                            <% if (request.getAttribute("statusCode") != null && request.getAttribute("statusCode").equals("6")) {%>
                                    <input type="button" id="showFinishedMsg" value="ملاحظات الإنهاء" style="float: right;" onclick="showFinishedMessage()"/>
                                            <% }%>
                                            <% if (request.getAttribute("statusCode") != null && request.getAttribute("statusCode").equals("5")) {%>
                                    <input type="button" id="showRejectedMessage" value="ملاحظات الإلغاء" style="float: right;" onclick="showRejectedMsg()"/>
                                            <% }%>
                                </td>
                                    </tr>
                                    --%>
                                    <tr>
                                        <td>
                                       
                        
                                   </td> </tr>
                                    <!--                    <tr>
                                                            <td  style="background-color:#A0A0A0;"  >المرسل</td>
                                                            <td style="text-align:right;">
                                    
                                                                <b>
                                                                    <font color="blue" size="3" ><%=wbo.getAttribute("fullName")%></font>
                                                                </b>
                                                            </td>
                                                        </tr>
                                    -->

                                </table>
                            </div>
                            <div style="margin-right: 54%;" id="cc">
                                <%   if (prvType.size() > 0) {
                                        CrmIssueStatus crmIssueStatus = new CrmIssueStatus();
                                        boolean canNotificate = false;
                                        if (privilegesList.contains("NOTIFICATIONS")) {
                                            canNotificate = true;
                                        }
                                        boolean canClose = false;
                                        boolean isClosed = false;
                                        boolean notFinished = false;
                                        if (privilegesList.contains("CLOSE") && isOwnerManager) {
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
                                        if (privilegesList.contains("FINISHED") && isOwner) {
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
                                <div class="buttons-input">
                                    <ul>
                                        <li style="display : <%=canNotificate ? "" : "none"%>">
                                            <input type="button" class="button_notification" onclick="notificationComp(this);"/>
                                        </li>
                                        <li style="display : <%=canClose ? "" : "none"%>">
                                            <input type="button" class="button_clos" onclick="popupCloseO(this);"/>
                                        </li>
                                        <li style="display : <%=isClosed ? "" : "none"%>">
                                            <input type="button" class="button_clos" onclick="notAllowed('تم الإغلاق مسبقا')"/>
                                        </li>
                                        <li style="display : <%=notFinished ? "" : "none"%>">
                                            <input type="button" class="button_clos" onclick="notAllowed('قم بالإنهاء أولا ثم الإغلاق')"/>
                                        </li>
                                        <li style="display : <%=canComment ? "" : "none"%>">
                                            <div class="dropdown" style="padding-left: 12px;">
                                                <input type="button" class="button_commx" onclick="return false;"/>
                                                <div class="submenux" style="z-index: 100;">
                                                    <ul class="root">
                                                        <li ><a href="#" style="text-align: right"  onclick="JavaScript:getComment();">إضافة تعليق</a></li>
                                                        <li ><a href="#" style="text-align: right"  onclick="JavaScript:addCommentChannel()">إضافة تعليق قناة</a></li>
                                                        <li ><a href="#" style="text-align: right" onclick="showComments(this)">مشاهدة التعليقات</a></li>
                                                    </ul>
                                                </div>
                                            </div>
                                        </li>
                                        <li style=" display : <%=canDistribute ? "" : "none"%> ">
                                            <input type="button" class="button_redirec" onclick="return getDataInPopup('ComplaintEmployeeServlet?op=usersUnderManager&formName=CLIENT_COMPLAINT_FORM&selectionType=multi&complaintId=' + $('#complaintId').val() + '&managerID=<%=userWbo.getAttribute("userId")%>')"/>
                                        </li>
                                        <li style="display : <%=isDistributed ? "" : "none"%>">
                                            <input type="button" class="button_redirec" onclick="notAllowed('تم التوزيع مسبقا')"/>
                                        </li>
                                        <li style="display : <%=canFinish && !request.getAttribute("statusCode").equals("5") ? "" : "none"%>">
                                            <input type="button" class="button_finis" onclick="popupFinishO(this);"/>
                                        </li>
                                        <li style="display : <%=isFinished && !request.getAttribute("statusCode").equals("5") ? "" : "none"%>">
                                            <input type="button" class="button_finis" onclick="notAllowed(' تم الإنهاء مسبقا')"/>
                                        </li>
                                        <li style="display : <%=request.getAttribute("statusCode").equals("5") ? "" : "none"%>">
                                            <input type="button" class="button_finis" onclick="notAllowed(' تم الألغاء مسبقا')"/>
                                        </li>
                                        <li style="display : <%=canAssign ? "" : "none"%>">
                                            <input type="button" class="managerBt" onclick="redistributionComp(this)"/>
                                        </li>
                                        <li style="display : <%=withEmployee ? "" : "none"%>">
                                            <input type="button" class="managerBt" onclick="notAllowed('الطلب مع الموظف المختص')"/>
                                        </li>
                                        <li style="display : <%=orderInAction ? "" : "none"%>">
                                            <input type="button" class="managerBt" onclick="notAllowed('تم التعامل مع الطلب من قبل')"/>
                                        </li>
                                        <li style="display : <%=notDistributed ? "" : "none"%>">
                                            <input type="button" class="managerBt" onclick="notAllowed('لا يمكن اجراء هذا الطلب الأن')"/>
                                        </li>
                                        <li style="display : <%=canCancel && !request.getAttribute("statusCode").equals("5") ? "" : "none"%>">
                                            <input type="button" class="rejectedBtn" onclick="rejectedComp(this)"/>
                                        </li>
                                        <li style="display : <%=request.getAttribute("statusCode").equals("5") ? "" : "none"%>">
                                            <input type="button" class="rejectedBtn" onclick="notAllowed(' تم الألغاء مسبقا')"/>
                                        </li>
                                        <li style="display : <%=canAttach ? "" : "none"%>">
                                            <div class="dropdown" style="padding-left: 12px;">
                                                <input type="button" class="attach_button" onclick="return false;"/>
                                                <div class="submenuxx">
                                                    <ul class="root">
                                                        <li ><a href="#" style="text-align: right"  onclick="JavaScript: popupAttach(this);">إضافة ملف</a></li>
                                                        <li ><a href="#" style="text-align: right" onclick="JavaScript: showAttachedFiles(this);">مشاهدة الملفات</a></li>
                                                    </ul>
                                                </div>
                                            </div>
                                        </li>
                                        <li style="display : <%=viewOrderPhases ? "" : "none"%>">
                                            <input type="button" class="order_phases_btn" onclick="comp_Report(this)"/>
                                        </li>
                                        <li style="display : <%=printComplaint ? "" : "none"%>">
                                            <input type="button" class="print_complaint_btn" onclick="getClientComplaintWithComments('<%=clientCompId%>');
                                                    return false;"/>
                                        </li>
                                        <li style="display : <%=deleteComplaint ? "" : "none"%>">
                                            <input type="button" class="re-delete" onclick="deleteComplaint('<%=issueId%>', '<%=clientCompId%>'); return false;" />
                                        </li>
                                        <li style="display : <%=reFinishComplaint ? "" : "none"%>">
                                            <input type="button" class="re-open" onclick="popupFinishO(this); return false;" />
                                        </li>
                                    </ul>
                                </div>
                                <%
                                } else {
                                %>
                                <b>لاتوجد صلاحيات من فضلك الإتصال بالمدير لتعين الصلاحيات الخاصة بك</b>
                                <%}%>
                                <%
                                    String statusCode = (String) wbo.getAttribute("statusCode");%>
                                <input type="hidden" id="statusCode" value="<%=statusCode%>" name="statusCode"/>
                                <input type="hidden" id="status_code" value="<%=statusCode%>" name="statusCode"/>
                            </div>
                        </fieldset>
                    </div>
                    <%}%>
                </div>
            </div>
            <div style="clear:both"></div>
            <!--</td>-->

            <!--</tr>-->

            <!--</table>-->
            <!--          <div>-->
            <%        String page5 = (String) request.getAttribute("includePage");
                if (null == page5) {
                    //page5 = securityUser.getDefaultPage();
                }
                //                               else{

                //                                               }
                try {
            %>

            <jsp:include page="<%=page5%>" flush="true"/>
            <%
            } catch (Exception ex) {%>
            <%
                    out.println(ex.getMessage());

                }%>
            <!--  </div>-->


        </div>

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
        <div id="show_attached_files"   style="width: 70% !important;display: none;position: fixed ;">

        </div>

        <div id="showImage"   style="width: 40% !important;display: none;position: fixed ;border:  1px solid red">
            <img id="docImage" name='docImage' alt='document image' height="300px" width="100%" style="margin-left: auto;margin-right: auto;">
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
                <!--<form id="commentForm" method="post" action="" enctype="multipart/form-data">-->
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

        </div>  

        <div id="show_comm"   style="width: 80% !important;display: none;position: fixed ;">

        </div>





        <div id="showNotes"  style="width: 30% ;margin-right: auto ;margin-left: auto;display: none;position: fixed"><!--class="popup_appointment" -->

            <div style="clear: both;margin-left: 88%;margin-top: 0px;margin-bottom: -38px;z-index: -10000000;">
                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                     -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                     box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                     -webkit-border-radius: 100px;
                     -moz-border-radius: 100px;
                     border-radius: 100px;" onclick="closePopup(this)"/>
            </div>
            <div class="login" style="width: 85%;margin-bottom: 10px;margin-left: auto;margin-right: auto;">
                <table class="" style="width:100%;text-align: right;border: none;margin-bottom: 20px;" class="table" >
                    <tr >
                        <td ALIGN="<%=align%>" style="border: none;width: 30%;font-size: 14px;">
                    <lable>الحالة</lable>
                    </td>
                    <td  style="text-align: right;border: none;">
                        <label id="compStatus" style="width: 30%;" ></label>
                    </td>
                    </tr>

                    <tr>
                        <td  ALIGN="<%=align%>" style="border: none;width: 30%;text-align: center;">
                    <lable style="font-size: 14px;">الملاحظات</lable>
                    </td>
                    <td width="70%" style="border:0px;text-align: right;">
                        <textarea rows="5"  id="compNotes" style="width: 100%;margin-top: 10px;" disabled="true"></textareae>
</td>
          </tr>
        </table>
    </div>
</div>
            

</FORM>
</body>
</html>
