package com.unit.db_access;

import com.maintenance.common.DateParser;
import com.silkworm.business_objects.BusinessForm;
import com.silkworm.business_objects.DOMFabricatorBean;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.persistence.relational.DateValue;
import com.silkworm.persistence.relational.NoSuchColumnException;
import com.silkworm.persistence.relational.RDBGateWay;
import com.silkworm.persistence.relational.Row;
import com.silkworm.persistence.relational.SQLCommandBean;
import com.silkworm.persistence.relational.StringValue;
import com.silkworm.persistence.relational.UniqueIDGen;
import com.silkworm.persistence.relational.UnsupportedTypeException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.log4j.xml.DOMConfigurator;

public class UnitPriceMgr extends RDBGateWay {

    public static UnitPriceMgr unitPriceMgr = new UnitPriceMgr();

    public static UnitPriceMgr getInstance() {
        logger.info("Getting UnitPriceMgr Instance ....");
        return unitPriceMgr;
    }

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("unit_price.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(WebBusinessObject unitPriceWbo, WebBusinessObject loggedUser) {
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult;
        params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue((String) unitPriceWbo.getAttribute("unitID")));
//        params.addElement(new DateValue(new Date(Calendar.getInstance().getTimeInMillis()))); //beginDate
//        params.addElement(new DateValue(new Date(Calendar.getInstance().getTimeInMillis()))); //endDate
        params.addElement(new StringValue((String) unitPriceWbo.getAttribute("maxPrice")));
        params.addElement(new StringValue((String) unitPriceWbo.getAttribute("minPrice")));
        params.addElement(new StringValue((String) loggedUser.getAttribute("userId")));
        params.addElement(new StringValue((String) unitPriceWbo.getAttribute("option1")));
        params.addElement(new StringValue(unitPriceWbo.getAttribute("option2") != null ? (String) unitPriceWbo.getAttribute("option2") : "UL"));
        params.addElement(new StringValue(unitPriceWbo.getAttribute("option3") != null ? (String) unitPriceWbo.getAttribute("option3") : "UL"));
        try {
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(getQuery("insertUnitPrice").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            endTransaction();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        }
        return (queryResult > 0);
    }

    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
    }

    @Override
    public ArrayList getCashedTableAsArrayList() {
        throw new UnsupportedOperationException("Not supported yet.");
    }
    
    public WebBusinessObject getLastPriceForUnit(String unitID) {
        Connection connection = null;
        WebBusinessObject resultBusObj = null;
        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(unitID));
        Vector queryResult;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getLastPriceForUnit").trim());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
            Row r;
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                resultBusObj = fabricateBusObj(r);
            }
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } catch (SQLException e) {
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return null;
            }
        }
        return resultBusObj;
    }
    
    public Map<String, String> getProjectsTotalPrice() {
        Connection connection = null;
        WebBusinessObject resultBusObj = null;
        Vector queryResult;
        SQLCommandBean forQuery = new SQLCommandBean();
        Map<String, String> resultMap = new HashMap<>();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getProjectsTotalPrice").trim());
            queryResult = forQuery.executeQuery();
            Row r;
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                try {
                    resultMap.put(r.getString("PROJECT_ID"), r.getString("PROJECT_TOTAL"));
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(UnitPriceMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } catch (SQLException e) {
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return null;
            }
        }
        return resultMap;
    }
}
