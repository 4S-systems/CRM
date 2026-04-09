<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<HTML>
   <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
   <META HTTP-EQUIV="Expires" CONTENT="0">
   <HEAD>
      <TITLE>System Users List</TITLE>
      <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css"><LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
   </HEAD>
<%
   
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();

   AppConstants appCons = new AppConstants();
   
   String[] userAttributes = appCons.getCurrentUserAttributes();
   String[] currentUsersListTitles ={"User name","User id", "Enter time","Enter id","Enter address"};//=appCons.getConcurrentUsersHeaders();
   
   int s = userAttributes.length;
  

   String attName = null;
   String attValue = null;
   String cellBgColor = null;

 

   Vector  usersList = (Vector) request.getAttribute("data");
  
 
  WebBusinessObject wbo = null;
  int flipper = 0;
  String bgColor = null;
  
   TouristGuide tGuide = new TouristGuide("/com/docviewer/international/BasicOps");
   TouristGuide sysAdminMenuGuide = new TouristGuide("/com/silkworm/international/SysAdminMenu");
   
   
String cMode= (String) request.getSession().getAttribute("currentMode");
    String  stat=cMode;
    String align=null;
    String dir=null;
    String style=null;
    String lang,langCode;
    
    String saving_status;
    String title_1,title_2;
    String cancel_url=context+"/main.jsp";
    String update_url=context+"/ListerServlet?op=ListAllUsers";
    String cancel_button_label;
    String save_button_label;
    if(stat.equals("En")){

        saving_status="Saving status";
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        
        title_1="Current users";
        title_2="All information are needed";
        cancel_button_label="Cancel ";
        save_button_label="Refresh ";
        langCode="Ar";
    }else{

        saving_status="&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        
        
      String x[]={"&#1575;&#1587;&#1605; &#1575;&#1604;&#1605;&#1587;&#1578;&#1582;&#1583;&#1605;","&#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1587;&#1578;&#1582;&#1583;&#1605;", "&#1608;&#1602;&#1578; &#1575;&#1604;&#1583;&#1582;&#1608;&#1604;","&#1585;&#1602;&#1605; &#1575;&#1604;&#1583;&#1582;&#1608;&#1604;","&#1593;&#1606;&#1608;&#1575;&#1606; &#1575;&#1604;&#1583;&#1582;&#1608;&#1604;"};
        currentUsersListTitles = x;
        
        title_1=" &#1575;&#1604;&#1605;&#1587;&#1578;&#1582;&#1583;&#1605;&#1610;&#1606; &#1575;&#1604;&#1581;&#1575;&#1604;&#1610;&#1610;&#1606; &#1604;&#1604;&#1606;&#1592;&#1575;&#1605;";
        title_2="&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
        cancel_button_label="&#1573;&#1606;&#1607;&#1575;&#1569; ";
        save_button_label=" &#1578;&#1581;&#1583;&#1610;&#1579; &#1575;&#1604;&#1605;&#1578;&#1575;&#1576;&#1593;";
        langCode="En";
    }
    
%>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
            function changePage(url){
                window.navigate(url);
            }
            function update()
            {
                
            }
</script>
<script src='ChangeLang.js' type='text/javascript'></script>
<body>
  
             <DIV align="left" STYLE="color:blue;">
            <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
            <button  onclick="JavaScript: changePage('<%=context%>/main.jsp');" class="button"><%=cancel_button_label%><IMG VALIGN="BOTTOM"   SRC="images/cancel.gif"> </button>
            <button  onclick="JavaScript:  changePage('<%=context%>/ListerServlet?op=ListAllUsers');" class="button"><%=save_button_label%><IMG HEIGHT="15" SRC="images/save.gif"></button>
              </DIV> 
             <fieldset class="set" align="center">
                <legend align="center">
                    <table align="<%=align%>" dir=<%=dir%>>
                        <tr>
                            
                            <td class="td">
                                <font color="blue" size="6">    <%=title_1%>                
                                </font>
                                
                            </td>
                        </tr>
                    </table>
                </legend>
          
  
<br><br>

<TABLE align="<%=align%>" dir=<%=dir%> WIDTH="400" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
                  <TR CLASS="head" STYLE="background-color:#9B9B00;">
                <%
                 for(int i = 0;i<s;i++)
                 {
                      
                     
               %>
              
                  <TD dir=<%=dir%> nowrap CLASS="firstname" WIDTH="150" STYLE=" border-top-WIDTH:0; font-size:12;color:white;" nowrap>
                      <B><%=currentUsersListTitles[i]%></B>
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

   <TR BGCOLOR="#DDDD00">
              <%
                 for(int i = 0;i<s;i++)
                 {
                       attName = userAttributes[i];
                       attValue = (String) wbo.getAttribute(attName);
              %>

                  <TD  STYLE="<%=style%>" nowrap  CLASS="cell" >
                     <DIV >
                    
                        <b> <%=attValue%> </b>
                     </DIV>
                  </TD>
                <%
                  }
                %>
                    
                  
                       
             

           
               </TR>
             
            
               <%
                
                 }
                
               %> 

</table>
<br><br><br>



</body>
</html>
