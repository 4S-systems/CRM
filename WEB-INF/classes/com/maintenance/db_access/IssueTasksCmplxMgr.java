package com.maintenance.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;

import java.util.*;
import java.sql.*;
import javax.servlet.http.HttpServletRequest;
import org.apache.log4j.xml.DOMConfigurator;

public class IssueTasksCmplxMgr extends RDBGateWay {
    
    SqlMgr sqlMgr = SqlMgr.getInstance();
    private static IssueTasksCmplxMgr issueTasksCmplxMgr = new IssueTasksCmplxMgr();
    
    public IssueTasksCmplxMgr() {
    }
    
    public static IssueTasksCmplxMgr getInstance() {
        logger.info("Getting IssueTasksMgr Instance ....");
        return issueTasksCmplxMgr;
    }
    
    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("issue_tasks_cmplx.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }
    
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
                forInsert.setSQLQuery(sqlMgr.getSql("insertIssueTasksCmplxSql").trim());
                
                String[] id = request.getParameterValues("id");
                String[] cIssueIndex = request.getParameterValues("maintTypeIndex");
                String[] notes = request.getParameterValues("desc");
                
                for (int i = 0; i < id.length; i++) {
                    params = new Vector();
                    params.addElement(new StringValue(UniqueIDGen.getNextID()));
                    params.addElement(new StringValue(issueId));
                    params.addElement(new StringValue(id[i]));
                    params.addElement(new StringValue(notes[i]));
                    params.addElement(new StringValue(cIssueIndex[i]));
                    
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
    
    public boolean saveObjectBySchTasks(WebBusinessObject webSchTasks, String issueId) throws SQLException {
        Vector params = new Vector();
        IssueMetaDataMgr issueMetaDataMgr = IssueMetaDataMgr.getInstance();
        Vector paramsIssueTasks = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertIssueTasksCmplxSql").trim());
            
//            String[] id = request.getParameterValues("id");
//            String[] notes = request.getParameterValues("desc");
            
            
            params = new Vector();
            params.addElement(new StringValue(UniqueIDGen.getNextID()));
            params.addElement(new StringValue(issueId));
            params.addElement(new StringValue(webSchTasks.getAttribute("codeTask").toString()));
            params.addElement(new StringValue(webSchTasks.getAttribute("desc").toString()));
            
            
            
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            try {
                Thread.sleep(200);
            } catch (InterruptedException ex) {
                logger.error(ex.getMessage());
            }
            try {
                
                if(!issueMetaDataMgr.getIssueTasks(issueId)){
                    
                    paramsIssueTasks.addElement(new StringValue(UniqueIDGen.getNextID()));
                    paramsIssueTasks.addElement(new StringValue(issueId));
                    paramsIssueTasks.addElement(new StringValue("1"));
                    forInsert.setSQLQuery(sqlMgr.getSql("insertIssueMetaDate").trim());
                    forInsert.setparams(paramsIssueTasks);
                    queryResult = forInsert.executeUpdate();
                    try {
                        Thread.sleep(200);
                    } catch (InterruptedException ex) {
                        logger.error(ex.getMessage());
                    }
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            } catch (Exception ex) {
                ex.printStackTrace();
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
        
        params.addElement(new StringValue((String) wbo.getAttribute("codeTask")));
        params.addElement(new StringValue((String) wbo.getAttribute("descEn")));
        params.addElement(new StringValue((String) wbo.getAttribute("descAr")));
        params.addElement(new StringValue((String) wbo.getAttribute("taskID")));
        
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(sqlMgr.getSql("updateIssueTasksCmplxSQL").trim());
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
    
    public  int CountMaintenanceItems(String taskId){
        Vector params = new Vector();
        SQLCommandBean forSelect = new SQLCommandBean();
        Vector queryResult = new Vector();
        
        params.addElement(new StringValue(taskId));
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forSelect.setConnection(connection);
            forSelect.setSQLQuery(sqlMgr.getSql("countIssueTasksCmplxSQL").trim());
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
