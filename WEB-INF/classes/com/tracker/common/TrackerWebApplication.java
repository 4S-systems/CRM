package com.tracker.common;

import com.businessfw.hrs.db_access.EmployeeDocMgr;
import com.businessfw.hrs.db_access.EmployeeMgr;
import com.crm.db_access.CommentsMgr;
import com.planning.db_access.PlanMgr;
import com.ApplicationConfiguration.db_access.CompanyConfigMgr;
import com.ApplicationConfiguration.db_access.SystemImagesMgr;
import com.DatabaseController.db_access.DBTablesConfigMgr;
import com.DatabaseController.db_access.ExternalDatabaseMgr;
import com.silkworm.db_access.GrantUserMgr;
import com.silkworm.db_access.GrantsMgr;
import com.silkworm.db_access.PersistentSessionMgr;
import com.contractor.db_access.MaintainableMgr;
import com.contractor.db_access.PeriodicMgr;
import com.docviewer.db_access.DocImgMgr;
import com.docviewer.db_access.DocTypeMgr;
import com.docviewer.db_access.FolderMgr;
import com.docviewer.db_access.ImageMgr;
import com.docviewer.db_access.InstMgr;
import com.externalReports.db_access.ExternalJobReportMgr;
import com.externalReports.db_access.IssueByCostTasksMgr;
import com.financials.db_access.FinancialDocumentMgr;
///////import com.inspection.ComplaintInspectionMgr;
//import com.inspection.InspectionMgr;
//import com.inspection.LaborInspectionMgr;
//import com.inspection.SequenceInspectionMgr;
//import com.inspection.TrnsMaintMgr;
import com.maintenance.common.Tools;
import com.silkworm.db_access.FileMgr;
import com.silkworm.logger.db_access.*;
import java.io.File;
import java.io.FileReader;
import java.io.LineNumberReader;
import java.sql.*;
import java.util.Properties;
import com.silkworm.common.*;
import com.maintenance.db_access.*;
// import com.MaintenanceDependency.db_access.*;
import com.tracker.db_access.*;
import java.util.Vector;
import com.SpareParts.db_access.*;
import com.categoryEngineering.db_access.JspTypesMgr;
import com.clients.db_access.ClientMgr;
import com.clients.db_access.EqpClientMgr;
import com.general_industrial.db_access.ManufactoryMgr;
import com.eqp_operation.db_access.EqpOperationMgr;
import com.hubs.db_access.OrgnDstnRlnMgr;
import com.planning.db_access.PlanIssueMgr;
import com.planning.db_access.RecordSeasonMgr;
import com.planning.db_access.SeasonMgr;
import com.planning.db_access.SeasonPlanMgr;
import com.Item_Type.db_access.ItemTypeMgr;
import com.android.common.LiteMetaDataMgr;
import com.android.db_access.AndroidDevicesMgr;
import com.android.db_access.AndroidLocationsMgr;
import com.businessfw.fin.db_access.ChannelsExpenseMgr;
import com.crm.db_access.AlertTypeMgr;
import com.clients.db_access.AppointmentMgr;
import com.clients.db_access.AppointmentNotificationMgr;
import com.clients.db_access.CallingPlanDetailsMgr;
import com.clients.db_access.CallingPlanMgr;
import com.clients.db_access.ClientCommunicationMgr;
import com.clients.db_access.ClientComplaintsMgr;
import com.clients.db_access.ClientComplaintsSLAMgr;
import com.clients.db_access.ClientComplaintsTimeLineMgr;
import com.clients.db_access.ClientProductMgr;
import com.clients.db_access.ClientRatingMgr;
import com.clients.db_access.ClientRuleMgr;
import com.clients.db_access.ClientSeasonsMgr;
import com.clients.db_access.ClientViewMgr;
import com.clients.db_access.CustomerGradesMgr;
import com.clients.db_access.QualityPlanMgr;
import com.clients.db_access.RateActionMgr;
import com.clients.db_access.ReservationMgr;
import com.clients.db_access.ReservationNotificationMgr;
import com.clients.db_access.SLANotificationMgr;
import com.clients.db_access.ServiceManAreaMgr;
import com.clients.db_access.TradeTypeMgr;
import com.crm.db_access.AlertMgr;
import com.crm.db_access.ChannelsMgr;
import com.crm.db_access.ChannelsUsersMgr;
import com.crm.db_access.EmployeesLoadsGroupSummaryMgr;
import com.crm.db_access.EmployeesLoadsMgr;
import com.crm.db_access.IssueDependenceMgr;
import com.crm.db_access.NotificationsMgr;
import com.email_processing.EmailMgr;
import com.routing.MailGroupMgr;
import com.routing.db_access.ComplaintEmployeeMgr;
import com.silkworm.db_access.CustomizationPanelMgr;
import com.silkworm.db_access.LoginInformationMgr;
import com.silkworm.db_access.QuartzSchedulerConfigurationMgr;
import com.silkworm.functional_security.db_access.BusinessOpSecurityMgr;
import com.silkworm.functional_security.db_access.UserBussinessOpMgr;
import com.unit.db_access.ApartmentRuleMgr;
import com.unit.db_access.ArchDetailsMgr;
import com.unit.db_access.UnitPriceMgr;
import com.workFlowTasks.db_access.VisitQualMgr;
import com.workFlowTasks.db_access.WFTaskCommentsMgr;
import com.workFlowTasks.db_access.WFTaskMgr;
import com.maintenance.common.ClosureConfigMgr;
import com.maintenance.common.UserClosureConfigMgr;
import com.maintenance.common.UserGroupConfigMgr;
import com.maintenance.common.UserDepartmentConfigMgr;
import com.silkworm.db_access.QuartzFinishSchedulerMgr;
import com.financials.db_access.AccountsMgr;
import com.financials.db_access.FinancialTransactionMgr;
import com.unit.db_access.RentContractMgr;
import com.maintenance.db_access.UserCompaniesMgr;
import com.maintenance.db_access.UserProjectsMgr;
import com.planning.db_access.PaymentPlanMgr;
import com.planning.db_access.StandardPaymentPlanMgr;
import com.unit.db_access.UnitTimelineMgr;
import com.unit.db_access.UnitTypeMgr;
import com.businessfw.oms.db_access.ContractMgr;
import com.businessfw.oms.db_access.ContractScheduleMgr;
import com.businessfw.oms.db_access.DocumentMgr;
import com.financials.db_access.ExpenseItemMgr;
import com.financials.db_access.ExpenseItemRelativeMgr;
import com.businessfw.hrs.db_access.EmployeeFinanceMgr;
import com.businessfw.hrs.db_access.EmployeeLoginMgr;
import com.businessfw.hrs.db_access.EmployeeSalaryConfigMgr;
import com.businessfw.hrs.db_access.EmployeeTransactionMgr;
import com.businessfw.oms.db_access.ClientSurveyMgr;
import com.clients.db_access.ClientLocationMgr;
import com.financials.db_access.ClientInvoiceMgr;
import com.financials.db_access.InvoiceMgr;
import com.maintenance.common.UserCampaignConfigMgr;
import com.sms.sender.SmsSenderMgr;

public class TrackerWebApplication extends swWebApplication {

    public TrackerWebApplication() {
    }

    public TrackerWebApplication(String driverClass, String databaseURL, Properties connectionAttributes, String[] sys_paths) throws SQLException, Exception {
        super(driverClass, databaseURL, connectionAttributes, sys_paths);
        File buildFile = new File(sys_paths[0] + Tools.getFileSeparator() + "mybuild.number");
        FileReader fr = new FileReader(buildFile);
        LineNumberReader lr = new LineNumberReader(fr);
        lr.readLine();
        String str;
        int i = 1;
        Vector vecBuild = new Vector();
        while ((str = lr.readLine()) != null) {
            if (i == 1) {
                str = str.substring(1);
            }
            vecBuild.add(str);
            i++;
        }
        fr.close();
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        vecBuild.add(databaseURL);
        metaMgr.setVecBuild(vecBuild);
        System.out.println("the path one" + sys_paths[0]);
        System.out.println("the path one" + sys_paths[1]);
    }

