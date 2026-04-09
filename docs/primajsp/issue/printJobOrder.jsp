<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.tracker.engine.*,com.silkworm.common.*, com.tracker.common.*, java.util.*,com.tracker.business_objects.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,java.util.*,java.text.SimpleDateFormat"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<html>
<%
MetaDataMgr metaMgr = MetaDataMgr.getInstance();
ProjectMgr projectMgr = ProjectMgr.getInstance();
FailureCodeMgr failureCodeMgr = FailureCodeMgr.getInstance();
//TaskExecutionMgr taskExecutionMgr = TaskExecutionMgr.getInstance();
EmpTasksHoursMgr empTasksHoursMgr =EmpTasksHoursMgr.getInstance();
TasksByIssueMgr tasksByIssueMgr = TasksByIssueMgr.getInstance();
EmpBasicMgr empBasicMgr = EmpBasicMgr.getInstance();
String context = metaMgr.getContext();
IssueMgr issueMgr = IssueMgr.getInstance();
TradeMgr tradeMgr = TradeMgr.getInstance();
UserMgr userMgr = UserMgr.getInstance();
CrewMissionMgr crewMgr = CrewMissionMgr.getInstance();
String issueId = (String) request.getAttribute(IssueConstants.ISSUEID);
String issueTitle = (String) request.getAttribute(IssueConstants.ISSUETITLE);

WebBusinessObject crewWbo = null;
WebBusinessObject empWbo = null;
WebBusinessObject tasksWbo = null;
WebBusinessObject getEmpWbo = null;
AppConstants appCons = new AppConstants();

String[] itemAtt = {"note", "itemId","itemQuantity","itemPrice","totalCost"};//appCons.getItemScheduleAttributes();
String[] itemTitle = {"&#1605;&#1604;&#1575;&#1581;&#1592;&#1575;&#1578;", "&#1575;&#1604;&#1603;&#1605;&#1610;&#1577; &#1575;&#1604;&#1605;&#1591;&#1604;&#1608;&#1576;&#1577;","&#1575;&#1587;&#1600;&#1600;&#1600;&#1605; &#1575;&#1604;&#1589;&#1606;&#1601;","&#1585;&#1602;&#1605; &#1575;&#1604;&#1589;&#1606;&#1601;", "&#1605;"};//appCons.getItemScheduleHeaders();


TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

String filterName = (String) request.getAttribute("filter");
String filterValue = (String) request.getAttribute("filterValue");

Vector  itemList = (Vector) request.getAttribute("data");
int s = itemAtt.length;
int t = s;
int iTotal = 0;

String attName = null;
String attValue = null;
int flipper = 0;
String empNo,empName;
WebBusinessObject wbo = issueMgr.getOnSingleKey(issueId);
WebBusinessObject wboTrade = tradeMgr.getOnSingleKey(wbo.getAttribute("workTrade").toString());
if(wbo.getAttribute("techName") != null){
    crewWbo = crewMgr.getOnSingleKey(wbo.getAttribute("techName").toString());
}
WebBusinessObject wboTemp = UnitScheduleMgr.getInstance().getOnSingleKey(wbo.getAttribute("unitScheduleID").toString());

String cMode= (String) request.getSession().getAttribute("currentMode");
String  stat="En";
String align=null;
String dir=null;
String style=null;
String lang,langCode,sBackToList,timeStatus,sExternalSch,sNotes,sTasks;
if(stat.equals("En")){
    
    align="center";
    dir="LTR";
    style="text-align:right";
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
    langCode="Ar";
    empNo="Employee No#";
    empName="Employee Name";
    sBackToList = "Cancel";
    sExternalSch = "External";
}else{
    
    align="right";
    dir="RTL";
    style="text-align:Right";
    lang="English";
    langCode="En";
    empNo="&#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1608;&#1592;&#1601;";
    empName="&#1575;&#1587;&#1605; &#1575;&#1604;&#1605;&#1608;&#1592;&#1601;";
    sBackToList = "&#1573;&#1606;&#1607;&#1575;&#1569;";
    sExternalSch="&#1582;&#1575;&#1585;&#1580;&#1609;";
}
WebBusinessObject siteWbo = projectMgr.getOnSingleKey(wbo.getAttribute("projectName").toString());
WebBusinessObject failuerWbo = failureCodeMgr.getOnSingleKey(wbo.getAttribute("failureCode").toString());

