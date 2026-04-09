package com.tracker.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.common.SecurityUser;
import com.silkworm.persistence.relational.StringValue;
import java.util.*;
import java.sql.*;
import javax.servlet.http.HttpSession;
import org.apache.log4j.xml.DOMConfigurator;

public class ClientCampaignMgr extends RDBGateWay {

    private static final ClientCampaignMgr clientCampaignMgr = new ClientCampaignMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();

    public ClientCampaignMgr() {
    }

    public static ClientCampaignMgr getInstance() {
        logger.info("Getting ClientCampaignMgr Instance ....");
        return clientCampaignMgr;
    }

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("client_campaign.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public boolean saveCampaignsByClient(String clientID, String[] campaignIDs, String[] campaignReferences, String[] businessObjIDs, String[] businessObjTypes, HttpSession s, boolean cleanInsert) {

        int queryResult = -1000;
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();

        SecurityUser securityUser = (SecurityUser) s.getAttribute("securityUser");
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            forInsert.setConnection(connection);

            // Delete old Client's Campaigns
            if (cleanInsert) {
                params = new Vector();
                params.addElement(new StringValue(clientID));
                forInsert.setparams(params);

                forInsert.setSQLQuery(getQuery("deleteOldClientCampaigns").trim());
                queryResult = forInsert.executeUpdate();
            }

            String sql = getQuery("saveClientCampaigns").trim();
            forInsert.setSQLQuery(sql);
            int i = 0;
            for (String campaignID : campaignIDs) {
                params = new Vector();
                params.addElement(new StringValue(UniqueIDGen.getNextID()));
                params.addElement(new StringValue(clientID));
                params.addElement(new StringValue(campaignID));
                if (campaignReferences.length > i) {
                    params.addElement(new StringValue(campaignReferences[i]));
                } else {
                    params.addElement(new StringValue(""));
                }
                if (businessObjIDs.length > i) {
                    params.addElement(new StringValue(businessObjIDs[i]));
                } else {
                    params.addElement(new StringValue(""));
                }
                if (businessObjTypes.length > i) {
                    params.addElement(new StringValue(businessObjTypes[i]));
                } else {
                    params.addElement(new StringValue(""));
                }
                params.addElement(new StringValue(securityUser.getUserId()));
                forInsert.setparams(params);
                try {
                    queryResult = forInsert.executeUpdate();
                    if (queryResult <= 0) {
                        connection.rollback();
//                    return false;
                    }
                } catch (SQLException se) {

                }
                try {
                    Thread.sleep(100);
                } catch (InterruptedException ex) {
                    logger.error(ex.getMessage());
                }
                i++;
            }
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } finally {
            try {
                if (connection != null) {
                    connection.commit();
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error("Close Error");
                return false;
            }
        }

        return (queryResult > 0);
    }

    public boolean saveSourceByClient(String clientID, String sourceClient) {

        int queryResult = -1000;
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            forInsert.setConnection(connection);

            String sql = getQuery("saveSourceClient").trim();
            forInsert.setSQLQuery(sql);
            params.addElement(new StringValue(clientID));
            params.addElement(new StringValue(sourceClient));
                
            forInsert.setparams(params);
                try {
                    queryResult = forInsert.executeUpdate();
                    if (queryResult <= 0) {
                        connection.rollback();
//                    return false;
                    }
                } catch (SQLException se) {

                }
                try {
                    Thread.sleep(100);
                } catch (InterruptedException ex) {
                    logger.error(ex.getMessage());
                }
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } finally {
            try {
                if (connection != null) {
                    connection.commit();
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error("Close Error");
                return false;
            }
        }

        return (queryResult > 0);
    }

    
    public ArrayList<WebBusinessObject> getCampaignsByClientList(String clientId) {
        ArrayList<WebBusinessObject> campaignsByClientList = new ArrayList<WebBusinessObject>();
        Row r;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;
        Enumeration e = null;
        Vector params = new Vector();

        params.addElement(new StringValue(clientId));

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getCampaignsByClient").trim());
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
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
        if (queryResult != null) {
            e = queryResult.elements();

            try {
                while (e.hasMoreElements()) {
                    r = (Row) e.nextElement();
                    WebBusinessObject wbo = fabricateBusObj(r);
                    wbo.setAttribute("campaignID", r.getString("ID"));
                    wbo.setAttribute("campaignTitle", r.getString("CAMPAIGN_TITLE"));
                    if (r.getString("REFERENCE") != null) {
                        wbo.setAttribute("reference", r.getString("REFERENCE"));
                    } else {
                        wbo.setAttribute("reference", "");
                    }
                    if (r.getString("BUSINESS_OBJ_ID") != null) {
                        wbo.setAttribute("businessObjID", r.getString("BUSINESS_OBJ_ID"));
                    } else {
                        wbo.setAttribute("businessObjID", "");
                    }
                    if (r.getString("BUSINESS_OBJ_TYPE") != null) {
                        wbo.setAttribute("businessObjType", r.getString("BUSINESS_OBJ_TYPE"));
                    } else {
                        wbo.setAttribute("businessObjType", "");
                    }
                    if (r.getString("CREATED_BY_NAME") != null) {
                        wbo.setAttribute("createdByName", r.getString("CREATED_BY_NAME"));
                    } else {
                        wbo.setAttribute("createdByName", "");
                    }
                    campaignsByClientList.add(wbo);
                }

            } catch (NoSuchColumnException ce) {
                logger.error(ce);
            }
        }
        return campaignsByClientList;

    }

