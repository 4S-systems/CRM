<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%> 
  
<%
    String status = (String) request.getAttribute("status");
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();

    TouristGuide tGuide = new TouristGuide("/com/silkworm/international/BasicForms");

%> 
<HTML>
   <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
   <META HTTP-EQUIV="Expires" CONTENT="0">

   <HEAD>
      <TITLE>Doc Depot - New Classification</TITLE>
      <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
   </HEAD>

   <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

   function submitForm()
   {    
      document.FUNCTION_FORM.action = "<%=context%>/ClassServlet?op=SaveClass";
      document.FUNCTION_FORM.submit();  
   }

   </SCRIPT>

   <BODY>
      <left>
      <FORM NAME="FUNCTION_FORM" METHOD="POST">
         <TABLE WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="right-WIDTH:1px;">
	    <TR VALIGN="MIDDLE">
               <TD COLSPAN="2" CLASS="tabletitle" STYLE="left-WIDTH: 1;text-align:left;">
                  <%=tGuide.getMessage("addclass")%>
               </TD>
               <TD CLASS="tabletitle" STYLE="">
                  <IMG WIDTH="20" HEIGHT="20" SRC="images/corner.gif">
               </TD>
               <TD CLASS="tableright" colspan="3">
                 
                  <A HREF="<%=context%>/main.jsp">
                     <%=tGuide.getMessage("cancel")%>
                  </A>
                  <IMG VALIGN="BOTTOM" HEIGHT="10" WIDTH="1" SRC="images/line.gif">
                  <A HREF="JavaScript: submitForm();">
                      <%=tGuide.getMessage("saveclass")%>
                  </A>
               </TD>
            </TR>
         </TABLE>

<%
    if(null!=status)
    {

%>

  <h3>    <%=tGuide.getMessage("classsavestatus")%>: <font color="#FF0000"><%=status%> </font></h3>

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
                       <p><b> <%=tGuide.getMessage("classname")%>: </b>&nbsp;
                    </LABEL>
               </TD>
               <TD class='td'>
                 <input type="TEXT" name="classTitle" ID="functionName" size="33" value="" maxlength="255">
               </TD>
            </TR>
          
            <TR>
               <TD class='td'>
                  <LABEL FOR="str_Function_Desc">
                       <p><b> <%=tGuide.getMessage("classdescription")%>: </b>&nbsp;
                    </LABEL>
               </TD>
               <TD class='td'>
                 <TEXTAREA rows="5" name="classDescription" cols="25"></TEXTAREA>
               </TD>
            </TR>
         </TABLE>
      </FORM>
   </BODY>
</HTML>     
                    