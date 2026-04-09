package com.planning.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import java.sql.SQLException;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.http.HttpSession;
import java.sql.*;
import org.apache.log4j.xml.DOMConfigurator;

public class PlanIssueMgr extends RDBGateWay {

    private static PlanIssueMgr planIssueMgr = new PlanIssueMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();

    public static PlanIssueMgr getInstance() {
        logger.info("Getting PlanIssueMgr Instance ....");
        return planIssueMgr;
    }

    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("plan_issue.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public boolean saveObject(String planId, String issueId, HttpSession s) throws NoUserInSessionException {
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue(planId));
        params.addElement(new StringValue(issueId));
        params.addElement(new StringValue((String) waUser.getAttribute("userId")));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(getQuery("insertPlanIssue").trim());
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

    public boolean savePlanIssues(String planId, String[] issueIdArr, HttpSession s)
            throws NoUserInSessionException {
        
        boolean queryResult = false;
        beginTransaction();

        for (int i = 0; i < issueIdArr.length; i++) {
            queryResult = this.saveObject(planId, issueIdArr[i], s);

            try {
                Thread.sleep(50);
            } catch (InterruptedException ex) {
                ex.printStackTrace();
            }

            if(queryResult == false) {
                try {
                    transConnection.rollback();
                    
                } catch (SQLException ex) {
                    Logger.getLogger(PlanIssueMgr.class.getName()).log(Level.SEVERE, null, ex);
                    
                } finally {
                    endTransaction();
                    return false;
                    
                }
                
            }

        }

        endTransaction();
        return true;
        
    }

    public ArrayList getCashedTableAsBusObjects() {
        cashedData = new ArrayList();
        WebBusinessObject wbo = null;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add(wbo);
        }

        return cashedData;
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

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
        return; //   throw new UnsupportedOperationException("Not supported yet.");
    }
}
