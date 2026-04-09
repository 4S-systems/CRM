<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*"%>  
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<%
MetaDataMgr metaMgr = MetaDataMgr.getInstance();
ItemDocMgr itemDocMgr = ItemDocMgr.getInstance();
SupplierItemMgr supplierItemMgr = SupplierItemMgr.getInstance();
String context = metaMgr.getContext();
String pIndex = request.getParameter("pIndex");

String categoryId = (String) request.getAttribute("categoryId");

CategoryMgr categoryMgr=CategoryMgr.getInstance();
WebBusinessObject item = (WebBusinessObject) request.getAttribute("item");
item.printSelf();
TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
StoreMgr storeMgr = StoreMgr.getInstance();
WebBusinessObject wbo = storeMgr.getOnSingleKey(item.getAttribute("storeID").toString());

Vector imagePath = (Vector) request.getAttribute("imagePath");


String cMode= (String) request.getSession().getAttribute("currentMode");
String  stat=cMode;
String align=null;
String dir=null;
String style=null;
String lang,langCode;

String cat_name, part_name, part_code, part_unit, store_name, part_price;
String saving_status, additional_operations;

String add_supplier, attach_doc, view_operations, view_images, view_docs, no_att_docs, view_supplier;
String no_sup_founded;

String title_1,title_2;
String cancel_button_label;
String save_button_label,info="No attached images founded";
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
    additional_operations="Additional operations";
    view_operations="View operations";
    view_images="View images";
    view_docs="View documents";
    view_supplier="View suppliers";
    no_sup_founded="No suppliers founded";
    
    add_supplier="Add supplier";
    attach_doc="Attach a document";
    no_att_docs="No attached documents founded";
    
    title_1="View spare parts";
    title_2="All information are needed";
    cancel_button_label="Return to menu ";
    save_button_label="Save ";
    langCode="Ar";
}else{
    
    saving_status="&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
    align="center";
    dir="RTL";
    style="text-align:Right";
    lang="English";
    
    
    additional_operations="&#1593;&#1605;&#1604;&#1610;&#1575;&#1578; &#1573;&#1590;&#1575;&#1601;&#1610;&#1577;";
    cat_name="&#1573;&#1587;&#1605; &#1575;&#1604;&#1589;&#1606;&#1601; ";
    part_name="&#1573;&#1587;&#1605; &#1575;&#1604;&#1602;&#1591;&#1593;&#1607; ";
    part_code="&#1603;&#1608;&#1583; &#1575;&#1604;&#1602;&#1591;&#1593;&#1607; ";
    part_unit="&#1608;&#1581;&#1583;&#1577; &#1575;&#1604;&#1602;&#1591;&#1593;&#1607; ";
    store_name="&#1573;&#1587;&#1605; &#1575;&#1604;&#1605;&#1582;&#1586;&#1606;";
    part_price="&#1587;&#1593;&#1585; &#1575;&#1604;&#1602;&#1591;&#1593;&#1607; ";
    
    add_supplier=" &#1571;&#1590;&#1601; &#1605;&#1608;&#1585;&#1583;";
    attach_doc=" &#1573;&#1585;&#1601;&#1602; &#1605;&#1587;&#1578;&#1606;&#1583; ";
    view_operations="&#1593;&#1605;&#1604;&#1610;&#1575;&#1578; &#1605;&#1588;&#1575;&#1607;&#1583;&#1577; ";
    view_images="&#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1575;&#1604;&#1589;&#1608;&#1585; ";
    view_docs="&#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583;&#1575;&#1578; ";
    no_att_docs="&#1604;&#1575; &#1610;&#1608;&#1580;&#1583; &#1605;&#1587;&#1578;&#1606;&#1583;&#1575;&#1578; &#1605;&#1585;&#1601;&#1602;&#1607; ";
    view_supplier="&#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1575;&#1604;&#1605;&#1608;&#1585;&#1583;&#1610;&#1606; ";
    no_sup_founded="&#1604;&#1575;&#1610;&#1608;&#1580;&#1583; &#1605;&#1608;&#1585;&#1583;&#1610;&#1606;";
    
    info="&#1604;&#1575; &#1610;&#1608;&#1580;&#1583; &#1589;&#1608;&#1585; &#1605;&#1585;&#1601;&#1602;&#1607; ";
    title_1="&#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1602;&#1591;&#1593;&#1577; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585;";
    title_2="&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
    cancel_button_label=" &#1593;&#1608;&#1583;&#1607; &#1575;&#1604;&#1610; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1607; ";
    save_button_label="&#1578;&#1587;&#1580;&#1610;&#1604; ";
    langCode="En";
}

%>

