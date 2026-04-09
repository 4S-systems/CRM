package com.businessfw.hrs.db_access;

import com.android.business_objects.LiteBusinessForm;
import com.android.business_objects.LiteWebBusinessObject;
import com.android.db_access.LiteRDBGateWay;
import com.android.persistence.LiteFloatValue;
import com.android.persistence.LiteSQLCommandBean;
import com.businessfw.oms.db_access.ContractScheduleMgr;
import com.silkworm.Exceptions.NoUserInSessionException;
import com.silkworm.business_objects.DOMFabricatorBean;
import com.silkworm.persistence.relational.UniqueIDGen;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Vector;
import javax.servlet.http.HttpSession;
import org.apache.log4j.xml.DOMConfigurator;
import com.android.persistence.LiteStringValue;
import com.silkworm.business_objects.SqlMgr;
import com.silkworm.business_objects.WebBusinessObject;
import java.sql.Connection;
import java.sql.*;

public class EmployeeFinanceMgr extends LiteRDBGateWay {

    SqlMgr sqlMgr = SqlMgr.getInstance();
    
    public static EmployeeFinanceMgr employeeFinanceMgr = new EmployeeFinanceMgr();

    public static EmployeeFinanceMgr getInstance() {
        logger.info("Getting employeeFinanceMgr Instance ....");
        return employeeFinanceMgr;
    }

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new LiteBusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("employee_finance.xml")));
                System.out.println("reading Successfully xml files....!");
            } catch (Exception e) {
                System.out.println("Error in reading xml files....!");
            }
        }
    }

    public boolean saveSalary(LiteWebBusinessObject employeeFinance, HttpSession s) throws NoUserInSessionException {

        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

        Vector params = new Vector();
        
        LiteSQLCommandBean forInsert = new LiteSQLCommandBean();
        int queryResult = -1000;

        params.addElement(new LiteStringValue(UniqueIDGen.getNextID()));
        params.addElement(new LiteStringValue((String) employeeFinance.getAttribute("empID")));
        params.addElement(new LiteStringValue((String) employeeFinance.getAttribute("expnseId")));
        params.addElement(new LiteStringValue((String) employeeFinance.getAttribute("year")));
        params.addElement(new LiteStringValue((String) employeeFinance.getAttribute("month")));
        params.addElement(new LiteFloatValue(new Float(employeeFinance.getAttribute("salaryItem").toString()).floatValue()));
        params.addElement(new LiteStringValue((String)waUser.getAttribute("userId")));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertEmployeeFinance").trim());
            forInsert.setparams(params);
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
    public boolean saveObject(LiteWebBusinessObject lwbo) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
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
}
