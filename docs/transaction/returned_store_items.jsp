<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.tracker.engine.*,com.silkworm.common.*, com.tracker.common.*, java.util.*,com.tracker.business_objects.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,java.util.*,java.text.SimpleDateFormat"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<html>
    <%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    String issueId = (String) request.getAttribute(IssueConstants.ISSUEID);
    WebBusinessObject wbo;
    String[] itemAtt = {"itemId", "itemQuantity"};
    
    ArrayList arrAllAmount = new ArrayList();
    arrAllAmount.add("&#1606;&#1593;&#1605;");
    arrAllAmount.add("&#1604;&#1575;");
    
    Vector  itemList = (Vector) request.getAttribute("data");
    Vector resultItem = (Vector) request.getAttribute("resultItem");
    Vector checkResponse = (Vector) request.getAttribute("checkResponse");
    String status = (String) request.getAttribute("status");
    if(status == null) status = "";
    
    int s = itemAtt.length;
    int t = s+2;
    int iTotal = 0;
    
    String stat= (String) request.getSession().getAttribute("currentMode");
    String align=null;
    String dir=null;
    String style=null;
    String lang,langCode,sBackToList, title,save,sSave,fSave;
    String resultTotalItem,noRequestForStore,noResponseFromStore,itemNo,itemName,itemQuan,returned,returnedQuan,retPrev,retCurr;
        if(stat.equals("En")) {
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        langCode="Ar";
        align="left";
        save = "Save";
        sBackToList = "Cancel";
        title = "Request Returned From Store";
        itemNo = "Item NO.";
        itemName = "Item Name";
        itemQuan = "Quantity";
        resultTotalItem = "The subtract from store"; 
        noRequestForStore = "There is no order from the stores";
        noResponseFromStore = "There is no Response From Stores";
        returned = "Returned";
        returnedQuan = "Returned Quantity";
        sSave = "Save Process Complete ...";
        fSave = "Save Process Not Complete ...";
        retPrev = "Previous";
        retCurr = "Current";
    }else {
        align="right";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        langCode="En";
        save = "&#1581;&#1600;&#1601;&#1600;&#1592;";
        itemNo = "&#1585;&#1602;&#1605; &#1575;&#1604;&#1589;&#1606;&#1601;";
        itemName = "&#1575;&#1587;&#1600;&#1600;&#1600;&#1605; &#1575;&#1604;&#1589;&#1606;&#1601;";
        itemQuan = "&#1575;&#1604;&#1603;&#1605;&#1610;&#1577; &#1575;&#1604;&#1605;&#1591;&#1604;&#1608;&#1576;&#1577;";
        sBackToList = "&#1573;&#1606;&#1607;&#1575;&#1569;";
        title = "&#1591;&#1604;&#1576; &#1571;&#1585;&#1578;&#1580;&#1575;&#1593; &#1605;&#1606; &#1575;&#1604;&#1605;&#1582;&#1586;&#1606;";
        resultTotalItem = "&#1575;&#1604;&#1605;&#1606;&#1589;&#1585;&#1601; &#1605;&#1606; &#1575;&#1604;&#1605;&#1582;&#1586;&#1606;";
        noRequestForStore = "&#1604;&#1575; &#1610;&#1608;&#1580;&#1583; &#1591;&#1604;&#1576; &#1589;&#1585;&#1601; &#1605;&#1606; &#1575;&#1604;&#1605;&#1582;&#1575;&#1586;&#1606;";
        noResponseFromStore = "&#1604;&#1575;&#1610;&#1608;&#1580;&#1583; &#1585;&#1583; &#1605;&#1606; &#1575;&#1604;&#1605;&#1582;&#1575;&#1586;&#1606;";
        returned = "&#1575;&#1585;&#1578;&#1580;&#1575;&#1593;";
        returnedQuan = "&#1575;&#1604;&#1603;&#1605;&#1610;&#1575;&#1578; &#1575;&#1604;&#1605;&#1585;&#1578;&#1580;&#1593;&#1577;";
        sSave = "&#1578;&#1600;&#1605;&#1600;&#1578; &#1593;&#1600;&#1605;&#1600;&#1604;&#1600;&#1610;&#1600;&#1577; &#1575;&#1604;&#1581;&#1600;&#1601;&#1600;&#1592; &#1576;&#1600;&#1606;&#1600;&#1580;&#1600;&#1575;&#1581; ...";
        fSave = "&#1604;&#1600;&#1605; &#1578;&#1600;&#1578;&#1600;&#1605; &#1593;&#1600;&#1605;&#1600;&#1604;&#1600;&#1610;&#1600;&#1577; &#1575;&#1604;&#1581;&#1600;&#1601;&#1600;&#1592; ...";
        retPrev = "&#1575;&#1604;&#1587;&#1575;&#1576;&#1602;&#1577;";
        retCurr = "&#1575;&#1604;&#1581;&#1575;&#1604;&#1610;&#1577;";
    }
        Vector tradeVec = (Vector) request.getAttribute("vecUserTrades");

        WebBusinessObject tradeWbo = (WebBusinessObject) tradeVec.get(0);

        String itemId = null;
        String totalCount = "0";
        int total = 0;
        ItemsMgr  itemsMgr = ItemsMgr.getInstance();
    %>
    
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    <head>
        <TITLE>Debug Tracker - Schedule Detail</TITLE>
        
    </head>
        <script type='text/javascript' src='ChangeLang.js'></script>
        <script type='text/javascript' src='js/silkworm_validate.js'></script>
        <link rel="StyleSheet" href="css/blueStyle.css" />

    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
        function cancelForm() {
            document.RETURNED_STORE_FORM.action ="<%=context%>/AssignedIssueServlet?op=VIEWDETAILS&issueId=<%=issueId%>";
            document.RETURNED_STORE_FORM.submit();
        }

        function submitForm() {
            if(checkReturned()) {
                document.RETURNED_STORE_FORM.action = "<%=context%>/TransactionServlet?op=SaveTransactionReturned";
                document.RETURNED_STORE_FORM.submit();
            }
        }
        
        function inputReadWrite(id) {
            var returnedQuantityList = document.getElementsByName('returnedQuantity');
            var returned = document.getElementsByName('returned');
            if(returned[id].checked) {
                returnedQuantityList[id].readOnly = false;
                returnedQuantityList[id].focus();
            } else {
                returnedQuantityList[id].readOnly = true;
                returnedQuantityList[id].value = "";
            }
        }

        function inputReadOnly(id) {
            var returnedQuantityList = document.getElementsByName('returnedQuantity');
            var returned = document.getElementsByName('returned');
            var value = returnedQuantityList[id].value;
            if(value == "" || !IsNumeric(returnedQuantityList[id].value)) {
                returned[id].checked = false;
                returnedQuantityList[id].readOnly = true;
                returnedQuantityList[id].value = "";
                return;
            }
            var idAsNumber = new Number(value);
            if(idAsNumber == 0) {
                returned[id].checked = false;
                returnedQuantityList[id].readOnly = true;
                returnedQuantityList[id].value = "";
            }
        }
        
        function checkReturned() {
            var returnedCheckBox = document.getElementsByName('returned');
            var counter = 0;
            for(var i = 0; i < returnedCheckBox.length; i++) {
                if(returnedCheckBox[i].checked) {
                    counter++;
                    if(!checkReturnedQuantity(i)) {
                        return false;
                    }
                }
            }

            if(counter > 0) {
                return true;
            } else {
                alert("Must Select at least one Quantity to Returned from Store ...");
            }

            return false;
        }
        
        function checkReturnedQuantity(id) {
            var returnedQuantityList = document.getElementsByName('returnedQuantity');
            var responseItemList = document.getElementsByName('responseItem');
            var returnedQuantityPrevList = document.getElementsByName('returnedQuantityPrev');
            
            var returnedQuantityAsNumber = new Number(returnedQuantityList[id].value);
            var returnedQuantityPrevAsNumber = new Number(returnedQuantityPrevList[id].value);
            var responseItemAsNumber = new Number(responseItemList[id].value);
            
            var returnedQuantity = returnedQuantityAsNumber + returnedQuantityPrevAsNumber;
            if(returnedQuantity > responseItemAsNumber) {
                alert("Must Returned Quantity less than or equal quantity response from store... \n-Becuse Previous Quantity ( " + returnedQuantityPrevAsNumber +" ) + Current Quantity ( " + returnedQuantityAsNumber +" ) must be < = response quantity from store ( " + responseItemAsNumber +" )\n-Must " + returnedQuantity + " less than or equal " + responseItemAsNumber);
                returnedQuantityList[id].focus();
                return false;
            }
            return true;
        }
        function openWindow(url) {
            
            openCustomDialog(url, "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width=750, height=400");
        }
        function getFormDetails() {

            openWindow('ReportsServlet?op=getFormDetails&formCode=STR-INTEG-4');
        }
    </SCRIPT>
    
    <body>
        <FORM NAME="RETURNED_STORE_FORM" METHOD="POST">
            <input type="hidden" id="issueId" name="issueId" value="<%=issueId%>" />
            <input type="hidden" name="trade" id="trade" value="<%=tradeWbo.getAttribute("tradeId")%>">
            <DIV align="left" STYLE="color:blue;">
                <input type="button" value="     <%=lang%>     " onclick="reloadAE('<%=langCode%>')" class="button">
                &ensp;
                <button  onclick="JavaScript: cancelForm();" class="button"><%=sBackToList%> <IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif"> </button>
                <% if((itemList != null && itemList.size()>0) && ((checkResponse != null && checkResponse.size()>0))) { %>
                    &ensp;
                    <button  onclick="JavaScript: submitForm();" class="button"><%=save%></button>
                <%}%>
                <input type="button" name="formDetails" class="button" onclick="getFormDetails()" value="Form Details" />
            </DIV>

            <fieldset align=center class="set">
                <legend align="center">
                    <table align="center">
                        <tr>
                            <td class="td">
                                <font color="blue" style="font-weight: bold" size="5"><%=title%></font>
                            </td>
                        </tr>
                    </table>
                </legend >
                <br>
                <%if(!status.equals("")) { %>
                    <TABLE dir="<%=dir%>" CLASS="blueBorder" WIDTH="50%" CELLPADDING="0" CELLSPACING="0" ALIGN="center">
                        <TR>
                            <%if(status.equals("ok")) { %>
                            <TD class="blueBorder blueHeaderTD" style="text-align:center;background-color: #D3D8DB;color: blue">
                                <%=sSave%>
                            </TD>
                            <% } else { %>
                            <TD class="blueBorder blueHeaderTD" style="text-align:center;background-color: #D3D8DB;color: red">
                                <%=fSave%>
                            </TD>
                            <% } %>
                        </TR>
                    </TABLE>
                    <br>
                <% } %>
                <% if((itemList != null && itemList.size()>0) && ((checkResponse != null && checkResponse.size()>0))) { %>
                    <TABLE dir="<%=dir%>" CLASS="blueBorder" WIDTH="95%" CELLPADDING="0" CELLSPACING="0" ALIGN="center">
                        <TR align="<%=align%>">
                            <TD class="blueBorder blueHeaderTD" style="text-align:center;height: 20px" width="2%" rowspan="2">
                                <b>#</b>
                            </TD>
                            <TD class="blueBorder blueHeaderTD" style="text-align:center;height: 25px" width="20%" rowspan="2">
                                <b><%=itemNo%></b>
                            </TD>
                            <TD class="blueBorder blueHeaderTD" style="text-align:center;height: 25px" width="28%" rowspan="2">
                                <b><%=itemName%></b>
                            </TD>
                            <TD class="blueBorder blueHeaderTD" style="text-align:center;height: 25px" width="10%" rowspan="2">
                                <b><%=itemQuan%></b>
                            </TD>
                            <TD class="blueBorder blueHeaderTD" style="text-align:center;height: 25px" width="15%" rowspan="2">
                                <b><%=resultTotalItem%></b>
                            </TD>
                            <TD class="blueBorder blueHeaderTD" style="text-align:center;height: 25px" width="20%" colspan="2">
                                <b><%=returnedQuan%></b>
                            </TD>
                            <TD class="blueBorder blueHeaderTD" style="text-align:center;height: 25px" width="5%" rowspan="2">
                                <b><%=returned%></b>
                            </TD>
                        </TR>
                        <TR align="<%=align%>">
                            <TD class="blueBorder blueHeaderTD" style="text-align:center;height: 15px" width="10%">
                                <%=retCurr%>
                            </TD>
                            <TD class="blueBorder blueHeaderTD" style="text-align:center;height: 15px" width="10%">
                                <%=retPrev%>
                            </TD>
                        </TR>
                        <%
                        Enumeration e = itemList.elements();

                        while(e.hasMoreElements()) {
                            total = 0;
                            iTotal++;
                            wbo = (WebBusinessObject) e.nextElement();
                            itemId = wbo.getAttribute("itemID").toString();

                            String[] itemCode = itemId.split("-");
                            WebBusinessObject wboItem = new WebBusinessObject();
                        %>

                        <TR>
                            <td class="blueBorder blueBodyTD" style="text-align:center" align="<%=align%>">
                                <b><%=iTotal%></b>
                            </td>
                            <%
                                if(itemCode.length > 1) {
                                    wboItem = itemsMgr.getOnSingleKey(itemId);
                                } else {
                                     wboItem = itemsMgr.getOnObjectByKey(itemId);
                                }
                            %>
                            <TD class="blueBorder blueBodyTD" style="text-align:center" align="<%=align%>">
                               <%  if(itemCode.length > 1) {  %>
                                <b><%=wboItem.getAttribute("itemCodeByItemForm")%></b>
                                <% } else { %>
                                <b><%=wboItem.getAttribute("itemCode")%></b>
                                <% } %>
                           </TD>
                            <TD class="blueBorder blueBodyTD" style="text-align:center" align="<%=align%>">
                                <b><%=wboItem.getAttribute("itemDscrptn")%></b>
                            </TD>
                            <TD class="blueBorder blueBodyTD" style="text-align:center" align="<%=align%>">
                                <b><%=wbo.getAttribute("total")%></b>
                            </TD>

                            <%
                            if (resultItem != null && resultItem.size()>0){
                                total = 0;
                                for(int x=0;x<resultItem.size();x++){
                                    WebBusinessObject resultItemWbo = (WebBusinessObject) resultItem.get(x);
                                    if(resultItemWbo.getAttribute("itemID").equals(itemId)){
                                        totalCount = resultItemWbo.getAttribute("total").toString();
                                        total++;
                                    }
                                }
                            %>
                                    <% if (total>0) { %>
                                        <TD class="blueBorder blueBodyTD" style="text-align:center" align="<%=align%>">
                                            <b><%=totalCount%></b>
                                        </TD>
                                        <% } else { %>
                                            <TD class="blueBorder blueBodyTD" style="text-align:center" align="<%=align%>">
                                            <b><%=total%></b>
                                        </TD>
                                        <% } %>
                                    <% } else { %>
                                    <TD class="blueBorder blueBodyTD" style="text-align:center" align="<%=align%>">
                                        <b><%=total%></b>
                                    </TD>
                                    <% }
                                    %>
                                    <TD class="blueBorder blueBodyTD" style="text-align:center" align="<%=align%>">
                                        <b><input id="returnedQuantity" name="returnedQuantity" type="text" size="5" value="" readonly onblur="JavaScript:inputReadOnly('<%=(iTotal - 1)%>')" maxlength="3" /> </b>
                                    </TD>
                                    <TD class="blueBorder blueBodyTD" style="text-align:center" align="<%=align%>">
                                        <b><input id="returnedQuantityPrev" name="returnedQuantityPrev" type="text" size="5" value="<%=wbo.getAttribute("returnedQuantity")%>" readonly/> </b>
                                        <input type="hidden" id="responseItem" name="responseItem" value="<%=totalCount%>" />
                                    </TD>
                                    <TD class="blueBorder blueBodyTD" style="text-align:center" align="<%=align%>" onclick="JavaScript:inputReadWrite('<%=(iTotal - 1)%>')">
                                        <b><input type="checkbox" id="returned" name="returned" value="<%=(iTotal - 1)%>" <%if(total == 0) { %>disabled<% } %> ></b>
                                        <input type="hidden" id="detailId" name="detailId" value="<%=wbo.getAttribute("detailId")%>" >
                                    </TD>
                               </TR>
                        <%
                        }
                        %>
                    </TABLE>
                <% } else if(itemList.size() == 0) { %>
                    <TABLE dir="<%=dir%>" CLASS="blueBorder" WIDTH="70%" CELLPADDING="0" CELLSPACING="0" ALIGN="center">
                        <TR align="<%=align%>">
                            <TD class="blueBorder blueHeaderTD" style="text-align:center;background-color: #A8A8A8">
                                <font color="blue" style="font-weight: bold" size="3"><%=noRequestForStore%></font>
                            </TD>
                        </TR>
                    </TABLE>
                <% } else {%>
                    <TABLE dir="<%=dir%>" CLASS="blueBorder" WIDTH="70%" CELLPADDING="0" CELLSPACING="0" ALIGN="center">
                        <TR align="<%=align%>">
                            <TD class="blueBorder blueHeaderTD" style="text-align:center;background-color: #A8A8A8">
                                <font color="blue" style="font-weight: bold" size="3"><%=noResponseFromStore%></font>
                            </TD>
                        </TR>
                    </TABLE>
                <% } %>
                <br>
            </fieldset>
            
        </FORM>
    </body>
</html>
