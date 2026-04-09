<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<HTML>


<%
String status = (String) request.getAttribute("Status");

MetaDataMgr metaMgr = MetaDataMgr.getInstance();
SupplierMgr supplierMgr=SupplierMgr.getInstance();

String itemID = request.getAttribute("itemID").toString();
String categoryId = request.getAttribute("categoryId").toString();

String context = metaMgr.getContext();
TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

WebBusinessObject supplierItem = (WebBusinessObject) request.getAttribute("supplierItem");

WebBusinessObject supplier = supplierMgr.getOnSingleKey(supplierItem.getAttribute("supplierID").toString());
String pIndex = request.getParameter("pIndex");



String cMode= (String) request.getSession().getAttribute("currentMode");
String  stat=cMode;
String align=null;
String dir=null;
String style=null;
String lang,langCode;

String head_1,head_2;
String saving_status;
String title_1,title_2;
//String head_1,head_2,field_1_1;
String cancel_button_label;
String  sup_name, sup_part_num, unit_price;
//String view, edit, delete;
String save_button_label;
String parts_numb="&#1606;&#1578;&#1610;&#1580;&#1577; &#1575;&#1604;&#1593;&#1585;&#1590;";
String piece_word="&#1602;&#1591;&#1593;&#1577;";
if(stat.equals("En")){
    
    saving_status="Saving status";
    align="center";
    dir="LTR";
    style="text-align:left";
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
   
    sup_name="Supplier name";
    sup_part_num="Supplier part number";
    unit_price="Unit price";
    
    title_1="Update supplier of a spare part";
    title_2="All information are needed";
    cancel_button_label=" Return to menu ";
    save_button_label="Save ";
    langCode="Ar";
}else{
    
    saving_status="&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
    align="center";
    dir="RTL";
    style="text-align:Right";
    lang="English";
    
    sup_name="&#1575;&#1587;&#1605; &#1575;&#1604;&#1605;&#1608;&#1585;&#1583;";
    sup_part_num="&#1585;&#1602;&#1605; &#1605;&#1608;&#1585;&#1583; &#1575;&#1604;&#1602;&#1591;&#1593;&#1607;";
    unit_price="&#1587;&#1593;&#1585; &#1575;&#1604;&#1602;&#1591;&#1593;&#1607;";
   
    title_1="&#1578;&#1581;&#1583;&#1610;&#1579; &#1605;&#1608;&#1585;&#1583;&#1610;&#1606; &#1602;&#1591;&#1593; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585;";
    title_2="&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
    cancel_button_label=" &#1593;&#1608;&#1583;&#1607; &#1575;&#1604;&#1610; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1607; ";
    save_button_label="&#1587;&#1580;&#1604; ";
    langCode="En";
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
        if (this.ITEM_FORM.partNO.value ==""){
        alert ("Enter Part Code");
        this.ITEM_FORM.partNO.focus();
    } else if (!IsNumeric(this.ITEM_FORM.partNO.value)){
        alert ("Not a valid Number");
        this.ITEM_FORM.partNO.focus();
    } else if (this.ITEM_FORM.unitPrice.value ==""){
        alert ("Enter Part Price");
        this.ITEM_FORM.unitPrice.focus();
    } else if (!IsNumeric(this.ITEM_FORM.unitPrice.value)){
        alert ("Not a valid Number");
        this.ITEM_FORM.unitPrice.focus();
    
    
   } else{
        
        document.ITEM_FORM.action = "<%=context%>/SupplierServlet?op=UpdateItemSupplier&itemID=<%=itemID%>&categoryId=<%=categoryId%>&pIndex=<%=pIndex%>";
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
    
    
    
 function changePage(url){
                window.navigate(url);
            }
</SCRIPT>
<script src='ChangeLang.js' type='text/javascript'></script>        
<BODY>

    
<FORM NAME="ITEM_FORM" METHOD="POST">
    
          
<DIV align="left" STYLE="color:blue;">
    <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
    <button  onclick="JavaScript: changePage('<%=context%>/SupplierServlet?op=ListItemSuppliers&itemID=<%=itemID%>&categoryId=<%=categoryId%>&pIndex=<%=pIndex%>');" class="button"><%=cancel_button_label%><IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif"> </button>
    <button  onclick="JavaScript:  submitForm();" class="button"><%=save_button_label%><IMG HEIGHT="15" SRC="images/save.gif"></button>
    
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

   
    <BR>
    <table align="<%=align%>" dir=<%=dir%>>
    <%    if(null!=status) {
    
    %>
    <tr><td  class="td" align=<%=align%>> <b> <font size=4 > <%=saving_status%> : <%=status%> </font>    
    </tr>
    
    <%
    }
    %>
    <TR COLSPAN="2" ALIGN="RIGHT">
        <TD STYLE="<%=style%>" class='td'>
                        <FONT color='red' size='+1'><%=title_2%></FONT> 
                    </TD>
        
    </TR>
    </table>
    <%    if(null!=status) {
    
    %>
    <br><br>
    <%
    }
    %>
        
    <br><br>
    <TABLE align="<%=align%>" dir=<%=dir%> CELLPADDING="0" CELLSPACING="0" BORDER="0">
        
        
        <TR>
            <TD STYLE="<%=style%>" class='td'>
                <LABEL FOR="supplierID">
                    <p><b><%=sup_name%><font color="#FF0000">*</font></b>&nbsp;
                </LABEL>
            </TD>
            <TD STYLE="<%=style%>" class='td'>
                <input disabled type="TEXT" name="supplierID" ID="supplierID" size="33" value="<%=supplier.getAttribute("name").toString()%>" maxlength="255">
            </TD>
            
        </TR>
        
        <TR>
            <TD STYLE="<%=style%>" class='td'>
                <LABEL FOR="partNO">
                    <p><b><%=sup_part_num%><font color="#FF0000">*</font></b>&nbsp;
                </LABEL>
            </TD>
            <TD STYLE="<%=style%>" class='td'>
                <input type="TEXT" name="partNO" ID="partNO" size="33" value="<%=supplierItem.getAttribute("partNO").toString()%>" maxlength="255">
            </TD>
            
        </TR>
        
        <TR>
            <TD STYLE="<%=style%>" class='td' CLASS="shaded">
                <LABEL FOR="unitPrice">
                    <p><b><%=unit_price%><font color="#FF0000">*</font></b>&nbsp;
                </LABEL>
            </TD>
            <TD STYLE="<%=style%>" class='td'>
                <input type="TEXT" CLASS="shaded" name="unitPrice" ID="unitPrice" size="33" value="<%=supplierItem.getAttribute("unitPrice").toString()%>" maxlength="255">
            </TD>
        </TR>
        <input type="hidden" name="itemID" id="itemID" value="<%=itemID%>">
        <input type="hidden" name="supplierID" id="supplierID" value="<%=supplierItem.getAttribute("supplierID").toString()%>">
        <input type="hidden" name="categoryId" id="categoryId" value="<%=categoryId%>">
    </TABLE>
    <BR><BR><BR>
</FORM>
</BODY>
</HTML>     
