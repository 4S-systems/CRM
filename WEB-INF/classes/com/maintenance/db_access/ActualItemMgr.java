package com.maintenance.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import java.sql.SQLException;
import java.util.*;
import java.sql.*;
import javax.servlet.http.HttpSession;
import org.apache.log4j.xml.DOMConfigurator;

public class ActualItemMgr extends RDBGateWay {
    private static ActualItemMgr actualItemMgr = new ActualItemMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();
    
    public static ActualItemMgr getInstance() {
        logger.info("Getting ActualItemMgr Instance ....");
        return actualItemMgr;
    }
    
    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if(supportedForm == null) {
            try {
                supportedForm  = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("actual_item.xml")));
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
            forInsert.setSQLQuery(sqlMgr.getSql("insertActualItem").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
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
    
    public ArrayList getCashedTableAsArrayList() {
        
        cashedData = new ArrayList();
        WebBusinessObject wbo = null;
        
        for(int i=0; i<cashedTable.size();i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add((String) wbo.getAttribute("id"));
        }
        
        return cashedData;
    }
    
    public Vector getActualItemSchedule(String Id){
        
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector SQLparams = new Vector();
        
        SQLparams.addElement(new StringValue(Id));
        
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection= dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getActualItemSchedule").trim());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
            
            
        } catch(SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        }
        
        catch(UnsupportedTypeException uste) {
            logger.error(uste.getMessage());
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
            wbo = (WebBusinessObject) fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }

    @Override
    protected void initSupportedQueries() {
     return;//   throw new UnsupportedOperationException("Not supported yet.");
    }
}
