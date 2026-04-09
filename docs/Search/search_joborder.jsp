<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*, com.tracker.common.*, java.util.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants"%>
<%@ page import="com.silkworm.common.TimeServices"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<HTML>
    <%
    UserMgr userMgr = UserMgr.getInstance();
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
    
    String message = (String) request.getAttribute("message");
    String stat= (String) request.getSession().getAttribute("currentMode");
    String align=null;
    String dir=null;
    String style=null;
    String lang, langCode, sTitle, sCancel, sOk, sSearchTitle, sAttachingStatus;
    
    if(stat.equals("En")){
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        sTitle="Search";
        sCancel="Cancel";
        sOk="Search";
        langCode="Ar";
        sSearchTitle = "Search for Job Order";
        sAttachingStatus = "Attaching Status";
    }else{
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        sTitle = "&#1576;&#1581;&#1579;";
        sCancel = tGuide.getMessage("cancel");
        sOk="&#1576;&#1581;&#1579;";
        langCode="En";
        sSearchTitle = "&#1576;&#1581;&#1579; &#1593;&#1606; &#1571;&#1605;&#1585; &#1588;&#1594;&#1604;";
        sAttachingStatus = "&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1573;&#1585;&#1601;&#1575;&#1602;";
    }
    %>
    
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>Doc Viewer- Select Project and Status</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>
    
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

        function submitForm()
        {    
        document.ISSUE_FORM.action = "<%=context%>/SearchServlet?op=SearchJobOrderTab";
        document.ISSUE_FORM.submit();  
        }
        function cancelForm()
        {    
            document.ISSUE_FORM.action = "main.jsp";
            document.ISSUE_FORM.submit();  
        }
    </SCRIPT>
    <script src='ChangeLang.js' type='text/javascript'></script>
    <BODY>
        <FORM NAME="ISSUE_FORM" METHOD="POST">
            <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
            <button  onclick="JavaScript: cancelForm();" class="button"><%=sCancel%> <IMG VALIGN="BOTTOM" SRC="images/cancel.gif"> </button>
            <button  onclick="JavaScript: submitForm();" class="button"><%=sOk%> <IMG HEIGHT="15" SRC="images/search.gif"></button>
            <BR>
            <fieldset class="set" align="center">
                <legend align="center">
                    <table dir="<%=dir%>" align="center">
                        <tr>
                            <td class="td">
                                <font color="blue" size="6">
                                    <%=sTitle%>
                                </font>
                            </td>
                        </tr>
                    </table>
                </legend>
                <TABLE ALIGN="center" DIR="<%=dir%>"  CELLPADDING="0" CELLSPACING="0" BORDER="0">
                    <TR>
                        <TD STYLE="text-align:right" class='td'>
                            <LABEL FOR="Project_Name">
                                <p><b><%=sSearchTitle%></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="text-align:right" class='td'>
                            <input type="TEXT" value="" id="issueID" name="issueID">
                        </TD>
                    </TR>                         
                </TABLE>
                <INPUT TYPE="hidden" name="filterValue" value="">
                
                <TABLE CELLPADDING="0" CELLSPACING="0" BORDER="0">
                    <TR>
                        <TD class="td">
                            &nbsp;
                        </TD>
                    </TR>
                </TABLE>
                <%    
                if(message != null) {
                %>
                <center>
                    <table  dir="<%=dir%>">
                        <tr>
                            <td class="td"  align="<%=align%>">
                                <H4><font color="red"><%=message%></font></H4>
                            </td>
                        </tr>
                    </table>
                    <br><br>
                </center>
                <%
                }
                %>
            </FIELDSET>
        </FORM>
    </BODY>
</HTML>     
