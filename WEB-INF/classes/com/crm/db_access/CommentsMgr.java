package com.crm.db_access;

import com.tracker.db_access.IssueMgr;
import com.clients.db_access.AppointmentMgr;
import com.crm.common.CRMConstants;
import com.maintenance.common.DateParser;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import com.silkworm.common.UserMgr;
import java.sql.SQLException;
import java.util.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.sql.Connection;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.logging.Level;
import java.util.logging.Logger;

public class CommentsMgr extends RDBGateWay {

    private static final CommentsMgr COMMENTS_MGR = new CommentsMgr();

    @Override
    protected void initSupportedForm() {
        if (supportedForm == null) {
            try {
                System.out.println("UserClientsMgr ..***********.trying to get the XML file from path:: " + webInfPath);
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("comments.xml")));
            } catch (Exception e) {
                System.out.println("Could not locate XML Document");
            }
        }
    }

    public static CommentsMgr getInstance() {
        System.out.println("Getting UserMgr Instance ....");
        return COMMENTS_MGR;
    }

    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public boolean saveComment(HttpServletRequest request, WebBusinessObject persistentUser) throws NoUserInSessionException, SQLException {
        String createdBy = (String) persistentUser.getAttribute("userId");
        String clientComplaintId = request.getParameter("clientId");
        String commentType = request.getParameter("type");
        String comment = request.getParameter("comment");
        String objectType = request.getParameter("businessObjectType");
        String option1 = request.getParameter("option1") != null ? request.getParameter("option1") : "UL";
        String option2 = request.getParameter("option2") != null ? request.getParameter("option2") : "UL";

        return saveComment(clientComplaintId, createdBy, commentType, objectType, comment, option1, option2);
    }

    public boolean saveComment(WebBusinessObject wbo) throws NoUserInSessionException, SQLException {
        String createdBy = (String) wbo.getAttribute("createdBy");
        String clientComplaintId = (String) wbo.getAttribute("objectId");
        String commentType = (String) wbo.getAttribute("commentType");
        String comment = (String) wbo.getAttribute("comment");
        String objectType = (String) wbo.getAttribute("objectType");
        String option1 = (String) wbo.getAttribute("option1");

        return saveComment(clientComplaintId, createdBy, commentType, objectType, comment, option1, "UL");
    }

    public boolean saveComment(WebBusinessObject wbo, WebBusinessObject persistentUser) throws NoUserInSessionException, SQLException {
        String createdBy = (String) persistentUser.getAttribute("userId");
        String clientComplaintId = (String) wbo.getAttribute("clientComplaintId");
        String commentType = (String) wbo.getAttribute("commentType");
        String comment = (String) wbo.getAttribute("comment");
        String objectType = (String) wbo.getAttribute("objectType");

        return saveComment(clientComplaintId, createdBy, commentType, objectType, comment, "UL", "UL");
    }

    public boolean saveCommentByIssueQA(WebBusinessObject wbo, WebBusinessObject persistentUser) throws NoUserInSessionException, SQLException {
        String createdBy = (String) persistentUser.getAttribute("userId");
        String clientComplaintId = (String) wbo.getAttribute("issueId");
        String commentType = "10";
        String comment = (String) wbo.getAttribute("comment");
        String objectType = "10";

        return saveComment(clientComplaintId, createdBy, commentType, objectType, comment, "UL", "UL");
    }

    public synchronized boolean saveComment(String clientComplaintId, String createdBy, String commentType, String objectType, String comment, String option1, String option2) throws NoUserInSessionException, SQLException {
        Vector parameters = new Vector();

        String id = UniqueIDGen.getNextID();
        parameters.addElement(new StringValue(id));
        parameters.addElement(new StringValue(clientComplaintId));
        parameters.addElement(new StringValue(createdBy));
        parameters.addElement(new StringValue(commentType));
        parameters.addElement(new StringValue("UL"));
        parameters.addElement(new StringValue(objectType));
        parameters.addElement(new StringValue(option1));
        parameters.addElement(new StringValue(option2));
        parameters.addElement(new StringValue(comment));
        parameters.addElement(new StringValue(createdBy));
        if (CRMConstants.COMMENT_TYPE_ID_GENERAL.equalsIgnoreCase(commentType)) {
            parameters.addElement(new StringValue(CRMConstants.COMMENT_TYPE_ID_GENERAL_VALUE));
        } else if (CRMConstants.COMMENT_TYPE_ID_SPECIAL.equalsIgnoreCase(commentType)) {
            parameters.addElement(new StringValue(createdBy));
        } else {
            parameters.addElement(new StringValue("UL"));
        }

        Connection connection = null;
        int queryResult = -1000;
        try {
            SQLCommandBean forInsert = new SQLCommandBean();
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(getQuery("insertComment").trim());
            forInsert.setparams(parameters);
            queryResult = forInsert.executeUpdate();
            if (queryResult < 0) {
                connection.rollback();
                return false;
            }
            try {
                Thread.sleep(500);
            } catch (InterruptedException ex) {
                logger.error(ex.getMessage());
            }

            // add alert type from attach file
            boolean saved = AlertMgr.getInstance().saveObject(clientComplaintId, CRMConstants.ALERT_TYPE_ID_ADD_COMMENT, createdBy, connection);
            if (!saved) {
                connection.rollback();
                return false;
            }
            try {
                Thread.sleep(500);
            } catch (InterruptedException ex) {
                logger.error(ex.getMessage());
            }

        } catch (Exception ex) {
            logger.error(ex.getMessage());
            connection.rollback();
            return false;
        } finally {
            connection.commit();
            connection.close();
        }

        return (queryResult > 0);
    }

    public synchronized boolean saveCommentAndUpdateIssue(WebBusinessObject wbo, WebBusinessObject persistentUser) throws NoUserInSessionException {      
        Vector parameters = new Vector();

        String id = UniqueIDGen.getNextID();
        parameters.addElement(new StringValue(id));
        parameters.addElement(new StringValue((String) wbo.getAttribute("objectId")));
        parameters.addElement(new StringValue((String) persistentUser.getAttribute("userId")));
        parameters.addElement(new StringValue("10"));
        parameters.addElement(new StringValue("UL"));
        parameters.addElement(new StringValue("issue"));
        parameters.addElement(new StringValue("10")); // option 1
        parameters.addElement(new StringValue("UL")); // option 2
        parameters.addElement(new StringValue((String) wbo.getAttribute("comment")));
        parameters.addElement(new StringValue((String) persistentUser.getAttribute("userId")));
        parameters.addElement(new StringValue("UL"));

        Connection connection = null;
        int queryResult = -1000;

        try {
            beginTransaction();
            SQLCommandBean forInsert = new SQLCommandBean();
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(getQuery("insertComment").trim());
            forInsert.setparams(parameters);
            queryResult = forInsert.executeUpdate();
            if (queryResult < 0) {
                connection.rollback();
                return false;
            }

            try {
                Thread.sleep(500);
            } catch (InterruptedException ex) {
                logger.error(ex.getMessage());
            }

            boolean saved = IssueMgr.getInstance().updateCurrentStatus((String) wbo.getAttribute("objectId"), (String) wbo.getAttribute("status"));
            if (!saved) {
                connection.rollback();
                return false;
            }
            
            endTransaction();
        } catch (Exception ex) {
            logger.error(ex.getMessage());
            return false;
        } finally {
            try {
                connection.commit();
                connection.close();
            } catch (Exception ex) {
                logger.error("Close Connection Error");
                return false;
            }
        }

        return (queryResult > 0);
    }

    public boolean saveChannelsComment(String clientComplaintId, String createdBy, String objectType, String comment, String... destinationsIds) throws SQLException {
        Vector parameters;

        Connection connection = null;
        int queryResult = -1000;
        try {
            SQLCommandBean forInsert = new SQLCommandBean();
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(getQuery("insertComment").trim());

            for (String destinationId : destinationsIds) {
                parameters = new Vector();

                String id = UniqueIDGen.getNextID();
                parameters.addElement(new StringValue(id));
                parameters.addElement(new StringValue(clientComplaintId));
                parameters.addElement(new StringValue(createdBy));
                parameters.addElement(new StringValue(CRMConstants.COMMENT_TYPE_ID_CHANNELS));
                parameters.addElement(new StringValue("UL"));
                parameters.addElement(new StringValue(objectType));
                parameters.addElement(new StringValue("UL"));
                parameters.addElement(new StringValue("UL"));
                parameters.addElement(new StringValue(comment));
                parameters.addElement(new StringValue(createdBy));
                parameters.addElement(new StringValue(destinationId));

                forInsert.setparams(parameters);
                queryResult = forInsert.executeUpdate();
                if (queryResult < 0) {
                    connection.rollback();
                    return false;
                }
                try {
                    Thread.sleep(50);
                } catch (InterruptedException ex) {
                    logger.error(ex.getMessage());
                }

                // add alert type from attach file
                boolean saved = AlertMgr.getInstance().saveObject(clientComplaintId, CRMConstants.ALERT_TYPE_ID_ADD_COMMENT, createdBy, connection);
                if (!saved) {
                    connection.rollback();
                    return false;
                }
                try {
                    Thread.sleep(200);
                } catch (InterruptedException ex) {
                    logger.error(ex.getMessage());
                }
            }
        } catch (Exception ex) {
            logger.error(ex.getMessage());
            connection.rollback();
            return false;
        } finally {
            connection.commit();
            connection.close();
        }

        return (queryResult > 0);
    }

    public boolean deteleComment(String id) throws SQLException {
        Connection connection = null;
        try {
            int queryResult;
            Vector params = new Vector();
            SQLCommandBean forInsert = new SQLCommandBean();
            connection = dataSource.getConnection();

            params.addElement(new StringValue(id));
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(getQuery("deleteComment").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            return queryResult > 0;
        } catch (SQLException ex) {
            Logger.getLogger(AppointmentMgr.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        } finally {
            connection.setAutoCommit(true);
            connection.close();

        }
    }

    public boolean updateComment(HttpServletRequest request, WebBusinessObject persistentUser) throws SQLException {
        String userId = (String) persistentUser.getAttribute("userId");
        Connection connection = null;
        String comment = request.getParameter("comment");
        String id = request.getParameter("commentId");
        try {

            int queryResult;
            Vector params = new Vector();
            SQLCommandBean forInsert = new SQLCommandBean();
            connection = dataSource.getConnection();

            params.addElement(new StringValue(comment));

            params.addElement(new StringValue(userId));
            params.addElement(new StringValue(id));
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(getQuery("updateComment").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            return queryResult > 0;
        } catch (SQLException ex) {
            logger.error(ex);
            return false;
        } finally {
            connection.setAutoCommit(true);
            connection.close();
        }
    }

    public Vector<WebBusinessObject> getComments(String objectId, String userId) {

        Vector<WebBusinessObject> data = new Vector<WebBusinessObject>();
        Connection connection = null;
        Vector parameters = new Vector();

        parameters.addElement(new StringValue(objectId));
        parameters.addElement(new StringValue(userId));
        parameters.addElement(new StringValue(userId));
        parameters.addElement(new StringValue(userId));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getComments").trim());
            forQuery.setparams(parameters);

            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }

        // process the vector
        // vector of business objects
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            data.addElement(fabricateBusObj((Row) e.nextElement()));
        }

        return data;
    }

    public Vector getIssuesComments(String period) {

        Vector data = new Vector();
        Connection connection = null;
        Vector parameters = new Vector();

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        parameters.addElement(new StringValue(period));

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getIssueComments").trim());
            forQuery.setparams(parameters);
            queryResult = forQuery.executeQuery();

            // process the vector
            // vector of business objects
            Enumeration e = queryResult.elements();

            while (e.hasMoreElements()) {
                Row row = (Row) e.nextElement();
                data.addElement(row.getString("busniess_object_id"));
            }
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } catch (Exception ex) {
            logger.error(ex.getMessage());
            return null;
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }

        return data;
    }

    public List<WebBusinessObject> getCommentsByObjectId(String objectId) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> result = null;
        Vector parameters = new Vector();
        List<WebBusinessObject> data = new ArrayList<WebBusinessObject>();

        parameters.addElement(new StringValue(objectId));
        parameters.addElement(new StringValue(objectId));

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getCommentsByObjectId").trim());
            command.setparams(parameters);

            result = command.executeQuery();
            WebBusinessObject wbo;
            SimpleDateFormat sdf = new SimpleDateFormat("yyy-MM-dd HH:mm:ss");
            SimpleDateFormat sdfFull = new SimpleDateFormat("EEE, MMMM yyyy HH:mm");
            for (Row row : result) {
                wbo = fabricateBusObj(row);
                if (row.getString("CREATED_BY_NAME") != null) {
                    wbo.setAttribute("createdByName", row.getString("CREATED_BY_NAME"));
                }
                if (row.getString("CREATION_TIME") != null) {
                    try {
                        wbo.setAttribute("creationTime", sdfFull.format(sdf.parse(row.getString("CREATION_TIME"))));
                    } catch (ParseException ex) {
                        wbo.setAttribute("creationTime", row.getString("CREATION_TIME"));
                    }
                } else {
                    wbo.setAttribute("creationTime", "");
                }
                data.add(wbo);
            }
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } catch (NoSuchColumnException ex) {
            Logger.getLogger(CommentsMgr.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }

        return data;
    }

    public List<WebBusinessObject> getCommentsByObjectId(String objectId, String clientComplaintType) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> result = null;
        Vector parameters = new Vector();
        List<WebBusinessObject> data = new ArrayList<WebBusinessObject>();

        parameters.addElement(new StringValue(objectId));
        parameters.addElement(new StringValue(clientComplaintType));

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getCommentsByObjectIdAndOption1").trim());
            command.setparams(parameters);

            result = command.executeQuery();
            for (Row row : result) {
                data.add(fabricateBusObj(row));
            }
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }

        return data;
    }

    public Vector<WebBusinessObject> getCommentsByClientID(String clientID) {

        Vector<WebBusinessObject> data = new Vector<WebBusinessObject>();
        WebBusinessObject wbo;
        Connection connection = null;
        Vector parameters = new Vector();

        parameters.addElement(new StringValue(clientID));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getCommentsByClientID").trim());
            forQuery.setparams(parameters);

            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }

        // process the vector
        // vector of business objects
        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            try {
                wbo.setAttribute("comment", r.getString("COMMENT_DESC"));
                wbo.setAttribute("userName", r.getString("FULL_NAME"));
                wbo.setAttribute("commentDate", r.getString("CREATION_TIME"));
                data.add(wbo);
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(CommentsMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
//            data.addElement(fabricateBusObj((Row) e.nextElement()));
        }

        return data;
    }

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
    }

    @Override
    public ArrayList getCashedTableAsArrayList() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public List<WebBusinessObject> getCommentsProductions(String groupId, String begin, String end) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> rows;
        Vector parameters = new Vector();
        WebBusinessObject wbo;

        parameters.addElement(new StringValue(groupId));
        parameters.addElement(new StringValue(begin));
        parameters.addElement(new StringValue(end));
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getCommentsProductions").trim());
            command.setparams(parameters);
            rows = command.executeQuery();

            List<WebBusinessObject> results = new ArrayList<>();
            for (Row row : rows) {
                try {
                    wbo = new WebBusinessObject();
                    wbo.setAttribute("fullName", row.getString("FULL_NAME"));
                    wbo.setAttribute("noTicket", String.valueOf(row.getBigDecimal("TOTAL")));
                    results.add(wbo);
                } catch (NoSuchColumnException ex) {
                    logger.error("SQL Exception  " + ex.getMessage());
                } catch (UnsupportedConversionException ex) {
                    logger.error("SQL Exception  " + ex.getMessage());
                }
            }
            return results;
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

        return new ArrayList<>();
    }

    public List<WebBusinessObject> getCommentssByUser(String userId, String date) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> rows;
        Vector parameters = new Vector();
        WebBusinessObject wbo;

        parameters.addElement(new StringValue(userId));
        parameters.addElement(new StringValue(date));
        parameters.addElement(new StringValue(date));
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getCommentssByUser").trim());
            command.setparams(parameters);
            rows = command.executeQuery();

            List<WebBusinessObject> results = new ArrayList<>();
            for (Row row : rows) {
                try {
                    wbo = new WebBusinessObject();
                    if (row.getBigDecimal("TOTAL") != null) {
                        wbo.setAttribute("total", row.getBigDecimal("TOTAL"));
                    }
                    if (row.getString("START_DATE") != null) {
                        wbo.setAttribute("startDate", row.getString("START_DATE").split(" ")[0]);
                    }
                    if (row.getString("END_DATE") != null) {
                        wbo.setAttribute("endDate", row.getString("END_DATE").split(" ")[0]);
                    }
                    results.add(wbo);
                } catch (NoSuchColumnException ex) {
                    logger.error("SQL Exception  " + ex.getMessage());
                } catch (UnsupportedConversionException ex) {
                    logger.error("SQL Exception  " + ex.getMessage());
                }
            }
            return results;
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

        return new ArrayList<>();
    }

    public ArrayList<WebBusinessObject> getEmployeeComments(String userId, java.sql.Date fromDate, java.sql.Date toDate, String reportType) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> rows;
        Vector parameters = new Vector();
        WebBusinessObject wbo;

        parameters.addElement(new StringValue(userId));
        parameters.addElement(new DateValue(fromDate));
        parameters.addElement(new DateValue(toDate));
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            if (("complaint").equalsIgnoreCase(reportType)) {
                command.setSQLQuery(getQuery("getEmployeeComplaintComments").trim());
            } else {
                command.setSQLQuery(getQuery("getEmployeeComments").trim());
            }
            command.setparams(parameters);
            rows = command.executeQuery();

            ArrayList<WebBusinessObject> results = new ArrayList<>();
            for (Row row : rows) {
                try {
                    wbo = fabricateBusObj(row);
                    if (row.getString("CLIENT_NO") != null) {
                        wbo.setAttribute("clientNo", row.getString("CLIENT_NO"));
                    }
                    if (row.getString("CLIENT_NAME") != null) {
                        wbo.setAttribute("clientName", row.getString("CLIENT_NAME"));
                    }
                    if (("complaint").equalsIgnoreCase(reportType)) {
                        if (row.getString("BUSINESS_ID") != null) {
                            wbo.setAttribute("businessID", row.getString("BUSINESS_ID"));
                        }
                        if (row.getString("BUSINESS_ID_BY_DATE") != null) {
                            wbo.setAttribute("businessIDByDate", row.getString("BUSINESS_ID_BY_DATE"));
                        }
                        if (row.getString("CLIENT_COMPLAINT_ID") != null) {
                            wbo.setAttribute("clientComplaintID", row.getString("CLIENT_COMPLAINT_ID"));
                        }
                        if (row.getString("COMPLAINT_TITLE") != null) {
                            wbo.setAttribute("complaintTitle", row.getString("COMPLAINT_TITLE"));
                        }
                    }
                    results.add(wbo);
                } catch (NoSuchColumnException ex) {
                    logger.error("SQL Exception  " + ex.getMessage());
                }
            }
            return results;
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
        return new ArrayList<>();
    }

    public ArrayList<WebBusinessObject> getIssueComments(String issueDate) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> rows;
        Vector parameters = new Vector();
        WebBusinessObject wbo;

        DateParser dateParser = new DateParser();
        java.sql.Date selectDate = dateParser.formatSqlDate((issueDate).replaceAll("-", "/"), "y/m/d");
        parameters.addElement(new DateValue(selectDate));

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery("SELECT I.ID ISSUE_ID, I.BUSINESS_ID, I.BUSINESS_ID_BY_DATE, I.USER_ID, U.FULL_NAME FROM ISSUE I LEFT JOIN USERS U ON I.USER_ID = U.USER_ID WHERE I.CREATION_TIME = ?");
            command.setparams(parameters);
            rows = command.executeQuery();

            ArrayList<WebBusinessObject> results = new ArrayList<>();
            for (Row row : rows) {
                try {
                    wbo = fabricateBusObj(row);
                    if (row.getString("ISSUE_ID") != null) {
                        wbo.setAttribute("issueID", row.getString("ISSUE_ID"));
                    }

                    if (row.getString("BUSINESS_ID") != null) {
                        wbo.setAttribute("businessID", row.getString("BUSINESS_ID"));
                    }

                    if (row.getString("BUSINESS_ID_BY_DATE") != null) {
                        wbo.setAttribute("businessIDByDate", row.getString("BUSINESS_ID_BY_DATE"));
                    }

                    if (row.getString("USER_ID") != null) {
                        wbo.setAttribute("createdBy", row.getString("USER_ID"));
                    }

                    if (row.getString("FULL_NAME") != null) {
                        wbo.setAttribute("fromUser", row.getString("FULL_NAME"));
                    }
                    results.add(wbo);
                } catch (NoSuchColumnException ex) {
                    logger.error("SQL Exception  " + ex.getMessage());
                }
            }
            return results;
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
        return new ArrayList<>();
    }

    public WebBusinessObject getLastUserIssueComment(String userID, String issueID) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> rows;
        Vector parameters = new Vector();
        WebBusinessObject wbo = null;
        parameters.addElement(new StringValue(userID));
        parameters.addElement(new StringValue(issueID));
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getLastUserIssueComment"));
            command.setparams(parameters);
            rows = command.executeQuery();
            for (Row row : rows) {
                wbo = fabricateBusObj(row);
                return wbo;
            }
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
        return wbo;
    }

    public ArrayList<WebBusinessObject> getCommentResponseInterval(java.sql.Date fromDate, java.sql.Date toDate) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> rows;
        Vector parameters = new Vector();
        WebBusinessObject wbo;

        parameters.addElement(new DateValue(fromDate));
        parameters.addElement(new DateValue(toDate));
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getCommentResponseInterval").trim());
            command.setparams(parameters);
            rows = command.executeQuery();

            ArrayList<WebBusinessObject> results = new ArrayList<>();
            for (Row row : rows) {
                try {
                    wbo = fabricateBusObj(row);
                    if (row.getString("BUSNIESS_OBJECT_ID") != null) {
                        wbo.setAttribute("businessObjectID", row.getString("BUSNIESS_OBJECT_ID"));
                    }
                    if (row.getString("COMMENT1_CREATED_BY") != null) {
                        wbo.setAttribute("comment1CreatedBy", row.getString("COMMENT1_CREATED_BY"));
                    }
                    if (row.getString("COMMENT1_ID") != null) {
                        wbo.setAttribute("comment1ID", row.getString("COMMENT1_ID"));
                    }
                    if (row.getString("COMMENT1_CREATED_BY_NAME") != null) {
                        wbo.setAttribute("comment1CreatedByName", row.getString("COMMENT1_CREATED_BY_NAME"));
                    }
                    if (row.getString("COMMENT1_COMMENT_DESC") != null) {
                        wbo.setAttribute("comment1", row.getString("COMMENT1_COMMENT_DESC"));
                    }
                    if (row.getString("COMMENT2_CREATED_BY") != null) {
                        wbo.setAttribute("comment2CreatedBy", row.getString("COMMENT2_CREATED_BY"));
                    }
                    if (row.getString("COMMENT2_ID") != null) {
                        wbo.setAttribute("comment2ID", row.getString("COMMENT2_ID"));
                    }
                    if (row.getString("COMMENT2_CREATED_BY_NAME") != null) {
                        wbo.setAttribute("comment2CreatedByName", row.getString("COMMENT2_CREATED_BY_NAME"));
                    }
                    if (row.getString("COMMENT2_COMMENT_DESC") != null) {
                        wbo.setAttribute("comment2", row.getString("COMMENT2_COMMENT_DESC"));
                    }
                    if (row.getString("BUSINESS_ID") != null) {
                        wbo.setAttribute("businessID", row.getString("BUSINESS_ID"));
                    }
                    if (row.getString("BUSINESS_ID_BY_DATE") != null) {
                        wbo.setAttribute("businessIDByDate", row.getString("BUSINESS_ID_BY_DATE"));
                    }
                    if (row.getString("CREATION_TIME") != null) {
                        wbo.setAttribute("issueCreationTime", row.getString("CREATION_TIME"));
                    }
                    if (row.getString("DIFF") != null) {
                        wbo.setAttribute("diff", row.getString("DIFF"));
                    }
                    results.add(wbo);
                } catch (NoSuchColumnException ex) {
                    logger.error("SQL Exception  " + ex.getMessage());
                }
            }
            return results;
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
        return new ArrayList<>();
    }
    
    public ArrayList<WebBusinessObject> getThirdEmptyComment(java.sql.Date fromDate, java.sql.Date toDate, String projectID) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> rows;
        Vector parameters = new Vector();
        WebBusinessObject wbo;

        parameters.addElement(new DateValue(fromDate));
        parameters.addElement(new DateValue(toDate));
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getThirdEmptyComments").trim().replaceAll("projectID", projectID));
            command.setparams(parameters);
            rows = command.executeQuery();

            ArrayList<WebBusinessObject> results = new ArrayList<>();
            for (Row row : rows) {
                try {
                    wbo = fabricateBusObj(row);
                    if (row.getString("BUSNIESS_OBJECT_ID") != null) {
                        wbo.setAttribute("businessObjectID", row.getString("BUSNIESS_OBJECT_ID"));
                    }
                    if (row.getString("COMMENT1_CREATED_BY") != null) {
                        wbo.setAttribute("comment1CreatedBy", row.getString("COMMENT1_CREATED_BY"));
                    }
                    if (row.getString("COMMENT1_ID") != null) {
                        wbo.setAttribute("comment1ID", row.getString("COMMENT1_ID"));
                    }
                    if (row.getString("COMMENT1_CREATED_BY_NAME") != null) {
                        wbo.setAttribute("comment1CreatedByName", row.getString("COMMENT1_CREATED_BY_NAME"));
                    }
                    if (row.getString("COMMENT1_COMMENT_DESC") != null) {
                        wbo.setAttribute("comment1", row.getString("COMMENT1_COMMENT_DESC"));
                    }
                    if (row.getString("COMMENT2_CREATED_BY") != null) {
                        wbo.setAttribute("comment2CreatedBy", row.getString("COMMENT2_CREATED_BY"));
                    }
                    if (row.getString("COMMENT2_ID") != null) {
                        wbo.setAttribute("comment2ID", row.getString("COMMENT2_ID"));
                    }
                    if (row.getString("COMMENT2_CREATED_BY_NAME") != null) {
                        wbo.setAttribute("comment2CreatedByName", row.getString("COMMENT2_CREATED_BY_NAME"));
                    }
                    if (row.getString("COMMENT2_COMMENT_DESC") != null) {
                        wbo.setAttribute("comment2", row.getString("COMMENT2_COMMENT_DESC"));
                    }
                    if (row.getString("COMMENT2_CREATION_TIME") != null) {
                        wbo.setAttribute("COMMENT2_CREATION_TIME", row.getString("COMMENT2_CREATION_TIME"));
                    }
                    if (row.getString("BUSINESS_ID") != null) {
                        wbo.setAttribute("businessID", row.getString("BUSINESS_ID"));
                    }
                    if (row.getString("BUSINESS_ID_BY_DATE") != null) {
                        wbo.setAttribute("businessIDByDate", row.getString("BUSINESS_ID_BY_DATE"));
                    }
                    if (row.getString("CREATION_TIME") != null) {
                        wbo.setAttribute("issueCreationTime", row.getString("CREATION_TIME"));
                    }
                    if (row.getString("DIFF") != null) {
                        wbo.setAttribute("diff", row.getString("DIFF"));
                    }
                    
                    if (row.getString("current_status") != null) {
                        wbo.setAttribute("current_status", row.getString("current_status"));
                    }
                    results.add(wbo);
                } catch (NoSuchColumnException ex) {
                    logger.error("SQL Exception  " + ex.getMessage());
                }
            }
            return results;
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
        return new ArrayList<>();
    }
    
    public ArrayList<WebBusinessObject> getThreeCommentResponseInterval(java.sql.Date fromDate, java.sql.Date toDate) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> rows;
        Vector parameters = new Vector();
        WebBusinessObject wbo;

        parameters.addElement(new DateValue(fromDate));
        parameters.addElement(new DateValue(toDate));
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getClientThirdComments").trim());
            command.setparams(parameters);
            rows = command.executeQuery();

            ArrayList<WebBusinessObject> results = new ArrayList<>();
            for (Row row : rows) {
                try {
                    wbo = fabricateBusObj(row);
                    if (row.getString("BUSNIESS_OBJECT_ID") != null) {
                        wbo.setAttribute("businessObjectID", row.getString("BUSNIESS_OBJECT_ID"));
                    }
                    if (row.getString("COMMENT1_CREATED_BY") != null) {
                        wbo.setAttribute("comment1CreatedBy", row.getString("COMMENT1_CREATED_BY"));
                    }
                    if (row.getString("COMMENT1_ID") != null) {
                        wbo.setAttribute("comment1ID", row.getString("COMMENT1_ID"));
                    }
                    if (row.getString("COMMENT1_CREATED_BY_NAME") != null) {
                        wbo.setAttribute("comment1CreatedByName", row.getString("COMMENT1_CREATED_BY_NAME"));
                    }
                    if (row.getString("COMMENT1_COMMENT_DESC") != null) {
                        wbo.setAttribute("comment1", row.getString("COMMENT1_COMMENT_DESC"));
                    }
                    if (row.getString("COMMENT2_CREATED_BY") != null) {
                        wbo.setAttribute("comment2CreatedBy", row.getString("COMMENT2_CREATED_BY"));
                    }
                    if (row.getString("COMMENT2_ID") != null) {
                        wbo.setAttribute("comment2ID", row.getString("COMMENT2_ID"));
                    }
                    if (row.getString("COMMENT2_CREATED_BY_NAME") != null) {
                        wbo.setAttribute("comment2CreatedByName", row.getString("COMMENT2_CREATED_BY_NAME"));
                    }
                    if (row.getString("COMMENT2_COMMENT_DESC") != null) {
                        wbo.setAttribute("comment2", row.getString("COMMENT2_COMMENT_DESC"));
                    }
                    
                    
                    if (row.getString("COMMENT3_CREATED_BY") != null) {
                        wbo.setAttribute("comment3CreatedBy", row.getString("COMMENT3_CREATED_BY"));
                    }
                    if (row.getString("COMMENT3_ID") != null) {
                        wbo.setAttribute("comment3ID", row.getString("COMMENT3_ID"));
                    }
                    if (row.getString("COMMENT3_CREATED_BY_NAME") != null) {
                        wbo.setAttribute("comment3CreatedByName", row.getString("COMMENT3_CREATED_BY_NAME"));
                    }
                    if (row.getString("COMMENT3_COMMENT_DESC") != null) {
                        wbo.setAttribute("comment3", row.getString("COMMENT3_COMMENT_DESC"));
                    }
                    
                    if (row.getString("BUSINESS_ID") != null) {
                        wbo.setAttribute("businessID", row.getString("BUSINESS_ID"));
                    }
                    if (row.getString("BUSINESS_ID_BY_DATE") != null) {
                        wbo.setAttribute("businessIDByDate", row.getString("BUSINESS_ID_BY_DATE"));
                    }
                    if (row.getString("CREATION_TIME") != null) {
                        wbo.setAttribute("issueCreationTime", row.getString("CREATION_TIME"));
                    }
                    if (row.getString("DIFF") != null) {
                        wbo.setAttribute("diff", row.getString("DIFF"));
                    }
                    
                    if (row.getString("DIFF2") != null) {
                        wbo.setAttribute("diff2", row.getString("DIFF2"));
                    }
                    
                    if (row.getString("current_status") != null) {
                        wbo.setAttribute("current_status", row.getString("current_status"));
                    }
                    results.add(wbo);
                } catch (NoSuchColumnException ex) {
                    logger.error("SQL Exception  " + ex.getMessage());
                }
            }
            return results;
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
        return new ArrayList<>();
    }

    public boolean updateCommentOwner(String commentID) throws SQLException {
        Connection connection = null;
        try {
            int queryResult;
            Vector params = new Vector();
            SQLCommandBean forInsert = new SQLCommandBean();
            connection = dataSource.getConnection();
            params.addElement(new StringValue(CRMConstants.AMR_KASRAWY_ID));
            params.addElement(new StringValue(commentID));
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(getQuery("updateCommentOwner").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            return queryResult > 0;
        } catch (SQLException ex) {
            logger.error(ex);
            return false;
        } finally {
            if (connection != null) {
                connection.setAutoCommit(true);
                connection.close();
            }
        }
    }

    public Vector<WebBusinessObject> getClientsComments(String fromDate, String toDate, String createdBy, List<WebBusinessObject> employeeList, String campaignID, String rateID, String subject) {
        Vector<WebBusinessObject> data = new Vector<>();
        Vector params = new Vector();
        WebBusinessObject wbo;
        Connection connection = null;
        StringBuilder where = new StringBuilder();
        if(fromDate != null && !fromDate.isEmpty()) {
            where.append(" and trunc(COMMENTS.CREATION_TIME) >= ? ");
            params.add(new DateValue(java.sql.Date.valueOf(fromDate.replaceAll("/", "-"))));
        }
        if(toDate != null && !toDate.isEmpty()) {
            where.append(" and trunc(COMMENTS.CREATION_TIME) <= ? ");
            params.add(new DateValue(java.sql.Date.valueOf(toDate.replaceAll("/", "-"))));
        }
        if(createdBy != null && !createdBy.isEmpty()) {
            where.append(" and COMMENTS.CREATED_BY = '").append(createdBy).append("'");
        } else {
            if(employeeList.size()>0){
                where.append(" and (");
                for (int i = 0; i < employeeList.size(); i++) {
                    WebBusinessObject mywbo = employeeList.get(i);
                    String user_id = (String) mywbo.getAttribute("userId");
                    where.append(" COMMENTS.CREATED_BY = '").append(user_id).append("'");
                    if (i != (employeeList.size() - 1)) {
                        where.append(" or");
                    }
                }
                where.append(")");
            }
        }
        if(campaignID != null && !campaignID.equals("all")) {
            where.append(" and CLIENT.SYS_ID IN (SELECT CLIENT_ID FROM CLIENT_CAMPAIGN WHERE CAMPAIGN_ID = '").append(campaignID).append("')");
        }
        if(rateID != null && !rateID.isEmpty()) {
            where.append(" and CR.RATE_ID = '").append(rateID).append("'");
        }
        if(subject != null && !subject.isEmpty()) {
            where.append(" AND CLIENT.OPTION3 = '").append(subject).append("'");
        }

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("clientComments").replaceAll("whereStatement", where.toString()).trim());
            forQuery.setparams(params);

            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }

        // process the vector
        // vector of business objects
        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            try {
                wbo.setAttribute("clientID", r.getString("SYS_ID"));
                wbo.setAttribute("clientNo", r.getString("CLIENT_NO"));
                wbo.setAttribute("clientName", r.getString("NAME"));
                wbo.setAttribute("clientMobile", r.getString("MOBILE"));
                wbo.setAttribute("creationTime", r.getString("CREATION_TIME"));

                if (r.getString("EMAIL") == null) {
                    wbo.setAttribute("clientEmail", "---");
                } else {
                    wbo.setAttribute("clientEmail", r.getString("EMAIL"));
                }
                if (r.getString("INTER_PHONE") != null) {
                    wbo.setAttribute("clientInterPhone", r.getString("INTER_PHONE"));
                }
                if (r.getString("RATE_NAME") != null) {
                    wbo.setAttribute("rateName", r.getString("RATE_NAME"));
                }
                if (r.getString("campaign_title") != null) {
                    wbo.setAttribute("campaign_title", r.getString("campaign_title"));
                }
                if (r.getString("englishname") != null) {
                    wbo.setAttribute("englishname", r.getString("englishname"));
                }
                data.add(wbo);
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(CommentsMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

        return data;
    }

    public Vector<WebBusinessObject> getClientGeneralComments(String clientId) {

        Vector<WebBusinessObject> data = new Vector<WebBusinessObject>();
        Connection connection = null;
        Vector parameters = new Vector();

        parameters.addElement(new StringValue(clientId));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getClientGeneralComments").trim());
            forQuery.setparams(parameters);

            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }

        // process the vector
        // vector of business objects
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            data.addElement(fabricateBusObj((Row) e.nextElement()));
        }

        return data;
    }

    public ArrayList<WebBusinessObject> getClientComments(String clientID, String createdBy, String subject) {
        ArrayList<WebBusinessObject> data = new ArrayList<>();
        Connection connection = null;
        Vector parameters = new Vector();
        parameters.addElement(new StringValue(clientID));
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        StringBuilder where = new StringBuilder();
        //if (subject != null && !subject.isEmpty()) {
        //    where.append(" AND CM.OPTION3 = ? ");
        //    parameters.addElement(new StringValue(subject));
        //}

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getClientComments").trim());
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
                wbo = fabricateBusObj(r);
                try {
                    if (r.getString("CREATED_BY_NAME") != null) {
                        wbo.setAttribute("createdByName", r.getString("CREATED_BY_NAME"));
                    }
                    if (r.getString("COMMENT") != null) {
                        wbo.setAttribute("comment", r.getString("COMMENT"));
                    }
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(CommentsMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                data.add(wbo);
            }
        }
        return data;
    }
    
    public ArrayList<WebBusinessObject> getFinishCloseComments(String issueID) {
        ArrayList<WebBusinessObject> data = new ArrayList<>();
        Connection connection = null;
        Vector parameters = new Vector();
        parameters.addElement(new StringValue(issueID));
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getFinishCloseComments").trim());
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
                wbo = fabricateBusObj(r);
                try {
                    if (r.getString("STATUS_NAME") != null) {
                        wbo.setAttribute("statusName", r.getString("STATUS_NAME"));
                    }
                    if (r.getString("BUSINESS_COMP_ID") != null) {
                        wbo.setAttribute("businessCompID", r.getString("BUSINESS_COMP_ID"));
                    }
                    if (r.getString("USER_NAME") != null) {
                        wbo.setAttribute("userName", r.getString("USER_NAME"));
                    }
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(CommentsMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                data.add(wbo);
            }
        }
        return data;
    }
    
    public ArrayList<WebBusinessObject> getAllComments(String issueID) {
        ArrayList<WebBusinessObject> data = new ArrayList<>();
        Connection connection = null;
        Vector parameters = new Vector();
        parameters.addElement(new StringValue(issueID));
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getAllComments").trim());
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
                wbo = fabricateBusObj(r);
                try {
                    if (r.getString("BUSINESS_COMP_ID") != null) {
                        wbo.setAttribute("businessCompID", r.getString("BUSINESS_COMP_ID"));
                    }
                    if (r.getString("USER_NAME") != null) {
                        wbo.setAttribute("userName", r.getString("USER_NAME"));
                    }
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(CommentsMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                data.add(wbo);
            }
        }
        return data;
    }
    
    public ArrayList<WebBusinessObject> getClientFirstCommentResponseInterval(java.sql.Date fromDate, java.sql.Date toDate) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> rows;
        Vector parameters = new Vector();
        WebBusinessObject wbo;

        parameters.addElement(new DateValue(fromDate));
        parameters.addElement(new DateValue(toDate));
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getFirstClientComment").trim());
            command.setparams(parameters);
            rows = command.executeQuery();

            ArrayList<WebBusinessObject> results = new ArrayList<>();
            for (Row row : rows) {
                try {
                    wbo = fabricateBusObj(row);
                    if (row.getString("SYS_ID") != null) {
                        wbo.setAttribute("clientID", row.getString("SYS_ID"));
                    }
                    if (row.getString("CLIENT_NO") != null) {
                        wbo.setAttribute("ClientNumber", row.getString("CLIENT_NO"));
                    }
                    if (row.getString("Name") != null) {
                        wbo.setAttribute("ClientName", row.getString("Name"));
                    }
                    if (row.getString("CREATION_TIME") != null) {
                        wbo.setAttribute("clientCreationTime", row.getString("CREATION_TIME"));
                    }
                    if (row.getString("CREATED_BY") != null) {
                        UserMgr userMgr = UserMgr.getInstance();
                        WebBusinessObject userWbo = userMgr.getOnSingleKey(row.getString("CREATED_BY"));
                        wbo.setAttribute("CLIENT_CREATED_BY_NAME", userWbo.getAttribute("userName"));
                    }
                    if (row.getString("COMMENT_CREATED_BY_NAME") != null) {
                        wbo.setAttribute("COMMENT_CREATED_BY_NAME", row.getString("COMMENT_CREATED_BY_NAME"));
                    }
                    if (row.getString("COMMENTS_CREATION_TIME") != null) {
                        wbo.setAttribute("COMMENTS_CREATION_TIME", row.getString("COMMENTS_CREATION_TIME"));
                    }
                    if (row.getString("COMMENT_DESC") != null) {
                        wbo.setAttribute("COMMENT_DESC", row.getString("COMMENT_DESC"));
                    } else {
                        wbo.setAttribute("COMMENT_DESC", "----");
                    }
                    
                    results.add(wbo);
                } catch (NoSuchColumnException ex) {
                    logger.error("SQL Exception  " + ex.getMessage());
                }
            }
            return results;
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
        return new ArrayList<>();
    }
    
    public Vector<WebBusinessObject> getAllClientComments(String clientID) {

        Vector<WebBusinessObject> data = new Vector<>();
        Connection connection = null;
        Vector parameters = new Vector();
        parameters.addElement(new StringValue(clientID));
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getAllClientComments").trim());
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
            while (e.hasMoreElements()) {
                data.addElement(fabricateBusObj((Row) e.nextElement()));
            }
        }
        return data;
    }
    
    public WebBusinessObject getClientFirstComment(String clientID) {
        Connection connection = null;
        Vector parameters = new Vector();
        parameters.addElement(new StringValue(clientID));
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        WebBusinessObject wbo = null;
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getClientFirstComment").trim());
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
            Row r;
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = new WebBusinessObject();
                try {
                    if (r.getString("COMMENT_DESC") != null) {
                        wbo.setAttribute("comment", r.getString("COMMENT_DESC"));
                    }
                    if (r.getString("CREATION_TIME") != null) {
                        wbo.setAttribute("commentDate", r.getString("CREATION_TIME").substring(0, 16));
                    }
                    if (r.getString("COMMENTED_BY") != null) {
                        wbo.setAttribute("commentedBy", r.getString("COMMENTED_BY"));
                    }
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(CommentsMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                return wbo;
            }
        }
        return null;
    }
    
     public ArrayList<WebBusinessObject> getClientCommentsExcel(String fromDate, String toDate, String createdBy, String subject){
        ArrayList<WebBusinessObject> data = new ArrayList<WebBusinessObject>();
        Vector params = new Vector();
        WebBusinessObject wbo;
        Connection connection = null;
        StringBuilder where = new StringBuilder();
        if(fromDate != null && !fromDate.isEmpty()) {
            where.append(" WHERE TRUNC(CM.CREATION_TIME) >= ? ");
            params.add(new DateValue(java.sql.Date.valueOf(fromDate.replaceAll("/", "-"))));
        }
        
        if(toDate != null && !toDate.isEmpty()) {
            if(where.length() > 0){
                where.append(" AND TRUNC(CM.CREATION_TIME) <= ? ");
            } else{
                where.append(" WHERE TRUNC(CM.CREATION_TIME) <= ? ");
            }
            params.add(new DateValue(java.sql.Date.valueOf(toDate.replaceAll("/", "-"))));
        }
        
        if(createdBy != null && !createdBy.isEmpty()) {
            if(where.length() > 0){
                where.append(" AND CM.CREATED_BY = '").append(createdBy).append("'");
            } else{
                where.append(" WHERE CM.CREATED_BY = '").append(createdBy).append("'");
            }
        }
        if(subject != null && !subject.isEmpty()) {
            if(where.length() > 0){
                where.append(" AND ");
            } else{
                where.append(" WHERE ");
            }
            where.append(" CM.OPTION2 = '").append(subject).append("'");
        }

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getClientCommentsExcel").replaceAll("whereStatement", where.toString()).trim());
            forQuery.setparams(params);

            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }

        // process the vector
        // vector of business objects
        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            try {
                if(r.getString("CREATION_TIME") != null){
                    wbo.setAttribute("creationTime", r.getString("CREATION_TIME"));
                } else {
                    wbo.setAttribute("creationTime", "");
                }
                
                if(r.getString("COMMENT_DESC") != null && !r.getString("COMMENT_DESC").equals("null") && !r.getString("COMMENT_DESC").equals("UL")){
                    wbo.setAttribute("cmntDsc", r.getString("COMMENT_DESC"));
                } else {
                    wbo.setAttribute("cmntDsc", "");
                }
                
                if(r.getString("FULL_NAME") != null && !r.getString("FULL_NAME").equals("null") && !r.getString("FULL_NAME").equals("UL")){
                    wbo.setAttribute("crtdBy", r.getString("FULL_NAME"));
                } else {
                    wbo.setAttribute("crtdBy", "");
                }
                
                if(r.getString("CLIENT_NO") != null && !r.getString("CLIENT_NO").equals("null") && !r.getString("CLIENT_NO").equals("UL")){
                    wbo.setAttribute("clntNo", r.getString("CLIENT_NO"));
                } else {
                    wbo.setAttribute("clntNo", "");
                }
                
                if(r.getString("NAME") != null && !r.getString("NAME").equals("null") && !r.getString("NAME").equals("UL")){
                    wbo.setAttribute("clntNm", r.getString("NAME"));
                } else {
                    wbo.setAttribute("clntNm", "");
                }
                
                if(r.getString("MOBILE") != null && !r.getString("MOBILE").equals("null") && !r.getString("MOBILE").equals("UL")){
                    wbo.setAttribute("mbl", r.getString("MOBILE"));
                } else {
                    wbo.setAttribute("mbl", "");
                }
                
                if(r.getString("INTER_PHONE") != null && !r.getString("INTER_PHONE").equals("null") && !r.getString("INTER_PHONE").equals("UL")){
                    wbo.setAttribute("intrCl", r.getString("INTER_PHONE"));
                } else {
                    wbo.setAttribute("intrCl", "");
                }
                
                if(r.getString("EMAIL") != null && !r.getString("EMAIL").equals("null") && !r.getString("EMAIL").equals("UL")){
                    wbo.setAttribute("mail", r.getString("EMAIL"));
                } else {
                    wbo.setAttribute("mail", "");
                }
                
                if(r.getString("addtionTime") != null && !r.getString("addtionTime").equals("null") && !r.getString("addtionTime").equals("UL")){
                    wbo.setAttribute("addtionTime", r.getString("addtionTime"));
                } else {
                    wbo.setAttribute("addtionTime", "");
                }
                data.add(wbo);
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(CommentsMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

        return data;
    }
    
    public ArrayList<WebBusinessObject> getCommentsOnEmployee(java.sql.Date fromDate, java.sql.Date toDate, String employeeID, String commentType) {
        Connection connection = null;
        Vector parameters = new Vector();
        parameters.addElement(new DateValue(fromDate));
        parameters.addElement(new DateValue(toDate));
        parameters.addElement(new StringValue(employeeID));
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        WebBusinessObject wbo = null;
        StringBuilder where = new StringBuilder();
        if (commentType != null && !commentType.isEmpty()) {
            where.append(" AND CT.OPTION2 = ? ");
            parameters.addElement(new StringValue(commentType));
        }
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getCommentsOnEmployee").trim() + where.toString());
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
        ArrayList<WebBusinessObject> result = new ArrayList<>();
        if (queryResult != null) {
            Enumeration e = queryResult.elements();
            Row r;
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = fabricateBusObj(r);
                try {
                    wbo.setAttribute("clientName", r.getString("CLIENT_NAME") != null ? r.getString("CLIENT_NAME") : "");
                    wbo.setAttribute("fromUserName", r.getString("FROM_USER_NAME") != null ? r.getString("FROM_USER_NAME") : "");
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(CommentsMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                result.add(wbo);
            }
        }
        return result;
    }
}
