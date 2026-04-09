package com.maintenance.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.persistence.relational.StringValue;
import java.util.*;
import java.sql.*;
import org.apache.log4j.xml.DOMConfigurator;

public class QuantifiedItemsDescMgr extends RDBGateWay {

    private static QuantifiedItemsDescMgr quantifiedItemsDescMgr = new QuantifiedItemsDescMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();

    public QuantifiedItemsDescMgr() {
    }

    public static QuantifiedItemsDescMgr getInstance() {
        logger.info("Getting avgUnitMgr Instance ....");
        return quantifiedItemsDescMgr;
    }

    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("quantified_items_desc.xml")));
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

    public Vector getAllQuantifiedItems(){
        return getQuantifiedItemsBySubName("");
    }

    public Vector getQuantifiedItemsBySubName(String name) {

        Connection connection = null;

        StringBuffer query = new StringBuffer(sqlMgr.getSql("getQuantifiedItemsDescBySubName").trim().replaceAll("ppp", name));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());

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

        Vector res = new Vector();

        for (int i = 0; i < queryResult.size(); i++) {
            res.add(fabricateBusObj((Row) queryResult.get(i)));
        }

        return res;
    }

    public String getItemDesc(String itemId) {

        Connection connection = null;

        Vector queryResult = null;
        Vector sqlParam = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();

        sqlParam.addElement(new StringValue(itemId));

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getItemDesc").trim());
            forQuery.setparams(sqlParam);
            queryResult = forQuery.executeQuery();

            Row row = (Row) queryResult.get(0);
            return row.getString("item_desc");

        } catch (Exception se) {
            logger.error("troubles closing connection " + se.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }

        return null;
    }

    @Override
    protected void initSupportedQueries() {
      return; //  throw new UnsupportedOperationException("Not supported yet.");
    }

}
