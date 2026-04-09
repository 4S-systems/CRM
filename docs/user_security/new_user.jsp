<%@page import="com.maintenance.common.Tools"%>
<%@page import="com.tracker.db_access.ProjectMgr"%>
<%@page import="java.util.ArrayList"%>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,com.silkworm.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page pageEncoding="UTF-8" %>

<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();

    Vector<WebBusinessObject> groups = (Vector<WebBusinessObject>) request.getAttribute("groups");
    Vector<String> tradesForUser = (Vector<String>) request.getAttribute("tradesForUser");
    String groupID = (String) request.getAttribute("groupID");
    String defaultIndex = "";
    //Vector<WebBusinessObject> projects = (Vector<WebBusinessObject>) request.getAttribute("projects");
    Vector<WebBusinessObject> grants = (Vector<WebBusinessObject>) request.getAttribute("grants");
    ArrayList trades = (ArrayList) request.getAttribute("trades");
    Vector<WebBusinessObject> allRoles = (Vector<WebBusinessObject>) request.getAttribute("allTrades");
    Vector<WebBusinessObject> projects = (Vector<WebBusinessObject>) request.getAttribute("allSites");
    Vector<WebBusinessObject> projects_ = new Vector<WebBusinessObject>();

    String status = (String) request.getAttribute("status");
    if (status == null) {
        status = "";
    }

    WebBusinessObject wbo = null;

    String stat = (String) request.getSession().getAttribute("currentMode");

    String align = null;
    String dir = null;
    String style = null;
    String lang, langCode;
    String fStatus, isSuperUser;
    String save, cancel, rePassword, name, divAlign, tradeQual, sPassword, comments, sEmail, sGroup, sTrade, site, isDefault, basicData, sUserName, sTitle, doubleName, success;
    String sPadding, strDefault, fullName,userType, sipID;
    if (stat.equals("En")) {
        align = "center";
        dir = "LTR";
        divAlign = "left";
        style = "text-align:left";
        lang = "   &#1593;&#1585;&#1576;&#1610;    ";
        sUserName = "User Name";
        sTitle = "New User";
        cancel = "Cancel";
        save = "Save";
        langCode = "Ar";
        rePassword = "Re Write Password";
        sPassword = "Password";
        sEmail = "Email Address";
        sGroup = "Group";
        sTrade = "Trade";
        isSuperUser = "Is Super User";
        fStatus = "Fail To Create Group";
        site = "Branches";
        isDefault = "Is Default";
        basicData = "Basic Data";
        name = "Name";
        doubleName = "This User Name Exist";
        success = "New user has been added successfully";
        strDefault = "Default";
        sPadding = "left";
        fullName = "Full Name";
        tradeQual = "Trade Qualification";
        comments = "Notes";
        userType="User type";
        sipID = "SIP ID";
    } else {
        align = "center";
        dir = "RTL";
        divAlign = "right";
        style = "text-align:Right";
        lang = "English";
        sUserName = "&#1575;&#1587;&#1605; &#1575;&#1604;&#1605;&#1587;&#1578;&#1582;&#1583;&#1605;";
        sTitle = "&#1605;&#1587;&#1578;&#1582;&#1583;&#1605; &#1580;&#1583;&#1610;&#1583;";
        cancel = "&#1573;&#1606;&#1607;&#1575;&#1569;";
        save = "&#1578;&#1587;&#1580;&#1610;&#1604;";
        langCode = "En";
        rePassword = "&#1571;&#1593;&#1575;&#1583;&#1577; &#1603;&#1604;&#1605;&#1577; &#1575;&#1604;&#1605;&#1585;&#1608;&#1585;";
        sPassword = "&#1603;&#1604;&#1605;&#1577; &#1575;&#1604;&#1605;&#1585;&#1608;&#1585;";
        sEmail = "&#1575;&#1604;&#1576;&#1585;&#1610;&#1583; &#1575;&#1604;&#1573;&#1604;&#1603;&#1578;&#1585;&#1608;&#1606;&#1610;";
        sGroup = "&#1575;&#1604;&#1605;&#1580;&#1605;&#1608;&#1593;&#1575;&#1578;";
        sTrade = "&#1575;&#1604;&#1573;&#1583;&#1575;&#1585;&#1577; &#1575;&#1604;&#1601;&#1606;&#1610;&#1577;";
        fStatus = "&#1604;&#1600;&#1605; &#1610;&#1600;&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604;";
        isSuperUser = "&#1587;&#1604;&#1591;&#1575;&#1578; &#1605;&#1591;&#1600;&#1600;&#1600;&#1600;&#1604;&#1602;&#1577;";
        site = "&#1575;&#1604;&#1601;&#1585;&#1608;&#1593;";
        isDefault = "&#1573;&#1601;&#1578;&#1585;&#1575;&#1590;&#1609;";
        basicData = "&#1575;&#1604;&#1576;&#1610;&#1575;&#1606;&#1575;&#1578; &#1575;&#1604;&#1571;&#1587;&#1575;&#1587;&#1610;&#1577;";
        name = "&#1575;&#1604;&#1571;&#1587;&#1605;";
        doubleName = "&#1575;&#1587;&#1605; &#1575;&#1604;&#1605;&#1587;&#1578;&#1582;&#1583;&#1605; &#1607;&#1584;&#1575; &#1605;&#1608;&#1580;&#1608;&#1583;";
        success = "&#1578;&#1605; &#1573;&#1590;&#1575;&#1601;&#1577; &#1575;&#1604;&#1605;&#1587;&#1578;&#1582;&#1583;&#1605; &#1575;&#1604;&#1580;&#1583;&#1610;&#1583; &#1576;&#1606;&#1580;&#1575;&#1581;";
        strDefault = "&#1573;&#1601;&#1578;&#1585;&#1575;&#1590;&#1609;";
        fullName = "الإسم بالكامل";
        sPadding = "right";
        tradeQual = "نوع الدور";

        comments = "ملاحظات";
        userType="نوع المستخدم";
        sipID = "SIP ID";
    }