String typeOfSchedule = null;
String caseStatus= null;
         
         Long iIDno = new Long(wbo.getAttribute("id").toString());
         Calendar calendar = Calendar.getInstance();
         calendar.setTimeInMillis(iIDno.longValue());
         String jobnumber = wbo.getAttribute("id").toString().substring(9) + "/" + (calendar.getTime().getMonth() + 1) + "/" + (calendar.getTime().getYear() + 1900);
  if (wbo.getAttribute("issueTitle").toString().equals("Emergency")){
              typeOfSchedule = "&#1589;&#1610;&#1575;&#1606;&#1577; &#1591;&#1575;&#1585;&#1574;&#1577;";
  }else{
             typeOfSchedule = wbo.getAttribute("issueTitle").toString();
             } 
             
  if (wbo.getAttribute("currentStatus").toString().equals("Finished")){
              caseStatus = "&#1578;&#1605;&#1578; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577; &#1604;&#1604;&#1605;&#1593;&#1583;&#1577;";
  }else{
             caseStatus = "&#1604;&#1605; &#1578;&#1606;&#1578;&#1607;&#1609; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577; &#1581;&#1578;&#1609; &#1575;&#1604;&#1570;&#1606;";
             } 
             
  Vector  empList = new Vector();
  Vector  tasksList = new Vector();
  
  empList = empTasksHoursMgr.getOnArbitraryKey(issueId,"key1");
  tasksList = tasksByIssueMgr.getOnArbitraryKey(issueId,"key");
  
  String employeeName = null;
  
  if (wbo.getAttribute("currentStatus").toString().equals("Schedule")){
               timeStatus = "&#1604;&#1605; &#1610;&#1576;&#1583;&#1571; &#1575;&#1604;&#1593;&#1605;&#1604; &#1576;&#1593;&#1583;";
  
               }else{
             timeStatus = issueMgr.getCreateTimeAssigned(issueId);
             }
             
             
             sNotes = issueMgr.getNotesAssigned(issueId);
              
             if (issueMgr.getTasksforIssue(issueId)){
              sNotes = "&#1604;&#1575; &#1610;&#1608;&#1580;&#1583; &#1578;&#1608;&#1589;&#1610;&#1575;&#1578; &#1578;&#1606;&#1601;&#1610;&#1584; &#1604;&#1571;&#1606;&#1607; &#1604;&#1605; &#1610;&#1576;&#1583;&#1571; &#1575;&#1604;&#1593;&#1605;&#1604; &#1576;&#1593;&#1583;";
  }else{
             sTasks = issueMgr.getNotesAssigned(issueId);
             }
%>
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Expires" CONTENT="0">
    <head>
        <TITLE>DebugTracker-Schedule detail</TITLE>
    
    </head>
    <script src='ChangeLang.js' type='text/javascript'></script>
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
    function cancelForm()
        {    
        document.JobOrder_FORM.action ="<%=context%>/AssignedIssueServlet?op=VIEWDETAILS&issueId=<%=issueId%>&filterName=<%=filterName%>&filterValue=<%=filterValue%>";
        document.JobOrder_FORM.submit();  
        }
</script>
    
    <body>
        
<FORM NAME="JobOrder_FORM" METHOD="POST">


<table border="0" width="100%" dir="LTR">
    <button  onclick="JavaScript: cancelForm();"><%=sBackToList%> <IMG VALIGN="BOTTOM"  HEIGHT="15" SRC="images/cancel.gif"> </button>
   
    
