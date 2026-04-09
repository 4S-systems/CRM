package com.maintenance.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import com.silkworm.util.UniqueIdGen;

import java.sql.*;
import java.util.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.log4j.xml.DOMConfigurator;

public class TaskExecutionNotesMgr extends RDBGateWay {
    
    SqlMgr sqlMgr = SqlMgr.getInstance();
    private static TaskExecutionNotesMgr taskExecutionNotesMgr = new TaskExecutionNotesMgr();
    
    public TaskExecutionNotesMgr() {
    }
    
    public static TaskExecutionNotesMgr getInstance() {
        logger.info("Getting TaskExecutionNotesMgr Instance ....");
        return taskExecutionNotesMgr;
    }
    
    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("task_execution_notes.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }
    
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }
    
    public boolean saveObject(HttpServletRequest request,HttpSession session) throws NoUserInSessionException {
       
        WebBusinessObject userWbo=new WebBusinessObject();
        userWbo=(WebBusinessObject)session.getAttribute("loggedUser");
        
        String taskId = request.getParameter("taskId");
        String[] arrNotes = request.getParameterValues("notes");
        String userId=userWbo.getAttribute("userId").toString();
        
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            
            if(arrNotes!=null){
                for(int i=0;i<arrNotes.length;i++){
                    params=new Vector();
                    String id=UniqueIdGen.getNextID();
                    params.addElement(new StringValue(id));
                    params.addElement(new StringValue(taskId));
                    params.addElement(new StringValue(arrNotes[i]));
                    params.addElement(new StringValue(userId));

                    forInsert.setSQLQuery(sqlMgr.getSql("inserTaskExecNotes").trim());
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

    @Override
    protected void initSupportedQueries() {
       return; // throw new UnsupportedOperationException("Not supported yet.");
    }
    
}
