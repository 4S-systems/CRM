<%@page import="com.clients.db_access.ClientRatingMgr"%>
<%@page import="com.crm.common.CRMConstants"%>
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
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
 <HTML>
    <c:set var="loc" value="en"/>
    <c:if test="${!(empty sessionScope.currentMode)}">
      <c:set var="loc" value="${sessionScope.currentMode}"/>
    </c:if>
<fmt:setLocale value="${loc}"  />
<fmt:setBundle basename="Languages.Issue.getCompl3"  var="getcompl3"/>
<fmt:setBundle basename="Languages.Issue.clientProduct"  var="clientproduct"/>
<jsp:include page="clientproduct_js.jsp" flush="true"/>


<%

    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String entry_Date = (String) request.getAttribute("entryDate");
    MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
    String connectByRealEstate = metaDataMgr.getConnectByRealEstate();
    ArrayList<WebBusinessObject> paymentPlace = (ArrayList<WebBusinessObject>) request.getAttribute("paymentPlace");
    WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");

    SecurityUser securityUser = (SecurityUser) session.getAttribute("securityUser");
    ArrayList<WebBusinessObject> prvType = new ArrayList();
    prvType = securityUser.getComplaintMenuBtn();
    ArrayList<String> privilegesList = new ArrayList ();
    for (WebBusinessObject wboTemp : prvType) {
        if (wboTemp != null && wboTemp.getAttribute("prevCode") != null) {
            privilegesList.add((String) wboTemp.getAttribute("prevCode"));
        }
    }
    ProjectMgr projectMgr = ProjectMgr.getInstance();
    List<WebBusinessObject> userProjects = new ArrayList(projectMgr.getOnArbitraryKeyOracle("1365240752318", "key2"));

    Calendar cal = Calendar.getInstance();
    String timeFormat = "yyyy/MM/dd HH:mm";
    SimpleDateFormat sdf = new SimpleDateFormat(timeFormat);
    String nowTime = sdf.format(cal.getTime());
    String reservationDateStr = nowTime.substring(0, nowTime.indexOf(" ")).replaceAll("/", "-");
    String issueId = (String) request.getAttribute("issueId");
    IssueMgr issueMgr = IssueMgr.getInstance();
    WebBusinessObject issueWbo = (WebBusinessObject) issueMgr.getOnSingleKey(issueId);
    Vector<WebBusinessObject> mainCatsTypes = new Vector();
    mainCatsTypes = (Vector) request.getAttribute("data");

    Vector products = (Vector) request.getAttribute("products");
    Vector reservedUnit = (Vector) request.getAttribute("reservedUnit");
    ArrayList<WebBusinessObject> purcheUnits = (ArrayList<WebBusinessObject>) request.getAttribute("purcheUnits");
    for (int i = 0; i < purcheUnits.size(); i++) {
        WebBusinessObject wbo = purcheUnits.get(i);
        System.out.println("WBO TEST " + wbo.getObjectAsJSON2());
    }
     UserMgr userMgr = UserMgr.getInstance();
    WebBusinessObject wbo = new WebBusinessObject();
    Vector<WebBusinessObject> CompetentEmp = new Vector();
    CompetentEmp = (Vector) request.getAttribute("CompetentEmp");
    CustomerGradesMgr customerGradesMgr = CustomerGradesMgr.getInstance();

     WebBusinessObject customerGrade = new WebBusinessObject();
    projectMgr = ProjectMgr.getInstance();
     String context = metaMgr.getContext();

//Get request data
     WebBusinessObject client = (WebBusinessObject) request.getAttribute("client");

    String clientStatus = "";
    if (client.getAttribute("currentStatus") != null) {
        clientStatus = (String) client.getAttribute("currentStatus");
    }

    //begin client rate
    WebBusinessObject clientRateMain = projectMgr.getOnSingleKey("key3", "CR");
    ArrayList<WebBusinessObject> ratesList = new ArrayList<>();
    if(clientRateMain != null) {
        ratesList = new ArrayList<>(projectMgr.getOnArbitraryKeyOracle((String) clientRateMain.getAttribute("projectID"), "key2"));
    }
    ClientRatingMgr clientRatingMgr = ClientRatingMgr.getInstance();
    WebBusinessObject clientRateWbo = clientRatingMgr.getOnSingleKey("key1", (String) client.getAttribute("id"));
    //end client rate
 TradeMgr tradeMgr = TradeMgr.getInstance();
    Vector<WebBusinessObject> jobs = new Vector();

    jobs = tradeMgr.getOnArbitraryKey("1", "key3");

    String issueDesc = "";
    if (issueWbo != null) {
        issueDesc = (String) issueWbo.getAttribute("issueDesc");
    }

    WebBusinessObject managerWbo = userMgr.getManagerByEmployeeID(securityUser.getUserId());
    String departmentID = "";
    if (managerWbo != null) {
        departmentID = (String) managerWbo.getAttribute("fullName");
        ArrayList<WebBusinessObject> departmentList = new ArrayList(projectMgr.getOnArbitraryKeyOracle((String) managerWbo.getAttribute("userId"), "key5"));
        if (departmentList.size() > 0) {
            departmentID = (String) departmentList.get(0).getAttribute("projectID");
        }
    }
    boolean isCanMoreEdit = securityUser.getUserId().equalsIgnoreCase((String) client.getAttribute("createdBy"));

    String stat = (String) request.getSession().getAttribute("currentMode");
     String dir = null;
    String style = null;
    String  birthDate, search, noRating,noodCode;
    if (stat.equals("En")) {
       
        dir = "LTR";
        style = "text-align:left";
        noodCode="Unite No.";
        
        
        birthDate = "Birth date";
        search = "Search";
        noRating = "No Rating";
    } else {
         
        dir = "RTL";
        style = "text-align:Right";
        birthDate = "تاريخ الميلاد";
        search = "بحث";
        noRating = "لا يوجد تقييم";
        noodCode="كود الوحدة";

    }

    WebBusinessObject userWbo = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
    BookmarkMgr bookmarkMgr = BookmarkMgr.getInstance();

    Vector bookmarksList = bookmarkMgr.getOnArbitraryDoubleKeyOracle((String) client.getAttribute("id"), "key1", (String) userWbo.getAttribute("userId"), "key2");
    String bookmarkId = "";
    String bookmarkDetails = "";
    if (bookmarksList != null && bookmarksList.size() > 0) {
        bookmarkId = (String) ((WebBusinessObject) bookmarksList.get(0)).getAttribute("bookmarkId");
        bookmarkDetails = (String) ((WebBusinessObject) bookmarksList.get(0)).getAttribute("bookmarkText");
    }

      GroupPrevMgr groupPrevMgr = GroupPrevMgr.getInstance();
    Vector groupPrev = new Vector();
    String dd = (String) userWbo.getAttribute("groupID");
    groupPrev = groupPrevMgr.getOnArbitraryKey(userWbo.getAttribute("groupID").toString(), "key1");
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
    }  

    ArrayList<String> userPrevList = new ArrayList();
    for (int i = 0; i < groupPrev.size(); i++) {
        wbo = (WebBusinessObject) groupPrev.get(i);
        userPrevList.add((String) wbo.getAttribute("prevCode"));
    }
    Vector<WebBusinessObject> vecApp = projectMgr.getOnArbitraryKey("meeting", "key3");
    ArrayList dataArray = null;
    if (vecApp.size() > 0) {
        WebBusinessObject wboComplaint = (WebBusinessObject) vecApp.get(0);
        dataArray = new ArrayList(projectMgr.getOnArbitraryKeyOracle((String) wboComplaint.getAttribute("projectID"), "key2"));
 
    }

%>
 

<!DOCTYPE html>
 <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Expires" CONTENT="0">

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Untitled Document</title>
    <script src='ChangeLang.js' type='text/javascript'></script>
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
    <script type="text/javascript" src="js/adamwdraper-Numeral-js-7487acb/numeral.min.js"></script>
    <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/default/easyui.css">
    <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/icon.css">
    <link rel="stylesheet" type="text/css" href="jquery-easyui/demo/demo.css">
    <script type="text/javascript" src="jquery-easyui/easyloader.js"></script>
    <script type="text/javascript" src="jquery-ui/ui/jquery.ui.widget.js"></script>
    <script type="text/javascript" src="jquery-ui/ui/jquery.ui.mouse.js"></script>
    <script type="text/javascript" src="jquery-ui/ui/jquery.ui.slider.js"></script>
    <script type="text/javascript" src="js/msdropdown/jquery.dd.min.js"></script>
    <link rel="stylesheet" href="jquery-ui/themes/base/jquery-ui-timepicker-addon.css"/>
    <link rel="stylesheet" type="text/css" href="css/CSS.css" />
    <link rel="stylesheet" type="text/css" href="css/Button.css" />
    <link rel="stylesheet" type="text/css" href="css/blueStyle.css" />
    <link rel="stylesheet" type="text/css" href="css/epoch_styles.css" />
    <link rel="stylesheet" type="text/css" href="css/msdropdown/dd.css" />
    <link rel="stylesheet" href="css/viewComp3.css"/>
</head>

