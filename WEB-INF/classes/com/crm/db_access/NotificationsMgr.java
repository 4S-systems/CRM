/*
 * FileMgr.java
 *
 * Created on March 25, 2005, 12:35 AM
 */
package com.crm.db_access;

import com.maintenance.common.DateParser;
import com.silkworm.business_objects.*;
import com.silkworm.persistence.relational.*;
import java.io.Serializable;
import java.sql.*;
import java.util.*;
import org.apache.log4j.xml.DOMConfigurator;

/**
 *
 * @author Walid
 */
public class NotificationsMgr extends RDBGateWay implements Serializable {

    private static final NotificationsMgr notificationsMgr = new NotificationsMgr();

    private NotificationsMgr() {
    }

    public static NotificationsMgr getInstance() {
        return notificationsMgr;
    }

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("notifications.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public Vector getNotificationsByIssueCreator(String issueCreator, String loggedUserID, java.sql.Date beginDate, java.sql.Date endDate) {
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector queryResult = new Vector();

        Vector parameters = new Vector();
        parameters.addElement(new StringValue(issueCreator));
        parameters.addElement(new DateValue(beginDate));
        parameters.addElement(new DateValue(endDate));
        parameters.addElement(new StringValue(loggedUserID));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getNotificationsByIssueCreator").trim());
            forQuery.setparams(parameters);
            queryResult = forQuery.executeQuery();
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

        Vector result = new Vector();
        Row row;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            row = (Row) e.nextElement();
            result.addElement(fabricateBusObj(row));
        }
        return result;
    }
    
    public Vector getNotificationsByIssueCreator2(String issueCreator) {
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector queryResult = new Vector();

        Vector parameters = new Vector();
        parameters.addElement(new StringValue(issueCreator));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getNotificationsByIssueCreator2"));
            forQuery.setparams(parameters);
            queryResult = forQuery.executeQuery();
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

        Vector result = new Vector();
        Row row;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            row = (Row) e.nextElement();
            result.addElement(fabricateBusObj(row));
        }
        return result;
    }
    
    public Vector getNotificationsByGroupMgr(String mgrId, int since) {
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector queryResult = new Vector();

        Vector parameters = new Vector();
        parameters.addElement(new StringValue(mgrId));
        parameters.addElement(new StringValue(mgrId));
        parameters.addElement(new StringValue(mgrId));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getNotificationByMgrGroup").replaceAll("WITH_IN", "" + since));
            forQuery.setparams(parameters);
            queryResult = forQuery.executeQuery();
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

        Vector result = new Vector();
        Row row;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            row = (Row) e.nextElement();
            result.addElement(fabricateBusObj(row));
        }
        return result;
    }

    public Vector getNotificationsByComplaintCode(String complaintCode, int within) {
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector queryResult = new Vector();

        String query = getQuery("getNotificationsByComplaintCode").replaceFirst("ccccc", complaintCode).trim();
        query = query.replaceFirst("no_of_hours", new Integer(within).toString());

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            queryResult = forQuery.executeQuery();
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

        Vector result = new Vector();
        Row row;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            row = (Row) e.nextElement();
            result.addElement(fabricateBusObj(row));
        }
        return result;
    }
    
    @Override
    public ArrayList getCashedTableAsArrayList() {
        return cashedData;
    }

    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
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
    
    private java.sql.Date getSqlBeginDate(String date) {
        DateParser parser = new DateParser();
        java.sql.Date sqlDate = parser.formatSqlDate(date);

        return sqlDate;
    }
    
    public ArrayList<WebBusinessObject> getAllNotifications(String fromDate, String toDate, ArrayList<WebBusinessObject> usrDprtmntCnfgLst) {
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector queryResult = new Vector();
        Connection connection = null;
        
        Vector parameters = new Vector();

        parameters.addElement(new DateValue(getSqlBeginDate(fromDate)));
        parameters.addElement(new DateValue(getSqlBeginDate(toDate)));
        
        StringBuilder dprtmntCnfgCon = new StringBuilder();
        if(usrDprtmntCnfgLst != null && usrDprtmntCnfgLst.size() > 0){
            dprtmntCnfgCon.append("AND SUBSTR(BUSINESS_COMP_ID, 0, INSTR(BUSINESS_COMP_ID, '-')-1) IN (SELECT EQ_NO FROM PROJECT WHERE PROJECT_ID IN (");
            for (int i = 0; i < usrDprtmntCnfgLst.size(); i++) {
                if(i==0){
                    dprtmntCnfgCon.append("?");
                    parameters.addElement(new StringValue(usrDprtmntCnfgLst.get(i).getAttribute("department_id").toString()));
                } else {
                    dprtmntCnfgCon.append(", ?");
                    parameters.addElement(new StringValue(usrDprtmntCnfgLst.get(i).getAttribute("department_id").toString()));
                }
            }
            
            dprtmntCnfgCon.append("))");
        }
        
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getAllNotifications").replaceAll("dprtmntCnfgCon", dprtmntCnfgCon.toString()).trim());
            forQuery.setparams(parameters);
            queryResult = forQuery.executeQuery();
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
        ArrayList<WebBusinessObject> result = new ArrayList<WebBusinessObject>();
        Row row;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            row = (Row) e.nextElement();
            result.add(fabricateBusObj(row));
        }
        return result;
    }
    
    public Vector getNotificationsByOwner(String currentOwner, String loggedUserID, java.sql.Date beginDate, java.sql.Date endDate) {
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector queryResult = new Vector();

        Vector parameters = new Vector();
        parameters.addElement(new StringValue(currentOwner));
        parameters.addElement(new DateValue(beginDate));
        parameters.addElement(new DateValue(endDate));
        parameters.addElement(new StringValue(loggedUserID));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getNotificationsByOwner").trim());
            forQuery.setparams(parameters);
            queryResult = forQuery.executeQuery();
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

        Vector result = new Vector();
        Row row;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            row = (Row) e.nextElement();
            result.addElement(fabricateBusObj(row));
        }
        return result;
    }
}
