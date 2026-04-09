<%@page import="com.maintenance.common.AutomationConfigurationMgr"%>
<%@page import="com.crm.common.CRMConstants"%>
<%@page import="com.crm.db_access.AlertMgr"%>
<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="com.tracker.engine.IssueStatusFactory, com.tracker.engine.*,java.text.*,com.docviewer.db_access.*, com.maintenance.db_access.*,com.maintenance.common.ParseSideMenu"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<HTML>
    <meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <meta HTTP-EQUIV="Expires" CONTENT="0">
    <head>
        <title>Weekly Manager Agenda</title>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>
        <script type="text/javascript" src="jquery-easyui/easyloader.js"></script>
        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/default/easyui.css"/>
        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/icon.css"/>
        <link rel="stylesheet" type="text/css" href="jquery-easyui/demo/demo.css"/>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css"/>
        <link rel="stylesheet" href="css/demo_table.css"/>
    </head>
 <c:set var="loc" value="en"/>
    <c:if test="${!(empty sessionScope.currentMode)}">
      <c:set var="loc" value="${sessionScope.currentMode}"/>
    </c:if>
<fmt:setLocale value="${loc}"  />
<fmt:setBundle basename="Languages.employee_agenda.employee_agenda"  />

    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        AutomationConfigurationMgr automation = AutomationConfigurationMgr.getCurrentInstance();
        long interval = automation.getDefaultRefreshPageInterval();
        response.setHeader("Cache-Control", "no-cache");
        response.setHeader("Cache-Control", "no-store");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        SecurityUser securityUser = (SecurityUser) request.getSession().getAttribute("securityUser");
        Map<String, String> selectedTabMap = securityUser.getSelectedTab();
        String selectedTab = selectedTabMap.get(CRMConstants.SELECTED_TAB_EMPLOYEE_AGENDA_KEY);
        if (selectedTab == null) {
            selectedTab = "1";
            securityUser.getSelectedTab().put(CRMConstants.SELECTED_TAB_EMPLOYEE_AGENDA_KEY, selectedTab);
        }

        AlertMgr alertMgr = AlertMgr.getInstance();
        WebBusinessObject loggedUser = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
        String count = alertMgr.getUnReadCommentsAlertCount((String) loggedUser.getAttribute("userId"));
    %>

    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
        $(function() {
            /*if (document.getElementById("selectedTab").value == "2") {
                showDev2();
            } else */if (document.getElementById("selectedTab").value == "3") {
                showDev3();
            } else if (document.getElementById("selectedTab").value == "4") {
                showDev4();
            } else if (document.getElementById("selectedTab").value == "5") {
                showDev5();
            } else if (document.getElementById("selectedTab").value === "6") {
                showDev6();
            } else if (document.getElementById("selectedTab").value === "7") {
                showDev7();
            } else {
                showDev1();
            }
        });
            
        $(function() {
            var url = "<%=context%>/LocalTimer?op=refreshEmpPage&cach=" + (new Date()).getTime();
            jQuery('#con1').load(url);
            setInterval(
                    function() {
                        var url = "<%=context%>/LocalTimer?op=refreshEmpPage&cach=" + (new Date()).getTime();
                        jQuery('#con1').load(url);
                    }, <%=interval%>); // refresh every 10000 milliseconds
        });

        function showDev1() {
            setSeletedTab("1");
//            document.getElementById("con2").style.display = 'none';
            document.getElementById("con3").style.display = 'none';
            document.getElementById("con4").style.display = 'none';
            document.getElementById("con5").style.display = 'none';
            document.getElementById("con6").style.display = 'none';
            document.getElementById("con7").style.display = 'none';
            document.getElementById("con1").style.display = 'block';
            document.getElementById("div1").style.backgroundImage = 'url(images/activeBtn2.jpg)';
//            document.getElementById("div2").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div3").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div4").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div5").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div6").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div7").style.backgroundImage = 'url(images/buttonbg.jpg)';
        }

