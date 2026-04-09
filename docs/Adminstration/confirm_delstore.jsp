<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.tracker.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<HTML>
    
    <%
    String storeID = (String) request.getAttribute("storeID");
    String storeName = (String) request.getAttribute("storeName");
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
    
    
    String cMode= (String) request.getSession().getAttribute("currentMode");
    String  stat=cMode;
    String align=null;
    String dir=null;
    String style=null;
    String lang,langCode;
    
    String saving_status;
    String store_number, store_name, store_location, store_manager, store_phone;
    String title_1,title_2;
    String cancel_button_label;
    String save_button_label;
    if(stat.equals("En")){
        
        saving_status="Saving status";
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        
        store_number="Store number";
        store_name="Store name";
        store_location="Store location";
        store_manager="Responsible manager";
        store_phone="Phone";
        
        
        title_1="Delete Store - Are You Sure ?";
        title_2="All information are needed";
        cancel_button_label="Back To List ";
        save_button_label="Delete ";
        langCode="Ar";
    }else{
        
        saving_status="&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        
        store_number="&#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1582;&#1586;&#1606;";
        store_name="&#1573;&#1587;&#1605; &#1575;&#1604;&#1605;&#1582;&#1586;&#1606;";
        store_location="&#1575;&#1604;&#1605;&#1608;&#1602;&#1593;";
        store_manager="&#1575;&#1604;&#1605;&#1583;&#1610;&#1585; &#1575;&#1604;&#1605;&#1587;&#1574;&#1608;&#1604;";
        store_phone="&#1578;&#1604;&#1610;&#1601;&#1608;&#1606;";
        
        
        title_1="&#1581;&#1584;&#1601; &#1575;&#1604;&#1605;&#1582;&#1586;&#1606; - &#1607;&#1604; &#1571;&#1606;&#1578; &#1605;&#1578;&#1571;&#1603;&#1583;&#1567;";
        title_2="&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
        cancel_button_label="&#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1573;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577; ";
        save_button_label="&#1573;&#1581;&#1584;&#1601; ";
        langCode="En";
    }
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
      document.PROJECT_DEL_FORM.action = "<%=context%>/StoreServlet?op=DeleteStore&storeID=<%=storeID%>&storeName=<%=storeName%>";
      document.PROJECT_DEL_FORM.submit();  
   }

     function cancelForm()
        {    
        document.PROJECT_DEL_FORM.action = "<%=context%>/StoreServlet?op=ListStores";
        document.PROJECT_DEL_FORM.submit();  
        }
    </SCRIPT>
    <script src='ChangeLang.js' type='text/javascript'></script>
    <BODY>
       <FORM NAME="PROJECT_DEL_FORM" METHOD="POST">
           
           <DIV align="left" STYLE="color:blue;">
                <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
                <button  onclick="JavaScript: cancelForm();" class="button"><%=cancel_button_label%><IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif"> </button>
                <button  onclick="JavaScript:  submitForm();" class="button"><%=save_button_label%><IMG HEIGHT="15" SRC="images/del.gif"></button>
            </DIV> 
            <fieldset class="set" align="center">
            <legend align="center">
                <table dir="<%=dir%>" align="<%=align%>">
                    <tr>
                        
                        <td class="td">
                            <font color="blue" size="6"><%=title_1%>                
                            </font>
                            
                        </td>
                    </tr>
                </table>
            </legend>  
            
            <br><br>
            
            
            <TABLE ALIGN=<%=align%> DIR=<%=dir%> CELLPADDING="0" CELLSPACING="0" BORDER="0">
                
                <TR>
                    <TD STYLE="<%=style%>" class='td'>
                        <LABEL FOR="storeName">
                            <p><b><%=store_name%><font color="#FF0000"></font></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="<%=style%>" class='td'>
                        <input disabled type="TEXT" name="storeName" value="<%=storeName%>" ID="<%=storeName%>" size="33"  maxlength="50">
                    </TD>
                </TR>
                
                <input  type="HIDDEN" name="storeID" value="<%=storeID%>">
                
            </TABLE>
        </FORM>
        <br>
        </fieldset>
    </BODY>
</HTML>     
