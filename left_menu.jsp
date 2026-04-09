<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="com.tracker.engine.IssueStatusFactory, com.tracker.engine.*,com.docviewer.db_access.*, com.maintenance.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %> 
<%@ page pageEncoding="UTF-8"%>
<HTML>
    <meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <meta HTTP-EQUIV="Expires" CONTENT="0">
    <head>
        <title>Weekly Manager Agenda</title>
        
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/Button.css">
        
        <link rel="stylesheet" type="text/css" href="css/tabcontent.css" />
        
        
    </head>
    
    <%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    Calendar weekCalendar = Calendar.getInstance();
    Calendar beginWeekCalendar = Calendar.getInstance();
    Calendar endWeekCalendar = Calendar.getInstance();
    IssueMgr issueMgr = IssueMgr.getInstance();
    ImageMgr imageMgr = ImageMgr.getInstance();
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
    
    beginWeekCalendar.add(beginWeekCalendar.DATE, -dayOfWeekValue);
    endWeekCalendar.add(endWeekCalendar.DATE, 6 - dayOfWeekValue);
    
    java.sql.Date beginInterval =  new java.sql.Date(beginWeekCalendar.getTimeInMillis());
    java.sql.Date endInterval = new java.sql.Date(endWeekCalendar.getTimeInMillis());
    java.sql.Date todayDate = new java.sql.Date(weekCalendar.getTimeInMillis());
    
    issuesVector = issueMgr.getIssuesListInRange(new java.sql.Date(beginWeekCalendar.getTimeInMillis()), new java.sql.Date(endWeekCalendar.getTimeInMillis()));
    
    String  stat = (String) request.getSession().getAttribute("currentMode");
    String title, from, to, align, dir, style, lang, langCode, Indicators, startToday, endToday, terminatedTask, unterminatedTask, configuredTask, unconfigureTask, emergency, normalCase, pressForAutoTasks, Quick, important, expectedBegin, expectedEnd, totalTasks;
    if(stat.equals("En")){
        title = "(Current Manager Agenda (Weekly";
        from = "From";
        to = "To";
        align = "center";
        dir = "RTL";
        style = "text-align:left";
        lang = "   &#1593;&#1585;&#1576;&#1610;    ";
        langCode = "Ar";
        Indicators = "Indicators Guide";
        startToday = "Should Be Begin Today";
        endToday = "Should Be Terminated Today";
        terminatedTask = "Terminated Task";
        unterminatedTask = "Unterminated Task";
        configuredTask = "Configured Task";
        unconfigureTask = "Unconfigure Task";
        emergency = "Emergency";
        normalCase = "Normal Case";
        pressForAutoTasks = "Press here for Auto Tasks";
        Quick="Quick Summary";
        important="Important Data";
        issueTitle[4] = "Title";
        issueTitle[3] = "Equipment Name";
        issueTitle[2] = "Status";
        expectedBegin = "Expected Begin Date";
        expectedEnd = "Expected End Date";
        totalTasks = "Total Tasks";
    } else {
        title = "&#1575;&#1604;&#1571;&#1580;&#1606;&#1583;&#1607; &#1575;&#1604;&#1571;&#1587;&#1576;&#1608;&#1593;&#1610;&#1607; &#1575;&#1604;&#1581;&#1575;&#1604;&#1610;&#1607;";
        from = "&#1605;&#1606;";
        to = "&#1573;&#1604;&#1609;";
        align = "center";
        dir = "LTR";
        style = "text-align:Right";
        lang = "English";
        langCode = "En";
        Indicators = "&#1575;&#1604;&#1605;&#1585;&#1588;&#1583; &#1575;&#1604;&#1605;&#1589;&#1608;&#1585;";
        startToday = "&#1575;&#1604;&#1576;&#1583;&#1575;&#1610;&#1607; &#1575;&#1604;&#1610;&#1608;&#1605;";
        endToday = "&#1575;&#1604;&#1606;&#1607;&#1575;&#1610;&#1607; &#1575;&#1604;&#1610;&#1608;&#1605;";
        terminatedTask = "&#1605;&#1607;&#1605;&#1607; &#1604;&#1605; &#1578;&#1606;&#1578;&#1607;&#1610; &#1576;&#1593;&#1583;";
        unterminatedTask = "&#1605;&#1607;&#1605;&#1607; &#1605;&#1606;&#1578;&#1607;&#1610;&#1607;";
        configuredTask = "&#1605;&#1585;&#1578;&#1576;&#1591; &#1576;&#1602;&#1591;&#1593; &#1594;&#1610;&#1575;&#1585;";
        unconfigureTask = "&#1594;&#1610;&#1585; &#1605;&#1585;&#1578;&#1576;&#1591; &#1576;&#1602;&#1591;&#1593; &#1594;&#1610;&#1575;&#1585;";
        emergency = "&#1591;&#1608;&#1575;&#1585;&#1574;";
        normalCase = "&#1575;&#1604;&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1591;&#1576;&#1610;&#1593;&#1610;&#1607;";
        pressForAutoTasks = "&#1573;&#1590;&#1594;&#1591; &#1607;&#1606;&#1575; &#1604;&#1580;&#1583;&#1608;&#1604;&#1577;  &#1604;&#1604;&#1605;&#1575;&#1603;&#1610;&#1606;&#1575;&#1578; &#1575;&#1604;&#1571;&#1578;&#1608;&#1605;&#1575;&#1578;&#1610;&#1603;&#1610;&#1607;";
        Quick="&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1587;&#1585;&#1610;&#1593;&#1577;";
        important="&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1607;&#1575;&#1605;&#1577;";
        issueTitle[4] = "&#1593;&#1606;&#1608;&#1575;&#1606; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1607;";
        issueTitle[3] = "&#1573;&#1587;&#1605; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;";
        issueTitle[2] = "&#1575;&#1604;&#1581;&#1575;&#1604;&#1607;";
        expectedBegin = "&#1575;&#1604;&#1608;&#1602;&#1578; &#1575;&#1604;&#1605;&#1578;&#1608;&#1602;&#1593; &#1604;&#1604;&#1576;&#1583;&#1575;&#1610;&#1607;";
        expectedEnd = "&#1575;&#1604;&#1608;&#1602;&#1578; &#1575;&#1604;&#1605;&#1578;&#1608;&#1602;&#1593; &#1604;&#1604;&#1573;&#1606;&#1578;&#1607;&#1575;&#1569;";
        totalTasks = "&#1605;&#1580;&#1605;&#1608;&#1593; &#1575;&#1604;&#1580;&#1583;&#1575;&#1608;&#1604;";
    }
    %>
    <script type="text/javascript" src="js/tabcontent.js">
    <script src='js/ChangeLang.js' type='text/javascript'></script>
    <script language="JavaScript">
    function changeMode(image1){
    document.getElementById(image1).src ="images/lft.png";
    }
    
    function changeMode2(image1){
    document.getElementById(image1).src ="images/aro.png";
    }
    </script>
    
    <BODY BGCOLOR="silver">
        <div align="right" onclick="window.navigate('main.jsp')" style="margin-right:-2px">
            <IMG ALIGN="right" id=ig onclick="if ((document.all||document.getElementById)&&window.parent.pull) window.parent.pull() " ondblclick="if ((document.all||document.getElementById)&&window.parent.pull) window.parent.draw()" STYLE="margin-right:0px;padding-right:0px" SRC="images/aro.png"  WIDTH="25" HEIGHT="40" ALT="Show Manager Agenda">
        </div>
        
        <div id="countrytabs"  class="modernbricksmenu2" >
            <ul>
                
                <li ><a href="#" rel="country1" class="selected">  <font color="white"> <%=title%> </font></a></li>
                <li ><a href="#" rel="country2">&#1588;&#1580;&#1585;&#1577; &#1575;&#1604;&#1605;&#1593;&#1583;&#1575;&#1578;      </a></li>
                <li  ><a href="#" rel="country3"> &#1575;&#1604;&#1580;&#1583;&#1575;&#1608;&#1604; &#1575;&#1604;&#1605;&#1578;&#1571;&#1582;&#1585;&#1607;     </a></li>
            </ul>
        </div>            
        <div style="text-align:center;border:1px solid gray; width:100%; margin-bottom: 1em;background-color:white; padding: 10px">
            
            <div id="country1" class="tabcontent">
                
                <DIV align="left" STYLE="color:blue;">
                    <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
                    
                </DIV> 
                
                <fieldset  class="set" >
                    <legend align="center">
                        <table dir="rtl" align="center">
                            <tr>                                    
                                <td class="td">
                                    <font color="blue" size="6">    <%=title%>          
                                    </font>
                                    
                                </td>
                            </tr>
                        </table>
                    </legend>
                    
                    <DIV ALIGN="CENTER"><Font COLOR="FF385C" FACE="verdana" SIZE="+2"><b></b></FONT></DIV><br>
                    <DIV ALIGN="CENTER"><Font COLOR="FF385C" FACE="verdana" SIZE="+1">  <%=from%>  </FONT><b><%=beginInterval.toString().substring(0,4)%> - <%=beginInterval.toString().substring(5,7)%> - <%=beginInterval.toString().substring(8,10)%>  </b> <Font COLOR="FF385C" FACE="verdana" SIZE="+1"> <%=to%>  </FONT><b><%=endInterval.toString().substring(0, 4)%> - <%=endInterval.toString().substring(5, 7)%> - <%=endInterval.toString().substring(8,10)%> </b></DIV><br>
                    
                    
                    <!--table align="center" dir="<%=dir%>">
                    <Th COLSPAN="7" ALIGN="<%=align%>" WIDTH="800" rowspan="2" STYLE="border-up: none;border-left:none;">
                    <%
                    ServletContext myContext = session.getServletContext();
                    String timerStatus = (String) myContext.getAttribute("timerStatus");
                    if(timerStatus.equals("on")) {
                    %>
                    
                    <A HREF="<%=context%>/AverageUnitServlet?op=GetTEST">
                        
                    <font color="blue" size="2"><%=pressForAutoTasks%></font>
                        <IMG BORDER="0" SRC="images/timer.gif" ONCLICK="" ALT="DI Timer is on">
                    </A>
                    
                    
                    <%
                    }
                    %>
                </Th>
                
            </table-->
                    <!--table>
                <tr>
                    <td>
                        <a href='/C:/Program Files/Alwil Software/Avast4/ashAvast.exe'>test</a>
                    </td>
                </tr>
            </table-->
                       
                    <TABLE ALIGN="center" WIDTH="100%" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;" DIR="<%=dir%>">
                        <TR>
                            <TD CLASS="td" WIDTH="100px" COLSPAN="2" bgcolor="#CC9900" STYLE="text-align:center;color:white;font-size:16">
                                <B><%=Indicators%></B>
                            </TD>
                            <TD CLASS="td" COLSPAN="2" bgcolor="#669900" STYLE="text-align:center;color:white;font-size:16">
                                <B><%=important%></B>
                            </TD>
                            <TD CLASS="td" COLSPAN="3" bgcolor="#808000" STYLE="text-align:center;color:white;font-size:16">
                                <B><%=Quick%></B>
                            </TD>
                        </TR>
                        
                        <TR CLASS="head">
                            <td CLASS="firstname" colspan="2" bgcolor="#FFBF00" STYLE="border-WIDTH:0; font-size:12;color:white;"><center>&nbsp;</center></td>
                            <TD nowrap CLASS="firstname" WIDTH="100" STYLE="border-top-WIDTH:0; font-size:12;color:white;" BGCOLOR="#7EBB00" nowrap><%=expectedBegin%></TD>
                            <TD nowrap CLASS="firstname" WIDTH="100" STYLE="border-top-WIDTH:0; font-size:12;color:white;" BGCOLOR="#7EBB00" nowrap><%=expectedEnd%></TD>
                            <%
                            for(int i = 2;i<t;i++) {
                        if(i!=5 && i!=6 && i!=7 && i!=8){
                            %>
                            <TD nowrap CLASS="firstname" WIDTH="100" STYLE="border-top-WIDTH:0; font-size:12;color:white;" bgcolor="#9B9B00" nowrap><%=issueTitle[i]%></TD>
                            <%
                            }
                            }
                            %>
                            
                        </TR>
                        
                        <tbody  id="planetData2">  
                            <%
                            Enumeration e = issuesVector.elements();
                            
                            while(e.hasMoreElements()) {
                                iTotal++;
                                wbo = (WebBusinessObject) e.nextElement();
                                webIssue = (WebIssue) wbo;
                                unitScheduleWbo = (WebBusinessObject) unitScheduleMgr.getOnSingleKey(webIssue.getAttribute("unitScheduleID").toString());
                                
                                issueID = (String) wbo.getAttribute("id");
                                ScheduleUnitId = issueMgr.getScheduleUnitId(issueID);
                                MaintenanceTitle= issueMgr.getMaintenanceTitle(ScheduleUnitId);
                                
                                if(wbo.getAttribute("expectedBeginDate").toString().equals(todayDate.toString()) && (wbo.getAttribute("currentStatus").toString().equals("FINISHED") != true) && (wbo.getAttribute("issueType").toString().equals("Emergency") != true)){
                                    bgColor = "FFCBE1";
                                    cellColor = "FFCBE1";
                                } else if(wbo.getAttribute("issueType").toString().equals("Emergency") && (wbo.getAttribute("currentStatus").toString().equals("FINISHED") != true)){
                                    bgColor = "F8FFBA";
                                    cellColor = "F8FFBA";
                                } else if((wbo.getAttribute("expectedBeginDate").toString().equals(todayDate.toString()) != true) && (wbo.getAttribute("issueType").toString().equals("Emergency") != true) && (wbo.getAttribute("currentStatus").toString().equals("FINISHED") != true) && (wbo.getAttribute("expectedEndDate").toString().equals(todayDate.toString()))){
                                    bgColor = "C1D2FE";
                                    cellColor = "C1D2FE";
                                } else {
                                    bgColor = "WHITE";
                                    cellColor = "WHITE";
                                }
                            %>
                            <TR BGCOLOR="<%=bgColor%>">
                                <TD WIDTH="30">
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
                                <TD WIDTH="30">
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
                                <TD><%=wbo.getAttribute("expectedBeginDate").toString()%></TD>
                                <%
                                if(wbo.getAttribute("expectedEndDate").toString().equals(todayDate.toString())){
                                        cellColor =  "C1D2FE";
                                }
                                %>
                                <TD BGCOLOR="<%=cellColor%>"><%=wbo.getAttribute("expectedEndDate").toString()%></TD>
                                <TD><%=wbo.getAttribute("currentStatus").toString()%></TD>
                                <TD><%=unitScheduleWbo.getAttribute("unitName").toString()%></TD>
                                <TD><%=MaintenanceTitle%></TD>
                                
                            </TR>
                            <%
                            }
                            %>
                        </tbody>
                        
                        <TR>
                            
                            <TD CLASS="cell" BGCOLOR="#808080" colspan="1" STYLE="text-align:center;padding-left:5;color:white;font-size:14;">
                                
                                <DIV NAME="" ID="">
                                    <B><%=iTotal%></B>
                                </DIV>
                            </TD>
                            <TD CLASS="cell" BGCOLOR="#808080" COLSPAN="6" STYLE="text-align:center;padding-right:5;border-right-width:1;color:white;font-size:14;">
                                <b><%=totalTasks%></b>
                            </TD>
                        </TR>
                        
                    </TABLE>
                    <BR><BR><BR>
                </FIELDSET>
                
            </div>
            
            <div id="country2" class="tabcontent">
                <jsp:include page="Eq_Tree.jsp"></jsp:include>
            </div>
            
            <div id="country3" class="tabcontent">
                <jsp:include page="Delayed_issue.jsp"></jsp:include>
            </div>
            
        </div>
        
        <script type="text/javascript">

var countries=new ddtabcontent("countrytabs")
countries.setpersist(true)
countries.setselectedClassTarget("link") 
countries.init()

        </script>
        
        
        
        
    </BODY>
</HTML>