<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.tracker.db_access.*"%>  
<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    ProjectMgr projectMgr = ProjectMgr.getInstance();
    String context = metaMgr.getContext();


    WebBusinessObject maintenanceWbo = (WebBusinessObject) request.getAttribute("maintenanceWbo");
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
%>

<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Document Viewer - add new Maintenance</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>
    <BODY>
        <left>
        <FORM NAME="PROJECT_VIEW_FORM" METHOD="POST">
            <TABLE WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="right-WIDTH:1px;">
                <TR VALIGN="MIDDLE">
                    <TD COLSPAN="2" CLASS="tabletitle" STYLE="border-left-WIDTH: 1;text-align:left;">
                        <%=tGuide.getMessage("viewmaintenance")%>
                    </TD>
                    <TD CLASS="tabletitle" STYLE="">
                        <IMG WIDTH="20" HEIGHT="20" SRC="images/corner.gif">
                    </TD>
                    <TD CLASS="tableright" colspan="3">
                
                        <IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif">
                        <A HREF="<%=context%>//MaintenanceServlet?op=ListMaintenance">
                            <%=tGuide.getMessage("backtolist")%>
                        </A>

                    </TD>
                </TR>
            </TABLE>


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
                        <input disabled type="TEXT" name="maintenanceDesc" ID="maintenanceDesc" size="33" value="<%=maintenanceWbo.getAttribute("maintenanceDesc")%>" maxlength="255">
                    </TD>
                </TR>
            </TABLE>
        </FORM>
    </BODY>
</HTML>     
                    