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
    ArrayList supplierArr = (ArrayList) request.getAttribute("supplierArr");
    ArrayList category = (ArrayList) request.getAttribute("category");
    
    
    WebBusinessObject unitWbo = null;
    MaintenanceItemMgr maintenanceItemMgr = MaintenanceItemMgr.getInstance();
    CategoryMgr categoryMgr = CategoryMgr.getInstance();
    Vector items = new Vector();
    ArrayList arrList = new ArrayList();
    SupplierItemMgr supplierItemMgr = SupplierItemMgr.getInstance();
    String supplierID = new String("");
    if(request.getParameter("supplierID") != null){
        supplierID = request.getParameter("supplierID");
    } else if(supplierArr.size() > 0){
        supplierID = ((WebBusinessObject) supplierArr.get(0)).getAttribute("id").toString();
    }
    Vector eqItems = new Vector();
    Vector itemsID = new Vector();
    eqItems = supplierItemMgr.getOnArbitraryKey(supplierID, "key1");
    for(int i = 0; i < eqItems.size(); i++){
        WebBusinessObject wboTemp = (WebBusinessObject) eqItems.get(i);
        itemsID.add(wboTemp.getAttribute("itemID").toString());
    }
    
    
    String cMode= (String) request.getSession().getAttribute("currentMode");
    String  stat=cMode;
    String align=null;
    String dir=null;
    String style=null;
    String lang,langCode,tit,save,cancel,TT,IG,AS,QS,BO,CD,PN,NAS,PL,PART,cat,Unit,PP,code;
    if(stat.equals("En")){
        
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        langCode="Ar";
        tit="Delete Schedule - Are you Sure ?";
        save="Delete";
        cancel="Cancel";
        TT="Task Title ";
        IG="Indicators guide ";
        AS="Supplier Name";
        NAS="Non Active Site";
        QS="Quick Summary";
        BO="Basic Operations";
        
        CD="There is No Parts Under This Supplier ";
        PN="Projects No.";
        PL="Parts List According To Suppliers";
        PART="Part Name";
        cat="Category";
        Unit="Unit";
        PP="Part price";
        code="Part Code";
    }else{
        
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        langCode="En";
        tit=" &#1581;&#1584;&#1601; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607; - &#1607;&#1604; &#1571;&#1606;&#1578; &#1605;&#1578;&#1571;&#1603;&#1583;&#1567;";
        save=" &#1573;&#1581;&#1584;&#1601;";
        cancel=" &#1573;&#1606;&#1607;&#1575;&#1569;";
        TT="&#1593;&#1606;&#1608;&#1575;&#1606; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607;";
        IG="&#1575;&#1604;&#1605;&#1585;&#1588;&#1583; &#1575;&#1604;&#1605;&#1589;&#1608;&#1585;";
        AS="&#1573;&#1587;&#1605; &#1575;&#1604;&#1605;&#1608;&#1585;&#1583;";
        NAS="&#1605;&#1608;&#1602;&#1593; &#1604;&#1575; &#1578;&#1593;&#1605;&#1604; &#1576;&#1607; &#1605;&#1593;&#1583;&#1575;&#1578;";
        QS="&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1587;&#1585;&#1610;&#1593;&#1577;";
        BO="&#1593;&#1605;&#1604;&#1610;&#1575;&#1578; &#1571;&#1587;&#1575;&#1587;&#1610;&#1577;";
        
        CD="&#1604;&#1575;&#1610;&#1608;&#1580;&#1583; &#1602;&#1591;&#1593; &#1578;&#1575;&#1576;&#1593;&#1607; &#1604;&#1607;&#1584;&#1575; &#1575;&#1604;&#1605;&#1608;&#1585;&#1583;";
        PN=" &#1593;&#1583;&#1583; &#1575;&#1604;&#1605;&#1608;&#1575;&#1602;&#1593;";
        PL=" &#1593;&#1585;&#1590; &#1575;&#1604;&#1602;&#1591;&#1593; &#1575;&#1604;&#1582;&#1575;&#1589;&#1607; &#1576;&#1603;&#1604; &#1605;&#1608;&#1585;&#1583;";
        PART="&#1573;&#1587;&#1605; &#1575;&#1604;&#1602;&#1591;&#1593;&#1607;";
        cat=" &#1575;&#1604;&#1589;&#1606;&#1601;";
        Unit="&#1608;&#1581;&#1583;&#1577; &#1575;&#1604;&#1602;&#1610;&#1575;&#1587;";
        PP=" &#1579;&#1605;&#1606; &#1575;&#1604;&#1602;&#1591;&#1593;&#1607;";
        code="&#1575;&#1604;&#1603;&#1608;&#1583;";
    }
    
    %>
    
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>Maintenance - Add new equipment item</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>
    
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
        function submitForm()
        {    
        document.ITEMS_FORM.action = "<%=context%>/ItemsServlet?op=SaveItem";
        document.ITEMS_FORM.submit();  
        }
         function cancelForm()
        {    
        document.ITEMS_FORM.action = "<%=context%>/main.jsp";
        document.ITEMS_FORM.submit();  
        }
        
        function refreshData(){
        document.ITEMS_FORM.action = "ItemsServlet?op=SupplierItemsReport";
        document.ITEMS_FORM.submit();	
        }
        
        function reloadAE(nextMode){
      
       var url = "<%=context%>/ajaxGetItrmName?key="+nextMode;
            if (window.XMLHttpRequest)
            { 
                req = new XMLHttpRequest(); 
            } 
               else if (window.ActiveXObject)
            { 
                req = new ActiveXObject("Microsoft.XMLHTTP"); 
            } 
            req.open("Post",url,true); 
            req.onreadystatechange =  callbackFillreload;
            req.send(null);
      
      }

       function callbackFillreload(){
         if (req.readyState==4)
            { 
               if (req.status == 200)
                { 
                     window.location.reload();
                }
            }
       }
       
           function changeMode(name){
            if(document.getElementById(name).style.display == 'none'){
                document.getElementById(name).style.display = 'block';
            } else {
                document.getElementById(name).style.display = 'none';
            }
        }
    </SCRIPT>
    
    <BODY>
        
        <DIV align="left" STYLE="color:blue;">
            <input type="button"  value="<%=lang%>"  onclick="reloadAE('<%=langCode%>')" class="button">
            <button  onclick="JavaScript: cancelForm();" class="button" ><%=cancel%><IMG VALIGN="BOTTOM"   SRC="images/cancel.gif"> </button>
            
        </DIV> 
        
        <fieldset align=center class="set">
        <legend align="center">
            
            <table dir=" <%=dir%>" align="<%=align%>">
                <tr>
                    
                    <td class="td">
                        <font color="blue" size="6"><%=PL%> 
                        </font>
                    </td>
                </tr>
            </table>
        </legend >
        
        <FORM NAME="ITEMS_FORM" METHOD="POST">
            <TABLE DIR="<%=dir%>" ALIGN="<%=align%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                <TR>
                    <TD STYLE="<%=style%> " class='td'>
                        <LABEL FOR="supplierID">
                            <p><b><%=AS%><font color="#FF0000">*</font></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="<%=style%> " class='td'>
                        <%
                        if(request.getParameter("supplierID") != null){
        WebBusinessObject wbo = SupplierMgr.getInstance().getOnSingleKey(request.getParameter("supplierID"));
                        String  supplierName = wbo.getAttribute("name").toString();
                        %>
                        <SELECT name="supplierID" onchange="refreshData();" STYLE="width:230px">
                            <sw:WBOOptionList wboList='<%=supplierArr%>' displayAttribute = "name" valueAttribute="id" scrollTo="<%=supplierName%>"/>
                        </SELECT>
                        <%
                        } else {
                        %>
                        <SELECT name="supplierID" onchange="refreshData();" STYLE="width:230px">
                            <sw:WBOOptionList wboList='<%=supplierArr%>' displayAttribute = "name" valueAttribute="id"/>
                        </SELECT>
                        <%
                        }
                        %>
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
            </TABLE><br><br>
            
            <%
            //if(request.getParameter("categoryID") != null){
            //items = maintenanceItemMgr.getOnArbitraryKey(request.getParameter("categoryID"), "key2");
            //} else if(category != null){
            if(itemsID.size() > 0){
        for(int j = 0; j < category.size(); j++){
            %>
            <BR>
            <TABLE DIR="<%=dir%>" ALIGN="<%=align%>" CELLPADDING="0" CELLSPACING="0" BORDER="0" STYLE="border-right-WIDTH:1px;" WIDTH="70%">
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
            
            <TABLE ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="400" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
                
                <TR>
                    <TD BGCOLOR="#c8d8f8" STYLE="<%=style%>" VALIGN="MIDDLE">
                        <B><%=cat%> : <%=((WebBusinessObject) category.get(j)).getAttribute("categoryName").toString()%></B>
                    </TD>
                </TR>
                <TR>
                    <TD CLASS="td" COLSPAN="4" bgcolor="#808000" STYLE="text-align:center;color:white;font-size:16">
                        <B><%=QS%></B>
                    </TD>
                    
                </tr>
                
                
                <TR>
                    <TD STYLE="<%=style%>">
                        
                        <TABLE DIR="<%=dir%>" ALIGN="<%=align%>" CELLPADDING="0" CELLSPACING="0" BORDER="0" STYLE="border-right-WIDTH:1px;" WIDTH="100%">
                            <TR CLASS="head">
                                <TD CLASS="firstname" BGCOLOR="#9B9B00" STYLE="text-align:center;color:white;font-size:12">
                                    <%=PART%> 
                                </TD>
                                <TD CLASS="firstname"  BGCOLOR="#9B9B00" STYLE="text-align:center;color:white;font-size:12">
                                    <%=Unit%>
                                </TD>
                                <TD CLASS="firstname"  BGCOLOR="#9B9B00" STYLE="text-align:center;color:white;font-size:12">
                                    <%=PP%>
                                </TD>
                                <TD CLASS="firstname"  BGCOLOR="#9B9B00" STYLE="text-align:center;color:white;font-size:12">
                                    <%=code%>
                                </TD>
                            </TR>
                            <%
                            for(int i = 0; i < items.size(); i++){
                                WebBusinessObject wbo = (WebBusinessObject) items.elementAt(i);
                                if(itemsID.contains(wbo.getAttribute("itemID").toString())){
                            %>
                            <TR>
                                <TD  BGCOLOR="#DDDD00" WIDTH="200" STYLE="<%=style%>;padding-right:20;">
                                    <%=wbo.getAttribute("itemDscrptn").toString()%>
                                </TD>
                                <%
                                ItemUnitMgr itemUnitMgr = ItemUnitMgr.getInstance();
                                WebBusinessObject wboTemp = itemUnitMgr.getOnSingleKey((String) wbo.getAttribute("itemUnit"));
                                %>
                                <TD  BGCOLOR="#DDDD00" WIDTH="100" STYLE="<%=style%>">
                                    <%=wboTemp.getAttribute("unitName").toString()%>
                                </TD>
                                <TD  BGCOLOR="#DDDD00" WIDTH="100" STYLE="<%=style%>">
                                    <%=wbo.getAttribute("itemUnitPrice").toString()%>
                                </TD>
                                <TD  BGCOLOR="#DDDD00" WIDTH="200" STYLE="<%=style%>;padding-right:20;">
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
            <table dir="<%=dir%>" align="<%=align%>">
                <tr>
                    <td class="td">
                        <H2 ><%=CD%></H2>
                        
            </td></tr></table>
            <%
            }
            %>
        </FORM>
    </BODY>
</HTML>

