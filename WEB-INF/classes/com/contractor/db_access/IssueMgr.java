/*
 * ExpenseMgr.java
 *
 * Created on November 28, 2004, 9:30 AM
 */
package com.contractor.db_access;

import com.silkworm.xml.DOMFabricatorBean;
import com.silkworm.business_objects.*;
import java.util.*;
import com.silkworm.persistence.relational.*;
import com.silkworm.events.*;

import java.sql.*;
import javax.sql.*;
import org.apache.log4j.xml.DOMConfigurator;

/**
 *
 * @author Walid
 */
public class IssueMgr extends RDBGateWay {

    /**
     * Creates a new instance of MaintainableMgr
     */
    private static final String insertSQL = "INSERT INTO issue VALUES (?,?,?,\"UL\",?,?,?,?,now(),\"Schedule\",now(),\"UL\",\"UL\",\"UL\",\"UL\",0,?,?,0,0,0,0,0)";
    private static final String updateSQL = "UPDATE maintainable_unit SET UNIT_NAME=?,SITE=?,DESCRIPTION=?,PURCHASE_DATE=?,OPERATION_S_DATE=?,IS_MAINTAINABLE=?,NO_OF_HOURS=? WHERE ID=?";
    private static final String deleteSQL = "DELETE FROM maintainable_unit WHERE ID = ?";
    private static final String deleteChildSQL = "DELETE FROM maintainable_unit WHERE PARENT_ID = ?";
    private static final String expenseSQL = "SELECT * FROM maintainable_unit ORDER BY UNIT_NAME";
    private static IssueMgr issueMgr = new IssueMgr();

    private IssueMgr() {
    }

    public static IssueMgr getInstance() {
        logger.info("Getting Issue Mgr Instance ....");
        return issueMgr;
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
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("issue.xml")));
            } catch (Exception e) {
                logger.error(e.getMessage());
            }
        }
    }

    public boolean saveObject(com.silkworm.business_objects.WebBusinessObject wbo) throws java.sql.SQLException {
        return false;
    }

    public void saveNewObject(com.silkworm.business_objects.WebBusinessObject wbo) throws java.sql.SQLException {
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue((String) wbo.getAttribute("maintenanceTitle")));
        params.addElement(new StringValue((String) wbo.getAttribute("site")));
        params.addElement(new StringValue((String) wbo.getAttribute("machine")));
        params.addElement(new StringValue("123456789"));
        params.addElement(new StringValue("Normal"));
        params.addElement(new StringValue((String) wbo.getAttribute("desc")));
        params.addElement(new DateValue((java.sql.Date) wbo.getAttribute("beginDate")));
        params.addElement(new DateValue((java.sql.Date) wbo.getAttribute("endDate")));

        Connection connection = dataSource.getConnection();
        try {
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(insertSQL);
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
        } catch (SQLException se) {
            throw se;
        } finally {

            connection.close();
        }
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
        return; //    throw new UnsupportedOperationException("Not supported yet.");
    }
}
