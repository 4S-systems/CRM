<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.tracker.engine.*,com.silkworm.common.*, com.tracker.common.*, java.util.*,com.tracker.business_objects.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,java.util.*,java.text.SimpleDateFormat"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<html>
<%
MetaDataMgr metaMgr = MetaDataMgr.getInstance();
ProjectMgr projectMgr = ProjectMgr.getInstance();
FailureCodeMgr failureCodeMgr = FailureCodeMgr.getInstance();
ItemUnitMgr itemUnitMgr = ItemUnitMgr.getInstance();
String context = metaMgr.getContext();
IssueMgr issueMgr = IssueMgr.getInstance();
UserMgr userMgr = UserMgr.getInstance();
CrewMissionMgr crewMgr = CrewMissionMgr.getInstance();
String issueId = (String) request.getAttribute(IssueConstants.ISSUEID);
String issueTitle = (String) request.getAttribute(IssueConstants.ISSUETITLE);

WebBusinessObject crewWbo = null;

AppConstants appCons = new AppConstants();

String filterName = (String) request.getAttribute("filter");
String filterValue = (String) request.getAttribute("filterValue");

String[] itemAtt = {"note", "itemId","itemQuantity","itemPrice","totalCost"};//appCons.getItemScheduleAttributes();
String[] itemTitle = {"&#1605;&#1604;&#1575;&#1581;&#1592;&#1575;&#1578;","&#1575;&#1604;&#1608;&#1581;&#1583;&#1577;", "&#1575;&#1604;&#1603;&#1605;&#1610;&#1577; &#1575;&#1604;&#1605;&#1591;&#1604;&#1608;&#1576;&#1577;","&#1575;&#1587;&#1600;&#1600;&#1600;&#1605; &#1575;&#1604;&#1589;&#1606;&#1601;","&#1585;&#1602;&#1605; &#1575;&#1604;&#1589;&#1606;&#1601;", "&#1605;"};//appCons.getItemScheduleHeaders();

WebBusinessObject unitWbo = null;
TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

Vector  itemList = (Vector) request.getAttribute("data");
int s = itemAtt.length;
int t = s+1;
int iTotal = 0;

String attName = null;
String attValue = null;
int flipper = 0;

WebBusinessObject wbo = issueMgr.getOnSingleKey(issueId);
if(wbo.getAttribute("techName") != null){
    crewWbo = crewMgr.getOnSingleKey(wbo.getAttribute("techName").toString());
}
WebBusinessObject wboTemp = UnitScheduleMgr.getInstance().getOnSingleKey(wbo.getAttribute("unitScheduleID").toString());

Hashtable logos=new Hashtable();
logos=(Hashtable)session.getAttribute("logos");

String cMode= (String) request.getSession().getAttribute("currentMode");
String  stat="En";
String align=null;
String dir=null;
String style=null;
String lang,langCode,sBackToList,unitItemCode,timeStatus,underConstruction;
if(stat.equals("En")){
    
    align="center";
    dir="LTR";
    style="text-align:right";
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
    langCode="Ar";
    sBackToList = "Cancel";
    underConstruction="This function Under Construction";
}else{
    
    align="right";
    dir="RTL";
    style="text-align:Right";
    lang="English";
    langCode="En";
    sBackToList = "&#1573;&#1606;&#1607;&#1575;&#1569;";
    underConstruction="&#1607;&#1584;&#1607; &#1575;&#1604;&#1582;&#1575;&#1589;&#1610;&#1607; &#1578;&#1581;&#1578; &#1575;&#1604;&#1575;&#1606;&#1588;&#1575;&#1569;";
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
             
             if (!wbo.getAttribute("currentStatus").toString().equals("Assigned")){
              timeStatus = "&#1604;&#1605; &#1610;&#1576;&#1583;&#1571; &#1575;&#1604;&#1593;&#1605;&#1604; &#1576;&#1593;&#1583;";
  }else{
             timeStatus = issueMgr.getCreateTimeAssigned(issueId);
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
            
               <!--table width="100%" align="center">
                <tr>
                    <td class="td" style="test-align:center">
                        <center> <br>  <font size="3" color="red" ><b><%//=underConstruction%></b></font></center>
                    </td>
                </tr>
            </table-->
            
          
            
            <table border="0" width="100%" id="table1" dir="LTR">
                <tr>
                    <td class="td" width="48%" colspan="2">
                        <img border="0" src="images/<%=logos.get("comLogo1").toString()%>" width="300" height="120" align="left">
                    </td>
                    <td class="td" width="50%" colspan="2">
                        <img border="0" src="images/<%=logos.get("comTitle").toString()%>" width="386" height="57">
                    </td>
                </tr>
                <tr>
                    <td colspan="4" bgcolor="#006699">
                        <p align="center"><font color="#FFFFFF"><b>
                                
                    &#1591;&#1604;&#1576; &#1589;&#1585;&#1601; &#1605;&#1582;&#1575;&#1586;&#1606;</b></font></td>
                </tr>
                
                <tr>
                    <td></td><td></td>
                    <td width="25%" align="right"><b><font color="#000080"><%=timeStatus%></font></b></td>
                    <td width="25%" bgcolor="#CCCCCC">
                    <p align="right"><b>&#1575;&#1604;&#1578;&#1575;&#1585;&#1610;&#1582;</b></td>
                </tr>
                <tr>
                    <td></td> <td></td>
                <td width="25%" align="right"><b><font color="#000080"><%=jobnumber%></font></b></td>
		<td width="25%" bgcolor="#CCCCCC">
		<p align="right"><b>&#1585;&#1602;&#1605; &#1575;&#1604;&#1573;&#1584;&#1606;</b></td>
		
		
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
                            
                            <TR bgcolor="#CCFFFF">
                                <TD width="40%" align="<%=align%>">
                                    <b>  &nbsp;<%=attValue%> </b>
                                </TD>
                                <%
                                for(int i = 1;i<s;i++) {
                                attName = itemAtt[i];
                                attValue = (String) wbo.getAttribute(attName);
                                MaintenanceItemMgr maintenanceItemMgr = MaintenanceItemMgr.getInstance();
                                 if(i==1){ %>
                                 <TD align="<%=align%>">
                                   <%  
                                    unitItemCode = "1";//maintenanceItemMgr.getOnSingleKey(wbo.getAttribute(itemAtt[1]).toString()).getAttribute("itemUnit").toString();
                                    unitWbo = itemUnitMgr.getOnSingleKey(unitItemCode);
                                    %>
                                    <b>  <%=unitWbo.getAttribute("unitName").toString()%> </b>
                                </TD>

                                           
                                <% }else if(i == 3) {
                                
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
                            
                            }
                            
                            %>
                            
                            
                        </TABLE>
                    </td>
                </tr>
                
                
                
                
                
                
            </table>
            
            
        </form>
          
    </body>
</html>
