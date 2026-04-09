<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.tracker.engine.*,com.silkworm.common.*, com.tracker.common.*, java.util.*,com.tracker.business_objects.*"%>
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
    if(tradeVec.size() > 0){
        for(int i=0; i<tradeVec.size(); i++){
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
    
    ArrayList arrAllAmount = new ArrayList();
    arrAllAmount.add("&#1606;&#1593;&#1605;");
    arrAllAmount.add("&#1604;&#1575;");
    
    WebBusinessObject unitWbo = null;
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
    
    Vector  itemList = (Vector) request.getAttribute("data");
    Vector resultItem = (Vector) request.getAttribute("resultItem");
    
    int s = itemAtt.length;
    int t = s+2;
    int iTotal = 0;
    
    String attName = null;
    String attValue = null;
    int flipper = 0;
    
    WebBusinessObject wbo = issueMgr.getOnSingleKey(issueId);
    if(wbo.getAttribute("techName") != null){
        crewWbo = crewMgr.getOnSingleKey(wbo.getAttribute("techName").toString());
    }
    WebBusinessObject wboTemp = UnitScheduleMgr.getInstance().getOnSingleKey(wbo.getAttribute("unitScheduleID").toString());
    
    String stat= (String) request.getSession().getAttribute("currentMode");
    String align=null;
    String dir=null;
    String style=null;
    String lang,langCode,underConstruction,sBackToList,unitItemCode,timeStatus, sResponsetItems, sDate, sJobOrderNo, sTrade, sSave, sOk, sNo;
    String repeatOrder,resultTotalItem,noRequestForStore,itemNameMsg;
        if(stat.equals("En")){
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        langCode="Ar";
        align="left";
        
        sBackToList = "Cancel";
        sResponsetItems = "subtract spare parts from store";
        itemTitle[0] = "#";
        itemTitle[1] = "Item NO.";
        itemTitle[2] = "Item Name";
        itemTitle[3] = "Quantity";
        sDate = "Order Date";
        sJobOrderNo = "Job Order NO.";
        sTrade = "Trade";
        sSave = "Order";
        sOk = "Order has been sent";
        sNo = "Order has not been sent";
        underConstruction="This function Under Construction";
        repeatOrder = "Add Item in order";
        resultTotalItem = "The subtract from store"; 
        noRequestForStore ="There is no order from the stores";

        itemNameMsg = "Item Not Found in stores";
    }else{
        
        align="right";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        langCode="En";
        sBackToList = "&#1573;&#1606;&#1607;&#1575;&#1569;";
        sResponsetItems = "&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1589;&#1585;&#1601; &#1605;&#1606; &#1575;&#1604;&#1605;&#1582;&#1575;&#1586;&#1606;";
        sDate = "&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1591;&#1604;&#1576;";
        sJobOrderNo = "&#1585;&#1602;&#1605; &#1575;&#1604;&#1573;&#1584;&#1606;";
        sTrade = "&#1575;&#1604;&#1573;&#1583;&#1575;&#1585;&#1577;";
        sSave = "&#1571;&#1591;&#1604;&#1576;";
        sOk = "&#1578;&#1605; &#1573;&#1585;&#1587;&#1575;&#1604; &#1575;&#1604;&#1571;&#1605;&#1585;";
        sNo = "&#1604;&#1605; &#1610;&#1578;&#1605; &#1573;&#1585;&#1587;&#1575;&#1604; &#1575;&#1604;&#1571;&#1605;&#1585;";
        underConstruction="&#1607;&#1584;&#1607; &#1575;&#1604;&#1582;&#1575;&#1589;&#1610;&#1607; &#1578;&#1581;&#1578; &#1575;&#1604;&#1575;&#1606;&#1588;&#1575;&#1569;";
        repeatOrder = "&#1573;&#1590;&#1575;&#1601;&#1577; &#1575;&#1604;&#1589;&#1606;&#1601; &#1576;&#1575;&#1604;&#1591;&#1604;&#1576;";
        resultTotalItem = "&#1575;&#1604;&#1605;&#1606;&#1589;&#1585;&#1601; &#1605;&#1606; &#1575;&#1604;&#1605;&#1582;&#1586;&#1606;";
        noRequestForStore = "&#1604;&#1575; &#1610;&#1608;&#1580;&#1583; &#1591;&#1604;&#1576; &#1589;&#1585;&#1601; &#1605;&#1606; &#1575;&#1604;&#1605;&#1582;&#1575;&#1586;&#1606;";

        itemNameMsg = "قطعة الغيار غير موجودة بالمخازن";
        }
    WebBusinessObject siteWbo = projectMgr.getOnSingleKey(wbo.getAttribute("projectName").toString());
    WebBusinessObject failuerWbo = failureCodeMgr.getOnSingleKey(wbo.getAttribute("failureCode").toString());
    
    Long iIDno = new Long(wbo.getAttribute("id").toString());
    Calendar calendar = Calendar.getInstance();
    calendar.setTimeInMillis(iIDno.longValue());
    String jobnumber = wbo.getAttribute("id").toString().substring(9) + "/" + (calendar.getTime().getMonth() + 1) + "/" + (calendar.getTime().getYear() + 1900);
    
    if (!wbo.getAttribute("currentStatus").toString().equals("Assigned")){
        if(stat.equals("En")){
            timeStatus = "Not started yet";
        } else {
            timeStatus = "&#1604;&#1605; &#1610;&#1576;&#1583;&#1571; &#1575;&#1604;&#1593;&#1605;&#1604; &#1576;&#1593;&#1583;";
        }
    }else{
        timeStatus = issueMgr.getCreateTimeAssigned(issueId);
    }
    String isMust ="&#1606;&#1593;&#1605;";
    String itemId = null;
    String totalCount = "0";
    int total = 0;
    ItemsMgr  itemsMgr = ItemsMgr.getInstance();
    %>
    
    
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    <head>
        <TITLE>DebugTracker-Schedule detail</TITLE>
        
    </head>
    <script src='ChangeLang.js' type='text/javascript'></script>
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
    function cancelForm()
        {    
            document.JobOrder_FORM.action ="<%=context%>/AssignedIssueServlet?op=VIEWDETAILS&issueId=<%=issueId%>&filterName=<%=filterName%>&filterValue=<%=filterValue%>";
            document.JobOrder_FORM.submit();  
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
            openWindow('ReportsServlet?op=getFormDetails&formCode=STR-INTEG-7');
        }
    </SCRIPT>
    
    <body>
        <FORM NAME="JobOrder_FORM" METHOD="POST">
            <DIV align="left" STYLE="color:blue;">
                <input type="button" value="     <%=lang%>     " onclick="reloadAE('<%=langCode%>')" class="button">
                <button  onclick="JavaScript: cancelForm();" class="button"><%=sBackToList%> <IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif"> </button>
                <input type="button" name="formDetails" class="button" onclick="getFormDetails()" value="Form Details" />
            </DIV>
            
           

            <fieldset align=center class="set">
                <legend align="center">
                    
                    <table align="center">
                        <tr>
                            <td class="td">
                                <font color="blue" size="6">
                                    <%=sResponsetItems%>
                                </font>
                            </td>
                        </tr>
                    </table>
                </legend >
                <%
                if(itemList != null && itemList.size()>0){
      
                %>
               
                <table border="0" width="90%" id="table1" align="center" dir="<%=dir%>">
                   
                    
                   
                    
                    
                    <tr>
                        <td width="98%" colspan="4">
                            <p align="center">
                                <TABLE WIDTH="100%" CELLPADDING="0" CELLSPACING="0" BORDER="1" ALIGN="center">
                                    <TR align="<%=align%>" bgcolor="#A0C0C0">
                                        <%
                                        for(int i = 0;i<t;i++) {
                                        %>
                                        <TD class="cell" style="text-align:center">
                                            <b>
                                                <%=itemTitle[i]%>
                                            </b>
                                        </TD>
                                        <%
                                        }
                                        %>
                                       <TD class="cell" style="text-align:center" BGCOLOR="#99CCFF">
                                            <b>
                                                <%=resultTotalItem%>
                                            </b>
                                        </TD>
                                    </TR>
                                    <%
                                    Enumeration e = itemList.elements();
                                    status = null;
                                    
                                    while(e.hasMoreElements()) {
                                        iTotal++;
                                        wbo = (WebBusinessObject) e.nextElement();
                                        itemId = wbo.getAttribute("itemID").toString();

                                        String[] itemCode = itemId.split("-");
                                        WebBusinessObject wboItem = new WebBusinessObject();
                                    %>
                                    
                                    <TR bgcolor="#CCFFFF">
                                        <td class="cell" style="text-align:center" align="<%=align%>" width="40">
                                            <b>  <%=iTotal%> </b>
                                        </td>
                                        <%
                                           // MaintenanceItemMgr maintenanceItemMgr = MaintenanceItemMgr.getInstance();
                                            if(itemCode.length > 1){
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
                                        <TD class="cell" style="text-align:center" align="<%=align%>">
                                            <b><%=item_code%></b>
                                       </TD>
                                        <TD class="cell" style="text-align:center" align="<%=align%>">
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
                                       <TD class="cell" style="text-align:center" align="<%=align%>">
                                            <b><%=wbo.getAttribute("total")%></b>
                                        </TD>
                                        
                                        <% if (resultItem != null && resultItem.size()>0){
                                                 total = 0;
                                                for(int x=0;x<resultItem.size();x++){
                                                WebBusinessObject resultItemWbo = (WebBusinessObject) resultItem.get(x);
                                                if(resultItemWbo.getAttribute("itemID").equals(itemId)){
                                                    totalCount = resultItemWbo.getAttribute("total").toString();
                                                    total++;
                                              
                                                } 
                                                
                                                } %>
                                                <% if (total>0){ %>
                                                <TD class="cell" style="text-align:center" align="<%=align%>" BGCOLOR="#D5EAFF">
                                                    <b><%=totalCount%></b>
                                                </TD>
                                                <% } else { 
                                                    
                                                    %>
                                                    <TD class="cell" style="text-align:center" align="<%=align%>" BGCOLOR="#D5EAFF">
                                                    <b><%=total%></b>
                                                </TD>
                                                <% }%>
                                                <% } else {
                                                                                               
                                                %>
                                                <TD class="cell" style="text-align:center" align="<%=align%>" BGCOLOR="#D5EAFF">
                                                    <b><%=total%></b>
                                                </TD>
                                                <% }
                                                %>
                                         
                                       </TR>
                                    <%
                                    }
                                    %>
                                </TABLE>
                            </p>
                        </td>
                    </tr>
                </table>
                <% } else { %>
                        <center style="font-size:20px;color:red;">
                            <%=noRequestForStore%>
                        </center>
                <% } %>
                <br><br>
            </fieldset>
            
        </form>
    </body>
</html>
