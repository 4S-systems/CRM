<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*"%>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide, com.contractor.db_access.MaintainableMgr"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants, com.maintenance.db_access.*"%>
<%@ page import="com.silkworm.common.TimeServices,com.silkworm.jsptags.*, com.tracker.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<%
MetaDataMgr metaMgr = MetaDataMgr.getInstance();
TradeMgr tradeMgr = TradeMgr.getInstance();
TaskTypeMgr taskTypeMgr = TaskTypeMgr.getInstance();
MaintainableMgr maintainableMgr = MaintainableMgr.getInstance();
IssueMgr issueMgr = IssueMgr.getInstance();
DateAndTimeControl dateAndTime = new DateAndTimeControl();

String context = metaMgr.getContext();

//Get request data
String filterName = request.getParameter("filterName");
String filterValue = request.getParameter("filterValue");

ArrayList issueTasksAL = (ArrayList)request.getAttribute("issueTasks");
String issueId = request.getAttribute("issueId").toString();

//Get Issue WebBusinessObject
WebBusinessObject issueWbo = issueMgr.getOnSingleKey(issueId);

String cMode= (String) request.getSession().getAttribute("currentMode");
String stat=cMode;
String align=null;
String dir=null;
String style=null;
String cellAlign=null;
String lang, langCode, back, title, JOData, JONo, forEqp, taskCode, taskName, workingTrade,
        mainType, expectedHours, source, noTasks,engDesc , duration ,  sMinute , sHour ,sDay ;

if(stat.equals("En")){
    align="center";
    dir="LTR";
    style="text-align:left";
    cellAlign="left";
    lang="&#1593;&#1585;&#1576;&#1610;";
    langCode="Ar";
    
    back = "Back";
    title = "Job Order maintenance tasks";
    JOData = "Job Order Data";
    JONo = "Job Order Number";
    forEqp = "Equipment Name";
    taskCode = "Task Code";
    taskName = "Task Name";
    workingTrade = "Working Trade";
    mainType = "Maintenance Type";
    expectedHours = "Expected Minutes";
    source = "Source";
    noTasks = "No Job Order Tasks";
    engDesc="English Description";
       duration="Expected Duration";
         sMinute = "Minute";
    sHour = "Hour";
    sDay = "Day";
}else{
    align="center";
    dir="RTL";
    style="text-align:right";
    cellAlign="right";
    lang="English";
    langCode="En";
    
    back = "&#1575;&#1604;&#1593;&#1608;&#1583;&#1577;";
    title = "&#1576;&#1606;&#1608;&#1583; &#1589;&#1610;&#1575;&#1606;&#1577; &#1571;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
    JOData = "&#1576;&#1610;&#1575;&#1606;&#1575;&#1578; &#1571;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
    JONo = "&#1585;&#1602;&#1605; &#1571;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
    forEqp = "&#1575;&#1587;&#1605; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577;";
    taskCode = "&#1603;&#1608;&#1583; &#1576;&#1606;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1607;";
    taskName = "&#1573;&#1587;&#1605; &#1575;&#1604;&#1576;&#1606;&#1583;";
    workingTrade = "&#1575;&#1604;&#1605;&#1580;&#1605;&#1608;&#1593;&#1577; &#1575;&#1604;&#1601;&#1606;&#1610;&#1577;";
    mainType = "&#1606;&#1608;&#1593; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
    expectedHours = "&#1575;&#1604;&#1600;&#1583;&#1602;&#1600;&#1600;&#1575;&#1574;&#1600;&#1600;&#1602; &#1575;&#1604;&#1600;&#1605;&#1600;&#1578;&#1600;&#1608;&#1602;&#1600;&#1593;&#1600;&#1607;";
    source = "&#1575;&#1604;&#1605;&#1589;&#1583;&#1585;";
    noTasks = "&#1604;&#1575;&#1610;&#1608;&#1580;&#1583; &#1576;&#1606;&#1608;&#1583; &#1589;&#1610;&#1575;&#1606;&#1577;";
    engDesc="&#1575;&#1604;&#1608;&#1589;&#1601; &#1575;&#1604;&#1575;&#1606;&#1580;&#1604;&#1610;&#1586;&#1609;";
     duration="&#1605;&#1578;&#1608;&#1587;&#1591; &#1575;&#1604;&#1605;&#1583;&#1607;";
     sMinute = "&#1583;&#1602;&#1610;&#1602;&#1577;";
    sHour = "&#1587;&#1575;&#1593;&#1577;";
    sDay = "&#1610;&#1608;&#1605;";
}
%>

