<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="java.util.*,com.maintenance.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.contractor.db_access.*,com.maintenance.db_access.*,java.text.SimpleDateFormat"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<%
TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
MetaDataMgr metaMgr = MetaDataMgr.getInstance();
MaintainableMgr maintainableMgr=MaintainableMgr.getInstance();
String context = metaMgr.getContext();

//Get request data
WebBusinessObject equipmentWbo=(WebBusinessObject)request.getAttribute("equipmentWbo");
WebBusinessObject tableWbo=new WebBusinessObject();
Vector tables=(Vector)request.getAttribute("tables");
String bgcolor="white";
// get report pictures
Hashtable logos=new Hashtable();
logos=(Hashtable)session.getAttribute("logos");

Hashtable tableItems=(Hashtable)request.getAttribute("tableItems");
Hashtable tableParts=(Hashtable)request.getAttribute("tableParts");
Hashtable hashTable=(Hashtable)request.getAttribute("allEqsTables");
Vector allEqps=(Vector)request.getAttribute("allEqps");
Vector allTable=new Vector();
Vector items=new Vector();
Vector allparts=new Vector();
WebBusinessObject eqWbo=new WebBusinessObject();
WebBusinessObject scheduleItemWbo=new WebBusinessObject();
WebBusinessObject schedulePartWbo=new WebBusinessObject();
WebBusinessObject itemWbo=new WebBusinessObject();
WebBusinessObject partWbo=new WebBusinessObject();

String cMode = (String) request.getSession().getAttribute("currentMode");
String stat = cMode;
String align = "center";
String dir = null;
String style = null;
String headerItem = null;
String bgColor="#c8d8f8";
String lang,langCode, cancel;
String freqType=null;
String totalMT,eqName,tableTitle,frequency,duration,title,maintTables,Ktype,Htype,NoTables,desc,min,maintItems,parts;

if(stat.equals("En")){
    align="left";
    dir = "LTR";
    style = "text-align:right";
    lang = "&#1593;&#1585;&#1576;&#1610;";
    langCode = "Ar";
    cancel = "Cancel";
    title="Equipment Maintenance Table Reprot";
    maintTables="Maintenance Tables";
    eqName="Equipment Name";
    totalMT="Total Equipment Maintenance Tables : ";
    duration="Duration";
    frequency="Frequency";
    tableTitle="Maintenance Table Title ";
    Ktype="K.M";
    Htype="Hr";
    NoTables="No Tables Related To this Equipment";
    desc="Description";
    min="Minutes";
    parts="Spare Parts";
    maintItems="Maintenance Items";
    
}else{
    dir = "RTL";
    align="right";
    style = "text-align:Right";
    lang = "English";
    langCode = "En";
    cancel = "&#1573;&#1606;&#1607;&#1575;&#1569;";
    title="&#1578;&#1602;&#1585;&#1610;&#1585; &#1580;&#1583;&#1575;&#1608;&#1604; &#1589;&#1610;&#1575;&#1606;&#1607; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;";
    maintTables="&#1580;&#1583;&#1575;&#1608;&#1604; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1607;";
    eqName="&#1575;&#1587;&#1605; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;";
    totalMT="&#1575;&#1580;&#1605;&#1575;&#1604;&#1609; &#1580;&#1583;&#1575;&#1608;&#1604; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1607; &#1604;&#1604;&#1605;&#1593;&#1583;&#1607; : ";
    duration="&#1605;&#1583;&#1607; &#1575;&#1604;&#1578;&#1606;&#1601;&#1610;&#1584;";
    frequency="&#1610;&#1578;&#1603;&#1585;&#1585; &#1603;&#1604;";
    tableTitle="&#1593;&#1606;&#1608;&#1575;&#1606; &#1580;&#1583;&#1608;&#1604; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1607;";
    Ktype="&#1603;&#1605;";
    Htype="&#1587;&#1575;&#1593;&#1607;";
    NoTables="&#1604;&#1575; &#1578;&#1608;&#1580;&#1583; &#1580;&#1583;&#1575;&#1608;&#1604; &#1589;&#1610;&#1575;&#1606;&#1607; &#1605;&#1585;&#1578;&#1576;&#1591;&#1607; &#1576;&#1607;&#1584;&#1607; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;";
    desc="&#1575;&#1604;&#1608;&#1589;&#1601;";
    min="&#1583;&#1602;&#1610;&#1602;&#1607;";
    maintItems="&#1576;&#1606;&#1608;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1607;";
    parts="&#1602;&#1591;&#1593; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585;";
}
%>

