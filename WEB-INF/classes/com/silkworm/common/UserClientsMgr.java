package com.silkworm.common;

import com.maintenance.common.DateParser;
import com.maintenance.db_access.TradeMgr;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import com.silkworm.db_access.GrantsMgr;
import java.sql.SQLException;
import com.silkworm.util.DictionaryItem;
import com.tracker.db_access.ProjectMgr;
import java.util.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.*;
import java.sql.Connection;
import com.maintenance.db_access.TradeMgr;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.logging.Level;
import java.util.logging.Logger;

public class UserClientsMgr extends RDBGateWay {

    private static UserClientsMgr userClientsMgr = new UserClientsMgr();
    private String[] sys_paths = null;
    private String imageDirPath = null;
    SqlMgr sqlMgr = SqlMgr.getInstance();
    String generatedUserId = null;
    String sessionUserId = null;
    TradeMgr tradeMgr = TradeMgr.getInstance();

    @Override
    protected void initSupportedForm() {
        if (supportedForm == null) {
            try {
                System.out.println("UserClientsMgr ..***********.trying to get the XML file from path:: " + webInfPath);
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("user_clients.xml")));
            } catch (Exception e) {
                System.out.println("Could not locate XML Document");
            }
        }
    }

    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public static UserClientsMgr getInstance() {
        System.out.println("Getting UserMgr Instance ....");
        return userClientsMgr;
    }

    public void setSysPaths(String[] sys_paths) {
        this.sys_paths = sys_paths;
        imageDirPath = sys_paths[1];

    }

