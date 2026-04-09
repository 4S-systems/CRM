package com.SpareParts.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.common.MetaDataMgr;
import java.util.*;
import java.sql.*;
import javax.servlet.http.HttpSession;
import org.apache.log4j.xml.DOMConfigurator;

public class SpecsOutTrnsMgr extends RDBGateWay {
    
    private static SpecsOutTrnsMgr specsOutTrnsMgr = new SpecsOutTrnsMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();
    
    public static SpecsOutTrnsMgr getInstance() {
        logger.info("Getting SpecsOutTrnsMgr Instance ....");
        return specsOutTrnsMgr;
    }
    
    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if(supportedForm == null) {
            try {
                supportedForm  = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("specs_out_trns.xml")));
            } catch(Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }
    
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }
    
    public boolean saveObject(Vector wboVec, String update, HttpSession s) throws SQLException {

        Connection connection = null;

        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        try {
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            forInsert.setConnection(connection);

//            if(update.equals("yes")) {
//                forInsert.setSQLQuery(sqlMgr.getSql("updateSpec").trim());
//            } else {
//                forInsert.setSQLQuery(sqlMgr.getSql("insertSpec").trim());
//            }

            WebBusinessObject wbo;
            Vector params = new Vector();
            
            for(int i = 0; i < wboVec.size(); i++) {
                wbo = (WebBusinessObject) wboVec.get(i);
                String updateAction = wbo.getAttribute("update").toString();
                if(updateAction.equals("no")) {
                    forInsert.setSQLQuery(sqlMgr.getSql("insertSpec").trim());
                    params.addElement(new StringValue(UniqueIDGen.getNextID()));
                }else if(updateAction.equals("yes")){
                    forInsert.setSQLQuery(sqlMgr.getSql("updateSpec").trim());
                }
                
                params.addElement(new StringValue((String) wbo.getAttribute("trnsCode")));
                params.addElement(new StringValue((String) wbo.getAttribute("requestType")));
                params.addElement(new StringValue((String) wbo.getAttribute("fromSide")));
                params.addElement(new StringValue((String) wbo.getAttribute("toSide")));

                if(updateAction.equals("yes")) {
                    params.addElement(new StringValue((String) wbo.getAttribute("id")));

                }
                
                forInsert.setparams(params);
                queryResult = forInsert.executeUpdate();
                params.clear();
                
                if(queryResult < 0) {
                    connection.rollback();
                    return false;
                }

                Thread.sleep(100);

            }
 
        } catch (Exception ex) {

            try {
                logger.error(ex.getMessage());
                connection.rollback();
            } catch (SQLException ex1) {
                logger.error(ex1.getMessage());
            }

            return false;
            
        } finally {
            
            try {
                connection.commit();
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        return true;

//        Vector params = new Vector();
//        SQLCommandBean forInsert = new SQLCommandBean();
//        int queryResult = -1000;
//
//        params.addElement(new StringValue(UniqueIDGen.getNextID()));
//        params.addElement(new StringValue((String) wbo.getAttribute("trnsCode")));
//        params.addElement(new StringValue((String) wbo.getAttribute("requestType")));
//        params.addElement(new StringValue((String) wbo.getAttribute("fromSide")));
//        params.addElement(new StringValue((String) wbo.getAttribute("toSide")));
//
//        Connection connection = null;
//
//        try {
//            connection = dataSource.getConnection();
//            forInsert.setConnection(connection);
//            forInsert.setSQLQuery(sqlMgr.getSql("insertSpec").trim());
//            forInsert.setparams(params);
//            queryResult = forInsert.executeUpdate();
//        } catch(SQLException se) {
//            logger.error(se.getMessage());
//            return false;
//        } finally {
//            try {
//                connection.close();
//            } catch(SQLException ex) {
//                logger.error("Close Error");
//                return false;
//            }
//        }
//
//        return (queryResult > 0);
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
     return;//   throw new UnsupportedOperationException("Not supported yet.");
    }

}