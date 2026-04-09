<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,com.silkworm.db_access.*"%>
<%
MetaDataMgr metaMgr = MetaDataMgr.getInstance();
String context = metaMgr.getContext();


WebBusinessObject user = (WebBusinessObject) request.getAttribute("user");


UserGroupMgr userGroupMgr = UserGroupMgr.getInstance();
UserTradeMgr userTradeMgr = UserTradeMgr.getInstance();

GrantUserMgr grantUserMgr = GrantUserMgr.getInstance();
GrantsMgr grantsMgr = GrantsMgr.getInstance();
WebBusinessObject grantWbo = new WebBusinessObject();

Vector groups = userGroupMgr.getOnRefInteg((String)user.getAttribute("userId"));
Vector trades = userTradeMgr.getOnRefInteg((String)user.getAttribute("userId"));
Vector grants = grantUserMgr.getOnArbitraryKey((String)user.getAttribute("userId"),"key2");

int l = groups.size();
int tradesize = trades.size();

WebBusinessObject wbo = null;
WebBusinessObject userTradeWbo = userTradeMgr.getOnSingleKey1(user.getAttribute("userId").toString());

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
String save_button_label, sPadding, sMenu, sSelect, sPassword, sEmail, sGroup, sTrade,project;
String isDefault,sGrantUser,filterQuery,sSelectAll;
if(stat.equals("En")){
    
    saving_status="Saving status";
    align="center";
    dir="LTR";
    style="text-align:left";
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
    
    sUserName="User Name";
    sUserDesc="User Description";
    sTitle="View Existing User";
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
    isDefault = "Is Default";
    sGrantUser = "Grants user";
    filterQuery="Search by";
    sSelectAll = "All";
}else{
    
    saving_status="&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
    align="center";
    dir="RTL";
    style="text-align:Right";
    lang="English";
    
    
    
    sUserName="&#1575;&#1587;&#1605; &#1575;&#1604;&#1605;&#1587;&#1578;&#1582;&#1583;&#1605;";
    sUserDesc="&#1608;&#1589;&#1601; &#1575;&#1604;&#1605;&#1580;&#1605;&#1608;&#1593;&#1577;";
    sTitle="&#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1605;&#1587;&#1578;&#1582;&#1583;&#1605;";
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
    isDefault = "&#1573;&#1601;&#1578;&#1585;&#1575;&#1590;&#1609;";
    sGrantUser = "&#1589;&#1604;&#1575;&#1581;&#1610;&#1575;&#1578; &#1575;&#1604;&#1605;&#1587;&#1578;&#1582;&#1583;&#1605;";
    filterQuery="&#1575;&#1604;&#1576;&#1581;&#1579; &#1576;&#1608;&#1575;&#1587;&#1591;&#1577;";
    sSelectAll ="&#1575;&#1604;&#1603;&#1604;";
}
Vector userGroupVec = new Vector();
WebBusinessObject userGroupWbo = new WebBusinessObject();
List filterList=(ArrayList) request.getAttribute("filterList");
boolean viewIsDefualt = (Boolean) request.getAttribute("viewIsDefualt");
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
        document.USERS_FORM.action = "<%=context%>/UsersServlet?op=SaveUser";
        document.USERS_FORM.submit();  
        }
        
        function cancelForm()
        {    
        document.USERS_FORM.action = "<%=context%>/ListerServlet?op=ListUsers";
        document.USERS_FORM.submit();  
        }

    </SCRIPT>
    
    <BODY>
        <FORM NAME="USERS_FORM" METHOD="POST">
            <DIV align="left" STYLE="color:blue;">
                <input type="button"  value="<%=lang%>"  onclick="reloadAE('<%=langCode%>')" class="button">
                <button    onclick="cancelForm()" class="button"><%=cancel_button_label%> <IMG VALIGN="BOTTOM"  HEIGHT="15" SRC="images/leftarrow.gif"></button>
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
                <BR>
                <TABLE CELLPADDING="0" CELLSPACING="0" BORDER="0" ALIGN="CENTER" DIR="<%=dir%>">
                    <TR>
                        <TD class='td'>
                            &nbsp;
                        </TD>
                    </TR>
                    <TR>
                        <TD class='td'>
                            <LABEL FOR="str_Function_Name">
                                <p><b><%=sUserName%>:</b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD class='td'>
                            <input disabled type="TEXT" name="userName" ID="userName" size="33" value="<%=user.getAttribute("userName")%>" maxlength="255">
                        </TD>
                    </TR>
                    
                    <TR>
                        <TD class='td'>
                            <LABEL FOR="str_Function_Desc">
                                <p><b><%=sPassword%>:</b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD class='td'>
                            <input disabled type="TEXT" name="password" ID="password" size="33" value="<%=user.getAttribute("password")%>" maxlength="255">
                        </TD>
                    </TR>
                    
                    <TR>
                        <TD class='td'>
                            <LABEL FOR="str_Function_Name">
                                <p><b><%=sEmail%>:</b>&nbsp;
                            </LABEL>
                        </TD>
                        <%
                            if(user.getAttribute("email")!=null && user.getAttribute("email").equals("")) {
                        %>
                        <TD class='td'>
                            <% if(user.getAttribute("email") != null && !user.getAttribute("email").equals("")){ %>
                            <input disabled type="TEXT" name="email" ID="email" size="33" value="<%=user.getAttribute("email")%>" maxlength="255">
                           <% }else { %>
                           <input disabled type="TEXT" name="email" ID="email" size="33" value="" maxlength="255">
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
                            <LABEL FOR="str_Function_Name">
                                <p><b><%=project%>:</b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD class='td'>
                            <input disabled type="TEXT" name="projectName" ID="projectName" size="33" value="<%=user.getAttribute("site")%>" maxlength="255">
                        </TD>
                    </TR>
                    <TR>
                        <TD class='td' STYLE="<%=style%>">
                            <p><b><%=filterQuery%></b>&nbsp;
                        </TD>
                        <TD class='td' STYLE="<%=style%>">
                           
                                <%
                                List queryList = new ArrayList();
                                for(int i=0;i<filterList.size();i++){

                                    queryList=(ArrayList)filterList.get(i);
                                %>
                                <% if(queryList.get(3).toString().equals(user.getAttribute("searchBy"))){ %>
                                    <%if(stat.equals("En")){ %>
                                        <input name="searchBy" id="searchBy" size="33" value="<%=queryList.get(2).toString()%>">
                                    <%}else{%>
                                        <input name="searchBy" id="searchBy" size="33" value="<%=queryList.get(1).toString()%>">
                                    <%}%>
                                <% } %>
                                <% } %>
                                 <% if(user.getAttribute("searchBy").equals("all")){ %>
                                    <%if(stat.equals("En")){ %>
                                        <input name="searchBy" id="searchBy" size="33" value="<%=sSelectAll%>">
                                    <%}else{%>
                                        <input name="searchBy" id="searchBy" size="33" value="<%=sSelectAll%>">
                                    <%}%>
                                <% } %>
                            </select>
                        </TD>
                    </TR>
                </TABLE>
                <BR><BR>
                
                <%if(viewIsDefualt){%>
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
                    
                    <%
                    for(int i = 0;i<l;i++) {

                    wbo = (WebBusinessObject) groups.get(i);

                    %>
                    <TR>
                       <%
                        userGroupVec = userGroupMgr.getOnArbitraryDoubleKey(wbo.getAttribute("groupID").toString(), "key", user.getAttribute("userId").toString(), "refintegkey");
                        if(userGroupVec.size()>0){
                            userGroupWbo = (WebBusinessObject) userGroupVec.get(0);
                        %>
                        <%if(userGroupWbo.getAttribute("isDefault").toString().equals("1")){
                            %>
                        <TD  CLASS="cell">
                            <INPUT TYPE="RADIO" NAME="isDefault" ID="isDefault<%=i%>" value="<%=wbo.getAttribute("groupID")%>" CHECKED disabled>
                            </TD>
                         <%} else { %>
                          <TD  CLASS="cell">
                            <INPUT TYPE="RADIO" NAME="isDefault" ID="isDefault<%=i%>" value="<%=wbo.getAttribute("groupID")%>" disabled />
                            </TD>
                         <% } %>
                        <TD  CLASS="cell" STYLE="padding-left:40;text-align:left;">
                            <DIV ID="links">
                                <A HREF="alert('');">
                                    <%=wbo.getAttribute("groupName")%>
                                    <SPAN>
                                    </SPAN>
                                </A>
                            </DIV>
                        </TD>

                       <TD  CLASS="cell">
                            <INPUT TYPE="CHECKBOX" NAME="userGroups" ONCLICK="checkDefault(<%=i%>)" value ="<%=wbo.getAttribute("groupName")%>" ID="group<%=i%>" checked disabled>
                            </TD>

                        <% } %>
                    </TR>
                    <%
                    }
                    
                    %>
                </TABLE>
                <%}%>
                <BR>
                    <% if (grants.size()>0){%>
                     <TABLE WIDTH="500" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;" ALIGN="center" DIR="<%=dir%>">
                    <TR CLASS="head" STYLE="background:#9B9B00;">
                        <TD nowrap CLASS="firstname" WIDTH="500" STYLE="border-top-WIDTH:0; font-size:12;color:white;">
                            <%=sGrantUser%>
                        </TD>
                        <TD VALIGN="BOTTOM" STYLE="border-top-WIDTH:0;color:white;" WIDTH="30">
                            <B>
                                &nbsp;&nbsp;
                            </B>
                        </TD>
                    </TR>

                    <%
                    for(int i = 0;i<grants.size();i++) {
                                 wbo = (WebBusinessObject) grants.get(i);
                                 grantWbo =(WebBusinessObject) grantsMgr.getOnSingleKey(wbo.getAttribute("grantId").toString());
                    %>
                    <TR>

                        <TD  CLASS="cell" STYLE="padding-left:40;text-align:left;">
                            <DIV ID="links">
                                <A HREF="alert('');">
                                    <%=grantWbo.getAttribute("grantName")%>
                                    <SPAN>
                                    </SPAN>
                                </A>
                            </DIV>
                        </TD>
                        <TD  CLASS="cell" style="border-left:black">
                            <INPUT TYPE="CHECKBOX" NAME="grantUser" value ="" CHECKED disabled>
                            </TD>
                            
                    </TR>
                    <%
                    }

                    %>


                </TABLE>
                <% } %>
                <BR>
                <TABLE WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;" ALIGN="center" DIR="<%=dir%>">
                    <TR CLASS="head" STYLE="background:#9B9B00;">
                        <TD nowrap CLASS="firstname" WIDTH="570" STYLE="border-top-WIDTH:0; font-size:12;color:white;">
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
                        if(wbo.getAttribute("tradeId").toString().equalsIgnoreCase(userTradeWbo.getAttribute("tradeId").toString())) {
                    %>
                    <TR>
                        <TD  CLASS="cell" STYLE="padding-left:40;text-align:left;">
                            <DIV ID="links">
                                <A HREF="alert('');">
                                    <%=wbo.getAttribute("tradeName")%>
                                </A>
                            </DIV>
                        </TD>
                        <TD  CLASS="cell" style="border-left:black">
                            <input disabled type="radio" name="userTrades" id="userTrades" checked value="<%=wbo.getAttribute("tradeName")%>" />
                        </TD>
                    </TR>
                    <% } else { %>
                     <TR>
                        <TD  CLASS="cell" STYLE="padding-left:40;text-align:left;">
                            <DIV ID="links">
                                <A HREF="alert('');">
                                    <%=wbo.getAttribute("tradeName")%>                                    
                                </A>
                            </DIV>
                        </TD>
                        <TD  CLASS="cell" style="border-left:black">
                            <input disabled type="radio" name="userTrades" id="userTrades" value="<%=wbo.getAttribute("tradeName")%>" />
                        </TD>
                    </TR>
                    <% }
                     }
                    %>
                </TABLE>
                <BR><BR>
            </FIELDSET>
        </FORM>
    </BODY>
</HTML>     
