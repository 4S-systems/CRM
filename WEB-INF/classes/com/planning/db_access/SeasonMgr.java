/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.planning.db_access;

import com.maintenance.common.DateParser;
import com.silkworm.business_objects.BusinessForm;
import com.silkworm.business_objects.DOMFabricatorBean;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.jsptags.DropdownDate;
import com.silkworm.persistence.relational.DateValue;
import com.silkworm.persistence.relational.IntValue;
import com.silkworm.persistence.relational.LongValue;
import com.silkworm.persistence.relational.NoSuchColumnException;
import com.silkworm.persistence.relational.RDBGateWay;
import com.silkworm.persistence.relational.Row;
import com.silkworm.persistence.relational.SQLCommandBean;
import com.silkworm.persistence.relational.StringValue;
import com.silkworm.persistence.relational.TimestampValue;
import com.silkworm.persistence.relational.UniqueIDGen;
import com.silkworm.persistence.relational.UnsupportedConversionException;
import com.silkworm.persistence.relational.UnsupportedTypeException;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Enumeration;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.log4j.xml.DOMConfigurator;

/**
 *
 * @author Waled
 */
public class SeasonMgr extends RDBGateWay {
    
    public static SeasonMgr seasonMgr = new SeasonMgr();  
    
     public static SeasonMgr getInstance() {
        logger.info("Getting SeasonMgr Instance ....");
        return seasonMgr;
    } 
    @Override
    protected void initSupportedForm() {
       if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("season_Type.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet.");
    }
    public ArrayList getAllSeasonCodes(){
        Vector queryResult = new Vector();
        SQLCommandBean getCodes = new SQLCommandBean();
         try {
            //connection = dataSource.getConnection();
            beginTransaction();
            getCodes.setConnection(transConnection);
            getCodes.setSQLQuery(getQuery("getAllSeasoncodes").trim());
            queryResult = getCodes.executeQuery();
            endTransaction(); 
        } catch (SQLException se) {
            logger.error(se.getMessage());
          
        } catch(UnsupportedTypeException utb){
            logger.error(utb.getMessage());
        }       
        ArrayList reultBusObjs = new ArrayList();
        Row r = null;
        Enumeration e = queryResult.elements();
        WebBusinessObject wbo = null;
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = fabricateBusObj(r);
            reultBusObjs.add(wbo);
        }
        return reultBusObjs;
    }
    
    public WebBusinessObject getSpecificSeasonTypeCodes( String name){
        Vector queryResult = new Vector();
        Vector params = new Vector();
        params.addElement(new StringValue(name));
        SQLCommandBean getCodes = new SQLCommandBean();
         try {
            //connection = dataSource.getConnection();
            beginTransaction();
            getCodes.setConnection(transConnection);
            getCodes.setSQLQuery(getQuery("getSpecificCodeForSType").trim());
            getCodes.setparams(params);
            queryResult = getCodes.executeQuery();
            endTransaction(); 
        } catch (SQLException se) {
            logger.error(se.getMessage());
          
        } catch(UnsupportedTypeException utb){
            logger.error(utb.getMessage());
        }       
        ArrayList reultBusObjs = new ArrayList();
        Row r = null;
        Enumeration e = queryResult.elements();
        WebBusinessObject wbo = null;
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = fabricateBusObj(r);
           // reultBusObjs.add(wbo);
        }
        return wbo;
    }
    public boolean saveSeason(HttpServletRequest request,HttpSession s){
        
         WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1;
        String Id = UniqueIDGen.getNextID();
        params.addElement(new StringValue(Id));
        params.addElement(new StringValue(request.getParameter("code")));
        params.addElement(new StringValue(request.getParameter("english_name")));
        params.addElement(new StringValue(request.getParameter("arabic_name")));
        params.addElement(new StringValue("red")); // default image name
        params.addElement(new StringValue(request.getParameter("display") != null ? "1" : "0"));
        params.addElement(new IntValue(0));
        params.addElement(new IntValue(0));
        params.addElement(new StringValue((String) waUser.getAttribute("userId")));
        try {
            //connection = dataSource.getConnection();
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(getQuery("insertSeason").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            endTransaction(); 
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        }
        return (queryResult>0);
    }

    public boolean updateSeason(HttpServletRequest request){


        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1;
        
        params.addElement(new StringValue(request.getParameter("code")));
        params.addElement(new StringValue(request.getParameter("english_name")));
        params.addElement(new StringValue(request.getParameter("arabic_name")));
//        params.addElement(new StringValue(request.getParameter("begin_date")));
//        params.addElement(new StringValue(request.getParameter("end_date")));
        params.addElement(new IntValue(0));
        params.addElement(new IntValue(0));
        params.addElement(new StringValue(request.getParameter("display") != null ? "1" : "0"));
        params.addElement(new StringValue(request.getParameter("seasonTypeId")));
        try {
            //connection = dataSource.getConnection();
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(getQuery("updateSeason").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            endTransaction();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        }
        return (queryResult>0);
    }
    
    public ArrayList<WebBusinessObject> communicationChannelsComparison(String[] chnls, String yr, String mnth){
        Vector queryResult = new Vector();
        SQLCommandBean getCodes = new SQLCommandBean();
        
        Vector params = new Vector();
        StringBuilder whrStmnt = new StringBuilder();
        if(chnls != null && chnls.length > 0 && (chnls[0] != null && !chnls[0].equalsIgnoreCase("null"))){
            whrStmnt.append(" AND ST.ID IN (");
            for (int i = 0; i < chnls.length; i++) {
                whrStmnt.append("?");
                params.addElement(new StringValue(chnls[i]));
                if(i<chnls.length-1){
                    whrStmnt.append(",");
                } else {
                    whrStmnt.append(")");
                }
            }
        }
        
        if(yr != null && !yr.isEmpty()){
            whrStmnt.append(" AND EXTRACT(YEAR FROM CL.CREATION_TIME) = ?");
            params.addElement(new StringValue(yr));
        }
        
        if(mnth != null && !mnth.isEmpty()){
            whrStmnt.append(" AND EXTRACT(MONTH FROM CL.CREATION_TIME) = ?");
            params.addElement(new StringValue(mnth));
        }
        
        try {
            beginTransaction();
            getCodes.setConnection(transConnection);
            getCodes.setSQLQuery(getQuery("communicationChannelsComparison").replaceAll("whrStmnt", whrStmnt.toString()).trim());
            getCodes.setparams(params);
            queryResult = getCodes.executeQuery();
            endTransaction(); 
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } catch(UnsupportedTypeException utb){
            logger.error(utb.getMessage());
        }       
        ArrayList reultBusObjs = new ArrayList();
        Row r = null;
        Enumeration e = queryResult.elements();
        WebBusinessObject wbo = null;
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            try {
                if(r.getString("ENGLISHNAME") != null){
                    wbo.setAttribute("engNm", r.getString("ENGLISHNAME"));
                } else {
                    wbo.setAttribute("engNm", "");
                }
                
                if(r.getString("ARABICNAME") != null){
                    wbo.setAttribute("arbNm", r.getString("ARABICNAME"));
                } else {
                    wbo.setAttribute("arbNm", "");
                }

                if(r.getString("CLNT_CNT") != null){
                    wbo.setAttribute("clntCnt", r.getString("CLNT_CNT"));
                } else {
                    wbo.setAttribute("clntCnt", "");
                }
                
                if(r.getString("YEAR") != null){
                    wbo.setAttribute("year", r.getString("YEAR"));
                } else {
                    wbo.setAttribute("year", "");
                }
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(SeasonMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            
            reultBusObjs.add(wbo);
        }
        return reultBusObjs;
    }
    
    @Override
    protected void initSupportedQueries() {
         queriesIS = metaDataMgr.getQueries(queriesPropFileName);
         return;
    }

    @Override
    public ArrayList getCashedTableAsArrayList() {
        return new ArrayList<>(getCashedTable());
    }
    
    public ArrayList<WebBusinessObject> getChannlesExpenses(java.sql.Date fromDate, java.sql.Date toDate) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> result;
        Vector parameters = new Vector();
        String query = getQuery("getChannlesExpenses").trim();
        StringBuilder where = new StringBuilder();
        parameters.addElement(new DateValue(fromDate));
        parameters.addElement(new DateValue(toDate));
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(query.trim());
            command.setparams(parameters);
            result = command.executeQuery();
            ArrayList<WebBusinessObject> data = new ArrayList<>();
            WebBusinessObject wbo;
            for (Row row : result) {
                wbo = fabricateBusObj(row);
                try {
                    wbo.setAttribute("expenseDate", row.getString("EXPENSE_DATE") != null ? row.getString("EXPENSE_DATE") : "");
                    wbo.setAttribute("currencyType", row.getString("CURRENCY_TYPE") != null ? row.getString("CURRENCY_TYPE") : "");
                    wbo.setAttribute("amount", row.getString("AMOUNT") != null ? row.getString("AMOUNT") : "");
                    wbo.setAttribute("companyName", row.getString("COMPANY_NAME") != null ? row.getString("COMPANY_NAME") : "");
                    wbo.setAttribute("exchangeRate", row.getString("EXCHANGE_RATE") != null ? row.getString("EXCHANGE_RATE") : "");
                    wbo.setAttribute("paidAmount", row.getString("PAID_AMOUNT") != null ? row.getString("PAID_AMOUNT") : "");
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(SeasonMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                data.add(wbo);
            }
            return data;
        } catch (UnsupportedTypeException | SQLException ex) {
            Logger.getLogger(SeasonMgr.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }
        return new ArrayList<>();
    }
    
    public ArrayList<WebBusinessObject> getCommunicationsClassificationsStat(java.sql.Date fromDate, java.sql.Date toDate, ArrayList<String> ratesNames, String groupID) {
        WebBusinessObject wbo;
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();
        params.addElement(new DateValue(fromDate));
        params.addElement(new DateValue(toDate));
        params.addElement(new StringValue(groupID != null ? groupID : ""));
        try {
            StringBuilder count = new StringBuilder();
            for (int i = 0; i < ratesNames.size(); i++) {
                count.append(", COUNT (CASE WHEN P.PROJECT_NAME = '").append(ratesNames.get(i)).append("' THEN CL.SYS_ID END) RATE").append(i);
            }
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            String sql = getQuery("getCommunicationsClassificationsStat");
            sql = sql.replaceFirst("countStatement", count.toString()).trim();
            forQuery.setSQLQuery(sql);
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
                logger.error(ex.getMessage());
            }
        }
        ArrayList<WebBusinessObject> resultBusObjs = new ArrayList<>();
        Row r = null;
        Enumeration e = queryResult.elements();
        try {
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = new WebBusinessObject();
                if (r.getString("CHANNEL_NAME") != null) {
                    wbo.setAttribute("channelName", r.getString("CHANNEL_NAME"));
                }
                for (int i = 0; i < ratesNames.size(); i++) {
                    if (r.getBigDecimal("RATE" + i) != null) {
                        wbo.setAttribute("rate" + i, r.getBigDecimal("RATE" + i));
                    }
                }
                resultBusObjs.add(wbo);
            }
        } catch (NoSuchColumnException | UnsupportedConversionException ce) {
            logger.error(ce);
        }
        return resultBusObjs;
    }
    
    public boolean updateSeasonDisplayHide(String id, String display) {
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1;
        params.addElement(new StringValue(display));
        params.addElement(new StringValue(id));
        try {
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(getQuery("updateSeasonDisplayHide").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            endTransaction();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        }
        return (queryResult > 0);
    }
    
    public String getSeasonTotalClientsNo(String id) {
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();
        params.addElement(new StringValue(id));
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getSeasonTotalClientsNo"));
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
                logger.error(ex.getMessage());
            }
        }
        Row r = null;
        Enumeration e = queryResult.elements();
        try {
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                if (r.getString("TOTAL_NO") != null) {
                    return r.getString("TOTAL_NO");
                }
            }
        } catch (NoSuchColumnException ce) {
            logger.error(ce);
        }
        return "0";
    }
}
