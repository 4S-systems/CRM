package com.silkworm.common;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import java.io.ByteArrayInputStream;
import java.sql.SQLException;
import java.util.*;
import javax.servlet.http.HttpSession;
import java.sql.*;

public class GroupMgr extends RDBGateWay {

    /**
     * Creates a new instance of GroupMgr
     */
    private static final GroupMgr GROUP_MGR = new GroupMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();

    public static GroupMgr getInstance() {
        return GROUP_MGR;
    }

    private GroupMgr() {
    }

    @Override
    protected void initSupportedForm() {
        if (supportedForm == null) {
            try {
                System.out.println("IssueMgr ..***********.trying to get the group.XML file from path:: " + webInfPath);
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("group.xml")));
            } catch (Exception e) {
                System.out.println("Could not locate XML Document");
            }
        }
    }

    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public boolean saveObject(WebBusinessObject wbo, HttpSession s) throws NoUserInSessionException {
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        // waUser.printSelf();
        wbo.printSelf();

        if (wbo == null) {
            System.out.println("null object is passed");
        } else {
            System.out.println("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! the object is just fine");
        }


        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue((String) wbo.getAttribute("groupName")));
        params.addElement(new StringValue((String) wbo.getAttribute("groupDesc")));
        params.addElement(new StringValue((String) wbo.getAttribute("groupMenu")));
        params.addElement(new StringValue((String) waUser.getAttribute("userId")));

        System.out.println("print params");
        for (int i = 0; i < params.size(); i++) {
            System.out.println(params.elementAt(i).toString());
        }
        //
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            // System.out.println(insertGroupSQL);
            forInsert.setSQLQuery(sqlMgr.getSql("insertTrackerGroup").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            cashData();
            System.out.println("right insertion");
        } catch (SQLException se) {
            System.out.println("Exception inserting group: " + se.getMessage());
            return false;
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                System.out.println("Close Error");
                return false;
            }
        }

        return (queryResult > 0);
    }

    public boolean saveGroup(WebBusinessObject wbo, HttpSession s, String[] pages) throws NoUserInSessionException, SQLException {
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        // waUser.printSelf();
        wbo.printSelf();

        if (wbo == null) {
            System.out.println("null object is passed");
        } else {
            System.out.println("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! the object is just fine");
        }


        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        String groupId = UniqueIDGen.getNextID();
        String groupMenu = (String) wbo.getAttribute("groupMenu");
        byte[] groupMenuByte = groupMenu.getBytes();
        ByteArrayInputStream byteInputStream = new ByteArrayInputStream(groupMenuByte);
        params.addElement(new StringValue(groupId));
        params.addElement(new StringValue((String) wbo.getAttribute("groupName")));
        params.addElement(new StringValue((String) wbo.getAttribute("groupDesc")));
        params.addElement(new StringValue((String) waUser.getAttribute("userId")));
        params.addElement(new StringValue((String) wbo.getAttribute("defaultPage")));
        params.addElement(new ImageValue(byteInputStream, groupMenuByte.length));
        System.out.println("print params");
        for (int i = 0; i < params.size(); i++) {
            System.out.println(params.elementAt(i).toString());
        }
        //
        Connection connection = null;
        try {
            beginTransaction();
            forInsert.setConnection(transConnection);
            // System.out.println(insertGroupSQL);
            forInsert.setSQLQuery(sqlMgr.getSql("insertTrackerGroup").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            if (queryResult < 0) {
                transConnection.rollback();
                return false;

            }
            if (pages != null) {
                for (String page : pages) {
                    params = new Vector();
                    forInsert = new SQLCommandBean();
                    forInsert.setConnection(transConnection);
                    queryResult = -1000;
                    params.addElement(new StringValue(UniqueIDGen.getNextID()));
                    params.addElement(new StringValue(page));
                    params.addElement(new StringValue(groupId));
                    params.addElement(new StringValue(""));
                    params.addElement(new StringValue(""));
                    params.addElement(new StringValue(" "));
                    params.addElement(new StringValue(" "));
                    params.addElement(new StringValue(" "));
                    params.addElement(new StringValue(" "));
                    params.addElement(new StringValue(" "));
                    params.addElement(new StringValue(" "));
                    params.addElement(new StringValue(" "));
                    params.addElement(new StringValue(" "));
                    params.addElement(new StringValue(" "));
                    forInsert.setSQLQuery(sqlMgr.getSql("insertBusinessOpSecurity").trim());
                    forInsert.setparams(params);
                    queryResult = forInsert.executeUpdate();
                    if (queryResult < 0) {
                        transConnection.rollback();
                        return false;

                    }
                }
            } else {
                transConnection.rollback();
                return false;
            }
        } catch (SQLException se) {
            System.out.println("Exception inserting group: " + se.getMessage());
            transConnection.rollback();
            return false;
        } finally {

            endTransaction();

        }

        return (queryResult > 0);
    }

    public boolean updateGroup(WebBusinessObject wbo, HttpSession s) throws NoUserInSessionException {
        Vector params = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;
        
        String groupMenu = (String) wbo.getAttribute("groupMenu");
        byte[] groupMenuByte = groupMenu.getBytes();
        ByteArrayInputStream byteInputStream = new ByteArrayInputStream(groupMenuByte);
        params.addElement(new StringValue((String) wbo.getAttribute("groupDesc")));
        params.addElement(new ImageValue(byteInputStream, groupMenuByte.length));
        params.addElement(new StringValue((String) wbo.getAttribute("groupName")));
        params.addElement(new StringValue((String) wbo.getAttribute("defaultPage")));
        params.addElement(new StringValue((String) wbo.getAttribute("groupID")));        
        System.out.println("print params");
        for (int i = 0; i < params.size(); i++) {
            System.out.println(params.elementAt(i).toString());
        }

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(sqlMgr.getSql("updateTrackerGroup").trim());
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();

            cashData();
            System.out.println("table updated");
        } catch (SQLException se) {
            System.out.println("Exception inserting group: " + se.getMessage());
            return false;
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                System.out.println("Close Error");
                return false;
            }
        }

        return (queryResult > 0);
    }
    
    public WebBusinessObject getDefaultGroup(String userId) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        Vector<Row> result = new Vector<Row>();

        parameters.addElement(new StringValue(userId));       

        for (int i = 0; i < parameters.size(); i++) {
            System.out.println(parameters.elementAt(i).toString());
        }

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getDefaultGroup").trim());
            command.setparams(parameters);
            result = command.executeQuery();
        } catch (SQLException se) {
            System.out.println("Exception inserting group: " + se.getMessage());
        } catch (UnsupportedTypeException se) {
            System.out.println("Exception inserting group: " + se.getMessage());
        }  finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                System.out.println("Close Error: " + ex);
            }
        }
        
        for (Row row : result) {
            return fabricateBusObj(row);
        }

        return null;
    }
    
    public boolean cloneGroup(WebBusinessObject wbo) {
        Vector params = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;
        params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue((String) wbo.getAttribute("groupName")));
        params.addElement(new StringValue((String) wbo.getAttribute("groupName")));
        params.addElement(new StringValue((String) wbo.getAttribute("userID")));
        params.addElement(new StringValue((String) wbo.getAttribute("groupID")));
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(getQuery("cloneGroup").trim());
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();
        } catch (SQLException se) {
            System.out.println("Exception cloning group: " + se.getMessage());
            return false;
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                System.out.println("Close Error");
                return false;
            }
        }
        return (queryResult > 0);
    }

    @Override
    public ArrayList getCashedTableAsArrayList() {
        cashedData = new ArrayList();
        WebBusinessObject wbo;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            System.out.println("my name is " + (String) wbo.getAttribute("groupName"));
            cashedData.add((String) wbo.getAttribute("groupName"));
        }

        return cashedData;
    }

    @Override
    public ArrayList getCashedTableAsBusObjects() {
        cashedData = new ArrayList();
        WebBusinessObject wbo;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            // System.out.println("my name is " + (String) wbo.getAttribute("groupName"));
            wbo.setObjectKey((String) wbo.getAttribute("groupName"));
            cashedData.add(wbo);
        }

        return cashedData;
    }

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
    }
    
    public ArrayList<WebBusinessObject> getAllGroups(){
    
    WebBusinessObject wbo;
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        StringBuilder sql = null;
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            sql = new StringBuilder(getQuery("getAllGroups").trim());
            forQuery.setSQLQuery(sql.toString());
            
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }
        ArrayList<WebBusinessObject> resultBusObjs = new ArrayList<>();
        Row r = null;
        Enumeration e = queryResult.elements();
        try {
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = fabricateBusObj(r);
                if (r.getString("GROUP_ID") != null) {
                    wbo.setAttribute("groupID", r.getString("GROUP_ID"));
                }
                if (r.getString("GROUP_NAME") != null) {
                    wbo.setAttribute("groupName", r.getString("GROUP_NAME"));
                }
                resultBusObjs.add(wbo);
            }
        } catch (NoSuchColumnException ce) {
            logger.error(ce);
        }
        return resultBusObjs;
    }
}
