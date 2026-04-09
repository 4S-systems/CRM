/*
 * FavoritesMgr.java
 *
 * Created on March 30, 2005, 7:28 AM
 */
package com.silkworm.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.common.CustomizationPanelElement;
import com.silkworm.util.DateAndTimeControl;
import java.sql.SQLException;
import java.util.*;
import java.sql.*;
import java.text.SimpleDateFormat;
import org.apache.log4j.xml.DOMConfigurator;

/**
 *
 * @author Walid
 */
public class LoginInformationMgr extends RDBGateWay {

    private final static LoginInformationMgr INFORMATION_MGR = new LoginInformationMgr();

    public static LoginInformationMgr getInstance() {
        return INFORMATION_MGR;
    }

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("login_information.xml")));
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

    public boolean save(String userId) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        int result = -1000;

        parameters.addElement(new StringValue(userId));
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("insert"));
            command.setparams(parameters);
            result = command.executeUpdate();
        } catch (SQLException se) {
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

        return (result > 0);
    }

    public boolean update(String userId) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        int result = -1000;

        parameters.addElement(new StringValue(userId));

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);

            // try update
            command.setSQLQuery(getQuery("update"));
            command.setparams(parameters);
            result = command.executeUpdate();
            if (result <= 0) {
                // start to store data
                command.setSQLQuery(getQuery("insert"));
                result = command.executeUpdate();
            }
        } catch (SQLException se) {
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

        return (result > 0);
    }

    public boolean delete(String userId) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        int result = -1000;

        parameters.addElement(new StringValue(userId));

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);

            // delete prev data if exsist
            command.setSQLQuery(getQuery("delete"));
            parameters = new Vector();
            parameters.addElement(new StringValue(userId));
            command.setparams(parameters);
            result = command.executeUpdate();
        } catch (SQLException se) {
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

        return (result > 0);
    }

    public Timestamp getLastLogin(String userId) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        Vector<Row> result;
        List<WebBusinessObject> data;

        parameters.addElement(new StringValue(userId));

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getByUserId"));
            command.setparams(parameters);
            result = command.executeQuery();

            for (Row row : result) {
                try {
                    return row.getTimestamp("LAST_LOGIN");
                } catch (NoSuchColumnException ex) {
                    logger.error(ex);
                } catch (UnsupportedConversionException ex) {
                    logger.error(ex);
                }
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

        return null;
    }

    public String getLastLogin(String userId, String state) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        Vector<Row> result;
        List<WebBusinessObject> data;

        parameters.addElement(new StringValue(userId));

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("select"));
            command.setparams(parameters);
            result = command.executeQuery();

            for (Row row : result) {
                try {
                    Timestamp time = row.getTimestamp("LAST_LOGIN");
                    SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
                    WebBusinessObject wbo = DateAndTimeControl.getFormattedDateTime2(formatter.format(time), state);
                    return "<font color=\"red\">" + wbo.getAttribute("day") + " - </font><b>" + wbo.getAttribute("time") + "</b>";
                } catch (NoSuchColumnException ex) {
                    logger.error(ex);
                } catch (UnsupportedConversionException ex) {
                    logger.error(ex);
                } catch (Exception ex) {
                    logger.error(ex);
                }
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

        return "---";
    }

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
    }
}
