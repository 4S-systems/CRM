<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,com.silkworm.db_access.*"%>
<%@ taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();

    String status = (String) request.getAttribute("status");

    ArrayList districts = new ArrayList();
    districts = (ArrayList) request.getAttribute("districts");
    String userId = (String) request.getAttribute("userId");

    GroupMgr groupMgr = GroupMgr.getInstance();
    Vector groups = groupMgr.getCashedTable();
    int l = groups.size();

    TouristGuide tGuide = new TouristGuide("/com/silkworm/international/BasicForms");
    String stat = (String) request.getSession().getAttribute("currentMode");
    String align = null;
    String dir = null;
    String style = null;
    String lang, langCode;

    String saving_status_ok, saving_status_fail, saving_status_repeated;
    String sTitle, title_2;
    String sUserName, sUserDesc;
    String cancel_button_label;
    String save_button_label, sPadding, sMenu, sSelect, sPassword, sEmail, sGroup, sTrade, project, sipID;

    String isDefault, sGrantUser, sSelectAll, filterQuery, sFullName, isSuperUser, userType, divAlign, companyName, noCompany;

    if (stat.equals("En")) {

        align = "center";
        dir = "LTR";
        style = "text-align:left";
        lang = "   &#1593;&#1585;&#1576;&#1610;    ";
        divAlign = "left";

        sUserName = "User Name";
        sUserDesc = "User Description";
        sTitle = "Update User Disrict";
        title_2 = "All information are needed";
        cancel_button_label = "Back To List";
        save_button_label = "Save";
        langCode = "Ar";
        sPadding = "left";
        sMenu = "Menu";
        sSelect = "Select";
        sPassword = "Password";
        sEmail = "Email Address";
        sGroup = "Group";
        sTrade = "Trade";
        project = "Site";
        saving_status_ok = "Saving Successfully";
        saving_status_fail = "Fail To Save";
        saving_status_repeated = "This User is Associated to a district";
        isDefault = "Is Default";
        sGrantUser = "Grants user";
        sSelectAll = "All";
        filterQuery = "Search by";
        sFullName = "Full Name";
        isSuperUser = "Is Super User";
        userType = "User type";

        sipID = "SIP ID";
        companyName = "District Name";
        noCompany = "Not Related to Company";
    } else {

        align = "center";
        dir = "RTL";
        style = "text-align:Right";
        lang = "English";
        divAlign = "right";

        sUserName = "&#1575;&#1587;&#1605; &#1575;&#1604;&#1605;&#1587;&#1578;&#1582;&#1583;&#1605;";
        sUserDesc = "&#1608;&#1589;&#1601; &#1575;&#1604;&#1605;&#1580;&#1605;&#1608;&#1593;&#1577;";
        sTitle = "تغيير البيانات الاساسية";
        title_2 = "&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
        cancel_button_label = "&#1593;&#1608;&#1583;&#1577;";
        save_button_label = "&#1578;&#1587;&#1580;&#1610;&#1604;";
        langCode = "En";
        sPadding = "right";
        sMenu = "&#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577;";
        sSelect = "&#1575;&#1582;&#1578;&#1575;&#1585;";
        sPassword = "&#1603;&#1604;&#1605;&#1577; &#1575;&#1604;&#1605;&#1585;&#1608;&#1585;";
        sEmail = "&#1575;&#1604;&#1576;&#1585;&#1610;&#1583; &#1575;&#1604;&#1573;&#1604;&#1603;&#1578;&#1585;&#1608;&#1606;&#1610;";
        sGroup = "&#1605;&#1580;&#1605;&#1608;&#1593;&#1577;";
        sTrade = "&#1575;&#1604;&#1573;&#1583;&#1575;&#1585;&#1577; &#1575;&#1604;&#1601;&#1606;&#1610;&#1577;";
        project = "&#1575;&#1604;&#1605;&#1608;&#1602;&#1593;";
        saving_status_ok = "&#1578;&#1605; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604; &#1576;&#1606;&#1580;&#1575;&#1581;";
        saving_status_fail = "&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
        saving_status_repeated  = "هذا المستخدم مرتبط بمنطقة اخري";
        isDefault = "&#1573;&#1601;&#1578;&#1585;&#1575;&#1590;&#1609;";
        sGrantUser = "&#1589;&#1604;&#1575;&#1581;&#1610;&#1575;&#1578; &#1575;&#1604;&#1605;&#1587;&#1578;&#1582;&#1583;&#1605;";
        sSelectAll = "&#1575;&#1604;&#1603;&#1604;";
        filterQuery = "&#1575;&#1604;&#1576;&#1581;&#1579; &#1576;&#1608;&#1575;&#1587;&#1591;&#1577;";
        sFullName = "الاسم بالكامل";
        isSuperUser = "&#1587;&#1604;&#1591;&#1575;&#1578; &#1605;&#1591;&#1600;&#1600;&#1600;&#1600;&#1604;&#1602;&#1577;";
        userType = "نوع المستخدم";

        sipID = "SIP ID";
        companyName = "اسم المنطقة";
        noCompany = "غير مرتبط بمنطقة";
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

        function submitForm()
        {
            document.USERS_FORM.action = "<%=context%>/UsersServlet?op=saveDistrict";
            document.USERS_FORM.submit();
        }

        function cancelForm()
        {
            document.USERS_FORM.action = "<%=context%>/ListerServlet?op=ListUsers";
            document.USERS_FORM.submit();
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
                    if (null != status) {
                        if (status.equalsIgnoreCase("ok")) {
                %>
                <center>
                    <h3>   <%=saving_status_ok%> </h3>
                </center>
                <br>
                <%} else if (status.equalsIgnoreCase("repeated")) {%>
                <center>
                    <h3>   <%=saving_status_repeated%> </h3>
                </center>
                <br>
                <%} else {%>
                <center>
                    <h3>   <%=saving_status_fail%> </h3>
                </center>
                <%
                        }
                    }
                %>

                <TABLE CELLPADDING="0" CELLSPACING="0" BORDER="0" ALIGN="CENTER" DIR="<%=dir%>">
                    <TR>
                        <TD class="td">
                            <p><b style="margin-left: 5px;margin-left: 5px;font-weight: bold"><%=companyName%></b>&nbsp;
                        </TD>
                        <TD class="td">
                            <div align="<%=divAlign%>">
                                <SELECT name="district" ID="district" STYLE="width:255px">
                                    <option value="0"><%=noCompany%></OPTION>>
                                    <sw:WBOOptionList wboList='<%=districts%>' displayAttribute = "projectName" valueAttribute="projectID" scrollTo=""/>
                                </SELECT>
                            </div>
                        </TD>
                    </TR>  
                </TABLE>
                <BR><BR>
                <input type="hidden" name="rows" id="rows" value="<%=l%>">
                <INPUT TYPE='HIDDEN' name='userId' value="<%=userId%>" > 
                <BR>
                <BR><BR>

            </fieldset>
        </FORM>
    </BODY>
</HTML>     
