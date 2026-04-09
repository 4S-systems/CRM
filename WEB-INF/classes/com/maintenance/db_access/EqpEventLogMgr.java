package com.maintenance.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import java.sql.SQLException;
import java.util.*;
import javax.servlet.http.HttpSession;
import java.sql.*;
import org.apache.log4j.xml.DOMConfigurator;

public class EqpEventLogMgr extends RDBGateWay {
    
    SqlMgr sqlMgr = SqlMgr.getInstance();
    private static EqpEventLogMgr eqpEventLogMgr = new EqpEventLogMgr();
    
    public EqpEventLogMgr() {
    }
    
    public static EqpEventLogMgr getInstance() {
        logger.info("Getting EqpEventLogMgr Instance ....");
        return eqpEventLogMgr;
    }
    
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("eqp_event_log.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }
    
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue((String) wbo.getAttribute("unitId")));
        params.addElement(new StringValue((String) wbo.getAttribute("lastReading")));
        params.addElement(new StringValue((String) wbo.getAttribute("totalReading")));
        params.addElement(new StringValue((String) wbo.getAttribute("action")));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertEqpEventLogSQL").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();

            //
            cashData();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
                return false;
            }
        }

        return (queryResult > 0);
        
    }
    
    public int getLastActionReading(String unitId)throws NoUserInSessionException {
        
        int lastActionReading=0;
        
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        Vector queryResult = new Vector();
//        String query="select LAST_ACTION_TOTAL_READING from eqp_event_log where date=(select max(ENTRY_DATE) from eqp_event_log)and unit_id= ? ";
        String query=sqlMgr.getSql("getLastActionReading");
        
        params.addElement(new StringValue(unitId));
        
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(query.trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeQuery();
            
            Row r = null;
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                lastActionReading = Integer.parseInt(r.getString(1));
            }
            cashData();
            
        } catch (SQLException ex) {
            ex.printStackTrace();
        } catch (UnsupportedTypeException ex) {
            ex.printStackTrace();
        } catch (NumberFormatException ex) {
            ex.printStackTrace();
        } catch (NoSuchColumnException ex) {
            ex.printStackTrace();
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }
        
        return lastActionReading;
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
            cashedData.add((String) wbo.getAttribute("empName"));
        }
        
        return cashedData;
    }
    
    public Connection getDatabaseConnection() throws SQLException {
        return dataSource.getConnection();
    }

    @Override
    protected void initSupportedQueries() {
      return; //  throw new UnsupportedOperationException("Not supported yet.");
    }
}
