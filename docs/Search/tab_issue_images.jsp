<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="com.tracker.engine.IssueStatusFactory, com.tracker.engine.*,com.docviewer.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<%

MetaDataMgr metaMgr = MetaDataMgr.getInstance();
String context = metaMgr.getContext();

WebBusinessObject wbo = (WebBusinessObject) request.getAttribute("wbo");
WebIssue webIssue = (WebIssue) wbo;
String cMode= (String) request.getSession().getAttribute("currentMode");
String  stat=cMode;
String align="center";
String dir=null;
String style=null;
String cancel_button_label;
String lang,langCode,indGuid,attached,termainanted,nconfig,Config,updateTime,notAattached,notTermainanted;
String showDetails,searchRe,numTask,QuikSummry,basicOP,workFlow,signe,mark,viewD,DM,sta,schduled,Begined,Finished,Canceled,Holded,Rejected,external,em,pm,timeout;
if(stat.equals("En")){
    
    cancel_button_label="Back to list";
    dir="LTR";
    style="text-align:left";
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
    langCode="Ar";
    indGuid=" Indicators guide ";
    nconfig="configured task";
    Config="Not yet configured task";
    attached="view attached files";
    notAattached="There is no attached files";
    termainanted="Termaintanted task"  ;
    notTermainanted="Not Termaintanted task"  ;
    updateTime="update date time";
    showDetails="show Details";
    numTask=" Tasks Numbers ";
    QuikSummry=" Quick Summary ";
    basicOP="Basic Operations";
    workFlow="Work Flow";
    signe="Guide";
    mark="Mark";
    viewD="View Details";
    DM="Delete Mark";
    sta="Status";
    schduled="Scheduled";
    Begined="Started";
    Finished="Finished";
    Canceled="Canceled";
    Holded="on Hold";
    Rejected="Rejected";
    external="External job Order";
    em="Emergency Job Order";
    pm="Premaintative Maintenance";
    timeout= "Don't change date after start engine";
    
}else{
    
    cancel_button_label="&#1593;&#1608;&#1583;&#1607; &#1575;&#1604;&#1610; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1607;";
    dir="RTL";
    style="text-align:Right";
    lang="English";
    langCode="En";
    indGuid= "&#1575;&#1604;&#1605;&#1585;&#1588;&#1583; &#1575;&#1604;&#1605;&#1589;&#1608;&#1585;";
    attached="&#1573;&#1590;&#1594;&#1591; &#1604;&#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583;&#1575;&#1578; &#1575;&#1604;&#1605;&#1585;&#1601;&#1602;&#1607;";
    notAattached="&#1604;&#1575; &#1610;&#1608;&#1580;&#1583; &#1605;&#1587;&#1578;&#1606;&#1583;&#1575;&#1578; &#1605;&#1585;&#1601;&#1602;&#1607;";
    termainanted="&#1605;&#1607;&#1605;&#1607; &#1605;&#1606;&#1578;&#1607;&#1610;&#1607;";
    notTermainanted="&#1605;&#1607;&#1605;&#1607; &#1594;&#1610;&#1585; &#1605;&#1606;&#1578;&#1607;&#1610;&#1607;"  ;
    Config="&#1580;&#1583;&#1608;&#1604; &#1605;&#1585;&#1578;&#1576;&#1591; &#1576;&#1602;&#1591;&#1593; &#1594;&#1610;&#1575;&#1585;";
    nconfig="&#1580;&#1583;&#1608;&#1604; &#1594;&#1610;&#1585; &#1605;&#1585;&#1578;&#1576;&#1591; &#1576;&#1602;&#1591;&#1593; &#1594;&#1610;&#1575;&#1585;";
    updateTime="&#1578;&#1581;&#1583;&#1610;&#1579; &#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1593;&#1605;&#1604;";
    showDetails="&#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1575;&#1604;&#1578;&#1601;&#1575;&#1589;&#1610;&#1604;";
    numTask="&#1593;&#1583;&#1583; &#1575;&#1604;&#1605;&#1607;&#1575;&#1605;  ";
    QuikSummry="&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1587;&#1585;&#1610;&#1593;&#1577;";
    basicOP="&#1593;&#1605;&#1604;&#1610;&#1575;&#1578; &#1571;&#1587;&#1575;&#1587;&#1610;&#1577;";
    workFlow="&#1575;&#1604;&#1583;&#1608;&#1585;&#1577; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583;&#1610;&#1577;";
    signe="&#1575;&#1604;&#1585;&#1605;&#1586;";
    mark="&#1593;&#1604;&#1575;&#1605;&#1607;";
    viewD="&#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1575;&#1604;&#1578;&#1601;&#1575;&#1589;&#1610;&#1604;";
    DM="&#1581;&#1584;&#1601; &#1575;&#1604;&#1593;&#1604;&#1575;&#1605;&#1577;";
    sta="&#1575;&#1604;&#1581;&#1575;&#1604;&#1577;";
    schduled="&#1605;&#1580;&#1583;&#1608;&#1604;&#1577;";
    Begined="&#1576;&#1583;&#1571;&#1578;";
    Finished="&#1573;&#1606;&#1578;&#1607;&#1578;";
    Canceled="&#1605;&#1604;&#1594;&#1575;&#1577;";
    Holded="&#1605;&#1608;&#1602;&#1608;&#1601;&#1577;";
    Rejected="&#1605;&#1585;&#1601;&#1608;&#1590;&#1577;";
    external="&#1571;&#1605;&#1585; &#1588;&#1594;&#1604; &#1582;&#1575;&#1585;&#1580;&#1610;";
    em="&#1571;&#1605;&#1585; &#1588;&#1594;&#1604; &#1587;&#1585;&#1610;&#1593;";
    pm="&#1589;&#1610;&#1575;&#1606;&#1577; &#1608;&#1602;&#1575;&#1574;&#1610;&#1607;";
    timeout="&#1604;&#1575; &#1610;&#1605;&#1603;&#1606; &#1578;&#1594;&#1610;&#1610;&#1585; &#1575;&#1604;&#1608;&#1602;&#1578; &#1576;&#1593;&#1583; &#1576;&#1583;&#1569; &#1605;&#1585;&#1581;&#1604;&#1577; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
}

