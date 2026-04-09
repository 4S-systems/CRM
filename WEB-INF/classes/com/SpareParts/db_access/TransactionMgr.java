package com.SpareParts.db_access;

import com.maintenance.db_access.ResultStoreItemMgr;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.common.MetaDataMgr;
import com.tracker.db_access.IssueMgr;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.*;
import java.sql.*;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.http.HttpServletRequest;
import org.apache.log4j.xml.DOMConfigurator;

public class TransactionMgr extends RDBGateWay {

    private static TransactionMgr transactionMgr = new TransactionMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();
    private String transactionId ;
    private String transactionNo ;

    public static TransactionMgr getInstance() {
        logger.info("Getting TransactionMgr Instance ....");
        return transactionMgr;
    }

    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("transaction.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public boolean saveObject(HttpServletRequest request) throws SQLException {



        String sTransactionNo = UniqueIDGen.getNextID();
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        WebBusinessObject waUser = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
        try {
            Thread.sleep(700);
        } catch (InterruptedException ex) {
            logger.error(ex.getMessage());
        }
        String sIssueID = request.getParameter("issueId");
        IssueMgr issueMgr = IssueMgr.getInstance();
        WebBusinessObject wboIssue = issueMgr.getOnSingleKey(sIssueID);

        Vector paramsDetails = new Vector();
        Vector paramsStatus = new Vector();

        params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue("91"));
        params.addElement(new StringValue(sTransactionNo));
        params.addElement(new StringValue((String) wboIssue.getAttribute("businessID")));
        params.addElement(new StringValue((String) waUser.getAttribute("userId")));
        params.addElement(new StringValue(request.getParameter("trade")));
        params.addElement(new StringValue(sIssueID));
        params.addElement(new StringValue((String) waUser.getAttribute("userId")));

        paramsStatus.addElement(new StringValue(UniqueIDGen.getNextID()));
        paramsStatus.addElement(new StringValue(sTransactionNo));

        Connection connection = null;


