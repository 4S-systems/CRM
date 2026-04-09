package com.silkworm.functional_security.db_access;

import com.clients.db_access.ClientComplaintsMgr;
import com.maintenance.common.UserPrev;
import com.maintenance.db_access.AllMaintenanceInfoMgr;
import com.maintenance.db_access.GroupPrevMgr;
import com.maintenance.db_access.TradeMgr;
import com.maintenance.db_access.UserStoresMgr;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import com.silkworm.db_access.GrantsMgr;
import java.sql.SQLException;
import com.silkworm.util.DictionaryItem;
import com.tracker.db_access.ProjectMgr;
import com.tracker.db_access.TotalTicketsMgr;
import com.tracker.servlets.TrackerLoginServlet;
import java.util.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.*;
import java.sql.Connection;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.http.HttpServletResponse;

public class BusinessOpSecurityMgr extends RDBGateWay {

    private static BusinessOpSecurityMgr businessOpSecurityMgr = new BusinessOpSecurityMgr();
    private String[] sys_paths = null;
    private String imageDirPath = null;
    SqlMgr sqlMgr = SqlMgr.getInstance();
    String generatedUserId = null;
    String sessionUserId = null;
    TotalTicketsMgr totalTicketsMgr = TotalTicketsMgr.getInstance();

    @Override
    protected void initSupportedForm() {
        if (supportedForm == null) {
            try {
                System.out.println("UserMgr ..***********.trying to get the XML file from path:: " + webInfPath);
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("business_op_security.xml")));
            } catch (Exception e) {
                System.out.println("Could not locate XML Document");
            }
        }
    }

    @Override
    protected void initQueryElemnts() throws EmptyRequestException {
        String[] fishingFor = {"userName", "password"};

        if (null == theRequest) {
            throw new EmptyRequestException("request has not been initialized");
        } else {
            DictionaryItem existingParam = null;
            queryElements = new ArrayList(1);

            for (int i = 0; i < fishingFor.length; i++) {
                existingParam = getRequestParamAsDictionaryItem(fishingFor[i]);
                if (null != existingParam) {
                    queryElements.add(existingParam);
                } else {
                    System.out.println("the following string bound elemrnt is null " + fishingFor[i]);
                }
            }
        }
    }

    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    @Override
    public Vector getSearchQueryResult(HttpServletRequest request) throws SQLException, Exception {
        String userName = request.getParameter("userName");
        String password = request.getParameter("password");


        if (userName.equals("") || password.equals("")) {
            return null;
        } else {
            return super.getSearchQueryResult(request);
        }
    }

    public static BusinessOpSecurityMgr getInstance() {
        System.out.println("Getting BusinessOpSecurityMgr Instance ....");
        return businessOpSecurityMgr;
    }

    public void setSysPaths(String[] sys_paths) {
        this.sys_paths = sys_paths;
        imageDirPath = sys_paths[1];

    }

    public Vector getOpSecurityList() {

        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getOpSecurityList").trim());
            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());

        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());

        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        Vector resultBusObjs = new Vector();

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

    public Vector getUsers(String username) throws SQLException {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        String query = null;
        Vector queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();

        query = sqlMgr.getSql("getUsers").trim();
        query = query.replaceAll("username", username);

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            queryResult = forQuery.executeQuery();

        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {

            connection.close();

        }

        Vector reultBusObjs = new Vector();
        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {

            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            reultBusObjs.add(wbo);
        }


        return reultBusObjs;


    }
    
    
       public Vector getOpSecurityById(String bussId) {

        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector queryResult = null;
        Vector params = new Vector();
                
        
        SQLCommandBean forQuery = new SQLCommandBean();
                 params.addElement(new StringValue(bussId));


        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
           forQuery.setparams(params);
            forQuery.setSQLQuery(sqlMgr.getSql("getOpSecurityById").trim());
            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());

        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());

        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        Vector resultBusObjs = new Vector();

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


    @Override
    protected void initSupportedQueries() {
         return;//throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public ArrayList getCashedTableAsArrayList() {
        throw new UnsupportedOperationException("Not supported yet.");
    }
}
