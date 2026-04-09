<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*, com.tracker.common.*,com.tracker.business_objects.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page pageEncoding="UTF-8"%>
<HTML>
    <%
    String itemCode = (String) request.getAttribute("itemCode");
    String itemName = (String) request.getAttribute("itemName");
    String itemForm = (String) request.getAttribute("itemForm");
    String itemFormName = (String) request.getAttribute("itemFormName");
    String storeCode = (String) request.getAttribute("storeCode");
    String storeName = (String) request.getAttribute("storeName");
    String balance = (String) request.getAttribute("balance");

    String cMode= (String) request.getSession().getAttribute("currentMode");
    String  stat=cMode;
    String align=null;
    String dir=null;
    String style=null;
    String lang, langCode, close, print, title;
    String divAlign;
    String store, strStoreName, strStoreCode, form, formName, formCode, sparePart, spareName, spareCode, strbalance, balanceInStore;

    if(stat.equals("En")){
        align="center";
        divAlign = "left";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        langCode="Ar";
        close = "Close";
        print = "Print";
        title = "View Details Spare Parts";

        store = "Store";
        strStoreName = "Store Name";
        strStoreCode = "Store Code";
        form = "Item Category";
        formCode = "Category Code";
        formName = "Category Name";
        sparePart = "Spare Parts";
        spareName = "Parts Name";
        spareCode = "Parts Code";
        strbalance = "Balance";
        balanceInStore = "Balance In Store";
    }else{
        align="center";
        divAlign = "right";
        dir="RTL";
        style="text-align:right";
        lang="   English    ";
        langCode="En";
        close = "&#1594;&#1604;&#1602;";
        print = "&#1575;&#1591;&#1576;&#1593;";
        title = "&#1578;&#1601;&#1575;&#1589;&#1610;&#1604; &#1602;&#1591;&#1593;&#1577; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585;";

        store = "&#1605;&#1582;&#1600;&#1600;&#1586;&#1606;";
        strStoreName = "&#1575;&#1587;&#1605; &#1575;&#1604;&#1605;&#1582;&#1586;&#1606;";
        strStoreCode = "&#1603;&#1608;&#1583; &#1575;&#1604;&#1605;&#1582;&#1586;&#1606;";
        form = "&#1589;&#1606;&#1600;&#1600;&#1601;";
        formCode = "&#1603;&#1608;&#1583; &#1575;&#1604;&#1589;&#1606;&#1601;";
        formName = "&#1575;&#1587;&#1605; &#1575;&#1604;&#1589;&#1606;&#1601;";
        sparePart = "&#1602;&#1591;&#1593;&#1577; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585;";
        spareName = "&#1575;&#1587;&#1605; &#1575;&#1604;&#1602;&#1591;&#1593;&#1577;";
        spareCode = "&#1603;&#1608;&#1583; &#1575;&#1604;&#1602;&#1591;&#1593;&#1577;";
        strbalance = "&#1575;&#1604;&#1585;&#1589;&#1610;&#1600;&#1600;&#1583;";
        balanceInStore = "&#1575;&#1604;&#1585;&#1589;&#1610;&#1583; &#1601;&#1609; &#1575;&#1604;&#1605;&#1582;&#1586;&#1606;";
    }
    %>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Issue Detail</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/blueStyle.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/Button.css">
    </HEAD>

    <script src='js/ChangeLang.js' type='text/javascript'></script>
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
        function printWindow(){
            document.getElementById('btnDiv').style.display = "none";
            window.print();
            document.getElementById('btnDiv').style.display = "block";
        }
    </SCRIPT>

    <BODY>
        <FORM NAME="ISSUE_DETAILS_FORM" METHOD="POST" action="">
            <DIV align="left" STYLE="color:blue;" ID="btnDiv">
                <input type="button" style="width:80px;height:30px;font-weight:bold" onclick="reloadAE('<%=langCode%>')" value="<%=lang%>" class="button">
                    &ensp;
                <input type="button" style="width:80px;height:30px;font-weight:bold"  value="<%=close%>"  onclick="window.close()" class="button">
                    &ensp;
                <input type="button" style="width:80px;height:30px;font-weight:bold"  value="<%=print%>"  onclick="JavaScript:printWindow();" class="button">
            </DIV>
            <br>
            <center>
                <fieldset class="set" style="border-color: #006699;width: 95%;">
                    <table class="blueBorder" dir="<%=dir%>" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                        <tr>
                            <td style="text-align:center;border-color: #006699;" width="50%" class="blueBorder blueHeaderTD">
                                 <FONT color='#F3D596' SIZE="4"><%=title%></FONT>
                            </td>
                        </tr>
                    </table>
                    <br>
                    <div align="<%=divAlign%>" style="margin-<%=divAlign%>: 5%;color: blue">
                        <p dir="rtl" align="center" style="background-color: #E6E6FA;width:20%;font-weight: bold;font-size: 18px"><b><%=store%></b></p>
                    </div>
                    <table dir="<%=dir%>" class="blueBorder" width="90%" cellpadding="0" cellspacing="0" align="center">
                        <tr>
                            <td class="blueBorder blueHeaderTD" width="15%" style="background-color: #bbc4d0;color: black">
                                <%=strStoreName%>
                            </td>
                            <td class="blueBorder blueBodyTD" width="35%">
                                <%=storeName%>
                            </td>
                            <td class="blueBorder blueHeaderTD" width="15%" style="background-color: #bbc4d0;color: black">
                                <%=strStoreCode%>
                            </td>
                            <td class="blueBorder blueBodyTD" width="35%">
                                <font color="black"><%=storeCode%></font>
                            </td>
                        </tr>
                    </table>
                    <div align="<%=divAlign%>" style="margin-<%=divAlign%>: 5%;color: blue">
                        <p dir="rtl" align="center" style="background-color: #E6E6FA;width:20%;font-weight: bold;font-size: 18px"><b><%=form%></b></p>
                    </div>
                    <table dir="<%=dir%>" class="blueBorder" width="90%" cellpadding="0" cellspacing="0" align="center">
                        <tr>
                            <td class="blueBorder blueHeaderTD" width="15%" style="background-color: #bbc4d0;color: black">
                                <%=formName%>
                            </td>
                            <td class="blueBorder blueBodyTD" width="35%">
                                <%=itemFormName%>
                            </td>
                            <td class="blueBorder blueHeaderTD" width="15%" style="background-color: #bbc4d0;color: black">
                                <%=formCode%>
                            </td>
                            <td class="blueBorder blueBodyTD" width="35%">
                                <font color="black"><%=itemForm%></font>
                            </td>
                        </tr>
                    </table>
                    <div align="<%=divAlign%>" style="margin-<%=divAlign%>: 5%;color: blue">
                        <p dir="rtl" align="center" style="background-color: #E6E6FA;width:20%;font-weight: bold;font-size: 18px"><b><%=sparePart%></b></p>
                    </div>
                    <table dir="<%=dir%>" class="blueBorder" width="90%" cellpadding="0" cellspacing="0" align="center">
                        <tr>
                            <td class="blueBorder blueHeaderTD" width="15%" style="background-color: #bbc4d0;color: black">
                                <%=spareName%>
                            </td>
                            <td class="blueBorder blueBodyTD" width="35%">
                                <%=itemName%>
                            </td>
                            <td class="blueBorder blueHeaderTD" width="15%" style="background-color: #bbc4d0;color: black">
                                <%=spareCode%>
                            </td>
                            <td class="blueBorder blueBodyTD" width="35%">
                                <font color="black"><%=itemCode%></font>
                            </td>
                        </tr>
                    </table>
                            <div align="<%=divAlign%>" style="margin-<%=divAlign%>: 5%;color: blue">
                        <p dir="rtl" align="center" style="background-color: #E6E6FA;width:20%;font-weight: bold;font-size: 18px"><b><%=strbalance%></b></p>
                    </div>
                    <table dir="<%=dir%>" class="blueBorder" width="90%" cellpadding="0" cellspacing="0" align="center">
                        <tr>
                            <td class="blueBorder blueHeaderTD" width="25%" style="background-color: #bbc4d0;color: black">
                                <%=balanceInStore%>
                            </td>
                            <td class="blueBorder blueBodyTD" width="25%">
                                <font color="blue"><%=balance%></font>
                            </td>
                        </tr>
                    </table>
                    <br>
                </fieldset>
            </center>
        </FORM>
    </BODY>
</HTML>