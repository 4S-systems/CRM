package com.maintenance.db_access;

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
//import com.tracker.app_constants.ProjectConstants;

import com.tracker.business_objects.*;
import org.apache.log4j.xml.DOMConfigurator;

public class CategoryMgr extends RDBGateWay {
    SqlMgr sqlMgr = SqlMgr.getInstance();
    private static CategoryMgr categoryMgr = new CategoryMgr();
    
    public static CategoryMgr getInstance() {
        logger.info("Getting CategoryMgr Instance ....");
        return categoryMgr;
    }
    
    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if(supportedForm == null) {
            try {
                supportedForm  = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("item_category.xml")));
            } catch(Exception e) {
                logger.info("Could not locate XML Document");
            }
        }
    }
    
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }
    
    public boolean saveObject(WebBusinessObject category, HttpSession s) throws NoUserInSessionException {
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        
        //params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue((String)category.getAttribute("CatName")));
//        params.addElement(new StringValue((String)waUser.getAttribute("userId")));
        params.addElement(new StringValue((String)category.getAttribute("catDesc")));
        //params.addElement(new StringValue((String)waUser.getAttribute("userId")));
        
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertCatSQL").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            cashData();
        } catch(SQLException se) {
            logger.info(se.getMessage());
            return false;
        } finally {
            try {
                connection.close();
            } catch(SQLException ex) {
                logger.info("Close Error");
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
            cashedData.add((String) wbo.getAttribute("categoryName"));
        }
        
        return cashedData;
    }
    
    public boolean updateCategory(WebBusinessObject wbo){
        Vector params = new Vector();
        
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;
        
        params.addElement(new StringValue((String)wbo.getAttribute("categoryName")));
        params.addElement(new StringValue((String)wbo.getAttribute("catDsc")));
        params.addElement(new StringValue((String)wbo.getAttribute("categoryId")));
        
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(sqlMgr.getSql("updateCatSQL").trim());
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();
            cashData();
        } catch(SQLException se) {
            return false;
        } finally {
            try {
                connection.close();
            } catch(SQLException ex) {
                logger.info("Close Error");
                return false;
            }
        }
        
        return (queryResult > 0);
    }
    
    public Vector getAllCategory(){
        
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        StringBuffer query = new StringBuffer(sqlMgr.getSql("getAllCategory").trim());
//        query.append(sSearch);
//        query.append("%'");
        
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection= dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            queryResult = forQuery.executeQuery();
            
            
        } catch(SQLException se) {
            logger.info("SQL Exception  " + se.getMessage());
        }
        
        catch(UnsupportedTypeException uste) {
            logger.info("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch(SQLException ex) {
                logger.info("Close Error");
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
    
    public String getCategoryId(String categoryName) {
        
        Vector SQLparams = new  Vector();
        SQLparams.addElement(new StringValue(categoryName));
        
        Connection connection = null;
        String categoryId = null;
        
        StringBuffer query = new StringBuffer(sqlMgr.getSql("getCategoryId").trim());
        
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
                categoryId = r.getString(1);
            }
            
        } catch(SQLException se) {
            logger.info("troubles closing connection " + se.getMessage());
            return null;
        }
        
        catch(UnsupportedTypeException uste) {
            logger.info("***** " + uste.getMessage());
            return null;
        } catch(NoSuchColumnException nosuch) {
            logger.info("***** " + nosuch.getMessage());
            return null;
        }
        
        finally {
            try {
                connection.close();
            } catch(SQLException sex) {
                logger.info("troubles closing connection " + sex.getMessage());
                return null;
            }
        }
        
        return categoryId;
        
    }
    
    public  boolean getActiveCategory(String categoryID) throws Exception {
        
        Vector SQLparams = new  Vector();
        Connection connection = null;
        Vector queryResult = null;
        SQLparams.addElement(new StringValue(categoryID));
        SQLCommandBean forQuery = new SQLCommandBean();
        
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getActiveCategory").trim());
            forQuery.setparams(SQLparams);
            
            queryResult = forQuery.executeQuery();
            
            
        } catch(SQLException se) {
            logger.info("database error from getListOnSecondKey: ImageMgr " + se.getMessage());
        } catch(UnsupportedTypeException uste) {
            logger.info("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch(SQLException sex) {
                logger.info("troubles closing connection " + sex.getMessage());
                return false;
            }
        }
        
        return queryResult.size() > 0;
    }
    
    public String getAllCategoryNames() {
        Connection connection = null;
        ResultSet result = null;
        StringBuffer returnSB = null;
        
        try {
            connection= dataSource.getConnection();
            Statement select = connection.createStatement();
            result = select.executeQuery(sqlMgr.getSql("selectAllCategory").trim());
            returnSB = new StringBuffer();
            while (result.next()) {
                returnSB.append(result.getString("unit_name") + ",");
            }
            returnSB.deleteCharAt(returnSB.length() - 1);
        } catch (SQLException e) {
            logger.info(e.toString());
        } finally{
            try {
                connection.close();
            } catch(SQLException sex) {
                logger.info("troubles closing connection " + sex.getMessage());
                return null;
            }
        }
        return returnSB.toString();
    }

    @Override
    protected void initSupportedQueries() {
      return; //  throw new UnsupportedOperationException("Not supported yet.");
    }
}
