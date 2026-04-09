package com.maintenance.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import com.silkworm.common.SecurityUser;
import com.silkworm.common.UserMgr;
import java.sql.SQLException;
import java.util.*;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.http.HttpSession;
import org.apache.log4j.xml.DOMConfigurator;

public class UserTradeMgr extends RDBGateWay {

    private static UserTradeMgr userTradeMgr = new UserTradeMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();

    public UserTradeMgr() {
    }

    public static UserTradeMgr getInstance() {
        logger.info("Getting UserTradeMgr Instance ....");
        return userTradeMgr;
    }

    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("user_trade.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public ArrayList getSalesUsers() throws UnsupportedTypeException {
        WebBusinessObject wbo = new WebBusinessObject();
        Vector params = new Vector();
        SQLCommandBean executeQuery = new SQLCommandBean();
//        int queryResult = -1000;
        Vector queryResult = null;
        String tradeId = "2";
        String query = "SELECT * FROM user_trade WHERE trade_id=" + "'" + tradeId + "'";
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            executeQuery.setConnection(connection);
            executeQuery.setSQLQuery(query.trim());
            queryResult = executeQuery.executeQuery();
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
        } catch (SQLException se) {
            System.out.println("Exception inserting group: " + se.getMessage());
            return null;
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                System.out.println("Close Error");
                return null;
            }
        }

    }

    public boolean saveUserTrade(String userID, Vector userTrades, String tradeIdDefault, HttpSession session) throws Exception {

        int queryResult = -1000;
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        UserMgr userMgr = UserMgr.getInstance();
        WebBusinessObject wbo = new WebBusinessObject();
        wbo = userMgr.getOnSingleKey(userID);
        String userName = "";
        if (wbo != null) {
            userName = (String) wbo.getAttribute("userName");
        }

//            SecurityUser securityUser = (SecurityUser) session.getAttribute("securityUser");
        WebBusinessObject userTradeWBO = new WebBusinessObject();
        Connection connection = null;

        try {

            connection = dataSource.getConnection();
            connection.setAutoCommit(true);
            forInsert.setConnection(connection);
            try {
                UserTradeMgr userTradeMgr = UserTradeMgr.getInstance();
                userTradeMgr.deleteOnArbitraryKey(userID, "key1");
            } catch (SQLException ex) {
                connection.rollback();
            }
            String sql = sqlMgr.getSql("insertUserTrade").trim();
            forInsert.setSQLQuery(sql);

            for (int i = 0; i < userTrades.size(); i++) {

                userTradeWBO = (WebBusinessObject) userTrades.get(i);

                params = new Vector();

                params.addElement(new StringValue(UniqueIDGen.getNextID()));
                params.addElement(new StringValue((String) userTradeWBO.getAttribute("tradeId")));
                params.addElement(new StringValue((String) userTradeWBO.getAttribute("tradeName")));

                params.addElement(new StringValue(userID));
                params.addElement(new StringValue(userName));
                params.addElement(new StringValue((String) userTradeWBO.getAttribute("tradeQualification")));
                params.addElement(new StringValue((String) userTradeWBO.getAttribute("isDefault")));
                params.addElement(new StringValue((String) userTradeWBO.getAttribute("notes")));
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

//                forInsert.setSQLQuery(sqlMgr.getSql("updateUserTrades").trim());
//                params = new Vector();
//                params.addElement(new StringValue(tradeIdDefault));
//                params.addElement(new StringValue(userID));
//                forInsert.setparams(params);
//                queryResult = forInsert.executeUpdate();
//
//                    if(queryResult <= 0){
//                        connection.rollback();
//                        return false;
//                    }
        } catch (SQLException se) {
            try {
                connection.rollback();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
            logger.error(se.getMessage());
            return false;
        } finally {
            try {
//                    connection.commit();
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
                return false;
            }
        }

        return (queryResult > 0);
    }

    public ArrayList getCashedTableAsArrayList() {
        return null;
    }

    public ArrayList getCashedTableAsBusObjects() {
        return null;
    }

    @Override
    protected void initSupportedQueries() {
        return; //  throw new UnsupportedOperationException("Not supported yet.");
    }
}
