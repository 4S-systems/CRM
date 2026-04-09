<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*,com.tracker.app_constants.*, com.tracker.common.*, java.util.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants"%>
<%@ page import="com.silkworm.common.TimeServices,com.silkworm.jsptags.*,com.contractor.db_access.MaintainableMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="java.text.SimpleDateFormat"%>
<HTML>
<%
    MaintainableMgr maintainableMgr = MaintainableMgr.getInstance();
    IssueTypeMgr issueTypeMgr = IssueTypeMgr.getInstance();

    String tabFromRequest = request.getParameter("tab");
    int number = 0;
    String tab = (String) request.getSession().getAttribute("tabId");
   // if (tabFromRequest == null) {
        if (tab != null && !tab.equals("")) {
            number = Integer.parseInt(tab);
        }
 //   } else {
  //      number = 1;
 //   }

   int i=0;
    String[] tabClass ={"","","","","","","","","",""};
    String[]activeLink ={"","","","","","","","","",""};

     String activeDiv="tab_contents tab_contents_active";
     String nonActiveDiv="tab_contents";
     String active="active";
     
     if(tab !=null && !tab.equals("")){
     for(i=0;i<10;i++){
         if(i==number){
             tabClass[i]=activeDiv;
             activeLink[i]=active;
             }else{
             tabClass[i]=nonActiveDiv;
             activeLink[i]="";
             }
         }
     }else {
         for(i=0;i<10;i++){
         if(i==1){
             tabClass[i]=activeDiv;
             activeLink[i]=active;
             }else{
             tabClass[i]=nonActiveDiv;
             activeLink[i]="";
             }
         }
         }
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
    String cMode= (String) request.getSession().getAttribute("currentMode");
    String  stat=cMode;
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    String report;
    String dir;
    String equipOut,equipByJobOrder,planningJobOrder,spareParts,equipByNormalJobOrder,maintenanceBacklog,weeklyReport,jobOrderByWeek;
    String siteStatusReport,siteStatisticsPieChart,siteStatisticsBarChart,failureCodeStatistics;
    String jobOrder,equipments,workers,maintenanceItem,sparePart,planning,transactionEQ,statistics,variety;
    String week_report,jobOrder_week,failureCode_statistics;
    String weeklyJobOrder,weeklyJobOrderForEquip,monthlyJobOrder,monthlyJobOrderForEquip,ratioSuccessPlan,timeScheduleForEquipmentMaint,equipCase;
    String EquipmentsByMainType,MaintenanceItems,mainTypeCategories,equipmentMaintenanceTable,transEquipmentMaintenance;
    String maintenanceItemsStatistics,productionLineEquipments,equipTypes,EquipmentsBySite,monthlyOfYearJobOrder;
    String lang,sCancel,langCode;
    String monthlyOfYearJobOrderTip,weeklyReportTip,jobOrderByWeekTip,equipByJobOrderTip,maintenanceBacklogTip,equipByNormalJobOrderTip;
    String mainTypeCategoriesTip,equipTypesTip,equipCaseTip,EquipmentsByMainTypeTip,productionLineEquipmentsTip,EquipmentsBySiteTip;
    String maintenanceItemsStatisticsTip,MaintenanceItemsTip;
    String sparePartsTip;
    String planningJobOrderTip;
    String equipOutTip;
    String equipmentMaintenanceTableTip;
    if(stat.equals("En")){
         langCode="Ar";
         lang="   &#1593;&#1585;&#1576;&#1610;    ";
         sCancel="Cancel";
         dir="left";
         report= "Reports";
         equipOut="Equipment out of order";
         equipByJobOrder="Scheduled of Job order";
         planningJobOrder="Future planning";
         spareParts="Spare parts";
         equipByNormalJobOrder="Normal maintenance";
         maintenanceBacklog="job order backlog";
         weeklyReport="This Week";
         week_report="Weekly report";
         jobOrderByWeek="Job order by weeks";
         jobOrder_week="Job order by weeks";

         jobOrder ="Job Order";
         equipments="Equipments";
         workers ="Workers";
         maintenanceItem="Maintenance Item";
         sparePart ="Spare Parts";
         planning ="Planning";
         transactionEQ="Transaction EQ.";
         statistics="Statistics";
         variety="Variety";
         siteStatusReport="Site status report";
         siteStatisticsPieChart="Site statistics pie chart";
         siteStatisticsBarChart="Site statistics bar chart";
         failureCodeStatistics="Failure code statistics";
         failureCode_statistics="Failure code statistics";
         weeklyJobOrder ="weekly job order report";
         weeklyJobOrderForEquip= "Weekly job orders for EQ.";
         monthlyJobOrder = "Monthly job orders report";
         monthlyJobOrderForEquip="Monthly job orders for EQ.";
         ratioSuccessPlan = "Ratio success plan";
         timeScheduleForEquipmentMaint="Timetable for the maintenance";
         equipCase="Equipment by types";
         EquipmentsByMainType = "EQ. by Main Type";
         MaintenanceItems = "Maintenance Items";
         mainTypeCategories="Main Type Categories";
         equipmentMaintenanceTable = "Equipment Maintenance Table";
         transEquipmentMaintenance="Case of EQ. maintenance";
         maintenanceItemsStatistics="Diagram of maintenance items";
         productionLineEquipments="EQ. by Production Line";
         equipTypes="Equipment Types";
         EquipmentsBySite="Equipments By Site";
         monthlyOfYearJobOrder="Job Order Monthly Of year";
         monthlyOfYearJobOrderTip = "monthly report of job order by current year and previous year <br> for type equipment and basic type equipment ";
         weeklyReportTip="Weekly report of job order by current week and previous week <br> for type equipment and basic type equipment";
         jobOrderByWeekTip=" job order weekly ";
         equipByJobOrderTip=" Scheduled job orders <br> implemented and under implementation";
         maintenanceBacklogTip=" Maintenance of equipment <br> Delayed implementation date";
         equipByNormalJobOrderTip=" Regular job orders non scheduled <br> may be in cases of emergency";
         mainTypeCategoriesTip=" Basic types of equipment <br> brief and description";
         equipTypesTip="Types of equipments with description";
         equipCaseTip="Display equipments according to the type of equipment";
         EquipmentsByMainTypeTip="Display equipment according to basic types";
         productionLineEquipmentsTip=" Display equipment within production line ";
         EquipmentsBySiteTip=" Display equipment within site " ;
         maintenanceItemsStatisticsTip="Statistical items of maintenance according to job orders ";
         MaintenanceItemsTip=" Display items of maintenance according to equipments ";
         sparePartsTip="Display spare parts and search by name or code";
         planningJobOrderTip="Planning the future of the scheduled job orders ";
         equipOutTip="Equipment out of service for maintenance <br> Or not it is the start-up";
         equipmentMaintenanceTableTip="Scheduled maintenance of equipment<br>details time of implementation and Spare parts and maintenance items ";
         } else {
         langCode="En";
         sCancel = tGuide.getMessage("cancel");
         lang="English";
        dir="right";
        report = " &#1578;&#1602;&#1575;&#1585;&#1610;&#1585; ";
        equipOut=" &#1605;&#1593;&#1583;&#1575;&#1578; &#1582;&#1575;&#1585;&#1580; &#1575;&#1604;&#1582;&#1583;&#1605;&#1577; ";
        equipByJobOrder=" &#1571;&#1608;&#1575;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604; &#1575;&#1604;&#1605;&#1580;&#1583;&#1608;&#1604;&#1577; ";
        planningJobOrder=" &#1575;&#1604;&#1582;&#1591;&#1577; &#1575;&#1604;&#1605;&#1587;&#1578;&#1601;&#1576;&#1604;&#1610;&#1577; ";
        spareParts=" &#1578;&#1602;&#1585;&#1610;&#1585; &#1602;&#1591;&#1593; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585; ";
        equipByNormalJobOrder=" &#1571;&#1608;&#1575;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604; &#1575;&#1604;&#1593;&#1575;&#1583;&#1610;&#1577; ";
        maintenanceBacklog=" &#1571;&#1608;&#1575;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604; &#1575;&#1604;&#1605;&#1578;&#1571;&#1582;&#1585;&#1577; ";
        weeklyReport=" &#1607;&#1584;&#1575; &#1575;&#1604;&#1571;&#1587;&#1576;&#1608;&#1593; ";
        week_report=" &#1575;&#1604;&#1578;&#1602;&#1585;&#1610;&#1585; &#1575;&#1604;&#1571;&#1587;&#1576;&#1608;&#1593;&#1609; ";
        jobOrderByWeek=" &#1571;&#1608;&#1575;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604; &#1576;&#1575;&#1604;&#1571;&#1587;&#1576;&#1608;&#1593; ";
        jobOrder_week=" &#1578;&#1602;&#1585;&#1610;&#1585; &#1575;&#1608;&#1575;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604; &#1575;&#1604;&#1575;&#1587;&#1576;&#1608;&#1593;&#1610;&#1577; ";

        equipments=" &#1575;&#1604;&#1605;&#1593;&#1583;&#1575;&#1578; ";
        jobOrder=" &#1575;&#1608;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604; ";
        workers =" &#1575;&#1604;&#1593;&#1605;&#1575;&#1604;&#1577; ";
        maintenanceItem=" &#1576;&#1606;&#1608;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577; ";
        sparePart =" &#1602;&#1591;&#1593; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585; ";
        planning =" &#1575;&#1604;&#1582;&#1591;&#1577; ";
        transactionEQ=" &#1581;&#1585;&#1603;&#1577; &#1575;&#1604;&#1605;&#1593;&#1583;&#1575;&#1578; ";
        statistics=" &#1573;&#1581;&#1589;&#1575;&#1574;&#1610;&#1577; ";
        variety =" &#1605;&#1578;&#1606;&#1608;&#1593;&#1577; ";
        siteStatusReport=" &#1578;&#1602;&#1585;&#1610;&#1585; &#1593;&#1606; &#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1605;&#1608;&#1602;&#1593; ";
        siteStatisticsPieChart=" &#1573;&#1581;&#1589;&#1575;&#1574;&#1610;&#1575;&#1578; &#1575;&#1604;&#1605;&#1588;&#1585;&#1608;&#1593;  Pie Chart ";
        siteStatisticsBarChart=" &#1573;&#1581;&#1589;&#1575;&#1574;&#1610;&#1575;&#1578; &#1575;&#1604;&#1605;&#1588;&#1585;&#1608;&#1593;   Bar Chart ";
        failureCodeStatistics=" &#1573;&#1581;&#1589;&#1575;&#1574;&#1610;&#1575;&#1578; &#1571;&#1603;&#1608;&#1575;&#1583; &#1575;&#1604;&#1571;&#1593;&#1591;&#1575;&#1604; ";
        failureCode_statistics=" &#1573;&#1581;&#1589;&#1575;&#1574;&#1610;&#1575;&#1578; &#1571;&#1603;&#1608;&#1575;&#1583; &#1575;&#1604;&#1571;&#1593;&#1591;&#1575;&#1604; ";
        weeklyJobOrder =" &#1593;&#1585;&#1590; &#1575;&#1587;&#1576;&#1608;&#1593;&#1609; &#1604;&#1575;&#1608;&#1575;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604; ";
        weeklyJobOrderForEquip= " &#1575;&#1608;&#1575;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604; &#1604;&#1605;&#1575;&#1603;&#1610;&#1606;&#1577; &#1575;&#1587;&#1576;&#1608;&#1593;&#1610;&#1575; ";
        monthlyJobOrder = "&#1578;&#1602;&#1585;&#1610;&#1585; &#1575;&#1608;&#1575;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604; &#1575;&#1604;&#1588;&#1607;&#1585;&#1610;&#1577; ";
        monthlyJobOrderForEquip=" &#1578;&#1602;&#1585;&#1610;&#1585; &#1575;&#1608;&#1575;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604; &#1604;&#1605;&#1575;&#1603;&#1610;&#1606;&#1577; &#1588;&#1607;&#1585;&#1610;&#1575; ";
        ratioSuccessPlan = " &#1606;&#1587;&#1576;&#1577; &#1606;&#1580;&#1575;&#1581; &#1575;&#1604;&#1582;&#1591;&#1577; ";
        timeScheduleForEquipmentMaint=" &#1575;&#1604;&#1580;&#1583;&#1608;&#1604; &#1575;&#1604;&#1586;&#1605;&#1606;&#1609; &#1604;&#1589;&#1610;&#1575;&#1606;&#1607; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577; ";
        equipCase=" &#1575;&#1604;&#1605;&#1593;&#1583;&#1575;&#1578; &#1581;&#1587;&#1576; &#1575;&#1604;&#1606;&#1608;&#1593; ";
        EquipmentsByMainType = "&#1575;&#1604;&#1605;&#1593;&#1583;&#1575;&#1578; &#1581;&#1587;&#1576; &#1575;&#1604;&#1606;&#1608;&#1593; &#1575;&#1604;&#1575;&#1587;&#1575;&#1587;&#1609; ";
        MaintenanceItems = " &#1576;&#1606;&#1608;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577; &#1604;&#1606;&#1608;&#1593; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577; ";
        mainTypeCategories=" &#1575;&#1604;&#1571;&#1606;&#1608;&#1575;&#1593; &#1575;&#1604;&#1571;&#1587;&#1575;&#1587;&#1610;&#1577; &#1604;&#1604;&#1605;&#1593;&#1583;&#1575;&#1578; ";
        equipmentMaintenanceTable=" &#1580;&#1583;&#1575;&#1608;&#1604; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577; &#1604;&#1604;&#1605;&#1593;&#1583;&#1575;&#1578; ";
        transEquipmentMaintenance=" &#1581;&#1585;&#1603;&#1577; &#1589;&#1610;&#1575;&#1606;&#1577; &#1575;&#1604;&#1605;&#1593;&#1583;&#1575;&#1578; ";
        maintenanceItemsStatistics=" &#1575;&#1604;&#1605;&#1606;&#1581;&#1606;&#1609; &#1575;&#1604;&#1578;&#1603;&#1585;&#1575;&#1585;&#1609; &#1604;&#1576;&#1606;&#1608;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1607; ";
        productionLineEquipments=" &#1575;&#1604;&#1605;&#1593;&#1583;&#1575;&#1578; &#1581;&#1587;&#1576; &#1582;&#1591;&#1608;&#1591; &#1575;&#1604;&#1573;&#1606;&#1578;&#1575;&#1580; ";
        equipTypes=" &#1571;&#1606;&#1608;&#1575;&#1593; &#1575;&#1604;&#1605;&#1593;&#1583;&#1575;&#1578; ";
        EquipmentsBySite=" &#1575;&#1604;&#1605;&#1593;&#1583;&#1575;&#1578; &#1581;&#1587;&#1576; &#1575;&#1604;&#1605;&#1608;&#1602;&#1593; ";
        monthlyOfYearJobOrder=" &#1571;&#1608;&#1575;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604; &#1575;&#1604;&#1588;&#1607;&#1585;&#1610;&#1577; ";
        monthlyOfYearJobOrderTip = "&#1607;&#1584;&#1575; &#1575;&#1604;&#1578;&#1602;&#1585;&#1610;&#1585; &#1610;&#1593;&#1591;&#1610;&#1603; &#1571;&#1608;&#1575;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604; &#1575;&#1604;&#1588;&#1607;&#1585;&#1610;&#1577; &#1593;&#1604;&#1609; &#1575;&#1606;&#1608;&#1575;&#1593; &#1575;&#1604;&#1605;&#1593;&#1583;&#1575;&#1578;<br>&#1608;&#1575;&#1604;&#1575;&#1606;&#1608;&#1575;&#1593; &#1575;&#1604;&#1575;&#1587;&#1575;&#1587;&#1610;&#1577; &#1604;&#1607;&#1575; &#1582;&#1604;&#1575;&#1604; &#1575;&#1604;&#1587;&#1606;&#1577; &#1575;&#1604;&#1581;&#1575;&#1604;&#1610;&#1577; &#1608;&#1575;&#1604;&#1605;&#1575;&#1590;&#1610;&#1577;&nbsp; ";
        weeklyReportTip=" &#1578;&#1602;&#1585;&#1610;&#1585; &#1571;&#1608;&#1575;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604; &#1593;&#1604;&#1609; &#1575;&#1606;&#1608;&#1575;&#1593; &#1575;&#1604;&#1605;&#1593;&#1583;&#1575;&#1578; <br> &#1608;&#1575;&#1604;&#1575;&#1606;&#1608;&#1575;&#1593; &#1575;&#1604;&#1575;&#1587;&#1575;&#1587;&#1610;&#1577; &#1604;&#1607;&#1575; &#1582;&#1604;&#1575;&#1604; &#1575;&#1604;&#1571;&#1587;&#1576;&#1608;&#1593; &#1575;&#1604;&#1581;&#1575;&#1604;&#1610; &#1608;&#1575;&#1604;&#1587;&#1575;&#1576;&#1602; ";
        jobOrderByWeekTip=" &#1571;&#1608;&#1575;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604; &#1571;&#1587;&#1576;&#1608;&#1593;&#1610;&#1575; ";
        equipByJobOrderTip=" &#1578;&#1602;&#1585;&#1610;&#1585; &#1571;&#1608;&#1575;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604; &#1575;&#1604;&#1605;&#1580;&#1583;&#1608;&#1604;&#1577;<br>&#1575;&#1604;&#1605;&#1606;&#1601;&#1584;&#1577; &#1608;&#1575;&#1604;&#1578;&#1609; &#1578;&#1581;&#1578; &#1575;&#1604;&#1578;&#1606;&#1601;&#1610;&#1584; ";
        maintenanceBacklogTip=" &#1578;&#1602;&#1585;&#1610;&#1585; &#1571;&#1608;&#1575;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604; &#1575;&#1604;&#1605;&#1580;&#1583;&#1608;&#1604;&#1577; <br> &#1575;&#1604;&#1578;&#1609; &#1578;&#1571;&#1582;&#1585; &#1605;&#1610;&#1593;&#1575;&#1583; &#1578;&#1606;&#1601;&#1610;&#1584;&#1607;&#1575; ";
        equipByNormalJobOrderTip="  &#1571;&#1608;&#1575;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604; &#1575;&#1604;&#1593;&#1575;&#1583;&#1610;&#1577; &#1594;&#1610;&#1585; &#1575;&#1604;&#1605;&#1580;&#1583;&#1608;&#1604;&#1577; <br> &#1602;&#1583; &#1578;&#1578;&#1605; &#1601;&#1609; &#1581;&#1575;&#1604;&#1575;&#1578; &#1575;&#1604;&#1591;&#1608;&#1575;&#1585;&#1574; ";
        mainTypeCategoriesTip=" &#1593;&#1585;&#1590; &#1604;&#1604;&#1571;&#1606;&#1608;&#1575;&#1593; &#1575;&#1604;&#1571;&#1587;&#1575;&#1587;&#1610;&#1577; &#1604;&#1604;&#1605;&#1593;&#1583;&#1575;&#1578; <br> &#1575;&#1604;&#1573;&#1582;&#1578;&#1589;&#1575;&#1585; &#1608;&#1575;&#1604;&#1608;&#1589;&#1601; ";
        equipTypesTip="&#1593;&#1585;&#1590; &#1571;&#1606;&#1608;&#1575;&#1593; &#1575;&#1604;&#1605;&#1593;&#1583;&#1575;&#1578; &#1608;&#1608;&#1589;&#1601;&#1607;&#1575; ";
        equipCaseTip="&#1593;&#1585;&#1590; &#1575;&#1604;&#1605;&#1593;&#1583;&#1575;&#1578; &#1591;&#1576;&#1602;&#1575; &#1604;&#1606;&#1608;&#1593; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577;  ";
        EquipmentsByMainTypeTip=" &#1593;&#1585;&#1590; &#1575;&#1604;&#1605;&#1593;&#1583;&#1575;&#1578; &#1591;&#1576;&#1602;&#1575; &#1604;&#1604;&#1606;&#1608;&#1593; &#1575;&#1604;&#1571;&#1587;&#1575;&#1587;&#1609; ";
        productionLineEquipmentsTip=" &#1593;&#1585;&#1590; &#1575;&#1604;&#1605;&#1593;&#1583;&#1575;&#1578; &#1591;&#1576;&#1602;&#1575; &#1604;&#1582;&#1591; &#1575;&#1604;&#1573;&#1606;&#1578;&#1575;&#1580; &#1575;&#1604;&#1605;&#1606;&#1583;&#1585;&#1580;&#1577; &#1576;&#1607; ";
        EquipmentsBySiteTip=" &#1593;&#1585;&#1590; &#1575;&#1604;&#1605;&#1593;&#1583;&#1575;&#1578; &#1591;&#1576;&#1602;&#1575; &#1604;&#1605;&#1608;&#1602;&#1593; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577; ";
        maintenanceItemsStatisticsTip=" &#1573;&#1581;&#1589;&#1575;&#1574;&#1610;&#1577; &#1576;&#1606;&#1608;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577; &#1591;&#1576;&#1602;&#1575; &#1604;&#1571;&#1608;&#1575;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604; ";
        MaintenanceItemsTip=" &#1593;&#1585;&#1590; &#1576;&#1606;&#1608;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577; &#1591;&#1576;&#1602;&#1575;&#1611; &#1604;&#1604;&#1605;&#1593;&#1583;&#1577; ";
        sparePartsTip="&#1593;&#1585;&#1590; &#1602;&#1591;&#1593; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585; &#1575;&#1608; &#1575;&#1604;&#1576;&#1581;&#1579; &#1593;&#1606;&#1607;&#1575; &#1576;&#1575;&#1604;&#1573;&#1587;&#1605; &#1575;&#1608; &#1575;&#1604;&#1603;&#1608;&#1583; ";
        planningJobOrderTip=" &#1575;&#1604;&#1578;&#1582;&#1591;&#1610;&#1591; &#1575;&#1604;&#1605;&#1587;&#1578;&#1602;&#1576;&#1604;&#1609; &#1604;&#1571;&#1608;&#1575;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604; &#1575;&#1604;&#1605;&#1580;&#1583;&#1608;&#1604;&#1577; ";
        equipOutTip="&#1605;&#1593;&#1583;&#1575;&#1578; &#1582;&#1575;&#1585;&#1580; &#1575;&#1604;&#1582;&#1583;&#1605;&#1577; &#1604;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577; <br> &#1571;&#1608; &#1604;&#1605; &#1610;&#1571;&#1578;&#1609; &#1576;&#1583;&#1569; &#1575;&#1604;&#1578;&#1588;&#1594;&#1610;&#1604; &#1604;&#1607;&#1575; ";
        equipmentMaintenanceTableTip=" &#1580;&#1583;&#1575;&#1608;&#1604; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577; &#1575;&#1604;&#1605;&#1602;&#1585;&#1585;&#1577; &#1604;&#1604;&#1605;&#1593;&#1583;&#1575;&#1578;<br> &#1605;&#1578;&#1590;&#1605;&#1606; &#1608;&#1602;&#1578; &#1575;&#1604;&#1578;&#1606;&#1601;&#1610;&#1584; &#1608;&#1602;&#1591;&#1593; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585; &#1608;&#1576;&#1606;&#1608;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
         }

