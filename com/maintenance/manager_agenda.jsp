<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="com.tracker.engine.IssueStatusFactory, com.tracker.engine.*,com.docviewer.db_access.*, com.maintenance.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %> 

<HTML>
    <meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <meta HTTP-EQUIV="Expires" CONTENT="0">
    <head>
        <title>Weekly Manager Agenda</title>
        <link REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </head>
    
    <%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    IssueMgr issueMgr = IssueMgr.getInstance();
    ImageMgr imageMgr = ImageMgr.getInstance();
    
    Calendar weekCalendar = Calendar.getInstance();
    Calendar beginWeekCalendar = Calendar.getInstance();
    Calendar endWeekCalendar = Calendar.getInstance();

    UnitScheduleMgr unitScheduleMgr = UnitScheduleMgr.getInstance();
    
    AppConstants appCons = new AppConstants();
    
    Vector issuesVector = new Vector();
    WebBusinessObject wbo = null;
    WebIssue webIssue = null;
    WebBusinessObject unitScheduleWbo = null;
    
    String context = metaMgr.getContext();
    String attName = null;
    String attValue = null;
    String issueID = null;
    String MaintenanceTitle=null;
    String ScheduleUnitId=null;
    String Configure = null;
    String bgColor = null;
    String cellColor = null;
    String UnitName = null;
    String status = null;
    
    String[] issueAtt = appCons.getIssueAttributes();
    String[] issueTitle = appCons.getIssueHeaders();
    
    int s = issueAtt.length;
    int t = s+6;
    int iTotal = 0;
    
    int dayOfWeekValue = weekCalendar.getTime().getDay();
    int todayValue = weekCalendar.getTime().getDate();
    
    beginWeekCalendar = (Calendar) weekCalendar.clone();
    endWeekCalendar = (Calendar) weekCalendar.clone();
    beginWeekCalendar = (Calendar) weekCalendar.clone();
    
    beginWeekCalendar.add(beginWeekCalendar.DATE, -dayOfWeekValue);
    endWeekCalendar.add(endWeekCalendar.DATE, 4 - dayOfWeekValue);
    
    java.sql.Date beginInterval =  new java.sql.Date(beginWeekCalendar.getTimeInMillis());
    java.sql.Date endInterval = new java.sql.Date(endWeekCalendar.getTimeInMillis());
    java.sql.Date todayDate = new java.sql.Date(weekCalendar.getTimeInMillis());
      
    issuesVector = issueMgr.getIssuesListInRange(new java.sql.Date(beginWeekCalendar.getTimeInMillis()), new java.sql.Date(endWeekCalendar.getTimeInMillis()));
    %>
    
    <BODY>
        <DIV ALIGN="CENTER"><Font COLOR="FF385C" FACE="verdana" SIZE="+2"><b>Current Manager Agenda (Weekly)</b></FONT></DIV><br>
        <DIV ALIGN="CENTER"><b><Font COLOR="FF385C" FACE="verdana" SIZE="+1">From</FONT>&nbsp;&nbsp;<%=beginInterval.toString()%>&nbsp;&nbsp;<Font COLOR="FF385C" FACE="verdana" SIZE="+1">To</FONT>&nbsp;&nbsp;<%=endInterval.toString()%></b></DIV><br>
        
        <table border="0" dir="ltr">
            <tr>
                <td colspan="5" border="0" bgcolor="#F3F3F3"><font color="#009FEC"><b>Indicators guide</b></font></td>
            </tr>
            <tr>    
                <td CLASS="cell" bgcolor="#F3F3F3"><IMG SRC="images/unassign.gif"  ALT="Terminated Task" ALIGN="left"><FONT COLOR="red" dir="ltr">Terminated Task</font></td>
                <td CLASS="cell" bgcolor="#F3F3F3"><IMG SRC="images/config.jpg"  ALT="Configured Schedule" ALIGN="left"><FONT COLOR="red" dir="ltr">Configured Schedule</font></td>
                <td CLASS="cell" bgcolor="#F3F3F3"><IMG HEIGHT="10" WIDTH="10" SRC="images/red.JPG"  ALT="Should Be Begin Today" ALIGN="left"><FONT COLOR="red" dir="ltr">Should Be Begin</font></td>
                <td CLASS="cell" bgcolor="#F3F3F3"><IMG  HEIGHT="10" WIDTH="10" SRC="images/blue.JPG" ALT="Should Be Terminated Today" ALIGN="left"><FONT COLOR="red" dir="ltr">Should Be Terminated Today</font></td>
                <td CLASS="cell" bgcolor="#F3F3F3"><IMG  HEIGHT="10" WIDTH="10" SRC="images/green.JPG" ALT="Normal Case" ALIGN="left"><FONT COLOR="red" dir="ltr">Late Work</font></td>
            </tr>
            <tr>
                <td CLASS="cell" bgcolor="#F3F3F3"><IMG SRC="images/assign.gif" ALT="UnTerminated Task" ALIGN="left"><FONT COLOR="red" dir="ltr">Unterminated Task</font></td>
                <td CLASS="cell" bgcolor="#F3F3F3"><IMG SRC="images/nonconfig.gif"  ALT="Un configure Schedule"><FONT COLOR="red" dir="ltr"> Unconfigure Schedule</font></td>
                <td CLASS="cell" bgcolor="#F3F3F3"><IMG  HEIGHT="10" WIDTH="10" SRC="images/yello.JPG"  ALT="Emergency" ALIGN="left"><FONT COLOR="red" dir="ltr">Emergency</font></td>
                <td CLASS="cell" bgcolor="#F3F3F3"><IMG  HEIGHT="10" WIDTH="10" SRC="images/white.JPG" ALT="Normal Case" ALIGN="left"><FONT COLOR="red" dir="ltr">Normal Case</font></td>
                <td></td>
            </tr>
        </table><br>
        
        <TABLE WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
            <TR CLASS="head">
                <TD nowrap CLASS="firstname" WIDTH="100" STYLE="border-top-WIDTH:0; font-size:12" nowrap><%=issueTitle[1]%></TD>
                <TD nowrap CLASS="firstname" WIDTH="100" STYLE="border-top-WIDTH:0; font-size:12" nowrap>Job Expected End Date</TD>
                <%
                for(int i = 2;i<t;i++) {
        if(i!=5 && i!=6 && i!=7 && i!=8){
                %>
                <TD nowrap CLASS="firstname" WIDTH="100" STYLE="border-top-WIDTH:0; font-size:12" nowrap><%=issueTitle[i]%></TD>
                <%
                }
                }
                %>
                <td nowrap  colspan="2" align="Center" CLASS="firstname" WIDTH="60" STYLE="border-top-WIDTH:0; font-size:12" nowrap>Indicators</td>
            </TR>
            
            <tbody id="planetData2">  
                <%
                Enumeration e = issuesVector.elements();
                
                while(e.hasMoreElements()) {
                    iTotal++;
                    wbo = (WebBusinessObject) e.nextElement();
                    webIssue = (WebIssue) wbo;
                    unitScheduleWbo = (WebBusinessObject) unitScheduleMgr.getOnSingleKey(webIssue.getAttribute("unitScheduleID").toString());
                    
                    //Calculate Dates
                    String issueBD = wbo.getAttribute("expectedBeginDate").toString();
                    java.sql.Date scheduleBeginDate = new java.sql.Date(new Integer(issueBD.substring(0,4)).intValue()-1900, new Integer(issueBD.substring(5,7)).intValue()-1, new Integer(issueBD.substring(8)).intValue());
                                                
                    issueID = (String) wbo.getAttribute("id");
                    ScheduleUnitId = issueMgr.getScheduleUnitId(issueID);
                    MaintenanceTitle= issueMgr.getMaintenanceTitle(ScheduleUnitId);
                    
                    if(wbo.getAttribute("expectedBeginDate").toString().equals(todayDate.toString()) && (wbo.getAttribute("currentStatus").toString().equals("FINISHED") != true) && (wbo.getAttribute("issueType").toString().equals("Emergency") != true)){
                        bgColor = "FFCBE1";
                        cellColor = "FFCBE1";
                    } else if(wbo.getAttribute("issueType").toString().equals("Emergency") && (wbo.getAttribute("currentStatus").toString().equals("FINISHED") != true)){
                        bgColor = "F8FFBA";
                        cellColor = "F8FFBA";
                    } 
                        //else if((wbo.getAttribute("expectedBeginDate").toString().equals(todayDate.toString()) != true) && (wbo.getAttribute("issueType").toString().equals("Emergency") != true) && (wbo.getAttribute("currentStatus").toString().equals("FINISHED") != true) && (wbo.getAttribute("expectedEndDate").toString().equals(todayDate.toString())) && (scheduleBeginDate.before(todayDate) == true)){
                        //bgColor = "C1D2FE";
                        //cellColor = "C1D2FE";
                        //} 
                        else if((scheduleBeginDate.before(todayDate) == true) && (wbo.getAttribute("currentStatus").toString().equalsIgnoreCase("Schedule") == true)){
                        bgColor = "E7F8FE";
                        cellColor = "E7F8FE";
                    } else {
                    bgColor = "WHITE";
                    cellColor = "WHITE";
                }
                %>
                <TR BGCOLOR="<%=bgColor%>">
                    <TD><%=wbo.getAttribute("expectedBeginDate").toString()%></TD>
                    <%
                    if(wbo.getAttribute("expectedEndDate").toString().equals(todayDate.toString()) && (wbo.getAttribute("currentStatus").toString().equalsIgnoreCase("FINISHED") != true)){
                    cellColor =  "C1D2FE";
                    }              
                    %>
                    <TD BGCOLOR="<%=cellColor%>"><%=wbo.getAttribute("expectedEndDate").toString()%></TD>
                    <TD><%=wbo.getAttribute("currentStatus").toString()%></TD>
                    <TD><%=unitScheduleWbo.getAttribute("unitName").toString()%></TD>
                    <TD><%=MaintenanceTitle%></TD>
                    <TD>
                        <%
                        if (webIssue.isTerminal()) {
                        %>
                        <IMG SRC="images/unassign.gif"  ALT="Terminated Task">                   
                        <%
                        } else {
                        %> 
                        <IMG SRC="images/assign.gif"  ALT="UnTerminated Task">
                        <%
                        } 
                        %>
                    </TD>
                    <TD>
                        <%
                        ScheduleUnitId=issueMgr.getScheduleUnitId(issueID);
                        Configure = issueMgr.getConfigure(ScheduleUnitId);
                        if(Configure.equals("Yes")) {
                        %>
                        <IMG SRC="images/config.jpg"  ALT="Configured Schedule"> 
                        <%
                        } else {
                        %> 
                        <IMG SRC="images/nonconfig.gif"  ALT="Un configure Schedule">
                        <% 
                        }
                        %>
                    </TD>
                </TR>
                <%
                }
                %>
            </tbody>
            
            <TR>
                <TD CLASS="total" COLSPAN="6" STYLE="text-align:right;padding-right:5;border-right-width:1;">
                    Total Schedules
                </TD>
                <TD CLASS="total" colspan="1" STYLE="text-align:left;padding-left:5;">
                    
                    <DIV NAME="" ID="">
                        <%=iTotal%>
                    </DIV>
                </TD>
            </TR>
            <TR>
                <%
                ServletContext myContext = session.getServletContext();
                String timerStatus = (String) myContext.getAttribute("timerStatus");
                if(timerStatus.equals("on")) {
                %>
                <TD WIDTH="40" rowspan="2" STYLE="border-bottom: none;border-right:none;">
                <IMG BORDER="0" SRC="images/timer.gif" ONCLICK="" ALT="DI Timer is on">
                <TD WIDTH="135" STYLE="border-bottom: none;border-left:none;HEIGHT: 14px;font-weight:bold;font-size:20;text-align:left;">
                &nbsp; 
                <%
                }
                %>
            </TR>
            
        </TABLE>
    </BODY>
</HTML>