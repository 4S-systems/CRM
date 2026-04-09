package com.maintenance.db_access;

import com.maintenance.common.Tools;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import java.util.*;
import java.sql.*;
import org.apache.log4j.xml.DOMConfigurator;

public class WarrantyItemsMgr extends RDBGateWay {

    SqlMgr sqlMgr = SqlMgr.getInstance();
    private static WarrantyItemsMgr warrantyItemsMgr = new WarrantyItemsMgr();

    public WarrantyItemsMgr() {
    }

    public static WarrantyItemsMgr getInstance() {
        logger.info("Getting WarrantyItemsMgr Instance ....");
        return warrantyItemsMgr;
    }

    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("warranty_items.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue((String) wbo.getAttribute("partId")));
        params.addElement(new StringValue((String) wbo.getAttribute("partCode")));
        params.addElement(new StringValue((String) wbo.getAttribute("vendor")));
        params.addElement(new DateValue(Tools.getSqlDate(wbo.getAttribute("bDate").toString())));
        params.addElement(new DateValue(Tools.getSqlDate(wbo.getAttribute("eDate").toString())));
        params.addElement(new StringValue((String) wbo.getAttribute("note")));
        params.addElement(new StringValue((String) wbo.getAttribute("userId")));

        Connection connection = dataSource.getConnection();
        try {
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertWarranty").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
        } catch (SQLException se) {
            throw se;
        } finally {
            connection.close();
        }
        return (queryResult > 0);
    }

    @Override
    public ArrayList getCashedTableAsArrayList() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    protected void initSupportedQueries() {
    return;//    throw new UnsupportedOperationException("Not supported yet.");
    }
}
