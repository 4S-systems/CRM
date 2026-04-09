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
    String timeFormat = "yyyy/MM/dd HH:mm";
    SimpleDateFormat sdf = new SimpleDateFormat(timeFormat);
    String nowTime = sdf.format(cal.getTime());
    String status = (String) request.getAttribute("status");
    String issueId = (String) request.getAttribute("issueId");
    IssueMgr issueMgr = IssueMgr.getInstance();
    WebBusinessObject issueWbo = (WebBusinessObject) issueMgr.getOnSingleKey(issueId);

    EmployeeView2Mgr employeeView2Mgr = EmployeeView2Mgr.getInstance();
    Vector<WebBusinessObject> clientCompVector = new Vector();
    String clientCompId = (String) request.getParameter("compId");
    clientCompVector = employeeView2Mgr.getOnArbitraryKey(request.getParameter("compId").toString(), "key4");
    String complaintId = (String) request.getAttribute("complaintId");
    ClientComplaintsMgr clientComplaintsMgr = ClientComplaintsMgr.getInstance();
    WebBusinessObject wb = new WebBusinessObject();
    wb = clientComplaintsMgr.getCurrentOwner(clientCompId);

    Vector products = (Vector) request.getAttribute("products");


    String call_status = (String) issueWbo.getAttribute("callType");
        String entryDate = (String) request.getAttribute("entryDate");
//    entryDate = entryDate.substring(0, 10);
//    entryDate = entryDate.replace("-", "/");


    if (call_status == null) {
        call_status = "";

    }


    ProjectMgr projectMgr = ProjectMgr.getInstance();
    ArrayList complaintList = projectMgr.getSubProjectsByCode("cmp");

    String context = metaMgr.getContext();
    ArrayList employeesx = (ArrayList) request.getAttribute("employeesx");

