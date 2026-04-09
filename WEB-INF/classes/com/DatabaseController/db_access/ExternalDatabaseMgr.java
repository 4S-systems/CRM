package com.DatabaseController.db_access;

import com.silkworm.business_objects.BusinessForm;
import com.silkworm.business_objects.DOMFabricatorBean;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.common.MetaDataMgr;
import com.silkworm.persistence.relational.NoSuchColumnException;
import com.silkworm.persistence.relational.RDBGateWay;
import com.silkworm.persistence.relational.Row;
import com.silkworm.persistence.relational.SQLCommandBean;
import com.silkworm.persistence.relational.StringValue;
import com.silkworm.persistence.relational.UnsupportedTypeException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.Vector;
import org.apache.log4j.Logger;
import org.apache.log4j.xml.DOMConfigurator;

public class ExternalDatabaseMgr extends RDBGateWay {

    private static Logger logger;

    private static final ExternalDatabaseMgr externalDatabaseMgr = new ExternalDatabaseMgr();
    private final MetaDataMgr metaDataMgr;
    private final String OFOUK_TYPE = "1";
    private final String RABWA_TYPE = "2";

    public ExternalDatabaseMgr() {
        this.metaDataMgr = MetaDataMgr.getInstance();
        logger = Logger.getLogger(ExternalDatabaseMgr.class);
    }

    public static ExternalDatabaseMgr getInstance() {
        logger.info("get Instance from database configuration mgr");
        return externalDatabaseMgr;
    }

    public Connection getConnection(String databaseType) throws SQLException {
        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
        } catch (ClassNotFoundException e) {
            System.out.println("ClassNotFoundException --> " + e.getMessage());
            logger.error("ClassNotFoundException --> " + e.getMessage());
            return null;
        }
        Connection connection = null;
        if (databaseType != null) {
            if (databaseType.equals(OFOUK_TYPE)) {
                connection = DriverManager.getConnection(metaDataMgr.getExternalDB1());
            } else if (databaseType.equals(RABWA_TYPE)) {
                connection = DriverManager.getConnection(metaDataMgr.getExternalDB2());
            }
        }
        return connection;
    }

    public ArrayList<WebBusinessObject> getClientFinancialReport(String clientId, String databaseType) throws SQLException, NoSuchColumnException {
        String theQuery = getQuery("getClientFinancialReport");
        Vector parameters = new Vector();
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = this.getConnection(databaseType);
        if (connection == null) {
            throw new SQLException("Can not connect to server");
        }
        try {
            parameters.addElement(new StringValue(clientId));
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(theQuery);
            forQuery.setparams(parameters);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            throw se;
        } catch (UnsupportedTypeException uste) {
            logger.error("Persistence Error " + uste.getMessage());
        } finally {
            connection.close();
        }
        Row r;
        Enumeration e = queryResult.elements();
        ArrayList<WebBusinessObject> clientUnitsList = new ArrayList<WebBusinessObject>();
        WebBusinessObject wbo;
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = fabricateBusObj(r);
            clientUnitsList.add(wbo);
        }
        return clientUnitsList;
    }

    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return true;
    }

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("external_unit_view.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
    }

    @Override
    public ArrayList getCashedTableAsArrayList() {
        cashedData = new ArrayList();
        WebBusinessObject wbo;
        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add((String) wbo.getAttribute("id"));
            cashedData.add((String) wbo.getAttribute("nameAr"));
            cashedData.add((String) wbo.getAttribute("nameEn"));
        }
        return cashedData;
    }
}