%>
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Expires" CONTENT="0">

<HEAD>
<TITLE>Doc Viewer- Select Project and Status</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="css/CSS.css">
<link rel="stylesheet" type="text/css" href="css/epoch_styles.css" />
<script type="text/javascript" src="js/epoch_classes.js"></script>
<script type="text/javascript" src="js/jquery-1.2.6.min.js"></script>

<script type="text/javascript">
    function openWindow(url)
    {
        window.open(url,"_blank","toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=no, copyhistory=no, width=800, height=800");
    }

    function openWindow(url)
    {
        window.open(url,"_blank","toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=no, copyhistory=no, width=800, height=800");
    }

function test(id){
   
    var url2 = "<%=context%>/ReportsServlet?op=setValueSession&tabId="+id;
    
    if (window.XMLHttpRequest) {
        req = new XMLHttpRequest( );
    }
    else if (window.ActiveXObject) {
        req = new ActiveXObject("Microsoft.XMLHTTP");
    }
     
    req.open("post",url2,true);
    req.send(null);
 }

 function cancelForm()
        {
            document.ISSUE_FORM.action = "main.jsp";
            document.ISSUE_FORM.submit();
        }
</script>
<style type="text/css">
/* create a button look for links */
a#mainLink{
background-color: #DFDFDF;
border: solid 1px;
border-color: #99f #039 #039 #99f;
color:#000080;
font-family: arial,sans-serif;
font-size: 8pt;
font-weight: bold;
letter-spacing: 1px;
padding: 3px;
text-decoration: none;
text-align: center;
line-height: 1.5;
width: 210;
margin-right: 2px;
}

