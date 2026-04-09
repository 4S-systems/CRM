package com.maintenance.db_access;

import com.maintenance.common.Tools;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import com.silkworm.util.*;

import java.util.*;
import java.text.*;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.http.HttpServletRequest;

import javax.servlet.http.HttpSession;
import org.apache.log4j.xml.DOMConfigurator;

public class TradeMgr extends RDBGateWay {

    private static TradeMgr tradeMgr = new TradeMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();

    public TradeMgr() {
    }

    public static TradeMgr getInstance() {
        logger.info("Getting TradeMgr Instance ....");
        return tradeMgr;
    }

    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("trade.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public boolean saveObject(WebBusinessObject trade, HttpSession s) throws NoUserInSessionException {

        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue((String) trade.getAttribute("tradeName")));
        params.addElement(new StringValue((String) trade.getAttribute("tradeNO")));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertTrade").trim());
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

    public String saveObjectForClient(WebBusinessObject wbo, HttpSession s) throws NoUserInSessionException {
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        String id = UniqueIDGen.getNextID();
        params.addElement(new StringValue(id));//id

        params.addElement(new StringValue((String) wbo.getAttribute("arName")));//name
        params.addElement(new StringValue((String) wbo.getAttribute("code")));//code
//        params.addElement(new StringValue((String) wbo.getAttribute("enName")));
//        if (wbo.getAttribute("enName") != null) {
//            params.addElement(new StringValue((String) wbo.getAttribute("enName")));
//        } else {
        params.addElement(new StringValue((String) wbo.getAttribute("enName")));//en_name
//        }
        params.addElement(new StringValue("1")); //flage 1 for client and 0 for users

        WebBusinessObject wboCreation = (WebBusinessObject) s.getAttribute("loggedUser");

        params.addElement(new StringValue((String) wboCreation.getAttribute("userId")));//created by
        // params.addElement(new StringValue((String) wbo.getAttribute("code")));//creation time
        params.addElement(new StringValue((String) wbo.getAttribute("ttradeTypeId")));//trade type
        params.addElement(new StringValue((String) wbo.getAttribute("code")));//option 1
        params.addElement(new StringValue((String) wbo.getAttribute("code")));//option 2

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(getQuery("insertJob").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
//            cashData();
        } catch (SQLIntegrityConstraintViolationException se) {
            logger.error(se.getMessage());
            return "dublicate";
        } catch (SQLException ex) {
            logger.error(ex.getMessage());
            return ex.getMessage();
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
                return ex.getMessage();
            }
        }

        return "ok";
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
        tradeMgr.cashData();
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

    public Vector getTradeByType(String tradeTypeId) throws SQLException, Exception {
//        StringBuilder dq = new StringBuilder("SELECT * FROM ");
//        dq.append(supportedForm.getTableSupported().getAttribute("name"));
//        dq.append(" where flage !=0");
        String theQuery = sqlMgr.getSql("getTradesByType").trim();
        Vector SQLparams = new Vector();

        SQLparams.addElement(new StringValue(tradeTypeId));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = dataSource.getConnection();
        try {
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(theQuery);
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            throw se;
        } catch (UnsupportedTypeException uste) {
            logger.error(uste.getMessage());
        } finally {
            connection.close();
        }

        // process the vector
        // vector of business objects
        Vector reultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            WebBusinessObject wbo=fabricateBusObj(r);
            if(r.getString("clientCount")!=null)
                wbo.setAttribute("clientCount", r.getString("clientCount"));
            else
                wbo.setAttribute("clientCount", "0");
            reultBusObjs.add(wbo);
        }

        return reultBusObjs;
    }

    public boolean updateTrade(HttpServletRequest request) {

        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1;

        params.addElement(new StringValue(request.getParameter("code")));
        params.addElement(new StringValue(request.getParameter("english_name")));
        params.addElement(new StringValue(request.getParameter("arabic_name")));

        params.addElement(new StringValue(request.getParameter("tradeId")));
        try {
            //connection = dataSource.getConnection();
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(getQuery("updateTrade").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            endTransaction();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        }
        return (queryResult > 0);
    }

    public WebBusinessObject getTradeByName(String tradeName) {
        WebBusinessObject wbo;
        Connection connection = null;
        StringBuilder query = new StringBuilder(getQuery("getTradeByName").trim());

        Vector param = new Vector();
        param.add(new StringValue(tradeName));
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(param);
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
                logger.error("Close Error");
            }
        }

        WebBusinessObject resultBusObjs = new WebBusinessObject();
        if (queryResult != null) {
            Row r = null;
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
            }
            resultBusObjs = fabricateBusObj(r);
        }

        return resultBusObjs;
    }
}
