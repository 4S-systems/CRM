package com.maintenance.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.persistence.relational.StringValue;
import java.util.*;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.log4j.xml.DOMConfigurator;

public class ItemsWithAvgPriceItemDataMgr extends RDBGateWay {

    private static ItemsWithAvgPriceItemDataMgr itemsWithAvgPriceItemDataMgr = new ItemsWithAvgPriceItemDataMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();

    public ItemsWithAvgPriceItemDataMgr() {
    }

    public static ItemsWithAvgPriceItemDataMgr getInstance() {
        logger.info("Getting avgUnitMgr Instance ....");
        return itemsWithAvgPriceItemDataMgr;
    }

    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("item_with_avg_price_item_data.xml")));
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

    public String getIssuePartsCost(String issueId) throws NoSuchColumnException, UnsupportedConversionException {
        Vector params = new Vector();
        Vector result = new Vector();
        params.addElement(new StringValue((issueId)));
        SQLCommandBean forSelect = new SQLCommandBean();
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forSelect.setConnection(connection);
            forSelect.setSQLQuery(sqlMgr.getSql("selectIssuPartsCost").trim());
            forSelect.setparams(params);
            try {
                result = forSelect.executeQuery();
            } catch (UnsupportedTypeException ex) {
                Logger.getLogger(ItemsWithAvgPriceItemDataMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        } catch (SQLException ex) {
            Logger.getLogger(ItemsWithAvgPriceItemDataMgr.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                Logger.getLogger(ItemsWithAvgPriceItemDataMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        if (result.isEmpty()) {
            return "0.00";
        } else {
            Row r;
            r = (Row) result.get(0);
            try {
                return r.getString("IssuePartsCost");
            } catch (Exception ex) {
                return "0.00";
            }
        }
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
            forQuery.setSQLQuery(sqlMgr.getSql("getItemsWithAvgPriceItemData").trim());
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
}
