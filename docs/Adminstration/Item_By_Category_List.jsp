<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    <HEAD>
        <TITLE>System Projects List</TITLE>
      <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css"><LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
    </HEAD>
    <%
    
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    
    ItemMgr itemMgr=ItemMgr.getInstance();
    
    //AppConstants appCons = new AppConstants();
    
    String[] categoryAttributes = {"categoryName"};
    String[] categoryListTitles = {"&#1573;&#1587;&#1605; &#1575;&#1604;&#1589;&#1606;&#1601;", "&#1593;&#1583;&#1583; &#1575;&#1604;&#1602;&#1591;&#1593;", "&#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1575;&#1604;&#1602;&#1591;&#1593;"};
    
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
    
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
    
    String categoryId=null;
    String Total =null;

      
String cMode= (String) request.getSession().getAttribute("currentMode");
    String  stat=cMode;
    String align=null;
    String dir=null;
    String style=null;
    String lang,langCode;
    
    String saving_status;
    String title_1,title_2;
    String head_1,head_2,field_1_1;
    String cancel_button_label;
    String save_button_label;
    if(stat.equals("En")){

        saving_status="Saving status";
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        
        head_1="Quick summary";
        head_2="Basic operations";
        categoryListTitles[0]="View parts";
        categoryListTitles[1]="Total parts";
        categoryListTitles[2]="Category name";
        field_1_1="view parts";
        
        title_1="List parts by category";
        title_2="All information are needed";
        cancel_button_label=" cancel ";
        save_button_label="Delete category";
        langCode="Ar";
    }else{

        saving_status="&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        
        head_1="&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1587;&#1585;&#1610;&#1593;&#1577;";
        head_2="&#1593;&#1605;&#1604;&#1610;&#1575;&#1578; &#1571;&#1587;&#1575;&#1587;&#1610;&#1577;";
        
        field_1_1="&#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1575;&#1604;&#1602;&#1591;&#1593;";
     
        
        title_1=" &#1593;&#1585;&#1590; &#1575;&#1604;&#1602;&#1591;&#1593; &#1581;&#1587;&#1576; &#1575;&#1604;&#1589;&#1606;&#1601;";
        title_2="&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
        cancel_button_label="&#1575;&#1604;&#1594;&#1575;&#1569;";
        save_button_label=" &#1581;&#1584;&#1601; &#1575;&#1604;&#1589;&#1606;&#1601;";
        langCode="En";
    }
    

    %>
     <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

    function changePage(url){
                window.navigate(url);
            }
    </SCRIPT>
    <script src='ChangeLang.js' type='text/javascript'></script>
    <body>
        
         <DIV align="left" STYLE="color:blue;">
            <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
            <button  onclick="JavaScript: changePage('<%=context%>/main.jsp');" class="button"><%=cancel_button_label%><IMG VALIGN="BOTTOM"   SRC="images/cancel.gif"> </button>
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
                
            
            
        
        
        
        
        
            <TABLE align="<%=align%>" dir=<%=dir%>  WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
                <!--Th nowrap COLSPAN="2" CLASS="tabletitle" STYLE="border-left-WIDTH: 1;text-align:right;">
                    &#1593;&#1585;&#1590; &#1575;&#1604;&#1571;&#1589;&#1606;&#1575;&#1601;
                </Th-->
                <TR>
                    <TD CLASS="td" COLSPAN="2" bgcolor="#808000" STYLE="text-align:center;color:white;font-size:16">
                        <B><%=head_1%></B>
                    </TD>
                    <TD CLASS="td" COLSPAN="1" bgcolor="#669900" STYLE="text-align:center;color:white;font-size:16">
                        <B><%=head_2%></B>
                    </TD>
                </TR>
                <TR CLASS="head">
                    <%
                    String columnColor = new String("");
                    for(int i = 0;i<t;i++) {
        if(i == 0 || i == 1){
            columnColor = "#9B9B00";
        } else {
            columnColor = "#7EBB00";
        }
                    
                    %>
                    <TD nowrap CLASS="firstname" WIDTH="33%" bgcolor="<%=columnColor%>" STYLE="text-align:center;border-WIDTH:0; font-size:12;color:white;" nowrap>
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
                        bgColor="#c8d8f8";
                    } else {
                        bgColor="white";
                    }
                    categoryId = (String) wbo.getAttribute("categoryId");
                %>
                <TR>
                    <%
                    for(int i = 0;i<s;i++) {
                        attName = categoryAttributes[i];
                        attValue = (String) wbo.getAttribute(attName);
                    %>
                    <TD  STYLE="text-align:center" nowrap  CLASS="cell" BGCOLOR="#DDDD00">
                        <DIV >
                            <b> <%=attValue%> </b>
                        </DIV>
                    </TD>
                    <%
                    }
                    %>
                    <%
                    Total=itemMgr.getTotalItems(categoryId);
                    if (Total!=null){
                    %>
                    <TD nowrap DIR="LTR" CLASS="cell" BGCOLOR="#DDDD00" STYLE="padding-left:10;text-align:center;">
                        <DIV ID="links">
                            <%=Total%>
                        </DIV>
                        <%  } else { %>
                        <DIV ID="links">
                            &#1604;&#1575;&#1610;&#1608;&#1580;&#1583; &#1602;&#1591;&#1593; &#1578;&#1581;&#1578; &#1607;&#1584;&#1575; &#1575;&#1604;&#1589;&#1606;&#1601;
                        </DIV>
                        <% } %>
                    </TD>
                    
                    <TD nowrap CLASS="cell" STYLE="padding-left:10;text-align:center;" BGCOLOR="#D7FF82">
                        <DIV ID="links">
                            <A HREF="<%=context%>/ItemsServlet?op=ViewItems&categoryId=<%=wbo.getAttribute("categoryId")%>">
                                <%=field_1_1%>
                            </A>
                        </DIV>
                    </TD>
                </TR>
                <%
                }
                %>
            </table>
            <BR>
        </fieldset>
    </body>
</html>
