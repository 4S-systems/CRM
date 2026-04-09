package com.tracker.db_access;

import com.silkworm.business_objects.BusinessForm;
import com.silkworm.business_objects.DOMFabricatorBean;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.persistence.relational.NoSuchColumnException;
import com.silkworm.persistence.relational.RDBGateWay;
import com.silkworm.persistence.relational.Row;
import com.silkworm.persistence.relational.SQLCommandBean;
import com.silkworm.persistence.relational.StringValue;
import com.silkworm.persistence.relational.UniqueIDGen;
import com.silkworm.persistence.relational.UnsupportedTypeException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.log4j.xml.DOMConfigurator;

public class StageWorkItemMgr extends RDBGateWay {

    public static StageWorkItemMgr stageWorkItemMgr = new StageWorkItemMgr();

    public static StageWorkItemMgr getInstance() {
        logger.info("Getting StageWorkItemMgr Instance ....");
        return stageWorkItemMgr;
    }

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("stage_work_item.xml")));
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
        params.addElement(new StringValue((String) wbo.getAttribute("stageID")));
        params.addElement(new StringValue((String) wbo.getAttribute("workItemID")));
        params.addElement(new StringValue((String) wbo.getAttribute("quantity")));
        params.addElement(new StringValue((String) wbo.getAttribute("note")));
        params.addElement(new StringValue((String) wbo.getAttribute("createdBy")));
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
            String sql = getQuery("insertStageWorkItem").trim();
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

    public boolean saveMultiObjects(ArrayList<WebBusinessObject> wboList) {
        int queryResult = -1000;
        Vector params;
        SQLCommandBean forInsert = new SQLCommandBean();
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            forInsert.setConnection(connection);
            String sql = getQuery("insertStageWorkItem").trim();
            forInsert.setSQLQuery(sql);
            for (WebBusinessObject wbo : wboList) {
                params = new Vector();
                params.addElement(new StringValue(UniqueIDGen.getNextID()));
                params.addElement(new StringValue((String) wbo.getAttribute("stageID")));
                params.addElement(new StringValue((String) wbo.getAttribute("workItemID")));
                params.addElement(new StringValue((String) wbo.getAttribute("quantity")));
                params.addElement(new StringValue((String) wbo.getAttribute("note")));
                params.addElement(new StringValue((String) wbo.getAttribute("createdBy")));
                params.addElement(new StringValue((String) wbo.getAttribute("option1")));
                params.addElement(new StringValue((String) wbo.getAttribute("option2")));
                params.addElement(new StringValue((String) wbo.getAttribute("option3")));
                params.addElement(new StringValue((String) wbo.getAttribute("option4")));
                params.addElement(new StringValue((String) wbo.getAttribute("option5")));
                params.addElement(new StringValue((String) wbo.getAttribute("option6")));
                forInsert.setparams(params);
                queryResult = forInsert.executeUpdate();
                if (queryResult <= 0) {
                    connection.rollback();
                    return false;
                }
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
        return null;
    }

    public ArrayList<WebBusinessObject> getStageWorkItems(String stageID) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> result;
        Vector params = new Vector();
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            params.addElement(new StringValue(stageID));
            command.setSQLQuery(getQuery("getStageWorkItems").trim());
            command.setparams(params);
            result = command.executeQuery();
            ArrayList<WebBusinessObject> data = new ArrayList<>();
            WebBusinessObject wbo;
            for (Row row : result) {
                wbo = fabricateBusObj(row);
                try {
                    if (row.getString("WORK_ITEM_NAME") != null) {
                        wbo.setAttribute("workItemName", row.getString("WORK_ITEM_NAME"));
                    }
                    if (row.getString("WORK_ITEM_CODE") != null) {
                        wbo.setAttribute("workItemCode", row.getString("WORK_ITEM_CODE"));
                    }
                    if (row.getString("CATEGORY_NAME") != null) {
                        wbo.setAttribute("categoryName", row.getString("CATEGORY_NAME"));
                    }
                    if (row.getString("ACTUAL_QUANTITY") != null) {
                        wbo.setAttribute("status", "done");
                    }
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(StageWorkItemMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                data.add(wbo);
            }
            return data;
        } catch (UnsupportedTypeException | SQLException ex) {
            Logger.getLogger(StageWorkItemMgr.class.getName()).log(Level.SEVERE, null, ex);
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
}
