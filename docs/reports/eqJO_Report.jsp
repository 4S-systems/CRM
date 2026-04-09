<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="java.util.*,com.maintenance.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,java.text.SimpleDateFormat"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="java.text.SimpleDateFormat"%>

<%
TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
MetaDataMgr metaMgr = MetaDataMgr.getInstance();
String context = metaMgr.getContext();

Vector  empList = new Vector();
EmpTasksHoursMgr empTasksHoursMgr =EmpTasksHoursMgr.getInstance();

//Get request data
Vector eqIssues=(Vector)request.getAttribute("equipIssues");
Hashtable allIssueTasks=(Hashtable)request.getAttribute("issueTasks");
Hashtable allIssueParts=(Hashtable)request.getAttribute("issueParts");
WebBusinessObject equipmentWbo=(WebBusinessObject)request.getAttribute("equipmentWbo");
WebBusinessObject issueWbo=new WebBusinessObject();
WebBusinessObject itemWbo=new WebBusinessObject();
WebBusinessObject sparPartWbo=new WebBusinessObject();
Vector issueItems=new Vector();
Vector issueParts=new Vector();
String issueId=null;
String bgcolor="white";

String bDate=(String)request.getAttribute("bDate");
String eDate=(String)request.getAttribute("eDate");

// get report pictures
Hashtable logos=new Hashtable();
logos=(Hashtable)session.getAttribute("logos");

// get current date
Calendar cal = Calendar.getInstance();
Date currentDate=cal.getTime();

int cyear=currentDate.getYear()+1900;
int cmonth=currentDate.getMonth()+1;
int cday=currentDate.getDate();
String age="";
int diffDays=0;
int diffMonths=0;
int diffYears=0;

