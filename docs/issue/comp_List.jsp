<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.maintenance.db_access.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.tracker.db_access.*,com.tracker.db_access.IssueMgr"%>
<%@page pageEncoding="UTF-8" %>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  

<%
MetaDataMgr metaMgr = MetaDataMgr.getInstance();
UnitScheduleMgr unitScheduleMgr = UnitScheduleMgr.getInstance();
IssueMgr issueMgr = IssueMgr.getInstance();
TaskMgr taskMgr = TaskMgr.getInstance();

String context = metaMgr.getContext();

//get request data
String filterValue = (String) request.getAttribute("filterValue");
String filterName = (String) request.getAttribute("filterName");
String issueId = (String) request.getAttribute("issueId");
String issueNo = (String) request.getAttribute("jobNo");
Vector data = (Vector) request.getAttribute("comp");

//get job order data
WebBusinessObject issueWbo = (WebBusinessObject) issueMgr.getOnSingleKey(issueId);

String align = null;
String dir = null;
String style = null;
String cellAlign = null;
String lang, langCode, cancel, title, JOData, JONo, forEqp, complaint, isRelatedTo, task, labor, entryTime,
        noComplaints, relatedTo, notRelated,taskCode;

String stat= (String) request.getSession().getAttribute("currentMode");
if(stat.equals("En")){
    align = "center";
    dir = "LTR";
    style = "text-align:left";
    cellAlign = "left";
    lang = "&#1593;&#1585;&#1576;&#1610;";
    langCode = "Ar";
    
    cancel = "Back";
    title = "Complaints List";
    JOData = "Job Order Data";
    JONo = "Job Order Number";
    forEqp = "Equipment Name";
    complaint = "Complaint";
    isRelatedTo = "Is related to task";
    task = "Task";
    labor = "Labor Name";
    entryTime = "Complaint entry date";
    noComplaints = "No Complaint related to this job order";
    relatedTo = "Related to task";
    notRelated = "Not Related to task";
    taskCode="Task Code";
} else {
    align = "center";
    dir = "RTL";
    style = "text-align:Right";
    lang = "English";
    cellAlign = "right";
    langCode="En";
    
    cancel = "&#1593;&#1600;&#1600;&#1600;&#1600;&#1608;&#1583;&#1577;";
    title = "عرض الشكاوي";
    JOData = "&#1576;&#1610;&#1575;&#1606;&#1575;&#1578; &#1571;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
    JONo = "&#1585;&#1602;&#1605; &#1571;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
    forEqp = "&#1575;&#1587;&#1605; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577;";
    complaint = "الشكوي";
    isRelatedTo = "&#1605;&#1585;&#1578;&#1576;&#1591;&#1577; &#1576;&#1576;&#1606;&#1583; &#1589;&#1610;&#1575;&#1606;&#1577;";
    task = "&#1576;&#1606;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
    labor = "&#1575;&#1587;&#1605; &#1575;&#1604;&#1593;&#1575;&#1605;&#1604;";
    entryTime = "تاريخ دخول الشكوي";
    noComplaints = "لا يوجد شكوي مرتبطه بأمر الشغل";
    relatedTo = "&#1605;&#1585;&#1578;&#1576;&#1591;&#1577; &#1576;&#1576;&#1606;&#1583; &#1589;&#1610;&#1575;&#1606;&#1577;";
    notRelated = "&#1594;&#1610;&#1585;&#1605;&#1585;&#1578;&#1576;&#1591;&#1577; &#1576;&#1576;&#1606;&#1583; &#1589;&#1610;&#1575;&#1606;&#1577;";
    taskCode="&#1603;&#1608;&#1583; &#1575;&#1604;&#1576;&#1606;&#1583;";
}
%>

<script type="text/javascript">
    function cancelForm(){    
        document.ISSUE_FORM.action = "<%=context%>/AssignedIssueServlet?op=VIEWDETAILS&issueId=<%=issueId%>&filterName=<%=filterName%>&filterValue=<%=filterValue%>";
        document.ISSUE_FORM.submit();  
    }
</script>
<script src='ChangeLang.js' type='text/javascript'></script>