<SCRIPT LANGUAGE="JavaScript" SRC="js/ChangeLang.js" TYPE="text/javascript">  </SCRIPT>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
    function cancelForm()
        {    
        document.EQP_REPORT_FORM.action ="<%=context%>/ReportsServlet?op=mainPage";
        document.EQP_REPORT_FORM.submit();  
        }
</script>

<HTML>
    <head>
        <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
        <META HTTP-EQUIV="Expires" CONTENT="0">   
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/CSS.css">
    </head>
    
    <body>
        <FORM NAME="EQP_REPORT_FORM" METHOD="POST">
            <table border="0" width="100%" dir="LTR">
                <button  onclick="JavaScript: cancelForm();" width="50"><%=cancel%> <IMG VALIGN="BOTTOM"  HEIGHT="15" SRC="images/cancel.gif"></button>
                <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
            </table> 
            
               <table border="0" width="100%" id="table1">
                <tr>
                    <td width="48%" align="center">
                        <img border="0" src="images/<%=logos.get("comLogo1").toString()%>" width="300" height="120">
                    </td>
                    <td width="50%" align="center">
                        <img border="0" src="images/<%=logos.get("comTitle").toString()%>" width="386" height="57">
                    </td>
                </tr>
            </table>
            
            <center>
                <table dir="<%=dir%>" align="center">
                    <tr>
                        <td class="td" bgcolor="#FFFFFF" style="text-align:center;border:0">
                            <b><font size="5" color="blue"><%=title%></font>
                        </td>
                    </tr>
                </table>
                <br>
                <%if(hashTable.size()>0){
                for(int i=0;i<allEqps.size();i++){
                eqWbo=new WebBusinessObject();
                eqWbo=(WebBusinessObject)allEqps.get(i);
                allTable=(Vector)hashTable.get(eqWbo.getAttribute("id").toString());%>
                <table width="90%">
                    <tr>
                        <td colspan="6" style="border:2px;border-right-width:2px;border-color:black;border-style: solid;" bgcolor="#CCCCFF">
                            <b><font size="4" color="blue"><%=(String)eqWbo.getAttribute("unitName")%></font></b>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="6" style="border:1px;border-right-width:1px;border-color:black;border-style: solid;" bgcolor="#CCCCFF">
                            <b><font size="3" color="blue"><%=maintTables%></font></b>
                        </td> 
                    </tr>
                    <tr>
                        <td colspan="6" style="border:0px;border-right-width:0px;border-color:black;border-style: solid;" bgcolor="#CCCCFF">
                            <b><font size="2" color="blue"><%=totalMT%><%=allTable.size()%></font></b>
                        </td> 
                    </tr>
                    <tr bgcolor="DCDCD0">
                        <td class="td" style="border-style: ridge;border-width: 1px;border-color: black;text-align:center;font:BOLD 14px arial;font-color:black;">
                            <b><font size="3" color="black"><%=maintItems%></font></b>
                        </td>
                        <td class="td" style="border-style: ridge;border-width: 1px;border-color: black;text-align:center;font:BOLD 14px arial;font-color:black;">
                            <b><font size="3" color="black"><%=parts%></font></b>
                        </td>
                        <td class="td" style="border-style: ridge;border-width: 1px;border-color: black;text-align:center;font:BOLD 14px arial;font-color:black;">
                            <b><font size="3" color="black"><%=desc%></font></b>
                        </td> 
                        <td class="td" style="border-style: ridge;border-width: 1px;border-color: black;text-align:center;font:BOLD 14px arial;font-color:black;">
                            <b><font size="3" color="black"><%=duration%></font></b>
                        </td> 
                        <td class="td" style="border-style: ridge;border-width: 1px;border-color: black;text-align:center;font:BOLD 14px arial;font-color:black;">
                            <b><font size="3" color="black"><%=frequency%></font></b>
                        </td> 
                        
                        <td class="td" style="border-style: ridge;border-width: 1px;border-color: black;text-align:center;font:BOLD 14px arial;font-color:black;">
                            <b><font size="3" color="black"><%=tableTitle%></font></b>
                        </td> 
                    </tr>
                    <%
                    if(allTable.size()>0){
                    for(int x=0;x<allTable.size();x++){
                        items=new Vector();
                        allparts=new Vector();
                        tableWbo=(WebBusinessObject)allTable.get(x);
                        if(tableWbo.getAttribute("scheduleType").toString().equalsIgnoreCase("1"))
                            freqType=Htype;
                        else if(tableWbo.getAttribute("scheduleType").toString().equalsIgnoreCase("2"))
                            freqType=Ktype;
                        else
                            freqType="";
                    %>
                    <tr>
                        <td class="td" style="padding-<%=align%>:20;border-style: ridge;border-width: 1px;border-color: black;text-align:<%=align%>;font:BOLD 12px arial;font-color:black;">
                            <table width="100%">
                                <%
                                items=(Vector)tableItems.get(tableWbo.getAttribute("periodicID").toString());
                                for(int c=0;c<items.size();c++){
                                    itemWbo=new WebBusinessObject();
                                    itemWbo=(WebBusinessObject)items.get(c);
                                %>
                                <tr>
                                    <td class="td" style="padding-<%=align%>:20;border-style: ridge;border-width: 1px;border-color: black;text-align:<%=align%>;font:BOLD 12px arial;font-color:black;">
                                        <%=(String)itemWbo.getAttribute("taskTitle")%>
                                    </td>
                                </tr>
                                <%}%>
                                
                            </table>
                        </td>
                        <td class="td" style="padding-<%=align%>:20;border-style: ridge;border-width: 1px;border-color: black;text-align:<%=align%>;font:BOLD 12px arial;font-color:black;">
                            <table width="100%">
                                
                                <%
                                allparts=(Vector)tableParts.get(tableWbo.getAttribute("periodicID").toString());
                                for(int c=0;c<allparts.size();c++){
                                    partWbo=new WebBusinessObject();
                                    partWbo=(WebBusinessObject)allparts.get(c);
                                %>
                                <tr>
                                    <td class="td" style="padding-<%=align%>:20;border-style: ridge;border-width: 1px;border-color: black;text-align:<%=align%>;font:BOLD 12px arial;font-color:black;">
                                        <%=(String)partWbo.getAttribute("itemDscrptn")%>
                                    </td>
                                </tr>
                                <%}%>
                            </table>
                        </td>
                        <td class="td" style="padding-<%=align%>:20;border-style: ridge;border-width: 1px;border-color: black;text-align:<%=align%>;font:BOLD 12px arial;font-color:black;">
                            <%=(String)tableWbo.getAttribute("description")%>
                        </td>                          
                        <td class="td" style="padding-<%=align%>:20;border-style: ridge;border-width: 1px;border-color: black;text-align:<%=align%>;font:BOLD 12px arial;font-color:black;">
                            <%=(String)tableWbo.getAttribute("duration")%>&nbsp;<%=min%>
                        </td>                          
                        <td class="td" style="padding-<%=align%>:20;border-style: ridge;border-width: 1px;border-color: black;text-align:<%=align%>;font:BOLD 12px arial;font-color:black;">
                            <%=(String)tableWbo.getAttribute("frequency")%>&nbsp;<%=freqType%>
                        </td>    
                        <td class="td" style="padding-<%=align%>:20;border-style: ridge;border-width: 1px;border-color: black;text-align:<%=align%>;font:BOLD 12px arial;font-color:black;">
                            <%=(String)tableWbo.getAttribute("maintenanceTitle")%>
                        </td>  
                    </tr>
                    
                    <%}}else{%>
                    <tr>
                        <td colspan="6" style="border:0px;border-right-width:0px;border-color:black;border-style: solid;" >
                            <b><font size="3" color="Red"><%=NoTables%></font></b>
                        </td> 
                    </tr>
                    <%}%>
                    <tr>
                        <td class="td" colspan="6">
                            <hr width="100%" size="2">                            
                        </td>
                    </tr>
                </table>
                <%}%>
                
                <%}else{%>
                <table width="100%">
                    <tr>
                        <td colspan="6" style="border:2px;border-right-width:2px;border-color:black;border-style: solid;" bgcolor="#CCCCFF">
                            <b><font size="4" color="blue"><%=(String)equipmentWbo.getAttribute("unitName")%></font></b>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="6" style="border:1px;border-right-width:1px;border-color:black;border-style: solid;" bgcolor="#CCCCFF">
                            <b><font size="3" color="blue"><%=maintTables%></font></b>
                        </td> 
                    </tr>
                    <tr>
                        <td colspan="6" style="border:0px;border-right-width:0px;border-color:black;border-style: solid;" bgcolor="#CCCCFF">
                            <b><font size="2" color="blue"><%=totalMT%><%=tables.size()%></font></b>
                        </td> 
                    </tr>
                    <tr bgcolor="DCDCD0">
                        <td class="td" style="border-style: ridge;border-width: 1px;border-color: black;text-align:center;font:BOLD 14px arial;font-color:black;">
                            <b><font size="3" color="black"><%=maintItems%></font></b>
                        </td>
                        <td class="td" style="border-style: ridge;border-width: 1px;border-color: black;text-align:center;font:BOLD 14px arial;font-color:black;">
                            <b><font size="3" color="black"><%=parts%></font></b>
                        </td>
                        <td class="td" style="border-style: ridge;border-width: 1px;border-color: black;text-align:center;font:BOLD 14px arial;font-color:black;">
                            <b><font size="3" color="black"><%=desc%></font></b>
                        </td> 
                        <td class="td" style="border-style: ridge;border-width: 1px;border-color: black;text-align:center;font:BOLD 14px arial;font-color:black;">
                            <b><font size="3" color="black"><%=duration%></font></b>
                        </td> 
                        <td class="td" style="border-style: ridge;border-width: 1px;border-color: black;text-align:center;font:BOLD 14px arial;font-color:black;">
                            <b><font size="3" color="black"><%=frequency%></font></b>
                        </td> 
                        
                        <td class="td" style="border-style: ridge;border-width: 1px;border-color: black;text-align:center;font:BOLD 14px arial;font-color:black;">
                            <b><font size="3" color="black"><%=tableTitle%></font></b>
                        </td> 
                    </tr>
                    
                    <%
                    if(tables.size()>0){
                        for(int i=0;i<tables.size();i++){
                            items=new Vector();
                            allparts=new Vector();
                            tableWbo=(WebBusinessObject)tables.get(i);
                            if(tableWbo.getAttribute("scheduleType").toString().equalsIgnoreCase("1"))
                                freqType=Htype;
                            else if(tableWbo.getAttribute("scheduleType").toString().equalsIgnoreCase("2"))
                                freqType=Ktype;
                            else
                                freqType="";
                    %>
                    <tr>
                        <td class="td" style="padding-<%=align%>:20;border-style: ridge;border-width: 1px;border-color: black;text-align:<%=align%>;font:BOLD 12px arial;font-color:black;">
                            <table width="100%">
                                <%
                                items=(Vector)tableItems.get(tableWbo.getAttribute("periodicID").toString());
                                for(int c=0;c<items.size();c++){
                                    itemWbo=new WebBusinessObject();
                                    itemWbo=(WebBusinessObject)items.get(c);
                                %>
                                
                                <tr>
                                    <td class="td" style="padding-<%=align%>:20;border-style: ridge;border-width: 1px;border-color: black;text-align:<%=align%>;font:BOLD 12px arial;font-color:black;">
                                        <%=(String)itemWbo.getAttribute("taskTitle")%>
                                    </td>
                                </tr>
                                
                                <%}%>
                            </table>
                        </td>
                        
                        <td class="td" style="padding-<%=align%>:20;border-style: ridge;border-width: 1px;border-color: black;text-align:<%=align%>;font:BOLD 12px arial;font-color:black;">
                            <table width="100%">
                                
                                <%
                                allparts=(Vector)tableParts.get(tableWbo.getAttribute("periodicID").toString());
                                for(int c=0;c<allparts.size();c++){
                                    partWbo=new WebBusinessObject();
                                    partWbo=(WebBusinessObject)allparts.get(c);
                                %>
                                <tr>
                                    <td class="td" style="padding-<%=align%>:20;border-style: ridge;border-width: 1px;border-color: black;text-align:<%=align%>;font:BOLD 12px arial;font-color:black;">
                                        <%=(String)partWbo.getAttribute("itemDscrptn")%>
                                    </td>
                                </tr>
                                <%}%>
                                
                            </table>
                        </td>
                        <td class="td" style="padding-<%=align%>:20;border-style: ridge;border-width: 1px;border-color: black;text-align:<%=align%>;font:BOLD 12px arial;font-color:black;">
                            <%=(String)tableWbo.getAttribute("description")%>
                        </td> 
                        <td class="td" style="padding-<%=align%>:20;border-style: ridge;border-width: 1px;border-color: black;text-align:<%=align%>;font:BOLD 12px arial;font-color:black;">
                            <%=(String)tableWbo.getAttribute("duration")%>&nbsp;<%=min%>
                        </td>                          
                        <td class="td" style="padding-<%=align%>:20;border-style: ridge;border-width: 1px;border-color: black;text-align:<%=align%>;font:BOLD 12px arial;font-color:black;">
                            <%=(String)tableWbo.getAttribute("frequency")%>&nbsp;<%=freqType%>
                        </td>    
                        <td class="td" style="padding-<%=align%>:20;border-style: ridge;border-width: 1px;border-color: black;text-align:<%=align%>;font:BOLD 12px arial;font-color:black;">
                            <%=(String)tableWbo.getAttribute("maintenanceTitle")%>
                        </td>  
                    </tr>
                    
                    <%}}else{%>
                    <tr>
                        <td colspan="6" style="border:0px;border-right-width:0px;border-color:black;border-style: solid;">
                            <b><font size="3" color="Red"><%=NoTables%></font></b>
                        </td> 
                    </tr>
                    <%}%>
                </table>
                <%}%>
            </center>
        </FORM>
    </body>
</html>