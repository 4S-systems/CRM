package com.maintenance.common;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import com.silkworm.util.*;

import java.util.*;
import java.text.*;
import java.sql.*;
import javax.servlet.http.HttpSession;
import org.apache.log4j.xml.DOMConfigurator;

public class UserDepartmentConfigMgr extends RDBGateWay {

    private static UserDepartmentConfigMgr userDepartmentConfigMgr = new UserDepartmentConfigMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();

    public static UserDepartmentConfigMgr getInstance() {
        logger.info("Getting UserDepartmentConfigMgr Instance ....");
        return userDepartmentConfigMgr;
    }

    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("user_department_config.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public WebBusinessObject getUserDepts(String userID, String deptID) {
        WebBusinessObject wbo = null;
        Connection connection = null;
        Vector queryResult = null;
        
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            StringBuilder sql = new StringBuilder("Select * from USER_DEPARTMENT_CONFIG where DEPARTMENT_ID = ? and USER_ID = ?");
            params.addElement(new StringValue(deptID));
            params.addElement(new StringValue(userID));
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
        Row r;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = fabricateBusObj(r);
            return wbo;
        }
        return wbo;
    }
    
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }
    
    public boolean saveUserDeprtments(WebBusinessObject wbo) {
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue((String) wbo.getAttribute("deptId")));
        params.addElement(new StringValue((String) wbo.getAttribute("userId")));
        params.addElement(new StringValue((String) wbo.getAttribute("isDefualt")));
              
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertUserDeptConfig").trim());
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

    public ArrayList getCashedTableAsArrayList() {
        return null;
    }

    @Override
    protected void initSupportedQueries() {
        return; //throw new UnsupportedOperationException("Not supported yet.");
    }
    
    public ArrayList<WebBusinessObject> getUserDeptartmentConfig(String userID) {
        WebBusinessObject wbo = null;
        Connection connection = null;
        Vector queryResult = null;
        
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            StringBuilder sql = new StringBuilder("Select * from USER_DEPARTMENT_CONFIG where USER_ID = ?");
            params.addElement(new StringValue(userID));
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
        Row r;
        Enumeration e = queryResult.elements();
        ArrayList<WebBusinessObject> result = new ArrayList<WebBusinessObject>();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            result.add(wbo);
        }
        return result;
    }
}