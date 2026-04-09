<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*, com.tracker.common.*,com.tracker.business_objects.*, java.util.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<HTML>
    
    <%
    UserMgr userMgr = UserMgr.getInstance();
    
    WebBusinessObject webIssue = (WebBusinessObject)request.getAttribute("webIssue");
    //String userId = (String) webIssue.getAttribute("userId");
    
    //WebBusinessObject webUser = (WebBusinessObject) userMgr.getOnSingleKey(userId);
    //webUser.printSelf();
    
    WebIssue wIssue = (WebIssue) request.getAttribute("webIssue");
    wIssue.printSelf();
    
    //  <A HREF="<%=context/ImageReaderServlet?op=<%=VO.getAttribute("filter")&filterValue=<%=VO.getAttribute("filterValue")">
    
    //  AssignedIssueState ais = (AssignedIssueState) request.getAttribute("state");
    String cMode= (String) request.getSession().getAttribute("currentMode");
    String  stat=cMode;
    String align=null;
    String dir=null;
    String style=null;
    String lang,langCode;
    if(stat.equals("En")){
        
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        langCode="Ar";
    }else{
        
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        langCode="En";
    }
    
    %>
    
    
    
    <script src='ChangeLang.js' type='text/javascript'></script>
    
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>DebugTracker-Schedule detail</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>
    
    <BODY>
        <left>
        <FORM NAME="ISSUE_DETAIL_FORM" METHOD="POST">
            
            
            <DIV align="left" STYLE="color:blue;">
                <input type="button" value="<%=lang%>"
                       onclick="reloadAE('<%=langCode%>')" STYLE="background:#cc6699;font-size:15;color:white;font-weight:bold; ">
            </DIV> 
            <TABLE WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;" dir="<%=dir%>">
                <TR VALIGN="MIDDLE">
                    <TD COLSPAN="2" CLASS="tabletitle" STYLE="border-left-WIDTH: 1;<%=style%>;">
                        View Schedule Detail
                    </TD>
                    <TD CLASS="tabletitle" STYLE="">
                        <IMG WIDTH="20" HEIGHT="20" SRC="images/corner.gif">
                    </TD>
                    <TD CLASS="tableright" colspan="3">
                        <IMG VALIGN="BOTTOM"  HEIGHT="15" SRC="images/leftarrow.gif">
                        <A HREF="">
                            Back to list
                        </A>
                        
                    </TD>
                </TR>
            </TABLE>
            
            <TABLE CELLPADDING="0" CELLSPACING="0" BORDER="0" dir="<%=dir%>">
                <TR>
                    <TD class='td'>
                        <LABEL FOR="ISSUE_TITLE">
                            <p><b>Schedule Title</b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD class='td'>
                        <input type="TEXT" name="issueTitle" ID="issueTitle" size="33" value="<%= (String) webIssue.getAttribute("issueTitle")%>" maxlength="255">
                    </TD>
                </TR>
                
                <TR>
                    <TD class='td'>
                        <LABEL FOR="str_Maintenance_Name">
                            <p><b>Maintenance</b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD class='td'>
                        <input type="TEXT" name="faId" ID="maintenance" size="33" value="<%= (String) webIssue.getAttribute("faId")%>" maxlength="255">
                    </TD>
                </TR>
                
                <TR>
                    <TD class='td'>
                        <LABEL FOR="str_IssueType_Name">
                            <p><b>Task Type</b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD class='td'>
                        <input type="TEXT" name="issueId" ID="typeName" size="33" value="<%= (String) webIssue.getAttribute("issueId")%>" maxlength="255">
                    </TD>
                </TR>
                
                <TR>
                    <TD class='td'>
                        <LABEL FOR="str_Urgency_Name">
                            <p><b>Urgency Type</b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD class='td'>
                        <input type="TEXT" name="urgencyId" ID="urgencyName" size="33" value="<%= (String) webIssue.getAttribute("urgencyId")%>" maxlength="255">
                    </TD>
                </TR>
                
                <TR>
                    <TD class='td'>
                        <LABEL FOR="str_User_Name">
                            <p><b>Created By</b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD class='td'>
                        <input type="TEXT" name="createdBy" ID="createdBy" size="33" value="<%= (String) webIssue.getAttribute("userId")%>" maxlength="255">
                    </TD>
                </TR>
                
                <TR>
                    <TD class='td'>
                        <LABEL FOR="str_current_status">
                            <p><b>Current Status</b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD class='td'>
                        <input type="TEXT" name="currentStatus" ID="currentStatus" size="33" value="<%= (String) webIssue.getAttribute("currentStatus")%>" maxlength="255">
                    </TD>
                </TR>
                
                <TR>
                    <TD class='td'>
                        <LABEL FOR="str_creation_time">
                            <p><b>Creation Time</b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD class='td'>
                        <input type="TEXT" name="CREATION_TIME" ID="CREATION_TIME" size="33" value="<%= (String) webIssue.getAttribute("currentStatusSince")%>" maxlength="255">
                    </TD>
                </TR>
                
                <TR>
                    <TD class='td'>
                        <LABEL FOR="str_Maintenance_Desc">
                            <p><b>Schedule Description </b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD class='td'>
                        <%= (String) webIssue.getAttribute("issueDesc")%>
                    </TD>
                </TR>
            </TABLE>
        </FORM>
    </BODY>
</HTML>     
