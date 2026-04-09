<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>

<%


MetaDataMgr metaMgr = MetaDataMgr.getInstance();
String context = metaMgr.getContext();

String status = (String) request.getAttribute("status");

WebBusinessObject tech = (WebBusinessObject) request.getAttribute("tech");
TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

%>

<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>Document Viewer - add new tech</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>
    
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

        function submitForm()
        {    
        
        if (this.TECH_FORM.techName.value ==""){
        alert ("Enter Technician  Name");
        this.TECH_FORM.techName.focus();
    } else if (this.TECH_FORM.jobTitle.value ==""){
        alert ("Enter Technician Job");
        this.TECH_FORM.jobTitle.focus();
    } else{
        document.TECH_FORM.action = "<%=context%>/TechServlet?op=UpdateTech";
        document.TECH_FORM.submit();  
        }
        }
    </SCRIPT>
    
    <BODY>
        <left>
        <FORM NAME="TECH_FORM" METHOD="POST">
            <TABLE WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="right-WIDTH:1px;">
                <TR VALIGN="MIDDLE">
                    <TD COLSPAN="2" CLASS="tabletitle" STYLE="border-left-WIDTH: 1;text-align:left;">
                        <%=tGuide.getMessage("updateexistingtech")%> 
                    </TD>
                    <TD CLASS="tabletitle" STYLE="">
                        <IMG WIDTH="20" HEIGHT="20" SRC="images/corner.gif">
                    </TD>
                    <TD CLASS="tableright" colspan="3">
                        
                        <IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif">
                        <A HREF="<%=context%>/TechServlet?op=ListTechnicians">
                            <%=tGuide.getMessage("backtolist")%> 
                        </A>
                        <IMG VALIGN="BOTTOM" HEIGHT="10" WIDTH="1" SRC="images/line.gif">
                        <A HREF="JavaScript: submitForm();">
                            <%=tGuide.getMessage("updatetech")%> 
                        </A>
                    </TD>
                </TR>
            </TABLE>
            <%
            if(null!=status) {
            
            %>
            
            <h3>   <%=tGuide.getMessage("techupdatestatus")%> : <font color="#FF0000"><%=status%></font> </h3>
            
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
                        <LABEL FOR="techName">
                            <p><b><%=tGuide.getMessage("techname")%>:</b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD class='td'>
                        <input type="TEXT" name="techName" ID="techName" size="33" value="<%=tech.getAttribute("techName")%>" maxlength="255">
                    </TD>
                </TR>
                
                <TR>
                    <TD class='td'>
                        <LABEL FOR="str_Function_Desc">
                            <p><b><%=tGuide.getMessage("techjob")%>:</b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD class='td'>
                        <input type="TEXT" name="jobTitle" ID="jobTitle" size="33" value="<%=tech.getAttribute("jobTitle")%>" maxlength="255">
                    </TD>
                </TR>
            </TABLE>
            <input type="hidden" name="techID" ID="techID" value="<%=tech.getAttribute("tech_Id")%>">
        </FORM>
    </BODY>
</HTML>     
