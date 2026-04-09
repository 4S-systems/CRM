<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
  
<%


    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();

    String status = (String) request.getAttribute("status");

    WebBusinessObject issue = (WebBusinessObject) request.getAttribute("issue");
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
      document.ISSUW_TYPE_FORM.action = "<%=context%>/IssueTypeServlet?op=UpdateIssueType";
      document.ISSUW_TYPE_FORM.submit();  
   }

   </SCRIPT>

   <BODY>
      <left>
      <FORM NAME="ISSUW_TYPE_FORM" METHOD="POST">
         <TABLE WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="right-WIDTH:1px;">
	    <TR VALIGN="MIDDLE">
               <TD COLSPAN="2" CLASS="tabletitle" STYLE="border-left-WIDTH: 1;text-align:left;">
                   <%=tGuide.getMessage("updateexistingissuetype")%> 
               </TD>
               <TD CLASS="tabletitle" STYLE="">
                  <IMG WIDTH="20" HEIGHT="20" SRC="images/corner.gif">
               </TD>
               <TD CLASS="tableright" colspan="3">
                
                     <IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif">
                  <A HREF="<%=context%>/IssueTypeServlet?op=ListIssueTypes">
                     <%=tGuide.getMessage("backtolist")%> 
                  </A>
                  <IMG VALIGN="BOTTOM" HEIGHT="10" WIDTH="1" SRC="images/line.gif">
                  <A HREF="JavaScript: submitForm();">
                     <%=tGuide.getMessage("updateissuetype")%> 
                  </A>
               </TD>
            </TR>
         </TABLE>
<%
    if(null!=status)
    {

%>

  <h3>   <%=tGuide.getMessage("issuetypeupdatestatus")%> : <font color="#FF0000"><%=status%></font> </h3>
           
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
                       <p><b><%=tGuide.getMessage("issuetypename")%>:</b>&nbsp;
                    </LABEL>
               </TD>
               <TD class='td'>
                 <input disabled type="TEXT" name="issueName" ID="issueName" size="33" value="<%=issue.getAttribute("issueName")%>" maxlength="255">
               </TD>
            </TR>
          
            <TR>
               <TD class='td'>
                  <LABEL FOR="str_Function_Desc">
                       <p><b><%=tGuide.getMessage("issuetypedesc")%>:</b>&nbsp;
                    </LABEL>
               </TD>
               <TD class='td'>
                 <input type="TEXT" name="issueDesc" ID="issueDesc" size="33" value="<%=issue.getAttribute("issueDesc")%>" maxlength="255">
               </TD>
            </TR>
         </TABLE>
         <input type="hidden" name="issueName" ID="issueName" value="<%=issue.getAttribute("issueName")%>">
      </FORM>
   </BODY>
</HTML>     
                    