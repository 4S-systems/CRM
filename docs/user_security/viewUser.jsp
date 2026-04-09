<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,com.silkworm.db_access.*"%>
<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();

    /*WebBusinessObject user = (WebBusinessObject) request.getAttribute("user");
    WebBusinessObject trade = (WebBusinessObject) request.getAttribute("trade");
    Vector<WebBusinessObject> groups = (Vector<WebBusinessObject>) request.getAttribute("groups");
    Vector<WebBusinessObject> grants = (Vector<WebBusinessObject>) request.getAttribute("grants");
    Vector<WebBusinessObject> projects = (Vector<WebBusinessObject>) request.getAttribute("projects");
    Vector<WebBusinessObject> stores = (Vector<WebBusinessObject>) request.getAttribute("stores");

    String isDefaultGroup = (String) request.getAttribute("isDefaultGroup");
    String isDefaultProject = (String) request.getAttribute("isDefaultProject");
*/
    //String userId = (String) user.getAttribute("userId");
    String index = (String) request.getAttribute("index");
    String numberOfUsers = (String) request.getAttribute("numberOfUsers");

    String stat= (String) request.getSession().getAttribute("currentMode");
    String storeName = "storeName" + stat;

    String nextTitle = "Next";
    String previousTitle = "Previous";
    String lastTitle = "Last";
    String firstTitle = "First";
    String nextValue = "next";
    String prevValue = "prev";
    String lastValue = numberOfUsers;
    String firstValue = "1";

    String dir=null;
    String style=null;
    String lang,langCode;
    String sTitle, sUserName;
    String cancel, stStore, isNotSelec;
    String divAlign, basicData, name, sPassword, sEmail, sGroup, sTrade, sites;
    String isDefault, sGrantUser, current, from;
    if(stat.equals("En")){
        dir="LTR";
        divAlign = "left";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        sUserName="User Name";
        sTitle="View Existing User";
        cancel="Back To List";
        langCode="Ar";
        sPassword = "Password";
        sEmail = "Email Address";
        sGroup = "Groups";
        sTrade = "Trade";
        sites = "Branches";
        isDefault = "Is Default";
        sGrantUser = "Grants";
        basicData = "Basic Data";
        name = "&#1575;&#1604;&#1571;&#1587;&#1605;";
        stStore = "Stores";
        isNotSelec = "Is not Selection yet";
        current = "Current";
        from = "From";
    } else {
        dir="RTL";
        divAlign = "right";
        style="text-align:Right";
        lang="English";
        langCode="En";
        sUserName="&#1575;&#1587;&#1605; &#1575;&#1604;&#1605;&#1587;&#1578;&#1582;&#1583;&#1605;";
        sTitle="&#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1575;&#1604;&#1605;&#1587;&#1578;&#1582;&#1583;&#1605;";
        cancel="&#1593;&#1608;&#1583;&#1577;";
        sPassword = "&#1603;&#1604;&#1605;&#1577; &#1575;&#1604;&#1605;&#1585;&#1608;&#1585;";
        sEmail = "&#1575;&#1604;&#1576;&#1585;&#1610;&#1583; &#1575;&#1604;&#1573;&#1604;&#1603;&#1578;&#1585;&#1608;&#1606;&#1610;";
        sTrade = "&#1575;&#1604;&#1573;&#1583;&#1575;&#1585;&#1577; &#1575;&#1604;&#1601;&#1606;&#1610;&#1577;";
        sites = "&#1575;&#1604;&#1601;&#1585;&#1608;&#1593;";
        isDefault = "&#1573;&#1601;&#1578;&#1585;&#1575;&#1590;&#1609;";
        sGrantUser = "&#1575;&#1604;&#1589;&#1604;&#1575;&#1581;&#1610;&#1575;&#1578;";
        basicData = "&#1575;&#1604;&#1576;&#1610;&#1575;&#1606;&#1575;&#1578; &#1575;&#1604;&#1571;&#1587;&#1575;&#1587;&#1610;&#1577;";
        sGroup = "&#1575;&#1604;&#1605;&#1580;&#1605;&#1608;&#1593;&#1575;&#1578;";
        name = "&#1575;&#1604;&#1571;&#1587;&#1605;";
        stStore = "&#1575;&#1604;&#1605;&#1582;&#1575;&#1586;&#1606;";
        isNotSelec = "&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1578;&#1581;&#1583;&#1610;&#1583; &#1576;&#1593;&#1583;";
        current = "&#1575;&#1604;&#1581;&#1600;&#1600;&#1600;&#1575;&#1604;&#1609;";
        from = "&#1605;&#1606;";
        nextTitle = "&#1575;&#1604;&#1587;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1575;&#1576;&#1602;";
        previousTitle = "&#1575;&#1604;&#1578;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1575;&#1604;&#1609;";
        lastTitle = "&#1575;&#1604;&#1571;&#1608;&#1604;";
        firstTitle = "&#1575;&#1604;&#1571;&#1582;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1610;&#1585;";
        nextValue = "prev";
        prevValue = "next";
        lastValue = "1";
        firstValue = numberOfUsers;
    }
