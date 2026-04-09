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
        if(unit.getAttribute("isMaintainable").toString().equalsIgnoreCase("0")){
            unitsList.remove(i);
            i = i-1;
        }
    }
    
    WebBusinessObject unitWbo = null;
    MaintenanceItemMgr maintenanceItemMgr = MaintenanceItemMgr.getInstance();
    CategoryMgr categoryMgr = CategoryMgr.getInstance();
    Vector items = new Vector();
    ArrayList arrList = new ArrayList();
    ItemCatsMgr itemCatsMgr = ItemCatsMgr.getInstance();
    String equipmentID = new String("");
    if(request.getParameter("equipmentID") != null){
        equipmentID = request.getParameter("equipmentID");
    } else if(unitsList.size() > 0){
        equipmentID = ((WebBusinessObject) unitsList.get(0)).getAttribute("id").toString();
    }
    Vector eqItems = new Vector();
    Vector itemsID = new Vector();
    eqItems = itemCatsMgr.getOnArbitraryKey(equipmentID, "key1");
    for(int i = 0; i < eqItems.size(); i++){
        WebBusinessObject wboTemp = (WebBusinessObject) eqItems.get(i);
        itemsID.add(wboTemp.getAttribute("itemID").toString());
    }
    
    
String cMode= (String) request.getSession().getAttribute("currentMode");
    String  stat=cMode;
    String align=null;
    String dir=null;
    String style=null;
    String lang,langCode;
    
    String saving_status;
    String title_1,title_2;
    String head_1,head_2,field_1_1;
    String part_name,part_unit,part_code,eq_cat_name,cat,part_price;
    String cancel_button_label,note;
    String save_button_label;
    if(stat.equals("En")){

        saving_status="Saving status";
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        
        head_1="Quick summary";
        head_2="Basic operations";
       
        field_1_1="view parts";
        
        part_name="Part name";
        part_unit="Part unit";
        part_code="Part code";
        eq_cat_name="Category name";
        cat="Catergory";
        part_price="Part price";
        title_1="List equipment spare parts";
        title_2="All information are needed";
        note="There is no parts for this category";
        cancel_button_label="Cancel";
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
     
        part_name="&#1573;&#1587;&#1605; &#1575;&#1604;&#1602;&#1591;&#1593;&#1607;";
        part_unit="&#1608;&#1581;&#1583;&#1577; &#1575;&#1604;&#1602;&#1610;&#1575;&#1587;";
        part_code="&#1603;&#1608;&#1583; &#1575;&#1604;&#1602;&#1591;&#1593;&#1607;";
        eq_cat_name="&#1573;&#1587;&#1605; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;";
        cat="&#1575;&#1604;&#1589;&#1606;&#1601; ";
        part_price="&#1587;&#1593;&#1585; &#1575;&#1604;&#1602;&#1591;&#1593;&#1607;";
        note="&#1604;&#1575; &#1610;&#1608;&#1580;&#1583; &#1602;&#1591;&#1593; &#1594;&#1610;&#1575;&#1585; &#1578;&#1581;&#1578; &#1607;&#1584;&#1575; &#1575;&#1604;&#1589;&#1606;&#1601; &#1605;&#1606; &#1575;&#1604;&#1605;&#1593;&#1583;&#1575;&#1578;";
        title_1="&#1593;&#1585;&#1590; &#1602;&#1591;&#1593; &#1594;&#1610;&#1575;&#1585; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;";
        title_2="&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
        cancel_button_label=" &#1573;&#1606;&#1607;&#1575;&#1569;   ";
        save_button_label=" &#1581;&#1584;&#1601; &#1575;&#1604;&#1589;&#1606;&#1601;";
        langCode="En";
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
        document.ITEMS_FORM.action = "<%=context%>/ItemsServlet?op=SaveItem";
        document.ITEMS_FORM.submit();  
        }
        
        function refreshData(){
        document.ITEMS_FORM.action = "ItemsServlet?op=EquipmentItemsReport";
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
        
        <FORM NAME="ITEMS_FORM" METHOD="POST">
                   <DIV align="left" STYLE="color:blue;">
            <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
            <button  onclick="JavaScript: cancelForm();" class="button"><%=cancel_button_label%><IMG VALIGN="BOTTOM"   SRC="images/cancel.gif"> </button>
      
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
                        <LABEL FOR="equipmentName">
                            <p><b> <%=eq_cat_name%><font color="#FF0000">*</font></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="<%=style%>" class='td'>
                        <%
                        if(request.getParameter("equipmentID") != null){
        WebBusinessObject wbo = MaintainableMgr.getInstance().getOnSingleKey(request.getParameter("equipmentID"));
                        %>
                        <SELECT name="equipmentID" onchange="refreshData();">
                            <sw:WBOOptionList wboList='<%=unitsList%>' displayAttribute = "unitName" valueAttribute="id" scrollTo="<%=wbo.getAttribute("unitName").toString()%>"/>
                        </SELECT>
                        <%
                        } else {
                        %>
                        <SELECT name="equipmentID" onchange="refreshData();">
                            <sw:WBOOptionList wboList='<%=unitsList%>' displayAttribute = "unitName" valueAttribute="id"/>
                        </SELECT>
                        <%
                        }
                        %>
                    </TD>
                </TR>
                <TR>
                    <TD class='td' COLSPAN="2">
                        &nbsp;
                    </TD>
                </TR>
                <!--TR>
                    <TD class='td'>
                        <LABEL FOR="categoryID">
                            <p><b>Category Name<font color="#FF0000">*</font></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD class='td'>
                        <1%
                        if(request.getParameter("categoryID") != null){
        WebBusinessObject wbo = categoryMgr.getOnSingleKey(request.getParameter("categoryID"));
                        %>
                        <SELECT name="categoryID" onchange="refreshData();">
                            <1sw:WBOOptionList wboList='<1%=category%>' displayAttribute = "categoryName" valueAttribute="categoryId" scrollTo="<1%=wbo.getAttribute("categoryName").toString()%>"/>
                        </SELECT>
                        <1%
                        } else {
                        %>
                        <SELECT name="categoryID" onchange="refreshData();">
                            <1sw:WBOOptionList wboList='<1%=category%>' displayAttribute = "categoryName" valueAttribute="categoryId"/>
                        </SELECT>
                        <1%
                        }
                        %>
                    </TD>
                </TR-->
            </TABLE>
            
            <%
            //if(request.getParameter("categoryID") != null){
            //items = maintenanceItemMgr.getOnArbitraryKey(request.getParameter("categoryID"), "key2");
            //} else if(category != null){
            if(itemsID.size() > 0){
        for(int j = 0; j < category.size(); j++){
            %>
            
            <TABLE align="<%=align%>" dir=<%=dir%> CELLPADDING="0" CELLSPACING="0" BORDER="0" STYLE="border-right-WIDTH:1px;" WIDTH="70%">
                <%
                items = maintenanceItemMgr.getOnArbitraryKey(((WebBusinessObject) category.get(j)).getAttribute("categoryId").toString(), "key2");
                boolean hasItems = false;
                for(int i = 0; i < items.size(); i++){
                    WebBusinessObject wbo = (WebBusinessObject) items.elementAt(i);
                    if(itemsID.contains(wbo.getAttribute("itemID").toString())){
                        hasItems = true;
                    }
                }
                if(items != null && items.size() > 0 && hasItems){
                %>
                <TR>
                    <TD BGCOLOR="#c8d8f8" STYLE="<%=style%>" VALIGN="MIDDLE">
                        <B><%=cat%> </B><font color="red"> <%=((WebBusinessObject) category.get(j)).getAttribute("categoryName").toString()%></font>
                    </TD>
                </TR> <TR>
                    <TD STYLE="<%=style%>">
                        
                        <TABLE align="<%=align%>" dir=<%=dir%> CELLPADDING="0" CELLSPACING="0" BORDER="0" STYLE="border-right-WIDTH:1px;" WIDTH="100%">
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
                            </TR>
                            <%
                            for(int i = 0; i < items.size(); i++){
                                WebBusinessObject wbo = (WebBusinessObject) items.elementAt(i);
                                if(itemsID.contains(wbo.getAttribute("itemID").toString())){
                            %>
                            <TR>
                                <TD CLASS="act_sub_heading" WIDTH="200" STYLE="<%=style%>;padding-left:20;">
                                    <%=wbo.getAttribute("itemDscrptn").toString()%>
                                </TD>
                                <%
                                ItemUnitMgr itemUnitMgr = ItemUnitMgr.getInstance();
                                WebBusinessObject wboTemp = itemUnitMgr.getOnSingleKey((String) wbo.getAttribute("itemUnit"));
                                %>
                                <TD CLASS="act_sub_heading" WIDTH="100" STYLE="<%=style%>">
                                    <%=wboTemp.getAttribute("unitName").toString()%>
                                </TD>
                                <TD CLASS="act_sub_heading" WIDTH="100" STYLE="<%=style%>">
                                    <%=wbo.getAttribute("itemUnitPrice").toString()%>
                                </TD>
                                <TD CLASS="act_sub_heading" WIDTH="200" STYLE="<%=style%>padding-left:20;">
                                    <%=wbo.getAttribute("itemCode").toString()%>
                                </TD>
                            </TR>
                            <%
                                }
                            }
                            %>
                        </TABLE>
                        <%
                        }
                        %>
                    </TD>
                </TR>
            </TABLE>
            <%
            }
            } else {
            %>
            <br><br><br>
            <table align="right" ><tr><td class="td" style="<%=style%>">
                         <H2><%=note%></H2>
                </td></tr>
            </table>
            <%
            }
            %>
        </FORM>
        <br><br><br>
    </BODY>
</HTML>

