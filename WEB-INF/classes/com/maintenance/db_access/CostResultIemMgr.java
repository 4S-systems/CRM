package com.maintenance.db_access;

import com.maintenance.common.Tools;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import java.util.*;
import java.sql.*;

import org.apache.log4j.xml.DOMConfigurator;

public class CostResultIemMgr extends RDBGateWay {

    SqlMgr sqlMgr = SqlMgr.getInstance();
    private static CostResultIemMgr costResultIemMgr = new CostResultIemMgr();

    public CostResultIemMgr() {
    }

    public static CostResultIemMgr getInstance() {
        logger.info("Getting CostResultIemMgr Instance ....");
        return costResultIemMgr;
    }

    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("cost_store_item.xml")));
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

        cashedData = new ArrayList();
        WebBusinessObject wbo = null;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add((String) wbo.getAttribute("title"));
        }

        return cashedData;
    }
      
    public double getCostItemIssue(String issueId) {
        double cost = 0.00;
        Connection connection = null;
        Vector params = new Vector();
        Vector<Row> queryResult = new Vector();
        SQLCommandBean commandBean = new SQLCommandBean();

        params.addElement(new StringValue(issueId));

        try {
            connection = dataSource.getConnection();
            commandBean.setConnection(connection);
            commandBean.setSQLQuery(sqlMgr.getSql("getCostItemIssue").trim());
            commandBean.setparams(params);

            queryResult = commandBean.executeQuery();
        } catch(Exception ex) {
            logger.error(ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch(SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        for (Row row : queryResult) {
            try {
                cost = row.getDouble("COST");
            } catch(Exception ex) {
                logger.error(ex.getMessage());
            }
        }

        return Tools.round(cost, 2);
    }

    @Override
    protected void initSupportedQueries() {
    return; //    throw new UnsupportedOperationException("Not supported yet.");
    }
   
}
