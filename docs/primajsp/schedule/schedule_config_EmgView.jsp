<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*"%>

<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.tracker.engine.*,com.silkworm.common.*, com.tracker.common.*, java.util.*,com.tracker.business_objects.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,java.text.DecimalFormat"%>

<HTML>
<%

MetaDataMgr metaMgr = MetaDataMgr.getInstance();
EmployeeMgr empMgr = EmployeeMgr.getInstance();
StaffCodeMgr staffCodeMgr = StaffCodeMgr.getInstance();
CrewMissionMgr crewMissionMgr = CrewMissionMgr.getInstance();

ProjectMgr projectMgr = ProjectMgr.getInstance();
FailureCodeMgr failureCodeMgr=FailureCodeMgr.getInstance();
String context = metaMgr.getContext();

UserMgr userMgr = UserMgr.getInstance();
String issueId = (String) request.getAttribute(IssueConstants.ISSUEID);
String issueTitle = (String) request.getAttribute(IssueConstants.ISSUETITLE);
String groupShift = (String) request.getAttribute("groupShift");

String filterName = (String) request.getAttribute("filter");
String filterValue = (String) request.getAttribute("filterValue");
String uID = (String) request.getAttribute("uID");

String type =(String) request.getAttribute("type");


String workShop = (String) request.getAttribute("workShop");

/* added */

AppConstants appCons = new AppConstants();
WebIssue webIssue = null;

String[] itemAtt = appCons.getItemScheduleAttributes();
String[] itemTitle = appCons.getItemScheduleHeaders();


TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

Vector  itemList = (Vector) request.getAttribute("data");

String operation=request.getAttribute("op").toString();
System.out.println("llllllkkk  "+operation);
System.out.println("Vector Count = "+itemList.size());



int s = itemAtt.length;
int t = s;
int iTotal = 0;

String attName = null;
String attValue = null;
String cellBgColor = new String("#FF00FF");
String bgColor = null;
int flipper = 0;


WebBusinessObject wbo = IssueMgr.getInstance().getOnSingleKey(issueId);
WebBusinessObject wboTemp = UnitScheduleMgr.getInstance().getOnSingleKey(wbo.getAttribute("unitScheduleID").toString());
WebBusinessObject wboFcode = failureCodeMgr.getOnSingleKey(wbo.getAttribute("failureCode").toString());
String failureCode = wboFcode.getAttribute("title").toString();
/* end */
TechMgr techMgr = TechMgr.getInstance();

