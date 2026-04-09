<%@page import="com.maintenance.db_access.WarrantyItemsMgr"%>
<%@page import="com.maintenance.common.Tools"%>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%
            MetaDataMgr metaMgr = MetaDataMgr.getInstance();
            String context = metaMgr.getContext();

            TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
            Hashtable allWarrantyInfo = (Hashtable) request.getAttribute("warrantyInfo");
            Vector quantifiedItems = (Vector) request.getAttribute("quantifiedItems");
            Vector configureItems = (Vector) request.getAttribute("configureItems");
            WebBusinessObject wbo = (WebBusinessObject) request.getAttribute("wbo");
            String attachedEqFlag = (String) request.getAttribute("attachedEqFlag");
            String eq_isStandAlone = (String) request.getAttribute("isStandalone");
            String currentStatus = new String("");
            if (wbo.getAttribute("currentStatus") != null) {
                currentStatus = (String) wbo.getAttribute("currentStatus");
            }
            String bgColor;
            double iConfigureTotal = 0;
            double iQuantifiedTotal = 0;
            double iActualTotal = 0;

            String display = "none";
            if (allWarrantyInfo.size() > 0) {
                display = "block";
            }

            String cMode = (String) request.getSession().getAttribute("currentMode");
            String stat = cMode;

            String align = null;
            String dir = null;
            String style = null;
            String lang, langCode, ViewSpars, attachedOn, partType, BackToList, schduled, finished, categlog, ToCost,
                    Begined, Finished, head, attached, Canceled, onAttachedEq, onMainEq, sparePartType, lacalSpare, ERPSpare, operation, delete, status, cost, count, price, name, code, update, viewTaskSpar, warranty, addWarranty, vendor, bDate, eDate, note, warrantyInfo, submit;
            if (stat.equals("En")) {

                align = "center";
                dir = "LTR";
                style = "text-align:left";

                lang = "   &#1593;&#1585;&#1576;&#1610;    ";
                langCode = "Ar";
                ViewSpars = "View Spare Parts";
                BackToList = "Back to list";
                schduled = "Scheduled";
                Begined = "Begined";
                Finished = "Finished";
                Canceled = "Canceled";
                status = "Status";
                code = "Code";
                name = "Name";
                price = "Price";
                count = "countity";
                cost = "Cost";
                finished = "After Execution Spare Parts";
                categlog = "Planned Spare Parts";
                ToCost = "Total Cost";
                viewTaskSpar = "View Spare Parts";
                sparePartType = "Spare Part Type";
                ERPSpare = "Non Local Spare Parts";
                lacalSpare = "Local Spare Parts Direct purchasing";
                partType = "Part Type";
                attachedOn = "Attached On";
                onAttachedEq = "On Attached Equipment";
                onMainEq = "On Main Equipment";
                head = "Main";
                attached = "Attached";
                warranty = "Warranty";
                addWarranty = "Add Warranty";
                vendor = "Vendor";
                bDate = "Begin Date";
                eDate = "End Date";
                note = "Note";
                warrantyInfo = "Warranty Information";
                submit = "update";
                update = "Edit";
                delete = "Delete";
                operation = "Basic Operation";
            } else {

                align = "center";
                dir = "RTL";
                style = "text-align:Right";
                lang = "English";
                langCode = "En";
                ViewSpars = " &#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1602;&#1591;&#1593; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585;";
                BackToList = "&#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1573;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577;";
                schduled = "&#1605;&#1580;&#1583;&#1608;&#1604;&#1577;";
                Begined = "&#1576;&#1583;&#1571;&#1578;";
                Finished = "&#1573;&#1606;&#1578;&#1607;&#1578;";
                Canceled = "&#1605;&#1604;&#1594;&#1575;&#1577;";
                status = "&#1575;&#1604;&#1581;&#1575;&#1604;&#1577;";
                code = "&#1603;&#1608;&#1583; &#1575;&#1604;&#1602;&#1591;&#1593;&#1577;";
                name = "&#1575;&#1587;&#1605; &#1575;&#1604;&#1602;&#1591;&#1593;&#1577;";
                price = "&#1587;&#1593;&#1585; &#1575;&#1604;&#1608;&#1581;&#1583;&#1577;";
                count = "&#1575;&#1604;&#1603;&#1605;&#1610;&#1577;";
                cost = "&#1573;&#1580;&#1605;&#1575;&#1604;&#1610; &#1575;&#1604;&#1587;&#1593;&#1585;";
                finished = "&#1602;&#1591;&#1593; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585; &#1576;&#1593;&#1583; &#1575;&#1604;&#1578;&#1606;&#1601;&#1610;&#1584;";
                categlog = "&#1602;&#1591;&#1593; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585; &#1575;&#1604;&#1605;&#1582;&#1591;&#1591;&#1577;";
                ToCost = "&#1573;&#1580;&#1605;&#1575;&#1604;&#1610;";
                viewTaskSpar = "&#1593;&#1585;&#1590; &#1602;&#1591;&#1593; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585;";
                sparePartType = "&#1606;&#1600;&#1600;&#1600;&#1600;&#1608;&#1593; &#1602;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1591;&#1600;&#1600;&#1593; &#1575;&#1604;&#1600;&#1600;&#1594;&#1600;&#1600;&#1610;&#1600;&#1600;&#1575;&#1585;";
                ERPSpare = "&#1602;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1591;&#1600;&#1600;&#1593; &#1575;&#1604;&#1600;&#1600;&#1594;&#1600;&#1600;&#1610;&#1600;&#1600;&#1575;&#1585; &#1605;&#1600;&#1606; &#1575;&#1604;&#1600;&#1605;&#1600;&#1582;&#1600;&#1575;&#1586;&#1606; &#1575;&#1604;&#1600;&#1582;&#1575;&#1585;&#1580;&#1600;&#1610;&#1600;&#1607;";
                lacalSpare = "&#1602;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1591;&#1600;&#1600;&#1593; &#1575;&#1604;&#1600;&#1600;&#1594;&#1600;&#1600;&#1610;&#1600;&#1600;&#1575;&#1585; &#1605;&#1606; &#1575;&#1604;&#1588;&#1585;&#1575;&#1569; &#1605;&#1576;&#1575;&#1588;&#1585;&#1577;";
                partType = "&#1606;&#1608;&#1593; &#1575;&#1604;&#1602;&#1591;&#1593;&#1607;";
                attachedOn = "&#1578;&#1605;&#1610;&#1610;&#1586; &#1575;&#1604;&#1602;&#1591;&#1593;&#1607;";
                onAttachedEq = "&#1602;&#1591;&#1593;&#1607; &#1594;&#1610;&#1575;&#1585; &#1593;&#1604;&#1609; &#1605;&#1602;&#1591;&#1608;&#1585;&#1607;";
                onMainEq = "&#1602;&#1591;&#1593;&#1607; &#1594;&#1610;&#1575;&#1585; &#1593;&#1604;&#1609; &#1602;&#1575;&#1591;&#1585;&#1607;";
                head = "&#1585;&#1571;&#1587;";
                attached = "&#1605;&#1604;&#1581;&#1602;";
                warranty = "&#1575;&#1604;&#1590;&#1605;&#1575;&#1606;";
                addWarranty = "&#1575;&#1590;&#1575;&#1601;&#1577; &#1590;&#1605;&#1575;&#1606;";
                vendor = "&#1575;&#1604;&#1605;&#1608;&#1585;&#1583;";
                bDate = "&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1576;&#1583;&#1575;&#1610;&#1607;";
                eDate = "&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1575;&#1606;&#1578;&#1607;&#1575;&#1569;";
                note = "&#1605;&#1604;&#1575;&#1581;&#1592;&#1575;&#1578;";
                warrantyInfo = "&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1575;&#1604;&#1590;&#1605;&#1575;&#1606;";
                submit = "&#1578;&#1581;&#1583;&#1610;&#1579;";
                update = "&#1578;&#1581;&#1585;&#1610;&#1585;";
                delete = "&#1581;&#1584;&#1601;";
                operation = "&#1593;&#1605;&#1604;&#1610;&#1575;&#1578; &#1575;&#1587;&#1575;&#1587;&#1610;&#1607;";
            }