    public ArrayList<WebBusinessObject> getClientsByCampaignList(String campaignId, String startDate, String endDate) {
        ArrayList<WebBusinessObject> clientsByCampaignList = new ArrayList<WebBusinessObject>();
        Row r;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;
        Enumeration e = null;
        Vector params = new Vector();

        params.addElement(new StringValue(campaignId));

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            StringBuilder sql = new StringBuilder(getQuery("getClientsByCampaign").trim());
            if(startDate != null && !startDate.isEmpty()) {
                sql.append(" and cc.CREATION_TIME >= ?");
                params.addElement(new TimestampValue(java.sql.Timestamp.valueOf(startDate + " 00:00:01")));
            }
            if(endDate != null && !endDate.isEmpty()) {
                sql.append(" and cc.CREATION_TIME <= ?");
                params.addElement(new TimestampValue(java.sql.Timestamp.valueOf(endDate + " 23:59:59")));
            }
            forQuery.setSQLQuery(sql.toString());
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } catch(IllegalArgumentException ie) {
            logger.error("***** " + ie.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }
        if (queryResult != null) {
            e = queryResult.elements();

            try {
                while (e.hasMoreElements()) {
                    r = (Row) e.nextElement();
                    WebBusinessObject wbo = new WebBusinessObject();
                    wbo.setAttribute("clientID", r.getString("SYS_ID"));
                    wbo.setAttribute("clientNo", r.getString("CLIENT_NO"));
                    wbo.setAttribute("clientName", r.getString("NAME"));
                    wbo.setAttribute("createdBy", r.getString("CREATED_BY"));
                    wbo.setAttribute("mobile", r.getString("MOBILE"));
                    wbo.setAttribute("interPhone", r.getString("INTER_PHONE") != null ? r.getString("INTER_PHONE") : "");
                    
                    clientsByCampaignList.add(wbo);
                }

            } catch (NoSuchColumnException ce) {
                logger.error(ce);
            }
        }
        return clientsByCampaignList;

    }
    
   


    
     public String  getCompainID(String campaignId) {
        Row r;
        String res="";
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;
        Enumeration e = null;
        Vector params = new Vector();
       // String s1="select "
        params.addElement(new StringValue(campaignId));

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            StringBuilder sql = new StringBuilder(getQuery("getClientsByCampaign").trim());
           
            forQuery.setSQLQuery("Select ID from CAMPAIGN WHERE TOOL_ID=?");
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } catch(IllegalArgumentException ie) {
            logger.error("***** " + ie.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }
        if (queryResult != null) {
            e = queryResult.elements();

            try {
                while (e.hasMoreElements()) {
                    r = (Row) e.nextElement();

                    res= r.getString("ID");
                    
                }

            } catch (NoSuchColumnException ce) {
                logger.error(ce);
            }
        }
        return res;

    }

