<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*,com.tracker.app_constants.*, com.tracker.common.*, java.util.*"%>
<%@ page import="com.maintenance.common.ConfigFileMgr" %>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants"%>
<%@ page import="com.silkworm.common.TimeServices,com.silkworm.jsptags.*,com.contractor.db_access.MaintainableMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page pageEncoding="UTF-8"%>
<HTML>

    <%
                TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
                MetaDataMgr metaMgr = MetaDataMgr.getInstance();
                String context = metaMgr.getContext();

                // get all need data
                Vector allSites = (Vector) request.getAttribute("allSites");
                ArrayList allTrade = (ArrayList) request.getAttribute("allTrade");
                ArrayList parents = (ArrayList) request.getAttribute("parents");

                //get session logged user and his trades
                WebBusinessObject user = (WebBusinessObject) session.getAttribute("loggedUser");

                // get current date
                Calendar cal = Calendar.getInstance();
                String jDateFormat = user.getAttribute("javaDateFormat").toString();
                SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
                String nowTime = sdf.format(cal.getTime());

                String cMode = (String) request.getSession().getAttribute("currentMode");
                String stat = cMode;

                String lang, langCode, dir, back, align, item, beginDate, task, endDate, search, cancel, calenderTip, tradeName, nameEquip, mainType, site,
                        status, assigned, canceled, closed, emrgancy, notEmergancy, title, selectAll, select, others, fMaintNum, tMaintNum, fromMaintTo, maintenance, brand,
                        ASCLabel, DESCLabel, actualBeginDateLabel, actualEndDateLabel, issueTitleLabel, currentStausLabel, orderByLabel, dateTypeLabel, moreOptionsLabel;

                String compareDateMsg, beginDateMsg, endDateMsg;
                String defSite;
                String selectByCode, selectByName;
                if (stat.equals("En")) {
                    lang = "   &#1593;&#1585;&#1576;&#1610;    ";
                    langCode = "Ar";
                    back = "Back";
                    align = "left";
                    dir = "LTR";
                    task = "Task";
                    item = "Item";
                    beginDate = "From Date";
                    endDate = "To Date";
                    search = "Export Report";
                    cancel = "Cancel";
                    calenderTip = "click inside text box to opn calender window";
                    tradeName = "Maintenance Type";
                    nameEquip = "By Equipment";
                    site = "Site";
                    mainType = "By Main Type";
                    brand = "Brand";
                    maintenance = "Maintenance";
                    emrgancy = "Emergency";
                    notEmergancy = "Periodic";
                    closed = "Closed";
                    canceled = "Canceled";
                    assigned = "In Progress";
                    title = "Follow-up Maintenance Items Report";
                    selectAll = "All";
                    select = "Select";
                    others = "Advanced Search";
                    fMaintNum = "From";
                    tMaintNum = "To";
                    fromMaintTo = "From Maint Num To Maint Num";
                    status = "Status";
                    ASCLabel = "ASC";
                    DESCLabel = "DESC";
                    actualBeginDateLabel = "Begin Date";
                    actualEndDateLabel = "End Date";
                    issueTitleLabel = "Issue Title";
                    currentStausLabel = "Current Status";
                    orderByLabel = "Order By";
                    dateTypeLabel = "Date Type";
                    moreOptionsLabel = "More Options";

                    compareDateMsg = "End Actual End Date must be greater than or equal start actual Begin Date";
                    endDateMsg = "End Actual End Date must be less than or equal today Date";
                    beginDateMsg = "Strat Actual Begin Date must be less than or equal today Date";
                    defSite = "Default Site";
                    selectByCode = "Select By Code";
                    selectByName = "Select By Name";

                } else {
                    lang = "English";
                    langCode = "En";
                    back = "&#1585;&#1580;&#1608;&#1593;";
                    align = "right";
                    dir = "RTL";
                    task = "&#1576;&#1606;&#1583; &#1589;&#1610;&#1575;&#1606;&#1577;";
                    item = "&#1602;&#1591;&#1593; &#1594;&#1610;&#1575;&#1585;";
                    beginDate = "&#1605;&#1606; &#1578;&#1575;&#1585;&#1610;&#1582;";
                    endDate = "&#1575;&#1604;&#1609; &#1578;&#1575;&#1585;&#1610;&#1582;";
                    search = "&#1575;&#1587;&#1578;&#1582;&#1585;&#1575;&#1580; &#1575;&#1604;&#1578;&#1602;&#1585;&#1610;&#1585;";
                    calenderTip = "&#1575;&#1590;&#1594;&#1591; &#1583;&#1575;&#1582;&#1604; &#1575;&#1604;&#1605;&#1587;&#1578;&#1591;&#1610;&#1604; &#1604;&#1603;&#1609; &#1610;&#1592;&#1607;&#1585; &#1604;&#1603; &#1606;&#1575;&#1601;&#1584;&#1607; &#1604;&#1571;&#1582;&#1578;&#1610;&#1575;&#1585; &#1575;&#1604;&#1578;&#1575;&#1585;&#1610;&#1582;";
                    cancel = tGuide.getMessage("cancel");
                    tradeName = "&#1606;&#1608;&#1593; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
                    mainType = "&#1576;&#1600;&#1600;&#1600; &#1575;&#1604;&#1606;&#1600;&#1600;&#1608;&#1593; &#1585;&#1574;&#1610;&#1600;&#1600;&#1587;&#1609;";
                    brand = "الماركة";
                    nameEquip = "&#1576;&#1600;&#1600;&#1600; &#1575;&#1604;&#1605;&#1600;&#1600;&#1600;&#1600;&#1593;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1583;&#1577;";
                    site = "&#1575;&#1604;&#1605;&#1608;&#1602;&#1593;";
                    maintenance = "&#1589;&#1610;&#1575;&#1606;&#1577;";
                    emrgancy = "&#1591;&#1575;&#1585;&#1574;&#1577;";
                    notEmergancy = "&#1583;&#1608;&#1585;&#1610;&#1577;";
                    assigned = "&#1578;&#1581;&#1578; &#1575;&#1604;&#1578;&#1606;&#1601;&#1610;&#1584;";
                    closed = "&#1578;&#1605; &#1575;&#1594;&#1604;&#1575;&#1602;&#1577;";
                    canceled = "&#1578;&#1605; &#1575;&#1604;&#1594;&#1575;&#1569;&#1607;";
                    selectAll = "&#1603;&#1600;&#1600;&#1600;&#1604;";
                    select = "&#1575;&#1582;&#1600;&#1578;&#1600;&#1575;&#1585;";
                    title = "تقرير متابعة بنود الصيانة";
                    others = "&#1576;&#1581;&#1600;&#1600;&#1579; &#1605;&#1600;&#1578;&#1600;&#1602;&#1600;&#1583;&#1605;";
                    fMaintNum = "&#1605;&#1606;";
                    tMaintNum = "&#1575;&#1604;&#1609;";
                    fromMaintTo = "&#1605;&#1606; &#1585;&#1602;&#1605; &#1589;&#1610;&#1575;&#1606;&#1577; &#1575;&#1604;&#1609; &#1585;&#1602;&#1605; &#1589;&#1610;&#1575;&#1606;&#1577;";
                    status = "&#1575;&#1604;&#1581;&#1600;&#1575;&#1604;&#1600;&#1577;";
                    ASCLabel = "&#1578;&#1589;&#1575;&#1593;&#1583;&#1610;";
                    DESCLabel = "&#1578;&#1606;&#1575;&#1586;&#1604;&#1610;";
                    actualBeginDateLabel = "&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1576;&#1583;&#1569; &#1575;&#1604;&#1601;&#1593;&#1604;&#1610;";
                    actualEndDateLabel = "&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1573;&#1606;&#1578;&#1607;&#1575;&#1569; &#1575;&#1604;&#1601;&#1593;&#1604;&#1610;";
                    issueTitleLabel = "&#1593;&#1606;&#1608;&#1575;&#1606; &#1575;&#1604;&#1605;&#1588;&#1603;&#1604;&#1577;";
                    currentStausLabel = "&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
                    orderByLabel = "&#1606;&#1608;&#1593; &#1575;&#1604;&#1578;&#1585;&#1578;&#1610;&#1576;";
                    dateTypeLabel = "&#1606;&#1608;&#1593; &#1575;&#1604;&#1578;&#1575;&#1585;&#1610;&#1582;";
                    moreOptionsLabel = "&#1578;&#1601;&#1575;&#1589;&#1610;&#1604; &#1571;&#1582;&#1585;&#1610;";

                    compareDateMsg = " \u0646\u0647\u0627\u064A\u0629 \u062A\u0627\u0631\u064A\u062E \u0627\u0644\u0628\u062F\u0621 \u0627\u0644\u0641\u0639\u0644\u064A \u064A\u062C\u0628 \u0623\u0646 \u064A\u0643\u0648\u0646 \u0623\u0643\u0628\u0631 \u0645\u0646 \u0623\u0648 \u064A\u0633\u0627\u0648\u064A \u0628\u062F\u0627\u064A\u0629 \u062A\u0627\u0631\u064A\u062E \u0627\u0644\u0628\u062F\u0621 \u0627\u0644\u0641\u0639\u0644\u064A";
                    endDateMsg = "\u0646\u0647\u0627\u064A\u0629 \u062A\u0627\u0631\u064A\u062E \u0627\u0644\u0628\u062F\u0621 \u0627\u0644\u0641\u0639\u0644\u064A \u064A\u062C\u0628 \u0623\u0646 \u064A\u0643\u0648\u0646 \u0623\u0642\u0644 \u0645\u0646 \u0623\u0648 \u064A\u0633\u0627\u0648\u064A \u062A\u0627\u0631\u064A\u062E \u0627\u0644\u064A\u0648\u0645";
                    beginDateMsg = "\u0628\u062F\u0627\u064A\u0629 \u062A\u0627\u0631\u064A\u062E \u0627\u0644\u0628\u062F\u0621 \u0627\u0644\u0641\u0639\u0644\u064A \u064A\u062C\u0628 \u0623\u0646 \u064A\u0643\u0648\u0646 \u0623\u0642\u0644 \u0645\u0646 \u0623\u0648 \u064A\u0633\u0627\u0648\u064A \u062A\u0627\u0631\u064A\u062E \u0627\u0644\u064A\u0648\u0645";
                    defSite = "&#1575;&#1604;&#1605;&#1608;&#1602;&#1593; &#1575;&#1604;&#1573;&#1601;&#1578;&#1585;&#1575;&#1590;&#1610;";
                    selectByCode = "بحث بالكود";
                    selectByName = "بحث بالإسم";
                }
                // get current defaultLocationName
                String defaultLocationName = (String) request.getAttribute("defaultLocationName");
    %>

    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Doc Viewer- Select Project and Status</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/CSS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/Button.css">
        <link rel="stylesheet" type="text/css" href="css/epoch_styles.css" />
        <link rel="stylesheet" type="text/css" href="css/tree_css.css" />
        <script type="text/javascript" src="js/getEquipmentsList.js"></script>
        <script type="text/javascript" src="js/epoch_classes.js"></script>
        <script src='ChangeLang.js' type='text/javascript'></script>
        <script type="text/javascript" src="js/common.js"></script>
        <script type="text/javascript" src="js/silkworm_validate.js"></script>
        <script type="text/javascript" src="js/getEquipmentsList.js"></script>
        <script type="text/javascript" src="js/tree_docs_js.js"></script>

        <script type="text/javascript">
            var mainTypeAll = "no";
            var siteAll = "no";
            var brandAll = "no";
            var tradeAll = "no";
            var dp_cal1 = null;
            var dp_cal2 = null;
            var chaild_window;
            var sitesValues = "";
            window.onload = function (){
                if(dp_cal1 == null && dp_cal2 == null) {
                    dp_cal1  = new Epoch('epoch_popup','popup',document.getElementById('beginDate'));
                    dp_cal2  = new Epoch('epoch_popup','popup',document.getElementById('endDate'));
                }
            }
            function submitForm()
            {

                var unitId = document.getElementById("unitId").value;
                if(Date.parse(document.getElementById("beginDate").value) > Date.parse('<%=nowTime%>')){
                    alert('<%=beginDateMsg%>');
                    document.SEARCH_MAINTENANCE_FORM.beginDate.focus();
                    return false;
                } else if(Date.parse(document.getElementById("endDate").value) > Date.parse('<%=nowTime%>')){
                    alert('<%=endDateMsg%>');
                    document.SEARCH_MAINTENANCE_FORM.endDate.focus();
                    return false;
                } else if (!compareDate()){
                    alert('<%=compareDateMsg%>');
                    document.SEARCH_MAINTENANCE_FORM.endDate.focus();
                    return false;
                } else if(document.getElementById('taskId').value == ""){
                    alert("Must Select Task");
                    document.SEARCH_MAINTENANCE_FORM.taskName.focus();
                    return false;
                } else if(document.getElementById('unit').checked && unitId == ""){
                    alert("Must Select Equipment");
                    document.SEARCH_MAINTENANCE_FORM.unitName.focus();
                    return false;
                } else if (document.getElementById('site').value == "") {
                    alert("Please Select Site");
                    document.SEARCH_MAINTENANCE_FORM.site.foucs();
                    return false;
                } else if(document.getElementById('brandRadio').checked && document.getElementById('brand').value == "") {
                    alert("Please Select Brand");
                    document.SEARCH_MAINTENANCE_FORM.brand.focus();
                    return false;
                } else {
                    var anyChecked = false;
                    var elements = document.getElementsByName('currenStatus');
                    for(var i=0;i<elements.length;i++){
                        if(elements[i].checked == true){
                            anyChecked = true;
                        }
                    }
                    if(anyChecked == false){
                        alert("Please Select Issue Status");
                        return;
                    }
                }

                var unit = document.getElementById('unit');
                var searchBy = 'model';

                if(unit.checked == true){
                    searchBy = 'unit';
                } else {
                    searchBy = 'model';
                }
                document.SEARCH_MAINTENANCE_FORM.action = "PDFReportServlet?op=followUpReportMaintenanceItemsResult&siteAll=" + siteAll + "&brandAll=" + brandAll + "&searchBy=" + searchBy ;

                openCustom('');
                document.SEARCH_MAINTENANCE_FORM.target = "window_chaild";
                document.SEARCH_MAINTENANCE_FORM.submit();
            }

            function showHide(id){
                var divUnit = document.getElementById('divUnit');
                var divBrand = document.getElementById('divBrand');
                if(id == 'mainTypeRadio') {
                    divUnit.style.display = "none";
                    divBrand.style.display = "none";
                } else if(id == 'brandRadio') {
                    divBrand.style.display = "block";
                    divUnit.style.display = "none";
                } else {
                    divUnit.style.display = "block";
                    divBrand.style.display = "none";
                }
                dp_cal1  = new Epoch('epoch_popup','popup',document.getElementById('beginDate'));
                dp_cal2  = new Epoch('epoch_popup','popup',document.getElementById('endDate'));
            }
        </script>

    </HEAD>

    <BODY STYLE="background-color:#E8E8E8">
        <script type="text/javascript" src="js/wz_tooltip.js"></script>
        <script type="text/javascript" src="js/tip_centerwindow.js"></script>
        <script type="text/javascript" src="js/tip_balloon.js"></script>
        <script type="text/javascript" src="js/tip_followscroll.js"></script>
        <FORM action=""  NAME="SEARCH_MAINTENANCE_FORM" METHOD="POST">
            <input type="hidden" name="search" value="search" />
            <DIV DIR="LTR" style="padding-left: 2.5%; padding-bottom: 10px" >
                <input type="button" style="font-size:15px;font-weight:bold"  value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
                &ensp;
                <button onclick="JavaScript:back('<%=context%>');" class="button" style="font-size:15px;font-weight:bold"><%=back%></button>
            </DIV>
            <CENTER>
                <FIELDSET class="set" style="width:95%;border-color: #006699;" >
                    <TABLE class="blueBorder" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                        <TR>
                            <TD dir="<%=dir%>" style="text-align:center;border-color: #006699;background-color: #ffcc66;" width="100%" class="blueBorder blueHeaderTD"><font color="#006699" size="4"><%=title%></font></TD>
                        </TR>
                    </TABLE>
                    <TABLE id="Others" ALIGN="center" DIR="<%=dir%>" WIDTH="90%" CELLSPACING=5 CELLPADDING=0 BORDER="0" style="display: block;">
                        <TR>
                            <TD CLASS="backStyle" style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" valign="MIDDLE" COLSPAN="5" >
                                &ensp;
                            </TD>
                        </TR>

                        <TR>
                            <TD CLASS="backStyle" style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" valign="MIDDLE" WIDTH="2%">
                                &ensp;
                            </TD>
                            <TD class="backgroundHeader" STYLE="text-align:center;padding:5px" WIDTH="13%">
                                <b><font size=3 color="black"><%=task%></font></b>
                            </TD>
                            <TD style="text-align:center;font:bold 15px;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" valign="MIDDLE" >
                                <input type="text" name="taskName" id="taskName" onchange="JavaScript:textChange('taskId')" style="width:77%;text-align:center" />
                                <input type="button" name="search" id="search" class="button" value="<%=select%>" onclick="return getDataInPopup('ReportsServlet?op=listTasks' + '&fieldName=TASK_NAME&fieldValue=' + getASSCIChar(document.getElementById('taskName').value) + '&formName=SEARCH_MAINTENANCE_FORM');" STYLE="height: 25px;font-size:15px;color:black;font-weight:bold;width:60px" />
                                <input type="hidden" name="taskId" id="taskId" />
                            </TD>
                            <TD class="backgroundHeader" ROWSPAN="2" STYLE="text-align:center;padding:5px" WIDTH="17%">
                                <b><font size=3 color="black"><%=site%></font></b>
                            </TD>
                            <TD ROWSPAN="2"STYLE="border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px;text-align:center;padding:5px" WIDTH="33%">
                                <input type="hidden" id="siteAll" value="no" name="siteAll" />
                                <div id='projectScroll' style="width:100%; height: 200px; overflow:auto;">
                                    <jsp:include page="/docs/new_search/project_checkbox_list.jsp" flush="true"/>
                                </div>
                            </TD>
                        </TR>
                        <TR>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" valign="MIDDLE" WIDTH="2%">
                                &ensp;
                            </TD>
                            <%--<TD class="backgroundHeader" STYLE="text-align:center;padding:5px" WIDTH="13%">
                                <b><font size=3 color="black"><%=tradeName%></font></b>
                            </TD>
                            <TD STYLE="border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px;text-align:center;padding:3px" WIDTH="35%">
                                <input type="hidden" id="tradeAll" name="tradeAll" value="no" />
                                <select name="trade" id="trade" onchange="selectAllElements(this.id,'tradeAll');" multiple size="3" style="font-size:12px;font-weight:bold;width:100%">
                                    <option value="selectAll" style="color:#989898" ><%=selectAll%></option>
                                    <sw:WBOOptionList wboList="<%=allTrade%>" displayAttribute="tradeName" valueAttribute="tradeId" />
                                </select>
                            </TD>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" valign="MIDDLE" COLSPAN="2" >
                                &ensp;
                            </TD>
                        </TR>
                        <TR>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" valign="MIDDLE" WIDTH="2%">
                                &ensp;
                            </TD>--%>
                            <TD class="backgroundHeader" STYLE="text-align:center;padding:5px" WIDTH="17%">
                                <b><font size=3 color="black"><input type="radio" checked id="brandRadio" value="brand" name="selectEquip" onclick="JavaScript:showHide(this.id);" /><%=brand%></font></b>
                            </TD>
                            <td style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" valign="MIDDLE" >
                                <DIV ID="divBrand">
                                    <select name="brand" id="brand" multiple size="5" style="font-size:12px;font-weight:bold;width:100%" onchange="selectAllElements(this.id)">
                                        <option value="selectAll" style="color:#989898;font-weight:bold;font-size:16px"><%=selectAll%></option>
                                        <sw:WBOOptionList wboList="<%=parents%>" displayAttribute="unitName" valueAttribute="id" />
                                    </select>
                                </DIV>
                            </td>

                            </TR>
                          <TR>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" valign="MIDDLE" WIDTH="2%">
                                &ensp;
                            </TD>
                            <TD class="backgroundHeader" STYLE="border-left-WIDTH:1px;text-align:center;padding:5px" WIDTH="13%">
                                <b><font size=3 color="black"><input type="radio" id="unit" value="unit" name="selectEquip" onclick="JavaScript:showHide(this.id);" /><%=nameEquip%></font></b>
                            </TD>
                            <td style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" valign="MIDDLE" >
                                <DIV ID="divUnit" style="display: none;">
                                    <input type="hidden" name="unitId" value="" id="unitId" />
                                    <input type="text" name="unitName" id="unitName" value="<%--=sName--%>" onclick="return getEquipmentInPopup();" />
                                    &nbsp;&nbsp;
                                    <input class="button" type="button" name="search" id="search" value="<%=select%>" onclick="return getEquipmentInPopup();"  STYLE="font-size:15;font-weight:bold;width:60px" />
                                </DIV>
                            </td>
                          </TR>
                         <TR>
                             <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" valign="MIDDLE" WIDTH="2%">
                                &ensp;
                            </TD>
                            <TD class="backgroundHeader" STYLE="text-align:center;padding:5px" WIDTH="15%">
                                <b><font size=3 color="black"><%= beginDate%></font></b>
                            </TD>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" valign="MIDDLE" >
                                <input readonly id="beginDate" name="beginDate" type="text" value="<%=nowTime%>" style="width:90%" /><img alt=""  src="images/showcalendar.gif" onmouseover="Tip('<%=calenderTip%>',CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#FFFF99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7, TITLE ,'Display Calender Help',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'black', TITLEBGCOLOR ,'#6699FF')" onmouseout="UnTip()" />
                            </TD>
                        <%--</TR>
                        <TR>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" valign="MIDDLE" WIDTH="2%">
                                &ensp;
                            </TD>
                            <TD class="backgroundHeader" STYLE="text-align:center;padding:5px" WIDTH="13%">
                                <b><font size=3 color="black"><%=item%></font></b>
                            </TD>
                            <TD style="text-align:center;font:bold 15px;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" valign="MIDDLE" >
                                <input type="text" name="sparePart" id="sparePart" onChange="JavaScript:textChange('partId')" style="width:77%;text-align:center" />
                                <input type="button" name="search" id="search" class="button" value="<%=selectByCode%>" onclick="return getDataInPopup('ReportsTreeServlet?op=listSpareParts' + '&fieldName=ITEM_ID&fieldValue=' + getASSCIChar(document.getElementById('sparePart').value));" STYLE="height: 25px;font-size:15px;color:black;font-weight:bold;width:60px" />
                                <input type="button" name="search" id="search" class="button" value="<%=selectByName%>" onclick="return getDataInPopup('ReportsTreeServlet?op=listSpareParts' + '&fieldName=ITEM_DESC&fieldValue=' + getASSCIChar(document.getElementById('sparePart').value));" STYLE="height: 25px;font-size:15px;color:black;font-weight:bold;width:60px" />
                                <input type="hidden" name="partId" id="partId" />
                            </TD>--%>
                            <TD class="backgroundHeader" STYLE="text-align:center;" WIDTH="15%">
                                <b> <font size=3 color="black"><%= endDate%></font> </b>
                            </TD>
                            <TD  style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" valign="middle">
                                <input readonly id="endDate" name="endDate" type="text" value="<%=nowTime%>" style="width:90%" /><img alt=""  src="images/showcalendar.gif" onmouseover="Tip('<%=calenderTip%>',CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#FFFF99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7, TITLE ,'Display Calender Help',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'black', TITLEBGCOLOR ,'#6699FF')" onmouseout="UnTip()" />
                            </TD>
                        </TR>
                        <TR>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" valign="MIDDLE" COLSPAN="5" >
                                &ensp;
                            </TD>
                        </TR>
                        
                        <TR style="display: none;">
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" valign="MIDDLE" WIDTH="2%">
                                &ensp;
                            </TD>
                            <TD class="backgroundHeader" STYLE="border-left-WIDTH:1px;text-align:center;padding:5px" WIDTH="13%">
                                <b><font size=3 color="black"><%=issueTitleLabel%></font></b>
                            </TD>
                            <TD DIR="<%=dir%>" style="text-align:center;font:bold 14px;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E8E8E8"  valign="MIDDLE">
                                <%=notEmergancy%><input type="radio" name="issueTitle" id="issueTitle" value="notEmergency" />
                                &ensp;
                                <%=emrgancy%><input type="radio" name="issueTitle" id="issueTitle" value="Emergency" />
                                &ensp;
                                <%=selectAll%><input type="radio" name="issueTitle" id="issueTitle" checked value="all" />
                            </TD>
                            <TD class="backgroundHeader" STYLE="border-left-WIDTH:1px;text-align:center;padding:5px" WIDTH="13%">
                                <b><font size=3 color="black"><%=currentStausLabel%></font></b>
                            </TD>
                            <TD DIR="<%=dir%>" style="text-align:center;font:bold 14px;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E8E8E8"  valign="MIDDLE">
                                <%=assigned%><input type="checkbox" name="currenStatus" id="currenStatus" checked value="Assigned" />
                                &ensp;
                                <%=closed%><input type="checkbox" name="currenStatus" id="currenStatus" checked value="Finished" />
                                &ensp;
                                <%=canceled%><input type="checkbox" name="currenStatus" id="currenStatus" checked value="Canceled" />
                            </TD>
                        </TR>
                        <TR style="display: none;">
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor=""  valign="MIDDLE" WIDTH="2%">
                                &ensp;
                            </TD>
                            <TD colspan="5" style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor=""  valign="MIDDLE" WIDTH="2%">
                                <div id="dropDown">
                                    <div onclick="JavaScript: changeMode('showHideTable');" id="showHide" style="text-align:<%=align%>;"><img id="showHideImg" src="images/317e0s5.gif" /><%=moreOptionsLabel%></div>
                                    <div id="showHideTable" style="display: none; padding-bottom:5px;">
                                        <table ALIGN="center" DIR="<%=dir%>" WIDTH="100%" CELLSPACING=0 CELLPADDING=0 BORDER="0">
                                            <tr>
                                                <TD class="backgroundHeader" STYLE="border-left-WIDTH:1px;text-align:center;padding:5px" WIDTH="13%">
                                                    <b><font size=3 color="white"><%=orderByLabel%></font></b>
                                                </TD>
                                                <TD colspan="2" DIR="<%=dir%>" style="text-align:<%=align%>;font:bold 15px;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#F8F8F8"  valign="MIDDLE" >
                                                    <input type="radio" name="orderType" id="orderType" checked value="ASC" /><%=ASCLabel%><br />
                                                    <input type="radio" name="orderType" id="orderType" value="DESC" /><%=DESCLabel%>
                                                </TD>
                                                <TD class="backgroundHeader" STYLE="border-left-WIDTH:1px;text-align:center;padding:5px" WIDTH="13%">
                                                    <b><font size=3 color="white"><%=dateTypeLabel%></font></b>
                                                </TD>
                                                <TD  DIR="<%=dir%>" style="text-align:<%=align%>;font:bold 15px;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#F8F8F8"  valign="MIDDLE" >
                                                    <input type="radio" name="dateType" id="dateType" checked value="actual_begin_date" /><%=actualBeginDateLabel%><br />
                                                    <input type="radio" name="dateType" id="dateType" value="actual_end_date" /><%=actualEndDateLabel%>
                                                </TD>
                                            </tr>
                                        </table>
                                    </div>
                                </div>

                            </TD>
                        </TR>
                        <TR>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" valign="MIDDLE" COLSPAN="5" >
                                &ensp;
                            </TD>
                        </TR>
                    </TABLE>
                    <br>
                    <TABLE ALIGN="center" DIR="<%=dir%>" WIDTH="90%" CELLSPACING=10 CELLPADDING=0 BORDER="0" style="display: block;">
                        <TR>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" valign="MIDDLE" >
                                <button onclick="JavaScript: submitForm();" class="button" STYLE="font-size:15px;font-weight:bold; width: 150px"><%=search%></button>
                                &ensp;
                                <button class="button" onclick="JavaScript: back();" STYLE="font-size:15px;font-weight:bold; "><%=cancel%></button>
                            </TD>
                        </TR>
                    </TABLE>
                    <br>
                </FIELDSET>
            </CENTER>
        </FORM>
    </BODY>
</HTML>
