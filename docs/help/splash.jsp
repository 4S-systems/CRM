<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>


<%//???@ page errorPage="ErrorPage.jsp" isErrorPage="false"%>


<HTML>
<%
  

     MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();

    TouristGuide tGuide = new TouristGuide("/com/docviewer/international/ProductFeatures");
  
%>
  <style>
      td1
      {
        
	border: none;
	padding: 3px;
	height: 30px;
	text-align: left;
	vertical-align: middle;
      }
     
   </style> 
<TABLE ALIGN="CENTER" CELLPADDING="0" CELLSPACING="0" BORDER="0">
             
               <TR>
                  <TD1>
                     &nbsp;
                  </TD1>
                  <TD1>
                     &nbsp;
                  </TD1>
               </TR>
    </Table>  



   <TABLE WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
	    <TR VALIGN="MIDDLE">
               <TD COLSPAN="2" CLASS="tabletitle" STYLE="border-left-WIDTH: 1;text-align:left;">
                  <%=tGuide.getMessage("title")%>
               </TD>
               <TD CLASS="tabletitle" STYLE="">
                  <IMG WIDTH="20" HEIGHT="20" SRC="images/corner.gif">
               </TD>
               <TD CLASS="tableright" colspan="3">
                  <IMG VALIGN="BOTTOM"  SRC="images/leftarrow.gif">
                  <A HREF="<%=context%>/main.jsp">
                     <%=tGuide.getMessage("done")%>
                  </A>
                 
               </TD>
            </TR>
         </TABLE>
  <TABLE ALIGN="CENTER" CELLPADDING="0" CELLSPACING="0" BORDER="0">
             
               <TR>
                  <TD1>
                     &nbsp;
                  </TD1>
                  <TD1>
                     &nbsp;
                  </TD1>
               </TR>
    </Table>  


                 <%=tGuide.getMessage("intro0")%> <I><b><%=tGuide.getMessage("intro1")%> </B></I><b><font color="#FF0000"><%=tGuide.getMessage("intro2")%></font></b>  <%=tGuide.getMessage("intro3")%> <b><I><br><%=tGuide.getMessage("intro4")%></I></B> &nbsp;<%=tGuide.getMessage("intro5")%><br>
            
            <%=tGuide.getMessage("intro6")%><br>
 

   <BODY ONLOAD="">
      <LEFT>
        <TABLE ALIGN="LEFT" WIDTH=1000 CELLPADDING="0" CELLSPACING="0" BORDER="1">

<%
            Integer e = null;
            for(int i = 0;i<11;i++)
            {
             e = new Integer(i);
            
%>
             <TR>
                  <TD1>
                     &nbsp;
                  </TD1>
                  <TD1>
                     &nbsp;
                  </TD1>
               </TR>
            
                <TR>
                
                    <TD1 nowrap border=0>
                        <IMG SRC="images/other.gif">  &nbsp; &nbsp;

                      
                         <%=tGuide.getMessage(e.toString())%>
                
                      
                    </TD1>
          </tr>
<%

            }
%>
             
             
    </Table> 
 
  
      </LEFT>

<table>    
  
  </table> 
  
   </BODY>
</HTML>

