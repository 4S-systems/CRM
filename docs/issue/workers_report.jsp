<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.TradeMgr"%>  
<%
MetaDataMgr metaMgr = MetaDataMgr.getInstance();
String context = metaMgr.getContext();
TradeMgr tradeMgr = TradeMgr.getInstance();

TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

WebBusinessObject wbo = (WebBusinessObject) request.getAttribute("wbo");
String currentStatus = new String("");
if(wbo.getAttribute("currentStatus") != null){
    currentStatus = (String) wbo.getAttribute("currentStatus");
}

Vector vecPlannedTasks = (Vector) request.getAttribute("vecPlannedTasks");
Vector vecTasksHours = (Vector) request.getAttribute("vecTasksHours");

Hashtable taskByEmpHash = (Hashtable) request.getAttribute("taskByEmpHash"); 


Hashtable hashtable = new Hashtable();
hashtable.put("1", "&#1578;&#1588;&#1581;&#1610;&#1605;");
hashtable.put("2", "&#1578;&#1586;&#1610;&#1610;&#1578;");

String bgColor, bgColor2;
double iConfigureTotal = 0;
double iQuantifiedTotal = 0;
double iActualTotal = 0;

bgColor="#FFFFCC";
bgColor2="#CCCC00";

String cMode= (String) request.getSession().getAttribute("currentMode");
String  stat=cMode;

String align=null;
String dir=null;
String style=null;
String lang,langCode,ViewSpars,BackToList,schduled,finished,categlog,ToCost, sWorkerName,
        Begined,Finished,Canceled,Holded,Rejected,status,cost,count,price,sJob,onCreate,sTitle, sMaintenanceItem,empNo, sMinute ,sHour ,sDay ;
if(stat.equals("En")){
    
    align="center";
    dir="LTR";
    style="text-align:left";
    
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
    langCode="Ar";
    ViewSpars="View Spare Parts";
    BackToList = "Back to list";
    schduled="Scheduled";
    Begined="Begined";
    Finished="Finished";
    Canceled="Canceled";
    Holded="on Hold";
    Rejected="Rejected";
    status="Status";
    sJob="Job";
    sHour="Minutes";
    price="Price";
    count="countity";
    cost="Cost";
    finished="Workers";
    categlog="Planned Spare Parts";
    onCreate="Maintenance Items and Jobs";
    ToCost="Total Cost";
    sTitle="Workers Report";
    sMaintenanceItem = "Maintenance Item";
    sWorkerName = "Worker Name";
     empNo="Employee No#";
       sMinute = "Minute";
    sHour = "Hour";
    sDay = "Day";
}else{
    
    align="center";
    dir="RTL";
    style="text-align:Right";
    lang="English";
    langCode="En";
    ViewSpars=" &#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1602;&#1591;&#1593; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585;";
    BackToList = "&#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1573;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577;";
    schduled="&#1605;&#1580;&#1583;&#1608;&#1604;&#1577;";
    Begined="&#1576;&#1583;&#1571;&#1578;";
    Finished="&#1573;&#1606;&#1578;&#1607;&#1578;";
    Canceled="&#1605;&#1604;&#1594;&#1575;&#1577;";
    Holded="&#1605;&#1608;&#1602;&#1608;&#1601;&#1577;";
    Rejected="&#1605;&#1585;&#1601;&#1608;&#1590;&#1577;";
    status="&#1575;&#1604;&#1581;&#1575;&#1604;&#1577;";
    sJob="&#1575;&#1604;&#1605;&#1607;&#1606;&#1577;";
    sHour="&#1583;&#1602;&#1600;&#1600;&#1610;&#1600;&#1600;&#1602;&#1600;&#1600;&#1607;";
    price="&#1587;&#1593;&#1585; &#1575;&#1604;&#1608;&#1581;&#1583;&#1577;";
    count="&#1575;&#1604;&#1603;&#1605;&#1610;&#1577;";
    cost="&#1573;&#1580;&#1605;&#1575;&#1604;&#1610; &#1575;&#1604;&#1587;&#1593;&#1585;";
    finished="&#1575;&#1604;&#1593;&#1605;&#1575;&#1604;&#1577;";
    categlog="&#1602;&#1591;&#1593; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585; &#1575;&#1604;&#1605;&#1582;&#1591;&#1591;&#1577;";
    onCreate="&#1576;&#1606;&#1608;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577; &#1608;&#1575;&#1604;&#1605;&#1607;&#1606;";
    ToCost="&#1573;&#1580;&#1605;&#1575;&#1604;&#1610;";
    sTitle="&#1578;&#1602;&#1585;&#1610;&#1585; &#1575;&#1604;&#1593;&#1605;&#1575;&#1604;&#1577;";
    sMaintenanceItem = "&#1576;&#1606;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1607;";
    sWorkerName = "&#1575;&#1587;&#1605; &#1575;&#1604;&#1593;&#1575;&#1605;&#1604;";
    empNo="&#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1608;&#1592;&#1601;";
 sMinute = "&#1583;&#1602;&#1610;&#1602;&#1577;";
    sHour = "&#1587;&#1575;&#1593;&#1577;";
    sDay = "&#1610;&#1608;&#1605;";
}
Vector empTasksVec = new Vector();
WebBusinessObject empTasksWbo = new WebBusinessObject();
%>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

  function cancelForm()
        {    
        document.PROJECT_VIEW_FORM.action = "<%=context%>/AssignedIssueServlet?op=viewdetails&issueId=<%=request.getParameter("issueId")%>&filterValue=<%=request.getParameter("filterValue")%>&filterName=<%=request.getParameter("filterName")%>";
        document.PROJECT_VIEW_FORM.submit();  
        }
       function changeMode(name){
        if(document.getElementById(name).style.display == 'none'){
            document.getElementById(name).style.display = 'block';
        } else {
            document.getElementById(name).style.display = 'none';
        }
    }                              
    
    function changePage(url){
        window.navigate(url);
    }
