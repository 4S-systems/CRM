/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.clients.db_access;

import com.silkworm.business_objects.BusinessForm;
import com.silkworm.business_objects.DOMFabricatorBean;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.persistence.relational.DateValue;
import com.silkworm.persistence.relational.NoSuchColumnException;
import com.silkworm.persistence.relational.RDBGateWay;
import com.silkworm.persistence.relational.Row;
import com.silkworm.persistence.relational.SQLCommandBean;
import com.silkworm.persistence.relational.StringValue;
import com.silkworm.persistence.relational.UniqueIDGen;
import com.silkworm.persistence.relational.UnsupportedTypeException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.log4j.xml.DOMConfigurator;

/**
 *
 * @author Administrator
 */
public class CustomerGradesMgr extends RDBGateWay {

    private static CustomerGradesMgr customerGradesMgr = new CustomerGradesMgr();

    public CustomerGradesMgr() {
    }

    public static CustomerGradesMgr getInstance() {
        logger.info("Getting CustomerGradesMgr Instance ....");
        return customerGradesMgr;
    }

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("customer_grades.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        Vector params = new Vector();
        String Type = (String) wbo.getAttribute("type");
        params.addElement(new StringValue((String) wbo.getAttribute("Emp")));
        params.addElement(new StringValue((String) wbo.getAttribute("EqpID")));
        params.addElement(new StringValue(Type));
        params.addElement(new DateValue((Date) wbo.getAttribute("beginDate")));
        int queryResult = -1;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            beginTransaction();
            forQuery.setConnection(transConnection);
            forQuery.setSQLQuery(getQuery("insertData").trim());
            forQuery.setparams(params);
            queryResult = forQuery.executeUpdate();
            endTransaction();

        } catch (SQLException se) {
            System.out.println("Error In executing Query.............!" + se.getMessage());
        }
        return (queryResult > 0);
    }

    public String getAllEqp(String type) {
        String allEquip = "";
        Vector params = new Vector();
        params.addElement(new StringValue(type));
        Vector queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            beginTransaction();
            forQuery.setConnection(transConnection);
            forQuery.setSQLQuery(getQuery("getAllEqp").trim());
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
            endTransaction();

        } catch (UnsupportedTypeException ex) {
            Logger.getLogger(CustomerGradesMgr.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(CustomerGradesMgr.class.getName()).log(Level.SEVERE, null, ex);
        }
        for (int i = 0; i < queryResult.size(); i++) {
            try {
                if (i == queryResult.size() - 1) {
                    allEquip += "'" + ((Row) queryResult.get(i)).getString("equep_id").toString() + "'";
                } else {
                    allEquip += "'" + ((Row) queryResult.get(i)).getString("equep_id").toString() + "'" + ",";
                }
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(CustomerGradesMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return allEquip;

    }

    public Vector getAllDrivers(WebBusinessObject wbo) {
        Vector queryResult = new Vector();
        Vector params = new Vector();
        params.addElement(new StringValue((String) wbo.getAttribute("type")));
        params.addElement(new DateValue((Date) wbo.getAttribute("fromDate")));
        params.addElement(new DateValue((Date) wbo.getAttribute("toDate")));


        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            beginTransaction();
            forQuery.setConnection(transConnection);
            forQuery.setSQLQuery(getQuery("getAllDrivers").trim());
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
            endTransaction();

        } catch (UnsupportedTypeException ex) {
            Logger.getLogger(CustomerGradesMgr.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(CustomerGradesMgr.class.getName()).log(Level.SEVERE, null, ex);
        }

        return queryResult;

    }

    public Vector getDriverAndSupervisorName(String Id) {
        Vector queryResult = new Vector();
        Vector params = new Vector();
        params.addElement(new StringValue(Id));


        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            beginTransaction();
            forQuery.setConnection(transConnection);
            forQuery.setSQLQuery(getQuery("getDriverAndSupervisorName").trim());
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
            endTransaction();

        } catch (UnsupportedTypeException ex) {
            Logger.getLogger(CustomerGradesMgr.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(CustomerGradesMgr.class.getName()).log(Level.SEVERE, null, ex);
        }

        return queryResult;

    }

//     public String getAttachedEmployees() {
//        Vector<Row> queryResult = new Vector<Row>();
//        Vector params = new Vector();
//        SQLCommandBean forQuery = new SQLCommandBean();
//        String attachedEmployeesStr="";
//
//        try {
//           beginTransaction();
//            forQuery.setConnection(transConnection);
//            forQuery.setSQLQuery(getQuery("getAttachedEmployees").trim());
//            forQuery.setparams(params);
//            queryResult = forQuery.executeQuery();
//            endTransaction();
//
//        } catch(SQLException se) {
//            System.out.println("Error In executing Query.............!" + se.getMessage());
//        } catch (UnsupportedTypeException ex) {
//            Logger.getLogger(AttachedEqpsMgr.class.getName()).log(Level.SEVERE, null, ex);
//        }
//       for(int i=0;i<queryResult.size();i++){
//            try {
//            if(i == queryResult.size()-1){
//                attachedEmployeesStr +="'" +((Row) queryResult.get(i)).getString("empid").toString()+"'";
//            }else{
//                attachedEmployeesStr +="'" +((Row) queryResult.get(i)).getString("empid").toString()+"'"+ ",";
//                }
//            } catch (NoSuchColumnException ex) {
//                Logger.getLogger(EmpEqpMgr.class.getName()).log(Level.SEVERE, null, ex);
//            }
//
//        }
//        return attachedEmployeesStr;
    // }
    public ArrayList getGrades() {
        Connection connection = null;

        String query = "SELECT * FROM grades".trim();
        ArrayList resVec = new ArrayList();
        //Vector params = new Vector();
        //params.addElement(new StringValue(unitId));
        Vector queryResult = null;
        Row row = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            //forQuery.setparams(params);
            forQuery.setSQLQuery(query);
            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return null;
            }
        }

        for (int i = 0; i < queryResult.size(); i++) {
            row = (Row) queryResult.get(i);
            try {
                WebBusinessObject tempWbo = new WebBusinessObject();
                tempWbo.setAttribute("id", row.getString("id"));
                tempWbo.setAttribute("ar_desc", row.getString("ar_desc"));
                tempWbo.setAttribute("en_desc", row.getString("en_desc"));
                resVec.add(tempWbo);
            } catch (NoSuchColumnException ex) {
                logger.error(ex.getMessage());
            }
        }

        return resVec;
    }

    public boolean upsertEqpEmp(WebBusinessObject eqpEmpWbo) {
        Connection connection = null;
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue((String) eqpEmpWbo.getAttribute("carId")));
        params.addElement(new StringValue((String) eqpEmpWbo.getAttribute("empType")));
        params.addElement(new StringValue((String) eqpEmpWbo.getAttribute("empId")));
        params.addElement(new DateValue((java.sql.Date) eqpEmpWbo.getAttribute("fromDate")));
        params.addElement(new StringValue((String) eqpEmpWbo.getAttribute("empId")));
        params.addElement(new StringValue((String) eqpEmpWbo.getAttribute("carId")));
        params.addElement(new StringValue((String) eqpEmpWbo.getAttribute("empType")));
        params.addElement(new DateValue((java.sql.Date) eqpEmpWbo.getAttribute("fromDate")));

        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(getQuery("upsertEqpEmp").trim());
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

    public boolean updateEqpEmp(WebBusinessObject eqpEmpWbo) {
        Vector params = new Vector();
        Connection connection = null;
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = 0;
        Vector eqpEmpVec = null;

        try {
            eqpEmpVec = customerGradesMgr.getOnArbitraryKey(
                    (String) eqpEmpWbo.getAttribute("clientId"),
                    "key1");

        } catch (SQLException ex) {
            Logger.getLogger(CustomerGradesMgr.class.getName()).log(Level.SEVERE, null, ex);

        } catch (Exception ex) {
            Logger.getLogger(CustomerGradesMgr.class.getName()).log(Level.SEVERE, null, ex);

        }

        if (eqpEmpVec.isEmpty()) {

            beginTransaction();
            forInsert.setConnection(transConnection);

            try {

                params.addElement(new DateValue((java.sql.Date) eqpEmpWbo.getAttribute("fromDate")));
                params.addElement(new StringValue((String) eqpEmpWbo.getAttribute("clientId")));
                params.addElement(new StringValue((String) eqpEmpWbo.getAttribute("degreeId")));


                forInsert.setSQLQuery("UPDATE customer_grades t SET end_date = ? WHERE t.customer_id = ? AND t.grade_id = ? AND t.end_date IS NULL".trim());
                forInsert.setparams(params);
                queryResult = forInsert.executeUpdate();

                queryResult = 0;
                params.removeAllElements();
                params.addElement(new StringValue(UniqueIDGen.getNextID()));
                params.addElement(new StringValue((String) eqpEmpWbo.getAttribute("clientId")));
                params.addElement(new StringValue((String) eqpEmpWbo.getAttribute("degreeId")));
                params.addElement(new DateValue((java.sql.Date) eqpEmpWbo.getAttribute("fromDate")));

                forInsert.setSQLQuery("insert into customer_grades values (?,?,?,?,null,null)".trim());
                forInsert.setparams(params);
                queryResult = forInsert.executeUpdate();

            } catch (SQLException se) {
                try {
                    transConnection.rollback();
                } catch (SQLException ex) {
                    Logger.getLogger(CustomerGradesMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                return false;

            } finally {
                endTransaction();

            }

        } else {
            beginTransaction();
            forInsert.setConnection(transConnection);
            params.addElement(new DateValue((java.sql.Date) eqpEmpWbo.getAttribute("fromDate")));
            params.addElement(new StringValue((String) eqpEmpWbo.getAttribute("degreeId")));
            params.addElement(new StringValue((String) eqpEmpWbo.getAttribute("clientId")));

            forInsert.setSQLQuery("UPDATE customer_grades  SET end_date = ?, grade_id = ? WHERE customer_id = ? AND end_date IS NULL".trim());
            forInsert.setparams(params);
            try {
                queryResult = forInsert.executeUpdate();
                if (queryResult > 0) {
                } else {
                    queryResult = 0;
                    params.removeAllElements();
                    params.addElement(new StringValue(UniqueIDGen.getNextID()));
                    params.addElement(new StringValue((String) eqpEmpWbo.getAttribute("clientId")));
                    params.addElement(new StringValue((String) eqpEmpWbo.getAttribute("degreeId")));
                    params.addElement(new DateValue((java.sql.Date) eqpEmpWbo.getAttribute("fromDate")));

                    forInsert.setSQLQuery("insert into customer_grades values (?,?,?,?,null,null)".trim());
                    forInsert.setparams(params);
                    queryResult = forInsert.executeUpdate();
                }

                // update start date only

//            try {
//                
//                params.addElement(new DateValue((java.sql.Date) eqpEmpWbo.getAttribute("fromDate")));
//                params.addElement(new StringValue((String) eqpEmpWbo.getAttribute("degreeId")));
//                params.addElement(new StringValue((String) eqpEmpWbo.getAttribute("clientId")));
//                
//                
//                connection = dataSource.getConnection();
//                forInsert.setConnection(connection);
//                forInsert.setSQLQuery("UPDATE customer_grades t SET start_date = ? WHERE t.grade_id = ? AND t.customer_id = ?".trim());
//                forInsert.setparams(params);
//                queryResult = forInsert.executeUpdate();
//
//            } catch (SQLException se) {
//                logger.error(se.getMessage());
//                return false;
//            
//            } finally {
//                try {
//                    connection.close();
//                
//                } catch (SQLException ex) {
//                    logger.error("Close Error");
//                    return false;
//                
//                }
//            } 
            } catch (SQLException ex) {
                Logger.getLogger(CustomerGradesMgr.class.getName()).log(Level.SEVERE, null, ex);
            } finally {
                endTransaction();
            }
        }
        return (queryResult > 0);
    }

    public boolean updateCustomerGrade(WebBusinessObject eqpEmpWbo) {
        Vector params = new Vector();
        Connection connection = null;
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = 0;
        Vector eqpEmpVec = null;

        try {
            eqpEmpVec = customerGradesMgr.getOnArbitraryKey(
                    (String) eqpEmpWbo.getAttribute("clientId"),
                    "key1");

        } catch (SQLException ex) {
            Logger.getLogger(CustomerGradesMgr.class.getName()).log(Level.SEVERE, null, ex);

        } catch (Exception ex) {
            Logger.getLogger(CustomerGradesMgr.class.getName()).log(Level.SEVERE, null, ex);

        }

        if (eqpEmpVec.isEmpty()) {

            beginTransaction();
            forInsert.setConnection(transConnection);

            try {


                params.addElement(new StringValue((String) eqpEmpWbo.getAttribute("clientId")));
                params.addElement(new StringValue((String) eqpEmpWbo.getAttribute("degreeId")));


                forInsert.setSQLQuery("UPDATE customer_grades t SET end_date = sysdate WHERE t.customer_id = ? AND t.grade_id = ? AND t.end_date IS NULL".trim());
                forInsert.setparams(params);
                queryResult = forInsert.executeUpdate();

                queryResult = 0;
                params.removeAllElements();
                params.addElement(new StringValue(UniqueIDGen.getNextID()));
                params.addElement(new StringValue((String) eqpEmpWbo.getAttribute("clientId")));
                params.addElement(new StringValue((String) eqpEmpWbo.getAttribute("degreeId")));
              

                forInsert.setSQLQuery("insert into customer_grades values (?,?,?,sysdate,null,null)".trim());
                forInsert.setparams(params);
                queryResult = forInsert.executeUpdate();

            } catch (SQLException se) {
                try {
                    transConnection.rollback();
                } catch (SQLException ex) {
                    Logger.getLogger(CustomerGradesMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                return false;

            } finally {
                endTransaction();

            }

        } else {
            beginTransaction();
            forInsert.setConnection(transConnection);
        
            params.addElement(new StringValue((String) eqpEmpWbo.getAttribute("degreeId")));
            params.addElement(new StringValue((String) eqpEmpWbo.getAttribute("clientId")));

            forInsert.setSQLQuery("UPDATE customer_grades  SET end_date = sysdate, grade_id = ? WHERE customer_id = ? AND end_date IS NULL".trim());
            forInsert.setparams(params);
            try {
                queryResult = forInsert.executeUpdate();
                if (queryResult > 0) {
                } else {
                    queryResult = 0;
                    params.removeAllElements();
                    params.addElement(new StringValue(UniqueIDGen.getNextID()));
                    params.addElement(new StringValue((String) eqpEmpWbo.getAttribute("clientId")));
                    params.addElement(new StringValue((String) eqpEmpWbo.getAttribute("degreeId")));
                   

                    forInsert.setSQLQuery("insert into customer_grades values (?,?,?,sysdate,null,null)".trim());
                    forInsert.setparams(params);
                    queryResult = forInsert.executeUpdate();
                }

            } catch (SQLException ex) {
                Logger.getLogger(CustomerGradesMgr.class.getName()).log(Level.SEVERE, null, ex);
            } finally {
                endTransaction();
            }
        }
        return (queryResult > 0);
    }

    public String getEmployeeNameByType(String carId, String type) {
        Connection connection = null;

        String query = getQuery("getEmployeeNameByType").trim();
        String employeeName = "";
        Vector params = new Vector();
        Vector queryResult = null;
        Row row = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);

            params.addElement(new StringValue(carId));
            params.addElement(new StringValue(type));
            forQuery.setparams(params);

            forQuery.setSQLQuery(query);
            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;

        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;

        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return null;
            }
        }

        if (queryResult.size() > 0) {
            row = (Row) queryResult.get(0);

            try {
                employeeName = row.getString("employeeName");

            } catch (NoSuchColumnException ex) {
                Logger.getLogger(CustomerGradesMgr.class.getName()).log(Level.SEVERE, null, ex);

            }
        }

        return employeeName;
    }

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
        return;
    }

    @Override
    public ArrayList getCashedTableAsArrayList() {
        ArrayList al = null;
        return al;
    }
}
