/*
 * FavoritesMgr.java
 *
 * Created on March 30, 2005, 7:28 AM
 */
package com.silkworm.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.common.CustomizationPanelElement;
import java.sql.SQLException;
import java.util.*;
import java.sql.*;
import org.apache.log4j.xml.DOMConfigurator;

/**
 *
 * @author Walid
 */
public class CustomizationPanelMgr extends RDBGateWay {

    private final static CustomizationPanelMgr PANEL_MGR = new CustomizationPanelMgr();

    public static CustomizationPanelMgr getInstance() {
        return PANEL_MGR;
    }

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("customization_panel.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    @Override
    public ArrayList getCashedTableAsArrayList() {
        cashedData = new ArrayList();
        WebBusinessObject wbo;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add(wbo);
        }

        return cashedData;
    }

    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public boolean saveObject(String userId, String name, String value, String createdBy) {
        return saveObject(userId, new String[]{name}, new String[]{value}, createdBy);
    }

    public boolean saveObject(String userId, String[] names, String[] values, String createdBy) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters;
        String id;
        int result = -1000;

        if (names.length == values.length) {
            try {
                connection = dataSource.getConnection();
                connection.setAutoCommit(false);
                command.setConnection(connection);

                // delete prev data if exsist
                command.setSQLQuery(getQuery("deleteByUser"));
                parameters = new Vector();
                parameters.addElement(new StringValue(userId));
                command.setparams(parameters);
                result = command.executeUpdate();
                try {
                    Thread.sleep(50);
                } catch (InterruptedException ex) {
                    connection.rollback();
                    logger.error("Exception inserting : " + ex.getMessage());
                    return false;
                }

                // start to store data
                command.setSQLQuery(getQuery("insert"));
                for (int i = 0; i < values.length; i++) {
                    result = -1000;
                    id = UniqueIDGen.getNextID();
                    parameters = new Vector();
                    parameters.addElement(new StringValue(id));
                    parameters.addElement(new StringValue(userId));
                    parameters.addElement(new StringValue(names[i]));
                    parameters.addElement(new StringValue(values[i]));
                    parameters.addElement(new StringValue(createdBy));
                    command.setparams(parameters);
                    result = command.executeUpdate();

                    if (result < 0) {
                        try {
                            connection.rollback();
                        } catch (SQLException ex) {
                            logger.error("Close Error: " + ex);
                        }
                    }

                    try {
                        Thread.sleep(50);
                    } catch (InterruptedException ex) {
                        connection.rollback();
                        logger.error("Exception inserting : " + ex.getMessage());
                        return false;
                    }
                }
            } catch (SQLException se) {
                try {
                    connection.rollback();
                } catch (SQLException ex) {
                    logger.error("Close Error: " + ex);
                }
                logger.error("Exception inserting: " + se.getMessage());
                return false;
            } finally {
                try {
                    connection.commit();
                    connection.close();
                } catch (SQLException ex) {
                    logger.error("Close Error: " + ex);
                    return false;
                }
            }
        }

        return (result > 0);
    }

    public List<WebBusinessObject> getByUserIdAndName(String userId, String name) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        Vector<Row> result = new Vector();
        List<WebBusinessObject> data;

        parameters.addElement(new StringValue(userId));
        parameters.addElement(new StringValue(name));

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getByUserId"));
            command.setparams(parameters);
            result = command.executeQuery();
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

        data = new ArrayList<WebBusinessObject>();
        for (Row row : result) {
            data.add(fabricateBusObj(row));
        }
        return data;
    }

    public Map<CustomizationPanelElement, String> getCustomizationUser(String userId) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        Vector<Row> result = new Vector();

        parameters.addElement(new StringValue(userId));

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getByUserId"));
            command.setparams(parameters);
            result = command.executeQuery();
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

        return fabricateToMap(result);
    }

    public List<WebBusinessObject> getByUserId(String userId) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        Vector<Row> result = new Vector();
        List<WebBusinessObject> data;

        parameters.addElement(new StringValue(userId));

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getByUserId"));
            command.setparams(parameters);
            result = command.executeQuery();
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

        data = new ArrayList<WebBusinessObject>();
        for (Row row : result) {
            data.add(fabricateBusObj(row));
        }
        return data;
    }

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
    }

    private Map<CustomizationPanelElement, String> fabricateToMap(Vector<Row> rows) {
        List<WebBusinessObject> list = new ArrayList<WebBusinessObject>();
        for (Row row : rows) {
            list.add(fabricateBusObj(row));
        }
        return fabricateToMap(list);
    }

    private Map<CustomizationPanelElement, String> fabricateToMap(List<WebBusinessObject> list) {
        Map<CustomizationPanelElement, String> data = new EnumMap<CustomizationPanelElement, String>(CustomizationPanelElement.class);
        CustomizationPanelElement element;
        String name, value;
        for (WebBusinessObject wbo : list) {
            name = (String) wbo.getAttribute("name");
            value = (String) wbo.getAttribute("value");
            element = CustomizationPanelElement.parse(name);
            if (element != null) {
                data.put(element, value);
            }
        }
        return data;
    }
}
