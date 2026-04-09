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

String[] categoryAttributes = {"categoryName"};
String[] categoryListTitles = {"Categoty Name", "View", "Edit", "Delete"};

int s = categoryAttributes.length;
int t = s+3;
int iTotal = 0;

String attName = null;
String attValue = null;
String cellBgColor = null;



Vector  categoryList = (Vector) request.getAttribute("data");


WebBusinessObject wbo = null;
int flipper = 0;
String bgColor = null;

TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

CategoryMgr categoryMgr=CategoryMgr.getInstance();



String cMode= (String) request.getSession().getAttribute("currentMode");
String  stat=cMode;
String align=null;
String dir=null;
String style=null;
String lang,langCode;

String saving_status;

String title_1,title_2,pic_1,pic_2;
String cat_show,last_field;
String cancel_button_label;
String save_button_label;
String field_1,field_2,field_3,field_4,IG,QS,BO;
if(stat.equals("En")){
    
    saving_status="Saving status";
    align="center";
    dir="LTR";
    style="text-align:left";
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
    
    
    IG="Indicators guide ";
    QS="Quick Summary";
    BO="Basic Operations";
    field_1="view";
    field_2="edit";
    field_3="delete";
    field_4="can't delete";
    
    pic_1="  &nbsp;&nbsp;Active Category ";
    pic_2="  &nbsp;&nbsp;Non Active Category ";
    cat_show="Category list";
    last_field="Categories number";
    title_1=" Indicators guide";
    title_2="All information are needed";
    cancel_button_label="Cancel ";
    save_button_label="Save ";
    langCode="Ar";
}else{
    
    saving_status="&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
    align="center";
    dir="RTL";
    style="text-align:Right";
    lang="English";
    IG="&#1575;&#1604;&#1605;&#1585;&#1588;&#1583; &#1575;&#1604;&#1605;&#1589;&#1608;&#1585;";
    
    QS="&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1587;&#1585;&#1610;&#1593;&#1577;";
    BO="&#1593;&#1605;&#1604;&#1610;&#1575;&#1578; &#1571;&#1587;&#1575;&#1587;&#1610;&#1577;";
    
    String x[]={"&#1573;&#1587;&#1605; &#1575;&#1604;&#1589;&#1606;&#1601;", "&#1605;&#1588;&#1575;&#1607;&#1583;&#1607; ",
    "&#1578;&#1581;&#1585;&#1610;&#1585;", "&#1581;&#1584;&#1601;"};
    categoryListTitles = x;
    
    field_1="&#1605;&#1588;&#1575;&#1607;&#1583;&#1607;";
    field_2="&#1578;&#1581;&#1585;&#1610;&#1585;";
    field_3="&#1581;&#1584;&#1601;";
    field_4="&#1604;&#1575; &#1610;&#1605;&#1603;&#1606; &#1581;&#1584;&#1601; &#1575;&#1604;&#1589;&#1606;&#1601;";
    
    pic_1="&nbsp;&nbsp;&#1589;&#1606;&#1601; &#1606;&#1588;&#1591";
    pic_2="&nbsp;&nbsp;&#1589;&#1606;&#1601; &#1594;&#1610;&#1585; &#1606;&#1588;&#1591";
    cat_show="&#1593;&#1585;&#1590; &#1575;&#1604;&#1571;&#1589;&#1606;&#1575;&#1601;";
    last_field="&#1593;&#1583;&#1583; &#1575;&#1604;&#1571;&#1589;&#1606;&#1575;&#1601;";
    title_1="&#1575;&#1604;&#1605;&#1585;&#1588;&#1583;";
    title_2="&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
    cancel_button_label="&#1573;&#1606;&#1607;&#1575;&#1569; ";
    save_button_label="&#1578;&#1587;&#1580;&#1610;&#1604; ";
    langCode="En";
}


%>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
     function changePage(url){
                window.navigate(url);
            }
            
             function changeMode(name){
            if(document.getElementById(name).style.display == 'none'){
                document.getElementById(name).style.display = 'block';
            } else {
                document.getElementById(name).style.display = 'none';
            }
        }
</SCRIPT>
<script src='ChangeLang.js' type='text/javascript'></script>

<body>
<table align="center" border="0" width="100%">
    <tr>
        <td STYLE="border:0px;">
            <div STYLE="width:40%;border:2px solid gray;background-color:#808000;color:white;" bgcolor="#F3F3F3" align="center">
                <div ONCLICK="JavaScript: changeMode('menu1');" STYLE="width:100%;background-color:#808000;color:white;cursor:hand;font-size:14;">
                    <b>
                        <%=title_1%>
                    </b>
                    <img src="images/arrow_down.gif">
                </div>
                <div ALIGN="center" STYLE="width:100%;background-color:#FFFFCC;color:white;display:none;<%=style%>border-top:2px solid gray;" ID="menu1">
                    <table align="center" border="0" dir="<%=dir%>" width="100%" cellspacing="2" >
                        <tr align="<%=align%>">
                            <td CLASS="cell" bgcolor="#B7B700" dir="<%=dir%>" style="color:white;<%=style%>" width="50%"><IMG WIDTH="20" SRC="images/active.jpg" ALT="Active Category by Parts" ALIGN="<%=align%>"><B><%=pic_1%></B></td>
                            <td CLASS="cell" bgcolor="#B7B700" dir="<%=dir%>" style="color:white;<%=style%>" width="50%"><IMG WIDTH="20" SRC="images/nonactive.jpg" ALT="Non Active Category" ALIGN="<%=align%>"><B><%=pic_2%></B></td>
                            
                        </tr>   
                    </table>
                </div>
            </div>
        </td>
    </tr>