//        function showDev2() {
//            setSeletedTab("2");
//            document.getElementById("con2").style.display = 'block';
//            document.getElementById("con1").style.display = 'none';
//            document.getElementById("con3").style.display = 'none';
//            document.getElementById("con4").style.display = 'none';
//            document.getElementById("con5").style.display = 'none';
//            document.getElementById("con6").style.display = 'none';
//            document.getElementById("con7").style.display = 'none';
//            document.getElementById("div2").style.backgroundImage = 'url(images/activeBtn2.jpg)';
//            document.getElementById("div1").style.backgroundImage = 'url(images/buttonbg.jpg)';
//            document.getElementById("div3").style.backgroundImage = 'url(images/buttonbg.jpg)';
//            document.getElementById("div4").style.backgroundImage = 'url(images/buttonbg.jpg)';
//            document.getElementById("div5").style.backgroundImage = 'url(images/buttonbg.jpg)';
//            document.getElementById("div6").style.backgroundImage = 'url(images/buttonbg.jpg)';
//            document.getElementById("div7").style.backgroundImage = 'url(images/buttonbg.jpg)';
//        }

        function showDev3() {
            setSeletedTab("3");
            document.getElementById("con3").style.display = 'block';
            document.getElementById("con4").style.display = 'none';
            document.getElementById("con5").style.display = 'none';
            document.getElementById("con6").style.display = 'none';
            document.getElementById("con7").style.display = 'none';
//            document.getElementById("con2").style.display = 'none';
            document.getElementById("con1").style.display = 'none';
            document.getElementById("div3").style.backgroundImage = 'url(images/activeBtn2.jpg)';
            document.getElementById("div4").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div5").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div6").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div7").style.backgroundImage = 'url(images/buttonbg.jpg)';
//            document.getElementById("div2").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div1").style.backgroundImage = 'url(images/buttonbg.jpg)';
        }

        function showDev4() {
            setSeletedTab("4");
            document.getElementById("con4").style.display = 'block';
            document.getElementById("con5").style.display = 'none';
            document.getElementById("con6").style.display = 'none';
            document.getElementById("con7").style.display = 'none';
            document.getElementById("con3").style.display = 'none';
//            document.getElementById("con2").style.display = 'none';
            document.getElementById("con1").style.display = 'none';
            document.getElementById("div5").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div6").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div7").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div4").style.backgroundImage = 'url(images/activeBtn2.jpg)';
            document.getElementById("div3").style.backgroundImage = 'url(images/buttonbg.jpg)';
//            document.getElementById("div2").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div1").style.backgroundImage = 'url(images/buttonbg.jpg)';
        }
        
        function showDev5() {
            setSeletedTab("5");
            document.getElementById("con5").style.display = 'block';
            document.getElementById("con6").style.display = 'none';
            document.getElementById("con7").style.display = 'none';
            document.getElementById("con4").style.display = 'none';
            document.getElementById("con3").style.display = 'none';
//            document.getElementById("con2").style.display = 'none';
            document.getElementById("con1").style.display = 'none';
            document.getElementById("div5").style.backgroundImage = 'url(images/activeBtn2.jpg)';
            document.getElementById("div6").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div7").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div4").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div3").style.backgroundImage = 'url(images/buttonbg.jpg)';
//            document.getElementById("div2").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div1").style.backgroundImage = 'url(images/buttonbg.jpg)';
        }
        
        function showDev6() {
            setSeletedTab("6");
            document.getElementById("con6").style.display = 'block';
            document.getElementById("con7").style.display = 'none';
            document.getElementById("con5").style.display = 'none';
            document.getElementById("con4").style.display = 'none';
            document.getElementById("con3").style.display = 'none';
//            document.getElementById("con2").style.display = 'none';
            document.getElementById("con1").style.display = 'none';
            document.getElementById("div6").style.backgroundImage = 'url(images/activeBtn2.jpg)';
            document.getElementById("div7").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div5").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div4").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div3").style.backgroundImage = 'url(images/buttonbg.jpg)';
