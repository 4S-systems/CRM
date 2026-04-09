<%@ page import="com.silkworm.business_objects.secure_menu.*,com.silkworm.business_objects.*,java.util.*"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<%
HttpSession s = request.getSession();
ServletContext c = s.getServletContext();



TwoDimensionMenu tdm = (TwoDimensionMenu) c.getAttribute("myMenu");
//tdm.applySecurityPolicy("00000111110");
// tdm.printSelf();
ArrayList menuBody = tdm.getContents();

String putImage = null;
String turnOn = null;

  ListIterator li = menuBody.listIterator();
        

%>
<HEAD>
      <TITLE>Main Menu</TITLE>
      <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>
 <SCRIPT LANGUAGE="JavaScript" SRC="Library.js" TYPE="text/javascript">
    </SCRIPT>
<body>
<TABLE WIDTH="600" CELLPADDING="0" CELLSPACING="0">

<TR>
    <TD WIDTH="176" ALIGN="CENTER" ROWSPAN="2" STYLE="BORDER-top:none;BORDER-right:none;BORDER-left:none;BORDER-bottom-WIDTH:2px;">
       <IMG ALIGN="ABSMIDDLE" SRC="images/swlogo.gif">
    </TD>
    <TD COLSPAN="6" CLASS="brand_bar">
      <IMG ALIGN="ABSMIDDLE" SRC="images/emerald_logo.gif">
      <IMG SRC="images/corner.gif">
    </TD>
  </TR>

  
  <TR>
<%
 OneDimensionMenu hmOption = null;
 WebBusinessObject hmRenderer = null;
        while(li.hasNext()) {
            hmOption = (OneDimensionMenu) li.next();
            hmRenderer = hmOption.getMenuInfo();
       
%>
    
    <TD nowrap CLASS="<%=hmRenderer.getAttribute("class")%>">
      <DIV ID="<%=hmRenderer.getAttribute("divid")%>" onmouseover="<%=hmRenderer.getAttribute("onmouseover")%>" onmouseout="<%=hmRenderer.getAttribute("onmousout")%>">

        <A HREF="<%=hmRenderer.getAttribute("target")%>">
          <%=hmRenderer.getAttribute("name")%> &nbsp;
          <%
            putImage = (String) hmRenderer.getAttribute("length");
            if(!putImage.equals("0"))
            {
                %>
          <IMG SRC="<%=hmRenderer.getAttribute("image")%>">
          <%
            }
          %>
          <SPAN ID="<%=hmRenderer.getAttribute("spanid")%>">
            <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
             
<%
    ArrayList vMenu = hmOption.getContents();
    ListIterator vI = vMenu.listIterator();
    while(vI.hasNext()) {
    WebBusinessObject m = (WebBusinessObject) vI.next();
%>
              <TR>
                <TD CLASS="<%=m.getAttribute("class")%>">
                  <DIV ID="<%=m.getAttribute("divid")%>">
<%
    turnOn = (String) m.getAttribute("turnOn");
    if(turnOn.equals("1"))
    {

%>
  
                    <A HREF="<%=m.getAttribute("target")%>">
<%
   }
    else
    {
 %>
                  <A HREF="<%=m.getAttribute("alttarget")%>">

<%
  }
%>
                      <SPAN ID="<%=m.getAttribute("spanid")%>">
                        <%=m.getAttribute("name")%>
                      <SPAN>
                    </A>
                  </DIV>
                </TD>
              </TR>
              
<%
}

%>            
            
            
             
            </TABLE>
          </SPAN>
        </A>
      </DIV>
    </TD>
<%

}
%>    
  </TR>
</TABLE>
&#1594;&#1610;&#1585; &#1605;&#1587;&#1605;&#1608;&#1581; &#1604;&#1603;  
</body>
</html>
