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
String[] issueAtt = {"issueDesc","expectedBeginDate","currentStatus"};
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
String ts = (String) request.getAttribute("ts");
String issueStatus = (String) request.getAttribute("status");
String filterName = (String) request.getAttribute("filterName");
String filterValue = (String) request.getAttribute("filterValue");

WebBusinessObject eqWbo = (WebBusinessObject) request.getAttribute("eqWbo");
String unitName = new String("");
if(eqWbo != null){
    unitName = (String) eqWbo.getAttribute("unitName");
}else
    unitName = "";

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
String showDetails,searchRe,numTask,QuikSummry,basicOP,workFlow,signe,mark,viewD,DM,sta,schduled,Begined,Finished,Canceled,Holded,Rejected,external,em,pm;



if(stat.equals("En")){
    
    cancel_button_label="Back to list";
    dir="LTR";
    style="text-align:left";
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
    langCode="Ar";
    
    issueTitle =new String[8];
    issueTitle[0]="Job Order Number";
    issueTitle[1]="start date";
    issueTitle[2]="Status";
    issueTitle[3]="Maintenance Schedule Name";
    issueTitle[4]="Details";
    issueTitle[5]="Bookmark";
    issueTitle[6]="Backward";
    issueTitle[7]="Forward";
    indGuid=" Indicators guide ";
    nconfig="configured task";
    Config="Not yet configured task";
    attached="view attached files";
    notAattached="There is no attached files";
    termainanted="Termaintanted task"  ;
    notTermainanted="Not Termaintanted task"  ;
    updateTime="update date time";
    showDetails="show Details";
    searchRe="Search Results for Equipment '" + unitName + "'";
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
    
}else{
    
    cancel_button_label="&#1593;&#1608;&#1583;&#1607; &#1575;&#1604;&#1610; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1607;";
    dir="RTL";
    style="text-align:Right";
    lang="English";
    langCode="En";
    issueTitle =new String[8];
    issueTitle[0]="&#1585;&#1602;&#1605; &#1575;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
    issueTitle[1]=" &#1608;&#1602;&#1578; &#1575;&#1604;&#1576;&#1583;&#1575;&#1610;&#1577;";
    issueTitle[2]="&#1575;&#1604;&#1581;&#1575;&#1604;&#1607;";
    issueTitle[3]="&#1575;&#1587;&#1605; &#1580;&#1583;&#1608;&#1604; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1607;";
    issueTitle[4]="&#1575;&#1604;&#1578;&#1601;&#1575;&#1589;&#1610;&#1604;";
    issueTitle[5]="&#1593;&#1604;&#1575;&#1605;&#1607; ";
    issueTitle[6]= "&#1604;&#1604;&#1582;&#1604;&#1601;";
    issueTitle[7]="&#1604;&#1604;&#1571;&#1605;&#1575;&#1605;";
    indGuid= "&#1575;&#1604;&#1605;&#1585;&#1588;&#1583; &#1575;&#1604;&#1605;&#1589;&#1608;&#1585;";
    attached="&#1573;&#1590;&#1594;&#1591; &#1604;&#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583;&#1575;&#1578; &#1575;&#1604;&#1605;&#1585;&#1601;&#1602;&#1607;";
    notAattached="&#1604;&#1575; &#1610;&#1608;&#1580;&#1583; &#1605;&#1587;&#1578;&#1606;&#1583;&#1575;&#1578; &#1605;&#1585;&#1601;&#1602;&#1607;";
    termainanted="&#1605;&#1607;&#1605;&#1607; &#1605;&#1606;&#1578;&#1607;&#1610;&#1607;";
    notTermainanted="&#1605;&#1607;&#1605;&#1607; &#1594;&#1610;&#1585; &#1605;&#1606;&#1578;&#1607;&#1610;&#1607;"  ;
    Config="&#1580;&#1583;&#1608;&#1604; &#1605;&#1585;&#1578;&#1576;&#1591; &#1576;&#1602;&#1591;&#1593; &#1594;&#1610;&#1575;&#1585;";
    nconfig="&#1580;&#1583;&#1608;&#1604; &#1594;&#1610;&#1585; &#1605;&#1585;&#1578;&#1576;&#1591; &#1576;&#1602;&#1591;&#1593; &#1594;&#1610;&#1575;&#1585;";
    updateTime="&#1578;&#1581;&#1583;&#1610;&#1579; &#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1593;&#1605;&#1604;";
    showDetails="&#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1575;&#1604;&#1578;&#1601;&#1575;&#1589;&#1610;&#1604;";
    searchRe="&#1606;&#1578;&#1610;&#1580;&#1577; &#1575;&#1604;&#1576;&#1581;&#1579; &#1604;&#1604;&#1605;&#1593;&#1583;&#1577; '"+ unitName +"'";
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
}
%>


