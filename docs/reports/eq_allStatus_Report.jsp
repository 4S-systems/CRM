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

Vector allEqStatus=(Vector)request.getAttribute("allEqStatus");
WebBusinessObject eqWbo=(WebBusinessObject)request.getAttribute("eqWbo");

String[] headers = {"Equipment Name", "Status", "Begin Date" ,"End Date","Description"};
String[] attributes = {"unitName", "stat", "beginDate","endDate","note"};

// get report pictures
Hashtable logos=new Hashtable();
logos=(Hashtable)session.getAttribute("logos"); 
request.getSession().setAttribute("data",allEqStatus);
request.getSession().setAttribute("headers",headers);
request.getSession().setAttribute("attributes",attributes);

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
String eqName,bDate,eDate,notes,working,outWorking,excel;
if(stat.equals("En")){
    align="left";
    dir = "LTR";
    style = "text-align:right";
    lang = "&#1593;&#1585;&#1576;&#1610;";
    langCode = "Ar";
    cancel = "Cancel";
    title="Equipment Status Reprot";
    eqName="Equipment Name";
    bDate="Begin Date";
    eDate="End Date";
    status="Status";
    notes="Notes";
    working="Working";
    outWorking="Out fo Woking";
    excel="Excel";
    
}else{
    dir = "RTL";
    align="right";
    style = "text-align:Right";
    lang = "English";
    langCode = "En";
    cancel = "&#1573;&#1606;&#1607;&#1575;&#1569;";
    title="&#1578;&#1602;&#1585;&#1610;&#1585; &#1581;&#1575;&#1604;&#1575;&#1578; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;";
    eqName="&#1575;&#1587;&#1600;&#1605; &#1575;&#1604;&#1600;&#1605;&#1593;&#1600;&#1583;&#1607;";
    bDate="&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1576;&#1583;&#1575;&#1610;&#1607;";
    eDate="&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1606;&#1607;&#1575;&#1610;&#1607;";
    status="&#1575;&#1604;&#1581;&#1575;&#1604;&#1607;";
    notes="&#1605;&#1604;&#1575;&#1581;&#1592;&#1575;&#1578;";
    working="&#1578;&#1593;&#1605;&#1604;";
    outWorking="&#1604;&#1575; &#1578;&#1593;&#1605;&#1604;";
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
                <button  style="display: <%=userPrevList.contains("EXCEL") ? "" : "none"%>;"  dir="<%=dir%> " onclick="changePage('<%=context%>/EquipmentServlet?op=extractToExcelCategories')" class="button"><%=excel%> <img src="<%=context%>/images/xlsicon.gif"></button>                
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
                
                <table dir="<%=dir%>"  align="center" width="90%">
                    <tr>
                        <td class="td" bgcolor="#DCDCDC" style="border:1px;border-style:solid;border-color:black;text-align:center;font:BOLD 12px arial;">
                            <font color="black" size="3"><b><%=eqName%></b></font>
                        </td>
                        <td class="td" bgcolor="#DCDCDC" style="border:1px;border-style:solid;border-color:black;text-align:center;font:BOLD 12px arial;">
                            <font color="black" size="3"><b><%=status%></b></font>
                        </td>
                        <td class="td" bgcolor="#DCDCDC" style="border:1px;border-style:solid;border-color:black;text-align:center;font:BOLD 12px arial;">
                            <font color="black" size="3"><b><%=bDate%></b></font>
                        </td>
                        <td class="td" bgcolor="#DCDCDC" style="border:1px;border-style:solid;border-color:black;text-align:center;font:BOLD 12px arial;">
                            <font color="black" size="3"><b><%=eDate%></b></font>
                        </td>
                        <td class="td" bgcolor="#DCDCDC" style="border:1px;border-style:solid;border-color:black;text-align:center;font:BOLD 12px arial;">
                            <font color="black" size="3"><b> <%=notes%></b></font>
                        </td>
                    </tr>
                    
                    <%
                    WebBusinessObject eqStatusWbo=null;
                    for(int i=0;i<allEqStatus.size();i++){
                        eqStatusWbo=new WebBusinessObject();
                        eqStatusWbo=(WebBusinessObject)allEqStatus.get(i);
                        if(bgcolor.equalsIgnoreCase("#c8d8f8"))
                            bgcolor="white";
                        else
                            bgcolor="#c8d8f8";
                    %>
                    <tr bgcolor="<%=bgcolor%>">
                        <%if(i==0){%>
                        <td class="td" style="border-style: ridge;border-left-width: 1px;border-bottom-width: 0px;border-right-width: 1px;border-top-width: 1px;border-color: black;<%=style%>;font:BOLD 12px arial;padding-<%=align%>:1cm;">
                            <b><font color="black" size="2">
                                    
                                    <%=eqWbo.getAttribute("unitName").toString()%> 
                                    
                            </font></b>
                        </td>
                        <%}else{%>
                        <td class="td" style="border-style: ridge;border-left-width: 1px;border-bottom-width: 1px;border-right-width: 1px;border-top-width: 0px;border-color: black;<%=style%>;font:BOLD 12px arial;padding-<%=align%>:1cm;">
                            &nbsp;
                        </td>
                        <%}%>
                        <td class="td" style="border-style: ridge;border-left-width: 0px;border-bottom-width: 1px;border-right-width: 0px;border-top-width: 0px;border-color: black;text-align:<%=align%>;font:BOLD 12px arial;padding-<%=align%>:1cm;">
                            <b><font color="black" size="2">
                                    <%if(eqStatusWbo.getAttribute("stateID").toString().equals("1")){%>
                                    <%=working%>
                                    <%}else{%>
                                    <%=outWorking%>
                                    <%}%>
                            </font></b>
                        </td>
                        <td class="td" style="border-style: ridge;border-left-width: 0px;border-bottom-width: 1px;border-right-width: 0px;border-top-width: 0px;border-color: black;text-align:<%=align%>;font:BOLD 12px arial;padding-<%=align%>:1cm;">
                            <b><font color="black" size="2">
                                    <% 
                                    if(eqStatusWbo.getAttribute("beginDate")!=null){%>
                                    <%=eqStatusWbo.getAttribute("beginDate").toString()%>
                                    <%}else{%>
                                    &#1604;&#1575; &#1578;&#1608;&#1580;&#1583; &#1576;&#1610;&#1575;&#1606;&#1575;&#1578; &#1605;&#1578;&#1575;&#1581;&#1607;
                                    <%}%>
                            </font></b>
                        </td>
                        
                        <td class="td" style="border-style: ridge;border-left-width: 0px;border-bottom-width: 1px;border-right-width: 0px;border-top-width: 0px;border-color: black;text-align:<%=align%>;font:BOLD 12px arial;padding-<%=align%>:1cm;">
                            <b><font color="black" size="2">
                                    <%if(eqStatusWbo.getAttribute("endDate")!=null){%>
                                    <%=eqStatusWbo.getAttribute("endDate").toString()%>
                                    <%}else{%>
                                    &#1607;&#1584;&#1607; &#1581;&#1575;&#1604;&#1607; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607; &#1575;&#1604;&#1575;&#1606;
                                    <%}%>
                            </font></b>
                        </td>
                        
                        <td class="td" style="border-style: ridge;border-left-width: 1px;border-bottom-width: 1px;border-right-width: 0px;border-top-width: 0px;border-color: black;text-align:<%=align%>;font:BOLD 12px arial;padding-<%=align%>:1cm;">
                            <b><font color="black" size="2">
                                    <%if(eqStatusWbo.getAttribute("note").toString()!=null){%>
                                    <%=eqStatusWbo.getAttribute("note").toString()%>
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