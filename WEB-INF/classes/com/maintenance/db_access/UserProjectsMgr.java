package com.maintenance.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.common.SecurityUser;
import com.silkworm.persistence.relational.StringValue;
import java.util.*;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.http.HttpSession;
import org.apache.log4j.xml.DOMConfigurator;

public class UserProjectsMgr extends RDBGateWay {

    private final static UserProjectsMgr USER_PROJECTS_MGR = new UserProjectsMgr();
    private final SqlMgr sqlMgr = SqlMgr.getInstance();
    SecurityUser securityUser = new SecurityUser();
    public UserProjectsMgr() {
    }

    public static UserProjectsMgr getInstance() {
        logger.info("Getting UserProjectsMgr Instance ....");
        return USER_PROJECTS_MGR;
    }

    @Override
    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("user_projects.xml")));
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
            Vector params = new Vector();
            SQLCommandBean forInsert = new SQLCommandBean();
            
            securityUser = (SecurityUser) session.getAttribute("securityUser");
            WebBusinessObject userProjectWBO =new WebBusinessObject();
            Connection connection = null;
            try {
                connection = dataSource.getConnection();
                connection.setAutoCommit(false);
                forInsert.setConnection(connection);
                String sql = sqlMgr.getSql("insertUserProject").trim();
                forInsert.setSQLQuery(sql);

                for (int i=0; i<userProjects.size();i++) {

                    userProjectWBO = (WebBusinessObject) userProjects.get(i);

                    params = new Vector();

                    params.addElement(new StringValue(UniqueIDGen.getNextID()));
                    params.addElement(new StringValue(userID));
                    params.addElement(new StringValue((String) userProjectWBO.getAttribute("projectId")));
                    params.addElement(new StringValue((String) userProjectWBO.getAttribute("projectName")));
                    params.addElement(new StringValue((String) userProjectWBO.getAttribute("isDefault")));
                    params.addElement(new StringValue(securityUser.getUserId()));
                    forInsert.setparams(params);

                    queryResult = forInsert.executeUpdate();
                    
                    if(queryResult <= 0){
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
                forInsert.setSQLQuery(sqlMgr.getSql("updateProjectUserGroup").trim());
                params = new Vector();
                params.addElement(new StringValue(projectIdDefault));
                params.addElement(new StringValue(userID));
                forInsert.setparams(params);
                queryResult = forInsert.executeUpdate();

                    if(queryResult <= 0){
                        connection.rollback();
                        return false;
                    }
            } catch (SQLException se) {
            try {
                connection.rollback();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
                logger.error(se.getMessage());
                return false;
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
            userProjects = USER_PROJECTS_MGR.getOnArbitraryKey(userId, "key1");
        } catch(Exception ex) { logger.error(ex.getMessage()); }

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
            forSelect.setSQLQuery(sqlMgr.getSql("getAllUserProjectIds").trim());
            result = forSelect.executeQuery();

        } catch (SQLException ex) {
            Logger.getLogger(UserProjectsMgr.class.getName()).log(Level.SEVERE, null, ex);

        } catch (UnsupportedTypeException ex) {
            Logger.getLogger(UserProjectsMgr.class.getName()).log(Level.SEVERE, null, ex);

        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                Logger.getLogger(UserProjectsMgr.class.getName()).log(Level.SEVERE, null, ex);
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

    public ArrayList getAllProjectsByUserAsArrayList(String userId){
        ArrayList allAsArrayList = new ArrayList();

        Vector allAsVector = getAllProjectsByUserId(userId);

        for (int i = 0; i < allAsVector.size(); i++) {
            allAsArrayList.add((WebBusinessObject) allAsVector.get(i));
        }

        return allAsArrayList;
    }

    public Vector getAllProjectsByUserId(String userId) {

        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        StringBuffer query = new StringBuffer(sqlMgr.getSql("getAllProjectsByUserId").trim());

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

    public List<WebBusinessObject> getByUserId(String userId) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> result = new Vector<Row>();
        List<WebBusinessObject> data = new ArrayList<WebBusinessObject>();
        Vector parameters = new Vector();

        parameters.add(new StringValue(userId));

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getByUserId").trim());
            command.setparams(parameters);

            result = command.executeQuery();
        } catch (SQLException se) {
            System.out.println("Persistence Error " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            System.out.println("Persistence Error " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException se) {
                System.out.println("Close Error " + se.getMessage());
            }
        }
        
        for(Row row : result) {
            data.add(fabricateBusObj(row));
        }

        return data;
    }

    @Override
    public ArrayList getCashedTableAsBusObjects() {
        cashedData = new ArrayList();
        WebBusinessObject wbo = null;

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
}
