<%@ page import="com.docviewer.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.db_access.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.docviewer.db_access.DocTypeMgr"%>
<%@ page import="com.contractor.db_access.MaintainableMgr, com.maintenance.db_access.*, com.tracker.db_access.*, com.silkworm.persistence.relational.Row"%>  
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<%
TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

MetaDataMgr metaMgr = MetaDataMgr.getInstance();
FileMgr fileMgr = FileMgr.getInstance();
MaintainableMgr maintainableMgr = MaintainableMgr.getInstance();
ProjectMgr projectMgr = ProjectMgr.getInstance();
SupplierMgr supplierMgr = SupplierMgr.getInstance();
DepartmentMgr deptMgr = DepartmentMgr.getInstance();
ProductionLineMgr productionLineMgr = ProductionLineMgr.getInstance();
SupplementMgr supplementMgr=SupplementMgr.getInstance();

//EmployeeMgr empMgr = EmployeeMgr.getInstance();

EmpBasicMgr empMgr = EmpBasicMgr.getInstance();

SupplierEquipmentMgr equipSupMgr = SupplierEquipmentMgr.getInstance();
EquipOperationMgr eqpOpMgr = EquipOperationMgr.getInstance();
AverageUnitMgr averageUnitMgr = AverageUnitMgr.getInstance();

String context = metaMgr.getContext();
String backTarget = null;

WebBusinessObject equipmentWBO = (WebBusinessObject) maintainableMgr.getOnSingleKey((String) request.getAttribute("equipID"));
WebBusinessObject wboTemp = maintainableMgr.getOnSingleKey(equipmentWBO.getAttribute("parentId").toString());
WebBusinessObject locationWBO = projectMgr.getOnSingleKey(equipmentWBO.getAttribute("site").toString());
WebBusinessObject deptWBO = deptMgr.getOnSingleKey(equipmentWBO.getAttribute("department").toString());
WebBusinessObject productionLineWBO = productionLineMgr.getOnSingleKey(equipmentWBO.getAttribute("productionLine").toString());

WebBusinessObject empWBO = empMgr.getOnSingleKey(equipmentWBO.getAttribute("empID").toString());
//WebBusinessObject eqSupWBO = equipSupMgr.getOnSingleKey(equipmentWBO.getAttribute("id").toString());
//WebBusinessObject supWBO = supplierMgr.getOnSingleKey((String) eqSupWBO.getAttribute("supplierID"));
//WebBusinessObject contEmpWBO = empMgr.getOnSingleKey(eqSupWBO.getAttribute("contractEmp").toString());
Vector eqpOpVector = eqpOpMgr.getOnArbitraryKey(equipmentWBO.getAttribute("id").toString(), "key1");
WebBusinessObject eqpOpWbo = (WebBusinessObject) eqpOpVector.elementAt(0);

IssueMgr issueMgr=IssueMgr.getInstance();
Vector EqAssignedIssues=issueMgr.getOnArbitraryDoubleKey((String)request.getAttribute("equipID"),"key6","Assigned","key7");

//Warranty Data
Vector warrantyData=equipSupMgr.getOnArbitraryKey((String) request.getAttribute("equipID"),"key");


String unitName = equipmentWBO.getAttribute("unitName").toString();
request.setAttribute("unitName", unitName);

Vector data = new Vector();
data.add(equipmentWBO);

request.getSession().setAttribute("info", data);
response.addHeader("Pragma", "No-cache");
response.addHeader("Cache-Control", "no-cache");
response.addDateHeader("Expires", 1);

Vector imagePath = (Vector) request.getAttribute("imagePath");

backTarget = context + "/main.jsp";

//String dateAcquired = eqSupWBO.getAttribute("purchaseDate").toString();
//String expiryDate = eqSupWBO.getAttribute("warrantyExpDate").toString();
EqChangesMgr eqChangesMgr = EqChangesMgr.getInstance();
Vector vecChanges = eqChangesMgr.getOnArbitraryKey(((String) equipmentWBO.getAttribute("id")), "key1");


String equipmentID = (String) request.getAttribute("equipID");

Vector eqps=supplementMgr.getOnArbitraryKey(equipmentID,"key1");
WebBusinessObject tempwbo=new WebBusinessObject();

UnitDocMgr unitDocMgr = UnitDocMgr.getInstance();
boolean active = maintainableMgr.hasSchedules(equipmentID);
EquipmentStatusMgr equipmentStatusMgr = EquipmentStatusMgr.getInstance();
WebBusinessObject tempWbo = equipmentStatusMgr.getLastStatus(equipmentID);
int currentStatus = 2;
if (tempWbo != null) {
    String stateID = (String) tempWbo.getAttribute("stateID");
    currentStatus = new Integer(stateID).intValue();
}

// check if the equipment id has record(s) in attach_eqps table and
// the separation_date equl null. this mean this eq is attached.
Vector attachedEqps=new Vector();
attachedEqps=supplementMgr.search(equipmentID);
int attachFlag=0;
if(attachedEqps.size()>0) {
    attachFlag=1;
}


