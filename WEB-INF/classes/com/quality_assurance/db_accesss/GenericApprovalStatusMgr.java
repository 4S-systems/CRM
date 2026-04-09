
package com.quality_assurance.db_accesss;

import com.silkworm.business_objects.*;


import com.silkworm.business_objects.WebBusinessObject;
import java.sql.SQLException;

import org.apache.log4j.xml.DOMConfigurator;

import java.util.*;
import java.sql.*;
import com.silkworm.persistence.relational.*;


public class GenericApprovalStatusMgr extends RDBGateWay{
    private static GenericApprovalStatusMgr genericApprovalStatusMgr =new GenericApprovalStatusMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();
    
    public GenericApprovalStatusMgr(){}
    
    
     public static GenericApprovalStatusMgr getInstance() {
        logger.info("Getting GenericApprovalStatusMgr Instance ....");
        return genericApprovalStatusMgr;
    }
     protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("generic_approval_status.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }
    

   

    public ArrayList getCashedTableAsArrayList() {
        throw new UnsupportedOperationException("Not supported yet.");
    }
    
    
    public boolean save(String equipmentId, String Status , String note, String type) {

        Vector params = new Vector();
        Vector paramsStatus = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        String ID = UniqueIDGen.getNextID();
        
        
        params.addElement(new StringValue(ID));
        params.addElement(new StringValue(type));
        params.addElement(new StringValue(equipmentId));
        params.addElement(new StringValue(Status));
        params.addElement(new StringValue(note));
        
        
      
        Connection connection = null;
               
          
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertGennricApproval").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            
          
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
                return false;
            }
        }

        return (queryResult > 0);
    }

    
    
    public boolean update(String equipmentId, String Status , String note) {

        Vector params = new Vector();
        Vector paramsStatus = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        params.addElement(new StringValue(Status));
        params.addElement(new StringValue(note));        
        params.addElement(new StringValue(equipmentId));
        
        
      
        Connection connection = null;
               
          
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("updateGennricApproval").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            
          
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
                return false;
            }
        }

        return (queryResult > 0);
    }

    
    
    
    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    protected void initSupportedQueries() {
      return; //  throw new UnsupportedOperationException("Not supported yet.");
    }
    
    
    
    
    
}
