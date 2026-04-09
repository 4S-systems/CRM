<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*"%>  
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<%
MetaDataMgr metaMgr = MetaDataMgr.getInstance();
String context = metaMgr.getContext();


String categoryId = (String) request.getAttribute("categoryId");
String pIndex = (String) request.getAttribute("pIndex");

String itemID = (String) request.getAttribute("itemID");

CategoryMgr categoryMgr=CategoryMgr.getInstance();

ItemMgr itemMgr = ItemMgr.getInstance();
WebBusinessObject item = (WebBusinessObject) request.getAttribute("item");
item.printSelf();
TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
StoreMgr storeMgr = StoreMgr.getInstance();
WebBusinessObject wbo = storeMgr.getOnSingleKey(item.getAttribute("storeID").toString());


String cMode= (String) request.getSession().getAttribute("currentMode");
String  stat=cMode;
String align=null;
String dir=null;
String style=null;
String lang,langCode;

String saving_status;
String title_1,title_2;
String cat_name, part_name, part_code, part_unit, store_name, part_price;
// String cat_name, part_name;
String cancel_button_label;
String save_button_label;
String info;
if(stat.equals("En")){
    
    saving_status="Saving status";
    align="center";
    dir="LTR";
    style="text-align:left";
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
    
    cat_name="Category name";
    part_name="Part name";
    part_code="Part code";
    part_unit="Part unit";
    store_name="Store name";
    part_price="Part price";
    
    info="Can't delete, because there are associated with parts.";
    
    title_1="Delete spare parts";
    title_2="All information are needed";
    cancel_button_label=" Return to menu ";
    save_button_label="Delete part";
    langCode="Ar";
}else{
    
    saving_status="&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
    align="center";
    dir="RTL";
    style="text-align:Right";
    lang="English";
    
    cat_name="&#1573;&#1587;&#1605; &#1575;&#1604;&#1589;&#1606;&#1601; ";
    part_name="&#1573;&#1587;&#1605; &#1575;&#1604;&#1602;&#1591;&#1593;&#1607; ";
    part_code="&#1603;&#1608;&#1583; &#1575;&#1604;&#1602;&#1591;&#1593;&#1607; ";
    part_unit="&#1608;&#1581;&#1583;&#1577; &#1575;&#1604;&#1602;&#1591;&#1593;&#1607; ";
    store_name="&#1573;&#1587;&#1605; &#1575;&#1604;&#1605;&#1582;&#1586;&#1606;";
    part_price="&#1587;&#1593;&#1585; &#1575;&#1604;&#1602;&#1591;&#1593;&#1607; ";
    
    info="&#1604;&#1575; &#1610;&#1605;&#1603;&#1606; &#1575;&#1604;&#1581;&#1584;&#1601; - &#1605;&#1585;&#1578;&#1576;&#1591; &#1576;&#1575;&#1580;&#1586;&#1575;&#1569; &#1575;&#1582;&#1585;&#1610;";
    
    title_1=" &#1581;&#1584;&#1601; &#1602;&#1591;&#1593;&#1577; &#1594;&#1610;&#1575;&#1585;";
    title_2="&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
    cancel_button_label=" &#1593;&#1608;&#1583;&#1607; &#1575;&#1604;&#1610; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1607; ";
    save_button_label="&#1573;&#1581;&#1584;&#1601; &#1575;&#1604;&#1602;&#1591;&#1593;&#1607;";
    langCode="En";
}

%>

