package com.maintenance.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;

import java.sql.*;
import java.util.*;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.xml.DOMConfigurator;

public class TaskExecutionCmplxMgr extends RDBGateWay {
    
    SqlMgr sqlMgr = SqlMgr.getInstance();
    private static TaskExecutionCmplxMgr taskExecutionCmplxMgr = new TaskExecutionCmplxMgr();
    IssueTasksMgr issueTasksMgr = IssueTasksMgr.getInstance();
    
    public TaskExecutionCmplxMgr() {
    }
    
    public static TaskExecutionCmplxMgr getInstance() {
        logger.info("Getting TaskExecutionMgr Instance ....");
        return taskExecutionCmplxMgr;
    }
    
    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("task_execution_cmplx.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }
    
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }
    
    public boolean saveObject(HttpServletRequest request) throws NoUserInSessionException {
        String[] arrTaskID = request.getParameterValues("taskID");
        String[] arrWorker = request.getParameterValues("worker");
        String[] arrActualHours = request.getParameterValues("actualHours");
        String[] arrPlannedHours = request.getParameterValues("plannedHours");
        String issueId = request.getParameter("issueId");
        String[] cIssueIndex = request.getParameterValues("cIssueIndex");
        
        Vector params = new Vector();
        Vector issueParams = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        
        
        
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            params.addElement(new StringValue(request.getParameter("issueId")));
            forInsert.setSQLQuery(sqlMgr.getSql("deleteAllTaskExecutionCmplxSQL").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            if (arrTaskID != null) {
                for (int i = 0; i < arrTaskID.length; i++) {
                    params = new Vector();
                    params.addElement(new StringValue(UniqueIDGen.getNextID()));
                    params.addElement(new StringValue(arrTaskID[i]));
                    params.addElement(new StringValue(arrWorker[i]));
                    params.addElement(new FloatValue(new Float(arrActualHours[i]).floatValue()));
                    params.addElement(new FloatValue(new Float(arrActualHours[i]).floatValue() - new Float(arrPlannedHours[i]).floatValue()));
                    params.addElement(new StringValue(issueId));
                    params.addElement(new StringValue(cIssueIndex[i]));
                    forInsert.setSQLQuery(sqlMgr.getSql("insertTaskExecutionCmplxSQL").trim());
                    forInsert.setparams(params);
                    queryResult = forInsert.executeUpdate();
                    try {
                        Thread.sleep(200);
                    } catch (InterruptedException ex) {
                        logger.error(ex.getMessage());
                    }
                }
            }
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
            cashedData.add((String) wbo.getAttribute("reason"));
        }
        
        return cashedData;
    }
    
    public ArrayList getCashedTableAsArrayList(String attribute) {
        
        cashedData = new ArrayList();
        WebBusinessObject wbo = null;
        
        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add((String) wbo.getAttribute(attribute));
        }
        
        return cashedData;
    }
    
    public Hashtable findExecutedTasks(String issueId) throws SQLException, Exception{
        Hashtable tasksHT = new Hashtable();
        
        Vector tasksVec = new Vector();
        Vector executedTasksVec = new Vector();
        
        //get Issue Tasks
        tasksVec = issueTasksMgr.getOnArbitraryKey(issueId,"key1");
        
        //get issue_tasks_execution
        ArrayList executedTasksAL = getCashedTableAsArrayList("issueTaskID");
        
        //build two vectors TasksVec and Executed Vec
        for(int i=0; i<tasksVec.size(); i++){
            WebBusinessObject taskWbo = (WebBusinessObject) tasksVec.elementAt(i);
            
            if(executedTasksAL.contains(taskWbo.getAttribute("taskID").toString())){
                executedTasksVec.add(taskWbo);
                tasksVec.removeElementAt(i);
                i--;
            }
            
        }
        
        tasksHT.put("unExecutedTasks", tasksVec);
        tasksHT.put("executedTasks", executedTasksVec);
        
        return tasksHT;
    }

    @Override
    protected void initSupportedQueries() {
       return; // throw new UnsupportedOperationException("Not supported yet.");
    }
}
