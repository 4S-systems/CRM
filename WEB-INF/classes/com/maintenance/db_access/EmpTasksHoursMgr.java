package com.maintenance.db_access;

import com.maintenance.common.Tools;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;

import java.util.*;
import java.sql.*;
import org.apache.log4j.xml.DOMConfigurator;

public class EmpTasksHoursMgr extends RDBGateWay {

    private static EmpTasksHoursMgr empTasksHoursMgr = new EmpTasksHoursMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();

    public EmpTasksHoursMgr() { }

    public static EmpTasksHoursMgr getInstance() {
        logger.info("Getting EmpTasksHoursMgr Instance ....");
        return empTasksHoursMgr;
    }

    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("emp_tasks_hours.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public ArrayList getCashedTableAsArrayList() {
        return null;
    }

    public Vector getTasksHoursByIssue(String sIssueID) {
        WebBusinessObject wbo = new WebBusinessObject();
        Vector params = new Vector();
        params.addElement(new StringValue(sIssueID));
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setparams(params);
            forQuery.setSQLQuery(sqlMgr.getSql("selectTasksHoursByIssueSQL").trim());
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

    public double getTolalCostLabor(String issueId) {
        Vector params = new Vector();
        params.addElement(new StringValue(issueId));

        Connection connection = null;
        Vector<Row> rows = null;
        Double total = 0.00;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setparams(params);
            forQuery.setSQLQuery(sqlMgr.getSql("getTolalCostLabor").trim());
            rows = forQuery.executeQuery();

            try {
                for(Row row : rows) {
                    if(Double.valueOf(row.getString("LABOR_COST")) != null) {
                        total = new Double(row.getString("LABOR_COST"));
                    }
                }
            } catch(Exception ex) { logger.error(ex.getMessage()); }

        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error : " + ex.getMessage());
            }
        }

        return Tools.round(total.doubleValue(), 2);
    }
    
    public Vector getTasksHoursByTasks(String taskId,String issueId) {
        WebBusinessObject wbo = new WebBusinessObject();
        Vector params = new Vector();
        params.addElement(new StringValue(taskId));
        params.addElement(new StringValue(issueId));
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setparams(params);
            forQuery.setSQLQuery(sqlMgr.getSql("getTasksHoursByTasks").trim());
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

    @Override
    protected void initSupportedQueries() {
     return;   //throw new UnsupportedOperationException("Not supported yet.");
    }
}
