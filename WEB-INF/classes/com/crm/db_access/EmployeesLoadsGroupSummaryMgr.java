/*
 * EmployeesLoadsMgr.java
 *
 * Created on March 25, 2005, 12:35 AM
 */
package com.crm.db_access;

import com.silkworm.business_objects.*;
import com.silkworm.persistence.relational.*;
import java.io.Serializable;
import java.sql.*;
import java.util.*;
import org.apache.log4j.xml.DOMConfigurator;

/**
 *
 * @author Yasser Ibrahim
 */
public class EmployeesLoadsGroupSummaryMgr extends RDBGateWay implements Serializable {

    private static final EmployeesLoadsGroupSummaryMgr EMPLOYEES_LOADS_GROUP_SUMMARY_MGR = new EmployeesLoadsGroupSummaryMgr();

    private EmployeesLoadsGroupSummaryMgr() {
    }

    public static EmployeesLoadsGroupSummaryMgr getInstance() {
        return EMPLOYEES_LOADS_GROUP_SUMMARY_MGR;
    }

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("employees_loads_group_summary.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    @Override
    public ArrayList getCashedTableAsArrayList() {
        return cashedData;
    }

    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    @Override
    public ArrayList getCashedTableAsBusObjects() {
        return cashedData;
    }

    @Override
    public WebBusinessObject getObjectFromCash(String key) {
        return super.getObjectFromCash(key);
    }

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
    }

    public String getFreeEmployee(String groupId, String isDefault) throws Exception {
        Connection connection = null;
        Vector queryResult = null;
        Vector parameters = new Vector();
        Row row;
        Enumeration enumeration;
        SQLCommandBean command = new SQLCommandBean();

        parameters.addElement(new StringValue(groupId));
        parameters.addElement(new StringValue(isDefault));
        parameters.addElement(new StringValue(groupId));
        parameters.addElement(new StringValue(isDefault));

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getFreeEmployeeByDefaultGroup").trim());
            command.setparams(parameters);
            queryResult = command.executeQuery();
        } catch (SQLException ex) {
            logger.error(ex.getMessage());
        } catch (UnsupportedTypeException ex) {
            logger.error(ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
            }
        }

        WebBusinessObject wbo;
        String id = null;
        if (queryResult != null && !queryResult.isEmpty()) {
            enumeration = queryResult.elements();
            while (enumeration.hasMoreElements()) {
                row = (Row) enumeration.nextElement();
                wbo = fabricateBusObj(row);

                id = (String) wbo.getAttribute("userId");
                break;
            }
        }

        return id;
    }

    public String getFreeEmployee(String groupId, boolean loggedOnly) throws Exception {
        Connection connection = null;
        Vector queryResult = null;
        Vector parameters = new Vector();
        Row row;
        Enumeration enumeration;
        SQLCommandBean command = new SQLCommandBean();

        parameters.addElement(new StringValue(groupId));
        parameters.addElement(new StringValue(groupId));
        StringBuilder where = new StringBuilder();
        if(loggedOnly) {
            where.append(" AND USER_ID IN (SELECT USER_ID FROM PERSISTENT_SESSION WHERE TRUNC(LOGGIN_IN_TIME) = TRUNC(SYSDATE))");
        }

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getFreeEmployeeByGroup").replace("whereStatement", where.toString()).trim());
            command.setparams(parameters);
            queryResult = command.executeQuery();
        } catch (SQLException ex) {
            logger.error(ex.getMessage());
        } catch (UnsupportedTypeException ex) {
            logger.error(ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
            }
        }

        WebBusinessObject wbo;
        String id = null;
        if (queryResult != null && !queryResult.isEmpty()) {
            enumeration = queryResult.elements();
            while (enumeration.hasMoreElements()) {
                row = (Row) enumeration.nextElement();
                wbo = fabricateBusObj(row);

                id = (String) wbo.getAttribute("userId");
                break;
            }
        }

        return id;
    }
}
