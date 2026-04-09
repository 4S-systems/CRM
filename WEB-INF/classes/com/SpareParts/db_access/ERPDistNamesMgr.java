package com.SpareParts.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.common.MetaDataMgr;
import java.util.*;
import java.sql.*;
import javax.servlet.http.HttpSession;
import org.apache.log4j.xml.DOMConfigurator;

public class ERPDistNamesMgr extends RDBGateWay {
    
    private static ERPDistNamesMgr erpDistNamesMgr = new ERPDistNamesMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();
    
    public static ERPDistNamesMgr getInstance() {
        logger.info("Getting ERPDistNamesMgr Instance ....");
        return erpDistNamesMgr;
    }
    
    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if(supportedForm == null) {
            try {
                supportedForm  = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("erp_dist_names.xml")));
            } catch(Exception e) {
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
            cashedData.add((String) wbo.getAttribute("id"));
        }
        
        return cashedData;
    }
    
    public boolean getDepartmentsByCodeFromERP(String depCode) {

        MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
        String userName = metaDataMgr.getStoreErpName();
        String password = metaDataMgr.getStoreErpPassword();
        String driver = metaDataMgr.getDriverErp();
        String URL = metaDataMgr.getDataBaseErpUrl();
        Connection conn = null;

        Vector SQLparams = new Vector();
        Vector queryResult = new Vector();

        SQLparams.addElement(new StringValue(depCode));

        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            Class.forName(driver);
            conn = DriverManager.getConnection(URL, userName, password);
            conn.setAutoCommit(false);
            forQuery.setConnection(conn);
            forQuery.setparams(SQLparams);
            forQuery.setSQLQuery(sqlMgr.getSql("getDepartmentsByCodeFromERP").trim());
            queryResult = forQuery.executeQuery();


        } catch (Exception se) {
            logger.error("database error " + se.getMessage());
        }finally {
            try {
                conn.commit();
                conn.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return false;
            }
        }

        return queryResult.size() > 0;
    }
    
    public boolean getStoresByCodeFromERP(String storeCode) {

        MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
        String userName = metaDataMgr.getStoreErpName();
        String password = metaDataMgr.getStoreErpPassword();
        String driver = metaDataMgr.getDriverErp();
        String URL = metaDataMgr.getDataBaseErpUrl();
        Connection conn = null;

        Vector SQLparams = new Vector();
        Vector queryResult = new Vector();

        SQLparams.addElement(new StringValue(storeCode));

        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            Class.forName(driver);
            conn = DriverManager.getConnection(URL, userName, password);
            conn.setAutoCommit(false);
            forQuery.setConnection(conn);
            forQuery.setparams(SQLparams);
            forQuery.setSQLQuery(sqlMgr.getSql("getStoresByCodeFromERP").trim());
            queryResult = forQuery.executeQuery();


        } catch (Exception se) {
            logger.error("database error " + se.getMessage());
        }finally {
            try {
                conn.commit();
                conn.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return false;
            }
        }

        return queryResult.size() > 0;
    }

    public Vector getDestinationByType(String type) {

        MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
        String userName = metaDataMgr.getStoreErpName();
        String password = metaDataMgr.getStoreErpPassword();
        String driver = metaDataMgr.getDriverErp();
        String URL = metaDataMgr.getDataBaseErpUrl();
        Vector params = new Vector();
        Connection conn = null;

        Vector queryResult = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        params.addElement(new StringValue(type));
        try{

            Class.forName(driver);
            conn = DriverManager.getConnection(URL, userName, password);
            conn.setAutoCommit(false);
            forUpdate.setConnection(conn);
            forUpdate.setparams(params);
            forUpdate.setSQLQuery(getQuery("getDestinationByType").trim());
            queryResult = forUpdate.executeQuery();
        } catch (Exception se) {
            logger.error(se.getMessage());
        } finally {
            try {
                conn.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

       Vector resultBusObjs = new Vector();
       WebBusinessObject wbo;
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
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
         return;
    }

}