package com.businessfw.hrs.db_access;

import com.android.business_objects.LiteBusinessForm;
import com.android.business_objects.LiteWebBusinessObject;
import com.android.db_access.LiteRDBGateWay;
import com.android.persistence.LiteNullValue;
import com.android.persistence.LiteSQLCommandBean;
import com.android.persistence.LiteStringValue;
import com.android.persistence.LiteTimestampValue;
import com.android.persistence.LiteUniqueIDGen;
import com.silkworm.business_objects.DOMFabricatorBean;
import com.silkworm.business_objects.WebBusinessObject;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Vector;
import org.apache.log4j.xml.DOMConfigurator;

public class EmployeeLoginMgr extends LiteRDBGateWay {

    private static final EmployeeLoginMgr employeeLoginMgr = new EmployeeLoginMgr();

    public static EmployeeLoginMgr getInstance() {
        logger.info("Getting EmployeeLoginMgr Instance ....");
        return employeeLoginMgr;
    }

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new LiteBusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("employee_login.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    @Override
    public ArrayList getCashedTableAsBusObjects() {
        cashedData = new ArrayList();
        LiteWebBusinessObject wbo;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (LiteWebBusinessObject) cashedTable.elementAt(i);
            cashedData.add(wbo);
        }

        return cashedData;
    }

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
    }

    @Override
    public ArrayList getCashedTableAsArrayList() {
        cashedData = new ArrayList();
        WebBusinessObject wbo = null;
        if (cashedTable != null) {
            for (int i = 0; i < cashedTable.size(); i++) {
                wbo = (WebBusinessObject) cashedTable.elementAt(i);
                cashedData.add((String) wbo.getAttribute("name"));
            }
        }

        return cashedData;
    }

    @Override
    public boolean saveObject(LiteWebBusinessObject lwbo) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    public boolean insertEmployeeLogin(ArrayList<LiteWebBusinessObject> employeeLoginList) {
        Vector params;
        String id;
        int queryResult = -1;
        LiteSQLCommandBean forInsert = new LiteSQLCommandBean();
        try {
            beginTransaction();
            for (LiteWebBusinessObject wbo : employeeLoginList) {
                id = LiteUniqueIDGen.getNextID();
                params = new Vector();
                params.addElement(new LiteStringValue(id));
                params.addElement(new LiteStringValue((String) wbo.getAttribute("employeeName")));
                params.addElement(new LiteStringValue((String) wbo.getAttribute("employeeNo")));
                params.addElement(!"".equals(wbo.getAttribute("loginDate")) ? new LiteTimestampValue((Timestamp) wbo.getAttribute("loginDate")) : new LiteNullValue());
                params.addElement(!"".equals(wbo.getAttribute("logoutDate")) ? new LiteTimestampValue((Timestamp) wbo.getAttribute("logoutDate")) : new LiteNullValue());
                params.addElement(new LiteStringValue((String) wbo.getAttribute("timeTable")));
                params.addElement(new LiteStringValue((String) wbo.getAttribute("userID")));
                params.addElement(new LiteStringValue((String) wbo.getAttribute("option1")));
                params.addElement(new LiteStringValue((String) wbo.getAttribute("option2")));
                params.addElement(new LiteStringValue((String) wbo.getAttribute("option3")));
                params.addElement(new LiteStringValue((String) wbo.getAttribute("option4")));
                params.addElement(new LiteStringValue((String) wbo.getAttribute("option5")));
                params.addElement(new LiteStringValue((String) wbo.getAttribute("option6")));
                forInsert.setConnection(transConnection);
                forInsert.setSQLQuery(getQuery("insertEmployeeLogin"));
                forInsert.setparams(params);
                queryResult = forInsert.executeUpdate();
            }
        } catch (SQLException se) {
            return false;
        } finally {
            endTransaction();
        }
        return queryResult > 0;
    }
}
