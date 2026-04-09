package com.maintenance.db_access;

import com.maintenance.common.DateParser;
import com.silkworm.jsptags.DropdownDate;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import java.sql.SQLException;
import com.silkworm.util.*;
import java.util.*;
import java.text.*;
import javax.servlet.http.HttpSession;
import java.sql.*;
import com.tracker.common.*;
import com.tracker.business_objects.*;
import org.apache.log4j.xml.DOMConfigurator;

public class EquipmentStatusMgr extends RDBGateWay {
    
    private static EquipmentStatusMgr equipmentStatusMgr = new EquipmentStatusMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();
    
    public EquipmentStatusMgr() {
    }
    
    public static EquipmentStatusMgr getInstance() {
        logger.info("Getting EquipmentStatusMgr Instance ....");
        return equipmentStatusMgr;
    }
    
    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("equipment_status.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }
    
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }
    
    public boolean saveObject(WebBusinessObject equipmentStatusWbo, HttpSession s) throws NoUserInSessionException {
        //Define variables
        Vector stateParams = new Vector();
        Vector updateStatusParams = new Vector();
        Vector updateEquipSatusParams = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        
        //Get logged user
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        
        //Get expected begin date
        String bDate = equipmentStatusWbo.getAttribute("beginDate").toString();
        String hour = equipmentStatusWbo.getAttribute("hour").toString();
        String min = equipmentStatusWbo.getAttribute("minute").toString();
        
//        String []beDate = bDate.split("/");
//
//        int bYear=Integer.parseInt(beDate[2]);
//        int bMonth=Integer.parseInt(beDate[0]);
//        int bDay=Integer.parseInt(beDate[1]);
        
        int h=Integer.parseInt(hour);
        int m=Integer.parseInt(min);
        
//        java.util.Date beginDate = new java.util.Date(bYear-1900,bMonth-1,bDay,h,m);
        DateParser dateParser=new DateParser();
        java.util.Date beginDate=dateParser.formatUtilDate(bDate,h,m);
        
        //Set Params
        stateParams.addElement(new StringValue(UniqueIDGen.getNextID()));
        stateParams.addElement(new StringValue((String) equipmentStatusWbo.getAttribute("equipmentID")));
        stateParams.addElement(new StringValue((String) equipmentStatusWbo.getAttribute("stateID")));
        stateParams.addElement(new TimestampValue(new java.sql.Timestamp(beginDate.getTime())));
        stateParams.addElement(new StringValue(null));
        stateParams.addElement(new StringValue((String) waUser.getAttribute("userId")));
        stateParams.addElement(new StringValue((String) equipmentStatusWbo.getAttribute("note")));
        
        updateStatusParams.addElement(new TimestampValue(new java.sql.Timestamp(beginDate.getTime())));
        updateStatusParams.addElement(new StringValue((String) equipmentStatusWbo.getAttribute("equipmentID")));
        
        updateEquipSatusParams.addElement(new StringValue((String) equipmentStatusWbo.getAttribute("stateID")));
        updateEquipSatusParams.addElement(new TimestampValue(new java.sql.Timestamp(beginDate.getTime())));
        updateEquipSatusParams.addElement(new StringValue((String) equipmentStatusWbo.getAttribute("equipmentID")));
        
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            
            //update equipment current status record
            forInsert.setSQLQuery(sqlMgr.getSql("updateStatusEndDateSql").trim());
            forInsert.setparams(updateStatusParams);
            queryResult = forInsert.executeUpdate();
            
            //insert new equipment status record
            forInsert.setSQLQuery(sqlMgr.getSql("insertEquipmentStatusSql").trim());
            forInsert.setparams(stateParams);
            queryResult = forInsert.executeUpdate();
            cashData();
            
            //update maintainable_unit status col
            forInsert.setSQLQuery(sqlMgr.getSql("updateEquipmentStatusSql").trim());
            forInsert.setparams(updateEquipSatusParams);
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
    
    public WebBusinessObject getLastStatus(String equipmentID) {
        Connection connection = null;
        
        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(equipmentID));
        
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getLastEquipmentStatusSQL").trim());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } catch (Exception exception) {
            logger.error("An exception has been thrown " + exception.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }
        
        Row r = null;
        Enumeration e = queryResult.elements();
        WebBusinessObject wbo = null;
        
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = (WebBusinessObject) fabricateBusObj(r);
        }
        
        return wbo;
    }
    
    public ArrayList getCashedTableAsBusObjects() {
        cashedData = new ArrayList();
        WebBusinessObject wbo = null;
        
        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add(wbo);
        }
        
        return cashedData;
    }
    
    public ArrayList getCashedTableAsArrayList() {
        
        cashedData = new ArrayList();
        WebBusinessObject wbo = null;
        
        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add((String) wbo.getAttribute("name"));
        }
        
        return cashedData;
    }
    
    public boolean updateState(WebBusinessObject wbo) {
        
        Vector params = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;
        
        
        params.addElement(new StringValue((String) wbo.getAttribute("name")));
        params.addElement(new StringValue((String) wbo.getAttribute("note")));
        params.addElement(new StringValue((String) wbo.getAttribute("id")));
        
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(sqlMgr.getSql("updateEqStateTypeSql").trim());
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();
            
            cashData();
        } catch (SQLException se) {
            
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
    public boolean updateStateByUnit(String unitId,Timestamp siteEntryDate) {
        
        Vector params = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;
        
        
        
        params.addElement(new TimestampValue(siteEntryDate));
        params.addElement(new StringValue(unitId));
        
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(sqlMgr.getSql("updateStateByUnit").trim());
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();
            
            cashData();
        } catch (SQLException se) {
            
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
    
        
    public Vector getStatusHistory(String equipmentID) {
        
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        StringBuffer query = new StringBuffer(sqlMgr.getSql("getStatusHistorySql").trim());
        Vector params = new Vector();
        params.addElement(new StringValue(equipmentID));
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(params);
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
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }

    public Vector getEquipStatusHistory(String equipmentId) {

        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        StringBuffer query = new StringBuffer(sqlMgr.getSql("getEquipStatusHistory").trim());
        Vector params = new Vector();
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        
        params.addElement(new StringValue(equipmentId));

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(params);
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
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }

        return resultBusObjs;
    }
    
    public boolean getStatusUnit(String unitId) {
        Connection connection = null;
        
        Vector SQLparams = new Vector();
        
        SQLparams.addElement(new StringValue(unitId));
        
        
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setparams(SQLparams);
            forQuery.setSQLQuery(sqlMgr.getSql("getStatusUnit").trim());
            
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } catch (Exception exception) {
            logger.error("An exception has been thrown " + exception.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }
        return queryResult.size() > 0;
    }
    
    public String getStatusDateTime(String eqpId) {
        //Define Variables
        String result = null;
        
        Vector SQLparams = new Vector();
        Vector queryResult = null;
        
        Connection connection = null;
        
        SQLCommandBean forQuery = new SQLCommandBean();
        
        //Set Params
        SQLparams.addElement(new StringValue(eqpId));
        
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getEqpStatueDateTime").trim());
            forQuery.setparams(SQLparams);
            
            queryResult = forQuery.executeQuery();
            
            Row r = null;
            Enumeration e = queryResult.elements();
            
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                result = r.getString(1);
            }
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } catch (NoSuchColumnException nosuch) {
            logger.error("***** " + nosuch.getMessage());
            return null;
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return null;
            }
        }
        return result;
    }

    @Override
    protected void initSupportedQueries() {
    return;//     throw new UnsupportedOperationException("Not supported yet.");
    }
}
