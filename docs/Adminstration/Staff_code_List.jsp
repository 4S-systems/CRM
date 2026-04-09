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
StaffCodeMgr staffCodeMgr = StaffCodeMgr.getInstance();
String context = metaMgr.getContext();

//AppConstants appCons = new AppConstants();

String[] staffCodeAttributes = {"crewStaffName"};
String[] staffCodeListTitles = new String[4];

int s = staffCodeAttributes.length;
int t = s+3;
int iTotal = 0;

String attName = null;
String attValue = null;
String cellBgColor = null;



Vector  staffCodeList = (Vector) request.getAttribute("data");


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
String lang,langCode,tit,save,cancel,TT,IG,AS,QS,BO,CD,PN,NAS,PL;
if(stat.equals("En")){
    
    align="center";
    dir="LTR";
    style="text-align:left";
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
    langCode="Ar";
    tit="Staff Code List";
    save="Delete";
    cancel="Back To List";
    TT="Task Title ";
    IG="Indicators guide ";
    AS="Active Staff Code By Employee";
    NAS="Non Active Staff Code ";
    QS="Quick Summary";
    BO="Basic Operations";
    staffCodeListTitles[0]="Staff Code";
    staffCodeListTitles[1]="View";
    staffCodeListTitles[2]="Edit";
    staffCodeListTitles[3]="Delete";
    CD="Can't Delete Crew";
    PN="Codes No.";
    PL="Crew Mission List";
}else{
    
    align="center";
    dir="RTL";
    style="text-align:Right";
    lang="English";
    langCode="En";
    tit="&#1593;&#1585;&#1590; &#1571;&#1603;&#1608;&#1575;&#1583; &#1575;&#1604;&#1601;&#1585;&#1602;";
    save=" &#1573;&#1581;&#1584;&#1601;";
    cancel=" &#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1573;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577; ";
    TT="&#1593;&#1606;&#1608;&#1575;&#1606; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607;";
    IG="&#1575;&#1604;&#1605;&#1585;&#1588;&#1583; &#1575;&#1604;&#1605;&#1589;&#1608;&#1585;";
    AS="&#1575;&#1604;&#1605;&#1608;&#1592;&#1601; &#1605;&#1585;&#1578;&#1576;&#1591; &#1576;&#1601;&#1585;&#1610;&#1602; &#1593;&#1605;&#1604;";
    NAS="&#1605;&#1608;&#1592;&#1601; &#1594;&#1610;&#1585; &#1605;&#1585;&#1578;&#1576;&#1591; &#1576;&#1601;&#1585;&#1610;&#1602;";
    QS="&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1587;&#1585;&#1610;&#1593;&#1577;";
    BO="&#1593;&#1605;&#1604;&#1610;&#1575;&#1578; &#1571;&#1587;&#1575;&#1587;&#1610;&#1577;";
    staffCodeListTitles[0]="&#1575;&#1604;&#1603;&#1608;&#1583;";
    staffCodeListTitles[1]="&#1605;&#1588;&#1575;&#1607;&#1583;&#1607;";
    staffCodeListTitles[2]="&#1578;&#1581;&#1585;&#1610;&#1585;";
    staffCodeListTitles[3]="&#1581;&#1584;&#1601;";
    CD=" &#1604;&#1575;&#1578;&#1587;&#1578;&#1591;&#1610;&#1593; &#1581;&#1584;&#1601; &#1575;&#1604;&#1601;&#1585;&#1610;&#1602;";
    PN=" &#1593;&#1583;&#1583; &#1575;&#1604;&#1571;&#1603;&#1608;&#1575;&#1583;";
    PL=" &#1593;&#1585;&#1590; &#1601;&#1585;&#1602; &#1575;&#1604;&#1593;&#1605;&#1604;";
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
                            <td CLASS="indicator" bgcolor="white" STYLE="<%=style%>" width="50%"><IMG SRC="images/active.jpg" ALT="<%=AS%>" ALIGN="<%=align%>"> <B><%=AS%></B></td>
                            <td CLASS="indicator" bgcolor="white" STYLE="<%=style%>" width="50%"><IMG SRC="images/nonactive.jpg" ALT="<%=NAS%>" ALIGN="<%=align%>"> <B><%=NAS%></B></td>
                        </tr>
                    </table>
                </div>
            </div>
        </td>
    </tr>
</table>
<br>
<DIV align="left" STYLE="color:blue;">
    <input type="button"  value="<%=lang%>"  onclick="reloadAE('<%=langCode%>')" class="button">
    
</DIV> 

<fieldset align=center class="set">
<legend align="center">
    
    <table dir=" <%=dir%>" align="<%=align%>">
        <tr>
            
            <td class="td">
                <font color="blue" size="6"><%=tit%> 
                </font>
            </td>
        </tr>
    </table>
</legend >
<br>

<center> <b> <font size="3" color="red"> <%=PN%> : <%=staffCodeList.size()%> </font></b></center> 


<TABLE DIR="<%=dir%>" ALIGN="<%=align%>" WIDTH="400" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">

<TABLE  DIR="<%=dir%>" ALIGN="<%=align%>" WIDTH="400" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">

<br>
<TABLE ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="400" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">

<TR>
    <TD class="blueBorder blueHeaderTD" COLSPAN="1" bgcolor="#808000" STYLE="text-align:center;color:white;font-size:18">
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
        if(i == 0 ){
            columnColor = "#9B9B00";
        } else {
            columnColor = "#7EBB00";
        }
        if(staffCodeListTitles[i].equalsIgnoreCase("")){
            columnWidth = "1";
            columnColor = "black";
            font = "1";
        } else {
            columnWidth = "100";
            font = "12";
        }
    %>                
    <TD nowrap CLASS="silver_header" WIDTH="<%=columnWidth%>" bgcolor="<%=columnColor%>" STYLE="border-WIDTH:0; font-size:<%=font%>;" nowrap>
        <B><%=staffCodeListTitles[i]%></B>
    </TD>
    <%
    }
    %>
    <TD nowrap  CLASS="silver_header" BGCOLOR="#FFBF00" WIDTH="135" STYLE="border-WIDTH:0; font-size:12" COLSPAN="1" nowrap>
        &nbsp;
        </TD>
