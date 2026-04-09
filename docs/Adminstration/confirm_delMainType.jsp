<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
  
<HTML>

<%
   String typeId = (String) request.getAttribute("typeId");
   String MainType = (String) request.getAttribute("MainType");
    String categoryId = (String) request.getAttribute("categoryId");
    

    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    FailureCodeMgr failureCodeMgr=FailureCodeMgr.getInstance();
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
      document.TECH_DEL_FORM.action = "<%=context%>/EquipMaintenanceTypeServlet?op=Delete&typeId=<%=typeId%>&MainType=<%=MainType%>&categoryId=<%=categoryId%>";
      document.TECH_DEL_FORM.submit();  
   }
  
   </SCRIPT>

   <BODY>
      <left>
     
        <FORM NAME="TECH_DEL_FORM" METHOD="POST">
            
        
         <TABLE WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
         
	    <TR VALIGN="MIDDLE">
               <TD COLSPAN="2" CLASS="tabletitle" STYLE="border-left-WIDTH: 1;text-align:left;">
                  Delete this Maintenance Type - <%=tGuide.getMessage("areyousure")%>
               </TD>
               <TD CLASS="tabletitle" STYLE="">
                  <IMG WIDTH="20" HEIGHT="20" SRC="images/corner.gif">
               </TD>
               <TD CLASS="tableright" colspan="3">
                  <IMG VALIGN="BOTTOM"  SRC="images/leftarrow.gif">
                  <A HREF="<%=context%>//EquipMaintenanceTypeServlet?op=ListMainType">
                     <%=tGuide.getMessage("backtolist")%>
                  </A>
                  <IMG VALIGN="BOTTOM" HEIGHT="10" WIDTH="1" SRC="images/line.gif">
                  <A HREF="JavaScript: submitForm();">
                     Delete Maintenance Type
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
                       <p><b>Maintenance Type : <font color="#FF0000"> </font></b>&nbsp;
                    </LABEL>
               </TD>
               <TD class='td'>
                 <input disabled type="TEXT" name="typeName" value="<%=MainType%>" ID="<%=MainType%>" size="33"  maxlength="50">
               </TD>
            </TR>

            <input  type="HIDDEN" name="typeId" value="<%=typeId%>">
            
          
          
         </TABLE>
      </FORM>
   </BODY>
</HTML>     
                    