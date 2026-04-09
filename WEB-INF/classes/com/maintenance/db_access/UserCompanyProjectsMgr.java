package com.maintenance.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.common.SecurityUser;
//import com.silkworm.logger.db_access.ObjectTypeMgr;
import com.silkworm.persistence.relational.StringValue;
import java.util.*;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.http.HttpSession;
import org.apache.log4j.xml.DOMConfigurator;

public class UserCompanyProjectsMgr extends RDBGateWay {

    private static final UserCompanyProjectsMgr USER_COMPANY_PROJECTS_MGR = new UserCompanyProjectsMgr();
    SecurityUser securityUser = new SecurityUser();

    public UserCompanyProjectsMgr() {
    }

    public static UserCompanyProjectsMgr getInstance() {
        logger.info("Getting UserCompanyProjectsMgr Instance ....");
        return USER_COMPANY_PROJECTS_MGR;
    }

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("user_company_projects.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public boolean saveUserProjects(String userID, Vector userProjects, String projectIdDefault, HttpSession session) {

        int queryResult = -1000;
        Vector parameters;
        SQLCommandBean forInsert = new SQLCommandBean();

        securityUser = (SecurityUser) session.getAttribute("securityUser");
        WebBusinessObject userProjectWBO;
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            forInsert.setConnection(connection);
            String sql = getQuery("insertUserCompanyProject").trim();
            forInsert.setSQLQuery(sql);

            for (int i = 0; i < userProjects.size(); i++) {

                userProjectWBO = (WebBusinessObject) userProjects.get(i);

                parameters = new Vector();

                parameters.addElement(new StringValue(UniqueIDGen.getNextID()));
                parameters.addElement(new StringValue(userID));
                parameters.addElement(new StringValue((String) userProjectWBO.getAttribute("projectId")));
                parameters.addElement(new StringValue((String) userProjectWBO.getAttribute("projectName")));
                parameters.addElement(new StringValue((String) userProjectWBO.getAttribute("isDefault")));
                parameters.addElement(new StringValue(securityUser.getUserId()));
                parameters.addElement(new StringValue((String) userProjectWBO.getAttribute("relatedFrom")));
                parameters.addElement(new StringValue((String) userProjectWBO.getAttribute("relatedTo")));
                parameters.addElement(new StringValue((String) userProjectWBO.getAttribute("trade")));//option1 in table
                forInsert.setparams(parameters);

                queryResult = forInsert.executeUpdate();

                if (queryResult <= 0) {
                    connection.rollback();
                    return false;
                }

                try {
                    Thread.sleep(100);
                } catch (InterruptedException ex) {
                    logger.error(ex.getMessage());
                }
            }

            // update Project UserGroup
//                forInsert.setSQLQuery(sqlMgr.getSql("updateProjectUserGroup").trim());
//                params = new Vector();
//                params.addElement(new StringValue(projectIdDefault));
//                params.addElement(new StringValue(userID));
//                forInsert.setparams(params);
//                queryResult = forInsert.executeUpdate();
            if (queryResult <= 0) {
                connection.rollback();
                return false;
            }
        } catch (SQLException se) {
            try {
                connection.rollback();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
//                logger.error(se.getMessage());
//                return false;
        } finally {
            try {
                connection.commit();
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
                return false;
            }
        }

        return (queryResult > 0);
    }

    public String[] getProjectsIdForUser(String userId) {
        Vector<WebBusinessObject> userProjects = new Vector<WebBusinessObject>();

        try {
            userProjects = USER_COMPANY_PROJECTS_MGR.getOnArbitraryKey(userId, "key1");
        } catch (Exception ex) {
            logger.error(ex.getMessage());
        }

        String[] resualt = new String[userProjects.size()];

        int index = 0;
        for (WebBusinessObject wbo : userProjects) {
            resualt[index] = (String) wbo.getAttribute("projectID");
            index++;
        }

        return resualt;
    }

