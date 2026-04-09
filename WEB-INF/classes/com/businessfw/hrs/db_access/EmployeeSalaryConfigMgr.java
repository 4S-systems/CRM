package com.businessfw.hrs.db_access;

import com.android.business_objects.LiteBusinessForm;
import com.android.business_objects.LiteWebBusinessObject;
import com.android.db_access.LiteRDBGateWay;
import com.android.exceptions.LiteNoSuchColumnException;
import com.android.exceptions.LiteUnsupportedConversionException;
import com.android.exceptions.LiteUnsupportedTypeException;
import com.android.persistence.LiteFloatValue;
import com.android.persistence.LiteRow;
import com.android.persistence.LiteSQLCommandBean;
import com.android.persistence.LiteStringValue;
import com.silkworm.business_objects.DOMFabricatorBean;
import com.silkworm.business_objects.SqlMgr;
import com.silkworm.persistence.relational.NoSuchColumnException;
import com.silkworm.persistence.relational.UniqueIDGen;
import com.silkworm.persistence.relational.UnsupportedConversionException;
import com.silkworm.persistence.relational.UnsupportedTypeException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.Vector;
import org.apache.log4j.Logger;
import org.apache.log4j.xml.DOMConfigurator;

public class EmployeeSalaryConfigMgr extends LiteRDBGateWay {
    
    SqlMgr sqlMgr = SqlMgr.getInstance();

    private static EmployeeSalaryConfigMgr empSalaryConfigMgr = new EmployeeSalaryConfigMgr();

    public static EmployeeSalaryConfigMgr getInstance() {
        logger.info("Getting Employee Salary Config Instance ....");
        return empSalaryConfigMgr;
    }

    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new LiteBusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("EmpSalaryConfig.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveEmpSalaryConfig(LiteWebBusinessObject salary) {
        Vector params = new Vector();

        LiteSQLCommandBean forInsert = new LiteSQLCommandBean();
        int queryResult = -1000;
        params.addElement(new LiteStringValue(UniqueIDGen.getNextID()));
        params.addElement(new LiteStringValue((String) salary.getAttribute("empID")));
        params.addElement(new LiteStringValue((String) salary.getAttribute("ExpenseItemID")));
        params.addElement(new LiteStringValue((String) salary.getAttribute("createdBy")));
        params.addElement(new LiteFloatValue(new Float(salary.getAttribute("configValue").toString()).floatValue()));
        params.addElement(new LiteStringValue((String) salary.getAttribute("salaryPersent")));
        params.addElement(new LiteStringValue((String) salary.getAttribute("salaryType")));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertEmpSalConfig").trim());
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
    
    public ArrayList<LiteWebBusinessObject> getSalaryConfigByEmp(String EmpID) throws LiteUnsupportedTypeException, LiteNoSuchColumnException, LiteUnsupportedConversionException {
        LiteWebBusinessObject wbo = new LiteWebBusinessObject();
        
        Vector params = new Vector();
        params.addElement(new LiteStringValue(EmpID));
        
        Connection connection = null;
        Vector queryResult = null;
        LiteSQLCommandBean forQuery = new LiteSQLCommandBean();
        
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getEmpSalConfig").trim());
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        ArrayList<LiteWebBusinessObject> resultBusObjs = new ArrayList<>();

        LiteRow r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (LiteRow) e.nextElement();
            wbo = new LiteWebBusinessObject();
            try {
                if (r.getString("EXPENSE_ID") != null) {
                    wbo.setAttribute("expenseID", r.getString("EXPENSE_ID"));
                } 
                
                if (r.getString("CODE") != null) {
                    wbo.setAttribute("expenseCode", r.getString("CODE"));
                } else {
                    wbo.setAttribute("expenseCode", "---");
                }
                
                if (r.getString("DESC_AR") != null) {
                    wbo.setAttribute("expenseAR", r.getString("DESC_AR"));
                } else {
                    wbo.setAttribute("expenseAR", "---");
                }
                
                if (r.getString("DESC_EN") != null) {
                    wbo.setAttribute("expenseEN", r.getString("DESC_EN"));
                } else {
                    wbo.setAttribute("expenseEN", "---");
                }
                
                if (r.getString("CONFIG_PERSENTAGE") != null) {
                    wbo.setAttribute("ConfigPersent", r.getString("CONFIG_PERSENTAGE"));
                } else {
                    wbo.setAttribute("ConfigPersent", "---");
                }
                
                if (r.getString("CONFIG_TYPE") != null) {
                    wbo.setAttribute("ConfigType", r.getString("CONFIG_TYPE"));
                } else {
                    wbo.setAttribute("ConfigType", "---");
                }
                
                try {
                    if (r.getBigDecimal("CONFIG_VALUE") != null) {
                        wbo.setAttribute("configValue", r.getBigDecimal("CONFIG_VALUE"));
                    } else {
                        wbo.setAttribute("configValue", "0");
                    }
                    
                    if (r.getTimestamp("CREATION_TIME") != null) {
                        wbo.setAttribute("creationTime", r.getTimestamp("CREATION_TIME"));
                    } else {
                        wbo.setAttribute("creationTime", "---");
                    }
                } catch (LiteUnsupportedConversionException ex) {
                    Logger.getLogger(ex.getMessage());
                }
            } catch (LiteNoSuchColumnException ex) {
                Logger.getLogger(ex.getMessage());
            }
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }
    
    public float getEmpBasicSalary(String empID) {

        LiteWebBusinessObject wbo = new LiteWebBusinessObject();
        Connection connection = null;
        Vector params = new Vector();

        params.addElement(new LiteStringValue(empID));

        LiteSQLCommandBean forQuery = new LiteSQLCommandBean();
        Vector queryResult = null;
        try {
            connection = dataSource.getConnection();

            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getEmpBsicSalary").trim());
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (LiteUnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        if(queryResult.size() > 0){
            LiteRow r = (LiteRow)queryResult.get(0);
            try {
                return r.getBigDecimal("config_value").floatValue();
            } catch (LiteNoSuchColumnException ex) {
                Logger.getLogger(ex.getMessage());
            } catch (LiteUnsupportedConversionException ex) {
                Logger.getLogger(ex.getMessage());
            }
        }
        return 0;
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
