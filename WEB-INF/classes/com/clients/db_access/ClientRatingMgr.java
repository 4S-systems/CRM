package com.clients.db_access;
 
import com.silkworm.business_objects.BusinessForm;
import com.silkworm.business_objects.DOMFabricatorBean;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.persistence.relational.Column;
import com.silkworm.persistence.relational.DateValue;
import com.silkworm.persistence.relational.NoSuchColumnException;
import com.silkworm.persistence.relational.RDBGateWay;
import com.silkworm.persistence.relational.Row;
import com.silkworm.persistence.relational.SQLCommandBean;
import com.silkworm.persistence.relational.StringValue;
import com.silkworm.persistence.relational.UniqueIDGen;
import com.silkworm.persistence.relational.UnsupportedConversionException;
import com.silkworm.persistence.relational.UnsupportedTypeException;
import com.tracker.db_access.CampaignMgr;
import com.tracker.db_access.ProjectMgr;
import java.sql.Connection;
import java.sql.Date;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.log4j.xml.DOMConfigurator;

public class ClientRatingMgr extends RDBGateWay {

    public static ClientRatingMgr clientRatingMgr = new ClientRatingMgr();

    public static ClientRatingMgr getInstance() {
        logger.info("Getting ClientRatingMgr Instance ....");
        return clientRatingMgr;
    }

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("client_rating.xml")));
                System.out.println("reading Successfully xml files....!");
            } catch (Exception e) {
                System.out.println("Error in reading xml files....!");
            }
        }
    }

    @Override
    public boolean saveObject(WebBusinessObject wbo) {
        String rateID = null;
        ProjectMgr projectMgr = ProjectMgr.getInstance();
        int queryResult = -1000;
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        Connection connection = null;
        String id = UniqueIDGen.getNextID();
        wbo.setAttribute("id", id);
        params.addElement(new StringValue(id));
        params.addElement(new StringValue((String) wbo.getAttribute("clientID")));
        if(wbo.getAttribute("rateID") != null && wbo.getAttribute("rateID").equals("Interested")){
            try {
                ArrayList<WebBusinessObject> rateLst = projectMgr.getOnArbitraryKey2((String)wbo.getAttribute("rateID"), "key1");
                if(rateLst.size() > 0){
                    rateID =rateLst.get(0).getAttribute("projectID").toString();
                }
                
            } catch (Exception ex) {
                Logger.getLogger(ClientRatingMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            params.addElement(new StringValue(rateID));
        } else {
            params.addElement(new StringValue((String) wbo.getAttribute("rateID")));
        }
        params.addElement(new StringValue((String) wbo.getAttribute("createdBy")));
        params.addElement(new StringValue((String) wbo.getAttribute("option1")));
        params.addElement(new StringValue((String) wbo.getAttribute("option2")));
        params.addElement(new StringValue((String) wbo.getAttribute("option3")));
        try {
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            forInsert.setConnection(connection);
            String sql = getQuery("insertClientRating").trim();
            forInsert.setSQLQuery(sql);
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            forInsert.setSQLQuery(getQuery("insertRatingHistory").trim());
            queryResult = forInsert.executeUpdate();
            forInsert.setSQLQuery(sql);
            if (queryResult <= 0) {
                connection.rollback();
                return false;
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

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
    }

    @Override
    public ArrayList getCashedTableAsArrayList() {
        ArrayList al = null;
        return al;
    }

    public ArrayList<WebBusinessObject> getClientsCountRate(String userId) {

        WebBusinessObject wbo;
        Connection connection = null;

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            String sql = getQuery("clientRateReport").trim();

            params.addElement(new StringValue(userId));

            forQuery.setSQLQuery(sql);
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
        Enumeration e = queryResult.elements();

        try {
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = new WebBusinessObject();
                wbo.setAttribute("clientCount", r.getString("CLIENT_COUNT"));
                wbo.setAttribute("rateID", r.getString("RATE_ID"));
                wbo.setAttribute("rateName", r.getString("PROJECT_NAME"));
                resultBusObjs.add(wbo);
            }

        } catch (NoSuchColumnException ce) {
            logger.error(ce);
        }
        return resultBusObjs;
    }

    public ArrayList<WebBusinessObject> getAllClientsCountRate() {

        WebBusinessObject wbo;
        Connection connection = null;

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            String sql = getQuery("allClientRateReport").trim();

            forQuery.setSQLQuery(sql);
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
        Enumeration e = queryResult.elements();

        try {
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = new WebBusinessObject();
                wbo.setAttribute("clientCount", r.getString("CLIENT_COUNT"));
                wbo.setAttribute("rateID", r.getString("RATE_ID"));
                wbo.setAttribute("rateName", r.getString("PROJECT_NAME"));
                resultBusObjs.add(wbo);
            }

        } catch (NoSuchColumnException ce) {
            logger.error(ce);
        }
        return resultBusObjs;
    }

    public ArrayList<WebBusinessObject> getClientRateInterval(Date fromDate, Date toDate, String campaignID, String projectID, String rateIDs,
            String employeeID, String type, String dateType, String department) {
        ClientComplaintsMgr clientComplaintsMgr = new ClientComplaintsMgr();
        clientComplaintsMgr = ClientComplaintsMgr.getInstance();
        clientComplaintsMgr.updateClientComplaintsType();
        
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> result;
        Vector params = new Vector();
        params.addElement(new DateValue(fromDate));
        params.addElement(new DateValue(toDate));
        StringBuilder where = new StringBuilder();
        where.append(" TRUNC(").append("registration".equals(dateType) ? "CL" : "CR").append(".CREATION_TIME) BETWEEN ? AND ? ");
        
        if (campaignID != null && !campaignID.equals("''") && !campaignID.equals("")) {
            where.append(" AND CL.OPTION3 = ").append(campaignID).append("");
        }
        if (rateIDs != null && !rateIDs.equals("''")) {
            where.append(" AND CR.RATE_ID IN (").append(rateIDs).append(")");
        }
        if (employeeID != null && !employeeID.isEmpty()) {
            where.append(" AND CCT.CURRENT_OWNER_ID = '").append(employeeID).append("'");
        }
        if (type != null && !type.isEmpty()) {
            where.append(" AND CCT.TYPE_TAG LIKE '").append(type).append("%'");
        }
        if (projectID != null && !projectID.isEmpty() && !projectID.equals("''") && !projectID.equals("")) {
            where.append(" AND CL.SYS_ID IN (SELECT CLIENT_ID FROM CLIENT_PROJECTS WHERE PRODUCT_CATEGORY_ID = '").append(projectID).append("' or project_id = '").append(projectID).append("')");
        }
        
        if ((employeeID == null || employeeID.isEmpty()) && (department != null && !department.isEmpty() && !department.equalsIgnoreCase("all"))) {
            where.append(" AND CCT.CURRENT_OWNER_ID IN ( SELECT USER_ID FROM USERS WHERE USER_ID IN (SELECT EMP_MGR.EMP_ID FROM EMP_MGR WHERE EMP_MGR.MGR_ID = (SELECT PROJECT.OPTION_ONE FROM PROJECT WHERE PROJECT.PROJECT_ID = '").append(department).append("') UNION SELECT PROJECT.OPTION_ONE FROM PROJECT WHERE PROJECT.PROJECT_ID = '").append(department).append("'").append("))");
        }
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            //command.setSQLQuery(getQuery("getClientRateInterval").trim() + where.toString());
           command.setSQLQuery(getQuery("getClientRateInterval1").trim() + where.toString());
            
            command.setparams(params);
            result = command.executeQuery();
            ArrayList<WebBusinessObject> data = new ArrayList<>();
            WebBusinessObject wbo;
            for (Row row : result) {
                wbo = fabricateBusObj(row);
                try {
                    if (row.getString("NAME") != null) {
                        wbo.setAttribute("clientName", row.getString("NAME"));
                    }
                    if (row.getString("MOBILE") != null) {
                        wbo.setAttribute("mobile", row.getString("MOBILE"));
                    }
                    if (row.getTimestamp("CLIENT_CREATION_TIME") != null) {
                        wbo.setAttribute("clientCreationTime", row.getString("CLIENT_CREATION_TIME"));
                    } else {
                        wbo.setAttribute("clientCreationTime", "");
                    }
                    if (row.getString("RATE_NAME") != null) {
                        wbo.setAttribute("rateName", row.getString("RATE_NAME"));
                    }
                    if (row.getString("COLOR") != null) {
                        wbo.setAttribute("color", row.getString("COLOR"));
                    }
                    if (row.getString("RATED_BY") != null) {
                        wbo.setAttribute("ratedBy", row.getString("RATED_BY"));
                    }
		    if (row.getTimestamp("MCT") != null) {
                        wbo.setAttribute("mct", row.getString("MCT"));
                    } else {
			SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			java.util.Date date = new java.util.Date();
			wbo.setAttribute("mct", dateFormat.format(date));
		    }
                    if (row.getTimestamp("FNA") != null) {
                        wbo.setAttribute("fna", row.getString("FNA"));
                    } else {
			wbo.setAttribute("fna", "---");
		    }
                    if (row.getString("INTER_PHONE") != null) {
                        wbo.setAttribute("interPhone", row.getString("INTER_PHONE"));
                    } else {
			wbo.setAttribute("interPhone", "---");
		    }
                    if (row.getString("englishname") != null) {
                        wbo.setAttribute("englishname", row.getString("englishname"));
                    } else {
			wbo.setAttribute("englishname", "---");
		    }
                    if (row.getString("campaign_title") != null) {
                        wbo.setAttribute("campaign_title", row.getString("campaign_title"));
                    } else {
			wbo.setAttribute("campaign_title", "---");
		    }
                    if (row.getString("COMMENT") != null) {
                        wbo.setAttribute("COMMENT", row.getString("COMMENT"));
                    } else {
			wbo.setAttribute("COMMENT", "---");
		    }
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
                } catch (Exception ex) {
                    Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                data.add(wbo);
            }
            return data;
        } catch (UnsupportedTypeException | SQLException ex) {
            Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
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
    
    public ArrayList<WebBusinessObject> getClientRateIntervalAll(Date fromDate, Date toDate, String campaignID, String projectID, String rateIDs,
            String employeeID, String type, String dateType, String department) {
        ClientComplaintsMgr clientComplaintsMgr = new ClientComplaintsMgr();
        clientComplaintsMgr = ClientComplaintsMgr.getInstance();
        clientComplaintsMgr.updateClientComplaintsType();
        
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> result;
        Vector params = new Vector();
        params.addElement(new DateValue(fromDate));
        params.addElement(new DateValue(toDate));
        StringBuilder where = new StringBuilder();
        where.append(" TRUNC(").append("registration".equals(dateType) ? "CL" : "CR").append(".CREATION_TIME) BETWEEN ? AND ? ");
        
        if (campaignID != null && !campaignID.equals("''") && !campaignID.equals("")) {
            where.append(" AND CL.OPTION3 = ").append(campaignID).append("");
        }
        if (rateIDs != null && !rateIDs.equals("''")) {
            where.append(" AND CR.RATE_ID IN (").append(rateIDs).append(")");
        }
        if (employeeID != null && !employeeID.isEmpty()) {
            where.append(" AND CCT.CURRENT_OWNER_ID = '").append(employeeID).append("'");
        }
        if (type != null && !type.isEmpty()) {
            where.append(" AND CCT.TYPE_TAG LIKE '").append(type).append("%'");
        }
        if (projectID != null && !projectID.isEmpty() && !projectID.equals("''") && !projectID.equals("")) {
            where.append(" AND CL.SYS_ID IN (SELECT CLIENT_ID FROM CLIENT_PROJECTS WHERE PRODUCT_CATEGORY_ID = '").append(projectID).append("' or project_id = '").append(projectID).append("')");
        }
        
        if ((employeeID == null || employeeID.isEmpty()) && (department != null && !department.isEmpty() && !department.equalsIgnoreCase("all"))) {
            where.append(" AND CCT.CURRENT_OWNER_ID IN ( SELECT USER_ID FROM USERS WHERE USER_ID IN (SELECT EMP_MGR.EMP_ID FROM EMP_MGR WHERE EMP_MGR.MGR_ID = (SELECT PROJECT.OPTION_ONE FROM PROJECT WHERE PROJECT.PROJECT_ID = '").append(department).append("') UNION SELECT PROJECT.OPTION_ONE FROM PROJECT WHERE PROJECT.PROJECT_ID = '").append(department).append("'").append("))");
        }
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            //command.setSQLQuery(getQuery("getClientRateInterval").trim() + where.toString());
           command.setSQLQuery(getQuery("getClientRateInterval1All").trim() + where.toString());
            
            command.setparams(params);
            result = command.executeQuery();
            ArrayList<WebBusinessObject> data = new ArrayList<>();
            WebBusinessObject wbo;
            for (Row row : result) {
                wbo = fabricateBusObj(row);
                try {
                    if (row.getString("NAME") != null) {
                        wbo.setAttribute("clientName", row.getString("NAME"));
                    }
                    if (row.getString("MOBILE") != null) {
                        wbo.setAttribute("mobile", row.getString("MOBILE"));
                    } else {
                        wbo.setAttribute("mobile", "");
                    }
                    if (row.getString("CLIENT_CREATION_TIME") != null) {
                        wbo.setAttribute("clientCreationTime", row.getString("CLIENT_CREATION_TIME"));
                    } else {
                        wbo.setAttribute("clientCreationTime", "");
                    }
                    if (row.getString("RATE_NAME") != null) {
                        wbo.setAttribute("rateName", row.getString("RATE_NAME"));
                    } else {
                        wbo.setAttribute("rateName", "");
                    }
                    if (row.getString("COLOR") != null) {
                        wbo.setAttribute("color", row.getString("COLOR"));
                    } else {
                        wbo.setAttribute("color", "");
                    }
                    if (row.getString("RATED_BY") != null) {
                        wbo.setAttribute("ratedBy", row.getString("RATED_BY"));
                    } else {
                        wbo.setAttribute("ratedBy", "");
                    }
		    if (row.getTimestamp("MCT") != null) {
                        wbo.setAttribute("mct", row.getString("MCT"));
                    } else {
			SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			java.util.Date date = new java.util.Date();
			wbo.setAttribute("mct", dateFormat.format(date));
		    }
                    if (row.getTimestamp("FNA") != null) {
                        wbo.setAttribute("fna", row.getString("FNA"));
                    } else {
			wbo.setAttribute("fna", "---");
		    }
                    if (row.getString("INTER_PHONE") != null) {
                        wbo.setAttribute("interPhone", row.getString("INTER_PHONE"));
                    } else {
			wbo.setAttribute("interPhone", "---");
		    }
                    if (row.getString("englishname") != null) {
                        wbo.setAttribute("englishname", row.getString("englishname"));
                    } else {
			wbo.setAttribute("englishname", "---");
		    }
                    if (row.getString("campaign_title") != null) {
                        wbo.setAttribute("campaign_title", row.getString("campaign_title"));
                    } else {
			wbo.setAttribute("campaign_title", "---");
		    }
                    if (row.getString("KNOWN_US_FROM") != null) {
                        wbo.setAttribute("KNOWN_US_FROM", row.getString("KNOWN_US_FROM"));
                    } else {
			wbo.setAttribute("KNOWN_US_FROM", "---");
		    }
                    if (row.getString("COMMENT") != null) {
                        wbo.setAttribute("COMMENT", row.getString("COMMENT"));
                    } else {
			wbo.setAttribute("COMMENT", "---");
		    }if (row.getString("CREATION_TIME") != null) {
                        wbo.setAttribute("creationTime", row.getString("CREATION_TIME"));
                    } else {
			wbo.setAttribute("creationTime", "---");
		    }
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
                } catch (Exception ex) {
                    Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                data.add(wbo);
            }
            return data;
        } catch (UnsupportedTypeException | SQLException ex) {
            Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
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
    
    
    public ArrayList<WebBusinessObject> getClientRateIntervalForCommChannels(Date fromDate, Date toDate, String channelID, String projectID, String rateIDs,
            String employeeID, String type, String dateType, String department) {
        ClientComplaintsMgr clientComplaintsMgr = new ClientComplaintsMgr();
        clientComplaintsMgr = ClientComplaintsMgr.getInstance();
        clientComplaintsMgr.updateClientComplaintsType();
        
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> result;
        Vector params = new Vector();
        params.addElement(new DateValue(fromDate));
        params.addElement(new DateValue(toDate));
        StringBuilder where = new StringBuilder();
        where.append(" TRUNC(").append("registration".equals(dateType) ? "CL" : "CR").append(".CREATION_TIME) BETWEEN ? AND ? ");
        
        if (channelID != null && !channelID.equals("''") && !channelID.equals("")) {
            where.append(" AND CL.OPTION3 IN (").append(channelID).append(")");
        }
        if (rateIDs != null && !rateIDs.equals("''")) {
            where.append(" AND CR.RATE_ID IN (").append(rateIDs).append(")");
        }
        if (employeeID != null && !employeeID.isEmpty()) {
            where.append(" AND CR.CREATED_BY = '").append(employeeID).append("'");
        }
        if (type != null && !type.isEmpty()) {
            where.append(" AND CCT.TYPE_TAG LIKE '").append(type).append("%'");
        }
        if (projectID != null && !projectID.isEmpty() && !projectID.equals("''") && !projectID.equals("")) {
            where.append(" AND CL.SYS_ID IN (SELECT CLIENT_ID FROM CLIENT_PROJECTS WHERE PRODUCT_CATEGORY_ID = '").append(projectID).append("' or project_id = '").append(projectID).append("')");
        }
        
        if ((employeeID == null || employeeID.isEmpty()) && (department != null && !department.isEmpty() && !department.equalsIgnoreCase("all"))) {
            where.append(" AND CR.CREATED_BY IN ( SELECT USER_ID FROM USERS WHERE USER_ID IN (SELECT EMP_MGR.EMP_ID FROM EMP_MGR WHERE EMP_MGR.MGR_ID = (SELECT PROJECT.OPTION_ONE FROM PROJECT WHERE PROJECT.PROJECT_ID = '").append(department).append("') UNION SELECT PROJECT.OPTION_ONE FROM PROJECT WHERE PROJECT.PROJECT_ID = '").append(department).append("'").append("))");
        }
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getClientRateInterval").trim() + where.toString());
            command.setparams(params);
            result = command.executeQuery();
            ArrayList<WebBusinessObject> data = new ArrayList<>();
            WebBusinessObject wbo;
            for (Row row : result) {
                wbo = fabricateBusObj(row);
                try {
                    if (row.getString("NAME") != null) {
                        wbo.setAttribute("clientName", row.getString("NAME"));
                    }
                    if (row.getString("MOBILE") != null) {
                        wbo.setAttribute("mobile", row.getString("MOBILE"));
                    }
                    if (row.getTimestamp("CLIENT_CREATION_TIME") != null) {
                        wbo.setAttribute("clientCreationTime", row.getString("CLIENT_CREATION_TIME"));
                    } else {
                        wbo.setAttribute("clientCreationTime", "");
                    }
                    if (row.getString("RATE_NAME") != null) {
                        wbo.setAttribute("rateName", row.getString("RATE_NAME"));
                    }
                    if (row.getString("COLOR") != null) {
                        wbo.setAttribute("color", row.getString("COLOR"));
                    }
                    if (row.getString("RATED_BY") != null) {
                        wbo.setAttribute("ratedBy", row.getString("RATED_BY"));
                    }
		    if (row.getTimestamp("MCT") != null) {
                        wbo.setAttribute("mct", row.getString("MCT"));
                    } else {
			SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			java.util.Date date = new java.util.Date();
			wbo.setAttribute("mct", dateFormat.format(date));
		    }
                    if (row.getTimestamp("FNA") != null) {
                        wbo.setAttribute("fna", row.getString("FNA"));
                    } else {
			wbo.setAttribute("fna", "---");
		    }
                    if (row.getString("INTER_PHONE") != null) {
                        wbo.setAttribute("interPhone", row.getString("INTER_PHONE"));
                    } else {
			wbo.setAttribute("interPhone", "---");
		    }
                    if (row.getString("KNOWN_US_FROM") != null) {
                        wbo.setAttribute("knownUsFrom", row.getString("KNOWN_US_FROM"));
                    }
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
                } catch (Exception ex) {
                    Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                data.add(wbo);
            }
            return data;
        } catch (UnsupportedTypeException | SQLException ex) {
            Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
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
    
    
    public ArrayList<WebBusinessObject> getClientCampaignRateInterval(String fromDate, String toDate, String [] campaignID) {
        ClientComplaintsMgr clientComplaintsMgr = new ClientComplaintsMgr();
        clientComplaintsMgr = ClientComplaintsMgr.getInstance();
        clientComplaintsMgr.updateClientComplaintsType();
        
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> result;
        Vector params = new Vector();
        params.addElement(new StringValue(fromDate));
        params.addElement(new StringValue(toDate));
        StringBuilder where = new StringBuilder();
        
        if (campaignID != null && campaignID.length != 0) {
            where.append(" AND CR.CLIENT_ID IN (SELECT CLIENT_ID FROM CLIENT_CAMPAIGN WHERE CAMPAIGN_ID IN (");
            for(int i=0; i<campaignID.length; i++){
                if(i == campaignID.length-1){
                    where.append("'").append(campaignID[i]).append("'"); 
                } else{
                    where.append("'").append(campaignID[i]).append("',"); 
                }
            }
            where.append("))");
            where.append(" AND C.ID IN (");
            for(int i=0; i<campaignID.length; i++){
                if(i == campaignID.length-1){
                    where.append("'").append(campaignID[i]).append("'"); 
                } else{
                    where.append("'").append(campaignID[i]).append("',"); 
                }
            }
            where.append(")");
            where.append("ORDER BY C.CAMPAIGN_TITLE");
            
        } else {
             where.append("ORDER BY C.CAMPAIGN_TITLE");
        }
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getClientCampaignRateInterval").trim() + where.toString());
            command.setparams(params);
            result = command.executeQuery();
            ArrayList<WebBusinessObject> data = new ArrayList<>();
            WebBusinessObject wbo;
            for (Row row : result) {
                wbo = fabricateBusObj(row);
                try {
                    if (row.getString("NAME") != null) {
                        wbo.setAttribute("clientName", row.getString("NAME"));
                    }
                    if (row.getString("MOBILE") != null) {
                        wbo.setAttribute("mobile", row.getString("MOBILE"));
                    }
                    if (row.getTimestamp("CLIENT_CREATION_TIME") != null) {
                        wbo.setAttribute("clientCreationTime", row.getString("CLIENT_CREATION_TIME"));
                    } else {
                        wbo.setAttribute("clientCreationTime", "");
                    }
                    if (row.getString("RATE_NAME") != null) {
                        wbo.setAttribute("rateName", row.getString("RATE_NAME"));
                    } else {
                        wbo.setAttribute("rateName", "Un Rated");
                    }
                    if (row.getString("COLOR") != null) {
                        wbo.setAttribute("color", row.getString("COLOR"));
                    }
                    if (row.getString("RATED_BY") != null) {
                        wbo.setAttribute("ratedBy", row.getString("RATED_BY"));
                    }
		    if (row.getTimestamp("MCT") != null) {
                        wbo.setAttribute("mct", row.getString("MCT"));
                    } else {
			SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			java.util.Date date = new java.util.Date();
			wbo.setAttribute("mct", dateFormat.format(date));
		    }
                    if (row.getString("CAMPAIGN_TITLE") != null) {
                        wbo.setAttribute("campaignTit", "Campaign: "+ row.getString("CAMPAIGN_TITLE").toString()+" - Creation Time: "+row.getString("CMPCT"));
                    }
                    if (row.getString("CMPCT") != null) {
                        wbo.setAttribute("campCT", row.getString("CMPCT"));
                    }
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
                } catch (Exception ex) {
                    Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                data.add(wbo);
            }
            return data;
        } catch (UnsupportedTypeException | SQLException ex) {
            Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
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

    public ArrayList<WebBusinessObject> getClientRateCountInterval(Date fromDate, Date toDate, String campaignID,String projectID , String rateIDs,
            String employeeID, String type, String dateType, String department) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> result;
        Vector params = new Vector();
        params.addElement(new DateValue(fromDate));
        params.addElement(new DateValue(toDate));
        StringBuilder where = new StringBuilder();
        where.append(" TRUNC(").append("registration".equals(dateType) ? "CL" : "CR").append(".CREATION_TIME) BETWEEN ? AND ? ");
        if (campaignID != null && !campaignID.equals("''")) {
            where.append(" AND CR.CLIENT_ID IN (SELECT CLIENT_ID FROM CLIENT_CAMPAIGN WHERE CAMPAIGN_ID IN (")
                    .append(campaignID).append("))");
        }
        if (rateIDs != null && !rateIDs.equals("''")) {
            where.append(" AND CR.RATE_ID IN (").append(rateIDs).append(")");
        }
        if (employeeID != null && !employeeID.isEmpty()) {
            where.append(" AND CCT.CURRENT_OWNER_ID = '").append(employeeID).append("'");
        }
        if (type != null && !type.isEmpty()) {
            where.append(" AND CCT.TYPE_TAG LIKE '").append(type).append("%'");
        }
        if (projectID != null && !projectID.isEmpty() && !projectID.equals("''")) {
            where.append(" AND CL.SYS_ID IN (SELECT CLIENT_ID FROM CLIENT_PROJECTS WHERE PRODUCT_CATEGORY_ID = '").append(projectID).append("' or project_id = '").append(projectID).append("')");
        }
        
        if ((employeeID == null || employeeID.isEmpty()) && (department != null && !department.isEmpty() && !department.equalsIgnoreCase("all"))) {
            where.append(" AND CCT.CURRENT_OWNER_ID IN ( SELECT USER_ID FROM USERS WHERE USER_ID IN (SELECT EMP_MGR.EMP_ID FROM EMP_MGR WHERE EMP_MGR.MGR_ID = (SELECT PROJECT.OPTION_ONE FROM PROJECT WHERE PROJECT.PROJECT_ID = '").append(department).append("') UNION SELECT PROJECT.OPTION_ONE FROM PROJECT WHERE PROJECT.PROJECT_ID = '").append(department).append("'").append("))");
        }
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getClientRateCountInterval1").replaceAll("whereStatement", where.toString()).trim());
            command.setparams(params);
            result = command.executeQuery();
            ArrayList<WebBusinessObject> data = new ArrayList<>();
            WebBusinessObject wbo;
            for (Row row : result) {
                wbo = new WebBusinessObject();
                try {
                    if (row.getString("CLIENT_COUNT") != null) {
                        wbo.setAttribute("clientCount", row.getString("CLIENT_COUNT"));
                    }
                    if (row.getString("RATE_ID") != null) {
                        wbo.setAttribute("rateID", row.getString("RATE_ID"));
                    }
                    if (row.getString("COLOR") != null) {
                        wbo.setAttribute("color", row.getString("COLOR"));
                    }
                    if (row.getString("RATE_NAME") != null) {
                        wbo.setAttribute("rateName", row.getString("RATE_NAME"));
                    }
                } catch (NoSuchColumnException | NullPointerException ex) {
                    Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                data.add(wbo);
            }
            return data;
        } catch (UnsupportedTypeException | SQLException ex) {
            Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
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
    
    public ArrayList<WebBusinessObject> getClientRateCountIntervalForComChannels(Date fromDate, Date toDate, String channelID,String projectID , String rateIDs,
            String employeeID, String type, String dateType, String department) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> result;
        Vector params = new Vector();
        params.addElement(new DateValue(fromDate));
        params.addElement(new DateValue(toDate));
        StringBuilder where = new StringBuilder();
        where.append(" TRUNC(").append("registration".equals(dateType) ? "CL" : "CR").append(".CREATION_TIME) BETWEEN ? AND ? ");
        if (channelID != null && !channelID.equals("''")) {
            where.append(" AND CL.OPTION3 IN (").append(channelID).append(")");
        }
        if (rateIDs != null && !rateIDs.equals("''")) {
            where.append(" AND CR.RATE_ID IN (").append(rateIDs).append(")");
        }
        if (employeeID != null && !employeeID.isEmpty()) {
            where.append(" AND CR.CREATED_BY = '").append(employeeID).append("'");
        }
        if (type != null && !type.isEmpty()) {
            where.append(" AND CCT.TYPE_TAG LIKE '").append(type).append("%'");
        }
        if (projectID != null && !projectID.isEmpty() && !projectID.equals("''")) {
            where.append(" AND CL.SYS_ID IN (SELECT CLIENT_ID FROM CLIENT_PROJECTS WHERE PRODUCT_CATEGORY_ID = '").append(projectID).append("' or project_id = '").append(projectID).append("')");
        }
        
        if ((employeeID == null || employeeID.isEmpty()) && (department != null && !department.isEmpty() && !department.equalsIgnoreCase("all"))) {
            where.append(" AND CR.CREATED_BY IN ( SELECT USER_ID FROM USERS WHERE USER_ID IN (SELECT EMP_MGR.EMP_ID FROM EMP_MGR WHERE EMP_MGR.MGR_ID = (SELECT PROJECT.OPTION_ONE FROM PROJECT WHERE PROJECT.PROJECT_ID = '").append(department).append("' UNION SELECT PROJECT.OPTION_ONE FROM PROJECT WHERE PROJECT.PROJECT_ID = '").append(department).append("'").append(")))");
        }
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getClientRateCountIntervalForComChannels").replaceAll("whereStatement", where.toString()).trim());
            command.setparams(params);
            result = command.executeQuery();
            ArrayList<WebBusinessObject> data = new ArrayList<>();
            WebBusinessObject wbo;
            for (Row row : result) {
                wbo = new WebBusinessObject();
                try {
                    if (row.getString("CLIENT_COUNT") != null) {
                        wbo.setAttribute("clientCount", row.getString("CLIENT_COUNT"));
                    }
                    if (row.getString("CHANNEL_NAME") != null) {
                        wbo.setAttribute("channelName", row.getString("CHANNEL_NAME"));
                    } else {
                        wbo.setAttribute("channelName", "No Channel");
                    }
                } catch (NoSuchColumnException | NullPointerException ex) {
                    Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                data.add(wbo);
            }
            return data;
        } catch (UnsupportedTypeException | SQLException ex) {
            Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
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
    
    public ArrayList<WebBusinessObject> getCampaignClientsRates(String campaignID, String startDate, String endDate) {
        WebBusinessObject wbo;
        Connection connection = null;
        Vector queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();

        params.addElement(new StringValue(campaignID));
        if (startDate.equals("") || endDate.equals("")) {
        } else {
            params.addElement(new StringValue(startDate));
            params.addElement(new StringValue(endDate));
        }

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            if (startDate.equals("") || endDate.equals("")) {
                forQuery.setSQLQuery(getQuery("clientRatingPerCampaign").trim());
            } else {
                forQuery.setSQLQuery(getQuery("clientRatingPerCampaignByDates").trim());
            }
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
        ArrayList<WebBusinessObject> resultBusObjs = new ArrayList<>();
        Row r;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = fabricateBusObj(r);
            try {
                if (r.getBigDecimal("CLIENT_COUNT") != null) {
                    wbo.setAttribute("ClientCount", r.getBigDecimal("CLIENT_COUNT"));
                } else {
                    wbo.setAttribute("ClientCount", "0");
                }

                if (r.getString("Rate_Name") != null) {
                    wbo.setAttribute("RateName", r.getString("Rate_Name"));
                } else {
                    wbo.setAttribute("RateName", "0");
                }
                
                if (r.getString("Rate_Color") != null) {
                    wbo.setAttribute("RateColor", r.getString("Rate_Color"));
                } else {
                    wbo.setAttribute("RateColor", "pink");
                }
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
            } catch (Exception ex) {
                Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
            }

            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }
    
    public ArrayList<WebBusinessObject> getCampaignClientsRates1(String campaignID, String startDate, String endDate) {
        WebBusinessObject wbo;
        Connection connection = null;
        Vector queryResult = new Vector();
        SQLCommandBean forQuery =  new SQLCommandBean();
        Vector params = new Vector();

        params.addElement(new StringValue(campaignID));
        if (startDate.equals("") || endDate.equals("")) {
        } else {
            params.addElement(new StringValue(startDate));
            params.addElement(new StringValue(endDate));
        }

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            if (startDate.equals("") || endDate.equals("")) {
                forQuery.setSQLQuery(getQuery("clientRatingPerCampaign").trim());
            } else {
                forQuery.setSQLQuery(getQuery("clientRatingPerCampaignByDates").trim());
            }
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
        ArrayList resultBusObjs = new ArrayList<>();
        Row r;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = fabricateBusObj(r);
            try {
                if (r.getBigDecimal("CLIENT_COUNT") != null) {
                    resultBusObjs.add(new Integer(r.getString("CLIENT_COUNT").toString()));
                } else {
                    resultBusObjs.add(0);
                }
            } catch (Exception ex) {
                resultBusObjs.add(0);
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }

        }
        return resultBusObjs;
    }
    
    public ArrayList<WebBusinessObject> getClientRateingHistory(String clientID) {
        Connection connection = null;
        Vector queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();
        params.addElement(new StringValue(clientID));
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getClientRateingHistory").trim());
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
        WebBusinessObject wbo;
        ArrayList<WebBusinessObject> result = new ArrayList<>();
        Row r;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = fabricateBusObj(r);
            try {
                wbo.setAttribute("fullName", r.getString("FULL_NAME") != null ? r.getString("FULL_NAME") : "");
                wbo.setAttribute("userName", r.getString("USER_NAME") != null ? r.getString("USER_NAME") : "");
                wbo.setAttribute("rateName", r.getString("RATE_NAME") != null ? r.getString("RATE_NAME") : "");
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            result.add(wbo);
        }
        return result;
    }
    
    public ArrayList<WebBusinessObject> geCampsRates(String startDate, String endDate, String campId, ArrayList Rates) {
        WebBusinessObject wbo;
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();

        params.addElement(new StringValue(campId));
        params.addElement(new StringValue(startDate));
        params.addElement(new StringValue(endDate));

        try {
            StringBuilder CountRate = new StringBuilder();

            for (int i = 0; i < Rates.size(); i++) {
                CountRate.append(" , count(case when PROJECT_NAME = '" + Rates.get(i) + "' then CLIENT_RATING.CLIENT_ID ELSE  null END) as " + Rates.get(i).toString().replaceAll("\\s", ""));
            }

            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            String sql = getQuery("getSubCampsRates");
            sql = sql.replaceFirst("RatesCounts", CountRate.toString()).trim();
            forQuery.setSQLQuery(sql);
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

        ArrayList<WebBusinessObject> resultBusObjs = new ArrayList<WebBusinessObject>();
        Row r = null;
        Enumeration e = queryResult.elements();
        try {
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = new WebBusinessObject();

                if (r.getString("CAMPAIGN_TITLE") != null) {
                    wbo.setAttribute("CAMPAIGN_TITLE", r.getString("CAMPAIGN_TITLE"));
                }

                for (int i = 0; i < Rates.size(); i++) {
                    if (r.getBigDecimal(Rates.get(i).toString().replaceAll("\\s", "")) != null) {
                        wbo.setAttribute(Rates.get(i).toString().replaceAll("\\s", ""), r.getBigDecimal(Rates.get(i).toString().replaceAll("\\s", "")));
                    }
                }

                resultBusObjs.add(wbo);
            }
        } catch (NoSuchColumnException ce) {
            logger.error(ce);
        } catch (Exception ex) {
            logger.error(ex);
        }
        return resultBusObjs;
    }
    
    public String getWeeksString(String[] campaignID, String rateID, String startDate, String endDate) {
        WebBusinessObject wbo;
        Connection connection = null;
        Vector queryResult = new Vector();
        SQLCommandBean forQuery =  new SQLCommandBean();
        Vector params = new Vector();

        String campWhere = "";
        
        params.addElement(new StringValue(rateID));
        for(int i=0; i<campaignID.length; i++){
            campWhere += "?,";
            params.addElement(new StringValue(campaignID[i]));
        }
        campWhere = campWhere.substring(0, campWhere.length() - 1);
        params.addElement(new StringValue(startDate));
        params.addElement(new StringValue(endDate));
        
        try {
            connection = dataSource.getConnection();
            
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getWeeksString").replace("*", campWhere).trim());
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
        
        String weeksString = "";
        Row r;
        Enumeration e = queryResult.elements();
        
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            try {
                if (r.getString("weeks") != null) {
                    weeksString = r.getString("weeks").toString();
                } else {
                    weeksString = null;
                }
            } catch (Exception ex) {
                weeksString = null;
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        
        return weeksString;
    }
    
    public ArrayList<String> getWeeksList(String[] campaignID, String rateID, String startDate, String endDate) {
        WebBusinessObject wbo;
        Connection connection = null;
        Vector<Row> queryResult = new Vector();
        SQLCommandBean forQuery =  new SQLCommandBean();
        Vector params = new Vector();

        String campWhere = "";
        
        params.addElement(new StringValue(rateID));
        for(int i=0; i<campaignID.length; i++){
            campWhere += "?,";
            params.addElement(new StringValue(campaignID[i]));
        }
        campWhere = campWhere.substring(0, campWhere.length() - 1);
        params.addElement(new StringValue(startDate));
        params.addElement(new StringValue(endDate));
        
        try {
            connection = dataSource.getConnection();
            
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getWeeksList").replace("*", campWhere).trim());
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
        
        ArrayList<String> data = new ArrayList<>();
        
        for (Row r : queryResult) {
            try {
                data.add(r.getString("week_no"));
            } catch (Exception ex) {
                logger.error(ex);
            }
        }
        
        return data;
    }
    
    public ArrayList<String> getRatesWeeksList(String[] rateID, String campaignID, String startDate, String endDate) {
        WebBusinessObject wbo;
        Connection connection = null;
        Vector<Row> queryResult = new Vector();
        SQLCommandBean forQuery =  new SQLCommandBean();
        Vector params = new Vector();

        String campWhere = "";
        
        params.addElement(new StringValue(campaignID));
        for(int i=0; i<rateID.length; i++){
            campWhere += "?,";
            params.addElement(new StringValue(rateID[i]));
        }
        campWhere = campWhere.substring(0, campWhere.length() - 1);
        params.addElement(new StringValue(startDate));
        params.addElement(new StringValue(endDate));
        
        try {
            connection = dataSource.getConnection();
            
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getRatesWeeksList").replace("*", campWhere).trim());
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
        
        ArrayList<String> data = new ArrayList<>();
        
        for (Row r : queryResult) {
            try {
                data.add(r.getString("week_no"));
            } catch (Exception ex) {
                logger.error(ex);
            }
        }
        
        return data;
    }
    
    public ArrayList<WebBusinessObject> geCampDegradation(String[] campaignID, String rateID, String startDate, String endDate, ArrayList<String> WeeksList) {
        WebBusinessObject wbo;
        Connection connection = null;
        Vector queryResult = new Vector();
        SQLCommandBean forQuery =  new SQLCommandBean();
        Vector params = new Vector();

        String campWhere = "";
        String withinWhere = "";
        
        params.addElement(new StringValue(rateID));
        for(int i=0; i<campaignID.length; i++){
            campWhere += "?,";
            params.addElement(new StringValue(campaignID[i]));
        }
        campWhere = campWhere.substring(0, campWhere.length() - 1);
        params.addElement(new StringValue(startDate));
        params.addElement(new StringValue(endDate));
        
        for(int i=0; i<WeeksList.size(); i++){
            withinWhere += WeeksList.get(i)+",";
        }
        withinWhere = withinWhere.substring(0, withinWhere.length() - 1);

        try {
            connection = dataSource.getConnection();
            
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getCampDegradation").replace("#", campWhere).replace("$", withinWhere).trim());
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

        ArrayList<WebBusinessObject> resultBusObjs = new ArrayList<WebBusinessObject>();
        Row r = null;
        Enumeration e = queryResult.elements();
        try {
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = new WebBusinessObject();
               
                if (r.getString("CAMPAIGN_TITLE") != null) {
                    wbo.setAttribute("CAMPAIGN_TITLE", r.getString("CAMPAIGN_TITLE"));
                }

                for (int i = 0; i < WeeksList.size(); i++) {
                    wbo.setAttribute(WeeksList.get(i).toString(),r.getString(WeeksList.get(i).toString()));
                }

                resultBusObjs.add(wbo);
            }
        } catch (NoSuchColumnException ce) {
            logger.error(ce);
        } catch (Exception ex) {
            logger.error(ex);
        }
        return resultBusObjs;
    }
    
    public ArrayList<WebBusinessObject> geCampRatesDegradation(String[] rateID, String campaignID, String startDate, String endDate, ArrayList<String> WeeksList) {
        WebBusinessObject wbo;
        Connection connection = null;
        Vector queryResult = new Vector();
        SQLCommandBean forQuery =  new SQLCommandBean();
        Vector params = new Vector();

        String campWhere = "";
        String withinWhere = "";
        
        params.addElement(new StringValue(campaignID));
        for(int i=0; i<rateID.length; i++){
            campWhere += "?,";
            params.addElement(new StringValue(rateID[i]));
        }
        campWhere = campWhere.substring(0, campWhere.length() - 1);
        params.addElement(new StringValue(startDate));
        params.addElement(new StringValue(endDate));
        
        for(int i=0; i<WeeksList.size(); i++){
            withinWhere += WeeksList.get(i)+",";
        }
        withinWhere = withinWhere.substring(0, withinWhere.length() - 1);

        try {
            connection = dataSource.getConnection();
            
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getCampRatesDegradation").replace("#", campWhere).replace("$", withinWhere).trim());
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

        ArrayList<WebBusinessObject> resultBusObjs = new ArrayList<WebBusinessObject>();
        Row r = null;
        Enumeration e = queryResult.elements();
        try {
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = new WebBusinessObject();
               
                if (r.getString("project_name") != null) {
                    wbo.setAttribute("Rate_Name", r.getString("project_name"));
                }
                if (r.getString("rate_id") != null) {
                    wbo.setAttribute("rate_id", r.getString("rate_id"));
                }

                for (int i = 0; i < WeeksList.size(); i++) {
                    wbo.setAttribute(WeeksList.get(i).toString(),r.getString(WeeksList.get(i).toString()));
                }

                resultBusObjs.add(wbo);
            }
        } catch (NoSuchColumnException ce) {
            logger.error(ce);
        } catch (Exception ex) {
            logger.error(ex);
        }
        return resultBusObjs;
    }
    
    public String geCampaignLastUse(String campaignID, String startDate, String endDate) {
        WebBusinessObject wbo;
        Connection connection = null;
        Vector queryResult = new Vector();
        SQLCommandBean forQuery =  new SQLCommandBean();
        Vector params = new Vector();

        
        
        params.addElement(new StringValue(startDate));
        params.addElement(new StringValue(endDate));
        params.addElement(new StringValue(campaignID));

        try {
            connection = dataSource.getConnection();
            
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getCampaignLastUse").trim());
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

        Row r = null;
        Enumeration e = queryResult.elements();
        
        String days = null;
        try {
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
               
                days = r.getString("days").toString();
            }
        } catch (NoSuchColumnException ce) {
            logger.error(ce);
        } catch (Exception ex) {
            logger.error(ex);
        }
        return days;
    }
    
    public ArrayList<WebBusinessObject> geClientCampDegradation(String campaignID, String startDate, String endDate, ArrayList<String> WeeksList) {
        WebBusinessObject wbo;
        Connection connection = null;
        Vector queryResult = new Vector();
        SQLCommandBean forQuery =  new SQLCommandBean();
        Vector params = new Vector();

        String campWhere = "";
        String withinWhere = "";
        
        params.addElement(new StringValue(campaignID));
        params.addElement(new StringValue(startDate));
        params.addElement(new StringValue(endDate));
        
        for(int i=0; i<WeeksList.size(); i++){
            withinWhere += WeeksList.get(i)+",";
        }
        withinWhere = withinWhere.substring(0, withinWhere.length() - 1);

        try {
            connection = dataSource.getConnection();
            
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getClientCampDgrdtion").replace("#", campWhere).replace("$", withinWhere).trim());
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

        ArrayList<WebBusinessObject> resultBusObjs = new ArrayList<WebBusinessObject>();
        Row r = null;
        Enumeration e = queryResult.elements();
        try {
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = new WebBusinessObject();
               
                for (int i = 0; i < WeeksList.size(); i++) {
                    wbo.setAttribute(WeeksList.get(i).toString(),r.getString(WeeksList.get(i).toString()));
                }

                resultBusObjs.add(wbo);
            }
        } catch (NoSuchColumnException ce) {
            logger.error(ce);
        } catch (Exception ex) {
            logger.error(ex);
        }
        return resultBusObjs;
    }
  public ArrayList<WebBusinessObject> getCampClientDetails(String campaignID, String rateID, String startDate, String endDate,String weekno) {
        WebBusinessObject wbo;
        Connection connection = null;
        Vector queryResult = new Vector();
        SQLCommandBean forQuery =  new SQLCommandBean();
        Vector params = new Vector();
        params.addElement(new StringValue(campaignID));
        params.addElement(new StringValue(rateID));
        params.addElement(new StringValue(startDate));
        params.addElement(new StringValue(endDate));
        params.addElement(new StringValue(weekno));

        try {
            connection = dataSource.getConnection();
            
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getCampClientsDetails").trim());
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

        ArrayList<WebBusinessObject> resultBusObjs = new ArrayList<WebBusinessObject>();
        Row r = null;
        Enumeration e = queryResult.elements();
        try {
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = new WebBusinessObject();
               
                if (r.getString("client_id") != null) {
                    wbo.setAttribute("client_id", r.getString("client_id"));
                }
                if (r.getString("CLIENT_NO") != null) {
                    wbo.setAttribute("CLIENT_NO", r.getString("CLIENT_NO"));
                }
                if (r.getString("NAME") != null) {
                    wbo.setAttribute("NAME", r.getString("NAME"));
                }
                if (r.getString("MOBILE") != null) {
                    wbo.setAttribute("MOBILE", r.getString("MOBILE"));
                }
                if (r.getString("INTER_PHONE") != null) {
                    wbo.setAttribute("INTER_PHONE", r.getString("INTER_PHONE"));
                }else{
                     wbo.setAttribute("INTER_PHONE", "--");
                }
                if (r.getString("clCreation_time") != null) {
                    wbo.setAttribute("clCreation_time", r.getString("clCreation_time"));
                }
                if (r.getString("comment_desc") != null) {
                    wbo.setAttribute("comment_desc", r.getString("comment_desc"));
                }else{
                     wbo.setAttribute("comment_desc", "--");
                }

                 if (r.getString("DESCRIPTION") != null) {
                    wbo.setAttribute("description", r.getString("DESCRIPTION"));
                }else{
                     wbo.setAttribute("description", "--");
                }
                 if (r.getString("CREATED_BY") != null) {
                    wbo.setAttribute("createdBy", r.getString("CREATED_BY"));
                }else{
                     wbo.setAttribute("createdBy", "--");
                }
                resultBusObjs.add(wbo);
            }
        } catch (NoSuchColumnException ce) {
            logger.error(ce);
        } catch (Exception ex) {
            logger.error(ex);
        }
        return resultBusObjs;
    }
    
}