</SCRIPT>
<script src='ChangeLang.js' type='text/javascript'></script>
<HTML>
    
    
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>Document Viewer - add new Project</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        
        <style>
            .header
            {
            background: #2B6FBB url(images/gradienu.gif);
            color: #ffffff;
            height:30;
            font: bold 16px Times New Roman;
            }
            .tRow
            {
            background: #ABCDEF;
            color: #083E76;
            font: bold 13px black Times New Roman;
            }
            
            .tRow2
            {
            background: White;
            color: #083E76;
            font: bold 13px black Times New Roman;
            }
            .bar
            {
            background: #BDD5F1 url(images/gradient.gif) repeat-x top left;
            color: #083E76;
            font: bold 13px Times New Roman;
            }
            td{
            border-right-width:1px;
            }
        </style>
        
    </HEAD>
    <BODY>
        
        <FORM NAME="PROJECT_VIEW_FORM" METHOD="POST">
            <%if(request.getAttribute("Tap")==null){%>
            <table align="<%=align%>" border="0" width="100%">
                <tr>
                <td STYLE="border:0px;">
                <div STYLE="width:50%;border:2px solid gray;background-color:#808000;color:white;" bgcolor="#F3F3F3" align="<%=align%>">
                    <div ONCLICK="JavaScript: changeMode('menu1');" STYLE="width:100%;background-color:#808000;color:white;cursor:hand;font-size:14;">
                        <b>
                            <%=status%> 
                        </b>
                        <img src="images/arrow_down.gif">
                    </div>
                    <div ALIGN="center" STYLE="width:100%;background-color:#FFFFCC;color:white;display:none;<%=style%>;border-top:2px solid gray;" ID="menu1">
                        <table align="center" border="0" dir="<%=dir%>" width="100%" cellspacing="2">
                            <tr>
                                <td style="text-align:center" CLASS="cell" width="16%" bgcolor="#EEE8AA" STYLE="color:black;<%=style%>;"><b><%=schduled%></b></td>
                                <td style="text-align:center" CLASS="cell" width="16%" bgcolor="#EEE8AA" STYLE="color:black;<%=style%>;"><b><%=Begined%></b></td>
                                <td style="text-align:center" CLASS="cell" width="16%" bgcolor="#EEE8AA" STYLE="color:black;<%=style%>;"><b><%=Finished%></b></td>
                                <td style="text-align:center" CLASS="cell" width="16%" bgcolor="#EEE8AA" STYLE="color:black;<%=style%>;"><b><%=Canceled%></b></td>
                                <td style="text-align:center" CLASS="cell" width="16%" bgcolor="#EEE8AA" STYLE="color:black;<%=style%>;"><b><%=Holded%></b></td>
                                <td style="text-align:center" CLASS="cell" width="16%" bgcolor="#EEE8AA" STYLE="color:black;<%=style%>;"><b><%=Rejected%></b></td>
                            </tr>
                            <tr>
                                <td style="text-align:center" CLASS="cell" bgcolor="#F3F3F3"><%if(currentStatus.equalsIgnoreCase("Schedule")){%><IMG SRC="images/don.gif" ALT="" ><%} else {%>&nbsp;<%}%></td>
                                <td style="text-align:center" CLASS="cell" bgcolor="#F3F3F3"><%if(currentStatus.equalsIgnoreCase("Assigned")){%><IMG SRC="images/don.gif" ALT="" ><%} else {%>&nbsp;<%}%></td>
                                <td style="text-align:center"CLASS="cell" bgcolor="#F3F3F3"><%if(currentStatus.equalsIgnoreCase("Finished")){%><IMG SRC="images/don.gif" ALT="" ><%} else {%>&nbsp;<%}%></td>
                                <td style="text-align:center"CLASS="cell" bgcolor="#F3F3F3"><%if(currentStatus.equalsIgnoreCase("Canceled")){%><IMG SRC="images/don.gif" ALT="" ><%} else {%>&nbsp;<%}%></td>
                                <td style="text-align:center"CLASS="cell" bgcolor="#F3F3F3"><%if(currentStatus.equalsIgnoreCase("Onhold")){%><IMG SRC="images/don.gif" ALT="" ><%} else {%>&nbsp;<%}%></td>
                                <td style="text-align:center"CLASS="cell" bgcolor="#F3F3F3"><%if(currentStatus.equalsIgnoreCase("Rejected")){%><IMG SRC="images/don.gif" ALT="" ><%} else {%>&nbsp;<%}%></td>
                            </tr>
                            
                        </table>
                    </div>
                </div>
            </table>
            <DIV align="left" STYLE="color:blue;">
                <input type="button" class="button" value="     <%=lang%>     " onclick="reloadAE('<%=langCode%>')">
                <button  class="button" onclick="JavaScript: cancelForm();"><%=BackToList%> <IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif"> </button>
            </DIV>
            
            <%}%>
            <fieldset align="center" style="border-color:blue" >
            <legend align="<%=align%>">
                
                <table dir="<%=dir%>" align="<%=align%>">
                    <tr>
                        
                        <td class="td">
                            <font color="blue" size="6">   <%=sTitle%>
                            </font>
                            
                        </td>
                    </tr>
                </table>
            </legend >
            <br><br>
            <table align="<%=align%>" border="0" dir="<%=dir%>" width="95%">
                <tr>
                    <TD CLASS="td" VALIGN="top">
                        <table ALIGN="<%=align%>" DIR="<%=dir%>" width ="100%">
                            <TR>
                                <TD STYLE="border:1px solid black" width ="33%" VALIGN="top" COLSPAN="2">
                                    <table border="0" ALIGN="<%=align%>" DIR="<%=dir%>" width ="100%" cellpadding="0" cellspacing="1">
                                        <TR>
                                            <TD style="text-align:center" CLASS="header" bgcolor="#F3F3F3" width="63%" COLSPAN="5">
                                                <b><%=onCreate%></b>
                                            </TD>
                                        </TR>
                                        <%
                                        String classStyle="tRow2";
                                        for(int i = 0; i < vecPlannedTasks.size(); i++){
                                            WebBusinessObject wboPlanned = (WebBusinessObject) vecPlannedTasks.get(i);
                                            WebBusinessObject wboTrade = tradeMgr.getOnSingleKey((String) wboPlanned.getAttribute("trade"));
                                            
                                         //   if((i%2)==1){
                                               classStyle="tRow2";
                                         //   } else {
                                          //      classStyle="tRow";
                                         //   }                                        
                                        
                                        %>
                                        <TR bgcolor="#808080">
                                            <TD CLASS="header" STYLE="border:0px;color:white">
                                                <b><%=sMaintenanceItem%></b>
                                            </TD>
                                            <TD CLASS="header" STYLE="border:0px;color:white">
                                                <b><%=sJob%></b>
                                            </TD>
                                            <TD CLASS="header" STYLE="border:0px;color:white">
                                                <b><%=sMinute%></b>
                                            </TD>
                                            <TD CLASS="header" STYLE="border:0px;color:white">
                                                <b><%=sHour%></b>
                                            </TD>
                                            <TD CLASS="header" STYLE="border:0px;color:white">
                                                <b><%=sDay%></b>
                                            </TD>
                                        </TR>
                                        
                                        <TR BGCOLOR="<%=bgColor%>">
                                            <TD CLASS="<%=classStyle%>" STYLE="border:0px">
                                                <%=wboPlanned.getAttribute("name")%>
                                            </TD>
                                            <TD CLASS="<%=classStyle%>" STYLE="border:0px">
                                                <%=wboTrade.getAttribute("tradeName")%>
                                            </TD>
                                            <TD CLASS="<%=classStyle%>" STYLE="border:0px">
                                                
                                                <%
                                                 int day =0;
                                int minute=0;
                                int hour =0;
                                String exeHours =wboPlanned.getAttribute("executionHrs").toString();
                                int exehour = Integer.parseInt(exeHours);
                                day = (exehour/ 60)/24;
                                hour =( exehour - day*24*60)/60;
                                minute = exehour - day*24*60 - hour*60;
                                             
        %>
        <%=minute%>
                                            </TD>
                                            
                                             <TD CLASS="<%=classStyle%>" STYLE="border:0px">
                                                <%=hour%>
                                            </TD>
                                                <TD CLASS="<%=classStyle%>" STYLE="border:0px">
                                                <%=day%>
                                            </TD>
                                        </TR>
                                        <% 
                                        
                                            empTasksVec = (Vector) taskByEmpHash.get(wboPlanned.getAttribute("taskId"));
                                           if(empTasksVec.size()>0){
                                        %>
                                        <TR>
                                            <TD STYLE="border:1px solid black" width ="33%" VALIGN="top" COLSPAN="3" ALIGN="<%=align%>" DIR="<%=dir%>">
                                            <table border="0" ALIGN="<%=align%>" DIR="<%=dir%>" width ="100%" cellpadding="0" cellspacing="1">
                                                <TR ALIGN="<%=align%>" DIR="<%=dir%>">
                                                    <TD ALIGN="<%=align%>" DIR="<%=dir%>" style="text-align:center;"  bgcolor="#CACAFF" width="33%" COLSPAN="3">
                                                        <font size="3" color="#000080"> <B><%=finished%></B></font>
                                                    </TD>
                                                </TR>
                                                <TR bgcolor="#808080" ALIGN="<%=align%>" DIR="<%=dir%>">
                                                   <TD  STYLE="border:0px;color:white" bgcolor="#EAEAFF"  ALIGN="<%=align%>" DIR="<%=dir%>">
                                                       <font size="3" color="#000080"> <b><%=empNo%></b></font>
                                                    </TD>
                                                    <TD  STYLE="border:0px;color:white" bgcolor="#EAEAFF"  ALIGN="<%=align%>" DIR="<%=dir%>">
                                                       <font size="3" color="#000080"> <b><%=sWorkerName%></b></font>
                                                    </TD>
                                                    <TD  STYLE="border:0px;color:white" bgcolor="#EAEAFF"  ALIGN="<%=align%>" DIR="<%=dir%>">
                                                        <font size="3" color="#000080"><b><%=sHour%></b></font>
                                                    </TD>
                                                </TR>
                                                <%

                                                for(int x = 0; x < empTasksVec.size(); x++){
                                                    WebBusinessObject wboTasks = (WebBusinessObject) empTasksVec.get(x);
                                                     wboTrade = tradeMgr.getOnSingleKey((String) wboTasks.getAttribute("trade"));
                                                  //  if((x%2)==1){
                                                        classStyle="tRow2";
                                                //    } else {
                                                 //       classStyle="tRow";
                                                 //   }
                                                %>
                                                <TR BGCOLOR="<%=bgColor%>" ALIGN="<%=align%>" DIR="<%=dir%>">
                                                    <TD CLASS="<%=classStyle%>"  STYLE="border:0px"  ALIGN="<%=align%>" DIR="<%=dir%>">
                                                    <%=wboTasks.getAttribute("empNo")%>
                                                    </TD>
                                                    <TD CLASS="<%=classStyle%>"  STYLE="border:0px"  ALIGN="<%=align%>" DIR="<%=dir%>">
                                                        <%=wboTasks.getAttribute("empName")%>
                                                    </TD>
                                                    <TD CLASS="<%=classStyle%>"  STYLE="border:0px"  ALIGN="<%=align%>" DIR="<%=dir%>">
                                                        <%=wboTasks.getAttribute("actualHours")%>
                                                    </TD>
                                                </TR>
                                                <%
                                                } }
                                                %>
                                            </table>
                                        </TD>
                                        </TR>
                                        <%
                                        }
                                        %>
                                    </table>
                                </TD>
                                
                            </TR>
                        </table>
                    </TD>
                </tr>
            </table>
            </fieldset>
        </FORM>
    </BODY>
</HTML>     
