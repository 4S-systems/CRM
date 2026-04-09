package com.tracker.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.common.SecurityUser;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.http.HttpSession;
import org.apache.log4j.xml.DOMConfigurator;

public class DepDocPrevMgr extends RDBGateWay {

    private static DepDocPrevMgr depDocPrevMgr = new DepDocPrevMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();

    public static DepDocPrevMgr getInstance() {
        logger.info("Getting DepDocPrevMgr Instance ....");
        return depDocPrevMgr;
    }

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("dep_doc_prev.xml")));
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

    public ArrayList<String> getDepartmentIDs(String docTypeID) {
        ArrayList<String> departmentIDs = new ArrayList<String>();
        try {
            ArrayList<WebBusinessObject> departments = getOnArbitraryKey2(docTypeID, "key1");
            for (WebBusinessObject wbo : departments) {
                departmentIDs.add((String) wbo.getAttribute("projectID"));
            }
        } catch (Exception ex) {
            Logger.getLogger(DepDocPrevMgr.class.getName()).log(Level.SEVERE, null, ex);
        }
        return departmentIDs;
    }

    public ArrayList<String> getLastVersionIDs(String docTypeID) {
        ArrayList<String> lastVersionIDs = new ArrayList<String>();
        try {
            ArrayList<WebBusinessObject> departments = getOnArbitraryKey2(docTypeID, "key1");
            for (WebBusinessObject wbo : departments) {
                if (wbo.getAttribute("lastVersion") != null && ((String) wbo.getAttribute("lastVersion")).equalsIgnoreCase("1")) {
                    lastVersionIDs.add((String) wbo.getAttribute("projectID"));
                }
            }
        } catch (Exception ex) {
            Logger.getLogger(DepDocPrevMgr.class.getName()).log(Level.SEVERE, null, ex);
        }
        return lastVersionIDs;
    }

    public boolean saveDocTypeDeps(String docTypeID, Vector userStores, HttpSession s) {

        int queryResult = -1000;
        Vector params;
        SQLCommandBean forInsert = new SQLCommandBean();

        SecurityUser securityUser = (SecurityUser) s.getAttribute("securityUser");
        WebBusinessObject userStoreWBO;
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            forInsert.setConnection(connection);

            // Delete old document type departments before saving new ones
            params = new Vector();
            params.addElement(new StringValue(docTypeID));
            forInsert.setparams(params);

            forInsert.setSQLQuery(getQuery("deleteOldDepDocPrev").trim());
            queryResult = forInsert.executeUpdate();

            String sql = getQuery("inserDepDocPrev").trim();
            forInsert.setSQLQuery(sql);

            for (int i = 0; i < userStores.size(); i++) {

                userStoreWBO = (WebBusinessObject) userStores.get(i);
                params = new Vector();
                params.addElement(new StringValue(UniqueIDGen.getNextID()));
                params.addElement(new StringValue((String) userStoreWBO.getAttribute("projectID")));
                params.addElement(new StringValue(docTypeID));
                params.addElement(new StringValue((String) userStoreWBO.getAttribute("lastVersion")));
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
}
