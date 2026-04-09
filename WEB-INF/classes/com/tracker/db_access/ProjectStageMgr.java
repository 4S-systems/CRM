package com.tracker.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.persistence.relational.StringValue;
import java.sql.SQLException;
import java.util.*;
import java.sql.Connection;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.log4j.xml.DOMConfigurator;

public class ProjectStageMgr extends RDBGateWay {

    private static ProjectStageMgr projectStageMgr = new ProjectStageMgr();

    public static ProjectStageMgr getInstance() {
        logger.info("Getting ProjectStageMgr Instance ....");
        return projectStageMgr;
    }

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }

        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("project_stage.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
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
        params.addElement(new StringValue((String) wbo.getAttribute("id")));
        params.addElement(new DateValue((java.sql.Date) wbo.getAttribute("estimatedFinishDate")));
        params.addElement(new StringValue((String) wbo.getAttribute("estimatedCost")));
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
            String sql = getQuery("insertProjectStage").trim();
            forInsert.setSQLQuery(sql);
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            if (queryResult <= 0) {
                connection.rollback();
                return false;
            }
        } catch (SQLException se) {
            Logger.getLogger(StageWorkItemMgr.class.getName()).log(Level.SEVERE, null, se);
            return false;
        } finally {
            try {
                if (connection != null) {
                    connection.commit();
                    connection.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(StageWorkItemMgr.class.getName()).log(Level.SEVERE, null, ex);
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
