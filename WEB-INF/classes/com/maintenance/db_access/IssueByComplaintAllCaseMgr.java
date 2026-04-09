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
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.log4j.xml.DOMConfigurator;

public class IssueByComplaintAllCaseMgr extends RDBGateWay {

    private static IssueByComplaintAllCaseMgr issueByComplaintAllCaseMgr = new IssueByComplaintAllCaseMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();

//    private static final String insertIssueSQL = "INSERT INTO ISSUE_TYPE VALUES (?,?,now(),?)";
    public static IssueByComplaintAllCaseMgr getInstance() {
        logger.info("Getting IssueByComplaintAllCaseMgr Instance ....");
        return issueByComplaintAllCaseMgr;
    }

    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("issue_by_complaint_all_case.xml")));
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

    public Vector getAllCase() throws SQLException, Exception {

        Vector SQLparams = new Vector();
        WebBusinessObject wbo = null;

        String theQuery = "select * from ISSUE_BY_COMPLAINT_ALL_CASE where STATUS_CODE in (7,6,5,4,3,2)";

        // finally do the query
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = dataSource.getConnection();
        try {

            forQuery.setConnection(connection);
            forQuery.setSQLQuery(theQuery);

            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            throw se;
        } catch (UnsupportedTypeException uste) {
            logger.error("Persistence Error " + uste.getMessage());
        } finally {
            connection.close();
        }

        Vector<WebBusinessObject> reultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            reultBusObjs.add(fabricateBusObj(r));
        }
        String ids = "";
        for (WebBusinessObject wbo3 : reultBusObjs) {

            String clientCompId = (String) wbo3.getAttribute("compId");

            String theQuery2 = "select max(status_id) from issue_status where business_obj_id=" + clientCompId;
            queryResult = null;
            forQuery = new SQLCommandBean();
            connection = dataSource.getConnection();
            try {

                forQuery.setConnection(connection);
                forQuery.setSQLQuery(theQuery2);

                queryResult = forQuery.executeQuery();

            } catch (SQLException se) {
                throw se;
            } catch (UnsupportedTypeException uste) {
                logger.error("Persistence Error " + uste.getMessage());
            } finally {
                connection.close();
            }

            reultBusObjs = new Vector();

            r = null;
            e = queryResult.elements();

            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                ids += r.getString(1) + ",";

            }

        }
        if (ids.length() > 0) {
            String ids2 = ids.substring(0, ids.length() - 1);
            String theQuery3 = "select * from ISSUE_BY_COMPLAINT_ALL_CASE where status_id in (" + ids2 + ")";
            // finally do the query
            queryResult = null;
            forQuery = new SQLCommandBean();
            connection = dataSource.getConnection();
            try {

                forQuery.setConnection(connection);
                forQuery.setSQLQuery(theQuery3);

                queryResult = forQuery.executeQuery();

            } catch (SQLException se) {
                throw se;
            } catch (UnsupportedTypeException uste) {
                logger.error("Persistence Error " + uste.getMessage());
            } finally {
                connection.close();
            }

            reultBusObjs = new Vector();

            r = null;
            e = queryResult.elements();

            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                reultBusObjs.add(fabricateBusObj(r));
            }

            return reultBusObjs;
        }
        return new Vector();
    }

    public Vector getAllCase(String issueId) throws SQLException, Exception {

        Vector SQLparams = new Vector();
        WebBusinessObject wbo = null;

        String theQuery = "select * from ISSUE_BY_COMPLAINT_ALL_CASE where STATUS_CODE in (7,6,5,4,3,2) and issue_id=" +"'"+ issueId +"'";

        // finally do the query
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = dataSource.getConnection();
        try {

            forQuery.setConnection(connection);
            forQuery.setSQLQuery(theQuery);

            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            throw se;
        } catch (UnsupportedTypeException uste) {
            logger.error("Persistence Error " + uste.getMessage());
        } finally {
            connection.close();
        }

        Vector<WebBusinessObject> reultBusObjs = new Vector();
        String ids2 = null;
        Row r = null;
        Enumeration e = queryResult.elements();

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            reultBusObjs.add(fabricateBusObj(r));
        }
        String ids = "";
        if (reultBusObjs != null && !reultBusObjs.isEmpty()) {
            for (WebBusinessObject wbo3 : reultBusObjs) {

                String clientCompId = (String) wbo3.getAttribute("compId");

                String theQuery2 = "select max(status_id) from issue_status where business_obj_id=" +"'" +  clientCompId+ "'" ;
                queryResult = null;
                forQuery = new SQLCommandBean();
                connection = dataSource.getConnection();
                try {

                    forQuery.setConnection(connection);
                    forQuery.setSQLQuery(theQuery2);

                    queryResult = forQuery.executeQuery();

                } catch (SQLException se) {
                    throw se;
                } catch (UnsupportedTypeException uste) {
                    logger.error("Persistence Error " + uste.getMessage());
                } finally {
                    connection.close();
                }

                reultBusObjs = new Vector();

                r = null;
                e = queryResult.elements();

                while (e.hasMoreElements()) {
                    r = (Row) e.nextElement();
                    ids += r.getString(1) + ",";

                }

            }
            ids2 = ids.substring(0, ids.length() - 1);
            if(ids2.split(",").length > 1){
               ids2 = ids2.replace(",", "','");
            }
        } else {
            return null;
        }
        if (ids2.length() > 0) {
            String theQuery3 = "select * from ISSUE_BY_COMPLAINT_ALL_CASE where status_id in (" +"'"+ ids2 +"'"+ ")";
            // finally do the query
            queryResult = null;
            forQuery = new SQLCommandBean();
            connection = dataSource.getConnection();
            try {

                forQuery.setConnection(connection);
                forQuery.setSQLQuery(theQuery3);

                queryResult = forQuery.executeQuery();

            } catch (SQLException se) {
                throw se;
            } catch (UnsupportedTypeException uste) {
                logger.error("Persistence Error " + uste.getMessage());
            } finally {
                connection.close();
            }

            reultBusObjs = new Vector();

            r = null;
            e = queryResult.elements();

            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                reultBusObjs.add(fabricateBusObj(r));
            }
        } else {
            return null;
        }
        return reultBusObjs;

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

    public String getStatusName(String statusId) {
        //Define Variables
        String result = null;
        Vector SQLparams = new Vector();
        Vector queryResult = null;
        Connection connection = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        //Set Params
        SQLparams.addElement(new StringValue(statusId));
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getStatusName").trim());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
            Row r = null;
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                result = r.getString(1);
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
        return result;
    }

    public ArrayList getStatusTypes() throws NoSuchColumnException {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        //Vector params = new Vector();
        Vector queryResult = null;
        ArrayList resultBusObjs = new ArrayList();
        Row r = null;
        Enumeration e = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        //forQuery.setparams(params);
        String query = getQuery("getStatusTypes").trim();
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
            wbo.setAttribute("id", r.getString("id"));
            wbo.setAttribute("enDesc", r.getString("case_en"));
            wbo.setAttribute("arDesc", r.getString("case_ar"));
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }
    public ArrayList getTicketTypes() throws NoSuchColumnException {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        //Vector params = new Vector();
        Vector queryResult = null;
        ArrayList resultBusObjs = new ArrayList();
        Row r = null;
        Enumeration e = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        //forQuery.setparams(params);
        String query = getQuery("getAllTicketTypes").trim();
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
            wbo.setAttribute("type_id", r.getString("type_id"));
            wbo.setAttribute("type_name", r.getString("type_name"));
            wbo.setAttribute("description", r.getString("description"));
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }

    public Vector getAllCaseBetweenDates(java.sql.Date beginDate, java.sql.Date endDate) throws SQLException, Exception {
        Vector SQLparams = new Vector();

        String theQuery = getQuery("getAllCaseBetweenDates").trim();
        SQLparams.addElement(new DateValue(beginDate));
        SQLparams.addElement(new DateValue(endDate));
        // finally do the query
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

        Vector<WebBusinessObject> reultBusObjs = new Vector();

        Row row;
        Enumeration e = queryResult.elements();

        while (e.hasMoreElements()) {
            row = (Row) e.nextElement();
            reultBusObjs.add(fabricateBusObj(row));
        }
        String ids = "";
        for (WebBusinessObject wbo3 : reultBusObjs) {

            String clientCompId = (String) wbo3.getAttribute("compId");

            String theQuery2 = getQuery("Query2").trim() + "'" + clientCompId + "'";
            queryResult = null;
            forQuery = new SQLCommandBean();
            connection = dataSource.getConnection();
            try {

                forQuery.setConnection(connection);
                forQuery.setSQLQuery(theQuery2);

                queryResult = forQuery.executeQuery();

            } catch (SQLException se) {
                throw se;
            } catch (UnsupportedTypeException uste) {
                logger.error("Persistence Error " + uste.getMessage());
            } finally {
                connection.close();
            }
            e = queryResult.elements();

            while (e.hasMoreElements()) {
                row = (Row) e.nextElement();
                ids += "'" + row.getString(1) + "',";

            }

        }
        String ids2 = "";
        if (ids.length() > 0) {
            ids2 = ids.substring(0, ids.length() - 1);
            String theQuery3 = getQuery("Query3WithDates").trim();
            theQuery3 = theQuery3.replace("x", ids2);
            // finally do the query
            queryResult = null;
            forQuery = new SQLCommandBean();
            //SQLparams.add(ids2);
            connection = dataSource.getConnection();
            try {
                forQuery.setConnection(connection);
                forQuery.setSQLQuery(theQuery3);
                forQuery.setparams(SQLparams);
                queryResult = forQuery.executeQuery();

            } catch (SQLException se) {
                throw se;
            } catch (UnsupportedTypeException uste) {
                logger.error("Persistence Error " + uste.getMessage());
            } finally {
                connection.close();
            }
        }

        reultBusObjs = new Vector();
        e = queryResult.elements();

        while (e.hasMoreElements()) {
            row = (Row) e.nextElement();
            reultBusObjs.add(fabricateBusObj(row));
        }

        return reultBusObjs;
    }

    public Vector getAllCase(int within) throws SQLException, Exception {
        String theQuery = getQuery("getAllCaseWithinTime").replaceFirst("no_of_hours", new Integer(within).toString());
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = dataSource.getConnection();
        try {
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(theQuery);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            throw se;
        } catch (UnsupportedTypeException uste) {
            logger.error("Persistence Error " + uste.getMessage());
        } finally {
            connection.close();
        }
        Vector<WebBusinessObject> reultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            reultBusObjs.add(fabricateBusObj(r));
        }
        String ids = "";
        for (WebBusinessObject wbo3 : reultBusObjs) {

            String clientCompId = (String) wbo3.getAttribute("compId");

            String theQuery2 = getQuery("Query2") + clientCompId;
            queryResult = null;
            forQuery = new SQLCommandBean();
            connection = dataSource.getConnection();
            try {
                forQuery.setConnection(connection);
                forQuery.setSQLQuery(theQuery2);
                queryResult = forQuery.executeQuery();
            } catch (SQLException se) {
                throw se;
            } catch (UnsupportedTypeException uste) {
                logger.error("Persistence Error " + uste.getMessage());
            } finally {
                connection.close();
            }

            reultBusObjs = new Vector();
            r = null;
            e = queryResult.elements();
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                ids += r.getString(1) + ",";
            }
        }
        if (ids.length() > 0) {
            String ids2 = ids.substring(0, ids.length() - 1);
            String theQuery3 = getQuery("Query3").replaceFirst("x", ids2);
            queryResult = null;
            forQuery = new SQLCommandBean();
            connection = dataSource.getConnection();
            try {
                forQuery.setConnection(connection);
                forQuery.setSQLQuery(theQuery3);
                queryResult = forQuery.executeQuery();
            } catch (SQLException se) {
                throw se;
            } catch (UnsupportedTypeException uste) {
                logger.error("Persistence Error " + uste.getMessage());
            } finally {
                connection.close();
            }

            reultBusObjs = new Vector();
            r = null;
            e = queryResult.elements();
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                reultBusObjs.add(fabricateBusObj(r));
            }
            return reultBusObjs;
        }
        return new Vector();
    }

    public Vector getAllCaseWithinTimeAndCreatedBy(java.sql.Date beginDate, java.sql.Date endDate, String createdBy) throws SQLException, Exception {
        String theQuery = getQuery("getAllCaseWithinTimeAndCreatedBy");
        Vector parameters = new Vector();
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = dataSource.getConnection();
        try {
            parameters.addElement(new StringValue(createdBy));
            parameters.addElement(new DateValue(beginDate));
            parameters.addElement(new DateValue(endDate));
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(theQuery);
            forQuery.setparams(parameters);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            throw se;
        } catch (UnsupportedTypeException uste) {
            logger.error("Persistence Error " + uste.getMessage());
        } finally {
            connection.close();
        }
        Vector<WebBusinessObject> reultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            reultBusObjs.add(fabricateBusObj(r));
        }
