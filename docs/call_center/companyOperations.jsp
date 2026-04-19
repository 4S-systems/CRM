

<%@page import="com.clients.db_access.CustomerGradesMgr"%>
<%--<%@page import="sun.org.mozilla.javascript.internal.regexp.SubString"%>--%>
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
    String entry_Date = (String) request.getAttribute("entryDate");
    MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
    String connectByRealEstate = metaDataMgr.getConnectByRealEstate();
    Calendar cal = Calendar.getInstance();
    String timeFormat = "yyyy/MM/dd HH:mm";
    SimpleDateFormat sdf = new SimpleDateFormat(timeFormat);
    String nowTime = sdf.format(cal.getTime());
//    String status = (String) request.getAttribute("status");
    String issueId = (String) request.getAttribute("issueId");
    IssueMgr issueMgr = IssueMgr.getInstance();
    WebBusinessObject issueWbo = (WebBusinessObject) issueMgr.getOnSingleKey(issueId);

//    IssueByComplaintMgr issueByComplaintMgr = IssueByComplaintMgr.getInstance();
//    Vector<WebBusinessObject> clientCompVector = new Vector();
//    String clientCompId = (String) request.getParameter("compId");
//    clientCompVector = issueByComplaintMgr.getOnArbitraryKey(request.getParameter("compId").toString(), "key5");
//    String complaintId = (String) request.getAttribute("complaintId");

    Vector<WebBusinessObject> mainCatsTypes = new Vector();
    mainCatsTypes = (Vector) request.getAttribute("data");

    Vector products = (Vector) request.getAttribute("products");
    Vector reservedUnit = (Vector) request.getAttribute("reservedUnit");

//    String call_status = (String) issueWbo.getAttribute("callType");
//    String entryDate = (String) issueWbo.getAttribute("currentStatusSince");

//    Vector<WebBusinessObject> clientCompVector = new Vector();
//    IssueByComplaintMgr issueByComplaintMgr = IssueByComplaintMgr.getInstance();
//    WebBusinessObject userWbo1 = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
//    clientCompVector = issueByComplaintMgr.getOnArbitraryKey(userWbo1.getAttribute("clientComId").toString(), "key5");
    UserMgr userMgr = UserMgr.getInstance();
    WebBusinessObject wbo = new WebBusinessObject();
    Vector<WebBusinessObject> CompetentEmp = new Vector();
    CompetentEmp = (Vector) request.getAttribute("CompetentEmp");
    CustomerGradesMgr customerGradesMgr = CustomerGradesMgr.getInstance();

    ArrayList allGrades = customerGradesMgr.getGrades();
    WebBusinessObject customerGrade = new WebBusinessObject();
    ProjectMgr projectMgr = ProjectMgr.getInstance();
    ArrayList complaintList = projectMgr.getSubProjectsByCode("cmp");

    String context = metaMgr.getContext();

//Get request data



//    Vector DepComp = (Vector) request.getAttribute("DepComp");



    String filterName = (String) request.getAttribute("filterName");
    String filterValue = (String) request.getAttribute("filterValue");

    WebBusinessObject client = (WebBusinessObject) request.getAttribute("client");
    String clientStatus = "";
    if (client.getAttribute("currentStatus") != null) {
        clientStatus = (String) client.getAttribute("currentStatus");
    }
    String reservationDateStr = nowTime.substring(0, nowTime.indexOf(" ")).replaceAll("/", "-");
    
    Boolean isCstatushecked = false;

    TradeMgr tradeMgr = TradeMgr.getInstance();
    Vector<WebBusinessObject> jobs = new Vector();

    jobs = tradeMgr.getOnArbitraryKey("1", "key3");

    String issueDesc = "";
    if (issueWbo != null) {
        issueDesc = (String) issueWbo.getAttribute("issueDesc");
    }

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
    String sat, sun, mon, tue, wed, thu, fri, view, gradeName;
    String codeStr, projectStr, distanceStr, deleteStr, responsibleStr, unit, search;
    if (stat.equals("En")) {
        align = "center";
        dir = "LTR";
        style = "text-align:left";
        lang = "   &#1593;&#1585;&#1576;&#1610;    ";
        langCode = "Ar";
        cellAlign = "left";
        unit = "unit";
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
        gradeName = "EN-DES";
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
        search = "Search";
    } else {
        align = "center";
        dir = "RTL";
        style = "text-align:Right";
        lang = "English";
        langCode = "En";
        gradeName = "AR-DES";
        cellAlign = "right";
        unit = "&#1573;&#1587;&#1605; &#1575;&#1604;&#1608;&#1581;&#1583;&#1577;";
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
        search = "بحث";
    }

    //String prevType ="1";
    // String clientId = (String) request.getAttribute("clientId");
    WebBusinessObject userWbo = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
    SecurityUser securityUser = (SecurityUser) session.getAttribute("securityUser");
    ArrayList<WebBusinessObject> prvType = new ArrayList();
    prvType = securityUser.getComplaintMenuBtn();
    ArrayList<String> privilegesList = new ArrayList<>();
    for (WebBusinessObject wboTemp : prvType) {
        if (wboTemp != null && wboTemp.getAttribute("prevCode") != null) {
            privilegesList.add((String) wboTemp.getAttribute("prevCode"));
        }
    }
    
    BookmarkMgr bookmarkMgr = BookmarkMgr.getInstance();
    
    Vector bookmarksList = bookmarkMgr.getOnArbitraryDoubleKeyOracle((String) client.getAttribute("id"), "key1", (String) userWbo.getAttribute("userId"), "key2");
    String bookmarkId = "";
    String bookmarkDetails = "";
    if(bookmarksList != null && bookmarksList.size() > 0){
        bookmarkId = (String) ((WebBusinessObject) bookmarksList.get(0)).getAttribute("bookmarkId");
        bookmarkDetails = (String) ((WebBusinessObject) bookmarksList.get(0)).getAttribute("bookmarkText");
    }
    
    UserStoresMgr userStoresMgr = UserStoresMgr.getInstance();
    GroupPrevMgr groupPrevMgr = GroupPrevMgr.getInstance();
    Vector groupPrev = new Vector();
    String dd = (String) userWbo.getAttribute("groupID");
    groupPrev = groupPrevMgr.getOnArbitraryKey(userWbo.getAttribute("groupID").toString(), "key1");
    // Vector userPrev = new Vector();
    //userPrev = userStoresMgr.getOnArbitraryKey(userWbo.getAttribute("userId").toString(), "key1");
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
    } //else {
    //  for (int x = 0; x < userPrev.size(); x++) {
    //      userPrevWbo = new WebBusinessObject();
    //      userPrevWbo = (WebBusinessObject) userPrev.get(x);
    //      if (userPrevWbo.getAttribute("prevCode").equals("COMMENT")) {
    //          userPrevObj.setComment(true);
    //    } else if (userPrevWbo.getAttribute("prevCode").equals("FORWARD")) {
    //        userPrevObj.setForward(true);
    //      } else if (userPrevWbo.getAttribute("prevCode").equals("CLOSE")) {
    //         userPrevObj.setClose(true);
    //      } else if (userPrevWbo.getAttribute("prevCode").equals("FINISHED")) {
    //          userPrevObj.setFinish(true);
    //       } else if (userPrevWbo.getAttribute("prevCode").equals("BOOKMARK")) {
    //           userPrevObj.setBookmark(true);
    //       }
    //    }
    // }



%>





<script src='ChangeLang.js' type='text/javascript'></script>
<!DOCTYPE html>


<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Expires" CONTENT="0">

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Untitled Document</title>
    <script src='ChangeLang.js' type='text/javascript'></script>

    <script src='ChangeLang.js' type='text/javascript'></script>

    <link rel="StyleSheet" href="treemenu/css/dtree.css" type="text/css" />
    <link rel="stylesheet" type="text/css" href="treemenu/page_style.css" />
    <!--\<script type="text/javascript" src="jquery-ui/jquery-1.6.2.js"></script>-->
    <!--<script type="text/javascript" src="jquery-ui/jquery-1.7.1.js"></script>-->
    <!--<script type="text/javascript" src="jquery-ui/"></script>-->
    <script type="text/javascript" src="js/common.js"></script>
    <script type="text/javascript" src="treemenu/script/contextmenu.js"></script>
    <script type="text/javascript" src="treemenu/script/dtree.js"></script>
    <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
    <script type="text/javascript" src="js/jquery.easing.1.3.js"></script>

    <!--<script type="text/javascript" src="js/jquery2.js"></script>-->
    <script type="text/javascript"  src="js/jqueryForm.js"></script>
    <!--<script type="text/javascript" src="js/jquery.bpopup.min.js"></script>-->

    <!--<script type="text/javascript" src="js/ajaxUpload.js"></script>-->
</head>
<style>
    .showx{
        display: block;
    }
    .hidex{
        display: none; font-size: 14px;
    }
    .popup_con{ 

        /*border: none;*/

        direction:rtl;
        padding:0px;
        margin-top: 10px;
        border: 1px solid tomato;
        background-color: #dfdfdf;
        margin-bottom: 5px;
        /*        width: 300px;
                height: 300px;*/
        width: 30%;
        margin-left: auto;
        margin-right: auto;


        /*position:relative;*/

        /*font:Verdana, Geneva, sans-serif;*/
        font-size:18px;
        font-weight:bold;
        display: none;
    }
    .popup_sms{ 

        /*border: none;*/

        direction:rtl;
        padding:0px;
        margin-top: 10px;
        border: 1px solid tomato;
        background-color: #dfdfdf;
        margin-bottom: 5px;
        /*        width: 300px;
                height: 300px;*/
        width:200px; 
        margin-left: auto;
        margin-right: auto;

        font-size:18px;
        font-weight:bold;
        display: none;
    }
