<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.tracker.engine.*,com.silkworm.common.*, com.tracker.common.*, java.util.*,com.tracker.business_objects.*,com.Erp.db_access.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,java.util.*,java.text.SimpleDateFormat"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page contentType="text/html; charset=utf-8" %>
<html>
    <%
                MetaDataMgr metaMgr = MetaDataMgr.getInstance();
                ProjectMgr projectMgr = ProjectMgr.getInstance();
                FailureCodeMgr failureCodeMgr = FailureCodeMgr.getInstance();
                ItemUnitMgr itemUnitMgr = ItemUnitMgr.getInstance();
                String context = metaMgr.getContext();
                IssueMgr issueMgr = IssueMgr.getInstance();
                UserMgr userMgr = UserMgr.getInstance();
                CrewMissionMgr crewMgr = CrewMissionMgr.getInstance();
                String issueId = (String) request.getAttribute(IssueConstants.ISSUEID);
                String issueTitle = (String) request.getAttribute(IssueConstants.ISSUETITLE);
                ArrayList tradeList = new ArrayList();
                String status = (String) request.getAttribute("status");

                Vector tradeVec = (Vector) request.getAttribute("vecUserTrades");
                if (tradeVec.size() > 0) {
                    for (int i = 0; i < tradeVec.size(); i++) {
                        WebBusinessObject wbo = (WebBusinessObject) tradeVec.elementAt(i);
                        tradeList.add(wbo);
                    }
                }

                WebBusinessObject crewWbo = null;

                AppConstants appCons = new AppConstants();

                String filterName = (String) request.getAttribute("filter");
                String filterValue = (String) request.getAttribute("filterValue");

                String[] itemAtt = {"itemId", "itemQuantity"};//appCons.getItemScheduleAttributes();
                String[] itemTitle = {"&#1605;", "&#1585;&#1602;&#1605; &#1575;&#1604;&#1589;&#1606;&#1601;", "&#1575;&#1587;&#1600;&#1600;&#1600;&#1605; &#1575;&#1604;&#1589;&#1606;&#1601;", "&#1575;&#1604;&#1603;&#1605;&#1610;&#1577; &#1575;&#1604;&#1605;&#1591;&#1604;&#1608;&#1576;&#1577;"};//appCons.getItemScheduleHeaders();

                String attName1 = "";
                String attValue1 = "";
                String costCenterName = "";
                ArrayList arrAllAmount = new ArrayList();
                arrAllAmount.add("&#1606;&#1593;&#1605;");
                arrAllAmount.add("&#1604;&#1575;");

                WebBusinessObject unitWbo = null;
                TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

                Vector itemList = (Vector) request.getAttribute("data");
                int s = itemAtt.length;
                int t = s + 2;
                int iTotal = 0;

                String attName = null;
                String attValue = null;
                int flipper = 0;

                WebBusinessObject wbo = issueMgr.getOnSingleKey(issueId);
                if (wbo.getAttribute("techName") != null) {
                    crewWbo = crewMgr.getOnSingleKey(wbo.getAttribute("techName").toString());
                }
                WebBusinessObject wboTemp = UnitScheduleMgr.getInstance().getOnSingleKey(wbo.getAttribute("unitScheduleID").toString());

                String stat = (String) request.getSession().getAttribute("currentMode");
                String align = null;
                String dir = null;
                String style = null;
                String reportCode = "Report Code: STR-DSPNSE-RQST-S100";
                String lang, langCode, underConstruction, sBackToList, unitItemCode, timeStatus, sRequestItems, sDate, sJobOrderNo, sTrade, sSave, sOk, sNo;
                String repeatOrder, resultTotalItem, costNameField, cost_c, sRequestForStore, sOrderForStore, sNoOrderForStore, itemFormTitle, branchTitle, storeTitle, print;

                String itemNameMsg;
                if (stat.equals("En")) {
                    dir = "LTR";
                    cost_c = "Cost Center";
                    style = "text-align:left";
                    lang = "   &#1593;&#1585;&#1576;&#1610;    ";
                    langCode = "Ar";
                    align = "left";

                    sBackToList = "Cancel";
                    sRequestItems = "Request from the Store";
                    itemTitle[0] = "#";
                    itemTitle[1] = "Item NO.";
                    itemTitle[2] = "Item Name";
                    //itemTitle[3] = "Item Unit";
                    itemTitle[3] = "Quantity";
                    //itemTitle[5] = "Note";
                    //itemTitle[4] = "All";
                    costNameField = "LATIN_NAME";
                    sDate = "Order Date";
                    sJobOrderNo = "Job Order NO.";
                    sTrade = "Trade";
                    sSave = "Order";
                    sOk = "Order has been sent";
                    sNo = "Order has not been sent";
                    underConstruction = "This function Under Construction";
                    repeatOrder = "Add Item in order";
                    resultTotalItem = "The subtract from store";
                    sRequestForStore = "old order for store";
                    sOrderForStore = "Order for Store";
                    sNoOrderForStore = " No spare parts required for the job order ";
                    itemFormTitle = "Item group";
                    branchTitle = "Branch of store";
                    storeTitle = "Store";
                    print = "Print";

                    itemNameMsg = "Item Not Found in stores";
                } else {

                    align = "right";
                    dir = "RTL";
                    cost_c = "مركز التكلفة";
                    style = "text-align:Right";
                    lang = "English";
                    langCode = "En";
                    costNameField = "COSTNAME";
                    sBackToList = "&#1573;&#1606;&#1607;&#1575;&#1569;";
                    sRequestItems = "&#1591;&#1604;&#1576; &#1589;&#1585;&#1601; &#1605;&#1582;&#1575;&#1586;&#1606;";
                    sDate = "&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1591;&#1604;&#1576;";
                    sJobOrderNo = "&#1585;&#1602;&#1605; &#1575;&#1604;&#1573;&#1584;&#1606;";
                    sTrade = "&#1575;&#1604;&#1573;&#1583;&#1575;&#1585;&#1577;";
                    sSave = "&#1571;&#1591;&#1604;&#1576;";
                    sOk = "&#1578;&#1605; &#1573;&#1585;&#1587;&#1575;&#1604; &#1575;&#1604;&#1571;&#1605;&#1585;";
                    sNo = "&#1604;&#1605; &#1610;&#1578;&#1605; &#1573;&#1585;&#1587;&#1575;&#1604; &#1575;&#1604;&#1571;&#1605;&#1585;";
                    underConstruction = "&#1607;&#1584;&#1607; &#1575;&#1604;&#1582;&#1575;&#1589;&#1610;&#1607; &#1578;&#1581;&#1578; &#1575;&#1604;&#1575;&#1606;&#1588;&#1575;&#1569;";
                    repeatOrder = "&#1573;&#1590;&#1575;&#1601;&#1577; &#1575;&#1604;&#1589;&#1606;&#1601; &#1576;&#1575;&#1604;&#1591;&#1604;&#1576;";
                    resultTotalItem = "&#1575;&#1604;&#1605;&#1606;&#1589;&#1585;&#1601; &#1605;&#1606; &#1575;&#1604;&#1605;&#1582;&#1586;&#1606;";
                    sRequestForStore = "&#1605;&#1575; &#1578;&#1605; &#1591;&#1604;&#1576;&#1607; &#1605;&#1606; &#1575;&#1604;&#1605;&#1582;&#1575;&#1586;&#1606;";
                    sOrderForStore = " &#1591;&#1604;&#1576; &#1575;&#1604;&#1605;&#1582;&#1586;&#1606; ";
                    sNoOrderForStore = "&#1604;&#1575; &#1610;&#1608;&#1580;&#1583; &#1602;&#1591;&#1593; &#1594;&#1610;&#1575;&#1585; &#1605;&#1591;&#1604;&#1608;&#1576;&#1577; &#1604;&#1571;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
                    itemFormTitle = "&#1605;&#1580;&#1605;&#1608;&#1593;&#1577; &#1575;&#1604;&#1589;&#1606;&#1601;";
                    branchTitle = "&#1601;&#1585;&#1593; &#1575;&#1604;&#1605;&#1582;&#1586;&#1606;";
                    storeTitle = "&#1575;&#1604;&#1605;&#1582;&#1586;&#1606;";
                    print = "&#1573;&#1591;&#1576;&#1593;";

                    itemNameMsg = "قطعة الغيار غير موجودة بالمخازن";
                }
                WebBusinessObject siteWbo = projectMgr.getOnSingleKey(wbo.getAttribute("projectName").toString());
                WebBusinessObject failuerWbo = failureCodeMgr.getOnSingleKey(wbo.getAttribute("failureCode").toString());

                Long iIDno = new Long(wbo.getAttribute("id").toString());
                Calendar calendar = Calendar.getInstance();
                calendar.setTimeInMillis(iIDno.longValue());
                String jobnumber = wbo.getAttribute("id").toString().substring(9) + "/" + (calendar.getTime().getMonth() + 1) + "/" + (calendar.getTime().getYear() + 1900);

                if (!wbo.getAttribute("currentStatus").toString().equals("Assigned")) {
                    if (stat.equals("En")) {
                        timeStatus = "Not started yet";
                    } else {
                        timeStatus = "&#1604;&#1605; &#1610;&#1576;&#1583;&#1571; &#1575;&#1604;&#1593;&#1605;&#1604; &#1576;&#1593;&#1583;";
                    }
                } else {
                    timeStatus = issueMgr.getCreateTimeAssigned(issueId);
                }
                String isMust = "&#1606;&#1593;&#1605;";


                Vector issueItemVec = (Vector) request.getAttribute("issueItemVec");
                Vector resultItem = (Vector) request.getAttribute("resultItem");
                String itemId = null;
                String totalCount = "0";
                int total = 0;

                ItemsMgr itemsMgr = ItemsMgr.getInstance();
                String itemForm = null;
                ItemFormMgr itemFormMgr = ItemFormMgr.getInstance();
                StoresErpMgr storesErpMgr = StoresErpMgr.getInstance();
                BranchErpMgr branchErpMgr = BranchErpMgr.getInstance();
                TransactionDetailsMgr transactionDetailsMgr = TransactionDetailsMgr.getInstance();
                WebBusinessObject transDetailWbo = new WebBusinessObject();
    %>


    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <head>
        <script type="text/javascript" src="js/wz_tooltip.js"></script>
    </head>

    <script src='ChangeLang.js' type='text/javascript'></script>
    <script LANGUAGE="JavaScript" TYPE="text/javascript">
        function cancelForm()
        {    
            document.JobOrder_FORM.action ="<%=context%>/AssignedIssueServlet?op=VIEWDETAILS&issueId=<%=issueId%>&filterName=<%=filterName%>&filterValue=<%=filterValue%>";
            document.JobOrder_FORM.submit();  
        }

        function exportReport(url) {
            window.open(url,"_blank","toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=no, resizable=yes, copyhistory=no, width=800, height=500");

        }
        
        function submitForm()
        { 
            document.JobOrder_FORM.action = "<%=context%>/TransactionServlet?op=SendOrder&filterName=<%=filterName%>&filterValue=<%=filterValue%>&issueId=<%=issueId%>&issueTitle=<%=issueTitle%>&issueStatus=<%=request.getParameter("issueStatus")%>";
            document.JobOrder_FORM.submit();
        }
        function openWindow(url) {
            
            openCustomDialog(url, "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width=750, height=400");
        }
        function getFormDetails() {
            openWindow('ReportsServlet?op=getFormDetails&formCode=STR-INTEG-5');
        }
    </script>

    <body>
        <form NAME="JobOrder_FORM" METHOD="POST">
            
            <DIV align="left" STYLE="color:blue;">
                <input type="button" value="     <%=lang%>     " onclick="reloadAE('<%=langCode%>')" class="button">
                <button  onclick="JavaScript: cancelForm();" class="button"><%=sBackToList%> <IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif"> </button>

                <% if (itemList != null && itemList.size() > 0) {%>
                <button    onclick="submitForm()" class="button"><%=sSave%>    <IMG SRC="images/save.gif"></button>
                    <%}%>

                <input type="button" name="formDetails" class="button" onclick="getFormDetails()" value="Form Details" />
                <% if (itemList == null || itemList.size() == 0) {%>
                <input type="button" name="print" class="button"
                       onmousedown="JavaScript: exportReport('<%=context%>/PDFReportServlet?op=resultRequestedItemsFromStore&issueId=<%=issueId%>');"
                       value="<%=print%>" />

                <%}%>
            </DIV>

            <!--table width="100%" align="center">
                <tr>
                    <td class="td" style="test-align:center">
                        <center> <br>  <font size="3" color="red" ><b><%//=underConstruction%></b></font></center>
                    </td>
                </tr>
            </table-->

            <fieldset align=center class="set">
                <legend align="center">

                    <table align="center">
                        <tr>
                            <td class="td">
                                <font color="blue" size="6">
                                    <%=sRequestItems%>
                                </font>
                            </td>
                        </tr>
                    </table>
                </legend >

                <% if (itemList == null || itemList.size() == 0) {%>
                <div style="text-align: left;">
                    <table>
                        <tr>
                            <td style="text-align: left;border: none;">
                                <font color="#FF385C" size="3" style="font-weight: bold;">
                                    <a id="mainLink"><%=reportCode%> <img onmouseover="Tip('<%=sRequestItems%>',CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#ffff99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'bold', SHADOW, true, SHADOWWIDTH, 7,TEXTALIGN ,'CENTER', TITLE ,'<%=sRequestItems%>',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'White', TITLEBGCOLOR ,'#FF9900')"  onmouseout="UnTip()" width="30" height="25"  src="images/qm01.jpg" /></a>
                                </font>
                            </td>
                        </tr>
                    </table>
                </div>
                <%}%>

                <%
                            if (status != null) {
                                if (status.equalsIgnoreCase("Ok")) {
                %>
                <center style="font-size:16px;color:red;">
                    <%=sOk%>
                </center>
                <%
                                                } else {
                %>
                <center style="font-size:20px;color:red;">
                    <%=sNo%>
                </center>
                <%
                                }
                            }
                %>

                <%
                            if (issueItemVec != null && issueItemVec.size() > 0) {

                %>
                <center style="font-size:20px;color:red;">
                    <%=sRequestForStore%>
                </center>
                <table border="0" width="90%" id="table1" align="center" dir="<%=dir%>">





                    <tr>
                        <td width="98%" colspan="4">
                            <p align="center">
                            <TABLE WIDTH="100%" CELLPADDING="0" CELLSPACING="0" BORDER="1" ALIGN="center">
                                <TR align="<%=align%>" bgcolor="#A0C0C0">
                                    <%
                                                                    for (int i = 0; i < t; i++) {
                                    %>
                                    <TD class="cell" style="text-align:center">
                                        <b>
                                            <%=itemTitle[i]%>
                                        </b>
                                    </TD>
                                    <%
                                                                    }
                                    %>
                                    <TD NOWRAP class="cell" style="text-align:center">
                                        <b>
                                            <%=cost_c%>
                                        </b>
                                    </TD>
                                    <TD NOWRAP class="cell" style="text-align:center">
                                        <b>
                                            <%=itemFormTitle%>
                                        </b>
                                    </TD>
                                    <TD NOWRAP class="cell" style="text-align:center">
                                        <b>
                                            <%=branchTitle%>
                                        </b>
                                    </TD>
                                    <TD NOWRAP class="cell" style="text-align:center">
                                        <b>
                                            <%=storeTitle%>
                                        </b>
                                    </TD>
                                    <TD NOWRAP class="cell" style="text-align:center" BGCOLOR="99CCFF">
                                        <b>
                                            <%=resultTotalItem%>
                                        </b>
                                    </TD>
                                </TR>

                                <%

                                                                Enumeration e = issueItemVec.elements();
                                                                status = null;
                                                                int countResult = 0;
                                                                while (e.hasMoreElements()) {
                                                                    transDetailWbo = new WebBusinessObject();
                                                                    countResult++;
                                                                    wbo = (WebBusinessObject) e.nextElement();
                                                                    itemId = wbo.getAttribute("itemID").toString();

                                                                    String[] itemCode = itemId.split("-");
                                                                    WebBusinessObject wboItem = new WebBusinessObject();
                                                                    transDetailWbo = (WebBusinessObject) transactionDetailsMgr.getOnSingleKey(wbo.getAttribute("detailId").toString());

                                                                    ///////////////////////////////////////////


                                                                    attName1 = "attachedOn";
                                                                    attValue1 = (String) transDetailWbo.getAttribute("cost_center_id");

                                                                    if (!attValue1.equals("2")) {
                                                                        CostCentersMgr costCenterMgr = CostCentersMgr.getInstance();
                                                                        Vector costCentersVec = costCenterMgr.getOnArbitraryKey(attValue1, "key");
                                                                        WebBusinessObject costCenterWbo = (WebBusinessObject) costCentersVec.elementAt(0);
                                                                        costCenterName = costCenterWbo.getAttribute(costNameField).toString();
                                                                    } else {
                                                                        costCenterName = "Not Found";
                                                                    }

                                %>

                                <TR bgcolor="#CCFFFF">
                                    <td nowrap class="cell" style="text-align:center" align="<%=align%>" width="40">
                                        <b>  <%=countResult%> </b>
                                    </td>
                                    <%
                                                                                                        //MaintenanceItemMgr maintenanceItemMgr = MaintenanceItemMgr.getInstance();
                                                                                                        if (itemCode.length > 1) {
                                                                                                            wboItem = itemsMgr.getOnSingleKey(itemId);
                                                                                                        } else {
                                                                                                            wboItem = itemsMgr.getOnObjectByKey(itemId);
                                                                                                        }
                                                                                                        String item_code = "";
                                                                                                        try {
                                                                                                            if (itemCode.length > 1) {
                                                                                                                item_code = wboItem.getAttribute("itemCodeByItemForm").toString();
                                                                                                            } else {
                                                                                                                item_code = wboItem.getAttribute("itemCode").toString();
                                                                                                            }
                                                                                                        } catch (NullPointerException pe) {
                                                                                                            item_code = "---";
                                                                                                        }
                                    %>
                                    <TD NOWRAP class="cell" style="text-align:center" align="<%=align%>">

                                        <b><%=item_code%></b>

                                    </TD>

                                    <TD STYLE="border:0px">
                                        <%
                                                                                                            String itemDesc = "";
                                                                                                            try {
                                                                                                                itemDesc = wboItem.getAttribute("itemDscrptn").toString();
                                                                                                            } catch (NullPointerException npe) {
                                                                                                                itemDesc = "<font size = '3' style='background-color: red;' color = 'white'><img src = 'images/worning_yallow.jpg' />&nbsp;&nbsp;" + itemNameMsg + "</font>";
                                                                                                            }

                                        %>
                                        <b><%=itemDesc%></b>
                                    </TD>
                                    <TD NOWRAP class="cell" style="text-align:center" align="<%=align%>">
                                        <b><%=wbo.getAttribute("total")%></b>
                                    </TD>


                                    <TD class="cell" style="text-align:center" align="<%=align%>">
                                        <input type="hidden" name="costCode"  value="<%=attValue1%>" />
                                        <%=costCenterName%>
                                    </TD>

                                    <td  NOWRAP class="cell" style="text-align:center" align="<%=align%>">
                                        <%   String itemFormByItem = null;
                                                                                                            WebBusinessObject itemFormByItemWbo = new WebBusinessObject();
                                                                                                            itemFormByItemWbo = itemFormMgr.getOnSingleKey(transDetailWbo.getAttribute("itemForm").toString());%>

                                        <table><tr><td class="td" style="text-align:center;"><%=transDetailWbo.getAttribute("itemForm").toString()%></td></tr>
                                            <tr><td class="td" style="text-align:center;"><%=itemFormByItemWbo.getAttribute("formDesc")%></td></tr></table>

                                    </td>
                                    <td  NOWRAP class="cell" style="text-align:center" align="<%=align%>">
                                        <%  String branchNameByItem = null;
                                                                                                            WebBusinessObject branchByItemWbo = new WebBusinessObject();
                                                                                                            branchByItemWbo = branchErpMgr.getOnSingleKey(transDetailWbo.getAttribute("branch").toString());
                                                                                                            String bName = "";

                                                                                                            try {

                                                                                                                bName =
                                                                                                                        branchByItemWbo.getAttribute("Description").toString();

                                                                                                                if (bName == null) {

                                                                                                                    bName = "Not Found in view BRANCH_ERP";
                                                                                                                }

                                                                                                            } catch (Exception ex) {

                                                                                                                bName = "Not Found in view BRANCH_ERP";

                                                                                                            }
                                        %>
                                        <table><tr><td class="td" style="text-align:center;"><%=transDetailWbo.getAttribute("branch")%></td></tr>
                                            <tr><td class="td" style="text-align:center;"><%=bName%></td></tr></table>

                                    </td>
                                    <td NOWRAP class="cell" style="text-align:center" align="<%=align%>">
                                        <%  String storeNameByItem = null;
                                                                                                            WebBusinessObject storeByItemWbo = new WebBusinessObject();
                                                                                                            storeByItemWbo = storesErpMgr.getOnSingleKey(transDetailWbo.getAttribute("store").toString());
                                                                                                            String sName = "";

                                                                                                            try {

                                                                                                                sName = storeByItemWbo.getAttribute("nameAr").toString();

                                                                                                                if (sName == null) {

                                                                                                                    sName = "Not Found in view STORE_ERP";

                                                                                                                }

                                                                                                            } catch (Exception ex) {

                                                                                                                sName = "Not Found in view STORE_ERP";

                                                                                                            }
                                        %>

                                        <table><tr><td class="td" style="text-align:center;"><%=transDetailWbo.getAttribute("store")%></td></tr>
                                            <tr><td class="td" style="text-align:center;"><%=sName%></td></tr></table>

                                    </td>
                                    <% if (resultItem != null && resultItem.size() > 0) {
                                                                                                            total = 0;
                                                                                                            for (int x = 0; x < resultItem.size(); x++) {
                                                                                                                WebBusinessObject resultItemWbo = (WebBusinessObject) resultItem.get(x);
                                                                                                                if (resultItemWbo.getAttribute("itemID").equals(itemId)) {
                                                                                                                    totalCount = resultItemWbo.getAttribute("total").toString();
                                                                                                                    total++;
                                                                                                                }

                                                                                                            }
                                                                                                            if (total > 0) {%>
                                    <TD NOWRAP class="cell" style="text-align:center" align="<%=align%>" BGCOLOR="D5EAFF">
                                        <b><%=totalCount%></b>
                                    </TD>
                                    <% } else {

                                    %>
                                    <TD NOWRAP class="cell" style="text-align:center" align="<%=align%>" BGCOLOR="D5EAFF">
                                        <b><%=total%></b>
                                    </TD>
                                    <% }%>
                                    <% } else {

                                    %>
                                    <TD NOWRAP class="cell" style="text-align:center" align="<%=align%>" BGCOLOR="D5EAFF">
                                        <b><%=total%></b>
                                    </TD>
                                    <% }
                                    %>

                                </TR>
                                <%
                                                                }
                                %>
                            </TABLE>
                        </td>
                    </tr>
                </table>
                <br><br><br>
                <% }%>

                <% if (itemList != null && itemList.size() > 0) {%>

                <center style="font-size:20px;color:red;">
                    <%=sOrderForStore%>
                </center>

                <table border="0" width="90%" id="table1" align="center" dir="<%=dir%>">

                    <!--tr>
                        <td class="cell" width="25%" bgcolor="#CCCCCC">
                        <p align="center"><b><%=sDate%></b></td>
                        <td class="cell" width="25%" style="text-align:center" bgcolor="#E9E9E9">
                            <b>
                                <font color="#000080">
                    <%=timeStatus%>
                </font>
            </b>
        </td>
        <td></td><td></td>
    </tr-->
                    <!--tr>
                        <td class="cell" width="25%" bgcolor="#CCCCCC">
                            <p align="center">
                                <b>
                    <%=sJobOrderNo%>
                </b>
            </p>
        </td>
        <td class="cell" width="25%" style="text-align:center" bgcolor="#E9E9E9">
            <b>
                <font color="#000080">
                    <%=jobnumber%>
                </font>
            </b>
        </td>
        <td></td><td></td>
    </tr>
    <tr>
        <td class="cell" width="25%" bgcolor="#CCCCCC">
            <p align="center">
                <b>
                    <%=sTrade%>
                </b>
            </p>
        </td>
        <td class="cell" width="25%" style="text-align:center" bgcolor="#E9E9E9">
            <b>
                <font color="#000080">
                    <SELECT NAME="trade" ID="trade" STYLE="width:230px; z-index:-1;<%=style%>;">
                        <//sw:WBOOptionList wboList='<%=tradeList%>' displayAttribute = "tradeName" valueAttribute="tradeId"/>
                    </SELECT>
                </font>
            </b>
        </td>
        <td></td><td></td>
    </tr-->
                    <% WebBusinessObject tradeWbo = (WebBusinessObject) tradeVec.get(0);
                    %>

                    <input type="hidden" name="trade" id="trade" value="<%=tradeWbo.getAttribute("tradeId")%>">
                    <tr>
                        <td width="98%" colspan="4">
                            <p align="center">
                            <table WIDTH="100%" CELLPADDING="0" CELLSPACING="0" BORDER="1" ALIGN="center">
                                <TR align="<%=align%>" bgcolor="#A0C0C0">
                                    <%
                                         for (int i = 0; i < t; i++) {
                                    %>
                                    <TD NOWRAP class="cell" style="text-align:center">
                                        <b>
                                            <%=itemTitle[i]%>
                                        </b>
                                    </TD>
                                    <%
                                         }
                                    %>
                                    <TD NOWRAP class="cell" style="text-align:center">
                                        <b>
                                            <%=cost_c%>
                                        </b>
                                    </TD>
                                    <TD NOWRAP class="cell" style="text-align:center">
                                        <b>
                                            <%=itemFormTitle%>
                                        </b>
                                    </TD>
                                    <TD NOWRAP class="cell" style="text-align:center">
                                        <b>
                                            <%=branchTitle%>
                                        </b>
                                    </TD>
                                    <TD NOWRAP class="cell" style="text-align:center">
                                        <b>
                                            <%=storeTitle%>
                                        </b>
                                    </TD>


                                    <TD NOWRAP class="cell" style="text-align:center">
                                        <b>
                                            <%=repeatOrder%>
                                        </b>
                                    </TD>

                                </TR>
                                <%
                                     Enumeration e = itemList.elements();
                                     status = null;

                                     while (e.hasMoreElements()) {
                                         iTotal++;



                                         wbo = (WebBusinessObject) e.nextElement();
                                         attName = itemAtt[0];
                                         attValue = (String) wbo.getAttribute(attName);
                                         String[] splitItemCode = wbo.getAttribute("itemId").toString().split("-");
                                         itemForm = splitItemCode[0];

                                         ////////////////////////////////////////////////////////////////////////////////////
                                         attName1 = "";
                                         attValue1 = "";
                                         costCenterName = "";
                                         attName1 = "attachedOn";
                                         attValue1 = (String) wbo.getAttribute(attName1);

                                         if (!attValue1.equals("2")) {
                                             CostCentersMgr costCenterMgr = CostCentersMgr.getInstance();
                                             Vector costCentersVec = costCenterMgr.getOnArbitraryKey(attValue1, "key");
                                             WebBusinessObject costCenterWbo = (WebBusinessObject) costCentersVec.elementAt(0);
                                             costCenterName = costCenterWbo.getAttribute(costNameField).toString();
                                         } else {
                                             costCenterName = "Not Found";
                                         }
                                %>

                                <tr bgcolor="#CCFFFF">
                                    <td nowrap class="cell" style="text-align:center" align="<%=align%>" width="40">
                                        <b>  <%=iTotal%> </b>
                                    </td>
                                    <%
                                                                             String sItemID = new String("");
                                                                             for (int i = 0; i < 2; i++) {
                                                                                 attName = itemAtt[i];
                                                                                 attValue = (String) wbo.getAttribute(attName);
                                                                                 // MaintenanceItemMgr maintenanceItemMgr = MaintenanceItemMgr.getInstance();
                                                                                 String[] itemCode = attValue.split("-");

                                                                                 WebBusinessObject wboItem = new WebBusinessObject();
                                                                                 if (i == 0) {
                                                                                     sItemID = (String) wbo.getAttribute(attName);
                                                                                     if (itemCode.length > 1) {
                                                                                         wboItem = itemsMgr.getOnSingleKey(attValue);
                                                                                     } else {
                                                                                         wboItem = itemsMgr.getOnObjectByKey(attValue);
                                                                                     }
                                                                                     unitItemCode = "1";//(String) wboItem.getAttribute("itemUnit");
                                                                                     unitWbo = itemUnitMgr.getOnSingleKey(unitItemCode);
                                    %>
                                    <TD NOWRAP class="cell" style="text-align:center" align="<%=align%>">
                                        <%
                                                                                                                             if (itemCode.length > 1) {
                                        %>
                                        <b><%=wboItem.getAttribute("itemCodeByItemForm")%></b>
                                        <% } else {%>
                                        <b><%=wboItem.getAttribute("itemCode")%></b>
                                        <% }%>
                                        <input type="hidden" id="itemQuantity<%=sItemID%>" name="itemQuantity<%=sItemID%>" value="<%=wbo.getAttribute("itemQuantity")%>">
                                    </TD>

                                    <TD NOWRAP class="cell" style="text-align:center" align="<%=align%>">
                                        <b><%=wboItem.getAttribute("itemDscrptn")%></b>
                                    </TD>

                                        <!--TD class="cell" style="text-align:center" align="<%=align%>">
                                            <b><%//=unitWbo.getAttribute("unitName")%></b>
                                        </TD-->
                                    <%
                                                                                                                     } else {%>
                                    <TD NOWRAP class="cell" style="text-align:center" align="<%=align%>">
                                        <DIV >
                                            <b><%=attValue%> </b>
                                        </DIV>
                                    </TD>
                                    <%
                                                                                 }
                                                                             }
                                    %>


                                    <TD class="cell" style="text-align:center" align="<%=align%>">
                                        <input type="hidden" name="costCode"  value="<%=attValue1%>" />
                                        <%=costCenterName%>
                                    </TD>


                                    <td  NOWRAP class="cell" style="text-align:center" align="<%=align%>">
                                        <%   String itemFormByItem = null;
                                                                                 WebBusinessObject itemFormByItemWbo = new WebBusinessObject();
                                                                                 itemFormByItemWbo = itemFormMgr.getOnSingleKey(itemForm);%>

                                        <table><tr><td class="td" style="text-align:center;"><%=itemForm%></td></tr> <tr><td class="td" style="text-align:center;"><%=itemFormByItemWbo.getAttribute("formDesc")%></td></tr></table>
                                        <input type="hidden" readonly name="itemFormName" id="itemFormName" value="<%=itemFormByItemWbo.getAttribute("formDesc")%>">
                                        <input type="hidden" readonly name="itemForm" id="itemForm" value="<%=itemForm%>">
                                    </td>
                                    <td  NOWRAP class="cell" style="text-align:center" align="<%=align%>">
                                        <%  String branchNameByItem = null;
                                                                                 WebBusinessObject branchByItemWbo = new WebBusinessObject();
                                                                                 branchByItemWbo = branchErpMgr.getOnSingleKey(wbo.getAttribute("branchCode").toString());
                                                                                 String bName = "";

                                                                                 try {

                                                                                     bName =
                                                                                             branchByItemWbo.getAttribute("Description").toString();

                                                                                     if (bName == null) {

                                                                                         bName = "Not Found in view BRANCH_ERP";
                                                                                     }

                                                                                 } catch (Exception ex) {

                                                                                     bName = "Not Found in view BRANCH_ERP";

                                                                                 }
                                        %>

                                        <table><tr><td class="td" style="text-align:center;"><%=wbo.getAttribute("branchCode")%></td></tr><tr><td class="td" style="text-align:center;"><%=bName%></td></tr></table>
                                        <input type="hidden" name="branchName" id="branchName" value="<%=bName%>">
                                        <input type="hidden" name="branch" id="branch" value="<%=wbo.getAttribute("branchCode")%>">
                                    </td>
                                    <td  NOWRAP class="cell" style="text-align:center" align="<%=align%>">
                                        <%  String storeNameByItem = null;
                                                                                 WebBusinessObject storeByItemWbo = new WebBusinessObject();
                                                                                 storeByItemWbo = storesErpMgr.getOnSingleKey(wbo.getAttribute("storeCode").toString());
                                                                                 String sName = "";

                                                                                 try {

                                                                                     sName = storeByItemWbo.getAttribute("nameAr").toString();

                                                                                     if (sName == null) {

                                                                                         sName = "Not Found in view STORE_ERP";

                                                                                     }

                                                                                 } catch (Exception ex) {

                                                                                     sName = "Not Found in view STORE_ERP";

                                                                                 }
                                        %>

                                        <table><tr><td class="td" style="text-align:center;"><%=wbo.getAttribute("storeCode")%></td></tr><tr><td class="td" style="text-align:center;"><%=sName%></td></tr></table>
                                        <input type="hidden" name="storeName" id="storeName" value="<%=sName%>">
                                        <input type="hidden" name="store" id="store" value="<%=wbo.getAttribute("storeCode")%>">
                                        <input type="hidden" name="isMust<%=sItemID%>" id="trade<%=sItemID%>" value="<%=isMust%>">
                                    </td>
                                    <TD NOWRAP class="cell" style="text-align:center" align="<%=align%>">
                                        <input type="checkbox" id="itemID" name="itemID" value="<%=sItemID%>" checked>
                                    </TD>


                                </tr>
                                <%
                                     }
                                %>
                            </table>
                        </td>
                    </tr>
                </table>
                <% }%>

                <% if (itemList != null && itemList.size() > 0 || issueItemVec != null && issueItemVec.size() > 0) {%>

                &nbsp;
                <% } else {%>
                <center style="font-size:20px;color:red;">
                    <%=sNoOrderForStore%>
                </center>
                <% }%>
                <br><br>
            </fieldset>

        </form>
    </body>
</html>
