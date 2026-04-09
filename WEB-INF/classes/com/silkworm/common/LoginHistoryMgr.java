package com.silkworm.common;

import com.silkworm.business_objects.BusinessForm;
import com.silkworm.business_objects.DOMFabricatorBean;
import com.silkworm.business_objects.SqlMgr;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.persistence.relational.DateValue;
import com.silkworm.persistence.relational.NoSuchColumnException;
import com.silkworm.persistence.relational.RDBGateWay;
import com.silkworm.persistence.relational.Row;
import com.silkworm.persistence.relational.SQLCommandBean;
import com.silkworm.persistence.relational.StringValue;
import com.silkworm.persistence.relational.UniqueIDGen;
import com.silkworm.persistence.relational.UnsupportedTypeException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Enumeration;
import java.util.List;
import java.util.Vector;
import org.apache.log4j.xml.DOMConfigurator;

public class LoginHistoryMgr extends RDBGateWay {

    private static final LoginHistoryMgr loginHistoryMgr = new LoginHistoryMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();

    public LoginHistoryMgr() {
    }

    public static LoginHistoryMgr getInstance() {
        logger.info("Getting LoginHistoryMgr Instance ....");
        return loginHistoryMgr;
    }

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("login_history.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        int queryResult = -1000;
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            forInsert.setConnection(connection);
            String sql = getQuery("insertLoginHistory").trim();
            forInsert.setSQLQuery(sql);
            params.addElement(new StringValue(UniqueIDGen.getNextID()));
            params.addElement(new StringValue((String) wbo.getAttribute("userID")));
            params.addElement(new StringValue(wbo.getAttribute("option1") != null ? (String) wbo.getAttribute("option1") : ""));
            params.addElement(new StringValue(wbo.getAttribute("option2") != null ? (String) wbo.getAttribute("option2") : ""));
            params.addElement(new StringValue(wbo.getAttribute("option3") != null ? (String) wbo.getAttribute("option3") : ""));
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
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

    public ArrayList<WebBusinessObject> getGroupAttendanceInPeriod(Date fromDate, Date toDate, String groupID) {
        WebBusinessObject wbo;
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();
        params.addElement(new DateValue(fromDate));
        params.addElement(new DateValue(toDate));
        params.addElement(new StringValue(groupID));
        StringBuilder sql = null;
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            sql = new StringBuilder(getQuery("getGroupAttendanceInPeriod").trim());
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
                wbo = fabricateBusObj(r);
                if (r.getString("FULL_NAME") != null) {
                    wbo.setAttribute("employeeName", r.getString("FULL_NAME"));
                }
                if (r.getString("NO_OF_DAYS") != null) {
                    wbo.setAttribute("noOfDays", r.getString("NO_OF_DAYS"));
                }
                resultBusObjs.add(wbo);
            }
        } catch (NoSuchColumnException ce) {
            logger.error(ce);
        }
        return resultBusObjs;
    }

    public ArrayList<WebBusinessObject> getUserAttendanceInPeriod(Date fromDate, Date toDate, String userID) {
        WebBusinessObject wbo;
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();
        params.addElement(new StringValue(userID));
        params.addElement(new DateValue(fromDate));
        params.addElement(new DateValue(toDate));
        StringBuilder sql = null;
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            sql = new StringBuilder(getQuery("getUserAttendanceInPeriod").trim());
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
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }
    
    public ArrayList<WebBusinessObject> getFirstLastLogin(Date fromDate, Date toDate) {
        WebBusinessObject wbo;
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();
        params.addElement(new DateValue(fromDate));
        params.addElement(new DateValue(toDate));
        StringBuilder sql = null;
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            sql = new StringBuilder(getQuery("getFirstLastLogin").trim());
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
                wbo = fabricateBusObj(r);
                if (r.getString("FIRST_LOGIN") != null) {
                    wbo.setAttribute("firstLogin", r.getString("FIRST_LOGIN").substring(11, 16)); // time only
                }
                if (r.getString("FIRST_USER_NAME") != null) {
                    wbo.setAttribute("firstUserName", r.getString("FIRST_USER_NAME"));
                }
                if (r.getString("LAST_LOGIN") != null) {
                    wbo.setAttribute("lastLogin", r.getString("LAST_LOGIN").substring(11, 16)); // time only
                }
                if (r.getString("LAST_USER_NAME") != null) {
                    wbo.setAttribute("lastUserName", r.getString("LAST_USER_NAME"));
                }
                if (r.getString("LOGIN_DATE") != null) {
                    wbo.setAttribute("loginDate", r.getString("LOGIN_DATE").substring(0, 10));
                }
                resultBusObjs.add(wbo);
            }
        } catch (NoSuchColumnException ce) {
            logger.error(ce);
        }
        return resultBusObjs;
    }
    
    public ArrayList<WebBusinessObject> getLoginInDay(String userID,Date fromDate,String departmentID,String byUserID) {
        WebBusinessObject wbo;
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();
        String query=getQuery("getLoginInDay").trim();
          
        for(int i=0;i<6;i++){
        params.addElement(new DateValue(fromDate));
        }
        if(!departmentID.equalsIgnoreCase("all") ){
         
        query=query.replace("bydepartid"," = ?");
        params.addElement(new StringValue(departmentID));
        }else{
        query=query.replace("bydepartid","in (select department_id from user_department_config where user_id= ?)");
        params.addElement(new StringValue(userID));
        }
        if(!byUserID.equalsIgnoreCase("all")){
        query=query.replace("byuserid", "and fh.user_id=?");
        params.addElement(new StringValue(byUserID));
        }else{
        query=query.replace("byuserid","");
        }
        StringBuilder sql = null;
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            sql = new StringBuilder(query.trim());
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
                wbo = fabricateBusObj(r);
                if (r.getString("entryCount") != null) {
                    wbo.setAttribute("entryCount", r.getString("entryCount")); 
                }
                if (r.getString("user_id") != null) {
                    wbo.setAttribute("userID", r.getString("user_id")); 
                }
                if (r.getString("userName") != null) {
                    wbo.setAttribute("userName", r.getString("userName"));
                }
                if (r.getString("minTime") != null) {
                    wbo.setAttribute("minTime", r.getString("minTime")); // time only
                }
                if (r.getString("maxTime") != null) {
                    wbo.setAttribute("maxTime", r.getString("maxTime")); // time only
                }
                
                resultBusObjs.add(wbo);
            }
        } catch (NoSuchColumnException ce) {
            logger.error(ce);
        }
        return resultBusObjs;
    }
}