</style>
<script type="text/javascript">

    function openWindowTasks(url)
    {

        window.open(url, "_blank", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=no, copyhistory=no,width=800,height=400");
    }




</script>
<script type="text/javascript" >
    $(document).ready(function()
    {

        $(".button_commen").click(function()
        {
            var X = $(this).attr('id');
            if (X == 1)
            {
                $(".submenu").hide();
                $(this).attr('id', '0');
            }
            else
            {
                $(".submenu").show();
                $(this).attr('id', '1');
            }

        });

        //Mouse click on sub menu
        $(".submenu").mouseup(function()
        {
            return false
        });
        $(".submenu").mouseout(function()
        {
            return false
        });
        $(".button_commen").mouseout(function()
        {
            return false
        });

        //Mouse click on my account link
        $(".button_commen").mouseup(function()
        {
            return false
        });


        //Document Click

        $(document).mouseup(function()
        {
            $(".submenu").hide();
            $(".button_commen").attr('id', '');
        });
        $(document).mouseout(function()
        {
            $(".submenu").hide();
            $(".button_commen").attr('id', '');
        });
        //appointment button
        $(".button_pointment").click(function()
        {
            var X = $(this).attr('id');
            if (X == 1)
            {
                $(".submenu1").hide();
                $(this).attr('id', '0');
            }
            else
            {
                $(".submenu1").show();
                $(this).attr('id', '1');
            }

        });
        $(".button_camp").click(function()
        {
            var X = $(this).attr('id');
            if (X == 1)
            {
                $(".submenu2").hide();
                $(this).attr('id', '0');
            }
            else
            {
                $(".submenu2").show();
                $(this).attr('id', '1');
            }

        });

        //Mouse click on sub menu
        $(".submenu1").mouseup(function()
        {
            return false
        });

        $(".submenu1").mouseout(function()
        {
            return false
        });
        $(".submenu2").mouseup(function()
        {
            return false
        });

        $(".submenu2").mouseout(function()
        {
            return false
        });
        //Mouse click on my account link
        $(".button_pointment").mouseup(function()
        {
            return false
        });
        $(".button_pointment").mouseout(function()
        {
            return false
        });
        $(".button_camp").mouseup(function()
        {
            return false
        });
        $(".button_camp").mouseout(function()
        {
            return false
        });
        //Document Click

        $(document).mouseup(function()
        {
            $(".submenu1").hide();
            $(".button_pointment").attr('id', '');
        });
        $(document).mouseout(function()
        {
            $(".submenu1").hide();
            $(".button_pointment").attr('id', '');
        });
        $(document).mouseup(function()
        {
            $(".submenu2").hide();
            $(".button_camp").attr('id', '');
        });
        $(document).mouseout(function()
        {
            $(".submenu2").hide();
            $(".button_camp").attr('id', '');
        });
        $(".change_status").click(function ()
        {
            var X = $(this).attr('id');
            if (X == 1)
            {
                $(".submenustatus").hide();
                $(this).attr('id', '0');
            }
            else
            {
                $(".submenustatus").show();
                $(this).attr('id', '1');
            }

        });

        //Mouse click on sub menu
        $(".submenustatus").mouseup(function ()
        {
            return false
        });
        $(".submenustatus").mouseout(function ()
        {
            return false
        });
        $(".change_status").mouseout(function ()
        {
            return false
        });

        //Mouse click on my account link
        $(".change_status").mouseup(function ()
        {
            return false
        });


        //Document Click

        $(document).mouseup(function ()
        {
            $(".submenustatus").hide();
            $(".change_status").attr('id', '');
        });
        $(document).mouseout(function ()
        {
            $(".submenustatus").hide();
            $(".change_status").attr('id', '');
        });
    });
    function saveSeason(obj) {
        
        

        var seasonNotes = $(obj).parent().parent().find('#seasonNotes').val();

        var seasonId = $(obj).parent().parent().find('#seasonId').val();

        var seasonName = $(obj).parent().parent().find('#seasonName').val();

        //            var seasonCode = $("#seasonCode").val();
        var clientId = $("#clientId").val();


        $.ajax({
            type: "post",
            url: "<%=context%>/SeasonServlet?op=saveClientSeason",
            data: {
                clientId: clientId,
                seasonId: seasonId,
                seasonName: seasonName,
                seasonNotes: seasonNotes

            },
            success: function(jsonString) {
                var info = $.parseJSON(jsonString);


                if (info.status == 'Ok') {

                    // change update icon state
                    $(obj).html("");
                    $(obj).css("background-position", "top");
                    $(obj).removeAttr("onclick");

                }
            }
        });
        //            });

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
    function changeImageState(checkBox) {
        if (checkBox.checked) {

            document.getElementById("file").disabled = false;
            document.getElementById("fileName").value = "";
        } else {
            document.getElementById("file").value = "";
            document.getElementById("file").disabled = true;
            document.getElementById('imageDiv').style.display = 'none';
            document.getElementById("fileName").value = "";
        }
    }
    function closePopup(obj){
           
        $(obj).parent().parent().bPopup().close();
              
        
    }
    var count=1;
    //    function removeTd(obj){
    //        $(obj).parent().remove();
    //        count=(count*1-1);
    //       // $("#addFile").removeAttr("disabled");
    //    }
  
    function addFiles(obj){
        if((count*1)==4){
            $("#addFile").removeAttr("disabled");
        }

        if(count>=1&count<=4){
            $("#listFile").append("<input type='file' style='float: right;text-align:right;font-size:12px;margin:1.5px;' name='file"+count+"' id='file'  maxlength='60'/>");
            $("#counter").val(count);
            
           
            count=Number(count*1+1)
           
            
           
        }else{
            $("#addFile").attr("disabled", true);
        }
       
       
    }
    function updateRow(obj) {
        $('#msg').html("");
        
        $("#updateUnit").css("display","");
        $("#addUnit").css("display","none");
        var x= $(obj).parent().find("#updateId").val();
        getSubProduct($(obj).parent().parent().find("#productCategoryId").val());
      
        $("#ID").val(x);
        $("#subProduct option:contains("+$(obj).parent().parent().find("#1").text()+")").prop('selected', true);
        //       alert($(obj).parent().parent().find("#2").text());
        $("#mainProduct option:contains("+$(obj).parent().parent().find("#2").text()+")").prop('selected', true);
       
        $("#budget").val($(obj).parent().parent().find("#3").text());
        $("#unitNotes").val($(obj).parent().parent().find("#6").text());    
        //     alert($(obj).parent().parent().find("#6").text())
        $("#period option:contains("+$(obj).parent().parent().find("#5").text()+")").prop('selected', true);
        $("#paymentSystem option:contains("+$(obj).parent().parent().find("#4").text()+")").prop('selected', true);
        
      
        $(obj).parent().parent().attr("id","ROWID");
     
        
        
  
        $('#unit_content').css("display", "block");
        $('#unit_content').bPopup({  easing: 'easeInOutSine', //uses jQuery easing plugin
            speed: 400,
            transition: 'slideDown'});
        
    }
    function addUnit(obj) {
        $('#msg').text("");
        var operation="insert";
        var notes = $('#unitNotes').val();
        if(notes==""||notes==null){
            notes="  ";
        }
        var budget = $('#budget').val();
        if (budget == "" || budget == null) {
            budget = "0";
        }
        var product_category_id = $('#mainProduct').val();
        if (product_category_id == "----" || product_category_id == null) {
            alert("من فضلك قم باختيار نوع إستثمار ");
        }
        var productId = $('#subProduct').val();
        var period = $('#period').val();
        var paymentSystem = $('#paymentSystem').val();
        //        var empId = $(obj).parent().parent().find('#employeeId').val();
        var clientId = $("#clientId").val();
        $.ajax({
            type: "post",
            url: "<%=context%>/ProjectServlet?op=saveInterestedProduct",
            data: {
                clientId: clientId,
                productId: productId,
                productCategoryId: product_category_id,
                paymentSystem: paymentSystem,
                period: period,
                budget: budget,
                notes: notes,
                operation:operation
            },
            success: function(jsonString) {
                //                    $(obj).html("");
                //                    $(obj).css("background-position", "top");
                //                   alert("info");
                //                    alert(jsonString);
                var info = $.parseJSON(jsonString);
                if (info.status == 'ok') {
                   
                    $('#unitNotes').val("");
                    $('#budget').val("");
                    $('#mainProduct').val("----");
                    $('#subProduct').val("----");
                    $('#subProduct').attr("disabled", "disabled");
                    $('#subProduct').html("----");

                    $('#period').val("");
                    $('#paymentSystem').val("");
                    $('#msg').text("تم التسجيل بنجاح");
                   
                    $("#interestedUnit").html($("#interestedUnit").html()+"<TR style='padding: 1px;'>\n\
                                <TD style='text-align:center;background: #f1f1f1;font-size: 14px;'>\n\
                                  <div class='remove' id='remove' onclick='removeRow(this)'></div> \n\
<div  class='update'  id='updateRow' onclick='updateRow(this)'> </div> \n\
 <input id='updateId'  type='hidden' value="+ info.id +"></TD>\n\
                            \n\
  <TD style='text-align:center;background: #f1f1f1;font-size: 14px;'>\n\
                                <b id='2'> " + info.productCategoryName + "</br>\
                                <input type='hidden' id='rowId' value=" + info.id + " />  </TD>\n\
                                <TD style='text-align:center;background: #f1f1f1;font-size: 14px;width: 13%;'>\n\
                                          <b id='1'>   " + info.productName + "</br> <input type='hidden' id='productCategoryId' value=" + info.productCategoryId + "          >       </TD>\n\
                                <TD style='text-align:center;background: #f1f1f1;font-size: 14px;'>\n\
                                     <b id='3'>  " + info.budget + " </br>       </TD>\n\
                                <TD style='text-align:center;background: #f1f1f1;font-size: 14px;'>\n\
                                        <b id='4'>     " + info.paymentSystem + "</br>                       </TD>\n\
                                <TD style='text-align:center;background: #f1f1f1;font-size: 14px;'>\n\
                               <b id='5'>  " + info.period + "</br>  </TD>\n\
                                 <TD style='text-align:center;background: #f1f1f1;font-size: 14px;'>\n\
                             <b id='6' onMouseOver='Tip('"+info.note+"', LEFT, true, OFFSETX, 0, BGCOLOR, '#FFFF99', FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT, 'BOLD', TITLEALIGN, 'center', TITLEFONTCOLOR, 'black', TITLEBGCOLOR, '#6699FF')' onMouseOut='UnTip()' >    " + info.note + "</br>  </TD>\n\
                            </TR>").show();

                } else if (info.status == 'no') {
                    $('#msg').text("لم يتم التسجيل");
                }
            }
        });
    }
    function updateUnit(obj) {
        var id= $("#ID").val();
       
        $('#msg').text("");
        var operation="update";
        var notes = $('#unitNotes').val();
        if(notes==""||notes==null){
            notes="  ";
        }
        var budget = $('#budget').val();
        if (budget == "" || budget == null) {
            budget = "0";
        }
        var product_category_id = $('#mainProduct').val();
        var productId = $('#subProduct').val();
        if (product_category_id == "----" || product_category_id == null) {
            alert("من فضلك قم باختيار نوع إستثمار ");
        }
        if($('#subProduct').attr("disabled") ){
            alert("من فضلك قم بإختيار الفئة");
            
        }else{}
        var period = $('#period').val();
        var paymentSystem = $('#paymentSystem').val();
        //        var empId = $(obj).parent().parent().find('#employeeId').val();
        var clientId = $("#clientId").val();
        $.ajax({
            type: "post",
            url: "<%=context%>/ProjectServlet?op=saveInterestedProduct",
            data: {
                clientId: clientId,
                productId: productId,
                productCategoryId: product_category_id,
                paymentSystem: paymentSystem,
                period: period,
                budget: budget,
                notes: notes,
                operation:operation,
                id:id
              
            },
            success: function(jsonString) {
                //                    $(obj).html("");
                //                    $(obj).css("background-position", "top");
                //                   alert("info");
                //                    alert(jsonString);
                var info = $.parseJSON(jsonString);
                if (info.status == 'ok') {
                    $('#unitNotes').val("");
                    $('#budget').val("");
                    $('#mainProduct').val("----");
                    $('#subProduct').val("----");
                    $('#subProduct').attr("disabled", "disabled");
                    $('#subProduct').html("----");

                    $('#period').val("");
                    $('#paymentSystem').val("");
                    $('#msg').text("تم التسجيل بنجاح");
                    
                    $("#ROWID").find("#1").html(info.productName);
                    $("#ROWID").find("#2").html(info.productCategoryName);
                    $("#ROWID").find("#3").html(info.budget);
                    $("#ROWID").find("#4").html(info.paymentSystem);
                    $("#ROWID").find("#5").html(info.period);
                    $("#ROWID").find("#6").html(info.note);
                    $("#ROWID").find("#7").html(info.note);
                    $("#ROWID").find("#updateRow").css('background-position','top');
                    $("#ROWID").removeAttr("id");
                 
                   
                } else if (info.status == 'no') {
                    $('#msg').text("لم يتم التسجيل");
                }
            }
        });
    }
   
    function cancelForm() {
        document.CLIENT_COMPLAINT_FORM.action = "<%=context%>/SearchServlet?op=searchForClient";
        document.CLIENT__FORM.submit();
    }
    function changeRate(obj) {
        $("#rate").css("display", "none");
        $("#choose").css("display", "inline");
        $("#changeRate").css("display", "none");
        $("#saveRate").css("display", "block");
        $(obj).parent().parent().find("#update").css("display", "none");
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

    function getSubProduct(mainProductId) {

        $("#subProduct").removeAttr("disabled");
        $('#msg').text("");

        if (mainProductId == null || mainProductId == "") {

        } else {
            document.getElementById('subProduct').innerHTML = "";
            //            $("#showBtn").removeAttr("disabled");
            //              $("#subProduct").attr("disabled","false");
            //          $('#subProduct').attr("disabled", "false");


            var url = "<%=context%>/ProjectServlet?op=getSubProject&mainProductId=" + mainProductId;
            if (window.XMLHttpRequest) {
                req = new XMLHttpRequest();
            } else if (window.ActiveXObject) {
                req = new ActiveXObject("Microsoft.XMLHTTP");
            }
            req.open("Post", url, true);
            req.onreadystatechange = callbackFillMainCategory;
            req.send(null);
        }
    }

    function callbackFillMainCategory() {
        if (req.readyState == 4) {
            if (req.status == 200) {

                var resultData = document.getElementById('subProduct');
                var result = req.responseText;
                
                //                        alert(result);
                if (result != "") {

                    var data = result.split("<element>");
                    var idAndName = "";
                    for (var i = 0; i < data.length; i++) {
                        idAndName = data[i].split("<subelement>");
                        resultData.options[resultData.options.length] = new Option(idAndName[1], idAndName[0]);
                    }
                } else {
                    $(resultData).html("");
                    //1364111290870 project_id refer to products
                    resultData.options[resultData.options.length] = new Option("تصنيف عام", "1364111290870");
                    //                    alert("no producttttttt")
                    //                     if(productName==null||productName==""||productName=="undefiend"){
                    //                                    productName="تصنيف عام";
                    //                                }
                }
            }
        }
    }


    function remove(obj) {

        $(obj).parent().parent().remove();
    }
    function isNumber2(evt) {
        var iKeyCode = (evt.which) ? evt.which : evt.keyCode
        if (iKeyCode != 46 && iKeyCode > 31 && (iKeyCode < 48 || iKeyCode > 57)) {

            $("#numberMsg").show();
            $("#numberMsg").text("أرقام فقط");
            return false;
        } else {
            $("#numberMsg").hide();
        }

    }
    
    function isNumber(evt) {
        var iKeyCode = (evt.which) ? evt.which : evt.keyCode
        if (iKeyCode != 46 && iKeyCode > 31 && (iKeyCode < 48 || iKeyCode > 57)) {

            alert("أرقام فقط")
            return false;
        } 

    }
    function checkNumber(obj) {
        //        alert('order');
        //            $("#clientID").keydown(function() {
        var clientNumber = $("input[name=clientNO]").val();
        if (clientNumber.length > 0) {
            $.ajax({
                type: "post",
                url: "<%=context%>/ClientServlet?op=getClientName",
                data: {
                    clientNumber: clientNumber
                },
                success: function(jsonString) {
                    var info = $.parseJSON(jsonString);

                    if (info.status == 'No') {

                        $("#MSG").css("color", "green");
                        $("#MSG").css(" text-align", "left");
                        //                            alert(jsonString);
                        $("#MSG").text(" متاح")
                        $("#MSG").removeClass("error");
                        $(obj).parent().parent().find("#warning").css("display", "none");
                        $(obj).parent().parent().find("#warning").css("float", "")
                        $(obj).parent().parent().find("#ok").css("display", "block")
                        $(obj).parent().parent().find("#ok").css("float", "right")

                    } else if (info.status == 'Ok') {
                        $("#MSG").css("color", "red");
                        $("#MSG").css(" text-align", "left");
                        $("#MSG").text(" محجوز");
                        $("#MSG").removeClass("error");
                        $(obj).parent().parent().find("#warning").css("display", "block")
                        $(obj).parent().parent().find("#warning").css("float", "right")
                        $(obj).parent().parent().find("#ok").css("display", "none");
                        $(obj).parent().parent().find("#ok").css("float", "")
                    }
                }
            });
        } else {
            $("#MSG").text("");
            $("#warning").css("display", "none");
            $("#ok").css("display", "none");
        }
        //            });
    }

</script>
<script type="text/javascript">
    function  getDataInPopup(url) {
        //alert("Message");
        var wind = window.open(url, "testname", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=no, copyhistory=no, width=650, height=600");
        wind.focus();
    }
    function hideCon() {

        //            alert("sssssss");
        //            $("#content").css("display", "none");
        $(obj).attr("src", "images/icons/plus.png");
        $(obj).attr("onclick", "showCon()");

    }
    $(function() {
        $("#appDate").datetimepicker({
            maxDate: "+d",
            changeMonth: true,
            changeYear: true,
            timeFormat: 'hh:mm',
            dateFormat: 'yy/mm/dd'
        });
    })

    $(function() {
        var x = $("#empId").val();
        if (x == null || x == "") {

            $('td[id|="removeTd"]').remove();
            $('th[id|="removeTd"]').remove();
            //                $("#removeTd").each(function() {
            //                
            //                        $("#call_center").find($("#removeTd")).remove();
            //                  
            //                })

        }


    });
    $(function() {
        var x = $("#empId").val();
        if (x == null || x == "") {

            $('tr[id|="removeTr"]').remove();
              
        }


    });
    function popup(obj) {
        $('#msg').html("");
        $("#addUnit").css("display","");
        $("#updateUnit").css("display","none");
        $('#unitNotes').val("");
        $('#budget').val("");
        $('#mainProduct').val("----");
        $('#subProduct').val("----");
        $('#subProduct').attr("disabled", "disabled");
        $('#subProduct').html("----");

        $('#period').val("");
        $('#paymentSystem').val("");
   
        
        $('#unit_content').css("display", "block");
        $('#unit_content').bPopup({  easing: 'easeInOutSine', //uses jQuery easing plugin
            speed: 400,
            transition: 'slideDown'});

    }
        
        
 
    function popupEmail(obj) {

        count=1;
        $("#addFile").removeAttr("disabled");
        $("#counter").val("0");
        $("#listFile").html("");
        var clientName=$("#clientInformation #clientName").text();
        $('#email_content #clientNa').val($("#hideName").val());
        $('#email_content #email').val($("#hideEmail").val());
        $("#msgContent").val("");
        
        $("#clientNo").text($("#num").text());
        $("#subj").val("");
        $("#progressx").hide();
        $('#email_content').show();
        $('#email_content').bPopup({  easing: 'easeInOutSine', //uses jQuery easing plugin
            speed: 400,
            transition: 'slideDown'});





    }
    function popupApp(obj) {

        $("#appTitleMsg").css("color","");
        $("#appTitleMsg").text("");
        $("#appTitle").val("");
       
       
        $("#appNote").val("");
        $("#appMsg").hide();
        $(".submenu1").hide();
        $("#appClientName").text($("#clientName").text());
        $(".button_pointment").attr('id', '0');
        $('#appointment_content').css("display", "block");
        
        $('#appointment_content').bPopup({  easing: 'easeInOutSine', //uses jQuery easing plugin
            speed: 400,
            transition: 'slideDown'});

      

    }
    function popupAddComment(obj) {

        $(".submenu").hide();
        $(".button_commen").attr('id', '0');
        $("#comment").val("");
        $("#commMsg").hide();
        
        $('#add_comments').css("display", "block");
        $('#add_comments').bPopup({  easing: 'easeInOutSine', //uses jQuery easing plugin
            speed: 400,
            transition: 'slideDown'});
        
    }
    function clientInformation(obj){
        $(".hidex").css("display", "none");
        $(".showx").css("display", "block");
        $('#clientInformation').css("display", "block");
        $("#updateBtn").css("display","none");
        $("#editBtn").css("display","block");
  
        $('#clientInformation').bPopup({  easing: 'easeInOutSine', //uses jQuery easing plugin
            speed: 400,
            transition: 'slideDown'});
    }
    function printClientInformation(obj){
        var url = "<%=context%>/PDFReportServlet?op=clientDataSheet&clientId=" + $("#clientId").val() + "&objectType=company";
        openWindow(url) 
    }
      
    function openWindow(url) {
        window.open(url,"_blank","toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=no, copyhistory=no, width=750, height=400");
    }
    function popupAddCampagin(obj) {
        $(".submenu2").hide();
        $(".button_camp").attr('id', '0');
        var url= "<%=context%>/SeasonServlet?op=showSeason";
       
        jQuery('#add_campaigns').load(url);
        $("#add_campaigns").css("display","block");

        $('#add_campaigns').bPopup({  easing: 'easeInOutSine', //uses jQuery easing plugin
            speed: 400,
            transition: 'slideDown'});
    }
    function popupShowComments(obj) {
        $(".submenu").hide();
        $(".button_commen").attr('id', '0');
        //            alert($("#businessObjectType").val());
        var url = "<%=context%>/CommentsServlet?op=showComments&clientId=" + $("#clientId").val() + "&objectType=" + $("#businessObjectType").val() + "&random=" + (new Date()).getTime();
        jQuery('#show_comments').load(url);
        $('#show_comments').css("display", "block");
        $('#show_comments').bPopup({  easing: 'easeInOutSine', //uses jQuery easing plugin
            speed: 400,
            transition: 'slideDown'});

    }
    function popupShowAppointment(obj) {

        $(".submenu1").hide();
        $(".button_pointment").attr('id', '0');
        var url = "<%=context%>/ClientServlet?op=showAppointment&clientId=" + $("#clientId").val() + "&cach=" + (new Date()).getTime();
        $('#show_appointment').load(url);
        $('#show_appointment').css("display", "block");
       
        $('#show_appointment').bPopup({  easing: 'easeInOutSine', //uses jQuery easing plugin
            speed: 400,
            transition: 'slideDown'});
            

    }
    function popupShowCampagin(obj) {

        $(".submenu2").hide();
        $(".button_camp").attr('id', '0');
        var url = "<%=context%>/ClientServlet?op=showClientCampaigns&clientId=" + $("#clientId").val();
        $('#show_campaigns').load(url);

        //        $('#show_campaigns').html();
        $('#show_campaigns').css("display","block");
        $('#show_campaigns').bPopup();
    }
    function sendMail()
    {
        var to = $("#email").val();
        var subject = $("#subj").val();
        var msgContent = $("#msgContent").val();
        //            alert(to);
        //            alert(subject)
        //            alert(msgContent)3
        var clientNumber = $("#errorMsg").val();
        var file = $("#file").val();
        var fileName = document.getElementById("file1").value;
        fileExt = "noFiles";
        var fileTitle = "noTitle";

        if (fileName.length > 0)
        {

            var fileExtPos = fileName.lastIndexOf('.');
            var fileTitlePos = fileName.lastIndexOf('\\');

            fileExt = fileName.substr(fileExtPos + 1);

            fileTitle = fileName.substring(fileTitlePos + 1, fileExtPos);

            document.getElementById("fileExtension").value = fileExt;

            document.getElementById("docTitle").value = fileTitle;

        }
        $("#sendMailBtn").on('click', function() {
            $("#file").upload("<%=context%>/EmailServlet?op=sendMail&fileExtension=" + fileExt, function(success) {
                console.log("done");
            }, $("#fgd"));
        })
      
    }
    function popupSms(obj) {


        $("#client_Na").text($("#hideName").val());
        $("#client_No").text($("#num").text());
        $("#mobile").val($("#client_mobile").text());
        $('#sms_content').css("display", "block");
        
        $('#sms_content').bPopup({  easing: 'easeInOutSine', //uses jQuery easing plugin
            speed: 400,
            transition: 'slideDown'});
    }

    function xx() {
        $("[id=showTd]").hide();
        $("[id=showTd2]").hide();
        $("[id=showTd3]").hide();
        $('#showEmployees').bPopup();

        $('#showEmployees').css("display", "block");

    }
    function view1(obj) {
        if ($(".save2").attr("xx") == "xx") {
            $(".save2").css("background-position", "bottom");
        }
          
        var comment = $(obj).parent().parent().find('#order').val();
        var managerId = $(obj).parent().parent().find('#department option:selected').val();
        var subject = $(obj).parent().parent().find('#subject').val();
        if(validateOrderFiled(obj)){
            $("#compTitle").val(comment);
            $("#compContent").val(subject);
            $("#managerId").val(managerId);
            $('#showEmployees').bPopup();

            $("[id=showTd]").show();
            $("[id=showTd2]").hide();
            $("[id=showTd3]").hide();
            $('#showEmployees').css("display", "block");
        }
    }
    function edit_Client2(obj){ 
        $(".hidex").css("display","block");
        $(".showx").css("display","none");
        $(obj).parent().parent().parent().find("#editBtn").css("display","none");
        $(obj).parent().parent().parent().find("#updateBtn").css("display","block");
        $(obj).parent().parent().parent().parent().parent().find("#job option:contains("+$(obj).parent().parent().parent().parent().parent().find("#clientJob").text()+")").prop('selected', true);
             
        //            $("input[class=hide]").css("display","block");
        
    }
    function updateClient(obj){

        var clientID=$("#clientId").val();
        var clientNO=$(obj).parent().parent().parent().parent().parent().find("#clientNO").text();
            
        var clientName=$(obj).parent().parent().parent().parent().parent().find("input[name=clientName]").val();
        var phone=$(obj).parent().parent().parent().parent().parent().find("input[name=phone]").val();
        var mobile=$(obj).parent().parent().parent().parent().parent().find("input[name=client_mobile]").val();
        var address=$(obj).parent().parent().parent().parent().parent().find("input[name=address]").val();
        var email=$(obj).parent().parent().parent().parent().parent().find("input[name=email]").val();

        $.ajax({
            type:"post",
            url: "<%=context%>/ClientServlet?op=UpdateCompanyAjax",
            data:{
                name:clientName,
                phone:phone,
                mobile:mobile,
                address:address,
                email:email,
                clientNO:clientNO,
                clientID:clientID

            },
            success:function(jsonString){
                 
                var data = $.parseJSON(jsonString);
                if(data.Status=="Ok"){
                       
                    var clientName2=  $(obj).parent().parent().parent().parent().parent().find("#clientName").attr("class", "showx");

                    var phone2=  $(obj).parent().parent().parent().parent().parent().find("#phone").attr("class", "showx");
                    var mobile2=  $(obj).parent().parent().parent().parent().parent().find("#client_mobile").attr("class", "showx");
                    var address2=  $(obj).parent().parent().parent().parent().parent().find("#address").attr("class", "showx");
                    var email2=  $(obj).parent().parent().parent().parent().parent().find("#email").attr("class", "showx");
                 
                    $(clientName2).text(clientName);
                  
                    $("#hideName").val(clientName2);
                    $("#hideEmail").val(email2);
                    $(phone2).text(phone);
                    $(mobile2).text(mobile);
                    $(address2).text(address);
                    $(email2).text(email);
                    $("#clientName").text(clientName);
                    $("#num").text(clientNO);
                    $(".showx").css("display","block");
                    $(".hidex").css("display","none");
                    $(obj).parent().css("display","none");
                    $(obj).parent().parent().parent().find("#editBtn").css("display","block");
                    alert("تم التعديل بنجاح");
                    //                        $(x).text(clientName);
                        
                }
            }
        });
                
    }
    function view2(obj) {
        if ($(".save3").attr("yy") == "yy") {
            $(".save3").css("background-position", "bottom");
        }
        if(validateComplaintFiled(obj)){
            var comment = $(obj).parent().parent().find('#complaint').val();
            var managerId = $(obj).parent().parent().find('#department option:selected').val();
            var subject = $(obj).parent().parent().find('#subject').val();
           
            $("#compTitle").val(comment);
            $("#compContent").val(subject);
            $("#managerId").val(managerId);
            $('#showEmployees').bPopup();
            $("[id=showTd3]").hide();
            $("[id=showTd2]").show();
            $("[id=showTd]").hide();
            $('#showEmployees').css("display", "block");
        }
    }
    function view3(obj) {
        if ($(".save4").attr("zz") == "zz") {
            $(".save4").css("background-position", "bottom");
        }
        if(validateQueryFiled(obj)){
            var comment = $(obj).parent().parent().find('#query').val();
            var managerId = $(obj).parent().parent().find('#department option:selected').val();
            var subject = $(obj).parent().parent().find('#subject').val();
           
            $("#compTitle").val(comment);
            $("#compContent").val(subject);
            $("#managerId").val(managerId);
            $('#showEmployees').bPopup();
            $("[id=showTd]").hide();
            $("[id=showTd2]").hide();
            $("[id=showTd3]").show();
            $('#showEmployees').css("display", "block");
        }
    }
    function saveAppo(obj) {
       var clientId = $("#clientId").val();
        $("#appTitleMsg").css("color","");
        $("#appTitleMsg").text("");


        var title = $(obj).parent().parent().parent().find($("#appTitle")).val();
       
        var date = $(obj).parent().parent().parent().find($("#appDate")).val();
        var comment = $(obj).parent().parent().parent().find($("#appNote")).val();
        var note = "UL";
        if(title.length>0){
            $(obj).parent().parent().parent().parent().find("#progress").show();
            $.ajax({
                type: "post",
                url: "<%=context%>/ClientServlet?op=saveAppointment",
                data: {
                    clientId: clientId,
                    title: title,
                    date: date,
                    note: note,
                    comment : comment,
                    type:1 
                },
                success: function(jsonString) {
                    var eqpEmpInfo = $.parseJSON(jsonString);
                    //                        alert(jsonString);
                    //                        alert(eqpEmpInfo);
                    if (eqpEmpInfo.status == 'ok') {
                        //                        alert("تم الحفظ");
                        $(obj).parent().parent().parent().parent().find("#appMsg").html("تم التسجيل بنجاح").show();
                        $(obj).parent().parent().parent().parent().find("#progress").hide();
                        

                    } else if (eqpEmpInfo.status == 'no') {
                        
                        $(obj).parent().parent().parent().parent().find("#progress").show();
                        $(obj).parent().parent().parent().parent().find("#appMsg").html("لم يتم التسجيل او هذا العميل غير موزع").show();
                    }


                }
            
            
            
            });
        }else{
            $("#appTitleMsg").css("color","white");
            $("#appTitleMsg").text("أدخل عنوان المقابلة");
                
        }

      


    }

    function saveComment(obj) {
        var clientId = $("#clientId").val();


        var type = $(obj).parent().parent().parent().find($("#commentType")).val();
        var comment = $("#commentCompany").val();
//        var comment = $(obj).parent().parent().parent().find($("#comment")).val();
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
                } else if (eqpEmpInfo.status == 'no') {
                    $(obj).parent().parent().parent().parent().find("#progress").show();
                }
            }
        });
    }
    function showCon(obj) {
        if ($(obj).attr("src") == "images/icons/plus.png") {
            $("#fieldCon").removeAttr("style");
            $("#fieldCon").css("width", "98%");
            $("#content").css("display", "block");
            $(obj).attr("src", "images/icons/minus.png");

            return false;
        }
        if ($(obj).attr("src") == "images/icons/minus.png") {
            $("#fieldCon").css("border", "none");
            $("#content").css("display", "none");
            $(obj).attr("src", "images/icons/plus.png");

            return false;
        }




    }
    function remove(obj) {

        $(obj).parent().parent().remove();
    }

    function yesnodialog(button1, button2, element) {
        var btns = {};
        btns[button1] = function() {
            element.parents('li').hide();
            $(this).dialog("close");
        };
        btns[button2] = function() {
            // Do nothing
            $(this).dialog("close");
        };
        $("<div></div>").dialog({
            autoOpen: true,
            title: 'Condition',
            modal: true,
            buttons: btns
        });
    }
    function removeRow(obj) {


        var x = confirm("هل أنت متاكد من الحذف");
        if (x == true) {
            var id=$(obj).parent().parent().find("#rowId").val();
            $.ajax({
                type: "post",
                url: "<%=context%>/ProjectServlet?op=removeInterestedProduct",
                data: {
                    id: id
                },
                success: function(jsonString) {
                    var info = $.parseJSON(jsonString);
                    if (info.status == 'ok') {
                        remove(obj);
                        //                            alert(obj);alert($(obj).parent().parent().val());
                    } else if (info.status == 'no') {
                        alert("حدث خظأ فى الحذف")
                    }
                }
            });
        }
    }

    function updateClientGrade(x) {

        var unitId = $("#clientId").val();
          
        var empId = document.getElementById("choose").value;
        $.ajax({
            type: "post",
            url: "<%=context%>/ClientServlet?op=updateCustomerGrade2",
            data: {clientId: unitId,
                degreeId: empId

            },
            success: function(jsonString) {
                var eqpEmpInfo = $.parseJSON(jsonString);

                if (eqpEmpInfo.status == 'Ok') {
                     
                    $("#rate").css("display", "inline");
                    $("#choose").css("display", "none");
                    $("#changeRate").css("display", "inline");
                    $("#saveRate").css("display", "none");
                    $("#update").css("display","block");
                    $("#rate").html($("#choose option:selected").text());
                }
            }
        });
    }


    function popupCreateBookmark(obj, clientId) {
        $("#createMsg").hide();
        $("#saveBookmark").show();
        $('#createBookmark').find("#title").val("");
        $('#createBookmark').find("#details").val("");
        $('#createBookmark').css("display", "block");
        $('#createBookmark').bPopup({  easing: 'easeInOutSine', //uses jQuery easing plugin
            speed: 400,
            transition: 'slideDown'});
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
            },
            success: function(jsonString) {
                var info = $.parseJSON(jsonString);
                if (info.status == 'ok') {
                    $("#bookmarkedImg").prop('title', details);
                    $("#createMsg").show();
                    $("#saveBookmark").hide();
                    $("#bookmarked").removeAttr("onclick");
                    $("#bookmarked").click(function(){
                        deleteBookmark(this, info.bookmarkId, clientId);
                    });
                    $('#bookmarked').css("display", "block");
                    $('#unbookmarked').css("display", "none");                      
                }
                else {
                }
            }
        });
    }
    function deleteBookmark(obj, bookmarkId, clientId) {
        $.ajax({
            type: "post",
            url: "<%=context%>/BookmarkServlet?op=DeleteAjax&key=" + bookmarkId,
            data: {
            },
            success: function(jsonString) {
                var info = $.parseJSON(jsonString);
                if (info.status == 'ok') {
                    $('#bookmarked').css("display", "none");
                    $('#unbookmarked').css("display", "block");
                }
            }
        });
    }
    function reservedUnit(obj) {
        var issueId = "<%=issueId%>";
        var clientComplaintId = "<%=request.getParameter("compId")%>";
        var clientId = $("#clientId").val();

        var unitId = document.getElementById("unitId").value;
        var parentId = document.getElementById("parentId").value;
        var period = document.getElementById("period2").value;
        var changeStatus = document.getElementById("changeStatus").value;

        var unitValue = document.getElementById("unitValue").value;
        var unitValueText = document.getElementById("unitValueText").value;
        var beforeDiscount = document.getElementById("beforeDiscount").value;
        var beforeDiscountText = document.getElementById("beforeDiscountText").value;
        var reservationValue = document.getElementById("reservationValue").value;
        var reservationValueText = document.getElementById("reservationValueText").value;
        var contractValue = document.getElementById("contractValue").value;
        var contractValueText = document.getElementById("contractValueText").value;

        var plotArea = document.getElementById("plotArea").value;
        var buildingArea = document.getElementById("buildingArea").value;
        var reservationDate = document.getElementById("reservationDate").value;
        var paymentSystem = document.getElementById("paymentSystem").value;
        var floorNumber = document.getElementById("floorNumber").value;
        var modelNo = document.getElementById("modelNo").value;
        var receiptNo = document.getElementById("receiptNo").value;
        var comments = document.getElementById("addtions").value;
        
        if (unitId == "") {
            alert("من فضلك ادخل الوحدة");
            return false;
        } else if (unitValue == "") {
            alert("من فضلك ادخل قيمة الوحده بعد الخصم");
            return false;
        } else if (beforeDiscount == "") {
            alert("من فضلك ادخل قيمة الوحدة فبل الخصم");
            return false;
        } else if (reservationValue == "") {
            alert("من فضلك ادخل دفعة الحجز");
            return false;
        } else if (contractValue == "") {
            alert("من فضلك ادخل دفعة التعاقد");
            return false;
        } else if (buildingArea == "") {
            alert("من فضلك ادخل مساحة الوحدة");
            return false;
        } else if (receiptNo == "") {
            alert("من فضلك ادخل رقم الايصال");
            return false;
        }
        
        if (period == "") {
            period = '7';
        }
        $('input[name="reserveUnit"]').attr('disabled', true);
        $.ajax({
            type: "post",
            url: "<%=context%>/ProjectServlet?op=saveAvailableUnits&changeStatus=" + changeStatus,
            data: {
                issueId: issueId,
                clientComplaintId: clientComplaintId,
                clientId: clientId,
                unitId: unitId,
                unitCategoryId: parentId,
                period: period,
                unitValue: unitValue,
                unitValueText: unitValueText,
                beforeDiscount: beforeDiscount,
                beforeDiscountText: beforeDiscountText,
                reservationValue: reservationValue,
                reservationValueText: reservationValueText,
                contractValue: contractValue,
                contractValueText: contractValueText,
                plotArea: plotArea,
                buildingArea: buildingArea,
                reservationDate: reservationDate,
                paymentSystem: paymentSystem,
                floorNumber: floorNumber,
                modelNo: modelNo,
                receiptNo: receiptNo,
                comments: comments

            },
            success: function (jsonString) {
                var info = $.parseJSON(jsonString);
                if (info.status == 'ok') {
                    alert("تم الحجز بنجاح")
                    closePopupDialog("reserveDialog");
                    $("#clientCode").val("");
                    $("#unitId").val("");
                    $("#period2").val("");
                    $("#paymentSystem").val("");
                    $("#parentId").val("");
                    $("#clientName").html("");
                    // For Status
                    $("#customerCheckGr").show();
                    $("#contactCheckGr").hide();
                    $("#opportunityCheckGr").hide();
                    $("#leadCheckGr").hide();
                    $("#customerCheck").hide();
                    $("#contactCheck").show();
                    $("#opportunityCheck").show();
                    $("#leadCheck").show();
                    $("#changeStatusImg").hide();
                    $("#changeStatusAll").hide();
                    $("#changeStatusClient").hide();
                    // Add Row
                    var d = new Date();
                    var month = d.getMonth() + 1;
                    var monthStr;
                    if (month < 10) {
                        monthStr = "0" + month;
                    } else {
                        monthStr = month;
                    }
                    var day = d.getDate();
                    var year = d.getFullYear();
                    $("#reservedUnit").html($("#reservedUnit").html() + "<TR style='padding: 1px;'>\n\
                            <TD style='text-align:center;background: #f1f1f1;font-size: 14px;'>\n\
                                <b id='1'> " + $("#unitCodeSell").val() + "</b>  </TD>\n\
                            <TD style='text-align:center;background: #f1f1f1;font-size: 14px;'>\n\
                                <b id='2'>  " + info.projectName + " </b>       </TD>\n\
                            <TD style='text-align:center;background: #f1f1f1;font-size: 14px;'>\n\
                                <b id='4'>  " + paymentSystem + " </b>       </TD>\n\
                            <TD style='text-align:center;background: #f1f1f1;font-size: 14px;'>\n\
                                <b id='5'>  " + period + " </b>       </TD>\n\
                            <TD style='text-align:center;background: #f1f1f1;font-size: 14px;'>\n\
                                <b id='6'>  " + year + "-" + monthStr + "-" + day + " </b>       </TD>\n\
                            <TD style='text-align:center;background: #f1f1f1;font-size: 14px;'>\n\
                                <b id='7'>    " + "حجز عادي" + "</b>  </TD>\n\
                        </TR>").show();
                } else if (eqpEmpInfo.status == 'no') {
                    alert("لم يتم الحجز");
                    $('input[name="reserveUnit"]').attr('disabled', false);
                }
            }
        });
    }
    function getUnitPrice() {
        var unitId = document.getElementById("unitId").value;

        $.ajax({
            type: "post",
            url: "<%=context%>/ProjectServlet?op=getUnitPrice",
            data: {
                unitId: unitId
            },
            success: function (jsonString) {
            var info = $.parseJSON(jsonString);

        if (jsonString != ''){
                    $("#beforeDiscount").val(info.option1);
                    $("#buildingArea").val(info.maxPrice);   
                } else {
                    alert("هذه الوحدة غير مسعرة");
                    $("#beforeDiscount").val("");
                    $("#buildingArea").val("");
                }
            }
        });
    }    
    function changeStatus(obj) {
        var comment = $(obj).parent().parent().parent().find('#clientStatusNotes').val();
        var statusDate = $(obj).parent().parent().parent().find('#clientStatusDate').val();
        var clientId = $("#clientId").val();
        var oldStatus = $("#clientStatus").val();
        $.ajax({
            type: "post",
            url: "<%=context%>/ClientServlet?op=changeClientStatus",
            data: {
                comment: comment,
                clientId: clientId,
                statusDate: statusDate,
                oldStatus: oldStatus},
            success: function (jsonString) {
                var info = $.parseJSON(jsonString);

                if (info.status == 'Ok') {
                    $("#clientStatusMsg").show();
                    $("#changeStatusBtn").hide();
                    $(obj).css("background-position", "top");
                    if (info.statusCode == '11') {
                        $("#customerCheckGr").show();
                        $("#contactCheckGr").hide();
                        $("#opportunityCheckGr").hide();
                        $("#leadCheckGr").hide();
                        $("#customerCheck").hide();
                        $("#contactCheck").show();
                        $("#opportunityCheck").show();
                        $("#leadCheck").show();
                        $("#changeStatusImg").hide();
                    } else if (info.statusCode == '13') {
                        $("#customerCheckGr").hide();
                        $("#contactCheckGr").hide();
                        $("#opportunityCheckGr").show();
                        $("#leadCheckGr").hide();
                        $("#customerCheck").show();
                        $("#contactCheck").show();
                        $("#opportunityCheck").hide();
                        $("#leadCheck").show();
                    } else if (info.statusCode == '14') {
                        $("#customerCheckGr").hide();
                        $("#contactCheckGr").show();
                        $("#opportunityCheckGr").hide();
                        $("#leadCheckGr").hide();
                        $("#customerCheck").show();
                        $("#contactCheck").hide();
                        $("#opportunityCheck").show();
                        $("#leadCheck").show();
                        $("#changeStatusAll").hide();
                        $("#changeStatusClient").show();
                    } else if (info.statusCode == '12') {
                        $("#customerCheckGr").hide();
                        $("#contactCheckGr").hide();
                        $("#opportunityCheckGr").hide();
                        $("#leadCheckGr").show();
                        $("#customerCheck").show();
                        $("#contactCheck").show();
                        $("#opportunityCheck").show();
                        $("#leadCheck").hide();
                    }
                    $("#clientStatus").val(info.statusCode);
                }
            }
        });

    }
    function popupClientStatus(obj) {
        $("#clientStatusMsg").hide();
        $("#changeStatusBtn").show();
        $('#clientStatus').find("#clientStatusNotes").val("");
        $('#clientStatus').css("display", "block");
        $('#clientStatus').bPopup();
    }
    function popupReverseStatus(obj) {
        $("#reverseStatusMsg").hide();
        $("#reverseStatusBtn").show();
        $('#reverseStatus').find("#reverseStatusNotes").val("");
        $('#reverseStatus').css("display", "block");
        $('#reverseStatus').bPopup();
    }
    function popupClientReservation() {
        divID = "reserveDialog";
        $('#overlay').show();
        $("#reservationBtn").show();
        $("#changeStatus").val('true');
        $('#reserveDialog').find("#clientStatusNotes").val("");
        $('#reserveDialog').css("display", "block");
        $('#reserveDialog').css("opacity", "100");
        $('#reserveDialog').bPopup({
            follow: [false, false], //x, y
            position: ["15%","10%"] //x, y
        });
        $('#reserveDialog').css({ 'position': 'fixed' });
    }
    function reverseStatus(obj) {
        var comment = $(obj).parent().parent().parent().find('#reverseStatusNotes').val();
        var statusDate = $(obj).parent().parent().parent().find('#reverseStatusDate').val();
        var clientId = $("#clientId").val();
        var oldStatus = '11';
        $.ajax({
            type: "post",
            url: "<%=context%>/ClientServlet?op=changeClientStatus",
            data: {
                comment: comment,
                clientId: clientId,
                statusDate: statusDate,
                oldStatus: oldStatus},
            success: function (jsonString) {
                var info = $.parseJSON(jsonString);

                if (info.status == 'Ok') {
                    $("#reverseStatusMsg").show();
                    $("#reverseStatusBtn").hide();
                    $(obj).css("background-position", "top");
                    $("#customerCheckGr").hide();
                    $("#contactCheckGr").hide();
                    $("#opportunityCheckGr").hide();
                    $("#leadCheckGr").show();
                    $("#customerCheck").show();
                    $("#contactCheck").show();
                    $("#opportunityCheck").show();
                    $("#leadCheck").hide();
                    $("#reverseStatus").val(info.statusCode);
                }
            }
        });

    }
