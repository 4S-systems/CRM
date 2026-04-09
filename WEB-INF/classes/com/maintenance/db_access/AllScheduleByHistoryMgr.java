package com.maintenance.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.tracker.db_access.IssueMgr;
import java.util.*;
import javax.servlet.http.HttpSession;
import java.sql.*;

import org.apache.log4j.xml.DOMConfigurator;

public class AllScheduleByHistoryMgr extends RDBGateWay {

    SqlMgr sqlMgr = SqlMgr.getInstance();
    private static AllScheduleByHistoryMgr allScheduleByHistoryMgr = new AllScheduleByHistoryMgr();

    public static AllScheduleByHistoryMgr getInstance() {
        logger.info("Getting UnitScheduleHistoryMgr Instance ....");
        return allScheduleByHistoryMgr;
    }

    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("all_schedule_by_history.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    

    

    public ArrayList getCashedTableAsBusObjects() {
        cashedData = new ArrayList();
        WebBusinessObject wbo = null;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add(wbo);
        }

        return cashedData;
    }

    public ArrayList getCashedTableAsArrayList() {

        cashedData = new ArrayList();
        WebBusinessObject wbo = null;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add((String) wbo.getAttribute("periodicId"));
        }

        return cashedData;
    }

    @Override
    protected void initSupportedQueries() {
       return; // throw new UnsupportedOperationException("Not supported yet.");
    }

}
