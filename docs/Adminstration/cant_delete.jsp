<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*, com.tracker.common.*, java.util.*,com.tracker.business_objects.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="com.tracker.common.AppConstants"%>
  
<HTML>
    <%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    // tGuide = new TouristGuide("/com/docviewer/international/DocOnlineMenu");
    
    String context= metaMgr.getContext();
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
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
                        <%=tGuide.getMessage("cantdelete")%> <%=(String)request.getAttribute("type")%>
                    </TD>
                    <TD CLASS="tabletitle" STYLE="">
                        <IMG WIDTH="20" HEIGHT="20" SRC="images/corner.gif">
                    </TD>
                    <TD CLASS="tableright" colspan="3">
                        <IMG VALIGN="BOTTOM"  HEIGHT="15" SRC="images/leftarrow.gif">
                        <A HREF="<%=context%>/<%=(String)request.getAttribute("servlet")%>?op=<%=(String)request.getAttribute("list")%>">
                        
                            <%=tGuide.getMessage("backtolist")%>
                        </A>
                 
                    </TD>
                </TR>
            </TABLE>

            <B><FONT color="red">  <%=tGuide.getMessage("youcantdelete")%> <%=(String)request.getAttribute("type")%> '<%=(String)request.getAttribute("name")%>'</font></B>
            <BR><BR>
            <B> This <%=(String)request.getAttribute("type")%> has <%=(String)request.getAttribute("no")%> <%=tGuide.getMessage("tasks")%></B>
        </FORM>
    </BODY>
</HTML>     
                    