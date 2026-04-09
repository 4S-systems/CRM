package com.SpareParts.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.common.MetaDataMgr;
import java.util.*;
import java.sql.*;
import javax.servlet.http.HttpSession;
import org.apache.log4j.xml.DOMConfigurator;

public class ERPStorTrnsMgr extends RDBGateWay {
    
    private static ERPStorTrnsMgr erpStorTrnsMgr = new ERPStorTrnsMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();
    
    public static ERPStorTrnsMgr getInstance() {
        logger.info("Getting ERPStorTrnsMgr Instance ....");
        return erpStorTrnsMgr;
    }
    
    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if(supportedForm == null) {
            try {
                supportedForm  = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("erp_stor_trns.xml")));
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
    
    public Vector getAllTransactionsFromERP() {

        MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
        String userName = metaDataMgr.getStoreErpName();
        String password = metaDataMgr.getStoreErpPassword();
        String driver = metaDataMgr.getDriverErp();
        String URL = metaDataMgr.getDataBaseErpUrl();
        Connection conn = null;

        Vector queryResult = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();

        try{

            Class.forName(driver);
            conn = DriverManager.getConnection(URL, userName, password);
            conn.setAutoCommit(false);
            forUpdate.setConnection(conn);
            forUpdate.setSQLQuery(sqlMgr.getSql("getAllTransactionsFromERP").trim());
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

    public WebBusinessObject getTransTypeFromERP(String transCode) {

        MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
        String userName = metaDataMgr.getStoreErpName();
        String password = metaDataMgr.getStoreErpPassword();
        String driver = metaDataMgr.getDriverErp();
        String URL = metaDataMgr.getDataBaseErpUrl();
        Connection conn = null;
        Vector params = new Vector();
        Vector queryResult = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        params.addElement(new StringValue(transCode));
        try{

            Class.forName(driver);
            conn = DriverManager.getConnection(URL, userName, password);
            conn.setAutoCommit(false);
            forUpdate.setConnection(conn);
            forUpdate.setparams(params);
            forUpdate.setSQLQuery(sqlMgr.getSql("getTransTypeFromERP").trim());
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
       WebBusinessObject wbo=null;
        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
//            resultBusObjs.add(wbo);
        }
        return wbo;

    }

    @Override
    protected void initSupportedQueries() {
       return; // throw new UnsupportedOperationException("Not supported yet.");
    }

}