<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">   
    function cancelForm(){    
        document.Backform.submit();
    }
</SCRIPT>

<HTML>
    <meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <meta HTTP-EQUIV="Expires" CONTENT="0">
    
    <head>
        <link REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <link rel="stylesheet" type="text/css" href="autosuggest.css" />
    </head>
    
    <BODY>
        <CENTER>
            <DIV align="left" STYLE="color:blue;">
                <form name="Backform" action="<%=context%>/AssignedIssueServlet?op=VIEWDETAILS&issueId=<%=issueId%>&filterName=<%=filterName%>&filterValue=<%=filterValue%>&projectName=<%=request.getAttribute("projectName")%>" method="post">
                    <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
                    <button onclick="cancelForm();" class="button"><%=back%> <IMG VALIGN="BOTTOM"  HEIGHT="15" SRC="images/cancel.gif"> </button>
                    <input type="hidden" name="mainTitle" id="mainTitle" value="<%=request.getAttribute("mainTitle")%>">
                </form>
            </DIV>
     
             <FIELDSET class="set" style="width:95%;border-color: #006699;" >
                    <TABLE class="blueBorder" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                        <TR>
                            <TD style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD"><font color="#F3D596" size="4"><%=title%></font></TD>
                        </TR>
                    </TABLE>
                
                <br>
                <TABLE ALIGN="<%=align%>" DIR="<%=dir%>" WIDTH="500" class="blueBorder" CELLPADDING="0" CELLSPACING="0" >
              
                    <TR>
                        <TD class="blueBorder backgroundHeader blueHeaderTD" style="text-align:center" COLSPAN="4" >
                    
                            <B><%=JOData%></B>                   
                        </TD>
                    </TR>
                    <TR>
                    
                   <TD class="blueBorder backgroundHeader blueHeaderTD" style="text-align:center" >
                            <b><%=JONo%></b>
                        </TD>
                        <TD CLASS="cell" STYLE="text-align:center;font-size:16;color:red;border-right-width:1px" WIDTH="300">
                            <b><%=issueWbo.getAttribute("businessID").toString().concat("/").concat(issueWbo.getAttribute("businessIDbyDate").toString())%></b>                              
                        </TD>
                    
                    </TR>
                    <tr>
                         <TD class="blueBorder backgroundHeader blueHeaderTD" style="text-align:center" >
                            <b><%=forEqp%></b>
                        </TD>
                        <TD CLASS="cell" STYLE="text-align:center;font-size:16;color:red;border-right-width:1px" WIDTH="300">
                            <b><%=issueWbo.getAttribute("issueType").toString()%></b>
                        </TD>
                    </tr>
                  
                </TABLE>
                <br>
                
                
                
                
                  <TABLE class="blueBorder" ALIGN="<%=align%>" DIR="<%=dir%>" cellpadding="0" cellspacing="0" WIDTH=98%  ID="listTable">
                    <TR>
                      
                        <TD CLASS="blueBorder backgroundHeader blueHeaderTD" WIDTH="10%" rowspan="2" style="height: 10px;"> 
                               <B>#</B>
                        </TD>
                        <TD CLASS="blueBorder backgroundHeader blueHeaderTD" WIDTH="20%" rowspan="2" style="height: 18px;">
                              <B><%=taskCode%></B>
                        </TD>
                        <TD CLASS="blueBorder backgroundHeader blueHeaderTD" WIDTH="15%" rowspan="2" style="height: 15px;">
                             <B><%=taskName%></B>
                        </TD>
                        <%--TD CLASS="blueBorder blueHeaderTD grayStyle" WIDTH="15%" colspan="2" style="height: 15px;"><b><%=sEstimatedTime%> </b></TD--%>
                        <TD CLASS="blueBorder backgroundHeader blueHeaderTD" WIDTH="10%" rowspan="2" style="height: 17px;">
                               <B><%=workingTrade%></B>
                        </TD>
                        <TD CLASS="blueBorder backgroundHeader blueHeaderTD" WIDTH="18%" rowspan="2" style="height: 15px;">
                            <B><%=mainType%></B>
                        </TD>
                        <TD CLASS="blueBorder backgroundHeader blueHeaderTD" WIDTH="12%" colspan="3" style="height: 15px;">
                               <B><%=duration%></B>
                        </TD>
                        <TD CLASS="blueBorder backgroundHeader blueHeaderTD" WIDTH="5%" rowspan="2" style="height: 15px;">
                                 <B><%=engDesc%></B>
                        </TD>
                        <TD CLASS="blueBorder backgroundHeader blueHeaderTD" WIDTH="10%" rowspan="2" style="height: 15px;">
                                   <B><%=source%></B>
                        </TD>  
                    </TR>
                    <TR>
                        <TD CLASS="blueBorder backgroundHeader blueHeaderTD" WIDTH="4%" style="height: 15px;">
                            <b><%=sMinute%></b>
                        </TD>
                        <TD CLASS="blueBorder backgroundHeader blueHeaderTD" WIDTH="4%" style="height: 15px;">
                            <b><%=sHour%></b>
                        </TD>
                        <TD CLASS="blueBorder backgroundHeader blueHeaderTD" WIDTH="4%" style="height: 15px;">
                            <b><%=sDay%></b>
                        </TD>
                        
                    </TR>
                
                
                    
                
                
                
                
                
                
                    
                    <%
                    if(issueTasksAL.size()==0 || issueTasksAL== null){
                    %>
                    <TR>
                        <TD COLSPAN="8" bgcolor="white" STYLE="text-align:center;font-size:14; border-width:1px;color:red">
                            <B><%=noTasks%></B>
                        </TD>
                    </TR>
                    <%} else {
                    for(int i=0;i<issueTasksAL.size();i++){
                    %>
                    <%
                    WebBusinessObject issueTaskWbo = (WebBusinessObject) issueTasksAL.get(i);
                    WebBusinessObject tradeWbo = tradeMgr.getOnSingleKey(issueTaskWbo.getAttribute("trade").toString());
                    WebBusinessObject taskTypeWbo = taskTypeMgr.getOnSingleKey(issueTaskWbo.getAttribute("taskType").toString()) ;
                    String bgColor = null;
                    
                    if(issueTaskWbo.getAttribute("source").toString().equalsIgnoreCase("complaint")){
                        bgColor = "lightcyan";
                    } else {
                        bgColor = "lightblue";
                    }
                    %>
                     <TR style="cursor: pointer"  onmouseover="this.className = 'rowHilight'" onmouseout="this.className = ''">
                            <td class="blueBorder blueBodyTD" style="text-align:center" align="<%=align%>">
                         
                            <%=i+1%>
                        </TD>
                        <td class="blueBorder blueBodyTD" style="text-align:center" align="<%=align%>">
                            <A  HREF="<%=context%>/TaskServlet?op=printTaskForm&taskId=<%=issueTaskWbo.getAttribute("id").toString()%>">
                            <%=issueTaskWbo.getAttribute("title").toString()%>
                             </A>
                        </TD>
                        <td class="blueBorder blueBodyTD" style="text-align:center" align="<%=align%>">
                            <%=issueTaskWbo.getAttribute("name").toString()%>
                        </TD>
                       <td class="blueBorder blueBodyTD" style="text-align:center" align="<%=align%>">
                            <%=tradeWbo.getAttribute("tradeName").toString()%>
                        </TD>
                        <td class="blueBorder blueBodyTD" style="text-align:center" align="<%=align%>">
                            <%=taskTypeWbo.getAttribute("name").toString()%>
                        </TD>
                       <td class="blueBorder blueBodyTD" style="text-align:center" align="<%=align%>">
                            <% 
                                int day =0;
                                int minute=0;
                                int hour =0;
                                String exeHours = issueTaskWbo.getAttribute("executionHrs").toString();
                                double doub = Double.parseDouble(exeHours);
                                int exehour = (int) doub;
                                day = (exehour/ 60)/24;
                                hour =( exehour - day*24*60)/60;
                                minute = exehour - day*24*60 - hour*60;
                            %>
                            <%=minute%>
                            
                        </TD>
                        <td class="blueBorder blueBodyTD" style="text-align:center" align="<%=align%>">
                        <%=hour%>
                        </td>
                        <td class="blueBorder blueBodyTD" style="text-align:center" align="<%=align%>">
                        <%=day%>
                        </td>
                        <td class="blueBorder blueBodyTD" style="text-align:center" align="<%=align%>">
                            <%if(issueTaskWbo.getAttribute("engDesc")!=null){%>
                            <%=issueTaskWbo.getAttribute("engDesc").toString()%>
                            <%}else{%>
                            No Description
                            <%}%>
                        </TD>
                        <td class="blueBorder blueBodyTD" style="text-align:center" align="<%=align%>">
                            <%=issueTaskWbo.getAttribute("source").toString()%>
                        </TD>
                    </TR>
                    <%
                    }
                    }
                    %>
                </TABLE>
                <br>
            </fieldset>
        </CENTER>
    </BODY>
</html>