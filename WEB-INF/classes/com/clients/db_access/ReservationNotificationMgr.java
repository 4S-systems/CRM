package com.clients.db_access;

import com.crm.common.CRMConstants;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import java.sql.Connection;
import java.sql.SQLException;

import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;
import java.util.Vector;
import org.apache.log4j.xml.DOMConfigurator;

public class ReservationNotificationMgr extends RDBGateWay {

    private static final ReservationNotificationMgr RESERVATION_NOTIFICATION_MGR = new ReservationNotificationMgr();

    public static ReservationNotificationMgr getInstance() {
        logger.info("Getting ReservationNotificationMgr Instance ....");
        return RESERVATION_NOTIFICATION_MGR;
    }

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("reservation_notification.xml")));
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
            cashedData.add((String) wbo.getAttribute("projectName"));
        }

        return cashedData;
    }

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
    }

    public List<WebBusinessObject> getReservation() {
        return getCashedTable();
    }

    public List<WebBusinessObject> getCanceledReservation() {
        return getReservation(CRMConstants.RESERVATION_STATUS_PENDING);
    }

    public List<WebBusinessObject> getReservation(String status) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> result;
        Vector parameters = new Vector();
        List<WebBusinessObject> data = new ArrayList<WebBusinessObject>();
        
        parameters.addElement(new StringValue(status));

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getCanceledReservation"));
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
}
