package com.maintenance.db_access;

import com.maintenance.common.DateParser;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;

import com.silkworm.jsptags.DropdownDate;
import java.util.*;
import java.sql.*;
import javax.servlet.http.HttpServletRequest;
import org.apache.log4j.xml.DOMConfigurator;

public class SupplementMgr extends RDBGateWay {
    private static SupplementMgr supplementMgr = new SupplementMgr();
    
    SqlMgr sqlMgr = SqlMgr.getInstance();
    
    public static SupplementMgr getInstance() {
        logger.info("Getting SupplementMgr Instance ....");
        return supplementMgr;
    }
    
    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if(supportedForm == null) {
            try {
                supportedForm  = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("part_supplement.xml")));
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
    
    public boolean saveObject(HttpServletRequest request) {
        WebBusinessObject waUser = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
        
        Vector params = new Vector();
        Vector paramsUpdate = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        DropdownDate dropdownDate = new DropdownDate();
//        java.sql.Timestamp attachDate = dropdownDate.getDate(request.getParameter("attachDate"));
        
        DateParser dateParser=new DateParser();
        java.sql.Date sqlDate=dateParser.formatSqlDate(request.getParameter("attachDate"));
        java.sql.Timestamp attachDate=new java.sql.Timestamp(sqlDate.getTime());
        String id = UniqueIDGen.getNextID();
        params.addElement(new StringValue(id));
        params.addElement(new StringValue(request.getParameter("equipmentID")));
        params.addElement(new StringValue(request.getParameter("attachEquipment")));
        params.addElement(new TimestampValue(attachDate));
        params.addElement(new StringValue(request.getParameter("notes")));

        paramsUpdate.addElement(new StringValue(id));
        paramsUpdate.addElement(new StringValue(request.getParameter("equipmentID")));
        
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertSupplementSQL").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();

            forInsert.setSQLQuery(sqlMgr.getSql("updateAttachedEquipmentId").trim());
            forInsert.setparams(paramsUpdate);
            queryResult = forInsert.executeUpdate();


            cashData();
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
    
    public boolean separateEquipments(HttpServletRequest request) {
        WebBusinessObject waUser = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
        
        Vector params = new Vector();
        Vector paramsUpdate = new Vector();
        SQLCommandBean forupdate = new SQLCommandBean();
        int queryResult = -1000;
        DropdownDate dropdownDate = new DropdownDate(); 
//        java.sql.Timestamp separateDate = dropdownDate.getDate(request.getParameter("separateDate"));
        
        DateParser dateParser=new DateParser();
        java.sql.Date sqlDate=dateParser.formatSqlDate(request.getParameter("separateDate"));
        java.sql.Timestamp separateDate=new java.sql.Timestamp(sqlDate.getTime());
        
        
        params.addElement(new TimestampValue(separateDate));
//        params.addElement(new StringValue(request.getParameter("notes")));
        params.addElement(new StringValue(request.getParameter("equipmentID")));
        params.addElement(new StringValue(request.getParameter("separateEquipment")));

        paramsUpdate.addElement(new StringValue(request.getParameter("equipmentID")));
        
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forupdate.setConnection(connection);
            forupdate.setSQLQuery(sqlMgr.getSql("separateEquipments").trim());
            forupdate.setparams(params);
            queryResult = forupdate.executeUpdate();

            forupdate.setSQLQuery(sqlMgr.getSql("updateSeparateEquipments").trim());
            forupdate.setparams(paramsUpdate);
            queryResult = forupdate.executeUpdate();


            cashData();
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
    
    public Vector search(String eqID){
        
        Vector params = new Vector();
        SQLCommandBean forupdate = new SQLCommandBean();
        Vector queryResult =new Vector();
        params.addElement(new StringValue(eqID));
        
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forupdate.setConnection(connection);
            forupdate.setSQLQuery(sqlMgr.getSql("searchAttachedEq").trim());
            forupdate.setparams(params);
            queryResult = forupdate.executeQuery();
            cashData();
        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
                return queryResult;
            }
        }
        
        return queryResult;
    }
    
    public Vector searchAllowedEqps(String eqID){
        
        Vector params = new Vector();
        SQLCommandBean forupdate = new SQLCommandBean();
        Vector queryResult =new Vector();
        params.addElement(new StringValue(eqID));
        
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forupdate.setConnection(connection);
            forupdate.setSQLQuery(sqlMgr.getSql("searchAllowedEqps").trim());
            forupdate.setparams(params);
            queryResult = forupdate.executeQuery();
            cashData();
        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
                return queryResult;
            }
        }
        
        return queryResult;
    }
    
    public Vector getAllAttachedEqps(String eqID){
        
        Vector params = new Vector();
        SQLCommandBean forupdate = new SQLCommandBean();
        Vector queryResult =new Vector();
        params.addElement(new StringValue(eqID));
        
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forupdate.setConnection(connection);
            forupdate.setSQLQuery(sqlMgr.getSql("GetAllAttachedEquipment").trim());
            forupdate.setparams(params);
            queryResult = forupdate.executeQuery();
            cashData();
        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
                return queryResult;
            }
        }
        
        Vector reultBusObjs = new Vector();
        
        Row r = null;
        Enumeration e = queryResult.elements();
        
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            reultBusObjs.add(fabricateBusObj(r));
        }
        
        
        return reultBusObjs;
        
    }
    //this get all equipment that attach this equipment
     public Vector getAllSupplementedEqps(String eqID){
        
        Vector params = new Vector();
        SQLCommandBean forupdate = new SQLCommandBean();
        Vector queryResult =new Vector();
        params.addElement(new StringValue(eqID));
        
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forupdate.setConnection(connection);
            forupdate.setSQLQuery(sqlMgr.getSql("GetAllSupplementedEquipment").trim());
            forupdate.setparams(params);
            queryResult = forupdate.executeQuery();
            cashData();
        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
                return queryResult;
            }
        }
        
        Vector reultBusObjs = new Vector();
        
        Row r = null;
        Enumeration e = queryResult.elements();
        
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            reultBusObjs.add(fabricateBusObj(r));
        }
        
        
        return reultBusObjs;
        
    }
    
    
    protected WebBusinessObject fabricateBusObj(Row r) {
        WebBusinessObject wbo=null;
        wbo=super.fabricateBusObj(r);
        Hashtable tab=wbo.getContents();
        int size=tab.size();
        if(size!=6)
        {
            wbo.setAttribute("separation_date","null");
        }
        return wbo;
    }

    @Override
    protected void initSupportedQueries() {
     return; //   throw new UnsupportedOperationException("Not supported yet.");
    }

    
}




