package com.ApplicationConfiguration.db_access;

import com.silkworm.business_objects.BusinessForm;
import com.silkworm.business_objects.DOMFabricatorBean;
import com.silkworm.business_objects.SqlMgr;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.persistence.relational.RDBGateWay;

import java.sql.SQLException;
import java.util.ArrayList;

import org.apache.log4j.xml.DOMConfigurator;

public class ApplicationUrlMgr extends RDBGateWay {

    public static ApplicationUrlMgr getInstance() {
        return applicationUrlMgr;
    }

    @Override protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("application_url.xml")));
            } catch (Exception e) {
                logger.error(e.getMessage());
            }
        }
    }

    @Override public ArrayList getCashedTableAsArrayList() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public WebBusinessObject getApplicationMaintenance() {
        return ApplicationUrlMgr.applicationUrlMgr.getOnSingleKey(ApplicationUrlMgr.APPLICATION_MAINTENANCE);
    }

//    public WebBusinessObject getApplicationFleet() {
//        return ApplicationUrlMgr.applicationUrlMgr.getOnSingleKey(ApplicationUrlMgr.APPLICATION_FLEET);
//    }
    
//    public String checkMaintenanceUrl(String url) {
//        return (url != null) ? url : ApplicationUrlMgr.DEFAULT_URL_MAINTENANCE;
//    }
//    
    public String checkFleetUrl(String url) {
        return (url != null) ? url : ApplicationUrlMgr.DEFAULT_URL_FLEET;
    }
    
    private static ApplicationUrlMgr applicationUrlMgr = new ApplicationUrlMgr();
    private SqlMgr sqlMgr = SqlMgr.getInstance();

    public static final String ATTRIBUTE_URL_NAME = "urlName";
    public static final String ATTRIBUTE_URL = "url";
    public static final String ATTRIBUTE_CAPTION_AR = "captionAr";
    public static final String ATTRIBUTE_CAPTION_EN = "captionEn";
    public static final String APPLICATION_MAINTENANCE = "MAINTENANCE";
    public static final String APPLICATION_FLEET = "FLEET";
    public static final String DEFAULT_URL_MAINTENANCE = "http://127.0.0.1:8084/ArMaint/TrackerLoginServlet";
    public static final String DEFAULT_URL_FLEET = "http://127.0.0.1:8084/FLEET/TrackerLoginServlet";
    public static final String PAGE_URL_ERROR = "docs/help/url_error.jsp";

    @Override
    protected void initSupportedQueries() {
     //   throw new UnsupportedOperationException("Not supported yet.");
        return;
    }
}
