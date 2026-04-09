package com.maintenance.db_access;

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
import org.apache.log4j.xml.DOMConfigurator;

public class ConfigureCategoryMgr extends RDBGateWay {
    SqlMgr sqlMgr;
    private static ConfigureCategoryMgr configureCategoryMgr = new ConfigureCategoryMgr();
    
//    private static final String insertfailureSQL = "INSERT INTO failure_code VALUES (?,?,now(),?,?)";
//    private static final String updatefailureSQL = "UPDATE failure_code SET TITLE = ?, CREATION_TIME = now(), CREATED_BY = ?, DESCRIPTION = ?  WHERE ID = ?";
    
    
    public ConfigureCategoryMgr() {
    }
    
    public static ConfigureCategoryMgr getInstance() {
        logger.info("Getting ConfigureCategoryMgr Instance ....");
        return configureCategoryMgr;
    }
    
    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if(supportedForm == null) {
            try {
                supportedForm  = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("machine_cats_config.xml")));
            } catch(Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }
    
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }
    
    public boolean saveObject(String[][] SaveData, int size)throws NoUserInSessionException, SQLException  {
        Vector itemCatsParams;
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        sqlMgr = new SqlMgr();
        Connection connection = null;
        try {
            for(int i = 0; i < size; i++){
                
                if(SaveData[i][0].toString().equalsIgnoreCase("no"))
                    continue;
                itemCatsParams = new Vector();
                
                
                itemCatsParams.addElement(new StringValue(UniqueIDGen.getNextID()));
                itemCatsParams.addElement(new StringValue(SaveData[i][0]));
                itemCatsParams.addElement(new StringValue(SaveData[i][1]));
                itemCatsParams.addElement(new StringValue(SaveData[i][2]));
                itemCatsParams.addElement(new StringValue(SaveData[i][3]));
                itemCatsParams.addElement(new StringValue(SaveData[i][4]));
                try {
                        Thread.sleep(200);
                    } catch (InterruptedException ex) {
                        logger.info(ex.getMessage());
                    }
                connection = dataSource.getConnection();
                forInsert.setConnection(connection);
                forInsert.setSQLQuery(sqlMgr.getSql("insertItemEquipmentCat").trim());
                forInsert.setparams(itemCatsParams);
                queryResult = forInsert.executeUpdate();
            }
            cashData();
        } catch(SQLException se) {
            logger.error("Save Item and Item Category sql error "+se.getMessage());
            return false;
        } finally {
            connection.close();
        }
        
        
        return (queryResult > 0);
        
        
    }
    
    public boolean saveObject(WebBusinessObject wbo, HttpSession s, String[] items) throws NoUserInSessionException, SQLException {
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        WebBusinessObject eqWbo = CategoryMgr.getInstance().getOnSingleKey(wbo.getAttribute("categoryID").toString());
        String categoryName = eqWbo.getAttribute("categoryName").toString();
        
        Vector itemCatsParams = new Vector();
        itemCatsParams.addElement(new StringValue(wbo.getAttribute("equipmentID").toString()));
        itemCatsParams.addElement(new StringValue(categoryName));
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        sqlMgr = new SqlMgr();
        Connection connection = null;
        
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            
            forInsert.setSQLQuery(sqlMgr.getSql("deleteItemEquipmentCat").trim());
            forInsert.setparams(itemCatsParams);
            queryResult = forInsert.executeUpdate();
            
            cashData();
        } catch(SQLException se) {
            logger.error("Save Item and Item Category sql error "+se.getMessage());
            return false;
        } finally {
            connection.close();
        }
        
        
        
        
        if(items != null){
            try {
                for(int i = 0; i < items.length; i++){
                    itemCatsParams = new Vector();
                    String itemID = items[i];
                    WebBusinessObject itemWbo = MaintenanceItemMgr.getInstance().getOnSingleKey(itemID);
                    itemCatsParams.addElement(new StringValue(UniqueIDGen.getNextID()));
                    itemCatsParams.addElement(new StringValue(wbo.getAttribute("equipmentID").toString()));
                    itemCatsParams.addElement(new StringValue(itemID));
                    itemCatsParams.addElement(new StringValue(categoryName));
                    itemCatsParams.addElement(new StringValue(itemWbo.getAttribute("itemDscrptn").toString()));
                    itemCatsParams.addElement(new FloatValue(new Float(itemWbo.getAttribute("itemUnitPrice").toString()).floatValue()));
                    try {
                        Thread.sleep(200);
                    } catch (InterruptedException ex) {
                        logger.error(ex.getMessage());
                    }
                    connection = dataSource.getConnection();
                    forInsert.setConnection(connection);
                    
                    forInsert.setSQLQuery(sqlMgr.getSql("insertItemEquipmentCat").trim());
                    forInsert.setparams(itemCatsParams);
                    queryResult = forInsert.executeUpdate();
                }
                cashData();
            } catch(SQLException se) {
                logger.error("Save Item and Item Category sql error "+se.getMessage());
                return false;
            } finally {
                connection.close();
            }
            
        } else {
            queryResult = 1;
        }
        return (queryResult > 0);
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
            cashedData.add((String) wbo.getAttribute("itemDesc"));
        }
        
        return cashedData;
    }

    @Override
    protected void initSupportedQueries() {
      return;//  throw new UnsupportedOperationException("Not supported yet.");
    }
}