String servDate=(String)equipmentWbo.getAttribute("serviceEntryDATE");
if(servDate!=null){
    java.sql.Date sqlServiceDate=java.sql.Date.valueOf(servDate);
    
    int sYear=sqlServiceDate.getYear()+1900;
    int sMonth=sqlServiceDate.getMonth()+1;
    int sDay=sqlServiceDate.getDate();
    
    diffDays=cday-sDay;
    diffMonths=cmonth-sMonth;
    diffYears=cyear-sYear;
    
    if(diffDays<0){
        diffDays+=30;
        diffMonths--;
    }if(diffMonths<0){
        diffMonths+=12;
        diffYears--;
    }
}
WebBusinessObject catWbo=new WebBusinessObject();
String cMode = (String) request.getSession().getAttribute("currentMode");
String stat = "Ar";
String align = "center";
String dir = null;
String style = null;
String lastReadingDate = null;
String headerItem = null;
String bgColor="#c8d8f8";
String status=null;
String lang,langCode, cancel, title;
String totalJO,eqNum,cost,enterWorkDate,lastReading;
String mainInfo,maintItems,spareParts,eqName,joNum,serviceEntryDATE,numHours,startWokingDate,actualEndDate,joName,eqJO,eqAge,exBDate,exEDate,schName;
String joStartDate,joEndDate,joDate,notStarted,notFinished,beginDate,endDate,partName,partCode,taskName,empName,workers,empCode;
if(stat.equals("En")){
    align="left";
    dir = "LTR";
    style = "text-align:right";
    lang = "&#1593;&#1585;&#1576;&#1610;";
    langCode = "Ar";
    cancel = "Cancel";
    title="Equipment Status Reprot";
    mainInfo="Equipment Main Information";
    maintItems="Maintenance Items";
    spareParts="Spare Parts";
    eqName="Equipment Name";
    joNum="Job Order Number";
    numHours="Number of Hours";
    startWokingDate="Start working Date";
    actualEndDate="Actual End Date";
    joName="Job Order Title";
    eqJO="Equipment Job Orders";
    eqNum="Equipment Number";
    cost="Cost";
    lastReading="Equipment Last Reading";
    enterWorkDate="Equipment Start Working in ";
    totalJO="Total Equipment Job orders Up To Date";
    serviceEntryDATE="Equipment Entering Date";
    eqAge="Equipment Age";
    cost="Cost";
    schName="Schedule Name";
    exBDate="Expected Begin Date";
    exEDate="Expected End Date";
    joDate="Job Order Date";
    joStartDate="Job Order Begin Date";
    joEndDate="Job Order End Date";
    notStarted="Not Started Yet";
    notFinished="Not Finished yet";
    beginDate="From Date";
    endDate="To Date";
    partName="Part Name";
    partCode="Part Code";
    taskName="Task Name";
    empName="Employee Name";
    empCode="Employee Code";
    workers="Workers";
    
}else{
    dir = "RTL";
    align="right";
    style = "text-align:Right";
    lang = "English";
    langCode = "En";
    cancel = "&#1573;&#1606;&#1607;&#1575;&#1569;";
    title="&#1578;&#1602;&#1585;&#1610;&#1585; &#1581;&#1575;&#1604;&#1607; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;";
    mainInfo="&#1575;&#1604;&#1576;&#1610;&#1575;&#1606;&#1575;&#1578; &#1575;&#1604;&#1575;&#1587;&#1575;&#1587;&#1610;&#1607; &#1604;&#1604;&#1605;&#1593;&#1583;&#1607;";
    maintItems="&#1576;&#1600;&#1600;&#1606;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1608;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1607;";
    spareParts="&#1602;&#1600;&#1600;&#1600;&#1600;&#1600;&#1591;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1593; &#1575;&#1604;&#1600;&#1600;&#1600;&#1600;&#1600;&#1594;&#1600;&#1600;&#1600;&#1600;&#1600;&#1610;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1575;&#1585;";
    eqName="&#1575;&#1587;&#1600;&#1605; &#1575;&#1604;&#1600;&#1605;&#1593;&#1600;&#1583;&#1607;";
    joNum="&#1585;&#1602;&#1605; &#1575;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
    numHours="&#1593;&#1583;&#1583; &#1587;&#1575;&#1593;&#1575;&#1578; &#1593;&#1605;&#1604; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;";
    startWokingDate="&#1578;&#1575;&#1585;&#1610;&#1582; &#1576;&#1583;&#1575;&#1610;&#1607; &#1575;&#1604;&#1578;&#1588;&#1594;&#1610;&#1604;";
    actualEndDate="&#1578;&#1575;&#1585;&#1610;&#1582; &#1606;&#1607;&#1575;&#1610;&#1607; &#1575;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
    joName="&#1593;&#1606;&#1608;&#1575;&#1606; &#1575;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
    eqJO="&#1575;&#1608;&#1575;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604; &#1604;&#1607;&#1584;&#1607; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;";
    eqNum="&#1603;&#1608;&#1583; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;";
    cost="&#1575;&#1604;&#1600;&#1578;&#1600;&#1600;&#1600;&#1600;&#1600;&#1603;&#1600;&#1600;&#1600;&#1604;&#1600;&#1600;&#1600;&#1600;&#1601;&#1600;&#1600;&#1600;&#1600;&#1607;";
    enterWorkDate="&#1578;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1575;&#1585;&#1610;&#1600;&#1582; &#1583;&#1582;&#1600;&#1600;&#1608;&#1604; &#1575;&#1604;&#1600;&#1600;&#1605;&#1600;&#1600;&#1593;&#1600;&#1600;&#1583;&#1607; &#1604;&#1604;&#1600;&#1600;&#1593;&#1600;&#1600;&#1605;&#1600;&#1600;&#1604;";
    totalJO="&#1575;&#1580;&#1605;&#1575;&#1604;&#1609; &#1575;&#1608;&#1575;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604; &#1581;&#1578;&#1609; ";
    lastReading="&#1575;&#1582;&#1585; &#1602;&#1585;&#1575;&#1569;&#1607; &#1604;&#1604;&#1600;&#1605;&#1593;&#1600;&#1583;&#1607;";
    serviceEntryDATE="&#1578;&#1575;&#1585;&#1610;&#1582; &#1583;&#1582;&#1608;&#1604; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607; &#1575;&#1604;&#1582;&#1583;&#1605;&#1607;";
    eqAge="&#1593;&#1605;&#1585; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;";
    cost="&#1575;&#1604;&#1578;&#1600;&#1600;&#1600;&#1600;&#1600;&#1603;&#1600;&#1600;&#1600;&#1600;&#1600;&#1604;&#1600;&#1600;&#1601;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1607;";
    schName="&#1575;&#1587;&#1605; &#1580;&#1583;&#1608;&#1604; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1607;";
    exBDate="&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1576;&#1583;&#1575;&#1610;&#1607; &#1575;&#1604;&#1605;&#1578;&#1608;&#1602;&#1593;";
    exEDate="&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1606;&#1607;&#1575;&#1610;&#1607; &#1575;&#1604;&#1605;&#1578;&#1608;&#1602;&#1593;";
    joDate="&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
    joStartDate="&#1578;&#1575;&#1585;&#1610;&#1582; &#1576;&#1583;&#1575;&#1610;&#1607; &#1575;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
    joEndDate="&#1578;&#1575;&#1585;&#1610;&#1582; &#1606;&#1607;&#1575;&#1610;&#1607; &#1575;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
    notStarted="&#1604;&#1605; &#1610;&#1576;&#1583;&#1571; &#1576;&#1593;&#1583;";
    notFinished="&#1604;&#1605; &#1610;&#1606;&#1578;&#1607;&#1609; &#1576;&#1593;&#1583;";
    beginDate="&#1575;&#1604;&#1578;&#1575;&#1585;&#1610;&#1582; &#1605;&#1606;";
    endDate="&#1575;&#1604;&#1609;";
    partName="&#1575;&#1587;&#1605; &#1575;&#1604;&#1602;&#1591;&#1593;&#1607;";
    partCode="&#1603;&#1608;&#1583; &#1575;&#1604;&#1602;&#1591;&#1593;&#1607;";
    taskName="&#1575;&#1587;&#1605; &#1575;&#1604;&#1576;&#1606;&#1583;";
    empName="&#1575;&#1587;&#1605; &#1575;&#1604;&#1593;&#1575;&#1605;&#1604;";
    empCode="&#1603;&#1608;&#1583; &#1575;&#1604;&#1593;&#1575;&#1605;&#1604;";
    workers="&#1575;&#1604;&#1593;&#1605;&#1575;&#1604;&#1607;";
}
%>

