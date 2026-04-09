<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.tracker.engine.*,com.silkworm.common.*, com.tracker.common.*, java.util.*,com.tracker.business_objects.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,java.util.*,java.text.SimpleDateFormat"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<HTML>
    <%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();

    Vector<WebBusinessObject>  itemList = (Vector) request.getAttribute("data");
    String issueId = (String) request.getAttribute(IssueConstants.ISSUEID);
    String businessId = (String) request.getAttribute("businessId");
    String status = (String) request.getAttribute("status");
    if(status == null) status = "";
    
    boolean canDelete = (Boolean) request.getAttribute("canDelete");
    boolean isIssueHasRequest = (Boolean) request.getAttribute("isIssueHasRequest");

    String stat= (String) request.getSession().getAttribute("currentMode");
    String align, reverseAlign, dir, title_1, title_2, issueNo, save, cannotCancel, quatitiesRequ;
    String lang, langCode, sBackToList, noRequestForStore, itemNo, itemName, itemQuantity, sStatus, fStatus;
    if(stat.equals("En")) {
        dir="LTR";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        langCode="Ar";
        align="left";
        reverseAlign="right";
        sBackToList = "Cancel";
        issueNo = "Issue Code";
        save = "Cancel Request";
        title_1="Cancel Request From Store";
        title_2="Cancel Request From Store - <font color=white>Are you Sure </font>?";
        itemNo = "Item NO.";
        itemName = "Item Name";
        itemQuantity = "Quantity";
        noRequestForStore ="There is no order from the stores";
        sStatus = "Spare Parts Saved Successfully";
        fStatus = "Fail To Save This Spare Parts";
        cannotCancel = "Can not cancel it because it has already replied him from the store";
        quatitiesRequ = "The Quantities Required";
    } else {
        align="right";
        reverseAlign="left";
        dir="RTL";
        lang="English";
        langCode="En";
        issueNo = "&#1585;&#1602;&#1605; &#1571;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
        sBackToList = "&#1573;&#1606;&#1607;&#1575;&#1569;";
        save = "&#1573;&#1604;&#1600;&#1594;&#1600;&#1575;&#1569; &#1575;&#1604;&#1591;&#1600;&#1604;&#1600;&#1576;";
        title_1="&#1573;&#1604;&#1600;&#1594;&#1600;&#1575;&#1569; &#1591;&#1600;&#1604;&#1600;&#1576; &#1605;&#1606; &#1575;&#1604;&#1605;&#1600;&#1600;&#1582;&#1600;&#1600;&#1586;&#1606;";
        title_2="&#1573;&#1604;&#1600;&#1594;&#1600;&#1575;&#1569; &#1591;&#1600;&#1604;&#1600;&#1576; &#1605;&#1606; &#1575;&#1604;&#1605;&#1600;&#1600;&#1582;&#1600;&#1600;&#1586;&#1606; - <font color=white>&#1607;&#1600;&#1600;&#1604; &#1571;&#1606;&#1600;&#1600;&#1578; &#1605;&#1600;&#1600;&#1578;&#1600;&#1600;&#1571;&#1603;&#1600;&#1600;&#1600;&#1600;&#1583; </font>&#1567;";
        noRequestForStore = "&#1604;&#1575; &#1610;&#1608;&#1580;&#1583; &#1591;&#1604;&#1576; &#1589;&#1585;&#1601; &#1605;&#1606; &#1575;&#1604;&#1605;&#1582;&#1575;&#1586;&#1606;";
        itemNo = "&#1585;&#1602;&#1605; &#1575;&#1604;&#1589;&#1606;&#1601;";
        itemName = "&#1575;&#1587;&#1600;&#1600;&#1600;&#1605; &#1575;&#1604;&#1589;&#1606;&#1601;";
        itemQuantity = "&#1575;&#1604;&#1603;&#1605;&#1610;&#1577; &#1575;&#1604;&#1605;&#1591;&#1604;&#1608;&#1576;&#1577;";
        fStatus="&#1604;&#1600;&#1605; &#1610;&#1600;&#1578;&#1600;&#1600;&#1605; &#1573;&#1604;&#1600;&#1594;&#1600;&#1575;&#1569; &#1575;&#1604;&#1591;&#1600;&#1604;&#1600;&#1576;";
        sStatus="&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604; &#1576;&#1600;&#1606;&#1600;&#1580;&#1600;&#1575;&#1581;";
        cannotCancel = "&#1604;&#1575; &#1610;&#1605;&#1600;&#1603;&#1600;&#1606; &#1573;&#1604;&#1600;&#1600;&#1594;&#1600;&#1600;&#1575;&#1569; &#1607;&#1600;&#1584;&#1575; &#1575;&#1604;&#1591;&#1600;&#1604;&#1600;&#1576; &#1604;&#1571;&#1606;&#1600;&#1607; &#1578;&#1605; &#1575;&#1604;&#1600;&#1585;&#1583; &#1593;&#1604;&#1600;&#1610;&#1600;&#1577; &#1605;&#1600;&#1606; &#1575;&#1604;&#1605;&#1600;&#1582;&#1600;&#1586;&#1606;";
        quatitiesRequ = "&#1575;&#1604;&#1603;&#1600;&#1605;&#1600;&#1610;&#1600;&#1575;&#1578; &#1575;&#1604;&#1605;&#1600;&#1591;&#1600;&#1604;&#1600;&#1608;&#1576;&#1600;&#1577;";
    }
    %>

    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    <HEAD>
        <TITLE>Maintenance - Schedule detail</TITLE>
    </HEAD>
    <script src='ChangeLang.js' type='text/javascript'></script>
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
    function cancelForm() {
        document.JobOrder_FORM.action ="<%=context%>/AssignedIssueServlet?op=VIEWDETAILS&issueId=<%=issueId%>";
        document.JobOrder_FORM.submit();
    }
        
    function submitForm() {
        document.JobOrder_FORM.action = "<%=context%>/TransactionServlet?op=deleteTransaction&issueId=<%=issueId%>";
        document.JobOrder_FORM.submit();
    }
    </SCRIPT>
    
    <BODY>
        <FORM action=""  NAME="JobOrder_FORM" METHOD="POST">
            <DIV align="left" STYLE="color:blue; padding-left: 2.5%; padding-bottom: 10px">
                <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
                &ensp;
                <button  onclick="JavaScript: cancelForm();" class="button"><%=sBackToList%></button>
                <% if(isIssueHasRequest && canDelete) { %>
                &ensp;
                <button  onclick="JavaScript: submitForm();" class="button"><%=save%></button>
                <% } %>
            </DIV>
            <CENTER>
                <FIELDSET class="set" style="width:95%;border-color: #006699;" >
                    <TABLE class="blueBorder" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                        <TR>
                            <TD style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD">
                                <font color="#F3D596" size="4">
                                    <% if(canDelete && isIssueHasRequest) { %>
                                        <%=title_2%>
                                    <% } else { %>
                                        <%=title_1%>
                                    <% } %>
                                </font>
                            </TD>
                        </TR>
                    </TABLE>
                    <% if(!status.equals("")) { %>
                    <TABLE class="blueBorder" dir="rtl" align="center" width="95%" cellpadding="0" cellspacing="0" style="margin-bottom: 10px; margin-top: 10px">
                        <TR>
                            <%if(status.equals("ok")){%>
                            <TD width="100%" bgcolor="#D0D0D0" STYLE="padding-bottom: 2px;padding-top: 2px">
                                <font color="blue" STYLE="font-weight: bold" size="3"><center><%=sStatus%></center></font>
                            </TD>
                            <%} else if(status.equals("no")){%>
                            <TD width="100%" bgcolor="#D0D0D0" STYLE="padding-bottom: 2px;padding-top: 2px">
                                <font color="red" STYLE="font-weight: bold" size="3"><center><%=fStatus%></center></font>
                            </TD>
                            <%}%>
                        </TR>
                    </TABLE>
                    <% } %>
                    <div align="<%=reverseAlign%>" style="margin-<%=reverseAlign%>: 2.5%;color: blue; margin-bottom: 10px; margin-top: 10px">
                        <p dir="<%=dir%>" align="<%=reverseAlign%>" style="background-color: #E6E6FA;width:25%;font-weight: bold;font-size: 16px;padding-top: 2px;padding-bottom: 2px;padding-left: 5px;padding-right: 5px;text-align: <%=align%>"><b><%=issueNo%>&ensp;:<font color="red">&ensp;<%=businessId%></font></b></p>
                    </div>

                    <div align="<%=align%>" style="margin-<%=align%>: 2.5%;color: blue; margin-bottom: 10px; margin-top: 10px">
                        <p dir="<%=dir%>" align="<%=align%>" style="background-color: #E6E6FA;width:25%;font-weight: bold;font-size: 16px;padding-top: 2px;padding-bottom: 2px;padding-left: 5px;padding-right: 5px;text-align: <%=align%>"><b><%=quatitiesRequ%></b></p>
                    </div>

                    <% if(isIssueHasRequest && canDelete) { %>
                    <TABLE class="blueBorder" dir="<%=dir%>" WIDTH="95%" CELLPADDING="0" CELLSPACING="0" ALIGN="center">
                        <TR>
                            <TD class="blueBorder backgroundHeader blueHeaderTD" style="text-align:center">
                                <b>#</b>
                            </TD>
                            <TD class="blueBorder backgroundHeader blueHeaderTD" style="text-align:center">
                                <b><%=itemNo%></b>
                            </TD>
                            <TD class="blueBorder backgroundHeader blueHeaderTD" style="text-align:center">
                                <b><%=itemName%></b>
                            </TD>
                            <TD class="blueBorder backgroundHeader blueHeaderTD" style="text-align:center">
                                <b><%=itemQuantity%></b>
                            </TD>
                        </TR>
                        <%
                        int iTotal = 0;
                        for(WebBusinessObject wbo : itemList) {
                            iTotal++;
                        %>
                        <TR style="cursor: pointer" onmouseover="this.className = 'rowHilight'" onmouseout="this.className = ''">
                            <TD class="blueBorder blueBodyTD" style="text-align:center" align="<%=align%>" width="40">
                                <b><%=iTotal%></b>
                            </TD>
                            <TD class="blueBorder blueBodyTD" style="text-align:center" align="<%=align%>">
                                <b><%=wbo.getAttribute("itemID")%></b>
                           </TD>
                            <TD class="blueBorder blueBodyTD" style="text-align:center" align="<%=align%>">
                                <b><%=wbo.getAttribute("itemName")%></b>
                            </TD>
                           <TD class="blueBorder blueBodyTD" style="text-align:center" align="<%=align%>">
                                <b><%=wbo.getAttribute("total")%></b>
                            </TD>
                           </TR>
                        <% } %>
                    </TABLE>
                    <% } else if(!isIssueHasRequest) { %>
                    <TABLE class="blueBorder" dir="rtl" align="center" width="95%" cellpadding="0" cellspacing="0">
                        <TR>
                            <TD width="100%" bgcolor="#D0D0D0" STYLE="padding-bottom: 2px;padding-top: 2px">
                                <font color="red" STYLE="font-weight: bold" size="3"><center><%=noRequestForStore%></center></font>
                            </TD>
                        </TR>
                    </TABLE>
                    <% } else { %>
                    <TABLE class="blueBorder" dir="rtl" align="center" width="95%" cellpadding="0" cellspacing="0">
                        <TR>
                            <TD width="100%" bgcolor="#D0D0D0" STYLE="padding-bottom: 2px;padding-top: 2px">
                                <font color="red" STYLE="font-weight: bold" size="3"><center><%=cannotCancel%></center></font>
                            </TD>
                        </TR>
                    </TABLE>
                    <% } %>
                    <BR>
                </FIELDSET>
            </CENTER>
            <!-- some hidden variables -->
            <input type="hidden" id="issueId" name="issueId" value="<%=issueId%>" />
            <input type="hidden" id="businessId" name="businessId" value="<%=businessId%>" />
        </FORM>
    </BODY>
</HTML>
