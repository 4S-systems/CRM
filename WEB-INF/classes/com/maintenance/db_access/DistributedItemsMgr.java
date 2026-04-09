package com.maintenance.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import com.silkworm.jsptags.DropdownDate;
import java.sql.SQLException;
import java.util.*;
import javax.servlet.http.HttpSession;
import java.sql.*;
import javax.servlet.http.HttpServletRequest;
import org.apache.log4j.xml.DOMConfigurator;

public class DistributedItemsMgr extends RDBGateWay {
    
    private static DistributedItemsMgr distributedItemsMgr = new DistributedItemsMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();
    
    public static DistributedItemsMgr getInstance() {
        logger.info("Getting distributedItemsMgr Instance ....");
        return distributedItemsMgr;
    }
    
    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("distributed_items.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }
    
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }
    
    public ArrayList getCashedTableAsArrayList() {
        
        cashedData = new ArrayList();
        WebBusinessObject wbo = null;
        
        for(int i=0; i<cashedTable.size();i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add((String) wbo.getAttribute("itemCode"));
        }
        
        return cashedData;
    }
    
    /****************** Elmalik *******************/
    
    public Vector getSparePartByName(String name,String storeId) {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        
        Vector SQLparams = new Vector();
        Vector queryResult = null;
        
        String query="select * from DISTRIBUTED_ITEMS where ITEM_DESC LIKE '%ppp%' and Store_code = ? AND ITEM_DESC IS NOT NULL";
        SQLparams.addElement(new StringValue(storeId));
        
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
//            forQuery.setSQLQuery(sqlMgr.getSql("getSparePartByName").trim().replaceAll("ppp", name));
            forQuery.setSQLQuery(query.trim().replaceAll("ppp", name));
            forQuery.setparams(SQLparams);
            
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
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
    
    public Vector getByCode(String number,String storeId) {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector SQLparams = new Vector();
        Vector queryResult = null;
        
        String query="select * from DISTRIBUTED_ITEMS where ITEM_CODE LIKE '%ppp%' and STORE_CODE= ? ";
        
        SQLparams.addElement(new StringValue(storeId));
        
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            
            forQuery.setConnection(connection);
//            forQuery.setSQLQuery(sqlMgr.getSql("getByCode").trim().replaceAll("ppp", number));
            forQuery.setSQLQuery(query.trim().replaceAll("ppp", number));
            forQuery.setparams(SQLparams);
            
            queryResult = forQuery.executeQuery();
            
        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
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
    
     public Vector getSparePartByName(String name) {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        
        Vector SQLparams = new Vector();
        Vector queryResult = null;
        
        String query="select * from DISTRIBUTED_ITEMS where ITEM_DESC LIKE '%ppp%' AND ITEM_DESC IS NOT NULL";
        
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
//            forQuery.setSQLQuery(sqlMgr.getSql("getSparePartByName").trim().replaceAll("ppp", name));
            forQuery.setSQLQuery(query.trim().replaceAll("ppp", name));
            forQuery.setparams(SQLparams);
            
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
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
    
    public Vector getByCode(String number) {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector SQLparams = new Vector();
        Vector queryResult = null;
        
        String query="select * from DISTRIBUTED_ITEMS where ITEM_CODE LIKE '%ppp%'  ";
        
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            
            forQuery.setConnection(connection);
//            forQuery.setSQLQuery(sqlMgr.getSql("getByCode").trim().replaceAll("ppp", number));
            forQuery.setSQLQuery(query.trim().replaceAll("ppp", number));
            forQuery.setparams(SQLparams);
            
            queryResult = forQuery.executeQuery();
            
        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
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
    
    public Vector getAllSpareParts(String storeId) {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector SQLparams = new Vector();
        Vector queryResult = null;
        
        String query="select * from DISTRIBUTED_ITEMS where STORE_CODE= ? AND ITEM_DESC IS NOT NULL";
        
        SQLparams.addElement(new StringValue(storeId));
        
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            
            forQuery.setConnection(connection);
//            forQuery.setSQLQuery(sqlMgr.getSql("getAllSpareParts").trim());
            forQuery.setSQLQuery(query.trim());
            forQuery.setparams(SQLparams);
            
            queryResult = forQuery.executeQuery();
            
        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
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
    
    /****************** End *******************/
    
    /******************* By Elmalik *************************/
    public Vector getStoreParts(String StoreId) {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector SQLparams = new Vector();
        Vector queryResult = null;
        
        String query="SELECT * FROM DISTRIBUTED_ITEMS WHERE STORE_CODE= ? ";
        
        SQLparams.addElement(new StringValue(StoreId));
        
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.trim());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
            
        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
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
    
    public Vector getPartsBySubName(String partName,String StoreId){
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        
        Vector SQLparams = new Vector();
        Vector queryResult = null;
        String query="select * from DISTRIBUTED_ITEMS where STORE_CODE= ? AND ITEM_DESC LIKE '%ppp%'";
        
        SQLparams.addElement(new StringValue(StoreId));
        
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.trim().replaceAll("ppp", partName));
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
            
        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
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

    @Override
    protected void initSupportedQueries() {
    return; //    throw new UnsupportedOperationException("Not supported yet.");
    }
    
    /********************* End ************************/
}
