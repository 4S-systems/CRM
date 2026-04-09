<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.tracker.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<HTML>
    
    <%
    String taskID = (String) request.getAttribute("taskID");
    String codeTask = (String) request.getAttribute("codeTask");
    String issueId = (String) request.getAttribute("issueId");
    
    ProjectMgr projectMgr=ProjectMgr.getInstance();
    
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
    String cMode= (String) request.getSession().getAttribute("currentMode");
    String  stat=cMode;
    String align=null;
    String dir=null;
    String style=null;
    String lang,langCode;
    if(stat.equals("En")){
        
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        langCode="Ar";
    }else{
        
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        langCode="En";
    }
    
    %>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <MEeTA HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>Document Viewer - Confirm Deletion</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>
    
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

   function submitForm()
   {    
      document.TASK_DEL_FORM.action = "<%=context%>/IssueServlet?op=DeleteTask&taskID=<%=taskID%>&codeTask=<%=codeTask%>&issueId=<%=issueId%>";
      document.TASK_DEL_FORM.submit();  
   }

    </SCRIPT>
    
    <script src='ChangeLang.js' type='text/javascript'></script>
    
    
    <BODY>
        
        
        
        <FORM NAME="TASK_DEL_FORM" METHOD="POST">
            
            
            <DIV align="left" STYLE="color:blue;">
                <input type="button" value="<%=lang%>"
                       onclick="reloadAE('<%=langCode%>')" STYLE="background:#cc6699;font-size=15;color:white;font-weight:bold; ">
            </DIV> 
            <TABLE ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
                
                <TR VALIGN="MIDDLE">
                    <TD COLSPAN="2" CLASS="tabletitle" STYLE="border-left-WIDTH: 1;<%=style%>;">
                        &#1581;&#1584;&#1601; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607; - &#1607;&#1604; &#1571;&#1606;&#1578; &#1605;&#1578;&#1571;&#1603;&#1583;&#1567;
                    </TD>
                    
                    <TD STYLE="<%=style%>" CLASS="tableright" colspan="3">
                        <IMG VALIGN="BOTTOM"  SRC="images/leftarrow.gif">
                        <A HREF="<%=context%>/IssueServlet?op=ListTasks&issueId=<%=issueId%>">
                            <%=tGuide.getMessage("backtolist")%>
                        </A>
                        <IMG VALIGN="BOTTOM" HEIGHT="10" WIDTH="1" SRC="images/line.gif">
                        <A HREF="JavaScript: submitForm();">
                            &#1581;&#1584;&#1601; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607;
                        </A>
                    </TD>
                </TR>
            </TABLE>
            <br><br>
            
            
            
            <TABLE ALIGN="<%=align%>" dir="<%=dir%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                
                
                <TR>
                    <TD STYLE="<%=style%>" class='td'>
                        <LABEL FOR="str_Function_Name">
                            <p><b>Task Code / &#1603;&#1608;&#1583; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607;</b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="<%=style%>" class='td'>
                        <input disabled type="TEXT" name="codeTask" value="<%=codeTask%>" ID="<%=codeTask%>" size="33"  maxlength="50">
                    </TD>
                </TR>
                
                <input  type="HIDDEN" name="taskID" value="<%=taskID%>">
                
                
                
            </TABLE>
        </FORM>
    </BODY>
</HTML>     
