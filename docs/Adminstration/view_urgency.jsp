<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>  
<%
MetaDataMgr metaMgr = MetaDataMgr.getInstance();
String context = metaMgr.getContext();


WebBusinessObject urgency = (WebBusinessObject) request.getAttribute("urgency");
TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
%>

<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Document Viewer - add new Urgency</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>
    <BODY>
        <left>
        <FORM NAME="PROJECT_VIEW_FORM" METHOD="POST">
            <TABLE WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="right-WIDTH:1px;">
                <TR VALIGN="MIDDLE">
                    <TD COLSPAN="2" CLASS="tabletitle" STYLE="border-left-WIDTH: 1;text-align:left;">
                        <%=tGuide.getMessage("viewurgency")%>
                    </TD>
                    <TD CLASS="tabletitle" STYLE="">
                        <IMG WIDTH="20" HEIGHT="20" SRC="images/corner.gif">
                    </TD>
                    <TD CLASS="tableright" colspan="3">
                
                        <IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif">
                        <A HREF="<%=context%>//UrgencyServlet?op=ListUrgencyLevels">
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
                        <LABEL FOR="str_Function_Name">
                            <p><b><%=tGuide.getMessage("urgencyname")%>:</b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD class='td'>
                        <input disabled type="TEXT" name="urgencyName" ID="urgencyName" size="33" value="<%=urgency.getAttribute("urgencyName")%>" maxlength="255">
                    </TD>
                </TR>
          
                <TR>
                    <TD class='td'>
                        <LABEL FOR="str_Function_Desc">
                            <p><b><%=tGuide.getMessage("urgencydesc")%>:</b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD class='td'>
                        <input disabled type="TEXT" name="urgencyDesc" ID="urgencyDesc" size="33" value="<%=urgency.getAttribute("urgencyDesc")%>" maxlength="255">
                    </TD>
                </TR>
            </TABLE>
        </FORM>
    </BODY>
</HTML>     
                    