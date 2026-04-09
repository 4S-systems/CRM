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
                Vector allSites = (Vector) request.getAttribute("allSites");
                ArrayList allTrade = (ArrayList) request.getAttribute("allTrade");
                ArrayList allMainType = (ArrayList) request.getAttribute("allMainType");
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

                String compareDateMsg , beginDateMsg, endDateMsg;
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
                    brand = "By Brand";
                    maintenance = "Maintenance";
                    emrgancy = "Emergency";
                    notEmergancy = "Periodic";
                    closed = "Closed";
                    canceled = "Canceled";
                    assigned = "In Progress";
                    title = "Report Details Maintenance";
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
                    brand = "&#1576;&#1600;&#1600;&#1600; &#1575;&#1604;&#1605;&#1600;&#1600;&#1600;&#1575;&#1585;&#1603;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1577;";
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
                    title = "&#1578;&#1602;&#1585;&#1610;&#1585; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577; &#1575;&#1604;&#1578;&#1601;&#1589;&#1610;&#1604;&#1609;";
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
                }
    %>

    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Doc Viewer- Select Project and Status</TITLE>
        <script type="text/javascript" src="js/wz_tooltip.js"></script>
        <script type="text/javascript" src="js/tip_centerwindow.js"></script>
        <script type="text/javascript" src="js/tip_balloon.js"></script>
        <script type="text/javascript" src="js/tip_followscroll.js"></script>
        <script type="text/javascript" src="js/common.js"></script>
        <script type="text/javascript" src="js/silkworm_validate.js"></script>
        <script type="text/javascript" src="js/getEquipmentsList.js"></script>
        <script type="text/javascript" src="js/datepicker_limit.js"></script>
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
                document.getElementById('fMaintNum').focus();
                showHide('mainTypeRadio');
            }
            var mainTypeAll = "no";
            var siteAll = "no";
            var brandAll = "no";
            var tradeAll = "no";
            function submitForm()
            {
                var other = document.getElementById("Other");
                if(other.checked)
                {
                    var searchBy = getSearchBy();
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
                    } else if (document.getElementById('site').value == "") {
                        alert("Please Select Site");
                        document.SEARCH_MAINTENANCE_FORM.site.foucs();
                        return;
                    } else if(document.getElementById('mainTypeRadio').checked && document.getElementById('maintype').value == "") {
                        alert("Please Select Main Type");
                        document.SEARCH_MAINTENANCE_FORM.maintype.focus();
                        return;
                    } else if(document.getElementById('brandRadio').checked && document.getElementById('brand').value == "") {
                        alert("Please Select Brand");
                        document.SEARCH_MAINTENANCE_FORM.brand.focus();
                        return;
                    } else if(document.getElementById('trade').value == "") {
                        alert("Please Select Trade");
                        document.SEARCH_MAINTENANCE_FORM.trade.focus();
                        return;
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
                    document.SEARCH_MAINTENANCE_FORM.action = "PDFReportServlet?op=resulSearchMaintenanceDetails&mainTypeAll=" + mainTypeAll + "&siteAll=" + siteAll + "&brandAll=" + brandAll + "&tradeAll=" + tradeAll + "&searchBy=" + searchBy;
                }
                else
                {
                    var from = document.getElementById("fMaintNum").value;
                    var to = document.getElementById("tMaintNum").value;
                    if(!IsNumericInt("fMaintNum") || from=="")
                    {
                        return false
                    }
                    if(!IsNumericInt("tMaintNum") || to=="")
                    {
                        return false;
                    }
                    if(from > to){
                        alert("from must be less than to");
                        return false;
                    }
                    document.SEARCH_MAINTENANCE_FORM.action = "PDFReportServlet?op=resultSearchMaintenanceDetailsFromTo&from=" + from + "&to=" + to;
                }
                openCustom('');
                document.SEARCH_MAINTENANCE_FORM.target = "window_chaild";
                document.SEARCH_MAINTENANCE_FORM.submit();
            }
            
            function openCustom(url)
            {
                openCustomDialog(url, "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width=850, height=400");
            }
            
            function cancelForm()
            {
                document.SEARCH_MAINTENANCE_FORM.target = "";
                document.SEARCH_MAINTENANCE_FORM.action = "<%=context%>/main.jsp;";
                document.SEARCH_MAINTENANCE_FORM.submit();
            }

            function back()
            {
                document.SEARCH_MAINTENANCE_FORM.target = "";
                document.SEARCH_MAINTENANCE_FORM.action = "<%=context%>/ReportsServlet?op=mainPage";
                document.SEARCH_MAINTENANCE_FORM.submit();
            }

            function compareDate()
            {
                return Date.parse(document.getElementById("endDate").value) >= Date.parse(document.getElementById("beginDate").value);
            }
        
            function getSearchBy() {
                var selectEquip = document.getElementsByName("selectEquip");
                for(var i = 0; i < selectEquip.length; i++) {
                    if(selectEquip[i].checked) {
                        return selectEquip[i].value;
                    }
                }

                return "maintype";
            }
     
            function getMaintype(){
                var mainTypeValues = "";
                var maintype = document.getElementById('maintype');
                for(var i = 0 ;i<maintype.options.length;i++){
                    if(maintype.options[i].selected){
                        mainTypeValues = mainTypeValues  + maintype.options[i].value + " ";
                    }
                }
            
                return mainTypeValues;
            }

            function getAllSites(){
                var sitesValues = "";
                var sites = document.getElementById('site');
                for(var i = 1 ;i<sites.options.length;i++){
                    sitesValues = sitesValues  + sites.options[i].value + " ";
                }
                return sitesValues;
            }

            function getBrand(){
                var brandValues = "";
                var brand = document.getElementById('brand');
                for(var i = 0 ;i<brand.options.length;i++){
                    if(brand.options[i].selected){
                        brandValues = brandValues  + brand.options[i].value + " ";
                    }
                }
                return brandValues;
            }

            function getAllBrand(){
                var brandValues = "";
                var brand = document.getElementById('brand');
                for(var i = 1 ;i<brand.options.length;i++){
                    brandValues = brandValues  + brand.options[i].value + " ";
                }
                return brandValues;
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
     
            function getIssueTitle(){
                var issueTitleValues = "";
                var issueTitle = document.getElementsByName('issueTitle');
         
                for(var i = 0; i < issueTitle.length; i++){
                    if(issueTitle[i].checked){
                        issueTitleValues = issueTitle[i].value;
                    }
                }
                return issueTitleValues;
            }
     
            function getCurrentStatus(){
                var currentStatusValues = "";
                var currenStatus = document.getElementsByName('currenStatus');

                for(var i = 0; i < currenStatus.length; i++){
                    if(currenStatus[i].checked){
                        currentStatusValues = currentStatusValues + currenStatus[i].value + " ";
                    }
                }
                return currentStatusValues;
            }

            function textChange(textBox){
                document.getElementById(textBox).value = "";
            }

            function getEquipment(){
                sitesValues = "";
                var sites = document.getElementById('site');
                var count = 0;

                for(var i = 0 ;i<sites.options.length;i++){
                    if(sites.options[i].selected){
                        sitesValues = sitesValues  + sites.options[i].value + " ";
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
    
            function getTask(){
                var formName = document.getElementById('SEARCH_MAINTENANCE_FORM').getAttribute("name");
                var name = document.getElementById('taskName').value;
                var res = "";
                for (i=0;i < name.length; i++) {
                    res += name.charCodeAt(i) + ',';
                }
                res = res.substr(0, res.length - 1);
                openWindow('ReportsServlet?op=listTasks&fieldName=TASK_NAME&fieldValue='+res+'&formName='+formName);
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
                chaild_window = window.open(url, "chaild_window", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width=850, height=400");
                chaild_window.focus();
            }

            function showHide(id){
                var divUnit = document.getElementById('divUnit');
                var divMainType = document.getElementById('divMainType');
                var divBrand = document.getElementById('divBrand');
                if(id == 'mainTypeRadio') {
                    divMainType.style.display = "block";
                    divUnit.style.display = "none";
                    divBrand.style.display = "none";
                } else if(id == 'brandRadio') {
                    divBrand.style.display = "block";
                    divUnit.style.display = "none";
                    divMainType.style.display = "none";
                } else {
                    divUnit.style.display = "block";
                    divMainType.style.display = "none";
                    divBrand.style.display = "none";
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
            
            function changeMode(id) {
                if(document.getElementById(id).style.display == 'none'){
                    document.getElementById(id).style.display = 'block';
                } else {
                    document.getElementById(id).style.display = 'none';
                }
            }

        </script>
        <style type="text/css">
        #showHide{
            /*background: #0066cc;*/
            border: none;
            padding: 10px;
            font-size: 16px;
            font-weight: bold;
            color: #0066cc;
            cursor: pointer;
            padding: 5px;
        }
        #dropDown{
            position: relative;
        }
        .backStyle{
            border-bottom-width:0px;
            border-left-width:0px;
            border-right-width:0px;
            border-top-width:0px
        }
    </style>

    </HEAD>
    
    <BODY STYLE="background-color:#E8E8E8">
        <FORM action=""  NAME="SEARCH_MAINTENANCE_FORM" METHOD="POST">
            <input type="hidden" name="search" value="search" />
            <DIV DIR="LTR" style="padding-left: 2.5%; padding-bottom: 10px" >
                <input type="button" style="font-size:15px;font-weight:bold"  value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
                &ensp;
                <button onclick="JavaScript:back();" class="button" style="font-size:15px;font-weight:bold"><%=back%></button>
            </DIV>
            <CENTER>
                <FIELDSET class="set" style="width:95%;border-color: #006699;" >
                    <TABLE class="blueBorder" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                        <TR>
                            <TD style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD">
                                <font color="#F3D596" size="4"><%=title%></font>
                            </TD>
                        </TR>
                    </TABLE>
                    <br>
                    <div align="<%=align%>" style="margin-<%=align%>: 5%;color: blue">
                        <p dir="<%=dir%>" align="align" style="background-color: #E6E6FA;width:40%;font-weight: bold;font-size: 16px;padding-top: 2px;padding-bottom: 2px;padding-left: 5px;padding-right: 5px"><b><input type="radio" value="MaintNum" name="choice" id="Maint" onclick="showHide2(this.id)" checked/>&ensp;<%=fromMaintTo%>&ensp;</b></p>
                    </div>
                    <TABLE id="MaintNum" ALIGN="center" DIR="<%=dir%>" WIDTH="90%" CELLSPACING=0 CELLPADDING=0 BORDER="0" style="display: block;">
                        <TR>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E8E8E8"  valign="MIDDLE" COLSPAN="5" >
                                &ensp;
                            </TD>
                        </TR>
                        <TR>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E8E8E8"  valign="MIDDLE" WIDTH="2%">
                                &ensp;
                            </TD>
                            <TD class="backgroundHeader" STYLE="border-left-WIDTH:1px;text-align:<%=align%>;padding-<%=align%> : 10px" WIDTH="14%">
                                <b><font size=3 color="black"><%=fMaintNum%></font></b>
                            </TD>
                            <TD style="text-align:center;font:bold 15px;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E8E8E8"  valign="MIDDLE" WIDTH="35%">
                                <input type="text" name="fMaintNum" id="fMaintNum" style="width: 90%"/>
                            </TD>
                            <TD class="backgroundHeader"  STYLE="border-left-WIDTH:1px;text-align:<%=align%>;padding-<%=align%> : 10px;" WIDTH="14%">
                                <b> <font size=3 color="black"><%=tMaintNum%></font> </b>
                            </TD>
                            <TD  bgcolor="#E8E8E8"  style="text-align:center;padding:5px;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" valign="middle" WIDTH="35%">
                                <input type="text" name="tMaintNum" id="tMaintNum" style="width: 90%"/>
                            </TD>
                        </TR>
                        <TR>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E8E8E8"  valign="MIDDLE" COLSPAN="5" >
                                &ensp;
                            </TD>
                        </TR>
                    </TABLE>
                    <br>
                    <div align="<%=align%>" style="margin-<%=align%>: 5%; padding-bottom: 5px; color: blue">
                        <p dir="<%=dir%>" align="align" style="background-color: #E6E6FA;width:40%;font-weight: bold;font-size: 16px;padding-top: 2px;padding-bottom: 2px;padding-left: 5px;padding-right: 5px"><b><input type="radio" value="Other" name="choice" id="Other" onclick="showHide2(this.id)">&ensp;<%=others%>&ensp;</b></p>
                    </div>
                    <TABLE id="Others" BGCOLOR="#E8E8E8" ALIGN="center" DIR="<%=dir%>" WIDTH="90%" CELLSPACING=5 CELLPADDING=0 BORDER="0" style="display: none;">
                        <TR>
                            <TD CLASS="backStyle" style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E8E8E8"  valign="MIDDLE" COLSPAN="5" >
                                &ensp;
                            </TD>
                        </TR>
                        <TR>
                            <TD CLASS="backStyle" style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E8E8E8"  valign="MIDDLE" WIDTH="2%">
                                &ensp;
                            </TD>
                            <TD class="backgroundHeader" STYLE="border-left-WIDTH:1px;text-align:center;padding:5px" WIDTH="17%">
                                <b style="text-align:<%=align%>;padding-<%=align%> : 10px"><font size=3 color="black"><input type="radio" id="mainTypeRadio" value="maintype" name="selectEquip" checked onclick="JavaScript:showHide(this.id);" /><%=mainType%></font></b>
                            </TD>
                            <TD BGCOLOR="#E8E8E8" STYLE="border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px;text-align:center;padding:5px" WIDTH="33%">
                                <DIV ID="divMainType">
                                    <select name="mainType" id="maintype" multiple size="5" style="font-size:12px; font-weight:bold; width:100%" onchange="selectAllElements(this.id)">
                                        <option value="selectAll" style="color:#989898;font-weight:bold;font-size:16px"><%=selectAll%></option>
                                        <sw:WBOOptionList wboList="<%=allMainType%>" displayAttribute="typeName" valueAttribute="id" />
                                    </select>
                                </DIV>
                            </TD>
                            <TD ROWSPAN="3" class="backgroundHeader" STYLE="border-left-WIDTH:1px;text-align:center;padding:5px" WIDTH="17%">
                                <b><font size=3 color="black"><%=site%></font></b>
                            </TD>
                            <TD ROWSPAN="3" BGCOLOR="#E8E8E8" STYLE="border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px;text-align:center;padding:5px" WIDTH="33%">
                                 <div id='projectScroll' style="width:100%; height: 200px; overflow:auto;">
                                    <jsp:include page="/docs/new_search/project_checkbox_list.jsp" flush="true"/>
                                </div>
                            </TD>
                        </TR>
                        <TR>
                            <TD CLASS="backStyle" style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E8E8E8"  valign="MIDDLE" WIDTH="2%">
                                &ensp;
                            </TD>
                            <TD class="backgroundHeader" STYLE="text-align:center;padding:5px" WIDTH="17%">
                                <b><font size=3 color="black"><input type="radio" id="brandRadio" value="brand" name="selectEquip" onclick="JavaScript:showHide(this.id);" /><%=brand%></font></b>
                            </TD>
                            <TD BGCOLOR="#E8E8E8" STYLE="border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px;text-align:center;padding:5px" WIDTH="33%">
                                <DIV ID="divBrand">
                                    <select name="brand" id="brand" multiple size="5" style="font-size:12px;font-weight:bold;width:100%" onchange="selectAllElements(this.id)">
                                        <option value="selectAll" style="color:#989898;font-weight:bold;font-size:16px"><%=selectAll%></option>
                                        <sw:WBOOptionList wboList="<%=parents%>" displayAttribute="unitName" valueAttribute="id" />
                                    </select>
                                </DIV>
                            </TD>
                        </TR>
                        <TR>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E8E8E8"  valign="MIDDLE" WIDTH="2%">
                                &ensp;
                            </TD>
                            <TD class="backgroundHeader" STYLE="border-left-WIDTH:1px;text-align:center;padding:5px" WIDTH="13%">
                                <b><font size=3 color="black"><input type="radio" id="unit" value="unit" name="selectEquip" onclick="JavaScript:showHide(this.id);" /><%=nameEquip%></font></b>
                            </TD>
                            <%--<TD style="text-align:center;font:bold 15px;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E8E8E8"  valign="MIDDLE" >
                                <DIV ID="divUnit">
                                    <input type="text" name="unitName" id="unitName" onchange="JavaScript:textChange('unitId')" style="width:77%;text-align:center" />
                                    <input type="button" class="button" name="search" id="search" value="<%=select%>" onclick="JavaScript:getEquipment()" STYLE="height: 25px;font-size:15px;font-weight:bold;width:60px" />
                                    <input type="hidden" name="unitId" id="unitId" />
                                </DIV>
                            </TD>--%>
                            <td style="text-align:center;font:bold 15px;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E8E8E8"  valign="MIDDLE" >
                                <DIV ID="divUnit" style="display: none;">
                                    <input type="hidden" name="unitId" value="" id="unitId" />
                                    <input type="text" name="unitName" id="unitName" value="<%--=sName--%>" onclick="return getEquipmentInPopup();" />
                                    &nbsp;&nbsp;
                                    <%--<button id="btnSearch" value="" style="text-align: <%=align%>;" onclick="return getDataInPopup('ReportsServletThree?op=ListEquipments' + '&fieldName=UNIT_NAME&fieldValue=' + getASSCIChar(document.getElementById('unitName').value));" /><img src="images/refresh.png" alt="<%=searchLabel%>" align="middle" width="24" height="24"/></button>--%>
                                    <input class="button" type="button" name="search" id="search" value="<%=select%>" onclick="return getEquipmentInPopup();"  STYLE="font-size:15;font-weight:bold;width:60px" />
                                </DIV>
                            </td>
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
                            <TD class="backgroundHeader" STYLE="border-left-WIDTH:1px;text-align:center;padding:5px" WIDTH="13%">
                                <b><font size=3 color="black"><%=tradeName%></font></b>
                            </TD>
                            <TD BGCOLOR="#E8E8E8" STYLE="border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px;text-align:center;padding:5px" WIDTH="35%">
                                <select name="trade" id="trade" multiple style="font-size:12px;font-weight:bold;width:100%" onchange="selectAllElements(this.id)">
                                    <option value="selectAll" style="color:#989898"><%=selectAll%></option>
                                    <sw:WBOOptionList wboList="<%=allTrade%>" displayAttribute="tradeName" valueAttribute="tradeId" />
                                </select>
                            </TD>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E8E8E8"  valign="MIDDLE" COLSPAN="2" >
                                &ensp;
                            </TD>
                        </TR>
                        <TR>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E8E8E8"  valign="MIDDLE" WIDTH="2%">
                                &ensp;
                            </TD>
                            <TD class="backgroundHeader" STYLE="border-left-WIDTH:1px;text-align:center;padding:5px" WIDTH="13%">
                                <b><font size=3 color="black"><%=task%></font></b>
                            </TD>
                            <TD style="text-align:center;font:bold 15px;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E8E8E8"  valign="MIDDLE" >
                                <input type="text" name="taskName" id="taskName" onchange="JavaScript:textChange('taskId')" style="width:77%;text-align:center" />
                                <input type="button" class="button" name="search" id="search" value="<%=select%>" onclick="JavaScript:getTask()" STYLE="height: 25px;font-size:15px;font-weight:bold;width:60px" />
                                <input type="hidden" name="taskId" id="taskId" />
                            </TD>
                            <TD  class="backgroundHeader" STYLE="border-left-WIDTH:1px;text-align:center;padding:5px" WIDTH="15%">
                                <b><font size=3 color="black"><%= beginDate%></font></b>
                            </TD>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E8E8E8"  valign="MIDDLE" >
                                <input readonly id="beginDate" name="beginDate" type="text" value="<%=nowTime%>" style="width: 90%" ><img alt=""  src="images/showcalendar.gif" onmouseover="Tip('<%=calenderTip%>',CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#FFFF99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7, TITLE ,'Display Calender Help',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'White', TITLEBGCOLOR ,'#6699FF')" onmouseout="UnTip()" >
                            </TD>
                        </TR>
                        <TR>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E8E8E8"  valign="MIDDLE" WIDTH="2%">
                                &ensp;
                            </TD>
                            <TD class="backgroundHeader" STYLE="border-left-WIDTH:1px;text-align:center;padding:5px" WIDTH="13%">
                                <b><font size=3 color="black"><%=item%></font></b>
                            </TD>
                    
                            <TD style="text-align:center;font:bold 15px;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E8E8E8"  valign="MIDDLE" >
                                <input type="text" name="sparePart" id="sparePart" onchange="JavaScript:textChange('partId')" style="width:77%;text-align:center" />
                                <input type="button" class="button" name="search" id="search" value="<%=select%>" onclick="JavaScript:getItems()" STYLE="height: 25px;font-size:15px;font-weight:bold;width:60px" />
                                <input type="hidden" name="partId" id="partId" />
                            </TD>
                            <TD class="backgroundHeader"  STYLE="border-left-WIDTH:1px;text-align:center;" WIDTH="15%">
                                <b> <font size=3 color="black"><%= endDate%></font> </b>
                            </TD>
                            <TD  bgcolor="#E8E8E8"  style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" valign="middle">
                                <input readonly id="endDate" name="endDate" type="text" value="<%=nowTime%>" style="width: 90%" ><img alt=""  src="images/showcalendar.gif" onmouseover="Tip('<%=calenderTip%>',CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#FFFF99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7, TITLE ,'Display Calender Help',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'White', TITLEBGCOLOR ,'#6699FF')" onmouseout="UnTip()" >
                            </TD>
                        </TR>
                        <TR>
                            <TD CLASS="backStyle" style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E8E8E8"  valign="MIDDLE" COLSPAN="5" >
                                &ensp;
                            </TD>
                        </TR>
                        <TR>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E8E8E8"  valign="MIDDLE" WIDTH="2%">
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
                        <TR>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E8E8E8"  valign="MIDDLE" WIDTH="2%">
                                &ensp;
                            </TD>
                            <TD colspan="5" style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E8E8E8"  valign="MIDDLE" WIDTH="2%">
                                <div id="dropDown">
                                    <div onclick="JavaScript: changeMode('showHideTable');" id="showHide" style="text-align:<%=align%>;"><img id="showHideImg" src="images/317e0s5.gif" /><%=moreOptionsLabel%></div>
                                    <div id="showHideTable" style="display: none; padding-bottom:5px;">
                                        <table ALIGN="center" DIR="<%=dir%>" WIDTH="100%" CELLSPACING=0 CELLPADDING=0 BORDER="0">
                                            <tr>
                                                <TD class="backgroundHeader" STYLE="border-left-WIDTH:1px;text-align:center;padding:5px" WIDTH="13%">
                                                    <b><font size=3 color="black"><%=orderByLabel%></font></b>
                                                </TD>
                                                <TD colspan="2" DIR="<%=dir%>" style="text-align:<%=align%>;font:bold 15px;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E8E8E8"  valign="MIDDLE" >
                                                    <input type="radio" name="orderType" id="orderType" checked value="ASC" /><%=ASCLabel%><br />
                                                    <input type="radio" name="orderType" id="orderType" value="DESC" /><%=DESCLabel%>
                                                </TD>
                                                <TD class="backgroundHeader" STYLE="border-left-WIDTH:1px;text-align:center;padding:5px" WIDTH="13%">
                                                    <b><font size=3 color="black"><%=dateTypeLabel%></font></b>
                                                </TD>
                                                <TD  DIR="<%=dir%>" style="text-align:<%=align%>;font:bold 15px;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E8E8E8"  valign="MIDDLE" >
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
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E8E8E8"  valign="MIDDLE" COLSPAN="5" >
                                &ensp;
                            </TD>
                        </TR>
                    </TABLE>
                    <br>
                    <TABLE BGCOLOR="#E8E8E8" ALIGN="center" DIR="<%=dir%>" WIDTH="90%" CELLSPACING=10 CELLPADDING=0 BORDER="0" style="display: block;">
                        <TR>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E8E8E8"  valign="MIDDLE" >
                                <button onclick="JavaScript: submitForm();" class="button" STYLE="font-size:15px;font-weight:bold; width: 150px"><%=search%></button>
                                &ensp;
                                <button class="button" onclick="JavaScript: cancelForm();" STYLE="font-size:15px;font-weight:bold; "><%=cancel%></button>
                            </TD>
                        </TR>
                    </TABLE>
                    <br>
                </FIELDSET>
            </CENTER>
        </FORM>
    </BODY>
</HTML>
