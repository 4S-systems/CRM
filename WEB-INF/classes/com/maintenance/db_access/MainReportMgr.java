package com.maintenance.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import java.sql.SQLException;
import java.util.*;
import java.sql.*;
import org.apache.log4j.xml.DOMConfigurator;

public class MainReportMgr extends RDBGateWay {

    private static MainReportMgr mainReportMgr = new MainReportMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();

    public static MainReportMgr getInstance() {
        logger.info("Getting MainReportMgr Instance ....");
        return mainReportMgr;
    }

    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                logger.info("MainReportMgr ..***********.trying to get the XML file from path:: " + webInfPath);
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("main_report.xml")));
            } catch (Exception e) {
                logger.info("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public ArrayList getCashedTableAsArrayList() {
        cashedData = new ArrayList();
        return cashedData;
    }

    @Override
    protected void initSupportedQueries() {
     return;//    throw new UnsupportedOperationException("Not supported yet.");
    }
}
