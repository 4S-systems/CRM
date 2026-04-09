<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*,com.tracker.app_constants.*, com.tracker.common.*, java.util.*"%>
<%@ page import="com.maintenance.common.ConfigFileMgr" %>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants"%>
<%@ page import="com.silkworm.common.TimeServices,com.silkworm.jsptags.*,com.contractor.db_access.MaintainableMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="java.text.SimpleDateFormat"%>
<HTML>

    <%
                TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
                MetaDataMgr metaMgr = MetaDataMgr.getInstance();
                String context = metaMgr.getContext();

                // get all need data
                ArrayList allMainType = (ArrayList) request.getAttribute("allMainType");
                ArrayList parents = (ArrayList) request.getAttribute("parents");
                ArrayList allSites = (ArrayList) request.getAttribute("allSites");
                String defaultLocationName = (String) request.getAttribute("defaultLocationName");

                //get session logged user and his trades
                WebBusinessObject user = (WebBusinessObject) session.getAttribute("loggedUser");

                // get defaultLocationName

                // get current date
                Calendar cal = Calendar.getInstance();
                String jDateFormat = user.getAttribute("javaDateFormat").toString();
                SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
                String nowTime = sdf.format(cal.getTime());

                String cMode = (String) request.getSession().getAttribute("currentMode");
                String stat = cMode;

                String withDepartments, beginDate, byProduction, byDepartments, detailed, endDate, search, cancel, calenderTip, nameEquip, mainType, site, divAlign,
                        dir, lang, langCode, title, selectAll, select, back, unit, withBrand, withMainType, notEmergancy, brand;

                String compareDateMsg , beginDateMsg, endDateMsg;
                if (stat.equals("En")) {
                    lang = "   &#1593;&#1585;&#1576;&#1610;    ";
                    langCode = "Ar";
                    unit = "With Units";
                    dir = "LTR";
                    divAlign = "left";
                    detailed = "Detailed";
                    withDepartments = "With Departments";
                    beginDate = "From Actual Begin Date";
                    endDate = "To Actual Begin Date";
                    search = "Export Report";
                    cancel = "Cancel";
                    calenderTip = "click inside text box to opn calender window";
                    nameEquip = "By Equipment";
                    site = "Site";
                    mainType = "By Main Type";
                    brand = "By Brand";
                    title = "Average Costing Report";
                    selectAll = "All";
                    select = "Select";
                    back = "Back";
                    withBrand = "With Brands";
                    withMainType = "With Main Types";
                    notEmergancy = "Periodic";
                    byDepartments = "By Departments";
                    byProduction = "By Production Line";

                    compareDateMsg = "End Actual End Date must be greater than or equal start actual Begin Date";
                    endDateMsg = "End Actual End Date must be less than or equal today Date";
                    beginDateMsg = "Strat Actual Begin Date must be less than or equal today Date";
                } else {
                    lang = "   English    ";
                    langCode = "En";
                    unit = "&#1605;&#1593; &#1575;&#1604;&#1605;&#1593;&#1583;&#1575;&#1578;";
                    dir = "RTL";
                    divAlign = "right";
                    detailed = "&#1578;&#1601;&#1589;&#1610;&#1604;&#1610;";
                    withDepartments = "&#1605;&#1593; &#1575;&#1604;&#1575;&#1602;&#1587;&#1575;&#1605;";
                    beginDate = "&#1605;&#1606; &#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1576;&#1583;&#1569; &#1575;&#1604;&#1601;&#1593;&#1604;&#1610;";
                    endDate = "&#1573;&#1604;&#1610; &#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1576;&#1583;&#1569; &#1575;&#1604;&#1601;&#1593;&#1604;&#1610;";
                    search = "&#1575;&#1587;&#1578;&#1582;&#1585;&#1575;&#1580; &#1575;&#1604;&#1578;&#1602;&#1585;&#1610;&#1585;";
                    cancel = tGuide.getMessage("cancel");
                    calenderTip = "&#1575;&#1590;&#1594;&#1591; &#1583;&#1575;&#1582;&#1604; &#1575;&#1604;&#1605;&#1587;&#1578;&#1591;&#1610;&#1604; &#1604;&#1603;&#1609; &#1610;&#1592;&#1607;&#1585; &#1604;&#1603; &#1606;&#1575;&#1601;&#1584;&#1607; &#1604;&#1571;&#1582;&#1578;&#1610;&#1575;&#1585; &#1575;&#1604;&#1578;&#1575;&#1585;&#1610;&#1582;";
                    site = "&#1575;&#1604;&#1605;&#1608;&#1602;&#1593;";
                    mainType = "&#1576;&#1600;&#1600;&#1600; &#1575;&#1604;&#1606;&#1600;&#1600;&#1608;&#1593; &#1575;&#1604;&#1585;&#1574;&#1610;&#1600;&#1600;&#1587;&#1609;";
                    brand = "&#1576;&#1600;&#1600;&#1600; &#1575;&#1604;&#1605;&#1600;&#1600;&#1600;&#1575;&#1585;&#1603;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1577;";
                    nameEquip = "&#1576;&#1600;&#1600;&#1600; &#1575;&#1604;&#1605;&#1600;&#1600;&#1600;&#1600;&#1593;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1583;&#1577;";
                    selectAll = "&#1603;&#1600;&#1600;&#1600;&#1604;";
                    select = "&#1575;&#1582;&#1578;&#1610;&#1575;&#1585;";
                    back = "&#1585;&#1580;&#1608;&#1593;";
                    title = "&#1578;&#1602;&#1585;&#1610;&#1585; &#1575;&#1604;&#1578;&#1603;&#1604;&#1601;&#1577; &#1575;&#1604;&#1573;&#1580;&#1605;&#1575;&#1604;&#1609;";
                    withBrand = "&#1605;&#1593; &#1575;&#1604;&#1605;&#1575;&#1585;&#1603;&#1575;&#1578;";
                    withMainType = "&#1605;&#1593; &#1575;&#1604;&#1575;&#1606;&#1608;&#1575;&#1593; &#1575;&#1604;&#1585;&#1574;&#1610;&#1587;&#1610;&#1577;";
                    notEmergancy = "&#1583;&#1608;&#1585;&#1610;&#1577;";
                    byDepartments = "&#1576;&#1600;&#1600; &#1575;&#1604;&#1571;&#1602;&#1587;&#1575;&#1605;";
                    byProduction = "&#1576;&#1600; &#1582;&#1591; &#1575;&#1604;&#1571;&#1606;&#1578;&#1575;&#1580;";

                    compareDateMsg = " \u0646\u0647\u0627\u064A\u0629 \u062A\u0627\u0631\u064A\u062E \u0627\u0644\u0628\u062F\u0621 \u0627\u0644\u0641\u0639\u0644\u064A \u064A\u062C\u0628 \u0623\u0646 \u064A\u0643\u0648\u0646 \u0623\u0643\u0628\u0631 \u0645\u0646 \u0623\u0648 \u064A\u0633\u0627\u0648\u064A \u0628\u062F\u0627\u064A\u0629 \u062A\u0627\u0631\u064A\u062E \u0627\u0644\u0628\u062F\u0621 \u0627\u0644\u0641\u0639\u0644\u064A";
                    endDateMsg = "\u0646\u0647\u0627\u064A\u0629 \u062A\u0627\u0631\u064A\u062E \u0627\u0644\u0628\u062F\u0621 \u0627\u0644\u0641\u0639\u0644\u064A \u064A\u062C\u0628 \u0623\u0646 \u064A\u0643\u0648\u0646 \u0623\u0642\u0644 \u0645\u0646 \u0623\u0648 \u064A\u0633\u0627\u0648\u064A \u062A\u0627\u0631\u064A\u062E \u0627\u0644\u064A\u0648\u0645";
                    beginDateMsg = "\u0628\u062F\u0627\u064A\u0629 \u062A\u0627\u0631\u064A\u062E \u0627\u0644\u0628\u062F\u0621 \u0627\u0644\u0641\u0639\u0644\u064A \u064A\u062C\u0628 \u0623\u0646 \u064A\u0643\u0648\u0646 \u0623\u0642\u0644 \u0645\u0646 \u0623\u0648 \u064A\u0633\u0627\u0648\u064A \u062A\u0627\u0631\u064A\u062E \u0627\u0644\u064A\u0648\u0645";
                }
    %>

    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Doc Viewer- Select Project and Status</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/CSS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/Button.css">
        <link rel="stylesheet" type="text/css" href="css/epoch_styles.css" />
        <script type="text/javascript" src="js/epoch_classes.js"></script>
        <script src='ChangeLang.js' type='text/javascript'></script>
        <script type="text/javascript" src="js/common.js"></script>
        <script type="text/javascript" src="js/getEquipmentsList.js"></script>
        <script type="text/javascript">
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

            function submitForm(){
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
                } else if(document.getElementById('mainTypeRadio').checked && document.getElementById('maintype').value == ""){
                    alert('Please Select Main Type');
                    document.getElementById('maintype').focus();
                    return;
                } else if(document.getElementById('brandRadio').checked && document.getElementById('brand').value == ""){
                    alert('Please Select Brand');
                    document.getElementById('brand').focus();
                    return;
                }
                document.SEARCH_MAINTENANCE_FORM.action = "PDFReportServlet?op=resultCostingReport";
                openCustom('');
                document.SEARCH_MAINTENANCE_FORM.target="window_chaild";
                document.SEARCH_MAINTENANCE_FORM.submit();
            }

            function back()
            {
                document.SEARCH_MAINTENANCE_FORM.target="";
                document.SEARCH_MAINTENANCE_FORM.action = "<%=context%>/<%=request.getParameter("filterName")%>?op=<%=request.getParameter("filterValue")%>";
                document.SEARCH_MAINTENANCE_FORM.submit();
            }

            function compareDate()
            {
                return Date.parse(document.getElementById("endDate").value) >= Date.parse(document.getElementById("beginDate").value);
            }

            function textChange(textBox){
                document.getElementById(textBox).value = "";
            }

            function getEquipment(){
                var formName = document.getElementById('SEARCH_MAINTENANCE_FORM').getAttribute("name");
                var name = document.getElementById('unitName').value;
                var res = "";
                for (i=0;i < name.length; i++) {
                    res += name.charCodeAt(i) + ',';
                }
                res = res.substr(0, res.length - 1);
                openCustom('ReportsServlet?op=listEquipment&unitName='+res+'&formName='+formName);
            }

            function openCustom(url)
            {
                openCustomDialog(url, "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width=850, height=400");
            }

            function showHide(eleId,radioId){
                document.getElementById(eleId).style.display = 'block';
                document.getElementById('reportType').value = radioId;
                if(radioId == 'mainTypeRadio'){
                    document.getElementById('brand').style.display = 'none';
                    document.getElementById('divUnit').style.display = 'none';
                    document.getElementById('reportData').disabled = false;
                    blockOptions();

                }else if(radioId == 'brandRadio'){
                    document.getElementById('maintype').style.display = 'none';
                    document.getElementById('divUnit').style.display = 'none';
                    document.getElementById('reportData').disabled = false;
                    blockOptions();
                    
                }else if(radioId == 'unit'){
                    document.getElementById('maintype').style.display = 'none';
                    document.getElementById('brand').style.display = 'none';
                    document.getElementById('reportData').disabled = true;
                    document.getElementById('reportData').checked = false;
                    document.getElementById('options').style.display = 'none';
                    blockOptions();
                    
                }
            }

            function trim(str) {
                return str.replace(/^\s+|\s+$/g,"");
            }

            function selectAllElements(optionListId,typeAllId){
                var length = document.getElementById(optionListId).options.length;
                var option = document.getElementById(optionListId).options;
                if(option[0].selected) {
                    document.getElementById(typeAllId).value = "yes";
                    option[0].selected = false;
                    for(var i = 1; i<length; i++){
                        option[i].selected = true;
                    }
                } else {
                    document.getElementById(typeAllId).value = "no";
                }
            }

            function selectAllSites(optionListId,typeAllId){
                var length = document.getElementById(optionListId).options.length;
                var option = document.getElementById(optionListId).options;
                if(option[0].selected) {
                    window.SEARCH_MAINTENANCE_FORM.site.multiple = true;
                    document.getElementById(typeAllId).value = "yes";
                    option[0].selected = false;
                    for(var i = 1; i<length; i++){
                        option[i].selected = true;
                    }
                } else {

                    window.SEARCH_MAINTENANCE_FORM.site.multiple = false;
                    var selected = 0;
                    for(var i = 1; i<length; i++){
                        if(option[i].selected == true){
                            selected = i;
                            break;
                        }
                    }
                    for(var i = 0; i<length; i++){
                        option[i].selected == false;
                    }
                    option[selected].selected == true

                    document.getElementById(typeAllId).value = "no";
                }
            }

            function getSelectedType() {
                var radioButtons = document.getElementsByName("selectType");
                for (var x = 0; x < radioButtons.length; x ++) {
                    if (radioButtons[x].checked) {
                        return radioButtons[x].id;
                    }
                }
            }

            function blockOptions() {
                var selectType = getSelectedType();
                if(selectType == 'unit') {
                    document.getElementById("reportData").disabled = true;
                    
                } else {
                    if(document.getElementById("reportData").checked){
                        document.getElementById("options").style.display = "none";
                        document.getElementById("reportData").checked = false;
                    }

                }
                
            }
            
            function displayOptions(){
                var selectType = getSelectedType();
                if(selectType == 'mainTypeRadio') {
                    document.getElementById('with1').disabled = false;
                    document.getElementById('with2').disabled = false;
                    document.getElementById('with1').checked  = true;

                } else if(selectType == 'brandRadio') {
                    document.getElementById('with1').disabled = false;
                    document.getElementById('with1').checked  = true;
                    document.getElementById('with2').disabled = true;

                }
                
                if(document.getElementById("reportData").checked){
                    document.getElementById("options").style.display = "block";
                }
                else
                {
                    document.getElementById("options").style.display = "none";
                }
            }
        </script>
        <style type="css/text">
            .backStyle{
                border-bottom-width:0px;
                border-left-width:0px;
                border-right-width:0px;
                border-top-width:0px
            }
        </style>
    </HEAD>
    <BODY STYLE="background-color:#ffffb9">
        <FORM NAME="SEARCH_MAINTENANCE_FORM" METHOD="POST">

            <CENTER>
                <FIELDSET class="set" style="width:90%;border-color: #006699;" >
                    <TABLE class="blueBorder" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                        <TR>
                            <TD dir="<%=dir%>" style="text-align:center;border-color: #006699;background-color: #ffcc66;" width="100%" class="blueBorder blueHeaderTD"><font color="#006699" size="4"><%=title%></font></TD>
                        </TR>
                    </TABLE>
                    <TABLE id="Others" BGCOLOR="#ffffb9" ALIGN="center" DIR="<%=dir%>" WIDTH="90%" CELLSPACING=5 CELLPADDING=0 BORDER="0" style="display: block;">
                        <TR>
                            <TD CLASS="backStyle" style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#ffffb9"  valign="MIDDLE" COLSPAN="5" >
                                &ensp;
                            </TD>
                        </TR>
                        <TR>
                            <TD CLASS="backStyle" style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#ffffb9"  valign="MIDDLE" WIDTH="2%">
                                &ensp;
                            </TD>
                            <TD class="backgroundHeader" STYLE="text-align:center;padding:5px" WIDTH="17%">
                                <input type="hidden" id="reportType" name="reportType" value="mainTypeRadio" />
                                <b><font size=3 color="black"><input type="radio" id="mainTypeRadio" value="maintype" name="selectType" checked onclick="JavaScript:showHide(this.value,this.id);blockOptions();"/><%=mainType%></font></b>
                            </TD>
                            <TD BGCOLOR="#ffffb9" STYLE="border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px;text-align:center;padding:5px" WIDTH="33%">
                                <input type="hidden" id="mainTypeAll" name="mainTypeAll" value="no" />
                                <select name="mainType" id="maintype" onchange="selectAllElements(this.id,'mainTypeAll');" multiple size="5" style="font-size:12px;font-weight:bold;width:100%;display: block;">
                                    <option value="selectAll" style="color:#989898;font-weight:bold;font-size:16px"><%=selectAll%></option>
                                    <sw:WBOOptionList wboList="<%=allMainType%>" displayAttribute="typeName" valueAttribute="id" />
                                </select>
                            </TD>

                            <TD class="backgroundHeader" ROWSPAN="3" STYLE="text-align:center;padding:5px" WIDTH="17%">
                                <b><font size=3 color="black"><%=site%></font></b>
                            </TD>
                            <TD ROWSPAN="3" BGCOLOR="#ffffb9" STYLE="border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px;text-align:center;padding:5px" WIDTH="33%">
                                <input type="hidden" id="siteAll" value="no" name="siteAll" />
                                <select name="site" onChange="selectAllSites(this.id,'siteAll');" id="site" multiple size="5" style="font-size:12px;font-weight:bold;width:100%; height: 100%; margin: 0px">
                                    <option value="selectAll" style="color:#989898;font-weight:bold;font-size:16px"><%=selectAll%></option>
                                    <sw:WBOOptionList wboList="<%=allSites%>" displayAttribute="projectName" valueAttribute="projectID" scrollTo="<%=defaultLocationName%>" />
                                </select>
                            </TD>
                        </TR>
                        <TR>
                            <TD CLASS="backStyle" style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#ffffb9"  valign="MIDDLE" WIDTH="2%">
                                &ensp;
                            </TD>
                            <TD class="backgroundHeader" STYLE="text-align:center;padding:5px" WIDTH="17%">
                                <b><font size=3 color="black"><input type="radio" id="brandRadio" value="brand" name="selectType" onclick="JavaScript:showHide(this.value,this.id);blockOptions();" /><%=brand%></font></b>
                            </TD>
                            <TD BGCOLOR="#ffffb9" STYLE="border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px;text-align:center;padding:5px" WIDTH="33%">
                                <input type="hidden" id="brandAll" name="brandAll" value="no"/>
                                <select onchange="selectAllElements(this.id,'brandAll');" name="brand" id="brand" multiple size="5" style="font-size:12px;font-weight:bold;width:100%;display: none;">
                                    <option value="selectAll" style="color:#989898;font-weight:bold;font-size:16px"><%=selectAll%></option>
                                    <sw:WBOOptionList wboList="<%=parents%>" displayAttribute="unitName" valueAttribute="id" />
                                </select>
                            </TD>
                        </TR>
                        <TR>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#ffffb9"  valign="MIDDLE" WIDTH="2%">
                                &ensp;
                            </TD>
                            <TD class="backgroundHeader" STYLE="text-align:center;padding:5px" WIDTH="13%">
                                <b><font size=3 color="black"><input type="radio" id="unit" value="divUnit" name="selectType" onclick="JavaScript:showHide(this.value,this.id);blockOptions();" /><%=nameEquip%></font></b>
                            </TD>
                            <TD style="text-align:center;font:bold 15px;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#ffffb9"  valign="MIDDLE" >
                                <DIV ID="divUnit" style="display: none;">
                                    <input type="text" name="unitName" id="unitName" onchange="JavaScript:textChange('unitId')" style="width:60%;text-align:center" />
                                    <input class="button" type="button" name="search" id="search" value="<%=select%>" onclick="return getEquipmentInPopup();" STYLE="height: 25px;font-size:15px;color:black;font-weight:bold;width:60px" />
                                    <input type="hidden" name="unitId" id="unitId" />
                                </DIV>
                            </TD>
                        </TR>
                        <TR>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#ffffb9"  valign="MIDDLE" COLSPAN="5" >
                                &ensp;
                            </TD>
                        </TR>
                        <TR>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#ffffb9"  valign="MIDDLE" WIDTH="2%">
                                &ensp;
                            </TD>
                            <TD class="backgroundHeader" STYLE="text-align:center;padding:5px" WIDTH="13%">
                                <b><font size=3 color="black"><%= beginDate%></font></b>
                            </TD>
                            <TD style="text-align:center;font:bold 15px;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#ffffb9"  valign="MIDDLE" >
                                <input readonly id="beginDate" name="beginDate" type="text" value="<%=nowTime%>" style="width:90%" /><img alt=""  src="images/showcalendar.gif" onmouseover="Tip('<%=calenderTip%>',CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#FFFF99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7, TITLE ,'Display Calender Help',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'black', TITLEBGCOLOR ,'#6699FF')" onmouseout="UnTip()" />
                            </TD>
                            <TD class="backgroundHeader" STYLE="text-align:center;padding:5px" WIDTH="13%">
                                <b> <font size=3 color="black"><%= endDate%></font> </b>
                            </TD>
                            <TD style="text-align:center;font:bold 15px;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#ffffb9"  valign="MIDDLE" >
                                <input readonly id="endDate" name="endDate" type="text" value="<%=nowTime%>" style="width:90%" /><img alt=""  src="images/showcalendar.gif" onmouseover="Tip('<%=calenderTip%>',CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#FFFF99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7, TITLE ,'Display Calender Help',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'black', TITLEBGCOLOR ,'#6699FF')" onmouseout="UnTip()" />
                            </TD>
                        </TR>
                        <TR>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#ffffb9"  valign="MIDDLE" COLSPAN="5" >
                                &ensp;
                            </TD>
                        </TR>
                        <TR>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#ffffb9"  valign="MIDDLE" WIDTH="2%">
                                &ensp;
                            </TD>
                            <TD style="text-align:<%=divAlign%>;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#ffffb9"  valign="MIDDLE" COLSPAN="4" >
                                <input type="checkbox" name="reportData" id="reportData" onclick="displayOptions()" value="detailed" /><font style="font-size: medium;font-weight: bold;">&nbsp;<%=detailed%></font>
                            </TD>
                        </TR>
                        <TR id="options" style="display: none;">
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#ffffb9"  valign="MIDDLE" colspan="5">
                                <input checked type="radio" id="with1" name="with" value="units" />&nbsp;<b style="font-size: small;"><%=unit%></b>
                                &nbsp;
                                <input type="radio" name="with" id="with2" value="brands" />&nbsp;<b style="font-size: small;"><%=withBrand%></b>
                            </TD>
                        </TR>
                        <TR>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#ffffb9"  valign="MIDDLE" COLSPAN="5" >
                                &ensp;
                            </TD>
                        </TR>
                    </TABLE>
                    <br>
                    <TABLE BGCOLOR="#ffffb9" ALIGN="center" DIR="<%=dir%>" WIDTH="90%" CELLSPACING=10 CELLPADDING=0 BORDER="0" style="display: block;">
                        <TR>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#ffffb9"  valign="MIDDLE" >
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
