package com.tracker.db_access;

import com.maintenance.common.Tools;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import com.silkworm.persistence.relational.StringValue;
import java.util.*;
import javax.servlet.http.HttpSession;
import java.sql.*;
import java.util.ArrayList;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import org.apache.log4j.xml.DOMConfigurator;

public class LocationTypeMgr extends RDBGateWay {

    private static LocationTypeMgr locationTypeMgr = new LocationTypeMgr();
    public static LocationTypeMgr getInstance() {
        logger.info("Getting LocationTypeMgr Instance ....");
        return locationTypeMgr;
    }

    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("location_type.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public boolean saveObject(HttpServletRequest req) throws NoUserInSessionException {

        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue((String) req.getParameter("typeCode")));
        params.addElement(new StringValue((String) req.getParameter("arDesc")));
        params.addElement(new StringValue((String) req.getParameter("enDesc")));
        params.addElement(new StringValue((String) req.getParameter("NON")));
        params.addElement(new StringValue((String) req.getParameter("NON")));

        try {
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(getQuery("insert").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            //
            cashData();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } finally {
            endTransaction();
        }

        return (queryResult > 0);
    }

    public ArrayList getCashedTableAsBusObjects() {
        cashedData = new ArrayList();
        WebBusinessObject wbo = null;

        locationTypeMgr.cashData();
        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add(wbo);
        }

        return cashedData;
    }

    public ArrayList getCashedTableAsArrayList() {

        cashedData = new ArrayList();
        WebBusinessObject wbo = null;

        locationTypeMgr.cashData();
        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add((String) wbo.getAttribute("arDesc"));
            cashedData.add((String) wbo.getAttribute("enDesc"));
        }

        return cashedData;
    }

    public String getAllSites() {
        cashData();
        StringBuffer sb = new StringBuffer();
        for (int i = 0; i < cashedTable.size(); i++) {
            sb.append(((WebBusinessObject) cashedTable.get(i)).getAttribute("id").toString() + " ");
        }

        return sb.toString();
    }

    public boolean update(HttpServletRequest req) throws NoUserInSessionException {

        Vector params = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;
        params.addElement(new StringValue((String) req.getParameter("typeCode")));
        params.addElement(new StringValue((String) req.getParameter("arDesc")));
        params.addElement(new StringValue((String) req.getParameter("enDesc")));
        params.addElement(new StringValue((String) req.getParameter("id")));

        try {
            beginTransaction();
            forUpdate.setConnection(transConnection);
            forUpdate.setSQLQuery(getQuery("update").trim());
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();

            endTransaction();
            cashData();
        } catch (SQLException se) {
            logger.error("Exception updating project: " + se.getMessage());
            return false;
        }

        return (queryResult > 0);
    }

    public boolean delete(HttpServletRequest req) throws NoUserInSessionException {

        Vector params = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;
        params.addElement(new StringValue((String) req.getParameter("id")));

        try {
            beginTransaction();
            forUpdate.setConnection(transConnection);
            forUpdate.setSQLQuery(getQuery("delete").trim());
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();

            endTransaction();
            cashData();
        } catch (SQLException se) {
            logger.error("Exception updating project: " + se.getMessage());
            return false;
        }

        return (queryResult > 0);
    }
    
    public boolean updateDisplayInTree(String ids) {
        Vector params = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;
        String query = getQuery("updateDisplayInTree").trim().replaceAll("ids", ids);
        params.addElement(new StringValue("1"));
        try {
            beginTransaction();
            forUpdate.setConnection(transConnection);
            forUpdate.setSQLQuery(query.replaceAll("inValue", "IN"));
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();
            
            params.removeAllElements();
            params.addElement(new StringValue("0"));
            forUpdate.setSQLQuery(query.replaceAll("inValue", "NOT IN"));
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();
            endTransaction();
            cashData();
        } catch (SQLException se) {
            logger.error("Exception updating project: " + se.getMessage());
            return false;
        }
        return (queryResult > 0);
    }

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
        return; //  throw new UnsupportedOperationException("Not supported yet.");
    }
    
    public Map<String, String> getLocationTypesMap(String[] ticketTypeIDs) {
        WebBusinessObject wbo;
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            StringBuilder in = new StringBuilder();
            in.append("'").append(Tools.arrayToString(ticketTypeIDs, "','")).append("'");
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            String sql = getQuery("getLocationTypesMap").trim();
            sql = sql.replaceFirst("inStatement", in.toString());
            forQuery.setSQLQuery(sql);
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
        Map<String, String> resultMap = new HashMap<>();
        Row r = null;
        Enumeration e = queryResult.elements();
        try {
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                if (r.getString("TYPE_ID") != null && r.getString("TYPE_NAME") != null) {
                    resultMap.put(r.getString("TYPE_ID"), r.getString("TYPE_NAME"));
                }
            }
        } catch (NoSuchColumnException ce) {
            logger.error(ce);
        }
        return resultMap;
    }
    
    public ArrayList<WebBusinessObject> getLocationTypeUsingLike(String likeTypCode) {
        WebBusinessObject wbo;
        Connection connection = null;
        Vector<Row> query = new Vector<>();
        Vector parameters = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        parameters.addElement(new StringValue("%" + likeTypCode + "%"));
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setparams(parameters);
            forQuery.setSQLQuery(getQuery("getLocationTypeUsingLike"));
            query = forQuery.executeQuery();
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

        ArrayList<WebBusinessObject> result = new ArrayList<>();
        for (Row row : query) {
            wbo = fabricateBusObj(row);
            result.add(wbo);
        }
        
        return result;
    }
    
    public WebBusinessObject getLocationTypeByID(String ticketTypeIDs) {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector<Row> query = new Vector<>();
        Vector parameters = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        StringBuilder in = new StringBuilder();
        parameters.addElement(new StringValue("%" + ticketTypeIDs + "%"));
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setparams(parameters);
            forQuery.setSQLQuery(getQuery("getLocationTypeUsingLike"));
            query = forQuery.executeQuery();
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

        for (Row row : query) {
            wbo = fabricateBusObj(row);
        }
        
        return wbo;
    }
}
