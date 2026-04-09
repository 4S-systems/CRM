package com.maintenance.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import com.silkworm.util.*;

import java.util.*;
import java.text.*;
import java.sql.*;

import java.util.ArrayList;
import javax.servlet.http.HttpSession;
import org.apache.log4j.xml.DOMConfigurator;

public class TaskTypeMgr extends RDBGateWay {

    private static TaskTypeMgr taskTypeMgr = new TaskTypeMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();

    public TaskTypeMgr() {
    }

    public static TaskTypeMgr getInstance() {
        logger.info("Getting TaskTypeMgr Instance ....");
        return taskTypeMgr;
    }

    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("task_type.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(WebBusinessObject wbo, HttpSession s) throws SQLException {
        return false;
    }

    public boolean saveObject(WebBusinessObject taskType){

        //WebBusinessObject project = (WebBusinessObject) wbo;
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;


        params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue((String) taskType.getAttribute("name")));
        params.addElement(new StringValue((String) taskType.getAttribute("desc")));


        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertTaskType").trim());
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

    public boolean updateTaskType(WebBusinessObject wbo){


        Vector params = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;
        params.addElement(new StringValue((String) wbo.getAttribute("name")));
        params.addElement(new StringValue((String) wbo.getAttribute("desc")));
        params.addElement(new StringValue((String) wbo.getAttribute("id")));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(sqlMgr.getSql("updateTaskType").trim());
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();
        } catch (SQLException se) {
            logger.error("Exception updating project: " + se.getMessage());
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
//
//    public void UpdateUserTrade(String TradeName, String OldTradeName) {
//        Vector tradenameParams = new Vector();
//        SQLCommandBean forUpdate = new SQLCommandBean();
//
//        tradenameParams.addElement(new StringValue(TradeName));
//        tradenameParams.addElement(new StringValue(OldTradeName));//Total Time
//        Connection connection = null;
//
//
//        try {
//            connection = dataSource.getConnection();
////
//            forUpdate.setConnection(connection);
//            forUpdate.setSQLQuery(sqlMgr.getSql("updateUserTrade").trim());
//            forUpdate.setparams(tradenameParams);
//            int queryResult = forUpdate.executeUpdate();
//        } catch (SQLException sex) {
//
//        } finally {
//            try {
//                connection.close();
//            } catch (SQLException ex) {
//                logger.error(ex.getMessage());
//            }
//        }
//    }
//
    public ArrayList getCashedTableAsBusObjects() {
        cashedData = new ArrayList();
        WebBusinessObject wbo = null;
        taskTypeMgr.cashData();
        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add(wbo);
        }

        return cashedData;
    }

    public Vector getAllTaskType(){
        taskTypeMgr.cashData();
        return cashedTable;
    }

    public ArrayList getCashedTableAsArrayList() {

        cashedData = new ArrayList();
        WebBusinessObject wbo = null;
        taskTypeMgr.cashData();
        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add((String) wbo.getAttribute("name"));
        }

        return cashedData;
    }

    public boolean nameExsit(String name){
        ArrayList allTaskTypeName = getCashedTableAsArrayList();
        String taskName;
        for (int i = 0; i < allTaskTypeName.size(); i++) {
            taskName = (String) allTaskTypeName.get(i);
            if(name.equalsIgnoreCase(taskName)){
                return true;
            }
        }

        return false;
    }
//
//    public boolean getActiveTrade(String tradeId) throws Exception {
//        Vector SQLparams = new Vector();
//        Connection connection = null;
//        Vector queryResult = null;
//        SQLparams.addElement(new StringValue(tradeId));
//        SQLCommandBean forQuery = new SQLCommandBean();
//
//        try {
//            connection = dataSource.getConnection();
//            forQuery.setConnection(connection);
//            forQuery.setSQLQuery(sqlMgr.getSql("getActiveTrade").trim());
//            forQuery.setparams(SQLparams);
//
//            queryResult = forQuery.executeQuery();
//
//
//        } catch (SQLException se) {
//            logger.error("database error from getListOnSecondKey: ImageMgr " + se.getMessage());
//        } catch (UnsupportedTypeException uste) {
//            logger.error("***** " + uste.getMessage());
//        } finally {
//            try {
//                connection.close();
//            } catch (SQLException sex) {
//                logger.error("troubles closing connection " + sex.getMessage());
//                return false;
//            }
//        }
//
//        return queryResult.size() > 0;
//    }

    @Override
    protected void initSupportedQueries() {
     return; //   throw new UnsupportedOperationException("Not supported yet.");
    }
}
