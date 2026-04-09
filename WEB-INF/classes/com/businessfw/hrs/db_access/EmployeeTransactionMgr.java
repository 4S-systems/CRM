package com.businessfw.hrs.db_access;

import com.android.business_objects.LiteBusinessForm;
import com.android.business_objects.LiteWebBusinessObject;
import com.android.db_access.LiteRDBGateWay;
import com.android.exceptions.LiteNoSuchColumnException;
import com.android.exceptions.LiteUnsupportedConversionException;
import com.android.exceptions.LiteUnsupportedTypeException;
import com.android.persistence.LiteDateValue;
import com.android.persistence.LiteFloatValue;
import com.android.persistence.LiteRow;
import com.android.persistence.LiteSQLCommandBean;
import com.android.persistence.LiteStringValue;
import com.android.persistence.LiteTimestampValue;
import com.maintenance.common.Tools;
import com.maintenance.db_access.TaskExecutionMgr;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import java.util.*;
import javax.servlet.http.HttpSession;
import java.sql.*;
import com.android.business_objects.LiteBusinessForm;
import com.android.business_objects.LiteWebBusinessObject;
import com.android.db_access.LiteRDBGateWay;
import com.silkworm.business_objects.DOMFabricatorBean;
import java.sql.SQLException;
import java.util.ArrayList;
import org.apache.log4j.xml.DOMConfigurator;

public class EmployeeTransactionMgr extends LiteRDBGateWay {

    SqlMgr sqlMgr = SqlMgr.getInstance();

    public static EmployeeTransactionMgr employeeTransMgr = new EmployeeTransactionMgr();

    public static EmployeeTransactionMgr getInstance() {
        logger.info("Getting EmployeeTransactionMgr Instance ....");
        return employeeTransMgr;
    }

    public boolean saveEmpSalTransaction(HttpSession s, String rowId, String empId, String reqAmount, String reqType) throws NoUserInSessionException {
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

        Vector empTransaction = new Vector();

        LiteSQLCommandBean forInsert = new LiteSQLCommandBean();
        int queryResult = -1000;

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);

            queryResult = -1000;
            String transactionId = UniqueIDGen.getNextID();
            empTransaction.addElement(new LiteStringValue(transactionId));
            empTransaction.addElement(new LiteStringValue(empId));
            empTransaction.addElement(new LiteStringValue(rowId));
            empTransaction.addElement(new LiteStringValue("UL"));
            empTransaction.addElement(new LiteStringValue("salary"));

            if (reqType.equals("credit")) {
                empTransaction.addElement(new LiteFloatValue(new Float(0).floatValue()));
                empTransaction.addElement(new LiteFloatValue(new Float(reqAmount).floatValue()));
            } else {
                empTransaction.addElement(new LiteFloatValue(new Float(reqAmount).floatValue()));
                empTransaction.addElement(new LiteFloatValue(new Float(0).floatValue()));
            }

            empTransaction.addElement(new LiteStringValue((String) waUser.getAttribute("userId")));

            forInsert.setSQLQuery(sqlMgr.getSql("saveEmpTrans").trim());
            forInsert.setparams(empTransaction);
            queryResult = forInsert.executeUpdate();
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

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new LiteBusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("employee_trans.xml")));
                System.out.println("reading Successfully xml files....!");
            } catch (Exception e) {
                System.out.println("Error in reading xml files....!");
            }
        }
    }

    @Override
    public boolean saveObject(LiteWebBusinessObject lwbo) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
    }

    @Override
    public ArrayList getCashedTableAsArrayList() {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

}
