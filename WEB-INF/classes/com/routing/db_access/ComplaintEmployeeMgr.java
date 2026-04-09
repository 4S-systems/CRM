package com.routing.db_access;

import com.clients.db_access.ClientMgr;
import com.planning.db_access.*;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import java.sql.SQLException;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.http.HttpSession;
import java.sql.*;
import org.apache.log4j.xml.DOMConfigurator;

public class ComplaintEmployeeMgr extends RDBGateWay {

    private static ComplaintEmployeeMgr complaintEmployeeMgr = new ComplaintEmployeeMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();

    public static ComplaintEmployeeMgr getInstance() {
        logger.info("Getting ComplaintEmployeeMgr Instance ....");
        return complaintEmployeeMgr;
    }

    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("complaint_employee.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public boolean saveObject(WebBusinessObject criteriaWbo, HttpSession s) throws NoUserInSessionException {
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

        Connection connection = null;
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue((String) criteriaWbo.getAttribute("complaintId")));
        params.addElement(new StringValue((String) criteriaWbo.getAttribute("employeeId")));
        params.addElement(new StringValue((String) criteriaWbo.getAttribute("notes")));
        params.addElement(new StringValue((String) waUser.getAttribute("userId")));
        params.addElement(new StringValue((String) criteriaWbo.getAttribute("responsiblity")));

        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(getQuery("insertComplaintEmployee").trim());
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

    public ArrayList getResponsibles(){
        Vector queryResult = new Vector();
        WebBusinessObject wbo = null;
        SQLCommandBean forSelect = new SQLCommandBean();
        try {
            //connection = dataSource.getConnection();
            beginTransaction();
            forSelect.setConnection(transConnection);
            forSelect.setSQLQuery(getQuery("selectAllResponsibles").trim());
            queryResult = forSelect.executeQuery();
            endTransaction();
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } catch (UnsupportedTypeException ex) {
            Logger.getLogger(ComplaintEmployeeMgr.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        ArrayList resultBusObjs = new ArrayList();
        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
        
    }
    
    public boolean updateComplaintEmployee(WebBusinessObject wbo, HttpSession s) throws NoUserInSessionException {
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
   
        Vector params = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;
        
        
        params.addElement(new StringValue((String)wbo.getAttribute("mailGroupId")));
        params.addElement(new StringValue((String)wbo.getAttribute("employeeId")));
//        params.addElement(new StringValue((String)wbo.getAttribute("groupName")));
//        params.addElement(new StringValue((String)wbo.getAttribute("groupID")));
        
        
        
        System.out.println("print params");
//        for(int i=0;i<params.size();i++)
//            System.out.println(params.elementAt(i).toString());
        
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forUpdate.setConnection(connection);
//            System.out.println(query.toString());
            forUpdate.setSQLQuery(getQuery("updateComplaintEmployee").trim());
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();
           
            cashData();
            System.out.println("table updated");
        }
        catch(SQLException se) {
            System.out.println("Exception inserting group: " + se.getMessage());
            return false;
        }
        finally {
            try {
                connection.close();
            }
            catch(SQLException ex) {
                System.out.println("Close Error");
                return false;
            }
        }
        
        return (queryResult > 0);
    }
    
    public ArrayList getCashedTableAsBusObjects() {
        cashedData = new ArrayList();
        WebBusinessObject wbo = null;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add(wbo);
        }

        return cashedData;
    }

    public ArrayList getCashedTableAsArrayList() {

        cashedData = new ArrayList();
        WebBusinessObject wbo = null;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add((String) wbo.getAttribute("id"));
        }

        return cashedData;
    }

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
        return; //   throw new UnsupportedOperationException("Not supported yet.");
    }
}