String url = context + "/main.jsp";
//if (session.getAttribute("CategoryID") != null) {
//   url = context + "/EquipmentServlet?op=ViewUnits&categoryId=" + (String) session.getAttribute("CategoryID");
//}
String cMode = (String) request.getSession().getAttribute("currentMode");
String stat = cMode;
int year,mon,day;
String align = null;
String dir = null;
String style = null;
String lang,viewAttachedHistory,EqHasAssignedJo,eqType_odometer,WarrantyExist,viewWarrantyData,noWarrantyData,addWarrant,eqType_continues, Countinous, By_Order,viewSeparateHistory, langCode, tit, save, cancel, TT, SNA, tit1, RU, EMP, STAT, NO, Reading, Excellent, Good, Poor, updateHours, listHours, updateKm, listKm, Emergency, sSupplier, sSupplierList, sAttachEquipment,Indicators,red_font,red_font_tib,black_font,black_font_tib,attachDriver,header,sSeparateEquipment;
String listAttachedDriver=null;
String workingEq,stoppedEq,stoppedEq_tip,workingEq_tip,yes,no;
String back = "&#1575;&#1604;&#1575;&#1580;&#1606;&#1583;&#1607; &#1575;&#1604;&#1575;&#1587;&#1576;&#1608;&#1593;&#1610;&#1607;";
if (stat.equals("En")) {
    align = "center";
    dir = "LTR";
    style = "text-align:left";
    lang = "   &#1593;&#1585;&#1576;&#1610;    ";
    langCode = "Ar";
    tit = "View File";
    tit1 = "Select File Type";
    save = "Attach";
    cancel = "Weekly Diary";
    TT = "Select File Type ";
    SNA = "Site Name";
    RU = "Waiting Business Rule";
    EMP = "Employee Name";
    STAT = "Attaching Status";
    NO = "Attach File Before Filling Information";
    Excellent = "Excellent";
    Good = "Good";
    Poor = "Poor";
    updateHours = "Update Equipment Hours";
    listHours = "List Equipment Hours";
    updateKm = "Update Equipment By Odometer";
    listKm = "List Equipment By Odometer";
    Emergency = "Normal Order";
    sSupplier = "Add External Supplier";
    sSupplierList = "List External Supplier";
    sAttachEquipment = "Attach Equipment";
    sSeparateEquipment="Separate Equipment";
    Indicators="Indicators Guide";
    red_font="Red Font Operations Can't Access";
    red_font_tib="This Option can't Performed now for this Equipment";
    black_font="Black Font Operations Can Access This Option";
    black_font_tib="You Can Perform This Option Now For This Equipment";
    attachDriver="Attach Driver";
    header="View Details for Equipment ";
    viewAttachedHistory="View Attached History";
    viewSeparateHistory="View Separation History";
    listAttachedDriver="List attached Drivers";
    Countinous = "Countinous";
    By_Order = "By Order";
    eqType_odometer="Working by KM";
    eqType_continues="Working by Hours";
    addWarrant="Add Warranty Data";
    noWarrantyData="No Warranty Data";
    viewWarrantyData="View Warranty Data";
    WarrantyExist="Warranty Data Already Exist";
    EqHasAssignedJo="Equipment Has Opened Job Orders";
    workingEq="Working Equipment";
    workingEq_tip="This Equipment Is Working Now";
    stoppedEq="Out Of Working Equipment";
    stoppedEq_tip="This Equipment Is Out Of Working Now";
    yes="Yes";
    no="No";
    
} else {
    align = "center";
    dir = "RTL";
    style = "text-align:Right";
    lang = "English";
    langCode = "En";
    tit = "  &#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583;  ";
    tit1 = "&#1573;&#1582;&#1578;&#1575;&#1585; &#1606;&#1608;&#1593; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583;";
    save = "&#1573;&#1585;&#1601;&#1602;";
    cancel = " &#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1573;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577; ";
    TT = "&#1573;&#1582;&#1578;&#1575;&#1585; &#1605;&#1604;&#1601;";
    SNA = "&#1573;&#1587;&#1605; &#1575;&#1604;&#1605;&#1608;&#1602;&#1593;";
    RU = "&#1605;&#1606;&#1578;&#1592;&#1585; &#1602;&#1575;&#1593;&#1583;&#1577; &#1593;&#1605;&#1604;";
    EMP = "&#1573;&#1587;&#1605; &#1575;&#1604;&#1608;&#1592;&#1601;";
    STAT = " &#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1573;&#1585;&#1601;&#1575;&#1602;";
    NO = "&#1573;&#1585;&#1601;&#1602; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583; &#1602;&#1576;&#1604; &#1605;&#1604;&#1574; &#1575;&#1604;&#1576;&#1610;&#1575;&#1606;&#1575;&#1578;";
    Excellent = "&#1605;&#1605;&#1578;&#1575;&#1586;&#1607;";
    Good = "&#1580;&#1610;&#1583;&#1607;";
    Poor = "&#1585;&#1583;&#1610;&#1574;&#1607;";
    updateHours = "&#1578;&#1581;&#1583;&#1610;&#1579; &#1587;&#1575;&#1593;&#1575;&#1578; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;";
    listHours = "&#1593;&#1585;&#1590; &#1587;&#1575;&#1593;&#1575;&#1578; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;";
    updateKm = "&#1578;&#1581;&#1583;&#1610;&#1579; &#1603;&#1610;&#1604;&#1608; &#1605;&#1578;&#1585;&#1575;&#1578; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;";
    listKm = "&#1593;&#1585;&#1590; &#1603;&#1610;&#1604;&#1608; &#1605;&#1578;&#1585;&#1575;&#1578; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577;";
    Emergency = "&#1573;&#1590;&#1575;&#1601;&#1577; &#1575;&#1605;&#1585; &#1588;&#1594;&#1604; &#1593;&#1575;&#1583;&#1609;";
    sSupplier = "&#1573;&#1590;&#1575;&#1601;&#1577; &#1605;&#1608;&#1585;&#1583; &#1582;&#1575;&#1585;&#1580;&#1610;";
    sSupplierList = "&#1593;&#1585;&#1590; &#1605;&#1608;&#1585;&#1583; &#1582;&#1575;&#1585;&#1580;&#1610;";
    sAttachEquipment = "&#1573;&#1604;&#1581;&#1575;&#1602; &#1605;&#1593;&#1583;&#1577;";
    sSeparateEquipment="&#1601;&#1589;&#1604; &#1605;&#1593;&#1583;&#1607;";
    Indicators="&#1575;&#1604;&#1605;&#1585;&#1588;&#1583; &#1575;&#1604;&#1605;&#1589;&#1608;&#1585;";
    red_font="&#1582;&#1591; &#1575;&#1581;&#1605;&#1585; &#1593;&#1605;&#1604;&#1610;&#1575;&#1578; &#1604;&#1575; &#1610;&#1605;&#1603;&#1606; &#1575;&#1604;&#1602;&#1610;&#1575;&#1605; &#1576;&#1607;&#1575;";
    red_font_tib="&#1607;&#1584;&#1607; &#1575;&#1604;&#1582;&#1575;&#1589;&#1610;&#1607; &#1594;&#1610;&#1585; &#1605;&#1578;&#1608;&#1601;&#1585;&#1607; &#1604;&#1607;&#1584;&#1607; &#1575;&#1604;&#1605;&#1575;&#1603;&#1610;&#1606;&#1607; &#1601;&#1609; &#1575;&#1604;&#1608;&#1602;&#1578; &#1575;&#1604;&#1581;&#1575;&#1604;&#1609;";
    black_font="&#1582;&#1591; &#1571;&#1587;&#1608;&#1583; &#1593;&#1605;&#1604;&#1610;&#1575;&#1578; &#1610;&#1605;&#1603;&#1606; &#1575;&#1604;&#1602;&#1610;&#1575;&#1605; &#1576;&#1607;&#1575; &#1575;&#1604;&#1575;&#1606;";
    black_font_tib="&#1607;&#1584;&#1607; &#1575;&#1604;&#1582;&#1575;&#1589;&#1610;&#1607; &#1610;&#1605;&#1603;&#1606;&#1603; &#1578;&#1606;&#1601;&#1610;&#1584;&#1607;&#1575; &#1601;&#1609; &#1575;&#1604;&#1608;&#1602;&#1578; &#1575;&#1604;&#1581;&#1575;&#1604;&#1609;";
    attachDriver="&#1573;&#1604;&#1581;&#1575;&#1602; &#1587;&#1575;&#1574;&#1602;";
    header="&#1605;&#1600;&#1588;&#1600;&#1575;&#1607;&#1600;&#1583;&#1607; &#1578;&#1600;&#1601;&#1600;&#1575;&#1589;&#1600;&#1610;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1604; &#1575;&#1604;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1605;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1593;&#1600;&#1583;&#1607;";
    viewAttachedHistory="&#1593;&#1585;&#1590; &#1578;&#1608;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1571;&#1604;&#1581;&#1575;&#1602;";
    viewSeparateHistory="&#1593;&#1585;&#1590; &#1578;&#1608;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1601;&#1589;&#1604;";
    listAttachedDriver="&#1593;&#1585;&#1590; &#1573;&#1604;&#1581;&#1575;&#1602; &#1575;&#1604;&#1587;&#1575;&#1574;&#1602;&#1610;&#1606;";
    Countinous = "&#1605;&#1587;&#1578;&#1605;&#1585;&#1607;";
    By_Order = "&#1576;&#1575;&#1604;&#1591;&#1604;&#1576;";
    eqType_odometer="&#1605;&#1593;&#1583;&#1607; &#1576;&#1603;&#1605;";
    eqType_continues="&#1605;&#1593;&#1583;&#1607; &#1576;&#1575;&#1604;&#1587;&#1575;&#1593;&#1607;";
    addWarrant="&#1575;&#1590;&#1575;&#1601;&#1607; &#1576;&#1610;&#1575;&#1606;&#1575;&#1578; &#1575;&#1604;&#1590;&#1605;&#1575;&#1606;";
    viewWarrantyData="&#1605;&#1588;&#1575;&#1607;&#1583;&#1607; &#1576;&#1610;&#1575;&#1606;&#1575;&#1578; &#1575;&#1604;&#1590;&#1605;&#1575;&#1606;";
    noWarrantyData="&#1604;&#1575; &#1610;&#1608;&#1580;&#1583; &#1590;&#1605;&#1575;&#1606;";
    WarrantyExist="&#1578;&#1605; &#1575;&#1583;&#1582;&#1575;&#1604; &#1575;&#1604;&#1590;&#1605;&#1575;&#1606; &#1605;&#1606; &#1602;&#1576;&#1604;";
    EqHasAssignedJo="&#1575;&#1604;&#1605;&#1593;&#1583;&#1607; &#1605;&#1585;&#1578;&#1576;&#1591;&#1607; &#1576;&#1571;&#1605;&#1585; &#1588;&#1594;&#1604; &#1605;&#1601;&#1578;&#1608;&#1581;";
    workingEq="&#1605;&#1593;&#1583;&#1607; &#1578;&#1593;&#1605;&#1604; &#1575;&#1604;&#1575;&#1606; (&#1583;&#1575;&#1582;&#1604; &#1575;&#1604;&#1582;&#1583;&#1605;&#1607;)";
    workingEq_tip="&#1607;&#1584;&#1607; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607; &#1578;&#1593;&#1605;&#1604; &#1575;&#1604;&#1575;&#1606; (&#1583;&#1575;&#1582;&#1604; &#1575;&#1604;&#1582;&#1583;&#1605;&#1607;)";
    stoppedEq="&#1605;&#1593;&#1583;&#1607; &#1604;&#1575; &#1578;&#1593;&#1605;&#1604; &#1575;&#1604;&#1575;&#1606; (&#1582;&#1575;&#1585;&#1580; &#1575;&#1604;&#1582;&#1583;&#1605;&#1607;)";
    stoppedEq_tip="&#1607;&#1584;&#1607; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607; &#1604;&#1575; &#1578;&#1593;&#1605;&#1604; &#1575;&#1604;&#1575;&#1606; (&#1582;&#1575;&#1585;&#1580; &#1575;&#1604;&#1582;&#1583;&#1605;&#1607;)";
    yes="&#1606;&#1593;&#1605;";
    no="&#1604;&#1575;";
}

	WebBusinessObject userWbo = (WebBusinessObject) request.getSession().getAttribute("loggedUser");

	GroupPrevMgr groupPrevMgr = GroupPrevMgr.getInstance();
	Vector groupPrev = groupPrev = groupPrevMgr.getOnArbitraryKey(userWbo.getAttribute("groupID").toString(), "key1");

	ArrayList<String> userPrevList = new ArrayList<String>();
        WebBusinessObject wboPrev;
        for (int i = 0; i < groupPrev.size(); i++) {
            wboPrev = (WebBusinessObject) groupPrev.get(i);
            userPrevList.add((String) wboPrev.getAttribute("prevCode"));
        }
%>

<SCRIPT language="JavaScript1.3">
    function changeMode(name){
        if(document.getElementById(name).style.display == 'none'){
            document.getElementById(name).style.display = 'block';
        } else {
        document.getElementById(name).style.display = 'none';
    }
}

function changePage(url){
    window.location=url;
}

var panes = new Array(); 

function setupPanes(containerId, defaultTabId) { 
        
    // go through the DOM, find each tab-container 
    // set up the panes array with named panes 
    panes[containerId] = new Array(); 
    var maxHeight = 0; var maxWidth = 0; 
    var container = document.getElementById(containerId); 
    var paneContainer = container.getElementsByTagName("div")[0]; 
    var paneList = paneContainer.childNodes; 
    for (var i=0; i < paneList.length; i++ ) { 
        var pane = paneList[i]; 
        if (pane.nodeType != 1) continue; 
        panes[containerId][pane.id] = pane; 
        pane.style.display = "none"; 
    } 
    document.getElementById(defaultTabId).onclick(); 
} 

function showPane(paneId, activeTab) { 
    // make tab active class 
    // hide other panes (siblings) 
    // make pane visible 
    
    for (var con in panes) { 
        activeTab.blur(); 
        activeTab.className = "tab-active"; 
        if (panes[con][paneId] != null) { // tab and pane are members of this container 
            var pane = document.getElementById(paneId); 
            pane.style.display = "block"; 
            var container = document.getElementById(con); 
            var tabs = container.getElementsByTagName("ul")[0]; 
            var tabList = tabs.getElementsByTagName("a") 
            for (var i=0; i < tabList.length; i++ ) { 
                var tab = tabList[i]; 
                if (tab != activeTab) tab.className = "tab-disabled"; 
            } 
            for (var i in panes[con]) { 
                var pane = panes[con][i]; 
                if (pane == undefined) continue; 
                if (pane.id == paneId) continue; 
                pane.style.display = "none" 
            } 
        } 
    } 
    return false; 
} 
</SCRIPT>


