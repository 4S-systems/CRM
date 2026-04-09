
<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
  
<HTML>

    <%
    String status = (String) request.getAttribute("Status");
    
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

    %>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>DebugTracker-add new Task type</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>

    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

        function submitForm()
        {  
        if (this.ISSUETYPE_FORM.issueName.value !="")
        {
        document.ISSUETYPE_FORM.action = "<%=context%>/IssueTypeServlet?op=SaveIssueType";
        document.ISSUETYPE_FORM.submit();  
        }
        else
        alert ("You must enter a name to the Task ");
        }

    </SCRIPT>

  
    <BODY>
        <left>
        <FORM NAME="ISSUETYPE_FORM" METHOD="POST">
             

            <TABLE WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="right-WIDTH:1px;">
                <TR VALIGN="MIDDLE">
                    <TD COLSPAN="2" CLASS="tabletitle" STYLE="border-left-WIDTH: 1;text-align:left;">
                        <%=tGuide.getMessage("addnewissuetype")%>
                    </TD>
                    <TD CLASS="tabletitle" STYLE="">
                        <IMG WIDTH="20" HEIGHT="20" SRC="images/corner.gif">
                    </TD>
                    <TD CLASS="tableright" colspan="3">
                  
                        <A HREF="<%=context%>/IssueServlet?op=ListSchedule">
                            <%=tGuide.getMessage("cancel")%>
                        </A>
                        <IMG VALIGN="BOTTOM"  HEIGHT="15" SRC="images/cancel.gif">
                        <IMG VALIGN="BOTTOM" HEIGHT="10" WIDTH="1" SRC="images/line.gif">
                        <IMG SRC="images/save.gif">
                        <A HREF="JavaScript: submitForm();">
                            <%=tGuide.getMessage("saveissuetype")%>
                        </A>
                    </TD>
                </TR>
            </TABLE>
            <%    if(null!=status)
     {

            %>

            <table> 
                <tr><td>
                </td></tr>
                <tr><td class="mes" align=center>  <h3> <%=tGuide.getMessage("issuetypesavingstatus")%> : <%=status%></td></tr></h3>
            </table>
            <%
            }
            %>
            <TABLE CELLPADDING="0" CELLSPACING="0" BORDER="0">
                <TR>
                    <TD class='td'>
                        &nbsp;
                    </TD>
                </TR>

                <TR COLSPAN="2" ALIGN="CENTER">
                    <TD class='td'>
                        <FONT color='red' size='+1'><%=tGuide.getMessage("allfieldsrequired")%></FONT> 
                    </TD>
                </TR>

                <TR>
                    <TD class='td'>
                        <LABEL FOR="str_Function_Name">
                            <p><b><%=tGuide.getMessage("issuetypename")%> <font color="#FF0000">*</font></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD class='td'>
                        <input type="TEXT" name="issueName" ID="issueName" size="33" value="" maxlength="255">
                    </TD>
                </TR>
          
                <TR>
                    <TD class='td'>
                        <LABEL FOR="str_Function_Desc">
                            <p><b><%=tGuide.getMessage("issuetypedesc")%> <font color="#FF0000">*</font></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD class='td'>
                        <TEXTAREA rows="5" name="issueDesc" cols="25"></TEXTAREA>
                    </TD>
                </TR>
            </TABLE>
        </FORM>
    </BODY>
</HTML>     
                    