<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,com.contractor.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    <HEAD>
        <TITLE>System Projects List</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>
    <%
    
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    
    MaintainableMgr maintainableMgr=MaintainableMgr.getInstance();
    TaskMgr taskMgr=TaskMgr.getInstance();
    
    //AppConstants appCons = new AppConstants();
    
    String[] categoryAttributes = {"unitName"};
    String[] categoryListTitles = {"Category Name", "Total Tasks", "View Tasks"};
    
    int s = categoryAttributes.length;
    int t = s+2;
    int iTotal = 0;
    
    String attName = null;
    String attValue = null;
    String cellBgColor = null;
    
    
    
    Vector  categoryList = (Vector) request.getAttribute("data");
    
    
    WebBusinessObject wbo = null;
    int flipper = 0;
    String bgColor = null;
    String bgColorm = null;
    
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
    
    String categoryId=null;
    String Total =null;
    
    String cMode= (String) request.getSession().getAttribute("currentMode");
    String  stat=cMode;
    String align=null;
    String dir=null;
    String style=null;
    String lang,langCode,listCat,noParCat,noEqCat,viewEq,Quick,Basic,noTask,viewTasks
            ;
    if(stat.equals("En")){
        
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        langCode="Ar";
        viewEq="View Equipment";
        listCat="List Category To Tasks";
        noParCat="No Parts Under That Category";
        noEqCat="No Equipment Under That Category";
        Quick="Quick Summary";
        Basic="Basic Oprations";
        noTask = "No Tasks Under That Category";
        viewTasks= "View Tasks";
        
    }else{
        
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        langCode="En";
        viewEq="&#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1575;&#1604;&#1605;&#1575;&#1603;&#1610;&#1606;&#1607;";
        listCat="&#1593;&#1585;&#1590; &#1575;&#1604;&#1575;&#1589;&#1606;&#1575;&#1601; &#1604;&#1576;&#1606;&#1608;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
        noParCat=" &#1604;&#1575; &#1610;&#1608;&#1580;&#1583; &#1602;&#1591;&#1593; &#1578;&#1581;&#1578; &#1607;&#1584;&#1575; &#1575;&#1604;&#1589;&#1606;&#1601;";
        noEqCat=" &#1604;&#1575; &#1610;&#1608;&#1580;&#1583; &#1605;&#1575;&#1603;&#1610;&#1606;&#1575;&#1578; &#1604;&#1607;&#1584;&#1575; &#1575;&#1604;&#1589;&#1606;&#1601;";
        String[] categoryListTitlesAr = {"&#1573;&#1587;&#1605; &#1575;&#1604;&#1589;&#1606;&#1601;", "&#1593;&#1583;&#1583; &#1576;&#1606;&#1608;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;", "&#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1576;&#1606;&#1608;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;"};
        categoryListTitles=categoryListTitlesAr;
        Quick="&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1587;&#1585;&#1610;&#1593;&#1577;";
        Basic="&#1593;&#1605;&#1604;&#1610;&#1575;&#1578; &#1571;&#1587;&#1575;&#1587;&#1610;&#1577;";
        noTask = "&#1604;&#1575; &#1610;&#1608;&#1580;&#1583; &#1576;&#1606;&#1608;&#1583; &#1589;&#1610;&#1575;&#1606;&#1577; &#1578;&#1581;&#1578; &#1578;&#1604;&#1603; &#1575;&#1604;&#1589;&#1606;&#1601;";
        viewTasks ="&#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1576;&#1606;&#1608;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
        }
    
    %>
    <script src='ChangeLang.js' type='text/javascript'></script>
    <LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
    <body>
        <DIV align="left" STYLE="color:blue;">
            <input type="button" value="<%=lang%>"
                   onclick="reloadAE('<%=langCode%>')" class="button">
        </DIV>  
        
        <fieldset align="center" class="set" >
            <legend align="center">
                <table dir="rtl" align="center">
                    <tr>
                        
                        <td class="td">
                            <font color="blue" size="6">    <%=listCat%>          
                            </font>
                            
                        </td>
                    </tr>
                </table>
            </legend>
            <br>
            <TABLE ALIGN="CENTER" dir="<%=dir%>" WIDTH="400" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
                
                <TR>
                    <TD class="blueBorder blueHeaderTD" COLSPAN="2" bgcolor="#808000" STYLE="text-align:center;color:white;font-size:18">
                        <B><%=Quick%></B>
                    </TD>
                    <TD class="blueBorder blueHeaderTD" COLSPAN="1" bgcolor="#669900" STYLE="text-align:center;color:white;font-size:18">
                        <B><%=Basic%></B>
                    </TD>
                    
                </TR>
                <TR >
                    <%
                    for(int i = 0;i<t;i++) {
        
        String columnColor="#9B9B00";
        if(i>1)
            columnColor="#7EBB00";
                    %>
                    
                    <TD nowrap CLASS="silver_header" WIDTH="100" STYLE="border-top-WIDTH:0; font-size:12; "  BGCOLOR="<%=columnColor%>">
                        <%=categoryListTitles[i]%>
                    </TD>
                    
                    
                    
                    <%
                    }
                    %>
                </TR>  
                <%
                
                Enumeration e = categoryList.elements();
                
                
                while(e.hasMoreElements()) {
                    iTotal++;
                    wbo = (WebBusinessObject) e.nextElement();
                    
                      flipper++;
                         if((flipper%2) == 1) {
                        bgColor="silver_odd";
                        bgColorm = "silver_odd_main";
                    } else {
                        bgColor= "silver_even";
                         bgColorm = "silver_even_main";
                    }
                    categoryId = (String) wbo.getAttribute("id");
                %>
                
                <TR >
                    <%
                    for(int i = 0;i<s;i++) {
                        attName = categoryAttributes[i];
                        attValue = (String) wbo.getAttribute(attName);
                    %>
                    
                    <TD  STYLE="<%=style%>" nowrap  CLASS="<%=bgColorm%>" BGCOLOR="#DDDD00">
                        <DIV >
                            
                            <b> <%=attValue%> </b>
                        </DIV>
                    </TD>
                    <%
                    }
                    %>
                    
                    <%
                    Total=taskMgr.getTotalTasks(categoryId);
                    if (Total!=null){
                    %>
                    <TD nowrap DIR="ltr" CLASS="<%=bgColor%>" STYLE="padding-left:10;text-align:center;" BGCOLOR="#DDDD00">
                        <DIV ID="links">
                         
                            <%=Total%>
                        </DIV>
                        <%  } else { %>
                        
                        <DIV ID="links">
                           
                            <%=noParCat%>
                        </DIV>
                        <% } %>
                    </TD>
                    
                    <TD nowrap CLASS="<%=bgColor%>" STYLE="padding-left:10;<%=style%>;" BGCOLOR="#D7FF82">
                        <% if(Total.equals("0")) { %>
                        <DIV ID="links">
                          
                            <font color="red"> <b> <%=noTask%> </b></font>
                        </DIV>
                        <% } else {  %>
                        
                        <DIV ID="links">
                            <A HREF="<%=context%>/TaskServlet?op=ViewTasksByCategory&categoryId=<%=wbo.getAttribute("id")%>&categoryName=<%=wbo.getAttribute("unitName")%>">
                                <%=viewTasks%>
                            </A>
                        </DIV>
                        <% } %>
                    </TD>
                
                </TR>
                
                
                <%
                
                }
                
                %>
                
            </table>
            <br><br>
        </fieldset>  
        
        
    </body>
</html>
