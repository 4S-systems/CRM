/*
 * FileMgr.java
 *
 * Created on March 25, 2005, 12:35 AM
 */
package com.crm.db_access;

import com.silkworm.business_objects.*;
import com.silkworm.persistence.relational.*;
import java.io.Serializable;
import java.sql.*;
import java.util.*;
import javax.servlet.http.HttpSession;
import org.apache.log4j.xml.DOMConfigurator;

/**
 *
 * @author Walid
 */
public class ChannelsUsersMgr extends RDBGateWay implements Serializable {

    private static final ChannelsUsersMgr CHANNELS_USERS_MGR = new ChannelsUsersMgr();

    private ChannelsUsersMgr() {
    }

    public static ChannelsUsersMgr getInstance() {
        return CHANNELS_USERS_MGR;
    }

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("channels_users.xml")));
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

    public boolean saveObject(WebBusinessObject wbo, HttpSession session) throws Exception {
        WebBusinessObject user = (WebBusinessObject) session.getAttribute("loggedUser");

        String channelsId = (String) wbo.getAttribute("channelsId");
        String usersId = (String) wbo.getAttribute("usersId");
        String createdBy = (String) user.getAttribute("userId");

        return saveObject(channelsId, usersId, createdBy);
    }

    public boolean saveObject(String channelsId, String usersId, String createdBy) throws Exception {
        return saveObject(channelsId, usersId, createdBy, dataSource.getConnection());
    }

    public boolean saveObject(String channelsId, String usersId, String createdBy, Connection connection) throws Exception {
        Vector parameters = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        parameters.addElement(new StringValue(channelsId));
        parameters.addElement(new StringValue(usersId));
        parameters.addElement(new StringValue(createdBy));

        try {
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(getQuery("insert").trim());
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

    public String[] getUsersIds(String... channelIds) throws SQLException {
        Connection connection = null;
        Vector<Row> queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        
        StringBuilder ids = new StringBuilder();
        int length = channelIds.length;
        for (int i = 0; i < length; i++) {
            ids.append(channelIds[i]);
            if (i < (length - 1)) {
                ids.append(",");
            }
        }

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getUsers").trim().replaceAll("IDS", ids.toString()));

            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            connection.close();
        }

        String[] users = null;
        if (!queryResult.isEmpty()) {
            users = new String[queryResult.size()];
            int index = 0;
            for (Row row : queryResult) {
                try {
                    users[index] = row.getString("USERS_ID");
                    index++;
                } catch (NoSuchColumnException ex) {
                    logger.error(ex);
                }
            }
        }

        return users;
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
}
