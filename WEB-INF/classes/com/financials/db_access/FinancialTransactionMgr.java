package com.financials.db_access;

import com.silkworm.Exceptions.NoUserInSessionException;
import com.silkworm.business_objects.BusinessForm;
import com.silkworm.business_objects.DOMFabricatorBean;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.persistence.relational.DateValue;
import com.silkworm.persistence.relational.FloatValue;
import com.silkworm.persistence.relational.NoSuchColumnException;
import com.silkworm.persistence.relational.RDBGateWay;
import com.silkworm.persistence.relational.Row;
import com.silkworm.persistence.relational.SQLCommandBean;
import com.silkworm.persistence.relational.StringValue;
import com.silkworm.persistence.relational.TimestampValue;
import com.silkworm.persistence.relational.UniqueIDGen;
import com.silkworm.persistence.relational.UnsupportedConversionException;
import com.silkworm.persistence.relational.UnsupportedTypeException;
import com.tracker.db_access.ProjectMgr;
import java.sql.Connection;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Enumeration;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.log4j.xml.DOMConfigurator;

public class FinancialTransactionMgr extends RDBGateWay {

    private static FinancialTransactionMgr FinanceTransMgr = new FinancialTransactionMgr();

    public static FinancialTransactionMgr getInstance() {
        logger.info("Getting FinancialTransactionMgr Instance ....");
        return FinanceTransMgr;
    }

