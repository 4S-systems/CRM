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
                ArrayList allTrade = (ArrayList) request.getAttribute("allTrade");
                ArrayList allMainType = (ArrayList) request.getAttribute("allMainType");
                ArrayList brands = (ArrayList) request.getAttribute("brands");
                //get session logged user and his trades
                WebBusinessObject user = (WebBusinessObject) session.getAttribute("loggedUser");

                // get defaultLocationName
                String defaultLocationName = (String) request.getAttribute("defaultLocationName");

                // get current date
                Calendar cal = Calendar.getInstance();
                String jDateFormat = user.getAttribute("javaDateFormat").toString();
                SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
                String nowTime = sdf.format(cal.getTime());

                String cMode = (String) request.getSession().getAttribute("currentMode");
                String stat = cMode;

                String item, beginDate, issue, endDate, search, cancel, calenderTip, tradeName, nameEquip, mainType, site, divAlign,
                        dir, lang, langCode, title, selectAll, select, back, maintenance, emrgancy, notEmergancy, byBrand, assigned, closed, canceled, totaly, detailed, analyised, reportType;

                String compareDateMsg, beginDateMsg, endDateMsg;
                if (stat.equals("En")) {
                    lang = "   &#1593;&#1585;&#1576;&#1610;    ";
                    langCode = "Ar";
                    dir = "LTR";
                    divAlign = "left";
                    issue = "Job Order";
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
                    title = "Maintenance Operations Analysis Report";
                    selectAll = "All";
                    select = "Select";
                    back = "Back";
                    maintenance = "Maintenance";
                    emrgancy = "Emergency";
                    notEmergancy = "Periodic";
                    byBrand = "By Brand";
                    assigned = "Assigned";
                    closed = "Closed";
                    canceled = "Canceled";
                    totaly = "Totaly";
                    detailed = "Detailed";
                    analyised = "Analyised";
                    reportType = "Report Type";

                    compareDateMsg = "End Actual End Date must be greater than or equal start actual Begin Date";
                    endDateMsg = "End Actual End Date must be less than or equal today Date";
                    beginDateMsg = "Strat Actual Begin Date must be less than or equal today Date";
                } else {
                    lang = "   English    ";
                    langCode = "En";
                    dir = "RTL";
                    divAlign = "right";
                    issue = "&#1571;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
                    item = "&#1602;&#1591;&#1593; &#1594;&#1610;&#1575;&#1585;";
                    beginDate = "&#1605;&#1606; &#1578;&#1575;&#1585;&#1610;&#1582;";
                    endDate = "&#1575;&#1604;&#1609; &#1578;&#1575;&#1585;&#1610;&#1582;";
                    search = "&#1575;&#1587;&#1578;&#1582;&#1585;&#1575;&#1580; &#1575;&#1604;&#1578;&#1602;&#1585;&#1610;&#1585;";
                    cancel = tGuide.getMessage("cancel");
                    calenderTip = "&#1575;&#1590;&#1594;&#1591; &#1583;&#1575;&#1582;&#1604; &#1575;&#1604;&#1605;&#1587;&#1578;&#1591;&#1610;&#1604; &#1604;&#1603;&#1609; &#1610;&#1592;&#1607;&#1585; &#1604;&#1603; &#1606;&#1575;&#1601;&#1584;&#1607; &#1604;&#1571;&#1582;&#1578;&#1610;&#1575;&#1585; &#1575;&#1604;&#1578;&#1575;&#1585;&#1610;&#1582;";
                    tradeName = "&#1606;&#1608;&#1593; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
                    nameEquip = "&#1576;&#1575;&#1604;&#1605;&#1593;&#1583;&#1577;";
                    site = "&#1575;&#1604;&#1605;&#1608;&#1602;&#1593;";
                    mainType = "&#1576;&#1575;&#1604;&#1606;&#1608;&#1593; &#1585;&#1574;&#1610;&#1587;&#1609;";
                    selectAll = "&#1603;&#1600;&#1600;&#1600;&#1604;";
                    select = "&#1575;&#1582;&#1578;&#1610;&#1575;&#1585;";
                    back = "&#1585;&#1580;&#1608;&#1593;";
                    title = "&#1578;&#1602;&#1585;&#1610;&#1585; &#1578;&#1581;&#1604;&#1610;&#1604; &#1593;&#1605;&#1604;&#1610;&#1575;&#1578; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
                    maintenance = "&#1589;&#1610;&#1575;&#1606;&#1577;";
                    emrgancy = "&#1591;&#1575;&#1585;&#1574;&#1577;";
                    notEmergancy = "&#1583;&#1608;&#1585;&#1610;&#1577;";
                    byBrand = "&#1576;&#1575;&#1604;&#1605;&#1575;&#1585;&#1603;&#1577;";
                    assigned = "&#1578;&#1581;&#1578; &#1575;&#1604;&#1578;&#1606;&#1601;&#1610;&#1584;";
                    closed = "&#1578;&#1605; &#1573;&#1594;&#1604;&#1575;&#1602;&#1607;";
                    canceled = "&#1578;&#1605; &#1573;&#1604;&#1594;&#1575;&#1569;&#1607;";
                    totaly = "&#1573;&#1580;&#1605;&#1575;&#1604;&#1610;";
                    detailed = "&#1578;&#1601;&#1589;&#1610;&#1604;&#1610;";
                    analyised = "&#1578;&#1581;&#1604;&#1610;&#1604;&#1610;";
                    reportType = "&#1606;&#1608;&#1593; &#1575;&#1604;&#1578;&#1602;&#1585;&#1610;&#1585;";

                    compareDateMsg = " \u0646\u0647\u0627\u064A\u0629 \u062A\u0627\u0631\u064A\u062E \u0627\u0644\u0628\u062F\u0621 \u0627\u0644\u0641\u0639\u0644\u064A \u064A\u062C\u0628 \u0623\u0646 \u064A\u0643\u0648\u0646 \u0623\u0643\u0628\u0631 \u0645\u0646 \u0623\u0648 \u064A\u0633\u0627\u0648\u064A \u0628\u062F\u0627\u064A\u0629 \u062A\u0627\u0631\u064A\u062E \u0627\u0644\u0628\u062F\u0621 \u0627\u0644\u0641\u0639\u0644\u064A";
                    endDateMsg = "\u0646\u0647\u0627\u064A\u0629 \u062A\u0627\u0631\u064A\u062E \u0627\u0644\u0628\u062F\u0621 \u0627\u0644\u0641\u0639\u0644\u064A \u064A\u062C\u0628 \u0623\u0646 \u064A\u0643\u0648\u0646 \u0623\u0642\u0644 \u0645\u0646 \u0623\u0648 \u064A\u0633\u0627\u0648\u064A \u062A\u0627\u0631\u064A\u062E \u0627\u0644\u064A\u0648\u0645";
                    beginDateMsg = "\u0628\u062F\u0627\u064A\u0629 \u062A\u0627\u0631\u064A\u062E \u0627\u0644\u0628\u062F\u0621 \u0627\u0644\u0641\u0639\u0644\u064A \u064A\u062C\u0628 \u0623\u0646 \u064A\u0643\u0648\u0646 \u0623\u0642\u0644 \u0645\u0646 \u0623\u0648 \u064A\u0633\u0627\u0648\u064A \u062A\u0627\u0631\u064A\u062E \u0627\u0644\u064A\u0648\u0645";
                }
    %>

    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <head>
        <TITLE>Doc Viewer- Select Project and Status</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/CSS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/Button.css">
        <script src='ChangeLang.js' type='text/javascript'></script>
        <script type="text/javascript" src="js/wz_tooltip.js"></script>
        <script type="text/javascript" src="js/tip_centerwindow.js"></script>
        <script type="text/javascript" src="js/tip_balloon.js"></script>
        <script type="text/javascript" src="js/tip_followscroll.js"></script>
        <script type="text/javascript" src="js/datepicker_limit.js"></script>
        <link rel="stylesheet" type="text/css" href="css/epoch_styles.css" />
        <script type="text/javascript" src="js/epoch_classes.js"></script>
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
                showHide('mainTypeRadio');
            }
            var mainTypeAll = "no";
            var siteAll = "no";
            var brandAll = "no";
            var tradeAll = "no";
            function submitForm()
            {
                var unitId = document.getElementById('unitId').value;
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
                } else if(document.getElementById('unit').checked && unitId == ""){
                    alert("Must Select Equipment");
                    document.SEARCH_MAINTENANCE_FORM.unitName.focus();
                    return;
                } else if (document.getElementById('site').value == "") {
                    alert("Please Select Site");
                    document.SEARCH_MAINTENANCE_FORM.site.foucs();
                    return;
                } else if(document.getElementById('mainTypeRadio').checked && document.getElementById('maintype').value == "") {
                    alert("Please Select Main Type");
                    document.SEARCH_MAINTENANCE_FORM.maintype.focus();
                    return;
                } else if(document.getElementById('brandType').checked && document.getElementById('brand').value == "") {
                    alert("Please Select Brand");
                    document.SEARCH_MAINTENANCE_FORM.brand.focus();
                    return;
                } else if(document.getElementById('trade').value == "") {
                    alert("Please Select Trade");
                    document.SEARCH_MAINTENANCE_FORM.trade.focus();
                    return;
                } else {
                    var anyChecked = false;
                    var elements = document.getElementsByName('issueStatus');
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
                document.SEARCH_MAINTENANCE_FORM.action = "PDFReportServlet?op=resultMaintenanceOpAnalysis&mainTypeAll=" + mainTypeAll + "&siteAll=" + siteAll + "&brandAll=" + brandAll + "&tradeAll=" + tradeAll;
                openCustom('');
                document.SEARCH_MAINTENANCE_FORM.target = "window_chaild";
                document.SEARCH_MAINTENANCE_FORM.submit();
            }

            function back()
            {
                document.SEARCH_MAINTENANCE_FORM.target = "";
                document.SEARCH_MAINTENANCE_FORM.action = "<%=context%>/<%=request.getParameter("filterName")%>?op=<%=request.getParameter("filterValue")%>";
                document.SEARCH_MAINTENANCE_FORM.submit();
            }

            function compareDate()
            {
                return Date.parse(document.getElementById("endDate").value) >= Date.parse(document.getElementById("beginDate").value);
            }

            function getIssueTitle() {
                var issueTitle = document.getElementsByName('issueTitle');
                for(var i = 0; i < issueTitle.length; i++) {
                    if(issueTitle[i].checked) {
                        return issueTitle[i].value;
                    }
                }

                return "both";
            }
        
            function getReportType(){
                var reportType = document.getElementsByName("reportType");
                for(var i=0;i<reportType.length;i++){
                    if(reportType[i].checked){
                        return reportType[i].value;
                    }
                }
            }
        
            function getIssueStatus() {
                var values = "";
                var issueStatus = document.getElementsByName('issueStatus');
                for(var i=0; i < issueStatus.length; i++){
                    if(issueStatus[i].checked){
                        values = values + issueStatus[i].value + " ";
                    }
                }
                if(values != ""){
                    return values;
                }else{
                    alert("Select at least 1 job order status");
                    return false;
                }
            }

            function getSites(){
                var sitesValues = "";
                var sites = document.getElementById('site');
                for(var i = 0 ;i<sites.options.length;i++){
                    if(sites.options[i].selected){
                        sitesValues = sitesValues  + sites.options[i].value + " ";
                    }
                }

                return sitesValues;
            }

            function getAllSites(){
                var sitesValues = "";
                var sites = document.getElementById('site');
                for(var i = 1 ;i<sites.options.length;i++){
                    sitesValues = sitesValues  + sites.options[i].value + " ";
                }
                return sitesValues;
            }
     
            function getMainType(){
                var mainTypeValues = "";
                var maintype = document.getElementById('maintype');
                for(var i = 0 ;i<maintype.options.length;i++){
                    if(maintype.options[i].selected){
                        mainTypeValues = mainTypeValues  + maintype.options[i].value + " ";
                    }
                }
                return mainTypeValues;
            }
        
            function getBrands(){
                var brands = "";
                var brandsType = document.getElementById('brand');
                for(var i = 0 ;i<brandsType.options.length;i++){
                    if(brandsType.options[i].selected){
                        brands = brands  + brandsType.options[i].value + " ";
                    }
                }
                return brands;
            }

            function getAllMainType(){
                var mainTypeValues = "";
                var maintype = document.getElementById('maintype');
                for(var i = 1 ;i<maintype.options.length;i++){
                    mainTypeValues = mainTypeValues  + maintype.options[i].value + " ";
                }
                return mainTypeValues;
            }

            function getAllTrade(){
                var tradeValues = "";
                var trade = document.getElementById('trade');
                for(var i = 1 ;i<trade.options.length;i++){
                    tradeValues = tradeValues  + trade.options[i].value + " ";
                }
                return tradeValues;
            }

            function textChange(textBox){
                document.getElementById(textBox).value = "";
            }

            function getEquipment(){
                sitesValues = "";
                var sites = document.getElementsByName('site');
                var count = 0;

                for(var i = 0 ;i<sites.length;i++){
                    if(sites[i].checked){
                        sitesValues = sitesValues  + sites[i].value + " ";
                        alert(sitesValues);
                        count++;
                    }
                }

                if(trim(sitesValues) == "selectAll"){
                    sitesValues = getAllSites();
                }
                if(count > 0){
                    var formName = document.getElementById('SEARCH_MAINTENANCE_FORM').getAttribute("name");
                    var name = document.getElementById('unitName').value;
                    var res = "";
                    for (i=0;i < name.length; i++) {
                        res += name.charCodeAt(i) + ',';
                    }
                    res = res.substr(0, res.length - 1);
                    openWindow('ReportsServletThree?op=selectEquipment&unitName='+res+'&formName='+formName+'&sites='+sitesValues);
                }else{
                    alert("Must select at least one Site");
                }

            }

            function getItems(){
                var formName = document.getElementById('SEARCH_MAINTENANCE_FORM').getAttribute("name");
                var name = document.getElementById('sparePart').value;
                var res = "";
                for (i=0;i < name.length; i++) {
                    res += name.charCodeAt(i) + ',';
                }
                res = res.substr(0, res.length - 1);
                openWindow('ReportsServletThree?op=selectItems&sparePart='+res+'&formName='+formName);
            }

            function openWindow(url)
            {
                window.open(url,"_blank","toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width=850, height=400");
            }
            
            function openCustom(url)
            {
                openCustomDialog(url, "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width=850, height=400");
            }

            function showHide(id){
                var divUnit = document.getElementById('divUnit');
                var divMainType = document.getElementById('divMainType');
                var divBrand = document.getElementById('divBrand');
                if(id == 'mainTypeRadio'){
                    divMainType.style.display = "block";
                    divUnit.style.display = "none";
                    divBrand.style.display = "none";
                }else if(id == 'unit'){
                    divUnit.style.display = "block";
                    divMainType.style.display = "none";
                    divBrand.style.display = "none";
                }else if(id =='brandType'){
                    divBrand.style.display = "block";
                    divUnit.style.display = "none";
                    divMainType.style.display = "none";
                }
                dp_cal1  = new Epoch('epoch_popup','popup',document.getElementById('beginDate'));
                dp_cal2  = new Epoch('epoch_popup','popup',document.getElementById('endDate'));
            }

            function showHide2(id){
                var divUnit = document.getElementById('MaintNum');
                var divMainType = document.getElementById('Others');
                if(id == 'Other') {
                    divMainType.style.display = "block";
                    divUnit.style.display = "none";
                    dp_cal1  = new Epoch('epoch_popup','popup',document.getElementById('beginDate'));
                    dp_cal2  = new Epoch('epoch_popup','popup',document.getElementById('endDate'));

                }else{
                    divUnit.style.display = "block";
                    divMainType.style.display = "none";
                    document.getElementById('fMaintNum').focus();
                }
            }
            function trim(str) {
                return str.replace(/^\s+|\s+$/g,"");
            }
            
            function selectAllElements(optionListId){
                var length = document.getElementById(optionListId).options.length;
                var option = document.getElementById(optionListId).options;
                if(option[0].selected) {
                    option[0].selected = false;
                    for(var i = 1; i<length; i++){
                        option[i].selected = true;
                    }
                    if(optionListId == "maintype"){
                        mainTypeAll = "yes";
                    } else if(optionListId == "site"){
                        siteAll = "yes";
                    } else if(optionListId == "brand"){
                        brandAll = "yes";
                    } else if(optionListId == "trade"){
                        tradeAll = "yes";
                    }
                } else {
                    if(optionListId == "maintype"){
                        mainTypeAll = "no";
                    } else if(optionListId == "site"){
                        siteAll = "no";
                    } else if(optionListId == "brand"){
                        brandAll = "no";
                    } else if(optionListId == "trade"){
                        tradeAll = "no";
                    }
                }
            }
        </script>
        <style type="css/text" >
            .backStyle{
                border-bottom-width:0px;
                border-left-width:0px;
                border-right-width:0px;
                border-top-width:0px
            }
        </style>
    </head>
    <BODY STYLE="background-color:#E8E8E8">
        <FORM action=""  NAME="SEARCH_MAINTENANCE_FORM" METHOD="POST">
            <DIV align="left" STYLE="color:blue;padding-left: 5%; padding-bottom: 10px">
                <input type="button"  value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
                &ensp;
                <button onclick="JavaScript:back();" class="button"><%=back%></button>
            </DIV>
            <CENTER>
                <FIELDSET class="set" style="width:90%;border-color: #006699;" >
                    <TABLE class="blueBorder" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                        <TR>
                            <TD dir="<%=dir%>" style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD"><font color="#F3D596" size="4"><%=title%></font></TD>
                        </TR>
                    </TABLE>
                    <br>
                    <TABLE id="Others" BGCOLOR="#E8E8E8" ALIGN="center" DIR="<%=dir%>" WIDTH="90%" CELLSPACING=5 CELLPADDING=0 BORDER="0">
                        <TR>
                            <TD CLASS="backStyle" style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E8E8E8"  valign="MIDDLE" COLSPAN="5" >
                                &ensp;
                            </TD>
                        </TR>
                        <TR>
                            <TD CLASS="backStyle" style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E8E8E8"  valign="MIDDLE" WIDTH="2%">
                                &ensp;
                            </TD>
                            <TD class="backgroundHeader" STYLE="text-align:center;padding:5px" WIDTH="17%">
                                <b><font size=3 color="black"><input type="radio" id="mainTypeRadio" value="maintype" name="selectEquip" checked onclick="JavaScript:showHide(this.id);" /><%=mainType%></font></b>
                            </TD>
                            <TD BGCOLOR="#E8E8E8" STYLE="border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px;text-align:center;padding:5px" WIDTH="33%">
                                <DIV ID="divMainType">
                                    <select name="mainType" id="maintype" multiple size="5" style="font-size:12px;font-weight:bold;width:100%" onchange="selectAllElements(this.id)">
                                        <option value="selectAll" style="color:#989898;font-weight:bold;font-size:16px"><%=selectAll%></option>
                                        <sw:WBOOptionList wboList="<%=allMainType%>" displayAttribute="typeName" valueAttribute="id" />
                                    </select>
                                </DIV>
                            </TD>
                            <TD class="backgroundHeader" ROWSPAN="2" STYLE="text-align:center;padding:5px" WIDTH="17%">
                                <b><font size=3 color="black"><%=site%></font></b>
                            </TD>
                            <TD ROWSPAN="2" BGCOLOR="#E8E8E8" STYLE="border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px;text-align:center;padding:5px" WIDTH="33%">
                              <div id='projectScroll' style="width:100%; height: 200px; overflow:auto;">
                                    <jsp:include page="/docs/new_search/project_checkbox_list.jsp" flush="true"/>
                              </div>
                            </TD>
                        </TR>
                        <TR>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E8E8E8"  valign="MIDDLE" WIDTH="2%">
                                &ensp;
                            </TD>
                            <TD class="backgroundHeader" STYLE="text-align:center;padding:5px" WIDTH="13%">
                                <b><font size=3 color="black"><input type="radio" id="unit" value="unit" name="selectEquip" onclick="JavaScript:showHide(this.id);" /><%=nameEquip%></font></b>
                            </TD>
                            <TD style="text-align:center;font:bold 15px;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E8E8E8"  valign="MIDDLE" >
                                <DIV ID="divUnit">
                                    <input type="text" name="unitName" id="unitName" onchange="JavaScript:textChange('unitId')" style="width:77%;text-align:center" />
                                    <input class="button" type="button" name="search" id="search" value="<%=select%>" onclick="JavaScript:getEquipment()" STYLE="height: 25px;font-size:15px;font-weight:bold;width:60px" />
                                    <input type="hidden" name="unitId" id="unitId" />
                                </DIV>
                            </TD>
                        </TR>
                        <TR>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E8E8E8"  valign="MIDDLE" WIDTH="2%">
                                &ensp;
                            </TD>
                            <TD class="backgroundHeader" STYLE="text-align:center;padding:5px" WIDTH="13%">
                                <b><font size=3 color="black"><input type="radio" id="brandType" value="brand" name="selectEquip" onclick="JavaScript:showHide(this.id);" /><%=byBrand%></font></b>
                            </TD>
                            <TD style="text-align:center;font:bold 15px;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E8E8E8"  valign="MIDDLE" >
                                <DIV ID="divBrand">
                                    <select name="brand" id="brand" multiple size="5" style="font-size:12px;font-weight:bold;width:100%" onchange="selectAllElements(this.id)">
                                        <option value="selectAll" style="color:#989898;font-weight:bold;font-size:16px"><%=selectAll%></option>
                                        <sw:WBOOptionList wboList="<%=brands%>" displayAttribute="unitName" valueAttribute="id" />
                                    </select>
                                </DIV>
                            </TD>
                        </TR>
                        <TR>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E8E8E8"  valign="MIDDLE" COLSPAN="5" >
                                &ensp;
                            </TD>
                        </TR>
                        <TR>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E8E8E8"  valign="MIDDLE" WIDTH="2%">
                                &ensp;
                            </TD>
                            <TD class="backgroundHeader" STYLE="text-align:center;padding:5px" WIDTH="13%">
                                <b><font size=3 color="black"><%=tradeName%></font></b>
                            </TD>
                            <TD BGCOLOR="#E8E8E8" STYLE="border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px;text-align:center;padding:3px" WIDTH="35%">
                                <select name="trade" id="trade" multiple style="font-size:12px;font-weight:bold;width:100%" onchange="selectAllElements(this.id)">
                                    <option value="selectAll" style="color:#989898"><%=selectAll%></option>
                                    <sw:WBOOptionList wboList="<%=allTrade%>" displayAttribute="tradeName" valueAttribute="tradeId" />
                                </select>
                            </TD>
                            <TD class="backgroundHeader" STYLE="text-align:center;padding:5px" WIDTH="15%">
                                <b><font size=3 color="black"><%= beginDate%></font></b>
                            </TD>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E8E8E8"  valign="MIDDLE" >
                                <input readonly id="beginDate" name="beginDate" type="text" value="<%=nowTime%>" style="width:90%" /><img alt=""  src="images/showcalendar.gif" onmouseover="Tip('<%=calenderTip%>',CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#FFFF99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7, TITLE ,'Display Calender Help',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'black', TITLEBGCOLOR ,'#6699FF')" onmouseout="UnTip()" />
                            </TD>
                        </TR>
                        <TR>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E8E8E8"  valign="MIDDLE" WIDTH="2%">
                                &ensp;
                            </TD>
                            <TD STYLE="text-align:center;padding:5px" WIDTH="13%" bgcolor="#E8E8E8">
                                <!-- <b><font size=3 color="black"><%=item%></font></b> -->
                            </TD>
                            <TD style="text-align:center;font:bold 15px;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E8E8E8"  valign="MIDDLE" >
                                <!-- <input type="text" name="sparePart" id="sparePart" onchange="JavaScript:textChange('partId')" style="width:77%;text-align:center" />
                                <input type="button" name="search" id="search" class="button" value="<%=select%>" onclick="JavaScript:getItems()" STYLE="height: 25px;font-size:15px;color:white;font-weight:bold;width:60px" />
                                <input type="hidden" name="partId" id="partId" /> -->
                            </TD>
                            <TD class="backgroundHeader" STYLE="text-align:center;" WIDTH="15%">
                                <b> <font size=3 color="black"><%= endDate%></font> </b>
                            </TD>
                            <TD  bgcolor="#E8E8E8"  style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" valign="middle">
                                <input readonly id="endDate" name="endDate" type="text" value="<%=nowTime%>" style="width:90%" /><img alt=""  src="images/showcalendar.gif" onmouseover="Tip('<%=calenderTip%>',CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#FFFF99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7, TITLE ,'Display Calender Help',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'black', TITLEBGCOLOR ,'#6699FF')" onmouseout="UnTip()" />
                            </TD>
                        </TR>
                        <TR>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E8E8E8"  valign="MIDDLE" COLSPAN="5" >
                                &ensp;
                            </TD>
                        </TR>
                        <TR>
                            <TD DIR="<%=dir%>" style="text-align:<%=divAlign%>;padding-<%=divAlign%> : 5%;font:bold 15px;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E8E8E8"  valign="MIDDLE" COLSPAN="3" >
                                <%=maintenance%>
                                <font color="red">(</font>
                                <%=notEmergancy%><input type="radio" name="issueTitle" id="issueTitle" checked value="notEmergency" />
                                &ensp;
                                <%=emrgancy%><input type="radio" name="issueTitle" id="issueTitle" checked value="Emergency" />
                                &ensp;
                                <%=selectAll%><input type="radio" name="issueTitle" id="issueTitle" checked value="both" />
                                <font color="red">)</font>
                            </TD>
                            <TD DIR="<%=dir%>" style="text-align:<%=divAlign%>;padding-<%=divAlign%> : 5%;font:bold 15px;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E8E8E8"  valign="MIDDLE" COLSPAN="2" >
                                <%=issue%>
                                <font color="red">(</font>
                                <%=assigned%><input type="checkbox" name="issueStatus" id="issueStatus" value="Assigned" />
                                &ensp;
                                <%=closed%><input type="checkbox" name="issueStatus" id="issueStatus" value="Finished" />
                                &ensp;
                                <%=canceled%><input type="checkbox" name="issueStatus" id="issueStatus" value="Canceled" />
                                <font color="red">)</font>
                            </TD>
                        </TR>
                        <TR>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E8E8E8"  valign="MIDDLE" COLSPAN="5" >
                                &ensp;
                            </TD>
                        </TR>
                        <TR>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E8E8E8"  valign="MIDDLE" COLSPAN="5" >
                                <hr>
                            </TD>
                        </TR>
                        <TR>
                            <TD DIR="<%=dir%>" style="text-align:center;padding-<%=divAlign%> : 5%;font:bold 15px;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E8E8E8"  valign="MIDDLE" COLSPAN="5" >
                                <%=reportType%>
                                <font color="red">(</font>
                                <%=totaly%> <input type="radio" name="reportType" id="reportType" value="Totaly" checked />
                                &ensp;
                                <%=detailed%> <input type="radio" name="reportType" id="reportType" value="Detailed" />
                                &ensp;
                                <%=analyised%> <input type="radio" name="reportType" id="reportType" value="Analyised" />
                                <font color="red">)</font>
                            </TD>
                        </TR>
                    </TABLE>
                    <br>
                    <TABLE BGCOLOR="#E8E8E8" ALIGN="center" DIR="<%=dir%>" WIDTH="90%" CELLSPACING=10 CELLPADDING=0 BORDER="0" style="display: block;">
                        <TR>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E8E8E8"  valign="MIDDLE" >
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
