package com.maintenance.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.common.SecurityUser;
//import com.silkworm.logger.db_access.ObjectTypeMgr;
import com.silkworm.persistence.relational.StringValue;
import java.util.*;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.http.HttpSession;
import org.apache.log4j.xml.DOMConfigurator;

public class ProjectsByGroupMgr extends RDBGateWay {

    private static ProjectsByGroupMgr projectsByGroupMgr = new ProjectsByGroupMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();
    SecurityUser securityUser = new SecurityUser();
    public ProjectsByGroupMgr() {
    }

    public static ProjectsByGroupMgr getInstance() {
        logger.info("Getting projectsByGroupMgr Instance ....");
        return projectsByGroupMgr;
    }

    @Override
    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("projects_by_group.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public boolean saveProjectByGroup(String groupId, Vector userStores, HttpSession s) {

        int queryResult = -1000;
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();

        securityUser = (SecurityUser) s.getAttribute("securityUser");
        WebBusinessObject userStoreWBO = new WebBusinessObject();
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            forInsert.setConnection(connection);

            // delete old projects before saving new ones
            params = new Vector();
            params.addElement(new StringValue(groupId));
            forInsert.setparams(params);
            forInsert.setSQLQuery(sqlMgr.getSql("deleteOldProjectByGroup").trim());
            queryResult = forInsert.executeUpdate();

            String sql = sqlMgr.getSql("saveProjectByGroup").trim();
            forInsert.setSQLQuery(sql);

            for (int i = 0; i < userStores.size(); i++) {

                userStoreWBO = (WebBusinessObject) userStores.get(i);

                params = new Vector();

                params.addElement(new StringValue(UniqueIDGen.getNextID()));
                params.addElement(new StringValue(groupId));
                params.addElement(new StringValue((String) userStoreWBO.getAttribute("projectId")));
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
                connection.commit();
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
                return false;
            }
        }

        return (queryResult > 0);
    }

   public ArrayList<String> getProjectByGroupList(String groupId) {
        ArrayList<String> projectByGroupList = new ArrayList<String>();
        Row r = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;
        Enumeration e = null;
        Vector params = new Vector();

        params.addElement(new StringValue(groupId));

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getProjectByGroupList").trim());
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        e = queryResult.elements();

        try {
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                projectByGroupList.add(r.getString("PROJECT_ID"));

            }

        } catch (NoSuchColumnException ce) {
            logger.error(ce);
        }

        return projectByGroupList;

    }
   
    @Override
    public ArrayList getCashedTableAsBusObjects() {
        cashedData = new ArrayList();
        WebBusinessObject wbo = null;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add(wbo);
        }

        return cashedData;
    }
    
    @Override
    public ArrayList getCashedTableAsArrayList() {

        cashedData = new ArrayList();
        return cashedData;
    }

    @Override
    protected void initSupportedQueries() {
      return; //  throw new UnsupportedOperationException("Not supported yet.");
    }
}
