<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,com.silkworm.persistence.relational.UniqueIDGen"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<HTML>


<%
String categoryName=request.getParameter("categoryName");
String status = (String) request.getAttribute("Status");

MetaDataMgr metaMgr = MetaDataMgr.getInstance();
CategoryMgr categoryMgr=CategoryMgr.getInstance();

String context = metaMgr.getContext();
TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
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

ArrayList arrayList = new ArrayList();
categoryMgr.cashData();
arrayList = categoryMgr.getCashedTableAsArrayList();

String cMode= (String) request.getSession().getAttribute("currentMode");
String  stat=cMode;
String align=null;
String dir=null;
String style=null;
String lang,langCode;

String CatTip,NameTip,CodeTip,UnitTip,StoreTip,PriceTip,ImageTip;

String saving_status;
String category_name, part_name,part_code,part_unit,store_name,part_price,attach_image,Dupname;
String title_1,title_2;
String cancel_button_label;
String save_button_label, sNoData;
String fStatus;
String sStatus;
if(stat.equals("En")){
    
    saving_status="Saving status";
    align="center";
    dir="LTR";
    style="text-align:left";
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
    
    
    category_name="Category name";
    part_name="Part name";
    part_code="Part code";
    part_unit="Part unit";
    store_name="Store name";
    part_price="Part price";
    attach_image="Attach image";
    
    
    title_1="New spare part";
    title_2="All information are needed";
    cancel_button_label="Cancel ";
    save_button_label="Save ";
    langCode="Ar";
    sNoData = "No Data are available for";
    Dupname = "Name is Duplicated Chane it";
    
    CatTip="Drop Down this List and select the Category of this Spare Part";
    sStatus="Item Saved Successfully";
    fStatus="Fail To Save This Item";
}else{
    
    saving_status="&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
    align="center";
    dir="RTL";
    style="text-align:Right";
    lang="English";
    
    category_name="&#1573;&#1587;&#1605; &#1575;&#1604;&#1589;&#1606;&#1601; ";
    part_name="&#1573;&#1587;&#1605; &#1575;&#1604;&#1602;&#1591;&#1593;&#1607; ";
    part_code="&#1603;&#1608;&#1583;&#1575;&#1604;&#1602;&#1591;&#1593;&#1577; ";
    part_unit="&#1575;&#1604;&#1608;&#1581;&#1583;&#1577; ";
    store_name="&#1575;&#1587;&#1605; &#1575;&#1604;&#1605;&#1582;&#1586;&#1606;";
    part_price="&#1587;&#1593;&#1585; &#1575;&#1604;&#1602;&#1591;&#1593;&#1577; ";
    attach_image="&#1575;&#1585;&#1601;&#1575;&#1602;&#1575;&#1604;&#1589;&#1608;&#1585;&#1577; &#1604;&#1604;&#1602;&#1591;&#1593;&#1577;";
    
    
    title_1="&#1573;&#1590;&#1575;&#1601;&#1577; &#1602;&#1591;&#1593;&#1577; &#1594;&#1610;&#1575;&#1585; &#1576;&#1575;&#1604;&#1589;&#1606;&#1601;";
    title_2="&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
    cancel_button_label="&#1573;&#1606;&#1607;&#1575;&#1569; ";
    save_button_label="&#1578;&#1587;&#1580;&#1610;&#1604; ";
    langCode="En";
    sNoData = "&#1604;&#1610;&#1587; &#1607;&#1606;&#1575;&#1603; &#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1578;&#1575;&#1581;&#1607; &#1604;";
    Dupname = "&#1607;&#1584;&#1575; &#1575;&#1604;&#1575;&#1587;&#1605; &#1587;&#1580;&#1604; &#1605;&#1606; &#1602;&#1576;&#1604; &#1610;&#1580;&#1576; &#1578;&#1587;&#1580;&#1610;&#1604; &#1575;&#1587;&#1605; &#1570;&#1582;&#1585;";
    fStatus="&#1604;&#1600;&#1605; &#1610;&#1600;&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604;";
    sStatus="&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604; &#1576;&#1600;&#1606;&#1600;&#1580;&#1600;&#1575;&#1581;";
}
String doubleName = (String) request.getAttribute("name");
if(arUnits.size() == 0){
    sNoData = sNoData + " '" + part_unit + "'";
}

