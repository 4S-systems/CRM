<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*"%>  
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<%
MetaDataMgr metaMgr = MetaDataMgr.getInstance();
String context = metaMgr.getContext();

String status = (String) request.getAttribute("Status");

String categoryId = (String) request.getAttribute("categoryId");
String itemID = (String) request.getAttribute("itemID");
String pIndex = request.getParameter("pIndex");

CategoryMgr categoryMgr=CategoryMgr.getInstance();
WebBusinessObject item = (WebBusinessObject) request.getAttribute("item");
TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

WebBusinessObject catWbo = (WebBusinessObject) categoryMgr.getOnSingleKey(categoryId);
ItemUnitMgr itemUnitMgr = ItemUnitMgr.getInstance();
itemUnitMgr.cashData();
ArrayList arUnits = itemUnitMgr.getCashedTableAsBusObjects();
//arUnits.add("Liter");
//arUnits.add("Centimeter");
//arUnits.add("Meter");
//arUnits.add("Number");
//arUnits.add("Gram");
//arUnits.add("Kilogram");

StoreMgr storeMgr = StoreMgr.getInstance();
storeMgr.cashData();
ArrayList storeList = new ArrayList();
storeList = storeMgr.getCashedTableAsBusObjects();

      
String cMode= (String) request.getSession().getAttribute("currentMode");
    String  stat=cMode;
    String align=null;
    String dir=null;
    String style=null;
    String lang,langCode;
    
    String saving_status;
    String title_1,title_2;
    String cat_name, part_name, part_code, part_unit, store_name, part_price,Dupname;
    String cancel_button_label;
    String save_button_label;
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
        
        title_1="Update spare parts";
        title_2="All information are needed";
        cancel_button_label=" Return to menu ";
        save_button_label="Update category";
        langCode="Ar";
        Dupname = "Name is Duplicated Chane it";
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
     
        
        title_1=" &#1578;&#1581;&#1583;&#1610;&#1579; &#1602;&#1591;&#1593;&#1577; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585;";
        title_2="&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
        cancel_button_label=" &#1593;&#1608;&#1583;&#1607; &#1575;&#1604;&#1610; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1607; ";
        save_button_label="&#1578;&#1581;&#1583;&#1610;&#1579;  ";
        langCode="En";
         Dupname = "&#1607;&#1584;&#1575; &#1575;&#1604;&#1575;&#1587;&#1605; &#1587;&#1580;&#1604; &#1605;&#1606; &#1602;&#1576;&#1604; &#1610;&#1580;&#1576; &#1578;&#1587;&#1580;&#1610;&#1604; &#1575;&#1587;&#1605; &#1570;&#1582;&#1585;";
  
    }
    
        String doubleName = (String) request.getAttribute("name");
%>

<HTML>
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Expires" CONTENT="0">

<HEAD>
    <TITLE>Document Viewer - View Detail Item</TITLE>
    <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css"><LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
</HEAD>

<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

        function submitForm()
        {    
            if (!validateData("req", this.ITEM_VIEW_FORM.categoryName, "Please, select Category Name.")){
                this.ITEM_VIEW_FORM.categoryName.focus();
            } else if (!validateData("req", this.ITEM_VIEW_FORM.itemDscrptn, "Please, enter Part Name.") || !validateData("minlength=3", this.ITEM_VIEW_FORM.itemDscrptn, "Please, enter a valid Part Name.")){
                this.ITEM_VIEW_FORM.itemDscrptn.focus();
            } else if (!validateData("req", this.ITEM_VIEW_FORM.itemCode, "Please, enter Part Code.") || !validateData("minlength=3", this.ITEM_VIEW_FORM.itemCode, "Please, enter a valid Part Code.")){
                this.ITEM_VIEW_FORM.itemCode.focus();
            } else if (!validateData("req", this.ITEM_VIEW_FORM.itemUnit, "Please, enter Part Unit.")){
                this.ITEM_VIEW_FORM.itemUnit.focus();
            } else if (!validateData("req", this.ITEM_VIEW_FORM.itemUnitPrice, "Please, enter Part Price.") || !validateData("numericfloat", this.ITEM_VIEW_FORM.itemUnitPrice, "Please, enter a valid Number for Price.")){
                this.ITEM_VIEW_FORM.itemUnitPrice.focus();
            } else{
                document.ITEM_VIEW_FORM.action = "<%=context%>/ItemsServlet?op=UpdateItem&categoryId=<%=categoryId%>&itemID=<%=itemID%>&pIndex=<%=pIndex%>";
                document.ITEM_VIEW_FORM.submit();  
            }
        }
        
           function IsNumeric(sText)
    {
        var ValidChars = "0123456789.";
        var IsNumber=true;
        var Char;

 
        for (i = 0; i < sText.length && IsNumber == true; i++) 
        { 
            Char = sText.charAt(i); 
            if (ValidChars.indexOf(Char) == -1) 
            {
                IsNumber = false;
            }
        }
        return IsNumber;

    }
    
    function clearValue(no){
        document.getElementById('Quantity' + no).value = '0';
        total();
    }
    
    function cancelForm()
        {    
        document.ITEM_VIEW_FORM.action = "<%=context%>//ItemsServlet?op=ViewItems&categoryId=<%=categoryId%>&itemID=<%=itemID%>&pIndex=<%=pIndex%>";
        document.ITEM_VIEW_FORM.submit();  
        }
         function changePage(url){
                window.navigate(url);
    }
</SCRIPT>
 <script src='ChangeLang.js' type='text/javascript'></script>
<BODY>

