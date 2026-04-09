<%@page import="com.clients.db_access.ClientComplaintsMgr"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page import="com.crm.common.CRMConstants"%>
<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="com.tracker.engine.IssueStatusFactory, com.tracker.engine.*,java.text.*,com.docviewer.db_access.*, com.maintenance.db_access.*,com.maintenance.common.ParseSideMenu"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page contentType="text/HTML; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<HTML>
     <c:set var="loc" value="en"/>
    <c:if test="${!(empty sessionScope.currentMode)}">
      <c:set var="loc" value="${sessionScope.currentMode}"/>
    </c:if>
<fmt:setLocale value="${loc}"  />
<fmt:setBundle basename="Languages.Sales_Market.Sales_Market"  />
    <meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <meta HTTP-EQUIV="Expires" CONTENT="0">
    <head>
        <title>Weekly Manager Agenda</title>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css"/>
        <link rel="stylesheet" href="css/demo_table.css"/>
        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/default/easyui.css"/>
        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/icon.css"/>
        <link rel="stylesheet" type="text/css" href="jquery-easyui/demo/demo.css"/>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>
        <script type="text/javascript" src="jquery-easyui/easyloader.js"></script>
    </head>

    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();

        Calendar weekCalendar = Calendar.getInstance();
        Calendar beginWeekCalendar = Calendar.getInstance();
        Calendar endWeekCalendar = Calendar.getInstance();

        metaMgr.setMetaData("xfile.jar");
        ParseSideMenu parseSideMenu = new ParseSideMenu();
        Hashtable logos = new Hashtable();
        logos = parseSideMenu.getCompanyLogo("configration" + metaMgr.getCompanyName() + ".xml");
        String weeksNo = logos.get("weeksNo").toString();

        int dayOfBack = new Integer(weeksNo).intValue() * 7;

        int dayOfWeekValue = weekCalendar.getTime().getDay();
        Calendar beginSecondWeekCalendar = Calendar.getInstance();
        Calendar endSecondWeekCalendar = Calendar.getInstance();
        beginSecondWeekCalendar = (Calendar) weekCalendar.clone();
        endSecondWeekCalendar = (Calendar) weekCalendar.clone();

        beginSecondWeekCalendar.add(beginWeekCalendar.DATE, -dayOfWeekValue - dayOfBack);
        endSecondWeekCalendar.add(endWeekCalendar.DATE, -dayOfWeekValue);

        beginWeekCalendar = (Calendar) weekCalendar.clone();
        endWeekCalendar = (Calendar) weekCalendar.clone();

        beginWeekCalendar.add(beginWeekCalendar.DATE, -dayOfWeekValue);
        endWeekCalendar.add(endWeekCalendar.DATE, 6 - dayOfWeekValue);

        SecurityUser securityUser = (SecurityUser) request.getSession().getAttribute("securityUser");
        Map<String, String> selectedTabMap = securityUser.getSelectedTab();
        String selectedTab = selectedTabMap.get(CRMConstants.SELECTED_TAB_SALES_MARKET_KEY);
        if (selectedTab == null) {
            selectedTab = "1";
            securityUser.getSelectedTab().put(CRMConstants.SELECTED_TAB_SALES_MARKET_KEY, selectedTab);
        }

        //Privileges
        ArrayList<WebBusinessObject> prvType = new ArrayList();
        prvType = securityUser.getComplaintMenuBtn();
        ArrayList<String> privilegesList = new ArrayList<>();
        for (WebBusinessObject wboTemp : prvType) {
            if (wboTemp != null && wboTemp.getAttribute("prevCode") != null) {
                privilegesList.add((String) wboTemp.getAttribute("prevCode"));
            }
        }

        String stat = (String) request.getSession().getAttribute("currentMode");
        ClientComplaintsMgr.getInstance().updateClientComplaintsType();
         
    %>

    <script language="javascript" type="text/javascript">
        function limitText(limitField, limitCount, limitNum) {
            if (limitField.value.length > limitNum) {
                limitField.value = limitField.value.substring(0, limitNum);
            } else {
                limitCount.value = limitNum - limitField.value.length;
            }
        }
    </script>


    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

        $(function() {
            if (document.getElementById("selectedTab").value == "2") {
                showDev2();
            } else if (document.getElementById("selectedTab").value == "3") {
                showDev3();
            } else if (document.getElementById("selectedTab").value == "4") {
                showDev4();
            } else if (document.getElementById("selectedTab").value == "5") {
                showDev5();
            } else if (document.getElementById("selectedTab").value === "6") {
                showDev6();
            } else {
                showDev1();
            }
        });
        
        function showLaterOrders() {
            var beginDate = document.getElementById("beginDate").value;
            var endDate = document.getElementById("endDate").value;
            var projectName = document.getElementById("projectName").value;
            var statusName = 'Schedule';

            window.navigate('<%=context%>/SearchServlet?op=StatusProjectList&beginDate=' + beginDate + '&endDate=' + endDate + '&projectName=' + projectName + '&statusName=' + statusName);
        }
        function checkSize() {
            var x = document.getElementById('notes');
            return x.value.length <= 30;
        }
        function showLaterClosedOrders() {
            var beginDate = document.getElementById("beginDate").value;
            var endDate = document.getElementById("endDate").value;
            var projectName = document.getElementById("projectName").value;
            var statusName = 'Finished';

            window.navigate('<%=context%>/SearchServlet?op=getJobOrdersByLateClosed&beginDate=' + beginDate + '&endDate=' + endDate + '&projectName=' + projectName + '&statusName=' + statusName);
        }

        function showDev1() {
            setSeletedTab("1");
            document.getElementById("con2").style.display = 'none';
//            document.getElementById("con3").style.display = 'none';
            document.getElementById("con4").style.display = 'none';
            document.getElementById("con1").style.display = 'block';
            document.getElementById("div1").style.backgroundImage = 'url(images/activeBtn2.jpg)';
            document.getElementById("div2").style.backgroundImage = 'url(images/buttonbg.jpg)';
//            document.getElementById("div3").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div4").style.backgroundImage = 'url(images/buttonbg.jpg)';
            try {
                document.getElementById("con5").style.display = 'none';
                document.getElementById("div5").style.backgroundImage = 'url(images/buttonbg.jpg)';
            } catch (err) {
            }
            try {
                document.getElementById("con6").style.display = 'none';
                document.getElementById("div6").style.backgroundImage = 'url(images/buttonbg.jpg)';
            } catch (err) {
            }
        }

        function showDev2() {
            setSeletedTab("2");
            document.getElementById("con2").style.display = 'block';
            document.getElementById("con1").style.display = 'none';
//            document.getElementById("con3").style.display = 'none';
            document.getElementById("con4").style.display = 'none';
            document.getElementById("div2").style.backgroundImage = 'url(images/activeBtn2.jpg)';
            document.getElementById("div1").style.backgroundImage = 'url(images/buttonbg.jpg)';
//            document.getElementById("div3").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div4").style.backgroundImage = 'url(images/buttonbg.jpg)';
            try {
                document.getElementById("con5").style.display = 'none';
                document.getElementById("div5").style.backgroundImage = 'url(images/buttonbg.jpg)';
            } catch (err) {
            }
            try {
                document.getElementById("con6").style.display = 'none';
                document.getElementById("div6").style.backgroundImage = 'url(images/buttonbg.jpg)';
            } catch (err) {
            }
        }
        function showDev3() {
            setSeletedTab("3");
//            document.getElementById("con3").style.display = 'block';
            document.getElementById("con1").style.display = 'none';
            document.getElementById("con2").style.display = 'none';
            document.getElementById("con4").style.display = 'none';
//            document.getElementById("div3").style.backgroundImage = 'url(images/activeBtn2.jpg)';
            document.getElementById("div1").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div2").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div4").style.backgroundImage = 'url(images/buttonbg.jpg)';
            try {
                document.getElementById("con5").style.display = 'none';
                document.getElementById("div5").style.backgroundImage = 'url(images/buttonbg.jpg)';
            } catch (err) {
            }
            try {
                document.getElementById("con6").style.display = 'none';
                document.getElementById("div6").style.backgroundImage = 'url(images/buttonbg.jpg)';
            } catch (err) {
            }
        }
        function showDev4() {
            setSeletedTab("4");
            document.getElementById("con4").style.display = 'block';
//            document.getElementById("con3").style.display = 'none';
            document.getElementById("con1").style.display = 'none';
            document.getElementById("con2").style.display = 'none';
            document.getElementById("div4").style.backgroundImage = 'url(images/activeBtn2.jpg)';
//            document.getElementById("div3").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div1").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div2").style.backgroundImage = 'url(images/buttonbg.jpg)';
            try {
                document.getElementById("con5").style.display = 'none';
                document.getElementById("div5").style.backgroundImage = 'url(images/buttonbg.jpg)';
            } catch (err) {
            }
            try {
                document.getElementById("con6").style.display = 'none';
                document.getElementById("div6").style.backgroundImage = 'url(images/buttonbg.jpg)';
            } catch (err) {
            }
        }
        function showDev5() {
            setSeletedTab("5");
            document.getElementById("con5").style.display = 'block';
            document.getElementById("con4").style.display = 'none';
//            document.getElementById("con3").style.display = 'none';
            document.getElementById("con1").style.display = 'none';
            document.getElementById("con2").style.display = 'none';
            document.getElementById("div5").style.backgroundImage = 'url(images/activeBtn2.jpg)';
            document.getElementById("div4").style.backgroundImage = 'url(images/buttonbg.jpg)';
//            document.getElementById("div3").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div1").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div2").style.backgroundImage = 'url(images/buttonbg.jpg)';
            try {
                document.getElementById("con6").style.display = 'none';
                document.getElementById("div6").style.backgroundImage = 'url(images/buttonbg.jpg)';
            } catch (err) {
            }
        }
        function showDev6() {
            setSeletedTab("6");
            document.getElementById("con6").style.display = 'block';
            document.getElementById("con4").style.display = 'none';
            document.getElementById("con1").style.display = 'none';
            document.getElementById("con2").style.display = 'none';
            document.getElementById("div6").style.backgroundImage = 'url(images/activeBtn2.jpg)';
            document.getElementById("div4").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div1").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div2").style.backgroundImage = 'url(images/buttonbg.jpg)';
            try {
                document.getElementById("con5").style.display = 'none';
                document.getElementById("div5").style.backgroundImage = 'url(images/buttonbg.jpg)';
            } catch (err) {
            }
        }

        function setSeletedTab(seletedTab) {
            $.ajax({
                type: "post",
                url: "<%=context%>/ajaxServlet?op=setSeletedTab",
                data: {
                    seletedTab: seletedTab,
                    forPage: '<%=CRMConstants.SELECTED_TAB_SALES_MARKET_KEY%>'
                }
            });
        }

        function printJobOrders() {
            var url = 'PDFReportServlet?op=printWeeklyJobOrders';
            openCustomDialog(url, "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width=850, height=400");

        }
        
        function mark(obj, element) {

            $(element).parent().attr("id", "bookmarkDiv");
            $("#notes").val("");
            $("#businessCompId").val(obj);
            $('#bookmark').bPopup();
            $('#bookmark').css("display", "block");
            $("#insertBookmark").on("click", function() {
                saveBookmark()

            });

        }

        function saveBookmark(element) {
            $(element).parent().attr("id", "bookmarkDiv");
            var compId = $("#businessCompId").val();
            var note = $("#notes").val();
            var title = $("#title").val();
            $.ajax({
                type: "post",
                url: "<%=context%>/IssueServlet?op=saveBookmark",
                data: {compId: compId,
                    note: note,
                    title: title
                },
                success: function(jsonString) {
                    var info = $.parseJSON(jsonString);

                    if (info.status == 'ok') {

                        $('#bookmark').css("display", "none");

                        $("#bookmarkDiv").find("#bookmarkImg").attr("src", "images/icons/bookmark_selected.png");
                        $("#bookmarkDiv").find("#bookmarkImg").removeAttr("onclick");
                        //                         $("#bookmarkDiv").find("#bookmarkImg").attr("onclick","deleteBookmark()");
                        $("#bookmarkDiv").find("#bookmarkImg").attr("onmouseover", "Tip('" + $("#notes").val() + "', CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#FFFF99', FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT, 'BOLD', TITLEALIGN, 'center', TITLEFONTCOLOR, 'black', TITLEBGCOLOR, '#6699FF')");
                        $("#bookmarkDiv").find("#bookmarkImg").attr("onMouseOut", "UnTip()");
                        $("#bookmarkDiv").attr("id", "");
                        $("#notes").val("");


                    }
                }
            });
        }
        function deleteBookmark(obj) {
            var bookmarkId = $(obj).val();
            $.ajax({
                type: "post",
                url: "<%=context%>/IssueServlet?op=deleteBookmark",
                data: {
                    bookmarkId: bookmarkId
                },
                success: function(jsonString) {
                    var info = $.parseJSON(jsonString);

                    if (info.status == 'ok') {
                        $(obj).removeAttr("src");

                        $(obj).attr("onMouseOver", "UnTip()");

                        $(obj).attr("src", "images/icons/bookmark_uns.png");

                    }
                }
            });
        }
        function displayCommentCounts(clientId) {
            $.ajax({
                type: "post",
                url: "<%=context%>/CommentsServlet?op=commentsCountAjax",
                data: {
                    clientId: clientId
                }
                ,
                success: function(jsonString) {
                    var info = $.parseJSON(jsonString);
                    $("#count").val(info.count);
                    divID = "countDiv";
                    $('#overlay').show();
                    $('#countDiv').css("display", "block");
                    $('#countDiv').dialog();
                }
            });
        }
        function changeCommentCounts(clientId, obj) {
            $.ajax({
                type: "post",
                url: "<%=context%>/ClientServlet?op=appointmentsCountAjax",
                data: {
                    clientId: clientId
                }
                ,
                success: function(jsonString) {
                    var info = $.parseJSON(jsonString);
                    $(obj).attr("title", "عدد المتابعات: " + info.count);
                }
            });
        }
        var divID;
        $(function() {
            centerDiv("countDiv");
        });
        function closePopup(formID) {
            $("#" + formID).hide();
            $('#overlay').hide();
        }
        function closeOverlay() {
            $("#" + divID).hide();
            $("#overlay").hide();
        }
        function centerDiv(div) {
            $("#" + div).css("position", "fixed");
            $("#" + div).css("top", Math.max(0, (($(window).height() - $("#" + div).outerHeight()) / 2) +
                    $(window).scrollTop()) + "px");
            $("#" + div).css("left", Math.max(0, (($(window).width() - $("#" + div).outerWidth()) / 2) +
                    $(window).scrollLeft()) + "px");
        }
    </SCRIPT>

    <style>
        .modal {
            display:    none;
            position:   fixed;
            z-index:    1000;
            top:        0;
            left:       0;
            height:     100%;
            width:      100%;
            background: #069
                url('http://i.stack.imgur.com/FhHRx.gif') 
                50% 50% 
                no-repeat;
        }

        /* When the body has the loading class, we turn
           the scrollbar off with overflow:hidden */
        body.loading {
            overflow: hidden;   
        }

        /* Anytime the body has the loading class, our
           modal element will be visible */
        body.loading .modal {
            display: block;
        }
        #tabs li{
            display: inline;
        }
        #tabs li a{

            text-align:center; font:bold 15px;
            display:inline;
            text-decoration:none;
            padding-right:20px;
            padding-left:20px;
            padding-bottom:0;
            margin:0px;
            font-size: 15px;
            background-image:url(images/buttonbg.jpg);       
            background-repeat: repeat-x;
            background-position: bottom;
            color:#069;
            border-top-left-radius: 10px;
            border-top-right-radius: 10px;
        }
        #tabs li a:hover{
            background-color:#FFF;
            color:#069; 
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
        .remove{
            width:20px;
            height:20px;
            margin: 4px;
            background-repeat: no-repeat;
            cursor: pointer;
            background-image:url(images/icons/icon-32-remove.png);
        }
        .smallDialog {
            width: 320px;
            display: none;
            position: fixed;
            /*                top: 80%;
                            left: 35%;*/
            z-index: 1000;
        }
        .mediumDialog {
            width: 370px;
            display: none;
            position: fixed;
            /*                top: 80%;
                            left: 35%;*/
            z-index: 1000;
        }
        .overlayClass {
            width: 100%;
            height: 100%;
            display: none;
            background-color: rgb(0, 85, 153);
            opacity: 0.4;
            z-index: 500;
            top: 0px;
            left: 0px;
            position: fixed;
        }
        .img:hover{
            cursor: pointer ;
        }
    </style>
    <BODY>     
        <div id="overlay" class="overlayClass" onclick="JavaScript: closeOverlay();">

        </div>
        <div id="countDiv" class="smallDialog">
            <div style="clear: both;margin-left: 88%;margin-top: 0px;margin-bottom: -38px;z-index: -10000000;">
                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                     -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                     box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                     -webkit-border-radius: 100px;
                     -moz-border-radius: 100px;
                     border-radius: 100px;" onclick="closePopup('countDiv')"/>
            </div>
            <div class="login" style="width: 85%;margin-bottom: 10px;margin-left: auto;margin-right: auto;">
                <table  border="0px"  style="width:100%;"  class="table">
                    <tr>
                        <td style="width: 40%;"> <label style="width: 100px;">عدد المتابعات</label></TD>
                        <td style="width: 60%;"><input  name="count" id="count" readonly></TD>
                    </tr>
                </table>                        
            </div>
        </div>
        <input type="hidden" id="selectedTab" name="selectedTab" value="<%=selectedTab%>"/>
        <div class="modal"><!-- Place at bottom of page --></div>
        <!--<div style="width: 20%;margin-left: auto;margin-right: auto;text-align: center;color: #005599;font-size: 18">مركز الإتصال والمتابعة</div>-->
        <div >
            <center>

                <div style="border:0px solid gray; width:100%; margin:auto;float: left; padding: 10px;margin-bottom: 0px;" id="tab">
                    <ul id="tabs" class="shadetabs" style="margin-right:21px;margin-bottom: 0px;">
                        <li ><a id="div6"  style="height: 30px;"href="javascript:showDev6();" ><span style="display: inline-block;padding: 2px;"><fmt:message key="myClientComments"/> <img src="images/icons/comments.png" width="22px" height="22px"  onclick="javascript:showDev6();"></span></a></li>
                        <li style="float: left;font-size: 16px;color: #005599;"> General Search - البحث العام </li>  
                        <li ><a id="div4" style="height: 30px;"href="javascript:showDev4();" ><SPAN style="display: inline-block;padding: 2px;"> <fmt:message key="notif"/><IMG src="images/icons/clock_time.png" width="25px" height="25px" onclick="javascript:showDev4();"></SPAN></a></li>
                        <!--li ><a id="div3" style="height: 30px;"href="javascript:showDev3();" ><SPAN style="display: inline-block;padding: 2px;"><!fmt:message key="calls_meetings"/><IMG src="images/icons/Phone-icon.png" width="22px" height="22px" onclick="javascript:showDev3();"></SPAN></a></li-->
                        <%
                            if (privilegesList.contains("DEP_REQUEST")) {
                        %>
                        <li ><a id="div5"  style="height: 30px;"href="javascript:showDev5();" ><SPAN style="display: inline-block;padding: 2px;"><fmt:message key="depreqs"/> <IMG src="images/icons/closedIssue.png" width="22px" height="22px"  onclick="javascript:showDev5();"></SPAN></a></li>
                        <%
                            }
                        %>
                        <li ><a id="div2"  style="height: 30px;"href="javascript:showDev2();" ><SPAN style="display: inline-block;padding: 2px;"><fmt:message key="myorders"/><IMG src="images/icons/closedIssue.png" width="22px" height="22px"  onclick="javascript:showDev2();"></SPAN></a></li>
                        <li class="active"><a id="div1"  style="height: 30px;"href="javascript:showDev1();" ><SPAN style="display: inline-block;padding: 2px;"><fmt:message key="search"/><IMG src="images/icons/search_icon.gif"width="22px" height="22px"onclick="javascript:showDev1();" ></SPAN></a></li>
                    </ul>
                    <div  dir="rtl" id="con1" style="display:block;border:0px solid gray; width:100%; margin: 0px; " >
                        <jsp:include page="/docs/sales/search_for_client.jsp" flush="true"></jsp:include>
                    </div>

                    <div  dir="rtl" id="con2" style="display:none;border:0px solid gray; width:100%; margin: 0px; ">
                        <jsp:include page="/docs/sales/sales_market_closed.jsp" flush="true"></jsp:include>
                    </div>

                    <!--div  dir="rtl" id="con3" style="display:none;border:0px solid gray; width:100%; margin: 0px; ">
                        <!jsp:include page="/docs/sales/sales_market_calls.jsp" flush="true"><!/jsp:include>
                    </div-->
                    <%
                        if (privilegesList.contains("DEP_REQUEST")) {
                    %>
                    <div  dir="rtl" id="con5" style="display:none;border:0px solid gray; width:100%; margin: 0px; ">
                        <jsp:include page="/docs/sales/sales_market_dep.jsp" flush="true"></jsp:include>
                    </div>
                    <%
                        }
                    %>
                    <div  dir="rtl" id="con4" style="display:none;border:0px solid gray; width:100%; margin: 0px; ">
                        <jsp:include page="appointment_notifications.jsp" flush="true"></jsp:include>
                    </div>
                    <div  dir="rtl" id="con6" style="display:none;border:0px solid gray; width:100%; margin: 0px; ">
                        <jsp:include page="my_client_comments.jsp" flush="true"></jsp:include>
                    </div>
                    <br>
                </div>
            </center>
        </div>
        <input type="hidden" id="businessCompId" />
        <input type="hidden" id="divImg" />


    </BODY>
</HTML>