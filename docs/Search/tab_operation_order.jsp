<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.tracker.db_access.IssueStatusMgr"%>
<%@ page import="com.silkworm.international.TouristGuide"%>  
<%
MetaDataMgr metaMgr = MetaDataMgr.getInstance();
String context = metaMgr.getContext();

TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

WebBusinessObject wbo = (WebBusinessObject) request.getAttribute("wbo");
Vector vecIssueStatus = IssueStatusMgr.getInstance().getOnArbitraryKey((String) wbo.getAttribute("id"), "key2");
String stat= (String) request.getSession().getAttribute("currentMode");

String align=null;
String dir=null;
String style=null;
String lang,langCode,sDate,sInstructions;
if(stat.equals("En")){
    align="center";
    dir="LTR";
    style="text-align:left";
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
    langCode="Ar";
    sDate = "Instruction Date";
    sInstructions = "Instruction";
}else{
    align="center";
    dir="RTL";
    style="text-align:Right";
    lang="English";
    langCode="En";
    sDate = "&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1578;&#1608;&#1589;&#1610;&#1577;";
    sInstructions = "&#1575;&#1604;&#1578;&#1608;&#1589;&#1610;&#1577;";
}
%>
<HTML>
    
    
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>Document Viewer - add new Project</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>
    <BODY>
        <br><br><br>
        <table align="center" border="0" dir="<%=dir%>" width="70%" cellspacing="0">
            <TR>
                <TD CLASS="firstname" WIDTH="20%" bgcolor="#9B9B00" STYLE="border-WIDTH:0;color:white;">
                    <%=sDate%>
                </TD>
                <TD CLASS="firstname" WIDTH="80%" bgcolor="#7EBB00" STYLE="border-WIDTH:0;color:white;">
                    <%=sInstructions%>
                </TD>
            </TR>
            <%
            for(int i = 0; i < vecIssueStatus.size(); i++){
            WebBusinessObject wboIssueStatus = (WebBusinessObject) vecIssueStatus.get(i);
            %>
            <TR>
                <TD CLASS="cell" VALIGN="top" BGCOLOR="#DDDD00" STYLE="<%=style%>;">
                    <%=wboIssueStatus.getAttribute("beginDate")%>
                </TD>
                <TD CLASS="cell" VALIGN="top" COLSPAN="2" BGCOLOR="#D7FF82" STYLE="<%=style%>;">
                    <B><%=wboIssueStatus.getAttribute("statusNote")%></B>
                </TD>
            </TR>
            <%
            }
            %>
        </TABLE>
    </BODY>
</HTML>     
