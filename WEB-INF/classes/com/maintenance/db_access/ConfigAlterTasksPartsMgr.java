package com.maintenance.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;

import java.util.*;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.http.HttpSession;

import org.apache.log4j.xml.DOMConfigurator;

public class ConfigAlterTasksPartsMgr extends RDBGateWay {
    SqlMgr sqlMgr = SqlMgr.getInstance();
    private static ConfigAlterTasksPartsMgr configAlterTasksPartsMgr = new ConfigAlterTasksPartsMgr();

    public ConfigAlterTasksPartsMgr() { }
    
    public static ConfigAlterTasksPartsMgr getInstance() {
        logger.info("Getting configAlterTasksPartsMgr Instance ....");
        return configAlterTasksPartsMgr;
    }

    @Override
    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if(supportedForm == null) {
            try {
                supportedForm  = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("alter_items_for_tasks_parts.xml")));
            } catch(Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }
   
    public boolean saveObject(Hashtable hash,HttpSession s) throws SQLException {
        Vector activeStoreVec = new Vector();
        ActiveStoreMgr activeStoreMgr = ActiveStoreMgr.getInstance();
        WebBusinessObject storeDataWbo = new WebBusinessObject();
        WebBusinessObject branchDataWbo = new WebBusinessObject();
        WebBusinessObject activeStoreWbo = new WebBusinessObject();
        StoresErpMgr storesErpMgr = StoresErpMgr.getInstance();
        BranchErpMgr branchErpMgr = BranchErpMgr.getInstance();
        String storeErpId = null;
        String branchErpId = null;

        activeStoreVec = activeStoreMgr.getActiveStore(s);
        if(activeStoreVec.size()>0) {
            activeStoreWbo = (WebBusinessObject)activeStoreVec.get(0);
             storeDataWbo = storesErpMgr.getOnSingleKey(activeStoreWbo.getAttribute("storeCode").toString());
             branchDataWbo = branchErpMgr .getOnSingleKey(activeStoreWbo.getAttribute("branchCode").toString());
             storeErpId = storeDataWbo.getAttribute("code").toString();
             branchErpId = branchDataWbo.getAttribute("code").toString();
        }

        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue(hash.get("TaskCode").toString()));
        params.addElement(new StringValue(hash.get("itemID").toString()));
        params.addElement(new IntValue(new Integer(hash.get("itemQuantity").toString())));
        params.addElement(new FloatValue(new Float(hash.get("itemPrice").toString()).floatValue()));
        params.addElement(new FloatValue(new Float(hash.get("totalCost").toString()).floatValue()));
        params.addElement(new StringValue(hash.get("note").toString()));
        params.addElement(new StringValue(branchErpId));
        params.addElement(new StringValue(storeErpId));
        Connection connection = null;
        
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertConfigTaskParts").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            try {
                Thread.sleep(200);
            } catch (InterruptedException ex) {
                logger.error(ex.getMessage());
            }
        } catch(SQLException se) {
            logger.error(se.getMessage());
            return false;
        } finally {
            try {
                connection.close();
            } catch(SQLException ex) {
                logger.error("Close Error");
                return false;
            }
        }
        
        return (queryResult > 0);
    }
    
    public boolean saveObjects(Vector<Hashtable> parts) {
        Vector params;
        SQLCommandBean forInsert = new SQLCommandBean();
        Connection connection = null;

        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertAlterConfigTaskParts").trim());
        
            for (Hashtable<String, String> part : parts) {
                params = new Vector();

                params.addElement(new StringValue(UniqueIDGen.getNextID()));
                params.addElement(new StringValue(part.get("TaskCode")));
                params.addElement(new StringValue(part.get("itemID")));
                params.addElement(new IntValue(new Integer(part.get("itemQuantity"))));
                params.addElement(new FloatValue(new Float(part.get("itemPrice")).floatValue()));
                params.addElement(new FloatValue(new Float(part.get("totalCost")).floatValue()));
                params.addElement(new StringValue(part.get("note")));
                params.addElement(new StringValue(part.get("branch")));
                params.addElement(new StringValue(part.get("store")));
                params.addElement(new StringValue(part.get("mainItemId")));
                params.addElement(new StringValue(part.get("mainItem")));
                forInsert.setparams(params);
                if(forInsert.executeUpdate() == 0) {
                    connection.rollback();
                    return false;
                }

                try {
                    Thread.sleep(100);
                } catch (InterruptedException ex) {
                    logger.error(ex.getMessage());
                }
            }
        } catch(SQLException se) {
            try {
                connection.rollback();
            } catch(SQLException sql) { logger.error(sql.getMessage()); }
            logger.error(se.getMessage());
            return false;
        } finally {
            try {
                connection.commit();
                connection.close();
            } catch(SQLException ex) {
                logger.error("Close Error");
                return false;
            }
        }
        
        return true;
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

    public Vector checkAlterPartsList (String taskId,String itemId){
        Vector partsList=new Vector();
            ConfigTasksPartsMgr  configTasksPartsMgr = ConfigTasksPartsMgr.getInstance();
        try {
            Vector confgPartV = (Vector) configTasksPartsMgr.getOnArbitraryKey(taskId, "key1");
            for(int i=0;i<confgPartV.size();i++){
                WebBusinessObject wbo = new WebBusinessObject();
                wbo = (WebBusinessObject) confgPartV.get(i);
                Vector taskByItemsV = (Vector)configAlterTasksPartsMgr.getOnArbitraryDoubleKey(taskId, "key1", wbo.getAttribute("itemId").toString(), "key2");
                for(int x=0;x<taskByItemsV.size();x++){
                    WebBusinessObject alterPartWbo = (WebBusinessObject) taskByItemsV.get(x);
                    if(alterPartWbo.getAttribute("itemId").toString().equals(itemId)){
                        partsList = taskByItemsV;
                        break;
                    }
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(ConfigAlterTasksPartsMgr.class.getName()).log(Level.SEVERE, null, ex);
        } catch (Exception ex) {
            Logger.getLogger(ConfigAlterTasksPartsMgr.class.getName()).log(Level.SEVERE, null, ex);
        }
        return partsList;
    }

    @Override
    protected void initSupportedQueries() {
    return; //    throw new UnsupportedOperationException("Not supported yet.");
    }
    
}