//        String ids = "";
//        for (WebBusinessObject wbo3 : reultBusObjs) {
//
//            String clientCompId = (String) wbo3.getAttribute("compId");
//
//            String theQuery2 = getQuery("Query2") + "'" + clientCompId + "'";
//            queryResult = null;
//            forQuery = new SQLCommandBean();
//            connection = dataSource.getConnection();
//            try {
//                forQuery.setConnection(connection);
//                forQuery.setSQLQuery(theQuery2);
//                queryResult = forQuery.executeQuery();
//            } catch (SQLException se) {
//                throw se;
//            } catch (UnsupportedTypeException uste) {
//                logger.error("Persistence Error " + uste.getMessage());
//            } finally {
//                connection.close();
//            }
//
//            reultBusObjs = new Vector();
//            r = null;
//            e = queryResult.elements();
//            while (e.hasMoreElements()) {
//                r = (Row) e.nextElement();
//                ids += "'" + r.getString(1) + "',";
//            }
//        }
//        if (ids.length() > 0) {
//            String ids2 = ids.substring(0, ids.length() - 1);
//            String theQuery3 = getQuery("Query3").replaceFirst("x", ids2);
//            queryResult = null;
//            forQuery = new SQLCommandBean();
//            connection = dataSource.getConnection();
//            try {
//                forQuery.setConnection(connection);
//                forQuery.setSQLQuery(theQuery3);
//                queryResult = forQuery.executeQuery();
//            } catch (SQLException se) {
//                throw se;
//            } catch (UnsupportedTypeException uste) {
//                logger.error("Persistence Error " + uste.getMessage());
//            } finally {
//                connection.close();
//            }
//
//            reultBusObjs = new Vector();
//            r = null;
//            e = queryResult.elements();
//            while (e.hasMoreElements()) {
//                r = (Row) e.nextElement();
//                reultBusObjs.add(fabricateBusObj(r));
//            }
            return reultBusObjs;
