<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*, com.tracker.common.*, java.util.*,com.tracker.business_objects.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="com.tracker.common.AppConstants"%>
  
<HTML>
    <%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    // tGuide = new TouristGuide("/com/docviewer/international/DocOnlineMenu");
    
    String context= metaMgr.getContext();
    String filterName = (String) request.getAttribute ("filterName");
    String filterValue = (String) request.getAttribute ("filterValue");
    
    String projectname = (String) request.getAttribute("projectName");
    %>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <MEeTA HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Tracker- Privacy  Viloation</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>

   

    <BODY>
        <left>
     
        <FORM NAME="ISSUE_FORM" METHOD="POST">
            <TABLE WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
                <TR VALIGN="MIDDLE">
                    <TD COLSPAN="2" CLASS="tabletitle" STYLE="border-left-WIDTH: 1;text-align:left;">
                        Privacy Viloation 
                    </TD>
                    <TD CLASS="tabletitle" STYLE="">
                        <IMG WIDTH="20" HEIGHT="20" SRC="images/corner.gif">
                    </TD>
                    <TD CLASS="tableright" colspan="3">
                        <IMG VALIGN="BOTTOM"  HEIGHT="15" SRC="images/leftarrow.gif">
                        <A HREF="<%=context%>/SearchServlet?op=<%=filterName%>&filterValue=<%=filterValue%>&projectName=<%=projectname%>">
                        
                            Back to list
                        </A>
                 
                    </TD>
                </TR>
            </TABLE>

            <B>  You Don't own this schedule: you can't perform this operation </B>
        </FORM>
    </BODY>
</HTML>     
                    