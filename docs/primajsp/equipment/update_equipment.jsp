<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,java.sql.*,com.silkworm.common.*, com.maintenance.db_access.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.tracker.db_access.*, com.contractor.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="java.text.SimpleDateFormat"%>

<%
TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

MetaDataMgr metaMgr = MetaDataMgr.getInstance();
MaintainableMgr maintainableMgr = MaintainableMgr.getInstance();
ProjectMgr projectMgr = ProjectMgr.getInstance();
SupplierMgr supplierMgr = SupplierMgr.getInstance();
DepartmentMgr deptMgr = DepartmentMgr.getInstance();
EmployeeMgr empMgr = EmployeeMgr.getInstance();
SupplierEquipmentMgr equipSupMgr = SupplierEquipmentMgr.getInstance();
EquipOperationMgr eqpOpMgr = EquipOperationMgr.getInstance();
ProductionLineMgr  productionLineMgr = ProductionLineMgr.getInstance();

WebBusinessObject equipmentWBO = (WebBusinessObject) request.getAttribute("equipmentWBO");
WebBusinessObject wboTemp = maintainableMgr.getOnSingleKey(equipmentWBO.getAttribute("parentId").toString());
WebBusinessObject locationWBO = projectMgr.getOnSingleKey(equipmentWBO.getAttribute("site").toString());
WebBusinessObject deptWBO = deptMgr.getOnSingleKey(equipmentWBO.getAttribute("department").toString());
WebBusinessObject productionLineWBO = productionLineMgr.getOnSingleKey(equipmentWBO.getAttribute("productionLine").toString());

WebBusinessObject empWBO = empMgr.getOnSingleKey(equipmentWBO.getAttribute("empID").toString());
WebBusinessObject eqSupWBO = equipSupMgr.getOnSingleKey(equipmentWBO.getAttribute("id").toString());
WebBusinessObject supWBO = supplierMgr.getOnSingleKey(eqSupWBO.getAttribute("supplierID").toString());
WebBusinessObject contEmpWBO = empMgr.getOnSingleKey(eqSupWBO.getAttribute("contractEmp").toString());
Vector eqpOpVector = eqpOpMgr.getOnArbitraryKey(equipmentWBO.getAttribute("id").toString(), "key1");
WebBusinessObject eqpOpWbo = (WebBusinessObject) eqpOpVector.elementAt(0);
String EID=(String)equipmentWBO.getAttribute("id");
String context = metaMgr.getContext();
String status = (String) request.getAttribute("Status");
String message = null;



ArrayList categoryList = (ArrayList) request.getAttribute("categoryList");
ArrayList locationsList = projectMgr.getCashedTableAsBusObjects();
ArrayList deptsList = deptMgr.getCashedTableAsBusObjects();
ArrayList productLineList = productionLineMgr.getCashedTableAsBusObjects();
ArrayList empList = new ArrayList();
ArrayList suppliersList = new ArrayList();
ArrayList eqpStatus = new ArrayList();
ArrayList contWarrant = new ArrayList();

eqpStatus.add("Excellent");
eqpStatus.add("Good");
eqpStatus.add("Poor");

contWarrant.add("Contract");
contWarrant.add("Warranty");

empMgr.cashData();
Vector empsVector = empMgr.getOnArbitraryKey("1","key1");
if(empsVector != null){
    for(int i=0; i<empsVector.size(); i++){
        WebBusinessObject empWbo = (WebBusinessObject)empsVector.elementAt(i);
        empList.add(empWbo);
    }
}

supplierMgr.cashData();
Vector suppliersVec = supplierMgr.getOnArbitraryKey("1","key1");
if(suppliersVec != null) {
    for(int i=0; i<suppliersVec.size(); i++){
        WebBusinessObject supplierWbo = (WebBusinessObject) suppliersVec.elementAt(i);
        suppliersList.add(supplierWbo);
    }
}


String s=(String) eqSupWBO.getAttribute("warrantyExpDate");
String s2=(String) eqSupWBO.getAttribute("purchaseDate");
Calendar c = Calendar.getInstance();
Calendar c1 = Calendar.getInstance();
if(eqSupWBO.getAttribute("warrantyExpDate") != null){
    
    TimeServices.setDate(s);
    c.setTimeInMillis(TimeServices.getDate());
}
if(eqSupWBO.getAttribute("purchaseDate") != null){
    
    TimeServices.setDate(s2);
    c1.setTimeInMillis(TimeServices.getDate());
}
String url = request.getRequestURL().toString();
String subURL = url.substring(0, url.indexOf(metaMgr.getContext()));



// get current date
Calendar cal = Calendar.getInstance();
WebBusinessObject loggedUser=(WebBusinessObject)session.getAttribute("loggedUser");
String jDateFormat=loggedUser.getAttribute("javaDateFormat").toString();
SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
String nowDate=sdf.format(cal.getTime());

String cMode= (String) request.getSession().getAttribute("currentMode");
String stat=cMode;
String align=null;
String dir=null;
String style=null;

String lang,langCode,newEq,save,Locations, Departments,Employees, Suppliers,Equipment_Category,M1,M2,
        noData,Date_Disposed,Current_Value,Date_Acquired,Purchase_Price,Warranty_Expiry_Date,Warranty_Contract,
        Contractor,Supplier,Supplying_Data,Model_No,Serial_No,Manufacturer,Manufacturing_Data,Average_Daily_Work,
        Operation_Type,Equipment_Type,Equipment_Operation,Equipment_Description,Attach_Image,Status,Category,
        Department,Location,Auth_Employee,Engine_Number,Equipment_Name,Asset_No,Basic_Data,Auto_Search,km,Hour,
        Static_Equipment, Odometer, Countinous, By_Order,Excellent, Good, Poor,Notes,back,scr,Local_Number,
        Operation_Data,updateEq,Dupname,validDateWarranty,altAsset,production_line,Contract_Date,Warranty_Data;

