package com.contractor.db_access;

import com.silkworm.xml.DOMFabricatorBean;
import com.silkworm.business_objects.*;
import java.util.*;
import com.silkworm.persistence.relational.*;
import java.sql.*;
import org.apache.log4j.xml.DOMConfigurator;

public class PeriodicMgr extends RDBGateWay {

    SqlMgr sqlMgr = SqlMgr.getInstance();
//    private static final String insertSQL = "INSERT INTO PERIODIC_MAINTENANCE (ID, MAINTENANCE_TITLE, UNIT_ID, DESCRIPTION, FREQUENCY, FREQUENCY_TYPE, BEGIN_DATE, CREATION_TIME, USER_ID) VALUES (?,?,?,?,?,?,?,now(),'123456789')";
    private static PeriodicMgr periodicMgr = new PeriodicMgr();

    private PeriodicMgr() {
    }

    public static PeriodicMgr getInstance() {
        logger.info("Getting Periodic Mgr Instance ....");
        return periodicMgr;
    }

    public boolean deletObject(com.silkworm.business_objects.WebBusinessObject wbo) throws java.sql.SQLException {
        return false;
    }

    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("periodicMaintenance.xml")));
            } catch (Exception e) {
                logger.error(e.getMessage());
            }
        }
    }

    public boolean saveObject(com.silkworm.business_objects.WebBusinessObject wbo) throws java.sql.SQLException {
        return false;
    }

    public boolean saveNewObject(com.silkworm.business_objects.WebBusinessObject wbo) throws java.sql.SQLException {

        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        params.addElement(new StringValue((String) wbo.getAttribute("id")));
        params.addElement(new StringValue((String) wbo.getAttribute("maintenanceTitle")));
        params.addElement(new StringValue((String) wbo.getAttribute("unitID")));
        params.addElement(new StringValue((String) wbo.getAttribute("desc")));
        params.addElement(new IntValue((Integer) wbo.getAttribute("frequency")));
        params.addElement(new IntValue((Integer) wbo.getAttribute("frequencyType")));
        params.addElement(new DateValue((java.sql.Date) wbo.getAttribute("beginDate")));
        Connection connection = dataSource.getConnection();
        try {
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertPeriodic").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
        } catch (SQLException se) {
            throw se;
        } finally {

            connection.close();
        }
        return queryResult > 0;
    }

    public boolean updateObject(com.silkworm.business_objects.WebBusinessObject wbo) throws java.sql.SQLException {
        return false;
    }

    protected WebBusinessObject fabricateBusObj(Row r) {
        ListIterator li = supportedForm.getFormElemnts().listIterator();
        FormElement fe = null;
        Hashtable ht = new Hashtable();
        String colName;
        String state = null;
        String docOwnerId = null;
        while (li.hasNext()) {

            try {
                fe = (FormElement) li.next();
                colName = (String) fe.getAttribute("column");
                // needs a case ......
                ht.put(fe.getAttribute("name"), r.getString(colName));
            } catch (Exception e) {

            }
        }
        MaintainableUnit expense = new MaintainableUnit(ht);
        return (WebBusinessObject) expense;
    }

    protected void notifyBusinessObjectEvent(WebBusinessObject subject, String eventName) {

    }

    public ArrayList getCashedTableAsArrayList() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    protected void initSupportedQueries() {
      return;  //throw new UnsupportedOperationException("Not supported yet.");
    }
}
