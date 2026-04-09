package com.maintenance.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.persistence.relational.StringValue;
import com.tracker.db_access.IssueMgr;

import java.util.*;
import java.sql.*;

import javax.servlet.http.HttpServletRequest;
import org.apache.log4j.xml.DOMConfigurator;

public class IssueTasksMgr extends RDBGateWay {
    
    SqlMgr sqlMgr = SqlMgr.getInstance();
    ScheduleTasksMgr scheduleTasksMgr = ScheduleTasksMgr.getInstance();
    ConfigureMainTypeMgr schedulePartsMgr = ConfigureMainTypeMgr.getInstance();
    IssueMgr issueMgr = IssueMgr.getInstance();
    IssueMetaDataMgr issueMetaDataMgr = IssueMetaDataMgr.getInstance();
    Vector<WebBusinessObject> scheduleTasks = new Vector<WebBusinessObject>();
    Vector<WebBusinessObject> scheduleParts = new Vector<WebBusinessObject>();
    private static IssueTasksMgr issueTasksMgr = new IssueTasksMgr();
    private TaskMgr taskMgr = TaskMgr.getInstance();
    private String taskId, unitScheduleId, storeCode, branchCode, costHour;

    public IssueTasksMgr() { }
    
    public static IssueTasksMgr getInstance() {
        logger.info("Getting IssueTasksMgr Instance ....");
        return issueTasksMgr;
    }

