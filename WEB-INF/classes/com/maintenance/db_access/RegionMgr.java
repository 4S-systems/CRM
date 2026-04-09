package com.maintenance.db_access;

import com.maintenance.common.Tools;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import com.silkworm.util.*;

import java.util.*;
import java.text.*;
import java.sql.*;

import javax.servlet.http.HttpSession;
import org.apache.log4j.xml.DOMConfigurator;

public class RegionMgr extends RDBGateWay {

    private static RegionMgr regionMgr = new RegionMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();

    public RegionMgr() {
    }

    public static RegionMgr getInstance() {
        logger.info("Getting RegionMgr Instance ....");
        return regionMgr;
    }

    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("region.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public boolean saveObject(WebBusinessObject region, HttpSession s) throws NoUserInSessionException {
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;


        params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue((String) region.getAttribute("name")));
        params.addElement(new StringValue((String) region.getAttribute("code")));


        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery("Insert into REGION values(?,?,?,'UL')");
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            cashData();
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

    public boolean saveObjectForClient(WebBusinessObject wbo, HttpSession s) throws NoUserInSessionException {
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        
        params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue((String) wbo.getAttribute("arName")));
        params.addElement(new StringValue((String) wbo.getAttribute("code")));
        params.addElement(new StringValue((String) waUser.getAttribute("userId")));
        params.addElement(new StringValue((String) wbo.getAttribute("arName")));

//        params.addElement(new StringValue((String) wbo.getAttribute("enName")));
//        if (wbo.getAttribute("enName") != null) {
//            params.addElement(new StringValue((String) wbo.getAttribute("enName")));
//        } else {
//        }
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(getQuery("insertRegionP").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
//            cashData();
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

    public boolean updateTrade(WebBusinessObject wbo) throws NoUserInSessionException {


        Vector params = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;
        params.addElement(new StringValue((String) wbo.getAttribute("tradeName")));
        params.addElement(new StringValue((String) wbo.getAttribute("tradeCode")));
        params.addElement(new StringValue((String) wbo.getAttribute("tradeId")));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(sqlMgr.getSql("updateTrade").trim());
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();

            cashData();
        } catch (SQLException se) {
            logger.error("Exception updating project: " + se.getMessage());
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

    public void UpdateUserTrade(String TradeName, String OldTradeName) {
        Vector tradenameParams = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();

        tradenameParams.addElement(new StringValue(TradeName));
        tradenameParams.addElement(new StringValue(OldTradeName));//Total Time
        Connection connection = null;


        try {
            connection = dataSource.getConnection();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(sqlMgr.getSql("updateUserTrade").trim());
            forUpdate.setparams(tradenameParams);
            int queryResult = forUpdate.executeUpdate();
        } catch (SQLException sex) {
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }
    }

    @Override
    public ArrayList getCashedTableAsBusObjects() {
        regionMgr.cashData();
        cashedData = new ArrayList();
        WebBusinessObject wbo = null;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add(wbo);
        }

        return cashedData;
    }

    public ArrayList getCashedTableAsArrayList() {

        cashedData = new ArrayList();
        WebBusinessObject wbo = null;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add((String) wbo.getAttribute("tradeName"));
        }

        return cashedData;
    }

    public boolean getActiveTrade(String tradeId) throws Exception {
        Vector SQLparams = new Vector();
        Connection connection = null;
        Vector queryResult = null;
        SQLparams.addElement(new StringValue(tradeId));
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getActiveTrade").trim());
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();


        } catch (SQLException se) {
            logger.error("database error from getListOnSecondKey: ImageMgr " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return false;
            }
        }

        return queryResult.size() > 0;
    }

    public Vector getTradesBySort() {

        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        StringBuilder query = new StringBuilder(sqlMgr.getSql("getTradesBySort").trim());

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            queryResult = forQuery.executeQuery();


        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        Vector resultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }

    public ArrayList getTradesBySort2() {

        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        StringBuilder query = new StringBuilder(sqlMgr.getSql("getTradesBySort").trim());

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            queryResult = forQuery.executeQuery();


        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        ArrayList resultBusObjs = new ArrayList();

        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }

    public Vector getTradesByIds(String[] ids) {

        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        String query = sqlMgr.getSql("getTradesByIds").trim();
        query = query.replaceAll("iii", Tools.concatenation(ids, ","));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            queryResult = forQuery.executeQuery();


        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        Vector resAsWbo = new Vector();
        Row row;
        for (int i = 0; i < queryResult.size(); i++) {
            row = (Row) queryResult.get(i);
            try {
                resAsWbo.addElement(row.getString("NAME"));
            } catch (NoSuchColumnException ex) {
                logger.error(ex.getMessage());
            }
        }

        return resAsWbo;
    }

    public ArrayList getAllAsArrayList() {
        ArrayList allAsArrayList = new ArrayList();

        Vector allAsVector = getTradesBySort();

        for (int i = 0; i < allAsVector.size(); i++) {
            allAsArrayList.add((WebBusinessObject) allAsVector.get(i));
        }

        return allAsArrayList;
    }

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
        return;
    }
}
