package com.maintenance.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;

import java.util.*;
import java.sql.*;
import javax.servlet.http.HttpServletRequest;
import org.apache.log4j.xml.DOMConfigurator;

public class ScheduleTasksMgr extends RDBGateWay {

    SqlMgr sqlMgr = SqlMgr.getInstance();
    private static ScheduleTasksMgr scheduleTasksMgr = new ScheduleTasksMgr();

    public ScheduleTasksMgr() {
    }

    public static ScheduleTasksMgr getInstance() {
        logger.info("Getting ScheduleTasksMgr Instance ....");
        return scheduleTasksMgr;
    }

    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("schedule_tasks.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public boolean HasItem(String scheduleId) throws SQLException {
        Vector Res = new Vector();
        try {
            Res = getOnArbitraryKey(scheduleId, "key1");
            if (Res.size() > 0) {
                return true;
            }
        } catch (SQLException ex) {
            logger.error(ex.getMessage());
        } catch (Exception ex) {
            logger.error(ex.getMessage());
        }

        return false;
    }

    public int chechScheduleTaskFound(String schId, String taskId) {

        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(schId));
        SQLparams.addElement(new StringValue(taskId));

        Connection connection = null;
        String unitName = null;

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            beginTransaction();
            forQuery.setConnection(transConnection);
            forQuery.setSQLQuery(getQuery("chechScheduleTaskFound").trim());
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

            endTransaction();


            
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return 0;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return 0;
        
        } finally {
        }

        if (queryResult.size()>0) {
            return 1;
        } else {
            return 0;
        }
    }

    public boolean saveObject(HttpServletRequest request, String scheduleId) throws SQLException {
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertScheduleTasksSql").trim());
            String[] sRank = request.getParameterValues("priority");
            String[] sCodeTask = request.getParameterValues("id");
            String[] sDescEn = request.getParameterValues("desc");

            for (int i = 0; i < sRank.length; i++) {
                String descValue=sDescEn[i];
                if(descValue==null || descValue.equalsIgnoreCase(""))
                    descValue="No Notes";
                
                params = new Vector();
                params.addElement(new StringValue(UniqueIDGen.getNextID()));
                params.addElement(new StringValue(scheduleId));
                params.addElement(new StringValue(sRank[i]));


                params.addElement(new StringValue(sCodeTask[i]));
                params.addElement(new StringValue(descValue));
                String x = sCodeTask[i];
                forInsert.setparams(params);
                queryResult = forInsert.executeUpdate();
                try {
                    Thread.sleep(200);
                } catch (InterruptedException ex) {
                    logger.error(ex.getMessage());
                }
            }
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

    public boolean updateObject(WebBusinessObject wbo) {

        Vector params = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue((String) wbo.getAttribute("priority")));
        params.addElement(new StringValue((String) wbo.getAttribute("codeTask")));

        params.addElement(new StringValue((String) wbo.getAttribute("desc")));
        params.addElement(new StringValue((String) wbo.getAttribute("taskID")));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(sqlMgr.getSql("updateScheduleTasksSQL").trim());
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();

            cashData();
        } catch (SQLException se) {

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

        cashedData = new ArrayList();
        WebBusinessObject wbo = null;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add((String) wbo.getAttribute("maintenanceTitle"));
        }

        return cashedData;
    }

    public ArrayList getCashedTableAsBusObjects() {
        return null;
    }

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
     return; //   throw new UnsupportedOperationException("Not supported yet.");
    }
}
