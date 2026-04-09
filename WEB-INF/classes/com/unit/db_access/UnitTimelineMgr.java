/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.unit.db_access;

import com.silkworm.business_objects.BusinessForm;
import com.silkworm.business_objects.DOMFabricatorBean;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.persistence.relational.DateValue;
import com.silkworm.persistence.relational.NullValue;
import com.silkworm.persistence.relational.RDBGateWay;
import com.silkworm.persistence.relational.Row;
import com.silkworm.persistence.relational.SQLCommandBean;
import com.silkworm.persistence.relational.StringValue;
import com.silkworm.persistence.relational.TimestampValue;
import com.silkworm.persistence.relational.UniqueIDGen;
import com.silkworm.persistence.relational.UnsupportedTypeException;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.Vector;
import org.apache.log4j.xml.DOMConfigurator;

/**
 *
 * @author java3
 */
public class UnitTimelineMgr extends RDBGateWay{
    
    
    public static UnitTimelineMgr unitTimelineMgr = new UnitTimelineMgr();

    public static UnitTimelineMgr getInstance() {
        logger.info("Getting UnitTimelineMgr Instance ....");
        return unitTimelineMgr;
    }

    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }
    
      public boolean saveObject(WebBusinessObject timeLineWBO, WebBusinessObject loggedUser) {
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult;
        
        String dateStr = (String) timeLineWBO.getAttribute("UNIT_DATE");
        java.util.Date myDate = new java.util.Date(dateStr);
        java.sql.Date sqlDate = new java.sql.Date(myDate.getTime());
        
        java.util.Date parsed = new java.util.Date();
        java.sql.Date creationDate = new java.sql.Date(parsed.getTime());
        
        params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue((String) timeLineWBO.getAttribute("UNIT_ID")));
        params.addElement(new DateValue(sqlDate));
        params.addElement(new StringValue((String) timeLineWBO.getAttribute("DATE_TYPE")));
        params.addElement(new TimestampValue(new Timestamp(System.currentTimeMillis())));
        params.addElement(new StringValue((String) loggedUser.getAttribute("userId")));
        params.addElement(new StringValue("63")); // current status (Initial)
        params.addElement(new NullValue()); // delay time
        params.addElement(new StringValue("UL")); // option 1
        params.addElement(new StringValue("UL")); // option 2
        params.addElement(new StringValue("UL")); // option 3
        params.addElement(new StringValue("UL")); // option 4
        params.addElement(new StringValue("UL")); // option 5
        params.addElement(new StringValue("UL")); // option 6
        try {
            beginTransaction();
            forInsert.setConnection(transConnection);
//            String myQ = "INSERT INTO UNIT_TIME VALUES (?, ?, ?, ?, ?, ?)";
//            forInsert.setSQLQuery(myQ);
            forInsert.setSQLQuery(getQuery("insertUnitDate").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            endTransaction();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        }
        return (queryResult > 0);
    }
      
    public boolean deleteTimeLine(String timeLineID) {
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult;
        params.addElement(new StringValue(timeLineID));
        try {
            beginTransaction();
            forInsert.setConnection(transConnection);
            String myQ = "DELETE UNIT_TIME WHERE ID = ?";
            forInsert.setSQLQuery(myQ);
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            endTransaction();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        }
        return (queryResult > 0);
    }
    
    public boolean editTimeLine(String timeLineID, WebBusinessObject timeLineWBO, WebBusinessObject loggedUser) {
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult;
        String dateStr = (String) timeLineWBO.getAttribute("UNIT_DATE");
        java.util.Date myDate = new java.util.Date(dateStr);
        java.sql.Date sqlDate = new java.sql.Date(myDate.getTime());
        
        java.util.Date parsed = new java.util.Date();
        java.sql.Date creationDate = new java.sql.Date(parsed.getTime());
        
        params.addElement(new DateValue(sqlDate));
        params.addElement(new StringValue((String) timeLineWBO.getAttribute("DATE_TYPE")));
        params.addElement(new TimestampValue(new Timestamp(System.currentTimeMillis())));
        params.addElement(new StringValue((String) loggedUser.getAttribute("userId")));
        params.addElement(new StringValue(timeLineID));
        try {
            beginTransaction();
            forInsert.setConnection(transConnection);
            String myQ = "UPDATE UNIT_TIME SET UNIT_DATE = ?, DATE_TYPE = ?, CREATION_TIME = ?, CREATED_BY = ? WHERE ID = ?";
            forInsert.setSQLQuery(myQ);
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            endTransaction();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        }
        return (queryResult > 0);
    }
    
    public WebBusinessObject getSpecificUnitDate(String unitID, String dateType) {
        Connection connection = null;
        
        WebBusinessObject resultBusObj = null;
        
        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(unitID));
        SQLparams.addElement(new StringValue(dateType));
        
        Vector queryResult;
        
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getSpecificUnitDate").trim());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
            Row r;
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                resultBusObj = fabricateBusObj(r);
            }
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } catch (SQLException e) {
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return null;
            }
        }
        return resultBusObj;
    }


    @Override
       protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("unit_time.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }
    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
    }


    @Override
    public ArrayList getCashedTableAsArrayList() {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }
    
}
