<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*, com.tracker.common.*, java.util.*,com.tracker.business_objects.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<HTML>
    
    <%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    
    String filterName = (String) request.getParameter("filterName");
    String filterValue = (String) request.getParameter("filterValue");
    
    String projectname = (String) request.getAttribute("projectName");
    
    WebBusinessObject bookmark = (WebBusinessObject) request.getAttribute("bookmark");
    String Cancelurl=context+"/SearchServlet?op="+filterName+"&filterValue="+filterValue+"&projectName="+projectname;
    String plusUrl="";
    if(session.getAttribute("case")!=null){
        
        plusUrl="&case=case39&unitName="+(String)session.getAttribute("unitName")+"&title="+(String)session.getAttribute("title");
        Cancelurl=context+"/SearchServlet?op=StatusProjctListTitle&filterValue="+filterValue+"&projectName="+projectname+plusUrl;
        
    }
    
    //AssignedIssueState ais = (AssignedIssueState) request.getAttribute("state");
    String stat= (String) request.getSession().getAttribute("currentMode");
    String align=null;
    String dir=null;
    String style=null;
    String lang, langCode, sTitle, sCancel, sBookmarkTitle, sTaskTitle, sRequired;
    
    if(stat.equals("En")){
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        sTitle="View Bookmark";
        sCancel="Back";
        langCode="Ar";
        sBookmarkTitle = "Bookmark Text";
        sTaskTitle = "Task Title";
        sRequired = "All * Fields are required";
    }else{
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        sTitle="&#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1593;&#1604;&#1575;&#1605;&#1577;";
        sCancel="&#1593;&#1600;&#1600;&#1600;&#1600;&#1608;&#1583;&#1577;";
        langCode="En";
        sBookmarkTitle = "&#1606;&#1589;&#1617; &#1575;&#1604;&#1593;&#1604;&#1575;&#1605;&#1577;";
        sTaskTitle = "&#1593;&#1606;&#1608;&#1575;&#1606; &#1575;&#1604;&#1605;&#1607;&#1605;&#1577;";
        sRequired = "&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
    }
    %>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <MEeTA HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>DebugTracker-add new issue</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>
    
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

        function submitForm()
        {    
        document.ISSUE_FORM.action = "<%=context%>/BookmarkServlet?op=save<%=plusUrl%>";
        document.ISSUE_FORM.submit();  
        }
        function cancelForm()
        {    
            document.ISSUE_FORM.action = "<%=Cancelurl%>";
            document.ISSUE_FORM.submit();  
        }
    </SCRIPT>
    <script src='ChangeLang.js' type='text/javascript'></script>
    <BODY>
        <FORM NAME="ISSUE_FORM" METHOD="POST">
            <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
            <button  onclick="JavaScript: cancelForm();" class="button"><%=sCancel%><IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif"> </button>
            <br>
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
                <TABLE CELLPADDING="0" CELLSPACING="0" BORDER="0" ALIGN="CENTER" DIR="<%=dir%>">
                    
                    <TR COLSPAN="2" ALIGN="CENTER">
                        <TD class='td'>
                            <FONT color='red' size='+1'><%=sRequired%></FONT> 
                        </TD>
                    </TR>
                    
                    <TR>
                        <TD class='td'>
                            <LABEL FOR="ISSUE_TITLE">
                                <p><b><%=sTaskTitle%><font color="#FF0000">*</font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD class='td'>
                            <input disabled type="TEXT" STYLE="width:230px;" name="issueTitle" value="<%=bookmark.getAttribute("issueTitle")%>" ID="issueTitle" size="33"  maxlength="50">
                        </TD>
                    </TR>
                    
                    
                    <TR>
                        <TD class='td'>
                            <LABEL FOR="str_Function_Desc">
                                <p><b><%=sBookmarkTitle%><font color="#FF0000">*</font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <td class='td'>
                            <DIV class="textview" STYLE="width:230px;<%=style%>">
                                <%=bookmark.getAttribute("bookmarkText")%>
                            </div>
                        </td>
                    </TR>
                </TABLE>
                <BR>
            </FIELDSET>
        </FORM>
    </BODY>
</HTML>     
