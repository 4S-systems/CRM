package com.tracker.db_access;

import com.maintenance.common.DateParser;
import com.maintenance.common.Tools;
import com.maintenance.db_access.AverageUnitMgr;
import com.maintenance.db_access.ReadingRateUnitMgr;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import com.silkworm.common.SecurityUser;
import com.silkworm.persistence.relational.StringValue;
import java.sql.SQLException;
import java.util.*;
import javax.servlet.http.HttpSession;
import com.tracker.business_objects.*;
import com.tracker.common.*;
import com.silkworm.timeutil.*;
import java.sql.*;
import org.apache.log4j.xml.DOMConfigurator;

public class AssignedIssueMgr extends RDBGateWay {
    
    private static AssignedIssueMgr assIssueMgr = new AssignedIssueMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();
    SQLCommandBean forInsert = null;
    
//    private static final String insertIssueStatusSQL = "INSERT INTO issue_status VALUES (?,?,?,?,?,'2010-12-31 00:00:00.0',Tools.timeNow()(),?)";
//    private static final String updateIssueSQL ="UPDATE ISSUE SET CURRENT_STATUS=?, CURRENT_STATUS_SINCE = Tools.timeNow()(), ASSIGNED_BY_ID=?, ASSIGNED_BY_NAME=?, ASSIGNED_TO_ID= ? , ASSIGNED_TO_NAME= ? , TECHNICIAN_NAME = ? , FINISHED_TIME=? WHERE ID=?";
//    private static final String setIssueStatusSQL ="UPDATE ISSUE SET CURRENT_STATUS=?, CURRENT_STATUS_SINCE = Tools.timeNow()() WHERE ID=?";
//    private static final String setIssueStatusDateSQL ="UPDATE issue_status SET END_DATE = Tools.timeNow()(),TOTAL_TIME = ? WHERE END_DATE = 20101231000000 AND ISSUE_ID = ?";
    public static AssignedIssueMgr getInstance() {
        logger.info("Getting AssignedIssueMgr Instance ....");
        return assIssueMgr;
    }
    