<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>Document Viewer - View Detail Item</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css"><LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
    </HEAD>
    
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
     
        function changeMode(name){
            if(document.getElementById(name).style.display == 'none'){
                document.getElementById(name).style.display = 'block';
            } else {
                document.getElementById(name).style.display = 'none';
            }
        }
           function changePage(url){
                window.navigate(url);
            }
    </SCRIPT> 
    <script src='ChangeLang.js' type='text/javascript'></script>
    <BODY>
        
        
        
        <table align="center" dir="rtl" border="0" width="80%">
            
            <tr>
                <td  STYLE="border:0px"  VALIGN="top" width="50%">
                    <div STYLE="width:100%;border:2px solid gray;background-color:#808000;color:white;" bgcolor="#F3F3F3" align="center">
                        <div ONCLICK="JavaScript: changeMode('menu1');" STYLE="width:100%;background-color:#808000;color:white;cursor:hand;font-size:14;">
                            <b>
                                <%=additional_operations%>
                                
                            </b>
                            <img src="images/arrow_down.gif">
                        </div>
                        <div ALIGN="right" STYLE="width:100%;background-color:#FFFFCC;color:white;display:none;<%=style%>;border-top:2px solid gray;" ID="menu1">
                            <table align="center" border="0" dir="rtl" width="100%" cellspacing="2">
                                <tr>
                                    <TD nowrap CLASS="cell" width="33%" style="text-align:center;border:1px solid black;cursor:hand;color:white;" bgcolor="#B7B700" onclick="JavaScript: changePage('<%=context%>/SupplierServlet?op=GetItemSupplierForm&itemID=<%=item.getAttribute("itemID")%>&categoryId=<%=item.getAttribute("categoryId")%>&pIndex=<%=pIndex%>');">
                                        <b><font color="white"> <%=add_supplier%></font></b>
                                    </TD>
                                    
                                    
                                    <TD nowrap CLASS="cell" width="33%" bgcolor="#B7B700" style="text-align:center;border:1px solid black;cursor:hand;color:white;" onclick="JavaScript: changePage('<%=context%>/ItemDocWriterServlet?op=SelectFile&itemID=<%=item.getAttribute("itemID")%>&categoryId=<%=item.getAttribute("categoryId")%>&pIndex=<%=pIndex%>');">
                                        <b> <font color="white"><%=attach_doc%></font></b>
                                    </TD>
                                    <TD nowrap CLASS="cell" width="33%" style="text-align:center;border:1px solid black;cursor:hand;color:white;" bgcolor="#B7B700" >
                                        <DIV ID="links">
                                            &nbsp;
                                        </DIV>
                                        
                                    </TD>
                                    
                                </tr>
                            </table>
                        </div>
                    </div>
                </td>
                <TD STYLE="border:0px"  VALIGN="top" width="50%">
                <DIV STYLE="width:100%;border:2px solid gray;background-color:#808000;color:white;">
                <DIV ONCLICK="JavaScript: changeMode('menu3');" STYLE="width:100%;background-color:#808000;color:white;cursor:hand;font-size:14;">
                    <b> <%=view_operations%></B> <img src="images/arrow_down.gif">
                </DIV>
                <DIV ALIGN="right" STYLE="width:100%;background-color:#FFFFCC;color:black;display:none;<%=style%>;" ID="menu3">
                <table border="0" cellpadding="0"  width="100%" cellspacing="2"  bgcolor="#FFFFCC">
                    <tr>
                        <%
                        if(itemDocMgr.hasImages(item.getAttribute("itemID").toString())) {
                        %>
                        <TD nowrap CLASS="cell" width="33%" bgcolor="#B7B700" STYLE="text-align:center;border:1px solid black;cursor:hand;" onclick="JavaScript: changePage('<%=context%>/ItemDocReaderServlet?op=ViewImages&itemID=<%=item.getAttribute("itemID")%>&categoryId=<%=item.getAttribute("categoryId")%>&pIndex=<%=pIndex%>');">
                            <b><font color="white"> <%=view_images%></font></b>
                            <IMG SRC="images/view.png"  ALT="view file"> 
                        </TD>
                        
                        <%
                        } else {
                        %> 
                        <TD nowrap CLASS="cell" width="33%" bgcolor="#B7B700" style="text-align:center;border:1px solid black;cursor:hand;color:white;">
                            <DIV ID="links">
                                
                                <b>  <font color="white"><%=info%></font></b>
                                
                            </DIV>
                        </TD>
                        
                        <%
                        }
                        %>
                        
                        <%
                        if(itemDocMgr.hasDocuments(item.getAttribute("itemID").toString())) {
                        %>
                        <TD nowrap CLASS="cell" width="33%" bgcolor="#B7B700" style="text-align:center;border:1px solid black;cursor:hand;color:white;" onclick="JavaScript: changePage('<%=context%>/ItemDocReaderServlet?op=ListDoc&itemID=<%=item.getAttribute("itemID")%>&categoryId=<%=item.getAttribute("categoryId")%>&pIndex=<%=pIndex%>');">
                            <b> <font color="white"> <%=view_docs%></font></b>
                            <IMG SRC="images/view.png"  ALT="view file">
                        </TD>
                        
                        <%
                        } else {
                        %> 
                        <TD nowrap CLASS="cell" width="33%" bgcolor="#B7B700" style="text-align:center;border:1px solid black;cursor:hand;color:white;">
                            <DIV ID="links">
                                
                                <b> <font color="white"> <%=no_att_docs%></font> </b>
                                
                            </DIV>
                        </TD>
                        
                        <%
                        }
                        %>
                        <%
                        
                        if(supplierItemMgr.hasSupplier((String) item.getAttribute("itemID"))) {
                        %>
                        <TD nowrap CLASS="cell" width="33%" bgcolor="#B7B700" style="text-align:center;border:1px solid black;cursor:hand;color:white;" onclick="JavaScript: changePage('<%=context%>/SupplierServlet?op=ListItemSuppliers&itemID=<%=item.getAttribute("itemID")%>&categoryId=<%=item.getAttribute("categoryId")%>&pIndex=<%=pIndex%>');">
                            <b>  <font color="white"> <%=view_supplier%></font></b>
                        </TD>
                        <%
                        } else {
                        %> 
                        <TD nowrap CLASS="cell" width="33%" bgcolor="#B7B700" style="text-align:center;border:1px solid black;cursor:hand;color:white;">
                            <DIV ID="links">
                                
                                <b> <font color="white"> <%=no_sup_founded%></font</b> 
                                
                            </DIV>
                        </TD>
                        
                        <%
                        }
                        %>
                    </tr>
                </table>
            </tr>
            </DIV>
            </DIV>
            </TD>
            </tr>
        </table>
        
        <DIV align="left" STYLE="color:blue;">
            <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
            <button  onclick="JavaScript: changePage('<%=context%>//ItemsServlet?op=ViewItems&categoryId=<%=categoryId%>&pIndex=<%=pIndex%>');" class="button"><%=cancel_button_label%><IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif"> </button>
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
        
        <FORM NAME="PROJECT_VIEW_FORM" METHOD="POST">
            
            <br><br>
            <TABLE dir="<%=dir%>" align="<%=align%>" CELLPADDING="0" CELLSPACING="0">
                <TR>
                    <TD class='td'>
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
                            <TR>
                                <TD STYLE="<%=style%>" class='td'>
                                    <LABEL FOR="itemCode">
                                        <p><b><%=part_code%><font color="#FF0000">*</font></b>&nbsp;
                                    </LABEL>
                                    
                                </TD>
                                <TD STYLE="<%=style%>" class='td'>
                                    <input disabled type="TEXT" name="itemCode" ID="itemCode" size="33" value="<%=item.getAttribute("itemCode")%>" maxlength="255">
                                </TD>
                                
                            </TR>
                            <TR>
                                <TD STYLE="<%=style%>" class='td'>
                                    <LABEL FOR="itemUnit">
                                        <p><b><%=part_unit%> <font color="#FF0000">*</font></b>&nbsp;
                                    </LABEL>
                                    
                                </TD>
                                <%
                                ItemUnitMgr itemUnitMgr = ItemUnitMgr.getInstance();
                                WebBusinessObject wboTemp = itemUnitMgr.getOnSingleKey((String) item.getAttribute("itemUnit"));
                                %>
                                <TD STYLE="<%=style%>" class='td'>
                                    <input disabled type="TEXT" name="itemUnit" ID="itemUnit" size="33" value="<%=(String) wboTemp.getAttribute("unitName")%>" maxlength="255">
                                </TD>
                                
                            </TR>
                            
                            <TR>
                                <TD STYLE="<%=style%>" class='td'>
                                    <LABEL FOR="storeName">
                                        <p><b><%=store_name%>;<font color="#FF0000">*</font></b>&nbsp;
                                    </LABEL>
                                    
                                </TD>
                                <TD STYLE="<%=style%>" class='td'>
                                    <input disabled type="TEXT" name="storeName" ID="storeName" size="33" value="<%=wbo.getAttribute("storeName")%>" maxlength="255">
                                </TD>
                                
                            </TR>
                            
                            <TR>
                                <TD STYLE="<%=style%>" class='td'>
                                    <LABEL FOR="itemUnitPrice">
                                        <p><b><%=part_price%><font color="#FF0000">*</font></b>&nbsp;
                                    </LABEL>
                                    
                                </TD>
                                <TD STYLE="<%=style%>" class='td'>
                                    <input disabled type="TEXT" name="itemUnitPrice" ID="itemUnitPrice" size="33" value="<%=item.getAttribute("itemUnitPrice")%>" maxlength="255">
                                </TD>
                                
                            </TR>
                            
                            
                        </TABLE>
                    </TD>
                    <TD class='td'>&nbsp;</TD>
                    <TD class='td'>
                        <table dir="<%=dir%>" align="<%=align%>">
                            <%
                            if(imagePath.size() > 0){
                                    for(int i = 0; i < imagePath.size(); i++){
                            %>
                            <TR>
                                <TD class='td'>
                                    <img align="right" name='docImage' width="200" alt='document image' src='<%=imagePath.get(i).toString()%>' >
                                </TD>
                            </tr>
                            <%
                                    }
                            } else {
                            %>
                            <TR>
                                <TD class='td'>
                                    <img align="right" name='docImage' alt='document image' src='images/no_image.jpg' border="2">
                                </TD>
                            </tr>
                            <%
                            }
                            %>
                        </table>
                    </TD>
                </TR>
            </TABLE>
        </FORM>
    </BODY>
</HTML>     
&#1571;&#1590;&#1601; &#1605;&#1608;&#1585;&#1583;