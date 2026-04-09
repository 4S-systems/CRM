<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="com.tracker.engine.IssueStatusFactory"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  

<HTML>
  <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
   <META HTTP-EQUIV="Expires" CONTENT="0">

   <HEAD>
      <TITLE>Worker List Issues</TITLE>
      <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
   </HEAD>

  <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
    <!-- Begin hiding Javascript
     function submitForm()
      {
    
      document.ISSUE_LISTING_FORM.action = "/Tracker/SearchServlet?op=ListResult";
      document.ISSUE_LISTING_FORM.submit();  
   }
      
-->
</script>
  <%
   WebIssue webIssue = null;
   String workerName = (String) request.getParameter("workerName");
  
  %>
<BODY>
      <left>
      
<FORM NAME="WORKER_ISSUES_LISTING_FORM" METHOD="POST">

   <TABLE  stylel="position:absolute;top:400px;left:30px;border-right-WIDTH:1px"  WIDTH="400" CELLPADDING="0" CELLSPACING="0">


                               
                  <TD nowrap COLSPAN="2" CLASS="tabletitle" STYLE="border-left-WIDTH: 1;text-align:left;">
                    Worker Schedules
                  </TD>
                  <TD CLASS="tabletitle" STYLE="">
                     <IMG WIDTH="20" HEIGHT="20" SRC="images/corner.gif">
                  </TD>

                  
               </TR>
   </TABLE>


   <TABLE WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
         <TR CLASS="head">                      
             <TD nowrap CLASS="firstname" WIDTH="100" STYLE="border-top-WIDTH:0; font-size:12" nowrap>
             Schedule Title
             </TD>
             <TD nowrap CLASS="firstname" WIDTH="100" STYLE="border-top-WIDTH:0; font-size:12" nowrap>
               From Date 
             </TD>              
             <TD nowrap CLASS="firstname" WIDTH="100" STYLE="border-top-WIDTH:0; font-size:12" nowrap>
                To Date
             </TD>
             <TD nowrap CLASS="firstname" WIDTH="100" STYLE="border-top-WIDTH:0; font-size:12" nowrap>
              Assigned Time
             </TD>
             <TD nowrap CLASS="firstname" WIDTH="100" STYLE="border-top-WIDTH:0; font-size:12" nowrap>
               Actual_finishTime
             </TD>
             <TD nowrap CLASS="firstname" WIDTH="100" STYLE="border-top-WIDTH:0; font-size:12" nowrap>
               <%=workerName%>
             </TD>
            </TR>  
  
</TABLE>


</FORM>
</body>
</html>