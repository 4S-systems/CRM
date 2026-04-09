<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*, com.tracker.common.*, java.util.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants"%>
<%@ page import="com.silkworm.common.TimeServices"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%--
The taglib directive below imports the JSTL library. If you uncomment it,
you must also add the JSTL library to the project. The Add Library... action
on Libraries node in Projects view can be used to add the JSTL 1.1 library.
--%>
<%--
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%> 
--%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<html>
    <%
    UserMgr userMgr = UserMgr.getInstance();
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
   System.out.println("llkkkkkk");
  
    String message = (String) request.getAttribute("message");
    String stat = (String) request.getSession().getAttribute("currentMode");
    String align=null;
    String dir=null;
    String style=null;
    WebBusinessObject webIssue=(WebBusinessObject)request.getAttribute("jopWebo");
    String lang,langCode, sTitle, sCancel;
    if(stat.equals("En")){
        
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        langCode="Ar";
        sCancel="Cancel";
        sTitle="Search for Job Order";
    }else{
        
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        langCode="En";
        sCancel = tGuide.getMessage("cancel");
        sTitle = "&#1576;&#1581;&#1579; &#1593;&#1606; &#1571;&#1605;&#1585; &#1588;&#1594;&#1604;";
    }
    
    
    %>
  
    
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        
    </head>
    <body>
        
       
        
        <TABLE ALIGN="<%=align%>"  CELLPADDING="0" CELLSPACING="0" BORDER="0" dir="<%=dir%>">
            
            
            <TR>
                <TD STYLE="<%=style%>" class='td'>
                    <LABEL FOR="ISSUE_TITLE">
                        <p><b><font color="#003399">Maintenance No# / &#1585;&#1602;&#1605; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1607;</font></b>&nbsp;
                    </LABEL>
                </TD>
                <TD STYLE="<%=style%>" class='td'>
                    <input disabled type="TEXT" name="id" ID="id" size="20" value="<%= (String) webIssue.getAttribute("id")%>" maxlength="255">
                </TD>
                <TD STYLE="<%=style%>" class='td'>
                    <LABEL FOR="ISSUE_TITLE">
                        <p><b><font color="#003399">Task Name / &#1573;&#1587;&#1605; &#1580;&#1583;&#1608;&#1604; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;</font></b>&nbsp;
                    </LABEL>
                </TD>
                <TD STYLE="<%=style%>" class='td'>
                    <input disabled type="TEXT" name="issueTitle" ID="issueTitle" size="20" value="<%=(String) webIssue.getAttribute("issueTitle")%>" maxlength="255">
                </TD>
            </TR>
            <TD class='td'>
                &nbsp;
            </TD>
            <TR>
                <TD STYLE="<%=style%>" class='td'>
                    <LABEL FOR="ISSUE_TITLE">
                        <p><b><font color="#003399">Received by /&#1571;&#1587;&#1578;&#1604;&#1605;&#1578; &#1576;&#1608;&#1575;&#1587;&#1591;&#1577;</font></b>&nbsp;
                    </LABEL>
                </TD>
                <TD STYLE="<%=style%>" class='td'>
                    <input disabled type="TEXT" name="Receivedby" ID="Receivedby" size="20" value="<%=(String) webIssue.getAttribute("receivedBy")%>" maxlength="255">
                </TD>
                <TD STYLE="<%=style%>" class='td'>
                    <LABEL FOR="ISSUE_TITLE">
                        <p><b><font color="#003399">Work Order Trade / &#1571;&#1605;&#1585; &#1575;&#1604;&#1593;&#1605;&#1604;</font></b>&nbsp;
                    </LABEL>
                </TD>
                <TD STYLE="<%=style%>" class='td'>
                    <input disabled type="TEXT" name="workTrade" ID="workTrade" size="20" value="<%= (String) webIssue.getAttribute("workTrade")%>" maxlength="255">
                </TD>
            </TR>
            <TD class='td'>
                &nbsp;
            </TD>
            <TR>
                <TD STYLE="<%=style%>" class='td'>
                    <LABEL FOR="ISSUE_TITLE">
                        <p><b><font color="#003399">Failure Code / &#1575;&#1604;&#1603;&#1608;&#1583;</font></b>&nbsp;
                    </LABEL>
                </TD>
                <TD STYLE="<%=style%>" class='td'>
                    <input disabled type="TEXT" name="failureCode" ID="failureCode" size="20" value="<%= (String) webIssue.getAttribute("failureCode")%>" maxlength="255">
                </TD>
                <TD STYLE="<%=style%>" class='td'>
                    <LABEL FOR="Project_Name">
                        <p><b><font color="#003399">Site Name / &#1573;&#1587;&#1605; &#1575;&#1604;&#1605;&#1608;&#1602;&#1593;</font></b>&nbsp;
                    </LABEL>
                </TD>
                <TD STYLE="<%=style%>" class='td'>
                    <input disabled type="TEXT" name="siteName" ID="siteName" size="20" value="<%= (String) webIssue.getAttribute("siteName")%>" maxlength="255">
                </TD>
            </TR>
            <TD class='td'>
                &nbsp;
            </TD>
            <TR>
                <TD STYLE="<%=style%>" class='td'>
                    <LABEL FOR="Project_Name">
                        <p><b><font color="#003399">Urgency Level / &#1583;&#1585;&#1580;&#1577; &#1575;&#1604;&#1571;&#1607;&#1605;&#1610;&#1607;</font></b>&nbsp;
                    </LABEL>
                </TD>
                <TD STYLE="<%=style%>" class='td'>
                    <input disabled type="TEXT" name="urgencyLevel" ID="urgencyLevel" size="20" value="<%= (String) webIssue.getAttribute("urgencyLevel")%>" maxlength="255">
                </TD>
                <TD STYLE="<%=style%>" class='td'>
                    <LABEL FOR="estimated_duration">
                        <p><b><font color="#003399">Estimated Duration/Hours /&#1575;&#1604;&#1608;&#1602;&#1578; &#1575;&#1604;&#1605;&#1578;&#1608;&#1602;&#1593; &#1576;&#1575;&#1604;&#1587;&#1575;&#1593;&#1607;</font></b>&nbsp;
                    </LABEL>
                </TD>
                <TD STYLE="<%=style%>" class='td'>
                    <input disabled type="TEXT" name="estimatedduration" ID="estimatedduration" size="5" value="<%= (String) webIssue.getAttribute("estimatedduration")%>" maxlength="255">
                </TD>
            </TR>
            <TD class='td'>
                &nbsp;
            </TD>
            <TR>
                <TD STYLE="<%=style%>" class='td'>
                    <LABEL FOR="str_IssueType_Name">
                        <p><b><font color="#003399">Job Type / &#1606;&#1608;&#1593; &#1575;&#1604;&#1593;&#1605;&#1604;</font></b>&nbsp;
                    </LABEL>
                </TD>
                <TD STYLE="<%=style%>" class='td'>
                    <input disabled type="TEXT" name="typeName" ID="typeName" size="20" value="<%= (String) webIssue.getAttribute("issueType")%>" maxlength="255">
                </TD>
                <TD STYLE="<%=style%>" class='td'>
                    <LABEL FOR="str_User_Name">
                        <p><b><font color="#003399"><%=tGuide.getMessage("createdby")%> / &#1576;&#1608;&#1575;&#1587;&#1591;&#1577;</font></b>&nbsp;
                    </LABEL>
                </TD>
                <%
                //createdBy= issueMgr.getCreateBy(createdBy);
                %>
                <TD STYLE="<%=style%>" class='td'>
                    <input disabled type="TEXT" name="createdBy" ID="createdBy" size="20" value="<%= (String) webIssue.getAttribute("createdByName")%>" maxlength="255">
                </TD>
            </TR>
            
            <TD class='td'>
                &nbsp;
            </TD>
            
            
            <TR>
                <TD STYLE="<%=style%>" class='td'>
                    <LABEL FOR="str_current_status">
                        <p><b><font color="#003399"><%=tGuide.getMessage("currentstatus")%> / &#1575;&#1604;&#1581;&#1575;&#1604;&#1607; &#1575;&#1604;&#1581;&#1575;&#1604;&#1610;&#1577;</font></b>&nbsp;
                    </LABEL>
                </TD>
                <TD STYLE="<%=style%>" class='td'>
                    <input disabled type="TEXT" name="currentStatus" ID="currentStatus" size="20" value="<%= (String) webIssue.getAttribute("currentStatus")%>" maxlength="255">
                </TD>
                <TD STYLE="<%=style%>" class='td'>
                    <LABEL FOR="str_creation_time">
                        <p><b><font color="#003399"><%=tGuide.getMessage("creationtime")%> / &#1608;&#1602;&#1578; &#1575;&#1604;&#1573;&#1606;&#1588;&#1575;&#1569;</font></b>&nbsp;
                    </LABEL>
                </TD>
                <TD STYLE="<%=style%>" class='td'>
                    <input disabled type="TEXT" name="CREATION_TIME" ID="CREATION_TIME" size="20" value="<%= (String) webIssue.getAttribute("currentStatusSince")%>" maxlength="255">
                </TD>
            </TR>
            
            <TD class='td'>
                &nbsp;
            </TD>
            
            <TR>
                
                <TD STYLE="<%=style%>" class='td'>
                    <LABEL FOR="str_assigned_by">
                        <p><b><font color="#003399"><%=tGuide.getMessage("assignedby")%> / &#1587;&#1604;&#1605; &#1576;&#1608;&#1575;&#1587;&#1591;&#1577;</font></b>&nbsp;
                    </LABEL>
                </TD>
                <%
                //if(! AssignByName.equals("UL")){
                
                %>
                <TD STYLE="<%=style%>" class='td'>
                    <input disabled type="TEXT" name="assignedByName" ID="assignedByName" size="20" value="<%= (String) webIssue.getAttribute("AssignByName")%>" maxlength="255">
                </TD>
                <%// } else {
                //  AssignByName="Not assigned";
                %>
                <!--TD class='td'>   
                <input disabled type="TEXT" name="assignedByName" ID="assignedByName" size="20" value="<%//=AssignByName%>" maxlength="255">
                <% //}%>
                        
                    </TD-->
                <TD STYLE="<%=style%>" class='td'>
                    <LABEL FOR="EXPECTED_B_DATE">
                        <p><b><font color="#003399"><%=tGuide.getMessage("expectedbdate")%> /&#1608;&#1602;&#1578; &#1575;&#1604;&#1576;&#1583;&#1575;&#1610;&#1577; &#1575;&#1604;&#1605;&#1578;&#1608;&#1602;&#1593; </font></b>&nbsp;
                    </LABEL>
                </TD>
                <TD STYLE="<%=style%>" class='td'>
                    <input disabled type="TEXT" name="expectedBeginDate" ID="expectedBeginDate" size="20" value="<%= (String) webIssue.getAttribute("expectedBeginDate")%>" maxlength="255">
                </TD>
            </TR>
            
            <TD class='td'>
                &nbsp;
            </TD>
            
            <TR>
                <TD STYLE="<%=style%>" class='td'>
                    <LABEL FOR="EXPECTED_E_DATE">
                        <p><b><font color="#003399"><%=tGuide.getMessage("expectededate")%> / &#1608;&#1602;&#1578; &#1575;&#1604;&#1606;&#1607;&#1575;&#1610;&#1607; &#1575;&#1604;&#1605;&#1578;&#1608;&#1602;&#1593;</font></b>&nbsp;
                    </LABEL>
                </TD>
                <TD STYLE="<%=style%>" class='td'>
                    <input disabled type="TEXT" name="expectedEndDate" ID="expectedEndDate" size="20" value="<%= (String) webIssue.getAttribute("expectedEndDate")%>" maxlength="255">
                </TD>
                <TD STYLE="<%=style%>" class='td'>
                    <LABEL FOR="str_finshed_time">
                        <p><b><font color="#003399"><%=tGuide.getMessage("finishedtime")%>/Hours / &#1608;&#1602;&#1578; &#1575;&#1604;&#1606;&#1607;&#1575;&#1610;&#1607; &#1576;&#1575;&#1604;&#1587;&#1575;&#1593;&#1607;</font></b>&nbsp;
                    </LABEL>
                </TD>
                <%
                //if(! FinishTime.equals("0")){
                %>
                <TD STYLE="<%=style%>" class='td'>
                    <input disabled type="TEXT" name="finishTime" ID="finishTime" size="20" value="<%= (String) webIssue.getAttribute("finishTime")%>" maxlength="255">
                </TD>
                
                <% //}else {
                // FinishTime="Has not been specified ";
                
                %>
                
                <!--TD class='td'>
                <input disabled type="TEXT" name="finishedTime" ID="finishedTime" size="20" value="<%//=FinishTime%>" maxlength="255">
                    </TD-->
            </TR>
            <% //}%>
            
            <TD class='td'>
                &nbsp;
            </TD>
            <TR>
                
                <TD STYLE="<%=style%>" class='td'>
                    <LABEL FOR="str_Maintenance_Desc">
                        <p><b><font color="#003399">Problem Description / &#1608;&#1589;&#1601; &#1575;&#1604;&#1605;&#1588;&#1603;&#1604;&#1577;</font> </b>&nbsp;
                    </LABEL>
                </TD>
                <TD STYLE="<%=style%>" class='td'>
                    <TEXTAREA disabled rows="5" name="issueDesc" cols="25"> <%= (String) webIssue.getAttribute("issueDesc")%></TEXTAREA>
                </TD>
                
            </TR>
        </TABLE>
       
        <BR>
        
        
    </body>
</html>
