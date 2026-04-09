/*
 * EquipByIssueMgr.java
 *
 * Created on October 13, 2008, 11:15 AM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.maintenance.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import com.silkworm.util.*;

import java.util.*;
import java.text.*;
import java.sql.*;
import javax.servlet.http.HttpSession;
import org.apache.log4j.xml.DOMConfigurator;

public class ActionTakenMgr extends RDBGateWay {

    private static ActionTakenMgr actionTakenMgr = new ActionTakenMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();

    public ActionTakenMgr() {
    }

    public static ActionTakenMgr getInstance() {
        logger.info("Getting EquipByIssueMgr Instance ....");
        return actionTakenMgr;
    }

    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("action_taken.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public ArrayList getCashedTableAsArrayList() {
        return null;
    }

public boolean saveActionTaken(WebBusinessObject wboActionTaken ,HttpSession s) {
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue((String) wboActionTaken.getAttribute("historyId")));
        params.addElement(new StringValue((String) wboActionTaken.getAttribute("scheduleId")));
        params.addElement(new StringValue((String) wboActionTaken.getAttribute("rateNo")));
        params.addElement(new StringValue((String) wboActionTaken.getAttribute("unitId")));
        params.addElement(new StringValue((String) wboActionTaken.getAttribute("readingCounter")));
        params.addElement(new StringValue((String) waUser.getAttribute("userId")));
        
        
        
        
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertActionTacken").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
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

    public boolean updateActionTakenAsIssue(WebBusinessObject wboActionTaken ) {
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue((String) wboActionTaken.getAttribute("issueId")));
        params.addElement(new StringValue((String) wboActionTaken.getAttribute("historyId")));
        params.addElement(new StringValue((String) wboActionTaken.getAttribute("readingCounter")));
        Connection connection = null;
        
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("updateActionTakenByIssue").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
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

    public boolean updateActionTakenAsCancel(WebBusinessObject wboActionTaken ) {
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue((String) wboActionTaken.getAttribute("cancelReason")));
        params.addElement(new StringValue((String) wboActionTaken.getAttribute("historyId")));
        params.addElement(new StringValue((String) wboActionTaken.getAttribute("readingCounter")));
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("updateActionTakenByCancel").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
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
     public Vector getLastIssueByAction(String unitId ,String readingCounter) {
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        Vector queryResult = new Vector();
        Vector queryAsBus = new Vector();

        params.addElement(new StringValue(unitId));
        params.addElement(new StringValue(readingCounter));
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("selectLastIssuesByAction").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeQuery();
        } catch (Exception se) {
            logger.error(se.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        String issueId;
        Row row;
         for (int i = 0; i < queryResult.size(); i++) {
            row = (Row) queryResult.get(i);
            try{
                issueId = row.getString("ISSUE_ID");
                queryAsBus.add(issueId);
            }catch(NoSuchColumnException ex){
                logger.error(ex.getMessage());
            }
         }

        return queryAsBus;
    }

    @Override
    protected void initSupportedQueries() {
        return; //throw new UnsupportedOperationException("Not supported yet.");
    }
    
}
