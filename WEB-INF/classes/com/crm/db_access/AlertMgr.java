/*
 * FileMgr.java
 *
 * Created on March 25, 2005, 12:35 AM
 */
package com.crm.db_access;

import com.crm.common.CRMConstants;
import com.silkworm.business_objects.*;
import com.silkworm.persistence.relational.*;
import java.io.Serializable;
import java.sql.*;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.http.HttpSession;
import org.apache.log4j.xml.DOMConfigurator;

/**
 *
 * @author Walid
 */
public class AlertMgr extends RDBGateWay implements Serializable {

    private static final AlertMgr ALERT_MGR = new AlertMgr();

    private AlertMgr() {
    }

    public static AlertMgr getInstance() {
        return ALERT_MGR;
    }

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("alert.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    @Override
    public ArrayList getCashedTableAsArrayList() {
        return cashedData;
    }

    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

//    public boolean saveObjectAddComment(String businessObjId, String userId) throws Exception {
//        return saveObject(businessObjId, CRMConstants.ALERT_TYPE_ID_ADD_COMMENT, userId, dataSource.getConnection());
//    }

    public boolean saveObjectAddReviewComment(String businessObjId, String userId) throws Exception {
        return saveObject(businessObjId, CRMConstants.ALERT_TYPE_ID_ADD_REVIEW_COMMENT, userId, dataSource.getConnection());
    }

    public boolean saveObjectAddReplayComment(String businessObjId, String userId) throws Exception {
        return saveObject(businessObjId, CRMConstants.ALERT_TYPE_ID_ADD_REPLAY_COMMENT, userId, dataSource.getConnection());
    }

    public boolean saveObjectAttachFile(String businessObjId, String userId) throws Exception {
        return saveObject(businessObjId, CRMConstants.ALERT_TYPE_ID_ATTACH_FILE, userId, dataSource.getConnection());
    }

    public boolean saveObjectFinishTicket(String businessObjId, String userId) throws Exception {
        return saveObject(businessObjId, CRMConstants.ALERT_TYPE_ID_FINISH_TICKET, userId, dataSource.getConnection());
    }

    public boolean saveObjectCloseTicket(String businessObjId, String userId) throws Exception {
        return saveObject(businessObjId, CRMConstants.ALERT_TYPE_ID_CLOSE_TICKET, userId, dataSource.getConnection());
    }

    public boolean saveObjectAcceptTicket(String businessObjId, String userId) throws Exception {
        return saveObject(businessObjId, CRMConstants.ALERT_TYPE_ID_ACCEPT_TICKET, userId, dataSource.getConnection());
    }

    public boolean saveObjectRejectTicket(String businessObjId, String userId) throws Exception {
        return saveObject(businessObjId, CRMConstants.ALERT_TYPE_ID_REJECT_TICKET, userId, dataSource.getConnection());
    }

    public boolean saveObject(WebBusinessObject wbo, HttpSession session) throws Exception {
        WebBusinessObject user = (WebBusinessObject) session.getAttribute("loggedUser");

        String businessObjId = (String) wbo.getAttribute("businessObjId");
        String alertTypeId = (String) wbo.getAttribute("alertTypeId");
        String userId = (String) user.getAttribute("userId");

        return saveObject(businessObjId, alertTypeId, userId);
    }

    public boolean saveObject(String businessObjId, String alertTypeId, String userId) throws Exception {
        return saveObject(businessObjId, alertTypeId, userId, dataSource.getConnection());
    }
    
    public boolean saveObject(String businessObjId, String alertTypeId, String userId, Connection connection) throws Exception {
        Vector parameters = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        String id = UniqueIDGen.getNextID();
        parameters.addElement(new StringValue(id));
        parameters.addElement(new StringValue(businessObjId));
        parameters.addElement(new StringValue(alertTypeId));
        parameters.addElement(new StringValue(userId));
        parameters.addElement(new StringValue("UL"));
        parameters.addElement(new StringValue("UL"));

        try {
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(getQuery("insertData").trim());
            forInsert.setparams(parameters);
            queryResult = forInsert.executeUpdate();
        } catch (SQLException se) {
            logger.error("Exception inserting file descriptor: " + se.getMessage());
            return false;
        } finally {
            try {
                if (connection.getAutoCommit()) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error("Close Error");
                return false;
            }
        }

        return (queryResult > 0);
    }
    
    public boolean saveObject(String businessObjId, String alertTypeId, String userId, String message, String at) throws Exception {
        return saveObject(businessObjId, alertTypeId, userId, message, at, dataSource.getConnection());
    }

    public boolean saveObject(String businessObjId, String alertTypeId, String userId, String message, String at, Connection connection) throws Exception {
        Vector parameters = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        String id = UniqueIDGen.getNextID();
        parameters.addElement(new StringValue(id));
        parameters.addElement(new StringValue(businessObjId));
        parameters.addElement(new StringValue(alertTypeId));
        parameters.addElement(new StringValue(userId));
        parameters.addElement(new StringValue(message));
        parameters.addElement(new StringValue(at));
        try {
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(getQuery("insertData").trim());
            forInsert.setparams(parameters);
            queryResult = forInsert.executeUpdate();
        } catch (SQLException se) {
            logger.error("Exception inserting file descriptor: " + se.getMessage());
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
        return cashedData;
    }

    @Override
    public WebBusinessObject getObjectFromCash(String key) {
        return super.getObjectFromCash(key);
    }

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
    }
    
    public boolean changeStatus(String alertID, String statusCode, String note, String actionCode) throws Exception {
        Vector parameters = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        Connection connection = dataSource.getConnection();
        parameters.addElement(new StringValue(statusCode));
        parameters.addElement(new StringValue(note));
        parameters.addElement(new StringValue(actionCode));
        parameters.addElement(new StringValue(alertID));
        try {
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(getQuery("changeStatus").trim());
            forInsert.setparams(parameters);
            queryResult = forInsert.executeUpdate();
        } catch (SQLException se) {
            return false;
        } finally {
            try {
                if (connection.getAutoCommit()) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error("Close Error");
                return false;
            }
        }
        return (queryResult > 0);
    }
    
    public ArrayList<WebBusinessObject> getCommentsAlert(String userID, java.sql.Date fromDate, java.sql.Date toDate) {
        WebBusinessObject wbo;
        Connection connection = null;
        Vector queryResult = null;
        Vector params = new Vector();
        params.addElement(new StringValue(userID));
        params.addElement(new StringValue(userID));
        params.addElement(new DateValue(fromDate));
        params.addElement(new DateValue(toDate));
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getCommentsAlert").trim());
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
        ArrayList<WebBusinessObject> results = new ArrayList<>();
        Row r;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = fabricateBusObj(r);
            try {
                if (r.getString("ALERT_CREATION_DATE") != null) {
                    wbo.setAttribute("alertCreationDate", r.getString("ALERT_CREATION_DATE"));
                }
                if (r.getString("STATUS_CODE") != null) {
                    wbo.setAttribute("statusCode", r.getString("STATUS_CODE"));
                }
                if (r.getString("ALERT_ID") != null) {
                    wbo.setAttribute("alertID", r.getString("ALERT_ID"));
                }
                if (r.getString("COMMENT_BY") != null) {
                    wbo.setAttribute("commentBy", r.getString("COMMENT_BY"));
                }
                if (r.getString("ALERT_TYPE") != null) {
                    wbo.setAttribute("alertType", r.getString("ALERT_TYPE"));
                }
                if (r.getString("CLIENT_NAME") != null) {
                    wbo.setAttribute("clientName", r.getString("CLIENT_NAME"));
                }
                if (r.getString("CLIENT_NO") != null) {
                    wbo.setAttribute("clientNo", r.getString("CLIENT_NO"));
                }
                if (r.getString("CLIENT_ID") != null) {
                    wbo.setAttribute("clientID", r.getString("CLIENT_ID"));
                }
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(AlertMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            results.add(wbo);
        }
        return results;
    }
    
    public String getUnReadCommentsAlertCount(String userID) {
        WebBusinessObject wbo;
        Connection connection = null;
        Vector queryResult = null;
        Vector params = new Vector();
        params.addElement(new StringValue(userID));
        params.addElement(new StringValue(userID));
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getUnReadCommentsAlertCount").trim());
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
        String count = "0";
        Row r;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            try {
                count = r.getString("COUNT") != null ? r.getString("COUNT") : "0";
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(AlertMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return count;
    }
    
    public ArrayList<WebBusinessObject> getActiveCommentsAlert(String userID) {
        WebBusinessObject wbo;
        Connection connection = null;
        Vector queryResult = null;
        Vector params = new Vector();
        params.addElement(new StringValue(userID));
        params.addElement(new StringValue(userID));
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getActiveCommentsAlert").trim());
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
        ArrayList<WebBusinessObject> results = new ArrayList<>();
        Row r;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = fabricateBusObj(r);
            try {
                if (r.getString("ALERT_CREATION_DATE") != null) {
                    wbo.setAttribute("alertCreationDate", r.getString("ALERT_CREATION_DATE"));
                }
                if (r.getString("STATUS_CODE") != null) {
                    wbo.setAttribute("statusCode", r.getString("STATUS_CODE"));
                }
                if (r.getString("ALERT_ID") != null) {
                    wbo.setAttribute("alertID", r.getString("ALERT_ID"));
                }
                if (r.getString("COMMENT_BY") != null) {
                    wbo.setAttribute("commentBy", r.getString("COMMENT_BY"));
                }
                if (r.getString("ALERT_TYPE") != null) {
                    wbo.setAttribute("alertType", r.getString("ALERT_TYPE"));
                }
                if (r.getString("CLIENT_NAME") != null) {
                    wbo.setAttribute("clientName", r.getString("CLIENT_NAME"));
                }
                if (r.getString("CLIENT_NO") != null) {
                    wbo.setAttribute("clientNo", r.getString("CLIENT_NO"));
                }
                if (r.getString("CLIENT_ID") != null) {
                    wbo.setAttribute("clientID", r.getString("CLIENT_ID"));
                }
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(AlertMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            results.add(wbo);
        }
        return results;
    }
    
    public boolean alreadyExists(String id, String alertTypeId, String at)
    {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        Vector result = null;

        parameters.addElement(new StringValue(id));
        parameters.addElement(new StringValue(alertTypeId));
        parameters.addElement(new StringValue(at));
        try
        {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("alreadyExists").trim());
            command.setparams(parameters);
            result = command.executeQuery();
        }
        catch (SQLException se)
        {
            return false;
        }
        catch (UnsupportedTypeException se)
        {
            return false;
        }
        finally
        {
            try
            {
                connection.close();
            }
            catch (SQLException ex)
            {
                logger.error("Close Error");
                return false;
            }
        }
        return (result != null && !result.isEmpty());
    }
    
    public ArrayList<WebBusinessObject> getContractsAlert(java.sql.Date fromDate, java.sql.Date toDate) {
        WebBusinessObject wbo;
        Connection connection = null;
        Vector queryResult = null;
        Vector params = new Vector();
        params.addElement(new DateValue(fromDate));
        params.addElement(new DateValue(toDate));
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getContractsAlert").trim());
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
        ArrayList<WebBusinessObject> results = new ArrayList<>();
        Row r;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = fabricateBusObj(r);
            try {
                if (r.getString("ALERT_CREATION_DATE") != null) {
                    wbo.setAttribute("alertCreationDate", r.getString("ALERT_CREATION_DATE"));
                }
                if (r.getString("STATUS_CODE") != null) {
                    wbo.setAttribute("statusCode", r.getString("STATUS_CODE"));
                }
                if (r.getString("ALERT_ID") != null) {
                    wbo.setAttribute("alertID", r.getString("ALERT_ID"));
                }
                if (r.getString("ALERT_TYPE") != null) {
                    wbo.setAttribute("alertType", r.getString("ALERT_TYPE"));
                }
                if (r.getString("CONTRACT_NUMBER") != null) {
                    wbo.setAttribute("contractNumber", r.getString("CONTRACT_NUMBER"));
                }
                if (r.getString("BEGIN_DATE") != null) {
                    wbo.setAttribute("beginDate", r.getString("BEGIN_DATE"));
                }
                if (r.getString("END_DATE") != null) {
                    wbo.setAttribute("endDate", r.getString("END_DATE"));
                }
                if (r.getString("CLIENT_NAME") != null) {
                    wbo.setAttribute("clientName", r.getString("CLIENT_NAME"));
                }
                if (r.getString("CLIENT_NO") != null) {
                    wbo.setAttribute("clientNo", r.getString("CLIENT_NO"));
                }
                if (r.getString("CLIENT_ID") != null) {
                    wbo.setAttribute("clientID", r.getString("CLIENT_ID"));
                }
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(AlertMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            results.add(wbo);
        }
        return results;
    }
    
    public ArrayList<WebBusinessObject> getMyClientLastCommentsAlert(String userID, int noOfDays) {
        WebBusinessObject wbo;
        Connection connection = null;
        Vector queryResult = null;
        Vector params = new Vector();
        params.addElement(new StringValue(userID));
        params.addElement(new StringValue(userID));
        params.addElement(new IntValue(noOfDays));
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getMyClientLastCommentsAlert").trim());
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
        ArrayList<WebBusinessObject> results = new ArrayList<>();
        Row r;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = fabricateBusObj(r);
            try {
                if (r.getString("ALERT_CREATION_DATE") != null) {
                    wbo.setAttribute("alertCreationDate", r.getString("ALERT_CREATION_DATE"));
                }
                if (r.getString("STATUS_CODE") != null) {
                    wbo.setAttribute("statusCode", r.getString("STATUS_CODE"));
                }
                if (r.getString("ALERT_ID") != null) {
                    wbo.setAttribute("alertID", r.getString("ALERT_ID"));
                }
                if (r.getString("COMMENT_BY") != null) {
                    wbo.setAttribute("commentBy", r.getString("COMMENT_BY"));
                }
                if (r.getString("ALERT_TYPE") != null) {
                    wbo.setAttribute("alertType", r.getString("ALERT_TYPE"));
                }
                if (r.getString("CLIENT_NAME") != null) {
                    wbo.setAttribute("clientName", r.getString("CLIENT_NAME"));
                }
                if (r.getString("CLIENT_NO") != null) {
                    wbo.setAttribute("clientNo", r.getString("CLIENT_NO"));
                }
                if (r.getString("CLIENT_ID") != null) {
                    wbo.setAttribute("clientID", r.getString("CLIENT_ID"));
                }
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(AlertMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            results.add(wbo);
        }
        return results;
    }
}
