package com.tracker.db_access;

import com.android.business_objects.LiteWebBusinessObject;
import com.crm.common.ActionEvent;
import com.maintenance.common.DateParser;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import java.sql.SQLException;
import java.util.*;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.http.HttpSession;
import org.apache.log4j.xml.DOMConfigurator;

public class IssueStatusMgr extends RDBGateWay {

    private static IssueStatusMgr issueStatusMgr = new IssueStatusMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();

    public static IssueStatusMgr getInstance() {
        logger.info("Getting IssueStatusMgr Instance ....");
        return issueStatusMgr;
    }

    public IssueStatusMgr() {
    }

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("issue_state.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    @Override
    public ArrayList getCashedTableAsArrayList() {

        return null;
    }

    public Vector getAllIssueStatus(String issueID) {

        Connection connection = null;

        Vector SQLparams = new Vector();

        SQLparams.addElement(new StringValue(issueID));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {

            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("selectIssueStatusBeginDate").trim());
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } catch (Exception exception) {
            logger.error("An exception has been thrown " + exception.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }

        // process the vector
        // vector of business objects
        Vector reultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            WebBusinessObject issueStatusList = fabricateBusObj(r);
            reultBusObjs.add(issueStatusList);
        }

        return reultBusObjs;

    }

    public WebBusinessObject getLastIssueStatus(String sIssueID) {

        Connection connection = null;
        WebBusinessObject resultBusObj = null;
//        StringBuffer query = new StringBuffer("SELECT * FROM ");
//        query.append("issue_status WHERE ISSUE_ID = ? AND END_DATE = '20101231000000'");

        DateParser dateParser = new DateParser();
        java.sql.Date virtaulEDate = dateParser.getVirtalEndDate();
        java.sql.Timestamp virtaulEndDate = new java.sql.Timestamp(virtaulEDate.getTime());

        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(sIssueID));
        SQLparams.addElement(new TimestampValue(virtaulEndDate));
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("selectIssueStatusEndDate").trim());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
            Row r = null;
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                resultBusObj = fabricateBusObj(r);
            }
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } catch (SQLException e) {
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return null;
            }
        }
        return resultBusObj;
    }

    public WebBusinessObject getIssueStatusFinish(String sIssueID) {

        Connection connection = null;
        WebBusinessObject resultBusObj = null;

        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(sIssueID));
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("selectFinishIssue").trim());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
            Row r = null;
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                resultBusObj = fabricateBusObj(r);
            }
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } catch (SQLException e) {
            logger.error(e.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return null;
            }
        }
        return resultBusObj;
    }

    public WebBusinessObject getPrivateCurrentStatus(HttpSession s) {
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        Connection connection = null;
        WebBusinessObject resultBusObj = null;
        String id = null;
        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue((String) waUser.getAttribute("userId")));
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getPrivateCurrentStatus").trim());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
            Row r = null;
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                try {
                    id = r.getString("STATUS_ID");
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(IssueStatusMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } catch (SQLException e) {
            logger.error(e.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return null;
            }
        }
        resultBusObj = (WebBusinessObject) getOnSingleKey(id);
        return resultBusObj;
    }

    public Vector getPublicCurrentStatus() {
        Connection connection = null;
        WebBusinessObject resultBusObj = null;
        List<String> ids = new ArrayList<String>();
        int i = 0;
        Vector SQLparams = new Vector();
        Vector statusV = new Vector();
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getPublicCurrentStatus").trim());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
            Row r = null;
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                try {
                    ids.add(r.getString("STATUS_ID").toString());
                    i++;
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(IssueStatusMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } catch (SQLException e) {
            logger.error(e.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return null;
            }
        }

        for (int x = 0; x < ids.size(); x++) {
            resultBusObj = new WebBusinessObject();
            resultBusObj = (WebBusinessObject) getOnSingleKey(ids.get(x));
            statusV.add(resultBusObj);
        }

        return statusV;
    }

    public boolean changeStatus(WebBusinessObject wbo) throws SQLException {
        String createdBy = "-1";
        String statusCode = (String) wbo.getAttribute("statusCode");
        String date = (String) wbo.getAttribute("date");
        String businessObjectId = (String) wbo.getAttribute("businessObjectId");
        String objectType = (String) wbo.getAttribute("objectType");
        String parentId = (String) wbo.getAttribute("parentId");
        String issueTitle = (String) wbo.getAttribute("issueTitle");
        String statusNote = (String) wbo.getAttribute("statusNote");
        String causeDescription = (String) wbo.getAttribute("cuseDescription");
        String actionTaken = (String) wbo.getAttribute("actionTaken");
        String preventionTaken = (String) wbo.getAttribute("preventionTaken");

        return changeStatus(statusCode, businessObjectId, objectType, date, parentId, createdBy, issueTitle, statusNote, causeDescription, actionTaken, preventionTaken, null);
    }
    public boolean AddNewMessage(WebBusinessObject wbo, WebBusinessObject loggedUser, ActionEvent event) throws SQLException {
        String createdBy = (String) loggedUser.getAttribute("userId");
        String statusCode = (String) wbo.getAttribute("statusCode");
        String date = (String) wbo.getAttribute("date");
        String businessObjectId = (String) wbo.getAttribute("businessObjectId");
        String objectType = (String) wbo.getAttribute("objectType");
        String parentId = (String) wbo.getAttribute("parentId");
        String issueTitle = (String) wbo.getAttribute("issueTitle");
        String statusNote = (String) wbo.getAttribute("statusNote");
        String causeDescription = (String) wbo.getAttribute("cuseDescription");
        String actionTaken = (String) wbo.getAttribute("actionTaken");
        String preventionTaken = (String) wbo.getAttribute("preventionTaken");

        return AddNewMessage(statusCode, businessObjectId, objectType, date, parentId, createdBy, issueTitle,
                statusNote, causeDescription, actionTaken, preventionTaken, event);
    }

    public boolean AddNewMessage(String statusCode, String businessObjectId, String objectType,
            String date, String parentId, String createdBy, String issueTitle, String statusNote,
            String causeDescription, String actionTaken, String preventionTaken, ActionEvent event) throws SQLException {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector issueStatusParameters = new Vector();
        Vector updateIssueStatusParameters = new Vector();
        int queryResult;

        String statusId = UniqueIDGen.getNextID();
        // set up new issue status record
        issueStatusParameters.addElement(new StringValue(statusId));
        issueStatusParameters.addElement(new StringValue(statusCode));
        issueStatusParameters.addElement(new StringValue(issueTitle));
        issueStatusParameters.addElement(new StringValue(statusNote));
        issueStatusParameters.addElement(new StringValue(date));
        issueStatusParameters.addElement(new StringValue(causeDescription));
        issueStatusParameters.addElement(new StringValue(actionTaken));
        issueStatusParameters.addElement(new StringValue(preventionTaken));
        issueStatusParameters.addElement(new StringValue(businessObjectId));
        issueStatusParameters.addElement(new StringValue(objectType));
        issueStatusParameters.addElement(new StringValue(parentId));
        issueStatusParameters.addElement(new StringValue(createdBy));

        try {
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            command.setConnection(connection);
            command.setSQLQuery(getQuery("insertIssueStatus"));
            command.setparams(issueStatusParameters);
            queryResult = command.executeUpdate();
            if (queryResult < 0) {
                connection.rollback();
                return false;
            }
            try {
                Thread.sleep(50);
            } catch (InterruptedException ex) {
                connection.rollback();
                logger.error("Exception : " + ex.getMessage());
                return false;
            }
        } catch (SQLException ex) {
            logger.error("Exception : " + ex.getMessage());
            return false;
        } finally {
            connection.commit();
            connection.close();
        }

        // fire event
        if (event != null) {
            event.fire(statusCode, businessObjectId, createdBy);
        }

        return true;
    }
    
    public boolean changeStatus(WebBusinessObject wbo, WebBusinessObject loggedUser, ActionEvent event) throws SQLException {
        String createdBy = (String) loggedUser.getAttribute("userId");
        String statusCode = (String) wbo.getAttribute("statusCode");
        String date = (String) wbo.getAttribute("date");
        String businessObjectId = (String) wbo.getAttribute("businessObjectId");
        String objectType = (String) wbo.getAttribute("objectType");
        String parentId = (String) wbo.getAttribute("parentId");
        String issueTitle = (String) wbo.getAttribute("issueTitle");
        String statusNote = (String) wbo.getAttribute("statusNote");
        String causeDescription = (String) wbo.getAttribute("cuseDescription");
        String actionTaken = (String) wbo.getAttribute("actionTaken");
        String preventionTaken = (String) wbo.getAttribute("preventionTaken");

        return changeStatus(statusCode, businessObjectId, objectType, date, parentId, createdBy, issueTitle,
                statusNote, causeDescription, actionTaken, preventionTaken, event);
    }

    public boolean changeStatus(String statusCode, String businessObjectId, String objectType,
            String date, String parentId, String createdBy, String issueTitle, String statusNote,
            String causeDescription, String actionTaken, String preventionTaken, ActionEvent event) throws SQLException {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector issueStatusParameters = new Vector();
        Vector updateIssueStatusParameters = new Vector();
        int queryResult;

        String statusId = UniqueIDGen.getNextID();
        // set up new issue status record
        issueStatusParameters.addElement(new StringValue(statusId));
        issueStatusParameters.addElement(new StringValue(statusCode));
        issueStatusParameters.addElement(new StringValue(issueTitle));
        issueStatusParameters.addElement(new StringValue(statusNote));
        issueStatusParameters.addElement(new StringValue(date));
        issueStatusParameters.addElement(new StringValue(causeDescription));
        issueStatusParameters.addElement(new StringValue(actionTaken));
        issueStatusParameters.addElement(new StringValue(preventionTaken));
        issueStatusParameters.addElement(new StringValue(businessObjectId));
        issueStatusParameters.addElement(new StringValue(objectType));
        issueStatusParameters.addElement(new StringValue(parentId));
        issueStatusParameters.addElement(new StringValue(createdBy));

        // set up update issue status record
        updateIssueStatusParameters.addElement(new StringValue(date));
        updateIssueStatusParameters.addElement(new StringValue(date));
        updateIssueStatusParameters.addElement(new StringValue(businessObjectId));
        updateIssueStatusParameters.addElement(new StringValue(objectType));

        try {
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            command.setConnection(connection);
            command.setSQLQuery(getQuery("updatePreviousStatus"));
            command.setparams(updateIssueStatusParameters);
            queryResult = command.executeUpdate();
            if (queryResult < 0) {
                connection.rollback();
                return false;
            }
            try {
                Thread.sleep(50);
            } catch (InterruptedException ex) {
                connection.rollback();
                logger.error("Exception : " + ex.getMessage());
                return false;
            }

            command.setSQLQuery(getQuery("insertIssueStatus"));
            command.setparams(issueStatusParameters);
            queryResult = command.executeUpdate();
            if (queryResult < 0) {
                connection.rollback();
                return false;
            }
            try {
                Thread.sleep(50);
            } catch (InterruptedException ex) {
                connection.rollback();
                logger.error("Exception : " + ex.getMessage());
                return false;
            }
        } catch (SQLException ex) {
            logger.error("Exception : " + ex.getMessage());
            return false;
        } finally {
            connection.commit();
            connection.close();
        }

        // fire event
        if (event != null) {
            event.fire(statusCode, businessObjectId, createdBy);
        }

        return true;
    }
    
    
    
    
    
    public boolean changeStatus1(LiteWebBusinessObject wbo, WebBusinessObject loggedUser, ActionEvent event) throws SQLException {
        String createdBy = (String) loggedUser.getAttribute("userId");
        String statusCode = (String) wbo.getAttribute("statusCode");
        String date = (String) wbo.getAttribute("date");
        String businessObjectId = (String) wbo.getAttribute("businessObjectId");
        String objectType = (String) wbo.getAttribute("objectType");
        String parentId = (String) wbo.getAttribute("parentId");
        String issueTitle = (String) wbo.getAttribute("issueTitle");
        String statusNote = (String) wbo.getAttribute("statusNote");
        String causeDescription = (String) wbo.getAttribute("cuseDescription");
        String actionTaken = (String) wbo.getAttribute("actionTaken");
        String preventionTaken = (String) wbo.getAttribute("preventionTaken");

        return changeStatus1(statusCode, businessObjectId, objectType, date, parentId, createdBy, issueTitle,
                statusNote, causeDescription, actionTaken, preventionTaken, event);
    }

    public boolean changeStatus1(String statusCode, String businessObjectId, String objectType,
            String date, String parentId, String createdBy, String issueTitle, String statusNote,
            String causeDescription, String actionTaken, String preventionTaken, ActionEvent event) throws SQLException {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector issueStatusParameters = new Vector();
        Vector updateIssueStatusParameters = new Vector();
        int queryResult= -1;

        String statusId = UniqueIDGen.getNextID();
        // set up new issue status record
        issueStatusParameters.addElement(new StringValue(statusId));
        issueStatusParameters.addElement(new StringValue(statusCode));
        issueStatusParameters.addElement(new StringValue(issueTitle));
        issueStatusParameters.addElement(new StringValue(statusNote));
        issueStatusParameters.addElement(new StringValue(date));
        issueStatusParameters.addElement(new StringValue(causeDescription));
        issueStatusParameters.addElement(new StringValue(actionTaken));
        issueStatusParameters.addElement(new StringValue(preventionTaken));
        issueStatusParameters.addElement(new StringValue(businessObjectId));
        issueStatusParameters.addElement(new StringValue(objectType));
        issueStatusParameters.addElement(new StringValue(parentId));
        issueStatusParameters.addElement(new StringValue(createdBy));

        // set up update issue status record
        updateIssueStatusParameters.addElement(new StringValue(date));
        updateIssueStatusParameters.addElement(new StringValue(businessObjectId));
        updateIssueStatusParameters.addElement(new StringValue(objectType));

        try {
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            command.setConnection(connection);
            command.setSQLQuery(getQuery("updateEmployeeStatus"));
            command.setparams(updateIssueStatusParameters);
            queryResult = command.executeUpdate();
            if (queryResult < 0) {
                connection.rollback();
                return false;
            }
            try {
                Thread.sleep(50);
            } catch (InterruptedException ex) {
                connection.rollback();
                logger.error("Exception : " + ex.getMessage());
                return false;
            }

            command.setSQLQuery(getQuery("insertIssueStatus"));
            command.setparams(issueStatusParameters);
            queryResult = command.executeUpdate();
            if (queryResult < 0) {
                connection.rollback();
                return false;
            }
            try {
                Thread.sleep(50);
            } catch (InterruptedException ex) {
                connection.rollback();
                logger.error("Exception : " + ex.getMessage());
                return false;
            }
        } catch (SQLException ex) {
            logger.error("Exception : " + ex.getMessage());
            return false;
        } finally {
            connection.commit();
            connection.close();
        }

        // fire event
        if (event != null) {
            event.fire(statusCode, businessObjectId, createdBy);
        }

        return true;
    }

    public boolean isStatusExist(String businessObjectId, String objectType, String statusCode) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        Vector queryResult;

        parameters.addElement(new StringValue(businessObjectId));
        parameters.addElement(new StringValue(objectType));
        parameters.addElement(new StringValue(statusCode));

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("isStatusExist"));
            command.setparams(parameters);
            queryResult = command.executeQuery();
            if (!queryResult.isEmpty()) {
                return true;
            }
        } catch (SQLException ex) {
            logger.error("Exception : " + ex.getMessage());
            return false;
        } catch (UnsupportedTypeException ex) {
            logger.error("Exception : " + ex.getMessage());
            return false;
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex);
            }
        }

        return false;
    }

    public boolean deleteComp(String compId) throws SQLException {

        int queryResult = -1000;
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;
        Vector param = new Vector();
        param.addElement(new StringValue(compId));
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("deleteComp"));
            forQuery.setparams(param);
            queryResult = forQuery.executeUpdate();

        } catch (SQLException ex) {
            Logger.getLogger(IssueStatusMgr.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        } finally {
            connection.close();
        }

        return true;

    }

    public boolean closeSelectedComp(String ids) throws SQLException {

        int queryResult = -1000;
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;
        Vector param = new Vector();
        param.addElement(new StringValue(ids));
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("closeSelectedComp"));
            forQuery.setparams(param);
            queryResult = forQuery.executeUpdate();
            if (queryResult <= 0) {
                connection.rollback();
                return false;
            }
        } catch (SQLException ex) {
            Logger.getLogger(IssueStatusMgr.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        } finally {
            connection.commit();
            connection.close();

        }

        return true;

    }

    public WebBusinessObject getClosedMsg(String compId) {

        Connection connection = null;
        WebBusinessObject resultBusObj = null;

        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(compId));
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getClosedMsg").trim());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
            Row r = null;
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                resultBusObj = fabricateBusObj(r);
            }
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } catch (SQLException e) {
            logger.error(e.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return null;
            }
        }
        return resultBusObj;
    }

    public WebBusinessObject getFinishedMsg(String compId) {

        Connection connection = null;
        WebBusinessObject resultBusObj = null;

        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(compId));
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getFinishedMsg").trim());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
            Row r = null;
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                resultBusObj = fabricateBusObj(r);
            }
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } catch (SQLException e) {
            logger.error(e.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return null;
            }
        }
        return resultBusObj;
    }

    public WebBusinessObject getCompByStatusCode(String compId, String statusCode) {

        Connection connection = null;
        WebBusinessObject resultBusObj = new WebBusinessObject();

        Vector SQLparams = new Vector();

        SQLparams.addElement(new StringValue(compId));
        SQLparams.addElement(new StringValue(statusCode));
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getCompByStatusCode").trim());
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();
            if (queryResult != null & queryResult.size() > 0) {
                Row row = (Row) queryResult.get(0);
                String endDate = row.getString("end_date");
                String beginDate = row.getString("begin_date");
                if (endDate != null) {
                    resultBusObj.setAttribute("endDate", endDate);
                }
                if (beginDate != null) {
                    resultBusObj.setAttribute("beginDate", beginDate);
                }
            } else {
                return null;
            }
        } catch (NoSuchColumnException ex) {
            Logger.getLogger(IssueStatusMgr.class.getName()).log(Level.SEVERE, null, ex);
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } catch (SQLException e) {
            logger.error(e.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return null;
            }
        }
        return resultBusObj;
    }

    public Vector getClosedChilds(String parentId) {

        Connection connection = null;
        Vector reultBusObjs = new Vector();

        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(parentId));
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getClosedChilds").trim());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
            Row r = null;
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                WebBusinessObject issueStatusList = fabricateBusObj(r);
                reultBusObjs.add(issueStatusList);
            }
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } catch (SQLException e) {
            logger.error(e.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return null;
            }
        }
        return reultBusObjs;
    }

    public WebBusinessObject getRejectdMsg(String compId) {

        Connection connection = null;
        WebBusinessObject resultBusObj = null;

        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(compId));
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getRejectdMsg").trim());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
            Row r = null;
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                resultBusObj = fabricateBusObj(r);
            }
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } catch (SQLException e) {
            logger.error(e.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return null;
            }
        }
        return resultBusObj;
    }

    public Vector getStatusForObject(String objectId) {
        Vector parameters = new Vector();
        Connection connection = null;
        Vector queryResult;
        Vector result = new Vector();
        WebBusinessObject wbo;

        parameters.addElement(new StringValue(objectId));
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getStatusForObject").trim());
            forQuery.setparams(parameters);
            queryResult = forQuery.executeQuery();

            Row row;
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                try {
                    row = (Row) e.nextElement();
                    wbo = new WebBusinessObject();
                    if (row.getString("STATUS_ID") != null) {
                        wbo.setAttribute("statusID", row.getString("STATUS_ID"));
                    }
                    if (row.getString("FULL_NAME") != null) {
                        wbo.setAttribute("createdByName", row.getString("FULL_NAME"));
                    }
                    if (row.getTimestamp("BEGIN_DATE") != null) {
                        wbo.setAttribute("beginDate", row.getTimestamp("BEGIN_DATE"));
                    }
                    if (row.getTimestamp("END_DATE") != null) {
                        wbo.setAttribute("endDate", row.getTimestamp("END_DATE"));
                    }
                    if (row.getBigDecimal("DURATION") != null) {
                        wbo.setAttribute("duration", row.getBigDecimal("DURATION").intValue());
                    }
                    if (row.getString("STATUS_NOTE") == null || row.getString("STATUS_NOTE").equals("UL")) {
                        wbo.setAttribute("status", "---");
                    } else {
                        wbo.setAttribute("status", row.getString("STATUS_NOTE"));
                    }

                    if (row.getString("TYPE") != null) {
                        wbo.setAttribute("type", row.getString("TYPE"));
                    } else {
                        wbo.setAttribute("type", "---");
                    }
                    wbo.setAttribute("caseName", row.getString("CASE_NAME"));
                    result.add(wbo);
                } catch (UnsupportedConversionException ex) {
                    logger.error("***** " + ex.getMessage());
                }
            }
        } catch (SQLException ex) {
            logger.error("***** " + ex.getMessage());
        } catch (UnsupportedTypeException ex) {
            logger.error("***** " + ex.getMessage());
        } catch (NoSuchColumnException ex) {
            logger.error("***** " + ex.getMessage());
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

    public Vector getAllStatusForObject(String objectId) {
        Vector parameters = new Vector();
        Connection connection = null;
        Vector queryResult;
        Vector result = new Vector();
        WebBusinessObject wbo;

        parameters.addElement(new StringValue(objectId));
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getAllStatusForObject").trim());
            forQuery.setparams(parameters);
            queryResult = forQuery.executeQuery();

            Row row;
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                row = (Row) e.nextElement();
                wbo = fabricateBusObj(row);

                result.add(wbo);
            }
        } catch (SQLException ex) {
            logger.error("***** " + ex.getMessage());
        } catch (UnsupportedTypeException ex) {
            logger.error("***** " + ex.getMessage());
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

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
    }

    public ArrayList<WebBusinessObject> getStatusNotesByType(String userId, String statusCode, String comment, java.sql.Date fromDate, java.sql.Date toDate) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> rows;
        Vector parameters = new Vector();
        WebBusinessObject wbo;

        parameters.addElement(new StringValue(userId));
        parameters.addElement(new StringValue(statusCode));
        parameters.addElement(new DateValue(fromDate));
        parameters.addElement(new DateValue(toDate));
        StringBuilder commentQuery = new StringBuilder();
        if (comment != null && !comment.isEmpty()) {
            commentQuery.append(" and st.STATUS_NOTE like '%").append(comment).append("%'");
        }
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getStatusNotesByType").trim().replaceAll("commentQuery", commentQuery.toString()));
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
                    if (row.getString("BUSINESS_ID") != null) {
                        wbo.setAttribute("businessID", row.getString("BUSINESS_ID"));
                    }
                    if (row.getString("BUSINESS_ID_BY_DATE") != null) {
                        wbo.setAttribute("businessIDByDate", row.getString("BUSINESS_ID_BY_DATE"));
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

    public ArrayList<WebBusinessObject> getEmployeesLoadByStatus(String departmentId, String statusCode) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> rows;
        Vector parameters = new Vector();
        WebBusinessObject wbo;

        parameters.addElement(new StringValue(departmentId));
        parameters.addElement(new StringValue(departmentId));
        parameters.addElement(new StringValue(statusCode));
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getEmployeesLoadByStatus").trim());
            command.setparams(parameters);
            rows = command.executeQuery();

            ArrayList<WebBusinessObject> results = new ArrayList<>();
            for (Row row : rows) {
                try {
                    wbo = new WebBusinessObject();
                    if (row.getString("TOTAL") != null) {
                        wbo.setAttribute("total", row.getString("TOTAL"));
                    }
                    if (row.getString("FULL_NAME") != null) {
                        wbo.setAttribute("userName", row.getString("FULL_NAME"));
                    }
                    if (row.getString("CREATED_BY") != null) {
                        wbo.setAttribute("createdBy", row.getString("CREATED_BY"));
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

    public ArrayList<WebBusinessObject> getClosureNotesProductions(String groupId, String statusCode, java.sql.Date fromDate, java.sql.Date toDate) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> rows;
        Vector parameters = new Vector();
        WebBusinessObject wbo;

        parameters.addElement(new StringValue(statusCode));
        parameters.addElement(new StringValue(groupId));
        parameters.addElement(new DateValue(fromDate));
        parameters.addElement(new DateValue(toDate));
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getClosureNotesProductions").trim());
            command.setparams(parameters);
            rows = command.executeQuery();

            ArrayList<WebBusinessObject> results = new ArrayList<>();
            for (Row row : rows) {
                try {
                    wbo = fabricateBusObj(row);
                    if (row.getString("TOTAL") != null) {
                        wbo.setAttribute("total", row.getString("TOTAL"));
                    }
                    if (row.getString("USER_NAME") != null) {
                        wbo.setAttribute("userName", row.getString("USER_NAME"));
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

    public WebBusinessObject getLastStatusForObject(String objectID) {
        Connection connection = null;
        WebBusinessObject resultBusObj = null;
        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(objectID));
        Vector queryResult;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getLastStatusForObject").trim());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
            Row r;
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                resultBusObj = fabricateBusObj(r);
            }
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } catch (SQLException e) {
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return null;
            }
        }
        return resultBusObj;
    }
    
    public Vector<WebBusinessObject> getAllStatusForIssueAndDepCode(String issueID, String departmentCode) {
        Vector parameters = new Vector();
        Connection connection = null;
        Vector queryResult;
        Vector<WebBusinessObject> result = new Vector<>();
        WebBusinessObject wbo;

        parameters.addElement(new StringValue(issueID));
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getAllStatusForIssueAndDepCode").trim().replaceAll("departmentCode", departmentCode));
            forQuery.setparams(parameters);
            queryResult = forQuery.executeQuery();

            Row row;
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                row = (Row) e.nextElement();
                wbo = fabricateBusObj(row);

                result.add(wbo);
            }
        } catch (SQLException | UnsupportedTypeException ex) {
            logger.error("***** " + ex.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return null;
            }
        }
        return result;
    }
}