<html>
    <HEAD>
        <TITLE>Tracker- List Schedules</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
    </HEAD>
    
    
    <script type="text/javascript">
    
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
           
            var url ="<%=context%>/ScheduleServlet?op=BindSingleSchedUnit&equipmentID=<%=projectname%>";
             window.navigate(url);
        }
    </script>
    
    <body>
        <table align="<%=align%>" border="0" width="100%">
            <tr>
                <td width="50%" STYLE="border:0px;">
                    <div STYLE="width:80%;border:2px solid gray;background-color:#808000;color:white;" bgcolor="#F3F3F3" align="<%=align%>">
                        <div ONCLICK="JavaScript: changeMode('menu1');" STYLE="width:100%;background-color:#808000;color:white;cursor:hand;font-size:14;">
                            <b>
                                <%=indGuid%>
                            </b>
                            <img src="images/arrow_down.gif">
                        </div>
                        <div ALIGN="<%=align%>" STYLE="width:100%;background-color:#FFFFCC;color:white;display:none;text-align:right;border-top:2px solid gray;" ID="menu1">
                            <table align="<%=align%>" border="0" dir="<%=dir%>" width="100%" cellspacing="2">
                                <tr>
                                    <td CLASS="cell" bgcolor="#B7B700" STYLE="color:white;<%=style%>;" width="16%"><IMG SRC="images/view.png" ALIGN=""ALT="view file" > <b><%=attached%></b></td>
                                    <td CLASS="cell" bgcolor="#B7B700" STYLE="color:white;<%=style%>;" width="16%"><IMG SRC="images/unassign.gif"  ALT="Terminated Task" > <b><%=termainanted%></b></td>
                                    <td CLASS="cell" bgcolor="#B7B700" STYLE="color:white;<%=style%>;" width="16%"><IMG SRC="images/config.jpg"  ALT="Configured Schedule" > <b><%=Config%></b></td>
                                    <td CLASS="cell" bgcolor="#B7B700" STYLE="color:white;<%=style%>;" width="16%"><IMG SRC="images/timer.gif"  ALT="Update Job Date"> <b><%=updateTime%></b></td>
                                    <td CLASS="cell" bgcolor="#B7B700" STYLE="color:white;<%=style%>;" width="16%"><IMG WIDTH="20" HEIGHT="20" SRC="images/emr.gif" ALT="Emergency job order"> <b><%=em%></b></td>
                                    <td CLASS="cell" bgcolor="#B7B700" STYLE="color:white;<%=style%>;" width="16%"><IMG WIDTH="20" HEIGHT="20" SRC="images/external.gif" ALT="External job order"> <b><%=external%></b></td>
                                </tr>
                                <tr>
                                    <td CLASS="cell" bgcolor="#B7B700" STYLE="color:white;<%=style%>;"><IMG SRC="images/unview.gif" ALT="non attached file" > <b><%=notAattached%></b></td>
                                    <td CLASS="cell" bgcolor="#B7B700" STYLE="color:white;<%=style%>;"><IMG SRC="images/assign.gif" ALT="UnTerminated Task" > <b><%=notTermainanted%></b></td>
                                    <td CLASS="cell" bgcolor="#B7B700" STYLE="color:white;<%=style%>;"><IMG SRC="images/nonconfig.gif"  ALT="Un configure Schedule"> <b><%=nconfig%></b></td>
                                    <td CLASS="cell" bgcolor="#B7B700" STYLE="color:white;<%=style%>;"><IMG WIDTH="20" HEIGHT="20" src="images/metal-Inform.gif"  ALT="Un configure Schedule"> <b><%=showDetails%></b></td>
                                    <td CLASS="cell" bgcolor="#B7B700" STYLE="color:white;<%=style%>;"><IMG WIDTH="20" HEIGHT="20" SRC="images/internal.gif" ALT="Premaintative Maintenance"> <b><%=pm%></b></td>
                                    <td CLASS="cell" bgcolor="#B7B700" STYLE="color:white;<%=style%>;"></td>
                                </tr>                                
                            </table>
                        </div>
                    </div>
                </td>
            </tr>
            
            <tr>
                <td width="100%" STYLE="border:0px;">
                    
                    <div STYLE="width:80%;border:2px solid gray;background-color:#808000;color:white;" bgcolor="#F3F3F3" align="<%=align%>">
                        <div ONCLICK="JavaScript: changeMode('menu3');" STYLE="width:100%;background-color:#808000;color:white;cursor:hand;font-size:14;">
                            <b>
                                <%=sta%>
                            </b>
                            <img src="images/arrow_down.gif">
                        </div>
                        <div ALIGN="<%=align%>" STYLE="width:100%;background-color:#FFFFCC;color:white;display:none;text-align:right;border-top:2px solid gray;" ID="menu3">
                            <table width="100%">
                                <tr>
                                    <td CLASS="cell" bgcolor="#B7B700" STYLE="color:white;text-align:center;" width="16%"><b style="font-size:14px"><%=schduled%></b></td>
                                    <td CLASS="cell" bgcolor="#B7B700" STYLE="color:white;text-align:center;" width="16%"><b style="font-size:14px"><%=Begined%></b></td>
                                    <td CLASS="cell" bgcolor="#B7B700" STYLE="color:white;text-align:center;" width="16%"><b style="font-size:14px"><%=Finished%></b></td>
                                    <td CLASS="cell" bgcolor="#B7B700" STYLE="color:white;text-align:center;" width="16%"><b style="font-size:14px"><%=Canceled%></b></td>
                                    <td CLASS="cell" bgcolor="#B7B700" STYLE="color:white;text-align:center;" width="16%"><b style="font-size:14px"><%=Holded%></b></td>
                                    <td CLASS="cell" bgcolor="#B7B700" STYLE="color:white;text-align:center;" width="16%"><b style="font-size:14px"><%=Rejected%></b></td>
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
                    <td class="td">  
                        <IMG WIDTH="40" HEIGHT="40" SRC="images/Search.png">
                    </td>
                    <td class="td">
                        <font color="blue" size="6"> <%=searchRe%>
                        </font>
                    </td>
                </tr>
            </table>
        </legend >
        <TABLE align="<%=align%>" border="0"  DIR= <%=dir%>  CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
            
            <TR>
                <TD CLASS="td" COLSPAN="5" bgcolor="#808000" STYLE="text-align:center;color:white;font-size:16">
                    <B><%=QuikSummry%></B>
                </TD>
                
                <TD CLASS="td" COLSPAN="4" bgcolor="#CC9900" STYLE="text-align:center;color:white;font-size:16">
                    <B><%=indGuid%></B>
                </TD>
            </TR>
            
            <TR CLASS="head">
                <TD nowrap CLASS="firstname" BGCOLOR="#9B9B00" STYLE="border-top-WIDTH:0; font-size:12" nowrap>
                    <font color="white"><a href="" onclick="return sortTable2(0)" style="color:white;">#</a></font>
                </td>
                
                <%
                String columnColor = new String("");
                String columnWidth = new String("");
                String font = new String("");
                for(int i = 0;i<issueAtt_length+1;i++) {
                    if(i == 0 || i == 1 ||i == 2 || i==3 ){
                        columnColor = "#9B9B00";
                    } /*else if ( i==5 || i==4){
                columnColor = "#7EBB00";
                } */else {
                        columnColor = "#CCCCCC";
                }
                    if(issueTitle[i].equalsIgnoreCase("")){
                        columnWidth = "1";
                        columnColor = "black";
                        font = "1";
                    } else {
                        columnWidth = "100";
                        font = "12";
                    }
                %>  
                <TD nowrap CLASS="firstname" WIDTH="<%=columnWidth%>" bgcolor="<%=columnColor%>" STYLE="border-WIDTH:0; font-size:<%=font%>;color:white;" nowrap>
                    
                    <% 
                    if (i <= 3) {
                    %>
                    <a href="" onclick="return sortTable2(<%=i+1%>)" style="color:white;"><%=issueTitle[i]%></a>
                    <% 
                    } else { %>
                    <%=issueTitle[i]%>
                    <%
                    }
                    %>
                    
                </TD>
                
                <%
                }
                %>
                <td nowrap BGCOLOR="#FFBF00" colspan="4" CLASS="firstname" WIDTH="60" STYLE="text-align:center;border-top-WIDTH:0; font-size:12" nowrap>
                    <font color="white"> <%=signe%> </font>
                </td>
            </TR>  
            
            <tbody id="planetData2">  
                <%
                for(int index=0;index<issueList.size();index++) {
                    wbo = (WebBusinessObject) issueList.get(index);
                    webIssue = (WebIssue) wbo;
                    issueID = (String) wbo.getAttribute("id");
                %>
                <TR>
                    <%
                    for(int i = 0;i<issueAtt_length;i++) {
                        attName = issueAtt[i];
                        attValue = (String) wbo.getAttribute(attName);
                        
                        if(i==1)
                            attValue = attValue.substring(8,10)+"-"+attValue.substring(5,7)+"-"+attValue.substring(0,4);
                        
                        if(i == 0) {
                            WebBusinessObject wboSID = issueMgr.getOnSingleKey(webIssue.getAttribute("id").toString());
                            String sBID =wboSID.getAttribute("businessIDbyDate").toString();                        
                    %>
                    <TD nowrap BGCOLOR="#DDDD00" STYLE="text-align:center" CLASS="cell">
                        <b><%=index+1%> </b> 
                    </td>
                    <TD  nowrap  BGCOLOR="#DDDD00" CLASS="cell" >
                        <font color="red"><%= (String) webIssue.getAttribute("businessID")%></font><font color="blue">/<%=sBID%></font>
                    </td>
                    <%} else if(i==1) { %>
                    <TD  nowrap  BGCOLOR="#DDDD00" CLASS="cell" >
                        <% if(issueMgr.getScheduleCase(webIssue.getAttribute("id").toString())){ %>
                        <b> <%=attValue%> <IMG SRC="images/timer.gif"  ALT="Update Job Date"></b>
                        <% } else { %>
                        <b> <%=attValue%> </b>
                        <% } %>
                    </TD>
                    
                    <%
                    } else { %>
                    <TD BGCOLOR="#DDDD00" nowrap  CLASS="cell" >
                        <b> <%=attValue%> </b>
                    </TD>
                    <%
                    }
                    }
                    %>
                    <TD nowrap CLASS="cell" BGCOLOR="#DDDD00" STYLE="padding-left:10;<%=style%>;">
                        <%=webIssue.getAttribute("issueTitle")%>
                    </TD>
                    
                    <DIV align="<%=align%>">
                        
                        <td BGCOLOR="#FFE391" width="10px">
                            <%
                            boolean hasDocs=imageMgr.hasDocuments(webIssue.getAttribute("id").toString());
                            if(hasDocs){
                            %>
                            <A HREF="<%=webIssue.getViewFileLink()%>">
                                <IMG SRC="images/view.png"  WIDTH="20" HEIGHT="20" ALT="view file"> 
                            </A>
                            <%
                            } else {
                            %> 
                            <IMG SRC="images/unview.gif"  WIDTH="20" HEIGHT="20" ALT="non attached file">
                            <% } %>
                        </td>
                        
                        <td BGCOLOR="#FFE391" width="10px">
                            <%
                            boolean isTerminal=webIssue.isTerminal();
                            if (isTerminal) {
                            %>
                            
                            <IMG SRC="images/unassign.gif" WIDTH="20" HEIGHT="20"  ALT="Terminated Task">
                            
                            <%
                            } else {
                            %> 
                            
                            <IMG WIDTH="20" HEIGHT="20" SRC="images/assign.gif"  ALT="UnTerminated Task">
                            <% } %>
                        </td>
                        <td BGCOLOR="#FFE391" width="10px">
                            <%
                            ScheduleUnitId=issueMgr.getScheduleUnitId(issueID);
                            Configure= issueMgr.getConfigure(ScheduleUnitId);
                            if(Configure.equalsIgnoreCase("Yes")) {
                            %>
                            <IMG WIDTH="20" HEIGHT="20" SRC="images/config.jpg"  ALT="Configured Schedule"> 
                            <%
                            } else {
                            %> 
                            
                            <IMG WIDTH="20" HEIGHT="20" SRC="images/nonconfig.gif"  ALT="Un configure Schedule">
                            <% } %>
                        </td>
                        
                        <% 
                        String issueType=wbo.getAttribute("issueType").toString();
                        if(issueType.equalsIgnoreCase("Emergency")){%>
                        <td BGCOLOR="#FFE391" width="10px">
                            <IMG WIDTH="20" HEIGHT="20" SRC="images/emr.gif"  ALT="Emergency job order">
                        </td>
                        <% }else if(issueType.equalsIgnoreCase("External")){ %>
                        <td BGCOLOR="#FFE391" width="10px">
                            <IMG WIDTH="20" HEIGHT="20" SRC="images/external.gif"  ALT="External job order">
                        </td>
                        <%}else{%>
                        <td BGCOLOR="#FFE391" width="10px">
                            <IMG WIDTH="20" HEIGHT="20" SRC="images/internal.gif"  ALT="Planned Job Order">
                        </td>
                        <%}%>
                        
                    </div>
                </tr>
                <%}%>
                <tr>
                    <TD CLASS="cell" BGCOLOR="#808080" COLSPAN="5" STYLE="<%=style%>padding-right:5;border-right-width:1;color:white;font-size:14;">
                        <B><%=numTask%></B>
                    </TD>
                    <TD CLASS="cell" BGCOLOR="#808080" colspan="4" STYLE="<%=style%>;padding-left:5;;color:white;font-size:14;">
                        
                        <DIV NAME="" ID="">
                            <B><%=issueList.size()%></B>
                        </DIV>
                    </TD>
                </tr>
            </tbody>
        </table>
    </body>
</html>