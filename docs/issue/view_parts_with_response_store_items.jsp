<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.tracker.engine.*,com.silkworm.common.*, com.tracker.common.*, java.util.*,com.tracker.business_objects.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,java.util.*,java.text.SimpleDateFormat"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page contentType="text/html; charset=utf-8" %>
<html>
    <%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    String issueId = (String) request.getAttribute(IssueConstants.ISSUEID);
    String issueTitle = (String) request.getAttribute(IssueConstants.ISSUETITLE);
    
    String filterName = (String) request.getAttribute("filter");
    String filterValue = (String) request.getAttribute("filterValue");
    
    String[] itemAtt = {"itemId", "itemQuantity"};//appCons.getItemScheduleAttributes();
    String[] itemTitle = {"&#1605;", "&#1585;&#1602;&#1605; &#1575;&#1604;&#1589;&#1606;&#1601;", "&#1575;&#1587;&#1600;&#1600;&#1600;&#1605; &#1575;&#1604;&#1589;&#1606;&#1601;", "&#1575;&#1604;&#1603;&#1605;&#1610;&#1577; &#1575;&#1604;&#1605;&#1591;&#1604;&#1608;&#1576;&#1577;"};//appCons.getItemScheduleHeaders();
    
    ArrayList arrAllAmount = new ArrayList();
    arrAllAmount.add("&#1606;&#1593;&#1605;");
    arrAllAmount.add("&#1604;&#1575;");
    
    Vector<WebBusinessObject>  itemList = (Vector) request.getAttribute("data");
    Vector resultItem = (Vector) request.getAttribute("resultItem");
    
    int s = itemAtt.length;
    int t = s+2;
    int iTotal = 0;
    
    String stat= (String) request.getSession().getAttribute("currentMode");
    String align=null;
    String dir=null;
    String style=null;
    String lang, langCode, sBackToList, sResponsetItems, resultTotalItem, noRequestForStore;
    String itemNameMsg;
        if(stat.equals("En")){
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        langCode="Ar";
        align="left";
        
        sBackToList = "Cancel";
        sResponsetItems = "View Spare Parts";
        itemTitle[0] = "#";
        itemTitle[1] = "Item NO.";
        itemTitle[2] = "Item Name";
        itemTitle[3] = "Quantity";
        resultTotalItem = "The subtract from store"; 
        noRequestForStore ="There is no Spare Parts";

        itemNameMsg = "Item Not Found in stores";
    } else {
        align="right";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        langCode="En";
        sBackToList = "&#1573;&#1606;&#1607;&#1575;&#1569;";
        sResponsetItems = "&#1605;&#1588;&#1600;&#1600;&#1600;&#1600;&#1575;&#1607;&#1583;&#1607; &#1602;&#1591;&#1600;&#1600;&#1600;&#1600;&#1593; &#1575;&#1604;&#1594;&#1610;&#1600;&#1600;&#1600;&#1600;&#1575;&#1585;";
        resultTotalItem = "&#1575;&#1604;&#1605;&#1606;&#1589;&#1585;&#1601; &#1605;&#1606; &#1575;&#1604;&#1605;&#1582;&#1586;&#1606;";
        noRequestForStore = "&#1604;&#1575; &#1610;&#1600;&#1600;&#1600;&#1600;&#1608;&#1580;&#1583; &#1602;&#1591;&#1600;&#1600;&#1600;&#1600;&#1593; &#1594;&#1610;&#1600;&#1600;&#1600;&#1600;&#1575;&#1585;";

        itemNameMsg = "قطعة الغيار غير موجودة بالمخازن";
    }
    
    String itemId = null;
    String totalCount = "0";
    int total = 0;
    ItemsMgr  itemsMgr = ItemsMgr.getInstance();
    %>
    
    
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    <head>
        <TITLE>View Spare Parts</TITLE>
        
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
    </SCRIPT>
    
    <body>
        <FORM NAME="JobOrder_FORM" METHOD="POST" action="">
            <DIV align="left" STYLE="color:blue; padding-left: 2.5%; padding-bottom: 10px">
                <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button" />
                &ensp;
                <button  onclick="JavaScript: cancelForm();" class="button"><%=sBackToList%></button>
            </DIV>
            <CENTER>
                <FIELDSET class="set" style="width:95%;border-color: #006699;" >
                    <TABLE class="blueBorder" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                        <TR>
                            <TD style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD"><font color="#F3D596" size="4"><%=sResponsetItems%></font></TD>
                        </TR>
                    </TABLE>
                    <% if(itemList != null && itemList.size()>0) { %>
                    <table border="0" width="95%" id="table1" align="center" dir="<%=dir%>" style="margin-top: 10px; margin-bottom: 10px">
                        <tr>
                            <td width="100%" style="border: none">
                                <TABLE class="blueBorder" WIDTH="100%" CELLPADDING="0" CELLSPACING="0" ALIGN="center">
                                    <TR align="<%=align%>">
                                        <% for(int i = 0;i<t;i++) { %>
                                        <TD class="blueBorder backgroundHeader blueHeaderTD" style="text-align:center">
                                            <b>
                                                <%=itemTitle[i]%>
                                            </b>
                                        </TD>
                                        <% } %>
                                       <TD class="blueBorder backgroundHeader blueHeaderTD" style="text-align:center" BGCOLOR="#99CCFF">
                                            <b>
                                                <%=resultTotalItem%>
                                            </b>
                                        </TD>
                                    </TR>
                                    <%
                                    WebBusinessObject wboItem;
                                    for(WebBusinessObject wbo : itemList) {
                                        iTotal++;
                                        itemId = wbo.getAttribute("itemId").toString();

                                        String[] itemCode = itemId.split("-");
                                        wboItem = new WebBusinessObject();
                                    %>
                                    <TR style="cursor: pointer"  onmouseover="this.className = 'rowHilight'" onmouseout="this.className = ''">
                                        <td class="blueBorder blueBodyTD" style="text-align:center" align="<%=align%>" width="40">
                                            <b>  <%=iTotal%> </b>
                                        </td>
                                        <%
                                            if(itemCode.length > 1) {
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
                                        <TD class="blueBorder blueBodyTD" style="text-align:center" align="<%=align%>">
                                            <b><%=item_code%></b>
                                       </TD>
                                        <TD class="blueBorder blueBodyTD" style="text-align:center" align="<%=align%>">
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
                                       <TD class="blueBorder blueBodyTD" style="text-align:center" align="<%=align%>">
                                            <b><%=wbo.getAttribute("itemQuantity")%></b>
                                        </TD>

                                        <% if (resultItem != null && resultItem.size() > 0){
                                                 total = 0;
                                                for(int x=0; x<resultItem.size(); x++){
                                                    WebBusinessObject resultItemWbo = (WebBusinessObject) resultItem.get(x);
                                                    if(resultItemWbo.getAttribute("itemID").equals(itemId)){
                                                        totalCount = resultItemWbo.getAttribute("total").toString();
                                                        total++;
                                                    }
                                                }
                                        %>
                                                <% if (total>0){ %>
                                                <TD class="blueBorder blueBodyTD" style="text-align:center" align="<%=align%>" BGCOLOR="#D5EAFF">
                                                    <b><%=totalCount%></b>
                                                </TD>
                                                <% } else { %>
                                                    <TD class="blueBorder blueBodyTD" style="text-align:center" align="<%=align%>" BGCOLOR="#D5EAFF">
                                                    <b><%=total%></b>
                                                </TD>
                                                <% } %>
                                                <% } else { %>
                                                <TD class="blueBorder blueBodyTD" style="text-align:center" align="<%=align%>" BGCOLOR="#D5EAFF">
                                                    <b><%=total%></b>
                                                </TD>
                                                <% } %>
                                       </TR>
                                    <% } %>
                                </TABLE>
                            </td>
                        </tr>
                    </table>
                    <% } else { %>
                        <center style="font-size:20px;color:red; margin-bottom: 10px; margin-top: 10px">
                            <%=noRequestForStore%>
                        </center>
                    <% } %>
                </FIELDSET>
            </CENTER>
        </FORM>
    </body>
</html>
