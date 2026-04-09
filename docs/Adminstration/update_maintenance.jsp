<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.tracker.db_access.*"%>

<%


    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();

    String status = (String) request.getAttribute("status");

    WebBusinessObject maintenanceWbo = (WebBusinessObject) request.getAttribute("maintenanceWbo");
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

%>

<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Document Viewer - add new maintenance</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>

    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

        function submitForm()
        {    
        document.MAINTENANCE_FORM.action = "<%=context%>/MaintenanceServlet?op=UpdateMaintenance";
        document.MAINTENANCE_FORM.submit();  
        }

    </SCRIPT>

    <BODY>
        <left>
        <FORM NAME="MAINTENANCE_FORM" METHOD="POST">
            <TABLE WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="right-WIDTH:1px;">
                <TR VALIGN="MIDDLE">
                    <TD COLSPAN="2" CLASS="tabletitle" STYLE="border-left-WIDTH: 1;text-align:left;">
                        <%=tGuide.getMessage("updateexistingmaintenance")%> 
                    </TD>
                    <TD CLASS="tabletitle" STYLE="">
                        <IMG WIDTH="20" HEIGHT="20" SRC="images/corner.gif">
                    </TD>
                    <TD CLASS="tableright" colspan="3">
                
                        <IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif">
                        <A HREF="<%=context%>/MaintenanceServlet?op=ListMaintenance">
                            <%=tGuide.getMessage("backtolist")%> 
                        </A>
                        <IMG VALIGN="BOTTOM" HEIGHT="10" WIDTH="1" SRC="images/line.gif">
                        <A HREF="JavaScript: submitForm();">
                            <%=tGuide.getMessage("updatemaintenance")%> 
                        </A>
                    </TD>
                </TR>
            </TABLE>
            <%
                if(null!=status) {

                %>
            
            <h3>   <%=tGuide.getMessage("maintenanceupdatestatus")%> : <font color="#FF0000"><%=status%></font> </h3>
           
            <%

                             }

                 %>
<TABLE CELLPADDING="0" CELLSPACING="0" BORDER="0">
                <TR>
                    <TD class='td'>
                        &nbsp;
                    </TD>
                </TR>
                    
                <TR>
                    <TD class='td'>
                        <LABEL FOR="str_Maintenance_Name">
                            <p><b><%=tGuide.getMessage("maintenancename")%>:</b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD class='td'>
                        <input disabled type="TEXT" name="maintenanceName" ID="maintenanceName" size="33" value="<%=maintenanceWbo.getAttribute("maintenanceName")%>" maxlength="255">
                    </TD>
                </TR>
          
                <TR>
                    <TD class='td'>
                        <LABEL FOR="str_Maintenance_Desc">
                            <p><b><%=tGuide.getMessage("maintenancedesc")%>:</b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD class='td'>
                        <input type="TEXT" name="maintenanceDesc" ID="maintenanceDesc" size="33" value="<%=maintenanceWbo.getAttribute("maintenanceDesc")%>" maxlength="255">
                    </TD>
                </TR>
            </TABLE>
            <input type="hidden" name="maintenanceName" ID="maintenanceName" value="<%=maintenanceWbo.getAttribute("maintenanceName")%>">
        </FORM>
    </BODY>
</HTML>     
                    