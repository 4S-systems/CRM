<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<HTML>
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Expires" CONTENT="0">
<HEAD>
    <TITLE>System Projects List</TITLE>
    <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
</HEAD>
<%

MetaDataMgr metaMgr = MetaDataMgr.getInstance();
TaskMgr taskMgr = TaskMgr.getInstance();


String context = metaMgr.getContext();

//AppConstants appCons = new AppConstants();

String[] taskAttributes = {"title"};
String taskNames=null;

String[] taksListTitles = new String[5];


int s = taskAttributes.length;
int t = s+4;
int iTotal = 0;

String attName = null;
String attValue = null;
String cellBgColor = null;

String status=(String)request.getAttribute("status");

Vector  taskList = (Vector) request.getAttribute("data");


WebBusinessObject wbo = null;
int flipper = 0;
String bgColor = null;
String bgColorm = null;

TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

String cMode= (String) request.getSession().getAttribute("currentMode");
String  stat=cMode;
String align=null;
String dir=null;
String style=null;
String lang,langCode,tit,save,cancel,TT,IG,AS,QS,BO,CD,PN,NAS,PL,delSuccess,delFail;
if(stat.equals("En")){
    
    align="center";
    dir="LTR";
    style="text-align:left";
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
    langCode="Ar";
    tit="Delete Schedule - Are you Sure ?";
    save="Delete";
    cancel="Back To List";
    TT="Task Title ";
    IG="Indicators guide ";
    AS="Active Task by job order";
    NAS="Non Active Task";
    QS="Quick Summary";
    BO="Basic Operations";
    taksListTitles[0]="Maintenance Item Code";
    taksListTitles[1]="Item Name";
    taksListTitles[2]="View";
    taksListTitles[3]="Edit";
    taksListTitles[4]="Delete";
    CD="Can't Delete Task";
    PN="Maintenance Item No.";
    PL="Maintenance Items List";
    delSuccess="Item Deleted Successfully";
    delFail="Fail To Delete Item";
}else{
    
    align="center";
    dir="RTL";
    style="text-align:Right";
    lang="English";
    langCode="En";
    tit=" &#1581;&#1584;&#1601; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607; - &#1607;&#1604; &#1571;&#1606;&#1578; &#1605;&#1578;&#1571;&#1603;&#1583;&#1567;";
    save=" &#1573;&#1581;&#1584;&#1601;";
    cancel=" &#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1573;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577; ";
    TT="&#1593;&#1606;&#1608;&#1575;&#1606; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607;";
    IG="&#1575;&#1604;&#1605;&#1585;&#1588;&#1583; &#1575;&#1604;&#1605;&#1589;&#1608;&#1585;";
    AS="&#1576;&#1606;&#1583; &#1589;&#1610;&#1575;&#1606;&#1577; &#1605;&#1585;&#1578;&#1576;&#1591; &#1576;&#1571;&#1605;&#1585; &#1588;&#1594;&#1604;";
    NAS="&#1576;&#1606;&#1583; &#1589;&#1610;&#1575;&#1606;&#1577; &#1594;&#1610;&#1585; &#1606;&#1588;&#1591;";
    QS="&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1587;&#1585;&#1610;&#1593;&#1577;";
    BO="&#1593;&#1605;&#1604;&#1610;&#1575;&#1578; &#1571;&#1587;&#1575;&#1587;&#1610;&#1577;";
    taksListTitles[0]="&#1576;&#1606;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
    taksListTitles[1]="&#1575;&#1587;&#1605; &#1575;&#1604;&#1576;&#1606;&#1583;";
    taksListTitles[2]="&#1605;&#1588;&#1575;&#1607;&#1583;&#1607;";
    taksListTitles[3]="&#1578;&#1581;&#1585;&#1610;&#1585;";
    taksListTitles[4]="&#1581;&#1584;&#1601;";
    CD="&#1604;&#1575; &#1610;&#1605;&#1603;&#1606; &#1581;&#1584;&#1601; &#1576;&#1606;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
    PN=" &#1593;&#1583;&#1583; &#1576;&#1606;&#1608;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
    PL="&#1593;&#1585;&#1590; &#1576;&#1606;&#1608;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
    delSuccess="&#1578;&#1600;&#1600;&#1605; &#1581;&#1600;&#1600;&#1584;&#1601; &#1575;&#1604;&#1600;&#1600;&#1576;&#1600;&#1600;&#1606;&#1600;&#1600;&#1583; &#1576;&#1600;&#1600;&#1606;&#1600;&#1600;&#1580;&#1600;&#1600;&#1575;&#1581;";
    delFail="&#1604;&#1605; &#1610;&#1600;&#1600;&#1578;&#1600;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1600;&#1600;&#1581;&#1600;&#1600;&#1600;&#1584;&#1601;";
}

