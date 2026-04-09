package com.maintenance.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import java.sql.SQLException;
import java.util.*;
import java.sql.*;
import org.apache.log4j.xml.DOMConfigurator;

public class TempDayMgr extends RDBGateWay {

    private static TempDayMgr tempDayMgr = new TempDayMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();

    public static TempDayMgr getInstance() {
        logger.info("Getting tempDayMgr Instance ....");
        return tempDayMgr;
    }

    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("temp_day.xml")));
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
    
    public void executeDateOfMonth(java.sql.Date bDate,java.sql.Date eDate) {
        Vector SQLparams = new Vector();
        Connection connection = null;
        Vector queryResult = null;
        
        SQLparams.addElement(new DateValue(bDate));
        SQLparams.addElement(new DateValue(eDate));
        SQLCommandBean forQuery = new SQLCommandBean();
        
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery("{call creatdays(?,?)}");
            forQuery.setparams(SQLparams);
            
            forQuery.execute();
            
            
        } catch (SQLException se) {
            logger.error("database error " + se.getMessage());
            System.out.print("date error"+se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }
        
    }
    
     public Vector getAllDayOfMonth() {

        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        StringBuffer query = new StringBuffer(sqlMgr.getSql("getAllDayOfMonth").trim());


        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            queryResult = forQuery.executeQuery();


        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
            System.out.print("Error SQL Exception  " + se.getMessage());
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
      return;//  throw new UnsupportedOperationException("Not supported yet.");
    }
     
}
