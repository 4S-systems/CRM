package com.businessfw.hrs.db_access;

import com.silkworm.Exceptions.NoUserInSessionException;
import com.silkworm.business_objects.BusinessForm;
import com.silkworm.business_objects.DOMFabricatorBean;
import com.silkworm.business_objects.SqlMgr;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.persistence.relational.FloatValue;
import com.silkworm.persistence.relational.IntValue;
import com.silkworm.persistence.relational.RDBGateWay;
import com.silkworm.persistence.relational.SQLCommandBean;
import com.silkworm.persistence.relational.StringValue;
import com.silkworm.persistence.relational.UniqueIDGen;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.http.HttpSession;
import org.apache.log4j.xml.DOMConfigurator;

public class EmployeeProfileMgr extends RDBGateWay {

    SqlMgr sqlMgr = SqlMgr.getInstance();
    private static EmployeeProfileMgr employeeProfileMgr = new EmployeeProfileMgr();

    public EmployeeProfileMgr() {
    }

    public static EmployeeProfileMgr getInstance() {
        logger.info("Getting EmployeeProfileMgr Instance ....");
        return employeeProfileMgr;
    }

    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("employee_profile.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }
    
    public boolean saveEmpProfile(WebBusinessObject employeeProfile, HttpSession s) throws NoUserInSessionException {
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        EmployeeProfileMgr employeeProfileMgr = EmployeeProfileMgr.getInstance();
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        String profID = (String)employeeProfile.getAttribute("profID");
       if(profID == null || profID.isEmpty()){
            params.addElement(new StringValue(UniqueIDGen.getNextID()));
            params.addElement(new StringValue((String) employeeProfile.getAttribute("empID")));
            params.addElement(new StringValue((String) employeeProfile.getAttribute("deptID")));
            params.addElement(new IntValue(new Integer(employeeProfile.getAttribute("vacationNo").toString()).intValue()));
            params.addElement(new IntValue(new Integer(employeeProfile.getAttribute("tempVacationsNo").toString()).intValue()));
            params.addElement(new IntValue(new Integer(employeeProfile.getAttribute("tempLeavesNo").toString()).intValue()));
            params.addElement(new IntValue(new Integer(employeeProfile.getAttribute("WorkingHours").toString()).intValue()));
            params.addElement(new StringValue((String) employeeProfile.getAttribute("workType")));
            params.addElement(new FloatValue(new Float(employeeProfile.getAttribute("salary").toString()).floatValue()));
            params.addElement(new StringValue((String) waUser.getAttribute("userId")));

            Connection connection = null;
            try {
                connection = dataSource.getConnection();
                forInsert.setConnection(connection);
                String sql = "INSERT INTO EMPLOYEE_PROFILE (ID, EMP_ID, DEPT_ID, VACATIONS, TEMP_VACATIONS, TEMP_LEAVE, WORKING_HOURS, WORK_TYPE,SALARY, CREATION_TIME, CREATED_BY) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ? , SYSDATE, ?)".trim();
                forInsert.setSQLQuery(sql);
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
       } else {
            params.addElement(new StringValue((String) employeeProfile.getAttribute("deptID")));
            params.addElement(new IntValue(new Integer(employeeProfile.getAttribute("vacationNo").toString()).intValue()));
            params.addElement(new IntValue(new Integer(employeeProfile.getAttribute("tempVacationsNo").toString()).intValue()));
            params.addElement(new IntValue(new Integer(employeeProfile.getAttribute("tempLeavesNo").toString()).intValue()));
            params.addElement(new IntValue(new Integer(employeeProfile.getAttribute("WorkingHours").toString()).intValue()));
            params.addElement(new StringValue((String) employeeProfile.getAttribute("workType")));
            params.addElement(new FloatValue(new Float(employeeProfile.getAttribute("salary").toString()).floatValue()));
            params.addElement(new StringValue((String) employeeProfile.getAttribute("empID")));
            
            Connection connection = null;
            try {
                connection = dataSource.getConnection();
                forInsert.setConnection(connection);
                String sql = "UPDATE EMPLOYEE_PROFILE SET  DEPT_ID = ?, VACATIONS = ?, TEMP_VACATIONS = ?, TEMP_LEAVE = ?, WORKING_HOURS = ?, WORK_TYPE = ?, SALARY = ? WHERE EMP_ID = ?".trim();
                forInsert.setSQLQuery(sql);
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
       }

        return (queryResult > 0);
    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    @Override
    public ArrayList getCashedTableAsArrayList() {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }
    
    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
    }
}
