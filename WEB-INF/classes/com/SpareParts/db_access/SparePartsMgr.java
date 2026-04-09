package com.SpareParts.db_access;

import com.maintenance.common.Tools;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;

import java.util.*;
import java.sql.*;

import org.apache.log4j.xml.DOMConfigurator;

public class SparePartsMgr extends RDBGateWay {

    private static SparePartsMgr itemsMgr = new SparePartsMgr();
    private SqlMgr sqlMgr = SqlMgr.getInstance();

    public static SparePartsMgr getInstance() {
        logger.info("Getting SparePartsMgr ....");
        return SparePartsMgr.itemsMgr;
    }

    public String getKind() {
        return this.metaDataMgr.getConfigurationSparePartsPrice() != null ? this.metaDataMgr.getConfigurationSparePartsPrice() : "0";
    }

    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("spare_parts.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document : " + e.getMessage());
            }
        }
    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public ArrayList getCashedTableAsArrayList() {
        cashedData = new ArrayList();
        WebBusinessObject wbo = null;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add((String) wbo.getAttribute("itemCodeByItemForm"));
        }

        return cashedData;
    }

    public Vector getSparePartsByInterval(String banchCode, String storeCode, String itemForm, String nameOrCode, String sub, String[] notIn, int beginInterval, int endInterval) {
        Connection connection = null;
        String quary;
        Vector parameters = new Vector();
        Vector<Row> queryResult = new Vector<Row>();

        // add parameters
        parameters.addElement(new StringValue(getKind()));
        if (getKind().equals("1")) {
            parameters.addElement(new StringValue(banchCode));
        } else if (getKind().equals("2")) {
            parameters.addElement(new StringValue(storeCode));
        } else {
            parameters.addElement(new StringValue("."));
        }
        parameters.addElement(new StringValue(itemForm));
        parameters.addElement(new IntValue(beginInterval));
        parameters.addElement(new IntValue(endInterval));

        if (notIn != null) {
            quary = sqlMgr.getSql("getSparePartsBySubCodeOrNameByNotInItemCodeByItemForm").trim();
            if (nameOrCode.equals("name")) {
                quary = quary.replaceAll("nnn", sub);
                quary = quary.replaceAll("ccc", "");
            } else {
                quary = quary.replaceAll("nnn", "");
                quary = quary.replaceAll("ccc", sub);
            }

            quary = quary.replaceAll("iii", Tools.concatenation(notIn, ","));
        } else {
            quary = sqlMgr.getSql("getSparePartsBySubCodeOrName").trim();
            if (nameOrCode.equals("name")) {
                quary = quary.replaceAll("nnn", sub);
                quary = quary.replaceAll("ccc", "");
            } else {
                quary = quary.replaceAll("nnn", "");
                quary = quary.replaceAll("ccc", sub);
            }
        }

        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(quary);
            forQuery.setparams(parameters);

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
        for (Row row : queryResult) {
            resultBusObjs.add(fabricateBusObj(row));
        }

        return resultBusObjs;
    }

    public WebBusinessObject getOnObjectByKey(String key) {

        Connection connection = null;

        StringBuilder query = new StringBuilder("SELECT * FROM ");
        query.append(supportedForm.getTableSupported().getAttribute("name"));
        query.append(" WHERE ");
        query.append(supportedForm.getTableSupported().getAttribute("key1"));
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

    public long getSparePartsNumber(String banchCode, String storeCode, String itemForm, String nameOrCode, String sub, String[] notIn) {
        Connection connection = null;
        String quary;
        Vector parameters = new Vector();
        Vector<Row> rows = new Vector<Row>();

        // add parameters
        parameters.addElement(new StringValue(getKind()));
        if (getKind().equals("1")) {
            parameters.addElement(new StringValue(banchCode));
        } else if (getKind().equals("2")) {
            parameters.addElement(new StringValue(storeCode));
        } else {
            parameters.addElement(new StringValue("."));
        }
        parameters.addElement(new StringValue(itemForm));

        if (notIn != null) {
            quary = sqlMgr.getSql("getCountSparePartsBySubCodeOrNameByNotInItemCodeByItemForm").trim();
            if (nameOrCode.equals("name")) {
                quary = quary.replaceAll("nnn", sub);
                quary = quary.replaceAll("ccc", "");
            } else {
                quary = quary.replaceAll("nnn", "");
                quary = quary.replaceAll("ccc", sub);
            }

            quary = quary.replaceAll("iii", Tools.concatenation(notIn, ","));
        } else {
            quary = sqlMgr.getSql("getCountSparePartsBySubCodeOrName").trim();
            if (nameOrCode.equals("name")) {
                quary = quary.replaceAll("nnn", sub);
                quary = quary.replaceAll("ccc", "");
            } else {
                quary = quary.replaceAll("nnn", "");
                quary = quary.replaceAll("ccc", sub);
            }
        }

        SQLCommandBean command = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(quary);
            command.setparams(parameters);

            rows = command.executeQuery();
            if (!rows.isEmpty()) {
                Row row = rows.get(0);
                String count = row.getString("NUMBER_SPARE_PARTS");
                return Long.valueOf(count).longValue();
            }
        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());
        } catch (NoSuchColumnException se) {
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
        for (Row row : rows) {
            resultBusObjs.add(fabricateBusObj(row));
        }

        return 0;
    }

    @Override
    protected void initSupportedQueries() {
     return; //   throw new UnsupportedOperationException("Not supported yet.");
    }
}