%>
<script language="javascript" type="text/javascript">
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
</script>
<body>

<table align="<%=align%>" border="0" width="100%">
    <tr>
        <td STYLE="border:0px;">
            <div STYLE="margin: auto;width:75%;border:2px solid gray;background-color:#9db0c1;color:white;" bgcolor="#F3F3F3" align="center">
                <div ONCLICK="JavaScript: changeMode('menu1');" STYLE="width:100%;background-color:#9db0c1;color:white;cursor:hand;font-size:16;">
                    <b>
                        <%=IG%>  
                    </b>
                    <img src="images/arrow_down.gif">
                </div>
                <div ALIGN="center" STYLE="width:100%;background-color:#FFFFCC;color:white;display:none;<%=style%>;border-top:2px solid gray;" ID="menu1">
                    <table align="<%=align%>" border="0" dir="<%=dir%>" width="100%" cellspacing="2">
                        <tr>
                            <td CLASS="indicator" bgcolor="white" STYLE="<%=style%>" width="50%"><IMG SRC="images/active.jpg" ALT="<%=AS%>" ALIGN="<%=align%>"> <b><%=AS%></b></td>
                            <td CLASS="indicator" bgcolor="white" STYLE="<%=style%>" width="50%"><IMG SRC="images/nonactive.jpg" ALT="<%=NAS%>" ALIGN="<%=align%>"> <b><%=NAS%></b></td>
                        </tr>
                    </table>
                </div>
            </div>
        </td>
    </tr>
</table>
<DIV align="left" STYLE="color:blue;">
    <input type="button"  value="<%=lang%>"  onclick="reloadAE('<%=langCode%>')" class="button">
    
</DIV> 

<fieldset align=center class="set">
<legend align="center">
    
    <table dir=" <%=dir%>" align="<%=align%>">
        <tr>
            
            <td class="td">
                <font color="blue" size="6"><%=PL%> 
                </font>
            </td>
        </tr>
    </table>
</legend >
<br>

<%if(status!=null){%>
<table dir=" <%=dir%>" align="<%=align%>">
    <tr>
        <%if(status.equalsIgnoreCase("ok")){%>
        <td>
            <font color="blue" size="3"><b><%=delSuccess%></b></font>
        </td>
        <%}else{%>
        <td>
            <font color="blue" size="3"><b><%=delFail%></b></font>
        </td>
        <%}%>
    </tr>
</table>
<br>
<%}%>


<center> <b> <font size="3" color="red"> <%=PN%> : <%=taskList.size()%> </font></b></center> 
<br>

<TABLE ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="400" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">

<TR>
    <TD class="blueBorder blueHeaderTD" COLSPAN="2" bgcolor="#808000" STYLE="text-align:center;color:white;font-size:18">
        <B><%=QS%></B>
    </TD>
    <TD class="blueBorder blueHeaderTD" COLSPAN="3" bgcolor="#669900" STYLE="text-align:center;color:white;font-size:18">
        <B><%=BO%></B>
    </TD>
    <TD class="blueBorder blueHeaderTD" COLSPAN="1" bgcolor="#CC9900" STYLE="text-align:center;color:white;font-size:18">
        <B><%=IG%> </b>
    </TD>
</tr>

<TR CLASS="head">
    
    <%
    String columnColor = new String("");
    String columnWidth = new String("");
    String font = new String("");
    for(int i = 0;i<t;i++) {
        if(i == 0){
            columnColor = "#9B9B00";
        } else if(i==1) {
             columnColor = "#9B9B00";
            }
            else {
            columnColor = "#7EBB00";
        }
        if(taksListTitles[i].equalsIgnoreCase("")){
            columnWidth = "1";
            columnColor = "black";
            font = "1";
        } else {
            columnWidth = "100";
            font = "12";
        }
    %>                
    <TD nowrap CLASS="silver_header" WIDTH="<%=columnWidth%>" bgcolor="<%=columnColor%>" STYLE="border-WIDTH:0; font-size:<%=font%>;" nowrap>
        <B><%=taksListTitles[i]%></B>
    </TD>
    <%
    }
    %>
    <TD nowrap CLASS="silver_header" BGCOLOR="#FFBF00" WIDTH="135" STYLE="border-WIDTH:0; font-size:12" COLSPAN="1" nowrap>
        &nbsp;
        </TD>
    
</TR>
<%

Enumeration e = taskList.elements();
String categoryId="";

