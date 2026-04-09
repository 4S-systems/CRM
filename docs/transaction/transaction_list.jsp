<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.tracker.engine.*,com.silkworm.common.*, com.tracker.common.*, java.util.*,com.tracker.business_objects.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,java.util.*,java.text.SimpleDateFormat"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,com.tracker.db_access.*"%>
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
Hashtable hashStatus = new Hashtable();

DepartmentMgr departmentMgr = DepartmentMgr.getInstance();
TradeMgr tradeMgr = TradeMgr.getInstance();
IssueMgr issueMgr = IssueMgr.getInstance();

String context = metaMgr.getContext();

//AppConstants appCons = new AppConstants();

String[] taskAttributes = {"jobOrderNO","transactionNO", "transDate","requestingDepartment","currentStatus"};
String[] taksListTitles = new String[5];

String issueId = (String) request.getAttribute(IssueConstants.ISSUEID);
String issueTitle = (String) request.getAttribute(IssueConstants.ISSUETITLE);

String filterName = (String) request.getAttribute("filter");
String filterValue = (String) request.getAttribute("filterValue");

int s = taskAttributes.length;
int t = s;
int iTotal = 0;

String attName = null;
String attValue = null;
String cellBgColor = null;


String cancel_button_label;
Vector  taskList = (Vector) request.getAttribute("data");

String  categoryName = (String) request.getAttribute("categoryName");

WebBusinessObject wbo = null;
int flipper = 0;
String bgColor = null;

TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

String cMode= (String) request.getSession().getAttribute("currentMode");
String  stat=cMode;
String align=null;
String dir=null;
String style=null;
String lang,langCode,tit,save,cancel,TT,IG,AS,QS,BO,CD,PN,NAS,PL,taskCode,taskTitle,trade,jobs,hours,Category,taskType;
String sChangeStatus,jobOrderNo,transDate,department,status,sTransactionList,QuikSummry,basicOP,sCantChange, sTransactionNO;
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
    sChangeStatus="Change Status";
    jobOrderNo="Job Order No";
    transDate="Transaction Date";
    department="Trade";
    status = "Status";
    sTransactionList="View Transaction Status";
    QuikSummry=" Quick Summary ";
    basicOP="Basic Operations";
    sTransactionNO = "Transaction NO.";
    sCantChange = "Can't Change Status";
    hashStatus.put("Submitted","Submitted");
    hashStatus.put("Granted","Granted");
    hashStatus.put("Not Available","Not Available");
    hashStatus.put("Partially","Partially");
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
    sChangeStatus="&#1594;&#1610;&#1585; &#1575;&#1604;&#1581;&#1575;&#1604;&#1577;";
    jobOrderNo="&#1585;&#1602;&#1605; &#1573;&#1584;&#1606; &#1575;&#1604;&#1588;&#1594;&#1604;";
    transDate="&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1573;&#1584;&#1606;";
    department="&#1575;&#1604;&#1602;&#1587;&#1605; &#1575;&#1604;&#1591;&#1575;&#1604;&#1576;";
    status = "&#1575;&#1604;&#1581;&#1575;&#1604;&#1577;";
    sTransactionList = "&#1593;&#1585;&#1590; &#1581;&#1575;&#1604;&#1577; &#1591;&#1604;&#1576;&#1575;&#1578; &#1575;&#1604;&#1605;&#1582;&#1575;&#1586;&#1606;";
    QuikSummry="&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1587;&#1585;&#1610;&#1593;&#1577;";
    basicOP="&#1593;&#1605;&#1604;&#1610;&#1575;&#1578; &#1571;&#1587;&#1575;&#1587;&#1610;&#1577;";
    sTransactionNO = "&#1585;&#1602;&#1605; &#1575;&#1604;&#1591;&#1604;&#1576;";
    sCantChange = "&#1604;&#1575; &#1610;&#1605;&#1603;&#1606; &#1578;&#1594;&#1610;&#1610;&#1585; &#1575;&#1604;&#1581;&#1575;&#1604;&#1577;";
    hashStatus.put("Submitted","&#1605;&#1602;&#1583;&#1605;");
    hashStatus.put("Granted","&#1603;&#1604; &#1575;&#1604;&#1591;&#1604;&#1576;");
    hashStatus.put("Not Available","&#1604;&#1575; &#1610;&#1608;&#1580;&#1583;");
    hashStatus.put("Partially","&#1576;&#1593;&#1590; &#1575;&#1604;&#1591;&#1604;&#1576;");
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
        document.ITEM_FORM.action = "main.jsp";
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
                <font color="blue" size="6"><%=sTransactionList%>
                </font>
            </td>
        </tr>
    </table>
