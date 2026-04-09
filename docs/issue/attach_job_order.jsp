<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*, com.tracker.common.*, java.util.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants"%>
<%@ page import="com.silkworm.common.TimeServices"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<HTML>
    <%
            UserMgr userMgr = UserMgr.getInstance();
            MetaDataMgr metaMgr = MetaDataMgr.getInstance();
            String context = metaMgr.getContext();
            TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

            String filterName = request.getParameter("filterName");
            String filterValue = request.getParameter("filterValue");

            String issueId = request.getParameter(IssueConstants.ISSUEID);

            String status = (String) request.getAttribute("status");

            String stat = (String) request.getSession().getAttribute("currentMode");
            String align = null;
            String dir = null;
            String style = null;
            String lang, langCode, sTitle, sCancel, sOk, sSearchTitle, sAttachingStatus, sDone, sNo, sAttachDesc;
            if (stat.equals("En")) {
                align = "center";
                dir = "LTR";
                style = "text-align:left";
                lang = "   &#1593;&#1585;&#1576;&#1610;    ";
                sTitle = "Attach Job Order";
                sCancel = "Back";
                sOk = "Save";
                langCode = "Ar";
                sSearchTitle = "Job Order Number";
                sAttachingStatus = "Saving Status";
                sDone = "Success";
                sNo = "There Is a problem In Creation";
                sAttachDesc = "Attach Description";
            } else {
                align = "center";
                dir = "RTL";
                style = "text-align:Right";
                lang = "English";
                sTitle = "&#1573;&#1604;&#1581;&#1575;&#1602; &#1571;&#1605;&#1585; &#1588;&#1594;&#1604;";
                sCancel = "&#1593;&#1608;&#1583;&#1577;";
                sOk = "&#1581;&#1601;&#1592;";
                langCode = "En";
                sSearchTitle = "&#1585;&#1602;&#1605; &#1571;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
                sAttachingStatus = "&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1581;&#1601;&#1592;";
                sDone = "&#1578;&#1605; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
                sNo = "&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
                sAttachDesc = "&#1575;&#1604;&#1608;&#1589;&#1601;";
            }
    %>
    
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>Doc Viewer- Select Project and Status</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>
    
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
        
        function submitForm()
        {    
            if (!validateData("req", this.ISSUE_FORM.attachIssueID, "Please, enter Job Order Number.")){
                this.ISSUE_FORM.attachIssueID.focus(); 
            } else if (!validateData("req", this.ISSUE_FORM.issueDesc, "Please, enter Attach Description.")){
            this.ISSUE_FORM.issueDesc.focus();
        } else {
        document.ISSUE_FORM.action = "<%=context%>/IssueServlet?op=SaveAttachJobOrder&issueId=<%=issueId%>&issueID=<%=issueId%>&filterName=<%=filterName%>&filterValue=<%=filterValue%>";
        document.ISSUE_FORM.submit();  
    }
}

function cancelForm()
{    
    document.ISSUE_FORM.action = "<%=context%>/AssignedIssueServlet?op=VIEWDETAILS&issueId=<%=issueId%>&filterName=<%=filterName%>&filterValue=<%=filterValue%>";
    document.ISSUE_FORM.submit();  
}
    </SCRIPT>
    <script src='ChangeLang.js' type='text/javascript'></script>
    <BODY>
        <FORM NAME="ISSUE_FORM" METHOD="POST">
            <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
            <button  onclick="JavaScript: cancelForm();" class="button"><%=sCancel%> <IMG VALIGN="BOTTOM" SRC="images/leftarrow.gif"> </button>
            <button  onclick="JavaScript: submitForm();" class="button"><%=sOk%> <IMG HEIGHT="15" SRC="images/save.gif"></button>
            <BR>
            <fieldset class="set" align="center">
                <legend align="center">
                    <table dir="<%=dir%>" align="center">
                        <tr>
                            <td class="td">
                                <font color="blue" size="6">
                                    <%=sTitle%>
                                </font>
                            </td>
                        </tr>
                    </table>
                </legend>
                <%
            if (status != null) {
                if (status.equalsIgnoreCase("Ok")) {
                %>
                <center style="font-size:16px;color:red;">
                    <%=sDone%>
                </center>
                <%
                    } else {
                %>
                <center style="font-size:20px;color:red;">
                    <%=sNo%>
                </center>
                <%
                }
            }
                %>
                <TABLE ALIGN="center"  DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                    <TR>
                        <TD STYLE="text-align:right" class='td'>
                            <LABEL FOR="Project_Name">
                                <p><b><%=sSearchTitle%></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="text-align:right" class='td'>
                            <input type="TEXT" value="" id="attachIssueID" name="attachIssueID" style="width:230px">
                        </TD>
                    </TR> 
                    <TR>
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="str_Maintenance_Desc">
                                <p><b><font color="#FF0000">*</font><font color="#003399"><%=sAttachDesc%></font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>"  class='td'>
                            <TEXTAREA rows="5" name="issueDesc" cols="28" style="width:230px"></TEXTAREA>
                        </TD>
                    </TR>
                </TABLE>
                <INPUT TYPE="hidden" name="filterValue" value="">
                
                <TABLE CELLPADDING="0" CELLSPACING="0" BORDER="0">
                    <TR>
                        <TD class="td">
                            &nbsp;
                        </TD>
                    </TR>
                </TABLE>
            </FIELDSET>
        </FORM>
    </BODY>
</HTML>     
