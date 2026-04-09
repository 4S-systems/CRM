/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.planning.db_access;

import com.silkworm.business_objects.BusinessForm;
import com.silkworm.business_objects.DOMFabricatorBean;
import com.silkworm.business_objects.SqlMgr;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.persistence.relational.DateValue;
import com.silkworm.persistence.relational.FloatValue;
import com.silkworm.persistence.relational.IntValue;
import com.silkworm.persistence.relational.NoSuchColumnException;
import com.silkworm.persistence.relational.RDBGateWay;
import com.silkworm.persistence.relational.Row;
import com.silkworm.persistence.relational.SQLCommandBean;
import com.silkworm.persistence.relational.StringValue;
import com.silkworm.persistence.relational.UniqueIDGen;
import com.silkworm.persistence.relational.UnsupportedTypeException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Enumeration;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.log4j.xml.DOMConfigurator;

/**
 *
 * @author fatma
 */
public class StandardPaymentPlanMgr extends RDBGateWay{
    private static StandardPaymentPlanMgr standardPaymentPlanMgr = new StandardPaymentPlanMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();
    
    public static StandardPaymentPlanMgr getInstance() {
        logger.info("Getting StandardPaymentPlanMgr Instance ....");
        return standardPaymentPlanMgr;
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
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("standard_payment_plan.xml")));
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
    
    public String saveObject(String planName, String resAmnt, String downPayAmnt, String downMnth, String insPayAmntSys, String insMnth, String insNo, String userId, String insAMT, String projectID, String yearInsPayTyp, String yearInsPayVal, String yearMinInsPayVal) throws SQLException {
        Connection connection = null;
        String planID = null;
        try {
            int queryResult = 0;
            Vector params = new Vector();
            SQLCommandBean forInsert = new SQLCommandBean();
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            
            planID = UniqueIDGen.getNextID();
            
            if(downMnth == null || downMnth.equals(" ")|| downMnth.equals("")){
                downMnth = "0";
            }
            
            if(insPayAmntSys == null || insPayAmntSys.equals(" ") || insPayAmntSys.equals("")){
                insPayAmntSys = "0";
            }
            
            if(insMnth == null || insMnth.equals(" ") || insMnth.equals("")){
                insMnth = "0";
            }
            
            if(insNo == null || insNo.equals(" ") || insNo.equals("")){
                insNo = "0";
            }
            
            if(insAMT == null || insAMT.equals(" ") || insAMT.equals("")){
                insAMT = "0";
            }
            String mainType = null;
            if(yearInsPayTyp == null || yearInsPayTyp.equals(" ") || yearInsPayTyp.equals("")){
                mainType = "normal";
            } else {
                mainType = "dual";
            }
            
            Calendar c = Calendar.getInstance();
            
            String query = "INSERT INTO STANDARED_PAYMENT_PLAN (SPLAN_ID, PLAN_TITEL, RESERVATION_AMT, DOWN_PMT_AMT, DOWN_PMT_DATE, INSTALLMENT_SYS, FRIST_INSTALLMENT_DATE, INSTALLMENT_NUM, CREATED_BY, CREATION_DATE, INSTALLMENT_AMT, PROJECT_ID, yearInsPayTyp, yearInsPayVal, yearMinInsPayVal, MAINTYPE) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            //forInsert.setSQLQuery(getQuery("insertStandardPaymentPlan").trim());
            forInsert.setSQLQuery(query);
            
            params.addElement(new StringValue(planID));
            params.addElement(new StringValue(planName));
            params.addElement(new IntValue(Integer.parseInt(resAmnt)));
            params.addElement(new IntValue(Integer.parseInt(downPayAmnt)));
            params.addElement(new IntValue(Integer.parseInt(downMnth)));
            params.addElement(new IntValue(Integer.parseInt(insPayAmntSys)));
            params.addElement(new IntValue(Integer.parseInt(insMnth)));
            params.addElement(new IntValue(Integer.parseInt(insNo)));
            params.addElement(new StringValue(userId));
            params.addElement(new DateValue(new java.sql.Date(c.getTimeInMillis())));
            params.addElement(new StringValue(insAMT));
            params.addElement(new StringValue((projectID)));
            params.addElement(new StringValue((yearInsPayTyp)));
            if(yearInsPayVal != null && yearMinInsPayVal != null){
                params.addElement(new IntValue(Integer.parseInt(yearInsPayVal)));
                params.addElement(new IntValue(Integer.parseInt(yearMinInsPayVal)));
            } else {
                params.addElement(new IntValue(0));
                params.addElement(new IntValue(0));
            }
            params.addElement(new StringValue(mainType));

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
                    Logger.getLogger(StandardPaymentPlanMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
        
        return planID;
    }
    
    public boolean saveStndrPymntPlnRng(String planID, String resIDMin, String resIDMax, String downPayIDMin, String downPayIDMax, String insPayIDSelectMin, String insPayIDSelectMax) throws SQLException {
        Connection connection = null;
        try {
            int queryResult = 0;
            Vector params = new Vector();
            SQLCommandBean forInsert = new SQLCommandBean();
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
                        
            if(resIDMin == null || resIDMin.equals(" ")|| resIDMin.equals("")){
                resIDMin = "0";
            }
            
            if(resIDMax == null || resIDMax.equals(" ") || resIDMax.equals("")){
                resIDMax = "100";
            }
            
            if(downPayIDMin == null || downPayIDMin.equals(" ") || downPayIDMin.equals("")){
                downPayIDMin = "0";
            }
            
            if(downPayIDMax == null || downPayIDMax.equals(" ") || downPayIDMax.equals("")){
                downPayIDMax = "100";
            }
            
            if(insPayIDSelectMin == null || insPayIDSelectMin.equals(" ") || insPayIDSelectMin.equals("")){
                insPayIDSelectMin = "0";
            }
            
            if(insPayIDSelectMax == null || insPayIDSelectMax.equals(" ") || insPayIDSelectMax.equals("")){
                insPayIDSelectMax = "100";
            }
            
            Calendar c = Calendar.getInstance();
            
            String query = "INSERT INTO STNDRD_PYMNT_PLN_TOLERANCE VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'UL', 'UL', 'UL')";
            //forInsert.setSQLQuery(getQuery("insertStandardPaymentPlan").trim());
            forInsert.setSQLQuery(query);
            
            params.addElement(new StringValue(UniqueIDGen.getNextID()));
            params.addElement(new StringValue(planID));
            params.addElement(new FloatValue(Float.parseFloat(resIDMin)));
            params.addElement(new FloatValue(Float.parseFloat(resIDMax)));
            params.addElement(new FloatValue(Float.parseFloat(downPayIDMin)));
            params.addElement(new FloatValue(Float.parseFloat(downPayIDMax)));
            params.addElement(new FloatValue(Float.parseFloat(insPayIDSelectMin)));
            params.addElement(new FloatValue(Float.parseFloat(insPayIDSelectMax)));

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
                    Logger.getLogger(StandardPaymentPlanMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
        
        return true;
    }
    
    public ArrayList<WebBusinessObject> getStandaredPayPlans(String prjID, String typ){
        ArrayList<WebBusinessObject> data = new ArrayList<>();
        WebBusinessObject wbo;
        Connection connection = null;
        Vector params = new Vector();
        params.addElement(new StringValue(prjID));
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            if(prjID != null && !prjID.equals("") && !prjID.equals(" ")){
                if(typ != null && typ.equalsIgnoreCase("dpp")){
                    forQuery.setSQLQuery(getQuery("getStandardPaymentPlanFProjectForD").trim());
                } else {
                    forQuery.setSQLQuery(getQuery("getStandardPaymentPlanFProjectForSppCpp").trim());
                }
                forQuery.setparams(params);
            } else {
                forQuery.setSQLQuery(getQuery("getStandardPaymentPlan").trim());
            }
            

            try {
                queryResult = forQuery.executeQuery();
            } catch (UnsupportedTypeException ex) {
                Logger.getLogger(StandardPaymentPlanMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
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
                    wbo.setAttribute("ID", r.getString("SPLAN_ID"));
                    wbo.setAttribute("planTitle", r.getString("PLAN_TITEL"));
                    wbo.setAttribute("downAMT", r.getString("DOWN_PMT_AMT"));
                    wbo.setAttribute("insMon", r.getString("FRIST_INSTALLMENT_DATE"));
                    wbo.setAttribute("insSys", r.getString("INSTALLMENT_SYS"));
                    wbo.setAttribute("insNum", r.getString("INSTALLMENT_NUM"));
                    wbo.setAttribute("rsrvAMT", r.getString("RESERVATION_AMT"));
                    wbo.setAttribute("downDate", r.getString("DOWN_PMT_DATE"));
                    wbo.setAttribute("insAMT", r.getString("INSTALLMENT_AMT"));
                    if(r.getString("ID") != null){
                        wbo.setAttribute("toleranceID", r.getString("ID"));
                    } else {
                        wbo.setAttribute("toleranceID", "");
                    }
                    
                    if(r.getString("RESERVATION_AMT_MIN") != null){
                        wbo.setAttribute("rsrvAMTMin", r.getString("RESERVATION_AMT_MIN"));
                    } else {
                        wbo.setAttribute("rsrvAMTMin", "");
                    }
                    
                    if(r.getString("RESERVATION_AMT_MAX") != null){
                        wbo.setAttribute("rsrvAMTMax", r.getString("RESERVATION_AMT_MAX"));
                    } else {
                        wbo.setAttribute("rsrvAMTMax", "");
                    }
                    
                    if (r.getString("DOWN_PMT_AMT_MIN") != null) {
                        wbo.setAttribute("downAMTMin", r.getString("DOWN_PMT_AMT_MIN"));
                    } else {
                        wbo.setAttribute("downAMTMin", "");
                    }
                    
                    if (r.getString("DOWN_PMT_AMT_MAX") != null) {
                        wbo.setAttribute("downAMTMax", r.getString("DOWN_PMT_AMT_MAX"));
                    } else {
                        wbo.setAttribute("downAMTMax", "");
                    }
                    
                    if (r.getString("INSTALLMENT_NUM_MIN") != null) {
                        wbo.setAttribute("insAMTMin", r.getString("INSTALLMENT_NUM_MIN"));
                    } else {
                        wbo.setAttribute("insAMTMin", "");
                    }
                    
                    if (r.getString("YEARINSPAYTYP") != null) {
                        wbo.setAttribute("yearlyInsPayTyp", r.getString("YEARINSPAYTYP"));
                    } else {
                        wbo.setAttribute("yearlyInsPayTyp", "---");
                    }
                    if (r.getString("YEARINSPAYVAL") != null) {
                        wbo.setAttribute("yearlyInsPayVal", r.getString("YEARINSPAYVAL"));
                    } else {
                        wbo.setAttribute("yearlyInsPayVal", "---");
                    }
                    if (r.getString("YEARMININSPAYVAL") != null) {
                        wbo.setAttribute("yearlyMinVal", r.getString("YEARMININSPAYVAL"));
                    } else {
                        wbo.setAttribute("yearlyMinVal", "");
                    }
                    if (r.getString("INSTALLMENT_NUM_MAX") != null) {
                        wbo.setAttribute("insAMTMax", r.getString("INSTALLMENT_NUM_MAX"));
                    } else {
                        wbo.setAttribute("insAMTMax", "");
                    }
                    data.add(wbo);
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(PaymentPlanMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
        
        return data;
    }
    
    
    public ArrayList<WebBusinessObject> getPayPlansToProject(String prjID, String typ){
        ArrayList<WebBusinessObject> data = new ArrayList<>();
        WebBusinessObject wbo;
        Connection connection = null;
        Vector params = new Vector();
        
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        params.addElement(new StringValue(prjID));
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            if(prjID != null && !prjID.equals("") && !prjID.equals(" ")){
                if(typ != null && typ.equalsIgnoreCase("dpp")){
                    forQuery.setSQLQuery("SELECT SPP.SPLAN_ID, SPP.CREATION_DATE, SPP.PLAN_TITEL,SPP.PMT_AMT, SPP.DOWN_PMT_AMT,SPP.DOWN_PMT_DATE, SPP.FRIST_INSTALLMENT_DATE,SPP.INSTALLMENT_SYS, SPP.INSTALLMENT_NUM,SPP.RESERVATION_AMT, SPP.INSTALLMENT_AMT,SPP.YEARINSPAYTYP,SPP.YEARINSPAYVAL,SPP.YEARMININSPAYVAL,SPP.MAINTYPE, U.FULL_NAME, P.PROJECT_NAME FROM STANDARED_PAYMENT_PLAN SPP LEFT JOIN USERS U ON SPP.CREATED_BY = U.USER_ID LEFT JOIN PROJECT P ON SPP.PROJECT_ID = P.PROJECT_ID WHERE SPP.PROJECT_ID = ? AND SPP.MAINTYPE = 'dual'");
                } else {
                    forQuery.setSQLQuery("SELECT SPP.SPLAN_ID, SPP.CREATION_DATE, SPP.PLAN_TITEL,SPP.PMT_AMT, SPP.DOWN_PMT_AMT,SPP.DOWN_PMT_DATE, SPP.FRIST_INSTALLMENT_DATE,SPP.INSTALLMENT_SYS, SPP.INSTALLMENT_NUM,SPP.RESERVATION_AMT, SPP.INSTALLMENT_AMT,SPP.YEARINSPAYTYP,SPP.YEARINSPAYVAL,SPP.YEARMININSPAYVAL,SPP.MAINTYPE, U.FULL_NAME, P.PROJECT_NAME FROM STANDARED_PAYMENT_PLAN SPP LEFT JOIN USERS U ON SPP.CREATED_BY = U.USER_ID LEFT JOIN PROJECT P ON SPP.PROJECT_ID = P.PROJECT_ID WHERE SPP.PROJECT_ID = ? AND SPP.MAINTYPE <> 'dual'");
                }
                forQuery.setparams(params);
            } else {
                forQuery.setSQLQuery("SELECT SPP.SPLAN_ID, SPP.CREATION_DATE, SPP.PLAN_TITEL,SPP.PMT_AMT, SPP.DOWN_PMT_AMT,SPP.DOWN_PMT_DATE, SPP.FRIST_INSTALLMENT_DATE,SPP.INSTALLMENT_SYS, SPP.INSTALLMENT_NUM,SPP.RESERVATION_AMT, SPP.INSTALLMENT_AMT,SPP.YEARINSPAYTYP,SPP.YEARINSPAYVAL,SPP.YEARMININSPAYVAL,SPP.MAINTYPE, U.FULL_NAME, P.PROJECT_NAME FROM STANDARED_PAYMENT_PLAN SPP LEFT JOIN USERS U ON SPP.CREATED_BY = U.USER_ID LEFT JOIN PROJECT P ON SPP.PROJECT_ID = P.PROJECT_ID");
            }
            
            try {
                queryResult = forQuery.executeQuery();
            } catch (UnsupportedTypeException ex) {
                Logger.getLogger(StandardPaymentPlanMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
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
                    wbo.setAttribute("ID", r.getString("SPLAN_ID"));
                    wbo.setAttribute("planTitle", r.getString("PLAN_TITEL"));
                    wbo.setAttribute("downAMT", r.getString("DOWN_PMT_AMT"));
                    wbo.setAttribute("insMon", r.getString("FRIST_INSTALLMENT_DATE"));
                    wbo.setAttribute("insSys", r.getString("INSTALLMENT_SYS"));
                    wbo.setAttribute("insNum", r.getString("INSTALLMENT_NUM"));
                    wbo.setAttribute("rsrvAMT", r.getString("RESERVATION_AMT"));
                    wbo.setAttribute("downDate", r.getString("DOWN_PMT_DATE"));
                    wbo.setAttribute("insAMT", r.getString("INSTALLMENT_AMT"));
                    if(r.getString("PROJECT_NAME") != null){
                        wbo.setAttribute("projectNM", r.getString("PROJECT_NAME"));
                    } else {
                        wbo.setAttribute("projectNM", "---");
                    }
                    
                    if(r.getString("YEARMININSPAYVAL") == null){
                        wbo.setAttribute("yearMinInsVal", "---");
                    } else {
                        wbo.setAttribute("yearMinInsVal", r.getString("YEARMININSPAYVAL"));
                    }
                    
                    if(r.getString("YEARINSPAYTYP") == null){
                        wbo.setAttribute("yearInsTyp", "---");
                    } else {
                        wbo.setAttribute("yearInsTyp", r.getString("YEARINSPAYTYP"));
                    }
                    
                    if(r.getString("YEARINSPAYVAL") == null){
                        wbo.setAttribute("yearInsVal", "---");
                    } else {
                        wbo.setAttribute("yearInsVal", r.getString("YEARINSPAYVAL"));
                    }
                    
                    if(r.getString("MAINTYPE") == null){
                        wbo.setAttribute("mainTyp", "---"); 
                    } else {
                       wbo.setAttribute("mainTyp", r.getString("MAINTYPE"));
                    }
                    
                    if(r.getString("CREATION_DATE") != null){
                        wbo.setAttribute("creationTime", r.getString("CREATION_DATE"));
                    } else {
                        wbo.setAttribute("creationTime", "---");
                    }
                    if(r.getString("FULL_NAME") != null){
                        wbo.setAttribute("createdBy", r.getString("FULL_NAME"));
                    } else {
                        wbo.setAttribute("createdBy", "---");
                    }
                    
                    data.add(wbo);
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(PaymentPlanMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
        
        return data;
    }
}