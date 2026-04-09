<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="java.util.*,com.maintenance.common.*, com.contractor.db_access.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,java.text.SimpleDateFormat"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<%
TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
com.maintenance.common.AppConstants headers = new AppConstants();

MetaDataMgr metaMgr = MetaDataMgr.getInstance();
MaintainableMgr maintainableMgr = MaintainableMgr.getInstance();
String context = metaMgr.getContext();

//get equipment headers
Hashtable itemHeaders = headers.getItemHeaders();

//Get request data
String items[]  = (String[]) request.getAttribute("items");
Vector itemsData = (Vector) request.getAttribute("data");

request.getSession().setAttribute("data",itemsData);
request.getSession().setAttribute("items",items);

// get report pictures
Hashtable logos=new Hashtable();
logos=(Hashtable)session.getAttribute("logos");

String cMode = (String) request.getSession().getAttribute("currentMode");
String stat = cMode;
String align = "center";
String dir = null;
String style = null;
String headerItem = null;
String bgcolor="#c8d8f8";
String lang,langCode, cancel, title,total, catName,excel;

if(stat.equals("En")){
    dir = "LTR";
    style = "text-align:right";
    lang = "&#1593;&#1585;&#1576;&#1610;";
    langCode = "Ar";
    cancel = "Cancel";
    title = "Equipments list for all categories";
    total="Number of All Equipments for this category is";
    catName = "Category Name";
    excel="Excel";
}else{
    dir = "RTL";
    style = "text-align:Right";
    lang = "English";
    langCode = "En";
    cancel = "&#1573;&#1606;&#1607;&#1575;&#1569;";
    title = "&#1578;&#1602;&#1585;&#1610;&#1585; &#1576;&#1606;&#1608;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577; &#1604;&#1580;&#1605;&#1610;&#1593; &#1575;&#1604;&#1571;&#1589;&#1606;&#1575;&#1601;";
    total="&#1593;&#1583;&#1583; &#1576;&#1606;&#1608;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1607; &#1575;&#1604;&#1603;&#1604;&#1609; &#1604;&#1607;&#1584;&#1575; &#1575;&#1604;&#1589;&#1606;&#1601;";
    catName = "&#1575;&#1587;&#1605; &#1575;&#1604;&#1589;&#1606;&#1601;";
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

<SCRIPT LANGUAGE="JavaScript" SRC="js/ChangeLang.js" TYPE="text/javascript">  </SCRIPT>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
    function cancelForm()
        {    
        document.EQP_REPORT_FORM.action ="<%=context%>/TaskServlet?op=getItemsReportForm";
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
                <input type="button" value="<%=lang%>"  onclick="reloadAE('<%=langCode%>')" class="button">
                <button style="display: <%=userPrevList.contains("EXCEL") ? "" : "none"%>;"   dir="<%=dir%> " onclick="changePage('<%=context%>/TaskServlet?op=extractToExcel')" class="button"><%=excel%> <img src="<%=context%>/images/xlsicon.gif"></button>
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
                            <b><font size="5" color="blue"><%=title%></font></b>
                        </td>
                    </tr>
                </table>
                <br>
                
                
                
                <table dir="<%=dir%>" align="<%=align%>" width="90%">
                    <tr>
                        <td align="center" bgcolor="gray" width="10" style="border-style: ridge;border-width: 1px;border-color: black;">
                            <b><Font size="3">#</FONT></B>
                        </td>
                        <td align="center" bgcolor="gray" style="border-style: ridge;border-width: 1px;border-color: black;">
                            <b><Font size="3"><%=catName%></FONT></B>
                        </td>
                        <td align="center" bgcolor="gray" style="border-style: ridge;border-width: 1px;border-color: black;">
                            <%
                            if(stat.equalsIgnoreCase("Ar")){
    headerItem = (String)itemHeaders.get("ArITEM_NAME");
                            } else {
    headerItem = (String)itemHeaders.get("EnITEM_NAME");
                            }
                            %>
                            <b><Font size="3"><%=headerItem%></FONT></B>
                        </td>
                        
                        <%
                        if(items != null){
    for(int i=0; i<items.length; i++){
                        %>
                        <td align="center" bgcolor="gray" style="border-style: ridge;border-width: 1px;border-color: black;">
                            <%
                            if(stat.equalsIgnoreCase("Ar")){
                                headerItem = (String)itemHeaders.get("Ar"+(String)items[i]);
                            } else {
                                headerItem = (String)itemHeaders.get("En"+(String)items[i]);
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
                    if(itemsData != null && itemsData.size()>0){
    
    
    for(int j=0; j<itemsData.size(); j++){
        WebBusinessObject itemWbo = (WebBusinessObject) itemsData.elementAt(j);
        if(bgcolor.equalsIgnoreCase("#c8d8f8"))
            bgcolor="white";
        else
            bgcolor="#c8d8f8";
                    %>
                    <tr bgcolor="<%=bgcolor%>">
                        <td class="firstname" align="center" width="10" style="border-style: ridge;border-width: 1px;border-color: black;">
                            <%=j+1%>
                        </td>
                        <td class="firstname" align="center" style="border-style: ridge;border-width: 1px;border-color: black;">
                            <%=(String)itemWbo.getAttribute("unitName")%>
                        </td>
                        <td align="center" style="border-style: ridge;border-width: 1px;border-color: black;">
                            <%=itemWbo.getAttribute("name")%>
                        </td>
                        
                        <%
                        if(items != null){
            for(int i=0; i<items.length; i++){
                headerItem = (String)itemHeaders.get("Att"+(String)items[i]);
                        %>
                        <td align="center" style="border-style: ridge;border-width: 1px;border-color: black;">
                            <%if(headerItem.equalsIgnoreCase("taskTitle")){
                            String taskTitle=itemWbo.getAttribute(headerItem).toString();
                            taskTitle=taskTitle.substring(0,taskTitle.indexOf("-"));
                            %>
                            <%=taskTitle%>
                            <%}else{if(itemWbo.getAttribute(headerItem)!=null){
                            %>
                            <%=itemWbo.getAttribute(headerItem)%>
                            <%}else{%>
                            Non  
                            <%}}%>
                        </td>
                        <%
                        }
                        }
                        %>
                    </tr>
                    <%
                    }
                    } else {
                    %>
                    <TR>
                        <TD COLSPAN="<%=items.length+2%>" ALIGN="<%=align%>" style="border-style: ridge;border-width: 1px;border-color: black;">
                            <b><font color="red">No Items related to this category</font></b>
                        </TD>           
                    </TR>
                    <%
                    }
                    %>
                </table>
                
                <table width="90%"  bgcolor="#E6E6FA">
                    <tr>
                        <td width="10%" align="center" style="border-style: ridge;border-width: 1px;border-color: black;">
                            <b><font color="black" size="3"> <%=itemsData.size()%> </font></b>
                        </td>
                        <td width="80%" align="center" colspan="<%=items.length+2%>" style="border-style: ridge;border-width: 1px;border-color: black;">
                            <b><font color="black" size="3"> <%=total%></font></b>
                        </td>
                    </tr>
                </table>
            </center>
        </FORM>
    </body>
</html>