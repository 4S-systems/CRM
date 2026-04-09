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

public class LocalItemsWarrantyMgr extends RDBGateWay {
    
    SqlMgr sqlMgr = SqlMgr.getInstance();
    private static LocalItemsWarrantyMgr localItemsWarrantyMgr = new LocalItemsWarrantyMgr();
    
    public static LocalItemsWarrantyMgr getInstance() {
        logger.info("Getting LocalStoresItemsMgr Instance ....");
        return localItemsWarrantyMgr;
    }
    
    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("local_items_warranty.xml")));
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
//        java.sql.Date beginDate = new java.sql.Date(dropdownDate.getDate(request.getParameter("beginWDate")).getTime());
//        java.sql.Date endDate = new java.sql.Date(dropdownDate.getDate(request.getParameter("endWDate")).getTime());
        
        DateParser dateParser=new DateParser();
        java.sql.Date beginDate=dateParser.formatSqlDate(request.getParameter("beginWDate"));        
        java.sql.Date endDate=dateParser.formatSqlDate(request.getParameter("endWDate"));
        
        Vector params = new Vector();
        
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        
        
        String id = UniqueIDGen.getNextID();
        
        //set loact store spare part data
        params.addElement(new StringValue(id));
        params.addElement(new StringValue(request.getParameter("itemCode")));
        params.addElement(new StringValue(request.getParameter("warrantyType")));
        params.addElement(new DateValue(beginDate));
        params.addElement(new DateValue(endDate));
        params.addElement(new StringValue(waUser.getAttribute("userId").toString()));
        
        
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            
            forInsert.setSQLQuery(sqlMgr.getSql("insertItemWarranty").trim());
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

    @Override
    protected void initSupportedQueries() {
      return; //  throw new UnsupportedOperationException("Not supported yet.");
    }
    
}