a#mainLink:hover
{   background-color: #39c; color: white;}

</style>

<script type="text/javascript">
// Load this script when page loads
$(document).ready(function(){

 // Set up a listener so that when anything with a class of 'tab'
 // is clicked, this function is run.
 $('.tab').click(function () {

  // Remove the 'active' class from the active tab.
  $('#tabs_container > .tabs > li.active')
	  .removeClass('active');

  // Add the 'active' class to the clicked tab.
  $(this).parent().addClass('active');

  // Remove the 'tab_contents_active' class from the visible tab contents.
  $('#tabs_container > .tab_contents_container > div.tab_contents_active')
	  .removeClass('tab_contents_active');

  // Add the 'tab_contents_active' class to the associated tab contents.
  $(this.rel).addClass('tab_contents_active');

 });
});
</script>

<style type="text/css">
a:active {
	outline: none;
}
a:focus {
	-moz-outline-style: none;
}
#tabs_container {
	
    width: 400px;
	font-family: Arial, Helvetica, sans-serif;
	font-size: 15px;
}
#tabs_container ul.tabs {
	list-style: none;
	border-bottom: 1px solid #000000;
	height: 21px;
	margin: 0;
    width: 800px;
}
#tabs_container ul.tabs li {
	float: <%=dir%>;
}
#tabs_container ul.tabs li a {
	padding: 3px 10px;
    font-size:12px;
    font-weight:bold;
	display: block;
	border-left: 1px solid #000080;
	border-top: 1px solid #000080;
	border-right: 1px solid #000080;
	margin-right: 0px;
	text-decoration: none;
	background-color: #FFFACD;
}
#tabs_container ul.tabs li.active a {
	background-color: #FF9900;
	padding-top: 4px;
}
div.tab_contents_container {
    width: 800px;
	border: 1px solid #FFFFFF;
	border-top: none;
	padding: 10px;
    
}
div.tab_contents {
    
	display: none;
}
div.tab_contents_active {
   
	display: block;
}
div.clear {
	clear: both;
}
</style>