    public ArrayList<String> getCampaignIDsByClientList(String clientId) {
        ArrayList<String> campaignIDsByClientList = new ArrayList<String>();
        Row r;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;
        Enumeration e = null;
        Vector params = new Vector();

        params.addElement(new StringValue(clientId));

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getCampaignsByClient").trim());
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
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
        if (queryResult != null) {
            e = queryResult.elements();

            try {
                while (e.hasMoreElements()) {
                    r = (Row) e.nextElement();
                    campaignIDsByClientList.add(r.getString("ID"));
                }

            } catch (NoSuchColumnException ce) {
                logger.error(ce);
            }
        }
        return campaignIDsByClientList;

    }
        
    public boolean deleteClientsCampaign(String clientIDs, String campaignID) throws SQLException {
        Connection connection = null;
        Vector params = new Vector();
        params.add(new StringValue(campaignID));
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;
        try {
            connection = dataSource.getConnection();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(getQuery("deleteClientsCampaign").replace("clientIDs", clientIDs));
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();
        } catch (SQLException se) {
            logger.error("database error " + se.getMessage());
            if (connection != null) {
                connection.rollback();
            }
            return false;
        } finally {
            try {
                if (connection != null) {
                    connection.commit();
                    connection.close();
                }
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return false;
            }
        }
        return (queryResult > 0);
    }
    
    public ArrayList<WebBusinessObject> getRepeatedCampaigns(Timestamp fromDate, Timestamp toDate) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> result;
        Vector parameters = new Vector();
        String query = getQuery("getRepeatedCampaigns").trim();
        StringBuilder where = new StringBuilder();
        if (fromDate != null) {
            where.append(" WHERE TRUNC(CC.CREATION_TIME) >= ?");
            parameters.addElement(new TimestampValue(fromDate));
        }
        if (toDate != null) {
            if (where.toString().isEmpty()) {
                where.append(" WHERE ");
            } else {
                where.append(" AND ");
            }
            where.append(" TRUNC(CC.CREATION_TIME) <= ?");
            parameters.addElement(new TimestampValue(toDate));
        }
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(query.replaceAll("whereStatement", where.toString()));
            command.setparams(parameters);
            result = command.executeQuery();

