package com.maintenance.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import com.silkworm.util.*;

import java.util.*;
import java.text.*;
import java.sql.*;
import javax.servlet.http.HttpSession;
import org.apache.log4j.xml.DOMConfigurator;

public class ItemCatsMgr extends RDBGateWay{
    private static ItemCatsMgr itemCatsMgr = new ItemCatsMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();
    
    
    public ItemCatsMgr() {
    }
    
    public static ItemCatsMgr getInstance() {
        logger.info("Getting ItemCatsMgr Instance ....");
        return itemCatsMgr;
    }
    
    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if(supportedForm == null) {
            try {
                supportedForm  = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("equp_item_cats.xml")));
            } catch(Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }
    
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }
    
    public boolean saveObject(Hashtable hash, HttpSession s) throws SQLException {
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        
        params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue(hash.get("scheduleUnitID").toString()));
        params.addElement(new StringValue(hash.get("itemID").toString()));
        params.addElement(new IntValue(new Integer(hash.get("itemQuantity").toString())));
        params.addElement(new FloatValue(new Float(hash.get("itemPrice").toString()).floatValue()));
        params.addElement(new FloatValue(new Float(hash.get("totalCost").toString()).floatValue()));
        params.addElement(new StringValue(hash.get("note").toString()));
        params.addElement(new StringValue((String) waUser.getAttribute("userId")));
        
        Connection connection = null;
        
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertQuantifiedMntence").trim());
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
    
    public boolean saveObject(WebBusinessObject wbo, HttpSession s, String[] items) throws NoUserInSessionException, SQLException {
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        WebBusinessObject eqWbo = CategoryMgr.getInstance().getOnSingleKey(wbo.getAttribute("categoryID").toString());
        String categoryName = eqWbo.getAttribute("categoryName").toString();
        
        Vector itemCatsParams = new Vector();
        itemCatsParams.addElement(new StringValue(wbo.getAttribute("equipmentID").toString()));
        itemCatsParams.addElement(new StringValue(categoryName));
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        
        Connection connection = null;
        
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            
            forInsert.setSQLQuery(sqlMgr.getSql("deleteItemCat").trim());
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
                    
                    forInsert.setSQLQuery(sqlMgr.getSql("insertItemCat").trim());
                    forInsert.setparams(itemCatsParams);
                    queryResult = forInsert.executeUpdate();
                }
                cashData();
            } catch(SQLException se) {
                return false;
            } finally {
                connection.close();
            }
            
        } else {
            queryResult = 1;
        }
        return (queryResult > 0);
    }
    
    public ArrayList getCashedTableAsArrayList() {
        return null;
    }
    
    public ArrayList getCashedTableAsBusObjects() {
        return null;
    }
    
    public Vector getItemsCats(String machineID) {
        
        Connection connection = null;
        Vector SQLparams = new Vector();
        Vector queryResult = null;
        
        SQLparams.addElement(new StringValue(machineID));
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection= dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getItemsCatsSQL").trim());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
        } catch(SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch(UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch(SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }
        
        Vector result = new Vector();
        
        Row r = null;
        Enumeration e = queryResult.elements();
        try {
            while(e.hasMoreElements()) {
                r = (Row) e.nextElement();
                result.addElement(r.getString("CATEGORY_NAME"));
            }
        } catch(NoSuchColumnException ce){
            logger.error(ce);
        }
        return result;
    }
    
    public Vector getScheduleItems(String[] itemsList) {
        Vector itemsVector = new Vector();
        Vector itemDetails = null;
        int prevoiusIndex =0;
        
        for(int i=0; i<itemsList.length; i++) {
            itemDetails = new Vector();
            String item = itemsList[i];
            
            
            for(int j=0; j<item.length(); j++) {
                char ch = item.charAt(j);
                
                if(ch =='D'|| ch =='Q' || ch =='P' || ch =='T') {
                    itemDetails.addElement((String)item.substring(prevoiusIndex,j));
                    prevoiusIndex = j+1;
                    if(ch == 'T'){
                        itemDetails.addElement((String)item.substring(prevoiusIndex));
                        break;
                    }
                }
            }
            
            itemsVector.addElement(itemDetails);
            prevoiusIndex = 0;
        }
        return itemsVector;
    }
    
    public Vector getAllItems(){
        
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        StringBuffer query = new StringBuffer(sqlMgr.getSql("getAllCategoryItems").trim());
        
        
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection= dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            queryResult = forQuery.executeQuery();
            
            
        } catch(SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        }
        
        catch(UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch(SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }
        
        Vector resultBusObjs = new Vector();
        
        Row r = null;
        Enumeration e = queryResult.elements();
        while(e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }
    
    public Vector getItemsCategory() {
        Connection connection = null;
        Vector SQLparams = new Vector();
        Vector queryResult = null;
        
//        SQLparams.addElement(new StringValue(machineID));
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection= dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("ItemsCategorySQL").trim());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
        } catch(SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch(UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch(SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }
        
        Vector result = new Vector();
        
        Row r = null;
        Enumeration e = queryResult.elements();
        try {
            while(e.hasMoreElements()) {
                r = (Row) e.nextElement();
                result.addElement(r.getString("CATEGORY_NAME"));
            }
        } catch(NoSuchColumnException ce){
            logger.error(ce);
        }
        return result;
    }

    @Override
    protected void initSupportedQueries() {
     return; //   throw new UnsupportedOperationException("Not supported yet.");
    }
}
