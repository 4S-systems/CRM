package com.maintenance.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import java.util.*;
import java.sql.*;

import org.apache.log4j.xml.DOMConfigurator;

public class ItemBalanceMgr extends RDBGateWay {

    SqlMgr sqlMgr = SqlMgr.getInstance();
    private static ItemBalanceMgr itemBalanceMgr = new ItemBalanceMgr();

    public ItemBalanceMgr() {
    }

    public static ItemBalanceMgr getInstance() {
        logger.info("Getting WorkPlaceMgr Instance ....");
        return itemBalanceMgr;
    }

    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("item_balance_at_time.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    @Override
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
        super.cashData();
        cashedData = new ArrayList();
        WebBusinessObject wbo = null;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add((String) wbo.getAttribute("title"));
        }

        return cashedData;
    }

    public String getBalance(String itemCode, String itemFrom, String storeCode) {
        String balance = "0";
        Connection connection = null;
        Vector SQLparams = new Vector();

        SQLparams.addElement(new StringValue(storeCode));
        SQLparams.addElement(new StringValue(itemFrom));
        SQLparams.addElement(new StringValue(itemCode));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getBalance").trim());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();

            if(queryResult.size() > 0) {
                balance = ((Row) queryResult.get(0)).getString("Q1");

                try {
                    Double dBalance = Double.valueOf(balance);
                    if(dBalance.doubleValue() < 0) {
                        return "0";
                    }
                }catch(Exception ex) {
                    logger.error(ex.getMessage());
                }
            }

        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (Exception uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        return balance;
    }

    @Override
    protected void initSupportedQueries() {
     return; //   throw new UnsupportedOperationException("Not supported yet.");
    }

}
