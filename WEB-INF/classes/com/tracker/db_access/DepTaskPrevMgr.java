package com.tracker.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.common.SecurityUser;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.http.HttpSession;
import org.apache.log4j.xml.DOMConfigurator;

public class DepTaskPrevMgr extends RDBGateWay {

    private static DepTaskPrevMgr depTaskPrevMgr = new DepTaskPrevMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();

    public static DepTaskPrevMgr getInstance() {
        logger.info("Getting DepDocPrevMgr Instance ....");
        return depTaskPrevMgr;
    }

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("dep_task_prev.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
    }

    @Override
    public ArrayList getCashedTableAsArrayList() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public ArrayList<String> getTaskTypeIDs(String departmentID) {
        ArrayList<String> taskTypeIDs = new ArrayList<String>();
        try {
            ArrayList<WebBusinessObject> taskTypes = getOnArbitraryKey2(departmentID, "key");
            for (WebBusinessObject wbo : taskTypes) {
                taskTypeIDs.add((String) wbo.getAttribute("taskID"));
            }
        } catch (Exception ex) {
            Logger.getLogger(DepTaskPrevMgr.class.getName()).log(Level.SEVERE, null, ex);
        }
        return taskTypeIDs;
    }

    public boolean saveDepartmentTaskTypes(String departmentID, ArrayList<String> taskTypeIDs, HttpSession s) {

        int queryResult = -1000;
        Vector params;
        SQLCommandBean forInsert = new SQLCommandBean();
        SecurityUser securityUser = (SecurityUser) s.getAttribute("securityUser");
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            forInsert.setConnection(connection);

            // Delete old document type departments before saving new ones
            params = new Vector();
            params.addElement(new StringValue(departmentID));
            forInsert.setparams(params);

            forInsert.setSQLQuery(getQuery("deleteOldDepTaskPrev").trim());
            queryResult = forInsert.executeUpdate();

            String sql = getQuery("inserDepTaskPrev").trim();
            forInsert.setSQLQuery(sql);
            for (String taskTypeID : taskTypeIDs) {
                params = new Vector();
                params.addElement(new StringValue(UniqueIDGen.getNextID()));
                params.addElement(new StringValue(taskTypeID));
                params.addElement(new StringValue(departmentID));
                params.addElement(new StringValue(securityUser.getUserId()));
                forInsert.setparams(params);
                queryResult = forInsert.executeUpdate();
                if (queryResult <= 0) {
                    connection.rollback();
                    return false;
                }
                try {
                    Thread.sleep(100);
                } catch (InterruptedException ex) {
                    logger.error(ex.getMessage());
                }
            }
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } finally {
            try {
                if(connection != null) {
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
}
