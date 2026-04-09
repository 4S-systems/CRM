package com.clients.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import java.sql.Connection;
import java.sql.SQLException;

import java.util.ArrayList;
import java.util.List;
import java.util.Vector;
import org.apache.log4j.xml.DOMConfigurator;

public class ClientComplaintsTimeLineMgr extends RDBGateWay {

    private static final ClientComplaintsTimeLineMgr CLIENT_COMPLAINTS_TIME_LINE_MGR = new ClientComplaintsTimeLineMgr();

    public static ClientComplaintsTimeLineMgr getInstance() {
        logger.info("Getting ClientComplaintsTimeLineMgr Instance ....");
        return CLIENT_COMPLAINTS_TIME_LINE_MGR;
    }

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("client_complaints_time_line.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document, " + e);
            }
        }
    }

    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    @Override
    public ArrayList getCashedTableAsArrayList() {
        cashedData = new ArrayList();
        WebBusinessObject wbo;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add((String) wbo.getAttribute("departmentCode"));
        }

        return cashedData;
    }

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
    }
    
    public List<WebBusinessObject> getClinetComplaintsTimeLineFromFinish() {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> result;
        List<WebBusinessObject> data = new ArrayList<WebBusinessObject>();

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getClinetComplaintsTimeLineFromFinish"));
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

    public List<WebBusinessObject> getClinetComplaintsToClosed(Integer interval) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> result;
        Vector parameters = new Vector();
        List<WebBusinessObject> data = new ArrayList<WebBusinessObject>();

        parameters.addElement(new IntValue(interval));

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getClinetComplaintsToClosed"));
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

    public List<WebBusinessObject> getClinetComplaintsToClosed(String departmentCode, Integer interval) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> result;
        Vector parameters = new Vector();
        List<WebBusinessObject> data = new ArrayList<WebBusinessObject>();

        parameters.addElement(new StringValue(departmentCode));
        parameters.addElement(new IntValue(interval));

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getClinetComplaintsToClosedByDepartmentCode"));
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

    public List<String> getClinetComplaintsIdsToClosed(String departmentCode, Integer interval) {
        List<String> ids = new ArrayList<String>();
        for (WebBusinessObject complaints : getClinetComplaintsToClosed(departmentCode, interval)) {
            ids.add((String) complaints.getAttribute("id"));
        }
        return ids;
    }
}
