<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.maintenance.db_access.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.contractor.db_access.MaintainableMgr"%>
<%@ page import="com.silkworm.common.TimeServices,com.silkworm.jsptags.*"%>

<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>


<HTML>
    <%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
    
    String status = (String) request.getAttribute("Status");
    ArrayList unitsList = (ArrayList) request.getAttribute("units");
    ArrayList category = (ArrayList) request.getAttribute("category");
    
    for(int i=0; i<unitsList.size(); i++){
        WebBusinessObject unit = (WebBusinessObject) unitsList.get(i);
        if(unit.getAttribute("isMaintainable").toString().equalsIgnoreCase("1")){
            unitsList.remove(i);
            i = i-1;
        }
    }
    
    WebBusinessObject unitWbo = null;
    MaintenanceItemMgr maintenanceItemMgr = MaintenanceItemMgr.getInstance();
    CategoryMgr categoryMgr = CategoryMgr.getInstance();
    Vector items = new Vector();
    ArrayList arrList = new ArrayList();
    ConfigureCategoryMgr configureCategoryMgr = ConfigureCategoryMgr.getInstance();
    String equipmentID = new String("");
    if(request.getParameter("equipmentID") != null){
        equipmentID = request.getParameter("equipmentID");
    } else if(unitsList.size() > 0){
        equipmentID = ((WebBusinessObject) unitsList.get(0)).getAttribute("id").toString();
    }
    Vector eqItems = new Vector();
    Vector itemsID = new Vector();
    eqItems = configureCategoryMgr.getOnArbitraryKey(equipmentID, "key1");
    for(int i = 0; i < eqItems.size(); i++){
        WebBusinessObject wboTemp = (WebBusinessObject) eqItems.get(i);
        itemsID.add(wboTemp.getAttribute("itemId").toString());
    }
    
    
    String cMode= (String) request.getSession().getAttribute("currentMode");
    String  stat=cMode;
    String align=null;
    String dir=null;
    String style=null;
    String lang,langCode;
    
    String part_name, part_code, part_unit, part_price, select;
    String saving_status;
    String eq_name, cat_name;
    String title_1,title_2;
    String cancel_button_label;
    String save_button_label,info="No part founded";
    String fStatus;
    String sStatus;
    if(stat.equals("En")){
        
        saving_status="Saving status";
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        
        part_name="Part name";
        part_code="Part code";
        part_price="Part price";
        part_unit="Part unit";
        select="Select";
        eq_name="Equipment category name";
        cat_name="Category name";
        
        title_1="Add new equipment category part";
        title_2="All information are needed";
        cancel_button_label="Cancel ";
        save_button_label="Save ";
        langCode="Ar";
        sStatus="Saved Successfully";
        fStatus="Fail To Save";
    }else{
        
        saving_status="&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        
        eq_name="&#1575;&#1587;&#1605; &#1589;&#1606;&#1601; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;";
        cat_name="&#1575;&#1587;&#1605; &#1575;&#1604;&#1589;&#1606;&#1601;";
        part_name="&#1575;&#1587;&#1605; &#1575;&#1604;&#1602;&#1591;&#1593;&#1607;";
        part_code="&#1603;&#1608;&#1583; &#1575;&#1604;&#1602;&#1591;&#1593;&#1607;";
        part_price="&#1587;&#1593;&#1585; &#1575;&#1604;&#1602;&#1591;&#1593;&#1607;";
        part_unit="&#1608;&#1581;&#1583;&#1607; &#1602;&#1610;&#1575;&#1587; &#1575;&#1604;&#1602;&#1591;&#1593;&#1607;";
        select="&#1575;&#1582;&#1578;&#1585;";
        info="&#1604;&#1575; &#1610;&#1608;&#1580;&#1583; &#1602;&#1591;&#1593;";
        title_1="&#1575;&#1590;&#1575;&#1601;&#1607; &#1602;&#1591;&#1593; &#1604;&#1589;&#1606;&#1601; &#1605;&#1593;&#1583;&#1607;";
        title_2="&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
        cancel_button_label="&#1573;&#1606;&#1607;&#1575;&#1569; ";
        save_button_label="&#1578;&#1587;&#1580;&#1610;&#1604; ";
        langCode="En";
        fStatus="&#1604;&#1600;&#1605; &#1610;&#1600;&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604;";
        sStatus="&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604; &#1576;&#1600;&#1606;&#1600;&#1580;&#1600;&#1575;&#1581;";
    }
    
    %>
    
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>Maintenance - Add new equipment item</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css"><LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
    </HEAD>
    
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
        function submitForm()
        {    
        document.ITEMS_FORM.action = "<%=context%>/ItemsServlet?op=SaveCatItem";
        document.ITEMS_FORM.submit();  
        }
        
        function refreshData(){
        document.ITEMS_FORM.action = "ItemsServlet?op=GetItemCatForm";
        document.ITEMS_FORM.submit();	
        }
        function cancelForm()
        {    
        document.ITEMS_FORM.action = "main.jsp";
        document.ITEMS_FORM.submit();  
        }
    </SCRIPT>
    <script src='ChangeLang.js' type='text/javascript'></script>
    <BODY>
        <LEFT>
        <FORM NAME="ITEMS_FORM" METHOD="POST">
            
            <DIV align="left" STYLE="color:blue;">
                <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
                <button  onclick="JavaScript: cancelForm();" class="button"><%=cancel_button_label%><IMG VALIGN="BOTTOM"   SRC="images/cancel.gif"> </button>
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
            if(null!=status){
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
            <TABLE dir="<%=dir%>" align="<%=align%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                <TR COLSPAN="2" ALIGN="<%=align%>">
                    <TD STYLE="<%=style%>" class='td'>
                        <FONT color='red' size='+1'><%=title_2%></FONT> 
                    </TD>
                    
                </TR>
            </TABLE>
            <br><br>
            <TABLE dir="<%=dir%>" align="<%=align%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                <TR>
                    <TD STYLE="<%=style%>" class='td'>
                        <LABEL FOR="equipmentName">
                            <p><b><%=eq_name%><font color="#FF0000">*</font></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="<%=style%>" class='td'>
                        <%
                        if(request.getParameter("equipmentID") != null){
        WebBusinessObject wbo = MaintainableMgr.getInstance().getOnSingleKey(request.getParameter("equipmentID"));
                        %>
                        <SELECT name="equipmentID" onchange="refreshData();" STYLE="width:230px">
                            <sw:WBOOptionList wboList='<%=unitsList%>' displayAttribute = "unitName" valueAttribute="id" scrollTo="<%=wbo.getAttribute("unitName").toString()%>"/>
                        </SELECT>
                        <%
                        } else {
                        %>
                        <SELECT name="equipmentID" onchange="refreshData();" STYLE="width:230px">
                            <sw:WBOOptionList wboList='<%=unitsList%>' displayAttribute = "unitName" valueAttribute="id"/>
                        </SELECT>
                        <%
                        }
                        %>
                    </TD>
                </TR>
                <TR>
                    
                </TR>
                <TR>
                    <TD STYLE="<%=style%>"class='td'>
                        <LABEL FOR="categoryID">
                            <p><b><%=cat_name%><font color="#FF0000">*</font></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="<%=style%>"class='td'>
                        <%
                        if(request.getParameter("categoryID") != null){
        WebBusinessObject wbo = categoryMgr.getOnSingleKey(request.getParameter("categoryID"));
                        %>
                        <SELECT name="categoryID" onchange="refreshData();" STYLE="width:230px">
                            <sw:WBOOptionList wboList='<%=category%>' displayAttribute = "categoryName" valueAttribute="categoryId" scrollTo="<%=wbo.getAttribute("categoryName").toString()%>"/>
                        </SELECT>
                        <%
                        } else {
                        %>
                        <SELECT name="categoryID" onchange="refreshData();" STYLE="width:230px">
                            <sw:WBOOptionList wboList='<%=category%>' displayAttribute = "categoryName" valueAttribute="categoryId"/>
                        </SELECT>
                        <%
                        }
                        %>
                    </TD>
                </TR>
            </TABLE>
            
            <%
            if(request.getParameter("categoryID") != null){
        items = maintenanceItemMgr.getOnArbitraryKey(request.getParameter("categoryID"), "key2");
            /*arrList = new ArrayList();
            for(int i = 0; i < items.size(); i++){
            arrList.add(items.elementAt(i));
            }*/
            } else if(category != null && category.size() > 0){
        items = maintenanceItemMgr.getOnArbitraryKey(((WebBusinessObject) category.get(0)).getAttribute("categoryId").toString(), "key2");
            /*arrList = new ArrayList();
            for(int i = 0; i < items.size(); i++){
            arrList.add(items.elementAt(i));
            }*/
            } else {
        items = null;
            }
    
    if(items != null){
            %>
            <BR>
            <TABLE dir="<%=dir%>" align="<%=align%>"  CELLPADDING="0" CELLSPACING="0" BORDER="0" STYLE="border-right-WIDTH:1px;">
                <TR CLASS="head">
                    <TD CLASS="firstname"  STYLE="border-top-WIDTH:0; font-size:12">
                        <%=part_name%>
                    </TD>
                    <TD CLASS="firstname"  STYLE="border-top-WIDTH:0; font-size:12">
                        <%=part_unit%>
                    </TD>
                    <TD CLASS="firstname"  STYLE="border-top-WIDTH:0; font-size:12">
                        <%=part_price%>
                    </TD>
                    <TD CLASS="firstname"  STYLE="border-top-WIDTH:0; font-size:12">
                        <%=part_code%>
                    </TD>
                    <TD VALIGN="BOTTOM" STYLE="border-top-WIDTH:0;" WIDTH="33">
                        <B>
                            <%=select%>
                        </B>
                    </TD>
                </TR>
                <%
                for(int i = 0; i < items.size(); i++){
                    WebBusinessObject wbo = (WebBusinessObject) items.elementAt(i);
                %>
                <TR>
                    <TD CLASS="act_sub_heading" WIDTH="200" STYLE="<%=style%>;padding-left:20;">
                        <%=wbo.getAttribute("itemDscrptn").toString()%>
                    </TD>
                    <%
                    ItemUnitMgr itemUnitMgr = ItemUnitMgr.getInstance();
                    WebBusinessObject wboTemp = itemUnitMgr.getOnSingleKey((String) wbo.getAttribute("itemUnit"));
                    %>
                    <TD CLASS="act_sub_heading" WIDTH="100" STYLE="text-align:center;">
                        <%=wboTemp.getAttribute("unitName").toString()%>
                    </TD>
                    <TD CLASS="act_sub_heading" WIDTH="100" STYLE="text-align:center;">
                        <%=wbo.getAttribute("itemUnitPrice").toString()%>
                    </TD>
                    <TD CLASS="act_sub_heading" WIDTH="200" STYLE="<%=style%>;padding-left:20;">
                        <%=wbo.getAttribute("itemCode").toString()%>
                    </TD>
                    <TD  CLASS="cell" style="<%=style%>">
                        <%
                        if(itemsID.contains(wbo.getAttribute("itemID").toString())){
                        %>
                        <INPUT TYPE="CHECKBOX" NAME="items" VALUE="<%=wbo.getAttribute("itemID").toString()%>" CHECKED>
                            <%
                            } else {
                            %>
                            <INPUT TYPE="CHECKBOX" NAME="items" VALUE="<%=wbo.getAttribute("itemID").toString()%>">
                        <%
                            }
                        %>
                    </TD>
                </TR>
                <%
                }
                %>
            </TABLE>
            <%
            } else {
            %>
            <BR><%=info%>
            <%
            }
            %>
            
        </FORM>
        <BR><BR>
    </BODY>
</HTML>

