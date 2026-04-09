<%@page import="java.text.DateFormat"%>
<%@page import="com.maintenance.common.UserPrev"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page import="com.silkworm.business_objects.*,com.maintenance.db_access.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.tracker.db_access.*,com.tracker.db_access.IssueMgr"%>
<%@page pageEncoding="UTF-8" %>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld"%> 

<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();

    Calendar cal = Calendar.getInstance();
    String timeFormat = "yyyy/MM/dd hh:mm";
    SimpleDateFormat sdf = new SimpleDateFormat(timeFormat);
    String nowTime = sdf.format(cal.getTime());

    String issueId = (String) request.getParameter("issueId");
    IssueMgr issueMgr = IssueMgr.getInstance();
    WebBusinessObject issueWbo = (WebBusinessObject) issueMgr.getOnSingleKey(issueId);

    IssueByComplaintMgr issueByComplaintMgr = IssueByComplaintMgr.getInstance();
    Vector<WebBusinessObject> clientCompVector = new Vector();
    String clientCompId = (String) request.getAttribute("compId");
    clientCompVector = issueByComplaintMgr.getOnArbitraryKey(request.getParameter("compId").toString(), "key5");
    String complaintId = (String) request.getAttribute("complaintId");

    Vector products = (Vector) request.getAttribute("products");


//    String call_status = (String) issueWbo.getAttribute("callType");
//    String entryDate = (String) issueWbo.getAttribute("currentStatusSince");
//
//    Vector<WebBusinessObject> clientCompVector = new Vector();
//    IssueByComplaintMgr issueByComplaintMgr = IssueByComplaintMgr.getInstance();
//    WebBusinessObject userWbo1 = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
//    clientCompVector = issueByComplaintMgr.getOnArbitraryKey(userWbo1.getAttribute("clientComId").toString(), "key5");


//    if (call_status == null) {
//        call_status = "";
//
//    }


//    ProjectMgr projectMgr = ProjectMgr.getInstance();
//    ArrayList complaintList = projectMgr.getSubProjectsByCode("cmp");

    String context = metaMgr.getContext();

//Get request data



//    Vector DepComp = (Vector) request.getAttribute("DepComp");



//    String filterName = (String) request.getAttribute("filterName");
//    String filterValue = (String) request.getAttribute("filterValue");

    WebBusinessObject client = (WebBusinessObject) request.getAttribute("client");
//    String status = (String) request.getAttribute("status");
    Boolean isChecked = false;

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
    String viewD, scheduleCase, executionCase, onHoldCase, fontSize, issueNo, issueTit, equip, issueStatus;
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
    }

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



%>

<link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css">
<script type="text/javascript" src="jquery-ui/jquery-1.7.1.js"></script>
<script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
<script type="text/javascript" src="jquery-ui/ui/jquery.effects.core.js"></script>
<script type="text/javascript" src="jquery-ui/ui/jquery.ui.widget.js"></script>
<script type="text/javascript" src="jquery-ui/ui/jquery.effects.drop.js"></script>
<script type="text/javascript" src="jquery-ui/ui/jquery.effects.fold.js"></script>
<script type="text/javascript" src="jquery-ui/ui/jquery.ui.mouse.js"></script>
<script type="text/javascript" src="jquery-ui/ui/jquery.ui.slider.js"></script>
<script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
<script type="text/javascript" src="jquery-ui/ui/jquery.ui.dialog.js"></script>
<script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>
<script type="text/javascript" src="js/jquery.chained.remote.min.js"></script>  
<script type="text/javascript" src="js/wz_tooltip.js"></script>
<script type="text/javascript" src="js/tip_balloon.js"></script>
<script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
<style>
    .show{
        display: block;
    }
    .hide{
        display: none;
    }
