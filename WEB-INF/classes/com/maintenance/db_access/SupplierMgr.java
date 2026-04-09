package com.maintenance.db_access;

import com.maintenance.common.Tools;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import java.sql.SQLException;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.sql.*;
import org.apache.log4j.xml.DOMConfigurator;

public class SupplierMgr extends RDBGateWay {

    SqlMgr sqlMgr = SqlMgr.getInstance();
    private static SupplierMgr supplierMgr = new SupplierMgr();

    public static SupplierMgr getInstance() {
        logger.info("Getting DepartmentMgr Instance ....");
        return supplierMgr;
    }

    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("supplier.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public boolean saveSupplier(HttpServletRequest request, HttpSession s) throws NoUserInSessionException {
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        String designation = null;
        String address = null;
        String city = null;
        String phone = null;
        String fax = null;
        String email = null;
        String service = null;
        String note = null;

        if (request.getParameter("designation").toString().equals("")) {
            designation = "SUPPLIER";

        } else {
            designation = request.getParameter("designation").toString();
        }
        if (request.getParameter("address").toString().equals("")) {
            address = "CAIRO";
        } else {
            address = request.getParameter("address").toString();

        }
        if (request.getParameter("city").toString().equals("")) {
            city = "CAIRO";
        } else {
            city = request.getParameter("city").toString();

        }
        if (request.getParameter("phone").toString().equals("")) {
            phone = "123456789";
        } else {
            phone = request.getParameter("phone").toString();

        }
        if (request.getParameter("fax").toString().equals("")) {
            fax = "123456789";

        } else {
            fax = request.getParameter("fax").toString();
        }
        if (request.getParameter("email").toString().equals("")) {
            email = "AHMED@YAHOO.COM";
        } else {
            email = request.getParameter("email").toString();

        }
        if (request.getParameter("service").toString().equals("")) {
            service = "PUBLIC";
        } else {
            service = request.getParameter("service").toString();

        }

        if (request.getParameter("note").toString().equals("")) {
            note = "none";
        } else {
            note = request.getParameter("note").toString();

        }

        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue(request.getParameter("supplierNO")));
        params.addElement(new StringValue(request.getParameter("supplierName")));
        params.addElement(new StringValue(designation));
        params.addElement(new StringValue(address));
        params.addElement(new StringValue(city));
        params.addElement(new StringValue(phone));
        params.addElement(new StringValue(fax));
        params.addElement(new StringValue(email));
        params.addElement(new StringValue(service));
        if (request.getParameter("isActive") != null) {
            params.addElement(new StringValue("1"));
        } else {
            params.addElement(new StringValue("0"));
        }
        params.addElement(new StringValue(note));
        params.addElement(new StringValue((String) waUser.getAttribute("userId")));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertSupplier").trim());
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

    public boolean updateSupplier(HttpServletRequest request) throws NoUserInSessionException {


        Vector params = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;
        params.addElement(new StringValue(request.getParameter("supplierNO")));
        params.addElement(new StringValue(request.getParameter("supplierName")));
        params.addElement(new StringValue(request.getParameter("designation")));
        params.addElement(new StringValue(request.getParameter("address")));
        params.addElement(new StringValue(request.getParameter("city")));
        params.addElement(new StringValue(request.getParameter("phone")));
        params.addElement(new StringValue(request.getParameter("fax")));
        params.addElement(new StringValue(request.getParameter("email")));
        params.addElement(new StringValue(request.getParameter("service")));
        if (request.getParameter("isActive") != null) {
            params.addElement(new StringValue("1"));
        } else {
            params.addElement(new StringValue("0"));
        }
        params.addElement(new StringValue(request.getParameter("note")));
        params.addElement(new StringValue(request.getParameter("supplierID")));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(sqlMgr.getSql("updateSupplier").trim());
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();

            cashData();
        } catch (SQLException se) {
            logger.error("Exception updating project: " + se.getMessage());
            return false;
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                return false;
            }
        }

        return (queryResult > 0);
    }

    public ArrayList getCashedTableAsArrayList() {
        cashedData = new ArrayList();
        WebBusinessObject wbo = null;
        if (cashedTable != null) {
            for (int i = 0; i < cashedTable.size(); i++) {
                wbo = (WebBusinessObject) cashedTable.elementAt(i);
                cashedData.add((String) wbo.getAttribute("name"));
            }
        }

        return cashedData;
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

    public String getAllSuppNo() {
        Connection connection = null;
        ResultSet result = null;
        StringBuffer returnSB = null;

        try {
            connection = dataSource.getConnection();
            Statement select = connection.createStatement();
            result = select.executeQuery(sqlMgr.getSql("getAllSuppNo").trim());
            returnSB = new StringBuffer();
            while (result.next()) {
                returnSB.append(result.getString("SUPPLIER_NO") + ",");
            }
            returnSB.deleteCharAt(returnSB.length() - 1);
        } catch (SQLException e) {
            logger.error("error ================ > " + e.toString());
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return null;
            }
        }
        return returnSB.toString();
    }

    public Vector getAllSuppliersByEquipment(HttpServletRequest request) {

        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector params = new Vector();
        params.addElement(new StringValue(request.getParameter("equipmentID")));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();


        try {
            forQuery.setparams(params);
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("selectAllSuppliersSQL").trim());
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

    public ArrayList getAllSuppliers() {
        WebBusinessObject wbo = new WebBusinessObject();
        Tools tools = new Tools();
        Connection connection = null;
        Vector params = new Vector();
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        forQuery.setparams(params);
        try {
            connection = dataSource.getConnection();
        } catch (SQLException ex) {
            Logger.getLogger(SupplierMgr.class.getName()).log(Level.SEVERE, null, ex);
        }
        forQuery.setConnection(connection);
        forQuery.setSQLQuery(sqlMgr.getSql("selectAllSuppliers").trim());
        try {
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            Logger.getLogger(SupplierMgr.class.getName()).log(Level.SEVERE, null, ex);
        } catch (UnsupportedTypeException ex) {
            Logger.getLogger(SupplierMgr.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
            }
        }
        ArrayList resultBusObjs = new ArrayList();
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

    public boolean canDelete(String supplierId) {
        boolean canDelete = false;
        ExternalJobMgr externalJobMgr = ExternalJobMgr.getInstance();
        Vector externalJobOrderVec = new Vector();

        try {
            externalJobOrderVec = externalJobMgr.getOnArbitraryKey(supplierId, "key1");

            if(externalJobOrderVec.isEmpty()) {
                canDelete = true;
            }
        } catch(Exception ex) { logger.error(ex.getMessage()); }

        return canDelete;
    }

    @Override
    protected void initSupportedQueries() {
      return; //  throw new UnsupportedOperationException("Not supported yet.");
    }
}
