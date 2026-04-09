
<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*, com.tracker.common.*, java.util.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants"%>
<%@ page import="com.silkworm.common.TimeServices"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="com.tracker.common.*,com.silkworm.util.*,com.maintenance.db_access.*"%>
<%@ page import="com.tracker.engine.IssueStatusFactory, com.tracker.engine.*,com.docviewer.db_access.*"%>

<HTML>
    <%
    UserMgr userMgr = UserMgr.getInstance();
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
    ImageMgr imageMgr = ImageMgr.getInstance();
    IssueMgr issueMgr = IssueMgr.getInstance();
    
    String message = (String) request.getAttribute("message");
    
    
    AttachedIssuesMgr attachedIssuesMgr = AttachedIssuesMgr.getInstance();
    Vector vecParent = attachedIssuesMgr.getOnArbitraryKey(request.getParameter("issueId"), "key2");
    
    String issueId = (String) request.getAttribute("issueId");
    
    String filterBack = "ListDoc";
    String equipmentID = (String) request.getAttribute("equipmentID");
    String projectname = (String) request.getAttribute("projectName");
    String MaintenanceTitle = (String) request.getAttribute("mainTitle");
    WebBusinessObject wbo = (WebBusinessObject) request.getAttribute("wbo");
    String stat = (String) request.getSession().getAttribute("currentMode");
    String currentStatus = new String("");
    if (wbo.getAttribute("currentStatus") != null) {
        currentStatus = (String) wbo.getAttribute("currentStatus");
    }
    
    String  actualBeginDatebyTime = (String) request.getAttribute("actualBeginDate");
    
    UnitScheduleMgr unitScheduleMgr=UnitScheduleMgr.getInstance();
    //WebBusinessObject unitWbo = unitScheduleMgr.getOnSingleKey(wbo.getAttribute("unitScheduleID").toString());
    WebBusinessObject unitWbo = (WebBusinessObject)request.getAttribute("unitWbo");
    String eqpName = (String) unitWbo.getAttribute("unitName");
    
    
    String filterValue="";
    String filterName="searchbyid";
    String align = null;
    String dir = null;
    String style = null;
    String orderStatus="";
    String lang, langCode, sTitle, sCancel;
    String BackToList, viewDetails, indGuid, viewOP, plusOp, MNumber, jobFor, RcievedBy, Workorder, ViewMaintenance,
            Failure_Code, Site_Name, Urgency_Level, Estimated_Duration, Job_Type, CreatedBy, current_status,
            creationTime, assignedby, Problem_Description, finishedtime, expectededate, expectedB, schduled, sConversionDate, sConversionReason,
            Begined, Finished, Canceled, Holded, Rejected, Edite, add_task, attach_file, noFiles, view_spar, View_task, sAddWorkers, sWorkersReport, sCantChange, sExternalMessage, sReceivedBY,
            View_file, View_hist, View_jop, status, viewEquipment, excel, groupname, shiftname, sChangeDateHistory, sChangeExternal, addJobTeam, addInstructions, addTaskbyJob, addParts, itemStore,
            sCantAddTask,unitName, actualBDate,notStarted, sCantAddPart,siteTime,sitEntryDate, complaint, sCantAddWorkers, sStoreRequest, sTransactionList, fontSize, laborComplaint, sAttachIssue, sLaborCost, sPartCost, sViewAttached, sAttachJobOrder,NotFinishTime,statusDateJobOrder,fieldSetTitle;
    String compose="";
    if (stat.equals("En")) {
        
        align = "center";
        dir = "LTR";
        style = "text-align:left";
        lang = "   &#1593;&#1585;&#1576;&#1610;    ";
        langCode = "Ar";
        sCancel = "Cancel";
        sTitle = "Task Name";
        plusOp = "Addition Operations";
        viewOP = " Viewing Operations";
        /*****************************************/
        complaint = "View Complaints";
        fontSize = "11";
        dir = "LTR";
        style = "text-align:left";
        lang = "   &#1593;&#1585;&#1576;&#1610;    ";
        langCode = "Ar";
        excel = "Excel";
        BackToList = "Back to list";
        indGuid = " Indicators guide ";
        viewDetails = "View Job Order Details";
        plusOp = "Addition Operations";
        viewOP = " Viewing Operations";
        MNumber = "Job Order Number";
        jobFor = "Job Order for machine";
        RcievedBy = "Received by";
        Workorder = "Work Order Trade";
        Failure_Code = "Failure Code";
        Site_Name = " Site Name";
        Urgency_Level = "Urgency Level";
        Estimated_Duration = " Estimated Duration/Hours ";
        Job_Type = "Job Type";
        CreatedBy = "Created By";
        current_status = " Current Status";
        creationTime = "Creation Time";
        assignedby = "Assinged By";
        Problem_Description = "Problem Description";
        finishedtime = "Finished Time/hours ";
        expectededate = "Expected Finish Date";
        expectedB = "Expected Begine Date";
        schduled = "Scheduled";
        Begined = "Started";
        Finished = "Finished";
        Canceled = "Canceled";
        Holded = "on Hold";
        Rejected = "Rejected";
        Edite = "Edit";
        add_task = "Adding Maintenance Item";
        sCantAddTask = "Can't Add<br>Maintenance Item";
        attach_file = "Attaching File";
        noFiles = "No Attached Files";
        view_spar = "View Spare parts";
        View_task = "View Task";
        View_file = "View Attached Files";
        View_hist = "View task history";
        View_jop = "View Jop order";
        status = "Status";
        viewEquipment = "View Equipment";
        groupname = "Created By";
        shiftname = "Shift";
        sChangeDateHistory = "Change Date History";
        sChangeExternal = "Change to External";
        addJobTeam = "Add Job Team";
        addInstructions = "Add Instructions for Task";
        addTaskbyJob = "Add Jobs For Task";
        sAddWorkers = "Add Workers";
        sCantAddWorkers = "Can't Add Workers";
        ViewMaintenance = "View Maintenance<br> Items & Jops";
        sWorkersReport = "Workers Report";
        sCantChange = "Can not Change";
        addParts = "Add Spare Parts";
        sCantAddPart = "Can't Add Spare<br>Parts";
        sExternalMessage = "This Job Order has been changed External";
        sReceivedBY = "To Importer";
        sConversionDate = "Conversion Date";
        sConversionReason = "Conversion Reason";
        itemStore = "Items Store Request";
        sStoreRequest = "Request from<br>the Store";
        sTransactionList = "View Transaction Status";
        laborComplaint = "Add Labor Compalint";
        sAttachIssue = "Attach Job Order";
        sLaborCost = "Labor Cost";
        sPartCost = "Part Cost";
        sViewAttached = "To view Attached Job Order press here";
        sAttachJobOrder = "Attach Job Order";
        NotFinishTime = "Has not been specified ";
        statusDateJobOrder="Status Date";
        fieldSetTitle="View Job Order Details";
        unitName="Job Order for machine";
        sitEntryDate="Site Entry Date";
        siteTime="Enter time ";
        actualBDate="Actual Beginning Date";
        notStarted="This Order Not Started Yet";
        /*****************************************/
    } else {
        
        align = "center";
        dir = "RTL";
        style = "text-align:Right";
        lang = "English";
        langCode = "En";
        sCancel = tGuide.getMessage("cancel");
        plusOp = "&#1593;&#1605;&#1604;&#1610;&#1575;&#1578; &#1573;&#1590;&#1575;&#1601;&#1577;";
        viewOP = "&#1593;&#1605;&#1604;&#1610;&#1575;&#1578; &#1605;&#1588;&#1575;&#1607;&#1583;&#1577;";
        sTitle = "&#1573;&#1587;&#1605; &#1580;&#1583;&#1608;&#1604; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
        /***************************************************/
        compose = "&#1585;&#1576;&#1591; &#1575;&#1604;&#1588;&#1603;&#1575;&#1608;&#1609; &#1576;&#1576;&#1606;&#1608;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1607;";
        complaint = "&#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1575;&#1604;&#1588;&#1603;&#1575;&#1608;&#1610;";
        fontSize = "13";
        dir = "RTL";
        style = "text-align:Right";
        lang = "English";
        langCode = "En";
        excel = "&#1573;&#1603;&#1587;&#1600;&#1600;&#1604;";
        
        BackToList = "&#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1573;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577;";
        viewDetails = "&#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1578;&#1601;&#1575;&#1589;&#1610;&#1604; &#1571;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
        indGuid = "&#1575;&#1604;&#1605;&#1585;&#1588;&#1583; &#1575;&#1604;&#1605;&#1589;&#1608;&#1585;";
        plusOp = "&#1593;&#1605;&#1604;&#1610;&#1575;&#1578; &#1573;&#1590;&#1575;&#1601;&#1577;";
        viewOP = "&#1593;&#1605;&#1604;&#1610;&#1575;&#1578; &#1605;&#1588;&#1575;&#1607;&#1583;&#1577;";
        MNumber = "&#1585;&#1602;&#1605; &#1571;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
        jobFor = "&#1571;&#1605;&#1585; &#1588;&#1594;&#1604; &#1604;&#1605;&#1593;&#1583;&#1577;";
        RcievedBy = "&#1571;&#1587;&#1578;&#1604;&#1605; &#1576;&#1608;&#1575;&#1587;&#1591;&#1577;";
        Workorder = "&#1606;&#1608;&#1593; &#1571;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
        Failure_Code = "&#1603;&#1608;&#1583; &#1575;&#1604;&#1593;&#1591;&#1604;";
        Site_Name = "&#1573;&#1587;&#1605; &#1575;&#1604;&#1605;&#1608;&#1602;&#1593;";
        Urgency_Level = "&#1583;&#1585;&#1580;&#1577; &#1575;&#1604;&#1571;&#1607;&#1605;&#1610;&#1577;";
        Estimated_Duration = " &#1575;&#1604;&#1605;&#1583;&#1577; &#1575;&#1604;&#1605;&#1578;&#1608;&#1602;&#1593;&#1577; &#1576;&#1575;&#1604;&#1587;&#1575;&#1593;&#1577; ";
        Job_Type = "&#1606;&#1608;&#1593; &#1575;&#1604;&#1593;&#1605;&#1604;";
        CreatedBy = "&#1571;&#1606;&#1588;&#1571;&#1578; &#1576;&#1608;&#1575;&#1587;&#1591;&#1607;";
        current_status = " &#1575;&#1604;&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1581;&#1575;&#1604;&#1610;&#1577;";
        creationTime = "&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1575;&#1606;&#1588;&#1575;&#1569;";
        assignedby = "&#1587;&#1604;&#1605; &#1576;&#1608;&#1575;&#1587;&#1591;&#1577;";
        Problem_Description = "&#1608;&#1589;&#1601; &#1575;&#1604;&#1605;&#1588;&#1603;&#1604;&#1577;";
        finishedtime = " &#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1606;&#1607;&#1575;&#1610;&#1577; &#1575;&#1604;&#1601;&#1593;&#1604;&#1609;";
        expectededate = "&#1578;&#1600;&#1575;&#1585;&#1610;&#1582;&nbsp; &#1575;&#1604;&#1606;&#1607;&#1575;&#1610;&#1577; &#1575;&#1604;&#1605;&#1578;&#1608;&#1602;&#1593;";
        expectedB = "&#1575;&#1604;&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1605;&#1578;&#1608;&#1602;&#1593; &#1604;&#1604;&#1576;&#1583;&#1610;&#1607;";
        schduled = "&#1605;&#1580;&#1583;&#1608;&#1604;&#1577;";
        Begined = "&#1576;&#1583;&#1571;&#1578;";
        Finished = "&#1573;&#1606;&#1578;&#1607;&#1578;";
        Canceled = "&#1605;&#1604;&#1594;&#1575;&#1577;";
        Holded = "&#1605;&#1608;&#1602;&#1608;&#1601;&#1577;";
        Rejected = "&#1605;&#1585;&#1601;&#1608;&#1590;&#1577;";
        Edite = "&#1578;&#1581;&#1585;&#1610;&#1585;";
        add_task = "&#1573;&#1590;&#1575;&#1601;&#1607; &#1576;&#1606;&#1583; &#1589;&#1610;&#1575;&#1606;&#1607; ";
        sCantAddTask = "&#1604;&#1575; &#1610;&#1605;&#1603;&#1606; &#1573;&#1590;&#1575;&#1601;&#1607; &#1576;&#1606;&#1583; &#1589;&#1610;&#1575;&#1606;&#1607;";
        attach_file = "&#1573;&#1585;&#1601;&#1602; &#1605;&#1587;&#1578;&#1606;&#1583;";
        noFiles = "&#1604;&#1575; &#1610;&#1608;&#1580;&#1583; &#1605;&#1587;&#1578;&#1606;&#1583;&#1575;&#1578;";
        view_spar = "&#1605;&#1588;&#1575;&#1607;&#1583;&#1607; &#1602;&#1591;&#1593; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585;";
        View_task = "&#1605;&#1588;&#1575;&#1607;&#1583;&#1607; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607;";
        View_file = "&#1605;&#1588;&#1575;&#1607;&#1583;&#1607; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583;&#1575;&#1578;";
        
        View_jop = "&#1605;&#1588;&#1575;&#1607;&#1583;&#1607; &#1575;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
        View_hist = " &#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1575;&#1604;&#1578;&#1575;&#1585;&#1610;&#1582; ";
        status = "&#1575;&#1604;&#1581;&#1575;&#1604;&#1577;";
        viewEquipment = "&#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577;";
        groupname = "&#1571;&#1606;&#1588;&#1571;&#1578; &#1576;&#1608;&#1575;&#1587;&#1591;&#1607;";
        shiftname = "&#1575;&#1604;&#1608;&#1585;&#1583;&#1610;&#1577;";
        sChangeDateHistory = "&#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1578;&#1594;&#1610;&#1610;&#1585;&#1575;&#1578; &#1575;&#1604;&#1578;&#1575;&#1585;&#1610;&#1582;";
        sChangeExternal = "&#1578;&#1581;&#1608;&#1610;&#1604; &#1582;&#1575;&#1585;&#1580;&#1609;";
        addJobTeam = "&#1573;&#1590;&#1575;&#1601;&#1577; &#1605;&#1607;&#1606; &#1601;&#1585;&#1610;&#1602; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
        addInstructions = "&#1573;&#1590;&#1575;&#1601;&#1577; &#1573;&#1585;&#1588;&#1575;&#1583;&#1575;&#1578; &#1604;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
        addTaskbyJob = "&#1573;&#1590;&#1575;&#1601;&#1577; &#1575;&#1606;&#1608;&#1575;&#1593; &#1575;&#1604;&#1605;&#1607;&#1606; &#1604;&#1576;&#1606;&#1583; &#1589;&#1610;&#1575;&#1606;&#1577;";
        sAddWorkers = "&#1573;&#1590;&#1575;&#1601;&#1577; &#1593;&#1605;&#1575;&#1604;&#1577;";
        sCantAddWorkers = "&#1604;&#1575; &#1610;&#1605;&#1603;&#1606; &#1573;&#1590;&#1575;&#1601;&#1577; &#1593;&#1605;&#1575;&#1604;&#1577;";
        ViewMaintenance = "&#1605;&#1588;&#1575;&#1607;&#1583;&#1607; &#1576;&#1606;&#1608;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1607;";
        sWorkersReport = "&#1578;&#1602;&#1585;&#1610;&#1585; &#1575;&#1604;&#1593;&#1605;&#1575;&#1604;&#1577;";
        sCantChange = "&#1604;&#1575; &#1610;&#1605;&#1603;&#1606; &#1575;&#1604;&#1578;&#1581;&#1608;&#1610;&#1604;";
        addParts = "&#1573;&#1590;&#1575;&#1601;&#1577; &#1602;&#1591;&#1593; &#1594;&#1610;&#1575;&#1585;";
        sCantAddPart = "&#1604;&#1575; &#1610;&#1605;&#1603;&#1606; &#1573;&#1590;&#1575;&#1601;&#1577; &#1602;&#1591;&#1593; &#1594;&#1610;&#1575;&#1585;";
        sExternalMessage = "&#1578;&#1605; &#1578;&#1581;&#1608;&#1610;&#1604; &#1607;&#1584;&#1575; &#1575;&#1604;&#1571;&#1605;&#1585; &#1582;&#1575;&#1585;&#1580;&#1610;&#1575;&#1611;";
        sReceivedBY = " &#1604;&#1604;&#1605;&#1608;&#1585;&#1583;";
        sConversionDate = "&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1578;&#1581;&#1608;&#1610;&#1604;";
        sConversionReason = "&#1587;&#1576;&#1576; &#1575;&#1604;&#1578;&#1581;&#1608;&#1610;&#1604;";
        itemStore = "&#1591;&#1604;&#1576; &#1589;&#1585;&#1601; &#1605;&#1582;&#1575;&#1586;&#1606;";
        sStoreRequest = "&#1571;&#1591;&#1604;&#1576; &#1605;&#1606; &#1575;&#1604;&#1605;&#1582;&#1586;&#1606;";
        sTransactionList = "&#1593;&#1585;&#1590; &#1581;&#1575;&#1604;&#1577; &#1591;&#1604;&#1576;&#1575;&#1578; &#1575;&#1604;&#1605;&#1582;&#1575;&#1586;&#1606;";
        laborComplaint = "&#1575;&#1590;&#1575;&#1601;&#1577; &#1588;&#1603;&#1608;&#1609; &#1593;&#1575;&#1605;&#1604;";
        sAttachIssue = "&#1573;&#1604;&#1581;&#1575;&#1602; &#1571;&#1605;&#1585; &#1588;&#1594;&#1604;";
        sLaborCost = "&#1578;&#1603;&#1604;&#1601;&#1577; &#1575;&#1604;&#1593;&#1605;&#1575;&#1604;&#1577;";
        sPartCost = "&#1578;&#1603;&#1604;&#1601;&#1577; &#1602;&#1591;&#1593; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585;";
        sViewAttached = "&#1604;&#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1571;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604; &#1575;&#1604;&#1605;&#1585;&#1578;&#1576;&#1591; &#1576;&#1607; &#1571;&#1590;&#1594;&#1591; &#1607;&#1606;&#1575;";
        sAttachJobOrder = "&#1573;&#1604;&#1581;&#1575;&#1602; &#1571;&#1605;&#1585; &#1588;&#1594;&#1604;";
        NotFinishTime = "&#1604;&#1605; &#1578;&#1606;&#1578;&#1607;&#1609; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577; &#1604;&#1578;&#1581;&#1583;&#1610;&#1583; &#1605;&#1610;&#1593;&#1575;&#1583; &#1575;&#1604;&#1571;&#1606;&#1578;&#1607;&#1575;&#1569;";
        statusDateJobOrder = "&#1578;&#1608;&#1575;&#1585;&#1610;&#1582; &#1581;&#1575;&#1604;&#1577; &#1571;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
        fieldSetTitle="&#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1578;&#1601;&#1575;&#1589;&#1610;&#1604; &#1571;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
        unitName="&#1571;&#1605;&#1585; &#1588;&#1594;&#1604; &#1604;&#1605;&#1593;&#1583;&#1607;";
        sitEntryDate="&#1578;&#1575;&#1585;&#1610;&#1582; &#1583;&#1582;&#1608;&#1604; &#1575;&#1604;&#1608;&#1585;&#1588;&#1607;";
        siteTime="&#1608;&#1602;&#1578;&nbsp; &#1583;&#1582;&#1608;&#1604; &#1575;&#1604;&#1608;&#1585;&#1588;&#1607;";
        actualBDate="&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1576;&#1583;&#1575;&#1610;&#1607;&nbsp; &#1575;&#1604;&#1601;&#1593;&#1604;&#1609;";
        notStarted="&#1575;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604; &#1604;&#1605; &#1610;&#1576;&#1583;&#1571; &#1576;&#1593;&#1583;";
        /**************************************************/
    }
    
    
    %>
    
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>Doc Viewer- Select Project and Status</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <style type="text/css"> 
            <!-- 
            .tabs {position:relative; left: 5; top: 3; border:1px solid #194367; height: 50px; width: 650; margin: 0; padding: 0; background:#C0D9DE; overflow:hidden; } 
            .tabs li {display:inline} 
            .tabs a:hover, .tabs a.tab-active {background:#fff;} 
            .tabs a { height: 27px; font:11px verdana, helvetica, sans-serif;font-weight:bold; 
                position:relative; padding:6px 10px 10px 10px; margin: 0px -4px 0px 0px; color:#2B4353;text-decoration:none; } 
            .tab-container { background: #fff; border:0px solid #194367; height:320px; width:500px} 
            .tab-panes { margin: 3px; border:1px solid #194367; height:320px} 
            div.content { padding: 5px; }
        </style>
        <script language="JavaScript1.3"> 
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
            
        
        function changeMode(name){
            if(document.getElementById(name).style.display == 'none'){
                document.getElementById(name).style.display = 'block';
            } else {
            document.getElementById(name).style.display = 'none';
        }
    }
    function changePage(url){
        window.navigate(url);
    }
    function reloadAE(nextMode){
        
        var url = "<%=context%>/ajaxGetItrmName?key="+nextMode;
        if (window.XMLHttpRequest)
            { 
                req = new XMLHttpRequest(); 
            } 
            else if (window.ActiveXObject)
                { 
                    req = new ActiveXObject("Microsoft.XMLHTTP"); 
                } 
                req.open("Post",url,true); 
                req.onreadystatechange =  callbackFillreload;
                req.send(null);
                
            }
            
            function callbackFillreload(){
                if (req.readyState==4)
                    { 
                        if (req.status == 200)
                            { 
                                window.location.reload();
                            }
                        }
                    }
   
        </script>
    </HEAD>
    <SCRIPT language="JavaScript" type="text/javascript">
        function cancelForm()
        {    
            document.ISSUE_FORM.action = "main.jsp";
            document.ISSUE_FORM.submit();  
        }
    </SCRIPT>
    
    <script src='ChangeLang.js' type='text/javascript'></script>
    
    
    
    <BODY onload='setupPanes("container1", "tab1");'>
        
        <FORM NAME="ISSUE_FORM" METHOD="POST">
            
            <%--
            <table align="<%=align%>" dir="<%=dir%>" border="0" width="100%">
                <tr>                  
                    <TD STYLE="border:0px" width="34%"  VALIGN="top">
                        <DIV STYLE="width:100%;border:2px solid gray;background-color:#808000;color:white;">
                            <DIV ONCLICK="JavaScript: changeMode('menu2');" STYLE="width:100%;background-color:#808000;color:white;cursor:hand;font-size:16;">
                                <B> <B><%=plusOp%></B> <img src="images/arrow_down.gif">
                            </DIV>                            
                            <DIV ALIGN="<%=align%>" STYLE="width:100%;background-color:#FFFFCC;color:black;display:none;text-align:right;" ID="menu2">
                                <table border="0" cellpadding="0"  width="100%" cellspacing="3"  bgcolor="#FFFFCC">
                                    
                                    <tr>
                                        <%
                                        if (!wbo.getAttribute("currentStatus").equals("Assigned") || wbo.getAttribute("scheduleType").equals("External")) {
                                        %>
                                        <TD nowrap CLASS="cell" width="34%" bgcolor="#FFCC00" style="text-align:center;border:1px solid blue;color:white; font-size:<%=fontSize%>">
                                            <b>  <font color="red"><%=sCantAddTask%></font>  </b>
                                        </TD>
                                        <TD nowrap CLASS="cell"  bgcolor="#FFCC66" style="text-align:center;border:1px solid blue;color:white; font-size:<%=fontSize%>">
                                            <b><font color="red"><%=sCantAddPart%></font></b>
                                        </TD>
                                        <TD nowrap CLASS="cell"  bgcolor="#FFCC99" style="text-align:center;border:1px solid blue;color:white; font-size:<%=fontSize%>">
                                            <b><font color="red"><%=sCantAddWorkers%></font></b>
                                        </TD>
                                        <%
                                        } else {
                                        %>
                                        <TD  nowrap CLASS="cell" width="34%" bgcolor="#FFCC00" style="text-align:center;border:1px solid blue;cursor:hand;color:white;font-size:<%=fontSize%>" onclick="JavaScript: changePage('<%=context%>/IssueServlet?op=GetTasksForm&issueId=<%=(String) wbo.getAttribute("id")%>&filterValue=<%=filterValue%>&filterName=<%=filterName%>');">
                                            <b>  <font color="black"><%=add_task%></font>  </b>
                                        </TD>
                                        <TD   nowrap CLASS="cell"  bgcolor="#FFCC66" style="text-align:center;border:1px solid blue;cursor:hand;color:white;font-size:<%=fontSize%>"  nowrap  CLASS="cell" ONCLICK="JavaScript: changePage('<%=context%>/AssignedIssueServlet?op=configParts&issueId=<%=(String) wbo.getAttribute("id")%>&filterValue=<%=filterValue%>&filterName=<%=filterName%>')">
                                            <b><font color="black"><%=addParts%></font></b>
                                        </TD>
                                        <TD   nowrap CLASS="cell"  bgcolor="#FFCC99" style="text-align:center;border:1px solid blue;cursor:hand;color:white;font-size:<%=fontSize%>"  nowrap  CLASS="cell" ONCLICK="JavaScript: changePage('<%=context%>/ScheduleServlet?op=AddWorkersForm&issueId=<%=(String) wbo.getAttribute("id")%>&filterValue=<%=filterValue%>&filterName=<%=filterName%>')">
                                            <b><font color="black"><%=sAddWorkers%></font></b>
                                        </TD>
                                        <%
                                        }
                                        %>
                                    </tr>
                                    
                                    <tr>
                                        <TD   nowrap CLASS="cell"  bgcolor="#999900" style="text-align:center;border:1px solid blue;cursor:hand;color:white; font-size:<%=fontSize%>" onclick="JavaScript: changePage('<%=context%>/AssignedIssueServlet?op=AddLabourCompalint&issueId=<%=(String) wbo.getAttribute("id")%>&filterValue=<%=filterValue%>&filterName=<%=filterName%>');">
                                            <b><font color="Black"><%=laborComplaint%></font></b>
                                        </TD>
                                        
                                        
                                        <TD   nowrap CLASS="cell" bgcolor="#CCCC00" style="text-align:center;border:1px solid blue;cursor:hand;color:white; font-size:<%=fontSize%>"  nowrap  CLASS="cell" onclick="JavaScript: changePage('<%=context%>/TransactionServlet?op=GetTransactionForm&issueId=<%=wbo.getAttribute("id")%>&issueTitle=<%=wbo.getAttribute("issueTitle")%>&issueStatus=<%=wbo.getAttribute("currentStatus")%>&filterName=<%=filterName%>&filterValue=<%=filterValue%>');">
                                            <b><font color="black"><%=sStoreRequest%></font></b>
                                        </TD>
                                        <%
                                        if (wbo.getAttribute("scheduleType").equals("NONE")) {
                                        %>
                                        <TD   nowrap CLASS="cell"  bgcolor="#CCCC66" style="text-align:center;border:1px solid blue;cursor:hand;color:white; font-size:<%=fontSize%>"  nowrap  CLASS="cell" ONCLICK="JavaScript: changePage('<%=context%>/ScheduleServlet?op=ChangeToExternal&issueId=<%=wbo.getAttribute("id")%>&issueTitle=<%=wbo.getAttribute("issueTitle")%>&issueStatus=<%=wbo.getAttribute("currentStatus")%>&filterName=<%=filterName%>&filterValue=<%=filterValue%>');">
                                            <b><font color="black"><%=sChangeExternal%></font></b>
                                        </TD>
                                        <%
                                        } else {
                                        %>
                                        <TD   nowrap CLASS="cell"  bgcolor="#CCCC66" style="text-align:center;border:1px solid blue;cursor:hand;color:white; font-size:<%=fontSize%>"  nowrap  CLASS="cell">
                                            <b><font color="red"><%=sCantChange%></font></b>
                                        </TD>
                                        <%
                                        }
                                        %>
                                    </tr>
                                    
                                    <tr>
                                        <TD nowrap CLASS="cell" width="34%" bgcolor="#FFD700" style="text-align:center;border:1px solid blue;cursor:hand;color:white; font-size:<%=fontSize%>" onclick="JavaScript: changePage('<%=context %>/ImageWriterServlet?op=SelectFile&issueId=<%=(String) wbo.getAttribute("id")%>&fValue=<%=filterValue%>&fName=<%=filterName%>');">
                                            <b> <font color="Black"><%=attach_file%></font>   </b>
                                        </TD>
                                        <TD   nowrap CLASS="cell"  bgcolor="#FFD766" style="text-align:center;border:1px solid blue;cursor:hand;color:white; font-size:<%=fontSize%>"  nowrap  CLASS="cell" onclick="JavaScript: changePage('<%=context%>/UnitDocWriterServlet?op=excel2');">
                                            <b><font color="black"> <%=excel%>  </font></b>
                                        </TD>
                                        <TD   nowrap CLASS="cell"  bgcolor="#FFD799" style="text-align:center;border:1px solid blue;cursor:hand;color:white; font-size:<%=fontSize%>"  nowrap  CLASS="cell">
                                            <b><font color="black"> &nbsp; </font></b>
                                        </TD>
                                    </tr>
                                    
                                    <%--
                                    <tr>
                                        <TD   nowrap CLASS="cell"  bgcolor="white" style="text-align:center;border:1px solid blue;cursor:hand;color:white; font-size:<%=fontSize%>"  nowrap  CLASS="cell">
                                            <b><font color="black"> &nbsp; </font></b>
                                        </TD>
                                        <TD nowrap CLASS="cell" width="34%" bgcolor="white" style="text-align:center;border:1px solid blue;cursor:hand;color:white; font-size:<%=fontSize%>" onclick="JavaScript: changePage('<%=context %>/ImageWriterServlet?op=SelectFile&issueId=<%=(String) wbo.getAttribute("id")%>&fValue=<%=filterValue%>&fName=<%=filterName%>');">
                                            <b> <font color="Black"><%=attach_file%></font>   </b>
                                        </TD>
                                        <TD   nowrap CLASS="cell"  bgcolor="white" style="text-align:center;border:1px solid blue;cursor:hand;color:white; font-size:<%=fontSize%>"  nowrap  CLASS="cell" onclick="JavaScript: changePage('<%=context%>/UnitDocWriterServlet?op=excel2');">
                                            <b><font color="black"> <%=excel%>  </font></b>
                                        </TD>
                                    </tr>
                                    
                                    
                                    
                                    <tr>
                                        
                                        <%
                                        if (wbo.getAttribute("scheduleType").equals("NONE")) {
                                        %>
                                        <TD   nowrap CLASS="cell"  bgcolor="#bbbccc" style="text-align:center;border:1px solid blue;cursor:hand;color:white; font-size:<%=fontSize%>"  nowrap  CLASS="cell" ONCLICK="JavaScript: changePage('<%=context%>/ScheduleServlet?op=ChangeToExternal&issueId=<%=wbo.getAttribute("id")%>&issueTitle=<%=wbo.getAttribute("issueTitle")%>&issueStatus=<%=wbo.getAttribute("currentStatus")%>&filterName=<%=filterName%>&filterValue=<%=filterValue%>');">
                                            <b><font color="black"><%=sChangeExternal%></font></b>
                                        </TD>
                                        <%
                                        } else {
                                        %>
                                        <TD   nowrap CLASS="cell"  bgcolor="#bbbccc" style="text-align:center;border:1px solid blue;cursor:hand;color:white; font-size:<%=fontSize%>"  nowrap  CLASS="cell">
                                            <b><font color="red"><%=sCantChange%></font></b>
                                        </TD>
                                        <%
                                        }
                                        %>
                                        <TD   nowrap CLASS="cell"  bgcolor="#bbbccc" style="text-align:center;border:1px solid blue;cursor:hand;color:white; font-size:<%=fontSize%>"  nowrap  CLASS="cell" onclick="JavaScript: changePage('<%=context%>/TransactionServlet?op=GetTransactionForm&issueId=<%=wbo.getAttribute("id")%>&issueTitle=<%=wbo.getAttribute("issueTitle")%>&issueStatus=<%=wbo.getAttribute("currentStatus")%>&filterName=<%=filterName%>&filterValue=<%=filterValue%>');">
                                            <b><font color="black"><%=sStoreRequest%></font></b>
                                        </TD>
                                        <TD   nowrap CLASS="cell"  bgcolor="#bbbccc" style="text-align:center;border:1px solid blue;cursor:hand;color:white; font-size:<%=fontSize%>" onclick="JavaScript: changePage('<%=context%>/AssignedIssueServlet?op=AddLabourCompalint&issueId=<%=(String) wbo.getAttribute("id")%>&filterValue=<%=filterValue%>&filterName=<%=filterName%>');">
                                            <b><font color="Black"><%=laborComplaint%></font></b>
                                        </TD>
                                    </tr>
                                  --%>
            <%--
                                    <tr>
                                        <%
                                        if (!wbo.getAttribute("currentStatus").equals("Assigned") || wbo.getAttribute("scheduleType").equals("External")) {
                                        %>
                                        <TD nowrap CLASS="cell" width="34%" bgcolor="white" style="text-align:center;border:1px solid blue;cursor:hand;color:white; font-size:<%=fontSize%>">
                                            <b>  <font color="red"><%=sCantAddTask%></font>  </b>
                                        </TD>
                                        <TD nowrap CLASS="cell"  bgcolor="white" style="text-align:center;border:1px solid blue;cursor:hand;color:white; font-size:<%=fontSize%>">
                                            <b><font color="red"><%=sCantAddPart%></font></b>
                                        </TD>
                                        <TD nowrap CLASS="cell"  bgcolor="white" style="text-align:center;border:1px solid blue;cursor:hand;color:white; font-size:<%=fontSize%>">
                                            <b><font color="red"><%=sCantAddWorkers%></font></b>
                                        </TD>
                                        <%
                                        } else {
                                        %>
                                        <TD  nowrap CLASS="cell" width="34%" bgcolor="white" style="text-align:center;border:1px solid blue;cursor:hand;color:white;font-size:<%=fontSize%>" onclick="JavaScript: changePage('<%=context%>/IssueServlet?op=GetTasksForm&issueId=<%=(String) wbo.getAttribute("id")%>&filterValue=<%=filterValue%>&filterName=<%=filterName%>');">
                                            <b>  <font color="black"><%=add_task%></font>  </b>
                                        </TD>
                                        <TD   nowrap CLASS="cell"  bgcolor="white" style="text-align:center;border:1px solid blue;cursor:hand;color:white;font-size:<%=fontSize%>"  nowrap  CLASS="cell" ONCLICK="JavaScript: changePage('<%=context%>/AssignedIssueServlet?op=configParts&issueId=<%=(String) wbo.getAttribute("id")%>&filterValue=<%=filterValue%>&filterName=<%=filterName%>')">
                                            <b><font color="black"><%=addParts%></font></b>
                                        </TD>
                                        <TD   nowrap CLASS="cell"  bgcolor="white" style="text-align:center;border:1px solid blue;cursor:hand;color:white;font-size:<%=fontSize%>"  nowrap  CLASS="cell" ONCLICK="JavaScript: changePage('<%=context%>/ScheduleServlet?op=AddWorkersForm&issueId=<%=(String) wbo.getAttribute("id")%>&filterValue=<%=filterValue%>&filterName=<%=filterName%>')">
                                            <b><font color="black"><%=sAddWorkers%></font></b>
                                        </TD>
                                        <%
                                        }
                                        %>
                                    </tr>
                                    --%>
            <%--
                                    <%
                                    Long iIDno = new Long(wbo.getAttribute("id").toString());
                                    Calendar calendar = Calendar.getInstance();
                                    calendar.setTimeInMillis(iIDno.longValue());
                                    String numjob = wbo.getAttribute("id").toString().substring(9) + "/" + (calendar.getTime().getMonth() + 1) + "/" + (calendar.getTime().getYear() + 1900);
                                    %>
                                    
                                    <tr>
                                        <TD  nowrap CLASS="cell" width="34%" bgcolor="#FFFF33" style="text-align:center;border:1px solid blue;cursor:hand;color:white;font-size:<%=fontSize%>;">
                                            <b><font color="black">&nbsp;</font></b>
                                        </TD>
                                        <TD  nowrap CLASS="cell"  bgcolor="#FFFF66" style="text-align:center;border:1px solid blue;cursor:hand;color:white;font-size:<%=fontSize%>;"  nowrap  CLASS="cell" onclick="JavaScript: changePage('<%=context%>/IssueServlet?op=compose&issueId=<%=wbo.getAttribute("id")%>&maintTitle=<%=MaintenanceTitle%>&jobNo=<%=numjob%>&filterValue=<%=filterValue%>&filterName=<%=filterName%>')">
                                            <b><font color="black"><%=compose%></font></b>
                                        </TD>
                                        
                                        <%
                                        if (vecParent.size() == 0) {
                                        %>
                                        <TD  nowrap CLASS="cell"  bgcolor="#FFFF99"  style="text-align:center;border:1px solid blue;cursor:hand;color:white;font-size:<%=fontSize%>;"  nowrap  CLASS="cell" onclick="JavaScript: changePage('<%=context%>/IssueServlet?op=AttachJobOrder&issueId=<%=wbo.getAttribute("id")%>&filterValue=<%=filterValue%>&filterName=<%=filterName%>');">
                                            <b><font color="black"><%=sAttachJobOrder%></font></b>
                                        </TD>
                                        <%
                                        } else {
                                        %>
                                        <TD   nowrap CLASS="cell"   bgcolor="#FFFF66" style="text-align:center;border:1px solid blue;cursor:hand;color:white;font-size:<%=fontSize%>;">
                                            <b><font color="black"> &nbsp; </font></b>
                                        </TD>
                                        <%
                                        }
                                        %>
                                    </tr>
                                    
                                    <%--
                                    <tr>
                                        <TD  nowrap CLASS="cell" width="34%" bgcolor="#bbbccc" style="text-align:center;border:1px solid blue;cursor:hand;color:white;font-size:<%=fontSize%>;">
                                            <b><font color="black">&nbsp;</font></b>
                                        </TD>
                                        <TD  nowrap CLASS="cell"  bgcolor="#bbbccc" style="text-align:center;border:1px solid blue;cursor:hand;color:white;font-size:<%=fontSize%>;"  nowrap  CLASS="cell" onclick="JavaScript: changePage('<%=context%>/IssueServlet?op=compose&issueId=<%=wbo.getAttribute("id")%>&maintTitle=null&jobNo=<%=numjob%>&filterValue=<%=filterValue%>&filterName=<%=filterName%>')">
                                            <b><font color="black"><%=compose%></font></b>
                                        </TD>
                                        
                                        <%
                                        if (vecParent.size() == 0) {
                                        %>
                                        <TD  nowrap CLASS="cell"  bgcolor="#bbbccc" style="text-align:center;border:1px solid blue;cursor:hand;color:white;font-size:<%=fontSize%>;"  nowrap  CLASS="cell" onclick="JavaScript: changePage('<%=context%>/IssueServlet?op=AttachJobOrder&issueId=<%=wbo.getAttribute("id")%>&filterValue=<%=filterValue%>&filterName=<%=filterName%>');">
                                            <b><font color="black"><%=sAttachJobOrder%></font></b>
                                        </TD>
                                        <%
                                        } else {
                                        %>
                                        <TD   nowrap CLASS="cell"  bgcolor="#bbbccc" style="text-align:center;border:1px solid blue;cursor:hand;color:white;font-size:<%=fontSize%>;">
                                            <b><font color="black"> &nbsp; </font></b>
                                        </TD>
                                        <%
                                        }
                                        %>
                                    </tr>
                                    --%>
            <%--
                                </table>
                            </DIV>
                        </DIV>
                    </TD> 
                    
                    <TD STYLE="border:0px" width="34%"  VALIGN="top">
                        <DIV STYLE="width:100%;border:2px solid gray;background-color:#808000;color:white;">
                            <DIV ONCLICK="JavaScript: changeMode('menu3');" STYLE="width:100%;background-color:#808000;color:white;cursor:hand;font-size:16;">
                                <b><%=viewOP%></B> <img src="images/arrow_down.gif">
                            </DIV>
                            <DIV ALIGN="<%=align%>" STYLE="width:100%;background-color:#FFFFCC;color:black;display:none;<%=style%>;" ID="menu3">
                                <table border="0" cellpadding="0"  width="100%" cellspacing="3"  bgcolor="#FFFFCC">
                                    
                                    <tr> 
                                        <TD   nowrap CLASS="cell"  bgcolor="#FFCC00" style="text-align:center;border:1px solid blue;cursor:hand;color:white;font-size:<%=fontSize%>;"  nowrap  CLASS="cell" onclick="JavaScript: changePage('<%=context%>/IssueServlet?op=Re_Jops&key=<%=wbo.getAttribute("id")%>&issueTitle=<%=wbo.getAttribute("issueTitle")%>&issueStatus=<%=wbo.getAttribute("currentStatus")%>&filterName=<%=filterName%>&filterValue=<%=filterValue%>&projcteName=<%=projectname%>&mainTitle=<%=MaintenanceTitle%>');">
                                            <b><font color="black"> <%=ViewMaintenance%></font></b>
                                        </TD>
                                        <TD  nowrap CLASS="cell" width="34%" bgcolor="#FFCC66" style="text-align:center;border:1px solid blue;cursor:hand;color:white;font-size:<%=fontSize%>;" onclick="JavaScript: changePage('<%=context%>/IssueServlet?op=ViewParts&issueId=<%=(String) wbo.getAttribute("id")%>&issueTitle=<%=(String) wbo.getAttribute("issueTitle")%>&issueState=<%=(String) wbo.getAttribute("currentStatus")%>&filterValue=<%=filterValue%>&filterName=<%=filterName%>');">
                                            <b> <font color="black"> <%=view_spar%> </font></b>
                                        </TD>                           
                                        <TD   nowrap CLASS="cell"  bgcolor="#FFCC99" style="text-align:center;border:1px solid blue;cursor:hand;color:white;font-size:<%=fontSize%>;"  nowrap  CLASS="cell" ONCLICK="JavaScript: changePage('<%=context%>/ScheduleServlet?op=WorkersReport&issueId=<%=(String) wbo.getAttribute("id")%>&filterValue=<%=filterValue%>&filterName=<%=filterName%>')">
                                            <b><font color="black"><%=sWorkersReport%></font></b>
                                        </TD>
                                    </tr>
                                    
                                    <tr>
                                        <TD  nowrap CLASS="cell"  bgcolor="#999900" style="text-align:center;border:1px solid blue;cursor:hand;color:white;font-size:<%=fontSize%>;"  nowrap  CLASS="cell" onclick="JavaScript: changePage('<%=context%>/IssueServlet?op=viewComp&issueId=<%=wbo.getAttribute("id")%>&maintTitle=<%=MaintenanceTitle%>&jobNo=<%=numjob%>&filterName=<%=filterName%>&filterValue=<%=filterValue%>')">
                                            <b><font color="black"><%=complaint%></font></b>
                                        </TD>
                                        
                                        <TD  nowrap CLASS="cell"  bgcolor="#CCCC00" style="text-align:center;border:1px solid blue;cursor:hand;color:white;font-size:<%=fontSize%>;"  nowrap  CLASS="cell" onclick="JavaScript: changePage('<%=context%>/IssueServlet?op=printOrderStore&issueId=<%=wbo.getAttribute("id")%>&issueTitle=<%=wbo.getAttribute("issueTitle")%>&issueStatus=<%=wbo.getAttribute("currentStatus")%>&filterName=<%=filterName%>&filterValue=<%=filterValue%>');">
                                            <b><font color="black"><%=itemStore%></font></b>
                                        </TD>
                                        <TD  nowrap CLASS="cell" width="34%" bgcolor="#CCCC66" style="text-align:center;border:1px solid blue;cursor:hand;color:white;font-size:<%=fontSize%>;" onclick="JavaScript: changePage('<%=context%>/IssueServlet?op=ListTasks&issueId=<%=(String) wbo.getAttribute("id")%>&filterValue=<%=filterValue%>&filterName=<%=filterName%>');">
                                            <b> <font color="black"> <%=View_task%> </font> </b>
                                        </TD>
                                    </tr>
                                    
                                    <tr>
                                        <%
                                        if (imageMgr.hasDocuments(wbo.getAttribute("id").toString())) {
                                        %>
                                        <TD  nowrap CLASS="cell" width="34%" bgcolor="#FFD700" style="text-align:center;border:1px solid blue;cursor:hand;color:white;font-size:<%=fontSize%>;" onclick="JavaScript: changePage('<%=context%>/ImageReaderServlet?op=ListDoc&issueId=<%=(String) wbo.getAttribute("id")%>&fValue=<%=filterValue%>&fName=<%=filterName%>&filterBack=<%=filterBack%>');">
                                            <b> <font color="black"> <%=View_file%></font></b>
                                            <IMG SRC="images/view.png"  ALT="Click icon for bookmark note">
                                        </TD>
                                        
                                        <%
                                        } else {
                                        %> 
                                        <TD nowrap CLASS="cell" width="34%" bgcolor="#FFD700" style="text-align:center;border:1px solid blue;color:white;font-size:<%=fontSize%>;">
                                            <b> <font color="red"> <%=noFiles%></font> </b>
                                        </td>
                                        
                                        <%
                                        }
                                        %>
                                        <TD  nowrap CLASS="cell" width="34%" bgcolor="#FFD766" style="text-align:center;border:1px solid blue;cursor:hand;color:white;font-size:<%=fontSize%>;" onclick="JavaScript: changePage('<%= context %>/SearchServlet?op=ViewHistory&issueId=<%=(String) wbo.getAttribute("id")%>&fValue=<%=filterValue%>&fName=<%=filterName%>');">
                                            <b><font color="Black"> <%=View_hist%></font></b>
                                        </TD>
                                        <TD nowrap CLASS="cell" width="34%" bgcolor="#FFD799" style="text-align:center;border:1px solid blue;cursor:hand;color:white;font-size:<%=fontSize%>;" onclick="JavaScript: changePage('<%=context%>/EquipmentServlet?op=ViewJobEquipment&equipmentID=<%=equipmentID%>&filterValue=<%=filterValue%>&filterName=<%=filterName%>&issueId=<%=(String) wbo.getAttribute("id")%>');">
                                            <b> <font color="black"> <%=viewEquipment%></font> </b>
                                        </td>
                                    </tr>
                                    
                                    <tr>
                                        
                                        <TD  nowrap CLASS="cell"  bgcolor="#FFFF33" style="text-align:center;border:1px solid blue;cursor:hand;color:white;font-size:<%=fontSize%>;"  nowrap  CLASS="cell" onclick="JavaScript: changePage('<%=context%>/IssueServlet?op=ChangeDateHistory&issueId=<%=wbo.getAttribute("id")%>&issueTitle=<%=wbo.getAttribute("issueTitle")%>&issueStatus=<%=wbo.getAttribute("currentStatus")%>&filterName=<%=filterName%>&filterValue=<%=filterValue%>');">
                                            <b><font color="black"><%=sChangeDateHistory%></font></b>
                                        </TD> 
                                        
                                        <%
                                        iIDno = new Long(wbo.getAttribute("id").toString());
                                        calendar = Calendar.getInstance();
                                        calendar.setTimeInMillis(iIDno.longValue());
                                        numjob = wbo.getAttribute("id").toString().substring(9) + "/" + (calendar.getTime().getMonth() + 1) + "/" + (calendar.getTime().getYear() + 1900);
                                        %>
                                        <TD  nowrap CLASS="cell" width="34%" bgcolor="#FFFF66" style="text-align:center;border:1px solid blue;cursor:hand;color:white;font-size:<%=fontSize%>;" onclick="JavaScript: changePage('<%=context%>/IssueServlet?op=printJobOrder&issueId=<%=wbo.getAttribute("id")%>&issueTitle=<%=wbo.getAttribute("issueTitle")%>&issueStatus=<%=wbo.getAttribute("currentStatus")%>&filterName=<%=filterName%>&filterValue=<%=filterValue%>&sID=<%=numjob%>&unitName=<%=MaintenanceTitle%>');">
                                            <DIV ID="links">
                                                <b><font color="black"> <%=View_jop%> </font></b>
                                            </DIV>
                                        </TD>
                                        
                                        <TD   nowrap CLASS="cell"  bgcolor="#FFFF99" style="text-align:center;border:1px solid blue;cursor:hand;color:white;font-size:<%=fontSize%>;"  nowrap  CLASS="cell" onclick="JavaScript: changePage('<%=context%>/IssueServlet?op=ShowStatusJobOrderDate&issueId=<%=wbo.getAttribute("id")%>&maintTitle=<%=MaintenanceTitle%>&jobNo=<%=numjob%>&filterName=<%=filterName%>&filterValue=<%=filterValue%>')">
                                            <b><font color="black"><%=statusDateJobOrder%></font></b>
                                        </TD>
                                    </tr>
                                    
                                    <%--
                                    <tr>
                                        <TD  nowrap CLASS="cell" width="34%" bgcolor="white" style="text-align:center;border:1px solid blue;cursor:hand;color:white;font-size:<%=fontSize%>;" onclick="JavaScript: changePage('<%= context %>/SearchServlet?op=ViewHistory&issueId=<%=(String) wbo.getAttribute("id")%>&fValue=<%=filterValue%>&fName=<%=filterName%>');">
                                            <b><font color="Black"> <%=View_hist%></font></b>
                                        </TD>
                                        
                                        <%
                                        if (imageMgr.hasDocuments(wbo.getAttribute("id").toString())) {
                                        %>
                                        
                                        <TD  nowrap CLASS="cell" width="34%" bgcolor="white" style="text-align:center;border:1px solid blue;cursor:hand;color:white;font-size:<%=fontSize%>;" onclick="JavaScript: changePage('<%=context%>/ImageReaderServlet?op=ListDoc&issueId=<%=(String) wbo.getAttribute("id")%>&fValue=<%=filterValue%>&fName=<%=filterName%>&filterBack=<%=filterBack%>');">
                                            <b> <font color="black"> <%=View_file%></font></b>
                                            <IMG SRC="images/view.png"  ALT="Click icon for bookmark note">
                                        </TD>
                                        
                                        <%
                                        } else {
                                        %> 
                                        <TD nowrap CLASS="cell" width="34%" bgcolor="white" style="text-align:center;border:1px solid blue;color:white;font-size:<%=fontSize%>;">
                                            <b> <font color="black"> <%=noFiles%></font> </b>
                                        </td>
                                        
                                        <%
                                        }
                                        %>
                                        <!--TD nowrap CLASS="cell" width="34%" bgcolor="white" style="text-align:center;border:1px solid blue;cursor:hand;color:white;font-size:<%=fontSize%>;" onclick="JavaScript: changePage('<%=context%>/EquipmentServlet?op=ViewJobEquipment&equipmentID=<%=equipmentID%>&filterValue=<%=filterValue%>&filterName=<%=filterName%>&issueId=<%=(String) wbo.getAttribute("id")%>');">
                                        <b> <font color="black"> <%=viewEquipment%></font> </b>
                                        </td-->
                                        <TD nowrap CLASS="cell" width="34%" bgcolor="white" style="text-align:center;border:1px solid blue;cursor:hand;color:white;font-size:<%=fontSize%>;" >
                                            <b> <font color="black"> &nbsp;</font> </b>
                                        </td>
                                    </tr>
                                    <tr>
                                        <TD  nowrap CLASS="cell" width="34%" bgcolor="#bbbccc" style="text-align:center;border:1px solid blue;cursor:hand;color:white;font-size:<%=fontSize%>;" onclick="JavaScript: changePage('<%=context%>/IssueServlet?op=ListTasks&issueId=<%=(String) wbo.getAttribute("id")%>&filterValue=<%=filterValue%>&filterName=<%=filterName%>');">
                                            <b> <font color="black"> <%=View_task%> </font> </b>
                                        </TD>
                                        <TD  nowrap CLASS="cell" width="34%" bgcolor="#bbbccc" style="text-align:center;border:1px solid blue;cursor:hand;color:white;font-size:<%=fontSize%>;" onclick="JavaScript: changePage('<%=context%>/IssueServlet?op=ViewParts&issueId=<%=(String) wbo.getAttribute("id")%>&issueTitle=<%=(String) wbo.getAttribute("issueTitle")%>&issueState=<%=(String) wbo.getAttribute("currentStatus")%>&filterValue=<%=filterValue%>&filterName=<%=filterName%>');">
                                            <b> <font color="black"> <%=view_spar%> </font></b>
                                        </TD>
                                        <%
                                        iIDno = new Long(wbo.getAttribute("id").toString());
                                        calendar = Calendar.getInstance();
                                        calendar.setTimeInMillis(iIDno.longValue());
                                        numjob = wbo.getAttribute("id").toString().substring(9) + "/" + (calendar.getTime().getMonth() + 1) + "/" + (calendar.getTime().getYear() + 1900);
                                        %>
                                        <TD  nowrap CLASS="cell" width="34%" bgcolor="#bbbccc" style="text-align:center;border:1px solid blue;cursor:hand;color:white;font-size:<%=fontSize%>;" onclick="JavaScript: changePage('<%=context%>/IssueServlet?op=printJobOrder&issueId=<%=wbo.getAttribute("id")%>&issueTitle=<%=wbo.getAttribute("issueTitle")%>&issueStatus=<%=wbo.getAttribute("currentStatus")%>&filterName=<%=filterName%>&filterValue=<%=filterValue%>&sID=<%=numjob%>&unitName=<%=MaintenanceTitle%>');">
                                            <DIV ID="links">
                                                <b><font color="black"> <%=View_jop%> </font></b>
                                            </DIV>
                                        </TD>
                                    </tr>
                                    
                                    
                                    <tr> 
                                        <TD  nowrap CLASS="cell"  bgcolor="white" style="text-align:center;border:1px solid blue;cursor:hand;color:white;font-size:<%=fontSize%>;"  nowrap  CLASS="cell" onclick="JavaScript: changePage('<%=context%>/IssueServlet?op=ChangeDateHistory&issueId=<%=wbo.getAttribute("id")%>&issueTitle=<%=wbo.getAttribute("issueTitle")%>&issueStatus=<%=wbo.getAttribute("currentStatus")%>&filterName=<%=filterName%>&filterValue=<%=filterValue%>');">
                                            <b><font color="black"><%=sChangeDateHistory%></font></b>
                                        </TD>
                                        <TD   nowrap CLASS="cell"  bgcolor="white" style="text-align:center;border:1px solid blue;cursor:hand;color:white;font-size:<%=fontSize%>;"  nowrap  CLASS="cell" onclick="JavaScript: changePage('<%=context%>/IssueServlet?op=Re_Jops&key=<%=wbo.getAttribute("id")%>&issueTitle=<%=wbo.getAttribute("issueTitle")%>&issueStatus=<%=wbo.getAttribute("currentStatus")%>&filterName=<%=filterName%>&filterValue=<%=filterValue%>&projcteName=<%=projectname%>&mainTitle=<%=MaintenanceTitle%>');">
                                            <b><font color="black"> <%=ViewMaintenance%></font></b>
                                        </TD>
                                        <TD   nowrap CLASS="cell"  bgcolor="white" style="text-align:center;border:1px solid blue;cursor:hand;color:white;font-size:<%=fontSize%>;"  nowrap  CLASS="cell" ONCLICK="JavaScript: changePage('<%=context%>/ScheduleServlet?op=WorkersReport&issueId=<%=(String) wbo.getAttribute("id")%>&filterValue=<%=filterValue%>&filterName=<%=filterName%>')">
                                            <b><font color="black"><%=sWorkersReport%></font></b>
                                        </TD>
                                    </tr>
                                    
                                    <tr>
                                        <TD  nowrap CLASS="cell"  bgcolor="#bbbccc" style="text-align:center;border:1px solid blue;cursor:hand;color:white;font-size:<%=fontSize%>;"  nowrap  CLASS="cell" onclick="JavaScript: changePage('<%=context%>/IssueServlet?op=printOrderStore&issueId=<%=wbo.getAttribute("id")%>&issueTitle=<%=wbo.getAttribute("issueTitle")%>&issueStatus=<%=wbo.getAttribute("currentStatus")%>&filterName=<%=filterName%>&filterValue=<%=filterValue%>');">
                                            <b><font color="black"><%=itemStore%></font></b>
                                        </TD>
                                        
                                        
                                        <TD  nowrap CLASS="cell"  bgcolor="#bbbccc" style="text-align:center;border:1px solid blue;cursor:hand;color:white;font-size:<%=fontSize%>;"  nowrap  CLASS="cell" onclick="JavaScript: changePage('<%=context%>/IssueServlet?op=viewComp&issueId=<%=wbo.getAttribute("id")%>&maintTitle=<%=MaintenanceTitle%>&jobNo=<%=numjob%>&filterName=<%=filterName%>&filterValue=<%=filterValue%>')">
                                            <b><font color="black"><%=complaint%></font></b>
                                        </TD>
                                        
                                        <TD   nowrap CLASS="cell"  bgcolor="#bbbccc" style="text-align:center;border:1px solid blue;cursor:hand;color:white;font-size:<%=fontSize%>;"  nowrap  CLASS="cell" onclick="JavaScript: changePage('<%=context%>/IssueServlet?op=ShowStatusJobOrderDate&issueId=<%=wbo.getAttribute("id")%>&maintTitle=<%=MaintenanceTitle%>&jobNo=<%=numjob%>&filterName=<%=filterName%>&filterValue=<%=filterValue%>')">
                                            <b><font color="black"><%=statusDateJobOrder%></font></b>
                                        </TD>
                                    </tr>
                                    --%>
            <%--
                                </table>
                            </DIV>
                        </DIV>
                    </TD>
                    
                    <td  STYLE="border:0px"  width="34%" VALIGN="top">
                        <div STYLE="width:100%;border:2px solid gray;background-color:#808000;color:white;" bgcolor="#F3F3F3" align="<%=align%>">
                            <div ONCLICK="JavaScript: changeMode('menu1');" STYLE="width:100%;background-color:#808000;color:white;cursor:hand;font-size:16;">
                                <b>
                                    <%=status%>
                                </b>
                                <img src="images/arrow_down.gif">
                            </div>
                            
                            <div ALIGN="<%=align%>" STYLE="width:100%;background-color:#FFFFCC;color:white;display:none;<%=style%>;border-top:2px solid gray;" ID="menu1">
                                
                                <table align="<%=align%>" border="0" dir="<%=dir%>" width="100%" cellspacing="2" bgcolor="#FFFFCC">
                                    <%if (currentStatus.equalsIgnoreCase("Schedule")) {
                                    orderStatus=schduled;
                                    %>
                                    <tr>
                                        <td style="text-align:center;border:1px solid blue; font-size:<%=fontSize%>" CLASS="cell" bgcolor="white" width="16%"><b><font color="black"><%=schduled%></font></b></td>
                                    </tr>
                                    <%} else if (currentStatus.equalsIgnoreCase("Assigned")) {
                                    orderStatus=Begined;   
                                    %>
                                    <tr>
                                        <td style="text-align:center;border:1px solid blue; font-size:<%=fontSize%>" CLASS="cell" bgcolor="white" width="16%"><b><font color="black"><%=Begined%></font></b></td>
                                    </tr>
                                    <%} else if (currentStatus.equalsIgnoreCase("Finished")) {
                                    orderStatus=Finished;
                                    %>
                                    <tr>
                                        <td style="text-align:center;border:1px solid blue; font-size:<%=fontSize%>" CLASS="cell" bgcolor="white" width="16%"><b><font color="black"><%=Finished%></font></b></td>
                                    </tr>
                                    <%} else if (currentStatus.equalsIgnoreCase("Canceled")) {
                                    orderStatus=Canceled;
                                    %>
                                    <tr>
                                        <td style="text-align:center;border:1px solid blue; font-size:<%=fontSize%>" CLASS="cell" bgcolor="white" width="16%"><b><font color="black"><%=Canceled%></font></b></td>
                                    </tr>
                                    <%} else if (currentStatus.equalsIgnoreCase("Onhold")) {
                                    orderStatus=Holded;
                                    %>
                                    <tr>
                                        <td style="text-align:center;border:1px solid blue; font-size:<%=fontSize%>" CLASS="cell" bgcolor="white" width="16%"><b><font color="black"><%=Holded%></font></b></td>
                                    </tr>
                                    <%} else if (currentStatus.equalsIgnoreCase("Rejected")) {
                                    orderStatus=Rejected;
                                    %>
                                    <tr>
                                        <td style="text-align:center;border:1px solid blue; font-size:<%=fontSize%>" CLASS="cell" bgcolor="white" width="16%"><b><font color="black"><%=Rejected%></font></b></td>
                                    </tr>
                                    <%}%>
                                </table>
                            </div>
                        </div>
                    </td>
                    
                </tr>
            </table>
            
            --%>
            <DIV align="left" STYLE="color:blue;">
                <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
                <button  onclick="JavaScript: cancelForm();" class="button"><%=sCancel%> <IMG VALIGN="BOTTOM" SRC="images/cancel.gif"> </button>
            </DIV> 
            <BR>
            <fieldset class="set" align="center">
                <legend align="center">
                    <table dir="<%=dir%>" align="center">
                        <tr>
                            <td class="td">
                                <font color="blue" size="6">
                                    <%=fieldSetTitle%>
                                </font>
                            </td>
                        </tr>
                    </table>
                </legend>
                <%
                if (message != null) {
                %>
                
                <table  dir="<%=dir%>">
                    <tr>
                        <td class="td"  align="<%=align%>">
                            <H4><font color="red"><%=message%></font></H4>
                        </td>
                    </tr>
                </table>
                <br><br>
                <%
                }
                %>
                <INPUT ALIGN="<%=align%>" dir="<%=dir%>" TYPE="hidden" name="filterValue" value="">
                <TABLE  ALIGN="<%=align%>"dir="<%=dir%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                    <TR>
                        <TD class="td">
                            &nbsp;
                            <div id="message" style="color:red; font-size:18"></div>
                        </TD>
                    </TR>
                </TABLE>
                <%
                if (metaMgr.getTabs().equalsIgnoreCase("On")) {
                %>
                <div class="tab-container" id="container1" style="width:100%;"> 
                    <ul class="tabs"> 
                        <li style="border-right: 1px solid #194367;" > 
                            <a href="#" onClick="return showPane('pane1', this)" id="tab1">&#1578;&#1601;&#1575;&#1589;&#1610;&#1604;<BR>Details</a> 
                        </li> 
                        <li> 
                            <a href="#" onClick="return showPane('pane2', this)" id="tab2">&#1602;&#1591;&#1593; &#1594;&#1610;&#1575;&#1585;<BR>Spare Parts</a> 
                        </li> 
                        <li style="border-left: 1px solid #194367;"> 
                            <a href="#" onClick="return showPane('pane3', this)" id="tab3">&#1575;&#1604;&#1593;&#1605;&#1575;&#1604;&#1577;<BR>Workers</a> 
                        </li> 
                        <li style="border-left: 1px solid #194367;"> 
                            <a href="#" onClick="return showPane('pane4', this)" id="tab4">&#1578;&#1608;&#1589;&#1610;&#1575;&#1578; &#1578;&#1606;&#1601;&#1610;&#1584;<BR>Execution Instructions</a> 
                        </li>
                        <li style="border-left: 1px solid #194367;"> 
                            <a href="#" onClick="return showPane('pane5', this)" id="tab5">&#1605;&#1604;&#1582;&#1589; &#1605;&#1589;&#1608;&#1585;<BR>Images Summery</a> 
                        </li>
                        <li style="border-left: 1px solid #194367;"> 
                            <a href="#" onClick="return showPane('pane6', this)" id="tab6">&#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583;&#1575;&#1578;<BR>Documents</a> 
                        </li>
                    </ul> 
                    
                    <div class="tab-panes"> 
                        <div class="content" id="pane1" style="text-align:center;">
                            <%
                            }
                            %>
                            <TABLE ALIGN="<%=align%>"  CELLPADDING="0" CELLSPACING="0" BORDER="0" dir="<%=dir%>">
                                
                                
                                <TR BGCOLOR="#F5F5F5">
                                    <TD STYLE="<%=style%>" class='td'>
                                        <LABEL FOR="ISSUE_TITLE">
                                            <p><b><font color="#003399"><%=MNumber%></font></b>&nbsp;
                                        </LABEL>
                                    </TD>
                                    <TD STYLE="<%=style%>" class='td'>
                                        <font size="3" color="#993333" ><b> <%=wbo.getAttribute("businessID")%>/<%=wbo.getAttribute("businessIDbyDate")%></b></font>
                                    </TD>
                                    <td width="10%" class="td"></td>
                                    
                                    <TD STYLE="<%=style%>" class='td'>
                                        <LABEL FOR="ISSUE_TITLE">
                                            <p><b><font color="#003399"><%=unitName%></font></b>&nbsp;
                                        </LABEL>
                                    </TD>
                                    <TD STYLE="<%=style%>" class='td'>
                                        <font size="3" color="#993333" ><b><%=eqpName%></b></font>
                                    </TD>
                                    
                                </TR>
                                
                                <tr bgcolor="#F5F5F5"><TD class='td'  COLSPAN="5" >&nbsp;</TD></TR>
                                
                                <TR BGCOLOR="#F5F5F5">
                                    
                                    <TD STYLE="<%=style%>" class='td'>
                                        <LABEL FOR="ISSUE_TITLE">
                                            <p><b><font color="#003399"><%=Workorder%></font></b>&nbsp;
                                        </LABEL>
                                    </TD>
                                    <TD STYLE="<%=style%>" class='td'>
                                        <font size="3" color="#993333" ><b>  <%=wbo.getAttribute("workTrade")%></b></font>
                                    </TD>
                                    
                                    <td width="10%" class="td"></td>
                                    <%---------------%> 
                                    <TD STYLE="<%=style%>" class='td'>
                                        <LABEL FOR="str_current_status">
                                            <p><b><font color="#003499"><%=current_status%></font></b>&nbsp;
                                        </LABEL>
                                    </TD>
                                    <TD STYLE="<%=style%>" class='td'>
                                        <b><font size="3" color="#993333" ><%=currentStatus%></font></b>
                                    </TD>
                                    <%---------------%> 
                                </TR>
                                
                                <tr bgcolor="#F5F5F5"><TD class='td'  COLSPAN="5" >&nbsp;</TD></TR>
                                
                                <TR BGCOLOR="#F5F5F5">
                                    
                                    <TD STYLE="<%=style%>" class='td'>
                                        <LABEL FOR="Project_Name">
                                            <p><b><font color="#003399"><%=Site_Name%></font></b>&nbsp;
                                        </LABEL>
                                    </TD>
                                    <TD STYLE="<%=style%>" class='td'>
                                        <font size="3" color="#993333" ><b>  <%=wbo.getAttribute("siteName")%></b></font>
                                    </TD>
                                    
                                    <td width="10%" class="td"></td>
                                    
                                    <TD STYLE="<%=style%>" class='td'>
                                        <LABEL FOR="Project_Name">
                                            <p><b><font color="#003399"><%=Urgency_Level%></font></b>&nbsp;
                                        </LABEL>
                                    </TD>
                                    <TD STYLE="<%=style%>" class='td'>
                                        <font size="3" color="#993333" ><b> <%=wbo.getAttribute("urgencyLevel")%></b></font>
                                    </TD>
                                    
                                </TR>
                                
                                <tr bgcolor="#F5F5F5"><TD class='td'  COLSPAN="5" >&nbsp;</TD></TR>
                                
                                <TR BGCOLOR="#F5F5F5">
                                    
                                    <TD STYLE="<%=style%>" class='td'>
                                        <LABEL FOR="estimated_duration">
                                            <p><b><font color="#003399"><%=Estimated_Duration%></font></b>&nbsp;
                                        </LABEL>
                                    </TD>
                                    <TD STYLE="<%=style%>" class='td'>
                                        <font size="3" color="#993333" ><b> <%= wbo.getAttribute("estimatedduration")%></b></font>
                                    </TD>
                                    
                                    <td width="10%" class="td"></td>
                                    
                                    <TD STYLE="<%=style%>" class='td'>
                                        <LABEL FOR="str_current_status">
                                            <p><b><font color="#003499">&nbsp;</font></b>&nbsp;
                                        </LABEL>
                                    </TD>
                                    <TD STYLE="<%=style%>" class='td'>
                                        <b><font size="3" color="#993333" >&nbsp;</font></b>
                                    </TD>
                                    
                                </TR>
                                
                                <tr bgcolor="#F5F5F5"><TD class='td'  COLSPAN="5" >&nbsp;</TD></TR>
                                <tr bgcolor="#6699FF"><TD class='td'  COLSPAN="5" >&nbsp;</TD></TR>
                                
                                <TR bgcolor="#F0F8FF">
                                    
                                    <TD STYLE="<%=style%>" class='td'>
                                        <LABEL FOR="str_User_Name">
                                            <p><b><font color="#003399"><%=groupname%></font></b>&nbsp;
                                        </LABEL>
                                    </TD>
                                    <%
                                    //createdBy= issueMgr.getCreateBy(createdBy);
                                    %>
                                    <TD STYLE="<%=style%>" class='td'>
                                        <font size="3" color="#993333" ><b> <%=wbo.getAttribute("createdByName")%></b></font>
                                    </TD>
                                    
                                    <td width="10%" class="td"></td>
                                    
                                    <TD STYLE="<%=style%>" class='td'>
                                        <LABEL FOR="str_assigned_by">
                                            <p><b><font color="#003399"><%=assignedby%></font></b>&nbsp;
                                        </LABEL>
                                    </TD>
                                    <%
                                    if (!wbo.getAttribute("assignedByName").equals("UL")) {
                                    %>
                                    <TD STYLE="<%=style%>" class='td'>
                                        <font size="3" color="#993333" ><b> <%=wbo.getAttribute("assignedByName")%></b></font>
                                    </TD>
                                    <% } else {
                                    %>
                                    <TD STYLE="<%=style%>" class='td'>   
                                        <font size="3" color="#993333" ><b> Has not been specified </b></font>
                                    </td>
                                    <% }%>
                                    
                                </TR>
                                
                                <tr bgcolor="fff999"><TD class='td'  COLSPAN="5" >&nbsp;</TD></TR>
                                
                                <tr bgcolor="#FAFAD2">
                                    
                                    <TD STYLE="<%=style%>" class='td'>
                                        <LABEL FOR="str_creation_time">
                                            <p><b><font color="#003399"><%=creationTime%></font></b>&nbsp;
                                        </LABEL>
                                    </TD>
                                    <TD STYLE="<%=style%>" class='td'>
                                        <font size="3" color="#993333" ><b> <%=wbo.getAttribute("creationTime")%></b></font>
                                    </TD> 
                                    
                                    <td width="10%" class="td"></td>
                                    
                                    <TD STYLE="<%=style%>" class='td'>
                                        <LABEL FOR="site entry date">
                                            <p><b><font color="#003399"><%=siteTime%> </font></b>&nbsp;
                                        </LABEL>
                                    </TD>
                                    <TD STYLE="<%=style%>" class='td' >
                                        <%String time=wbo.getAttribute("siteEntryTime").toString();%>
                                        <font size="3" color="#993333" ><b> <%=time%></b></font>
                                    </TD>
                                    
                                </tr>
                                
                                <tr  bgcolor="#FAFAD2"><TD class='td' COLSPAN="5" >&nbsp;</TD></TR>
                                
                                <TR bgcolor="#FAFAD2">
                                    
                                    <TD STYLE="<%=style%>" class='td'>
                                        <LABEL FOR="EXPECTED_B_DATE">
                                            <p><b><font color="#003399"><%=expectedB%> </font></b>&nbsp;
                                        </LABEL>
                                    </TD>
                                    <TD STYLE="<%=style%>" class='td'>
                                        <font size="3" color="#993333" ><b> <%=wbo.getAttribute("expectedBeginDate")%></b></font>
                                    </TD>
                                    
                                    <td width="10%" class="td"></td>
                                    
                                    <TD STYLE="<%=style%>" class='td'>
                                        <LABEL FOR="Actual Begin date">
                                            <p><b><font color="#003499"><%=actualBDate%></font></b>&nbsp;
                                        </LABEL>
                                    </TD>                                    
                                    <TD STYLE="<%=style%>" class='td'>
                                        <%if(wbo.getAttribute("actualBeginDate").toString().equalsIgnoreCase("notstarted")){%>
                                        <b><font size="3" color="#993333" ><%=notStarted%></font></b>
                                        <%}else{%>
                                        <b><font size="3" color="#993333" ><%=actualBeginDatebyTime%></font></b>
                                        <%}%>
                                    </TD>
                                    
                                </TR>
                                
                                <tr  bgcolor="#FAFAD2"><TD class='td'  COLSPAN="5" >&nbsp;</TD></TR>
                                
                                <tr bgcolor="#FAFAD2">
                                    
                                    <TD STYLE="<%=style%>" class='td'>
                                        <LABEL FOR="EXPECTED_E_DATE">
                                            <p><b><font color="#003399"><%=expectededate%></font></b>&nbsp;
                                        </LABEL>
                                    </TD>
                                    <TD STYLE="<%=style%>" class='td'>
                                        <font size="3" color="#993333" ><b> <%=wbo.getAttribute("expectedEndDate")%></b></font>
                                    </TD>
                                    
                                    <td width="10%" class="td"></td>
                                    
                                    
                                    <TD STYLE="<%=style%>" class='td'>
                                        <LABEL FOR="str_finshed_time">
                                            <p><b><font color="#003399"><%=finishedtime%></font></b>&nbsp;
                                        </LABEL>
                                    </TD>
                                    <TD STYLE="<%=style%>" class='td'>
                                        <%if (currentStatus.equalsIgnoreCase("Finished")){%>
                                         <% String EndJobDate= issueMgr.getEndJobDate(issueId);
                                        %>
                                        <font size="3" color="#993333" ><b> <%=EndJobDate%></b></font>
                                        <%}else{%>
                                        <font size="3" color="#993333" ><b> <%=NotFinishTime%></b></font>
                                        <%}%>
                                    </TD>
                                    
                                </tr>
                                
                                <tr BGCOLOR="#E6E6FA"><TD class='td' COLSPAN="5" >&nbsp;</TD></TR>
                                
                                <TR BGCOLOR="#E6E6FA">
                                    
                                    <TD STYLE="<%=style%>" class='td'>
                                        <LABEL FOR="str_Maintenance_Desc">
                                            <p><b><font color="#003399"><%=Problem_Description%></font> </b>&nbsp;
                                        </LABEL>
                                    </TD>
                                    <TD STYLE="<%=style%>" class='td'>
                                        <font size="3" color="#993333" ><b>  <%=wbo.getAttribute("issueDesc")%></b></font>
                                    </TD>
                                    <td width="10%" class="td" colspan="3"></td>
                                    
                                    
                                </TR>
                                <% //}%>
                                
                                <TD class='td'>
                                    &nbsp;
                                </TD>
                                
                            </TABLE>
                            <%
                            if (metaMgr.getTabs().equalsIgnoreCase("On")) {
                            %>
                        </div> 
                        <div class="content" id="pane2"> 
                            <jsp:include page="/docs/Search/tab_spare_parts.jsp" flush="true" />
                        </div> 
                        <div class="content" id="pane3">
                            <jsp:include page="/docs/Search/tab_workers.jsp" flush="true" />
                        </div>
                        <div class="content" id="pane4">
                            <jsp:include page="/docs/Search/tab_operation_order.jsp" flush="true" />
                        </div>
                        <div class="content" id="pane5">
                            <jsp:include page="/docs/Search/tab_issue_images.jsp" flush="true" />
                        </div>
                        <div class="content" id="pane6">
                            <jsp:include page="/docs/Search/tab_docs_list.jsp" flush="true" />
                        </div>
                    </div> 
                </div>
                <%
                            }
                %>
                <BR>
            </FIELDSET>
        </FORM>
    </BODY>
</HTML>     
