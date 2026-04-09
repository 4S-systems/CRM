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

public class IssueByComplaint2Mgr extends RDBGateWay {

    private static IssueByComplaint2Mgr issueByComplaint2Mgr = new IssueByComplaint2Mgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();

//    private static final String insertIssueSQL = "INSERT INTO ISSUE_TYPE VALUES (?,?,now(),?)";
    public static IssueByComplaint2Mgr getInstance() {
        logger.info("Getting IssueByComplaintMgr Instance ....");
        return issueByComplaint2Mgr;
    }

    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("issue_by_complaint2.xml")));
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

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
        return; //   throw new UnsupportedOperationException("Not supported yet.");
    }

//     public Vector getComplaintsByDepartment(String beginDate, String endDate){
//        
//        Vector queryResult = new Vector();
//        SQLCommandBean forUpdate = new SQLCommandBean();
//        Vector params = new Vector();
//        Connection connection = null;
//         forUpdate.setSQLQuery(sqlMgr.getSql("getComplaintsByDepartment").trim());
//         params.addElement(new DateValue(getSqlBeginDate(beginDate)));
//        params.addElement(new DateValue(getSqlBeginDate(endDate)));
//        try{
//        
//            connection = dataSource.getConnection();
//            forUpdate.setConnection(connection);
//            forUpdate.setparams(params);
//            queryResult = forUpdate.executeQuery();
//        } catch (Exception se) {
//            logger.error(se.getMessage());
//        } finally {
//            try { 
//                connection.close();
//            } catch (SQLException ex) {
//                logger.error("Close Error");                
//            }
//        }
//
//       Vector resultBusObjs = new Vector();
//       WebBusinessObject wbo;
//        Row r = null;
//        Enumeration e = queryResult.elements();
//        while (e.hasMoreElements()) {
//            r = (Row) e.nextElement();
//            wbo = new WebBusinessObject();
//            wbo = fabricateBusObj(r);
//            resultBusObjs.add(wbo);
//        }
//        return resultBusObjs;
//    }
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

    private java.sql.Date getSqlBeginDate(String date) {
        DateParser parser = new DateParser();
        java.sql.Date sqlDate = parser.formatSqlDate(date);

        return sqlDate;
    }

    public Vector getComplaintsByBussinessId(String bussId) {

        Vector queryResult = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        Vector params = new Vector();
        Connection connection = null;
        forUpdate.setSQLQuery(sqlMgr.getSql("getComplaintsByBussId").trim());
        params.addElement(new StringValue(bussId));

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
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }

    public Vector getComplaintsByClientId() {

        Vector queryResult = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        Vector params = new Vector();
        Connection connection = null;
        forUpdate.setSQLQuery(sqlMgr.getSql("getComplaintsByClientId").trim());


        try {

            connection = dataSource.getConnection();
            forUpdate.setConnection(connection);
            //forUpdate.setparams(params);
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
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }

    public Vector getComplaintsByCustomer(String beginDate, String endDate, String departmentId, String customerName) {

        Vector queryResult = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        Vector params = new Vector();
        Connection connection = null;
        forUpdate.setSQLQuery(sqlMgr.getSql("getComplaintsByCustomer").trim().replace("$", customerName));


        params.addElement(new DateValue(getSqlBeginDate(beginDate)));
        params.addElement(new DateValue(getSqlBeginDate(endDate)));
        params.addElement(new StringValue(departmentId));
        // params.addElement(new StringValue(customerName));

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

        Vector resultBusObjs = new Vector();
        WebBusinessObject wbo;
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

    public Vector getComplaintsByCustomer(String beginDate, String endDate, String customerName) {

        Vector queryResult = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        Vector params = new Vector();
        Connection connection = null;
        forUpdate.setSQLQuery(sqlMgr.getSql("getComplaintsByCustomerAllDeps").trim().replace("$", customerName));


        params.addElement(new DateValue(getSqlBeginDate(beginDate)));
        params.addElement(new DateValue(getSqlBeginDate(endDate)));
        // params.addElement(new StringValue(customerName));

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

        Vector resultBusObjs = new Vector();
        WebBusinessObject wbo;
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
}