//Get request data



    Vector DepComp = (Vector) request.getAttribute("DepComp");



    String filterName = (String) request.getAttribute("filterName");
    String filterValue = (String) request.getAttribute("filterValue");

    WebBusinessObject client = (WebBusinessObject) request.getAttribute("client");

    Boolean isCstatushecked = false;

    String stat = (String) request.getSession().getAttribute("currentMode");
    String align = null;
    String dir = null;
    String style = null;
    String cellAlign = null;
    String message = null;
    String lang, langCode, calenderTip, cancel, save, title, JOData, JONo, forEqp, task, complaint, entryTime, notes, add, delete, noComplaints, M, M2;
    String close, finish, forward, comment, bookmark;
    String complaintNo, customerName, complaintDate;
    int iTotal = 0;
    String viewD, scheduleCase, executionCase, onHoldCase, fontSize, issueNo, issueTit, equip, issueStatus, clientOperation;
    String sat, sun, mon, tue, wed, thu, fri, view;
    String codeStr, projectStr, distanceStr, deleteStr, responsibleStr;
    if (stat.equals("En")) {
        align = "center";
        dir = "LTR";
        style = "text-align:left";
        lang = "   &#1593;&#1585;&#1576;&#1610;    ";
        langCode = "Ar";
        cellAlign = "left";

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
    } else {
        align = "center";
        dir = "RTL";
        style = "text-align:Right";
        lang = "English";
        langCode = "En";
        cellAlign = "right";

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

    <!--<script type="text/javascript" src="js/jquery.chained.remote.min.js"></script>  -->
    <script type="text/javascript" src="js/wz_tooltip.js"></script>
    <script type="text/javascript" src="js/tip_balloon.js"></script>
    <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>


    <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/default/easyui.css">
    <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/icon.css">
    <link rel="stylesheet" type="text/css" href="jquery-easyui/demo/demo.css">
    <script type="text/javascript" src="jquery-easyui/easyloader.js"></script>
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
        var minDateS='<%=entryDate%>';
        $(function() {
            $("#closedEndDate,#finishEndDate").datetimepicker({
                changeMonth: true,
                changeYear: true,
                minDate: new Date(minDateS),
                maxDate: 0,
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
            $('#add_comm').bPopup({  easing: 'easeInOutSine', //uses jQuery easing plugin
                speed: 400,
                transition: 'slideDown'});
        }
        function showComments()
        {
            $(".submenux").hide();
            $(".button_commx").attr('id', '0');

            var url = "<%=context%>/ClientServlet?op=showComments&clientId=" + $("#clientCompId").val() + "&objectType=" + $("#businessObjectType2").val() + "&random=" + (new Date()).getTime();
            jQuery('#show_comm').load(url);
           
            $('#show_comm').css("display", "block");
            $('#show_comm').bPopup({  easing: 'easeInOutSine', //uses jQuery easing plugin
                speed: 400,
                transition: 'slideDown'});
 
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
            if (e.keyCode == 27) {   $("#report").window('close')}   // esc
        });
       
        function comp_Report(obj) {
       
            $.ajax({
                type: "post",
                url: "<%=context%>/ComplaintEmployeeServlet?op=compReport",
                data: {
                    issueId:<%=issueId%>,
                    compId:<%=clientCompId%>
                },
                success: function(jsonString) {
                    var info=$.parseJSON(jsonString);
                
                    if(info.isFinish){
                        $("#finish").show();
                    }else{
                        $("#finish").hide();
                    }
                    if(info.isClosed){
                        $("close").show();
                    }else{
                        $("#close").hide();
                    }
                    if(info.isAssigned){
                        $("#assign").show();
                    }else{
                        $("#assign").hide();
                    }
                    if(info.isAcknowledge){
                        $("#open").show();
                    }else{
                        $("#open").hide();
                    }
                    if(info.isFound){
                        $("#total").show();
                    }else{
                        $("#total").hide();
                    }
                    if(info.isRejected){
                        $("#rejected").show();
                    }else{
                        $("#rejected").hide();
                    }
                    $("#requestDate").text(info.requestDate);
                    $("#assignDate").text(info.assignDate);
                    $("#openDate").text(info.openDate);
                    $("#rejectedDate").text(info.rejectedDate);
                    $("#finishDate").text(info.finishDate);
                    $("#closeDate").text(info.closeDate);
                    $("#period").text(info.period);
                    $("#closedPeriod").text(info.closedPeriod);
                    $("#finishPeriod").text(info.finishPeriod);
                    $("#rejectedPeriod").text(info.rejectedPeriod);
                    $("#openPeriod").text(info.openPeriod);
                    $("#assignPeriod").text(info.assignPeriod);
                    $("#totalTime").text(info.totalTime);
                    $("#report").window('open');
                    
                    
                   
                }
            });

        }
        function notAllowed(obj){
       
            alert(obj);
        }
        function redirectComplaintToEmployee(obj) {
            //        alert('order');
            //        var comment = $(obj).parent().parent().find('#order').val();
            //        var userId = $(obj).parent().parent().find('#department option:selected').val();
            //            var notes = $(obj).parent().parent().parent().find('#notes').val();
            var empId = $("#department").val();
            var responsibleEmp= $("#department :selected").text();
          
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
                        $("#redirectMsg").css("color","red");
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
            $.ajax({
                type: "post",
                url: "<%=context%>/ComplaintEmployeeServlet?op=finishComp&issueId=<%=issueId%>&compId=<%=clientCompId%>",
                data: {
                    notes: notes,
                    clientId: <%=clientId%>,
                    endDate:endDate
                },
                success: function(jsonString) {
                  
                  

                    var info = $.parseJSON(jsonString);

                    if (info.status == 'ok') {
                        $("#finishMsg").show();
                        $(obj).removeAttr("onclick");
                      
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
            //            alert(endDate);
            $.ajax({
                type: "post",
                url: "<%=context%>/ComplaintEmployeeServlet?op=closeComp&issueId=<%=issueId%>&compId=<%=clientCompId%>",
                data: {
                    notes: notes,
                    clientId: <%=clientId%>,
                    endDate:endDate
                },
                success: function(jsonString) {
                  
                   

                    var info = $.parseJSON(jsonString);

                    if (info.status == 'ok') {
                        $("#closedMsg").show();
                        $(obj).removeAttr("onclick");
                    }
                    else {

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
                    endDate:endDate
                },
                success: function(jsonString) {
                  
                   

                    var info = $.parseJSON(jsonString);

                    if (info.status == 'ok') {
                        $("#rejectedMsg").html("تم الإلغاء بنجاح");
                        $("#rejectedMsg").show();
                        $(obj).removeAttr("onclick");
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
            var complaintComment = $("#complaintComment").val();
            //            alert(complaintComment);
            var compSubject = $("#compSubject").val();
            //            alert(compSubject)
            var responsible =1;
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


        function showClosedMessage(obj) {
            var compId=<%=clientCompId%>;
            $.ajax({
                type: "post",
                url: "<%=context%>/IssueServlet?op=showClosedMsg",
                data: {compId :compId},
                success: function(jsonString) {
                    var info = $.parseJSON(jsonString);

                    if (info.status == 'ok') {
                        var closedMsg=info.message;
                        $("#compNotes").val(closedMsg);
                        $("#compStatus").html($("#statusCode").val());
                        $("#compStatus").css("color","white");
                        //   $("#compStatus").css("background-color","red");
                        $("#showNotes").css("display", "block")
                        $("#showNotes").bPopup({  easing: 'easeInOutSine', //uses jQuery easing plugin
                            speed: 400,
                            transition: 'slideDown'});
                    }if(info.status == 'no'){
                        alert("لاتوجد ملاحظات إنهاء");   
                    }
                }
            });

        }
    
        function showFinishedMessage(obj) {
            var compId=<%=clientCompId%>;
            $.ajax({
                type: "post",
                url: "<%=context%>/IssueServlet?op=showFinishedMsg",
                data: {compId :compId},
                success: function(jsonString) {
                    var info = $.parseJSON(jsonString);

                    if (info.status == 'ok') {
                        var closedMsg=info.message;
                        $("#compNotes").val(closedMsg);
                        $("#compStatus").html($("#statusCode").val());
                        $("#compStatus").css("color","white");
                        //   $("#compStatus").css("background-color","red");
                        $("#showNotes").css("display", "block")
                        $("#showNotes").bPopup({  easing: 'easeInOutSine', //uses jQuery easing plugin
                            speed: 400,
                            transition: 'slideDown'});
                    }if(info.status == 'no'){
                        alert("لاتوجد ملاحظات إنهاء");   
                    }
                }
            });

        }
    
    
        function showRejectedMsg(obj) {
            var compId=<%=clientCompId%>;
            $.ajax({
                type: "post",
                url: "<%=context%>/IssueServlet?op=showRejectedMessage",
                data: {compId :compId},
                success: function(jsonString) {
                    var info = $.parseJSON(jsonString);
                    if (info.status == 'ok') {
                        var closedMsg=info.message;
                        $("#compNotes").val(closedMsg);
                        $("#compStatus").html($("#statusCode").val());
                        $("#compStatus").css("color","white");
                        $("#showNotes").css("display", "block")
                        $("#showNotes").bPopup({  easing: 'easeInOutSine', //uses jQuery easing plugin
                            speed: 400,
                            transition: 'slideDown'});
                    }if(info.status == 'no'){
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
                url: "<%=context%>/ClientServlet?op=saveComment",
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
            $('#closeNote').bPopup({  easing: 'easeInOutSine', //uses jQuery easing plugin
                speed: 400,
                transition: 'slideDown'});
         

        }
        function popupFinishO(obj) {
            $("#finishMsg").hide();
          
            $('#finishNote').find("#notes").val("");
            $('#finishNote').css("display", "block");
            $('#finishNote').bPopup({  easing: 'easeInOutSine', //uses jQuery easing plugin
                speed: 400,
                transition: 'slideDown'});
         

        }
        function rejectedComp(obj) {
            
            $('#rejectedNote').find("#notes").val("");
            $("#rejectedMsg").text("");
            $('#rejectedNote').css("display", "block");
            $('#rejectedNote').bPopup({  easing: 'easeInOutSine', //uses jQuery easing plugin
                speed: 400,
                transition: 'slideDown'});
         

        }
        function redirectComp(obj) {
            $("#redirectMsg").text("");
            $('#redirectComp').bPopup();
            $('#redirectComp').css("display", "block");

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
        width:128px;
        height:27px;
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
        width:132px;
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
    .rejectedBtn{
        width:145px;
        height:40px;
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
</style>
<body>
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


        <div style="display: none;width: 60%;margin-right: auto;margin-left: auto">
            <div id="report" class="easyui-window" data-options="modal:true,closed:true" title="مراحل الطلب" style="width:700px;height:auto;padding:10px;text-align: right;">

                <div style="padding:10px 0 10px 20px;">

                    <table style="width:100%;text-align: right;border: none;margin-bottom: 20px;" class="table" dir="rtl">
                        <thead>
                            <tr>
                                <td>مراحل الطلب</td>
                                <td>التوقيت</td>
                                <td style="width: 50%">المدة المنصرمة</td>

                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td style="width: 20%;"> <label style="width: 100px;"> التسجيل  </label></TD>
                                <td style="width: 30%;"><label id="requestDate"></label></TD>
                                <td style="width: 50%;"><label id="">-----</label></TD>
                            </TR>

                            <tr id="assign">
                                <td style="width: 20%;"> <label style="width: 100px;"> التوزيع  </label></TD>
                                <td style="width: 30%;"><label id="assignDate"></label></TD>
                                <td style="width: 50%;"><label id="assignPeriod"></label></TD>
                            </tr>
                            <tr id="open">
                                <td style="width: 20%;"> <label style="width: 100px;"> المتابعة  </label></TD>
                                <td style="width: 30%;"><label id="openDate"></label></TD>
                                <td style="width: 50%;"><label id="openPeriod"></label></TD>
                            </tr>
                            <tr id="finish">
                                <td style="width: 20%;"> <label style="width: 100px;">   الإنهاء </label></TD>
                                <td style="width: 30%;"><label id="finishDate"></label></TD>
                                <td style="width: 50%;"><label id="finishPeriod"></label></TD>
                            </TR>
                            <tr id="close">
                                <td style="width: 20%;"> <label style="width: 100px;"> الإغلاق </label></TD>
                                <td style="width: 30%;"><label id="closeDate"></label></TD>
                                <td style="width: 50%;"><label id="closedPeriod"></label></TD>

                            </TR>
                            <tr id="rejected">
                                <td style="width: 20%;"> <label style="width: 100px;"> الإلغاء </label></TD>
                                <td style="width: 30%;"><label id="rejectedDate"></label></TD>
                                <td style="width: 50%;"><label id="rejectedPeriod"></label></TD>

                            </TR>
                            <tr>
                                <td colspan="3">
                                    <hr style="width: 92%;"></TD>

                            </tr>
                            <tr id="total">
                                <td style="width: 20%;"><label>الوقت الكلى </label></TD>
                                <td style="width: 20%;"></TD>
                                <td style="width: 60%;text-align: center;"><label id="totalTime"></label></TD>
                            </tr>

                        </tbody>
                    </table>


                </div>

            </div>  
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
                    <tr>
                        <td colspan="2" >
                            <div style="margin: 0 auto;display: none; width: 90%;text-align: center;color: white" id="closedMsg">تم الإغلاق بنجاح</>
                        </td>
                    </tr>
                    </tr>
                </TABLE>
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
                        <td colspan="2" class="blueBorder blueHeaderTD" style="font-size:17px;">مركز الإتصال</td>
                    </tr>
                </table>
                <div id="showDiv"    style="width: 80% !important;margin-left: auto;margin-right: auto;display: none">
                    <div style="clear: both;margin-left: 89%;margin-top: 0px;margin-bottom: -15px;z-index: -10000000;">
                        <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;" onclick="closeDiv(this)"/>
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
                    <fieldset style="width:100%;padding: 10px;">
                        <legend style="color: #FF3300

                                ;">الطلب</legend>

                        <table width="100%"   dir="rtl" style="border-left:0px;" class="table">
                            <tr>
                                <td   style="color: #000;" class="excelentCell formInputTag"  >الحالة</td>

                                <td style="<%=style%>">
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
                                <td   style="color: #000;" class="excelentCell formInputTag"  >المدير</td>
                                <td style="<%=style%>">
                                    <%
                                        String managerName = "";
                                        managerName = (String) request.getAttribute("managerName");

                                    %>
                                    <%=managerName%>
                                </td>
                                <td   style="color: #000;" class="excelentCell formInputTag"  >الموظف المسئول</td>
                                <td style="<%=style%>" id="responsibleEmp">
                                    <%
                                        String receipName = "";
                                        receipName = (String) request.getAttribute("receipName");
                                    %>
                                    <%=receipName%>
                                </td>
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


                        </table>
                        <input type="button" id="compReport" value="مراحل الطلب" style="float: right;" onclick="comp_Report(this)"/>
                    </fieldset>

                </div>
                <!--<tr style="">-->
                <!--//         <td style="border-left: none;width: 35%;">-->
                <div style="width: 100%;">
                    <div style="width: 35%;float: right;display: block;">
                        <fieldset style="width:100%;padding: 10px;">
                            <legend style="color: #FF3300

                                    ;">بيانات المكالمة</legend>

                            <table width="100%"   dir="rtl" style="border-left:0px;" class="table">
                                <tr>
                                    <td  width="30%" style="color: #000;" class="excelentCell formInputTag"  >رقم المتابعة</td>

                                    <td style="<%=style%>">


                                        <b>
                                            <font color="red" size="3"><%=issueWbo.getAttribute("businessID")%></font>/<font color="blue" size="3" ><%=issueWbo.getAttribute("businessIDbyDate")%></font>


                                        </b>


                                    </td>

                                </tr>
                                <tr>
                                    <td width="30%"  style="color: #000;" class="excelentCell formInputTag"> نوع المكالمة</td>

                                    <td style="text-align:right;">
                                           <input name="call_status" type="radio" value="incoming" <%if (issueWbo.getAttribute(
                                                       "callType") != null && issueWbo.getAttribute("callType").toString().equals("incoming")) {%> checked <%}%>/>
                                        <label>واردة</label>
                                               <input name="call_status" type="radio" value="out_call" <%if (issueWbo.getAttribute(
                                                           "callType") != null && issueWbo.getAttribute("callType").toString().equals("out_call")) {%> checked <%}%>/>
                                        <label>صادرة</label>

                                </tr>
                                <tr>
                                    <td  style="color: #000;" class="excelentCell formInputTag" >تعليق مركز الإتصال </td>
                                    <td style="text-align:right;"><textarea rows="5" cols="10" style="width:100%;" resize="false" ><%=issueWbo.getAttribute("issueDesc")%></textarea></td>
                                </tr>

                            </table>
                        </fieldset>
                    </div>
                    <!--</td>-->
                    <!--<td  style="border-right: none;width: 50%;">-->
                    <% WebBusinessObject clientCompWbo = null;
                        String compType = "";
                        clientComplaintsMgr = ClientComplaintsMgr.getInstance();
                        clientCompWbo = clientComplaintsMgr.getOnSingleKey(clientCompId);
                        String comp_details = "";
                        if (clientCompWbo.getAttribute(
                                "ticketType").toString().equals("1")) {
                            compType = " الشكوى";
                            comp_details = "تفاصيل الشكوى";
                        } else if (clientCompWbo.getAttribute(
                                "ticketType").toString().equals("2")) {
                            compType = " الطلب";
                            comp_details = "تفاصيل الطلب";
                        } else if (clientCompWbo.getAttribute(
                                "ticketType").toString().equals("3")) {
                            compType = " الإستعلام";
                            comp_details = "تفاصيل الشكوى";
                        }
                        WebBusinessObject wbo = new WebBusinessObject();
                        if (clientCompVector != null && !clientCompVector.isEmpty()) {
                            wbo = clientCompVector.get(0);
                    %>
                    <div style="width: 60%;display: block;float: left;" id="section">
                        <fieldset style="width: 100%;padding: 10px;padding-left: 0px !important;" >
                            <legend style="color: #FF3300

                                    ;"><%=compType%></legend>

                            <div style="width: 65%;float: right;">
                                <table border="1px" width="100%" class="table" align="right" style="float: right;margin: 0px !important;">

                                    <tr>
                                        <td  style="color: #000;" class="excelentCell formInputTag" >كود <%=compType%></td>
                                        <td style="text-align:right;">

                                            <b>
                                                <font color="blue" size="3" ><%=wbo.getAttribute("businessCompId")%></font>
                                            </b>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td  style="color: #000;" class="excelentCell formInputTag" >عنوان <%=compType%></td>
                                        <td style="text-align:right;">

                                            <b style="">
                                                <font color="green"  size="3" ><%=wbo.getAttribute("compSubject")%></font>
                                            </b>
                                        </td>
                                    </tr>
                                    <tr>


                                        <TD style="color: #000;" class="excelentCell formInputTag"><b><%=compType%></b></TD>


                                        <% String sCompl = " ";

                                            if (wbo.getAttribute(
                                                    "comments") != null && !wbo.getAttribute("comments").equals("")) {
                                                sCompl = (String) wbo.getAttribute("comments");

                                                //sCompl = sCompl.substring(0,23) + "....";
%>
                                        <TD style="text-align:right;width: 60%;"><textarea rows="5" cols="10" style="width:100%;" resize="false" id="complaintComment"><%=sCompl%></textarea></TD>
                                    <input type="hidden" id="compSubject" value="<%=wbo.getAttribute("compSubject")%>" />

                                    <% }%>

                                    </tr>
                                    <!--                    <tr>
                                                            <td  style="color: #000;" class="excelentCell formInputTag" >المرسل</td>
                                                            <td style="text-align:right;">
                                    
                                                                <b>
                                                                    <font color="blue" size="3" ><%=wbo.getAttribute("fullName")%></font>
                                                                </b>
                                                            </td>
                                                        </tr>
                                    -->

                                </table>
                            </div>
                            <div style="margin-right: 69%;" id="cc">
                                <div style="width:1%;border-left: solid #999 1px;float: right;" id="line"></div>

                                <div style="width:98%;margin-right:auto;margin-top: auto;">
                                    <%

                                        String userId = (String) userWbo.getAttribute("userId");
                                        UserMgr um = UserMgr.getInstance();
                                        ArrayList<WebBusinessObject> prvType = new ArrayList();
                                        prvType = securityUser.getComplaintMenuBtn();
                                        String statusCode = (String) wbo.getAttribute("statusCode");%>
                                    <input type="hidden" id="statusCode" value="<%=statusCode%>" name="statusCode"/>
                                    <input type="hidden" id="status_code" value="<%=statusCode%>" name="statusCode"/>
                                    <%   if (prvType.size() > 0) {

                                            for (int i = 0; i < prvType.size(); i++) {
                                                wbo = new WebBusinessObject();
                                                wbo = prvType.get(i);
                                                String userPrevName = (String) wbo.getAttribute("prevCode");

                                                CrmIssueStatus crmIssueStatus = new CrmIssueStatus();
                                    %>



                                    <%
                                        //  if (um.getAction(userPrevName, userId)) {
                                        if (userPrevName.equals("CLOSE")) {
                                    %>
                                    <% if (crmIssueStatus.canClose(clientCompId) & !crmIssueStatus.canFinish(clientCompId)) {%>

                                    <div style="margin-right: auto;margin-left: auto;"><input type="button"  onclick="popupCloseO(this);" class="button_clos"></div>
                                        <% } else if (!crmIssueStatus.canClose(clientCompId)) {%>
                                    <div style="margin-right: auto;margin-left: auto;"><input type="button"  onclick="notAllowed('تم الإغلاق مسبقا')" class="button_clos"></div>

                                    <% } else {%>
                                    <div style="margin-right: auto;margin-left: auto;"><input type="button"  onclick="notAllowed('قم بالإنهاء أولا ثم الإغلاق')" class="button_clos"></div>
                                        <%}%>
                                        <% } else if (userPrevName.equals("COMMENT")) {%>
                                    <!--          <div style="margin-right: auto;margin-left: auto;"> 
                                                  
                                                  <input type="button" onclick="JavaScript: getComment();" class="button_comm" >
                                              
                                              
                                              
                                              </div>-->
                                    <div class="dropdown" style="width:50%;display: inline-table;margin-left: auto;margin-right: auto;">
                                        <a class="button_commx" ></a>

                                        <div class="submenux">
                                            <ul class="root">
                                                <li ><a href="#" style="text-align: right"  onclick="JavaScript:getComment();">إضافة تعليق</a></li>
                                                <li ><a href="#" style="text-align: right" onclick="showComments(this)">مشاهدة التعليقات</a></li>

                                            </ul>
                                        </div>

                                    </div>    
                                    <%  } else if (userPrevName.equals("FORWARD")) {%>
                                    <% if (crmIssueStatus.canAssign(clientCompId)) {%>

                                    <div style="margin-right: auto;margin-left: auto;"> <input type="button"  onclick="return getDataInPopup('ComplaintEmployeeServlet?op=getEmpByGroup&formName=CLIENT_COMPLAINT_FORM&selectionType=multi&complaintId=' + $('#complaintId').val())"
                                                                                               class="button_redirec"></div>  
                                        <% } else {%>
                                    <div style="margin-right: auto;margin-left: auto;"><input type="button"  onclick="notAllowed('تم التوزيع مسبقا')"  class="button_redirec"></div>  
                                        <%}
                                        } else if (userPrevName.equals("FINISHED")) {
                                            if (crmIssueStatus.canFinish(clientCompId)) {%>


                                    <div style="margin-right: auto;margin-left: auto;"> <input type="button"  onclick="popupFinishO(this);" class="button_finis"></div>
                                        <%} else {%>
                                    <div style="margin-right: auto;margin-left: auto;"> <input type="button"  onclick="notAllowed(' تم الإنهاء مسبقا')" class="button_finis"></div>
                                        <%  }
                                        } else if (userPrevName.equals("BOOKMARK")) {%>
                                    <div style="margin-right: auto;margin-left: auto;"> <input type="button"  onclick="" class="button_bookmar"></div>
                                        <%  } else if (userPrevName.equals("ASSIGN")) {

                                            int w = 0;
                                            int x = 1;
                                            int y = 2;
                                            int z = 3;
                                        %>
                                        <% if (crmIssueStatus.canRedirectOrderToAnotherEmployee(clientCompId) == z) {%>
                                    <div style="margin-right: auto;margin-left: auto;">   <input type="button"  onclick="redirectComp(this)" class="managerBt"></div>

                                    <%} else if (crmIssueStatus.canRedirectOrderToAnotherEmployee(clientCompId) == x) {%>

                                    <div style="margin-right: auto;margin-left: auto;">   <input type="button"  onclick="notAllowed('الطلب مع الموظف المختص')" class="managerBt"></div>

                                    <%} else if (crmIssueStatus.canRedirectOrderToAnotherEmployee(clientCompId) == y) {%>

                                    <div style="margin-right: auto;margin-left: auto;">   <input type="button"  onclick="notAllowed('تم التعامل مع الطلب من قبل')" class="managerBt"></div>

                                    <%} else if (crmIssueStatus.canRedirectOrderToAnotherEmployee(clientCompId) == w) {%>

                                    <div style="margin-right: auto;margin-left: auto;">   <input type="button"  onclick="notAllowed('الطلب لم يتم توزيعة وبالتالى لا يمكن تحويلة')" class="managerBt"></div>
                                        <% } else {
                                            }%>

                                    <%            }
                                        }%>

                                    <div style="margin-right: auto;margin-left: auto;">   <input type="button"  onclick="rejectedComp(this)"  class="rejectedBtn"/></div>
                                        <%
                                            //   }
                                        } else {%>
                                    <b>لاتوجد صلاحيات من فضلك الإتصال بالمدير لتعين الصلاحيات الخاصة بك</b>
                                    <%}%>
                                </div>
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
            <%} catch (Exception ex) {%>
            <%
                    out.println(ex.getMessage());

                }%>
            <!--  </div>-->


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

        <div id="show_comm"   style="width: 50% !important;display: none;position: fixed ;">

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