            ArrayList<WebBusinessObject> data = new ArrayList<>();
            WebBusinessObject wbo;
            for (Row row : result) {
                wbo = fabricateBusObj(row);
                try {
                    if (row.getString("NAME") != null) {
                        wbo.setAttribute("clientName", row.getString("NAME"));
                    } else {
                        wbo.setAttribute("clientName", "");
                    }
                    if (row.getString("MOBILE") != null) {
                        wbo.setAttribute("mobile", row.getString("MOBILE"));
                    } else {
                        wbo.setAttribute("mobile", "");
                    }
                    if (row.getString("PHONE") != null) {
                        wbo.setAttribute("phone", row.getString("PHONE"));
                    } else {
                        wbo.setAttribute("phone", "");
                    }
                    if (row.getString("INTER_PHONE") != null) {
                        wbo.setAttribute("interPhone", row.getString("INTER_PHONE"));
                    } else {
                        wbo.setAttribute("interPhone", "");
                    }
                    if (row.getBigDecimal("CAMPAIGN_COUNT") != null) {
                        wbo.setAttribute("campaignCount", row.getString("CAMPAIGN_COUNT"));
                    } else {
                        wbo.setAttribute("campaignCount", "0");
                    }
                    
                } catch (NoSuchColumnException | UnsupportedConversionException ex) {
                }
                data.add(wbo);
            }
            return data;
        } catch (UnsupportedTypeException | SQLException ex) {
            logger.error("database error " + ex.getMessage());
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
    
    public boolean linkClientsToCampaign(String[] clientIDs, String campaignID, String userID) {
        int queryResult = -1000;
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            forInsert.setConnection(connection);
            String sql = getQuery("saveClientCampaigns").trim();
            forInsert.setSQLQuery(sql);
            int i = 0;
            for (String clientID : clientIDs) {
                params = new Vector();
                params.addElement(new StringValue(UniqueIDGen.getNextID()));
                params.addElement(new StringValue(clientID));
                params.addElement(new StringValue(campaignID));
                params.addElement(new StringValue(""));
                params.addElement(new StringValue(""));
                params.addElement(new StringValue(""));
                params.addElement(new StringValue(userID));
                forInsert.setparams(params);
                try {
                    queryResult = forInsert.executeUpdate();
                    if (queryResult <= 0) {
                        connection.rollback();
                    }
                } catch (SQLException se) {
                }
                try {
                    Thread.sleep(100);
                } catch (InterruptedException ex) {
                    logger.error(ex.getMessage());
                }
                i++;
            }
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } finally {
            try {
                if (connection != null) {
                    connection.commit();
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error("Close Error");
                return false;
            }
        }
        return (queryResult > 0);
    }
    
    public boolean updateClientsCampaign(String[] clientIDs, String newCampaignID, String oldCampaignID) {
        int queryResult = -1000;
        Vector params = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            forUpdate.setConnection(connection);
            String sql = getQuery("updateClientCampaign").trim();
            forUpdate.setSQLQuery(sql);
            int i = 0;
            for (String clientID : clientIDs) {
                params = new Vector();
                params.addElement(new StringValue(newCampaignID));
                params.addElement(new StringValue(clientID));
                params.addElement(new StringValue(oldCampaignID));
                forUpdate.setparams(params);
                try {
                    queryResult = forUpdate.executeUpdate();
                    if (queryResult <= 0) {
                        connection.rollback();
                    }
                } catch (SQLException se) {
                }
                try {
                    Thread.sleep(100);
                } catch (InterruptedException ex) {
                    logger.error(ex.getMessage());
                }
                i++;
            }
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } finally {
            try {
                if (connection != null) {
                    connection.commit();
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error("Close Error");
                return false;
            }
        }
        return (queryResult > 0);
    }
    
    public ArrayList<WebBusinessObject> getCampaignWboByClientList(String clientId, String campID) {
        ArrayList<WebBusinessObject> campaignIDsByClientList = new ArrayList<WebBusinessObject>();
        Row r;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;
        Enumeration e = null;
        Vector params = new Vector();

        params.addElement(new StringValue(clientId));
        params.addElement(new StringValue(campID));

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getCampaignWboByClientList").trim());
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
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
        if (queryResult != null) {
            e = queryResult.elements();

            try {
                while (e.hasMoreElements()) {
                    r = (Row) e.nextElement();
                    WebBusinessObject wbo = fabricateBusObj(r);
                    wbo.setAttribute("id", r.getString("ID"));
                    wbo.setAttribute("createdByName", r.getString("CREATED_BY_NAME"));
                    wbo.setAttribute("clntCmpID", r.getString("clntCmpID"));
                    campaignIDsByClientList.add(wbo);
                }

            } catch (NoSuchColumnException ce) {
                logger.error(ce);
            }
        }
        return campaignIDsByClientList;

    }
    
    public boolean removeClientCampaign(String[] clntCmpIDs) throws SQLException {
        Connection connection = null;
        Vector params = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;
        StringBuilder clntCmpIDStr = new StringBuilder();
        for(int i=0; i<clntCmpIDs.length; i++){
            if(i==0){
                clntCmpIDStr.append("?");
            } else {
                clntCmpIDStr.append(", ?");
            }
            params.addElement(new StringValue(clntCmpIDs[i]));
        }
        try {
            connection = dataSource.getConnection();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(getQuery("removeClientCampaign").replace("clntCmpIDStr", clntCmpIDStr.toString()));
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();
        } catch (SQLException se) {
            logger.error("database error " + se.getMessage());
            if (connection != null) {
                connection.rollback();
            }
            return false;
        } finally {
            try {
                if (connection != null) {
                    connection.commit();
                    connection.close();
                }
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return false;
            }
        }
        return (queryResult > 0);
    }

    @Override
    public ArrayList getCashedTableAsBusObjects() {
        cashedData = new ArrayList();
        WebBusinessObject wbo;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add(wbo);
        }

        return cashedData;
    }

    @Override
    public ArrayList getCashedTableAsArrayList() {

        cashedData = new ArrayList();
        return cashedData;
    }

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
    }
}
