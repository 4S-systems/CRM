
<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,com.silkworm.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<%
MetaDataMgr metaMgr = MetaDataMgr.getInstance();
String context = metaMgr.getContext();


String status = (String) request.getAttribute("status");


GroupMgr groupMgr = GroupMgr.getInstance();
TradeMgr tradeMgr = TradeMgr.getInstance();
GrantsMgr grantsMgr = GrantsMgr.getInstance();

Vector groups = groupMgr.getCashedTable();

Vector trades = tradeMgr.getCashedTable();

Vector grants = grantsMgr.getCashedTable();


int l = groups.size();
int tradesize = trades.size();
ArrayList sites=new ArrayList();
sites=(ArrayList)request.getAttribute("sites");
WebBusinessObject wbo = null;
TouristGuide tGuide = new TouristGuide("/com/silkworm/international/BasicForms");
String stat= (String) request.getSession().getAttribute("currentMode");
String align=null;
String dir=null;
String style=null;
String lang,langCode;

String saving_status;
String sTitle,title_2;
String sUserName,sUserDesc;
String cancel_button_label;
String fStatus;
String sStatus;
String save_button_label, sPadding, sMenu, sSelect, sPassword, sEmail, sGroup, sTrade,site;
String isDefault,sGrantUser,sSelectAll,filterQuery;
if(stat.equals("En")){
    
    saving_status="Saving status";
    align="center";
    dir="LTR";
    style="text-align:left";
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
    
    sUserName="User Name";
    sUserDesc="User Description";
    sTitle="New User";
    title_2="All information are needed";
    cancel_button_label="Cancel";
    save_button_label="Save";
    langCode="Ar";
    sPadding = "left";
    sMenu = "Menu";
    sSelect = "Select";
    sPassword = "Password";
    sEmail = "Email Address";
    sGroup = "Group";
    sTrade = "Trade";
    sStatus="User Created Successfully";
    fStatus="Fail To Create Group";
    site="Site";
    isDefault = "Is Default";
    sGrantUser = "Grants user";
    sSelectAll = "All";
    filterQuery="Search by";

}else{
    
    saving_status="&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
    align="center";
    dir="RTL";
    style="text-align:Right";
    lang="English";
    
    
    
    sUserName="&#1575;&#1587;&#1605; &#1575;&#1604;&#1605;&#1587;&#1578;&#1582;&#1583;&#1605;";
    sUserDesc="&#1608;&#1589;&#1601; &#1575;&#1604;&#1605;&#1580;&#1605;&#1608;&#1593;&#1577;";
    sTitle="&#1605;&#1587;&#1578;&#1582;&#1583;&#1605; &#1580;&#1583;&#1610;&#1583;";
    title_2="&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
    cancel_button_label="&#1573;&#1606;&#1607;&#1575;&#1569;";
    save_button_label="&#1578;&#1587;&#1580;&#1610;&#1604;";
    langCode="En";
    sPadding = "right";
    sMenu = "&#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577;";
    sSelect = "&#1575;&#1582;&#1578;&#1575;&#1585;";
    sPassword = "&#1603;&#1604;&#1605;&#1577; &#1575;&#1604;&#1605;&#1585;&#1608;&#1585;";
    sEmail = "&#1575;&#1604;&#1576;&#1585;&#1610;&#1583; &#1575;&#1604;&#1573;&#1604;&#1603;&#1578;&#1585;&#1608;&#1606;&#1610;";
    sGroup = "&#1605;&#1580;&#1605;&#1608;&#1593;&#1577;";
    sTrade = "&#1575;&#1604;&#1573;&#1583;&#1575;&#1585;&#1577; &#1575;&#1604;&#1601;&#1606;&#1610;&#1577;";
    fStatus="&#1604;&#1600;&#1605; &#1610;&#1600;&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604;";
    sStatus="&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604; &#1576;&#1600;&#1606;&#1600;&#1580;&#1600;&#1575;&#1581;";
    site="&#1575;&#1604;&#1605;&#1608;&#1602;&#1593;";
    isDefault = "&#1573;&#1601;&#1578;&#1585;&#1575;&#1590;&#1609;";
    sGrantUser = "&#1589;&#1604;&#1575;&#1581;&#1610;&#1575;&#1578; &#1575;&#1604;&#1605;&#1587;&#1578;&#1582;&#1583;&#1605;";
    sSelectAll ="&#1575;&#1604;&#1603;&#1604;";
    filterQuery="&#1575;&#1604;&#1576;&#1581;&#1579; &#1576;&#1608;&#1575;&#1587;&#1591;&#1577;";
}


