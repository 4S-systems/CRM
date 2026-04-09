package com.tracker.db_access;

import com.crm.common.CRMConstants;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import java.sql.Connection;
import java.sql.Date;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.log4j.xml.DOMConfigurator;

public class StoreTransactionMgr extends RDBGateWay {

    private static final StoreTransactionMgr storeTransactionMgr = new StoreTransactionMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();

    public static StoreTransactionMgr getInstance() {
        logger.info("Getting StoreTransactionMgr Instance ....");
        return storeTransactionMgr;
    }

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("store_transaction.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    @Override
    public boolean saveObject(WebBusinessObject transactionWbo) throws SQLException {
        String id = UniqueIDGen.getNextID();
        transactionWbo.setAttribute("id", id);
        Vector params = new Vector();
        params.addElement(new StringValue(id));
        params.addElement(new StringValue((String) transactionWbo.getAttribute("dependOnIssueID")));
        params.addElement(new StringValue((String) transactionWbo.getAttribute("transactionType")));
        params.addElement(new StringValue((String) transactionWbo.getAttribute("vendorID")));
        params.addElement(new StringValue((String) transactionWbo.getAttribute("transactionMethod")));
        params.addElement(new StringValue((String) transactionWbo.getAttribute("paymentMethod")));
        params.addElement(new StringValue((String) transactionWbo.getAttribute("userId")));
        params.addElement(new StringValue(CRMConstants.STORE_TRANSACTION_PENDING)); //current status "Pending"
        params.addElement(new StringValue((String) transactionWbo.getAttribute("option1"))); //option1
        params.addElement(new StringValue((String) transactionWbo.getAttribute("option2"))); //option2
        params.addElement(new StringValue((String) transactionWbo.getAttribute("option3"))); //option3
        params.addElement(new StringValue((String) transactionWbo.getAttribute("option4"))); //option4
        params.addElement(new StringValue((String) transactionWbo.getAttribute("option5"))); //option5
        params.addElement(new StringValue((String) transactionWbo.getAttribute("option6"))); //option6
        int queryResult = -1000;
        try {
            SQLCommandBean forInsert = new SQLCommandBean();
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(getQuery("insertStoreTransaction").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            if (queryResult < 0) {
                transConnection.rollback();
                return false;
            }
            params = new Vector();
            String issueStatusId = UniqueIDGen.getNextID();
            params.addElement(new StringValue(issueStatusId));
            params.addElement(new StringValue("30"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("0"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue(id));
            params.addElement(new StringValue("STORE_TRANSACTION"));
            params.addElement(new StringValue("0"));
            params.addElement(new StringValue((String) transactionWbo.getAttribute("userId")));
            forInsert.setSQLQuery(sqlMgr.getSql("saveCompStatus").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            if (queryResult < 0) {
                transConnection.rollback();
                return false;
            }
        } catch (SQLException se) {
            System.out.println("DataBase Error = " + se.getMessage());
            logger.error(se.getMessage());
            return false;
        } finally {
            endTransaction();
        }
        return (queryResult > 0);
    }

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
    }

    @Override
    public ArrayList getCashedTableAsArrayList() {
        cashedData = new ArrayList();
        for (Object object : cashedTable) {
            cashedData.add(object);
        }
        return cashedData;
    }

    public ArrayList<WebBusinessObject> getStoreTransactionsWithStatus(Date beginDate, Date endDate, String status, String itemID) {
        String theQuery = getQuery("getStoreTransactionsWithStatus").trim().replaceAll("itemID", itemID).replaceAll("statusID", status);
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        ArrayList<WebBusinessObject> data = new ArrayList<>();
        Vector<Row> result;
        Vector parameters = new Vector();
        parameters.addElement(new DateValue(beginDate));
        parameters.addElement(new DateValue(endDate));
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(theQuery);
            command.setparams(parameters);
            result = command.executeQuery();
            WebBusinessObject wbo;
            for (Row row : result) {
                wbo = fabricateBusObj(row);
                try {
                    if (row.getString("BUSINESS_ID") != null) {
                        wbo.setAttribute("businessID", row.getString("BUSINESS_ID"));
                    }
                    if (row.getString("BUSINESS_ID_BY_DATE") != null) {
                        wbo.setAttribute("businessIDByDate", row.getString("BUSINESS_ID_BY_DATE"));
                    }
                    if (row.getString("STATUS_NAME_AR") != null) {
                        wbo.setAttribute("statusNameAr", row.getString("STATUS_NAME_AR"));
                    }
                    if (row.getString("STATUS_NAME_EN") != null) {
                        wbo.setAttribute("statusNameEn", row.getString("STATUS_NAME_En"));
                    }
                } catch (NoSuchColumnException ex) {
                    logger.error(ex);
                }
                data.add(wbo);
            }
        } catch (SQLException | UnsupportedTypeException ex) {
            logger.error(ex);
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                Logger.getLogger(StoreTransactionMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return data;
    }
    
    public boolean updateTransactionStatus(String id, String currentStatus) {
        SQLCommandBean commandBean = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        int result = -1000;
        parameters.addElement(new StringValue(currentStatus));
        parameters.addElement(new StringValue(id));
        try {
            connection = dataSource.getConnection();
            commandBean.setConnection(connection);
            commandBean.setSQLQuery(getQuery("updateTransactionStatus").trim());
            commandBean.setparams(parameters);
            result = commandBean.executeUpdate();
        } catch (SQLException se) {
            logger.error("Exception " + se.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex);
            }
        }
        return (result > 0);
    }
}
