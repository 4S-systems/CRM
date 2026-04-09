package com.maintenance.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.tracker.db_access.IssueMgr;
import java.util.*;
import javax.servlet.http.HttpSession;
import java.sql.*;

import javax.swing.JOptionPane;
import org.apache.log4j.xml.DOMConfigurator;

public class UnitScheduleHistoryMgr extends RDBGateWay {

    SqlMgr sqlMgr = SqlMgr.getInstance();
    private String uinqueID = null;
    private String ScheduleUnitId = null;
    private static UnitScheduleHistoryMgr unitScheduleHistoryMgr = new UnitScheduleHistoryMgr();

    public static UnitScheduleHistoryMgr getInstance() {
        logger.info("Getting UnitScheduleHistoryMgr Instance ....");
        return unitScheduleHistoryMgr;
    }

    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("unit_schedule_history.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    

    

    public ArrayList getCashedTableAsBusObjects() {
        cashedData = new ArrayList();
        WebBusinessObject wbo = null;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add((String) wbo.getAttribute("unitName"));
        }

        return cashedData;
    }

    public ArrayList getCashedTableAsArrayList() {

        cashedData = new ArrayList();
        WebBusinessObject wbo = null;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add((String) wbo.getAttribute("unitName"));
        }

        return cashedData;
    }

     public String saveInHistoryUnitSchedule(WebBusinessObject schedule, WebBusinessObject average, HttpSession s, int rateNo){
        IssueMgr issueMgr = IssueMgr.getInstance();
        Vector unitScheduleParams = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        
        
        String unitName = null;
        unitName = issueMgr.getEquipName(average.getAttribute("unitName").toString());
        
        ScheduleUnitId = UniqueIDGen.getNextID().toString();
        unitScheduleParams.addElement(new StringValue(ScheduleUnitId));
        unitScheduleParams.addElement(new StringValue((String) average.getAttribute("unitName")));
        unitScheduleParams.addElement(new StringValue(unitName));
        unitScheduleParams.addElement(new StringValue((String) schedule.getAttribute("periodicID")));
        unitScheduleParams.addElement(new StringValue((String) schedule.getAttribute("maintenanceTitle")));
        unitScheduleParams.addElement(new StringValue((String) Integer.toString(rateNo)));
        
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            
            forInsert.setSQLQuery(sqlMgr.getSql("insertHistoryIssueUnitSchedule").trim());
            forInsert.setparams(unitScheduleParams);
            queryResult = forInsert.executeUpdate();
            
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } //catch(InterruptedException e){
        //    }
        finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }
        String saveStatus="saveFail";
        if(queryResult > 0)
            return ScheduleUnitId;
        else
            return saveStatus;
        
    }
   
public boolean checkScheduleExist(String unitId,String scheduleId) throws java.sql.SQLException {
        
        StringValue stimeStamp = new StringValue(UniqueIDGen.getNextID());
         
        Vector params = new Vector();
        SQLCommandBean forDelete = new SQLCommandBean();
        int queryResult = -1000;
        
        params.addElement(new StringValue(unitId));
        params.addElement(new StringValue(scheduleId));
        Connection connection = dataSource.getConnection();
        SQLCommandBean forInsert = new SQLCommandBean();
     
        
        try {
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("checkScheduleExist").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            
        connection.close();
            
         } catch (SQLException se) {
            logger.error("SQL - Exception "+se.getMessage());
        }
        return queryResult > 0;
    }
    public boolean ViewSchedule(String unitId,String scheduleId) throws java.sql.SQLException {
        Vector params = new Vector();
        int queryResult = -1000;

        params.addElement(new StringValue(unitId));
        params.addElement(new StringValue(scheduleId));
        Connection connection = dataSource.getConnection();
        SQLCommandBean forInsert = new SQLCommandBean();


        try {
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("viewSchedule").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();

        connection.close();

         } catch (SQLException se) {
            logger.error("SQL - Exception "+se.getMessage());
            JOptionPane.showMessageDialog(null, se.getMessage());
        }
        return queryResult > 0;
    }


