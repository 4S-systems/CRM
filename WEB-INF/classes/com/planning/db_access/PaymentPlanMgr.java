/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.planning.db_access;

import com.android.business_objects.LiteWebBusinessObject;
import com.silkworm.business_objects.BusinessForm;
import com.silkworm.business_objects.DOMFabricatorBean;
import com.silkworm.business_objects.SqlMgr;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.persistence.relational.DateValue;
import com.silkworm.persistence.relational.IntValue;
import com.silkworm.persistence.relational.NoSuchColumnException;
import com.silkworm.persistence.relational.RDBGateWay;
import com.silkworm.persistence.relational.Row;
import com.silkworm.persistence.relational.SQLCommandBean;
import com.silkworm.persistence.relational.StringValue;
import com.silkworm.persistence.relational.UniqueIDGen;
import com.silkworm.persistence.relational.UnsupportedConversionException;
import com.silkworm.persistence.relational.UnsupportedTypeException;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Enumeration;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.mail.Session;
import javax.servlet.http.HttpSession;
import org.apache.log4j.xml.DOMConfigurator;

/**
 *
 * @author java3
 */
public class PaymentPlanMgr extends RDBGateWay{
    private static PaymentPlanMgr paymentPlanMgr = new PaymentPlanMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();

    public static PaymentPlanMgr getInstance() {
        logger.info("Getting PaymentPlanMgr Instance ....");
        return paymentPlanMgr;
    }
    
    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }
    
    @Override
       protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("payment_plan.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }
       
    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
    }
    
    @Override
    public ArrayList getCashedTableAsArrayList() {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }
    
    public String saveObject(String unitID, String clientID, String planName, String resAmnt, String downAmnt, String downDate, String insAmnt, String fristInsDate, String insNo, String Dis, String usrID, String paymentAmt, String entitiesInfo, String sPlanID, String typ) throws SQLException {
        Connection connection = null;
        
        DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd");
        java.sql.Date downDateConv = null;
         java.sql.Date fristInsDateConv = null;
        Calendar c = Calendar.getInstance();
        String planID = null;
        try {
            int queryResult = 0;
            Vector params = new Vector();
            SQLCommandBean forInsert = new SQLCommandBean();
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            
            planID = UniqueIDGen.getNextID();
            if(downDate == null || downDate.equals("")){
                downDate = "null";
            }
            
            if(downAmnt == null || downAmnt.equals("")){
                downAmnt = "0";
            }
            
            if(Dis == null || Dis.equals("")){
                Dis = "0";
            }
            
            if(insNo == null || insNo.equals("")){
                insNo = "0";
            }
            
            if(resAmnt == null || resAmnt.equals("")){
                resAmnt = "0";
            }
            
            try {
                downDateConv =  new java.sql.Date (dateFormat.parse(downDate).getTime());
            } catch (ParseException ex) {
                Logger.getLogger(PaymentPlanMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            
            try {
                fristInsDateConv = new java.sql.Date (dateFormat.parse(fristInsDate).getTime());
            } catch (ParseException ex) {
                Logger.getLogger(PaymentPlanMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            
            forInsert.setSQLQuery(getQuery("insertPaymentPlan").trim());
            
            params.addElement(new StringValue(planID));
            params.addElement(new StringValue(planName));
            params.addElement(new StringValue(paymentAmt));
            params.addElement(new IntValue(Integer.parseInt(downAmnt)));
            params.addElement(new DateValue(downDateConv));
            params.addElement(new DateValue(fristInsDateConv));
            params.addElement(new IntValue(Integer.parseInt(Dis)));
            params.addElement(new IntValue(Integer.parseInt(insNo)));
            params.addElement(new IntValue(Integer.parseInt(resAmnt)));
            params.addElement(new StringValue(usrID));
            params.addElement(new DateValue(new java.sql.Date(c.getTimeInMillis())));
            params.addElement(new StringValue(clientID));
            params.addElement(new StringValue(unitID));
            params.addElement(new StringValue(entitiesInfo));
            params.addElement(new StringValue(sPlanID));
            params.addElement(new StringValue(typ));

            forInsert.setparams(params);

            queryResult = forInsert.executeUpdate();
            
            if(queryResult > 0){
                params = new Vector();
                String issuesStID = UniqueIDGen.getNextID();
                forInsert.setSQLQuery(getQuery("insertPaymentPlanIssStatus").trim());
                
                params.addElement(new StringValue(issuesStID));
                params.addElement(new StringValue("79"));
                params.addElement(new StringValue("Proposed"));
                params.addElement(new StringValue(planID));
                params.addElement(new StringValue("Payment_Plan"));
                params.addElement(new StringValue(usrID));
                
                forInsert.setparams(params);
                queryResult = forInsert.executeUpdate();
            }
        } catch (SQLException ex) {
            logger.error(ex);
        } finally {
            if (connection != null) {
                try {
                    connection.setAutoCommit(true);
                    connection.close();
                } catch (SQLException ex) {
                    Logger.getLogger(PaymentPlanMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
        
        return planID;
    }
    
    public String createInstallments(String planID, String insDate, int insNo, String insNoName, String insPayAmt, String insPayAmntSys, String usrID, String payType) throws SQLException {
        Connection connection = null;
        
        DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd");
        java.sql.Date payDateConv = null;
        Calendar c = Calendar.getInstance();
        if(insPayAmt == null || insPayAmt.equals("")){
            insPayAmt = "0";
        }
        
        double aDouble = Double.parseDouble(insPayAmt);
        int intValue = (int) aDouble;
        try {
            int queryResult = 0;
            Vector params = new Vector();
            SQLCommandBean forInsert = new SQLCommandBean();
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            String paymentID = UniqueIDGen.getNextID();

            String payTitle = insNoName + " payment";
            if(insNo > 0){
                String[] parts = insDate.split("/");
                double x;
                int month, year = Integer.parseInt(parts[0]);

                month = (Integer.parseInt(parts[1]) + Integer.parseInt(insPayAmntSys));
                if(month > 12){
                    x = Math.floor(month/12);
                    year = year + (int) x;
                    month = month - (12 * (int) x);
                    if(month == 0){
                        month = 12;
                        year = year - 1;
                    }
                }

                parts[0] = Integer.toString(year);
                parts[1] = Integer.toString(month);
                if(month < 10 && parts[1].length() < 2){
                    parts[1] = "0" + parts[1];
                }

                insDate = parts[0] + "/" + parts[1] + "/" + parts[2];
            }

            try {
                payDateConv = new java.sql.Date (dateFormat.parse(insDate).getTime());
            } catch (ParseException ex) {
                Logger.getLogger(PaymentPlanMgr.class.getName()).log(Level.SEVERE, null, ex);
            }

            forInsert.setSQLQuery(getQuery("insertPaymentPlanDetails").trim());

            params.addElement(new StringValue(paymentID));
            params.addElement(new StringValue(planID));
            params.addElement(new StringValue(payTitle));
            params.addElement(new IntValue(intValue));
            params.addElement(new StringValue(usrID));
            params.addElement(new DateValue(new java.sql.Date(c.getTimeInMillis())));
            params.addElement(new DateValue(payDateConv));
            params.addElement(new StringValue(payType));

            forInsert.setparams(params);

            queryResult = forInsert.executeUpdate();
        } catch (SQLException ex) {
            logger.error(ex);
        } finally {
            if (connection != null) {
                try {
                    connection.setAutoCommit(true);
                    connection.close();
                } catch (SQLException ex) {
                    Logger.getLogger(PaymentPlanMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
        
        return insDate;
    }
    
    public ArrayList<WebBusinessObject> getInstallmentPlan(String planID) throws UnsupportedTypeException, NoSuchColumnException, UnsupportedConversionException {
        ArrayList<WebBusinessObject> data = new ArrayList<>();
        Vector params = new Vector();
        WebBusinessObject wbo;
        Connection connection = null;

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getInstallmentPlan").trim());
            
            params.addElement(new StringValue(planID));
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
                wbo = new WebBusinessObject();
                try {
                    if(r.getString("PLAN_ID") != null){
                        wbo.setAttribute("planID", r.getString("PLAN_ID"));
                    } else {
                        wbo.setAttribute("planID", null);
                    }
                    
                    if(r.getString("PAYMENT_AMT") != null){
                         wbo.setAttribute("insAMT", r.getString("PAYMENT_AMT"));
                    } else {
                        wbo.setAttribute("insAMT", null);
                    }
                    
                    Timestamp timestamp = r.getTimestamp("PAYMENT_DATE");
                    if(timestamp != null){
                        wbo.setAttribute("insDate", r.getString("PAYMENT_DATE"));
                    } else {
                        wbo.setAttribute("insDate", "null");
                    }
                    
                    if(r.getString("PAYMENT_TYPE") != null){
                        wbo.setAttribute("payType", r.getString("PAYMENT_TYPE"));
                    } else {
                        wbo.setAttribute("payType", null);
                    }
                    
                    data.add(wbo);
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(PaymentPlanMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
        
        return data;
    }
    
    public boolean detelePlan(String tableName, String planID) throws SQLException {
        Connection connection = null;
        int queryResult = -1000;
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        
        StringBuilder table = new StringBuilder();
        
        table.append(tableName);
        try {
            connection = dataSource.getConnection();

            params.addElement(new StringValue(planID));
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(getQuery("deletePayPlan").replaceAll("table", table.toString()).trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            if (queryResult < 0) {
                return false;
            } else {
                return true;
            }
        } catch (SQLException ex) {
            Logger.getLogger(PaymentPlanMgr.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        } finally {
            connection.setAutoCommit(true);
            connection.close();
        }
    }
    
    public boolean cancelPlan(String planID, HttpSession s) throws SQLException {
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        //waUser.getAttribute("userId")
        Connection connection = null;
        int queryResult = -1000;
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        
        StringBuilder table = new StringBuilder();
        
        try {
            connection = dataSource.getConnection();

            params.addElement(new StringValue(planID));
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(getQuery("upPayPlanSt").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            if (queryResult < 0) {
                return false;
            } else {
                params = new Vector();                
                String issuesStID = UniqueIDGen.getNextID();
                forInsert.setSQLQuery(getQuery("insertPaymentPlanIssStatus").trim());
                
                params.addElement(new StringValue(issuesStID));
                params.addElement(new StringValue("80"));
                params.addElement(new StringValue("Canceled"));
                params.addElement(new StringValue(planID));
                params.addElement(new StringValue("Payment_Plan"));
                params.addElement(new StringValue((String) waUser.getAttribute("userId")));
                
                forInsert.setparams(params);
                queryResult = forInsert.executeUpdate();
                
                return true;
            }
        } catch (SQLException ex) {
            Logger.getLogger(PaymentPlanMgr.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        } finally {
            connection.setAutoCommit(true);
            connection.close();
        }
    }
    
     public boolean requestPlanApproval(String planID, HttpSession s) throws SQLException {
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        Connection connection = null;
        int queryResult = -1000;
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        
        StringBuilder table = new StringBuilder();
        
        try {
            connection = dataSource.getConnection();

            params.addElement(new StringValue(planID));
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(getQuery("upPayPlanSt").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            if (queryResult < 0) {
                return false;
            } else {
                params = new Vector();                
                String issuesStID = UniqueIDGen.getNextID();
                forInsert.setSQLQuery(getQuery("insertPaymentPlanIssStatus").trim());
                
                params.addElement(new StringValue(issuesStID));
                params.addElement(new StringValue("81"));
                params.addElement(new StringValue("Approval Requested"));
                params.addElement(new StringValue(planID));
                params.addElement(new StringValue("Payment_Plan"));
                params.addElement(new StringValue((String) waUser.getAttribute("userId")));
                
                forInsert.setparams(params);
                queryResult = forInsert.executeUpdate();
                
                return true;
            }
        } catch (SQLException ex) {
            Logger.getLogger(PaymentPlanMgr.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        } finally {
            connection.setAutoCommit(true);
            connection.close();
        }
    }
     
     public boolean approvePaymentPlan(String planID, HttpSession s) throws SQLException {
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        Connection connection = null;
        int queryResult = -1000;
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        
        StringBuilder table = new StringBuilder();
        
        try {
            connection = dataSource.getConnection();

            params.addElement(new StringValue(planID));
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(getQuery("upPayPlanSt").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            if (queryResult < 0) {
                return false;
            } else {
                params = new Vector();                
                String issuesStID = UniqueIDGen.getNextID();
                forInsert.setSQLQuery(getQuery("insertPaymentPlanIssStatus").trim());
                
                params.addElement(new StringValue(issuesStID));
                params.addElement(new StringValue("82"));
                params.addElement(new StringValue("Approved"));
                params.addElement(new StringValue(planID));
                params.addElement(new StringValue("Payment_Plan"));
                params.addElement(new StringValue((String) waUser.getAttribute("userId")));
                
                forInsert.setparams(params);
                queryResult = forInsert.executeUpdate();
                
                return true;
            }
        } catch (SQLException ex) {
            Logger.getLogger(PaymentPlanMgr.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        } finally {
            connection.setAutoCommit(true);
            connection.close();
        }
    }
     
     public boolean rejectPaymentPlan(String planID, HttpSession s) throws SQLException {
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        Connection connection = null;
        int queryResult = -1000;
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        
        StringBuilder table = new StringBuilder();
        
        try {
            connection = dataSource.getConnection();

            params.addElement(new StringValue(planID));
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(getQuery("upPayPlanSt").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            if (queryResult < 0) {
                return false;
            } else {
                params = new Vector();                
                String issuesStID = UniqueIDGen.getNextID();
                forInsert.setSQLQuery(getQuery("insertPaymentPlanIssStatus").trim());
                
                params.addElement(new StringValue(issuesStID));
                params.addElement(new StringValue("83"));
                params.addElement(new StringValue("Rejected"));
                params.addElement(new StringValue(planID));
                params.addElement(new StringValue("Payment_Plan"));
                params.addElement(new StringValue((String) waUser.getAttribute("userId")));
                
                forInsert.setparams(params);
                queryResult = forInsert.executeUpdate();
                
                return true;
            }
        } catch (SQLException ex) {
            Logger.getLogger(PaymentPlanMgr.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        } finally {
            connection.setAutoCommit(true);
            connection.close();
        }
    }
    
    public ArrayList<WebBusinessObject> getPayPlan(String clientID) throws UnsupportedTypeException, NoSuchColumnException {
        ArrayList<WebBusinessObject> data = new ArrayList<>();
        Vector params = new Vector();
        WebBusinessObject wbo;
        Connection connection = null;

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getPayPlanByClient").trim());
            
            params.addElement(new StringValue(clientID));
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
                wbo = new WebBusinessObject();
                try {
                    wbo.setAttribute("ID", r.getString("PLAN_ID"));
                    wbo.setAttribute("planTitle", r.getString("PLAN_TITLE"));
                    wbo.setAttribute("unitID", r.getString("UNIT_ID"));
                    wbo.setAttribute("statusID", r.getString("STATUS_ID"));
                    wbo.setAttribute("statusTit", r.getString("ISSUE_TITLE"));
                    wbo.setAttribute("createdBy", r.getString("FULL_NAME"));
                    wbo.setAttribute("creationTime", r.getString("CREATION"));
                    data.add(wbo);
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(PaymentPlanMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
        
        return data;
    }
    
    public ArrayList<WebBusinessObject> getPayPlanInSpecificDay(String clientID, String Date) throws UnsupportedTypeException, NoSuchColumnException {
        ArrayList<WebBusinessObject> data = new ArrayList<>();
        Vector params = new Vector();
        WebBusinessObject wbo;
        Connection connection = null;

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getPayPlanInSpecificDay").trim());
            
            params.addElement(new StringValue(clientID));
            params.addElement(new StringValue(Date));
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
                wbo = new WebBusinessObject();
                try {
                    wbo.setAttribute("ID", r.getString("PLAN_ID"));
                    wbo.setAttribute("planTitle", r.getString("PLAN_TITLE"));
                    wbo.setAttribute("unitID", r.getString("UNIT_ID"));
                    wbo.setAttribute("statusID", r.getString("STATUS_ID"));
                    wbo.setAttribute("statusTit", r.getString("ISSUE_TITLE"));
                    wbo.setAttribute("clientNm", r.getString("NAME"));
                    wbo.setAttribute("unitNm", r.getString("UNIT_NAME"));
                    wbo.setAttribute("creationTime", r.getString("CREATION_DATE"));
                    data.add(wbo);
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(PaymentPlanMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
        
        return data;
    }
    
    public ArrayList<WebBusinessObject> getAllMyPayPlans(HttpSession s, String fromD, String toD, String reqTyp) throws UnsupportedTypeException, NoSuchColumnException {
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        ArrayList<WebBusinessObject> data = new ArrayList<>();
        Vector params = new Vector();
        WebBusinessObject wbo;
        Connection connection = null;
        StringBuilder where = new StringBuilder();
        
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            //AND TRUNC(CREATION_DATE) BETWEEN TO_DATE(?, 'YYYY-MM-DD') AND TO_DATE(?, 'YYYY-MM-DD')
            if(fromD != null && !fromD.isEmpty() &&  toD != null && !toD.isEmpty()){
                where.append(" AND TRUNC(PP.CREATION_DATE) BETWEEN TO_DATE('").append(fromD).append("','YYYY-MM-DD') AND TO_DATE('").append(toD).append("','YYYY-MM-DD')");
            }
            if(reqTyp != null && !reqTyp.isEmpty()){
                where.append(" AND ISS.ISSUE_TITLE = '").append(reqTyp).append("'");
            } else {
                //where.append("AND (ISS.ISSUE_TITLE = 'Approval Requested' OR ISS.ISSUE_TITLE = 'Approved' OR ISS.ISSUE_TITLE = 'Rejected')");
            }
            forQuery.setSQLQuery(getQuery("getAllMyPayPlans").trim()+ where.toString());
            
            params.addElement(new StringValue((String) waUser.getAttribute("userId")));
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
                wbo = fabricateBusObj(r);
                try {
                    wbo.setAttribute("ID", r.getString("PLAN_ID"));
                    wbo.setAttribute("statusID", r.getString("STATUS_ID"));
                    wbo.setAttribute("statusTit", r.getString("ISSUE_TITLE"));
                    wbo.setAttribute("CreationTime", r.getString("CREATION_DATE"));
                    wbo.setAttribute("clientName", r.getString("NAME"));
                    wbo.setAttribute("employeeName", r.getString("FULL_NAME"));
                    wbo.setAttribute("clientID", r.getString("CLIENT_ID"));
                    wbo.setAttribute("issueID", r.getString("ISSUE_ID"));
                    wbo.setAttribute("complaintID", r.getString("COMPLAINT_ID"));
                    wbo.setAttribute("reservationAmount", r.getString("RESERVATION_PAYMENT_AMOUNT"));
                    wbo.setAttribute("downPaymentAmount", r.getString("DOWN_PAYMENT_AMOUNT"));
                    wbo.setAttribute("parentID", r.getString("PARENT_ID") != null ? r.getString("PARENT_ID") : "");
                    wbo.setAttribute("unitName", r.getString("UNIT_NAME") != null ? r.getString("UNIT_NAME") : "");
                    wbo.setAttribute("mobile", r.getString("MOBILE") != null ? r.getString("MOBILE") : "");
                    wbo.setAttribute("interPhone", r.getString("INTER_PHONE") != null ? r.getString("INTER_PHONE") : "");
                    data.add(wbo);
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(PaymentPlanMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
        
        return data;
    }
    
    public ArrayList<WebBusinessObject> getPayPlanToAllClients(String fromD, String toD, String reqTyp) throws UnsupportedTypeException, NoSuchColumnException {
        ArrayList<WebBusinessObject> data = new ArrayList<>();
        Vector params = new Vector();
        WebBusinessObject wbo;
        Connection connection = null;

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        StringBuilder where = new StringBuilder();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            if(fromD != null && toD != null){
                if(reqTyp != null && !reqTyp.isEmpty()){
                    where.append("AND ISS.ISSUE_TITLE = '").append(reqTyp).append("'");
                } else {
                    where.append("AND (ISS.ISSUE_TITLE = 'Approval Requested' OR ISS.ISSUE_TITLE = 'Approved' OR ISS.ISSUE_TITLE = 'Rejected')");
                }
                
                //forQuery.setSQLQuery(getQuery("getPayPlanToAllClients").trim());
                forQuery.setSQLQuery(getQuery("getPayPlanToAllClients").trim() + where.toString());

                params.addElement(new StringValue(fromD));
                params.addElement(new StringValue(toD));

                forQuery.setparams(params);
            } else {
                if(reqTyp != null && !reqTyp.isEmpty()){
                    where.append("AND ISS.ISSUE_TITLE = '").append(reqTyp).append("'");
                } else {
                    where.append("AND (ISS.ISSUE_TITLE = 'Approval Requested' OR ISS.ISSUE_TITLE = 'Approved' OR ISS.ISSUE_TITLE = 'Rejected')");
                }
                forQuery.setSQLQuery(getQuery("getPayPlanToAllClientsWioutFilters").trim() + where.toString());
                forQuery.setparams(params);
            }
            
            

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
                wbo = new WebBusinessObject();
                try {
                    wbo.setAttribute("ID", r.getString("PLAN_ID"));
                    wbo.setAttribute("planTitle", r.getString("PLAN_TITLE"));
                    wbo.setAttribute("unitID", r.getString("UNIT_ID"));
                    wbo.setAttribute("statusID", r.getString("STATUS_ID"));
                    wbo.setAttribute("statusTit", r.getString("ISSUE_TITLE"));
                    wbo.setAttribute("CreationTime", r.getString("CREATION_DATE"));
                    wbo.setAttribute("clientName", r.getString("NAME"));
                    wbo.setAttribute("employeeName", r.getString("FULL_NAME"));
                    wbo.setAttribute("clientID", r.getString("CLIENT_ID"));
                    data.add(wbo);
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(PaymentPlanMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
        
        return data;
    }
    
    public WebBusinessObject getPayPlanDetails(String planID) throws UnsupportedTypeException, NoSuchColumnException {
        Vector params = new Vector();
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getPayPlanDetails").trim());
            
            params.addElement(new StringValue(planID));
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
                wbo = new WebBusinessObject();
                try {
                    wbo.setAttribute("finalPrice", r.getString("PAYMNET_AMT"));
                    wbo.setAttribute("unitID", r.getString("UNIT_ID"));
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(PaymentPlanMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
        
        return wbo;
    }
    
    public ArrayList<WebBusinessObject> getApprovedPlanDetails(String clientID, String unitID) {
        Vector params = new Vector();
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getApprovedPlanDetails").trim());
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
        ArrayList<WebBusinessObject> data = new ArrayList<>();
        Row r;
        if (queryResult != null) {
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = new WebBusinessObject();
                try {
                    if (r.getString("PAYMNET_ID") != null) {
                        wbo.setAttribute("paymentID", r.getString("PAYMNET_ID"));
                    }
                    if (r.getString("PLAN_ID") != null) {
                        wbo.setAttribute("planID", r.getString("PLAN_ID"));
                    }
                    if (r.getString("PAYMENT_AMT") != null) {
                        wbo.setAttribute("paymentAmount", r.getString("PAYMENT_AMT"));
                    }
                    if (r.getString("PAYMENT_DATE") != null) {
                        wbo.setAttribute("paymentDate", r.getString("PAYMENT_DATE"));
                    }
                    if (r.getString("PAYMENT_TYPE") != null) {
                        wbo.setAttribute("paymentType", r.getString("PAYMENT_TYPE"));
                    }
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(PaymentPlanMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                data.add(wbo);
            }
        }
        return data;
    }
    
    
    public ArrayList<WebBusinessObject> getIntallmentsToBeCollected(String fromDate, String toDate) {
        Vector params = new Vector();
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getIntallmentsToBeCollected").trim());
            params.addElement(new StringValue(fromDate));
            params.addElement(new StringValue(toDate));
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
        ArrayList<WebBusinessObject> data = new ArrayList<>();
        Row r;
        if (queryResult != null) {
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = new WebBusinessObject();
                try {
                    if (r.getString("CLIENT_NAME") != null) {
                        wbo.setAttribute("clientName", r.getString("CLIENT_NAME"));
                    } else {
                        wbo.setAttribute("clientName", "---");
                    }
                    if (r.getString("UNIT_NAME") != null) {
                        wbo.setAttribute("unitName", r.getString("UNIT_NAME"));
                    } else {
                        wbo.setAttribute("unitName", "---");
                    }
                    if (r.getString("PAYMENT_AMT") != null) {
                        wbo.setAttribute("paymentAmount", r.getString("PAYMENT_AMT"));
                    } else {
                        wbo.setAttribute("paymentAmount", "---");
                    }
                    if (r.getString("PAYMENT_TYPE") != null) {
                        wbo.setAttribute("paymentType", r.getString("PAYMENT_TYPE"));
                    } else {
                        wbo.setAttribute("paymentType", "---");
                    }
                    if (r.getString("PAYMENT_DATE") != null) {
                        wbo.setAttribute("paymentDate", r.getString("PAYMENT_DATE"));
                    } else {
                        wbo.setAttribute("paymentDate", "---");
                    }
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(PaymentPlanMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                data.add(wbo);
            }
        }
        return data;
    }
    
    public boolean saveInstallments(String planID, String[] paymentDate, String paymentTitle, String[] paymentAmount, String userID, String[] paymentType) {
        Connection connection = null;
        DateFormat dateFormat = new SimpleDateFormat("dd-MMM-yy");
        Calendar c = Calendar.getInstance();
        int queryResult = 0;
        try {
            Vector params;
            SQLCommandBean forInsert = new SQLCommandBean();
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(getQuery("insertPaymentPlanDetails").trim());
            for (int i = 0; i < paymentDate.length; i++) {
                params = new Vector();
                params.addElement(new StringValue(UniqueIDGen.getNextID()));
                params.addElement(new StringValue(planID));
                params.addElement(new StringValue(paymentTitle + " " + paymentType[i] + " payment"));
                params.addElement(new IntValue(Double.valueOf(paymentAmount[i]).intValue()));
                params.addElement(new StringValue(userID));
                params.addElement(new DateValue(new java.sql.Date(c.getTimeInMillis())));
                params.addElement(new DateValue(new java.sql.Date(dateFormat.parse(paymentDate[i]).getTime())));
                params.addElement(new StringValue(paymentType[i]));
                forInsert.setparams(params);
                queryResult = forInsert.executeUpdate();
            }
        } catch (SQLException ex) {
            logger.error(ex);
        } catch (ParseException ex) {
            Logger.getLogger(PaymentPlanMgr.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            if (connection != null) {
                try {
                    connection.setAutoCommit(true);
                    connection.close();
                } catch (SQLException ex) {
                    Logger.getLogger(PaymentPlanMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
        return queryResult > 0;
    }
    
    public ArrayList<LiteWebBusinessObject> getClientInstallments(String clientID) {
        Vector params = new Vector();
        LiteWebBusinessObject wbo = new LiteWebBusinessObject();
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            beginTransaction();
            forQuery.setConnection(transConnection);
            forQuery.setSQLQuery(getQuery("getClientInstallments").trim());
            params.addElement(new StringValue(clientID));
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            endTransaction();
        }
        ArrayList<LiteWebBusinessObject> data = new ArrayList<>();
        Row r;
        if (queryResult != null) {
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = new LiteWebBusinessObject();
                try {
                    wbo.setAttribute("businessID", r.getString("BUSINESS_ID") != null ? r.getString("BUSINESS_ID") : "");
                    wbo.setAttribute("inDate", r.getString("IN_DATE") != null ? r.getString("IN_DATE") : "");
                    wbo.setAttribute("total", r.getString("TOTAL") != null ? r.getString("TOTAL") : "");
                    data.add(wbo);
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(PaymentPlanMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
        return data;
    }

 public ArrayList<LiteWebBusinessObject> getClientInstallments(String clientID,String fromD,String toD) {
        Vector params = new Vector();
        LiteWebBusinessObject wbo = new LiteWebBusinessObject();
        Vector queryResult = null;
           StringBuilder where = new StringBuilder();

         if(fromD != null && !fromD.isEmpty()) {
            where.append(" AND TRUNC(PD.PAYMENT_DATE) >= TO_DATE('").append(fromD).append("','YYYY/MM/DD')");
        }
        
        if(toD != null && !toD .isEmpty()) {
            where.append(" AND TRUNC(PD.PAYMENT_DATE) <= TO_DATE('").append(toD).append("','YYYY/MM/DD')");
        }
        
        where.append(" ORDER BY PD.PAYMENT_DATE");
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            beginTransaction();
            forQuery.setConnection(transConnection);
            forQuery.setSQLQuery(getQuery("getClientInstallments1").trim()+where.toString());
            params.addElement(new StringValue(clientID));
            
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            endTransaction();
        }
        ArrayList<LiteWebBusinessObject> data = new ArrayList<>();
        Row r;
        if (queryResult != null) {
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = new LiteWebBusinessObject();
                try {
                    wbo.setAttribute("businessID", r.getString("BUSINESS_ID") != null ? r.getString("BUSINESS_ID") : "");
                    wbo.setAttribute("inDate", r.getString("IN_DATE") != null ? r.getString("IN_DATE") : "");
                    wbo.setAttribute("total", r.getString("TOTAL") != null ? r.getString("TOTAL") : "");
                    data.add(wbo);
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(PaymentPlanMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
        return data;
    }


}