<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>
    
    <BODY>
        <FORM NAME="ISSUE_FORM" METHOD="POST">
            <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
            <button  onclick="cancelForm();" class="button"><%=cancel%><IMG VALIGN="BOTTOM" SRC="images/leftarrow.gif"> </button>
            <br>
            
            <fieldset class="set" align="center">
                <legend align="center">
                    <table dir="<%=dir%>" align="center">
                        <tr>
                            <td class="td">
                                <font color="blue" size="6">
                                    <%=title%>
                                </font>
                            </td>
                        </tr>
                    </table>
                </legend>
                <br>
                
                <TABLE ALIGN="<%=align%>" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" width="400">
                    <TR>
                        <TD CLASS="cell" bgcolor="#99bbbb" STYLE="text-align:center;font-size:16" COLSPAN="2">
                            <B><%=JOData%></B>                   
                        </TD>
                    </TR>
                    <TR>
                        <TD CLASS="cell" bgcolor="#ccdddd" STYLE="text-align:center;font-size:16" WIDTH="200">
                            <b><%=JONo%></b>
                        </TD>
                        <TD CLASS="cell" STYLE="text-align:center;font-size:16;color:red;border-right-width:1px" WIDTH="200">
                            <b><%=issueWbo.getAttribute("businessID").toString().concat("/").concat(issueWbo.getAttribute("businessIDbyDate").toString())%></b>                              
                        </TD>
                    </TR>
                    <TR>
                        <TD CLASS="cell" bgcolor="#ccdddd" STYLE="text-align:center;font-size:16" WIDTH="200">
                            <b><%=forEqp%></b>
                        </TD>
                        <TD CLASS="cell" STYLE="text-align:center;font-size:16;color:red;border-right-width:1px" WIDTH="200">
                            <b><%=issueWbo.getAttribute("issueType").toString()%></b>
                        </TD>
                    </TR>
                </TABLE>
                <br>
                
                <TABLE ALIGN="<%=align%>" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" STYLE="border-width:1px;border-color:white;">
                    <TR>
                        <TD CLASS="cell" bgcolor="#99bbbb" STYLE="text-align:center;font-size:16;border-width:1px" WIDTH="20">
                            <B>#</B>
                        </TD>
                        <TD CLASS="cell" bgcolor="#99bbbb" STYLE="text-align:center;font-size:16;border-width:1px" WIDTH="280">
                            <B><%=complaint%></B>
                        </TD>
                        <TD CLASS="cell" bgcolor="#99bbbb" STYLE="text-align:center;font-size:16;border-width:1px" WIDTH="150">
                            <B><%=isRelatedTo%></B>
                        </TD>
                        <TD CLASS="cell" bgcolor="#99bbbb" STYLE="text-align:center;font-size:16;border-width:1px" WIDTH="200">
                            <B><%=taskCode%></B>
                        </TD>
                        <TD CLASS="cell" bgcolor="#99bbbb" STYLE="text-align:center;font-size:16;border-width:1px" WIDTH="200">
                            <B><%=task%></B>
                        </TD>
                        <%--
                        <TD CLASS="cell" bgcolor="#99bbbb" STYLE="text-align:center;font-size:16;border-width:1px" WIDTH="150">
                            <B><%=labor%></B>
                        </TD>
                        --%>
                        <TD CLASS="cell" bgcolor="#99bbbb" STYLE="text-align:center;font-size:16;border-width:1px" WIDTH="200">
                            <B><%=entryTime%></B>
                        </TD>
                    </TR>
                    
                    <%if(data.size()<=0 || data == null){%>
                    <TR>
                        <TD COLSPAN="7" bgcolor="white" STYLE="text-align:center;font-size:14; border-width:1px;color:red">
                            <B><%=noComplaints%></B>
                        </TD>
                    </TR>
                    <%
                    } else {
                    %>
                    <%
                    for(int i=0;i<data.size();i++){
                    %>
                    <%
                    WebBusinessObject wbo = (WebBusinessObject) data.elementAt(i);
                    %>
                    <TR>
                        <TD bgcolor="lightblue" STYLE="text-align:center;font-size:14; border-width:1px">
                            <%=i+1%>
                        </TD>
                        <TD bgcolor="lightblue" STYLE="text-align:center;font-size:14; border-width:1px">
                            <textarea readonly style="width:280;"><%=wbo.getAttribute("complaint").toString()%></textarea>
                        </TD>
                        <TD bgcolor="lightblue" STYLE="text-align:center;font-size:14; border-width:1px">
                            <%if(!wbo.getAttribute("taskId").toString().equalsIgnoreCase("null")){%>
                            <%=relatedTo%>
                            <%} else {%>
                            <Font COLOR="red"><%=notRelated%></FONT>
                            <%}%>
                        </TD>
                        <%
                        if(!wbo.getAttribute("taskId").toString().equalsIgnoreCase("null")){
                        WebBusinessObject taskWbo = taskMgr.getOnSingleKey(wbo.getAttribute("taskId").toString());
                        %>
                        <TD bgcolor="lightblue" STYLE="text-align:center;font-size:14; border-width:1px" WIDTH="100">
                            <%=taskWbo.getAttribute("title")%>
                        </TD>
                        <TD bgcolor="lightblue" STYLE="text-align:center;font-size:14; border-width:1px" WIDTH="200">
                            <%=taskWbo.getAttribute("name")%>
                        </TD>
                        <%} else {%>
                        <TD bgcolor="lightblue" STYLE="text-align:center;font-size:14; border-width:1px" WIDTH="100">
                            <FONT COLOR="red">---</FONT>
                        </TD>
                        <TD bgcolor="lightblue" STYLE="text-align:center;font-size:14; border-width:1px" WIDTH="200">
                            <FONT COLOR="red">---</FONT>
                        </TD>
                        <%}%>
                        <%--
                        <TD bgcolor="lightblue" STYLE="text-align:center;font-size:14; border-width:1px">
                            <%=wbo.getAttribute("laborName").toString()%>
                        </TD>
                        --%>
                        <TD bgcolor="lightblue" STYLE="text-align:center;font-size:14; border-width:1px">
                            <%=wbo.getAttribute("creationTime").toString()%>
                        </TD>
                    </TR>
                    <%
                    }
                    }
                    %>
                </TABLE>
                <br>
                
            </fieldset>
        </FORM>
    </body>
</html>