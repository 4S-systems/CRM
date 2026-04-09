package com.SpareParts.db_access;

import com.maintenance.db_access.ActiveStoreMgr;
import com.maintenance.db_access.BranchErpMgr;
import com.maintenance.db_access.StoresErpMgr;
import com.maintenance.db_access.QuantifiedMntenceMgr;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import java.util.*;
import javax.servlet.http.HttpSession;
import java.sql.*;


import org.apache.log4j.xml.DOMConfigurator;

public class UsedSparePartsMgr extends RDBGateWay {

    private static UsedSparePartsMgr usedSparePartsMgr = new UsedSparePartsMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();

    public static UsedSparePartsMgr getInstance() {
        logger.info("Getting UsedSparePartsMgr Instance ....");
        return usedSparePartsMgr;
    }

    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("used_spare_parts.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public void delete(String id, HttpSession s) throws SQLException {

        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

        try {
            deleteOnArbitraryKey(id, "key1");

        } catch (SQLException sqlEx) {
            logger.error("i can't do delete in UsedSparePartsMgr");
            logger.error(sqlEx.getMessage());
        } catch (Exception ex) {
            logger.error(ex.getMessage());
        }

    }

    public boolean saveObject(WebBusinessObject wbo, HttpSession s) throws NoUserInSessionException {
//        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
//        WebIssueType issueType = (WebIssueType)wbo;
//        Vector params = new Vector();
//        SQLCommandBean forInsert = new SQLCommandBean();
//        int queryResult = -1000;
//
//        //params.addElement(new StringValue(UniqueIDGen.getNextID()));
//        params.addElement(new StringValue(issueType.getIssueName()));
//        params.addElement(new StringValue(issueType.getIssueDesc()));
//        params.addElement(new StringValue((String)waUser.getAttribute("userId")));
//
//        Connection connection = null;
//        try
//        {
//            connection = dataSource.getConnection();
//            forInsert.setConnection(connection);
//            forInsert.setSQLQuery(insertIssueSQL);
//            forInsert.setparams(params);
//            queryResult = forInsert.executeUpdate();
//
//            //
//            cashData();
//        }
//        catch(SQLException se)
//        {
//            logger.error(se.getMessage());
//            return false;
//        }
//        finally
//        {
//            try
//            {
//                connection.close();
//            }
//            catch(SQLException ex)
//            {
//                logger.error("Close Error");
//                return false;
//            }
//        }
//
//        return (queryResult > 0);
        return false;
    }

