
<%@ page contentType="text/html; charset=utf-8"%>
<%@page import="com.customization.model.Customization"%>
<%@page import="com.customization.common.CustomizeEquipmentMgr"%>
<%@ page import="com.docviewer.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.db_access.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.docviewer.db_access.DocTypeMgr"%>
<%@ page import="com.contractor.db_access.MaintainableMgr, com.maintenance.db_access.*, com.tracker.db_access.*, com.silkworm.persistence.relational.Row"%>  
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<%
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

    // Customization Screen
    CustomizeEquipmentMgr customizeEquipmentMgr = CustomizeEquipmentMgr.getInstance();
    Customization customizationProductionLine = customizeEquipmentMgr.getCustomization(CustomizeEquipmentMgr.PRODUCTION_LINE_ELEMENT);

    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    MaintainableMgr maintainableMgr = MaintainableMgr.getInstance();
    ProjectMgr projectMgr = ProjectMgr.getInstance();
    DepartmentMgr deptMgr = DepartmentMgr.getInstance();
    ProductionLineMgr productionLineMgr = ProductionLineMgr.getInstance();
    SupplementMgr supplementMgr = SupplementMgr.getInstance();

    SupplierEquipmentMgr equipSupMgr = SupplierEquipmentMgr.getInstance();
    EquipOperationMgr eqpOpMgr = EquipOperationMgr.getInstance();
    AverageUnitMgr averageUnitMgr = AverageUnitMgr.getInstance();

    String context = metaMgr.getContext();

    WebBusinessObject equipmentWBO = (WebBusinessObject) maintainableMgr.getOnSingleKey((String) request.getAttribute("equipID"));
    WebBusinessObject wboTemp = maintainableMgr.getOnSingleKey(equipmentWBO.getAttribute("parentId").toString());
    WebBusinessObject locationWBO = projectMgr.getOnSingleKey(equipmentWBO.getAttribute("site").toString());
    WebBusinessObject deptWBO = deptMgr.getOnSingleKey(equipmentWBO.getAttribute("department").toString());
    WebBusinessObject productionLineWBO = productionLineMgr.getOnSingleKey(equipmentWBO.getAttribute("productionLine").toString());

    MainCategoryTypeMgr mainCatTypeMgr = MainCategoryTypeMgr.getInstance();
    WebBusinessObject mainCatTypeWbo = mainCatTypeMgr.getOnSingleKey((String) equipmentWBO.getAttribute("maintTypeId"));

    Vector eqpOpVector = eqpOpMgr.getOnArbitraryKey(equipmentWBO.getAttribute("id").toString(), "key1");
    WebBusinessObject eqpOpWbo = new WebBusinessObject();
    if (eqpOpVector.size() > 0) {
        eqpOpWbo = (WebBusinessObject) eqpOpVector.elementAt(0);
    }

    //Warranty Data
    Vector warrantyData = equipSupMgr.getOnArbitraryKey((String) request.getAttribute("equipID"), "key");


    String unitName = equipmentWBO.getAttribute("unitName").toString();
    request.setAttribute("unitName", unitName);

    Vector data = new Vector();
    data.add(equipmentWBO);

    request.getSession().setAttribute("info", data);
    response.addHeader("Pragma", "No-cache");
    response.addHeader("Cache-Control", "no-cache");
    response.addDateHeader("Expires", 1);

    Vector imagePath = (Vector) request.getAttribute("imagePath");

    EqChangesMgr eqChangesMgr = EqChangesMgr.getInstance();
    Vector vecChanges = eqChangesMgr.getOnArbitraryKey(((String) equipmentWBO.getAttribute("id")), "key1");



    String equipmentID = (String) request.getAttribute("equipID");
    String imageshow = (String) request.getAttribute("imageshow");

    Vector eqps = supplementMgr.getOnArbitraryKey(equipmentID, "key1");
    WebBusinessObject tempwbo = new WebBusinessObject();

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
    Vector attachedEqps = new Vector();
    attachedEqps = supplementMgr.search(equipmentID);
    int attachFlag = 0;
    if (attachedEqps.size() > 0) {
        attachFlag = 1;
    }


    String url = context + "/main.jsp";
    String cMode = (String) request.getSession().getAttribute("currentMode");
    String stat = cMode;
    int year, mon, day;
    String align = null;
    String dir = null;
    String style = null;
    String lang, viewAttachedHistory, EqHasAssignedJo, eqType_odometer, WarrantyExist, viewWarrantyData, noWarrantyData, addWarrant, eqType_continues, Countinous, By_Order, viewSeparateHistory, langCode, tit, save, cancel, TT, SNA, tit1, RU, EMP, STAT, NO, Reading, Excellent, Good, Poor, updateHours, listHours, updateKm, listKm, Emergency, sSupplier, sSupplierList, sAttachEquipment, Indicators, red_font, red_font_tib, black_font, black_font_tib, attachDriver, header, sSeparateEquipment;
    String listAttachedDriver = null;
    String workingEq, stoppedEq, stoppedEq_tip, workingEq_tip, printPreview, addEqpOperation, eqpOperationAdded,
            mainCatName, byPrecentage, additionalData, eqpChanges, assignSchedule, attachDoc, changeStatus,
            noFiles, viewFiles, viewChanges, noChanges, jobOrders, jobOrdersDates, changesDates, manufData, eqpHistory, putDriver, connPart, listPart;
    String back = "&#1575;&#1604;&#1575;&#1580;&#1606;&#1583;&#1607; &#1575;&#1604;&#1575;&#1587;&#1576;&#1608;&#1593;&#1610;&#1607;";
    String moveEqp;
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
        updateKm = "Update Equipment By Odometer";
        updateHours = "Update Equipment Hours";
        listHours = "List Equipment Hours";

        listKm = "List Equipment By Odometer";
        Emergency = "Normal Order";
        sSupplier = "Add External Supplier";
        sSupplierList = "List External Supplier";
        sAttachEquipment = "Attach Equipment";
        sSeparateEquipment = "Separate Equipment";
        Indicators = "Indicators Guide";
        red_font = "Red Font Operations Can't Access";
        red_font_tib = "This Option can't Performed now for this Equipment";
        black_font = "Black Font Operations Can Access This Option";
        black_font_tib = "You Can Perform This Option Now For This Equipment";
        attachDriver = "Attach Employee";
        header = "View Details for Equipment ";
        viewAttachedHistory = "View Attached History";
        viewSeparateHistory = "View Separation History";
        listAttachedDriver = "List attached Drivers";
        Countinous = "Countinous";
        By_Order = "By Order";
        eqType_odometer = "Working by KM";
        eqType_continues = "Working by Hours";
        addWarrant = "Add Warranty Data";
        noWarrantyData = "No Warranty Data";
        viewWarrantyData = "View Warranty Data";
        WarrantyExist = "Updating Warranty Data ";
        EqHasAssignedJo = "Equipment Has Opened Job Orders";
        workingEq = "Working Equipment";
        workingEq_tip = "This Equipment Is WoworkingEq_tiprking Now";
        stoppedEq = "Out Of Working Equipment";
        stoppedEq_tip = "This Equipment Is Out Of Working Now";
        printPreview = "Print Preview";
        addEqpOperation = "Update Operation";
        eqpOperationAdded = "Operation Added before";
        mainCatName = "Main Category";
        byPrecentage = " By ";
        additionalData = "Additional Data";
        manufData = "Manufactorer Data";
        eqpChanges = "Equipment Changes";
        assignSchedule = "Assign Schedule";
        attachDoc = "Attach File";
        changeStatus = "Change Status";
        noFiles = "No Attached Documents";
        viewFiles = "View Attached Documents";
        viewChanges = "View Equipment Changes";
        noChanges = "No Changes";
        jobOrders = "Job Orders";
        jobOrdersDates = "Job Orders Dates";
        changesDates = "Changes Dates";
        putDriver = "Put Driver";
        connPart = "Connecting Part";
        listPart = "List attached Part";
        moveEqp = "Move Equipment";
        eqpHistory = "View Equipment History";
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
        sSeparateEquipment = "&#1601;&#1589;&#1604; &#1605;&#1593;&#1583;&#1607;";
        Indicators = "&#1575;&#1604;&#1605;&#1585;&#1588;&#1583; &#1575;&#1604;&#1605;&#1589;&#1608;&#1585;";
        red_font = "&#1582;&#1591; &#1575;&#1581;&#1605;&#1585; &#1593;&#1605;&#1604;&#1610;&#1575;&#1578; &#1604;&#1575; &#1610;&#1605;&#1603;&#1606; &#1575;&#1604;&#1602;&#1610;&#1575;&#1605; &#1576;&#1607;&#1575;";
        red_font_tib = "&#1607;&#1584;&#1607; &#1575;&#1604;&#1582;&#1575;&#1589;&#1610;&#1607; &#1594;&#1610;&#1585; &#1605;&#1578;&#1608;&#1601;&#1585;&#1607; &#1604;&#1607;&#1584;&#1607; &#1575;&#1604;&#1605;&#1575;&#1603;&#1610;&#1606;&#1607; &#1601;&#1609; &#1575;&#1604;&#1608;&#1602;&#1578; &#1575;&#1604;&#1581;&#1575;&#1604;&#1609;";
        black_font = "&#1582;&#1591; &#1571;&#1587;&#1608;&#1583; &#1593;&#1605;&#1604;&#1610;&#1575;&#1578; &#1610;&#1605;&#1603;&#1606; &#1575;&#1604;&#1602;&#1610;&#1575;&#1605; &#1576;&#1607;&#1575; &#1575;&#1604;&#1575;&#1606;";
        black_font_tib = "&#1607;&#1584;&#1607; &#1575;&#1604;&#1582;&#1575;&#1589;&#1610;&#1607; &#1610;&#1605;&#1603;&#1606;&#1603; &#1578;&#1606;&#1601;&#1610;&#1584;&#1607;&#1575; &#1601;&#1609; &#1575;&#1604;&#1608;&#1602;&#1578; &#1575;&#1604;&#1581;&#1575;&#1604;&#1609;";
        attachDriver = "&#1573;&#1604;&#1581;&#1575;&#1602; &#1605;&#1608;&#1592;&#1601;";
        header = "&#1605;&#1600;&#1588;&#1600;&#1575;&#1607;&#1600;&#1583;&#1607; &#1578;&#1600;&#1601;&#1600;&#1575;&#1589;&#1600;&#1610;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1604; &#1575;&#1604;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1605;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1593;&#1600;&#1583;&#1607;";
        viewAttachedHistory = "&#1593;&#1585;&#1590; &#1578;&#1608;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1571;&#1604;&#1581;&#1575;&#1602;";
        viewSeparateHistory = "&#1593;&#1585;&#1590; &#1578;&#1608;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1601;&#1589;&#1604;";
        listAttachedDriver = "&#1593;&#1585;&#1590; &#1573;&#1604;&#1581;&#1575;&#1602; &#1575;&#1604;&#1587;&#1575;&#1574;&#1602;&#1610;&#1606;";
        Countinous = "&#1605;&#1587;&#1578;&#1605;&#1585;&#1607;";
        By_Order = "&#1576;&#1575;&#1604;&#1591;&#1604;&#1576;";
        eqType_odometer = "&#1605;&#1593;&#1583;&#1607; &#1576;&#1603;&#1605;";
        eqType_continues = "&#1605;&#1593;&#1583;&#1607; &#1576;&#1575;&#1604;&#1587;&#1575;&#1593;&#1607;";
        addWarrant = "&#1575;&#1590;&#1575;&#1601;&#1607; &#1576;&#1610;&#1575;&#1606;&#1575;&#1578; &#1575;&#1604;&#1590;&#1605;&#1575;&#1606;";
        viewWarrantyData = "&#1605;&#1588;&#1575;&#1607;&#1583;&#1607; &#1576;&#1610;&#1575;&#1606;&#1575;&#1578; &#1575;&#1604;&#1590;&#1605;&#1575;&#1606;";
        noWarrantyData = "&#1604;&#1575; &#1610;&#1608;&#1580;&#1583; &#1590;&#1605;&#1575;&#1606;";
        WarrantyExist = "&#1578;&#1581;&#1583;&#1610;&#1579; &#1576;&#1610;&#1575;&#1606;&#1575;&#1578; &#1575;&#1604;&#1590;&#1605;&#1575;&#1606;";
        EqHasAssignedJo = "&#1575;&#1604;&#1605;&#1593;&#1583;&#1607; &#1605;&#1585;&#1578;&#1576;&#1591;&#1607; &#1576;&#1571;&#1605;&#1585; &#1588;&#1594;&#1604; &#1605;&#1601;&#1578;&#1608;&#1581;";
        workingEq = "&#1605;&#1593;&#1583;&#1607; &#1578;&#1593;&#1605;&#1604; &#1575;&#1604;&#1575;&#1606; (&#1583;&#1575;&#1582;&#1604; &#1575;&#1604;&#1582;&#1583;&#1605;&#1607;)";
        workingEq_tip = "&#1607;&#1584;&#1607; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607; &#1578;&#1593;&#1605;&#1604; &#1575;&#1604;&#1575;&#1606; (&#1583;&#1575;&#1582;&#1604; &#1575;&#1604;&#1582;&#1583;&#1605;&#1607;)";
        stoppedEq = "&#1605;&#1593;&#1583;&#1607; &#1604;&#1575; &#1578;&#1593;&#1605;&#1604; &#1575;&#1604;&#1575;&#1606; (&#1582;&#1575;&#1585;&#1580; &#1575;&#1604;&#1582;&#1583;&#1605;&#1607;)";
        stoppedEq_tip = "&#1607;&#1584;&#1607; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607; &#1604;&#1575; &#1578;&#1593;&#1605;&#1604; &#1575;&#1604;&#1575;&#1606; (&#1582;&#1575;&#1585;&#1580; &#1575;&#1604;&#1582;&#1583;&#1605;&#1607;)";
        printPreview = "&#1605;&#1588;&#1575;&#1607;&#1583;&#1607; &#1604;&#1604;&#1591;&#1576;&#1575;&#1593;&#1607;";
        addEqpOperation = "&#1578;&#1581;&#1583;&#1610;&#1579; &#1593;&#1605;&#1604; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;";
        eqpOperationAdded = "&#1578;&#1605; &#1573;&#1583;&#1582;&#1575;&#1604; &#1576;&#1610;&#1575;&#1606;&#1575;&#1578; &#1593;&#1605;&#1604; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;";
        mainCatName = "&#1575;&#1604;&#1606;&#1608;&#1593; &#1575;&#1604;&#1575;&#1587;&#1575;&#1587;&#1609;";
        byPrecentage = "&#1576;&#1606;&#1587;&#1576;&#1600;&#1600;&#1600;&#1577;";
        additionalData = "&#1576;&#1600;&#1600;&#1610;&#1600;&#1600;&#1575;&#1606;&#1600;&#1600;&#1600;&#1575;&#1578; &#1571;&#1590;&#1600;&#1600;&#1575;&#1601;&#1600;&#1600;&#1610;&#1600;&#1600;&#1600;&#1600;&#1600;&#1607;";
        manufData = "&#1576;&#1610;&#1600;&#1600;&#1575;&#1606;&#1600;&#1600;&#1600;&#1600;&#1575;&#1578; &#1575;&#1604;&#1578;&#1600;&#1589;&#1606;&#1600;&#1610;&#1600;&#1600;&#1600;&#1600;&#1593;";
        eqpChanges = "&#1578;&#1594;&#1610;&#1610;&#1585;&#1575;&#1578; &#1593;&#1604;&#1610; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;";
        assignSchedule = "&#1585;&#1576;&#1591; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577; &#1576;&#1580;&#1583;&#1608;&#1604; &#1589;&#1610;&#1575;&#1606;&#1577;";
        attachDoc = "&#1573;&#1585;&#1601;&#1602; &#1605;&#1587;&#1578;&#1606;&#1583;";
        changeStatus = "&#1578;&#1594;&#1610;&#1610;&#1600;&#1585; &#1575;&#1604;&#1581;&#1600;&#1600;&#1575;&#1604;&#1600;&#1600;&#1577;";
        noFiles = "&#1604;&#1575; &#1610;&#1608;&#1580;&#1583; &#1605;&#1587;&#1578;&#1606;&#1583;&#1575;&#1578; &#1605;&#1585;&#1601;&#1602;&#1607;";
        viewFiles = "&#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583;&#1575;&#1578;";
        viewChanges = "&#1605;&#1588;&#1575;&#1607;&#1583;&#1607; &#1575;&#1604;&#1578;&#1594;&#1610;&#1585;&#1575;&#1578;";
        noChanges = "&#1604;&#1575; &#1578;&#1608;&#1580;&#1583; &#1578;&#1594;&#1610;&#1610;&#1585;&#1575;&#1578;";
        jobOrders = "&#1571;&#1608;&#1575;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
        jobOrdersDates = "&#1578;&#1575;&#1585;&#1610;&#1582; &#1571;&#1608;&#1575;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
        changesDates = "&#1578;&#1600;&#1600;&#1575;&#1585;&#1610;&#1600;&#1582; &#1575;&#1604;&#1581;&#1600;&#1600;&#1575;&#1604;&#1600;&#1600;&#1577;";
        putDriver = "&#1573;&#1604;&#1581;&#1575;&#1602; &#1587;&#1575;&#1574;&#1602;";
        listPart = "&#1593;&#1585;&#1590; &#1575;&#1604;&#1605;&#1604;&#1581;&#1602;&#1575;&#1578;";
        connPart = "&#1585;&#1576;&#1591; &#1605;&#1604;&#1581;&#1602;";
        moveEqp = "&#1578;&#1581;&#1585;&#1610;&#1603; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577;";
        eqpHistory = "&#1593;&#1585;&#1590; &#1578;&#1581;&#1585;&#1603;&#1575;&#1578; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577;";
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
    -->