String cMode= (String) request.getSession().getAttribute("currentMode");
String  stat=cMode;
String align=null;
String dir=null;
String style=null;
String lang,langCode,BackToList,save,attachTask,title,Categ,view,deleting,search,fCode,M_Name,site;
String AddCode,AddName,addNew,tCost,code,name,price,count,cost,Mynote,del,group,shift;
if(stat.equals("En")){
    
    align="center";
    dir="LTR";
    style="text-align:left";
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
    langCode="Ar";
    BackToList = "Back to list";
    
    attachTask="Attach spare parts to task";
    
    Categ="Equipment Category";
    title="task title";
    site="Site";
    M_Name="Machine name";
    
    fCode="Failure code";
    search="Auto search";
    
    AddCode="Add using Part Code";
    AddName="Add using Part Name";
    addNew="Add new part";
    tCost="Total cost  ";
    code="Code";
    name="Name";
    price="Price";
    count="Quntity";
    cost="Cost";
    Mynote="Note";
    del="Delete";
    
   view="View Emergency Job Order";
    deleting="Delete Emergency Job Order";
    group = "Group";
    shift = "Shift";
    
}else{
    
    align="center";
    dir="RTL";
    style="text-align:Right";
    lang="English";
    langCode="En";
    view="&#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1571;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604; &#1575;&#1604;&#1591;&#1575;&#1585;&#1574;";
    deleting ="&#1581;&#1584;&#1601; &#1571;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604; &#1575;&#1604;&#1591;&#1575;&#1585;&#1574;";
    BackToList = "&#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1573;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577;";
    
    attachTask="&#1585;&#1576;&#1591; &#1575;&#1604;&#1580;&#1583;&#1608;&#1604; &#1576;&#1602;&#1591;&#1593; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585;";
    title="&#1606;&#1608;&#1593; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607;";
    site=" &#1575;&#1604;&#1605;&#1608;&#1602;&#1593;";
    M_Name="&#1573;&#1587;&#1605; &#1575;&#1604;&#1575;&#1604;&#1607;";
    fCode="&#1606;&#1608;&#1593; &#1575;&#1604;&#1593;&#1591;&#1604;";
    Categ="&#1589;&#1606;&#1601; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;  ";
    
    
    search="&#1576;&#1581;&#1579; &#1584;&#1575;&#1578;&#1610;";
    AddCode="&#1576;&#1581;&#1579; &#1576;&#1575;&#1604;&#1585;&#1602;&#1605;";
    AddName="&#1576;&#1581;&#1579; &#1576;&#1575;&#1604;&#1575;&#1587;&#1605;";
    addNew="  &#1571;&#1590;&#1601; &#1602;&#1591;&#1593;&#1577; &#1580;&#1583;&#1610;&#1583;&#1607; ";
    tCost="&#1573;&#1580;&#1605;&#1575;&#1604;&#1610; &#1575;&#1604;&#1578;&#1603;&#1604;&#1601;&#1607;   ";
    code="&#1575;&#1604;&#1603;&#1608;&#1583;";
    name="&#1575;&#1604;&#1573;&#1587;&#1605;";
    price="&#1575;&#1604;&#1587;&#1593;&#1585; ";
    count="&#1575;&#1604;&#1603;&#1605;&#1610;&#1607;";
    cost=" &#1575;&#1604;&#1578;&#1603;&#1604;&#1601;&#1607;";
    Mynote="&#1605;&#1604;&#1575;&#1581;&#1592;&#1575;&#1578;";
    del="&#1581;&#1584;&#1601; ";
    group = "&#1575;&#1604;&#1605;&#1580;&#1605;&#1608;&#1593;&#1577;";
    shift = "&#1575;&#1604;&#1608;&#1585;&#1583;&#1610;&#1577;";
    
    
}
%>
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Expires" CONTENT="0">

<HEAD>
    <TITLE>Agricultural Miantenance - work shop order</TITLE>
    <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    <LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
    
</HEAD>

<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
 
        function submitForm()
        {    
          
    
   
       document.WORKSHOP_FORM.action = "<%=context%>/ScheduleServlet?op=Deleteview&scheduleUnitID=<%=uID%>&delete=0&type=<%=type%>";
       document.WORKSHOP_FORM.submit();  
       
    }
        window.onload = function () {
        
           var RowCount = document.getElementsByName('rowCount');
           var cost = document.getElementsByName('cost');
           var temp = 0.0;
           for(var i=0;i<RowCount[0].value;i++){
           
              temp+=cost[i].value*1;
           }
         var total = document.getElementsByName('totale');
         total[0].value=new Number(temp).toFixed(2);
        
        }
        
        function Delete(){
        
           document.WORKSHOP_FORM.action = "<%=context%>/ScheduleServlet?op=Deleteview&scheduleUnitID=<%=uID%>&delete=1&type=<%=type%>";
           document.WORKSHOP_FORM.submit();  
        }
       
                      </script>

<script src='ChangeLang.js' type='text/javascript'></script>
<BODY>
<DIV align="left" STYLE="color:blue;">
    <input type="button" value="     <%=lang%>     " onclick="reloadAE('<%=langCode%>')" class="button">
    <button  onclick="JavaScript: submitForm();" class="button"><%=BackToList%> <IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif"> </button>
    <%
    if(!operation.equals("view")){
    %>
    
    <button  onclick="JavaScript:  Delete();" class="button"><%=del%> <IMG HEIGHT="15" SRC="images/cancel.gif"></button>
    
    
    <%}%>
</DIV>   

<left>



