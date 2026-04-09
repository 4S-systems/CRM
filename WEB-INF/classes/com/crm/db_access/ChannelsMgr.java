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
public class ChannelsMgr extends RDBGateWay implements Serializable {

    private static final ChannelsMgr channelsMgr = new ChannelsMgr();

    private ChannelsMgr() {
    }

    public static ChannelsMgr getInstance() {
        return channelsMgr;
    }

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("channels.xml")));
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

    public String saveObject(WebBusinessObject wbo, HttpSession session) throws Exception {
        WebBusinessObject user = (WebBusinessObject) session.getAttribute("loggedUser");

        String name = (String) wbo.getAttribute("name");
        String ownerId = (String) wbo.getAttribute("ownerId");

        return saveObject(name, ownerId);
    }

    public String saveObject(String name, String ownerId) throws Exception {
        return saveObject(name, ownerId, dataSource.getConnection());
    }

    public String saveObject(String name, String ownerId, Connection connection) throws Exception {
        Vector parameters = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        String id = UniqueIDGen.getNextID();
        parameters.addElement(new StringValue(id));
        parameters.addElement(new StringValue(name));
        parameters.addElement(new StringValue(ownerId));

        try {
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(getQuery("insert").trim());
            forInsert.setparams(parameters);
            queryResult = forInsert.executeUpdate();
        } catch (SQLException se) {
            logger.error("Exception inserting file descriptor: " + se.getMessage());
            return null;
        } finally {
            try {
                if (connection.getAutoCommit()) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error("Close Error");
                return null;
            }
        }

        return id;
    }

    public String updateObject(String name, String ownerId) throws Exception {
        return updateObject(name, ownerId, dataSource.getConnection());
    }

    public String updateObject(String id, String name, Connection connection) throws Exception {
        Vector parameters = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        parameters.addElement(new StringValue(name));
        parameters.addElement(new StringValue(id));

        try {
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(getQuery("update").trim());
            forInsert.setparams(parameters);
            queryResult = forInsert.executeUpdate();
        } catch (SQLException se) {
            logger.error("Exception inserting file descriptor: " + se.getMessage());
            return null;
        } finally {
            try {
                if (connection.getAutoCommit()) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error("Close Error");
                return null;
            }
        }

        return id;
    }

    public boolean saveObject(String name, String ownerId, String[] users) throws Exception {
        ChannelsUsersMgr channelsUsersMgr = ChannelsUsersMgr.getInstance();
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            String id = saveObject(name, ownerId, connection);
            connection.commit();
            for (String user : users) {
                channelsUsersMgr.saveObject(id, user, ownerId);
            }
        } finally {
            connection.commit();
            logger.info("Saved Channel Ok*********");
        }
        return true;
    }

    public boolean updateObject(String id, String name, String ownerId, String[] users) throws Exception {
        ChannelsUsersMgr channelsUsersMgr = ChannelsUsersMgr.getInstance();
        try {
            updateObject(id, name);
            channelsUsersMgr.deleteOnArbitraryKey(id, "key1");
            for (String user : users) {
                channelsUsersMgr.saveObject(id, user, ownerId);
            }
        } finally {
            logger.info("Saved Channel Ok*********");
        }
        return true;
    }
    
    public String[] getChannelsIds(String ownerId) throws SQLException {
        Connection connection = null;
        Vector<Row> queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector parameters = new Vector();
        parameters.addElement(new StringValue(ownerId));
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getChannelsIds").trim());
            forQuery.setparams(parameters);

            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            connection.close();
        }

        String[] ids = null;
        if (!queryResult.isEmpty()) {
            ids = new String[queryResult.size()];
            int index = 0;
            for (Row row : queryResult) {
                try {
                    ids[index] = row.getString("ID");
                    index++;
                } catch (NoSuchColumnException ex) {
                    logger.error(ex);
                }
            }
        }

        return ids;
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
