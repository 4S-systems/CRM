package com.tracker.db_access;

import com.silkworm.business_objects.BusinessForm;
import com.silkworm.business_objects.DOMFabricatorBean;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.persistence.relational.RDBGateWay;
import com.silkworm.persistence.relational.SQLCommandBean;
import com.silkworm.persistence.relational.StringValue;
import com.silkworm.persistence.relational.UniqueIDGen;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Vector;
import org.apache.log4j.xml.DOMConfigurator;

public class ProjectPriceHistoryMgr extends RDBGateWay {

    public static ProjectPriceHistoryMgr projectPriceHistoryMgr = new ProjectPriceHistoryMgr();

    public static ProjectPriceHistoryMgr getInstance() {
        logger.info("Getting ProjectPriceHistoryMgr Instance ....");
        return projectPriceHistoryMgr;
    }

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("project_price_history.xml")));
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
        params.addElement(new StringValue((String) wbo.getAttribute("projectID")));
        params.addElement(new StringValue((String) wbo.getAttribute("createdBy")));
        params.addElement(new StringValue((String) wbo.getAttribute("unitNum")));
        params.addElement(new StringValue((String) wbo.getAttribute("meterPrice")));
        params.addElement(new StringValue((String) wbo.getAttribute("garageNum")));
        params.addElement(new StringValue((String) wbo.getAttribute("lockerNum")));
        params.addElement(new StringValue((String) wbo.getAttribute("option1")));
        params.addElement(new StringValue((String) wbo.getAttribute("option2")));
        params.addElement(new StringValue((String) wbo.getAttribute("option3")));
        params.addElement(new StringValue((String) wbo.getAttribute("option4")));
        params.addElement(new StringValue((String) wbo.getAttribute("option5")));
        params.addElement(new StringValue((String) wbo.getAttribute("option6")));
        try {
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            forInsert.setConnection(connection);
            String sql = getQuery("insertProjectPriceHistory").trim();
            forInsert.setSQLQuery(sql);
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
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
        cashData();
        return new ArrayList(cashedTable);
    }
}
