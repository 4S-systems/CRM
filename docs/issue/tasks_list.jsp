<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.tracker.db_access.*,com.tracker.db_access.IssueMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    <HEAD>
        <TITLE>System Projects List</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>
    <%
    
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    
    String[] taskAttributes = {"title" ,"name"};
    String[] taskListTitles = {"&#1603;&#1608;&#1583; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607;", "&#1573;&#1587;&#1605; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607;" ,"&#1581;&#1584;&#1601;"};
    
    int s = taskAttributes.length;
    int t = s+1;
    int iTotal = 0;
    
    String attName = null;
    String attValue = null;
    String cellBgColor = null;
    
    
    
    Vector  projectsList = (Vector) request.getAttribute("data");
    
    
    WebBusinessObject wbo = null;
    int flipper = 0;
    String bgColor = null;
    
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
    String issueId = (String) request.getAttribute("issueId");
    String filterName= request.getParameter("filterName");
    String filterValue= request.getParameter("filterValue");
    
    String stat= (String) request.getSession().getAttribute("currentMode");
    String align=null;
    String dir=null;
    String style=null;
    String lang, langCode, sTitle, sCancel, sQuickSummary, sBasicOperations, sMoreDetails, sTaskNo;
    
    if(stat.equals("En")){
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        sTitle="Tasks List";
        sCancel="Back";
        langCode="Ar";
        sQuickSummary="Quick Summary";
        sBasicOperations="Basic Oprations";
        sTaskNo = "Tasks Number";
        taskListTitles[0] = "Task Code";
        taskListTitles[1] = "Task Name";
        taskListTitles[2] = "Delete";
    }else{
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        sTitle="&#1593;&#1585;&#1590; &#1575;&#1604;&#1605;&#1607;&#1575;&#1605;";
        sCancel="&#1593;&#1600;&#1600;&#1600;&#1600;&#1608;&#1583;&#1577;";
        langCode="En";
        sQuickSummary="&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1587;&#1585;&#1610;&#1593;&#1577;";
        sBasicOperations="&#1593;&#1605;&#1604;&#1610;&#1575;&#1578; &#1571;&#1587;&#1575;&#1587;&#1610;&#1577;";
        sMoreDetails = "&#1578;&#1601;&#1575;&#1589;&#1610;&#1604; &#1571;&#1603;&#1579;&#1585;";
        sTaskNo = "&#1593;&#1583;&#1583; &#1575;&#1604;&#1605;&#1607;&#1575;&#1605;";
    }
    %>
    <script type="text/javascript">
    function cancelForm()
    {    
        document.ISSUE_FORM.action = "<%=context%>/AssignedIssueServlet?op=viewdetails&issueId=<%=issueId%>&filterValue=<%=filterValue%>&filterName=<%=filterName%>";
        document.ISSUE_FORM.submit();  
    }
    </script>
    <script src='ChangeLang.js' type='text/javascript'></script>
    <body>
        <FORM NAME="ISSUE_FORM" METHOD="POST">
            <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
            <button  onclick="JavaScript: cancelForm();" class="button"><%=sCancel%><IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif"> </button>
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
                <TABLE  ALIGN="CENTER" DIR="<%=dir%>"  WIDTH="450" CELLPADDING="0" CELLSPACING="0">
                    <TR>
                        <TD CLASS="td">
                            &nbsp;
                        </TD>
                    </TR>
                    <TR>
                        <TD CLASS="td" COLSPAN="2" bgcolor="#808000" STYLE="text-align:center;color:white;font-size:16">
                            <B><%=sQuickSummary%></B>
                        </TD>
                        <TD CLASS="td" COLSPAN="1" bgcolor="#669900" STYLE="text-align:center;color:white;font-size:16">
                            <B><%=sBasicOperations%></B>
                        </TD>
                    </TR>
                    <TR CLASS="head">
                        <%
                        for(int i = 0;i<t;i++) {
        String columnColor = new String("");
        if(i == 0 || i == 1){
            columnColor = "#9B9B00";
        } else {
            columnColor = "#7EBB00";
        }
                        %>
                        <TD nowrap CLASS="firstname" WIDTH="150" bgcolor="<%=columnColor%>" STYLE="border-WIDTH:0;color:white;" nowrap>
                            <%=taskListTitles[i]%>
                            </TD>
                        <%
                        }
                        %>
                    </TR>
                    <%
                    Enumeration e = projectsList.elements();
                    while(e.hasMoreElements()) {
                        iTotal++;
                        wbo = (WebBusinessObject) e.nextElement();
                        
                        //flipper++;
                        //if((flipper%2) == 1) {
                        //    bgColor="#c8d8f8";
                        //} else {
                        //    bgColor="white";
                        //}
                    %>
                    <TR>
                        <%
                        for(int i = 0;i<s;i++) {
                            attName = taskAttributes[i];
                            attValue = (String) wbo.getAttribute(attName);
                        %>
                        <TD  BGCOLOR="#DDDD00" STYLE="<%=style%>" nowrap  CLASS="cell" >
                            <DIV >
                                <b> <%=attValue%> </b>
                            </DIV>
                        </TD>
                        <%
                        }
                        %>
                        <TD nowrap CLASS="cell" STYLE="padding-left:10;<%=style%>" BGCOLOR="#D7FF82">
                            <DIV ID="links">
                                <A HREF="<%=context%>/IssueServlet?op=DeleteTask&taskId=<%=wbo.getAttribute("id")%>&issueId=<%=request.getAttribute("issueId")%>&filterValue=<%=filterValue%>&filterName=<%=filterName%>">
                                    <%=tGuide.getMessage("delete")%>
                                </A>
                            </DIV>
                        </TD>
                    </TR>
                    <%
                    
                    }
                    
                    %>
                    <TR>
                        <TD CLASS="cell" COLSPAN="2" BGCOLOR="#808080" STYLE="<%=style%>;padding-right:5;border-right-width:1;color:white;font-size:14;">
                            <B><%=sTaskNo%></B>
                        </TD>
                        <TD STYLE="<%=style%>;padding-left:5;;color:white;font-size:14;" CLASS="cell" BGCOLOR="#808080" colspan="1">
                            
                            <DIV NAME="" ID="">
                                <B><%=iTotal%></B>
                            </DIV>
                        </TD>
                    </TR>
                    <TR>
                        <TD CLASS="td">
                            &nbsp;
                        </TD>
                    </TR>
                </table>
            </fieldset>
        </form>
    </body>
</html>
