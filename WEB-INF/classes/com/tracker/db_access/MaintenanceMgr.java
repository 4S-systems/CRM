package com.tracker.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import java.sql.SQLException;
import java.util.*;
import javax.servlet.http.HttpSession;
import java.sql.*;

import com.tracker.business_objects.*;
import org.apache.log4j.xml.DOMConfigurator;

public class MaintenanceMgr extends RDBGateWay {

    private static MaintenanceMgr maintenanceMgr = new MaintenanceMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();

//    private static final String insertFunSQL = "INSERT INTO maintenance_type VALUES (?,?,?,now(),?)";
    public static MaintenanceMgr getInstance() {
        logger.info("Getting MaintenanceMgr Instance ....");
        return maintenanceMgr;
    }

    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("maintenance_type.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public boolean saveObject(WebBusinessObject wbo, HttpSession s) throws NoUserInSessionException {
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

        WebMaintenance maintenance = (WebMaintenance) wbo;
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        //params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue(maintenance.getMaintenanceName()));
        params.addElement(new StringValue((String) waUser.getAttribute("userId")));
        params.addElement(new StringValue(maintenance.getMaintenanceDesc()));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertMaintenanceType").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            //
            cashData();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
                return false;
            }
        }

        return (queryResult > 0);
    }

    public ArrayList getCashedTableAsBusObjects() {
        cashedData = new ArrayList();
        WebBusinessObject wbo = null;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add(wbo);
        }

        return cashedData;
    }

    public ArrayList getCashedTableAsArrayList() {

        cashedData = new ArrayList();
        WebBusinessObject wbo = null;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add((String) wbo.getAttribute("maintenanceName"));
        }

        return cashedData;
    }

    public boolean updateMaintenance(WebBusinessObject wbo) throws NoUserInSessionException {

        Vector params = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;


        params.addElement(new StringValue((String) wbo.getAttribute("maintenanceDesc")));
        params.addElement(new StringValue((String) wbo.getAttribute("maintenanceName")));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(sqlMgr.getSql("updateMaintenanceType").trim());
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();

            cashData();
        } catch (SQLException se) {
            logger.error("Exception updating maintenance: " + se.getMessage());
            return false;
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
                return false;
            }
        }

        return (queryResult > 0);
    }

    @Override
    protected void initSupportedQueries() {
      return; //  throw new UnsupportedOperationException("Not supported yet.");
    }
}
