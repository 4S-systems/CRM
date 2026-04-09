<%@page import="com.maintenance.common.Tools"%>
<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*"%>
<%@ page import="com.maintenance.common.ConfigFileMgr,com.tracker.db_access.ProjectMgr" %>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    <HEAD>
        <TITLE>Costing Report</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/CSS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/headers.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/Button.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/blueStyle.css">
        <script type="text/css" src="js/sorttable.js"></script>
    </HEAD>
    <%
                MetaDataMgr metaMgr = MetaDataMgr.getInstance();
                String context = metaMgr.getContext();

                int iTotal = 0;

                Vector data = (Vector) request.getAttribute("data");
                String beginDate = (String) request.getAttribute("beginDate");
                String endDate = (String) request.getAttribute("endDate");

                String issueTitle = (String) request.getAttribute("issueTitle");
                String orderBy = (String) request.getAttribute("orderBy");
                String unitName = (String) request.getAttribute("unitName");


                Hashtable logos = new Hashtable();
                logos = (Hashtable) session.getAttribute("logos");

                String cMode = (String) request.getSession().getAttribute("currentMode");
                String stat = cMode;
                String align = null, alignTable;
                String dir = null;
                String style = null;
                String lang, langCode, jobNo, begin, end, equip, costLabor, costSpareParts, costTotal, strTotal, bothMaintType, emgMaintType, notEmgMaintType;
                String title, notFoundJo, close, print, divAlign, maintType, orderingJobOrder, acs, desc, allEquipment;
                if (stat.equals("En")) {
                    align = "center";
                    dir = "LTR";
                    style = "text-align:left";
                    alignTable = "left";
                    lang = "   &#1593;&#1585;&#1576;&#1610;    ";
                    langCode = "Ar";
                    divAlign = "left";

                    close = "Close";
                    print = "Print";

                    costLabor = "Costing Labor";
                    costSpareParts = "Costing Spare Parts";
                    costTotal = "Total Costing";
                    strTotal = "Total Costing";

                    orderingJobOrder = "Ordering Job Order";
                    acs = "Ascending";
                    desc = "Descending";
                    allEquipment = "All Equipmets";

                    bothMaintType = "Periodic & Emergency Maintenance";
                    emgMaintType = "Emergency Maintenance";
                    notEmgMaintType = "Periodic Maintenance";

                    jobNo = "Job Order No.";
                    begin = "From Date";
                    end = "To Date";
                    equip = "Equipment";
                    title = "Total Costing";
                    maintType = "Maintenance Type";
                    notFoundJo = "No Job Orders in the Period";
                } else {
                    align = "center";
                    dir = "RTL";
                    style = "text-align:Right";
                    alignTable = "right";
                    lang = "English";
                    langCode = "En";
                    divAlign = "right";

                    close = "&#1594;&#1604;&#1602;";
                    print = "&#1575;&#1591;&#1576;&#1593;";

                    allEquipment = "&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1583;&#1575;&#1578;";

                    costLabor = "&#1578;&#1603;&#1604;&#1601;&#1577; &#1575;&#1604;&#1593;&#1605;&#1575;&#1604;&#1577;";
                    costSpareParts = "&#1578;&#1603;&#1604;&#1601;&#1577; &#1602;&#1591;&#1593; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585;";
                    costTotal = "&#1575;&#1604;&#1578;&#1603;&#1604;&#1601;&#1577; &#1575;&#1604;&#1603;&#1604;&#1610;&#1577;";
                    strTotal = "&#1575;&#1604;&#1578;&#1603;&#1604;&#1601;&#1577; &#1575;&#1604;&#1571;&#1580;&#1605;&#1575;&#1604;&#1610;&#1577;";

                    orderingJobOrder = "&#1578;&#1600;&#1585;&#1578;&#1600;&#1610;&#1600;&#1576; &#1571;&#1608;&#1575;&#1605;&#1600;&#1585; &#1575;&#1604;&#1600;&#1588;&#1600;&#1594;&#1600;&#1604;";
                    acs = "&#1578;&#1589;&#1575;&#1593;&#1583;&#1610;&#1575;";
                    desc = "&#1578;&#1606;&#1575;&#1586;&#1604;&#1610;&#1575;";

                    bothMaintType = "&#1589;&#1610;&#1575;&#1606;&#1577; &#1591;&#1575;&#1585;&#1574;&#1577; &#1608; &#1583;&#1608;&#1585;&#1610;&#1577;";
                    emgMaintType = "&#1589;&#1610;&#1575;&#1606;&#1577; &#1591;&#1575;&#1585;&#1574;&#1577;";
                    notEmgMaintType = "&#1589;&#1610;&#1575;&#1606;&#1577; &#1583;&#1608;&#1585;&#1610;&#1577;";

                    jobNo = "&#1585;&#1602;&#1605; &#1575;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
                    begin = "&#1605;&#1606; &#1578;&#1575;&#1585;&#1610;&#1582;";
                    end = "&#1575;&#1604;&#1609; &#1578;&#1575;&#1585;&#1610;&#1582;";
                    equip = "&#1605;&#1593;&#1583;&#1577;";
                    title = "&#1578;&#1602;&#1585;&#1610;&#1585; &#1575;&#1604;&#1578;&#1603;&#1604;&#1601;&#1577; &#1575;&#1604;&#1571;&#1580;&#1605;&#1575;&#1604;&#1610;&#1577;";
                    maintType = "&#1606;&#1608;&#1593; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
                    notFoundJo = "&#1604;&#1575;&#1578;&#1600;&#1608;&#1580;&#1600;&#1583; &#1571;&#1608;&#1575;&#1605;&#1600;&#1585; &#1588;&#1600;&#1594;&#1600;&#1604; &#1601;&#1600;&#1609; &#1578;&#1600;&#1604;&#1603; &#1575;&#1604;&#1601;&#1600;&#1578;&#1600;&#1585;&#1577;";
                }

    %>
    <script type="text/javascript" src="js/ChangeLang.js"></script>
    <script language="javascript" type="text/javascript">
        
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

        function printWindow(){
            document.getElementById('btnDiv').style.display = "none";
            window.print();
            document.getElementById('btnDiv').style.display = "block";
        }

    </script>
    <style type="text/css" >
        .thead {
            color:black;
            font:14px;
            border-left-width:1px;
            height:50px;
            border-color:black;
            font-weight:lighter;
            padding:5px;
            cursor:pointer
        }
        .row {
            background:white;
            color:black;
            font:12px;
            height:25px;
            text-align:center;
            border-color:black;
            font-weight:bold;
            padding:2px;
        }
    </style>
    <body>
        <DIV align="left" STYLE="color:blue;" ID="btnDiv">
            <input type="button" style="width:100px" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
            &ensp;
            <input type="button" style="width:100px" value="<%=close%>" onclick="window.close()" class="button">
            &ensp;
            <input type="button" style="width:100px" value="<%=print%>" onclick="JavaScript:printWindow();" class="button">
        </DIV>
        <br>
        <center>
            <table border="0" width="95%" id="table1" dir="LTR">
                <tr>
                    <td class="td" width="35%" colspan="2">
                        <img alt=""  border="0" src="images/<%=logos.get("headReport3").toString()%>" width="180" height="200" align="left">
                    </td>
                    <td class="td" width="65%" colspan="2">
                        <TABLE  ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="100%" CELLPADDING="0" CELLSPACING="0">
                            <TR>
                                <td class="td" colspan="4" bgcolor="#D0D0D0" style="text-align:center;border:0">
                                    <b><font size="5" color="blue"><label id="title"><%=title%></label></font></b>
                                </td>
                            </TR>
                            <TR>
                                <td class="td" colspan="4" style="text-align:center;border:0">
                                    &ensp;
                                </td>
                            </TR>
                            <TR>
                                <TD class="td" colspan="4" style="text-align:center;border:0">
                                    <TABLE CLASS="blueBorder" style="border-color: black" ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="100%" CELLPADDING="0" CELLSPACING="0">
                                        <TR>
                                            <TD CLASS="thead" nowrap WIDTH="3%" STYLE="height:15px" bgcolor="#D0D0D0">
                                                <B><%=begin%></B>
                                            </TD>
                                            <TD CLASS="row" >
                                                <%=beginDate%>
                                            </TD>
                                            <TD CLASS="thead" nowrap WIDTH="3%" STYLE="height:15px" bgcolor="#D0D0D0">
                                                <B><%=end%></B>
                                            </TD>
                                            <TD CLASS="row" >
                                                <%=endDate%>
                                            </TD>
                                        </TR>
                                        <TR>
                                            <TD CLASS="thead" nowrap WIDTH="3%" STYLE="height:15px" bgcolor="#D0D0D0">
                                                <B><%=equip%></B>
                                            </TD>
                                            <TD CLASS="row" >
                                                <% if(unitName != null) { %>
                                                    <%=unitName%>
                                                <% } else {%>
                                                    <%=allEquipment%>
                                                <% } %>
                                            </TD>
                                            <TD CLASS="thead" nowrap WIDTH="3%" STYLE="height:15px" bgcolor="#D0D0D0">
                                                <B><%=maintType%></B>
                                            </TD>
                                            <TD CLASS="row" >
                                                <%if("Emergency".equals(issueTitle)) {%>
                                                    <%=emgMaintType%>
                                                <% } else if("notEmergency".equals(issueTitle)) { %>
                                                    <%=notEmgMaintType%>
                                                <% } else { %>
                                                    <%=bothMaintType%>
                                                <% } %>
                                            </TD>
                                        </TR>
                                        <TR>
                                            <TD colspan="2" CLASS="thead" nowrap WIDTH="3%" STYLE="height:15px" bgcolor="#D0D0D0">
                                                <b><%=orderingJobOrder%></b>
                                            </TD>
                                            <TD colspan="2" CLASS="row">
                                                <%if("acs".equals(orderBy)) {%>
                                                    <b><%=acs%></b>
                                                <% } else { %>
                                                    <b><%=desc%></b>
                                                <% } %>
                                            </TD>
                                        </TR>
                                    </TABLE>
                                </TD>
                            </TR>
                        </TABLE>
                    </td>
                </tr>
            </table>
            <br>
            <%if (data.size() > 0) {%>
            <div id="fig1" style="width:95%" >
                <TABLE border="0" style="border-width: 0px" class="sortable" ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="100%" CELLPADDING="0" CELLSPACING="0">
                    <%
                        WebBusinessObject wboDetails;
                        Vector<WebBusinessObject> list;
                        String strSumCost, strdTotalCost;
                        double dcostItems, dcostTasks, dTotalCost, sumCost = 0.00, finalCosting = 0.00;
                        for (int i = 0; i < data.size(); i++) {
                            wboDetails = (WebBusinessObject) data.get(i);
                            unitName = (String) wboDetails.getAttribute("unitName");
                            list = (Vector) wboDetails.getAttribute("list");
                            iTotal = 0;
                    %>
                    <TR>
                        <TD style="border-width: 0px">
                            <div align="<%=divAlign%>" style="margin-<%=divAlign%>: 0px;margin-bottom: 10px;margin-top: 10px">
                                <p dir="rtl" style="background-color: #E6E6FA;width:50%;padding-<%=divAlign%>: 5px"><b><font color="red"><%=equip%></font></b><b>&ensp;:&ensp;<%=unitName%></b></p>
                            </div>
                        </TD>
                    </TR>
                    <TR>
                        <TD style="border-width: 0px">
                            <TABLE class="sortable blueBorder" style="border-color: black;" ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="100%" CELLPADDING="0" CELLSPACING="0">
                                <TR>
                                    <TD CLASS="blueBorder blueHeaderTD" style="border-color: black;background-color: #989898;color: black;color: black" nowrap WIDTH="5%">
                                        <B>#</B>
                                    </TD>
                                    <TD CLASS="blueBorder blueHeaderTD" style="border-color: black;background-color: #989898;color: black" nowrap WIDTH="25%">
                                        <B><%=jobNo%></B>
                                    </TD>
                                    <TD CLASS="blueBorder blueHeaderTD" style="border-color: black;background-color: #989898;color: black" nowrap WIDTH="20%">
                                        <B><%=costLabor%></B>
                                    </TD>
                                    <TD CLASS="blueBorder blueHeaderTD" style="border-color: black;background-color: #989898;color: black" nowrap>
                                        <B><%=costSpareParts%></B>
                                    </TD>
                                    <TD CLASS="blueBorder blueHeaderTD" style="border-color: black;background-color: #989898;color: black" nowrap>
                                        <B><%=costTotal%></B>
                                    </TD>
                                </TR>
                                <%
                                sumCost = 0.00;
                                for(WebBusinessObject wbo : list) {
                                    dcostItems = (Double) wbo.getAttribute("dcostItems");
                                    dcostTasks = (Double) wbo.getAttribute("dcostTasks");

                                    dTotalCost = dcostItems + dcostTasks;
                                    sumCost += dTotalCost;
                                    strdTotalCost = Tools.getCurrency(String.valueOf(dTotalCost));
                                    iTotal++;
                                %>
                                <TR>
                                    <TD CLASS="blueBorder blueBodyTD" style="border-color: black;" >
                                        <%=iTotal%>
                                    </TD>
                                    <TD CLASS="blueBorder blueBodyTD" style="border-color: black;">
                                        <b><font color="red" style="font-weight: bold"><%=wbo.getAttribute("issueCode")%></font><font color="blue" style="font-weight: bold">/<%=wbo.getAttribute("issueCodeByDate")%></font></b>
                                    </TD>
                                    <TD CLASS="blueBorder blueBodyTD" style="border-color: black;">
                                        <b><%=wbo.getAttribute("costTasks")%></b>
                                    </TD>
                                    <TD CLASS="blueBorder blueBodyTD" style="border-color: black;">
                                        <b> <%=wbo.getAttribute("costItems")%> </b>
                                    </TD>
                                    <TD CLASS="blueBorder blueBodyTD" style="border-color: black;">
                                        <b> <%=strdTotalCost%> </b>
                                    </TD>
                                </TR>
                                <% 
                                }
                                strSumCost = Tools.getCurrency(String.valueOf(sumCost));
                                finalCosting += sumCost;
                                %>
                                <TR>
                                    <TD colspan="4" CLASS="blueBorder blueHeaderTD" style="border-color: black;background-color: #D0D0D0;color: black;height: 15px" nowrap>
                                        <B><%=strTotal%></B>
                                    </TD>
                                    <TD CLASS="blueBorder blueHeaderTD" style="border-color: black;background-color: #D0D0D0;color: black;height: 20px" nowrap>
                                        <B><%=strSumCost%></B>
                                    </TD>
                                </TR>
                            </TABLE>
                        </TD>
                    </TR>
                    <%}%>
                    <TR>
                        <TD style="border-width: 0px;height: 10px">
                            &ensp;
                        </TD>
                    </TR>
                    <TR>
                        <TD style="border-width: 0px">
                            <TABLE class="sortable blueBorder" style="border-color: black;" ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="100%" CELLPADDING="0" CELLSPACING="0">
                                <TR>
                                    <TD CLASS="blueBorder blueHeaderTD" style="border-color: black;background-color: #989898;color: black;color: black" nowrap WIDTH="5%">
                                        <B><%=strTotal%></B>
                                    </TD>
                                    <TD CLASS="blueBorder blueHeaderTD" style="border-color: black;background-color: #989898;color: black;color: black" nowrap WIDTH="5%">
                                        <B><B><%=Tools.getCurrency(String.valueOf(finalCosting))%></B></B>
                                    </TD>
                                </TR>
                            </TABLE>
                        </TD>
                    </TR>
                </TABLE>
            </div>
            
            <%} else {%>
            <TABLE ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="100%" CELLPADDING="0" CELLSPACING="0">
                <TR>
                    <td class="td" colspan="4" bgcolor="#D0D0D0" style="text-align:center;border:0">
                        <b><font size="3" color="blue"><label id="title"><%=notFoundJo%></label></font></b>
                    </td>
                </TR>
            </TABLE>
            <%}%>
        </center>
        <br>
    </body>
</html>
