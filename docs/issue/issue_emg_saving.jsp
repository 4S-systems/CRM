<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*,com.tracker.app_constants.*, com.tracker.common.*, java.util.*"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants,com.contractor.db_access.MaintainableMgr"%>
<%@ page import="com.silkworm.common.TimeServices,com.silkworm.jsptags.*,com.silkworm.international.TouristGuide,com.maintenance.db_access.*"%>
<%@page pageEncoding="UTF-8" %>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<%
MetaDataMgr metaMgr = MetaDataMgr.getInstance();

String context = metaMgr.getContext();
// update Equipment
String StatusUpdate = (String) request.getAttribute("StatusUpdate");
String updateEuip = (String) request.getAttribute("updateEuip");
if(updateEuip == null)
    updateEuip = "no";

//Get request data
String status = (String) request.getAttribute("Status");
String businessID = (String) request.getAttribute("businessID");
String sID = (String) request.getAttribute("sID");
String isID = (String) request.getAttribute("issueID");

//Define language setting
String cMode = (String) request.getSession().getAttribute("currentMode");
String stat = cMode;
String align = null;
String dir = null;
String lang, langCode, cancel, Titel, successStatus, successUpdate,failStatus, failUpdate,jobNo, data, title, viewDeatils;

if (stat.equals("En")) {
    align = "center";
    dir = "LTR";
    lang = "   &#1593;&#1585;&#1576;&#1610;    ";
    langCode = "Ar";
    
    cancel = "Back to main page";
    Titel = "New Regular Job Order ";
    successStatus = "Job Order Saved Successfully";
    failStatus = "Fail to Save Job Order. Please contact system administrator";
    jobNo = "Job Order Number : ";
    data = " View Job Order";
    title = "Add Labor Inspections";
    viewDeatils = "View Job Order / Add operation ";
    
    successUpdate="Update Counter Successfully";
    failUpdate = "Fail to Update Counter";
} else{
    align = "center";
    dir = "RTL";
    lang = "English";
    langCode = "En";
    
    cancel = "&#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1575;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577;";
    Titel = " &nbsp;&#1571;&#1605;&#1585; &#1588;&#1594;&#1604; &#1593;&#1575;&#1583;&#1609;";
    successStatus = "&#1578;&#1600;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1600;&#1578;&#1600;&#1587;&#1580;&#1600;&#1610;&#1600;&#1604; &#1576;&#1600;&#1606;&#1600;&#1580;&#1600;&#1575;&#1581;";
    failStatus = "&#1604;&#1605; &#1610;&#1578;&#1605; &#1578;&#1587;&#1580;&#1610;&#1604; &#1571;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604; - &#1605;&#1606; &#1601;&#1590;&#1604;&#1603; &#1575;&#1585;&#1601;&#1593; &#1575;&#1604;&#1605;&#1588;&#1603;&#1604;&#1577; &#1604;&#1605;&#1583;&#1610;&#1585; &#1575;&#1604;&#1606;&#1592;&#1575;&#1605;";
    jobNo = "&#1585;&#1602;&#1605; &#1573;&#1584;&#1606; &#1575;&#1604;&#1588;&#1594;&#1604; :";
    data = "&#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1571;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
    title = "اضافة شكوي عاملين";
    viewDeatils = "&#1593;&#1585;&#1590; &#1578;&#1601;&#1575;&#1589;&#1610;&#1604; &#1571;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604; / &#1575;&#1590;&#1575;&#1601;&#1577; &#1593;&#1605;&#1604;&#1610;&#1575;&#1578;";
    successUpdate="&#1578;&#1605; &#1578;&#1581;&#1583;&#1610;&#1579; &#1575;&#1604;&#1593;&#1583;&#1575;&#1583; &#1576;&#1606;&#1580;&#1575;&#1581;";
    failUpdate = "&#1604;&#1605; &#1610;&#1578;&#1605; &#1578;&#1581;&#1583;&#1610;&#1579; &#1575;&#1604;&#1593;&#1583;&#1575;&#1583;";
}
%>