</style>
<script type="text/javascript">


    (function($) {

        // DOM Ready
        $(function() {

            // Binding a click event
            // From jQuery v.1.7.0 use .on() instead of .bind()

            $('#email').bind('click', function(e) {

                // Prevents the default action to be triggered. 
                e.preventDefault();
//               /  $('#email_content').dialog();
                $('#email_content').bPopup();
            });
            $('#sms').bind('click', function(e) {

                // Prevents the default action to be triggered. 
                e.preventDefault();

                $('#sms_content').bPopup();
            });
            $('#attach_file').click(function() {
                $('#file').start;
            })
//              $('#email').click(function(){
//                   
//                   $('#email_content').dialog();
//              })

        });

    })(jQuery);
    function openWindowTasks(url)
    {

        window.open(url, "_blank", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=no, copyhistory=no,width=800,height=450");
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
        var complaintId = $("#complaintId").val();
        var empIdArr = $('input[name=empId]');
        var empId = $(empIdArr[x - 1]).val();
        var commentsArr = $('input[name=comments]');
        var comments = $(commentsArr[x - 1]).val();
        var responsibleArr = $('select[name=responsible]');

        var responsible = $(responsibleArr[x - 1]).val();
        //alert('res= '+responsible);
        $("#save" + x).html("<img src='images/icons/spinner.gif'/>");

        $.ajax({
            type: "post",
            url: "<%=context%>/ComplaintEmployeeServlet?op=saveComplaintEmployee",
            data: {complaintId: complaintId,
                empId: empId,
                comments: comments,
                responsible: responsible},
            success: function(jsonString) {
                var eqpEmpInfo = $.parseJSON(jsonString);

                if (eqpEmpInfo.status == 'Ok') {

                    $("#save" + x).html("");
                    $("#save" + x).css("background-position", "top");
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
        document.CLIENT_COMPLAINT_FORM.action = "";
        document.CLIENT_COMPLAINT_FORM.submit();
        $("#sms_content").css("dispaly","none");
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

    function remove(obj) {

        $(obj).parent().parent().remove();
    }

</script>


<script src='ChangeLang.js' type='text/javascript'></script>
<!DOCTYPE html>


<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Expires" CONTENT="0">

<HEAD>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Untitled Document</title>
    <link href="css/bootstrap.min.css" rel="stylesheet" media="screen">
    <!--<script src="js/jquery.js"></script>-->
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
        height:20px;
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


    #call_center{
        direction:rtl;
        padding:0px;
        margin-top: 10px;
        /*background-color: #dedede;*/
        /*        margin-left: auto;
                margin-right: auto;*/
        margin-bottom: 5px;
        /*color:#005599;*/
        /*            height:600px;*/
        width:100%;
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
    .button_comment {
        width:152px;
        height:45px;
        margin: 4px;
        background-repeat: no-repeat;
        cursor: pointer;
        border: none;
        background-position: right top ;
        display: inline-block;
        background-color: transparent;
        background-image:url(images/buttons/comment.png);
    }

    .button_notes {
        width:152px;
        height:45px;
        margin: 4px;
        background-repeat: no-repeat;
        cursor: pointer;
        border: none;
        background-position: right top ;
        display: inline-block;
        background-color: transparent;
        background-image:url(images/buttons/notes.png);
    }

    .button_attached {
        width:152px;
        height:45px;
        margin: 4px;
        background-repeat: no-repeat;
        cursor: pointer;
        border: none;
        background-position: right top ;
        display: inline-block;
        background-color: transparent;
        background-image:url(images/buttons/send_file.png);
    }

    .button_sms {
        width:152px;
        height:45px;
        margin: 4px;
        background-repeat: no-repeat;
        cursor: pointer;
        border: none;
        background-position: right top ;
        display: inline-block;
        background-color: transparent;
        background-image:url(images/buttons/sms.png);
    }

    .button_email {
        width:152px;
        height:45px;
        margin: 4px;
        background-repeat: no-repeat;
        cursor: pointer;
        border: none;
        background-position: right top ;
        display: inline-block;
        background-color: transparent;
        background-image:url(images/buttons/email.png);
    }
    #attach_file{
        width:32px;
        height:32px;
        margin: 4px;
        background-repeat: no-repeat;

        border: none;


        background-color: transparent;
        background-image:url(images/buttons/attach-file.png);
    }
    .popup_content{ 

        border: none;

        direction:rtl;
        padding:0px;
        margin-top: 10px;
        background-color: #dfdfdf;
        margin-bottom: 5px;
        width: 300px;
        height: 300px;
        /*position:absolute;*/
        border:1px solid #f1f1f1;
        font:Verdana, Geneva, sans-serif;
        font-size:18px;
        font-weight:bold;
        display: none;
    }

</style>
<body>
    <FORM NAME="CLIENT_COMPLAINT_FORM" METHOD="POST">
        <input type="hidden" id="clientId" name="clientId" value="<%=clientId%>"/>

        <!--<button onclick="JavaScript: submitForm();" class="button_comment" style="border: none;" >-->

        <!--</button>-->
        <DIV align="left" STYLE="color:blue;margin-bottom: 30px;background-color: #f1f1f1;width: 975px;margin-top:15px;">


            <% if (userPrevObj.getFinish()) {%>
            <input type="button"  onclick="" class="button_notes" id="notes">
            <%}%>
            &ensp;
            <% if (userPrevObj.getForward()) {%>
            <input type="button"  onclick="" class="button_attached" id="attached">
            <%}%>
            &ensp;
            <% if (userPrevObj.getComment()) {%>
            <input type="button" onclick="" class="button_sms" id="sms">
            <%}%>
            &ensp;
            <% if (userPrevObj.getBookmark()) {%>

            &ensp;
            <%}%>
            <input type="button"  class="button_email" id="email">
        </DIV>

        <br/><br/>


        <br/><br/>


        <div  id="call_center" class="show">

            <!--                <table border="1px" style="width: 96%;" >
                                <td style="width: 46%;border: none;">-->
            <div style="width: 98%;">
                <div style="float: right;width: 33%;">
                    <table align="right" width="100%" class="table" style="background: #f9f9f9;">
                        <tr align="center" style="height: 10px;">
                            <td colspan="2"  class="blueBorder blueHeaderTD" style="font-size:18px;">بيانات العميل</td>
                        </tr>
                        <tr>
                            <td style="color: #000;" class="excelentCell formInputTag" width="30%" >اسم العميل</td>
                            <td style="text-align:right;background: #f1f1f1;"><label><%=client.getAttribute("name").toString()%></label></td>
                        </tr>

                        <tr>
                            <td style="color: #000;"class="excelentCell formInputTag" >النوع</td>
                            <td style="text-align:right;background: #f1f1f1;"><label><%=client.getAttribute("gender").toString()%></label></td>
                        </tr>
                        <tr>
                            <td style="color: #000;"class="excelentCell formInputTag" >الحالة الإجتماعية</td>
                            <td style="text-align:right;background: #f1f1f1;"><label><%=client.getAttribute("matiralStatus").toString()%></label></td>
                        </tr>
                        <tr>
                            <td style="color: #000;" class="excelentCell formInputTag"width="30%" >الرقم القومى</td>
                            <td style="text-align:right;background: #f1f1f1;"><label><%=client.getAttribute("clientSsn").toString()%></label></td>
                        </tr>
                        <tr>
                            <td style="color: #000;" class="excelentCell formInputTag">رقم التليفون</td>
                            <td style="text-align:right;background: #f1f1f1;"><label><%=client.getAttribute("phone").toString()%></label></td>
                        </tr>

                        <tr>
                            <td style="color: #000;" class="excelentCell formInputTag" width="30%" >رقم الموبايل</td>
                            <td style="text-align:right;background: #f1f1f1;"><label><%=client.getAttribute("mobile").toString()%></label></td>
                        </tr>
                        <tr>
                            <td style="color: #000;" class="excelentCell formInputTag" width="30%" >العنوان</td>
                            <td style="text-align:right;background: #f1f1f1;"><label><%=client.getAttribute("address").toString()%></label></td>
                        </tr>
                        <tr>
                            <td style="color: #000;" class="excelentCell formInputTag" width="30%" >الدخل الإجمالى</td>
                            <td style="text-align:right;background: #f1f1f1;"><label><%=client.getAttribute("salary").toString()%></label></td>
                        </tr>

                        <tr>
                            <td style="color: #000;" class="excelentCell formInputTag" width="30%" >البريد الإلكترونى</td>
                            <td style="text-align:right;background: #f1f1f1;"><label><%=client.getAttribute("email").toString()%></label></td>
                        </tr>


                    </table>
                </div>
                <!--                </td>
                                <td style="width: 46%;text-align: right;margin-right: 54%;border: none;">-->
                <div style="margin-right:36%;width: 100%;">
                    <table align="right" border="1px"  style="width: 100%;" class="table">
                        <tr align="center" align="center">
                            <td colspan="2"  class="blueBorder blueHeaderTD" style="font-size:18px;">بيانات الوحدات</td>
                        </tr>
                    </table>
                </div>
                <div style="margin-right:36%;width: 100%;">

                    <fieldset>
                        <legend style="color: #009933">المشتريات</legend>
                        <TABLE id="tblData" class="blueBorder" ALIGN="center" dir="<%=dir%>" width="100%" cellpadding="0" cellspacing="0">
                            <TR>

                                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="30%" ><b>المستعرة</b></TD>
                                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="30%" id="empNameShown" value=""><b>التصنيف</b></TD>
                                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="10%"><b>سعر الشراء</b></TD>
                                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="10%"><b>نظام الدفع</b></TD>
                                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="10%"><b>الفترة</b></TD>
                                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="10%"><b>تاريخ الشراء</b></TD>
                            </TR>

                        </TABLE>
                    </fieldset>
                </div>
                <%if (products != null && !products.isEmpty()) {
                %>

                <div style="margin-right:36%;width: 100%;display: block;margin-top: 10px;" id="tblDataDiv">
                    <fieldset>
                        <legend style="color: #FF3300
                                ;">الرغبات</legend>
                        <TABLE id="tblData" class="blueBorder" ALIGN="center" dir="<%=dir%>" width="100%" cellpadding="0" cellspacing="0">
                            <TR>

                                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="30%" ><b>المنتج</b></TD>
                                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="30%" id="empNameShown" value=""><b>الفئة</b></TD>
                                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="10%"><b>الميزانية</b></TD>
                                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="10%"><b>نظام الدفع</b></TD>
                                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="10%"><b>الفترة</b></TD>
                                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="10%"><b>وقت الطلب</b></TD>
                            </TR>
                            <%

                                Enumeration e = products.elements();

                                WebBusinessObject wbo = new WebBusinessObject();
                                while (e.hasMoreElements()) {

                                    wbo = (WebBusinessObject) e.nextElement();
                            %>
                            <TR style="padding: 1px;">


                                <TD style="text-align:right;background: #f1f1f1;font-size: 14px;">

                                    <%if (wbo.getAttribute("productName") != null) {%>
                                    <b><%=wbo.getAttribute("productName")%></b>
                                    <%}%>

                                </TD>
                                <TD style="text-align:right;background: #f1f1f1;font-size: 14px;width: 13%;">

                                    <%if (wbo.getAttribute("productCategoryName") != null) {%>
                                    <b><%=wbo.getAttribute("productCategoryName")%></b>
                                    <%}
                                    %>

                                </TD>

                                <TD style="text-align:center;background: #f1f1f1;font-size: 14px;">

                                    <%if (wbo.getAttribute("budget") != null) {%>
                                    <b><%=wbo.getAttribute("budget")%></b>
                                    <%}%>

                                </TD>
                                <TD style="text-align:center;background: #f1f1f1;font-size: 14px;">

                                    <%if (wbo.getAttribute("paymentSystem") != null) {%>
                                    <b><%=wbo.getAttribute("paymentSystem")%></b>
                                    <%}%>

                                </TD>
                                <TD style="text-align:center;background: #f1f1f1;font-size: 14px;">

                                    <%if (wbo.getAttribute("period") != null) {%>
                                    <b><%=wbo.getAttribute("period")%></b>
                                    <%}%>

                                </TD>
                                <TD style="text-align:right;background: #f1f1f1;font-size: 14px;">

                                    <%if (wbo.getAttribute("creationTime") != null) {%>
                                    <b><%=wbo.getAttribute("creationTime")%></b>
                                    <%}%>

                                </TD>


                            </TR>


                            <%

                                }

                            %>
                        </TABLE>
                    </fieldset>
                </div>

                <% }%>   

            </div>
            <!--
                            </td>
            
                            </table>-->
            <div style="clear:both"></div>

        </div>
        <div id="email_content" class="popup_content">
            <!--<form name="email_form">-->
            <table align="right" border="0px"  style="width:300px;" class="table" >

                <tr align="center" align="center">
                    <td colspan="2"  class="blueBorder blueHeaderTD" style="font-size:18px;">رسالة جديدة</td>
                </tr>
                <tr>
                    <td width="30%" style="color: #000;border: none;" class="excelentCell formInputTag">إلى</td>
                    <td width="70%" style="text-align:right;background: #f1f1f1"><input type="text" width="100%;" value="<%=client.getAttribute("email").toString()%>" /></td>
                </tr>
                <tr>
                    <td width="30%" style="color: #000;" class="excelentCell formInputTag">الموضوع</td>
                    <td width="70%"style="text-align:right;background: #f1f1f1"><input type="text" width="100%" /></td>
                </tr>
                <tr>

                    <td width="100%" colspan="2"style="color: #000;" class="excelentCell formInputTag"> 
                        <textarea cols="40" rows="10" style="overflow: hidden;"></textarea>
                    </td>

                </tr>
                <tr>
                    <td><lable>إرفاق ملف</lable></td>
                <td  style="color: #000;" class="excelentCell formInputTag"> 
                    <input type="file" value="إرفاق ملف" style="float: right;font-size: 12px;" id="file"/>



                </td>

                </tr>
                <tr>
                    <td colspan="2" style="color: #000;" class="excelentCell formInputTag"> 

                        <input type="submit" value="إرسال" />



                    </td>

                </tr>
            </table>

            <!--            </form>-->
        </div>    
        <div id="sms_content" class="popup_content" >
            <!--<form name="email_form">-->

            <table align="right" border="0px"  style="width:300px;" class="table" >
                <tr align="center" align="center">
                    <td colspan="2"  class="blueBorder blueHeaderTD" style="font-size:18px;">رسالة قصيرة</td>
                </tr>
                <tr>
                    <td width="30%" style="color: #000;border: none;" class="excelentCell formInputTag">إلى</td>
                    <td width="70%" style="text-align:right;background: #f1f1f1"><input type="text" width="100%;" value="<%=client.getAttribute("name").toString()%>" /></td>
                </tr>
                <tr>
                    <td width="30%" style="color: #000;" class="excelentCell formInputTag">رقم الموبايل</td>
                    <td width="70%"style="text-align:right;background: #f1f1f1"><input type="text" width="100%" value="<%=client.getAttribute("mobile").toString()%>" /></td>
                </tr>
                <tr>

                    <td width="100%" colspan="2"style="color: #000;" class="excelentCell formInputTag"> 
                        <textarea cols="40" rows="10" style="overflow: hidden;"></textarea>
                    </td>

                </tr>
                <tr>
                    <td colspan="2" style="color: #000;" class="excelentCell formInputTag"> 
                        <input type="button" value="إرسال" onclick="javascript: submitForm(this)"/>
                    </td>

                </tr>
            </table>

            <!--            </form>-->
        </div>  

    </FORM>
</body>
</html>
