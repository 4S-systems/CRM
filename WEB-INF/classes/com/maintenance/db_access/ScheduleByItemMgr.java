package com.maintenance.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import java.sql.SQLException;
import java.util.*;
import java.sql.*;
import org.apache.log4j.xml.DOMConfigurator;

public class ScheduleByItemMgr extends RDBGateWay {

    private static ScheduleByItemMgr scheduleByItemMgr = new ScheduleByItemMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();

    public static ScheduleByItemMgr getInstance() {
        logger.info("Getting ScheduleByItemMgr Instance ....");
        return scheduleByItemMgr;
    }

    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("schedule_by_item.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
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
    
     public boolean checkcompiledViewScheduleByItem () {
        
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        boolean statusView = true;
        StringBuffer query = new StringBuffer(sqlMgr.getSql("checkcompiledViewScheduleByItem").trim());

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
         Vector SQLparams = new Vector();
        
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            queryResult = forQuery.executeQuery();
            
            
        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
            statusView = false;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
               
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
            return statusView;
        }
        
     }
     
     
     public Vector getAllScheduleItem() {
        
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        StringBuffer query = new StringBuffer(sqlMgr.getSql("getAllScheduleItem").trim());

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            queryResult = forQuery.executeQuery();
            
            
        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }
        
        Vector resultBusObjs = new Vector();
        
        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }

    @Override
    protected void initSupportedQueries() {
     return; //   throw new UnsupportedOperationException("Not supported yet.");
    }
    
}
