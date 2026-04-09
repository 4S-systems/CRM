<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="java.util.*,com.maintenance.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,java.text.SimpleDateFormat"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<%
TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
com.maintenance.common.AppConstants headers = new AppConstants();

MetaDataMgr metaMgr = MetaDataMgr.getInstance();
String context = metaMgr.getContext();

//get equipment headers
Hashtable equipmentHeaders = headers.getEquipmentHeaders();

//Get request data
WebBusinessObject pLineWbo = (WebBusinessObject) request.getAttribute("pLineWbo");
String items[]  = (String[]) request.getAttribute("items");
Vector equipments = (Vector) request.getAttribute("equipments");

request.getSession().setAttribute("data",equipments);
request.getSession().setAttribute("items",items);

WebBusinessObject eqWbo=null;
// get report pictures
Hashtable logos=new Hashtable();
logos=(Hashtable)session.getAttribute("logos");
String cMode = (String) request.getSession().getAttribute("currentMode");
String stat = "Ar";
String align = "center";
String dir = null;
String style = null;
String headerItem = null;
String bgColor="#c8d8f8";
String lang,langCode, cancel, title,totaleq,excel;
if(stat.equals("En")){
    dir = "LTR";
    style = "text-align:right";
    lang = "&#1593;&#1585;&#1576;&#1610;";
    langCode = "Ar";
    cancel = "Cancel";
    title = "Equipments list for Production Line";
    totaleq="Number of Equipment under This Main Type";
    excel="Excel";
}else{
    dir = "RTL";
    style = "text-align:Right";
    lang = "English";
    langCode = "En";
    cancel = "&#1573;&#1606;&#1607;&#1575;&#1569;";
    title = "&#1578;&#1602;&#1585;&#1610;&#1585; &#1575;&#1604;&#1605;&#1593;&#1583;&#1575;&#1578; &#1604;&#1582;&#1591; &#1575;&#1604;&#1575;&#1606;&#1578;&#1575;&#1580;";
    totaleq="&#1593;&#1583;&#1583; &#1575;&#1604;&#1605;&#1593;&#1583;&#1575;&#1578; &#1578;&#1581;&#1578; &#1582;&#1591; &#1575;&#1604;&#1575;&#1606;&#1578;&#1575;&#1580; ";
    excel="&#1575;&#1603;&#1587;&#1604;";
}

    WebBusinessObject userWbo = (WebBusinessObject) request.getSession().getAttribute("loggedUser");

    GroupPrevMgr groupPrevMgr = GroupPrevMgr.getInstance();
    Vector groupPrev = groupPrev = groupPrevMgr.getOnArbitraryKey(userWbo.getAttribute("groupID").toString(), "key1");

    ArrayList<String> userPrevList = new ArrayList<String>();
    WebBusinessObject wboPrev;
    for (int i = 0; i < groupPrev.size(); i++) {
        wboPrev = (WebBusinessObject) groupPrev.get(i);
        userPrevList.add((String) wboPrev.getAttribute("prevCode"));
    }
%>

<script src='ChangeLang.js' type='text/javascript'></script>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
    function cancelForm()
        {    
        document.EQP_REPORT_FORM.action ="<%=context%>/EquipmentServlet?op=GetProductionLineReportForm";
        document.EQP_REPORT_FORM.submit();  
        }
    function changePage(url){
            window.navigate(url);
    }         
</script>

