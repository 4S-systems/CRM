<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*, com.maintenance.db_access.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.tracker.db_access.*,com.silkworm.persistence.relational.UniqueIDGen"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="java.text.SimpleDateFormat"%>
<%
TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

MetaDataMgr metaMgr = MetaDataMgr.getInstance();
ProjectMgr projectMgr = ProjectMgr.getInstance();
SupplierMgr supplierMgr = SupplierMgr.getInstance();
DepartmentMgr deptMgr = DepartmentMgr.getInstance();
ProductionLineMgr  productionLineMgr = ProductionLineMgr.getInstance();
EmployeeMgr empMgr = EmployeeMgr.getInstance();
EmpBasicMgr empBasicMgr = EmpBasicMgr.getInstance();
FixedAssetsMachineMgr fixedAssetsMachineMgr =FixedAssetsMachineMgr.getInstance();
fixedAssetsMachineMgr.cashData();
ArrayList categoryList = (ArrayList) request.getAttribute("categoryList");
ArrayList locationsList = projectMgr.getCashedTableAsBusObjects();
ArrayList deptsList = deptMgr.getCashedTableAsBusObjects();
ArrayList machineList = fixedAssetsMachineMgr.getCashedTableAsBusObjects();
ArrayList productLineList = productionLineMgr.getCashedTableAsBusObjects();

ArrayList empList = new ArrayList();
ArrayList suppliersList = new ArrayList();

String context = metaMgr.getContext();
String status = (String) request.getAttribute("Status");
String base = (String) request.getAttribute("base");
String message = null;

empMgr.cashData();
Vector empsVector = empMgr.getOnArbitraryKey("1","key1");
if(empsVector != null){
    for(int i=0; i<empsVector.size(); i++){
        WebBusinessObject empWbo = (WebBusinessObject)empsVector.elementAt(i);
        empList.add(empWbo);
    }
}



//empBasicMgr.cashData();
//Vector empbaiscVector = empBasicMgr.getAllEmpView();
//if(empbaiscVector != null){
//  for(int i=0; i<empbaiscVector.size(); i++){
//     WebBusinessObject empbasicWbo = (WebBusinessObject)empbaiscVector.elementAt(i);
//  empList.add(empbasicWbo);
// }
//}


supplierMgr.cashData();
Vector suppliersVec = supplierMgr.getOnArbitraryKey("1","key1");
if(suppliersVec != null) {
    for(int i=0; i<suppliersVec.size(); i++){
        WebBusinessObject supplierWbo = (WebBusinessObject) suppliersVec.elementAt(i);
        suppliersList.add(supplierWbo);
    }
}

Calendar c = Calendar.getInstance();
// get current date
Calendar cal = Calendar.getInstance();
WebBusinessObject loggedUser=(WebBusinessObject)session.getAttribute("loggedUser");
String jDateFormat=loggedUser.getAttribute("javaDateFormat").toString();
SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
String nowDate=sdf.format(cal.getTime());
String url = request.getRequestURL().toString();
String subURL = url.substring(0, url.indexOf(metaMgr.getContext()));

String cMode= (String) request.getSession().getAttribute("currentMode");
String  stat=cMode;
String align=null;
String dir=null;
String style=null;
String label = null;
String lang,langCode,newEq,save,Locations, Departments,Employees, Suppliers,Equipment_Category,M1,M2,noData
        ,Date_Disposed,Current_Value,Date_Acquired,Purchase_Price,Warranty_Expiry_Date,Warranty,Contract
        ,Contractor,Supplier,Supplying_Data,Model_No,Serial_No,Manufacturer,Manufacturing_Data,
        Average_Daily_Work,Operation_Type,Equipment_Type,Equipment_Operation,Equipment_Description,Attach_Image,Status,
        Category,Department,Location,Auth_Employee,Engine_Number,Equipment_Name,Asset_No,Basic_Data,Auto_Search,km,
        Hour,Static_Equipment, Odometer, Countinous, By_Order,Excellent, Good, Poor,Notes,back,scr,production_line;
