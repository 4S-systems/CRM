<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="java.util.*,com.maintenance.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,java.text.SimpleDateFormat"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="java.text.SimpleDateFormat"%>

<%
TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
MetaDataMgr metaMgr = MetaDataMgr.getInstance();
String context = metaMgr.getContext();

//Get request data

Vector outOfWorkingEqps=(Vector)request.getAttribute("outOfWorkingEqpsNoJO");

String[] headers = {"Equipment Name", "Out Of Working Date", "Notes"};
String[] attributes = {"unitName", "beginStatusDate", "statusNote"};

request.getSession().setAttribute("data",outOfWorkingEqps);
request.getSession().setAttribute("headers",headers);
request.getSession().setAttribute("attributes",attributes);

Hashtable logos=new Hashtable();
logos=(Hashtable)session.getAttribute("logos");

String bgcolor="white";
String cMode = (String) request.getSession().getAttribute("currentMode");
String stat = "Ar";
String align = "center";
String dir = null;
String style = null;
String beginDate = null;
String endDate = null;
String headerItem = null;
String bgColor="#c8d8f8";
String status=null;
String lang,langCode, cancel, title;
String eqName,bDate,eDate,notes,working,outWorking,excel,total;
if(stat.equals("En")){
    align="left";
    dir = "LTR";
    style = "text-align:right";
    lang = "&#1593;&#1585;&#1576;&#1610;";
    langCode = "Ar";
    cancel = "Cancel";
    title="Out Of Working Equipments With Out Job Orders Reprot ";
    eqName="Equipment Name";
    bDate="Out Of Working Date";
    eDate="End Date";
    status="Status";
    notes="Notes";
    working="Working";
    outWorking="Out fo Woking";
    excel="Excel";
    total="Number Of Equipments Out Of Working";
    
}else{
    dir = "RTL";
    align="right";
    style = "text-align:Right";
    lang = "English";
    langCode = "En";
    cancel = "&#1573;&#1606;&#1607;&#1575;&#1569;";
    title="&#1578;&#1602;&#1585;&#1610;&#1585; &#1575;&#1604;&#1605;&#1593;&#1583;&#1575;&#1578; &#1575;&#1604;&#1605;&#1593;&#1591;&#1604;&#1607; &#1576;&#1583;&#1608;&#1606; &#1575;&#1605;&#1585; &#1588;&#1594;&#1604;";
    eqName="&#1575;&#1587;&#1600;&#1605; &#1575;&#1604;&#1600;&#1605;&#1593;&#1600;&#1583;&#1607;";
    bDate="&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1582;&#1585;&#1608;&#1580; &#1605;&#1606; &#1575;&#1604;&#1582;&#1583;&#1605;&#1607;";
    eDate="&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1606;&#1607;&#1575;&#1610;&#1607;";
    status="&#1575;&#1604;&#1581;&#1575;&#1604;&#1607;";
    notes="&#1605;&#1604;&#1575;&#1581;&#1592;&#1575;&#1578;";
    working="&#1578;&#1593;&#1605;&#1604;";
    outWorking="&#1604;&#1575; &#1578;&#1593;&#1605;&#1604;";
    excel="&#1575;&#1603;&#1587;&#1604;";
    total="&#1593;&#1583;&#1583; &#1575;&#1604;&#1605;&#1593;&#1583;&#1575;&#1578; &#1582;&#1575;&#1585;&#1580; &#1575;&#1604;&#1582;&#1583;&#1605;&#1607;";
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
        document.EQP_REPORT_FORM.action ="<%=context%>/main.jsp";
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
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/CSS.css">
    </head>
    
    <body>
        <FORM NAME="EQP_REPORT_FORM" METHOD="POST">
            <table border="0" width="100%" dir="LTR">
                <button  onclick="JavaScript: cancelForm();" width="50"><%=cancel%> <IMG VALIGN="BOTTOM"  HEIGHT="15" SRC="images/cancel.gif"></button>
                <button style="display: <%=userPrevList.contains("EXCEL") ? "" : "none"%>;"   dir="<%=dir%> " onclick="changePage('<%=context%>/EquipmentServlet?op=extractToExcelCategories')" class="button"><%=excel%> <img src="<%=context%>/images/xlsicon.gif"></button>                                                
            </table> 
            
            <table border="0" width="100%" id="table1" dir="LTR">
                <tr>
                    <td class="td" width="48%" colspan="2">
                        <img border="0" src="images/<%=logos.get("comLogo1").toString()%>" width="300" height="120" align="left">
                    </td>
                    <td class="td" width="50%" colspan="2">
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
                
                <table width="90%" bgcolor="#E6E6FA">
                    <tr>                        
                        <td width="30%" align="center">
                            <b><font color="black" size="3"> <%=outOfWorkingEqps.size()%> </font></b>
                        </td>
                        <td width="30%" align="center">
                            <b><font color="black" size="3"><%=total%> </font></b>
                        </td>
                    </tr>
                </table>
                
                <table dir="<%=dir%>"  align="center" width="90%">
                    <tr>
                        <td class="td" bgcolor="#DCDCDC" style="border:1px;border-style:solid;border-color:black;text-align:center;font:BOLD 12px arial;">
                            <font color="black" size="3"><b>#</b></font>
                        </td>
                        <td class="td" bgcolor="#DCDCDC" style="border:1px;border-style:solid;border-color:black;text-align:center;font:BOLD 12px arial;">
                            <font color="black" size="3"><b><%=eqName%></b></font>
                        </td>
                        <td class="td" bgcolor="#DCDCDC" style="border:1px;border-style:solid;border-color:black;text-align:center;font:BOLD 12px arial;">
                            <font color="black" size="3"><b><%=bDate%></b></font>
                        </td>
                        <td class="td" bgcolor="#DCDCDC" style="border:1px;border-style:solid;border-color:black;text-align:center;font:BOLD 12px arial;">
                            <font color="black" size="3"><b> <%=notes%></b></font>
                        </td>
                    </tr>
                    
                    <%
                    WebBusinessObject eqWbo=null;
                    for(int i=0;i<outOfWorkingEqps.size();i++){
                        eqWbo=new WebBusinessObject();
                        eqWbo=(WebBusinessObject)outOfWorkingEqps.get(i);
                        if(bgcolor.equalsIgnoreCase("#c8d8f8"))
                            bgcolor="white";
                        else
                            bgcolor="#c8d8f8";
                    %>
                    <tr bgcolor="<%=bgcolor%>">
                        <td class="td" style="border-style: ridge;border-left-width: 1px;border-bottom-width: 1px;border-right-width: 1px;border-top-width: 1px;border-color: black;<%=style%>;font:BOLD 12px arial;padding-<%=align%>:1cm;">
                            <b><font color="black" size="2">
                                    <%=i+1%> 
                            </font></b>
                        </td>
                        
                        <td class="td" style="border-style: ridge;border-left-width: 1px;border-bottom-width: 1px;border-right-width: 1px;border-top-width: 1px;border-color: black;<%=style%>;font:BOLD 12px arial;padding-<%=align%>:1cm;">
                            <b><font color="black" size="2">
                                    <%=eqWbo.getAttribute("unitName").toString()%> 
                            </font></b>
                        </td>
                        
                        <td class="td" style="border-style: ridge;border-left-width: 1px;border-bottom-width: 1px;border-right-width: 1px;border-top-width: 1px;border-color: black;text-align:<%=align%>;font:BOLD 12px arial;padding-<%=align%>:1cm;">
                            <b><font color="black" size="2">
                                    <% 
                                    if(eqWbo.getAttribute("beginStatusDate")!=null){%>
                                    <%=eqWbo.getAttribute("beginStatusDate").toString()%>
                                    <%}else{%>
                                    &#1604;&#1575; &#1578;&#1608;&#1580;&#1583; &#1576;&#1610;&#1575;&#1606;&#1575;&#1578; &#1605;&#1578;&#1575;&#1581;&#1607;
                                    <%}%>
                            </font></b>
                        </td>
                        
                        <td class="td" style="border-style: ridge;border-left-width: 1px;border-bottom-width: 1px;border-right-width: 1px;border-top-width: 1px;border-color: black;text-align:<%=align%>;font:BOLD 12px arial;padding-<%=align%>:1cm;">
                            <b><font color="black" size="2">
                                    <%if(eqWbo.getAttribute("statusNote").toString()!=null){%>
                                    <%=eqWbo.getAttribute("statusNote").toString()%>
                                    <%}else{%>
                                    &#1604;&#1575; &#1610;&#1608;&#1580;&#1583; &#1608;&#1589;&#1601;
                                    <%}%>
                            </font></b>
                        </td>
                    </tr>
                    <%}%>
                    
                </table>
                
            </center>
        </FORM>
    </body>
</html>