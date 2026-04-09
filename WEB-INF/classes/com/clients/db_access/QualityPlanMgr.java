package com.clients.db_access;

import com.crm.common.CRMConstants;
import com.silkworm.business_objects.BusinessForm;
import com.silkworm.business_objects.DOMFabricatorBean;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.persistence.relational.RDBGateWay;
import com.silkworm.persistence.relational.SQLCommandBean;
import com.silkworm.persistence.relational.StringValue;
import com.silkworm.persistence.relational.TimestampValue;
import com.silkworm.persistence.relational.UniqueIDGen;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Vector;
import org.apache.log4j.xml.DOMConfigurator;

public class QualityPlanMgr extends RDBGateWay {

    public static QualityPlanMgr qualityPlanMgr = new QualityPlanMgr();

    public static QualityPlanMgr getInstance() {
        logger.info("Getting QualityPlanMgr Instance ....");
        return qualityPlanMgr;
    }

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("quality_plan.xml")));
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
        params.addElement(new StringValue((String) wbo.getAttribute("requestedTitle")));
        params.addElement(new StringValue(CRMConstants.QUALITY_PLAN_STATUS_PLANNED));
        params.addElement(new TimestampValue((Timestamp) wbo.getAttribute("fromDate")));
        params.addElement(new TimestampValue((Timestamp) wbo.getAttribute("toDate")));
        params.addElement(new StringValue((String) wbo.getAttribute("createdBy")));
        params.addElement(new StringValue((String) wbo.getAttribute("title")));
        params.addElement(new StringValue((String) wbo.getAttribute("option2")));
        params.addElement(new StringValue((String) wbo.getAttribute("option3")));

        Vector issueStatusParameters = new Vector();
        issueStatusParameters.addElement(new StringValue(UniqueIDGen.getNextID()));
        issueStatusParameters.addElement(new StringValue(CRMConstants.QUALITY_PLAN_STATUS_PLANNED));
        issueStatusParameters.addElement(new StringValue("UL"));
        issueStatusParameters.addElement(new StringValue("UL"));
        issueStatusParameters.addElement(new TimestampValue(new Timestamp(Calendar.getInstance().getTimeInMillis())));
        issueStatusParameters.addElement(new StringValue("UL"));
        issueStatusParameters.addElement(new StringValue("UL"));
        issueStatusParameters.addElement(new StringValue("UL"));
        issueStatusParameters.addElement(new StringValue(id));
        issueStatusParameters.addElement(new StringValue("quality plan"));
        issueStatusParameters.addElement(new StringValue("UL"));
        issueStatusParameters.addElement(new StringValue((String) wbo.getAttribute("createdBy")));
        try {
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            forInsert.setConnection(connection);
            String sql = getQuery("insertQualityPlan").trim();
            forInsert.setSQLQuery(sql);
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            if (queryResult <= 0) {
                connection.rollback();
                return false;
            }
            sql = getQuery("insertQualityPlanStatus").trim();
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
    
    public boolean updateQualityPlanStatus(String qualityPlanID, String newStatus) {
        int queryResult = -1000;
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        Connection connection = null;
        params.addElement(new StringValue(newStatus));
        params.addElement(new StringValue(qualityPlanID));
        try {
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            forInsert.setConnection(connection);
            String sql = getQuery("updateQualityPlanStatus").trim();
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
