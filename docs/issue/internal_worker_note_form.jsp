<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*, com.tracker.business_objects.*,com.tracker.common.*, java.util.*"%>
<%@ page import="com.tracker.common.AppConstants"%>
<%@ page import="com.contractor.db_access.MaintainableMgr" %>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<HTML>
    
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>DebugTracker-add new Schedule</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>
    <%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    // tGuide = new TouristGuide("/com/docviewer/international/DocOnlineMenu");
    
    String context= metaMgr.getContext();
    String projectname = (String) request.getAttribute("projectName");
    
    UserMgr userMgr = UserMgr.getInstance();
    String issueId = (String) request.getAttribute("issueId");
    String issueTitle = (String) request.getAttribute("issueTitle");
    String direction = (String) request.getAttribute(AppConstants.DIRECTION);
    
    String filterName = (String) request.getAttribute("filterName");
    String filterValue = (String) request.getAttribute("filterValue");
    String nextStatus = (String) request.getAttribute("nextStatus");
    
    //   AssignedIssueState ais = (AssignedIssueState) request.getAttribute("state");
    
    System.out.println("Worker Notes Page" + issueId);
    
    
    String cMode= (String) request.getSession().getAttribute("currentMode");
    String  stat=cMode;
    
    String align=null;
    String dir=null;
    String style=null;
    String lang,langCode,stopWork,BackToList,save,AllRequired,note,TaskType
            ;
    if(stat.equals("En")){
        
        align="center";
        dir="LTR";
        style="text-align:left";
        
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        langCode="Ar";
        stopWork="Change Task Status";
        BackToList = "Back to list";
        save = " Save ";
        AllRequired="(*) All data must be filled";
        TaskType="Task Type";
        note="Notes";
        
    }else{
        
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        langCode="En";
        stopWork="&#1578;&#1594;&#1610;&#1585; &#1581;&#1575;&#1604;&#1607; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607;";
        BackToList = "&#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1573;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577;";
        save="&#1578;&#1587;&#1580;&#1610;&#1604;";
        AllRequired=" &#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607; (*)";
        TaskType="&#1606;&#1608;&#1593; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607;";
        note="&#1605;&#1604;&#1575;&#1581;&#1592;&#1575;&#1578;";
    }
    %>
    
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

        function submitForm()
        {    
        document.ISSUE_FORM.action = "<%=context%>/ProgressingIssueServlet?op=ChangeStatus&projectName=<%=projectname%>";
        document.ISSUE_FORM.submit();  
        }
 
    function cancelForm()
        {    
        document.ISSUE_FORM.action ="<%=context%>/AssignedIssueServlet?op=VIEWDETAILS&issueId=<%=issueId%>&filterName=<%=filterName%>&filterValue=<%=filterValue%>";
        document.ISSUE_FORM.submit();  
        }
       
                                    
    
    </SCRIPT>
    
    <script src='ChangeLang.js' type='text/javascript'></script>
    <BODY>
        
        
        <FORM NAME="ISSUE_FORM" METHOD="POST">
            
            
            <%
            if(request.getAttribute("case")!=null){
            %>
            <INPUT TYPE="HIDDEN" NAME="case" VALUE="<%=(String)request.getAttribute("case")%>">
            <INPUT TYPE="HIDDEN" NAME="title" VALUE="<%=(String)request.getAttribute("title")%>">
            <INPUT TYPE="HIDDEN" NAME="unitName" VALUE="<%=(String)request.getAttribute("unitName")%>">
            <%
            
            }
            %>
            <DIV align="left" STYLE="color:blue;">
                <input type="button" value="     <%=lang%>     " onclick="reloadAE('<%=langCode%>')" class="button">
                <button  onclick="JavaScript: cancelForm();" class="button"><%=BackToList%> <IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif"> </button>
                <button  onclick="JavaScript:  submitForm();" class="button"><%=save%> <IMG HEIGHT="13" SRC="images/save.gif"></button>
                
                
            </DIV>  
            <br><br>
            <fieldset align=center class="set" >
                <legend align="center">
                    <table dir="rtl" align="center">
                        <tr>
                            
                            <td class="td">
                                <font color="blue" size="6"> <%=stopWork%>                  
                                </font>
                                
                            </td>
                        </tr>
                    </table>
                </legend>
                <table align="<%=align%>" >
                    <TR COLSPAN="2" ALIGN="<%=align%>">
                        <TD STYLE="<%=style%>" class='td'>
                            <FONT color='red' size='+1'><%=AllRequired%></FONT> 
                        </TD>
                        <td STYLE="<%=style%>" class="td"><IMG VALIGN="BOTTOM"  HEIGHT="30" SRC="images/note.JPG"></td>
                    </TR>
                </table>
                <br><br>
                <TABLE ALIGN="<%=align%>" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                    
                    <TR>
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="ISSUE_TITLE">
                                <p><b><%=TaskType%>  <font color="#FF0000"> </font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>" class='td'>
                            <input disabled type="text" name="issueTitle" value="<%=issueTitle%>" ID="<%=issueTitle%>" size="33"  maxlength="50">
                        </TD>
                    </TR>
                    
                    <TR>
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="str_Function_Desc">
                                <p><b><%=note%><font color="#FF0000">*</font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>" class='td'>
                            <TEXTAREA rows="5" name="workerNote" cols="26"></TEXTAREA>
                        </TD>
                    </TR>
                </TABLE>
                <input type=HIDDEN name="issueId" value = "<%=issueId%>" >
                <input type=HIDDEN name=filterValue value="<%=filterValue%>" >
                <input type=HIDDEN name=filterName value="<%=filterName%>" >
                <input type=HIDDEN name="<%=AppConstants.DIRECTION%>" value="<%=direction%>" >
            </fieldset>
        </FORM>
    </BODY>
</HTML>     