</legend >
<br>


<br>

<TABLE ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="70%" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
    
    <TR>
        <TD CLASS="td" COLSPAN="5" bgcolor="#808000" STYLE="text-align:center;color:white;font-size:16">
            <B><%=QuikSummry%></B>
        </TD>
        <TD CLASS="td" COLSPAN="1" bgcolor="#669900" STYLE="text-align:center;color:white;font-size:16">
            <B><%=basicOP%></B>
        </TD>
        
    </TR>
    <tr>
        <TD CLASS="td" COLSPAN="1" bgcolor="#9B9B00" STYLE="text-align:center;color:white;font-size:12">
            <B><%=jobOrderNo%></B>
        </TD>
        <TD CLASS="td" COLSPAN="1" bgcolor="#9B9B00" STYLE="text-align:center;color:white;font-size:12">
            <B><%=sTransactionNO%></B>
        </TD>
        <TD CLASS="td" COLSPAN="1" bgcolor="#9B9B00" STYLE="text-align:center;color:white;font-size:12">
            <B><%=transDate%></B>
        </TD>
        <TD CLASS="td" COLSPAN="1" bgcolor="#9B9B00" STYLE="text-align:center;color:white;font-size:12">
            <B><%=department%></B>
        </TD>
        <TD CLASS="td" COLSPAN="1" bgcolor="#9B9B00" STYLE="text-align:center;color:white;font-size:12">
            <B><%=status%></B>
        </TD>
        <TD CLASS="td" COLSPAN="1" bgcolor="#7EBB00" STYLE="text-align:center;color:white;font-size:12">
            <B><%=sChangeStatus%></B>
        </TD>
        
    </tr>
    
    </TR>
    <%
    Enumeration e = taskList.elements();
    while(e.hasMoreElements()) {
        iTotal++;
        wbo = (WebBusinessObject) e.nextElement();
        
        flipper++;
        if((flipper%2) == 1) {
            bgColor="#c8d8f8";
        } else {
            bgColor="white";
        }
    %>
    <TR bgcolor="<%=bgColor%>">
        <%
        for(int i = 0;i<s;i++) {
            attName =taskAttributes[i];
            attValue = (String) wbo.getAttribute(attName);
            
            if(i==3){
                
                attName =taskAttributes[i];
                attValue = (String) wbo.getAttribute(attName);
                WebBusinessObject wboDepartment = tradeMgr.getOnSingleKey(attValue);
                attValue= wboDepartment.getAttribute("tradeName").toString();
        
        %>
        <TD  STYLE="<%=style%>" BGCOLOR="#DDDD00" nowrap  CLASS="cell" >
            <DIV>
                <b> <%=attValue%> </b>
            </DIV>
        </TD>
        <% } else {
                if(i == 4){
                    attValue = (String) hashStatus.get(attValue);
                }
                %>
        <TD  STYLE="<%=style%>" BGCOLOR="#DDDD00" nowrap  CLASS="cell" >
            <DIV >
                
                <b> <%=attValue%> </b>
            </DIV>
        </TD>
        <% } %>
        <%
        }
        String sCurrentStatus = (String) wbo.getAttribute("currentStatus");
        %>
        <TD  STYLE="<%=style%>" BGCOLOR="#D7FF82" nowrap  CLASS="cell" >
            <DIV >
                <b>
                    <%
                    if(sCurrentStatus.equalsIgnoreCase("Submitted")){
                    %>
                    <a href="<%=context%>/TransactionServlet?op=ChangeStatusForm&filterValue=<%=request.getAttribute("filterValue")%>&transactionID=<%=wbo.getAttribute("id")%>&transactionNO=<%=wbo.getAttribute("transactionNO")%>">
                        <%=sChangeStatus%>
                    </a>
                    <%
                    } else {
                    %>
                    <%=sCantChange%>
                    <%
                    }
                    %>
                </b>
            </DIV>
        </TD>
        <%
        }
        %>
    </TR>
</table>
<br>
</fieldset>
</form>
</body>
</html>
