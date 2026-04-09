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
      
        ArrayList allTrade = (ArrayList) request.getAttribute("allTrade");
        ArrayList allMainType = (ArrayList) request.getAttribute("allMainType");
        ArrayList parents = (ArrayList) request.getAttribute("parents");

        //get session logged user and his trades
        WebBusinessObject user = (WebBusinessObject) session.getAttribute("loggedUser");

        // get current defaultLocationName
        String defaultLocationName = (String) request.getAttribute("defaultLocationName");

        // get current date
        Calendar cal = Calendar.getInstance();
        String jDateFormat = user.getAttribute("javaDateFormat").toString();
        SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
        String nowTime = sdf.format(cal.getTime());

        String cMode = (String) request.getSession().getAttribute("currentMode");
        String stat = cMode;

  String item, beginDate, task, endDate, search, cancel, others, calenderTip, tradeName, nameEquip, mainType, site, divAlign,
                dir, lang, langCode, fromMaintTo, fMaintNum, tMaintNum, title, selectAll, select, back, laborDetailed, maintenance, emrgancy, notEmergancy, brand;

  String ASCLabel, DESCLabel, actualBeginDateLabel, actualEndDateLabel, textAlign, issueTitleLabel, currentStausLabel, orderByLabel, dateTypeLabel, moreOptionsLabel,pageTitle, doc;
  String compareDateMsg , beginDateMsg, endDateMsg;
  String selectByCode, selectByName;
        if (stat.equals("En")) {
            lang = "   &#1593;&#1585;&#1576;&#1610;    ";
            langCode = "Ar";
            laborDetailed = "With Labor Detail";
            dir = "LTR";
            divAlign = "left";
            task = "Task";
            item = "Item";
            beginDate = "From Actual Begin Date";
            endDate = "To Actual Begin Date";
            search = "Export Report";
            cancel = "Cancel";
            others = "Advanced Search";
            calenderTip = "click inside text box to opn calender window";
            tradeName = "Maintenance Type";
            nameEquip = "By Equipment";
            site = "Site";
            mainType = "By Main Type";
            brand = "By Brand";
            fMaintNum = "From";
            tMaintNum = "To";
            fromMaintTo = "From Maint Num To Maint Num";
            title = "Internal Maintenance Cost";
            selectAll = "All";
            select = "Select";
            back = "Back";
            maintenance = "Maintenance";
            emrgancy = "Emergency";
            notEmergancy = "Periodic";
            ASCLabel = "ASC";
            DESCLabel = "DESC";
            actualBeginDateLabel = "Begin Date";
            actualEndDateLabel = "End Date";
            issueTitleLabel = "Issue Title";
            currentStausLabel = "Current Status";
            orderByLabel = "Order By";
            dateTypeLabel = "Date Type";
            moreOptionsLabel = "More Options";
            pageTitle = "Report Code: M_COST_1";
            doc = "View Details";
            compareDateMsg = "End Actual End Date must be greater than or equal start actual Begin Date";
            endDateMsg = "End Actual End Date must be less than or equal today Date";
            beginDateMsg = "Strat Actual Begin Date must be less than or equal today Date";
            selectByCode = "Select By Code";
            selectByName = "Select By Name";
        } else {
            lang = "   English    ";
            langCode = "En";
            laborDetailed = "&#1576;&#1600;&#1600; &#1578;&#1601;&#1589;&#1610;&#1604; &#1575;&#1604;&#1593;&#1605;&#1575;&#1604;&#1577;";
            dir = "RTL";
            divAlign = "right";
            task = "&#1576;&#1606;&#1583; &#1589;&#1610;&#1575;&#1606;&#1577;";
            item = "&#1602;&#1591;&#1593; &#1594;&#1610;&#1575;&#1585;";
            beginDate = "&#1605;&#1606; &#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1576;&#1583;&#1569; &#1575;&#1604;&#1601;&#1593;&#1604;&#1610;";
            endDate = "&#1573;&#1604;&#1610; &#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1576;&#1583;&#1569; &#1575;&#1604;&#1601;&#1593;&#1604;&#1610;";
            search = "&#1575;&#1587;&#1578;&#1582;&#1585;&#1575;&#1580; &#1575;&#1604;&#1578;&#1602;&#1585;&#1610;&#1585;";
            cancel = tGuide.getMessage("cancel");
            calenderTip = "&#1575;&#1590;&#1594;&#1591; &#1583;&#1575;&#1582;&#1604; &#1575;&#1604;&#1605;&#1587;&#1578;&#1591;&#1610;&#1604; &#1604;&#1603;&#1609; &#1610;&#1592;&#1607;&#1585; &#1604;&#1603; &#1606;&#1575;&#1601;&#1584;&#1607; &#1604;&#1571;&#1582;&#1578;&#1610;&#1575;&#1585; &#1575;&#1604;&#1578;&#1575;&#1585;&#1610;&#1582;";
            others = "&#1576;&#1581;&#1600;&#1600;&#1579; &#1605;&#1600;&#1578;&#1600;&#1602;&#1600;&#1583;&#1605;";
            tradeName = "&#1606;&#1608;&#1593; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
            site = "&#1575;&#1604;&#1605;&#1608;&#1602;&#1593;";
            mainType = "&#1576;&#1600;&#1600;&#1600; &#1575;&#1604;&#1606;&#1600;&#1600;&#1608;&#1593; &#1585;&#1574;&#1610;&#1600;&#1600;&#1587;&#1609;";
            brand = "&#1576;&#1600;&#1600;&#1600; &#1575;&#1604;&#1605;&#1600;&#1600;&#1600;&#1575;&#1585;&#1603;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1577;";
            nameEquip = "&#1576;&#1600;&#1600;&#1600; &#1575;&#1604;&#1605;&#1600;&#1600;&#1600;&#1600;&#1593;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1583;&#1577;";
            fMaintNum = "&#1605;&#1606;";
            tMaintNum = "&#1575;&#1604;&#1609;";
            fromMaintTo = "&#1605;&#1606; &#1585;&#1602;&#1605; &#1589;&#1610;&#1575;&#1606;&#1577; &#1575;&#1604;&#1609; &#1585;&#1602;&#1605; &#1589;&#1610;&#1575;&#1606;&#1577;";
            selectAll = "&#1603;&#1600;&#1600;&#1600;&#1604;";
            select = "&#1575;&#1582;&#1578;&#1610;&#1575;&#1585;";
            back = "&#1585;&#1580;&#1608;&#1593;";
            //title = "&#1578;&#1603;&#1604;&#1601;&#1577; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577; &#1575;&#1604;&#1583;&#1575;&#1582;&#1604;&#1610;&#1577;";
            title = "تكلفة الصيانة الداخلية";
            maintenance = "&#1589;&#1610;&#1575;&#1606;&#1577;";
            emrgancy = "&#1591;&#1575;&#1585;&#1574;&#1577;";
            notEmergancy = "&#1583;&#1608;&#1585;&#1610;&#1577;";
            ASCLabel = "&#1578;&#1589;&#1575;&#1593;&#1583;&#1610;";
            DESCLabel = "&#1578;&#1606;&#1575;&#1586;&#1604;&#1610;";
            actualBeginDateLabel = "&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1576;&#1583;&#1569; &#1575;&#1604;&#1601;&#1593;&#1604;&#1610;";
            actualEndDateLabel = "&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1573;&#1606;&#1578;&#1607;&#1575;&#1569; &#1575;&#1604;&#1601;&#1593;&#1604;&#1610;";
            issueTitleLabel = "&#1593;&#1606;&#1608;&#1575;&#1606; &#1575;&#1604;&#1605;&#1588;&#1603;&#1604;&#1577;";
            currentStausLabel = "&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
            orderByLabel = "&#1606;&#1608;&#1593; &#1575;&#1604;&#1578;&#1585;&#1578;&#1610;&#1576;";
            dateTypeLabel = "&#1606;&#1608;&#1593; &#1575;&#1604;&#1578;&#1575;&#1585;&#1610;&#1582;";
            moreOptionsLabel = "&#1578;&#1601;&#1575;&#1589;&#1610;&#1604; &#1571;&#1582;&#1585;&#1610;";
            pageTitle = "Report Code: M_COST_1";
            doc = "&#1593;&#1585;&#1590; &#1575;&#1604;&#1578;&#1601;&#1575;&#1589;&#1610;&#1604;";
            compareDateMsg = " \u0646\u0647\u0627\u064A\u0629 \u062A\u0627\u0631\u064A\u062E \u0627\u0644\u0628\u062F\u0621 \u0627\u0644\u0641\u0639\u0644\u064A \u064A\u062C\u0628 \u0623\u0646 \u064A\u0643\u0648\u0646 \u0623\u0643\u0628\u0631 \u0645\u0646 \u0623\u0648 \u064A\u0633\u0627\u0648\u064A \u0628\u062F\u0627\u064A\u0629 \u062A\u0627\u0631\u064A\u062E \u0627\u0644\u0628\u062F\u0621 \u0627\u0644\u0641\u0639\u0644\u064A";
            endDateMsg = "\u0646\u0647\u0627\u064A\u0629 \u062A\u0627\u0631\u064A\u062E \u0627\u0644\u0628\u062F\u0621 \u0627\u0644\u0641\u0639\u0644\u064A \u064A\u062C\u0628 \u0623\u0646 \u064A\u0643\u0648\u0646 \u0623\u0642\u0644 \u0645\u0646 \u0623\u0648 \u064A\u0633\u0627\u0648\u064A \u062A\u0627\u0631\u064A\u062E \u0627\u0644\u064A\u0648\u0645";
            beginDateMsg = "\u0628\u062F\u0627\u064A\u0629 \u062A\u0627\u0631\u064A\u062E \u0627\u0644\u0628\u062F\u0621 \u0627\u0644\u0641\u0639\u0644\u064A \u064A\u062C\u0628 \u0623\u0646 \u064A\u0643\u0648\u0646 \u0623\u0642\u0644 \u0645\u0646 \u0623\u0648 \u064A\u0633\u0627\u0648\u064A \u062A\u0627\u0631\u064A\u062E \u0627\u0644\u064A\u0648\u0645";

            selectByCode = "إختيار بالكود";
            selectByName = "إختيار بالإسم";
        }
    %>

    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Doc Viewer- Select Project and Status</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/CSS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/Button.css">
        <script src='ChangeLang.js' type='text/javascript'></script>
        <script type="text/javascript" src="js/wz_tooltip.js"></script>
        <script type="text/javascript" src="js/tip_centerwindow.js"></script>
        <script type="text/javascript" src="js/tip_balloon.js"></script>
        <script type="text/javascript" src="js/tip_followscroll.js"></script>
        <script type="text/javascript" src="js/common.js"></script>
        <script type="text/javascript" src="js/silkworm_validate.js"></script>
        <script type="text/javascript" src="js/getEquipmentsList.js"></script>
        <link rel="stylesheet" type="text/css" href="css/epoch_styles.css" />
        <script type="text/javascript" src="js/epoch_classes.js"></script>
        <script type="text/javascript" src="js/datepicker_limit.js"></script>

       <script LANGUAGE="JavaScript" TYPE="text/javascript">
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

        function submitForm(){
            var url;
            if(document.getElementById("Other").checked){
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
                    return false;
                } else if(document.getElementById('trade').value == ""){
                    alert("Please select Trade type")
                    document.SEARCH_MAINTENANCE_FORM.trade.focus();
                    return false;
                } else if(document.getElementById('mainTypeRadio').checked && document.getElementById('maintype').value == ""){
                    alert("please select main type");
                    document.SEARCH_MAINTENANCE_FORM.maintype.focus();
                    return false;
                } else if(document.getElementById('brandRadio').checked && document.getElementById('brand').value == ""){
                    alert("please select brand");
                    document.SEARCH_MAINTENANCE_FORM.brand.focus();
                    return false;
                }

                url = "<%=context%>/PDFReportServlet?op=resultCostByAvgJO";
                
            }
            else{
                var from = document.getElementById("fMaintNum").value;
                var to = document.getElementById("tMaintNum").value;
                if(!IsNumericInt("fMaintNum") || from=="")
                {
                    return false
                }
                if(!IsNumericInt("tMaintNum"))
                {
                    return false;
                }
                if(to == "") {
                    to = from;
                    document.getElementById("tMaintNum").value = to;
                }
                if(from > to){
                    alert("from must be less than to");
                    return false;
                }

                url = "<%=context%>/PDFReportServlet?op=resultCostByAvgJOMaintNum";
                
            }
            
            open_Window('');
            document.SEARCH_MAINTENANCE_FORM.target = "window_chaild";
            document.SEARCH_MAINTENANCE_FORM.action = url;
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

        function getSearchBy() {
            var selectEquip = document.getElementsByName("selectEquip");
            for(var i = 0; i < selectEquip.length; i++) {
                if(selectEquip[i].checked) {
                    return selectEquip[i].value;
                }
            }

            return "maintype";
        }

        function viewLaborDetail() {
            if(document.getElementById('laborDetail').checked) {
                return "yes";
            }

            return "no";
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

        function getAllMainType(){
            var mainTypeValues = "";
            var maintype = document.getElementById('maintype');
            for(var i = 1 ;i<maintype.options.length;i++){
                mainTypeValues = mainTypeValues  + maintype.options[i].value + " ";
            }
            return mainTypeValues;
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
                openCustom('ReportsServletThree?op=selectEquipment&unitName='+res+'&formName='+formName+'&sites='+sitesValues);
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
            openCustom('ReportsServlet?op=listTasks&taskName='+res+'&formName='+formName);
        }

        function getItems(){
            var formName = document.getElementById('SEARCH_MAINTENANCE_FORM').getAttribute("name");
            var name = document.getElementById('sparePart').value;
            var res = "";
            for (i=0;i < name.length; i++) {
                res += name.charCodeAt(i) + ',';
            }
            res = res.substr(0, res.length - 1);
            openCustom('ReportsServletThree?op=selectItems&sparePart='+res+'&formName='+formName);
        }

        function openCustom(url)
        {
            openCustomDialog(url, "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width=850, height=400");
        }

        function open_Window(url)
        {
            var openedWindow = window.open(url,"window_chaild","toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width=850, height=400");
            openedWindow.focus();

        }

        function showHide(id){
            var divUnit = document.getElementById('divUnit');
            var unitName = document.getElementById('unitName');
            var unitId = document.getElementById('unitId');
            var brand = document.getElementById('brand');
            var maintype = document.getElementById('maintype');
            var divMainType = document.getElementById('divMainType');
            var divBrand = document.getElementById('divBrand');
            if(id == 'mainTypeRadio') {
                unitName.disabled = true;
                unitId.disabled = true;
                brand.disabled = true;
                maintype.disabled = false;
                divMainType.style.display = "block";
                divUnit.style.display = "none";
                divBrand.style.display = "none";
            } else if(id == 'brandRadio') {
                unitName.disabled = true;
                unitId.disabled = true;
                brand.disabled = false;
                maintype.disabled = true;
                divBrand.style.display = "block";
                divUnit.style.display = "none";
                divMainType.style.display = "none";
            } else {
                unitName.disabled = false;
                unitId.disabled = false;
                brand.disabled = true;
                maintype.disabled = true;
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
                //window.SEARCH_MAINTENANCE_FORM.site.multiple = true;
                document.getElementById(typeAllId).value = "yes";
                option[0].selected = false;
                for(var i = 1; i<length; i++){
                    option[i].selected = true;
                }
            } else {
                
                //window.SEARCH_MAINTENANCE_FORM.site.multiple = false;
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
        function changeMode(id){
            if(document.getElementById(id).style.display == 'none'){
                document.getElementById(id).style.display = 'block';
            } else {
                document.getElementById(id).style.display = 'none';
            }
        }
        function openWindow(url) {
            window.open(url,"_blank","toolbar=no, location=no, directories=no, status=yes, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width=750, height=600");
        }
        function getFormDetails(code) {
            openWindow('SelfDocServlet?op=getFormDetails&formCode=' + code);
        }
        function IsNumericInt(id) {
            var ValidChars = "0123456789";
            var IsNumber=true;
            var Char;
            var sText=document.getElementById(id).value;

            for (var i = 0; i < sText.length && IsNumber == true; i++) {
                Char = sText.charAt(i);

                if (ValidChars.indexOf(Char) == -1) {
                    IsNumber = false;
                    alert("This Value { " + sText +" } must be positive integer and more than zero");
                    document.getElementById(id).value='';
                    document.getElementById(id).focus();
                }
            }

            return IsNumber;
        }

        function copyValue(control) {
            var toField = document.getElementById('tMaintNum');
            toField.value = control.value;
            toField.focus();
            
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
   <BODY STYLE="background-color:#ffffb9">
        <FORM NAME="SEARCH_MAINTENANCE_FORM" METHOD="POST">
            <DIV align="left" STYLE="color:blue;padding-left: 5%; padding-bottom: 10px">
                <input type="button"  value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
                &ensp;
                <button onclick="JavaScript:back();" class="button"><%=back%></button>
                <button  onclick="JavaScript: getFormDetails('TRNS_JO_LBR_AVG_COST');" class="button"> <%=doc%></button>
            </DIV>
            <CENTER>
                <FIELDSET class="set" style="width:90%;border-color: #006699;" >
                    <TABLE class="blueBorder" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                        <TR>
                            <TD dir="<%=dir%>" style="text-align:center;border-color: #006699;background-color: #ffcc66;" width="100%" class="blueBorder blueHeaderTD"><font color="#006699" size="4"><%=title%></font></TD>
                        </TR>
                    </TABLE>
                    <div style="text-align: left;">
                    <table>
                        <tr>
                            <td style="text-align: left;border: none;">
                                <font color="#FF385C" size="3" style="font-weight: bold;">
                                    <a id="mainLink"><%=pageTitle%> <img onmouseover="Tip('<%=title%>',CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#ffff99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'bold', SHADOW, true, SHADOWWIDTH, 7,TEXTALIGN ,'CENTER', TITLE ,'<%=title%>',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'White', TITLEBGCOLOR ,'#FF9900')"  onmouseout="UnTip()" width="30" height="25"  src="images/qm01.jpg" /></a>
                                </font>
                            </td>
                        </tr>
                    </table>
                    </div>
                    <br>
                    <div align="<%=divAlign%>" style="margin-<%=divAlign%>: 5%;color: blue">
                        <p dir="<%=dir%>" align="divAlign" style="background-color: #E6E6FA;width:40%;font-weight: bold;font-size: 16px;padding-top: 2px;padding-bottom: 2px;padding-left: 5px;padding-right: 5px">
                            <b><input type="radio" value="MaintNum" name="choice" id="Maint" onclick="showHide2(this.id)" checked/>&ensp;<%=fromMaintTo%>&ensp;</b>
                        </p>
                    </div>
                    <TABLE id="MaintNum" ALIGN="center" DIR="<%=dir%>" WIDTH="90%" CELLSPACING=0 CELLPADDING=0 BORDER="0" style="display: block;">
                        <TR>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#ffffb9"  valign="MIDDLE" COLSPAN="5" >
                                &ensp;
                            </TD>
                        </TR>
                        <TR>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#ffffb9"  valign="MIDDLE" WIDTH="2%">
                                &ensp;
                            </TD>
                            <TD class="backgroundHeader" STYLE="text-align:center;padding:5px" WIDTH="14%">
                                <b><font size=3 color="black"><%=fMaintNum%></font></b>
                            </TD>
                            <TD style="text-align:center;font:bold 15px;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#ffffb9"  valign="MIDDLE" WIDTH="35%">
                                <input type="text" name="from" id="fMaintNum" style="width: 90%" onBlur="copyValue(this);"/>
                            </TD>
                            <TD class="backgroundHeader" STYLE="text-align:center;" WIDTH="14%">
                                <b> <font size=3 color="black"><%=tMaintNum%></font> </b>
                            </TD>
                            <TD  bgcolor="#ffffb9"  style="text-align:center;padding:5px;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" valign="middle" WIDTH="35%">
                                <input type="text" name="to" id="tMaintNum" style="width: 90%"/>
                            </TD>
                        </TR>
                        <TR>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#ffffb9"  valign="MIDDLE" COLSPAN="5" >
                                &ensp;
                            </TD>
                        </TR>
                    </TABLE>
                    <br>
                    <div align="<%=divAlign%>" style="margin-<%=divAlign%>: 5%;color: blue">
                        <p dir="<%=dir%>" align="divAlign" style="background-color: #E6E6FA;width:40%;font-weight: bold;font-size: 16px;padding-top: 2px;padding-bottom: 2px;padding-left: 5px;padding-right: 5px">
                            <b><input type="radio" value="Other" name="choice" id="Other" onclick="showHide2(this.id)">&ensp;<%=others%>&ensp;</b>
                        </p>
                    </div>
                    <TABLE id="Others" BGCOLOR="#ffffb9" ALIGN="center" DIR="<%=dir%>" WIDTH="90%" CELLSPACING=5 CELLPADDING=0 BORDER="0" style="display: none;">
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
                                <b><font size=3 color="black"><input type="radio" id="mainTypeRadio" value="maintype" name="selectEquip" checked onclick="JavaScript:showHide(this.id);" /><%=mainType%></font></b>
                            </TD>
                            <TD BGCOLOR="#ffffb9" STYLE="border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px;text-align:center;padding:5px" WIDTH="33%">
                                <DIV ID="divMainType">
                                    <input type="hidden" id="mainTypeAll" name="mainTypeAll" value="no" />
                                    <select name="mainType" id="maintype" onchange="selectAllElements(this.id,'mainTypeAll');" multiple size="5" style="font-size:12px;font-weight:bold;width:100%">
                                        <option value="selectAll" style="color:#989898;font-weight:bold;font-size:16px"><%=selectAll%></option>
                                        <sw:WBOOptionList wboList="<%=allMainType%>" displayAttribute="typeName" valueAttribute="id" />
                                    </select>
                                </DIV>
                            </TD>
                            <TD class="backgroundHeader" ROWSPAN="3" STYLE="text-align:center;padding:5px" WIDTH="17%">
                                <b><font size=3 color="black"><%=site%></font></b>
                            </TD>
                            <TD ROWSPAN="3" BGCOLOR="#ffffb9" STYLE="border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px;text-align:center;padding:5px" WIDTH="33%">
                                <div id='projectScroll' style="width:100%; height: 200px; overflow:auto;">
                                    <jsp:include page="/docs/new_search/project_checkbox_list.jsp" flush="true"/>
                                </div>
                            </TD>
                        </TR>
                        <TR>
                            <TD CLASS="backStyle" style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#ffffb9"  valign="MIDDLE" WIDTH="2%">
                                &ensp;
                            </TD>
                            <TD class="backgroundHeader" STYLE="text-align:center;padding:5px" WIDTH="17%">
                                <b><font size=3 color="black"><input type="radio" id="brandRadio" value="brand" name="selectEquip" onclick="JavaScript:showHide(this.id);" /><%=brand%></font></b>
                            </TD>
                            <TD BGCOLOR="#ffffb9" STYLE="border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px;text-align:center;padding:5px" WIDTH="33%">
                                <DIV ID="divBrand">
                                    <input type="hidden" id="brandAll" name="brandAll" value="no"/>
                                    <select disabled onchange="selectAllElements(this.id,'brandAll');" name="brand" id="brand" multiple size="5" style="font-size:12px;font-weight:bold;width:100%">
                                        <option value="selectAll" style="color:#989898;font-weight:bold;font-size:16px"><%=selectAll%></option>
                                        <sw:WBOOptionList wboList="<%=parents%>" displayAttribute="unitName" valueAttribute="id" />
                                    </select>
                                </DIV>
                            </TD>
                        </TR>
                        <TR>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#ffffb9"  valign="MIDDLE" WIDTH="2%">
                                &ensp;
                            </TD>
                            <TD class="backgroundHeader" STYLE="text-align:center;padding:5px" WIDTH="13%">
                                <b><font size=3 color="black"><input type="radio" id="unit" value="unit" name="selectEquip" onclick="JavaScript:showHide(this.id);" /><%=nameEquip%></font></b>
                            </TD>
                            <%--<TD style="text-align:center;font:bold 15px;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#ffffb9"  valign="MIDDLE" >
                                <DIV ID="divUnit">
                                    <input type="text" name="unitName" id="unitName" onchange="JavaScript:textChange('unitId')" style="width:77%;text-align:center" />
                                    <input class="button" type="button" name="search" id="search" value="<%=select%>" onclick="JavaScript:getEquipment()" STYLE="height: 25px;font-size:15px;color:black;font-weight:bold;width:60px" />
                                    <input type="hidden" name="unitId" id="unitId" />
                                </DIV>
                            </TD>--%>
                            <td style="text-align:center;font:bold 15px;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#ffffb9"  valign="MIDDLE" >
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
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#ffffb9"  valign="MIDDLE" COLSPAN="5" >
                                &ensp;
                            </TD>
                        </TR>
                        <TR>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#ffffb9"  valign="MIDDLE" WIDTH="2%">
                                &ensp;
                            </TD>
                            <TD class="backgroundHeader" STYLE="text-align:center;padding:5px" WIDTH="13%">
                                <b><font size=3 color="black"><%=tradeName%></font></b>
                            </TD>
                            <TD BGCOLOR="#ffffb9" STYLE="border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px;text-align:center;padding:3px" WIDTH="35%">
                                <input type="hidden" id="tradeAll" name="tradeAll" value="no" />
                                <select name="trade" id="trade" onchange="selectAllElements(this.id,'tradeAll');" multiple size="3" style="font-size:12px;font-weight:bold;width:100%">
                                    <option value="selectAll" style="color:#989898" ><%=selectAll%></option>
                                    <sw:WBOOptionList wboList="<%=allTrade%>" displayAttribute="tradeName" valueAttribute="tradeId" />
                                </select>
                            </TD>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#ffffb9"  valign="MIDDLE" COLSPAN="2" >
                                &ensp;
                            </TD>
                        </TR>
                        <TR>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#ffffb9"  valign="MIDDLE" WIDTH="2%">
                                &ensp;
                            </TD>
                            <TD class="backgroundHeader" STYLE="text-align:center;padding:5px" WIDTH="13%">
                                <b><font size=3 color="black"><%=task%></font></b>
                            </TD>
                            <TD style="text-align:center;font:bold 15px;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#ffffb9"  valign="MIDDLE" >
                                <input type="text" name="taskName" id="taskName" onchange="JavaScript:textChange('taskId')" style="width:77%;text-align:center" />
                                <input type="button" name="search" id="search" class="button" value="<%=select%>" onclick="JavaScript:getTask()" STYLE="height: 25px;font-size:15px;color:black;font-weight:bold;width:60px" />
                                <input type="hidden" name="taskId" id="taskId" />
                            </TD>
                            <TD class="backgroundHeader" STYLE="text-align:center;padding:5px" WIDTH="15%">
                                <b><font size=3 color="black"><%= beginDate%></font></b>
                            </TD>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#ffffb9"  valign="MIDDLE" >
                                <input readonly id="beginDate" name="beginDate" type="text" value="<%=nowTime%>" style="width:90%" /><img alt=""  src="images/showcalendar.gif" onmouseover="Tip('<%=calenderTip%>',CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#FFFF99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7, TITLE ,'Display Calender Help',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'black', TITLEBGCOLOR ,'#6699FF')" onmouseout="UnTip()" />
                            </TD>
                        </TR>
                        <TR>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#ffffb9"  valign="MIDDLE" WIDTH="2%">
                                &ensp;
                            </TD>
                            <TD class="backgroundHeader" STYLE="text-align:center;padding:5px" WIDTH="13%">
                                <b><font size=3 color="black"><%=item%></font></b>
                            </TD>
                            <TD style="text-align:center;font:bold 15px;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#ffffb9"  valign="MIDDLE" >
                                <input type="text" name="sparePart" id="sparePart" onchange="JavaScript:textChange('partId')" style="width:77%;text-align:center" />
                                <%--<input type="button" name="search" id="search" class="button" value="<%=select%>" onclick="JavaScript:getItems()" STYLE="height: 25px;font-size:15px;color:black;font-weight:bold;width:60px" />--%>
                                <input type="button" name="search" id="search" class="button" value="<%=selectByCode%>" onclick="return getDataInPopup('ReportsServletThree?op=listSpareParts' + '&fieldName=ITEM_ID&fieldValue=' + getASSCIChar(document.getElementById('sparePart').value));" STYLE="height: 25px;font-size:15px;color:black;font-weight:bold;width:80px" />
                                <input type="button" name="search" id="search" class="button" value="<%=selectByName%>" onclick="return getDataInPopup('ReportsServletThree?op=listSpareParts' + '&fieldName=ITEM_DESC&fieldValue=' + getASSCIChar(document.getElementById('sparePart').value));" STYLE="height: 25px;font-size:15px;color:black;font-weight:bold;width:80px" />
                                <input type="hidden" name="partId" id="partId" />
                            </TD>
                            <TD class="backgroundHeader" STYLE="text-align:center;" WIDTH="15%">
                                <b> <font size=3 color="black"><%= endDate%></font> </b>
                            </TD>
                            <TD  bgcolor="#ffffb9"  style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" valign="middle">
                                <input readonly id="endDate" name="endDate" type="text" value="<%=nowTime%>" style="width:90%" /><img alt=""  src="images/showcalendar.gif" onmouseover="Tip('<%=calenderTip%>',CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#FFFF99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7, TITLE ,'Display Calender Help',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'black', TITLEBGCOLOR ,'#6699FF')" onmouseout="UnTip()" />
                            </TD>
                        </TR>
                        <TR>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#ffffb9"  valign="MIDDLE" COLSPAN="5" >
                                &ensp;
                            </TD>
                        </TR>
                        <TR>
                            <TD DIR="<%=dir%>" style="text-align:<%=divAlign%>;padding-<%=divAlign%> : 5%;font:bold 15px;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#ffffb9"  valign="MIDDLE" COLSPAN="3" >
                                <%=maintenance%>
                                <font color="red">(</font>
                                <%=notEmergancy%><input type="radio" name="issueTitle" id="issueTitle" checked value="notEmergency" />
                                &ensp;
                                <%=emrgancy%><input type="radio" name="issueTitle" id="issueTitle" checked value="Emergency" />
                                &ensp;
                                <%=selectAll%><input type="radio" name="issueTitle" id="issueTitle" checked value="both" />
                                <font color="red">)</font>
                            </TD>
                            <TD style="text-align:<%=divAlign%>;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#ffffb9"  valign="MIDDLE" colspan="2">
                                <input type="checkbox" id="laborDetail" name="laborDetail" value="on"/>&ensp;<font size=3><%=laborDetailed%></font>
                            </TD>
                        </TR>
                        <TR>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor=""  valign="MIDDLE" WIDTH="2%">
                                &ensp;
                            </TD>
                            <TD colspan="5" style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor=""  valign="MIDDLE" WIDTH="2%">
                                <div id="dropDown">
                                    <div onclick="JavaScript: changeMode('showHideTable');" id="showHide" style="text-align:<%=divAlign%>;"><img id="showHideImg" src="images/317e0s5.gif" /><%=moreOptionsLabel%></div>
                                    <div id="showHideTable" style="display: none; padding-bottom:5px;">
                                        <table ALIGN="center" DIR="<%=dir%>" WIDTH="100%" CELLSPACING=0 CELLPADDING=0 BORDER="0">
                                            <tr>
                                                <TD BGCOLOR="#989898" STYLE="border-left-WIDTH:1px;text-align:center;padding:5px" WIDTH="13%">
                                                    <b><font size=3 color="white"><%=orderByLabel%></font></b>
                                                </TD>
                                                <TD colspan="2" DIR="<%=dir%>" style="text-align:<%=divAlign%>;font:bold 15px;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#F8F8F8"  valign="MIDDLE" >
                                                    <input type="radio" name="orderType" id="orderType" checked value="ASC" /><%=ASCLabel%><br />
                                                    <input type="radio" name="orderType" id="orderType" value="DESC" /><%=DESCLabel%>
                                                </TD>
                                                <TD BGCOLOR="#989898" STYLE="border-left-WIDTH:1px;text-align:center;padding:5px" WIDTH="13%">
                                                    <b><font size=3 color="white"><%=dateTypeLabel%></font></b>
                                                </TD>
                                                <TD  DIR="<%=dir%>" style="text-align:<%=divAlign%>;font:bold 15px;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#F8F8F8"  valign="MIDDLE" >
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
