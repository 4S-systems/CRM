<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="com.tracker.engine.IssueStatusFactory, com.tracker.engine.*,com.docviewer.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  

<%
System.out.println("in JSP ---------");
AppConstants appCons = new AppConstants();
WebIssue webIssue = null;

String projectname = (String) request.getParameter("projectName");
MetaDataMgr metaMgr = MetaDataMgr.getInstance();
String context = metaMgr.getContext();
String[] issueAtt = {"expectedBeginDate"};
String[] issueTitle ;

int issueAtt_length = issueAtt.length;
int t = issueAtt_length+5;

String attName = null;
String attValue = null;
String cellBgColor = null;

IssueMgr issueMgr = IssueMgr.getInstance();

Vector  issueList = (Vector) request.getAttribute("data");

WebBusinessObject wbo = null;
int flipper = 0;
String bgColor = null;
String bgColorm = null;
String ts = (String) request.getAttribute("ts");
String issueStatus = (String) request.getAttribute("status");
String filterName = (String) request.getAttribute("filterName");
String filterValue = (String) request.getAttribute("filterValue");
String scheduleId=(String)request.getAttribute("scheduleId");
String unitId=(String)request.getAttribute("unitId");

WebBusinessObject eqWbo = (WebBusinessObject) request.getAttribute("eqWbo");
String unitName = new String("");
String eqId="";
if(eqWbo != null){
    eqId=eqWbo.getAttribute("id").toString();
    unitName = (String) eqWbo.getAttribute("unitName");
}else
    unitName = "All";

String issueID = null;
String UnitName = null;
String MaintenanceTitle=null;
String ScheduleUnitId=null;
String Configure = null;

ImageMgr imageMgr = ImageMgr.getInstance();

String cMode= (String) request.getSession().getAttribute("currentMode");
String  stat=cMode;
String align="center";
String dir=null;
String style=null;
String cancel_button_label;
String lang,langCode,indGuid,attached,termainanted,nconfig,Config,updateTime,notAattached,notTermainanted;
String showDetails,searchRe,numTask,QuikSummry,basicOP,workFlow,signe,mark,viewD,DM,sta,schduled,Begined,Finished,Canceled,Holded,Rejected,external,em,pm,from,to;
String scheduleTitle="";

String beginDate=(String)request.getAttribute("beginDate");
String endDate=(String)request.getAttribute("endDate");

String cancelIssue,keepIssue,all,eqpName,assignIssue,addLateReason;

