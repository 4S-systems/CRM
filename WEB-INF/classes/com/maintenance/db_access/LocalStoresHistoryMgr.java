package com.maintenance.db_access;

import com.maintenance.common.DateParser;
import com.silkworm.jsptags.DropdownDate;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import java.sql.SQLException;
import java.util.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.sql.*;
import org.apache.log4j.xml.DOMConfigurator;

public class LocalStoresHistoryMgr extends RDBGateWay {
    
    private static LocalStoresHistoryMgr localStoresHistoryMgr = new LocalStoresHistoryMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();
    
//    private static final String insertProSQL = "INSERT INTO place VALUES (?,?,?,NOW(),?)";
    public static LocalStoresHistoryMgr getInstance() {
        logger.info("Getting localStoresHistoryMgr Instance ....");
        return localStoresHistoryMgr;
    }
    
    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("local_stores_history.xml")));
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
            cashedData.add(wbo);
        }
        
        return cashedData;
    }
    
    public ArrayList getCashedTableAsArrayList() {
        
        cashedData = new ArrayList();
        WebBusinessObject wbo = null;
        
        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add((String) wbo.getAttribute("itemId"));
        }
        
        return cashedData;
    }
    
    public Vector getListSparePartByDate(HttpServletRequest request) {
        DropdownDate dropdownDate = new DropdownDate();
//        java.sql.Date beginDate = new java.sql.Date(dropdownDate.getDate(request.getParameter("beginDate")).getTime());
//        java.sql.Date endDate = new java.sql.Date(dropdownDate.getDate(request.getParameter("endDate")).getTime());
        
        DateParser dateParser=new DateParser();
        java.sql.Date beginDate=dateParser.formatSqlDate(request.getParameter("beginDate"));
        java.sql.Date endDate=dateParser.formatSqlDate(request.getParameter("endDate"));
        
        Vector SQLparams = new Vector();
        SQLparams.addElement(new DateValue(beginDate));
        SQLparams.addElement(new DateValue(endDate));
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        StringBuffer query = new StringBuffer(sqlMgr.getSql("getListSparePartByDate").trim());
        
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(SQLparams);
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
    
    public String getTotalItemsByDate(String itemId) {
        
        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(itemId));
        
        Connection connection = null;
        String total = null;
        
        StringBuffer query = new StringBuffer(sqlMgr.getSql("getTotalItemsByDate").trim());
        
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
                total = r.getString(1);
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
        
        return total;
        
    }

    @Override
    protected void initSupportedQueries() {
     return; //   throw new UnsupportedOperationException("Not supported yet.");
    }
}