%>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

    function cancelForm()
    {
        document.PROJECT_VIEW_FORM.action = "<%=context%>/AssignedIssueServlet?op=viewdetails&issueId=<%=(String) request.getAttribute("issueId")%>&filterValue=<%=(String) request.getAttribute("filterValue")%>&filterName=<%=(String) request.getAttribute("filterName")%>";
        document.PROJECT_VIEW_FORM.submit();
    }
    function submitForm(){
        var parts = document.getElementsByName("partId");
        if(parts.length<=0){
            alert("Please Add at least one Warranty Information");
            return false;
        }
        document.warrantyForm.action = "WarrantyItemsServlet?op=saveForm&issueId=<%=request.getParameter("issueId")%>&issueTitle=<%=request.getParameter("issueTitle")%>&issueState=<%=request.getParameter("issueState")%>&filterValue=<%=request.getParameter("filterValue")%>&filterName=<%=request.getParameter("filterName")%>";
        document.warrantyForm.submit();
    }
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
    function OpenDialog(url){
        window.open(url, null,"status = 1, height = 450, width = 500, resizable = 0");
    }
    function light(rowId){
        var row = document.getElementById(rowId);
        var C = row.cells;
        for (x in C)
        {
            if(C[x].style != null){
                C[x].style.backgroundColor = 'red';
            }
        }
    }
    function Navigate(url){
        document.location.href = url + "&issueId=<%=request.getParameter("issueId")%>&issueTitle=<%=request.getParameter("issueTitle")%>&issueState=<%=request.getParameter("issueState")%>&filterValue=<%=request.getParameter("filterValue")%>&filterName=<%=request.getParameter("filterName")%>";
    }
