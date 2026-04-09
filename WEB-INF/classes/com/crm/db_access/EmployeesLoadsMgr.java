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
public class EmployeesLoadsMgr extends RDBGateWay implements Serializable {

    private static final EmployeesLoadsMgr EMPLOYEES_LOADS_MGR = new EmployeesLoadsMgr();

    private EmployeesLoadsMgr() {
    }

    public static EmployeesLoadsMgr getInstance() {
        return EMPLOYEES_LOADS_MGR;
    }

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("employees_loads.xml")));
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

    public List getEmployeesLoadDynamicReport(String departmentId) throws NoSuchColumnException, UnsupportedConversionException {
        WebBusinessObject wbo;
        Connection connection = null;
        Vector parameters = new Vector();
        Vector queryResult = null;
        ArrayList resultBusObjs = new ArrayList();
        Row row;
        Enumeration enumeration;
        SQLCommandBean command = new SQLCommandBean();
        parameters.add(new StringValue(departmentId));
        command.setparams(parameters);

        String query = getQuery("employeesLoadDynamicReport").trim();
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(query);
            queryResult = command.executeQuery();
        } catch (SQLException ex) {
            logger.error(ex.getMessage());
        } catch (UnsupportedTypeException ex) {
            logger.error(ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }
        enumeration = queryResult.elements();
        while (enumeration.hasMoreElements()) {
            row = (Row) enumeration.nextElement();
            wbo = fabricateBusObj(row);
            wbo.setAttribute("noTicket", String.valueOf(row.getBigDecimal("TOTAL")));
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }
    
    public List getEmployeesLoadDynamicReportByGroup(String groupId) throws NoSuchColumnException, UnsupportedConversionException {
        WebBusinessObject wbo;
        Connection connection = null;
        Vector parameters = new Vector();
        Vector queryResult = null;
        ArrayList resultBusObjs = new ArrayList();
        Row row;
        Enumeration enumeration;
        SQLCommandBean command = new SQLCommandBean();
        parameters.add(new StringValue(groupId));
        command.setparams(parameters);

        String query = getQuery("employeesLoadDynamicReportByGroup").trim();
        if (groupId.equalsIgnoreCase("all")) {
            query = getQuery("employeesLoadDynamicReportByAll").trim();
            command.setparams(null);
        }
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(query);
            queryResult = command.executeQuery();
        } catch (SQLException ex) {
            logger.error(ex.getMessage());
        } catch (UnsupportedTypeException ex) {
            logger.error(ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }
        if (queryResult != null) {
            enumeration = queryResult.elements();
            while (enumeration.hasMoreElements()) {
                row = (Row) enumeration.nextElement();
                wbo = fabricateBusObj(row);
                wbo.setAttribute("noTicket", String.valueOf(row.getBigDecimal("TOTAL")));
                resultBusObjs.add(wbo);
            }
        }
        return resultBusObjs;
    }

    public List<WebBusinessObject> employeesLoads(String... employees) throws Exception {
        Connection connection = null;
        Vector queryResult = null;
        List<WebBusinessObject> resultBusObjs = new ArrayList<WebBusinessObject>();
        Row row;
        Enumeration enumeration;
        SQLCommandBean command = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("employeesLoads").trim().replaceFirst("IDS", prepareInParameter(employees)));
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
        if (queryResult != null && !queryResult.isEmpty()) {
            enumeration = queryResult.elements();
            while (enumeration.hasMoreElements()) {
                row = (Row) enumeration.nextElement();
                wbo = fabricateBusObj(row);
                wbo.setAttribute("noTicket", String.valueOf(row.getBigDecimal("TOTAL")));
                resultBusObjs.add(wbo);
            }
        }

        // check loads list
        List<String> employeeList = Arrays.asList(employees);
        for (WebBusinessObject load : resultBusObjs) {

        }

        return resultBusObjs;
    }
}
