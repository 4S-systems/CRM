<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.tracker.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
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
        <TITLE>DebugTracker-add new maintenance</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>

    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

        function submitForm()
        { 
        if (this.MAINTENANCE_FORM.maintenanceName.value !="")
        {
     
        document.MAINTENANCE_FORM.action = "<%=context%>/MaintenanceServlet?op=SaveMaintenance";
        document.MAINTENANCE_FORM.submit();  
        }
        else
        alert ("You must enter a name to the maintenance ");
        }

    </SCRIPT>

  
    <BODY>
        <left>
        <FORM NAME="MAINTENANCE_FORM" METHOD="POST">
            <TABLE WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="right-WIDTH:1px;">
                <TR VALIGN="MIDDLE">
                    <TD COLSPAN="2" CLASS="tabletitle" STYLE="left-WIDTH: 1;text-align:left;">
                        <%=tGuide.getMessage("addnewmaintenance")%>
                    </TD>
                    <TD CLASS="tabletitle" STYLE="">
                        <IMG WIDTH="20" HEIGHT="20" SRC="images/corner.gif">
                    </TD>
                    <TD CLASS="tableright" colspan="3">
                        <A HREF="<%=context%>/IssueServlet?op=ListSchedule">
                            <%=tGuide.getMessage("cancel")%>
                        </A>
                        <IMG VALIGN="BOTTOM"  HEIGHT="15" SRC="images/cancel.gif">
                        <IMG VALIGN="BOTTOM" HEIGHT="15" WIDTH="1" SRC="images/line.gif">
                        <IMG SRC="images/save.gif">
                        <A HREF="JavaScript: submitForm();">
                            <%=tGuide.getMessage("savemaintenance")%>
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
                <tr><td  align=center>  <H2><%=tGuide.getMessage("maintenancesavingstatus")%> <%=status%></td></tr></H2>
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
                        <LABEL FOR="str_maintenance_Name">
                            <p><b><%=tGuide.getMessage("maintenancename")%> <font color="#FF0000">*</font></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD class='td'>
                        <input type="TEXT" name="maintenanceName" ID="maintenanceName" size="31" value="" maxlength="255">
                    </TD>
                </TR>
          
                <TR>
                    <TD class='td'>
                        <LABEL FOR="str_maintenance_Desc">
                            <p><b><%=tGuide.getMessage("maintenancedesc")%> <font color="#FF0000">*</font></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD class='td'>
                        <TEXTAREA rows="5" name="maintenanceDesc" cols="25"></TEXTAREA>
                    </TD>
                </TR>
            </TABLE>
        </FORM>
    </BODY>
</HTML>     
                    