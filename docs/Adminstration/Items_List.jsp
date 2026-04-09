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

String[] itemAttributes = {"itemDscrptn"};
String[] itemListTitles = {"&#1575;&#1587;&#1605; &#1602;&#1591;&#1593;&#1577; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585;", "&#1605;&#1588;&#1575;&#1607;&#1583;&#1577;", "&#1578;&#1581;&#1585;&#1610;&#1585;", "&#1581;&#1584;&#1601;"};//,"Add Supplier &#1573;&#1590;&#1575;&#1601;&#1577; &#1605;&#1608;&#1585;&#1583;", "View Supplier &#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1605;&#1608;&#1585;&#1583;", "Attach File &#1573;&#1585;&#1601;&#1602; &#1605;&#1587;&#1578;&#1606;&#1583;","View Files &#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583;", "View Images &#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1575;&#1604;&#1589;&#1608;&#1585;"};

int s = itemAttributes.length;
int t = s + 3;
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
if(stat.equals("En")){
    
    saving_status="Saving status";
    align="center";
    dir="LTR";
    style="text-align:left";
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
    String[] x={"Part name","View","Edit","Delete"};
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

<table align="center" border="0" width="100%">
    <tr>
        <td STYLE="border:0px;">
            <div STYLE="width:75%;border:2px solid gray;background-color:#808000;color:white;" bgcolor="#F3F3F3" align="center">
                <div ONCLICK="JavaScript: changeMode('menu1');" STYLE="width:100%;background-color:#808000;color:white;cursor:hand;font-size:14;">
                    <b>
                        <%=indicator_guide_f%>
                    </b>
                    <img src="images/arrow_down.gif">
                </div>
                <div ALIGN="center" STYLE="width:100%;background-color:#FFFFCC;color:white;display:none;<%=style%>border-top:2px solid gray;" ID="menu1">
                    <table align="center" border="0" dir="<%=dir%>" width="100%" cellspacing="2">
                        <tr>
                            <td CLASS="cell" bgcolor="#B7B700" STYLE="color:white;<%=style%>" width="33%"><IMG SRC="images/active.jpg" ALT="Active Part" ALIGN="center"> <B><%=AP%></B></td>
                            <td CLASS="cell" bgcolor="#B7B700" STYLE="color:white;<%=style%>" width="33%"><IMG SRC="images/nonactive.jpg" ALT="Non Active Part" ALIGN="center"> <B><%=NAP%></B></td>
                       
                        </tr>
                    </table>
                </div>
            </div>
        </td>
    </tr>
</table>

<DIV align="left" STYLE="color:blue;">
    <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
    <button  onclick="JavaScript: changePage('<%=context%>//ItemsServlet?op=ListItembyCategory');" class="button"><%=cancel_button_label%><IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif"> </button>
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
    <B><font color="red" size="3"><%=parts_numb%> : <%=itemList.size()%> <%=piece_word%></B></font>
</DIV>

<BR>

<TABLE align="<%=align%>" dir=<%=dir%> WIDTH="60" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
    <%
    if(size > 1){
    %>
    <tr>
        <td colspan="5" style="color:white;font-size:14px" BGCOLOR="#808080">
            <div align="center">
                <a href="<%=context%>/ItemsServlet?op=ViewItems&categoryId=<%=categoryId%>&pIndex=1" style="color:white;font-size:14px"><<</a>
                <%
                if(index > 1){
                %>
                <a href="<%=context%>/ItemsServlet?op=ViewItems&categoryId=<%=categoryId%>&pIndex=<%=index - 1%>" style="color:white;font-size:14px"><</a>
                <%
                } else {
                %>
                <b><</b> 
                <%
                }
                if(size > 10){
                    int maxPage = index + 5;
                    int minPage = index - 5;
                    if(maxPage > size){
                        maxPage = size;
                    }
                    if(minPage < 1){
                        minPage = 1;
                    }
                    for(int i = minPage; i <= maxPage; i++){
                        if(i != index){
                %>
                <a href="<%=context%>/ItemsServlet?op=ViewItems&categoryId=<%=categoryId%>&pIndex=<%=i%>" style="color:white;font-size:14px"><%=i%></a>
                <%
                        } else {
                %>
                <b><%=i%></b>
                <%
                        }
                    }
                } else {
                    for(int i = 1; i <= size; i++){
                        if(i != index){
                %>
                <a href="<%=context%>/ItemsServlet?op=ViewItems&categoryId=<%=categoryId%>&pIndex=<%=i%>" style="color:white;font-size:14px"><%=i%></a>
                <%
                        } else {
                %>
                <b><%=i%></b>
                <%
                        }
                    }
                }
                
                if(index < size){
                %>
                <a href="<%=context%>/ItemsServlet?op=ViewItems&categoryId=<%=categoryId%>&pIndex=<%=index + 1%>" style="color:white;font-size:14px">></a>
                <%
                } else {
                %>
                <b>></b>
                <%
                }
                %>
                <a href="<%=context%>/ItemsServlet?op=ViewItems&categoryId=<%=categoryId%>&pIndex=<%=size%>" style="color:white;font-size:14px">>></a>
            </div>
        </td>
    </tr>
    <%
    }
    %>
    <TR>
        <TD CLASS="td" COLSPAN="1" bgcolor="#808000" STYLE="text-align:center;color:white;font-size:16">
            <B><%=summery_f%></B>
        </TD>
        <TD CLASS="td" COLSPAN="3" bgcolor="#669900" STYLE="text-align:center;color:white;font-size:16">
            <B><%=basic_operation_f%></B>
        </TD>
        <TD CLASS="td" COLSPAN="1" bgcolor="#CC9900" STYLE="text-align:center;color:white;font-size:16">
            <B><%=indicator_guide_f%></B>
        </TD>
    </TR>
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
        
        <TD nowrap CLASS="firstname" WIDTH="150" bgcolor="<%=columnColor%>" STYLE="border-WIDTH:0; font-size:12;color:white;" nowrap>
            <%=itemListTitles[i]%>
            </TD>
        
        
        
        <%
        }
        %>
        <TD nowrap CLASS="firstname" BGCOLOR="#FFBF00" WIDTH="135" STYLE="border-WIDTH:0; font-size:12" COLSPAN="1" nowrap>
            &nbsp;
            </TD>
        
    </TR>  
    <%
    
    Enumeration e = itemList.elements();
    
    if(size > 0){
        for(int j = (number * (index - 1)); j < max; j++){
            iTotal++;
            wbo = (WebBusinessObject) itemList.get(j);
            
            flipper++;
            if((flipper%2) == 1) {
                bgColor="#c8d8f8";
            } else {
                bgColor="white";
                
            }
    %>
    
    <TR>
        <%
        for(int i = 0;i<s;i++) {
                attName = itemAttributes[i];
                attValue = (String) wbo.getAttribute(attName);
        %>
        
        <TD  STYLE="text-align:center" nowrap  CLASS="cell" BGCOLOR="#DDDD00">
            <DIV > 
                
                <b> <%=attValue%> </b>
            </DIV>
        </TD>
        <%
        }
        %>
        
        <TD nowrap CLASS="cell" STYLE="padding-left:10;text-align:center;" BGCOLOR="#D7FF82">
            <DIV ID="links">
                <A HREF="<%=context%>/ItemsServlet?op=ShowItem&itemID=<%=wbo.getAttribute("itemID")%>&categoryId=<%=wbo.getAttribute("categoryId")%>&pIndex=<%=index%>">
                    <%=view%>
                </A>
            </DIV>
        </TD>
        
        <TD nowrap CLASS="cell" STYLE="padding-left:10;text-align:center;" BGCOLOR="#D7FF82">
            <DIV ID="links">
                <A HREF="<%=context%>/ItemsServlet?op=GetUpdateItem&itemID=<%=wbo.getAttribute("itemID")%>&categoryId=<%=wbo.getAttribute("categoryId")%>&pIndex=<%=index%>">
                    <%=edit%>
                </A>
            </DIV>
        </TD>
        <TD nowrap CLASS="cell" STYLE="padding-left:10;text-align:center;" BGCOLOR="#D7FF82">
            <DIV ID="links">
                <A HREF="<%=context%>/ItemsServlet?op=ConfirmDeleteItem&itemID=<%=wbo.getAttribute("itemID")%>&categoryId=<%=wbo.getAttribute("categoryId")%>&pIndex=<%=index%>">
                    <%=delete%>
                </A>
            </DIV>
        </TD>
        
        <!--TD nowrap CLASS="cell" STYLE="padding-left:10;<%=style%>">
                <DIV ID="links">
        <A HREF="<%//=context%>/SupplierServlet?op=GetItemSupplierForm&itemID=<%//=wbo.getAttribute("itemID")%>&categoryId=<%//=wbo.getAttribute("categoryId")%>">
                        &#1571;&#1590;&#1601; &#1605;&#1608;&#1585;&#1583;
                    </A>
                </DIV>
                
            </TD>
        <%
        //if(supplierItemMgr.hasSupplier(wbo.getAttribute("itemID").toString())) {
        %>
        <TD nowrap CLASS="cell" STYLE="padding-left:10;<%=style%>">
                <DIV ID="links">
        <A HREF="<%//=context%>/SupplierServlet?op=ListItemSuppliers&itemID=<%//=wbo.getAttribute("itemID")%>&categoryId=<%//=wbo.getAttribute("categoryId")%>">
                        &#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1575;&#1604;&#1605;&#1608;&#1585;&#1583;&#1610;&#1606;
                    </A>
                </DIV>
                
            </TD>
        <%
        //} else {
        %> 
        <TD nowrap CLASS="cell" STYLE="padding-left:10;<%=style%>">
                <DIV ID="links">
                    
                    &#1604;&#1575;&#1610;&#1608;&#1580;&#1583; &#1605;&#1608;&#1585;&#1583;&#1610;&#1606;
                    
                </DIV>
            </TD>
            
        <%
        //}
        %>
            
        <TD nowrap CLASS="cell" STYLE="padding-left:10;<%=style%>">
                <DIV ID="links">
        <A HREF="<%//=context%>/ItemDocWriterServlet?op=SelectFile&itemID=<%//=wbo.getAttribute("itemID")%>&categoryId=<%//=wbo.getAttribute("categoryId")%>">
                        &#1573;&#1585;&#1601;&#1602; &#1605;&#1587;&#1578;&#1606;&#1583;
                    </A>
                </DIV>
                
            </TD>
        <%
        //if(itemDocMgr.hasDocuments(wbo.getAttribute("itemID").toString())) {
        %>
            <TD nowrap CLASS="cell" STYLE="padding-left:10;text-align:left;">
                <DIV ID="links">
        <A HREF="<%//=context%>/ItemDocReaderServlet?op=ListDoc&itemID=<%//=wbo.getAttribute("itemID")%>&categoryId=<%//=wbo.getAttribute("categoryId")%>">
                        &#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583;&#1575;&#1578;
                    </A>
        <A HREF="<%//=context%>/ItemDocReaderServlet?op=ListDoc&itemID=<%//=wbo.getAttribute("itemID")%>&categoryId=<%//=wbo.getAttribute("categoryId")%>">
                        <IMG SRC="images/view.png"  ALT="view file">  
                    </A>
                </DIV>
                
            </TD>
            
        <%
        //} else {
        %> 
        <TD nowrap CLASS="cell" STYLE="padding-left:10;<%=style%>">
                <DIV ID="links">
                    
                    &#1604;&#1575; &#1610;&#1608;&#1580;&#1583; &#1605;&#1587;&#1578;&#1606;&#1583;&#1575;&#1578; &#1605;&#1585;&#1601;&#1602;&#1607;
                    
                </DIV>
            </TD>
            
        <%
        //}
        %>
        <%
        //if(itemDocMgr.hasImages(wbo.getAttribute("itemID").toString())) {
        %>
        <TD nowrap CLASS="cell" STYLE="padding-left:10;<%=style%>">
                <DIV ID="links">
        <A HREF="<%//=context%>/ItemDocReaderServlet?op=ViewImages&itemID=<%//=wbo.getAttribute("itemID")%>&categoryId=<%//=wbo.getAttribute("categoryId")%>">
                        &#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1575;&#1604;&#1589;&#1608;&#1585;
                    </A>
        <A HREF="<%//=context%>/ItemDocReaderServlet?op=ViewImages&itemID=<%//=wbo.getAttribute("itemID")%>&categoryId=<%//=wbo.getAttribute("categoryId")%>">
                        <IMG SRC="images/view.png"  ALT="view file">  
                    </A>
                </DIV>
                
            </TD>
            
        <%
        //} else {
        %> 
        <TD nowrap CLASS="cell" STYLE="padding-left:10;<%=style%>">
                <DIV ID="links">
                    
                    &#1604;&#1575; &#1610;&#1608;&#1580;&#1583; &#1589;&#1608;&#1585; &#1605;&#1585;&#1601;&#1602;&#1607;
                    
                </DIV>
            </TD-->
            
        <%
        //}
        %>
        
        <TD WIDTH="20px" nowrap CLASS="cell" BGCOLOR="#FFE391">
            <%
            if(itemMgr.getActiveItem(wbo.getAttribute("itemID").toString())) {
            %>
            <IMG SRC="images/active.jpg"  ALT="Active Part by Equipment"> 
            
            
            <%
            } else {
            %> 
            
            <IMG SRC="images/nonactive.jpg"  ALT="Non Active Part">
            <% } %>
        </TD>             
        
        
        
    </TR>
    
    
    <%
    
        }
    }
    %>
    <TR>
        <TD CLASS="cell" BGCOLOR="#808080" COLSPAN="4" STYLE="<%=style%>;color:white;font-size:14;">
            <B><%=parts_numb%></B>
        </TD>
        <TD CLASS="cell" BGCOLOR="#808080" colspan="1" STYLE="<%=style%>;color:white;font-size:14;">
            
            <DIV NAME="" ID="">
                <B><%=iTotal%></B>
            </DIV>
        </TD>
    </TR>
</table>
<BR>
</fieldset>



</body>
</html>
