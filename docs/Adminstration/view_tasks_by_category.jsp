<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*"%>
<%@ page contentType="text/html; charset=UTF-8"%>
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
TradeMgr tradeMgr = TradeMgr.getInstance();
EmployeeTitleMgr employeeTitleMgr = EmployeeTitleMgr.getInstance();
TaskTypeMgr taskTypeMgr = TaskTypeMgr.getInstance();

TaskMgr taskMgr = TaskMgr.getInstance();

String context = metaMgr.getContext();

//AppConstants appCons = new AppConstants();

String[] taskAttributes = {"title","taskTitle","trade","empTitle","taskType"};
String[] taksListTitles = new String[4];


int s = taskAttributes.length;
int t = s;
int iTotal = 0;

String attName = null;
String attValue = null;
String cellBgColor = null;


String cancel_button_label;
Vector  taskList = (Vector) request.getAttribute("data");

String  categoryName = (String) request.getAttribute("categoryName");
WebBusinessObject catWbo=(WebBusinessObject)request.getAttribute("catWbo");

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
String lang,langCode,tit,save,cancel,TT,IG,AS,QS,BO,CD,PN,NAS,PL,taskCode,taskTitle,trade,jobs,hours,Category,taskType;
String noEmpTitle;
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
    QS="Main Data for Tasks";
    BO="Basic Operations";
    taksListTitles[0]="Maintenance Item Code";
    taksListTitles[1]="View";
    taksListTitles[2]="Edit";
    taksListTitles[3]="Delete";
    CD="Can't Delete Task";
    PN="Maintenance Item No.";
    PL="Maintenance Items List";
    taskCode="Task Code";
    taskTitle="Task Title";
    trade="Trade";
    jobs="Job type";
    hours="Rate hours";
    cancel_button_label="Cancel ";
    Category="Category";
    taskType="Task type";
    noEmpTitle = "have not employee title";
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
    QS="&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1576;&#1606;&#1608;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
    BO="&#1593;&#1605;&#1604;&#1610;&#1575;&#1578; &#1571;&#1587;&#1575;&#1587;&#1610;&#1577;";
    taksListTitles[0]="&#1576;&#1606;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
    taksListTitles[1]="&#1605;&#1588;&#1575;&#1607;&#1583;&#1607;";
    taksListTitles[2]="&#1578;&#1581;&#1585;&#1610;&#1585;";
    taksListTitles[3]="&#1581;&#1584;&#1601;";
    CD="&#1604;&#1575; &#1610;&#1605;&#1603;&#1606; &#1581;&#1584;&#1601; &#1576;&#1606;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
    PN=" &#1593;&#1583;&#1583; &#1576;&#1606;&#1608;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
    PL="&#1593;&#1585;&#1590; &#1576;&#1606;&#1608;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
    taskCode="&#1603;&#1608;&#1583; &#1576;&#1606;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
    taskTitle="&#1608;&#1589;&#1601; &#1575;&#1604;&#1576;&#1606;&#1583;";
    trade="&#1575;&#1604;&#1605;&#1580;&#1605;&#1608;&#1593;&#1577; &#1575;&#1604;&#1601;&#1606;&#1610;&#1577;";
    jobs="&#1606;&#1608;&#1593; &#1575;&#1604;&#1608;&#1592;&#1610;&#1601;&#1577;";
    hours="&#1605;&#1578;&#1608;&#1587;&#1591; &#1575;&#1604;&#1587;&#1575;&#1593;&#1575;&#1578;";
    cancel_button_label="&#1573;&#1606;&#1607;&#1575;&#1569; ";
    Category=" &#1575;&#1604;&#1589;&#1606;&#1601;";
    taskType="&#1606;&#1608;&#1593; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
    noEmpTitle ="&#1604;&#1575; &#1578;&#1608;&#1580;&#1583; &#1605;&#1607;&#1606;&#1577;";
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
        
        function cancelForm()
        {    
        document.ITEM_FORM.action = "<%=context%>/TaskServlet?op=tasksByCategory";
        document.ITEM_FORM.submit();  
        }
</script>
<body>
    
<FORM NAME="ITEM_FORM" METHOD="POST">
<DIV align="left" STYLE="color:blue;">
    <input type="button"  value="<%=lang%>"  onclick="reloadAE('<%=langCode%>')" class="button">
    <button  onclick="JavaScript: cancelForm();" class="button"><%=cancel_button_label%><IMG VALIGN="BOTTOM"   SRC="images/cancel.gif"> </button>
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

<center> <b> <font size="3" color="red"> <%=PN%> : <%=taskList.size()%> </font></b></center> 
<center> <b> <font size="3" color="red"> <%=Category%> : <font color="green"><%=catWbo.getAttribute("unitName").toString()%> </font></font></b></center> 
<br>

