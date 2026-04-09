
<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.engine.*"%>
<%@ page import="com.silkworm.business_objects.*,com.maintenance.db_access.*"%>
<html>
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
<meta HTTP-EQUIV="Expires" CONTENT="0">
<head>
    <title>Create New Schedule</title>
    <link REL="stylesheet" TYPE="text/css" HREF="CSS.css">
</head>

<%


MetaDataMgr metaMgr = MetaDataMgr.getInstance();
TradeMgr tradeMgr = TradeMgr.getInstance();
String context = metaMgr.getContext();
String filterName = request.getParameter("filterName");
String filterValue = request.getParameter("filterValue");
System.out.println("kkkkkmain "+request.getAttribute("mainTitle"));

ArrayList items=(ArrayList)request.getAttribute("items");
String id=request.getAttribute("id").toString();
String cMode= (String) request.getSession().getAttribute("currentMode");
String  stat=cMode;
String align=null;
String dir=null;
String style=null;
System.out.println("hiiii "+request.getAttribute("projectName"));

String lang,langCode,TC,TN,TH,TJ,back;

if(stat.equals("En")){
    
    align="center";
    dir="LTR";
    style="text-align:left";
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
    langCode="Ar";
    
    TC="Maintenance Item Code";
    TN="Maintenance Item  Name";
    TH="Estimated Time";
    TJ="Trade";
    back="back";
    
    
}else{
    
    align="center";
    dir="RTL";
    style="text-align:right";
    lang="   English    ";
    langCode="En";
    back="&#1593;&#1608;&#1583;&#1607;";
    TC="&#1603;&#1608;&#1583; &#1576;&#1606;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1607;";
    TN="&#1573;&#1587;&#1605; &#1575;&#1604;&#1576;&#1606;&#1583;";
    TH="&#1575;&#1604;&#1587;&#1575;&#1593;&#1575;&#1578; &#1575;&#1604;&#1605;&#1578;&#1608;&#1602;&#1593;&#1607;";
    TJ="&#1575;&#1604;&#1605;&#1580;&#1605;&#1608;&#1593;&#1577; &#1575;&#1604;&#1601;&#1606;&#1610;&#1577;";
    
    
}

WebBusinessObject wboTrade = new WebBusinessObject();

%>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">   
 function cancelForm()
        {    
         document.Backform.submit();
        }
</SCRIPT>
<TABLE ALIGN="<%=align%>" DIR="<%=dir%>"  border="0" WIDTH=80%  ID="listTable">
    
    <%if(request.getAttribute("mainTitle")!=null){%>
    <DIV align="left" STYLE="color:blue;">
        <form name="Backform" action="<%=context%>/AssignedIssueServlet?op=VIEWDETAILS&issueId=<%=id%>&filterName=<%=filterName%>&filterValue=<%=filterValue%>&projectName=<%=request.getAttribute("projectName")%>" method="post">
            <input type="button" value="<%=back%>" onclick="cancelForm();" class="button">
            <input type="hidden" name="mainTitle" id="mainTitle" value="<%=request.getAttribute("mainTitle")%>">
        </form>
    </DIV> 
    
    <%}%>
    <TR>
        <td></td>
        <TD CLASS="head"  > <b><%=TC%></b></TD>
        <TD CLASS="head" ><b><%=TN%> </b></TD>        
        <TD CLASS="head" ><b><%=TJ%> </b></TD>
        <!--TD CLASS="head" ><b><%=TH%> </b></TD-->
        
    </TR>
    <%for(int i=0;i<items.size();i++){
    WebBusinessObject item=(WebBusinessObject)items.get(i);
    %>
    <TR>
        <td></td>
        <TD BGCOLOR="white" ><b><%=item.getAttribute("title").toString()%></b></TD>
        <TD BGCOLOR="white" ><b><%=item.getAttribute("name").toString()%> </b></TD> 
        <% wboTrade = tradeMgr.getOnSingleKey(item.getAttribute("trade").toString()); %>
        <TD BGCOLOR="white" ><b><%=wboTrade.getAttribute("tradeName").toString()%> </b></TD>
        <!--TD BGCOLOR="white" ><b><%=item.getAttribute("executionHrs").toString()%> </b></TD-->
        
    </TR>
    <%}%>
    
    
</TABLE>
</FORM>
</BODY>