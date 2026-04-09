<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<HTML>
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Expires" CONTENT="0">
<HEAD>
    <TITLE>System Departments List</TITLE>
    <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
</HEAD>
<%

MetaDataMgr metaMgr = MetaDataMgr.getInstance();
String context = metaMgr.getContext();
StaffCodeMgr staffCodeMgr = StaffCodeMgr.getInstance();
CrewMissionMgr crewMissionMgr = CrewMissionMgr.getInstance();

//String crewID = (String) request.getAttribute("crewID");


//AppConstants appCons = new AppConstants();

String[] crewAttributes = {"crewStaffName"};
String[] crewListTitles =new String[3];

int s = crewAttributes.length;
int t = s + 2;
int iTotal = 0;

String attName = null;
String attValue = null;
String cellBgColor = null;
String staffCode =null;



Vector  crewList = (Vector) request.getAttribute("data");


WebBusinessObject wbo = null;
int flipper = 0;
String bgColor = null;
String bgColorm = null;
TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
CrewEmployeeMgr crewEmployeeMgr = CrewEmployeeMgr.getInstance();
WebBusinessObject staffCodeWbo = new WebBusinessObject();

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
    tit="Delete Schedule - Are you Sure ?";
    save="Delete";
    cancel="Back To List";
    TT="There Is No Staff ";
    IG="Indicators guide ";
    AS="Active Crew Mission by Staff Code";
    NAS="Non Active Crew Mission";
    QS="Quick Summary";
    BO="Basic Operations";
    crewListTitles[0]="Staff Code";
    crewListTitles[1]="Update Staff";
    crewListTitles[2]="View Staff";
    
    CD="Can't Delete Crew";
    PN="Staff No.";
    PL="Staff List";
}else{
    
    align="center";
    dir="RTL";
    style="text-align:Right";
    lang="English";
    langCode="En";
    tit=" &#1581;&#1584;&#1601; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607; - &#1607;&#1604; &#1571;&#1606;&#1578; &#1605;&#1578;&#1571;&#1603;&#1583;&#1567;";
    save=" &#1573;&#1581;&#1584;&#1601;";
    cancel=" &#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1573;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577; ";
    TT="&#1604;&#1575;&#1610;&#1608;&#1580;&#1583; &#1601;&#1585;&#1602;";
    IG="&#1575;&#1604;&#1605;&#1585;&#1588;&#1583; &#1575;&#1604;&#1605;&#1589;&#1608;&#1585;";
    AS="&#1601;&#1585;&#1610;&#1602; &#1593;&#1605;&#1604; &#1610;&#1593;&#1605;&#1604;";
    NAS="&#1601;&#1585;&#1610;&#1602; &#1593;&#1605;&#1604; &#1604;&#1575; &#1610;&#1593;&#1605;&#1604;";
    QS="&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1587;&#1585;&#1610;&#1593;&#1577;";
    BO="&#1593;&#1605;&#1604;&#1610;&#1575;&#1578; &#1571;&#1587;&#1575;&#1587;&#1610;&#1577;";
    crewListTitles[0]="&#1603;&#1608;&#1583; &#1601;&#1585;&#1610;&#1602; &#1575;&#1604;&#1593;&#1605;&#1604;";
    crewListTitles[1]="&#1578;&#1593;&#1583;&#1610;&#1604; &#1575;&#1604;&#1601;&#1585;&#1610;&#1602;";
    crewListTitles[2]="&#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1575;&#1604;&#1601;&#1585;&#1610;&#1602;";
    CD=" &#1604;&#1575;&#1578;&#1587;&#1578;&#1591;&#1610;&#1593; &#1581;&#1584;&#1601; &#1575;&#1604;&#1601;&#1585;&#1610;&#1602;";
    PN="  &#1593;&#1583;&#1583; &#1575;&#1604;&#1601;&#1585;&#1602;";
    PL="  &#1593;&#1585;&#1590; &#1575;&#1604;&#1601;&#1585;&#1602;";
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

<br>
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

<center> <b> <font size="3" color="red"> <%=PN%> : <%=crewList.size()%> </font></b></center> 

<TABLE DIR="<%=dir%>" ALIGN="<%=align%>" WIDTH="400" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
    
    
    <br>
    <TABLE ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="400" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
    
    <TR>
        <TD class="blueBorder blueHeaderTD" COLSPAN="1" bgcolor="#808000" STYLE="text-align:center;color:white;font-size:18">
            <B><%=QS%></B>
        </TD>
        <TD class="blueBorder blueHeaderTD" COLSPAN="2" bgcolor="#669900" STYLE="text-align:center;color:white;font-size:18">
            <B><%=BO%></B>
        </TD>
        
    </tr>
    
    <TR >
        
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
            if(crewListTitles[i].equalsIgnoreCase("")){
                columnWidth = "1";
                columnColor = "black";
                font = "1";
            } else {
                columnWidth = "100";
                font = "12";
            }
        %>                
        <TD nowrap CLASS="silver_header" WIDTH="<%=columnWidth%>" bgcolor="<%=columnColor%>" STYLE="border-WIDTH:0; font-size:<%=font%>;" nowrap>
            <B><%=crewListTitles[i]%></B>
        </TD>
        <%
        }
        %>
        
    </TR> 
    
    <%
    
    Enumeration e = crewList.elements();
    
    
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
            attName = crewAttributes[i];
            attValue = (String) wbo.getAttribute(attName);
            //staffCodeWbo = (WebBusinessObject) staffCodeMgr.getOnSingleKey(attValue);
            //staffCode = staffCodeWbo.getAttribute("code").toString();
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
                <%
                boolean hasStaff = crewEmployeeMgr.hasStaff(wbo.getAttribute("id").toString());
                if(hasStaff){
                %>
                <A HREF="<%=context%>/CrewMissionServlet?op=GetUpdateStaffForm&staffCode=<%=wbo.getAttribute("id").toString()%>&crewCodeName=<%=wbo.getAttribute("crewStaffName").toString()%>">
                    <%=crewListTitles[1]%>
                </A>
                <%
                } else {
                %>
                
                <%=TT%> 
                
                <%
                }
                %>
            </DIV>
        </TD>               
        <TD nowrap CLASS="<%=bgColor%>" BGCOLOR="#D7FF82" STYLE="padding-right:10;<%=style%>">
            <DIV ID="links">
                <%
                if(hasStaff){
                %>
                <A HREF="<%=context%>/CrewMissionServlet?op=ViewStaff&staffCode=<%=wbo.getAttribute("id").toString()%>&crewCodeName=<%=wbo.getAttribute("crewStaffName").toString()%>">
                    <%=crewListTitles[2]%>
                </A>
                <%
                } else {
                %>
                <%=TT%>
                <%
                }
                %>
            </DIV>
        </TD>
    </TR>
    
    
    
    
    <%
    
    }
    
    %>
    
    <TD CLASS="silver_footer" BGCOLOR="#808080" COLSPAN="2" STYLE="<%=style%>;padding-right:5;border-right-width:1;font-size:16;">
        <B><%=PN%></B>
    </td>
    <td CLASS="silver_footer" BGCOLOR="#808080" STYLE="<%=style%>;padding-left:5;font-size:16;">
        <B><%=iTotal%></B>
    </td> 
    
    </DIV>
    </TD>
    </TR>
</table>

<br>
</fieldset>


</body>
</html>