%>

<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Document Viewer - add new user</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <script src='ChangeLang.js' type='text/javascript'></script>
    </HEAD>

    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

        function isCheckedAllProjects() {
            var checkProjects = document.getElementsByName('checkTrade');
            var count = 0;
            
            for(var i = 0; i < checkProjects.length; i++) {
                if(checkProjects[i].checked) {
                    count++;
                }
            }

            if(count == checkProjects.length && checkProjects.length > 0) {
                document.getElementById('checkAll').checked = true;
            } else {
                document.getElementById('checkAll').checked = false;
            }
        }
           
        function checkAlla2(index) {
            var check = false;
            if (document.getElementById('checkTrade'+index).checked == true) {
                document.getElementById('tradeQualification'+index).disabled=false;
                document.getElementById('notes'+index).disabled=false;
                document.getElementById('tradeName'+index).disabled=false;
                document.getElementById('tradeId'+index).disabled=false;
                document.getElementById('isDefault'+index).checked=false
                document.getElementById('isDefault'+index).disabled=false;
                check  = false;
            } else {
                document.getElementById('tradeQualification'+index).disabled=true;
                document.getElementById('notes'+index).disabled=true;
                document.getElementById('tradeName'+index).disabled=true;
                document.getElementById('tradeId'+index).disabled=true;
                document.getElementById('isDefault'+index).checked=false;
                document.getElementById('isDefault'+index).disabled=true;
                check = true;
            }

            //  isDefaultDisabled(check, index);
        }
        function checkedAll2() {
            var checkProject = document.getElementsByName('checkTrade');
            var isDefault = document.getElementsByName('isDefault');
               
            var checked = false;
            var check = false;
            var disabled = false;
            if(document.getElementById('checkAll').checked) {
                checked = true;
                check  = false;
                disabled = false;

            } else {
                checked = false;
                check = true;
                disabled = true;
            }
            //alert('checkProject.length : '+checkProject.length);
            //alert('isDefault.length : '+isDefault.length);
            for(var j = 0; j< checkProject.length; j++) {
                checkProject[j].checked = checked;

                isDefault[j].disabled = disabled;
                isDefault[j].checked = check;
            }
                
        }
        function isDefaultDisabled(disabled, index) {
            document.getElementById('isDefault' + index).disabled = disabled;
            document.getElementById('isDefault' + index).checked = false;
        }
        
        $(document).ready(function() {
            $('#checkAllGroup').click(function() {
                checkAll('Group');
            });
            $('#checkAll').click(function() {
                checkedAll();
            });
        });

        function validateForm2() {
            var checkProject = document.getElementsByName('checkTrade');
            var isDefault = document.getElementsByName('isDefault');
            var selectIsDefault = false;
            var count = 0;

            for(var i = 0; i< checkProject.length; i++) {
                if(checkProject[i].checked) {
                    count++;

                    if(isDefault[i].checked) {
                        selectIsDefault = true;
                    }
                }
            }

            if(selectIsDefault && count > 0) {
                return true;
            } else if(count == 0) {
                alert("You must select at least one role ... ");
                return false;
            } else {
                alert("You must select default role ... ");
                return false;
            }
        }
        
        function submitForm() {

            if (!validateData("req", this.USERS_FORM.user_name, "Please, enter User Name ...")) {
                this.USERS_FORM.user_name.focus();
            } else if (!validateData("req", this.USERS_FORM.user_password, "Please, enter Password ...")) {
                this.USERS_FORM.user_password.focus();
            } else if (!validateData("req", this.USERS_FORM.repassword, "Please, enter RePassword ...")) {
                this.USERS_FORM.repassword.focus();
            } else if (!confirmPassword()) {
                this.USERS_FORM.user_password.focus();
            } else if (!validateData("req", this.USERS_FORM.email, "Please, enter Email ...")) {  //!validateData("req", this.USERS_FORM.email, "Please, enter Email.") ||
                this.USERS_FORM.email.focus();
            } else if (!validateData("email", this.USERS_FORM.email, "Please, enter a valid Email ...")) {  //!validateData("req", this.USERS_FORM.email, "Please, enter Email.") ||
                this.USERS_FORM.email.focus();
                //            } else if (!validateData("req", this.USERS_FORM.userTrades, "Please, enter trade ...")) {
                //                this.USERS_FORM.userTrades.focus();
            } else if (!validateChecked('Group')) {
                return;
//            } else if (!validateForm2()) {
//                return;
            }else if (!validateForm()) {
                return;
            } else if (document.getElementById('totalGrant').value <= 0) {
                alert("Please, check for grants ...");
                return;
            } else {
                document.USERS_FORM.action = "<%=context%>/UsersServlet?op=SaveUser";
                document.USERS_FORM.submit();
            }
        }

        function validateForm() {
            var checkProject = document.getElementsByName('checkProject');
            var isDefault = document.getElementsByName('isDefaultProject');
            var selectIsDefault = false;
            var count = 0;

            for (var i = 0; i < checkProject.length; i++) {
                if (checkProject[i].checked) {
                    count++;

                    if (isDefault[i].checked) {
                        selectIsDefault = true;
                    }
                }
            }

            if (selectIsDefault && count > 0) {
                return true;
            } else if (count == 0) {
                alert("You must select at least one branch ... ");
                return false;
            } else {
                alert("You must select default branch ... ");
                return false;
            }
        }
        function cancelForm() {
            document.USERS_FORM.action = "main.jsp";
            document.USERS_FORM.submit();
        }

        function checkedSingle(groupOrProject, index) {
            if (document.getElementById('check' + groupOrProject + index).checked) {
                document.getElementById('isDefault' + groupOrProject + index).disabled = false;
            } else {
                document.getElementById('isDefault' + groupOrProject + index).disabled = true;
            }

            document.getElementById('isDefault' + groupOrProject + index).checked = false;

            checkForCheckAll(groupOrProject);
        }

        function checkAll(groupOrProject) {
            var check = document.getElementById('checkAll' + groupOrProject).checked;

            var length = document.getElementsByName('isDefault' + groupOrProject).length;

            for (var i = 0; i < length; i++) {
                isDefaultDisabled(groupOrProject, check, i);
            }
        }

        function isDefaultDisabled(groupOrProject, disabled, index) {
            document.getElementById('check' + groupOrProject + index).checked = disabled;
            if (disabled) {
                document.getElementById('isDefault' + groupOrProject + index).disabled = false;
            } else {
                document.getElementById('isDefault' + groupOrProject + index).disabled = true;
            }

            document.getElementById('isDefault' + groupOrProject + index).checked = false;
        }

        function checkForCheckAll(groupOrProject) {
            var count = 0;
            var length = document.getElementsByName('isDefault' + groupOrProject).length;

            for (var i = 0; i < length; i++) {
                if (document.getElementById('check' + groupOrProject + i).checked) {
                    count++;
                }
            }

            if (length > 0 && count == length) {
                document.getElementById('checkAll' + groupOrProject).checked = true;
            } else {
                document.getElementById('checkAll' + groupOrProject).checked = false;
            }
        }

        function validateChecked(groupOrProject) {
            var check = false;
            var isDefault = false;
            var checkGroupOrProject = document.getElementsByName('check' + groupOrProject);
            var isDefaultGroupOrProject = document.getElementsByName('isDefault' + groupOrProject);

            for (var i = 0; i < checkGroupOrProject.length; i++) {
                if (checkGroupOrProject[i].checked) {
                    check = true;

                    if (isDefaultGroupOrProject[i].checked) {
                        isDefault = true;
                        break;
                    }
                }
            }

            if (!check) {
                alert("you must select at least one " + groupOrProject + " ...");
                return false;
            } else if (!isDefault) {
                alert("you must select default " + groupOrProject + " ...");
                return false;
            } else {
                return true;
            }
        }

        function confirmPassword() {
            var password = document.getElementById('user_password').value;
            var repassword = document.getElementById('repassword').value;

            if (password != repassword) {
                alert("check confirm password ...");
                return false;
            } else {
                return true;
            }
        }

        function checkedAll() {
            var checkProject = document.getElementsByName('checkProject');
            var isDefault = document.getElementsByName('isDefaultProject');
            var checkSubProject = 0;
            var checked = false;
            var check = false;
            var disabled = false;
            if (document.getElementById('checkAll').checked) {
                checked = true;
                check = false;
                disabled = false;

            } else {
                checked = false;
                check = true;
                disabled = true;
            }
            //alert('checkProject.length : '+checkProject.length);
            //alert('isDefault.length : '+isDefault.length);
            for (var j = 0; j < checkProject.length; j++) {
                checkProject[j].checked = checked;

                isDefault[j].disabled = disabled;
                isDefault[j].checked = check;
                try {
                    //                        document.getElementById('checkProject'+j).checked = checked;
                    //                        isDefaultDisabled(check, j);
                    //                        document.getElementById('checkSubProject'+j).checked = checked;
                    //                        isDefaultDisabledSubProjects(check, j, "");
                    //alert('checkProject.length : '+checkProject.length+ ' : ' +j);

                    //                        checkSubProject = document.getElementById('totalSubProjects'+j);
                    //                        //alert('checkSubProject.value totalSubProjects :' +checkSubProject.value+' : '+j);
                    //                        var subIndex = 0;
                    //
                    //                        alert('totalSubProjects'+j+ ' : '+checkSubProject.value);
                    //                        if(checkSubProject.value > 0) {
                    //                            for(var i = 0; i< checkSubProject.value; i++) {
                    //                                subIndex = j++;
                    //                                alert('checkSubProject'+subIndex);
                    //                                document.getElementById('checkSubProject'+subIndex).checked = checked;
                    //                                //isDefaultDisabledSubProjects(check, j, subIndex);
                    //                            }
                    //                        }
                } catch (e) {
                }
            }

        }

        function checkedStores(i, j) {
            //alert('index  : '+index)
            //var i = "";
            var index = j;
            var disabled = document.getElementById('checkSubProject' + index).checked;
            //alert('disabled  : '+disabled)
            if (disabled) {

                isDefaultDisable(false, index);
                document.getElementById('checkProject' + i).checked = true;
                isDefaultDisable(false, i);
            }
            else {

                isDefaultDisable(true, index);

                //isUnCheckedAllSubProjects(i,j);
            }
        }

        function isDefaultDisable(disabled, index) {
            document.getElementById('isDefaultProject' + index).disabled = disabled;
            document.getElementById('isDefaultProject' + index).checked = false;
        }

        function isDefaultDisabledSubProjects(disabled, i, j) {
            document.getElementById('isDefaultProject' + i + j).disabled = disabled;
            document.getElementById('isDefaultProject' + i + j).checked = false;
        }

        function isCheckedAllProjects() {
            var checkProjects = document.getElementsByName('checkProject');
            var count = 0;

            for (var i = 0; i < checkProjects.length; i++) {
                if (checkProjects[i].checked) {
                    count++;
                }
            }

            if (count == checkProjects.length && checkProjects.length > 0) {
                document.getElementById('checkAll').checked = true;
            } else {
                document.getElementById('checkAll').checked = false;
            }
        }
        function isUnCheckedAllSubProjects(j) {
            var checkSubProjects = document.getElementById('totalSubProjects' + j);
            //alert('checkSubProjects.value : ' +checkSubProjects.value);
            var count = 0;

            for (var i = 0; i < checkSubProjects.value; i++) {
                if (document.getElementById('checkSubProject' + j + i).checked) {
                    count++;
                }
            }
            if (count == checkSubProjects.value && checkSubProjects.value > 0) {
                document.getElementById('checkProject' + j).checked = true;
            } else if (count == 0) {

                document.getElementById('checkProject' + j).checked = false;

                isDefaultDisabled(true, j);

            }
        }
        function checkAlla(index) {

            var checkSubProject = 0;
            var checked = false;
            var check = false;
            if (document.getElementById('checkProject' + index).checked == true) {

                checked = true;
                check = false;
            } else {
                checked = false;
                check = true;
            }

            isDefaultDisabled(check, index);
            var subIndex = parseInt(index);
            try {
                var checkSubProject = document.getElementById('totalSubProjects' + index);
                if (checkSubProject.value > 0) {


                    for (var i = 0; i < checkSubProject.value; i++) {
                        subIndex++;
                        //alert('sssssssss----' + subIndex + '---sssssss: ' + checkSubProject.value);
                        //alert('ssssssssssssssss: ' + document.getElementById('checkSubProject'+subIndex).checked);
                        document.getElementById('checkSubProject' + subIndex).checked = checked;
                        isDefaultDisabled(check, subIndex);
                    }
                }
            } catch (e) {
            }
        }
    </SCRIPT>

    <BODY onload="document.USERS_FORM.user_name.focus();">
        <FORM action=""  NAME="USERS_FORM" METHOD="POST">
            <DIV align="center" STYLE="color:blue;padding-left: 5%; padding-bottom: 10px">
                <!--<input type="button"  value="<%=lang%>"  onclick="reloadAE('<%=langCode%>')" class="button">-->
                &ensp;
                <button onclick="cancelForm()" class="button"><%=cancel%></button>
                &ensp;
                <!--<button class="button"><%=save%></button>-->
                <input type="button"  onclick="JavaScript:  submitForm();" value="<%=save%>" class="button" />
            </DIV>
            <center>
                <fieldset class="set" style="width:90%;border-color: #006699;">
                    <table class="blueBorder" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                        <tr>
                            <td style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueBorder blueHeaderTD">
                                <font color="#F3D596" size="4"><%=sTitle%></font>
                            </td>
                        </tr>
                    </table>
                    <% if (status.equalsIgnoreCase("error")) {%>
                    <br>
                    <table align="<%=align%>" dir="<%=dir%>" WIDTH="70%">
                        <tr>
                            <td class="backgroundHeader">
                                <font size="3" color="red"><%=fStatus%></font>
                            </td>
                        </tr>
                    </table>
                    <% } else if (status.equalsIgnoreCase("doubleName")) {%>
                    <br>
                    <table align="<%=align%>" dir=<%=dir%> WIDTH="70%">
                        <tr>
                            <td class="backgroundHeader">
                                <font size="3" color="red"><%=doubleName%></font>
                            </td>
                        </tr>
                    </table>
                    <% } else if (status.equalsIgnoreCase("ok")) {%>
                    <br>
                    <table align="<%=align%>" dir=<%=dir%> WIDTH="70%">
                        <tr>
                            <td class="backgroundHeader">
                                <font size="3" color="blue"><%=success%></font>
                            </td>
                        </tr>
                    </table>
                    <% }%>
                    <br>
                    <div align="<%=divAlign%>" style="margin-<%=divAlign%>: 15%;color: blue">
                        <p dir="<%=dir%>" align="divAlign" style="background-color: #E6E6FA;width:20%;font-weight: bold;font-size: 16px;padding-top: 2px;padding-bottom: 2px;padding-left: 5px;padding-right: 5px"><b><%=basicData%></b></p>
                    </div>
                    <TABLE class="backgroundTable" width="70%" CELLPADDING="0" CELLSPACING="8" ALIGN="CENTER" DIR="<%=dir%>">

                        <TR>
                            <TD class="backgroundHeader" style="<%=style%>" width="35%">
                                <p><b style="margin-left: 5px;margin-left: 5px;font-weight: bold"><%=fullName%></b>
                            </TD>
                            <TD style="border-width: 0px" width="65%">
                                <input type="TEXT" name="full_name" ID="full_name" size="33" value="" maxlength="255" style="width:100%;color: black; font-weight: bold; font-size: 12px">
                            </TD>
                        </TR>

                        <TR>
                            <TD class="backgroundHeader" style="<%=style%>" width="35%">
                                <p><b style="margin-left: 5px;margin-left: 5px;font-weight: bold"><%=sUserName%></b></p>
                            </TD>
                            <TD style="border-width: 0px" width="65%">
                                <input type="TEXT" name="user_name" ID="user_name" size="33" value="" maxlength="255" style="width:100%;color: black; font-weight: bold; font-size: 12px">
                            </TD>
                        </TR>

                        <TR>
                            <TD class="backgroundHeader" style="<%=style%>" width="35%">
                                <p><b style="margin-left: 5px;margin-left: 5px;font-weight: bold"><%=sPassword%></b></p>
                            </TD>
                            <TD style="border-width: 0px" width="65%">
                                <input type="PASSWORD" name="user_password" ID="user_password" size="35" value="" maxlength="255" style="width:100%;color: black; font-weight: bold; font-size: 12px" />
                            </TD>
                        </TR>

                        <TR>
                            <TD class="backgroundHeader" style="<%=style%>" width="35%">
                                <p><b style="margin-left: 5px;margin-left: 5px;font-weight: bold;"><%=rePassword%></b>
                            </TD>
                            <TD style="border-width: 0px" width="65%">
                                <input type="PASSWORD" name="repassword" ID="repassword" size="35" value="" maxlength="255" style="width:100%;color: black; font-weight: bold; font-size: 12px">
                            </TD>
                        </TR>

                        <TR>
                            <TD class="backgroundHeader" style="<%=style%>" width="35%">
                                <p><b style="margin-left: 5px;margin-left: 5px;font-weight: bold"><%=sEmail%></b>
                            </TD>
                            <TD style="border-width: 0px" width="65%">
                                <input type="TEXT" name="email" ID="email" size="33" value="" maxlength="255" style="width:100%;color: black; font-weight: bold; font-size: 12px">
                            </TD>
                        </TR>
                        
                        <TR>
                            <TD class="backgroundHeader" style="<%=style%>" width="35%">
                                <p><b style="margin-left: 5px;margin-left: 5px;font-weight: bold"><%=sipID%></b>
                            </TD>
                            <TD style="border-width: 0px" width="65%">
                                <input type="TEXT" name="SIPID" ID="SIPID" size="33" value="" maxlength="255" style="width:100%;color: black; font-weight: bold; font-size: 12px">
                            </TD>
                        </TR>

                        <!--                        <TR>
                                                    <TD class="backgroundHeader" style="<%=style%>" width="35%">
                                                        <p><b style="margin-left: 5px;margin-left: 5px;font-weight: bold"><%=sTrade%></b>&nbsp;
                                                    </TD>
                                                    <TD style="border-width: 0px" width="65%">
                                                        <select name="userTrades" id="userTrades" dir="<%=dir%>" style="width:100%;color: black; font-weight: bold; font-size: 12px">
                        <sw:WBOOptionList wboList="<%=trades%>" valueAttribute="tradeId" displayAttribute="tradeName" />
                    </select>
                </TD>
            </TR>-->

                        <TR>
                            <TD class="backgroundHeader" style="<%=style%>" width="35%">
                                <p><b style="margin-left: 5px;margin-left: 5px;font-weight: bold"><%=isSuperUser%></b>&nbsp;
                            </TD>
                            <TD style="border-width: 0px" width="65%">
                                <div align="<%=divAlign%>"><input type="checkbox" name="isSuperUser" ID="isSuperUser" value="1"></div>
                            </TD>
                        </TR>
                        <TR>
                            <TD class="backgroundHeader" style="<%=style%>" width="35%">
                                <p><b style="margin-left: 5px;margin-left: 5px;font-weight: bold"><%=userType%></b>&nbsp;
                            </TD>
                            <TD style="border-width: 0px" width="65%">
                                <div align="<%=divAlign%>">
                                    <SELECT id="isManager" name="isManager" style="font-size: 14px;">
                                        <OPTION value="1">مدير</OPTION>
                                        <OPTION value="0">موظف</OPTION>
                                    </SELECT></div>
                            </TD>
                        </TR>
                    </TABLE>
                    <BR>
                    <div align="<%=divAlign%>" style="margin-<%=divAlign%>: 15%;color: blue">
                        <p dir="<%=dir%>" align="divAlign" style="background-color: #E6E6FA;width:20%;font-weight: bold;font-size: 16px;padding-top: 2px;padding-bottom: 2px;padding-left: 5px;padding-right: 5px"><b><%=sGroup%></b></p>
                    </div>

                    <TABLE CLASS="blueBorder" style="border-color: silver;" WIDTH="70%" CELLPADDING="0" CELLSPACING="0" ALIGN="CENTER" DIR="<%=dir%>">
                        <TR style="cursor: pointer;" class="backgroundHeader" onmousemove="this.className = 'selectedRow'" onmouseout="this.className = 'backgroundHeader'">

                            <TD  CLASS="" width="10%" style="text-align:center;border-top-width: 0px">
                                <input type="checkbox" id="checkAllGroup" name="checkAllGroup" />
                            </TD>
                            <TD CLASS="" width="80%" STYLE="font-size: 14px;font-weight: bold;color: black;text-align:center;border-top-width: 0px">
                                <%=name%>
                            </TD>
                            <TD  CLASS="" width="10%" style="text-align:center;border-top-width: 0px">
                                <%=isDefault%>
                            </TD>

                        </TR>
                        <%
                            int indexGroup = 0;
                            for (WebBusinessObject group : groups) {
                                if (group.getAttribute("groupID").equals(groupID)) {
                                    defaultIndex = indexGroup + "";
                                }
                        %>
                        <TR style="cursor: pointer" onmousemove="this.className = 'selectedRow'" onmouseout="this.className = ''">

                            <TD style="text-align:center;border-top-width: 0px">
                                <INPUT TYPE="CHECKBOX" ID="checkGroup<%=indexGroup%>" NAME="checkGroup" value ="<%=indexGroup%>" onclick="checkedSingle('Group', '<%=indexGroup%>');">
                            </TD>
                            <TD STYLE="text-align:center;border-top-width: 0px">
                                <%=group.getAttribute("groupName")%>
                            </TD>
                            <TD STYLE="text-align:center;border-top-width: 0px">
                                <input type="radio" id="isDefaultGroup<%=indexGroup%>" name="isDefaultGroup" disabled value="<%=group.getAttribute("groupID")%>" />
                                <input type="hidden" id="groupID" name="userGroups" value="<%=group.getAttribute("groupID")%>" />
                            </TD>

                        </TR>
                        <% indexGroup++;
                            }%>
                    </TABLE>
                    <BR>
                    <div align="<%=divAlign%>" style="display: none;margin-<%=divAlign%>: 15%;color: blue">
                        <p dir="<%=dir%>" align="divAlign" style="background-color: #E6E6FA;width:20%;font-weight: bold;font-size: 16px;padding-top: 2px;padding-bottom: 2px;padding-left: 5px;padding-right: 5px"><b>تعين الأدوار </b></p>
                    </div>
                    <TABLE CLASS="blueBorder" style="display: none; border-color: silver;" WIDTH="60%" CELLPADDING="0" CELLSPACING="0" ALIGN="CENTER" DIR="<%=dir%>">
                        <TR style="cursor: pointer;" class="mainHeaderNormal" onmousemove="this.className='selectedRow0'" onmouseout="this.className='mainHeaderNormal'">

                            <TD CLASS="" width="50%" STYLE="font-size: 14px;font-weight: bold;color: black;text-align:center;border-top-width: 0px">
                                <input type="checkbox" style="float: <%=sPadding%>" id="checkAll" name="checkAll" onclick="checkedAll2();" />
                                <%=name%>
                            </TD>
                            <TD  CLASS="" width="10%" STYLE="font-size: 14px;font-weight: bold;color: black;text-align:center;border-top-width: 0px">
                                <%=tradeQual%>
                            </TD>
                            <TD  CLASS="" width="10%" STYLE="font-size: 14px;font-weight: bold;color: black;text-align:center;border-top-width: 0px">
                                <%=comments%>
                            </TD>
                            <TD  CLASS="" width="10%" style="text-align:center;border-top-width: 0px">
                                <%=strDefault%>
                            </TD>
                        </TR>
                        <%
                            int index = 0;
                            int counter = 0;
                            String tradeId, radioChecked, tradeQualification, notes;
                            boolean checkTrade;
