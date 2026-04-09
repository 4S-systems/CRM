package com.maintenance.db_access;

import com.maintenance.common.DateParser;
import com.silkworm.jsptags.DropdownDate;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import java.sql.SQLException;
import java.util.*;
import javax.servlet.http.HttpServletRequest;
import java.sql.*;
import org.apache.log4j.xml.DOMConfigurator;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import com.silkworm.jsptags.DropdownDate;

public class LocalStoresItemsMgr extends RDBGateWay {
    
    SqlMgr sqlMgr = SqlMgr.getInstance();
    private static LocalStoresItemsMgr localStoreItemsMgr = new LocalStoresItemsMgr();
    
    public static LocalStoresItemsMgr getInstance() {
        logger.info("Getting LocalStoresItemsMgr Instance ....");
        return localStoreItemsMgr;
    }
    
    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("local_stores_items.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }
    
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }
    
    public boolean saveObject(HttpServletRequest request) {
        WebBusinessObject waUser = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
         DropdownDate dropdownDate = new DropdownDate();
//        java.sql.Date beginDate = new java.sql.Date(dropdownDate.getDate(request.getParameter("beginDate")).getTime());
      
        DateParser dateParser=new DateParser();
        java.sql.Date beginDate=dateParser.formatSqlDate(request.getParameter("beginDate"));
        
        Vector storeParams = new Vector();
        Vector historyParams = new Vector();
        
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        
        String note = null;
        String from = null;
        String itemId = UniqueIDGen.getNextID();
        
        if(request.getParameter("notes").equalsIgnoreCase("") || request.getParameter("notes") == null){
            note = "no notes";
        } else {
            note = request.getParameter("notes");
        }
        
        if(request.getParameter("from").equalsIgnoreCase("") || request.getParameter("from") == null){
            from = "undefined";
        } else {
            from = request.getParameter("from");
        }
        
        //set loact store spare part data
        storeParams.addElement(new StringValue(itemId));
        storeParams.addElement(new StringValue(request.getParameter("itemCode")));
        storeParams.addElement(new StringValue(request.getParameter("itemName")));
        storeParams.addElement(new IntValue(new Integer(request.getParameter("quantity").toString()).intValue()));
        storeParams.addElement(new IntValue(new Integer(request.getParameter("price").toString()).intValue()));
        storeParams.addElement(new StringValue(request.getParameter("store")));
        storeParams.addElement(new StringValue(note));
        storeParams.addElement(new StringValue(waUser.getAttribute("userId").toString()));
        storeParams.addElement(new StringValue(from));
        
        //set spare part history data
        historyParams.addElement(new StringValue(UniqueIDGen.getNextID()));
        historyParams.addElement(new StringValue(itemId));
        historyParams.addElement(new IntValue(new Integer(request.getParameter("quantity").toString()).intValue()));
        historyParams.addElement(new IntValue(new Integer(request.getParameter("price").toString()).intValue()));
        historyParams.addElement(new StringValue(from));
       
        historyParams.addElement(new StringValue(note));
         historyParams.addElement(new DateValue(beginDate));
        historyParams.addElement(new StringValue(waUser.getAttribute("userId").toString()));
        
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            
            forInsert.setSQLQuery(sqlMgr.getSql("insertSparePart").trim());
            forInsert.setparams(storeParams);
            queryResult = forInsert.executeUpdate();
            
            forInsert.setSQLQuery(sqlMgr.getSql("insertSparePartHistory").trim());
            forInsert.setparams(historyParams);
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
    
     public boolean saveNewQuantityItem(HttpServletRequest request) {
        WebBusinessObject waUser = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
         DropdownDate dropdownDate = new DropdownDate();
//        java.sql.Date beginDate = new java.sql.Date(dropdownDate.getDate(request.getParameter("beginDate")).getTime());
      
         DateParser dateParser=new DateParser();
        java.sql.Date beginDate=dateParser.formatSqlDate(request.getParameter("beginDate"));
         
        Vector storeParams = new Vector();
        Vector historyParams = new Vector();
        
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        
        String note = null;
        String from = null;
        //String itemId = UniqueIDGen.getNextID();
        
        if(request.getParameter("notes").equalsIgnoreCase("") || request.getParameter("notes") == null){
            note = "no notes";
        } else {
            note = request.getParameter("notes");
        }
        
        if(request.getParameter("from").equalsIgnoreCase("") || request.getParameter("from") == null){
            from = "undefined";
        } else {
            from = request.getParameter("notes");
        }
        
        //set loact store spare part data
       
        
        //set spare part history data
        historyParams.addElement(new StringValue(UniqueIDGen.getNextID()));
        historyParams.addElement(new StringValue(request.getParameter("id")));
        historyParams.addElement(new IntValue(new Integer(request.getParameter("quantity").toString()).intValue()));
        historyParams.addElement(new IntValue(new Integer(request.getParameter("price").toString()).intValue()));
        historyParams.addElement(new StringValue(from));
       
        historyParams.addElement(new StringValue(note));
        historyParams.addElement(new DateValue(beginDate));
        historyParams.addElement(new StringValue(waUser.getAttribute("userId").toString()));
        
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
             
            forInsert.setSQLQuery(sqlMgr.getSql("insertSparePartHistory").trim());
            forInsert.setparams(historyParams);
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
            cashedData.add((String) wbo.getAttribute("itemCode"));
        }
        
        return cashedData;
    }
    
    public boolean getActiveItem(String itemID) throws Exception {

        Vector SQLparams = new Vector();
        Connection connection = null;
        Vector queryResult = null;
        SQLparams.addElement(new StringValue(itemID));
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getActiveItem").trim());
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
    
    public Vector getListSparePartByDate(HttpServletRequest request) {
        DropdownDate dropdownDate = new DropdownDate();
//        java.sql.Date beginDate = new java.sql.Date(dropdownDate.getDate(request.getParameter("beginDate")).getTime());
//        java.sql.Date endDate = new java.sql.Date(dropdownDate.getDate(request.getParameter("endDate")).getTime());
//        
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

    @Override
    protected void initSupportedQueries() {
     return; //   throw new UnsupportedOperationException("Not supported yet.");
    }
}
