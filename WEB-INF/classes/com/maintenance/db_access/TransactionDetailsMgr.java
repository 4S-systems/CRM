package com.maintenance.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import java.sql.SQLException;
import java.util.*;
import org.apache.log4j.xml.DOMConfigurator;

public class TransactionDetailsMgr extends RDBGateWay {

    private static TransactionDetailsMgr transactionDetailsMgr = new TransactionDetailsMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();

    public static TransactionDetailsMgr getInstance() {
        logger.info("Getting TransactionDetailsMgr Instance ....");
        return transactionDetailsMgr;
    }

    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("transaction_details.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public boolean saveObject(Hashtable hash) throws SQLException {
        return false;
    }

    public ArrayList getCashedTableAsArrayList() {

        cashedData = new ArrayList();
        WebBusinessObject wbo = null;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add((String) wbo.getAttribute("itemID"));
        }

        return cashedData;
    }

    @Override
    protected void initSupportedQueries() {
     return; //   throw new UnsupportedOperationException("Not supported yet.");
    }
}