</table>
<DIV align="left" STYLE="color:blue;">
    <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
    <button  onclick="JavaScript: changePage('<%=context%>/main.jsp');" class="button"><%=cancel_button_label%><IMG VALIGN="BOTTOM"   SRC="images/cancel.gif"> </button>
</DIV> 
<fieldset class="set" align="center">
<legend align="center">
    <table dir="<%=dir%>" align="<%=align%>">
        <tr>
            
            <td class="td">
                <font color="blue" size="6">    <%=cat_show%>                
                </font>
                
            </td>
        </tr>
    </table>
</legend>


<br>
<center>
    <b><font size="3" color="red">  <%=last_field%> : <%=categoryList.size()%></font></b>
</center>

<TABLE ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="400" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">

<TR>
    <TD CLASS="td" COLSPAN="1" bgcolor="#808000" STYLE="text-align:center;color:white;font-size:16">
        <B><%=QS%></B>
    </TD>
    <TD CLASS="td" COLSPAN="3" bgcolor="#669900" STYLE="text-align:center;color:white;font-size:16">
        <B><%=BO%></B>
    </TD>
    <TD CLASS="td" COLSPAN="1" bgcolor="#CC9900" STYLE="text-align:center;color:white;font-size:16">
        <B><%=IG%> </b>
    </TD>
</tr>

<TR CLASS="head">
    
    <%
    String columnColor = new String("");
    String columnWidth = new String("");
    String font = new String("");
    for(int i = 0;i<t;i++) {
        if(i == 0 ){
            columnColor = "#9B9B00";
        } else {
            columnColor = "#7EBB00";
        }
        if(categoryListTitles[i].equalsIgnoreCase("")){
            columnWidth = "1";
            columnColor = "black";
            font = "1";
        } else {
            columnWidth = "100";
            font = "12";
        }
    %>                
    <TD nowrap CLASS="firstname" WIDTH="<%=columnWidth%>" bgcolor="<%=columnColor%>" STYLE="border-WIDTH:0; font-size:<%=font%>;color:white;" nowrap>
        <B><%=categoryListTitles[i]%></B>
    </TD>
    <%
    }
    %>
    <TD nowrap CLASS="firstname" BGCOLOR="#FFBF00" WIDTH="135" STYLE="border-WIDTH:0; font-size:12" COLSPAN="1" nowrap>
        &nbsp;
        </TD>
</TR>
<%

Enumeration e = categoryList.elements();


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
for(int i = 0;i<s;i++) {
        attName = categoryAttributes[i];
        attValue = (String) wbo.getAttribute(attName);
%>

<TD  STYLE="<%=style%>"  BGCOLOR="#DDDD00" nowrap  CLASS="cell" >
    <DIV >
        
        <b> <%=attValue%> </b>
    </DIV>
</TD>
<%
}
%>

<TD nowrap CLASS="cell" BGCOLOR="#D7FF82" STYLE="padding-left:10;<%=style%>">
    <DIV ID="links">
        <A HREF="<%=context%>/ItemsServlet?op=ViewCategory&categoryId=<%=wbo.getAttribute("categoryId")%>">
            <%=field_1%>
        </A>
    </DIV>
</TD>

<TD nowrap CLASS="cell" BGCOLOR="#D7FF82"STYLE="padding-left:10;<%=style%>">
    <DIV ID="links">
        <A HREF="<%=context%>/ItemsServlet?op=GetUpdateCategory&categoryId=<%=wbo.getAttribute("categoryId")%>">
            <%=field_2%>
        </A>
    </DIV>
</TD>

<%
if(categoryMgr.getActiveCategory(wbo.getAttribute("categoryId").toString())) {
%>
<TD nowrap CLASS="cell" BGCOLOR="#D7FF82" STYLE="padding-left:10;<%=style%>">
<DIV ID="links">
    <%=field_4%>
    </A>
</DIV>

<%
} else {
%> 

<TD nowrap CLASS="cell" BGCOLOR="#D7FF82" STYLE="padding-left:10;<%=style%>">
    <DIV ID="links">
        <A HREF="<%=context%>/ItemsServlet?op=ConfirmDeleteCategory&categoryId=<%=wbo.getAttribute("categoryId")%>&categoryName=<%=wbo.getAttribute("categoryName")%>">
            <%=field_3%>
        </A>
    </DIV>
</TD>
<% } %>


<TD WIDTH="20px" BGCOLOR="#FFE391" nowrap CLASS="cell">
    <%
    if(categoryMgr.getActiveCategory(wbo.getAttribute("categoryId").toString())) {
    %>
    <IMG SRC="images/active.jpg"  ALT="Active Category by Parts"> 
    
    
    <%
    } else {
    %> 
    
    <IMG SRC="images/nonactive.jpg"  ALT="Non Active Category">
    <% } %>
</TD>               



</TR>


<%

}

%>
<TR>
    <TD CLASS="total" COLSPAN="3" STYLE="<%=style%>">
        <%=last_field%>
    </TD>
    <TD CLASS="total" colspan="2" STYLE="<%=style%>;padding-left:5;">
        
        <DIV NAME="" ID="">
            <%=iTotal%>
        </DIV>
    </TD>
</TR>
</table>
<br><br><br>



</body>
</html>
