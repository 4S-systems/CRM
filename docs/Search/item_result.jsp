<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    <HEAD>
        <TITLE>System Projects List</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css"><LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
        
    </HEAD>
    <%
    
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    
    //AppConstants appCons = new AppConstants();
    
    String[] itemAttributes = {"itemCode", "itemDscrptn", "itemQuantity"};
    String[] itemListTitles = {"&#1575;&#1604;&#1603;&#1608;&#1583;","&#1575;&#1587;&#1605; &#1602;&#1591;&#1593;&#1577; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585;", "&#1575;&#1604;&#1593;&#1583;&#1583; &#1575;&#1604;&#1605;&#1591;&#1604;&#1608;&#1576;"};
    
    int s = itemAttributes.length;
    int t = s;
    int iTotal = 0;
    
    String attName = null;
    String attValue = null;
    String cellBgColor = null;
    
    
    
    Vector  itemList = (Vector) request.getAttribute("data");
    
    
    WebBusinessObject wbo = null;
    int flipper = 0;
    String bgColor = null;
    
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
    
    ItemMgr itemMgr = ItemMgr.getInstance();
    ItemDocMgr itemDocMgr = ItemDocMgr.getInstance();
    SupplierItemMgr supplierItemMgr = SupplierItemMgr.getInstance();
    
    int number = 25;
    String pIndex = request.getParameter("pIndex");
    
    int size = (itemList.size() / number);
    System.out.println("Size of index = "+size);
    if((size * number) < itemList.size()){
        size++;
    }
    int index = 1;
    if(request.getParameter("pIndex") != null){
        if(!request.getParameter("pIndex").equals("null")){
            index = new Integer(request.getParameter("pIndex")).intValue();
        } else {
            index = 1;
        }
    }
    
    if(index > size){
        index = size;
    }
    int max = ((number * (index - 1)) + number);
    if(max > itemList.size()){
        max = itemList.size();
    }
    
    String categoryId = (String) request.getAttribute("categoryId");
    
    
    String cMode= (String) request.getSession().getAttribute("currentMode");
    String  stat=cMode;
    String align=null;
    String dir=null;
    String style=null;
    String lang,langCode;
    
    String saving_status;
    String title_1,title_2;
    String head_1,head_2,field_1_1;
    String cancel_button_label;
    String indicator_guide_f, NAP,basic_operation_f, summery_f, del_f, edit_f, view_f, part_name_f,AP;
    String view, edit, delete;
    String save_button_label;
    String parts_numb="&#1606;&#1578;&#1610;&#1580;&#1577; &#1575;&#1604;&#1593;&#1585;&#1590;";
    String piece_word="&#1602;&#1591;&#1593;&#1577;";
    String sTitle = new String("");
    if(stat.equals("En")){
        
        saving_status="Saving status";
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        String[] x={"Code","Part name","Quantity"};
        itemListTitles=x;
        summery_f="Quick summery";
        basic_operation_f="Basic operation";
        indicator_guide_f="Indicator guide";
        
        view="View";
        delete="Delete";
        edit="Edit";
        AP="Active Part ";
        NAP="Non Active Part ";
        head_1="Quick summary";
        head_2="Basic operations";
        piece_word="part";
        field_1_1="view parts";
        parts_numb="Parts number";
        title_1="List spare parts";
        title_2="All information are needed";
        cancel_button_label=" Back To List ";
        save_button_label="Delete category";
        langCode="Ar";
        sTitle = "Required Spare Parts from " + request.getParameter("beginDate") + " to " + request.getParameter("endDate");
    }else{
        NAP="&#1602;&#1591;&#1593;&#1577; &#1594;&#1610;&#1575;&#1585; &#1594;&#1610;&#1585; &#1605;&#1585;&#1578;&#1576;&#1591;&#1577;";
        saving_status="&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        
        head_1="&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1587;&#1585;&#1610;&#1593;&#1577;";
        head_2="&#1593;&#1605;&#1604;&#1610;&#1575;&#1578; &#1571;&#1587;&#1575;&#1587;&#1610;&#1577;";
        field_1_1="&#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1575;&#1604;&#1602;&#1591;&#1593;";
        
        view="&#1605;&#1588;&#1575;&#1607;&#1583;&#1607;";
        delete = "&#1581;&#1584;&#1601;";
        edit = "&#1578;&#1581;&#1585;&#1610;&#1585;";
        AP="&#1602;&#1591;&#1593;&#1577; &#1594;&#1610;&#1575;&#1585; &#1605;&#1585;&#1578;&#1576;&#1591;&#1577;";
        summery_f="&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1587;&#1585;&#1610;&#1593;&#1577;";
        basic_operation_f="&#1593;&#1605;&#1604;&#1610;&#1575;&#1578; &#1571;&#1587;&#1575;&#1587;&#1610;&#1577;";
        indicator_guide_f="&#1575;&#1604;&#1605;&#1585;&#1588;&#1583; &#1575;&#1604;&#1605;&#1589;&#1608;&#1585;";
        
        title_1=" &#1593;&#1585;&#1590; &#1602;&#1591;&#1593; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585;";
        title_2="&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
        cancel_button_label=" &#1593;&#1608;&#1583;&#1607; &#1575;&#1604;&#1610; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1607; ";
        save_button_label=" &#1581;&#1584;&#1601; &#1575;&#1604;&#1589;&#1606;&#1601;";
        langCode="En";
        sTitle = "&#1602;&#1591;&#1593; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585; &#1575;&#1604;&#1605;&#1591;&#1604;&#1608;&#1576;&#1577; &#1605;&#1606; " + request.getParameter("beginDate") + " &#1573;&#1604;&#1610; " + request.getParameter("endDate");
    }
    
    %>
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
    <body>
        
        <DIV align="left" STYLE="color:blue;">
            <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
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
            
            
            <BR><Br>
            
            <DIV align="center" STYLE="color:blue;">
                <B>
                    <font color="red" size="3">
                        <%=sTitle%>
                </B>
            </DIV>
            
            <BR>
            
            <TABLE align="<%=align%>" dir=<%=dir%> WIDTH="60" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
                <TR CLASS="head">
                    <%
                    String columnColor = new String("");
                    for(int i = 0;i<t;i++) {
                        if(i == 0){
                            columnColor = "#9B9B00";
                        } else {
                            columnColor = "#7EBB00";
                        }
                    %>
                    
                    <TD nowrap CLASS="firstname" WIDTH="150" bgcolor="<%=columnColor%>" STYLE="border-WIDTH:0; font-size:12;color:white;">
                        <%=itemListTitles[i]%>
                    </TD>
                    <%
                    }
                    %>
                </TR>  
                <%
                
                Enumeration e = itemList.elements();
                
                if(size > 0){
                for(int j = (number * (index - 1)); j < max; j++){
                iTotal++;
                wbo = (WebBusinessObject) itemList.get(j);
                
                %>
                
                <TR>
                <%
                for(int i = 0;i<s;i++) {
                attName = itemAttributes[i];
                attValue = (String) wbo.getAttribute(attName);
                String sColor = new String("#DDDD00");
                if(i > 0){
                sColor = new String("#D7FF82");
                }
                %>
                
                <TD  STYLE="text-align:center" nowrap  CLASS="cell" BGCOLOR="<%=sColor%>">
                    <DIV > 
                        
                        <b> <%=attValue%> </b>
                    </DIV>
                </TD>
                <%
                }
                }
                }
                %>
            </table>
            <BR>
        </fieldset>
        
        
        
    </body>
</html>
