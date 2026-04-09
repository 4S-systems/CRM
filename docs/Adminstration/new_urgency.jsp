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
        <TITLE>DebugTracker-add new urgency</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>

    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

        function submitForm()
        { 
        if (this.URGENCY_FORM.urgencyName.value !="")
        {
        document.URGENCY_FORM.action = "<%=context%>/UrgencyServlet?op=SaveUrgency";
        document.URGENCY_FORM.submit();  
        }
        else
        alert ("You must enter an urgency name to the issue ");

        }

    </SCRIPT>

 
    <BODY>
        <left>
        <FORM NAME="URGENCY_FORM" METHOD="POST">
            <TABLE WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="right-WIDTH:1px;">
                <TR VALIGN="MIDDLE">
                    <TD COLSPAN="2" CLASS="tabletitle" STYLE="border-left-WIDTH: 1;text-align:left;" class='td'>
                        <%=tGuide.getMessage("addnewurgency")%>
                    </TD>
                    <TD CLASS="tabletitle" STYLE="" class='td'>
                        <IMG WIDTH="20" HEIGHT="20" SRC="images/corner.gif">
                    </TD>
                    <TD CLASS="tableright" colspan="3" class='td'>
                  
                        <A HREF="<%=context%>/IssueServlet?op=ListSchedule">
                            <%=tGuide.getMessage("cancel")%>
                        </A>
                        <IMG VALIGN="BOTTOM"  HEIGHT="15" SRC="images/cancel.gif">
                        <IMG VALIGN="BOTTOM" HEIGHT="10" WIDTH="1" SRC="images/line.gif">
                        <IMG SRC="images/save.gif">
                        <A HREF="JavaScript: submitForm();">
                            <%=tGuide.getMessage("saveurgency")%>
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
                <tr><td  align=center>  <H2><%=tGuide.getMessage("urgencysavingstatus")%> : <%=status%></td></tr></H2>
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
                        <LABEL FOR="str_Urgency_Name">
                            <p><b><%=tGuide.getMessage("urgencyname")%> <font color="#FF0000">*</font></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD class='td'>
                        <input type="TEXT" name="urgencyName" ID="urgencyName" size="33" value="" maxlength="255">
                    </TD>
                </TR>

                <TR>
                    <TD class='td'>
                        <LABEL FOR="str_Function_Desc">
                            <p><b><%=tGuide.getMessage("urgencydesc")%> <font color="#FF0000">*</font></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD class='td'>
                        <TEXTAREA rows="5" name="urgencyDesc" cols="25"></TEXTAREA>
                    </TD>
                </TR>
            </TABLE>
        </FORM>
    </BODY>
</HTML>     
                    