if(arrayList.size() == 0){
    sNoData = sNoData + " '" + category_name + "'";
}

if(storeList.size() == 0){
    sNoData = sNoData + " '" + store_name + "'";
}
%>

<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Expires" CONTENT="0">

<HEAD>
    <TITLE>DebugTracker-add new Category</TITLE>
    <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css"><LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
</HEAD>

<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

        function submitForm()
        {  
            var fileName = document.getElementById("file1").value;
            if (!validateData("req", this.ITEM_FORM.categoryName, "Please, select Category Name.")){
                this.ITEM_FORM.categoryName.focus();
            } else if (!validateData("req", this.ITEM_FORM.itemDscrptn, "Please, enter Part Name.") || !validateData("minlength=3", this.ITEM_FORM.itemDscrptn, "Please, enter a valid Part Name.")){
                this.ITEM_FORM.itemDscrptn.focus();
            } else if (!validateData("req", this.ITEM_FORM.itemCode, "Please, enter Part Code.") || !validateData("minlength=3", this.ITEM_FORM.itemCode, "Please, enter a valid Part Code.")){
                this.ITEM_FORM.itemCode.focus();
            } else if (!validateData("req", this.ITEM_FORM.itemUnit, "Please, enter Part Unit.")){
                this.ITEM_FORM.itemUnit.focus();
            } else if (!validateData("req", this.ITEM_FORM.itemUnitPrice, "Please, enter Part Price.") || !validateData("numericfloat", this.ITEM_FORM.itemUnitPrice, "Please, enter a valid Number for Price.")){
                this.ITEM_FORM.itemUnitPrice.focus();
            } else if(document.getElementById("checkImage").checked && fileName.indexOf("jpg") == -1 && fileName.indexOf("JPG") == -1 && fileName.length > 0){
                alert("Invalid Image type, required JPG Image.");
            } else{
                document.ITEM_FORM.action = "<%=context%>/ItemsServlet?op=SavetembyCategory";
                document.ITEM_FORM.submit();
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
    
    function changeImageState(checkBox){
        if(checkBox.checked){
            document.getElementById("file1").disabled = false;
            document.getElementById("imageName").value = "";
        } else {
            document.getElementById("file1").disabled = true;
        }
    }
    
    function changePic(){
        var fileName = document.getElementById("file1").value;
        if(fileName.length > 0){
            if(fileName.indexOf("jpg") > -1 || fileName.indexOf("JPG") > -1){
                document.getElementById("itemImage").src = fileName;
                document.getElementById("imageName").value = fileName;
                document.getElementById("file1").value = '';
            } else {
                alert("Invalid Image type, required JPG Image.");
                document.getElementById("itemImage").src = 'images/no_image.jpg';
                document.getElementById("imageName").value = "";
                document.getElementById("file1").select();
            }
        } else {
            document.getElementById("itemImage").src = 'images/no_image.jpg';
            document.getElementById("imageName").value = "";
        }
    }
    
      function cancelForm()
        {    
        document.ITEM_FORM.action = "main.jsp";
        document.ITEM_FORM.submit();  
        }
        
        
           function showCursor(text)
            {
            document.getElementById('trail').innerHTML=text;
            document.getElementById('trail').style.visibility="visible";
            document.getElementById('trail').style.position="absolute";
            document.getElementById('trail').style.left=event.clientX+10;
            document.getElementById('trail').style.top=event.clientY;
            }

            function hideCursor()
            {
            document.getElementById('trail').style.visibility="hidden";
            }
        
</SCRIPT>
<script src='ChangeLang.js' type='text/javascript'></script>
<BODY>

<FORM NAME="ITEM_FORM" method="post" enctype="multipart/form-data">
<DIV align="left" STYLE="color:blue;">
    <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
    <button  onclick="JavaScript: cancelForm();" class="button"><%=cancel_button_label%><IMG VALIGN="BOTTOM"   SRC="images/cancel.gif"> </button>
    <%
    if(arrayList.size() > 0 && arUnits.size() > 0 && storeList.size() > 0){
    %>
    <button  onclick="JavaScript:  submitForm();" class="button"><%=save_button_label%><IMG HEIGHT="15" SRC="images/save.gif"></button>
    <%
    }
    %>
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

<table  dir="<%=dir%>" align="<%=align%>"> 
    <%    if(null!=status) {
    if(status.equalsIgnoreCase("ok")){
    %>  
    <tr>
        <table align="<%=align%>" dir=<%=dir%>>
            <tr>                    
                <td class="td">
                    <font size=4 color="black"><%=sStatus%></font> 
                </td>                    
        </tr> </table>
    </tr>
    <%
    }else{%>
    <tr>
        <table align="<%=align%>" dir=<%=dir%>>
            <tr>                    
                <td class="td">
                    <font size=4 color="red" ><%=fStatus%></font> 
                </td>                    
        </tr> </table>
    </tr>
    <%}
    }
    %>
    <%
    if(arrayList.size() == 0 || arUnits.size() == 0 || storeList.size() == 0) {
    %>
    <BR><center><font color="red"><B><%=sNoData%></B></font></center>
    <%
    }
    %>
    
</table>
<br>
<table align="<%=align%>" dir=<%=dir%>>
    <TR COLSPAN="2" ALIGN="<%=align%>">
        <TD STYLE="<%=style%>" class='td'>
            <FONT color='red' size='+1'><%=title_2%></FONT> 
        </TD>
        
    </TR>
</table>
<TABLE  dir="<%=dir%>" align="<%=align%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
    <TD STYLE="<%=style%>" class='td'>
        <TABLE  dir="<%=dir%>" align="<%=align%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
            <TR>
                <TD STYLE="<%=style%>" class='td'>
                    <LABEL FOR="categoryName">
                        <p><b><%=category_name%><font color="#FF0000">*</font></b>&nbsp;
                    </LABEL>
                    
                </TD>
                <TD STYLE="<%=style%>" class='td'>
                    
                    <SELECT name="categoryName" ID="categoryName" STYLE="width:230px;">
                        <%
                        if(request.getParameter("categoryName") != null){
                        %>
                        <sw:OptionList optionList = '<%=arrayList%>'  scrollTo = "<%=request.getParameter("categoryName")%>"/>                            
                        <%
                        } else {
                        %>
                        
                        <sw:OptionList optionList = '<%=arrayList%>' scrollTo = ""/>
                        
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
                    <LABEL FOR="itemDscrptn">
                        <p><b><%=part_name%><font color="#FF0000">*</font></b>&nbsp;
                    </LABEL>
                    
                </TD>
                <TD STYLE="<%=style%>" class='td'>
                    <input style="width:230px;" type="TEXT" name="itemDscrptn" ID="itemDscrptn" size="33" value="" maxlength="255">
                </TD>
            </TR>
            <TR>
                <TD STYLE="<%=style%>" class='td'>
                    <LABEL FOR="itemCode">
                        <p><b><%=part_code%><font color="#FF0000">*</font></b>&nbsp;
                    </LABEL>
                    
                </TD>
                <TD STYLE="<%=style%>" class='td'>
                    <input style="width:230px;" type="TEXT" name="itemCode" ID="itemCode" size="33" value="" maxlength="255">
                </TD>
                
            </TR>
            
            
            <TR>
                <TD STYLE="<%=style%>"  class='td'>
                    <LABEL FOR="itemUnit">
                        <p><b><%=part_unit%><font color="#FF0000">*</font></b>&nbsp;
                    </LABEL>
                    
                </TD>
                <TD STYLE="<%=style%>" class='td'>
                    <!--input type="TEXT" name="itemUnit" ID="itemUnit" size="33" value="" maxlength="255"-->
                    <select name="itemUnit" ID="itemUnit" style="width:230px;">
                        <%
                        for(int i = 0; i < arUnits.size(); i++){
    WebBusinessObject wbo = (WebBusinessObject) arUnits.get(i);
                        %>
                        <option value="<%=(String) wbo.getAttribute("unitID")%>"><%=(String) wbo.getAttribute("unitName")%>
                        <%
                        }
                        %>
                    </select>
                </TD>
                
            </TR>
            
            <TR>
                <TD STYLE="<%=style%>" class='td'>
                    <LABEL FOR="storeID">
                        <p><b> <%=store_name%><font color="#FF0000">*</font></b>&nbsp;
                    </LABEL>
                    
                </TD>
                <TD STYLE="<%=style%>" class='td'>
                    
                    <SELECT name="storeID" ID="storeID" STYLE="width:230px;">
                        <%
                        if(request.getParameter("storeID") != null){
                        %>
                        <sw:WBOOptionList wboList='<%=storeList%>' displayAttribute="storeName" valueAttribute="storeID" scrollTo = "<%=request.getParameter("storeID")%>"/>                            
                        <%
                        } else {
                        %>
                        
                        <sw:WBOOptionList wboList='<%=storeList%>' displayAttribute="storeName" valueAttribute="storeID" scrollTo = ""/>
                        
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
                <TD STYLE="<%=style%>" class='td' CLASS="shaded">
                    <LABEL FOR="itemUnitPrice">
                        <p><b><%=part_price%><font color="#FF0000">*</font></b>&nbsp;
                    </LABEL>
                    
                </TD>
                <TD STYLE="<%=style%>" class='td'>
                    <input style="width:230px;" type="TEXT" CLASS="shaded" name="itemUnitPrice" ID="itemUnitPrice" size="33" value="" maxlength="255">
                </TD>
                
            </TR>
            
            <TR>
                <TD STYLE="<%=style%>" class='td' CLASS="shaded">
                    <input type="checkbox" id="checkImage" onclick="JavaScript: changeImageState(this);"><b><%=attach_image%></b></input>
                    
                </TD>
                
                <TD STYLE="<%=style%>" class='td'>
                    <input style="width:230px;" type="file" name="file1" disabled id="file1" accept="*.jpg" onchange="JavaScript: changePic();">
                    <input type="hidden" name="imageName" id="imageName" value="">
                </TD>
                
            </TR>
            
        </TABLE>
    </TD>
    <TD STYLE="<%=style%>" class='td'>
        <img width="250px" name='itemImage' id='itemImage' align="<%=align%>" alt='document image' src='images/no_image.jpg' border="2">
    </TD>
    <input type="hidden" name="docType" value="jpg">
    <input type="hidden" name="docTitle" value="Spare Part Image">
    <input type="hidden" name="itemID" value="<%=UniqueIDGen.getNextID()%>">
    <input type="hidden" name="description" value="Spare Part Image">
    <input type="hidden" name="faceValue" value="0">
    <input type="hidden" name="fileExtension" value="jpg">
    <%
    Calendar c = Calendar.getInstance();
    Integer iMonth = new Integer(c.get(c.MONTH));
    int month = iMonth.intValue() + 1;
    iMonth = new Integer(month);
    %>
    <input type="hidden" name="docDate" value="<%=iMonth.toString() + "/" + c.get(c.DATE) + "/" + c.get(c.YEAR)%>">
    <input type="hidden" name="configType" value="1">
    </TR>
</TABLE>
</FORM>
</BODY>
</HTML>     
