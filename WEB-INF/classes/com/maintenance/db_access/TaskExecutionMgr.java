package com.maintenance.db_access;

import com.businessfw.hrs.db_access.EmployeeMgr;
import com.maintenance.common.Tools;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;

import java.sql.*;
import java.util.*;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.xml.DOMConfigurator;

public class TaskExecutionMgr extends RDBGateWay {
    
    SqlMgr sqlMgr = SqlMgr.getInstance();
    private static TaskExecutionMgr taskExecutionMgr = new TaskExecutionMgr();
    IssueTasksMgr issueTasksMgr = IssueTasksMgr.getInstance();
    
    public TaskExecutionMgr() {
    }
    
    public static TaskExecutionMgr getInstance() {
        logger.info("Getting TaskExecutionMgr Instance ....");
        return taskExecutionMgr;
    }
    
    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("task_execution.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }
    
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }
    
    public boolean saveObject(HttpServletRequest request) throws NoUserInSessionException {
        EmployeeMgr employeeMgr = EmployeeMgr.getInstance();
        
        String[] arrTaskID = request.getParameterValues("taskID");
        String[] arrWorker = request.getParameterValues("worker");
        String[] actualMinutes = request.getParameterValues("actualMinutes");
        String[] actualHours = request.getParameterValues("actualHours");
        String[] arrPlannedHours = request.getParameterValues("plannedHours");
        
        Vector params = new Vector();
        
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        int intActualMi, intActualHr;
        double actual,totalCost,floatCostTask,totalCostOfTaskForAllLabor;
        double[] arrTotalTask = new double[arrWorker.length];
        
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            forInsert.setConnection(connection);

            params.addElement(new StringValue(request.getParameter("issueId")));
            forInsert.setSQLQuery(sqlMgr.getSql("deleteAllTaskExecutionSQL").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();

            if (arrTaskID != null) {
                forInsert.setSQLQuery(sqlMgr.getSql("insertTaskExecutionSQL").trim());
                for (int i = 0; i < arrTaskID.length; i++) {
                    
                    intActualMi = Tools.convertInt(actualMinutes[i]);
                    intActualHr = Tools.convertInt(actualHours[i]) * 60;
                    floatCostTask = employeeMgr.getCostHour(arrWorker[i]);

                    actual = intActualHr + intActualMi;

                    totalCost = (actual / 60) * floatCostTask;
                    arrTotalTask[i] = totalCost;
                    
                    params = new Vector();
                    params.addElement(new StringValue(UniqueIDGen.getNextID()));
                    params.addElement(new StringValue(arrTaskID[i]));
                    params.addElement(new StringValue(arrWorker[i]));
                    params.addElement(new DoubleValue(new Double(actual)));
                    params.addElement(new DoubleValue(actual - new Double(arrPlannedHours[i]).doubleValue()));
                    params.addElement(new DoubleValue(new Double(floatCostTask)));
                    params.addElement(new DoubleValue(new Double(totalCost)));
                    forInsert.setparams(params);
                    queryResult = forInsert.executeUpdate();

                    if(queryResult <= 0) {
                        connection.rollback();
                        return false;
                    }

                    try {
                        Thread.sleep(200);
                    } catch (InterruptedException ex) {
                        logger.error(ex.getMessage());
                    }
                }

                String[] nativeIssueTask = Tools.removeDuplicate(arrTaskID);
                forInsert.setSQLQuery(sqlMgr.getSql("updateIssueTaskCost").trim());
                for (int i = 0; i < nativeIssueTask.length; i++) {
                    totalCostOfTaskForAllLabor = Tools.sumOf(arrTotalTask, arrTaskID, nativeIssueTask[i]);

                    params = new Vector();
                    params.addElement(new DoubleValue(totalCostOfTaskForAllLabor));
                    params.addElement(new StringValue(nativeIssueTask[i]));
                    
                    forInsert.setparams(params);
                    queryResult = forInsert.executeUpdate();

                    if(queryResult <= 0) {
                        connection.rollback();
                        return false;
                    }
                }
            }
        } catch (SQLException se) {
            try {
                connection.rollback();
                logger.error(se.getMessage());
                return false;
            } catch (SQLException ex) {
                logger.error(se.getMessage());
            }
        } finally {
            try {
                connection.commit();
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
                logger.error("Close Error");
                return false;
            }
        }
        return (queryResult > 0);
    }

    @Override
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
    return; //    throw new UnsupportedOperationException("Not supported yet.");
    }
}
