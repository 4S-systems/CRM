<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,com.silkworm.db_access.*"%>
<%@ taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%


MetaDataMgr metaMgr = MetaDataMgr.getInstance();
String context = metaMgr.getContext();

String status = (String) request.getAttribute("status");

GroupMgr groupMgr = GroupMgr.getInstance();
TradeMgr tradeMgr = TradeMgr.getInstance();
GrantsMgr grantsMgr =GrantsMgr.getInstance();
GrantUserMgr grantUserMgr= GrantUserMgr.getInstance();

UserTradeMgr userTradeMgr = UserTradeMgr.getInstance();

Vector groups = groupMgr.getCashedTable();
Vector trades = tradeMgr.getCashedTable();
Vector grants = grantsMgr.getAllgrants();

int l = groups.size();
int tradesize = trades.size();

WebBusinessObject wbo = null;
ArrayList sites=new ArrayList();
sites=(ArrayList)request.getAttribute("sites");
WebBusinessObject user = (WebBusinessObject) request.getAttribute("user");

WebBusinessObject userWbo = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
GroupPrevMgr groupPrevMgr = GroupPrevMgr.getInstance();
Vector groupPrev = groupPrev = groupPrevMgr.getOnArbitraryKey(userWbo.getAttribute("groupID").toString(), "key1");
ArrayList<String> userPrevList = new ArrayList<>();
for (int i = 0; i < groupPrev.size(); i++) {
    wbo = (WebBusinessObject) groupPrev.get(i);
    userPrevList.add((String) wbo.getAttribute("prevCode"));
}

//WebBusinessObject userTradeWbo = userTradeMgr.getOnSingleKey1(user.getAttribute("userId").toString());
TouristGuide tGuide = new TouristGuide("/com/silkworm/international/BasicForms");
String stat= (String) request.getSession().getAttribute("currentMode");
String align=null;
String dir=null;
String style=null;
String lang,langCode;

String saving_status_ok,saving_status_fail;
String sTitle,title_2;
String sUserName,sUserDesc;
String cancel_button_label;
String save_button_label, sPadding, sMenu, sSelect, sPassword, sEmail, sGroup, sTrade,project, sipID;