</HEAD>
<BODY>
<script type="text/javascript" src="js/wz_tooltip.js"></script>


<FORM NAME="ISSUE_FORM" METHOD="POST">
    <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
   <button  onclick="JavaScript: cancelForm();" class="button"><%=sCancel%> <IMG VALIGN="BOTTOM" SRC="images/cancel.gif"> </button> <br>
     <table align="center" width="80%">
        <tr><td class="td">
                <fieldset style="border:solid 2px;;border-color:#000080;">
                    <legend align="center">
                        <table dir="<%=dir%>" align="center">
                            <tr>
                                <td class="td">
                                    <font color="blue" size="6">
                                        <%=report%>
                                    </font>
                                </td>
                            </tr>
                        </table>
                    </legend>
             <!-- This is the box that all of the tabs and contents of
             the tabs will reside -->
    <div id="tabs_container" align="center">

          <!-- These are the tabs -->
          <ul class="tabs">
            <li class="<%=activeLink[1]%>"><a href="#" rel="#tab_1_contents" class="tab" onclick="javascript:test('1');"><%=jobOrder%></a></li>
            <li class="<%=activeLink[2]%>"><a href="#" rel="#tab_2_contents" class="tab" onclick="javascript:test('2');"><%=equipments%></a></li>
            <li class="<%=activeLink[3]%>"><a href="#" rel="#tab_3_contents" class="tab" onclick="javascript:test('3');"><%=workers%></a></li>
            <li class="<%=activeLink[4]%>"><a href="#" rel="#tab_4_contents" class="tab" onclick="javascript:test('4');"><%=maintenanceItem%></a></li>
            <li class="<%=activeLink[5]%>"><a href="#" rel="#tab_5_contents" class="tab" onclick="javascript:test('5');"><%=sparePart%></a></li>
            <li class="<%=activeLink[6]%>"><a href="#" rel="#tab_6_contents" class="tab" onclick="javascript:test('6');"><%=planning%></a></li>
            <li class="<%=activeLink[7]%>"><a href="#" rel="#tab_7_contents" class="tab" onclick="javascript:test('7');"><%=transactionEQ%></a></li>
            <li class="<%=activeLink[8]%>"><a href="#" rel="#tab_8_contents" class="tab" onclick="javascript:test('8');"><%=statistics%></a></li>
            <li class="<%=activeLink[9]%>"><a href="#" rel="#tab_9_contents" class="tab" onclick="javascript:test('9');"><%=variety%></a></li>
          </ul>

          <!-- This is used so the contents don't appear to the
               right of the tabs -->
          <div class="clear" align="center"></div>

          <!-- This is a div that hold all the tabbed contents -->
          <div class="tab_contents_container" align="center">

                    <!-- First Tab (Job Order)-->
                    <div align="center" id="tab_1_contents" class="<%=tabClass[1]%>">
                    <table><tr>
                    <td class="td">
                    <div align="center">
                     <a id="mainLink" href="<%=context%>/ReportsServlet?op=getEqJOReportForm&schedule=yes" onmouseover="Tip('<%=equipByJobOrderTip%>',CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#ffff99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7,TEXTALIGN ,'CENTER', TITLE ,'<%=equipByJobOrder%>',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'White', TITLEBGCOLOR ,'#FF9900')" onmouseout="UnTip()"><%=equipByJobOrder%></a>
                     <a id="mainLink" href="<%=context%>/ReportsServlet?op=jobOrderPerWeekMain" onmouseover="Tip('<%=jobOrderByWeekTip%>',CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#ffff99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7,TEXTALIGN ,'CENTER', TITLE ,'<%=jobOrderByWeek%>',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'White', TITLEBGCOLOR ,'#FF9900')" onmouseout="UnTip()"><%=jobOrderByWeek%></a>
                     <a id="mainLink" href="<%=context%>/ReportsServlet?op=jobOrderTypeMain" onmouseover="Tip('<%=weeklyReportTip%>',CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#ffff99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7,TEXTALIGN ,'CENTER', TITLE ,'<%=weeklyReport%>',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'White', TITLEBGCOLOR ,'#FF9900')" onmouseout="UnTip()"><%=weeklyReport%></a>
                     </div>
                    </td></tr>
                    <tr><td class="td">
                    <div align="center">
                    <a id="mainLink" href="<%=context%>/ReportsServlet?op=getEqJOReportByEmgForm&schedule=yes" onmouseover="Tip('<%=equipByNormalJobOrderTip%>',CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#ffff99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7,TEXTALIGN ,'CENTER', TITLE ,'<%=equipByNormalJobOrder%>',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'White', TITLEBGCOLOR ,'#FF9900')"  onmouseout="UnTip()"><%=equipByNormalJobOrder%></a>
                    <a id="mainLink" href="<%=context%>/ReportsServlet?op=searchFromPlan" onmouseover="Tip('<%=maintenanceBacklogTip%>',CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#ffff99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7,TEXTALIGN ,'CENTER', TITLE ,'<%=maintenanceBacklog%>',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'White', TITLEBGCOLOR ,'#FF9900')"  onmouseout="UnTip()"><%=maintenanceBacklog%></a>
                    <a id="mainLink" href="<%=context%>/ReportsServlet?op=getJobOrderbyMonthOfYearForm" onmouseover="Tip('<%=monthlyOfYearJobOrderTip%>',CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#ffff99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7,TEXTALIGN ,'CENTER', TITLE ,'<%=monthlyOfYearJobOrder%>',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'White', TITLEBGCOLOR ,'#FF9900')"  onmouseout="UnTip()"><%=monthlyOfYearJobOrder%></a>

                    </div>
                    </td></tr></table>
                    </div>

                   <!-- Second Tab (Equipments)-->                  
                    <div align="center" id="tab_2_contents" class="<%=tabClass[2]%>">
                    <table><tr>
                    <td class="td">
                    <div align="center">
                    <a id="mainLink" href="<%=context%>/EquipmentServlet?op=selectEqReport" onmouseover="Tip('<%=equipCaseTip%>',CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#ffff99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7,TEXTALIGN ,'CENTER', TITLE ,'<%=equipCase%>',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'White', TITLEBGCOLOR ,'#FF9900')"  onmouseout="UnTip()"><%=equipCase%></a>
                    <a id="mainLink" href="<%=context%>/ReportsServlet?op=getEquipmentTypeReport" onmouseover="Tip('<%=equipTypesTip%>',CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#ffff99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7,TEXTALIGN ,'CENTER', TITLE ,'<%=equipTypes%>',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'White', TITLEBGCOLOR ,'#FF9900')"  onmouseout="UnTip()"><%=equipTypes%></a>
                    <a id="mainLink" href="<%=context%>/EquipmentServlet?op=mainCategoriesReport" onmouseover="Tip('<%=mainTypeCategoriesTip%>',CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#ffff99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7,TEXTALIGN ,'CENTER', TITLE ,'<%=mainTypeCategories%>',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'White', TITLEBGCOLOR ,'#FF9900')"  onmouseout="UnTip()"><%=mainTypeCategories%></a>

                    </div>
                    </td></tr>
                    <tr>
                    <td class="td">
                    <div align="center">
                    <!--a id="mainLink" href="<%=context%>/ReportsServlet?op=getEqJOReportForm&schedule=yes" ><%=equipByJobOrder%></a-->
                    <!--a id="mainLink" href="JavaScript:openWindow('ReportsServlet?op=equipmentOutOfWorkReport');"><%=equipOut%></a-->
                    <a id="mainLink" href="<%=context%>/ReportsServlet?op=selectEqReportBySite" onmouseover="Tip('<%=EquipmentsBySiteTip%>',CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#ffff99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7,TEXTALIGN ,'CENTER', TITLE ,'<%=EquipmentsBySite%>',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'White', TITLEBGCOLOR ,'#FF9900')"  onmouseout="UnTip()"><%=EquipmentsBySite%></a>
                    <a id="mainLink" href="<%=context%>/EquipmentServlet?op=GetProductionLineReportForm" onmouseover="Tip('<%=productionLineEquipmentsTip%>',CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#ffff99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7,TEXTALIGN ,'CENTER', TITLE ,'<%=productionLineEquipments%>',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'White', TITLEBGCOLOR ,'#FF9900')"  onmouseout="UnTip()"><%=productionLineEquipments%></a>
                    <a id="mainLink" href="<%=context%>/ReportsServlet?op=selectEqReportByMainType" onmouseover="Tip('<%=EquipmentsByMainTypeTip%>',CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#ffff99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7,TEXTALIGN ,'CENTER', TITLE ,'<%=EquipmentsByMainType%>',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'White', TITLEBGCOLOR ,'#FF9900')"  onmouseout="UnTip()"><%=EquipmentsByMainType%></a>
                    <!--a id="mainLink" href="<%=context%>/EquipmentServlet?op=getEqTableReportForm&EqReadReport=no"><%=equipmentMaintenanceTable%></a-->
                  </div>
                    </td></tr>
                     <!--tr>
                    <td class="td">
                    <div align="center">
                     <a id="mainLink" href="<%=context%>/EquipmentServlet?op=getEqTableReportForm&EqReadReport=yes"><%=transEquipmentMaintenance%></a>
                      </div>
                    </td></tr-->
                    </table>
                    </div>

                   <!-- Third Tab (Workers)-->                   
                    
                    <div align="center" id="tab_3_contents" class="<%=tabClass[3]%>">
                    <table><tr>
                    <td class="td">
                    <div align="center">
                   <font size="5" color="red"><b>Under Constraction</b></font>
                   </div>
                    </td></tr></table>
                    </div>

                   <!-- Forth Tab (Maintenance Item)-->
                   <div align="center" id="tab_4_contents" class="<%=tabClass[4]%>">
                   <table><tr>
                    <td class="td">
                    <div align="center">
                    <a id="mainLink" href="<%=context%>/TaskServlet?op=getItemsReportForm" onmouseover="Tip('<%=MaintenanceItemsTip%>',CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#ffff99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7,TEXTALIGN ,'CENTER', TITLE ,'<%=MaintenanceItems%>',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'White', TITLEBGCOLOR ,'#FF9900')"  onmouseout="UnTip()"><%=MaintenanceItems%></a>
                    <a id="mainLink" href="<%=context%>/EquipmentServlet?op=MaintenanceItemsReport" onmouseover="Tip('<%=maintenanceItemsStatisticsTip%>',CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#ffff99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7,TEXTALIGN ,'CENTER', TITLE ,'<%=maintenanceItemsStatistics%>',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'White', TITLEBGCOLOR ,'#FF9900')"  onmouseout="UnTip()"><%=maintenanceItemsStatistics%></a>
                    </div>
                    </td></tr></table>
                    </div>
                   <!-- Fifth Tab (Spare Parts)-->

                    <div align="center" id="tab_5_contents" class="<%=tabClass[5]%>">
                    <table><tr>
                    <td class="td">
                    <div align="center">
                    <a id="mainLink" href="<%=context%>/ReportsServlet?op=searchItems" onmouseover="Tip('<%=sparePartsTip%>',CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#ffff99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7,TEXTALIGN ,'CENTER', TITLE ,'<%=spareParts%>',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'White', TITLEBGCOLOR ,'#FF9900')"  onmouseout="UnTip()"><%=spareParts%></a>
                    </div>
                    </td></tr></table>
                    </div>

                   <!-- Sixth Tab (Planning)-->
                   <div align="center" id="tab_6_contents" class="<%=tabClass[6]%>">
                    <table><tr>
                    <td class="td">
                    <div align="center">
                    <a id="mainLink" href="<%=context%>/ReportsServlet?op=getFutureEqJOReportForm&schedule=yes" onmouseover="Tip('<%=planningJobOrderTip%>',CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#ffff99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7,TEXTALIGN ,'CENTER', TITLE ,'<%=planningJobOrder%>',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'White', TITLEBGCOLOR ,'#FF9900')"  onmouseout="UnTip()"><%=planningJobOrder%></a>
                    </div>
                    </td></tr></table>
                    </div>

                   <!-- Seventh Tab (Transaction EQ.)-->
                    <div align="center" id="tab_7_contents" class="<%=tabClass[7]%>">
                    <table><tr>
                    <td class="td">
                    <div align="center">
                    <a id="mainLink" href="JavaScript:openWindow('ReportsServlet?op=equipmentOutOfWorkReport');" onmouseover="Tip('<%=equipOutTip%>',CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#ffff99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7,TEXTALIGN ,'CENTER', TITLE ,'<%=equipOut%>',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'White', TITLEBGCOLOR ,'#FF9900')"  onmouseout="UnTip()"><%=equipOut%></a>
                    <a id="mainLink" href="<%=context%>/EquipmentServlet?op=getEqTableReportForm&EqReadReport=yes"><%=transEquipmentMaintenance%></a>

                    </div>
                    </td></tr></table>
                    </div>

                   <!-- Eighth Tab (Statistics)-->
                    <div align="center" id="tab_8_contents" class="<%=tabClass[8]%>">
                    <table><tr>
                    <td class="td">
                    <div align="center">
                    <a id="mainLink" href="<%=context%>/SearchServlet?op=Projects&type=Status" ><%=siteStatusReport%></a>
                    <a id="mainLink" href="<%=context%>/SearchServlet?op=Projects&type=Statistics&chart=pie" ><%=siteStatisticsPieChart%></a>
                    <a id="mainLink" href="<%=context%>/SearchServlet?op=Projects&type=Statistics&chart=bar"><%=siteStatisticsBarChart%></a>
                    </div>
                    </td></tr>
                    <tr><td class="td">
                    <div align="center">
                    <a id="mainLink" href="<%=context%>/SearchServlet?op=FailureCodeChart"><%=failureCode_statistics%></a>
                    <a id="mainLink" href="<%=context%>/ReportsServlet?op=jobOrderTypeMain"><%=week_report%></a>
                    <a id="mainLink" href="<%=context%>/ReportsServlet?op=jobOrderPerWeekMain"><%=jobOrder_week%></a>
                    </div>
                    </td></tr>
                    <tr><td class="td">
                    <div align="center">
                    <a id="mainLink" href="<%=context%>/SearchServlet?op=JobOrderReport"><%=weeklyJobOrder%></a>
                    <a id="mainLink" href="<%=context%>/SearchServlet?op=JobOrderReportByEquip"><%=weeklyJobOrderForEquip%></a>
                    <a id="mainLink" href="<%=context%>/SearchServlet?op=JobOrderReportByMonth"><%=monthlyJobOrder%></a>
                    </div>
                    </td></tr>
                    <tr><td class="td">
                    <div align="center">
                    <a id="mainLink" href="<%=context%>/SearchServlet?op=JobOrderReportByEquipByMonth"><%=monthlyJobOrderForEquip%></a>
                    <a id="mainLink" href="<%=context%>/SearchServlet?op=RatioSuccess"><%=ratioSuccessPlan%></a>
                    <a id="mainLink" href="<%=context%>/ScheduleServlet?op=GetEqpScheduleCalendar&peroid=currentMonth"><%=timeScheduleForEquipmentMaint%></a>
                    </div>
                    </td></tr>
                    <tr><td class="td">
                    <div align="center">
                    <a id="mainLink" href="<%=context%>/EquipmentServlet?op=MaintenanceItemsReport" onmouseover="Tip('<%=maintenanceItemsStatisticsTip%>',CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#ffff99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7,TEXTALIGN ,'CENTER', TITLE ,'<%=maintenanceItemsStatistics%>',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'White', TITLEBGCOLOR ,'#FF9900')"  onmouseout="UnTip()"><%=maintenanceItemsStatistics%></a>
                    </div>
                    </td></tr>
                    </table>
                    
                    </div>

                   <!-- Ninth Tab (Variety)-->

                    <div align="center" id="tab_9_contents" class="<%=tabClass[9]%>">
                    <table><tr>
                    <td class="td">
                        <a id="mainLink" href="<%=context%>/EquipmentServlet?op=mainCategoriesReport" onmouseover="Tip('<%=mainTypeCategoriesTip%>',CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#ffff99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7,TEXTALIGN ,'CENTER', TITLE ,'<%=mainTypeCategories%>',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'White', TITLEBGCOLOR ,'#FF9900')"  onmouseout="UnTip()"><%=mainTypeCategories%></a>
                        <a id="mainLink" href="<%=context%>/EquipmentServlet?op=getEqTableReportForm&EqReadReport=no" onmouseover="Tip('<%=equipmentMaintenanceTableTip%>',CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#ffff99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7,TEXTALIGN ,'CENTER', TITLE ,'<%=equipmentMaintenanceTable%>',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'White', TITLEBGCOLOR ,'#FF9900')"  onmouseout="UnTip()"><%=equipmentMaintenanceTable%></a>
                        <a id="mainLink" href="<%=context%>/EquipmentServlet?op=GetProductionLineReportForm" onmouseover="Tip('<%=productionLineEquipmentsTip%>',CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#ffff99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7,TEXTALIGN ,'CENTER', TITLE ,'<%=productionLineEquipments%>',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'White', TITLEBGCOLOR ,'#FF9900')"  onmouseout="UnTip()"><%=productionLineEquipments%></a>
                     </td></tr></table>
                    </div>

                </div>
                </div>
            </fieldset>
            </td>
        </tr>
    </table>
</FORM>

</BODY>
</HTML>
