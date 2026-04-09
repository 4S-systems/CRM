<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
  
<HTML>

<%
   String placeId = (String) request.getAttribute("placeId");
   String placeName = (String) request.getAttribute("placeName");

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
      document.PLACE_DEL_FORM.action = "<%=context%>/PlaceServlet?op=Delete&placeId=<%=placeId%>&placeName=<%=placeName%>";
      document.PLACE_DEL_FORM.submit();  
   }

   </SCRIPT>

   <BODY>
      <left>
     
        <FORM NAME="PLACE_DEL_FORM" METHOD="POST">
         <TABLE ALIGN="RIGHT" DIR="RTL" WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
         
	    <TR VALIGN="MIDDLE">
               <TD COLSPAN="2" CLASS="tabletitle" STYLE="border-left-WIDTH: 1;text-align:left;">
                  &#1581;&#1584;&#1601; &#1575;&#1604;&#1605;&#1608;&#1602;&#1593; - &#1607;&#1604; &#1571;&#1606;&#1578; &#1605;&#1578;&#1571;&#1603;&#1583; &#1567;
               </TD>
               <TD CLASS="tableright" colspan="3">
                  <IMG VALIGN="BOTTOM"  SRC="images/leftarrow.gif">
                  <A HREF="<%=context%>/PlaceServlet?op=ListPlaces">
                     &#1575;&#1604;&#1593;&#1608;&#1583;&#1607; &#1573;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1607;
                  </A>
                  <IMG VALIGN="BOTTOM" HEIGHT="10" WIDTH="1" SRC="images/line.gif">
                  <A HREF="JavaScript: submitForm();">
                     &#1573;&#1581;&#1584;&#1601; &#1575;&#1604;&#1605;&#1608;&#1602;&#1593;
                  </A>
               </TD>
            </TR>
         </TABLE>

  <TABLE ALIGN="RIGHT"  DIR="RTL" CELLPADDING="0" CELLSPACING="0" BORDER="0">
               <TR>
                  <TD class='td'>
                     &nbsp;
                   </TD>
           </TR>

   </table

       <TABLE ALIGN="RIGHT"  DIR="RTL" CELLPADDING="0" CELLSPACING="0" BORDER="0">
            
              
            
              <TR>
               <TD class='td'>
                  <LABEL FOR="ISSUE_TITLE">
                       <p><b>&#1573;&#1587;&#1605; &#1575;&#1604;&#1605;&#1608;&#1602;&#1593;<font color="#FF0000"> </font></b>&nbsp;
                    </LABEL>
               </TD>
               <TD class='td'>
                 <input disabled type="TEXT" name="placeName" value="<%=placeName%>" ID="<%=placeName%>" size="33"  maxlength="50">
               </TD>
            </TR>

            <input  type="HIDDEN" name="placeId" value="<%=placeId%>">
            
          
          
         </TABLE>
      </FORM>
   </BODY>
</HTML>     
                    