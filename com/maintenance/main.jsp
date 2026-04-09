<%@ page import="com.silkworm.business_objects.secure_menu.*,com.silkworm.business_objects.*,java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.silkworm.common.*"%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
    <%
 
    response.addHeader("Pragma","No-cache");
    response.addHeader("Cache-Control","no-cache");
    response.addDateHeader("Expires",1);
    
    TouristGuide tGuide = new TouristGuide("/com/silkworm/international/BasicForms");
    
    HttpSession s = request.getSession();
    ServletContext c = s.getServletContext();
    
    WebBusinessObject loggedUser = (WebBusinessObject) s.getAttribute("loggedUser");
    
    String userName = (String) loggedUser.getAttribute("userName");
    String groupName = (String) loggedUser.getAttribute("groupName");
    
    TwoDimensionMenu tdm = (TwoDimensionMenu) c.getAttribute("myMenu");
    //tdm.applySecurityPolicy("00000111110");
    // tdm.printSelf();
    ArrayList menuBody = tdm.getContents();
    
    String putImage = null;
    String turnOn = null;
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    ListIterator li = menuBody.listIterator();
    
    
    %>
    <HEAD>
        <META HTTP-EQUIV="Content-Type" CONTENT="text/html  charset=UTF-8">
        <TITLE>Main Menu</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>
    <SCRIPT LANGUAGE="JavaScript" SRC="Library.js" TYPE="text/javascript"></SCRIPT>
     <SCRIPT LANGUAGE="JavaScript">
        function closeApplication(){
            window.navigate("LogoutServlet");
        }
        
        var myclose = false;

		function ConfirmClose()
		{
			if (event.clientY < 0)
			{
				//event.returnValue = 'Any message you want';

				//setTimeout('myclose=false',100);
				//myclose=true;
                                window.navigate("LogoutServlet");
			}
		}

		function HandleOnClose()
		{
			if (myclose==true) window.navigate("LogoutServlet");
		}
    </SCRIPT>
    <body onbeforeunload="ConfirmClose()" onunload="HandleOnClose()">
        <TABLE WIDTH="600" CELLPADDING="0" CELLSPACING="0" style='z-index:-400'>
              <TR>
                <TD WIDTH="150" ALIGN="CENTER" ROWSPAN="2" STYLE="BORDER-top:none;BORDER-right:none;BORDER-left:none;BORDER-bottom-WIDTH:2px;">
                    <IMG  ALIGN="ABSMIDDLE" SRC="images/4s_logo.jpg" HEIGHT="100">
                </TD>
                <TD COLSPAN="6" CLASS="brand_bar">
                    <IMG width='700' height='100' ALIGN="ABSMIDDLE" SRC="images/pic_menu1.jpg">
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
                            if(!putImage.equals("0")) {
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
                                                if(turnOn.equals("1")) {
                                                
                                                %>
                                                
                                                <A HREF="<%=m.getAttribute("target")%>">
                                                <%
                                                } else {
                                                %>
                                                <A HREF="<%=m.getAttribute("alttarget")%>">
                                                    
                                                    <%
                                                    }
                                                    %>
                                                    <SPAN ID="<%=m.getAttribute("spanid")%>">
                                                    <%
                                                    turnOn = (String) m.getAttribute("turnOn");
                                                    if(turnOn.equals("1")) {
                                                    
                                                    %>
                                                    <IMG SRC="images/<%=m.getAttribute("sora")%>">
                                                    <%
                                                    } else {
                                                    %>
                                                    <IMG SRC="images/stop.gif">
                                                    <%
                                                    }
                                                    %>
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
            
            
            <TR CLASS="head">
                
                
                <TD  nowrap CLASS="firstname"  STYLE="border-top-WIDTH:0; font-size:12" >
                    <%=tGuide.getMessage("user")%>: <%=userName%> - <%=tGuide.getMessage("group")%>: <%=groupName%>  
                </TD>
                
            </TR>  
        
        
        
      
            
        
        
        
        </TABLE>
        <% 
        String page2 = (String) request.getAttribute("page");
        if(null==page2) {
            page2 = new String("manager_agenda.jsp");
        }
        %>
        <jsp:include page="<%=page2%>" flush="true"/> 
    </body>
</html>
