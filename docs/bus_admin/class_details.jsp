<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
  
<HTML>

<%
    WebBusinessObject classItem = (WebBusinessObject) request.getAttribute("classItem");
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    TouristGuide tGuide = new TouristGuide("/com/silkworm/international/BasicForms");
%>
   <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
   <MEeTA HTTP-EQUIV="Expires" CONTENT="0">

   <HEAD>
      <TITLE>Document Viewer - Classification Details</TITLE>
      <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
   </HEAD>

   <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">


   </SCRIPT>

   <BODY>
      <left>
     
        <FORM NAME="ISSUE_FORM" METHOD="POST">
         <TABLE WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
	    <TR VALIGN="MIDDLE">
               <TD COLSPAN="2" CLASS="tabletitle" STYLE="border-left-WIDTH: 1;text-align:left;">
                  <%=tGuide.getMessage("viewbusinessclass")%>
               </TD>
               <TD CLASS="tabletitle" STYLE="">
                  <IMG WIDTH="20" HEIGHT="20" SRC="images/corner.gif">
               </TD>
               <TD CLASS="tableright" colspan="3">
                  <IMG VALIGN="BOTTOM"   SRC="images/arrow_left_red.gif">
                  <A HREF="<%=context%>/ClassServlet?op=ListAll">
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

   </table> 

         <TABLE CELLPADDING="0" CELLSPACING="0" BORDER="0">
            
        
            
              <TR>
               <TD class='td'>
                  <LABEL FOR="ISSUE_TITLE">
                       <p><b><%=tGuide.getMessage("classtitle")%>:</b>&nbsp;
                    </LABEL>
               </TD>
               <TD class='td'>
                 <input disabled type="TEXT" name="classTitle" value="<%=classItem.getAttribute("classTitle")%>" ID="classTitle" size="33"  maxlength="50">
               </TD>
            </TR>

            
            <TR>
               <TD class='td'>
                  <LABEL FOR="str_Function_Desc">
                       <p><b><%=tGuide.getMessage("classdescription")%>:</b>&nbsp;
                    </LABEL>
               </TD>
               <td class='td'>
                <DIV class="textview">
                 <%=classItem.getAttribute("classDescription")%>
                 </div>
                </td>
             
            </TR>
          
         </TABLE>
      </FORM>
   </BODY>
</HTML>     
                    