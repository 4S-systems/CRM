/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.tracker.db_access;

import com.silkworm.business_objects.BusinessForm;
import com.silkworm.business_objects.DOMFabricatorBean;
import com.silkworm.business_objects.SqlMgr;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.persistence.relational.NoSuchColumnException;
import com.silkworm.persistence.relational.RDBGateWay;
import com.silkworm.persistence.relational.Row;
import com.silkworm.persistence.relational.SQLCommandBean;
import com.silkworm.persistence.relational.StringValue;
import com.silkworm.persistence.relational.TimestampValue;
import com.silkworm.persistence.relational.UniqueIDGen;
import com.silkworm.persistence.relational.UnsupportedTypeException;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.log4j.xml.DOMConfigurator;

/**
 *
 * @author fatma
 */
public class ProjectEntityMgr extends RDBGateWay{
    private static ProjectEntityMgr projectEntityMgr = new ProjectEntityMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();
    
    public static ProjectEntityMgr getInstance() {
        logger.info("Getting ProjectEntityMgr Instance ....");
        return projectEntityMgr;
    }
    
    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("PROJECT_ENTITY.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }
    
    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }
    
    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
    }
    
    public ArrayList getCashedTableAsArrayList() {
        cashedData = new ArrayList();
        WebBusinessObject wbo = null;
        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add((String) wbo.getAttribute("ENTITY_ID"));
        }

        return cashedData;
    }
    
    public String addEntity(String projectAccId, String entityType, String entityPrice, String entityArea, String usrID) {
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult;
        
        String id = UniqueIDGen.getNextID();
        
        params.addElement(new StringValue(id));
        params.addElement(new StringValue(projectAccId));
        params.addElement(new StringValue(entityType));
        params.addElement(new StringValue(entityPrice));
        params.addElement(new StringValue(entityArea));
        params.addElement(new StringValue(usrID));
        params.addElement(new TimestampValue(new Timestamp(System.currentTimeMillis())));
        try {
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(getQuery("addEntity").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            endTransaction();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return "";
        }
        
        if(queryResult > 0){
            return id;
        } else {
            return "";
        }
    }
    
    public ArrayList<WebBusinessObject> getEntityLst(String projectAccID) throws UnsupportedTypeException{
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector queryResult = null;
        ArrayList resultBusObjs = new ArrayList();
        Row r = null;
        Enumeration e = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();
        
        params.addElement(new StringValue(projectAccID));
        
        String query = getQuery("getEntity").trim();
        forQuery.setparams(params);
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            queryResult = forQuery.executeQuery();
        } catch (Exception ex) {
            logger.error(ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {}
        }
        
        e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            try {
                wbo.setAttribute("entityID", r.getString("ENTITY_ID"));
                wbo.setAttribute("entity", r.getString("ENTITY_TYPE"));
                wbo.setAttribute("price", r.getString("ENTITY_PRICE"));
                wbo.setAttribute("area", r.getString("ENTITY_AREA"));
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(ProjectEntityMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            
            resultBusObjs.add(wbo);
        }
        
        return resultBusObjs;
    }
    
    public boolean updateEntity(String entityID, String entityPrice, String entityArea) {
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult;
        StringBuilder updateAtt = new StringBuilder();
        if(entityPrice != null){
            if (updateAtt.length() > 0){
                updateAtt.append(" , ");
            }
            updateAtt.append(" ENTITY_PRICE = ? ");
            params.addElement(new StringValue(entityPrice));
        }
        
        if(entityArea != null){
            if (updateAtt.length() > 0){
                updateAtt.append(" , ");
            }
            
            updateAtt.append(" ENTITY_AREA = ? ");
            params.addElement(new StringValue(entityArea));
        }
        
        params.addElement(new StringValue(entityID));
        try {
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(getQuery("updateEntity").replaceAll("updateAtt", updateAtt.toString()).trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            endTransaction();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        }
        
        return (queryResult > 0);
    }
    
    public boolean deleteEntity(String entityID) {
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult;
        params.addElement(new StringValue(entityID));
        try {
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(getQuery("daleteEntity").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            endTransaction();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        }
        
        return (queryResult > 0);
    }
    
    public WebBusinessObject getEntityByType(String projectAccID, String type) throws UnsupportedTypeException{
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector queryResult = null;
        Row r = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();
        
        params.addElement(new StringValue(projectAccID));
        params.addElement(new StringValue(type));
        
        String query = getQuery("getEntityByType").trim();
        forQuery.setparams(params);
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            queryResult = forQuery.executeQuery();
        } catch (Exception ex) {
            logger.error(ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {}
        }
        
        wbo = new WebBusinessObject();
        if (!queryResult.isEmpty()) {
            for (int i = 0; i < queryResult.size(); i++){
                r = (Row) queryResult.get(i);
                try {
                    wbo.setAttribute("entityID", r.getString("ENTITY_ID"));

                    if(r.getString("ENTITY_PRICE") == null || r.getString("ENTITY_PRICE").equals("0")){
                         wbo.setAttribute("price", "");
                    } else {
                        wbo.setAttribute("price", r.getString("ENTITY_PRICE"));
                    }

                    if(r.getString("ENTITY_AREA") == null || r.getString("ENTITY_AREA").equals("0")){
                         wbo.setAttribute("area", "");
                    } else {
                        wbo.setAttribute("area", r.getString("ENTITY_AREA"));
                    }
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(ProjectEntityMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
        
        return wbo;
    }
}