<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>  
<%
MetaDataMgr metaMgr = MetaDataMgr.getInstance();
String context = metaMgr.getContext();

TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

Vector actualItems = (Vector) request.getAttribute("actualItems");
Vector quantifiedItems = (Vector) request.getAttribute("quantifiedItems");
Vector configureItems = (Vector) request.getAttribute("configureItems");
WebBusinessObject wbo = (WebBusinessObject) request.getAttribute("wbo");
String currentStatus = new String("");
if(wbo.getAttribute("currentStatus") != null){
    currentStatus = (String) wbo.getAttribute("currentStatus");
}
String bgColor;
double iConfigureTotal = 0;
double iQuantifiedTotal = 0;
double iActualTotal = 0;


String cMode= (String) request.getSession().getAttribute("currentMode");
String  stat=cMode;

String align=null;
String dir=null;
String style=null;
String lang,langCode,ViewSpars,BackToList,schduled,finished,categlog,ToCost,
        Begined,Finished,Canceled,Holded,Rejected,status,cost,count,price,name,code,onCreate,viewTaskSpar
        ;
if(stat.equals("En")){
    
    align="center";
    dir="LTR";
    style="text-align:left";
    
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
    langCode="Ar";
    ViewSpars="View Spare Parts";
    BackToList = "Back to list";
    schduled="Scheduled";
    Begined="Begined";
    Finished="Finished";
    Canceled="Canceled";
    Holded="on Hold";
    Rejected="Rejected";
    status="Status";
    code="Code";
    name="Name";
    price="Price";
    count="countity";
    cost="Cost";
    finished="After Execution Spare Parts";
    categlog="Planned Spare Parts";
    onCreate="During Execution Spare Parts";
    ToCost="Total Cost";
    viewTaskSpar="View Spare Parts";
    
}else{
    
    align="center";
    dir="RTL";
    style="text-align:Right";
    lang="English";
    langCode="En";
    ViewSpars=" &#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1602;&#1591;&#1593; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585;";
    BackToList = "&#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1573;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577;";
    schduled="&#1605;&#1580;&#1583;&#1608;&#1604;&#1577;";
    Begined="&#1576;&#1583;&#1571;&#1578;";
    Finished="&#1573;&#1606;&#1578;&#1607;&#1578;";
    Canceled="&#1605;&#1604;&#1594;&#1575;&#1577;";
    Holded="&#1605;&#1608;&#1602;&#1608;&#1601;&#1577;";
    Rejected="&#1605;&#1585;&#1601;&#1608;&#1590;&#1577;";
    status="&#1575;&#1604;&#1581;&#1575;&#1604;&#1577;";
    code="&#1603;&#1608;&#1583; &#1575;&#1604;&#1602;&#1591;&#1593;&#1577;";
    name="&#1575;&#1587;&#1605; &#1575;&#1604;&#1602;&#1591;&#1593;&#1577;";
    price="&#1587;&#1593;&#1585; &#1575;&#1604;&#1608;&#1581;&#1583;&#1577;";
    count="&#1575;&#1604;&#1603;&#1605;&#1610;&#1577;";
    cost="&#1573;&#1580;&#1605;&#1575;&#1604;&#1610; &#1575;&#1604;&#1587;&#1593;&#1585;";
    finished="&#1602;&#1591;&#1593; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585; &#1576;&#1593;&#1583; &#1575;&#1604;&#1578;&#1606;&#1601;&#1610;&#1584;";
    categlog="&#1602;&#1591;&#1593; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585; &#1575;&#1604;&#1605;&#1582;&#1591;&#1591;&#1577;";
    onCreate="&#1602;&#1591;&#1593; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585; &#1582;&#1604;&#1575;&#1604; &#1575;&#1604;&#1578;&#1606;&#1601;&#1610;&#1584;";
    ToCost="&#1573;&#1580;&#1605;&#1575;&#1604;&#1610;";
    viewTaskSpar="&#1593;&#1585;&#1590; &#1605;&#1585;&#1581;&#1604;&#1610; &#1604;&#1602;&#1591;&#1593; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585;";
    
}
%>
<HTML>
    
    
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>Document Viewer - add new Project</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>
    <BODY>
        <br><br><br>
        <table align="<%=align%>" border="0" dir="<%=dir%>" width="100%">
            
            <tr>
                <TD CLASS="td" VALIGN="top">
                    <table ALIGN="<%=align%>" DIR="<%=dir%>" width ="100%">
                        <TR>
                            <TD STYLE="border:1px solid black" width ="33%" VALIGN="top" COLSPAN="2">
                                <table border="0" ALIGN="<%=align%>" DIR="<%=dir%>" width ="100%" cellpadding="0" cellspacing="1">
                                    <TR>
                                        <TD style="text-align:center" CLASS="head" bgcolor="#F3F3F3" width="33%" COLSPAN="6">
                                            <b><%=categlog%></b>
                                        </TD>
                                    </TR>
                                    <TR bgcolor="#808080">
                                        <TD STYLE="border:0px;color:white">
                                            <b><%=code%></b>
                                        </TD>
                                        <TD STYLE="border:0px;color:white">
                                            <b><%=name%></b>
                                        </TD>
                                        <TD STYLE="border:0px;color:white">
                                            <b><%=count%></b>
                                        </TD>
                                        <!--TD STYLE="border:0px;color:white">
                                            <b><%=price%></b>
                                        </TD>
                                        <TD STYLE="border:0px;color:white">
                                            <b><%=cost%></b>
                                        </TD-->
                                    </TR>
                                    <%
                                    for(int i = 0; i < configureItems.size(); i++){
    WebBusinessObject tempWbo = (WebBusinessObject) configureItems.get(i);
    if((i%2) == 1) {
        bgColor="#FFFFCC";
    } else {
        bgColor="#CCCC00";
    }
    if(((String) tempWbo.getAttribute("totalCost")) != null){
        Double iTemp = new Double(((String) tempWbo.getAttribute("totalCost")));
        iConfigureTotal = iConfigureTotal + iTemp.doubleValue();
    }
                                    %>
                                    <TR BGCOLOR="<%=bgColor%>">
                                        <TD STYLE="border:0px">
                                            <%=(String) tempWbo.getAttribute("itemCode")%>
                                        </TD>
                                        <TD STYLE="border:0px">
                                            <%=(String) tempWbo.getAttribute("itemDscrptn")%>
                                        </TD>
                                        <TD STYLE="border:0px">
                                            <%=(String) tempWbo.getAttribute("itemQuantity")%>
                                        </TD>
                                        <!--TD STYLE="border:0px">
                                            <%=(String) tempWbo.getAttribute("itemPrice")%>
                                        </TD>
                                        <TD STYLE="border:0px">
                                            <%=(String) tempWbo.getAttribute("totalCost")%>
                                        </TD-->
                                    </TR>
                                    <%
                                    }
                                    %>
                                </TABLE>
                            </TD>
                            <TD STYLE="border:1px solid black" width ="33%" VALIGN="top" COLSPAN="2">
                                <table border="0" ALIGN="<%=align%>" DIR="<%=dir%>" width ="100%" cellpadding="0" cellspacing="1">
                                    <TR>
                                        <TD style="text-align:center" CLASS="head" bgcolor="#F3F3F3" width="33%" COLSPAN="6">
                                            <b><%=onCreate%></b>
                                        </TD>
                                    </TR>
                                    <TR bgcolor="#808080">
                                        <TD STYLE="border:0px;color:white">
                                            <b><%=code%></b>
                                        </TD>
                                        <TD STYLE="border:0px;color:white">
                                            <b><%=name%></b>
                                        </TD>
                                        <TD STYLE="border:0px;color:white">
                                            <b><%=count%></b>
                                        </TD>
                                        <!--TD STYLE="border:0px;color:white">
                                            <b><%=price%></b>
                                        </TD>
                                        <TD STYLE="border:0px;color:white">
                                            <b><%=cost%></b>
                                        </TD-->
                                    </TR>
                                    <%
                                    for(int i = 0; i < quantifiedItems.size(); i++){
    WebBusinessObject tempWbo = (WebBusinessObject) quantifiedItems.get(i);
    if((i%2) == 1) {
        bgColor="#FFFFCC";
    } else {
        bgColor="#CCCC00";
    }
    if(((String) tempWbo.getAttribute("totalCost")) != null){
        Double iTemp = new Double(((String) tempWbo.getAttribute("totalCost")));
        iQuantifiedTotal = iQuantifiedTotal + iTemp.doubleValue();
    }
                                    %>
                                    <TR BGCOLOR="<%=bgColor%>">
                                        <TD STYLE="border:0px">
                                            <%=(String) tempWbo.getAttribute("itemCode")%>
                                        </TD>
                                        <TD STYLE="border:0px">
                                            <%=(String) tempWbo.getAttribute("itemDscrptn")%>
                                        </TD>
                                        <TD STYLE="border:0px">
                                            <%=(String) tempWbo.getAttribute("itemQuantity")%>
                                        </TD>
                                        <!--TD STYLE="border:0px">
                                            <%=(String) tempWbo.getAttribute("itemPrice")%>
                                        </TD>
                                        <TD STYLE="border:0px">
                                            <%=(String) tempWbo.getAttribute("totalCost")%>
                                        </TD-->
                                    </TR>
                                    <%
                                    }
                                    %>
                                </TABLE>
                            </TD>
                            <TD STYLE="border:1px solid black" width ="33%" VALIGN="top" COLSPAN="2">
                                <table border="0" ALIGN="<%=align%>" DIR="<%=dir%>" width ="100%" cellpadding="0" cellspacing="1">
                                    <TR>
                                        <TD style="text-align:center" CLASS="head" bgcolor="#F3F3F3" width="33%" COLSPAN="6">
                                            <B><%=finished%></B>
                                        </TD>
                                    </TR>
                                    <TR bgcolor="#808080">
                                        <TD STYLE="border:0px;color:white">
                                            <b><%=code%></b>
                                        </TD>
                                        <TD STYLE="border:0px;color:white">
                                            <b><%=name%></b>
                                        </TD>
                                        <TD STYLE="border:0px;color:white">
                                            <b><%=count%></b>
                                        </TD>
                                        <!--TD STYLE="border:0px;color:white">
                                            <b><%=price%></b>
                                        </TD>
                                        <TD STYLE="border:0px;color:white">
                                            <b><%=cost%></b>
                                        </TD-->
                                    </TR>
                                    <%
                                    for(int i = 0; i < actualItems.size(); i++){
    WebBusinessObject tempWbo = (WebBusinessObject) actualItems.get(i);
    if((i%2) == 1) {
        bgColor="#FFFFCC";
    } else {
        bgColor="#CCCC00";
    }
    if(((String) tempWbo.getAttribute("totalCost")) != null){
        Double iTemp = new Double(((String) tempWbo.getAttribute("totalCost")));
        iActualTotal = iActualTotal + iTemp.doubleValue();
    }
                                    %>
                                    <TR BGCOLOR="<%=bgColor%>">
                                        <TD STYLE="border:0px">
                                            <%=(String) tempWbo.getAttribute("itemCode")%>
                                        </TD>
                                        <TD STYLE="border:0px">
                                            <%=(String) tempWbo.getAttribute("itemDscrptn")%>
                                        </TD>
                                        <TD STYLE="border:0px">
                                            <%=(String) tempWbo.getAttribute("itemQuantity")%>
                                        </TD>
                                        <!--TD STYLE="border:0px">
                                            <%=(String) tempWbo.getAttribute("itemPrice")%>
                                        </TD>
                                        <TD STYLE="border:0px">
                                            <%=(String) tempWbo.getAttribute("totalCost")%>
                                        </TD-->
                                    </TR>
                                    <%
                                    }
                                    %>
                                </TABLE>
                            </TD>
                        </TR>
                        <!--TR bgcolor="#808080">
                            <TD STYLE="border:1px solid black;color:white" VALIGN="top">
                                <b><%=ToCost%></b>
                            </TD>
                            <TD STYLE="border:1px solid black;color:white" width ="10%" VALIGN="top">
                                <%=iConfigureTotal%>
                            </TD>
                            <TD STYLE="border:1px solid black;color:white" VALIGN="top">
                                <b><%=ToCost%></b>
                            </TD>
                            <TD STYLE="border:1px solid black;color:white" width ="10%" VALIGN="top">
                                <%=iQuantifiedTotal%>
                            </TD>
                            <TD STYLE="border:1px solid black;color:white" VALIGN="top">
                                <b><%=ToCost%></b>
                            </TD>
                            <TD STYLE="border:1px solid black;color:white" width ="10%" VALIGN="top">
                                <%=iActualTotal%>
                            </TD>
                        </TR-->
                    </TABLE>
                </TD>
            </TR>
        </TABLE>
    </BODY>
</HTML>     