<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>Document Viewer - Delete Detail Item</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css"><LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
    </HEAD>
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

   function submitForm()
   {    
      document.PROJECT_VIEW_FORM.action = "<%=context%>/ItemsServlet?op=DeleteItem&itemID=<%=itemID%>&categoryId=<%=categoryId%>&pIndex=<%=pIndex%>";
      document.PROJECT_VIEW_FORM.submit();  
   }
 function changePage(url){
                window.navigate(url);
    }
    </SCRIPT>
    <script src='ChangeLang.js' type='text/javascript'></script>
    <BODY>
        
        <FORM NAME="PROJECT_VIEW_FORM" METHOD="POST">
            
            <DIV align="left" STYLE="color:blue;">
                <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
                <button  onclick="JavaScript: changePage('<%=context%>//ItemsServlet?op=ViewItems&categoryId=<%=categoryId%>&itemID=<%=itemID%>&pIndex=<%=pIndex%>');" class="button"><%=cancel_button_label%><IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif"> </button>
                <button  onclick="JavaScript:  submitForm();" class="button"><%=save_button_label%><IMG HEIGHT="15" SRC="images/save.gif"></button>
            </DIV> 
            <fieldset class="set" align="center">
            <legend align="center">
                <table dir="<%=dir%>" align="<%=align%>">
                    <tr>
                        
                        <td class="td">
                            <font color="blue" size="6">    <%=title_1%>                
                            </font>
                            
                        </td>
                    </tr>
                </table>
            </legend>
            
            <%
            if(itemMgr.getActiveItem(itemID)) {
            %>
            <p align="center">
            <b><font color="red"><%=info%></font></b></p>
            <%
            } else {
            %>   
            
            <% } %>
            <br>
            <TABLE dir="<%=dir%>" align="<%=align%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                
                
                <%
                ArrayList arrayList = new ArrayList();
                categoryMgr.cashData();
                arrayList = categoryMgr.getCashedTableAsArrayList();
                %>
                
                <TR>
                    <TD STYLE="<%=style%>" class='td'>
                        <LABEL FOR="categoryName">
                            <p><b><%=cat_name%><font color="#FF0000">*</font></b>&nbsp;
                        </LABEL>
                        
                    </TD>
                    <TD STYLE="<%=style%>" class='td'>
                    <!--
                        <SELECT DISABLED name="categoryName">
                    <%
                    //if(request.getParameter("categoryName") != null){
                    %>
                    <//sw:OptionList optionList = '<%//=arrayList%>'  scrollTo = "<%//=request.getParameter("categoryName")%>"/>                            
                    <%
                    // } else {
                    %>
                            
                    <//sw:OptionList optionList = '<%//=arrayList%>' scrollTo = ""/>
                            
                    <%
                    // }
                    %>
                        </SELECT>
                            -->
                    <input disabled type="TEXT" name="categoryName" ID="categoryName" size="33" value="<%=item.getAttribute("categoryName")%>" maxlength="255">
                    
                    
                </TR>
                <!--
                <tr>
                    <TD class='td'>
                        <LABEL FOR="str_Function_Name">
                            <p><b>Category Name:</b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD class='td'>
                <input disabled type="TEXT" name="categoryName" ID="categoryName" size="33" value="<%//=category.getAttribute("categoryName")%>" maxlength="255">
                    </TD>
                </TR>
                -->
                <!--
                <TR>
                    <TD class='td'>
                        <LABEL FOR="str_Function_Name">
                <p><b><%//=tGuide.getMessage("eqNO")%>:</b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD class='td'>
                <input disabled type="TEXT" name="eqNO" ID="eqNO" size="33" value="<%//=project.getAttribute("eqNO")%>" maxlength="255">
                    </TD>
                </TR>
          -->
                <TR>
                    <TD STYLE="<%=style%>" class='td'>
                        <LABEL FOR="itemDscrptn">
                            <p><b><%=part_name%><font color="#FF0000">*</font></b>&nbsp;
                        </LABEL>
                        
                    </TD>
                    <TD STYLE="<%=style%>" class='td'>
                        <!--
                        <TEXTAREA   rows="5" name="itemDscrptn" value="<%//= (String) item.getAttribute("itemDscrptn")%>" cols="25"></TEXTAREA>
                    -->
                        <input disabled type="TEXT" name="itemDscrptn" ID="itemDscrptn" size="33" value="<%=(String) item.getAttribute("itemDscrptn")%>" maxlength="255">
                        
                    </TD>
                </TR>
                
                
                
                
            </TABLE>
            <br><br><br>
        </FORM>
    </BODY>
</HTML>     
