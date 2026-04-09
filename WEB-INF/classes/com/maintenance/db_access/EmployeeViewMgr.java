package com.maintenance.db_access;

import com.maintenance.common.DateParser;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import com.silkworm.util.DateAndTimeControl;
import java.sql.SQLException;
import java.util.*;
import javax.servlet.http.HttpSession;
import java.sql.*;
import org.apache.log4j.xml.DOMConfigurator;

public class EmployeeViewMgr extends RDBGateWay {

    private static EmployeeViewMgr employeeViewMgr = new EmployeeViewMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();

//    private static final String insertIssueSQL = "INSERT INTO ISSUE_TYPE VALUES (?,?,now(),?)";
    public static EmployeeViewMgr getInstance() {
        System.out.println("Getting EmployeeViewMgr Instance ....");
        return employeeViewMgr;
    }

    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("employee_view.xml")));

            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public boolean saveObject(WebBusinessObject wbo, HttpSession s) throws NoUserInSessionException {

        return false;
    }

    public ArrayList getCashedTableAsArrayList() {

        cashedData = new ArrayList();
        WebBusinessObject wbo = null;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add((String) wbo.getAttribute("id"));
        }

        return cashedData;
    }

    public ArrayList getClientComplaintList(String groupBy, String cMode) {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector params = new Vector();
        Vector queryResult = null;
        String groupSelector = null;
        ArrayList resultBusObjs = new ArrayList();
        Row r = null;
        Enumeration e = null;
        String entryDate = null;

        SQLCommandBean forQuery = new SQLCommandBean();
        forQuery.setparams(params);

        String query = getQuery("getClientComplaintList").trim();

        if (groupBy.equals("department")) {
            groupSelector = "department_name";

        } else if (groupBy.equals("sender")) {
            groupSelector = "sender_name";

        } else if (groupBy.equals("client")) {
            groupSelector = "customer_name";

        }

        // add group selector
        query = query.replaceAll("group_selector", groupSelector);

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            queryResult = forQuery.executeQuery();

        } catch (SQLException ex) {
            logger.error(ex.getMessage());
        } catch (UnsupportedTypeException ex) {
            logger.error(ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
            }
        }

        e = queryResult.elements();

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            entryDate = (String) wbo.getAttribute("entryDate");
            wbo.setAttribute("complaintAge", DateAndTimeControl.getDelayTimeHex(entryDate, cMode));

            resultBusObjs.add(wbo);
        }

        return resultBusObjs;
    }

    public ArrayList getClientComplaintList(String groupBy, String cMode, String beginDate, String endDate) {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector params = new Vector();
        Vector queryResult = null;
        String groupSelector = null;
        ArrayList resultBusObjs = new ArrayList();
        Row r = null;
        Enumeration e = null;
        String entryDate = null;

        SQLCommandBean forQuery = new SQLCommandBean();
        params.addElement(new DateValue(getSqlBeginDate(beginDate)));
        params.addElement(new DateValue(getSqlBeginDate(endDate)));
        forQuery.setparams(params);

        String query = getQuery("getClientComplaintList").trim();

        if (groupBy.equals("department")) {
            groupSelector = "department_name";

        } else if (groupBy.equals("sender")) {
            groupSelector = "sender_name";

        } else if (groupBy.equals("client")) {
            groupSelector = "customer_name";

        }

        // add group selector
        query = query.replaceAll("group_selector", groupSelector);

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            queryResult = forQuery.executeQuery();

        } catch (SQLException ex) {
            logger.error(ex.getMessage());
        } catch (UnsupportedTypeException ex) {
            logger.error(ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
            }
        }

        e = queryResult.elements();

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            entryDate = (String) wbo.getAttribute("entryDate");
            wbo.setAttribute("complaintAge", DateAndTimeControl.getDelayTimeHex(entryDate, cMode));

            resultBusObjs.add(wbo);
        }

        return resultBusObjs;
    }

    public Vector getComplaintCountPerDepartment() {

        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getComplaintCountPerDepartment").trim());
            queryResult = forQuery.executeQuery();

        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());

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

        try {
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = new WebBusinessObject();
                wbo.setAttribute("departmentName", r.getString("department_name"));
                wbo.setAttribute("complaintCount", r.getString("complaint_count"));
                resultBusObjs.add(wbo);
            }

        } catch (NoSuchColumnException ce) {
            logger.error(ce);
        }
        return resultBusObjs;
    }

    public Vector getComplaintsWithoutDate_(int numOfKeys, String[] keysValue, String[] keysIndex, String orderIndex, String resp) throws SQLException, Exception {

        Vector SQLparams = new Vector();
        WebBusinessObject wbo = null;
        String theQuery = "";
        StringBuffer dq = new StringBuffer("SELECT * FROM ");
        dq.append(supportedForm.getTableSupported().getAttribute("name")).append(" WHERE ");

        if (keysIndex.length == keysValue.length) {
            if (keysIndex.length == numOfKeys) {
                for (int i = 0; i < numOfKeys - 1; i++) {
                    dq.append(supportedForm.getTableSupported().getAttribute(keysIndex[i]));
                    dq.append(" = ? ");
//                    dq.append("AND ");
                }
//                dq.append(supportedForm.getTableSupported().getAttribute(keysIndex[keysIndex.length - 1]));
//                dq.append(" = ? ");
//                dq.append("and resp= " + "'" + resp + "'");
                dq.append(" ORDER BY ");
                dq.append(supportedForm.getTableSupported().getAttribute(orderIndex));
                dq.append(" DESC");
                theQuery = dq.toString();
            }
        }

        if (supportedForm == null) {

            initSupportedForm();
        }
        logger.info("the query " + theQuery);

        // finally do the query
        if (keysIndex.length == keysValue.length) {
            if (keysIndex.length == numOfKeys) {
                for (int i = 0; i < numOfKeys-1; i++) {
                    SQLparams.add(new StringValue(keysValue[i]));
                }
            }
        }


        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = dataSource.getConnection();
        try {

            forQuery.setConnection(connection);
            forQuery.setSQLQuery(theQuery);
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            throw se;
        } catch (UnsupportedTypeException uste) {
            logger.error("Persistence Error " + uste.getMessage());
        } finally {
            connection.close();
        }

        Vector reultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            reultBusObjs.add(fabricateBusObj(r));
        }


        return reultBusObjs;
    }

    public Vector getComplaintsByDepartment(String beginDate, String endDate, String cMode) {

        Vector queryResult = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        Vector params = new Vector();
        Connection connection = null;
        forUpdate.setSQLQuery(sqlMgr.getSql("getComplaintsByDepartment").trim());
        params.addElement(new DateValue(getSqlBeginDate(beginDate)));
        params.addElement(new DateValue(getSqlBeginDate(endDate)));
        try {

            connection = dataSource.getConnection();
            forUpdate.setConnection(connection);
            forUpdate.setparams(params);
            queryResult = forUpdate.executeQuery();
        } catch (Exception se) {
            logger.error(se.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }
        String entryDate = null;

        Vector resultBusObjs = new Vector();
        WebBusinessObject wbo;
        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            entryDate = (String) wbo.getAttribute("entryDate");
            wbo.setAttribute("complaintAge", DateAndTimeControl.getDelayTimeHex(entryDate, cMode));

            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }

    public Vector getComplaints(String userId, String beginDate, String endDate, String type, String status) throws NoSuchColumnException {

        Vector queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();

        params.addElement(new StringValue(userId));
        params.addElement(new StringValue(status));
        params.addElement(new StringValue(type));
        params.addElement(new DateValue(getSqlBeginDate(beginDate)));
        params.addElement(new DateValue(getSqlBeginDate(endDate)));
        Connection connection = null;


        try {

            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getComplaint").trim());
//            forQuery.setSQLQuery(getQuery("getComplaints").trim());
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (Exception se) {
            logger.error(se.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }
        String entryDate = null;

        Vector resultBusObjs = new Vector();
        WebBusinessObject wbo;
        Row r = null;
        Enumeration d = queryResult.elements();
        while (d.hasMoreElements()) {
            r = (Row) d.nextElement();
            wbo = new WebBusinessObject();
            wbo.setAttribute("businessId", r.getString("business_id"));
            wbo.setAttribute("businessComId", r.getString("business_comp_id"));
            wbo.setAttribute("customerName", r.getString("customer_name"));
            wbo.setAttribute("fullName", r.getString("full_name"));
            wbo.setAttribute("senderName", r.getString("sender_name"));
            wbo.setAttribute("entryDate", r.getString("entry_date"));
            wbo.setAttribute("compSubject", r.getString("comp_subject"));
            wbo.setAttribute("senderId", r.getString("sender_id"));
            wbo.setAttribute("entryDate", r.getString("entry_date"));
            if (r.getString("manager_comment") == null || r.getString("Manager_comment").isEmpty()) {
                wbo.setAttribute("managerComment", "no comment");

            } else {
                wbo.setAttribute("managerComment", r.getString("Manager_comment"));
            }
            wbo.setAttribute("comments", r.getString("comments"));
            wbo.setAttribute("status", r.getString("status_ar_name"));
//            wbo = fabricateBusObj(r);
//            entryDate = (String) wbo.getAttribute("entryDate");
//            wbo.setAttribute("complaintAge", DateAndTimeControl.getDelayTimeHex(entryDate, cMode));

            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }

    private java.sql.Date getSqlBeginDate(String date) {
        DateParser parser = new DateParser();
        java.sql.Date sqlDate = parser.formatSqlDate(date);

        return sqlDate;
    }

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
        return;
    }

    @Override
    protected WebBusinessObject fabricateBusObj(Row row) {

        ListIterator li = supportedForm.getFormElemnts().listIterator();
        FormElement fe = null;
        Hashtable ht = new Hashtable();
        String colName;

        while (li.hasNext()) {
            try {
                fe = (FormElement) li.next();
                colName = (String) fe.getAttribute("column");
                // needs a case ......
                ht.put(fe.getAttribute("name"), row.getString(colName));
            } catch (Exception e) { /* raise an exception */ }
        }

        WebBusinessObject wbo = new WebBusinessObject(ht);
        return wbo;
    }
}
