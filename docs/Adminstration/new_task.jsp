<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,com.tracker.db_access.*,com.contractor.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<HTML>


    <%

        String status = (String) request.getAttribute("Status");

        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        TaskTypeMgr taskTypeMgr = TaskTypeMgr.getInstance();
        MaintainableMgr maintainableMgr = MaintainableMgr.getInstance();
        TradeMgr tradeMgr = TradeMgr.getInstance();
        EmployeeTitleMgr employeeTitleMgr = EmployeeTitleMgr.getInstance();
        ArrayList EmpTitleList = employeeTitleMgr.getCashedTableAsBusObjects();
        ArrayList tradeList = tradeMgr.getCashedTableAsBusObjects();
        ArrayList tasktypeList = taskTypeMgr.getCashedTableAsBusObjects();
        ArrayList parentUnitList = maintainableMgr.getCategoryAsBusObjects();
        DateAndTimeControl dateAndTime = new DateAndTimeControl();

        WebBusinessObject taskWbo = (WebBusinessObject) request.getAttribute("taskWbo");

        String context = metaMgr.getContext();

        TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
        String[] taskAttributes = {"title", "name"};
        String[] taksListTitles = new String[2];
        String attName = null;
        String attValue = null;
        String cellBgColor = null;

        int s = taskAttributes.length;
        int t = s;
        int iTotal = 0;

        WebBusinessObject wbo = null;
        int flipper = 0;
        String bgColor = null;

        ArrayList JobZiseList = new ArrayList();


        String cMode = (String) request.getSession().getAttribute("currentMode");
        String stat = cMode;
        String align = null;
        String dir = null;
        String style = null;
        String lang, langCode;

        String saving_status, Dupname;
        String code, code_name;
        String title_1, title_2;
        String cancel_button_label;
        String fStatus;
        String sStatus;
        String save_button_label, Jops, EstimatedHours, Houre, PN, sPerviousItems, tradeName, taskType, Category, JobZise, eng_Desc;

        String AddCode, AddName, addNew, tCost, itemCode, name, price, count, cost, Mynote, del, scr, add;
        String updateParts;
        String search, searchTitleName, searchTitleCode, searchLableName, searchLableCode, toolCode, searchByName, searchByCode;
        String sMinute, sHour, sDay,totCost;
        if (stat.equals("En")) {

            saving_status = "Saving status";
            align = "center";
            dir = "LTR";
            style = "text-align:left";
            lang = "   &#1593;&#1585;&#1576;&#1610;    ";
            code = "Maintenance Item Code";
            code_name = "Arabic Description";
            title_1 = "New Maintenance Item";
            Jops = "Reqiured Jop";
            EstimatedHours = "Expected Duration";
            Houre = "  Minutes ";
            title_2 = "All information are needed";
            cancel_button_label = "Cancel ";
            save_button_label = "Save ";
            langCode = "Ar";
            Dupname = "Name is Duplicated Chane it";
            taksListTitles[0] = "Maintenance Item Code";
            taksListTitles[1] = "Arabic Description";
            PN = "Maintenance Item No.";
            sPerviousItems = "Pervious Maintenance Items";
            tradeName = "Trade Name";
            taskType = "Type Of Task";
            Category = " Brand ";
            sStatus = "Maintenance Item Saved Successfully";
            fStatus = "Fail To Save Maintenance Item ";

            JobZiseList.add("Large");
            JobZiseList.add("medium");
            JobZiseList.add("small");
            JobZise = "Working size";
            eng_Desc = "English Description";

            add = "   Add   ";
            search = "Auto search";
            AddCode = "  Add using Part Code  ";
            AddName = "  Add using Part Name  ";
            addNew = "Add new part";
            tCost = "Cost of Task for ( <font color=\"red\">Hour</font> )";
            itemCode = "Code";
            name = "Name";
            price = "Price";
            count = "Quntity";
            cost = "Total Price";
            Mynote = "Note";
            del = "Delete";
            scr = "images/arrow1.swf";
            updateParts = "Add Spare Parts on Maintenance Item";

            search = "Auto search";
            searchLableName = "Write Maintenance Item Name or SubName";
            searchLableCode = "Write Maintenance Item Code or SubCode";
            searchTitleName = "Seach About Maintenance Item By Name";
            searchTitleCode = "Seach About Maintenance Item By Code";

            searchByName = "Saerch By Item Name";
            searchByCode = "Search By Item Code";
            sMinute = "Minute";
            sHour = "Hour";
            sDay = "Day";
            totCost="Total Cost";
        } else {

            saving_status = "&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            lang = "English";
            code = "&#1603;&#1608;&#1583; &#1575;&#1604;&#1576;&#1606;&#1583; ";
            code_name = "&#1575;&#1604;&#1608;&#1589;&#1601; &#1575;&#1604;&#1593;&#1585;&#1576;&#1609;";
            Jops = "&#1575;&#1604;&#1605;&#1607;&#1606;&#1607; &#1575;&#1604;&#1605;&#1591;&#1604;&#1608;&#1576;&#1607; ";
            EstimatedHours = "&#1575;&#1604;&#1605;&#1578;&#1608;&#1587;&#1591;";
            Houre = "   &#1583;&#1602;&#1600;&#1600;&#1610;&#1600;&#1600;&#1602;&#1600;&#1600;&#1607; ";
            title_1 = "&#1576;&#1606;&#1583; &#1589;&#1610;&#1575;&#1606;&#1577; &#1580;&#1583;&#1610;&#1583;";
            title_2 = "&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
            cancel_button_label = "&#1573;&#1606;&#1607;&#1575;&#1569; ";
            save_button_label = "&#1578;&#1587;&#1580;&#1610;&#1604;";
            langCode = "En";
            Dupname = "&#1607;&#1584;&#1575; &#1575;&#1604;&#1575;&#1587;&#1605; &#1587;&#1580;&#1604; &#1605;&#1606; &#1602;&#1576;&#1604; &#1610;&#1580;&#1576; &#1578;&#1587;&#1580;&#1610;&#1604; &#1575;&#1587;&#1605; &#1570;&#1582;&#1585;";
            taksListTitles[0] = "&#1576;&#1606;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
            taksListTitles[1] = "&#1575;&#1604;&#1608;&#1589;&#1601; &#1575;&#1604;&#1593;&#1585;&#1576;&#1609;";
            PN = " &#1593;&#1583;&#1583; &#1576;&#1606;&#1608;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
            sPerviousItems = "&#1575;&#1604;&#1576;&#1606;&#1608;&#1583; &#1575;&#1604;&#1587;&#1575;&#1576;&#1602; &#1573;&#1583;&#1582;&#1575;&#1604;&#1607;&#1575;";
            tradeName = "&#1575;&#1604;&#1605;&#1580;&#1605;&#1608;&#1593;&#1577; &#1575;&#1604;&#1601;&#1606;&#1610;&#1577;";
            taskType = "&#1606;&#1608;&#1593; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
            Category = " &#1605;&#1575;&#1585;&#1603;&#1577; &#1605;&#1593;&#1583;&#1577; ";
            fStatus = "&#1604;&#1600;&#1605; &#1610;&#1600;&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604;";
            sStatus = "&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604; &#1576;&#1600;&#1606;&#1600;&#1580;&#1600;&#1575;&#1581;";
            JobZiseList.add("&#1603;&#1576;&#1610;&#1585;");
            JobZiseList.add("&#1605;&#1578;&#1608;&#1587;&#1591;");
            JobZiseList.add("&#1576;&#1587;&#1610;&#1591;");
            JobZise = "&#1581;&#1580;&#1605; &#1575;&#1604;&#1593;&#1605;&#1604;";
            eng_Desc = "&#1575;&#1604;&#1608;&#1589;&#1601; &#1576;&#1575;&#1604;&#1575;&#1606;&#1580;&#1604;&#1610;&#1586;&#1609;";

            add = "  &#1571;&#1590;&#1601;  ";
            search = "&#1576;&#1581;&#1579; &#1584;&#1575;&#1578;&#1610;";
            AddCode = "   &#1576;&#1581;&#1579; &#1576;&#1575;&#1604;&#1585;&#1602;&#1605;   ";
            AddName = "   &#1576;&#1581;&#1579; &#1576;&#1575;&#1604;&#1575;&#1587;&#1605;   ";
            addNew = "  &#1571;&#1590;&#1601; &#1602;&#1591;&#1593;&#1577; &#1580;&#1583;&#1610;&#1583;&#1607; ";
            tCost = "&#1578;&#1603;&#1604;&#1601;&#1577; &#1575;&#1604;&#1576;&#1606;&#1583; &#1604;&#1604;&#1600;&#1600; ( <font color=\"red\">&#1587;&#1575;&#1593;&#1577;</font> )";
            itemCode = "&#1575;&#1604;&#1603;&#1608;&#1583;";
            name = "&#1575;&#1604;&#1573;&#1587;&#1605;";
            price = "&#1575;&#1604;&#1587;&#1593;&#1585; ";
            count = "&#1575;&#1604;&#1603;&#1605;&#1610;&#1607;";
            cost = " &#1575;&#1580;&#1605;&#1575;&#1604;&#1610; &#1575;&#1604;&#1587;&#1593;&#1585;";
            Mynote = "&#1605;&#1604;&#1575;&#1581;&#1592;&#1575;&#1578;";
            del = "&#1581;&#1584;&#1601; ";
            scr = "images/arrow2.swf";
            updateParts = "&#1575;&#1590;&#1575;&#1601;&#1607; &#1602;&#1591;&#1593; &#1594;&#1610;&#1575;&#1585; &#1604;&#1576;&#1606;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1607;";

            search = "&#1576;&#1581;&#1579; &#1584;&#1575;&#1578;&#1610;";
            searchLableName = "&#1571;&#1603;&#1578;&#1576; &#1575;&#1587;&#1605; &#1575;&#1604;&#1576;&#1606;&#1583; &#1571;&#1608; &#1580;&#1586;&#1569; &#1605;&#1606;&#1607;";
            searchLableCode = "&#1571;&#1603;&#1578;&#1576; &#1603;&#1608;&#1583; &#1575;&#1604;&#1576;&#1606;&#1583; &#1571;&#1608; &#1580;&#1586;&#1569; &#1605;&#1606;&#1607; ";

            searchTitleName = "&#1576;&#1581;&#1579; &#1593;&#1606; &#1576;&#1606;&#1583; &#1589;&#1610;&#1575;&#1606;&#1607; &#1576;&#1575;&#1604;&#1575;&#1587;&#1605;";
            searchTitleCode = "&#1576;&#1581;&#1579; &#1593;&#1606; &#1576;&#1606;&#1583; &#1589;&#1610;&#1575;&#1606;&#1607; &#1576;&#1575;&#1604;&#1603;&#1608;&#1583;";

            searchByName = "&#1576;&#1581;&#1579; &#1576;&#1575;&#1587;&#1605; &#1575;&#1604;&#1576;&#1606;&#1583;";
            searchByCode = "&#1576;&#1581;&#1579; &#1576;&#1603;&#1608;&#1583; &#1575;&#1604;&#1576;&#1606;&#1583;";
            sMinute = "&#1583;&#1602;&#1610;&#1602;&#1577;";
            sHour = "&#1587;&#1575;&#1593;&#1577;";
            sDay = "&#1610;&#1608;&#1605;";
            totCost="\u062A\u0643\u0644\u0641\u0629 \u0627\u0644\u0639\u0645\u0627\u0644\u0647";
        }
        String doubleName = (String) request.getAttribute("name");

        ArrayList hoursJob = new ArrayList();
        String hour = null;
        for (float i = 0; i < 60.5; i += 0.5) {
            hour = new Float(i).toString();
            hoursJob.add(hour);
        }
        hoursJob.remove(0);
    %>

    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>DebugTracker-add new Failure Code</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css"><LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="css\headers.css">        

    </HEAD>

    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

        function submitForm()
        {
            if (!validateData("req", this.ITEM_FORM.title, "Please, enter Code.") || !validateData("minlength=3", this.ITEM_FORM.title, "Please, enter a valid Code.")){
                this.ITEM_FORM.title.focus();
            } else if (!validateData("req", this.ITEM_FORM.description, "Please, enter Code Name.") || !validateData("minlength=3", this.ITEM_FORM.description, "Please, enter a valid Code Name.")){
                this.ITEM_FORM.description.focus(); 
                // } else if (!validateData("req", this.ITEM_FORM.executionHrs, "Please, enter Expected Duration.")){
                //     this.ITEM_FORM.executionHrs.focus();
            } else if (!validateData("req", this.ITEM_FORM.empTitle, "Please, enter Employee Title.")){
                this.ITEM_FORM.empTitle.focus(); 
            } else if (!validateData("req", this.ITEM_FORM.tradeName, "Please, enter Trade Name.")){
                this.ITEM_FORM.tradeName.focus(); 
            } else if (!validateData("req", this.ITEM_FORM.taskType, "Please, enter Task Type.")){
                this.ITEM_FORM.taskType.focus(); 
                // } else if(!validateData("req", this.ITEM_FORM.executionHrs, "Please, enter Execution Hours.")){
                //      this.ITEM_FORM.executionHrs.focus();
            } else if(!checkDateTime()){
                alert("Put time to maintenance item");
                this.ITEM_FORM.minute.focus();
            } else if(!checkCost()) {
                return;
            } else {
                document.ITEM_FORM.action = "<%=context%>/TaskServlet?op=newtask";
                document.ITEM_FORM.submit();  
            }
        }
        
        function checkEmail(email) {
            if (/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(email)){
                return (true)
            }
            return (false)
        }
       
        function IsNumeric()
        {
            var ValidChars = "0123456789.";
            var IsNumber=true;
            var Char;
        
            sText=document.getElementById('executionHrs').value;
        
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
    
        function clearValue(no){
            document.getElementById('Quantity' + no).value = '0';
            total();
        }
    
        function cancelForm()
        {    
            document.ITEM_FORM.action = "main.jsp";
            document.ITEM_FORM.submit();  
        }
    
       
    </SCRIPT>
    <script>

        <%--------------Popup window-------------------%> 
           function openWindowTasks(url)
           {
               window.open(url,"_blank","toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=no, copyhistory=no, width=750, height=500");
           }
            
           function getTasks()
           {
               var formName = document.getElementById('ITEM_FORM').getAttribute("name");
               var name = document.getElementById('taskName').value

               var res = ""
               for (i=0;i < name.length; i++) {
                   res += name.charCodeAt(i) + ',';
               }
                
               openWindowTasks('TaskServlet?op=searchTaskResult&searchType=name&taskName='+res+'&formName='+formName);
           }
            
           function getTasksByCode()
           {
               var formName = document.getElementById('ITEM_FORM').getAttribute("name");
               var name = document.getElementById('taskCode').value
               var res = ""
               for (i=0;i < name.length; i++) {
                   res += name.charCodeAt(i) + ',';
               }
               res = res.substr(0, res.length - 1);

               openWindowTasks('TaskServlet?op=searchTaskResult&searchType=code&taskCode='+res+'&formName='+formName);

           }
        <%---------------------------------%> 
        
            function changeMode(name){
                if(document.getElementById(name).style.display == 'none'){
                    document.getElementById(name).style.display = 'block';
                } else {
                    document.getElementById(name).style.display = 'none';
                }
            }
            
      function calcTotCost(){
        var costHour=document.getElementById('costHour').value;
        //alert('---1'+costHour);
        var day=document.getElementById('day').value;
        //alert('---2'+day);
        var hour=document.getElementById('hour').value;
        //alert('---3'+hour);
        var minute=document.getElementById('minute').value;
        //alert('---4'+minute);
        var totalCost=((day*24)+(hour*1)+(minute/60))*costHour;
        //alert('---5'+totalCost);
        document.getElementById('totalCost').value=totalCost;
    }
        
    </script>
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
        var count = 0;
        var itemsCode;
        var itemNames;
        var nowMode="code";
    
        var lookAheadArray = null;
        var suggestionDiv = null;
        var cursor;
        var inputTextField;
        var debugPane = null;
        var urlbase = '<%=context%>';
        var checkMinsLabel;
        var empty="";
    
        window.onload = function (){
            init("title");
        }
     
        function init (field) {
            inputTextField = document.getElementById(field);
            cursor = -1;
            fillArrayWithAllUsernames();
            inputTextField.onkeyup = function (inEvent) {
                if (!inEvent) {
                    inEvent = window.event;
                }    
                keyUpHandler(inEvent);
            }

            inputTextField.onkeydown = function (inEvent) {
                if (!inEvent){
                    inEvent = window.event;
                }
                keyDownHandler(inEvent);
            }
        
            inputTextField.onblur = function () {
                hideSuggestions();
            }

            createDiv();
        }

        function fillArrayWithAllUsernames(){ 
            var url = "<%=context%>/TaskServlet?op=list";
        
            if (window.XMLHttpRequest) { 
                req = new XMLHttpRequest(); 
            } else if (window.ActiveXObject) { 
                req = new ActiveXObject("Microsoft.XMLHTTP"); 
            } 
        
            req.open("Post",url,true); 
            req.onreadystatechange =  callbackFilltaskcode;
            req.send(null);
        } 
    
        function callbackFilltaskcode() { 
            if (req.readyState==4) { 
                if (req.status == 200) { 
                    var result= req.responseText;
                    var arr=result.split('&#');
                
                    itemsCode=arr[0].split('!=');
                    lookAheadArray =itemsCode;
                    itemNames= arr[1].split('!=');
                    nowMode="code";
                } 
            } 
        }
    
        function createDiv(){
            suggestionDiv = document.createElement("div");
            suggestionDiv.style.zIndex = "1000";
            suggestionDiv.style.opacity ="1.0";
            suggestionDiv.style.repeat = "repeat";
            suggestionDiv.style.filter = "alpha(opacity=80)";
            suggestionDiv.className = "suggestions";
            suggestionDiv.style.visibility = "hidden";
            suggestionDiv.style.width = inputTextField.offsetWidth;
            suggestionDiv.style.backgroundColor = "#FFFFFF";
            suggestionDiv.style.autocomplete = "off";
            suggestionDiv.style.backgroundImage = "url(transparent50.png)";
            //when the user clicks on the a suggestion, get the text (innerHTML)
            //and place it into a inputTextField
        
            suggestionDiv.onmouseup = function() {
                inputTextField.focus();
            }
        
            suggestionDiv.onmouseover = function(inputEvent) {
                inputEvent = inputEvent || window.event;
                sugTarget = inputEvent.target || inputEvent.srcElement;
                highlightSuggestion(sugTarget);
            }
        
            suggestionDiv.onmousedown = function(inputEvent) {
                inputEvent = inputEvent || window.event;
                sugTarget = inputEvent.target || inputEvent.srcElement;
                inputTextField.value = sugTarget.firstChild.nodeValue;
                lookupUsername(inputTextField.value);
                hideSuggestions();
            }
        
            document.body.appendChild(suggestionDiv);
        }
    
        function keyDownHandler(inEvent ){
            switch(inEvent.keyCode) {
                /* up arrow */
                case 38: 
                    if (suggestionDiv.childNodes.length > 0 && cursor > 0) {
                        var highlightNode = suggestionDiv.childNodes[--cursor];
                        highlightSuggestion(highlightNode);
                        inputTextField.value = highlightNode.firstChild.nodeValue;   
                    }
                    break;
            
                /* Down arrow */
            case 40: 
                if (suggestionDiv.childNodes.length > 0 && cursor < suggestionDiv.childNodes.length-1) {
                    var newNode = suggestionDiv.childNodes[++cursor];
                    highlightSuggestion(newNode);
                    inputTextField.value = newNode.firstChild.nodeValue; 
                }
                break;
                
            /* Enter key = 13 */
        case 13: 
            var lookupName = inputTextField.value;
            hideSuggestions();
            lookupUsername(lookupName);
            break;
    }
} 
    
function keyUpHandler(inEvent) {
    var potentials = new Array();
    var enteredText = inputTextField.value;
    var iKeyCode = inEvent.keyCode;

    if (iKeyCode == 32 || iKeyCode == 8 || ( 45 < iKeyCode && iKeyCode < 112) || iKeyCode > 123) /*keys to consider*/{
        if (enteredText.length > 0){
            for (var i=0; i < lookAheadArray.length; i++) { 
                if (lookAheadArray[i].indexOf(enteredText) == 0) {
                    potentials.push(lookAheadArray[i]);
                } 
            }

            showSuggestions(potentials);
        }
            
        if (potentials.length > 0) {
            if (iKeyCode != 46 && iKeyCode != 8) {
                typeAhead(potentials[0]);
            }

            showSuggestions(potentials);
        } else {
            hideSuggestions();
        }
    }
}
    
function hideSuggestions () {
    suggestionDiv.style.visibility = "hidden";
}

function highlightSuggestion(suggestionNode) {
    for (var i=0; i < suggestionDiv.childNodes.length; i++) {
        var sNode = suggestionDiv.childNodes[i];
            
        if (sNode == suggestionNode) {
            sNode.className = "current"
        } else if (sNode.className == "current") {
            sNode.className = "";
        }
    }
}
    
function selectRange(start , end ) {
    if (inputTextField.createTextRange) {
        var sRange = inputTextField.createTextRange(); 
        sRange.moveStart("character", start); 
        sRange.moveEnd("character", end - inputTextField.value.length);      
        sRange.select();
    } else if (inputTextField.setSelectionRange) {
        inputTextField.setSelectionRange(start, end);
    }     
        
    inputTextField.focus();      
} 

function showSuggestions(suggestions) {
    var sDiv = null;    
    suggestionDiv.innerHTML = "";  

    for (i=0; i < suggestions.length; i++) {
        sDiv = document.createElement("div");
        sDiv.appendChild(document.createTextNode(suggestions[i]));
        suggestionDiv.appendChild(sDiv);
    }

    suggestionDiv.style.top = (210+inputTextField.offsetTop+inputTextField.offsetHeight+document.getElementById("code").offsetTop+document.getElementById("data").offsetTop) + "px";
    suggestionDiv.style.left = (-100+inputTextField.offsetLeft+document.getElementById("code").offsetLeft+document.getElementById("data").offsetLeft) + "px";
    suggestionDiv.style.visibility = "visible";
}

function typeAhead(suggestion) {
    if (inputTextField.createTextRange || inputTextField.setSelectionRange){
        var iLen = inputTextField.value.length; 
        inputTextField.value = suggestion; 
        selectRange(iLen, suggestion.length);
    }
}
    
function reloadAE(nextMode){
    var url = "<%=context%>/ajaxGetItrmName?key="+nextMode;
        
    if (window.XMLHttpRequest){ 
        req = new XMLHttpRequest(); 
    } else if (window.ActiveXObject) { 
        req = new ActiveXObject("Microsoft.XMLHTTP"); 
    } 
        
    req.open("Post",url,true); 
    req.onreadystatechange =  callbackFillreload;
    req.send(null);
}

function callbackFillreload(){
    if (req.readyState==4) { 
        if (req.status == 200) { 
            window.location.reload();
        }
    }
}
    
function checkTime()
{
    checkMinsLabel = document.getElementById("executionHrs").value;
    if(parseInt(checkMinsLabel) <= 0 || checkMinsLabel.indexOf("-")>=0)
    {
        alert("Time must be positive and more than zero");
        document.getElementById("executionHrs").value='';
    }
}

function IsNumeric(id) {
    var ValidChars = "0123456789";
    var IsNumber=true;
    var Char;
    var valMinute;
    var valHour;
    sText=document.getElementById(id).value;

    for (i = 0; i < sText.length && IsNumber == true; i++) {
        Char = sText.charAt(i);

        if (ValidChars.indexOf(Char) == -1) {
            IsNumber = false;
            alert("This Value { " + sText +" } must be positive integer and more than zero");
            document.getElementById(id).value='';
            document.getElementById(id).focus();
        }
    }
         
    valMinute=document.getElementById('minute').value;
    if(parseInt(valMinute) > 59) {
        IsNumber = false;
        alert("Minutes should be not more than 59");
        document.getElementById('minute').value='';
        document.getElementById('minute').focus();
    }

    valHour=document.getElementById('hour').value;
    if(parseInt(valHour) > 23) {
        IsNumber = false;
        alert("Hours should be not more than 23");
        document.getElementById('hour').value='';
        document.getElementById('hour').focus();
    }
    return IsNumber;
}

   

function checkDateTime()
{
    var count=0;
                
    if (document.getElementById('minute').value != null && document.getElementById('minute').value != '' && document.getElementById('minute').value !='00' && document.getElementById('minute').value !='0')
    {
        count = count+1;
    }else if(document.getElementById('hour').value != null && document.getElementById('hour').value != '' && document.getElementById('hour').value !='00' && document.getElementById('hour').value !='0')
    {
        count = count+1;
    }else if(document.getElementById('day').value != null && document.getElementById('day').value != '' && document.getElementById('day').value !='00' && document.getElementById('day').value !='0')
    {
        count = count+1;
    }
    if(count>0){
        return true;
    }else{
        return false;
    }
}
    
function checkCost() {

    if(document.getElementById('costHour').value == null || document.getElementById('costHour').value == '' || document.getElementById('costHour').value =='00' || document.getElementById('costHour').value =='0') {
        alert("Must Enter Cost of Task for Hour ...");
        document.getElementById('costHour').focus();
        return false;
    }
    return true;
}
    </SCRIPT>


    <script src='ChangeLang.js' type='text/javascript'></script>
    <BODY>

        <FORM NAME="ITEM_FORM" METHOD="POST">

            <DIV align="left" STYLE="color:blue;">
                <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
                <button  onclick="JavaScript: cancelForm();" class="button"><%=cancel_button_label%><IMG VALIGN="BOTTOM"   SRC="images/cancel.gif"> </button>
                <button  onclick="JavaScript:  submitForm();" class="button"><%=save_button_label%><IMG HEIGHT="15" SRC="images/save.gif"></button>
            </DIV> 
            <fieldset class="set" align="center">
                <legend align="center">
                    <table dir="<%=dir%>" align="center">
                        <tr>
                            <td class="td">
                                <font color="blue" size="6"><%=title_1%></font> 
                            </td>
                        </tr>
                    </table>
                </legend>

                <%
                    if (null != doubleName) {
                %>
                <table dir="<%=dir%>" align="<%=align%>" width="400">
                    <tr>
                        <td class="bar" style="height:30;">
                            <center>
                                <font size="3" color="black" ><%=Dupname%></font>
                            </center>
                        </td>
                    </tr>
                </table>
                <%}%>    
                <%
                    if (null != status) {
                        if (status.equalsIgnoreCase("ok")) {
                %>  
                <tr>
                <table align="<%=align%>" dir=<%=dir%> width="400">
                    <tr>                    
                        <td class="bar">
                            <center>
                                <font size="3" color="black" ><%=sStatus%></font>
                            </center>
                        </td>                    
                    </tr>
                </table>
                </tr>
                <%
            } else {%>
                <tr>
                <table align="<%=align%>" dir=<%=dir%> width="400">
                    <tr>                    
                        <td class="bar">
                            <center>
                                <font size="3" color="red" ><%=fStatus%></font> 
                            </center>
                        </td>                    
                    </tr>
                </table>
                </tr>
                <%}
                }%>


                <table align="<%=align%>" dir=<%=dir%>>
                    <TR COLSPAN="2" ALIGN="<%=align%>">
                        <TD STYLE="<%=style%>" class='td'>
                            <FONT color='red' size='+1'><%=title_2%></FONT> 
                        </TD>
                    </TR>
                </table>
                <br>
                <TABLE ALIGN="<%=align%>" DIR="<%=dir%>" border="0" width="80%" ID="code">
                    <%--
                    <TR>
                        <TD STYLE="<%=style%>" class="bar">
                            <LABEL FOR="str_Function_Name">
                                <p><b><%=code%></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>" CLASS="td" WIDTH="10%" ID="data">
                    <input type="text" dir="ltr" autocomplete="off" size="24" name="title" ID="title">
                    </TD>
                    <td width="2%" CLASS="td">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <TD STYLE="<%=style%>" class='td' WIDTH="25%">
                        &nbsp;
                    </TD>
                    <TD STYLE="<%=style%>" class='td'>
                        &nbsp;
                    </TD>
                    </TR>
                    --%>
                    <TR>
                        <TD NOWRAP STYLE="<%=style%>" class="bar" WIDTH="15%">
                            <LABEL FOR="str_Function_Name">
                                <p><b><%=code%></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>" CLASS="td" ID="data">
                            <%--<input type="TEXT" name="title" ID="title" size="24" value="" maxlength="255">--%>
                            <%if (status != null && status.equalsIgnoreCase("ok")) {%>
                            <input type="text" dir="ltr" autocomplete="off" value="<%=(String) taskWbo.getAttribute("title")%>" size="24" name="title" ID="title">
                            <%} else {%>
                            <input type="text" dir="ltr" autocomplete="off" size="24" name="title" ID="title">
                            <%}%>
                        </TD>

                        <TD STYLE="<%=style%>" class='td' WIDTH="5%" >
                            &nbsp;
                        </TD>

                        <TD NOWRAP STYLE="<%=style%>" class="bar" WIDTH="15%">
                            <LABEL FOR="str_Function_Desc">
                                <p><b> <%=Jops%></b>&nbsp;
                            </LABEL>
                        </TD>                    
                        <TD STYLE="<%=style%>" class='td'  WIDTH="33">
                            <SELECT name="empTitle" id="empTitle" style="width:180px">
                                <%if (status != null && status.equalsIgnoreCase("ok")) {
                                        String employeeName = (String) taskWbo.getAttribute("empName");
                                %>
                                <sw:WBOOptionList wboList='<%=EmpTitleList%>' scrollTo="<%=employeeName%>" displayAttribute = "name" valueAttribute="id"/>
                                <%} else {%>
                                <sw:WBOOptionList wboList='<%=EmpTitleList%>' displayAttribute = "name" valueAttribute="id"/>
                                <%}%>
                            </SELECT>
                        </TD>
                    </TR>
                    <TR>
                        <TD NOWRAP STYLE="<%=style%>" class="bar">
                            <LABEL FOR="Category">
                                <p><b><%=Category%></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>" class='td'  WIDTH="33">
                            <SELECT name="categoryName" id="categoryName" style="width:180px">
                                <%if (status != null && status.equalsIgnoreCase("ok")) {
                                        String parentName = (String) taskWbo.getAttribute("parentName");
                                %>
                                <sw:WBOOptionList wboList='<%=parentUnitList%>' scrollTo="<%=parentName%>" displayAttribute = "unitName" valueAttribute="id"/>
                                <%} else {%>
                                <sw:WBOOptionList wboList='<%=parentUnitList%>' displayAttribute = "unitName" valueAttribute="id"/>
                                <%}%>
                            </SELECT>
                        </TD>
                        <TD STYLE="<%=style%>" class='td'>
                            &nbsp;
                        </TD>
                        <TD NOWRAP STYLE="<%=style%>" class="bar">
                            <LABEL FOR="assign_to">
                                <p><b><%=taskType%></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>" class='td'  WIDTH="33">
                            <SELECT name="taskType" id="taskType" style="width:180px">
                                <%if (status != null && status.equalsIgnoreCase("ok")) {
                                        String taskTypeName = (String) taskWbo.getAttribute("taskTypeName");
                                %>
                                <sw:WBOOptionList wboList='<%=tasktypeList%>' scrollTo="<%=taskTypeName%>" displayAttribute = "name" valueAttribute="id"/>
                                <%} else {%>
                                <sw:WBOOptionList wboList='<%=tasktypeList%>' displayAttribute = "name" valueAttribute="id"/>
                                <%}%>
                            </SELECT>
                        </TD>
                    </TR>
                    <tr>
                    <input type="hidden" name="jobzise" ID="jobzise" value="<%=JobZiseList.get(0).toString()%>">
                    <%--
                    <TD STYLE="<%=style%>" class="bar">
                        <LABEL FOR="assign_to">
                            <p><b>
                            <%=JobZise%></b>&nbsp;
                    </LABEL></td>
                    <TD STYLE="<%=style%>" class='td'  WIDTH="33">
                       
                        <select name="jobzise" ID="jobzise" style="width:180px">
                            <%if(status!=null && status.equalsIgnoreCase("ok")){%>
                            <sw:OptionList optionList='<%=JobZiseList%>' scrollTo = "<%=(String)taskWbo.getAttribute("repairtype")%>"/>
                            <%}else{%>
                            <sw:OptionList optionList='<%=JobZiseList%>' scrollTo = ""/>
                            <%}%>
                        </SELECT>
                    </td>
                    --%>
                    <TD NOWRAP STYLE="<%=style%>" class="bar">
                        <LABEL FOR="assign_to">
                            <p><b><%=tradeName%></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="<%=style%>" class='td'  WIDTH="33">
                        <SELECT name="tradeName" id="tradeName" style="width:180px">
                            <%if (status != null && status.equalsIgnoreCase("ok")) {
                                    String tradeTypeName = (String) taskWbo.getAttribute("tradeName");
                            %>
                            <sw:WBOOptionList wboList='<%=tradeList%>' scrollTo="<%=tradeTypeName%>" displayAttribute = "tradeName" valueAttribute="tradeId"/>
                            <%} else {%>
                            <sw:WBOOptionList wboList='<%=tradeList%>' displayAttribute = "tradeName" valueAttribute="tradeId"/>
                            <%}%>
                        </SELECT>
                    </TD>
                    <TD STYLE="<%=style%>" class='td' >
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    </TD>
                    <TD NOWRAP STYLE="<%=style%>" class="bar">
                        <LABEL FOR="str_Function_Desc" ID="timeInMins">
                            <p><b> <%=EstimatedHours%></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="<%=style%>"  class='td'>
                        <table ALIGN="<%=align%>" DIR="<%=dir%>">
                            <tr>
                                <td style="border-right-width:1px;border-left-width:1px"><font color="red"><b><%=sMinute%></b></font></td>
                                <td ><font color="red"><b><%=sHour%></b></font></td>
                                <td style="border-right-width:1px;border-left-width:1px"><font color="red"><b><%=sDay%></b></font></td>
                            </tr>
                            <%
                                if (status != null && status.equalsIgnoreCase("ok")) {

                                    HashMap time = new HashMap();
                                    String exeHours = (String) taskWbo.getAttribute("executionHrs");
                                    Double execHr = 0.0;
                                    int execIntHr = 0;
                                    execHr = new Double(exeHours).doubleValue();
                                    if (execHr < 1) {
                                        execHr = 1.0;
                                    }
                                    execIntHr = execHr.intValue();
                                    time = dateAndTime.getDetailsDaysHourMinute(execIntHr);

                                    String minute = (String) time.get("minute");
                                    if (minute == null) {
                                        minute = "";
                                    }
                            %>
                            <tr>
                                <td width="5%" style="border-right-width:1px;border-left-width:1px">
                                    <% if (new Integer(time.get("minute").toString()).intValue() > 0) {%>
                                    <select style="width:40px;" name="minute" id="minute">
                                        <option value="00" <%if (minute.equals("00")) {%>selected<%}%> >00</option>
                                        <option value="15" <%if (minute.equals("15")) {%>selected<%}%> >15</option>
                                        <option value="30" <%if (minute.equals("30")) {%>selected<%}%> >30</option>
                                        <option value="45" <%if (minute.equals("45")) {%>selected<%}%> >45</option>
                                    </select>
                                    <% } else {%>
                                    <select style="width:40px;" name="minute" id="minute">
                                        <option value="00" >00</option>
                                        <option value="15" >15</option>
                                        <option value="30" >30</option>
                                        <option value="45" >45</option>
                                    </select>
                                    <% }%>
                                </td>
                                <td width="5%">
                                    <% if (new Integer(time.get("hours").toString()).intValue() > 0) {%>
                                    <input style="width:20px;" type="text" name="hour" id="hour" maxlength="2" value="<%=time.get("hours")%>" ONBLUR="IsNumeric(this.id);">
                                    <% } else {%>
                                    <input style="width:20px;" type="text" name="hour" id="hour" maxlength="2" ONBLUR="IsNumeric(this.id);">
                                    <% }%>
                                </td>
                                <td width="5%" style="border-right-width:1px;border-left-width:1px">
                                    <% if (new Integer(time.get("day").toString()).intValue() > 0) {%>
                                    <input style="width:20px;" type="text" name="day" id="day" maxlength="2" value="<%=time.get("day")%>" ONBLUR="IsNumeric(this.id);">
                                    <% } else {%>
                                    <input style="width:20px;" type="text" name="day" id="day" maxlength="2" ONBLUR="IsNumeric(this.id);">
                                    <% }%>
                                </td>
                            </tr>
                            <% } else {%>
                            <tr>
                                <td width="5%" style="border-right-width:1px;border-left-width:1px">
                                    <select style="width:40px;" name="minute" id="minute">
                                        <option value="00" >00</option>
                                        <option value="15" >15</option>
                                        <option value="30" >30</option>
                                        <option value="45" >45</option>
                                    </select>
                                </td>
                                <td width="5%"><input style="width:20px;" type="text" name="hour" id="hour" maxlength="2" ONBLUR="IsNumeric(this.id);"></td>
                                <td width="5%" style="border-right-width:1px;border-left-width:1px"><input style="width:20px;" type="text" name="day" id="day" maxlength="2" ONBLUR="IsNumeric(this.id);"></td>
                            </tr>
                            <% }%>
                        </table>
                    </TD>
                    </tr>
                    <TR>
                        <td width="2%" CLASS="td">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                        <td width="2%" CLASS="td">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                        <td width="2%" CLASS="td">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                        <TD STYLE="<%=style%>" WIDTH="5%"  class="bar">
                            <LABEL FOR="str_Function_Desc">
                                <p><b> <%=tCost%></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>" CLASS="td" WIDTH="10%">
                            <%if (status != null && status.equalsIgnoreCase("ok")) {%>
                            <input type="text" maxlength="5" name="costHour" id="costHour" value="<%=(String) taskWbo.getAttribute("costHour")%>" style="width:40px" ONBLUR="IsNumeric(this.id);">
                            <%} else {%>
                            <input type="text" maxlength="5" name="costHour" id="costHour" style="width:40px"  ONBLUR="IsNumeric(this.id);">
                            <%}%>
                        </TD>
                    </TR>
                    
                  <TR>
                        <td width="2%" CLASS="td">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                        <td width="2%" CLASS="td">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                        <td width="2%" CLASS="td">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                        <TD STYLE="<%=style%>" WIDTH="5%"  class="bar">
                            <LABEL FOR="str_Function_Desc">
                                <p><b> <%=totCost%></b>&nbsp;
                            </LABEL>
                        </TD>

                        <TD STYLE="<%=style%>" CLASS="td" WIDTH="20%" >
                            <input type="text" maxlength="5" name="totalCost" id="totalCost" style="background-color: yellow;" onfocus="calcTotCost()" >
                        </TD>
                    </TR>             
                    <TR>
                        <TD STYLE="<%=style%>" WIDTH="5%"  class="bar">
                            <LABEL FOR="str_Function_Desc">
                                <p><b> <%=code_name%></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>" CLASS="td" WIDTH="10%">
                            <%if (status != null && status.equalsIgnoreCase("ok")) {%>
                            <textarea name="description" id="description" style="width:180px;height:40px;"><%=(String) taskWbo.getAttribute("name")%></textarea>
                            <%} else {%>
                            <textarea name="description" id="description" style="width:180px;height:40px;"></textarea>
                            <%}%>
                        </TD>
                        <td width="2%" CLASS="td">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                        <TD NOWRAP STYLE="<%=style%>" class="bar">
                            <LABEL FOR="str_Function_Desc">
                                <p><b> <%=eng_Desc%></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>"  class='td'>
                            <%if (status != null && status.equalsIgnoreCase("ok")) {%>
                            <textarea name="engDesc" id="engDesc" style="width:180px;height:40px;"><%=(String) taskWbo.getAttribute("engDesc")%></textarea>
                            <%} else {%>
                            <textarea name="engDesc" id="engDesc" style="width:180px;height:40px;"></textarea>
                            <%}%>
                        </TD>
                    </TR>
                </TABLE>
                <br>
                <table align="<%=align%>" border="0" width="80%">
                    <tr>
                        <td width="50%" STYLE="border:0px;">
                            <div STYLE="width:80%;border:2px solid gray;color:white;" class="header" align="<%=align%>">
                                <div ONCLICK="JavaScript: changeMode('menu1');" class="header" STYLE="width:100%;color:white;cursor:pointer;font-size:16px;">
                                    <b>
                                        <%=searchTitleName%>
                                    </b>
                                    <img alt=""  src="images/arrow_down.gif">
                                </div>
                                <div ALIGN="<%=align%>" STYLE="width:100%;color:white;display:block;text-align:right;border-top:2px solid gray;" ID="menu1">
                                    <table align="<%=align%>" border="0" dir="<%=dir%>" width="100%" cellspacing="2">
                                        <tr>
                                            <td CLASS="tRow" bgcolor="white" STYLE="text-align:center;">
                                                <b><%=searchLableName%></b>
                                                <input type="text" name="taskName" id="taskName">
                                            </td>
                                            <td CLASS="tRow" bgcolor="white" STYLE="text-align:center;">
                                                <button onclick="JavaScript:getTasks();" style="width:120"> <%=searchByName%> <IMG VALIGN="BOTTOM" SRC="images/search.gif"></button>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </td>
                    </tr>
                </table>
                <br>
                <table align="<%=align%>" border="0" width="80%">
                    <tr>
                        <td width="50%" STYLE="border:0px;">
                            <div STYLE="width:80%;border:2px solid gray;color:white;" class="header" align="<%=align%>">
                                <div ONCLICK="JavaScript: changeMode('menu2');" class="header" STYLE="width:100%;color:white;cursor:hand;font-size:16;">
                                    <b>
                                        <%=searchTitleCode%>
                                    </b>
                                    <img alt=""  src="images/arrow_down.gif">
                                </div>
                                <div ALIGN="<%=align%>" STYLE="width:100%;color:white;display:block;text-align:right;border-top:2px solid gray;" ID="menu2">
                                    <table align="<%=align%>" border="0" dir="<%=dir%>" width="100%" cellspacing="2">
                                        <tr>
                                            <td CLASS="tRow" bgcolor="white" STYLE="text-align:center;">
                                                <b><%=searchLableCode%></b>
                                                <input type="text" name="taskCode" id="taskCode">
                                            </td>
                                            <td CLASS="tRow" bgcolor="white" STYLE="text-align:center;">
                                                <button onclick="JavaScript:getTasksByCode();" style="width:120"> <%=searchByCode%> <IMG VALIGN="BOTTOM" SRC="images/search.gif"></button>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </td>
                    </tr>
                </table>
                <br>
            </fieldset>
        </FORM>
    </BODY>
</HTML>     
