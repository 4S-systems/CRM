<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.tracker.engine.*,com.silkworm.common.*, com.tracker.common.*, java.util.*,com.tracker.business_objects.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,java.text.DecimalFormat"%>

<HTML>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        FailureCodeMgr failureCodeMgr = FailureCodeMgr.getInstance();
        String context = metaMgr.getContext();
        ItemsMgr itemsMgr = ItemsMgr.getInstance();
        IssueTasksMgr issueTasksMgr = IssueTasksMgr.getInstance();

        String issueId = (String) request.getAttribute(IssueConstants.ISSUEID);
        String issueTitle = (String) request.getAttribute(IssueConstants.ISSUETITLE);

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

        String TotaleCost = (String) request.getAttribute("TotaleCost");

        // to save or not
        String status = (String) request.getAttribute("status");
        if (status == null) {
            status = "";
        }

        AppConstants appCons = new AppConstants();
        String[] itemAtt = appCons.getItemScheduleAttributesByEff();
        String[] configitemAtt = appCons.getItemScheduleAttributes();
        Vector itemList = (Vector) request.getAttribute("data");
        Vector configitemList = (Vector) request.getAttribute("configdata");

        int iTotal = 0;

        String attName = null;
        String attValue = null;
        String bgColor = null;
        int flipper = 0;



        WebBusinessObject wbo = IssueMgr.getInstance().getOnSingleKey(issueId);
        WebBusinessObject wboFcode = failureCodeMgr.getOnSingleKey(wbo.getAttribute("failureCode").toString());
        String failureCode = wboFcode.getAttribute("title").toString();


        String cMode = (String) request.getSession().getAttribute("currentMode");
        String stat = cMode;
        String align = null;
        String dir = null;
        String style = null;
        String endTask, BackToList, save, lang, langCode, AllRequired, title, Fcode, site, M_Name, crew, ATask, print, actualTime;
        String search, AddCode, select, isMainEq, AddName, addNew, tCost, code, name, price, count, cost, Mynote, del, scr, sBackToList, attachTask;
        String updateParts, classGroup, totalCost, viewSparPart, setupStoreNote, addTaskNote;
        String changeStore, sBsearch, storeAva, sStatus, fStatus, usedItemParts, efficient, addRequestParts, sPrint;
        if (stat.equals("En")) {
            align = "center";
            dir = "LTR";
            style = "text-align:left";
            lang = "   &#1593;&#1585;&#1576;&#1610;    ";
            langCode = "Ar";
            endTask = "End that task";
            BackToList = "Back to list";
            save = "    Save   ";
            AllRequired = "(*) All Data Must Be Filled";
            title = "Schedule title";
            Fcode = "Failure code";
            print = "Print order";
            ATask = "Assign task";
            site = "Site";
            select = "Select";
            search = "Search for code ends with";
            M_Name = "Machine name";
            crew = "Assign to Crew Mission";
            AddCode = "Add using Part Code";
            AddName = "Add using Part Name";
            addNew = "Add new part";
            tCost = "Total cost  ";
            code = "Code";
            name = "Name";
            price = "Price";
            count = "qountity";
            cost = "Total Price";
            Mynote = "Note";
            del = "Delete";
            scr = "images/arrow1.swf";
            sBackToList = "Back To Job Order";
            attachTask = "Attach spare parts to task";
            isMainEq = "Is Main Equipment";
            updateParts = "Add / Update Equipment Spare Parts";
            classGroup = "Gorups of items";
            totalCost = "Total cost of spare parts";
            viewSparPart = "View spare parts";
            setupStoreNote = "Should be prepared store for the program";
            addTaskNote = "You must add maintenance item";
            changeStore = "Change Store";
            sBsearch = "Search";
            storeAva = "Available Stroes";
            sStatus = "Site Saved Successfully";
            fStatus = "Fail To Save This Site";
            usedItemParts = "Used Spare Parts";
            efficient = "efficient";
            addRequestParts = "Add Job Order Parts";
            sPrint = "Print";
        } else {
            select = "&#1571;&#1582;&#1578;&#1575;&#1585;";
            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            lang = "English";
            langCode = "En";
            endTask = " &#1573;&#1606;&#1578;&#1607;&#1575;&#1569; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607;";
            BackToList = "&#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1573;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577;";
            save = " &#1587;&#1580;&#1604; &#1575;&#1604;&#1581;&#1575;&#1604;&#1577; ";
            AllRequired = "&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607; (*)";
            title = "&#1606;&#1608;&#1593; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607;";
            Fcode = "&#1603;&#1608;&#1583; &#1575;&#1604;&#1593;&#1591;&#1604; ";

            site = " &#1575;&#1604;&#1605;&#1608;&#1602;&#1593;";
            M_Name = "&#1573;&#1587;&#1605; &#1575;&#1604;&#1575;&#1604;&#1607;";
            fStatus = "&#1604;&#1600;&#1605; &#1610;&#1600;&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604;";
            sStatus = "&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604; &#1576;&#1600;&#1606;&#1600;&#1580;&#1600;&#1575;&#1581;";
            print = "&#1573;&#1591;&#1576;&#1593; &#1575;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
            ATask = "&#1573;&#1587;&#1606;&#1575;&#1583; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607;";
            crew = "&#1578;&#1587;&#1606;&#1583; &#1573;&#1604;&#1609; &#1601;&#1585;&#1610;&#1602; &#1575;&#1604;&#1593;&#1605;&#1604;";
            search = "&#1576;&#1581;&#1579;&nbsp; &#1593;&#1606; &#1603;&#1608;&#1583; &#1610;&#1606;&#1578;&#1607;&#1609; &#1576;&#1609;";
            AddCode = "&#1576;&#1581;&#1579; &#1576;&#1575;&#1604;&#1585;&#1602;&#1605;";
            AddName = "&#1576;&#1581;&#1579; &#1576;&#1575;&#1604;&#1575;&#1587;&#1605;";
            addNew = "  &#1571;&#1590;&#1601; &#1602;&#1591;&#1593;&#1577; &#1580;&#1583;&#1610;&#1583;&#1607; ";
            tCost = "&#1573;&#1580;&#1605;&#1575;&#1604;&#1610; &#1575;&#1604;&#1578;&#1603;&#1604;&#1601;&#1607;   ";
            code = "&#1575;&#1604;&#1603;&#1608;&#1583;";
            name = "&#1575;&#1604;&#1573;&#1587;&#1605;";
            price = "&#1575;&#1604;&#1587;&#1593;&#1585; ";
            count = "&#1575;&#1604;&#1603;&#1605;&#1610;&#1607;";
            cost = " &#1575;&#1580;&#1605;&#1575;&#1604;&#1610; &#1575;&#1604;&#1587;&#1593;&#1585;";
            Mynote = "&#1605;&#1604;&#1575;&#1581;&#1592;&#1575;&#1578;";
            del = "&#1581;&#1584;&#1601; ";
            scr = "images/arrow2.swf";
            sBackToList = "&#1593;&#1608;&#1583;&#1607; &#1575;&#1604;&#1609; &#1575;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
            attachTask = "&#1585;&#1576;&#1591; &#1575;&#1605;&#1585;&#1575;&#1604;&#1588;&#1594;&#1604; &#1576;&#1602;&#1591;&#1593; &#1594;&#1610;&#1575;&#1585; &#1605;&#1606; &#1575;&#1604;&#1605;&#1582;&#1575;&#1586;&#1606;";
            isMainEq = "&#1593;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1591;&#1585;&#1607;";
            updateParts = "&#1575;&#1590;&#1575;&#1601;&#1577; / &#1578;&#1593;&#1583;&#1610;&#1604; &#1602;&#1591;&#1593; &#1594;&#1610;&#1575;&#1585; &#1604;&#1604;&#1605;&#1593;&#1583;&#1607;";
            classGroup = "&#1605;&#1580;&#1605;&#1608;&#1593;&#1575;&#1578; &#1575;&#1604;&#1571;&#1589;&#1606;&#1575;&#1601;";
            totalCost = "&#1573;&#1580;&#1605;&#1575;&#1604;&#1609; &#1575;&#1604;&#1578;&#1603;&#1604;&#1601;&#1577; &#1604;&#1602;&#1591;&#1593; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585;";
            viewSparPart = "&#1602;&#1591;&#1593; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585; &#1576;&#1575;&#1604;&#1605;&#1582;&#1586;&#1606;";
            setupStoreNote = "&#1610;&#1580;&#1576; &#1573;&#1593;&#1583;&#1575;&#1583; &#1575;&#1604;&#1605;&#1582;&#1586;&#1606; &#1604;&#1604;&#1576;&#1585;&#1606;&#1575;&#1605;&#1580;";
            addTaskNote = "&#1610;&#1580;&#1576; &#1573;&#1590;&#1575;&#1601;&#1577; &#1576;&#1606;&#1583; &#1589;&#1610;&#1575;&#1606;&#1577; &#1571;&#1608;&#1604;&#1575;&#1611;";
            changeStore = "&#1578;&#1594;&#1610;&#1610;&#1585; &#1575;&#1604;&#1605;&#1582;&#1586;&#1606;";
            sBsearch = "&#1576;&#1581;&#1579;";
            storeAva = "&#1575;&#1604;&#1605;&#1600;&#1600;&#1582;&#1600;&#1600;&#1575;&#1586;&#1606; &#1575;&#1604;&#1605;&#1600;&#1600;&#1578;&#1575;&#1581;&#1600;&#1600;&#1577;";
            usedItemParts = "&#1605;&#1587;&#1578;&#1607;&#1604;&#1603;&#1575;&#1578; &#1602;&#1591;&#1593; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585;";
            efficient = "&#1575;&#1604;&#1603;&#1601;&#1575;&#1569;&#1577;";
            addRequestParts = "&#1573;&#1590;&#1575;&#1601;&#1577; &#1602;&#1591;&#1593; &#1594;&#1610;&#1575;&#1585; &#1571;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
            sPrint = "&#1573;&#1591;&#1576;&#1600;&#1600;&#1593;";
        }

        WebBusinessObject itemWbo = new WebBusinessObject();
        Vector checkTasksVec = new Vector();
        checkTasksVec = issueTasksMgr.getOnArbitraryKey(issueId, "key1");
        int partsSum = 0;
        try {
            partsSum = (Integer) request.getAttribute("partsSum");
        } catch (Exception Ex) {
        }
        String storeNameAttribute = "storeName" + stat;
    %>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Agricultural - Maintenance - work shop order</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <script LANGUAGE="JavaScript" TYPE="text/JavaScript">
            var count=0;
            function submitForm(attachedFlag){
                var qun = document.getElementsByName('qun');
                var qun_o = document.getElementsByName('qun_o');
                var used = 0;
                for(k=0;k<qun.length;k++){
                    used += parseInt(qun[k].value);
                }
                for(k=0;k<qun_o.length;k++){
                    used += parseInt(qun_o[k].value);
                }
                checkNote();
                if(parseInt(used) < parseInt('<%=partsSum%>')) {
                    var result = confirm('Used Spare Parts ' + used + ' less than Issue Spare Parts <%=partsSum%>');
                    if(result == false){
                        return;
                    }
                }
                if(document.getElementsByName('check').length>0){
                    if(checkQuantity()){
                        action();
                    }
                }
            }

            function action(){
        
                document.SPARE_PARTS_FORM.action = "<%=context%>/AssignedIssueServlet?op=saveUsedParts&projectID=<%=wbo.getAttribute("projectName").toString()%>&assignNote=<%=failureCode%>&uID=<%=uID%>&filterName=<%=filterName%>&filteValue=<%=filterValue%>&page=spareparts&isDirectPrch=0";
                document.SPARE_PARTS_FORM.submit();
       
            }

            function checkNote(){
                var notes = document.getElementsByName('note');
                for(var i = 0; i < notes.length; i++){
                    if(notes[i].value == ""){
                        notes[i].value = "No Note";
                    }
                }
            }
    
            function checkQuantity(){
                var quns = document.getElementsByName('qun');
                var efficients = document.getElementsByName('efficient');
                for(var i = 0; i < quns.length; i++){
                    if(quns[i].value == ""){
                        alert("Must Enter Quantity ...");
                        quns[i].focus();
                        return false;
                    } else if(quns[i].value == "0"){
                        alert("Must Quantity Large Than Zero ...");
                        quns[i].focus();
                        return false;
                    } else if(!IsNumeric(quns[i].value)){
                        alert("Must Quantity Number ...");
                        quns[i].focus();
                        return false;
                    }
                }

                for(var i = 0; i < efficients.length; i++){
                    if(efficients[i].value == ""){
                        alert("Must Enter efficient ...");
                        efficients[i].focus();
                        return false;
                    }else if(!IsNumeric(efficients[i].value)){
                        alert("Must efficient Number ...");
                        efficients[i].focus();
                        return false;
                    }
                }
                return true;
            }
    
            function checNumeric() {
   
                var q=document.getElementsByName('qun');
                var c=document.getElementsByName('cost');
                var p=document.getElementsByName('price');
                var total=0.0;
                var totalprice = 0.0;
                for(var x=0;x<q.length;x++){
                    var price=p[x].value;
                    var check=q[x].value;
                    if(IsNumeric(check)){
                        total+=check*price;
                        totalprice = Number(check*price);
                        totalprice = totalprice.toFixed(2);
                        c[x].value=totalprice;
                    }
                    else {
                        q[x].value="0";
                        c[x].value="0.0";
                    }
      
                } 
                var tot = document.getElementById('totale');
                tot.value = total.toFixed(2);
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

            function isFound(x){
                var code=document.getElementsByName('code');
                for(var i=0;i<count;i++){
   
                    if(x==code[i].value) return true;
                }
                return false;
            }

            function addNew(test){
                var TDName=document.getElementsByName('TDName');
                var group= document.getElementById("groupId").value;

                if(TDName[0].value==""){
                    alert("please fill the name field frist ");
                    return;
                }
     
                if(isFound(group+"-"+TDName[0].value)){
                    alert(" that item is exist already in the table");
                    return;
                }
     
                count++;
                document.getElementById('con').value=count;
                var x = document.getElementById('itemTable').insertRow();
                var C1 = x.insertCell(0);
                var C2 = x.insertCell(1);
                var C3 = x.insertCell(2);
                var C4 = x.insertCell(3);
                var C5 = x.insertCell(4);
                var C6 = x.insertCell(5);
                var C7 = x.insertCell(6);
        
                if(test.match("attached")){
        
                    var C8 = x.insertCell(7);
                    var C9 = x.insertCell(8);
                    var C10 = x.insertCell(9);
                    var C11 = x.insertCell(10);
                    var C12 = x.insertCell(11);
                }else
                {
        
                    var C8 = x.insertCell(7);
                    var C9 = x.insertCell(8);
                    var C10 = x.insertCell(9);
                    var C11 = x.insertCell(10);
                }
        
                C1.borderWidth = "1px";
                C2.borderWidth = "1px";
                C3.borderWidth = "1px";
                C4.borderWidth = "1px";
                C5.borderWidth = "1px";
                C6.borderWidth = "1px";
                C7.borderWidth = "1px";
                C8.borderWidth = "1px";
                C9.borderWidth = "1px";

                var me=count-1;
        
                C1.innerHTML = "<input type='text'  name='code' ID='code' readonly value=' '>";  
                C2.innerHTML = "<input type='text' name='name1' ID='name1' readonly>";
                C3.innerHTML = "<input type='text' name='qun' ID='qun'  onblur='checNumeric()'>";
                C4.innerHTML = "<input type='text' name='price' ID='price' onblur='checNumeric()'>";
                C5.innerHTML = "<input type='text' name='cost' ID='cost' value='0.0' readonly>";
                C6.innerHTML = "<input type='text' name='efficient' ID='efficient' value='0'>";
                C7.innerHTML = "<input type='text' name='note' ID='note' value='Add your Note'>";
         
                if(test.match("attached")){
                    C8.innerHTML = "<input type='checkbox' name='checkattachEq' ID='checkattachEq'>";
                    C9.innerHTML = "<input type='checkbox' name='check' ID='check'>";
                    C10.innerHTML = "<input type='hidden' name='Hid' ID='Hid'>";
                    C11.innerHTML = "<input type='hidden' name='branch' ID='branch'>";
                    C12.innerHTML = "<input type='hidden' name='store' ID='store'>";
            
                }else {
                    C8.innerHTML = "<input type='checkbox' name='check' ID='check'>";
                    C9.innerHTML = "<input type='hidden' name='Hid' ID='Hid'>";
                    C10.innerHTML = "<input type='hidden' name='branch' ID='branch'>";
                    C11.innerHTML = "<input type='hidden' name='store' ID='store'>";
                }
            }

            function Delete() {

                var tbl = document.getElementById('spareList');
                var check = document.getElementsByName('check');

                var check_o = document.getElementsByName('check_o');
                var leng = check.length;
                //alert("Length : " + leng);
                for(var i = 0; i < leng; i++){
                    if(check[i].checked == true){
                        tbl.deleteRow(check_o.length + i + 1);
                        i--;
                        leng--;
                    }
                }
            }
            function mod(mode){
                if(mode=="code"){
                    lookAheadArray =itemsCode;
                    nowMode="code";
                    document.getElementById('searchSubCode').disabled = false;
                    document.getElementById('partCode').disabled = false;
                }
                else{
                    lookAheadArray=itemNames;
                    nowMode="name";
                    document.getElementById('searchSubCode').disabled = true;
                    document.getElementById('partCode').disabled = true;
                }
            } 
      
            function cancelForm()
            {    
                document.SPARE_PARTS_FORM.action ="<%=context%>/AssignedIssueServlet?op=VIEWDETAILS&issueId=<%=issueId%>&filterName=<%=filterName%>&filterValue=<%=filterValue%>";
                document.SPARE_PARTS_FORM.submit();
            }

            function openWindow(url)
            {
                window.open(url,"_blank","toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=no, copyhistory=no, width=800, height=800");
            }

            function openCahngeStoreWindow(url)
            {
                window.open(url,"_blank","toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=no, copyhistory=no, width=600, height=400");
            }

            function changeMode(name){
                if(document.getElementById(name).style.display == 'none'){
                    document.getElementById(name).style.display = 'block';
                } else {
                    document.getElementById(name).style.display = 'none';
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
                openWindowParts('SelectiveServlet?op=selectMultiSpareParts&spareName='+res+'&formName='+formName+'&itemForm=' + itemForm + '&storeCode=' + storeCode + '&branchCode=' + branchCode + '&codeOrName=' + codeOrName + '&codes=' + codeValues + '&attachOn=issue&efficient=1');
            }

            function openWindowParts(url)
            {
                window.open(url,"_blank","toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width=750, height=600");
            }

            function getItemForm(storeId) {
                // clear select form and selected Form
                document.getElementById('selectedStore').value = storeId;
                document.getElementById('selectedFormList').innerHTML = "";
                document.getElementById('selectedForm').value = "";

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
                        var selectedForm = document.getElementById('selectedForm');

                        var allData = req.responseText;
                        var data = allData.split("<data>");
                        var arrCodeDesc = data[1].split("<element>");
                        for(var i=0; i < arrCodeDesc.length; i++){
                            var temp = arrCodeDesc[i].split("<subelement>");
                            selectForm.options[selectForm.options.length] = new Option(temp[1], temp[0]);
                        }

                        // add active Form to text box
                        if(selectForm.options.length > 0){
                            selectedForm.value = selectForm.options[0].value;
                        }
                    }
                }
            }

            function getCodeOrName(){
                if(document.getElementById('radioCode').checked){
                    return document.getElementById('radioCode').value;
                } else{
                    return document.getElementById('radioName').value;
                }
            }
    
            function getCodes(){
                var codeValues = "";
                var codes = document.getElementsByName('code');
                if(codes != null){
                    for(var i = 0; i < codes.length; i++){
                        codeValues = codeValues + codes[i].value + " ";
                    }
                }
                return codeValues;
            }
            
            function changeForm(value){
                document.getElementById('selectedForm').value = value;
            }

            function getConfigParts()
            {
                var issueId = document.getElementById('issueId').value;

                openWindowParts('SelectiveServlet?op=selectConfigSpareParts&configissueid='+issueId+'&efficient=1&attachedEqFlag=<%=attachedEqFlag%>&parts=' + getAddedConfigParts());
            }

            function openWindow(url) {
            
                openCustomDialog(url, "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width=750, height=400");
            }
            function getFormDetails() {

                //var stores = document.getElementById('stores').value;
                openWindow('ReportsServlet?op=getFormDetails&formCode=STR-INTEG-3');
            }
            function getAddedConfigParts(){
                var codes = null;
                var qunts = null;
                /*var codes_o = document.getElementsByName('code_o');
                var qunts_o = document.getElementsByName('qun_o');
                var checkattachEq = document.getElementsByName('checkattachEq_o');
                var leng1 = codes_o.length;*/
                var leng2 = 0;
                var partsCodes = '';
                var partsQunts = '';
                var newQun = 0;


                /*if(leng1 > 0){
                    for(var i = 0; i < leng1; i++ ){
                        partsCodes += codes_o[i].value + ',';
                        partsQunts += qunts_o[i].value + ',';
                    }
                    alert(leng1 + "-----" + partsCodes);
                }*/
                try{
                    codes = document.getElementsByName('code');
                    if(codes != null){
                        qunts = document.getElementsByName('qun');
                        leng2 = codes.length;
                        if(leng2 > 0){
                            for(var i = 0; i < leng2; i++ ){
                                //alert(leng2)
                                partsCodes += codes[i].value + ',';
                                partsQunts += qunts[i].value + ',';
                            }
                        }
                    }
                }catch(ex){
                }
                return partsCodes + '/' + partsQunts;
            }
            function print() {
                document.SPARE_PARTS_FORM.action = "PDFReportServlet?op=printUsedSpareParts";
                openCustom('');
                document.SPARE_PARTS_FORM.target="window_chaild";
                document.SPARE_PARTS_FORM.submit();

            }
            function openCustom(url)
            {
                openCustomDialog(url, "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width=850, height=400");
            }

            function checkMaxQuantity(id){
                //alert("id.length " +id.length);
                var index = id.substr(4, id.length);
                //alert(index + "  " + id);
                var qun    = document.getElementById(id).value;
                var maxQun = document.getElementById('maxQun_' + index).value;
                //alert(qun + " - " + maxQun);

                if(parseInt(qun) > parseInt(maxQun)){
                    document.getElementById(id).style.background = "green";
                    document.getElementById(id).color = "white";
                    document.getElementById(id).value = maxQun;
                    document.getElementById(id).focus();
                    if('<%=stat%>' == 'En'){
                        alert("Quantity (" + qun + ") Must Be Less Than OR equal (" + maxQun + ")");
                    } else {
                        alert(" \u0627\u0644\u0643\u0645\u064A\u0629 \u0644\u0627\u0628\u062F \u0648\u0623\u0646 \u062A\u0643\u0648\u0646 \u0623\u0642\u0644 \u0645\u0646 \u0623\u0648 \u062A\u0633\u0627\u0648\u064A " + maxQun);
                    }
                } else if(parseInt(qun) < 1){
                    document.getElementById(id).style.background = "green";
                    document.getElementById(id).color = "white";
                    document.getElementById(id).value = maxQun;
                    document.getElementById(id).focus();
                    if('<%=stat%>' == 'En'){
                        alert("Quantity (" + qun + ") Must Be more Than OR equal (1)");
                    } else {
                        alert(" \u0627\u0644\u0643\u0645\u064A\u0629 \u0644\u0627\u0628\u062F \u0648\u0623\u0646 \u062A\u0643\u0648\u0646 \u0623\u0643\u0628\u0631 \u0645\u0646 \u0623\u0648 \u062A\u0633\u0627\u0648\u064A 1");
                    }
                }
                checNumeric();

            }
        </script>
        <style type="text/css">
            .myBorder {
                border-color:#000080;
                border-width:1px;
                border-style:solid
            }
        </style>
        <script src='silkworm_validate.js' type='text/javascript'></script>
        <script src='ChangeLang.js' type='text/javascript'></script>
        <link rel="stylesheet" type="text/css" href="autosuggest.css" />
    </HEAD>
    <BODY>
        <FORM NAME="SPARE_PARTS_FORM" ID="SPARE_PARTS_FORM" METHOD="POST">
            <DIV align="left" STYLE="color:blue;">
                <input type="button" value="     <%=lang%>     " onclick="reloadAE('<%=langCode%>')" class="Button">
                <button  onclick="JavaScript: cancelForm();" class="button" style="width:125"><%=sBackToList%> <IMG VALIGN="BOTTOM"  HEIGHT="15" SRC="images/leftarrow.gif"> </button>
                    <% if (allStores.size() > 0 && checkTasksVec.size() > 0) {%>
                    <%--<button  onclick="JavaScript:  openWindow('ReportsServlet?op=sparePartByStore&storeCode=<%=storeByBranch%>&itemForm='+document.getElementById('groupId').value);" class="button" value=""><%=viewSparPart%></button>
                    --button  onclick="JavaScript:  openCahngeStoreWindow('ReportsServlet?op=changeActiveStore');" class="button" value=""><%=changeStore%></button--%>
                <button  onclick="JavaScript:  submitForm('<%=attachedEqFlag%>');" class="button"><%=save%> <IMG HEIGHT="15" SRC="images/save.gif"></button>
                    <% }%>
                <%if (!itemList.isEmpty()) {%>
                    <button  onclick="JavaScript: print();" class="button"><%=sPrint%></button>
                <%}%>
                <input type="button" name="formDetails" class="button" onclick="getFormDetails()" value="Form Details" />
            </DIV> 
            <FIELDSET style="border-color:blue">
                <legend align="center">
                    <table dir="rtl" align="center">
                        <tr>
                            <td class="td">
                        <font color="blue" size="5"><center> <%=usedItemParts%></center></font>
                        </td>
                        </tr>
                    </table>
                </legend>
                <%if (!status.equals("")) {%>
                <br>
                <table class="myBorder" dir="rtl" align="center" width="50%" cellpadding="0" cellspacing="0">
                    <tr>
                        <%if (status.equals("ok")) {%>
                        <td class="myBorder" width="100%" bgcolor="#D0D0D0" style="padding-bottom: 2px;padding-top: 2px">
                    <font color="blue" style="font-weight: bold" size="3"><center><%=sStatus%></center></font>
                    </td>
                    <%} else if (status.equals("no")) {%>
                    <td class="myBorder" width="100%" bgcolor="#D0D0D0" style="padding-bottom: 2px;padding-top: 2px">
                    <font color="red" style="font-weight: bold" size="3"><center><%=fStatus%></center></font>
                    </td>
                    <%}%>
                    </tr>
                </table>
                <%}%>
                <%if (checkTasksVec.size() > 0) {%>
                <%if (allStores.size() > 0) {%>
                <%--<br>
                <table align="<%=align%>" border="0" width="70%">
                    <tr>
                        <td width="50%" STYLE="border:0px;">
                            <div STYLE="background-color:#CC9900; width:80%;border:2px solid gray;color:white;" class="header"  align="<%=align%>">
                                <div ONCLICK="JavaScript: changeMode('menu1');"  class="header" STYLE="background-color:#CC9900; width:100%;color:white;cursor:hand;font-size:16px;">
                                    <b>
                                        <%=search%>
                                    </b>
                                    <img src="images/arrow_down.gif">
                                </div>
                                <div ALIGN="<%=align%>" STYLE="width:100%;color:white;display:none;text-align:right;border-top:2px solid gray;" ID="menu1">
                                    <table align="<%=align%>" border="0" dir="<%=dir%>" width="100%" cellspacing="2">
                                        <tr>
                                             <td CLASS="tRow" bgcolor="#CC9900" STYLE="text-align:center;">
                                                <button  id="searchSubCode"  onclick="JavaScript:getParts();" style="width:120"> <%=sBsearch%> <IMG VALIGN="BOTTOM" SRC="images/search.gif"></button>
                                            </td>
                                            <td CLASS="tRow" bgcolor="#CC9900" STYLE="text-align:center;">
                                                <input type="text" name="partCode" id="partCode">
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </td>
                    </tr>
                </table>--%>
                <br>
                <TABLE CLASS="myBorder" ALIGN="<%=align%>" DIR="<%=dir%>" ID="tab" CELLPADDING="0" CELLSPACING="0" width="50%" style="display: none;">
                    <TR>
                        <TD CLASS="myBorder" colspan="2" bgcolor="#006699" STYLE="text-align:center;color:white;font-size:16px;height: 35px">
                            <B><%=storeAva%></B>
                        </TD>
                    </TR>
                    <TD CLASS="myBorder" bgcolor="#D8D8D8" STYLE="text-align:center;color:white;font-size:16px">
                        <SELECT name="groupId" ID="groupId" STYLE="width:233px;text-align:center;font-size:14px;font-weight: bold" ONCHANGE="JavaScript:getItemForm(this.value);">
                            <sw:WBOOptionList wboList="<%=allStores%>" displayAttribute = "<%=storeNameAttribute%>" valueAttribute="storeCode" scrollTo="<%=selectedStore%>" />
                        </SELECT>
                        <input type="text" id="selectedStore" name="selectedStore" value="<%=selectedStore%>" style="text-align:center;font-size:14px;font-weight: bold" readonly>
                        <input type="hidden" id="selectedBranch" name="selectedBranch" value="<%=selectedBranch%>" />
                    </TD>
                </TABLE>
                <br>
                <TABLE CLASS="myBorder" ALIGN="<%=align%>" DIR="<%=dir%>" ID="tab" CELLPADDING="0" CELLSPACING="0" width="95%" style="display: none;">
                    <TR>
                        <TD CLASS="myBorder" colspan="2" bgcolor="#006699" STYLE="text-align:center;color:white;font-size:16px;height: 35px">
                            <B><%=updateParts%></B>
                        </TD>
                    </TR>
                    <TR>
                        <TD CLASS="myBorder" bgcolor="#D8D8D8" STYLE="text-align:center;color:#000000;font-size:16px;height: 35px">
                            <B><%=classGroup%></B>
                        </TD>
                        <TD CLASS="myBorder" bgcolor="#D8D8D8" STYLE="text-align:center;color:white;font-size:16px">
                            <SELECT name="selectedFormList" ID="selectedFormList" STYLE="width:233;text-align:center;font-size:14px;font-weight: bold" ONCHANGE="javascript:changeForm(this.value)">
                                <sw:WBOOptionList wboList="<%=itemFormForSelectedStore%>" displayAttribute = "formDesc" valueAttribute="codeForm" scrollTo="<%=selectedForm%>"/>
                            </SELECT>
                            <input id="selectedForm" name="selectedForm" size="5" value="<%=selectedForm%>" style="text-align:center;font-size:14px;font-weight: bold" readonly>
                        </TD>
                    </TR>
                    <TR align="center">
                        <TD CLASS="myBorder" bgcolor="#EDEDED" STYLE="text-align:center;color:#000000;font-size:15px" WIDTH="175">
                            <input type="radio" name="radioCodeOrName" id="radioCode" value="code" checked><b><%=AddCode%></b>
                        </TD>
                        <TD CLASS="myBorder" bgcolor="#EDEDED" STYLE="text-align:center;color:#000000;font-size:15px" ROWSPAN="2" id="CellData" WIDTH="300">
                            <input id="spareName" name="spareName" value="" style="text-align:center;font-size:14px;font-weight: bold;width: 200px" />
                            <input type="button" id="btnSearch" style="text-align:center;font-size:14px;font-weight: bold;width: 70px" value="<%=select%>"  ONCLICK="JavaScript:getSpareParts()" />
                        </TD>
                    </TR>
                    <TR>
                        <TD CLASS="myBorder" bgcolor="#EDEDED" STYLE="text-align:center;color:#000000;font-size:15px" WIDTH="175">
                            <input type="radio" name="radioCodeOrName" id="radioName" value="name"><b><%=AddName%></b>
                        </TD>
                    </TR>
                </TABLE>
                <br>
                <TABLE id="spareList" CLASS="myBorder" ALIGN="<%=align%>" DIR="<%=dir%>" WIDTH="95%" CELLPADDING="0" CELLSPACING="0">
                    <TR>
                        <TD CLASS="myBorder" bgcolor="#006699" STYLE="text-align:center;color:white;font-size:15px;height: 35px" WIDTH="23%">
                            <b><%=code%></b>
                        </TD>
                        <TD CLASS="myBorder" bgcolor="#006699" STYLE="text-align:center;color:white;font-size:15px" WIDTH="23%">
                            <b><%=name%></b>
                        </TD>
                        <TD CLASS="myBorder" bgcolor="#006699" STYLE="text-align:center;color:white;font-size:15px" WIDTH="10%">
                            <b><%=count%></b>
                        </TD>
                        <TD CLASS="myBorder" bgcolor="#006699" STYLE="text-align:center;color:white;font-size:15px" WIDTH="10%">
                            <b><%=price%></b>
                        </TD>
                        <TD CLASS="myBorder" bgcolor="#006699" STYLE="text-align:center;color:white;font-size:15px" WIDTH="10%">
                            <b><%=cost%></b>
                        </TD>
                        <TD CLASS="myBorder" bgcolor="#006699" STYLE="text-align:center;color:white;font-size:15px" WIDTH="10%">
                            <b><%=efficient%></b>
                        </TD>
                        <TD CLASS="myBorder" bgcolor="#006699" STYLE="text-align:center;color:white;font-size:15px" WIDTH="21%">
                            <b><%=Mynote%></b>
                        </TD>

                        <%if (attachedEqFlag.equalsIgnoreCase("attached")) {%>
                        <TD CLASS="myBorder" bgcolor="#006699" STYLE="text-align:center;color:white;font-size:15px" WIDTH="3%">
                            <b> <%=isMainEq%></b>
                        </TD>
                        <%}%>

                        <TD CLASS="myBorder" bgcolor="#006699" STYLE="text-align:center;color:white;font-size:15px" WIDTH="3%">
                            <input type="button" value="<%=del%>" style="font-weight: bold;text-align:center;color:black;font-size:14px;width: 70px" onclick="JavaScript: Delete()"/>
                        </TD>
                    </TR>

                    <%
                        Enumeration e = itemList.elements();
                        double dtotalCost = 0.0;
                        while (e.hasMoreElements()) {
                            iTotal++;
                            wbo = (WebBusinessObject) e.nextElement();
                            DecimalFormat format = new DecimalFormat("0.00");
                            attName = itemAtt[0];
                            attValue = (String) wbo.getAttribute(attName);
                            String[] itemcodeList = attValue.split("-");
                            if (itemcodeList.length > 1) {
                                itemWbo = (WebBusinessObject) itemsMgr.getOnSingleKey(attValue);
                            } else {
                                itemWbo = itemsMgr.getOnObjectByKey(attValue);
                            }
                            if (itemWbo != null) {
                    %>
                    <TR CLASS="myBorder">
                        <TD CLASS="myBorder">
                            <% if (itemcodeList.length > 1) {%>
                            <input type="text" readonly name="code_o" id="code_o" style="width: 200px" value="<%=itemWbo.getAttribute("itemCodeByItemForm").toString()%>">
                            <% } else {%>
                            <input type="text" readonly name="code_o" id="code_o" style="width: 200px;" value="<%=itemWbo.getAttribute("itemCode").toString()%>">
                            <% }%>
                        </TD>

                        <TD CLASS="myBorder">
                            <input type="text" readonly name="name1_o" id="name1_o" style="width: 200px;" value="<%=itemWbo.getAttribute("itemDscrptn").toString()%>">
                        </TD>
                        <%
                            attName = itemAtt[1];
                            attValue = (String) wbo.getAttribute(attName);
                        %>
                        <TD CLASS="myBorder">
                            <input type="text"  name="qun_o" id="qun_o" style="width: 80px;" value="<%=attValue%>" onblur='checNumeric()'>
                        </TD>
                        <%
                            attName = itemAtt[2];
                            attValue = (String) wbo.getAttribute(attName);

                            attValue = format.format(new Float(attValue));
                        %>
                        <TD CLASS="myBorder">
                            <input type="text" readonly name="price_o" id="price_o" style="width: 80px;" value="<%=attValue%>" >
                        </TD>
                        <%
                            attName = itemAtt[3];
                            attValue = (String) wbo.getAttribute(attName);

                            attValue = format.format(new Float(attValue));
                            dtotalCost = dtotalCost + new Double(attValue);
                        %>
                        <TD CLASS="myBorder">
                            <input type="text" readonly name="cost_o" id="cost_o" style="width: 80px;" value="<%=attValue%>">
                        </TD>
                        <%
                            attName = itemAtt[4];
                            attValue = (String) wbo.getAttribute(attName);
                        %>
                        <TD CLASS="myBorder">
                            <input type="text"  name="efficient_o" id="efficient_o" style="width: 80px;" value="<%=attValue%>">
                        </TD>
                        <%
                            attName = itemAtt[5];
                            attValue = (String) wbo.getAttribute(attName);
                        %>
                        <TD CLASS="myBorder">
                            <input type="text"  name="note_o" id="note_o" style="width: 200px;" value="<%=attValue%>">
                        </TD>
                        <%
                            if (attachedEqFlag.equalsIgnoreCase("attached")) {
                                if (wbo.getAttribute("attachedOn").equals("1") || wbo.getAttribute("attachedOn").equals("2")) {%>
                        <TD CLASS="myBorder">
                            <input type="checkbox"  name="checkattachEq_o" id="checkattachEq_o" value="1" checked >
                        </TD>
                        <%} else {%>
                        <TD CLASS="myBorder">
                            <input type="checkbox"  name="checkattachEq_o" id="checkattachEq_o" value="0" >
                        </TD>
                        <%}
                            }%>
                        <TD CLASS="myBorder">
                            <input type="checkbox"  name="check_o" id="check_o" value="false" disabled>
                            <input type="hidden" name="Hid_o" id="Hid_o" value="<%=(String) wbo.getAttribute(itemAtt[0])%>">
                            <input type="hidden" name="branch_o" id="branch_o" value="<%=(String) wbo.getAttribute("branchCode")%>">
                            <input type="hidden" name="store_o" id="store_o" value="<%=(String) wbo.getAttribute("storeCode")%>">
                        </TD>
                        <%-- <TD CLASS="myBorder">
                             <input type="hidden" name="Hid" id="Hid" value="<%=(String) wbo.getAttribute(itemAtt[0])%>">
                         </TD>
                         <TD CLASS="myBorder">
                             <% if(wbo.getAttribute("branchCode") != null && !wbo.getAttribute("branchCode").equals("")){ %>
                                 <input type="hidden" name="branch" id="branch" value="<%=(String) wbo.getAttribute("branchCode")%>">
                             <% } else { %>
                                 <input type="hidden" name="branch" id="branch" value="none">
                             <% } %>
                         </TD>
                         <TD CLASS="myBorder">
                             <% if(wbo.getAttribute("storeCode") != null && !wbo.getAttribute("storeCode").equals("")){ %>
                                 <input type="hidden" name="store" id="store" value="<%=(String) wbo.getAttribute("storeCode")%>">
                             <% } else { %>
                                 <input type="hidden" name="store" id="store" value="none">
                             <% } %>
                         </TD>--%>
                    </TR>
                    <%
                            }
                        }
                    %>

                </TABLE>
                <br>
                <TABLE ALIGN="<%=align%>" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                    <tr>
                        <td class="td">
                            <input type=HIDDEN name=issueId id="issueId" value="<%=issueId%>" >
                            <input type=HIDDEN name=filterName value="<%=filterName%>" >
                            <input type=HIDDEN name=filterValue value="<%=filterValue%>" >
                            <input type=HIDDEN name=issueTitle value="<%=issueTitle%>">
                        </td>
                    </tr>
                </TABLE>
                <TABLE CLASS="myBorder" ALIGN="<%=align%>" DIR="<%=dir%>" WIDTH="400" CELLPADDING="0" CELLSPACING="0" >
                    <TR bgcolor="#E8E8FF">
                        <td CLASS="myBorder" style="height: 35px"><font size="3" color="black"><b><%=totalCost%></b></font></td>
                            <% if (TotaleCost != null && !TotaleCost.equals("")) {%>
                        <td CLASS="myBorder"><font size="3"><b><input type="text" name="totale"  readonly ID="totale"  value="<%=TotaleCost%>" maxlength="255" ></b></font></td>
                                <% } else {%>
                        <td CLASS="myBorder"><font size="3"><b><input type="text" name="totale"  readonly ID="totale"  value="<%=dtotalCost%>" maxlength="255" ></b></font></td>
                                <% }%>
                    </TR>
                </TABLE>
                <% } else {%>
                <br>
                <TABLE ALIGN="<%=align%>" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                    <tr>
                        <td nowrap>
                            <font size="3" color="red"><b> <%=setupStoreNote%></b></font>
                        </td>
                    </tr>
                </TABLE>
                <%      }
                } else {%>
                <br>
                <TABLE ALIGN="<%=align%>" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                    <tr>
                        <td nowrap>
                            <font size="3" color="red"><b> <%=addTaskNote%></b></font>
                        </td>
                    </tr>
                </TABLE>
                <% }%>
                <br>
            </FIELDSET>

            <input type="button" onclick="getConfigParts();" value="<%=addRequestParts%>">
            <input type="hidden" name="trade" id="trade" value="1">
        </FORM>
        <input type="hidden"  name="con" id="con" value="<%=iTotal%>">
    </BODY>
</HTML>     