    public String[] getAllUserProjectIds() {
        Connection connection = null;
        SQLCommandBean forSelect = new SQLCommandBean();
        Vector result = new Vector();
        try {
            connection = dataSource.getConnection();
            forSelect.setConnection(connection);
            forSelect.setSQLQuery(getQuery("getAllUserProjectIds").trim());
            result = forSelect.executeQuery();
        } catch (SQLException ex) {
            Logger.getLogger(UserCompanyProjectsMgr.class.getName()).log(Level.SEVERE, null, ex);

        } catch (UnsupportedTypeException ex) {
            Logger.getLogger(UserCompanyProjectsMgr.class.getName()).log(Level.SEVERE, null, ex);

        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                Logger.getLogger(UserCompanyProjectsMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

        /* convert site vector to array */
        String[] siteArr = new String[result.size()];
        try {
            int index = 0;
            for (Object row : result) {
                siteArr[index] = ((Row) row).getString("project_id");
                index++;
            }
        } catch (Exception e) { /* raise an exception */ }
        /* -convert site vector to array */

        return siteArr;
    }

    public List<String> getUserIdsByTrade(String tradeId) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> result;
        Vector parameters = new Vector();

        parameters.addElement(new StringValue(tradeId));

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setparams(parameters);
            command.setSQLQuery(getQuery("getUserIdsByTrade").trim());
            result = command.executeQuery();

            List<String> ids = new ArrayList<String>();
            for (Row row : result) {
                try {
                    ids.add(row.getString("USER_ID"));
                } catch (NoSuchColumnException ex) {
                    logger.error(ex);
                }
            }
            return ids;
        } catch (SQLException ex) {
            logger.error(ex);
        } catch (UnsupportedTypeException ex) {
            logger.error(ex);
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex);
            }
        }

        return new ArrayList<String>();
    }

    public ArrayList getAllProjectsByUserAsArrayList(String userId) {
        ArrayList allAsArrayList = new ArrayList();

        Vector allAsVector = getAllProjectsByUserId(userId);

        for (int i = 0; i < allAsVector.size(); i++) {
            allAsArrayList.add((WebBusinessObject) allAsVector.get(i));
        }

        return allAsArrayList;
    }

    public Vector getAllProjectsByUserId(String userId) {

        WebBusinessObject wbo;
        Connection connection = null;
       

        Vector param = new Vector();
        param.add(new StringValue(userId));
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
             StringBuilder query = new StringBuilder(getQuery("getAllCompanyProjectsByUserId").trim());
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(param);
            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
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
    public ArrayList getCashedTableAsBusObjects() {
        cashedData = new ArrayList();
        WebBusinessObject wbo;
        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add(wbo);
        }
        return cashedData;
    }

    @Override
    public ArrayList getCashedTableAsArrayList() {
        cashedData = new ArrayList();
        return cashedData;
    }

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
    }

    public WebBusinessObject getUserDefaultProject(String userId) {
        try {
            Vector<WebBusinessObject> userProjectsList = getOnArbitraryDoubleKeyOracle(userId, "key1", "1", "key3");
            if (userProjectsList.size() > 0) {
                return userProjectsList.get(0);
            }
        } catch (Exception ex) {
            Logger.getLogger(UserCompanyProjectsMgr.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }
    
    public ArrayList<WebBusinessObject> getAllEngineersInProject(String projectId) {

        WebBusinessObject wbo;
        Connection connection = null;
        StringBuilder query = new StringBuilder(getQuery("getAllEngineersInProject").trim());

        Vector param = new Vector();
        param.add(new StringValue(projectId));
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(param);
            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if(connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        ArrayList<WebBusinessObject> resultBusObjs = new ArrayList<WebBusinessObject>();
        if (queryResult != null) {
            Row r;
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = fabricateBusObj(r);
                try {
                    if(r.getString("full_name") != null) {
                        wbo.setAttribute("engineerName", r.getString("full_name"));
                    }
                    if(r.getString("name") != null) {
                        wbo.setAttribute("roleName", r.getString("name"));
                    }
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(UserCompanyProjectsMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                resultBusObjs.add(wbo);
            }
        }
        return resultBusObjs;
    }
    
    public ArrayList<String> getUserFinanceProjects(String userId) {

        WebBusinessObject wbo;
        Connection connection = null;
        StringBuilder query = new StringBuilder(getQuery("getUserFinanceProjects").trim());

        Vector param = new Vector();
        param.add(new StringValue(userId));
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(param);
            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if(connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        ArrayList<String> resultBusObjs = new ArrayList<String>();
        if (queryResult != null) {
            Row r;
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = fabricateBusObj(r);
                
                resultBusObjs.add(wbo.getAttribute("PROJECT_ID").toString());
            }
        }
        return resultBusObjs;
    }
    
    public WebBusinessObject getEmpInProject(String projectId, String tradeId) {
        WebBusinessObject wbo;
        Connection connection = null;
        StringBuilder query = new StringBuilder(getQuery("getUserIdByTradeAndProject").trim());

        Vector param = new Vector();
        param.add(new StringValue(tradeId));
        param.add(new StringValue(projectId));
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(param);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if(connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        WebBusinessObject resultBusObjs = null;
        if (queryResult != null) {
            Row r;
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                resultBusObjs = fabricateBusObj(r);
                return resultBusObjs;
            }
        }
        
        return resultBusObjs;
    }
    //Kareem
    //public ArrayList<WebBusinessObject> getAllUsersWithProjects(String type,String projectId,String tradeId) {
    public ArrayList<WebBusinessObject> getAllUsersWithProjects(String type,String projectId,String tradeId, String intervalId) {

        WebBusinessObject wbo;
        Connection connection = null;
        StringBuilder query = new StringBuilder(getQuery("getAllUsersWithProjects").trim());

        Vector param = new Vector();
        param.add(new StringValue(projectId));
        param.add(new StringValue(tradeId));
        param.add(new StringValue(type));
        if (!intervalId.equals("")){
            query.append(" and (interval_id ='"+intervalId+"')");
        }
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(param);
            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if(connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        ArrayList<WebBusinessObject> resultBusObjs = new ArrayList<WebBusinessObject>();
        if (queryResult != null) {
            Row r;
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = fabricateBusObj(r);
                try {
                    if(r.getString("project_name") != null) {
                        wbo.setAttribute("projectName", r.getString("project_name"));
                    }
                    if(r.getString("full_name") != null) {
                        wbo.setAttribute("engineerName", r.getString("full_name"));
                    }
                    if(r.getString("name") != null) {
                        wbo.setAttribute("roleName", r.getString("name"));
                    }
                    if(r.getString("interval_id") != null) {
                        wbo.setAttribute("interval", r.getString("interval_id"));
                    }
                    if(r.getBigDecimal("target_val") !=null){
                        wbo.setAttribute("targetValue", r.getBigDecimal("Target_Val").doubleValue());
                    }else {
                        wbo.setAttribute("targetValue", "0.0d");
                    }
                    if(r.getString("user_company_project_id") !=null){
                    wbo.setAttribute("hasRow", "1");
                    }else{
                        wbo.setAttribute("hasRow", "0");
                    }
                    if(r.getString("id") != null) {
                        wbo.setAttribute("id", r.getString("id"));
                    }
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(UserCompanyProjectsMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                catch (UnsupportedConversionException ex)
                {
                    Logger.getLogger(UserCompanyProjectsMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                resultBusObjs.add(wbo);
            }
        }
        return resultBusObjs;
    }//Kareem End
    //Kareem 
    public boolean saveSalesTarget(WebBusinessObject salesTargetWbo, WebBusinessObject loggedUser) {
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult;
        params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue((String) salesTargetWbo.getAttribute("ID")));
        params.addElement(new StringValue((String) salesTargetWbo.getAttribute("Interval_Id")));
        String userCompanyID , interval_id;
        userCompanyID =(String) salesTargetWbo.getAttribute("ID");
        interval_id=(String) salesTargetWbo.getAttribute("Interval_Id");
        deleteSalesTarget(userCompanyID,interval_id);
        params.addElement(new StringValue((String) salesTargetWbo.getAttribute("targetValue")));
        params.addElement(new StringValue((String) loggedUser.getAttribute("userId")));
       // params.addElement(new StringValue((String) salesTargetWbo.getAttribute("option1")));
        //params.addElement(new StringValue(salesTargetWbo.getAttribute("option2") != null ? (String) unitPriceWbo.getAttribute("option2") : "UL"));
        //params.addElement(new StringValue(salesTargetWbo.getAttribute("option3") != null ? (String) unitPriceWbo.getAttribute("option3") : "UL"));
        try {
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(getQuery("insertSalesTarget").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            endTransaction();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        }
        return (queryResult > 0);
    }
    
    public boolean deleteSalesTarget(String CompanyTargetId, String intervalId){
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        params.addElement(new StringValue((String)CompanyTargetId));
        params.addElement(new StringValue((String)intervalId));
    try {
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(getQuery("deleteSalesTarget").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            endTransaction();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } catch (Exception e){
            System.out.println(e.getMessage());
        }
        return (queryResult > 0);
    
    }//Kareem End
        public ArrayList<WebBusinessObject> getAllIntervals(){//(String userId) {

        WebBusinessObject wbo;
        Connection connection = null;
        StringBuilder query = new StringBuilder(getQuery("getAllIntervals").trim());

        //Vector param = new Vector();
        //param.add(new StringValue(userId));
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
          //  forQuery.setparams(param);
            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if(connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        ArrayList<WebBusinessObject> resultBusObjs = new ArrayList<WebBusinessObject>();
        if (queryResult != null) {
            Row r;
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = fabricateBusObj(r);
                
                //resultBusObjs.add(wbo.getAttribute("PROJECT_ID").toString());
                resultBusObjs.add(wbo);
            }
        }
        return resultBusObjs;
    }
}
