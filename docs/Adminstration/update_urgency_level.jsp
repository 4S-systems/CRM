<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
  
<%


    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();

    String status = (String) request.getAttribute("status");

    WebBusinessObject urgency = (WebBusinessObject) request.getAttribute("urgency");
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
  
%>

<HTML>
   <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
   <META HTTP-EQUIV="Expires" CONTENT="0">

   <HEAD>
      <TITLE>Document Viewer - add new issue type</TITLE>
      <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
   </HEAD>

   <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

   function submitForm()
   {    
      document.URGENCY_FORM.action = "<%=context%>/UrgencyServlet?op=UpdateUrgency";
      document.URGENCY_FORM.submit();  
   }

   </SCRIPT>

   <BODY>
      <left>
      <FORM NAME="URGENCY_FORM" METHOD="POST">
         <TABLE WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="right-WIDTH:1px;">
	    <TR VALIGN="MIDDLE">
               <TD COLSPAN="2" CLASS="tabletitle" STYLE="border-left-WIDTH: 1;text-align:left;">
                   <%=tGuide.getMessage("updateexistingurgency")%> 
               </TD>
               <TD CLASS="tabletitle" STYLE="">
                  <IMG WIDTH="20" HEIGHT="20" SRC="images/corner.gif">
               </TD>
               <TD CLASS="tableright" colspan="3">
                
                     <IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif">
                  <A HREF="<%=context%>/UrgencyServlet?op=ListUrgencyLevels">
                     <%=tGuide.getMessage("backtolist")%> 
                  </A>
                  <IMG VALIGN="BOTTOM" HEIGHT="10" WIDTH="1" SRC="images/line.gif">
                  <A HREF="JavaScript: submitForm();">
                     <%=tGuide.getMessage("updateurgency")%> 
                  </A>
               </TD>
            </TR>
         </TABLE>
<%
    if(null!=status)
    {

%>

  <h3>   <%=tGuide.getMessage("urgencyupdatestatus")%> : <font color="#FF0000"><%=status%></font> </h3>
           
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
                 <input type="TEXT" name="urgencyDesc" ID="urgencyDesc" size="33" value="<%=urgency.getAttribute("urgencyDesc")%>" maxlength="255">
               </TD>
            </TR>
         </TABLE>
         <input type="hidden" name="urgencyName" ID="urgencyName" value="<%=urgency.getAttribute("urgencyName")%>">
      </FORM>
   </BODY>
</HTML>     
                    