if(stat.equals("En")){
    align="center";
    dir="LTR";
    style="text-align:left";
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
    langCode="Ar";
    newEq="New Equipment";
    save="Update";
    noData="No Data are available for one or more of those fields:";
    Locations="Locations";
    Departments="Departments";
    Employees="Employees";
    Suppliers="Suppliers";
    Equipment_Category="Equipment Category";
    M1="The Saving Successed";
    M2="The Saving Successed Faild";
    Date_Disposed="Date Disposed";
    Current_Value="Current Value";
    Date_Acquired="Date Acquired";
    Purchase_Price="Purchase Price";
    Warranty_Expiry_Date="Warranty Expiry Date";
    Warranty_Contract="Warranty / Contract ";
    Contractor="Contractor";
    Supplier="Supplier";
    Supplying_Data="Supplying Data";
    Model_No="Model No";
    Serial_No="Serial No";
    Manufacturer="Manufacturer";
    Manufacturing_Data="Manufacturing Data";
    Average_Daily_Work="Average Daily Work";
    Operation_Type="Operation Type";
    Equipment_Type="Equipment Type";
    Equipment_Operation="Equipment Operation";
    Equipment_Description="Equipment Description";
    Attach_Image="Attach Image";
    Status="Status";
    Category="Category";
    Department="Department";
    Location="Location";
    Auth_Employee="Auth. Employee";
    Engine_Number="Engine Number";
    Equipment_Name="Equipment Name";
    Asset_No="Asset No";
    Basic_Data="Basic Data";
    Auto_Search="You Can't Change,linked with ERP ";
    km="km";
    Hour="Hour";
    Static_Equipment="Static Equipment";
    Odometer="Odometer";
    Countinous="Countinous";
    By_Order="By Order";
    Excellent="Excellent";
    Good="Good";
    Poor="Poor";
    Notes="Notes";
    back="Cancel";
    Local_Number="Local Number";
    Operation_Data="Operation Data";
    updateEq="Update Equipment Data";
    scr="images/arrow1.swf";
    Dupname = "Name is Duplicated Chane it";
    validDateWarranty = "Warranty Expiry Date oldest than Date Acquired change date of them.";
    altAsset="Enter The Asset No. Of Equipment Not Less Than 3 Characters <br> Note : You Can Use Auto Complete To Know The Available No. ";
    production_line="Production Line";
    Contract_Date="Contract Date";
    Warranty_Data = "Warranty Data";
}else{
    Contract_Date = "&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1578;&#1593;&#1575;&#1602;&#1583;";
    align="center";
    dir="RTL";
    style="text-align:right";
    lang="English";
    langCode="En";
    newEq=" &#1605;&#1593;&#1583;&#1607; &#1580;&#1583;&#1610;&#1583;&#1607;";
    save=" &#1578;&#1581;&#1583;&#1610;&#1579;";
    noData="&#1604;&#1610;&#1587; &#1607;&#1606;&#1575;&#1603; &#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1578;&#1575;&#1581;&#1607;:";
    Locations="&#1575;&#1604;&#1605;&#1608;&#1575;&#1602;&#1593;";
    Departments=" &#1575;&#1604;&#1575;&#1602;&#1587;&#1575;&#1605;";
    Employees=" &#1575;&#1604;&#1605;&#1608;&#1592;&#1601;&#1610;&#1606;";
    Suppliers="&#1575;&#1604;&#1605;&#1608;&#1585;&#1583;&#1610;&#1606;";
    Equipment_Category="&#1589;&#1606;&#1601; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;";
    M1="&#1578;&#1605; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604; &#1576;&#1606;&#1580;&#1575;&#1581; ";
    M2="&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
    Date_Disposed=" &#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1573;&#1606;&#1578;&#1607;&#1575;&#1569;";
    Current_Value="&#1575;&#1604;&#1602;&#1610;&#1605;&#1607; &#1575;&#1604;&#1581;&#1575;&#1604;&#1610;&#1607;";
    Date_Acquired="&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1575;&#1606;&#1578;&#1575;&#1580;";
    Purchase_Price=" &#1579;&#1605;&#1606; &#1575;&#1604;&#1588;&#1585;&#1575;&#1569;";
    Warranty_Expiry_Date="&#1606;&#1607;&#1575;&#1610;&#1577; &#1575;&#1604;&#1590;&#1605;&#1575;&#1606;";
    Warranty_Contract="&#1575;&#1604;&#1590;&#1605;&#1575;&#1606;";
    Contractor="&#1575;&#1604;&#1605;&#1578;&#1593;&#1575;&#1602;&#1583;";
    Supplier="&#1575;&#1604;&#1605;&#1608;&#1585;&#1583;";
    Supplying_Data="&#1576;&#1610;&#1575;&#1606;&#1575;&#1578; &#1575;&#1604;&#1605;&#1608;&#1585;&#1583;";
    Model_No=" &#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1608;&#1583;&#1610;&#1604;";
    Serial_No="&#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1589;&#1606;&#1593; &#1575;&#1604;&#1605;&#1587;&#1604;&#1587;&#1604;";
    Manufacturer="&#1575;&#1604;&#1605;&#1589;&#1606;&#1593;";
    Manufacturing_Data=" &#1576;&#1610;&#1575;&#1606;&#1575;&#1578; &#1575;&#1604;&#1578;&#1589;&#1606;&#1610;&#1593;";
    Average_Daily_Work=" &#1605;&#1578;&#1608;&#1587;&#1591; &#1575;&#1604;&#1593;&#1605;&#1604; &#1575;&#1604;&#1610;&#1608;&#1605;&#1610;";
    Operation_Type=" &#1606;&#1608;&#1593; &#1575;&#1604;&#1593;&#1605;&#1604;&#1610;&#1607;";
    Equipment_Type="&#1575;&#1604;&#1606;&#1608;&#1593;";
    Equipment_Operation="&#1593;&#1605;&#1604; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;";
    Equipment_Description=" &#1575;&#1604;&#1608;&#1589;&#1601;";
    Attach_Image=" &#1573;&#1585;&#1601;&#1593; &#1589;&#1608;&#1585;&#1607;";
    Status=" &#1575;&#1604;&#1581;&#1575;&#1604;&#1607;";
    Category=" &#1575;&#1604;&#1589;&#1606;&#1601;";
    Department=" &#1575;&#1604;&#1602;&#1587;&#1605;";
    Location=" &#1575;&#1604;&#1605;&#1608;&#1602;&#1593;";
    Auth_Employee=" &#1575;&#1604;&#1605;&#1608;&#1592;&#1601;";
    scr="images/arrow2.swf";
    Equipment_Name="&#1573;&#1587;&#1605; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;";
    Asset_No=" &#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;";
    Basic_Data=" &#1575;&#1604;&#1576;&#1610;&#1575;&#1606;&#1575;&#1578; &#1575;&#1604;&#1585;&#1574;&#1610;&#1587;&#1610;&#1577;";
    Auto_Search="You Can't Change,linked with ERP ";
    km="&#1603;&#1605;";
    Hour="&#1587;&#1575;&#1593;&#1607;";
    Static_Equipment="&#1605;&#1593;&#1583;&#1607; &#1579;&#1575;&#1576;&#1578;&#1607;";
    Odometer="&#1605;&#1593;&#1583;&#1607; &#1576; &#1603;&#1605;";
    Engine_Number="&#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1581;&#1585;&#1603;";
    Countinous="&#1605;&#1587;&#1578;&#1605;&#1585;&#1607;";
    By_Order="&#1576;&#1575;&#1604;&#1591;&#1604;&#1576;";
    Excellent="&#1605;&#1605;&#1578;&#1575;&#1586;&#1607;";
    Good="&#1580;&#1610;&#1583;";
    Poor="&#1585;&#1583;&#1610;&#1574;&#1607;";
    Notes="&#1605;&#1604;&#1575;&#1581;&#1592;&#1575;&#1578;";
    Local_Number=" &#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;";
    Operation_Data="  &#1576;&#1610;&#1575;&#1606;&#1575;&#1578; &#1575;&#1604;&#1578;&#1588;&#1594;&#1610;&#1604;";
    back=tGuide.getMessage("cancel");
    updateEq="&#1578;&#1581;&#1583;&#1610;&#1579; &#1576;&#1610;&#1575;&#1606;&#1575;&#1578; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577;";
    Dupname = "&#1607;&#1584;&#1575; &#1575;&#1604;&#1575;&#1587;&#1605; &#1587;&#1580;&#1604; &#1605;&#1606; &#1602;&#1576;&#1604; &#1610;&#1580;&#1576; &#1578;&#1587;&#1580;&#1610;&#1604; &#1575;&#1587;&#1605; &#1570;&#1582;&#1585;";
    validDateWarranty = "&#1578;&#1575;&#1585;&#1610;&#1582; &#1606;&#1607;&#1575;&#1610;&#1577; &#1575;&#1604;&#1590;&#1605;&#1575;&#1606; &#1571;&#1602;&#1583;&#1605; &#1605;&#1606; &#1578;&#1575;&#1585;&#1610;&#1582; &#1588;&#1585;&#1575;&#1569; &#1575;&#1604;&#1605;&#1575;&#1603;&#1610;&#1606;&#1577; &#1610;&#1580;&#1576; &#1578;&#1594;&#1610;&#1610;&#1585; &#1571;&#1581;&#1583; &#1605;&#1606;&#1607;&#1605;&#1575;";
    altAsset="&#1571;&#1583;&#1582;&#1604; &#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607; &#1604;&#1575;&#1610;&#1602;&#1604; &#1593;&#1606; 3 &#1581;&#1585;&#1608;&#1601;<br>&#1604;&#1575;&#1581;&#1592; :&nbsp;&#1610;&#1605;&#1603;&#1606;&#1603; &#1573;&#1587;&#1578;&#1582;&#1583;&#1575;&#1605; &#1582;&#1575;&#1589;&#1610;&#1577; &#1575;&#1604;&#1571;&#1608;&#1578;&#1608; &#1603;&#1608;&#1605;&#1576;&#1604;&#1610;&#1578; &#1604;&#1603;&#1609; &#1578;&#1593;&#1585;&#1601; &#1575;&#1604;&#1571;&#1585;&#1602;&#1575;&#1605; &#1575;&#1604;&#1605;&#1608;&#1580;&#1608;&#1583;&#1607;&nbsp;";
    production_line="&#1582;&#1591; &#1575;&#1604;&#1575;&#1606;&#1578;&#1575;&#1580;";
    Warranty_Data="&#1576;&#1610;&#1575;&#1606;&#1575;&#1578; &#1575;&#1604;&#1590;&#1605;&#1575;&#1606;";
    
}

