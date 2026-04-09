package com.maintenance.db_access;

import com.silkworm.business_objects.*;
import com.silkworm.persistence.relational.*;
import java.sql.*;
import java.util.*;
import org.apache.log4j.xml.DOMConfigurator;

public class DistributionListMgr extends RDBGateWay {

    private static DistributionListMgr distributionListMgr = new DistributionListMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();

    public static DistributionListMgr getInstance() {
        logger.info("Getting distributedItemsMgr Instance ....");
        return distributionListMgr;
    }

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("distribution_list.xml")));
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

        cashedData = new ArrayList();
        WebBusinessObject wbo = null;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add((String) wbo.getAttribute("itemCode"));
        }

        return cashedData;
    }

    public WebBusinessObject getLastOwnerForComp(String clientComId) throws NoSuchColumnException {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector SQLparams = new Vector();
        Vector queryResult = null;

        SQLparams.addElement(new StringValue(clientComId));

        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();

            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getLastOwnerForComp").trim());
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

        Row row;
        Enumeration e = queryResult.elements();
        wbo = new WebBusinessObject();
        while (e.hasMoreElements()) {
            row = (Row) e.nextElement();
            String receipId = row.getString(1);
            wbo.setAttribute("receipId", receipId);
        }
        return wbo;
    }

    public WebBusinessObject getDistributionListInfoByComplaintId(String clientComplaintId) throws NoSuchColumnException {
        WebBusinessObject wbo;
        Connection connection = null;
        Vector SQLparams = new Vector();
        Vector queryResult = null;

        SQLparams.addElement(new StringValue(clientComplaintId));

        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();

            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getDistributionListInfoByComplaintId").trim());
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

        Enumeration e = queryResult.elements();
        wbo = new WebBusinessObject();
        while (e.hasMoreElements()) {
            wbo = fabricateBusObj((Row) e.nextElement());
            break;
        }
        return wbo;
    }

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
    }
    
    public ArrayList<WebBusinessObject> getComplaintsPerProject(String projectID, String ticketType, String startDate, String endDate) {

        WebBusinessObject wbo;
        Connection connection = null;

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            params.addElement(new StringValue(projectID));
            params.addElement(new StringValue(ticketType));
            String sql = getQuery("getComplaintPerProject").trim();
            StringBuilder where = new StringBuilder();
            if (startDate != null && !startDate.isEmpty()) {
                where.append(" and issue_date >= ?");
                params.addElement(new TimestampValue(java.sql.Timestamp.valueOf(startDate + " 00:00:01")));
            }
            if (endDate != null && !endDate.isEmpty()) {
                where.append(" and issue_date <= ?");
                params.addElement(new TimestampValue(java.sql.Timestamp.valueOf(endDate + " 23:59:59")));
            }
            forQuery.setSQLQuery(sql.replace("where_between_date", where.toString()));
            forQuery.setparams(params);
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
        ArrayList<WebBusinessObject> resultBusObjs = new ArrayList<WebBusinessObject>();

        Row r = null;
        if (queryResult != null) {
            Enumeration e = queryResult.elements();

            try {
                while (e.hasMoreElements()) {
                    r = (Row) e.nextElement();
                    wbo = new WebBusinessObject();
                    wbo.setAttribute("complaintCount", r.getString("complaint_count"));
                    wbo.setAttribute("complaint", r.getString("complaint"));
                    resultBusObjs.add(wbo);
                }

            } catch (NoSuchColumnException ce) {
                logger.error(ce);
            }
        }
        return resultBusObjs;
    }
    
    public ArrayList<WebBusinessObject> getProjectPerformance(String projectID, String ticketType, String startDate, String endDate) {

        WebBusinessObject wbo;
        Connection connection = null;

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            params.addElement(new StringValue(ticketType));
            String sql = getQuery("getProjectPerformance").trim();
            StringBuilder where = new StringBuilder();
            if (projectID != null && !projectID.isEmpty()) {
                where.append(" and PRODUCT_CATEGORY_ID = ?");
                params.addElement(new StringValue(projectID));
            }
            if (startDate != null && !startDate.isEmpty()) {
                where.append(" and issue_date >= ?");
                params.addElement(new TimestampValue(java.sql.Timestamp.valueOf(startDate + " 00:00:01")));
            }
            if (endDate != null && !endDate.isEmpty()) {
                where.append(" and issue_date <= ?");
                params.addElement(new TimestampValue(java.sql.Timestamp.valueOf(endDate + " 23:59:59")));
            }
            forQuery.setSQLQuery(sql.replace("where_project_and_between_date", where.toString()));
            forQuery.setparams(params);
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
        ArrayList<WebBusinessObject> resultBusObjs = new ArrayList<WebBusinessObject>();

        Row r = null;
        if (queryResult != null) {
            Enumeration e = queryResult.elements();

            try {
                while (e.hasMoreElements()) {
                    r = (Row) e.nextElement();
                    wbo = new WebBusinessObject();
                    wbo.setAttribute("complaintCount", r.getString("complaint_count"));
                    wbo.setAttribute("urgency", r.getString("urgency"));
                    resultBusObjs.add(wbo);
                }

            } catch (NoSuchColumnException ce) {
                logger.error(ce);
            }
        }
        return resultBusObjs;
    }

    public String getLastResponsibleEmployee(String clientId) {
        SQLCommandBean command;
        Connection connection = null;
        Vector<Row> result;
        Vector parameters = new Vector();

        parameters.addElement(new StringValue(clientId));
        try {
            connection = dataSource.getConnection();
            command = new SQLCommandBean();
            command.setConnection(connection);
            command.setparams(parameters);
            command.setSQLQuery(getQuery("getLastResponsibleEmployee").trim());
            result = command.executeQuery();
            for (Row row : result) {
                try {
                    return row.getString("RECEIP_ID");
                } catch (NoSuchColumnException ex) {
                    logger.error("***** " + ex.getMessage());
                }
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
                logger.error("***** " + ex.getMessage());
            }
        }

        return null;
    }
    
    public boolean updateResponsible(String clientComplaintId, String userId) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector updateCurrentOwnerClientComplaintParameters = new Vector();
        int queryResult = -1000;

        updateCurrentOwnerClientComplaintParameters = new Vector();
        updateCurrentOwnerClientComplaintParameters.addElement(new StringValue(userId));
        updateCurrentOwnerClientComplaintParameters.addElement(new StringValue(clientComplaintId));

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("updateResponsible").trim());
            command.setparams(updateCurrentOwnerClientComplaintParameters);
            queryResult = command.executeUpdate();
        } catch (SQLException ex) {
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
        return (queryResult > 0);
    }
    
    public boolean updateMgr(WebBusinessObject wbo) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        int queryResult = -1000;
	
        parameters.addElement(new StringValue(wbo.getAttribute("firstEmpId").toString()));
        parameters.addElement(new StringValue(wbo.getAttribute("oldMgr").toString()));
	parameters.addElement(new StringValue(wbo.getAttribute("secondEmpId").toString()));

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("updateMgr").trim());
            command.setparams(parameters);
            queryResult = command.executeUpdate();
        } catch (SQLException ex) {
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
        return (queryResult > 0);
    }
    
    public boolean changeUserManager(String managerID, String userID) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector params = new Vector();
        int queryResult = -1000;

        params = new Vector();
        params.addElement(new StringValue(managerID));
        params.addElement(new StringValue(userID));

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("updateSenderManager").trim());
            command.setparams(params);
            queryResult = command.executeUpdate();
            if (queryResult < 0) {
                connection.rollback();
                return false;
            }
            params.addElement(new StringValue(userID));
            command.setSQLQuery(getQuery("updateRecipientManager").trim());
            queryResult = command.executeUpdate();
        } catch (SQLException ex) {
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
        return (queryResult > 0);
    }
    
    public boolean changeUserManagerN(String managerID, String userID) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector params = new Vector();
        int queryResult = -1000;

        params = new Vector();
        params.addElement(new StringValue(managerID));
        params.addElement(new StringValue(userID));

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("updateSenderManagerN").trim());
            command.setparams(params);
            queryResult = command.executeUpdate();
            if (queryResult < 0) {
                connection.rollback();
                return false;
            }
            
        } catch (SQLException ex) {
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
        return (queryResult > 0);
    }
            
    public ArrayList<WebBusinessObject> getDistributionListByIssueID(String issueID) {
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            params.addElement(new StringValue(issueID));
            forQuery.setSQLQuery(getQuery("getDistributionListByIssueID").trim());
            forQuery.setparams(params);
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
        ArrayList<WebBusinessObject> result = new ArrayList<>();
        if (queryResult != null) {
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                result.add(fabricateBusObj((Row) e.nextElement()));
            }
        }
        return result;
    }
}