    public AssignedIssueMgr() {
    }
    
    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("assigned_issue.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }
    
    public void saveObjectCost(String Uid, String Total) throws NoUserInSessionException {
        forInsert = new SQLCommandBean();
        Vector costV = new Vector();
        costV.addElement(new FloatValue(new Float(Total).floatValue()));
        costV.addElement(Uid);
        try {
            
            beginTransaction();
            forInsert.setConnection(transConnection);
            executeQuery(sqlMgr.getSql("updateIssueTotalCost").trim(), costV);
            
            endTransaction();
            
        } catch (SQLException sqex) {
            logger.error("***********************====********************>    " + Total);
            
        } finally {
            
        }
    }
    
    public boolean saveObject(WebBusinessObject wbo, HttpSession session, String assignNote, java.sql.Timestamp bdate) throws NoUserInSessionException {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;

        WebBusinessObject waUser = (WebBusinessObject) session.getAttribute("loggedUser");
        WebIssue issue = (WebIssue) wbo;
        Vector issueStatusParams = new Vector();
        Vector issueParams = new Vector();
        Vector setIssueStatusParams = new Vector();
        
        String beginDate = null;
        String endDate = null;
        
        /***** Get Virtual end date for first status *******/
        DateParser dateParser = new DateParser();
        java.sql.Date virtaulEDate = dateParser.getVirtalEndDate();
        java.sql.Timestamp virtaulEndDate = new java.sql.Timestamp(virtaulEDate.getTime());
        
        long lTemp;
        long lHours;
        DateServices dsDate = new DateServices();
        
        issueParams.addElement(new StringValue(AppConstants.LC_ASSIGNED));
        issueParams.addElement(new StringValue((String) waUser.getAttribute("userId")));
        issueParams.addElement(new StringValue((String) waUser.getAttribute("userName")));
        issueParams.addElement(new StringValue((String) issue.getAssignedToID()));
        issueParams.addElement(new StringValue((String) issue.getAssignedToName()));
        issueParams.addElement(new StringValue((String) issue.getAttribute("empID")));
        issueParams.addElement(new IntValue(new Integer(issue.getFinishedTime().toString())));
        issueParams.addElement(new TimestampValue(bdate));
        
        String sIssueID = null;
        sIssueID = (String) issue.getIssueID();
        issueParams.addElement(new StringValue(sIssueID));
        
        issueStatusParams.addElement(new StringValue(UniqueIDGen.getNextID()));
        issueStatusParams.addElement(new StringValue(AppConstants.LC_ASSIGNED));
        issueStatusParams.addElement(new StringValue(sIssueID));
        issueStatusParams.addElement(new StringValue((String) issue.getIssueTitle()));
        issueStatusParams.addElement(new StringValue(assignNote));
        issueStatusParams.addElement(new TimestampValue(virtaulEndDate));
        issueStatusParams.addElement(new StringValue("0"));
        
        IssueStatusMgr iStatusMgr = IssueStatusMgr.getInstance();
        WebBusinessObject lastIssueStatus = iStatusMgr.getLastIssueStatus(sIssueID);
        
        beginDate = (String) lastIssueStatus.getAttribute("beginDate");
        endDate = (String) lastIssueStatus.getAttribute("endDate");
        lTemp = dsDate.convertMySQLDate(endDate) - dsDate.convertMySQLDate(beginDate);
        lTemp = lTemp / (1000);
        lHours = lTemp / (60 * 60);
        if ((lTemp - (lHours * 60 * 60)) > 0) {
            lHours++;
        }
        setIssueStatusParams.addElement(new StringValue(String.valueOf(lHours)));
        setIssueStatusParams.addElement(new TimestampValue(virtaulEndDate));
        setIssueStatusParams.addElement(new StringValue(sIssueID));
        try {
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            command.setConnection(connection);

            command.setSQLQuery(sqlMgr.getSql("updateAssignedIssueStatus").trim());
            command.setparams(setIssueStatusParams);
            command.executeUpdate();

            command.setSQLQuery(sqlMgr.getSql("updateAssignedIssue").trim());
            command.setparams(issueParams);
            command.executeUpdate();

            command.setSQLQuery(sqlMgr.getSql("insertAssignedIssueStatus").trim());
            command.setparams(issueStatusParams);
            command.executeUpdate();
        } catch (SQLException sqex) {
            try {
               connection.rollback();
           } catch(SQLException sqex2) {
               logger.error(sqex2.getMessage());
               return (false);
           }
            logger.error("SQLException : " + sqex.getMessage());
            return (false);
        } finally {
           try {
               connection.commit();
               connection.close();
           } catch(SQLException sqex) {
               logger.error(sqex.getMessage());
               return (false);
           }
        }

        return (true);
    }
    
    public boolean assignedIssueAndUpdateEquipment(WebIssue webIssue, SecurityUser securityUser, WebBusinessObject averageUnit) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;

        Vector issueStatusParams = new Vector();
        Vector issueParams = new Vector();
        Vector setIssueStatusParams = new Vector();
        Vector issueCounterReadingParams = new Vector();
        Vector averageUnitParams = new Vector();
        Vector readingRateMachineParams = new Vector();

        String averageUnitQuery;
        String beginDate = null;
        String endDate = null;
        
        /***** Get Virtual end date for first status *******/
        DateParser dateParser = new DateParser();
        java.sql.Date virtaulEDate = dateParser.getVirtalEndDate();
        java.sql.Timestamp virtaulEndDate = new java.sql.Timestamp(virtaulEDate.getTime());
        
        long lTemp;
        long lHours;
        DateServices dsDate = new DateServices();

        // update issue current status
        issueParams.addElement(new StringValue(AppConstants.LC_ASSIGNED));
        issueParams.addElement(new StringValue(securityUser.getUserId()));
        issueParams.addElement(new StringValue(securityUser.getUserName()));
        issueParams.addElement(new StringValue((String) webIssue.getAssignedToID()));
        issueParams.addElement(new StringValue((String) webIssue.getAssignedToName()));
        issueParams.addElement(new StringValue((String) webIssue.getAttribute("empID")));
        issueParams.addElement(new IntValue(new Integer(webIssue.getFinishedTime().toString())));
        issueParams.addElement(new TimestampValue((Timestamp) webIssue.getAttribute("bDate")));
        
        String sIssueID = null;
        sIssueID = (String) webIssue.getIssueID();
        issueParams.addElement(new StringValue(sIssueID));

        // insert new row in issue_status
        issueStatusParams.addElement(new StringValue(UniqueIDGen.getNextID()));
        issueStatusParams.addElement(new StringValue(AppConstants.LC_ASSIGNED));
        issueStatusParams.addElement(new StringValue(sIssueID));
        issueStatusParams.addElement(new StringValue((String) webIssue.getIssueTitle()));
        issueStatusParams.addElement(new StringValue((String) webIssue.getAttribute("assignNote")));
        issueStatusParams.addElement(new TimestampValue(virtaulEndDate));
        issueStatusParams.addElement(new StringValue("0"));
        
        IssueStatusMgr iStatusMgr = IssueStatusMgr.getInstance();
        WebBusinessObject lastIssueStatus = iStatusMgr.getLastIssueStatus(sIssueID);
        
        beginDate = (String) lastIssueStatus.getAttribute("beginDate");
        endDate = (String) lastIssueStatus.getAttribute("endDate");
        lTemp = dsDate.convertMySQLDate(endDate) - dsDate.convertMySQLDate(beginDate);
        lTemp = lTemp / (1000);
        lHours = lTemp / (60 * 60);
        if ((lTemp - (lHours * 60 * 60)) > 0) {
            lHours++;
        }

        // update current row in issue_status
        setIssueStatusParams.addElement(new StringValue(String.valueOf(lHours)));
        setIssueStatusParams.addElement(new TimestampValue(virtaulEndDate));
        setIssueStatusParams.addElement(new StringValue(sIssueID));

        // insert new row in issue_counter_reading
        issueCounterReadingParams.addElement(new StringValue(UniqueIDGen.getNextID()));
        issueCounterReadingParams.addElement(new StringValue(sIssueID));
        issueCounterReadingParams.addElement(new StringValue((String) averageUnit.getAttribute("scheduleId")));
        issueCounterReadingParams.addElement(new StringValue((String) averageUnit.getAttribute("issueTitle")));
        issueCounterReadingParams.addElement(new IntValue(Integer.valueOf((String) averageUnit.getAttribute("currentReading"))));
        issueCounterReadingParams.addElement(new StringValue(securityUser.getUserId()));
        
        // save or update average_unit
        String existRowInAvgUnit = (String) averageUnit.getAttribute("existRowInAvgUnit");
        if(existRowInAvgUnit != null && existRowInAvgUnit.equals("no")) {
            averageUnitParams.addElement(new StringValue(UniqueIDGen.getNextID()));
            averageUnitParams.addElement(new IntValue(Integer.valueOf((String) averageUnit.getAttribute("currentReading"))));
            averageUnitParams.addElement(new IntValue(Integer.valueOf((String) averageUnit.getAttribute("0"))));
            averageUnitParams.addElement(new LongValue(Tools.timeNow()));
            averageUnitParams.addElement(new StringValue((String) averageUnit.getAttribute("description")));
            averageUnitParams.addElement(new LongValue(Tools.timeNow()));
            averageUnitParams.addElement(new StringValue((String) averageUnit.getAttribute("unitId")));
            averageUnitParams.addElement(new StringValue(sIssueID));
            averageUnitQuery = sqlMgr.getSql("insertAverageUnitSQLWithJO").trim();
        } else {
            
            averageUnitParams.addElement(new IntValue(Integer.valueOf((String) averageUnit.getAttribute("currentReading"))));
            averageUnitParams.addElement(new IntValue(Integer.valueOf((String) averageUnit.getAttribute("lastReading"))));
            averageUnitParams.addElement(new LongValue(Tools.timeNow()));
            averageUnitParams.addElement(new StringValue((String) averageUnit.getAttribute("description")));
            averageUnitParams.addElement(new LongValue(Long.valueOf((String) averageUnit.getAttribute("longLastDateReading"))));
            averageUnitParams.addElement(new StringValue(sIssueID));
            averageUnitParams.addElement(new StringValue((String) averageUnit.getAttribute("averageUnitId")));
            averageUnitQuery = sqlMgr.getSql("updateAverageUnitSQLWithJO").trim();
        }

         
        ReadingRateUnitMgr readingRateUnitMgr = ReadingRateUnitMgr.getInstance();
        String actionRead=null;
        try{
            Vector historyReadV = new Vector();
            historyReadV = readingRateUnitMgr.getOnArbitraryDoubleKey(averageUnit.getAttribute("unitId").toString(), "key1",sIssueID,"key2");
            if(historyReadV!=null){
                String x="1";
            }
            if(historyReadV.size()>0 && historyReadV.size()<2){
                    actionRead="update";
               }else{ 
                   actionRead ="insert";
               }           
        }catch(Exception e){

        }

        // insert new row in reading_rate_machine
            readingRateMachineParams.addElement(new StringValue(UniqueIDGen.getNextID()));
            readingRateMachineParams.addElement(new StringValue((String) averageUnit.getAttribute("currentReading")));
            readingRateMachineParams.addElement(new LongValue(Tools.timeNow()));
            readingRateMachineParams.addElement(new StringValue((String) averageUnit.getAttribute("description")));
            readingRateMachineParams.addElement(new StringValue((String) averageUnit.getAttribute("unitId")));
            readingRateMachineParams.addElement(new StringValue(sIssueID));

        

        

        try {
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            command.setConnection(connection);

            command.setSQLQuery(sqlMgr.getSql("updateAssignedIssueStatus").trim());
            command.setparams(setIssueStatusParams);
            command.executeUpdate();

            command.setSQLQuery(sqlMgr.getSql("updateAssignedIssue").trim());
            command.setparams(issueParams);
            command.executeUpdate();

            command.setSQLQuery(sqlMgr.getSql("insertAssignedIssueStatus").trim());
            command.setparams(issueStatusParams);
            command.executeUpdate();
            
            command.setSQLQuery(sqlMgr.getSql("insertIssueCounterReading").trim());
            command.setparams(issueCounterReadingParams);
            command.executeUpdate();
            
            command.setSQLQuery(sqlMgr.getSql("insertReadingRateUnitWithJO").trim());
            command.setparams(readingRateMachineParams);
            if(actionRead!=null && !actionRead.equals("") && actionRead.equals("insert")){
                command.executeUpdate();
            }

            
            command.setSQLQuery(averageUnitQuery);
            command.setparams(averageUnitParams);
            command.executeUpdate();
        } catch (SQLException sqex) {
            try {
               connection.rollback();
           } catch(SQLException sqex2) {
               logger.error(sqex2.getMessage());
               return (false);
           }
            logger.error("SQLException : " + sqex.getMessage());
            return (false);
        } finally {
           try {
               connection.commit();
               connection.close();
           } catch(SQLException sqex) {
               logger.error(sqex.getMessage());
               return (false);
           }
        }

        return (true);
    }

