package com.businessfw.oms.db_access;

import com.android.business_objects.LiteBusinessForm;
import com.android.business_objects.LiteWebBusinessObject;
import com.android.db_access.LiteRDBGateWay;
import com.android.exceptions.LiteNoSuchColumnException;
import com.android.exceptions.LiteUnsupportedTypeException;
import com.android.persistence.LiteDateValue;
import com.android.persistence.LiteIntValue;
import com.android.persistence.LiteRow;
import com.android.persistence.LiteSQLCommandBean;
import com.android.persistence.LiteStringValue;
import com.android.persistence.LiteTimestampValue;
import com.android.persistence.LiteUniqueIDGen;
import com.silkworm.business_objects.DOMFabricatorBean;
import java.sql.Connection;
import java.sql.Date;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.log4j.xml.DOMConfigurator;

public class ContractScheduleMgr extends LiteRDBGateWay {

    public static ContractScheduleMgr contractScheduleMgr = new ContractScheduleMgr();

    public static ContractScheduleMgr getInstance() {
        logger.info("Getting ContractScheduleMgr Instance ....");
        return contractScheduleMgr;
    }

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new LiteBusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("contract_schedule.xml")));
                System.out.println("reading Successfully xml files....!");
            } catch (Exception e) {
                System.out.println("Error in reading xml files....!");
            }
        }
    }

    @Override
    public boolean saveObject(LiteWebBusinessObject wbo) throws SQLException {
        return false;
    }

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
    }

    @Override
    public ArrayList getCashedTableAsArrayList() {
        ArrayList al = null;
        return al;
    }

    public String insertContractSchedule(LiteWebBusinessObject wbo) {
        Vector params = new Vector();
        String id = LiteUniqueIDGen.getNextID();
        params.addElement(new LiteStringValue(id));
        params.addElement(new LiteStringValue((String) wbo.getAttribute("contractID")));
        params.addElement(new LiteStringValue((String) wbo.getAttribute("scheduleTitle")));
        params.addElement(new LiteIntValue((Integer) wbo.getAttribute("frequencyRate")));
        params.addElement(new LiteIntValue((Integer) wbo.getAttribute("frequencyType")));
        params.addElement(new LiteStringValue((String) wbo.getAttribute("scheduleStatus")));
        params.addElement(new LiteStringValue((String) wbo.getAttribute("scheduleType")));
        params.addElement(new LiteDateValue((Date) wbo.getAttribute("fromDate")));
        params.addElement(new LiteDateValue((Date) wbo.getAttribute("toDate")));
        params.addElement(new LiteStringValue((String) wbo.getAttribute("userID")));
        params.addElement(new LiteStringValue((String) wbo.getAttribute("option1")));
        params.addElement(new LiteStringValue((String) wbo.getAttribute("option2")));
        params.addElement(new LiteStringValue((String) wbo.getAttribute("option3")));
        params.addElement(new LiteStringValue((String) wbo.getAttribute("option4")));
        params.addElement(new LiteStringValue((String) wbo.getAttribute("option5")));
        params.addElement(new LiteStringValue((String) wbo.getAttribute("option6")));
        int queryResult = -1;
        LiteSQLCommandBean forInsert = new LiteSQLCommandBean();
        try {
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(getQuery("insertContractSchedule").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
        } catch (SQLException se) {
            System.out.println("Error in saving Contract Schedule .............!" + se.getMessage());
        } finally {
            endTransaction();
        }
        return (queryResult > 0 ? id : null);
    }

    public ArrayList<LiteWebBusinessObject> getContractSchedulesList() {
        Connection connection = null;
        Vector SQLparams = new Vector();
        Vector queryResult = null;
        LiteSQLCommandBean forQuery = new LiteSQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getContractSchedulesList").trim());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (LiteUnsupportedTypeException ex) {
            Logger.getLogger(ContractScheduleMgr.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }
        ArrayList<LiteWebBusinessObject> resultBusObjs = new ArrayList<>();
        LiteWebBusinessObject wbo;
        LiteRow r;
        if (queryResult != null) {
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                r = (LiteRow) e.nextElement();
                wbo = fabricateBusObj(r);
                try {
                    if (r.getString("CONTACT_NUMBER") != null) {
                        wbo.setAttribute("contractNumber", r.getString("CONTACT_NUMBER"));
                    }
                    if (r.getString("SCHEDULE_STATUS_NAME") != null) {
                        wbo.setAttribute("scheduleStatusName", r.getString("SCHEDULE_STATUS_NAME"));
                    }
                } catch (LiteNoSuchColumnException ex) {
                    Logger.getLogger(ContractScheduleMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                resultBusObjs.add(wbo);
            }
        }
        return resultBusObjs;
    }

    public String updateContractSchedule(LiteWebBusinessObject wbo) {
        Vector params = new Vector();
        String id = LiteUniqueIDGen.getNextID();
        params.addElement(new LiteStringValue((String) wbo.getAttribute("contractID")));
        params.addElement(new LiteStringValue((String) wbo.getAttribute("scheduleTitle")));
        params.addElement(new LiteIntValue(new Integer((String) wbo.getAttribute("frequencyRate"))));
        params.addElement(new LiteIntValue(new Integer((String) wbo.getAttribute("frequencyType"))));
        params.addElement(new LiteStringValue((String) wbo.getAttribute("scheduleType")));
        params.addElement(new LiteTimestampValue(new Timestamp((Long) wbo.getAttribute("fromDate"))));
        params.addElement(new LiteTimestampValue(new Timestamp((Long) wbo.getAttribute("toDate"))));
        params.addElement(new LiteStringValue((String) wbo.getAttribute("id")));
        int queryResult = -1;
        LiteSQLCommandBean forUpdate = new LiteSQLCommandBean();
        try {
            beginTransaction();
            forUpdate.setConnection(transConnection);
            forUpdate.setSQLQuery(getQuery("updateContractSchedule").trim());
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();
        } catch (SQLException se) {
            System.out.println("Error in saving Contract Schedule .............!" + se.getMessage());
        } finally {
            endTransaction();
        }
        return (queryResult > 0 ? id : null);
    }

    public boolean updateContractScheduleStatus(String newStatus, String scheduleID) {
        Vector params = new Vector();
        params.addElement(new LiteStringValue(newStatus));
        params.addElement(new LiteStringValue(scheduleID));
        int queryResult = -1;
        LiteSQLCommandBean forUpdate = new LiteSQLCommandBean();
        try {
            beginTransaction();
            forUpdate.setConnection(transConnection);
            forUpdate.setSQLQuery(getQuery("updateContractScheduleStatus").trim());
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();
        } catch (SQLException se) {
            System.out.println("Error in updating Contract Schedule Status .............!" + se.getMessage());
        } finally {
            endTransaction();
        }
        return (queryResult > 0);
    }
}