public boolean updateScheduleExist(String unitId,String scheduleId, int rateNo) throws java.sql.SQLException {
        
        StringValue stimeStamp = new StringValue(UniqueIDGen.getNextID());
        
        Vector params = new Vector();
        SQLCommandBean forDelete = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue(Integer.toString(rateNo)));
        params.addElement(new StringValue(unitId));
        params.addElement(new StringValue(scheduleId));
        
        Connection connection = dataSource.getConnection();
        SQLCommandBean forInsert = new SQLCommandBean();
        try {
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("updateScheduleExist").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            
        connection.close();
            
         } catch (SQLException se) {
            logger.error("SQL - Exception "+se.getMessage());
        }
        return queryResult > 0;
    }

    public boolean updateCancelRate(String id){

        Vector params = new Vector();
        int queryResult = -1000;

        params.addElement(new StringValue(id));

        Connection connection = null;
        SQLCommandBean forInsert = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("updateCancelRate").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();

            connection.close();

         } catch (SQLException se) {
            logger.error("SQL - Exception "+se.getMessage());
        }
        return queryResult > 0;
    }

    public boolean updateJobOrderRate(String id){

        Vector params = new Vector();
        int queryResult = -1000;

        params.addElement(new StringValue(id));

        Connection connection = null;
        SQLCommandBean forInsert = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("updateJobOrderRate").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();

            connection.close();

         } catch (SQLException se) {
            logger.error("SQL - Exception "+se.getMessage());
        }
        return queryResult > 0;
    }
  
public boolean updateScheduleRateAndReading(String unitId,String scheduleId ,int rateNo ,String currentReading) throws java.sql.SQLException {
        
        StringValue stimeStamp = new StringValue(UniqueIDGen.getNextID());
        
        Vector params = new Vector();
        SQLCommandBean forDelete = new SQLCommandBean();
        int queryResult = -1000;
       
        params.addElement(new StringValue(String.valueOf(rateNo)));
        params.addElement(new StringValue(currentReading));
        params.addElement(new StringValue(unitId));
        params.addElement(new StringValue(scheduleId));
        
        
    
        Connection connection = dataSource.getConnection();
        SQLCommandBean forInsert = new SQLCommandBean();
        try {
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("updateScheduleRateAndReading").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            
        connection.close();
            
         } catch (SQLException se) {
            logger.error("SQL - Exception "+se.getMessage());
        }
        return queryResult > 0;
    }

public String getScheduleRateId(String unitId,String scheduleId) {
        
        Vector SQLparams = new Vector();
        
        SQLparams.addElement(new StringValue(unitId));
        SQLparams.addElement(new StringValue(scheduleId));
        
        Connection connection = null;
        String scheduleRateId = null;
        
        StringBuffer query = new StringBuffer(sqlMgr.getSql("getScheduleRateId").trim());
        
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(SQLparams);
            
            queryResult = forQuery.executeQuery();
            
            Row r = null;
            Enumeration e = queryResult.elements();
            
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                scheduleRateId = r.getString(1);
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
        
        return scheduleRateId;
        
    }
  
public Vector getScheduleCanView(String unitId) {
        
        Vector SQLparams = new Vector();
        
        SQLparams.addElement(new StringValue(unitId));
        
        Connection connection = null;
        
        StringBuffer query = new StringBuffer(sqlMgr.getSql("selectAllSchduleCanView").trim());
        
        Vector queryResult = null;
        Vector queryAsBus = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(SQLparams);
            
            queryResult = forQuery.executeQuery();
            
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return null;
            }
        }

        WebBusinessObject wbo;
        Row row;

        for (int i = 0; i < queryResult.size(); i++) {
           row = (Row) queryResult.get(i);
           wbo = fabricateBusObj(row);
           queryAsBus.add(wbo);
        }
        
        return queryAsBus;
        
    }

public Vector getAllEquipmentsUnderSchedule(String scheduleId) {
        
        Vector SQLparams = new Vector();
        
        SQLparams.addElement(new StringValue(scheduleId));
        
        Connection connection = null;
        
        StringBuffer query = new StringBuffer(sqlMgr.getSql("getAllEquipmentsUnderSchedule").trim());
        
        Vector queryResult = null;
        Vector queryAsBus = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(SQLparams);
            
            queryResult = forQuery.executeQuery();
            
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return null;
            }
        }

        WebBusinessObject wbo;
        Row row;

        for (int i = 0; i < queryResult.size(); i++) {
           row = (Row) queryResult.get(i);
           wbo = fabricateBusObj(row);
           queryAsBus.add(wbo);
        }
        
        return queryAsBus;
        
    }

    public String getPeriodicId(String unitScheduleHistoryId) {
        String periodicId = null;
        WebBusinessObject wbo = UnitScheduleHistoryMgr.unitScheduleHistoryMgr.getOnSingleKey(unitScheduleHistoryId);

        if(wbo != null) {
            periodicId = (String) wbo.getAttribute("periodicId");
        }

        return periodicId;
    }

    @Override
    protected void initSupportedQueries() {
    return; //    throw new UnsupportedOperationException("Not supported yet.");
    }

}