//    public boolean saveObject(WebBusinessObject wbo, HttpSession s) throws NoUserInSessionException {
//        setUserID();
//        setSessionUser(s);
//        
//        
//        if(wbo == null) {
//            System.out.println("null object is passed");
//        } else {
//            System.out.println("the object is just fine");
//        }
//        
//        WebAppUser user = (WebAppUser)wbo;
//        Vector params = new Vector();
//        SQLCommandBean forInsert = new SQLCommandBean();
//        int queryResult = -1000;
//        
//        if(this.createUserHomeDir() && this.createUserImageDir()) {
//            params.addElement(new StringValue(getUserID()));
//            params.addElement(new StringValue(user.getUserName()));
//            params.addElement(new StringValue(user.getPassword()));
//            params.addElement(new StringValue("u" + getUserID()));
//            params.addElement(new StringValue(getSessionUser()));
//            params.addElement(new StringValue(user.getEmail()));
//            params.addElement(new StringValue("0"));
//            params.addElement(new StringValue(user.getFullName()));
//            params.addElement(new StringValue(user.getSodicId()));
//            try {
//                //transConnection = dataSource.getConnection();
//                //transConnection.setAutoCommit(false);
//                forInsert.setConnection(transConnection);
//                
//                forInsert.setSQLQuery(sqlMgr.getSql("insertUser").trim());
//                forInsert.setparams(params);
//                queryResult = forInsert.executeUpdate();
//                // transConnection.rollback();
//                System.out.println("reight insertion");
//            } catch(SQLException se) {
//                logger.error(se.getMessage());
//                return false;
//            }
//            
//        } else {
//            return false;
//        }
//
//        return (queryResult > 0);
//    }
    public boolean upsertUserClientRelation(WebBusinessObject userRelationWbo) throws ParseException {
        Vector params = new Vector();
        Connection connection = null;
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = 0;
        String from_date = userRelationWbo.getAttribute("fromDate").toString();

        SimpleDateFormat parser = new SimpleDateFormat("MM/dd/yyyy");
        from_date = from_date.replaceAll("-", "/");
        Date from = parser.parse(from_date);
        java.sql.Date fromDate = new java.sql.Date(from.getTime());;
        try {

            params.addElement(new StringValue((String) userRelationWbo.getAttribute("userId")));
            params.addElement(new StringValue((String) userRelationWbo.getAttribute("clientId")));
            params.addElement(new StringValue((String) userRelationWbo.getAttribute("comments")));
            params.addElement(new DateValue(fromDate));
            params.addElement(new StringValue((String) userRelationWbo.getAttribute("relationType")));


            params.addElement(new StringValue(UniqueIDGen.getNextID()));
            params.addElement(new StringValue((String) userRelationWbo.getAttribute("userId")));
            params.addElement(new StringValue((String) userRelationWbo.getAttribute("clientId")));
            params.addElement(new StringValue((String) userRelationWbo.getAttribute("comments")));
            params.addElement(new StringValue((String) userRelationWbo.getAttribute("createdBy")));
            params.addElement(new DateValue(fromDate));
            params.addElement(new StringValue((String) userRelationWbo.getAttribute("relationType")));

            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            //MERGE INTO user_clients t USING dual ON (t.user_id = ? AND t.client_id = ?) WHEN MATCHED THEN UPDATE SET comments = ? WHEN NOT MATCHED THEN INSERT (id, user_id, client_id, comments) VALUES (?,?,?,?)
            forInsert.setSQLQuery(sqlMgr.getSql("upsertUserClientRelation").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();

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

    public boolean updateEqpEmp(WebBusinessObject eqpEmpWbo) {
        Vector params = new Vector();
        Connection connection = null;
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = 0;
        Vector eqpEmpVec = null;

        try {
            eqpEmpVec = userClientsMgr.getOnArbitraryDoubleKey(
                    (String) eqpEmpWbo.getAttribute("userId"),
                    "key1",
                    (String) eqpEmpWbo.getAttribute("clientId"),
                    "key2");

        } catch (SQLException ex) {
            Logger.getLogger(UserClientsMgr.class.getName()).log(Level.SEVERE, null, ex);

        } catch (Exception ex) {
            Logger.getLogger(UserClientsMgr.class.getName()).log(Level.SEVERE, null, ex);

        }

        if (eqpEmpVec.isEmpty()) {

            beginTransaction();
            forInsert.setConnection(transConnection);

            try {

                params.addElement(new DateValue((java.sql.Date) eqpEmpWbo.getAttribute("fromDate")));
                params.addElement(new StringValue((String) eqpEmpWbo.getAttribute("clientId")));
                params.addElement(new StringValue((String) eqpEmpWbo.getAttribute("relationType")));

                forInsert.setSQLQuery(getQuery("updateTypeEndDate").trim());
                forInsert.setparams(params);
                queryResult = forInsert.executeUpdate();

                queryResult = 0;
                params.removeAllElements();
                String id = UniqueIDGen.getNextID();
                params.addElement(new StringValue(id));
                params.addElement(new StringValue((String) eqpEmpWbo.getAttribute("userId")));
                params.addElement(new StringValue((String) eqpEmpWbo.getAttribute("clientId")));
                params.addElement(new DateValue((java.sql.Date) eqpEmpWbo.getAttribute("fromDate")));
                params.addElement(new StringValue((String) eqpEmpWbo.getAttribute("relationType")));
                params.addElement(new StringValue((String) eqpEmpWbo.getAttribute("tradeId")));

                forInsert.setSQLQuery(getQuery("insertData").trim());
                forInsert.setparams(params);
                queryResult = forInsert.executeUpdate();

            } catch (SQLException se) {
                try {
                    transConnection.rollback();
                } catch (SQLException ex) {
                    Logger.getLogger(UserClientsMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                return false;

            } finally {
                endTransaction();

            }

        } else {    // update start date only

            try {

//                params.addElement(new DateValue((java.sql.Date) eqpEmpWbo.getAttribute("fromDate")));
//                params.addElement(new StringValue((String) eqpEmpWbo.getAttribute("userId")));
//                params.addElement(new StringValue((String) eqpEmpWbo.getAttribute("clientId")));
//                
//                
//                connection = dataSource.getConnection();
//                forInsert.setConnection(connection);
//                forInsert.setSQLQuery(getQuery("updateTypeStartDate").trim());
//                forInsert.setparams(params);
//                queryResult = forInsert.executeUpdate();

                connection = dataSource.getConnection();
                forInsert.setConnection(connection);
                params.addElement(new DateValue((java.sql.Date) eqpEmpWbo.getAttribute("fromDate")));
                params.addElement(new StringValue((String) eqpEmpWbo.getAttribute("clientId")));
                params.addElement(new StringValue((String) eqpEmpWbo.getAttribute("relationType")));

                forInsert.setSQLQuery(getQuery("updateTypeEndDate").trim());
                forInsert.setparams(params);
                queryResult = forInsert.executeUpdate();

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
        }

        return (queryResult > 0);
    }

    public String getAttachedEmployees() {
        Vector<Row> queryResult = new Vector<Row>();
        Vector params = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        String attachedEmployeesStr = "";

        try {
            beginTransaction();
            forQuery.setConnection(transConnection);
            forQuery.setSQLQuery(getQuery("getAttachedEmployees").trim());
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
            endTransaction();

        } catch (SQLException se) {
            System.out.println("Error In executing Query.............!" + se.getMessage());
        } catch (UnsupportedTypeException ex) {
            Logger.getLogger(UserClientsMgr.class.getName()).log(Level.SEVERE, null, ex);
        }
        for (int i = 0; i < queryResult.size(); i++) {
            try {
                if (i == queryResult.size() - 1) {
                    attachedEmployeesStr += "'" + ((Row) queryResult.get(i)).getString("user_id").toString() + "'";
                } else {
                    attachedEmployeesStr += "'" + ((Row) queryResult.get(i)).getString("user_id").toString() + "'" + ",";
                }
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(UserClientsMgr.class.getName()).log(Level.SEVERE, null, ex);
            }

        }
        return attachedEmployeesStr;

    }

    public Vector getUnitEmployees(String unitId) {
        Connection connection = null;

        String query = getQuery("getUnitEmployees").trim();
        Vector resVec = new Vector();
        Vector params = new Vector();
        params.addElement(new StringValue(unitId));
        Vector queryResult = null;
        Row row = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setparams(params);
            forQuery.setSQLQuery(query);
            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return null;
            }
        }

        for (int i = 0; i < queryResult.size(); i++) {
            row = (Row) queryResult.get(i);
            try {
                WebBusinessObject tempWbo = new WebBusinessObject();
                tempWbo.setAttribute("userName", row.getString("full_name"));
                tempWbo.setAttribute("fromDate", row.getString("from_date").replaceAll("-", "/"));
                tempWbo.setAttribute("empType", row.getString("relation_type"));
                resVec.addElement(tempWbo);
            } catch (NoSuchColumnException ex) {
                logger.error(ex.getMessage());
            }
        }

        return resVec;
    }

    public Vector getCompetentEmp(String clientId) {
        Connection connection = null;

        String query = getQuery("getCompetentEmp").trim();
        Vector resVec = new Vector();
        Vector params = new Vector();
        params.addElement(new StringValue(clientId));
        Vector queryResult = null;
        Row row = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setparams(params);
            forQuery.setSQLQuery(query);
            queryResult = forQuery.executeQuery();
            Vector newData = new Vector();
            Row r = null;
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                WebBusinessObject wbo = null;
                r = (Row) e.nextElement();
                wbo = new WebBusinessObject();
                wbo = fabricateBusObj(r);
                newData.add(wbo);
            }
            return newData;
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return null;
            }
        }
    }

    public boolean deleteUserClientRelation(WebBusinessObject userRelationWbo) throws ParseException {
        Vector params = new Vector();
        Connection connection = null;
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = 0;
        try {

            params.addElement(new StringValue((String) userRelationWbo.getAttribute("userId")));
            params.addElement(new StringValue((String) userRelationWbo.getAttribute("clientId")));

            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            //MERGE INTO user_clients t USING dual ON (t.user_id = ? AND t.client_id = ?) WHEN MATCHED THEN UPDATE SET comments = ? WHEN NOT MATCHED THEN INSERT (id, user_id, client_id, comments) VALUES (?,?,?,?)
            forInsert.setSQLQuery(sqlMgr.getSql("deleteUserClientRelation").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();

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

    private void setSessionUser(HttpSession s) {
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        //waUser.printSelf();
        sessionUserId = (String) waUser.getAttribute("userId");
    }

    private String getSessionUser() {
        return sessionUserId;
    }

    private void setUserID() {
        generatedUserId = UniqueIDGen.getNextID();
    }

    private String getUserID() {
        return generatedUserId;
    }

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
        return;
    }

    @Override
    public ArrayList getCashedTableAsArrayList() {
        throw new UnsupportedOperationException("Not supported yet.");
    }
}
