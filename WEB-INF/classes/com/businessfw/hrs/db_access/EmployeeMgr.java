package com.businessfw.hrs.db_access;

import com.android.business_objects.LiteBusinessForm;
import com.android.business_objects.LiteWebBusinessObject;
import com.android.db_access.LiteRDBGateWay;
import com.android.exceptions.LiteNoSuchColumnException;
import com.android.exceptions.LiteUnsupportedConversionException;
import com.android.exceptions.LiteUnsupportedTypeException;
import com.android.persistence.LiteDateValue;
import com.android.persistence.LiteFloatValue;
import com.android.persistence.LiteNullValue;
import com.android.persistence.LiteRow;
import com.android.persistence.LiteSQLCommandBean;
import com.android.persistence.LiteStringValue;
import com.android.persistence.LiteTimestampValue;
import com.clients.db_access.AppointmentMgr;
import com.maintenance.common.Tools;
import com.maintenance.db_access.TaskExecutionMgr;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import java.util.*;
import javax.servlet.http.HttpSession;
import java.sql.*;
import java.text.ParseException;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.log4j.xml.DOMConfigurator;
import java.text.SimpleDateFormat;
import java.time.LocalDate;

public class EmployeeMgr extends LiteRDBGateWay {

    SqlMgr sqlMgr = SqlMgr.getInstance();
    private static EmployeeMgr employeeMgr = new EmployeeMgr();
    private TaskExecutionMgr taskExecutionMgr = TaskExecutionMgr.getInstance();

    public EmployeeMgr() {
    }

    public static EmployeeMgr getInstance() {
        logger.info("Getting employeeMgr Instance ....");
        return employeeMgr;
    }

    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new LiteBusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("employee.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(LiteWebBusinessObject wbo) throws SQLException {
        return false;
    }

