package com.maintenance.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import java.sql.SQLException;
import java.util.*;
import java.sql.*;
import org.apache.log4j.xml.DOMConfigurator;

public class EquipmentMaintenanceMgr extends RDBGateWay {

    SqlMgr sqlMgr = SqlMgr.getInstance();
    private static EquipmentMaintenanceMgr equipmentMaintenanceMgr = new EquipmentMaintenanceMgr();

    public static EquipmentMaintenanceMgr getInstance() {
        logger.info("Getting EquipmentMaintenanceMgr Instance ....");
        return equipmentMaintenanceMgr;
    }

    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("equipment_maintenance.xml")));
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
            cashedData.add((String) wbo.getAttribute("issueTitle"));
        }

        return cashedData;
    }

    public Vector getFutureMaintenace(String equipmentID) {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Calendar c = Calendar.getInstance();

        Vector params = new Vector();
        params.addElement(new DateValue(new java.sql.Date(c.getTimeInMillis())));
        c.setTimeInMillis(c.getTimeInMillis() + (6 * 30 * 24 * 60 * 60 * 1000L));
        StringBuffer query = new StringBuffer(sqlMgr.getSql("selectFutureMaintenace").trim() + " '" + equipmentID + "'");

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        params.addElement(new DateValue(new java.sql.Date(c.getTimeInMillis())));
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(params);
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

    public Vector getLastMaintenace(String equipmentID) {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Calendar c = Calendar.getInstance();

        java.sql.Date d1=new java.sql.Date(c.getTimeInMillis());
        c.setTimeInMillis(c.getTimeInMillis() - (6 * 30 * 24 * 60 * 60 * 1000L));
        java.sql.Date d2=new java.sql.Date(c.getTimeInMillis());

        Vector params = new Vector();
        params.addElement(new DateValue(d2));
        params.addElement(new DateValue(d1));
//        params.addElement(new DateValue(new java.sql.Date(c.getTimeInMillis())));
//        c.setTimeInMillis(c.getTimeInMillis() - (6 * 30 * 24 * 60 * 60 * 1000L));
        StringBuffer query = new StringBuffer(sqlMgr.getSql("selectFutureMaintenace").trim() + " '" + equipmentID + "'");

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
//        params.addElement(new DateValue(new java.sql.Date(c.getTimeInMillis())));
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(params);
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
    return; //    throw new UnsupportedOperationException("Not supported yet.");
    }
}
