package com.clients.db_access;

import com.crm.common.CRMConstants;
import com.silkworm.business_objects.BusinessForm;
import com.silkworm.business_objects.DOMFabricatorBean;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.persistence.relational.NoSuchColumnException;
import com.silkworm.persistence.relational.RDBGateWay;
import com.silkworm.persistence.relational.Row;
import com.silkworm.persistence.relational.SQLCommandBean;
import com.silkworm.persistence.relational.StringValue;
import com.silkworm.persistence.relational.TimestampValue;
import com.silkworm.persistence.relational.UniqueIDGen;
import com.silkworm.persistence.relational.UnsupportedTypeException;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.log4j.xml.DOMConfigurator;

public class CallingPlanMgr extends RDBGateWay {

    public static CallingPlanMgr callingPlanMgr = new CallingPlanMgr();

    public static CallingPlanMgr getInstance() {
        logger.info("Getting CallingPlanMgr Instance ....");
        return callingPlanMgr;
    }

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("calling_plan.xml")));
                System.out.println("reading Successfully xml files....!");
            } catch (Exception e) {
                System.out.println("Error in reading xml files....!");
            }
        }
    }

    @Override
    public boolean saveObject(WebBusinessObject wbo) {
        int queryResult = -1000;
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        Connection connection = null;
        String id = UniqueIDGen.getNextID();
        wbo.setAttribute("id", id);
        params.addElement(new StringValue(id));
        params.addElement(new StringValue((String) wbo.getAttribute("frequencyRate")));
        params.addElement(new StringValue((String) wbo.getAttribute("frequencyType")));
        params.addElement(new StringValue((String) wbo.getAttribute("scheduleStatus")));
        params.addElement(new TimestampValue((Timestamp) wbo.getAttribute("fromDate")));
        params.addElement(new TimestampValue((Timestamp) wbo.getAttribute("toDate")));
        params.addElement(new StringValue((String) wbo.getAttribute("createdBy")));
        params.addElement(new StringValue((String) wbo.getAttribute("option1")));
        params.addElement(new StringValue((String) wbo.getAttribute("option3")));
        
        Vector issueStatusParameters = new Vector();
        issueStatusParameters.addElement(new StringValue(UniqueIDGen.getNextID()));
        issueStatusParameters.addElement(new StringValue(CRMConstants.CALLING_PLAN_STATUS_PLANNED));
        issueStatusParameters.addElement(new StringValue("UL"));
        issueStatusParameters.addElement(new StringValue("UL"));
        issueStatusParameters.addElement(new TimestampValue(new Timestamp(Calendar.getInstance().getTimeInMillis())));
        issueStatusParameters.addElement(new StringValue("UL"));
        issueStatusParameters.addElement(new StringValue("UL"));
        issueStatusParameters.addElement(new StringValue("UL"));
        issueStatusParameters.addElement(new StringValue(id));
        issueStatusParameters.addElement(new StringValue("calling plan"));
        issueStatusParameters.addElement(new StringValue("UL"));
        issueStatusParameters.addElement(new StringValue((String) wbo.getAttribute("createdBy")));
        try {
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            forInsert.setConnection(connection);
            String sql = getQuery("insertCallingPlan").trim();
            forInsert.setSQLQuery(sql);
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            if (queryResult <= 0) {
                connection.rollback();
                return false;
            }
            sql = getQuery("insertCallingPlanStatus").trim();
            forInsert.setSQLQuery(sql);
            forInsert.setparams(issueStatusParameters);
            queryResult = forInsert.executeUpdate();
            if (queryResult <= 0) {
                connection.rollback();
                return false;
            }
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } finally {
            try {
                if (connection != null) {
                    connection.commit();
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error("Close Error");
                return false;
            }
        }
        return (queryResult > 0);
    }
    
    public boolean updateCallingPlanStatus(String callingPlanID, String newStatus) {
        int queryResult = -1000;
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        Connection connection = null;
        params.addElement(new StringValue(newStatus));
        params.addElement(new StringValue(callingPlanID));
        try {
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            forInsert.setConnection(connection);
            String sql = getQuery("updateCallingPlanStatus").trim();
            forInsert.setSQLQuery(sql);
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            if (queryResult <= 0) {
                connection.rollback();
                return false;
            }
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } finally {
            try {
                if (connection != null) {
                    connection.commit();
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error("Close Error");
                return false;
            }
        }
        return (queryResult > 0);
    }
    
    public ArrayList<WebBusinessObject> getClientCampaigns(String clientID) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> result;
        Vector parameters = new Vector();
        parameters.addElement(new StringValue(clientID));
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getClientCampaigns").trim());
            command.setparams(parameters);
            result = command.executeQuery();
            ArrayList<WebBusinessObject> data = new ArrayList<>();
            WebBusinessObject wbo;
            for (Row row : result) {
                wbo = fabricateBusObj(row);
                data.add(wbo);
            }
            return data;
        } catch (UnsupportedTypeException | SQLException ex) {
            Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
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

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
    }

    @Override
    public ArrayList getCashedTableAsArrayList() {
        ArrayList al = null;
        return al;
    }

}