    public FinancialTransactionMgr() {
    }

    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }

        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("FinancialTransaction.xml")));
                logger.debug("supportedForm --> " + supportedForm);
            } catch (Exception e) {
                logger.error("Could not locate XML Document from FinancialTransaction");
            }
        }
    }

    public String saveFinTrnsaction(WebBusinessObject transactionWbo, WebBusinessObject persistentUser) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(new java.util.Date());

        DateFormat df = new SimpleDateFormat("yyyy/MM/dd");
        java.sql.Timestamp entryTime = null;
        String transDate = transactionWbo.getAttribute("docDate").toString();
        try {
            entryTime = new java.sql.Timestamp(df.parse(transDate).getTime());
        } catch (ParseException ex) {
            logger.error(ex);
        }

        Vector transParameters = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        String transId = UniqueIDGen.getNextID();
        Connection connection = null;
        try {
            // setup Finicial Transaction data
            transParameters.addElement(new StringValue(transId));
            transParameters.addElement(new StringValue(transactionWbo.getAttribute("businessID").toString()));
            transParameters.addElement(new StringValue(transactionWbo.getAttribute("docNumber").toString()));
            transParameters.addElement(new TimestampValue(entryTime));
            transParameters.addElement(new StringValue(transactionWbo.getAttribute("accountCode") != null ? transactionWbo.getAttribute("accountCode").toString() : "UL"));
            transParameters.addElement(new StringValue(transactionWbo.getAttribute("FTypeID").toString()));
            transParameters.addElement(new StringValue(transactionWbo.getAttribute("purposeID").toString()));
            transParameters.addElement(new FloatValue(new Float(transactionWbo.getAttribute("transValue").toString())));
            transParameters.addElement(new FloatValue(new Float(transactionWbo.getAttribute("transNetValue") != null ? transactionWbo.getAttribute("transNetValue").toString() : "0")));
            transParameters.addElement(new StringValue(transactionWbo.getAttribute("sourceKind").toString()));
            transParameters.addElement(new StringValue(transactionWbo.getAttribute("source").toString()));
            transParameters.addElement(new StringValue(transactionWbo.getAttribute("destinationKind").toString()));
            transParameters.addElement(new StringValue(transactionWbo.getAttribute("destination").toString()));
            transParameters.addElement(new StringValue(transactionWbo.getAttribute("notes").toString()));
            transParameters.addElement(new StringValue((String) persistentUser.getAttribute("userId")));
            transParameters.addElement(new StringValue((String) transactionWbo.getAttribute("units")));

            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            forInsert.setConnection(connection);

            // saving transaction data
            forInsert.setSQLQuery(getQuery("insertTransaction").trim());
            forInsert.setparams(transParameters);
            queryResult = forInsert.executeUpdate();
            if (queryResult < 0) {
                connection.rollback();
                return null;
            }
        } catch (SQLException ex) {
            logger.error(ex.getMessage());
            try {
                connection.rollback();
            } catch (SQLException ex1) {
                Logger.getLogger("Saving Financial Transaction Exception = " + ex1);
            }

            return null;
        } finally {
            try {
                connection.commit();
                connection.close();
            } catch (SQLException ex) {
                Logger.getLogger("Saving Financial Transaction Exception = " + ex);
            }
        }

        if (queryResult > 0) {
            return "ok";
        } else {
            return null;
        }
    }
  
    public Double getClientUnitTotal(String clientID, String unitID) {
        Vector params = new Vector();
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getClientUnitTotal").trim());
            params.addElement(new StringValue(clientID));
            params.addElement(new StringValue(unitID));
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }
        Row r;
        if (queryResult != null) {
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                try {
                    if (r.getBigDecimal("TOTAL") != null) {
                        return r.getBigDecimal("TOTAL").doubleValue();
                    }
                } catch (NoSuchColumnException | UnsupportedConversionException ex) {
                    Logger.getLogger(FinancialTransactionMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
        return 0.0;
    }

    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
        return;
    }

    @Override
    public ArrayList getCashedTableAsArrayList() {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }
    
    public Vector getAllFinancialTransaction(String unitID, String clientID) throws NoUserInSessionException {
        Vector queryResult = new Vector();
        Vector params = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;
        StringBuilder where = new StringBuilder();
        
        
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            String flag = "0";
            if(unitID != null && !unitID.equalsIgnoreCase("")){
                where.append(" WHERE FT.OPTION1 = ?");
                params.addElement(new StringValue(unitID));
                flag = "1";
            }
            
            if(clientID != null && !clientID.equalsIgnoreCase("")){
                if(flag == "1"){
                    where.append(" AND FT.SOURCE_ID = ?");
                } else {
                    where.append(" WHERE FT.SOURCE_ID = ?");
                } 
                
                params.addElement(new StringValue(clientID));
            }
            String query = getQuery("getAllFinancialTransaction").trim();
            forQuery.setSQLQuery(query + where.toString());
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        
        Vector resultBusObjs = new Vector();
        Row r = null;
        WebBusinessObject wbo;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            try {
                if(r.getString("NAME") != null){
                    wbo.setAttribute("clientNm", r.getString("NAME"));
                } else {
                    wbo.setAttribute("clientNm", "---");
                }
                
                if(r.getString("UnitNm") != null){
                    wbo.setAttribute("UnitNm", r.getString("UnitNm"));
                } else {
                    wbo.setAttribute("UnitNm", "---");
                }
                
                if(r.getString("TransTyp") != null){
                    wbo.setAttribute("TransTyp", r.getString("TransTyp"));
                } else {
                    wbo.setAttribute("TransTyp", "---");
                }
                
                if(r.getString("madeen") != null){
                    wbo.setAttribute("madeen", r.getString("madeen"));
                } else {
                    wbo.setAttribute("madeen", "---");
                }
                
                if(r.getString("FULL_NAME") != null){
                    wbo.setAttribute("createdByNm", r.getString("FULL_NAME"));
                } else {
                    wbo.setAttribute("createdByNm", "---");
                }
                resultBusObjs.add(wbo);
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(FinancialTransactionMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        
        return resultBusObjs;
    }
    
    public Vector getFinancialTransactionByDates(String fromDate, String toDate) throws NoUserInSessionException {
        Vector queryResult = new Vector();
        Vector params = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;
        StringBuilder where = new StringBuilder();
        params.addElement(new StringValue(fromDate));
        params.addElement(new StringValue(toDate));
        
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            String flag = "0";
            String query = getQuery("getFinancialTransactionByDates").trim();
            forQuery.setSQLQuery(query + where.toString());
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        
        Vector resultBusObjs = new Vector();
        Row r = null;
        WebBusinessObject wbo;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            try {
                if(r.getString("NAME") != null){
                    wbo.setAttribute("clientNm", r.getString("NAME"));
                } else {
                    wbo.setAttribute("clientNm", "---");
                }
                
                if(r.getString("UnitNm") != null){
                    wbo.setAttribute("UnitNm", r.getString("UnitNm"));
                } else {
                    wbo.setAttribute("UnitNm", "---");
                }
                
                if(r.getString("TransTyp") != null){
                    wbo.setAttribute("TransTyp", r.getString("TransTyp"));
                } else {
                    wbo.setAttribute("TransTyp", "---");
                }
                
                if(r.getString("madeen") != null){
                    wbo.setAttribute("madeen", r.getString("madeen"));
                } else {
                    wbo.setAttribute("madeen", "---");
                }
                
                if(r.getString("FULL_NAME") != null){
                    wbo.setAttribute("createdByNm", r.getString("FULL_NAME"));
                } else {
                    wbo.setAttribute("createdByNm", "---");
                }
                resultBusObjs.add(wbo);
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(FinancialTransactionMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        
        return resultBusObjs;
    }
    public Vector getTransactionsList(String ContractId, String fromD, String toD) throws SQLException, Exception {

        Vector SQLparams = new Vector();
        WebBusinessObject wbo = null; 
      StringBuilder where = new StringBuilder();
         if(fromD != null && !fromD.isEmpty()) {
            where.append(" AND TRUNC(DOCUMENT_DATE) >= TO_DATE('").append(fromD).append("','YYYY/MM/DD')");
        }
        
        if(toD != null && !toD .isEmpty()) {
            where.append(" AND TRUNC(DOCUMENT_DATE) <= TO_DATE('").append(toD).append("','YYYY/MM/DD')");
        }
        
        where.append(" ORDER BY DOCUMENT_DATE");
        StringBuffer dq = new StringBuffer("SELECT * FROM FINANCE_TRANSACTION WHERE SOURCE_ID ='");
        dq.append(ContractId);
        dq.append("'");
        
        String theQuery = dq.toString()+ where.toString();

      

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = dataSource.getConnection();
        try {

            forQuery.setConnection(connection);
            forQuery.setSQLQuery(theQuery);

            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            throw se;
        } catch (UnsupportedTypeException uste) {
            logger.error("Persistence Error " + uste.getMessage());
        } finally {
            connection.close();
        }

        // process the vector
        // vector of business objects
        Vector reultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            reultBusObjs.add(fabricateBusObj(r));
        }

        return reultBusObjs;

    }
    
    public ArrayList<WebBusinessObject> getFinancialTransactionsBycolumnName(String beginDate, String endDate,String Code,String Type ) {
        WebBusinessObject wbo;
        Connection connection = null;
        Vector<Row> query = new Vector<>();
        Vector parameters = new Vector();
        
        SQLCommandBean forQuery = new SQLCommandBean();
        parameters.addElement(new StringValue(beginDate));
        parameters.addElement(new StringValue(endDate));
        String Where="  WHERE T."+Type+" like '%"+Code.trim()+"%' And TRUNC(T.CREATION_TIME) BETWEEN TO_DATE(?, 'YYYY/MM/DD') AND TO_DATE(?, 'YYYY/MM/DD') ";
        
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getFinancialTransactionsByCode")+Where);
            forQuery.setparams(parameters);
            query = forQuery.executeQuery();
        } catch (SQLException ex) {
            java.util.logging.Logger.getLogger(FinancialTransactionMgr.class.getName()).log(Level.SEVERE, null, ex);
        } catch (UnsupportedTypeException ex) {
            java.util.logging.Logger.getLogger(FinancialTransactionMgr.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        ArrayList<WebBusinessObject> result = new ArrayList<>();
           try {
            for (Row row : query) {
                wbo = fabricateBusObj(row);
                if (row.getString("SourceName") != null) {
                    wbo.setAttribute("SourceName", row.getString("SourceName"));
                }else
                {
                     wbo.setAttribute("SourceName","");
                }
                
                if (row.getString("DestName") != null) {
                    wbo.setAttribute("DestName", row.getString("DestName"));
                }else
                {
                     wbo.setAttribute("DestName","");
                }
                if (row.getString("TRANSACTION_TYPE_NAME") != null) {
                    wbo.setAttribute("TRANSACTION_TYPE_NAME", row.getString("TRANSACTION_TYPE_NAME"));
                }else
                {
                     wbo.setAttribute("TRANSACTION_TYPE_NAME","");
                }

              
                result.add(wbo);
            }
        } catch (NoSuchColumnException ex) {
            java.util.logging.Logger.getLogger(FinancialTransactionMgr.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        
        return result;
    }
     public ArrayList<WebBusinessObject> getFinancialTransactionsByRecipient(String beginDate, String endDate,String[] recipient ) {
        WebBusinessObject wbo;
        Connection connection = null;
        Vector<Row> query = new Vector<>();
        Vector parameters = new Vector();
        
        SQLCommandBean forQuery = new SQLCommandBean();
        parameters.addElement(new StringValue(beginDate));
        parameters.addElement(new StringValue(endDate));
       String Where=" WHERE T.DESTINATION_ID IN( ";
       for(int i=0;i<recipient.length;i++)
       {
           
           Where=Where+"'"+recipient[i]+"'";
           if(i!=recipient.length-1)
              Where=Where+ ",";
       }
        Where=Where+") And TRUNC(T.CREATION_TIME) BETWEEN TO_DATE(?, 'YYYY/MM/DD') AND TO_DATE(?, 'YYYY/MM/DD')";
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getFinancialTransactionsByCode") +Where);
            forQuery.setparams(parameters);
            query = forQuery.executeQuery();
        } catch (SQLException ex) {
            java.util.logging.Logger.getLogger(FinancialTransactionMgr.class.getName()).log(Level.SEVERE, null, ex);
        } catch (UnsupportedTypeException ex) {
            java.util.logging.Logger.getLogger(FinancialTransactionMgr.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        ArrayList<WebBusinessObject> result = new ArrayList<>();
           try {
            for (Row row : query) {
                wbo = fabricateBusObj(row);
                if (row.getString("SourceName") != null) {
                    wbo.setAttribute("SourceName", row.getString("SourceName"));
                }else
                {
                     wbo.setAttribute("SourceName","");
                }
                
                if (row.getString("DestName") != null) {
                    wbo.setAttribute("DestName", row.getString("DestName"));
                }else
                {
                     wbo.setAttribute("DestName","");
                }
                if (row.getString("TRANSACTION_TYPE_NAME") != null) {
                    wbo.setAttribute("TRANSACTION_TYPE_NAME", row.getString("TRANSACTION_TYPE_NAME"));
                }else
                {
                     wbo.setAttribute("TRANSACTION_TYPE_NAME","");
                }

              
                result.add(wbo);
            }
        } catch (NoSuchColumnException ex) {
            java.util.logging.Logger.getLogger(FinancialTransactionMgr.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        
        return result;
    }
    
     
    public ArrayList<WebBusinessObject> getAllRecipients() {
        WebBusinessObject wbo;
        Connection connection = null;
        Vector<Row> query = new Vector<>();
        Vector parameters = new Vector();
        
        SQLCommandBean forQuery = new SQLCommandBean();
        
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getAllRecipients"));
            query = forQuery.executeQuery();
        } catch (SQLException ex) {
            java.util.logging.Logger.getLogger(FinancialTransactionMgr.class.getName()).log(Level.SEVERE, null, ex);
        } catch (UnsupportedTypeException ex) {
            java.util.logging.Logger.getLogger(FinancialTransactionMgr.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        ArrayList<WebBusinessObject> result = new ArrayList<>();
           try {
            for (Row row : query) {
                wbo = fabricateBusObj(row);
                if (row.getString("ID") != null) {
                    wbo.setAttribute("ID", row.getString("ID"));
                }else
                {
                     wbo.setAttribute("ID","");
                }
                
                if (row.getString("NAME") != null) {
                    wbo.setAttribute("NAME", row.getString("NAME"));
                }else
                {
                     wbo.setAttribute("NAME","");
                }
               
              
                result.add(wbo);
            }
        } catch (NoSuchColumnException ex) {
            java.util.logging.Logger.getLogger(FinancialTransactionMgr.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        
        return result;
    }
    
  public WebBusinessObject getAccountOpeningBalance(String accountID, java.sql.Date inDate) {
        Vector queryResult = new Vector();
        Vector params = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;
        StringBuilder where = new StringBuilder();
        params.addElement(new StringValue(accountID));
        params.addElement(new StringValue(accountID));
        params.addElement(new StringValue(accountID));
        params.addElement(new StringValue(accountID));
        params.addElement(new DateValue(inDate));
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            String query = getQuery("getAccountOpeningBalance").trim();
            forQuery.setSQLQuery(query + where.toString());
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                java.util.logging.Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        Row r = null;
        WebBusinessObject wbo = new WebBusinessObject();
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            try {
                wbo.setAttribute("balance", r.getString("BALANCE") != null ? r.getString("BALANCE") : "0");
            } catch (NoSuchColumnException ex) {
                java.util.logging.Logger.getLogger(FinancialTransactionMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return wbo;
    }
     public ArrayList<WebBusinessObject> searchTransactionByType(String accountID, java.sql.Date fromDate, java.sql.Date toDate,String Type) {
        Vector queryResult = new Vector();
        Vector params = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;
        StringBuilder where = new StringBuilder();
        params.addElement(new StringValue(accountID));
        params.addElement(new StringValue(accountID));
        params.addElement(new StringValue(accountID));
        params.addElement(new DateValue(fromDate));
        params.addElement(new DateValue(toDate));
        params.addElement(new StringValue(Type));
        
        params.addElement(new StringValue(accountID));
        params.addElement(new StringValue(accountID));
        params.addElement(new StringValue(accountID));
        params.addElement(new DateValue(fromDate));
        params.addElement(new DateValue(toDate));
        params.addElement(new StringValue(Type));
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            String query = getQuery("getBalanceReport2").trim();
            forQuery.setSQLQuery(query + where.toString());
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                java.util.logging.Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        ArrayList<WebBusinessObject> results = new ArrayList<>();
        Row r = null;
        WebBusinessObject wbo;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = fabricateBusObj(r);
            try {
                wbo.setAttribute("creditValue", r.getString("CREDIT_VALUE") != null ? r.getString("CREDIT_VALUE") : "0");
                wbo.setAttribute("debitValue", r.getString("DEBIT_VALUE") != null ? r.getString("DEBIT_VALUE") : "0");
                wbo.setAttribute("creditName", r.getString("CREDIT_NAME") != null ? r.getString("CREDIT_NAME") : "---");
                wbo.setAttribute("debitName", r.getString("DEBIT_NAME") != null ? r.getString("DEBIT_NAME") : "---");
                results.add(wbo);
            } catch (NoSuchColumnException ex) {
                java.util.logging.Logger.getLogger(FinancialTransactionMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return results;
    }


  public ArrayList<WebBusinessObject> getFinancialTransactions(String beginDate, String endDate) {
        WebBusinessObject wbo;
        Connection connection = null;
        Vector<Row> query = new Vector<>();
        Vector parameters = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        parameters.addElement(new StringValue(beginDate));
        parameters.addElement(new StringValue(endDate));
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setparams(parameters);
            forQuery.setSQLQuery(getQuery("getFinancialTransactions"));
            query = forQuery.executeQuery();
        } catch (SQLException ex) {
            java.util.logging.Logger.getLogger(FinancialTransactionMgr.class.getName()).log(Level.SEVERE, null, ex);
        } catch (UnsupportedTypeException ex) {
            java.util.logging.Logger.getLogger(FinancialTransactionMgr.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        ArrayList<WebBusinessObject> result = new ArrayList<>();
        try {
            for (Row row : query) {
                wbo = fabricateBusObj(row);
                if (row.getString("PROJECT_NAME") != null) {
                    wbo.setAttribute("finTrnsTyp", row.getString("PROJECT_NAME"));
                }
                
                if (row.getString("SRC_AR_DESC") != null) {
                    wbo.setAttribute("srcArDesc", row.getString("SRC_AR_DESC"));
                }

                if (row.getString("SRC_EN_DESC") != null) {
                    wbo.setAttribute("srcEnDesc", row.getString("SRC_EN_DESC"));
                }

                if (row.getString("SRC_NM") != null) {
                    wbo.setAttribute("srcNm", row.getString("SRC_NM"));
                }

                if (row.getString("DST_AR_DESC") != null) {
                    wbo.setAttribute("dstArDesc", row.getString("DST_AR_DESC"));
                }
                
                if (row.getString("DST_EN_DESC") != null) {
                    wbo.setAttribute("dstEnDsc", row.getString("DST_EN_DESC"));
                }
                
                if (row.getString("DST_NM") != null) {
                    wbo.setAttribute("dstNm", row.getString("DST_NM"));
                }
                
                result.add(wbo);
            }
        } catch (NoSuchColumnException ex) {
            java.util.logging.Logger.getLogger(FinancialTransactionMgr.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        return result;
    }
  
   public ArrayList<WebBusinessObject> getBalanceReport(String accountID, java.sql.Date fromDate, java.sql.Date toDate) {
        Vector queryResult = new Vector();
        Vector params = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;
        StringBuilder where = new StringBuilder();
        params.addElement(new StringValue(accountID));
        params.addElement(new StringValue(accountID));
        params.addElement(new StringValue(accountID));
        params.addElement(new DateValue(fromDate));
        params.addElement(new DateValue(toDate));
        
        params.addElement(new StringValue(accountID));
        params.addElement(new StringValue(accountID));
        params.addElement(new StringValue(accountID));
        params.addElement(new DateValue(fromDate));
        params.addElement(new DateValue(toDate));
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            String query = getQuery("getBalanceReport1").trim();
            forQuery.setSQLQuery(query + where.toString());
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                java.util.logging.Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        ArrayList<WebBusinessObject> results = new ArrayList<>();
        Row r = null;
        WebBusinessObject wbo;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = fabricateBusObj(r);
            try {
                wbo.setAttribute("creditValue", r.getString("CREDIT_VALUE") != null ? r.getString("CREDIT_VALUE") : "0");
                wbo.setAttribute("debitValue", r.getString("DEBIT_VALUE") != null ? r.getString("DEBIT_VALUE") : "0");
                wbo.setAttribute("creditName", r.getString("CREDIT_NAME") != null ? r.getString("CREDIT_NAME") : "---");
                wbo.setAttribute("debitName", r.getString("DEBIT_NAME") != null ? r.getString("DEBIT_NAME") : "---");
                wbo.setAttribute("documentCode", r.getString("DOCUMENT_CODE") != null ? r.getString("DOCUMENT_CODE") : "");
                wbo.setAttribute("transactionCode", r.getString("TRANSACTION_CODE") != null ? r.getString("TRANSACTION_CODE") : " ");
                results.add(wbo);
            } catch (NoSuchColumnException ex) {
                java.util.logging.Logger.getLogger(FinancialTransactionMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return results;
    }   
   
   
    public String insertTreeTransactionTypeRel(WebBusinessObject transactionWbo ) {
        
        Vector transParameters = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        String transId = UniqueIDGen.getNextID();
        Connection connection = null;
        try {
            // setup Finicial Transaction data
            transParameters.addElement(new StringValue(transId));
            transParameters.addElement(new StringValue(transactionWbo.getAttribute("itemID").toString()));
            transParameters.addElement(new StringValue(transactionWbo.getAttribute("TypeID").toString()));
             transParameters.addElement(new StringValue("UL"));
            transParameters.addElement(new StringValue("UL"));
            transParameters.addElement(new StringValue("UL"));
            transParameters.addElement(new StringValue("UL"));
           
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            forInsert.setConnection(connection);

            // saving transaction data
            forInsert.setSQLQuery(getQuery("insertTreeTransactionTypeRel").trim());
            forInsert.setparams(transParameters);
            queryResult = forInsert.executeUpdate();
            if (queryResult < 0) {
                connection.rollback();
                return null;
            }
        } catch (SQLException ex) {
            logger.error(ex.getMessage());
            try {
                connection.rollback();
            } catch (SQLException ex1) {
                Logger.getLogger("Saving Financial Transaction Exception = " + ex1);
            }

            return null;
        } finally {
            try {
                connection.commit();
                connection.close();
            } catch (SQLException ex) {
                Logger.getLogger("Saving Financial Transaction Exception = " + ex);
            }
        }

        if (queryResult > 0) {
            return "ok";
        } else {
            return "fail";
        }
    }
    
  public String detechTreeItem(String itemId ) {
        
        Vector transParameters = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

         Connection connection = null;
        try {
            // setup Finicial Transaction data
            transParameters.addElement(new StringValue(itemId));
             
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            forInsert.setConnection(connection);
              forInsert.setSQLQuery(getQuery("detechTreeItem").trim());
            forInsert.setparams(transParameters);
            queryResult = forInsert.executeUpdate();
            if (queryResult < 0) {
                connection.rollback();
                return null;
            }
        } catch (SQLException ex) {
            logger.error(ex.getMessage());
            try {
                connection.rollback();
            } catch (SQLException ex1) {
                Logger.getLogger("Saving Financial Transaction Exception = " + ex1);
            }

            return null;
        } finally {
            try {
                connection.commit();
                connection.close();
            } catch (SQLException ex) {
                Logger.getLogger("Saving Financial Transaction Exception = " + ex);
            }
        }

        if (queryResult > 0) {
            return "ok";
        } else {
            return "fail";
        }
    }
  

}
