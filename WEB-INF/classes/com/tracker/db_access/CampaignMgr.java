package com.tracker.db_access;

import com.maintenance.common.DateParser;
import com.maintenance.common.Tools;
import com.planning.db_access.SeasonMgr;
import com.silkworm.business_objects.BusinessForm;
import com.silkworm.business_objects.DOMFabricatorBean;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.persistence.relational.DateValue;
import com.silkworm.persistence.relational.NoSuchColumnException;
import com.silkworm.persistence.relational.RDBGateWay;
import com.silkworm.persistence.relational.Row;
import com.silkworm.persistence.relational.SQLCommandBean;
import com.silkworm.persistence.relational.StringValue;
import com.silkworm.persistence.relational.TimestampValue;
import com.silkworm.persistence.relational.UniqueIDGen;
import com.silkworm.persistence.relational.UnsupportedTypeException;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.log4j.xml.DOMConfigurator;

public class CampaignMgr extends RDBGateWay {

    public static CampaignMgr campaignMgr = new CampaignMgr();

    public static CampaignMgr getInstance() {
        logger.info("Getting campaignMgr Instance ....");
        return campaignMgr;
    }

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }

        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("campaign.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(WebBusinessObject campaignWbo, WebBusinessObject loggedUser) {
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1;
        DateParser dateParser = new DateParser();

        String Id = UniqueIDGen.getNextID();
        campaignWbo.setAttribute("id", Id);
        params.addElement(new StringValue(Id));
        params.addElement(new StringValue((String) campaignWbo.getAttribute("campaignTitle")));
        params.addElement(new StringValue((String) campaignWbo.getAttribute("toolID")));
        params.addElement(new DateValue(dateParser.formatSqlDate(((String) campaignWbo.getAttribute("fromDate")).replaceAll("-", "/"))));
        params.addElement(new DateValue(dateParser.formatSqlDate(((String) campaignWbo.getAttribute("toDate")).replaceAll("-", "/"))));
        params.addElement(new StringValue((String) campaignWbo.getAttribute("cost")));
        params.addElement(new StringValue((String) campaignWbo.getAttribute("objective")));
        params.addElement(new StringValue((String) campaignWbo.getAttribute("parentID")));
        params.addElement(new StringValue((String) campaignWbo.getAttribute("campaignType")));
        params.addElement(new StringValue((String) campaignWbo.getAttribute("currentStatus")));
        params.addElement(new StringValue((String) loggedUser.getAttribute("userId")));
        params.addElement(new StringValue((String) campaignWbo.getAttribute("direction")));
        try {
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(getQuery("insertCampaign").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            endTransaction();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            rollbackTransaction();
            return false;
        }
        return (queryResult > 0);
    }

    public ArrayList<WebBusinessObject> campaignsComparison(String[] chnls, String yr, String mnth) throws SQLException {
        Vector queryResult = new Vector();
        SQLCommandBean getCodes = new SQLCommandBean();

        Vector params = new Vector();
        StringBuilder whrStmnt = new StringBuilder();
        if (chnls != null && chnls.length > 0 && (chnls[0] != null && !chnls[0].equalsIgnoreCase("null"))) {
            whrStmnt.append(" AND CA.ID IN (");
            for (int i = 0; i < chnls.length; i++) {
                whrStmnt.append("?");
                params.addElement(new StringValue(chnls[i]));
                if (i < chnls.length - 1) {
                    whrStmnt.append(",");
                } else {
                    whrStmnt.append(")");
                }
            }
        }

        if (yr != null && !yr.isEmpty()) {
            whrStmnt.append(" AND EXTRACT(YEAR FROM CL.CREATION_TIME) = ?");
            params.addElement(new StringValue(yr));
        }

        if (mnth != null && !mnth.isEmpty()) {
            whrStmnt.append(" AND EXTRACT(MONTH FROM CL.CREATION_TIME) = ?");
            params.addElement(new StringValue(mnth));
        }

        try {
            beginTransaction();
            getCodes.setConnection(transConnection);
            getCodes.setSQLQuery(getQuery("campaignComparison").replaceAll("whrStmnt", whrStmnt.toString()).trim());
            getCodes.setparams(params);
            queryResult = getCodes.executeQuery();
            endTransaction();
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } catch (UnsupportedTypeException utb) {
            logger.error(utb.getMessage());
        } finally {
            transConnection.close();
        }
        ArrayList reultBusObjs = new ArrayList();
        Row r = null;
        Enumeration e = queryResult.elements();
        WebBusinessObject wbo = null;
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            try {

                if (r.getString("CAMPAIGN_TITLE") != null) {
                    wbo.setAttribute("arbNm", r.getString("CAMPAIGN_TITLE"));
                } else {
                    wbo.setAttribute("arbNm", "");
                }

                if (r.getString("CLNT_CNT") != null) {
                    wbo.setAttribute("clntCnt", r.getString("CLNT_CNT"));
                } else {
                    wbo.setAttribute("clntCnt", "");
                }

                if (r.getString("YEAR") != null) {
                    wbo.setAttribute("year", r.getString("YEAR"));
                } else {
                    wbo.setAttribute("year", "");
                }
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(SeasonMgr.class.getName()).log(Level.SEVERE, null, ex);
            }

            reultBusObjs.add(wbo);
        }
        return reultBusObjs;
    }

    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
    }

    @Override
    public ArrayList getCashedTableAsArrayList() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public String getCampaignStatusName(String campaignStatus, String lang) throws SQLException, NoSuchColumnException {
        String theQuery = getQuery("getCampaignStatus");
        Vector parameters = new Vector();
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = dataSource.getConnection();
        try {
            parameters.addElement(new StringValue(campaignStatus));
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(theQuery);
            forQuery.setparams(parameters);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            throw se;
        } catch (UnsupportedTypeException uste) {
            logger.error("Persistence Error " + uste.getMessage());
        } finally {
            connection.close();
        }

        Row r;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            if (lang != null && lang.equalsIgnoreCase("ar")) {
                return r.getString("CASE_AR");
            } else {
                return r.getString("CASE_EN");
            }
        }
        return "";
    }

    public boolean updateCampaignStatus(String campaignID, String newCampaignStatus) {
        Vector params = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;
        params.addElement(new StringValue(newCampaignStatus));
        params.addElement(new StringValue(campaignID));
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            connection.setAutoCommit(true);
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(getQuery("updateCampaignStatus").trim());
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();
        } catch (SQLException se) {
            logger.error("Exception updating campaign status: " + se.getMessage());
            return false;
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                Logger.getLogger(CampaignMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return (queryResult > 0);
    }

    public boolean updateCampaign(String campaignId, String updateType, String updateValue) {
        Vector params = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;
        String query = "";
        if (updateType.equalsIgnoreCase("fromDate")) {
            DateParser dateParser = new DateParser();
            query = "updateCampaignFromDate";
            params.addElement(new DateValue(dateParser.formatSqlDate(updateValue.replaceAll("-", "/"))));
        } else if (updateType.equalsIgnoreCase("toDate")) {
            DateParser dateParser = new DateParser();
            query = "updateCampaignToDate";
            params.addElement(new DateValue(dateParser.formatSqlDate(updateValue.replaceAll("-", "/"))));
        } else if (updateType.equalsIgnoreCase("cost")) {
            query = "updateCampaignCost";
            params.addElement(new StringValue(updateValue));
        } else if (updateType.equalsIgnoreCase("objective")) {
            query = "updateCampaignObjective";
            params.addElement(new StringValue(updateValue));
        } else if (updateType.equalsIgnoreCase("direction")) {
            query = "updateCampaignDirection";
            params.addElement(new StringValue(updateValue));
        } else if (updateType.equalsIgnoreCase("title")) {
            query = "updateCampaignTitle";
            params.addElement(new StringValue(updateValue));
        }

        params.addElement(new StringValue(campaignId));
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            connection.setAutoCommit(true);
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(getQuery(query).trim());
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();
        } catch (SQLException se) {
            logger.error("Exception updating campaign: " + se.getMessage());
            return false;
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                Logger.getLogger(CampaignMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return (queryResult > 0);
    }

    public ArrayList<WebBusinessObject> getAgentClientsCountPerCampaign(String employeeID, String startDate, String endDate) {
        WebBusinessObject wbo;
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            StringBuilder sql = new StringBuilder(getQuery("campaignClientsReport").trim());
            if (startDate != null && !startDate.isEmpty()) {
                sql.append(" and cc.CREATION_TIME >= ?");
                params.addElement(new TimestampValue(java.sql.Timestamp.valueOf(startDate + " 00:00:01")));
            }

            if (endDate != null && !endDate.isEmpty()) {
                sql.append(" and cc.CREATION_TIME <= ?");
                params.addElement(new TimestampValue(java.sql.Timestamp.valueOf(endDate + " 23:59:59")));
            }
            if (employeeID != null && !employeeID.isEmpty()) {
                sql.append(" AND CURRENT_OWNER_ID = ?");
                params.addElement(new StringValue(employeeID));
            }
            sql.append(" group by cp.ID, cp.CAMPAIGN_TITLE");
            forQuery.setSQLQuery(sql.toString());
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
                wbo.setAttribute("campaignTitle", r.getString("CAMPAIGN_TITLE"));
                wbo.setAttribute("campaignID", r.getString("ID"));
                resultBusObjs.add(wbo);
            }
        } catch (NoSuchColumnException ce) {
            logger.error(ce);
        }
        return resultBusObjs;
    }

    public ArrayList<WebBusinessObject> getAllSubCampaigns() {
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getAllSubCampaigns").trim());
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

        ArrayList<WebBusinessObject> resultBusObjs = new ArrayList<>();
        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            resultBusObjs.add(fabricateBusObj(r));
        }

        return resultBusObjs;
    }

    public ArrayList<WebBusinessObject> getClientsCountPerActiveCampaign(String startDate, String endDate, ArrayList<String> userCampaigns) {
        WebBusinessObject wbo;
        Connection connection = null;

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            String sql = getQuery("activeCampaignClientsReport").trim();
            StringBuilder where = new StringBuilder();
            SimpleDateFormat sdf = new SimpleDateFormat("dd-MMM-yyyy");
            if (startDate != null && !startDate.isEmpty()) {
                where.append(" TRUNC(CREATION_TIME) >= '").append(sdf.format(java.sql.Date.valueOf(startDate))).append("'");
            }

            if (endDate != null && !endDate.isEmpty()) {
                if (where.length() > 0) {
                    where.append(" AND ");
                }
                where.append(" TRUNC(CREATION_TIME) <= '").append(sdf.format(java.sql.Date.valueOf(endDate))).append("'");
            }

            forQuery.setSQLQuery(sql.replaceAll("whereStatement", (where.length() > 0 ? " WHERE " : "") + where.toString()));
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
                wbo.setAttribute("campaignTitle", r.getString("CAMPAIGN_TITLE"));
                wbo.setAttribute("campaignID", r.getString("ID"));
                wbo.setAttribute("soldCount", r.getString("SOLD_COUNT"));
                if (userCampaigns == null || userCampaigns.isEmpty() || userCampaigns.contains(r.getString("ID"))) {
                    resultBusObjs.add(wbo);
                }
            }
        } catch (NoSuchColumnException ce) {
            logger.error(ce);
        }
        return resultBusObjs;
    }

    public boolean saveObjects(WebBusinessObject campaignWbo, ArrayList<WebBusinessObject> tools, WebBusinessObject loggedUser) {
        Vector params = new Vector();
        // ArrayList<SQLCommandBean> forInsert = new ArrayList<StringBuilder>();
        SQLCommandBean forInsertCom = new SQLCommandBean();
        int queryResult = -1;
        DateParser dateParser = new DateParser();

        ArrayList<StringBuilder> sql = new ArrayList<StringBuilder>();

        StringBuilder sqlStr = new StringBuilder();
        for (int count = 0; count < tools.size(); count++) {
            String Id = UniqueIDGen.getNextID();
            String title = (String) campaignWbo.getAttribute("mainCampaignTtile") + " - " + tools.get(count).getAttribute("arabicName");
            campaignWbo.setAttribute("id", Id);

            sql.add(sqlStr.append("INSERT INTO CAMPAIGN VALUES ('"));
            sql.set(count, sqlStr.append(Id));
            sql.set(count, sqlStr.append("','"));
            sql.set(count, sqlStr.append(title));
            sql.set(count, sqlStr.append("','"));
            sql.set(count, sqlStr.append((String) tools.get(count).getAttribute("id")));
            sql.set(count, sqlStr.append("','"));

            /*SimpleDateFormat format = new SimpleDateFormat("dd-MM-yyyy");
           java.util.Date parsedFromDate = null;
           java.util.Date parsedToDate = null;
            try {
                parsedFromDate = format.parse((String) campaignWbo.getAttribute("fromDate"));
                parsedToDate = format.parse((String) campaignWbo.getAttribute("toDate"));
            } catch (ParseException ex) {
                Logger.getLogger(CampaignMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
           java.sql.Date fromDate = new java.sql.Date(parsedFromDate.getTime());
           java.sql.Date toDate = new java.sql.Date(parsedToDate.getTime());*/
            sql.set(count, sqlStr.append(""));
            sql.set(count, sqlStr.append("','"));
            sql.set(count, sqlStr.append(""));
            sql.set(count, sqlStr.append("','"));
            sql.set(count, sqlStr.append((String) campaignWbo.getAttribute("cost")));
            sql.set(count, sqlStr.append("','"));
            sql.set(count, sqlStr.append((String) campaignWbo.getAttribute("objective")));
            sql.set(count, sqlStr.append("','"));
            sql.set(count, sqlStr.append((String) campaignWbo.getAttribute("parentID")));
            sql.set(count, sqlStr.append("','"));
            sql.set(count, sqlStr.append((String) campaignWbo.getAttribute("campaignType")));
            sql.set(count, sqlStr.append("','"));
            sql.set(count, sqlStr.append((String) campaignWbo.getAttribute("currentStatus")));
            sql.set(count, sqlStr.append("','"));
            sql.set(count, sqlStr.append(""));
            sql.set(count, sqlStr.append("','"));
            sql.set(count, sqlStr.append((String) loggedUser.getAttribute("userId")));
            sql.set(count, sqlStr.append("','"));
            sql.set(count, sqlStr.append(""));
            sql.set(count, sqlStr.append("','"));
            sql.set(count, sqlStr.append((String) campaignWbo.getAttribute("direction") + "')"));
            sqlStr = new StringBuilder();
        }

        params.addElement(new StringValue((String) campaignWbo.getAttribute("parentID")));
        params.addElement(new StringValue((String) campaignWbo.getAttribute("parentID")));
        params.addElement(new TimestampValue(new Timestamp(System.currentTimeMillis())));
        params.addElement(new TimestampValue(new Timestamp(System.currentTimeMillis())));
        params.addElement(new StringValue((String) campaignWbo.getAttribute("parentID")));
        try {
            beginTransaction();
            forInsertCom.setConnection(transConnection);
            for (int count = 0; count < tools.size(); count++) {
                forInsertCom.setSQLQuery((sql.get(count)).toString());
                try {
                    queryResult = forInsertCom.executeUpdate();
                } catch (SQLException se) {
                    // do nothing - continue with other tools
                }
            }
            forInsertCom.setSQLQuery(getQuery("updatesubCampDate"));
            forInsertCom.setparams(params);
            queryResult = forInsertCom.executeUpdate();
            endTransaction();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            rollbackTransaction();
            return false;
        }
        return (queryResult > 0);
    }

    public boolean deleteSubCampaign(String subCampaignID) {
        int queryResult = -1;
        boolean isDeleted = false;
        Vector params = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        params.addElement(new StringValue(subCampaignID));
        try {
            beginTransaction();
            forUpdate.setConnection(transConnection);
            forUpdate.setSQLQuery(getQuery("deleteSubCamp").trim());
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();
            endTransaction();
            if (queryResult > 0) {
                isDeleted = true;
            } else {
                isDeleted = false;
            }
        } catch (SQLException se) {
            logger.error("Exception updating project: " + se.getMessage());
            return false;
        }
        return isDeleted;
    }

    public boolean deleteCampaign(String CampaignID) {
        int queryResult = -1;
        boolean isDeleted = false;
        Vector params = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        params.addElement(new StringValue(CampaignID));
        try {
            beginTransaction();
            forUpdate.setConnection(transConnection);
            forUpdate.setSQLQuery(getQuery("deleteSubCamp").trim());
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();
            endTransaction();
            if (queryResult > 0) {
                isDeleted = true;
            } else {
                isDeleted = false;
            }
        } catch (SQLException se) {
            logger.error("Exception updating project: " + se.getMessage());
            return false;
        }
        return isDeleted;
    }

    public ArrayList<WebBusinessObject> getClientsCountPerCampaign(String startDate, String endDate, String grpType, ArrayList<String> userCampaigns) {
        WebBusinessObject wbo;
        Connection connection = null;

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();

        StringBuilder sql = null;
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            if (grpType != null && grpType.equals("grpTool")) {
                sql = new StringBuilder(getQuery("campaignClientsReport").trim());
                if (startDate != null && !startDate.isEmpty()) {
                    sql.append(" and cc.CREATION_TIME >= ?");
                    params.addElement(new TimestampValue(java.sql.Timestamp.valueOf(startDate + " 00:00:01")));
                }

                if (endDate != null && !endDate.isEmpty()) {
                    sql.append(" and cc.CREATION_TIME <= ?");
                    params.addElement(new TimestampValue(java.sql.Timestamp.valueOf(endDate + " 23:59:59")));
                }

                sql.append(" group by cp.ID, cp.CAMPAIGN_TITLE, ST.ENGLISHNAME, ST.ARABICNAME");
            } else if (grpType != null && grpType.equals("grpCamp")) {
                SimpleDateFormat sdf = new SimpleDateFormat("dd-MMM-yyyy");
                StringBuilder where = new StringBuilder();
                if (startDate != null && !startDate.isEmpty()) {
                    where.append(" TRUNC(CREATION_TIME) >= '").append(sdf.format(java.sql.Date.valueOf(startDate))).append("'");
                }

                if (endDate != null && !endDate.isEmpty()) {
                    if (where.length() > 0) {
                        where.append(" AND ");
                    }

                    where.append(" TRUNC(CREATION_TIME) <= '").append(sdf.format(java.sql.Date.valueOf(endDate))).append("'");
                }

                sql = new StringBuilder(getQuery("campaignCampClientsReport").replaceAll("whereStatement", (where.length() > 0 ? " WHERE " : "") + where.toString()).trim());
            }

            forQuery.setSQLQuery(sql.toString());
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
                if (r.getString("CLIENT_COUNT") != null) {
                    wbo.setAttribute("clientCount", r.getString("CLIENT_COUNT"));
                } else {
                    wbo.setAttribute("clientCount", "0");
                }

                if (r.getString("CAMPAIGN_TITLE") != null) {
                    wbo.setAttribute("campaignTitle", r.getString("CAMPAIGN_TITLE"));
                } else {
                    wbo.setAttribute("campaignTitle", "---");
                }

                if (r.getString("ID") != null) {
                    wbo.setAttribute("campaignID", r.getString("ID"));
                } else {
                    wbo.setAttribute("campaignID", "---");
                }

                if (grpType != null && grpType.equals("grpTool")) {
                    if (r.getString("ENGLISHNAME") != null) {
                        wbo.setAttribute("ChannelEnName", r.getString("ENGLISHNAME"));
                    } else {
                        wbo.setAttribute("ChannelEnName", "---");
                    }

                    if (r.getString("ARABICNAME") != null) {
                        wbo.setAttribute("ChannelARName", r.getString("ARABICNAME"));
                    } else {
                        wbo.setAttribute("ChannelARName", "---");
                    }
                } else {
                    wbo.setAttribute("soldCount", r.getString("SOLD_COUNT"));
                }

                if (userCampaigns == null || userCampaigns.isEmpty() || userCampaigns.contains(r.getString("ID"))) {
                    resultBusObjs.add(wbo);
                }
            }

        } catch (NoSuchColumnException ce) {
            logger.error(ce);
        }
        return resultBusObjs;
    }

    public ArrayList<WebBusinessObject> getTargetedClientsCountPerCampaign(String startDate, String endDate, String grpType) {
        WebBusinessObject wbo;
        Connection connection = null;

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();

        StringBuilder sql = null;
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            if (grpType != null && grpType.equals("grpCamp")) {
                SimpleDateFormat sdf = new SimpleDateFormat("dd-MMM-yyyy");
                StringBuilder where = new StringBuilder();
                if (startDate != null && !startDate.isEmpty()) {
                    where.append(" TRUNC(TIME1) >= '").append(sdf.format(java.sql.Date.valueOf(startDate))).append("'");
                }

                if (endDate != null && !endDate.isEmpty()) {
                    if (where.length() > 0) {
                        where.append(" AND ");
                    }

                    where.append(" TRUNC(TIME1) <= '").append(sdf.format(java.sql.Date.valueOf(endDate))).append("'");
                }
                String check = "";
                if (where.length() > 0) {
                    check = " WHERE ";
                }
                sql = new StringBuilder("SELECT A.* FROM (SELECT COUNT(CLIENT_NO) CLIENT_COUNT, CP.ID, CP.CAMPAIGN_TITLE ,CP.OBJECTIVE TARGET_COUNT ,CP.COST COST  ,CP.CREATION_TIME  TIME1 FROM CLIENT C INNER JOIN (SELECT DISTINCT CLIENT_ID, CAMPAIGN_ID FROM CLIENT_CAMPAIGN ) CC  ON C.SYS_ID = CC.CLIENT_ID RIGHT JOIN CAMPAIGN CP ON  CC.CAMPAIGN_ID = CP.ID GROUP BY CP.ID, CP.CAMPAIGN_TITLE,CP.OBJECTIVE,CP.COST,CP.CREATION_TIME) A " + check + where.toString().trim());
            }

            forQuery.setSQLQuery(sql.toString());
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
                if (r.getString("CLIENT_COUNT") != null) {
                    wbo.setAttribute("clientCount", r.getString("CLIENT_COUNT"));
                } else {
                    wbo.setAttribute("clientCount", "0");
                }

                if (r.getString("CAMPAIGN_TITLE") != null) {
                    wbo.setAttribute("campaignTitle", r.getString("CAMPAIGN_TITLE"));
                } else {
                    wbo.setAttribute("campaignTitle", "---");
                }

                if (r.getString("ID") != null) {
                    wbo.setAttribute("campaignID", r.getString("ID"));
                } else {
                    wbo.setAttribute("campaignID", "---");
                }
                if (r.getString("COST") != null) {
                    wbo.setAttribute("COST", r.getString("COST"));
                } else {
                    wbo.setAttribute("COST", "COST");
                }

                if (grpType != null && grpType.equals("grpTool")) {
                    if (r.getString("ENGLISHNAME") != null) {
                        wbo.setAttribute("ChannelEnName", r.getString("ENGLISHNAME"));
                    } else {
                        wbo.setAttribute("ChannelEnName", "---");
                    }

                    if (r.getString("ARABICNAME") != null) {
                        wbo.setAttribute("ChannelARName", r.getString("ARABICNAME"));
                    } else {
                        wbo.setAttribute("ChannelARName", "---");
                    }
                } else if (r.getString("TARGET_COUNT") != null) {
                    wbo.setAttribute("soldCount", r.getString("TARGET_COUNT"));
                } else {
                    wbo.setAttribute("soldCount", "0");
                }

                resultBusObjs.add(wbo);
            }

        } catch (NoSuchColumnException ce) {
            logger.error(ce);
        }
        return resultBusObjs;
    }

    public ArrayList<WebBusinessObject> getCampaignLastDaysRatio(String startDate, String endDate, String grpType) {
        WebBusinessObject wbo;
        Connection connection = null;

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();

        StringBuilder sql = null;
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            if (grpType != null && grpType.equals("grpCamp")) {
                SimpleDateFormat sdf = new SimpleDateFormat("dd-MMM-yyyy");
                StringBuilder where = new StringBuilder();
                if (startDate != null && !startDate.isEmpty()) {
                    where.append(" TRUNC(CREATION_TIME) >= '").append(sdf.format(java.sql.Date.valueOf(startDate))).append("'");
                }

                if (endDate != null && !endDate.isEmpty()) {
                    if (where.length() > 0) {
                        where.append(" AND ");
                    }

                    where.append(" TRUNC(CREATION_TIME) <= '").append(sdf.format(java.sql.Date.valueOf(endDate))).append("'");
                }
                String check = "";
                if (where.length() > 0) {
                    check = " WHERE ";
                }

            }
            //   sql = new StringBuilder("SELECT A.* FROM (SELECT COUNT(CLIENT_NO) CLIENT_COUNT, CP.ID, CP.CAMPAIGN_TITLE ,CP.OBJECTIVE TARGET_COUNT ,floor (CP.TO_DATE-CP.FROM_DATE) TOTALL_DAY,floor (CP.TO_DATE-SYSDATE+1) REMAINING_DAYS,floor(SYSDATE-CP.from_date) last_days  FROM CLIENT C INNER JOIN (SELECT DISTINCT CLIENT_ID, CAMPAIGN_ID FROM CLIENT_CAMPAIGN  "+check+ where.toString()+") CC  ON C.SYS_ID = CC.CLIENT_ID RIGHT JOIN CAMPAIGN CP ON  CC.CAMPAIGN_ID = CP.ID GROUP BY CP.ID, CP.CAMPAIGN_TITLE,CP.OBJECTIVE,CP.from_date,CP.TO_DATE) A ".trim());        

            sql = new StringBuilder(getQuery("getDaysRatioCampaigns").trim());
            forQuery.setSQLQuery(sql.toString());
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
                if (r.getString("CLIENT_COUNT") != null) {
                    wbo.setAttribute("clientCount", r.getString("CLIENT_COUNT"));
                } else {
                    wbo.setAttribute("clientCount", "0");
                }

                if (r.getString("CAMPAIGN_TITLE") != null) {
                    wbo.setAttribute("campaignTitle", r.getString("CAMPAIGN_TITLE"));
                } else {
                    wbo.setAttribute("campaignTitle", "---");
                }
                if (r.getString("REMAINING_DAYS") != null) {
                    wbo.setAttribute("REMAINING_DAYS", r.getString("REMAINING_DAYS"));
                } else {
                    wbo.setAttribute("REMAINING_DAYS", "---");
                }
                if (r.getString("last_days") != null) {
                    wbo.setAttribute("last_days", r.getString("last_days"));
                } else {
                    wbo.setAttribute("last_days", "---");
                }
                if (r.getString("TOTALL_DAY") != null) {
                    wbo.setAttribute("TOTALL_DAY", r.getString("TOTALL_DAY"));
                } else {
                    wbo.setAttribute("TOTALL_DAY", "---");
                }

                if (r.getString("ID") != null) {
                    wbo.setAttribute("campaignID", r.getString("ID"));
                } else {
                    wbo.setAttribute("campaignID", "---");
                }

                if (grpType != null && grpType.equals("grpTool")) {
                    if (r.getString("ENGLISHNAME") != null) {
                        wbo.setAttribute("ChannelEnName", r.getString("ENGLISHNAME"));
                    } else {
                        wbo.setAttribute("ChannelEnName", "---");
                    }

                    if (r.getString("ARABICNAME") != null) {
                        wbo.setAttribute("ChannelARName", r.getString("ARABICNAME"));
                    } else {
                        wbo.setAttribute("ChannelARName", "---");
                    }
                } else if (r.getString("TARGET_COUNT") != null) {
                    wbo.setAttribute("soldCount", r.getString("TARGET_COUNT"));
                } else {
                    wbo.setAttribute("soldCount", "0");
                }

                resultBusObjs.add(wbo);
            }

        } catch (NoSuchColumnException ce) {
            logger.error(ce);
        }
        return resultBusObjs;
    }

    public ArrayList<ArrayList<String>> getClientsCountPerCampaignList(String startDate, String endDate) {
        Vector<Row> result = new Vector();

        Connection connection = null;

        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            StringBuilder sql = new StringBuilder(getQuery("campaignClientsReport").trim());
            if (startDate != null && !startDate.isEmpty()) {
                sql.append(" and cc.CREATION_TIME >= ?");
                params.addElement(new TimestampValue(java.sql.Timestamp.valueOf(startDate + " 00:00:01")));
            }

            if (endDate != null && !endDate.isEmpty()) {
                sql.append(" and cc.CREATION_TIME <= ?");
                params.addElement(new TimestampValue(java.sql.Timestamp.valueOf(endDate + " 23:59:59")));
            }

            sql.append(" where cp.CAMPAIGN_TITLE NOT LIKE '%Recycle%' group by cp.ID, cp.CAMPAIGN_TITLE, ST.ENGLISHNAME, ST.ARABICNAME");
            forQuery.setSQLQuery(sql.toString());
            forQuery.setparams(params);
            result = forQuery.executeQuery();
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

        ArrayList<ArrayList<String>> data = new ArrayList<>();
        for (Row r : result) {
            try {
                ArrayList<String> wbo = new ArrayList<>();

                if (r.getString("CAMPAIGN_TITLE") != null) {
                    wbo.add(r.getString("CAMPAIGN_TITLE"));
                } else {
                    wbo.add("---");
                }

                if (r.getString("ENGLISHNAME") != null) {
                    wbo.add(r.getString("ENGLISHNAME"));
                } else {
                    wbo.add("---");
                }

                if (r.getString("CLIENT_COUNT") != null) {
                    wbo.add(r.getString("CLIENT_COUNT"));
                } else {
                    wbo.add("0");
                }

//                if(r.getString("ID") != null) {
//                    wbo.add( r.getString("ID"));
//                } else {
//                    wbo.add("---");
//                }
//                
//                
//                
//                if(r.getString("ARABICNAME") != null) {
//                    wbo.add(r.getString("ARABICNAME"));
//                } else {
//                    wbo.add("---");
//                }
                data.add(wbo);
            } catch (Exception ex) {
                logger.error(ex);
            }
        }
        return data;
    }

    public ArrayList<WebBusinessObject> getProjectCampaign(String projectID) {
        ArrayList<WebBusinessObject> data = new ArrayList<>();
        Vector<Row> result = new Vector();
        Connection connection = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();
        try {
            params.addElement(new StringValue(projectID));

            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getProjectCampaign").trim());
            forQuery.setparams(params);

            result = forQuery.executeQuery();
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

        WebBusinessObject wbo;
        Row r;
        if (result != null) {
            Enumeration e = result.elements();
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = new WebBusinessObject();
                try {
                    wbo.setAttribute("campaignID", r.getString("ID"));
                    wbo.setAttribute("campaignName", r.getString("CAMPAIGN_TITLE"));
                    wbo.setAttribute("fromDate", r.getString("FROM_DATE"));
                    wbo.setAttribute("toDate", r.getString("TO_DATE"));
                    wbo.setAttribute("cost", r.getString("COST"));
                    wbo.setAttribute("objective", r.getString("OBJECTIVE"));

                    data.add(wbo);
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
        return data;
    }

    public ArrayList<WebBusinessObject> getCampaignStat(String startDate, String endDate, String campID, String toolID, String prjID) {
        WebBusinessObject wbo;
        Connection connection = null;

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();

        StringBuilder pramCondition = new StringBuilder();
        StringBuilder joinStmt = new StringBuilder();

        params.addElement(new StringValue(startDate));
        params.addElement(new StringValue(endDate));
        if (campID != null && !campID.equals("")) {
            pramCondition.append(" ( CAMPAIGN.PARENT_ID = ? OR CAMPAIGN.id = ? ) AND ");
            params.addElement(new StringValue(campID));
            params.addElement(new StringValue(campID));
        }

        if (toolID != null && !toolID.equals("")) {
            pramCondition.append("( CAMPAIGN.ID IN (SELECT CAMPAIGN.ID FROM CAMPAIGN WHERE TOOL_ID = ? ) OR CAMPAIGN.ID IN (SELECT CAMPAIGN.PARENT_ID FROM CAMPAIGN WHERE TOOL_ID = ? ) OR campaign.TOOL_ID = ? ) AND");
            params.addElement(new StringValue(toolID));
            params.addElement(new StringValue(toolID));
            params.addElement(new StringValue(toolID));
        }

        if (prjID != null && !prjID.equals("")) {
            joinStmt.append(" LEFT JOIN CAMPAIGN_PROJECT PCAMPPRJ ON campaign.parent_id = PCAMPPRJ.campaign_id ");
            pramCondition.append(" ( PCAMPPRJ.PROJECT_ID = ? OR CAMPAIGN_PROJECT.PROJECT_ID = ? ) AND ");
            params.addElement(new StringValue(prjID));
            params.addElement(new StringValue(prjID));
        }

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("campaignStatistics").replaceAll("joinStmt", joinStmt.toString()).replaceAll("pramCondition", pramCondition.toString()).trim());
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
                if (r.getString("ID") != null) {
                    wbo.setAttribute("CampaignID", r.getString("ID"));
                } else {
                    wbo.setAttribute("CampaignID", "0");
                }

                if (r.getString("CAMPAIGN_TITLE") != null) {
                    wbo.setAttribute("campaignTitle", r.getString("CAMPAIGN_TITLE"));
                } else {
                    wbo.setAttribute("campaignTitle", "---");
                }

                if (r.getString("cost") != null) {
                    wbo.setAttribute("cost", r.getString("cost"));
                } else {
                    wbo.setAttribute("cost", "---");
                }

                if (r.getString("objective") != null) {
                    wbo.setAttribute("objective", r.getString("objective"));
                } else {
                    wbo.setAttribute("objective", "---");
                }

                if (r.getString("parent_id") != null) {
                    wbo.setAttribute("parent_id", r.getString("parent_id"));
                } else {
                    wbo.setAttribute("parent_id", "---");
                }

                if (r.getBigDecimal("InboundTotal") != null) {
                    wbo.setAttribute("InboundTotal", r.getBigDecimal("InboundTotal"));
                } else {
                    wbo.setAttribute("InboundTotal", "0");
                }

                if (r.getBigDecimal("OutboundTotal") != null) {
                    wbo.setAttribute("OutboundTotal", r.getBigDecimal("OutboundTotal"));
                } else {
                    wbo.setAttribute("OutboundTotal", "0");
                }

                if (r.getBigDecimal("Total_Clients") != null) {
                    wbo.setAttribute("Total_Clients", r.getBigDecimal("Total_Clients"));
                } else {
                    wbo.setAttribute("Total_Clients", "0");
                }

                if (r.getString("project_id") != null) {
                    wbo.setAttribute("project_id", r.getString("project_id"));
                } else {
                    wbo.setAttribute("project_id", "---");
                }

                if (r.getString("PROJECT_NAME") != null) {
                    wbo.setAttribute("PROJECT_NAME", r.getString("PROJECT_NAME"));
                } else {
                    wbo.setAttribute("PROJECT_NAME", "---");
                }

                if (r.getString("Tool_Name") != null) {
                    wbo.setAttribute("Tool_Name", r.getString("Tool_Name"));
                } else {
                    wbo.setAttribute("Tool_Name", "---");
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

    public ArrayList<WebBusinessObject> getCampaignPrj(String campID) {
        WebBusinessObject wbo;
        Connection connection = null;

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();

        params.addElement(new StringValue(campID));
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getCampaignPrj").trim());
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
                if (r.getString("PROJECT_ID") != null) {
                    wbo.setAttribute("projectID", r.getString("PROJECT_ID"));
                }

                if (r.getString("PROJECT_NAME") != null) {
                    wbo.setAttribute("projectName", r.getString("PROJECT_NAME"));
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

    public ArrayList<WebBusinessObject> getCampaignTool(String campID) {
        WebBusinessObject wbo;
        Connection connection = null;

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();

        params.addElement(new StringValue(campID));
        params.addElement(new StringValue(campID));
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getCampaignTool").trim());
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
                if (r.getString("ID") != null) {
                    wbo.setAttribute("id", r.getString("ID"));
                }

                if (r.getString("ENGLISH_NAME") != null) {
                    wbo.setAttribute("englishName", r.getString("ENGLISH_NAME"));
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

    public ArrayList<WebBusinessObject> getSyncClntCmpnLst(String[] campaigns) {
        WebBusinessObject wbo;
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();

        StringBuilder whrStmnt = new StringBuilder();
        if (campaigns != null && campaigns.length > 0 && (campaigns[0] != null && !campaigns[0].equalsIgnoreCase("null"))) {
            whrStmnt.append(" WHERE C.ID IN (");
            for (int i = 0; i < campaigns.length; i++) {
                whrStmnt.append("?");
                params.addElement(new StringValue(campaigns[i]));
                if (i < campaigns.length - 1) {
                    whrStmnt.append(",");
                } else {
                    whrStmnt.append(")");
                }
            }
        }

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getSyncClntCmpn").replaceAll("whrStmnt", whrStmnt.toString()).trim());
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

        ArrayList<WebBusinessObject> syncRtClntCmpnLst = new ArrayList<WebBusinessObject>();
        Row r = null;
        Enumeration e = queryResult.elements();
        try {
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = new WebBusinessObject();

                if (r.getString("CAMPAIGN_TITLE") != null) {
                    wbo.setAttribute("task", r.getString("CAMPAIGN_TITLE"));
                }

                if (r.getTimestamp("MIN") != null) {
                    wbo.setAttribute("start", r.getString("MIN").split(" ")[0]);
                }

                if (r.getTimestamp("MAX") != null) {
                    wbo.setAttribute("end", r.getString("MAX").split(" ")[0]);
                }
                syncRtClntCmpnLst.add(wbo);
            }
        } catch (NoSuchColumnException ce) {
            logger.error(ce);
        } catch (Exception ex) {
            logger.error(ex);
        }
        return syncRtClntCmpnLst;
    }

    public ArrayList<WebBusinessObject> getSyncCmpnActvtyLst(String[] campaigns, String prntCmpID) {
        WebBusinessObject wbo;
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();

        StringBuilder whrStmnt = new StringBuilder();
        if (campaigns != null && campaigns.length > 0 && (campaigns[0] != null && !campaigns[0].equalsIgnoreCase("null"))) {
            whrStmnt.append(" AND C.ID IN (");
            for (int i = 0; i < campaigns.length; i++) {
                whrStmnt.append("?");
                params.addElement(new StringValue(campaigns[i]));
                if (i < campaigns.length - 1) {
                    whrStmnt.append(",");
                } else {
                    whrStmnt.append(")");
                }
            }
        }

        if (prntCmpID != null && !prntCmpID.isEmpty()) {
            whrStmnt.append(" AND (C.PARENT_ID = ?");
            params.addElement(new StringValue(prntCmpID));

            whrStmnt.append(" OR C.ID = ?)");
            params.addElement(new StringValue(prntCmpID));
        }

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getSyncCmpnActvtyLst").replaceAll("whrStmnt", whrStmnt.toString()).trim());
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

        ArrayList<WebBusinessObject> syncRtClntCmpnLst = new ArrayList<WebBusinessObject>();
        Row r = null;
        Enumeration e = queryResult.elements();
        try {
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = new WebBusinessObject();

                if (r.getString("CAMPAIGN_TITLE") != null) {
                    wbo.setAttribute("task", r.getString("CAMPAIGN_TITLE"));
                }

                if (r.getString("ID") != null) {
                    wbo.setAttribute("cmpnId", r.getString("ID"));
                }

                if (r.getTimestamp("BEGIN_DATE") != null) {
                    wbo.setAttribute("start", r.getString("BEGIN_DATE"));
                }

                if (r.getTimestamp("END_DATE") != null) {
                    wbo.setAttribute("end", r.getString("END_DATE"));
                }
                syncRtClntCmpnLst.add(wbo);
            }
        } catch (NoSuchColumnException ce) {
            logger.error(ce);
        } catch (Exception ex) {
            logger.error(ex);
        }
        return syncRtClntCmpnLst;
    }

    public ArrayList<WebBusinessObject> getChannelCampaigns(String channelID) {
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();
        try {
            params.addElement(new StringValue(channelID));
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getChannelCampaigns").trim());
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
        ArrayList<WebBusinessObject> resultBusObjs = new ArrayList<>();
        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            resultBusObjs.add(fabricateBusObj(r));
        }
        return resultBusObjs;
    }

    public ArrayList<WebBusinessObject> getAllCampaign(String fromDate, String toDate, String statusID, String userID, String departmentID, boolean mainOnly) {
        WebBusinessObject wbo;
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            /*StringBuilder sql = new StringBuilder();
            if (fromDate != null && !fromDate.isEmpty() && toDate != null && !toDate.isEmpty()) {
                sql.append(" WHERE (TRUNC(C.CREATION_TIME) BETWEEN  to_date(?, 'yyyy/mm/dd') AND to_date(?, 'yyyy/mm/dd')")
                        .append(" OR TRUNC(C.CREATION_TIME) BETWEEN  to_date(?, 'yyyy/mm/dd') AND to_date(?, 'yyyy/mm/dd')")
                        .append(" OR to_date(?, 'yyyy/mm/dd') BETWEEN TRUNC(C.CREATION_TIME) AND TRUNC(C.CREATION_TIME)")
                        .append(" OR to_date(?, 'yyyy/mm/dd') BETWEEN TRUNC(C.CREATION_TIME) AND TRUNC(C.CREATION_TIME))");
                params.addElement(new StringValue(fromDate));
                params.addElement(new StringValue(toDate));
                params.addElement(new StringValue(fromDate));
                params.addElement(new StringValue(toDate));
                params.addElement(new StringValue(fromDate));
                params.addElement(new StringValue(toDate));
            } else if (fromDate != null && !fromDate.isEmpty() && toDate == null) {
                sql.append(" WHERE TRUNC(C.CREATION_TIME) >=  to_date(?, 'yyyy/mm/dd')");
                params.addElement(new StringValue(fromDate));
            }

            if (statusID != null && !statusID.isEmpty() && !statusID.equals(" ")) {
                if (statusID.equals("15")) {
                    statusID += "','UL";
                }
                if (sql != null && sql.length() > 0) {
                    sql.append(" AND ");
                } else {
                    sql.append(" WHERE ");
                }
                sql.append(" C.CURRENT_STATUS IN ('").append(statusID).append("')");
            }
            // for security by department
            if (sql.length() > 0) {
                sql.append(" AND ");
            } else {
                sql.append(" WHERE ");
            }
            if (departmentID == null || departmentID.isEmpty()) {
                sql.append(" c.direction= '2' ")
                        .append(userID).append("'))");
            } else {
                sql.append(" C.CREATED_BY IN (SELECT OPTION_ONE FROM PROJECT WHERE PROJECT_ID = '").append(departmentID).append("')");
            }
            if (mainOnly) {
                if (sql.length() > 0) {
                    sql.append(" AND ");
                } else {
                    sql.append(" WHERE ");
                }
                sql.append(" C.PARENT_ID = '0'");
            }*/

            forQuery.setSQLQuery(getQuery("getAllCampaign").trim());
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
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = fabricateBusObj(r);
            try {
                if (r.getString("FULL_NAME") != null) {
                    wbo.setAttribute("fullName", r.getString("FULL_NAME"));
                }
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(CampaignMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }

    public ArrayList<WebBusinessObject> getClientsCountPerMainCampaign(String startDate, String endDate, ArrayList<String> userCampaigns) {
        WebBusinessObject wbo;
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();
        StringBuilder sql = null;
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            SimpleDateFormat sdf = new SimpleDateFormat("dd-MMM-yyyy");
            StringBuilder where = new StringBuilder();
            if (startDate != null && !startDate.isEmpty()) {
                where.append(" TRUNC(CREATION_TIME) >= '").append(sdf.format(java.sql.Date.valueOf(startDate))).append("'");
            }

            if (endDate != null && !endDate.isEmpty()) {
                if (where.length() > 0) {
                    where.append(" AND ");
                }

                where.append(" TRUNC(CREATION_TIME) <= '").append(sdf.format(java.sql.Date.valueOf(endDate))).append("'");
            }
            sql = new StringBuilder(getQuery("mainCampaignClientsReport").replace("whereStatement", (where.length() > 0 ? " WHERE " : "") + where.toString())
                    .replace(" andStatement", (where.length() > 0 ? " AND " : "") + where.toString()).trim());
            forQuery.setSQLQuery(sql.toString());
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
        ArrayList<WebBusinessObject> resultBusObjs = new ArrayList<>();
        Row r = null;
        Enumeration e = queryResult.elements();
        try {
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = new WebBusinessObject();
                if (r.getString("CLIENT_COUNT") != null) {
                    wbo.setAttribute("clientCount", r.getString("CLIENT_COUNT"));
                } else {
                    wbo.setAttribute("clientCount", "0");
                }
                if (r.getString("CAMPAIGN_TITLE") != null) {
                    wbo.setAttribute("campaignTitle", r.getString("CAMPAIGN_TITLE"));
                } else {
                    wbo.setAttribute("campaignTitle", "---");
                }
                if (r.getString("ID") != null) {
                    wbo.setAttribute("campaignID", r.getString("ID"));
                } else {
                    wbo.setAttribute("campaignID", "---");
                }
                wbo.setAttribute("soldCount", r.getString("SOLD_COUNT"));
                if (userCampaigns == null || userCampaigns.isEmpty() || userCampaigns.contains(r.getString("ID"))) {
                    resultBusObjs.add(wbo);
                }
            }

        } catch (NoSuchColumnException ce) {
            logger.error(ce);
        }
        return resultBusObjs;
    }

    public ArrayList<WebBusinessObject> getCampaignStatuses() {
        String theQuery = getQuery("getCampaignStatuses").trim();
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        ArrayList<WebBusinessObject> data = new ArrayList<>();
        Vector<Row> result;
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(theQuery);
            result = command.executeQuery();

            WebBusinessObject wbo;
            for (Row row : result) {
                wbo = fabricateBusObj(row);
                try {
                    if (row.getString("ID") != null) {
                        wbo.setAttribute("statusTypeID", row.getString("ID"));
                    }
                    if (row.getString("CASE_EN") != null) {
                        wbo.setAttribute("typeNameEn", row.getString("CASE_EN"));
                    }
                    if (row.getString("CASE_AR") != null) {
                        wbo.setAttribute("typeNameAr", row.getString("CASE_AR"));
                    }
                } catch (NoSuchColumnException ex) {
                    logger.error(ex);
                }
                data.add(wbo);
            }
        } catch (SQLException | UnsupportedTypeException ex) {
            logger.error(ex);
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex);
            }
        }
        return data;
    }

    public ArrayList<WebBusinessObject> getUserDepartmentsCampaigns(String userID) {
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();
        try {
            params.addElement(new StringValue(userID));
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getUserDepartmentsCampaigns").trim());
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
        ArrayList<WebBusinessObject> resultBusObjs = new ArrayList<>();
        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            resultBusObjs.add(fabricateBusObj(r));
        }
        return resultBusObjs;
    }

    public ArrayList<WebBusinessObject> getPorjectsCampaigns(java.sql.Date fromDate, java.sql.Date toDate) {
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();
        StringBuilder where = new StringBuilder();
        try {
            if (fromDate != null) {
                where.append(" AND TRUNC(CM.CREATION_TIME) >= ? ");
                params.addElement(new DateValue(fromDate));
            }
            if (toDate != null) {
                where.append(" AND TRUNC(CM.CREATION_TIME) <= ? ");
                params.addElement(new DateValue(toDate));
            }
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getPorjectsCampaigns").replace("whereStatement", where.toString()).trim());
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
        ArrayList<WebBusinessObject> results = new ArrayList<>();
        Row r = null;
        Enumeration e = queryResult.elements();
        WebBusinessObject wbo;
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = fabricateBusObj(r);
            try {
                if (r.getString("PROJECT_ID") != null) {
                    wbo.setAttribute("projectID", r.getString("PROJECT_ID"));
                }
                if (r.getString("PROJECT_NAME") != null) {
                    wbo.setAttribute("projectName", r.getString("PROJECT_NAME"));
                }
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(CampaignMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            results.add(wbo);
        }
        return results;
    }

    public ArrayList<WebBusinessObject> getBrokersCampaigns() {
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getBrokersCampaigns").trim());
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
        ArrayList<WebBusinessObject> results = new ArrayList<>();
        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            results.add(fabricateBusObj(r));
        }
        return results;
    }

    public Map<String, Map<String, String>> getCampaignClientsDetails(String campaignID, java.sql.Date fromDate, java.sql.Date toDate, Set<String> ratesNames) {
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();
        try {
            params.addElement(new StringValue(campaignID));
            params.addElement(new DateValue(fromDate));
            params.addElement(new DateValue(toDate));
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getCampaignClientsDetails").trim());
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
        Map<String, Map<String, String>> results = new HashMap<>();
        Row r = null;
        Enumeration e = queryResult.elements();
        Map<String, String> tempMap;
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            try {
                if (r.getString("CAMPAIGN_TITLE") != null) {
                    if (results.containsKey(r.getString("CAMPAIGN_TITLE"))) {
                        tempMap = results.get(r.getString("CAMPAIGN_TITLE"));
                    } else {
                        tempMap = new HashMap<>();
                    }
                    if (r.getString("RATE_NAME") != null && r.getString("TOTAL_CLIENT") != null) {
                        tempMap.put(r.getString("RATE_NAME"), r.getString("TOTAL_CLIENT"));
                        if (!ratesNames.contains(r.getString("RATE_NAME"))) {
                            ratesNames.add(r.getString("RATE_NAME"));
                        }
                    } else if (r.getString("TOTAL_CLIENT") != null) {
                        tempMap.put("Not Rated", r.getString("TOTAL_CLIENT"));
                    }
                    if (!results.containsKey(r.getString("CAMPAIGN_TITLE"))) {
                        results.put(r.getString("CAMPAIGN_TITLE"), tempMap);
                    }
                }
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(CampaignMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return results;
    }

    public ArrayList<WebBusinessObject> getAllCampaignList() {
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getAllCampaign").trim());
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
        WebBusinessObject wbo = new WebBusinessObject();
        ArrayList<WebBusinessObject> results = new ArrayList<>();
        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = fabricateBusObj(r);

            try {
                if (r.getString("FULL_NAME") != null) {
                    wbo.setAttribute("fullName", r.getString("FULL_NAME"));
                }
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(CampaignMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            results.add(wbo);
        }

        return results;
    }

    public WebBusinessObject getCampaignInfo(String campaignID, String fromDate, String toDate) {
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();
        
        DateParser dateParser = new DateParser();

        params.addElement(new StringValue(fromDate.replaceAll("-", "/")));
        params.addElement(new StringValue(toDate.replaceAll("-", "/")));
        params.addElement(new StringValue(campaignID));

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getCampainInfo").trim());
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
        WebBusinessObject wbo = new WebBusinessObject();

        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();

            try {
                if (r.getString("CAMPAIGN_TITLE") != null) {
                    wbo.setAttribute("CAMPAIGN_TITLE", r.getString("CAMPAIGN_TITLE"));
                }
                if (r.getTimestamp("FROM_DATE") != null) {
                    wbo.setAttribute("FROM_DATE", r.getTimestamp("FROM_DATE"));
                }
                if (r.getTimestamp("TO_DATE") != null) {
                    wbo.setAttribute("TO_DATE", r.getTimestamp("TO_DATE"));
                }
                if (r.getBigDecimal("COST") != null) {
                    wbo.setAttribute("COST", r.getBigDecimal("COST"));
                }
                if (r.getString("CASE_EN") != null) {
                    wbo.setAttribute("CASE_EN", r.getString("CASE_EN"));
                }
                if (r.getString("Total_Campaign_Client") != null) {
                    wbo.setAttribute("Total_Campaign_Client", r.getString("Total_Campaign_Client"));
                }
                if (r.getString("Period_client") != null) {
                    wbo.setAttribute("Period_client", r.getString("Period_client"));
                } else {
                     wbo.setAttribute("Period_client", "0");
                } 
                
                if (r.getString("MaxClientDate") != null) {
                    wbo.setAttribute("MaxClientDate", r.getString("MaxClientDate"));
                }
                if (r.getString("user_name") != null) {
                    wbo.setAttribute("user_name", r.getString("user_name"));
                }
                if (r.getTimestamp("CREATION_TIME") != null) {
                    wbo.setAttribute("CREATION_TIME", r.getTimestamp("CREATION_TIME"));
                }
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(CampaignMgr.class.getName()).log(Level.SEVERE, null, ex);
            } catch (Exception ex) {
                logger.error(ex);
            }
        }

        return wbo;
    }
    
    public ArrayList<WebBusinessObject> getCampaignsF(String[] departmentIds) {
    SQLCommandBean forQuery = new SQLCommandBean();
    Connection connection = null;
    Vector parameters = new Vector();
    Vector<Row> result = new Vector();
    ArrayList<WebBusinessObject> list = new ArrayList<>();
    
    if (departmentIds == null || departmentIds.length == 0) return list;

    // بناء SQL ديناميكي للـ IN
    StringBuilder placeholders = new StringBuilder();
    for (int i = 0; i < departmentIds.length; i++) {
        placeholders.append("?");
        if (i < departmentIds.length - 1) placeholders.append(",");
        parameters.addElement(new StringValue(departmentIds[i]));
    }

    String getScript = "select id, campaign_title from campaign where direction IN (" + placeholders.toString() + ")";

    try {
        connection = dataSource.getConnection();
        forQuery.setConnection(connection);
        forQuery.setparams(parameters);
        forQuery.setSQLQuery(getScript.trim());
        result = forQuery.executeQuery();
    } catch (SQLException ex) {
        logger.error("SQL Exception  " + ex.getMessage());
    } catch (UnsupportedTypeException uste) {
        logger.error("***** " + uste.getMessage());
    } finally {
        try {
            connection.close();
        } catch (SQLException ex) {
            logger.error("***** " + ex.getMessage());
        }
    }

    for (Row row : result) {
        list.add(fabricateBusObj(row));
    }
    return list;
}

}
