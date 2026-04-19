<%@page import="com.maintenance.db_access.GroupPrevMgr"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<%@page pageEncoding="UTF-8" %>

<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    <HEAD>
        <%

            MetaDataMgr metaMgr = MetaDataMgr.getInstance();
            String context = metaMgr.getContext();

            AppConstants appCons = new AppConstants();

            String[] userAttributes = appCons.getUserAttributes();
            String[] userListTitles = appCons.getUserHeaders();

            int s = userAttributes.length;
            int t = s + 5;
            int iTotal = 0;

            String attName = null;
            String attValue = null;
            String cellBgColor = null;
            String viewUserLabel = null;

            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

            Vector usersList = (Vector) request.getAttribute("data");
            long numberOfUsers = (Long) request.getAttribute("numberOfUsers");
            ArrayList<WebBusinessObject> trades = (ArrayList<WebBusinessObject>) request.getAttribute("trades");
            String userStatus = (String) request.getAttribute("userStatus");
            String updtMgr = request.getAttribute("updtMgr") != null ? (String) request.getAttribute("updtMgr") : "";

            WebBusinessObject wbo = null;
            int flipper = 0;
            String bgColor = null;
            String bgColorm = null;
            SecurityUser securityUser = (SecurityUser) session.getAttribute("securityUser");
            //boolean isSuperUser = securityUser.isSuperUser();
            boolean isSuperUser = true;
            TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
            String stat = (String) request.getSession().getAttribute("currentMode");
            String align = null;
            String dir = null;
            String style = null;
            String lang, langCode, sUsersList;
            String beginDate, saveData, areaName, search, dateMsg, areaMsg, roleMsg, successMsg, faildMsg, role, active, inactive, all, userStatusStr, changeManager, maxUserExceedMsg,
                    entryDate;
            if (stat.equals("En")) {

                align = "center";
                dir = "LTR";
                style = "text-align:left";
                lang = "   &#1593;&#1585;&#1576;&#1610;    ";
                langCode = "Ar";
                userListTitles[0] = "User Name";
                userListTitles[1] = "Full Name";
                //userListTitles[1]="Password";
                userListTitles[2] = "View";
                userListTitles[3] = "Edit";
                userListTitles[4] = "Delete";
                userListTitles[5] = "Area";
                userListTitles[6] = "Transfer";
                userListTitles[7] = "Status";
                changeManager = "Change the Manager";
                sUsersList = isSuperUser ? "Users List" : "Work Load Balance";
                viewUserLabel = "Basic Info.";
                saveData = "Save";
                beginDate = "Begin Date";
                areaName = "Area";
                search = "Search";
                dateMsg = "Please insert begin date";
                areaMsg = "Please select area";
                roleMsg = "Please select role";
                successMsg = "Saved Successfully";
                faildMsg = "Faild to save";
                role = "Role";
                active = "Active";
                inactive = "Inactive";
                all = "All";
                userStatusStr = "User Status";
                maxUserExceedMsg = "Cannot activate user, maximum allowed number of users to be active is ";
                entryDate = "Entry Date";
            } else {

                align = "center";
                dir = "RTL";
                style = "text-align:Right";
                lang = "English";
                langCode = "En";
                userListTitles[0] = "&#1575;&#1587;&#1605; &#1575;&#1604;&#1605;&#1587;&#1578;&#1582;&#1583;&#1605;";
                // userListTitles[1]="&#1603;&#1604;&#1605;&#1577; &#1575;&#1604;&#1605;&#1585;&#1608;&#1585;";
                userListTitles[1] = "الاسم";
                userListTitles[2] = "&#1605;&#1588;&#1575;&#1607;&#1583;&#1607;";
                userListTitles[3] = "&#1578;&#1581;&#1585;&#1610;&#1585;";
                userListTitles[4] = "&#1581;&#1584;&#1601;";
                userListTitles[5] = "\u0645\u0646\u0637\u0642\u0629";
                userListTitles[6] = "نقل اﻷعمال";
                userListTitles[7] = "&#1575;&#1604;&#1581;&#1575;&#1604;&#1577;";
                changeManager = "تغيير المدير";
                sUsersList = isSuperUser ? "عرض المستخدمين" : "نقل الأعمال";

                viewUserLabel = "&#1575;&#1604;&#1576;&#1610;&#1575;&#1606;&#1575;&#1578; &#1575;&#1604;&#1571;&#1587;&#1575;&#1587;&#1610;&#1577;.";
                saveData = "\u062d\u0641\u0638";
                beginDate = "\u0645\u0646 \u062a\u0627\u0631\u064a\u062e";
                areaName = "\u0627\u0644\u0645\u0646\u0637\u0642\u0629";
                search = "\u0628\u062d\u062b";
                dateMsg = "\u064a\u062c\u0628 \u0623\u062f\u062e\u0627\u0644 \u0627\u0644\u062a\u0627\u0631\u064a\u062e";
                areaMsg = "\u064a\u062c\u0628 \u0623\u062f\u062e\u0627\u0644 \u0627\u0644\u0645\u0646\u0637\u0642\u0629";
                roleMsg = "\u064a\u062c\u0628 \u0623\u062f\u062e\u0627\u0644 \u0627\u0644\u0648\u0638\u064a\u0641\u0629";
                successMsg = "\u062a\u0645 \u0627\u0644\u062a\u0633\u062c\u064a\u0644 \u0628\u0646\u062c\u0627\u062d";
                faildMsg = "\u0644\u0645 \u064a\u062a\u0645 \u0627\u0644\u062a\u0633\u062d\u064a\u0644";
                role = "\u0627\u0644\u0648\u0638\u064a\u0641\u0629";
                active = "Active";
                inactive = "Inactive";
                all = "الكل";
                userStatusStr = "حالة المستخدم";
                maxUserExceedMsg = "لا يمكن تغيير حالة المستخدم, أقصي عدد للمستخدمين النشطين هو ";
                entryDate = "تاريخ الدخول";
            }

            WebBusinessObject userWbo = (WebBusinessObject) request.getSession().getAttribute("loggedUser");

            GroupPrevMgr groupPrevMgr = GroupPrevMgr.getInstance();
            Vector groupPrev = groupPrev = groupPrevMgr.getOnArbitraryKey(userWbo.getAttribute("groupID").toString(), "key1");

            ArrayList<String> userPrevList = new ArrayList<String>();
            WebBusinessObject wboPrev;
            for (int i = 0; i < groupPrev.size(); i++) {
                wboPrev = (WebBusinessObject) groupPrev.get(i);
                userPrevList.add((String) wboPrev.getAttribute("prevCode"));
            }
        %>
        <TITLE>System Users List</TITLE>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css">
        <link rel="stylesheet" href="css/demo_table.css">
        <script type="text/javascript" src="jquery-ui/jquery-1.6.2.js"></script>

        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>
        <style>
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
            .mediumDialog {
                width: 370px;
                display: none;
                position: fixed;
                z-index: 1100;
                top: 150px;
                left: 500px;
            }
        </style>
    </HEAD>
    <script type="text/javascript">

        function exportToExcel() {
            var url = "<%=context%>/ListerServlet?op=exportUsersToExcel";
            window.open(url, "_blank", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width=700, height=700");
        }


        var oTable;
        var users = new Array();
        $(document).ready(function () {

            //                if ($("#tblData").attr("class") == "blueBorder") {
            //                    $("#tblData").bPopup();
            //                }

            //            $("#clients").css("display", "none");
            oTable = $('#users').dataTable({
                bJQueryUI: true,
                sPaginationType: "full_numbers",
                "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                iDisplayLength: 25,
                iDisplayStart: 0,
                "bPaginate": true,
                "bProcessing": true

            }).fadeIn(2000);

        });
        $(function () {
            $(".beginDateClass").datepicker({
                maxDate: "+d",
                changeMonth: true,
                changeYear: true,
                dateFormat: 'yy-mm-dd'
            });
        });
        function showUserArea(userID)
        {
            $("#userID").val(userID);
            getUserArea();
//            $('#user_area').css("display", "block");
            $('#user_area').bPopup({easing: 'easeInOutSine', //uses jQuery easing plugin
                speed: 400,
                transition: 'slideDown'});
        }
        function closePopup(obj) {
            $(obj).parent().parent().bPopup().close();
            $(obj).parent().parent().css("display", "none");

        }
        function saveUserArea() {
            var userID = $("#userID").val();
            var beginDate = $("#beginDate").val();
            var areaID = $("#region").val();
            var roleID = $("#roleID").val();
            if (validateUserArea()) {
                $.ajax({
                    type: "post",
                    url: "<%=context%>/ProjectServlet?op=saveUserAreaByAjax",
                    data: {
                        userID: userID,
                        beginDate: beginDate,
                        roleID: roleID,
                        areaID: areaID
                    }
                    ,
                    success: function (jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.status == 'Ok') {
                            alert("<%=successMsg%>");
                            $("#user_area").bPopup().close();
                            $("#user_area").css("display", "none");
                            $("#beginDate").val("");
                            $("#region").val("");
                            $("#regionName").val("");
                            $("#roleID").val("");
                        } else if (info.status == 'faild') {
                            alert("<%=faildMsg%>");
                        }
                    }
                });
            }
        }
        function validateUserArea() {
            if (!validateData("req", document.getElementById("beginDate"), "<%=dateMsg%>")) {
                document.getElementById("beginDate").focus();
                return false;
            }
            else if (!validateData("req", document.getElementById("region"), "<%=areaMsg%>")) {
                document.getElementById("region").focus();
                return false;
            }
            else if (!validateData("req", document.getElementById("roleID"), "<%=roleMsg%>")) {
                document.getElementById("roleID").focus();
                return false;
            }
            return true;
        }
        function getUserArea() {
            var userID = $("#userID").val();
            $.ajax({
                type: "post",
                url: "<%=context%>/ProjectServlet?op=getUserAreaByAjax",
                data: {
                    userID: userID
                }
                ,
                success: function (jsonString) {
                    var info = $.parseJSON(jsonString);
                    if (info.status == 'Ok') {
                        $("#beginDate").val(info.beginDateString);
                        $("#region").val(info.areaId);
                        $("#regionName").val(info.areaName);
                        $("#roleID").val(info.roleId);
                        var maxDate = $("#beginDate").val();
                        $('#beginDate').datepicker('option', 'minDate', new Date(maxDate));
                    }
                }
            });
        }
        function changeUserStatus(userID, newStatus) {
            $.ajax({
                type: "post",
                url: "<%=context%>/UsersServlet?op=changeUserStatusByAjax",
                data: {
                    userID: userID,
                    newStatus: newStatus
                }
                ,
                success: function (jsonString) {
                    var info = $.parseJSON(jsonString);
                    if (info.status == 'Ok') {
                        alert("<%=successMsg%>");
                        if (newStatus == '21') {
                            $("#active" + userID).show();
                            $("#activeBtn" + userID).hide();
                            $("#inactive" + userID).hide();
                            $("#inactiveBtn" + userID).show();
                        } else {
                            $("#active" + userID).hide();
                            $("#activeBtn" + userID).show();
                            $("#inactive" + userID).show();
                            $("#inactiveBtn" + userID).hide();
                        }
                    } else if (info.status == 'faild') {
                        alert("<%=faildMsg%>");
                    } else if (info.status === 'maxUserExceed') {
                        alert("<%=maxUserExceedMsg%>" + " " + info.maxUsersNum);
                    }
                }
            });
        }
        function submitForm() {
            document.USER_LIST_FROM.submit();
        }
        function showManagerPopup(userID) {
            var url = "<%=context%>/EmployeeServlet?op=changeManager&userID=" + userID + "&page=newmanager";
            jQuery('#manager_dialog').load(url);
            $('#manager_dialog').css("display", "block");
            $('#manager_dialog').bPopup();
        }

        function getExternal() {
            document.USER_LIST_FROM.action = "<%=context%>/ReportsServletThree?op=exportReport&reportType=PDF&reportName=report1";
            document.USER_LIST_FROM.submit();
        }
    </script>

    <body>
        <div id="overlay" class="overlayClass" onclick="JavaScript: closeOverlay();">

        </div>
        <div id="manager_dialog" class="mediumDialog"></div>
        <div id="user_area" style="width: 30%;display: none;position: fixed;margin-left: auto;margin-right: auto">
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
                        <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 30%;" nowrap>
                            <%=beginDate%>
                        </td>
                        <td style="width: 70%; text-align: right;" colspan="2">
                            <input type="TEXT" style="width:100px" name="beginDate" ID="beginDate" class="beginDateClass" size="20" value="" maxlength="100" readonly="true"/>
                            <input type="HIDDEN" name="userID" ID="userID" value=""/>
                        </td>
                    </tr>
                    <tr>
                        <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 30%;" nowrap>
                            <%=areaName%>
                        </td>
                        <td style="width: 70%; text-align: right;">
                            <input type="text" readonly id="regionName" name="regionName" value="" >
                            <input type="hidden" id="region" name="region" value="" >
                        </td>
                        <td style="width: 70%; text-align: right;">
                            <input type="button" onclick="window.open('<%=context%>/EquipmentServlet?op=getAllRegions', '_blank', 'status=1,scrollbars=1,width=400')"  value="<%=search%>">
                        </td>
                    </tr>
                    <tr>
                        <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 30%;" nowrap>
                            <%=role%>
                        </td>
                        <td style="width: 70%; text-align: right;" colspan="2">
                            <select id="roleID" name="roleID" style="width: 170px; font-size: medium;">
                                <option value="">Select</option>
                                <sw:WBOOptionList wboList="<%=trades%>" displayAttribute="tradeName" valueAttribute="tradeId"/>
                            </select>  
                        </td>
                    </tr>
                </table>
                <div style="text-align: center;margin-left: auto;margin-right: auto;" > <input type="button" value="<%=saveData%>" onclick="saveUserArea()" id="editToDate" class="login-submit"/>
                </div>                           
            </div>
        </div>

        <fieldset align=center class="set">
            <legend align="center">



                <TABLE dir=" <%=dir%>" align="<%=align%>">
                    <tr>

                        <td class="td">
                            <font color="blue" size="6"><%=sUsersList%> 
                            </font>
                        </td>
                    </tr>
                </TABLE>
            </legend >
            <%
                if (isSuperUser) {
            %>
            <form name="USER_LIST_FROM" method="post">
                <table align="center" dir="rtl" id="code" width="20%" style="border-width:1px;border-color:white;margin-top: 5px; margin-right: auto; margin-left: auto;" >
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;">
                            <b>
                                <font size=3 color="white"><%=userStatusStr%></font>
                            </b>
                        </td>
                    </tr>
                    <tr>
                        <td  bgcolor="#dedede" valign="middle">
                            <select style="width:190px" id="userStatus" name="userStatus" onchange="JavaScript: submitForm();">
                                <option value="all" <%="all".equals(userStatus) ? "selected" : ""%>><%=all%></option>
                                <option value="active" <%="active".equals(userStatus) ? "selected" : ""%>><%=active%></option>
                                <option value="inactive" <%="inactive".equals(userStatus) ? "selected" : ""%>><%=inactive%></option>
                            </select>
                        </td>
                    </tr>
                </table>
            </form>
            <button type="button" style="color: #27272A;font-size:15px;margin: 9px;font-weight:bold; display: <%=userPrevList.contains("EXCEL") ? "" : "none"%>;" onclick="exportToExcel()">Excel<img height="15" src="images/search.gif">
            </button>
            <button onclick="JavaScript: getExternal();" style="color: #27272A;font-size:15px;margin: 9px;font-weight:bold; display: <%=userPrevList.contains("EXCEL") ? "" : "none"%>;" name="reportType" value="PDF"> 
                <img style="height:25px;" src="images/icons/printer.png" title="PDF"/>
            </button>
            <input type="hidden" name="reportName" value="report1"/> <!--PATH FOLDER NAME/REPORT NAME-->
            <%
                }
            %>
            <div style="width: 60%;margin-left: auto;margin-right: auto;">
                <TABLE ALIGN="<%=align%>" dir="<%=dir%>" style="width: 100%;" id="users">
                    <thead>
                        <TR >
                            <%
                                String columnColor = new String("");
                                String columnWidth = new String("100");
                                String font = new String("12");
                                for (int i = 0; i < t; i++) {
                                    if (i == 0) {
                                        columnColor = "#9B9B00";
                                    } else {
                                        columnColor = "#7EBB00";
                                    }
                            %>
                            <% if (i == 1 || i == 6 || (isSuperUser && i != 3)) {%>  
                            <Th>
                                <B><%=userListTitles[i]%></B>
                            </Th>
                            <%}%>
                            <%
                                }
                            %>
                            <th>
                                <B> <%=changeManager%> </B>
                            </th>
                            <th>
                                <b> <%=entryDate%> </b>
                            </th>
                            <%
                                if (isSuperUser) {
                            %>
                            <Th>
                                &nbsp;
                            </Th>
                            <%
                                }
                            %>
                        </TR>
                    </thead>
                    <tbody>
                        <%

                            Enumeration e = usersList.elements();


                            while (e.hasMoreElements()) {
                                iTotal++;
                                wbo = (WebBusinessObject) e.nextElement();
                                flipper++;
                                if ((flipper % 2) == 1) {
                                    bgColor = "silver_odd";
                                    bgColorm = "silver_odd_main";
                                } else {
                                    bgColor = "silver_even";
                                    bgColorm = "silver_even_main";
                                }
                        %>

                        <TR>
                            <%
                                for (int i = 0; i < s; i++) {
                                    attName = userAttributes[i];
                                    if ((isSuperUser && !attName.equals("password")) || attName.equals("fullName")) {
                                        attValue = (String) wbo.getAttribute(attName);
                                        System.out.println("att = " + attValue);
                            %>

                            <TD>
                                <DIV >

                                    <b> <%=attValue%> </b>
                                </DIV>
                            </TD>
                            <%
                                    }
                                }
                                String statusCode = (String) wbo.getAttribute("statusCode");
                                String userId = (String) wbo.getAttribute("userId");
                                if (isSuperUser) {
                            %>

                            <TD >
                                <DIV ID="links">
                                    <A HREF="<%=context%>/UsersServlet?op=ViewUser&userId=<%=wbo.getAttribute("userId")%>&index=<%=wbo.getAttribute("index")%>&numberOfUsers=<%=numberOfUsers%>&statusCode=<%=statusCode%>">
                                        <%=userListTitles[2]%>
                                    </A> 
                                </DIV>
                            </TD>

                            <!--TD>
                                <DIV ID="links">
                                    <A HREF="<%=context%>/UsersServlet?op=GetUpdateForm&userId=<%=wbo.getAttribute("userId")%>&index=<%=wbo.getAttribute("index")%>&numberOfUsers=<%=numberOfUsers%>">
                            <%=userListTitles[3]%>
                        </A>
                    </DIV>
                </TD-->
                            <TD >
                                <DIV ID="links">
                                    <% if (attValue.equalsIgnoreCase("admin")) {%>
                                    ****
                                    <% } else {%>
                                    <% if (metaMgr.getCandelete().equals("1")) {%>
                                    <A HREF="<%=context%>/UsersServlet?op=ConfirmDelete&userId=<%=wbo.getAttribute("userId")%>&userName=<%=wbo.getAttribute("userName")%>">
                                        <%=userListTitles[4]%>
                                    </A>
                                    <% } else {%>
                                    ****
                                    <% }
                                        }%>
                                </DIV>
                            </TD>
                            <TD >
                                <DIV ID="links">
                                    <% if (attValue.equalsIgnoreCase("admin")) {%>
                                    ****
                                    <% } else {%>
                                    <A HREF="JavaScript: showUserArea('<%=wbo.getAttribute("userId")%>');">
                                        <%=userListTitles[5]%>
                                    </A>
                                    <% }%>
                                </DIV>
                            </TD>
                            <%
                                }
                            %>
                            <TD >
                                <DIV ID="links">
                                    <% if (attValue.equalsIgnoreCase("admin")) {%>
                                    ****
                                    <% } else {%>
                                    <A HREF="<%=context%>/UsersServlet?op=moveSelectedComplaints&userId=<%=wbo.getAttribute("userId")%>&userName=<%=wbo.getAttribute("userName")%>">
                                        <%=userListTitles[6]%>
                                    </A>
                                    <% }%>
                                </DIV>
                            </TD>
                            <%
                                if (isSuperUser) {
                            %>
                            <TD >
                                <DIV ID="links">
                                    <b id="active<%=userId%>" style="color: green; display: <%=statusCode != null && statusCode.equals("21") ? "" : "none"%>"><%=active%></b>
                                    <b id="inactive<%=userId%>" style="color: red; display: <%=statusCode != null && statusCode.equals("21") ? "none" : ""%>"><%=inactive%></b>
                                </DIV>
                            </TD>
                            <%
                                }
                            %>

                            <td>
                                <%
                                    if ("1".equals(wbo.getAttribute("userType"))) {
                                %>
                                ---
                                <%
                                } else {
                                %>
                                <a onclick="JavaScript: showManagerPopup('<%=wbo.getAttribute("userId")%>');">
                                    <%=changeManager%> 
                                </a>
                                <%
                                    }
                                %>
                            </td>
                            <td nowrap>
                                <%=((String) wbo.getAttribute("CREATION_TIME")).substring(0, 10)%>
                            </td>

                            <%
                                if (isSuperUser) {
                            %>
                            <TD >
                                <DIV ID="links">
                                    <input type="button" id="inactiveBtn<%=userId%>" style="display: <%=statusCode != null && statusCode.equals("21") ? "" : "none"%>" value="<%=inactive%>"
                                           onclick="JavaScript: changeUserStatus('<%=userId%>', '22')"/>
                                    <input type="button" id="activeBtn<%=userId%>" style="display: <%=statusCode != null && statusCode.equals("21") ? "none" : ""%>" value="<%=active%>"
                                           onclick="JavaScript: changeUserStatus('<%=userId%>', '21')"/>
                                </DIV>
                            </TD>
                            <%
                                }
                            %>
                        </TR>


                        <%
                            }

                        %>
                    </tbody>
                </TABLE>
            </div>
            <br/><br/>


        </fieldset>

    </body>
</html>
