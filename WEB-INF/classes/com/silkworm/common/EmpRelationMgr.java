package com.silkworm.common;

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
import java.util.logging.Level;
import java.util.logging.Logger;

public class EmpRelationMgr extends RDBGateWay {

    private final static EmpRelationMgr EMP_RELATION_MGR = new EmpRelationMgr();

    SqlMgr sqlMgr = SqlMgr.getInstance();
    String generatedUserId = null;
    String sessionUserId = null;
    TradeMgr tradeMgr = TradeMgr.getInstance();

    @Override
    protected void initSupportedForm() {
        if (supportedForm == null) {
            try {
                System.out.println("EmpRelationMgr ..***********.trying to get the XML file from path:: " + webInfPath);
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("emp_mgr_table.xml")));
            } catch (Exception e) {
                System.out.println("Could not locate XML Document");
            }
        }
    }

    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public static EmpRelationMgr getInstance() {
        System.out.println("Getting UserMgr Instance ....");
        return EMP_RELATION_MGR;
    }

    public boolean isEmployeeBelongsToDepartment(String employeeId, String departmentId) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        Vector result = new Vector();
        parameters.addElement(new StringValue(departmentId));
        parameters.addElement(new StringValue(employeeId));

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("isEmployeeBelongsToDepartment").trim());
            command.setparams(parameters);
            result = command.executeQuery();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } catch (UnsupportedTypeException se) {
            logger.error(se.getMessage());
            return false;
        } finally {
            try {
                connection.close();
            } catch (SQLException se) {
                logger.error(se.getMessage());
            }
        }

        return (result.size() > 0);
    }

    public boolean upsertEmpRelation(WebBusinessObject empRelationWbo) {
        Vector params = new Vector();
        Connection connection = null;
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = 0;

        try {

            params.addElement(new StringValue((String) empRelationWbo.getAttribute("firstEmpId")));
            params.addElement(new StringValue((String) empRelationWbo.getAttribute("secondEmpId")));
            params.addElement(new StringValue((String) empRelationWbo.getAttribute("comments")));

            params.addElement(new StringValue(UniqueIDGen.getNextID()));
            params.addElement(new StringValue((String) empRelationWbo.getAttribute("firstEmpId")));
            params.addElement(new StringValue((String) empRelationWbo.getAttribute("secondEmpId")));
            params.addElement(new StringValue((String) empRelationWbo.getAttribute("comments")));

            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("upsertEmpRelation").trim());
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

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
    }

    @Override
    public ArrayList getCashedTableAsArrayList() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public String getDepartmentByManager(String userID) {
        String departmentID = null;
        Vector params = new Vector();
        Connection connection = null;
        SQLCommandBean forInsert = new SQLCommandBean();
        Vector queryResult;
        try {
            params.addElement(new StringValue(userID));

            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("findDepartmentByManager").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeQuery();
            Row r = null;
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                departmentID = r.getString(1);

            }
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        } catch (UnsupportedTypeException ex) {
            Logger.getLogger(EmpRelationMgr.class.getName()).log(Level.SEVERE, null, ex);
        } catch (NoSuchColumnException ex) {
            Logger.getLogger(EmpRelationMgr.class.getName()).log(Level.SEVERE, null, ex);
        }
        return departmentID;
    }
}