//        }
//        return new Vector();
    }

    public ArrayList getStatusTypesByDepart (String depID) throws NoSuchColumnException{
         WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector params = new Vector();
        params.addElement(new StringValue(depID));
        Vector queryResult = null;
        ArrayList resultBusObjs = new ArrayList();
        Row r = null;
        Enumeration e = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        forQuery.setparams(params);
        String query = getQuery("getAllTicketTypesByDepartmentCode").trim();
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
            wbo.setAttribute("type_id", r.getString("type_id"));
            wbo.setAttribute("type_name", r.getString("type_name"));
            wbo.setAttribute("description", r.getString("description"));
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }
    
    public Vector getAllCaseWithinTimeForDep(int within, String depCode) throws SQLException, Exception {
        String theQuery = getQuery("getAllCaseWithinTimeByDep").replaceFirst("no_of_hours", new Integer(within).toString());
        Vector parameters = new Vector();
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = dataSource.getConnection();
        try {
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(theQuery.replaceFirst("depCode", depCode));
            forQuery.setparams(parameters);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            throw se;
        } catch (UnsupportedTypeException uste) {
            logger.error("Persistence Error " + uste.getMessage());
        } finally {
            connection.close();
        }
        Vector<WebBusinessObject> reultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            reultBusObjs.add(fabricateBusObj(r));
        }
