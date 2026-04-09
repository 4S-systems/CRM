package com.DatabaseController.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.common.MetaDataMgr;
import java.io.File;
import java.math.BigDecimal;
import java.util.*;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.input.SAXBuilder;

public class DatabaseControllerMgr extends RDBGateWay {

    public static final String _GL = "GENERAL_LEDGER_SCHEMA";
    public static final String _PAY = "PAYROLL_SCHEMA";
    public static final String _STR = "STORE_SCHEMA";
    public static final String _UNITS = "UNITS_SCHEMA";
    public static final String _BANK = "Bank_SCHEMA";
    public static final String VIEW_VALID_STATUS = "VALID";
    public static final String VIEW_INVALID_STATUS = "INVALID";
    public static final String ATTRIBUTE_VIEWS_XML_VIEW = "view";
    public static final String ATTRIBUTE_VIEWS_XML_DECRIPTION_EN = "description-en";
    public static final String ATTRIBUTE_VIEWS_XML_DECRIPTION_AR = "description-ar";
    public static final String ATTRIBUTE_VIEWS_XML_VIEW_STATMENT = "viewstatment";
    public static final String ATTRIBUTE_VIEWS_XML_VIEW_NAME = "viewname";
    public static final String ATTRIBUTE_VIEWS_XML_VIEW_INDEX = "viewIndex";
    public static final String PATH_DATABASE_UPDATE_XML = staticWebInfPath + "/database/DataBaseUpdate.xml";
    public static final String PATH_VIEWS_XML = staticWebInfPath + "/database/Views.xml";
    private Document document;
    private Element elements = null;
    private List<Element> listElements;
    private SAXBuilder builder = new SAXBuilder();
    private static DatabaseControllerMgr databaseControllerMgr = new DatabaseControllerMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();

    private DatabaseControllerMgr() {
        try {
            document = builder.build(new File(DatabaseControllerMgr.PATH_VIEWS_XML));
        } catch (JDOMException ex) {
            logger.error(ex.getMessage());
        } catch (Exception ex) {
            logger.error(ex.getMessage());
        }

        elements = document.getRootElement();
        listElements = elements.getChildren();
    }

    public static DatabaseControllerMgr getInstance() {
        logger.error("Getting databaseControllerMgr Instance ....");
        return databaseControllerMgr;
    }