String doubleName = (String) request.getAttribute("name");
String checkdate = (String) request.getAttribute("checkdate");
%>

<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
    function getRadioCheck(){
       x = document.getElementById('fixed');
       y = document.getElementById('odometer');
       k = document.getElementById('average');
       if(x.checked){
           z = document.getElementById('km');
           w = document.getElementById('hr');
           z.color = "black"
           w.color = "red"
           k.value = "24"
       } else if(y.checked){
           z = document.getElementById('hr');
           w = document.getElementById('km');
           w.color = "red"
           z.color = "black"
            k.value = "0"
       }
       
    }
    
    function setAverage(){
       x = document.getElementById('Continues');
       y = document.getElementById('ByOrder');
       z = document.getElementById('average');
       
       if(x.checked){
           z.value = "24"
       } else if (y.checked){
           z.value = "0"
       }
    }
    
    function changeImageState(checkBox){
        if(checkBox.checked){
            document.getElementById("file1").disabled = false;
            document.getElementById("imageName").value = "";
        } else {
            document.getElementById("file1").disabled = true;
        }
    }
    
    function changePic(){
        var fileName = document.getElementById("file1").value;
        if(fileName.length > 0){
            if(fileName.indexOf("jpg") > -1 || fileName.indexOf("JPG") > -1){
                document.getElementById("equipmentImage").src = fileName;
                document.getElementById("imageName").value = fileName;
                document.getElementById("file1").value = '';
            } else {
                alert("Invalid Image type, required JPG Image.");
                document.getElementById("equipmentImage").src = 'images/no_image.jpg';
                document.getElementById("imageName").value = "";
                document.getElementById("file1").select();
            }
        } else {
            document.getElementById("equipmentImage").src = 'images/no_image.jpg';
            document.getElementById("imageName").value = "";
        }
    }
    
    function IsNumeric(sText)
        {
            var ValidChars = "0123456789.";
            var IsNumber=true;
            var Char;

            for (i = 0; i < sText.length && IsNumber == true; i++) { 
                Char = sText.charAt(i); 
                if (ValidChars.indexOf(Char) == -1) {
                    IsNumber = false;
                }
        }
        return IsNumber;
    }
    var dp_cal1,dp_cal2; 
    window.onload = function () {
            dp_cal1  = new Epoch('epoch_popup','popup',document.getElementById('acquiringDate'));
            dp_cal2  = new Epoch('epoch_popup','popup',document.getElementById('warrantyDate'));
            init("equipmentNo");
        }
        var lookAheadArray = null;
        var suggestionDiv = null;
        var cursor;
        var inputTextField;
        var debugPane = null;
        var urlbase = '<%=context%>'; 

        function createDiv(){
            suggestionDiv = document.createElement("div");
            suggestionDiv.style.zIndex = "1000000000";
            suggestionDiv.style.opacity ="1.0";
            suggestionDiv.style.repeat = "repeat";
            suggestionDiv.style.filter = "alpha(opacity=80)";
            suggestionDiv.className = "suggestions";
            suggestionDiv.style.visibility = "hidden";
            suggestionDiv.style.width = inputTextField.offsetWidth;
            suggestionDiv.style.backgroundColor = "white";
            suggestionDiv.style.autocomplete = "off";
            suggestionDiv.style.backgroundImage = "url(transparent50.png)";
            //when the user clicks on the a suggestion, get the text (innerHTML)
            //and place it into a inputTextField
            suggestionDiv.onmouseup = function() 
            {
                inputTextField.focus();
            }
            suggestionDiv.onmouseover = function(inputEvent) 
            {
                inputEvent = inputEvent || window.event;
                sugTarget = inputEvent.target || inputEvent.srcElement;
                highlightSuggestion(sugTarget);
            }
            suggestionDiv.onmousedown = function(inputEvent) 
            {
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
                    if (suggestionDiv.childNodes.length > 0 && cursor > 0) 
                    {
                        var highlightNode = suggestionDiv.childNodes[--cursor];
                        highlightSuggestion(highlightNode);
                           inputTextField.value = highlightNode.firstChild.nodeValue;   
                    }
                break;
                /* Down arrow */
                case 40: 
                     if (suggestionDiv.childNodes.length > 0 && cursor < suggestionDiv.childNodes.length-1) 
                     {
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

            if (iKeyCode == 32 || iKeyCode == 8 || ( 45 < iKeyCode && iKeyCode < 112) || iKeyCode > 123) /*keys to consider*/
            {
                if (enteredText.length > 0){
                    for (var i=0; i < lookAheadArray.length; i++) { 
                        if (lookAheadArray[i].indexOf(enteredText) == 0) 
                        {
                            potentials.push(lookAheadArray[i]);

                        } 
                    }
                        showSuggestions(potentials);
                }
                if (potentials.length > 0) 
                {
                    if (iKeyCode != 46 && iKeyCode != 8) 
                    {
                        typeAhead(potentials[0]);
                    }
                    showSuggestions(potentials);
                } 
                else 
                {
                    hideSuggestions();
                   }
            }
        }

        function hideSuggestions () 
        {
            suggestionDiv.style.visibility = "hidden";
        }

        function highlightSuggestion(suggestionNode) 
        {
            for (var i=0; i < suggestionDiv.childNodes.length; i++) 
            {
                var sNode = suggestionDiv.childNodes[i];
                if (sNode == suggestionNode) 
                {
                    sNode.className = "current"
                } 
                else if (sNode.className == "current") 
                {
                    sNode.className = "";
                }
            }
        }

        function init (field) 
        {
           inputTextField = document.getElementById(field);
           cursor = -1;
            fillArrayWithAllUsernames();
            inputTextField.onkeyup = function (inEvent) 
            {

                if (!inEvent) 
                {
                    inEvent = window.event;
                }    
                keyUpHandler(inEvent);
            }

            inputTextField.onkeydown = function (inEvent) 
            {
                if (!inEvent) 
                {
                    inEvent = window.event;
                }    
                keyDownHandler(inEvent);
            }
            inputTextField.onblur = function () 
            {
                hideSuggestions();
            }

            createDiv();
        }

        function selectRange(start , end ) 
        {
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

        function showSuggestions(suggestions) 
        {
            var sDiv = null;
            suggestionDiv.innerHTML = "";  

            for (i=0; i < suggestions.length; i++) 
            {
                sDiv = document.createElement("div");
                sDiv.appendChild(document.createTextNode(suggestions[i]));
                suggestionDiv.appendChild(sDiv);
            }

            suggestionDiv.style.top = (244+inputTextField.offsetTop+inputTextField.offsetHeight+document.getElementById("CellData").offsetTop+document.getElementById("MainTable").offsetTop) + "px";
            suggestionDiv.style.left = (52+inputTextField.offsetLeft+document.getElementById("CellData").offsetLeft+document.getElementById("MainTable").offsetLeft) + "px";
            suggestionDiv.style.visibility = "visible";
        }


        function typeAhead(suggestion) 
        {
            if (inputTextField.createTextRange || inputTextField.setSelectionRange)
            {
                var iLen = inputTextField.value.length; 
                inputTextField.value = suggestion; 
                selectRange(iLen, suggestion.length);
            }
        }

        function fillArrayWithAllUsernames()
        { 
            var url = urlbase+"/EquipmentServlet?op=NumberList";
            if (window.XMLHttpRequest)
            { 
                req = new XMLHttpRequest(); 
            } 
               else if (window.ActiveXObject)
            { 
                req = new ActiveXObject("Microsoft.XMLHTTP"); 
            } 
            req.open("Get",url,true); 
            req.onreadystatechange =  callbackFillUsernames;
            req.send(null);
        } 


        function callbackFillUsernames()
        { 
            if (req.readyState==4)
            { 
               if (req.status == 200)
                { 
                    populateUsernames();
                } 
               } 
        } 

        function populateUsernames()
        {
            var nameString = req.responseText;
            var nameArray = nameString.split(',');

            lookAheadArray = nameArray;
        }

              /*
              * lookupUsername gets the customer information from the database
              */
              function lookupUsername(foundname){ 

                var username = document.getElementById("ajax_username");
                var url = urlbase+"/lookup?username=" + escape(foundname)+"&type="+ escape("2"); 
              //alert('url submitting:'+url);
                if (window.XMLHttpRequest){ 
                     req = new XMLHttpRequest(); 
                 } 
                 else if (window.ActiveXObject){ 
                     req = new ActiveXObject("Microsoft.XMLHTTP"); 
                } 
                req.open("Get",url,true); 
                req.onreadystatechange = callbackLookupUser; 
                req.send(null);
            }     

            function callbackLookupUser(){ 
                if (req.readyState==4){ 
                    if (req.status == 200){ 
                        populateCustomerInfo();
                    } 
                } 
            }
            
            function checkAverage(){
            if (IsNumeric(this.EQUIPMENT_FORM.average.value) && this.EQUIPMENT_FORM.average.value >24 && this.EQUIPMENT_FORM.opration.Continues.checked && this.EQUIPMENT_FORM.eqptype.fixed.checked){
                alert ("Please enter an average number less than or equal 24");
                this.EQUIPMENT_FORM.average.value = 24;
                this.EQUIPMENT_FORM.average.focus();
            } else if (IsNumeric(this.EQUIPMENT_FORM.average.value) && this.EQUIPMENT_FORM.average.value >24 && this.EQUIPMENT_FORM.opration.ByOrder.checked && this.EQUIPMENT_FORM.eqptype.fixed.checked){
                alert ("Please enter an average number less than or equal 24");
                this.EQUIPMENT_FORM.average.value = 24;
                this.EQUIPMENT_FORM.average.focus();
            } else if(IsNumeric(this.EQUIPMENT_FORM.average.value)==false) {
             alert ("Please Enter Number ");
            
            }
            } 
       function cancelForm(url)
        {    
        window.navigate(url);
        }
        
         function showCursor(text){
            document.getElementById('trail').innerHTML=text;
            document.getElementById('trail').style.visibility="visible";
            document.getElementById('trail').style.position="absolute";
            document.getElementById('trail').style.left=event.clientX+10;
            document.getElementById('trail').style.top=event.clientY+150;
         }

        function hideCursor() {
            document.getElementById('trail').style.visibility="hidden";
        } 
        
        function dateLabel(){
        
            name = document.getElementById('contract').value
            
            if(name == "1"){
                document.getElementById("contractCol").color="red";
                document.getElementById("warrantyCol").color="gray";
                
                document.getElementById("contractDate").color="red";
                document.getElementById("warrantyDate").color="gray";
            } else {
                document.getElementById("contractCol").color="gray";
                document.getElementById("warrantyCol").color="red";
                
                document.getElementById("contractDate").color="gray";
                document.getElementById("warrantyDate").color="red";
            }
        }
        
         function submitForm()
        {    
        if (!this.EQUIPMENT_FORM.equipmentNo.disabled && (!validateData("req", this.EQUIPMENT_FORM.equipmentNo, "Please, enter Equipment number.") || !validateData("minlength=3", this.EQUIPMENT_FORM.equipmentNo, "Please, enter a valid Equipment number."))){
               this.EQUIPMENT_FORM.equipmentNo.focus();
           } else if (!this.EQUIPMENT_FORM.equipmentName.disabled && (!validateData("req", this.EQUIPMENT_FORM.equipmentName, "Please, enter Equipment name.") || !validateData("minlength=3", this.EQUIPMENT_FORM.equipmentName, "Please, enter a valid Equipment name."))){
              this.EQUIPMENT_FORM.equipmentName.focus();
            } else if (!validateData("req", this.EQUIPMENT_FORM.engineNo, "Please, enter Engine Number.") || !validateData("minlength=3", this.EQUIPMENT_FORM.engineNo, "Please, enter a valid Engine Number.")){
                this.EQUIPMENT_FORM.engineNo.focus();
            } else if (!validateData("req", this.EQUIPMENT_FORM.proLine, "Please, enter Production Line.")){
                this.EQUIPMENT_FORM.proLine.focus();
            } else if (!validateData("req", this.EQUIPMENT_FORM.average, "Please, enter the working Average number or set it by 0.") || !validateData("numeric", this.EQUIPMENT_FORM.average, "Please, enter a valid Average number.")){
                this.EQUIPMENT_FORM.average.focus();
            } else if (IsNumeric(this.EQUIPMENT_FORM.average.value) && this.EQUIPMENT_FORM.average.value >24 && this.EQUIPMENT_FORM.opration.value == 'Continues'){
                alert ("Please enter an Average number less than or equal 24");
                this.EQUIPMENT_FORM.average.focus();
            } else if (!validateData("req", this.EQUIPMENT_FORM.manufacturer, "Please, enter Manufacturer name.") || !validateData("minlength=3", this.EQUIPMENT_FORM.manufacturer, "Please, enter a valid Manufacturer name.")){
                this.EQUIPMENT_FORM.manufacturer.focus();
                } else if (!validateData("req", this.EQUIPMENT_FORM.modelNo, "Please, enter Model Number.") || !validateData("minlength=3", this.EQUIPMENT_FORM.modelNo, "Please, enter a valid Model Number.")){
                this.EQUIPMENT_FORM.modelNo.focus();
            } else if (!validateData("req", this.EQUIPMENT_FORM.serialNo, "Please, enter Serial Number.") || !validateData("minlength=3", this.EQUIPMENT_FORM.serialNo, "Please, enter a valid Serial Number.")){
                this.EQUIPMENT_FORM.serialNo.focus();
             } else if(!compareDate()){
                alert('Warranty Expiry Date must be greater than Purchase Date');
               }else {
                document.EQUIPMENT_FORM.action = "<%=context%>/EquipmentServlet?op=UpdateEquipment&eID=<%=EID%>";
                document.EQUIPMENT_FORM.submit();  
        }
                }
        
        function compareDate()
        {
            return Date.parse(document.getElementById("warrantyDate").value) > Date.parse(document.getElementById("acquiringDate").value);
        }
        
        
</SCRIPT>

<script src='ChangeLang.js' type='text/javascript'></script>
<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CShjikjhS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
        <link rel="stylesheet" type="text/css" href="css/epoch_styles.css" />
        <script type="text/javascript" src="js/epoch_classes.js"></script>
    </HEAD>
    
    <BODY>
        <FORM NAME="EQUIPMENT_FORM" METHOD="POST">
            <br>
            <DIV align="left" STYLE="color:blue;">
                <input type="button" value="<%=lang%>"  onclick="reloadAE('<%=langCode%>')" class="button">
                <button onclick="JavaScript: cancelForm('<%=context%>/EquipmentServlet?op=ListEquipment');" class="button"> <%=back%> <IMG VALIGN="BOTTOM"   SRC="images/cancel.gif"> </button>
                <button onclick="JavaScript: submitForm();" class="button"> <%=save%> <IMG VALIGN="BOTTOM" SRC="images/save.gif"> </button>
            </DIV>
            <br>
            
            <fieldset align="center" class="set">
                <legend align="center">
                    <table dir="<%=dir%>" align="center">
                        <tr>
                            <td class="td">
                                <font color="blue" size="6"><%=updateEq%></font>
                            </td>
                        </tr>
                    </table>
                </legend>
                
                <br>
                
                
                <table>
                    <tr>
                        <td style="<%=style%>" width="28%" class="td2"><input type="hidden" name="currentValue" ID="currentValue" size="33" value="0" maxlength="255"></td>
                        <td style="<%=style%>" class="td2"><FONT FACE="tahoma"><b><%//=Date_Disposed%><font color="#FF0000"></font>&nbsp;</b></font></td>
                        <td style="<%=style%>"  class="calender">
                        </td>   
                    </tr>
                </table>
                
                <table ALIGN="<%=align%>" dir="<%=dir%>" border="0" width="100%" cellpadding="7" id="MainTable">
                    <% 
                    if(null!=status) {
    if(status.equalsIgnoreCase("ok")){
        message  = M1;
    } else {
        if(status.equalsIgnoreCase("1062")){
            message = M2;
        } else {
            message = M2;
        }
    }
                    %>
                    <TR BGCOLOR="FBE9FE">
                        <TD STYLE="<%=style%>"  colspan="3" class="td">
                            <B><FONT FACE="tahoma" color='blue'><%=message%></FONT></B>
                        </TD>
                    </TR>
                    <%
                    }
                    %>
                    
                    <%
                    if(null!=checkdate) {
                    %>
                    <TR BGCOLOR="FBE9FE">
                        <TD STYLE="<%=style%>" colspan="3" class="td">
                            <B><FONT FACE="tahoma" color='blue'><%=validDateWarranty%></FONT></B>
                        </td>
                    </tr> 
                    <%
                    }
                    %> 
                    
                    <%
                    if(null!=doubleName) {
                    %>
                    <TR BGCOLOR="FBE9FE">
                        <TD STYLE="<%=style%>" colspan="3" class="td">
                            <B><FONT FACE="tahoma" color='blue'><%=Dupname%></FONT></B>
                        </td>
                    </tr> 
                    <%
                    }
                    %>
                    
                    <tr bgcolor="darkkhaki" >
                        <td style="text-align:center" width="100%" colspan="3" class="td"><FONT color='white' SIZE="+1"><%=Basic_Data%></FONT><BR></td>
                    </tr>
                    <% if (equipmentWBO.getAttribute("erpFlag").toString().equals("1")) {%>
                    <tr>
                        <td style="<%=style%>" class="td2"><b><%=Asset_No%><font color="#FF0000">*</font>&nbsp;</b></td>
                        <td style="<%=style%>" class="td2" id="CellData"><input readonly type="TEXT" name="equipmentNo" ID="equipmentNo" size="33" value="<%=equipmentWBO.getAttribute("unitNo")%>" maxlength="20"></td>
                        
                        <TD class="td" STYLE="<%=style%>" WIDTH="500">
                            
                            <b > <font size=1 color=red><%=Auto_Search%></font> </b>
                        </TD>
                    </tr>
                    
                    <tr>
                        <td style="<%=style%>" class="td2"><b><%=Equipment_Name%><font color="#FF0000">*</font>&nbsp;</b></td>
                        <td style="<%=style%>" class="td2"><input readonly type="TEXT" name="equipmentName" ID="equipmentName" size="33" value="<%=equipmentWBO.getAttribute("unitName")%>" maxlength="100"></td>
                        <TD class="td" STYLE="<%=style%>" WIDTH="500">
                            
                            <b > <font size=1 color=red><%=Auto_Search%></font> </b>
                        </TD>
                    </tr>
                    <% } else { %>
                    <tr>
                        <td style="<%=style%>" class="td2"><b><%=Asset_No%><font color="#FF0000">*</font>&nbsp;</b></td>
                        <td style="<%=style%>" class="td2" id="CellData"><input  type="TEXT" name="equipmentNo" ID="equipmentNo" size="33" value="<%=equipmentWBO.getAttribute("unitNo")%>" maxlength="20"></td>
                        
                        
                    </tr>
                    
                    <tr>
                        <td style="<%=style%>" class="td2"><b><%=Equipment_Name%><font color="#FF0000">*</font>&nbsp;</b></td>
                        <td style="<%=style%>" class="td2"><input  type="TEXT" name="equipmentName" ID="equipmentName" size="33" value="<%=equipmentWBO.getAttribute("unitName")%>" maxlength="100"></td>
                        
                    </tr>
                    <% } %>
                    <tr>
                        <td style="<%=style%>" class="td2"><b><%=Engine_Number%><font color="#FF0000">*</font>&nbsp;</b></td>
                        <td style="<%=style%>" class="td2"><input type="TEXT" name="engineNo" ID="engineNo" size="33" value="<%=equipmentWBO.getAttribute("engineNo")%>" maxlength="20"></td>
                    </tr>
                    
                    <!--tr>
                    <td style="<%=style%>" class="td2"><b><%=Auth_Employee%>&nbsp;</b></td>
                    <td style="<%=style%>" class="td2">
                            <SELECT name="AuthEmp" STYLE="width:200px;">
                    <//sw:WBOOptionList wboList='<%//=empList%>' displayAttribute = "empName" valueAttribute="empId" scrollTo="<%//=empWBO.getAttribute("empName").toString()%>"/>
                            </SELECT>
                        </td>
                    </tr-->
                    <input type="hidden" name="AuthEmp" id="AuthEmp" value="1">
                    <tr>
                        <td style="<%=style%>" class="td2"><b><%=Location%><font color="#FF0000">*</font>&nbsp;</b></td>
                        <td style="<%=style%>" class="td2">
                            <SELECT name="locations" STYLE="width:200px; z-index:-1;">
                                <sw:WBOOptionList wboList='<%=locationsList%>' displayAttribute = "projectName" valueAttribute="projectID" scrollTo="<%=locationWBO.getAttribute("projectName").toString()%>"/>
                            </SELECT>
                        </td>
                    </tr>
                    
                    <tr>
                        <td style="<%=style%>" class="td2"><b><%=Department%><font color="#FF0000">*</font>&nbsp;</b></td>
                        <td style="<%=style%>" class="td2">
                            <SELECT name="depts" STYLE="width:200px;">
                                <sw:WBOOptionList wboList='<%=deptsList%>' displayAttribute = "departmentName" valueAttribute="departmentID" scrollTo="<%=deptWBO.getAttribute("departmentName").toString()%>"/>
                            </SELECT>
                        </td>
                    </tr>
                    
                    <tr>
                        <td style="<%=style%>" class="td2"><FONT FACE="tahoma"><b><%=production_line%>&nbsp;</b></font></td>
                        <td style="<%=style%>" class="td2">
                            <SELECT name="proLine" STYLE="width:200px;">
                                <sw:WBOOptionList wboList='<%=productLineList%>' displayAttribute = "code" valueAttribute="id" scrollTo="<%=productionLineWBO.getAttribute("code").toString()%>"/>
                            </SELECT>
                            
                        </td>
                    </tr>
                    
                    <tr>
                        <td style="<%=style%>" class="td2"><b><%=Category%><font color="#FF0000">*</font>&nbsp;</b></td>
                        <td style="<%=style%>" class="td2">
                            <SELECT name="parentCategory" STYLE="width:200px;">
                                <sw:WBOOptionList wboList='<%=categoryList%>' displayAttribute = "unitName" valueAttribute="id" scrollTo="<%=wboTemp.getAttribute("unitName").toString()%>"/>
                            </SELECT>
                        </td>
                    </tr>
                    
                    <tr>
                        <td style="<%=style%>" class="td2"><b><%=Status%>&nbsp;</b></td>
                        <td style="<%=style%>" class="td2">
                            <SELECT name="status" STYLE="width:200px;">
                                <sw:OptionList optionList='<%=eqpStatus%>' scrollTo="<%=equipmentWBO.getAttribute("status").toString()%>"/>
                            </SELECT>
                        </TD>
                    </tr>
                    
                    <tr>
                        <td style="<%=style%>" class="td2"><b><%=Equipment_Description%></b></td>
                        <td style="<%=style%>" class="td2" colspan="3"><TEXTAREA rows="4" name="equipmentDescription" cols="100"><%=equipmentWBO.getAttribute("desc")%></TEXTAREA></td>     
                    </tr>
                    
                    
                    <tr bgcolor="darkkhaki">
                        <td style="text-align:center" colspan="4" class="td"><FONT color='white' size="+1"><%=Equipment_Operation%></FONT></td>
                    </tr>
                    
                    <tr>
                        <td style="<%=style%>" class="td2"><b><%=Equipment_Type%>&nbsp;</b></td>
                        <td style="<%=style%>" class="td2">
                            <Input type="HIDDEN" name="oldeqptype" id="oldeqptype" value="<%=equipmentWBO.getAttribute("rateType").toString()%>">
                            <%
                            if(equipmentWBO.getAttribute("rateType").toString().equalsIgnoreCase("fixed")){
                            %>
                            <Input type="radio" name="eqptype" value="fixed" ID="fixed" ONCLICK="JavaScript: getRadioCheck();" checked>Static Equipment <br>
                            <Input type="radio" name="eqptype" value="odometer" ID="odometer" ONCLICK="JavaScript: getRadioCheck();">Odometer  
                            <%
                            } else {
                            %>
                            <input type="radio" name="eqptype" value="fixed" id="fixed" onclick="JavaScript: getRadioCheck();">Static Equipment <br>
                            <input type="radio" name="eqptype" value="odometer" id="odometer" checked onclick="JavaScript: getRadioCheck();">Odometer
                            <%
                            }
                            %>
                        </TD>
                        
                        <td style="<%=style%>" class="td">
                            <table>
                                <tr>
                                    <td style="<%=style%>" class="td2"><b><%=Operation_Type%>&nbsp;</b></td>
                                    <td style="<%=style%>" class="td2">
                                        <%
                                        if(eqpOpWbo.getAttribute("operation_type").toString().equalsIgnoreCase("Continues")){
                                        %>
                                        <Input type="radio" name="opration" value="Continues" ID="Continues" ONCLICK="JavaScript: setAverage();" checked> <%=Countinous%> <br>
                                        <Input type="radio" name="opration" value="ByOrder" ID="ByOrder" ONCLICK="JavaScript: setAverage();"> <%=By_Order%>  
                                        <%
                                        } else {
                                        %>
                                        <Input type="radio" name="opration" value="Continues" ID="Continues" ONCLICK="JavaScript: setAverage();" > <%=Countinous%> <br>
                                        <Input type="radio" name="opration" value="ByOrder" ID="ByOrder" CHECKED ONCLICK="JavaScript: setAverage();"> <%=By_Order%>   
                                        <%
                                        }
                                        %>
                                    </td>  
                                </tr>
                            </table>
                        </td>
                    </tr>
                    
                    <tr>
                        <td style="<%=style%>" class="td2"><b><%=Average_Daily_Work%><font color="#FF0000">*</font>&nbsp;</b></td>
                        <td style="<%=style%>" class="td2">
                            <input type="TEXT" name="average" ID="average" size="15" value="<%=eqpOpWbo.getAttribute("average").toString()%>" maxlength="24" autocomplete="off" onchange="JavaScript: checkAverage();">&nbsp;&nbsp;&nbsp; <B><FONT ID="km"> <%=km%> </FONT>/ <FONT ID="Hr" COLOR="red"><%=Hour%></FONT></B>
                        </td>
                    </tr>
                    
                    <tr bgcolor="darkkhaki">
                        <td style="text-align:center" colspan="3" class="td"><FONT color='white' size="+1"><%=Manufacturing_Data%></FONT></td>
                    </tr>
                    
                    <tr>
                        <td style="<%=style%>" class="td2"><b><%=Manufacturer%><font color="#FF0000">*</font>&nbsp;</b></td>
                        <td style="<%=style%>" class="td2"><input type="TEXT" name="manufacturer" ID="manufacturer" size="33" value="<%=equipmentWBO.getAttribute("manufacturer")%>" maxlength="255"></td>
                    </tr>
                    
                    <tr>
                    <tr>
                        <td style="<%=style%>" class="td2"><b><%=Serial_No%><font color="#FF0000">*</font>&nbsp;</b></td>
                        <td style="<%=style%>" class="td2"><input type="TEXT" name="serialNo" ID="serialNo" size="33" value="<%=equipmentWBO.getAttribute("serialNo")%>" maxlength="255"></td>
                    </tr>
                    
                    <tr>
                        <td style="<%=style%>" class="td2"><b><%=Model_No%><font color="#FF0000">*</font>&nbsp;</b></td>
                        <td style="<%=style%>" class="td2"><input type="TEXT" name="modelNo" ID="modelNo" size="33" value="<%=equipmentWBO.getAttribute("modelNo")%>" maxlength="255"></td>
                    </tr>
                    
                    <tr>
                        <td style="<%=style%>" valign="top" class="td2"><b><%=Notes%></b></td>
                        <td style="<%=style%>" class="td2" colspan="3"><TEXTAREA rows="4" name="eqDescription" cols="100"><%=eqSupWBO.getAttribute("note")%></TEXTAREA></td>
                    </tr>
                    
                    <tr bgcolor="darkkhaki">
                        <td style="text-align:center" colspan="3" class="td"><FONT color='white' size="+1"><%=Warranty_Data%></FONT></td>
                    </tr>
                    <input type="hidden" name="supplier" value="1">
                    <input type="hidden" name="contractor" value="1">
                    <!--tr>
                    <td style="<%=style%>" class="td2"><b><%=Supplier%>&nbsp;</b></td>
                    <td style="<%=style%>" class="td2">
                            <SELECT name="supplier" STYLE="width:200px;">
                    <//sw:WBOOptionList wboList='<%=suppliersList%>' displayAttribute = "name" valueAttribute="id" scrollTo="<%//=supWBO.getAttribute("name").toString()%>"/>
                            </SELECT>
                        </td>
                    <td style="<%=style%>" class="td">
                            <table>
                                <tr>
                    <td style="<%=style%>" class="td2"><b><%=Contractor%></b></td>
                    <td style="<%=style%>" class="td2">
                                        <SELECT name="contractor" STYLE="width:200px;">
                    <//sw:WBOOptionList wboList='<%=empList%>' displayAttribute = "empName" valueAttribute="empId"/>
                                        </SELECT>
                                    </td>  
                                </tr>
                            </table>
                        </td>     
                    </tr-->
                    
                    <tr>
                        <td style="<%=style%>" class="td2"><b><FONT ID="contractCol" color = "red">Contract / Warranty</font></b></td>
                        <td style="<%=style%>" class="td2">
                            <SELECT name="contract" STYLE="width:200px;">
                                <%if(eqSupWBO.getAttribute("warranty").equals("1")){%>
                                <sw:OptionList optionList='<%=contWarrant%>' scrollTo="Contract"/>
                                <%} else {%>
                                <sw:OptionList optionList='<%=contWarrant%>' scrollTo="Warranty"/>
                                <%}%>
                            </SELECT>
                        </TD>
                    </tr>
                    
                    <tr>
                        <!--td style="<%//=style%>" class="td2"><FONT FACE="tahoma"><b><%//=Purchase_Price%>&nbsp;</b></font></td>
                        <td style="<%//=style%>"class="td2"--><input type ="hidden" name="price" ID="price" size="33" maxlength="255" value="0.0"><!--/td-->
                        <tr>
                            <td style="<%=style%>" class="td2"><FONT FACE="tahoma"><b><%=Date_Acquired%>&nbsp;</b></font></td>
                            <td style="<%=style%>" class="calender">
                                <input name="acquiringDate" id="acquiringDate" type="text" value="<%=nowDate%>" ><img src="images/showcalendar.gif" >
                            </td> 
                        </tr>
                        <!--td style="<%//=style%>" class="td">
                        <table>
                            
                        </table>
                    </td-->
                    </tr>
                    
                    <tr>
                        <tr>
                            <td style="<%=style%>" class="td2"><b><FONT ID="contractDateLABEL" color="red"><%=Contract_Date%></font><br><FONT ID="warrantyDateLabel"><%=Warranty_Expiry_Date%></FONT></b></td>
                            <td style="<%=style%>"  class="calender">
                                <input name="warrantyDate" id="warrantyDate" type="text" value="<%=nowDate%>" ><img src="images/showcalendar.gif" >
                            </td>  
                        </tr>
                    </tr>
                    
                </table>
            </fieldset>
        </FORM>
    </BODY>
</html>