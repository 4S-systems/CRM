<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@ page pageEncoding="UTF-8"%>
<%
            MetaDataMgr metaMgr = MetaDataMgr.getInstance();
            String context = metaMgr.getContext();

            TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

//Vector actualItems = (Vector) request.getAttribute("actualItems");
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


            String cMode = (String) request.getSession().getAttribute("currentMode");
            String stat = cMode;

            String align = null;
            String dir = null;
            String style = null;
            String lang, langCode, ViewSpars, attachedOn, partType, BackToList, schduled, finished, categlog, ToCost,
                    Begined, Finished, head, attached, Canceled, onAttachedEq, onMainEq, sparePartType, lacalSpare, ERPSpare, Holded, Rejected, status, cost, count, price, name, code, onCreate, viewTaskSpar;
            String itemNameMsg = "";

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
                Holded = "on Hold";
                Rejected = "Rejected";
                status = "Status";
                code = "Code";
                name = "Name";
                price = "Price";
                count = "countity";
                cost = "Cost";
                finished = "After Execution Spare Parts";
                categlog = "Planned Spare Parts";
                onCreate = "During Execution Spare Parts";
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

                itemNameMsg = "Item Not Found in stores";
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
                Holded = "&#1605;&#1608;&#1602;&#1608;&#1601;&#1577;";
                Rejected = "&#1605;&#1585;&#1601;&#1608;&#1590;&#1577;";
                status = "&#1575;&#1604;&#1581;&#1575;&#1604;&#1577;";
                code = "&#1603;&#1608;&#1583; &#1575;&#1604;&#1602;&#1591;&#1593;&#1577;";
                name = "&#1575;&#1587;&#1605; &#1575;&#1604;&#1602;&#1591;&#1593;&#1577;";
                price = "&#1587;&#1593;&#1585; &#1575;&#1604;&#1608;&#1581;&#1583;&#1577;";
                count = "&#1575;&#1604;&#1603;&#1605;&#1610;&#1577;";
                cost = "&#1573;&#1580;&#1605;&#1575;&#1604;&#1610; &#1575;&#1604;&#1587;&#1593;&#1585;";
                finished = "&#1602;&#1591;&#1593; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585; &#1576;&#1593;&#1583; &#1575;&#1604;&#1578;&#1606;&#1601;&#1610;&#1584;";
                categlog = "&#1602;&#1591;&#1593; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585; &#1575;&#1604;&#1605;&#1582;&#1591;&#1591;&#1577;";
                onCreate = "&#1602;&#1591;&#1593; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585; &#1582;&#1604;&#1575;&#1604; &#1575;&#1604;&#1578;&#1606;&#1601;&#1610;&#1584;";
                ToCost = "&#1573;&#1580;&#1605;&#1575;&#1604;&#1610;";
                viewTaskSpar = "&#1593;&#1585;&#1590; &#1605;&#1585;&#1581;&#1604;&#1610; &#1604;&#1602;&#1591;&#1593; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585;";
                sparePartType = "&#1606;&#1600;&#1600;&#1600;&#1600;&#1608;&#1593; &#1602;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1591;&#1600;&#1600;&#1593; &#1575;&#1604;&#1600;&#1600;&#1594;&#1600;&#1600;&#1610;&#1600;&#1600;&#1575;&#1585;";
                ERPSpare = "&#1602;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1591;&#1600;&#1600;&#1593; &#1575;&#1604;&#1600;&#1600;&#1594;&#1600;&#1600;&#1610;&#1600;&#1600;&#1575;&#1585; &#1605;&#1600;&#1606; &#1575;&#1604;&#1600;&#1605;&#1600;&#1582;&#1600;&#1575;&#1586;&#1606; &#1575;&#1604;&#1600;&#1582;&#1575;&#1585;&#1580;&#1600;&#1610;&#1600;&#1607;";
                lacalSpare = "&#1602;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1591;&#1600;&#1600;&#1593; &#1575;&#1604;&#1600;&#1600;&#1594;&#1600;&#1600;&#1610;&#1600;&#1600;&#1575;&#1585; &#1605;&#1606; &#1575;&#1604;&#1588;&#1585;&#1575;&#1569; &#1605;&#1576;&#1575;&#1588;&#1585;&#1577;";
                partType = "&#1606;&#1608;&#1593; &#1575;&#1604;&#1602;&#1591;&#1593;&#1607;";
                attachedOn = "&#1578;&#1605;&#1610;&#1610;&#1586; &#1575;&#1604;&#1602;&#1591;&#1593;&#1607;";
                onAttachedEq = "&#1602;&#1591;&#1593;&#1607; &#1594;&#1610;&#1575;&#1585; &#1593;&#1604;&#1609; &#1605;&#1602;&#1591;&#1608;&#1585;&#1607;";
                onMainEq = "&#1602;&#1591;&#1593;&#1607; &#1594;&#1610;&#1575;&#1585; &#1593;&#1604;&#1609; &#1602;&#1575;&#1591;&#1585;&#1607;";
                head = "&#1585;&#1571;&#1587;";
                attached = "&#1605;&#1604;&#1581;&#1602;";

                itemNameMsg = "قطعة الغيار غير موجودة بالمخازن";
            }