String altAsset,altEname,altENo,altEn,altLo,altDept,Dupname,validDateWarranty,altLine,altCategory,altStatus, Contract_Date,fixed_MachineName,titleReading,Warranty_Data;
if(stat.equals("En")){
    
    align="center";
    dir="LTR";
    style="text-align:left";
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
    langCode="Ar";
    newEq="New Equipment";
    save="Save";
    noData="No Data are available for one or more of those fields:";
    Locations="Locations";
    Departments="Departments";
    Employees="Employees";
    Suppliers="Suppliers";
    Equipment_Category="Equipment Category";
    M1="The Saving Successed";
    M2="The Saving Successed Faild";
    
    
    
    
//////////////////
    Date_Disposed="Date Disposed";
    Current_Value="Current Value";
    Date_Acquired="Purchase Date";
    Contract_Date = "Contract Date";
    Purchase_Price="Purchase Price";
    Warranty_Expiry_Date="Warranty Expiry Date";
    Warranty="Warranty";
    Contract="Contract";
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
    Auto_Search="Auto Search";
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
    scr="images/arrow1.swf";
    production_line="Production Line";
    
/////////////////////
    
    altAsset="Enter The Asset No. Of Equipment Not Less Than 3 Characters <br> Note : You Can Use Auto Complete To Know The Available No. ";
    altEname="Enter The Equipment Name - Set of Characters <br> E.g. Car";
    altENo="Enter Engine No. That Written on Your Equipment Engine";
    altEn="Drop Down this List and Select Responsable Employee";
    altLo="Drop Down this List and select Equipment Location";
    altDept="Drop Down this List and Select Equipment Deparment";
    altLine="Drob Down this List and select the Production Line";
    altCategory=" Drob Down this List and select the Category";
    altStatus="Drob Down this List to select the Status";
    Dupname = "Name is Duplicated Chane it";
    validDateWarranty = "Warranty Expiry Date oldest than Date Acquired change date of them.";
    fixed_MachineName="Select Fixed Asset Machine Name";
    titleReading="Equipment Reading";
    Warranty_Data = "Warranty Data";
}else{
    
    align="center";
    dir="RTL";
    style="text-align:Right";
    lang="English";
    langCode="En";
    newEq=" &#1605;&#1593;&#1583;&#1607; &#1580;&#1583;&#1610;&#1583;&#1607;";
    save="&#1578;&#1587;&#1580;&#1610;&#1604;";
    noData="&#1604;&#1610;&#1587; &#1607;&#1606;&#1575;&#1603; &#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1578;&#1575;&#1581;&#1607;:";
    Locations="&#1575;&#1604;&#1605;&#1608;&#1575;&#1602;&#1593;";
    Departments=" &#1575;&#1604;&#1575;&#1602;&#1587;&#1575;&#1605;";
    Employees=" &#1575;&#1604;&#1605;&#1608;&#1592;&#1601;&#1610;&#1606;";
    Suppliers="&#1575;&#1604;&#1605;&#1608;&#1585;&#1583;&#1610;&#1606;";
    Equipment_Category="&#1589;&#1606;&#1601; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;";
    M1="&#1578;&#1605; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604; &#1576;&#1606;&#1580;&#1575;&#1581; ";
    M2="&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
    fixed_MachineName="&#1571;&#1582;&#1578;&#1575;&#1585; &#1607;&#1606;&#1575; &#1573;&#1584;&#1575; &#1603;&#1575;&#1606;&#1578; &#1575;&#1604;&#1605;&#1575;&#1603;&#1610;&#1606;&#1577; &#1605;&#1606; &#1575;&#1604;&#1571;&#1589;&#1608;&#1604; &#1575;&#1604;&#1579;&#1575;&#1576;&#1578;&#1577;";
    
//////////////////
    Date_Disposed=" &#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1573;&#1606;&#1578;&#1607;&#1575;&#1569;";
    Current_Value="&#1575;&#1604;&#1602;&#1610;&#1605;&#1607; &#1575;&#1604;&#1581;&#1575;&#1604;&#1610;&#1607;";
    Date_Acquired="&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1588;&#1585;&#1575;&#1569;";
    Purchase_Price=" &#1579;&#1605;&#1606; &#1575;&#1604;&#1588;&#1585;&#1575;&#1569;";
    Warranty_Expiry_Date="&#1578;&#1575;&#1585;&#1610;&#1582; &#1606;&#1607;&#1575;&#1610;&#1577; &#1575;&#1604;&#1590;&#1605;&#1575;&#1606;";
    Warranty="&#1575;&#1604;&#1590;&#1605;&#1575;&#1606;";
    Contract="&#1575;&#1604;&#1578;&#1593;&#1575;&#1602;&#1583;";
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
    Contract_Date = "&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1578;&#1593;&#1575;&#1602;&#1583;";
    
    Equipment_Name="&#1573;&#1587;&#1605; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;";
    Asset_No=" &#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;";
    Basic_Data=" &#1575;&#1604;&#1576;&#1610;&#1575;&#1606;&#1575;&#1578; &#1575;&#1604;&#1585;&#1574;&#1610;&#1587;&#1610;&#1577;";
    Auto_Search=" &#1576;&#1581;&#1579; &#1584;&#1575;&#1578;&#1610; ";
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
    back=tGuide.getMessage("cancel");
    production_line="&#1582;&#1591; &#1575;&#1604;&#1575;&#1606;&#1578;&#1575;&#1580;";
    
//////////////////
    altAsset="&#1571;&#1583;&#1582;&#1604; &#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607; &#1604;&#1575;&#1610;&#1602;&#1604; &#1593;&#1606; 3 &#1581;&#1585;&#1608;&#1601;<br>&#1604;&#1575;&#1581;&#1592; :&nbsp;&#1610;&#1605;&#1603;&#1606;&#1603; &#1573;&#1587;&#1578;&#1582;&#1583;&#1575;&#1605; &#1582;&#1575;&#1589;&#1610;&#1577; &#1575;&#1604;&#1571;&#1608;&#1578;&#1608; &#1603;&#1608;&#1605;&#1576;&#1604;&#1610;&#1578; &#1604;&#1603;&#1609; &#1578;&#1593;&#1585;&#1601; &#1575;&#1604;&#1571;&#1585;&#1602;&#1575;&#1605; &#1575;&#1604;&#1605;&#1608;&#1580;&#1608;&#1583;&#1607;&nbsp;";
    altEname="&#1571;&#1583;&#1582;&#1604; &#1573;&#1587;&#1605; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607; &#1593;&#1576;&#1575;&#1585;&#1607; &#1593;&#1606; &#1605;&#1580;&#1605;&#1608;&#1593;&#1607; &#1605;&#1606; &#1575;&#1604;&#1581;&#1585;&#1608;&#1601; <br> &#1605;&#1579;&#1575;&#1604; : &#1593;&#1585;&#1576;&#1610;&#1607;";
    altENo="&#1571;&#1583;&#1582;&#1604; &#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1581;&#1585;&#1603; &#1575;&#1604;&#1605;&#1603;&#1578;&#1608;&#1576; &#1593;&#1604;&#1609; &#1605;&#1581;&#1585;&#1603; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;";
    altEn="&#1575;&#1582;&#1578;&#1575;&#1585; &#1605;&#1606; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577; &#1573;&#1587;&#1605; &#1575;&#1604;&#1605;&#1608;&#1592;&#1601; &#1575;&#1604;&#1605;&#1587;&#1574;&#1608;&#1604;";
    altLo="&#1575;&#1582;&#1578;&#1575;&#1585; &#1605;&#1606; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577; &#1573;&#1587;&#1605; &#1605;&#1608;&#1602;&#1593; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;";
    altDept="&#1575;&#1582;&#1578;&#1575;&#1585; &#1605;&#1606; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577; &#1573;&#1587;&#1605; &#1575;&#1604;&#1602;&#1587;&#1605; &#1575;&#1604;&#1578;&#1575;&#1576;&#1593;&#1607; &#1604;&#1607; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;";
    altCategory="&#1571;&#1583;&#1582;&#1604; &#1605;&#1606; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577; &#1606;&#1608;&#1593; &#1575;&#1604;&#1589;&#1606;&#1601; &#1575;&#1604;&#1578;&#1575;&#1576;&#1593; &#1604;&#1607; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577;";
    altStatus="&#1571;&#1583;&#1582;&#1604; &#1605;&#1606; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577; &#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1605;&#1606;&#1578;&#1580;";
    Dupname = "&#1607;&#1584;&#1575; &#1575;&#1604;&#1575;&#1587;&#1605; &#1587;&#1580;&#1604; &#1605;&#1606; &#1602;&#1576;&#1604; &#1610;&#1580;&#1576; &#1578;&#1587;&#1580;&#1610;&#1604; &#1575;&#1587;&#1605; &#1570;&#1582;&#1585;";
    validDateWarranty = "&#1578;&#1575;&#1585;&#1610;&#1582; &#1606;&#1607;&#1575;&#1610;&#1577; &#1575;&#1604;&#1590;&#1605;&#1575;&#1606; &#1571;&#1602;&#1583;&#1605; &#1605;&#1606; &#1578;&#1575;&#1585;&#1610;&#1582; &#1588;&#1585;&#1575;&#1569; &#1575;&#1604;&#1605;&#1575;&#1603;&#1610;&#1606;&#1577; &#1610;&#1580;&#1576; &#1578;&#1594;&#1610;&#1610;&#1585; &#1571;&#1581;&#1583; &#1605;&#1606;&#1607;&#1605;&#1575;";
    altLine="&#1571;&#1583;&#1582;&#1604; &#1605;&#1606; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577; &#1571;&#1587;&#1605; &#1582;&#1591; &#1575;&#1604;&#1571;&#1606;&#1578;&#1575;&#1580; &#1575;&#1604;&#1578;&#1575;&#1576;&#1593; &#1604;&#1607; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577;";
    titleReading="&#1602;&#1585;&#1575;&#1569;&#1577; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577;";
    Warranty_Data="&#1576;&#1610;&#1575;&#1606;&#1575;&#1578; &#1575;&#1604;&#1590;&#1605;&#1575;&#1606;";
    
}