</script>
<style type="text/css">
    .save_ {
        width:32px;
        height:32px;
        background-image:url(images/icons/check.png);
        background-repeat: no-repeat;
        background-position: bottom;
        cursor: pointer;
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

    .backStyle{
        border-bottom-width:0px;
        border-left-width:0px;
        border-right-width:0px;
        border-top-width:0px
    }
    .remove {
        width:20px;
        height:20px;
        margin: 4px;
        background-repeat: no-repeat;
        cursor: pointer;
        background-position: top;
        background-image:url(images/icons/icon-32-remove.png);

    }
    .update {
        width:20px;
        height:20px;
        margin: 4px;
        background-repeat: no-repeat;
        cursor: pointer;
        background-position: bottom;
        background-image:url(images/icons/update.png);

    }
    .datepick {}
    .login td{border: none;}
    .save__{
        width:20px;
        height:20px;
        background-image:url(images/icons/icon-32-publish.png);
        background-repeat: no-repeat;
        background-position: bottom;
        cursor: pointer;
        margin-right: auto;
        margin-left: auto;
    }
    .silver_odd_main,.silver_even_main {
        text-align: center;
    }
    .popup_content{ 

        border: none;

        direction:rtl;
        padding:0px;
        margin-top: 10px;
        border: 1px solid tomato;
        background-color: #dfdfdf;
        margin-bottom: 5px;
        width: 300px;
        height: 300px;
        /*position:absolute;*/

        font:Verdana, Geneva, sans-serif;
        font-size:18px;
        font-weight:bold;
        display: none;
    }
    .popup_appointment{
        border: none;

        direction:rtl;
        padding:0px;
        margin-top: 10px;
        border: 1px solid tomato;
        background-color: #dfdfdf;
        margin-bottom: 5px;
        width: 30%;

        /*position:absolute;*/

        font:Verdana, Geneva, sans-serif;
        font-size:18px;
        font-weight:bold;
        display: none;
    }
    input { font-size: 18px; }

    .button_commen {
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
        background-image:url(images/buttons/comments.png);
    }

    .show{
        display: block;
    }
    .hide{
        display: none;
    }

    .button_sms{
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
        background-image:url(images/buttons/smss.png);
    }
    .button_email{
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
        background-image:url(images/buttons/emails.png);
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
        border-radius: 3px;
        background-image:url(images/buttons/attach.png);
    }
    .button_financial{
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
        background-image:url(images/buttons/fin.png);
    }
    .button_pointment{
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
        background-image:url(images/buttons/pio.png);
    }
    .button_camp{
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
        background-image:url(images/buttons/campaign.gif);
    }
</style>
<style>

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
    #textS{
        font:Verdana, Geneva, sans-serif;
        font-size:12px;

        color:#009933;
    }


    #call_center{
        direction:rtl;
        padding:0px;

        /*        background-color: #dedede;*/
        margin-left: auto;
        margin-right: auto;
        margin-bottom: 5px;
        margin-top: 0px;
        color:#005599;
        /*            height:600px;*/
        width:95%;
        /*position:absolute;*/
        border:1px solid #f1f1f1;
        font:Verdana, Geneva, sans-serif;
        font-size:16px;
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

    #progress { width:50%; border: none; padding: 1px; margin-left: auto;margin-right: auto;text-align: center;}
    #bar { background-color: #B4F5B4; width:0%; height:20px; border-radius: 3px; }
    /*    #percent { position:absolute; display:inline-block; top:3px; left:48%; z-index: 1000;}*/
    #tableDATA th{

        font-size: 15px;
    }



    .status{

        width:32px;
        height:32px;
        background-image:url(images/icons/status.png);
        background-repeat: no-repeat;
        cursor: pointer;
    }

    .button_comment {
        width:145px;
        height:31px;
        margin: 4px;
        background-repeat: no-repeat;
        cursor: pointer;
        border: none;
        background-position: right top ;
        display: inline-block;
        background-color: transparent;
        background-image:url(images/buttons/comment.png);
    }
    .button_comment:hover {
        width:145px;
        height:31px;
        margin: 4px;
        background-repeat: no-repeat;
        cursor: pointer;
        border: none;
        background-position: right top ;
        display: inline-block;
        background-color: transparent;
        background-image:url(images/buttons/commentH.png);
    }
    .button_bookmark {
        width:145px;
        height:31px;
        margin: 4px;
        background-repeat: no-repeat;
        cursor: pointer;
        border: none;
        background-position: right top ;
        display: inline-block;
        background-color: transparent;
        background-image:url(images/buttons/bookmark.png);
    }
    .hide{display: none;text-align: right;}
    .show{display: block;}
    .button_bookmark:hover {
        width:145px;
        height:31px;
        margin: 4px;
        background-repeat: no-repeat;
        cursor: pointer;
        border: none;
        background-position: right top ;
        display: inline-block;
        background-color: transparent;
        background-image:url(images/buttons/bookmarkH.png);
    }
    .button_redirect {
        width:145px;
        height:31px;
        margin: 4px;
        background-repeat: no-repeat;
        cursor: pointer;
        border: none;
        background-position: right top ;
        display: inline-block;
        background-color: transparent;
        background-image:url(images/buttons/redi.png);
    }
    /*    .button_redirect:hover {
            width:145px;
            height:31px;
            margin: 4px;
            background-repeat: no-repeat;
            cursor: pointer;
            border: none;
            background-position: right top ;
            display: inline-block;
            background-color: transparent;
            background-image:url(images/buttons/redirectH.png);
        }*/
    .button_finish {
        width:145px;
        height:31px;
        margin: 4px;
        background-repeat: no-repeat;
        cursor: pointer;
        border: none;
        background-position: right top ;
        display: inline-block;
        background-color: transparent;
        background-image:url(images/buttons/finish.png);
    }
    .button_finish:hover {
        width:145px;
        height:31px;
        margin: 4px;
        background-repeat: no-repeat;
        cursor: pointer;
        border: none;
        background-position: right top ;
        display: inline-block;
        background-color: transparent;
        background-image:url(images/buttons/finishH.png);
    }
    .button_close {
        width:145px;
        height:31px;
        margin: 4px;
        background-repeat: no-repeat;
        cursor: pointer;
        border: none;
        background-position: right top ;
        display: inline-block;
        background-color: transparent;
        background-image:url(images/buttons/close.png);
    }
    .button_close:hover {
        width:145px;
        height:31px;
        margin: 4px;
        background-repeat: no-repeat;
        cursor: pointer;
        border: none;
        background-position: right top ;
        display: inline-block;
        background-color: transparent;
        background-image:url(images/buttons/closeH.png);
    }

    .button_clientO{
        width:145px;
        height:31px;
        margin: 4px;
        background-repeat: no-repeat;
        cursor: pointer;
        border: none;
        background-position: right top ;
        display: inline-block;
        background-color: transparent;
        background-image:url(images/buttons/clientO.png);
        /*        background-position: top right;*/
    }.managerBtn{
        width:145px;
        height:31px;
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
    .dropdown 
    {
        color: #555;

        /*margin: 3px -22px 0 0;*/
        width: 128px;
        position: relative;
        height: 17px;
        text-align:left;
    }
    .submenu
    {
        background:#FFFFCC;
        position: absolute;
        top: 30px;
        left:0px;
        /*left: 0px;*/
        z-index: 1000;
        width: 120px;
        display: none;
        margin-left: 10px;
        padding: 0px 0 5px;
        border-radius: 6px;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.45);
    }
    .submenu1
    {
        background:#FFFFCC;
        position: absolute;
        top: 30px;
        left:0px;
        /*left: 0px;*/
        z-index: 1000;
        width: 120px;
        display: none;
        margin-left: 10px;
        padding: 0px 0 5px;
        border-radius: 6px;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.45);
    }
    .submenu2
    {
        background:#FFFFCC;
        position: absolute;
        top: 30px;
        left:0px;
        /*left: 0px;*/
        z-index: 1000;
        width: 120px;
        display: none;
        margin-left: 10px;
        padding: 0px 0 5px;
        border-radius: 6px;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.45);
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
    .save2 {
        width:20px;
        height:20px;
        background-image:url(images/icons/icon-32-publish.png);
        background-position: bottom;
        background-repeat: no-repeat;
        cursor: pointer;
    }
    .save3 {
        width:20px;
        height:20px;
        background-image:url(images/icons/icon-32-publish.png);
        background-position: bottom;
        background-repeat: no-repeat;
        cursor: pointer;
    }
    .save4 {
        width:20px;
        height:20px;
        background-image:url(images/icons/icon-32-publish.png);
        background-position: bottom;
        background-repeat: no-repeat;
        cursor: pointer;
    }
    .dropdown li a:hover
    {
        background:#155FB0;
        color:yellow;
        text-decoration: none;
    }
    /*    a.button_commen 
        {
            font-size: 11px;
            line-height: 16px;
            color: #555;
            position: absolute;
            z-index: 110;
            display: block;
            padding: 11px 0 0 20px;
            height: 28px;
            width: 121px;
            margin: -11px 0 0 -10px;
            text-decoration: none;
            background: url(icons/arrow.png) 116px 17px no-repeat;
            cursor:pointer;
        }*/
    .root
    {
        list-style:none;
        margin:0px;
        padding:0px;
        font-size: 11px;
        padding: 11px 0 0 0px;
        border-top:1px solid #dedede;
    }