//            document.getElementById("div2").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div1").style.backgroundImage = 'url(images/buttonbg.jpg)';
        }
        
        function showDev7() {
            setSeletedTab("7");
            document.getElementById("con7").style.display = 'block';
            document.getElementById("con6").style.display = 'none';
            document.getElementById("con5").style.display = 'none';
            document.getElementById("con4").style.display = 'none';
            document.getElementById("con3").style.display = 'none';
//            document.getElementById("con2").style.display = 'none';
            document.getElementById("con1").style.display = 'none';
            document.getElementById("div7").style.backgroundImage = 'url(images/activeBtn2.jpg)';
            document.getElementById("div6").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div5").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div4").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div3").style.backgroundImage = 'url(images/buttonbg.jpg)';
//            document.getElementById("div2").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div1").style.backgroundImage = 'url(images/buttonbg.jpg)';
        }

        function setSeletedTab(seletedTab) {
            $.ajax({
                type: "post",
                url: "<%=context%>/ajaxServlet?op=setSeletedTab",
                data: {
                    seletedTab: seletedTab,
                    forPage: '<%=CRMConstants.SELECTED_TAB_EMPLOYEE_AGENDA_KEY%>'
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
        function viewRequest(issueId, clientComplaintId) {
            var url = '<%=context%>/IssueServlet?op=requestComments&issueId=' + issueId + '&clientComplaintId=' + clientComplaintId + '&showPopup=true';
            var wind = window.open(url, "", "toolbar=no,height=" + screen.height + ",width=" + screen.width + ", location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no,navigationbar=no");
            wind.focus();
        }

        function saveBookmark(clientId, obj) {
            var note = "UL";
            var title = "UL";
            $.ajax({
                type: "post",
                url: "<%=context%>/IssueServlet?op=saveBookmark",
                data: {
                    compId: clientId,
                    note: note,
                    title: title,
                    type: "CLIENT"
                },
                success: function(jsonString) {
                    var info = $.parseJSON(jsonString);
                    if (info.status == 'ok') {
                        $("#unbookmarkImg" + clientId).removeAttr("onclick");
                        $("#unbookmarkImg" + clientId).click(function() {
                            deleteBookmark(clientId, this);
                        });
                        $('#unbookmarkImg' + clientId).css("display", "block");
                        $('#bookmarkImg' + clientId).css("display", "none");
                    }
                }
            });
        }
        function deleteBookmark(clientId, obj) {
            var bookmarkId = $(obj).val();
            $.ajax({
                type: "post",
                url: "<%=context%>/IssueServlet?op=deleteBookmark",
                data: {
                    clientId: clientId
                },
                success: function(jsonString) {
                    var info = $.parseJSON(jsonString);

                    if (info.status == 'ok') {
                        $("#bookmarkImg" + clientId).removeAttr("onclick");
                        $("#bookmarkImg" + clientId).click(function() {
                            deleteBookmark(clientId, this);
                        });
                        $('#bookmarkImg' + clientId).css("display", "block");
                        $('#unbookmarkImg' + clientId).css("display", "none");
                    }
                }
            });
        }
        function popupExecutionPeriod(clientComplaintID, clientName) {
            $.ajax({
                type: "post",
                url: "<%=context%>/IssueServlet?op=getExecutionPeriodAjax",
                data: {
                    clientComplaintID: clientComplaintID
                }
                ,
                success: function(jsonString) {
                    var info = $.parseJSON(jsonString);
                    $("#executionPeriod").val(info.executionPeriod);
                }
            });
            $("#clientComplaintID").val(clientComplaintID);
            $("#clientNameTD").html(clientName);
            $("#executionPeriod").val("");
            $("#executionMsg").hide();
            $('#execution_period').css("display", "block");
            $('#execution_period').bPopup({easing: 'easeInOutSine',
                speed: 400,
                transition: 'slideDown'});
            $('.b-modal').css("display", "block");
        }
        function saveExecutionPeriod(obj) {
            var clientComplaintID = $("#clientComplaintID").val();
            var executionPeriod = $("#executionPeriod").val();
            $(obj).parent().parent().parent().parent().find("#progress").show();
            $.ajax({
                type: "post",
                url: "<%=context%>/IssueServlet?op=updateExecutionPeriod",
                data: {
                    clientComplaintID: clientComplaintID,
                    executionPeriod: executionPeriod
                }
                ,
                success: function(jsonString) {
                    var eqpEmpInfo = $.parseJSON(jsonString);
                    if (eqpEmpInfo.status == 'ok') {
                        $("#executionMsg").show();
                        $(obj).parent().parent().parent().parent().find("#progress").hide();
                        $('#execution_period').css("display", "none");
                        $('.b-modal').css("display", "none");
                    } else if (eqpEmpInfo.status == 'no') {
                        $(obj).parent().parent().parent().parent().find("#progress").show();
                    }
                }
            });
        }
        function closePopupExecutionPeriod() {
            $('#execution_period').css("display", "none");
            $('.b-modal').css("display", "none");
        }
        function printClientInformation(clientID) {
            var url = "<%=context%>/PDFReportServlet?op=clientDataSheet&clientId=" + clientID + "&objectType=client";
            window.open(url, "_blank", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=no, copyhistory=no, width=700, height=600");
        }
        function openInNewWindow(url) {
            var win = window.open(url, '_blank');
            win.focus();
        }
    </SCRIPT>
    <style>
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
        .popup_{ 

            border: none;

            direction:rtl;
            padding:0px;
            margin-top: 10px;
            border: 1px solid tomato;
            background-color: #f1f1f1;
            margin-bottom: 5px;
            width: 30%;

            /*position:absolute;*/

            font:Verdana, Geneva, sans-serif;
            font-size:18px;
            font-weight:bold;
            display: none;
        }
        .popup_conten{ 

            border: none;

            direction:rtl;
            padding:0px;
            margin-top: 10px;
            border: 1px solid tomato;
            background-color: #f1f1f1;
            margin-bottom: 5px;
            width: 30%;

            /*position:absolute;*/

            font:Verdana, Geneva, sans-serif;
            font-size:18px;
            font-weight:bold;
            display: none;
        }
        
        .urgent{
            background-image: url(images/redBgt.png);
        }
    </style>
    <BODY>
        <div id="execution_period"  style="width: 30% ;margin-right: auto ;margin-left: auto;display: none;position: fixed;top: 0%;"><!--class="popup_appointment" -->
            <div style="clear: both;margin-left: 88%;margin-bottom: -38px;z-index: -10000000;">
                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                     -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                     box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                     -webkit-border-radius: 100px;
                     -moz-border-radius: 100px;
                     border-radius: 100px;" onclick="closePopupExecutionPeriod()"/>
            </div>
            <div class="login" style="width: 85%;margin-bottom: 10px;margin-left: auto;margin-right: auto;">
                <table  border="0px"  style="width:100%;"  class="table"> 
                    <tr>
                        <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 25%;" nowrap>اسم العميل</td>
                        <td style="width: 65%;" id="clientNameTD" colspan="2">
                            
                        </td>
                    </tr> 
                    <tr>
                        <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 25%;" nowrap>مدة التنفيذ</td>
                        <td style="width: 65%;" >
                            <input type="number" placeholder="Number" style="width: 100%;" id="executionPeriod" name="executionPeriod"/>
                            <input type="hidden" name="clientComplaintID" id="clientComplaintID"/>
                        </td>
                        <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 10%;">يوم</td>
                    </tr>
                </table>
                <div style="text-align: center;margin-left: auto;margin-right: auto;clear: both" > 
                    <input type="button" value="حفظ" onclick="saveExecutionPeriod(this)" id="saveExecution"class="login-submit"/></div>                             </form>
                <div id="progress" style="display: none;">
                    <img src="images/Loading2.gif" width="32px" height="32px;" style="background-repeat: no-repeat;margin-left: auto;margin-right: auto"/>
                </div>
                <div style="margin: 0 auto;display: none; width: 90%;text-align: center;color: white;font-size: 16px;font-weight: bold" id="executionMsg">
                    تم التسجيل
                </div>
            </div>  
        </div>
            <input type="hidden" id="selectedTab" name="selectedTab" value="<%=selectedTab%>"/>
        <div >
            <center>
                <div style="border:0px solid gray; width:100%; margin:auto; padding: 10px;margin-bottom: 0px;">
                    <ul id="tabs" class="shadetabs" style="text-align:right; margin-right:21px;margin-bottom: 0px;">
                        <li ><a id="div4"  style="height: 35px;"href="javascript:showDev4();" ><SPAN style="display: inline-block;padding: 2px;"><fmt:message key="search"/><IMG src="images/icons/search_icon.gif"width="22px" height="22px"onclick="javascript:showDev4();" ></SPAN></a></li>
<%--                        <li style="<%=Integer.parseInt(count) > 0 ? "" : "display: none;"%>" ><a id="div7" class="urgent" style="height: 35px;"href="javascript:showDev7();" ><SPAN style="display: inline-block; padding: 2px; color: red;"> <fmt:message key="activeComments"/> <IMG src="images/icons/manager1.png" width="40px" height="35px" style=""> &nbsp; <label class="login" style="width: 25px; height: 20px; margin: 0px; padding: 0px; background: #FF5733; float: right;"> <%=count%> </label> </SPAN></a></li>
                        <li ><a id="div6" style="height: 35px;"href="javascript:showDev6();" ><SPAN style="display: inline-block; padding: 2px;"> <fmt:message key="supervisorComments"/></SPAN></a></li>
                        <li ><a id="div5" style="height: 35px;"href="javascript:showDev5();" ><SPAN style="display: inline-block;padding: 2px;"><fmt:message key="notification"/><IMG src="images/icons/clock_time.png" width="25px" height="25px" onclick="javascript:showDev5();"></SPAN></a></li>
                        <li><a id="div3" style="height: 35px;"href="javascript:showDev3();" ><SPAN style="display: inline-block;padding: 2px;"><fmt:message key="finished"/><IMG src="images/icons/finish.png" width="28px" height="28px" onclick="javascript:showDev3();"></SPAN></a></li>
                        --%><li><a id="div1"  style="height: 35px;"href="javascript:showDev1();" ><SPAN style="display: inline-block;padding: 2px;"><fmt:message key="input"/><IMG src="images/icons/in.png"width="22px" height="22px"onclick="javascript:showDev1();" ></SPAN></a></li>
                    </ul>
                        <div dir=<fmt:message key="direction"/> id="con1" style="display:block;border:0px solid gray; width:96%; margin: 0px;">
                        <jsp:include page="employee_agenda_details.jsp" flush="true"></jsp:include>
                    </div>
                    <div dir=<fmt:message key="direction"/> id="con3" style="display:none;border:0px solid gray; width:96%;margin: 0px;">
                        <jsp:include page="employee_agenda_details_outbox.jsp" flush="true"></jsp:include>
                    </div>
                    <div  dir=<fmt:message key="direction"/> id="con5" style="display:none;border:0px solid gray; width:100%; margin: 0px; ">
                        <jsp:include page="appointment_notifications.jsp" flush="true"></jsp:include>
                    </div>
                    <div  dir="rtl" id="con4" style="display:block;border:0px solid gray; width:100%; margin: 0px; " >
                        <%--<jsp:include page="/docs/sales/search_my_clients.jsp" flush="true"></jsp:include>--%>
                        <jsp:include page="/docs/sales/search_my_clients2.jsp" flush="true"></jsp:include>
                    </div>
                    <div  dir=<fmt:message key="direction"/> id="con6" style="display:none;border:0px solid gray; width:100%; margin: 0px; ">
                        <jsp:include page="comments_notifications.jsp" flush="true"></jsp:include>
                    </div>
                    <div  dir=<fmt:message key="direction"/> id="con7" style="display:none;border:0px solid gray; width:100%; margin: 0px; ">
                        <jsp:include page="active_comments.jsp" flush="true"></jsp:include>
                    </div>
                    <br>
                    <br>
                    <br>
                </div>
            </center>
        </div>
        <script language="JavaScript" type="text/javascript">
            $(document).ready(function(){
                $(".fromToDate").datepicker({
                    maxDate: "+d",
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: 'yy/mm/dd'
                });
            });
        </script>
    </BODY>
</HTML>