//        String ids = "";
//        for (WebBusinessObject wbo3 : reultBusObjs) {
//
//            String clientCompId = (String) wbo3.getAttribute("compId");
//
//            String theQuery2 = getQuery("Query2") + "'" + clientCompId + "'";
//            queryResult = null;
//            forQuery = new SQLCommandBean();
//            connection = dataSource.getConnection();
//            try {
//                forQuery.setConnection(connection);
//                forQuery.setSQLQuery(theQuery2);
//                queryResult = forQuery.executeQuery();
//            } catch (SQLException se) {
//                throw se;
//            } catch (UnsupportedTypeException uste) {
//                logger.error("Persistence Error " + uste.getMessage());
//            } finally {
//                connection.close();
//            }
//
//            reultBusObjs = new Vector();
//            r = null;
//            e = queryResult.elements();
//            while (e.hasMoreElements()) {
//                r = (Row) e.nextElement();
//                ids += "'" + r.getString(1) + "',";
//            }
//        }
//        if (ids.length() > 0) {
//            String ids2 = ids.substring(0, ids.length() - 1);
//            String theQuery3 = getQuery("Query3").replaceFirst("x", ids2);
//            queryResult = null;
//            forQuery = new SQLCommandBean();
//            connection = dataSource.getConnection();
//            try {
//                forQuery.setConnection(connection);
//                forQuery.setSQLQuery(theQuery3);
//                queryResult = forQuery.executeQuery();
//            } catch (SQLException se) {
//                throw se;
//            } catch (UnsupportedTypeException uste) {
//                logger.error("Persistence Error " + uste.getMessage());
//            } finally {
//                connection.close();
//            }
//
//            reultBusObjs = new Vector();
//            r = null;
//            e = queryResult.elements();
//            while (e.hasMoreElements()) {
//                r = (Row) e.nextElement();
//                reultBusObjs.add(fabricateBusObj(r));
//            }
            return reultBusObjs;
