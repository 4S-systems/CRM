<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*, com.tracker.common.*,com.tracker.business_objects.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page pageEncoding="UTF-8"%>
<HTML>
    <%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();

    String scheduleTitle = (String) request.getAttribute("scheduleTitle");
    WebBusinessObject issueDetails = (WebBusinessObject) request.getAttribute("issueDetails");
    Vector<WebBusinessObject> tasks, items;
    WebBusinessObject wboIssue;

    String cMode= (String) request.getSession().getAttribute("currentMode");
    String  stat=cMode;
    String align=null;
    String dir=null;
    String style=null;
    String lang, langCode, close, print, title, notFoundJobOrder, jobOrderNo, unitName, jobOrderType, jobOrderStatus, siteName, siteEntryDate;
    String strTasks, strItems, taskName, taskCode, notFoundTask, notFoundItems, codeItem, nameItem, quantityItem;
    String divAlign;

    if(stat.equals("En")){
        align="center";
        divAlign = "left";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        langCode="Ar";
        close = "Close";
        print = "Print";
        title = "Last Issue For Schedule";
        notFoundJobOrder = "Not Found Job Order";
        jobOrderNo = "Job Order No";
        unitName = "Job Order for Machine";
        jobOrderType = "Work Order Trade";
        jobOrderStatus = "Current Status";
        siteName = "Site Name";
        siteEntryDate = "Site Entry Date";
        strItems = "Spare Parts";
        strTasks = "Tasks";
        taskCode = "Task Code";
        taskName = "Task Name";
        notFoundItems = "Not Found Spare Parts";
        notFoundTask = "Not Found Tasks";
        codeItem = "&#1603;&#1600;&#1608;&#1583; &#1575;&#1604;&#1600;&#1602;&#1600;&#1591;&#1600;&#1593;&#1600;&#1577;";
        nameItem = "&#1575;&#1587;&#1600;&#1605; &#1575;&#1604;&#1600;&#1602;&#1600;&#1591;&#1600;&#1593;&#1600;&#1577;";
        quantityItem = "&#1575;&#1604;&#1600;&#1603;&#1600;&#1605;&#1600;&#1610;&#1600;&#1577;";
    }else{
        align="center";
        divAlign = "right";
        dir="RTL";
        style="text-align:right";
        lang="   English    ";
        langCode="En";
        close = "&#1594;&#1604;&#1602;";
        print = "&#1575;&#1591;&#1576;&#1593;";
        title = "&#1575;&#1582;&#1585; &#1571;&#1605;&#1585; &#1588;&#1594;&#1604; &#1604;&#1580;&#1583;&#1608;&#1604; &#1589;&#1610;&#1575;&#1606;&#1577;";
        notFoundJobOrder = "&#1604;&#1575;&#1610;&#1600;&#1608;&#1580;&#1600;&#1583; &#1571;&#1608;&#1575;&#1605;&#1600;&#1585; &#1588;&#1600;&#1594;&#1600;&#1604;";
        jobOrderNo = "&#1585;&#1602;&#1605; &#1571;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
        unitName = "&#1571;&#1605;&#1585; &#1588;&#1594;&#1604; &#1604;&#1605;&#1593;&#1583;&#1607;";
        jobOrderType = "&#1606;&#1608;&#1593; &#1571;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
        jobOrderStatus = "&#1575;&#1604;&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1581;&#1575;&#1604;&#1610;&#1577;";
        siteName = "&#1573;&#1587;&#1605; &#1575;&#1604;&#1605;&#1608;&#1602;&#1593;";
        siteEntryDate = "&#1608;&#1602;&#1578;&nbsp; &#1583;&#1582;&#1608;&#1604; &#1575;&#1604;&#1608;&#1585;&#1588;&#1607;";
        strTasks = "&#1576;&#1600;&#1606;&#1600;&#1608;&#1583; &#1575;&#1604;&#1600;&#1589;&#1600;&#1610;&#1600;&#1575;&#1606;&#1600;&#1577;";
        strItems = "&#1602;&#1600;&#1591;&#1600;&#1593; &#1575;&#1604;&#1600;&#1594;&#1600;&#1610;&#1600;&#1575;&#1585;";
        taskCode = "&#1603;&#1600;&#1608;&#1583; &#1575;&#1604;&#1600;&#1576;&#1600;&#1606;&#1600;&#1583;";
        taskName = "&#1575;&#1587;&#1600;&#1605; &#1575;&#1604;&#1600;&#1576;&#1600;&#1606;&#1600;&#1583;";
        notFoundTask = "&#1604;&#1575;&#1610;&#1600;&#1608;&#1580;&#1600;&#1583; &#1576;&#1600;&#1606;&#1600;&#1608;&#1583; &#1589;&#1600;&#1610;&#1600;&#1575;&#1606;&#1600;&#1577;";
        notFoundItems = "&#1604;&#1575; &#1610;&#1600;&#1608;&#1580;&#1600;&#1583; &#1602;&#1600;&#1591;&#1600;&#1594; &#1594;&#1600;&#1600;&#1610;&#1600;&#1575;&#1585;";
        codeItem = "&#1603;&#1600;&#1608;&#1583; &#1575;&#1604;&#1600;&#1602;&#1600;&#1591;&#1600;&#1593;&#1600;&#1577;";
        nameItem = "&#1575;&#1587;&#1600;&#1605; &#1575;&#1604;&#1600;&#1602;&#1600;&#1591;&#1600;&#1593;&#1600;&#1577;";
        quantityItem = "&#1575;&#1604;&#1600;&#1603;&#1600;&#1605;&#1600;&#1610;&#1600;&#1577;";
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
                                <FONT color='white' SIZE="4"><%=title%></FONT>
                            </td>
                            <td style="text-align:center;border-color: #006699;" width="50%" class="blueBorder blueHeaderTD">
                                 <FONT color='white' SIZE="4">(&ensp;<FONT color='#F3D596' SIZE="4"><%=scheduleTitle%></FONT>&ensp;)</FONT>
                            </td>
                        </tr>
                    </table>
                    <br>
                    <%
                    if(issueDetails != null) {
                        wboIssue = (WebBusinessObject) issueDetails.getAttribute("issue");
                        items = (Vector) issueDetails.getAttribute("items");
                        tasks = (Vector) issueDetails.getAttribute("tasks");
                    %>
                    <table dir="<%=dir%>" class="blueBorder" width="90%" cellpadding="0" cellspacing="0" align="center">
                        <tr>
                            <td class="blueBorder blueHeaderTD" width="25%" style="background-color: #bbc4d0;color: black">
                                <%=jobOrderNo%>
                            </td>
                            <td class="blueBorder blueBodyTD" width="25%">
                                <font color="blue"><%=wboIssue.getAttribute("businessID")%></font><font color="red">/<%=wboIssue.getAttribute("businessIDbyDate")%></font>
                            </td>
                            <td class="blueBorder blueHeaderTD" width="25%" style="background-color: #bbc4d0;color: black">
                                <%=unitName%>
                            </td>
                            <td class="blueBorder blueBodyTD" width="25%">
                                <%=issueDetails.getAttribute("unitName")%>
                            </td>
                        </tr>
                        <tr>
                            <td class="blueBorder blueHeaderTD" width="25%" style="background-color: #bbc4d0;color: black">
                                <%=jobOrderType%>
                            </td>
                            <td class="blueBorder blueBodyTD" width="25%">
                                <%=issueDetails.getAttribute("tradeName")%>
                            </td>
                            <td class="blueBorder blueHeaderTD" width="25%" style="background-color: #bbc4d0;color: black">
                                <%=jobOrderStatus%>
                            </td>
                            <td class="blueBorder blueBodyTD" width="25%">
                                <%=wboIssue.getAttribute("currentStatus")%>
                            </td>
                        </tr>
                        <tr>
                            <td class="blueBorder blueHeaderTD" width="25%" style="background-color: #bbc4d0;color: black">
                                <%=siteName%>
                            </td>
                            <td class="blueBorder blueBodyTD" width="25%">
                                <%=issueDetails.getAttribute("projectName")%>
                            </td>
                            <td class="blueBorder blueHeaderTD" width="25%" style="background-color: #bbc4d0;color: black">
                                <%=siteEntryDate%>
                            </td>
                            <td class="blueBorder blueBodyTD" width="25%">
                                <%=wboIssue.getAttribute("siteEntryDate")%>
                            </td>
                        </tr>
                    </table>
                    <div align="<%=divAlign%>" style="margin-<%=divAlign%>: 5%;color: blue">
                        <p dir="rtl" align="center" style="background-color: #E6E6FA;width:20%;font-weight: bold;font-size: 18px"><b><%=strTasks%></b></p>
                    </div>
                    <table dir="<%=dir%>" class="blueBorder" width="90%" cellpadding="0" cellspacing="0" align="center">
                        <%if(tasks.size() > 0) { %>
                            <tr>
                                <td class="blueBorder blueHeaderTD" width="5%" style="background-color: #bbc4d0;color: black">
                                    #
                                </td>
                                <td class="blueBorder blueHeaderTD" width="45%" style="background-color: #bbc4d0;color: black">
                                    <%=taskCode%>
                                </td>
                                <td class="blueBorder blueHeaderTD" width="45%" style="background-color: #bbc4d0;color: black">
                                    <%=taskName%>
                                </td>
                            </tr>
                            <%
                            int index = 0;
                            for(WebBusinessObject wbo : tasks) {
                                index++;
                            %>
                            <tr>
                                <td class="blueBorder blueBodyTD">
                                    <%=index%>
                                </td>
                                <td class="blueBorder blueBodyTD">
                                    <%=wbo.getAttribute("code")%>
                                </td>
                                <td class="blueBorder blueBodyTD">
                                    <%=wbo.getAttribute("name")%>
                                </td>
                            </tr>
                            <% } %>
                        <% } else { %>
                        <tr>
                            <td class="blueBorder blueHeaderTD" width="5%" style="background-color: #bbc4d0;color: black">
                                <%=notFoundTask%>
                            </td>
                        </tr>
                        <% } %>
                    </table>
                    <div align="<%=divAlign%>" style="margin-<%=divAlign%>: 5%;color: blue">
                        <p dir="rtl" align="center" style="background-color: #E6E6FA;width:20%;font-weight: bold;font-size: 18px"><b><%=strItems%></b></p>
                    </div>
                    <table dir="<%=dir%>" class="blueBorder" width="90%" cellpadding="0" cellspacing="0" align="center">
                        <%if(items.size() > 0) { %>
                        <tr>
                            <td class="blueBorder blueHeaderTD" width="5%" style="background-color: #bbc4d0;color: black">
                                #
                            </td>
                            <td class="blueBorder blueHeaderTD" width="30%" style="background-color: #bbc4d0;color: black">
                                <%=codeItem%>
                            </td>
                            <td class="blueBorder blueHeaderTD" width="45%" style="background-color: #bbc4d0;color: black">
                                <%=nameItem%>
                            </td>
                            <td class="blueBorder blueHeaderTD" width="15%" style="background-color: #bbc4d0;color: black">
                                <%=quantityItem%>
                            </td>
                        </tr>
                            <%
                            int index = 0;
                            for(WebBusinessObject wbo : items) {
                                index++;
                            %>
                            <tr>
                                <td class="blueBorder blueBodyTD">
                                    <%=index%>
                                </td>
                                <td class="blueBorder blueBodyTD">
                                    <%=wbo.getAttribute("itemId")%>
                                </td>
                                <td class="blueBorder blueBodyTD">
                                    <%=wbo.getAttribute("itemDesc")%>
                                </td>
                                <td class="blueBorder blueBodyTD">
                                    <%=wbo.getAttribute("itemQuantity")%>
                                </td>
                            </tr>
                            <% } %>
                        <% } else { %>
                        <tr>
                            <td class="blueBorder blueHeaderTD" width="5%" style="background-color: #bbc4d0;color: black">
                                <%=notFoundItems%>
                            </td>
                        </tr>
                        <% } %>
                    </table>
                    <% } else { %>
                        <table class="blueBorder" width="90%" cellpadding="0" cellspacing="0" align="center">
                            <tr>
                                <td class="blueHeaderTD blueBorder" style="background-color: #bbc4d0;color: red">
                                    <%=notFoundJobOrder%>
                                </td>
                            </tr>
                        </table>
                    <% } %>
                    <br>
                </fieldset>
            </center>
        </FORM>
    </BODY>
</HTML>