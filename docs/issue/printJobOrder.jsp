<%@page import="java.math.BigDecimal"%>
<%@page import="com.Erp.db_access.CostCentersMgr"%>
<%@page import="com.maintenance.common.Tools"%>
<%@page import="com.customization.common.CustomizeJOMgr"%>
<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.tracker.engine.*,com.silkworm.common.*, com.tracker.common.*, java.util.*,com.tracker.business_objects.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,java.util.*,java.text.SimpleDateFormat"%>
<%@ page import="com.maintenance.common.ConfigFileMgr,com.maintenance.common.ParseSideMenu,com.contractor.db_access.MaintainableMgr" %>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page pageEncoding="UTF-8"%>
<html>
    <%
                MetaDataMgr metaMgr = MetaDataMgr.getInstance();
                ProjectMgr projectMgr = ProjectMgr.getInstance();
                ConfigFileMgr configFileMgr = new ConfigFileMgr();
                EmpTasksHoursMgr empTasksHoursMgr = EmpTasksHoursMgr.getInstance();
                CustomizeJOMgr customizeJOMgr = CustomizeJOMgr.getInstance();
                TasksByIssueMgr tasksByIssueMgr = TasksByIssueMgr.getInstance();
                String context = metaMgr.getContext();
                IssueMgr issueMgr = IssueMgr.getInstance();
                TradeMgr tradeMgr = TradeMgr.getInstance();
                String issueId = (String) request.getAttribute(IssueConstants.ISSUEID);
                DateAndTimeControl dateAndTime = new DateAndTimeControl();
                MaintainableMgr maintainableMgr = MaintainableMgr.getInstance();

                WebBusinessObject itemWbo = new WebBusinessObject();
                String name = null;
                double totalCostItems = 0;
                String totalCostLabor = null;
                double laborCost = 0, totalCostLabors = 0.0;
                WebBusinessObject empWbo = null;
                WebBusinessObject tasksWbo = null;
                WebBusinessObject wboIssueStatusNote = null;
                Hashtable logos = new Hashtable();
                logos = (Hashtable) session.getAttribute("logos");

                ExternalJobMgr externalJobMgr = ExternalJobMgr.getInstance();
                SupplierMgr supplierMgr = SupplierMgr.getInstance();
                WebIssue webIssue = (WebIssue) request.getAttribute("webIssue");
                Vector vecExternal = externalJobMgr.getOnArbitraryKey((String) webIssue.getAttribute("id"), "key2");
                String jobType = webIssue.getAttribute("issueType").toString();
                String jobTitle = (String) webIssue.getAttribute("issueTitle");
                String groupbyShift = (String) webIssue.getAttribute("faId");
                String group = groupbyShift.substring(0, 1);
                String shift = groupbyShift.substring(2);
                Vector vec = new Vector();
                String[] itemAtt = {"note", "itemId", "itemQuantity", "itemPrice", "totalCost"};//appCons.getItemScheduleAttributes();
                String[] itemTitle = new String[7];

                String[] spareAtt = {"itemId", "itemQuantity"};//appCons.getItemScheduleAttributes();
                String[] spareTitle = {"&#1605;", "&#1585;&#1602;&#1605; &#1575;&#1604;&#1589;&#1606;&#1601;", "&#1575;&#1587;&#1600;&#1600;&#1600;&#1605; &#1575;&#1604;&#1589;&#1606;&#1601;", "&#1575;&#1604;&#1603;&#1605;&#1610;&#1577; &#1575;&#1604;&#1605;&#1591;&#1604;&#1608;&#1576;&#1577;"};//appCons.getItemScheduleHeaders();

                int sSpare = spareAtt.length;
                int tSpare = sSpare + 2;
                double totalCostTasks = 0, costItems = 0;
                String filterName = (String) request.getAttribute("filter");
                String filterValue = (String) request.getAttribute("filterValue");

                Vector itemList = (Vector) request.getAttribute("data");
                Vector complaintsList = (Vector) request.getAttribute("complaints");

                Vector issueItemVec = (Vector) request.getAttribute("issueItemVec");
                Vector resultItem = (Vector) request.getAttribute("resultItem");
                Vector avgPrice = (Vector) request.getAttribute("avgPrice");
                wboIssueStatusNote = (WebBusinessObject) request.getAttribute("wboIssueStatusNote");

                int s = itemAtt.length;
                int t = s;
                int iTotal = 0;

                // to view back button
                String back = request.getParameter("back");
                if (back == null) {
                    back = "";
                }
                String totalCost = null;
                WebBusinessObject wbo = (WebBusinessObject) request.getAttribute("issueWbo");
                WebBusinessObject webIssueStatus = (WebBusinessObject) request.getAttribute("webIssueStatus");

                WebBusinessObject wboTrade = tradeMgr.getOnSingleKey(wbo.getAttribute("workTrade").toString());
                WebBusinessObject wboTemp = UnitScheduleMgr.getInstance().getOnSingleKey(wbo.getAttribute("unitScheduleID").toString());

                WebBusinessObject unitWbo = maintainableMgr.getOnSingleKey(
                        (String) wboTemp.getAttribute("unitId"));

                String cMode = (String) request.getSession().getAttribute("currentMode");
                String stat = cMode;
                String align = null;
                String dir = null;
                String style = null;
                String endDate, actualTakenTime;
                Hashtable shifts = new Hashtable();
                String[] complaintsTitle = new String[2];
                String lang, langCode, sBackToList, timeStatus, sExternalSch, sNotes, actionTaken, causeDesc,inspection;
                String sTitle, sStartDate, sEndDate, sCaseOfJobOrder, sActualTimeExe, sSite, sEquipment, sStatusJobOrder;
                String sTypeMaintenance, sShift, sComplaintsWorkers, sSpareParts, sMaintenanceItem;
                String sCodeMaintenanceItem, sNameMaintenanceItem, sWorkers, sRecommended;
                String sTimeOfWorkers, sWorkerName;
                String sResponsetItems, resultTotalItem, accordingTo, print, readCounter, printJO, divAlign, strCost, strCostTotal, strItemsCostTotal, strLaborCostTotal, jobOrderCost;

                String sExternalMessage, sReceivedBY, sConversionDate, sLaborCost,
                        sPartCost, sConversionReason, itemStore, externalType, part, stotal, unitNoStr;
                String costNameField, itemNameMsg;
                if (stat.equals("En")) {
                    divAlign = "left";
                    align = "center";
                    dir = "LTR";
                    style = "text-align:left";
                    lang = "   &#1593;&#1585;&#1576;&#1610;    ";
                    langCode = "Ar";
                    sBackToList = "Back";
                    sExternalSch = "External";
                    causeDesc = "Complaint description";
                    inspection="Tecnical Inspection";
                    actionTaken = "How to Deal";
                    shifts.put("1", "First Shift");
                    shifts.put("2", "Second Shift");
                    shifts.put("3", "Third shift");
                    shifts.put("4", "Daylight");
                    sTitle = "Job order";
                    sStartDate = "Actual start date";
                    sEndDate = "Actual end date";
                    sCaseOfJobOrder = "Type of job order";
                    sActualTimeExe = "Actual execution time";
                    sSite = "Site";
                    sEquipment = "Equipment";
                    sStatusJobOrder = "Status of job order";
                    sTypeMaintenance = "Maintenance type";
                    sShift = "Shift";
                    sComplaintsWorkers = "Complaint of workers";
                    complaintsTitle[0] = "#";
                    complaintsTitle[1] = "Complaint";
                    sSpareParts = "Spare parts";
                    itemTitle[0] = "#";
                    itemTitle[1] = "Code";
                    itemTitle[2] = "Name";
                    itemTitle[3] = "Quantity";
                    itemTitle[4] = "Cost Center";
                    itemTitle[5] = "Cost";
                    itemTitle[6] = "Total Cost";
                    sMaintenanceItem = "Maintenance item";
                    sCodeMaintenanceItem = "Code";
                    sNameMaintenanceItem = "Name";
                    sWorkers = "Workers";
                    sRecommended = "Implementation of the recommendations";
                    sTimeOfWorkers = "Time of work";
                    sWorkerName = "Worker name";
                    sResponsetItems = "subtract spare parts from store";
                    spareTitle[0] = "#";
                    spareTitle[1] = "Item NO.";
                    spareTitle[2] = "Item Name";
                    spareTitle[3] = "Quantity";

                    resultTotalItem = "The subtract from store";
                    accordingTo = " According to Table ";
                    print = "Print";
                    readCounter = "Reading Counter";
                    printJO = "Print Job Order";
                    strCost = "Cost";
                    strCostTotal = "Total Cost";
                    strLaborCostTotal = "Labor Total Cost";
                    strItemsCostTotal = "Items Total Cost";
                    jobOrderCost = "Job Order Cost";

                    costNameField = "LATIN_NAME";

                    sPartCost = "Part Cost";
                    sLaborCost = "Labor Cost";
                    part = "Part";
                    stotal = "Total";
                    sExternalMessage = "This Job Order has been changed External";
                    sReceivedBY = "To Importer";
                    sConversionDate = "Conversion Date";
                    sConversionReason = "Conversion Reason";
                    itemStore = "Items Store Request";
                    externalType = "External Type";

                    itemNameMsg = "Item Not Found in stores";
                    unitNoStr = "Equipment No.";
                    
                } else {
                    divAlign = "right";
                    align = "center";
                    dir = "RTL";
                    style = "text-align:Right";
                    lang = "English";
                    langCode = "En";
                    sBackToList = "&#1593;&#1608;&#1583;&#1607;";
                    sExternalSch = "&#1582;&#1575;&#1585;&#1580;&#1609;";
                    causeDesc = "وصف الشكوي";
                    inspection="الفحص الفني";
                    actionTaken = "&#1591;&#1585;&#1610;&#1602;&#1607; &#1575;&#1604;&#1578;&#1593;&#1575;&#1605;&#1604;";
                    shifts.put("1", "&#1575;&#1604;&#1608;&#1585;&#1583;&#1610;&#1607; &#1575;&#1604;&#1575;&#1608;&#1604;&#1609;");
                    shifts.put("2", "&#1575;&#1604;&#1608;&#1585;&#1583;&#1610;&#1607; &#1575;&#1604;&#1579;&#1575;&#1606;&#1610;&#1607;");
                    shifts.put("3", "&#1575;&#1604;&#1608;&#1585;&#1583;&#1610;&#1607; &#1575;&#1604;&#1579;&#1575;&#1604;&#1579;&#1607;");
                    shifts.put("4", "&#1606;&#1607;&#1575;&#1585;&#1609;");
                    sTitle = "&#1571;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
                    sStartDate = "&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1576;&#1583;&#1575;&#1610;&#1607; &#1575;&#1604;&#1601;&#1593;&#1604;&#1609;";
                    sEndDate = "&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1571;&#1606;&#1578;&#1607;&#1575;&#1569; &#1575;&#1604;&#1601;&#1593;&#1604;&#1609;";
                    sCaseOfJobOrder = "&#1591;&#1576;&#1610;&#1593;&#1577; &#1571;&#1605;&#1585; &#1575;&#1604;&#1588;&#1593;&#1604;";
                    sActualTimeExe = "&#1575;&#1604;&#1605;&#1583;&#1577; &#1575;&#1604;&#1601;&#1593;&#1604;&#1610;&#1577; &#1604;&#1604;&#1578;&#1606;&#1601;&#1610;&#1584;";
                    sSite = "&#1575;&#1604;&#1605;&#1608;&#1602;&#1593;";
                    sEquipment = "&#1575;&#1604;&#1605;&#1593;&#1583;&#1577;";
                    sStatusJobOrder = "&#1575;&#1604;&#1581;&#1575;&#1604;&#1577;";
                    sTypeMaintenance = "&#1606;&#1608;&#1593; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
                    sShift = "&#1575;&#1604;&#1608;&#1585;&#1583;&#1610;&#1607;";
                    sComplaintsWorkers = "شكاوي العاملين";
                    complaintsTitle[0] = "&#1605;";
                    complaintsTitle[1] = "الشكوي";
                    sSpareParts = "&#1602;&#1591;&#1593; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585;";
                    itemTitle[0] = "&#1605;";
                    itemTitle[1] = "&#1585;&#1602;&#1605; &#1575;&#1604;&#1589;&#1606;&#1601;";
                    itemTitle[2] = "&#1575;&#1587;&#1600;&#1600;&#1600;&#1605; &#1575;&#1604;&#1589;&#1606;&#1601;";
                    itemTitle[3] = "&#1575;&#1604;&#1603;&#1605;&#1610;&#1577; &#1575;&#1604;&#1605;&#1591;&#1604;&#1608;&#1576;&#1577;";
                    itemTitle[4] = "مركز التكلفة";
                    itemTitle[5] = "التكلفة";
                    itemTitle[6] = "التكلفة الإجمالية";
                    sMaintenanceItem = "&#1576;&#1606;&#1608;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
                    sCodeMaintenanceItem = "&#1603;&#1608;&#1583; &#1576;&#1606;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
                    sNameMaintenanceItem = "&#1608;&#1589;&#1601; &#1575;&#1604;&#1576;&#1606;&#1583;";
                    sWorkers = "&#1575;&#1604;&#1593;&#1605;&#1575;&#1604;&#1577;";
                    sRecommended = "&#1578;&#1608;&#1589;&#1610;&#1575;&#1578; &#1575;&#1604;&#1578;&#1606;&#1601;&#1610;&#1584;";
                    sTimeOfWorkers = "&#1593;&#1600;&#1600;&#1583;&#1583; &#1583;&#1602;&#1600;&#1600;&#1575;&#1574;&#1600;&#1602; &#1575;&#1604;&#1600;&#1593;&#1600;&#1605;&#1600;&#1604;";
                    sWorkerName = "&#1575;&#1587;&#1605; &#1575;&#1604;&#1605;&#1608;&#1592;&#1601;";
                    sResponsetItems = "&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1589;&#1585;&#1601; &#1605;&#1606; &#1575;&#1604;&#1605;&#1582;&#1575;&#1586;&#1606;";
                    resultTotalItem = "&#1575;&#1604;&#1605;&#1606;&#1589;&#1585;&#1601; &#1605;&#1606; &#1575;&#1604;&#1605;&#1582;&#1586;&#1606;";
                    accordingTo = " &#1576;&#1606;&#1575;&#1569; &#1593;&#1604;&#1609; &#1580;&#1583;&#1608;&#1604; ";
                    print = "&#1575;&#1591;&#1576;&#1593;";
                    readCounter = "&#1602;&#1585;&#1575;&#1569;&#1577; &#1575;&#1604;&#1593;&#1583;&#1575;&#1583;";
                    printJO = "&#1591;&#1600;&#1576;&#1600;&#1575;&#1593;&#1600;&#1577; &#1571;&#1605;&#1600;&#1600;&#1600;&#1585; &#1588;&#1600;&#1594;&#1600;&#1604;";
                    strCost = "&#1575;&#1604;&#1600;&#1578;&#1600;&#1603;&#1600;&#1604;&#1600;&#1601;&#1600;&#1577;";
                    strCostTotal = "&#1575;&#1604;&#1600;&#1578;&#1600;&#1603;&#1600;&#1604;&#1600;&#1601;&#1600;&#1577; &#1575;&#1604;&#1600;&#1603;&#1600;&#1604;&#1600;&#1610;&#1600;&#1577;";
                    strLaborCostTotal = "التكلفة الكلية للعمالة";
                    strItemsCostTotal = "التكلفة الكلية لقطع الغيار";
                    jobOrderCost = "&#1578;&#1600;&#1603;&#1600;&#1604;&#1600;&#1601;&#1600;&#1577; &#1571;&#1605;&#1600;&#1585; &#1575;&#1604;&#1600;&#1588;&#1600;&#1594;&#1600;&#1604;";

                    costNameField = "COSTNAME";

                    sLaborCost = "&#1578;&#1603;&#1604;&#1601;&#1577; &#1575;&#1604;&#1593;&#1605;&#1575;&#1604;&#1577;";
                    part = "&#1580;&#1586;&#1574;&#1610;";
                    stotal = "&#1603;&#1604;&#1610;";
                    externalType = "&#1606;&#1608;&#1593; &#1575;&#1604;&#1578;&#1581;&#1608;&#1610;&#1604;";
                    sExternalMessage = "&#1578;&#1605; &#1578;&#1581;&#1608;&#1610;&#1604; &#1607;&#1584;&#1575; &#1575;&#1604;&#1571;&#1605;&#1585; &#1582;&#1575;&#1585;&#1580;&#1610;&#1575;&#1611;";
                    sReceivedBY = " &#1604;&#1604;&#1605;&#1608;&#1585;&#1583;";
                    sConversionDate = "&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1578;&#1581;&#1608;&#1610;&#1604;";
                    sConversionReason = "&#1587;&#1576;&#1576; &#1575;&#1604;&#1578;&#1581;&#1608;&#1610;&#1604;";
                    itemStore = "&#1591;&#1604;&#1576; &#1589;&#1585;&#1601; &#1605;&#1582;&#1575;&#1586;&#1606;";

                    itemNameMsg = "قطعة الغيار غير موجودة بالمخازن";
                    unitNoStr = "كود المعدة";
                }
                WebBusinessObject siteWbo = projectMgr.getOnSingleKey(wbo.getAttribute("projectName").toString());

                String typeOfSchedule = null;
                String caseStatus = null;

                Long iIDno = new Long(wbo.getAttribute("id").toString());
                Calendar calendar = Calendar.getInstance();
                calendar.setTimeInMillis(iIDno.longValue());
                String jobnumber = "<font color=\"red\">" + wbo.getAttribute("businessID").toString() + "</font>/<font color=\"blue\">" + (calendar.getTime().getMonth() + 1) + "/" + (calendar.getTime().getYear() + 1900) + "</font>";
                WebBusinessObject issueWbo = (WebBusinessObject) issueMgr.getOnSingleKey(issueId);
                String cause = (String) issueWbo.getAttribute("issueDesc");
                if (wbo.getAttribute("issueTitle").toString().equals("Emergency")) {
                    typeOfSchedule = configFileMgr.getJobOrderType("Emergency");
                } else {
                    String temp = (String) issueWbo.getAttribute("issueTitle");
                    cause = accordingTo + " ( <font color='red'>" + temp + " </font> )";
                    typeOfSchedule = configFileMgr.getJobOrderType("Planned");
                }

                if (wbo.getAttribute("currentStatus").toString().equals("Finished")) {
                    caseStatus = configFileMgr.getMaintenanceFinish();
                } else {
                    caseStatus = configFileMgr.getMaintenanceNotEnd();
                }

                Vector empList = new Vector();
                Vector tasksList = new Vector();
                Vector inspectionVector=new Vector();
                IssueStatusMgr issueStatusMgr=IssueStatusMgr.getInstance();

                empList = empTasksHoursMgr.getOnArbitraryKey(issueId, "key1");
                tasksList = tasksByIssueMgr.getOnArbitraryKey(issueId, "key");
                inspectionVector=issueStatusMgr.getOnArbitraryKey(issueId, "key2");
                actualTakenTime = "";
                endDate = "";
                if (wbo.getAttribute("currentStatus").toString().equals("Schedule")) {
                    timeStatus = configFileMgr.getWorkingNotStartYet();
                    endDate = configFileMgr.getWorkingNotStartYet();
                    actualTakenTime = configFileMgr.getNotEndYet();

                } else {
                    timeStatus = issueMgr.getCreateTimeAssigned(issueId);
                    if (wbo.getAttribute("actualEndDate") != null) {
                        endDate = (String) wbo.getAttribute("actualEndDate");
                        String exeHours = wbo.getAttribute("actualFinishTime").toString();
                        Double execHr = 0.0;
                        int execIntHr = 0;
                        execHr = new Double(exeHours).doubleValue();
                        if (execHr < 1) {
                            execHr = 1.0;
                        }
                        execIntHr = execHr.intValue();
                        actualTakenTime = dateAndTime.getDaysHourMinute(execIntHr);
                    } else {
                        endDate = configFileMgr.getNotEndYet();
                        actualTakenTime = configFileMgr.getNotEndYet();
                    }
                }

                shift = (String) shifts.get((String) wbo.getAttribute("shift"));


                sNotes = issueMgr.getNotesAssigned(issueId);

                ItemsMgr itemsMgr = ItemsMgr.getInstance();
                String itemId = null;
                String totalCount = "0";
                int total = 0;
                int iSpareTotal = 0;

                // Readin Counter
                ReadingRateUnitMgr readingRateUnitMgr = ReadingRateUnitMgr.getInstance();
                String reading = readingRateUnitMgr.getReadingCounter((String) wbo.getAttribute("id"));
                
                String equipType = maintainableMgr.getUnitType((String) wbo.getAttribute("unitId"));
                String unit;
                if (equipType.equalsIgnoreCase("fixed")) {
                    if (stat.equals("En")) {
                        unit = "Hours";
                    } else {
                        unit = "&#1587;&#1575;&#1593;&#1577;";
                    }
                } else {
                    if (stat.equals("En")) {
                        unit = "K.M";
                    } else {
                        unit = "&#1603;&#1610;&#1604;&#1608;&#1605;&#1578;&#1585;";
                    }
                }
    %>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    <head>
        <TITLE>Job Order-detail</TITLE>
    </head>
    <script src='js/ChangeLang.js' type='text/javascript'></script>
    <link rel="stylesheet" href="css/blueStyle.css" />
    <style type="text/css" >
        .textStyle {
            padding-left:5px;
            padding-right:5px;
            color: black;
            font-weight: bold;
        }
    </style>
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
        function cancelForm() {
            document.JobOrder_FORM.action ="<%=context%>/AssignedIssueServlet?op=VIEWDETAILS&issueId=<%=issueId%>&filterName=<%=filterName%>&filterValue=<%=filterValue%>";
            document.JobOrder_FORM.submit();
        }

        function printWindow() {
            document.getElementById('divDutton').style.display = "none";
            window.print();
            document.getElementById('divDutton').style.display = "block";
        }

        function createPDF() {
            document.JobOrder_FORM.action ="<%=context%>/PDFReportServlet?op=printJobOrder&issueId=<%=issueId%>&issueTitle=<%=jobTitle%>";
            document.JobOrder_FORM.submit();
        }
    </SCRIPT>
    <body>
        <FORM NAME="JobOrder_FORM" METHOD="POST">
            <div dir="LTR" id="divDutton">
                <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
                <%if (!back.equals("no")) {%>
                &ensp;
                <button  onclick="JavaScript: cancelForm();"><%=sBackToList%> <IMG VALIGN="BOTTOM"  HEIGHT="15" SRC="images/cancel.gif"> </button>
                    <%}%>
                &ensp;
                <button  onclick="JavaScript: printWindow();" style="width:80px"><%=print%></button>
                &ensp;
                <button  onclick="JavaScript: createPDF();" style="width:80px">PDF</button>
            </div>
            <table border="0" width="90%" id="table1" ALIGN="center" dir="<%=dir%>">
                <tr>
                    <td nowrap colspan="3" style="text-align: center;color: blue" bgcolor="#D0D0D0" width="100%">
                        <b><font color="black" size="4"><%=printJO%></font></b>
                    </td>
                    <td nowrap align="center" rowspan="4" width="100%">
                        <img alt="Logo" border="0" src="images/<%=logos.get("headReport1").toString()%>" width="200" height="120">
                    </td>
                </tr>
                <tr>
                    <td nowrap colspan="3" width="100%">
                        <b><%=sTitle%> : <b><font color="#000089" dir="ltr" ><%=jobnumber%></font></b></b>
                    </td>
                </tr>
                <tr>
                    <%if(siteWbo.getAttribute("mainProjId").equals("0")){%>
                    <td nowrap bgcolor="#FFFFFF" width="100%">
                        <b><%=sSite%> : </b><b><font color="#000089"><%=siteWbo.getAttribute("projectName").toString()%></font></b>
                    </td>
                    <%}else{
                    WebBusinessObject getMainSite = projectMgr.getOnSingleKey((String)siteWbo.getAttribute("mainProjId"));
                    String allSite = "";
                    if(stat.equals("Ar")){
                       allSite =siteWbo.getAttribute("projectName").toString()+", الرئيسى : "+getMainSite.getAttribute("projectName").toString();
                    }else{
                       allSite =siteWbo.getAttribute("projectName").toString()+" , Main Site :"+getMainSite.getAttribute("projectName").toString();
                    }
                        %>
                        <td nowrap bgcolor="#FFFFFF" width="100%">
                        <b><%=sSite%> : </b><b><font color="#000089"><%=allSite%></font></b>
                    </td>
                    <%}%>
                </tr>

                <tr>
                    <td nowrap colspan="4" width="100%">&ensp;</td>
                </tr>
                <tr>
                    <td nowrap nowrap colspan="4" width="100%">
                        <table align="center" cellpadding="0" cellspacing="0" width="100%" class="blueBorder textStyle">
                            <tr>
                                <td nowrap  nowrap class="blueBorder textStyle" width="23%" bgcolor="#CCCCCC">
                                    <p><b><%=sStartDate%></b></td>
                                <td nowrap  nowrap class="blueBorder textStyle" width="27%" ><b><font color="black" size="2"><%=timeStatus%></font></b>
                                </td>
                                <td nowrap class="blueBorder textStyle textStyle" width="23%" bgcolor="#CCCCCC">
                                    <p><b><%=sShift%></b></p>
                                </td>
                                <td nowrap width="27%" class="blueBorder textStyle" >
                                    <%if (customizeJOMgr.getCustomization("Shift").display()) {%>
                                    <b><font color="black" size="2"><%=shift%></font></b>
                                    <%} else {%>
                                    <b> ----- </b>
                                    <%}%>
                                </td>
                            </tr>
                            <tr>
                                <td nowrap class="blueBorder textStyle" width="23%" bgcolor="#CCCCCC">
                                    <p><b><%=sEndDate%></b></p>
                                </td>
                                <td nowrap width="27%" class="blueBorder textStyle">
                                    <b><font color="black" size="2"><%=endDate%></font></b>
                                </td>
                                <td nowrap class="blueBorder textStyle" width="18%" bgcolor="#CCCCCC">
                                    <p ><b><%=sCaseOfJobOrder%></b>
                                </td>
                                <% if (wbo.getAttribute("scheduleType").toString().equals("NONE")) {%>
                                <td nowrap class="blueBorder textStyle" width="27%" >
                                    <b><font color="black" size="2" size="2"><%=typeOfSchedule%></font></b>
                                </td>
                                <% } else {%>
                                <td nowrap class="blueBorder textStyle" width="27%" >
                                    <b><font color="red">(<%=sExternalSch%>)</font><font color="black" size="2"><%=typeOfSchedule%></font></b>
                                </td>
                                <% }%>
                            </tr>
                            <tr>
                                <td nowrap class="blueBorder textStyle" width="23%" bgcolor="#CCCCCC">
                                    <p><b><%=sActualTimeExe%></b></p>
                                </td>
                                <td nowrap class="blueBorder textStyle" width="27%" >
                                    <b><font color="black" size="2"><%=actualTakenTime%></font></b>
                                </td>
                                <td nowrap class="blueBorder textStyle" width="23%" bgcolor="#CCCCCC">
                                    <p><b><%=sEquipment%></b>
                                </td>
                                <td nowrap class="blueBorder textStyle" width="27%" >
                                    <b><font color="black" size="2"><%=wboTemp.getAttribute("unitName").toString()%></font></b>
                                </td>
                            </tr>
                            <tr>
                                <td nowrap class="blueBorder textStyle" width="23%" bgcolor="#CCCCCC">
                                    <p><b><%=sStatusJobOrder%></b>
                                </td>
                                <td nowrap class="blueBorder textStyle" width="27%" >
                                    <b><font color="black" size="2"><%=caseStatus%></font></b>
                                </td>
                                <td nowrap class="blueBorder textStyle" width="23%" bgcolor="#CCCCCC">
                                    <p><b><%=sTypeMaintenance%></b></td>
                                <td nowrap class="blueBorder textStyle" width="27%" >
                                    <b><font color="black" size="2"><%=wboTrade.getAttribute("tradeName").toString()%></font></b>
                                </td>
                            </tr>
                            <%if (!(cause == null || cause.equalsIgnoreCase("UL") || cause.equalsIgnoreCase("null") || cause.equals("No Description"))) {%>
                            <tr>
                                <td nowrap colspan="2" class="blueBorder textStyle" width="23%" bgcolor="#CCCCCC">
                                    <p><b><%=causeDesc%></b>
                                </td>
                                <td nowrap colspan="2" class="blueBorder textStyle" width="27%" >
                                    <b><font color="black" size="2" ><%=cause%></font></b>
                                </td>
                            </tr>
                            <% }%>
                            <% if (inspectionVector.size() == 2) {
                                
    WebBusinessObject inspWbo=new WebBusinessObject();
    inspWbo=(WebBusinessObject)inspectionVector.get(1);
    %>
                            
                            <tr>
                                <td nowrap colspan="2" class="blueBorder textStyle" width="23%" bgcolor="#CCCCCC">
                                    <p><b><%=inspection%></b>
                                </td>
                                <td nowrap colspan="2" class="blueBorder textStyle" width="27%" >
                                    <b><font color="black" size="2" ><%=inspWbo.getAttribute("statusNote")%></font></b>
                                    <input type="hidden" name="statusNote" value="<%=inspWbo.getAttribute("statusNote")%>">
                                </td>
                            </tr>
                            <% }%>
                            <%if (reading != null) {%>
                            <tr>
                                <td nowrap colspan="2" class="blueBorder textStyle" width="23%" bgcolor="#CCCCCC">
                                    <b><%=readCounter%></b>
                                </td>
                                <td nowrap colspan="2" class="blueBorder textStyle" width="27%" >
                                    <b><font color="black" size="2" ><%=reading%>&ensp;<%=unit%></font></b>
                                </td>
                            </tr>
                            <% }%>

                            <tr>
                                <td nowrap colspan="2" class="blueBorder textStyle" width="23%" bgcolor="#CCCCCC">
                                    <b><%=unitNoStr%></b>
                                </td>
                                <td nowrap colspan="2" class="blueBorder textStyle" width="27%" >
                                    <b><font color="black" size="2" ><%=unitWbo.getAttribute("unitNo")%></font></b>
                                </td>
                            </tr>

                        </table>
                    </td>
                </tr>
                <% if (tasksList.size() != 0) {%>
                <tr>
                    <td nowrap colspan="4">
                        <br>
                        <div align="<%=divAlign%>">
                            <p dir="rtl" align="center" style="background-color: #E6E6FA;width:100%;text-align: divAlign"><b><%=sMaintenanceItem%></b></p>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td nowrap width="98%" colspan="4">
                        <TABLE WIDTH="100%" CELLPADDING="0" CELLSPACING="0" BORDER="1" dir="<%=dir%>" class="blueBorder">
                            <TR align="<%=align%>" bgcolor="#A0C0C0">
                                <td nowrap class="blueBorder blueHeaderTD">
                                    <b><%=spareTitle[0]%></b>
                                </td>
                                <td nowrap class="blueBorder blueHeaderTD">
                                    <b><%=sCodeMaintenanceItem%></b>
                                </td>
                                <td nowrap class="blueBorder blueHeaderTD">
                                    <b><%=sNameMaintenanceItem%></b>
                                </td>
                                <!--                                <td nowrap class="blueBorder blueHeaderTD">
                                                                    <b><%=strCost%></b>
                                                                </td>-->
                            </TR>
                            <%
                                 iTotal = 0;
                                 double taskCost = 0;
                                 totalCostTasks = 0.0;
                                 Enumeration x = tasksList.elements();
                                 while (x.hasMoreElements()) {
                                     taskCost = 0.0;
                                     iTotal++;
                                     tasksWbo = (WebBusinessObject) x.nextElement();

                                     try {
                                         taskCost = Double.valueOf((String) tasksWbo.getAttribute("totalCost")).doubleValue();
                                     } catch (Exception ex) {
                                     }
                                     totalCostTasks += taskCost;
                            %>
                            <TR>
                                <td nowrap align="<%=align%>" class="blueBorder blueBodyTD">
                                    <%=iTotal%>
                                </td>
                                <td nowrap width="40%" align="<%=align%>" class="blueBorder blueBodyTD">
                                    <%=tasksWbo.getAttribute("code")%>
                                </td>
                                <td nowrap width="40%" align="<%=align%>" class="blueBorder blueBodyTD">
                                    <%=tasksWbo.getAttribute("name")%>
                                </td>
<!--                                <td nowrap align="<%=align%>" class="blueBorder blueBodyTD">
                                <%=taskCost%>
                            </td>-->
                            </TR>
                            <% }%>
                            <!--                            <TR>
                                                            <td nowrap class="blueBorder blueHeaderTD" colspan="2" style="text-align:center;background-color: #D0D0D0;color: black;height: 25px">
                                                                <b><%=strCostTotal%></b>
                                                            </td>
                                                            <td nowrap class="blueBorder blueHeaderTD" colspan="2" style="text-align:center;background-color: #D0D0D0;color: black;height: 25px">
                                                                <b><%=totalCostTasks%></b>
                                                            </td>
                                                        </TR>-->
                        </TABLE>
                    </td>
                </tr>
                <% }%>


                <% if (itemList.size() != 0) {%>
                <tr>
                    <td nowrap colspan="4">
                        <br>
                        <div align="<%=divAlign%>">
                            <p dir="rtl" align="center" style="background-color: #E6E6FA;width:100%;text-align: divAlign"><b><%=sSpareParts%></b></p>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td nowrap width="98%" colspan="4">
                        <TABLE WIDTH="100%" CELLPADDING="0" CELLSPACING="0" dir="<%=dir%>" class="blueBorder">
                            <TR>
                                <% for (int i = 0; i < itemTitle.length; i++) {%>
                                <td nowrap STYLE="text-align:center;" class="blueBorder blueHeaderTD">
                                    <b><%=itemTitle[i]%></b>
                                </td>
                                <% }%>
                            </TR>
                            <%

                                 Enumeration e = itemList.elements();
                                 iTotal = 0;
                                 int index2 = 0;
                                 while (e.hasMoreElements()) {
                                     iTotal++;

                                     wbo = (WebBusinessObject) e.nextElement();
                                     String[] itemCode = wbo.getAttribute("itemId").toString().split("-");
                            %>
                            <TR>
                                <td nowrap class="blueBorder blueBodyTD" width="10%" STYLE="text-align:center;" align="<%=align%>">
                                    <b>&nbsp;<%=iTotal%> </b>
                                </td>
                                <td nowrap class="blueBorder blueBodyTD" width="30%" align="<%=align%>">
                                    <%=(String) wbo.getAttribute("itemId")%>
                                </td>
                                <td nowrap class="blueBorder blueBodyTD" width="30%" align="<%=align%>">
                                    <% if (itemCode.length > 1) {
                                         itemWbo = itemsMgr.getOnSingleKey(wbo.getAttribute("itemId").toString());
                                     } else {
                                         itemWbo = itemsMgr.getOnObjectByKey(wbo.getAttribute("itemId").toString());
                                     }

                                    try{
                                        name = (String) itemWbo.getAttribute("itemDscrptn");
                                    } catch (Exception ex) {
                                        name = "<font size = '3' style='background-color: red;' color = 'white'><img src = 'images/worning_yallow.jpg' />&nbsp;&nbsp;" + itemNameMsg + "</font>";
                                    }
                                    %>
                                    <%=name%>
                                </td>
                                <td nowrap class="blueBorder blueBodyTD" width="10%" align="<%=align%>">
                                    <%=(String) wbo.getAttribute("itemQuantity")%>
                                </td>

                                <%
                                 String costCenterName = null;
                                     String attValue = (String) wbo.getAttribute("attachedOn");

                                     if (!attValue.equals("2")) {
                                         CostCentersMgr costCenterMgr = CostCentersMgr.getInstance();
                                         WebBusinessObject costCenterWbo =  new WebBusinessObject();
                                         Vector costCentersVec = new Vector();
                                         try {
                                                 costCentersVec = costCenterMgr.getOnArbitraryKey(attValue, "key");
                                                 costCenterWbo = (WebBusinessObject) costCentersVec.elementAt(0);

                                         } catch (Exception exc) {
                                                 costCenterName = "<font size = '2' style='background-color: red;' color = 'white'><img src = 'images/worning_yallow.jpg' />&nbsp;&nbsp;Not Found</font>";
                                         }
                                         try {
                                             costCenterName = costCenterWbo.getAttribute(costNameField).toString();
                                         } catch (Exception ex) {
                                             costCenterName = "<font size = '2' style='background-color: red;' color = 'white'><img src = 'images/worning_yallow.jpg' />&nbsp;&nbsp;Not Found</font>";
                                         }
                                     } else {
                                         costCenterName = "<font size = '2' style='background-color: red;' color = 'white'><img src = 'images/worning_yallow.jpg' />&nbsp;&nbsp;Not Found</font>";
                                     }
                                %>
                                <td nowrap class="blueBorder blueBodyTD" width="30%" align="<%=align%>">
                                    <%=costCenterName%>
                                </td>

                                <%

                                 WebBusinessObject wbo2 = new WebBusinessObject();
                                 String cost = "";
                                 try{
                                     wbo2 = (WebBusinessObject) avgPrice.get(index2);
                                     if (wbo2.getAttribute("total") != null) {
                                         cost = (String) wbo2.getAttribute("total");
                                     } else {
                                         cost = "0";
                                     }
                                 }catch(Exception ex){
                                     cost = "0";
                                 }
                                 totalCostItems += Double.valueOf(cost);
                                 totalCost = Tools.getCurrency(Double.toString(totalCostItems));
                                 cost = Tools.getCurrency(cost);
                                 index2++;
                                 String price ="0";
                                %>
                                <%
                                try{
                                    price = (String) wbo2.getAttribute("price");
                                    if(price == null){
                                        price = "0";
                                    }
                                }catch(Exception ex){
                                    price = "0";
                                }
                                 price = Tools.getCurrency(price);
                                 %>
                                <td nowrap class="blueBorder blueBodyTD" width="20%" align="<%=align%>">
                                    <%=price%>
                                </td>
                                <td nowrap class="blueBorder blueBodyTD" width="20%" align="<%=align%>">
                                    <%=cost%>
                                </td>
                                <%}%>
                            </TR>


                            <TR>
                                <td nowrap class="blueBorder blueHeaderTD" colspan="2" style="text-align:center;background-color: #D0D0D0;color: black;height: 25px">
                                    <b><%=strItemsCostTotal%></b>
                                </td>
                                <td nowrap class="blueBorder blueHeaderTD" colspan="5" style="text-align:center;background-color: #D0D0D0;color: black;height: 25px">
                                    <b><%=totalCost%></b>
                                </td>
                            </TR>


                        </TABLE>
                    </td>
                </tr>
                <% }%>
                <% if (tasksList.size() != 0 && empList.size() > 0) {%>
                <tr>
                    <td nowrap colspan="4">
                        <br>
                        <div align="<%=divAlign%>">
                            <p dir="rtl" align="center" style="background-color: #E6E6FA;width:100%;text-align: divAlign"><b><%=sWorkers%></b></p>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td nowrap width="98%" colspan="4">
                        <TABLE WIDTH="100%" CELLPADDING="0" CELLSPACING="0" BORDER="1" dir="<%=dir%>" class="blueBorder">
                            <TR align="<%=align%>" bgcolor="#A0C0C0">
                                <td nowrap class="blueBorder blueHeaderTD">
                                    <b><%=spareTitle[0]%></b>
                                </td>
                                <td nowrap class="blueBorder blueHeaderTD">
                                    <b><%=sTimeOfWorkers%></b>
                                </td>
                                <td nowrap class="blueBorder blueHeaderTD">
                                    <b><%=sWorkerName%></b>
                                </td>
                                <td nowrap class="blueBorder blueHeaderTD">
                                    <b><%=strCost%></b>
                                </td>
                            </TR>
                            <%
                                 iTotal = 0;

                                 Enumeration en = empList.elements();
                                 while (en.hasMoreElements()) {
                                     iTotal++;
                                     laborCost = 0;
                                     empWbo = (WebBusinessObject) en.nextElement();

                                     try {
                                         laborCost = Double.valueOf((String) empWbo.getAttribute("totalCost")).doubleValue();
                                     } catch (Exception ex) {
                                     }
                                     totalCostLabors += laborCost;
                                     totalCostLabor = Tools.getCurrency(Double.toString(totalCostLabors));
                            %>
                            <TR>
                                <td nowrap align="<%=align%>" class="blueBorder blueBodyTD">
                                    <b> <%=iTotal%> </b>
                                </td>
                                <td nowrap align="<%=align%>" class="blueBorder blueBodyTD">
                                    <b> <%=empWbo.getAttribute("actualHours")%> </b>
                                </td>
                                <td nowrap align="<%=align%>" class="blueBorder blueBodyTD">
                                    <b> <%=empWbo.getAttribute("empName")%> </b>
                                </td>
                                <td nowrap align="<%=align%>" class="blueBorder blueBodyTD">
                                    <b> <%=laborCost%> </b>
                                </td>
                            </TR>
                            <% }%>
                            <TR>
                                <td nowrap class="blueBorder blueHeaderTD" colspan="2" style="text-align:center;background-color: #D0D0D0;color: black;height: 25px">
                                    <b><%=strLaborCostTotal%></b>
                                </td>
                                <td nowrap class="blueBorder blueHeaderTD" colspan="2" style="text-align:center;background-color: #D0D0D0;color: black;height: 25px">
                                    <b><%=totalCostLabor%></b>
                                </td>
                            </TR>
                        </TABLE>
                    </td>
                </tr>
                <% }%>
                <% if (complaintsList.size() != 0) {%>
                <tr>
                    <td nowrap colspan="4">
                        <br>
                        <div align="<%=divAlign%>">
                            <p dir="rtl" align="center" style="background-color: #E6E6FA;width:100%;text-align: divAlign"><b><%=sComplaintsWorkers%></b></p>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td nowrap width="98%" colspan="4">
                        <TABLE WIDTH="100%" CELLPADDING="0" CELLSPACING="0" BORDER="1" dir="<%=dir%>" class="blueBorder">
                            <TR align="<%=align%>" bgcolor="#A0C0C0">
                                <% for (int i = 0; i < complaintsTitle.length; i++) {%>
                                <td nowrap STYLE="text-align:center;" class="blueBorder blueHeaderTD">
                                    <b><%=complaintsTitle[i]%></b>
                                </td>
                                <% }%>
                            </TR>
                            <%
                                 Enumeration e = complaintsList.elements();
                                 WebBusinessObject comWbo = new WebBusinessObject();
                                 while (e.hasMoreElements()) {
                                     iTotal++;
                                     comWbo = (WebBusinessObject) e.nextElement();
                            %>
                            <TR>
                                <td nowrap WIDTH="10%" STYLE="text-align:center;" align="<%=align%>" class="blueBorder blueBodyTD">
                                    <b>&nbsp;<%=iTotal%> </b>
                                </td>
                                <td nowrap COLSPAN="2" align="<%=align%>" class="blueBorder blueBodyTD">
                                    <%=(String) comWbo.getAttribute("delayReason")%>
                                </td>
                            </TR>
                            <%
                                 }
                            %>
                        </TABLE>
                    </td>
                </tr>
                <% }%>
                <%
                            String action = null;
                            if (webIssueStatus != null) {
                                action = (String) webIssueStatus.getAttribute("actionTaken");
                            }
                            if (!(action == null || action.equalsIgnoreCase("UL") || action.equalsIgnoreCase("null"))) {
                %>
                <TR>
                    <td nowrap width="98%" colspan="4">
                        <br>
                        <TABLE WIDTH="100%" CELLPADDING="0" CELLSPACING="0" BORDER="1" dir="<%=dir%>"  class="blueBorder">
                            <tr>
                                <td nowrap width="25%" class="blueBorder blueHeaderTD textStyle" style="background-color: #D0D0D0;color: black;height: 20px">
                                    <b><%=actionTaken%></b>
                                </td>
                                <td nowrap width="75%" colspan="3" align="<%=align%>" class="blueBorder blueBodyTD textStyle" style="<%=style%>;padding-left:5px;padding-right:5px">
                                    <b><%=action%></b>
                                </td>
                            </tr>
                        </TABLE>
                    </td>
                </TR>
                <%}%>
                <%
                            String cost;
                            double jobOrderCosting = totalCostItems + totalCostLabors;
                            cost = Tools.getCurrency(Double.toString(jobOrderCosting));
                %>
                <TR>
                    <td nowrap width="98%" colspan="4">
                        <br>
                        <TABLE WIDTH="100%" CELLPADDING="0" CELLSPACING="0" BORDER="1" dir="<%=dir%>"  class="blueBorder">
                            <tr>
                                <td nowrap width="25%" class="blueBorder blueHeaderTD textStyle" style="background-color: #D0D0D0;color: black;height: 20px">
                                    <b><%=jobOrderCost%></b>
                                </td>
                                <td nowrap width="75%" colspan="3" align="<%=align%>" class="blueBorder blueBodyTD textStyle" style="<%=style%>;padding-left:5px;padding-right:5px">
                                    <b><%=cost%></b>
                                </td>
                            </tr>
                        </TABLE>
                    </td>
                </TR>
                <% if (webIssue.getAttribute("scheduleType").equals("External")) {%>
                <tr>
                    <td nowrap width="98%" colspan="4">&nbsp;
                    </td>
                </tr>
                <tr>
                    <td nowrap width="98%" colspan="4">
                        <TABLE WIDTH="100%" CELLPADDING="0" CELLSPACING="0" BORDER="1" dir="<%=dir%>" class="blueBorder">
                            <TR align="<%=align%>" bgcolor="#A0C0C0" style="color: #ffcc66">
                                
                                <td nowrap colspan="3" STYLE="text-align:center;" class="blueBorder blueHeaderTD">
                                    <b><%=sExternalMessage%></b>
                                </td>
                                
                            </TR>
                            <%
                                        Long iID = new Long(webIssue.getAttribute("id").toString());
                                        calendar = Calendar.getInstance();

                                        calendar.setTimeInMillis(iID.longValue());
                                        String sID = webIssue.getAttribute("id").toString().substring(9) + "/" + (calendar.getTime().getMonth() + 1) + "/" + (calendar.getTime().getYear() + 1900);
                                        WebBusinessObject wboSID = issueMgr.getOnSingleKey(webIssue.getAttribute("id").toString());
                                        String sBID = wboSID.getAttribute("businessID").toString() + "/" + wboSID.getAttribute("businessIDbyDate").toString();

                                            if (vecExternal.size() > 0) {
                                                WebBusinessObject wboExternal = (WebBusinessObject) vecExternal.get(0);
                                                WebBusinessObject wboSupplier = supplierMgr.getOnSingleKey((String) wboExternal.getAttribute("supplierID"));
                            %>
                            <TR>
                                <td nowrap width="25%" class="blueBorder blueHeaderTD textStyle" style="background-color: #D0D0D0;color: black;height: 20px">
                                    <b>&nbsp;<%=sReceivedBY%> </b>
                                </td>
                                <td nowrap COLSPAN="2" align="<%=align%>" class="blueBorder blueBodyTD">
                                    <%=(String) wboSupplier.getAttribute("name")%>
                                </td>
                            </TR>
                            <TR>
                                <td nowrap width="25%" class="blueBorder blueHeaderTD textStyle" style="background-color: #D0D0D0;color: black;height: 20px">
                                    <b>&nbsp;<%=sConversionDate%> </b>
                                </td>
                                <td nowrap COLSPAN="2" align="<%=align%>" class="blueBorder blueBodyTD">
                                    <%=(String) wboExternal.getAttribute("conversionDate")%>
                                </td>
                            </TR>
                            <TR>
                                <td nowrap width="25%" class="blueBorder blueHeaderTD textStyle" style="background-color: #D0D0D0;color: black;height: 20px">
                                    <b>&nbsp;<%=jobOrderCost%> </b>
                                </td>
                                <td nowrap COLSPAN="2" align="<%=align%>" class="blueBorder blueBodyTD">
                                    <%=(String) wboExternal.getAttribute("laborCost")%>
                                </td>
                            </TR>
                            <TR>
                                <td nowrap width="25%" class="blueBorder blueHeaderTD textStyle" style="background-color: #D0D0D0;color: black;height: 20px">
                                    <b>&nbsp;<%=externalType%> </b>
                                </td>
                                <td nowrap COLSPAN="2" align="<%=align%>" class="blueBorder blueBodyTD">
                                    <%if (wboExternal.getAttribute("externalType").equals(ExternalJobMgr.PART)) {%>
                                    <b><font color="#993333"><%=part%></font></b>
                                    <%} else {%>
                                    <b><font color="#993333"><%=total%></font></b>
                                    <%}%>
                                </td>
                            </TR>

                            <TR>
                                <td nowrap width="25%" class="blueBorder blueHeaderTD textStyle" style="background-color: #D0D0D0;color: black;height: 20px">
                                    <b>&nbsp;<%=sConversionReason%> </b>
                                </td>
                                <td nowrap COLSPAN="2" align="<%=align%>" class="blueBorder blueBodyTD">
                                    <%=wboExternal.getAttribute("reason")%>
                                </td>
                            </TR>
                            <% } %>
                        </TABLE>
                    </td>
                </tr>
                <% } %>
            </table>
        </FORM>


    </body>
</html>
