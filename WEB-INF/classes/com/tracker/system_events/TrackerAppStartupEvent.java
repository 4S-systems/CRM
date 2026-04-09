package com.tracker.system_events;

// removed untill we get FLEET UP import com.ApplicationConfiguration.db_access.ApplicationUrlMgr;
import com.DatabaseController.db_access.DatabaseConfigurationMgr;
import com.maintenance.common.PublicSettingsMgr;
import com.silkworm.business_objects.SqlMgr;
//import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.common.*;
import com.silkworm.system_events.*;
import com.tracker.common.TrackerWebApplication;
import com.silkworm.business_objects.secure_menu.*;
import com.silkworm.telecom.TeleComGateway;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.StringWriter;

import java.util.*;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.commons.io.IOUtils;

public class TrackerAppStartupEvent extends WebAppStartupEvent {

    TrackerWebApplication trackerWebApplication = null;

    public TrackerAppStartupEvent() {
    }

    protected void getAppParams() {
        String driverClass = servletContext.getInitParameter("DriverClass");
        String databaseURL = servletContext.getInitParameter("DataBaseURL");
        String userName = servletContext.getInitParameter("UserName");
        String password = servletContext.getInitParameter("PassWord");
        String emailAddress = servletContext.getInitParameter("Email");
        String sqlServer = servletContext.getInitParameter("SqlServer");
        String companyName = servletContext.getInitParameter("companyName");
        String apiKey = servletContext.getInitParameter("SmsProviderKey");
        String apiSecret = servletContext.getInitParameter("SmsProviderSecret");
        String companyNameForLogo = servletContext.getInitParameter("companyNameForLogo");
        String visibleCost = servletContext.getInitParameter("VisibleCost");
        String projectType = servletContext.getInitParameter("projectType");
        String assetErpName = servletContext.getInitParameter("assetErpName");
        String realEstateWeb = servletContext.getInitParameter("realEstateWeb");
        String assetErpPassword = servletContext.getInitParameter("assetErpPassword");
        String storeErpName = servletContext.getInitParameter("storeErpName");
        String storeErpPassword = servletContext.getInitParameter("storeErpPassword");
        String realEstateName = servletContext.getInitParameter("realEstateName");
        String realEstatePassword = servletContext.getInitParameter("realEstatePassword");
        String connectByRealEstate = servletContext.getInitParameter("connectByRealEstate");
        String showCalendar = servletContext.getInitParameter("showCalendar");
        String RegionsMainCode = servletContext.getInitParameter("RegionsMainCode");
        String pageRefreshTimer = servletContext.getInitParameter("pageRefreshTimer");
        String driverErp = servletContext.getInitParameter("driverErp");
        String dataBaseErpUrl = servletContext.getInitParameter("dataBaseErpUrl");
        String configurationSparePartsPrice = servletContext.getInitParameter("configurationSparePartsPrice");
        String sendMail = swAppContext.getInitParameter("sendMail");
        String runAutomationReports = swAppContext.getInitParameter("runAutomationReports");
        String isSsecretaryFullOption = swAppContext.getInitParameter("isSsecretaryFullOption");
        String candelete = swAppContext.getInitParameter("candelete");
        String dateSpan = swAppContext.getInitParameter("dateSpan");
        String externalDB1 = swAppContext.getInitParameter("externalDB1");
        String externalDB2 = swAppContext.getInitParameter("externalDB2");
        String customerServiceID = swAppContext.getInitParameter("customerServiceID");
        String dataMigration = swAppContext.getInitParameter("dataMigration");
        String webDirectoryPath = swAppContext.getInitParameter("webDirectoryPath");
        String departmentRootID = swAppContext.getInitParameter("departmentRootID");
        String showCommentType = swAppContext.getInitParameter("showCommentType");
        String departmentIdForReports = swAppContext.getInitParameter("departmentIdForReports");
        String projectsDepartmentID = swAppContext.getInitParameter("projectsDepartmentID");
        String maxVisitNo = swAppContext.getInitParameter("maxVisitNo");
        String unitFinanceFlag = swAppContext.getInitParameter("UnitFinance");
        String hasCallCenter = swAppContext.getInitParameter("hasCallCenter");
        String sambaServer = swAppContext.getInitParameter("sambaServer");
        String sambaUserName = swAppContext.getInitParameter("sambaUserName");
        String sambaPassword = swAppContext.getInitParameter("sambaPassword");
        String DelayedTaskPeriod = swAppContext.getInitParameter("DelayedTaskPeriod");
        String defaultLanguage = swAppContext.getInitParameter("defaultLanguage");
        String checkAuthorization = swAppContext.getInitParameter("checkAuthorization");
        String webServiceUrl = swAppContext.getInitParameter("webServiceUrl");
        String runSessionKill = servletContext.getInitParameter("runSessionKill");
        String telesalesID = servletContext.getInitParameter("telesalesID");
        String targetCalls = servletContext.getInitParameter("targetCalls");
        String hoursBeforeNeglect = servletContext.getInitParameter("hoursBeforeNeglect");
        
        System.out.println("companyName:    " + companyName);
        System.out.println("VisibleCost:    " + visibleCost);
        System.out.println("configurationSparePartsPrice:    " + configurationSparePartsPrice);
        System.out.println("smtp : " + emailAddress);
        String smtpServer = servletContext.getInitParameter("SMTPServer");
        System.out.println(smtpServer);
        String emailPassword = servletContext.getInitParameter("EmailPassword");
        System.out.println(emailPassword);
        String emailPort = servletContext.getInitParameter("EmailPort");
        String emailSSL = servletContext.getInitParameter("EmailSSL");
        String NewTap = servletContext.getInitParameter("NewTap");
        String imapServer = servletContext.getInitParameter("IMAPServer");
        String tabs = servletContext.getInitParameter("Tabs");
        String display = servletContext.getInitParameter("Display");
        String maxUsersNum = servletContext.getInitParameter("main");
        String deleteClassification = servletContext.getInitParameter("deleteClassification");
        String copyToFuture = servletContext.getInitParameter("copyToFuture");
        String addonActive = servletContext.getInitParameter("addonActive");

        servletContext.log(driverClass);
        servletContext.log(databaseURL);
        servletContext.log(userName);
        servletContext.log(password);

        Properties properties = new Properties();
        properties.put("user", userName);
        properties.put("password", password);
        properties.put("useUnicode", "true");
        properties.put("characterEncoding", "UTF-8");

        try {
            trackerWebApplication = new TrackerWebApplication(driverClass, databaseURL, properties, sys_paths);
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }

        System.out.println("Tracker startup event");
        MenuBuilder menuBuilder = new MenuBuilder();
        
        MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
        menuBuilder.setFileURL(metaDataMgr.getWebInfPath() + "/menu.xml");
        menuBuilder.setXslFile(metaDataMgr.getWebInfPath() + "/menu.xsl");
        menuBuilder.setXslGroupFile(metaDataMgr.getWebInfPath() + "/menu_group.xsl");
        StringWriter stringWriter = new StringWriter();
        ThreeDimensionMenu threeDimensionMenu = menuBuilder.getMenu();
        
        
        threeDimensionMenu.setMenuGroupString(menuBuilder.buildNewGroupMenu());

        try {
            IOUtils.copy(new FileInputStream(new File(metaDataMgr.getWebInfPath() + "/menu.xml")), stringWriter, "UTF-8");
            threeDimensionMenu.setMenuString(menuBuilder.buildMenu(stringWriter.toString()));
            menuBuilder.setXslFile(metaDataMgr.getWebInfPath() + "/menu_en.xsl");
            menuBuilder.setXslGroupFile(metaDataMgr.getWebInfPath() + "/menu_group_en.xsl");
            threeDimensionMenu.setMenuEnGroupString(menuBuilder.buildNewGroupMenu());
            threeDimensionMenu.setMenuEnString(menuBuilder.buildMenu(stringWriter.toString()));
        } catch (IOException ex) {
            Logger.getLogger(TrackerAppStartupEvent.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        MenuBuilder tmenuBuilder = new MenuBuilder();
        tmenuBuilder.setFileURL(metaDataMgr.getWebInfPath() + "/tree_menu.xml");
        ThreeDimensionMenu tthreeDimensionMenu = tmenuBuilder.getMenu();

        ArrayList myTree = tthreeDimensionMenu.getContents();


        metaDataMgr.setContext((String) threeDimensionMenu.getRenderer().getAttribute("context"));
        metaDataMgr.setDataBaseURL(databaseURL);
        metaDataMgr.setDataBaseUserName(userName);
        metaDataMgr.setDataBasePassword(password);
        metaDataMgr.setSqlServer(sqlServer);
        metaDataMgr.setEmailAddress(emailAddress);
        System.out.println("metaMgr email : " + metaDataMgr.getEmailAddress());
        metaDataMgr.setSMTPServer(smtpServer);
        System.out.println("metaMgr smtp : " + metaDataMgr.getSMTPServer());
        metaDataMgr.setEmailPassword(emailPassword);
        System.out.println("metaMgr passwod : " + metaDataMgr.getEmailPassword());
        metaDataMgr.setEmailPort(emailPort);
        metaDataMgr.setEmailSSL(emailSSL);
        metaDataMgr.setNewTap(NewTap);
        metaDataMgr.setImapServer(imapServer);
        metaDataMgr.setMNU((String) threeDimensionMenu.getRenderer().getAttribute("mnu"));
        metaDataMgr.setDisplay(display);
        metaDataMgr.setTabs(tabs);
        metaDataMgr.setCompanyName(companyName);
        metaDataMgr.setApiKey(apiKey);
        metaDataMgr.setApiSecret(apiSecret);
        metaDataMgr.setCompanyNameForLogo(companyNameForLogo);
        metaDataMgr.setVisibleCost(visibleCost);
        metaDataMgr.setProjectType(projectType);

        metaDataMgr.setAssetErpName(assetErpName);
        metaDataMgr.setRealEstateWeb(realEstateWeb);
        metaDataMgr.setAssetErpPassword(assetErpPassword);

        metaDataMgr.setStoreErpName(storeErpName);
        metaDataMgr.setStoreErpPassword(storeErpPassword);

        metaDataMgr.setRealEstateName(realEstateName);
        metaDataMgr.setRealEstatePassword(realEstatePassword);
        metaDataMgr.setConnectByRealEstate(connectByRealEstate);
        metaDataMgr.setShowCalendar(showCalendar);
        metaDataMgr.setRegionsMainCode(RegionsMainCode);
        metaDataMgr.setPageRefreshTimer(pageRefreshTimer);
        metaDataMgr.setDriverErp(driverErp);
        metaDataMgr.setDataBaseErpUrl(dataBaseErpUrl);
        metaDataMgr.setConfigurationSparePartsPrice(configurationSparePartsPrice);

        metaDataMgr.setTreeMenu(myTree);
        metaDataMgr.setSendMail(sendMail);
        metaDataMgr.setRunAutomationReports(runAutomationReports);
        metaDataMgr.setIsSsecretaryFullOption(isSsecretaryFullOption);
        metaDataMgr.setCandelete(candelete);
        metaDataMgr.setDateSpan(dateSpan);
        metaDataMgr.setExternalDB1(externalDB1);
        metaDataMgr.setExternalDB2(externalDB2);
        metaDataMgr.setCustomerServiceID(customerServiceID);
        metaDataMgr.setDataMigration(dataMigration);
        metaDataMgr.setWebDirectoryPath(webDirectoryPath);
        metaDataMgr.setDepartmentRootID(departmentRootID);
        metaDataMgr.setShowCommentType(showCommentType);
        metaDataMgr.setDepartmentIdForReports(departmentIdForReports);
        metaDataMgr.setProjectsDepartmentID(projectsDepartmentID);
        metaDataMgr.setMaxVisitNo(maxVisitNo);
        metaDataMgr.setUnitFinanceFlag(unitFinanceFlag);
        metaDataMgr.setDelayedTaskPeriod(DelayedTaskPeriod);
        metaDataMgr.setHasCallCenter(hasCallCenter);
        metaDataMgr.setSambaServer(sambaServer);
        metaDataMgr.setSambaUserName(sambaUserName);
        metaDataMgr.setSambaPassword(sambaPassword);
        metaDataMgr.setDefaultLanguage(defaultLanguage);
        metaDataMgr.setCheckAuthorization(checkAuthorization);
        metaDataMgr.setWebServiceUrl(webServiceUrl);
        metaDataMgr.setRunSessionKill(runSessionKill);
        metaDataMgr.setUserName(userName);
        metaDataMgr.setPassword(password);
        metaDataMgr.setTelesalesID(telesalesID);
        metaDataMgr.setTargetCalls(targetCalls);
        metaDataMgr.setMaxUsersNum(maxUsersNum);
        metaDataMgr.setDeleteClassification(deleteClassification);
        metaDataMgr.setCopyToFuture(copyToFuture);
        metaDataMgr.setReservationDefaultPeriod(PublicSettingsMgr.getCurrentInstance().getReservationDefaultPeriod());
        metaDataMgr.setAddonActive(addonActive);
        metaDataMgr.setHoursBeforeNeglect(hoursBeforeNeglect);
        servletContext.setAttribute("myMenu", threeDimensionMenu);
        SqlMgr sqlMgr = SqlMgr.getInstance();
        sqlMgr.getDocument();
        metaDataMgr.closeDataSource();

        // set meta data by fleet url to swich application
//        ApplicationUrlMgr applicationUrlMgr = ApplicationUrlMgr.getInstance();
//        WebBusinessObject fleetApplication = applicationUrlMgr.getApplicationFleet();
//        metaDataMgr.setFleetUrl((String) fleetApplication.getAttribute(ApplicationUrlMgr.ATTRIBUTE_URL));
//        metaDataMgr.setFleetCaptionAr((String) fleetApplication.getAttribute(ApplicationUrlMgr.ATTRIBUTE_CAPTION_AR));
//        metaDataMgr.setFleetCaptionEn((String) fleetApplication.getAttribute(ApplicationUrlMgr.ATTRIBUTE_CAPTION_EN));

        // set database configuration
        DatabaseConfigurationMgr databaseConfigurationMgr = DatabaseConfigurationMgr.getInstance();
        databaseConfigurationMgr.setBasicUrl(databaseURL);
        databaseConfigurationMgr.setBasicDriverClass(driverClass);
        databaseConfigurationMgr.setBasicUser(userName);
        databaseConfigurationMgr.setBasicPassword(password);

        databaseConfigurationMgr.setErpDriverClass(metaDataMgr.getDriverErp());
        databaseConfigurationMgr.setErpUrl(metaDataMgr.getDataBaseErpUrl());
        databaseConfigurationMgr.updateDatabaseConfigurationXML();
        
//              TeleComGateway telecomMgr = TeleComGateway.getInstance();
//       
//            try {
//                telecomMgr.callNumber("SIP/walid","phones","200");
//            } catch (IOException ex) {
//                Logger.getLogger(TrackerAppStartupEvent.class.getName()).log(Level.SEVERE, null, ex);
//            } catch (AuthenticationFailedException ex) {
//                Logger.getLogger(TrackerAppStartupEvent.class.getName()).log(Level.SEVERE, null, ex);
//            } catch (TimeoutException ex) {
//                Logger.getLogger(TrackerAppStartupEvent.class.getName()).log(Level.SEVERE, null, ex);
//            }
    }

    protected boolean initDBGateways() {
        return false;
    }

    protected void startTimer() {
//        System.out.println("starting timer....one minute.........");
//        servletContext.setAttribute("timerStatus","on");
//        MonthlyEvent  me = new MonthlyEvent();
//        long delay =24 * 60 * 60 * 1000;
//        swTimer t = new swTimer();
//        t.setDelay(delay);
//        t.addTimerListener(me);
//        t.start();
    }
}
