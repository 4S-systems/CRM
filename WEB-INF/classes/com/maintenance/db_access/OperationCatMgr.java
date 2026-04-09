package com.maintenance.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import java.sql.SQLException;
import com.silkworm.util.*;
import java.util.*;
import java.text.*;
import javax.servlet.http.HttpSession;
import java.sql.*;
import com.tracker.common.*;
//import com.tracker.app_constants.ProjectConstants;

import com.tracker.business_objects.*;
import org.apache.log4j.xml.DOMConfigurator;

public class OperationCatMgr extends RDBGateWay {

    private static OperationCatMgr operationCatMgr = new OperationCatMgr();
    private static final String insertOperationSQL = "INSERT INTO operations_cat VALUES (?,?,?,?,?)";
    private static final String updateOperationSQL = "UPDATE employee SET EMP_NO = ?, EMP_NAME = ?, ADDRESS = ?, DESIGNATION = ?, WORK_PHONE = ?, EXTENSION = ?, HOME_PHONE = ?, FAX = ?, EMAIL = ?, DEPARTMENT = ?, HOURE_SALARY = ?, OVER_TIME1 = ?, OVER_TIME2 = ?, OVER_TIME3 = ?, IS_ACTIVE = ?, NOTE = ? WHERE EMP_ID = ?";
    private static final String countItemsSQL = "SELECT COUNT(ITEM_CODE) AS total FROM maintenance_item WHERE CATEGORY_ID = ?";

    public OperationCatMgr() {
    }

    public static OperationCatMgr getInstance() {
        logger.info("Getting operationCatMgr Instance ....");
        return operationCatMgr;
    }

    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("operations_cat.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public boolean saveObject(WebBusinessObject operation, HttpSession s) throws NoUserInSessionException {
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

        //WebBusinessObject project = (WebBusinessObject) wbo;
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        //params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue((String) operation.getAttribute("catCode")));
        params.addElement(new StringValue((String) operation.getAttribute("catName")));
        params.addElement(new StringValue((String) operation.getAttribute("relatedTo")));
        params.addElement(new StringValue((String) operation.getAttribute("Note")));
//        params.addElement(new StringValue((String)waUser.getAttribute("userId")));

//        params.addElement(new StringValue((String)item.getAttribute("getCategoryId")));
//        params.addElement(new StringValue((String)item.getAttribute("categoryName")));
//
//        params.addElement(new StringValue((String)item.getAttribute("catDesc")));
        //params.addElement(new StringValue((String)waUser.getAttribute("userId")));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(insertOperationSQL);
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

    public boolean updateEmployee(WebBusinessObject employee) {

        Vector params = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue((String) employee.getAttribute("empNO")));
        params.addElement(new StringValue((String) employee.getAttribute("empName")));
        params.addElement(new StringValue((String) employee.getAttribute("Address")));
        params.addElement(new StringValue((String) employee.getAttribute("Designation")));
        params.addElement(new StringValue((String) employee.getAttribute("workPhone")));
        params.addElement(new StringValue((String) employee.getAttribute("Extension")));
        params.addElement(new StringValue((String) employee.getAttribute("homePhone")));
        params.addElement(new StringValue((String) employee.getAttribute("fax")));
        params.addElement(new StringValue((String) employee.getAttribute("Email")));
        params.addElement(new StringValue((String) employee.getAttribute("departmentName")));
        params.addElement(new StringValue((String) employee.getAttribute("houreSalary")));
        params.addElement(new StringValue((String) employee.getAttribute("overTime1")));
        params.addElement(new StringValue((String) employee.getAttribute("overTime2")));
        params.addElement(new StringValue((String) employee.getAttribute("overTime3")));
        params.addElement(new StringValue((String) employee.getAttribute("isActive")));
        params.addElement(new StringValue((String) employee.getAttribute("Note")));

        params.addElement(new StringValue((String) employee.getAttribute("employeeId")));


        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(updateOperationSQL);
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();

            cashData();
        } catch (SQLException se) {

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

    public Vector getAllItems() {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        StringBuffer query = new StringBuffer("SELECT * FROM operations_cat");
//        query.append(sSearch);
//        query.append("%'");

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

    public String getTotalItems(String categoryId) {

        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(categoryId));

        Connection connection = null;
        String total = null;

        StringBuffer query = new StringBuffer("SELECT COUNT(ITEM_CODE) AS total FROM maintenance_item WHERE CATEGORY_ID = ?");

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

            Row r = null;
            Enumeration e = queryResult.elements();

            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                total = r.getString(1);
            }

        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } catch (NoSuchColumnException nosuch) {
            logger.error("***** " + nosuch.getMessage());
            return null;
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return null;
            }
        }

        return total;

    }

    public Vector getAllItems(String categoryId) {
        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(categoryId));
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        StringBuffer query = new StringBuffer("SELECT * FROM maintenance_item WHERE CATEGORY_ID = ?");
//        query.append(sSearch);
//        query.append("%'");

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(SQLparams);
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

    public String getDepartmentId(String department) {

        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(department));

        Connection connection = null;
        String departmentId = null;

        StringBuffer query = new StringBuffer("SELECT DEPARTMENT_ID FROM department WHERE DEPARTMENT_NAME = ? ");

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

            Row r = null;
            Enumeration e = queryResult.elements();

            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                departmentId = r.getString(1);
            }

        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } catch (NoSuchColumnException nosuch) {
            logger.error("***** " + nosuch.getMessage());
            return null;
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return null;
            }
        }

        return departmentId;

    }

    public boolean getActiveItem(String itemID) throws Exception {
        Vector SQLparams = new Vector();
        Connection connection = null;
        Vector queryResult = null;
        SQLparams.addElement(new StringValue(itemID));
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery("SELECT * FROM quantified_mntence WHERE ITEM_ID = ?");
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();


        } catch (SQLException se) {
            logger.error("database error from getListOnSecondKey: ImageMgr " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return false;
            }
        }

        return queryResult.size() > 0;
    }

    @Override
    protected void initSupportedQueries() {
     return; //   throw new UnsupportedOperationException("Not supported yet.");
    }
}