<FORM NAME="ITEM_VIEW_FORM" METHOD="POST">
      
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
            if(null!=doubleName) {
            
            %>
            
            <table dir="<%=dir%>" align="<%=align%>">
                <tr>
                    <td class="td">
                        <font size=4 > <%=Dupname%> </font> 
                    </td>
                    
            </tr> </table>
            <%
            
            }
            
            %>   
                
<%    if(null!=status) {

%>
<br><br>

<table dir="<%=dir%>" align="<%=align%>"> 
    <tr><td  class="td" align=right> <b> <font size=4 color="red"> <%=saving_status%> : <%=status%> </font> 
    </tr>
</table>

<%
}
%>
<br><br>

<TABLE dir="<%=dir%>" align="<%=align%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">


<%
ArrayList arrayList = new ArrayList();
categoryMgr.cashData();
arrayList = categoryMgr.getCashedTableAsArrayList();
%>

<TR>
    <TD STYLE="<%=style%>" class='td'>
        <LABEL FOR="itemDscrptn">
            <p><b><%=cat_name%><font color="#FF0000">*</font></b>&nbsp;
        </LABEL>
        
    </TD>
    <TD STYLE="<%=style%>" class='td'>
    
    <SELECT  name="categoryName" STYLE="width:230px">
        <%
        if(request.getParameter("categoryId") != null){
        %>
        <sw:OptionList optionList = '<%=arrayList%>'  scrollTo = "<%=catWbo.getAttribute("categoryName").toString()%>"/>                            
        <%
        } else {
        %>
        
        <sw:OptionList optionList = '<%=arrayList%>' scrollTo = ""/>
        
        <%
        }
        %>
    </SELECT>
    
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
<TD  STYLE="<%=style%>" class='td'>
    <input STYLE="width:230px" type="TEXT"  rows="5" name="itemDscrptn" ID="itemDscrptn" value="<%=item.getAttribute("itemDscrptn")%>" cols="25"></TEXTAREA>
</TD>
</TR>

<TR>
    <TD STYLE="<%=style%>" class='td'>
        <LABEL FOR="itemCode">
            <p><b><%=part_code%><font color="#FF0000">*</font></b>&nbsp;
        </LABEL>
        
    </TD>
    <TD  STYLE="<%=style%>" class='td'>
        <input STYLE="width:230px" type="TEXT" name="itemCode" ID="itemCode" size="33" value="<%=item.getAttribute("itemCode")%>" maxlength="255">
    </TD>
    
</TR>
<TR>
    <TD STYLE="<%=style%>" class='td'>
        <LABEL FOR="itemUnit">
            <p><b><%=part_unit%><font color="#FF0000">*</font></b>&nbsp;
        </LABEL>
        
    </TD>
    <TD STYLE="<%=style%>" class='td'>
        <!--input  type="TEXT" name="itemUnit" ID="itemUnit" size="33" value="<//%=item.getAttribute("itemUnit")%>" maxlength="255"-->
        <select name="itemUnit" ID="itemUnit" STYLE="width:230px">
            
            <%
            for(int i = 0; i < arUnits.size(); i++){
    WebBusinessObject wbo = (WebBusinessObject) arUnits.get(i);
            %>
            <option value="<%=(String) wbo.getAttribute("unitID")%>"
                    <% if(item.getAttribute("itemUnit").equals(wbo.getAttribute("unitID"))){%>
                    Selected 
                    <%}%>
                    >
                <%=(String) wbo.getAttribute("unitName")%>
                <%
                }
                %>
            </select>
    </TD>
    
</TR>

<TR>
    <TD STYLE="<%=style%>" class='td'>
        <LABEL FOR="storeName">
            <p><b><%=store_name%><font color="#FF0000">*</font></b>&nbsp;
        </LABEL>
        
    </TD>
    <TD STYLE="<%=style%>" class='td'>
        
        <SELECT name="storeID" ID="storeID" STYLE="width:230px">
            <%
            if(request.getParameter("storeID") != null){
    WebBusinessObject wbo = storeMgr.getOnSingleKey(request.getParameter("storeID"));
            %>
            <sw:WBOOptionList wboList='<%=storeList%>' displayAttribute="storeName" valueAttribute="storeID" scrollTo = "<%=wbo.getAttribute("storeName").toString()%>"/>                            
            <%
            } else {
    WebBusinessObject wbo = storeMgr.getOnSingleKey(item.getAttribute("storeID").toString());
            %>
            
            <sw:WBOOptionList wboList='<%=storeList%>' displayAttribute="storeName" valueAttribute="storeID" scrollTo = "<%=wbo.getAttribute("storeName").toString()%>"/>
            
            <%
            }
            %>
        </SELECT>
        <!--
                           <input type="TEXT" name="categoryName" ID="categoryName" size="33" value="Tanks" maxlength="255">
              -->
    </TD>
    
</TR>

<TR>
    <TD STYLE="<%=style%>" class='td'>
        <LABEL FOR="itemUnitPrice">
            <p><b><%=part_price%><font color="#FF0000">*</font></b>&nbsp;
        </LABEL>
        
    </TD>
    <TD  STYLE="<%=style%>"class='td'>
        <input STYLE="width:230px" type="TEXT" name="itemUnitPrice" ID="itemUnitPrice" size="33" value="<%=item.getAttribute("itemUnitPrice")%>" maxlength="255">
    </TD>
    
</TR>


<input type="hidden" name="itemID" ID="itemID" value="<%=item.getAttribute("itemID")%>">
</TABLE>
<br><br><br>
</FORM>
</BODY>
</HTML>     
