package com.maintenance.db_access;

import com.crm.common.CRMConstants;
import com.maintenance.common.DateParser;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import com.silkworm.util.DateAndTimeControl;
import com.tracker.db_access.ProjectMgr;
import java.sql.Connection;
import java.sql.Date;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.http.HttpSession;
import org.apache.log4j.xml.DOMConfigurator;

public class IssueByComplaintMgr extends RDBGateWay {

    private static final IssueByComplaintMgr ISSUE_BY_COMPLAINT_MGR = new IssueByComplaintMgr();
    private final SqlMgr sqlMgr = SqlMgr.getInstance();

    public static IssueByComplaintMgr getInstance() {
        logger.info("Getting IssueByComplaintMgr Instance ....");
        return ISSUE_BY_COMPLAINT_MGR;
    }

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("issue_by_complaint.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public boolean saveObject(WebBusinessObject wbo, HttpSession s) throws NoUserInSessionException {

        return false;
    }

    @Override
    public ArrayList getCashedTableAsArrayList() {

        cashedData = new ArrayList();
        WebBusinessObject wbo;

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

    public Vector getComplaintsByClientId(String clientId) {
        Vector queryResult = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        Vector parameters = new Vector();

        parameters.addElement(new StringValue(clientId));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(sqlMgr.getSql("getComplaintsByClientId").trim());
            forUpdate.setparams(parameters);
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
        Row row;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            row = (Row) e.nextElement();
            wbo = fabricateBusObj(row);
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

    /**
     *
     * @param since represent time by hours
     * @return
     * @throws Exception
     */
    public Vector<WebBusinessObject> getNotAcknowledgeComplaintsBySince(String since) throws Exception {
        SQLCommandBean command = new SQLCommandBean();
        Vector queryResult;
        Vector<WebBusinessObject> data = new Vector<WebBusinessObject>();

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getNotAcknowledgeComplaintsBySince").replaceAll("since", since).trim());
            queryResult = command.executeQuery();

            WebBusinessObject wbo;
            if (queryResult != null && !queryResult.isEmpty()) {
                for (Object row : queryResult) {
                    wbo = fabricateBusObj((Row) row);
                    wbo.setAttribute("ticketType", ((Row) row).getString("TICKET_TYPE"));
                    data.addElement(wbo);
                }
            }

        } catch (UnsupportedTypeException ex) {
            logger.error(ex);
        } finally {
            connection.close();
        }

        return data;
    }

    /**
     *
     * @param userId
     * @param since
     * @return
     */
    public List<WebBusinessObject> getComplaintByOlderStatus(String userId, int since , Date beginDate, Date endDate) {
        return getComplaintByOlderStatus(userId, CRMConstants.CLIENT_COMPLAINT_STATUS_FINISHED, since , beginDate ,endDate );
    }

    /**
     *
     * @param userId
     * @param statusCode
     * @param since represent time by hours
     * @return
     */
    public List<WebBusinessObject> getComplaintByOlderStatus(String userId, String statusCode, int since , Date beginDate, Date endDate) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        List<WebBusinessObject> data = new ArrayList<WebBusinessObject>();
        Vector<Row> result;
        Vector parameters = new Vector();

        parameters.addElement(new StringValue(statusCode));
        parameters.addElement(new StringValue(userId));
        parameters.addElement(new StringValue(statusCode));
        parameters.addElement(new DateValue(beginDate));
        parameters.addElement(new DateValue(endDate));
        

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getComplaintByOlderStatus").replaceAll("WITH_IN", "" + since).trim());
            command.setparams(parameters);
            result = command.executeQuery();

            for (Row row : result) {
                data.add(fabricateBusObj(row));
            }
        } catch (SQLException ex) {
            logger.error(ex);
        } catch (UnsupportedTypeException ex) {
            logger.error(ex);
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex);
            }
        }

        return data;
    }

    public List<WebBusinessObject> getComplaintByCreatedBy(String createdBy, int since) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        List<WebBusinessObject> data = new ArrayList<WebBusinessObject>();
        Vector<Row> result;
        Vector parameters = new Vector();

        parameters.addElement(new StringValue(createdBy));

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getComplaintByCreatedBy").replaceAll("WITH_IN", "" + since).trim());
            command.setparams(parameters);
            result = command.executeQuery();

            for (Row row : result) {
                data.add(fabricateBusObj(row));
            }
        } catch (SQLException ex) {
            logger.error(ex);
        } catch (UnsupportedTypeException ex) {
            logger.error(ex);
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex);
            }
        }

        return data;
    }

    public List<WebBusinessObject> getComplaintByOlder(String userId, String fromDate, String toDate) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        List<WebBusinessObject> data = new ArrayList<WebBusinessObject>();
        Vector<Row> result;
        Vector parameters = new Vector();

        parameters.addElement(new StringValue(userId));
        parameters.addElement(new DateValue(getSqlBeginDate(fromDate)));
        parameters.addElement(new DateValue(getSqlBeginDate(toDate)));

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getComplaintByOlder").trim());
            command.setparams(parameters);
            result = command.executeQuery();

            for (Row row : result) {
                data.add(fabricateBusObj(row));
            }
        } catch (SQLException ex) {
            logger.error(ex);
        } catch (UnsupportedTypeException ex) {
            logger.error(ex);
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex);
            }
        }

        return data;
    }

    public List<WebBusinessObject> getComplaintsByCreatorDateComments(String creator, Date beginDate, Date endDate, String contractorID, String type) {
        SQLCommandBean command = new SQLCommandBean();
        String theQuery = getQuery("getComplaintsByCreatorDateComments").trim().replaceAll("contractorID", contractorID);
        Connection connection = null;
        List<WebBusinessObject> data = new ArrayList<WebBusinessObject>();
        Vector<Row> result;
        Vector parameters = new Vector();

        Date date = new Date(endDate.getYear(), endDate.getMonth(), endDate.getDate() + 1);
        parameters.addElement(new StringValue(creator));
        parameters.addElement(new DateValue(beginDate));
        parameters.addElement(new DateValue(date));
        parameters.addElement(new StringValue(type));

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(theQuery);
            command.setparams(parameters);
            result = command.executeQuery();

            WebBusinessObject wbo;
            for (Row row : result) {
                wbo = fabricateBusObj(row);
                try {
                    if (row.getBigDecimal("NO_COMMENTS") != null) {
                        wbo.setAttribute("comments", row.getBigDecimal("NO_COMMENTS"));
                    }
                    if (row.getString("ISSUE_STATUS_CODE") != null) {
                        wbo.setAttribute("issueStatusCode", row.getString("ISSUE_STATUS_CODE"));
                    }
                } catch (NoSuchColumnException | UnsupportedConversionException ex) {
                    logger.error(ex);
                }
                data.add(wbo);
            }
        } catch (SQLException ex) {
            logger.error(ex);
        } catch (UnsupportedTypeException ex) {
            logger.error(ex);
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex);
            }
        }

        return data;
    }

    public List<WebBusinessObject> getComplaintsByCrruentOwnerDateComments(String currentOwner, Date beginDate, Date endDate, String type) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        List<WebBusinessObject> data = new ArrayList<WebBusinessObject>();
        Vector<Row> result;
        Vector parameters = new Vector();

        Date date = new Date(endDate.getYear(), endDate.getMonth(), endDate.getDate() + 1);
        parameters.addElement(new StringValue(currentOwner));
        parameters.addElement(new DateValue(beginDate));
        parameters.addElement(new DateValue(date));
        parameters.addElement(new StringValue(type));

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getComplaintsByCrruentOwnerDateComments").trim());
            command.setparams(parameters);
            result = command.executeQuery();

            WebBusinessObject wbo;
            for (Row row : result) {
                wbo = fabricateBusObj(row);
                try {
                    if (row.getBigDecimal("NO_COMMENTS") != null) {
                        wbo.setAttribute("comments", row.getBigDecimal("NO_COMMENTS"));
                    }
                    if (row.getString("ISSUE_STATUS_CODE") != null) {
                        wbo.setAttribute("issueStatusCode", row.getString("ISSUE_STATUS_CODE"));
                    }
                    if (row.getString("ISSUE_STATUS_NAME") != null) {
                        wbo.setAttribute("issueStatusName", row.getString("ISSUE_STATUS_NAME"));
                    }
                } catch (NoSuchColumnException ex) {
                    logger.error(ex);
                } catch (UnsupportedConversionException ex) {
                    logger.error(ex);
                }
                data.add(wbo);
            }
        } catch (SQLException ex) {
            logger.error(ex);
        } catch (UnsupportedTypeException ex) {
            logger.error(ex);
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex);
            }
        }

        return data;
    }

    public List<WebBusinessObject> getComplaintsByDateComments(Date beginDate, Date endDate, String type) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        List<WebBusinessObject> data = new ArrayList<WebBusinessObject>();
        Vector<Row> result;
        Vector parameters = new Vector();

        Date date = new Date(endDate.getYear(), endDate.getMonth(), endDate.getDate() + 1);
        parameters.addElement(new DateValue(beginDate));
        parameters.addElement(new DateValue(date));
        parameters.addElement(new StringValue(type));

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getComplaintsByDateComments").trim());
            command.setparams(parameters);
            result = command.executeQuery();

            WebBusinessObject wbo;
            for (Row row : result) {
                try {
                    wbo = fabricateBusObj(row);
                    wbo.setAttribute("comments", row.getBigDecimal("NO_COMMENTS"));
                    data.add(wbo);
                } catch (NoSuchColumnException ex) {
                    logger.error(ex);
                } catch (UnsupportedConversionException ex) {
                    logger.error(ex);
                }
            }
        } catch (SQLException ex) {
            logger.error(ex);
        } catch (UnsupportedTypeException ex) {
            logger.error(ex);
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex);
            }
        }

        return data;
    }

    public List<WebBusinessObject> getValidComplaintsByComments(String type, String customerID) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        List<WebBusinessObject> data = new ArrayList<WebBusinessObject>();
        Vector<Row> result;
        Vector parameters = new Vector();

        parameters.addElement(new StringValue(type));
        parameters.addElement(new StringValue(customerID));

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getValidComplaintsByComments").trim());
            command.setparams(parameters);
            result = command.executeQuery();

            WebBusinessObject wbo;
            for (Row row : result) {
                try {
                    wbo = fabricateBusObj(row);
                    wbo.setAttribute("comments", row.getBigDecimal("NO_COMMENTS"));
                    if (row.getString("STATUS_NOTE") != null) {
                        wbo.setAttribute("statusNote", row.getString("STATUS_NOTE"));
                    }
                    if (row.getString("STATUS_NAME") != null) {
                        wbo.setAttribute("statusName", row.getString("STATUS_NAME"));
                    }
                    data.add(wbo);
                } catch (NoSuchColumnException ex) {
                    logger.error(ex);
                } catch (UnsupportedConversionException ex) {
                    logger.error(ex);
                }
            }
        } catch (SQLException ex) {
            logger.error(ex);
        } catch (UnsupportedTypeException ex) {
            logger.error(ex);
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex);
            }
        }

        return data;
    }

    public List<WebBusinessObject> getIssueComplaintsByComments(String type, String issueID) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        List<WebBusinessObject> data = new ArrayList<WebBusinessObject>();
        Vector<Row> result;
        Vector parameters = new Vector();

        parameters.addElement(new StringValue(type));
        parameters.addElement(new StringValue(issueID));

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getIssueComplaintsByComments").trim());
            command.setparams(parameters);
            result = command.executeQuery();

            WebBusinessObject wbo;
            for (Row row : result) {
                try {
                    wbo = fabricateBusObj(row);
                    wbo.setAttribute("comments", row.getBigDecimal("NO_COMMENTS"));
                    if (row.getString("STATUS_NOTE") != null) {
                        wbo.setAttribute("statusNote", row.getString("STATUS_NOTE"));
                    }
                    if (row.getString("STATUS_NAME") != null) {
                        wbo.setAttribute("statusName", row.getString("STATUS_NAME"));
                    }
                    data.add(wbo);
                } catch (NoSuchColumnException ex) {
                    logger.error(ex);
                } catch (UnsupportedConversionException ex) {
                    logger.error(ex);
                }
            }
        } catch (SQLException ex) {
            logger.error(ex);
        } catch (UnsupportedTypeException ex) {
            logger.error(ex);
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex);
            }
        }

        return data;
    }

    public List<WebBusinessObject> getComplaintByDepartment(int within, String depCode, String fromDate, String toDate) {
        SQLCommandBean commad = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        Vector<Row> queryResult = null;
        List<WebBusinessObject> result = new ArrayList<WebBusinessObject>();
        
        StringBuilder dateCon = new StringBuilder();
        if(fromDate != null){
           dateCon.append(" AND trunc(entry_date) >= ?");
           parameters.addElement(new DateValue(getSqlBeginDate(fromDate))); 
        }
        
        if(toDate != null){
           dateCon.append("AND trunc(entry_date) <= ?");
           parameters.addElement(new DateValue(getSqlBeginDate(toDate))); 
        }
                
        try {
            connection = dataSource.getConnection();
            commad.setConnection(connection);
            commad.setSQLQuery(getQuery("getComplaintByDepartment").replaceFirst("depCode", depCode).replaceAll("dateCondition", dateCon.toString()).trim());
            commad.setparams(parameters);
            queryResult = commad.executeQuery();
        } catch (SQLException se) {
            logger.error(se);
        } catch (UnsupportedTypeException uste) {
            logger.error(uste);
        } finally {
            try {
                connection.close();
            } catch (SQLException se) {
                logger.error(se);
            }
        }

        for (Row row : queryResult) {
            result.add(fabricateBusObj(row));
        }
        return result;
    }

    public Vector<WebBusinessObject> preparer(Vector<WebBusinessObject> complaints) {
        if (!complaints.isEmpty()) {

            // prepare complaints
            WebBusinessObject wbo;
            String businessId;
            String customerType;
            String customerName;
            String mobile;
            String complaintType;
            String complaintSubject;
            String statusName;
            String statusDate;
            String employeeName;
            String managerName;
            String entryDate;
            for (WebBusinessObject complaint : complaints) {
                try {

                    businessId = complaint.getAttribute("businessID").toString() + "/" + complaint.getAttribute("businessIDbyDate");
                    complaintType = (String) complaint.getAttribute("typeName");

                    if (complaint.getAttribute("age").equals("100")) {
                        customerType = "شركة";
                    } else {
                        customerType = "فرد";
                    }

                    mobile = (String) complaint.getAttribute("mobile");
                    if (mobile == null) {
                        mobile = "---------";
                    } else if (mobile.trim().isEmpty()) {
                        mobile = "---------";
                    }

                    complaintSubject = (String) complaint.getAttribute("compSubject");
                    if (complaintSubject != null && complaintSubject.length() > 20) {
                        complaintSubject = complaintSubject.substring(0, 17) + "...";
                    } else {
                        complaintSubject = "---------";
                    }

                    statusName = (String) complaint.getAttribute("statusArName");
                    wbo = DateAndTimeControl.getFormattedDateTime((String) complaint.getAttribute("entryDate"), "Ar");
                    statusDate = wbo.getAttribute("day") + "-" + wbo.getAttribute("time");
                    customerName = (String) complaint.getAttribute("customerName");
                    employeeName = (String) complaint.getAttribute("currentOwner");
                    managerName = (String) complaint.getAttribute("fullName");

                    entryDate = DateAndTimeControl.getArabicDateTimeFormatted((String) complaint.getAttribute("entryDate"));

                    complaint.setAttribute("businessId", businessId);
                    complaint.setAttribute("customerType", customerType);
                    complaint.setAttribute("customerName", customerName);
                    complaint.setAttribute("mobile", mobile);
                    complaint.setAttribute("complaintType", complaintType);
                    complaint.setAttribute("complaintSubject", complaintSubject);
                    complaint.setAttribute("statusName", statusName);
                    complaint.setAttribute("statusDate", statusDate);
                    complaint.setAttribute("statusDay", wbo.getAttribute("day"));
                    complaint.setAttribute("statusTime", wbo.getAttribute("time"));
                    complaint.setAttribute("employeeName", employeeName);
                    complaint.setAttribute("managerName", managerName);
                    complaint.setAttribute("entryDate", entryDate);
                } catch (Exception ex) {
                    logger.error(ex);
                }
            }
        }

        return complaints;
    }

    /**
     *
     * @param since represent time by hours
     * @return
     * @throws Exception
     */
    public Vector<WebBusinessObject> getPreparedNotAcknowledgeComplaintsBySince(String since) throws Exception {
        Vector<WebBusinessObject> complaints = preparer(this.getNotAcknowledgeComplaintsBySince(since));
        return complaints;
    }

    public ArrayList<WebBusinessObject> getAllCaseWithinTimeAndCompliantCode(String fromDate, String toDate, String departmentCode, String searchType, String userID) throws SQLException, Exception {

        String theQuery = getQuery("getAllCaseWithinTimeAndCompliantCode");
        StringBuilder where = new StringBuilder();
        StringBuilder tempSelect = new StringBuilder("in (select emp_id from emp_mgr where mgr_id in (select PROJECT.OPTION_ONE from project where eq_no = '")
                .append(departmentCode).append("') union select PROJECT.OPTION_ONE from project where eq_no = '")
                .append(departmentCode).append("')");
        StringBuilder userWhere = new StringBuilder();
        if (searchType != null && !searchType.isEmpty()) {
            where.append("and (");
            if (!searchType.equalsIgnoreCase("owner")) {
                where.append("sender_id ").append(tempSelect);
            }
            if (searchType.equalsIgnoreCase("all")) {
                where.append(" or ");
            }
            if (!searchType.equalsIgnoreCase("sender")) {
                where.append("current_owner_id ").append(tempSelect);
            }
            where.append(")");
            if (!userID.equals("all")) {
                if (searchType.equalsIgnoreCase("owner")) {
                    userWhere.append(" and current_owner_id = '").append(userID).append("'");
                } else if (searchType.equalsIgnoreCase("sender")) {
                    userWhere.append(" and sender_id = '").append(userID).append("'");
                } else {
                    userWhere.append(" and (current_owner_id = '").append(userID).append("' or ");
                    userWhere.append(" sender_id = '").append(userID).append("')");
                }
            }
        } else {
            return new ArrayList<WebBusinessObject>();
        }
        theQuery = theQuery.replaceFirst("whereStatement", where.toString());
        Vector params = new Vector();
        Vector queryResult = null;
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
        params.addElement(new DateValue(new java.sql.Date(sdf.parse(fromDate).getTime())));
        params.addElement(new DateValue(new java.sql.Date(sdf.parse(toDate).getTime())));
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = dataSource.getConnection();
        try {
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(theQuery + userWhere.toString());
            forQuery.setparams(params);
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
    }

    public ArrayList<WebBusinessObject> getAllCaseWithinTimeAndCompliantCodeSubDiv(String fromDate, String toDate, String departmentID, String searchType) throws SQLException, Exception {

        String theQuery = getQuery("getAllCaseWithinTimeAndCompliantCode");
        StringBuilder where = new StringBuilder();
        StringBuilder tempSelect = new StringBuilder("in (select emp_id from emp_mgr where mgr_id in (select PROJECT.OPTION_ONE from project where project_id = '")
                .append(departmentID).append("') union select PROJECT.OPTION_ONE from project where project_id = '")
                .append(departmentID).append("')");
        if (searchType != null && !searchType.isEmpty()) {
            where.append("and (");
            if (!searchType.equalsIgnoreCase("owner")) {
                where.append("sender_id ").append(tempSelect);
            }
            if (searchType.equalsIgnoreCase("all")) {
                where.append(" or ");
            }
            if (!searchType.equalsIgnoreCase("sender")) {
                where.append("current_owner_id ").append(tempSelect);
            }
            where.append(")");
        } else {
            return new ArrayList<WebBusinessObject>();
        }
        theQuery = theQuery.replaceFirst("whereStatement", where.toString());
        Vector params = new Vector();
        Vector queryResult = null;
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
        params.addElement(new DateValue(new java.sql.Date(sdf.parse(fromDate).getTime())));
        params.addElement(new DateValue(new java.sql.Date(sdf.parse(toDate).getTime())));
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = dataSource.getConnection();
        try {
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(theQuery);
            forQuery.setparams(params);
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
    }

    public List<WebBusinessObject> getAllComplaintsByDateComments(String creator, Date beginDate, Date endDate, String type, String engineerID, String contractorID, String itemID, String projectID) {
        String theQuery = getQuery("getAllComplaintsByDateComments").trim().replaceAll("contractorID", contractorID)
                .replaceAll("engineerID", engineerID).replaceAll("itemID", itemID).replaceAll("projectID", projectID);
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        List<WebBusinessObject> data = new ArrayList<WebBusinessObject>();
        Vector<Row> result;
        Vector parameters = new Vector();

        parameters.addElement(new DateValue(beginDate));
        parameters.addElement(new DateValue(endDate));
        parameters.addElement(new StringValue(type));

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(theQuery);
            command.setparams(parameters);
            result = command.executeQuery();

            WebBusinessObject wbo;
            for (Row row : result) {
                wbo = fabricateBusObj(row);
                try {
                    if (row.getBigDecimal("NO_COMMENTS") != null) {
                        wbo.setAttribute("comments", row.getBigDecimal("NO_COMMENTS"));
                    }
                    if (row.getString("ISSUE_STATUS_CODE") != null) {
                        wbo.setAttribute("issueStatusCode", row.getString("ISSUE_STATUS_CODE"));
                    }
                    if (row.getString("ISSUE_STATUS_NAME") != null) {
                        wbo.setAttribute("issueStatusName", row.getString("ISSUE_STATUS_NAME"));
                    }
                } catch (NoSuchColumnException ex) {
                    logger.error(ex);
                } catch (UnsupportedConversionException ex) {
                    logger.error(ex);
                }
                data.add(wbo);
            }
        } catch (SQLException ex) {
            logger.error(ex);
        } catch (UnsupportedTypeException ex) {
            logger.error(ex);
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex);
            }
        }

        return data;
    }

    public List<WebBusinessObject> getAllComplaintsByDateLastCommenter(String creator, Date beginDate, Date endDate, String type, String engineerID, String contractorID, String itemID, String projectID, String statusOfIssue) {
        String theQuery = getQuery("getAllComplaintsByDateLastCommenter").trim().replaceAll("contractorID", contractorID)
                .replaceAll("engineerID", engineerID).replaceAll("itemID", itemID).replaceAll("projectID", projectID)
                .replaceAll("statusOfIssue", statusOfIssue);
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        List<WebBusinessObject> data = new ArrayList<WebBusinessObject>();
        Vector<Row> result;
        Vector parameters = new Vector();

        parameters.addElement(new DateValue(beginDate));
        parameters.addElement(new DateValue(endDate));
        parameters.addElement(new StringValue(type));

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(theQuery);
            command.setparams(parameters);
            result = command.executeQuery();

            WebBusinessObject wbo;
            for (Row row : result) {
                wbo = fabricateBusObj(row);
                try {
                    if (row.getString("LAST_COMMENTER_ID") != null) {
                        wbo.setAttribute("lastCommenterID", row.getString("LAST_COMMENTER_ID"));
                    }
                    if (row.getString("ISSUE_STATUS") != null) {
                        wbo.setAttribute("issueStatus", row.getString("ISSUE_STATUS"));
                    }
                    if (row.getString("NAME_OF_PROJECT") != null) {
                        wbo.setAttribute("nameOfProject", row.getString("NAME_OF_PROJECT"));
                    }
                    if (row.getString("ENGINEER_NAME") != null) {
                        wbo.setAttribute("engineerName", row.getString("ENGINEER_NAME"));
                    }
                    if (row.getBigDecimal("NO_COMMENTS") != null) {
                        wbo.setAttribute("comments", row.getBigDecimal("NO_COMMENTS"));
                    }
                    if (row.getString("LAST_COMMENT_DATE") != null) {
                        wbo.setAttribute("lastCommentDate", row.getString("LAST_COMMENT_DATE"));
                    }
                } catch (NoSuchColumnException ex) {
                    logger.error(ex);
                } catch (UnsupportedConversionException ex) {
                    Logger.getLogger(IssueByComplaintMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                data.add(wbo);
            }
        } catch (SQLException ex) {
            logger.error(ex);
        } catch (UnsupportedTypeException ex) {
            logger.error(ex);
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex);
            }
        }

        return data;
    }

    public ArrayList<WebBusinessObject> getAllComplaintsByUserAndStatusAndSource(String ownerID, String sourceID, String beginDate, String endDate, String issueStatus, String noAppCmnt, String departmentIDs) {
        StringBuilder theQuery = new StringBuilder(getQuery("getAllComplaintsByUserAndStatus").trim());
        StringBuilder where = new StringBuilder();
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        ArrayList<WebBusinessObject> data = new ArrayList<>();
        Vector<Row> result;
        Vector parameters = new Vector();
        boolean and = false;
        if (ownerID != null && !ownerID.isEmpty()) {
            parameters.addElement(new StringValue(ownerID));
            where.append(" CC.CURRENT_OWNER_ID = ? and I.ID is not null ");
            and = true;
        } else if(departmentIDs != null) {
            where.append(" CC.CURRENT_OWNER_ID IN (SELECT EMP_ID FROM EMP_MGR WHERE MGR_ID IN (SELECT OPTION_ONE FROM PROJECT WHERE PROJECT_ID IN ('")
                    .append(departmentIDs).append("'))) and I.ID is not null");
            and = true;
        }

        /*if (sourceID != null && !sourceID.isEmpty()) {
            parameters.addElement(new StringValue(sourceID));
            if (and) {
                where.append(" AND ");
            }
            where.append(" CC.CREATED_BY = ? ");
            and = true;
        }*/
        if (beginDate != null && !beginDate.isEmpty()) {
            if (and) {
                where.append(" AND ");
            }
            where.append(" TRUNC(CC.CREATION_TIME) >= TO_DATE(?, 'YYYY/MM/DD')");
            parameters.addElement(new StringValue(beginDate));
            and = true;
        }
        if (endDate != null && !endDate.isEmpty()) {
            if(and){
                where.append(" AND ");
            }
            where.append(" TRUNC(CC.CREATION_TIME) <= TO_DATE(?, 'YYYY/MM/DD')");
            parameters.addElement(new StringValue(endDate));
            and = true;
        }

        if (noAppCmnt != null && noAppCmnt.equals("on")) {
            if(and){
                where.append(" AND ");
            }
            where.append(" I.URGENCY_ID NOT IN (SELECT CLIENT_ID from APPOINTMENT) AND I.URGENCY_ID NOT IN (SELECT BUSNIESS_OBJECT_ID from COMMENTS)");            
        }
        if (issueStatus != null && !issueStatus.isEmpty()) {
            if(and){
                where.append(" AND ");
            }
            where.append(" CC.CURRENT_STATUS in (").append(issueStatus).append(")");            
        }
        if (where.toString().length() > 0) {
            theQuery.append(" WHERE ").append(where);
        }
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(theQuery.toString());
            command.setparams(parameters);
            result = command.executeQuery();
            WebBusinessObject wbo;
            for (Row row : result) {
                wbo = fabricateBusObj(row);
                try {
                    if (row.getString("CREATED_BY_NAME") != null) {
                        wbo.setAttribute("createdByName", row.getString("CREATED_BY_NAME"));
                    }
                    if (row.getString("TYPE_TAG") != null) {
                        wbo.setAttribute("typeTag", row.getString("TYPE_TAG"));
                    }if (row.getString("current_status") != null) {
                        wbo.setAttribute("current_status", row.getString("current_status"));
                    }
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(IssueByComplaintMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                data.add(wbo);
            }
        } catch (SQLException | UnsupportedTypeException ex) {
            logger.error(ex);
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error(ex);
            }
        }
        return data;
    }

    public List<WebBusinessObject> getComplaintsWithComments(String creator, Date beginDate, Date endDate, String comment) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        List<WebBusinessObject> data = new ArrayList<WebBusinessObject>();
        Vector<Row> result;
        Vector parameters = new Vector();

        Date date = new Date(endDate.getYear(), endDate.getMonth(), endDate.getDate() + 1);
        parameters.addElement(new StringValue("%" + creator + "%"));
        parameters.addElement(new DateValue(beginDate));
        parameters.addElement(new DateValue(date));
        parameters.addElement(new StringValue("%" + comment + "%"));

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getComplaintsWithComments").trim());
            command.setparams(parameters);
            result = command.executeQuery();

            WebBusinessObject wbo;
            for (Row row : result) {
                wbo = fabricateBusObj(row);
                try {
                    if (row.getBigDecimal("NO_COMMENTS") != null) {
                        wbo.setAttribute("comments", row.getBigDecimal("NO_COMMENTS"));
                    }
                    if (row.getString("ISSUE_STATUS_CODE") != null) {
                        wbo.setAttribute("issueStatusCode", row.getString("ISSUE_STATUS_CODE"));
                    }
                    if (row.getString("ISSUE_STATUS_NAME") != null) {
                        wbo.setAttribute("issueStatusName", row.getString("ISSUE_STATUS_NAME"));
                    }
                } catch (NoSuchColumnException ex) {
                    logger.error(ex);
                } catch (UnsupportedConversionException ex) {
                    logger.error(ex);
                }
                data.add(wbo);
            }
        } catch (SQLException ex) {
            logger.error(ex);
        } catch (UnsupportedTypeException ex) {
            logger.error(ex);
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex);
            }
        }

        return data;
    }

    public ArrayList<WebBusinessObject> getTimeAgeByDepartmentSince(String since, String departmentID, String type) throws Exception {
        SQLCommandBean command = new SQLCommandBean();
        Vector queryResult;
        ArrayList<WebBusinessObject> data = new ArrayList<WebBusinessObject>();
        Vector params = new Vector();
        params.addElement(new StringValue(departmentID));
        String query;
        if (type.equals("acknow")) {
            query = getQuery("getTimeAgeByDepartmentAcknow");
        } else if (type.equals("finish")) {
            query = getQuery("getTimeAgeByDepartmentFinish");
        } else {
            query = getQuery("getTimeAgeByDepartmentClose");
        }

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(query.replaceAll("since", since).trim());
            command.setparams(params);
            queryResult = command.executeQuery();
            WebBusinessObject wbo;
            if (queryResult != null && !queryResult.isEmpty()) {
                for (Object row : queryResult) {
                    wbo = fabricateBusObj((Row) row);
                    wbo.setAttribute("ticketType", ((Row) row).getString("TICKET_TYPE"));
                    data.add(wbo);
                }
            }
        } catch (UnsupportedTypeException ex) {
            logger.error(ex);
        } finally {
            if (connection != null) {
                connection.close();
            }
        }
        return data;
    }

    public ArrayList<WebBusinessObject> getComplaintsPerEmployee(String userID, Date fromDate, Date toDate, String interCode, String sourceID) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        ArrayList<WebBusinessObject> data = new ArrayList<WebBusinessObject>();
        Vector<Row> result;
        Vector parameters = new Vector();

        parameters.addElement(new StringValue(userID));
        parameters.addElement(new DateValue(fromDate));
        parameters.addElement(new DateValue(toDate));
        parameters.addElement(new StringValue(userID));
        parameters.addElement(new DateValue(fromDate));
        parameters.addElement(new DateValue(toDate));
        parameters.addElement(new StringValue(userID));
        parameters.addElement(new StringValue(userID));
        StringBuilder where = new StringBuilder(" WHERE STATUS_CODE != 7 ");
        if (interCode != null && !interCode.isEmpty()) {
            where.append(" AND INTER_PHONE LIKE '").append(interCode).append("%'");
        }
        if (sourceID != null && !sourceID.isEmpty()) {
            where.append(" AND SENDER_ID = '").append(sourceID).append("'");
        }

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getComplaintsPerEmployee").replace("whereStatement", where.toString()).trim());
            command.setparams(parameters);
            result = command.executeQuery();

            WebBusinessObject wbo;
            for (Row row : result) {
                wbo = fabricateBusObj(row);
                if (row.getBigDecimal("TOTAL_RESERVATION") != null) {
                    wbo.setAttribute("totalReservation", row.getBigDecimal("TOTAL_RESERVATION") + "");
                }
                if (row.getBigDecimal("TOTAL_CONFIRMED") != null) {
                    wbo.setAttribute("totalConfirmed", row.getBigDecimal("TOTAL_CONFIRMED") + "");
                }
                data.add(wbo);
            }
        } catch (SQLException | UnsupportedTypeException ex) {
            logger.error(ex);
        } catch (NoSuchColumnException | UnsupportedConversionException ex) {
            Logger.getLogger(IssueByComplaintMgr.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error(ex);
            }
        }
        return data;
    }

    public ArrayList<WebBusinessObject> getAllEmployeeComplaints(String userID, String fromDate, String toDate, String currentStatus) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        ArrayList<WebBusinessObject> data = new ArrayList<>();
        Vector<Row> result;
        Vector parameters = new Vector();
        parameters.addElement(new StringValue(userID));
