package com.maintenance.common;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;

import java.util.*;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.log4j.xml.DOMConfigurator;

public class UserCampaignConfigMgr extends RDBGateWay {

    private static final UserCampaignConfigMgr userCampaignConfigMgr = new UserCampaignConfigMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();

    public static UserCampaignConfigMgr getInstance() {
        logger.info("Getting UserCampaignConfigMgr Instance ....");
        return userCampaignConfigMgr;
    }

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("user_campaign_config.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue((String) wbo.getAttribute("campaignID")));
        params.addElement(new StringValue((String) wbo.getAttribute("userID")));
        params.addElement(new StringValue((String) wbo.getAttribute("createdBy")));
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(getQuery("insertUserGroupConfig").trim());
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
    public ArrayList getCashedTableAsArrayList() {
        cashData();
        return new ArrayList(cashedTable);
    }

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
    }

    public boolean saveUserCampaigns(String[] campaingIDs, String userID, String createdBy) throws SQLException {
        Vector params;
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(getQuery("insertUserCampaignConfig").trim());
            for (String campaignID : campaingIDs) {
                params = new Vector();
                params.addElement(new StringValue(UniqueIDGen.getNextID()));
                params.addElement(new StringValue(campaignID));
                params.addElement(new StringValue(userID));
                params.addElement(new StringValue(createdBy));
                forInsert.setparams(params);
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

    public ArrayList<WebBusinessObject> getAllUserCampaignConfig(String userID) {
        WebBusinessObject wbo = null;
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            params.addElement(new StringValue(userID));
            forQuery.setSQLQuery(getQuery("getAllUserCampaignConfig").trim());
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
        Row r;
        Enumeration e = queryResult.elements();
        ArrayList<WebBusinessObject> results = new ArrayList<>();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = fabricateBusObj(r);
            try {
                if (r.getString("CAMPAIGN_TITLE") != null) {
                    wbo.setAttribute("campaignTitle", r.getString("CAMPAIGN_TITLE"));
                }
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(UserCampaignConfigMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            results.add(wbo);
        }
        return results;
    }

    public ArrayList<WebBusinessObject> getCampaignsForUser(String userID) {
        WebBusinessObject wbo = null;
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            params.addElement(new StringValue(userID));
            forQuery.setSQLQuery(getQuery("getCampaignsForUser").trim());
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
        Row r;
        Enumeration e = queryResult.elements();
        ArrayList<WebBusinessObject> results = new ArrayList<>();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = fabricateBusObj(r);
            try {
                if (r.getString("CAMPAIGN_TITLE") != null) {
                    wbo.setAttribute("campaignTitle", r.getString("CAMPAIGN_TITLE"));
                }
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(UserCampaignConfigMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            results.add(wbo);
        }
        return results;
    }
    
    public ArrayList<String> getAllUserCampaignIDs(String userID) {
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            params.addElement(new StringValue(userID));
            forQuery.setSQLQuery(getQuery("getAllUserCampaignConfig").trim());
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
        Row r;
        Enumeration e = queryResult.elements();
        ArrayList<String> results = new ArrayList<>();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            try {
                results.add(r.getString("CAMPAIGN_ID"));
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(UserCampaignConfigMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return results;
    }
    
    public ArrayList<WebBusinessObject> getUserCampaigns() {
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getUserCampaigns").trim());
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
        Row r;
        Enumeration e = queryResult.elements();
        ArrayList<WebBusinessObject> results = new ArrayList<>();
        WebBusinessObject wbo;
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            try {
                wbo = fabricateBusObj(r);
                wbo.setAttribute("userName", r.getString("USER_NAME") != null ? r.getString("USER_NAME") : "");
                wbo.setAttribute("campaignTitle", r.getString("CAMPAIGN_TITLE") != null ? r.getString("CAMPAIGN_TITLE") : "");
                results.add(wbo);
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(UserCampaignConfigMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return results;
    }
}