if(stat.equals("En")){
    
    cancel_button_label="Back to list";
    dir="LTR";
    style="text-align:left";
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
    langCode="Ar";
    
    issueTitle =new String[2];
    issueTitle[0]="Date";
    issueTitle[1]="Operation";
    
    indGuid=" Indicators guide ";
    nconfig="configured task";
    Config="Not yet configured task";
    attached="view attached files";
    notAattached="There is no attached files";
    termainanted="Termaintanted task"  ;
    notTermainanted="Not Termaintanted task"  ;
    updateTime="update date time";
    showDetails="show Details";
    searchRe="Late Job Orders for Equipment '" + unitName + "'";
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
    from="In period from";
    to="To";
    cancelIssue="Cancel";
    keepIssue="View";
    all="Late Job Order For All Equipments";
    eqpName="Equipment Name";
    assignIssue="Assign";
    addLateReason="Add Late Reason";
    scheduleTitle="Schedule Title";
    
}else{
    
    cancel_button_label="&#1593;&#1608;&#1583;&#1607; &#1575;&#1604;&#1610; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1607;";
    dir="RTL";
    style="text-align:Right";
    lang="English";
    langCode="En";
    issueTitle =new String[2];
    issueTitle[0]="&#1575;&#1604;&#1578;&#1575;&#1585;&#1610;&#1582;";
    issueTitle[1]="&#1593;&#1605;&#1604;&#1610;&#1575;&#1578;";
    
    indGuid= "&#1575;&#1604;&#1605;&#1585;&#1588;&#1583; &#1575;&#1604;&#1605;&#1589;&#1608;&#1585;";
    attached="&#1573;&#1590;&#1594;&#1591; &#1604;&#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583;&#1575;&#1578; &#1575;&#1604;&#1605;&#1585;&#1601;&#1602;&#1607;";
    notAattached="&#1604;&#1575; &#1610;&#1608;&#1580;&#1583; &#1605;&#1587;&#1578;&#1606;&#1583;&#1575;&#1578; &#1605;&#1585;&#1601;&#1602;&#1607;";
    termainanted="&#1605;&#1607;&#1605;&#1607; &#1605;&#1606;&#1578;&#1607;&#1610;&#1607;";
    notTermainanted="&#1605;&#1607;&#1605;&#1607; &#1594;&#1610;&#1585; &#1605;&#1606;&#1578;&#1607;&#1610;&#1607;"  ;
    Config="&#1580;&#1583;&#1608;&#1604; &#1605;&#1585;&#1578;&#1576;&#1591; &#1576;&#1602;&#1591;&#1593; &#1594;&#1610;&#1575;&#1585;";
    nconfig="&#1580;&#1583;&#1608;&#1604; &#1594;&#1610;&#1585; &#1605;&#1585;&#1578;&#1576;&#1591; &#1576;&#1602;&#1591;&#1593; &#1594;&#1610;&#1575;&#1585;";
    updateTime="&#1578;&#1581;&#1583;&#1610;&#1579; &#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1593;&#1605;&#1604;";
    showDetails="&#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1575;&#1604;&#1578;&#1601;&#1575;&#1589;&#1610;&#1604;";
    searchRe="&#1571;&#1608;&#1575;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604; &#1575;&#1604;&#1605;&#1578;&#1571;&#1582;&#1585;&#1607; &#1604;&#1604;&#1605;&#1593;&#1583;&#1607; '"+ unitName +"'";
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
    from="&#1601;&#1609; &#1575;&#1604;&#1601;&#1578;&#1585;&#1607; &#1605;&#1606;";
    to="&#1575;&#1604;&#1609;";
    cancelIssue="&#1573;&#1604;&#1594;&#1575;&#1569;";
    keepIssue="&#1605;&#1588;&#1575;&#1607;&#1583;&#1607;";
    all="&#1571;&#1608;&#1575;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604; &#1575;&#1604;&#1605;&#1578;&#1571;&#1582;&#1585;&#1607; &#1604;&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1583;&#1575;&#1578;";
    eqpName="&#1575;&#1587;&#1605; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;";
    assignIssue="&#1573;&#1587;&#1606;&#1575;&#1583;";
    addLateReason="&#1571;&#1590;&#1601; &#1587;&#1576;&#1576; &#1578;&#1571;&#1582;&#1610;&#1585;";
    scheduleTitle="&#1575;&#1587;&#1605; &#1575;&#1604;&#1580;&#1583;&#1608;&#1604;";
}
%>