String doubleName = (String) request.getAttribute("name");
String checkdate = (String) request.getAttribute("checkdate");

label = Contract_Date;
%>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">   
    function changeEquipmentName(checkBox){
        if(checkBox.checked){
            document.getElementById("fixedMachine").disabled = false;
            document.getElementById("equipmentName").disabled = true;
            document.getElementById("equipmentNo").disabled = true;
            //document.getElementById("equipmentName").value="0000";
            document.getElementById("equipmentNo").value="0000";
        } else {
            document.getElementById("fixedMachine").disabled = true;
            document.getElementById("equipmentName").disabled = false;
            document.getElementById("equipmentNo").disabled = false;
            document.getElementById("equipmentNo").value="";
        }
    }
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
    
    function submitForm()
        {    
            var fileName = document.getElementById("file1").value;
            
           if(document.getElementById("equipmentNo").disabled = false){
           if (!validateData("req", this.EQUIPMENT_FORM.equipmentNo, "Please, enter Equipment number.") || !validateData("minlength=3", this.EQUIPMENT_FORM.equipmentNo, "Please, enter a valid Equipment number.")){
               this.EQUIPMENT_FORM.equipmentNo.focus();
             } else if (!validateData("req", this.EQUIPMENT_FORM.equipmentName, "Please, enter Equipment name.") || !validateData("minlength=3", this.EQUIPMENT_FORM.equipmentName, "Please, enter a valid Equipment name.")){
              this.EQUIPMENT_FORM.equipmentName.focus();
            }
           }
             //if (!validateData("req", this.EQUIPMENT_FORM.equipmentNo, "Please, enter Equipment number.") || !validateData("minlength=3", this.EQUIPMENT_FORM.equipmentNo, "Please, enter a valid Equipment number.")){
             //  this.EQUIPMENT_FORM.equipmentNo.focus();
           //  } else if (!validateData("req", this.EQUIPMENT_FORM.equipmentName, "Please, enter Equipment name.") || !validateData("minlength=3", this.EQUIPMENT_FORM.equipmentName, "Please, enter a valid Equipment name.")){
            //  this.EQUIPMENT_FORM.equipmentName.focus();
           // } else 
           if (!validateData("req", this.EQUIPMENT_FORM.engineNo, "Please, enter Engine Number.") || !validateData("minlength=3", this.EQUIPMENT_FORM.engineNo, "Please, enter a valid Engine Number.")){
                this.EQUIPMENT_FORM.engineNo.focus();
            } else if (!validateData("req", this.EQUIPMENT_FORM.productionLine, "Please, enter Production Line.")){
                this.EQUIPMENT_FORM.productionLine.focus();
            } else if (!validateData("req", this.EQUIPMENT_FORM.manufacturer, "Please, enter Manufacturer name.") || !validateData("minlength=3", this.EQUIPMENT_FORM.manufacturer, "Please, enter a valid Manufacturer name.")){
                this.EQUIPMENT_FORM.manufacturer.focus();
            } else if (!validateData("req", this.EQUIPMENT_FORM.modelNo, "Please, enter Model Number.") || !validateData("minlength=3", this.EQUIPMENT_FORM.modelNo, "Please, enter a valid Model Number.")){
                this.EQUIPMENT_FORM.modelNo.focus();
            } else if (!validateData("req", this.EQUIPMENT_FORM.serialNo, "Please, enter Serial Number.") || !validateData("minlength=3", this.EQUIPMENT_FORM.serialNo, "Please, enter a valid Serial Number.")){
                this.EQUIPMENT_FORM.serialNo.focus();
            } else if (!validateData("numericfloat", this.EQUIPMENT_FORM.price, "Please, enter a valid Number.")){
                this.EQUIPMENT_FORM.price.focus();
            } else if (!validateData("req", this.EQUIPMENT_FORM.average, "Please, enter the working Average number or set it by 0.") || !validateData("numeric", this.EQUIPMENT_FORM.average, "Please, enter a valid Average number.")){
                this.EQUIPMENT_FORM.average.focus();
            } else if (IsNumeric(this.EQUIPMENT_FORM.average.value) && this.EQUIPMENT_FORM.average.value >24 && this.EQUIPMENT_FORM.opration.value == 'Continues'){
                alert ("Please enter an Average number less than or equal 24");
                this.EQUIPMENT_FORM.average.focus();
            } else if(document.getElementById("checkImage").checked && fileName.indexOf("jpg") == -1 && fileName.indexOf("JPG") == -1 && fileName.length > 0){
                alert("Invalid Image type, required JPG Image.");
            } else if (!validateData("req", this.EQUIPMENT_FORM.averageReading, "Please, enter the Equipment Reading  number or set it by 0.") || !validateData("numeric", this.EQUIPMENT_FORM.averageReading, "Please, enter a valid Equipment Reading number.")){
                this.EQUIPMENT_FORM.averageReading.focus();
            } else if(!compareDate()){
                alert('Warranty Expiry Date must be greater than Purchase Date');
            } else{
                if (this.EQUIPMENT_FORM.price.value ==""){
                   this.EQUIPMENT_FORM.price.value = "0.0";
                }
                document.EQUIPMENT_FORM.action = "<%=context%>/EquipmentServlet?op=SaveEquipment";
                document.EQUIPMENT_FORM.submit();  
            }
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
                document.getElementById("warrantyCol").color="white";
                
                document.getElementById("contractDateLabel").color="red";
                document.getElementById("warrantyDateLabel").color="white";
            } else {
                document.getElementById("contractCol").color="white";
                document.getElementById("warrantyCol").color="red";
                
                document.getElementById("contractDateLabel").color="white";
                document.getElementById("warrantyDateLabel").color="red";
            }
        }
        
         function compareDate()
        {
            return Date.parse(document.getElementById("warrantyDate").value) > Date.parse(document.getElementById("acquiringDate").value);
        }