</TR> 


<%

Enumeration e = staffCodeList.elements();


while(e.hasMoreElements()) {
    iTotal++;
    wbo = (WebBusinessObject) e.nextElement();
    
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
        attName = staffCodeAttributes[i];
        attValue = (String) wbo.getAttribute(attName);
%>

<TD STYLE="<%=style%>" BGCOLOR="#DDDD00" nowrap  CLASS="<%=bgColorm%>" >
    <DIV >
        
        <b> <%=attValue%> </b>
    </DIV>
</TD>
<%
}
%>

<TD nowrap CLASS="<%=bgColor%>" BGCOLOR="#D7FF82" STYLE="padding-right:10;<%=style%>">
    <DIV ID="links">
        <A HREF="<%=context%>/StaffCodeServlet?op=ViewStaffCode&staffCodeId=<%=wbo.getAttribute("id")%>">
            <%=staffCodeListTitles[1]%>
        </A>
    </DIV>
</TD>

<TD nowrap CLASS="<%=bgColor%>" BGCOLOR="#D7FF82" STYLE="padding-right:10;<%=style%>">
    <DIV ID="links">
        <A HREF="<%=context%>/StaffCodeServlet?op=GetUpdateStaffCode&staffCodeId=<%=wbo.getAttribute("id")%>">
            <%=staffCodeListTitles[2]%>
        </A>
    </DIV>
</TD>

<%
if(staffCodeMgr.getActiveStaffCode(wbo.getAttribute("id").toString())) {
%>
<TD nowrap CLASS="<%=bgColor%>"BGCOLOR="#D7FF82" STYLE="padding-right:10;<%=style%>">
<DIV ID="links">
    <%=CD%>
    </A>
</DIV>
</td>

<%
} else {
%> 

<TD nowrap CLASS="<%=bgColor%>" BGCOLOR="#D7FF82" STYLE="padding-right:10;<%=style%>">
    <DIV ID="links">
        <A HREF="<%=context%>/StaffCodeServlet?op=ConfirmDeleteStaffCode&staffCodeId=<%=wbo.getAttribute("id")%>&staffTitle=<%=wbo.getAttribute("code")%>">
            <%=staffCodeListTitles[3]%>
        </A>
    </DIV>
</TD>
<% } %>

<TD WIDTH="20px" BGCOLOR="#FFE391" nowrap CLASS="<%=bgColor%>">
    <%
    if(staffCodeMgr.getActiveStaffCode(wbo.getAttribute("id").toString())) {
    %>
    <IMG SRC="images/active.jpg"  ALT="Active Satff Code by Employee"> 
    
    
    <%
    } else {
    %> 
    
    <IMG SRC="images/nonactive.jpg"  ALT="Non Active Staff Code">
    <% } %>
</TD>        


</TR>


<%

}

%>
<TR>
    <TD CLASS="silver_footer" BGCOLOR="#808080" COLSPAN="3" STYLE="<%=style%>;padding-right:5;border-right-width:1;font-size:16;">
        <B><%=PN%></B>
    </TD>
    <TD CLASS="silver_footer" BGCOLOR="#808080" colspan="2" STYLE="<%=style%>;padding-left:5;font-size:16;">
        
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
