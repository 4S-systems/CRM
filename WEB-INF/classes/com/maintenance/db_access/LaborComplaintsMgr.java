package com.maintenance.db_access;

import com.docviewer.business_objects.Document;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.servlets.MultipartRequest;
import javax.servlet.http.HttpSession;
import java.util.*;
import java.sql.*;
import java.io.File;
import com.docviewer.db_access.QueryMgr;
import com.silkworm.db_access.FileMgr;
import com.silkworm.jsptags.DropdownDate;
import java.io.InputStream;
import java.math.BigDecimal;
import javax.servlet.http.HttpServletRequest;
import org.apache.log4j.xml.DOMConfigurator;
import com.maintenance.db_access.*;

public class LaborComplaintsMgr extends RDBGateWay {
    
    //Variables
    SqlMgr sqlMgr = SqlMgr.getInstance();
    IssueTasksMgr issueTasksMgr = IssueTasksMgr.getInstance();
    TaskMgr taskMgr = TaskMgr.getInstance();
    
    private static LaborComplaintsMgr laborComplaintMgr = new LaborComplaintsMgr();
    
    public static LaborComplaintsMgr getInstance() {
        logger.error("Getting LaborComplaintMgr Instance ....");
        return laborComplaintMgr;
    }
    
    public void setQueryMgr(QueryMgr qm) {
        queryMgr = qm;
    }
    
    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("labor_complaint.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }
    
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }
    
    public boolean saveObject(HttpServletRequest request) throws java.sql.SQLException {
        //Define Variables
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        Connection connection = null;
        
        int queryResult = -1000;
        
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertComplaintSql").trim());
            
            String issueId=request.getParameter("issueId");
            String []laborId = request.getParameterValues("empId");
            String []laborName = request.getParameterValues("empName");
            String []comp=request.getParameterValues("comp");
            String []isRelated  = request.getParameterValues("related");
            
            for (int i = 0; i < isRelated.length; i++) {
                if(isRelated[i].equalsIgnoreCase("no") || isRelated[i].equalsIgnoreCase("new")){
                    params = new Vector();
                    params.addElement(new StringValue(UniqueIDGen.getNextID()));
                    params.addElement(new StringValue(laborId[i]));
                    params.addElement(new StringValue(issueId));
                    params.addElement(new StringValue(comp[i]));
                    params.addElement(new StringValue(laborName[i]));
                    params.addElement(new StringValue("NO"));
                    
                    forInsert.setparams(params);
                    queryResult = forInsert.executeUpdate();
                    try {
                        Thread.sleep(200);
                    } catch (InterruptedException ex) {
                        logger.error(ex.getMessage());
                    }
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
     
    
    public boolean saveObject(HttpServletRequest request,String issd ) throws java.sql.SQLException {
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertComplaintSql").trim());
            
            String laborId=request.getParameter("emp");
            String issueId=issd;
            String [] comp=request.getParameterValues("comp");
            
            for (int i = 0; i < comp.length; i++) {
                params = new Vector();
                params.addElement(new StringValue(UniqueIDGen.getNextID()));
                params.addElement(new StringValue(laborId));
                params.addElement(new StringValue(issueId));
                params.addElement(new StringValue(comp[i]));
                
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
    
    public boolean saveObjectCmplx(HttpServletRequest request) throws java.sql.SQLException {
        //Define Variables
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        Connection connection = null;
        int queryResult = -1000;
        
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertComplaintSql").trim());
            
            String issueId=request.getParameter("issueId");
            String []laborId = request.getParameterValues("empId");
            String []laborName = request.getParameterValues("empName");
            String []comp=request.getParameterValues("comp");
            String []isRelated  = request.getParameterValues("related");
            String []cIssueIndex  = request.getParameterValues("cIssueIndex");
            
            for (int i = 0; i < isRelated.length; i++) {
                if(isRelated[i].equalsIgnoreCase("no") || isRelated[i].equalsIgnoreCase("new")){
                    params = new Vector();
                    params.addElement(new StringValue(UniqueIDGen.getNextID()));
                    params.addElement(new StringValue(laborId[i]));
                    params.addElement(new StringValue(issueId));
                    params.addElement(new StringValue(comp[i]));
                    params.addElement(new StringValue(laborName[i]));
                    params.addElement(new StringValue(cIssueIndex[i]));
                    
                    forInsert.setparams(params);
                    queryResult = forInsert.executeUpdate();
                    try {
                        Thread.sleep(200);
                    } catch (InterruptedException ex) {
                        logger.error(ex.getMessage());
                    }
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
    
    
    public java.util.ArrayList getCashedTableAsArrayList() {
        return null;
    }
    
    
    public Vector getComplaints(String Id) {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        StringBuffer query = new StringBuffer(sqlMgr.getSql("getcomplaints").trim());
//        query.append(sSearch);
//        query.append("%'");
        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(Id));
        
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(SQLparams);
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
    
    
    
    public boolean newob(HttpServletRequest request,String issueId) throws java.sql.SQLException {
        Vector compalintsParams = new Vector();
        Vector tasksParams = new Vector();
        
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        Connection connection = null;        
        //Get request parameters 
        String [] compId=request.getParameterValues("compId");
        String [] tasks=request.getParameterValues("taskId");
        String [] taw=request.getParameterValues("recommend");
        
        try {
            //set connection
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            
            for (int i = 0; i < compId.length; i++) {
                if(!tasks[i].equalsIgnoreCase("---")){
                    //save issue_compaliants tasks
                    compalintsParams = new Vector();
                    compalintsParams.addElement(new StringValue(UniqueIDGen.getNextID()));
                    compalintsParams.addElement(new StringValue(issueId));
                    compalintsParams.addElement(new StringValue(tasks[i]));
                    compalintsParams.addElement(new StringValue(compId[i]));
                    compalintsParams.addElement(new StringValue(taw[i]));
                    forInsert.setSQLQuery(sqlMgr.getSql("insertMergeComplaintSql").trim());   
                    forInsert.setparams(compalintsParams);
                    queryResult = forInsert.executeUpdate();
                    
                    //Check if issue task is exist or not
                    Vector tasksVec = issueTasksMgr.getOnArbitraryDoubleKey(issueId, "key1", tasks[i], "key2");
                    if(tasksVec == null || tasksVec.size()<=0){
                        //save issue tasks
                        tasksParams = new Vector();
                        tasksParams.addElement(new StringValue(UniqueIDGen.getNextID()));
                        tasksParams.addElement(new StringValue(issueId));
                        tasksParams.addElement(new StringValue(tasks[i]));
                        tasksParams.addElement(new StringValue(taw[i]));
                        tasksParams.addElement(new StringValue("0"));                        
                        forInsert.setSQLQuery(sqlMgr.getSql("insertIssueTasksSql").trim());
                        forInsert.setparams(tasksParams);
                        queryResult = forInsert.executeUpdate();
                    }
                    try {
                        Thread.sleep(200);
                    } catch (InterruptedException ex) {
                        logger.error(ex.getMessage());
                    }
                }
            }
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } catch(Exception ex){
            logger.error(ex.getMessage());
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
    protected void initSupportedQueries() {
     return; //   throw new UnsupportedOperationException("Not supported yet.");
    }
    
    
}
