<%@page import="com.Erp.db_access.CostCentersMgr"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.quality_assurance.db_accesss.GenericApprovalStatusMgr"%>
<%@page import="com.customization.model.Customization"%>
<%@page import="com.customization.common.CustomizeEquipmentMgr"%>
<%@ page import="com.docviewer.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.db_access.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.docviewer.db_access.DocTypeMgr"%>
<%@ page import="com.contractor.db_access.MaintainableMgr, com.maintenance.db_access.*, com.tracker.db_access.*, com.silkworm.persistence.relational.Row"%>  
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page pageEncoding="UTF-8" %>

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
    FixedAssetsDataMgr assetsDataMgr = FixedAssetsDataMgr.getInstance();
    SupplierEquipmentMgr equipSupMgr = SupplierEquipmentMgr.getInstance();
    EquipOperationMgr eqpOpMgr = EquipOperationMgr.getInstance();
    AverageUnitMgr averageUnitMgr = AverageUnitMgr.getInstance();

    String context = metaMgr.getContext();

    WebBusinessObject equipmentWBO = (WebBusinessObject) maintainableMgr.getOnSingleKey((String) request.getAttribute("equipID"));
    WebBusinessObject wboTemp = maintainableMgr.getOnSingleKey(equipmentWBO.getAttribute("parentId").toString());
    WebBusinessObject deptWBO = deptMgr.getOnSingleKey(equipmentWBO.getAttribute("department").toString());
   // WebBusinessObject productionLineWBO = productionLineMgr.getOnSingleKey(equipmentWBO.getAttribute("productionLine").toString());
   
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

    //check if the equipment in approval table or no 
    boolean flag = false;
    GenericApprovalStatusMgr genericApprovalStatusMgr = GenericApprovalStatusMgr.getInstance();
    WebBusinessObject Approval = null;
    Approval = genericApprovalStatusMgr.getOnSingleKey1(equipmentID);
    if (Approval != null) {
        flag = true;
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
    String moveEqp, Equipment_Approval, Approved,updateReading,farm,sector,attachedEqp;
    String resetCounter;
    if (stat.equals("En")) {
        align = "center";
        dir = "LTR";
        style = "text-align:left";
        lang = "   &#1593;&#1585;&#1576;&#1610;    ";
        langCode = "Ar";
        farm="branch";
        sector="main";
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
        Equipment_Approval = "Equipment Approval";
        Approved = "Equipment Approved ";
        updateReading="update Current reading";
        attachedEqp="attached equipment";
        resetCounter="reset counter";
    } else {
        align = "center";
        dir = "RTL";
        style = "text-align:Right";
        lang = "English";
        langCode = "En";
        farm="الفرعى";
        sector="الرئيسى";
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
        Equipment_Approval = "&#1605;&#1591;&#1575;&#1576;&#1602;&#1577; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;";
        Approved = "&#1578;&#1605;&#1578; &#1575;&#1604;&#1605;&#1591;&#1575;&#1576;&#1602;&#1607";
        updateReading="تحديث القراءة";
        attachedEqp="الحاق معدة فرعية";
        resetCounter="&#1578;&#1589;&#1601;&#1610;&#1585; &#1575;&#1604;&#1593;&#1583;&#1575;&#1583;";
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
    function openWindowEquip(url)
            {
                window.open(url,"_blank","toolbar=no, location=no, directories=no, status=yes, menubar=no, scrollbars=yes, resizable=no, copyhistory=no, width=750, height=400");
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
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
          <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css">
	<script src="jquery-ui/jquery-1.7.1.js"></script>
	<script src="jquery-ui/ui/jquery.ui.core.js"></script>
	<script src="jquery-ui/ui/jquery.ui.widget.js"></script>
	<script src="jquery-ui/ui/jquery.ui.tabs.js"></script>
	 <LINK REL="stylesheet" TYPE="text/css" HREF="jquery-ui/demos/demos.css">
        <script type="text/javascript" src=""></script>
        <script type="text/javascript" src="js/stepcarousel.js">

            /***********************************************
             * Step Carousel Viewer script- (c) Dynamic Drive DHTML code library (www.dynamicdrive.com)
             * Visit http://www.dynamicDrive.com for hundreds of DHTML scripts
             * This notice must stay intact for legal use
             ***********************************************/

        </script>
<script>
	$(function() {
		$( "#xxx" ).tabs();
	});
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
                overflow: hidden; /*clip content that go outside dimensions of holding panel div*/
                margin: 10px; /*margin around each panel*/
                width: 250px; /*Width of each panel holding each content. If removed, widths should be individually defined on each content div then. */
            }

        </style>

    </HEAD>

    <BODY onload='setupPanes("container1", "tab1");'>

        <script type="text/javascript">

            stepcarousel.setup({
                galleryid: 'mygallery', //id of carousel div
                beltclass: 'belt', //class of inner "belt" div containing all the panel DIVs
                panelclass: 'panel', //class of panel DIVs each holding content
                autostep: {enable:true, moveby:1, pause:3000},
                panelbehavior: {speed:500, wraparound:false, persist:true},
                defaultbuttons: {enable: false, moveby: 1, leftnav: ['images/317e0s5.gif', -5, 80], rightnav: ['images/33o7di8.gif', -20, 80]},
                statusvars: ['statusA', 'statusB', 'statusC'], //register 3 variables that contain current panel (start), current panel (last), and total panels
                contenttype: ['inline'] //content setting ['inline'] or ['external', 'path_to_external_file']
            })

        </script>

        <div  align="left" STYLE="white-space: nowrap; color:blue;">

            <button onclick="changePage('<%=url%>')" class="homebutton"><%=back%> <IMG VALIGN="BOTTOM"   SRC="images/diary16.gif" WIDTH="20" HEIGHT="16"> </button>

        </div>

        <BR>

        <div>
            <table align="center" border="0" width="100%">
                <tr>
                    <td STYLE="border:0px;">
                        <div STYLE="margin: auto; width:75%;border:2px solid gray;background-color:#92a7b8;color:white;" bgcolor="#F3F3F3" align="center">
                            <div ONCLICK="JavaScript: changeMode('menu3');" STYLE="width:100%;background-color:#92a7b8;color:white;cursor:hand;font-size:16;">
                                <b>
                                    <%=Indicators%>
                                </b>
                                <img src="images/arrow_down.gif">
                            </div>
                            <div ALIGN="center" STYLE="width:100%;background-color:#FFFFCC;color:white;display:block;<%=style%>;border-top:2px solid gray;" ID="menu3">
                                <table align="center" border="0" dir="<%=dir%>" width="100%" cellspacing="2">
                                    <tr>
                                        <td CLASS="indicator" bgcolor="white" STYLE="<%=style%>;" width="33%"><img src="images/red_font.JPG" border="0" alt="<%=red_font_tib%>"><b>&nbsp;&nbsp;<font color="red"><%=red_font%></font></b></td>
                                        <td CLASS="indicator" bgcolor="white" STYLE="<%=style%>;"><img src="images/black_font.JPG" border="0" alt="<%=black_font_tib%>"><b>&nbsp;&nbsp;<%=black_font%></b></td>
                                    </tr>
                                    <tr>
                                        <td CLASS="indicator" bgcolor="white" STYLE="<%=style%>;" width="33%"><img src="images/workingEq.gif" width="40" height="30" border="0" alt="<%=workingEq_tip%>"><b>&nbsp;&nbsp;<font color="red"><%=workingEq%></font></b></td>
                                        <td CLASS="indicator" bgcolor="white" STYLE="<%=style%>;"><img src="images/stoppedEq.gif" width="30" height="30" border="0" alt="<%=stoppedEq_tip%>"><b>&nbsp;&nbsp;<%=stoppedEq%></b></td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </td>
                </tr>
            </table>

            <table BORDER="0" ALIGN="CENTER" WIDTH="80%">
                <tr>
                    <td STYLE="border:0px" WIDTH="30%" VALIGN="top">
                        <div STYLE="width:100%;border:2px solid gray;background-color:#92a7b8;color:white;">
                            <div ONCLICK="JavaScript: changeMode('menu1');" STYLE="width:100%;background-color:#92a7b8;color:white;cursor:hand;font-size:14;">
                                <b>&#1593;&#1605;&#1604;&#1610;&#1575;&#1578; &#1605;&#1588;&#1575;&#1607;&#1583;&#1577; / Viewing Operations</b> <img src="images/arrow_down.gif">
                            </div>

                            <div ALIGN="right" STYLE="width:100%;background-color:#FFFFCC;color:black;display:block;text-align:right;" ID="menu1">
                                <table border="0" cellpadding="0" cellspacing="3" width="100%" >
                                    <tr>
                                        <td class="silver_odd" style="border:1px solid silver;cursor:hand;color:white;" width="33%" bgcolor="white" >
                                            <a href="<%=context%>/ScheduleServlet?op=ListEqpSchedules&amp;source=other&amp;equipment=<%=equipmentWBO.getAttribute("id").toString()%>">
                                                <font color="black"> <b><%=jobOrders%></b></font>
                                            </a>
                                        </td>
                                        <%
                                            if (vecChanges.size() > 0) {
                                        %>
                                        <td class="silver_odd" style="border:1px solid silver;cursor:hand;color:white;" width="33%" bgcolor="white" >
                                            <a href="<%=context%>/EquipmentServlet?op=ListChanges&equipmentID=<%=equipmentID%>&action=view">
                                                <font color="black"> <b><%=viewChanges%></b></font>
                                            </a>
                                        </td>
                                        <%
                                        } else {
                                        %>
                                        <td class="silver_odd" style="border:1px solid silver;color:white;" width="33%" bgcolor="white" >
                                            <font color="black">  <b><%=noChanges%></b></font>
                                        </td>
                                        <%
                                            }
                                        %>
                                        <%
                                            if (unitDocMgr.hasDocuments(equipmentID)) {
                                        %>
                                        <td class="silver_odd" style="border:1px solid silver;cursor:hand;color:white;" width="33%" bgcolor="white" >
                                            <a href="<%=context%>/UnitDocReaderServlet?op=ListDoc&equipmentID=<%=equipmentID%>">
                                                <font color="black"> <b><%=viewFiles%></b></font>
                                            </a>
                                        </td>
                                        <%
                                        } else {
                                        %>
                                        <td class="silver_odd" style="border:1px solid silver;color:white;" width="33%" bgcolor="white">
                                            <font color="black"><b><%=noFiles%></b></font>
                                        </td>
                                        <%
                                            }
                                        %>
                                    </tr>

                                    <tr>
                                        <td class="silver_odd" style="border:1px solid silver;cursor:hand;color:white;" width="33%" bgcolor="#bbbccc" >
                                            <a href="<%=context%>/EquipmentServlet?op=ListJobOrders&equipmentID=<%=equipmentID%>">
                                                <font color="black"><b><%=jobOrdersDates%></b></font>
                                            </a>
                                        </td>
                                        <td class="silver_odd" style="border:1px solid silver;cursor:hand;color:white;" width="33%" bgcolor="#bbbccc" >
                                            <a href="<%=context%>/EqStateTypeServlet?op=ViewStatusHistory&equipmentID=<%=equipmentID%>">
                                                <font color="black"><b><%=changesDates%></b></font>
                                            </a>
                                        </td>
                                        <%if (equipmentWBO.getAttribute("rateType").equals("By Hour")) {%>
                                        <td class="silver_odd" style="border:1px solid silver;color:white;cursor:hand;" width="33%" bgcolor="#bbbccc">
                                            <a href="<%=context%>/AverageUnitServlet?op=ListAverageUnitForm&equipmentID=<%=equipmentID%>&currentMode=<%=cMode%>">
                                                <font color="black"> <b><%=listHours%></b></font>
                                            </a>
                                        </td>
                                        <%} else {%>
                                        <td class="silver_odd" style="border:1px solid silver;color:white;cursor:hand;" width="33%" bgcolor="#bbbccc" >
                                            <a href="<%=context%>/AverageUnitServlet?op=ListAverageKelUnitForm&equipmentID=<%=equipmentID%>&currentMode=<%=cMode%>">
                                                <font color="black"> <b><%=listKm%></b></font>
                                            </a>
                                        </td>
                                        <%}%>
                                    </tr>
                                    <tr>
                                        <td class="silver_odd" style="border:1px solid silver;color:white;cursor:hand;" width="33%"   bgcolor="#ffff00">
                                            <a href="<%=context%>/EquipmentServlet?op=ListEquipmentSuppliers&equipmentID=<%=equipmentID%>&currentMode=<%=cMode%>">
                                                <font color="black"><b><%=sSupplierList%></b></font></a>
                                        </td>
                                        <%try{
                                            ArrayList clientList = (ArrayList)request.getAttribute("clientName");
                                            String clientid = ((WebBusinessObject)clientList.get(0)).getAttribute("id").toString();

                                            %>
                                       
                                        <td class="silver_odd" style="border:1px solid silver;color:black;cursor:hand;" width="33%" bgcolor="#ffff00" >
                                            <a href="#" onclick="openWindowEquip('<%=context%>/ClientServlet?op=ViewClient&clientID=<%=clientid%>')" >
                                            <font color="black"><b>Client information / &#1576;&#1610;&#1575;&#1606;&#1575;&#1578; &#1575;&#1604;&#1593;&#1605;&#1610;&#1604;</b></font></a>
                                        </td>
                                        <%}catch(Exception e){%>
                                          <td style="border:1px solid silver;color:black;cursor:hand;" width="33%" bgcolor="#ffff00" >
                                            <font color="black"><b>No Client</b></font>
                                        </td>
                                        <%}%>

                                        <%//} else {%>
                                        <%--
                                        <td style="border:1px solid blue;color:black;cursor:hand;" width="33%" bgcolor="#ffff00">
                                            <a href="<%=context%>/SupplementServlet?op=viewAttachedHistory&equipmentID=<%=equipmentID%>&currentMode=<%=cMode%>&ismain=notmain">
                                            <font color="black"> <b><%=viewAttachedHistory%></b></font></a>
                                        </td>
                                        --%>
                                        <%//}%>
                                        <td class="silver_odd" style="border:1px solid silver;color:black;cursor:hand;" width="33%" bgcolor="#ffff00" >
                                            <a href="<%=context%>/DriverHistoryServlet?op=ListAttachDriverForm&equipmentID=<%=equipmentID%>&currentMode=<%=cMode%>">
                                                <font color="black"> <b><%=listAttachedDriver%></b></font>
                                            </a>
                                        </td>

                                    </tr>
                                    <tr>
                                        <td class="silver_odd" style="border:1px solid silver;color:white;cursor:hand;" width="33%"   >
                                            <a href="<%=context%>/EquipmentServlet?op=getPrintEqpForm&equipmentID=<%=equipmentID%>&currentMode=<%=cMode%>">
                                                <font color="black"> <b><%=printPreview%></b></font>
                                            </a>
                                        </td>
                                        <%if (warrantyData.size() > 0) {%>
                                        <td class="silver_odd" style="border:1px solid silver;color:black;cursor:hand;" width="33%" bgcolor="#ffff00" onclick="JavaScript: changePage('')">
                                            <a href="<%=context%>/EquipmentServlet?op=viewWarrantyData&equipmentID=<%=equipmentID%>&currentMode=<%=cMode%>">
                                                <font color="black"> <b><%=viewWarrantyData%></b></font>
                                            </a>
                                        </td>
                                        <%} else {%>
                                        <td class="silver_odd" style="border:1px solid silver;color:black;" width="33%" bgcolor="#ffff00" >
                                            <font color="red"><b><%=noWarrantyData%></b></font>
                                        </td>
                                        <%}%>
                                        <td class="silver_odd" style="border:1px solid silver;color:black;cursor:hand;" width="33%"   >
                                            <a href="<%=context%>/EqpMoveHistoryServlet?op=viewHistory&equipmentID=<%=equipmentID%>&unitName=<%=equipmentWBO.getAttribute("unitName")%>">
                                                <font color="black"> <b><%=eqpHistory%></b></font>
                                            </a>
                                        </td>

                                    </tr>
                                </table>
                            </div>
                        </div>
                    </td>
                    <td STYLE="border:0px" WIDTH="30%" VALIGN="top">
                        <div STYLE="width:100%;border:2px solid gray;background-color:#92a7b8;color:white;">
                            <div ONCLICK="JavaScript: changeMode('menu2');" STYLE="width:100%;background-color:#92a7b8;color:white;cursor:hand;font-size:14;">
                                <b>&#1593;&#1605;&#1604;&#1610;&#1575;&#1578; &#1573;&#1590;&#1575;&#1601;&#1577; / Addition Operations</b> <img src="images/arrow_down.gif">
                            </div>

                            <div ALIGN="right" STYLE="width:100%;background-color:#FFFFCC;color:black;display:none;text-align:right;" ID="menu2">
                                <table border="0" cellpadding="0" cellspacing="3" width="100%" bgcolor="#FFFFCC">
                                    <tr>
                                        <td class="silver_odd" style="border:1px solid silver;cursor:hand;color:white;" width="33%" bgcolor="white" >
                                            <a href="<%=context%>/ScheduleServlet?op=BindSingleSchedUnit&equipmentID=<%=equipmentID%>">
                                                <font color="black"> <b><%=assignSchedule%></b></font>
                                            </a>
                                        </td>
                                        <td class="silver_odd" style="border:1px solid silver;cursor:hand;color:white;" width="33%" bgcolor="white" >
                                            <a href="<%=context%>/EquipmentServlet?op=GetChangeForm&equipmentID=<%=equipmentID%>">
                                                <font color="black"> <b><%=eqpChanges%></b></font>
                                            </a>
                                        </td>
                                        <td class="silver_odd" style="border:1px solid silver;cursor:hand;color:white;" width="33%" bgcolor="white" >
                                            <a href="<%=context%>/UnitDocWriterServlet?op=SelectFile&equipmentID=<%=equipmentID%>">
                                                <font color="black"><b><%=attachDoc%></b></font>
                                            </a>
                                        </td>
                                    </tr>

                                    <tr>
                                        <%--
                                        <td class="silver_odd" style="border:1px solid silver;color:white;cursor:hand;" width="33%"   bgcolor="#bbbccc" >
                                            <a href="<%=context%>/EqpMoveHistoryServlet?op=MoveForm&equipmentID=<%=equipmentID%>&location=<%=locationWBO.getAttribute("projectID")%>" >
                                                <font color="black"><b><%=moveEqp%></b></font>
                                            </a>
                                        </td>--%>
                                        <td class="silver_odd" style="border:1px solid silver;cursor:hand;color:white;" width="33%" bgcolor="#bbbccc" >
                                            <a href="<%=context%>/EqStateTypeServlet?op=ChangeStatusForm&equipmentID=<%=equipmentID%>&currentStatus=<%=currentStatus%>">
                                                <font color="black"><b><%=changeStatus%></b></font>
                                            </a>
                                        </td>
                                        <%if (equipmentWBO.getAttribute("rateType").equals("By Hour")) {%>
                                        <td class="silver_odd" style="border:1px solid silver;color:white;cursor:hand;" width="33%" bgcolor="#bbbccc" >
                                            <%-- <a href="<%=context%>/AverageUnitServlet?op=UpdateAverageUnitForm&equipmentID=<%=equipmentID%>&currentMode=<%=cMode%>">--%>
                                            <a href="<%=context%>/HoursWorkingEquipmentServlet?op=getUpdateHoursEquipmentForm&unitId=<%=equipmentID%>&currentMode=<%=cMode%>&backto=viewEquipment">

                                                <font color="black"> <b><%=updateHours%></b></font>
                                            </a>
                                        </td>
                                        <%} else {%>
                                        <td class="silver_odd" style="border:1px solid silver;color:white;cursor:hand;" width="33%" bgcolor="#ffff00" >
                                            <%--<a href="<%=context%>/AverageUnitServlet?op=UpdateAverageKelUnitForm&equipmentID=<%=equipmentID%>&currentMode=<%=cMode%>">--%>
                                            <a href="<%=context%>/HoursWorkingEquipmentServlet?op=getUpdateKiloEquipmentForm&equipmentID=<%=equipmentID%>&currentMode=<%=cMode%>&backto=viewEquipment">
                                                <font color="black"><b><%=updateKm%></b></font>
                                            </a>
                                        </td>
                                        <%}%>
                                    </tr>
                                    <tr>

                                        <%//if (equipmentWBO.getAttribute("isStandalone").equals("1")) {
%>
                                        <td class="silver_odd" style="border:1px solid silver;color:white;cursor:hand;" width="33%" bgcolor="#ffff00" >
                                            <%--  <a href="<%=context%>/DriverHistoryServlet?op=GetAttachDriverForm&equipmentID=<%=equipmentID%>&currentMode=<%=cMode%>"> --%>
                                           <a  href="#" onclick="openWindowEquip('AverageUnitServlet?op=upDateCurrentReadingPupop&equipmentID=<%=equipmentID%>&currentMode=<%=cMode%>&reset=reset')">
                                            <font color="black"> <b><%=resetCounter%> <%//=attachDriver%></b></font>
                                            </a>
                                            <%-- </a> --%>
                                        </td>
                                        <%//} else {%>
                                        <!--td style="border:1px solid black;color:white;" width="33%" bgcolor="#ffff00">
                                        <font color="red"> <b><%=attachDriver%></b></font>
                                        </td-->
                                        <%//}%>



                                        <%
                                            //if (attachFlag == 1) {
                                        %>
                                        <td class="silver_odd" style="border:1px solid silver;color:white;cursor:hand;" width="33%" bgcolor="#ffff00" >
                                            <%--  <a href="<%=context%>/SupplementServlet?op=GetSeparateEqForm&EID=<%=equipmentID%>&currentMode=<%=cMode%>">  --%>
                                            <a  href="#" onclick="openWindowEquip('AverageUnitServlet?op=upDateCurrentReadingPupop&equipmentID=<%=equipmentID%>&currentMode=<%=cMode%>')">
                                            <font color="black">        <b> <%=updateReading%></b></font>
                                            <%--   </a>  --%>
                                        </a>
                                        </td>
                                        <%//} else {%>
                                        <%--
                                        <td style="border:1px solid blue;color:white;cursor:hand;" width="33%" bgcolor="#ffff00" >
                                            <font color="red"> <b><%=sSeparateEquipment%></b></font>
                                        </td>
                                        --%>
                                        <%//}%>



                                        <%//if (equipmentWBO.getAttribute("isStandalone").equals("1")) {
                                            // if (attachFlag == 0) {
                                        %>
                                        <td class="silver_odd" style="border:1px solid silver;color:white;cursor:hand;" width="33%" bgcolor="#ffff00">
                                            <%--   <a href="<%=context%>/SupplementServlet?op=GetAttachEqForm&equipmentID=<%=equipmentID%>&currentMode=<%=cMode%>">  --%>
                                            <a href="#" onclick="openWindowEquip('EquipmentServlet?op=attachedEqptoMainEqp&equipmentID=<%=equipmentID%>&currentMode=<%=cMode%>')">
                                            <font color="black">  <b> <%=attachedEqp%></b></font>
                                            </a>
                                            <%--  </a>  --%>
                                        </td>
                                        <%//} else {%>
                                        <%--
                                        <td style="border:1px solid blue;color:white;" width="33%" bgcolor="#ffff00">
                                            <font color="red"> <b><%=sAttachEquipment%></b></font>
                                        </td>

                                        <%//}
//} else {%>
                                        <td style="border:1px solid blue;color:white;" width="33%" bgcolor="#ffff00">
                                            <font color="red"> <b><%=sAttachEquipment%></b></font>
                                        </td>
                                        --%>
                                        <%//}%>
                                    </tr>
                                    <tr>
                                        <td class="silver_odd" style="border:1px solid silver;color:white;cursor:hand;" width="33%"   bgcolor="#bbbccc" >
                                            <%if (flag == false) {%>
                                            <a href="<%=context%>/GenericApprovalStatusServlet?op=EquipmentAppovalForm&equipmentID=<%=equipmentID%>&source=viewImages&currentMode=<%=cMode%>">
                                                <font color="black"><b><%=Equipment_Approval%></b></font> 
                                            </a>
                                            <%} else {%>
                                            <a href="<%=context%>/GenericApprovalStatusServlet?op=EquipmentAppovalForm&equipmentID=<%=equipmentID%>&source=viewImages&currentMode=<%=cMode%>">
                                                <font color="black"><b><%=Approved%></b></font>

                                            </a>
                                            <%}%>
                                        </td>
                                        </td>
                                        <td class="silver_odd" style="border:1px solid silver;color:white;cursor:hand;" width="33%"   bgcolor="#bbbccc" >
                                            <a href="<%=context%>/ScheduleServlet?op=no&unitName=<%=equipmentID%>&source=viewImages&currentMode=<%=cMode%>">
                                                <font color="black"><b><%=Emergency%></b></font>
                                            </a>
                                        </td>

                                        <td class="silver_odd" style="border:1px solid silver;color:white;cursor:hand;" width="33%"   bgcolor="#bbbccc" >
                                            <a href="<%=context%>/EquipmentServlet?op=GetSupplierForm&equipmentID=<%=equipmentID%>&currentMode=<%=cMode%>">
                                                <font color="black"> <b><%=sSupplier%></b></font>
                                            </a>
                                        </td>

                                    </tr>
                                    <%--
                                    <tr>
                                        <td style="border:1px solid blue;color:white;cursor:hand;" width="33%"   bgcolor="#bbbccc" >
                                            &nbsp;
                                        </td>

                                        <td style="border:1px solid blue;color:white;cursor:hand;" width="33%"   bgcolor="#bbbccc" >
                                            <a href="<%=context%>/EquipmentServlet?op=getmanufForm&equipmentID=<%=equipmentID%>&currentMode=<%=cMode%>">
                                                <font color="black"> <b><%=manufData%></b></font>
                                            </a>
                                        </td>
                                        <td style="border:1px solid blue;color:white;cursor:hand;" width="33%"   bgcolor="#bbbccc" >
                                            <a href="<%=context%>/EquipmentServlet?op=getEqpOperationForm&equipmentID=<%=equipmentID%>&currentMode=<%=cMode%>">
                                                <font color="black"> <b><%=addEqpOperation%></b></font>
                                            </a>
                                        </td>
                                    </tr>
                                    --%>



                                </table>
                            </div>
                        </div>
                    </td>


                    <%--   <td STYLE="border:0px" WIDTH="30%" VALIGN="top">
                    <div STYLE="width:100%;border:2px solid gray;background-color:#92a7b8;color:white;">
                        <div ONCLICK="JavaScript: changeMode('menu3');" STYLE="width:100%;background-color:#92a7b8;color:white;cursor:hand;font-size:14;">
                            <b>&#1575;&#1604;&#1605;&#1585;&#1588;&#1583; &#1575;&#1604;&#1605;&#1589;&#1608;&#1585; / Indicators Guide</b> <img src="images/arrow_down.gif">
                        </div>

                        <div STYLE="width:100%;background-color:#FFFFCC;color:black;display:none;" ID="menu3">
                            <table border="0" cellpadding="0" cellspacing="3" width="100%" bgcolor="#FFFFCC">
                                <tr>
                                    <td style="border:1px solid blue;color:white;text-align:right;" width="100%" bgcolor="white">
                                        <%
                                        if (tempWbo != null) {
    if (tempWbo.getAttribute("stateID").equals("1")) {
                                        %>
                                        <font color="black"> <b>Working Equipment / &#1605;&#1593;&#1583;&#1607; &#1578;&#1593;&#1605;&#1604;</b> </font><img src="images/good.jpg" border="0"  alt="Poor Status">
                                        <%
                                        } else {
                                        %>
                                        <font color="black"> <b>Out of Work Equipment / &#1605;&#1593;&#1583;&#1607; &#1604;&#1575;&#1578;&#1593;&#1605;&#1604;</b> </font><img src="images/ungood.jpg" border="0"  alt="Poor Status">
                                        <%
                                        }
                                        } else {
                                        %>
                                        <font color="black"><b>Out of Work Equipment / &#1605;&#1593;&#1583;&#1607; &#1604;&#1575;&#1578;&#1593;&#1605;&#1604;</b></font> <img src="images/ungood.jpg" border="0"  alt="Poor Status">
                                        <%
                                        }
                                        %>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="border:1px solid blue;color:white;text-align:right;" width="100%" bgcolor="#bbbccc">
                                        <%
                                        String imgName = new String("");
                                        String eqStatus = new String("");
                                        if (equipmentWBO.getAttribute("status").equals("100%")) {
                                            imgName = "green.gif";
                                            eqStatus = "Excellent Status / &#1605;&#1605;&#1578;&#1575;&#1586;&#1607;";
                                        } else if (equipmentWBO.getAttribute("status").equals("75%")) {
                                            imgName = "yellow.gif";
                                            eqStatus = "Good Status / &#1580;&#1610;&#1583;&#1607;";
                                        } else {
                                            imgName = "red.gif";
                                            eqStatus = "Poor Status / &#1585;&#1583;&#1610;&#1574;&#1607;";
                                        }
                                        %>
                                        <font color="black"> <b><%=eqStatus%></b></font> <img src="images/<%=imgName%>" border="0">
                                    </td>
                                </tr>
                                <tr>
                                    <td style="border:1px solid blue;color:white;text-align:right;" width="100%" bgcolor="white">
                                        <%
                                        if (active) {
                                        %>
                                        <font color="black"><b>Active Equipment / &#1605;&#1593;&#1583;&#1577; &#1605;&#1585;&#1578;&#1576;&#1591;&#1577; &#1576;&#1571;&#1605;&#1585; &#1588;&#1594;&#1604;</b></font> <IMG SRC="images/active.jpg" ALT="Active Equipment" ALIGN="center">
                                        <%
                                        } else {
                                        %>
                                        <font color="black"> <b>Non Active Equipment / &#1605;&#1593;&#1583;&#1577; &#1594;&#1610;&#1585; &#1605;&#1585;&#1578;&#1576;&#1591;&#1577; &#1576;&#1571;&#1605;&#1585; &#1588;&#1594;&#1604;</b></font> <IMG SRC="images/nonactive.jpg" ALT="Non Active Equipment" ALIGN="center">
                                        <%
                                        }
                                        %>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </td>
                    --%>
                </tr>



                <%  Vector attachedVector = new Vector();
                    attachedVector = maintainableMgr.getCheckAttachedEq(equipmentWBO.getAttribute("maintTypeId").toString());

                    if (attachedVector.size() > 0) {%>
                <%--
                <td STYLE="border:0px" WIDTH="20%" VALIGN="top">
                    <div STYLE="width:100%;border:2px solid gray;background-color:blue;color:white;">
                        <div ONCLICK= "JavaScript:changeMode('menu0');" STYLE="width:80%;background-color:blue;color:white;cursor:hand;font-size:14;">
                            <b>&#1573;&#1583;&#1575;&#1585;&#1577; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607; / Equibment Management</b> <img src="images/arrow_down.gif">
                        </div>

                            <div ALIGN="right" STYLE="width:100%;background-color:#FFFFCC;color:black;display:block;text-align:right;" ID="menu0">
                                <table border="0" cellpadding="0" cellspacing="3" width="100%" bgcolor="#FFFFCC">
                                    <tr>
                                        <td style="border:1px solid blue;color:white;" width="25%" bgcolor="white" >
                                            <a href="<%=context%>/SupplementServlet?op=viewAttachedHistory&equipmentID=<%=equipmentID%>&currentMode=<%=cMode%>&ismain=main">
                                            <font color="black">  <b> <%=listPart%></b></font>
                                            </a>
                                        </td>
                                       <% if(equipmentWBO.getAttribute("attachedEqId") != null && !equipmentWBO.getAttribute("attachedEqId").equals("")){ %>

                                        <td style="border:1px solid blue;cursor:hand;color:white;" width="25%" bgcolor="white" >
                                              <a href="<%=context%>/SupplementServlet?op=GetSeparateEqForm&EID=<%=equipmentID%>&currentMode=<%=cMode%>">
                                              <font color="black"> <b><%=disConnPart%></b></font>
                                              </a>
                                        </td>
                                        <% } else { %>

                                       <td style="border:1px solid blue;cursor:hand;color:white;" width="25%" bgcolor="white" >
                                              <a href="<%=context%>/SupplementServlet?op=GetAttachEqForm&equipmentID=<%=equipmentID%>&currentMode=<%=cMode%>">
                                              <font color="black"> <b><%=connPart%></b></font>
                                              </a>
                                        </td>
                                        <% } %>

                                        <td style="border:1px solid blue;cursor:hand;color:white;" width="25%" bgcolor="white" >
                                            <font color="black"> <b><%=changeDriver%></b></font>
                                        </td>



                                        <td style="border:1px solid blue;cursor:hand;color:white;" width="25%" bgcolor="white" >
                                              <font color="black"> <b><%=putDriver%></b></font>
                                       </td>

                                    </tr>

                                </table>
                            </div>
                        </div>
                    </td>
                --%>
                <% }%>


                <td STYLE="border:0px" WIDTH="30%" VALIGN="top">
                    <div STYLE="width:100%;border:2px solid gray;background-color:#92a7b8;color:white;">
                        <div ONCLICK="JavaScript: changeMode('menu4');" STYLE="width:100%;background-color:#92a7b8;color:white;cursor:hand;font-size:14;">
                            <b> &#1576;&#1600;&#1600;&#1610;&#1600;&#1600;&#1600;&#1575;&#1606;&#1600;&#1600;&#1600;&#1600;&#1600;&#1575;&#1578; &#1571;&#1590;&#1600;&#1575;&#1601;&#1600;&#1610;&#1600;&#1600;&#1600;&#1607; / Addition Data</b> <img src="images/arrow_down.gif">
                        </div>

                        <div ALIGN="right" STYLE="width:100%;background-color:#FFFFCC;color:black;display:block;text-align:right;" ID="menu4">
                            <table border="0" cellpadding="0" cellspacing="3" width="100%" bgcolor="#FFFFCC">
                                <tr>

                                    <%if (warrantyData.size() > 0) {%>
                                    <td style="border:1px solid silver;color:white;cursor:hand;" width="33%"   bgcolor="#bbbccc" >

                                        <a href="<%=context%>/EquipmentServlet?op=changeWarrantyData&equipmentID=<%=equipmentID%>&currentMode=<%=cMode%>">
                                            <font color="black"><b><%=WarrantyExist%></b></font>
                                        </a>
                                    </td>
                                    <%} else {%>
                                    <td style="border:1px solid silver;color:white;cursor:hand;" width="33%"   bgcolor="#bbbccc" >
                                        <a href="<%=context%>/EquipmentServlet?op=addWarrantyData&equipmentID=<%=equipmentID%>&currentMode=<%=cMode%>">
                                            <font color="black"><b><%=addWarrant%></b></font>
                                        </a>
                                    </td>
                                    <%}%>

                                    <td style="border:1px solid silver;color:white;cursor:hand;" width="33%"   bgcolor="#bbbccc" >
                                        <a href="<%=context%>/EquipmentServlet?op=getmanufForm&equipmentID=<%=equipmentID%>&currentMode=<%=cMode%>">
                                            <font color="black"> <b><%=manufData%></b></font>
                                        </a>
                                    </td>
                                    <td style="border:1px solid silver;color:white;cursor:hand;" width="33%"   bgcolor="#bbbccc" >
                                        <a href="<%=context%>/EquipmentServlet?op=getEqpOperationForm&equipmentID=<%=equipmentID%>&currentMode=<%=cMode%>">
                                            <font color="black"> <b><%=addEqpOperation%></b></font>
                                        </a>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </td>
                </tr>
            </table>


        </div>
        <br><br>

    <center>
        <fieldset align="center" class="set" >

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
            <center>


                <table width="
                       100%" cellpadding="0" cellspacing="0" align="center" style="border: 1px solid #000089" bgcolor="#E5E9F3">


                    <tr>
                        <td style="border: 1px solid #000089" >
                            <font color="red" size="3"> <b> <%=equipmentWBO.getAttribute("unitName")%></b></font>
                            <%if (flag == true) {%>
                            <img src="images/yes.jpg"></img>

                            <%}%>          

                        </td>
                    </tr>
                </table>
            </center>
            <br>

            <div class="demo" id="container1" style=" width:100%;text-align:left;">
            <!--    
                <ul id="tabs">
                    <table>
                        <tr>
                            <td>
                        <li style="border-right: 1px solid #194367;">
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

                                if (attachFlag == 1) {

                        %>

                        <td>
                        <li style="border-left: 1px solid #194367;">
                            <a href="#" onClick="return showPane('pane4', this)" id="tab4">&#1605;&#1604;&#1581;&#1602;&#1575;&#1578;<BR>Attached Equipment</a>
                        </li>
                        </td>

                        <%            }
                            }
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
                        <%        }
                        %>
                        </tr>
                    </table>
                </ul>
                        <br> -->
                        <div class="demo">

                            <div id="xxx" >
                                <ul >
            <li style="white-space: nowrap;height: 20px; color: red" ><a href="#tabs-1">تفاصيل المعدات/Equipment Details</a></li>
            <li style="white-space: nowrap;height: 20px;" ><a href="#tabs-2">صيانة 6 أشهر مستقبليه/Future 6 Months.Job Orders</a></li>
		<li style="white-space: nowrap;height: 20px;"><a href="#tabs-3">صيانة اخر 6 أشهر/Last 6 Months.Job Orders</a></li>
	</ul>
	<div id="tabs-1">
		<p>
                    <br>
                        <table  WIDTH="100%" CELLPADDING="0" CELLSPACING="0">
                            <tr>
                                <td >

                                    <table STYLE="border:1 solid black"  WIDTH="600" CELLPADDING="0" CELLSPACING="0">

                                        <tr VALIGN="MIDDLE">

                                            <td CLASS="silver_header" bgcolor="#9B9B00" STYLE="text-align:center;font-size:14" WIDTH="200"><b>Asset No / &#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1575;&#1603;&#1610;&#1606;&#1607;</b></td>

                                            <td CLASS="silver_header" bgcolor="#9B9B00" STYLE="text-align:center;font-size:14" WIDTH="200"><b>Model No / &#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1608;&#1583;&#1610;&#1604;</b></td>

                                            <td CLASS="silver_header" bgcolor="#9B9B00" STYLE="text-align:center;font-size:14" WIDTH="200"><b><%=tGuide.getMessage("equipmentname")%> / &#1573;&#1587;&#1605; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;</b></td>
                                        </tr>

                                        <tr VALIGN="MIDDLE">

                                            <td CLASS="silver_odd" bgcolor="#EEE8AA" STYLE="text-align:center;color:Blue;font-size:12"><b><font  size="3" ><%=equipmentWBO.getAttribute("unitNo")%></font></b></td>

                                            <td CLASS="silver_odd" bgcolor="#EEE8AA" STYLE="text-align:center;color:Blue;font-size:12"><b><font  size="3" ><%=equipmentWBO.getAttribute("modelNo")%></font></b></td>

                                            <td CLASS="silver_odd" bgcolor="#EEE8AA" STYLE="text-align:center;color:Blue;font-size:12"><b><font  size="3" ><%=equipmentWBO.getAttribute("unitName")%></font></b></td>
                                        </tr>

                                    </table>

                                    <br><br>
                                    <table  WIDTH="600" CELLPADDING="0" CELLSPACING="0">
                                        <tr>
                                            <td CLASS="silver_header" bgcolor="darkgoldenrod" STYLE="text-align:center;font-size:16" COLSPAN="3">
                                                <b>&#1602;&#1585;&#1575;&#1569;&#1607; &#1593;&#1583;&#1575;&#1583; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577; / Equipment Counter Reading</b>
                                            </td>
                                        </tr>

                                        <tr>
                                            <td CLASS="silver_header" bgcolor="goldenrod" STYLE="text-align:center;font-size:14">
                                                <b>Previous Reading<br>&#1575;&#1604;&#1602;&#1585;&#1575;&#1569;&#1577; &#1575;&#1604;&#1587;&#1575;&#1576;&#1602;&#1577;</b>
                                            </td>
                                            <td CLASS="silver_header" bgcolor="goldenrod" STYLE="text-align:center;font-size:14">
                                                <b>Last Reading<br>&#1570;&#1582;&#1585; &#1602;&#1585;&#1575;&#1569;&#1577;</b>
                                            </td>
                                            <td CLASS="silver_header" bgcolor="goldenrod" STYLE="text-align:center;font-size:14">
                                                <b>Last Reading Date<br>&#1578;&#1575;&#1585;&#1610;&#1582; &#1570;&#1582;&#1585; &#1602;&#1585;&#1575;&#1569;&#1577;</b>
                                            </td>

                                        </tr>

                                        <tr>
                                            <%
                                                Vector items = averageUnitMgr.getOnArbitraryKey(equipmentID, "key1");
                                                if (items.size() > 0) {
                                                    for (int i = 0; i < items.size(); i++) {
                                                        WebBusinessObject wbo = (WebBusinessObject) items.elementAt(i);
                                                        WebBusinessObject categoryName = (WebBusinessObject) maintainableMgr.getOnSingleKey(wbo.getAttribute("unitName").toString());
                                                        String unit = "";
                                                        if (equipmentWBO.getAttribute("rateType").toString().equalsIgnoreCase("By K.M")) {
                                                            unit = "km";
                                                        } else {
                                                            unit = "hr";
                                                        }
                                            %>
                                            <td CLASS="silver_odd" bgcolor="#FFE391" STYLE="text-align:center;"><b><%=wbo.getAttribute("acual_Reading").toString()%>&nbsp;<%=unit%></b></td>
                                            <td CLASS="silver_odd" bgcolor="#FFE391" STYLE="text-align:center;"><b><%=wbo.getAttribute("current_Reading").toString()%>&nbsp;<%=unit%></b></td>
                                            <%
                                            try{
                                                Date d = Calendar.getInstance().getTime();
                                                String readingDate =(String)wbo.getAttribute("entry_Time");
                                                Long l = new Long(readingDate);
                                                long sl = l.longValue();
                                                d.setTime(sl);
                                                readingDate = d.toString();
                                                year = d.getYear() + 1900;
                                                mon = d.getMonth() + 1;
                                                day = d.getDate();
                                                readingDate = day + " / " + mon + " / " + year;
                                                //readingDate = readingDate.substring(0, 10) + readingDate.substring(24, 29);
                                             %>
                                            <td CLASS="silver_odd" bgcolor="#FFE391" STYLE="text-align:center;"><b><%=readingDate%></b></td>
                                            <%
                                            }catch(Exception e){
                                                System.out.println("Error"+e);
                                                }
                                            }} else {
                                            %>
                                            <td CLASS="silver_odd" bgcolor="#FFE391" STYLE="text-align:center;" COLSPAN="3">No Reading for this equipment <br> &#1604;&#1575;&#1610;&#1608;&#1580;&#1583; &#1602;&#1585;&#1575;&#1569;&#1577; &#1604;&#1607;&#1584;&#1607; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577;</td>
                                                <%        }
                                                %>
                                        </tr>
                                    </table>
                                </td>

                                <td CLASS="td" ALIGN="RIGHT">

                                    <%if (equipmentWBO.getAttribute("equipmentStatus").toString().equals("1")) {%>
                                    <img src="images/workingEq.gif">
                                    <%} else {%>
                                    <img src="images/stoppedEq.gif">
                                    <%}%>
                                    <br>
                                    <%--
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
                                    --%>
                                </td>
                            </tr>

                            <tr>
                                <td CLASS="silver_header">&nbsp;</td>
                                <td CLASS="silver_odd">&nbsp;</td>
                            </tr>

                            <tr>
                                <td CLASS="td">
                                    <table WIDTH="600" BORDER="0" CELLSPACING="0">
                                        <tr>
                                            <td CLASS="blueHeaderTD" bgcolor="#808000" STYLE="text-align:center;font-size:14" COLSPAN="2">
                                                <b>Basic Information / &#1575;&#1604;&#1576;&#1610;&#1575;&#1606;&#1575;&#1578; &#1575;&#1604;&#1571;&#1587;&#1575;&#1587;&#1610;&#1607;</b>
                                            </td>
                                        </tr>

                                        <tr>
                                            <td CLASS="silver_header" bgcolor="#9B9B00" STYLE="text-align:left;font-size:12" WIDTH="200"><b>Asset No / &#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1575;&#1603;&#1610;&#1606;&#1607;</b></td>
                                            <td CLASS="silver_odd" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12;font:BOLD;"><%=equipmentWBO.getAttribute("unitNo")%></td>
                                        </tr>

                                        <tr>
                                            <td CLASS="silver_header" bgcolor="#9B9B00" STYLE="text-align:left;font-size:12" WIDTH="200"><b><%=tGuide.getMessage("equipmentname")%> / &#1573;&#1587;&#1605; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;</b></td>
                                            <td CLASS="silver_odd" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12;font:BOLD;"><%=equipmentWBO.getAttribute("unitName")%></td>
                                        </tr>

                                        <tr>
                                            <td CLASS="silver_header" bgcolor="#9B9B00" STYLE="text-align:left;font-size:12" WIDTH="200"><b>Engine Number / &#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1581;&#1585;&#1603; / &#1575;&#1604;&#1588;&#1575;&#1587;&#1610;&#1607;</b></td>
                                            <td CLASS="silver_odd" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12;font:BOLD;"><%=equipmentWBO.getAttribute("engineNo")%></td>
                                        </tr>
                                        <%--
                                        <tr>
                                            <td CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><b>Auth. Employee / &#1575;&#1604;&#1605;&#1608;&#1592;&#1601; &#1575;&#1604;&#1605;&#1587;&#1574;&#1608;&#1604;</b></td>
                                            <td CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12;font:BOLD;"><%=empWBO.getAttribute("empName")%></td>
                                        </tr>
                                        --%>
                                       
                                        <tr>
                                            <td CLASS="silver_header" bgcolor="#9B9B00" STYLE="text-align:left;font-size:12" WIDTH="200"><b>Department / &#1575;&#1604;&#1602;&#1587;&#1605;</b></td>
                                            <td CLASS="silver_odd" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12;font:BOLD;"><%=deptWBO.getAttribute("departmentName")%></td>
                                        </tr>

                                      

                                        <tr>
                                            <td CLASS="silver_header" bgcolor="#9B9B00" STYLE="text-align:left;font-size:12" WIDTH="200"><b>Main Category / &#1575;&#1604;&#1606;&#1608;&#1593; &#1575;&#1604;&#1575;&#1587;&#1575;&#1587;&#1609;</b></td>
                                            <td CLASS="silver_odd" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12;font:BOLD;"><b><%=mainCatTypeWbo.getAttribute("typeName")%></b></td>
                                        </tr>

                                        <tr>
                                            <td CLASS="silver_header" bgcolor="#9B9B00" STYLE="text-align:left;font-size:12" WIDTH="200"><b>Model/Brand/Year  / &#1575;&#1604;&#1605;&#1575;&#1585;&#1603;&#1607;/&#1575;&#1604;&#1605;&#1608;&#1583;&#1610;&#1604;/&#1587;&#1606;&#1577; &#1575;&#1604;&#1578;&#1589;&#1606;&#1610;&#1593; </b></td>
                                            <td CLASS="silver_odd" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12;font:BOLD;"><b><%=wboTemp.getAttribute("unitName")%></b></td>
                                        </tr>

                                        <tr>
                                            <td CLASS="silver_header" bgcolor="#9B9B00" STYLE="text-align:left;font-size:12;font:BOLD;" WIDTH="200"><b>Status / &#1575;&#1604;&#1581;&#1575;&#1604;&#1607;</b></td>
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
                                            <td CLASS="silver_odd" DIR="RTL" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12;font:BOLD;">
                                                <%=status%>&nbsp;&nbsp;
                                                <%=byPrecentage%>&nbsp;&nbsp;
                                                <%=equipmentWBO.getAttribute("statusValue").toString()%>
                                            </td>
                                        </tr>

                                        <tr>
                                            <td CLASS="silver_header" bgcolor="#9B9B00" STYLE="text-align:left;font-size:12" WIDTH="200"><b>Is Standalone / &#1578;&#1593;&#1605;&#1604; &#1576;&#1605;&#1601;&#1585;&#1583;&#1607;&#1575;</b></td>
                                            <td CLASS="silver_odd" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12;font:BOLD;"><% if (equipmentWBO.getAttribute("isStandalone").equals("1")) {%>&#1606;&#1593;&#1605;<%} else {%> &#1604;&#1575;<%}%></td>
                                        </tr>

                                        <tr>
                                            <td CLASS="silver_header" bgcolor="#9B9B00" STYLE="text-align:left;font-size:12" WIDTH="200"><b>Service Entry Date / &#1583;&#1582;&#1608;&#1604; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607; &#1575;&#1604;&#1582;&#1583;&#1605;&#1607;</b></td>
                                            <td CLASS="silver_odd" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12;font:BOLD;">
                                                <%=(String) equipmentWBO.getAttribute("serviceEntryDATE")%>
                                            </td>
                                        </tr>

                                        <tr>
                                            <td CLASS="silver_header" bgcolor="#9B9B00" STYLE="text-align:left;font-size:12" WIDTH="200"><b><%=tGuide.getMessage("equipmentdescription")%> / &#1608;&#1589;&#1601; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;</b></td>
                                            <td CLASS="silver_odd" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12;font:BOLD;"><%=equipmentWBO.getAttribute("desc")%></td>
                                        </tr>
                                        <%if (eqpOpVector.size() > 0) {%>
                                        <tr>
                                            <td CLASS="blueHeaderTD" bgcolor="#808000" STYLE="text-align:center;color:white;font-size:14" COLSPAN="2">
                                                <b>Operation Data / &#1576;&#1610;&#1575;&#1606;&#1575;&#1578; &#1575;&#1604;&#1593;&#1605;&#1604;</b>
                                            </td>
                                        </tr>

                                        <tr>
                                            <td CLASS="silver_header" bgcolor="#9B9B00" STYLE="text-align:left;font-size:12" WIDTH="200"><b>Equipment Type / &#1606;&#1608;&#1593; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;</b></td>
                                            <%if (equipmentWBO.getAttribute("rateType").toString().equalsIgnoreCase("By Hour")) {%>
                                            <td CLASS="silver_odd" bgcolor="darkkhaki" STYLE="text-align:center;font-size:12;font:BOLD;"><b><%=eqType_continues%></b></td>
                                            <%} else {%>
                                            <td CLASS="silver_odd" bgcolor="darkkhaki" STYLE="text-align:center;font-size:12;font:BOLD;"><b><%=eqType_odometer%></b></td>
                                            <%}%>
                                        </tr>

                                        <tr>
                                            <td CLASS="silver_header" bgcolor="#9B9B00" STYLE="text-align:left;font-size:12" WIDTH="200"><b>Operation Type / &#1606;&#1608;&#1593; &#1575;&#1604;&#1593;&#1605;&#1604;</b></td>
                                            <%if (eqpOpWbo.getAttribute("operation_type").toString().equalsIgnoreCase("Countinous")) {%>
                                            <td CLASS="silver_odd" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12;font:BOLD;"><%=Countinous%></td>
                                            <%} else {%>

                                            <td CLASS="silver_odd" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12;font:BOLD;"><%=By_Order%></td>
                                            <%}%>
                                        </tr>

                                        <tr>
                                            <td CLASS="silver_header" bgcolor="#9B9B00" STYLE="text-align:left;font-size:12" WIDTH="200"><b>Average / &#1575;&#1604;&#1605;&#1578;&#1608;&#1587;&#1591;</b></td>
                                            <%if (equipmentWBO.getAttribute("rateType").toString().equalsIgnoreCase("By Hour")) {%>
                                            <td CLASS="silver_odd" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12;font:BOLD;"><%=eqpOpWbo.getAttribute("average")%> Hours.</td>
                                            <%} else {%>
                                            <td CLASS="silver_odd" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12;font:BOLD;"><%=eqpOpWbo.getAttribute("average")%> K.M.</td>
                                            <%}%>
                                        </tr>
                                        <%}%>
                                        <tr>
                                            <td CLASS="blueHeaderTD" bgcolor="#808000" STYLE="text-align:center;color:white;font-size:14" COLSPAN="2">
                                                <b>Manufacturing Data / &#1576;&#1610;&#1575;&#1606;&#1575;&#1578; &#1575;&#1604;&#1578;&#1589;&#1606;&#1610;&#1593;</b>
                                            </td>
                                        </tr>

                                        <%--<tr>
                                            <td CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12;font:BOLD;" WIDTH="200"><b>Manufacturer / &#1575;&#1604;&#1605;&#1589;&#1606;&#1593;</b></td>
                                            <td CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12;font:BOLD;"><%=equipmentWBO.getAttribute("manufacturer")%></td>
                                        </tr>--%>

                                        <tr>
                                            <td CLASS="silver_header" bgcolor="#9B9B00" STYLE="text-align:left;font-size:12" WIDTH="200"><b>Model No / &#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1608;&#1583;&#1610;&#1604;</b></td>
                                            <td CLASS="silver_odd" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12;font:BOLD;"><%=equipmentWBO.getAttribute("modelNo")%></td>
                                        </tr>

                                        <tr>
                                            <td CLASS="silver_header" bgcolor="#9B9B00" STYLE="text-align:left;font-size:12" WIDTH="200"><b>Serial No / &#1575;&#1604;&#1587;&#1585;&#1610;&#1575;&#1604;</b></td>
                                            <td CLASS="silver_odd" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12;font:BOLD;"><%=equipmentWBO.getAttribute("serialNo")%></td>
                                        </tr>
                                        <tr>
                                            <td CLASS="blueHeaderTD"  STYLE="text-align:center;color:white;font-size:14" COLSPAN="2">
                                                <b>Client information / &#1576;&#1610;&#1575;&#1606;&#1575;&#1578; &#1575;&#1604;&#1593;&#1605;&#1610;&#1604;</b>
                                            </td>
                                        </tr>
                                         <%
                                        try{
                                            ArrayList clientList = (ArrayList)request.getAttribute("clientName");
                                            String clientName = ((WebBusinessObject)clientList.get(0)).getAttribute("name").toString();
                                          
                                        %>
                                        
                                        <tr>
                                            <td CLASS="silver_header" bgcolor="#9B9B00" STYLE="text-align:left;font-size:14" WIDTH="200"><b>Client name / &#1573;&#1587;&#1605; &#1575;&#1604;&#1593;&#1605;&#1610;&#1604;</b></td>
                                            <td CLASS="silver_odd" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12"><%=clientName%></td>
                                        </tr>
                                        <%}catch(Exception e){%>
                                            <tr>
                                            <td CLASS="silver_header" bgcolor="#9B9B00" STYLE="text-align:left;font-size:14" WIDTH="200"><b>Client name / &#1573;&#1587;&#1605; &#1575;&#1604;&#1593;&#1605;&#1610;&#1604;</b></td>
                                            <td CLASS="silver_odd" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12">........</td>
                                        </tr>
                                            <%}%>
                                        <%--
                                    <tr>
                                        <td CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><b>Notes / &#1605;&#1604;&#1575;&#1581;&#1592;&#1575;&#1578;</b></td>
                                        <td CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12;font:BOLD;"><%=eqSupWBO.getAttribute("note")%></td>
                                    </tr>

                                        <tr>
                                            <td CLASS="cell" bgcolor="#808000" STYLE="text-align:center;color:white;font-size:14" COLSPAN="2">
                                                <b>Warranty Data / &#1576;&#1610;&#1575;&#1606;&#1575;&#1578; &#1575;&#1604;&#1590;&#1605;&#1575;&#1606;</b>
                                            </td>
                                        </tr>

                                        <!--tr>
                                            <td CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><b>Supplier / &#1575;&#1604;&#1605;&#1608;&#1585;&#1583;</b></td>
                                        <td CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12"><%//=supWBO.getAttribute("name")%></td>
                                        </tr>

                                        <tr>
                                            <td CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><b>Contractor  / &#1575;&#1604;&#1605;&#1578;&#1593;&#1575;&#1602;&#1583;</b></td>
                                        <td CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12"><%//=contEmpWBO.getAttribute("empName")%></td>
                                        </tr-->

                                        <tr>
                                            <td CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><b>Dealing Method / &#1591;&#1576;&#1610;&#1593;&#1577; &#1575;&#1604;&#1578;&#1593;&#1575;&#1605;&#1604;</b></td>
                                            <%if (eqSupWBO.getAttribute("warranty").equals("1")) {%>
                                            <td CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12;font:BOLD;">Contract / &#1578;&#1593;&#1575;&#1602;&#1583;</td>
                                            <%} else {%>
                                            <td CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12;font:BOLD;">Warranty / &#1590;&#1605;&#1575;&#1606;</td>
                                            <%}%>
                                        </tr>

                                        <tr>
                                            <%if (eqSupWBO.getAttribute("warranty").equals("1")) {%>
                                            <td CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12;font:BOLD;" WIDTH="200"><b>Contract Begin Date / &#1578;&#1600;&#1575;&#1585;&#1610;&#1600;&#1582; &#1576;&#1600;&#1583;&#1575;&#1610;&#1600;&#1607;&nbsp;&#1575;&#1604;&#1600;&#1578;&#1600;&#1593;&#1600;&#1575;&#1602;&#1600;&#1583;</b></td>
                                            <%} else {%>
                                            <td CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12;font:BOLD;" WIDTH="200"><b>Warranty Begin Date / &#1578;&#1600;&#1575;&#1585;&#1610;&#1600;&#1582; &#1576;&#1600;&#1583;&#1575;&#1610;&#1600;&#1607;&nbsp;&#1575;&#1604;&#1600;&#1590;&#1600;&#1605;&#1600;&#1575;&#1606;</b></td>
                                            <%}%>
                                            <td CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12;font:BOLD;"><%=dateAcquired.substring(0, 10)%></td>
                                        </tr>

                                        <tr>
                                            <%if (eqSupWBO.getAttribute("warranty").equals("1")) {%>
                                            <td CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12;font:BOLD;" WIDTH="200"><b>Contract Date / &#1578;&#1600;&#1575;&#1585;&#1610;&#1600;&#1582; &#1606;&#1600;&#1607;&#1600;&#1575;&#1610;&#1600;&#1607; &#1575;&#1604;&#1600;&#1578;&#1600;&#1593;&#1600;&#1575;&#1602;&#1600;&#1583;</b></td>
                                            <%} else {%>
                                            <td CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12;font:BOLD;" WIDTH="200"><b>Warranty Date / &#1578;&#1575;&#1585;&#1610;&#1582; &#1606;&#1607;&#1575;&#1610;&#1577; &#1575;&#1604;&#1590;&#1605;&#1575;&#1606;</b></td>
                                            <%}%>
                                            <td CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12;font:BOLD;"><%=expiryDate.substring(0, 10)%></td>
                                        </tr>

                                        --%>
                                          <tr>
                                            <td CLASS="blueHeaderTD"  STYLE="text-align:center;color:white;font-size:14" COLSPAN="2">
                                                <b>Informations from Assets / بيانات من الإصــــــــول</b>
                                            </td>
                                        </tr>
                                       
                                       
                                        <tr>
                                            <td CLASS="silver_header" bgcolor="#9B9B00" STYLE="text-align:left;font-size:14" WIDTH="200"><b>Cost Center / مركز التكلفة</b></td>
                                            <%
                                            CostCentersMgr costCentersMgr = CostCentersMgr.getInstance();
                                            try{
                                            String costName = "";
                                            if(!equipmentWBO.getAttribute("productionLine").equals("")&&!equipmentWBO.getAttribute("productionLine").equals("0")){
                                                costName = costCentersMgr.getCostCenterNameByCode((String)equipmentWBO.getAttribute("productionLine"),"Ar");
                                                if(costName.equals("***")){
                                                    costName="\u0644\u0627 \u064A\u0648\u062C\u062F";
                                                }
                                            }else{
                                                costName="\u0644\u0627 \u064A\u0648\u062C\u062F";
                                            }
                        
                                            %>
                                           
                                            <td CLASS="silver_odd" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12"><%=costName%></td>
                                           
                                            <%}catch(Exception e){%>
                                             <td CLASS="silver_odd" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12">غير متاح</td>
                                            <%}%>
                                        </tr>
                                        <tr>
                                            <td CLASS="silver_header" bgcolor="#9B9B00" STYLE="text-align:left;font-size:14" WIDTH="200"><b>Employee Name / إسم عامل المعدة</b></td>
                                             <%
                                            try{
                                            String empId = equipmentWBO.getAttribute("empID").toString();
                                            EmpBasicMgr basicMgr = EmpBasicMgr.getInstance();
                                             String empName = basicMgr.getEmployeeName(empId) ;       %>
                                             <td CLASS="silver_odd" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12"><%=empName%></td>
                                            <%}catch(Exception e){%>
                                            <td CLASS="silver_odd" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12">غير متاح</td>
                                            <%}%>
                                        </tr>
                                       
                                            
                                              <%
                                            try{
                                            WebBusinessObject projectWbo =null ;
                                            String loc = equipmentWBO.getAttribute("site").toString();
                                            if(!loc.equals("NON")){
                                                projectWbo =  (WebBusinessObject) projectMgr.getOnSingleKey(loc);
                                                if(projectWbo.getAttribute("mainProjId").equals("0")){
                                                %>
                                                 <tr>
                                                <td CLASS="silver_header" bgcolor="#9B9B00" STYLE="text-align:left;font-size:14" WIDTH="200"><b>Location / الموقع</b></td>
                                                <td CLASS="silver_odd" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12"><b> <font size="2">
                                                        <%=projectWbo.getAttribute("projectName").toString()%><font color="blue" size="3" style="<%=style%>"> : <%=sector%></font>
                                                    </font>
                                                    </b></td>
                                                 </tr>
                                                <%
                                                }else{
                                                    Vector parentSite = projectMgr.getOnArbitraryKey(projectWbo.getAttribute("mainProjId").toString(), "key");
                                                   // String parentSiteAndBra=projectWbo.getAttribute("projectName").toString()+" / "+((WebBusinessObject)parentSite.get(0)).getAttribute("projectName");
                                                    %>
                                                     <tr>
                                                <td CLASS="silver_header" bgcolor="#9B9B00" STYLE="text-align:left;font-size:14" WIDTH="200"><b>Main Site / الموقع الرئيسى</b></td>

                                                    <td CLASS="silver_odd" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12"><b> <font size="2">
                                                               <font color="blue" size="3" style="<%=style%>"> <%=((WebBusinessObject)parentSite.get(0)).getAttribute("projectName")%></font>
                                                            </font>
                                                        </b></td>
                                                     </tr>
                                                <tr>
                                                <td CLASS="silver_header" bgcolor="#9B9B00" STYLE="text-align:left;font-size:14" WIDTH="200"><b>branch Site / الموقع الفرعى</b></td>
                                                
                                                    <td CLASS="silver_odd" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12"><b> <font size="2">
                                                               <font color="blue" size="3" style="<%=style%>"><%=projectWbo.getAttribute("projectName").toString()%></font>
                                                            </font>
                                                        </b></td>
                                                     </tr>

                                               %>
                                            <%}}else{%>
                                             <tr>
                                                <td CLASS="silver_header" bgcolor="#9B9B00" STYLE="text-align:left;font-size:14" WIDTH="200"><b>Location / الموقع</b></td>

                                            <td CLASS="silver_odd" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12">غير متاح</td>
                                             </tr>
                                            <%}}catch(Exception e){%>
                                             <tr>
                                                <td CLASS="silver_header" bgcolor="#9B9B00" STYLE="text-align:left;font-size:14" WIDTH="200"><b>Location / الموقع</b></td>

                                             <td CLASS="silver_odd" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12">غير متاح</td>
                                             </tr>
                                             <%}%>
                                    </table>
                                </td>
                                <td CLASS="td3">
                                    <table>
                                        <%
                                            if (wboTemp.getAttribute("unitName").toString().equals("Lorry")) {%>
                                        <tr>
                                            <td class='td3'>
                                                <img name='LorryImage' alt='Lorry image' src='images/lorry.jpg'  width="250" height="200">
                                            </td>
                                        </tr>
                                        <% } else if (wboTemp.getAttribute("unitName").toString().equals("Trailer")) {%>

                                        <tr>
                                            <td class='td3'>
                                                <img name='TrailerImage' alt='Trailer image' src='images/trailer.jpg'  width="250" height="200">
                                            </td>
                                        </tr>
                                        <% }%>
                                        <%
                                            if (imagePath.size() > 0) {%>
                                        <tr>
                                            <td class='td3'>
                                                <div  class="stepcarousel" id="mygallery">
                                                    <div class="belt">

                                                        <%for (int i = 0; i < imagePath.size(); i++) {
                                                        %>
                                                        <div class="panel" >
                                                            <img   name='docImage' alt='document image' src='<%=imagePath.get(i).toString()%>'  width="250" height="180"/>
                                                        </div>
                                                        <%
                                                            }%>
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                        <%} else {
                                        %>
                                        <tr>
                                            <td class='td'>
                                                <img name='docImage' alt='document image' src='images/no_image.jpg' border="2">
                                            </td>
                                        </tr>
                                        <%        }
                                        %>
                                    </table>
                                </td>
                            </tr>
                        </table>
                        <br>
                </p>
	</div>
    <div id="tabs-2" >
		<BR><BR>
           <jsp:include page="/docs/equipment/future_maintenance.jsp" flush="true" />
	</div>
	<div id="tabs-3">
		<BR><BR>
                        <jsp:include page="/docs/equipment/last_maintenance.jsp" flush="true" />
	</div>
</div>

</div><!-- End demo -->

            </div>
            <br>
            
        </fieldset>
    </center>
</BODY>
</HTML>     