%>

<HTML>
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Expires" CONTENT="0">

<HEAD>
    <TITLE>Tracker- List Schedules</TITLE>
    <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    <LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
</HEAD>
<BODY>
    <center>
        <BR>
        <%
        if (webIssue.isTerminal()) {
        %>
        <b> <%//=webIssue.getReverseStateAction()%> </b>
        
        <IMG SRC="images/unassign.gif" WIDTH="20" HEIGHT="20"  ALT="Terminated Task">
        
        <%
        } else {
        %> 
        
        <IMG WIDTH="20" HEIGHT="20" SRC="images/assign.gif"  ALT="UnTerminated Task">
        <% } %>
        <BR>
        <%
        String ScheduleUnitId=IssueMgr.getInstance().getScheduleUnitId((String) wbo.getAttribute("id"));
        String Configure= IssueMgr.getInstance().getConfigure(ScheduleUnitId);
        if(Configure.equals("Yes")) {
        %>
        <IMG WIDTH="20" HEIGHT="20" SRC="images/config.jpg"  ALT="Configured Schedule"> 
        <%
        } else {
        %> 
        
        <IMG WIDTH="20" HEIGHT="20" SRC="images/nonconfig.gif"  ALT="Un configure Schedule">
        <% } %>
        <BR>
        <% if(wbo.getAttribute("issueType").toString().equalsIgnoreCase("Emergency")){%>
        <IMG WIDTH="20" HEIGHT="20" SRC="images/emr.gif"  ALT="Emergency job order">
        <% }else if(wbo.getAttribute("issueType").toString().equalsIgnoreCase("External")){ %>
        <IMG WIDTH="20" HEIGHT="20" SRC="images/external.gif"  ALT="External job order">
        <%}else{%>
        <IMG WIDTH="20" HEIGHT="20" SRC="images/internal.gif"  ALT="Planned Job Order">
        <%}%>
        <BR>
        <% if(wbo.getAttribute("scheduleType").toString().equalsIgnoreCase("External")){%>
        <IMG WIDTH="20" HEIGHT="20" SRC="images/external.gif"  ALT="External job order">
        <% } else {
        %>
        &nbsp;
        <%
        }
        %>
        <BR>
    </CENTER>
</body>
</html>