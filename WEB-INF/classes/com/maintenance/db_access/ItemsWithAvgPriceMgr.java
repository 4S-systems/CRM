package com.maintenance.db_access;

import com.maintenance.common.DateParser;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.common.MetaDataMgr;
import com.silkworm.persistence.relational.StringValue;
import java.util.*;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.log4j.xml.DOMConfigurator;

public class ItemsWithAvgPriceMgr extends RDBGateWay {

    private static ItemsWithAvgPriceMgr itemsWithAvgPriceMgr = new ItemsWithAvgPriceMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();

    public ItemsWithAvgPriceMgr() {
    }

    public static ItemsWithAvgPriceMgr getInstance() {
        logger.info("Getting avgUnitMgr Instance ....");
        return itemsWithAvgPriceMgr;
    }

    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("item_with_avg_price.xml")));
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
            cashedData.add((String) wbo.getAttribute("id"));
        }

        return cashedData;
    }

    public Vector getItemsWithAvgPrice(String schedualeId) {
        Connection connection = null;

        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(schedualeId));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {

            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getItemsWithAvgPrice").trim());
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
        Vector reultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            reultBusObjs.add((WebBusinessObject) fabricateBusObj(r));
        }

        return reultBusObjs;
    }


    @Override
    protected void initSupportedQueries() {
     return; //   throw new UnsupportedOperationException("Not supported yet.");
    }


    public Vector getItemsWithAvgPriceByCostCenter(String schedualeId, String costCenterCode) {
        Connection connection = null;

        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(schedualeId));
        SQLparams.addElement(new StringValue(costCenterCode));
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {

            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getItemsWithAvgPriceByCostCenter").trim());
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
        Vector reultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            reultBusObjs.add((WebBusinessObject) fabricateBusObj(r));
        }

        return reultBusObjs;
    }

    public Double getUnitPriceByTransAndBanch(String itemId,WebBusinessObject wboIssue) {

        MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
        String userName = metaDataMgr.getStoreErpName();
        String password = metaDataMgr.getStoreErpPassword();
        String driver = metaDataMgr.getDriverErp();
        String URL = metaDataMgr.getDataBaseErpUrl();
        Vector params = new Vector();
        Connection conn = null;
        Double unitPrice=0.0;
        String []item = itemId.split("-");
        String itemForm = item[0];
        String itemCode = item[1];

        String sSqlDate=null;
        String startDate = (String) wboIssue.getAttribute("actualBeginDate");
        String endDate = (String) wboIssue.getAttribute("actualEndDate");
        java.sql.Date sqlDate;
        DateParser parser = new DateParser();
        startDate = startDate.substring(0, 10);
        startDate = startDate.replace("-","/");
        startDate = startDate.substring(8, 10) +"-"+ startDate.substring(5,7)+"-"+startDate.substring(0,4);
        sSqlDate = startDate;
//        sqlDate = parser.formatSqlDate(startDate);
//        Long longDate=sqlDate.getTime();
//        java.sql.Date dendDate = new java.sql.Date(longDate + 24 * 60 * 60 * 1000);
        if(wboIssue.getAttribute("actualEndDate") != null && !wboIssue.getAttribute("actualEndDate").equals("")){
            endDate = endDate.substring(0, 10);
            startDate = endDate.substring(8, 10) +"-"+ endDate.substring(5,7)+"-"+endDate.substring(0,4);
            endDate = endDate.replace("-","/");
            sSqlDate = endDate;
//            sqlDate = parser.formatSqlDate(endDate);
//            longDate=sqlDate.getTime();
//            dendDate = new java.sql.Date(longDate + 24 * 60 * 60 * 1000);
            
        }
        Vector queryResult = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
//        params.addElement(new DateValue(dendDate));
        params.addElement(new StringValue(itemForm));
        params.addElement(new StringValue(itemCode));
        String sql = "select  * from v_abc where trns_stamp <= to_date('20-Dec-2012','DD-MON-YYYY')  and   item_form=? and item_code=?  order by trns_stamp desc";
        try{
 
            Class.forName(driver);
            conn = DriverManager.getConnection(URL, userName, password);
            conn.setAutoCommit(false);
            forUpdate.setConnection(conn);
            forUpdate.setparams(params);
//            String quary = sqlMgr.getSql("getUnitPriceByTransAndBanch").trim();
//            forUpdate.setSQLQuery(sqlMgr.getSql("getUnitPriceByTransAndBanch").trim());
//            quary.replaceAll("ccc", sSqlDate);
            forUpdate.setSQLQuery(sql); 
            queryResult = forUpdate.executeQuery();
        } catch (Exception se) {
           logger.error(se.getMessage());
        } finally {
            try {
                conn.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

       Vector resultBusObjs = new Vector();
       WebBusinessObject wbo;
        Row r = null;

        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            try {
                //            r = (Row) e.nextElement();
                r = (Row) queryResult.get(0);
                unitPrice = r.getDouble("unitprice");
                //            wbo = new WebBusinessObject();
                //            resultBusObjs.add(wbo);
                //            resultBusObjs.add(wbo);
            } catch (NoSuchColumnException ex) {
                unitPrice=0.0;
            } catch (UnsupportedConversionException ex) {
                unitPrice=0.0;
            }
        }
        return unitPrice;

    }

}