//                                    ProjectMgr projectMgr = ProjectMgr.getInstance();
                            for (WebBusinessObject role : allRoles) {
                                tradeId = (String) role.getAttribute("tradeId");
                                tradeQualification = (String) role.getAttribute("tradeQualification");
                                if (tradeQualification == null) {
                                    tradeQualification = "";
                                }
                                notes = (String) role.getAttribute("notes");
                                if (notes == null) {
                                    notes = "";
                                }
                                checkTrade = Tools.isFound(tradeId, tradesForUser);

                                if (tradeId != null && tradeId.equals(isDefault)) {
                                    radioChecked = "checked";
                                } else {
                                    radioChecked = "";
                                }
                                index = counter;
//                                        if(projectCode.equals("1365240752318")){
%>
                        <TR onmousemove="this.className='selectedRow0'" onmouseout="this.className='act_sub_heading'" class="act_sub_heading">

                            <TD style="cursor: pointer;text-align:<%=sPadding%>;padding-<%=sPadding%>:10;" >
                                <INPUT TYPE="CHECKBOX" ID="checkTrade<%=index%>" NAME="checkTrade" value ="<%=tradeId%>" <% if (checkTrade) {%> checked <% }%> onclick="checkAlla2('<%=index%>');">
                                <%=role.getAttribute("tradeName")%>
                                <input type="hidden" id="tradeName<%=index%>" name="tradeName" value="<%=role.getAttribute("tradeName")%>" />
                            </TD>
                            <TD style="text-align:center;border-top-width: 0px">
                                <SELECT id="tradeQualification<%=index%>" name="tradeQualification" >
                                    <OPTION value="PRIM" >دور أساسي</OPTION>
                                    <OPTION value="SEC" >دور ثانوي</OPTION>
                                    <OPTION value="TEMP">بصفه مؤقته</OPTION>
                                </SELECT>
                                <!--<input type="text" id="tradeQualification" name="tradeQualification" value="<%=tradeQualification%>" />-->
                            </TD>
                            <TD style="text-align:center;border-top-width: 0px">
                                <input type="text" id="notes<%=index%>" name="notes" value="<%=notes%>" />
                            </TD>
                            <TD STYLE=" text-align: center;border-top-width: 0px">

                                <input type="radio" id="isDefault<%=index%>" name="isDefault" <% if (!checkTrade) {%> disabled <% }%>  <%=radioChecked%> value="<%=tradeId%>" />
                                <input type="hidden" id="tradeId<%=index%>" name="tradeId" value="<%=tradeId%>" />
                            </TD>
                        </TR>

                        <%

                            counter++;
                        %>

                        <%
                                index++;
                            }
                        %>
                    </TABLE>
                    <div align="<%=divAlign%>" style="margin-<%=divAlign%>: 15%;color: blue">
                        <p dir="<%=dir%>" align="divAlign" style="background-color: #E6E6FA;width:20%;font-weight: bold;font-size: 16px;padding-top: 2px;padding-bottom: 2px;padding-left: 5px;padding-right: 5px"><b><%=site%></b></p>
                    </div>

                    <TABLE CLASS="blueBorder" style="border-color: silver;" WIDTH="70%" CELLPADDING="0" CELLSPACING="0" ALIGN="CENTER" DIR="<%=dir%>">
                        <%--<TR style="cursor: pointer;" class="backgroundHeader" onmousemove="this.className='selectedRow'" onmouseout="this.className='backgroundHeader'">

                            <TD CLASS="" width="90%" STYLE="font-size: 14px;font-weight: bold;color: black;text-align:center;border-top-width: 0px">
                                <input type="checkbox" style="float: <%=sPadding%>" id="checkAll" name="checkAll" onclick="checkedAll();" />
                                <%=name%>
                            </TD>
                            <TD  CLASS="" width="10%" style="text-align:center;border-top-width: 0px">
                                <%=isDefault%>
                            </TD>
                        </TR>

                        int indexProject = 0;
                        for(WebBusinessObject project : projects) {
                        --%>
                        <TR style="cursor: pointer" onmousemove="this.className = 'selectedRow'" onmouseout="this.className = ''">
                            <td>
                                <TABLE CLASS="blueBorder" style="border-color: silver;" WIDTH="100%" CELLPADDING="0" CELLSPACING="0" ALIGN="CENTER" DIR="<%=dir%>">
                                    <TR style="cursor: pointer;" class="mainHeaderNormal" onmousemove="this.className = 'selectedRow0'" onmouseout="this.className = 'mainHeaderNormal'">

                                        <TD CLASS="" width="90%" STYLE="font-size: 14px;font-weight: bold;color: black;text-align:center;border-top-width: 0px">
                                            <input type="checkbox" style="float: <%=sPadding%>" id="checkAll" name="checkAll" />
                                            <%=name%>
                                        </TD>
                                        <TD  CLASS="" width="10%" style="text-align:center;border-top-width: 0px">
                                            <%=strDefault%>
                                        </TD>
                                    </TR>
                                    <%
                                        index = 0;
                                        counter = 0;
                                        String projectCode;
                                        boolean checkProject;
                                        ProjectMgr projectMgr = ProjectMgr.getInstance();
                                        //WebBusinessObject project = projectMgr.getOnSingleKey("1365240752318");
                                        for (WebBusinessObject project : projects) {
                                            projectCode = (String) project.getAttribute("projectID");
                                            index = counter;
                                            if (projectCode.equals("1365240752318")) {
                                    %>
                                    <TR onmousemove="this.className = 'selectedRow0'" onmouseout="this.className = 'act_sub_heading'" class="act_sub_heading">

                                        <TD style="cursor: pointer;text-align:<%=sPadding%>;padding-<%=sPadding%>:10;" >
                                            <INPUT TYPE="CHECKBOX" ID="checkProject<%=index%>" NAME="checkProject" value ="<%=index%>" onclick="checkAlla('<%=index%>');">
                                            <%=project.getAttribute("projectName")%>
                                            <input type="hidden" id="projectName" name="projectName" value="<%=project.getAttribute("projectName")%>" />
                                        </TD>
                                        <%--<TD style="text-align:center;border-top-width: 0px">
                                            <INPUT TYPE="CHECKBOX" ID="checkProject<%=index%>" NAME="checkProject" value ="<%=index%>" <% if (checkProject) {%> checked <% }%> onclick="checkAlla('<%=index%>');">
                                        </TD>--%>
                                        <TD STYLE=" text-align: center;border-top-width: 0px">
                                            <input type="radio" id="isDefault<%=index%>" name="isDefaultProject" value="<%=projectCode%>" />
                                            <input type="hidden" id="projectCode" name="projectCode" value="<%=projectCode%>" />
                                        </TD>
                                    </TR>
                                    <%
                                        projects_ = projectMgr.getOnArbitraryKey(projectCode, "key2");
                                        int index_ = 0;
                                        int countTotal = 0;
                                        String projectCode_, projectName_;
                                        boolean checkProject_;
                                        for (WebBusinessObject project_ : projects_) {
                                            projectCode_ = (String) project_.getAttribute("projectID");
                                            projectName_ = project_.getAttribute("projectName").toString();
                                            index_ = index + 1;
                                            counter++;
                                            index_ = counter;
                                            countTotal++;
                                    %>
                                    <TR onmousemove="this.className = 'selectedRow'" onmouseout="this.className = ''">

                                        <TD style="cursor: pointer;text-align:<%=sPadding%>;padding-<%=sPadding%>:30px;" >
                                            <INPUT TYPE="CHECKBOX" ID="checkSubProject<%=index_%>" NAME="checkProject" value ="<%=index_%>" onclick="checkedStores('<%=index%>', '<%=index_%>');" />
                                            <%=project_.getAttribute("projectName")%>
                                            <input type="hidden" id="projectName" name="projectName" value="<%=projectName_%>" />
                                        </TD>
                                        <%--<TD style="text-align:center;border-top-width: 0px">
                                            <INPUT TYPE="CHECKBOX" ID="checkSubProject<%=index%><%=index_%>" NAME="checkSubProject<%=index%>" value ="<%=index_%>" <% if (checkProject_) {%> checked <% }%> onclick="checkedStores('<%=index%>','<%=index_%>');" />
                                        </TD>--%>
                                        <TD STYLE="text-align:center;border-top-width: 0px;">
                                            <input type="radio" id="isDefault<%=index_%>" name="isDefaultProject" value="<%=projectCode_%>" />
                                            <input type="hidden" id="projectCode" name="projectCode" value="<%=projectCode_%>" />
                                        </TD>
                                    </TR>
                                    <%
                                        }
                                        counter++;
                                    %>
                                    <input type="hidden" name="totalSubProjects<%=index%>" id="totalSubProjects<%=index%>" value="<%=countTotal%>">
                                    <%
                                                index++;
                                            }
                                        }
                                    %>
                                </TABLE>
                            </td>
                            <%--<TD colspan="3" style="padding:5px;text-align:center;font:bold 15px;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#ccffcc"  valign="MIDDLE" >
                                <div id='projectScroll' style="width:100%; height: 200px; overflow:auto;">
                                    <jsp:include page="/docs/new_search/project_checkbox_list_.jsp" flush="true">
                                        <jsp:param name="fieldName" value="projectCode"/>
                                    </jsp:include>
                                </div>
                            </TD>--%>
                        </TR>
                        <%-- indexProject++; } --%>
                    </TABLE>
                    <BR>
                </fieldset>
                <script type="text/javascript">
                    // to check for all project select all or not
                    isCheckedAllProjects();
                </script>
            </center>
            <!-- all hidden variables -->
            <% for (int i = 0; i < grants.size(); i++) {
                    wbo = (WebBusinessObject) grants.get(i);%>
            <input type="hidden" ID="grant<%=i%>" name="grantUser" value ="<%=wbo.getAttribute("id")%>"/>
            <% }%>
            <input type="hidden" id="totalGrant" value="<%=grants.size()%>">

            <input type="hidden" name="searchBy" id="searchBy" value="bySite" >
            <!-- -->
        </FORM>
        <script>
            <%
                if (!defaultIndex.isEmpty()) {
            %>
            $(document).ready(function(){
                $("#checkGroup" + <%=defaultIndex%>).trigger('click');
                checkedSingle('Group', '<%=defaultIndex%>');
                $("#isDefaultGroup" + <%=defaultIndex%>).trigger('click');
            });
            <%
                }
            %>
        </script>
    </BODY>
</HTML>     
