package com.maintenance.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.util.*;
import java.util.*;
import java.sql.*;



import javax.servlet.http.HttpSession;
import org.apache.log4j.xml.DOMConfigurator;
//import org.apache.tools.ant.taskdefs.Sleep;

public class TaskToolsMgr extends RDBGateWay {
    SqlMgr sqlMgr = SqlMgr.getInstance();
    private static TaskToolsMgr taskToolsMgr = new TaskToolsMgr();
    
    public TaskToolsMgr() {
    }
    
    public static TaskToolsMgr getInstance() {
        logger.info("Getting TaskToolsMgr Instance ....");
        return taskToolsMgr;
    }
    
    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if(supportedForm == null) {
            try {
                supportedForm  = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("task_tools.xml")));
            } catch(Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }
    
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }
    
    public boolean saveObject(WebBusinessObject wbo,HttpSession session){
        
        WebBusinessObject userWbo=(WebBusinessObject)session.getAttribute("loggedUser");
        Vector params = new Vector();
        String query="INSERT INTO TASK_TOOLS VALUES (?,?,?,SYSDATE,?,?,?)";
        
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        
        UniqueIdGen uniqueIdGen=new UniqueIdGen();
        String id=uniqueIdGen.getNextID();
        
        params.addElement(new StringValue(id));
        params.addElement(new StringValue((String) wbo.getAttribute("taskId")));
        params.addElement(new StringValue((String) wbo.getAttribute("toolId")));
        params.addElement(new StringValue((String) userWbo.getAttribute("userId")));
        params.addElement(new StringValue((String) wbo.getAttribute("notes")));
        params.addElement(new StringValue((String) wbo.getAttribute("toolType")));
        
        try {
            Connection connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            
            forInsert.setSQLQuery(query);
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            
            connection.close();
            
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        }
        
        try {
            Thread.sleep(200);
        } catch (InterruptedException ex) {
            ex.printStackTrace();
        }
        
        return queryResult>0;
    }
    
    public ArrayList getCashedTableAsBusObjects() {
        cashedData = new ArrayList();
        WebBusinessObject wbo = null;
        
        for(int i=0; i<cashedTable.size();i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add(wbo);
        }
        
        return cashedData;
    }
    
    public ArrayList getCashedTableAsArrayList() {
        
        cashedData = new ArrayList();
        WebBusinessObject wbo = null;
        
        for(int i=0; i<cashedTable.size();i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add((String) wbo.getAttribute("id"));
        }
        
        return cashedData;
    }

    @Override
    protected void initSupportedQueries() {
     return; //   throw new UnsupportedOperationException("Not supported yet.");
    }
    
}