<script src='ChangeLang.js' type='text/javascript'></script>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
    function cancelForm()
        {    
        document.EQP_REPORT_FORM.action ="<%=context%>/main.jsp";
        document.EQP_REPORT_FORM.submit();  
        }
</script>

<HTML>
    <head>
        <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
        <META HTTP-EQUIV="Expires" CONTENT="0">   
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/CSS.css">
    </head>
    
    <body>
        <FORM NAME="EQP_REPORT_FORM" METHOD="POST">
            <table border="0" width="100%" dir="LTR">
                <button  onclick="JavaScript: cancelForm();" width="50"><%=cancel%> <IMG VALIGN="BOTTOM"  HEIGHT="15" SRC="images/cancel.gif"></button>
            </table> 
            
           <table border="0" width="100%" id="table1">
                <tr>
                    <td width="48%" align="center">
                        <img border="0" src="images/<%=logos.get("comLogo1").toString()%>" width="300" height="120">
                    </td>
                    <td width="50%" align="center">
                        <img border="0" src="images/<%=logos.get("comTitle").toString()%>" width="386" height="57">
                    </td>
                </tr>
            </table>
            
            <center>
                <table dir="<%=dir%>" align="center">
                    <tr>
                        <td class="td" bgcolor="#FFFFFF" style="text-align:center;border:0">
                            <b><font size="5" color="blue"><%=title%></font> &nbsp;:&nbsp;
                            <b><font color="red" size="5"><%=equipmentWbo.getAttribute("unitName").toString()%></font></b>
                        </td>
                    </tr>
                </table>
                <br>
                <%--Table Contains all Tables in page--%>
                <table dir="<%=dir%>"  align="center" >
                    <tr>
                        <td style="border:2px;border-right-width:2px;border-color:black;border-style: solid;" bgcolor="#CCCCFF">
                            <b><font size="4" color="blue"><%=mainInfo%></font></b>
                        </td>
                    </tr>
                    <tr >
                        <%--Table Contains Equipment Data--%>
                        <td style="border:2px;border-right-width:2px;border-color:Black;border-style: solid;">
                            <table dir="<%=dir%>"  align="<%=align%>" width="100%">
                                <tr>
                                    <td class="td" bgcolor="#DCDCDC" width="80"  style="<%=style%>;font:BOLD 12px arial;">
                                        <b><font color="black" size="2"> <%=eqNum%>:</font></b>
                                    </td>
                                    <td width="200" class="td" style="<%=style%>;font:BOLD 12px arial;">
                                        <b> <font color="black" size="2">
                                                <%=equipmentWbo.getAttribute("unitNo").toString()%>
                                        </font></b>
                                    </td>
                                    
                                    <td width="100" bgcolor="#DCDCDC" class="td" style="<%=style%>;font:BOLD 12px arial;">
                                        <b> <font color="black" size="2"> <%=eqName%>:</font></b>
                                    </td>
                                    <td width="250" class="td" width="15%" style="<%=style%>;font:BOLD 12px arial;">
                                        <b> <font color="black" size="2">
                                                <%=equipmentWbo.getAttribute("unitName").toString()%>
                                        </font></b>
                                    </td>
                                    
                                    <td width="110" bgcolor="#DCDCDC" class="td" style="<%=style%>;font:BOLD 12px arial;">
                                        <b><font color="black" size="2"> <%=lastReading%>:</font></b>
                                    </td>
                                    <td width="80" class="td" style="<%=style%>;font:BOLD 12px arial;">
                                        <b> <font color="black" size="2">
                                                
                                                <% if(equipmentWbo.getAttribute("lastReading")!=null){
    if(equipmentWbo.getAttribute("rateType").toString().equalsIgnoreCase("fixed")){
                                                %>    
                                                <%=(String)equipmentWbo.getAttribute("lastReading")%><font color="red">&nbsp;&#1587;&#1575;&#1593;&#1607;</font>
                                                <%}else{%>
                                                <%=(String)equipmentWbo.getAttribute("lastReading")%><font color="red">&nbsp;&#1603;&#1605;</font>
                                                <%}}else{%>
                                                &#1594;&#1610;&#1585; &#1605;&#1578;&#1575;&#1581;
                                                <%}%>
                                                
                                        </font></b>
                                    </td>
                                    
                                    <td width="110" bgcolor="#DCDCDC" class="td" style="<%=style%>;font:BOLD 12px arial;">
                                        <b><font color="black" size="2"> <%=beginDate%>:</font></b>
                                    </td>
                                    <td width="150" class="td" style="<%=style%>;font:BOLD 12px arial;">
                                        
                                        <b> <font color="black" size="2">
                                                <%=bDate%>
                                        </font></b>
                                    </td>
                                </tr>
                                
                                <tr>
                                    <td class="td" colspan="4">&nbsp;</td>
                                    <td class="td" bgcolor="#DCDCDC" style="<%=style%>;font:BOLD 12px arial;">
                                        <b><font color="black" size="2">&#1576;&#1578;&#1575;&#1585;&#1610;&#1582;:&nbsp;&nbsp;</font></b>
                                    </td>
                                    <td class="td" style="<%=style%>;font:BOLD 12px arial;">
                                        
                                        <%if(equipmentWbo.getAttribute("lastReadingDate")!=null){ 
                                        lastReadingDate =equipmentWbo.getAttribute("lastReadingDate").toString();
                                        Date d = Calendar.getInstance().getTime();
                                        long id = d.getTime();
                                        
                                        String stringID = new Long(id).toString();
                                        String test = new String(lastReadingDate);
                                        Long l = new Long(test);
                                        long sl = l.longValue();
                                        
                                        d.setTime(sl);
                                        int year=d.getYear()+1900;
                                        int mon=d.getMonth()+1;
                                        int day=d.getDate();
                                        lastReadingDate=year+"/"+mon+"/"+day;
                                        }else{
                                        lastReadingDate="&#1594;&#1610;&#1585; &#1605;&#1578;&#1575;&#1581;";
                                        }
                                        %>
                                        
                                        <b><font color="black" size="2"><%=lastReadingDate%>                                                 </font></b>
                                    </td>
                                    <td class="td" bgcolor="#DCDCDC" style="<%=style%>;font:BOLD 12px arial;">
                                        <b><font color="black" size="2"> <%=endDate%>:</font></b>
                                    </td>
                                    <td class="td" style="<%=style%>;font:BOLD 12px arial;">
                                        <b> <font color="black" size="2">
                                                <%=eDate%>
                                        </font></b>
                                    </td>
                                    
                                </tr>
                                
                            </table>
                        </td>
                        <%-----------End of Eq Data---------------%>
                    </tr>
                    <tr>
                        <td style="font:BOLD 12px arial;" bgcolor="#CCCCFF">
                            <b><font size="3" color="blue"><%=eqJO%></font></b>
                        </td>
                    </tr>
                    <tr>
                        <td style="font:BOLD 12px arial;" bgcolor="#CCCCFF">
                            <b><font size="3" color="blue"><%=totalJO%>&nbsp;<%=eDate%>&nbsp;:&nbsp;<%=eqIssues.size()%></font></b>
                        </td>
                    </tr>
                    
                    <tr>
                        <td style="border:2px;border-right-width:2px;border-color:Black;border-style: solid;">
                            <table dir="<%=dir%>" align="<%=align%>" width="100%" style="border-style:solid;border-color:black;border-width:1px;">
                                <tr bgcolor="#C0C0C0">
                                    <td style="text-align:center;font:BOLD 12px arial;">
                                        <b><font color="black" size="2">&#1605;</font></b>
                                    </td>
                                    
                                    <td style="text-align:center;font:BOLD 12px arial;">
                                        <b><font color="black" size="2"><%=joNum%></font></b>
                                    </td>
                                    
                                    <td style="text-align:center;font:BOLD 12px arial;">
                                        <b><font color="black" size="2"> <%=schName%> </font>  </b>                                    
                                    </td>
                                    
                                    <td style="text-align:center;font:BOLD 12px arial;">
                                        <b><font color="black" size="2"><%=joDate%></font></b>
                                    </td>
                                    
                                    <td style="text-align:center;font:BOLD 12px arial;">
                                        <b><font color="black" size="2"><%=joStartDate%></font></b>
                                    </td>
                                    
                                    <td style="text-align:center;font:BOLD 12px arial;">
                                        <b><font color="black" size="2"><%=joEndDate%></font></b>
                                    </td>
                                    
                                    <td style="text-align:center;font:BOLD 12px arial;">
                                        <b><font color="black" size="2"><%=maintItems%></font></b>
                                    </td>
                                    
                                    <td style="text-align:center;font:BOLD 12px arial;">
                                        <b><font color="black" size="2"><%=spareParts%></font></b>
                                    </td>
                                    
                                    <td style="text-align:center;font:BOLD 12px arial;">
                                        <b><font color="black" size="2"><%=workers%></font></b>
                                    </td>
                                    
                                </tr>
                                
                                <%
                                for(int i=0;i<eqIssues.size();i++){
    issueWbo=new WebBusinessObject();
    issueWbo=(WebBusinessObject)eqIssues.get(i);
    issueId=issueWbo.getAttribute("id").toString();
                                
                                %>
                                <tr>
                                    <td style="<%=style%>;font:BOLD 12px arial;">
                                        <b><font color="black" size="2">
                                                <%=i+1%>
                                        </font></b>
                                    </td>
                                    
                                    <td style="<%=style%>;font:BOLD 12px arial;">
                                        <b><font color="black" size="2">
                                                <%=issueWbo.getAttribute("businessID").toString()%>
                                        </font></b>
                                    </td>
                                    
                                    <td style="<%=style%>;font:BOLD 12px arial;">
                                        <b><font color="black" size="2">
                                        <%=issueWbo.getAttribute("unitScheduleTitle").toString()%>
                                    </td>
                                    
                                    <td style="<%=style%>;font:BOLD 12px arial;">
                                        <b><font color="black" size="2">
                                                <%=issueWbo.getAttribute("creationTime").toString()%>
                                        </font></b>
                                    </td>
                                    
                                    <td style="<%=style%>;font:BOLD 12px arial;">
                                        <b><font color="black" size="2">
                                                <%if(issueWbo.getAttribute("expectedBeginDate")!=null){%>
                                                <%=issueWbo.getAttribute("expectedBeginDate").toString()%>
                                                <% }else{%>
                                                <%=notStarted%>
                                                <%}%>
                                        </font></b>
                                    </td>
                                    
                                    <td style="<%=style%>;font:BOLD 12px arial;">
                                        <b><font color="black" size="2">
                                                
                                                <%if(issueWbo.getAttribute("expectedEndDate")!=null){%>
                                                <%=issueWbo.getAttribute("expectedEndDate").toString()%>
                                                <% }else{%>
                                                <%=notFinished%>
                                                <%}%>
                                        </font></b>
                                    </td>
                                    
                                    <td style="<%=style%>;font:BOLD 12px arial;">
                                        <table dir="<%=dir%>"  align="<%=align%>" width="100%">
                                            <tr bgcolor="#DCDCDC">
                                                <td class="td" style="border-style: ridge;border-left-width: 0px;border-bottom-width: 1px;border-right-width: 0px;border-top-width: 0px;border-color: black;text-align:center;font:BOLD 12px arial;">
                                                    <b><font color="black" size="2">
                                                            <%=taskName%> 
                                                    </font></b>
                                                </td>
                                            </tr>
                                            <%
                                            if(allIssueTasks.size()>0){
        issueItems=new Vector();
        issueItems=(Vector)allIssueTasks.get(issueId);
        if(issueItems.size()>0){
            for(int x=0;x<issueItems.size();x++){
                itemWbo=new WebBusinessObject();
                itemWbo=(WebBusinessObject)issueItems.get(x);
                if(bgcolor.equalsIgnoreCase("#c8d8f8"))
                    bgcolor="white";
                else
                    bgcolor="#c8d8f8";
                                            %>
                                            <tr bgcolor="<%=bgcolor%>">
                                                <td class="td" style="border-style: ridge;border-left-width: 0px;border-bottom-width: 1px;border-right-width: 0px;border-top-width: 0px;border-color: black;text-align:<%=align%>;font:BOLD 12px arial;">
                                                    <b><font color="black" size="2">
                                                            <%=(String)itemWbo.getAttribute("name")%> 
                                                    </font></b>
                                                </td>
                                            </tr>
                                            <%}}else{%>
                                            <tr>
                                                <td class="td" colspan="2" style="text-align:<%=align%>;font:BOLD 12px arial;">
                                                    <font color="red" size="2"> &#1604;&#1575; &#1578;&#1608;&#1580;&#1583; &#1576;&#1606;&#1608;&#1583; &#1589;&#1610;&#1575;&#1606;&#1607; &#1593;&#1604;&#1609; &#1575;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;</font>
                                                </td>
                                            </tr>
                                            <%}%>
                                            <%}%>
                                            
                                        </table>
                                    </td>
                                    
                                    <td style="<%=style%>;font:BOLD 12px arial;">
                                        <table width="100%">
                                            <tr bgcolor="#DCDCDC">
                                                <td class="td" style="border-style: ridge;border-left-width: 0px;border-bottom-width: 1px;border-right-width: 0px;border-top-width: 0px;border-color: black;text-align:center;font:BOLD 12px arial;">
                                                    <b><font color="black" size="2">
                                                            <%=partName%> 
                                                    </font></b>
                                                </td>
                                                <td class="td" style="border-style: ridge;border-left-width: 0px;border-bottom-width: 1px;border-right-width: 0px;border-top-width: 0px;border-color: black;text-align:center;font:BOLD 12px arial;">
                                                    <b><font color="black" size="2">
                                                            <%=partCode%> 
                                                    </font></b>
                                                </td>
                                            </tr>
                                            <%
                                            if(allIssueParts.size()>0){
        issueParts=new Vector();
        issueParts=(Vector)allIssueParts.get(issueId);
        if(issueParts.size()>0){
            for(int x=0;x<issueParts.size();x++){
                sparPartWbo=new WebBusinessObject();
                sparPartWbo=(WebBusinessObject)issueParts.get(x);
                if(bgcolor.equalsIgnoreCase("#c8d8f8"))
                    bgcolor="white";
                else
                    bgcolor="#c8d8f8";
                                            %>
                                            <tr bgcolor="<%=bgcolor%>">
                                                <td class="td" style="border-style: ridge;border-left-width: 0px;border-bottom-width: 1px;border-right-width: 0px;border-top-width: 0px;border-color: black; <%=style%>;font:BOLD 12px arial;">
                                                    <b><font color="black" size="2">
                                                            <%=(String)sparPartWbo.getAttribute("itemDscrptn")%> 
                                                    </font></b>
                                                </td>
                                                <td class="td" style="border-style: ridge;border-left-width: 0px;border-bottom-width: 1px;border-right-width: 0px;border-top-width: 0px;border-color: black; <%=style%>;font:BOLD 12px arial;">
                                                    <b><font color="black" size="2">
                                                            <%=(String)sparPartWbo.getAttribute("itemCode")%> 
                                                    </font></b>
                                                </td>
                                            </tr>
                                            <%}}else{%>
                                            <tr>
                                                <td class="td" colspan="2" style="<%=style%>;font:BOLD 12px arial;">
                                                    <font color="red" size="2"> &#1604;&#1575; &#1578;&#1608;&#1580;&#1583; &#1602;&#1591;&#1593; &#1594;&#1610;&#1575;&#1585; &#1593;&#1604;&#1609; &#1575;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;</font>
                                                </td>
                                            </tr>
                                            <%}%>
                                            <%}%>
                                            
                                        </table>
                                    </td>
                                    
                                    <td style="<%=style%>;font:BOLD 12px arial;">
                                        <table width="100%">
                                            <tr bgcolor="#DCDCDC">
                                                <td class="td" style="border-style: ridge;border-left-width: 0px;border-bottom-width: 1px;border-right-width: 0px;border-top-width: 0px;border-color: black;text-align:center;font:BOLD 12px arial;">
                                                    <b><font color="black" size="2">
                                                            <%=empName%> 
                                                    </font></b>
                                                </td>
                                                <td class="td" style="border-style: ridge;border-left-width: 0px;border-bottom-width: 1px;border-right-width: 0px;border-top-width: 0px;border-color: black;text-align:center;font:BOLD 12px arial;">
                                                    <b><font color="black" size="2">
                                                            <%=empCode%> 
                                                    </font></b>
                                                </td>
                                            </tr>
                                            <%
                                            empList=new Vector();
                                            empList = empTasksHoursMgr.getOnArbitraryKey(issueId,"key1");
                                            WebBusinessObject empWbo=new WebBusinessObject();
                                            if(empList.size()>0){
                                                for(int m=0;m<empList.size();m++){
                                                    empWbo=new WebBusinessObject();
                                                    empWbo = (WebBusinessObject) empList.get(m);
                                                    if(bgcolor.equalsIgnoreCase("#c8d8f8"))
                                                        bgcolor="white";
                                                    else
                                                        bgcolor="#c8d8f8";
                                            %>
                                            <tr bgcolor="<%=bgcolor%>">
                                                <td class="td" style="border-style: ridge;border-left-width: 0px;border-bottom-width: 1px;border-right-width: 0px;border-top-width: 0px;border-color: black; <%=style%>;font:BOLD 12px arial;">
                                                    <b><font color="black" size="2">
                                                            <%=(String)empWbo.getAttribute("empName")%> 
                                                    </font></b>
                                                </td>
                                                <td class="td" style="border-style: ridge;border-left-width: 0px;border-bottom-width: 1px;border-right-width: 0px;border-top-width: 0px;border-color: black; <%=style%>;font:BOLD 12px arial;">
                                                    <b><font color="black" size="2">
                                                            <%=empWbo.getAttribute("empId").toString()%>
                                                    </font></b>
                                                </td>
                                            </tr>
                                            <% }}else{%>
                                            <tr>
                                                <td colspan="2" class="td" style="<%=style%>;font:BOLD 12px arial;">
                                                    <font color="red" size="2">&#1604;&#1575; &#1578;&#1608;&#1580;&#1583; &#1593;&#1605;&#1575;&#1604;&#1607; &#1593;&#1604;&#1609; &#1575;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;</font>
                                                </td>
                                            </tr>
                                            <%}%>
                                        </table>
                                    </td>
                                    
                                </tr>     
                                <%}%>
                            </table>
                        </td>
                    </tr>
                </table>
            </center>
        </FORM>
    </body>
</html>