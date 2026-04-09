package com.workFlowTasks.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import java.sql.SQLException;
import com.silkworm.util.*;
import java.util.*;
import java.text.*;
import javax.servlet.http.HttpSession;
import java.sql.*;
import com.tracker.common.*;
//import com.tracker.app_constants.ProjectConstants;

import com.tracker.business_objects.*;
import java.io.File;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.log4j.xml.DOMConfigurator;

public class WFTaskMgr extends RDBGateWay {
    
    SqlMgr sqlMgr = SqlMgr.getInstance();
    private static WFTaskMgr wFTaskMgr = new WFTaskMgr();
    private String wfTaskId="";
    private String wfTaskVisitId="";
    
    public WFTaskMgr() {
    }
    
    public static WFTaskMgr getInstance() {
        logger.info("Getting wFTaskMgr Instance ....");
        return wFTaskMgr;
    }
    
    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("wf_task.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }
    
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }
    
    public boolean saveObject(WebBusinessObject wfTask, HttpSession s) throws NoUserInSessionException {
        
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        
        Vector params = new Vector();
        Vector taskVisitparams = new Vector();
        Vector taskStatusparams = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        
//        String query="INSERT INTO WF_TASK VALUES(?,?,?,?,?,?,?,?,?)";
//        String taskVisitquery="INSERT INTO WF_TASK_VISIT VALUES(?,?,?,?,?,?)";
//        String taskStatusQuery="INSERT INTO WF_TASK_STATUS VALUES(?,?,?,?,?,?,TO_DATE('31-Dec-2020','DD-MON-YYYY'),?,SYSDATE)";
        
        String wfTaskId=UniqueIDGen.getNextID();
        
        params.addElement(new StringValue(wfTaskId));
        params.addElement(new StringValue((String) wfTask.getAttribute("title")));
        params.addElement(new StringValue((String) wfTask.getAttribute("desc")));
        params.addElement(new StringValue((String) wfTask.getAttribute("userId")));
        params.addElement(new DateValue((java.sql.Date) wfTask.getAttribute("date")));
        params.addElement(new StringValue((String) wfTask.getAttribute("taskCode")));
        params.addElement(new StringValue((String) wfTask.getAttribute("taskType")));
        params.addElement(new StringValue((String) wfTask.getAttribute("department")));
        params.addElement(new StringValue("open"));
        
        String wfTaskVisitId=UniqueIDGen.getNextID();
        
        taskVisitparams.addElement(new StringValue(wfTaskVisitId));
        taskVisitparams.addElement(new StringValue(wfTaskId));
        taskVisitparams.addElement(new StringValue("create"));
        taskVisitparams.addElement(new StringValue((String) wfTask.getAttribute("desc")));
        taskVisitparams.addElement(new StringValue((String) wfTask.getAttribute("userId")));
        taskVisitparams.addElement(new DateValue((java.sql.Date) wfTask.getAttribute("date")));
        
        String wfTaskStatusId=UniqueIDGen.getNextID();
        taskStatusparams.addElement(new StringValue(wfTaskStatusId));
        taskStatusparams.addElement(new StringValue("open"));
        taskStatusparams.addElement(new StringValue(wfTaskId));
        taskStatusparams.addElement(new StringValue((String) wfTask.getAttribute("title")));
        taskStatusparams.addElement(new StringValue("open"));
        taskStatusparams.addElement(new DateValue((java.sql.Date) wfTask.getAttribute("date")));
        taskStatusparams.addElement(new StringValue((String) wfTask.getAttribute("userId")));
        
        
        
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertWFTask").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            
            forInsert.setSQLQuery(sqlMgr.getSql("insertWFTaskVisit").trim());
            forInsert.setparams(taskVisitparams);
            queryResult = forInsert.executeUpdate();
            
            forInsert.setSQLQuery(sqlMgr.getSql("insertWFTaskStatus").trim());
            forInsert.setparams(taskStatusparams);
            queryResult = forInsert.executeUpdate();
            
            wFTaskMgr.setWFTaskId(wfTaskId);
            wFTaskMgr.setWFTaskVisitId(wfTaskVisitId);
            
            cashData();
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
    
    public boolean saveNotes(WebBusinessObject wfTask, HttpSession s) throws NoUserInSessionException {
        
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        
        Vector params = new Vector();
        Vector taskVisitparams = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        
//        String taskVisitquery="INSERT INTO WF_TASK_VISIT VALUES(?,?,?,?,?,?)";
        
        String wfTaskVisitId=UniqueIDGen.getNextID();
        
        taskVisitparams.addElement(new StringValue(wfTaskVisitId));
        taskVisitparams.addElement(new StringValue((String)wfTask.getAttribute("id")));
        taskVisitparams.addElement(new StringValue("update"));
        taskVisitparams.addElement(new StringValue((String) wfTask.getAttribute("notes")));
        taskVisitparams.addElement(new StringValue((String) wfTask.getAttribute("userId")));
        taskVisitparams.addElement(new DateValue((java.sql.Date) wfTask.getAttribute("date")));
        
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            
            forInsert.setSQLQuery(sqlMgr.getSql("visitTask").trim());
            forInsert.setparams(taskVisitparams);
            queryResult = forInsert.executeUpdate();
            
            cashData();
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
    
    
    public boolean updateWFTask(WebBusinessObject wfTask, HttpSession s) throws NoUserInSessionException {
        
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        
        Vector params = new Vector();
        Vector taskVisitparams = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        
//        String query="UPDATE WF_TASK SET TITLE = ?, NOTES = ?, CREATED_BY = ?, CREATION_DATE = ?, TASK_TYPE = ?, DEPARTMENT = ? WHERE ID = ?";
        
        params.addElement(new StringValue((String) wfTask.getAttribute("title")));
        params.addElement(new StringValue((String) wfTask.getAttribute("desc")));
        params.addElement(new StringValue((String) wfTask.getAttribute("userId")));
        params.addElement(new DateValue((java.sql.Date) wfTask.getAttribute("date")));
        params.addElement(new StringValue((String) wfTask.getAttribute("taskType")));
        params.addElement(new StringValue((String) wfTask.getAttribute("department")));
        params.addElement(new StringValue((String) wfTask.getAttribute("id")));
        
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("updateTask").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            
            wFTaskMgr.setWFTaskId((String) wfTask.getAttribute("id"));
            
            cashData();
            
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
    
    public boolean deleteWfTask(String id){
//        String taskVisitQuery="DELETE FROM WF_TASK_VISIT WHERE TASK_ID = ? ";
//        String taskQuery="DELETE FROM WF_TASK WHERE ID = ? ";
        
        SQLCommandBean forInsert = new SQLCommandBean();
        Vector params=new Vector();
        int queryResult = -1000;
        
        params.addElement(new StringValue(id));
        
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("deleteWFTaskVisit").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            
            forInsert.setSQLQuery(sqlMgr.getSql("deleteWFTask").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            
            cashData();
            
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
    
    public boolean changeStatus(WebBusinessObject wfTaskStatus, HttpSession s)throws NoUserInSessionException {
        
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        
        Vector params = new Vector();
        Vector taskStatusparams = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        
        String taskStatusquery="INSERT INTO WF_TASK_Status VALUES(?,?,?,?,?,?,?,?,SYSDATE)";
        String taskquery="update WF_TASK set last_status= ? where id= ? ";
        int queryResult = -1000;
        
        String wfTaskStatusId=UniqueIDGen.getNextID();
        
        java.sql.Date tempDate=(java.sql.Date)wfTaskStatus.getAttribute("endDate");
//        java.sql.Timestamp endDate = new java.sql.Timestamp(tempDate.getTime());
        
        java.sql.Date tempBDate=(java.sql.Date)wfTaskStatus.getAttribute("beginDate");
        
        taskStatusparams.addElement(new StringValue(wfTaskStatusId));
        taskStatusparams.addElement(new StringValue((String)wfTaskStatus.getAttribute("status")));
        taskStatusparams.addElement(new StringValue((String)wfTaskStatus.getAttribute("taskId")));
        taskStatusparams.addElement(new StringValue((String)wfTaskStatus.getAttribute("taskTitle")));
        taskStatusparams.addElement(new StringValue((String)wfTaskStatus.getAttribute("notes")));
        taskStatusparams.addElement(new DateValue(tempBDate));
        taskStatusparams.addElement(new DateValue(tempDate));
        taskStatusparams.addElement(new StringValue((String)wfTaskStatus.getAttribute("userId")));
        
        params.addElement(new StringValue("Finished"));
        params.addElement(new StringValue((String)wfTaskStatus.getAttribute("taskId")));
        
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            
            forInsert.setSQLQuery(taskStatusquery.trim());
            forInsert.setparams(taskStatusparams);
            queryResult = forInsert.executeUpdate();
            
            forInsert.setSQLQuery(taskquery.trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            
            cashData();
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
    
    public Vector getTicketComponent(String ID) {
        Vector res = new Vector();
        Vector params = new Vector();
        SQLCommandBean forSelect = new SQLCommandBean();
        params.addElement(new StringValue(ID));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forSelect.setConnection(connection);
            forSelect.setSQLQuery(sqlMgr.getSql("getTicketComponent").trim());
            forSelect.setparams(params);
            res = forSelect.executeQuery();

        } catch (Exception se) {
            logger.error(se.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }
        return res;
    }
    
    public ArrayList getCashedTableAsBusObjects() {
        cashedData = new ArrayList();
        WebBusinessObject wbo = null;
        
        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add(wbo);
        }
        
        return cashedData;
    }
    
    public ArrayList getCashedTableAsArrayList() {
        
        cashedData = new ArrayList();
        WebBusinessObject wbo = null;
        
        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add((String) wbo.getAttribute("title"));
        }
        
        return cashedData;
    }
    
    public void setWFTaskId(String wFTaskId){
        wfTaskId=wFTaskId;
    }
    
    public void setWFTaskVisitId(String wFTaskVisitId){
        wfTaskVisitId=wFTaskVisitId;
    }
    
    public String getWFTaskId(){
        return wfTaskId;
    }
    
    public String getWFTaskVisitId(){
        return wfTaskVisitId;
    }

    @Override
    protected void initSupportedQueries() {
      return; //  throw new UnsupportedOperationException("Not supported yet.");
    }
    
}
