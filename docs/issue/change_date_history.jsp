<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.engine.*"%>
<%@ page import="com.tracker.engine.IssueStatusFactory,java.lang.Integer"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%
MetaDataMgr metaMgr = MetaDataMgr.getInstance();
String context = metaMgr.getContext();
String filterName = request.getParameter("filterName");
String filterValue = request.getParameter("filterValue");

String[] changeDateAtt = {"beginDate", "endDate", "reason", "creationTime"};
String[] changeDateTitle = {"Begin Date", "End Date ", "Reason","Change Date", "Change by"};

int s = changeDateAtt.length;
int iTotal = 0;
String attName = null;
String attValue = null;

WebBusinessObject wbo = new WebBusinessObject();

Enumeration e;

Vector  vecHistory = (Vector) request.getAttribute("data");

WebBusinessObject issueWbo = (WebBusinessObject) request.getAttribute("issueWbo");
UserMgr userMgr = UserMgr.getInstance();

String cMode= (String) request.getSession().getAttribute("currentMode");
String  stat=cMode;
String align=null;
String dir=null;
String style=null;
String lang,langCode,back,viewChangeDate,Schedule_History,Schedule_Information,DFV;
if(stat.equals("En")){
    
    align="center";
    dir="LTR";
    style="text-align:left";
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
    langCode="Ar";
    back="Back";
    viewChangeDate="Change Date History for '" + issueWbo.getAttribute("issueTitle") + "'";
}else{
    
    align="center";
    dir="RTL";
    style="text-align:Right";
    lang="English";
    langCode="En";
    back="&#1593;&#1608;&#1583;&#1577;";
    changeDateTitle[0] = "&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1576;&#1583;&#1575;&#1610;&#1577;";
    changeDateTitle[1] = "&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1606;&#1607;&#1575;&#1610;&#1577;";
    changeDateTitle[2] = "&#1587;&#1576;&#1576; &#1575;&#1604;&#1578;&#1594;&#1610;&#1610;&#1585;";
    changeDateTitle[3] = "&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1578;&#1594;&#1610;&#1610;&#1585;";
    changeDateTitle[4] = "&#1602;&#1575;&#1605; &#1576;&#1575;&#1604;&#1578;&#1594;&#1610;&#1610;&#1585;";
    viewChangeDate="&#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1578;&#1594;&#1610;&#1610;&#1585;&#1575;&#1578; &#1575;&#1604;&#1578;&#1575;&#1585;&#1610;&#1582; &#1604; '" + issueWbo.getAttribute("issueTitle") + "'";
}
%>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">   
 function cancelForm(url)
        {    
        window.navigate(url);
        }
</SCRIPT>
<script src='ChangeLang.js' type='text/javascript'></script>
<LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">

<HTML>
    
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>Tracker- List Schedules</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>
    <BODY>
        
        <DIV align="left" STYLE="color:blue;">
            <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
            <input type="button" value="<%=back%>" onclick="cancelForm('<%=context%>/AssignedIssueServlet?op=VIEWDETAILS&issueId=<%=issueWbo.getAttribute("id")%>&mainTitle=&filterName=<%=filterName%>&filterValue=<%=filterValue%>')" class="button">
        </DIV> 
        
        <fieldset align="center" class="set" >
            <legend align="<%=align%>">
                
                <table dir="<%=dir%>" align="<%=align%>">
                    <tr>
                        
                        <td class="td">
                            <font color="blue" size="6">   <%=viewChangeDate%>
                            </font>
                            
                        </td>
                    </tr>
                </table>
            </legend >
            
            <br><br><br>
            <TABLE ALIGN="<%=align%>" DIR="<%=dir%>" WIDTH="800" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
                <TR>
                    <% for(int i = 0;i<s + 1;i++) {
                    %>
                    <TD bgcolor="#C8D8F8">
                        <B><%=changeDateTitle[i]%></B>
                    </TD>
                    <%
                    }
                    %>
                </TR>
                <%
                e = vecHistory.elements();
                vecHistory = null;
                while(e.hasMoreElements()) {
                    wbo = (WebBusinessObject) e.nextElement();
                    WebBusinessObject userWbo = userMgr.getOnSingleKey((String) wbo.getAttribute("userID"));
                %>
                <TR>
                    <% for(int i = 0;i<s;i++) {
                        attValue = (String) wbo.getAttribute(changeDateAtt[i]);
                        
                    %>
                    <TD STYLE="text-align:center">
                        <%=attValue%>
                    </TD>
                    <%
                    }
                    %>
                    <TD STYLE="text-align:center">
                        <%=userWbo.getAttribute("userName")%>
                    </TD>
                </TR>
                <%
                }
                %>
            </TABLE>
            <br><br>
        </fieldset>
    </body>
</html>