    protected void initSupportedForm() {
    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public boolean saveObject() {
        return false;
    }

    @Override
    public ArrayList getCashedTableAsBusObjects() {
        return null;
    }

    public ArrayList getCashedTableAsArrayList() {
        return null;
    }

    public Integer getLastIndex() throws SQLException, UnsupportedTypeException, NoSuchColumnException, UnsupportedConversionException {

        Integer lastIndex = 1;
        BigDecimal bigDecimal;
        Vector queryResult;
        SQLCommandBean commandBean = new SQLCommandBean();
        String query = "Select LAST_UPD from DB_update";
        Connection connection = null;

        connection = dataSource.getConnection();
        commandBean.setSQLQuery(query);
        commandBean.setConnection(connection);
        queryResult = commandBean.executeQuery();

        if (queryResult.size() > 0) {
            bigDecimal = ((Row) queryResult.get(0)).getBigDecimal("LAST_UPD");
            lastIndex = bigDecimal.intValue();
        }

        connection.close();

        return lastIndex;

    }

    public boolean updateLastIndes(Long lastIndex) throws SQLException {

        String query = "update DB_update set LAST_UPD = ?";
        int queryResult = -1000;
        Vector params = new Vector();
        SQLCommandBean commandBean = new SQLCommandBean();

        params.addElement(new LongValue(lastIndex));

        Connection connection;
        connection = dataSource.getConnection();
        commandBean.setSQLQuery(query);
        commandBean.setConnection(connection);
        commandBean.setparams(params);
        queryResult = commandBean.executeUpdate();

        connection.close();
        return queryResult > 0;
    }

    public boolean commit() throws SQLException {
        boolean res = execute("commit");
        return res;
    }

    public boolean rollback() throws SQLException {
        boolean res = execute("rollback");
        return res;
    }

    public boolean execute(String query) throws SQLException {
        int queryResult = -1000;
        SQLCommandBean commandBean = new SQLCommandBean();

        Connection connection;
        connection = dataSource.getConnection();
        commandBean.setSQLQuery(query);
        commandBean.setConnection(connection);
        queryResult = commandBean.executeUpdate();

        connection.close();
        return queryResult > 0;
    }

    public boolean isConnected(String host, String service, String userName, String password) {
        MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
        String driver = metaDataMgr.getDriverErp();
        String URL = "jdbc:oracle:thin:@" + host + ":1521:" + service;
        Connection conn = null;
        try {
            Class.forName(driver);
            conn = DriverManager.getConnection(URL, userName, password);
        } catch (Exception se) {
            logger.error("database error " + se.getMessage());
            return false;
        } finally {
            try {
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return false;
            }
        }
        return true;
    }

    public boolean isSchemaFound(String owner) {
        SQLCommandBean commandBean = new SQLCommandBean();
        Vector params = new Vector();
        Connection connection = null;
        Vector quaryResualt = new Vector();

        owner = owner.toUpperCase();
        params.addElement(new StringValue(owner));

        try {
            connection = dataSource.getConnection();
            commandBean.setConnection(connection);
            commandBean.setSQLQuery(sqlMgr.getSql("isSchemaFound").trim());
            commandBean.setparams(params);

            quaryResualt = commandBean.executeQuery();
        } catch (UnsupportedTypeException ex) {
            logger.error(ex.getMessage());
        } catch (SQLException ex) {
            logger.error(ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        return quaryResualt.size() > 0;
    }

    public WebBusinessObject checkAllViews() {
        Vector validViews = getAllView(DatabaseControllerMgr.VIEW_VALID_STATUS);
        Vector invalidViews = getAllView(DatabaseControllerMgr.VIEW_INVALID_STATUS);

        WebBusinessObject wbo = new WebBusinessObject();
        wbo.setAttribute(DatabaseControllerMgr.VIEW_VALID_STATUS, validViews);
        wbo.setAttribute(DatabaseControllerMgr.VIEW_INVALID_STATUS, invalidViews);

        return wbo;
    }

    public Vector getAllView(String status) {
        SQLCommandBean selectCommand = new SQLCommandBean();
        Vector queryResult = new Vector();
        Vector<WebBusinessObject> vectorView = new Vector<WebBusinessObject>();
        WebBusinessObject wbo;
        Vector params = new Vector();
        String viewName;
        Row row;
        Connection connection = null;

        try {
            connection = dataSource.getConnection();

            params.addElement(new StringValue(connection.getMetaData().getUserName()));
            params.addElement(new StringValue(status));

            selectCommand.setConnection(connection);
            selectCommand.setSQLQuery(sqlMgr.getSql("selectAllViews").trim());
            selectCommand.setparams(params);
            queryResult = selectCommand.executeQuery();

            for (int i = 0; i < queryResult.size(); i++) {
                row = (Row) queryResult.get(i);
                viewName = row.getString("OBJECT_NAME");
                wbo = new WebBusinessObject();
                wbo.setAttribute("viewQuary", viewName);
                wbo.setAttribute("message", status);
                setDescriptionAndIndexWbo(viewName, wbo);
                vectorView.addElement(wbo);
            }

        } catch (Exception ex) {
            logger.error(ex.getMessage());
            return null;
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
                return null;
            }
        }
        return vectorView;
    }

    public boolean IgnoreDBError() {
        SQLCommandBean commandBean = new SQLCommandBean();
        Connection connection = null;
        int quaryResualt = -1000;
        try {
            connection = dataSource.getConnection();
            commandBean.setConnection(connection);
            commandBean.setSQLQuery(sqlMgr.getSql("incrementDBIndexbyOne").trim());
            quaryResualt = commandBean.executeUpdate();
        } catch (SQLException ex) {
            logger.error(ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }
        return quaryResualt > 0;
    }

    public void setDescriptionAndIndexWbo(String viewName, WebBusinessObject wbo) {
        try {
            for (Element element : listElements) {
                if (element.getChild(ATTRIBUTE_VIEWS_XML_VIEW_NAME).getText().equalsIgnoreCase(viewName)) {
                    wbo.setAttribute(ATTRIBUTE_VIEWS_XML_DECRIPTION_AR, element.getChild(ATTRIBUTE_VIEWS_XML_DECRIPTION_AR).getText());
                    wbo.setAttribute(ATTRIBUTE_VIEWS_XML_DECRIPTION_EN, element.getChild(ATTRIBUTE_VIEWS_XML_DECRIPTION_EN).getText());
                    wbo.setAttribute(ATTRIBUTE_VIEWS_XML_VIEW_INDEX, element.getChild(ATTRIBUTE_VIEWS_XML_VIEW_INDEX).getText());
                    return;
                }
            }

            wbo.setAttribute(ATTRIBUTE_VIEWS_XML_DECRIPTION_AR, "***");
            wbo.setAttribute(ATTRIBUTE_VIEWS_XML_DECRIPTION_EN, "***");
            wbo.setAttribute(ATTRIBUTE_VIEWS_XML_VIEW_INDEX, "***");
        } catch (Exception ex) {
            wbo.setAttribute(ATTRIBUTE_VIEWS_XML_DECRIPTION_AR, "***");
            wbo.setAttribute(ATTRIBUTE_VIEWS_XML_DECRIPTION_EN, "***");
            wbo.setAttribute(ATTRIBUTE_VIEWS_XML_VIEW_INDEX, "***");

            logger.error(ex.getMessage());
        }
    }

    public boolean killInactiveSessions() {
        SQLCommandBean commandBean = new SQLCommandBean();
        Connection connection = null;
        int queryResult = -1000;
        Vector result = null;
        Vector params = new Vector();
        try {
            params.addElement(new StringValue(metaDataMgr.getUserName().toUpperCase()));
            connection = dataSource.getConnection();
            commandBean.setConnection(connection);
            commandBean.setSQLQuery(sqlMgr.getSql("killInactiveSessions").trim());
            commandBean.setparams(params);
            result = commandBean.executeQuery();
            if (result != null) {
                Row r;
                Enumeration e = result.elements();
                commandBean.setparams(null);
                while (e.hasMoreElements()) {
                    r = (Row) e.nextElement();
                    try {
                        if(r.getString("STATEMENT") != null){
                            commandBean.setSQLQuery(r.getString("STATEMENT"));
                            queryResult = commandBean.executeUpdate();
                        }
                    } catch (NoSuchColumnException ex) {
                        Logger.getLogger(DatabaseControllerMgr.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
            }
        } catch (SQLException ex) {
            logger.error(ex.getMessage());
        } catch (UnsupportedTypeException ex) {
            Logger.getLogger(DatabaseControllerMgr.class.getName()).log(Level.SEVERE, null, ex);
        } catch (Exception ex) {
            Logger.getLogger(DatabaseControllerMgr.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }
        return queryResult > 0;
    }

    @Override
    protected void initSupportedQueries() {
        return; //  throw new UnsupportedOperationException("Not supported yet.");
    }
}
