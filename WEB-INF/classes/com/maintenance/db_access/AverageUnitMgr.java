package com.maintenance.db_access;

import com.contractor.db_access.MaintainableMgr;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import com.silkworm.persistence.relational.StringValue;
import java.sql.SQLException;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.http.HttpSession;
import java.sql.*;
import org.apache.log4j.xml.DOMConfigurator;

public class AverageUnitMgr extends RDBGateWay {
    SqlMgr sqlMgr = SqlMgr.getInstance();
    MaintainableMgr maintainableMgr = MaintainableMgr.getInstance();
    private static AverageUnitMgr averageUnitMgr = new AverageUnitMgr();
    
    private static final String countItemsSQL = "SELECT COUNT(ITEM_CODE) AS total FROM maintenance_item WHERE CATEGORY_ID = ?";
    
    public AverageUnitMgr() {
    }
    
    public static AverageUnitMgr getInstance() {
        logger.info("Getting employeeMgr Instance ....");
        return averageUnitMgr;
    }
    
    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if(supportedForm == null) {
            try {
                supportedForm  = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("average_unit.xml")));
            } catch(Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }
    
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }
    
    public boolean saveObject(WebBusinessObject Average, HttpSession s, long now) throws NoUserInSessionException {
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        
        Vector params = new Vector();
        Vector allReadingUnitparams = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        SQLCommandBean forInsertReadindRate = new SQLCommandBean();
        int queryResult = -1000;
        
        params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue((String)Average.getAttribute("current_Reading")));
        params.addElement(new StringValue((String)Average.getAttribute("current_Reading")));
        params.addElement(new String((String)(Average.getAttribute("date"))));
        params.addElement(new StringValue((String)Average.getAttribute("description")));
        params.addElement(new LongValue(now));
        params.addElement(new StringValue((String)Average.getAttribute("unit")));
        
        allReadingUnitparams.addElement(new StringValue(UniqueIDGen.getNextID()));
        allReadingUnitparams.addElement(new StringValue((String)Average.getAttribute("current_Reading")));
        allReadingUnitparams.addElement(new LongValue(now));
        allReadingUnitparams.addElement(new StringValue((String)Average.getAttribute("description")));
        allReadingUnitparams.addElement(new StringValue((String)Average.getAttribute("unit")));
        String joNumber = (String) Average.getAttribute("joNumber");
        if(joNumber != null){
            allReadingUnitparams.addElement(new StringValue(joNumber));
            forInsertReadindRate.setSQLQuery(sqlMgr.getSql("insertReadingRateUnitWithJO").trim());
        }else{
            forInsertReadindRate.setSQLQuery(sqlMgr.getSql("insertReadingRateUnit").trim());
        }
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertAverageUnitSQL").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            
            forInsertReadindRate.setConnection(connection);
            forInsertReadindRate.setparams(allReadingUnitparams);
            queryResult = forInsertReadindRate.executeUpdate();
            cashData();
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
    
    public boolean saveEquipReading(WebBusinessObject Average, HttpSession s, long now) throws NoUserInSessionException {
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        
        if(Average == null) {
            logger.info("null object is passed");
        } else {
            logger.info("the object is just fine");
        }
        
        Vector params = new Vector();
        Vector allReadingUnitparams = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        
        params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue((String)Average.getAttribute("current_Reading")));
        params.addElement(new StringValue((String)Average.getAttribute("current_Reading")));
        params.addElement(new LongValue(now));
        params.addElement(new StringValue((String)Average.getAttribute("description")));
        params.addElement(new LongValue(now));
        params.addElement(new StringValue((String)Average.getAttribute("unit")));
        
        
        allReadingUnitparams.addElement(new StringValue(UniqueIDGen.getNextID()));
        allReadingUnitparams.addElement(new StringValue((String)Average.getAttribute("current_Reading")));
        allReadingUnitparams.addElement(new LongValue(now));
        allReadingUnitparams.addElement(new StringValue((String)Average.getAttribute("description")));
        allReadingUnitparams.addElement(new StringValue((String)Average.getAttribute("unit")));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertAverageUnitSQL").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            
            forInsert.setSQLQuery(sqlMgr.getSql("insertReadingRateUnit").trim());
            forInsert.setparams(allReadingUnitparams);
            queryResult = forInsert.executeUpdate();
            cashData();
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
    
    public ArrayList getCashedTableAsBusObjects() {
        cashedData = new ArrayList();
        WebBusinessObject wbo = null;
        
        for(int i=0; i<cashedTable.size();i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add(wbo);
        }
        
        return cashedData;
    }
    
    public ArrayList getCashedTableAsArrayList() {
        
        cashedData = new ArrayList();
        WebBusinessObject wbo = null;
        
        for(int i=0; i<cashedTable.size();i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add((String) wbo.getAttribute("empName"));
        }
        
        return cashedData;
    }



    public boolean resetAverage(WebBusinessObject Average, WebBusinessObject updateAverage,String prevDate, long now) {

        Vector params = new Vector();
        Vector allReadingUnitparams = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult1 = -1000;
        int queryResult2 = -1000;
        int currentRead ;
        int currentReadOld=0;
        int total;
        //currentReadOld = new Integer(updateAverage.getAttribute("current_Reading").toString()).intValue();
        total = new Integer(updateAverage.getAttribute("acual_Reading").toString()).intValue();
        currentRead = new Integer(Average.getAttribute("current_Reading").toString()).intValue();


        params.addElement(new IntValue(currentRead));
        params.addElement(new IntValue(currentReadOld));
        params.addElement(new StringValue(""+now));
        params.addElement(new StringValue((String) Average.getAttribute("description")));
        params.addElement(new StringValue(prevDate));
        params.addElement(new StringValue((String) updateAverage.getAttribute("id")));

        allReadingUnitparams.addElement(new StringValue(UniqueIDGen.getNextID()));
        allReadingUnitparams.addElement(new IntValue(currentRead));
        allReadingUnitparams.addElement(new StringValue(""+now));
        allReadingUnitparams.addElement(new StringValue((String)Average.getAttribute("description")));
        allReadingUnitparams.addElement(new StringValue((String)Average.getAttribute("unit")));
        String joNumber = (String) Average.getAttribute("joNumber");
        if(joNumber != null){
            allReadingUnitparams.addElement(new StringValue(joNumber));
            forInsert.setSQLQuery(sqlMgr.getSql("insertReadingRateUnitWithJO").trim());
        }else{
            forInsert.setSQLQuery(sqlMgr.getSql("insertReadingRateUnit").trim());
        }

        //UPDATE average_unit SET CURRENT_READING = ?, ACUAL_READING = ?, ENTRY_TIME = ?, DESCRIPTION = ?, PREVIOUS_TIME = ? WHERE ID = ?
//        }
//        params.addElement(new StringValue((String)employee.getAttribute("employeeId")));

        try {
            /*connection = dataSource.getConnection();
            connection.setAutoCommit(false);*/
            beginTransaction();

            forUpdate.setConnection(transConnection);
            forUpdate.setSQLQuery(sqlMgr.getSql("updateAverageUnitSQL").trim());
            forUpdate.setparams(params);
            queryResult1 = forUpdate.executeUpdate();

            forInsert.setConnection(transConnection);
            forInsert.setparams(allReadingUnitparams);
            queryResult2 = forInsert.executeUpdate();

            //connection.commit();
            endTransaction();
            cashData();
            try {
                Thread.sleep(200);
            } catch (InterruptedException ex) {
                ex.printStackTrace();
            }
        } catch(SQLException se) {
            logger.error(se.getMessage());
        }

        return true;
    }

    public boolean updateAverage(WebBusinessObject Average, WebBusinessObject updateAverage,String prevDate, long now) {
        
        Vector params = new Vector();
        Vector allReadingUnitparams = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult1 = -1000;
        int queryResult2 = -1000;
        int currentRead ;
        int currentReadOld;
        int total;
        currentReadOld = new Integer(updateAverage.getAttribute("current_Reading").toString()).intValue();
        total = new Integer(updateAverage.getAttribute("acual_Reading").toString()).intValue();
        currentRead = new Integer(Average.getAttribute("current_Reading").toString()).intValue();
        
//        if(currentReadOld == 0)
//            currentReadOld = currentRead;
//        if (currentReadOld >= currentRead){
//
//        }else {
//        String unitType= maintainableMgr.getUnitType((String)Average.getAttribute("unit"));
//            if(unitType.equals("fixed")){
           
//            }
//            else if(unitType.equals("odometer")){
//            params.addElement(new IntValue(currentRead-total));
//            params.addElement(new IntValue(currentRead));
//            }
//        params.addElement(new IntValue(currentRead));
//        params.addElement(new IntValue(total+currentRead));
        params.addElement(new IntValue(currentRead));
        params.addElement(new IntValue(currentReadOld));
        params.addElement(new StringValue(""+now));
        params.addElement(new StringValue((String) Average.getAttribute("description")));
        params.addElement(new StringValue(prevDate));
        params.addElement(new StringValue((String) updateAverage.getAttribute("id")));
        
        allReadingUnitparams.addElement(new StringValue(UniqueIDGen.getNextID()));
        allReadingUnitparams.addElement(new IntValue(currentRead));
        allReadingUnitparams.addElement(new StringValue(""+now));
        allReadingUnitparams.addElement(new StringValue((String)Average.getAttribute("description")));
        allReadingUnitparams.addElement(new StringValue((String)Average.getAttribute("unit")));
        String joNumber = (String) Average.getAttribute("joNumber");
        if(joNumber != null){
            allReadingUnitparams.addElement(new StringValue(joNumber));
            forInsert.setSQLQuery(sqlMgr.getSql("insertReadingRateUnitWithJO").trim());
        }else{
            forInsert.setSQLQuery(sqlMgr.getSql("insertReadingRateUnit").trim());
        }

        //UPDATE average_unit SET CURRENT_READING = ?, ACUAL_READING = ?, ENTRY_TIME = ?, DESCRIPTION = ?, PREVIOUS_TIME = ? WHERE ID = ?
//        }
//        params.addElement(new StringValue((String)employee.getAttribute("employeeId")));
                
        try {
            /*connection = dataSource.getConnection();
            connection.setAutoCommit(false);*/
            beginTransaction();

            forUpdate.setConnection(transConnection);
            forUpdate.setSQLQuery(sqlMgr.getSql("updateAverageUnitSQL").trim());
            forUpdate.setparams(params);
            queryResult1 = forUpdate.executeUpdate();
            
            forInsert.setConnection(transConnection);
            forInsert.setparams(allReadingUnitparams);
            queryResult2 = forInsert.executeUpdate();

            //connection.commit();
            endTransaction();
            cashData();
            try {
                Thread.sleep(200);
            } catch (InterruptedException ex) {
                ex.printStackTrace();
            }
        } catch(SQLException se) {
            logger.error(se.getMessage());
        } 
   
        return true;
    }

    public boolean updateAverageUnitUpdateBy(String id, String updateBy, String idBy) {
        int queryResult = -1000;
        SQLCommandBean forUpdate = new SQLCommandBean();
        Vector params = new Vector();
        params.addElement(new StringValue(updateBy));
        params.addElement(new StringValue(id));
        
        if(idBy.equals("unitId")){
            forUpdate.setSQLQuery(sqlMgr.getSql("updateAverageUnitUpdateByWithUnitId").trim());
        } else{
            forUpdate.setSQLQuery(sqlMgr.getSql("updateAverageUnitUpdateBy").trim());
        }

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forUpdate.setConnection(connection);
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();
            
            cashData();
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
    
    public boolean updateAverageConten(WebBusinessObject Average, WebBusinessObject updateAverage,String prevDate, long now,long size) {
        
        Vector params = new Vector();
        Vector allReadingUnitparams = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;
        long currentRead ;
        int currentReadOld;
        int total;
        long counter;
        currentReadOld = new Integer(updateAverage.getAttribute("current_Reading").toString()).intValue();
        total = new Integer(updateAverage.getAttribute("acual_Reading").toString()).intValue();
        currentRead = new Integer(Average.getAttribute("current_Reading").toString()).intValue();
        counter = currentRead*size;
//        if (currentReadOld >= currentRead){
//
//        }else {
        
        params.addElement(new LongValue(currentRead));
        params.addElement(new LongValue(counter+total));
        params.addElement(new LongValue(now));
        params.addElement(new StringValue((String) Average.getAttribute("description")));
        params.addElement(new StringValue(prevDate));
        params.addElement(new StringValue((String) updateAverage.getAttribute("id")));
        
        
        
//        }
//        params.addElement(new StringValue((String)employee.getAttribute("employeeId")));
        
        
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(sqlMgr.getSql("updateAverageUnitSQL").trim());
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();
            
            cashData();
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
    
    public Vector getAllItems(){
        
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        StringBuffer query = new StringBuffer(sqlMgr.getSql("selectAllAverage").trim());

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection= dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            queryResult = forQuery.executeQuery();
            
            
        } catch(SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch(UnsupportedTypeException uste) {
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
    public String getTrueUpdate(String categoryId) {
        
        Vector SQLparams = new  Vector();
        SQLparams.addElement(new StringValue(categoryId));
        
        Connection connection = null;
        String total = null;
        
        StringBuffer query = new StringBuffer(sqlMgr.getSql("getTrueUpdate").trim());
        
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        
        try {
            connection= dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(SQLparams);
            
            queryResult = forQuery.executeQuery();
            
            Row r = null;
            Enumeration e = queryResult.elements();
            
            while(e.hasMoreElements()) {
                r = (Row) e.nextElement();
                total = r.getString(1);
            }
            
        } catch(SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        }
        
        catch(UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } catch(NoSuchColumnException nosuch) {
            logger.error("***** " + nosuch.getMessage());
            return null;
        }
        
        finally {
            try {
                connection.close();
            } catch(SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return null;
            }
        }
        
        return total;
        
    }
    
    public Vector getAllItems(String categoryId){
        Vector SQLparams = new  Vector();
        SQLparams.addElement(new StringValue(categoryId));
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        StringBuffer query = new StringBuffer("SELECT * FROM maintenance_item WHERE CATEGORY_ID = ?");
//        query.append(sSearch);
//        query.append("%'");
        
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
    
    public String getDepartmentId(String department) {
        
        Vector SQLparams = new  Vector();
        SQLparams.addElement(new StringValue(department));
        
        Connection connection = null;
        String departmentId = null;
        
        StringBuffer query = new StringBuffer("SELECT DEPARTMENT_ID FROM department WHERE DEPARTMENT_NAME = ? ");
        
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        
        try {
            connection= dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(SQLparams);
            
            queryResult = forQuery.executeQuery();
            
            Row r = null;
            Enumeration e = queryResult.elements();
            
            while(e.hasMoreElements()) {
                r = (Row) e.nextElement();
                departmentId = r.getString(1);
            }
            
        } catch(SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        }
        
        catch(UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } catch(NoSuchColumnException nosuch) {
            logger.error("***** " + nosuch.getMessage());
            return null;
        }
        
        finally {
            try {
                connection.close();
            } catch(SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return null;
            }
        }
        
        return departmentId;
        
    }
    
    public  boolean getActiveItem(String itemID) throws Exception {
        Vector SQLparams = new  Vector();
        Connection connection = null;
        Vector queryResult = null;
        SQLparams.addElement(new StringValue(itemID));
        SQLCommandBean forQuery = new SQLCommandBean();
        
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery("SELECT * FROM quantified_mntence WHERE ITEM_ID = ?");
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
    
    public  boolean checkDateUnit(String id) throws Exception {
        
        Vector SQLparams = new  Vector();
        Connection connection = null;
        Vector queryResult = null;
        SQLparams.addElement(new StringValue(id));
        SQLCommandBean forQuery = new SQLCommandBean();
        
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("checkDateUnit").trim());
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
    
    public Vector getScheduleByMainType(String categoryId){
        
        Vector SQLparams = new  Vector();
        SQLparams.addElement(new StringValue(categoryId));
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        StringBuffer query = new StringBuffer(sqlMgr.getSql("getScheduleByMainType").trim());
//        query.append(sSearch);
//        query.append("%'");
        
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
    
    public String prevDate(String id) {
        
        Vector SQLparams = new  Vector();
        SQLparams.addElement(new StringValue(id));
        
        Connection connection = null;
        String enteryDate = null;
        
        StringBuffer query = new StringBuffer(sqlMgr.getSql("prevDate").trim());
        
        logger.info(" query :" + query);
        
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        
        try {
            connection= dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(SQLparams);
            
            queryResult = forQuery.executeQuery();
            
            Row r = null;
            Enumeration e = queryResult.elements();
            
            while(e.hasMoreElements()) {
                r = (Row) e.nextElement();
                enteryDate = r.getString(1);
            }
            
        } catch(SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        }
        
        catch(UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } catch(NoSuchColumnException nosuch) {
            logger.error("***** " + nosuch.getMessage());
            return null;
        }
        
        finally {
            try {
                connection.close();
            } catch(SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return null;
            }
        }
        
        return enteryDate;
        
    }
    
    public  boolean checkUnit(String id) throws Exception {
        
        Vector SQLparams = new  Vector();
        Connection connection = null;
        Vector queryResult = null;
        SQLparams.addElement(new StringValue(id));
        SQLCommandBean forQuery = new SQLCommandBean();
        
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("checkUnit").trim());
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
    public Vector getEqpNameCurReading(String id){
        Vector params = new Vector();
        Vector queryResult = null;
        params.addElement(new StringValue(id));
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
           beginTransaction();
            forQuery.setConnection(transConnection);
            forQuery.setSQLQuery(getQuery("updateCurrentReading").trim());
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
            endTransaction();

        } catch(SQLException se) {
            logger.error("database error from getListOnSecondKey: ImageMgr " + se.getMessage());
        } catch(UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        }
        try {
            String eqpCurrentReading = ((Row) queryResult.get(0)).getString("CURRENT_READING");
            String eqpName = ((Row)queryResult.get(0)).getString("UNIT_NAME");
        } catch (NoSuchColumnException ex) {
            Logger.getLogger(AverageUnitMgr.class.getName()).log(Level.SEVERE, null, ex);
        }

        return queryResult;
    }
    public  boolean checkEquipStatus(String id){
        
        Vector SQLparams = new  Vector();
        Connection connection = null;
        Vector queryResult = null;
        SQLparams.addElement(new StringValue(id));
        SQLCommandBean forQuery = new SQLCommandBean();
        
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("checkEquipStatus").trim());
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
    
    public Vector getEquipmentReading(String unitId){
        Vector SQLparams = new  Vector();
        Connection connection = null;
        Vector queryResult = null;
        Vector resultBusObjs = new Vector();
        SQLparams.addElement(new StringValue(unitId));
        SQLCommandBean forQuery = new SQLCommandBean();
        
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getEquipmentReading").trim());
            forQuery.setparams(SQLparams);
            
            queryResult = forQuery.executeQuery();
            
            
        } catch(SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch(UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch(SQLException ex) {
                logger.error("Close Error");
            }
        }
        
        Row r = null;
        WebBusinessObject wbo = null;
        Enumeration e = queryResult.elements();
        while(e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }

    public Connection getDatabaseConnection() throws SQLException{
        return dataSource.getConnection();
    }

    @Override
    protected void initSupportedQueries() {
         queriesIS = metaDataMgr.getQueries(queriesPropFileName);
    return; //    throw new UnsupportedOperationException("Not supported yet.");
    }
    
    
    
}