    public boolean saveObject(LiteWebBusinessObject employee, HttpSession s) throws NoUserInSessionException {

        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

        Vector params = new Vector();
        Vector empBasicParams = new Vector();
        LiteSQLCommandBean forInsert = new LiteSQLCommandBean();
        int queryResult = -1000;

        //params.addElement(new LiteStringValue(UniqueIDGen.getNextID()));
        params.addElement(new LiteStringValue((String) employee.getAttribute("empID")));
        params.addElement(new LiteStringValue((String) employee.getAttribute("empNO")));
        params.addElement(new LiteStringValue((String) employee.getAttribute("empName")));
        params.addElement(new LiteStringValue((String) employee.getAttribute("Address")));
        params.addElement(new LiteStringValue((String) employee.getAttribute("Designation")));
        params.addElement(new LiteStringValue((String) employee.getAttribute("workPhone")));
        params.addElement(new LiteStringValue((String) employee.getAttribute("Extension")));
        params.addElement(new LiteStringValue((String) employee.getAttribute("homePhone")));
        params.addElement(new LiteStringValue((String) employee.getAttribute("fax")));
        params.addElement(new LiteStringValue((String) employee.getAttribute("Email")));
        params.addElement(new LiteStringValue((String) employee.getAttribute("departmentName")));
        params.addElement(new LiteStringValue((String) employee.getAttribute("houreSalary")));
        params.addElement(new LiteStringValue((String) employee.getAttribute("overTime1")));
        params.addElement(new LiteStringValue((String) employee.getAttribute("overTime2")));
        params.addElement(new LiteStringValue((String) employee.getAttribute("overTime3")));
        params.addElement(new LiteStringValue((String) employee.getAttribute("isActive")));
        params.addElement(new LiteStringValue((String) employee.getAttribute("Note")));
        params.addElement(new LiteStringValue((String) waUser.getAttribute("userId")));
        params.addElement(new LiteStringValue((String) waUser.getAttribute("education")));
        params.addElement(new LiteStringValue((String) waUser.getAttribute("gender")));
        params.addElement(new LiteStringValue((String) waUser.getAttribute("matiralStatus")));

//        params.addElement(new LiteStringValue((String)item.getAttribute("getCategoryId")));
//        params.addElement(new LiteStringValue((String)item.getAttribute("categoryName")));
//
//        params.addElement(new LiteStringValue((String)item.getAttribute("catDesc")));
        //params.addElement(new LiteStringValue((String)waUser.getAttribute("userId")));
        empBasicParams.addElement(new LiteStringValue((String) employee.getAttribute("empID")));
        empBasicParams.addElement(new LiteStringValue((String) employee.getAttribute("empName")));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertEmployeeSQL").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();

            Vector empDates = (Vector) employee.getAttribute("empDates");
            for (int i = 0; i < empDates.size(); i++) {
                LiteWebBusinessObject empDate = (LiteWebBusinessObject) empDates.get(i);
                saveEmpDates((String) employee.getAttribute("empID"), (String) empDate.getAttribute("empDate"), (String) empDate.getAttribute("DateType"));
            }
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

    public boolean saveEmp(LiteWebBusinessObject employee, HttpSession s) throws NoUserInSessionException {

        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

        Vector params = new Vector();
        Vector empBasicParams = new Vector();
        LiteSQLCommandBean forInsert = new LiteSQLCommandBean();
        int queryResult = -1000;

        params.addElement(new LiteStringValue((String) employee.getAttribute("empID")));
        params.addElement(new LiteStringValue((String) employee.getAttribute("empNO")));
        params.addElement(new LiteStringValue((String) employee.getAttribute("empName")));
        params.addElement(new LiteStringValue((String) employee.getAttribute("Address")));
        params.addElement(new LiteStringValue((String) employee.getAttribute("mobile")));
        params.addElement(new LiteStringValue((String) employee.getAttribute("Email")));
        params.addElement(new LiteStringValue((String) employee.getAttribute("department")));
        params.addElement(!"".equals(employee.getAttribute("empSalary")) ? new LiteFloatValue(Float.parseFloat(employee.getAttribute("empSalary").toString())) : new LiteNullValue());
        params.addElement(new LiteStringValue((String) employee.getAttribute("Note")));
        params.addElement(new LiteStringValue((String) waUser.getAttribute("userId")));
        params.addElement(new LiteStringValue((String) employee.getAttribute("gender")));
        params.addElement(new LiteStringValue((String) employee.getAttribute("matiralStatus")));
        params.addElement(new LiteStringValue((String) employee.getAttribute("education")));
        params.addElement(new LiteStringValue((String) employee.getAttribute("workingType")));
        params.addElement(new LiteStringValue((String) employee.getAttribute("empSocialNO")));
        params.addElement(new LiteStringValue((String) employee.getAttribute("workType")));

        try {
            SimpleDateFormat format = new SimpleDateFormat("yyyy-mm-dd");
            java.sql.Date beginWorkFrom = new java.sql.Date(format.parse(employee.getAttribute("beginWorkFrom").toString()).getTime());
            params.addElement(new LiteDateValue(beginWorkFrom));
            params.addElement(new LiteStringValue((String) employee.getAttribute("melatryStatus")));
            params.addElement(new LiteStringValue((String) employee.getAttribute("empInsuranceNO")));
            params.addElement(new LiteDateValue(new java.sql.Date(format.parse(employee.getAttribute("birthDate").toString()).getTime())));
        } catch (ParseException e1) {
            e1.printStackTrace();
        }

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            String forInsertW = this.getQuery("insertEmployee");
            forInsert.setSQLQuery(forInsertW);
            // now property file works - walid   forInsert.setSQLQuery(sqlMgr.getSql("insertEmpSQL").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
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

    public ArrayList<WebBusinessObject> AllEmployeeReqStatus() {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector SQLparams = new Vector();
        Vector queryResult = null;

        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("AllEmployeeReqStatus"));

            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException ex) {
            Logger.getLogger(EmployeeMgr.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        ArrayList resultBusObjs = new ArrayList();

        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            try {
                if (r.getString("ID") != null) {
                    wbo.setAttribute("ID", r.getString("ID"));
                } else {
                    wbo.setAttribute("ID", " ");
                }

                if (r.getString("CASE_EN") != null) {
                    wbo.setAttribute("CASE_EN", r.getString("CASE_EN"));
                } else {
                    wbo.setAttribute("CASE_EN", " ");
                }
                
                if (r.getString("CASE_AR") != null) {
                    wbo.setAttribute("CASE_AR", r.getString("CASE_AR"));
                } else {
                    wbo.setAttribute("CASE_AR", " ");
                }

            } catch (NoSuchColumnException ex) {
                Logger.getLogger(EmployeeMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;

    }

    public boolean updateEmp(LiteWebBusinessObject employee, HttpSession s) throws NoUserInSessionException {

        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

        Vector params = new Vector();
        Vector empBasicParams = new Vector();
        LiteSQLCommandBean forInsert = new LiteSQLCommandBean();
        int queryResult = -1000;

        params.addElement(new LiteStringValue((String) employee.getAttribute("empName")));
        params.addElement(new LiteStringValue((String) employee.getAttribute("Address")));
        params.addElement(new LiteStringValue((String) employee.getAttribute("mobile")));
        params.addElement(new LiteStringValue((String) employee.getAttribute("Email")));
        params.addElement(new LiteStringValue((String) employee.getAttribute("Note")));
        params.addElement(new LiteStringValue((String) employee.getAttribute("gender")));
        params.addElement(new LiteStringValue((String) employee.getAttribute("matiralStatus")));
        params.addElement(new LiteStringValue((String) employee.getAttribute("workingType")));
        params.addElement(new LiteStringValue((String) employee.getAttribute("empID")));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("updateEmpSQL").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
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

    public boolean saveEmpDates(String employeeID, String empDate, String dateType) throws NoUserInSessionException {
        Vector params = new Vector();
        Vector empBasicParams = new Vector();
        LiteSQLCommandBean forInsert = new LiteSQLCommandBean();
        int queryResult = -1000;

        params.addElement(new LiteStringValue(UniqueIDGen.getNextID()));
        params.addElement(new LiteStringValue(employeeID));
        java.util.Date parsed = null;
        SimpleDateFormat format = new SimpleDateFormat("yyyy/mm/dd");
        try {
            parsed = format.parse(empDate);
        } catch (ParseException e1) {
            e1.printStackTrace();
        }
        java.sql.Date newDate = new java.sql.Date(parsed.getTime());
        params.addElement(new LiteDateValue(newDate));
        params.addElement(new LiteStringValue(dateType));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertEmployeeDatesSQL").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
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

    @Override
    public ArrayList getCashedTableAsBusObjects() {
        cashedData = new ArrayList();
        LiteWebBusinessObject wbo = null;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (LiteWebBusinessObject) cashedTable.elementAt(i);
            cashedData.add(wbo);
        }

        return cashedData;
    }

    public ArrayList getCashedTableAsArrayList() {

        cashedData = new ArrayList();
        LiteWebBusinessObject wbo = null;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (LiteWebBusinessObject) cashedTable.elementAt(i);
            cashedData.add((String) wbo.getAttribute("empName"));
        }

        return cashedData;
    }

    public boolean updateEmployee(LiteWebBusinessObject employee) {

        Vector params = new Vector();
        LiteSQLCommandBean forUpdate = new LiteSQLCommandBean();
        int queryResult = -1000;

        params.addElement(new LiteStringValue((String) employee.getAttribute("empNO")));
        params.addElement(new LiteStringValue((String) employee.getAttribute("empName")));
        params.addElement(new LiteStringValue((String) employee.getAttribute("Address")));
        params.addElement(new LiteStringValue((String) employee.getAttribute("Designation")));
        params.addElement(new LiteStringValue((String) employee.getAttribute("workPhone")));
        params.addElement(new LiteStringValue((String) employee.getAttribute("Extension")));
        params.addElement(new LiteStringValue((String) employee.getAttribute("homePhone")));
        params.addElement(new LiteStringValue((String) employee.getAttribute("fax")));
        params.addElement(new LiteStringValue((String) employee.getAttribute("Email")));
        params.addElement(new LiteStringValue((String) employee.getAttribute("departmentName")));
        params.addElement(new LiteStringValue((String) employee.getAttribute("houreSalary")));
        params.addElement(new LiteStringValue((String) employee.getAttribute("overTime1")));
        params.addElement(new LiteStringValue((String) employee.getAttribute("overTime2")));
        params.addElement(new LiteStringValue((String) employee.getAttribute("overTime3")));
        params.addElement(new LiteStringValue((String) employee.getAttribute("isActive")));
        params.addElement(new LiteStringValue((String) employee.getAttribute("Note")));

        params.addElement(new LiteStringValue((String) employee.getAttribute("employeeId")));

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

    public Vector getAllItems() throws LiteUnsupportedTypeException {

        LiteWebBusinessObject wbo = new LiteWebBusinessObject();
        Connection connection = null;
        StringBuffer query = new StringBuffer(sqlMgr.getSql("getAllEmployee").trim());

        Vector queryResult = null;
        LiteSQLCommandBean forQuery = new LiteSQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        Vector resultBusObjs = new Vector();

        LiteRow r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (LiteRow) e.nextElement();
            wbo = new LiteWebBusinessObject();
            wbo = fabricateBusObj(r);
            try {
                if (r.getString("STATUS_NAME") != null) {
                    wbo.setAttribute("status_name", r.getString("STATUS_NAME"));
                } else {
                    wbo.setAttribute("status_name", "0");
                }
                if (r.getString("CASE_EN") != null) {
                    wbo.setAttribute("statusEnName", r.getString("CASE_EN"));
                } else {
                    wbo.setAttribute("statusEnName", "inActive");
                }
                try {
                    if (r.getTimestamp("BEGIN_DATE") != null) {
                        wbo.setAttribute("beginDate", r.getTimestamp("BEGIN_DATE"));
                    }
                } catch (LiteUnsupportedConversionException ex) {
                    Logger.getLogger(EmployeeMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
            } catch (LiteNoSuchColumnException ex) {
                Logger.getLogger(EmployeeMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }

    public Vector filterItems(String empNo) throws LiteUnsupportedTypeException {

        LiteWebBusinessObject wbo = new LiteWebBusinessObject();
        Connection connection = null;
        String query = "SELECT * FROM employee where EMP_NO like '%" + empNo + "%'";

        Vector queryResult = null;
        LiteSQLCommandBean forQuery = new LiteSQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        Vector resultBusObjs = new Vector();

        LiteRow r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (LiteRow) e.nextElement();
            wbo = new LiteWebBusinessObject();
            wbo = fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }

    public String getDepartmentId(String department) throws LiteUnsupportedTypeException {

        Vector SQLparams = new Vector();
        SQLparams.addElement(new LiteStringValue(department));

        Connection connection = null;
        String departmentId = null;

        StringBuffer query = new StringBuffer(sqlMgr.getSql("getDepID").trim());

        Vector queryResult = null;
        LiteSQLCommandBean forQuery = new LiteSQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

            LiteRow r = null;
            Enumeration e = queryResult.elements();

            while (e.hasMoreElements()) {
                r = (LiteRow) e.nextElement();
                departmentId = r.getString(1);
            }

        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        } catch (LiteNoSuchColumnException ex) {
            Logger.getLogger(EmployeeMgr.class.getName()).log(Level.SEVERE, null, ex);
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

    public String getEmployeeId(String employeeName) throws LiteUnsupportedTypeException {

        Vector SQLparams = new Vector();
        SQLparams.addElement(new LiteStringValue(employeeName));

        Connection connection = null;
        String Id = null;

        StringBuffer query = new StringBuffer(sqlMgr.getSql("getEmployeeId").trim());

        Vector queryResult = null;
        LiteSQLCommandBean forQuery = new LiteSQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

            LiteRow r = null;
            Enumeration e = queryResult.elements();

            while (e.hasMoreElements()) {
                r = (LiteRow) e.nextElement();
                Id = r.getString(1);
            }

        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        } catch (LiteNoSuchColumnException ex) {
            Logger.getLogger(EmployeeMgr.class.getName()).log(Level.SEVERE, null, ex);
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

    public Vector getEmployeeBySubName(String name) {
        LiteWebBusinessObject wbo = new LiteWebBusinessObject();
        Connection connection = null;
        Vector SQLparams = new Vector();
        Vector queryResult = null;

        LiteSQLCommandBean forQuery = new LiteSQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getEmployeeBySubName").trim().replaceAll("ppp", name));

            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());
        } catch (LiteUnsupportedTypeException ex) {
            Logger.getLogger(EmployeeMgr.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        Vector resultBusObjs = new Vector();

        LiteRow r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (LiteRow) e.nextElement();
            wbo = new LiteWebBusinessObject();
            wbo = fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }

    public double getCostHour(String employeeId) {
        double costHour = 0.00;
        LiteWebBusinessObject wboEmployee = employeeMgr.getOnSingleKey(employeeId);
        String sCostHour;
        if (wboEmployee != null) {
            sCostHour = (String) wboEmployee.getAttribute("houreSalary");
            costHour = Double.valueOf(sCostHour).doubleValue();
            return Tools.round(costHour, 2);
        }

        return costHour;
    }

    public boolean canDelete(String employeeId) {
        Vector taskExecutionVec = new Vector();
        boolean canDelete = false;

        try {
            taskExecutionVec = taskExecutionMgr.getOnArbitraryKey(employeeId, "key2");

            if (taskExecutionVec.isEmpty()) {
                canDelete = true;
            }
        } catch (Exception ex) {
            logger.error(ex.getMessage());
        }

        return canDelete;
    }

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
        return; //   throw new UnsupportedOperationException("Not supported yet.");
    }

    public boolean disJoinMgr(String mgrCode) {

        Vector params = new Vector();
        LiteSQLCommandBean forUpdate = new LiteSQLCommandBean();
        int queryResult = -1000;
        boolean deleted = false;
//        params.addElement(mgrCode);

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(sqlMgr.getSql("disJoinMgrAndEmp").trim().replace("?", mgrCode));
            forUpdate.setparams(params);
            forUpdate.executeUpdate();

            cashData();
        } catch (SQLException se) {
            System.out.println(se.getMessage());
            return false;
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
                return false;
            }
        }

        return true;
    }

    public boolean disJoinEmp(String empCode) {

        Vector params = new Vector();
        LiteSQLCommandBean forUpdate = new LiteSQLCommandBean();
//        int queryResult = -1000;
//        boolean deleted = false ;
//        params.addElement(mgrCode);

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(sqlMgr.getSql("disJoinEmp").trim().replace("?", empCode));
            forUpdate.setparams(params);
            forUpdate.executeUpdate();

            cashData();
        } catch (SQLException se) {
            System.out.println(se.getMessage());
            return false;
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
                return false;
            }
        }

        return true;
    }

    public ArrayList<LiteWebBusinessObject> getEmployeeByManagerCode(String managerCode) {
        LiteWebBusinessObject wbo = new LiteWebBusinessObject();
        Connection connection = null;
        Vector SQLparams = new Vector();
        Vector queryResult = null;

        LiteSQLCommandBean forQuery = new LiteSQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getEmployeeByManagerCode").trim().replace("?", managerCode));

            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());
        } catch (LiteUnsupportedTypeException ex) {
            Logger.getLogger(EmployeeMgr.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        ArrayList resultBusObjs = new ArrayList();

        LiteRow r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (LiteRow) e.nextElement();
            wbo = new LiteWebBusinessObject();
            try {
                wbo.setAttribute("employeeName", r.getString(1));
            } catch (LiteNoSuchColumnException ex) {
                Logger.getLogger(EmployeeMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }

    public ArrayList<LiteWebBusinessObject> getMyEmployeeList(String UsrId) {
        LiteWebBusinessObject wbo = new LiteWebBusinessObject();
        Connection connection = null;
        Vector SQLparams = new Vector();
        Vector queryResult = null;
        SQLparams.add(new StringValue((UsrId)));
        SQLparams.add(new StringValue((UsrId)));
        LiteSQLCommandBean forQuery = new LiteSQLCommandBean();
        String qu = "";
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            qu = sqlMgr.getSql("getMyEmployeeList").trim().replace("?", UsrId);
            forQuery.setSQLQuery(qu);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());
        } catch (LiteUnsupportedTypeException ex) {
            Logger.getLogger(EmployeeMgr.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        ArrayList resultBusObjs = new ArrayList();

        LiteRow r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (LiteRow) e.nextElement();
            wbo = new LiteWebBusinessObject();
            try {
                wbo.setAttribute("employeeName", r.getString("EMP_NAME") == null ? " " : r.getString("EMP_NAME"));
                wbo.setAttribute("empID", r.getString("EMP_ID") == null ? " " : r.getString("EMP_ID"));
            } catch (LiteNoSuchColumnException ex) {
                Logger.getLogger(EmployeeMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }

    public boolean saveEmpReq(String reqTypWbo, String fDate, String tDate, String notes, HttpSession s, String empID) throws NoUserInSessionException {

        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        long from = 0, to = 0;

        java.util.Date fromDate = new java.util.Date();
        try {
            SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd HH:mm");
            fromDate = formatter.parse(fDate);
            from = fromDate.getTime();
        } catch (ParseException ex) {
            logger.error(ex);
        }

        java.util.Date toDate = new java.util.Date();
        try {
            SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd HH:mm");
            toDate = formatter.parse(tDate);
            to = toDate.getTime();
        } catch (ParseException ex) {
            logger.error(ex);
        }
        
        long dateDiff = to-from;
        int seconds = (int) dateDiff/1000;
        int minutes = (seconds / 60);

        String reqId = UniqueIDGen.getNextID();
        Vector params = new Vector();
        Vector ISparams = new Vector();
        Vector empBasicParams = new Vector();
        LiteSQLCommandBean forInsert = new LiteSQLCommandBean();
        int queryResult = -1000;
        //params.addElement(new LiteStringValue(UniqueIDGen.getNextID()));
        params.addElement(new LiteStringValue(reqId));
        if (empID != null && !empID.isEmpty()) {
            params.addElement(new LiteStringValue((String) empID));
        } else {
            params.addElement(new LiteStringValue((String) waUser.getAttribute("userId")));
        }
        params.addElement(new LiteStringValue((String) reqTypWbo));
        params.addElement(new LiteTimestampValue(new Timestamp(from)));
        params.addElement(new LiteTimestampValue(new Timestamp(to)));
        params.addElement(new LiteFloatValue(new Float(Math.abs((toDate.getTime() - fromDate.getTime()) / 86400000) + 1)));
        params.addElement(new LiteStringValue("vacation"));
        params.addElement(new LiteStringValue(notes));
        params.addElement(new LiteStringValue((String) waUser.getAttribute("userId")));
        params.addElement(new LiteStringValue(Integer.toString(minutes)));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("saveEmpReq").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();

            if (queryResult > 0) {
                queryResult = -1000;
                String issueId = UniqueIDGen.getNextID();
                ISparams.addElement(new LiteStringValue(issueId));
                ISparams.addElement(new LiteStringValue(reqId)); //bussiness_obj_id
                ISparams.addElement(new LiteStringValue((String) waUser.getAttribute("userId")));
                forInsert.setSQLQuery(sqlMgr.getSql("saveEmpReqIssueStatus").trim());
                forInsert.setparams(ISparams);
                queryResult = forInsert.executeUpdate();
            }
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

    public ArrayList<LiteWebBusinessObject> getAllMyEmployeesRequests(String fromDate, String toDate, HttpSession s, String typ, String empID,String reqStauts) {
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

        LiteWebBusinessObject wbo = new LiteWebBusinessObject();
        Connection connection = null;
        Vector SQLparams = new Vector();
        Vector queryResult = null;
        //SQLparams.addElement(new LiteStringValue((String) reqStauts));
        //   SQLparams.addElement(new LiteStringValue((String) waUser.getAttribute("userId")));
        SQLparams.addElement(new LiteStringValue(fromDate));
        SQLparams.addElement(new LiteStringValue(toDate));
        String Where = "";
        if (!typ.equals("all")) {
            Where = " And ER.REQ_ID='" + typ + "'";
        }
        
        if (!empID.equals("all")) {
            Where = Where + " And ER.EMP_ID='" + empID + "'";
        }
        
        if (!reqStauts.equals("all")) {
            Where =Where+ " And ISS.STATUS_NAME = '" + reqStauts + "'";
        }
      
         LiteSQLCommandBean forQuery = new LiteSQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getAllMyEmployeesRequestsByreqStatus").trim() + Where);
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());
        } catch (LiteUnsupportedTypeException ex) {
            Logger.getLogger(EmployeeMgr.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        ArrayList resultBusObjs = new ArrayList();

        LiteRow r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (LiteRow) e.nextElement();
            wbo = new LiteWebBusinessObject();
            try {
                if (r.getString("ID") != null) {
                    wbo.setAttribute("rowID", r.getString("ID"));
                }
                if (r.getString("EMP_ID") != null) {
                    wbo.setAttribute("empID", r.getString("EMP_ID"));
                }
                if (r.getString("REQ_ID") != null) {
                    wbo.setAttribute("reqID", r.getString("REQ_ID"));
                }
                if (r.getString("FROM_DATE") != null) {
                    wbo.setAttribute("fromDate", r.getString("FROM_DATE"));
                }
                if (r.getString("TO_DATE") != null) {
                    wbo.setAttribute("toDate", r.getString("TO_DATE"));
                }
                if (r.getString("REQ_AMOUNT") != null) {
                    wbo.setAttribute("reqAmount", r.getString("REQ_AMOUNT"));
                }
                if (r.getString("NOTE") != null) {
                    wbo.setAttribute("note", r.getString("NOTE"));
                }
                if (r.getString("CREATION_TIME") != null) {
                    wbo.setAttribute("creationTime", r.getString("CREATION_TIME"));
                }
                if (r.getString("CREATED_BY") != null) {
                    wbo.setAttribute("createdBy", r.getString("CREATED_BY"));
                }
                if (r.getString("OPTION1") != null) {
                    wbo.setAttribute("vacByMinute", r.getString("OPTION1"));
                }
                if (r.getString("FULL_NAME") != null) {
                    wbo.setAttribute("empName", r.getString("FULL_NAME"));
                }
                if (r.getString("PROJECT_NAME") != null) {
                    wbo.setAttribute("reqType", r.getString("PROJECT_NAME"));
                }
                if (r.getString("STATUS_ID") != null) {
                    wbo.setAttribute("issStatusId", r.getString("STATUS_ID"));
                }
                 if (r.getString("CASE_EN") != null) {
                    wbo.setAttribute("statusEn", r.getString("CASE_EN"));
                }
                if (r.getString("CASE_AR") != null) {
                    wbo.setAttribute("statusAr", r.getString("CASE_AR"));
                }
                
                if (r.getString("STCODE") != null) {
                    wbo.setAttribute("STCODE", r.getString("STCODE"));
                }
            } catch (LiteNoSuchColumnException ex) {
                Logger.getLogger(EmployeeMgr.class.getName()).log(Level.SEVERE, null, ex);
            } catch (Exception ex) {
                Logger.getLogger(EmployeeMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }

    public ArrayList<LiteWebBusinessObject> getAllMyRequests(String fromDate, String toDate, HttpSession s, String typ,String reqStauts, String empID) {
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

        LiteWebBusinessObject wbo = new LiteWebBusinessObject();
        Connection connection = null;
        Vector SQLparams = new Vector();
        Vector queryResult = null;
         String Where = "";
        if (!typ.equals("all")) {
            Where = " And ER.REQ_ID='" + typ + "'";
        }
        
       
        if (!reqStauts.equals("all")) {
            Where =Where+ " And ISS.STATUS_NAME = '" + reqStauts + "'";
        }
        if (empID != null && !empID.isEmpty()) {
            SQLparams.addElement(new LiteStringValue((String) empID));
        } else {
            SQLparams.addElement(new LiteStringValue((String) waUser.getAttribute("userId")));
        }

        SQLparams.addElement(new LiteStringValue(fromDate));
        SQLparams.addElement(new LiteStringValue(toDate));

        LiteSQLCommandBean forQuery = new LiteSQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getAllMyRequests").trim()+Where);
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());
        } catch (LiteUnsupportedTypeException ex) {
            Logger.getLogger(EmployeeMgr.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        ArrayList resultBusObjs = new ArrayList();

        LiteRow r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (LiteRow) e.nextElement();
            wbo = new LiteWebBusinessObject();
            try {
                if (r.getString("ID") != null) {
                    wbo.setAttribute("rowID", r.getString("ID"));
                }
                if (r.getString("EMP_ID") != null) {
                    wbo.setAttribute("empID", r.getString("EMP_ID"));
                }
                if (r.getString("REQ_ID") != null) {
                    wbo.setAttribute("reqID", r.getString("REQ_ID"));
                }
                if (r.getString("FROM_DATE") != null) {
                    wbo.setAttribute("fromDate", r.getString("FROM_DATE"));
                }
                if (r.getString("TO_DATE") != null) {
                    wbo.setAttribute("toDate", r.getString("TO_DATE"));
                }
                if (r.getString("NOTE") != null) {
                    wbo.setAttribute("note", r.getString("NOTE"));
                }
                if (r.getString("CREATION_TIME") != null) {
                    wbo.setAttribute("creationTime", r.getString("CREATION_TIME"));
                }
                if (r.getString("CREATED_BY") != null) {
                    wbo.setAttribute("createdBy", r.getString("CREATED_BY"));
                }
                
                if (r.getString("OPTION1") != null) {
                    wbo.setAttribute("vacByMinute", r.getString("OPTION1"));
                }
                
                if (r.getString("EMP_NAME") != null) {
                    wbo.setAttribute("empName", r.getString("EMP_NAME"));
                } else {
                    wbo.setAttribute("empName", r.getString("FULL_NAME"));
                }
                if (r.getString("PROJECT_NAME") != null) {
                    wbo.setAttribute("reqType", r.getString("PROJECT_NAME"));
                }
                if (r.getString("STATUS_ID") != null) {
                    wbo.setAttribute("issStatusId", r.getString("STATUS_ID"));
                }
                if (r.getString("CASE_EN") != null) {
                    wbo.setAttribute("statusEn", r.getString("CASE_EN"));
                }
                if (r.getString("CASE_AR") != null) {
                    wbo.setAttribute("statusAr", r.getString("CASE_AR"));
                }
            } catch (LiteNoSuchColumnException ex) {
                Logger.getLogger(EmployeeMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }

    public boolean acceptEmpRequest(HttpSession s, String rowId, String boId, String empId, String reqAmount, String comment) throws NoUserInSessionException {

        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

        String reqId = UniqueIDGen.getNextID();
        Vector params = new Vector();
        Vector ISparams = new Vector();
        Vector empBasicParams = new Vector();
        Vector empTransaction = new Vector();

        LiteSQLCommandBean forInsert = new LiteSQLCommandBean();
        int queryResult = -1000;
        //params.addElement(new LiteStringValue(UniqueIDGen.getNextID()));

        params.addElement(new LiteStringValue(rowId));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("upIssueStatus").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();

            String issueId = UniqueIDGen.getNextID();
            if (queryResult > 0) {
                queryResult = -1000;
                ISparams.addElement(new LiteStringValue(issueId));
                ISparams.addElement(new LiteStringValue(comment));
                ISparams.addElement(new LiteStringValue(boId)); //bussiness_obj_id
                ISparams.addElement(new LiteStringValue((String) waUser.getAttribute("userId")));
                forInsert.setSQLQuery(sqlMgr.getSql("saveEmpReqStatusIssueStatus").trim());
                forInsert.setparams(ISparams);
                queryResult = forInsert.executeUpdate();
            }

            if (queryResult > 0) {
                queryResult = -1000;
                String transactionId = UniqueIDGen.getNextID();
                empTransaction.addElement(new LiteStringValue(transactionId));
                empTransaction.addElement(new LiteStringValue(empId));
                empTransaction.addElement(new LiteStringValue(rowId));
                empTransaction.addElement(new LiteStringValue(issueId));
                empTransaction.addElement(new LiteStringValue("request"));
                empTransaction.addElement(new LiteFloatValue(new Float(reqAmount).floatValue()));
                empTransaction.addElement(new LiteFloatValue(new Float(0).floatValue()));
                empTransaction.addElement(new LiteStringValue((String) waUser.getAttribute("userId")));

                forInsert.setSQLQuery(sqlMgr.getSql("saveEmpTrans").trim());
                forInsert.setparams(empTransaction);
                queryResult = forInsert.executeUpdate();
            }
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

    public ArrayList<LiteWebBusinessObject> getAllEmployeesRequests(String fromDate, String toDate, HttpSession s, String req) {
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

        LiteWebBusinessObject wbo = new LiteWebBusinessObject();
        Connection connection = null;
        Vector SQLparams = new Vector();
        Vector queryResult = null;
        SQLparams.addElement(new LiteStringValue((String) req));
        SQLparams.addElement(new LiteStringValue(fromDate));
        SQLparams.addElement(new LiteStringValue(toDate));

        LiteSQLCommandBean forQuery = new LiteSQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getAllEmployeesRequests").trim());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());
        } catch (LiteUnsupportedTypeException ex) {
            Logger.getLogger(EmployeeMgr.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        ArrayList resultBusObjs = new ArrayList();

        LiteRow r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (LiteRow) e.nextElement();
            wbo = new LiteWebBusinessObject();
            try {
                if (r.getString("ID") != null) {
                    wbo.setAttribute("rowID", r.getString("ID"));
                }
                if (r.getString("EMP_ID") != null) {
                    wbo.setAttribute("empID", r.getString("EMP_ID"));
                }
                if (r.getString("REQ_ID") != null) {
                    wbo.setAttribute("reqID", r.getString("REQ_ID"));
                }
                if (r.getString("FROM_DATE") != null) {
                    wbo.setAttribute("fromDate", r.getString("FROM_DATE"));
                }
                if (r.getString("TO_DATE") != null) {
                    wbo.setAttribute("toDate", r.getString("TO_DATE"));
                }
                if (r.getString("NOTE") != null) {
                    wbo.setAttribute("note", r.getString("NOTE"));
                }
                if (r.getString("CREATION_TIME") != null) {
                    wbo.setAttribute("creationTime", r.getString("CREATION_TIME"));
                }
                if (r.getString("CREATED_BY") != null) {
                    wbo.setAttribute("createdBy", r.getString("CREATED_BY"));
                }
                if (r.getString("FULL_NAME") != null) {
                    wbo.setAttribute("empName", r.getString("FULL_NAME"));
                }
                if (r.getString("PROJECT_NAME") != null) {
                    wbo.setAttribute("reqType", r.getString("PROJECT_NAME"));
                }
                if (r.getString("STATUS_ID") != null) {
                    wbo.setAttribute("issStatusId", r.getString("STATUS_ID"));
                }
                if (r.getString("CASE_EN") != null) {
                    wbo.setAttribute("statusEn", r.getString("CASE_EN"));
                }
                if (r.getString("CASE_AR") != null) {
                    wbo.setAttribute("statusAr", r.getString("CASE_AR"));
                }
            } catch (LiteNoSuchColumnException ex) {
                Logger.getLogger(EmployeeMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }

    public boolean rejectEmpRequest(HttpSession s, String rowId, String boId, String comment) throws NoUserInSessionException {

        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

        String reqId = UniqueIDGen.getNextID();
        Vector params = new Vector();
        Vector ISparams = new Vector();
        Vector empBasicParams = new Vector();
        LiteSQLCommandBean forInsert = new LiteSQLCommandBean();
        int queryResult = -1000;
        //params.addElement(new LiteStringValue(UniqueIDGen.getNextID()));

        params.addElement(new LiteStringValue(rowId));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("upIssueStatus").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();

            if (queryResult > 0) {
                queryResult = -1000;
                String issueId = UniqueIDGen.getNextID();
                ISparams.addElement(new LiteStringValue(issueId));
                ISparams.addElement(new LiteStringValue(comment));
                ISparams.addElement(new LiteStringValue(boId)); //bussiness_obj_id
                ISparams.addElement(new LiteStringValue((String) waUser.getAttribute("userId")));
                forInsert.setSQLQuery(sqlMgr.getSql("saveEmpReqStatusIssueRejStatus").trim());
                forInsert.setparams(ISparams);
                queryResult = forInsert.executeUpdate();
            }
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

    public boolean cancelEmpRequest(HttpSession s, String rowId, String boId, String comment) throws NoUserInSessionException {

        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

        String reqId = UniqueIDGen.getNextID();
        Vector params = new Vector();
        Vector ISparams = new Vector();
        Vector empBasicParams = new Vector();
        LiteSQLCommandBean forInsert = new LiteSQLCommandBean();
        int queryResult = -1000;
        //params.addElement(new LiteStringValue(UniqueIDGen.getNextID()));

        params.addElement(new LiteStringValue(rowId));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("upIssueStatus").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();

            if (queryResult > 0) {
                queryResult = -1000;
                String issueId = UniqueIDGen.getNextID();
                ISparams.addElement(new LiteStringValue(issueId));
                ISparams.addElement(new LiteStringValue(comment));
                ISparams.addElement(new LiteStringValue(boId)); //bussiness_obj_id
                ISparams.addElement(new LiteStringValue((String) waUser.getAttribute("userId")));
                forInsert.setSQLQuery(sqlMgr.getSql("saveEmpReqStatusIssueCancelStatus").trim());
                forInsert.setparams(ISparams);
                queryResult = forInsert.executeUpdate();
            }
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

    public Vector getAllEmployees() throws LiteUnsupportedTypeException {

        LiteWebBusinessObject wbo = new LiteWebBusinessObject();
        Connection connection = null;
        StringBuffer query = new StringBuffer(sqlMgr.getSql("getEmployee").trim());

        Vector queryResult = null;
        LiteSQLCommandBean forQuery = new LiteSQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        Vector resultBusObjs = new Vector();

        LiteRow r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (LiteRow) e.nextElement();
            wbo = new LiteWebBusinessObject();
            wbo = fabricateBusObj(r);
            try {
                if (r.getBigDecimal("HOURE_SALARY") == null) {
                    wbo.setAttribute("houreSalary", "---");
                } else {
                    wbo.setAttribute("houreSalary", r.getString("HOURE_SALARY"));
                }
            } catch (LiteNoSuchColumnException ex) {
                Logger.getLogger(EmployeeMgr.class.getName()).log(Level.SEVERE, null, ex);
            } catch (LiteUnsupportedConversionException ex) {
                Logger.getLogger(EmployeeMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }

    public ArrayList<LiteWebBusinessObject> getManagerEmployees(String managerID) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        Vector<LiteRow> rows;
        LiteWebBusinessObject wbo;
        String query = (sqlMgr.getSql("getManagerEmployees").trim());
        ArrayList<LiteWebBusinessObject> results = new ArrayList<>();
        try {
            parameters.addElement(new StringValue(managerID));
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setparams(parameters);
            command.setSQLQuery(query);
            rows = command.executeQuery();
            for (LiteRow row : rows) {
                wbo = fabricateBusObj(row);
                try {
                    if (row.getString("ID") != null) {
                        wbo.setAttribute("employeeManagerID", row.getString("ID"));
                    }
                    if (row.getString("COMMENTS") != null) {
                        wbo.setAttribute("comments", row.getString("COMMENTS"));
                    }
                    if (row.getString("TYPE_AR") != null) {
                        wbo.setAttribute("typeAr", row.getString("TYPE_AR"));
                    }
                    if (row.getString("TYPE_EN") != null) {
                        wbo.setAttribute("typeEn", row.getString("TYPE_EN"));
                    }
                } catch (LiteNoSuchColumnException ex) {
                    Logger.getLogger(EmployeeMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                results.add(wbo);
            }
        } catch (SQLException | UnsupportedTypeException se) {
            logger.error(se.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error("Close Error " + ex.getMessage());
            }
        }
        return results;
    }

    public WebBusinessObject getEmployeeProfile(String empID) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        Vector<Row> rows;
        WebBusinessObject wbo = new WebBusinessObject();
        String query = (sqlMgr.getSql("getEmployeeProfile").trim());
        try {
            parameters.addElement(new StringValue(empID));
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setparams(parameters);
            command.setSQLQuery(query);
            rows = command.executeQuery();
            for (Row row : rows) {
                try {
                    if (row.getString("ID") != null) {
                        wbo.setAttribute("profileId", row.getString("ID"));
                    }
                    if (row.getString("VACATIONS") != null) {
                        wbo.setAttribute("yearlyH", row.getString("VACATIONS"));
                    }
                    if (row.getString("TEMP_VACATIONS") != null) {
                        wbo.setAttribute("otherH", row.getString("TEMP_VACATIONS"));
                    }
                    if (row.getString("TEMP_LEAVE") != null) {
                        wbo.setAttribute("permissions", row.getString("TEMP_LEAVE"));
                    }
                    if (row.getString("WORKING_HOURS") != null) {
                        wbo.setAttribute("workHours", row.getString("WORKING_HOURS"));
                    }
                    if (row.getString("WORK_TYPE") != null) {
                        wbo.setAttribute("workTyp", row.getString("WORK_TYPE"));
                    }
                    if (row.getString("SALARY") != null) {
                        wbo.setAttribute("salary", row.getString("SALARY"));
                    }
                    if (row.getString("DEPARTMENT_NAME") != null) {
                        wbo.setAttribute("depName", row.getString("DEPARTMENT_NAME"));
                    }
                    if (row.getString("DEPT_ID") != null) {
                        wbo.setAttribute("depID", row.getString("DEPT_ID"));
                    }
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(EmployeeMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        } catch (SQLException | UnsupportedTypeException se) {
            logger.error(se.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error("Close Error " + ex.getMessage());
            }
        }
        return wbo;
    }
    
    public ArrayList<WebBusinessObject> getEmpVacStatistic(String departmentID, String beginDate, String endDate) {
        ArrayList<WebBusinessObject> data = new ArrayList<>();
        Connection connection = null;

        Vector parameters = new Vector();
        
        //Visits Clients
        parameters.addElement(new StringValue(departmentID));
        //parameters.addElement(new StringValue("1519222276681"));
        parameters.addElement(new StringValue(beginDate));
        parameters.addElement(new StringValue(endDate));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getEmpVacStatistic").trim());
            forQuery.setparams(parameters);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }
        if (queryResult != null) {
            Enumeration e = queryResult.elements();
            WebBusinessObject wbo;
            Row r;
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = new WebBusinessObject();
                try {
                    if (r.getString("EMP_ID") != null) {
                        wbo.setAttribute("userID", r.getString("EMP_ID"));
                    }

                    if (r.getString("full_name") != null) {
                        wbo.setAttribute("userName", r.getString("full_name"));
                    }

                    if (r.getBigDecimal("EDEP") != null) {
                        wbo.setAttribute("EDEP", r.getBigDecimal("EDEP"));
                    } else {
                        wbo.setAttribute("EDEP", "0");
                    }

                    if (r.getBigDecimal("EMRGH") != null) {
                        wbo.setAttribute("EMRGH", r.getBigDecimal("EMRGH"));
                    } else {
                        wbo.setAttribute("EMRGH", "0");
                    }

                    if (r.getBigDecimal("LATT") != null) {
                        wbo.setAttribute("LATT", r.getBigDecimal("LATT"));
                    } else {
                        wbo.setAttribute("LATT", "0");
                    }

                    if (r.getBigDecimal("STANDARDH") != null) {
                        wbo.setAttribute("STANDARDH", r.getBigDecimal("STANDARDH"));
                    } else {
                        wbo.setAttribute("STANDARDH", "0");
                    }

                    if (r.getBigDecimal("HEALTHVAC") != null) {
                        wbo.setAttribute("HEALTHVAC", r.getBigDecimal("HEALTHVAC"));
                    } else {
                        wbo.setAttribute("HEALTHVAC", "0");
                    }
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(AppointmentMgr.class.getName()).log(Level.SEVERE, null, ex);
                } catch (UnsupportedConversionException ex) {
                    Logger.getLogger(AppointmentMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                data.add(wbo);
            }
        }
        return data;
    }
}
