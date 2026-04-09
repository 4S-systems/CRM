package com.maintenance.db_access;

import com.maintenance.common.DateParser;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;

import com.silkworm.jsptags.DropdownDate;
import java.sql.SQLException;
import java.util.*;
import java.sql.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import org.apache.log4j.xml.DOMConfigurator;

public class DriversHistoryMgr extends RDBGateWay {
    private static DriversHistoryMgr driversHistoryMgr = new DriversHistoryMgr();
    
    SqlMgr sqlMgr = SqlMgr.getInstance();
    EmpBasicMgr  empBasicMgr = EmpBasicMgr.getInstance();
    
    public static DriversHistoryMgr getInstance() {
        logger.info("Getting driversHistoryMgr Instance ....");
        return driversHistoryMgr;
    }
    
    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if(supportedForm == null) {
            try {
                supportedForm  = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("drivers_history.xml")));
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
    
    public boolean saveObject(HttpServletRequest request, HttpSession s) {
        WebBusinessObject waUser = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
        
        Vector params = new Vector();
        Vector maintainableParams = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
//        DropdownDate dropdownDate = new DropdownDate();
//        java.sql.Timestamp attachDate = dropdownDate.getDate(request.getParameter("attachDate"));
        WebBusinessObject wboEmp = empBasicMgr.getOnSingleKey(request.getParameter("attachDriver").toString());
        String empName = wboEmp.getAttribute("empName").toString();
        
        
        //Get expected begin and end date
        String bDate = request.getParameter("attachDate");
        
//        String []beDate = bDate.split("/");
//        String []eEDate = bDate.split("/");
//
//        int bYear=Integer.parseInt(beDate[2]);
//        int bMonth=Integer.parseInt(beDate[0]);
//        int bDay=Integer.parseInt(beDate[1]);
//
//        int eYear=Integer.parseInt(eEDate[2]);
//        int eMonth=Integer.parseInt(eEDate[0]);
//        int eDay=Integer.parseInt(eEDate[1]);
//
//        java.sql.Date beginD = new java.sql.Date(bYear-1900,bMonth-1,bDay);
//        java.sql.Date eEginD = new java.sql.Date(eYear-1900,eMonth-1,eDay);
        
        DateParser dateParser=new DateParser();
        java.sql.Date beginD=dateParser.formatSqlDate(bDate);
        java.sql.Date eEginD=dateParser.formatSqlDate(bDate);
        
        java.sql.Timestamp attachDate = new java.sql.Timestamp(beginD.getTime());
        java.sql.Timestamp endAttachDate = new java.sql.Timestamp(eEginD.getTime());
        
        params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue(request.getParameter("equipmentID")));
        params.addElement(new StringValue(request.getParameter("attachDriver")));
        params.addElement(new TimestampValue(attachDate));
        params.addElement(new StringValue(request.getParameter("notes")));
        params.addElement(new StringValue((String) waUser.getAttribute("userId")));
        params.addElement(new StringValue(empName));
        
        maintainableParams.addElement(new StringValue(request.getParameter("attachDriver")));
        maintainableParams.addElement(new StringValue(request.getParameter("equipmentID")));
        
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertDriversSQL").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            if(queryResult==1){
                forInsert.setSQLQuery(sqlMgr.getSql("updateMaintainableDriver").trim());
                forInsert.setparams(maintainableParams);
                queryResult = forInsert.executeUpdate();
            }
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
    
    public boolean updateDriverHistory(HttpServletRequest request,String id, HttpSession s) {
        
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        
        Vector params = new Vector();
        Vector InsertDriverparams = new Vector();
        
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;
        DropdownDate dropdownDate = new DropdownDate();
//        java.sql.Timestamp attachDate = dropdownDate.getDate(request.getParameter("attachEndDate"));
        
        DateParser dateParser=new DateParser();
        java.sql.Date sqlDate=dateParser.formatSqlDate(request.getParameter("attachEndDate"));
        java.sql.Timestamp attachDate=new java.sql.Timestamp(sqlDate.getTime());
        
//        java.sql.Timestamp attachAnotherDate = dropdownDate.getDate(request.getParameter("attachAnotherDate"));
        
        params.addElement(new TimestampValue(attachDate));
        params.addElement(new StringValue(id));
        
//        InsertDriverparams.addElement(new StringValue(UniqueIDGen.getNextID()));
//        InsertDriverparams.addElement(new StringValue(request.getParameter("equipmentID")));
//        InsertDriverparams.addElement(new StringValue(request.getParameter("attachAnotherDriver")));
//        InsertDriverparams.addElement(new TimestampValue(attachAnotherDate));
//        InsertDriverparams.addElement(new StringValue(request.getParameter("notes")));
//        InsertDriverparams.addElement(new StringValue((String) waUser.getAttribute("userId")));
//
        
        
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(sqlMgr.getSql("updateDriverHistory").trim());
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
    
    
    public boolean getAttachDriver(String unitId) throws Exception {
        
        Vector SQLparams = new Vector();
        Connection connection = null;
        Vector queryResult = null;
        SQLparams.addElement(new StringValue(unitId));
        SQLCommandBean forQuery = new SQLCommandBean();
        
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getAttachDriver").trim());
            forQuery.setparams(SQLparams);
            
            queryResult = forQuery.executeQuery();
            
            
        } catch (SQLException se) {
            logger.error("database error from getListOnSecondKey: ImageMgr " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return false;
            }
        }
        
        return queryResult.size() > 0;
    }
    
    public String getDriverHistoryId(String unitId) {
        
        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(unitId));
        
        Connection connection = null;
        String Id = null;
        
        StringBuffer query = new StringBuffer(sqlMgr.getSql("getDriverHistoryId").trim());
        
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
                Id = r.getString(1);
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
        
        return Id;
        
    }

    @Override
    protected void initSupportedQueries() {
     return; //   throw new UnsupportedOperationException("Not supported yet.");
    }
    
}