</script>
<script src='ChangeLang.js' type='text/javascript'></script>
<html>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>Add New Equipment</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
        <link rel="stylesheet" type="text/css" href="css/epoch_styles.css" />
        <script type="text/javascript" src="js/epoch_classes.js"></script>
    </HEAD>
    
    <link rel="stylesheet" type="text/css" href="autosuggest.css" />
    <body>
        <FORM NAME="EQUIPMENT_FORM" METHOD="POST" ENCTYPE="multipart/form-data">
            
            <DIV align="left" STYLE="color:blue;">
                <input type="button" value="<%=lang%>"  onclick="reloadAE('<%=langCode%>')" class="button">
                <button  onclick="JavaScript: cancelForm('<%=context%>/main.jsp');" class="button"> <%=back%> <IMG VALIGN="BOTTOM"   SRC="images/cancel.gif"> </button>
                <button  onclick="JavaScript: submitForm();" class="button"> <%=save%> <IMG VALIGN="BOTTOM"   SRC="images/save.gif"> </button>
            </DIV> 
            
            <br><br>
            <fieldset align="center" class="set" >
            <legend align="center">
                <table dir="<%=dir%>" align="center">
                    <tr>
                        
                        <td class="td">
                            <font color="blue" size="6"> <%=newEq%>     
                            </font>
                            
                        </td>
                    </tr>
                </table>
                
            </legend>
            
            <%
            if((categoryList.size()<=0 || locationsList.size()<=0 || locationsList == null) || (deptsList.size()<=0 || deptsList == null) || (empList.size()<=0 || empList == null) || (suppliersList.size()<=0 || suppliersList == null)){
            %>
            <table border="0" width="600" cellpadding="0" dir="<%=dir%>">
                <TR CLASS="head">
                    <TD class="td" COLSPAN="5">
                        <CENTER><B><Font FACE="tahoma"><B><%=noData%>&nbsp;</B></FONT></B></CENTER>
                    </TD>
                </TR>
                
                <TR>
                    <TD CLASS="shaded">
                        <Font FACE="tahoma"><B><%=Equipment_Category%></B></FONT><br>
                    </TD>
                    
                    <TD CLASS="shaded">
                        <Font FACE="tahoma"><B><%=Locations%></B></FONT><br>
                    </TD>
                    
                    <TD CLASS="shaded">
                        <Font FACE="tahoma"><B><%=Departments%></B></FONT><br>
                    </TD>
                    
                    <TD CLASS="shaded">
                        <Font FACE="tahoma"><B><%=Employees%></B></FONT><br>
                    </TD>
                    <TD CLASS="shaded">
                        <Font FACE="tahoma"><B><%=Suppliers%></B></FONT><br>
                    </TD>
                </TR>
            </TABLE>
            <%
            } else {
            %>
            <table ALIGN="<%=align%>"  dir="<%=dir%>" border="0" width="100%" cellpadding="7" id="MainTable">
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
                <TR  BGCOLOR="FBE9FE">
                    <TD STYLE="<%=style%>" colspan="4" class="td">
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
                    <TD STYLE="<%=style%>" colspan="4" class="td">
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
                    <TD STYLE="<%=style%>" colspan="4" class="td">
                        <B><FONT FACE="tahoma" color='blue'><%=Dupname%></FONT></B>
                    </td>
                </tr> 
                <%
                }
                %> 
                
                <!--TR COLSPAN="2" ALIGN="<%=align%>">
                <td colspan="4" class="td" style=""<%=style%>"">
                <table ALIGN="<%=align%>" >
                            <tr>
                <td STYLE=""<%=style%>"" class="td"><IMG VALIGN="BOTTOM"  HEIGHT="30" SRC="images/note.JPG"></td>
                <TD STYLE=""<%=style%>"" class='td'>
                                    <FONT color='red' size='+1'>&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607;</FONT> 
                                </TD>
                            </tr>
                        </table>
                    </td>
                </TR-->
                
                <tr bgcolor="darkkhaki" >
                    <td style="text-align:center" width="100%" colspan="6" class="td"><FONT color='white' SIZE="+1"><%=Basic_Data%></FONT><BR></td>
                </tr>
                
                <tr>
                    <td style="<%=style%>" class="td2"><FONT FACE="tahoma"><b><%=Asset_No%><font color="#FF0000">*</font>&nbsp;</b></font></td>
                    <td style="<%=style%>" class="td2" id="CellData"><input  type="TEXT" name="equipmentNo" ID="equipmentNo" size="33" value="" maxlength="20"  onclick="JavaScript: showCursor('<%=altAsset%>');" onmouseout="JavScript: hideCursor();" autocomplete="off"></td>
                    
                    <TD class="td" STYLE="<%=style%>" WIDTH="500">
                        
                        <object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=8,0,0,0" width="90" height="25" id="arrow2" ALIGN="<%=align%>">
                            <param name="allowScriptAccess" value="sameDomain" />
                            <param name="movie" value="<%=scr%>" /><param name="quality" value="high" /><param name="bgcolor" value="#ffffff" />
                            <embed src="<%=scr%>" quality="high" bgcolor="#ffffff" width="90" height="25" name="arrow2" ALIGN="<%=align%>" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" />
                        </object>
                        <b><%=Auto_Search%> </b>
                    </TD> 
                </tr>
                <tr>   
                    <!--tr>
                    <td></td>
                    <td style="<%//=style%>" class="td2">
                    <SELECT name="AuthEmp"  ONMOUSEOVER="JavaScript: showCursor('<%//=Asset_No%>');" onmouseout="JavScript: hideCursor();" STYLE="width:200px;z-index:-1;">
                    <//sw:WBOOptionList wboList='<%//=machineList%>' displayAttribute = "machineNo" valueAttribute="machineNo"/>
                        </SELECT>
                    </td>
                </tr-->
                </tr>
                
                <tr>
                    
                    <td style="<%=style%>" class="td2"><FONT FACE="tahoma"><b><%=Equipment_Name%><font color="#FF0000">*</font>&nbsp;</b></font></td>
                    <td style="<%=style%>"  class="td2"><input type="TEXT" name="equipmentName" ID="equipmentName" size="33" value="" onclick="JavaScript: showCursor('<%=altEname%>');" onmouseout="JavScript: hideCursor();"    maxlength="100"></td>
                    
                    <td style="<%=style%>" colspan="2" class="td3" rowspan="8">
                        <img width="250px" name='equipmentImage' id='equipmentImage' alt='document image' src='images/no_image.jpg' border="2">
                        <input type="hidden" name="docType" value="jpg">
                        <input type="hidden" name="docTitle" value="Employee Image">
                        <input type="hidden" name="equipmentID" value="<%=UniqueIDGen.getNextID()%>">
                        <input type="hidden" name="description" value="Employee Image">
                        <input type="hidden" name="faceValue" value="0">
                        <input type="hidden" name="fileExtension" value="jpg">
                        <%
                        c = Calendar.getInstance();
                        Integer iMonth = new Integer(c.get(c.MONTH));
                        int month = iMonth.intValue() + 1;
                        iMonth = new Integer(month);
                        %>
                        <input type="hidden" name="docDate" value="<%=iMonth.toString() + "/" + c.get(c.DATE) + "/" + c.get(c.YEAR)%>">
                        <input type="hidden" name="configType" value="1">
                    </td>
                </tr>
                <tr>
                    
                    <td style="<%=style%>" class="td2">
                        <FONT FACE="tahoma">
                            <input type="checkbox" id="checkMachine" onclick="JavaScript: changeEquipmentName(this);"><b><font color="red"><%=fixed_MachineName%></font></b></input>
                        </font>
                    </td>
                    <td style="<%=style%>" class="td2">
                        <SELECT disabled name="equipmentName" id="fixedMachine"  ONMOUSEOVER="JavaScript: showCursor('<%=altEname%>');" onmouseout="JavScript: hideCursor();" STYLE="width:200px;z-index:-1;">
                            <sw:WBOOptionList wboList='<%=machineList%>' displayAttribute = "machineName" valueAttribute="machineName"/>
                        </SELECT>
                    </td>
                    
                </tr>
                <tr>
                    <td style="<%=style%>" class="td2"><FONT FACE="tahoma"><b><%=Engine_Number%><font color="#FF0000">*</font>&nbsp;</b></font></td>
                    <td style="<%=style%>" class="td2"><input type="TEXT" name="engineNo" ID="engineNo" size="33" value="" onclick="JavaScript: showCursor('<%=altENo%>');" onmouseout="JavScript: hideCursor();" maxlength="100"></td>
                </tr>
                
                <!--tr>
                <td style="<%=style%>" class="td2"><FONT FACE="tahoma"><b><%=Auth_Employee%>&nbsp;</b></font></td>
                <td style="<%=style%>" class="td2">
                <SELECT name="AuthEmp"  ONMOUSEOVER="JavaScript: showCursor('<%=altEn%>');" onmouseout="JavScript: hideCursor();" STYLE="width:200px;z-index:-1;">
                <//sw:WBOOptionList wboList='<%//=empList%>' displayAttribute = "empName" valueAttribute="empId"/>
                        </SELECT>
                    </td>
                </tr-->
                <input type="hidden" name="AuthEmp" id="AuthEmp" value="1">
                <tr>
                    <td style="<%=style%>" class="td2"><FONT FACE="tahoma"><b><%=Location%><font color="#FF0000">*</font>&nbsp;</b></font></td>
                    <td style="<%=style%>" class="td2">
                        <SELECT name="locations" ONMOUSEOVER="JavaScript: showCursor('<%=altLo%>');" onmouseout="JavScript: hideCursor();" STYLE="width:200px; zIndex:10;">
                            <sw:WBOOptionList wboList='<%=locationsList%>' displayAttribute = "projectName" valueAttribute="projectID"/>
                        </SELECT>
                    </td>
                </tr>
                
                <tr>
                    <td style="<%=style%>" class="td2"><FONT FACE="tahoma"><b><%=Department%><font color="#FF0000">*</font>&nbsp;</b></font></td>
                    <td style="<%=style%>" class="td2">
                        <SELECT name="depts" ONMOUSEOVER="JavaScript: showCursor('<%=altDept%>');" onmouseout="JavScript: hideCursor();" STYLE="width:200px;">
                            <sw:WBOOptionList wboList='<%=deptsList%>' displayAttribute = "departmentName" valueAttribute="departmentID"/>
                        </SELECT>
                    </td>
                </tr>
                
                <tr>
                    <td style="<%=style%>" class="td2"><FONT FACE="tahoma"><b><%=production_line%>&nbsp;</b></font></td>
                    <td style="<%=style%>" class="td2" onmouseover="JavaScript: showCursor('<%=altLine%>');" onmouseout="JavScript: hideCursor();">
                        <SELECT name="productionLine" STYLE="width:200px;">
                            <sw:WBOOptionList wboList='<%=productLineList%>' displayAttribute = "code" valueAttribute="id"/>
                        </SELECT>
                        
                    </td>
                </tr>
                
                <tr>
                    <td style="<%=style%>" class="td2"><FONT FACE="tahoma"><b><%=Category%><font color="#FF0000">*</font>&nbsp;</b></font></td>
                    <td style="<%=style%>" class="td2" onmouseover="JavaScript: showCursor('<%=altCategory%>');" onmouseout="JavScript: hideCursor();">
                        <SELECT name="parentCategory" STYLE="width:200px;">
                            <sw:WBOOptionList wboList='<%=categoryList%>' displayAttribute = "unitName" valueAttribute="id"/>
                        </SELECT>
                    </td>
                </tr>
                
                <tr>
                    <td style="<%=style%>" class="td2"><FONT FACE="tahoma"><b><%=Status%>&nbsp;</b></font></td>
                    <td style="<%=style%>" class="td2"  onmouseover="JavaScript: showCursor('<%=altStatus%>');" onmouseout="JavScript: hideCursor();">
                        <SELECT name="status" STYLE="width:200px;z-index:0;">
                            <OPTION VALUE="Excellent"><%=Excellent%>
                            <option value="Good"><%=Good%>
                            <option value="Poor"><%=Poor%>
                        </SELECT>
                    </td>
                </tr>
                
                <tr>
                    <td style="<%=style%>" class="td2">
                        <FONT FACE="tahoma">
                            <input type="checkbox" id="checkImage" onclick="JavaScript: changeImageState(this);"><b><%=Attach_Image%></b></input>
                        </font>
                    </td>
                    <td style="<%=style%>" valign="top" class="td2">
                        <input type="file" name="file1" disabled id="file1" accept="*.jpg" onchange="JavaScript: changePic();">
                        <input type="hidden" name="imageName" id="imageName" value="">
                    </td>
                </tr>
                
                <tr>
                    <td style="<%=style%>" class="td2"><FONT FACE="tahoma"><b><%=Equipment_Description%></b></font></td>
                    <td style="<%=style%>" class="td2" colspan="3"><TEXTAREA rows="4" name="equipmentDescription" cols="115">No Description</TEXTAREA></td>     
                </tr>
                <tr><td class="td"><br><br></td></tr>
                <tr bgcolor="darkkhaki">
                    <td style="text-align:center" colspan="4" class="td"><FONT color='white' size="+1"><%=Equipment_Operation%></FONT></td>
                </tr>
                
                <tr>
                    <td style="<%=style%>" class="td2"><FONT FACE="tahoma"><b><%=Equipment_Type%>&nbsp;</b></font></td>
                    <td style="<%=style%>" class="td2">
                        <Input type="radio" name="eqptype" value="fixed" ID="fixed" ONCLICK="JavaScript: getRadioCheck();" checked><%=Static_Equipment%> <br>
                        <Input type="radio" name="eqptype" value="odometer" ID="odometer" ONCLICK="JavaScript: getRadioCheck();"><%=Odometer%>  
                    </td>
                    <td style="<%=style%>" class="td">
                        <table>
                            <tr>
                                <td style="<%=style%>" class="td2"><FONT FACE="tahoma"><b><%=Operation_Type%>&nbsp;</b></font></td>
                                <td style="<%=style%>" class="td2">
                                    
                                    <Input type="radio" name="opration" value="Continues" ID="Continues" ONCLICK="JavaScript: setAverage();" checked><%=Countinous%> <br>
                                    <Input type="radio" name="opration" value="ByOrder" ID="ByOrder" ONCLICK="JavaScript: setAverage();"> <%=By_Order%>
                                </td>  
                            </tr>
                        </table>
                    </td>
                    
                </tr>
                
                <tr>
                    <td style="<%=style%>" class="td2"><FONT FACE="tahoma"><b><%=Average_Daily_Work%><font color="#FF0000">*</font>&nbsp;</b></font></td>
                    <td style="<%=style%>" class="td2">
                        <input type="TEXT" name="average" ID="average" size="15" value="24" maxlength="24" autocomplete="off" onchange="JavaScript: checkAverage();">&nbsp;&nbsp;&nbsp; <B><FONT ID="km"> <%=km%> </FONT>/ <FONT ID="Hr" COLOR="red"><%=Hour%></FONT></B>
                    </td>
                    
                    <td style="<%=style%>" class="td2"><FONT FACE="tahoma"><b><%=titleReading%><font color="#FF0000">*</font>&nbsp;</b></font>
                        <input type="TEXT" name="averageReading" ID="averageReading" size="15" value="0" maxlength="24" autocomplete="off"">
                           </td>
                    
                </tr>
                <tr><td class="td"><br><br></td></tr>
                <tr bgcolor="darkkhaki">
                    <td style="text-align:center" colspan="4" class="td"><FONT color='white' size="+1"><%=Manufacturing_Data%></FONT></td>
                </tr>
                
                <tr>
                    <td style="<%=style%>" class="td2"><FONT FACE="tahoma"><b><%=Manufacturer%><font color="#FF0000">*</font>&nbsp;</b></font></td>
                    <td style="<%=style%>" class="td2"><input type="TEXT" name="manufacturer" ID="manufacturer" size="33" value="" maxlength="255"></td>
                </tr>
                
                <tr>
                    <td style="<%=style%>" class="td2"><FONT FACE="tahoma"><b><%=Serial_No%><font color="#FF0000">*</font>&nbsp;</b></font></td>
                    <td style="<%=style%>" class="td2"><input type="TEXT" name="serialNo" ID="serialNo" size="33" value="" maxlength="255"></td>
                    <td style="<%=style%>" class="td">
                        <table>
                            <tr>
                                <td style="<%=style%>" class="td2"><FONT FACE="tahoma"><b><%=Model_No%><font color="#FF0000">*</font>&nbsp;</b></font></td>
                                <td style="<%=style%>" class="td2"><input type="TEXT" name="modelNo" ID="modelNo" size="33" value="" maxlength="255"></td>
                            </tr>
                        </table>
                    </td>
                    
                </tr>
                
                <tr>
                    <td style="<%=style%>" valign="top" class="td2"><FONT FACE="tahoma"><b><%=Notes%></b></font></td>
                    <td style="<%=style%>" class="td2" colspan="3"><TEXTAREA rows="4" name="notes" cols="115">No Notes</TEXTAREA></td>
                </tr>
                
                <tr><td class="td"><br><br></td></tr>
                <tr bgcolor="darkkhaki">
                    <td style="text-align:center" colspan="4" class="td2"><FONT color='white' size="+1"><%=Warranty_Data%></FONT></td>
                </tr>
                <input type="hidden" name="supplier" value="1">
                <input type="hidden" name="contractor" value="1">
                <!--tr>
                <td style="<%=style%>" class="td2"><FONT FACE="tahoma"><b><%=Supplier%>&nbsp;</b></font></td>
                <td style="<%=style%>" class="td2">
                        <SELECT name="supplier" STYLE="width:200px;">
                <//sw:WBOOptionList wboList='<%=suppliersList%>' displayAttribute = "name" valueAttribute="id"/>
                        </SELECT>
                    </td>
                <td style="<%=style%>" class="td">
                        <table>
                            <tr>
                <td style="<%=style%>" class="td2"><FONT FACE="tahoma"><b><%=Contractor%></td>
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
                    <td style="<%=style%>" class="td2"><b><FONT ID="contractCol" color = "red"><%=Contract%></font><font ID="warrantyCol" COLOR="white"><%=Warranty%></font></b></td>
                    <td style="<%=style%>" class="td2">
                        <SELECT name="contract" ID="contract" STYLE="width:200px;" ONCHANGE="javascript: dateLabel();">
                            <OPTION VALUE="1">Contract
                            <option value="2">Warranty
                        </SELECT>
                    </td>
                </tr>
                
                <tr>
                    <!--td style="<%//=style%>" class="td2"><FONT FACE="tahoma"><b><%//=Purchase_Price%>&nbsp;</b></font></td>
                    <td style="<%//=style%>"class="td2"--><input type ="hidden" name="price" ID="price" size="33" maxlength="255" value="0"><!--/td-->
                    <tr>
                        <td style="<%=style%>" class="td2"><FONT FACE="tahoma"><b>
                                    <%=Date_Acquired%>&nbsp;
                        </b></font></td>
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
                        <td style="<%=style%>" class="td2"><b><FONT ID="contractDateLABEL" color="red"><%=Contract_Date%></font><br><FONT ID="warrantyDateLabel" COLOR="white"><%=Warranty_Expiry_Date%></FONT></b></td>
                        <td style="<%=style%>"  class="calender">
                            <input name="warrantyDate" id="warrantyDate" type="text" value="<%=nowDate%>" ><img src="images/showcalendar.gif" >
                        </td>  
                    </tr>
                </tr>
                
                <tr>
                    <td style="<%=style%>" class="td2"><FONT FACE="tahoma"><b><%//=Current_Value%><font color="#FF0000"></font>&nbsp;</b></font></td>
                    <td style="<%=style%>" width="28%" class="td2"><input type="hidden" name="currentValue" ID="currentValue" size="33" value="0" maxlength="255"></td>
                    <td style="<%=style%>" class="td">
                        <table>
                            <tr>
                                <td style="<%=style%>" class="td2"><FONT FACE="tahoma"><b><%//=Date_Disposed%><font color="#FF0000"></font>&nbsp;</b></font></td>
                                <td style="<%=style%>"  class="calender">
                                    <INPUT TYPE="hidden" name="base" id="base" VALUE="<%=base%>">
                                </td>   
                            </tr>
                        </table>
                    </td>
                    
                </tr>
            </table>
            <%
            }
            %>
        </FORM>
    </body>
</html>