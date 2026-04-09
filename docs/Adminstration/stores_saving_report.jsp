<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,com.tracker.db_access.*,com.silkworm.persistence.relational.UniqueIDGen"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<%
TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

MetaDataMgr metaMgr = MetaDataMgr.getInstance();

String context = metaMgr.getContext();
String cMode= (String) request.getSession().getAttribute("currentMode");

Vector savedData = (Vector) request.getAttribute("savedData");
Vector unsavedData = (Vector) request.getAttribute("unsavedData");

String  stat=cMode;
String align=null;
String dir=null;
String style=null;
String lang,langCode;
String cancel;
String title;
String savedS;
String unsavedS;
String serial;
String storeName;
String storeNo;
String storeLoc;
String storeEmp;
String storeTel;
String noData;

if(stat.equals("En")){
    align="center";
    dir="LTR";
    style="text-align:left";
    lang="&#1593;&#1585;&#1576;&#1610;";
    langCode="Ar";
    cancel="Back";
    title="Stores Saving Results";
    savedS="Saved Stores";
    unsavedS="Unsaved Stores";
    serial="Serial";
    storeName="Store Name";
    storeNo="Store Number";
    storeLoc="Location";
    storeEmp="Responsible Employee ID";
    storeTel="Telephone";
    noData="No Data";
} else {
    align="center";
    dir="RTL";
    style="text-align:Right";
    lang="English";
    langCode="En";
    cancel=" &#1575;&#1604;&#1593;&#1608;&#1583;&#1577;";
    title="&#1606;&#1578;&#1575;&#1574;&#1580; &#1581;&#1601;&#1592; &#1575;&#1604;&#1605;&#1582;&#1575;&#1586;&#1606;";
    savedS="&#1575;&#1604;&#1605;&#1582;&#1575;&#1586;&#1606; &#1575;&#1604;&#1578;&#1610; &#1578;&#1605; &#1578;&#1587;&#1580;&#1610;&#1604;&#1607;&#1575;";
    unsavedS="&#1575;&#1604;&#1605;&#1582;&#1575;&#1586;&#1606; &#1575;&#1604;&#1578;&#1610; &#1604;&#1605; &#1610;&#1578;&#1605; &#1578;&#1587;&#1580;&#1610;&#1604;&#1607;&#1575;";
    serial="&#1605;&#1587;&#1604;&#1587;&#1604;";
    storeName="&#1575;&#1587;&#1605; &#1575;&#1604;&#1605;&#1582;&#1586;&#1606;";
    storeNo="&#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1582;&#1586;&#1606;";
    storeLoc="&#1575;&#1604;&#1605;&#1608;&#1602;&#1593;";
    storeEmp="&#1575;&#1604;&#1605;&#1608;&#1592;&#1601; &#1575;&#1604;&#1605;&#1587;&#1572;&#1604;";
    storeTel="&#1578;&#1604;&#1610;&#1601;&#1608;&#1606;";
    noData="&#1604;&#1575;&#1610;&#1608;&#1580;&#1583;";
}
%>

<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
    function cancelForm(){    
        document.REPORT_FORM.action = "<%=context%>//StoreServlet?op=importExcelStore";
        document.REPORT_FORM.submit();  
    }
</SCRIPT>
<script src='ChangeLang.js' type='text/javascript'></script>