    @Override
    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("issue_tasks.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }
    
    public boolean saveObject(HttpServletRequest request, String issueId) throws SQLException {
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        
        Connection connection = null;
        if(request.getParameterValues("id") != null && request.getParameterValues("desc") != null){
            try {
                connection = dataSource.getConnection();
                forInsert.setConnection(connection);
                forInsert.setSQLQuery(sqlMgr.getSql("insertIssueTasksSql").trim());
                
                String[] id = request.getParameterValues("id");
                String[] notes = request.getParameterValues("desc");
                
                for (int i = 0; i < id.length; i++) {
                    params = new Vector();

                    params.addElement(new StringValue(UniqueIDGen.getNextID()));
                    params.addElement(new StringValue(issueId));
                    params.addElement(new StringValue(id[i]));
                    params.addElement(new StringValue(notes[i]));
                    params.addElement(new StringValue(taskMgr.getCostTaskHour(id[i])));
                    
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
        } else {
            queryResult = 1;
        }
        
        return (queryResult > 0);
    }
    
    public boolean saveTasksForScheduleActive(String issueId, String scheduleId, String userId) {
        SQLCommandBean commandBean = new SQLCommandBean();
        Connection connection = null;
        Vector params;
        Vector paramsIssueTasks;
        Vector paramsIssueMetaDate = new Vector();
        boolean result = false;
        
        if(!"1".equals(scheduleId) && !"2".equals(scheduleId)) {
            try {
                if (!issueMetaDataMgr.getIssueTasks(issueId)) {
                    try {
                        unitScheduleId = issueMgr.getUnitScheduleId(issueId);
                        scheduleTasks = scheduleTasksMgr.getOnArbitraryKey(scheduleId, "key1");

                        connection = dataSource.getConnection();
                        connection.setAutoCommit(false);
                        commandBean.setConnection(connection);
                        commandBean.setSQLQuery(sqlMgr.getSql("insertIssueTasksSql").trim());

                        for(WebBusinessObject task : scheduleTasks) {
                            params = new Vector();

                            taskId = (String) task.getAttribute("codeTask");
                            costHour = "0";
                            costHour = taskMgr.getCostTaskHour(taskId);

                            try {
                                Thread.sleep(50);
                            } catch (InterruptedException ex) {
                                logger.error(ex.getMessage());
                            }

                            params.addElement(new StringValue(UniqueIDGen.getNextID()));
                            params.addElement(new StringValue(issueId));
                            params.addElement(new StringValue(taskId));
                            params.addElement(new StringValue((String) task.getAttribute("desc")));
                            params.addElement(new StringValue(costHour));

                            commandBean.setparams(params);

                            if(commandBean.executeUpdate() < 0) {
                                connection.rollback();
                                return false;
                            }

                            try {
                                Thread.sleep(50);
                            } catch (InterruptedException ex) {
                                logger.error(ex.getMessage());
                            }
                        }

                        // save all parts for this task
                        scheduleParts = new Vector<WebBusinessObject>();
                        commandBean.setSQLQuery(sqlMgr.getSql("insertQuantifiedFromTasks").trim());

                        try {
                            scheduleParts = schedulePartsMgr.getOnArbitraryKey(scheduleId, "key1");
                        } catch(Exception ex) { logger.error(ex.getMessage()); }

                        for(WebBusinessObject schedulePart : scheduleParts) {

                            storeCode = (String) schedulePart.getAttribute("storeCode");
                            branchCode = (String) schedulePart.getAttribute("branchCode");
                            
                            if((storeCode != null && !storeCode.equals("null") && !storeCode.isEmpty()) && (branchCode != null && !branchCode.equals("null") && !branchCode.isEmpty())) {
                                paramsIssueTasks = new Vector();
                                
                                paramsIssueTasks.addElement(new StringValue(UniqueIDGen.getNextID()));
                                paramsIssueTasks.addElement(new StringValue(unitScheduleId));
                                paramsIssueTasks.addElement(new StringValue((String) schedulePart.getAttribute("itemId")));
                                paramsIssueTasks.addElement(new StringValue((String) schedulePart.getAttribute("itemQuantity")));
                                paramsIssueTasks.addElement(new StringValue((String) schedulePart.getAttribute("itemPrice")));
                                paramsIssueTasks.addElement(new StringValue((String) schedulePart.getAttribute("totalCost")));
                                paramsIssueTasks.addElement(new StringValue((String) schedulePart.getAttribute("note")));
                                paramsIssueTasks.addElement(new StringValue(userId));
                                paramsIssueTasks.addElement(new StringValue("0"));
                                paramsIssueTasks.addElement(new StringValue(branchCode));
                                paramsIssueTasks.addElement(new StringValue(storeCode));

                                commandBean.setparams(paramsIssueTasks);

                                if(commandBean.executeUpdate() < 0) {
                                    connection.rollback();
                                    return false;
                                }

                                try {
                                    Thread.sleep(50);
                                } catch (InterruptedException ex) {
                                    logger.error(ex.getMessage());
                                }
                            }
                        }
                        // end save all parts for this task

                        // insert row in issue meta data for tell this issue actule added this taks for schedule
                        paramsIssueMetaDate.addElement(new StringValue(UniqueIDGen.getNextID()));
                        paramsIssueMetaDate.addElement(new StringValue(issueId));
                        paramsIssueMetaDate.addElement(new StringValue("1"));

                        commandBean.setSQLQuery(sqlMgr.getSql("insertIssueMetaDate").trim());
                        commandBean.setparams(paramsIssueMetaDate);
                        if(commandBean.executeUpdate() < 0) {
                            connection.rollback();
                            return false;
                        }

                    } catch (SQLException se) {
                        connection.rollback();
                        logger.error(se.getMessage());
                        return false;
                    } catch (Exception ex) {
                        connection.rollback();
                        logger.error(ex.getMessage());
                        return false;
                    } finally {
                        try {
                            connection.commit();
                            result = true;
                            connection.close();
                        } catch (SQLException ex) {
                            logger.error("Close Error : " + ex.getMessage());
                            return false;
                        }
                    }
                } else {
                    result = true;
                }
            } catch(Exception ex) { logger.error(ex.getMessage()); }
        } else {
            result = true;
        }
        
        return result;
    }

    public boolean saveObjectBySchTasks(WebBusinessObject webSchTasks, String issueId) throws SQLException {
        Vector params = new Vector();
        Vector paramsIssueTasks = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            connection.setAutoCommit(false);
            forInsert.setSQLQuery(sqlMgr.getSql("insertIssueTasksSql").trim());

            params = new Vector();
            params.addElement(new StringValue(UniqueIDGen.getNextID()));
            params.addElement(new StringValue(issueId));
            params.addElement(new StringValue(webSchTasks.getAttribute("codeTask").toString()));
            params.addElement(new StringValue(webSchTasks.getAttribute("desc").toString()));
            params.addElement(new StringValue(webSchTasks.getAttribute("costHour").toString()));

            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            
            if(queryResult < 0) {
                connection.rollback();
                return false;
            }

            try {
                Thread.sleep(100);
            } catch (InterruptedException ex) {
                logger.error(ex.getMessage());
            }
            
            if(!issueMetaDataMgr.getIssueTasks(issueId)){
                queryResult = -1000;

                paramsIssueTasks.addElement(new StringValue(UniqueIDGen.getNextID()));
                paramsIssueTasks.addElement(new StringValue(issueId));
                paramsIssueTasks.addElement(new StringValue("1"));
                forInsert.setSQLQuery(sqlMgr.getSql("insertIssueMetaDate").trim());
                forInsert.setparams(paramsIssueTasks);
                queryResult = forInsert.executeUpdate();
                
                if(queryResult < 0) {
                    connection.rollback();
                    return false;
                }

                try {
                    Thread.sleep(100);
                } catch (InterruptedException ex) {
                    logger.error(ex.getMessage());
                }
            }
        } catch (SQLException se) {
            connection.rollback();
            logger.error(se.getMessage());
            return false;
        } catch (Exception ex) {
            connection.rollback();
            logger.error(ex.getMessage());
            return false;
        } finally {
            try {
                connection.commit();
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error : " + ex.getMessage());
                return false;
            }
        }
        
        return (queryResult > 0);
    }

    public boolean updateObject(WebBusinessObject wbo) {
        
        Vector params = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;
        
        params.addElement(new StringValue((String) wbo.getAttribute("codeTask")));
        params.addElement(new StringValue((String) wbo.getAttribute("descEn")));
        params.addElement(new StringValue((String) wbo.getAttribute("descAr")));
        params.addElement(new StringValue((String) wbo.getAttribute("taskID")));
        
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(sqlMgr.getSql("updateIssueTasksSQL").trim());
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

    @Override
    public ArrayList getCashedTableAsArrayList() {
        
        cashedData = new ArrayList();
        WebBusinessObject wbo = null;
        
        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add((String) wbo.getAttribute("maintenanceTitle"));
        }
        
        return cashedData;
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
    
    public int CountMaintenanceItems(String taskId){
        Vector params = new Vector();
        SQLCommandBean forSelect = new SQLCommandBean();
        Vector queryResult = new Vector();
        
        params.addElement(new StringValue(taskId));
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forSelect.setConnection(connection);
            forSelect.setSQLQuery(sqlMgr.getSql("countIssueTasksSQL").trim());
            forSelect.setparams(params);
            queryResult = forSelect.executeQuery();
            
        } catch (UnsupportedTypeException ex) {
            ex.printStackTrace();
        } catch (SQLException ex) {
            ex.printStackTrace();
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
                return 0;
            }
        }
        return queryResult.size();
    }

    @Override
    protected void initSupportedQueries() {
     return; //   throw new UnsupportedOperationException("Not supported yet.");
    }
}