    @Override
    public void init() throws Exception {
        // initialize application managers with the data source aand other important variables
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        metaMgr.setWebInfPath(webInfPath);
        metaMgr.setMetaData("xfile.jar");
        LiteMetaDataMgr liteMetaMgr = LiteMetaDataMgr.getInstance();
        liteMetaMgr.setWebInfPath(webInfPath);
        liteMetaMgr.setMetaData("xfile.jar");

        AccountsMgr accountMgr = AccountsMgr.getInstance();
        accountMgr.setWebInfPath(webInfPath);
        accountMgr.setDataSource(dataSource);
        
        UserMgr userMgr = UserMgr.getInstance();
        userMgr.setWebInfPath(webInfPath);
        userMgr.setDataSource(dataSource);
        userMgr.setSysPaths(sys_paths);

        IssueDocumentMgr issueDocumentMgr = IssueDocumentMgr.getInstance();
        issueDocumentMgr.setWebInfPath(webInfPath);
        issueDocumentMgr.setDataSource(dataSource);

        ComplaintsIssueViewMgr complaintsIssueViewMgr = ComplaintsIssueViewMgr.getInstance();
        complaintsIssueViewMgr.setWebInfPath(webInfPath);
        complaintsIssueViewMgr.setDataSource(dataSource);

        ExtDbConnectionMgr extDbConnectionMgr = ExtDbConnectionMgr.getInstance();
        extDbConnectionMgr.setWebInfPath(webInfPath);
        extDbConnectionMgr.setDataSource(dataSource);

        BusinessOpSecurityMgr businessOpSecurityMgr = BusinessOpSecurityMgr.getInstance();
        businessOpSecurityMgr.setWebInfPath(webInfPath);
        businessOpSecurityMgr.setDataSource(dataSource);

        UserBussinessOpMgr userBussinessOpMgr = UserBussinessOpMgr.getInstance();
        userBussinessOpMgr.setWebInfPath(webInfPath);
        userBussinessOpMgr.setDataSource(dataSource);

        LoginInformationMgr loginInformationMgr = LoginInformationMgr.getInstance();
        loginInformationMgr.setWebInfPath(webInfPath);
        loginInformationMgr.setDataSource(dataSource);

        LocationTypeMgr locationTypeMgr = LocationTypeMgr.getInstance();
        locationTypeMgr.setWebInfPath(webInfPath);
        locationTypeMgr.setDataSource(dataSource);

        ProjectMgr projectMgr = ProjectMgr.getInstance();
        projectMgr.setWebInfPath(webInfPath);
        projectMgr.setDataSource(dataSource);

        EmployeeViewMgr employeeViewMgr = EmployeeViewMgr.getInstance();
        employeeViewMgr.setWebInfPath(webInfPath);
        employeeViewMgr.setDataSource(dataSource);

        EmployeeView2Mgr employeeView2Mgr = EmployeeView2Mgr.getInstance();
        employeeView2Mgr.setWebInfPath(webInfPath);
        employeeView2Mgr.setDataSource(dataSource);

        TotalTicketsMgr totalTicketsMgr = TotalTicketsMgr.getInstance();
        totalTicketsMgr.setWebInfPath(webInfPath);
        totalTicketsMgr.setDataSource(dataSource);

        CustomerGradesMgr customerGradesMgr = CustomerGradesMgr.getInstance();
        customerGradesMgr.setWebInfPath(webInfPath);
        customerGradesMgr.setDataSource(dataSource);

        UserClientsMgr userClientsMgr = UserClientsMgr.getInstance();
        userClientsMgr.setWebInfPath(webInfPath);
        userClientsMgr.setDataSource(dataSource);

        DistributionListMgr distributionListMgr = DistributionListMgr.getInstance();
        distributionListMgr.setWebInfPath(webInfPath);
        distributionListMgr.setDataSource(dataSource);

        ClientViewMgr clientViewMgr = ClientViewMgr.getInstance();
        clientViewMgr.setWebInfPath(webInfPath);
        clientViewMgr.setDataSource(dataSource);

        AppointmentMgr appointmentMgr = AppointmentMgr.getInstance();
        appointmentMgr.setWebInfPath(webInfPath);
        appointmentMgr.setDataSource(dataSource);

        AppointmentNotificationMgr appointmentNotificationMgr = AppointmentNotificationMgr.getInstance();
        appointmentNotificationMgr.setWebInfPath(webInfPath);
        appointmentNotificationMgr.setDataSource(dataSource);

        SLANotificationMgr slaNotificationMgr = SLANotificationMgr.getInstance();
        slaNotificationMgr.setWebInfPath(webInfPath);
        slaNotificationMgr.setDataSource(dataSource);

        ReservationNotificationMgr reservationNotificationMgr = ReservationNotificationMgr.getInstance();
        reservationNotificationMgr.setWebInfPath(webInfPath);
        reservationNotificationMgr.setDataSource(dataSource);

        GenericCountMgr genericCountMgr = GenericCountMgr.getInstance();
        genericCountMgr.setWebInfPath(webInfPath);
        genericCountMgr.setDataSource(dataSource);

        UserCompanyProjectsMgr userCompanyProjectsMgr = UserCompanyProjectsMgr.getInstance();
        userCompanyProjectsMgr.setWebInfPath(webInfPath);
        userCompanyProjectsMgr.setDataSource(dataSource);

        CommentsMgr commentsMgr = CommentsMgr.getInstance();
        commentsMgr.setWebInfPath(webInfPath);
        commentsMgr.setDataSource(dataSource);

        EmpRelationMgr empRelationMgr = EmpRelationMgr.getInstance();
        empRelationMgr.setWebInfPath(webInfPath);
        empRelationMgr.setDataSource(dataSource);

        TradeTypeMgr tradeTypeMgr = TradeTypeMgr.getInstance();
        tradeTypeMgr.setWebInfPath(webInfPath);
        tradeTypeMgr.setDataSource(dataSource);

        ItemTypeMgr itemtypeMge = ItemTypeMgr.getInstance();
        itemtypeMge.setWebInfPath(webInfPath);
        itemtypeMge.setDataSource(dataSource);

        DepartmentMgr departmentMgr = DepartmentMgr.getInstance();
        departmentMgr.setWebInfPath(webInfPath);
        departmentMgr.setDataSource(dataSource);

        PlaceMgr placeMgr = PlaceMgr.getInstance();
        placeMgr.setWebInfPath(webInfPath);
        placeMgr.setDataSource(dataSource);

        IssueByComplaintMgr issueByComplaintMgr = IssueByComplaintMgr.getInstance();
        issueByComplaintMgr.setWebInfPath(webInfPath);
        issueByComplaintMgr.setDataSource(dataSource);

        IssueByComplaintAllCaseMgr issueByComplaintAllCaseMgr = IssueByComplaintAllCaseMgr.getInstance();
        issueByComplaintAllCaseMgr.setWebInfPath(webInfPath);
        issueByComplaintAllCaseMgr.setDataSource(dataSource);

        IssueByComplaint2Mgr issueByComplaint2Mgr = IssueByComplaint2Mgr.getInstance();
        issueByComplaint2Mgr.setWebInfPath(webInfPath);
        issueByComplaint2Mgr.setDataSource(dataSource);

        MaintenanceMgr maintenanceMgr = MaintenanceMgr.getInstance();
        maintenanceMgr.setWebInfPath(webInfPath);
        maintenanceMgr.setDataSource(dataSource);

        IssueTypeMgr issueTypeMgr = IssueTypeMgr.getInstance();
        issueTypeMgr.setWebInfPath(webInfPath);
        issueTypeMgr.setDataSource(dataSource);

        UrgencyMgr urgencyMgr = UrgencyMgr.getInstance();
        urgencyMgr.setWebInfPath(webInfPath);
        urgencyMgr.setDataSource(dataSource);

        IssueMgr issueMgr = IssueMgr.getInstance();
        issueMgr.setWebInfPath(webInfPath);
        issueMgr.setDataSource(dataSource);

        TradeMgr tradeMgr = TradeMgr.getInstance();
        tradeMgr.setWebInfPath(webInfPath);
        tradeMgr.setDataSource(dataSource);

        RegionMgr regionMgr = RegionMgr.getInstance();
        regionMgr.setWebInfPath(webInfPath);
        regionMgr.setDataSource(dataSource);

        GroupMgr groupMgr = GroupMgr.getInstance();
        groupMgr.setWebInfPath(webInfPath);
        groupMgr.setDataSource(dataSource);

        UserGroupMgr userGroupMgr = UserGroupMgr.getInstance();
        userGroupMgr.setWebInfPath(webInfPath);
        userGroupMgr.setDataSource(dataSource);

        BookmarkMgr bookmarkMgr = BookmarkMgr.getInstance();
        bookmarkMgr.setWebInfPath(webInfPath);
        bookmarkMgr.setDataSource(dataSource);

        IssueStatusMgr issueStatusMgr = IssueStatusMgr.getInstance();
        issueStatusMgr.setWebInfPath(webInfPath);
        issueStatusMgr.setDataSource(dataSource);

        ClientComplaintsMgr clientComplaintsMgr = ClientComplaintsMgr.getInstance();
        clientComplaintsMgr.setWebInfPath(webInfPath);
        clientComplaintsMgr.setDataSource(dataSource);
        clientComplaintsMgr.updateClientComplaintsType();

        ClientStatusMgr clientStatusMgr = ClientStatusMgr.getInstance();
        clientStatusMgr.setWebInfPath(webInfPath);
        clientStatusMgr.setDataSource(dataSource);

        BusinessObjectTypeMgr businessObjectTypeMgr = BusinessObjectTypeMgr.getInstance();
        businessObjectTypeMgr.setWebInfPath(webInfPath);
        businessObjectTypeMgr.setDataSource(dataSource);

        EventTypeMgr eventTypeMgr = EventTypeMgr.getInstance();
        eventTypeMgr.setWebInfPath(webInfPath);
        eventTypeMgr.setDataSource(dataSource);

        BusinessEventMgr businessEventMgr = BusinessEventMgr.getInstance();
        businessEventMgr.setWebInfPath(webInfPath);
        businessEventMgr.setDataSource(dataSource);

        ClientSeasonsMgr clientSeasonsMgr = ClientSeasonsMgr.getInstance();
        clientSeasonsMgr.setWebInfPath(webInfPath);
        clientSeasonsMgr.setDataSource(dataSource);

        UnitStatusMgr unitStatusMgr = UnitStatusMgr.getInstance();
        unitStatusMgr.setWebInfPath(webInfPath);
        unitStatusMgr.setDataSource(dataSource);

        ClientProductMgr clientProductMgr = ClientProductMgr.getInstance();
        clientProductMgr.setWebInfPath(webInfPath);
        clientProductMgr.setDataSource(dataSource);

        MilestoneMgr milestoneMgr = MilestoneMgr.getInstance();
        milestoneMgr.setWebInfPath(webInfPath);
        milestoneMgr.setDataSource(dataSource);

        FolderMgr fldrMgr = FolderMgr.getInstance();
        fldrMgr.setWebInfPath(webInfPath);
        fldrMgr.setDataSource(dataSource);

        ImageMgr imageMgr = ImageMgr.getInstance();
        imageMgr.setWebInfPath(webInfPath);
        imageMgr.setDataSource(dataSource);

        FileMgr fileMgr = FileMgr.getInstance();
        fileMgr.setWebInfPath(webInfPath);
        fileMgr.setDataSource(dataSource);
        fileMgr.cashData();

        DocTypeMgr docTypeMgr = DocTypeMgr.getInstance();
        docTypeMgr.setWebInfPath(webInfPath);
        docTypeMgr.setDataSource(dataSource);
        docTypeMgr.cashData();

        DocImgMgr diMgr = DocImgMgr.getInstance();
        diMgr.setWebInfPath(webInfPath);
        diMgr.setDataSource(dataSource);

        ScheduleMgr schedualMgr = ScheduleMgr.getInstance();
        schedualMgr.setWebInfPath(webInfPath);
        schedualMgr.setDataSource(dataSource);

        ItemCatsMgr itemCatsMgr = ItemCatsMgr.getInstance();
        itemCatsMgr.setWebInfPath(webInfPath);
        itemCatsMgr.setDataSource(dataSource);

        MaintainableMgr maintainableMgr = MaintainableMgr.getInstance();
        maintainableMgr.setDataSource(dataSource);

        PeriodicMgr periodicMgr = PeriodicMgr.getInstance();
        periodicMgr.setDataSource(dataSource);

        UnitScheduleMgr unitScheduleMgr = UnitScheduleMgr.getInstance();
        unitScheduleMgr.setDataSource(dataSource);

        QuantifiedMntenceMgr quantifiedMntenceMgr = QuantifiedMntenceMgr.getInstance();
        quantifiedMntenceMgr.setDataSource(dataSource);

        MaintenanceItemMgr maintenanceItemMgr = MaintenanceItemMgr.getInstance();
        maintenanceItemMgr.setDataSource(dataSource);

        ActualItemMgr actualItemMgr = ActualItemMgr.getInstance();
        actualItemMgr.setWebInfPath(webInfPath);
        actualItemMgr.setDataSource(dataSource);

        CategoryMgr categoryMgr = CategoryMgr.getInstance();
        categoryMgr.setDataSource(dataSource);

        TechMgr techMgr = TechMgr.getInstance();
        techMgr.setDataSource(dataSource);

        ItemMgr itemMgr = ItemMgr.getInstance();
        itemMgr.setDataSource(dataSource);

        EmployeeMgr employeeMgr = EmployeeMgr.getInstance();
        employeeMgr.setWebInfPath(webInfPath);
        employeeMgr.setDataSource(dataSource);

        MailGroupMgr mailGroupMgr = MailGroupMgr.getInstance();
        mailGroupMgr.setWebInfPath(webInfPath);
        mailGroupMgr.setDataSource(dataSource);

        ConfigureCategoryMgr configureCategoryMgr = ConfigureCategoryMgr.getInstance();
        configureCategoryMgr.setWebInfPath(webInfPath);
        configureCategoryMgr.setDataSource(dataSource);

        ConfigureMainTypeMgr configureMainTypeMgr = ConfigureMainTypeMgr.getInstance();
        configureMainTypeMgr.setWebInfPath(webInfPath);
        configureMainTypeMgr.setDataSource(dataSource);

        FailureCodeMgr failureCodeMgr = FailureCodeMgr.getInstance();
        failureCodeMgr.setWebInfPath(webInfPath);
        failureCodeMgr.setDataSource(dataSource);

        StaffCodeMgr staffCodeMgr = StaffCodeMgr.getInstance();
        staffCodeMgr.setWebInfPath(webInfPath);
        staffCodeMgr.setDataSource(dataSource);

        EquipMaintenanceTypeMgr equipMaintenanceTypeMgr = EquipMaintenanceTypeMgr.getInstance();
        equipMaintenanceTypeMgr.setWebInfPath(webInfPath);
        equipMaintenanceTypeMgr.setDataSource(dataSource);

        InstMgr instMgr = InstMgr.getInstance();
        instMgr.setWebInfPath(webInfPath);
        instMgr.setDataSource(dataSource);

        SupplierMgr supplierMgr = SupplierMgr.getInstance();
        supplierMgr.setWebInfPath(webInfPath);
        supplierMgr.setDataSource(dataSource);

        PreviligesMgr previligesMgr = PreviligesMgr.getInstance();
        previligesMgr.setWebInfPath(webInfPath);
        previligesMgr.setDataSource(dataSource);

        UnitDocMgr unitDocMgr = UnitDocMgr.getInstance();
        unitDocMgr.setWebInfPath(webInfPath);
        unitDocMgr.setDataSource(dataSource);

        OperationCatMgr operationCatMgr = OperationCatMgr.getInstance();
        operationCatMgr.setWebInfPath(webInfPath);
        operationCatMgr.setDataSource(dataSource);

        UnitCategoryMgr unitCategoryMgr = UnitCategoryMgr.getInstance();
        unitCategoryMgr.setWebInfPath(webInfPath);
        unitCategoryMgr.setDataSource(dataSource);

        EmployeeDocMgr employeeDocMgr = EmployeeDocMgr.getInstance();
        employeeDocMgr.setWebInfPath(webInfPath);
        employeeDocMgr.setDataSource(dataSource);

        SupplierEquipmentMgr supEquipMgr = SupplierEquipmentMgr.getInstance();
        supEquipMgr.setWebInfPath(webInfPath);
        supEquipMgr.setDataSource(dataSource);

        StoreMgr storeMgr = StoreMgr.getInstance();
        storeMgr.setWebInfPath(webInfPath);
        storeMgr.setDataSource(dataSource);

        ItemDocMgr itemDocMgr = ItemDocMgr.getInstance();
        itemDocMgr.setWebInfPath(webInfPath);
        itemDocMgr.setDataSource(dataSource);

        SupplierItemMgr supplierItemMgr = SupplierItemMgr.getInstance();
        supplierItemMgr.setWebInfPath(webInfPath);
        supplierItemMgr.setDataSource(dataSource);

        CrewMissionMgr crewMissionMgr = CrewMissionMgr.getInstance();
        crewMissionMgr.setWebInfPath(webInfPath);
        crewMissionMgr.setDataSource(dataSource);

        CrewEmployeeMgr crewEmployeeMgr = CrewEmployeeMgr.getInstance();
        crewEmployeeMgr.setWebInfPath(webInfPath);
        crewEmployeeMgr.setDataSource(dataSource);

        ItemUnitMgr itemUnitMgr = ItemUnitMgr.getInstance();
        itemUnitMgr.setWebInfPath(webInfPath);
        itemUnitMgr.setDataSource(dataSource);

        EquipmentMaintenanceMgr equipmentMaintenanceMgr = EquipmentMaintenanceMgr.getInstance();
        equipmentMaintenanceMgr.setWebInfPath(webInfPath);
        equipmentMaintenanceMgr.setDataSource(dataSource);

        ScheduleItemMgr scheduleItemMgr = ScheduleItemMgr.getInstance();
        scheduleItemMgr.setWebInfPath(webInfPath);
        scheduleItemMgr.setDataSource(dataSource);

        EqStateTypeMgr eqStateTypeMgr = EqStateTypeMgr.getInstance();
        eqStateTypeMgr.setWebInfPath(webInfPath);
        eqStateTypeMgr.setDataSource(dataSource);

        EquipmentStatusMgr equipmentStatusMgr = EquipmentStatusMgr.getInstance();
        equipmentStatusMgr.setWebInfPath(webInfPath);
        equipmentStatusMgr.setDataSource(dataSource);

        ScheduleTasksMgr scheduleTasksMgr = ScheduleTasksMgr.getInstance();
        scheduleTasksMgr.setWebInfPath(webInfPath);
        scheduleTasksMgr.setDataSource(dataSource);

        EquipOperationMgr eqpOperationMgr = EquipOperationMgr.getInstance();
        eqpOperationMgr.setWebInfPath(webInfPath);
        eqpOperationMgr.setDataSource(dataSource);

        IssueTasksMgr issueTasksMgr = IssueTasksMgr.getInstance();
        issueTasksMgr.setWebInfPath(webInfPath);
        issueTasksMgr.setDataSource(dataSource);

        DataBaseControlMgr dataBaseControlMgr = DataBaseControlMgr.getInstance();
        dataBaseControlMgr.setWebInfPath(webInfPath);
        dataBaseControlMgr.setDataSource(dataSource);

        EqChangesMgr eqChangesMgr = EqChangesMgr.getInstance();
        eqChangesMgr.setWebInfPath(webInfPath);
        eqChangesMgr.setDataSource(dataSource);

        TaskMgr taskMgr = TaskMgr.getInstance();
        taskMgr.setWebInfPath(webInfPath);
        taskMgr.setDataSource(dataSource);

        IssueEquipmentMgr issueEquipmentMgr = IssueEquipmentMgr.getInstance();
        issueEquipmentMgr.setWebInfPath(webInfPath);
        issueEquipmentMgr.setDataSource(dataSource);

        EmpBasicMgr empBasicMgr = EmpBasicMgr.getInstance();
        empBasicMgr.setWebInfPath(webInfPath);
        empBasicMgr.setDataSource(dataSource);

        ChangeDateHistoryMgr changeDateHistoryMgr = ChangeDateHistoryMgr.getInstance();
        changeDateHistoryMgr.setWebInfPath(webInfPath);
        changeDateHistoryMgr.setDataSource(dataSource);

        MainReportMgr mainReportMgr = MainReportMgr.getInstance();
        mainReportMgr.setWebInfPath(webInfPath);
        mainReportMgr.setDataSource(dataSource);

        FixedAssetsMachineMgr fixedAssetsMachineMgr = FixedAssetsMachineMgr.getInstance();
        fixedAssetsMachineMgr.setWebInfPath(webInfPath);
        fixedAssetsMachineMgr.setDataSource(dataSource);

        ExternalJobMgr externalJobMgr = ExternalJobMgr.getInstance();
        externalJobMgr.setWebInfPath(webInfPath);
        externalJobMgr.setDataSource(dataSource);

        TaskExecutionMgr taskExecutionMgr = TaskExecutionMgr.getInstance();
        taskExecutionMgr.setWebInfPath(webInfPath);
        taskExecutionMgr.setDataSource(dataSource);

        EmpTasksHoursMgr empTasksHoursMgr = EmpTasksHoursMgr.getInstance();
        empTasksHoursMgr.setWebInfPath(webInfPath);
        empTasksHoursMgr.setDataSource(dataSource);

        PlannedTasksMgr plannedTasksMgr = PlannedTasksMgr.getInstance();
        plannedTasksMgr.setWebInfPath(webInfPath);
        plannedTasksMgr.setDataSource(dataSource);

        UserTradeMgr userTradeMgr = UserTradeMgr.getInstance();
        userTradeMgr.setWebInfPath(webInfPath);
        userTradeMgr.setDataSource(dataSource);

        UnitScheduleByIssueMgr unitScheduleByIssueMgr = UnitScheduleByIssueMgr.getInstance();
        unitScheduleByIssueMgr.setWebInfPath(webInfPath);
        unitScheduleByIssueMgr.setDataSource(dataSource);

        TaskTypeMgr taskTypeMgr = TaskTypeMgr.getInstance();
        taskTypeMgr.setWebInfPath(webInfPath);
        taskTypeMgr.setDataSource(dataSource);

        EmployeeTitleMgr employeeTitleMgr = EmployeeTitleMgr.getInstance();
        employeeTitleMgr.setWebInfPath(webInfPath);
        employeeTitleMgr.setDataSource(dataSource);

        TransactionMgr transactionMgr = TransactionMgr.getInstance();
        transactionMgr.setWebInfPath(webInfPath);
        transactionMgr.setDataSource(dataSource);

        TransactionDetailsMgr transactionDetailsMgr = TransactionDetailsMgr.getInstance();
        transactionDetailsMgr.setWebInfPath(webInfPath);
        transactionDetailsMgr.setDataSource(dataSource);

        TransactionTypeMgr transactionTypeMgr = TransactionTypeMgr.getInstance();
        transactionTypeMgr.setWebInfPath(webInfPath);
        transactionTypeMgr.setDataSource(dataSource);

        TransactionStatusMgr transactionStatusMgr = TransactionStatusMgr.getInstance();
        transactionStatusMgr.setWebInfPath(webInfPath);
        transactionStatusMgr.setDataSource(dataSource);

        TransactionReceivedMgr transactionReceivedMgr = TransactionReceivedMgr.getInstance();
        transactionReceivedMgr.setWebInfPath(webInfPath);
        transactionReceivedMgr.setDataSource(dataSource);

        ScheduleDocMgr scheduleDocMgr = ScheduleDocMgr.getInstance();
        scheduleDocMgr.setWebInfPath(webInfPath);
        scheduleDocMgr.setDataSource(dataSource);

        ProductionLineMgr productionLineMgr = ProductionLineMgr.getInstance();
        productionLineMgr.setWebInfPath(webInfPath);
        productionLineMgr.setDataSource(dataSource);

        ItemsMgr itemsMgr = ItemsMgr.getInstance();
        itemsMgr.setWebInfPath(webInfPath);
        itemsMgr.setDataSource(dataSource);

        EquipmentSuppliersMgr equipmentSuppliersMgr = EquipmentSuppliersMgr.getInstance();
        equipmentSuppliersMgr.setWebInfPath(webInfPath);
        equipmentSuppliersMgr.setDataSource(dataSource);

        TasksByIssueMgr tasksByIssueMgr = TasksByIssueMgr.getInstance();
        tasksByIssueMgr.setWebInfPath(webInfPath);
        tasksByIssueMgr.setDataSource(dataSource);

        ReadingRateUnitMgr readingRateUnitMgr = ReadingRateUnitMgr.getInstance();
        readingRateUnitMgr.setWebInfPath(webInfPath);
        readingRateUnitMgr.setDataSource(dataSource);

        FailureIssueMachineMgr failureIssueMachineMgr = FailureIssueMachineMgr.getInstance();
        failureIssueMachineMgr.setWebInfPath(webInfPath);
        failureIssueMachineMgr.setDataSource(dataSource);

        SupplementMgr supplementMgr = SupplementMgr.getInstance();
        supplementMgr.setWebInfPath(webInfPath);
        supplementMgr.setDataSource(dataSource);

        UnitMgr unitmgr = UnitMgr.getInstance();
        unitmgr.setWebInfPath(webInfPath);
        unitmgr.setDataSource(dataSource);

        LaborComplaintsMgr laborComplaintsMgr = LaborComplaintsMgr.getInstance();
        laborComplaintsMgr.setWebInfPath(webInfPath);
        laborComplaintsMgr.setDataSource(dataSource);

        AttachedIssuesMgr attachedIssuesMgr = AttachedIssuesMgr.getInstance();
        attachedIssuesMgr.setWebInfPath(webInfPath);
        attachedIssuesMgr.setDataSource(dataSource);

        DelayReasonsMgr delayReasonsMgr = DelayReasonsMgr.getInstance();
        delayReasonsMgr.setWebInfPath(webInfPath);
        delayReasonsMgr.setDataSource(dataSource);

        IssueTasksComplaintMgr issueTasksComplaintMgr = IssueTasksComplaintMgr.getInstance();
        issueTasksComplaintMgr.setWebInfPath(webInfPath);
        issueTasksComplaintMgr.setDataSource(dataSource);

        EmployeeTypeMgr employeeTypeMgr = EmployeeTypeMgr.getInstance();
        employeeTypeMgr.setWebInfPath(webInfPath);
        employeeTypeMgr.setDataSource(dataSource);

        DriversHistoryMgr driversHistoryMgr = DriversHistoryMgr.getInstance();
        driversHistoryMgr.setWebInfPath(webInfPath);
        driversHistoryMgr.setDataSource(dataSource);

        SequenceMgr sequenceMgr = SequenceMgr.getInstance();
        sequenceMgr.setWebInfPath(webInfPath);
        sequenceMgr.setDataSource(dataSource);

        LocalStoresItemsMgr localStoresItemsMgr = LocalStoresItemsMgr.getInstance();
        localStoresItemsMgr.setWebInfPath(webInfPath);
        localStoresItemsMgr.setDataSource(dataSource);

        ParentUnitMgr parentUnitMgr = ParentUnitMgr.getInstance();
        parentUnitMgr.setWebInfPath(webInfPath);
        parentUnitMgr.setDataSource(dataSource);

        IssueMetaDataMgr issueMetaDataMgr = IssueMetaDataMgr.getInstance();
        issueMetaDataMgr.setWebInfPath(webInfPath);
        issueMetaDataMgr.setDataSource(dataSource);

        ComplaintTasksMgr complaintsTasksMgr = ComplaintTasksMgr.getInstance();
        complaintsTasksMgr.setWebInfPath(webInfPath);
        complaintsTasksMgr.setDataSource(dataSource);

        CancelUnitSchedule cancelUnitSchedule = CancelUnitSchedule.getInstance();
        cancelUnitSchedule.setWebInfPath(webInfPath);
        cancelUnitSchedule.setDataSource(dataSource);

        MainCategoryTypeMgr mainCategoryTypeMgr = MainCategoryTypeMgr.getInstance();
        mainCategoryTypeMgr.setWebInfPath(webInfPath);
        mainCategoryTypeMgr.setDataSource(dataSource);

        ComplexIssueMgr complexIssueMgr = ComplexIssueMgr.getInstance();
        complexIssueMgr.setWebInfPath(webInfPath);
        complexIssueMgr.setDataSource(dataSource);

        QuantMntenceCmplxMgr quantMntenceCmplxMgr = QuantMntenceCmplxMgr.getInstance();
        quantMntenceCmplxMgr.setDataSource(dataSource);

        IssueTasksCmplxMgr issueTasksCmplxMgr = IssueTasksCmplxMgr.getInstance();
        issueTasksCmplxMgr.setDataSource(dataSource);

        TaskExecutionCmplxMgr taskExecutionCmplxMgr = TaskExecutionCmplxMgr.getInstance();
        taskExecutionCmplxMgr.setDataSource(dataSource);

        EquipByIssueMgr eqpIssueMgr = EquipByIssueMgr.getInstance();
        eqpIssueMgr.setDataSource(dataSource);

        FutureEquipByIssueMgr futEquipByIssueMgr = FutureEquipByIssueMgr.getInstance();
        futEquipByIssueMgr.setDataSource(dataSource);

        ConfigTasksPartsMgr configTasksPartsMgr = ConfigTasksPartsMgr.getInstance();
        configTasksPartsMgr.setDataSource(dataSource);

        LocalItemsWarrantyMgr localItemsWarrantyMgr = LocalItemsWarrantyMgr.getInstance();
        localItemsWarrantyMgr.setDataSource(dataSource);

        TaskToolsMgr taskToolsMgr = TaskToolsMgr.getInstance();
        taskToolsMgr.setDataSource(dataSource);

        TaskExecutionNotesMgr taskExecutionNotesMgr = TaskExecutionNotesMgr.getInstance();
        taskExecutionNotesMgr.setWebInfPath(webInfPath);
        taskExecutionNotesMgr.setDataSource(dataSource);

        ToolsMgr toolsMgr = ToolsMgr.getInstance();
        toolsMgr.setWebInfPath(webInfPath);
        toolsMgr.setDataSource(dataSource);
        toolsMgr.cashData();

        DistributedItemsMgr distItemsMgr = DistributedItemsMgr.getInstance();
        distItemsMgr.setWebInfPath(webInfPath);
        distItemsMgr.setDataSource(dataSource);

        TempDayMgr tmpDayMgr = TempDayMgr.getInstance();
        tmpDayMgr.setWebInfPath(webInfPath);
        tmpDayMgr.setDataSource(dataSource);

        MonthlyJobOrderMgr mnthlyJOMgr = MonthlyJobOrderMgr.getInstance();
        mnthlyJOMgr.setWebInfPath(webInfPath);
        mnthlyJOMgr.setDataSource(dataSource);

        ScheduleByEmpTitleMgr scheduleByEmpTitleMgr = ScheduleByEmpTitleMgr.getInstance();
        scheduleByEmpTitleMgr.setWebInfPath(webInfPath);
        scheduleByEmpTitleMgr.setDataSource(dataSource);

        ScheduleByItemMgr scheduleByItemMgr = ScheduleByItemMgr.getInstance();
        scheduleByItemMgr.setWebInfPath(webInfPath);
        scheduleByItemMgr.setDataSource(dataSource);

        ScheduleByJobOrderMgr scheduleByJobOrderMgr = ScheduleByJobOrderMgr.getInstance();
        scheduleByJobOrderMgr.setWebInfPath(webInfPath);
        scheduleByJobOrderMgr.setDataSource(dataSource);

        TempTotalEmpTitleMgr tempTotalEmpTitleMgr = TempTotalEmpTitleMgr.getInstance();
        tempTotalEmpTitleMgr.setWebInfPath(webInfPath);
        tempTotalEmpTitleMgr.setDataSource(dataSource);

        TempTotalItemMgr tempTotalItemMgr = TempTotalItemMgr.getInstance();
        tempTotalItemMgr.setWebInfPath(webInfPath);
        tempTotalItemMgr.setDataSource(dataSource);

        TransStoreItemMgr transStoreItemMgr = TransStoreItemMgr.getInstance();
        transStoreItemMgr.setWebInfPath(webInfPath);
        transStoreItemMgr.setDataSource(dataSource);

        TransInfoItemMgr transInfoItemMgr = TransInfoItemMgr.getInstance();
        transInfoItemMgr.setWebInfPath(webInfPath);
        transInfoItemMgr.setDataSource(dataSource);

        ResultStoreItemMgr resultStoreItemMgr = ResultStoreItemMgr.getInstance();
        resultStoreItemMgr.setWebInfPath(webInfPath);
        resultStoreItemMgr.setDataSource(dataSource);

        UnitScheduleHistoryMgr unitScheduleHistoryMgr = UnitScheduleHistoryMgr.getInstance();
        unitScheduleHistoryMgr.setWebInfPath(webInfPath);
        unitScheduleHistoryMgr.setDataSource(dataSource);

        ItemFormListMgr itemFormListMgr = ItemFormListMgr.getInstance();
        itemFormListMgr.setWebInfPath(webInfPath);
        itemFormListMgr.setDataSource(dataSource);

        ItemFormMgr itemFormMgr = ItemFormMgr.getInstance();
        itemFormMgr.setWebInfPath(webInfPath);
        itemFormMgr.setDataSource(dataSource);

        CanceledJobOrdersMgr canceledJobOrdersMgr = CanceledJobOrdersMgr.getInstance();
        canceledJobOrdersMgr.setWebInfPath(webInfPath);
        canceledJobOrdersMgr.setDataSource(dataSource);

        PriceItemByBranchMgr priceItemByBranchMgr = PriceItemByBranchMgr.getInstance();
        priceItemByBranchMgr.setWebInfPath(webInfPath);
        priceItemByBranchMgr.setDataSource(dataSource);

        StoresErpMgr storesErpMgr = StoresErpMgr.getInstance();
        storesErpMgr.setWebInfPath(webInfPath);
        storesErpMgr.setDataSource(dataSource);

        BranchErpMgr branchErpMgr = BranchErpMgr.getInstance();
        branchErpMgr.setWebInfPath(webInfPath);
        branchErpMgr.setDataSource(dataSource);

        ActiveStoreMgr activeStoreMgr = ActiveStoreMgr.getInstance();
        activeStoreMgr.setWebInfPath(webInfPath);
        activeStoreMgr.setDataSource(dataSource);

        GrantsMgr grantsMgr = GrantsMgr.getInstance();
        grantsMgr.setWebInfPath(webInfPath);
        grantsMgr.setDataSource(dataSource);

        GrantUserMgr grantUserMgr = GrantUserMgr.getInstance();
        grantUserMgr.setWebInfPath(webInfPath);
        grantUserMgr.setDataSource(dataSource);

        ReconfigTaskMgr reconfigTaskMgr = ReconfigTaskMgr.getInstance();
        reconfigTaskMgr.setWebInfPath(webInfPath);
        reconfigTaskMgr.setDataSource(dataSource);

        FixedAssetsDataMgr fixedAssetsDataMgr = FixedAssetsDataMgr.getInstance();
        fixedAssetsDataMgr.setWebInfPath(webInfPath);
        fixedAssetsDataMgr.setDataSource(dataSource);

        WorkPlaceMgr workPlaceMgr = WorkPlaceMgr.getInstance();
        workPlaceMgr.setWebInfPath(webInfPath);
        workPlaceMgr.setDataSource(dataSource);

        WorkEquipMgr workEquipMgr = WorkEquipMgr.getInstance();
        workEquipMgr.setWebInfPath(webInfPath);
        workEquipMgr.setDataSource(dataSource);

        CostResultIemMgr costResultIemMgr = CostResultIemMgr.getInstance();
        costResultIemMgr.setWebInfPath(webInfPath);
        costResultIemMgr.setDataSource(dataSource);

        ActionTakenMgr actionTakenMgr = ActionTakenMgr.getInstance();
        actionTakenMgr.setWebInfPath(webInfPath);
        actionTakenMgr.setDataSource(dataSource);

        AllMaintenanceInfoMgr allMaintenanceInfoMgr = AllMaintenanceInfoMgr.getInstance();
        allMaintenanceInfoMgr.setWebInfPath(webInfPath);
        allMaintenanceInfoMgr.setDataSource(dataSource);

        EquipmentsWithReadingMgr equipmentsWithReadingMgr = EquipmentsWithReadingMgr.getInstance();
        equipmentsWithReadingMgr.setWebInfPath(webInfPath);
        equipmentsWithReadingMgr.setDataSource(dataSource);
//
        ResponsibiltyCompViewMgr responsibiltyCompViewMgr = ResponsibiltyCompViewMgr.getInstance();
        responsibiltyCompViewMgr.setWebInfPath(webInfPath);
        responsibiltyCompViewMgr.setDataSource(dataSource);
//
//        SequenceInspectionMgr sequenceInspectionMgr = SequenceInspectionMgr.getInstance();
//        sequenceInspectionMgr.setWebInfPath(webInfPath);
//        sequenceInspectionMgr.setDataSource(dataSource);

        ItemsWithAvgPriceMgr itemsWithAvgPriceMgr = ItemsWithAvgPriceMgr.getInstance();
        itemsWithAvgPriceMgr.setWebInfPath(webInfPath);
        itemsWithAvgPriceMgr.setDataSource(dataSource);

        ViewTableMgr viewTableMgr = ViewTableMgr.getInstance();
        viewTableMgr.setWebInfPath(webInfPath);
        viewTableMgr.setDataSource(dataSource);

        ProjectsByGroupMgr projectsByGroupMgr = ProjectsByGroupMgr.getInstance();
        projectsByGroupMgr.setWebInfPath(webInfPath);
        projectsByGroupMgr.setDataSource(dataSource);

        AllScheduleByHistoryMgr allScheduleByHistoryMgr = AllScheduleByHistoryMgr.getInstance();
        allScheduleByHistoryMgr.setWebInfPath(webInfPath);
        allScheduleByHistoryMgr.setDataSource(dataSource);

        ExternalJobReportMgr externalJobReportMgr = ExternalJobReportMgr.getInstance();
        externalJobReportMgr.setWebInfPath(webInfPath);
        externalJobReportMgr.setDataSource(dataSource);

        WarrantyItemsMgr warrantyItemsMgr = WarrantyItemsMgr.getInstance();
        warrantyItemsMgr.setWebInfPath(webInfPath);
        warrantyItemsMgr.setDataSource(dataSource);

        IssueByCostTasksMgr issueByCostTasksMgr = IssueByCostTasksMgr.getInstance();
        issueByCostTasksMgr.setWebInfPath(webInfPath);
        issueByCostTasksMgr.setDataSource(dataSource);

        ItemBalanceMgr itemBalanceMgr = ItemBalanceMgr.getInstance();
        itemBalanceMgr.setWebInfPath(webInfPath);
        itemBalanceMgr.setDataSource(dataSource);

        UserProjectsMgr userProjectsMgr = UserProjectsMgr.getInstance();
        userProjectsMgr.setWebInfPath(webInfPath);
        userProjectsMgr.setDataSource(dataSource);
        
        UserCompaniesMgr userCompaniesMgr = UserCompaniesMgr.getInstance();
        userCompaniesMgr.setWebInfPath(webInfPath);
        userCompaniesMgr.setDataSource(dataSource);

        UserStoresMgr userStoresMgr = UserStoresMgr.getInstance();
        userStoresMgr.setWebInfPath(webInfPath);
        userStoresMgr.setDataSource(dataSource);

        ItemsWithAvgPriceItemDataMgr avgPriceItemDataMgr = ItemsWithAvgPriceItemDataMgr.getInstance();
        avgPriceItemDataMgr.setWebInfPath(webInfPath);
        avgPriceItemDataMgr.setDataSource(dataSource);

        LoggerMgr loggerMgr = LoggerMgr.getInstance();
        loggerMgr.setWebInfPath(webInfPath);
        loggerMgr.setDataSource(dataSource);

        SystemImagesMgr systemImagesMgr = SystemImagesMgr.getInstance();
        systemImagesMgr.setWebInfPath(webInfPath);
        systemImagesMgr.setDataSource(dataSource);

        CompanyConfigMgr companyConfigMgr = CompanyConfigMgr.getInstance();
        companyConfigMgr.setWebInfPath(webInfPath);
        companyConfigMgr.setDataSource(dataSource);

        ItemsBranchMgr itemsBranchMgr = ItemsBranchMgr.getInstance();
        itemsBranchMgr.setWebInfPath(webInfPath);
        itemsBranchMgr.setDataSource(dataSource);
        
//      maintenance  clean up 
//        ScheduleRelationsMgr scheduleRelationsMgr = ScheduleRelationsMgr.getInstance();
//        scheduleRelationsMgr.setWebInfPath(webInfPath);
//        scheduleRelationsMgr.setDataSource(dataSource);
//
//        RelatedScheduleDetailsMgr relatedScheduleDetailsMgr = RelatedScheduleDetailsMgr.getInstance();
//        relatedScheduleDetailsMgr.setWebInfPath(webInfPath);
//        relatedScheduleDetailsMgr.setDataSource(dataSource);

        ManufactoryMgr manufactoryMgr = ManufactoryMgr.getInstance();
        manufactoryMgr.setWebInfPath(webInfPath);
        manufactoryMgr.setDataSource(dataSource);

        EqpOperationMgr operationMgr = EqpOperationMgr.getInstance();
        operationMgr.setWebInfPath(webInfPath);
        operationMgr.setDataSource(dataSource);

        EqpClientMgr eqpclientMgr = EqpClientMgr.getInstance();
        eqpclientMgr.setWebInfPath(webInfPath);
        eqpclientMgr.setDataSource(dataSource);

        ServiceManAreaMgr serviceManAreaMgr = ServiceManAreaMgr.getInstance();
        serviceManAreaMgr.setWebInfPath(webInfPath);
        serviceManAreaMgr.setDataSource(dataSource);

        PreviligesTypeMgr previligesTypeMgr = PreviligesTypeMgr.getInstance();
        previligesTypeMgr.setWebInfPath(webInfPath);
        previligesTypeMgr.setDataSource(dataSource);

        ClientMgr clientMgr = ClientMgr.getInstance();
        clientMgr.setWebInfPath(webInfPath);
        clientMgr.setDataSource(dataSource);
        clientMgr.removeClientNameWhiteSpace();

        OrgnDstnRlnMgr orgnDstnRlnMgr = OrgnDstnRlnMgr.getInstance();
        orgnDstnRlnMgr.setWebInfPath(webInfPath);
        orgnDstnRlnMgr.setDataSource(dataSource);

        PlanMgr planMgr = PlanMgr.getInstance();
        planMgr.setWebInfPath(webInfPath);
        planMgr.setDataSource(dataSource);

        PlanIssueMgr planIssueMgr = PlanIssueMgr.getInstance();
        planIssueMgr.setWebInfPath(webInfPath);
        planIssueMgr.setDataSource(dataSource);

        ComplaintEmployeeMgr complaintEmployeeMgr = ComplaintEmployeeMgr.getInstance();
        complaintEmployeeMgr.setWebInfPath(webInfPath);
        complaintEmployeeMgr.setDataSource(dataSource);

        GroupPrevMgr groupPrevMgr = GroupPrevMgr.getInstance();
        groupPrevMgr.setWebInfPath(webInfPath);
        groupPrevMgr.setDataSource(dataSource);

        SeasonMgr seasonMgr = SeasonMgr.getInstance();
        seasonMgr.setWebInfPath(webInfPath);
        seasonMgr.setDataSource(dataSource);

        RecordSeasonMgr recordSeasonMgr = RecordSeasonMgr.getInstance();
        recordSeasonMgr.setWebInfPath(webInfPath);
        recordSeasonMgr.setDataSource(dataSource);

        JspTypesMgr jspTypesMgr = JspTypesMgr.getInstance();
        jspTypesMgr.setWebInfPath(webInfPath);
        jspTypesMgr.setDataSource(dataSource);

        SchedulesTasksRlnModelMgr schedulesTasksRlnModelMgr = SchedulesTasksRlnModelMgr.getInstance();
        schedulesTasksRlnModelMgr.setWebInfPath(webInfPath);
        schedulesTasksRlnModelMgr.setDataSource(dataSource);

        SeasonPlanMgr seasonPlanMgr = SeasonPlanMgr.getInstance();
        seasonPlanMgr.setWebInfPath(webInfPath);
        seasonPlanMgr.setDataSource(dataSource);

        MeasurementUnitsMgr measurementUnitsMgr = MeasurementUnitsMgr.getInstance();
        measurementUnitsMgr.setWebInfPath(webInfPath);
        measurementUnitsMgr.setDataSource(dataSource);

        MeasurementsMgr measurementsMgr = MeasurementsMgr.getInstance();
        measurementsMgr.setWebInfPath(webInfPath);
        measurementsMgr.setDataSource(dataSource);

        MainTypeMeasurementMgr mainTypeMeasurementMgr = MainTypeMeasurementMgr.getInstance();
        mainTypeMeasurementMgr.setWebInfPath(webInfPath);
        mainTypeMeasurementMgr.setDataSource(dataSource);

        ConfigAlterTasksPartsMgr configAlterTasksPartsMgr = ConfigAlterTasksPartsMgr.getInstance();
        configAlterTasksPartsMgr.setWebInfPath(webInfPath);
        configAlterTasksPartsMgr.setDataSource(dataSource);

        IssueCounterReadingMgr issueCounterReadingMgr = IssueCounterReadingMgr.getInstance();
        issueCounterReadingMgr.setWebInfPath(webInfPath);
        issueCounterReadingMgr.setDataSource(dataSource);

        SchedulesOnEquipmentByItemMgr schedulesOnEquipmentByItemMgr = SchedulesOnEquipmentByItemMgr.getInstance();
        schedulesOnEquipmentByItemMgr.setWebInfPath(webInfPath);
        schedulesOnEquipmentByItemMgr.setDataSource(dataSource);

        MeasureMgr measureMgr = MeasureMgr.getInstance();
        measureMgr.setWebInfPath(webInfPath);
        measureMgr.setDataSource(dataSource);

        IssueCounterByUnitMgr issueCounterByUnitMgr = IssueCounterByUnitMgr.getInstance();
        issueCounterByUnitMgr.setWebInfPath(webInfPath);
        issueCounterByUnitMgr.setDataSource(dataSource);

        WFTaskMgr wFTaskMgr = WFTaskMgr.getInstance();
        wFTaskMgr.setWebInfPath(webInfPath);
        wFTaskMgr.setDataSource(dataSource);

        VisitQualMgr visitQualMgr = VisitQualMgr.getInstance();
        visitQualMgr.setWebInfPath(webInfPath);
        visitQualMgr.setDataSource(dataSource);

        WFTaskCommentsMgr wfTaskCommentsMgr = WFTaskCommentsMgr.getInstance();
        wfTaskCommentsMgr.setWebInfPath(webInfPath);
        wfTaskCommentsMgr.setDataSource(dataSource);

        AlertMgr alertMgr = AlertMgr.getInstance();
        alertMgr.setWebInfPath(webInfPath);
        alertMgr.setDataSource(dataSource);

        AlertTypeMgr alertTypeMgr = AlertTypeMgr.getInstance();
        alertTypeMgr.setWebInfPath(webInfPath);
        alertTypeMgr.setDataSource(dataSource);

//        TradeTypeMgr tradeTypeMgr = TradeTypeMgr.getInstance();
//        tradeTypeMgr.setWebInfPath(webInfPath);
//        tradeTypeMgr.setDataSource(dataSource);
//        tradeTypeMgr.cashData();
        NotificationsMgr notificationsMgr = NotificationsMgr.getInstance();
        notificationsMgr.setWebInfPath(webInfPath);
        notificationsMgr.setDataSource(dataSource);

        ChannelsMgr channelsMgr = ChannelsMgr.getInstance();
        channelsMgr.setWebInfPath(webInfPath);
        channelsMgr.setDataSource(dataSource);

        ChannelsUsersMgr channelsUsersMgr = ChannelsUsersMgr.getInstance();
        channelsUsersMgr.setWebInfPath(webInfPath);
        channelsUsersMgr.setDataSource(dataSource);

        DepDocPrevMgr depDocPrevMgr = DepDocPrevMgr.getInstance();
        depDocPrevMgr.setWebInfPath(webInfPath);
        depDocPrevMgr.setDataSource(dataSource);

        EmployeesLoadsMgr employeesLoadsMgr = EmployeesLoadsMgr.getInstance();
        employeesLoadsMgr.setWebInfPath(webInfPath);
        employeesLoadsMgr.setDataSource(dataSource);

        EmployeesLoadsGroupSummaryMgr employeesLoadsGroupSummaryMgr = EmployeesLoadsGroupSummaryMgr.getInstance();
        employeesLoadsGroupSummaryMgr.setWebInfPath(webInfPath);
        employeesLoadsGroupSummaryMgr.setDataSource(dataSource);

        CampaignMgr campaignMgr = CampaignMgr.getInstance();
        campaignMgr.setWebInfPath(webInfPath);
        campaignMgr.setDataSource(dataSource);

        CampaignProjectMgr campaignProjectMgr = CampaignProjectMgr.getInstance();
        campaignProjectMgr.setWebInfPath(webInfPath);
        campaignProjectMgr.setDataSource(dataSource);

        ClientCampaignMgr clientCampaignMgr = ClientCampaignMgr.getInstance();
        clientCampaignMgr.setWebInfPath(webInfPath);
        clientCampaignMgr.setDataSource(dataSource);

        IncentiveMgr incentiveMgr = IncentiveMgr.getInstance();
        incentiveMgr.setWebInfPath(webInfPath);
        incentiveMgr.setDataSource(dataSource);

        ClientIncentiveMgr clientIncentiveMgr = ClientIncentiveMgr.getInstance();
        clientIncentiveMgr.setWebInfPath(webInfPath);
        clientIncentiveMgr.setDataSource(dataSource);

        UserAreaMgr userAreaMgr = UserAreaMgr.getInstance();
        userAreaMgr.setWebInfPath(webInfPath);
        userAreaMgr.setDataSource(dataSource);

        UnitPriceMgr unitPriceMgr = UnitPriceMgr.getInstance();
        unitPriceMgr.setWebInfPath(webInfPath);
        unitPriceMgr.setDataSource(dataSource);

        ArchDetailsMgr archDetailsMgr = ArchDetailsMgr.getInstance();
        archDetailsMgr.setWebInfPath(webInfPath);
        archDetailsMgr.setDataSource(dataSource);

        DepTaskPrevMgr depTaskPrevMgr = DepTaskPrevMgr.getInstance();
        depTaskPrevMgr.setWebInfPath(webInfPath);
        depTaskPrevMgr.setDataSource(dataSource);

        CustomizationPanelMgr panelMgr = CustomizationPanelMgr.getInstance();
        panelMgr.setWebInfPath(webInfPath);
        panelMgr.setDataSource(dataSource);

        ExternalDatabaseMgr externalDatabaseMgr = ExternalDatabaseMgr.getInstance();
        externalDatabaseMgr.setWebInfPath(webInfPath);
        externalDatabaseMgr.setDataSource(dataSource);

        ClientCommunicationMgr clientCommunicationMgr = ClientCommunicationMgr.getInstance();
        clientCommunicationMgr.setWebInfPath(webInfPath);
        clientCommunicationMgr.setDataSource(dataSource);

        ApartmentRuleMgr apartmentRuleMgr = ApartmentRuleMgr.getInstance();
        apartmentRuleMgr.setWebInfPath(webInfPath);
        apartmentRuleMgr.setDataSource(dataSource);

        ClientRuleMgr clientRuleMgr = ClientRuleMgr.getInstance();
        clientRuleMgr.setWebInfPath(webInfPath);
        clientRuleMgr.setDataSource(dataSource);

        ReservationMgr reservationMgr = ReservationMgr.getInstance();
        reservationMgr.setWebInfPath(webInfPath);
        reservationMgr.setDataSource(dataSource);

        RequestItemsMgr requestItemsMgr = RequestItemsMgr.getInstance();
        requestItemsMgr.setWebInfPath(webInfPath);
        requestItemsMgr.setDataSource(dataSource);

        RequestItemsDetailsMgr requestItemsDetailsMgr = RequestItemsDetailsMgr.getInstance();
        requestItemsDetailsMgr.setWebInfPath(webInfPath);
        requestItemsDetailsMgr.setDataSource(dataSource);

        QuartzSchedulerConfigurationMgr quartzSchedulerConfigurationMgr = QuartzSchedulerConfigurationMgr.getInstance();
        quartzSchedulerConfigurationMgr.setWebInfPath(webInfPath);
        quartzSchedulerConfigurationMgr.setDataSource(dataSource);

        QuartzFinishSchedulerMgr quartzFinishSchedulerMgr = QuartzFinishSchedulerMgr.getInstance();
        quartzFinishSchedulerMgr.setWebInfPath(webInfPath);
        quartzFinishSchedulerMgr.setDataSource(dataSource);

        IssueByComplaintUniqueMgr issueByComplaintUniqueMgr = IssueByComplaintUniqueMgr.getInstance();
        issueByComplaintUniqueMgr.setWebInfPath(webInfPath);
        issueByComplaintUniqueMgr.setDataSource(dataSource);

        IssueProjectMgr issueProjectMgr = IssueProjectMgr.getInstance();
        issueProjectMgr.setWebInfPath(webInfPath);
        issueProjectMgr.setDataSource(dataSource);

        ClientComplaintsTimeLineMgr clientComplaintsTimeLineMgr = ClientComplaintsTimeLineMgr.getInstance();
        clientComplaintsTimeLineMgr.setWebInfPath(webInfPath);
        clientComplaintsTimeLineMgr.setDataSource(dataSource);

        ClosureConfigMgr closureConfigMgr = ClosureConfigMgr.getInstance();
        closureConfigMgr.setWebInfPath(webInfPath);
        closureConfigMgr.setDataSource(dataSource);
        closureConfigMgr.cashData();

        UserClosureConfigMgr userClosureConfigMgr = UserClosureConfigMgr.getInstance();
        userClosureConfigMgr.setWebInfPath(webInfPath);
        userClosureConfigMgr.setDataSource(dataSource);

        ClientComplaintsSLAMgr clientComplaintsSLAMgr = ClientComplaintsSLAMgr.getInstance();
        clientComplaintsSLAMgr.setWebInfPath(webInfPath);
        clientComplaintsSLAMgr.setDataSource(dataSource);

        UserGroupConfigMgr userGroupConfigMgr = UserGroupConfigMgr.getInstance();
        userGroupConfigMgr.setWebInfPath(webInfPath);
        userGroupConfigMgr.setDataSource(dataSource);

        UserDepartmentConfigMgr userDepartmentConfigMgr = UserDepartmentConfigMgr.getInstance();
        userDepartmentConfigMgr.setWebInfPath(webInfPath);
        userDepartmentConfigMgr.setDataSource(dataSource);

        PersistentSessionMgr persistentSessionMgr = PersistentSessionMgr.getInstance();
        persistentSessionMgr.setWebInfPath(webInfPath);
        persistentSessionMgr.setDataSource(dataSource);

        IssueDependenceMgr issueDependenceMgr = IssueDependenceMgr.getInstance();
        issueDependenceMgr.setWebInfPath(webInfPath);
        issueDependenceMgr.setDataSource(dataSource);

        CallingPlanMgr callingPlanMgr = CallingPlanMgr.getInstance();
        callingPlanMgr.setWebInfPath(webInfPath);
        callingPlanMgr.setDataSource(dataSource);

        CallingPlanDetailsMgr callingPlanDetailsMgr = CallingPlanDetailsMgr.getInstance();
        callingPlanDetailsMgr.setWebInfPath(webInfPath);
        callingPlanDetailsMgr.setDataSource(dataSource);

        QualityPlanMgr qualityPlanMgr = QualityPlanMgr.getInstance();
        qualityPlanMgr.setWebInfPath(webInfPath);
        qualityPlanMgr.setDataSource(dataSource);

        StoreTransactionMgr storeTransactionMgr = StoreTransactionMgr.getInstance();
        storeTransactionMgr.setWebInfPath(webInfPath);
        storeTransactionMgr.setDataSource(dataSource);

        StoreTransactionDetailsMgr storeTransactionDetailsMgr = StoreTransactionDetailsMgr.getInstance();
        storeTransactionDetailsMgr.setWebInfPath(webInfPath);
        storeTransactionDetailsMgr.setDataSource(dataSource);

        ClientRatingMgr clientRatingMgr = ClientRatingMgr.getInstance();
        clientRatingMgr.setWebInfPath(webInfPath);
        clientRatingMgr.setDataSource(dataSource);
        
//        BaseReportsMgr baseReportsMgr = BaseReportsMgr.getInstance();
//        baseReportsMgr.setWebInfPath(webInfPath);
//        baseReportsMgr.setDataSource(dataSource);
        
        FinancialTransactionMgr financTransMgr = FinancialTransactionMgr.getInstance();
        financTransMgr.setWebInfPath(webInfPath);
        financTransMgr.setDataSource(dataSource);
        
        RentContractMgr rentContractMgr = RentContractMgr.getInstance();
        rentContractMgr.setWebInfPath(webInfPath);
        rentContractMgr.setDataSource(dataSource);
        
        ProjectAccountingMgr projectAccMgr = ProjectAccountingMgr.getInstance();
        projectAccMgr.setWebInfPath(webInfPath);
        projectAccMgr.setDataSource(dataSource);
        
        // email manager here
        EmailMgr emailMgr = EmailMgr.getInstance();
        emailMgr.setWebInfPath(webInfPath);
        emailMgr.setDataSource(dataSource);
        
        UnitTimelineMgr unitTimelineMgr = UnitTimelineMgr.getInstance();
         unitTimelineMgr.setWebInfPath(webInfPath);
         unitTimelineMgr.setDataSource(dataSource);
         
         PaymentPlanMgr paymentplanMgr = PaymentPlanMgr.getInstance();
         paymentplanMgr.setWebInfPath(webInfPath);
         paymentplanMgr.setDataSource(dataSource);
         
        StandardPaymentPlanMgr standardPaymentPlanMgr = StandardPaymentPlanMgr.getInstance();
        standardPaymentPlanMgr.setWebInfPath(webInfPath);
        standardPaymentPlanMgr.setDataSource(dataSource);
        
        ProjectEntityMgr projectEntityMgr = ProjectEntityMgr.getInstance();
        projectEntityMgr.setWebInfPath(webInfPath);
        projectEntityMgr.setDataSource(dataSource);
        
        LoginHistoryMgr loginHistoryMgr = LoginHistoryMgr.getInstance();
        loginHistoryMgr.setWebInfPath(webInfPath);
        loginHistoryMgr.setDataSource(dataSource);
        
        TradeTempMgr tradeTempMgr = TradeTempMgr.getInstance();
        tradeTempMgr.setWebInfPath(webInfPath);
        tradeTempMgr.setDataSource(dataSource);
        
        UnitTypeMgr unitTypeMgr = UnitTypeMgr.getInstance();
        unitTypeMgr.setWebInfPath(webInfPath);
        unitTypeMgr.setDataSource(dataSource);
        
        UserDistrictsMgr userDistrictsMgr = UserDistrictsMgr.getInstance();
        userDistrictsMgr.setWebInfPath(webInfPath);
        userDistrictsMgr.setDataSource(dataSource);
        
        AndroidDevicesMgr androidDevicesMgr = AndroidDevicesMgr.getInstance();
        androidDevicesMgr.setWebInfPath(webInfPath);
        androidDevicesMgr.setDataSource(dataSource);

        AndroidLocationsMgr androidLocationsMgr = AndroidLocationsMgr.getInstance();
        androidLocationsMgr.setWebInfPath(webInfPath);
        androidLocationsMgr.setDataSource(dataSource);

        RateActionMgr rateActionMgr = RateActionMgr.getInstance();
        rateActionMgr.setWebInfPath(webInfPath);
        rateActionMgr.setDataSource(dataSource);
        
        ContractMgr contractMgr = ContractMgr.getInstance();
        contractMgr.setWebInfPath(webInfPath);
        contractMgr.setDataSource(dataSource);
        
        DocumentMgr documentMgr = DocumentMgr.getInstance();
        documentMgr.setWebInfPath(webInfPath);
        documentMgr.setDataSource(dataSource);
        
        ExpenseItemMgr expenseItemMgr = ExpenseItemMgr.getInstance();
        expenseItemMgr.setWebInfPath(webInfPath);
        expenseItemMgr.setDataSource(dataSource);
        
        ExpenseItemRelativeMgr expenseItemRelativeMgr = ExpenseItemRelativeMgr.getInstance();
        expenseItemRelativeMgr.setWebInfPath(webInfPath);
        expenseItemRelativeMgr.setDataSource(dataSource);
        
        ChannelsExpenseMgr channelsExpenseMgr = ChannelsExpenseMgr.getInstance();
        channelsExpenseMgr.setWebInfPath(webInfPath);
        channelsExpenseMgr.setDataSource(dataSource);
        
        ContractScheduleMgr contractScheduleMgr = ContractScheduleMgr.getInstance();
        contractScheduleMgr.setWebInfPath(webInfPath);
        contractScheduleMgr.setDataSource(dataSource);
        
        EmployeeFinanceMgr employeeFinanceMgr = EmployeeFinanceMgr.getInstance();
        employeeFinanceMgr.setWebInfPath(webInfPath);
        employeeFinanceMgr.setDataSource(dataSource);
        
        EmployeeTransactionMgr employeeTransMgr = EmployeeTransactionMgr.getInstance();
        employeeTransMgr.setWebInfPath(webInfPath);
        employeeTransMgr.setDataSource(dataSource);
        
        EmployeeSalaryConfigMgr employeeSalaryConfigMgr = EmployeeSalaryConfigMgr.getInstance();
        employeeSalaryConfigMgr.setWebInfPath(webInfPath);
        employeeSalaryConfigMgr.setDataSource(dataSource);
        
        DBTablesConfigMgr dBTablesConfigMgr = DBTablesConfigMgr.getInstance();
        dBTablesConfigMgr.setWebInfPath(webInfPath);
        dBTablesConfigMgr.setDataSource(dataSource);
        
        ClientSurveyMgr clientSurveyMgr = ClientSurveyMgr.getInstance();
        clientSurveyMgr.setWebInfPath(webInfPath);
        clientSurveyMgr.setDataSource(dataSource);
        
        EmployeeLoginMgr employeeLoginMgr = EmployeeLoginMgr.getInstance();
        employeeLoginMgr.setWebInfPath(webInfPath);
        employeeLoginMgr.setDataSource(dataSource);
        
        ProjectPriceHistoryMgr projectPriceHistoryMgr = ProjectPriceHistoryMgr.getInstance();
        projectPriceHistoryMgr.setWebInfPath(webInfPath);
        projectPriceHistoryMgr.setDataSource(dataSource);
        
        MessagesMgr messagesMgr = MessagesMgr.getInstance();
        messagesMgr.setWebInfPath(webInfPath);
        messagesMgr.setDataSource(dataSource);
        
        UserExtMgr userExtMgr = UserExtMgr.getInstance();
        userExtMgr.setWebInfPath(webInfPath);
        userExtMgr.setDataSource(dataSource);
        
        InvoiceMgr invoiceMgr = InvoiceMgr.getInstnace();
        invoiceMgr.setWebInfPath(webInfPath);
        invoiceMgr.setDataSource(dataSource);
        
        
        ClientInvoiceMgr clientInvoiceMgr = ClientInvoiceMgr.getInstnace();
        clientInvoiceMgr.setWebInfPath(webInfPath);
        clientInvoiceMgr.setDataSource(dataSource);
        
        FinancialDocumentMgr finaicalDocumentMgr = FinancialDocumentMgr.getInstance();
        finaicalDocumentMgr.setWebInfPath(webInfPath);
        finaicalDocumentMgr.setDataSource(dataSource);
        
        UnitAddonDetailsMgr unitAddonDetailsMgr = UnitAddonDetailsMgr.getInstance();
        unitAddonDetailsMgr.setWebInfPath(webInfPath);
        unitAddonDetailsMgr.setDataSource(dataSource);
        
        UserCampaignConfigMgr userCampaignConfigMgr = UserCampaignConfigMgr.getInstance();
        userCampaignConfigMgr.setWebInfPath(webInfPath);
        userCampaignConfigMgr.setDataSource(dataSource);
        
        
        SmsSenderMgr smsSenderMgr = SmsSenderMgr.getInstance();
        smsSenderMgr.setWebInfPath(webInfPath);
        smsSenderMgr.setDataSource(dataSource);
        
        StageWorkItemMgr stageWorkItemMgr = StageWorkItemMgr.getInstance();
        stageWorkItemMgr.setWebInfPath(webInfPath);
        stageWorkItemMgr.setDataSource(dataSource);
        
        ProjectStageMgr projectStageMgr = ProjectStageMgr.getInstance();
        projectStageMgr.setWebInfPath(webInfPath);
        projectStageMgr.setDataSource(dataSource);
        
        ClientLocationMgr clientLocationMgr = ClientLocationMgr.getInstance();
        clientLocationMgr.setWebInfPath(webInfPath);
        clientLocationMgr.setDataSource(dataSource);
    }
}