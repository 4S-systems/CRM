<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
  
<%


MetaDataMgr metaMgr = MetaDataMgr.getInstance();
String context = metaMgr.getContext();

String status = (String) request.getAttribute("status");

WebBusinessObject milestone = (WebBusinessObject) request.getAttribute("milestone");
TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

%>

<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Document Viewer - add new milestone</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>

    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

        function submitForm()
        {    
        document.MILESTONES_FORM.action = "<%=context%>/MilestoneServlet?op=UpdateMilestone";
        document.MILESTONES_FORM.submit();  
        }

    </SCRIPT>

    <BODY>
        <left>
        <FORM NAME="MILESTONES_FORM" METHOD="POST">
            <TABLE WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="right-WIDTH:1px;">
                <TR VALIGN="MIDDLE">
                    <TD COLSPAN="2" CLASS="tabletitle" STYLE="border-left-WIDTH: 1;text-align:left;">
                        <%=tGuide.getMessage("updateexistingmilestone")%> 
                    </TD>
                    <TD CLASS="tabletitle" STYLE="">
                        <IMG WIDTH="20" HEIGHT="20" SRC="images/corner.gif">
                    </TD>
                    <TD CLASS="tableright" colspan="3">
                
                        <IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif">
                        <A HREF="<%=context%>/MilestoneServlet?op=ListMilestone">
                            <%=tGuide.getMessage("backtolist")%> 
                        </A>
                        <IMG VALIGN="BOTTOM" HEIGHT="10" WIDTH="1" SRC="images/line.gif">
                        <A HREF="JavaScript: submitForm();">
                            <%=tGuide.getMessage("updatemilestone")%> 
                        </A>
                    </TD>
                </TR>
            </TABLE>
            <%
            if(null!=status) {

            %>

            <h3>   <%=tGuide.getMessage("milestoneupdatestatus")%> : <font color="#FF0000"><%=status%></font> </h3>
           
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
                        <LABEL FOR="str_Function_Name">
                            <p><b><%=tGuide.getMessage("milestonename")%>:</b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD class='td'>
                        <input disabled type="TEXT" name="milestoneName" ID="milestoneName" size="33" value="<%=milestone.getAttribute("milestoneName")%>" maxlength="255">
                    </TD>
                </TR>
                
                <TR>
                    <TD class='td'>
                        <LABEL FOR="EXPECTED_E_DATE">
                            <p><b><%=tGuide.getMessage("expectedenddate")%>:</b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD class='td'>
                        <input disabled type="TEXT" name="expectedEndDate" ID="expectedEndDate" size="33" value="<%= (String) milestone.getAttribute("expectedEndDate")%>" maxlength="255">
                    </TD>
                </TR>
          
                <TR>
                    <TD class='td'>
                        <LABEL FOR="str_Function_Desc">
                            <p><b><%=tGuide.getMessage("milestonedesc")%>:</b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD class='td'>
                        <input type="TEXT" name="milestoneDesc" ID="milestoneDesc" size="33" value="<%=milestone.getAttribute("milestoneDesc")%>" maxlength="255">
                    </TD>
                </TR>
            </TABLE>
            <input type="hidden" name="milestoneID" ID="milestoneID" value="<%=milestone.getAttribute("milestoneID")%>">
        </FORM>
    </BODY>
</HTML>     
                    