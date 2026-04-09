package com.maintenance.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import java.sql.SQLException;
import com.silkworm.util.*;
import java.util.*;
import java.text.*;
import java.sql.*;
import com.tracker.common.*;
//import com.tracker.app_constants.ProjectConstants;

import com.tracker.business_objects.*;
import org.apache.log4j.xml.DOMConfigurator;

public class DataBaseControlMgr extends RDBGateWay {
    SqlMgr sqlMgr = SqlMgr.getInstance();
    private static DataBaseControlMgr dataBaseControlMgr = new DataBaseControlMgr();
    
//    private static final String insertfailureSQL = "INSERT INTO failure_code VALUES (?,?,now(),?,?)";
//    private static final String updatefailureSQL = "UPDATE failure_code SET TITLE = ?, CREATION_TIME = now(), CREATED_BY = ?, DESCRIPTION = ?  WHERE ID = ?";
    
    
    public DataBaseControlMgr() {
    }
    
    public static DataBaseControlMgr getInstance() {
        logger.info("Getting DataBaseControlMgr Instance ....");
        return dataBaseControlMgr;
    }
    
    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if(supportedForm == null) {
            try {
                supportedForm  = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("failure_code.xml")));
            } catch(Exception e) {
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
            cashedData.add((String) wbo.getAttribute("title"));
        }
        
        return cashedData;
    }
    
    
    

    
    public  boolean DelAllJobOrder(int i) throws Exception {
        
        Vector SQLparams = new  Vector();
        Connection connection = null;
        Vector queryResult = null;
//        SQLparams.addElement(new StringValue(categoryID));
        SQLCommandBean forQuery = new SQLCommandBean();
        
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("del"+i).trim());
//            forQuery.setparams(SQLparams);
            
            queryResult = forQuery.executeQuery();
            
            
        } catch(SQLException se) {
            logger.error("SQL Exception " + se.getMessage());
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
    
    public  boolean DelScheduleConfigure(int i) throws Exception {
        
        Vector SQLparams = new  Vector();
        Connection connection = null;
        Vector queryResult = null;
//        SQLparams.addElement(new StringValue(categoryID));
        SQLCommandBean forQuery = new SQLCommandBean();
        
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("delconf"+i).trim());
            forQuery.setparams(SQLparams);
            
            queryResult = forQuery.executeQuery();
            
            
        } catch(SQLException se) {
            logger.error("SQL Exception " + se.getMessage());
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
    
    public String getAllUnitSheduleForIssue(String id) {
        
        Vector SQLparams = new  Vector();
        SQLparams.addElement(new StringValue(id));
        
        Connection connection = null;
        String Id = null;
        
        StringBuffer query = new StringBuffer(sqlMgr.getSql("getAllUnitSheduleForIssue").trim());
        
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
                Id = r.getString(1);
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
        
        return Id;
        
    }
    
    public Vector getAllUnitSheduleForEquip(String id){
        
        Vector SQLparams = new  Vector();
        SQLparams.addElement(new StringValue(id));
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        StringBuffer query = new StringBuffer(sqlMgr.getSql("getAllUnitSheduleForEquip").trim());
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
    
    
    public  boolean getEMG(String id) throws Exception {
        
        Vector SQLparams = new  Vector();
        Connection connection = null;
        Vector queryResult = null;
        SQLparams.addElement(new StringValue(id));
        SQLCommandBean forQuery = new SQLCommandBean();
        
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getEMG").trim());
            forQuery.setparams(SQLparams);
            
            queryResult = forQuery.executeQuery();
            
            
        } catch(SQLException se) {
            logger.error("SQL Exception " + se.getMessage());
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
    
    public  boolean DelQuanEmg(String id) throws Exception {
        
        Vector SQLparams = new  Vector();
        Connection connection = null;
        Vector queryResult = null;
        SQLparams.addElement(new StringValue(id));
        SQLCommandBean forQuery = new SQLCommandBean();
        
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("DelQuanEmg").trim());
            forQuery.setparams(SQLparams);
            
            queryResult = forQuery.executeQuery();
            
            
        } catch(SQLException se) {
            logger.error("SQL Exception " + se.getMessage());
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
    public  boolean getDOC(String id) throws Exception {
        
        Vector SQLparams = new  Vector();
        Connection connection = null;
        Vector queryResult = null;
        SQLparams.addElement(new StringValue(id));
        SQLCommandBean forQuery = new SQLCommandBean();
        
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getDOC").trim());             
            forQuery.setparams(SQLparams);
            
            queryResult = forQuery.executeQuery();
            
            
        } catch(SQLException se) {
            logger.error("SQL Exception " + se.getMessage());
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
    
     public  boolean DelDocEmg(String id) throws Exception {
        
        Vector SQLparams = new  Vector();
        Connection connection = null;
        Vector queryResult = null;
        SQLparams.addElement(new StringValue(id));
        SQLCommandBean forQuery = new SQLCommandBean();
        
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("DelDocEmg").trim());
            forQuery.setparams(SQLparams);
            
            queryResult = forQuery.executeQuery();
            
            
        } catch(SQLException se) {
            logger.error("SQL Exception " + se.getMessage());
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
     
     public  boolean DelStatusEmg(String issueId) throws Exception {
        
        Vector SQLparams = new  Vector();
        Connection connection = null;
        Vector queryResult = null;
        SQLparams.addElement(new StringValue(issueId));
        SQLCommandBean forQuery = new SQLCommandBean();
        
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("DelStatusEmg").trim());
            forQuery.setparams(SQLparams);
            
            queryResult = forQuery.executeQuery();
            
            
        } catch(SQLException se) {
            logger.error( "SQL Exception " + se.getMessage());
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
     public  boolean DelIssueEmg(String issueId) throws Exception {
        
        Vector SQLparams = new  Vector();
        Connection connection = null;
        Vector queryResult = null;
         SQLparams.addElement(new StringValue(issueId));
        SQLCommandBean forQuery = new SQLCommandBean();
        
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("DelIssueEmg").trim());
            forQuery.setparams(SQLparams);
            
            queryResult = forQuery.executeQuery();
            
            
        } catch(SQLException se) {
            logger.error("SQL Exception " + se.getMessage());
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
     
     public  boolean DelExternalJob(String issueId) throws Exception {
        
        Vector SQLparams = new  Vector();
        Connection connection = null;
        Vector queryResult = null;
         SQLparams.addElement(new StringValue(issueId));
        SQLCommandBean forQuery = new SQLCommandBean();
        
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("DelExternalJob").trim());
            forQuery.setparams(SQLparams);
            
            queryResult = forQuery.executeQuery();
            
            
        } catch(SQLException se) {
            logger.error("SQL Exception " + se.getMessage());
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
     
     public  boolean DelUnitSchEmg(String issueId) throws Exception {
        
        Vector SQLparams = new  Vector();
        Connection connection = null;
        Vector queryResult = null;
        SQLparams.addElement(new StringValue(issueId));
        
        SQLCommandBean forQuery = new SQLCommandBean();
        
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("DelUnitSchEmg").trim());
            forQuery.setparams(SQLparams);
            
            queryResult = forQuery.executeQuery();
            
            
        } catch(SQLException se) {
            logger.error( "SQL Exception"+se.getMessage());
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
     
      public Vector getIssueEmg(){
        
        Vector SQLparams = new  Vector();
//        SQLparams.addElement(new StringValue(id));
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        StringBuffer query = new StringBuffer(sqlMgr.getSql("getIssueEmg").trim());
//        query.append(sSearch);
//        query.append("%'");
        
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection= dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
//            forQuery.setparams(SQLparams);
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
      
      public  boolean DelAcualEmg(String id) throws Exception {
        
        Vector SQLparams = new  Vector();
        Connection connection = null;
        Vector queryResult = null;
        SQLparams.addElement(new StringValue(id));
        SQLCommandBean forQuery = new SQLCommandBean();
        
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("DelAcualEmg").trim());
            forQuery.setparams(SQLparams);
            
            queryResult = forQuery.executeQuery();
            
            
        } catch(SQLException se) {
            logger.error("SQL Exception" + se.getMessage());
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
      
      ////Begin Function Delete Emergancy Job Order for All Machine ///
      
      public Vector getUnitSchEmg(){
        
//        Vector SQLparams = new  Vector();
//        SQLparams.addElement(new StringValue(id));
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        StringBuffer query = new StringBuffer(sqlMgr.getSql("getUnitSchEmg").trim());
//        query.append(sSearch);
//        query.append("%'");
        
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection= dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
//            forQuery.setparams(SQLparams);
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
      
      public String getUnitSheduleForIssueId(String id) {
        
        Vector SQLparams = new  Vector();
        SQLparams.addElement(new StringValue(id));
        
        Connection connection = null;
        String Id = null;
        
        StringBuffer query = new StringBuffer(sqlMgr.getSql("getUnitSheduleForIssueId").trim());
        
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
                Id = r.getString(1);
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
        
        return Id;
        
    }
      
      /// Begin Functions Delete External Job Order for All Machine ///
       public Vector getUnitSchExr(){
        
//        Vector SQLparams = new  Vector();
//        SQLparams.addElement(new StringValue(id));
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        StringBuffer query = new StringBuffer(sqlMgr.getSql("getUnitSchExr").trim());
//        query.append(sSearch);
//        query.append("%'");
        
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection= dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
//            forQuery.setparams(SQLparams);
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
       public Vector getIssueExr(){
        
        Vector SQLparams = new  Vector();
//        SQLparams.addElement(new StringValue(id));
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        StringBuffer query = new StringBuffer(sqlMgr.getSql("getIssueExr").trim());
//        query.append(sSearch);
//        query.append("%'");
        
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection= dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
//            forQuery.setparams(SQLparams);
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
       
       public  boolean DelStatusExr() throws Exception {
        
//        Vector SQLparams = new  Vector();
        Connection connection = null;
        Vector queryResult = null;

        SQLCommandBean forQuery = new SQLCommandBean();
        
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("DelStatusExr").trim());
//          
            
            queryResult = forQuery.executeQuery();
            
            
        } catch(SQLException se) {
            logger.error( "SQL Exception " + se.getMessage());
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
       
       public  boolean DelIssueExr() throws Exception {
        
        Vector SQLparams = new  Vector();
        Connection connection = null;
        Vector queryResult = null;

        SQLCommandBean forQuery = new SQLCommandBean();
        
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("DelIssueExr").trim());

            
            queryResult = forQuery.executeQuery();
            
            
        } catch(SQLException se) {
            logger.error("SQL Exception " + se.getMessage());
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
       
       public  boolean DelUnitSchExr() throws Exception {
        
//        Vector SQLparams = new  Vector();
        Connection connection = null;
        Vector queryResult = null;

        SQLCommandBean forQuery = new SQLCommandBean();
        
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("DelUnitSchExr").trim());

            
            queryResult = forQuery.executeQuery();
            
            
        } catch(SQLException se) {
            logger.error( "SQL Exception"+se.getMessage());
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
       
      /// End Functions Delete External Job Order for All Machine ///
      
       public  boolean getActiveQuan(String id) throws Exception {
        
        Vector SQLparams = new  Vector();
        Connection connection = null;
        Vector queryResult = null;
        SQLparams.addElement(new StringValue(id));
        SQLCommandBean forQuery = new SQLCommandBean();
        
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getActiveQuan").trim());             
            forQuery.setparams(SQLparams);
            
            queryResult = forQuery.executeQuery();
            
            
        } catch(SQLException se) {
            logger.error("SQL Exception " + se.getMessage());
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
       public  boolean getActiveAcut(String id) throws Exception {
        
        Vector SQLparams = new  Vector();
        Connection connection = null;
        Vector queryResult = null;
        SQLparams.addElement(new StringValue(id));
        SQLCommandBean forQuery = new SQLCommandBean();
        
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getActiveAcut").trim());             
            forQuery.setparams(SQLparams);
            
            queryResult = forQuery.executeQuery();
            
            
        } catch(SQLException se) {
            logger.error("SQL Exception " + se.getMessage());
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
       public  boolean getActiveDocIssue(String id) throws Exception {
        
        Vector SQLparams = new  Vector();
        Connection connection = null;
        Vector queryResult = null;
        SQLparams.addElement(new StringValue(id));
        SQLCommandBean forQuery = new SQLCommandBean();
        
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getActiveDocIssue").trim());             
            forQuery.setparams(SQLparams);
            
            queryResult = forQuery.executeQuery();
            
            
        } catch(SQLException se) {
            logger.error("SQL Exception " + se.getMessage());
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
       public  boolean getActiveIssuestatus(String id) throws Exception {
        
        Vector SQLparams = new  Vector();
        Connection connection = null;
        Vector queryResult = null;
        SQLparams.addElement(new StringValue(id));
        SQLCommandBean forQuery = new SQLCommandBean();
        
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getActiveIssuestatus").trim());             
            forQuery.setparams(SQLparams);
            
            queryResult = forQuery.executeQuery();
            
            
        } catch(SQLException se) {
            logger.error("SQL Exception " + se.getMessage());
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
       public  boolean getActiveIssue(String id) throws Exception {
        
        Vector SQLparams = new  Vector();
        Connection connection = null;
        Vector queryResult = null;
        SQLparams.addElement(new StringValue(id));
        SQLCommandBean forQuery = new SQLCommandBean();
        
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getActiveIssue").trim());             
            forQuery.setparams(SQLparams);
            
            queryResult = forQuery.executeQuery();
            
            
        } catch(SQLException se) {
            logger.error("SQL Exception " + se.getMessage());
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
       
       public  boolean getActiveUnitSchedule(String id) throws Exception {
        
        Vector SQLparams = new  Vector();
        Connection connection = null;
        Vector queryResult = null;
        SQLparams.addElement(new StringValue(id));
        SQLCommandBean forQuery = new SQLCommandBean();
        
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getActiveUnitSchedule").trim());             
            forQuery.setparams(SQLparams);
            
            queryResult = forQuery.executeQuery();
            
            
        } catch(SQLException se) {
            logger.error("SQL Exception " + se.getMessage());
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
       
       ///Begin Delete Schedule Operation after assign job order //
       
        public Vector getUnitSchforUnAssign(){
        
//        Vector SQLparams = new  Vector();
//        SQLparams.addElement(new StringValue(id));
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        StringBuffer query = new StringBuffer(sqlMgr.getSql("getUnitSchforUnAssign").trim());
//        query.append(sSearch);
//        query.append("%'");
        
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection= dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
//            forQuery.setparams(SQLparams);
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
       
       //End Delete Schedule Operation after assign job order //
        
        /// Begin Delete Unassign job Order//
        public  boolean DelStatusUnAssignSch(String id) throws Exception {
        
        Vector SQLparams = new  Vector();
        Connection connection = null;
        Vector queryResult = null;
        SQLparams.addElement(new StringValue(id));
        SQLCommandBean forQuery = new SQLCommandBean();
        
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("DelStatusUnAssignSch").trim());
            forQuery.setparams(SQLparams);
            
            queryResult = forQuery.executeQuery();
            
            
        } catch(SQLException se) {
            logger.error( "SQL Exception " + se.getMessage());
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
        
        public  boolean DelIssueUnAssignSch(String id) throws Exception {
        
        Vector SQLparams = new  Vector();
        Connection connection = null;
        Vector queryResult = null;
        SQLparams.addElement(new StringValue(id));
        SQLCommandBean forQuery = new SQLCommandBean();
        
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("DelIssueUnAssignSch").trim());
            forQuery.setparams(SQLparams);
            
            queryResult = forQuery.executeQuery();
            
            
        } catch(SQLException se) {
            logger.error("SQL Exception " + se.getMessage());
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
        
        public  boolean DelUnitSchIdforUnAssign(String id) throws Exception {
        
        Vector SQLparams = new  Vector();
        Connection connection = null;
        Vector queryResult = null;
        SQLparams.addElement(new StringValue(id));
        SQLCommandBean forQuery = new SQLCommandBean();
        
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("DelUnitSchIdforUnAssign").trim());
            forQuery.setparams(SQLparams);
            
            queryResult = forQuery.executeQuery();
            
            
        } catch(SQLException se) {
            logger.error("SQL Exception " + se.getMessage());
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
        
        public Vector getIssueScheduleTask(){
        
//        Vector SQLparams = new  Vector();
//        SQLparams.addElement(new StringValue(id));
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        StringBuffer query = new StringBuffer(sqlMgr.getSql("getIssueScheduleTask").trim());
//        query.append(sSearch);
//        query.append("%'");
        
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection= dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
//            forQuery.setparams(SQLparams);
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
        ///End Delete Unassign Job Order//
        
        /// Begin Delete EmgTask For Equipment  ///
        
         public String getAllUnitSheduleForEmgIssue(String id) {
        
        Vector SQLparams = new  Vector();
        SQLparams.addElement(new StringValue(id));
        
        Connection connection = null;
        String Id = null;
        
        StringBuffer query = new StringBuffer(sqlMgr.getSql("getAllUnitSheduleForEmgIssue").trim());
        
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
                Id = r.getString(1);
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
        
        return Id;
        
    }
        public Vector getEmgUnitSheduleForEquip(String id){
        
        Vector SQLparams = new  Vector();
        SQLparams.addElement(new StringValue(id));
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        StringBuffer query = new StringBuffer(sqlMgr.getSql("getEmgUnitSheduleForEquip").trim());
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
    
        
        /// End Delete EmgTask For Equipment  ///
        
        /// Begin Delete EmgTask For Equipment  ///
        
         public String getAllUnitSheduleForExrIssue(String id) {
        
        Vector SQLparams = new  Vector();
        SQLparams.addElement(new StringValue(id));
        
        Connection connection = null;
        String Id = null;
        
        StringBuffer query = new StringBuffer(sqlMgr.getSql("getAllUnitSheduleForExrIssue").trim());
        
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
                Id = r.getString(1);
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
        
        return Id;
        
    }
        public Vector getExrUnitSheduleForEquip(String id){
        
        Vector SQLparams = new  Vector();
        SQLparams.addElement(new StringValue(id));
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        StringBuffer query = new StringBuffer(sqlMgr.getSql("getExrUnitSheduleForEquip").trim());
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
    
        
        /// End Delete EmgTask For Equipment  ///
        
        public  boolean GetUnAssignSchId(String unitSchId,String unitId) throws Exception {
        
        Vector SQLparams = new  Vector();
        Connection connection = null;
        Vector queryResult = null;
        SQLparams.addElement(new StringValue(unitSchId));
        SQLparams.addElement(new StringValue(unitId));
        SQLCommandBean forQuery = new SQLCommandBean();
        
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("GetUnAssignSchId").trim());
            forQuery.setparams(SQLparams);
            
            queryResult = forQuery.executeQuery();
            
            
        } catch(SQLException se) {
            logger.error( "SQL Exception " + se.getMessage());
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
        
        public Vector getUnitSheduleForEquipAndTask(String idEquip, String idTask){
        
        Vector SQLparams = new  Vector();
        SQLparams.addElement(new StringValue(idEquip));
        SQLparams.addElement(new StringValue(idTask));
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        StringBuffer query = new StringBuffer(sqlMgr.getSql("getUnitSheduleForEquipAndTask").trim());
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

    @Override
    protected void initSupportedQueries() {
    return; //    throw new UnsupportedOperationException("Not supported yet.");
    }
}
