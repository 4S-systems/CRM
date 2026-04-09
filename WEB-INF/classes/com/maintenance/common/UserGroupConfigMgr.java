package com.maintenance.common;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;

import java.util.*;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.log4j.xml.DOMConfigurator;

public class UserGroupConfigMgr extends RDBGateWay {

    private static final UserGroupConfigMgr userGroupConfigMgr = new UserGroupConfigMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();

    public static UserGroupConfigMgr getInstance() {
        logger.info("Getting UserGroupConfigMgr Instance ....");
        return userGroupConfigMgr;
    }

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("user_group_config.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public WebBusinessObject getUserGroupConfig(String userID, String groupID) {
        WebBusinessObject wbo = null;
        Connection connection = null;
        Vector queryResult = null;
        
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            params.addElement(new StringValue(groupID));
            params.addElement(new StringValue(userID));
            forQuery.setSQLQuery(sqlMgr.getSql("getUserGroupConfig").trim());
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
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = fabricateBusObj(r);
            return wbo;
        }
        return wbo;
    }

    public ArrayList<WebBusinessObject> getAllUserGroupConfig(String userID) {
        WebBusinessObject wbo = null;
        Connection connection = null;
        Vector queryResult = null;

        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            params.addElement(new StringValue(userID));
            forQuery.setSQLQuery(sqlMgr.getSql("getAllUserGroupConfig").trim());
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
                if (r.getString("GROUP_NAME") != null) {
                    wbo.setAttribute("groupName", r.getString("GROUP_NAME"));
                }
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(UserGroupConfigMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            results.add(wbo);
        }
        return results;
    }
    
    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }
    
    public boolean saveUserGroupsConfig(WebBusinessObject wbo) {
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue((String) wbo.getAttribute("groupId")));
        params.addElement(new StringValue((String) wbo.getAttribute("userId")));
        params.addElement(new StringValue((String) wbo.getAttribute("isDefualt")));
              
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertUserGroupConfig").trim());
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
        return null;
    }

    @Override
    protected void initSupportedQueries() {
        //throw new UnsupportedOperationException("Not supported yet.");
    }
}
