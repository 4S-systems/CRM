package com.silkworm.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import java.sql.SQLException;
import com.silkworm.util.DictionaryItem;
import com.tracker.db_access.TotalTicketsMgr;
import java.util.*;
import java.sql.Connection;
import java.util.logging.Level;
import java.util.logging.Logger;

public class PersistentSessionMgr extends RDBGateWay {

    private static final PersistentSessionMgr persistSessionMgr = new PersistentSessionMgr();
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
                System.out.println("PersistentSessionMgr ..***********.trying to get the XML file from path:: " + webInfPath);
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("persist_session.xml")));
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

   
    public static PersistentSessionMgr getInstance() {
        System.out.println("Getting PersistentSessionMgr Instance ....");
        return persistSessionMgr;
    }

    public void setSysPaths(String[] sys_paths) {
        this.sys_paths = sys_paths;
        imageDirPath = sys_paths[1];

    }

    public boolean saveOrUpdateObject(String remoteAddress, String userId, String userName, String managerId, String action, String ipAddress) throws NoUserInSessionException{
        
        
        if(remoteAddress==null || userId==null){
            return false;
        }


       Vector params = new Vector();
 
       
//       params.addElement(new StringValue(managerId));
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        String insertQuery = null;
        Connection conn = null;
        try {
            conn = dataSource.getConnection();
            conn.setAutoCommit(true);
            forInsert.setConnection(conn);
            if (action.equals("I")) {
                params.addElement(new StringValue(remoteAddress));
                params.addElement(new StringValue(userId));
                params.addElement(new StringValue(userName));
                params.addElement(new StringValue(managerId));
                params.addElement(new StringValue(ipAddress));
                insertQuery = this.getQuery("insertSession").trim();
            } else {
                params.addElement(new StringValue(userId));
                params.addElement(new StringValue(userName));
                params.addElement(new StringValue(managerId));
                params.addElement(new StringValue(ipAddress));
                params.addElement(new StringValue(remoteAddress));
                insertQuery = this.getQuery("updateSession").trim();
            }

            forInsert.setSQLQuery(insertQuery.trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            // transConnection.rollback();
            System.out.println("reight insertion");
        } catch (SQLException se) {
            logger.error("PersistentSessionMgr insert error --->>> " + se.getMessage());
            System.out.println("PersistentSessionMgr insert error --->>> " + se.getMessage());
            return false;
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException ex) {
                    Logger.getLogger(PersistentSessionMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }

        return true;
    }

    public ArrayList<String> getLoggedUsers() {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> result;
        String query = getQuery("getLoggedUsers").trim();
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(query);
            result = command.executeQuery();
            ArrayList<String> data = new ArrayList<>();
            for (Row row : result) {
                if (row.getString("USER_ID") != null) {
                    data.add(row.getString("USER_ID"));
                }
            }
            return data;
        } catch (UnsupportedTypeException | SQLException | NoSuchColumnException ex) {
            Logger.getLogger(PersistentSessionMgr.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }
        return new ArrayList<>();
    }
        
   


  //  public boolean updateUser(WebBusinessObject wbo, HttpSession s) throws NoUserInSessionException, SQLException {
//        setSessionUser(s);
//
//        if (wbo == null) {
//            System.out.println("UPDATE USER null object is passed");
//        } else {
//            System.out.println("UPDATE USER the object is just fine");
//        }
//
//        //WebAppUser user = (WebAppUser)wbo;
//        Vector params = new Vector();
//        SQLCommandBean forUpdate = new SQLCommandBean();
//        int queryResult = -1000;
//
//        System.out.println(wbo.getAttribute("password"));
//        System.out.println(wbo.getAttribute("userId"));
//
//        params.addElement(new StringValue((String) wbo.getAttribute("password")));
//
//        params.addElement(new StringValue((String) wbo.getAttribute("email")));
//
//        params.addElement(new StringValue((String) wbo.getAttribute("fullName")));
//
//        params.addElement(new StringValue((String) wbo.getAttribute("userId")));
//
//        //     Connection connection = null;
//        try {
//            //transConnection = dataSource.getConnection();
//            //transConnection.setAutoCommit(false);
//            forUpdate.setConnection(transConnection);
//
//            forUpdate.setSQLQuery(sqlMgr.getSql("updateUser").trim());
//            forUpdate.setparams(params);
//            queryResult = forUpdate.executeUpdate();
//            // transConnection.rollback();
//            System.out.println("reight insertion");
//        } catch (SQLException se) {
//
//            throw se;
//
//        }
////
//      return (true);
//    }

   
    

  

   
   @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
    }

    @Override
    public ArrayList getCashedTableAsArrayList() {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }
  
    public ArrayList<WebBusinessObject> getUsersWithDepartment() {
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        String query = getQuery("getUsersWithDepartment").trim();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
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
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }
        ArrayList<WebBusinessObject> resultBusObjs = new ArrayList<>();
        if (queryResult != null) {
            WebBusinessObject wbo;
            Row r;
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = fabricateBusObj(r);
                try {
                    if (r.getString("DEPARTMENT_NAME") != null) {
                        wbo.setAttribute("departmentName", r.getString("DEPARTMENT_NAME"));
                    }
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(PersistentSessionMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                resultBusObjs.add(wbo);
            }
        }
        return resultBusObjs;
    }
}
