<%@page import="com.tracker.db_access.ProjectMgr"%>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,com.silkworm.db_access.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();

    WebBusinessObject user = (WebBusinessObject) request.getAttribute("user");
    WebBusinessObject managerWbo = (WebBusinessObject) request.getAttribute("managerWbo");
    Vector<WebBusinessObject> groups = (Vector<WebBusinessObject>) request.getAttribute("groups");
    Vector<WebBusinessObject> grants = (Vector<WebBusinessObject>) request.getAttribute("grants");
    Vector<WebBusinessObject> stores = (Vector<WebBusinessObject>) request.getAttribute("stores");
    Vector<WebBusinessObject> projects = (Vector<WebBusinessObject>) request.getAttribute("projects");
    
    String isDefaultGroup = (String) request.getAttribute("isDefaultGroup");
    String statusCode = (String) request.getAttribute("statusCode");
    String isDefaultProject = (String) request.getAttribute("isDefaultProject");

    String userId = (String) user.getAttribute("userId");
    String numberOfUsers = (String) request.getAttribute("numberOfUsers");

    String stat = (String) request.getSession().getAttribute("currentMode");
    String storeName = "storeName" + stat;

    String dir = null;
    String style = null;
    String sTitle, sUserName;
    String stStore, isNotSelec;
    String divAlign, basicData, name, sPassword, sEmail, sGroup, sTrade, sites;
    String isDefault, sManagerName;
    String sFullName, isSuperUser, userType, sMgr, sEmp, sipID, active, inactive,
            successMsg,faildMsg, changeManager, noManager, setManager;
    if (stat.equals("En")) {
        dir = "LTR";
        divAlign = "left";
        style = "text-align:left";
        sUserName = "User Name";
        sTitle = "View Existing User";
        sPassword = "Password";
        sEmail = "Email Address";
        sGroup = "Groups";
        sTrade = "Trade";
        sites = "Branches";
        isDefault = "Is Default";
        sManagerName = "Manager";
        basicData = "Basic Data";
        name = "&#1575;&#1604;&#1571;&#1587;&#1605;";
        stStore = "Stores";
        isNotSelec = "Is not Selection yet";
        sFullName = "Full Name";
        isSuperUser = "Is Super User";
        userType = "User type";
        sMgr = "Manager";
        sEmp = "Employee";
        sipID = "SIP ID";
        active = "Active";
        inactive = "Inactive";
        successMsg = "Saved Successfully";
        faildMsg = "Faild to save";
        changeManager = "Change Manager";
        noManager = "No Manager";
        setManager = "Set Manager";
    } else {
        dir = "RTL";
        divAlign = "right";
        style = "text-align:Right";
        sUserName = "&#1575;&#1587;&#1605; &#1575;&#1604;&#1605;&#1587;&#1578;&#1582;&#1583;&#1605;";
        sTitle = "&#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1575;&#1604;&#1605;&#1587;&#1578;&#1582;&#1583;&#1605;";
        sPassword = "&#1603;&#1604;&#1605;&#1577; &#1575;&#1604;&#1605;&#1585;&#1608;&#1585;";
        sEmail = "&#1575;&#1604;&#1576;&#1585;&#1610;&#1583; &#1575;&#1604;&#1573;&#1604;&#1603;&#1578;&#1585;&#1608;&#1606;&#1610;";
        sTrade = "&#1575;&#1604;&#1573;&#1583;&#1575;&#1585;&#1577; &#1575;&#1604;&#1601;&#1606;&#1610;&#1577;";
        sites = "&#1575;&#1604;&#1601;&#1585;&#1608;&#1593;";
        isDefault = "&#1573;&#1601;&#1578;&#1585;&#1575;&#1590;&#1609;";
        sManagerName = "المدير";
        basicData = "&#1575;&#1604;&#1576;&#1610;&#1575;&#1606;&#1575;&#1578; &#1575;&#1604;&#1571;&#1587;&#1575;&#1587;&#1610;&#1577;";
        sGroup = "&#1575;&#1604;&#1605;&#1580;&#1605;&#1608;&#1593;&#1575;&#1578;";
        name = "&#1575;&#1604;&#1571;&#1587;&#1605;";
        stStore = "&#1575;&#1604;&#1605;&#1582;&#1575;&#1586;&#1606;";
        isNotSelec = "&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1578;&#1581;&#1583;&#1610;&#1583; &#1576;&#1593;&#1583;";
        sFullName = "الاسم بالكامل";
        isSuperUser = "&#1587;&#1604;&#1591;&#1575;&#1578; &#1605;&#1591;&#1600;&#1600;&#1600;&#1600;&#1604;&#1602;&#1577;";
        userType = "نوع المستخدم";
        sMgr = "مدير";
        sEmp = "موظف";
        sipID = "SIP ID";
        active = "Active";
        inactive = "Inactive";
        successMsg = "\u062a\u0645 \u0627\u0644\u062a\u0633\u062c\u064a\u0644 \u0628\u0646\u062c\u0627\u062d";
        faildMsg = "\u0644\u0645 \u064a\u062a\u0645 \u0627\u0644\u062a\u0633\u062d\u064a\u0644";
        changeManager = "تغيير المدير";
        noManager = "لا يوجد مدير";
        setManager = "تعيين المدير";
    }
