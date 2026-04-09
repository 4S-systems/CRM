<%@page import="com.maintenance.db_access.MainCategoryTypeMgr"%>
<%@page import="com.maintenance.common.Tools"%>
<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*, com.tracker.common.*, java.util.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants"%>
<%@ page import="com.silkworm.common.TimeServices"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page pageEncoding="UTF-8"%>

<HTML>
    <%
        MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
        String context = metaDataMgr.getContext();
        TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

        String scheduleId = (String) request.getAttribute("scheduleId");
        String scheduleName = (String) request.getAttribute("scheduleName");
        String afterOrBefore = (String) request.getAttribute("afterOrBefore");
        MainCategoryTypeMgr mainCategoryTypeMgr=MainCategoryTypeMgr.getInstance();
        ArrayList mainCategories=mainCategoryTypeMgr.getCashedTableAsBusObjects();
        ProjectMgr projMgr = ProjectMgr.getInstance();
        ArrayList siteList=projMgr.getCashedTableAsBusObjects();
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
        String lang, langCode, sTitle, sCancel, sOk, sScheduleName, exportReport, before, mainCatName,select,name;
        String site,allSelect, printStr;
        
        if (stat.equals("En")) {
            align = "left";
            dir = "LTR";
            style = "text-align:left";
            lang = "   &#1593;&#1585;&#1576;&#1610;    ";
            sTitle = "Compute Difference Reading";
            sCancel = "Cancel";
            sOk = "Search";
            langCode = "Ar";
            sScheduleName = "Schedule Name";
            exportReport = "Export Report";
            before = "Before";
            mainCatName = "Main category";
            select="Select";
            name = "Equipment Name";
            site="Site";
            allSelect="All";
            printStr = "Print";
            
        } else {
            align = "right";
            dir = "RTL";
            style = "text-align:Right";
            lang = "English";
            sTitle = "&#1581;&#1587;&#1600;&#1600;&#1575;&#1576; &#1575;&#1604;&#1601;&#1600;&#1600;&#1585;&#1602; &#1601;&#1609; &#1575;&#1604;&#1602;&#1600;&#1600;&#1585;&#1575;&#1569;&#1575;&#1578;";
            sCancel = tGuide.getMessage("cancel");
            sOk = "&#1576;&#1581;&#1579;";
            langCode = "En";
            sScheduleName = "&#1575;&#1587;&#1600;&#1600;&#1605; &#1580;&#1600;&#1600;&#1583;&#1608;&#1604; &#1575;&#1604;&#1589;&#1610;&#1600;&#1600;&#1575;&#1606;&#1577;";
            exportReport = "&#1573;&#1587;&#1578;&#1582;&#1600;&#1600;&#1585;&#1580; &#1575;&#1604;&#1578;&#1602;&#1600;&#1600;&#1585;&#1610;&#1585;";
            before = "&ensp;&#1602;&#1576;&#1600;&#1600;&#1604;";
            mainCatName = "&#1575;&#1604;&#1606;&#1608;&#1593; &#1575;&#1604;&#1571;&#1587;&#1575;&#1587;&#1609;";
            select="&#1573;&#1582;&#1578;&#1575;&#1585;";
            name = " &#1575;&#1587;&#1605; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607; ";
            site="&#1575;&#1604;&#1605;&#1608;&#1602;&#1593;";
            allSelect="&#1575;&#1604;&#1603;&#1604;";
            printStr = "طباعة";
        }
    %>

    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Doc Viewer- Select Project and Status</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <link rel="stylesheet" type="text/css" href="css/headers.css" />
        <script src='ChangeLang.js' type='text/javascript'></script>
    </HEAD>
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
        function submitForm() {
            var searchAll = "no";
           
            if((document.getElementById('mainCatId').value==null
                ||document.getElementById('mainCatId').value == '') 
                &&
                (document.getElementById('unitId').value ==null
                || document.getElementById('unitId').value == "")){
                
                alert("Please Select main category Or equipment");
                document.getElementById('mainCatId').focus();
                return;
            }
            
            var mainCatId = document.getElementById('mainCatId').value;
            var scheduleId = document.getElementById('scheduleId').value;
            var scheduleName = document.getElementById('scheduleName').value;
            scheduleName = getASSCIChar(scheduleName);
            var url = "<%=context%>/AverageUnitServlet?op=resaultScheduleReadingReport&mainCatId="+mainCatId+"&scheduleId=" + scheduleId + "&scheduleName=" + scheduleName +"&searchAll=" + searchAll;
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
            document.REPORT_FORM.action = "<%=context%>/ReportsServletThree?op=reportOperations";
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
            openWindowTasks('ReportsServlet?op=listEquipment&unitName='+res+'&formName='+formName+'&typeRate=all');
        }
        function selectType(){
            if(document.getElementById('main').checked==true){
                document.getElementById('mainCatId').disabled=false;
                document.getElementById('siteId').disabled=false;
                document.getElementById('unitName').disabled=true;
                document.getElementById('equipSearch').disabled=true;
            }else if(document.getElementById('equip').checked==true){
                document.getElementById('unitName').disabled=false;
                document.getElementById('equipSearch').disabled=false;
                document.getElementById('mainCatId').disabled=true;
                document.getElementById('siteId').disabled=true;
            }
        }
        
        function exportReport() {
            
            var searchAll = "no";
           
            if((document.getElementById('mainCatId').value==null
                ||document.getElementById('mainCatId').value == '') 
                &&
                (document.getElementById('unitId').value ==null
                || document.getElementById('unitId').value == "")){
                
                alert("Please Select main category Or equipment");
                document.getElementById('mainCatId').focus();
                return;
            }
            
            var mainCatId = document.getElementById('mainCatId').value;
            var scheduleId = document.getElementById('scheduleId').value;
            var scheduleName = document.getElementById('scheduleName').value;
            scheduleName = getASSCIChar(scheduleName);
            var url = "<%=context%>/PDFReportServlet?op=equipmentReadings&mainCatId="+mainCatId+"&scheduleId=" + scheduleId + "&scheduleName=" + scheduleName +"&searchAll=" + searchAll;
            
            open_Window('');
            document.REPORT_FORM.target = "window_chaild";
            document.REPORT_FORM.action = url;
            document.REPORT_FORM.submit();
            
        }
        
        function open_Window(url)
        {
            var openedWindow = window.open(url,"window_chaild","toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width=850, height=400");
            openedWindow.focus();

        }
            
    </SCRIPT>
    <BODY>
        <FORM action="" id="REPORT_FORM"  NAME="REPORT_FORM" METHOD="POST">
            <DIV align="left" STYLE="color:blue;padding-left: 2.5%; padding-bottom: 10px">
                <button onclick="JavaScript: cancelForm();" class="button"><%=sCancel%></button>
                &ensp;
                <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
                &ensp;
                <input type="button" value="<%=printStr%>" onclick="exportReport();" class="button">
            </DIV>
            <center>
                <FIELDSET class="set" style="width:95%;border-color: #006699;" >
                    <TABLE class="blueBorder" align="center" width="100%" cellpadding="0" cellspacing="0" style="border-color: #006699;">
                        <TR>
                            <TD dir="<%=dir%>" style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD"><font color="#F3D596" size="4"><%=sTitle%></font></TD>
                        </TR>
                    </TABLE>
                    <br>
                    <TABLE ID="tableSearch"  ALIGN="center" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="3" width="70%" style="height: 100%">
                        <TR>
                            <TD CLASS="backgroundTable" STYLE="text-align:<%=align%>; padding-<%=align%>: 10px; color: black; font-size:15px; height: 40px; font-weight: bold" width="25%">
                                <b><%=mainCatName%></b>   
                            </TD>
                             <TD nowrap CLASS="backgroundTable" width="1%">
                                 <input type="radio" name="select" id="main" checked="" onclick="selectType();"/> 
                             </TD>
                            <TD STYLE="text-align:center;color: black;font-size:15px;background-color: #EDEDED" class='td' id="CellData">           
                                <SELECT name="mainCatId" ID="mainCatId" STYLE="width:233;" >
                                            <option value=""><%=select%></option>
                                            <option value="all"><%=allSelect%></option>
                                            <sw:WBOOptionList wboList='<%=mainCategories%>' displayAttribute = "typeName" valueAttribute="id"/>
                                        </SELECT>
                            </TD>
                            
                        </TR>
                        <TR>
                            <TD CLASS="backgroundTable" STYLE="text-align:<%=align%>; padding-<%=align%>: 10px; color: black; font-size:15px; height: 40px; font-weight: bold" width="25%">
                                <b><%=site%></b>
                            </TD>
                             <TD nowrap CLASS="backgroundTable" width="1%">
                                 &nbsp;
                             </TD>
                            <TD STYLE="text-align:center;color: black;font-size:15px;background-color: #EDEDED" class='td' id="CellData">
                                <SELECT name="siteId" ID="siteId" STYLE="width:233;" >
                                            <option value=""><%=select%></option>
                                            <sw:WBOOptionList wboList='<%=siteList%>' displayAttribute = "projectName" valueAttribute="projectID"/>
                                        </SELECT>
                            </TD>

                        </TR>
                        <TR>
                            <TD CLASS="backgroundTable" STYLE="text-align:<%=align%>; padding-<%=align%>: 10px; color: black; font-size:15px; height: 40px; font-weight: bold" width="25%">
                                <b><%=sScheduleName%></b>     
                            </TD>
                            <TD nowrap CLASS="backgroundTable" width="1%"> 
                                &nbsp;
                            </TD>
                            <TD STYLE="text-align:center;color: black;font-size:15px;background-color: #EDEDED" width="75%" colspan="2">
                                
                                <input type="text" dir="<%=dir%>" value="" name="scheduleName" ID="scheduleName" size="30" onchange="JavaScript: inputChange('scheduleId');" STYLE="text-align:<%=align%>; padding-<%=align%>: 10px; color: black; font-size:12px; width: 88%; font-weight: bold">
                                <input type="hidden" name="scheduleId" ID="scheduleId" value="<%=scheduleId%>">
                                <input type="button" id="btnSearch" value="<%=sOk%>" style="text-align:center;font-size:14px;font-weight: bold;width: 9%" ONCLICK="JavaScript: getSchedule();">
                            </TD>
                            </TR>
                        <TR>
                           <TD width="30%" title="<%=name%>" STYLE="<%=style%>; padding-<%=align%>: 10px; font-size: 16px; font-weight: bold; color: black" class="backgroundTable excelentCell">
                                  <b><%=name%></b>
                           </TD>
                           <TD nowrap CLASS="backgroundTable" width="1%"> 
                               <input type="radio" name="select" id="equip" onclick="selectType();" />
                            </TD>
                               <TD STYLE="text-align:center;color: black;font-size:15px;background-color: #EDEDED" width="75%" colspan="2">
                                   <input disabled="" type="text" dir="<%=dir%>" value="" name="unitName" ID="unitName" size="30" onchange="JavaScript: inputChange('unitId');" STYLE="text-align:<%=align%>; padding-<%=align%>: 10px; color: black; font-size:12px; width: 88%; font-weight: bold">
                                <input type="hidden" name="unitId" id="unitId" value="" />
                                <input disabled="" type="button" id="equipSearch" value="<%=sOk%>" style="text-align:center;font-size:14px;font-weight: bold;width: 9%" ONCLICK="JavaScript: getEquipments();">
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