String isDefault,sGrantUser,sSelectAll,filterQuery,sFullName,isSuperUser,userType,divAlign;
String sMgr,sEmp,sDoubleName;
if(stat.equals("En")){
    
    align="center";
    dir="LTR";
    style="text-align:left";
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
    divAlign = "left";
    
    sUserName="User Name";
    sUserDesc="User Description";
    sTitle="Update basic data for user";
    title_2="All information are needed";
    cancel_button_label="Back To List";
    save_button_label="Save";
    langCode="Ar";
    sPadding = "left";
    sMenu = "Menu";
    sSelect = "Select";
    sPassword = "Password";
    sEmail = "Email Address";
    sGroup = "Group";
    sTrade = "Trade";
    project="Site";
    saving_status_ok="Saving Successfully";
    saving_status_fail="Fail To Save";
    isDefault = "Is Default";
    sGrantUser = "Grants user";
    sSelectAll = "All";
    filterQuery="Search by";
    sFullName="Full Name";
    isSuperUser = "Is Super User";
    userType="User type";
    sMgr="Manager";
    sEmp="Employee";
    sDoubleName = "This User Name Exist";
    sipID = "SIP ID";
}else{
    
    align="center";
    dir="RTL";
    style="text-align:Right";
    lang="English";
    divAlign = "right";
    
    
    sUserName="&#1575;&#1587;&#1605; &#1575;&#1604;&#1605;&#1587;&#1578;&#1582;&#1583;&#1605;";
    sUserDesc="&#1608;&#1589;&#1601; &#1575;&#1604;&#1605;&#1580;&#1605;&#1608;&#1593;&#1577;";
    sTitle="تغيير البيانات الاساسية";
    title_2="&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
    cancel_button_label="&#1593;&#1608;&#1583;&#1577;";
    save_button_label="&#1578;&#1587;&#1580;&#1610;&#1604;";
    langCode="En";
    sPadding = "right";
    sMenu = "&#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577;";
    sSelect = "&#1575;&#1582;&#1578;&#1575;&#1585;";
    sPassword = "&#1603;&#1604;&#1605;&#1577; &#1575;&#1604;&#1605;&#1585;&#1608;&#1585;";
    sEmail = "&#1575;&#1604;&#1576;&#1585;&#1610;&#1583; &#1575;&#1604;&#1573;&#1604;&#1603;&#1578;&#1585;&#1608;&#1606;&#1610;";
    sGroup = "&#1605;&#1580;&#1605;&#1608;&#1593;&#1577;";
    sTrade = "&#1575;&#1604;&#1573;&#1583;&#1575;&#1585;&#1577; &#1575;&#1604;&#1601;&#1606;&#1610;&#1577;";
    project="&#1575;&#1604;&#1605;&#1608;&#1602;&#1593;";
    saving_status_ok="&#1578;&#1605; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604; &#1576;&#1606;&#1580;&#1575;&#1581;";
    saving_status_fail="&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
    isDefault = "&#1573;&#1601;&#1578;&#1585;&#1575;&#1590;&#1609;";
    sGrantUser = "&#1589;&#1604;&#1575;&#1581;&#1610;&#1575;&#1578; &#1575;&#1604;&#1605;&#1587;&#1578;&#1582;&#1583;&#1605;";
    sSelectAll ="&#1575;&#1604;&#1603;&#1604;";
    filterQuery="&#1575;&#1604;&#1576;&#1581;&#1579; &#1576;&#1608;&#1575;&#1587;&#1591;&#1577;";
    sFullName="الاسم بالكامل";
    isSuperUser = "&#1587;&#1604;&#1591;&#1575;&#1578; &#1605;&#1591;&#1600;&#1600;&#1600;&#1600;&#1604;&#1602;&#1577;";
    userType="نوع المستخدم";
    sMgr="مدير";
    sEmp="موظف";
    sDoubleName = "&#1575;&#1587;&#1605; &#1575;&#1604;&#1605;&#1587;&#1578;&#1582;&#1583;&#1605; &#1607;&#1584;&#1575; &#1605;&#1608;&#1580;&#1608;&#1583;";
    sipID = "SIP ID";
}
UserGroupMgr  userGroupMgr = UserGroupMgr.getInstance();
Vector userGroupVec = new Vector();
WebBusinessObject userGroupWbo = new WebBusinessObject();
Vector grantVec = new Vector();
String userId= (String) request.getAttribute("userId");
String doubleName = (String) request.getAttribute("doubleName");
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

        function submitForm()
        {   if (!validateData("req", this.USERS_FORM.userName, "Please, enter User Name ...")) {
                this.USERS_FORM.userName.focus();
            }else if (!validateData("email", document.USERS_FORM.email, "Please, enter a valid Email.")) { //!validateData("req", document.USERS_FORM.email, "Please, enter Email.") ||
                document.USERS_FORM.email.focus();
            } else {
                document.USERS_FORM.action = "<%=context%>/UsersServlet?op=saveBasicData";
                document.USERS_FORM.submit();           
            }
        }
        function cancelForm()
        {    
        document.USERS_FORM.action = "<%=context%>/ListerServlet?op=ListUsers";
        document.USERS_FORM.submit();  
        }
        function checkDefault(i)
        {
            var check = document.getElementById('group'+i);
            var rows = document.getElementById('rows').value;
            var count = 0;
             for (x=0;x<rows;x++){
                    if(document.getElementById('isDefault'+x).checked == true){
                        count = count +1;
                    }
                }

            if ( check.checked == true ){
                   document.getElementById('isDefault'+i).disabled = false;

            } else {
                document.getElementById('isDefault'+i).checked = false;
                document.getElementById('isDefault'+i).disabled = true;
            }

        }
        function  checkRadioDefault ()
        {

            var rows = document.getElementById('rows').value;
            var countDefault = 0;

             for (x=0;x<rows;x++){
                    if(document.getElementById('isDefault'+x).checked == true){
                        countDefault = countDefault +1;
                    }
                }
                 if(countDefault >0){
                 return true;
               }else {
                 return false;
                }
        }

         function  checkGroup()
        {

            var rows = document.getElementById('rows').value;
            var countGroup = 0;

             for (x=0;x<rows;x++){
                    if(document.getElementById('group'+x).checked == true){
                        countGroup = countGroup +1;
                    }
                }
                 if(countGroup >0){

                  return true;
               }else {
                 return false;

                }
        }

        function checkAll(checkObj){
            var i = 0;
            var count = document.getElementById('totalGrant').value;
            var check = document.getElementById('allGrant');


            if ( check.checked==true ){

                        for (i=0;i<count;i++ ) {
                        document.getElementById('grant['+i+']').checked = true;
                            }
                 } else {

                        for (i=0;i<count;i++ ) {
                        document.getElementById('grant['+i+']').checked = false;
                 }
        }
        }

        function addId(){
            var i = 0;
            var count = document.getElementById('totalGrant').value;
            var checkAll = 0;

                    for (i=0;i<count;i++ ) {
                        if( document.getElementById('grant['+i+']').checked == true ){
                       checkAll = checkAll+1;

                        } else {
                            document.getElementById("allGrant").checked = false;
                        }

                    }

                    if (count == checkAll){
                        document.getElementById("allGrant").checked = true;
                    }



        }

          function  checkGrant()
        {

            var count = document.getElementById('totalGrant').value;
            var checkAll = 0;

             for (x=0;x<count;x++){
                    if(document.getElementById('grant['+x+']').checked == true){
                        checkAll = checkAll +1;
                    }
                }
                 if(checkAll >0){

                  return true;
               }else {
                 return false;

                }
        }
        
    </SCRIPT>
    
    <BODY>
        <FORM NAME="USERS_FORM" id="USERS_FORM"  METHOD="POST">
            <DIV align="left" STYLE="color:blue;">
                <input type="button"  value="<%=lang%>"  onclick="reloadAE('<%=langCode%>')" class="button">
                <button    onclick="cancelForm()" class="button"><%=cancel_button_label%> <IMG VALIGN="BOTTOM"  HEIGHT="15" SRC="images/leftarrow.gif"></button>
                <button  onclick="JavaScript:  submitForm();" class="button"><%=save_button_label%><IMG HEIGHT="15" SRC="images/save.gif"></button>
            </DIV>
            <fieldset class="set" align="center">
                <legend align="center">
                    <table align="<%=align%>" dir=<%=dir%>>
                        <tr>
                            
                            <td class="td">
                                <font color="blue" size="6">    <%=sTitle%>                
                                </font>
                                
                            </td>
                        </tr>
                    </table>
                </legend>
                <%
                if(null!=status) {
    if(status.equalsIgnoreCase("ok")){
                %>
                <center>
                    <h3>   <%=saving_status_ok%> </h3>
                </center>
                <br>
                <%}else{%>
                <center>
                    <h3>   <%=saving_status_fail%> </h3>
                    <% if (doubleName!=null && !doubleName.equals("")) {%>
                    <br><h3><font size="3" color="red"><%=sDoubleName%></font></h3>
                    <%}%>
                    
                </center>
                <br>
                <%}}
                
                %>
                <TABLE CELLPADDING="0" CELLSPACING="0" BORDER="0" ALIGN="CENTER" DIR="<%=dir%>">
                    <TR>
                        <TD class='td'>
                            <p><b style="margin-left: 5px;margin-left: 5px;font-weight: bold"><%=sFullName%></b></p>
                        </TD>
                        <%
                            if(user.getAttribute("fullName")!=null){

                        %>
                        <TD class='td'>
                            <input type="TEXT" name="fullName" ID="fullName" size="33" value="<%=user.getAttribute("fullName")%>" maxlength="255" style="width:100%;color: black; font-weight: bold; font-size: 12px">
                        </TD>
                        <%    
                            }else{
                        %>
                        <TD class='td'>
                            <input type="TEXT" name="fullName" ID="fullName" size="33" value="" maxlength="255" style="width:100%;color: black; font-weight: bold; font-size: 12px">
                        </TD>
                        <% 
                            }
                        %>
                    </TR>
                    <TR>
                        <TD class='td'>
                            <LABEL FOR="str_Function_Name">
                                <p><b><%=sUserName%>:</b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD class='td'>
                            <input type="TEXT" name="userName" ID="userName" size="33" value="<%=user.getAttribute("userName")%>" maxlength="255"
                                   <%=userPrevList.contains("EDIT_USER_NAME") ? "" : "readonly"%> />
                        </TD>
                    </TR>
                                        
                    <TR>
                        <TD class='td'>
                            <LABEL FOR="str_Function_Name">
                                <p><b><%=sEmail%>:</b>&nbsp;
                            </LABEL>
                        </TD>
                        <%
                            if(user.getAttribute("email")!=null && !user.getAttribute("email").equals("")) {
                        %>
                        <TD class='td'>
                            <% if(user.getAttribute("email") != null && !user.getAttribute("email").equals("")) { %>
                            <input type="TEXT" name="email" ID="email" size="33" value="<%=user.getAttribute("email").toString()%>" maxlength="255">
                            <% } else { %>
                            <input type="TEXT" name="email" ID="email" size="33" value="" maxlength="255">
                            <% } %>
                        </TD>
                        <%
                           } else {
                        %>
                         <TD class='td'>
                            <input type="TEXT" name="email" ID="email" size="33" maxlength="255">
                        </TD>
                        <%
                           }
                        %>
                    </TR>
                    <TR>
                        <TD class='td'>
                            <LABEL>
                                <p><b><%=sipID%>:</b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD class='td'>
                            <input type="TEXT" name="SIPID" ID="SIPID" size="33" value="<%=user.getAttribute("canSendEmail") != null ? user.getAttribute("canSendEmail") : ""%>" maxlength="255"/>
                        </TD>
                    </TR>
                    <TR>
                            <TD class='td'>
                                <p><b style="margin-left: 5px;margin-left: 5px;font-weight: bold"><%=isSuperUser%></b>&nbsp;
                            </TD>
                            <TD class='td'>
                                <div align="<%=divAlign%>"><input type="checkbox" name="isSuperUser" <% if (user.getAttribute("isSuperUser") != null && !user.getAttribute("isSuperUser").equals("") && user.getAttribute("isSuperUser").equals("1")){%>checked<%}%> ID="isSuperUser" value="1"></div>
                            </TD>
                    </TR>
                    <TR>
                            <TD class="td">
                                <p><b style="margin-left: 5px;margin-left: 5px;font-weight: bold"><%=userType%></b>&nbsp;
                            </TD>
                            <TD class="td">
                                <div align="<%=divAlign%>">
                                    <SELECT id="isManager" name="isManager" style="font-size: 14px;">
                                        <OPTION value="1" <%if(user.getAttribute("userType")!=null && !user.getAttribute("userType").equals("") && user.getAttribute("userType").equals("1")){%>selected<%}%>><%=sMgr%></OPTION>
                                        <OPTION value="0" <%if(user.getAttribute("userType")!=null && !user.getAttribute("userType").equals("") && user.getAttribute("userType").equals("0")){%>selected<%}%>><%=sEmp%></OPTION>
                                    </SELECT></div>
                            </TD>
                        </TR>
                </TABLE>
                <BR><BR>
                <input type="hidden" name="rows" id="rows" value="<%=l%>">
                <INPUT TYPE='HIDDEN' name='userId' value="<%=user.getAttribute("userId")%>" > 
                
                    
                <BR>
                <BR><BR>
                
            </fieldset>
        </FORM>
    </BODY>
</HTML>     
