package com.tracker.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import java.sql.SQLException;
import java.util.*;
import java.sql.*;
import javax.servlet.http.HttpServletRequest;
import org.apache.log4j.xml.DOMConfigurator;

public class ChangeDateHistoryMgr extends RDBGateWay {

    private static ChangeDateHistoryMgr changeDateHistoryMgr = new ChangeDateHistoryMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();

    public static ChangeDateHistoryMgr getInstance() {
        logger.info("Getting ChangeDateHistoryMgr Instance ....");
        return changeDateHistoryMgr;
    }

    public ChangeDateHistoryMgr() {
    }

    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("change_date_history.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public ArrayList getCashedTableAsArrayList() {

        return null;
    }

    public boolean saveChangeDate(HttpServletRequest request, WebBusinessObject userWbo) {
        return false;
    }

    @Override
    protected void initSupportedQueries() {
     return; //   throw new UnsupportedOperationException("Not supported yet.");
    }
}
