package com.tracker.db_access;

import com.maintenance.common.DateParser;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.common.SecurityUser;
import com.silkworm.persistence.relational.StringValue;
import java.util.*;
import java.sql.*;
import javax.servlet.http.HttpSession;
import org.apache.log4j.xml.DOMConfigurator;

public class ClientIncentiveMgr extends RDBGateWay {

    private static final ClientIncentiveMgr clientIncentiveMgr = new ClientIncentiveMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();

    public ClientIncentiveMgr() {
    }

    public static ClientIncentiveMgr getInstance() {
        logger.info("Getting ClientIncentiveMgr Instance ....");
        return clientIncentiveMgr;
    }

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("client_incentive.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public boolean saveIncentivesByClient(String clientID, String[] incentiveIDs, String[] incentiveDates, HttpSession s) {

        int queryResult = -1000;
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();

        SecurityUser securityUser = (SecurityUser) s.getAttribute("securityUser");
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            forInsert.setConnection(connection);
            DateParser dateParser = new DateParser();
            String sql = getQuery("saveClientIncentives").trim();
            forInsert.setSQLQuery(sql);
            int i = 0;
            for (String incentiveID : incentiveIDs) {
                params = new Vector();
                params.addElement(new StringValue(UniqueIDGen.getNextID()));
                params.addElement(new StringValue(clientID));
                params.addElement(new StringValue(incentiveID));
                if (incentiveDates.length > i && incentiveDates[i] != null && !incentiveDates[i].isEmpty()) {
                    params.addElement(new DateValue(dateParser.formatSqlDate(incentiveDates[i].replaceAll("-", "/"))));
                } else {
                    params.addElement(new DateValue(dateParser.formatSqlDate((new java.sql.Date(Calendar.getInstance().getTimeInMillis())).toString().replaceAll("-", "/"))));
                }
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

    public ArrayList<WebBusinessObject> getIncentivesByClientList(String clientId) {
        ArrayList<WebBusinessObject> incentivesByClientList = new ArrayList<WebBusinessObject>();
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
            forQuery.setSQLQuery(getQuery("getIncentivesByClient").trim());
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
                    wbo.setAttribute("incentiveID", r.getString("ID"));
                    wbo.setAttribute("incentiveTitle", r.getString("INCENTIVE_TITLE"));
                    if (r.getString("INCENTIVE_DATE") != null) {
                        wbo.setAttribute("incentiveDate", r.getString("INCENTIVE_DATE"));
                    } else {
                        wbo.setAttribute("incentiveDate", "");
                    }
                    incentivesByClientList.add(wbo);
                }

            } catch (NoSuchColumnException ce) {
                logger.error(ce);
            }
        }
        return incentivesByClientList;

    }

    public ArrayList<String> getIncentiveIDsByClientList(String clientId) {
        ArrayList<String> incentiveIDsByClientList = new ArrayList<String>();
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
            forQuery.setSQLQuery(getQuery("getIncentivesByClient").trim());
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
                    incentiveIDsByClientList.add(r.getString("ID"));
                }

            } catch (NoSuchColumnException ce) {
                logger.error(ce);
            }
        }
        return incentiveIDsByClientList;

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
