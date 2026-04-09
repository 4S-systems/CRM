package com.maintenance.db_access;

import com.maintenance.common.DateParser;
import com.maintenance.common.Tools;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import com.silkworm.jsptags.DropdownDate;
import java.util.*;
import javax.servlet.http.HttpSession;
import java.sql.*;
import javax.servlet.http.HttpServletRequest;
import org.apache.log4j.xml.DOMConfigurator;

public class ItemsMgr extends RDBGateWay {
    
    private static ItemsMgr itemsMgr = new ItemsMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();
    
//    private static final String insertIssueSQL = "INSERT INTO ISSUE_TYPE VALUES (?,?,now(),?)";
    public static ItemsMgr getInstance() {
        logger.info("Getting ItemsMgr Instance ....");
        return itemsMgr;
    }
    
    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("items.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }
    
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }
    
    public boolean saveObject(WebBusinessObject wbo, HttpSession s) throws NoUserInSessionException {
        return false;
    }
    
    public Vector getRequiredItemsInRange(HttpServletRequest request) {
        DropdownDate dropdownDate = new DropdownDate();
        
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        StringBuffer query = new StringBuffer(sqlMgr.getSql("selectItemsCountSQL").trim());
        Vector params = new Vector();
        
        DateParser dateParser=new DateParser();
        java.sql.Date sqlDate=dateParser.formatSqlDate(request.getParameter("beginDate"));
        java.sql.Timestamp beginDate=new java.sql.Timestamp(sqlDate.getTime());
        
        sqlDate=dateParser.formatSqlDate(request.getParameter("endDate"));
        java.sql.Timestamp endDate=new java.sql.Timestamp(sqlDate.getTime());
        
        params.addElement(new TimestampValue(beginDate));
        params.addElement(new TimestampValue(endDate));
        
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
            
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                
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
    
    public ArrayList getCashedTableAsArrayList() {
        
        cashedData = new ArrayList();
        WebBusinessObject wbo = null;
        
        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add((String) wbo.getAttribute("id"));
        }
        
        return cashedData;
    }

    public WebBusinessObject getOnObjectByKey(String key) {

        Connection connection = null;

        StringBuilder query = new StringBuilder("SELECT * FROM ");
        query.append(supportedForm.getTableSupported().getAttribute("name"));
        query.append(" WHERE ");
        query.append(supportedForm.getTableSupported().getAttribute("key3"));
        query.append(" = ?");

        Vector SQLparams = new Vector();
        logger.info("the query " + query.toString());

        SQLparams.addElement(new StringValue(key));

        Vector queryResult = null;
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

        WebBusinessObject reultBusObj = null;

        Row r = null;
        Enumeration e = queryResult.elements();

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            reultBusObj = fabricateBusObj(r);
        }


        return reultBusObj;

    }

    ///////////////////Mahmoud Farahat/////////////
    public Vector getSparePartByName(String name) {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector queryResult = null;



        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getSparePartByName").trim().replaceAll("ppp", name));
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
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

    public Vector getSparePartByNameAndItemForm(String name,String itemForm,HttpSession s) {

         ActiveStoreMgr activeStoreMgr = ActiveStoreMgr.getInstance();
            WebBusinessObject activeStoreWbo = new WebBusinessObject();
            Vector activeStoreVec = new Vector();

            activeStoreVec = activeStoreMgr.getActiveStore(s);
            activeStoreWbo = (WebBusinessObject) activeStoreVec.get(0);
            String storeCode =activeStoreWbo.getAttribute("storeCode").toString();

        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;

        Vector SQLparams = new Vector();
        Vector queryResult = null;

        SQLparams.addElement(new StringValue(itemForm));
        SQLparams.addElement(new StringValue(storeCode));

        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getSparePartByNameAndItemForm").trim().replaceAll("ppp", name));
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
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

    public Vector getByCode(String number) {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector SQLparams = new Vector();
        Vector queryResult = null;



        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getByCode").trim().replaceAll("ppp", number));

            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
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

    public Vector getAllSpareParts() {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector SQLparams = new Vector();
        Vector queryResult = null;



        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getAllSpareParts").trim());

            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
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
    //////////////// End//////////////////////////

    public Vector getPartsBySubName(String partName){
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;

        Vector queryResult = null;
        String query="select * from items where ITEM_DESC LIKE '%ppp%'";

        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.trim().replaceAll("ppp", partName));
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
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

    public Vector getSparePartByNameAndStore(String name,String storeCode) {

        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;

        Vector SQLparams = new Vector();
        Vector queryResult = null;

        SQLparams.addElement(new StringValue(storeCode));

        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getSparePartByNameAndStore").trim().replaceAll("ppp", name));
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
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
   
    public Vector getSparePartByCodeAndStore(String code,String storeCode) {

        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;

        Vector SQLparams = new Vector();
        Vector queryResult = null;

        SQLparams.addElement(new StringValue(storeCode));

        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getSparePartByCodeAndStore").trim().replaceAll("ppp", code));
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
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

    public Vector getSparePartByFinalCodeAndItemForm(String subCode,String itemForm,HttpSession s) {

         ActiveStoreMgr activeStoreMgr = ActiveStoreMgr.getInstance();
            WebBusinessObject activeStoreWbo = new WebBusinessObject();
            Vector activeStoreVec = new Vector();

            activeStoreVec = activeStoreMgr.getActiveStore(s);
            activeStoreWbo = (WebBusinessObject) activeStoreVec.get(0);
            String storeCode =activeStoreWbo.getAttribute("storeCode").toString();

        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;

        Vector SQLparams = new Vector();
        Vector queryResult = null;

        SQLparams.addElement(new StringValue(itemForm));
        SQLparams.addElement(new StringValue(storeCode));

        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getSparePartByFinalCodeAndItemForm").trim().replaceAll("ppp", subCode));
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
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

    public Vector getSpareParts(String itemForm,String storeCode,String nameOrCode,String sub, String[] notIn){
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        String quary;
        Vector SQLparams = new Vector();
        Vector queryResult = null;

        SQLparams.addElement(new StringValue(itemForm));
        SQLparams.addElement(new StringValue(storeCode));

        if(notIn != null){
            if(nameOrCode.equals("name"))
                quary = sqlMgr.getSql("selectItemsBySubNameByNotInItemCodeByItemForm").trim();
            else
                quary = sqlMgr.getSql("selectItemsBySubCodeByNotInItemCodeByItemForm").trim();

            quary = quary.replaceAll("ccc", Tools.concatenation(notIn, ","));
        } else{
            if(nameOrCode.equals("name"))
                quary = sqlMgr.getSql("selectItemsBySubName").trim();
            else
                quary = sqlMgr.getSql("selectItemsBySubCode").trim();
        }

        quary = quary.replaceAll("ppp", sub);

        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(quary);
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
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

    public String getItemName(String itemCodeByItemForm) {
        String itemName = "---";

        try {
            WebBusinessObject wbo = ItemsMgr.itemsMgr.getOnSingleKey(itemCodeByItemForm);
            itemName = (String) wbo.getAttribute("itemDscrptn");
        } catch(Exception ex) { logger.error(ex.getMessage()); }

        return itemName;
    }

    @Override
    protected void initSupportedQueries() {
      return; //  throw new UnsupportedOperationException("Not supported yet.");
    }
}