    public void saveObject(String[] qun, String[] pr, String[] cost, String[] note, String[] id, String Uid, String isDirectPrch, HttpSession s) {

        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

        int size = qun.length;

        Connection connection = null;
        SQLCommandBean forInsert = new SQLCommandBean();
        try {

            connection = dataSource.getConnection();
            for (int i = 0; i < size; i++) {
                forInsert.setConnection(connection);
                forInsert.setSQLQuery(sqlMgr.getSql("insertUsedSpareParts").trim());
                Vector params = new Vector();

                int queryResult = -1000;

                params.addElement(new StringValue(UniqueIDGen.getNextID()));
                params.addElement(new StringValue(Uid));
                params.addElement(new StringValue(id[i]));
                params.addElement(new FloatValue(new Float(qun[i]).floatValue()));
                params.addElement(new FloatValue(new Float(pr[i]).floatValue()));
                params.addElement(new FloatValue(new Float(cost[i]).floatValue()));
                params.addElement(new StringValue(note[i]));
                params.addElement(new StringValue((String) waUser.getAttribute("userId")));
                params.addElement(new StringValue(isDirectPrch));


                forInsert.setparams(params);
                queryResult = forInsert.executeUpdate();
                try {
                    Thread.sleep(200);
                } catch (InterruptedException ex) {
                    logger.error(ex.getMessage());
                }

            }
        } catch (SQLException se) {
            logger.error(se.getMessage());

        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");

            }
        }
    }

    public boolean saveItemsObject(String[] qun, String[] pr, String[] cost, String[] note, String[] id, String[] branchs, String[] stores, String Uid, String isDirectPrch, String[] attachedOn, String[] efficient, HttpSession s) {

        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        TransactionMgr transactionMgr = TransactionMgr.getInstance();

        List savingList = new ArrayList();
        Hashtable tableItem = new Hashtable();



        int size = qun.length;

        Connection connection = null;
        SQLCommandBean forInsert = new SQLCommandBean();
        try {
            int queryResult = -1000;
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertUsedPartsFromTasks").trim());
            float totalCost = 0.0f;
            for (int i = 0; i < size; i++) {
                Vector params = new Vector();
                if(qun[i]!=null){
                totalCost = new Float(qun[i]).floatValue()* new Float(pr[i]).floatValue();
                params.addElement(new StringValue(UniqueIDGen.getNextID()));
                params.addElement(new StringValue(Uid));
                params.addElement(new StringValue(id[i]));
                params.addElement(new FloatValue(new Float(qun[i]).floatValue()));
                params.addElement(new FloatValue(new Float(pr[i]).floatValue()));
                params.addElement(new FloatValue(totalCost));
                params.addElement(new StringValue(note[i]));
                params.addElement(new StringValue((String) waUser.getAttribute("userId")));
                params.addElement(new StringValue(isDirectPrch));
                params.addElement(new StringValue(branchs[i]));
                params.addElement(new StringValue(stores[i]));
                params.addElement(new StringValue(efficient[i]));

                savingList.clear();
                String[] item = id[i].split("-");
                String itemCode = item[1];
                String itemForm = item[0];

                tableItem.put("itemId", itemCode);
                tableItem.put("qnty", qun[i]);
                tableItem.put("itemForm", itemForm);
                tableItem.put("branch", branchs[i]);
                tableItem.put("store", stores[i]);

                savingList.add(tableItem);

                forInsert.setparams(params);
                queryResult = forInsert.executeUpdate();
                if (queryResult <= 0) {
                    connection.rollback();
                    return false;
                }
                try {
                    Thread.sleep(200);
                } catch (InterruptedException ex) {
                    logger.error(ex.getMessage());
                }

                QuantifiedMntenceMgr quantifiedMntenceMgr = QuantifiedMntenceMgr.getInstance();
                Double quantityStatus = 0.0;
                if(id.length > 0){
                    //for(int i = 0; i < id.length; i++){
                    String sQty =Float.toString(new Float (qun[i]));
                    Double quant =new Double(sQty);
                    quantityStatus += quant;
                    for(int j = i + 1; j < id.length; j++){
                        if(id[i].equals(id[j])){
                            quantityStatus += Integer.parseInt(qun[j]);
                        }
                    }

                    int quantStatus = 0;
                    quantStatus = (int)quantifiedMntenceMgr.getQuantityStatusByItemID(id[i], Uid, isDirectPrch);
                    quantityStatus = quantStatus - quantityStatus;
                    if(quantityStatus < 0){
                        quantityStatus = 0.0;
                    }
                    quantifiedMntenceMgr.UpdateItemQuantityStatus(id[i], Uid, isDirectPrch, quantityStatus);
                }
            }
           }
        } catch (SQLException se) {
            try {
                connection.rollback();
            } catch (SQLException ex) {
                logger.error(se.getMessage());
            }
            logger.error(se.getMessage());
            return false;

        } finally {
            try {
                connection.commit();
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }


        return true;

    }

    public void saveObject2(String[] qun, String[] pr, String[] cost, String[] note, String[] id, String Uid, String isDirectPrch, String[] attachedOn, HttpSession s) {

        Vector activeStoreVec = new Vector();
        ActiveStoreMgr activeStoreMgr = ActiveStoreMgr.getInstance();
        WebBusinessObject storeDataWbo = new WebBusinessObject();
        WebBusinessObject branchDataWbo = new WebBusinessObject();
        WebBusinessObject activeStoreWbo = new WebBusinessObject();
        StoresErpMgr storesErpMgr = StoresErpMgr.getInstance();
        BranchErpMgr branchErpMgr = BranchErpMgr.getInstance();
        String storeErpId = null;
        String branchErpId = null;


        activeStoreVec = activeStoreMgr.getActiveStore(s);
        if (activeStoreVec.size() > 0) {
            activeStoreWbo = (WebBusinessObject) activeStoreVec.get(0);
            storeDataWbo = storesErpMgr.getOnSingleKey(activeStoreWbo.getAttribute("storeCode").toString());
            branchDataWbo = branchErpMgr.getOnSingleKey(activeStoreWbo.getAttribute("branchCode").toString());
            storeErpId = storeDataWbo.getAttribute("code").toString();
            branchErpId = branchDataWbo.getAttribute("code").toString();
        }

        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

        int size = qun.length;

        Connection connection = null;
        SQLCommandBean forInsert = new SQLCommandBean();
        try {

            connection = dataSource.getConnection();
            for (int i = 0; i < size; i++) {
                forInsert.setConnection(connection);
//                String query="INSERT INTO quantified_mntence VALUES (?, ?, ?, ?, ?, ?, ?, ?, SYSDATE,?,'2')";
                forInsert.setSQLQuery(sqlMgr.getSql("insertUsedPartsFromTasks").trim());
//                forInsert.setSQLQuery(query.trim());
                Vector params = new Vector();

                int queryResult = -1000;

                params.addElement(new StringValue(UniqueIDGen.getNextID()));
                params.addElement(new StringValue(Uid));
                params.addElement(new StringValue(id[i]));
                params.addElement(new FloatValue(new Float(qun[i]).floatValue()));
                params.addElement(new FloatValue(new Float(pr[i]).floatValue()));
                params.addElement(new FloatValue(new Float(cost[i]).floatValue()));
                params.addElement(new StringValue(note[i]));
                params.addElement(new StringValue((String) waUser.getAttribute("userId")));
                params.addElement(new StringValue(isDirectPrch));
                params.addElement(new StringValue(branchErpId));
                params.addElement(new StringValue(storeErpId));
//                params.addElement(new StringValue(attachedOn[i]));


                forInsert.setparams(params);
                queryResult = forInsert.executeUpdate();
                try {
                    Thread.sleep(200);
                } catch (InterruptedException ex) {
                    logger.error(ex.getMessage());
                }

            }
        } catch (SQLException se) {
            logger.error(se.getMessage());

        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");

            }
        }
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

    public Vector getItemSchedule(String issueId) {

        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector SQLparams = new Vector();

        SQLparams.addElement(new StringValue(issueId));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("stItemSQL").trim());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();


        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        Vector resultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = (WebBusinessObject) fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }

    public Vector getUsedItemSchedule(String issueId) {

        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector SQLparams = new Vector();

        SQLparams.addElement(new StringValue(issueId));


        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getUsedItemSchedule").trim());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();


        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        Vector resultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = (WebBusinessObject) fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }

    public int getUsedItemsQuantityForIssue(String issueId) {

        Connection connection = null;
        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(issueId));
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getUsedItemsQuantityForIssue").trim());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }
        if (queryResult.size() > 0) {
            Row r = (Row) queryResult.get(0);
            try {
                return r.getBigDecimal("USED").intValue();
            } catch (NoSuchColumnException ex) {
                logger.error(ex.getMessage());
            } catch (UnsupportedConversionException ex) {
                logger.error(ex.getMessage());
            }
        }
        return 0;
    }

    @Override
    protected void initSupportedQueries() {
      return;//  throw new UnsupportedOperationException("Not supported yet.");
    }
}
