<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.SupplierMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<HTML>
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Expires" CONTENT="0">
<HEAD>
    <TITLE>System Departments List</TITLE>
    <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css"><LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
</HEAD>
<%

MetaDataMgr metaMgr = MetaDataMgr.getInstance();
String context = metaMgr.getContext();

//AppConstants appCons = new AppConstants();

String[] supplierAttributes = {"supplierID"};
String[] supplierListTitles = {"&#1573;&#1587;&#1605; &#1575;&#1604;&#1605;&#1608;&#1585;&#1583;", "&#1605;&#1588;&#1575;&#1607;&#1583;&#1577;", "&#1578;&#1581;&#1585;&#1610;&#1585;", "&#1581;&#1584;&#1601;"};

int s = supplierAttributes.length;
int t = s+3;
int iTotal = 0;

String attName = null;
String attValue = null;
String cellBgColor = null;



Vector  supplierList = (Vector) request.getAttribute("data");


WebBusinessObject wbo = null;
int flipper = 0;
String bgColor = null;

TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

SupplierMgr supplierMgr = SupplierMgr.getInstance();

String itemID = request.getAttribute("itemID").toString();
String categoryId = request.getAttribute("categoryId").toString();
String pIndex = request.getParameter("pIndex");





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
String sup_num="Suppliers number";
//String indicator_guide_f, basic_operation_f, summery_f, del_f, edit_f, view_f, part_name_f;
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
    String[] x={"Supplier name","View","Edit","Delete"};
    supplierListTitles  =x;
    
    //view="View";edit="Edit";delete="Delete";
    
    head_1="Quick summary";
    head_2="Basic operations";
    piece_word="part";
    field_1_1="view parts";
    parts_numb="Parts number";
    title_1="List suppliers";
    title_2="All information are needed";
    cancel_button_label=" Return to menu ";
    save_button_label="Delete category";
    langCode="Ar";
}else{
    
    saving_status="&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
    align="center";
    dir="RTL";
    style="text-align:Right";
    lang="English";
    sup_num="&#1593;&#1583;&#1583; &#1575;&#1604;&#1605;&#1608;&#1585;&#1583;&#1610;&#1606;";
    //"&#1605;&#1588;&#1575;&#1607;&#1583;&#1577;", "&#1578;&#1581;&#1585;&#1610;&#1585;", "&#1581;&#1584;&#1601;"};
   // view="&#1605;&#1588;&#1575;&#1607;&#1583;&#1577;";edit="&#1578;&#1581;&#1585;&#1610;&#1585;";delete="&#1581;&#1584;&#1601;";
    head_1="&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1587;&#1585;&#1610;&#1593;&#1577;";
    head_2="&#1593;&#1605;&#1604;&#1610;&#1575;&#1578; &#1571;&#1587;&#1575;&#1587;&#1610;&#1577;";
    field_1_1="&#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1575;&#1604;&#1602;&#1591;&#1593;";
    
    title_1="&#1593;&#1585;&#1590; &#1575;&#1604;&#1605;&#1608;&#1585;&#1583;&#1610;&#1606;";
    title_2="&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
    cancel_button_label=" &#1593;&#1608;&#1583;&#1607; &#1575;&#1604;&#1610; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1607; ";
    save_button_label=" &#1581;&#1584;&#1601; &#1575;&#1604;&#1589;&#1606;&#1601;";
    langCode="En";
}

    
%>
  <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
         
 function changePage(url){
                window.navigate(url);
            }

    </SCRIPT>
    <script src='ChangeLang.js' type='text/javascript'></script>    
<body>

<DIV align="left" STYLE="color:blue;">
    <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
    <button  onclick="JavaScript: changePage('<%=context%>/ItemsServlet?op=ShowItem&categoryId=<%=categoryId%>&pIndex=<%=pIndex%>&itemID=<%=itemID%>');" class="button"><%=cancel_button_label%><IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif"> </button>
   
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

<TABLE align="<%=align%>" dir=<%=dir%> WIDTH="400" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
    <TR CLASS="head">
        <%
        for(int i = 0;i<t;i++) {
        
        
        %>
        
        <TD nowrap CLASS="firstname" WIDTH="100" STYLE="border-top-WIDTH:0; font-size:12" nowrap>
            <%=supplierListTitles[i]%>
            </TD>
        
        
        
        <%
        }
        %>
    </TR>  
    <%
    
    Enumeration e = supplierList.elements();
    
    
    while(e.hasMoreElements()) {
        iTotal++;
        wbo = (WebBusinessObject) e.nextElement();
        
        flipper++;
        if((flipper%2) == 1) {
            bgColor="#c8d8f8";
        } else {
            bgColor="white";
        }
    %>
    
    <TR bgcolor="<%=bgColor%>">
        <%
        WebBusinessObject wboSupplier = new WebBusinessObject();
        for(int i = 0;i<s;i++) {
            attName = supplierAttributes[i];
            attValue = (String) wbo.getAttribute(attName);
            wboSupplier = supplierMgr.getOnSingleKey(attValue);
        %>
        
        <TD  nowrap  CLASS="cell" STYLE="<%=style%>">
            <DIV >
                
                <b> <%=wboSupplier.getAttribute("name").toString()%> </b>
            </DIV>
        </TD>
        <%
        }
        %>
        
        <TD nowrap CLASS="cell" STYLE="<%=style%>" >
            <DIV ID="links">
                <A HREF="<%=context%>/SupplierServlet?op=ViewItemSupplier&supplierID=<%=wbo.getAttribute("supplierID")%>&itemID=<%=itemID%>&categoryId=<%=categoryId%>&pIndex=<%=pIndex%>">
                    <%=supplierListTitles[1]%>
                </A>
            </DIV>
        </TD>
        
        <TD nowrap CLASS="cell" STYLE="padding-left:10;<%=style%>">
            <DIV ID="links">
                <A HREF="<%=context%>/SupplierServlet?op=GetUpdateItemSupplierForm&supplierID=<%=wbo.getAttribute("supplierID")%>&itemID=<%=itemID%>&categoryId=<%=categoryId%>&pIndex=<%=pIndex%>">
                    <%=supplierListTitles[2]%>
                </A>
            </DIV>
        </TD>
        <TD nowrap CLASS="cell" STYLE="padding-left:10;<%=style%>">
            <DIV ID="links">
                <A HREF="<%=context%>/SupplierServlet?op=ConfirmItemSupplierDelete&supplierID=<%=wbo.getAttribute("supplierID")%>&supplierName=<%=wboSupplier.getAttribute("name")%>&itemID=<%=itemID%>&categoryId=<%=categoryId%>&pIndex=<%=pIndex%>">
                    <%=supplierListTitles[3]%>
                </A>
            </DIV>
        </TD>
        
        
        
        
    </TR>
    
    
    <%
    
    }
    
    %>
    <TR>
        <TD CLASS="total" COLSPAN="3" STYLE="<%=style%>">
           <%=sup_num%>
        </TD>
        <TD CLASS="total" colspan="1" STYLE="text-align:left;padding-left:5;">
            
            <DIV NAME="" ID="">
                <%=iTotal%>
            </DIV>
        </TD>
    </TR>
</table>
<br><br><br>



</body>
</html>