<FORM NAME="WORKSHOP_FORM" METHOD="POST"> 
    
    <fieldset align="center" class="set" >
        <legend align="center">
            <table dir="rtl" align="center">
                <tr>
                    
                    <td class="td">
                        <font color="blue" size="6">                  
                            
                            <%
                            if(operation.equals("view")){
                            %>
                            <%=view%>
                            <%
                            }else{
                            %>
                            <%=deleting%>
                            <%
                            }
                            %>
                        </font>
                        
                    </td>
                </tr>
            </table>
        </legend>
        
        <TD CLASS="tabletitle" STYLE="">
            <IMG WIDTH="20" HEIGHT="20" SRC="images/corner.gif">
        </TD>
        
        
        </TR>
        
        
        
        
    </FORM>
    <td>
        <TABLE CELLPADDING="0" CELLSPACING="0" BORDER="0" dir="<%=dir%>" ALIGN="<%=align%>" style="<%=style%>;">
            
            <TR>
                <TD class='td'>
                    <LABEL FOR="ISSUE_TITLE">
                        <p><b><%=title%><font color="#FF0000"> </font></b>&nbsp;
                    </LABEL>
                </TD>
                <TD class='td'>
                    <input disabled type="TEXT" style="width:230px" name="maintenanceTitle" value="<%=issueTitle%>" ID="<%=issueTitle%>" size="33"  maxlength="50">
                </TD>
            </TR>
            
            <TR>
                <TD class='td'>
                    <LABEL FOR="ISSUE_TITLE">
                        <p><b><%=site%><font color="#FF0000"> </font></b>&nbsp;
                    </LABEL>
                </TD>
                <TD class='td'>
                    <input disabled type="TEXT" style="width:230px" name="workShop" value="<%=projectMgr.getOnSingleKey(wbo.getAttribute("projectName").toString()).getAttribute("projectName").toString()%>" ID="workShop" size="33"  maxlength="50">
                </TD>
            </TR>
            
            
            <TR>
                <TD class='td'>
                    <LABEL FOR="ISSUE_TITLE">
                        <p><b><%=M_Name%><font color="#FF0000"> </font></b>&nbsp;
                    </LABEL>
                </TD>
                <TD class='td'>
                    <input disabled type="TEXT" style="width:230px" name="machineName" value="<%=wboTemp.getAttribute("unitName").toString()%>" ID="machineName" size="33"  maxlength="50">
                </TD>
            </TR>
            
            <!--TR>
                <TD class='td'>
                    <LABEL FOR="ISSUE_TITLE">
            <p><b><%//=group%><font color="#FF0000"> </font></b>&nbsp;
                    </LABEL>
                </TD>
                <TD class='td'>
            <input disabled type="TEXT" style="width:230px" name="group" value="<%//=groupShift.subSequence(0,1)%>" ID="machineName" size="33"  maxlength="50">
                </TD>
                
                <TD class='td'>
                    <LABEL FOR="ISSUE_TITLE">
            <p><b><%//=shift%><font color="#FF0000"> </font></b>&nbsp;
                    </LABEL>
                </TD>
                <TD class='td'>
            <input disabled type="TEXT" style="width:230px" name="shift" value="<%//=groupShift.substring(2)%>" ID="machineName" size="33"  maxlength="50">
                </TD>
           
            </TR-->
            
            
            
            <TR>
                <TD class='td'>
                    <LABEL FOR="str_Function_Desc">
                        <p><b><%=fCode%> : </b>&nbsp;
                    </LABEL>
                </TD>
                <TD class='td'>
                    <input type="text" DISABLED style="width:230px" rows="2" name="assignNote" value="<%=failureCode%>" ID="assignNote" cols="25">
                </TD>
            </TR>
        </TABLE>
        <input type=HIDDEN name=issueId value="<%=issueId%>" >
        <input type=HIDDEN name=filterName value="<%=filterName%>" >
        <input type=HIDDEN name=filterValue value="<%=filterValue%>" >
        <input type=HIDDEN name=issueTitle value="<%=issueTitle%>">
        
    </td>
    
    
    <br>
    
    <%
    if(itemList.size()==0){
    %>
    not configured
    
    <%
    
    } else{
    %>
    
    <br>
    <TABLE ALIGN="<%=align%>" DIR="<%=dir%>" id="itemTable" WIDTH=100%  CELLPADDING="0" CELLSPACING="0" STYLE="right-WIDTH:1px;">
        
        
        <!--Tr>
            
            <TD CLASS="total" colspan="2" STYLE="<!%=style%>;padding-right:5;border-right-width:1;">
                <!%=tCost%>
            </TD>
            <TD CLASS="td" STYLE="<!%=style%>" >
                <input type="TEXT" name="totale"  disabled ID="totale" size="20" value="0.00" maxlength="255" autocomplete="off">
            </TD>
            <TD>
                
            </TD>
            <TD></TD>
        </TR-->  
        <TR CLASS="head">  
            <TD nowrap CLASS="firstname" WIDTH="100" STYLE="border-top-WIDTH:0; font-size:12">
                <%=code%>
            </TD> 
            <TD nowrap CLASS="firstname" WIDTH="100" STYLE="border-top-WIDTH:0; font-size:12">
                <%=name%>
            </TD> 
            <TD nowrap CLASS="firstname" WIDTH="100" STYLE="border-top-WIDTH:0; font-size:12">
                <%=count%>
            </TD> 
            <!--TD nowrap CLASS="firstname" WIDTH="100" STYLE="border-top-WIDTH:0; font-size:12">
                <%=price%>
            </TD> 
            <TD nowrap CLASS="firstname" WIDTH="100" STYLE="border-top-WIDTH:0; font-size:12">
                <%=cost%>
            </TD--> 
            <TD nowrap CLASS="firstname" WIDTH="100" STYLE="border-top-WIDTH:0; font-size:12">
                <%=Mynote%>
            </TD>
        </TR>
        
        
        
        <%
        
        Enumeration e = itemList.elements();
        String status = null;
        
        while(e.hasMoreElements()) {
            iTotal++;
            wbo = (WebBusinessObject) e.nextElement();
            //webIssue = (WebIssue) wbo;
            flipper++;
            if((flipper%2) == 1) {
                bgColor="#c8d8f8";
            } else {
                bgColor="white";
            }
            //  issueID = (String) wbo.getAttribute("id");
        %>
        
        <TR bgcolor="<%=bgColor%>">
            
            <%
            DecimalFormat format = new DecimalFormat("0.00");
            
            attName = itemAtt[0];
            attValue = (String) wbo.getAttribute(attName);
            
            MaintenanceItemMgr maintenanceItemMgr = MaintenanceItemMgr.getInstance();
            
            %>
            
            <TD><input type="text" readonly name="code" id="code" value="<%=maintenanceItemMgr.getOnSingleKey(attValue).getAttribute("itemCode").toString()%>">
                
            </TD>
            
            <TD><input type="text" readonly name="name1" id="name1" value="<%=maintenanceItemMgr.getOnSingleKey(attValue).getAttribute("itemDscrptn").toString()%>">
                
            </TD>
            <%
            attName = itemAtt[1];
            attValue = (String) wbo.getAttribute(attName);
            // attValue = format.format(new Float(attValue));
            %>
            
            <TD> <input type="text"  name="Hqun" id="Hqun" value="<%=attValue%>" readonly>
                    
                    
                    
                </TD>
            <%
            attName = itemAtt[2];
            attValue = (String) wbo.getAttribute(attName);
            
            attValue = format.format(new Float(attValue));
            %>
            <!--TD> <input type="text" readonly name="Hprice" id="Hprice" value="<%=attValue%>">
                
                
                
            </TD>
            <%
            attName = itemAtt[3];
            attValue = (String) wbo.getAttribute(attName);
            
            attValue = format.format(new Float(attValue));   
            %>
            <TD> <input type="text" readonly name="cost" id="cost" value="<%=attValue%>">
                
                
                
            </TD-->
            
            <%
            attName = itemAtt[4];
            attValue = (String) wbo.getAttribute(attName);
            %>
            
            <TD> <input type="text"  name="Hnote" id="Hnote" value=" <%=attValue%>">
                
                
                
            </TD>
            
            
            <TD><input type="hidden" name="Hid" id="Hid" value="<%=(String) wbo.getAttribute(itemAtt[0])%>">
            </TD>
            
            
        </TR>
        <%
        }
        
        %>
        
        
        
        
        
        
    </TABLE>
    
    <input type="hidden" name="rowCount" id="rowCount" value="<%=iTotal%>">
    <%
    } 
    %>
    
    <BR>
    
    
    
</fieldset>
</BODY>
</HTML>     