List filterList=(ArrayList) request.getAttribute("filterList");

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
        {
            var checked=false;
            var total = document.getElementById('total').value;
            for (i=0;i<total;i++){
                if (document.getElementById('userTrades'+i).checked  == true) {
                    checked=true;
                }
            }

            if (!validateData("req", this.USERS_FORM.userName, "Please, enter User Name.")) {
                this.USERS_FORM.userName.focus();
            } else if (!validateData("req", this.USERS_FORM.password, "Please, enter Password.")) {
                this.USERS_FORM.password.focus();
            } else if (!validateData("email", this.USERS_FORM.email, "Please, enter a valid Email.")) {  //!validateData("req", this.USERS_FORM.email, "Please, enter Email.") ||
                this.USERS_FORM.email.focus();
            } else if (checked==false) {
                alert ("You must select a management ");
            } else {
                 if (checkGroup() == true) {
                    if (checkRadioDefault() == true) {
                        if(checkGrant() == true){


                document.USERS_FORM.action = "<%=context%>/UsersServlet?op=SaveUser";
                document.USERS_FORM.submit();
                }else {
                        alert ("Select default grant for user.");
                }
                }else {
                        alert ("Select default group for user.");
                    }
                } else {
                        alert ("Select at least one group for user");
                }
            }
        }
        
        function cancelForm()
        {    
            document.USERS_FORM.action = "main.jsp";
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
                <tr>
                    <table align="<%=align%>" dir=<%=dir%>>
                        <tr>                    
                            <td class="td">
                                <font size=4 color="black"><%=sStatus%></font> 
                            </td>                    
                    </tr> </table>
                </tr>
                <%
                }else{%>
                <tr>
                    <table align="<%=align%>" dir=<%=dir%>>
                        <tr>                    
                            <td class="td">
                                <font size=4 color="red" ><%=fStatus%></font> 
                            </td>                    
                    </tr> </table>
                </tr>
                <%}
                }
                %>
                <br>
                <TABLE CELLPADDING="0" CELLSPACING="0" BORDER="0" ALIGN="CENTER" DIR="<%=dir%>">
                    <TR>
                        <TD class='td' STYLE="<%=style%>">
                            <LABEL FOR="str_Function_Name">
                                <p><b><%=sUserName%></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD class='td' STYLE="<%=style%>">
                            <input type="TEXT" name="userName" ID="userName" size="33" value="" maxlength="255">
                        </TD>
                    </TR>
                    
                    <TR>
                        <TD class='td' STYLE="<%=style%>">
                            <LABEL FOR="str_Function_Desc">
                                <p><b><%=sPassword%></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD class='td' STYLE="<%=style%>">
                            <input type="PASSWORD" name="password" ID="password" size="35" value="" maxlength="255">
                        </TD>
                    </TR>
                    
                    <TR>
                        <TD class='td' STYLE="<%=style%>">
                            <LABEL FOR="str_Function_Name">
                                <p><b><%=sEmail%></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD class='td' STYLE="<%=style%>">
                            <input type="TEXT" name="email" ID="email" size="33" value="" maxlength="255">
                        </TD>
                    </TR>
                    
                    <TR>
                        <TD class='td' STYLE="<%=style%>">
                            <p><b><%=site%></b>&nbsp;
                        </TD>
                        <TD class='td' STYLE="<%=style%>">
                            <select name="site" id="site" dir="<%=dir%>" style="width:233">
                                <%
                                WebBusinessObject sWbo=new WebBusinessObject();
                                for(int i=0;i<sites.size();i++){
                                    sWbo=new WebBusinessObject();
                                    sWbo=(WebBusinessObject)sites.get(i);
                                %>
                                <option value="<%=(String)sWbo.getAttribute("projectID")%>"><%=(String)sWbo.getAttribute("projectName")%>
                                <%}%>
                            </select>
                        </TD>
                    </TR>
                    <TR>
                        <TD class='td' STYLE="<%=style%>">
                            <p><b><%=filterQuery%></b>&nbsp;
                        </TD>
                        <TD class='td' STYLE="<%=style%>">
                            <select name="searchBy" id="searchBy" dir="<%=dir%>" style="width:233">
                                
                                <%
                                List queryList = new ArrayList();
                                for(int i=0;i<filterList.size();i++){
                                    
                                    queryList=(ArrayList)filterList.get(i);
                                %>
                               <%if(stat.equals("En")){ %>
                                <option value="<%=queryList.get(3).toString()%>"><%=queryList.get(2).toString()%>
                               <%}else{%>
                                <option value="<%=queryList.get(3).toString()%>"><%=queryList.get(1).toString()%>
                               <%}%>
                                <%}%>
                                <% if(stat.equals("En")){ %>
                                <option value="all"><%=sSelectAll%>
                                <% }else{ %>
                                <option value="all"><%=sSelectAll%>
                                <% } %>
                            </select>
                        </TD>
                    </TR>
                </TABLE>
                
                <BR>
                
                <TABLE WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;" ALIGN="center" DIR="<%=dir%>">
                    <TR CLASS="head" STYLE="background:#9B9B00;">
                        <TD VALIGN="BOTTOM" STYLE="border-top-WIDTH:0;color:white;" WIDTH="40">
                            <B>
                                &nbsp;<%=isDefault%>&nbsp;
                            </B>
                        </TD>
                        <TD nowrap CLASS="firstname" WIDTH="570" STYLE="border-top-WIDTH:0; font-size:12;color:white;">
                            <%=sGroup%>
                        </TD>
                        <TD VALIGN="BOTTOM" STYLE="border-top-WIDTH:0;color:white;" WIDTH="30">
                            <B>
                                &nbsp;<%=sSelect%>&nbsp;
                            </B>
                        </TD>
                    </TR>       
                    <input type="hidden" name="rows" id="rows" value="<%=l%>">
                    <%
                    for(int i = 0;i<l;i++) {
                                    wbo = (WebBusinessObject) groups.get(i);
                    %>
                    <TR>
                     <TD  CLASS="cell">
                            <INPUT TYPE="RADIO" NAME="isDefault" ID="isDefault<%=i%>" value="<%=wbo.getAttribute("groupID")%>" <% if(i==0){%>CHECKED <%}%> >
                            </TD>
                        <TD  CLASS="cell" STYLE="padding-left:40;text-align:left;">
                            <DIV ID="links">
                                <A HREF="alert('');">
                                    <%=wbo.getAttribute("groupName")%>
                                    <SPAN>
                                    </SPAN>
                                </A>
                            </DIV>
                        </TD>
                        <TD  CLASS="cell" style="border-left">
                            <INPUT TYPE="CHECKBOX" NAME="userGroups" ONCLICK="checkDefault(<%=i%>)" value ="<%=wbo.getAttribute("groupName")%>" ID="group<%=i%>" CHECKED >
                            </TD>
                           
                    </TR>
                    <%
                    }
                    
                    %>
                </TABLE>     
                <BR>
                     <TABLE WIDTH="500" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;" ALIGN="center" DIR="<%=dir%>">
                    <TR CLASS="head" STYLE="background:#9B9B00;">
                        <TD nowrap CLASS="firstname" WIDTH="500" STYLE="border-top-WIDTH:0; font-size:12;color:white;">
                            <%=sGrantUser%>
                        </TD>
                        <TD VALIGN="BOTTOM" STYLE="border-top-WIDTH:0;color:white;" WIDTH="30">
                            <B>
                                &nbsp;<%=sSelect%>&nbsp;<INPUT TYPE="CHECKBOX" NAME="allGrant" value ="" ID="allGrant" onclick="javascript:checkAll(this);" >
                            </B>
                        </TD>
                    </TR>

                    <%
                    for(int i = 0;i<grants.size();i++) {
                                    wbo = (WebBusinessObject) grants.get(i);
                    %>
                    <TR>

                        <TD  CLASS="cell" STYLE="padding-left:40;text-align:left;">
                            <DIV ID="links">
                                <A HREF="alert('');">
                                    <%=wbo.getAttribute("grantName")%>
                                    <SPAN>
                                    </SPAN>
                                </A>
                            </DIV>
                        </TD>
                        <TD  CLASS="cell" style="border-left">
                            <INPUT TYPE="CHECKBOX" NAME="grantUser" value ="<%=wbo.getAttribute("id")%>" ID="grant[<%=i%>]" onclick="addId();"  >
                            </TD>
                            <input type="hidden" id="totalGrant" value="<%=grants.size()%>">
                    </TR>
                    <%
                    }

                    %>

                    
                </TABLE>
                    <BR>
                <TABLE WIDTH="500" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;" ALIGN="center" DIR="<%=dir%>">
                    <TR CLASS="head" STYLE="background:#9B9B00;">
                        <TD nowrap CLASS="firstname" WIDTH="500" STYLE="border-top-WIDTH:0; font-size:12;color:white;">
                            <%=sTrade%>
                        </TD>
                        <TD VALIGN="BOTTOM" STYLE="border-top-WIDTH:0;color:white;" WIDTH="30">
                            <B>
                                &nbsp;<%=sSelect%>&nbsp;
                            </B>
                        </TD>
                    </TR>       
                    
                    <%
                    for(int i = 0;i<tradesize;i++) {
                                    wbo = (WebBusinessObject) trades.get(i);
                    %>
                    <TR>

                        <TD  CLASS="cell" STYLE="padding-left:40;text-align:left;">
                            <DIV ID="links">
                                <A HREF="alert('');">
                                    <%=wbo.getAttribute("tradeName")%>
                                    <SPAN>
                                    </SPAN>
                                </A>
                            </DIV>
                        </TD>
                        <TD CLASS="cell" style="border-left">
                            <input type="radio" name="userTrades" id="userTrades<%=i%>" value ="<%=wbo.getAttribute("tradeId")%>" />
                            </TD>
                    </TR>
                    <%
                    }
                    
                    %>

                    <input type="hidden" name="total" id="total" value="<%=tradesize%>">
                </TABLE>
                            
                        
                            
               
                         
                
                <BR><BR>
            </FIELDSET>
        </FORM>
    </BODY>
</HTML>     