</SCRIPT>
<style type="text/css">
    .grayStyle {
        color: blue;
        font-size: 16px;
        font-weight: bold;
        background-color: #9b9b9b;
    }
</style>
<script src='ChangeLang.js' type='text/javascript'></script>
<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    <HEAD>
        <TITLE>Document Viewer - add new Project</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>
    <BODY>

        <%if (request.getAttribute("Tap") == null) {%>
        <DIV align="left" STYLE="color:blue;">
            <input type="button" class="button" value="     <%=lang%>     " onclick="reloadAE('<%=langCode%>')">
            <button  class="button" onclick="JavaScript: cancelForm();"><%=BackToList%> <IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif"> </button>
            <button  class="button" onclick="JavaScript: submitForm();"><%=submit%></button>
        </DIV>

        <%}%>
        <br>
        <fieldset align="center" class="set" style="border-color: #006699;width: 95%">
            <table class="blueBorder" dir="<%=dir%>" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                <tr>
                    <td style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD"><FONT color='white' SIZE="+1"><%=viewTaskSpar%></FONT><BR></td>
                </tr>
            </table>
            <br>
            <FORM NAME="PROJECT_VIEW_FORM" METHOD="POST">
                <TABLE class="blueBorder" ALIGN="<%=align%>" DIR="<%=dir%>" cellpadding="0" cellspacing="0" WIDTH=90%>
                    <TR>
                        <TD CLASS="blueBorder blueHeaderTD grayStyle" WIDTH="18%"> <b><%=code%></b></TD>
                        <TD CLASS="blueBorder blueHeaderTD grayStyle" WIDTH="20%"><b><%=name%> </b></TD>
                        <TD CLASS="blueBorder blueHeaderTD grayStyle" WIDTH="10%"><b><%=count%> </b></TD>
                        <TD CLASS="blueBorder blueHeaderTD grayStyle" WIDTH="10%"><b><%=price%> </b></TD>
                        <TD CLASS="blueBorder blueHeaderTD grayStyle" WIDTH="10%"><b><%=cost%> </b></TD>
                        <TD CLASS="blueBorder blueHeaderTD grayStyle" WIDTH="12%"><b><%=warranty%> </b></TD>
                    </TR>
                    <%
                                for (int i = 0; i < quantifiedItems.size(); i++) {
                                    WebBusinessObject tempWbo = (WebBusinessObject) quantifiedItems.get(i);
                                    if ((i % 2) == 1) {
                                        bgColor = "#c8d8f8";
                                    } else {
                                        bgColor = "#c8d8f8";
                                    }
                                    if (((String) tempWbo.getAttribute("totalCost")) != null) {
                                        Double iTemp = new Double(((String) tempWbo.getAttribute("totalCost")));
                                        iQuantifiedTotal = iQuantifiedTotal + iTemp.doubleValue();
                                    }
                                    if (tempWbo.getAttribute("isDirectPrch").toString().equals("1")) {
                                        bgColor = "#FFCC00";
                                    }
                    %>
                    <TR>
                        <TD CLASS="blueBorder blueBodyTD" STYLE="text-align:center;">
                            <%=(String) tempWbo.getAttribute("itemCode")%>
                        </TD>
                        <TD CLASS="blueBorder blueBodyTD" STYLE="text-align:center;">
                            <%=(String) tempWbo.getAttribute("itemDscrptn")%>
                        </TD>
                        <TD CLASS="blueBorder blueBodyTD" STYLE="text-align:center;">
                            <%=(String) tempWbo.getAttribute("itemQuantity")%>
                        </TD>
                        <TD CLASS="blueBorder blueBodyTD" STYLE="text-align:center;">
                            <%=Tools.getCurrency(tempWbo.getAttribute("itemPrice").toString())%>
                        </TD>
                        <TD CLASS="blueBorder blueBodyTD" STYLE="text-align:center;">
                            <%=Tools.getCurrency(tempWbo.getAttribute("totalCost").toString())%>
                        </TD>
                        <TD CLASS="blueBorder blueBodyTD" STYLE="text-align:center;">
                            <% if (!allWarrantyInfo.containsKey((String) tempWbo.getAttribute("id"))) {%>
                            <a id="<%=tempWbo.getAttribute("id")%>" onclick="OpenDialog('<%=context%>/WarrantyItemsServlet?op=GetForm&partId=<%=tempWbo.getAttribute("id")%>&itemCode=<%=tempWbo.getAttribute("itemCode")%>')" href="#"><font color="blue"><%=addWarranty%></font></a>
                            <%} else {%>
                            <img id="<%=tempWbo.getAttribute("id")%>" onclick="light('<%=tempWbo.getAttribute("itemCode")%>')" src="images/tick_16.png" style="cursor: pointer">
                            <%}%>
                        </TD>
                    </TR>
                    <%
                                }
                    %>
                </TABLE>
                <br>
                <br>
            </FORM>
            <fieldset id="warrantyInfo" align="center" class="set" style="border-color: #006699;width: 90%;display: <%=display%>">
                <table class="blueBorder" dir="<%=dir%>" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <tr>
                        <td style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD"><FONT color='white' SIZE="+1"><%=warrantyInfo%></FONT><BR></td>
                    </tr>
                </table>
                <br>
                <form action=""  name="warrantyForm" id="warrantyForm" method="post">
                    <TABLE id="table" class="blueBorder" ALIGN="<%=align%>" DIR="<%=dir%>" cellpadding="0" cellspacing="0" WIDTH=90%>
                        <TR>
                            <TD CLASS="blueBorder blueHeaderTD grayStyle" WIDTH="20%"> <b><%=code%></b></TD>
                            <TD CLASS="blueBorder blueHeaderTD grayStyle" WIDTH="20%"> <b><%=vendor%></b></TD>
                            <TD CLASS="blueBorder blueHeaderTD grayStyle" WIDTH="10%"><b><%=bDate%> </b></TD>
                            <TD CLASS="blueBorder blueHeaderTD grayStyle" WIDTH="10%"><b><%=eDate%> </b></TD>
                            <TD CLASS="blueBorder blueHeaderTD grayStyle" WIDTH="30%"><b><%=note%> </b></TD>
                            <TD colspan="2" CLASS="blueBorder blueHeaderTD grayStyle" width="10%"><%=operation%></TD>
                        </TR>
                        <%
                                    WebBusinessObject temp = new WebBusinessObject();
                                    Enumeration keysTemp = allWarrantyInfo.keys();
                                    while (keysTemp.hasMoreElements()) {
                                        temp = (WebBusinessObject) allWarrantyInfo.get(keysTemp.nextElement().toString());
                        %>
                        <TR id="<%=temp.getAttribute("itemCode")%>">
                            <td class="blueBorder blueBodyTD">
                                <input type="hidden" id="partId" name="partId" value="<%=temp.getAttribute("quantifiedId")%>">
                                <input readonly style="width: 99%;text-align: center" id="partCode" name="partCode" value="<%=temp.getAttribute("itemCode")%>">
                            </td>
                            <td class="blueBorder blueBodyTD"><input readonly style="width: 99%;text-align: center" id="vendor" name="vendor" value="<%=temp.getAttribute("vendor")%>"></td>
                            <td class="blueBorder blueBodyTD"><input readonly style="width: 99%;text-align: center" id="bDate" name="bDate" value="<%=temp.getAttribute("bDate")%>"></td>
                            <td class="blueBorder blueBodyTD"><input readonly style="width: 99%;text-align: center" id="eDate" name="eDate" value="<%=temp.getAttribute("eDate")%>"></td>
                            <td class="blueBorder blueBodyTD"><input readonly style="width: 99%;text-align: center" id="note" name="note" value="<%=temp.getAttribute("note")%>"></td>
                            <td class="blueBorder blueBodyTD"><input type="button" onclick="OpenDialog('<%=context%>/WarrantyItemsServlet?op=updateForm&id=<%=temp.getAttribute("id")%>&itemCode=<%=temp.getAttribute("itemCode")%>')" value="<%=update%>"></td>
                            <td class="blueBorder blueBodyTD"><input type="button" onclick="Navigate('<%=context%>/WarrantyItemsServlet?op=delete&id=<%=temp.getAttribute("id")%>')" value="<%=delete%>"></td>
                        </TR>
                        <%}%>
                    </TABLE>
                </form>
                <br>
            </fieldset>
            <br>
            <br>
        </fieldset>
    </BODY>
</HTML>
