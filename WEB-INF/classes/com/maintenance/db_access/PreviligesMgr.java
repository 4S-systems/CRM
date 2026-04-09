package com.maintenance.db_access;

import com.maintenance.common.Tools;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.common.SecurityUser;
import java.util.*;
import java.sql.*;
import javax.servlet.http.HttpSession;
import org.apache.log4j.xml.DOMConfigurator;

public class PreviligesMgr extends RDBGateWay {

    private static PreviligesMgr previligesMgr = new PreviligesMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();
    SecurityUser securityUser = new SecurityUser();

    public PreviligesMgr() {
    }

    public static PreviligesMgr getInstance() {
        logger.info("Getting UserStoresMgr Instance ....");
        return previligesMgr;
    }

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("previliges.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public boolean saveUserStores(String userID, Vector userStores, HttpSession s, String type) {

        int queryResult = -1000;
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();

        securityUser = (SecurityUser) s.getAttribute("securityUser");
        WebBusinessObject userStoreWBO = new WebBusinessObject();
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            forInsert.setConnection(connection);

            // delete old privileges before saving new ones
            params = new Vector();
            params.addElement(new StringValue(userID));
            params.addElement(new StringValue(type));
            forInsert.setparams(params);
            forInsert.setSQLQuery(sqlMgr.getSql("deleteOldPrivileges").trim());
            queryResult = forInsert.executeUpdate();

            String sql = sqlMgr.getSql("saveUserStore").trim();
            forInsert.setSQLQuery(sql);

            for (int i = 0; i < userStores.size(); i++) {

                userStoreWBO = (WebBusinessObject) userStores.get(i);

                params = new Vector();

                params.addElement(new StringValue(UniqueIDGen.getNextID()));
                params.addElement(new StringValue(userID));
                params.addElement(new StringValue((String) userStoreWBO.getAttribute("storeNameAr")));
                params.addElement(new StringValue((String) userStoreWBO.getAttribute("storeNameEn")));
                params.addElement(new StringValue((String) userStoreWBO.getAttribute("storeCode")));
//                    params.addElement(new StringValue(""));
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
                connection.commit();
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
                return false;
            }
        }

        return (queryResult > 0);
    }

    public ArrayList<String> getPrivilegeCodes(String prvlgType) {
        ArrayList<String> userPrivilegeList = new ArrayList<String>();
        Row r = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;
        Enumeration e = null;
        Vector params = new Vector();

        params.addElement(new StringValue(prvlgType));

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getPrivilegeCodes").trim());
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        e = queryResult.elements();

        try {
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                userPrivilegeList.add(r.getString("PREV_CODE"));

            }

        } catch (NoSuchColumnException ce) {
            logger.error(ce);
        }

        return userPrivilegeList;

    }

    public boolean deleteUserStoresByBranches(String userId, String[] branches) {
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        Connection connection = null;

        String sql = sqlMgr.getSql("deleteUserStoresByBranches").trim();
        sql = sql.replaceAll("bbb", Tools.concatenation(branches, ","));

        params.addElement(new StringValue(userId));

        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sql);
            forInsert.setparams(params);

            forInsert.executeUpdate();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error " + ex.getMessage());
                return false;
            }
        }

        return true;
    }

    public boolean updateStores(String storeId) {

        SQLCommandBean forInsert = new SQLCommandBean();
        Connection connection = null;

        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery("UPDATE USER_STORE SET USER_STORE.STORE_NAME_EN = (SELECT NAME_EN FROM STORES_ERP WHERE CODE = '" + storeId + "') WHERE STORE_CODE = '" + storeId + "'");

            forInsert.executeUpdate();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error " + ex.getMessage());
                return false;
            }
        }

        return true;
    }

    public Vector getPrivliges(String type) throws SQLException, NoSuchColumnException {

        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = dataSource.getConnection();
        Vector queryResult = null;
        Vector params = new Vector();
        params.addElement(new StringValue(type));
        try {

            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getAllPrevliges").trim());
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            throw se;

        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            connection.close();
        }

        // process the vector
        // vector of business objects
        Vector reultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();

        while (e.hasMoreElements()) {
            WebBusinessObject resWbo = new WebBusinessObject();
            r = (Row) e.nextElement();
            resWbo.setAttribute("id", r.getString("ID"));
            resWbo.setAttribute("prevNameAr", r.getString("PREV_NAME_AR"));
            resWbo.setAttribute("prevNameEn", r.getString("PREV_NAME_EN"));
            resWbo.setAttribute("prevCode", r.getString("PREV_CODE"));
            resWbo.setAttribute("type", r.getString("TYPE"));
            reultBusObjs.add(resWbo);
        }

        return reultBusObjs;

    }

    @Override
    public ArrayList getCashedTableAsBusObjects() {
        cashedData = new ArrayList();
        WebBusinessObject wbo = null;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add(wbo);
        }

        return cashedData;
    }

    @Override
    public ArrayList getCashedTableAsArrayList() {

        cashedData = new ArrayList();
        WebBusinessObject wbo = null;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add((String) wbo.getAttribute("Description"));
        }

        return cashedData;
    }

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
        return;
    }
}
