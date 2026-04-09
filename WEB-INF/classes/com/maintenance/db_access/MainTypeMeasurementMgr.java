package com.maintenance.db_access;

import com.planning.db_access.*;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import java.util.*;
import javax.servlet.http.HttpSession;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.log4j.xml.DOMConfigurator;

public class MainTypeMeasurementMgr extends RDBGateWay {

    private static MainTypeMeasurementMgr mainTypeMeasurementMgr = new MainTypeMeasurementMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();

    public static MainTypeMeasurementMgr getInstance() {
        logger.info("Getting PlanMgr Instance ....");
        return mainTypeMeasurementMgr;
    }

    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("main_type_measurement.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;

    }

    public boolean saveObject(WebBusinessObject MainTypeMeasurementWbo, HttpSession s) throws NoUserInSessionException {
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        Connection connection = null;
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue((String) MainTypeMeasurementWbo.getAttribute("mainTypeId")));
        params.addElement(new StringValue((String) MainTypeMeasurementWbo.getAttribute("measurementId")));
        params.addElement(new StringValue((String) MainTypeMeasurementWbo.getAttribute("notes")));
        params.addElement(new StringValue((String) waUser.getAttribute("userId")));
        
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(getQuery("insertMainTypeMeasurement").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
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

    public boolean saveMultiObject(String mainTypeId,
                                   String[] measurementIdArr,
                                   String[] notesArr,
                                   HttpSession s) {

        Connection connection = null;
        WebBusinessObject MainTypeMeasurementWbo = null;

        int offset = 0;

        if (measurementIdArr != null) {
            if (notesArr.length > measurementIdArr.length) {
                offset = notesArr.length - measurementIdArr.length;

            }
        }

        try {
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            
            for(int i = 0; i < measurementIdArr.length; i++) {
                MainTypeMeasurementWbo = new WebBusinessObject();

                MainTypeMeasurementWbo.setAttribute("mainTypeId", mainTypeId);
                MainTypeMeasurementWbo.setAttribute("measurementId", measurementIdArr[i]);
                MainTypeMeasurementWbo.setAttribute("notes", (notesArr[i + offset].equals("")) ? "none" : notesArr[i + offset]);
                
                if(!this.saveObject(MainTypeMeasurementWbo, s)) {
                    connection.rollback();
                    return false;
                }

                try {
                    Thread.sleep(100);
                } catch (InterruptedException ex) {
                    logger.error(ex.getMessage());
                }

            }

        } catch (Exception ex) {
            try {
                logger.error(ex.getMessage());
                connection.rollback();
            } catch (SQLException ex1) {
                logger.error(ex1.getMessage());
            }
            return false;

        } finally {
            try {
                connection.commit();
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        return true;
    }

    public String getAttachedMeasurements(String mainTypeId) {
	Vector<Row> queryResult = new Vector<Row>();
	Vector params = new Vector();
	SQLCommandBean forQuery = new SQLCommandBean();
	String measurementIdsStr = "";
	try {
	   beginTransaction();
            forQuery.setConnection(transConnection);
            forQuery.setSQLQuery(getQuery("getAttachedMeasurements").trim());

            params.addElement(new StringValue(mainTypeId));
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
            endTransaction();

	}catch(SQLException se) {
            System.out.println("Error In executing Query.............!" + se.getMessage());
	}catch (UnsupportedTypeException ex) {
            Logger.getLogger(MainTypeMeasurementMgr.class.getName()).log(Level.SEVERE, null, ex);
        }
       for(int i=0;i<queryResult.size();i++) {
            try {
                if(i == queryResult.size()-1){
                    measurementIdsStr += "'" +((Row) queryResult.get(i)).getString("measurement_id").toString() + "'";
                }else{
                    measurementIdsStr += "'" +((Row) queryResult.get(i)).getString("measurement_id").toString() + "'" + ",";
                }
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(MainTypeMeasurementMgr.class.getName()).log(Level.SEVERE, null, ex);
            }

        }
	return measurementIdsStr;

    }

    public ArrayList getCashedTableAsBusObjects() {
        cashData();
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
            cashedData.add((String) wbo.getAttribute("id"));
        }

        return cashedData;
    }

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
        return; //   throw new UnsupportedOperationException("Not supported yet.");
    }

}