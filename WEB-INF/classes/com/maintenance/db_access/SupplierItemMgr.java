package com.maintenance.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import java.sql.SQLException;
import java.util.*;
import java.sql.*;
import javax.servlet.http.HttpServletRequest;
import org.apache.log4j.xml.DOMConfigurator;

public class SupplierItemMgr extends RDBGateWay {

    private static SupplierItemMgr supplierItemMgr = new SupplierItemMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();

    public SupplierItemMgr() {
    }

    public static SupplierItemMgr getInstance() {
        logger.info("Getting SupplierItemMgr Instance ....");
        return supplierItemMgr;
    }

    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("supplier_item.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public boolean saveSupplierItem(HttpServletRequest request) throws NoUserInSessionException {

        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue(request.getParameter("supplierID")));
        params.addElement(new StringValue(request.getParameter("itemID")));
        params.addElement(new StringValue(request.getParameter("partNO")));
        params.addElement(new StringValue(request.getParameter("unitPrice")));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertSupplierItemSQL").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();

            cashData();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            request.setAttribute("Status", "Supplier already exist");
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

    public boolean updateSupplierItem(HttpServletRequest request) throws NoUserInSessionException {

        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue(request.getParameter("partNO")));
        params.addElement(new StringValue(request.getParameter("unitPrice")));
        params.addElement(new StringValue(request.getParameter("itemID")));
        params.addElement(new StringValue(request.getParameter("supplierID")));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("updateItemSupplier").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();

            cashData();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            request.setAttribute("Status", "Supplier already exist");
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

    public boolean hasSupplier(String itemID) throws Exception {

        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();

        params.addElement(new StringValue(itemID));

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("selectItemHasSupplier").trim());
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {

        } catch (UnsupportedTypeException uste) {
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                return false;
            }
        }

        return queryResult.size() > 0;
    }

    public Vector getItemSupplier(String itemID, String supplierID) {

        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();

        params.addElement(new StringValue(itemID));
        params.addElement(new StringValue(supplierID));

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("selectItemSupplier").trim());
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {

        } catch (UnsupportedTypeException uste) {
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
            }
        }
        WebBusinessObject wbo = new WebBusinessObject();

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

    public boolean deleteItemSupplier(String itemID, String supplierID) {

        Connection connection = null;
        int queryResult = 0;
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();

        params.addElement(new StringValue(itemID));
        params.addElement(new StringValue(supplierID));

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("deleteItemSupplier").trim());
            forQuery.setparams(params);
            queryResult = forQuery.executeUpdate();

        } catch (SQLException se) {
            logger.error(se.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
            }
        }
        return queryResult > 0;
    }

    public ArrayList getCashedTableAsArrayList() {
        cashedData = new ArrayList();
        WebBusinessObject wbo = null;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add((String) wbo.getAttribute("partNO"));
        }

        return cashedData;
    }

    @Override
    protected void initSupportedQueries() {
    return; //    throw new UnsupportedOperationException("Not supported yet.");
    }
}
