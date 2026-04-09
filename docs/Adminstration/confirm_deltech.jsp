<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
  
<HTML>

<%
   String techId = (String) request.getAttribute("techId");
   String techName = (String) request.getAttribute("techName");

    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
   
%>
   <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
   <MEeTA HTTP-EQUIV="Expires" CONTENT="0">

   <HEAD>
      <TITLE>Document Viewer - Confirm Deletion</TITLE>
      <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
   </HEAD>

   <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

   function submitForm()
   {    
      document.TECH_DEL_FORM.action = "<%=context%>/TechServlet?op=Delete&techId=<%=techId%>&techName=<%=techName%>";
      document.TECH_DEL_FORM.submit();  
   }

   </SCRIPT>

   <BODY>
      <left>
     
        <FORM NAME="TECH_DEL_FORM" METHOD="POST">
         <TABLE WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
         
	    <TR VALIGN="MIDDLE">
               <TD COLSPAN="2" CLASS="tabletitle" STYLE="border-left-WIDTH: 1;text-align:left;">
                  <%=tGuide.getMessage("deletetech")%> - <%=tGuide.getMessage("areyousure")%>
               </TD>
               <TD CLASS="tabletitle" STYLE="">
                  <IMG WIDTH="20" HEIGHT="20" SRC="images/corner.gif">
               </TD>
               <TD CLASS="tableright" colspan="3">
                  <IMG VALIGN="BOTTOM"  SRC="images/leftarrow.gif">
                  <A HREF="<%=context%>/TechServlet?op=ListTechnicians">
                     <%=tGuide.getMessage("backtolist")%>
                  </A>
                  <IMG VALIGN="BOTTOM" HEIGHT="10" WIDTH="1" SRC="images/line.gif">
                  <A HREF="JavaScript: submitForm();">
                     <%=tGuide.getMessage("deletetech")%>
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

   </table

       <TABLE ALIGN="LEFT" CELLPADDING="0" CELLSPACING="0" BORDER="0">
            
              
            
              <TR>
               <TD class='td'>
                  <LABEL FOR="ISSUE_TITLE">
                       <p><b><%=tGuide.getMessage("techname")%><font color="#FF0000"> </font></b>&nbsp;
                    </LABEL>
               </TD>
               <TD class='td'>
                 <input disabled type="TEXT" name="techName" value="<%=techName%>" ID="<%=techName%>" size="33"  maxlength="50">
               </TD>
            </TR>

            <input  type="HIDDEN" name="techId" value="<%=techId%>">
            
          
          
         </TABLE>
      </FORM>
   </BODY>
</HTML>     
                    