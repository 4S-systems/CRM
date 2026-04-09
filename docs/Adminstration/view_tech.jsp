<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>  
<%
MetaDataMgr metaMgr = MetaDataMgr.getInstance();
String context = metaMgr.getContext();


WebBusinessObject tech = (WebBusinessObject) request.getAttribute("tech");
TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
%>

<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Document Viewer - add new Tech</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>
    <BODY>
        <left>
        <FORM NAME="TECH_VIEW_FORM" METHOD="POST">
            <TABLE WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="right-WIDTH:1px;">
                <TR VALIGN="MIDDLE">
                    <TD COLSPAN="2" CLASS="tabletitle" STYLE="border-left-WIDTH: 1;text-align:left;">
                        <%=tGuide.getMessage("viewtech")%>
                    </TD>
                    <TD CLASS="tabletitle" STYLE="">
                        <IMG WIDTH="20" HEIGHT="20" SRC="images/corner.gif">
                    </TD>
                    <TD CLASS="tableright" colspan="3">
                
                        <IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif">
                        <A HREF="<%=context%>//TechServlet?op=ListTechnicians">
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
                            <p><b><%=tGuide.getMessage("techname")%>:</b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD class='td'>
                        <input disabled type="TEXT" name="techName" ID="techName" size="33" value="<%=tech.getAttribute("techName")%>" maxlength="255">
                    </TD>
                </TR>
                
                <TR>
                    <TD class='td'>
                        <LABEL FOR="str_Function_Desc">
                            <p><b><%=tGuide.getMessage("techjob")%>:</b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD class='td'>
                        <input disabled type="TEXT" name="jobTitle" ID="jobTitle" size="33" value="<%=tech.getAttribute("jobTitle")%>" maxlength="255">
                    </TD>
                </TR>
            </TABLE>
        </FORM>
    </BODY>
</HTML>     
                    