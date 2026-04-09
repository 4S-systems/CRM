package com.maintenance.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;

import java.util.*;
import java.sql.*;

import javax.servlet.http.HttpSession;

import org.apache.log4j.xml.DOMConfigurator;

public class ConfigureMainTypeMgr extends RDBGateWay {
    SqlMgr sqlMgr = SqlMgr.getInstance();
    private static ConfigureMainTypeMgr configureMainTypeMgr = new ConfigureMainTypeMgr();

    public ConfigureMainTypeMgr() { }
    
    public static ConfigureMainTypeMgr getInstance() {
        logger.info("Getting ConfigureMainTypeMgr Instance ....");
        return configureMainTypeMgr;
    }

    @Override
    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if(supportedForm == null) {
            try {
                supportedForm  = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("eqp_mntnc_type_config.xml")));
            } catch(Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }
    
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public boolean changeConfigStatus(String id) throws SQLException {
        Connection connection = null;
        SQLCommandBean upDate = new SQLCommandBean();
        int queryResult = -1000;
        Vector params = new Vector();
        try {
            connection = dataSource.getConnection();
            upDate.setConnection(connection);
            upDate.setSQLQuery(sqlMgr.getSql("updateConfigUnitSchedule").trim());
            params.addElement(new StringValue(id));
            upDate.setparams(params);
            queryResult = upDate.executeUpdate();
           
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
        params.addElement(new StringValue(hash.get("scheduleId").toString()));
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
            forInsert.setSQLQuery(sqlMgr.getSql("insertConfigureMainType").trim());
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
    
    public  boolean getConfigureSchedule(String periodicID) throws Exception {
        
        Vector SQLparams = new  Vector();
        Connection connection = null;
        Vector queryResult = null;
        SQLparams.addElement(new StringValue(periodicID));
        SQLCommandBean forQuery = new SQLCommandBean();
        
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getConfigureSchedule").trim());
            forQuery.setparams(SQLparams);
            
            queryResult = forQuery.executeQuery();
            
            
        } catch(SQLException se) {
            logger.error("database error from getListOnSecondKey: ImageMgr " + se.getMessage());
        } catch(UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch(SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return false;
            }
        }
        
        return queryResult.size() > 0;
    }
    
    public Vector getConfigItemBySchedule(String scheduleId){
        
        Vector SQLparams = new  Vector();
        SQLparams.addElement(new StringValue(scheduleId));
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        StringBuilder query = new StringBuilder(sqlMgr.getSql("getConfigureSchedule").trim());
        
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection= dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
            
            
        } catch(SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        }
        
        catch(UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch(SQLException ex) {
                logger.error("Close Error");
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
    
    public Vector getAllConfigureMainType() {

        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector SQLparams = new Vector();

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("selectAllConfig").trim());
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
            wbo = (WebBusinessObject) fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }

    public boolean updatePrice(float  price ,String configureMainTypeId) {
        Connection connection = null;
        Vector SQLparams = new Vector();

        SQLparams.addElement(new FloatValue(price));
        SQLparams.addElement(new FloatValue(price));
        SQLparams.addElement(new StringValue(configureMainTypeId));

        int queryResult = -1000;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("updatePriceConfig").trim());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeUpdate();
            Thread.sleep(300);

        } catch (Exception se) {
            logger.error("SQL Exception  " + se.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        return queryResult > 0;
    }

    @Override
    protected void initSupportedQueries() {
       return;//  throw new UnsupportedOperationException("Not supported yet.");
    }

}
