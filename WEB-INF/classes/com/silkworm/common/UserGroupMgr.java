package com.silkworm.common;

import com.maintenance.common.Tools;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import com.silkworm.functional_security.db_access.BusinessOpSecurityMgr;
import com.silkworm.util.ServletUtils;
import java.io.ByteArrayInputStream;

import java.util.*;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.http.HttpServletRequest;

public class UserGroupMgr extends RDBGateWay {

    private static UserGroupMgr userGroupMgr = new UserGroupMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();

    public UserGroupMgr() {
    }

    public static UserGroupMgr getInstance() {
        System.out.println("Getting UserGroupMgr Instance ....");
        return userGroupMgr;
    }

    @Override
    protected void initSupportedForm() {
        if (supportedForm == null) {
            try {
                System.out.println("UserGroupMgr ..***********.trying to get the group.XML file from path:: " + webInfPath);
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("user_group.xml")));
            } catch (Exception e) {
                System.out.println("Could not locate XML Document");
            }
        }
    }

    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    @Override
    public Vector getSearchQueryResult(HttpServletRequest request) throws SQLException, Exception {
        String sTemp = new String(request.getParameter("userName").getBytes(), "ISO-8859-1");
        System.out.println("$$$$$$$$$$$$$$$$$$$$$$$$$$ User Name ====> " + request.getParameter("userName"));
        System.out.println("$$$$$$$$$$$$$$$$$$$$$$$$$$ User Name ====> " + sTemp);
        if (request.getParameter("userName").equals("") || request.getParameter("password").equals("")) {
            return null;
        } else {
            return super.getSearchQueryResult(request);
        }
    }

    public Vector getSearchResult(HttpServletRequest req, String password) throws SQLException, Exception {
        // class variables setting
        String userName = (String) req.getParameter("userName");
        userName = Tools.getRealChar(userName);

        this.theRequest = req;
        this.presentQueryParameters = ServletUtils.getRequestParams(theRequest);

        Vector params = new Vector();
        Vector queryResult = null;

        params.addElement(new StringValue((String) req.getAttribute("groupID")));
        params.addElement(new StringValue(password));
        params.addElement(new StringValue(userName));

        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = dataSource.getConnection();
        try {

            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("selectLoginUser").trim());
            forQuery.setparams(params);

            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            throw se;

        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            connection.close();
        }

        // process the vector
        // vector of business objects
        Vector reultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            reultBusObjs.add(fabricateBusObj(r));
        }

        return reultBusObjs;
    }

    public boolean updateGroupPreviliges(String prev, String groupName, String groupID) throws NoUserInSessionException {
        Vector params = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue(prev));
        params.addElement(new StringValue(groupName));
        params.addElement(new StringValue(groupID));

        String query = "UPDATE USER_GROUP SET GROUP_MENU=?, GROUP_NAME=? WHERE GROUP_ID=?";

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(query.trim());
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

    public boolean updateGroupPreviliges2(String prev, String groupName, String groupID, String[] pages) throws NoUserInSessionException {
        Vector params = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;

        byte[] groupMenuByte = prev.getBytes();
        ByteArrayInputStream byteInputStream = new ByteArrayInputStream(groupMenuByte);
        params.addElement(new ImageValue(byteInputStream, groupMenuByte.length));
        params.addElement(new StringValue(groupName));
        params.addElement(new StringValue(groupID));

        String query = "UPDATE USER_GROUP SET GROUP_MENU=?, GROUP_NAME=? WHERE GROUP_ID=?";

        Connection connection = null;
        try {

            beginTransaction();
            forUpdate.setConnection(transConnection);
            forUpdate.setSQLQuery(query.trim());
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();
            if (queryResult < 0) {
                transConnection.rollback();
            } else {
                BusinessOpSecurityMgr bussinessOpSecurityMgr = BusinessOpSecurityMgr.getInstance();
                try {
                    Vector data = new Vector();
                    data = bussinessOpSecurityMgr.getOnArbitraryKey(groupID, "key1");
                    if (data != null & !data.isEmpty()) {
                        bussinessOpSecurityMgr.deleteOnArbitraryKey(groupID, "key1");
                    }

                    if (pages != null) {
                        for (int i = 0; i < pages.length; i++) {
                            params = new Vector();
                            forUpdate = new SQLCommandBean();
                            forUpdate.setConnection(transConnection);
                            queryResult = -1000;
                            params.addElement(new StringValue(UniqueIDGen.getNextID()));
                            params.addElement(new StringValue(pages[i]));
                            params.addElement(new StringValue(groupID));
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
                            forUpdate.setSQLQuery(sqlMgr.getSql("insertBusinessOpSecurity").trim());
                            forUpdate.setparams(params);
                            queryResult = forUpdate.executeUpdate();
                            if (queryResult < 0) {
                                transConnection.rollback();
                                break;
                            }
                        }
                        return true;

                    }
                } catch (Exception ex) {
                    Logger.getLogger(UserGroupMgr.class.getName()).log(Level.SEVERE, null, ex);
                }

            }

            System.out.println("table updated");
        } catch (SQLException se) {
            System.out.println("Exception inserting group: " + se.getMessage());
            return false;
        } finally {

            endTransaction();

        }

        return (queryResult > 0);
    }

    public Vector getGroupMembers(String groupName) throws SQLException, Exception {

        Vector SQLparams = new Vector();

        if (supportedForm == null) {
            initSupportedForm();
        }

        SQLparams.add(new StringValue(groupName));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = dataSource.getConnection();
        try {

            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("selectUserGroup").trim());
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            throw se;
        } catch (UnsupportedTypeException uste) {
            System.out.println("Persistence Error " + uste.getMessage());
        } finally {
            connection.close();
        }

        // process the vector
        // vector of business objects
        Vector reultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            reultBusObjs.add(fabricateBusObj(r));
        }

        return reultBusObjs;
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

        for (Row row : result) {
            data.add(fabricateBusObj(row));
        }

        return data;
    }

    public boolean isUserHasGroup(String userId, String groupId) throws SQLException, Exception {
        Vector queryResult = null;
        SQLCommandBean command;
        Connection connection = null;
        Vector parameters = new Vector();

        parameters.add(new StringValue(userId));
        parameters.add(new StringValue(groupId));

        try {
            connection = dataSource.getConnection();
            command = new SQLCommandBean();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("isUserHasGroup").trim());
            command.setparams(parameters);

            queryResult = command.executeQuery();
        } catch (SQLException se) {
            throw se;
        } catch (UnsupportedTypeException uste) {
            System.out.println("Persistence Error " + uste.getMessage());
        } finally {
            connection.close();
        }

        Row row;
        int result = -1000;
        if (!queryResult.isEmpty()) {
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                row = (Row) e.nextElement();
                result = row.getBigDecimal("RESULT").intValue();
            }
        }

        return (result > 0);
    }

    public Vector getUserByName(String userName) throws SQLException, Exception {
        Vector queryResult = null;
        SQLCommandBean command;
        Connection connection = null;
        Vector parameters = new Vector();

        parameters.add(new StringValue(userName));

        try {
            connection = dataSource.getConnection();
            command = new SQLCommandBean();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("selectActiveUser").trim());
            command.setparams(parameters);

            queryResult = command.executeQuery();
        } catch (SQLException se) {
            throw se;
        } catch (UnsupportedTypeException uste) {
            System.out.println("Persistence Error " + uste.getMessage());
        } finally {
            connection.close();
        }

        Row row;
        Vector result = new Vector();
        if (!queryResult.isEmpty()) {
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                row = (Row) e.nextElement();
                result.add(fabricateBusObj(row));
            }
        }

        return result;
    }
    
    //Kareem 
    public Vector getAllGroupUsers() throws SQLException, Exception {
        Vector queryResult = null;
        SQLCommandBean command;
        Connection connection = null;
        Vector parameters = new Vector();

        //parameters.add(new StringValue(userName));

        try {
            connection = dataSource.getConnection();
            command = new SQLCommandBean();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("selectAllGroupUsers").trim());
            //command.setparams(parameters);

            queryResult = command.executeQuery();
        } catch (SQLException se) {
            throw se;
        } catch (UnsupportedTypeException uste) {
            System.out.println("Persistence Error " + uste.getMessage());
        } finally {
            connection.close();
        }

        Row row;
        Vector result = new Vector();
        if (!queryResult.isEmpty()) {
            WebBusinessObject webo2;
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                row = (Row) e.nextElement();
                webo2=fabricateBusObj(row);
                if(row.getString("user_name")!=null){
                webo2.setAttribute("userName", row.getString("user_name"));
                }
                //result.add(fabricateBusObj(row));
                result.add(webo2);
            }
        }

        return result;
    }
    //Kareem end
    @Override
    public ArrayList getCashedTableAsArrayList() {
        throw new UnsupportedOperationException("Not supported yet.");
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
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
    }

    public Vector getGroupUsers(String groupID) {
        Vector usersVector = new Vector();

        try {
            Vector usersGroupVector = userGroupMgr.getOnArbitraryKey(groupID, "key");

            if (usersGroupVector.size() > 0) {
                for (int i = 0; i < usersGroupVector.size(); i++) {
                    WebBusinessObject wbo = (WebBusinessObject) usersGroupVector.get(i);
                    usersVector.add(wbo.getAttribute("userId").toString());
                }
            }

        } catch (Exception ex) {
            System.out.println(ex.getMessage());
        }

        return usersVector;

    }

    public void saveGroupUsers(HttpServletRequest request) {
        GroupMgr groupMgr = GroupMgr.getInstance();
        UserMgr userMgr = UserMgr.getInstance();

        Connection connection = null;

        String groupId = request.getParameter("groupID").toString();
        String[] usersId = request.getParameterValues("userId");

        try {
            //Connection Settings
            Vector params = null;
            SQLCommandBean forInsert = new SQLCommandBean();
            int queryResult = -1000;

            //Get data from All_Users page
            WebBusinessObject groupWbo = groupMgr.getOnSingleKey(groupId);
            byte[] groupMenuByte = ((String) groupWbo.getAttribute("groupMenu")).getBytes();
            ByteArrayInputStream byteInputStream = new ByteArrayInputStream(groupMenuByte);

            if (usersId.length > 0) {
                for (int i = 0; i < usersId.length; i++) {
                    params = new Vector();
                    WebBusinessObject userWbo = userMgr.getOnSingleKey(usersId[i]);

                    params.addElement(new StringValue((String) groupWbo.getAttribute("groupName")));
                    params.addElement(new StringValue((String) groupWbo.getAttribute("groupID")));
                    params.addElement(new StringValue(usersId[i]));
                    params.addElement(new StringValue((String) userWbo.getAttribute("userName")));
                    params.addElement(new StringValue("u" + usersId[i]));
                    params.addElement(new StringValue((String) userWbo.getAttribute("password")));
                    params.addElement(new StringValue("1"));
                    params.addElement(new StringValue((String) groupWbo.getAttribute("defaultPage")));
                    params.addElement(new StringValue((String) groupWbo.getAttribute("defaultPage")));
                    params.addElement(new StringValue((String) userWbo.getAttribute("password")));
                    params.addElement(new StringValue(UniqueIDGen.getNextID()));
                    params.addElement(new StringValue("UL"));
                    params.addElement(new StringValue("0"));
                    params.addElement(new ImageValue(byteInputStream, groupMenuByte.length));

                    connection = dataSource.getConnection();
                    forInsert.setConnection(connection);
                    forInsert.setSQLQuery("INSERT INTO user_group VALUES(?,?,?,?,?,?,?,SYSDATE,?,?,?,?,?,'0',?,?)");
                    forInsert.setparams(params);
                    queryResult = forInsert.executeUpdate();
                    if (queryResult < 0) {
                        connection.rollback();
                    }
                    try {
                        Thread.sleep(100);
                    } catch (InterruptedException ex) {
                        logger.error(ex.getMessage());
                    }
                    byteInputStream.reset();
                }
            }
        } catch (Exception ex) {
            try {
                System.out.println("General Saving Group Users Exception:" + ex.getMessage());
                logger.error(ex.getMessage());
                connection.rollback();
            } catch (SQLException ex1) {
                System.out.println("SQL Saving Group Users Exception:" + ex1.getMessage());
                logger.error(ex1.getMessage());
            }
        } finally {
            try {
                connection.commit();
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }
    }
}