<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
    function cancelForm(){    
        document.ISSUE_FORM.action = "<%=context%>/main.jsp";
        document.ISSUE_FORM.submit();  
    }
        
    function changePage(url){
        window.navigate(url);
    }
</SCRIPT>

<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <link rel="stylesheet" type="text/css" href="autosuggest.css" />
        <link rel="stylesheet" type="text/css" href="css/epoch_styles.css" />
    </HEAD>
    
    <body>
        <center>
        <FORM NAME="ISSUE_FORM" METHOD="POST">
            <DIV align="left" STYLE="color:blue;">
                <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
                <button onclick="JavaScript: cancelForm();" class="button" style="width:170"> <%=cancel%> <IMG VALIGN="BOTTOM" SRC="images/cancel.gif"></button>
                
            </DIV>
            <br>
            
            <fieldset class="set">
                <legend align="center">
                    <table ALIGN="<%=align%>" dir="<%=dir%>">
                        <tr>
                            <td class="td">
                                <font color="blue" size="6"><%=Titel%></font>
                            </td>
                        </tr>
                    </table>
                </legend>
                <br>
                
                <%    
                if (null != status) {
                %>
                <table border="0" ALIGN="<%=align%>" dir="<%=dir%>" width="400">
                    <%
                    if(status.equalsIgnoreCase("ok")){
                    %>
                    <tr>
                        <td colspan="2" bgcolor="#006699">
                            <b><font color="#FFFFFF" size="4"><%=successStatus%></font></b>
                        </td>
                    </tr>
                    <%
                    if(updateEuip.equalsIgnoreCase("ok")){
                        if(StatusUpdate.equalsIgnoreCase("ok")){
                    %>
                    <tr>
                        <td colspan="2" bgcolor="#006699">
                            <b><font color="#FFFFFF" size="4"><%=successUpdate%></font></b>
                        </td>
                    </tr>
                    <%}else{%>
                    <tr>
                        <td colspan="2" bgcolor="#006699">
                            <b><font color="red" size="4"><%=failUpdate%></font></b>
                        </td>
                    </tr>
                    <%} }%>
                    <tr>
                        <td width="200" bgcolor="#CCCCCC" ALIGN="<%=align%>">
                            <b><font size="2" color="black"><%=jobNo%></font></b>
                        </td>
                        <td width="200" ALIGN="<%=align%>" style="border-right-width:1px">
                            <b><font color="red" size="3"><%=businessID%>/</font><font color="blue" size="3" ><%=sID%></font></b>
                        </td>
                    </tr>
                    
                    <tr>
                        <td width="400" ALIGN="<%=align%>" colspan="2" style="border:0px">
                            &nbsp;
                        </td>
                    </tr>
                    
                    <tr>
                        <td colspan="2" bgcolor="#006699">
                            <b><font color="#FFFFFF" size="4"><%=viewDeatils%></font></b>
                        </td>
                    </tr>
                    
                    <tr>
                        <td width="200" bgcolor="lightsteelblue" ALIGN="<%=align%>" style="cursor:hand" onclick="JavaScript: changePage('<%=context%>/AssignedIssueServlet?op=VIEWDETAILS&issueId=<%=isID%>&filterValue=null&filterName=null&mainTitle=Emergency&backTo=all');">
                            <b><font size="3" color="blue"><%=data%></font></b>
                        </td>
                        <td width="200" bgcolor="lightsteelblue" ALIGN="<%=align%>" style="cursor:hand" onclick="JavaScript: changePage('<%=context%>/AssignedIssueServlet?op=AddLabourCompalint&issueId=<%=isID%>&filterValue=null&filterName=null');">
                            <b><font size="3" color="blue"><%=title%></font></b>
                        </td>
                    </tr>
                    <%} else {%>
                    <tr>
                        <td colspan="2" bgcolor="#006699">
                            <b><font color="red" size="4"><%=failStatus%></font></b>
                        </td>
                    </tr>
                    <%}%>
                </table>
                <%}%>
                
                <br>
            </fieldset>
        </Form>        
    </body>
</html>