%>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

    function cancelForm()
    {
        document.PROJECT_VIEW_FORM.action = "<%=context%>/AssignedIssueServlet?op=viewdetails&issueId=<%=(String) request.getAttribute("issueId")%>&filterValue=<%=(String) request.getAttribute("filterValue")%>&filterName=<%=(String) request.getAttribute("filterName")%>";
        document.PROJECT_VIEW_FORM.submit();  
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
</SCRIPT>
<script src='ChangeLang.js' type='text/javascript'></script>
<HTML>


    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Document Viewer - add new Project</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>
    <BODY>

        <FORM NAME="PROJECT_VIEW_FORM" METHOD="POST">
            <%if (request.getAttribute("Tap") == null) {%>
            <table align="<%=align%>" border="0" width="100%">


                <tr>

                    <TD STYLE="border:0px" width="34%"  VALIGN="top">
                        <DIV STYLE="width:50%;border:2px solid gray;background-color:#808000;color:white;">
                            <DIV ONCLICK="JavaScript: changeMode('menu5');" STYLE="width:100%;background-color:#808000;color:white;cursor:hand;font-size:16;">
                                <B><%=sparePartType%></B> <img src="images/arrow_down.gif">
                            </DIV>

                            <DIV ALIGN="<%=align%>" STYLE="width:100%;background-color:#FFFFCC;color:black;display:none;text-align:right;" ID="menu5">
                                <table border="0" cellpadding="0"  width="100%" cellspacing="3"  bgcolor="#FFFFCC">

                                    <tr>

                                        <TD   nowrap CLASS="cell"  bgcolor="#FFCC00" style="text-align:center;border:1px solid blue;cursor:hand;color:white;font-size:12;"  nowrap  CLASS="cell">
                                            <b><font color="black"><%=lacalSpare%></font></b>
                                        </TD>
                                        <TD   nowrap CLASS="cell"  bgcolor="#c8d8f8" style="text-align:center;border:1px solid blue;cursor:hand;color:white; font-size:12"  nowrap  CLASS="cell">
                                            <b><font color="black"><%=ERPSpare%></font></b>
                                        </TD>

                                    </tr>
                                    <tr>

                                        <TD   nowrap CLASS="cell"  bgcolor="#cc9933" style="text-align:center;border:1px solid blue;cursor:hand;color:white;font-size:12;"  nowrap  CLASS="cell">
                                            <b><font color="black"><%=onMainEq%></font></b>
                                        </TD>
                                        <TD   nowrap CLASS="cell"  bgcolor="#FFFF33" style="text-align:center;border:1px solid blue;cursor:hand;color:white; font-size:12"  nowrap  CLASS="cell">
                                            <b><font color="black"><%=onAttachedEq%></font></b>
                                        </TD>

                                    </tr>
                                </table>
                            </DIV>
                        </DIV>
                    </TD>

                </tr>
            </table>
            <DIV align="left" STYLE="color:blue;">
                <input type="button" class="button" value="     <%=lang%>     " onclick="reloadAE('<%=langCode%>')">
                <button  class="button" onclick="JavaScript: cancelForm();"><%=BackToList%> <IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif"> </button>
                <!--button  class="button" onclick="JavaScript: changePage('<%=context%>/ItemDocReaderServlet?op=ViewPartsExcel&issueId=<%=request.getParameter("issueId")%>');"><IMG VALIGN="BOTTOM"   SRC="images/xlsicon.gif"> </button-->
            </DIV>

            <%}%>
            <fieldset align="center" style="border-color:blue" >
                <legend align="<%=align%>">

                    <table dir="<%=dir%>" align="<%=align%>">
                        <tr>

                            <td class="td">
                                <font color="blue" size="6">   <%=viewTaskSpar%>
                                </font>

                            </td>
                        </tr>
                    </table>
                </legend >

                <br>
                <table align="<%=align%>" border="0" dir="<%=dir%>" width="100%">

                    <tr>
                        <TD CLASS="td" VALIGN="top">
                            <table ALIGN="<%=align%>" DIR="<%=dir%>" width ="100%">
                                <TR>
                                    <TD STYLE="border:1px solid black" width ="33%" VALIGN="top" COLSPAN="2">
                                        <table border="0" ALIGN="<%=align%>" DIR="<%=dir%>" width ="100%" cellpadding="0" cellspacing="1">
                                            <TR>
                                                <TD style="text-align:center" CLASS="head" bgcolor="#F3F3F3" width="33%" COLSPAN="6">
                                                    <b><%=categlog%></b>
                                                </TD>
                                            </TR>
                                            <TR bgcolor="#808080">
                                                <TD STYLE="border:0px;color:white">
                                                    <b><%=code%></b>
                                                </TD>
                                                <TD STYLE="border:0px;color:white">
                                                    <b><%=name%></b>
                                                </TD>
                                                <TD STYLE="border:0px;color:white">
                                                    <b><%=count%></b>
                                                </TD>
                                                <TD STYLE="border:0px;color:white">
                                                    <b><%=price%></b>
                                                </TD>
                                                <TD STYLE="border:0px;color:white">
                                                    <b><%=cost%></b>
                                                </TD>
                                            </TR>
                                            <%
                                                        for (int i = 0; i < configureItems.size(); i++) {
                                                            WebBusinessObject tempWbo = (WebBusinessObject) configureItems.get(i);
                                                            if ((i % 2) == 1) {
                                                                bgColor = "#FFFFCC";
                                                            } else {
                                                                bgColor = "#CCCC00";
                                                            }
                                                            if (((String) tempWbo.getAttribute("totalCost")) != null) {
                                                                Double iTemp = new Double(((String) tempWbo.getAttribute("totalCost")));
                                                                iConfigureTotal = iConfigureTotal + iTemp.doubleValue();
                                                            }
                                            %>
                                            <TR BGCOLOR="<%=bgColor%>">
                                                <TD STYLE="border:0px">
                                                    <%=(String) tempWbo.getAttribute("itemCode")%>
                                                </TD>
                                                <TD STYLE="border:0px">
                                                    <%
                                                        String itemDesc = tempWbo.getAttribute("itemDscrptn").toString();
                                                        if(itemDesc.equals("---")){
                                                            itemDesc = "<font size = '3' style='background-color: red;' color = 'white'><img src = 'images/worning_yallow.jpg' />&nbsp;&nbsp;" + itemNameMsg + "</font>";
                                                        }
                                                    %>
                                                    <%=itemDesc%>
                                                </TD>
                                                <TD STYLE="border:0px">
                                                    <%=(String) tempWbo.getAttribute("itemQuantity")%>
                                                </TD>
                                                <TD STYLE="border:0px">
                                                    <%=(String) tempWbo.getAttribute("itemPrice")%>
                                                </TD>
                                                <TD STYLE="border:0px">
                                                    <%=(String) tempWbo.getAttribute("totalCost")%>
                                                </TD>
                                            </TR>
                                            <%
                                                        }
                                            %>
                                        </table>
                                    </TD>
                                    <TD STYLE="border:1px solid black" width ="33%" VALIGN="top" COLSPAN="2">
                                        <table border="0" ALIGN="<%=align%>" DIR="<%=dir%>" width ="100%" cellpadding="0" cellspacing="1">
                                            <TR>
                                                <TD style="text-align:center" CLASS="head" bgcolor="#F3F3F3" width="33%" COLSPAN="6">
                                                    <b><%=onCreate%></b>
                                                </TD>
                                            </TR>
                                            <TR bgcolor="#808080">

                                                <!--TD WIDTH="20" STYLE="border:0px;color:white">
                                                    <b><%=attachedOn%></b>
                                                </TD-->

                                                <TD STYLE="border:0px;color:white">
                                                    <b><%=code%></b>
                                                </TD>
                                                <TD STYLE="border:0px;color:white">
                                                    <b><%=name%></b>
                                                </TD>
                                                <TD STYLE="border:0px;color:white">
                                                    <b><%=count%></b>
                                                </TD>
                                                <TD STYLE="border:0px;color:white">
                                                    <b><%=price%></b>
                                                </TD>
                                                <TD STYLE="border:0px;color:white">
                                                    <b><%=cost%></b>
                                                </TD>
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
                                            <TR BGCOLOR="<%=bgColor%>">
                                                <%--
                                                <%if(tempWbo.getAttribute("attachedOn").toString().equals("1")){%>
                                                <TD STYLE="border:0px" BGCOLOR="#cc9933"><b><font color="white"><%=head%></font></b></TD>
                                                <%}else if(tempWbo.getAttribute("attachedOn").toString().equals("0")){%>
                                                <TD STYLE="border:0px" BGCOLOR="#ffff33"><b><%=attached%></b></TD>
                                                <%}else if(tempWbo.getAttribute("attachedOn").toString().equals("2")){
                                                if(eq_isStandAlone.equalsIgnoreCase("1")){%>
                                                <TD STYLE="border:0px" BGCOLOR="#cc9933"><b><font color="white"><%=head%></font></b></TD>
                                                <%}else{%>
                                                <TD STYLE="border:0px" BGCOLOR="#ffff33"><b><%=attached%></b></TD>
                                                <%}}%>
                                                --%>
                                                <TD STYLE="border:0px">
                                                    <%=(String) tempWbo.getAttribute("itemCode")%>
                                                </TD>
                                                <TD STYLE="border:0px">
                                                    <%
                                                        String itemDesc = tempWbo.getAttribute("itemDscrptn").toString();
                                                        if(itemDesc.equals("---")){
                                                            itemDesc = "<font size = '3' style='background-color: red;' color = 'white'><img src = 'images/worning_yallow.jpg' />&nbsp;&nbsp;" + itemNameMsg + "</font>";
                                                        }
                                                    %>
                                                    <%=itemDesc%>
                                                </TD>
                                                <TD STYLE="border:0px">
                                                    <%=(String) tempWbo.getAttribute("itemQuantity")%>
                                                </TD>
                                                <TD STYLE="border:0px">
                                                    <%=(String) tempWbo.getAttribute("itemPrice")%>
                                                </TD>
                                                <TD STYLE="border:0px">
                                                    <%=(String) tempWbo.getAttribute("totalCost")%>
                                                </TD>
                                            </TR>
                                            <%
                                                        }
                                            %>
                                        </table>
                                    </TD>
                                    <%--
                                    <TD STYLE="border:1px solid black" width ="33%" VALIGN="top" COLSPAN="2">
                                        <table border="0" ALIGN="<%=align%>" DIR="<%=dir%>" width ="100%" cellpadding="0" cellspacing="1">
                                            <TR>
                                                <TD style="text-align:center" CLASS="head" bgcolor="#F3F3F3" width="33%" COLSPAN="6">
                                                    <B><%=finished%></B>
                                                </TD>
                                            </TR>
                                            <TR bgcolor="#808080">
                                                <TD STYLE="border:0px;color:white">
                                                    <b><%=code%></b>
                                                </TD>
                                                <TD STYLE="border:0px;color:white">
                                                    <b><%=name%></b>
                                                </TD>
                                                <TD STYLE="border:0px;color:white">
                                                    <b><%=count%></b>
                                                </TD>
                                                <TD STYLE="border:0px;color:white">
                                                    <b><%=price%></b>
                                                </TD>
                                                <TD STYLE="border:0px;color:white">
                                                    <b><%=cost%></b>
                                                </TD>
                                            </TR>
                                            <%
                                            for(int i = 0; i < actualItems.size(); i++){
        WebBusinessObject tempWbo = (WebBusinessObject) actualItems.get(i);
        if((i%2) == 1) {
            bgColor="#FFFFCC";
        } else {
            bgColor="#CCCC00";
        }
        if(((String) tempWbo.getAttribute("totalCost")) != null){
            Double iTemp = new Double(((String) tempWbo.getAttribute("totalCost")));
            iActualTotal = iActualTotal + iTemp.doubleValue();
        }
                                            %>
                                            <TR BGCOLOR="<%=bgColor%>">
                                                <TD STYLE="border:0px">
                                                    <%=(String) tempWbo.getAttribute("itemCode")%>
                                                </TD>
                                                <TD STYLE="border:0px">
                                                    <%=(String) tempWbo.getAttribute("itemDscrptn")%>
                                                </TD>
                                                <TD STYLE="border:0px">
                                                    <%=(String) tempWbo.getAttribute("itemQuantity")%>
                                                </TD>
                                                <TD STYLE="border:0px">
                                                    <%=(String) tempWbo.getAttribute("itemPrice")%>
                                                </TD>
                                                <TD STYLE="border:0px">
                                                    <%=(String) tempWbo.getAttribute("totalCost")%>
                                                </TD>
                                            </TR>
                                            <%
                                            }
                                            %>
                                        </TABLE>
                                    </TD>
                                    --%>
                                </TR>
                                <%--
                                <TR bgcolor="#808080">
                                    <TD STYLE="border:1px solid black;color:white" VALIGN="top">
                                        <b><%=ToCost%></b>
                                    </TD>
                                    <TD STYLE="border:1px solid black;color:white" width ="10%" VALIGN="top">
                                        <%=iConfigureTotal%>
                                    </TD>
                                    <TD STYLE="border:1px solid black;color:white" VALIGN="top">
                                        <b><%=ToCost%></b>
                                    </TD>
                                    <TD STYLE="border:1px solid black;color:white" width ="10%" VALIGN="top">
                                        <%=iQuantifiedTotal%>
                                    </TD>
                                    <TD STYLE="border:1px solid black;color:white" VALIGN="top">
                                        <b><%=ToCost%></b>
                                    </TD>
                                    <TD STYLE="border:1px solid black;color:white" width ="10%" VALIGN="top">
                                        <%=iActualTotal%>
                                    </TD>
                                </TR>
                                --%>
                            </table>
                        </TD>
                    </tr>
                </table>
                <br>
                <br>
            </fieldset>
        </FORM>
    </BODY>
</HTML>     
