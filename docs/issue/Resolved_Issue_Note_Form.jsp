<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*, com.tracker.business_objects.*,com.tracker.common.*, java.util.*"%>
<%@ page import="com.tracker.common.AppConstants"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>DebugTracker-add new Schedule</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>
    <%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    // tGuide = new TouristGuide("/com/docviewer/international/DocOnlineMenu");
    
    String context= metaMgr.getContext();
    
    String projectname = (String) request.getAttribute("projectName");
    %>
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

        function submitForm()
        {
         if ( !isNaN (this.ISSUE_FORM.actual_finish_time.value)&& this.ISSUE_FORM.actual_finish_time.value != "")
          {
          document.ISSUE_FORM.action = "<%=context%>/ProgressingIssueServlet?op=SaveStatus&projectName=<%=projectname%>";
          document.ISSUE_FORM.submit(); 
          }
         else
          {
          alert ("Enter A numeric Value In The actual_finish_time Field ")
          }
        }
    </SCRIPT>
    
 <script src='ChangeLang.js' type='text/javascript'></script>


    
    <BODY>
        <left>
        <%
        UserMgr userMgr = UserMgr.getInstance();
        String issueId = (String) request.getAttribute("issueId");
        String issueTitle = (String) request.getAttribute("issueTitle");
        String direction = (String) request.getAttribute(AppConstants.DIRECTION);
        String filterName = (String) request.getAttribute("filterName");
        String filterValue = (String) request.getAttribute("filterValue");
        
        //AssignedIssueState ais = (AssignedIssueState) request.getAttribute("state");
        
        System.out.println("Worker Notes Page" + issueId);
        
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
        <FORM NAME="ISSUE_FORM" METHOD="POST">
            
            
            <DIV align="left" STYLE="color:blue;">
                <input type="button" value="<%=lang%>"
                       onclick="reloadAE('<%=langCode%>')" STYLE="background:#cc6699;font-size:15;color:white;font-weight:bold; ">
            </DIV> 
            <TABLE WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;" dir="<%=dir%>">
                
                <TR VALIGN="MIDDLE">
                    <TD COLSPAN="2" CLASS="tabletitle" STYLE="border-left-WIDTH: 1;<%=style%>;">
                        Start Working on Schedule
                    </TD>
                    <TD CLASS="tabletitle" STYLE="">
                        <IMG WIDTH="20" HEIGHT="20" SRC="images/corner.gif">
                    </TD>
                    <TD CLASS="tableright" colspan="3">
                        <IMG VALIGN="BOTTOM"  HEIGHT="15" SRC="images/leftarrow.gif">
                        <A HREF="<%=context%>/SearchServlet?op=<%=filterName%>&filterValue=<%=filterValue%>&projectName=<%=projectname%>">
                            Back to list
                        </A>
                        <IMG VALIGN="BOTTOM" HEIGHT="10" WIDTH="1" SRC="images/line.gif">
                        <A HREF="JavaScript: submitForm();">
                            Save Status
                        </A>
                    </TD>
                </TR>
            </TABLE>
            
            <TABLE CELLPADDING="0" CELLSPACING="0" BORDER="0" dir="<%=dir%>">
                
                <TR COLSPAN="2" ALIGN="CENTER">
                    <TD class='td'>
                        <FONT color='red' size='+1'>All * Fields are required</FONT> 
                    </TD>
                </TR>
                
                <TR>
                    <TD class='td'>
                        <LABEL FOR="ISSUE_TITLE">
                            <p><b>Start working on<font color="#FF0000"> </font></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD class='td'>
                        <input disabled type="text" name="issueTitle" value="<%=issueTitle%>" ID="<%=issueTitle%>" size="33"  maxlength="50">
                    </TD>
                </TR>
                
                <TR>
                    <TD class='td'>
                        <LABEL FOR="str_Function_Desc">
                            <p><b>Worker note: <font color="#FF0000">*</font></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD class='td'>
                        <TEXTAREA rows="5" name="workerNote" cols="25"></TEXTAREA>
                    </TD>
                    
                </TR>
                <TR>
                    <TD class='td'>
                        <LABEL FOR="str_Function_Desc">
                            <p><b>Actual Finish Time: <font color="#FF0000">*</font></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD class='td'>
                        <input  type="text" name="actual_finish_time"  size="4" ></input>
                    </TD>
                    
                </TR>
            </TABLE>
            <input type=HIDDEN name="issueId" value = "<%=issueId%>" >
            <input type=HIDDEN name=filterValue value="<%=filterValue%>" >
            <input type=HIDDEN name=filterName value="<%=filterName%>" >
            <input type=HIDDEN name="<%=AppConstants.DIRECTION%>" value="<%=direction%>" >
        </FORM>
    </BODY>
</HTML>     