<HTML>
    <head>
        <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
        <META HTTP-EQUIV="Expires" CONTENT="0">        
    </head>
    
    <body>
        <FORM NAME="EQP_REPORT_FORM" METHOD="POST">
            <table border="0" width="100%" dir="LTR">
                <button  onclick="JavaScript: cancelForm();" width="50"><%=cancel%> <IMG VALIGN="BOTTOM"  HEIGHT="15" SRC="images/cancel.gif"></button>
                <button style="display: <%=userPrevList.contains("EXCEL") ? "" : "none"%>;"   dir="<%=dir%> " onclick="changePage('<%=context%>/EquipmentServlet?op=extractToExcel')" class="button"><%=excel%> <img src="<%=context%>/images/xlsicon.gif"></button>
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
                <table dir="<%=dir%>" align="<%=align%>">
                    <tr>
                        <td bgcolor="#FFFFFF">
                            <b><font size="5" color="blue"><%=title%>:&nbsp;</font><font color="red" size="5"><%=pLineWbo.getAttribute("code")%></font></b>
                        </td>
                    </tr>
                </table>
                <br>
                <table width="90%" bgcolor="#E6E6FA">
                    <tr>                        
                        <td width="30%" align="center">
                            <b><font color="black" size="3"> <%=equipments.size()%> </font></b>
                        </td>
                        <td width="30%" align="center">
                            <b><font color="black" size="3"> <%=totaleq%><%=(String)pLineWbo.getAttribute("code")%>&nbsp;=&nbsp;</font></b>
                        </td>
                    </tr>
                </table>
                <br>
                <table dir="<%=dir%>" align="<%=align%>" width="90%">
                    <tr >
                        <td align="center" bgcolor="gray" width="10">
                            <b><Font size="3">#</FONT></B>
                        </td>
                        <td align="center" bgcolor="gray">
                            <%
                            if(stat.equalsIgnoreCase("Ar")){
    headerItem = (String)equipmentHeaders.get("ArUNIT_NAME");
                            } else {
    headerItem = (String)equipmentHeaders.get("EnUNIT_NAME");
                            }
                            %>
                            <b><Font size="3"><%=headerItem%></FONT></B>
                        </td>
                        
                        <%
                        if(items != null){
    for(int i=0; i<items.length; i++){
                        %>
                        <td align="center" bgcolor="gray">
                            <%
                            if(stat.equalsIgnoreCase("Ar")){
                                headerItem = (String)equipmentHeaders.get("Ar"+(String)items[i]);
                            } else {
                                headerItem = (String)equipmentHeaders.get("En"+(String)items[i]);
                            }
                            %>
                            <b><Font size="3"><%=headerItem%></FONT></B>
                        </td>
                        <%
                        }
                        }
                        %>
                    </tr>
                    <%
                    if(equipments.size()>0){
    for(int x=0;x<equipments.size();x++){
        eqWbo=new WebBusinessObject();
        eqWbo=(WebBusinessObject)equipments.get(x);
        if(bgColor.equalsIgnoreCase("#c8d8f8"))
            bgColor="white";
        else
            bgColor="#c8d8f8";
                    %>
                    <tr bgcolor="<%=bgColor%>">
                        
                        <td class="td" width="20" style="border-style: ridge;border-width: 1px;border-color: black;padding-<%=align%>:1.5cm;text-align:<%=align%>;" >
                            <%=x+1%>
                        </td>
                        
                        <td class="td" style="border-style: ridge;border-width: 1px;border-color: black;padding-<%=align%>:0.5cm;text-align:<%=align%>;font:BOLD 12px arial;">
                            <%=eqWbo.getAttribute("unitName")%>
                        </td>
                        <%
                        if(items != null){
            for(int i=0; i<items.length; i++){
                headerItem = (String)equipmentHeaders.get("Att"+(String)items[i]);
                        %>
                        <td class="td" style="border-style: ridge;border-width: 1px;border-color: black;padding-<%=align%>:0.5cm;text-align:<%=align%>;font:BOLD 12px arial;">
                            <%if(items[i].toString().equalsIgnoreCase("STATUS")){
                            if (eqWbo.getAttribute(headerItem).toString().equalsIgnoreCase("Excellent")) {%>
                            &#1605;&#1605;&#1578;&#1575;&#1586;&#1607;
                            <% } else if (eqWbo.getAttribute(headerItem).toString().equalsIgnoreCase("Good")) {%>
                            &#1580;&#1610;&#1583;&#1607;
                            <%} else {%>
                            &#1585;&#1583;&#1610;&#1574;&#1607;
                            <%}
                            
                            }else if(items[i].toString().equalsIgnoreCase("TYPE_OF_RATE")){ 
                            if (eqWbo.getAttribute(headerItem).toString().equalsIgnoreCase("By K.M")){%>
                            &#1576;&#1575;&#1604;&#1603;&#1610;&#1604;&#1608; &#1605;&#1578;&#1585;
                            <%}else{%>
                            &#1576;&#1575;&#1604;&#1587;&#1575;&#1593;&#1607;
                            <%}%>                            
                            
                            <%}else if(items[i].toString().equalsIgnoreCase("TYPE_OF_OPERATION")){
                            if (eqWbo.getAttribute(headerItem).toString().equalsIgnoreCase("By Order")){%>
                            &#1576;&#1575;&#1604;&#1591;&#1604;&#1576;
                            <%}else{%>
                            &#1605;&#1587;&#1578;&#1605;&#1585;&#1607;
                            <%}%>  
                            
                            <%}else if(items[i].toString().equalsIgnoreCase("SERVICE_ENTRY_DATE")){
                            if (eqWbo.getAttribute(headerItem)!=null){%>
                            <%=eqWbo.getAttribute(headerItem)%>
                            <%}else{%>
                            &#1604;&#1575; &#1578;&#1608;&#1580;&#1583; &#1576;&#1610;&#1575;&#1606;&#1575;&#1578; &#1605;&#1578;&#1575;&#1581;&#1607;
                            <%}%>  
                            
                            <%}else if(items[i].toString().equalsIgnoreCase("NO_OF_HOURS")){
                            if (eqWbo.getAttribute(headerItem).toString().equals("0")){%>
                            &#1604;&#1575; &#1578;&#1608;&#1580;&#1583; &#1576;&#1610;&#1575;&#1606;&#1575;&#1578; &#1605;&#1578;&#1575;&#1581;&#1607;
                            <%}else{%>
                            <%=eqWbo.getAttribute(headerItem)%>                            
                            <%}%>
                            
                            <%}else{%>
                            <%if(eqWbo.getAttribute(headerItem).toString().equalsIgnoreCase("not found")){%>
                            &#1604;&#1575; &#1578;&#1608;&#1580;&#1583; &#1576;&#1610;&#1575;&#1606;&#1575;&#1578; &#1605;&#1578;&#1575;&#1581;&#1607;
                            <%}else{%>                            
                            <%=eqWbo.getAttribute(headerItem)%>
                            <%}}%>
                        </td>
                        <%
                        }
                        }
                        %>
                    </tr>
                    <%----End of p_eqps loop------%>
                    <%}}else{%>
                    <tr>
                        <td class="td" colspan="<%=items.length%>" style="BORDER-RIGHT-WIDTH:1PX;" align="center"  >
                            <font color="red" size="3">&#1604;&#1575; &#1578;&#1608;&#1580;&#1583; &#1605;&#1593;&#1583;&#1575;&#1578; &#1578;&#1581;&#1578; &#1582;&#1591; &#1575;&#1604;&#1575;&#1606;&#1578;&#1575;&#1580; &#1607;&#1584;&#1575;.</font>
                        </td>
                    </tr>
                    <%}%>
                    
                </table>
            </center>
        </FORM>
    </body>
</html>