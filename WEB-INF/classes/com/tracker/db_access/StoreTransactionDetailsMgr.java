package com.tracker.db_access;

import com.crm.common.CRMConstants;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.log4j.xml.DOMConfigurator;

public class StoreTransactionDetailsMgr extends RDBGateWay {

    private static final StoreTransactionDetailsMgr storeTransactionDetailsMgr = new StoreTransactionDetailsMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();

    public static StoreTransactionDetailsMgr getInstance() {
        logger.info("Getting StoreTransactionDetailsMgr Instance ....");
        return storeTransactionDetailsMgr;
    }

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("store_transaction_details.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    @Override
    public boolean saveObject(WebBusinessObject transactionDetailsWbo) throws SQLException {
        String id = UniqueIDGen.getNextID();
        transactionDetailsWbo.setAttribute("id", id);
        Vector params = new Vector();
        params.addElement(new StringValue(id));
        params.addElement(new StringValue((String) transactionDetailsWbo.getAttribute("storeTransactionID")));
        params.addElement(new StringValue((String) transactionDetailsWbo.getAttribute("itemID")));
        params.addElement(new StringValue((String) transactionDetailsWbo.getAttribute("quantity")));
        params.addElement(new StringValue((String) transactionDetailsWbo.getAttribute("price")));
        params.addElement(new StringValue((String) transactionDetailsWbo.getAttribute("note")));
        params.addElement(new StringValue((String) transactionDetailsWbo.getAttribute("storeID")));
        params.addElement(new StringValue(CRMConstants.SPARE_ITEM_PENDING)); //current status "Pending"
        params.addElement(new StringValue((String) transactionDetailsWbo.getAttribute("option1"))); //option1
        params.addElement(new StringValue((String) transactionDetailsWbo.getAttribute("option2"))); //option2
        params.addElement(new StringValue((String) transactionDetailsWbo.getAttribute("option3"))); //option3
        params.addElement(new StringValue((String) transactionDetailsWbo.getAttribute("option4"))); //option4
        params.addElement(new StringValue((String) transactionDetailsWbo.getAttribute("option5"))); //option5
        params.addElement(new StringValue((String) transactionDetailsWbo.getAttribute("option6"))); //option6
        params.addElement(new StringValue((String) transactionDetailsWbo.getAttribute("storePlace")));
        params.addElement(new StringValue((String) transactionDetailsWbo.getAttribute("packageNo")));
        params.addElement(new StringValue(null)); // production date
        params.addElement(new StringValue(null)); // Expire date
        params.addElement(new StringValue(null)); // other date
        int queryResult = -1000;
        try {
            SQLCommandBean forInsert = new SQLCommandBean();
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(getQuery("insertStoreTransactionDetails").trim());
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
            params.addElement(new StringValue((String) transactionDetailsWbo.getAttribute("userId")));
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

    public boolean update(String id, String note, String price, String quantity, String storeID, String currentStatus,
            String storePlace, String packageNo) {
        SQLCommandBean commandBean = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        int result = -1000;

        parameters.addElement(new StringValue(note));
        parameters.addElement(new StringValue(price));
        parameters.addElement(new StringValue(quantity));
        parameters.addElement(new StringValue(storeID));
        parameters.addElement(new StringValue(currentStatus));
        parameters.addElement(new StringValue(storePlace));
        parameters.addElement(new StringValue(packageNo));
        parameters.addElement(new StringValue(id));
        try {
            connection = dataSource.getConnection();
            commandBean.setConnection(connection);
            commandBean.setSQLQuery(getQuery("updateObject").trim());
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

    public ArrayList<WebBusinessObject> getByTransactionID(String transactionID) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        Vector<Row> result;
        ArrayList<WebBusinessObject> data = new ArrayList<>();
        parameters.addElement(new StringValue(transactionID));
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getByTransactionID"));
            command.setparams(parameters);
            result = command.executeQuery();
            WebBusinessObject wbo;
            for (Row row : result) {
                try {
                    wbo = fabricateBusObj(row);
                    if (row.getString("ITEM_NAME") != null) {
                        wbo.setAttribute("itemName", row.getString("ITEM_NAME"));
                    }
                    if (row.getString("ITEM_CODE") != null) {
                        wbo.setAttribute("itemCode", row.getString("ITEM_CODE"));
                    }
                    data.add(wbo);
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(StoreTransactionDetailsMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } catch (UnsupportedTypeException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error, " + ex);
            }
        }

        return data;
    }
    
    public boolean updateTransactionDetailsStatus(String transactionID, String currentStatus) {
        SQLCommandBean commandBean = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        int result = -1000;
        parameters.addElement(new StringValue(currentStatus));
        parameters.addElement(new StringValue(transactionID));
        try {
            connection = dataSource.getConnection();
            commandBean.setConnection(connection);
            commandBean.setSQLQuery(getQuery("updateTransactionDetailsStatus").trim());
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