//        }
//        return new Vector();
    }
    
    public ArrayList<WebBusinessObject> getRequestsBetweenDates(java.sql.Date beginDate, java.sql.Date endDate,
            String contractorID, String engineerID, String type) throws SQLException, Exception {
        Vector SQLparams = new Vector();
        String theQuery = getQuery("getRequestsBetweenDates").trim().replaceAll("contractorID", contractorID).replaceAll("engineerID", engineerID);
        SQLparams.addElement(new DateValue(beginDate));
        Calendar c = Calendar.getInstance();
        c.setTime(endDate);
        c.add(Calendar.DATE, 1);
        endDate = new java.sql.Date(c.getTimeInMillis());
        SQLparams.addElement(new DateValue(endDate));
        SQLparams.addElement(new StringValue(type));
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
        ArrayList<WebBusinessObject> reultBusObjs = new ArrayList<WebBusinessObject>();
        Row row;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            row = (Row) e.nextElement();
            WebBusinessObject wbo = fabricateBusObj(row) ;
            if(row.getString("counts") != null){
                wbo.setAttribute("count", row.getString("counts"));
            }
            if(row.getString("NAME_OF_PROJECT") != null){
                wbo.setAttribute("nameOfProject", row.getString("NAME_OF_PROJECT"));
            }
            reultBusObjs.add(wbo);
        }
        return reultBusObjs;
    }

    public ArrayList<WebBusinessObject> getAllCaseByClientComplaintCode (String clientComplaint) {
        try {
            Vector SQLparams = new Vector();
            String theQuery = getQuery("getAllCaseByClientComplaintCode").trim();
            SQLparams.addElement(new StringValue(clientComplaint));
            
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
            ArrayList<WebBusinessObject> reultBusObjs = new ArrayList<WebBusinessObject>();
            Row row;
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                row = (Row) e.nextElement();
                reultBusObjs.add(fabricateBusObj(row));
            }
            
            return reultBusObjs;
        } catch (SQLException ex) {
            Logger.getLogger(IssueByComplaintAllCaseMgr.class.getName()).log(Level.SEVERE, null, ex);
            return null ;
        }
    }
    
    
}
