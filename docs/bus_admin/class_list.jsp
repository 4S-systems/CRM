<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<HTML>
   <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
   <META HTTP-EQUIV="Expires" CONTENT="0">
   <HEAD>
       <META HTTP-EQUIV="Content-Type" CONTENT="text/html">
      <TITLE>System Users List</TITLE>
      <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
   </HEAD>
<%

 MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
   AppConstants appCons = new AppConstants();
   
   String[] classAttributes = appCons.getClassAttributes();
   String[] classListTitles = appCons.getClassHeaders();
   
   int s = classAttributes.length;
   int t = s+2;

   String attName = null;
   String attValue = null;
   String cellBgColor = null;

 

   Vector  usersList = (Vector) request.getAttribute("data");
  
 
  WebBusinessObject wbo = null;
  int flipper = 0;
  String bgColor = null;

  TouristGuide tGuide = new TouristGuide("/com/docviewer/international/BasicOps");

%>

<body>


   <TABLE CELLPADDING="0" CELLSPACING="0" BORDER="0">
               <TR>
                  <TD class='td'>
                     &nbsp;
                   </TD>
           </TR>

   </table> 

  <TABLE  stylel="position:absolute;top:400px;left:30px;border-right-WIDTH:1px"  WIDTH="250" CELLPADDING="0" CELLSPACING="0">


                               
                  <TD nowrap COLSPAN="2" CLASS="tabletitle" STYLE="border-left-WIDTH: 1;text-align:left;">
                    <%=tGuide.getMessage("businessclasslist")%> 
                  </TD>
                  <TD CLASS="tabletitle" STYLE="">
                     <IMG WIDTH="20" HEIGHT="20" SRC="images/corner.gif">
                  </TD>

                  
               </TR>
   </TABLE>


<TABLE WIDTH="400" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
                  <TR CLASS="head">
                <%
                 for(int i = 0;i<t;i++)
                 {
                      
                     
               %>
              
                  <TD nowrap CLASS="firstname" WIDTH="100" STYLE="border-top-WIDTH:0; font-size:12" nowrap>
                      <%=classListTitles[i]%>
                  </TD>
                 
                    
           
           <%
             }
           %>
            </TR>  
<%
                
          Enumeration e = usersList.elements();
      

           while(e.hasMoreElements())
            {
              wbo = (WebBusinessObject) e.nextElement();
             
              flipper++;
               if((flipper%2) == 1)
             {
              bgColor="#c8d8f8";
             }
            else
             {
              bgColor="white";
             }
%>

   <TR bgcolor="<%=bgColor%>">
              <%
                 for(int i = 0;i<s;i++)
                 {
                       attName = classAttributes[i];
                       attValue = (String) wbo.getAttribute(attName);
              %>

                  <TD  nowrap  CLASS="cell" >
                     <DIV >
                    
                        <b> <%=attValue%> </b>
                     </DIV>
                  </TD>
                <%
                  }
                %>

                 <TD nowrap CLASS="cell" STYLE="padding-left:10;text-align:left;">
                    <DIV ID="links">
                     <A HREF="<%=context%>/ClassServlet?op=ViewDetails&classId=<%=wbo.getAttribute("classTitle")%>">
                        <%=tGuide.getMessage("viewdetails")%>
                     </A>
                     </DIV>
                     </TD>


                     <TD nowrap CLASS="cell" STYLE="padding-left:10;text-align:left;">
                    <DIV ID="links">
                     <A HREF="<%=context%>/ClassServlet?op=ConfirmDelete&classId=<%=wbo.getAttribute("classTitle")%>">
                        <%=tGuide.getMessage("delete")%>
                     </A>
                     </DIV>
                     </TD>
                       
             
               </TR>
             
            
               <%
                
                 }
                
               %> 

</table>




</body>
</html>
