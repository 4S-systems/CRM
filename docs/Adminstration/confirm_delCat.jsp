<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<HTML>
    
    <%
    String categoryId = (String) request.getAttribute("categoryId");
    String categoryName = (String) request.getAttribute("categoryName");
    
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    CategoryMgr categoryMgr=CategoryMgr.getInstance();
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

    
String cMode= (String) request.getSession().getAttribute("currentMode");
    String  stat=cMode;
    String align=null;
    String dir=null;
    String style=null;
    String lang,langCode;
    
    String saving_status;
    String title_1,title_2;
    String cat_name,cat_desc;
    String cancel_button_label;
    String save_button_label;
    if(stat.equals("En")){

        saving_status="Saving status";
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        
        cat_name="Category name";
        cat_desc="Category description";
        title_1="Category view";
        title_2="All information are needed";
        cancel_button_label=" Back To List ";
        save_button_label="Delete ";
        langCode="Ar";
    }else{

        saving_status="&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        
        
     
        cat_name="&#1573;&#1587;&#1605; &#1575;&#1604;&#1589;&#1606;&#1601;";
        cat_desc="&#1608;&#1589;&#1601; &#1575;&#1604;&#1589;&#1606;&#1601;";
        title_1="  &#1581;&#1584;&#1601; &#1575;&#1604;&#1589;&#1606;&#1601; - &#1607;&#1604; &#1571;&#1606;&#1578; &#1605;&#1578;&#1571;&#1603;&#1583;&#1567;";
        title_2="&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
        cancel_button_label=" &#1593;&#1608;&#1583;&#1607; &#1575;&#1604;&#1610; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1607; ";
        save_button_label=" &#1581;&#1584;&#1601; ";
        langCode="En";
    }
    

    %>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <MEeTA HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>Document Viewer - Confirm Deletion</TITLE>
 <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css"><LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
    </HEAD>
    
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

   function submitForm()
   {    
      document.TECH_DEL_FORM.action = "<%=context%>/ItemsServlet?op=Delete&categoryId=<%=categoryId%>&categoryName=<%=categoryName%>";
      document.TECH_DEL_FORM.submit();  
   }
   function cancelForm()
        {    
        document.TECH_DEL_FORM.action = "<%=context%>//ItemsServlet?op=ListCategory";
        document.TECH_DEL_FORM.submit();  
        }
    </SCRIPT>
    <script src='ChangeLang.js' type='text/javascript'></script>
    <BODY>
        
        
        <FORM NAME="TECH_DEL_FORM" METHOD="POST">
            
            <DIV align="left" STYLE="color:blue;">
            <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
             <button  onclick="JavaScript:  submitForm();" class="button"><%=save_button_label%><IMG VALIGN="BOTTOM"   SRC="images/del.gif"></button>
             <button  onclick="JavaScript: cancelForm();" class="button"><%=cancel_button_label%><IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif"> </button>
      
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
            <TABLE align="<%=align%>" dir=<%=dir%> CELLPADDING="0" CELLSPACING="0" BORDER="0">
                
                
                
                <TR>
                    <TD STYLE="<%=style%>" class='td'>
                        <LABEL FOR="ISSUE_TITLE">
                            <p><b><%=cat_name%><font color="#FF0000"> </font></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="<%=style%>" class='td'>
                        <input disabled type="TEXT" name="categoryName" value="<%=categoryName%>" ID="<%=categoryName%>" size="33"  maxlength="50">
                    </TD>
                </TR>
                
                <input  type="HIDDEN" name="techId" value="<%=categoryId%>">
                
                
                
            </TABLE>
            <br><br>
        </FORM>
    </BODY>
</HTML>     
