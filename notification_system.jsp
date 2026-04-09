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
        <script type="text/javascript" src="jquery-ui/jquery-1.7.1.js"></script>
        <script type="text/javascript" language="javascript" src="jquery-ui/jquery-ui.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>
        <script type="text/javascript" src="jquery-easyui/easyloader.js"></script>
        
        <link rel="stylesheet" type="text/css" href="js/jquery/api/jquery-ui.css" />
        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/default/easyui.css"/>
        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/icon.css"/>
        <link rel="stylesheet" type="text/css" href="jquery-easyui/demo/demo.css"/>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css"/>
        <link rel="stylesheet" href="css/demo_table.css"/>
    </head>

    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();

        String stat = (String) request.getSession().getAttribute("currentMode");
        String myOrders, notification;
        
        SecurityUser securityUser = (SecurityUser) request.getSession().getAttribute("securityUser");
        Map<String, String> selectedTabMap = securityUser.getSelectedTab();
        String selectedTab = selectedTabMap.get(CRMConstants.SELECTED_TAB_NOTIFICATION_SYSTEM_KEY);
        if (selectedTab == null) {
            selectedTab = "2";
            securityUser.getSelectedTab().put(CRMConstants.SELECTED_TAB_NOTIFICATION_SYSTEM_KEY, selectedTab);
        }
        
        ProjectMgr projectMgr = ProjectMgr.getInstance();
        ArrayList<WebBusinessObject> actionsList = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKeyOracle("ACT", "key6"));

        if (stat.equals("En")) {
            myOrders = "My Orders";
            notification = "Notification";

        } else {
            myOrders = "طلباتى";
            notification = "أشعارات";
        }
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
            if (document.getElementById("selectedTab").value == "1") {
                showDev1();
            } else {
                showDev2();
            }
        });
        $(function() {
            document.getElementById("div1").style.backgroundImage = 'url(images/activeBtn2.jpg)';
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
            document.getElementById("con1").style.display = 'block';
            document.getElementById("con2").style.display = 'none';
            document.getElementById("div1").style.backgroundImage = 'url(images/activeBtn2.jpg)';
            document.getElementById("div2").style.backgroundImage = 'url(images/buttonbg.jpg)';

        }

        function showDev2() {
            setSeletedTab("2");
            document.getElementById("con2").style.display = 'block';
            document.getElementById("con1").style.display = 'none';
            document.getElementById("div2").style.backgroundImage = 'url(images/activeBtn2.jpg)';
            document.getElementById("div1").style.backgroundImage = 'url(images/buttonbg.jpg)';

        }
        
        function setSeletedTab(seletedTab) {
            $.ajax({
                type: "post",
                url: "<%=context%>/ajaxServlet?op=setSeletedTab",
                data: {
                    seletedTab: seletedTab,
                    forPage: '<%=CRMConstants.SELECTED_TAB_NOTIFICATION_SYSTEM_KEY%>'
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

        function showAction(id)
        {
            $("#actionCode").val("");
            $("#alertID").val(id);
            $("#actionNote").val("");
            $('#add_action').css("display", "block");
            $('#add_action').bPopup();
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
                success: function(jsonString) {
                    var info = $.parseJSON(jsonString);
                    $("#actionNameDisplay").html(info.actionName);
                    $("#actionNoteDisplay").html(info.option2);
                    $('#view_action').css("display", "block");
                    $('#view_action').bPopup();
                }
            });
        }
        
        function viewSlaHistory(id) {
            var url = "<%=context%>/NotificationServlet?op=displaySLAHistory&id=" + id;
            jQuery('#viewSlaHistory').load(url);
            $('#viewSlaHistory').css("display", "block");
            $('#viewSlaHistory').bPopup();
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
            z-index: 100000000;

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
    </style>
    <BODY>
        <input type="hidden" id="selectedTab" name="selectedTab" value="<%=selectedTab%>"/>
    <center>
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
        <div id="viewSlaHistory" style="width: 50%; margin-right: auto; margin-left: auto; display: none; position: fixed"></div>
        <div style="border:0px solid gray; width:100%; margin:auto;float: left; padding: 10px;margin-bottom: 0px;" id="tab">
            <ul id="tabs" class="shadetabs" style="margin-right:21px;margin-bottom: 0px;">
                <li style="float: left;font-size: 16px;color: #005599; font-style: oblique"> <b>Notification System</b></li>
                <li ><a id="div2"  style="height: 30px;"href="javascript:showDev2();" ><SPAN style="display: inline-block;padding: 2px;"><%=notification%><IMG src="images/icons/closedIssue.png" width="22px" height="22px"  onclick="javascript:showDev2();"></SPAN></a></li>
                <li class="active"><a id="div1"  style="height: 30px;"href="javascript:showDev1();" ><SPAN style="display: inline-block;padding: 2px;"><%=myOrders%><IMG src="images/icons/Phone-icon.png"width="22px" height="22px"onclick="javascript:showDev1();" ></SPAN></a></li>
            </ul>
            <div  dir="rtl" id="con1" style="display:block;border:0px solid gray; width:100%; margin: 0px; " >
                <jsp:include page="/docs/notification_system/my_orders.jsp" flush="true"></jsp:include>
            </div>

            <div  dir="rtl" id="con2" style="display:none;border:0px solid gray; width:100%; margin: 0px; ">
                <jsp:include page="/docs/notification_system/notifications.jsp" flush="true"></jsp:include>
            </div>
            <br>
        </div>
    </center>
<input type="hidden" id="businessCompId" />
<input type="hidden" id="divImg" />


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