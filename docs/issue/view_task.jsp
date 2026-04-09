<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>  
<%
MetaDataMgr metaMgr = MetaDataMgr.getInstance();
String context = metaMgr.getContext();


WebBusinessObject task = (WebBusinessObject) request.getAttribute("task");
TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

String issueId = (String) request.getAttribute("issueId");
%>

<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>Document Viewer - add new task</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>
    <BODY>
        
        <FORM NAME="TASK_VIEW_FORM" METHOD="POST">
            <TABLE ALIGN="RIGHT" DIR="RTL" WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="right-WIDTH:1px;">
                <TR VALIGN="MIDDLE">
                    <TD COLSPAN="2" CLASS="tabletitle" STYLE="border-left-WIDTH: 1;text-align:right;">
                        &#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607;

                    </TD>
                
                    <TD STYLE="text-align:left" CLASS="tableright" colspan="3">
                        
                        <IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif">
                        <A HREF="<%=context%>/IssueServlet?op=ListTasks&issueId=<%=issueId%>">
                            <%=tGuide.getMessage("backtolist")%>
                        </A>
                        
                    </TD>
                </TR>
            </TABLE>
            <br><br>
            
            <TABLE ALIGN="RIGHT" DIR="RTL" CELLPADDING="0" CELLSPACING="0" BORDER="0">
          
                
                <TR>
                    <TD STYLE="text-align:right" class='td'>
                        <LABEL FOR="str_Function_Name">
                            <p><b>Task Code / &#1603;&#1608;&#1583; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607;</b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="text-align:right"  class='td'>
                        <input readonly type="TEXT" name="codeTask" ID="codeTask" size="33" value="<%=task.getAttribute("codeTask")%>" maxlength="255">
                    </TD>
                </TR>
                
                <TR>
                    <TD STYLE="text-align:right"  class='td'>
                        <LABEL FOR="str_Function_Desc">
                            <p><b>Description / &#1575;&#1604;&#1608;&#1589;&#1601;</b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="text-align:right"  class='td'>
                        <TEXTAREA readonly  rows="5" name="descEn" ID="descEn" cols="33"><%=task.getAttribute("descEn")%></TEXTAREA>
                    </TD>
                </TR>
                
                <TR>
                    <TD STYLE="text-align:right"  class='td'>
                        <LABEL FOR="str_Function_Desc">
                            <p><b></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="text-align:right"  class='td'>
                        <input type="hidden"  name="descAr" ID="descAr" cols="33" value="<%=task.getAttribute("descAr")%>">
                    </TD>
                </TR>
            </TABLE>
        </FORM>
    </BODY>
</HTML>     
