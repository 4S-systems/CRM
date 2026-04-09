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
String save_button_label, sPadding, sMenu, sSelect, sPassword, sEmail, sGroup, sTrade,project;

String isDefault,sGrantUser,sSelectAll,filterQuery,sFullName,sConfirmPassword,changePassword;

if(stat.equals("En")){
    
    align="center";
    dir="LTR";
    style="text-align:left";
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
    
    sUserName="User Name";
    sUserDesc="User Description";
    sTitle="Update User";
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
    sConfirmPassword="Confirm Password";
    changePassword="Change Password";
}else{
    
    align="center";
    dir="RTL";
    style="text-align:Right";
    lang="English";
    
    
    
    sUserName="&#1575;&#1587;&#1605; &#1575;&#1604;&#1605;&#1587;&#1578;&#1582;&#1583;&#1605;";
    sUserDesc="&#1608;&#1589;&#1601; &#1575;&#1604;&#1605;&#1580;&#1605;&#1608;&#1593;&#1577;";
    sTitle="&#1578;&#1581;&#1583;&#1610;&#1579; &#1605;&#1587;&#1578;&#1582;&#1583;&#1605;";
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
    sConfirmPassword="تأكيد كلمة المرور";
    changePassword="تغيير كلمة المرور";
}
UserGroupMgr  userGroupMgr = UserGroupMgr.getInstance();
Vector userGroupVec = new Vector();
WebBusinessObject userGroupWbo = new WebBusinessObject();
Vector grantVec = new Vector();
String userId= (String) request.getAttribute("userId");

%>

<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>Document Viewer - add new user</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        
    </HEAD>
    
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

        function submitForm()
        {   
            var  pass = document.getElementById("password").value;
            var  cPass = document.getElementById("cpassword").value;
            if (pass != cPass) { 
                alert("password not matched by confirm password.");
                document.getElementById("password").value="";
                document.getElementById("cpassword").value="";
                document.USERS_FORM.password.focus();
                return false;
            } else {
                document.USERS_FORM.action = "<%=context%>/UsersServlet?op=savePassword";
                document.USERS_FORM.submit();           
            }
        }
        function cancelForm()
        {    
        document.USERS_FORM.action = "<%=context%>/main.jsp";
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
        <FORM NAME="USERS_FORM" METHOD="POST">
            <DIV align="left" STYLE="color:blue;">
                <button    onclick="cancelForm()" class="button"><%=cancel_button_label%> <IMG VALIGN="BOTTOM"  HEIGHT="15" SRC="images/leftarrow.gif"></button>
                <button  onclick="JavaScript:  submitForm();" class="button"><%=save_button_label%><IMG HEIGHT="15" SRC="images/save.gif"></button>
            </DIV>
            <fieldset class="set" align="center">
                <legend align="center">
                    <table align="<%=align%>" dir=<%=dir%>>
                        <tr>
                            
                            <td class="td">
                                <font color="blue" size="4"> <%=changePassword%></font>
                                
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
                </center>
                <br>
                <%}}
                
                %>
                <TABLE CELLPADDING="0" CELLSPACING="0" BORDER="0" ALIGN="CENTER" DIR="<%=dir%>">
                    <TR>
                        <TD class='td'>
                            <LABEL FOR="str_Function_Desc">
                                <p><b><%=sPassword%>:</b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD class='td'>
                            <input type="PASSWORD" name="password" ID="password" size="33" value="" maxlength="255">
                        </TD>
                    </TR>
                    
                    <TR>
                        <TD class='td'>
                            <LABEL FOR="str_Function_Desc">
                                <p><b><%=sConfirmPassword%>:</b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD class='td'>
                            <input type="PASSWORD" name="cpassword" ID="cpassword" size="33" value="" maxlength="255">
                        </TD>
                    </TR>
                    
                </TABLE>
                <BR><BR>
                <input type="hidden" name="rows" id="rows" value="<%=l%>">
                <INPUT TYPE='HIDDEN' name='userId' value="<%=user.getAttribute("userId")%>" > 
                <INPUT TYPE='HIDDEN' name='userName' value="<%=user.getAttribute("userName")%>" > 
                    
                <BR>
                <BR><BR>
                
            </fieldset>
        </FORM>
    </BODY>
</HTML>     