<TABLE ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="400" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
    
    <!--TR>
    <TD CLASS="td" COLSPAN="5" bgcolor="#808000" STYLE="text-align:center;color:white;font-size:16">
    <B><%=QS%></B>
    </TD>
   
    </tr-->
    <tr>
        <TD CLASS="silver_header" COLSPAN="1" bgcolor="#669900" STYLE="text-align:center;font-size:14">
            <B><%=taskCode%></B>
        </TD>
        <TD CLASS="silver_header" COLSPAN="1" bgcolor="#669900" STYLE="text-align:center;font-size:14">
            <B><%=taskTitle%></B>
        </TD>
        <TD CLASS="silver_header" COLSPAN="1" bgcolor="#669900" STYLE="text-align:center;font-size:14">
            <B><%=taskType%></B>
        </TD>
        <TD CLASS="silver_header" COLSPAN="1" bgcolor="#669900" STYLE="text-align:center;font-size:14">
            <B><%=trade%></B>
        </TD>
        <TD CLASS="silver_header" COLSPAN="1" bgcolor="#669900" STYLE="text-align:center;font-size:14">
            <B><%=jobs%></B>
        </TD>
        <!--TD CLASS="td" COLSPAN="1" bgcolor="#669900" STYLE="text-align:center;color:white;font-size:12">
            <B><%=hours%></B>
        </TD-->
        
        
    </tr>
    
    </TR>
    <%
    
    Enumeration e = taskList.elements();
    
    
    while(e.hasMoreElements()) {
    iTotal++;
    wbo = (WebBusinessObject) e.nextElement();
    
    flipper++;
                    if((flipper%2) == 1) {
                        bgColor = "silver_odd";
                        bgColorm = "silver_odd_main";
                    } else {
                       bgColor = "silver_even";
                       bgColorm = "silver_even_main";
                    }
    %>
    
    <TR bgcolor="<%=bgColor%>">
        <%
        for(int i = 0;i<s;i++) {
        attName =taskAttributes[i];
        attValue = (String) wbo.getAttribute(attName);
        if (i==2) {
        attName =taskAttributes[i];
        attValue = (String) wbo.getAttribute(attName);
        WebBusinessObject wboTrade = tradeMgr.getOnSingleKey(attValue);
        attValue= wboTrade.getAttribute("tradeName").toString();
        
        %>
        
        
        <TD  STYLE="<%=style%>" BGCOLOR="#DDDD00" nowrap  class="<%=bgColorm%>" >
            <DIV >
                
                <b> <%=attValue%> </b>
            </DIV>
        </TD>
        
        <% } else if  (i==3) {
        attName =taskAttributes[i];
        attValue = (String) wbo.getAttribute(attName);
        WebBusinessObject wboEmpTitle = employeeTitleMgr.getOnSingleKey(attValue);
        if (wboEmpTitle != null && !wboEmpTitle.equals("")){
            attValue= wboEmpTitle.getAttribute("name").toString();
        } else {
            attValue = noEmpTitle;
            }
        
        
        %>
        <TD  STYLE="<%=style%>" BGCOLOR="#DDDD00" nowrap  class="<%=bgColor%>" >
            <DIV >
                
                <b> <%=attValue%> </b>
            </DIV>
        </TD>
        <% } else if  (i==4) {
        attName =taskAttributes[i];
        attValue = (String) wbo.getAttribute(attName);
        WebBusinessObject wboTasktype = taskTypeMgr.getOnSingleKey(attValue);
        attValue= wboTasktype.getAttribute("name").toString();
        
        %>
        <TD  STYLE="<%=style%>" BGCOLOR="#DDDD00" nowrap  class="<%=bgColor%>" >
            <DIV >
                
                <b> <%=attValue%> </b>
            </DIV>
        </TD>
        <% } else { %>
        <TD  STYLE="<%=style%>" BGCOLOR="#DDDD00" nowrap  class="<%=bgColor%>" >
            <DIV >
                
                <b> <%=attValue%> </b>
            </DIV>
        </TD>
        <% } %>
        
        <%
        }}
        %>
        
        
        
        
        
    </TR>
    
    <TR>
        <TD CLASS="silver_footer" BGCOLOR="#808080" COLSPAN="4" STYLE="<%=style%>;padding-right:5;border-right-width:1;font-size:14;">
            <B><%=PN%></B>
        </TD>
        <TD CLASS="silver_footer" BGCOLOR="#808080" colspan="1" STYLE="<%=style%>;padding-left:5;font-size:14;">
            
            <DIV NAME="" ID="">
                <B><%=iTotal%></B>
            </DIV>
        </TD>
    </TR>
</table>
<br>
</fieldset>
</form>
</body>
</html>