</style>
<style type="text/css">
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

        -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 0.67);
        -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 0.67);
        box-shadow:         0px 0px 17px rgba(255, 255, 255, 0.67);
        -webkit-border-radius: 20px;
        -moz-border-radius: 20px;
        border-radius: 20px;
    }
    .remove__{
        width:20px;
        height:20px;
        background-image:url(images/icons/remove1.png);
        background-position: bottom;
        background-repeat: no-repeat;
        cursor: pointer;
        margin-right: auto;
        margin-left: auto;
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


        color: #ffffff;

        text-shadow: 0 1px rgba(255, 255, 255, 0.3);
        background: #cc0000;
        background-clip: padding-box;
        border: 1px solid #284473;
        border-bottom-color: #223b66;
        border-radius: 4px;
        cursor: pointer;
        /*background: #ff670f;  Old browsers */
        /*        background-image: -webkit-linear-gradient(top, #d0e1fe, #96b8ed);
                background-image: -moz-linear-gradient(top, #d0e1fe, #96b8ed);
                background-image: -o-linear-gradient(top, #d0e1fe, #96b8ed);
                background-image: linear-gradient(to bottom, #d0e1fe, #96b8ed);
                -webkit-box-shadow: inset 0 1px rgba(255, 255, 255, 0.5), inset 0 0 7px rgba(255, 255, 255, 0.4), 0 1px 1px rgba(0, 0, 0, 0.15);
                box-shadow: inset 0 1px rgba(255, 255, 255, 0.5), inset 0 0 7px rgba(255, 255, 255, 0.4), 0 1px 1px rgba(0, 0, 0, 0.15);*/
    }

    .login-input {

        width: 100%;
        height: 23px;
        padding: 0 9px;
        color: #27272A;
        font-size: 13px;
        cursor: auto;
        text-shadow: 0 1px black;
        background: #2b3e5d;
        border: 1px solid #ffffff;
        border-top-color: #0d1827;
        border-radius: 4px;
        background: rgb(249,252,247); /* Old browsers */
        /* IE9 SVG, needs conditional override of 'filter' to 'none' */
        /*background: url(data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiA/Pgo8c3ZnIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgd2lkdGg9IjEwMCUiIGhlaWdodD0iMTAwJSIgdmlld0JveD0iMCAwIDEgMSIgcHJlc2VydmVBc3BlY3RSYXRpbz0ibm9uZSI+CiAgPGxpbmVhckdyYWRpZW50IGlkPSJncmFkLXVjZ2ctZ2VuZXJhdGVkIiBncmFkaWVudFVuaXRzPSJ1c2VyU3BhY2VPblVzZSIgeDE9IjAlIiB5MT0iMCUiIHgyPSIwJSIgeTI9IjEwMCUiPgogICAgPHN0b3Agb2Zmc2V0PSIwJSIgc3RvcC1jb2xvcj0iI2Y5ZmNmNyIgc3RvcC1vcGFjaXR5PSIxIi8+CiAgICA8c3RvcCBvZmZzZXQ9IjEwMCUiIHN0b3AtY29sb3I9IiNmNWY5ZjAiIHN0b3Atb3BhY2l0eT0iMSIvPgogIDwvbGluZWFyR3JhZGllbnQ+CiAgPHJlY3QgeD0iMCIgeT0iMCIgd2lkdGg9IjEiIGhlaWdodD0iMSIgZmlsbD0idXJsKCNncmFkLXVjZ2ctZ2VuZXJhdGVkKSIgLz4KPC9zdmc+);*/
        background: -moz-linear-gradient(top, rgba(249,252,247,1) 0%, rgba(245,249,240,1) 100%); /* FF3.6+ */
        background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,rgba(249,252,247,1)), color-stop(100%,rgba(245,249,240,1))); /* Chrome,Safari4+ */
        background: -webkit-linear-gradient(top, rgba(249,252,247,1) 0%,rgba(245,249,240,1) 100%); /* Chrome10+,Safari5.1+ */
        background: -o-linear-gradient(top, rgba(249,252,247,1) 0%,rgba(245,249,240,1) 100%); /* Opera 11.10+ */
        background: -ms-linear-gradient(top, rgba(249,252,247,1) 0%,rgba(245,249,240,1) 100%); /* IE10+ */
        background: linear-gradient(to bottom, rgba(249,252,247,1) 0%,rgba(245,249,240,1) 100%); /* W3C */
        filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#f9fcf7', endColorstr='#f5f9f0',GradientType=0 ); /* IE6-8 */
    }
    .input-file{

        width: 80%;
        height: 20px;
        padding: 0 9px;
        color: #27272A;
        font-size: 12px;
        cursor: auto;
        text-shadow: 0 1px black;
        background: #2b3e5d;
        border: 1px solid #ffffff;
        border-top-color: #0d1827;
        border-radius: 4px;
        background: rgb(249,252,247); /* Old browsers */
        /* IE9 SVG, needs conditional override of 'filter' to 'none' */
        /*background: url(data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiA/Pgo8c3ZnIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgd2lkdGg9IjEwMCUiIGhlaWdodD0iMTAwJSIgdmlld0JveD0iMCAwIDEgMSIgcHJlc2VydmVBc3BlY3RSYXRpbz0ibm9uZSI+CiAgPGxpbmVhckdyYWRpZW50IGlkPSJncmFkLXVjZ2ctZ2VuZXJhdGVkIiBncmFkaWVudFVuaXRzPSJ1c2VyU3BhY2VPblVzZSIgeDE9IjAlIiB5MT0iMCUiIHgyPSIwJSIgeTI9IjEwMCUiPgogICAgPHN0b3Agb2Zmc2V0PSIwJSIgc3RvcC1jb2xvcj0iI2Y5ZmNmNyIgc3RvcC1vcGFjaXR5PSIxIi8+CiAgICA8c3RvcCBvZmZzZXQ9IjEwMCUiIHN0b3AtY29sb3I9IiNmNWY5ZjAiIHN0b3Atb3BhY2l0eT0iMSIvPgogIDwvbGluZWFyR3JhZGllbnQ+CiAgPHJlY3QgeD0iMCIgeT0iMCIgd2lkdGg9IjEiIGhlaWdodD0iMSIgZmlsbD0idXJsKCNncmFkLXVjZ2ctZ2VuZXJhdGVkKSIgLz4KPC9zdmc+);*/
        background: -moz-linear-gradient(top, rgba(249,252,247,1) 0%, rgba(245,249,240,1) 100%); /* FF3.6+ */
        background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,rgba(249,252,247,1)), color-stop(100%,rgba(245,249,240,1))); /* Chrome,Safari4+ */
        background: -webkit-linear-gradient(top, rgba(249,252,247,1) 0%,rgba(245,249,240,1) 100%); /* Chrome10+,Safari5.1+ */
        background: -o-linear-gradient(top, rgba(249,252,247,1) 0%,rgba(245,249,240,1) 100%); /* Opera 11.10+ */
        background: -ms-linear-gradient(top, rgba(249,252,247,1) 0%,rgba(245,249,240,1) 100%); /* IE10+ */
        background: linear-gradient(to bottom, rgba(249,252,247,1) 0%,rgba(245,249,240,1) 100%); /* W3C */
        filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#f9fcf7', endColorstr='#f5f9f0',GradientType=0 ); /* IE6-8 */
    }

    #changeRate{
        width: 32px;height: 32px;background-image: url(images/user_male_edit.png);background-repeat: no-repeat;display: inline; 
    }

    .login-input:focus {
        outline: 0;
        background-color:  #ffa84c;;
        -webkit-box-shadow: inset 0 1px 2px #ffa84c, 0 0 4px 1px #ffa84c;
        box-shadow: inset 0 1px 2px #ffa84c, 0 0 4px 1px #ffa84c;
    }
    .lt-ie9 .login-input {
        line-height: 35px;
    }

    .login-submit {
        text-align: center;
        width: 30%;
        height: 37px;
        margin-top: 15px;
        margin-left: auto;
        margin-right: auto;
        margin-bottom: 15px;
        font-size: 14px;
        font-weight: bold;
        color: #294779;
        text-shadow: 0 1px rgba(255, 255, 255, 0.3);
        background: #f1f1f1;
        background-clip: padding-box;
        /*border: 1px solid #284473;*/
        /*border-bottom-color: #223b66;*/
        border-radius: 4px;
        cursor: pointer;
        background: #cfe7fa; /* Old browsers */
        /* IE9 SVG, needs conditional override of 'filter' to 'none' */
        /*background: url(data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiA/Pgo8c3ZnIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgd2lkdGg9IjEwMCUiIGhlaWdodD0iMTAwJSIgdmlld0JveD0iMCAwIDEgMSIgcHJlc2VydmVBc3BlY3RSYXRpbz0ibm9uZSI+CiAgPGxpbmVhckdyYWRpZW50IGlkPSJncmFkLXVjZ2ctZ2VuZXJhdGVkIiBncmFkaWVudFVuaXRzPSJ1c2VyU3BhY2VPblVzZSIgeDE9IjAlIiB5MT0iMCUiIHgyPSIwJSIgeTI9IjEwMCUiPgogICAgPHN0b3Agb2Zmc2V0PSIwJSIgc3RvcC1jb2xvcj0iI2NmZTdmYSIgc3RvcC1vcGFjaXR5PSIxIi8+CiAgICA8c3RvcCBvZmZzZXQ9IjEwMCUiIHN0b3AtY29sb3I9IiM2MzkzYzEiIHN0b3Atb3BhY2l0eT0iMSIvPgogIDwvbGluZWFyR3JhZGllbnQ+CiAgPHJlY3QgeD0iMCIgeT0iMCIgd2lkdGg9IjEiIGhlaWdodD0iMSIgZmlsbD0idXJsKCNncmFkLXVjZ2ctZ2VuZXJhdGVkKSIgLz4KPC9zdmc+);*/
        background: #f9fcf7; /* Old browsers */
        /* IE9 SVG, needs conditional override of 'filter' to 'none' */
        /*background: url(data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiA/Pgo8c3ZnIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgd2lkdGg9IjEwMCUiIGhlaWdodD0iMTAwJSIgdmlld0JveD0iMCAwIDEgMSIgcHJlc2VydmVBc3BlY3RSYXRpbz0ibm9uZSI+CiAgPGxpbmVhckdyYWRpZW50IGlkPSJncmFkLXVjZ2ctZ2VuZXJhdGVkIiBncmFkaWVudFVuaXRzPSJ1c2VyU3BhY2VPblVzZSIgeDE9IjAlIiB5MT0iMCUiIHgyPSIwJSIgeTI9IjEwMCUiPgogICAgPHN0b3Agb2Zmc2V0PSIwJSIgc3RvcC1jb2xvcj0iI2Y5ZmNmNyIgc3RvcC1vcGFjaXR5PSIxIi8+CiAgICA8c3RvcCBvZmZzZXQ9IjEwMCUiIHN0b3AtY29sb3I9IiNmNWY5ZjAiIHN0b3Atb3BhY2l0eT0iMSIvPgogIDwvbGluZWFyR3JhZGllbnQ+CiAgPHJlY3QgeD0iMCIgeT0iMCIgd2lkdGg9IjEiIGhlaWdodD0iMSIgZmlsbD0idXJsKCNncmFkLXVjZ2ctZ2VuZXJhdGVkKSIgLz4KPC9zdmc+);*/
        background: -moz-linear-gradient(top, #f9fcf7 0%, #f5f9f0 100%); /* FF3.6+ */
        background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#f9fcf7), color-stop(100%,#f5f9f0)); /* Chrome,Safari4+ */
        background: -webkit-linear-gradient(top, #f9fcf7 0%,#f5f9f0 100%); /* Chrome10+,Safari5.1+ */
        background: -o-linear-gradient(top, #f9fcf7 0%,#f5f9f0 100%); /* Opera 11.10+ */
        background: -ms-linear-gradient(top, #f9fcf7 0%,#f5f9f0 100%); /* IE10+ */
        background: linear-gradient(to bottom, #f9fcf7 0%,#f5f9f0 100%); /* W3C */
        filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#f9fcf7', endColorstr='#f5f9f0',GradientType=0 ); /* IE6-8 */
    }
    .login-submit:active {
        background: #a4c2f3;
        -webkit-box-shadow: inset 0 1px 5px rgba(0, 0, 0, 0.4), 0 1px rgba(255, 255, 255, 0.1);
        box-shadow: inset 0 1px 5px rgba(0, 0, 0, 0.4), 0 1px rgba(255, 255, 255, 0.1);
    }

    .login-help {
        text-align: center;
    }
    .login-help  a {
        font-size: 11px;
        color: #d4deef;
        text-decoration: none;
        text-shadow: 0 -1px rgba(0, 0, 0, 0.4);
    }
    .login-help a:hover {
        text-decoration: underline;
    }
    .updateComment {
        float: left;
        display: none;
        width:20px;
        height:20px;
        background-image:url(images/icons/check1.png);
        background-repeat: no-repeat;
        background-position: bottom;
        cursor: pointer;

    }
    .editComment {
        /*margin-left: 30px;*/
        width:20px;
        float: left;
        height:20px;
        background-image:url(images/icons/update.png);
        background-repeat: no-repeat;
        background-position: top;
        cursor: pointer;

    }
    .removeComment {
        float: left;
        width:20px;
        height:20px;
        background-image:url(images/icons/remove1.png);
        background-repeat: no-repeat;
        background-position: top;
        cursor: pointer;

    }
    .updateA {
        margin-left: auto;
        margin-right: auto;
        width:20px;
        height:20px;
        background-image:url(images/icons/check1.png);
        background-repeat: no-repeat;
        background-position: bottom;
        cursor: pointer;
    }
    .editA {

        margin-left: auto;
        margin-right: auto;
        width:20px;
        height:20px;
        background-image:url(images/icons/update.png);
        background-repeat: no-repeat;
        background-position: top;
        cursor: pointer;
    }
    .removeA {
        margin-left: auto;
        margin-right: auto;
        width:20px;
        height:20px;
        background-image:url(images/icons/remove1.png);
        background-repeat: no-repeat;
        background-position: top;
        cursor: pointer;
    }
    #appointmentTable td{
        border: none !important;
    }
    #appointmentTable {
        border: none !important;
    }
    .tool-box {
        width:40px;
        height: 40px;
        float:right;
        margin: 0px;
        padding: 0px;
    }

    .tool-box a img {
        width: 40px !important;
        height: 40px !important;
        float: right;
        margin: 0px;
        padding: 0px;
        text-align: right;
    }
    .submenustatus {
        background:#FFFFCC;
        position: absolute;
        top: 30px;
        left:0px;
        /*left: 0px;*/
        z-index: 1000;
        width: 120px;
        display: none;
        margin-left: 10px;
        padding: 0px 0 5px;
        border-radius: 6px;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.45);
    }
    .hidexC{
        width:170px;
        font-size:16px;
    }
</style>
<body>
    <div id="show_comments"   style="width: 50% !important;display: none;position: fixed ;">

    </div>
    <div id="add_campaigns"   style="width: 40% !important;display: none;position: fixed ;">

    </div>
    <div id="show_appointment"  style="width: 70% !important;display: none;margin-left: auto;margin-right: auto;text-align: center;position: fixed ;">

    </div>
    <div id="show_campaigns"   style="width: 70%;display: none;position: fixed ;margin-top: 0px; top: 100px;">

    </div>
    <FORM NAME="CLIENT_COMPLAINT_FORM" METHOD="POST" >
 <br>
        <div style="width: 100px;float: left;margin-left: 2.5%;margin-top: 0px;margin-bottom: 0px;">
            <!--<input  type="button" onclick="history.go(-1);" value="رجوع"/>-->
        </div>
        <div  id="call_center"  style="border: none;clear: both;">

            <!--                <table border="1px" style="width: 96%;" >
                                <td style="width: 46%;border: none;">-->
            <div style="width: 100%;margin-bottom: 0px;border: none;">
                <div style="width:95%;margin-left: auto;margin-right: auto;">
                    <fieldset style="background-color:#b9d2ef;">
                        <legend style="color: #0066cc ;font-size: 20px;"><span> الشركة </span></legend>
                        <div style="width: 40%;float: right;margin-top: 10px;margin-right: 10px;margin-bottom: 10px;">


                            <table align="right" width="100%" class="table" style="background: #f9f9f9;">
                                <tr>
                                    <td class='td' style="display: <%=issueId != null && privilegesList.contains("client_status_change") ? "" : "none"%>">

                                        <div id="changeStatusAll" class="dropdown" style="width:50%;display: <%=clientStatus.equals("11") || clientStatus.equals("14") ? "none" : "inline-table"%>;;margin-left: auto;margin-right: auto;">
                                            <a class="change_status">
                                                <img src="images/arrow-right.ico" width="30px"/>
                                            </a>
                                            <div class="submenustatus">
                                                <ul class="root">
                                                    <li ><a href="#" style="text-align: right" onclick="JavaScript: popupClientStatus();">تقدم الحالة</a></li>
                                                    <li ><a href="#" style="text-align: right" onclick="JavaScript: popupClientReservation();">حجز</a></li>
                                                    <li ><a href="#" style="text-align: right" onclick="JavaScript: popupClientOnhold();">حجز  مرتجع</a></li>
                                                </ul>
                                            </div>
                                        </div>
                                        <img src="images/arrow-right.ico" width="30px"  onclick="JavaScript:popupClientReservation();" id="changeStatusClient"
                                             style="display: <%=clientStatus.equals("14") ? "block" : "none"%>;"/>
                                    </td>
                                    <td class='td' style="display: <%=clientStatus.equals("11") && privilegesList.contains("client_status_reverse") ? "block" : "none"%>;">
                                        <img src="images/arrow-left.ico" width="30px"  onclick="JavaScript:popupReverseStatus();" id="changeStatusReverse" />
                                    </td>
                                    <td style="color: #27272A; text-align: left;" colspan="2">
                                        <label style="font-size: smaller;">COMPANY STATUS</label>
                                        <table align="right" width="100%" class="table" cellpadding="0" cellspacing="0" style="border: 0px black solid;">
                                            <tr>
                                                <td style="text-align:center; background: #f1f1f1;">
                                                    <img src="images/client/cstmr-gr.jpg" height="30px" id="customerCheckGr"
                                                         style="display: <%=clientStatus.equals("11") ? "block" : "none"%>; text-align:center;"/>
                                                    <img src="images/client/cstmr.jpg" height="30px" id="customerCheck"
                                                         style="display: <%=clientStatus.equals("11") ? "none" : "block"%>; text-align:center;"/>
                                                </td>
                                                <td style="text-align:center; background: #f1f1f1;">
                                                    <img src="images/client/cnct-gr.jpg" height="30px" id="contactCheckGr"
                                                         style="display: <%=clientStatus.equals("14") ? "block" : "none"%>; text-align:center;"/>
                                                    <img src="images/client/cnct.jpg" height="30px" id="contactCheck"
                                                         style="display: <%=clientStatus.equals("14") ? "none" : "block"%>; text-align:center;"/>
                                                </td>
                                                <td style="text-align:center; background: #f1f1f1;">
                                                    <img src="images/client/oprt-gr.jpg" height="30px" id="opportunityCheckGr"
                                                         style="display: <%=clientStatus.equals("13") ? "block" : "none"%>; text-align:center;"/>
                                                    <img src="images/client/oprt.jpg" height="30px" id="opportunityCheck"
                                                         style="display: <%=clientStatus.equals("13") ? "none" : "block"%>; text-align:center;"/>
                                                </td>
                                                <td style="text-align:center; background: #f1f1f1; text-align:center;">
                                                    <img src="images/client/lead-gr.jpg" height="30px" id="leadCheckGr"
                                                         style="display:<%=clientStatus.equals("12") ? "block" : "none"%>; "/>
                                                    <img src="images/client/lead.jpg" height="30px" id="leadCheck"
                                                         style="display:<%=clientStatus.equals("12") ? "none" : "block"%>; "/>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <%
                                    if (connectByRealEstate != null && !connectByRealEstate.equals("")
                                            && connectByRealEstate.equals("0")) {
                                %>
                                <tr>
                                    <td style="color: #27272A;" nowrap >كود الشركة</td>
                                    <td class='td' style="display: <%=clientStatus.equals("11") && privilegesList.contains("client_status_reverse") ? "block" : "none"%>;">
                                        &nbsp;
                                    </td>
                                    <td style="text-align:right;border: none;"><label id="num"><%=client.getAttribute("clientNO")%></label></td>
                                </tr>
                                <%
                                    } else {
                                %>
                                <tr>
                                    <td style="color: #27272A;" nowrap >كود الشركة</td>
                                    <td class='td' style="display: <%=clientStatus.equals("11") && privilegesList.contains("client_status_reverse") ? "block" : "none"%>;">
                                        &nbsp;
                                    </td>
                                    <!-- code in real estate-->
                                    <td style="text-align:right;border: none;"><label id="num"><%=client.getAttribute("clientNO")%></label></td>
                                </tr>
                                <%
                                    }
                                %>
                                <tr>
                                    <td style="color: #27272A;" nowrap width="36%" >اسم الشركة</td>
                                    <td class='td' style="display: <%=clientStatus.equals("11") && privilegesList.contains("client_status_reverse") ? "block" : "none"%>;">
                                        &nbsp;
                                    </td>
                                    <td style="text-align:right;background: #f1f1f1;"><label id="clientName"><%=client.getAttribute("name")%></label></td>
                                <input type="hidden" id="clientId" name="clientId" value="<%=client.getAttribute("id")%>"/>
                                </tr>
                                <%
                                if (CompetentEmp != null & CompetentEmp.size() > 0) {
                                %>               
                                <tr >
                                    <td  style="color: #27272A;" width="36%" nowrap >الموظف المختص</td>
                                    <td class='td' style="display: <%=clientStatus.equals("11") && privilegesList.contains("client_status_reverse") ? "block" : "none"%>;">
                                        &nbsp;
                                    </td>
                                    <!--<td style="text-align: right;"><label id="textS"></label><input type="hidden" id="empId" name="empId" value="" /></td>-->
                                    <td style="text-align: right;">


                                        <a href="#" style="color: #005599" onclick="xx()">مشاهدة</a>
                                    </td>
                                </tr>

                                <%                                    
                                }
                                    String clientId = (String) client.getAttribute("id");
                                    customerGrade = customerGradesMgr.getOnSingleKey("key1", clientId);


                                    if (customerGrade != null) {
                                        String grade = (String) customerGrade.getAttribute("gradeId");
                                        String gradeStatus = "";
                                %>
                                <!--tr>
                                    <td  style="color: #000;" ">تقييم الشركة</td>
                                    <%
                                        if (grade.equals("1")) {
                                            gradeStatus = "عادى";
                                        } else if (grade.equals("2")) {
                                            gradeStatus = "جيد";
                                        } else if (grade.equals("3")) {
                                            gradeStatus = "ممتاز";
                                        }

                                    %>
                                    <td style="text-align: right;"><label id="rate" style="float: right;"><%=gradeStatus%></label>
                                        <div style="float: right;">
                                            <select id="choose" style="display: none;margin-left: 10px;width: 60px;font-size: 14PX;">
                                                <option value="1">عادى</option>
                                                <option value="2">جيد</option>
                                                <option value="3">ممتاز</option>

                                            </select>
                                        </div>
                                        <div id="saveRate" style=" display: none;margin-left:7px;margin-right:50px;  "
                                             >
                                            <a  href="#" style="margin-left:7px;  width:20px;
                                                height:20px;
                                                background-image:url(images/icons/icon-32-publish.png);
                                                background-repeat: no-repeat;
                                                background-position: bottom;
                                                float: right;
                                                " onclick="updateClientGrade(this)"></a>
                                        </div>
                                        <div style="display: block;float: right;margin-right: 16px;" id="update">
                                            <a  href="#" style="margin-top: 5px;color: green;font-size:14px; " onclick="changeRate(this)">تعديل</a>
                                        </div>

                                    </td>

                                </tr-->

                                <%
                                    } else {
                                %>
                                <!--tr>
                                    <td  style="color: #000;" ">تقييم الشركة</td>
                                    <td style="text-align: right;"><label id="rate" style="float: right;">عادى</label>
                                        <div style="float: right;">
                                            <select id="choose" style="display: none;margin-left: 10px;width: 60px;font-size: 14PX;">
                                                <option value="1">عادى</option>
                                                <option value="2">جيد</option>
                                                <option value="3">ممتاز</option>

                                            </select>
                                        </div>
                                        <div id="saveRate" style=" display: none;margin-left:7px;margin-right:50px;  "
                                             >
                                            <a  href="#" style="margin-left:7px;  width:20px;
                                                height:20px;
                                                background-image:url(images/icons/icon-32-publish.png);
                                                background-repeat: no-repeat;
                                                background-position: bottom;
                                                float: right;
                                                " onclick="updateClientGrade(this)"></a>
                                        </div>
                                        <div style="display: block;float: right;margin-right: 16px;" id="update">
                                            <a  href="#" style="margin-top: 5px;color: green;font-size:14px; " onclick="changeRate(this)">تعديل</a>
                                        </div>

                                    </td>
                                </tr-->

                                <%
                                    }
                                %> 
                                <tr>
                                    <td nowrap>بيانات الشركة</td>
                                    <td class='td' style="display: <%=clientStatus.equals("11") && privilegesList.contains("client_status_reverse") ? "block" : "none"%>;">
                                        &nbsp;
                                    </td>
                                    <td>
                                        <div class="tool-box" style="width:40px; border:1px solid black; height:40px; float:right; padding: 2px;">
                                            <a href="#" onclick="clientInformation(this)"><image style="height:35px;" src="images/user_red_edit.png" title="Edit"/></a>

                                        </div>
                                        <div class="tool-box" style="width:40px; border:1px solid black; height:40px; float:right; text-align:center; padding: 2px 2px 2px 0px; " id="update">
                                            <a href="#" onclick="printClientInformation(this)"><image style="height:39px;" src="images/pdf_icon.gif" title="Datasheet"/></a>

                                        </div>
                                        <div class="tool-box" style="width:40px; border:1px solid black; height:40px; float:right; padding: 2px;" id="update">
                                            <a id="unbookmarked" href="#" style="width: 16px;height: 32px;float: right; display: <%=bookmarksList != null && bookmarksList.isEmpty() ? "block" : "none"%>"
                                               onclick="popupCreateBookmark(this, '<%=client.getAttribute("id")%>')">
                                                <image src="images/star1.jpg" title="علامة" style="height: 35px;"/></a>
                                            <a id="bookmarked" href="#" style="width: 16px;height: 32px;float: right; display: <%=bookmarksList == null || !bookmarksList.isEmpty() ? "block" : "none"%>"
                                               onclick="deleteBookmark(this, '<%=bookmarkId%>', '<%=client.getAttribute("id")%>')">
                                                <image src="images/star2.jpg" title="<%=bookmarkDetails%>" style="height: 35px;" id="bookmarkedImg"/></a>
                                        </div>
                                              <div class="tool-box" style="width:40px; height:40px; border:1px solid black; float:right; padding: 2px;" id="update">
                                            <a href="#" onclick="printClientInformation(this)"><image style="height:42px;" src="images/finical-rebort.png" title="Financials"/></a>

                                        </div>
                                    </td>

                                </tr>

                            </table>

                        </div>
                        <div style="float: left;width: 50%;margin-top: 10px;" id="tblDataDiv">

                            <table style="width: 400px;padding: 0px;" cellpadding="0" cellspacing="0" border="1px">
                                <tr style="">
                                    <%
                                        String userId = (String) userWbo.getAttribute("userId");
                                        UserMgr um = UserMgr.getInstance();
                                        prvType = securityUser.getClientMenuBtn();
                                        int i = 0;
                                        int x = 0, y = 0;
                                        // userPrevWbo = (WebBusinessObject) groupPrev.get(x);
                                        //  if (userPrevWbo.getAttribute("prevCode").equals("COMMENT")) {
                                        //      userPrevObj.setComment(true);
                                        //  } else if (userPrevWbo.getAttribute("prevCode").equals("FORWARD")) {
                                        //       userPrevObj.setForward(true);
                                        //   } else if (userPrevWbo.getAttribute("prevCode").equals("CLOSE")) {
                                        //        userPrevObj.setClose(true);
                                        //    } else if (userPrevWbo.getAttribute("prevCode").equals("FINISHED")) {
                                        //       userPrevObj.setFinish(true);
                                        //   } else if (userPrevWbo.getAttribute("prevCode").equals("BOOKMARK")) {
                                        //      userPrevObj.setBookmark(true);
                                        //   }
                                        if (groupPrev.size() > 0) {
                                    %>


                                    <%
                                        for (i = 0; i < groupPrev.size(); i++) {
                                            wbo = new WebBusinessObject();
                                            wbo = (WebBusinessObject) groupPrev.get(i);
                                            String userPrevName = (String) wbo.getAttribute("prevCode");
                                            //if (um.getAction2(userPrevName, userId)) {%>

                                    <%   
                                            if (userPrevName.equals("sms")) {
                                    %>
                                    <td style="border: none;background: transparent">
                                        <div style="margin-right: auto;margin-left: auto;width: 100%;"><input type="button"  onclick="popupSms(this);" class="button_sms"></div>
                                    </td>

                                    <%
                                            } else if (userPrevName.equals("email")) {
                                    %>
                                    <td style="border: none;background: transparent">
                                        <div style="margin-right: auto;margin-left: auto;width: 100%;"> <input type="button" onclick="JavaScript: popupEmail(this);" class="button_email" ></div>
                                            <%}%>
                                    </td>
                                    <% //}
                                        }%>


                                </tr>
                                <tr style="">


                                    <%
                                        for (i = 0; i < groupPrev.size(); i++) {
                                            wbo = new WebBusinessObject();
                                            wbo = (WebBusinessObject) groupPrev.get(i);
                                            String userPrevName = (String) wbo.getAttribute("prevCode");
                                            // if (um.getAction2(userPrevName, userId)) {%>
                                    <%
                                            if (userPrevName.equals("comment")) {
                                    %>
                                    <!--                                        <div style="margin-right: auto;margin-left: auto;width: 100%;"> <input type="button" onclick="JavaScript: getComment();" class="button_commen" ></div>-->
                                    <td style="border: none;background: transparent">
                                        <div class="dropdown" style="width: 60%;display: inline-table;">
                                            <a class="button_commen" ></a>

                                            <div class="submenu">
                                                <ul class="root">
                                                    <li ><a href="#" style="text-align: right"  onclick="popupAddComment(this)">إضافة تعليق</a></li>
                                                    <li ><a href="#" style="text-align: right" onclick="popupShowComments(this)">مشاهدة التعليقات</a></li>

                                                </ul>
                                            </div>

                                        </div>            
                                        <%
                                            }
                                        %>
                                    </td>

                                    <%
                                            // }
                                        }%>
                                    <%
                                        for (i = 0; i < groupPrev.size(); i++) {
                                            wbo = new WebBusinessObject();
                                            wbo = (WebBusinessObject) groupPrev.get(i);
                                            String userPrevName = (String) wbo.getAttribute("prevCode");
                                            //   if (um.getAction2(userPrevName, userId)) {%>

                                    <%   
                                            if (userPrevName.equals("pointment")) {
                                    %>
                                    <td style="border: none;background: transparent">
                                        <!--<div style="margin-right: auto;margin-left: auto;width: 100%;"><input type="button"  onclick="popupApp(this);" class="button_pointment"></div>-->
                                        <div class="dropdown" style="width: 60%;display: inline-table;">
                                            <a class="button_pointment" ></a>

                                            <div class="submenu1">
                                                <ul class="root">
                                                    <li ><a href="#" style="text-align: right"  onclick="popupApp(this);" >إضافة مقابلة</a></li>
                                                    <li ><a href="#" style="text-align: right" onclick="popupShowAppointment(this)"> المقابلات</a></li>

                                                </ul>
                                            </div>

                                        </div>     
                                        <%
                                            }
                                        %>
                                    </td>

                                    <%   
                                        if (userPrevName.equals("campagin")) {
                                    %>
                                    <td style="border: none;background: transparent">
                                        <div class="dropdown" style="width: 60%;display: inline-table;">
                                            <a class="button_camp" onclick="popupShowCampagin(this)"></a>

                                        </div>  
                                        <%}%>
                                        <%
                                                // }
                                            }%>
                                    </td>

                                </tr>
                            </table>

                            <% } else {%>
                            <table style="width: 96%;">
                                <tr>
                                    <td style="background-color: #f9e375;"> <b style="font-size: 18px">العمليات الخاصة بالشركة غير متاحة لك من فضلك قم بالإتصال بالإدارة االمختصة</b></td>
                                </tr>
                            </table>
                            <%}%>



                        </div>
                    </fieldset>
                </div>
                <!--                              <div class="dropdown">
                                                            <a class="button_commen" ></a>
                
                                                            <div class="submenu">
                                                                <ul class="root">
                                                                    <li ><a href="#Dashboard" style="text-align: right">إضافة تعليق</a></li>
                                                                    <li ><a href="#Profile" style="text-align: right">مشاهدة التعليقات</a></li>
                                                                 
                                                                </ul>
                                                            </div>
                
                                                        </div>-->
                <%
                if(issueDesc == null || !issueDesc.equalsIgnoreCase("internal")) {
                %>
                <div style="width: 95%;margin-left: auto;margin-right:auto;margin-top: 8px;border: none;">
                    <fieldset  style="background-color: FFFFCC;">
                        <!--                 <img id ="" src="images/icons/plus.png" width="16" height="16" onclick="showCon(this);"/>البيانات التجارية -->
                        <legend style="color: saddlebrown ;font-size: 20px;"><span> الوحدات </span></legend>
                        <!--                        <div style="float: right;width: 30%">
                                                    <table align="right" width="100%" class="table" style="background: #f9f9f9;margin-top: 10px;margin-right: 10px;margin-bottom: 10px;" >
                        
                                                        <tr>
                                                            <td  style="color: #000;" ">الموقف المالى</td>
                                                            <td style="text-align: right;"> <a href="report.pdf" id="openDoc">مشاهدة</a></td>
                                                        </tr>
                                                        <tr>
                                                            <td  style="color: #000;" ">البضائع المحجوزة</td>
                                                            <td style="text-align: right;"> <a href="#" id="openDoc">مشاهدة</a></td>
                                                        </tr>
                        
                                                    </table>
                                                </div>-->
                        <%if (reservedUnit != null && !reservedUnit.isEmpty()) {
                        %>
                        <div style="width: 98%;display: block;margin-top: 10px;float: right;border: none;" id="tblDataDiv">
                            <!--                            <fieldset style="width: 100%;">
                                                            <legend style="color: #FF3300
                            
                                                                    ;">الرغبات</legend>                                     -->
                            <div style="float: right;width: 100%;">
                                <div> <b style="float: right;clear: both;">المشتريات</b></div>
                                <div style="float: right;width: 15%;clear: both;"><hr ></hr></div>
                            </div>
                            <TABLE id="tblData" class="blueBorder" ALIGN="center" dir="<%=dir%>"  width="90%" cellpadding="0" cellspacing="0" style="margin-top: 10px;margin-right: 4%;">
                                <TR>

                                    <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="25%" ><b>الوحدة</b></TD>
                                    <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="15%" id="empNameShown" value=""><b>التصنيف</b></TD>
                                    <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="10%"><b>سعر الشراء</b></TD>
                                    <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="10%"><b>نظام الدفع</b></TD>
                                    <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="10%"><b>مكان الدفع</b></TD>
                                    <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="20%"><b>تاريخ الحجز</b></TD>
                                    <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="20%"><b>الحالة</b></TD>
                                </TR>
                                <%

                                    Enumeration e = reservedUnit.elements();

                                    wbo = new WebBusinessObject();
                                    while (e.hasMoreElements()) {

                                        wbo = (WebBusinessObject) e.nextElement();
                                %>
                                <TR style="padding: 1px;">


                                    <TD style="text-align:center;background: #f1f1f1;font-size: 14px;">

                                        <%if (wbo.getAttribute("productName") != null) {%>
                                        <b><%=wbo.getAttribute("productName")%></b>
                                        <%}%>

                                    </TD>
                                    <TD style="text-align:center;background: #f1f1f1;font-size: 14px;width: 13%;">

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
                                    <TD style="text-align:center;background: #f1f1f1;font-size: 14px;">

                                        <%if (wbo.getAttribute("creationTime") != null) {
                                                String creationTime = (String) wbo.getAttribute("creationTime");
                                                String time = creationTime.substring(0, 16);
                                        %>
                                        <b ><%=time%></b>
                                        <%}%>

                                    </TD>
                                    <TD style="text-align:center;background: #f1f1f1;font-size: 14px;">


                                        <b style="color: red;">محجوزة</b>


                                    </TD>


                                </TR>


                                <%

                                    }

                                %>
                            </TABLE>



                        </div>
                        <%}%>

                        <div style="width: 98%;display: block;margin-top: 10px;" id="tblDataDiv">
                            <!--                            <fieldset style="width: 100%;">
                                                            <legend style="color: #FF3300
                            
                                                                    ;">الرغبات</legend>                                     -->
                            <div style="float: right;width: 100%;">
                                <div> <b style="float: right;clear: both;">الرغبات</b></div>
                                <div style="float: right;width: 15%;clear: both;"><hr ></hr></div>
                            </div>
                            <TABLE id="interestedUnit"  <%if (products != null && !products.isEmpty()) {
                                   %>style="margin-right: 3%;display: block;margin-top: 10px;" <%} else {%>style="display: none;"<%}%>class="blueBorder" ALIGN="center" dir="<%=dir%>" width="90%" cellpadding="0" cellspacing="0">
                                <TR>
                                    <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="32px;" ><b></b></TD>
                                    <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="20%" id="empNameShown" value=""><b>نوع الإستثمار</b></TD>
                                    <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="25%" ><b>المنتج</b></TD>

                                    <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="10%"><b>الميزانية</b></TD>
                                    <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="10%"><b>نظام الدفع</b></TD>
                                    <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="10%"><b>الفترة</b></TD>
                                    <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="25%"><b>الملاحظات</b></TD>
                                </TR>
                                <%if (products != null && !products.isEmpty()) {
                                %>
                                <%

                                    Enumeration q = products.elements();

                                    WebBusinessObject wbo2 = new WebBusinessObject();
                                    while (q.hasMoreElements()) {

                                        wbo2 = (WebBusinessObject) q.nextElement();
                                %>
                                <TR style="padding: 1px;">

                                    <td style="text-align:center;background: #f1f1f1;font-size: 14px;">
                                        <div style="" class="remove" id="remove" onclick="removeRow(this)" value="<%=wbo2.getAttribute("id")%>"> </div>
                                        <div  class="update"  id="updateRow" onclick="updateRow(this)" value="<%=wbo2.getAttribute("id")%>"> </div>
                                        <input id="updateId"  type="hidden" value="<%=wbo2.getAttribute("id")%>"/>
                                        <input id="ID"  type="hidden" value=""/>

                                    </td>

                                    <TD style="text-align:center;background: #f1f1f1;font-size: 14px;width: 13%;">

                                        <%if (wbo2.getAttribute("productCategoryName") != null) {%>
                                        <b id="2"><%=wbo2.getAttribute("productCategoryName")%></b>
                                        <input type="hidden" id="productCategoryId" value='<%=wbo2.getAttribute("productCategoryId")%>' />
                                        <input type="hidden" id="projectId" value='<%=wbo2.getAttribute("projectId")%>' />
                                        <%}
                                        %>

                                    </TD>
                                    <TD style="text-align:center;background: #f1f1f1;font-size: 14px;">

                                        <%if (wbo2.getAttribute("productName") != null) {%>
                                        <input type="hidden" id="rowId" value="<%=wbo2.getAttribute("id")%>" />
                                        <b id="1"><%=wbo2.getAttribute("productName")%></b>
                                        <%}%>

                                    </TD>
                                    <TD style="text-align:center;background: #f1f1f1;font-size: 14px;">

                                        <%if (wbo2.getAttribute("budget") != null) {%>
                                        <b id="3"><%=wbo2.getAttribute("budget")%></b>
                                        <%}%>

                                    </TD>
                                    <TD style="text-align:center;background: #f1f1f1;font-size: 14px;">

                                        <%if (wbo2.getAttribute("paymentSystem") != null) {%>
                                        <b id="4"><%=wbo2.getAttribute("paymentSystem")%></b>
                                        <%}%>

                                    </TD>
                                    <TD style="text-align:center;background: #f1f1f1;font-size: 14px;">

                                        <%if (wbo2.getAttribute("period") != null) {%>
                                        <b id="5"><%=wbo2.getAttribute("period")%></b>
                                        <%}%>

                                    </TD>
                                    <TD style="text-align:center;background: #f1f1f1;font-size: 14px;">

                                        <%if (wbo2.getAttribute("note") != null) {
                                                String note = (String) wbo2.getAttribute("note");
                                                String time = "";
                                                if (note.length() > 17) {
                                                    time = note.substring(0, 16) + "...";
                                                } else {
                                                    time = note;
                                                }
                                        %>
                                        <b id="6" onMouseOver="Tip('<%=note%>', LEFT, true, OFFSETX, 0, BGCOLOR, '#FFFF99', FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT, 'BOLD', TITLEALIGN, 'center', TITLEFONTCOLOR, 'black', TITLEBGCOLOR, '#6699FF')" onMouseOut="UnTip()"><%=time%></b>
                                        <b style="display: none" id="7"><%=note%></b>
                                        <%}%>

                                    </TD>
                                </TR>



                                <%

                                    }

                                %>   <% }%>   
                            </TABLE>

                            <div style="margin-top: 7px;"><input type="button" value="إضافة رغبات" id="Btn" onclick="popup(this)" /></div>

                        </div>
                    </fieldset>

                </div>
                <%
                }
                %>
                <!--                </td>
                                <td style="width: 46%;text-align: right;margin-right: 54%;border: none;">-->



                <div style="clear: both"></div>
                <div style="width: 30%; display: block;margin-top: 10px;float: right;" id="tblDataDiv">

                </div>

            </div>

            <div style="clear:both"></div>

        </div>

        <!-- client infromation popup -->
        <div id="clientInformation" style="width: 35%;display: none;position:fixed;">

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
                    <!--<table align="right" width="30%" class="login" style="display: none;color: white" id="" cellpadding="3px;" cellspacing="3px;">-->
                    <%
                        //  if (connectByRealEstate != null && !connectByRealEstate.equals("")
                        //     && connectByRealEstate.equals("1")) {
                    %>


                    <tr>
                        <td width="40%"style="color: #27272A;text-align: match-parent" >كود الشركة</td>
                        <td style="text-align:right;border: none;">
                            <label style="float: right;" id="clientNO"><%=client.getAttribute("clientNO").toString()%></label>
                            <hr style="float: right;width: 70%;clear: both;" >
                        </td>
                    </tr>
                    <!--                                <tr>
                                                        <td width="40%" style="color: #000;" >كود الشركة</td>
                                                        <td style="text-align:right;border: none;"><label style="color: #ffffff;" id="clientNO"><%=client.getAttribute("clientNO")%></label>
                                                            <hr style="float: right;width: 70%;clear: both;" 
                    
                                                        </td>
                                                    </tr>-->

                    <tr>
                        <td style="color: #27272A;" width="40%" >اسم الشركة</td>
                        <td style="text-align:right;"><label class="showx" id="clientName"><%=client.getAttribute("name")%></label>
                            <hr style="float: right;width: 70%;" class="showx">
                            <input type="text"  name="clientName" class="hidex" value="<%=client.getAttribute("name")%>"/>
                            <input type="hidden" id="hideName" value="<%=client.getAttribute("name")%>" />
                            <% String mail = "";
                                if (client.getAttribute("email") != null) {
                                    mail = (String) client.getAttribute("email");
                                }
                            %>
                            <input type="hidden" id="hideEmail" value="<%=mail%>" />
                            <input type="hidden" id="clientId" name="clientId" value="<%=client.getAttribute("id")%>"/>
                        </td>

                    </tr>


                    <%if (client.getAttribute("phone") != null && !client.getAttribute("phone").equals("")) {
                    %>

                    <tr>
                        <td style="color: #27272A;" width="40%" >رقم التليفون</td>
                        <td style="text-align:right;"><label class="showx" id="phone"><%=client.getAttribute("phone")%></label>
                            <hr style="float: right;width: 70%;" class="showx">

                            <input type="text"  name="phone" class="hidex" value="<%=client.getAttribute("phone")%>" onkeypress="javascript:return isNumber(event)"/>
                        </td>
                    </tr>
                    <%} else {%>
                    <tr>
                        <td style="color: #27272A;" width="40%" >رقم التليفون</td>
                        <td style="text-align:right;"><label class="showx" id="phone"></label>
                            <hr style="float: right;width: 70%;" class="showx">
                            <input type="text" name="phone" class="hidex" value="" onkeypress="javascript:return isNumber(event)"/>
                        </td>
                    </tr>
                    <%}%>
                    <tr>
                        <td style="color: #27272A;" width="40%" >رقم الموبايل</td>
                        <td style="text-align:right;"><label  class="showx" id="client_mobile"><%=client.getAttribute("mobile")%></label>
                            <hr style="float: right;width: 70%;" class="showx">

                            <input type="text"  name="client_mobile" class="hidex" value="<%=client.getAttribute("mobile")%>" onkeypress="javascript:return isNumber(event)"/>
                        </td>
                    </tr>
                    <%if (client.getAttribute("address") != null && !client.getAttribute("address").equals("")) {
                    %>
                    <tr>
                        <td style="color: #27272A;"  width="40%">العنوان</td>
                        <td style="text-align:right;"><label class="showx" id="address"><%=client.getAttribute("address")%></label>
                            <hr style="float: right;width: 70%;" class="showx">

                            <input type="text"  name="address" class="hidex" value="<%=client.getAttribute("address")%>"/>
                        </td>
                    </tr>
                    <%} else {%>
                    <tr>
                        <td style="color: #27272A;"  width="40%">العنوان</td>
                        <td style="text-align:right;"><label class="showx"  id="address"></label>
                            <hr style="float: right;width: 70%;" class="showx">
                            <input type="text"  name="address" class="hidex" value=""/>
                        </td>
                    </tr>

                    <%}%>
                    <%if (client.getAttribute("email") != null && !client.getAttribute("email").equals("")) {
                    %>
                    <tr>
                        <td style="color: #27272A;"  width="30%" >البريد الإلكترونى</td>
                        <td style="text-align:right;"><label  class="showx"  id="email"><%=client.getAttribute("email")%></label>
                            <hr style="float: right;width: 90%;" class="showx">

                            <input type="text"  name="email" class="hidex" value="<%=client.getAttribute("email")%>"/>
                        </td>
                    </tr>
                    <%} else {%>
                    <tr>
                        <td style="color: #27272A;"  width="30%" >البريد الإلكترونى</td>
                        <td style="text-align:right;"><label  class="showx"  id="email"></label>
                            <hr style="float: right;width: 90%;" class="showx">
                            <input type="text"  name="email" class="hidex" value=""/>
                        </td>
                    </tr>
                    <%}%>


                    <tr>
                        <td colspan="2">
                            <div style="text-align: center;">
                                <div id="editBtn" style="display: none;">
                                    <input type="button"  value="edit" onclick="edit_Client2(this)"  />
                                </div>
                                <div id="updateBtn" style="display: none;">
                                    <input type="button" value="update" onclick="updateClient(this)" />
                                </div>
                            </div>
                        </td>
                    </tr>

                    <%//}%>
                </table>
            </div>
        </div>

        <div id="unit_content" style="display: none;width: 30%;position: fixed">
            <!--<form name="email_form">-->
            <div style="clear: both;margin-left: 88%;margin-top: 0px;margin-bottom: -38px;z-index: -10000000;">
                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                     -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                     box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                     -webkit-border-radius: 100px;
                     -moz-border-radius: 100px;
                     border-radius: 100px;" onclick="closePopup(this)"/>
            </div>

            <!--<h1>رسالة قصيرة</h1>-->
            <div class="login" style="width: 85%;margin-bottom: 10px;margin-left: auto;margin-right: auto;">
                <table  border="0px" class="table" style="width:100%;text-align: right;" >
                    <!--                    <tr align="center" align="center" style="border: none">
                                            <td colspan="2"  style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 30%;">إضافة رغبات</td>
                                        </tr>-->
                    <tr align="center" align="center" style="border: none">
                        <td colspan="2"  style="font-size:16px;"><b style="color: green;font-size: 18px;"id="msg"></b></td>
                    </tr>
                    <tr style="border: none">
                        <td style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 30%;" >نوع الإستثمار</td>
                        <td width="70%" style="text-align:right;">
                            <SELECT name='mainProduct' id='mainProduct' style='width:170px;font-size:16px;' onchange="getSubProduct(this.value)" onclick="getSubProduct(this.value)">
                                <option>----</option>
                                <%
                                    if (mainCatsTypes != null && !mainCatsTypes.isEmpty()) {
                                        for (WebBusinessObject Wbo : mainCatsTypes) {
                                            String productName = (String) Wbo.getAttribute("projectName");
                                            String productId = (String) Wbo.getAttribute("projectID");%>
                                <option id="proId"value='<%=productId%>'><b id="projectN"><%=productName%></b></option>

                                <%}
                                    }%>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 30%;">المنتج</td>
                        <td style="text-align:right;"><b id="reservedPlace"></b>
                            <SELECT name='subProduct' id='subProduct' style='width:170px;font-size:16px;' disabled="disabled">
                                <option>----</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 30%;">الميزانية</td>
                        <td style="text-align:right;">
                            <input type="text" name="budget" id="budget" style="width: 130px;" onkeypress="javascript:return isNumber(event)"/>
                        </td>


                    </tr>
                    <tr>
                        <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 30%;">الفترة</td>
                        <td style="text-align:right;">
                            <SELECT name='period' id='period' style="font-size: 15px;"> 
                                <OPTION value="سنه">سنه</OPTION> <OPTION value="سنتين">سنتين</OPTION> 
                                <% for (int c = 3; c <= 10; c++) {%> 
                                <OPTION value='<%=c%>سنين'><%=c%>سنين</OPTION> 
                                <% }%>
                                <% for (int c = 11; c <= 15; c++) {%> 
                                <OPTION value='<%=c%>سنه'><%=c%>سنه</OPTION> 
                                <% }%>
                            </SELECT>
                        </td>
                    </tr>



                    <tr>
                        <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 30%;">نظام الدفع</td>
                        <td style="text-align:right;">
                            <SELECT name='paymentSystem' id='paymentSystem' style="font-size: 15px;"> 
                                <OPTION>نقدى</OPTION>
                                <OPTION>تقسيط</OPTION>
                            </SELECT>
                        </td>
                    </tr>
                    <tr>
                        <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 30%;">ملاحظات</td>
                        <td style="text-align:right;">
                            <TEXTAREA cols='30' rows='3' name='unitNotes' id='unitNotes' style="width: 100%;"></TEXTAREA>
                        </td>
                    </tr>

                    <tr>
                        <td colspan="2" style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 30%;text-align: center;"> 


                            <input type="submit" value="إضافة" id="addUnit"onclick="javascript: addUnit(this)" style="font-size: 15px;font-family: serif;display: none;"/>
                            <input type="submit" value="تحديث" id="updateUnit"onclick="javascript:updateUnit(this)" style="font-size: 15px;font-family: serif;display: none;margin-left: auto;margin-right: auto;"/>
                        </td>

                    </tr>
                </table>
            </div>

            <!--            </form>-->
        </div>  
        <!--email popup -->

        <div id="email_content"  style="width: 30%;display: none;position: fixed;margin-left: auto;margin-right: auto">

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
                <form id="myForm" action="<%=context%>/EmailServlet?op=sendByAjax" method="post" enctype="multipart/form-data">
                    <table class="table " style="width:100%;">

                        
                        <tr >
                            <td style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 30%;">كود الشركة</td>
                            <td style="text-align:right;width: 70%;">
                                <b id="clientNo" ></b>
                            </td>


                        </tr>
                        <tr>
                            <td style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 30%;">إسم الشركة</td>
                            <td style="text-align:right;width: 70%;">
                                <!--<input type="text" readonly="true" id="clientName" style="float: right;"/>-->
                                <!--<b id="clientName" style="float: right;"></b>-->

                                <input type="text" id="clientNa" class="login-input" />
                            </td>
                        </tr>
                        <tr>
                            <%  mail = "";
                                if (client.getAttribute("email") != null) {
                                    mail = (String) client.getAttribute("email");
                                }
                            %>
                            <td style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 30%;">إلى</td>
                            <td style="text-align:right;width: 70%;">
                                <input type="text" id="email" value="<%=mail%>"name="to" style="float: right;" class="login-input"/>
                                <!--<b id="email" style="float: right;"></b>-->
                            </td>
                        </tr>



                        <tr>
                            <td style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 30%;" >موضوع الرسالة</td>
                            <td style="text-align:right;width: 70%;">
                                <input type="text" size="60" maxlength="60" id="subj" name="subject" class="login-input"/>
                            </td>
                        </tr>
                        <tr>
                            <td style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 30%;"><lable>إرفاق ملف</lable>
                        <input type="button" id="addFile" onclick="addFiles(this)" value="+" />

                        <input id="counter" value="" type="hidden" name="counter"/>
                        </td>
                        <td style="text-align:right;width: 70%;" id="listFile"> 

                            <!--                        <input type="file"  style="float: right;" name="file1" id="file1" class="login-input" maxlength="60"/>
                                                    <input type="file" style="float: right;display: none" name="file2" id="file2" class="login-input" maxlength="60"/>
                                                    <input type="file"  style="float: right;display: none" name="file3" id="file3" class="login-input" maxlength="60"/>-->

                        </td>

                        </tr>
                        <tr>
                            <td style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 30%;">نص الرسالة</td>
                            <td  style="width: 70%;">

                                <textarea placeholder="محتوى الرسالة" rows="8" cols="10" name="message"  id="msgContent"class="login-input" style="height: 100px;"></textarea>
                            </td>

                        </tr> 


                    </table>
                    <div style="width: 30%;text-align: center;margin-left: auto;margin-right: auto;" id="status"></div>

                    <div id="message" style="margin-left: auto;margin-right: auto;text-align: center"></div>
                    <input type="submit" value="إرسال"  class="login-submit" style="margin-left: auto;margin-right: auto;text-align: center" onclick="sendMailByAjax(this)" />

                </form>
                <div id="progressx" style="display: none;">
                    <img src="images/Loading2.gif" width="32px" height="32px;" style="background-repeat: no-repeat;margin-left: auto;margin-right: auto"/>
                </div>
            </div>

        </div>  
        <div id="add_comments"  style="width: 30% ;margin-right: auto ;margin-left: auto;display: none;position: fixed;top: 0%;"><!--class="popup_appointment" -->

            <div style="clear: both;margin-left: 88%;margin-bottom: -38px;z-index: -10000000;">
                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                     -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                     box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                     -webkit-border-radius: 100px;
                     -moz-border-radius: 100px;
                     border-radius: 100px;" onclick="closePopup(this)"/>
            </div>

            <!--<h1>رسالة قصيرة</h1>-->
            <div class="login" style="width: 85%;margin-bottom: 10px;margin-left: auto;margin-right: auto;">

                <table  border="0px"  style="width:100%;"  class="table">

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
                    <tr>
                        <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 30%;">التعليق</td>
                        <td style="width: 70%;" >

                            <textarea  placeholder="" style="width: 100%;height: 80px;" id="commentCompany" > </textarea>
                        </td>

                    </tr> 
                </table>
                <div style="text-align: center;margin-left: auto;margin-right: auto;clear: both" >
                    <input type="button" value="حفظ"   onclick="saveComment(this)" id="saveComm"class="login-submit"/></div>                             </form>
                <!--<div style="clear: both;display: none"></div>-->
                <div id="progress" style="display: none;">
                    <img src="images/Loading2.gif" width="32px" height="32px;" style="background-repeat: no-repeat;margin-left: auto;margin-right: auto"/>
                </div>
                <div style="margin: 0 auto;display: none; width: 90%;text-align: center;color: white;font-size: 16px;font-weight: bold" id="commMsg">
                    تم إضافة التعليق
                </div>


            </div>  
        </div>

        <div id="sms_content"    style="width: 30% !important;display: none;position: fixed">
            <div style="clear: both;margin-left: 88%;margin-top: 0px;margin-bottom: -38px;z-index: -10000000;">
                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                     -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                     box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                     -webkit-border-radius: 100px;
                     -moz-border-radius: 100px;
                     border-radius: 100px;" onclick="closePopup(this)"/>
            </div>

            <!--<h1>رسالة قصيرة</h1>-->
            <div class="login" style="width: 85%;margin-bottom: 10px;margin-left: auto;margin-right: auto;">
                <table class="table " style="width:100%;">


                    <tr>
                        <td style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 30%;">كود الشركة</td>
                        <td style="text-align:right;width: 70%;">


                            <b id="client_No" style="float: right;"></b>


                        </td>


                    </tr>
                    <tr >
                        <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 30%;">إسم الشركة</td>
                        <td style="text-align:right;width: 70%;">
                            <!--<input type="text" readonly="true" id="clientName" style="float: right;"/>-->
                            <b id="client_Na" style="float: right;"></b>
                        </td>
                    </tr>
                    <tr >
                        <td style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 30%;">رقم الموبايل</td>
                        <td style="text-align:right;width: 50%;">
                            <!--<input type="text" readonly="true" id="clientName" style="float: right;"/>-->
                            <input type="text" class="login-input" id="mobile" style="float: right;width: 70%;"></b>
                        </td>
                    </tr>

                    <tr>
                        <td style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 30%;">نص الرسالة</td>
                        <td  style="width: 70%;">

                            <textarea placeholder="محتوى الرسالة" rows="5" cols="10" class="login-input" style="height: 60px;"></textarea>
                        </td>

                    </tr> 


                </table>
                <div style="text-align: center;margin-left: auto;margin-right: auto;width: 100%;clear: both;" > 
                    <input type="submit" value="إرسال" onclick="javascript: reservedUnit(this)" class="login-submit"/>
                </div>
            </div>
        </div>  







        <div id="appointment_content" style="width: 30% !important;display: none;position: fixed"><!--class="popup_appointment" -->
            <!--<h1>تحديد مقابلة</h1>-->
            <div style="clear: both;margin-left: 88%;margin-top: 0px;margin-bottom: -38px;z-index: -10000000;">
                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                     -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                     box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                     -webkit-border-radius: 100px;
                     -moz-border-radius: 100px;
                     border-radius: 100px;" onclick="closePopup(this)"/>
            </div>

            <!--<h1>رسالة قصيرة</h1>-->
            <div class="login" style="width: 85%;margin-bottom: 10px;margin-left: auto;margin-right: auto;">
                <table class="table " style="width:100%;">

                    <tr >
                        <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 30%;" >
                            إسم الشركة                           
                        </td>
                        <td width="70%"style="text-align:right;">
                            <!--<input type="text" readonly="true" id="clientName" style="float: right;"/>-->
                            <b id="appClientName"></b>
                        </td>
                    </tr>
                    <tr>
                        <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 30%;">موضوع المقابلة</td>
                        <td  style="text-align:right;width: 70%;">

                            <input  type="text" id="appTitle" style="float: right;" class="login-input" required="required"/>
                            <label id="appTitleMsg"></label>
                        </td>
                    </tr>
                    <tr>
                        <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 30%;">تاريخ المقابلة</td>
                        <td style="width: 70%;" >
                            <input class="login-input" name="entryDate" id="appDate" type="text" size="50" maxlength="50" style="width:80%;float: right;" value="<%=(entry_Date == null) ? nowTime : entry_Date%>"/>
                        </td>

                    </tr> 
                    <tr>
                        <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 30%;">ملاحظات المقابلة</td>
                        <td style="width: 70%;" >

                            <textarea  placeholder="" style="width: 100%;height: 60px;" id="appNote" class="login-input" maxlength="500"/>
                        </td>

                    </tr> 

                </table>

                <div style="text-align: center;margin-left: auto;margin-right: auto;" > <input type="submit" value="حفظ" onclick="javascript: saveAppo(this)" class="login-submit"/></div>
                <div id="progress" style="display: none;">
                    <img src="images/Loading2.gif" width="32px" height="32px;" style="background-repeat: no-repeat;margin-left: auto;margin-right: auto"/>
                </div>

                <div style="margin: 0 auto;display: none; width: 90%;text-align: center;color: white;font-size: 16px;font-weight: bold" id="appMsg">تم إضافة المقابلة </>
                </div>
            </div>  






            <%           if (CompetentEmp != null & CompetentEmp.size() > 0) {%>                
            <div id="showEmployees" style="display: none;width: 30%;margin-left: auto;margin-right: auto;">

                <div style="clear: both;margin-left: 88%;margin-top: 0px;margin-bottom: -38px;z-index: -10000000;">
                    <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                         -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                         box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                         -webkit-border-radius: 100px;
                         -moz-border-radius: 100px;
                         border-radius: 100px;" onclick="closePopup(this)"/>
                </div>
                <div class="login" style="width: 90%;float: left;margin: 0px 0xp;">
                    <table style="width: 100%;" dir="rtl" class="login">

                        <tr style="background-color: #f1f1f1">
                            <td>#</td>
                            <td >إسم الموظف</td>
                            <td>الإدارة</td>
                            <td style="display: none;" d="showTd"></td>
                        </tr>



                        <% int q = 1;
                            String department = "";
                            if (CompetentEmp != null & !CompetentEmp.isEmpty()) {
                                for (WebBusinessObject wbo2 : CompetentEmp) {

                                    WebBusinessObject data = new WebBusinessObject();
                                    data = userMgr.getOnSingleKey((String) wbo2.getAttribute("userId"));
                                    String CompetentEmpName = (String) data.getAttribute("userName");
                                    if (CompetentEmpName == null) {
                                        CompetentEmpName = "";
                                    }
                                    String CompetentEmpId = (String) data.getAttribute("userId");
                                    UserTradeMgr userTradeMgr = UserTradeMgr.getInstance();
                                    data = new WebBusinessObject();
                                    data = userTradeMgr.getOnSingleKey("key1", CompetentEmpId);

                                    if (data != null) {

                                        department = (String) data.getAttribute("tradeName");
                                    } else {
                                        department = "لا ينتمى إلى إدارة";
                                    }


                        %>

                        <tr>
                            <td><%=q%>
                                <input type="hidden" id="empId" name="empId" value="<%=CompetentEmpId%>" />

                            </td>
                            <td ><%=CompetentEmpName%></td>
                            <td ><%=department%></td>
                            <td style="display: none;" id="showTd"><div class="save2" onclick='saveOrderEmp(this)'></div></td>
                            <td style="display: none;" id="showTd2"><div class="save3" onclick='saveComplaintEmp(this)'></div></td>
                            <td style="display: none;" id="showTd3"><div class="save4" onclick='saveQueryEmp(this)'></div></td>
                        </tr>


                        <%q++;
                                }
                            }%>

                    </table>
                </div>
            </div>
            <% }%>
            <div id="clientStatus"  style="width: 40%;display: none;position: fixed">
                <div style="clear: both;margin-left: 93%;margin-top: 0px;margin-bottom: -38px;z-index: -10000000;">
                    <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);background-color: transparent;
                 -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                 box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                 -webkit-border-radius: 100px;
                 -moz-border-radius: 100px;
                 border-radius: 100px;" onclick="closePopup(this)"/>
                </div>
                <div class="login" style="width:90%;margin-left: auto;margin-right: auto;">
                    <center><b style="font-weight: bolder; color: #3f65b7; font-size: medium;">تغيير حالة العميل</b></center>
                    <table  border="0px" class="table" style="width:100%;text-align: right;margin-bottom: 10px !important;margin-left: auto;margin-right: auto;" >                
                        <tr>
                            <td style="width: 40%;"> <label style="width: 100px;">ملاحظات</label></TD>
                            <td style="width: 60%;"><TEXTAREA cols="40" rows="5" name="clientStatusNotes" id="clientStatusNotes"></TEXTAREA></TD>
                        </TR>
                        <tr>
                            <td style="width: 40%;"> <label style="width: 100px;">التاريخ</label></TD>
                            <td style="width: 60%;">  <input name="clientStatusDate" id="clientStatusDate" type="text" size="40" maxlength="50" style="width:50%;float: right;font-size: 12px;" value="<%=nowTime%>"/></TEXTAREA></TD>
                        </TR>
                        <tr>
                            <td colspan="2" >
                                <input type="button" value="حفظ" onclick="JavaScript:changeStatus(this);" class="login-submit" id="changeStatusBtn"/>
                            </TD>
                        </tr>
                        <tr>
                            <td colspan="2" >
                                <div style="margin: 0 auto;display: none; width: 90%;text-align: center;color: white" id="clientStatusMsg">تم تغيير حالة العميل بنجاح</>
                            </td>
                        </tr>
                    </TABLE>
                </div>

            </div>
            <div id="reverseStatus"  style="width: 40%;display: none;">
                <div style="clear: both;margin-left: 93%;margin-top: 0px;margin-bottom: -38px;z-index: -10000000;">
                    <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);background-color: transparent;
                 -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                 box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                 -webkit-border-radius: 100px;
                 -moz-border-radius: 100px;
                 border-radius: 100px;" onclick="closePopup(this)"/>
                </div>
                <div class="login" style="width:90%;margin-left: auto;margin-right: auto;">
                    <center><b style="font-weight: bolder; color: #3f65b7; font-size: medium;">أرجاع لعميل جديد</b></center>
                    <table  border="0px" class="table" style="width:100%;text-align: right;margin-bottom: 10px !important;margin-left: auto;margin-right: auto;" >                
                        <tr>
                            <td style="width: 40%;"> <label style="width: 100px;">ملاحظات</label></TD>
                            <td style="width: 60%;"><TEXTAREA cols="40" rows="5" name="reverseStatusNotes" id="reverseStatusNotes"></TEXTAREA></TD>
                        </TR>
                        <tr>
                            <td style="width: 40%;"> <label style="width: 100px;">التاريخ</label></TD>
                            <td style="width: 60%;">  <input name="reverseStatusDate" id="reverseStatusDate" type="text" size="40" maxlength="50" style="width:50%;float: right;font-size: 12px;" value="<%=nowTime%>"/></TEXTAREA></TD>
                        </TR>
                        <tr>
                            <td colspan="2" >
                                <input type="button" value="حفظ" onclick="JavaScript:reverseStatus(this);" class="login-submit" id="reverseStatusBtn"/>
                            </TD>
                        </tr>
                        <tr>
                            <td colspan="2" >
                                <div style="margin: 0 auto;display: none; width: 90%;text-align: center;color: white" id="reverseStatusMsg">تم تغيير حالة العميل بنجاح</>
                            </td>
                        </tr>
                    </TABLE>
                </div>
            </div>
            <div id="reserveDialog" style="display: none;width: 70%;position: fixed; z-index: 1000; top: 0px; left: 0px;" >
            <div style="clear: both;margin-left: 90%;margin-top: 0px;margin-bottom: -40px;">
                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                 -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                 box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                 -webkit-border-radius: 20px;
                 -moz-border-radius: 20px;
                 border-radius: 20px;" onclick="closePopup(this)"/>
            </div>
            <div class="backgroundTable" style="text-align: center; width: 100%">
                <table  width="100%" cellpadding="0" cellspacing="0" style="">
                    <tr>
                       <td>
                            <input type="hidden" id="clientId" name="clientId"/>
                            <input name="reserveUnit" type="submit" value="حجز الأن" onclick="javascript: reservedUnit(this)"/>
                        </td>
                        <th class="titlebar">
                            <font color="#005599" size="4">حجز وحدة / فيلا</font>
                        </th>
                    </tr>
                </table>
                
                <TABLE class="backgroundTable" width="100%" CELLPADDING="0" CELLSPACING="8" ALIGN="CENTER" DIR="<%=dir%>">
                    <tr>
                        <td width="2%" class="backgroundHeader" nowrap>مسئول المبيعات</td>
                        <td width="5%" style="color:blue; font-size: 16px;font-weight: bold; text-align: right;" class="backgroundHeader">
                        <%=(String) userWbo.getAttribute("userName")%>
                        </td>
                    </tr>
                    
                    <tr>
                        <td class="titlebar" colspan="4">
                            <font color="red" size="3">بيانات الوحدة/ الفيلا</font>
                        </td>
                    </tr>
                    
                    <tr>
                        <td width="20%"  style="text-align: right;" class="backgroundHeader" nowrap>كود الوحدة  / الفيلا</td>
                        <td width="30%" style="text-align: right;"class="backgroundHeader">
                        <table class="hidex" style="display: block;" ALIGN="Right"  dir="RTL" border="0" id="regionTable">
                                <tr>
                                    <td style="<%=style%>" class="td2">
                                        <input class="hidexC" type="text" readonly id="unitCode" name="unitCode" value="" />
                                        <input type="hidden" id="unitId" name="unitId"/>
                                        <input type="hidden" id="parentId" name="parentId"/>
                                        <input type="hidden" id="changeStatus" name="changeStatus"/>
                                    </td>
                                    <td style="border: 0px">
                                        <input type="button" onclick="return getDataInPopup('ProjectServlet?op=getAllAvailableUnits&fieldName=PROJECT_NAME&fieldValue=' + getASSCIChar($('#unitCode').val()) + '&formName=CLIENT_COMPLAINT_FORM&selectionType=single');"  value="<%=search%>">
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    
                    <tr>   
                        <td width="20%" style="text-align: right;" class="backgroundHeader" nowrap>مساحة المباني / الوحدة</td>
                        <td width="30%"style="text-align:right;" class="backgroundHeader">
                            <input type="number" size="7" maxlength="7" id="buildingArea" name="buildingArea" style='width:170px;'/>
                        </td>
                        <td width="20%" style="text-align: right;" class="backgroundHeader" nowrap>مساحة الارض</td>
                        <td width="30%"style="text-align:right;" class="backgroundHeader">
                            <input type="number" size="7" maxlength="7" id="plotArea" name="plotArea" style='width:170px;'/>
                        </td>
                    </tr>
                    
                    <tr>
                        <td width="20%"  style="text-align: right;" class="backgroundHeader" nowrap>دور الوحدة</td>
                        <td width="30%"style="text-align:right;" class="backgroundHeader">
                            <input type="text" size="7" maxlength="40" name="floorNumber" id="floorNumber" style='width:170px;'/>
                        </td>
                        <td width="20%"  style="text-align: right;" class="backgroundHeader" nowrap>النموذج</td>
                        <td width="30%"style="text-align:right;" class="backgroundHeader">
                            <input type="text" size="7" maxlength="7" name="modelNo" id="modelNo" style='width:170px;'/>
                        </td>
                    </tr>

                    <tr>
                        <td width="20%" style="text-align: right;" class="backgroundHeader" nowrap>قيمة الوحدة/ الفيلا قبل الخصم</td>
                        <td width="30%"style="text-align:right;" class="backgroundHeader">
                            <input type="number" size="7" maxlength="7" id="beforeDiscount" name="beforeDiscount" style='width:170px;'/>
                        </td>
                        
                         <td width="2%" style="text-align: right;" class="backgroundHeader" nowrap>فقط</td>
                         <td width="48%"style="text-align:right;" class="backgroundHeader">
                             <textarea name="beforeDiscountText" id="beforeDiscountText" style='width:250px; height: 50px; background: #FFFF99'></textarea>
                        </td> 
                       
                    </tr>
                    
                 <tr align="left">

                     <td width="20%" style="text-align: right;" class="backgroundHeader" nowrap>قيمة الوحدة / الفيلا</td>
                        <td width="30%"style="text-align:right;" class="backgroundHeader">
                            <input type="number" size="7" maxlength="7" id="unitValue" name="unitValue" style='width:170px;'/>
                        </td>
                     <td width="20%" style="text-align: right;" class="backgroundHeader" nowrap>فقط</td>
                   <td width="40%"style="text-align:right;" class="backgroundHeader">
                       <textarea name="unitValueText" id="unitValueText" style='width:250px; height: 50px; background: #FFFF99'></textarea>
                        </td> 
                    </tr>
                    
                    <tr>
                        <td class="titlebar" colspan="4">
                            <font color="red" size="3">بيانات الحجز</font>
                        </td>
                    </tr>
                    
                    <tr>
                        <td width="25%" style="text-align: right;" class="backgroundHeader" nowrap>تاريخ الحجز</td>
                        <td width="25%"style="text-align:right;" class="backgroundHeader">
                            <input type="text" size="7" maxlength="7" readonly id="reservationDate" name="reservationDate"
                                   style='width:170px;' value="<%=reservationDateStr%>"/>
                        </td>
                        <td width="25%" style="text-align: right;" class="backgroundHeader" nowrap>مدة الحجز </td>
                        <td width="25%"style="text-align:right;" class="backgroundHeader">
                            <input type="number" size="7" maxlength="7" id="period2" name="period2" style='width:170px;'/>
                        </td>
                    </tr>
                    
                    <tr>
                        <td width="25%" style="text-align: right;" class="backgroundHeader" nowrap>دفعة التعاقد</td>
                        <td width="25%"style="text-align:right;" class="backgroundHeader">
                            <input type="number" size="7" maxlength="7" id="contractValue" name="contractValue" style='width:170px;'/>
                        </td>
                        
                   <td width="20px" style="text-align: right;" class="backgroundHeader" nowrap>فقط</td>
                   <td width="40%"style="text-align:right;" class="backgroundHeader">
                   <textarea id="contractValueText" name="contractValueText" style='width:250px; height: 50px; background: #FFFF99'></textarea>
                        </td> 
                       
                    </tr>
                    
               <tr> 
                   <td width="25%" style="text-align: right;" class="backgroundHeader" nowrap>دفعة الحجز</td>
                        <td width="25%"style="text-align:right;" class="backgroundHeader">
                            <input type="number" size="7" maxlength="7" id="reservationValue" name="reservationValue" style='width:170px;'/>
                        </td>
              
                 <td width="20%" style="text-align: right;" class="backgroundHeader" nowrap>فقط</td>
                   <td width="40%"style="text-align:right;" class="backgroundHeader">
                       <textarea name="reservationValueText" id="reservationValueText" style='width:250px; height: 50px; background: #FFFF99'></textarea>
                        </td> 
                    </tr>
                    <tr>
                        <td width="25%" style="text-align: right;" class="backgroundHeader" nowrap>طريقة السداد</td>
                        <td width="25%"style="text-align:right;" class="backgroundHeader">
                            <select name="paymentSystem" id="paymentSystem" style='width:170px;font-size:16px;'>
                                <option value="كاش">كاش</option>
                                <option value="أقساط">أقساط</option>
                            </select>
                        </td>
                        <td width="20%" style="text-align: right;" class="backgroundHeader" nowrap>ايصال استلام رقم</td>
                        <td width="30%"style="text-align:right;" class="backgroundHeader">
                            <input type="text" size="7" maxlength="7" name="receiptNo" id="receiptNo" style='width:170px;'/>
                        </td>
                    </tr>
                    
                    <tr>
                        <td width="25%" style="text-align: right;" class="backgroundHeader" nowrap>إضافات</td>
                        <td style="text-align:right;" class="backgroundHeader" colspan="3"><TEXTAREA cols="75" rows="2" name="addtions" id="addtions"></TEXTAREA></td>
                    </tr>

                    <tr>
                        <td colspan="4" class="backgroundHeader" nowrap> 
                            <input type="hidden" id="clientId" name="clientId"/>
                            <input name="reserveUnit" type="submit" value="حجز الأن" onclick="javascript: reservedUnit(this)"/>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <div id="sellDialog" style="display: none;width: 30%;position: fixed; z-index: 1000;" >
            <div style="clear: both;margin-left: 90%;margin-top: 0px;margin-bottom: -40px;">
                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                 -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                 box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                 -webkit-border-radius: 20px;
                 -moz-border-radius: 20px;
                 border-radius: 20px;" onclick="closePopupDialog('sellDialog')"/>
            </div>
            <div class="login" style="width: 90%;text-align: center">
                <table class="table " style="width:100%;">
                    <tr>
                        <td style="color:#f1f1f1; font-size: 16px;font-weight: bold;" colspan="2">بيع وحدة</td>
                    </tr>
                    <tr>
                        <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;" nowrap>مسئول المبيعات</td>
                        <td width="70%" style="color:#f1f1f1; font-size: 16px;font-weight: bold; text-align: right;">
                        <%=(String) userWbo.getAttribute("userName")%>
                        </td>
                    </tr>
                    <tr>
                        <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;">كود الوحدة</td>
                        <td width="70%"style="text-align:right;">
                            <table class="hidex" style="display: block; margin-right: -5px;" ALIGN="center"  dir="<%=dir%>" border="0" id="regionTable">
                                <tr>
                                    <td style="<%=style%>" class="td2">
                                        <input class="hidex" type="text" readonly id="unitCodeSell" name="unitCodeSell" value=""
                                                ondblclick="return getDataInPopup('ProjectServlet?op=getAllAvailableUnits&fieldName=PROJECT_NAME&fieldValue=' + getASSCIChar(this.value) + '&formName=CLIENT_COMPLAINT_FORM&selectionType=single');">
                                        <input type="hidden" id="unitIdSell" name="unitId"/>
                                        <input type="hidden" id="parentIdSell" name="parentId"/>
                                    </td>
                                    <td style="border: 0px">
                                        <input type="button" onclick="return getDataInPopup('ProjectServlet?op=getAllAvailableUnits&fieldName=PROJECT_NAME&fieldValue=' + getASSCIChar($('#unitCode').val()) + '&formName=CLIENT_COMPLAINT_FORM&selectionType=single');"  value="<%=search%>">
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" style="color:#f1f1f1; font-size: 16px;font-weight: bold;"> 
                            <input type="hidden" id="clientIdSell" name="clientId"/>
                            <input type="submit" value="بيع" onclick="javascript: sellUnit(this)"/>
                        </td>

                    </tr>
                </table>
            </div>
        </div>
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
                                <input name="title" id="title" value=""/>
                            </td>
                        </tr> 
                        <tr>
                            <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 30%;">تفاصيل</td>
                            <td style="width: 70%;" >
                                <textarea  placeholder="" style="width: 100%;height: 80px;" id="details" > </textarea>
                            </td>
                        </tr> 
                    </table>
                    <div style="text-align: center;margin-left: auto;margin-right: auto;clear: both" > <input type="button" value="حفظ"   onclick="JavaScript:createBookmark(this, '<%=client.getAttribute("id")%>');" id="saveBookmark"class="login-submit"/></div>                             </form>
                    <!--<div style="clear: both;display: none"></div>-->
                    <div id="progressBookmark" style="display: none;">
                        <img src="images/Loading2.gif" width="32px" height="32px;" style="background-repeat: no-repeat;margin-left: auto;margin-right: auto"/>
                    </div>
                    <div style="margin: 0 auto;display: none; width: 90%;text-align: center;color: white;font-size: 16px;font-weight: bold" id="createMsg">
                        تم إضافة العلامة
                    </div>
                </div>  
            </div>
            <input type="hidden" id="compTitle" name="compTitle" />
            <input type="hidden" id="compContent" name="compContent"  />
            <input type="hidden" id="managerId" name="managerId"/>
            <input type="hidden" id="managerId" name="managerId"/>
            <input type="hidden" id="clientStatus" name="clientStatus" value="<%=clientStatus%>"/>



    </FORM>







    <script type="text/javascript">
        function sendMailByAjax(obj){
            $(obj).parent().find("#progressx").css("display","block");
            var options = { 
                beforeSend: function() 
                {
                    $("#progressx").show();
                    //clear everything
                    //                    $("#bar").width('0%');
                    $("#message").html("");
                    $("#progressx").css("display","block");
                },
                uploadProgress: function(event, position, total, percentComplete) 
                {
                    $("#bar").width(percentComplete+'%');
                    $("#percent").html(percentComplete+'%');

    
                },
                success: function() 
                {
                 
                    $("#progressx").html('');
                    $("#progressx").css("display","none");
                  

                },
                complete: function(response) 
                {
                    $("#message").html("<font color='white'>"+response.responseText+"</font>");
                 
                 
                },
                error: function()
                {
                    alert("error")
                    $("#message").html("<font color='red'> ERROR: unable to upload files</font>");

                }
     
            }; 

            $("#myForm").ajaxForm(options);

     
        }
       
    </script>

</body>
</html>
