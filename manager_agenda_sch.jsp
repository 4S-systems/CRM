<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="com.tracker.engine.IssueStatusFactory, com.tracker.engine.*,java.text.*,com.docviewer.db_access.*, com.maintenance.db_access.*,com.maintenance.common.ParseSideMenu"%>
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
    Calendar weekCalendar = Calendar.getInstance();
    Calendar beginWeekCalendar = Calendar.getInstance();
    Calendar endWeekCalendar = Calendar.getInstance();

    metaMgr.setMetaData("xfile.jar");
    ParseSideMenu parseSideMenu=new ParseSideMenu();
    Hashtable logos=new Hashtable();
    logos=parseSideMenu.getCompanyLogo("configration"+metaMgr.getCompanyName()+".xml");
    String weeksNo = logos.get("weeksNo").toString();

    int dayOfBack = new Integer(weeksNo).intValue()*7;

    int dayOfWeekValue = weekCalendar.getTime().getDay();
    Calendar beginSecondWeekCalendar = Calendar.getInstance();
    Calendar endSecondWeekCalendar  = Calendar.getInstance();
    beginSecondWeekCalendar = (Calendar) weekCalendar.clone();
    endSecondWeekCalendar = (Calendar) weekCalendar.clone();

    beginSecondWeekCalendar.add(beginWeekCalendar.DATE, - dayOfWeekValue - dayOfBack);
    endSecondWeekCalendar.add(endWeekCalendar.DATE, - dayOfWeekValue);

    java.sql.Date beginSecondInterval =  new java.sql.Date(beginSecondWeekCalendar.getTimeInMillis());
    java.sql.Date endSecondInterval = new java.sql.Date(endSecondWeekCalendar.getTimeInMillis());
    String beginDate = null;
    String endDate = null;

    DateFormat  sqlDateParser = new SimpleDateFormat("yyyy/MM/dd");
    beginDate = sqlDateParser.format(beginSecondInterval);
    endDate = sqlDateParser.format(endSecondInterval);

    session = request.getSession();
    IssueMgr issueMgr = IssueMgr.getInstance();
    UnitScheduleMgr unitScheduleMgr = UnitScheduleMgr.getInstance();
    
    Vector<WebBusinessObject> issuesVector = new Vector();
    WebIssue webIssue = null;
    WebBusinessObject unitScheduleWbo = null;
    
    String context = metaMgr.getContext();
    String issueID = null;
    String MaintenanceTitle=null;
    String ScheduleUnitId=null;
    
    int iTotal = 0;
    
    beginWeekCalendar = (Calendar) weekCalendar.clone();
    endWeekCalendar = (Calendar) weekCalendar.clone();
    
    beginWeekCalendar.add(beginWeekCalendar.DATE, -dayOfWeekValue);
    endWeekCalendar.add(endWeekCalendar.DATE, 6 - dayOfWeekValue);
    
    java.sql.Date beginInterval =  new java.sql.Date(beginWeekCalendar.getTimeInMillis());
    java.sql.Date endInterval = new java.sql.Date(endWeekCalendar.getTimeInMillis());
    
    issuesVector = issueMgr.getIssuesListInRangeBySch(new java.sql.Date(beginWeekCalendar.getTimeInMillis()), new java.sql.Date(endWeekCalendar.getTimeInMillis()),session);
    
    String  stat = (String) request.getSession().getAttribute("currentMode");
    String title, from, to, align, dir, style, Indicators, Quick, important, expectedBegin, expectedEnd, totalTasks;
    String viewD, scheduleCase,executionCase,onHoldCase, fontSize, issueNo, issueTit, equip, issueStatus;
    if(stat.equals("En")){
        title = "(Current Manager Agenda (Weekly";
        from = "From";
        to = "To";
        align = "left";
        dir = "LTR";
        style = "text-align:left";
        Indicators = "Helping";
        Quick="Quick Summary";
        important="Important Data";
        issueNo = "Job Order number";
        issueTit = "Title";
        equip = "Equipment Name";
        issueStatus = "Status";
        expectedBegin = "Expected Begin Date";
        expectedEnd = "Expected End Date";
        totalTasks = "Total Job Order(s)";
        viewD = "View Details";
        scheduleCase ="Not start yet";
        executionCase = "under execution";
        onHoldCase = "On hold";
        fontSize = "3";
    } else {
        title = "&#1575;&#1604;&#1571;&#1580;&#1606;&#1583;&#1607; &#1575;&#1604;&#1571;&#1587;&#1576;&#1608;&#1593;&#1610;&#1607; &#1575;&#1604;&#1581;&#1575;&#1604;&#1610;&#1607;";
        from = "&#1605;&#1606;";
        to = "&#1573;&#1604;&#1609;";
        align = "right";
        dir = "RTL";
        style = "text-align:Right";
        Indicators = "&#1605;&#1587;&#1575;&#1593;&#1583;&#1577;";
        Quick="&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1587;&#1585;&#1610;&#1593;&#1577;";
        important="&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1607;&#1575;&#1605;&#1577;";
        issueNo = "&#1585;&#1602;&#1605; &#1571;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
        issueTit = "&#1593;&#1606;&#1608;&#1575;&#1606; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1607;";
        equip = "&#1573;&#1587;&#1605; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;";
        issueStatus = "&#1575;&#1604;&#1581;&#1575;&#1604;&#1607;";
        expectedBegin = "&#1575;&#1604;&#1608;&#1602;&#1578; &#1575;&#1604;&#1605;&#1578;&#1608;&#1602;&#1593; &#1604;&#1604;&#1576;&#1583;&#1575;&#1610;&#1607;";
        expectedEnd = "&#1575;&#1604;&#1608;&#1602;&#1578; &#1575;&#1604;&#1605;&#1578;&#1608;&#1602;&#1593; &#1604;&#1604;&#1573;&#1606;&#1578;&#1607;&#1575;&#1569;";
        totalTasks = "&#1605;&#1580;&#1605;&#1600;&#1600;&#1600;&#1600;&#1608;&#1593; &#1571;&#1608;&#1575;&#1605;&#1600;&#1600;&#1585; &#1575;&#1604;&#1578;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1588;&#1594;&#1610;&#1604;";
        viewD = "&#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1575;&#1604;&#1578;&#1601;&#1575;&#1589;&#1610;&#1604;";
        scheduleCase ="&#1604;&#1605; &#1610;&#1576;&#1583;&#1571; &#1576;&#1593;&#1583;";
        executionCase = "&#1578;&#1581;&#1578; &#1575;&#1604;&#1578;&#1606;&#1601;&#1610;&#1584;";
        onHoldCase = "&#1578;&#1581;&#1578; &#1575;&#1604;&#1573;&#1585;&#1580;&#1575;&#1569;";
        fontSize = "4";
    }
    %>
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
        function changePage(url){
                window.navigate(url);
        }

        function changeMode(name){
            if(document.getElementById(name).style.display == 'none'){
                document.getElementById(name).style.display = 'block';
            } else {
                document.getElementById(name).style.display = 'none';
            }
        }
        
        function showLaterOrders(){
            var beginDate = document.getElementById("beginDate").value;
            var endDate = document.getElementById("endDate").value;
            var projectName = document.getElementById("projectName").value;
            var statusName = 'Schedule';

            window.navigate('<%=context%>/SearchServlet?op=StatusProjectList&beginDate='+beginDate+'&endDate='+endDate+'&projectName='+projectName+'&statusName='+statusName);
        }

        function showLaterClosedOrders(){
            var beginDate = document.getElementById("beginDate").value;
            var endDate = document.getElementById("endDate").value;
            var projectName = document.getElementById("projectName").value;
            var statusName = 'Finished';

            window.navigate('<%=context%>/SearchServlet?op=getJobOrdersByLateClosed&beginDate='+beginDate+'&endDate='+endDate+'&projectName='+projectName+'&statusName='+statusName);
        }
    </SCRIPT>
    <script src='ChangeLang.js' type='text/javascript'></script>
    <BODY>
        <CENTER>
            <FIELDSET class="set" style="width:96%;" >
                <table class="blueBorder" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <tr>
                        <td style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD">
                            <font color="#006699" size="4"><%=title%></font>
                        </td>
                    </tr>
                </table>
                <DIV align="<%=align%>" style="padding-<%=align%>: 2.5%">
                <TABLE class="blueBorder" DIR="<%=dir%>" CELLPADDING="0" cellspacing="0" style="padding-top: 2px; padding-bottom: 4px; padding-left: 10px; padding-right: 10px; margin-top: 10px; width: auto">
                    <TR>
                        <TD class="backgroundTable" style="border: none">
                            <Font COLOR="FF385C" FACE="verdana" SIZE="<%=fontSize%>"><%=from%></Font>
                            <Font COLOR="black" FACE="verdana" SIZE="2">&ensp;<b><%=beginInterval.toString().substring(0,4)%> - <%=beginInterval.toString().substring(5,7)%> - <%=beginInterval.toString().substring(8,10)%></b>&ensp;</Font>
                            <Font COLOR="FF385C" FACE="verdana" SIZE="<%=fontSize%>"><%=to%></Font>
                            <Font COLOR="black" FACE="verdana" SIZE="2">&ensp;<b><%=endInterval.toString().substring(0, 4)%> - <%=endInterval.toString().substring(5, 7)%> - <%=endInterval.toString().substring(8,10)%></b></Font>
                        </TD>
                    </TR>
                </TABLE>
                </DIV> </br>
                <TABLE class="blueBorder" align="center" DIR="<%=dir%>" WIDTH="100%" CELLPADDING="0" cellspacing="0">
                    
                    <TR>
                        <TD CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En"))?"12px":"14px"%>; font-weight: bold; height: 25px" width="13%"><b><%=issueNo%></b></TD>
                        <TD CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En"))?"12px":"14px"%>; font-weight: bold; height: 25px" width="24%"><b><%=issueTit%></b></TD>
                        <TD CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En"))?"12px":"14px"%>; font-weight: bold; height: 25px" width="24%"><b><%=equip%></b></TD>
                        <TD CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En"))?"12px":"14px"%>; font-weight: bold; height: 25px" width="7%"><b><%=issueStatus%></b></TD>
                        <TD CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En"))?"12px":"14px"%>; font-weight: bold; height: 25px" width="11%"><b><%=expectedBegin%></b></TD>
                        <TD CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En"))?"12px":"14px"%>; font-weight: bold; height: 25px" width="11%"><b><%=expectedEnd%></b></TD>
                        <td CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En"))?"12px":"14px"%>; font-weight: bold; height: 25px" width="10%"><b>&nbsp;</b></td>
                    </TR>
                    <tbody  id="planetData2">
                        <%
                        for(WebBusinessObject wbo : issuesVector) {
                            webIssue = (WebIssue) wbo;
                            unitScheduleWbo = (WebBusinessObject) unitScheduleMgr.getOnSingleKey(webIssue.getAttribute("unitScheduleID").toString());

                            issueID = (String) wbo.getAttribute("id");
                            String sBID =wbo.getAttribute("businessID").toString();
                            String sBIDByDate =wbo.getAttribute("businessIDbyDate").toString();
                            ScheduleUnitId = issueMgr.getScheduleUnitId(issueID);
                            MaintenanceTitle= issueMgr.getMaintenanceTitle(ScheduleUnitId);

                            if(!wbo.getAttribute("currentStatus").toString().equals("Finished") && !wbo.getAttribute("currentStatus").toString().equals("Canceled") && !wbo.getAttribute("currentStatus").toString().equals("Removed")){
                             iTotal++;
                            %>
                        <TR style="cursor: pointer" onmouseover="this.className = 'rowHilight'" onmouseout="this.className = ''">
                            <TD class="blueBorder blueBodyTD" STYLE="<%=style%>; padding-<%=align%>: 5px; font-size: 12px"><Font color="red"><%=sBID%></Font><Font color="blue">/<%=sBIDByDate%></Font></TD>
                            <TD class="blueBorder blueBodyTD" STYLE="<%=style%>; padding-<%=align%>: 5px; font-size: 12px"><b><%=MaintenanceTitle%></b></TD>
                            <TD class="blueBorder blueBodyTD" STYLE="<%=style%>; padding-<%=align%>: 5px; font-size: 12px"><b><%=unitScheduleWbo.getAttribute("unitName").toString()%></b></TD>
                            <%  if (wbo.getAttribute("currentStatus").toString().equals("Schedule")){ %>
                                    <TD class="blueBorder blueBodyTD" STYLE="<%=style%>; padding-<%=align%>: 5px; font-size: 12px"><b><%=scheduleCase%></b></TD>
                                 <% }else if (wbo.getAttribute("currentStatus").toString().equals("Assigned")){%>
                                    <TD class="blueBorder blueBodyTD" STYLE="<%=style%>; padding-<%=align%>: 5px; font-size: 12px"><b><%=executionCase%></b></TD>
                                <% }else if (wbo.getAttribute("currentStatus").toString().equals("Onhold")){%>
                                <TD class="blueBorder blueBodyTD" STYLE="<%=style%>; padding-<%=align%>: 5px; font-size: 12px"><b><%=onHoldCase%></b></TD>
                                <% } %>

                            <TD class="blueBorder blueBodyTD" STYLE="<%=style%>; padding-<%=align%>: 5px; font-size: 12px"><b><%=wbo.getAttribute("expectedBeginDate").toString()%></b></TD>
                            <TD class="blueBorder blueBodyTD" STYLE="<%=style%>; padding-<%=align%>: 5px; font-size: 12px"><b><%=wbo.getAttribute("expectedEndDate").toString()%></b></TD>
                            <TD class="blueBorder blueBodyTD"><b><A HREF="<%=webIssue.getViewDetailLink()%>"><font color="blue"><%=viewD%></font></A></b></TD>
                        </TR>
                        <% } } %>
                    </tbody>
                    <TR>
                        <TD CLASS="blueBorder blueBodyTD" BGCOLOR="#808080" COLSPAN="6" STYLE="text-align:center;color:white;Font-size:16px;">
                            <b><%=totalTasks%></b>
                        </TD>
                        <TD CLASS="blueBorder blueBodyTD" BGCOLOR="#808080" colspan="1" STYLE="text-align:center;color:white;Font-size:14px;">
                            <B><%=iTotal%></B>
                        </TD>
                    </TR>
                </TABLE>
                <input type="hidden" name="beginDate" id="beginDate" value="<%=beginDate%>">
                <input type="hidden" name="endDate" id="endDate" value="<%=endDate%>">
                <input type="hidden" name="projectName" id="projectName" value="All">
                <input type="hidden" name="statusName" id="statusName" value="Schedule">
                <BR>
            </FIELDSET>
        </CENTER>
    </BODY>
</HTML>