<html>
    <HEAD>
        <TITLE>Tracker- List Schedules</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="css\headers.css">
        <script src="js/sorttable.js"></script>
    </HEAD>
    
    
    <script type="text/javascript">
    
        function assignIssue(issueId,issuetitle){
            var url ="<%=context%>/AssignedIssueServlet?op=assign&state=SCHEDULE&viewOrigin=null&issueId="+issueId+"&direction=forward&planType=late&issueTitle="+issuetitle;
            window.navigate(url);
        }
        
        function addLateReason(issueId){
            var url ="<%=context%>/EquipmentServlet?op=addDelayReason&backTo=lateJO&planType=late&issueId="+issueId;
            window.navigate(url);
        }
          
     function reloadAE(nextMode){
      
       var url = "<%=context%>/ajaxGetItrmName?key="+nextMode;
            if (window.XMLHttpRequest)
            { 
                req = new XMLHttpRequest(); 
            } 
               else if (window.ActiveXObject)
            { 
                req = new ActiveXObject("Microsoft.XMLHTTP"); 
            } 
            req.open("Post",url,true); 
            req.onreadystatechange =  callbackFillreload;
            req.send(null);
      
      }
      
      function callbackFillreload(){
         if (req.readyState==4)
            { 
               if (req.status == 200)
                { 
                     window.location.reload();
                }
            }
       }
       
       
        function changeMode(name){
            if(document.getElementById(name).style.display == 'none'){
                document.getElementById(name).style.display = 'block';
            } else {
                document.getElementById(name).style.display = 'none';
            }
        }
        
        function cancelForm()
        {    
            var url ="main.jsp";
            window.navigate(url);
        }
        
        function cancelIssue(issueId)
        {   
            var r=confirm("Are You Sure you need to cancel this Job Order");
            if (r==true)
              {
                    var url ="<%=context%>/SearchServlet?op=cancelPlannedIssue&issueId="+issueId+"&unitId=<%=unitId%>&beginDate=<%=beginDate%>&endDate=<%=endDate%>&planType=late";
                    window.navigate(url);
              }
        }
        
        function keepIssue(issueId)
        {    
            alert("Your Job Order Now keeped in the plan");
            var url ="<%=context%>/ProgressingIssueServlet?op=keepIssue&issueId="+issueId+"&scheduleId=<%=scheduleId%>&eqpId=<%=eqId%>&planType=late";
           // window.navigate(url);
        }
        
        function viewIssue(link)
        {   
            window.navigate(link);
        }
        
    </script>
    
    <body>
        <table align="<%=align%>" border="0" width="100%">
            <tr>
                <td width="50%" STYLE="border:0px;">
                    <div STYLE="margin: auto;width:80%;border:2px solid gray;background-color:#91a6b7;color:white;" bgcolor="#F3F3F3" align="<%=align%>">
                        <div ONCLICK="JavaScript: changeMode('menu1');" STYLE="width:100%;background-color:#91a6b7;color:white;cursor:hand;font-size:14;">
                            <b>
                                <%=indGuid%>
                            </b>
                            <img src="images/arrow_down.gif">
                        </div>
                        <div ALIGN="<%=align%>" STYLE="width:100%;background-color:#FFFFCC;color:white;display:none;text-align:right;border-top:2px solid gray;" ID="menu1">
                            <table align="<%=align%>" border="0" dir="<%=dir%>" width="100%" cellspacing="2">
                                <tr>
                                    <td CLASS="cell" bgcolor="#B7B700" STYLE="background-color: #f3f3f3;<%=style%>;" width="16%"><IMG SRC="images/view.png" ALIGN=""ALT="view file" > <b><%=attached%></b></td>
                                    <td CLASS="cell" bgcolor="#B7B700" STYLE="background-color: #f3f3f3;<%=style%>;" width="16%"><IMG SRC="images/unassign.gif"  ALT="Terminated Task" > <b><%=termainanted%></b></td>
                                    <td CLASS="cell" bgcolor="#B7B700" STYLE="background-color: #f3f3f3;<%=style%>;" width="16%"><IMG SRC="images/config.jpg"  ALT="Configured Schedule" > <b><%=Config%></b></td>
                                    <td CLASS="cell" bgcolor="#B7B700" STYLE="background-color: #f3f3f3;<%=style%>;" width="16%"><IMG SRC="images/timer.gif"  ALT="Update Job Date"> <b><%=updateTime%></b></td>
                                    <td CLASS="cell" bgcolor="#B7B700" STYLE="background-color: #f3f3f3;<%=style%>;" width="16%"><IMG WIDTH="20" HEIGHT="20" SRC="images/emr.gif" ALT="Emergency job order"> <b><%=em%></b></td>
                                    <td CLASS="cell" bgcolor="#B7B700" STYLE="background-color: #f3f3f3;<%=style%>;" width="16%"><IMG WIDTH="20" HEIGHT="20" SRC="images/external.gif" ALT="External job order"> <b><%=external%></b></td>
                                </tr>
                                <tr>
                                    <td CLASS="cell" bgcolor="#B7B700" STYLE="background-color: #f3f3f3;<%=style%>;"><IMG SRC="images/unview.gif" ALT="non attached file" > <b><%=notAattached%></b></td>
                                    <td CLASS="cell" bgcolor="#B7B700" STYLE="background-color: #f3f3f3;<%=style%>;"><IMG SRC="images/assign.gif" ALT="UnTerminated Task" > <b><%=notTermainanted%></b></td>
                                    <td CLASS="cell" bgcolor="#B7B700" STYLE="background-color: #f3f3f3;<%=style%>;"><IMG SRC="images/nonconfig.gif"  ALT="Un configure Schedule"> <b><%=nconfig%></b></td>
                                    <td CLASS="cell" bgcolor="#B7B700" STYLE="background-color: #f3f3f3;<%=style%>;"><IMG WIDTH="20" HEIGHT="20" src="images/metal-Inform.gif"  ALT="Un configure Schedule"> <b><%=showDetails%></b></td>
                                    <td CLASS="cell" bgcolor="#B7B700" STYLE="background-color: #f3f3f3;<%=style%>;"><IMG WIDTH="20" HEIGHT="20" SRC="images/internal.gif" ALT="Premaintative Maintenance"> <b><%=pm%></b></td>
                                    <td CLASS="cell" bgcolor="#B7B700" STYLE="background-color: #f3f3f3;<%=style%>;"></td>
                                </tr>                                
                            </table>
                        </div>
                    </div>
                </td>
            </tr>
            
            <tr>
                <td width="100%" STYLE="border:0px;">
                    
                    <div STYLE="margin: auto;width:80%;border:2px solid gray;background-color:#91a6b7;color:white;" bgcolor="#F3F3F3" align="<%=align%>">
                        <div ONCLICK="JavaScript: changeMode('menu3');" STYLE="width:100%;background-color:#91a6b7;color:white;cursor:hand;font-size:14;">
                            <b>
                                <%=sta%>
                            </b>
                            <img src="images/arrow_down.gif">
                        </div>
                        <div ALIGN="<%=align%>" STYLE="width:100%;background-color:#FFFFCC;color:white;display:none;text-align:right;border-top:2px solid gray;" ID="menu3">
                            <table width="100%">
                                <tr>
                                    <td CLASS="cell" bgcolor="#B7B700" STYLE="background-color: #f3f3f3;text-align:center;" width="16%"><b style="font-size:14px"><%=schduled%></b></td>
                                    <td CLASS="cell" bgcolor="#B7B700" STYLE="background-color: #f3f3f3;text-align:center;" width="16%"><b style="font-size:14px"><%=Begined%></b></td>
                                    <td CLASS="cell" bgcolor="#B7B700" STYLE="background-color: #f3f3f3;text-align:center;" width="16%"><b style="font-size:14px"><%=Finished%></b></td>
                                    <td CLASS="cell" bgcolor="#B7B700" STYLE="background-color: #f3f3f3;text-align:center;" width="16%"><b style="font-size:14px"><%=Canceled%></b></td>
                                    <td CLASS="cell" bgcolor="#B7B700" STYLE="background-color: #f3f3f3;text-align:center;" width="16%"><b style="font-size:14px"><%=Holded%></b></td>
                                    <td CLASS="cell" bgcolor="#B7B700" STYLE="background-color: #f3f3f3;text-align:center;" width="16%"><b style="font-size:14px"><%=Rejected%></b></td>
                                </tr>
                            </table>
                        </div>
                    </div>
                    
                    
                </td>
            </tr>
        </table>
        
        <DIV align="left" STYLE="color:blue;">
            <input type="button"  value="<%=lang%>"  onclick="reloadAE('<%=langCode%>')" class="button">
            <button  onclick="JavaScript: cancelForm();" class="button"><%=cancel_button_label%><IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif"> </button>
        </div>
        <fieldset >
        <legend align="center">
            
            <table dir=" <%=dir%>" align="<%=align%>">
                <tr>
                    <td class="td" style="text-align:center">
                        <b>
                            <font color="blue" size="5"> 
                                <%if(unitId.equalsIgnoreCase("All")){%>
                                <%=all%>
                                <%}else{%>
                                <%=searchRe%>
                                <%}%>
                                <br>
                                <%=from%>                        
                            </font>
                            <font color="red" size="3"><%=beginDate%></font>
                            <font color="blue" size="4"> &nbsp;&nbsp;<%=to%>&nbsp;&nbsp;</font><font color="red" size="3"><%=endDate%>
                            </font>
                        </b>
                    </td>
                </tr>
            </table>
        </legend >
        
        <br>
        <TABLE align="<%=align%>" WIDTH="800" border="0"  DIR= <%=dir%>  CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
            <TR>
                <TD class="blueBorder blueHeaderTD" bgcolor="#808000" STYLE="text-align:center;color:white;font-size:18">
                    <B><%=QuikSummry%></B>
                </TD>
                
            </TR>
        </table>
        <TABLE class="sortable" WIDTH="800" align="<%=align%>" border="0"  DIR= <%=dir%>  CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
            <TR >
                <TH CLASS="silver_header"style="font-size: 14;" WIDTH="30">#</TH>
                
                <TH CLASS="silver_header"style="font-size: 14;" WIDTH="200">
                    <%=issueTitle[0]%>
                </TH>  
                <%if(unitId.equalsIgnoreCase("All")){%>
                <TH CLASS="silver_header"style="font-size: 14;" WIDTH="200">
                    <%=eqpName%>
                </TH>  
                <%}%>
                
                <TH CLASS="silver_header"style="font-size: 14;" WIDTH="200">
                    <%=scheduleTitle%>
                </TH> 
                
                <TH CLASS="silver_header"style="font-size: 14;" COLSPAN="6" WIDTH="200">
                    <%=issueTitle[1]%>
                </TH> 
            </TR>  
            
            <%
            String className="tRow2";
            int count=0;
            for(int index=0;index<issueList.size();index++) {
                wbo = (WebBusinessObject) issueList.get(index);
                webIssue = (WebIssue) wbo;
                issueID = (String) wbo.getAttribute("id");
                if((index%2)==1)
                    className="tRow2";
                else
                    className="tRow";
                
                String status=webIssue.getAttribute("currentStatus").toString();
                if(!status.equalsIgnoreCase("Canceled")){
                    count++;
            %>
            <TR>
                <%
                for(int i = 0;i<issueAtt.length;i++) {
                        attName = issueAtt[i];
                        attValue = (String) wbo.getAttribute(attName);
                        flipper++;
                         if((flipper%2) == 1) {
                        bgColor="silver_odd";
                        bgColorm = "silver_odd_main";
                    } else {
                        bgColor= "silver_even";
                         bgColorm = "silver_even_main";
                    }
                %>
                <TD CLASS="<%=bgColorm%>">
                    <b><%=count%> </b> 
                </td>
                <TD CLASS="<%=bgColor%>" >
                    
                    <% if(issueMgr.getScheduleCase(webIssue.getAttribute("id").toString())){ %>
                    <A HREF="<%=context%>/IssueServlet?op=ViewUpdateJobIssueDate&issueId=<%=webIssue.getAttribute("id")%>&backTo=lateJO">
                        <b> <%=attValue%> <IMG SRC="images/timer.gif"  ALT="Update Job Date"></b>
                    </a>
                    <% } else { %>
                    <b> <%=attValue%> </b>
                    <% } %>
                </TD>
                
                <%if(unitId.equalsIgnoreCase("All")){%>
                <TD CLASS="<%=bgColor%>">
                    <b><%=webIssue.getAttribute("unitName").toString()%></b>
                </TD>
                <%}%>
                
                <TD CLASS="<%=bgColor%>">
                    <%=webIssue.getAttribute("issueTitle").toString()%>
                </td>
                
                <%--
                <TD CLASS="bar" >
                    <%
                    String checkCmplx=(String)wbo.getAttribute("issueType");
                    if(checkCmplx.equalsIgnoreCase("cmplx")){
                    %>
                    <button style="width:80" onclick="JavaScript: viewIssue('<%=context%>/ComplexIssueServlet?op=viewDetailsCmplx&issueId=<%=issueID%>&filterValue=null&filterName=null&mainTitle=cmplx');">
                        <font color="black" size="2"><B><%=keepIssue%></B></font>
                    </button>
                    <%}else{%>
                    <button style="width:80" onclick="JavaScript: viewIssue('<%=context%>/AssignedIssueServlet?op=VIEWDETAILS&issueId=<%=issueID%>');">
                        <font color="black" size="2"><B><%=keepIssue%></B></font>
                    </button>
                    
                    <%}%>
                </TD>
                --%>
                
                <TD  CLASS="<%=bgColor%>" >
                    <button style="width:80"  onclick="JavaScript: assignIssue('<%=issueID%>','<%=webIssue.getAttribute("issueTitle").toString()%>');">
                        <font color="black" size="2"><b><%=assignIssue%></b></font>
                    </button>
                </td>
                
                <TD  CLASS="<%=bgColor%>" >
                    <button style="width:110"  onclick="JavaScript: addLateReason('<%=issueID%>');">
                        <font color="black" size="2"><b><%=addLateReason%></b></font>
                    </button>
                </td>
                
                <TD  CLASS="<%=bgColor%>" >
                    <button style="width:80"  onclick="JavaScript: cancelIssue('<%=issueID%>');">
                        <font color="black" size="2"><b><%=cancelIssue%></b></font>
                    </button>
                </TD> 
                
            </TR>
            <%}}}%>
        </table>
        <TABLE align="<%=align%>" WIDTH="800" border="0"  DIR= <%=dir%>  CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
            <tr>
                <TD CLASS="silver_footer" BGCOLOR="#808080" COLSPAN="2" STYLE="<%=style%>padding-right:5;border-right-width:1;">
                    <font color="black" size="3">  <B><%=numTask%></B></FONT>
                </TD>
                <%if(unitId.equalsIgnoreCase("All")){%>
                <TD CLASS="silver_footer" BGCOLOR="#808080" colspan="5" STYLE="text-align:center;padding-left:5;;color:Black;font-size:16;">
                    <font color="black" size="3">  <B><%=count%></B></FONT>
                </TD>
                <%}else{%>
                <TD CLASS="silver_footer" BGCOLOR="#808080" colspan="5" STYLE="text-align:center;padding-left:5;;color:Black;font-size:16;">
                    <font color="black" size="3">  <B><%=count%></B></FONT>
                </TD>
                <%}%>
            </tr>
        </table>
        <input type="hidden" name="scheduleId" id="scheduleId" value="<%=scheduleId%>">
        <input type="hidden" name="eqpId" id="eqpId" value="<%=eqId%>">
    </body>
</html>