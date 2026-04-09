/*
 * MetaDataMgr.java
 *
 * Created on March 25, 2004, 9:24 AM
 */
package com.silkworm.common;

import com.silkworm.persistence.relational.RDBGateWay;
import java.util.Vector;
import java.util.jar.*;
import java.io.*;
import java.util.ArrayList;
import java.util.Hashtable;
import org.apache.log4j.xml.DOMConfigurator;

/**
 *
 * @author walid
 */
public class MetaDataMgr extends RDBGateWay {

    /**
     * Creates a new instance of MetaDataMgr
     */
    private static final MetaDataMgr META_DATA_MGR = new MetaDataMgr();
    String metaDataSource = null;
    JarFile jf = null;
    private String dataBaseURL = null;
    String appContext = null;
    boolean sumup = false;
    boolean appletRender = false;
    private boolean isSsecretaryFullOption = false;
    String backupDir = null;
    String mnu = null;
    String appLocale = null;
    String appCountry = null;
    String emailAddress = null;
    String smtpServer = null;
    String emailPassword = null;
    String emailPort = null;
    String emailSSL = null;
    String NewTap = null;
    String imapServer = null;
    String appSqlServer = null;
    Vector vecBuild = new Vector();
    String display = null;
    String companyName = null;
    String visibleCost = null;
    String projectType = null;
    String portServer = null;
    String localHost = null;
    String localHostInternal = null;
    String sendMail = null;
    String unitFlag = null;
    String delayedPeriod = null;
    private String runAutomationReports;
    private String assetErpName = null;
    private String realEstateWeb = null;
    private String assetErpPassword = null;
    private String storeErpName = null;
    private String storeErpPassword = null;
    private String driverErp = null;
    private String dataBaseErpUrl = null;
    private String realEstateName = null;
    private String realEstatePassword = null;
    private String connectByRealEstate = null;
    private String showCalendar = null;
    private String RegionsMainCode = null;
    private String pageRefreshTimer = "";
    private String dateSpan = null;
    // to change url
    private String fleetUrl;
    private String fleetCaptionAr;
    private String fleetCaptionEn;
    private ArrayList treeMenu;
    private String tabs = null;
    private String configurationSparePartsPrice = null;
    private String candelete = null;
    private Hashtable logos;
    private String realRootPath;
    private String companyNameForLogo = null;
    private String externalDB1;
    private String externalDB2;
    private String customerServiceID;
    private String dataMigration;
    private String webDirectoryPath;
    private String departmentRootID;
    private String showCommentType;
    private String departmentIdForReports;
    private String projectsDepartmentID;
    private String maxVisitNo;
    private String hasCallCenter;
    private String sambaServer;
    private String sambaUserName;
    private String sambaPassword;
    private String dbUserName;
    private String dbPassword;
    private String defaultLanguage;
    private String checkAuthorization;
    private String webServiceUrl;
    private String runSessionKill;
    private String userName;
    private String password;
    private String telesalesID;
    private String targetCalls;
    private String maxUsersNum;
    private String deleteClassification;
    private String copyToFuture;
    private String reservationDefaultPeriod;
    private String addonActive;
    private String apiKey;
    private String apiSecret;
    private String hoursBeforeNeglect;
    public static MetaDataMgr getInstance() {
        logger.info("Getting MetaData Manager Instance ....");
        return META_DATA_MGR;
    }

    public MetaDataMgr() {
    }

    public java.util.ArrayList getCashedTableAsArrayList() {
        return null;
    }

    protected void initSupportedForm() {
    }

    public boolean saveObject(com.silkworm.business_objects.WebBusinessObject wbo) throws java.sql.SQLException {
        return false;
    }