<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>Stores Saving Report</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css"><LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
    </HEAD>
    
    <link rel="stylesheet" type="text/css" href="autosuggest.css" />
    <BODY>
        <FORM  NAME="REPORT_FORM" METHOD="POST">
            <DIV align="left" STYLE="color:blue;">
                <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
                <button onclick="cancelForm()" class="button"><%=cancel%><IMG VALIGN="BOTTOM"  HEIGHT="15" SRC="images/leftarrow.gif"></button>
            </DIV>
            
            <fieldset class="set" align="center">
                <legend align="center">
                    <table dir="<%=dir%>" align="center">
                        <tr>
                            <td class="td">
                                <font color="blue" size="6"><%=title%></font>
                            </td>
                        </tr>
                    </table>
                </legend>
                
                <br>
                <table dir="<%=dir%>" align="<%=align%>" width="800">
                    <tr>
                        <td class="td" bgcolor="plum" colspan="6" style="font-size:16;color:white;text-align:center"><b><%=savedS%></b></td>
                    </tr>
                    <tr bgcolor="mistyrose">
                        <td class="td" align="center" style="font-size:15;text-align:center"><b><%=serial%></b></td>
                        <td class="td" align="center" style="font-size:15;text-align:center"><b><%=storeName%></b></td>
                        <td class="td" align="center" style="font-size:15;text-align:center"><b><%=storeNo%></b></td>
                        <td class="td" align="center" style="font-size:15;text-align:center"><b><%=storeLoc%></b></td>
                        <td class="td" align="center" style="font-size:15;text-align:center"><b><%=storeEmp%></b></td>
                        <td class="td" align="center" style="font-size:15;text-align:center"><b><%=storeTel%></b></td>
                    </tr>
                    <%
                    if(savedData.size()>0){
                        for(int i=0; i<savedData.size(); i++){
                            Vector rowData = (Vector) savedData.elementAt(i);
                    %>
                    <tr bgcolor="lavenderblush">
                        <td class="td" align="center" style="font-size:12;text-align:center"><B><%=i+1%></B></td>
                        <td class="td" align="center" style="font-size:12;text-align:center"><B><%=rowData.elementAt(0).toString()%></B></td>
                        <td class="td" align="center" style="font-size:12;text-align:center"><B><%=rowData.elementAt(1).toString()%></B></td>
                        <td class="td" align="center" style="font-size:12;text-align:center"><B><%=rowData.elementAt(2).toString()%></B></td>
                        <td class="td" align="center" style="font-size:12;text-align:center"><B><%=rowData.elementAt(3).toString()%></B></td>
                        <td class="td" align="center" style="font-size:12;text-align:center"><B><%=rowData.elementAt(4).toString()%></B></td>
                    </tr>
                    <%
                        }
                    } else {
                    %>
                    <tr bgcolor="lavenderblush">
                        <td class="td" align="center" style="font-size:12;text-align:center" colspan="6"><B><%=noData%></B></td>
                    </tr>
                    <%}%>
                </table>
                
                <br>
                <table dir="<%=dir%>" align="<%=align%>" width="800">
                    <tr>
                        <td class="td" bgcolor="red" colspan="6" style="font-size:16;color:white;text-align:center"><b><%=unsavedS%></b></td>
                    </tr>
                    <tr bgcolor="mistyrose">
                        <td class="td" align="center" style="font-size:15;text-align:center"><b><%=serial%></b></td>
                        <td class="td" align="center" style="font-size:15;text-align:center"><b><%=storeName%></b></td>
                        <td class="td" align="center" style="font-size:15;text-align:center"><b><%=storeNo%></b></td>
                        <td class="td" align="center" style="font-size:15;text-align:center"><b><%=storeLoc%></b></td>
                        <td class="td" align="center" style="font-size:15;text-align:center"><b><%=storeEmp%></b></td>
                        <td class="td" align="center" style="font-size:15;text-align:center"><b><%=storeTel%></b></td>
                    </tr>
                    <%
                    if(unsavedData.size()>0){
                        for(int i=0; i<unsavedData.size(); i++){
                            Vector rowData = (Vector) unsavedData.elementAt(i);
                    %>
                    <tr bgcolor="lavenderblush">
                        <td class="td" align="center" style="font-size:12;text-align:center"><B><%=i+1%></B></td>
                        <td class="td" align="center" style="font-size:12;text-align:center"><B><%=rowData.elementAt(0).toString()%></B></td>
                        <td class="td" align="center" style="font-size:12;text-align:center"><B><%=rowData.elementAt(1).toString()%></B></td>
                        <td class="td" align="center" style="font-size:12;text-align:center"><B><%=rowData.elementAt(2).toString()%></B></td>
                        <td class="td" align="center" style="font-size:12;text-align:center"><B><%=rowData.elementAt(3).toString()%></B></td>
                        <td class="td" align="center" style="font-size:12;text-align:center"><B><%=rowData.elementAt(4).toString()%></B></td>
                    </tr>
                    <%
                        }
                    } else {
                    %>
                    <tr bgcolor="lavenderblush">
                        <td class="td" align="center" style="font-size:12;text-align:center" colspan="6"><B><%=noData%></B></td>
                    </tr>
                    <%}%>
                </table>
                <br>
            </fieldset>
        </FORM>
    </body>
</html>