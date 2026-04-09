package com.tracker.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.persistence.relational.StringValue;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.*;
import java.util.ArrayList;
import org.apache.log4j.xml.DOMConfigurator;

public class RequestItemsMgr extends RDBGateWay {

    private static final RequestItemsMgr REQUEST_ITEMS_MGR = new RequestItemsMgr();

    public static RequestItemsMgr getInstance() {
        logger.info("Getting RequestItemsMgr Instance ....");
        return REQUEST_ITEMS_MGR;
    }

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("request_items.xml")));
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
        cashedData = new ArrayList();
        for (Object object : cashedTable) {
            cashedData.add(object);
        }
        return cashedData;
    }

    public String save(WebBusinessObject wbo) {
        String issueId = (String) wbo.getAttribute("issueId");
        String projectId = (String) wbo.getAttribute("projectId");
        String quantity = (String) wbo.getAttribute("quantity");
        String valid = (String) wbo.getAttribute("valid");
        String note = (String) wbo.getAttribute("note");
        String createdBy = (String) wbo.getAttribute("createdBy");
        return save(issueId, projectId, quantity, valid, note, createdBy, "UL", "UL", "UL", "UL", "UL", "UL");
    }

    public String save(String issueId, String projectId, String quantity, String valid, String note, String createdBy, String option1, String option2, String option3, String option4, String option5, String option6) {
        SQLCommandBean commandBean = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();

        String id = UniqueIDGen.getNextID();
        parameters.addElement(new StringValue(id));
        parameters.addElement(new StringValue(issueId));
        parameters.addElement(new StringValue(projectId));
        parameters.addElement(new StringValue(quantity));
        parameters.addElement(new StringValue(valid));
        parameters.addElement(new StringValue(note));
        parameters.addElement(new StringValue(createdBy));
        parameters.addElement(new StringValue(option1));
        parameters.addElement(new StringValue(option2));
        parameters.addElement(new StringValue(option3));
        parameters.addElement(new StringValue(option4));
        parameters.addElement(new StringValue(option5));
        parameters.addElement(new StringValue(option6));
        try {
            connection = dataSource.getConnection();
            commandBean.setConnection(connection);
            commandBean.setSQLQuery(getQuery("insert").trim());
            commandBean.setparams(parameters);
            commandBean.executeUpdate();
            return id;
        } catch (SQLException se) {
            logger.error("Exception updating project: " + se.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex);
            }
        }
        return null;
    }
    
    public boolean update(String id, String quantity, String valid, String note) {
        SQLCommandBean commandBean = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        int result = -1000;

        parameters.addElement(new StringValue(quantity));
        parameters.addElement(new StringValue(valid));
        parameters.addElement(new StringValue(note));
        parameters.addElement(new StringValue(id));
        try {
            connection = dataSource.getConnection();
            commandBean.setConnection(connection);
            commandBean.setSQLQuery(getQuery("update").trim());
            commandBean.setparams(parameters);
            result = commandBean.executeUpdate();
        } catch (SQLException se) {
            logger.error("Exception updating project: " + se.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex);
            }
        }
        return (result > 0);
    }

    public boolean delete(String id) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        int result = -1000;

        parameters.addElement(new StringValue(id));

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("delete"));
            command.setparams(parameters);
            result = command.executeUpdate();
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error, " + ex);
            }
        }

        return (result > 0);
    }

    public boolean deleteByIssueId(String issueId) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        int result = -1000;

        parameters.addElement(new StringValue(issueId));

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("deleteByIssueId"));
            command.setparams(parameters);
            result = command.executeUpdate();
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error, " + ex);
            }
        }

        return (result > 0);
    }

    public List<WebBusinessObject> getByIssueId(String issueId) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        Vector<Row> result;
        List<WebBusinessObject> data = new ArrayList<WebBusinessObject>();

        parameters.addElement(new StringValue(issueId));

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getByIssueId"));
            command.setparams(parameters);
            result = command.executeQuery();

            for (Row row : result) {
                data.add(fabricateBusObj(row));
            }
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } catch (UnsupportedTypeException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error, " + ex);
            }
        }

        return data;
    }
    
    public ArrayList<WebBusinessObject> getRepeatedUnitItems(java.sql.Date beginDate, java.sql.Date endDate) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        Vector<Row> result;
        ArrayList<WebBusinessObject> data = new ArrayList<>();
        parameters.addElement(new DateValue(beginDate));
        parameters.addElement(new DateValue(endDate));
        
        WebBusinessObject wbo;
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getRepeatedUnitItems"));
            command.setparams(parameters);
            result = command.executeQuery();
            for (Row row : result) {
                wbo = new WebBusinessObject();
                try {
                    if(row.getBigDecimal("NUM") != null) {
                        wbo.setAttribute("num", row.getBigDecimal("NUM"));
                    }
                    if(row.getString("UNIT_NAME") != null) {
                        wbo.setAttribute("unitName", row.getString("UNIT_NAME"));
                    }
                    if(row.getString("UNIT_ID") != null) {
                        wbo.setAttribute("unitID", row.getString("UNIT_ID"));
                    }
                    if(row.getString("ITEM_NAME") != null) {
                        wbo.setAttribute("itemName", row.getString("ITEM_NAME"));
                    }
                    if(row.getString("ITEM_ID") != null) {
                        wbo.setAttribute("itemID", row.getString("ITEM_ID"));
                    }
                } catch (NoSuchColumnException ex) {
                    logger.error(ex);
                } catch (UnsupportedConversionException ex) {
                    logger.error(ex);
                }
                data.add(wbo);
            }
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } catch (UnsupportedTypeException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error("Close Error, " + ex);
            }
        }
        return data;
    }
    
    public ArrayList<WebBusinessObject> getRepeatedItemIssues(String itemID, String unitName) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        Vector<Row> result;
        ArrayList<WebBusinessObject> data = new ArrayList<>();
        parameters.addElement(new StringValue(unitName));
        parameters.addElement(new StringValue(itemID));
        
        WebBusinessObject wbo;
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getRepeatedItemIssues"));
            command.setparams(parameters);
            result = command.executeQuery();
            for (Row row : result) {
                wbo = new WebBusinessObject();
                try {
                    if(row.getString("BUSINESS_ID") != null) {
                        wbo.setAttribute("businessID", row.getString("BUSINESS_ID"));
                    }
                    if(row.getString("BUSINESS_ID_BY_DATE") != null) {
                        wbo.setAttribute("businessIDByDate", row.getString("BUSINESS_ID_BY_DATE"));
                    }
                    if(row.getString("CONTRACTOR_NAME") != null) {
                        wbo.setAttribute("contractorName", row.getString("CONTRACTOR_NAME"));
                    }
                    if(row.getString("ISSUE_ID") != null) {
                        wbo.setAttribute("issueID", row.getString("ISSUE_ID"));
                    }
                } catch (NoSuchColumnException ex) {
                    logger.error(ex);
                }
                data.add(wbo);
            }
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } catch (UnsupportedTypeException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error("Close Error, " + ex);
            }
        }
        return data;
    }
    
    public ArrayList<WebBusinessObject> getRequestItemsUnit(java.sql.Date beginDate, java.sql.Date endDate) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        Vector<Row> result;
        ArrayList<WebBusinessObject> data = new ArrayList<>();
        parameters.addElement(new DateValue(beginDate));
        parameters.addElement(new DateValue(endDate));
        
        WebBusinessObject wbo;
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getRequestItemsUnit"));
            command.setparams(parameters);
            result = command.executeQuery();
            for (Row row : result) {
                wbo = new WebBusinessObject();
                try {
                    if(row.getString("UNIT_NAME") != null) {
                        wbo.setAttribute("unitName", row.getString("UNIT_NAME"));
                    }
                    if(row.getString("UNIT_ID") != null) {
                        wbo.setAttribute("unitID", row.getString("UNIT_ID"));
                    }
                } catch (NoSuchColumnException ex) {
                    logger.error(ex);
                }
                data.add(wbo);
            }
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } catch (UnsupportedTypeException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error("Close Error, " + ex);
            }
        }
        return data;
    }
    
    public ArrayList<WebBusinessObject> getItemsByUnit(java.sql.Date beginDate, java.sql.Date endDate, String unitName) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        Vector<Row> result;
        ArrayList<WebBusinessObject> data = new ArrayList<>();
        parameters.addElement(new DateValue(beginDate));
        parameters.addElement(new DateValue(endDate));
        parameters.addElement(new StringValue(unitName));
        
        WebBusinessObject wbo;
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getItemsByUnit"));
            command.setparams(parameters);
            result = command.executeQuery();
            for (Row row : result) {
                wbo = fabricateBusObj(row);
                try {
                    if(row.getString("ITEM_NAME") != null) {
                        wbo.setAttribute("itemName", row.getString("ITEM_NAME"));
                    }
                    if(row.getString("ITEM_ID") != null) {
                        wbo.setAttribute("itemID", row.getString("ITEM_ID"));
                    }
                    if(row.getString("BUSINESS_ID") != null) {
                        wbo.setAttribute("businessID", row.getString("BUSINESS_ID"));
                    }
                    if(row.getString("BUSINESS_ID_BY_DATE") != null) {
                        wbo.setAttribute("businessIDByDate", row.getString("BUSINESS_ID_BY_DATE"));
                    }
                    if(row.getString("CONTRACTOR_NAME") != null) {
                        wbo.setAttribute("contractorName", row.getString("CONTRACTOR_NAME"));
                    }
                } catch (NoSuchColumnException ex) {
                    logger.error(ex);
                }
                data.add(wbo);
            }
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } catch (UnsupportedTypeException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error("Close Error, " + ex);
            }
        }
        return data;
    }
    
    public ArrayList<WebBusinessObject> getWorkItemsRecurringCurve(java.sql.Date beginDate, java.sql.Date endDate, String engineerID, String contractorID, String projectID) {
        String theQuery = getQuery("getWorkItemsRecurringCurve").trim().replaceAll("contractorID", contractorID)
                .replaceAll("engineerID", engineerID).replaceAll("projectID", projectID);
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        ArrayList<WebBusinessObject> data = new ArrayList<>();
        Vector<Row> result;
        Vector parameters = new Vector();
        parameters.addElement(new DateValue(beginDate));
        parameters.addElement(new DateValue(endDate));
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(theQuery);
            command.setparams(parameters);
            result = command.executeQuery();

            WebBusinessObject wbo;
            for (Row row : result) {
                wbo = fabricateBusObj(row);
                try {
                    if(row.getBigDecimal("TOTAL") != null) {
                        wbo.setAttribute("total", row.getBigDecimal("TOTAL") + "");
                    }
                    if(row.getString("ITEM_NAME") != null) {
                        wbo.setAttribute("itemName", row.getString("ITEM_NAME"));
                    }
                } catch (NoSuchColumnException | UnsupportedConversionException ex) {
                    logger.error(ex);
                }
                data.add(wbo);
            }
        } catch (SQLException | UnsupportedTypeException ex) {
            logger.error(ex);
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex);
            }
        }
        return data;
    }
    
    public ArrayList<WebBusinessObject> getSpareItemStatuses() {
        String theQuery = getQuery("getSpareItemStatuses").trim();
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        ArrayList<WebBusinessObject> data = new ArrayList<>();
        Vector<Row> result;
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(theQuery);
            result = command.executeQuery();

            WebBusinessObject wbo;
            for (Row row : result) {
                wbo = fabricateBusObj(row);
                try {
                    if (row.getString("ID") != null) {
                        wbo.setAttribute("statusTypeID", row.getString("ID"));
                    }
                    if (row.getString("CASE_EN") != null) {
                        wbo.setAttribute("typeNameEn", row.getString("CASE_EN"));
                    }
                    if (row.getString("CASE_AR") != null) {
                        wbo.setAttribute("typeNameAr", row.getString("CASE_AR"));
                    }
                } catch (NoSuchColumnException ex) {
                    logger.error(ex);
                }
                data.add(wbo);
            }
        } catch (SQLException | UnsupportedTypeException ex) {
            logger.error(ex);
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex);
            }
        }
        return data;
    }
    
    public boolean update(String id, String note, String option3, String option4, String option5, String option6) {
        SQLCommandBean commandBean = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        int result = -1000;

        parameters.addElement(new StringValue(note));
        parameters.addElement(new StringValue(option3));
        parameters.addElement(new StringValue(option4));
        parameters.addElement(new StringValue(option5));
        parameters.addElement(new StringValue(option6));
        parameters.addElement(new StringValue(id));
        try {
            connection = dataSource.getConnection();
            commandBean.setConnection(connection);
            commandBean.setSQLQuery(getQuery("updateObject").trim());
            commandBean.setparams(parameters);
            result = commandBean.executeUpdate();
        } catch (SQLException se) {
            logger.error("Exception updating project: " + se.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex);
            }
        }
        return (result > 0);
    }
}