</table> 

                <table border="0" width="100%" id="table1" dir="LTR">
                    <tr>
                    <td width="48%">
                    <img border="0" src="images/prima.jpg" width="800" height="120" align="left"></td>
                    
                    <!--td width="50%" colspan="2">
		<img border="0" src="images/lehaaTitle.JPG" width="386" height="57"></td>
		</tr-->
             
            </table>
                <table border="0" width="100%" id="table1" dir="LTR">    
	<tr>
		<td colspan="4" bgcolor="#FFFFFF">
		<p align="center"><b>
		
		&#1573;&#1584;&#1606; &#1575;&#1604;&#1588;&#1594;&#1604;</b></td>
	</tr>
        <tr></tr>
        <tr></tr>
        <tr>
		<td colspan="4" bgcolor="#006699">
                    <p align="center"><font color="#FFFFFF"><b>
                        
                &#1578;&#1601;&#1575;&#1589;&#1610;&#1604; &#1573;&#1584;&#1606; &#1575;&#1604;&#1588;&#1594;&#1604;</font></b></td>
	</tr>
	<tr>
                <td width="25%" align="right"><b><font color="#000080"><%=timeStatus%></font></b></td>
                <td width="23%" bgcolor="#CCCCCC">
		<p align="right"><b>&#1578;&#1575;&#1585;&#1610;&#1582; &#1576;&#1583;&#1569; &#1575;&#1604;&#1578;&#1606;&#1601;&#1610;&#1584;</b></td>
		
                <td width="25%" align="right"><b><font color="#000080"><%=jobnumber%></font></b></td>
		<td width="23%" bgcolor="#CCCCCC">
		<p align="right"><b>&#1585;&#1602;&#1605; &#1575;&#1604;&#1573;&#1584;&#1606;</b></td>
		
		
	</tr>
	<tr>
                <td width="25%" align="right"><b><font color="#000080"><%=wboTemp.getAttribute("unitName").toString()%></font></b></td>
		<td width="23%" bgcolor="#CCCCCC">
		<p align="right"><b>&#1575;&#1604;&#1605;&#1593;&#1583;&#1577;</b></td>
		
                <td width="24%" align="right"><b><font color="#000080"><%=failuerWbo.getAttribute("title").toString()%></font></b></td>
		<td width="23%" bgcolor="#CCCCCC">
		<p align="right"><b>&#1606;&#1608;&#1593; &#1575;&#1604;&#1593;&#1591;&#1604;</b></td>
		
	</tr>
	<tr>
                <td width="25%" align="right"><b><font color="#000080"><%=wboTrade.getAttribute("tradeName").toString()%></font></b></td>
        	<td width="23%" bgcolor="#CCCCCC">
		<p align="right"><b>&#1606;&#1608;&#1593; &#1571;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;</b></td>
		
                <td width="24%" align="right"><b><font color="#000080"><%=siteWbo.getAttribute("projectName").toString()%></font></b></td>
		<td width="23%" bgcolor="#CCCCCC">
		<p align="right"><b>&#1575;&#1604;&#1605;&#1608;&#1602;&#1593;</b></td>
		
	</tr>
	<tr>
            <% if(wbo.getAttribute("scheduleType").toString().equals("NONE")) { %>
                <td width="25%" align="right"><b><font color="#000080"><%=typeOfSchedule%></font></b></td>
		<% } else { %>
                <td width="25%" align="right"><b><font color="red">(<%=sExternalSch%>)</font><font color="#000080"><%=typeOfSchedule%></font></td>	
             <%   } %>
                <td width="18%" bgcolor="#CCCCCC">
		<p align="right"><b>&#1606;&#1608;&#1593; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;</b></td>
		
                <td width="24%" align="right"><b><font color="#000080"><%=caseStatus%></font></b></td>
		<td width="23%" bgcolor="#CCCCCC">
		<p align="right"><b>&#1575;&#1604;&#1581;&#1575;&#1604;&#1577;</b></td>
		
	</tr>
	
	
	<tr>
		<td colspan="4" bgcolor="#006699">
		<p align="center"><font color="#FFFFFF"><b>
		
		 &#1602;&#1591;&#1593; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585;</b></font></td>
	</tr>
	
	<tr>
		<td width="98%" colspan="4">
		<p align="center">
                    <TABLE WIDTH="100%" CELLPADDING="0" CELLSPACING="0" BORDER="1" dir="<%=dir%>">
                                        <TR align="<%=align%>" bgcolor="#A0C0C0">
                                            
                                            <%
                                            for(int i = 0;i<t;i++) {
                                            %>
                                            <TD>
                                                <b>
                                                    <%=itemTitle[i]%>
                                                </b>
                                                
                                            </TD>
                                            <%
                                            }
                                            %>
                                        </TR>  
                                        
                                        <%
                                        
                                        Enumeration e = itemList.elements();
                                        String status = null;
                                        
                                        while(e.hasMoreElements()) {
                                            iTotal++;
                                            wbo = (WebBusinessObject) e.nextElement();
                                            attName = itemAtt[0];
                                            attValue = (String) wbo.getAttribute(attName);
                                        %>
                                        <% if(itemList.size()==0) {%>
                             <TR align="<%=align%>" bgcolor="#A0C0C0">
                        
                             <TD>   <b> <font color="red">
                                         &#1604;&#1575; &#1610;&#1608;&#1580;&#1583; &#1602;&#1591;&#1593; &#1594;&#1610;&#1575;&#1585; &#1605;&#1583;&#1585;&#1580;&#1577; &#1576;&#1571;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;
                             </font> </b></td>
                         </tr> 
                         <% } else { %>
                                        <TR bgcolor="#CCFFFF">
                                                <TD width="40%" align="<%=align%>">
                                                    <b>  &nbsp;<%=attValue%> </b>
                                                </TD>
                                                <%
                                                for(int i = 2;i<s;i++) {
                                                attName = itemAtt[i];
                                                attValue = (String) wbo.getAttribute(attName);
                                                MaintenanceItemMgr maintenanceItemMgr = MaintenanceItemMgr.getInstance();
                                                if(i == 3) {
                                                
                                                %>
                                                <TD align="<%=align%>">
                                                    <b> <%=maintenanceItemMgr.getOnSingleKey(wbo.getAttribute(itemAtt[1]).toString()).getAttribute("itemDscrptn").toString()%> </b>
                                                </TD>
                                                <%
                                                } else if(i==4){
                                                %>
                                                <TD align="<%=align%>">
                                                    <b>  <%=maintenanceItemMgr.getOnSingleKey(wbo.getAttribute(itemAtt[1]).toString()).getAttribute("itemCode").toString()%> </b>
                                                </TD>
                                                <%
                                                } else { %>
                                                <TD width="15%" align="<%=align%>">
                                                    <DIV >
                                                        
                                                        <b><%=attValue%> </b>
                                                    </DIV>
                                                </TD>
                                                <%
                                                }
                                                }
                                                %>
                                                <td align="<%=align%>" width="40">
                                                    <b>  <%=iTotal%> </b>
                                                </td>
                                           
                                        </TR>
                                        
                                        
                                        <%
                                        
                                        } }
                                        
                                        %>
                                        
                                        
                                    </TABLE>
                    </td>
	</tr>
        <tr>
		<td colspan="4" bgcolor="#006699">
		<p align="center"><font color="#FFFFFF"><b>
		
		&#1576;&#1606;&#1608;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;</b></font></td>
	</tr>
        <tr>
                     <td width="98%" colspan="4">
                         <p align="center">
                         <TABLE WIDTH="100%" CELLPADDING="0" CELLSPACING="0" BORDER="1" dir="<%=dir%>">
                             
                             <% if(tasksList.size()==0) {%>
                             <TR align="<%=align%>" bgcolor="#A0C0C0">
                        
                             <TD>   <b> <font color="red">
                                         &#1604;&#1575; &#1610;&#1608;&#1580;&#1583; &#1576;&#1606;&#1608;&#1583; &#1589;&#1610;&#1575;&#1606;&#1577; &#1605;&#1583;&#1585;&#1580;&#1577; &#1578;&#1581;&#1578; &#1571;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;
                             </font> </b></td>
                         </tr> 
                        <% } else { %>
                         <TR align="<%=align%>" bgcolor="#A0C0C0">
                        
                            
                                       <TD>   <b>
                                &#1608;&#1589;&#1601; &#1575;&#1604;&#1576;&#1606;&#1583;
                               </b>                   
                                </TD>   
                                 <TD>   <b>
                              &#1603;&#1608;&#1583; &#1576;&#1606;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;
                               </b>                   
                                </TD>
                                
                                        </TR>  
                                        
                      <%
                                        
                            Enumeration x = tasksList.elements();                   
                              while(x.hasMoreElements()) {
                               iTotal++;
                               tasksWbo = (WebBusinessObject) x.nextElement();
                                            
                       %>
                         <TR bgcolor="#CCFFFF">
                             
                                 
                             <TD align="<%=align%>">
                               <b> <%=tasksWbo.getAttribute("name").toString()%> </b>
                                 </TD>
                                 
                             <TD width="40%" align="<%=align%>">
                             <b><%=tasksWbo.getAttribute("code").toString()%>   </b>
                              </TD>
                                              
                               
                                                
                              <%
                                  }
                                                
                                  %>
                                            
                        </TR>
                                        
                                <% }%>        
                                        
                        
                                        
                                        
                                    </TABLE>
                    
                    </td>
	</tr>
        
        <!--tr>
		<td colspan="4" bgcolor="#006699">
		<p align="center"><font color="#FFFFFF"><b>
            &#1575;&#1604;&#1593;&#1605;&#1575;&#1604;&#1577;</font></b></td>
	</tr>
	<tr>
		<td width="98%" colspan="4">
		<p align="center">
                     <TABLE WIDTH="100%" CELLPADDING="0" CELLSPACING="0" BORDER="1" dir="<%=dir%>">
                      <TR align="<%=align%>" bgcolor="#A0C0C0">
                        
                          <TD>   <b>
                               &#1593;&#1583;&#1583; &#1587;&#1575;&#1593;&#1575;&#1578; &#1575;&#1604;&#1593;&#1605;&#1604;
                               </b>                   
                                </TD>   
                                       <TD>   <b>
                                &#1575;&#1587;&#1605; &#1575;&#1604;&#1605;&#1608;&#1592;&#1601;
                               </b>                   
                                </TD>   
                                <TD>   <b>
                                 &#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1608;&#1592;&#1601;
                               </b>                   
                                </TD>
                                        </TR>  
                                        
                      <%
                                        
                            e = empList.elements();                   
                             while(e.hasMoreElements()) {
                             iTotal++;
                              empWbo = (WebBusinessObject) e.nextElement();
                                            
                       %>
                         <TR bgcolor="#CCFFFF">
                             <TD align="<%=align%>">
                               <b> <%=empWbo.getAttribute("actualHours").toString()%> </b>
                                 </TD>
                                 
                             <TD align="<%=align%>">
                               <b> <%=empWbo.getAttribute("empName").toString()%> </b>
                                 </TD>
                                 
                             <TD width="40%" align="<%=align%>">
                             <b><%=empWbo.getAttribute("empId").toString()%>   </b>
                              </TD>
                                              
                               
                                                
                              <%
                                  }
                                                
                                  %>
                                            
                        </TR>
                                        
                                        
                                        
                        
                                        
                                        
                                    </TABLE>
                    
                    </td>
	</tr-->
        
        <tr>
		<td colspan="4" bgcolor="#006699">
		<p align="center"><font color="#FFFFFF"><b>
            &#1578;&#1608;&#1589;&#1610;&#1575;&#1578; &#1575;&#1604;&#1578;&#1606;&#1601;&#1610;&#1584;</font></b></td>
	</tr>
        <tr>
		<td width="98%" colspan="4">
                <p align="center"><b><%=sNotes%></b></td>
	</tr>
	<!--tr>
            <td width="25%">&nbsp;</td>
            <td width="25%">&nbsp;</td>
                <td width="25%">&nbsp;</td>
		<td width="25%" bgcolor="#CCCCCC">
		<p align="right"><b>
                    <font color="#800000">
                        &#1575;&#1604;&#1605;&#1608;&#1592;&#1601; &#1575;&#1604;&#1605;&#1587;&#1574;&#1608;&#1604;
            </font></b></td>
		
	</tr-->
</table>
</FORM>
          
    </body>
</html>