        try {
            beginTransaction();
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertTransactionSQL").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            queryResult = -1000;

            String[] arrItems = request.getParameterValues("itemID");
            String[] itemForm = request.getParameterValues("itemForm");
            String[] branch = request.getParameterValues("branch");
            String[] store = request.getParameterValues("store");

            for (int i = 0; i < arrItems.length; i++) {
                try {
                    Thread.sleep(700);
                } catch (InterruptedException ex) {
                    logger.error(ex.getMessage());
                }
                paramsDetails = new Vector();
                paramsDetails.addElement(new StringValue(UniqueIDGen.getNextID()));
                paramsDetails.addElement(new StringValue(request.getParameter("itemQuantity" + arrItems[i])));
                paramsDetails.addElement(new StringValue(arrItems[i]));
                paramsDetails.addElement(new StringValue(sTransactionNo));
                paramsDetails.addElement(new StringValue(request.getParameter("isMust" + arrItems[i])));
                paramsDetails.addElement(new StringValue((String) waUser.getAttribute("userId")));
                paramsDetails.addElement(new StringValue(itemForm[i]));
                paramsDetails.addElement(new StringValue(branch[i]));
                paramsDetails.addElement(new StringValue(store[i]));

                forInsert.setSQLQuery(sqlMgr.getSql("insertTransactionDetailsSQL").trim());
                forInsert.setparams(paramsDetails);
                queryResult = forInsert.executeUpdate();
            }
            try {
                Thread.sleep(700);
            } catch (InterruptedException ex) {
                logger.error(ex.getMessage());
            }
            queryResult = -1000;
            forInsert.setSQLQuery(sqlMgr.getSql("insertTransactionFirstStatusSQL").trim());
            forInsert.setparams(paramsStatus);
            queryResult = forInsert.executeUpdate();
            endTransaction();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
                return false;
            }
        }

        return (queryResult > 0);
    }

    public boolean saveMutiFormTrans(HttpServletRequest request,List savingList, String transactionCode) throws SQLException {


        Hashtable tableItem = new Hashtable();
        String sTransactionNo = UniqueIDGen.getNextID();
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        WebBusinessObject waUser = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
        try {
            Thread.sleep(200);
        } catch (InterruptedException ex) {
            logger.error(ex.getMessage());
        }
        String sIssueID = request.getParameter("issueId");
        IssueMgr issueMgr = IssueMgr.getInstance();
        WebBusinessObject wboIssue = issueMgr.getOnSingleKey(sIssueID);

        Vector paramsDetails = new Vector();
        Vector paramsStatus = new Vector();

        String transId = UniqueIDGen.getNextID();
        this.setTransactionId(transId);
        this.setTransactionNo(sTransactionNo);


        params.addElement(new StringValue(transId));
        params.addElement(new StringValue(transactionCode));
        params.addElement(new StringValue(sTransactionNo));
        params.addElement(new StringValue((String) wboIssue.getAttribute("businessID")));
        params.addElement(new StringValue((String) waUser.getAttribute("userId")));
        params.addElement(new StringValue((String) request.getAttribute("trade")));
        params.addElement(new StringValue(sIssueID));
        params.addElement(new StringValue((String) waUser.getAttribute("userId")));

        paramsStatus.addElement(new StringValue(UniqueIDGen.getNextID()));
        paramsStatus.addElement(new StringValue(sTransactionNo));

        Connection connection = null;


        try {
            beginTransaction();
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);

            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertTransactionSQL").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();

            if(queryResult <= 0) {
                connection.rollback();
                return false;
            }

            queryResult = -1000;


            String[] arrItems = request.getParameterValues("itemID");
            String[] itemForm = request.getParameterValues("itemForm");
            String[] costCode = request.getParameterValues("costCode");
            String[] branch = request.getParameterValues("branch");
            String[] store = request.getParameterValues("store");

            for (int i = 0; i < savingList.size(); i++) {
                try {
                    Thread.sleep(200);
                } catch (InterruptedException ex) {
                    logger.error(ex.getMessage());
                }
                tableItem = (Hashtable) savingList.get(i);
                paramsDetails = new Vector();
                paramsDetails.addElement(new StringValue(UniqueIDGen.getNextID()));
                paramsDetails.addElement(new StringValue(tableItem.get("qnty").toString()));
                paramsDetails.addElement(new StringValue(tableItem.get("itemId").toString()));
                paramsDetails.addElement(new StringValue(sTransactionNo));
                paramsDetails.addElement(new StringValue(tableItem.get("isMust").toString()));
                paramsDetails.addElement(new StringValue((String) waUser.getAttribute("userId")));
                paramsDetails.addElement(new StringValue(tableItem.get("itemForm").toString()));
                paramsDetails.addElement(new StringValue(tableItem.get("branch").toString()));
                paramsDetails.addElement(new StringValue(tableItem.get("store").toString()));
                paramsDetails.addElement(new StringValue(tableItem.get("costCode").toString()));

                forInsert.setSQLQuery(sqlMgr.getSql("insertTransactionDetailsSQL").trim());
                forInsert.setparams(paramsDetails);
                queryResult = forInsert.executeUpdate();

                if(queryResult <= 0) {
                    connection.rollback();
                    return false;
                }
            }
            try {
                Thread.sleep(200);
            } catch (InterruptedException ex) {
                logger.error(ex.getMessage());
            }
            queryResult = -1000;
            forInsert.setSQLQuery(sqlMgr.getSql("insertTransactionFirstStatusSQL").trim());
            forInsert.setparams(paramsStatus);
            queryResult = forInsert.executeUpdate();

            if(queryResult <= 0) {
                connection.rollback();
                return false;
            }
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } finally {
            try {
                connection.commit();
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
                return false;
            }
        }

        if(queryResult > 0){

            saveTransactionInERP(request,savingList,transactionCode,wboIssue.getAttribute("businessID").toString());

        }

        return (queryResult > 0);
    }

    public Vector getTransactionsInRange(long lBeginDate, long lEndDate) {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        java.sql.Date beginDate = new java.sql.Date(lBeginDate);
        java.sql.Date endDate = new java.sql.Date(lEndDate + 24 * 60 * 60 * 1000);
        Vector SQLparams = new Vector();
        Vector queryResult = null;

        SQLparams.addElement(new DateValue(beginDate));
        SQLparams.addElement(new DateValue(endDate));

        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("selectTransactionInRange").trim());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error(uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        Vector resultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }

    public boolean updateStatusForTransaction(HttpServletRequest request) {
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        Vector paramsUpdateStatus = new Vector();
        Vector paramsStatus = new Vector();

        params.addElement(new StringValue(request.getParameter("status")));
        params.addElement(new StringValue(request.getParameter("transactionID")));

        paramsStatus.addElement(new StringValue(UniqueIDGen.getNextID()));
        paramsStatus.addElement(new StringValue(request.getParameter("transactionNO")));
        paramsStatus.addElement(new StringValue(request.getParameter("status")));
        paramsStatus.addElement(new StringValue(request.getParameter("note")));

        paramsUpdateStatus.addElement(new StringValue(request.getParameter("transactionNO")));

        Connection connection = null;

        try {
            beginTransaction();
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("updateTransactionStatusSQL").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            queryResult = -1000;

            forInsert.setSQLQuery(sqlMgr.getSql("updateTransactionStatusDateSQL").trim());
            forInsert.setparams(paramsUpdateStatus);
            queryResult = forInsert.executeUpdate();
            queryResult = -1000;
            forInsert.setSQLQuery(sqlMgr.getSql("insertTransactionStatusSQL").trim());
            forInsert.setparams(paramsStatus);
            queryResult = forInsert.executeUpdate();
            logger.info("right insertion");
            endTransaction();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
                return false;
            }
        }

        return (queryResult > 0);
    }

    public ArrayList getCashedTableAsArrayList() {

        cashedData = new ArrayList();
        WebBusinessObject wbo = null;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add((String) wbo.getAttribute("transactionNO"));
        }

        return cashedData;
    }

    public Vector getCheckResponse(String issueId, String transactionCode) {

        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        StringBuilder query = new StringBuilder(sqlMgr.getSql("getCheckResponse").trim());

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
         Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(issueId));
        SQLparams.addElement(new StringValue(transactionCode));
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
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
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }

    public boolean deleteTransactionResult(String transactionNo) {
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue(transactionNo));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("deleteTransactionResult").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            cashData();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
                return false;
            }
        }

        return (queryResult > 0);
    }

    public boolean isIssueHasRequestStore(String issueId) {
        Vector transaction = new Vector();
        try {
            transaction = transactionMgr.getOnArbitraryKey(issueId, "key2");
        } catch(Exception ex) { logger.error(ex.getMessage()); }

        return transaction.size() > 0;
    }

    public boolean canDelete(String issueId) {
        ResultStoreItemMgr resultStoreItemMgr = ResultStoreItemMgr.getInstance();

        return !resultStoreItemMgr.isIssueHasRespone(issueId);
    }

    public boolean deleteTransaction(String issueId) {
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();

        params.addElement(new StringValue(issueId));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);

            forInsert.setSQLQuery("{ CALL DELETE_TRANSACTION(?) }");
            forInsert.setparams(params);

            forInsert.executeUpdate();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
                return false;
            }
        }

        return (true);
    }

    public boolean saveTransactionInERP(HttpServletRequest request,List savingList,String transactionCode,String issueID){

        MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
        String userName = metaDataMgr.getStoreErpName();
        String password = metaDataMgr.getStoreErpPassword();
        String driver = metaDataMgr.getDriverErp();
        String URL = metaDataMgr.getDataBaseErpUrl();
        Connection conn = null;
        Hashtable tableItem = new Hashtable();
        Vector params = new Vector();

        Vector transParam = new Vector();

        Vector mapTransParam = new Vector();

        int rs = -1000;
        tableItem = (Hashtable) savingList.get(0);
        String branch = tableItem.get("branch").toString();
        String fromDest = "4";
        String fromCode = tableItem.get("store").toString();
        String toDest = "4";
        String toCode = tableItem.get("store").toString();
        String itemForm = tableItem.get("itemForm").toString();


        SpecsOutTrnsMgr specOutTrans = SpecsOutTrnsMgr.getInstance();
        Vector specVec = new Vector();
        WebBusinessObject specWbo = new WebBusinessObject();
        String transType = null;
        String[] fromDestType = null;
        String[] toDestType = null;
        String trnsTypeSpecs = null;
        try {

            if(transactionCode != null && !transactionCode.equals("")){
                if(transactionCode.equals("91")){
                     specVec = specOutTrans.getOnArbitraryKey("sub", "key1");
                }else if(transactionCode.equals("100")){
                 specVec = specOutTrans.getOnArbitraryKey("ret", "key1");
                }else if(transactionCode.equals("92")){
                 specVec = specOutTrans.getOnArbitraryKey("use", "key1");
                }
             }
             String testw = null;
            for(int i=0;i<specVec.size();i++){
            specWbo = (WebBusinessObject) specVec.get(i);
            transType = (String) specWbo.getAttribute("transType");
            ERPStorTrnsMgr erpStorTrnsMgr = ERPStorTrnsMgr.getInstance();
            WebBusinessObject erpStoreTrnsWbo = (WebBusinessObject)erpStorTrnsMgr.getTransTypeFromERP(transType);
            trnsTypeSpecs =(String) erpStoreTrnsWbo.getAttribute("transType");
            if(specWbo.getAttribute("fromSide") != null && !specWbo.getAttribute("fromSide").equals("")
                    && !specWbo.getAttribute("fromSide").equals("store")){
                fromDestType = (String[]) specWbo.getAttribute("fromSide").toString().split("-");
                fromDest = fromDestType[0];
                fromCode = fromDestType[1];
                }
            if(specWbo.getAttribute("toSide") != null && !specWbo.getAttribute("toSide").equals("")
                    && !specWbo.getAttribute("toSide").equals("store")){
                toDestType = (String[]) specWbo.getAttribute("toSide").toString().split("-");
                toDest = toDestType[0];
                toCode = toDestType[1];
                }
             }
        } catch (SQLException ex) {
            Logger.getLogger(TransactionMgr.class.getName()).log(Level.SEVERE, null, ex);
        } catch (Exception ex) {
            Logger.getLogger(TransactionMgr.class.getName()).log(Level.SEVERE, null, ex);
        }
        String test="0";
  

        Long transNo = getMaxExtTransNumber (transType,branch);
        transNo++;
        params.addElement(new LongValue(transNo));
        params.addElement(new StringValue(transType));
        params.addElement(new StringValue(fromDest));
        params.addElement(new StringValue(fromCode));
        params.addElement(new StringValue(toDest));
        params.addElement(new StringValue(toCode));
        params.addElement(new StringValue(itemForm));
        params.addElement(new StringValue(branch));
        params.addElement(new StringValue(issueID));
        params.addElement(new StringValue(trnsTypeSpecs));

        transParam.addElement(new StringValue(transType));
        transParam.addElement(new LongValue(transNo));
        transParam.addElement(new StringValue(branch));
        transParam.addElement(new StringValue(this.getTransactionId()));

        mapTransParam.addElement(new StringValue(transType));
        mapTransParam.addElement(new LongValue(transNo));
        mapTransParam.addElement(new StringValue(branch));
        mapTransParam.addElement(new StringValue(transactionCode));
        mapTransParam.addElement(new StringValue(this.getTransactionNo()));

        SQLCommandBean forQuery = new SQLCommandBean();
        SQLCommandBean forUpdate = new SQLCommandBean();
        SQLCommandBean forInsertMap = new SQLCommandBean();

        try {
            Class.forName(driver);
            conn = DriverManager.getConnection(URL, userName, password);
            conn.setAutoCommit(false);
            forQuery.setConnection(conn);
            forQuery.setparams(params);
            forQuery.setSQLQuery(sqlMgr.getSql("saveTransactionInERP").trim());
            rs = forQuery.executeUpdate();






        } catch (Exception se) {
            logger.error("database error " + se.getMessage());
        }finally {
            try {
                conn.commit();
                conn.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return false;
            }
        }


        if(rs>0){
            saveMapTran (mapTransParam);

            //////// Update Transaction  /////////
             Connection connection = null;
            try {

            connection = dataSource.getConnection();
            forUpdate.setConnection(connection);
            forUpdate.setparams(transParam);
            forUpdate.setSQLQuery(sqlMgr.getSql("updateTransaction").trim());
            rs = forUpdate.executeUpdate();




        } catch (Exception se) {
            logger.error("database error " + se.getMessage());
        }finally {
            try {
                connection.commit();
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return false;
            }
        }
            //////////
            saveTransactionDetailsInERP(request, savingList,transNo,transType);
        }

        return rs > 0;
    }

    public boolean saveTransactionDetailsInERP(HttpServletRequest request,List savingList,Long transNo,String transType){

        MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
        String userName = metaDataMgr.getStoreErpName();
        String password = metaDataMgr.getStoreErpPassword();
        String driver = metaDataMgr.getDriverErp();
        String URL = metaDataMgr.getDataBaseErpUrl();
        Connection conn = null;
        Hashtable tableItem = new Hashtable();
        Vector paramsDetails = new Vector();
        int rs = -1000;
        tableItem = (Hashtable) savingList.get(0);
        String branch = tableItem.get("branch").toString();
        String fromDest = "4";
        String fromCode = tableItem.get("store").toString();
        String toDest = "4";
        String toCode = tableItem.get("store").toString();
        String itemForm = tableItem.get("itemForm").toString();
        String unitNo = (String) request.getAttribute("unitNo");







        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            Class.forName(driver);
            conn = DriverManager.getConnection(URL, userName, password);
            conn.setAutoCommit(false);
            forQuery.setConnection(conn);
            int serial =1;
             for (int i = 0; i < savingList.size(); i++) {
                try {
                    Thread.sleep(200);
                } catch (InterruptedException ex) {
                    logger.error(ex.getMessage());
                }
                tableItem = (Hashtable) savingList.get(i);
                String[] itemCodeArr = tableItem.get("itemId").toString().split("-");
                String itemCode = itemCodeArr[1];

                paramsDetails = new Vector();
                paramsDetails.addElement(new StringValue(transType));
                paramsDetails.addElement(new LongValue(transNo));
                paramsDetails.addElement(new StringValue(itemCode));
                paramsDetails.addElement(new StringValue(tableItem.get("qnty").toString()));
                paramsDetails.addElement(new StringValue(tableItem.get("itemForm").toString()));
                paramsDetails.addElement(new StringValue(tableItem.get("branch").toString()));
                paramsDetails.addElement(new IntValue(serial));
                paramsDetails.addElement(new StringValue(unitNo));

                forQuery.setSQLQuery(sqlMgr.getSql("saveTransactionDetailsInERP").trim());
                forQuery.setparams(paramsDetails);
                rs = forQuery.executeUpdate();

                if(rs <= 0) {
                    conn.rollback();
                    return false;
                }
                serial++;
            }



        } catch (Exception se) {
            logger.error("database error " + se.getMessage());
        }finally {
            try {
                conn.commit();
                conn.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return false;
            }
        }

        if(rs>0){

        }

        return rs > 0;
    }

    public Long getMaxExtTransNumber (String transType,String branch){
        MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
        String userName = metaDataMgr.getStoreErpName();
        String password = metaDataMgr.getStoreErpPassword();
        String driver = metaDataMgr.getDriverErp();
        String URL = metaDataMgr.getDataBaseErpUrl();
        Connection conn = null;
        Long number =new Long(0);
        BigDecimal transNo = null;
        Vector rs = null;

         Vector SQLparams = new Vector();

        SQLparams.addElement(new StringValue(transType));
        SQLparams.addElement(new StringValue(branch));
        SQLCommandBean forQuery = new SQLCommandBean();
         try {
            Class.forName(driver);
            conn = DriverManager.getConnection(URL, userName, password);
            conn.setAutoCommit(false);
            forQuery.setConnection(conn);
            forQuery.setparams(SQLparams);
            forQuery.setSQLQuery(sqlMgr.getSql("getMaxExtTransNumber").trim());
            rs = forQuery.executeQuery();

            Enumeration e = rs.elements();
            Row r = null;

            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                 transNo = r.getBigDecimal(1);
            }
//            if(rs.getBigDecimal("MAX_NO") != null){
//            number = rs.getBigDecimal("MAX_NO").longValue() + 1;
//		}
//            }

        } catch (Exception se) {
            logger.error("database error " + se.getMessage());
        }finally {
            try {
                conn.commit();
                conn.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());

            }
        }
        if(transNo != null){
            number = Long.valueOf(transNo.toString()).longValue();
        }

        return number;
    }

     public boolean saveMapTran (Vector mapTransParam){
        MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
        String userName = metaDataMgr.getStoreErpName();
        String password = metaDataMgr.getStoreErpPassword();
        String driver = metaDataMgr.getDriverErp();
        String URL = metaDataMgr.getDataBaseErpUrl();
        Connection conn = null;
        Long number =new Long(0);
        BigDecimal transNo = null;
        int rs = -1000;


        SQLCommandBean forInsertMap = new SQLCommandBean();
         try {
            Class.forName(driver);
            conn = DriverManager.getConnection(URL, userName, password);
            conn.setAutoCommit(false);
            forInsertMap.setConnection(conn);

            forInsertMap.setparams(mapTransParam);
            forInsertMap.setSQLQuery(sqlMgr.getSql("insertMainMapTransInERP").trim());
            rs = forInsertMap.executeUpdate();


        } catch (Exception se) {
            logger.error("database error " + se.getMessage());
        }finally {
            try {
                conn.commit();
                conn.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());

            }
        }

        return true;
    }


    public String getTransactionNo() {
        return transactionNo;
    }

    public void setTransactionNo(String transactionNo) {
        this.transactionNo = transactionNo;
    }


    public String getTransactionId() {
        return transactionId;
    }

    public void setTransactionId(String transactionId) {
        this.transactionId = transactionId;
    }

    @Override
    protected void initSupportedQueries() {
     return; //   throw new UnsupportedOperationException("Not supported yet.");
    }

}
