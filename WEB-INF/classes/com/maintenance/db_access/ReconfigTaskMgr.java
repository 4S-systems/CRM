package com.maintenance.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.util.*;
import java.util.*;
import java.sql.*;

import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.http.HttpSession;
import org.apache.log4j.xml.DOMConfigurator;

public class ReconfigTaskMgr extends RDBGateWay {
    SqlMgr sqlMgr = SqlMgr.getInstance();
    private static ReconfigTaskMgr reconfigTaskMgr = new ReconfigTaskMgr();
    
    public ReconfigTaskMgr() {
    }
    
    public static ReconfigTaskMgr getInstance() {
        logger.info("Getting ReconfigTaskMgr Instance ....");
        return reconfigTaskMgr;
    }
    
    @Override
    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if(supportedForm == null) {
            try {
                supportedForm  = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("reconfig_task.xml")));
            } catch(Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }
    
    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }
    
    @Override
    public ArrayList getCashedTableAsBusObjects() {
        cashedData = new ArrayList();
        WebBusinessObject wbo = null;
        
        for(int i=0; i<cashedTable.size();i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add(wbo);
        }
        
        return cashedData;
    }
    
    @Override
    public ArrayList getCashedTableAsArrayList() {
        
        cashedData = new ArrayList();
        WebBusinessObject wbo = null;
        
        for(int i=0; i<cashedTable.size();i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add((String) wbo.getAttribute("id"));
        }
        
        return cashedData;
    }
    
    public boolean saveObjects(String issueId, String itemId, String[] taskIds, String[] quantitys) {
        SQLCommandBean forInsert = new SQLCommandBean();
        Vector params;
        int index = 0;
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertReconfigTask").trim());
            
            for(String taskId : taskIds) {
                params = new Vector();
                
                params.addElement(new StringValue(UniqueIdGen.getNextID()));
                params.addElement(new StringValue(issueId));
                params.addElement(new StringValue(taskId));
                params.addElement(new StringValue(itemId));
                params.addElement(new IntValue(Integer.parseInt(quantitys[index])));

                forInsert.setparams(params);

                if(forInsert.executeUpdate() == 0) {
                    connection.rollback();
                    return false;
                }

                try {
                    Thread.sleep(200);
                } catch (InterruptedException interruptedException) {
                    logger.error(interruptedException.getMessage());
                }

                index++;
            }
        } catch (Exception exception) {
            try {
                connection.rollback();
                return false;
            } catch (SQLException sql) {
                logger.error(sql.getMessage());
            }
            logger.error(exception.getMessage());
        } finally {
            try {
                connection.commit();
                connection.close();
            } catch (SQLException exception) {
                logger.error(exception.getMessage());
            }
        }
        
        return true;
    }
    
    public boolean saveObject(String issueId,String[] itemId,String[] taskId,HttpSession session){
        
        WebBusinessObject userWbo=(WebBusinessObject)session.getAttribute("loggedUser");
        
       // String query="INSERT INTO TASK_TOOLS VALUES (?,?,?,SYSDATE,?,?,?)";
        
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
        } catch (SQLException ex) {
            Logger.getLogger(ReconfigTaskMgr.class.getName()).log(Level.SEVERE, null, ex);
        }

        for(int i=0;i<itemId.length;i++ ) {
        Vector params = new Vector();
        UniqueIdGen uniqueIdGen=new UniqueIdGen();
        String id=uniqueIdGen.getNextID();
        
        params.addElement(new StringValue(id));
        params.addElement(new StringValue(issueId));
        params.addElement(new StringValue(taskId[i]));
        params.addElement(new StringValue(itemId[i]));
        
        try {
           
            
            forInsert.setSQLQuery(sqlMgr.getSql("insertReconfigTask").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            
           try {
            Thread.sleep(200);
        } catch (InterruptedException ex) {
            ex.printStackTrace();
        }
        
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        }
        }
        try {
            connection.close();
        } catch (SQLException ex) {
            Logger.getLogger(ReconfigTaskMgr.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        return queryResult>0;
    }

    public boolean getActiveItemTask(String issueId,String taskId,String itemId) throws Exception {

        Vector SQLparams = new  Vector();
        Connection connection = null;
        Vector queryResult = null;
        SQLparams.addElement(new StringValue(issueId));
        SQLparams.addElement(new StringValue(taskId));
        SQLparams.addElement(new StringValue(itemId));
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getActiveItemTask").trim());
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();


        } catch(SQLException se) {
            logger.info("database error from getListOnSecondKey: ImageMgr " + se.getMessage());
        } catch(UnsupportedTypeException uste) {
            logger.info("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch(SQLException sex) {
                logger.info("troubles closing connection " + sex.getMessage());
                return false;
            }
        }

        return queryResult.size() > 0;
    }
    
    // TASK_ID = ?
    public Vector<WebBusinessObject> getReconfigTaskByItemName(String issueId, String taskId) {
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector<Row> queryResult = null;
        Vector SQLparams = new Vector();
        WebBusinessObject wbo;
        
        StringBuilder dq = new StringBuilder("SELECT DISTINCT TASK_ID, ITEMS.ITEM_DESC AS ITEM_NAME, RECONFIG_TASK.ITEM_ID, RECONFIG_TASK.ITEM_QUANTITY FROM ");
        dq.append(supportedForm.getTableSupported().getAttribute("name")).append(", ITEMS WHERE ");
        dq.append("RECONFIG_TASK.ITEM_ID = ITEMS.ITEMCODE_BY_ITEMFORM AND ");
        dq.append(supportedForm.getTableSupported().getAttribute("key1"));
        dq.append(" = ? AND ");
        dq.append(supportedForm.getTableSupported().getAttribute("key2"));
        dq.append(" = ? ");
        String theQuery = dq.toString();
        
        if (supportedForm == null) {
            initSupportedForm();
        }
        
        SQLparams.add(new StringValue(issueId));
        SQLparams.add(new StringValue(taskId));
        
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(theQuery);
            forQuery.setparams(SQLparams);
            
            queryResult = forQuery.executeQuery();
            
        } catch (SQLException se) {
            logger.error("***** " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try{
                connection.close();
            } catch(SQLException sql) { logger.error("***** " + sql.getMessage()); }
            
        }
        
        Vector<WebBusinessObject> reultBusObjs = new Vector<WebBusinessObject>();
        
        for(Row row : queryResult) {
            wbo = fabricateBusObj(row);

            try {
                wbo.setAttribute("itemName", row.getString("ITEM_NAME"));
            } catch(Exception ex) { }

            reultBusObjs.add(wbo);
        }
        
        return reultBusObjs;
    }

    @Override
    protected void initSupportedQueries() {
      return; //  throw new UnsupportedOperationException("Not supported yet.");
    }
}