<style type="text/css"> 
    <!-- 
    .tabs {position:relative; left: 5; top: 3; border:1px solid #194367; height: 60px; width: 850; margin: 0; padding: 0; background:#C0D9DE; overflow:hidden; } 
    .tabs li {display:inline} 
    .tabs a:hover, .tabs a.tab-active {background:#fff;} 
    .tabs a { height: 40px; font:11px verdana, helvetica, sans-serif;font-weight:bold; 
        position:relative; padding:6px 10px 10px 10px; margin: 0px -4px 0px 0px; color:#2B4353;text-decoration:none; } 
    .tab-container { background: #fff; border:0px solid #194367; height:320px; width:500px} 
    .tab-panes { margin: 3px; border:1px solid #194367; height:320px} 
    div.content { padding: 5px; }
</style>

<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>Maintenance - View Equipment Details</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        
        <script type="text/javascript" src="js/jquery-1.2.6.pack.js"></script>
        
        <script type="text/javascript" src="js/stepcarousel.js">

/***********************************************
* Step Carousel Viewer script- (c) Dynamic Drive DHTML code library (www.dynamicdrive.com)
* Visit http://www.dynamicDrive.com for hundreds of DHTML scripts
* This notice must stay intact for legal use
***********************************************/

        </script>
        
        <style type="text/css">
            
            .stepcarousel{
            position: relative; /*leave this value alone*/
            border: 10px solid black;
            overflow: scroll; /*leave this value alone*/
            width: 270px; /*Width of Carousel Viewer itself*/
            height: 200px; /*Height should enough to fit largest content's height*/
            }
            
            .stepcarousel .belt{
            position: absolute; /*leave this value alone*/
            left: 0;
            top: 0;
            }
            
            .stepcarousel .panel{
            float: left; /*leave this value alone*/
            overflow: hidden; /*clip content that go outside dimensions of holding panel DIV*/
            margin: 10px; /*margin around each panel*/
            width: 250px; /*Width of each panel holding each content. If removed, widths should be individually defined on each content DIV then. */
            }
            
        </style>
        
    </HEAD>
    
    <BODY onload='setupPanes("container1", "tab1");'>
        
        <script type="text/javascript">

stepcarousel.setup({
	galleryid: 'mygallery', //id of carousel DIV
	beltclass: 'belt', //class of inner "belt" DIV containing all the panel DIVs
	panelclass: 'panel', //class of panel DIVs each holding content
	autostep: {enable:true, moveby:1, pause:3000},
	panelbehavior: {speed:500, wraparound:false, persist:true},
	defaultbuttons: {enable: true, moveby: 1, leftnav: ['images/317e0s5.gif', -5, 80], rightnav: ['images/33o7di8.gif', -20, 80]},
	statusvars: ['statusA', 'statusB', 'statusC'], //register 3 variables that contain current panel (start), current panel (last), and total panels
	contenttype: ['inline'] //content setting ['inline'] or ['external', 'path_to_external_file']
})

        </script>
        
        <DIV align="left" STYLE="color:blue;">
            
            <button onclick="changePage('<%=url%>')" class="homebutton"><%=back%> <IMG VALIGN="BOTTOM"   SRC="images/diary16.gif" WIDTH="20" HEIGHT="16"> </button>
            
        </DIV>
        
        <BR>
        
        <div>
            <table align="center" border="0" width="100%">
                <tr>
                    <td STYLE="border:0px;">
                        <div STYLE="width:75%;border:2px solid gray;background-color:#808000;color:white;" bgcolor="#F3F3F3" align="center">
                            <div ONCLICK="JavaScript: changeMode('menu3');" STYLE="width:100%;background-color:#808000;color:white;cursor:hand;font-size:16;">
                                <b>
                                    <%=Indicators%>
                                </b>
                                <img src="images/arrow_down.gif">
                            </div>
                            <div ALIGN="center" STYLE="width:100%;background-color:#FFFFCC;color:white;display:block;<%=style%>;border-top:2px solid gray;" ID="menu3">
                                <table align="center" border="0" dir="<%=dir%>" width="100%" cellspacing="2">
                                    <tr>
                                        <td CLASS="indicator" bgcolor="white" STYLE="<%=style%>;" width="33%"><img src="images/red_font.JPG" border="0" alt="<%=red_font_tib%>"><B>&nbsp;&nbsp;<font color="red"><%=red_font%></font></B></td>
                                        <td CLASS="indicator" bgcolor="white" STYLE="<%=style%>;"><img src="images/black_font.JPG" border="0" alt="<%=black_font_tib%>"><B>&nbsp;&nbsp;<%=black_font%></B></td>
                                    </tr>
                                    <tr>
                                        <td CLASS="indicator" bgcolor="white" STYLE="<%=style%>;" width="33%"><img src="images/workingEq.gif" width="40" height="30" border="0" alt="<%=workingEq_tip%>"><B>&nbsp;&nbsp;<font color="red"><%=workingEq%></font></B></td>
                                        <td CLASS="indicator" bgcolor="white" STYLE="<%=style%>;"><img src="images/stoppedEq.gif" width="30" height="30" border="0" alt="<%=stoppedEq_tip%>"><B>&nbsp;&nbsp;<%=stoppedEq%></B></td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </td>
                </tr>
            </table>
            
            <TABLE BORDER="0" ALIGN="right" WIDTH="100%">
                <TR>
                    <TD STYLE="border:0px" WIDTH="30%" VALIGN="top">
                        <DIV STYLE="width:100%;border:2px solid gray;background-color:#808000;color:white;">
                            <DIV ONCLICK="JavaScript: changeMode('menu1');" STYLE="width:100%;background-color:#808000;color:white;cursor:hand;font-size:14;">
                                <B>&#1593;&#1605;&#1604;&#1610;&#1575;&#1578; &#1605;&#1588;&#1575;&#1607;&#1583;&#1577; / Viewing Operations</B> <img src="images/arrow_down.gif">
                            </DIV>
                            
                            <DIV ALIGN="right" STYLE="width:100%;background-color:#FFFFCC;color:black;display:none;text-align:right;" ID="menu1">
                                <table border="0" cellpadding="0" cellspacing="3" width="100%" bgcolor="#FFFFCC">
                                    <tr>
                                        <td style="border:1px solid blue;cursor:hand;color:white;" width="33%" bgcolor="white" >
                                            <a href="<%=context%>/ScheduleServlet?op=ListEqpSchedules&amp;source=other&amp;equipment=<%=equipmentWBO.getAttribute("id").toString()%>">
                                                <font color="black"> <B>&#1571;&#1608;&#1575;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;</B></FONT>
                                            </A>
                                        </td>
                                        <%
                                        if (vecChanges.size() > 0) {
                                        %>
                                        <td style="border:1px solid blue;cursor:hand;color:white;" width="33%" bgcolor="white" >
                                            <a href="<%=context%>/EquipmentServlet?op=ListChanges&equipmentID=<%=equipmentID%>&action=view">
                                                <font color="black"> <B>&#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1575;&#1604;&#1578;&#1594;&#1610;&#1610;&#1585;&#1575;&#1578;</B></FONT>
                                            </A>
                                        </td>
                                        <%
                                        } else {
                                        %>
                                        <td style="border:1px solid blue;color:white;" width="33%" bgcolor="white" >
                                            <font color="black">  <B>&#1604;&#1575; &#1578;&#1608;&#1580;&#1583; &#1578;&#1594;&#1610;&#1610;&#1585;&#1575;&#1578;</B></FONT>
                                        </td>
                                        <%
                                        }
                                        %>
                                        <%
                                        if (unitDocMgr.hasDocuments(equipmentID)) {
                                        %>
                                        <td style="border:1px solid blue;cursor:hand;color:white;" width="33%" bgcolor="white" >
                                            <a href="<%=context%>/UnitDocReaderServlet?op=ListDoc&equipmentID=<%=equipmentID%>">
                                                <font color="black"> <B>&#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583;&#1575;&#1578;</B></FONT>
                                            </A>
                                        </td>
                                        <%
                                        } else {
                                        %>
                                        <td style="border:1px solid blue;color:white;" width="33%" bgcolor="white">
                                            <font color="black"><B>&#1604;&#1575; &#1610;&#1608;&#1580;&#1583; &#1605;&#1587;&#1578;&#1606;&#1583;&#1575;&#1578; &#1605;&#1585;&#1601;&#1602;&#1607;</B></FONT>
                                        </td>
                                        <%
                                        }
                                        %>
                                    </tr>
                                    
                                    <tr>
                                        <td style="border:1px solid blue;cursor:hand;color:white;" width="33%" bgcolor="#bbbccc" >
                                            <a href="<%=context%>/EquipmentServlet?op=ListJobOrders&equipmentID=<%=equipmentID%>">
                                                <font color="black"><B>&#1578;&#1575;&#1585;&#1610;&#1582; &#1571;&#1608;&#1575;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;</B></FONT>
                                            </A>
                                        </td>
                                        <td style="border:1px solid blue;cursor:hand;color:white;" width="33%" bgcolor="#bbbccc" >
                                            <a href="<%=context%>/EqStateTypeServlet?op=ViewStatusHistory&equipmentID=<%=equipmentID%>">
                                                <font color="black"><B>&#1578;&#1600;&#1600;&#1575;&#1585;&#1610;&#1600;&#1582; &#1575;&#1604;&#1581;&#1600;&#1600;&#1575;&#1604;&#1600;&#1600;&#1577;</B></FONT>
                                            </A>
                                        </td>
                                        <%if (equipmentWBO.getAttribute("rateType").equals("By Hour")) {%>
                                        <td style="border:1px solid blue;color:white;cursor:hand;" width="33%" bgcolor="#bbbccc"> 
                                            <a href="<%=context%>/AverageUnitServlet?op=ListAverageUnitForm&equipmentID=<%=equipmentID%>&currentMode=<%=cMode%>">
                                                <font color="black"> <B><%=listHours%></B></FONT>
                                            </A>
                                        </td>
                                        <%} else {%>
                                        <td style="border:1px solid blue;color:white;cursor:hand;" width="33%" bgcolor="#bbbccc" > 
                                            <a href="<%=context%>/AverageUnitServlet?op=ListAverageKelUnitForm&equipmentID=<%=equipmentID%>&currentMode=<%=cMode%>">
                                                <font color="black"> <B><%=listKm%></B></FONT>
                                            </A>
                                        </td>
                                        <%}%>
                                    </tr>
                                    <tr>
                                        <td style="border:1px solid blue;color:white;cursor:hand;" width="33%"   bgcolor="#ffff00">
                                            <a href="<%=context%>/EquipmentServlet?op=ListEquipmentSuppliers&equipmentID=<%=equipmentID%>&currentMode=<%=cMode%>"> 
                                            <font color="black"><B><%=sSupplierList%></B></FONT></a>
                                        </td>
                                        <%if (equipmentWBO.getAttribute("isStandalone").equals("1")) {%>
                                        <td style="border:1px solid blue;color:black;cursor:hand;" width="33%" bgcolor="#ffff00" >
                                            <a href="<%=context%>/SupplementServlet?op=viewAttachedHistory&equipmentID=<%=equipmentID%>&currentMode=<%=cMode%>&ismain=main"> 
                                            <font color="black"><B><%=viewAttachedHistory%></B></FONT></a>                                            
                                        </td>
                                        <%}else{%>
                                        <td style="border:1px solid blue;color:black;cursor:hand;" width="33%" bgcolor="#ffff00">
                                            <a href="<%=context%>/SupplementServlet?op=viewAttachedHistory&equipmentID=<%=equipmentID%>&currentMode=<%=cMode%>&ismain=notmain">
                                            <font color="black"> <B><%=viewAttachedHistory%></B></FONT></A>                                            
                                        </td>
                                        <%}%>
                                        <td style="border:1px solid blue;color:black;cursor:hand;" width="33%" bgcolor="#ffff00" >
                                            <a href="<%=context%>/DriverHistoryServlet?op=ListAttachDriverForm&equipmentID=<%=equipmentID%>&currentMode=<%=cMode%>">
                                                <font color="black"> <B><%=listAttachedDriver%></B></FONT>
                                            </A>
                                        </td>
                                        
                                    </tr>
                                    <tr>
                                        <td style="border:1px solid blue;color:white;cursor:hand;" width="33%"   >
                                            <font color="black"><B>&nbsp;</B></FONT>
                                        </td>
                                        <%if(warrantyData.size()>0) {%>
                                        <td style="border:1px solid blue;color:black;cursor:hand;" width="33%" bgcolor="#ffff00" onclick="JavaScript: changePage('')">
                                            <a href="<%=context%>/EquipmentServlet?op=viewWarrantyData&equipmentID=<%=equipmentID%>&currentMode=<%=cMode%>">
                                                <font color="black"> <B><%=viewWarrantyData%></B></FONT>
                                            </A>
                                        </td>
                                        <%}else{%>
                                        <td style="border:1px solid blue;color:black;" width="33%" bgcolor="#ffff00" >
                                            <font color="red"><B><%=noWarrantyData%></B></FONT>
                                        </td>
                                        <%}%>
                                        <td style="border:1px solid blue;color:black;cursor:hand;" width="33%"   >
                                            <B>&nbsp;</B>
                                        </td>
                                        
                                    </tr>
                                </table>
                            </DIV>
                        </DIV>
                    </TD>
                    <TD STYLE="border:0px" WIDTH="30%" VALIGN="top">
                        <DIV STYLE="width:100%;border:2px solid gray;background-color:#808000;color:white;">
                            <DIV ONCLICK="JavaScript: changeMode('menu2');" STYLE="width:100%;background-color:#808000;color:white;cursor:hand;font-size:14;">
                                <B>&#1593;&#1605;&#1604;&#1610;&#1575;&#1578; &#1573;&#1590;&#1575;&#1601;&#1577; / Addition Operations</B> <img src="images/arrow_down.gif">
                            </DIV>
                            
                            <DIV ALIGN="right" STYLE="width:100%;background-color:#FFFFCC;color:black;display:block;text-align:right;" ID="menu2">
                                <table border="0" cellpadding="0" cellspacing="3" width="100%" bgcolor="#FFFFCC">
                                    <tr>
                                        <td style="border:1px solid blue;cursor:hand;color:white;" width="33%" bgcolor="white" >
                                            <a href="<%=context%>/ScheduleServlet?op=BindSingleSchedUnit&equipmentID=<%=equipmentID%>">
                                                <font color="black"> <B>&#1585;&#1576;&#1591; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577; &#1576;&#1580;&#1583;&#1608;&#1604; &#1589;&#1610;&#1575;&#1606;&#1577;</B></FONT>
                                            </A>
                                        </td>
                                        <td style="border:1px solid blue;cursor:hand;color:white;" width="33%" bgcolor="white" >
                                            <a href="<%=context%>/EquipmentServlet?op=GetChangeForm&equipmentID=<%=equipmentID%>">
                                                <font color="black"> <B>&#1578;&#1594;&#1610;&#1610;&#1585;&#1575;&#1578; &#1593;&#1604;&#1610; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;</B></FONT>
                                            </A>
                                        </td>
                                        <td style="border:1px solid blue;cursor:hand;color:white;" width="33%" bgcolor="white" >
                                            <a href="<%=context%>/UnitDocWriterServlet?op=SelectFile&equipmentID=<%=equipmentID%>">
                                                <font color="black"><B>&#1573;&#1585;&#1601;&#1602; &#1605;&#1587;&#1578;&#1606;&#1583;</B></FONT>
                                            </A>
                                        </td>
                                    </tr>
                                    
                                    <tr>
                                        
                                        <td style="border:1px solid blue; color:white; cursor:hand; display: <%=userPrevList.contains("EXCEL") ? "" : "none"%>;" width="33%"   bgcolor="#bbbccc" >
                                            <a href="<%=context%>/UnitDocWriterServlet?op=excel&unitName=<%=equipmentWBO.getAttribute("unitName")%>">
                                                <font color="black"><B> Excel <img src="<%=context%>/images/xlsicon.gif"></B></FONT>
                                            </A>
                                        </td>
                                        <td style="border:1px solid blue;cursor:hand;color:white;" width="33%" bgcolor="#bbbccc" >
                                            <%if(EqAssignedIssues.size()>0){%>
                                            <font color="red" size="2"><B>
                                                    <%=EqHasAssignedJo%>
                                            </B></FONT>
                                            <%}else{%>
                                            <a href="<%=context%>/EqStateTypeServlet?op=ChangeStatusForm&equipmentID=<%=equipmentID%>&currentStatus=<%=currentStatus%>">  
                                                <font color="black"><B>&#1578;&#1594;&#1610;&#1610;&#1600;&#1585; &#1575;&#1604;&#1581;&#1600;&#1600;&#1575;&#1604;&#1600;&#1600;&#1577;</B></FONT>
                                            </A>
                                            <%}%>
                                        </td>
                                        <%if (equipmentWBO.getAttribute("rateType").equals("By Hour")) {%>
                                        <td style="border:1px solid blue;color:white;cursor:hand;" width="33%" bgcolor="#bbbccc" >
                                            <%-- <a href="<%=context%>/AverageUnitServlet?op=UpdateAverageUnitForm&equipmentID=<%=equipmentID%>&currentMode=<%=cMode%>">--%>
                                            <a href="<%=context%>/AverageUnitServlet?op=GetAverageUnitForm&equipmentID=<%=equipmentID%>&currentMode=<%=cMode%>&backto=viewEquipment">
                                                
                                                <font color="black"> <B><%=updateHours%></B></FONT>
                                            </A>
                                        </td>
                                        <%} else {%>
                                        <td style="border:1px solid blue;color:white;cursor:hand;" width="33%" bgcolor="#bbbccc" >
                                            <%--<a href="<%=context%>/AverageUnitServlet?op=UpdateAverageKelUnitForm&equipmentID=<%=equipmentID%>&currentMode=<%=cMode%>">--%>
                                            <a href="<%=context%>/AverageUnitServlet?op=GetAverageeKelUnitForm&equipmentID=<%=equipmentID%>&currentMode=<%=cMode%>&backto=viewEquipment">
                                                <font color="black"><B><%=updateKm%></B></FONT>
                                            </A>
                                        </td>
                                        <%}%>
                                    </tr>
                                    <tr>
                                        
                                        <%//if (equipmentWBO.getAttribute("isStandalone").equals("1")) {
                                        %>
                                        <td style="border:1px solid blue;color:white;cursor:hand;" width="33%" bgcolor="#ffff00" >
                                            <a href="<%=context%>/DriverHistoryServlet?op=GetAttachDriverForm&equipmentID=<%=equipmentID%>&currentMode=<%=cMode%>">
                                                <font color="black"> <B><%=attachDriver%></B></FONT>
                                            </A>
                                        </td>
                                        <%//} else {%>
                                        <!--td style="border:1px solid black;color:white;" width="33%" bgcolor="#ffff00"> 
                                        <font color="red"> <B><%=attachDriver%></B></FONT>
                                        </td-->
                                        <%//}%>
                                        
                                        
                                        
                                        <%
                                        if( attachFlag==1) {
                                        %>               
                                        <td style="border:1px solid blue;color:white;cursor:hand;" width="33%" bgcolor="#ffff00" >
                                            <a href="<%=context%>/SupplementServlet?op=GetSeparateEqForm&EID=<%=equipmentID%>&currentMode=<%=cMode%>">
                                                <font color="black"> <B><%=sSeparateEquipment%></B></FONT>
                                            </A>
                                        </td>
                                        <%}else{%>
                                        <td style="border:1px solid blue;color:white;cursor:hand;" width="33%" bgcolor="#ffff00" > 
                                            <font color="red"> <B><%=sSeparateEquipment%></B></FONT>
                                        </td>
                                        <%}%>
                                        
                                        
                                        
                                        <%if (equipmentWBO.getAttribute("isStandalone").equals("1")) {
                                        if(attachFlag==0)
                                        {
                                        %>                                        
                                        <td style="border:1px solid blue;color:white;cursor:hand;" width="33%" bgcolor="#ffff00"> 
                                            <a href="<%=context%>/SupplementServlet?op=GetAttachEqForm&equipmentID=<%=equipmentID%>&currentMode=<%=cMode%>">
                                                <font color="black"> <B><%=sAttachEquipment%></B></FONT>
                                            </A>
                                        </td>
                                        <%}else{%>
                                        <td style="border:1px solid blue;color:white;" width="33%" bgcolor="#ffff00"> 
                                            <font color="red"> <B><%=sAttachEquipment%></B></FONT>
                                        </td>
                                        <% }}else {%>
                                        <td style="border:1px solid blue;color:white;" width="33%" bgcolor="#ffff00"> 
                                            <font color="red"> <B><%=sAttachEquipment%></B></FONT>
                                        </td>
                                        <%}%>
                                    </tr>
                                    <tr>
                                        <%if(warrantyData.size()>0) {%>
                                        <td style="border:1px solid blue;color:white;cursor:hand;" width="33%"   bgcolor="#bbbccc" >
                                            <font color="red"><B><%=WarrantyExist%></B></FONT>
                                        </td>
                                        <%}else{%>
                                        <td style="border:1px solid blue;color:white;cursor:hand;" width="33%"   bgcolor="#bbbccc" >
                                            <a href="<%=context%>/EquipmentServlet?op=addWarrantyData&equipmentID=<%=equipmentID%>&currentMode=<%=cMode%>">
                                                <font color="black"><B><%=addWarrant%></B></FONT>
                                            </A>
                                        </td>
                                        <%}%>
                                        <%--
                                        <td style="border:1px solid blue;color:white;cursor:hand;" width="33%"   bgcolor="#bbbccc" onclick="JavaScript: changePage('<%=context%>/IssueServlet?op=EmgByEquip&equipmentID=<%=equipmentID%>&currentMode=<%=cMode%>')">
                                            <font color="black"><B><%=Emergency%></B></FONT>
                                        </td>
                                        --%>
                                        <td style="border:1px solid blue;color:white;cursor:hand;" width="33%"   bgcolor="#bbbccc" >
                                            <a href="<%=context%>/IssueServlet?op=no&unitName=<%=equipmentID%>&source=viewImages&currentMode=<%=cMode%>">
                                                <font color="black"><B><%=Emergency%></B></FONT>
                                            </A>
                                        </td>
                                        
                                        <td style="border:1px solid blue;color:white;cursor:hand;" width="33%"   bgcolor="#bbbccc" >
                                            <a href="<%=context%>/EquipmentServlet?op=GetSupplierForm&equipmentID=<%=equipmentID%>&currentMode=<%=cMode%>">
                                                <font color="black"> <B><%=sSupplier%></B></FONT>
                                            </A>
                                        </td>
                                        
                                    </tr>
                                </table>
                            </DIV>
                        </DIV>
                    </TD>
                    
                    
                </TR>
            </TABLE>
            
        </DIV>
        
        <br><br><br><br><br><br>
        <p></p>
        <center>
            <fieldset align="center" class="set">
                
                <legend align="center">
                    <table dir="rtl" align="center">
                        <tr>
                            <td class="td">
                                <font color="blue" size="6">
                                    &#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607; / View Equipment
                                </font>
                            </td>
                        </tr>
                    </table>
                </legend>
                
                <br>
                
                <table width="100%" align="center" style="border: 1px solid blue" bgcolor="#E5E9F3">
                    <tr>
                        <td>
                            <font color="red" size="3"> <b> <%=equipmentWBO.getAttribute("unitName")%></b></font>
                        </td>
                    </tr>
                </table>
                
                <br>
                
                <div class="tab-container" id="container1" style="width:100%;text-align:left;"> 
                    
                    
                    <ul class="tabs"> 
                        <table>
                            <tr>
                                <td>
                                    <li style="border-right: 1px solid #194367;" > 
                                        <a href="#" onClick="return showPane('pane1', this)" id="tab1">&#1578;&#1601;&#1575;&#1589;&#1610;&#1604; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;<BR>Details <img src="images/metal-Inform.gif" width="20px" alt="" /></a> 
                                    </li>
                                </td>
                                <td>
                                    <li> 
                                        <a href="#" onClick="return showPane('pane2', this)" id="tab2">&#1589;&#1610;&#1575;&#1606;&#1577; 6 &#1571;&#1588;&#1607;&#1585; &#1605;&#1587;&#1578;&#1602;&#1576;&#1604;&#1610;&#1607;<BR>Future 6 Months<br> Job Orders</a> 
                                    </li> 
                                </td>
                                <td>
                                    <li style="border-left: 1px solid #194367;"> 
                                        <a href="#" onClick="return showPane('pane3', this)" id="tab3">&#1589;&#1610;&#1575;&#1606;&#1577; &#1570;&#1582;&#1585; 6 &#1571;&#1588;&#1607;&#1585;<BR>Last 6 Months<br> Job Orders</a> 
                                    </li>
                                </td>
                                
                                <%
                                if (request.getAttribute("sAttachedEquipmentID") != null) {
    
    if( attachFlag==1) {
                                
                                %>
                                
                                <td>
                                    <li style="border-left: 1px solid #194367;"> 
                                        <a href="#" onClick="return showPane('pane4', this)" id="tab4">&#1605;&#1604;&#1581;&#1602;&#1575;&#1578;<BR>Attached Equipment</a> 
                                    </li>
                                </td>
                                
                                <%
                                }}
                                %>
                                <%
                                if (metaMgr.getTabs().equalsIgnoreCase("On")) {
                                %>
                                <td>
                                    <li style="border-left: 1px solid #194367;"> 
                                        <a href="#" onClick="return showPane('pane5', this)" id="tab5">&#1580;&#1583;&#1608;&#1575;&#1604; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577; &#1593;&#1604;&#1609; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577;<BR>Schedule Type</a> 
                                    </li>                                
                                </td>
                                <td>
                                    <li style="border-left: 1px solid #194367;"> 
                                        <a href="#" onClick="return showPane('pane6', this)" id="tab6">&#1576;&#1606;&#1608;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577; &#1593;&#1604;&#1609; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577;<BR>Task Type</a> 
                                    </li>                                
                                </td>
                                <td>
                                    <li style="border-left: 1px solid #194367;"> 
                                        <a href="#" onClick="return showPane('pane7', this)" id="tab7">&#1576;&#1606;&#1608;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577; &#1593;&#1604;&#1609; &#1589;&#1606;&#1601; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577;<BR>Schedule Type<br>by Category</a> 
                                    </li>
                                </td>
                                <td>
                                    <li style="border-left: 1px solid #194367;"> 
                                        <a href="#" onClick="return showPane('pane8', this)" id="tab8">&#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583;&#1575;&#1578;<BR>Documents <img src="images/view.png" width="20px" alt="" /></a> 
                                    </li>
                                </td>
                                <%
                                }
                                %>
                        </tr></table>
                    </ul> 
                    
                    <div class="tab-panes"> 
                        <div class="content" id="pane1" style="text-align:center;">
                            <br>
                            <TABLE  WIDTH="100%" CELLPADDING="0" CELLSPACING="0">
                                <TR>
                                    <TD CLASS="td">
                                        
                                        <TABLE STYLE="border:1 solid black"  WIDTH="600" CELLPADDING="0" CELLSPACING="0">
                                            
                                            <TR VALIGN="MIDDLE">
                                                
                                                <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:center;color:white;font-size:14" WIDTH="200"><B>Asset No / &#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1575;&#1603;&#1610;&#1606;&#1607;</B></TD>
                                                
                                                <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:center;color:white;font-size:14" WIDTH="200"><B>Model No / &#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1608;&#1583;&#1610;&#1604;</B></TD>
                                                
                                                <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:center;color:white;font-size:14" WIDTH="200"><B><%=tGuide.getMessage("equipmentname")%> / &#1573;&#1587;&#1605; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;</B></TD>
                                            </tr>
                                            
                                            <TR VALIGN="MIDDLE">
                                                
                                                <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;color:Blue;font-size:12"><b><font  size="3" ><%=equipmentWBO.getAttribute("unitNo")%></font></b></TD>
                                                
                                                <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;color:Blue;font-size:12"><b><font  size="3" ><%=equipmentWBO.getAttribute("modelNo")%></font></b></TD>
                                                
                                                <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;color:Blue;font-size:12"><b><font  size="3" ><%=equipmentWBO.getAttribute("unitName")%></font></b></TD>
                                            </tr>
                                            
                                        </table>
                                        
                                        <br><br>
                                        <TABLE  WIDTH="600" CELLPADDING="0" CELLSPACING="0">
                                            <TR>
                                                <TD CLASS="td" bgcolor="darkgoldenrod" STYLE="text-align:center;color:white;font-size:16" COLSPAN="3">
                                                    <B>&#1602;&#1585;&#1575;&#1569;&#1607; &#1593;&#1583;&#1575;&#1583; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577; / Equipment Counter Reading</B>
                                                </TD>
                                            </TR>
                                            
                                            <TR>
                                                <TD CLASS="td" bgcolor="goldenrod" STYLE="text-align:center;color:white;font-size:14">
                                                    <B>Total<br>&#1575;&#1604;&#1605;&#1580;&#1605;&#1608;&#1593;</B>
                                                </TD>
                                                <TD CLASS="td" bgcolor="goldenrod" STYLE="text-align:center;color:white;font-size:14">
                                                    <B>Last Reading<br>&#1570;&#1582;&#1585; &#1602;&#1585;&#1575;&#1569;&#1577;</B>
                                                </TD>
                                                <TD CLASS="td" bgcolor="goldenrod" STYLE="text-align:center;color:white;font-size:14">
                                                    <B>Last Reading Date<br>&#1578;&#1575;&#1585;&#1610;&#1582; &#1570;&#1582;&#1585; &#1602;&#1585;&#1575;&#1569;&#1577;</B>
                                                </TD>
                                                
                                            </TR>
                                            
                                            <TR>
                                                <%
                                                Vector items = averageUnitMgr.getOnArbitraryKey(equipmentID, "key1");
                                                if (items.size() > 0) {
                                                    for (int i = 0; i < items.size(); i++) {
                                                        WebBusinessObject wbo = (WebBusinessObject) items.elementAt(i);
                                                        WebBusinessObject categoryName = (WebBusinessObject) maintainableMgr.getOnSingleKey(wbo.getAttribute("unitName").toString());
                                                        String unit = "";
                                                        if (equipmentWBO.getAttribute("rateType").equals("odometer")) {
                                                            unit = "km";
                                                        } else {
                                                            unit = "hr";
                                                        }
                                                %>
                                                <TD CLASS="cell" bgcolor="#FFE391" STYLE="text-align:center;"><%=wbo.getAttribute("acual_Reading").toString()%>&nbsp;<%=unit%></TD>
                                                <TD CLASS="cell" bgcolor="#FFE391" STYLE="text-align:center;"><%=wbo.getAttribute("current_Reading").toString()%>&nbsp;<%=unit%></TD>
                                                <%
                                                Date d = Calendar.getInstance().getTime();
                                                String readingDate = (String) wbo.getAttribute("entry_Time");
                                                Long l = new Long(readingDate);
                                                long sl = l.longValue();
                                                d.setTime(sl);
                                                readingDate = d.toString();
                                                year=d.getYear()+1900;
                                                mon=d.getMonth()+1;
                                                day=d.getDate();
                                                readingDate=day+" / "+mon+" / "+year;
                                                //readingDate = readingDate.substring(0, 10) + readingDate.substring(24, 29);
                                                %>
                                                <TD CLASS="cell" bgcolor="#FFE391" STYLE="text-align:center;"><%=readingDate%></TD>
                                                <%
                                                    }
                                                } else {
                                                %>
                                                <TD CLASS="cell" bgcolor="#FFE391" STYLE="text-align:center;" COLSPAN="3">No Reading for this equipment <br> &#1604;&#1575;&#1610;&#1608;&#1580;&#1583; &#1602;&#1585;&#1575;&#1569;&#1577; &#1604;&#1607;&#1584;&#1607; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577;</TD>
                                                <%
                                                }
                                                %>
                                            </TR>
                                        </TABLE>
                                    </TD>
                                    
                                    <TD CLASS="td" ALIGN="RIGHT">
                                        
                                        <%if(equipmentWBO.getAttribute("equipmentStatus").toString().equals("1")){%>
                                        <img src="images/workingEq.gif">
                                        <%}else{%>
                                        <img src="images/stoppedEq.gif">
                                        <%}%>
                                        <br>
                                        <% if (equipmentWBO.getAttribute("isStandalone").equals("1")) {
                                                    if(attachFlag==1){%>
                                        <img src="images/attachedEqps.JPG">
                                        <%}else{%>
                                        <img src="images/truck.JPG">
                                        <%}}else{
                                        Vector attached_Eqps=supplementMgr.getOnArbitraryKey(equipmentID,"key2");
                                        if(attached_Eqps.size()>0){%>
                                        <img src="images/attachedEqps.JPG">
                                        <%}else{%>
                                        <img src="images/semitrailer.JPG">
                                        <%}}%>
                                        
                                    </TD>
                                </TR>
                                
                                <TR>
                                    <TD CLASS="td">&nbsp;</TD>
                                    <TD CLASS="td">&nbsp;</TD>
                                </TR>
                                
                                <TR>
                                    <TD CLASS="td">
                                        <TABLE WIDTH="600" BORDER="0" CELLSPACING="0">
                                            <TR>
                                                <TD CLASS="cell" bgcolor="#808000" STYLE="text-align:center;color:white;font-size:14" COLSPAN="2">
                                                    <B>Basic Information / &#1575;&#1604;&#1576;&#1610;&#1575;&#1606;&#1575;&#1578; &#1575;&#1604;&#1571;&#1587;&#1575;&#1587;&#1610;&#1607;</B>   
                                                </TD>
                                            </TR>
                                            
                                            <TR>
                                                <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><B>Asset No / &#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1575;&#1603;&#1610;&#1606;&#1607;</B></TD>
                                                <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12;font:BOLD;"><%=equipmentWBO.getAttribute("unitNo")%></TD>
                                            </TR>
                                            
                                            <TR>
                                                <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><B><%=tGuide.getMessage("equipmentname")%> / &#1573;&#1587;&#1605; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;</B></TD>
                                                <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12;font:BOLD;"><%=equipmentWBO.getAttribute("unitName")%></TD>
                                            </TR>
                                            
                                            <TR>
                                                <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><B>Engine Number / &#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1581;&#1585;&#1603; / &#1575;&#1604;&#1588;&#1575;&#1587;&#1610;&#1607;</B></TD>
                                                <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12;font:BOLD;"><%=equipmentWBO.getAttribute("engineNo")%></TD>
                                            </TR>
                                            
                                            <TR>
                                                <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><B>Auth. Employee / &#1575;&#1604;&#1605;&#1608;&#1592;&#1601; &#1575;&#1604;&#1605;&#1587;&#1574;&#1608;&#1604;</B></TD>
                                                <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12;font:BOLD;"><%=empWBO.getAttribute("empName")%></TD>
                                            </TR>
                                            
                                            
                                            
                                            
                                            <TR>
                                                <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><B>In Service / &#1583;&#1575;&#1582;&#1604; &#1575;&#1604;&#1582;&#1583;&#1605;&#1607;</B></TD>
                                                <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12;font:BOLD;">
                                                    <%
                                                    String eqStatus=(String)equipmentWBO.getAttribute("equipmentStatus");
                                                    if(eqStatus.equalsIgnoreCase("1")){%>
                                                    <%=yes%>
                                                    <%}else{%>
                                                    <%=no%>
                                                    <%}%>
                                                </TD>
                                            </TR>
                                            
                                            <TR>
                                                <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><B>Category / &#1575;&#1604;&#1606;&#1608;&#1593;</B></TD>
                                                <TD CLASS="cell" bgcolor="darkkhaki" STYLE="text-align:center;font-size:12;font:BOLD;"><B><%=wboTemp.getAttribute("unitName")%></B></TD>
                                            </TR>
                                            
                                            <TR>
                                                <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12;font:BOLD;" WIDTH="200"><B>Status / &#1575;&#1604;&#1581;&#1575;&#1604;&#1607;</B></TD>
                                                <%
                                                String status;
                                                if (equipmentWBO.getAttribute("status").toString().equalsIgnoreCase("Excellent")) {
                                                    status = Excellent;
                                                } else if (equipmentWBO.getAttribute("status").toString().equalsIgnoreCase("Good")) {
                                                    status = Good;
                                                } else {
                                                    status = Poor;
                                                }
                                                %>
                                                <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12;font:BOLD;"><%=status%></TD>
                                            </TR>
                                            
                                            <TR>
                                                <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><B>Is Standalone / &#1578;&#1593;&#1605;&#1604; &#1576;&#1605;&#1601;&#1585;&#1583;&#1607;&#1575;</B></TD>
                                                <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12;font:BOLD;"><% if (equipmentWBO.getAttribute("isStandalone").equals("1")) {%>&#1606;&#1593;&#1605;<%} else {%> &#1604;&#1575;<%}%></TD>
                                            </TR>
                                            
                                            <TR>
                                                <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><B>Service Entry Date / &#1583;&#1582;&#1608;&#1604; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607; &#1575;&#1604;&#1582;&#1583;&#1605;&#1607;</B></TD>
                                                <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12;font:BOLD;">
                                                    <%=(String)equipmentWBO.getAttribute("serviceEntryDATE")%>
                                                </TD>
                                            </TR>
                                            
                                            <TR>
                                                <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><B><%=tGuide.getMessage("equipmentdescription")%> / &#1608;&#1589;&#1601; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;</B></TD>
                                                <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12;font:BOLD;"><%=equipmentWBO.getAttribute("desc")%></TD>
                                            </TR>
                                            
                                            
                                            
                                            
                                            
                                            
                                            
                                            
                                            
                                            
                                            <TR>
                                                <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><B>Model No / &#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1608;&#1583;&#1610;&#1604;</B></TD>
                                                <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12;font:BOLD;"><%=equipmentWBO.getAttribute("modelNo")%></TD>
                                            </TR>
                                            
                                            
                                            <%--
                                        <TR>
                                            <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><B>Notes / &#1605;&#1604;&#1575;&#1581;&#1592;&#1575;&#1578;</B></TD>
                                            <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12;font:BOLD;"><%=eqSupWBO.getAttribute("note")%></TD>
                                        </TR>
                                        
                                        <TR>
                                            <TD CLASS="cell" bgcolor="#808000" STYLE="text-align:center;color:white;font-size:14" COLSPAN="2">
                                                <B>Warranty Data / &#1576;&#1610;&#1575;&#1606;&#1575;&#1578; &#1575;&#1604;&#1590;&#1605;&#1575;&#1606;</B>   
                                            </TD>
                                        </TR>
                                        
                                        <!--TR>
                                            <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><B>Supplier / &#1575;&#1604;&#1605;&#1608;&#1585;&#1583;</B></TD>
                                        <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12"><%//=supWBO.getAttribute("name")%></TD>
                                        </TR>
                                        
                                        <TR>
                                            <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><B>Contractor  / &#1575;&#1604;&#1605;&#1578;&#1593;&#1575;&#1602;&#1583;</B></TD>
                                        <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12"><%//=contEmpWBO.getAttribute("empName")%></TD>
                                        </TR-->
                                        
                                        <TR>
                                            <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><B>Dealing Method / &#1591;&#1576;&#1610;&#1593;&#1577; &#1575;&#1604;&#1578;&#1593;&#1575;&#1605;&#1604;</B></TD>
                                            <%if (eqSupWBO.getAttribute("warranty").equals("1")) {%>
                                            <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12;font:BOLD;">Contract / &#1578;&#1593;&#1575;&#1602;&#1583;</TD>
                                            <%} else {%>
                                            <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12;font:BOLD;">Warranty / &#1590;&#1605;&#1575;&#1606;</TD>
                                            <%}%>
                                        </TR>
                                        
                                        <TR>
                                            <%if (eqSupWBO.getAttribute("warranty").equals("1")) {%>
                                            <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12;font:BOLD;" WIDTH="200"><B>Contract Begin Date / &#1578;&#1600;&#1575;&#1585;&#1610;&#1600;&#1582; &#1576;&#1600;&#1583;&#1575;&#1610;&#1600;&#1607;&nbsp;&#1575;&#1604;&#1600;&#1578;&#1600;&#1593;&#1600;&#1575;&#1602;&#1600;&#1583;</B></TD>
                                            <%} else {%>
                                            <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12;font:BOLD;" WIDTH="200"><B>Warranty Begin Date / &#1578;&#1600;&#1575;&#1585;&#1610;&#1600;&#1582; &#1576;&#1600;&#1583;&#1575;&#1610;&#1600;&#1607;&nbsp;&#1575;&#1604;&#1600;&#1590;&#1600;&#1605;&#1600;&#1575;&#1606;</B></TD>
                                            <%}%>
                                            <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12;font:BOLD;"><%=dateAcquired.substring(0, 10)%></TD>
                                        </TR>
                                        
                                        <TR>
                                            <%if (eqSupWBO.getAttribute("warranty").equals("1")) {%>
                                            <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12;font:BOLD;" WIDTH="200"><B>Contract Date / &#1578;&#1600;&#1575;&#1585;&#1610;&#1600;&#1582; &#1606;&#1600;&#1607;&#1600;&#1575;&#1610;&#1600;&#1607; &#1575;&#1604;&#1600;&#1578;&#1600;&#1593;&#1600;&#1575;&#1602;&#1600;&#1583;</B></TD>
                                            <%} else {%>
                                            <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12;font:BOLD;" WIDTH="200"><B>Warranty Date / &#1578;&#1575;&#1585;&#1610;&#1582; &#1606;&#1607;&#1575;&#1610;&#1577; &#1575;&#1604;&#1590;&#1605;&#1575;&#1606;</B></TD>
                                            <%}%>
                                            <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12;font:BOLD;"><%=expiryDate.substring(0, 10)%></TD>
                                        </TR>
                                        
                                        --%>
                                        
                                        </TABLE>
                                    </TD>
                                    <TD CLASS="td3">
                                        
                                        
                                        
                                        <TABLE>
                                            <% 
                                            if(wboTemp.getAttribute("unitName").toString().equals("Lorry")){ %>
                                            <TR>
                                                <TD class='td3'>
                                                    <img name='LorryImage' alt='Lorry image' src='images/lorry.jpg'  width="250" height="200">
                                                </TD>
                                            </TR>          
                                            <% } else if(wboTemp.getAttribute("unitName").toString().equals("Trailer")){ %>
                                            
                                            <TR>
                                                <TD class='td3'>
                                                    <img name='TrailerImage' alt='Trailer image' src='images/trailer.jpg'  width="250" height="200">
                                                </TD>
                                            </TR> 
                                            <% } %>
                                            <%
                                            if (imagePath.size() > 0) {%>
                                            <TR>
                                                <TD class='td3'>
                                                    <div id="mygallery" class="stepcarousel">
                                                        <div class="belt">
                                                            
                                                            <%for (int i = 0; i < imagePath.size(); i++) {
                                                            %>
                                                            <div class="panel">
                                                                <img name='docImage' alt='document image' src='<%=imagePath.get(i).toString()%>'  width="250" height="180">
                                                            </div>
                                                            <%
                                                            }%>
                                                        </div>
                                                    </div>
                                                </TD>
                                            </TR>
                                            <%} else {
                                            %>
                                            <TR>
                                                <TD class='td'>
                                                    <img name='docImage' alt='document image' src='images/no_image.jpg' border="2">
                                                </TD>
                                            </tr>
                                            <%
                                            }
                                            %>
                                        </Table>
                                    </TD>
                                </TR>
                            </TABLE>
                            <br>
                        </div>
                        <div class="content" id="pane2">
                            <BR><BR>
                            <jsp:include page="/docs/equipment/future_maintenance.jsp" flush="true" />
                        </div>
                        <div class="content" id="pane3">
                            <BR><BR>
                            <jsp:include page="/docs/equipment/last_maintenance.jsp" flush="true" />
                        </div>
                        <%
                        if (request.getAttribute("sAttachedEquipmentID") != null) {
                                                    
                                                    Vector getattachedEqps=supplementMgr.search((String) request.getAttribute("equipID"));
                                                    Row row=null;
                                                    if(getattachedEqps.size()>0){
                                                        row=(Row)getattachedEqps.get(0);
                                                        String attachedEqID=row.getString(3);
                                                        
                                                        equipmentWBO = (WebBusinessObject) maintainableMgr.getOnSingleKey(attachedEqID);
                                                        //equipmentWBO = (WebBusinessObject) maintainableMgr.getOnSingleKey((String) request.getAttribute("sAttachedEquipmentID"));
                                                        wboTemp = maintainableMgr.getOnSingleKey(equipmentWBO.getAttribute("parentId").toString());
                                                        locationWBO = projectMgr.getOnSingleKey(equipmentWBO.getAttribute("site").toString());
                                                        deptWBO = deptMgr.getOnSingleKey(equipmentWBO.getAttribute("department").toString());
                                                        productionLineWBO = productionLineMgr.getOnSingleKey(equipmentWBO.getAttribute("productionLine").toString());
                                                        
                                                        empWBO = empMgr.getOnSingleKey(equipmentWBO.getAttribute("empID").toString());
                                                        //   eqSupWBO = equipSupMgr.getOnSingleKey(equipmentWBO.getAttribute("id").toString());
                                                        //   supWBO = supplierMgr.getOnSingleKey((String) eqSupWBO.getAttribute("supplierID"));
                                                        //  contEmpWBO = empMgr.getOnSingleKey(eqSupWBO.getAttribute("contractEmp").toString());
                                                        eqpOpVector = eqpOpMgr.getOnArbitraryKey(equipmentWBO.getAttribute("id").toString(), "key1");
                                                        eqpOpWbo = (WebBusinessObject) eqpOpVector.elementAt(0);
                                                        
                                                        unitName = equipmentWBO.getAttribute("unitName").toString();
                                                        request.setAttribute("unitName", unitName);
                                                        
                                                        data = new Vector();
                                                        data.add(equipmentWBO);
                        
                        %>
                        <div class="content" id="pane4">
                            <BR>
                            <TABLE  WIDTH="100%" CELLPADDING="0" CELLSPACING="0">
                                <TR>
                                    <TD CLASS="td">
                                        <TABLE  WIDTH="600" CELLPADDING="0" CELLSPACING="0">
                                            <TR>
                                                <TD CLASS="td" bgcolor="darkgoldenrod" STYLE="text-align:center;color:white;font-size:16" COLSPAN="3">
                                                    <B>&#1602;&#1585;&#1575;&#1569;&#1607; &#1593;&#1583;&#1575;&#1583; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577; / Equipment Counter Reading</B>
                                                </TD>
                                            </TR>
                                            
                                            <TR>
                                                <TD CLASS="td" bgcolor="goldenrod" STYLE="text-align:center;color:white;font-size:14">
                                                    <B>Total<br>&#1575;&#1604;&#1605;&#1580;&#1605;&#1608;&#1593;</B>
                                                </TD>
                                                <TD CLASS="td" bgcolor="goldenrod" STYLE="text-align:center;color:white;font-size:14">
                                                    <B>Last Reading<br>&#1570;&#1582;&#1585; &#1602;&#1585;&#1575;&#1569;&#1577;</B>
                                                </TD>
                                                <TD CLASS="td" bgcolor="goldenrod" STYLE="text-align:center;color:white;font-size:14">
                                                    <B>Last Reading Date<br>&#1578;&#1575;&#1585;&#1610;&#1582; &#1570;&#1582;&#1585; &#1602;&#1585;&#1575;&#1569;&#1577;</B>
                                                </TD>                   
                                            </TR>
                                            
                                            <TR>
                                                <%
                                                items = averageUnitMgr.getOnArbitraryKey(equipmentID, "key1");
                                                if (items.size() > 0) {
                                                    for (int i = 0; i < items.size(); i++) {
                                                        WebBusinessObject wbo = (WebBusinessObject) items.elementAt(i);
                                                        WebBusinessObject categoryName = (WebBusinessObject) maintainableMgr.getOnSingleKey(wbo.getAttribute("unitName").toString());
                                                        String unit = "";
                                                        if (equipmentWBO.getAttribute("rateType").equals("odometer")) {
                                                            unit = "km";
                                                        } else {
                                                            unit = "hr";
                                                        }
                                                %>
                                                <TD CLASS="cell" bgcolor="#FFE391" STYLE="text-align:center;"><%=wbo.getAttribute("acual_Reading").toString()%>&nbsp;<%=unit%></TD>
                                                <TD CLASS="cell" bgcolor="#FFE391" STYLE="text-align:center;"><%=wbo.getAttribute("current_Reading").toString()%>&nbsp;<%=unit%></TD>
                                                <%
                                                Date d = Calendar.getInstance().getTime();
                                                String readingDate = (String) wbo.getAttribute("entry_Time");
                                                Long l = new Long(readingDate);
                                                long sl = l.longValue();
                                                d.setTime(sl);
                                                readingDate = d.toString();
                                                year=d.getYear()+1900;
                                                mon=d.getMonth()+1;
                                                day=d.getDate();
                                                readingDate=day+" / "+mon+" / "+year;
                                                //     readingDate = readingDate.substring(0, 10) + readingDate.substring(24, 29);
                                                %>
                                                <TD CLASS="cell" bgcolor="#FFE391" STYLE="text-align:center;"><%=readingDate%></TD>
                                                <%
                                                    }
                                                } else {
                                                %>
                                                <TD CLASS="cell" bgcolor="#FFE391" STYLE="text-align:center;" COLSPAN="3">No Reading for this equipment <br> &#1604;&#1575;&#1610;&#1608;&#1580;&#1583; &#1602;&#1585;&#1575;&#1569;&#1577; &#1604;&#1607;&#1584;&#1607; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577;</TD>
                                                <%
                                                }
                                                %>
                                            </TR>
                                        </TABLE>
                                    </TD>
                                    <TD CLASS="td">
                                    </TD>
                                </TR>
                                
                                <TR>
                                    <TD CLASS="td">&nbsp;</TD>
                                    <TD CLASS="td">&nbsp;</TD>
                                </TR>
                                
                                <TR>
                                    <TD CLASS="td">
                                        <TABLE WIDTH="600" BORDER="0" CELLSPACING="0">
                                            <TR>
                                                <TD CLASS="cell" bgcolor="#808000" STYLE="text-align:center;color:white;font-size:14" COLSPAN="2">
                                                    <B>Basic Information / &#1575;&#1604;&#1576;&#1610;&#1575;&#1606;&#1575;&#1578; &#1575;&#1604;&#1571;&#1587;&#1575;&#1587;&#1610;&#1607;</B>   
                                                </TD>
                                            </TR>
                                            
                                            <TR>
                                                <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><B>Asset No / &#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1575;&#1603;&#1610;&#1606;&#1607;</B></TD>
                                                <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12"><%=equipmentWBO.getAttribute("unitNo")%></TD>
                                            </TR>
                                            
                                            <TR>
                                                <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><B><%=tGuide.getMessage("equipmentname")%> / &#1573;&#1587;&#1605; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;</B></TD>
                                                <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12"><%=equipmentWBO.getAttribute("unitName")%></TD>
                                            </TR>
                                            
                                            <TR>
                                                <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><B>Engine Number / &#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1581;&#1585;&#1603; / &#1575;&#1604;&#1588;&#1575;&#1587;&#1610;&#1607;</B></TD>
                                                <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12"><%=equipmentWBO.getAttribute("engineNo")%></TD>
                                            </TR>
                                            
                                            <TR>
                                                <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><B>Auth. Employee / &#1575;&#1604;&#1605;&#1608;&#1592;&#1601; &#1575;&#1604;&#1605;&#1587;&#1574;&#1608;&#1604;</B></TD>
                                                <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12"><%=empWBO.getAttribute("empName")%></TD>
                                            </TR>
                                            
                                            
                                            
                                            <TR>
                                                <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><B>Production Line / &#1582;&#1591; &#1575;&#1604;&#1573;&#1606;&#1578;&#1575;&#1580;</B></TD>
                                                <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12"><%=productionLineWBO.getAttribute("code")%></TD>
                                            </TR>
                                            
                                            <TR>
                                                <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><B>Category / &#1575;&#1604;&#1606;&#1608;&#1593;</B></TD>
                                                <TD CLASS="cell" bgcolor="darkkhaki" STYLE="text-align:center;font-size:12"><B><%=wboTemp.getAttribute("unitName")%></B></TD>
                                            </TR>
                                            
                                            <TR>
                                                <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><B>Status / &#1575;&#1604;&#1581;&#1575;&#1604;&#1607;</B></TD>
                                                <%
                                                if (equipmentWBO.getAttribute("status").toString().equalsIgnoreCase("Excellent")) {
                                                    status = Excellent;
                                                } else if (equipmentWBO.getAttribute("status").toString().equalsIgnoreCase("Good")) {
                                                    status = Good;
                                                } else {
                                                    status = Poor;
                                                }
                                                %>
                                                <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12"><%=status%></TD>
                                            </TR>
                                            
                                            <TR>
                                                <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><B>Is Standalone / &#1578;&#1593;&#1605;&#1604; &#1576;&#1605;&#1601;&#1585;&#1583;&#1607;&#1575;</B></TD>
                                                <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12"><% if (equipmentWBO.getAttribute("isStandalone").equals("1")) {%>&#1606;&#1593;&#1605;<%} else {%> &#1604;&#1575;<%}%></TD>
                                            </TR>
                                            
                                            <TR>
                                                <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><B><%=tGuide.getMessage("equipmentdescription")%> / &#1608;&#1589;&#1601; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;</B></TD>
                                                <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12"><%=equipmentWBO.getAttribute("desc")%></TD>
                                            </TR>
                                            
                                            <TR>
                                                <TD CLASS="cell" bgcolor="#808000" STYLE="text-align:center;color:white;font-size:14" COLSPAN="2">
                                                    <B>Operation Data / &#1576;&#1610;&#1575;&#1606;&#1575;&#1578; &#1575;&#1604;&#1593;&#1605;&#1604;</B>   
                                                </TD>
                                            </TR>
                                            
                                            
                                            
                                            
                                            
                                            
                                            
                                            
                                            
                                            <TR>
                                                <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><B>Model No / &#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1608;&#1583;&#1610;&#1604;</B></TD>
                                                <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12"><%=equipmentWBO.getAttribute("modelNo")%></TD>
                                            </TR>
                                            
                                            
                                            <%--
                            <TR>
                                <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><B>Notes / &#1605;&#1604;&#1575;&#1581;&#1592;&#1575;&#1578;</B></TD>
                                <%if(eqSupWBO.getAttribute("note").toString()==null||eqSupWBO.getAttribute("note").toString().equals("")){%>
                                <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12">No Notes</TD>
                                <%}else{%>
                                <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12"><%=eqSupWBO.getAttribute("note")%></TD>
                                <%}%>
                                
                            </TR>
                            
                            <TR>
                                <TD CLASS="cell" bgcolor="#808000" STYLE="text-align:center;color:white;font-size:14" COLSPAN="2">
                                    <B>Warranty Data / &#1576;&#1610;&#1575;&#1606;&#1575;&#1578; &#1575;&#1604;&#1590;&#1605;&#1575;&#1606;</B>   
                                </TD>
                            </TR>
                            
                            <!--TR>
                                            <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><B>Supplier / &#1575;&#1604;&#1605;&#1608;&#1585;&#1583;</B></TD>
                            <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12"><%//=supWBO.getAttribute("name")%></TD>
                                        </TR>
                                        
                                        <TR>
                                            <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><B>Contractor  / &#1575;&#1604;&#1605;&#1578;&#1593;&#1575;&#1602;&#1583;</B></TD>
                            <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12"><%//=contEmpWBO.getAttribute("empName")%></TD>
                                        </TR-->
                            
                            <TR>
                                <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><B>Dealing Method / &#1591;&#1576;&#1610;&#1593;&#1577; &#1575;&#1604;&#1578;&#1593;&#1575;&#1605;&#1604;</B></TD>
                                <%if (eqSupWBO.getAttribute("warranty").equals("1")) {%>
                                <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12">Contract / &#1578;&#1593;&#1575;&#1602;&#1583;</TD>
                                <%} else {%>
                                <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12">Warranty / &#1590;&#1605;&#1575;&#1606;</TD>
                                <%}%>
                            </TR>
                            
                            <TR>
                                <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><B>Purchase Date / &#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1588;&#1585;&#1575;&#1569;</B></TD>
                                <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12"><%=dateAcquired.substring(0, 10)%></TD>
                            </TR>
                            
                            <TR>
                                <%if (eqSupWBO.getAttribute("warranty").equals("1")) {%>
                                <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><B>Contract Date / &#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1578;&#1593;&#1575;&#1602;&#1583;</B></TD>
                                <%} else {%>
                                <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><B>Warranty Date / &#1578;&#1575;&#1585;&#1610;&#1582; &#1606;&#1607;&#1575;&#1610;&#1577; &#1575;&#1604;&#1590;&#1605;&#1575;&#1606;</B></TD>
                                <%}%>
                                <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12"><%=expiryDate.substring(0, 10)%></TD>
                            </TR>
                            --%>
                                        </TABLE>
                                    </TD>
                                    <TD CLASS="td">&nbsp;</TD>
                                </TR>
                            </TABLE>
                        </div>
                        <%
                                                    }}
                        %>
                        <%
                        if (metaMgr.getTabs().equalsIgnoreCase("On")) {
                        %>
                        <div class="content" id="pane5">
                            <BR><BR>
                            <jsp:include page="/docs/schedule/List_all_eqp_schedules_by_tap.jsp" flush="true" />
                        </div>
                        <div class="content" id="pane6">
                            <BR><BR>
                            <jsp:include page="/docs/schedule/List_all_eqp_tasks_by_tap.jsp" flush="true" />
                        </div>
                        <div class="content" id="pane7">
                            <BR><BR>
                            <jsp:include page="/docs/schedule/List_all_eqpCat_tasks_by_tap.jsp" flush="true" />
                        </div>
                        <div class="content" id="pane8">
                            <BR><BR>
                            <jsp:include page="/docs/unit_doc_handling/docs_list_by_tap.jsp" flush="true" />
                        </div>
                        <%
                        }
                        %>
                    </div> 
                </div>
                <br>
            </fieldset>
        </center>
    </BODY>
</HTML>     
