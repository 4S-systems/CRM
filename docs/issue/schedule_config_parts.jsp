<%@page import="com.Erp.db_access.CostCentersMgr"%>
<%@page import="com.SpareParts.db_access.SparePartsMgr"%>
<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.tracker.engine.*,com.silkworm.common.*, com.tracker.common.*, java.util.*,com.tracker.business_objects.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,java.text.DecimalFormat"%>
<%@ page pageEncoding="UTF-8"%>
<HTML>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        FailureCodeMgr failureCodeMgr = FailureCodeMgr.getInstance();
        String context = metaMgr.getContext();
        SparePartsMgr sparePartsMgr = SparePartsMgr.getInstance();
        ItemsBranchMgr itemsBranchMgr = ItemsBranchMgr.getInstance();
        IssueMgr issueMgr = IssueMgr.getInstance();
        IssueTasksMgr issueTasksMgr = IssueTasksMgr.getInstance();

        String issueId = (String) request.getAttribute(IssueConstants.ISSUEID);
        String issueTitle = (String) request.getAttribute(IssueConstants.ISSUETITLE);
        //IssueTasksMgr issueTasksMgr = new IssueTasksMgr();

        String issueCode = "";
        WebBusinessObject wboIssue = issueMgr.getOnSingleKey(issueId);
        if (wboIssue != null) {
            issueCode = (String) wboIssue.getAttribute("businessID");
        }

        String filterName = (String) request.getAttribute("filter");

        String filterValue = (String) request.getAttribute("filterValue");
        String attachedEqFlag = (String) request.getAttribute("attachedEqFlag");
        String uID = (String) request.getAttribute("uID");

        /* Stores Data */
        ArrayList allStores = (ArrayList) request.getAttribute("allStores");
        String selectedStore = (String) request.getAttribute("selectedStore");
        String selectedBranch = (String) request.getAttribute("selectedBranch");
        ArrayList itemFormForSelectedStore = (ArrayList) request.getAttribute("itemFormForSelectedStore");
        String selectedForm = (String) request.getAttribute("selectedForm");

        // to save or not
        String status = (String) request.getAttribute("status");
        if (status == null) {
            status = "";
        }
        
        ArrayList tradeList = new ArrayList();
        Vector tradeVec = (Vector) request.getAttribute("vecUserTrades");
           if (tradeVec.size() > 0) {
               for (int i = 0; i < tradeVec.size(); i++) {
                    WebBusinessObject wbo = (WebBusinessObject) tradeVec.elementAt(i);
                    tradeList.add(wbo);
                   }
             }

        /* added */
        AppConstants appCons = new AppConstants();

        String[] itemAtt = appCons.getItemScheduleAttributes();

        Vector itemList = (Vector) request.getAttribute("data");
        int iTotal = 0;

        String attName = null;
        String attValue = null;

        WebBusinessObject wbo = IssueMgr.getInstance().getOnSingleKey(issueId);
        WebBusinessObject wboFcode = failureCodeMgr.getOnSingleKey(wbo.getAttribute("failureCode").toString());
        String failureCode = wboFcode.getAttribute("title").toString();
        /* end */

        String cMode = (String) request.getSession().getAttribute("currentMode");
        String stat = cMode;
        String align = null;
        String dir = null;
        String STYLE = null;
        String save, lang, langCode;
        String AddCode, select, isMainEq, AddName, code, name, price, count, cost, Mynote, del, sBackToList, notFoundItemForm;
        String updateParts, classGroup, totalCost, setupStoreNote, addTaskNote, quantity, fStatus, sStatus, storeAva, dist, sPrint,refreshSearchLabel;

        String costNameField,costCenterLabel, costCenterMsg, costCenterEmpMsg;
        String addSpareParts,saveRequestStore;
        String itemNameMsg = "", costCentermsg = "";
        if (stat.equals("En")) {
            align = "center";
            dir = "LTR";
            STYLE = "text-align:left";
            lang = "   &#1593;&#1585;&#1576;&#1610;    ";
            langCode = "Ar";
            select = "Select";
            AddCode = "Add using Part Code";
            AddName = "Add using Part Name";
            code = "Code";
            name = "Name";
            price = "Price";
            count = "Qountity";
            cost = "Total Price";
            Mynote = "Note";
            del = "Delete";
            sBackToList = "Job Order Detail";
            notFoundItemForm = "Not Found Categories";
            isMainEq = "Is Main Equipment";
            updateParts = "Add / Update Equipment Spare Parts";
            classGroup = "Gorups of items";
            totalCost = "Total cost of spare parts";
            setupStoreNote = "Should be prepared store for the program";
            addTaskNote = "You must add maintenance item";
            save = "Save";
            sStatus = "Spare Parts Saved Successfully";
            fStatus = "Fail To Save This Spare Parts";
            storeAva = "Available Stroes";
            dist = "Distribution";
            quantity = "Available";
            sPrint = "Print";
            refreshSearchLabel = "Search";

            costNameField = "LATIN_NAME";

            costCenterLabel = "Cost Center";
            costCenterMsg = "This Spare Part Already Distributed with the same Cost Center";
            costCenterEmpMsg = "Please Enter Cost Center";

            itemNameMsg = "Item Not Found in stores";
            costCentermsg = "Not Found";
            addSpareParts="alternative items";
            saveRequestStore="save requested exchange of stores";
        } else {
            select = "&#1571;&#1582;&#1578;&#1575;&#1585;";
            align = "center";
            dir = "RTL";
            STYLE = "text-align:Right";
            lang = "English";
            langCode = "En";
            save = " &#1581;&#1601;&#1592; ";
            AddCode = "&#1576;&#1581;&#1579; &#1576;&#1575;&#1604;&#1585;&#1602;&#1605;";
            AddName = "&#1576;&#1581;&#1579; &#1576;&#1575;&#1604;&#1575;&#1587;&#1605;";
            code = "&#1575;&#1604;&#1603;&#1608;&#1583;";
            name = "&#1575;&#1604;&#1573;&#1587;&#1605;";
            price = "&#1575;&#1604;&#1587;&#1593;&#1585; ";
            count = "&#1575;&#1604;&#1603;&#1605;&#1610;&#1607;";
            cost = " &#1575;&#1580;&#1605;&#1575;&#1604;&#1610; &#1575;&#1604;&#1587;&#1593;&#1585;";
            Mynote = "&#1605;&#1604;&#1575;&#1581;&#1592;&#1575;&#1578;";
            del = "&#1581;&#1584;&#1601; ";
            sBackToList = "&#1578;&#1601;&#1575;&#1589;&#1610;&#1604; &#1575;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
            notFoundItemForm = "\u0644\u0627 \u062A\u0648\u062C\u062F \u0627\u0635\u0646\u0627\u0641";
            isMainEq = "&#1593;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1591;&#1585;&#1607;";
            updateParts = "&#1575;&#1590;&#1575;&#1601;&#1577; / &#1578;&#1593;&#1583;&#1610;&#1604; &#1602;&#1591;&#1593; &#1594;&#1610;&#1575;&#1585; &#1604;&#1604;&#1605;&#1593;&#1583;&#1607;";
            classGroup = "&#1605;&#1580;&#1605;&#1608;&#1593;&#1575;&#1578; &#1575;&#1604;&#1571;&#1589;&#1606;&#1575;&#1601;";
            totalCost = "&#1573;&#1580;&#1605;&#1575;&#1604;&#1609; &#1575;&#1604;&#1578;&#1603;&#1604;&#1601;&#1577; &#1604;&#1602;&#1591;&#1593; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585;";
            setupStoreNote = "&#1610;&#1580;&#1576; &#1573;&#1593;&#1583;&#1575;&#1583; &#1575;&#1604;&#1605;&#1582;&#1586;&#1606; &#1604;&#1604;&#1576;&#1585;&#1606;&#1575;&#1605;&#1580;";
            addTaskNote = "&#1610;&#1580;&#1576; &#1573;&#1590;&#1575;&#1601;&#1577; &#1576;&#1606;&#1583; &#1589;&#1610;&#1575;&#1606;&#1577; &#1571;&#1608;&#1604;&#1575;&#1611;";
            storeAva = "&#1575;&#1604;&#1605;&#1600;&#1600;&#1582;&#1600;&#1600;&#1575;&#1586;&#1606; &#1575;&#1604;&#1605;&#1600;&#1600;&#1578;&#1575;&#1581;&#1600;&#1600;&#1577;";
            fStatus = "&#1604;&#1600;&#1605; &#1610;&#1600;&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604;";
            sStatus = "&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604; &#1576;&#1600;&#1606;&#1600;&#1580;&#1600;&#1575;&#1581;";
            dist = "&#1578;&#1600;&#1600;&#1608;&#1586;&#1610;&#1600;&#1600;&#1593;";
            quantity = "&#1575;&#1604;&#1605;&#1578;&#1575;&#1581;";
            sPrint = "&#1573;&#1591;&#1576;&#1600;&#1600;&#1593;";

            refreshSearchLabel = "&#1573;&#1593;&#1575;&#1583;&#1577; &#1576;&#1581;&#1579;";
            costNameField = "COSTNAME";

            costCenterLabel = "&#1605;&#1585;&#1603;&#1586; &#1575;&#1604;&#1578;&#1603;&#1604;&#1601;&#1577;";
            costCenterMsg = "\u0647\u0630\u0647 \u0627\u0644\u0645\u0639\u062F\u0629 \u062A\u0645 \u062A\u0648\u0632\u064A\u0639\u0647\u0627 \u0645\u0646 \u0642\u0628\u0644 \u0645\u0639 \u0646\u0641\u0633 \u0645\u0631\u0643\u0632 \u0627\u0644\u062A\u0643\u0644\u0641\u0629";
            costCenterEmpMsg = "\u0627\u0644\u0631\u062C\u0627\u0621 \u0625\u062F\u062E\u0627\u0631 \u0645\u0631\u0643\u0632 \u0627\u0644\u062A\u0643\u0644\u0641\u0629";

            itemNameMsg = "قطعة الغيار غير موجودة بالمخازن";
            costCentermsg = "غير موجود";

            addSpareParts="&#1576;&#1583;&#1575;&#1574;&#1604; &#1602;&#1591;&#1593;&#1577; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585;";
            saveRequestStore="&#1578;&#1587;&#1580;&#1610;&#1604; &#1591;&#1604;&#1576; &#1575;&#1604;&#1589;&#1585;&#1601; &#1605;&#1606; &#1575;&#1604;&#1605;&#1582;&#1575;&#1586;&#1606;";
        }

        WebBusinessObject itemWbo = new WebBusinessObject();
        Vector checkTasksVec = new Vector();
        checkTasksVec = issueTasksMgr.getOnArbitraryKey(issueId, "key1");

        String storeNameAttribute = "storeName" + stat;
        String isMust = "&#1606;&#1593;&#1605;";
    %>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Agricultural Maintenance - work shop order</TITLE>
        <script LANGUAGE="JavaScript" TYPE="text/javascript" src="js/common.js"></script>
        <script LANGUAGE="JavaScript" TYPE="text/javascript" src="js/silkworm_validate.js"></script>
        <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
        var count=0;
        var window_chaild = null;
        
        window.onload = function() {
            checNumeric();
        }

        function submitForm(attachedFlag) {

            checkNote();
            if(document.getElementsByName('check').length>0){
                if(checkQuantity()){
                    if(CheckCostCenters()){
                        if(CheckUniqueSparParts()){
                            action(attachedFlag);
                        }
                    }
                }
            } else{
                var r=confirm("Are You Sure You need to delete all Parts")
                if (r==true) {
                    if(CheckCostCenters()){
                        if(CheckUniqueSparParts()){
                            action(attachedFlag);
                        }
                    }
                }
            }
        }

        function CheckCostCenters(){

            var costNames = document.getElementsByName("costName");
            for(var i = 0; i < costNames.length; i++){
                if(costNames[i].value == ''){
                    alert('<%=costCenterEmpMsg%>');
                    var id = costNames[i].id;
                    document.getElementById(id).focus();
                    return false
                }
            }
            return true;
        }
        function CheckUniqueSparParts(){

            var codes = document.getElementsByName("code");
            var costCodes = document.getElementsByName("costCode");

            var costNames = document.getElementsByName("costName");
            var saprPartsNames = document.getElementsByName("name1");

            for(var i = 0; i < codes.length; i++){
                var code = codes[i].value;
                var costCode = costCodes[i].value;
                for(var j = i+1; j < codes.length; j++){
                    if(code == codes[j].value && costCode == costCodes[j].value){
                        alert("(" + saprPartsNames[j].value + ") <%=costCenterMsg%> (" + costNames[j].value + ") ");
                        var id = costNames[j].id;
                        document.getElementById(id).focus();
                        return false;
                    }
                }
            }
            return true;
        }

        function action(attachedFlag){
            if(attachedFlag.match("attached")){
                coffee=document.forms[0].checkattachEq;
                txt="";
                for (i=0;i<coffee.length;++ i) {
                    if (coffee[i].checked) {
                        txt=txt + "1!";
                    }else{
                        txt=txt + "0!";
                    }
                }
                if(coffee.length==undefined) {
                    if(document.forms[0].checkattachEq.checked){
                        txt="1!";
                    }else{
                        txt="0!";
                    }
                }
                document.SPARE_PARTS_FORM.action = "<%=context%>/AssignedIssueServlet?op=saveconfigParts&projectID=<%=wbo.getAttribute("projectName").toString()%>&assignNote=<%=failureCode%>&uID=<%=uID%>&filterName=<%=filterName%>&filteValue=<%=filterValue%>&page=spareparts&isDirectPrch=0&attachedOn="+txt;
                document.SPARE_PARTS_FORM.submit();
            }else{
                document.SPARE_PARTS_FORM.action = "<%=context%>/AssignedIssueServlet?op=saveconfigParts&projectID=<%=wbo.getAttribute("projectName").toString()%>&assignNote=<%=failureCode%>&uID=<%=uID%>&filterName=<%=filterName%>&filteValue=<%=filterValue%>&page=spareparts&isDirectPrch=0";
                document.SPARE_PARTS_FORM.submit();
            }
        }

        function checkQuantity(){
            var quns = document.getElementsByName('qun');
            for(var i = 0; i < quns.length; i++){
                if(!isRealQuantity(quns[i].value)){
                    quns[i].focus();
                    return false;
                }
            }

            return true;
        }
        
        function isRealQuantity(quantity){
            if(quantity == ""){
                alert("Must Enter Quantity ...");
                return false;
            } else if(quantity == "0"){
                alert("Must Quantity Large Than Zero ...");
                return false;
            } else if(!IsNumeric(quantity)){
                alert("Must Quantity Number ...");
                return false;
            }
            
            var intQuantity = new Number(quantity);
            if(intQuantity <= 0) {
                alert("Must Quantity Large Than Zero ");
                return false;
            }

            return true;
        }

        function checkNote() {
            var notes = document.getElementsByName('note');
            for(var i = 0; i < notes.length; i++){
                if(notes[i].value == ""){
                    notes[i].value = "No Note";
                }
            }
        }

        function checNumeric() {
            var q = document.getElementsByName('qun');
            var c = document.getElementsByName('cost');
            var p = document.getElementsByName('price');
            var length = document.getElementsByName('check').length;
            var total = 0.0;

            for(var x = 0; x < length; x++) {

                var price=p[x].value;
                var check=q[x].value;

                if(IsNumeric(check)) {
                    total += check * price;
                    c[x].value = roundNumber(check * price, 2);
                } else {
                    q[x].value = "0";
                    c[x].value = "0.0";
                }
            }

            var tot = document.getElementById('total');
            tot.value = total.toFixed(2);
        }

        function Delete() {
            var tbl = document.getElementById('itemTable');
            var check=document.getElementsByName('check');
            for(var i=0;i<check.length;i++){
                if(check[i].checked==true){
                    tbl.deleteRow(i+1);
                    i--;
                }
            }
            checNumeric();
        }

        function IsNumeric(sText)   {
            var ValidChars = "0123456789.";
            var IsNumber=true;
            var Char;

            for (i = 0; i < sText.length && IsNumber == true; i++)
            {
                Char = sText.charAt(i);
                if (ValidChars.indexOf(Char) == -1)
                {
                    IsNumber = false;
                }
            }
            return IsNumber;
        }

        function cancelForm()
        {
            document.SPARE_PARTS_FORM.action ="<%=context%>/AssignedIssueServlet?op=VIEWDETAILS&issueId=<%=issueId%>&filterName=<%=filterName%>&filterValue=<%=filterValue%>";
            document.SPARE_PARTS_FORM.submit();
        }

        function changeMode(name){
            if(document.getElementById(name).STYLE.display == 'none'){
                document.getElementById(name).STYLE.display = 'block';
            } else {
                document.getElementById(name).STYLE.display = 'none';
            }
        }

        function getSpareParts() {
            var codeOrName = getCodeOrName();
            var itemForm = document.getElementById('selectedFormList').value;
            var codeValues = getCodes();
            var storeCode =  document.getElementById('selectedStore').value;
            var branchCode = document.getElementById('selectedBranch').value;
            var formName = document.getElementById('SPARE_PARTS_FORM').getAttribute("name");
            var subCode = document.getElementById('spareName').value;

            var res = ""
            for (i=0;i < subCode.length; i++) {
                res += subCode.charCodeAt(i) + ',';
            }

            res = res.substr(0, res.length - 1);
            count=document.getElementById('con').value;
            openWindowParts('SelectiveServlet?op=selectMultiSpareParts&spareName='+res+'&formName='+formName+'&itemForm=' + itemForm + '&storeCode=' + storeCode + '&branchCode=' + branchCode + '&codeOrName=' + codeOrName + '&codes=&attachOn=issue'); //' + codeValues + '
        }

        function getCodeOrName() {
            if(document.getElementById('radioCode').checked){
                return document.getElementById('radioCode').value;
            } else{
                return document.getElementById('radioName').value;
            }
        }

        function getCodes() {
            var codeValues = "";
            var codes = document.getElementsByName('code');
            if(codes != null){
                for(var i = 0; i < codes.length; i++) {
                    codeValues = codeValues + codes[i].value + " ";
                }
            }
            return codeValues;
        }

        function openWindowParts(url) {
            openCustomDialog(url, "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width=1000, height=600");
        }

        function getFormDetails() {

            openWindowParts('ReportsServlet?op=getFormDetails&formCode=STR-INTEG-6');
        }
        
        function getItemBalance(store, index) { 
            var codes = document.getElementsByName('code');

            var itemCode = codes[index].value;
            var codeAndForm = itemCode.split("-");
            var itemForm = codeAndForm[0];
            itemCode = codeAndForm[1];

            openWindowParts("PopupServlet?op=getBalance&itemCode=" + itemCode + "&itemForm=" + itemForm + "&storeCode=" + store);
        }
        
        function distribution(itemCode) {
            var codes = document.getElementsByName("code");
            var issueId = '<%=issueId%>';
            var index = 0;
            for(var i = 0; i < codes.length; i++) {
                if(codes[i].value == itemCode) {
                    index = i;
                    break;
                }
            }
            
            var quantity = document.getElementsByName("qun")[index].value;
            if(isRealQuantity(quantity)) {
                customShowModalDialog("PopupServlet?op=distributionParts&itemCode=" + itemCode + "&issueId=" + issueId + "&quantity=" + quantity);
            } else {
                document.getElementsByName("qun")[index].focus();
            }
        }
        
        function customShowModalDialog(url) {
            openCustomDialog(url, "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width=850, height=600");
        }

        function changeSelectedForm(id) {
            document.getElementById('itemForm').value = document.getElementById(id).value;
        }

        function getItemForm(storeId) {
            // clear select form and selected Form
            document.getElementById('selectedStore').value = storeId;
            document.getElementById('selectedFormList').innerHTML = "";
            document.getElementById('itemForm').value = "";

            var url = "<%=context%>/ajaxServlet?op=getItemForm&storeId=" + storeId;
            if (window.XMLHttpRequest) {
                req = new XMLHttpRequest();
            }
            else if (window.ActiveXObject) {
                req = new ActiveXObject("Microsoft.XMLHTTP");
            }
            req.open("POST",url,true);
            req.onreadystatechange =  callbackFillItemForm;
            req.send(null);
        }

        function callbackFillItemForm(){
            if (req.readyState==4) {
                if (req.status == 200) {
                    var selectForm = document.getElementById('selectedFormList');
                    var selectedBranch = document.getElementById('selectedBranch');
                    var itemForm = document.getElementById('itemForm');

                    var allData = req.responseText;
                    var data = allData.split("<data>");

                    selectedBranch.value = data[0];
                    var arrCodeDesc = data[1].split("<element>");

                    if(data[1] != "") {
                        for(var i=0; i < arrCodeDesc.length; i++) {
                            changeSearchPanel(false);

                            var temp = arrCodeDesc[i].split("<subelement>");
                            selectForm.options[selectForm.options.length] = new Option(temp[1], temp[0]);
                        }

                        // add active Form to text box
                        itemForm.value = selectForm.options[0].value;
                    } else {
                        changeSearchPanel(true);
                        selectForm.options[selectForm.options.length] = new Option('<%=notFoundItemForm%>', '-------');
                        itemForm.value = '---';
                    }
                }
            }
        }

        function changeSearchPanel(disabled) {
            document.getElementById('radioName').disabled = disabled;
            document.getElementById('radioCode').disabled = disabled;
            document.getElementById('spareName').disabled = disabled;
            document.getElementById('btnSearch').disabled = disabled;
        }

        function print() {
            document.SPARE_PARTS_FORM.action = "PDFReportServlet?op=printEquipmentParts";
            openCustom('');
            document.SPARE_PARTS_FORM.target="window_chaild";
            document.SPARE_PARTS_FORM.submit();

        }
        function openCustom(url)
        {
            openCustomDialog(url, "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width=850, height=400");
        }
        
       function setAlternativeItems(taskId,mainItemId){

            openWindowParts("SelectiveServlet?op=listAlterParts&taskId=" + taskId + "&mainItemId=" + mainItemId);

       }

       function updateAlterPart(crt) {
                if(crt.value != null || crt.value !=''){
                    document.SPARE_PARTS_FORM.action = "<%=context%>/AssignedIssueServlet?op=updateAlterParts&issueId=<%=issueId%>&attachedEqFlag=<%=attachedEqFlag%>&filterValue=<%=filterValue%>&filterName=<%=filterName%>&updateId="+crt.value;
                    document.SPARE_PARTS_FORM.submit();
                }          
        }
    </SCRIPT>

    <STYLE type="text/css">
        .blackFont {
            color: black;
            font-weight: bold;
        }
    </STYLE>
    </HEAD>
    <BODY>
        <FORM action=""  NAME="SPARE_PARTS_FORM" ID="SPARE_PARTS_FORM" METHOD="POST">
             <% WebBusinessObject tradeWbo = (WebBusinessObject) tradeVec.get(0);
              %>
           <input type="hidden" name="trade" id="trade" value="<%=tradeWbo.getAttribute("tradeId")%>">
           
            <input type="hidden" name="isMust" id="isMust" value="<%=isMust%>">
            <DIV align="left" STYLE="color:blue;padding-left: 2.5%">
                <input type="button" value="     <%=lang%>     " onclick="reloadAE('<%=langCode%>')" class="Button">
                &ensp;
                <button  onclick="JavaScript: cancelForm();" class="button" STYLE="width:125px"><%=sBackToList%></button>
                <% if (allStores.size() > 0 && checkTasksVec.size() > 0) {%>
                &ensp;
                <button  onclick="JavaScript:  submitForm('<%=attachedEqFlag%>');" class="button"><%=save%><img alt=""  HEIGHT="15" SRC="images/save.gif"></button>
                    <% }%>
                <%if (!itemList.isEmpty()) {%>
                    <button  onclick="JavaScript: print();" class="button"><%=sPrint%></button>
                <%}%>
                <input type="button" name="formDetails" class="button" onclick="getFormDetails()" value="Form Details" />
            </DIV>
            <br>
            <center>
                <FIELDSET class="set" STYLE="width:100%;border-color: #006699;" >
                    <TABLE class="blueBorder" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                        <TR>
                            <TD STYLE="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD">
                                <font color="#F3D596" size="4"><%=updateParts%>&ensp;<font color="white" size="4">-</font>&ensp;<%=issueCode%></font>
                            </TD>
                        </TR>
                    </TABLE>
                    <%if (!status.equals("")) {%>
                    <br>
                    <table class="blueBorder" dir="rtl" align="center" width="95%" cellpadding="0" cellspacing="0">
                        <tr>
                            <%if (status.equals("ok")) {%>
                            <td width="100%" bgcolor="#D0D0D0" STYLE="padding-bottom: 2px;padding-top: 2px">
                        <font color="blue" STYLE="font-weight: bold" size="3"><center><%=sStatus%></center></font>
                        </td>
                        <%} else if (status.equals("no")) {%>
                        <td width="100%" bgcolor="#D0D0D0" STYLE="padding-bottom: 2px;padding-top: 2px">
                        <font color="red" STYLE="font-weight: bold" size="3"><center><%=fStatus%></center></font>
                        </td>
                        <%}%>
                        </tr>
                    </table>
                    <%}%>
                    <br>
                    <%if (checkTasksVec.size() > 0) {%>
                    <%if (allStores.size() > 0) {%>
                    <TABLE DIR="<%=dir%>" cellpadding="0" cellspacing="0" border="0" width="95%">
                        <TR>
                            <TD STYLE="border-width: 0px" width="50%">
                                <TABLE CLASS="blueBorder" ALIGN="<%=align%>" DIR="<%=dir%>" ID="tab" CELLPADDING="0" CELLSPACING="0" width="100%">
                                    <TR>
                                        <TD CLASS="blueBorder backgroundHeader blueHeaderTD" STYLE="text-align:center;font-size:16px;height: 35px" width="30%">
                                            <B><%=storeAva%></B>
                                        </TD>
                                        <TD CLASS="blueBorder" bgcolor="#D8D8D8" STYLE="text-align:center;color:white;font-size:16px;height: 35px" width="70%">
                                            <SELECT name="groupId" ID="groupId" STYLE="width:233px;text-align:center;font-size:14px;font-weight: bold" ONCHANGE="JavaScript:getItemForm(this.value);">
                                                <sw:WBOOptionList wboList="<%=allStores%>" displayAttribute = "<%=storeNameAttribute%>" valueAttribute="storeCode" scrollTo="<%=selectedStore%>" />
                                            </SELECT>
                                            <input type="text" id="selectedStore" name="selectedStore" value="<%=selectedStore%>" STYLE="text-align:center;font-size:14px;font-weight: bold;" size="7" readonly>
                                            <input type="hidden" id="selectedBranch" name="selectedBranch" value="<%=selectedBranch%>">
                                        </TD>
                                    </TR>
                                    <TR>
                                        <TD CLASS="blueBorder backgroundHeader blueHeaderTD"STYLE="text-align:center;font-size:16px;">
                                            <B><%=classGroup%></B>
                                        </TD>
                                        <TD CLASS="blueBorder" bgcolor="#D8D8D8">
                                            <SELECT name="selectedFormList" ID="selectedFormList"STYLE="width:233px;text-align:center;font-size:14px;font-weight: bold" ONCHANGE="javascript: changeSelectedForm(this.id)">
                                                <sw:WBOOptionList wboList="<%=itemFormForSelectedStore%>" displayAttribute = "formDesc" valueAttribute="codeForm" scrollTo="<%=selectedForm%>"/>
                                            </SELECT>
                                            <input id="itemForm" size="7" value="<%=selectedForm%>" STYLE="text-align:center;font-size:14px;font-weight: bold" readonly />
                                        </TD>
                                    </TR>
                                </TABLE>
                            </TD>
                            <TD STYLE="border-width: 0px" width="1%">
                                &ensp;
                            </TD>
                            <TD STYLE="border-width: 0px" width="49%">
                                <TABLE ID="tableSearch" class="blueBorder" ALIGN="<%=align%>" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" width="100%" STYLE="height: 100%">
                                    <TR>
                                        <TD CLASS="blueBorder backgroundHeader blueHeaderTD" STYLE="text-align:center;font-size:15px;">
                                            <input type="radio" id="radioCode" name="radioCodeOrName" value="code" checked><b><%=AddCode%></b>
                                        </TD>
                                        <TD CLASS="blueBorder blueHeaderTD" STYLE="text-align:center;color:#000000;font-size:15px;background-color: #EDEDED" ROWSPAN="2" id="CellData" colspan="2">
                                            <input type="text" dir="ltr" value="" name="spareName" ID="spareName" size="30" STYLE="text-align: center;">
                                            <input type="button" id="btnSearch" value="<%=select%>"  STYLE="text-align:center;font-size:14px;font-weight: bold;width: 70px" ONCLICK="JavaScript: getSpareParts();">
                                        </TD>
                                    </TR>
                                    <TR>
                                        <TD CLASS="blueBorder backgroundHeader blueHeaderTD" STYLE="text-align:center;font-size:15px;">
                                            <input type="radio" id="radioName" name="radioCodeOrName" value="name" ><b><%=AddName%></b>
                                        </TD>
                                    </TR>
                                </TABLE>
                            </TD>
                        </TR>
                        <TR>
                            <TD STYLE="border-width: 0px" width="50%">
                                <TABLE CLASS="blueBorder" ALIGN="<%=align%>" DIR="<%=dir%>" ID="tab" CELLPADDING="0" CELLSPACING="0" width="100%">
                                    <TR>
                                        <TD CLASS="blueBorder backgroundHeader blueHeaderTD" STYLE="text-align:center;font-size:16px;height: 35px" width="30%">
                                            <B><%=saveRequestStore%></B>
                                        </TD>
                                        <TD colspan="2" CLASS="blueBorder" bgcolor="#D8D8D8" STYLE="text-align:center;color:white;font-size:16px;height: 35px" width="70%">
                                            <input type="checkbox" name="saveRequest" id="saveRequest" />
                                        </TD>
                                    </TR>
                                </TABLE>
                            </TD>
                        </TR>
                    </TABLE>
                    <br>
                    <TABLE CLASS="blueBorder" ALIGN="<%=align%>" DIR="<%=dir%>" id="itemTable" WIDTH="95%" CELLPADDING="0" CELLSPACING="0">
                        <TR>
                            <TD CLASS="blueBorder backgroundHeader blueHeaderTD" WIDTH="18%">
                                <b><%=code%></b>
                            </TD>
                            <TD CLASS="blueBorder backgroundHeader blueHeaderTD" WIDTH="20%">
                                <b><%=name%></b>
                            </TD>
                            <TD CLASS="blueBorder backgroundHeader blueHeaderTD" WIDTH="10%">
                                <b><%=count%></b>
                            </TD>
                            <TD CLASS="blueBorder backgroundHeader blueHeaderTD" WIDTH="10%">
                                <b><%=costCenterLabel%></b>
                            </TD>
                            <TD CLASS="blueBorder backgroundHeader blueHeaderTD" WIDTH="10%">
                                <b><%=price%></b>
                            </TD>
                            <TD CLASS="blueBorder backgroundHeader blueHeaderTD" WIDTH="10%">
                                <b><%=cost%></b>
                            </TD>
                            <TD CLASS="blueBorder backgroundHeader blueHeaderTD"  WIDTH="10%">
                                <b><%=quantity%></b>
                            </TD>
                            <TD CLASS="blueBorder backgroundHeader blueHeaderTD" WIDTH="17%">
                                <b><%=Mynote%></b>
                            </TD>

                            <%if (attachedEqFlag.equalsIgnoreCase("attached")) {%>
                            <TD CLASS="blueBorder backgroundHeader blueHeaderTD" WIDTH="3%">
                                <b> <%=isMainEq%></b>
                            </TD>
                            <%}%>

                            <TD CLASS="blueBorder backgroundHeader blueHeaderTD" WIDTH="6%">
                                <input type="button" value="<%=del%>" STYLE="font-weight: bold;text-align:center;color:black;font-size:14px;width: 55px" onclick="JavaScript: Delete()"/>
                            </TD>

                            <TD CLASS="blueBorder backgroundHeader blueHeaderTD" WIDTH="6%">
                                <b><%=addSpareParts%></b>
                            </TD>
                        </TR>
                        <%
                            int index = 0;
                            Enumeration e = itemList.elements();
                            double dtotalCost = 0.0;
                            while (e.hasMoreElements()) {
                                iTotal++;
                                wbo = (WebBusinessObject) e.nextElement();
                                DecimalFormat format = new DecimalFormat("0.00");
                                attName = itemAtt[0];
                                attValue = (String) wbo.getAttribute(attName);
                                if (attValue.indexOf("-") == -1) {
                                    iTotal--;
                                    continue;
                                }
                                String[] itemcodeList = attValue.split("-");
                                if (itemcodeList.length > 1) {
                                    itemWbo = (WebBusinessObject) sparePartsMgr.getOnSingleKey(attValue);
                                } else {
                                    itemWbo = sparePartsMgr.getOnObjectByKey(attValue);
                                }
                                try {
                                    itemWbo.setAttribute("itemCodeByItemForm", itemWbo.getAttribute("itemCodeByItemForm"));
                                    itemWbo.setAttribute("itemQuantity", itemsBranchMgr.getQuantity(itemWbo.getAttribute("itemForm").toString(), itemWbo.getAttribute("itemCode").toString(), itemWbo.getAttribute("code").toString()));
                                } catch (Exception ex) {
                                    itemWbo = new WebBusinessObject();
                                    itemWbo.setAttribute("itemCodeByItemForm", attValue);
                                    itemWbo.setAttribute("itemName", "---");
                                    itemWbo.setAttribute("itemCode", itemcodeList[1]);
                                    itemWbo.setAttribute("itemQuantity", "0");
                                }
                        %>
                        <TR>
                            <TD CLASS="blueBorder blackFont">
                                <% if (itemcodeList.length > 1) {%>
                                <a class='blackFont' href="JavaScript: getItemBalance('<%=wbo.getAttribute("storeCode").toString()%>' ,'<%=index++%>')" STYLE="color: blue"><%=itemWbo.getAttribute("itemCodeByItemForm").toString()%></a>
                                <input type="hidden" name="code" id="code" value="<%=itemWbo.getAttribute("itemCodeByItemForm").toString()%>" />
                                <% } else {%>
                                <a class='blackFont' href="JavaScript: getItemBalance('<%=wbo.getAttribute("storeCode").toString()%>' ,'<%=index++%>')" STYLE="color: blue"><%=itemWbo.getAttribute("itemCode").toString()%></a>
                                <input type="hidden" name="code" id="code" value="<%=itemWbo.getAttribute("itemCode").toString()%>" />
                                <% }%>
                            </TD>
                            <%
                                String itemName = itemWbo.getAttribute("itemName").toString();
                                if(itemName.equals("---")){
                                   itemName = "<font size = '3' style='background-color: red;' color = 'white'><img src = 'images/worning_yallow.jpg' />&nbsp;&nbsp;" + itemNameMsg + "</font>";
                           %><TD CLASS="blueBorder blackFont"><%=itemName%></TD><%
                               } else {
                            %>
                            <TD CLASS="blueBorder blackFont">
                                <input class='blackFont' type="text" readonly STYLE="width: 100%;text-align: center" name="name1" id="name1" value="<%=itemName%>">
                            </TD>
                            <% }
                                attName = itemAtt[1];
                                attValue = (String) wbo.getAttribute(attName);
                            %>
                            <TD CLASS="blueBorder blackFont" width="9%">
                                <input class='blackFont' type="text" STYLE="width: 100%;text-align: center" name="qun" id="qun" value="<%=attValue%>" onblur='checNumeric()' maxlength="10" size="10">
                            </TD>
                            <%
                                String costCenterName;
                                attName = "attachedOn";
                                attValue = (String) wbo.getAttribute(attName);
                                if (!attValue.equals("2")) {
                                     CostCentersMgr costCenterMgr = CostCentersMgr.getInstance();
                                     WebBusinessObject costCenterWbo =  new WebBusinessObject();
                                     Vector costCentersVec = new Vector();
                                     try {
                                             costCentersVec = costCenterMgr.getOnArbitraryKey(attValue, "key");
                                             costCenterWbo = (WebBusinessObject) costCentersVec.elementAt(0);
                                     } catch (Exception exc) {
                                             costCenterName = "";
                                     }
                                     try {
                                         costCenterName = costCenterWbo.getAttribute(costNameField).toString();
                                     } catch (Exception ex) {
                                         costCenterName = "";
                                     }
                                 } else {
                                     costCenterName = "";
                                 }
                            %>
                            <TD CLASS="blueBorder blackFont" width="9%">
                                <%
                                    if(costCenterName.equalsIgnoreCase("")){
                                        //costCenterName = "<font size = '2' style='background-color: red;' color = 'white'><img src = 'images/worning_yallow.jpg' />&nbsp;&nbsp;"+costCenterMsg+"</font>";
                                        %>
                                        <input type='hidden' name='costCode' id='costCode_<%=index%>' value='2' />
                                        <input type='text' name='costName' id='costName_<%=index%>' value='' readonly />
                                        <button id='btnSearch' value='' onclick="return getDataInPopup('AssignedIssueServlet?op=listCostCenters&fieldName=<%=costNameField%>&fieldValue=&formName=SPARE_PARTS_FORM&selectionType=single&rowIndex=<%=index%>');" >
                                            <img src='images/refresh.png' alt='Search' title='Search' align='middle' width='24' height='24' />
                                        </button>
                                <%=costCenterName%><%
                                    } else {
                                %>
                                <%--<a class='blackFont' href="JavaScript: distribution('<%=itemWbo.getAttribute("itemCodeByItemForm")%>')" STYLE="color: blue"><%=dist%></a>--%>
                                <input type="hidden" name="costCode" id="cost_code_<%=index%>" value="<%=attValue%>" />
                                <input type="text" name="costName" id="cost_name_<%=index%>" value="<%=costCenterName%>" readonly />
                                <%}%>
                            </TD>
                            <%
                                attName = itemAtt[2];
                                attValue = (String) wbo.getAttribute(attName);
                                attValue = format.format(new Float(attValue));
                            %>
                            <TD CLASS="blueBorder blackFont">
                                <input class='blackFont' type="text" readonly STYLE="width: 100%;text-align: center" name="price" id="price" value="<%=attValue%>">
                            </TD>
                            <%
                                attName = itemAtt[3];
                                attValue = (String) wbo.getAttribute(attName);
                                attValue = format.format(new Float(attValue));
                                dtotalCost = dtotalCost + new Double(attValue);
                            %>
                            <TD CLASS="blueBorder blackFont">
                                <input class='blackFont' type="text" STYLE="width: 100%;text-align: center" readonly name="cost" id="cost" value="<%=attValue%>">
                            </TD>
                            <TD CLASS="blueBorder blackFont">
                                <input class='blackFont' type="text" STYLE="width: 100%;text-align: center" readonly name="quantity" id="quantity" value="<%=itemWbo.getAttribute("itemQuantity")%>" />
                            </TD>
                            <%
                                attName = itemAtt[4];
                                attValue = (String) wbo.getAttribute(attName);
                            %>
                            <TD CLASS="blueBorder blackFont">
                                <input class='blackFont' type="text" STYLE="width: 100%;text-align: center" name="note" id="note" value=" <%=attValue%>" maxlength="190">
                            </TD>
                            <%
                                if (attachedEqFlag.equalsIgnoreCase("attached")) {
                                    if (wbo.getAttribute("attachedOn").equals("1") || wbo.getAttribute("attachedOn").equals("2")) {%>
                            <TD><input class='blackFont' type="checkbox"  name="checkattachEq" id="checkattachEq" value="1" checked ></TD>
                                <%} else {%>
                            <TD><input  class='blackFont'type="checkbox"  name="checkattachEq" id="checkattachEq" value="0" ></TD>
                                <%                                                                        }
                                    }
                                %>
                            <TD CLASS="blueBorder blackFont">
                                <input type="hidden" name="Hid" id="Hid" value="<%=(String) wbo.getAttribute(itemAtt[0])%>">
                                <% if (wbo.getAttribute("branchCode") != null && !wbo.getAttribute("branchCode").equals("")) {%>
                                <input type="hidden" name="branch" id="branch" value="<%=(String) wbo.getAttribute("branchCode")%>">
                                <% } else {%>
                                <input type="hidden" name="branch" id="branch" value="none">
                                <% }%>

                                <% if (wbo.getAttribute("storeCode") != null && !wbo.getAttribute("storeCode").equals("")) {%>
                                <input type="hidden" name="store" id="store" value="<%=(String) wbo.getAttribute("storeCode")%>">
                                <% } else {%>
                                <input type="hidden" name="store" id="store" value="none">
                                <% }%>
                                <%if (wbo.getAttribute("canDelete") != null && wbo.getAttribute("canDelete").equals(true)) {%>
                                <input type="checkbox" name="check" id="check" />
                                <%} else {%>
                                <input type="checkbox" name="check" id="check" disabled />
                                <%}%>
                                
                            </TD>
                            <TD CLASS="blueBorder blackFont">
                                <% for(int x=0;x<checkTasksVec.size();x++){
                                    WebBusinessObject taskWbo = (WebBusinessObject) checkTasksVec.get(x);
                                    Vector taskByItemsV = new Vector();
                                    ConfigAlterTasksPartsMgr configAlterTasksPartsMgr =ConfigAlterTasksPartsMgr.getInstance();
                                    String taskId= taskWbo.getAttribute("codeTask").toString();
                                    String mainItemId=wbo.getAttribute("itemId").toString();
                                    ConfigTasksPartsMgr  configTasksPartsMgr = ConfigTasksPartsMgr.getInstance();
                                    taskByItemsV = configAlterTasksPartsMgr.checkAlterPartsList(taskId,itemWbo.getAttribute("itemCodeByItemForm").toString());
                                    //taskByItemsV = (Vector)configAlterTasksPartsMgr.getOn(taskId, "key1", mainItemId, "key2");
                                    if(taskByItemsV.size()>0){
                                        String id=null;
                                        %>
                                        <select id="alterPart" name="alterPart" onchange="updateAlterPart(this);">
                                            <option value=""><%=select%></option>
                                            <% for(int y=0;y<taskByItemsV.size();y++){
                                                WebBusinessObject taskByItemWbo = (WebBusinessObject) taskByItemsV.get(y);
                                                id = taskByItemWbo.getAttribute("id").toString();
                                                ItemsMgr itemMgr = ItemsMgr.getInstance();
                                                itemWbo = (WebBusinessObject)itemMgr.getOnSingleKey(taskByItemWbo.getAttribute("itemId").toString());
                                                String desc = itemWbo.getAttribute("itemDscrptn").toString();
                                                %>
                                                <option value="<%=id%>-<%=wbo.getAttribute("id")%>"><%=desc%></option>
                                                <% } %>
                                        </select>

                                <%  break;
                                    } %>
                                <%}%>
                            </TD>
                        </TR>
                        <% }%>
                    </TABLE>
                    <br>
                    <TABLE CLASS="blueBorder blackFont" ALIGN="<%=align%>" DIR="<%=dir%>" WIDTH="95%" CELLPADDING="0" CELLSPACING="0" >
                        <TR bgcolor="#E8E8FF">
                            <td CLASS="blueBorder blackFont" STYLE="height: 25px" width="65%" ><font size="3" color="black"><b><%=totalCost%></b></font></td>
                            <td CLASS="blueBorder blackFont" width="35%" ><font size="3"><b><input type="text" name="total"  readonly ID="total"  value="" maxlength="255" STYLE="width: 80%;text-align: center;font-weight: bold;color: black;font-size: 14px" ></b></font></td>
                        </TR>
                    </TABLE>

                    <!-- Hidden variables -->
                    <input type=HIDDEN name=issueId value="<%=issueId%>" >
                    <input type=HIDDEN name=filterName value="<%=filterName%>" >
                    <input type=HIDDEN name=filterValue value="<%=filterValue%>" >
                    <input type=HIDDEN name=issueTitle value="<%=issueTitle%>">
                    <!-- End Hidden variables -->

                    <% } else {%>
                    <br>
                    <TABLE class="blueBorder" cellspacing="0" cellpadding="0" align="<%=align%>" dir="<%=dir%>" width="90%">
                        <TR>
                            <TD class="backgroundTable">
                                <b><font size=4 color='red'><%=setupStoreNote%></font></b>
                            </TD>
                        </TR>
                    </TABLE>
                    <% }%>
                    <% } else {%>
                    <br>
                    <TABLE class="blueBorder" cellspacing="0" cellpadding="0" align="<%=align%>" dir="<%=dir%>" width="90%">
                        <TR>
                            <TD class="backgroundTable">
                                <b><font size=4 style="font-size: medium;" color='red'><%=addTaskNote%></font></b>
                            </TD>
                        </TR>
                    </TABLE>
                    <% }%>
                    <br><br>
                </FIELDSET>
            </center>
            <input type="hidden"  name="con" id="con" value="<%=iTotal%>">
            <!-- check found item form or not -->
            <SCRIPT type="text/javascript" >
                var selectForm = document.getElementById('selectedFormList');
                if(selectForm.options.length == 0) {
                    changeSearchPanel(true);
                    selectForm.options[selectForm.options.length] = new Option('<%=notFoundItemForm%>', '-------');
                    document.getElementById('itemForm').value = '---';
                }
            </SCRIPT>
        </FORM>
    </BODY>
</HTML>     