</style>

<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Maintenance - View Equipment Details</TITLE>
        <link rel="stylesheet" href="styles/layout.css" type="text/css" />
        <script type="text/javascript" src="scripts/jquery-1.4.3.min.js"></script>
        <script type="text/javascript" src="scripts/fancybox/jquery.mousewheel-3.0.4.pack.js"></script>
        <script type="text/javascript" src="scripts/fancybox/jquery.fancybox-1.3.2.js"></script>
        <script type="text/javascript" src="scripts/fancybox/jquery.fancybox-1.3.2.setup.js"></script>
        <link rel="stylesheet" href="scripts/fancybox/jquery.fancybox-1.3.2.css" type="text/css" />

    </HEAD>

    <BODY>

    <center>
       


            <br>
            <center>
                <%if (imageshow.equals("single")) {%>
                <table  WIDTH="100%" align="center" CELLPADDING="0" CELLSPACING="0">
                    <tr>
                        <td align="center" CLASS="td"><table WIDTH="600" BORDER="0" align="center" CELLSPACING="0">
                                <tr>
                                    <td CLASS="blueBorder" bgcolor="#CCCCCC" STYLE="border:1px solid #999; text-align:center;color:#333333;font-size:14;" COLSPAN="2"><font color="whit" size="3">
                            كارت المعدة /  Equipment sheet
                            </font></td>
                                </tr>
                                <tr>
                                    <td CLASS="cell" bgcolor="#CCCCCC" STYLE="border:1px solid #999; text-align:left;color:#333333;font-size:12" WIDTH="200"><b>Asset No / &#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1575;&#1603;&#1610;&#1606;&#1607;</b></td>
                                    <td CLASS="cell" bgcolor="#EDEDED" STYLE="border:1px solid #999; text-align:center;font-size:12;font:BOLD;"><%=equipmentWBO.getAttribute("unitNo")%></td>
                                </tr>
                                <tr>
                                    <td CLASS="cell" bgcolor="#CCCCCC" STYLE="border:1px solid #999; text-align:left;color:#333333;font-size:12" WIDTH="200"><b><%=tGuide.getMessage("equipmentname")%> / &#1573;&#1587;&#1605; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;</b></td>
                                    <td CLASS="cell" bgcolor="#EDEDED" STYLE="border:1px solid #999; text-align:center;font-size:12;font:BOLD;"><%=equipmentWBO.getAttribute("unitName")%></td>
                                </tr>
                                <tr>
                                    <td CLASS="cell" bgcolor="#CCCCCC" STYLE="border:1px solid #999; text-align:left;color:#333333;font-size:12" WIDTH="200"><b>Engine Number / &#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1581;&#1585;&#1603; / &#1575;&#1604;&#1588;&#1575;&#1587;&#1610;&#1607;</b></td>
                                    <td CLASS="cell" bgcolor="#EDEDED" STYLE="border:1px solid #999; text-align:center;font-size:12;font:BOLD;"><%=equipmentWBO.getAttribute("engineNo")%></td>
                                </tr>
                                <%--
                                                    <tr>
                                                        <td CLASS="cell" bgcolor="#9B9B00" STYLE="border:1px solid #999; text-align:left;color:#333333;font-size:12" WIDTH="200"><b>Auth. Employee / &#1575;&#1604;&#1605;&#1608;&#1592;&#1601; &#1575;&#1604;&#1605;&#1587;&#1574;&#1608;&#1604;</b></td>
                                                        <td CLASS="cell" bgcolor="#EDEDED" STYLE="border:1px solid #999; text-align:center;font-size:12;font:BOLD;"><%=empWBO.getAttribute("empName")%></td>
                                                    </tr>
                                --%>
                                <tr>
                                    <td CLASS="cell" bgcolor="#CCCCCC" STYLE="border:1px solid #999; text-align:left;color:#333333;font-size:12" WIDTH="200"><b>Location / &#1575;&#1604;&#1605;&#1608;&#1602;&#1593;</b></td>
                                    <td CLASS="cell" bgcolor="#EDEDED" STYLE="border:1px solid #999; text-align:center;font-size:12;font:BOLD;"><%=locationWBO.getAttribute("projectName")%></td>
                                </tr>
                                <tr>
                                    <td CLASS="cell" bgcolor="#CCCCCC" STYLE="border:1px solid #999; text-align:left;color:#333333;font-size:12" WIDTH="200"><b>Department / &#1575;&#1604;&#1602;&#1587;&#1605;</b></td>
                                    <td CLASS="cell" bgcolor="#EDEDED" STYLE="border:1px solid #999; text-align:center;font-size:12;font:BOLD;"><%=deptWBO.getAttribute("departmentName")%></td>
                                </tr>
                                <% if (customizationProductionLine.display()) {%>
                                <tr>
                                    <td CLASS="cell" bgcolor="#CCCCCC" STYLE="border:1px solid #999; text-align:left;color:#333333;font-size:12" WIDTH="200"><b>Production Line / &#1582;&#1591; &#1575;&#1604;&#1573;&#1606;&#1578;&#1575;&#1580;</b></td>
                                    <td CLASS="cell" bgcolor="#EDEDED" STYLE="border:1px solid #999; text-align:center;font-size:12;font:BOLD;"><%=productionLineWBO.getAttribute("code")%></td>
                                </tr>
                                <% }%>
                                <tr>
                                    <td CLASS="cell" bgcolor="#CCCCCC" STYLE="border:1px solid #999; text-align:left;color:#333333;font-size:12" WIDTH="200"><b>Main Category / &#1575;&#1604;&#1606;&#1608;&#1593; &#1575;&#1604;&#1575;&#1587;&#1575;&#1587;&#1609;</b></td>
                                    <td CLASS="cell" bgcolor="#EDEDED" STYLE="border:1px solid #999; text-align:center;font-size:12;font:BOLD;"><b><%=mainCatTypeWbo.getAttribute("typeName")%></b></td>
                                </tr>
                                <tr>
                                    <td CLASS="cell" bgcolor="#CCCCCC" STYLE="border:1px solid #999; text-align:left;color:#333333;font-size:12" WIDTH="200"><b>Model/Brand/Year  / &#1575;&#1604;&#1605;&#1575;&#1585;&#1603;&#1607;/&#1575;&#1604;&#1605;&#1608;&#1583;&#1610;&#1604;/&#1587;&#1606;&#1577; &#1575;&#1604;&#1578;&#1589;&#1606;&#1610;&#1593; </b></td>
                                    <td CLASS="cell" bgcolor="#EDEDED" STYLE="border:1px solid #999; text-align:center;font-size:12;font:BOLD;"><b><%=wboTemp.getAttribute("unitName")%></b></td>
                                </tr>
                                <tr>
                                    <td CLASS="cell" bgcolor="#CCCCCC" STYLE="border:1px solid #999; text-align:left;color:#333333;font-size:12;font:BOLD;" WIDTH="200"><b>Status / &#1575;&#1604;&#1581;&#1575;&#1604;&#1607;</b></td>
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
                                    <td CLASS="cell" DIR="RTL" bgcolor="#EDEDED" STYLE="border:1px solid #999; text-align:center;font-size:12;font:BOLD;"><%=status%>&nbsp;&nbsp; <%=byPrecentage%>&nbsp;&nbsp; <%=equipmentWBO.getAttribute("statusValue").toString()%></td>
                                </tr>
                                <tr>
                                    <td CLASS="cell" bgcolor="#CCCCCC" STYLE="border:1px solid #999; text-align:left;color:#333333;font-size:12" WIDTH="200"><b>Is Standalone / &#1578;&#1593;&#1605;&#1604; &#1576;&#1605;&#1601;&#1585;&#1583;&#1607;&#1575;</b></td>
                                    <td CLASS="cell" bgcolor="#EDEDED" STYLE="border:1px solid #999; text-align:center;font-size:12;font:BOLD;"><% if (equipmentWBO.getAttribute("isStandalone").equals("1")) {%>
                                        &#1606;&#1593;&#1605;
                                        <%} else {%>
                                        &#1604;&#1575;
                                        <%}%></td>
                                </tr>
                                <tr>
                                    <td CLASS="cell" bgcolor="#CCCCCC" STYLE="border:1px solid #999; text-align:left;color:#333333;font-size:12" WIDTH="200"><b>Service Entry Date / &#1583;&#1582;&#1608;&#1604; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607; &#1575;&#1604;&#1582;&#1583;&#1605;&#1607;</b></td>
                                    <td CLASS="cell" bgcolor="#EDEDED" STYLE="border:1px solid #999; text-align:center;font-size:12;font:BOLD;"><%=(String) equipmentWBO.getAttribute("serviceEntryDATE")%></td>
                                </tr>
                                <tr>
                                    <td CLASS="cell" bgcolor="#CCCCCC" STYLE="border:1px solid #999; text-align:left;color:#333333;font-size:12" WIDTH="200"><b><%=tGuide.getMessage("equipmentdescription")%> / &#1608;&#1589;&#1601; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;</b></td>
                                    <td CLASS="cell" bgcolor="#EDEDED" STYLE="border:1px solid #999; text-align:center;font-size:12;font:BOLD;"><%=equipmentWBO.getAttribute("desc")%></td>
                                </tr>
                                <%if (eqpOpVector.size() > 0) {%>
                                <tr bgcolor="#CCCCCC">
                                    <td COLSPAN="2" bgcolor="#CCCCCC" CLASS="cell" STYLE="border:1px solid #999; text-align:center;color:#333333;font-size:14"><b>Operation Data / &#1576;&#1610;&#1575;&#1606;&#1575;&#1578; &#1575;&#1604;&#1593;&#1605;&#1604;</b></td>
                                </tr>
                                <tr>
                                    <td CLASS="cell" bgcolor="#CCCCCC" STYLE="border:1px solid #999; text-align:left;color:#333333;font-size:12" WIDTH="200"><b>Equipment Type / &#1606;&#1608;&#1593; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;</b></td>
                                    <%if (equipmentWBO.getAttribute("rateType").toString().equalsIgnoreCase("By Hour")) {%>
                                    <td CLASS="cell" bgcolor="#CCCCCC" STYLE="border:1px solid #999; text-align:center;font-size:12;font:BOLD;"><b><%=eqType_continues%></b></td>
                                    <%} else {%>
                                    <td CLASS="cell" bgcolor="#CCCCCC" STYLE="border:1px solid #999; text-align:center;font-size:12;font:BOLD;"><b><%=eqType_odometer%></b></td>
                                    <%}%>
                                </tr>
                                <tr>
                                    <td CLASS="cell" bgcolor="#CCCCCC" STYLE="border:1px solid #999; text-align:left;color:#333333;font-size:12" WIDTH="200"><b>Operation Type / &#1606;&#1608;&#1593; &#1575;&#1604;&#1593;&#1605;&#1604;</b></td>
                                    <%if (eqpOpWbo.getAttribute("operation_type").toString().equalsIgnoreCase("Countinous")) {%>
                                    <td CLASS="cell" bgcolor="#EDEDED" STYLE="border:1px solid #999; text-align:center;font-size:12;font:BOLD;"><%=Countinous%></td>
                                    <%} else {%>
                                    <td CLASS="cell" bgcolor="#EDEDED" STYLE="border:1px solid #999; text-align:center;font-size:12;font:BOLD;"><%=By_Order%></td>
                                    <%}%>
                                </tr>
                                <tr>
                                    <td CLASS="cell" bgcolor="#CCCCCC" STYLE="border:1px solid #999; text-align:left;color:#333333;font-size:12" WIDTH="200"><b>Average / &#1575;&#1604;&#1605;&#1578;&#1608;&#1587;&#1591;</b></td>
                                    <%if (equipmentWBO.getAttribute("rateType").toString().equalsIgnoreCase("By Hour")) {%>
                                    <td CLASS="cell" bgcolor="#EDEDED" STYLE="border:1px solid #999; text-align:center;font-size:12;font:BOLD;"><%=eqpOpWbo.getAttribute("average")%> Hours.</td>
                                    <%} else {%>
                                    <td CLASS="cell" bgcolor="#EDEDED" STYLE="border:1px solid #999; text-align:center;font-size:12;font:BOLD;"><%=eqpOpWbo.getAttribute("average")%> K.M.</td>
                                    <%}%>
                                </tr>
                                <%}%>
                                <tr>

                                    <%--<tr>
                                                            <td CLASS="cell" bgcolor="#9B9B00" STYLE="border:1px solid #999; text-align:left;color:#333333;font-size:12;font:BOLD;" WIDTH="200"><b>Manufacturer / &#1575;&#1604;&#1605;&#1589;&#1606;&#1593;</b></td>
                                                            <td CLASS="cell" bgcolor="#EDEDED" STYLE="border:1px solid #999; text-align:center;font-size:12;font:BOLD;"><%=equipmentWBO.getAttribute("manufacturer")%></td>
                                                        </tr>--%>
                                    <%--
                                                    <tr>
                                                        <td CLASS="cell" bgcolor="#9B9B00" STYLE="border:1px solid #999; text-align:left;color:#333333;font-size:12" WIDTH="200"><b>Notes / &#1605;&#1604;&#1575;&#1581;&#1592;&#1575;&#1578;</b></td>
                                                        <td CLASS="cell" bgcolor="#EDEDED" STYLE="border:1px solid #999; text-align:center;font-size:12;font:BOLD;"><%=eqSupWBO.getAttribute("note")%></td>
                                                    </tr>

                                        <tr>
                                            <td CLASS="cell" bgcolor="#808000" STYLE="border:1px solid #999; text-align:center;color:#333333;font-size:14" COLSPAN="2">
                                                <b>Warranty Data / &#1576;&#1610;&#1575;&#1606;&#1575;&#1578; &#1575;&#1604;&#1590;&#1605;&#1575;&#1606;</b>
                                            </td>
                                        </tr>

                                        <!--tr>
                                            <td CLASS="cell" bgcolor="#9B9B00" STYLE="border:1px solid #999; text-align:left;color:#333333;font-size:12" WIDTH="200"><b>Supplier / &#1575;&#1604;&#1605;&#1608;&#1585;&#1583;</b></td>
                                        <td CLASS="cell" bgcolor="#EDEDED" STYLE="border:1px solid #999; text-align:center;font-size:12"><%//=supWBO.getAttribute("name")%></td>
                                        </tr>

                                        <tr>
                                            <td CLASS="cell" bgcolor="#9B9B00" STYLE="border:1px solid #999; text-align:left;color:#333333;font-size:12" WIDTH="200"><b>Contractor  / &#1575;&#1604;&#1605;&#1578;&#1593;&#1575;&#1602;&#1583;</b></td>
                                        <td CLASS="cell" bgcolor="#EDEDED" STYLE="border:1px solid #999; text-align:center;font-size:12"><%//=contEmpWBO.getAttribute("empName")%></td>
                                        </tr-->

                                        <tr>
                                            <td CLASS="cell" bgcolor="#9B9B00" STYLE="border:1px solid #999; text-align:left;color:#333333;font-size:12" WIDTH="200"><b>Dealing Method / &#1591;&#1576;&#1610;&#1593;&#1577; &#1575;&#1604;&#1578;&#1593;&#1575;&#1605;&#1604;</b></td>
                                            <%if (eqSupWBO.getAttribute("warranty").equals("1")) {%>
                                            <td CLASS="cell" bgcolor="#EDEDED" STYLE="border:1px solid #999; text-align:center;font-size:12;font:BOLD;">Contract / &#1578;&#1593;&#1575;&#1602;&#1583;</td>
                                            <%} else {%>
                                            <td CLASS="cell" bgcolor="#EDEDED" STYLE="border:1px solid #999; text-align:center;font-size:12;font:BOLD;">Warranty / &#1590;&#1605;&#1575;&#1606;</td>
                                            <%}%>
                                        </tr>

                                        <tr>
                                            <%if (eqSupWBO.getAttribute("warranty").equals("1")) {%>
                                            <td CLASS="cell" bgcolor="#9B9B00" STYLE="border:1px solid #999; text-align:left;color:#333333;font-size:12;font:BOLD;" WIDTH="200"><b>Contract Begin Date / &#1578;&#1600;&#1575;&#1585;&#1610;&#1600;&#1582; &#1576;&#1600;&#1583;&#1575;&#1610;&#1600;&#1607;&nbsp;&#1575;&#1604;&#1600;&#1578;&#1600;&#1593;&#1600;&#1575;&#1602;&#1600;&#1583;</b></td>
                                            <%} else {%>
                                            <td CLASS="cell" bgcolor="#9B9B00" STYLE="border:1px solid #999; text-align:left;color:#333333;font-size:12;font:BOLD;" WIDTH="200"><b>Warranty Begin Date / &#1578;&#1600;&#1575;&#1585;&#1610;&#1600;&#1582; &#1576;&#1600;&#1583;&#1575;&#1610;&#1600;&#1607;&nbsp;&#1575;&#1604;&#1600;&#1590;&#1600;&#1605;&#1600;&#1575;&#1606;</b></td>
                                            <%}%>
                                            <td CLASS="cell" bgcolor="#EDEDED" STYLE="border:1px solid #999; text-align:center;font-size:12;font:BOLD;"><%=dateAcquired.substring(0, 10)%></td>
                                        </tr>

                                        <tr>
                                            <%if (eqSupWBO.getAttribute("warranty").equals("1")) {%>
                                            <td CLASS="cell" bgcolor="#9B9B00" STYLE="border:1px solid #999; text-align:left;color:#333333;font-size:12;font:BOLD;" WIDTH="200"><b>Contract Date / &#1578;&#1600;&#1575;&#1585;&#1610;&#1600;&#1582; &#1606;&#1600;&#1607;&#1600;&#1575;&#1610;&#1600;&#1607; &#1575;&#1604;&#1600;&#1578;&#1600;&#1593;&#1600;&#1575;&#1602;&#1600;&#1583;</b></td>
                                            <%} else {%>
                                            <td CLASS="cell" bgcolor="#9B9B00" STYLE="border:1px solid #999; text-align:left;color:#333333;font-size:12;font:BOLD;" WIDTH="200"><b>Warranty Date / &#1578;&#1575;&#1585;&#1610;&#1582; &#1606;&#1607;&#1575;&#1610;&#1577; &#1575;&#1604;&#1590;&#1605;&#1575;&#1606;</b></td>
                                            <%}%>
                                            <td CLASS="cell" bgcolor="#EDEDED" STYLE="border:1px solid #999; text-align:center;font-size:12;font:BOLD;"><%=expiryDate.substring(0, 10)%></td>
                                        </tr>

                                    --%>
                            </table></td>
                    </tr>
                </table>
                <p>&nbsp;</p>
            </center>
            <br>               
            <%} else if (imagePath.size() > 0) {%>
            <div class="gallery" style="background-color: #C0D9DE">    
             
                    <%for (int i = 0; i < imagePath.size(); i++) {
                    %>

                    <a rel="gallery_group" href="<%=imagePath.get(i).toString()%>" title="Image 1"><img style="width: 100px;height: 100px;margin: 5px; float: left;" src="<%=imagePath.get(i).toString()%>" alt="" /></a>                    <%
                        }%>
                <br class="clear" /> 
            </div>

            <%} else {
            %>


            <img name='docImage' alt='document image' src='images/no_image.jpg' >


            <%        }
            %>


     
    </center>
</BODY>
</HTML>     