<script type="text/javascript">
    function assigncuststatus (status)
        {
            console.log("status");
            console.log(status);
             if(status==="11" )
            {
                console.log("case 11");
                $("#cstmr").addClass("label-success");
            }
            else if(status==="14"  )
            {
                console.log("case 14");
                  $("#cnct").addClass("label-success");
            }
             else if(status==="13" )
             {
                 console.log("case 13");
                  $("#oprt").addClass("label-success");
             }
             else if(status==="12" )
             {
                 console.log("case 12");
                  $("#lead").addClass("label-success");
             }
          }
     
          var divID;
  $(function () {
      
        $("#birthDateCal").datepicker({
            maxDate: "+d",
            changeMonth: true,
            changeYear: true,
            dateFormat: 'yy-mm-dd',
            yearRange: "-70:+0"
        });

        $("#clientStatusDate,#reservationDate,#reservationDateOnhold").datepicker({
            maxDate: "+d",
            changeMonth: true,
            changeYear: true,
            dateFormat: 'yy-mm-dd'
        });
        showCalendar(<%=!purcheUnits.isEmpty()%>);
    });

    function openWindowTasks(url)
    {

        window.open(url, "_blank", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=no, copyhistory=no,width=800,height=400");
    }


    function centerDiv(div) {
        $("#" + div).css("position", "fixed");
        $("#" + div).css("top", Math.max(0, (($(window).height() - $("#" + div).outerHeight()) / 2)) + "px");
        $("#" + div).css("left", Math.max(0, (($(window).width() - $("#" + div).outerWidth()) / 2)) + "px");
    }
 
    function closeOverlay() {
        $("#" + divID).hide();
        $("#overlay").hide();
    }

    function closePopupDialog(formID) {
        try {
            $('#' + formID).bPopup().close();
        } catch (err) {
        }
        $("#" + formID).hide();
        $('#overlay').hide();
    }

function openattachmentmenu()
{
    
    var X = $("#attachment-button").attr('id');
            console.log("X= ");
            console.log(X);
            console.log($("#attachment-button"));
            if (X == 1)
            {
                $(".submenuattach").hide();
                $("#attachment-button").attr('id', '0');
            }
            else
            {
                $(".submenuattach").show();
                $("#attachment-button").attr('id', '1');
            }
}

</script>
<script type="text/javascript" >

    $(document).ready(function ()
    {
        centerDiv("show_appointment");
        centerDiv("unit_content");
        centerDiv("reserveDialog");
        centerDiv("sellDialog");
        centerDiv("onholdDialog");
        centerDiv("clientInformation");
        centerDiv("add_comments");
        centerDiv("add_campaigns");

        $(".button_commen").click(function ()
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
        $(".submenu").mouseup(function ()
        {
            return false
        });
        $(".submenu").mouseout(function ()
        {
            return false
        });
        $(".button_commen").mouseout(function ()
        {
            return false
        });

        //Mouse click on my account link
        $(".button_commen").mouseup(function ()
        {
            return false
        });


        //Document Click

        $(document).mouseup(function ()
        {
            $(".submenu").hide();
            $(".button_commen").attr('id', '');
        });
        $(document).mouseout(function ()
        {
            $(".submenu").hide();
            $(".button_commen").attr('id', '');
        });
        //appointment button
        $(".button_pointment").click(function ()
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
        $(".button_camp").click(function ()
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
        $(".button_incentive").click(function ()
        {
            var X = $(this).attr('id');
            if (X == 1)
            {
                $(".submenu_incentive").hide();
                $(this).attr('id', '0');
            }
            else
            {
                $(".submenu_incentive").show();
                $(this).attr('id', '1');
            }

        });

        //Mouse click on sub menu
        $(".submenu1").mouseup(function ()
        {
            return false
        });

        $(".submenu1").mouseout(function ()
        {
            return false
        });
        $(".submenu2").mouseup(function ()
        {
            return false
        });

        $(".submenu2").mouseout(function ()
        {
            return false
        });
        $(".submenu_incentive").mouseup(function ()
        {
            return false
        });

        $(".submenu_incentive").mouseout(function ()
        {
            return false
        });
        //Mouse click on my account link
        $(".button_pointment").mouseup(function ()
        {
            return false
        });
        $(".button_pointment").mouseout(function ()
        {
            return false
        });
        $(".button_camp").mouseup(function ()
        {
            return false
        });
        $(".button_camp").mouseout(function ()
        {
            return false
        });
        $(".button_incentive").mouseup(function ()
        {
            return false
        });
        $(".button_incentive").mouseout(function ()
        {
            return false
        });
        //Document Click

        $(document).mouseup(function ()
        {
            $(".submenu1").hide();
            $(".button_pointment").attr('id', '');
        });
        $(document).mouseout(function ()
        {
            $(".submenu1").hide();
            $(".button_pointment").attr('id', '');
        });
        $(document).mouseup(function ()
        {
            $(".submenu2").hide();
            $(".button_camp").attr('id', '');
        });
        $(document).mouseout(function ()
        {
            $(".submenu2").hide();
            $(".button_camp").attr('id', '');
        });
        $(document).mouseup(function ()
        {
            $(".submenu_incentive").hide();
            $(".button_incentive").attr('id', '');
        });
        $(document).mouseout(function ()
        {
            $(".submenu_incentive").hide();
            $(".button_incentive").attr('id', '');
        });

        $(".attach_file").click(function ()
        {
            var X = $(this).attr('id');
            console.log("X= ");
            console.log(X);
            console.log($(this));
            if (X == 1)
            {
                $(".submenuattach").hide();
                $(this).attr('id', '0');
            }
            else
            {
                $(".submenuattach").show();
                $(this).attr('id', '1');
            }

        });
        
        

        //Mouse click on sub menu
        $(".submenuattach").mouseup(function ()
        {
            return false
        });
        $(".submenuattach").mouseout(function ()
        {
            return false
        });
        $(".attach_file").mouseout(function ()
        {
            return false
        });

        //Mouse click on my account link
        $(".attach_file").mouseup(function ()
        {
            return false
        });


        //Document Click

        $(document).mouseup(function ()
        {
            $(".submenuattach").hide();
            $(".attach_file").attr('id', '');
        });
        $(document).mouseout(function ()
        {
            $(".submenuattach").hide();
            $(".attach_file").attr('id', '');
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
        try {
            $("#clientRate").msDropDown();
        } catch(e) {
            alert(e.message);
        }
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
            success: function (jsonString) {
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
        $('#reserveDialog').dialog(); //.bPopup({easing: 'easeInOutSine',
//            speed: 400,
//            transition: 'slideDown'});
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

    function popupClientOnhold() {
        divID = "onholdDialog";
        $('#overlay').show();
        $("#onholdBtn").show();
        $("#onholdChangeStatus").val('true');
        $('#onholdDialog').find("#clientStatusNotes").val("");
        $('#onholdDialog').css("display", "block");
        $('#onholdDialog').css("opacity", "100");
        $('#onholdDialog').dialog(); //.bPopup({easing: 'easeInOutSine',
//            speed: 400,
//            transition: 'slideDown'});
    }
    function onholdUnit() {
        var clientId = $("#clientId").val();
        var unitId = $("#unitIdOnhold").val();
        var budget = $("#budgetOnhold").val();
        var period = $("#periodOnhold").val();
        var paymentSystem = $("#paymentSystemOnhold").val();
        var paymentPlace = $("#paymentPlaceOnhold").val();
        var parentId = $("#parentIdOnhold").val();
        var issueId = "<%=issueId%>";
        var clientComplaintId = "<%=request.getParameter("compId")%>";
        var changeStatus = $("#onholdChangeStatus").val();
        var reservationDate = $("#reservationDateOnhold").val();
        $.ajax({
            type: "post",
            url: "<%=context%>/ProjectServlet?op=saveOnholdUnits&changeStatus=" + changeStatus,
            data: {
                clientId: clientId,
                unitId: unitId,
                budget: budget,
                period: period,
                unitCategoryId: parentId,
                paymentSystem: paymentSystem,
                paymentPlace: paymentPlace,
                issueId: issueId,
                clientComplaintId: clientComplaintId,
                reservationDate: reservationDate
            },
            success: function (jsonString) {
                var info = $.parseJSON(jsonString);
                if (info.status == 'ok') {
                    alert("تم الحجز بنجاح")
                    closePopupDialog("onholdDialog");
                    $("#unitIdOnhold").val("");
                    $("#budgetOnhold").val("");
                    $("#periodOnhold").val("");
                    $("#paymentSystemOnhold").val("");
                    $("#paymentPlaceOnhold").val("");
                    $("#parentIdOnhold").val("");
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
                                <b id='1'> " + $("#unitCodeOnhold").val() + "</b>  </TD>\n\
                            <TD style='text-align:center;background: #f1f1f1;font-size: 14px;'>\n\
                                <b id='2'>  " + info.projectName + " </b>       </TD>\n\
                            <TD style='text-align:center;background: #f1f1f1;font-size: 14px;'>\n\
                                <b id='3'>  " + budget + " </b>       </TD>\n\
                            <TD style='text-align:center;background: #f1f1f1;font-size: 14px;'>\n\
                                <b id='4'>  " + paymentSystem + " </b>       </TD>\n\
                            <TD style='text-align:center;background: #f1f1f1;font-size: 14px;'>\n\
                                <b id='5'>  " + period + " </b>       </TD>\n\
                            <TD style='text-align:center;background: #f1f1f1;font-size: 14px;'>\n\
                                <b id='6'>  " + year + "-" + monthStr + "-" + day + " </b>       </TD>\n\
                            <TD style='text-align:center;background: #f1f1f1;font-size: 14px;'>\n\
                                <b id='7'>    " + "حجز مرتجع" + "</b>  </TD>\n\
                        </TR>").show();
                } else if (eqpEmpInfo.status == 'no') {
                    alert("لم يتم الحجز");
                }
            }
        });
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
    function closePopup(obj) {

        $(obj).parent().parent().bPopup().close();


    }
    var count2 = 1;
    var count3 = 1;
    //    function removeTd(obj){
    //        $(obj).parent().remove();
    //        count=(count*1-1);
    //       // $("#addFile").removeAttr("disabled");
    //    }

//    function addFiles(obj){
//        if((count*1)==4){
//            $("#addFile").removeAttr("disabled");
//        }
//
//        if(count>=1&count<=4){
//            $("#listFile").append("<input type='file' style='float: right;text-align:right;font-size:12px;margin:1.5px;' name='file"+count+"' id='file'  maxlength='60'/>");
//            $("#counter").val(count);
//            
//           
//            count=Number(count*1+1)
//           
//            
//           
//        }else{
//            $("#addFile").attr("disabled", true);
//        }
//       
//       
//    }
    function addFiles(obj) {
        if ((count2 * 1) == 4) {
            $("#addFile").removeAttr("disabled");
        }

        if (count2 >= 1 & count2 <= 4) {
            $("#listAttachFile").append("<input type='file' style='float: right;text-align:right;font-size:12px;margin:1.5px;' name='file" + count2 + "' id='file2'  maxlength='60'/>");
            $("#counterFile").val(count2);
            count2 = Number(count2 * 1 + 1)

        } else {
            $("#addFile").attr("disabled", true);
        }
    }
    function addEmailFiles(obj) {
        if ((count3 * 1) == 4) {
            $("#addEmailFile").removeAttr("disabled");
        }

        if (count3 >= 1 & count3 <= 4) {
            $("#listFile").append("<input type='file' style='float: right;text-align:right;font-size:12px;margin:1.5px;' name='file" + count3 + "' id='file2'  maxlength='60'/>");
            $("#emailCounter").val(count3);
            count3 = Number(count3 * 1 + 1)

        } else {
            $("#addEmailFile").attr("disabled", true);
        }
    }
    function updateRow(obj) {
        divID = "unit_content";
        $('#overlay').show();
        $('#msg').html("");

        $("#updateUnit").css("display", "");
        $("#addUnit").css("display", "none");
        var x = $(obj).parent().find("#updateId").val();

        $("#ID").val(x);
        $("#mainProduct option:contains(" + $(obj).parent().parent().find("#2").text() + ")").prop('selected', true);

        $("#budget").val($(obj).parent().parent().find("#3").text());
        $("#unitNotes").val($(obj).parent().parent().find("#6").text());
        //     alert($(obj).parent().parent().find("#6").text())
        $("#period option:contains(" + $(obj).parent().parent().find("#5").text() + ")").prop('selected', true);
        $("#paymentSystem option:contains(" + $(obj).parent().parent().find("#4").text() + ")").prop('selected', true);


        $(obj).parent().parent().attr("id", "ROWID");




        $('#unit_content').css("display", "block");
        $('#unit_content').css("opacity", "100");
        $('#unit_content').dialog(); //.bPopup({easing: 'easeInOutSine', //uses jQuery easing plugin
//            speed: 400,
//            transition: 'slideDown'});

    }
                                            var productId;
                                            function getParentIDValue(obj) {
                                                $.ajax({
                                                    type: "post",
                                                    url: "<%=context%>/ProjectServlet?op=getParentIDAjax",
                                                    data: {
                                                        projectID: $(obj).val()
                                                    },
                                                    success: function (jsonString) {
                                                        var info = $.parseJSON(jsonString);
                                                        if (info.status == 'ok') {
                                                            productId = info.mainProjId;
                                                        }
                                                    }
                                                });
                                            }
    function addUnitRecord(obj) {
        $('#msg').text("");
        var operation = "insert";
        var notes = $('#unitNotes').val();
        if (notes == "" || notes == null) {
            notes = "  ";
        }
        var budget = $(obj).parent().parent().parent().find('#budget').val();
        if (budget == "" || budget == null) {
            budget = "0";
        }
        var product_category_id = $('#mainProduct').val();
        if (product_category_id == "----" || product_category_id == null) {
            alert("من فضلك قم باختيار المشروع ");
            return;
        }
        var period = $(obj).parent().parent().parent().find("#period").val();
//        var period = $('#period').val();
        var paymentSystem = $('#paymentSystemInterested').val();
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
                operation: operation
            },
            success: function (jsonString) {
                //                    $(obj).html("");
                //                    $(obj).css("background-position", "top");
                //                   alert("info");
                //                    alert(jsonString);
                var info = $.parseJSON(jsonString);
                if (info.status == 'ok') {

                    $('#unitNotes').val("");
                    $('#budget').val("");
                    $('#mainProduct').val("----");
                    $('#period').val("");
                    $('#paymentSystemInterested').val("");
                    $('#msg').text("تم التسجيل بنجاح");

                    $("#interestedUnit").html($("#interestedUnit").html() + "<TR style='padding: 1px;'>\n\
                                <TD style='text-align:center;background: #f1f1f1;font-size: 14px;'>\n\
                                  <div class='remove' id='remove' onclick='removeRow(this)'></div> \n\
<div  class='update'  id='updateRow' onclick='updateRow(this)'> </div> \n\
 <input id='updateId'  type='hidden' value=" + info.id + "></TD>\n\
                            \n\
  <TD style='text-align:center;background: #f1f1f1;font-size: 14px;'>\n\
                                <b id='2'> " + info.productCategoryName + "</br>\
                                <input type='hidden' id='rowId' value=" + info.id + " />  </TD>\n\
                                <TD style='text-align:center;background: #f1f1f1;font-size: 14px;'>\n\
                                     <b id='3'>  " + info.budget + " </br>       </TD>\n\
                                <TD style='text-align:center;background: #f1f1f1;font-size: 14px;'>\n\
                                        <b id='4'>     " + info.paymentSystem + "</br>                       </TD>\n\
                                <TD style='text-align:center;background: #f1f1f1;font-size: 14px;'>\n\
                               <b id='5'>  " + info.period + "</br>  </TD>\n\
                                 <TD style='text-align:center;background: #f1f1f1;font-size: 14px;'>\n\
                             <b id='6' onMouseOver='Tip('" + info.note + "', LEFT, true, OFFSETX, 0, BGCOLOR, '#FFFF99', FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT, 'BOLD', TITLEALIGN, 'center', TITLEFONTCOLOR, 'black', TITLEBGCOLOR, '#6699FF')' onMouseOut='UnTip()' >    " + info.note + "</br>  </TD>\n\
                            </TR>").show();

                } else if (info.status == 'no') {
                    $('#msg').text("لم يتم التسجيل");
                }
            }
        });
    }
    function updateUnitRecord(obj) {
        var id = $("#ID").val();

        $('#msg').text("");
        var operation = "update";
        var notes = $('#unitNotes').val();
        if (notes == "" || notes == null) {
            notes = "  ";
        }
        var budget = $('#budget').val();
        if (budget == "" || budget == null) {
            budget = "0";
        }
        var product_category_id = $('#mainProduct').val();
        if (product_category_id == "----" || product_category_id == null) {
            alert("من فضلك قم باختيار نوع إستثمار ");
            return;
        }
        var period = $('#period').val();
        var paymentSystem = $('#paymentSystemInterested').val();
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
                operation: operation,
                id: id

            },
            success: function (jsonString) {
                //                    $(obj).html("");
                //                    $(obj).css("background-position", "top");
                //                   alert("info");
                //                    alert(jsonString);
                var info = $.parseJSON(jsonString);
                if (info.status == 'ok') {
                    $('#unitNotes').val("");
                    $('#budget').val("");
                    $('#mainProduct').val("----");

                    $('#period').val("");
                    $('#paymentSystemInterested').val("");
                    $('#msg').text("تم التسجيل بنجاح");

                    $("#ROWID").find("#2").html(info.productCategoryName);
                    $("#ROWID").find("#3").html(info.budget);
                    $("#ROWID").find("#4").html(info.paymentSystem);
                    $("#ROWID").find("#5").html(info.period);
                    $("#ROWID").find("#6").html(info.note);
                    $("#ROWID").find("#7").html(info.note);
                    $("#ROWID").find("#updateRow").css('background-position', 'top');
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
                success: function (jsonString) {
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
    function changeFormat(x) {
        alert('tedt');

    }
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
    $(function () {
        $("#appDate").datetimepicker({
            minDate: 0,
            changeMonth: true,
            changeYear: true,
            timeFormat: 'HH:mm',
            dateFormat: 'yy/mm/dd'
        });
    });

    $(function () {
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
    $(function () {
        var x = $("#empId").val();
        if (x == null || x == "") {

            $('tr[id|="removeTr"]').remove();

        }


    });
    function popup(obj) {
        divID = "unit_content";
        $('#overlay').show();
        $('#msg').html("");
        $("#addUnit").css("display", "");
        $("#updateUnit").css("display", "none");
        $('#unitNotes').val("");
        $('#budget').val("");
        $('#mainProduct').val("----");

        $('#period').val("");
        $('#paymentSystemInterested').val("");


        $('#unit_content').css("display", "block");
        $('#unit_content').css("opacity", "100");
        $('#unit_content').dialog(); //.bPopup({easing: 'easeInOutSine', //uses jQuery easing plugin
//            speed: 400,
//            transition: 'slideDown'});

    }
    function popupEmail(obj) {

        count3 = 1;
        $("#addFile").removeAttr("disabled");
        $("#emailCounter").val("0");
        $("#listFile").html("");
        var clientName = $("#clientInformation #clientName").text();
        $('#email_content #clientNa').val($("#hideName").val());
        $('#email_content #emailTo').val($("#hideEmail").val());
        $("#msgContent").val("");
        $("#emailStatus").html("");

        $("#clientNo").text($("#num").text());
        $("#subj").val("");
        $("#progressx").hide();
        $('#email_content').show();
        $('#email_content').bPopup();
    }
    function popupAttach2(obj) {
        $("#attachMessage").html("");
        $(".attach_file").attr('id', '0');
        $(".submenuattach").attr('id', '0');
        count2 = 1;
        $("#addFile").removeAttr("disabled");
        $("#counterFile").val("0");
        $("#listAttachFile").html("");

        $('#attach_file').show();
        $('#attach_file').bPopup();
    }
    function showAttachedClientFiles()
    {
        var url = "<%=context%>/SeasonServlet?op=showAttachedFiles&clientID=" + <%=client.getAttribute("id")%>;
        jQuery('#show_attached_files2').load(url);

        $('#show_attached_files2').css("display", "block");
        $('#show_attached_files2').bPopup();

    }
    function viewClientContract(obj) {

        $.ajax({
            type: "post",
            url: "./EmailServlet?op=getContractID&clientID=" + <%=client.getAttribute("id")%>,
            success: function (jsonString) {
                var hiddenIFrameID = 'hiddenDownloader',
                        iframe = document.getElementById(hiddenIFrameID);
                if (jsonString != '') {
                    var url = "<%=context%>/EmailServlet?op=viewDocument&docID=" + jsonString + "&docType=pdf";
                    window.open(url);
//                  
//                      alert(url);                
//                    if (iframe === null) {
//                        iframe = document.createElement('iframe');
//                        iframe.id = hiddenIFrameID;
//                        iframe.style.display = 'none';
//                        document.body.appendChild(iframe);
//                    }
//                    iframe.src = url;
                }
            },
            error: function ()
            {
                alert('لا يوجد عقد مرفق');
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
    function popupApp(obj) {

        $("#appTitleMsg").css("color", "");
        $("#appTitleMsg").text("");
        $("#appTitle").val("");


        $("#appNote").val("");
        $("#appMsg").hide();
        $(".submenu1").hide();
        $("#appClientName").text($("#clientName").text());
        $(".button_pointment").attr('id', '0');
        $('#appointment_content').css("display", "block");

        $('#appointment_content').bPopup();



    }
    function popupAddComment(obj) {
        divID = "add_comments";
        $('#overlay').show();

        $(".submenu").hide();
        $(".button_commen").attr('id', '0');
//        $("#comment").val("");
        $("#commMsg").hide();

        $('#add_comments').css("display", "block");
        $('#add_comments').css("opacity", "100");
        $('#add_comments').dialog(); //.bPopup({easing: 'easeInOutSine', //uses jQuery easing plugin
//            speed: 400,
//            transition: 'slideDown'});

    }
    function clientInformation(obj) {
        divID = "clientInformation";
        $('#overlay').show();
        $(".hidex").css("display", "none");
        $(".showx").css("display", "block");
        $('#clientInformation').css("display", "block");
        $("#updateBtn").css("display", "none");
        $("#editBtn").css("display", "block");

        $('#clientInformation').css("opacity", "100");
        $('#clientInformation').dialog(); //.bPopup({easing: 'easeInOutSine', //uses jQuery easing plugin
//            speed: 400,
//            transition: 'slideDown'});
    }
    function printClientInformation(obj) {
        var url = "<%=context%>/PDFReportServlet?op=clientDataSheet&clientId=" + $("#clientId").val() + "&objectType=client";
        openWindow(url)
    }
    function printClientFincancial() {
        var url = "<%=context%>/ExternalDatabaseServlet?op=viewClientFinancialReport&clientId=" + $("#clientId").val();
        window.open(url, "_blank", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=no, copyhistory=no, width=1200, height=500");
    }

    function openWindow(url) {
        window.open(url, "_blank", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=no, copyhistory=no, width=750, height=400");
    }
    function popupAddCampagin(obj) {
        divID = "add_campaigns";
        var url = "<%=context%>/ClientServlet?op=showClientCampaigns&clientId=" + $("#clientId").val();
        $('#overlay').show();
        jQuery('#add_campaigns').load(url);
        $("#add_campaigns").css("display", "block");
        $("#add_campaigns").css("opacity", "100");

        $('#add_campaigns').dialog();//.bPopup();
    }
    function popupShowComments(obj) {
        $(".submenu").hide();
        $(".button_commen").attr('id', '0');
        //            alert($("#businessObjectType").val());
        var url = "<%=context%>/CommentsServlet?op=showClientComments&clientId=" + $("#clientId").val() + "&objectType=" + $("#businessObjectType").val() + "&random=" + (new Date()).getTime();
        jQuery('#show_comments').load(url);
        $('#show_comments').css("display", "block");
        $('#show_comments').bPopup();

    }

    function popupShowAppointment(obj) {
        $(".submenu1").hide();
        $(".button_pointment").attr('id', '0');
        var url = "<%=context%>/AppointmentServlet?op=showClientAppointment&clientId=" + $("#clientId").val() + "&cach=" + (new Date()).getTime();
        $('#show_appointment').load(url);
        $('#show_appointment').css("display", "block");

        $('#show_appointment').bPopup();
    }

    function popupShowCampagin(obj) {

        $(".submenu2").hide();
        $(".button_camp").attr('id', '0');
        var url = "<%=context%>/ClientServlet?op=showCampaigns&clientId=" + $("#clientId").val() + "&cach=" + (new Date()).getTime();
        $('#show_campaigns').load(url);

        //        $('#show_campaigns').html();
        $('#show_campaigns').css("display", "block");
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
        $("#sendMailBtn").on('click', function () {
            $("#file").upload("<%=context%>/EmailServlet?op=sendMail&fileExtension=" + fileExt, function (success) {
                console.log("done");
            }, $("#fgd"));
        })

    }
    function popupSms(obj) {


        $("#client_Na").text($("#hideName").val());
        $("#client_No").text($("#num").text());
        $("#mobile").val($("#client_mobile").text());
        $('#sms_content').css("display", "block");

        $('#sms_content').bPopup();
    }
    function popupUserAppo(obj) {

        var url = "<%=context%>/ScheduleServlet?op=showUserCalendar";
        $('#show_client_info').load(url);
        $('#show_client_info').css("display", "block");
        $('#show_client_info').bPopup();
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
        if (validateOrderFiled(obj)) {
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
    function edit_Client2(obj) {
        $(".hidex").css("display", "block");
        $(".showx").css("display", "none");
        $(obj).parent().parent().parent().find("#editBtn").css("display", "none");
        $(obj).parent().parent().parent().find("#updateBtn").css("display", "block");
        $(obj).parent().parent().parent().parent().parent().find("#job option:contains(" + $(obj).parent().parent().parent().parent().parent().find("#clientJob").text() + ")").prop('selected', true);

        //            $("input[class=hide]").css("display","block");

    }
    function updateClient(obj) {

        var clientID = $("#clientId").val();
        var clientNO = $(obj).parent().parent().parent().parent().parent().find("#clientNO").text();

        var clientName = $(obj).parent().parent().parent().parent().parent().find("input[name=clientName]").val();
        var partner = $(obj).parent().parent().parent().parent().parent().find("input[name=partner]").val();
        var gender = $(obj).parent().parent().parent().parent().parent().find("input[name=gender]:checked").val();
        var matiral_status = $(obj).parent().parent().parent().parent().parent().find("input[name=matiral_status]:checked").val();
        var clientSsn = $(obj).parent().parent().parent().parent().parent().find("input[name=clientSsn]").val();
        var phone = $(obj).parent().parent().parent().parent().parent().find("input[name=phone]").val();
        var mobile = $(obj).parent().parent().parent().parent().parent().find("input[name=client_mobile]").val();
        var dialedNumber = $(obj).parent().parent().parent().parent().parent().find("input[name=dialedNumber]").val();
        var interPhone = $(obj).parent().parent().parent().parent().parent().find("input[name=interPhone]").val();
        var address = $(obj).parent().parent().parent().parent().parent().find("input[name=address]").val();
        var email = $(obj).parent().parent().parent().parent().parent().find("input[name=email]").val();
        //var age=$(obj).parent().parent().parent().parent().parent().find("input[name=age]:checked").val();
        var age = "30-40";
        var workOut = $(obj).parent().parent().parent().parent().parent().find("input[name=workOut]:checked").val();
        var kindred = $(obj).parent().parent().parent().parent().parent().find("input[name=kindred]:checked").val();
        var clientJob = $(obj).parent().parent().parent().parent().parent().find("#job").val();
        var birthDate = $("#birthDateCal").val();
        var regionID = $("#region").val();
        var description = $(obj).parent().parent().parent().parent().parent().find("textarea[name=description]").val();
        var branch = $(obj).parent().parent().parent().parent().parent().find("input[name=clientBranch]:checked").val();
        $.ajax({
            type: "post",
            url: "<%=context%>/ClientServlet?op=UpdateClientAjax",
            data: {
                name: clientName,
                partner: partner,
                gender: gender,
                matiral_status: matiral_status,
                clientSsn: clientSsn,
                phone: phone,
                mobile: mobile,
                address: address,
                email: email,
                age: age,
                clientNO: clientNO,
                clientID: clientID,
                kindred: kindred,
                workOut: workOut,
                clientJob: clientJob,
                birthDate: birthDate,
                regionID: regionID,
                dialedNumber: dialedNumber,
                interPhone: interPhone,
                description: description,
                clientBranch: branch
            },
            success: function (jsonString) {

                var data = $.parseJSON(jsonString);
                if (data.Status == "Ok") {

                    var clientName2 = $(obj).parent().parent().parent().parent().parent().find("#clientName").attr("class", "showx");

                    var partner2 = $(obj).parent().parent().parent().parent().parent().find("#partner").attr("class", "showx");
                    var matiral_status2 = $(obj).parent().parent().parent().parent().parent().find("#matiral_status").attr("class", "showx");
                    var clientSsn2 = $(obj).parent().parent().parent().parent().parent().find("#clientSsn").attr("class", "showx");
                    var phone2 = $(obj).parent().parent().parent().parent().parent().find("#phone").attr("class", "showx");
                    var mobile2 = $(obj).parent().parent().parent().parent().parent().find("#client_mobile").attr("class", "showx");
                    var dialedNumber2 = $(obj).parent().parent().parent().parent().parent().find("#dialedNumber").attr("class", "showx");
                    var interPhone2 = $(obj).parent().parent().parent().parent().parent().find("#interPhone").attr("class", "showx");
                    var address2 = $(obj).parent().parent().parent().parent().parent().find("#address").attr("class", "showx");
                    var email2 = $(obj).parent().parent().parent().parent().parent().find("#email").attr("class", "showx");
                    var clientJob2 = $(obj).parent().parent().parent().parent().parent().find("#clientJob").attr("class", "showx");
                    $(clientName2).text(clientName);
                    $(clientJob2).text(data.job);
                    $("#hideName").val(clientName2);
                    $("#hideEmail").val(email2);
                    $(partner2).text(partner);
                    $(matiral_status2).text(matiral_status);
                    $(clientSsn2).text(clientSsn);
                    $(phone2).text(phone);
                    $(mobile2).text(mobile);
                    $(dialedNumber2).text(dialedNumber);
                    $(interPhone2).text(interPhone);
                    $(address2).text(address);
                    $(email2).text(email);
                    $("#clientName").text(clientName);
                    $("#num").text(clientNO);
                    $(".showx").css("display", "block");
                    $(".hidex").css("display", "none");
                    $(obj).parent().css("display", "none");
                    $(obj).parent().parent().parent().find("#editBtn").css("display", "block");
                    $("#birthDate").text(birthDate);
                    $("#regionText").text($("#regionName").val());
                    $("#description").text(description);
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
        if (validateComplaintFiled(obj)) {
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
        if (validateQueryFiled(obj)) {
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
    function saveAppoientment(obj) {



        var clientId = $("#clientId").val();
        $("#appTitleMsg").css("color", "");
        $("#appTitleMsg").text("");

        var title = $(obj).parent().parent().parent().find($("#appTitle")).val();

        var date = $(obj).parent().parent().parent().find($("#appDate")).val();
        var appType = $(obj).parent().parent().parent().find("#note:checked").val();
        var appointmentPlace = $(obj).parent().parent().parent().find("#appointmentPlace").val();
//        var note = $(obj).parent().parent().parent().find($("#appNote")).val();
        var comment = $(obj).parent().parent().parent().find("#comment").val();
        var note = "UL";
        if (title.length > 0) {
//            $(obj).parent().parent().parent().parent().find("#progress").show();

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
                },
                success: function (jsonString) {
                    var eqpEmpInfo = $.parseJSON(jsonString);
                    //                        alert(jsonString);
                    if (eqpEmpInfo.status == 'ok') {
                        //                        alert("تم الحفظ");

//                        $(obj).parent().parent().parent().parent().find("#appMsg").html("تم التسجيل بنجاح").show();
//                        $(obj).parent().parent().parent().parent().find("#progress").hide();

                        $('#overlay').hide();
                        $('#appointment_content').css("display", "none");
                        $('#appointment_content').bPopup().close();
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

    function saveComment(obj) {
        var clientId = $("#clientId").val();


        var type = $(obj).parent().parent().parent().find($("#commentType")).val();
        var comment = $("#newCommentArea").val();
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
            success: function (jsonString) {
                var eqpEmpInfo = $.parseJSON(jsonString);

                if (eqpEmpInfo.status === 'ok') {
                    $(obj).parent().parent().parent().parent().find("#commMsg").show();
                    $(obj).parent().parent().parent().parent().find("#progress").hide();
                    $('#overlay').hide();
                    $('#add_comments').css("display", "none");
                } else if (eqpEmpInfo.status === 'no') {
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
        btns[button1] = function () {
            element.parents('li').hide();
            $(this).dialog("close");
        };
        btns[button2] = function () {
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
            var id = $(obj).parent().parent().find("#rowId").val();
            $.ajax({
                type: "post",
                url: "<%=context%>/ProjectServlet?op=removeInterestedProduct",
                data: {
                    id: id
                },
                success: function (jsonString) {
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
            success: function (jsonString) {
                var eqpEmpInfo = $.parseJSON(jsonString);

                if (eqpEmpInfo.status == 'Ok') {

                    $("#rate").css("display", "inline");
                    $("#choose").css("display", "none");
                    $("#changeRate").css("display", "inline");
                    $("#saveRate").css("display", "none");
                    $("#update").css("display", "block");
                    $("#rate").html($("#choose option:selected").text());
                }
            }
        });
    }



    function popupCreateBookmark(obj, clientId, clientName) {
        $("#createMsg").hide();
        $("#saveBookmark").show();
        $('#createBookmark').find("#title").val(clientName);
        $('#createBookmark').find("#details").val("");
        $('#createBookmark').css("display", "block");
        $('#createBookmark').bPopup();
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
            success: function (jsonString) {
                var info = $.parseJSON(jsonString);
                if (info.status == 'ok') {
                    $("#bookmarkedImg").prop('title', details);
                    $("#createMsg").show();
                    $("#saveBookmark").hide();
                    $("#bookmarked").removeAttr("onclick");
                    $("#bookmarked").click(function () {
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
            success: function (jsonString) {
                var info = $.parseJSON(jsonString);
                if (info.status == 'ok') {
                    $('#bookmarked').css("display", "none");
                    $('#unbookmarked').css("display", "block");
                }
            }
        });
    }
    function incentive() {
        $(".submenu_incentive").hide();
        var url = "<%=context%>/SeasonServlet?op=getIncentiveForm&clientId=<%=client.getAttribute("id")%>";
//        var url= "<%=context%>/IncentiveServlet?op=getIncentiveForm&clientId=<%=client.getAttribute("id")%>";
                $('#add_incentives').load(url);
                $("#add_incentives").css("display", "block");
                $('#add_incentives').bPopup();
            }
            function incentiveList() {
                $(".submenu_incentive").hide();
//        var url= "<%=context%>/IncentiveServlet?op=showIncentives&clientId=<%=client.getAttribute("id")%>";
                var url = "<%=context%>/SeasonServlet?op=showIncentives&clientId=<%=client.getAttribute("id")%>";
                        $('#add_incentives').load(url);
                        $("#add_incentives").css("display", "block");
                        $('#add_incentives').bPopup();
                    }
                    function popupSell(proId, busObjId, projectName) {
                        divID = "sellDialog";
                        $('#overlay').show();
                        $('#sellDialog').css("display", "block");
                        $("#sellPlace").html(projectName);
                        $("#unitIdSell").val(proId);
                        $("#parentIdSell").val(busObjId);
                        $('#sellDialog').css("opacity", "100");
                        $('#sellDialog').dialog(); //.bPopup({easing: 'easeInOutSine',
//                            speed: 400,
//                            transition: 'slideDown'});
                    }
                    function closeSellPopup(obj) {
                        $("#sellDialog").bPopup().close();
                        $("#sellDialog").css("display", "none");
                    }
                    function sellUnit() {
                        var clientId = $("#clientId").val();
                        var unitId = document.getElementById("unitIdSell").value;
                        var budget = "0";
                        var period = "UL";
                        var paymentSystem = "UL";
                        var paymentPlace = "UL";
                        var parentId = document.getElementById("parentIdSell").value;
                        var issueId = "<%=issueId%>";
                        $.ajax({
                            type: "post",
                            url: "<%=context%>/ProjectServlet?op=saveSellUnits",
                            data: {
                                clientId: clientId,
                                unitId: unitId,
                                budget: budget,
                                period: period,
                                unitCategoryId: parentId,
                                paymentSystem: paymentSystem,
                                paymentPlace: paymentPlace,
                                issueId: issueId
                            },
                            success: function (jsonString) {
                                var info = $.parseJSON(jsonString);
                                if (info.status == 'ok') {
                                    alert("تم البيع بنجاح")
                                    closePopupDialog("sellDialog");
                                    $("#unitIdSell").val("");
                                    $("#parentIdSell").val("");
                                    $("#unitCodeSell").html("");
                                    $("#purcheUnits").html($("#purcheUnits").html() + "<TR style='padding: 1px;'>"
                            <%
                                if (userPrevList.contains("UNDO_PURCHASE")) {
                            %>
                                            + "<TD style='text-align:center;background: #f1f1f1;font-size: 14px;'>"
                                            + "<div class='remove' id='remove' onclick='removeRow(this)' value='" + info.id + "'></div>"
                            
                                            + "<input type='hidden' id='rowId' value='" + info.id + "' />"
                                            + "</TD>\n"
                            <%
                                }
                            %>
                                + "<TD style='text-align:center;background: #f1f1f1;font-size: 14px;'>\n\
                                    <b id='1'> " + $("#unitCodeSell").val() + "</br>\
                                    <input type='hidden' id='rowId' value=" + info.projectID + " />  </TD>\n\
                                <TD style='text-align:center;background: #f1f1f1;font-size: 14px;'>\n\
                                    <b id='2'>  " + info.projectName + " </br>       </TD>\n\
                                <TD style='text-align:center;background: #f1f1f1;font-size: 14px;'>\n\
                                    <b id='3'>    " + "التفاصيل" + "</br>  </TD>\n\
                            </TR>").show();
                                    showCalendar(true);
                                } else if (eqpEmpInfo.status == 'no') {
                                    alert("لم يتم البيع");
                                }
                            }
                        });
                    }
                    function popupReservation() {
                        divID = "reserveDialog";
                        $('#overlay').show();
                        $("#reservationBtn").show();
                        $('#reserveDialog').find("#clientStatusNotes").val("");
                        $('#reserveDialog').css("display", "block");
                        $('#reserveDialog').css("opacity", "100");
                        $('#reserveDialog').dialog(); //.bPopup({easing: 'easeInOutSine',
//                            speed: 400,
//                            transition: 'slideDown'});
                    }
    function changeClientRate(clientID) {
        var rateID = $("#clientRate option:selected").val();
        $.ajax({
            type: "post",
            url: "<%=context%>/ClientServlet?op=changeClientRate",
            data: {
                rateID: rateID,
                clientID: clientID
            },
            success: function (jsonString) {
                var info = $.parseJSON(jsonString);
                if (info.status == 'ok') {
                    alert("تم التقييم");
                } else {
                    alert("خطأ لم يتم التقييم");
                }
            }
        });

    }
</script>

<body>
    <div id="add_incentives" style="width: 30% !important;display: none;position: fixed ;"></div>

    <div id="show_comments"   style="width: 50% !important;display: none;position: fixed ;">

    </div>
    <div id="add_campaigns"   style="width: 50% !important;display: none;position: fixed ; z-index: 1000; height: 550px;">

    </div>
    <div id="overlay" class="overlayClass" onclick="JavaScript: closeOverlay();">

    </div>
    <div id="show_appointment"  style="width: 97% !important;display: none;margin-left: auto;margin-right: auto;text-align: center;position: fixed ;">

    </div>
    <div id="show_campaigns"   style="width: 70%;display: none;position: fixed ;margin-top: 0px;">

    </div>
    <div id="show_attached_files2"   style="width: 70% !important;display: none;position: fixed ;">

    </div>
      <FORM NAME="CLIENT_COMPLAINT_FORM" METHOD="POST" >

        <br>
        <div  id="call_center"  style="border: none;clear: both;">
          
             <fieldset  class="set" style="width:95%; border-color: #006699;  ">
                    <legend align='center' style="color: #FF3300;  ">
                          <font color="#005599" size="4" >
                          <fmt:message bundle="${getcompl3}" key="client" />
                                </font>
                    </legend>
                    <TABLE style="width:100%; "dir='<fmt:message bundle="${getcompl3}"  key="direction" />'>
                        <TR>
                            <TD style="width:40%; border:none; ">
                                 
                               <TABLE width="100%"  dir='<fmt:message bundle="${getcompl3}"  key="direction" />' >
                            <tr>
                                <td style="border: none;width:100%;">
                                      <TABLE class='subtable' width="95%" align="center" dir='<fmt:message bundle="${getcompl3}"  key="direction" />'  >
                                       <TR>
                                            <td nowrap  class="silver_footer " style="width:35%;"> <fmt:message bundle="${getcompl3}"  key="clientno" />  </td>
                                             <td id="num"> <%=client.getAttribute("clientNO")%> </td>
                                        </TR>
                                        <TR>
                                            <td nowrap  class="silver_footer "style="width:35%;"> <fmt:message bundle="${getcompl3}"  key="clientname" /> </td>
                                             <td id="num"> <%=client.getAttribute("name")%> </td>
                                        </TR>
                                         <tr>
                                             <td style="color: #000;"  ><fmt:message bundle="${getcompl3}"  key="clientrating" />  </td>
                                           
                                            <td style="text-align: center;">
                                                <%
                                                    if (privilegesList.contains("CLIENT_RATING")) {
                                                %>
                                                <select name="clientRate" id="clientRate" style="width: 200px; direction: rtl;"
                                                        onchange="JavaScript: changeClientRate('<%=client.getAttribute("id")%>');">
                                                    <option>Select Client Rate</option>
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
                                                    WebBusinessObject rateWbo = null;
                                                    if (clientRateWbo != null) {
                                                        rateWbo = projectMgr.getOnSingleKey((String) clientRateWbo.getAttribute("rateID"));
                                                    }
                                                    if (rateWbo != null) {
                                                %>
                                                <%=rateWbo.getAttribute("projectName")%> <img src="images/msdropdown/<%="UL".equals(rateWbo.getAttribute("optionThree")) ? "black" : rateWbo.getAttribute("optionThree")%>.png"/>
                                                <%
                                                } else {
                                                %>
                                                <%=noRating%>
                                                <%
                                                        }
                                                    }
                                                %>
                                            </td>
                                        </tr>
                                        <tr>
                                             <td nowrap  class="silver_footer "style="width:35%;"> <fmt:message bundle="${getcompl3}"  key="custstatus" /></td>
                                            <td   colspan="3">
                                                <TABLE style="width: 100%">
                                                    <TR >
                                                        <TD style="width: 80% ;border: none">
                                                             <span id='cstmr' class="label label-default" style="font-size: 16px;">cstmr</span>
                                                               <span id='cnct' class="label label-default"  style="font-size: 16px;">cnct</span>
                                                               <span id='oprt' class="label label-default"  style="font-size: 16px;">oprt</span>
                                                               <span id='lead' class="label label-default"  style="font-size: 16px;">lead</span>
                                                            </TD>
                                                            <TD style="width: 20%; border: none">
                                                                
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
                                                                <img src="images/arrow-right.ico" width="30px"  onclick="JavaScript: popupClientReservation();" id="changeStatusClient"
                                                                 style="display: <%=clientStatus.equals("14") ? "block" : "none"%>;"/>
                                                                <img src="images/arrow-left.ico" width="30px"  onclick="JavaScript:popupReverseStatus();" id="changeStatusReverse" style="display: <%=clientStatus.equals("11") && privilegesList.contains("client_status_reverse") ? "block" : "none"%>;"/>
                                                            </TD>
                                                    </TR>
                                                </TABLE>
                                                
                                        
                                     </td> 
                                     <script >
                                         var status=<%=clientStatus%>;
                                          assigncuststatus(status);
                                     </script>
                                     
                                        </tr>
                            <%if (CompetentEmp != null && CompetentEmp.size() > 0) {%>               
                            <tr >
                                <td  style="color: #000; ">الموظف المختص</td>
                                <td class='td' style="display: <%=clientStatus.equals("11") && privilegesList.contains("client_status_reverse") ? "block" : "none"%>;">
                                    &nbsp;
                                </td>
                                <!--<td style="text-align: right;"><label id="textS"></label><input type="hidden" id="empId" name="empId" value="" /></td>-->
                                <td style="text-align: right;">


                                    <a href="#" style="color: #005599" onclick="xx()">مشاهدة</a>
                                </td>
                            </tr>

                            <%                                    }
                                String clientId = (String) client.getAttribute("id");
                                customerGrade = customerGradesMgr.getOnSingleKey("key1", clientId);

                                if (customerGrade != null) {
                                    String grade = (String) customerGrade.getAttribute("gradeId");
                                    String gradeStatus = "";
                            %>
                             
                            <%if (grade.equals("1")) {
                                    gradeStatus = "عادى";
                                } else if (grade.equals("2")) {
                                    gradeStatus = "جيد";
                                } else if (grade.equals("3")) {
                                    gradeStatus = "ممتاز";
                                }

                            %>
                         
                            <% } else {%>
                       
                            <%}%> 
                             <TR style=" padding-top: 3%;" dir='<fmt:message bundle="${getcompl3}"  key="direction" />'>
                                        <TD  colspan="3" style="border: none; width:100%;">
                                            <TABLE align="center" style="border: none; width:60%;"> 
                                                <tr  style="border: none; width:100%;">
                                                    <TD><a href="#" onclick="clientInformation(this)"><image style="height:35px;" src="images/user_red_edit.png" title="Edit"/></a></TD>
                                                    <TD><a href="#" onclick="printClientInformation(this)"><image style="height:39px;" src="images/pdf_icon.gif" title="Datasheet"/></a></TD>
                                                    <TD> 
                                                        <a id="unbookmarked" href="#" style="float: right; display: <%=bookmarksList != null && bookmarksList.isEmpty() ? "block" : "none"%>"
                                           onclick="popupCreateBookmark(this, '<%=client.getAttribute("id")%>', '<%=client.getAttribute("name")%>')">
                                            <image src="images/star1.jpg" title="علامة" style="height: 35px;"/></a>
                                        <a id="bookmarked" href="#" style="width: 16px;height: 32px;float: right; display: <%=bookmarksList == null || !bookmarksList.isEmpty() ? "block" : "none"%>"
                                           onclick="deleteBookmark(this, '<%=bookmarkId%>', '<%=client.getAttribute("id")%>')">
                                            <image src="images/star2.jpg" title="<%=bookmarkDetails%>" style="height: 35px;" id="bookmarkedImg"/></a></TD>
                                                    <TD><a href="#" onclick="printClientFincancial(this)"><image style="height:42px;" src="images/finical-rebort.png" title="Financials"/></a>
</TD>
                                                    <TD><a href="#" onclick="viewClientContract(this)"><image style="height:42px;" src="images/contract_icon.jpg" title="Contracts"/></a>
 </TD>
                                                    <TD><a href="<%=context%>/ClientServlet?op=clientDetails&clientId=<%=client.getAttribute("id")%>"><image style="height:42px;" src="images/view-details.png" title="More Details"/></TD>
                                                </tr>
                                            </TABLE>
                                      
                                        </TD>
                                    </TR>
                        </table>
                        </td>
                        </tr>
                        </table>

                            </TD>
                            <TD style="width:40%; border:none;">
                                
                                 <%
                                     if (groupPrev.size() > 0) {
                                %>
                         <table style="width: 60%; margin-<fmt:message bundle="${getcompl3}"  key="align" /> :15% ">
                                  
                            <TR style=" " dir='<fmt:message bundle="${getcompl3}"  key="direction" />'>
                                
                                <TD id="btnscolumn" style="border: none; width:20%;">
                                              <input type="button"  onclick="JavaScript: popupEmail(this);"  class="button2 <fmt:message bundle="${getcompl3}"  key="css-email" />" value='<fmt:message bundle="${getcompl3}"  key="email" />' />
                                  </TD>
                                  
                                              <TD id="btnscolumn" style="border: none; width:20%;">
                                                  <input type="button" onclick="popupSms(this);" class="button2 <fmt:message bundle="${getcompl3}"  key="css-sms" />" value='<fmt:message bundle="${getcompl3}"  key="sms" />' />
                                              </TD>
                                            
                                                <TD id="btnscolumn" style="border: none; width:20%;">
                                                <div class="dropdown" style="display: inline-table;">
                                                    <input id="attachment-button" type="button"     class="attach_file button2 <fmt:message bundle="${getcompl3}"  key="css-attach" />" value='<fmt:message bundle="${getcompl3}"  key="attachments" />' style="display: <%=userPrevList.contains("client_attach") ? "" : "none"%>;"/>
                                                  <div class="submenuattach">
                                                    <ul class="root">
                                                     <li ><a href="#" style="text-align: right"  onclick="JavaScript: popupAttach2(this);"><fmt:message bundle="${clientproduct}"  key="addfile" />  </a></li>
                                                        <li ><a href="#" style="text-align: right" onclick="JavaScript: showAttachedClientFiles(this);"> <fmt:message bundle="${clientproduct}"  key="showfiles" /> </a></li>
                                                    </ul>
                                                    </div>
                                                
                                                </TD>
                                              
                                             
                                       </TR>
                                         <TR style=" " dir='<fmt:message bundle="${getcompl3}"  key="direction" />'>
                                       <TD id="btnscolumn" style="border: none; width:20%;">
                                             <div class="dropdown" style="display: inline-table; ">
                                        <input type="button" class="button_commen button2 <fmt:message bundle="${getcompl3}"  key="css-comment" />" value='<fmt:message bundle="${clientproduct}"  key="comment" />' />

                                        <div class="submenu">
                                            <ul class="root">
                                                <li >
                                                    <a href="#" style="text-align:right"  onclick="popupAddComment(this)"><fmt:message bundle="${clientproduct}"  key="addcomment" /></a>
                                                </li>
                                                <li >
                                                    <a href="#" style="text-align:right" onclick="popupShowComments(this)"><fmt:message  bundle="${clientproduct}"  key="showcomments" /></a>
                                                </li>

                                            </ul>
                                        </div>

                                    </div>     
                                          </TD>
                                         
                                              <TD id="btnscolumn" style="border: none; width:20%;">
                                                    
                                                     <div class="dropdown" style= "display: inline-table;">
                                        <input type="button"   class="button_pointment button2 <fmt:message bundle="${getcompl3}"  key="css-meeting" />" value='<fmt:message bundle="${getcompl3}"  key="meeting" />' />
                                           <div class="submenu1">
                                            <ul class="root">
                                                <li ><a href="#" style="text-align: right"  onclick="popupApp(this);" ><fmt:message bundle="${clientproduct}" key="addmeeting"/>  </a></li>
                                                <li ><a href="#" style="text-align: right" onclick="popupShowAppointment(this)"> <fmt:message bundle="${clientproduct}" key="showmeetings"/></a></li>

                                            </ul>
                                        </div>

                                    </div>     
                                              </TD>
                                             
                                                <TD id="btnscolumn" style="border: none; width:20%;">
                                                  <input type="button" onclick="popupAddCampagin(this);"   class="button_camp button2 <fmt:message bundle="${getcompl3}"  key="css-campaigns" />" value='<fmt:message bundle="${getcompl3}"  key="campaigns" />' />
                                              </TD>
                                               
                                             
                                       </TR>
                                       <TR>
                                                <TD id="btnscolumn" style="border: none; width:20%; display: <%=userPrevList.contains("client_incentive") ? "" : "none"%>;">
                                                  
                                                  
                                                  <div class="dropdown" style="width: 50%;display: inline-table; float:right;">
                                        <input type="button" class="button_incentive button2 <fmt:message bundle="${getcompl3}"  key="css-gift" />" value='<fmt:message bundle="${getcompl3}"  key="gifts" />' />
                                                                   <div class="submenu_incentive">
                                            <ul class="root">
                                                <li ><a href="#" style="text-align: right"  onclick="JavaScript: incentive();"><fmt:message bundle="${clientproduct}"  key="addgift" />  </a></li>
                                                <li ><a href="#" style="text-align: right" onclick="JavaScript: incentiveList();"><fmt:message bundle="${clientproduct}"  key="showgifts" />  </a></li>
                                            </ul>
                                        </div>
                                    </div>
                                              </TD>
                                           
                                       </TR>
                                </table>
                              <%}%>
                            </TD>
                        </TR>
                    </TABLE>
                                              <br>
             </FIELDSET>
            
        <br>
          <fieldset  class="set" style="width:95%; border-color: #006699;  ">
                    <legend align='center' style="color: #FF3300;  ">
                          <font color="#005599" size="4" >
                              <fmt:message bundle="${getcompl3}"  key="units" />
                                </font>
                    </legend>
                                
                     <div align="center" style="width: 95%;display: block;border: none;" id="tblDataDivSell">
                     <div  style="width: 100%;">
                            <TABLE dir='<fmt:message bundle="${getcompl3}"  key="direction" />'  style="width: 100%;">
                                <TR>
                                    <TD style="border: none">
                                        <b style="float: <fmt:message bundle="${getcompl3}"  key="align"/>;clear: both; color: #005599 ; font-size: 18px;">  <fmt:message bundle="${getcompl3}"  key="purchases"/></b>
                                        
                                    </TD>
                                    <TD style="border: none ; display: <%=metaMgr.getDataMigration().equals("1") ? "" : "none"%>;">
                                         <input type="button"  onclick="JavaScript: popupSell(this);"  class="button3 <fmt:message bundle="${getcompl3}"  key="css-sellunit" />"  style=" float: right ; " value='<fmt:message bundle="${getcompl3}"  key="sellunit" />' />
                                    </TD>
                                </TR>
                            </TABLE>
                          </div> 
                                    
                        <TABLE id="purcheUnits" class="blueBorder" ALIGN="center" dir='<fmt:message bundle="${getcompl3}"  key="direction"/>'  width="100%" cellpadding="0" cellspacing="0">
                            <TR>
                                
                                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="25%" ><b><fmt:message bundle="${getcompl3}"  key="unit"/></b></TD>
                                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="15%" id="empNameShown" value=""><b> <fmt:message bundle="${getcompl3}"  key="project"/>  </b></TD>
                                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="10%"><b> <fmt:message bundle="${getcompl3}"  key="details"/>  </b></TD>
                            <%
                                if(userPrevList.contains("UNDO_PURCHASE")) {
                                %>
                                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold; width: 2%;" nowrap ><b></b></TD>
                                <%
                                }
                                %>
                            </TR>                       
                            <%
                                for (WebBusinessObject wboUnit : purcheUnits) {
                            %>
                            <TR style="padding: 1px;">
                             
                                <TD style="text-align:center;background: #f1f1f1;font-size: 14px;">
                                    <%if (wboUnit.getAttribute("productName") != null) {%>
                                    <b><%=wboUnit.getAttribute("productName")%></b>
                                    <%}%>
                                    <input type="hidden" id="rowId" value='<%=wboUnit.getAttribute("id")%>' />
                                </TD>
                                <TD style="text-align:center;background: #f1f1f1;font-size: 14px;width: 13%;">
                                    <%if (wboUnit.getAttribute("productCategoryName") != null) {%>
                                    <b><%=wboUnit.getAttribute("productCategoryName")%></b>
                                    <%}%>
                                </TD>
                                <TD style="text-align:center;background: #f1f1f1;font-size: 14px;">
                                    <b><fmt:message bundle="${getcompl3}"  key="details"/></b>
                                </TD>
                                   <%
                                if(userPrevList.contains("UNDO_PURCHASE")) {
                                %>
                                <td style="text-align:center;background: #f1f1f1;font-size: 14px; width: 2%;">
                                    <div style="" class="remove" id="remove" onclick="removeRow(this)" value="<%=wboUnit.getAttribute("id")%>"> </div>
                                    <input type="hidden" id="rowId" value='<%=wboUnit.getAttribute("id")%>' />
                                </td>
                                <%
                                }
                                %>
                            </TR>
                            <%
                                }
                            %>
                        </TABLE>

                        
                    </div>
         
                    <br>
                     <div align="center" style="width: 95%;display: block;border: none;" id="tblDataDivReserve">
                      <div  style="width: 100%;">
                            <TABLE dir='<fmt:message bundle="${getcompl3}"  key="direction" />'  style="width: 100%;">
                                <TR>
                                    <TD style="border: none">
                                        <b style="float: <fmt:message bundle="${getcompl3}"  key="align"/>;clear: both; color: #005599 ; font-size: 18px;">  <fmt:message bundle="${getcompl3}"  key="bookings"/></b>
                                    </TD>
                                    <TD style="border: none; display: <%=metaMgr.getDataMigration().equals("1") ? "" : "none"%> ;">
                                         <input type="button"  onclick="JavaScript: popupReservation(this);"  class="button3 <fmt:message bundle="${getcompl3}"  key="css-bookunit" />"  style=" float: right ; " value='<fmt:message bundle="${getcompl3}"  key="bookunit" />' />
                                    </TD>
                                </TR>
                            </TABLE>
                          </div> 
                                    
                        <TABLE id="reservedUnit" class="blueBorder" ALIGN="center" dir='<fmt:message bundle="${getcompl3}"  key="direction"/>'  width="100%" cellpadding="0" cellspacing="0"  > 
                            <TR>

                                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="25%" ><b><fmt:message bundle="${getcompl3}"  key="unit"/></b></TD>
                                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="15%" id="empNameShown" value=""><b><fmt:message bundle="${getcompl3}"  key="project"/></b></TD>
                                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="10%"><b>  <fmt:message bundle="${getcompl3}"  key="payment"/> </b></TD>
                                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="10%"><b><fmt:message bundle="${getcompl3}"  key="bookduration"/>  </b></TD>
                                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="20%"><b> <fmt:message bundle="${getcompl3}"  key="bookdate"/>  </b></TD>
                                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="20%"><b> <fmt:message bundle="${getcompl3}"  key="booktype"/>  </b></TD>
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
                                            String time = creationTime.substring(0, 10);
                                    %>
                                    <b ><%=time%></b>
                                    <%}%>

                                </TD>
                                <TD style="text-align:center;background: #f1f1f1;font-size: 14px;">
                                    <b><%=wbo.getAttribute("productId") != null && wbo.getAttribute("productId").equals("reserved") ? "حجز عادي" : "حجز مرتجع"%></b>
                                </TD>


                            </TR>


                            <%}%>
                        </TABLE>
                        

                     </div>
                        
                        <br>
                         <div align="center" style="width: 95%;display: block;border: none;" id="tblDataDivInterest">
                   
                        <div  style="width: 100%;">
                            <TABLE dir='<fmt:message bundle="${getcompl3}"  key="direction" />'  style="width: 100%;">
                                <TR>
                                    <TD style="border: none">
                                        <b style="float: <fmt:message bundle="${getcompl3}"  key="align"/>;clear: both; color: #005599 ; font-size: 18px;"> <fmt:message bundle="${getcompl3}"  key="desires"/> </b>
                                    </TD>
                                    <TD style="border: none">
                                        <input type="button" onclick="popup(this)" class="Addyourdesires" style=" text-align: center; float: right"/>
                                    </TD>
                                </TR>
                            </TABLE>
                          </div> 
                          <TABLE id="interestedUnit" class="blueBorder" ALIGN="center" dir='<fmt:message bundle="${getcompl3}"  key="direction"/>'  width="100%" cellpadding="0" cellspacing="0" > 
                             <TR>
                                
                                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="20%" id="empNameShown" value=""><b><fmt:message bundle="${getcompl3}"  key="project"/></b></TD>
                                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="10%"><b><fmt:message bundle="${getcompl3}"  key="area"/></b></TD>
                                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="10%"><b><fmt:message bundle="${getcompl3}"  key="payment"/></b></TD>
                                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="10%"><b><fmt:message bundle="${getcompl3}"  key="duration"/> </b></TD>
                                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="25%"><b><fmt:message bundle="${getcompl3}"  key="notes"/></b></TD>
                            <TD CLASS="silver_header" STYLE="border-right: none; text-align:center;color:black;font-size:14px;font-weight: bold; width: 1%;" nowrap ><b></b></TD>
                            <TD CLASS="silver_header" STYLE="border-left: none; text-align:center;color:black;font-size:14px;font-weight: bold; width: 1%; display: <%=userPrevList.contains("DELETE_INTERESTED") ? "block" : "none"%>;" nowrap ><b></b></TD>
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

                               
                                <TD style="text-align:center;background: #f1f1f1;font-size: 14px;width: 25%;">

                                    <%if (wbo2.getAttribute("productCategoryName") != null) {%>
                                    <b id="2"><%=wbo2.getAttribute("productCategoryName")%></b>
                                    <input type="hidden" id="productCategoryId" value='<%=wbo2.getAttribute("productCategoryId")%>' />
                                    <input type="hidden" id="projectId" value='<%=wbo2.getAttribute("projectId")%>' />
                                    <input type="hidden" id="rowId" value='<%=wbo2.getAttribute("id")%>' />
                                    <%}
                                    %>

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
                                <TD style="text-align:center;background: #f1f1f1;font-size: 14px; width: 25%;">

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
                                
                                 <td style="border-right: none; text-align:center;background: #f1f1f1;font-size: 14px;  display: <%=userPrevList.contains("DELETE_INTERESTED") ? "block" : "none"%>;">
                                    <div style="" class="remove" id="remove" onclick="removeRow(this)" value="<%=wbo2.getAttribute("id")%>"> </div>
                                 </td>
                                <td style="border-left:  none; text-align:center;background: #f1f1f1;font-size: 14px; ">
                                     <div  class="update"  id="updateRow" onclick="updateRow(this)" value="<%=wbo2.getAttribute("id")%>"> </div>
                                 </td>
                                <TD style="border: none; display: none" ><input id="updateId"  type="hidden" value="<%=wbo2.getAttribute("id")%>"/>
                                    <input id="ID"  type="hidden" value=""/></TD>
                            </TR>
                              


                            <%

                                }

                            %>   <% }%>   
                        </TABLE>
                        
                                    
                        

                         </div>
          </FIELDSET>
            
                    <br>
                    
                     
<DIV id="POPUPS">
                             
   <!-- client infromation popup -->
    <div id="clientInformation" style="display: none;width: 65%;position: fixed; z-index: 1000; margin: auto;">

        <div style="clear: both;margin-left: 93%;margin-top: 0px;margin-bottom: -38px;z-index: -10000000;">
            <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);background-color: transparent;
                 -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                 box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                 -webkit-border-radius: 100px;
                 -moz-border-radius: 100px;
                 border-radius: 100px;" onclick="closePopupDialog('clientInformation')"/>
        </div>

        <!--<h1>رسالة قصيرة</h1>-->
        <div class="login" style="width:90%;margin-left: auto;margin-right: auto;">
            <table  border="0px" class="table" style="width:100%;text-align: right;margin-bottom: 10px !important;margin-left: auto;margin-right: auto;" >
                <!--<table align="right" width="30%" class="login" style="display: none;color: white" id="" cellpadding="3px;" cellspacing="3px;">-->
                <%
                    //  if (connectByRealEstate != null && !connectByRealEstate.equals("")
                    //     && connectByRealEstate.equals("1")) {
                %>

                <%//} else {%>
                <tr >
                    <td style="width: 50%;">
                        <table>
                            <tr>
                                <td width="40%"style="color: #000;text-align: match-parent" >رقم العميل</td>
                                <td style="text-align:right;border: none;">
                                    <label style="float: right;" id="clientNO"><%=client.getAttribute("clientNO").toString()%></label>
                                    <hr style="float: right;width: 70%;clear: both;" >
                                </td>
                            </tr>
                            <!--                                <tr>
                                                                <td width="40%" style="color: #000;" >رقم العميل</td>
                                                                <td style="text-align:right;border: none;"><label style="color: #ffffff;" id="clientNO"><%=client.getAttribute("clientNO")%></label>
                                                                    <hr style="float: right;width: 70%;clear: both;" 
                            
                                                                </td>
                                                            </tr>-->

                            <tr>
                                <td style="color: #000;" width="40%" >اسم العميل</td>
                                <td style="text-align:right;"><label class="showx" id="clientName"><%=client.getAttribute("name")%></label>
                                    <hr style="float: right;width: 70%;" class="showx">
                                    <input type="text"  name="clientName" class="hidex" <%=!isCanMoreEdit ? "readonly" : ""%> value="<%=client.getAttribute("name")%>"/>
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
                            <%if (client.getAttribute("partner") != null && !client.getAttribute("partner").equals("")) {
                            %>
                            <tr>
                                <td style="color: #000;" width="40%" >إسم الزوجة/الزوج</td>
                                <td style="text-align:right"><label id="partner"class="showx"><%=client.getAttribute("partner")%></label>
                                    <hr style="float: right;width: 70%;" class="showx">
                                    <input type="text"  name="partner" class="hidex" value="<%=client.getAttribute("partner")%>"/>
                                </td>
                            </tr>
                            <%} else {%>
                            <tr>
                                <td style="color: #000;" width="40%" >إسم الزوجة/الزوج</td>
                                <td style="text-align:right"><label id="partner"class="showx"><%=client.getAttribute("partner")%></label>
                                    <hr style="float: right;width: 70%;" class="showx">
                                    <input type="text"  name="partner" class="hidex" value=""/>
                                </td>
                            </tr>

                            <%}%>
                            <TR>
                                <TD td style="text-align:center; font-weight: bold; font-size: 16px; color: black;" width="35%" ><%=birthDate%> </TD>
                                <td style="text-align:right"><label id="birthDate" class="showx"><%=client.getAttribute("birthDate").toString()%></label>
                                    <hr style="float: right;width: 70%;" class="showx">
                                    <input readonly type="text" id="birthDateCal"  name="birthDate" class="hidex" value="<%=client.getAttribute("birthDate").toString()%>"/>
                                </td>        
                            </TR>    
                            <TR>
                                <TD td style="text-align:center; font-weight: bold; font-size: 16px; color: black;" width="28%" >النوع</TD>

                                <td style="<%=style%>" class='td'>
                                    <span><input type="radio" name="gender" value="ذكر"  <% if (client.getAttribute("gender").equals("ذكر") || client.getAttribute("gender").equals("UL")) {%> checked="true" <%}%>/>  <font size="3" color="#005599"><b>ذكر</b></font></span>
                                    <span><input type="radio"  name="gender" value="أنثى"  <% if (client.getAttribute("gender").equals("أنثى")) {%> checked="true" <%}%>/>  <font size="3" color="#005599"><b>أنثى</b></font></span>
                                </td>
                            </TR>

                            <TR>
                                <TD td style="text-align:center; font-weight: bold; font-size: 16px; color: black;"  width="28%" >

                                    الحالة الإجتماعية
                                </TD>

                                <td style="<%=style%>" class='td'>
                                    <span><input type="radio" name="matiral_status" value="أعزب"  <% if (client.getAttribute("matiralStatus").equals("أعزب") || client.getAttribute("matiralStatus").equals("UL")) {%> checked="true" <%}%>/>  <font size="3" color="#005599"><b>أعزب</b></font></span>
                                    <span><input type="radio" name="matiral_status" value="متزوج" <% if (client.getAttribute("matiralStatus").equals("متزوج")) {%> checked="true" <%}%> />  <font size="3" color="#005599"><b>متزوج</b></font></span>
                                    <span><input type="radio" name="matiral_status" value="مطلق"  <% if (client.getAttribute("matiralStatus").equals("مطلق")) {%> checked="true" <%}%>/>  <font size="3" color="#005599"><b>مطلق</b></font></span>
                                    <span><input type="radio" name="matiral_status" value="غير محدد"  <% if (client.getAttribute("matiralStatus").equals("غير محدد")) {%> checked="true" <%}%>/>  <font size="3" color="#005599"><b>غير محدد</b></font></span>

                                </td>

                            </TR>

                            <%if (client.getAttribute("clientSsn") != null && !client.getAttribute("clientSsn").equals("")) {
                            %>
                            <tr>
                                <td style="color: #000;" width="40%" >ر.قومى / ج. سفر</td>
                                <td style="text-align:right;">
                                    <label id="clientSsn" class="showx"><%=client.getAttribute("clientSsn")%></label>
                                    <hr style="float: right;width: 70%;" class="showx">

                                    <input type="text" name="clientSsn" class="hidex" value="<%=client.getAttribute("clientSsn")%>" />

                                </td>
                            </tr>
                            <%} else {%>
                            <tr>
                                <td style="color: #000;" width="40%">ر.قومى / ج. سفر</td>
                                <td style="text-align:right;"><label class="showx" id="clientSsn"></label>
                                    <hr style="float: right;width: 70%;" class="showx">
                                    <input type="text"  name="clientSsn" class="hidex" value="" />
                                </td>
                            </tr>
                            <%}%>
                            <tr>
                                <td style="color: #000;" width="40%">
                                    <LABEL FOR="job" style="color: #000;">
                                        <p><b>المهنة<font color="#FF0000"></font></b>&nbsp;
                                    </LABEL>
                                </td>
                                <td style="<%=style%>"class='td'>
                                    <%
                                        String jobName = "";
                                        if (client.getAttribute("job") != null && !client.getAttribute("job").equals("")) {
                                            String jobCode = (String) client.getAttribute("job");
                                            WebBusinessObject wbo5 = new WebBusinessObject();
                                            wbo5 = tradeMgr.getOnSingleKey(jobCode);
                                            if (wbo5 != null) {

                                                jobName = (String) wbo5.getAttribute("tradeName");
                                            } else {
                                                jobName = "لم يتم الإختيار";
                                            }
                                        }
                                    %>


                                    <label class="showx" id="clientJob"><%=jobName%></label>
                                    <SELECT name="job" id="job" style="width: 100px;text-align:center;font-size: 13px;font-weight: bold;" class="hidex">


                                        <OPTION value="000"> ---إختر---</OPTION>
                                            <%
                                                if (jobs != null && !jobs.isEmpty()) {
                                                    for (WebBusinessObject wbo3 : jobs) {%>
                                        <OPTION value="<%=wbo3.getAttribute("tradeId")%>"><%=wbo3.getAttribute("tradeName")%></OPTION>

                                        <%
                                                }

                                            }

                                        %>
                                    </SELECT>


                                </td>
                            </tr>
                            <tr>
                                <td style="color: #000;" width="40%">
                                    <LABEL FOR="job" style="color: #000;">
                                        <p><b>المنطقة<font color="#FF0000"></font></b>&nbsp;
                                    </LABEL>
                                </td>
                                <td style="text-align: right;color: #005599">
                                    <%                                        String regionName = "";
                                        String regionID = "";

                                        projectMgr = ProjectMgr.getInstance();
                                        WebBusinessObject wbo_ = new WebBusinessObject();
                                        wbo_ = projectMgr.getOnSingleKey((String) client.getAttribute("region"));
                                        if (wbo_ != null) {
                                            regionName = (String) wbo_.getAttribute("projectName");
                                            regionID = (String) wbo_.getAttribute("projectID");
                                        }
                                    %>
                                    <label class="showx" id="regionText"><%=regionName%></label>
                                    <table class="hidex" style="margin-bottom: 20px;display: block; margin-right: -5px;" ALIGN="center"  dir="<%=dir%>" border="0" id="regionTable">
                                        <tr>
                                            <td style="<%=style%>" class="td2">
                                                <input class="hidex" type="text" readonly id="regionName" name="regionName" value="<%=regionName%>" >
                                                <input type="hidden" id="region" name="region" value="<%=regionID%>" >
                                            </td>
                                            <td style="border: 0px">
                                                <input class="hidex" type="button" style="width:70px;" onclick="window.open('<%=context%>/EquipmentServlet?op=getAllRegions', '_blank', 'status=1,scrollbars=1,width=400,height=400')"  value="<%=search%>">
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td style="width: 50%;">
                        <table>
                            <%if (client.getAttribute("phone") != null && !client.getAttribute("phone").equals("")) {
                            %>

                            <tr>
                                <td style="color: #000;" width="40%" >رقم التليفون</td>
                                <td style="text-align:right;"><label class="showx" id="phone"><%=client.getAttribute("phone")%></label>
                                    <hr style="float: right;width: 70%;" class="showx">

                                    <input type="text"  name="phone" class="hidex" value="<%=client.getAttribute("phone")%>" onkeypress="javascript:return isNumber(event)"/>
                                </td>
                            </tr>
                            <%} else {%>
                            <tr>
                                <td style="color: #000;" width="40%" >رقم التليفون</td>
                                <td style="text-align:right;"><label class="showx" id="phone"></label>
                                    <hr style="float: right;width: 70%;" class="showx">
                                    <input type="text" name="phone" class="hidex" value="" onkeypress="javascript:return isNumber(event)"
                                           maxlength="10"/>
                                </td>
                            </tr>
                            <%}%>
                            <tr>
                                <td style="color: #000;" width="40%" >رقم الموبايل</td>
                                <td style="text-align:right;"><label  class="showx" id="client_mobile"><%=client.getAttribute("mobile")%></label>
                                    <hr style="float: right;width: 70%;" class="showx">

                                    <input type="text"  name="client_mobile" class="hidex" <%=!isCanMoreEdit ? "readonly" : ""%> value="<%=client.getAttribute("mobile")%>" onkeypress="javascript:return isNumber(event)"
                                           maxlength="11"/>
                                </td>
                            </tr>
                            <tr>
                                <td style="color: #000;" width="40%" >رقم الطالب</td>
                                <td style="text-align:right;"><label  class="showx" id="dialedNumber"><%=client.getAttribute("option3") != null ? client.getAttribute("option3") : ""%></label>
                                    <hr style="float: right;width: 70%;" class="showx">

                                    <input type="text"  name="dialedNumber" class="hidex" value="<%=client.getAttribute("option3") != null ? client.getAttribute("option3") : ""%>" onkeypress="javascript:return isNumber(event)"
                                           maxlength="14"/>
                                </td>
                            </tr>
                            <tr>
                                <td style="color: #000;" width="40%" >الرقم الدولى</td>
                                <td style="text-align:right;"><label  class="showx" id="interPhone"><%=client.getAttribute("interPhone") != null ? client.getAttribute("interPhone") : ""%></label>
                                    <hr style="float: right;width: 70%;" class="showx">

                                    <input type="text"  name="interPhone" class="hidex" value="<%=client.getAttribute("interPhone") != null ? client.getAttribute("interPhone") : ""%>" onkeypress="javascript:return isNumber(event)"
                                           maxlength="16"/>
                                </td>
                            </tr>
                            <tr>
                                <TD td style="text-align:center; font-weight: bold; font-size: 16px; color: black;"  width="28%" >

                                    الفرع
                                </TD>

                                <td style="<%=style%>" class='td'>
                                    <% for (int a = 0; a < userProjects.size(); a++) {
                                            WebBusinessObject obj = (WebBusinessObject) userProjects.get(a);
                                    %>

                                    <div><span><input type="radio" name="clientBranch" value="<%=obj.getAttribute("projectID")%>"  <% if (client.getAttribute("branch") != null && client.getAttribute("branch").equals(obj.getAttribute("projectID"))) {%> checked="true" <%}%>/>  <font size="3" color="#005599"><b><%=obj.getAttribute("projectName")%></b></font></span></div>

                                    <%}%>
                                    <div><span><input type="radio" name="clientBranch" value="UL"  <% if (client.getAttribute("branch") != null && client.getAttribute("branch").equals("UL")) {%> checked="true" <%}%>/>  <font size="3" color="#005599"><b>غير محدد</b></font></span></div>

                                </td>
                            </tr>
                            <%if (client.getAttribute("address") != null && !client.getAttribute("address").equals("")) {
                            %>
                            <tr>
                                <td style="color: #000;"  width="40%">العنوان</td>
                                <td style="text-align:right;"><label class="showx" id="address"><%=client.getAttribute("address")%></label>
                                    <hr style="float: right;width: 70%;" class="showx">

                                    <input type="text"  name="address" class="hidex" value="<%=client.getAttribute("address")%>"/>
                                </td>
                            </tr>
                            <%} else {%>
                            <tr>
                                <td style="color: #000;"  width="40%">العنوان</td>
                                <td style="text-align:right;"><label class="showx"  id="address"></label>
                                    <hr style="float: right;width: 70%;" class="showx">
                                    <input type="text"  name="address" class="hidex" value=""/>
                                </td>
                            </tr>

                            <%}%>
                            <%if (client.getAttribute("email") != null && !client.getAttribute("email").equals("")) {
                            %>
                            <tr>
                                <td style="color: #000;"  width="30%" >البريد الإلكترونى</td>
                                <td style="text-align:right;"><label  class="showx"  id="email"><%=client.getAttribute("email")%></label>
                                    <hr style="float: right;width: 90%;" class="showx">

                                    <input type="text"  name="email" class="hidex" value="<%=client.getAttribute("email")%>"/>
                                </td>
                            </tr>
                            <%} else {%>
                            <tr>
                                <td style="color: #000;"  width="30%" >البريد الإلكترونى</td>
                                <td style="text-align:right;"><label  class="showx"  id="email"></label>
                                    <hr style="float: right;width: 90%;" class="showx">
                                    <input type="text"  name="email" class="hidex" value=""/>
                                </td>
                            </tr>
                            <%}%>
                            <!--
                            --><tr>
                                <td style="color: #000;"  width="40%" >يعمل بالخارج</td>

                                <td style="text-align:right;">
                                    <span><input type="radio" name="workOut" value="1"  <% if (client.getAttribute("option1") != null && client.getAttribute("option1").equals("1")) {%> checked="true" <%}%>/> <b style="font-size: 11px;">نعم</b></font></span>
                                    <span><input type="radio" name="workOut" value="0"  <% if (client.getAttribute("option1") != null && client.getAttribute("option1").equals("0")) {%> checked="true" <%}%>/> <b style="font-size: 11px;">لا</b></font></span>
                                </td>

                            </tr>

                            <tr>
                                <td style="color: #000;width: 40%;"  width="40%" >أقارب بالخارج</td>
                                <td style="text-align:right;">
                                    <span><input type="radio" name="kindred" value="1"  <% if (client.getAttribute("option2") != null && client.getAttribute("option2").equals("1")) {%> checked="true" <%}%>/> <b style="font-size: 11px;">نعم</b></font></span>
                                    <span><input type="radio" name="kindred" value="0"  <% if (client.getAttribute("option2") != null && client.getAttribute("option2").equals("0")) {%> checked="true" <%}%>/> <b style="font-size: 11px;">لا</b></font></span>
                                </td>
                            </tr>
                            <tr>
                                <td style="color: #000;width: 40%;"  width="40%" >ملاحظات</td>
                                <td style="text-align:right;">
                                    <label  class="showx" id="description"><%=client.getAttribute("description") != null && !((String) client.getAttribute("description")).equals("UL") ? client.getAttribute("description") : ""%></label>
                                    <hr style="float: right;width: 90%;" class="showx">
                                    <textarea name="description" class="hidex" cols="26" rows="7"><%=client.getAttribute("description") != null && !((String) client.getAttribute("description")).equals("UL") ? client.getAttribute("description") : ""%></textarea>
                                </td>
                            </tr>

                            <!--TR>
                                <TD td style="text-align:center; font-weight: bold; font-size: 16px; color: black;"  width="28%" >الفئة العمرية</TD>

                                <td style="<%=style%>" class='td'>
                                    
                                    <span><input type="radio" name="age" value="20-30"  <% if (client.getAttribute("age").equals("20-30")) {%> checked="true" <%}%>/> <b style="font-size: 11px;">20-30</b></font></span>
                                    <span><input type="radio" name="age" value="30-40"  <% if (client.getAttribute("age").equals("30-40")) {%> checked="true" <%}%>/> <b style="font-size: 11px;">30-40</b></font></span>
                                    <span><input type="radio" name="age" value="40-50" <% if (client.getAttribute("age").equals("40-50")) {%> checked="true" <%}%>/>  <b  style="font-size: 11px;">40-50</b></font></span>
                                    <span><input type="radio" name="age" value="50-60"  <% if (client.getAttribute("age").equals("50-60")) {%> checked="true" <%}%>/>  <b  style="font-size: 11px;">50-60</b></font></span>

                                </td>
                            </TR-->
                        </table>
                    </td>
                </tr>

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

    <div id="unit_content" style="display: none;width: 30%;position: fixed; z-index: 1000;">
        <!--<form name="email_form">-->
        <div style="clear: both;margin-left: 88%;margin-top: 0px;margin-bottom: -38px;z-index: -10000000;">
            <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                 -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                 box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                 -webkit-border-radius: 100px;
                 -moz-border-radius: 100px;
                 border-radius: 100px;" onclick="closePopupDialog('unit_content')"/>
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
                    <td style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 30%;" >المشروع</td>
                    <td width="70%" style="text-align:right;">
                        <SELECT name='mainProduct' id='mainProduct' style='width:170px;font-size:16px;'>
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
                    <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 30%;">المساحة</td>
                    <td style="text-align:right;">
                        <select id="budget" name="budget">
                            <option value="80-100">80-100</option>
                            <option value="100-120">100-120</option>
                            <option value="120-150">120-150</option>
                            <option value="150-200">150-200</option>
                            <option value="200-250">200-250</option>
                            <option value="250-300">250-300</option>
                            <option value="300-400">300-400</option>
                        </select>
                    </td>


                </tr>
                <tr>
                    <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 30%;">الفترة</td>
                    <td style="text-align:right;">
                        <SELECT name='period' id='period' style="font-size: 15px;"> 
                            <OPTION value="سنه">سنه</OPTION> <OPTION value="سنتين">سنتين</OPTION> 
                                <%
                                    for (int c = 3; c <= 10; c++) {
                                %> 
                            <OPTION value='<%=c%>سنين'><%=c%>سنين</OPTION> 
                                <%
                                    }
                                %>
                                <%
                                    for (int c = 11; c <= 15; c++) {
                                %> 
                            <OPTION value='<%=c%>سنه'><%=c%>سنه</OPTION> 
                                <%
                                    }
                                %>
                        </SELECT>
                    </td>
                </tr>



                <tr>
                    <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 30%;">نظام الدفع</td>
                    <td style="text-align:right;">
                        <SELECT name='paymentSystemInterested' id='paymentSystemInterested' style="font-size: 15px;"> 
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


                            <input type="button" value="إضافة" id="addUnit" onclick="javascript: addUnitRecord(this)" style="font-size: 15px;font-family: serif;display: none;"/>
                            <input type="button" value="تحديث" id="updateUnit" onclick="javascript: updateUnitRecord(this)" style="font-size: 15px;font-family: serif;display: none;margin-left: auto;margin-right: auto;"/>
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
           <div class="login" style="width: 90%;text-align: center">
                <form id="emailForm" action="<%=context%>/EmailServlet?op=sendByAjax" method="post" enctype="multipart/form-data">
                    <table class="table " style="width:100%;" dir='<fmt:message bundle="${getcompl3}"  key="direction" />'>


                        <tr >
                            <td style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 30%;"><fmt:message bundle="${getcompl3}"  key="clientno" />  </td>
                            <td style="text-align: <fmt:message bundle="${getcompl3}"  key="align" />;width: 70%;">
                                <b id="clientNo" ></b>
                            </td>


                        </tr>
                        <tr>
                            <td style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 30%;"><fmt:message bundle="${getcompl3}"  key="clientname" />  </td>
                            <td style="text-align:right;width: 70%;">
                                <input type="text" id="clientNa" class="login-input" />
                            </td>
                        </tr>
                        <tr>
                        <%  mail = "";
                            if (client.getAttribute("email") != null) {
                                mail = (String) client.getAttribute("email");
                            }
                        %>
                            <td style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 30%;"><fmt:message bundle="${clientproduct}"  key="to" /></td>
                            <td style="text-align:right;width: 70%;">
                                <input type="text" id="emailTo" value="<%=mail%>"name="to" style="float: right;" class="login-input"/>
                             </td>
                        </tr>



                        <tr>
                            <td style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 30%;" ><fmt:message bundle="${clientproduct}"  key="subject" />  </td>
                            <td style="text-align:right;width: 70%;">
                                <input type="text" size="60" maxlength="60" id="subj" name="subject" class="login-input"/>
                            </td>
                        </tr>
                         
                        <tr>
                            <td style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 30%;"><lable><fmt:message bundle="${clientproduct}"  key="attach" />   </lable>
                        <input type="button" id="addEmailFile" onclick="addEmailFiles(this)" value="+" />

                        <input id="emailCounter" value="0" type="hidden" name="counter"/>
                        </td>
                        <td style="text-align:right;width: 70%;" id="listFile"> 
    
                        </td>

                        </tr>
                        <tr>
                            <td style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 30%;"><fmt:message bundle="${clientproduct}"  key="text" />  </td>
                            <td  style="width: 70%;">

                                <textarea  rows="8" cols="10" name="message"  id="msgContent"class="login-input" style="height: 100px;"></textarea>
                            </td>

                        </tr> 


                    </table>
                    <div style="width: 30%;text-align: center;margin-left: auto;margin-right: auto;" id="emailStatus"></div>

                    <div id="message" style="margin-left: auto;margin-right: auto;text-align: center"></div>
                    <input type="submit" value='<fmt:message bundle="${clientproduct}"  key="send" />'  class="login-submit" style="margin-left: auto;margin-right: auto;text-align: center" onclick="sendMailByAjax()" />

                </form>
                <div id="progressx" style="display: none;">
                    <img src="images/Loading2.gif" width="32px" height="32px;" style="background-repeat: no-repeat;margin-left: auto;margin-right: auto"/>
                </div>
            </div>

        </div>  

        <!--        //Attach file-->
        <div id="attach_file"  style="width: 30%;display: none;position: fixed;margin-left: auto;margin-right: auto">

            <div style="clear: both;margin-left: 90%;margin-top: 0px;margin-bottom: -40px;">
                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                 -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                 box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                 -webkit-border-radius: 20px;
                 -moz-border-radius: 20px;
                 border-radius: 20px;" onclick="closePopup(this)"/>
            </div>
 <div class="login" style="width: 90%;text-align: center">
                <form id="attachForm" action="<%=context%>/EmailServlet?op=attachFile" method="post" enctype="multipart/form-data">
                    <table class="table " style="width:100%;">
                        <tr>
                            <td style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 30%;"><lable><fmt:message bundle="${clientproduct}"  key="attach" />  </lable>
                        <input type="button" id="addFile" onclick="addFiles(this)" value="+" />

                        <input id="counterFile" value="" type="hidden" name="counter"/>
                        <input name="projectId" value="<%=client.getAttribute("id")%>" type="hidden" />
                        </td>
                        <td style="text-align:right;width: 70%;" id="listAttachFile"> 
                        </td>

                        </tr>

                    </table>
                    <div style="width: 30%;text-align: center;margin-left: auto;margin-right: auto;" id="statusFile"></div>

                    <div id="attachMessage" style="margin-left: auto;margin-right: auto;text-align: center"></div>
                    <button type="button" class="login-submit" style="margin-left: auto;margin-right: auto;text-align: center" onclick="submitClientFile()" >
                        <fmt:message bundle="${clientproduct}"  key="upload" />
                    </button>

                </form>
                <div id="progressx2" style="display: none;">
                    <img src="images/Loading2.gif" width="32px" height="32px;" style="background-repeat: no-repeat;margin-left: auto;margin-right: auto"/>
                </div>
            </div>

        </div>
        <!--        //-->
        
     <div id="add_comments"  style="display: none;width: 30%;position: fixed; z-index: 1000;"><!--class="popup_appointment" -->

            <div style="clear: both;margin-left: 148%;margin-bottom: -38px;z-index: -10000000;">
                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                 -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                 box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                 -webkit-border-radius: 100px;
                 -moz-border-radius: 100px;
                 border-radius: 100px;" onclick="closePopupDialog('add_comments')"/>
            </div>
         <div class="login" style="width: 150%;margin-bottom: 10px;margin-left: auto;margin-right: 10%;">

                <table  border="0px"  style="width:100%;"  class="table" dir='<fmt:message bundle="${clientproduct}" key="direction"/>'>
                <%
                    if (metaMgr.getShowCommentType().equalsIgnoreCase("1")) {
                %>
                    <tr>
                        <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 30%;"><fmt:message bundle="${clientproduct}" key="commenttype"/>  </td>
                        <td style="width: 70%;" >
                            <select style="float: right;width: 30%; font-size: 14px;" id="commentType">
                                <option value="0"><fmt:message bundle="${clientproduct}" key="public"/></option>
                                <option value="1"><fmt:message bundle="${clientproduct}" key="private"/></option>
                            </select>
                            <input type="hidden" id="businessObjectType" name="businessObjectType" value="1"/>
                        </td>

                    </tr>
                <%
                } else {
                %>
                    <input type="hidden" id="commentType" name="commentType" value="0"/>
                    <input type="hidden" id="businessObjectType" name="businessObjectType" value="1"/>
                <%
                    }
                %>
                    <tr>
                        <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 30%;"><fmt:message bundle="${clientproduct}" key="comment"/></td>
                        <td style="width: 70%;" >

                            <textarea  placeholder="" style="width: 100%;height: 100px;" id="newCommentArea" name="newCommentArea" > </textarea>
                        </td>

                    </tr> 
                </table>
                <div style="text-align: center;margin-left: auto;margin-right: auto;clear: both" > 
                    <input type="button" value='<fmt:message bundle="${clientproduct}" key="save"/>'   onclick="saveComment(this)" id="saveComm"class="login-submit"/></div>                             </form>
                <!--<div style="clear: both;display: none"></div>-->
                <div id="progress" style="display: none;">
                    <img src="images/Loading2.gif" width="32px" height="32px;" style="background-repeat: no-repeat;margin-left: auto;margin-right: auto"/>
                </div>
                <div style="margin: 0 auto;display: none; width: 90%;text-align: center;color: white;font-size: 16px;font-weight: bold" id="commMsg">
                    
                    <fmt:message bundle="${clientproduct}" key="commentadded"/>
                </div>


            </div>  
        </div>

        <div id="sms_content"    style="width: 30% !important;display: none;position: fixed">
            <div style="clear: both;margin-left:88%;margin-top: 0px;margin-bottom: -38px;z-index: -10000000;">
                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                 -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                 box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                 -webkit-border-radius: 100px;
                 -moz-border-radius: 100px;
                 border-radius: 100px;" onclick="closePopup(this)"/>
            </div>
  <div class="login" style="width: 85%;margin-bottom: 10px;margin-left: auto;margin-right: auto;">
                <table class="table " dir='<fmt:message bundle="${getcompl3}"  key="direction" />' style="width:100%; ">
                       <tr>
                        <td style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 30%;"><fmt:message bundle="${getcompl3}"  key="clientno" />   </td>
                        <td style="text-align: <fmt:message bundle="${getcompl3}"  key="align" />;width: 70%;">
                            <b id="client_No" style="float: <fmt:message bundle="${getcompl3}"  key="align" />;"></b>
                        </td>


                    </tr>
                    <tr >
                        <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 30%;"><fmt:message bundle="${getcompl3}"  key="clientname" />   </td>
                        <td style="text-align: <fmt:message bundle="${getcompl3}"  key="align" />;width: 70%;">
                             <b id="client_Na" style="float: <fmt:message bundle="${getcompl3}"  key="align" />;"></b>
                        </td>
                    </tr>
                    <tr >
                        <td style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 30%;"><fmt:message bundle="${clientproduct}"  key="mobileno" />   </td>
                        <td style="text-align: <fmt:message bundle="${getcompl3}"  key="align" />;width: 50%;">
                             <input type="text" class="login-input" id="mobile" style="float: <fmt:message bundle="${getcompl3}"  key="align" />;width: 70%;"></b>
                        </td>
                    </tr>

                    <tr>
                        <td style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 30%;"><fmt:message bundle="${clientproduct}"  key="text" />    </td>
                        <td  style="width: 70%;">

                            <textarea  rows="5" cols="10" class="login-input" style="height: 60px;"></textarea>
                        </td>

                    </tr> 
   </table>
                <div style="text-align: center;margin-left: auto;margin-right: auto;width: 100%;clear: both;" > 
                    <input type="submit" value='<fmt:message bundle="${clientproduct}"  key="send" /> ' onclick="javascript: reservedUnit(this)" class="login-submit"/>
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
            <h1><fmt:message bundle="${clientproduct}" key="follow"/>  </h1>
            <table class="table " style="width:100%;" dir="<fmt:message bundle="${clientproduct}" key="direction"/>">

                    <tr >
                        <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 30%;" >
                            <fmt:message bundle="${clientproduct}" key="client"/>                           
                        </td>
                        <td width="70%"style="text-align: <fmt:message bundle="${clientproduct}" key="align"/>;">
                             <b id="appClientName"></b>
                        </td>
                    </tr>
                    <tr>
                        <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 30%;"><fmt:message bundle="${clientproduct}" key="target"/> </td>
                        <td style="text-align : <fmt:message bundle="${clientproduct}" key="align"/> ;width: 70%;">
                            <select id="appTitle" name="appTitle" STYLE="width:200px;font-size: medium; font-weight: bold;">
                                
                            <sw:WBOOptionList wboList='<%=dataArray%>' displayAttribute = "projectName" valueAttribute="projectName" />
                                                
                            </select>
                             <label id="appTitleMsg"></label>
                        </td>
                    </tr>
                     <tr>
                        <td style="color:#f1f1f1;   font-size: 16px;width: 30%;">الالية </td>
                        <td style="text-align: <fmt:message bundle="${clientproduct}" key="align"/>; width: 70%;">
                            <table >
                                <TR>
                                    <TD style="border: none">
                                        <input name="note" type="radio" value="call" checked="" id="note" >
                                        <img src="images/dialogs/phone.png" alt="phone" width="24px">
                                        <fmt:message bundle="${clientproduct}" key="call"/> 
                                    </TD>
                                    <TD style="border: none">
                                         <%
                                if (!departmentID.equals(CRMConstants.DEPARTMENT_CALL_CENTER_ID)) {
                            %>
                    <input name="note" type="radio" value="meeting" id="note" style="margin-right: 10px;" >
                    <img src="images/dialogs/handshake.png" alt="meeting" width="24px"> 
                    <fmt:message bundle="${getcompl3}"  key="meeting" />
                            <%
                                }
                            %>
                                    </TD>
                                </TR>
                            </table>
                            
                           
                        </td>
                    </tr>
                    <tr>
                        <td style="color:#f1f1f1;font-size: 16px;font-weight: bold;width: 30%;"><fmt:message bundle="${clientproduct}"  key="date" /></td>
                        <td style="text-align: <fmt:message bundle="${clientproduct}" key="align"/>; width: 70%;" >
                            <input class="login-input" name="appDate" id="appDate" type="text" size="50" maxlength="50" style="width:200px;font-size: medium; " value="<%=(entry_Date == null) ? nowTime : entry_Date%>"/>
                        </td>

                    </tr> 
                    <tr>
                        <td style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 30%;">
                            <fmt:message bundle="${clientproduct}"  key="location" />
                        <br>
                            
                        
                        </td>
                        <td style="text-align: <fmt:message bundle="${clientproduct}" key="align"/>; width: 70%;">
                            <select id="appointmentPlace" name="appointmentPlace" style="margin-top: 7px;width:200px;font-size: medium;">
                            <sw:WBOOptionList wboList='<%=userProjects%>' displayAttribute = "projectName" valueAttribute="projectName" />
                            <option value="Other">Other</option>
                            </select>
                           
                        </td>
                    </tr>
                    <tr>
                        <td style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 30%;">
                            <fmt:message bundle="${clientproduct}"  key="comment" />
                        </td>
                        <td style="text-align: <fmt:message bundle="${clientproduct}" key="align"/>; width: 70%;">
                            <textarea cols="26" rows="3" id="comment" maxlength="500"></textarea>
                        </td>
                    </tr>
                    
                </table>

                <div style="text-align: center;margin-left: auto;margin-right: auto;" > 
                    <input type="submit" value="<fmt:message bundle="${clientproduct}"  key="save" />" onclick="javascript: saveAppoientment(this)" class="login-submit" style="background: #FF9900;"/></div>
                <div id="progress" style="display: none;">
                    <img src="images/Loading2.gif" width="32px" height="32px;" style="background-repeat: no-repeat;margin-left: auto;margin-right: auto"/>
                </div>

                <div style="margin: 0 auto;display: none; width: 90%;text-align: center;color: white;font-size: 16px;font-weight: bold" id="appMsg"><fmt:message bundle="${clientproduct}"  key="meetingadded" />     </>
                </div>
            </div>  
        </div>





    <%           if (CompetentEmp != null && CompetentEmp.size() > 0) {%>                
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
                    if (CompetentEmp != null && !CompetentEmp.isEmpty()) {
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
                                <input name="title" id="title" value="" readonly/>
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
            <div id="reverseStatus"  style="width: 40%;display: none;position: fixed">
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
            <div id="reserveDialog" style="display: none;width: 70%;position: fixed; z-index: 1000;" >
            <div style="clear: both;margin-left: 90%;margin-top: 0px;margin-bottom: -40px;">
                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                 -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                 box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                 -webkit-border-radius: 20px;
                 -moz-border-radius: 20px;
                 border-radius: 20px;" onclick="closePopupDialog('reserveDialog')"/>
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
                        <%=(String) loggedUser.getAttribute("userName")%>
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
                                        <input class="hidex" type="text" readonly id="unitCode" name="unitCode" value="" />
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
                <table class="table " style="width:100%;"  dir="<%=dir%>" > 
                    <tr>
                        <td style="color:#f1f1f1; font-size: 16px;font-weight: bold;" colspan="2">بيع وحدة</td>
                    </tr>
                    <tr>
                        <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;" nowrap>مسئول المبيعات</td>
                        <td width="70%" style="color:#f1f1f1; font-size: 16px;font-weight: bold; text-align: right;">
                        <%=(String) loggedUser.getAttribute("userName")%>
                        </td>
                    </tr>
                    <tr>
                        <td width="5%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;padding-top: 15px"><%=noodCode%></td>
                        <td width="50%"style="text-align:right;">
                            <table class="hidex" style="display: block; margin-left: -14px;" ALIGN="center"  dir="<%=dir%>" border="0" id="regionTable">
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
        <div id="onholdDialog" style="display: none;width: 35%;position: fixed; z-index: 1000;" >
            <div style="clear: both;margin-left: 90%;margin-top: 0px;margin-bottom: -40px;">
                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                 -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                 box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                 -webkit-border-radius: 20px;
                 -moz-border-radius: 20px;
                 border-radius: 20px;" onclick="closePopupDialog('onholdDialog')"/>
            </div>
            <div class="login" style="width: 90%;text-align: center">
                <table class="table " style="width:100%;" dir="<%=dir%>">
                    <tr>
                        <td style="color:#f1f1f1; font-size: 16px;font-weight: bold;" colspan="2">حجز وحدة (مرتجع)</td>
                    </tr>
                    <tr>
                        <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;" nowrap>مسئول المبيعات</td>
                        <td width="70%" style="color:#f1f1f1; font-size: 16px;font-weight: bold; text-align: right;">
                        <%=(String) loggedUser.getAttribute("userName")%>
                        </td>
                    </tr>
                    <tr>
                        <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;"><%=noodCode%></td>
                        <td width="70%"style="text-align:right;">
                            <table class="hidex" style="display: block; margin-right: -5px;" ALIGN="center"  dir="<%=dir%>" border="0" id="regionTable">
                                <tr>
                                    <td style="<%=style%>" class="td2">
                                        <input class="hidex" type="text" readonly id="unitCodeOnhold" name="unitCodeOnhold" value=""
                                                ondblclick="return getDataInPopup('ProjectServlet?op=getAllAvailableOnholdUnits&fieldName=PROJECT_NAME&fieldValue=' + getASSCIChar(this.value) + '&formName=CLIENT_COMPLAINT_FORM&selectionType=single');">
                                        <input type="hidden" id="unitIdOnhold" name="unitIdOnhold"/>
                                        <input type="hidden" id="parentIdOnhold" name="parentIdOnhold"/>
                                        <input type="hidden" id="onholdChangeStatus" name="onholdChangeStatus"/>
                                    </td>
                                    <td style="border: 0px">
                                        <input type="button" onclick="return getDataInPopup('ProjectServlet?op=getAllAvailableOnholdUnits&fieldName=PROJECT_NAME&fieldValue=' + getASSCIChar($('#unitCode').val()) + '&formName=CLIENT_COMPLAINT_FORM&selectionType=single');"  value="<%=search%>">
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;" nowrap>تاريخ الحجز </td>
                        <td width="70%"style="text-align:right;">
                            <input type="text" size="7" maxlength="7" readonly id="reservationDateOnhold" name="reservationDateOnhold"
                                   style='width:170px;' value="<%=reservationDateStr%>"/>
                        </td>
                    </tr>
                    <tr>
                        <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;">مقدم الحجز</td>
                        <td width="70%"style="text-align:right;">
                            <input type="number" size="7" maxlength="7" id="budgetOnhold" name="budgetOnhold" style='width:170px;'/>
                        </td>
                    </tr>
                    <tr>
                        <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;" nowrap>مدة الحجز</td>
                        <td width="70%"style="text-align:right;">
                            <input type="number" size="7" maxlength="7" id="periodOnhold" name="periodOnhold" style='width:170px;'/>
                        </td>
                    </tr>
                    <tr>
                        <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;">نظام الدفع</td>
                        <td width="70%"style="text-align:right;">
                            <select name="paymentSystemOnhold" id="paymentSystemOnhold" style='width:170px;font-size:16px;'>
                                <option value="فورى">فورى</option>
                                <option value="تقسيط">تقسيط</option>
                            </select>
                        </td>
                    </tr> 
                    <tr>
                        <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;">مكان الدفع</td>
                        <td width="70%"style="text-align:right;">
                            <SELECT name='paymentPlaceOnhold' id='paymentPlaceOnhold' style='width:170px;font-size:16px;'>
                            <%if (paymentPlace != null && !paymentPlace.isEmpty()) {
                            %>
                            <%for (WebBusinessObject Wbo : paymentPlace) {
                                    String productName = (String) Wbo.getAttribute("projectName");
                                    String productId = (String) Wbo.getAttribute("projectID");%>
                                <option value='<%=productName%>'><%=productName%></option>
                            <%}
                            } else {%>
                                <option>لم يتم العثور على فروع</option>
                            <%}%>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" style="color:#f1f1f1; font-size: 16px;font-weight: bold;"> 
                            <input id="onholdBtn" type="submit" value="حجز الأن" onclick="javascript: onholdUnit(this)"/>
                        </td>

                    </tr>
                </table>
            </div>
        </div>
      
                        </DIV>  
                            
            <input type="hidden" id="compTitle" name="compTitle" />
            <input type="hidden" id="compContent" name="compContent"  />
            <input type="hidden" id="managerId" name="managerId"/>
            <input type="hidden" id="clientStatus" name="clientStatus" value="<%=clientStatus%>"/>

                
          </body>
</html>