while(e.hasMoreElements()) {
    
    categoryId="";
    wbo = (WebBusinessObject) e.nextElement();
    iTotal++;
    categoryId=wbo.getAttribute("parentUnit").toString();
    flipper++;
    if((flipper%2) == 1) {
                        bgColor="silver_odd";
                        bgColorm = "silver_odd_main";
                    } else {
                        bgColor= "silver_even";
                         bgColorm = "silver_even_main";
                    }
%>

<TR >
    <%
    for(int i = 0;i<s;i++) {
        attName =taskAttributes[i];
        attValue = (String) wbo.getAttribute(attName);
        taskNames=(String) wbo.getAttribute("name");
    %>
    
    <TD  STYLE="<%=style%>" BGCOLOR="#DDDD00" nowrap  CLASS="<%=bgColorm%>" >
        <DIV >
            
            <b> <%=attValue%> </b>
        </DIV>
    </TD>
    
     <TD  STYLE="<%=style%>" BGCOLOR="#DDDD00" nowrap  CLASS="<%=bgColor%>" WIDTH="150" >
        <DIV >
            
            <b> <%= taskNames %> </b>
        </DIV>
    </TD>
    <%
    }
    %>
    
    <TD nowrap CLASS="<%=bgColor%>"  BGCOLOR="#D7FF82" STYLE="<%=style%>">
        <DIV ID="links">
            <%if(categoryId.equalsIgnoreCase("no")||categoryId.equalsIgnoreCase("")){%>
            <A HREF="<%=context%>/TaskServlet?op=viewTaskMain&taskId=<%=wbo.getAttribute("id")%>">
                <%=taksListTitles[2]%>
            </A>
            <%}else{%>
            <A HREF="<%=context%>/TaskServlet?op=view&taskId=<%=wbo.getAttribute("id")%>">
                <%=taksListTitles[2]%>
            </A>
            <%}%>
        </DIV>
    </TD>
    
    <TD nowrap CLASS="<%=bgColor%>"  BGCOLOR="#D7FF82" STYLE="<%=style%>">
        <DIV ID="links">
            <%if(categoryId.equalsIgnoreCase("no")||categoryId.equalsIgnoreCase("")){%>
            <A HREF="<%=context%>/TaskServlet?op=GetTaskMainUpdate&taskId=<%=wbo.getAttribute("id")%>">
                <%=taksListTitles[3]%>
            </A>
            <%}else{%>
            <A HREF="<%=context%>/TaskServlet?op=GetTaskUpdate&taskId=<%=wbo.getAttribute("id")%>">
                <%=taksListTitles[3]%>
            </A>
            <%}%>
        </DIV>
    </TD>
    </DIV>
    <%
    // if(taskMgr.getActiveTask(wbo.getAttribute("id").toString())) {
    
    %>
    
    <!--TD nowrap CLASS="cell"  BGCOLOR="#D7FF82" STYLE="<%=style%>">
        <DIV ID="links">
    <%=CD%>
            
        </DIV>
    </td-->
    <%
    //} else {
    %> 
    <TD nowrap CLASS="<%=bgColor%>"  BGCOLOR="#D7FF82" STYLE="<%=style%>">
        
        <DIV ID="links">---
            <!--A HREF="<%=context%>/TaskServlet?op=confdel&taskId=<%=wbo.getAttribute("id")%>&taskTitle=<%=wbo.getAttribute("title")%>">
                <%=taksListTitles[4]%>
            </A-->
        </DIV>
    </TD>
    <% //}%>
    
    
    <TD WIDTH="20px" nowrap BGCOLOR="#FFE391" CLASS="<%=bgColor%>">
        <%
        if(taskMgr.getActiveTask(wbo.getAttribute("id").toString())) {
        %>
        <IMG SRC="images/active.jpg"  ALT="<%=AS%>"> 
        
        
        <%
        } else {
        %> 
        
        <IMG SRC="images/nonactive.jpg"  ALT="<%=NAS%>">
        <% } %>
    </TD>        
    
    <% } %>
    
</TR>

<TR>
    <TD CLASS="silver_footer" BGCOLOR="#808080" COLSPAN="5" STYLE="<%=style%>;padding-right:5;border-right-width:1;font-size:16;">
        <B><%=PN%></B>
    </TD>
    <TD CLASS="silver_footer" BGCOLOR="#808080" colspan="1" STYLE="<%=style%>;padding-left:5;font-size:16;">
        
        <DIV NAME="" ID="">
            <B><%=iTotal%></B>
        </DIV>
    </TD>
</TR>
</table>
<br>
</fieldset>
</body>
</html>