%>

<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Document Viewer - add new user</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <script src='ChangeLang.js' type='text/javascript'></script>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css">
        <link rel="stylesheet" href="css/demo_table.css">
        <script type="text/javascript" src="jquery-ui/jquery-1.6.2.js"></script>

        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
    </HEAD>

    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

        function cancelForm() {
            document.USERS_FORM.action = "<%=context%>/ListerServlet?op=ListUsers";
            document.USERS_FORM.submit();
        }

        function directTo(directType, index) {
            document.USERS_FORM.action = "<%=context%>/UsersServlet?op=directTo&userId=<%=userId%>&index=" + index + "&numberOfUsers=<%=numberOfUsers%>&directType=" + directType;
            document.USERS_FORM.submit();
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
                success: function(jsonString) {
                    var info = $.parseJSON(jsonString);
                    if (info.status == 'Ok') {
                        alert("<%=successMsg%>");
                        if(newStatus == '21') {
                            $("#activeBtn" + userID).hide();
                            $("#inactiveBtn" + userID).show();
                        } else {
                            $("#activeBtn" + userID).show();
                            $("#inactiveBtn" + userID).hide();
                        }
                    } else if (info.status == 'faild') {
                        alert("<%=faildMsg%>");
                    }
                }
            });
        }
        
        function showManagerPopup(userID) {
            var url = "<%=context%>/EmployeeServlet?op=changeManager&userID=" + userID+"&page=newmanager";
            jQuery('#manager_dialog').load(url);
            $('#manager_dialog').css("display", "block");
            $('#manager_dialog').bPopup();
        }
        
        function closePopup(obj){
            $(obj).parent().parent().bPopup().close();
            $(obj).parent().parent().css("display", "none");
            
        }

    </SCRIPT>
    <style>
        .titlebar {
            background-image: url(images/title_bar.png);
            background-position-x: 50%;
            background-position-y: 50%;
            background-size: initial;
            background-repeat-x: repeat;
            background-repeat-y: no-repeat;
            background-attachment: initial;
            background-origin: initial;
            background-clip: initial;
            background-color: rgb(204, 204, 204);
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
    <BODY>
        <FORM action=""  NAME="USERS_FORM" METHOD="POST">

            <br>
            <center>
                <fieldset class="set" style="width:90%;border-color: #006699;">
                    <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                        <tr>
                            <td width="10%" class="titlebar">
                                <DIV ID="links">
                                    <input type="button" id="inactiveBtn<%=userId%>" style="display: <%=statusCode != null && statusCode.equals("21") ? "" : "none"%>" value="<%=inactive%>"
                                           onclick="JavaScript: changeUserStatus('<%=userId%>', '22')"/>
                                    <input type="button" id="activeBtn<%=userId%>" style="display: <%=statusCode != null && statusCode.equals("21") ? "none" : ""%>" value="<%=active%>"
                                           onclick="JavaScript: changeUserStatus('<%=userId%>', '21')"/>
                                </DIV>
                            </td>
                            <td width="90%" class="titlebar">
                                <font color="#005599" size="4"><%=sTitle%>&ensp;:&ensp;</font><font color="#005599" size="4"><%=user.getAttribute("userName")%></font>
                            </td>
                            
                        </tr>
                    </table>
                    <br>
                    <div align="<%=divAlign%>" style="margin-<%=divAlign%>: 15%;color: blue">
                        <p dir="<%=dir%>" align="divAlign" style="background-color: #E6E6FA;width:20%;font-weight: bold;font-size: 16px;padding-top: 2px;padding-bottom: 2px;padding-left: 5px;padding-right: 5px"><b><%=basicData%></b></p>
                    </div>
                    <TABLE class="backgroundTable" width="70%" CELLPADDING="0" CELLSPACING="8" ALIGN="CENTER" DIR="<%=dir%>">
                        <TR>
                            <TD class="backgroundHeader" style="<%=style%>" width="35%">
                                <p><b style="margin-left: 5px;margin-left: 5px;font-weight: bold"><%=sFullName%></b></p>
                            </TD>
                            <%
                                if (user.getAttribute("fullName") != null) {

                            %>
                            <TD style="border-width: 0px" width="65%">
                                <input type="TEXT" name="fullName" ID="fullName" readonly size="33" value="<%=user.getAttribute("fullName")%>" maxlength="255" style="width:100%;color: black; font-weight: bold; font-size: 12px">
                            </TD>
                            <%
                            } else {
                            %>
                            <TD style="border-width: 0px" width="65%">
                                <input type="TEXT" name="fullName" ID="fullName" readonly size="33" value="" maxlength="255" style="width:100%;color: black; font-weight: bold; font-size: 12px">
                            </TD>
                            <%                                }
                            %>
                        </TR>

                        <TR>
                            <TD class="backgroundHeader" style="<%=style%>" width="35%">
                                <p><b style="margin-left: 5px;margin-left: 5px;font-weight: bold"><%=sUserName%></b></p>
                            </TD>
                            <TD style="border-width: 0px" width="65%">
                                <input type="TEXT" name="userName" ID="userName" readonly size="33" value="<%=user.getAttribute("userName")%>" maxlength="255" style="width:100%;color: black; font-weight: bold; font-size: 12px">
                            </TD>
                        </TR>

                        <TR>
                            <TD class="backgroundHeader" style="<%=style%>" width="35%">
                                <p><b style="margin-left: 5px;margin-left: 5px;font-weight: bold"><%=sPassword%></b></p>
                            </TD>
                            <TD style="border-width: 0px" width="65%">
                                <input type="password" name="password" ID="password" readonly size="35" value="<%=user.getAttribute("password")%>" maxlength="255" style="width:100%;color: black; font-weight: bold; font-size: 12px">
                            </TD>
                        </TR>

                        <TR>
                            <TD class="backgroundHeader" style="<%=style%>" width="35%">
                                <p><b style="margin-left: 5px;margin-left: 5px;font-weight: bold"><%=sEmail%></b>
                            </TD>
                            <TD style="border-width: 0px" width="65%">
                                <input type="TEXT" name="email" ID="email" size="33" <% if (user.getAttribute("email") != null && !user.getAttribute("email").equals("")) {%> value="<%=user.getAttribute("email")%>" <% }%> maxlength="255" style="width:100%;color: black; font-weight: bold; font-size: 12px">
                            </TD>
                        </TR>
                        <%
                            if ("0".equals(user.getAttribute("userType"))) {
                        %>
                        <TR>
                            <TD class="backgroundHeader" style="<%=style%>" width="35%">
                                <p><b style="margin-left: 5px;margin-left: 5px;font-weight: bold"><%=sManagerName%></b>
                            </TD>
                            <TD style="border-width: 0px" width="65%">
                                <input type="TEXT" readonly="true" name="managerName" ID="managerName" size="33" value="<%=managerWbo != null && managerWbo.getAttribute("fullName") != null ? managerWbo.getAttribute("fullName") : noManager%>" maxlength="255" style="width:50%;color: black; font-weight: bold; font-size: 12px; float:right;">
                                <a onclick="JavaScript: showManagerPopup('<%=userId%>');">
                                    <%=managerWbo != null && managerWbo.getAttribute("fullName") != null ? changeManager : setManager%> 
                                </a>
                            </TD>
                        </TR>
                        <%
                            }
                        %>
                        <TR>
                            <TD class="backgroundHeader" style="<%=style%>" width="35%">
                                <p><b style="margin-left: 5px;margin-left: 5px;font-weight: bold"><%=sipID%></b>
                            </TD>
                            <TD style="border-width: 0px" width="65%">
                                <input type="TEXT" name="SIPID" ID="SIPID" size="33" value="<%=user.getAttribute("canSendEmail") != null ? user.getAttribute("canSendEmail") : ""%>" maxlength="255" style="width:100%;color: black; font-weight: bold; font-size: 12px">
                            </TD>
                        </TR>
                        <TR>
                            <TD class="backgroundHeader" style="<%=style%>" width="35%">
                                <p><b style="margin-left: 5px;margin-left: 5px;font-weight: bold"><%=isSuperUser%></b>&nbsp;
                            </TD>
                            <TD style="border-width: 0px" width="65%">
                                <div align="<%=divAlign%>"><input disabled type="checkbox" name="isSuperUser" <% if (user.getAttribute("isSuperUser") != null && !user.getAttribute("isSuperUser").equals("") && user.getAttribute("isSuperUser").equals("1")) {%>checked<%}%> ID="isSuperUser"></div>
                            </TD>
                        </TR>
                        <TR>
                            <TD class="backgroundHeader" style="<%=style%>" width="35%">
                                <p><b style="margin-left: 5px;margin-left: 5px;font-weight: bold"><%=userType%></b>&nbsp;
                            </TD>
                            <TD style="border-width: 0px" width="35%">
                                <div align="<%=divAlign%>"><b><font size="3">
                                        <% if (user.getAttribute("userType") != null && !user.getAttribute("userType").equals("") && user.getAttribute("userType").equals("1")) {%>
                                        <%=sMgr%>
                                        <% } else {%>
                                        <%=sEmp%>
                                        <% }%>
                                        </font></b></div>
                            </TD>
                        </TR>
                        <!--
                                                <TR>
                                                    <TD class="backgroundHeader" style="<%=style%>" width="35%">
                                                        <p><b style="margin-left: 5px;margin-left: 5px;font-weight: bold"><%=sTrade%></b>&nbsp;
                                                    </TD>
                                                    <TD style="border-width: 0px" width="65%">
                                                        <input type="text" name="trade" ID="trade" readonly size="35" value="<%//=trade.getAttribute("tradeName")%>" maxlength="255" style="width:100%;color: black; font-weight: bold; font-size: 12px">
                                                    </TD>
                                                </TR> -->
                    </TABLE>
                    <BR>
                    <div align="<%=divAlign%>" style="margin-<%=divAlign%>: 15%;color: blue">
                        <p dir="<%=dir%>" align="divAlign" style="background-color: #E6E6FA;width:20%;font-weight: bold;font-size: 16px;padding-top: 2px;padding-bottom: 2px;padding-left: 5px;padding-right: 5px"><b><%=sGroup%></b></p>
                    </div>

                    <TABLE CLASS="blueBorder" style="border-color: silver;" WIDTH="70%" CELLPADDING="0" CELLSPACING="0" ALIGN="CENTER" DIR="<%=dir%>">
                        <TR style="cursor: pointer;" class="backgroundHeader" onmousemove="this.className = 'selectedRow'" onmouseout="this.className = 'backgroundHeader'">
                            <TD CLASS="" width="10%" STYLE="font-size: 14px;font-weight: bold;color: black;text-align:center;border-top-width: 0px;height: 20px">
                                <%=isDefault%>
                            </TD>
                            <TD CLASS="" width="90%" STYLE="font-size: 14px;font-weight: bold;color: black;text-align:center;border-top-width: 0px">
                                <%=name%>
                            </TD>
                        </TR>
                        <%
                            boolean booleanIsDefault = false;
                            String defaultRow = "";
                            for (WebBusinessObject group : groups) {
                                booleanIsDefault = isDefaultGroup != null && isDefaultGroup.equalsIgnoreCase((String) group.getAttribute("groupID"));
                                if (booleanIsDefault) {
                                    defaultRow = "defaultRow";
                                } else {
                                    defaultRow = "";
                                }
                        %>
                        <TR class="<%=defaultRow%>" style="cursor: pointer" onmousemove="this.className = 'selectedRow'" onmouseout="this.className = '<%=defaultRow%>'">
                            <TD STYLE="text-align:center;border-top-width: 0px">
                                <% if (booleanIsDefault) {%>
                                <img src="images/accept.png" height="15" width="16" alt="accept" />
                                <% } else {%>
                                &ensp;
                                <% }%>
                            </TD>
                            <TD STYLE="text-align:center;border-top-width: 0px">
                                <%=group.getAttribute("groupName")%>
                            </TD>
                        </TR>
                        <% }%>
                        <% if (groups != null && groups.isEmpty()) {%>
                        <TR style="cursor: pointer" onmousemove="this.className = 'selectedRow'" onmouseout="this.className = '<%=defaultRow%>'">
                            <TD colspan="2" STYLE="text-align:center;border-top-width: 0px; color: red">
                                <%=isNotSelec%>
                            </TD>
                        </TR>
                        <% }%>
                    </TABLE>
                    <br /><br />
                    <BR>
                    <div align="<%=divAlign%>" style="margin-<%=divAlign%>: 15%;color: blue">
                        <p dir="<%=dir%>" align="divAlign" style="background-color: #E6E6FA;width:20%;font-weight: bold;font-size: 16px;padding-top: 2px;padding-bottom: 2px;padding-left: 5px;padding-right: 5px"><b><%=sites%></b></p>
                    </div>
                    <TABLE CLASS="blueBorder" style="border-color: silver;" WIDTH="70%" CELLPADDING="0" CELLSPACING="0" ALIGN="CENTER" DIR="<%=dir%>">
                        <TR style="cursor: pointer;" class="backgroundHeader" onmousemove="this.className = 'selectedRow'" onmouseout="this.className = 'backgroundHeader'">
                            <TD CLASS="" width="10%" STYLE="font-size: 14px;font-weight: bold;color: black;text-align:center;border-top-width: 0px;height: 20px">
                                <%=isDefault%>
                            </TD>
                            <TD CLASS="" width="90%" STYLE="font-size: 14px;font-weight: bold;color: black;text-align:center;border-top-width: 0px;height: 20px">
                                <%=name%>
                            </TD>
                        </TR>
                        <%
                            booleanIsDefault = false;
                            defaultRow = "";
                            for (WebBusinessObject project : projects) {
                                booleanIsDefault = isDefaultProject != null && isDefaultProject.equalsIgnoreCase((String) project.getAttribute("projectID"));
                                if (booleanIsDefault) {
                                    defaultRow = "defaultRow";
                                } else {
                                    defaultRow = "";
                                }
                        %>
                        <TR class="<%=defaultRow%>" style="cursor: pointer" onmousemove="this.className = 'selectedRow'" onmouseout="this.className = '<%=defaultRow%>'">
                            <TD STYLE="text-align:center;border-top-width: 0px">
                                <% if (booleanIsDefault) {%>
                                <img src="images/accept.png" height="15" width="16" alt="accept" />
                                <% } else {%>
                                &ensp;
                                <% }%>
                            </TD>
                            <TD STYLE="text-align:center;border-top-width: 0px">
                                <%=project.getAttribute("projectName")%>
                            </TD>
                        </TR>
                        <% }%>
                        <% if (projects != null && projects.isEmpty()) {%>
                        <TR style="cursor: pointer" onmousemove="this.className = 'selectedRow'" onmouseout="this.className = '<%=defaultRow%>'">
                            <TD colspan="2" STYLE="text-align:center;border-top-width: 0px; color: red">
                                <%=isNotSelec%>
                            </TD>
                        </TR>
                        <% }%>
                    </TABLE>
                    <BR>
                </fieldset>
            </center>
            <input type="hidden" id="numberOfUsers" name="numberOfUsers" value="<%=numberOfUsers%>" />
            
        </FORM>
        <div id="manager_dialog" class="mediumDialog"></div>
    </BODY>
</HTML>     