//        parameters.addElement(new StringValue(userID));
        StringBuilder where = new StringBuilder();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
        if(fromDate != null && !fromDate.isEmpty() && toDate != null && !toDate.isEmpty()) {
            try {
                parameters.addElement(new DateValue(new java.sql.Date(sdf.parse(fromDate).getTime())));
                parameters.addElement(new DateValue(new java.sql.Date(sdf.parse(toDate).getTime())));
                where.append(" AND TRUNC(ENTRY_DATE) BETWEEN ? AND ? ");
            } catch (ParseException ex) {
                Logger.getLogger(IssueByComplaintMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        if (currentStatus != null && !currentStatus.isEmpty()) {
            where.append(" AND STATUS_CODE IN ('").append(currentStatus.replaceAll(",", "','")).append("')");
        }
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getAllEmployeeComplaints").trim() + where.toString());
            command.setparams(parameters);
            result = command.executeQuery();
            WebBusinessObject wbo;
            for (Row row : result) {
                wbo = fabricateBusObj(row);
                data.add(wbo);
            }
        } catch (SQLException | UnsupportedTypeException ex) {
            logger.error(ex);
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error(ex);
            }
        }
        return data;
    }

    public ArrayList<WebBusinessObject> getOverallPerformance(Date beginDate, Date endDate, String type, String engineerID, String contractorID, String itemID, String projectID) {
        String theQuery = getQuery("getOverallPerformance").trim().replaceAll("contractorID", contractorID)
                .replaceAll("engineerID", engineerID).replaceAll("itemID", itemID).replaceAll("projectID", projectID);
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        ArrayList<WebBusinessObject> data = new ArrayList<>();
        Vector<Row> result;
        Vector parameters = new Vector();

        parameters.addElement(new DateValue(beginDate));
        parameters.addElement(new DateValue(endDate));
        parameters.addElement(new StringValue(type));

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(theQuery);
            command.setparams(parameters);
            result = command.executeQuery();

            WebBusinessObject wbo;
            for (Row row : result) {
                wbo = new WebBusinessObject();
                try {
                    if (row.getString("ISSUE_STATUS") != null) {
                        wbo.setAttribute("issueStatus", row.getString("ISSUE_STATUS"));
                    }
                    if (row.getBigDecimal("TOTAL_NO") != null) {
                        wbo.setAttribute("totalNo", row.getBigDecimal("TOTAL_NO") + "");
                    }
                } catch (NoSuchColumnException ex) {
                    logger.error(ex);
                } catch (UnsupportedConversionException ex) {
                    Logger.getLogger(IssueByComplaintMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                data.add(wbo);
            }
        } catch (SQLException | UnsupportedTypeException ex) {
            logger.error(ex);
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error(ex);
            }
        }
        return data;
    }

    public List<WebBusinessObject> getAllComplaintsByDateLastCommenterFinance(String creator, Date beginDate, Date endDate, String type, String engineerID, String contractorID, String itemID, String projectID) {
        String theQuery = getQuery("getAllComplaintsByDateLastCommenterFinance").trim().replaceAll("contractorID", contractorID)
                .replaceAll("engineerID", engineerID).replaceAll("itemID", itemID).replaceAll("projectID", projectID);
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        List<WebBusinessObject> data = new ArrayList<WebBusinessObject>();
        Vector<Row> result;
        Vector parameters = new Vector();

        parameters.addElement(new DateValue(beginDate));
        parameters.addElement(new DateValue(endDate));
        parameters.addElement(new StringValue(type));

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(theQuery);
            command.setparams(parameters);
            result = command.executeQuery();

            WebBusinessObject wbo;
            for (Row row : result) {
                wbo = fabricateBusObj(row);
                try {
                    if (row.getString("LAST_COMMENTER_ID") != null) {
                        wbo.setAttribute("lastCommenterID", row.getString("LAST_COMMENTER_ID"));
                    }
                    if (row.getString("ISSUE_STATUS") != null) {
                        wbo.setAttribute("issueStatus", row.getString("ISSUE_STATUS"));
                    }
                    if (row.getString("NAME_OF_PROJECT") != null) {
                        wbo.setAttribute("nameOfProject", row.getString("NAME_OF_PROJECT"));
                    }
                    if (row.getString("ENGINEER_NAME") != null) {
                        wbo.setAttribute("engineerName", row.getString("ENGINEER_NAME"));
                    }
                    if (row.getBigDecimal("NO_COMMENTS") != null) {
                        wbo.setAttribute("comments", row.getBigDecimal("NO_COMMENTS"));
                    }
                } catch (NoSuchColumnException ex) {
                    logger.error(ex);
                } catch (UnsupportedConversionException ex) {
                    Logger.getLogger(IssueByComplaintMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                data.add(wbo);
            }
        } catch (SQLException ex) {
            logger.error(ex);
        } catch (UnsupportedTypeException ex) {
            logger.error(ex);
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex);
            }
        }

        return data;
    }

    public List<WebBusinessObject> getClientRequestsByComments(String customerID) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        List<WebBusinessObject> data = new ArrayList<>();
        Vector<Row> result;
        Vector parameters = new Vector();
        parameters.addElement(new StringValue(customerID));
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getClientRequestsByComments").trim());
            command.setparams(parameters);
            result = command.executeQuery();
            WebBusinessObject wbo;
            for (Row row : result) {
                try {
                    wbo = fabricateBusObj(row);
                    wbo.setAttribute("comments", row.getBigDecimal("NO_COMMENTS"));
                    if (row.getString("STATUS_NOTE") != null) {
                        wbo.setAttribute("statusNote", row.getString("STATUS_NOTE"));
                    }
                    if (row.getString("STATUS_NAME") != null) {
                        wbo.setAttribute("statusName", row.getString("STATUS_NAME"));
                    }
                    data.add(wbo);
                } catch (NoSuchColumnException | UnsupportedConversionException ex) {
                    logger.error(ex);
                }
            }
        } catch (SQLException | UnsupportedTypeException ex) {
            logger.error(ex);
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error(ex);
            }
        }
        return data;
    }

    public List<WebBusinessObject> getAllProcurementRequests(Date beginDate, Date endDate, String type, String itemID) {
        String theQuery = getQuery("getAllProcurementRequests").trim().replaceAll("itemID", itemID);
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        List<WebBusinessObject> data = new ArrayList<>();
        Vector<Row> result;
        Vector parameters = new Vector();

        parameters.addElement(new DateValue(beginDate));
        parameters.addElement(new DateValue(endDate));
        parameters.addElement(new StringValue(type));

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(theQuery);
            command.setparams(parameters);
            result = command.executeQuery();

            WebBusinessObject wbo;
            for (Row row : result) {
                wbo = fabricateBusObj(row);
                try {
                    if (row.getString("ISSUE_STATUS") != null) {
                        wbo.setAttribute("issueStatus", row.getString("ISSUE_STATUS"));
                    }
                    if (row.getString("REQUEST_TYPE") != null) {
                        wbo.setAttribute("requestType", row.getString("REQUEST_TYPE"));
                    }
                    if (row.getString("REQUEST_CODE") != null) {
                        wbo.setAttribute("requestCode", row.getString("REQUEST_CODE"));
                    }
                } catch (NoSuchColumnException ex) {
                    logger.error(ex);
                }
                data.add(wbo);
            }
        } catch (SQLException | UnsupportedTypeException ex) {
            logger.error(ex);
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex);
            }
        }

        return data;
    }

    public ArrayList<WebBusinessObject> getEmpClientsAppntms(String beginDate, String endDate,String departmentID, String userID) {
        ArrayList<WebBusinessObject> data = new ArrayList<>();
        Connection connection = null;

        Vector parameters = new Vector();

        parameters.addElement(new StringValue(beginDate));
        parameters.addElement(new StringValue(endDate));
        parameters.addElement(new StringValue(beginDate));
        parameters.addElement(new StringValue(endDate));
        parameters.addElement(new StringValue(userID));
        parameters.addElement(new StringValue(userID));
        
        Vector<Row> queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getAppointmentsPerEmp").trim());
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
                    if (r.getString("full_name") != null) {
                        wbo.setAttribute("userName", r.getString("full_name"));
                    }

                    if (r.getBigDecimal("call") != null) {
                        wbo.setAttribute("call", r.getBigDecimal("call"));
                    } else {
                        wbo.setAttribute("call", "0");
                    }

                    if (r.getBigDecimal("call_duration") != null) {
                        wbo.setAttribute("call_duration", r.getBigDecimal("call_duration"));
                    } else {
                        wbo.setAttribute("call_duration", "0");
                    }

                    if (r.getBigDecimal("meeting") != null) {
                        wbo.setAttribute("meeting", r.getBigDecimal("meeting"));
                    } else {
                        wbo.setAttribute("meeting", "0");
                    }

                    if (r.getBigDecimal("meeting_duration") != null) {
                        wbo.setAttribute("meeting_duration", r.getBigDecimal("meeting_duration"));
                    } else {
                        wbo.setAttribute("meeting_duration", "0");
                    }

                    if (r.getBigDecimal("not_answred") != null) {
                        wbo.setAttribute("not_answred", r.getBigDecimal("not_answred"));
                    } else {
                        wbo.setAttribute("not_answred", "0");
                    }

                    if (r.getBigDecimal("total_client") != null) {
                        wbo.setAttribute("total_client", r.getBigDecimal("total_client"));
                    } else {
                        wbo.setAttribute("total_client", "0");
                    }
                    
                    if (r.getString("TYPE_TAG") != null || r.getString("TYPE_TAG").equals("UL")) {
                        wbo.setAttribute("TYPE_TAG", r.getString("TYPE_TAG"));
                    } else 
                    {
                        wbo.setAttribute("TYPE_TAG", "---");
                    }
                    
                    if (r.getString("TYPE_TAG") != null || r.getString("TYPE_TAG").equals("UL")) {
                        WebBusinessObject projectWbo = ProjectMgr.getInstance().getOnSingleKey("key1", r.getString("TYPE_TAG"));
                        wbo.setAttribute("Tag_Color",projectWbo.getAttribute("optionOne").toString());
                    } else 
                    {
                        wbo.setAttribute("Tag_Color", "white");
                    }
                    
                    if (r.getString("current_owner_id") != null) {
                        wbo.setAttribute("userID", r.getString("current_owner_id"));
                    }                
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(IssueByComplaintMgr.class.getName()).log(Level.SEVERE, null, ex);
                } catch (UnsupportedConversionException ex) {
                    Logger.getLogger(IssueByComplaintMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                data.add(wbo);
            }
        }
        return data;
    }

    public ArrayList<WebBusinessObject> getDeptEmpsTagType(String startDate, String endDate, String dept_id, ArrayList TypeTagNames) {
        WebBusinessObject wbo;
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();

        params.addElement(new StringValue(startDate));
        params.addElement(new StringValue(endDate));
        params.addElement(new StringValue(startDate));
        params.addElement(new StringValue(endDate));
        params.addElement(new StringValue(dept_id));

        try {
            StringBuilder CountTypeTag = new StringBuilder();

            for (int i = 0; i < TypeTagNames.size(); i++) {
                CountTypeTag.append(" , count(case when TYPE_TAG = '" + TypeTagNames.get(i) + "' THEN CUSTOMER_ID END) as " + TypeTagNames.get(i).toString().replaceAll("\\s", ""));
            }

            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            String sql = getQuery("getAppntsTagPerDept");
            sql = sql.replaceFirst("CountTypeTag", CountTypeTag.toString()).trim();
            forQuery.setSQLQuery(sql);
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        ArrayList<WebBusinessObject> resultBusObjs = new ArrayList<WebBusinessObject>();
        Row r = null;
        Enumeration e = queryResult.elements();
        try {
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = new WebBusinessObject();

                if (r.getString("current_owner_id") != null) {
                    wbo.setAttribute("userID", r.getString("current_owner_id"));
                }

                if (r.getString("full_name") != null) {
                    wbo.setAttribute("userName", r.getString("full_name"));
                }

                for (int i = 0; i < TypeTagNames.size(); i++) {
                    if (r.getBigDecimal(TypeTagNames.get(i).toString().replaceAll("\\s", "")) != null) {
                        wbo.setAttribute(TypeTagNames.get(i).toString().replaceAll("\\s", ""), r.getBigDecimal(TypeTagNames.get(i).toString().replaceAll("\\s", "")));
                    }
                }

                resultBusObjs.add(wbo);
            }
        } catch (NoSuchColumnException ce) {
            logger.error(ce);
        } catch (Exception ex) {
            logger.error(ex);
        }
        return resultBusObjs;
    }
    
    public ArrayList<ArrayList<String>> getEmpClientsData(String userID, String departmentID, String beginDate, String endDate, String type) {
        Connection connection = null;

        Vector parameters = new Vector();
        parameters.addElement(new StringValue(userID));
        parameters.addElement(new StringValue(beginDate));
        parameters.addElement(new StringValue(endDate));
        parameters.addElement(new StringValue(userID));
        parameters.addElement(new StringValue(beginDate));
        parameters.addElement(new StringValue(endDate));
        parameters.addElement(new StringValue(beginDate));
        parameters.addElement(new StringValue(endDate));
        //parameters.addElement(new StringValue(departmentID));
        parameters.addElement(new StringValue(userID));
        parameters.addElement(new StringValue(type));

        Vector<Row> queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getAppointmentsPerEmpDetails").trim());
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

        ArrayList<ArrayList<String>> data = new ArrayList<>();
        for (Row row : queryResult) {
            try {
                ArrayList<String> wbo = new ArrayList<>();

                if (row.getString("customer_name") != null) {
                    wbo.add(row.getString("customer_name"));
                } else {
                    wbo.add("---");
                }

                if (row.getBigDecimal("call") != null) {
                    wbo.add(row.getBigDecimal("call").toString());
                } else {
                    wbo.add("0");
                }

                if (row.getBigDecimal("call_duration") != null) {
                    wbo.add(row.getBigDecimal("call_duration").toString());
                } else {
                    wbo.add("0");
                }

                if (row.getBigDecimal("meeting") != null) {
                    wbo.add(row.getBigDecimal("meeting").toString());
                } else {
                    wbo.add("0");
                }

                if (row.getBigDecimal("meeting_duration") != null) {
                    wbo.add(row.getBigDecimal("meeting_duration").toString());
                } else {
                    wbo.add("0");
                }

                if (row.getBigDecimal("not_answred") != null) {
                    wbo.add(row.getBigDecimal("not_answred").toString());
                } else {
                    wbo.add("0");
                }

                if (row.getString("CUSTOMER_ID") != null) {
                    wbo.add(row.getString("CUSTOMER_ID"));
                } else {
                    wbo.add("---");
                }
                data.add(wbo);
            } catch (Exception ex) {
                logger.error(ex);
            }
        }
        return data;
    }

    public ArrayList<WebBusinessObject> getEmpTagType(String startDate, String endDate, String user_id, String dept_id) {
        WebBusinessObject wbo;
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();

        params.addElement(new StringValue(startDate));
        params.addElement(new StringValue(endDate));
        params.addElement(new StringValue(startDate));
        params.addElement(new StringValue(endDate));
        params.addElement(new StringValue(startDate));
        params.addElement(new StringValue(endDate));
        params.addElement(new StringValue(dept_id));
        params.addElement(new StringValue(user_id));

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            StringBuilder sql = new StringBuilder(getQuery("getAppntsTagPerEmp").trim());
            forQuery.setSQLQuery(sql.toString());
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        ArrayList<WebBusinessObject> resultBusObjs = new ArrayList<WebBusinessObject>();
        Row r = null;
        Enumeration e = queryResult.elements();
        try {
            while (e.hasMoreElements()) {
                    r = (Row) e.nextElement();
                    wbo = new WebBusinessObject();
                    if (r.getString("current_owner_id") != null) {
                        wbo.setAttribute("userID", r.getString("current_owner_id"));
                    }
                    if (r.getString("full_name") != null) {
                        wbo.setAttribute("userName", r.getString("full_name"));
                    }
                    if (r.getBigDecimal("Inbound") != null) {
                        wbo.setAttribute("Inbound", r.getBigDecimal("Inbound"));
                    }
                    if (r.getBigDecimal("Visit") != null) {
                        wbo.setAttribute("Visit", r.getBigDecimal("Visit"));
                    }
                    if (r.getBigDecimal("Outbound") != null) {
                        wbo.setAttribute("Outbound", r.getBigDecimal("Outbound"));
                    }
                    if (r.getBigDecimal("Recycle_Data") != null) {
                        wbo.setAttribute("Recycle_Data", r.getBigDecimal("Recycle_Data"));
                    }
                    resultBusObjs.add(wbo);
                }
									   
        } catch (NoSuchColumnException ce) {
            logger.error(ce);
        } catch (Exception ex) {
            logger.error(ex);
        }
        return resultBusObjs;
    }
    
    public ArrayList<WebBusinessObject> getEmpCallsByDist(String startDate, String endDate, String user_id, String Type_Tag) {
        WebBusinessObject wbo;
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();

        params.addElement(new StringValue(user_id));
        params.addElement(new StringValue(startDate));
        params.addElement(new StringValue(endDate));
        params.addElement(new StringValue(user_id));
        params.addElement(new StringValue(startDate));
        params.addElement(new StringValue(endDate));
        params.addElement(new StringValue(startDate));
        params.addElement(new StringValue(endDate));
        params.addElement(new StringValue(user_id));
        params.addElement(new StringValue(Type_Tag));

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            StringBuilder sql = new StringBuilder(getQuery("getEmpDistCalls").trim());
            forQuery.setSQLQuery(sql.toString());
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        ArrayList<WebBusinessObject> resultBusObjs = new ArrayList<WebBusinessObject>();
        Row r = null;
        Enumeration e = queryResult.elements();
        try {
            while (e.hasMoreElements()) {
                    r = (Row) e.nextElement();
                    wbo = new WebBusinessObject();
                    
                    if (r.getBigDecimal("ANSWERED") != null) {
                        wbo.setAttribute("ANSWERED", r.getBigDecimal("ANSWERED"));
                    }
                    if (r.getBigDecimal("NOT_ANSWERED") != null) {
                        wbo.setAttribute("NOT_ANSWERED", r.getBigDecimal("NOT_ANSWERED"));
                    }
                    if (r.getBigDecimal("PLANED_CALLS") != null) {
                        wbo.setAttribute("PLANED_CALLS", r.getBigDecimal("PLANED_CALLS"));
                    }
                    
                    resultBusObjs.add(wbo);
                }
									   
        } catch (NoSuchColumnException ce) {
            logger.error(ce);
        } catch (Exception ex) {
            logger.error(ex);
        }
        return resultBusObjs;
    }

    public ArrayList<WebBusinessObject> getEmpCallsByDistDetail (String startDate, String endDate, String user_id, String Type_Tag, String option9) {
        ArrayList<WebBusinessObject> data = new ArrayList<>();
        Connection connection = null;

        Vector params = new Vector();
        params.addElement(new StringValue(user_id));
        params.addElement(new StringValue(startDate));
        params.addElement(new StringValue(endDate));
        params.addElement(new StringValue(user_id));
        params.addElement(new StringValue(startDate));
        params.addElement(new StringValue(endDate));
        params.addElement(new StringValue(startDate));
        params.addElement(new StringValue(endDate));
        params.addElement(new StringValue(user_id));
        params.addElement(new StringValue(Type_Tag));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            
            StringBuilder option9Cond;
            
            forQuery.setConnection(connection);
            if (option9.equals("Answred")) {
                 option9Cond = new StringBuilder(" and OPTION9 IN ('answered') ");
            } else if (option9.equals("NotAnswered")) {
                option9Cond = new StringBuilder(" and OPTION9 IN ('wrong number','not answered') ");
            } else {
                option9Cond = new StringBuilder(" and (OPTION9 is null or OPTION9 = 'UL') ");
            }

            forQuery.setSQLQuery(getQuery("getEmpDistCallsDetails").trim().replace("Option9Cond", option9Cond.toString()));
            forQuery.setparams(params);
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
                    if (r.getString("NAME") != null) {
                        wbo.setAttribute("Client_NAME", r.getString("NAME"));
                    } else {
                        wbo.setAttribute("Client_NAME", "---");
                    }

                    if (r.getString("APPOINTMENT_DATE") != null) {
                        wbo.setAttribute("AppointmentDate", r.getString("APPOINTMENT_DATE"));
                    } else {
                        wbo.setAttribute("AppointmentDate", "---");
                    }

                    if (r.getString("COMMENT") != null) {
                        wbo.setAttribute("comment", r.getString("COMMENT"));
                    } else {
                        wbo.setAttribute("comment", "---");
                    }

                    if (r.getString("CALL_DURATION") != null) {
                        wbo.setAttribute("callDuration", r.getString("CALL_DURATION"));
                    } else {
                        wbo.setAttribute("callDuration", "---");
                    }

                    if (r.getString("NOTE") != null) {
                        wbo.setAttribute("callRes", r.getString("NOTE"));
                    } else {
                        wbo.setAttribute("callRes", "---");
                    }

                    if (r.getString("CLIENT_ID") != null) {
                        wbo.setAttribute("CLIENT_ID", r.getString("CLIENT_ID"));
                    } else {
                        wbo.setAttribute("CLIENT_ID", "---");
                    }
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(IssueByComplaintMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                data.add(wbo);
            }
        }
        return data;
    }
    
    public ArrayList<WebBusinessObject> getEmpMeetingByDist(String startDate, String endDate, String user_id, String Type_Tag) {
        WebBusinessObject wbo;
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();

        params.addElement(new StringValue(user_id));
        params.addElement(new StringValue(startDate));
        params.addElement(new StringValue(endDate));
        params.addElement(new StringValue(user_id));
        params.addElement(new StringValue(startDate));
        params.addElement(new StringValue(endDate));
        params.addElement(new StringValue(startDate));
        params.addElement(new StringValue(endDate));
        params.addElement(new StringValue(user_id));
        params.addElement(new StringValue(Type_Tag));

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            StringBuilder sql = new StringBuilder(getQuery("getEmpDistMeeting").trim());
            forQuery.setSQLQuery(sql.toString());
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        ArrayList<WebBusinessObject> resultBusObjs = new ArrayList<WebBusinessObject>();
        Row r = null;
        Enumeration e = queryResult.elements();
        try {
            while (e.hasMoreElements()) {
                    r = (Row) e.nextElement();
                    wbo = new WebBusinessObject();
                    
                    if (r.getBigDecimal("Sccuess") != null) {
                        wbo.setAttribute("Sccuess", r.getBigDecimal("Sccuess"));
                    }
                    if (r.getBigDecimal("Fail") != null) {
                        wbo.setAttribute("Fail", r.getBigDecimal("Fail"));
                    }

                    resultBusObjs.add(wbo);
                }
									   
        } catch (NoSuchColumnException ce) {
            logger.error(ce);
        } catch (Exception ex) {
            logger.error(ex);
        }
        return resultBusObjs;
    }
    
    public ArrayList<WebBusinessObject> getEmpMeetingByDistDetail (String startDate, String endDate, String user_id, String Type_Tag, String currentStatus) {
        ArrayList<WebBusinessObject> data = new ArrayList<>();
        Connection connection = null;

        Vector params = new Vector();
        params.addElement(new StringValue(user_id));
        params.addElement(new StringValue(startDate));
        params.addElement(new StringValue(endDate));
        params.addElement(new StringValue(user_id));
        params.addElement(new StringValue(startDate));
        params.addElement(new StringValue(endDate));
        params.addElement(new StringValue(startDate));
        params.addElement(new StringValue(endDate));
        params.addElement(new StringValue(user_id));
        params.addElement(new StringValue(Type_Tag));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            
            StringBuilder current_status;
            
            forQuery.setConnection(connection);
            if (currentStatus.equals("26")) {
                 current_status = new StringBuilder(" and current_status = '26' ");
            } else {
                current_status = new StringBuilder(" and current_status IN('23','24','25','27') ");
            }

            forQuery.setSQLQuery(getQuery("getEmpDistMeetingDetails").trim().replace("currentStatusCond", current_status.toString()));
            forQuery.setparams(params);
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
                    if (r.getString("NAME") != null) {
                        wbo.setAttribute("Client_NAME", r.getString("NAME"));
                    } else {
                        wbo.setAttribute("Client_NAME", "---");
                    }

                    if (r.getString("APPOINTMENT_DATE") != null) {
                        wbo.setAttribute("AppointmentDate", r.getString("APPOINTMENT_DATE"));
                    } else {
                        wbo.setAttribute("AppointmentDate", "---");
                    }

                    if (r.getString("COMMENT") != null) {
                        wbo.setAttribute("comment", r.getString("COMMENT"));
                    } else {
                        wbo.setAttribute("comment", "---");
                    }

                    if (r.getString("CALL_DURATION") != null) {
                        wbo.setAttribute("callDuration", r.getString("CALL_DURATION"));
                    } else {
                        wbo.setAttribute("callDuration", "---");
                    }

                    if (r.getString("NOTE") != null) {
                        wbo.setAttribute("callRes", r.getString("NOTE"));
                    } else {
                        wbo.setAttribute("callRes", "---");
                    }
                    
                    if (r.getString("current_status") != null) {
                        wbo.setAttribute("current_status", r.getString("current_status"));
                    } else {
                        wbo.setAttribute("current_status", "---");
                    }

                    if (r.getString("CLIENT_ID") != null) {
                        wbo.setAttribute("CLIENT_ID", r.getString("CLIENT_ID"));
                    } else {
                        wbo.setAttribute("CLIENT_ID", "---");
                    }
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(IssueByComplaintMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                data.add(wbo);
            }
        }
        return data;
    }
    
    public ArrayList<WebBusinessObject> srchJobOrderByBusId(String bussId) {

        Vector queryResult = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        Vector params = new Vector();
        Connection connection = null;
        forUpdate.setSQLQuery(getQuery("srchJobOrderByBusId").trim());
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

        ArrayList<WebBusinessObject> resultBusObjs = new ArrayList<WebBusinessObject>();
        WebBusinessObject wbo;
        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            try {
                if (r.getString("URGENCY_ID") != null) {
                    wbo.setAttribute("clientID", r.getString("URGENCY_ID"));
                } else {
                    wbo.setAttribute("clientID", "---");
                }
                
                if (r.getString("ID") != null) {
                    wbo.setAttribute("compID", r.getString("ID"));
                } else {
                    wbo.setAttribute("compID", "---");
                }
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(IssueByComplaintMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }
}
