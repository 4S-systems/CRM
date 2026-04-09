package com.maintenance.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import java.sql.SQLException;
import java.util.*;
import java.sql.*;
import javax.servlet.http.HttpServletRequest;
import org.apache.log4j.xml.DOMConfigurator;

public class EquipmentSuppliersMgr extends RDBGateWay {

    private static EquipmentSuppliersMgr equipmentSuppliersMgr = new EquipmentSuppliersMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();

    public EquipmentSuppliersMgr() {
    }

    public static EquipmentSuppliersMgr getInstance() {
        logger.info("Getting EquipmentSuppliersMgr Instance ....");
        return equipmentSuppliersMgr;
    }

    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("equipment_suppliers.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public boolean saveObject(HttpServletRequest request) {
        Vector params = new Vector();
        Vector empBasicParams = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue(request.getParameter("equipmentID")));
        params.addElement(new StringValue(request.getParameter("supplierName")));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertEquipmentSuppliersSQL").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
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

    public boolean deleteObject(HttpServletRequest request) {
        Vector params = new Vector();
        Vector empBasicParams = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue(request.getParameter("equipmentID")));
        params.addElement(new StringValue(request.getParameter("supplierID")));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("deleteEquipmentSupplierSQL").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
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

    public Vector getSuppliersByEquipment(HttpServletRequest request) {

        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        StringBuffer query;// = new StringBuffer(sqlMgr.getSql("selectSuppliersByEquipment").trim());
        Vector params = new Vector();
        params.addElement(new StringValue(request.getParameter("equipmentID")));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();


        try {
//            if(getOnArbitraryKey((String) request.getParameter("equipmentID"), "key1").size() > 0){
            query = new StringBuffer(sqlMgr.getSql("selectSuppliersByEquipmentSQL").trim());
            forQuery.setparams(params);
//            } else {
//                query = new StringBuffer(sqlMgr.getSql("selectAllSuppliersSQL").trim());
//            }
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            queryResult = forQuery.executeQuery();


        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {

        } catch (Exception e) {
            logger.error("Exception  " + e.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {

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

    public ArrayList getCashedTableAsArrayList() {
        cashedData = new ArrayList();
        WebBusinessObject wbo = null;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add((String) wbo.getAttribute("note"));
        }

        return cashedData;
    }

    @Override
    protected void initSupportedQueries() {
     return; //   throw new UnsupportedOperationException("Not supported yet.");
    }
}
