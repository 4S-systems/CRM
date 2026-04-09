<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.tracker.engine.*,com.silkworm.common.*, com.tracker.common.*, java.util.*,com.tracker.business_objects.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,java.util.*,java.text.SimpleDateFormat"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<HTML>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();

        String issueId = (String) request.getAttribute("issueId");
        Vector<WebBusinessObject> tasks = (Vector<WebBusinessObject>) request.getAttribute("tasks");
        Vector<WebBusinessObject> reconfigTasks;

        int indexTask, indexItem;

        String stat= (String) request.getSession().getAttribute("currentMode");
        String align=null;
        String dir=null;
        String style=null;
        String lang,langCode,sBackToList, sSave, sMainTitle, name, code, quantity, notFoundParts;
        if(stat.equals("En")) {
            dir="LTR";
            style="text-align:left";
            lang="   &#1593;&#1585;&#1576;&#1610;    ";
            langCode="Ar";
            align="left";

            sBackToList = "Cancel";
            code = "Code <font color=red>Maintenance Item</font> / <font color=red>Item</font>";
            name = "Name <font color=red>Maintenance Item</font> / <font color=red>Item</font>";
            quantity = "Quantity";
            sSave = "Save";
            sMainTitle = "View spare parts by maintenance items";
            notFoundParts = "Not Found Spare Parts on this Task";
        } else {
            align="right";
            dir="RTL";
            style="text-align:Right";
            lang="English";
            langCode="En";
            sBackToList = "&#1573;&#1606;&#1607;&#1575;&#1569;";
            code = "&#1603;&#1608;&#1583; <font color=red>&#1575;&#1604;&#1576;&#1606;&#1583;</font> / <font color=red>&#1602;&#1591;&#1593;&#1577; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585;</font>";
            name = "&#1575;&#1587;&#1605; <font color=red>&#1575;&#1604;&#1576;&#1606;&#1583;</font> / <font color=red>&#1602;&#1591;&#1593;&#1577; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585;</font>";
            quantity = "&#1575;&#1604;&#1600;&#1603;&#1600;&#1605;&#1600;&#1610;&#1600;&#1577;";
            sSave = "&#1578;&#1587;&#1580;&#1610;&#1604;";
            sMainTitle ="&#1593;&#1600;&#1600;&#1600;&#1585;&#1590; &#1602;&#1591;&#1593; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585; &#1576;&#1576;&#1606;&#1608;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
            notFoundParts = "&#1604;&#1575;&#1578;&#1600;&#1600;&#1600;&#1600;&#1608;&#1580;&#1583; &#1602;&#1591;&#1600;&#1600;&#1600;&#1600;&#1593; &#1594;&#1610;&#1600;&#1600;&#1600;&#1600;&#1575;&#1585; &#1593;&#1604;&#1609; &#1607;&#1600;&#1600;&#1600;&#1600;&#1584;&#1575; &#1575;&#1604;&#1576;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1606;&#1583;";
        }
    %>

    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    <HEAD>
        <TITLE>Debug Tracker - Schedule detail</TITLE>
    </HEAD>

    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
        function cancelForm() {
            document.RECONFIG_TASK_FORM.action ="<%=context%>/AssignedIssueServlet?op=VIEWDETAILS&issueId=<%=issueId%>";
            document.RECONFIG_TASK_FORM.submit();
        }
        
        function submitForm() {
            document.RECONFIG_TASK_FORM.action = "<%=context%>/AssignedIssueServlet?op=saveReconfigTasks&issueId=<%=issueId%>&issueStatus=<%=request.getParameter("issueStatus")%>";
            document.RECONFIG_TASK_FORM.submit();
        }
    </SCRIPT>
    
    <BODY>
        <FORM NAME="RECONFIG_TASK_FORM" action="" METHOD="POST">
            <DIV align="left" STYLE="color:blue;padding-left: 2.5%" ID="btnDiv">
                <input type="button" style="width:100px;height:30px;font-weight:bold" onclick="reloadAE('<%=langCode%>')" value="<%=lang%>" class="button">
                    &ensp;
                <input type="button" style="width:100px;height:30px;font-weight:bold"  value="<%=sBackToList%>"  onclick="JavaScript: cancelForm();" class="button">
                    &ensp;
                <input type="button" id="btnSave" style="width:100px;height:30px;font-weight:bold"  value="<%=sSave%>"  onclick="JavaScript: submitForm();" class="button">
            </DIV>
            <BR>
            <CENTER>
                <FIELDSET class="set" style="border-color: #006699;width: 95%;">
                    <TABLE class="blueBorder" dir="<%=dir%>" align="CENTER" width="100%" cellpadding="0" cellspacing="0" style="">
                        <TR>
                            <TD style="text-align:CENTER;border-color: #006699;" width="50%" class="blueBorder blueHeaderTD"><FONT color='#F3D596' SIZE="4"><%=sMainTitle%></FONT></TD>
                        </TR>
                    </TABLE>
                    <BR>
                    <TABLE CLASS="blueBorder" style="border-color: silver;" WIDTH="95%" CELLPADDING="0" CELLSPACING="0" ALIGN="CENTER" DIR="<%=dir%>">
                        <TR style="cursor: pointer;" class="mainHeaderNormal" onmousemove="this.className='rowHilight'" onmouseout="this.className='mainHeaderNormal'">
                            <TD CLASS="" width="5%" STYLE="font-size: 14px;font-weight: bold;color: black;text-align:<%=align%>;padding-<%=align%>:10px;border-top-width: 0px; height: 25px">
                                &ensp;
                            </TD>
                            <TD CLASS="" width="25%" STYLE="font-size: 14px;font-weight: bold;color: black;text-align:<%=align%>;padding-<%=align%>:10px;border-top-width: 0px; height: 25px">
                                <%=code%>
                            </TD>
                            <TD  CLASS="" width="55%" STYLE="font-size: 14px;font-weight: bold;color: black;text-align:<%=align%>;padding-<%=align%>:10px;border-top-width: 0px; height: 25px">
                                <%=name%>
                            </TD>
                            <TD  CLASS="" width="20%" STYLE="font-size: 14px;font-weight: bold;color: black;text-align:<%=align%>;padding-<%=align%>:10px;border-top-width: 0px; height: 25px">
                                <%=quantity%>
                            </TD>
                        </TR>
                        <%
                        indexTask = 0;
                        for(WebBusinessObject task : tasks) {
                            reconfigTasks = (Vector<WebBusinessObject>) task.getAttribute("reconfigTask");
                            indexTask++;
                        %>
                        <TR style="cursor: pointer" CLASS="act_sub_heading" onmousemove="this.className='rowHilight'" onmouseout="this.className='act_sub_heading'">
                            <TD STYLE="text-align:<%=align%>;padding-<%=align%>:5px;;color: blue;border-top-width: 0px; height: 20px">
                                <%=indexTask%>
                            </TD>
                            <TD STYLE="text-align:<%=align%>;padding-<%=align%>:10px;color: blue;border-top-width: 0px; height: 20px">
                                <%=task.getAttribute("code")%>
                            </TD>
                            <TD  STYLE="text-align:<%=align%>;padding-<%=align%>:10px;color: blue;border-top-width: 0px; height: 20px" colspan="2">
                                <%=task.getAttribute("name")%>
                            </TD>
                        </TR>
                            <% 
                            indexItem = 0;
                            for(WebBusinessObject reconfigTask : reconfigTasks) {
                                indexItem++;
                            %>
                            <TR style="cursor: pointer" onmousemove="this.className='rowHilight'" onmouseout="this.className=''">
                                <TD STYLE="text-align: center;border-top-width: 0px">
                                    <%=indexItem%>
                                </TD>
                                <TD STYLE="text-align:<%=align%>;padding-<%=align%>:40px;border-top-width: 0px">
                                    <%=reconfigTask.getAttribute("itemId")%>
                                </TD>
                                <TD STYLE="text-align:<%=align%>;padding-<%=align%>:40px;border-top-width: 0px">
                                    <%=reconfigTask.getAttribute("itemName")%>
                                </TD>
                                <TD STYLE="text-align:<%=align%>;padding-<%=align%>:40px;border-top-width: 0px">
                                    <%=reconfigTask.getAttribute("itemQuantity")%>
                                </TD>
                            </TR>
                            <% } %>
                            <% if(reconfigTasks.isEmpty()) { %>
                            <TR style="cursor: pointer" onmousemove="this.className='rowHilight'" onmouseout="this.className=''">
                                <TD STYLE="text-align: center;border-top-width: 0px; color: red; font-size: 12px; height: 30px" colspan="4">
                                    <%=notFoundParts%>
                                </TD>
                            </TR>
                            <% } %>
                        <% } %>
                    </TABLE>
                    <BR>
                </FIELDSET>
            </CENTER>
        </FORM>
    </BODY>
</HTML>