    private boolean executeQuery(String query, Vector p) throws SQLException {
        int queryResult = -1000;
        Vector averageUnitParams = p;
        
        try {
            forInsert.setSQLQuery(query);
            forInsert.setparams(averageUnitParams);
            queryResult = forInsert.executeUpdate();
        } catch (Exception ex) {
            logger.error("Save Assigned Issue Exception : " + ex.getMessage());
            return false;
        }
        
        return (queryResult > 0);
    }
    
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }
    
    public ArrayList getCashedTableAsArrayList() {
        return null;
    }
    
    public ArrayList getCashedTableAsBusObjects() {
        return null;
    }
    
    public boolean updateIssueState(WebBusinessObject wbo, HttpSession s, String state) throws NoUserInSessionException {
        
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        
        //B NEW
        Vector setIssueStatusParams = new Vector();
        String beginDate = null;
        String endDate = null;
        long lTemp;
        long lHours;
        String sTemp = null;
        DateServices dsDate = new DateServices();
        //E NEW
        WebIssue issue = (WebIssue) wbo;
        Vector issueStatusParams = new Vector();
        Vector issueParams = new Vector();
        forInsert = new SQLCommandBean();
        
        issueParams.addElement(new StringValue(state));
        issueParams.addElement(new StringValue((String) waUser.getAttribute("userId")));
        issueParams.addElement(new StringValue((String) waUser.getAttribute("userName")));
        issueParams.addElement(new StringValue((String) issue.getAssignedToID()));
        issueParams.addElement(new StringValue((String) issue.getAssignedToName()));
        issueParams.addElement(new StringValue((String) issue.getAttribute("techName")));
        issueParams.addElement(new IntValue(new Integer(issue.getFinishedTime().toString())));
        //issueParams.addElement(new StringValue((String)issue.getManagerNote()));
        String sIssueID = null;
        sIssueID = (String) issue.getIssueID();
        issueParams.addElement(new StringValue(sIssueID));
        
        issueStatusParams.addElement(new StringValue(UniqueIDGen.getNextID()));
        issueStatusParams.addElement(new StringValue(state));
        issueStatusParams.addElement(new StringValue((String) issue.getIssueID()));
        issueStatusParams.addElement(new StringValue((String) issue.getIssueTitle()));
        issueStatusParams.addElement(new StringValue((String) issue.getManagerNote()));
        issueStatusParams.addElement(new StringValue("0"));
        IssueStatusMgr iStatusMgr = IssueStatusMgr.getInstance();
        WebBusinessObject lastIssueStatus = iStatusMgr.getLastIssueStatus(sIssueID);
        //BB
        
        beginDate = (String) lastIssueStatus.getAttribute("beginDate");
        endDate = (String) lastIssueStatus.getAttribute("endDate");
        
        lTemp = dsDate.convertMySQLDateToLong(endDate) - dsDate.convertMySQLDateToLong(beginDate);
        lTemp = lTemp / (1000);
        lHours = lTemp / (60 * 60);
        if ((lTemp - (lHours * 60 * 60)) > 0) {
            lHours++;
        }
        
        setIssueStatusParams.addElement(new StringValue(sTemp.valueOf(lHours)));
        setIssueStatusParams.addElement(new StringValue(sIssueID));
        //EEEEE
        try {
            beginTransaction();
            forInsert.setConnection(transConnection);
            //B New
            executeQuery(sqlMgr.getSql("updateAssignedIssueStatus").trim(), setIssueStatusParams);
            //E New
            executeQuery(sqlMgr.getSql("insertAssignedIssueStatus").trim(), issueStatusParams);
            //executeQuery(setIssueStatusSQL,issueParams);
            executeQuery(sqlMgr.getSql("updateAssignedIssue").trim(), issueParams);
            endTransaction();
        } catch (SQLException sex) {
            return false;
        } finally {
            // return;
        }
        return true;
    }
    
    public Vector fillIssueUpdateParams(String state, String issueId) {
        Vector averageUnitParams = new Vector();
        
        averageUnitParams.addElement(new StringValue(state));
        averageUnitParams.addElement(new StringValue(issueId));
        
        return averageUnitParams;
    }
    
    public String getEndDate(String id) {
        
        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(id));
        
        Connection connection = null;
        String endDate = null;
        
        //StringBuffer query = new StringBuffer("SELECT END_DATE FROM ISSUE_STATUS WHERE ISSUE_ID = ? ");
        
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getEndDateForIssue").trim());
            forQuery.setparams(SQLparams);
            
            queryResult = forQuery.executeQuery();
            
            Row r = null;
            Enumeration e = queryResult.elements();
            
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                endDate = r.getString(1);
            }
            
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } catch (NoSuchColumnException nosuch) {
            logger.error("***** " + nosuch.getMessage());
            return null;
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return null;
            }
        }
        
        return endDate;
        
    }

    @Override
    protected void initSupportedQueries() {
     return; //   throw new UnsupportedOperationException("Not supported yet.");
    }
}
