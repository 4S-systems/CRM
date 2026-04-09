/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
//package com.financials.db_access;
package com.unit.db_access;
import com.silkworm.business_objects.BusinessForm;
import com.silkworm.business_objects.DOMFabricatorBean;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.persistence.relational.FloatValue;
import com.silkworm.persistence.relational.RDBGateWay;
import com.silkworm.persistence.relational.SQLCommandBean;
import com.silkworm.persistence.relational.StringValue;
import com.silkworm.persistence.relational.TimestampValue;
import com.silkworm.persistence.relational.UniqueIDGen;
import com.silkworm.Exceptions.*;
import java.sql.Connection;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Vector;
import org.apache.log4j.Logger;
import org.apache.log4j.xml.DOMConfigurator;



import com.clients.db_access.ClientComplaintsMgr;
import com.crm.common.CRMConstants;
import com.maintenance.common.Tools;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.common.UserMgr;
import com.silkworm.persistence.relational.StringValue;
import java.sql.SQLException;
import java.util.*;
import javax.servlet.http.HttpSession;
import java.sql.*;
import com.tracker.common.*;
import com.tracker.db_access.ProjectMgr;
import java.util.logging.Level;

import javax.servlet.http.HttpServletRequest;
import org.apache.log4j.xml.DOMConfigurator;

public class RentContractMgr extends RDBGateWay
{
    private static RentContractMgr RentContractMgr = new RentContractMgr();
    public static RentContractMgr getInstance() {
        logger.info("Getting RentContractMgr Instance ....");
        return RentContractMgr;
    }

    public RentContractMgr() {
    }
     protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("RentContract.xml")));
                logger.debug("supportedForm --> " + supportedForm);
            } catch (Exception e) {
                logger.error("Could not locate XML Document from RentContract");
            }
        }
    }
     public String saveRentContract(WebBusinessObject contractWbo, WebBusinessObject persistentUser) {
     //public String saveRentContract(WebBusinessObject contractWbo ) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(new java.util.Date());

        DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        //java.sql.Timestamp entryTime = null;
        java.sql.Timestamp startDatee = null;
        java.sql.Timestamp endDatee = null;
        //String transDate = contractWbo.getAttribute("docDate").toString();
        String startDate = contractWbo.getAttribute("startDatee").toString();
        try {
            //entryTime = new java.sql.Timestamp(df.parse(startDate).getTime());
            startDatee = new java.sql.Timestamp(df.parse(startDate).getTime());
        } catch (ParseException ex) {
            logger.error(ex);
        }
        String endDate = contractWbo.getAttribute("endDatee").toString();
        try {
            //entryTime = new java.sql.Timestamp(df.parse(startDate).getTime());
            endDatee = new java.sql.Timestamp(df.parse(endDate).getTime());
        } catch (ParseException ex) {
            logger.error(ex);
        }

        Vector rentContractParameters = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        
        String contractID = UniqueIDGen.getNextID();
        Connection connection = null;
        
        try {
            
            rentContractParameters.addElement(new StringValue(contractID));
            rentContractParameters.addElement(new StringValue(contractWbo.getAttribute("projectID").toString()));
            rentContractParameters.addElement(new StringValue(contractWbo.getAttribute("clientID").toString()));
            //status_id
            //rentContractParameters.addElement(new TimestampValue(entryTime));        
            rentContractParameters.addElement(new StringValue(contractWbo.getAttribute("contractPeriod").toString()));
            //rentContractParameters.addElement(new StringValue(contractWbo.getAttribute("startDatee").toString()));
            rentContractParameters.addElement(new TimestampValue(startDatee));        
            //rentContractParameters.addElement(new StringValue(contractWbo.getAttribute("endDatee").toString()));
            rentContractParameters.addElement(new TimestampValue(endDatee));
            rentContractParameters.addElement(new FloatValue(new Float(contractWbo.getAttribute("monthlyRent").toString())));
            rentContractParameters.addElement(new StringValue(contractWbo.getAttribute("sponcer").toString()));
            rentContractParameters.addElement(new FloatValue(new Float(contractWbo.getAttribute("paymentKind").toString())));
            rentContractParameters.addElement(new StringValue((String) persistentUser.getAttribute("userId")));        
            
          
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            forInsert.setConnection(connection);
            
            // saving contract data
            forInsert.setSQLQuery("insert into CONTRACT values (?,?,?,'UL',NULL,?,?,?,?,?,?,'UL','UL',0,0,NULL,'UL',?,SYSDATE)");
            forInsert.setparams(rentContractParameters);
            queryResult = forInsert.executeUpdate();
            if (queryResult < 0) {
                connection.rollback();
                return null;
            }
            
        } catch (SQLException ex) {
            logger.error(ex.getMessage());
            try {
                connection.rollback();
            } catch (SQLException ex1) {
                Logger.getLogger("Saving Rent Contract Exception = "+ex1);
            }
            return null;
        } finally {
            try {
                connection.commit();
                connection.close();
            } catch (SQLException ex) {
                Logger.getLogger("Saving Rent Contract Exception = "+ex);
            }
        }
        if (queryResult > 0) {
            return "ok";
        } else {
            return null;
        }
    }
     
     //public Vector getAllRentedUnits(String departmentID, java.sql.Date fromDate, java.sql.Date toDate) throws NoUserInSessionException {
     public Vector getAllRentedUnits() throws NoUserInSessionException {
        Vector queryResult = new Vector();
        Vector params = new Vector();
//        params.addElement(new StringValue(departmentID));
//        params.addElement(new DateValue(fromDate));
//        params.addElement(new DateValue(toDate));
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;

        try {
            String query = ("SELECT PROJECT_ID,CLIENT_ID,START_DATE,END_DATE,MONTHLY_RENT,SPONCER FROM CONTRACT");//getQuery("getAllPricedUnits").trim();
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                java.util.logging.Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        Vector resultBusObjs = new Vector();
        Row r = null;
        WebBusinessObject wbo;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = fabricateBusObj(r);
            try {
                if (r.getString("PROJECT_ID") != null) {
                    wbo.setAttribute("projectID", r.getString("PROJECT_ID"));
                }
                if (r.getString("CLIENT_ID") != null) {
                    wbo.setAttribute("clientId", r.getString("CLIENT_ID"));
                }
                if (r.getString("START_DATE") != null) {
                //    wbo.setAttribute("startDate", r.getDate("START_DATE"));
                    wbo.setAttribute("startDate", r.getString("START_DATE"));
                }
                if (r.getString("END_DATE") != null) {
                //    wbo.setAttribute("endDate", r.getDate("END_DATE"));
                    wbo.setAttribute("endDate", r.getString("END_DATE"));
                }
                if (r.getString("MONTHLY_RENT") != null) {
                    wbo.setAttribute("monthlyRent", r.getDouble("MONTHLY_RENT"));
                }
                if (r.getString("SPONCER") != null) {
                    wbo.setAttribute("sponcer", r.getString("SPONCER"));
                }

            } catch (Exception ex) {
                java.util.logging.Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }
    
    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
        return;
    }

    @Override
    public ArrayList getCashedTableAsArrayList() {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }
    
}