    public void setMetaData(String source) {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
            backupDir = webInfPath + "/" + "backup";
            File file = new File(backupDir);
            if (!file.exists()) {
                if (!file.mkdir()) {
                    backupDir = null;
                }
            }
        }
        metaDataSource = source;
        try {
            jf = new JarFile(webInfPath + "/lib/" + source);
        } catch (IOException ioex) {
            logger.error("Severe Error: Unable to locate metadata source " + ioex.getMessage());
        }

    }

    public InputStream getMetadata(String metaTable) {
        try {
            JarEntry entry = jf.getJarEntry(metaTable);
            return (null != entry ? jf.getInputStream(entry) : null);
        } catch (IOException ioex) {
            logger.error("Severe error: unable to return inputstream for metadata: " + metaTable + ioex.getMessage());
            return null;
        }

    }

    public void setContext(String context) {

        appContext = context;
    }

    public String getContext() {
        return appContext;
    }
    public void setApiKey(String apiKey) {

        this.apiKey = apiKey;
    }

    public String getHoursBeforeNeglect() {
        return hoursBeforeNeglect;
    }

    public void setHoursBeforeNeglect(String hoursBeforeNeglect) {
        this.hoursBeforeNeglect = hoursBeforeNeglect;
    }
    
    public String getApiKey() {
        return apiKey;
    }
    public void setApiSecret(String apiSecret) {

        this.apiSecret = apiSecret;
    }

    public String getApiSecret() {
        return apiSecret;
    }

    public void setMyLocale(String myLocale) {

        appLocale = myLocale;
    }

    public String getMyLocale() {
        return appLocale;
    }

    public void setMyCountry(String myCountry) {

        appCountry = myCountry;
    }

    public String getMyCountry() {
        return appCountry;
    }

    public void setBackupDir(String dirPath) {

        backupDir = dirPath;
    }

    public String getBackupDir() {
        return backupDir;
    }

    public void setEmailAddress(String email) {

        emailAddress = email;
    }

    public String getEmailAddress() {
        return emailAddress;
    }

    public void setSMTPServer(String smtp) {

        smtpServer = smtp;
    }

    public String getSMTPServer() {
        return smtpServer;
    }

    public void setEmailPassword(String password) {

        emailPassword = password;
    }

    public String getEmailPassword() {
        return emailPassword;
    }

    public String getEmailPort() {
        return emailPort;
    }

    public void setEmailPort(String emailPort) {
        this.emailPort = emailPort;
    }

    public String getEmailSSL() {
        return emailSSL;
    }

    public void setEmailSSL(String emailSSL) {
        this.emailSSL = emailSSL;
    }
    
    public String getNewTap() {
        return NewTap;
    }

    public void setNewTap(String NewTap) {
        this.NewTap = NewTap;
    }

    public String getImapServer() {
        return imapServer;
    }

    public void setImapServer(String imapServer) {
        this.imapServer = imapServer;
    }

    public void setSumFlag(String flag) {

        if (flag.equalsIgnoreCase("true")) {
            sumup = true;
        } else {
            sumup = false;
        }
    }

    public void setAppletRender(String render) {

        if (render.equalsIgnoreCase("applet")) {
            appletRender = true;
        } else {
            appletRender = false;
        }
    }

    public boolean getSumFlag() {
        return sumup;
    }

    public boolean appletRender() {
        return appletRender;
    }

    public void setMNU(String purchased) {

        mnu = purchased;
    }

    public String getMNU() {

        return mnu;
    }

    public void setUnitFinanceFlag(String flag) {

        System.out.println("Unit Flag = " + flag);
        unitFlag = flag;
    }

    public String getUnitFinanceFlag() {
        return unitFlag;
    }
    
    public void setDelayedTaskPeriod(String flag) {

        System.out.println("Delayed Tasks Period = " + flag);
        delayedPeriod = flag;
    }

    public String getDelayedTaskPeriod() {
        return delayedPeriod;
    }

    public String getSqlServer() {
        return appSqlServer;
    }

    public void setSqlServer(String appSqlServer) {
        this.appSqlServer = appSqlServer;
    }

    public boolean closeDataSource() {

        try {
            jf.close();
        } catch (IOException ioex) {
            logger.error("Unable to close Meta Data Source");
            return false;
        }
        return true;
    }

    public Vector getVecBuild() {
        return vecBuild;
    }

    public void setVecBuild(Vector vecBuild) {
        this.vecBuild = vecBuild;
    }

    public String getDisplay() {
        return display;
    }

    public void setDisplay(String display) {
        this.display = display;
    }

    public String getTabs() {
        return tabs;
    }

    public void setTabs(String tabs) {
        this.tabs = tabs;
    }

    public String getWebInfPath() {
        return webInfPath;
    }

    public String getCompanyName() {
        return companyName;
    }

    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }

    public String getVisibleCost() {
        return visibleCost;
    }

    public void setVisibleCost(String visibleCost) {
        this.visibleCost = visibleCost;
    }

    public String getProjectType() {
        return projectType;
    }

    public void setProjectType(String projectType) {
        this.projectType = projectType;
    }

    public String getAssetErpPassword() {
        return assetErpPassword;
    }

    public void setAssetErpPassword(String storeErpPassword) {
        this.assetErpPassword = storeErpPassword;
    }

    public String getDriverErp() {
        return driverErp;
    }

    public void setDriverErp(String driverErp) {
        this.driverErp = driverErp;
    }

    public String getDataBaseErpUrl() {
        return dataBaseErpUrl;
    }

    public void setDataBaseErpUrl(String dataBaseErpUrl) {
        this.dataBaseErpUrl = dataBaseErpUrl;
    }

    public String getAssetErpName() {
        return assetErpName;
    }

    public void setAssetErpName(String storeErpName) {
        this.assetErpName = storeErpName;
    }

    public String getRealEstateWeb() {
        return realEstateWeb;
    }

    public void setRealEstateWeb(String realEstateWeb) {
        this.realEstateWeb = realEstateWeb;
    }

    public String getConfigurationSparePartsPrice() {
        return configurationSparePartsPrice;
    }

    public void setConfigurationSparePartsPrice(String configurationSparePartsPrice) {
        this.configurationSparePartsPrice = configurationSparePartsPrice;
    }

    public String getStoreErpName() {
        return storeErpName;
    }

    public void setStoreErpName(String storeErpName) {
        this.storeErpName = storeErpName;
    }

    public String getStoreErpPassword() {
        return storeErpPassword;
    }

    public void setStoreErpPassword(String storeErpPassword) {
        this.storeErpPassword = storeErpPassword;
    }

    public String getFleetUrl() {
        return fleetUrl;
    }

    public void setFleetUrl(String fleetUrl) {
        this.fleetUrl = fleetUrl;
    }

    public String getFleetCaptionAr() {
        return fleetCaptionAr;
    }

    public void setFleetCaptionAr(String fleetCaptionAr) {
        this.fleetCaptionAr = fleetCaptionAr;
    }

    public String getFleetCaptionEn() {
        return fleetCaptionEn;
    }

    public void setFleetCaptionEn(String fleetCaptionEn) {
        this.fleetCaptionEn = fleetCaptionEn;
    }

    public void setTreeMenu(ArrayList treeMenu) {
        this.treeMenu = treeMenu;
    }

    public ArrayList getTreeMenu() {
        return this.treeMenu;
    }

    public String getPortServer() {
        return portServer;
    }

    public void setPortServer(String portServer) {
        this.portServer = portServer;
    }

    public String getLocalHost() {
        return localHost;
    }

    public void setLocalHost(String localHost) {
        this.localHost = localHost;
    }

    public String getLocalHostInternal() {
        return localHostInternal;
    }

    public void setLocalHostInternal(String localHostInternal) {
        this.localHostInternal = localHostInternal;
    }

    public String getSendMail() {
        return sendMail;
    }

    public void setSendMail(String sendMail) {
        this.sendMail = sendMail;
    }

    @Override
    protected void initSupportedQueries() {
        // throw new UnsupportedOperationException("Not supported yet.");
        return;
    }

    public InputStream getQueries(String serviceName) {

        return getMetadata(serviceName);

    }

    public String getRealEstateName() {
        return realEstateName;
    }

    public void setRealEstateName(String realEstateName) {
        this.realEstateName = realEstateName;
    }

    public String getRealEstatePassword() {
        return realEstatePassword;
    }

    public void setRealEstatePassword(String realEstatePassword) {
        this.realEstatePassword = realEstatePassword;
    }

    public String getConnectByRealEstate() {
        return connectByRealEstate;
    }

    public void setConnectByRealEstate(String connectByRealEstate) {
        this.connectByRealEstate = connectByRealEstate;
    }

    public String getCandelete() {
        return candelete;
    }

    public void setCandelete(String candelete) {
        this.candelete = candelete;
    }

    public boolean canDelete() {
        if (candelete.equals("0")) {
            return false;
        } else {
            return true;
        }

    }

    public String getDataBaseURL() {
        return dataBaseURL;
    }

    public void setDataBaseURL(String dataBaseURL) {
        this.dataBaseURL = dataBaseURL;
    }

    /**
     * @return the showCalendar
     */
    public String getShowCalendar() {
        return showCalendar;
    }

    public void setShowCalendar(String showCalendar) {
        this.showCalendar = showCalendar;
    }
    
    public String getRegionsMainCode() {
        return RegionsMainCode;
    }

    public void setRegionsMainCode(String RegionsMainCode) {
        this.RegionsMainCode = RegionsMainCode;
    }

    public String getPageRefreshTimer() {
        return pageRefreshTimer;
    }

    public void setPageRefreshTimer(String pageRefreshTimer) {
        this.pageRefreshTimer = pageRefreshTimer;
    }

    public String getDateSpan() {
        return dateSpan;
    }

    public void setDateSpan(String dateSpan) {
        this.dateSpan = dateSpan;
    }

    public Hashtable getLogos() {
        return logos;
    }

    public void setLogos(Hashtable logos) {
        this.logos = logos;
    }

    public String getRealRootPath() {
        return realRootPath;
    }

    public void setRealReportsPath(String realReportsPath) {
        this.realRootPath = realReportsPath;
    }

    public String getRunAutomationReports() {
        return runAutomationReports;
    }

    public void setRunAutomationReports(String runAutomationReports) {
        this.runAutomationReports = runAutomationReports;
    }

    public String getCompanyNameForLogo() {
        return companyNameForLogo;
    }

    public void setCompanyNameForLogo(String companyNameForLogo) {
        this.companyNameForLogo = companyNameForLogo;
    }

    public String getExternalDB1() {
        return externalDB1;
    }

    public void setExternalDB1(String externalDB1) {
        this.externalDB1 = externalDB1;
    }

    public String getExternalDB2() {
        return externalDB2;
    }

    public void setExternalDB2(String externalDB2) {
        this.externalDB2 = externalDB2;
    }

    public String getCustomerServiceID() {
        return customerServiceID;
    }

    public void setCustomerServiceID(String customerServiceID) {
        this.customerServiceID = customerServiceID;
    }

    public String getDataMigration() {
        return dataMigration;
    }

    public void setDataMigration(String dataMigration) {
        this.dataMigration = dataMigration;
    }

    public String getWebDirectoryPath() {
        return webDirectoryPath;
    }

    public void setWebDirectoryPath(String webDirectoryPath) {
        this.webDirectoryPath = webDirectoryPath;
    }

    public String getDepartmentRootID() {
        return departmentRootID;
    }

    public void setDepartmentRootID(String departmentRootID) {
        this.departmentRootID = departmentRootID;
    }

    public String getShowCommentType() {
        return showCommentType;
    }

    public void setShowCommentType(String showCommentType) {
        this.showCommentType = showCommentType;
    }

    public boolean isIsSsecretaryFullOption() {
        return isSsecretaryFullOption;
    }

    public void setIsSsecretaryFullOption(String isSsecretaryFullOption) {
        this.isSsecretaryFullOption = "1".equalsIgnoreCase(isSsecretaryFullOption);
    }

    public String getDepartmentIdForReports() {
        return departmentIdForReports;
    }

    public void setDepartmentIdForReports(String departmentIdForReports) {
        this.departmentIdForReports = departmentIdForReports;
    }

    public String getProjectsDepartmentID() {
        return projectsDepartmentID;
    }

    public void setProjectsDepartmentID(String projectsDepartmentID) {
        this.projectsDepartmentID = projectsDepartmentID;
    }

    public String getMaxVisitNo() {
        return maxVisitNo;
    }

    public void setMaxVisitNo(String maxVisitNo) {
        this.maxVisitNo = maxVisitNo;
    }

    public String getHasCallCenter() {
        return hasCallCenter;
    }

    public void setHasCallCenter(String hasCallCenter) {
        this.hasCallCenter = hasCallCenter;
    }

    public String getSambaServer() {
        return sambaServer;
    }

    public void setSambaServer(String sambaServer) {
        this.sambaServer = sambaServer;
    }

    public String getSambaUserName() {
        return sambaUserName;
    }

    public void setSambaUserName(String sambaUserName) {
        this.sambaUserName = sambaUserName;
    }

    public String getSambaPassword() {
        return sambaPassword;
    }

    public void setSambaPassword(String sambaPassword) {
        this.sambaPassword = sambaPassword;
    }
    
    public String getDataBaseUserName() {
        return dbUserName;
    }

    public void setDataBaseUserName(String dbUserName) {
        this.dbUserName = dbUserName;
    }
    
    public String getDataBasePassword() {
        return dbPassword;
    }

    public void setDataBasePassword(String dbPassword) {
        this.dbPassword = dbPassword;
    }

    public String getDefaultLanguage() {
        return defaultLanguage;
    }

    public void setDefaultLanguage(String defaultLanguage) {
        this.defaultLanguage = defaultLanguage;
    }

    public String getCheckAuthorization() {
        return checkAuthorization;
    }

    public void setCheckAuthorization(String checkAuthorization) {
        this.checkAuthorization = checkAuthorization;
    }

    public String getWebServiceUrl() {
        return webServiceUrl;
    }

    public void setWebServiceUrl(String webServiceUrl) {
        this.webServiceUrl = webServiceUrl;
    }

    public String getRunSessionKill() {
        return runSessionKill;
    }

    public void setRunSessionKill(String runSessionKill) {
        this.runSessionKill = runSessionKill;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }
    
    public String getTelesalesID() {
        return telesalesID;
    }

    public void setTelesalesID(String telesalesID) {
        this.telesalesID = telesalesID;
    }

    public String getTargetCalls() {
        return targetCalls;
    }

    public void setTargetCalls(String targetCalls) {
        this.targetCalls = targetCalls;
    }

    public String getMaxUsersNum() {
        return maxUsersNum;
    }

    public void setMaxUsersNum(String maxUsersNum) {
        this.maxUsersNum = maxUsersNum;
    }

    public String getDeleteClassification() {
        return deleteClassification;
    }

    public void setDeleteClassification(String deleteClassification) {
        this.deleteClassification = deleteClassification;
    }

    public String getCopyToFuture() {
        return copyToFuture;
    }

    public void setCopyToFuture(String copyToFuture) {
        this.copyToFuture = copyToFuture;
    }

    public String getReservationDefaultPeriod() {
        return reservationDefaultPeriod;
    }

    public void setReservationDefaultPeriod(String reservationDefaultPeriod) {
        this.reservationDefaultPeriod = reservationDefaultPeriod;
    }

    public String getAddonActive() {
        return addonActive;
    }

    public void setAddonActive(String addonActive) {
        this.addonActive = addonActive;
    }
    
}
