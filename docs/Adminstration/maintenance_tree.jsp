<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.tracker.db_access.ProjectMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    <HEAD>
        <TITLE>System Projects List</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>
    <%

        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

    %>

    <body>


        <TABLE CELLPADDING="0" CELLSPACING="0" BORDER="0">
            <TR>
                <TD class='td'>
                    &nbsp;
                </TD>
            </TR>

        </table> 

        <TABLE  stylel="position:absolute;left:30px;border-right-WIDTH:1px"  WIDTH="200" CELLPADDING="0" CELLSPACING="0">


                               
            <TD nowrap COLSPAN="2" CLASS="tabletitle" STYLE="border-left-WIDTH: 1;text-align:left;">
                <IMG WIDTH="20" HEIGHT="20" SRC="images/pinion.gif">
                Maintainable Units
            </TD>
            <TD CLASS="tabletitle" STYLE="">
                <IMG WIDTH="20" HEIGHT="20" SRC="images/corner.gif">
            </TD>

                  
            </TR>
        </TABLE>
<br><br>
        <APPLET CODE="com\silkworm\contractor\Interface\TreeJApplet.class" width=200 height=200 ARCHIVE="docs/maintenance.jar,docs/lib/jcalendar-1.3.2.jar,docs/lib/looks-2.0.1.jar,docs/lib/mysql-connector-java-5.0.3-bin.jar,docs/lib/swing-layout-1.0.jar">
            
        </APPLET>
    </body>
</html>
