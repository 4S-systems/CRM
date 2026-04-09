package com.maintenance.db_access;

import com.maintenance.common.DateParser;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import java.sql.SQLException;
import com.silkworm.util.*;
import java.util.*;
import java.text.*;
import javax.servlet.http.HttpSession;
import java.sql.*;

import com.tracker.business_objects.*;
import org.apache.log4j.xml.DOMConfigurator;

public class QuantMntenceCmplxMgr extends RDBGateWay {
    
    private static QuantMntenceCmplxMgr quantMntenceCmplxMgr = new QuantMntenceCmplxMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();
//    private static final String insertIssueSQL = "INSERT INTO ISSUE_TYPE VALUES (?,?,now(),?)";
//    private static final String stItemSQL = "SELECT * FROM quantified_mntence WHERE SCHEDULE_ID = ?";
    public static QuantMntenceCmplxMgr getInstance() {
        logger.info("Getting IssueMaintenanceMgr Instance ....");
        return quantMntenceCmplxMgr;
    }
    
    
    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("quantified_maintainance_cmplx.xml")));
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
            logger.error("i can't do delete in QuantifiedMntenceMGR");
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
    
    public void saveObject(String[] qun, String[] pr, String[] cost, String[] note, String[] id, String Uid,String isDirectPrch, HttpSession s) {
        
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        
        int size = qun.length;
        
        Connection connection = null;
        SQLCommandBean forInsert = new SQLCommandBean();
        try {
            
            connection = dataSource.getConnection();
            for (int i = 0; i < size; i++) {
                forInsert.setConnection(connection);
                forInsert.setSQLQuery(sqlMgr.getSql("insertQuantifiedMntence").trim());
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
    
    public boolean saveObject2(String[] qun, String[] pr, String[] cost, String[] note,String[] cIssueIndex,String issueId, String[] id, String Uid,String isDirectPrch,String[] attachedOn, HttpSession s,String []dates) {
        
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        
        int size = qun.length;
        int queryResult = -1000;
        
        Connection connection = null;
        SQLCommandBean forInsert = new SQLCommandBean();
        try {
            
            connection = dataSource.getConnection();
            for (int i = 0; i < size; i++) {
                forInsert.setConnection(connection);
                String query="INSERT INTO QUANIFIED_MNTENCE_CMPLX VALUES (?, ?, ?, ?, ?, ?, ?, ?, SYSDATE,?,?,?,?,?)";
                forInsert.setSQLQuery(query.trim());
                Vector params = new Vector();
                String dateValue=dates[i].replaceAll("-","/");
//                String []beDate = dateValue.split("/");
//                int disYear=Integer.parseInt(beDate[2]);
//                int disMonth=Integer.parseInt(beDate[0]);
//                int disDay=Integer.parseInt(beDate[1]);
//                java.sql.Date dispenseDate = new java.sql.Date(disYear-1900,disMonth-1,disDay);
                
                DateParser dateParser=new DateParser();
                java.sql.Date dispenseDate=dateParser.formatSqlDate(dateValue);
                
                java.sql.Timestamp disDate = new java.sql.Timestamp(dispenseDate.getTime());
                
                params.addElement(new StringValue(UniqueIDGen.getNextID()));
                params.addElement(new StringValue(Uid));
                params.addElement(new StringValue(id[i]));
                params.addElement(new FloatValue(new Float(qun[i]).floatValue()));
                params.addElement(new FloatValue(new Float(pr[i]).floatValue()));
                params.addElement(new FloatValue(new Float(cost[i]).floatValue()));
                params.addElement(new StringValue(note[i]));
                params.addElement(new StringValue((String) waUser.getAttribute("userId")));
                params.addElement(new StringValue(isDirectPrch));
                params.addElement(new StringValue(attachedOn[i]));
                params.addElement(new StringValue(issueId));
                params.addElement(new StringValue(cIssueIndex[i]));
                params.addElement(new TimestampValue(disDate));
                
                forInsert.setparams(params);
                queryResult = forInsert.executeUpdate();
                try {
                    Thread.sleep(200);
                } catch (InterruptedException ex) {
                    logger.error(ex.getMessage());
                    return false;
                }
                
            }
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
        return queryResult>0;
    }
    
    /* overloaded becouse in this case we didn't have the despense date
     because it added forward to maintenece items*/
    public boolean saveObject2(String[] qun, String[] pr, String[] cost, String[] note,String[] cIssueIndex,String issueId, String[] id, String Uid,String isDirectPrch,String[] attachedOn, HttpSession s) {
        
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        
        int size = qun.length;
        int queryResult = -1000;
        
        Connection connection = null;
        SQLCommandBean forInsert = new SQLCommandBean();
        try {
            
            connection = dataSource.getConnection();
            for (int i = 0; i < size; i++) {
                forInsert.setConnection(connection);
                String query="INSERT INTO QUANIFIED_MNTENCE_CMPLX VALUES (?, ?, ?, ?, ?, ?, ?, ?, SYSDATE,?,?,?,?,SYSDATE)";
                forInsert.setSQLQuery(query.trim());
                Vector params = new Vector();
                
                params.addElement(new StringValue(UniqueIDGen.getNextID()));
                params.addElement(new StringValue(Uid));
                params.addElement(new StringValue(id[i]));
                params.addElement(new FloatValue(new Float(qun[i]).floatValue()));
                params.addElement(new FloatValue(new Float(pr[i]).floatValue()));
                params.addElement(new FloatValue(new Float(cost[i]).floatValue()));
                params.addElement(new StringValue(note[i]));
                params.addElement(new StringValue((String) waUser.getAttribute("userId")));
                params.addElement(new StringValue(isDirectPrch));
                params.addElement(new StringValue(attachedOn[i]));
                params.addElement(new StringValue(issueId));
                params.addElement(new StringValue(cIssueIndex[i]));
                
                forInsert.setparams(params);
                queryResult = forInsert.executeUpdate();
                try {
                    Thread.sleep(200);
                } catch (InterruptedException ex) {
                    logger.error(ex.getMessage());
                    return false;
                }
                
            }
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
        return queryResult>0;
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
    
    public Vector getSpecialItemSchedule(String issueId,String isDirectPrch) {
        
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector SQLparams = new Vector();
        
        SQLparams.addElement(new StringValue(issueId));
        SQLparams.addElement(new StringValue(isDirectPrch));
        
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("stSpecialItemCmplxSQL").trim());
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

    @Override
    protected void initSupportedQueries() {
    return; //    throw new UnsupportedOperationException("Not supported yet.");
    }
    
    
}
