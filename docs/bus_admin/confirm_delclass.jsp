<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
  
<HTML>

<%
   String classId = (String) request.getAttribute("classId");
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    TouristGuide tGuide = new TouristGuide("/com/silkworm/international/BasicForms");
%>
   <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
   <MEeTA HTTP-EQUIV="Expires" CONTENT="0">

   <HEAD>
      <TITLE>Document Viewer - Confirm Delete </TITLE>
      <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
   </HEAD>

   <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

   function submitForm()
   {    
      document.ISSUE_FORM.action = "<%=context%>/ClassServlet?op=Delete&classId=<%=classId%>";
      document.ISSUE_FORM.submit();  
   }

   </SCRIPT>

   <BODY>
      <left>
     
        <FORM NAME="ISSUE_FORM" METHOD="POST">
         <TABLE WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
         
	    <TR VALIGN="MIDDLE">
               <TD COLSPAN="2" CLASS="tabletitle" STYLE="border-left-WIDTH: 1;text-align:left;">
                  <%=tGuide.getMessage("deleteclass")%> -  <%=tGuide.getMessage("areyousure")%>
               </TD>
               <TD CLASS="tabletitle" STYLE="">
                  <IMG WIDTH="20" HEIGHT="20" SRC="images/corner.gif">
               </TD>
               <TD CLASS="tableright" colspan="3">
                  
                  <A HREF="<%=context%>/ClassServlet?op=ListAll">
                      <%=tGuide.getMessage("backtolist")%>
                  </A>
<IMG VALIGN="BOTTOM"   SRC="images/arrow_left_red.gif">
                  <IMG VALIGN="BOTTOM" HEIGHT="10" WIDTH="1" SRC="images/line.gif">
                  <A HREF="JavaScript: submitForm();">
                     <%=tGuide.getMessage("deleteclass")%>
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
                       <p><b> <%=tGuide.getMessage("classtitle")%>:<font color="#FF0000"> </font></b>&nbsp;
                    </LABEL>
               </TD>
               <TD class='td'>
                 <input disabled type="TEXT" name="classId" value="<%=classId%>" ID="<%=classId%>" size="33"  maxlength="50">
               </TD>
            </TR>

            <input  type="HIDDEN" name="classId" value="<%=classId%>">
            
          
          
         </TABLE>
      </FORM>
   </BODY>
</HTML>     
                    