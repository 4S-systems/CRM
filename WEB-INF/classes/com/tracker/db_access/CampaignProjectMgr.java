package com.tracker.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.common.SecurityUser;
import com.silkworm.persistence.relational.StringValue;
import java.util.*;
import java.sql.*;
import javax.servlet.http.HttpSession;
import org.apache.log4j.xml.DOMConfigurator;

public class CampaignProjectMgr extends RDBGateWay {

    private static final CampaignProjectMgr campaignProjectMgr = new CampaignProjectMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();

    public CampaignProjectMgr() {
    }

    public static CampaignProjectMgr getInstance() {
        logger.info("Getting CampaignProjectMgr Instance ....");
        return campaignProjectMgr;
    }

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("campaign_project.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public boolean saveProjectsByCampaign(String campaignID, String[] projectIDs, HttpSession s) {

        int queryResult = -1000;
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();

        SecurityUser securityUser = (SecurityUser) s.getAttribute("securityUser");
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            forInsert.setConnection(connection);

            String sql = getQuery("saveCampaignProjects").trim();
            forInsert.setSQLQuery(sql);
            for (String projectID : projectIDs) {
                params = new Vector();
                params.addElement(new StringValue(UniqueIDGen.getNextID()));
                params.addElement(new StringValue(campaignID));
                params.addElement(new StringValue(projectID));
                params.addElement(new StringValue(securityUser.getUserId()));
                forInsert.setparams(params);
                queryResult = forInsert.executeUpdate();
                if (queryResult <= 0) {
                    connection.rollback();
                    return false;
                }
                try {
                    Thread.sleep(100);
                } catch (InterruptedException ex) {
                    logger.error(ex.getMessage());
                }
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

    public ArrayList<WebBusinessObject> getProjectByCampaignList(String campaignId) {
        ArrayList<WebBusinessObject> projectByCampaignList = new ArrayList<>();
        Row r;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;
        Enumeration e = null;
        Vector params = new Vector();

        params.addElement(new StringValue(campaignId));
        params.addElement(new StringValue(campaignId));

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getProjectsByCampaign").trim());
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
                    WebBusinessObject wbo = new WebBusinessObject();
                    if (r.getString("PROJECT_ID") != null) {
                        wbo.setAttribute("projectID", r.getString("PROJECT_ID"));
                    }
                    if (r.getString("PROJECT_NAME") != null) {
                        wbo.setAttribute("projectName", r.getString("PROJECT_NAME"));
                    } else {
                        wbo.setAttribute("projectName", "");
                    }
                    projectByCampaignList.add(wbo);
                }

            } catch (NoSuchColumnException ce) {
                logger.error(ce);
            }
        }
        return projectByCampaignList;

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
