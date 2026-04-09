package com.maintenance.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import java.util.*;
import javax.servlet.http.HttpSession;
import java.sql.*;

import org.apache.log4j.xml.DOMConfigurator;

public class EmpBasicMgr extends RDBGateWay {

    SqlMgr sqlMgr = SqlMgr.getInstance();
    private static EmpBasicMgr empBasicMgr = new EmpBasicMgr();

    public EmpBasicMgr() {
    }

    public static EmpBasicMgr getInstance() {
        logger.info("Getting EmpBasicMgr Instance ....");
        return empBasicMgr;
    }

    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("empview.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public boolean saveObject(WebBusinessObject employee, HttpSession s) throws NoUserInSessionException {

        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

        //WebBusinessObject project = (WebBusinessObject) wbo;
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        //params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue((String) employee.getAttribute("empID")));
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
        params.addElement(new StringValue((String) waUser.getAttribute("userId")));

//        params.addElement(new StringValue((String)item.getAttribute("getCategoryId")));
//        params.addElement(new StringValue((String)item.getAttribute("categoryName")));
//
//        params.addElement(new StringValue((String)item.getAttribute("catDesc")));
        //params.addElement(new StringValue((String)waUser.getAttribute("userId")));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertEmployeeSQL").trim());
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
            forUpdate.setSQLQuery(sqlMgr.getSql("updateEmployeeSQL").trim());
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

    public Vector getAllEmpView() {

        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        StringBuffer query = new StringBuffer(sqlMgr.getSql("getAllEmpView").trim());
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

    public String getDepartmentId(String department) {

        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(department));

        Connection connection = null;
        String departmentId = null;

        StringBuffer query = new StringBuffer(sqlMgr.getSql("getDepID").trim());

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

    public String getAllEmployeeNames() {
        Connection connection = null;
        ResultSet result = null;
        StringBuffer returnSB = null;

        try {
            connection = dataSource.getConnection();
            Statement select = connection.createStatement();
            result = select.executeQuery(sqlMgr.getSql("selectAllEmployees").trim());
            returnSB = new StringBuffer();
            while (result.next()) {
                returnSB.append(result.getString("emp_name") + ",");
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

    public String getEmployeeId(String employeeName) {

        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(employeeName));

        Connection connection = null;
        String Id = null;

        StringBuffer query = new StringBuffer(sqlMgr.getSql("getEmployeeId").trim());

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
                Id = r.getString(1);
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

        return Id;

    }

      public String getEmployeeName(String employeeId) {

        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(employeeId));

        Connection connection = null;
        String Id = null;

        StringBuffer query = new StringBuffer(sqlMgr.getSql("getEmployeeName").trim());

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
                Id = r.getString(1);
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
        return Id;
    }





    public Vector getEmpViewNotInEmployee(String sub, String codeOrName, String langCode) {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;

        Vector SQLparams = new Vector();
        Vector queryResult = null;

        String query;

        if(codeOrName.equals("name")) {
            query = sqlMgr.getSql("getEmpViewByName").trim().replaceAll("ppp", sub);
        } else {
            query = sqlMgr.getSql("getEmpViewByCode").trim().replaceAll("ppp", sub);
        }
        
        query = query.replaceAll("AR_OR_EN", langCode);

        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
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

    public Vector getAllEmpViewNotInEmployee() {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;

        Vector SQLparams = new Vector();
        Vector queryResult = null;

        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getAllEmpViewNotInEmployee").trim());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
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
     return;//   throw new UnsupportedOperationException("Not supported yet.");
    }
}
