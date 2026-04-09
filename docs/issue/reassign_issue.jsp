<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*"%>

<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*, com.tracker.common.*, java.util.*,com.tracker.business_objects.*,com.tracker.engine.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<HTML>
<%

MetaDataMgr metaMgr = MetaDataMgr.getInstance();
String context = metaMgr.getContext();
// tGuide = new TouristGuide("/com/docviewer/international/DocOnlineMenu");

//String context= metaMgr.getContext();
UserMgr userMgr = UserMgr.getInstance();
String issueId = (String) request.getAttribute(IssueConstants.ISSUEID);
String issueTitle = (String) request.getAttribute(IssueConstants.ISSUETITLE);

String filterName = (String) request.getAttribute("filter");
String filterValue = (String) request.getAttribute("filterValue");
System.out.println("filterValue IN JSP ____________________________HIIIIIIIIIIIIII"+filterValue);
System.out.println("filterName IN JSP ____________________________HIIIIIIIIIIIIII"+filterName);
AssignedIssueState ais = (AssignedIssueState) request.getAttribute("state");

String projectname = (String) request.getAttribute("projectName");

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
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Expires" CONTENT="0">

<HEAD>
    <TITLE>DebugTracker-add new issue</TITLE>
    <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
</HEAD>

<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

        function submitForm()
        {    
        if (!isNaN(this.ISSUE_FORM.finishTime.value) && this.ISSUE_FORM.finishTime.value !="")
        { 
        document.ISSUE_FORM.action = "<%=context%>/AssignedIssueServlet?op=saveReassign&projectName=<%=projectname%>";
        document.ISSUE_FORM.submit();  
        }
        else
        alert ("You must enter a numeric value to the finish time ");

        }

</SCRIPT>


<script src='ChangeLang.js' type='text/javascript'></script>


<BODY>
<left>

<FORM NAME="ISSUE_FORM" METHOD="POST">


<DIV align="left" STYLE="color:blue;">
    <input type="button" value="<%=lang%>"
           onclick="reloadAE('<%=langCode%>')" STYLE="background:#cc6699;font-size:15;color:white;font-weight:bold; ">
</DIV> 
<TABLE WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;" dir="<%=dir%>">
    
    <TR VALIGN="MIDDLE">
        <TD COLSPAN="2" CLASS="tabletitle" STYLE="border-left-WIDTH: 1;<%=style%>;">
            Reassigning Issue
        </TD>
        <TD CLASS="tabletitle" STYLE="">
            <IMG WIDTH="20" HEIGHT="20" SRC="images/corner.gif">
        </TD>
        <TD CLASS="tableright" colspan="3">                   
            <A HREF="<%=context%>/SearchServlet?op=<%=filterName%>&filterValue=<%=filterValue%>&projectName=<%=projectname%>">
                Back to list
                <IMG VALIGN="BOTTOM"  HEIGHT="15" SRC="images/leftarrow.gif">
            </A>
            <IMG VALIGN="BOTTOM" HEIGHT="10" WIDTH="1" SRC="images/line.gif">
            <A HREF="JavaScript: submitForm();">
                Reassign Issue
            </A>
        </TD>
    </TR>
</TABLE>

<TABLE CELLPADDING="0" CELLSPACING="0" BORDER="0" dir="<%=dir%>">
<TR>
    <TD class='td'>
        &nbsp;
    </TD>
</TR>
<TR COLSPAN="2" ALIGN="<%=align%>">
<TD class='td'>
    <FONT color='red' size='2'><b>All * fields are required</FONT></b> 
</TD>
</TR>

<TR>
    <TD class='td'>
        &nbsp;
    </TD>
</TR>
<TR>
    <TD class='td'>
        <LABEL FOR="ISSUE_TITLE">
            <p><b><font color="#FF0000">*</font>Issue Title:</b>&nbsp;
        </LABEL>
    </TD>
    <TD class='td'>
        <input disabled type="TEXT" name=issueTitle value="<%=issueTitle%>" ID="<%=issueTitle%>" size="33"  maxlength="50">
    </TD>
</TR>
<TR>
    <TD class='td'>
        &nbsp;
    </TD>
</TR>
<TR>
    <TD class='td'>
        <LABEL FOR="assign_to">
            <p><b><font color="#FF0000">*</font>Assign to:</b>&nbsp;
        </LABEL>
    </TD>
    <TD class='td'>
        <SELECT name="assignTo">
            <sw:WBOOptionList wboList='<%=userMgr.getCashedTableAsBusObjects()%>' displayAttribute = "userName" valueAttribute="userId"/>
        </SELECT>
    </TD>
</TR>
<TR>
    <TD class='td'>
        &nbsp;
    </TD>
</TR>
<TR>
    <TD class='td'>
        <LABEL FOR="FINISH_TIME">
            <p><b> <font color="#FF0000">*</font>Finish Time (in hours):</b>&nbsp;
        </LABEL>
    </TD>
    <TD class='td'>
        <input type="TEXT" name="finishTime" ID="issueTitle" size="3" value="" maxlength="3">
    </TD>
    <input type=HIDDEN name=issueId value="<%=issueId%>" >
    <input type=HIDDEN name=filterName value="<%=filterName%>" >
    <input type=HIDDEN name=filterValue value="<%=filterValue%>" >
    <input type=HIDDEN name=issueTitle value="<%=issueTitle%>">
</TR>
<TR>
    <TD class='td'>
        &nbsp;
    </TD>
</TR>
<TR>
    <TD class='td'>
        <LABEL FOR="str_Function_Desc">
            <p><b><font color="#FF0000">*</font>Root Cause Analysis:</b>&nbsp;
        </LABEL>
    </TD>
    <TD class='td'>
        <TEXTAREA rows="5" name="assignNote" cols="25"></TEXTAREA>
    </TD>
</TR>
</TABLE>
</FORM>
</BODY>
</HTML>     
