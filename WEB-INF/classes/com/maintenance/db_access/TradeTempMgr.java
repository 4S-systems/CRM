package com.maintenance.db_access;

import com.silkworm.business_objects.BusinessForm;
import com.silkworm.business_objects.DOMFabricatorBean;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.persistence.relational.RDBGateWay;
import com.silkworm.persistence.relational.SQLCommandBean;
import com.silkworm.persistence.relational.StringValue;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Vector;
import org.apache.log4j.xml.DOMConfigurator;

public class TradeTempMgr extends RDBGateWay {

    private static final TradeTempMgr tradeTempMgr = new TradeTempMgr();

    public static TradeTempMgr getInstance() {
        logger.info("Getting TradeTempMgr Instance ....");
        return tradeTempMgr;
    }

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("trade_temp.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        params.addElement(new StringValue((String) wbo.getAttribute("id")));
        params.addElement(new StringValue((String) wbo.getAttribute("isAuthorized")));
        params.addElement(new StringValue((String) wbo.getAttribute("isPaid")));
        params.addElement(new StringValue((String) wbo.getAttribute("isLocked")));
        params.addElement(new StringValue((String) wbo.getAttribute("option4")));
        params.addElement(new StringValue((String) wbo.getAttribute("option5")));
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(getQuery("insert").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            cashData();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }
        return (queryResult > 0);
    }
    
    public boolean updateObject(WebBusinessObject wbo) throws SQLException {
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        params.addElement(new StringValue((String) wbo.getAttribute("isAuthorized")));
        params.addElement(new StringValue((String) wbo.getAttribute("isPaid")));
        params.addElement(new StringValue((String) wbo.getAttribute("isLocked")));
        params.addElement(new StringValue((String) wbo.getAttribute("option4")));
        params.addElement(new StringValue((String) wbo.getAttribute("option5")));
        params.addElement(new StringValue((String) wbo.getAttribute("id")));
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(getQuery("update").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            cashData();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }
        return (queryResult > 0);
    }

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
    }

    @Override
    public ArrayList getCashedTableAsArrayList() {
        cashData();
        return new ArrayList(cashedData);
    }

}