%>

<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Document Viewer - add new user</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <script src='js/jquery-1.2.6.min.js' type='text/javascript'></script>
        <script src='ChangeLang.js' type='text/javascript'></script>
        <script src='js/common.js' type='text/javascript'></script>
    </HEAD>

    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

        function cancelForm() {
            document.USERS_FORM.action = "<%=context%>/ListerServlet?op=ListUsers";
            document.USERS_FORM.submit();
        }

        function directTo(directType, index) {
            document.USERS_FORM.action = "<%=context%>/UsersServlet?op=directTo&userId=<%--=userId--%>&index=" + index + "&numberOfUsers=<%=numberOfUsers%>&directType=" + directType;
            document.USERS_FORM.submit();
        }
        $(document).ready(function(){
            selectUser('<%=index%>', '<%=index%>', '<%=numberOfUsers%>');
            getTitlePagination01(<%=stat%>);
        });
    </SCRIPT>

    <BODY>
        <FORM action=""  NAME="USERS_FORM" METHOD="POST">
            <DIV align="left" STYLE="color:blue; padding-left: 5%">
                <input type="button"  value="<%=lang%>"  onclick="reloadAE('<%=langCode%>')" class="button" style="width: 15%">
                &ensp;
                <button onclick="cancelForm()" class="button" style="width: 15%"><%=cancel%></button>

                <a onclick="JavaScript: selectUser('last', '<%=lastValue%>', '<%=numberOfUsers%>');" title="<%=lastTitle%>" class="pagingStyle" style="background-image: url('images/bg_paging.png'); cursor: pointer; margin-left: 30%" onmouseover="this.style.backgroundImage = 'url(images/bg_paging_highlit.png)'" onmouseout="this.style.backgroundImage = 'url(images/bg_paging.png)'"><b style="font-size: 15px; color: black"><<</b></a>
                <a onclick="JavaScript: selectUser('<%=nextValue%>', getIndex(), '<%=numberOfUsers%>');" title="<%=nextTitle%>" class="pagingStyle" style="background-image: url('images/bg_paging.png'); cursor: pointer" onmouseover="this.style.backgroundImage = 'url(images/bg_paging_highlit.png)'" onmouseout="this.style.backgroundImage = 'url(images/bg_paging.png)'"><b style="font-size: 15px; color: black"><</b></a>
                <a onclick="JavaScript: selectUser('<%=prevValue%>', getIndex(), '<%=numberOfUsers%>');" title="<%=previousTitle%>" class="pagingStyle" style="background-image: url('images/bg_paging.png'); cursor: pointer" onmouseover="this.style.backgroundImage = 'url(images/bg_paging_highlit.png)'" onmouseout="this.style.backgroundImage = 'url(images/bg_paging.png)'"><b style="font-size: 15px; color: black">></b></a>
                <a onclick="JavaScript: selectUser('first', '<%=firstValue%>', '<%=numberOfUsers%>');" title="<%=firstTitle%>" class="pagingStyle" style="background-image: url('images/bg_paging.png'); cursor: pointer" onmouseover="this.style.backgroundImage = 'url(images/bg_paging_highlit.png)'" onmouseout="this.style.backgroundImage = 'url(images/bg_paging.png)'"><b style="font-size: 15px; color: black">>></b></a>
                <b class="excelentCell" style="width: 16.5%; text-align: center; font-size: 14px" id="titlePagination<%=stat%>" title=""><font color="black"><%=current%></font><font color="red">&ensp;:&ensp;</font><%=index%><font color="red">&ensp;<%=from%>&ensp;</font><%=numberOfUsers%></b>
            </DIV>
            <br>
            <center>
                <fieldset class="set" style="width:90%;border-color: #006699;">
                    
                    <br>
                    <div align="<%=divAlign%>" style="margin-<%=divAlign%>: 15%;color: blue">
                        <p dir="<%=dir%>" align="divAlign" style="background-color: #E6E6FA;width:20%;font-weight: bold;font-size: 16px;padding-top: 2px;padding-bottom: 2px;padding-left: 5px;padding-right: 5px"><b><%=basicData%></b></p>
                    </div>
                    <TABLE class="backgroundTable" width="70%" CELLPADDING="0" CELLSPACING="8" ALIGN="CENTER" DIR="<%=dir%>">
                        <TR>
                            <TD class="backgroundHeader" style="<%=style%>" width="35%">
                                <p><b style="margin-left: 5px;margin-left: 5px;font-weight: bold"><%=sUserName%></b></p>
                            </TD>
                            <TD style="border-width: 0px" width="65%">
                                <input type="TEXT" name="userName" ID="userName" readonly size="33" value="" maxlength="255" style="width:100%;color: black; font-weight: bold; font-size: 12px">
                            </TD>
                        </TR>

                        <TR>
                            <TD class="backgroundHeader" style="<%=style%>" width="35%">
                                <p><b style="margin-left: 5px;margin-left: 5px;font-weight: bold"><%=sPassword%></b></p>
                            </TD>
                            <TD style="border-width: 0px" width="65%">
                                <input type="text" name="password" ID="password" readonly size="35" value="" maxlength="255" style="width:100%;color: black; font-weight: bold; font-size: 12px">
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
                                <p><b style="margin-left: 5px;margin-left: 5px;font-weight: bold"><%=sTrade%></b>&nbsp;
                            </TD>
                            <TD style="border-width: 0px" width="65%">
                                <input type="text" name="trade" ID="trade" readonly size="35" value="" maxlength="255" style="width:100%;color: black; font-weight: bold; font-size: 12px">
                            </TD>
                        </TR>
                    </TABLE>
                    <BR>
                    <%--<div align="<%=divAlign%>" style="margin-<%=divAlign%>: 15%;color: blue">
                        <p dir="<%=dir%>" align="divAlign" style="background-color: #E6E6FA;width:20%;font-weight: bold;font-size: 16px;padding-top: 2px;padding-bottom: 2px;padding-left: 5px;padding-right: 5px"><b><%=sGroup%></b></p>
                    </div>

                    <TABLE CLASS="blueBorder" style="border-color: silver;" WIDTH="70%" CELLPADDING="0" CELLSPACING="0" ALIGN="CENTER" DIR="<%=dir%>">
                        <TR style="cursor: pointer;" class="backgroundHeader" onmousemove="this.className='selectedRow'" onmouseout="this.className='backgroundHeader'">
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
                        for(WebBusinessObject group : groups) {
                            booleanIsDefault = isDefaultGroup != null && isDefaultGroup.equalsIgnoreCase((String) group.getAttribute("groupID"));
                            if(booleanIsDefault) {
                                defaultRow = "defaultRow";
                            } else {
                                defaultRow = "";
                            }
                        %>
                        <TR class="<%=defaultRow%>" style="cursor: pointer" onmousemove="this.className='selectedRow'" onmouseout="this.className='<%=defaultRow%>'">
                            <TD STYLE="text-align:center;border-top-width: 0px">
                                <% if(booleanIsDefault) { %>
                                    <img src="images/accept.png" height="15" width="16" alt="accept" />
                                <% } else { %>
                                    &ensp;
                                <% } %>
                            </TD>
                            <TD STYLE="text-align:center;border-top-width: 0px">
                                <%=group.getAttribute("groupName")%>
                            </TD>
                        </TR>
                        <% } %>
                        <% if(groups != null && groups.isEmpty()) { %>
                        <TR style="cursor: pointer" onmousemove="this.className='selectedRow'" onmouseout="this.className='<%=defaultRow%>'">
                            <TD colspan="2" STYLE="text-align:center;border-top-width: 0px; color: red">
                                <%=isNotSelec%>
                            </TD>
                        </TR>
                        <% } %>
                    </TABLE>
                    <BR>
                    <div align="<%=divAlign%>" style="margin-<%=divAlign%>: 15%;color: blue">
                        <p dir="<%=dir%>" align="divAlign" style="background-color: #E6E6FA;width:20%;font-weight: bold;font-size: 16px;padding-top: 2px;padding-bottom: 2px;padding-left: 5px;padding-right: 5px"><b><%=sites%></b></p>
                    </div>

                    <TABLE CLASS="blueBorder" style="border-color: silver;" WIDTH="70%" CELLPADDING="0" CELLSPACING="0" ALIGN="CENTER" DIR="<%=dir%>">
                        <TR style="cursor: pointer;" class="backgroundHeader" onmousemove="this.className='selectedRow'" onmouseout="this.className='backgroundHeader'">
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
                        for(WebBusinessObject project : projects) {
                            booleanIsDefault = isDefaultProject != null && isDefaultProject.equalsIgnoreCase((String) project.getAttribute("projectID"));
                            if(booleanIsDefault) {
                                defaultRow = "defaultRow";
                            } else {
                                defaultRow = "";
                            }
                        %>
                        <TR class="<%=defaultRow%>" style="cursor: pointer" onmousemove="this.className='selectedRow'" onmouseout="this.className='<%=defaultRow%>'">
                            <TD STYLE="text-align:center;border-top-width: 0px">
                                <% if(booleanIsDefault) { %>
                                    <img src="images/accept.png" height="15" width="16" alt="accept" />
                                <% } else { %>
                                    &ensp;
                                <% } %>
                            </TD>
                            <TD STYLE="text-align:center;border-top-width: 0px">
                                <%=project.getAttribute("projectName")%>
                            </TD>
                        </TR>
                        <% } %>
                        <% if(projects != null && projects.isEmpty()) { %>
                        <TR style="cursor: pointer" onmousemove="this.className='selectedRow'" onmouseout="this.className='<%=defaultRow%>'">
                            <TD colspan="2" STYLE="text-align:center;border-top-width: 0px; color: red">
                                <%=isNotSelec%>
                            </TD>
                        </TR>
                        <% } %>
                    </TABLE>
                    <BR>
                    <div align="<%=divAlign%>" style="margin-<%=divAlign%>: 15%;color: blue">
                        <p dir="<%=dir%>" align="divAlign" style="background-color: #E6E6FA;width:20%;font-weight: bold;font-size: 16px;padding-top: 2px;padding-bottom: 2px;padding-left: 5px;padding-right: 5px"><b><%=stStore%></b></p>
                    </div>

                    <TABLE CLASS="blueBorder" style="border-color: silver;" WIDTH="70%" CELLPADDING="0" CELLSPACING="0" ALIGN="CENTER" DIR="<%=dir%>">
                        <TR style="cursor: pointer;" class="backgroundHeader" onmousemove="this.className='selectedRow'" onmouseout="this.className='backgroundHeader'">
                            <TD CLASS="" width="90%" STYLE="font-size: 14px;font-weight: bold;color: black;text-align:center;border-top-width: 0px;height: 20px">
                                <%=name%>
                            </TD>
                        </TR>
                        <% for(WebBusinessObject store : stores) { %>
                        <TR style="cursor: pointer" onmousemove="this.className='selectedRow'" onmouseout="this.className=''">
                            <TD STYLE="text-align:center;border-top-width: 0px">
                                <%=store.getAttribute(storeName)%>
                            </TD>
                        </TR>
                        <% } %>
                        <% if(stores != null && stores.isEmpty()) { %>
                        <TR style="cursor: pointer" onmousemove="this.className='selectedRow'" onmouseout="this.className='<%=defaultRow%>'">
                            <TD STYLE="text-align:center;border-top-width: 0px; color: red">
                                <%=isNotSelec%>
                            </TD>
                        </TR>
                        <% } %>
                    </TABLE>
                    <BR>
                    <div align="<%=divAlign%>" style="margin-<%=divAlign%>: 15%;color: blue">
                        <p dir="<%=dir%>" align="divAlign" style="background-color: #E6E6FA;width:20%;font-weight: bold;font-size: 16px;padding-top: 2px;padding-bottom: 2px;padding-left: 5px;padding-right: 5px"><b><%=sGrantUser%></b></p>
                    </div>

                    <TABLE CLASS="blueBorder" style="border-color: silver;" WIDTH="70%" CELLPADDING="0" CELLSPACING="0" ALIGN="CENTER" DIR="<%=dir%>">
                        <TR style="cursor: pointer;" class="backgroundHeader" onmousemove="this.className='selectedRow'" onmouseout="this.className='backgroundHeader'">
                            <TD CLASS="" width="90%" STYLE="font-size: 14px;font-weight: bold;color: black;text-align:center;border-top-width: 0px;height: 20px">
                                <%=name%>
                            </TD>
                        </TR>
                        <% for(WebBusinessObject grant : grants) { %>
                        <TR style="cursor: pointer" onmousemove="this.className='selectedRow'" onmouseout="this.className=''">
                            <TD STYLE="text-align:center;border-top-width: 0px">
                                <%=grant.getAttribute("grantName")%>
                            </TD>
                        </TR>
                        <% } %>
                        <% if(grants != null && grants.isEmpty()) { %>
                        <TR style="cursor: pointer" onmousemove="this.className='selectedRow'" onmouseout="this.className='<%=defaultRow%>'">
                            <TD STYLE="text-align:center;border-top-width: 0px; color: red">
                                <%=isNotSelec%>
                            </TD>
                        </TR>
                        <% } %>
                        
                    </TABLE>
                    <BR>
                </fieldset>
            </center>

            <input type="hidden" id="numberOfUsers" name="numberOfUsers" value="<%=numberOfUsers%>" />--%>
        </FORM>
    </BODY>
</HTML>
