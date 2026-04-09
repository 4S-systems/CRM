
<%@page import="com.silkworm.international.TouristGuide"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<HTML>
    <%
        MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
        String context = metaDataMgr.getContext();
        TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

        String scheduleId = (String) request.getAttribute("scheduleId");
        String scheduleName = (String) request.getAttribute("scheduleName");
        String afterOrBefore = (String) request.getAttribute("afterOrBefore");

        if (scheduleId == null) {
            scheduleId = "";
        }
        if (scheduleName == null) {
            scheduleName = "";
        }
        if (afterOrBefore == null) {
            afterOrBefore = "0";
        }

        String stat = (String) request.getSession().getAttribute("currentMode");
        String align = null;
        String dir = null;
        String style = null;
        String lang, langCode, sTitle, sCancel, sOk, sScheduleName, exportReport, before, unitName, after;
        if (stat.equals("En")) {
            align = "left";
            dir = "LTR";
            style = "text-align:left";
            lang = "   &#1593;&#1585;&#1576;&#1610;    ";
            sTitle = "Get Schedule Before Deserve Report";
            sCancel = "Cancel";
            sOk = "Search";
            langCode = "Ar";
            sScheduleName = "Schedule Name";
            exportReport = "Export Report";
            before = "Before";
            unitName = "Unit Name";
            after = "After";
        } else {
            align = "right";
            dir = "RTL";
            style = "text-align:Right";
            lang = "English";
            sTitle = "&#1578;&#1602;&#1585;&#1610;&#1585; &#1575;&#1604;&#1580;&#1583;&#1575;&#1608;&#1604; &#1575;&#1604;&#1608;&#1575;&#1580;&#1576; &#1578;&#1606;&#1601;&#1610;&#1584;&#1607;&#1575;";
            sCancel = tGuide.getMessage("cancel");
            sOk = "&#1576;&#1581;&#1579;";
            langCode = "En";
            sScheduleName = "&#1575;&#1587;&#1600;&#1600;&#1605; &#1580;&#1600;&#1600;&#1583;&#1608;&#1604; &#1575;&#1604;&#1589;&#1610;&#1600;&#1600;&#1575;&#1606;&#1577;";
            exportReport = "&#1573;&#1587;&#1578;&#1582;&#1600;&#1600;&#1585;&#1580; &#1575;&#1604;&#1578;&#1602;&#1600;&#1600;&#1585;&#1610;&#1585;";
            before = " &#1602;&#1576;&#1600;&#1600;&#1604;";
            unitName = "&#1571;&#1587;&#1605; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577;";
            after = " &#1576;&#1593;&#1583;";
        }
    %>

    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Doc Viewer- Select Project and Status</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <link rel="stylesheet" type="text/css" href="css/headers.css" />
        <script src='ChangeLang.js' type='text/javascript'></script>
        <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
            function submitForm() {
                var searchAll = "no";
                if(document.getElementById('scheduleId').value == "" && document.getElementById('unitId').value == "") {
                    alert("Please Select Schedule or unit");
                    return;
                }
                if(!IsNumeric(document.getElementById('deserveBefore').value) || document.getElementById('deserveBefore').value == "" ){
                    alert("Please Enter Valid Number");
                    document.getElementById('deserveBefore').focus();
                    return;
                }
            
                var scheduleId = document.getElementById('scheduleId').value;
                var scheduleName = document.getElementById('scheduleName').value;
                scheduleName = getASSCIChar(scheduleName);
                var url = "<%=context%>/ReportsServletThree?op=resaultScheduleBeforeOrAfterTime&scheduleId=" + scheduleId + "&scheduleName=" + scheduleName + "&searchAll=" + searchAll;
                document.REPORT_FORM.action = url;
                document.REPORT_FORM.submit();
            }
        
            function getSchedule() {
                var formName = document.getElementById('REPORT_FORM').getAttribute("name");
                var scheduleName = document.getElementById('scheduleName').value;
                scheduleName = getASSCIChar(scheduleName);
                openWindowTasks('SelectiveServlet?op=listSchedules&scheduleName=' + scheduleName + '&scheduleOn=all&formName=' + formName);
            }

            function cancelForm() {
                document.REPORT_FORM.action = "<%=context%>/ReportsServletThree?op=operationReports";
                document.REPORT_FORM.submit();
            }
        
            function inputChange(id) {
                document.getElementById(id).value = "";
            }

            function openWindowTasks(url) {
                openCustomDialog(url, "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width=800, height=400");
            }
        
            function getEquipments()
            {
                var formName = document.getElementById('REPORT_FORM').getAttribute("name");
                var name = document.getElementById('unitName').value
                var res = ""
                for (i=0;i < name.length; i++) {
                    res += name.charCodeAt(i) + ',';
                }
                res = res.substr(0, res.length - 1);
                openWindowTasks('SelectiveServlet?op=listEquipmentsAndViewEquipment&unitName=' + res + '&formName=' + formName);
            }
        </SCRIPT>
    </HEAD>
    <BODY>
        <FORM action="" id="REPORT_FORM"  NAME="REPORT_FORM" METHOD="POST">
            <DIV align="left" STYLE="color:blue;padding-left: 2.5%; padding-bottom: 10px">
                <button onclick="JavaScript: cancelForm();" class="button"><%=sCancel%></button>
                &ensp;
                <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
            </DIV>
            <center>
                <FIELDSET class="set" style="width:95%;border-color: #006699;" >
                    <TABLE class="blueBorder" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                        <TR>
                            <TD dir="<%=dir%>" style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD"><font color="#F3D596" size="4"><%=sTitle%></font></TD>
                        </TR>
                    </TABLE>
                    <br>
                    <TABLE ID="tableSearch"  ALIGN="center" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="3" width="70%" style="height: 100%">
                        <TR>
                            <TD CLASS="backgroundTable" STYLE="text-align:<%=align%>; padding-<%=align%>: 10px; color: black; font-size:15px; height: 40px; font-weight: bold" width="25%">
                                <b><%=sScheduleName%></b>
                            </TD>
                            <TD STYLE="text-align:center;color: black;font-size:15px;background-color: #EDEDED" width="75%" colspan="2">
                                <input type="text" dir="<%=dir%>" value="" name="scheduleName" ID="scheduleName" size="30" onchange="JavaScript: inputChange('scheduleId');" STYLE="text-align:<%=align%>; padding-<%=align%>: 10px; color: black; font-size:12px; width: 88%; font-weight: bold">
                                <input type="hidden" name="scheduleId" ID="scheduleId" value="<%=scheduleId%>">
                                <input type="button" id="btnSearch" value="<%=sOk%>" style="text-align:center;font-size:14px;font-weight: bold;width: 9%" ONCLICK="JavaScript: getSchedule();">
                            </TD>
                        </TR>
                        <TR>
                            <TD CLASS="backgroundTable" STYLE="text-align:<%=align%>; padding-<%=align%>: 10px; color: black; font-size:15px; height: 40px; font-weight: bold" width="25%">
                                <b><%=unitName%></b>
                            </TD>
                            <TD STYLE="text-align:center;color: black;font-size:15px;background-color: #EDEDED" width="75%" colspan="2">
                                <input type="text" dir="<%=dir%>" value="" name="unitName" ID="unitName" size="30" onchange="JavaScript: inputChange('unitId');" STYLE="text-align:<%=align%>; padding-<%=align%>: 10px; color: black; font-size:12px; width: 88%; font-weight: bold">
                                <input type="hidden" name="unitId" id="unitId" value="" />
                                <input type="button" id="btnSearch" value="<%=sOk%>" style="text-align:center;font-size:14px;font-weight: bold;width: 9%" ONCLICK="JavaScript: getEquipments();">
                            </TD>
                        </TR>
                        <TR>
                            <TD STYLE="border: none" width="80%" colspan="2">
                                &ensp;
                            </TD>
                            <TD CLASS="backgroundTable" STYLE="text-align:<%=align%>; padding-<%=align%>: 10px; color: black; font-size:15px; height: 40px; font-weight: bold" width="40%">
                                <table width="100%" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td style="border: none; text-align:<%=align%>; padding-<%=align%>: 10px; color: black; font-size:15px; font-weight: bold" width="30%">
                                            <input type="radio" name="interval" value="before" checked /><%=before%>
                                            <input type="radio" name="interval" value="after" /><%=after%>
                                        </td>
                                        <td style="border: none; text-align:center; color: black; font-size:15px; font-weight: bold" width="70%">
                                            <input type="text" dir="<%=dir%>" value="<%=afterOrBefore%>" name="deserveBefore" ID="deserveBefore" STYLE="text-align:center; color: black; font-size:12px; width: 100%; font-weight: bold; vertical-align: middle" />
                                        </td>
                                    </tr>
                                </table>
                            </TD>
                        </TR>
                        <TR>
                            <TD STYLE="border: none" width="80%" colspan="2">
                                &ensp;
                            </TD>
                            <TD STYLE="text-align:center;color: black;font-size:15px;background-color: #EDEDED; height: 40px" width="40%">
                                <input type="button" id="btnExportReport" value="<%=exportReport%>" style="text-align:center;font-size:14px;font-weight: bold;width: 85%" ONCLICK="JavaScript: submitForm()">
                            </TD>
                        </TR>
                    </TABLE>
                    <br>
                </FIELDSET>
            </center>
        </FORM>
    </BODY>
</HTML>
