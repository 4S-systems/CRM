<%@page import="com.crm.common.CRMConstants"%>
<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="com.tracker.engine.IssueStatusFactory, com.tracker.engine.*,java.text.*,com.docviewer.db_access.*, com.maintenance.db_access.*,com.maintenance.common.ParseSideMenu"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page contentType="text/HTML; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8"%>


<HTML>
    <meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <meta HTTP-EQUIV="Expires" CONTENT="0">
    <head>
        <title>Weekly Manager Agenda</title>
        <link REL="stylesheet" TYPE="text/css" HREF="css/CSS.css">
        <script type="text/javascript" src="jquery-ui/jquery-1.7.1.js"></script>
        <script type="text/javascript" src="jquery-ui/"></script>
        <script type="text/javascript" src="treemenu/script/contextmenu.js"></script>
        <script type="text/javascript" src="js/common.js"></script>
        
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css"/>
        <link rel="stylesheet" href="css/demo_table.css"/>
        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/icon.css"/>
        <link rel="stylesheet" type="text/css" href="jquery-easyui/demo/demo.css"/>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>
        <script type="text/javascript" src="jquery-easyui/easyloader.js"></script>

        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/default/easyui.css">
    </head>

    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();

        SecurityUser securityUser = (SecurityUser) request.getSession().getAttribute("securityUser");
        Map<String, String> selectedTabMap = securityUser.getSelectedTab();
        String selectedTab = selectedTabMap.get(CRMConstants.SELECTED_TAB_CALL_CENTER_KEY);
        if (selectedTab == null) {
            selectedTab = "1";
            securityUser.getSelectedTab().put(CRMConstants.SELECTED_TAB_CALL_CENTER_KEY, selectedTab);
        }

        ProjectMgr projectMgr = ProjectMgr.getInstance();
        ArrayList<WebBusinessObject> actionsList = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKeyOracle("ACT", "key6"));

        String stat = (String) request.getSession().getAttribute("currentMode");
        String input, closedIssue, callAmeet, depReq, notif;

        if (stat.equals("En")) {
            input = "Search";
            closedIssue = "My Orders";
            callAmeet = "Calls & Meetings";
            depReq = "Department Requirements";
            notif = "Notifications";
            
        } else {
            input = "البحث";
            closedIssue = "طلباتي";
            callAmeet = "المكالمات/المقابلات";
            depReq = "طلبات القسم";
            notif = "اشعارات";
        }
    %>

    <script language="javascript" type="text/javascript">
        $(function () {
            if (document.getElementById("selectedTab").value == "2") {
                showDev2();
            } else if (document.getElementById("selectedTab").value == "3") {
                showDev3();
            } else if (document.getElementById("selectedTab").value == "4") {
                showDev4();
            } else if (document.getElementById("selectedTab").value == "5") {
                showDev5();
            } else {
                showDev1();
            }
        });

        function showDev1() {
            setSeletedTab("1");
            document.getElementById("con1").style.display = 'block';
            document.getElementById("con2").style.display = 'none';
            document.getElementById("con3").style.display = 'none';
            //document.getElementById("con4").style.display = 'none';
            document.getElementById("con5").style.display = 'none';

            document.getElementById("div1").style.backgroundImage = 'url(images/activeBtn2.jpg)';
            document.getElementById("div2").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div3").style.backgroundImage = 'url(images/buttonbg.jpg)';
            //document.getElementById("div4").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div5").style.backgroundImage = 'url(images/buttonbg.jpg)';
        }

        function showDev2() {
            setSeletedTab("2");
            document.getElementById("con2").style.display = 'block';
            document.getElementById("con1").style.display = 'none';
            document.getElementById("con3").style.display = 'none';
            //document.getElementById("con4").style.display = 'none';
            document.getElementById("con5").style.display = 'none';

            document.getElementById("div2").style.backgroundImage = 'url(images/activeBtn2.jpg)';
            document.getElementById("div1").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div3").style.backgroundImage = 'url(images/buttonbg.jpg)';
            //document.getElementById("div4").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div5").style.backgroundImage = 'url(images/buttonbg.jpg)';
        }

        function showDev3() {
            setSeletedTab("3");
            document.getElementById("con3").style.display = 'block';
            document.getElementById("con1").style.display = 'none';
            document.getElementById("con2").style.display = 'none';
            //document.getElementById("con4").style.display = 'none';
            document.getElementById("con5").style.display = 'none';

            document.getElementById("div3").style.backgroundImage = 'url(images/activeBtn2.jpg)';
            document.getElementById("div1").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div2").style.backgroundImage = 'url(images/buttonbg.jpg)';
            //document.getElementById("div4").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div5").style.backgroundImage = 'url(images/buttonbg.jpg)';
        }

        function showDev4() {
            setSeletedTab("4");
            //document.getElementById("con4").style.display = 'block';
            document.getElementById("con1").style.display = 'none';
            document.getElementById("con2").style.display = 'none';
            document.getElementById("con3").style.display = 'none';
            document.getElementById("con5").style.display = 'none';

            //document.getElementById("div4").style.backgroundImage = 'url(images/activeBtn2.jpg)';
            document.getElementById("div1").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div2").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div3").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div5").style.backgroundImage = 'url(images/buttonbg.jpg)';
        }

        function showDev5() {
            setSeletedTab("5");
            document.getElementById("con5").style.display = 'block';
            document.getElementById("con1").style.display = 'none';
            document.getElementById("con2").style.display = 'none';
            document.getElementById("con3").style.display = 'none';
            //document.getElementById("con4").style.display = 'none';

            document.getElementById("div5").style.backgroundImage = 'url(images/activeBtn2.jpg)';
            document.getElementById("div1").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div2").style.backgroundImage = 'url(images/buttonbg.jpg)';
            document.getElementById("div3").style.backgroundImage = 'url(images/buttonbg.jpg)';
            //document.getElementById("div4").style.backgroundImage = 'url(images/buttonbg.jpg)';
        }

        function setSeletedTab(seletedTab) {
            $.ajax({
                type: "post",
                url: "<%=context%>/ajaxServlet?op=setSeletedTab",
                data: {
                    seletedTab: seletedTab,
                    forPage: '<%=CRMConstants.SELECTED_TAB_CALL_CENTER_KEY%>'
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
                success: function (jsonString) {
                    var info = $.parseJSON(jsonString);
                    $("#count").val(info.count);
                    divID = "countDiv";
                    $('#overlay').show();
                    $('#countDiv').css("display", "block");
                    $('#countDiv').dialog();
                }
            });
        }
        function getPhoneAndOtherMobile(obj) {
            var mobile = $(obj).parent().find("#mobile").val();
            var phone = $(obj).parent().find("#phone").val();
            var other = $(obj).parent().find("#other").val();
            $("#clientPhoneDiv").find("#mobile").val(mobile);
            $("#clientPhoneDiv").find("#phone").val(phone);
            $("#clientPhoneDiv").find("#other").val(other);
            $('#clientPhoneDiv').css("display", "block");
            $('#clientPhoneDiv').bPopup();
        }
        function changeCommentCounts(clientId, obj) {
            $.ajax({
                type: "post",
                url: "<%=context%>/ClientServlet?op=appointmentsCountAjax",
                data: {
                    clientId: clientId
                }
                ,
                success: function (jsonString) {
                    var info = $.parseJSON(jsonString);
                    $(obj).attr("title", "عدد المتابعات: " + info.count);
                }
            });
        }
        var divID;
        $(function () {
            centerDiv("countDiv");
        });
        $(function () {
            centerDiv("clientPhoneDiv");
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

        function showAction(id)
        {
            $("#actionCode").val("");
            $("#alertID").val(id);
            $("#actionNote").val("");
            $('#add_action').css("display", "block");
            $('#add_action').bPopup({easing: 'easeInOutSine', speed: 400, transition: 'slideDown'});
        }
        function closePopup(obj) {
            $(obj).parent().parent().bPopup().close();
        }
        function saveAction() {
            changeStatus('39', 'action', $("#alertID").val(), $("#actionNote").val(), $("#actionCode").val());
        }

        function viewAction(id) {
            $.ajax({
                type: "post",
                url: "<%=context%>/IssueServlet?op=getActionByAjax",
                data: {
                    id: id
                }
                ,
                success: function (jsonString) {
                    var info = $.parseJSON(jsonString);
                    $("#actionNameDisplay").html(info.actionName);
                    $("#actionNoteDisplay").html(info.option2);
                    $('#view_action').css("display", "block");
                    $('#view_action').bPopup({easing: 'easeInOutSine', speed: 400, transition: 'slideDown'});
                }
            });
        }
        
    </script>

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

        <div id="add_action"  style="width: 30% ;margin-right: auto ;margin-left: auto;display: none;position: fixed"><!--class="popup_appointment" -->
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
                    <tr>
                        <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 30%;">الفعل</td>
                        <td style="width: 70%;" >
                            <select style="float: right;width: 230px; font-size: 14px;" id="actionCode">
                                <sw:WBOOptionList wboList="<%=actionsList%>" displayAttribute="projectName" valueAttribute="projectID"/>
                            </select>
                            <input type="hidden" id="alertID" />
                        </td>
                    </tr>
                    <tr>
                        <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 30%;">التعليق</td>
                        <td style="width: 70%;" >
                            <textarea  placeholder="" style="width: 100%;height: 80px;" id="actionNote" >
                            </textarea>
                        </td>
                    </tr> 
                </table>
                <div style="text-align: center;margin-left: auto;margin-right: auto;" > <input type="button" value="حفظ"   onclick="saveAction()" id="saveAction"class="login-submit"/>
                </div>                           
            </div>
        </div>

        <div id="view_action"  style="width: 30% ;margin-right: auto ;margin-left: auto;display: none;position: fixed"><!--class="popup_appointment" -->
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
                    <tr>
                        <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 30%;">الفعل</td>
                        <td style="width: 70%;" id="actionNameDisplay">

                        </td>
                    </tr>
                    <tr>
                        <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 30%;">التعليق</td>
                        <td style="width: 70%;" id="actionNoteDisplay">
                        </td>
                    </tr> 
                </table>
            </div>
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

        <div id="clientPhoneDiv" class="easyui-window" data-options="modal:true,closed:true" title="تليفونات العملاء" style="width:500px;height:auto;padding:10px;text-align: right;background-color: #1D4D87; display: none; z-index: 10000;">
            <div style="">
                <table class="table" style="width:100%;border: none;margin-right: auto;margin-left: auto" dir="rtl" id="data">
                    <tr>
                        <td style="width: 40%;"> <label style="width: 100px; color: wheat;">التليفون</label></TD>
                        <td style="width: 60%;"><input  name="phone" id="phone"readonly/></TD>
                    </TR>
                    <tr>
                        <td style="width: 40%;"> <label style="width: 100px; color: wheat;">المحمول</label></TD>
                        <td style="width: 60%;"> <input name="mobile" id="mobile" readonly/></TD>
                    </TR>
                    <tr>
                        <td style="width: 40%;"> <label style="width: 100px; color: wheat;">رقم الطالب-اخر</label></TD>
                        <td style="width: 60%;"><input name="other" id="other" readonly/></TD>
                    </TR>
                </table>
            </div>
        </div>

        <input type="hidden" id="selectedTab" name="selectedTab" value="<%=selectedTab%>"/>
        <div>
            <center>
                <div style="border:0px solid gray; width:100%; margin:auto;float: left; padding: 10px;margin-bottom: 0px;" id="tab">
                    <ul id="tabs" class="shadetabs" style="margin-right:10px;margin-bottom: 0px;">
                        <li style="float: left;font-size: 16px;color: #005599;">Customer Service - مركز خدمة العملاء</li>
                        <!--li ><a id="div5" style="height: 30px;"href="javascript:showDev5();" ><SPAN style="display: inline-block;padding: 2px;">كل الإشعارات <IMG src="images/icons/closedIssue.png" width="22px" height="22px"  onclick="javascript:showDev5();"></SPAN></a></li-->   
                        <%--<li ><a id="div4" style="height: 30px;"href="javascript:showDev4();" ><SPAN style="display: inline-block;padding: 2px;"><%=callAmeet%><IMG src="images/icons/Phone-icon.png" width="22px" height="22px" onclick="javascript:showDev4();"></SPAN></a></li>--%>
                        <li ><a id="div3" style="height: 30px;"href="javascript:showDev3();" ><SPAN style="display: inline-block;padding: 2px;"><%=depReq%><IMG src="images/icons/closedIssue.png" width="22px" height="22px" onclick="javascript:showDev3();"></SPAN></a></li>
                        <li ><a id="div5" style="height: 30px;"href="javascript:showDev5();" ><SPAN style="display: inline-block;padding: 2px;"> <%=notif%><IMG src="images/icons/clock_time.png" width="25px" height="25px" onclick="javascript:showDev5();"></SPAN></a></li>
                        <li ><a id="div2" style="height: 30px;"href="javascript:showDev2();" ><SPAN style="display: inline-block;padding: 2px;"><%=closedIssue%><IMG src="images/icons/closedIssue.png" width="22px" height="22px"  onclick="javascript:showDev2();"></SPAN></a></li>
                        <li class="active"><a id="div1"  style="height: 30px;"href="javascript:showDev1();" ><SPAN style="display: inline-block;padding: 2px;"><%=input%><IMG src="images/icons/search_icon.gif"width="22px" height="22px"onclick="javascript:showDev1();" ></SPAN></a></li>
                    </ul>
                </div>

                    <div  dir="rtl" id="con1" style="display:block;border:0px solid gray; width:100%; margin: 0px; " >
                    <%--<jsp:include page="/docs/Search/search_for_client.jsp" flush="true"></jsp:include>--%>
                    <jsp:include page="/docs/sales/search_for_client.jsp" flush="true"></jsp:include>
                    </div>
                

                    <div  dir="rtl" id="con2" style="display:none;border:0px solid gray; width:100%; margin: 0px; ">
                    <%--<jsp:include page="call_center_closed.jsp" flush="true"></jsp:include>--%>
                    <jsp:include page="/docs/sales/sales_market_closed.jsp" flush="true"></jsp:include>
                    </div>

                    <div  dir="rtl" id="con3" style="display:none;border:0px solid gray; width:100%; margin: 0px; ">
                    <jsp:include page="call_center_dep.jsp" flush="true"></jsp:include>
                    </div>

                    <%--<div  dir="rtl" id="con4" style="display:none;border:0px solid gray; width:100%; margin: 0px; ">
                    <jsp:include page="call_center_calls.jsp" flush="true"></jsp:include>
                    </div>--%>
                    
                    <div  dir="rtl" id="con5" style="display:none;border:0px solid gray; width:100%; margin: 0px; ">
                        <jsp:include page="appointment_notifications.jsp" flush="true"></jsp:include>
                    </div>

                    <!--div  dir="rtl" id="con5" style="display:none;border:0px solid gray; width:100%; margin: 0px; ">
                    <!jsp:include page="notifications.jsp" flush="true"><!/jsp:include>
                </div-->
        </div>
    </center>
</DIV>
</BODY>
</HTML>