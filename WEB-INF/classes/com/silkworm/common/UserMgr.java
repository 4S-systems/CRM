package com.silkworm.common;

import com.clients.db_access.ClientComplaintsMgr;
import com.crm.common.CRMConstants;
import com.maintenance.common.UserPrev;
import com.maintenance.db_access.AllMaintenanceInfoMgr;
import com.maintenance.db_access.GroupPrevMgr;
import com.maintenance.db_access.TradeMgr;
import com.maintenance.db_access.UserStoresMgr;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import java.sql.SQLException;
import com.silkworm.util.DictionaryItem;
import com.tracker.db_access.TotalTicketsMgr;
import com.tracker.servlets.TrackerLoginServlet;
import java.util.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.*;
import java.sql.Connection;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.http.HttpServletResponse;

public class UserMgr extends RDBGateWay {

    private static final UserMgr USER_MGR = new UserMgr();
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
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("user_table.xml")));
            } catch (Exception e) {
                System.out.println("Could not locate XML Document");
            }
        }
    }

     public ArrayList<WebBusinessObject> getAllBrokers() {
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery("SELECT U.* FROM USERS U RIGHT JOIN USERS_EXT UE ON U.USER_ID = UE.USER_ID");
            queryResult = forQuery.executeQuery();
        } catch (SQLException | UnsupportedTypeException se) {
            System.out.println("jjjjjjjjjjjjjjjjjjjjjjj" + se.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }
        ArrayList results = new ArrayList();
        Row r;
        if (queryResult != null) {
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                results.add(fabricateBusObj(r));
            }
        }
        return results;
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

    public static UserMgr getInstance() {
        System.out.println("Getting UserMgr Instance ....");
        return USER_MGR;
    }

    public void setSysPaths(String[] sys_paths) {
        this.sys_paths = sys_paths;
        imageDirPath = sys_paths[1];

    }

    public boolean saveObject(WebBusinessObject wbo, HttpSession s) throws NoUserInSessionException {
        setUserID();
        setSessionUser(s);

        if (wbo == null) {
            System.out.println("null object is passed");
        } else {
            System.out.println("the object is just fine");
        }

        WebAppUser user = (WebAppUser) wbo;
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        if (this.createUserHomeDir() && this.createUserImageDir()) {
            params.addElement(new StringValue(getUserID()));
            params.addElement(new StringValue(user.getUserName()));
            params.addElement(new StringValue(user.getPassword()));
            params.addElement(new StringValue("u" + getUserID()));
            params.addElement(new StringValue(getSessionUser()));
            params.addElement(new StringValue(user.getEmail()));
            params.addElement(new StringValue("0"));
            try {
                //transConnection = dataSource.getConnection();
                //transConnection.setAutoCommit(false);
                forInsert.setConnection(transConnection);

                forInsert.setSQLQuery(sqlMgr.getSql("insertUser").trim());
                forInsert.setparams(params);
                queryResult = forInsert.executeUpdate();
                // transConnection.rollback();
                System.out.println("reight insertion");
            } catch (SQLException se) {
                logger.error(se.getMessage());
                return false;
            }

        } else {
            return false;
        }

        return (queryResult > 0);
    }

    public boolean updateUser(WebBusinessObject wbo, HttpSession s) throws NoUserInSessionException, SQLException {
        setSessionUser(s);

        if (wbo == null) {
            System.out.println("UPDATE USER null object is passed");
        } else {
            System.out.println("UPDATE USER the object is just fine");
        }

        //WebAppUser user = (WebAppUser)wbo;
        Vector params = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;

        System.out.println(wbo.getAttribute("password"));
        System.out.println(wbo.getAttribute("userId"));

        params.addElement(new StringValue((String) wbo.getAttribute("password")));

        params.addElement(new StringValue((String) wbo.getAttribute("email")));

        params.addElement(new StringValue((String) wbo.getAttribute("fullName")));

        params.addElement(new StringValue((String) wbo.getAttribute("userId")));

        //     Connection connection = null;
        try {
            //transConnection = dataSource.getConnection();
            //transConnection.setAutoCommit(false);
            forUpdate.setConnection(transConnection);

            forUpdate.setSQLQuery(sqlMgr.getSql("updateUser").trim());
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();
            // transConnection.rollback();
            System.out.println("reight insertion");
        } catch (SQLException se) {

            throw se;

        }

        return (queryResult > 0);
    }

    public boolean updateBasicDataOfUser(WebBusinessObject wbo, HttpSession s) throws NoUserInSessionException, SQLException {
        setSessionUser(s);

        if (wbo == null) {
            System.out.println("UPDATE USER null object is passed");
        } else {
            System.out.println("UPDATE USER the object is just fine");
        }

        //WebAppUser user = (WebAppUser)wbo;
        Vector params = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;

        System.out.println(wbo.getAttribute("password"));
        System.out.println(wbo.getAttribute("userId"));

        params.addElement(new StringValue(((String) wbo.getAttribute("userName")).trim()));
        params.addElement(new StringValue((String) wbo.getAttribute("email")));
        params.addElement(new StringValue((String) wbo.getAttribute("fullName")));
        params.addElement(new StringValue((String) wbo.getAttribute("isSuperUser")));
        params.addElement(new StringValue((String) wbo.getAttribute("isManager")));
        params.addElement(new StringValue((String) wbo.getAttribute("canSendEmail")));//SIP ID
        params.addElement(new StringValue((String) wbo.getAttribute("userId")));

        //     Connection connection = null;
        try {
            //transConnection = dataSource.getConnection();
            //transConnection.setAutoCommit(false);
            forUpdate.setConnection(transConnection);

            forUpdate.setSQLQuery(sqlMgr.getSql("updateBasicDataOfUser").trim());
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();
            // transConnection.rollback();
            System.out.println("reight insertion");
        } catch (SQLException se) {

            throw se;

        }

        return (queryResult > 0);
    }

    public boolean updatePasswordOfUser(WebBusinessObject wbo, HttpSession s) throws NoUserInSessionException, SQLException {
        setSessionUser(s);

        if (wbo == null) {
            System.out.println("UPDATE USER null object is passed");
        } else {
            System.out.println("UPDATE USER the object is just fine");
        }

        //WebAppUser user = (WebAppUser)wbo;
        Vector params = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue((String) wbo.getAttribute("password")));
        params.addElement(new StringValue((String) wbo.getAttribute("userId")));

        try {

            forUpdate.setConnection(transConnection);

            forUpdate.setSQLQuery(sqlMgr.getSql("updatePasswordOfUser").trim());
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();
            // transConnection.rollback();
            System.out.println("reight insertion");
        } catch (SQLException se) {

            throw se;

        }

        return (queryResult > 0);
    }

    public boolean saveUserGroupObject(WebBusinessObject userWbo, WebBusinessObject wbo, String defaultGroup) throws NoUserInSessionException {

        if (wbo == null) {
            System.out.println("null object is passed");
        } else {
            System.out.println("the object is just fine");
        }

        WebAppUser user = (WebAppUser) userWbo;
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        String groupMenu = (String) wbo.getAttribute("groupMenu");
        byte[] groupMenuByte = groupMenu.getBytes();
        ByteArrayInputStream byteInputStream = new ByteArrayInputStream(groupMenuByte);

        params.addElement(new StringValue((String) wbo.getAttribute("groupName")));
        params.addElement(new StringValue((String) wbo.getAttribute("groupID")));
        params.addElement(new StringValue(getUserID()));
        params.addElement(new StringValue(user.getUserName()));
        params.addElement(new StringValue("u" + getUserID()));
        params.addElement(new StringValue(user.getPassword()));
        params.addElement(new StringValue(getSessionUser()));
        params.addElement(new StringValue((String) user.getEmail()));
        params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue((String) userWbo.getAttribute("siteId")));
        params.addElement(new StringValue((String) userWbo.getAttribute("searchBy")));
        params.addElement(new ImageValue(byteInputStream, groupMenuByte.length));

        //        Connection connection = null;
        try {
            //transConnection = dataSource.getConnection();
            //transConnection.setAutoCommit(false);
            forInsert.setConnection(transConnection);
            if (defaultGroup.equals(wbo.getAttribute("groupID").toString())) {
                forInsert.setSQLQuery(sqlMgr.getSql("insertUserGroupByDefault").trim());
            } else {
                forInsert.setSQLQuery(sqlMgr.getSql("insertUserGroup").trim());
            }
//            forInsert.setSQLQuery(sqlMgr.getSql("insertUserGroup").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            try {
                Thread.sleep(200);
            } catch (InterruptedException ex) {
                ex.printStackTrace();
            }
            System.out.println("reight insertion");
        } catch (SQLException se) {
            System.out.println(se.getMessage());
            return false;
        }
        /*
         finally
         {
         try
         {
         connection.close();
         }
         catch(SQLException ex)
         {
         System.out.println("Close Error");
         return false;
         }
         }
         */
        return (queryResult > 0);
    }

    public boolean updateUserGroupObject(WebBusinessObject userWbo, WebBusinessObject wbo) throws NoUserInSessionException {
        if (wbo == null) {
            System.out.println("null object is passed");
        } else {
            System.out.println("the object is just fine");
        }

        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        userWbo.printSelf();
        wbo.printSelf();
        String groupMenu = (String) wbo.getAttribute("groupMenu");
        byte[] groupMenuByte = groupMenu.getBytes();
        ByteArrayInputStream byteInputStream = new ByteArrayInputStream(groupMenuByte);

        params.addElement(new StringValue((String) wbo.getAttribute("groupName")));
        params.addElement(new StringValue((String) wbo.getAttribute("groupID")));
        params.addElement(new StringValue((String) userWbo.getAttribute("userName")));
        params.addElement(new StringValue("u" + (String) userWbo.getAttribute("userId")));
        params.addElement(new StringValue((String) userWbo.getAttribute("password")));
        params.addElement(new StringValue(getSessionUser()));
        params.addElement(new ImageValue(byteInputStream, groupMenuByte.length));
        params.addElement(new StringValue((String) userWbo.getAttribute("email")));
        //   params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue((String) userWbo.getAttribute("siteId")));
        params.addElement(new StringValue((String) userWbo.getAttribute("userId")));

        //        Connection connection = null;
        try {
            //transConnection = dataSource.getConnection();
            //transConnection.setAutoCommit(false);
            forInsert.setConnection(transConnection);
//          forInsert.setSQLQuery(sqlMgr.getSql("insertUserGroup").trim());
            forInsert.setSQLQuery(sqlMgr.getSql("updateUserGroup").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            try {
                Thread.sleep(200);
            } catch (InterruptedException ex) {
                ex.printStackTrace();
            }
            System.out.println("reight insertion");
        } catch (SQLException se) {
            System.out.println(se.getMessage());
            return false;
        }
        /*
         finally
         {
         try
         {
         connection.close();
         }
         catch(SQLException ex)
         {
         System.out.println("Close Error");
         return false;
         }
         }
         */
        return (queryResult > 0);
    }

    public boolean saveUserTradeObject(WebBusinessObject userWbo, WebBusinessObject wbo) throws NoUserInSessionException {

        if (wbo == null) {
            System.out.println("null object is passed");
        } else {
            System.out.println("the object is just fine");
        }

        StringValue userTradeID = new StringValue(UniqueIDGen.getNextID());
        WebAppUser user = (WebAppUser) userWbo;
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(userTradeID);
        params.addElement(new StringValue((String) wbo.getAttribute("tradeId")));
        params.addElement(new StringValue((String) wbo.getAttribute("tradeName")));
        params.addElement(new StringValue(getUserID()));
        params.addElement(new StringValue(user.getUserName()));

        //        Connection connection = null;
        try {
            //transConnection = dataSource.getConnection();
            //transConnection.setAutoCommit(false);
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertUserTrade").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            try {
                Thread.sleep(200);
            } catch (InterruptedException ex) {
                ex.printStackTrace();
            }
            System.out.println("reight insertion");
        } catch (SQLException se) {
            System.out.println(se.getMessage());
            return false;
        }
        /*
         finally
         {
         try
         {
         connection.close();
         }
         catch(SQLException ex)
         {
         System.out.println("Close Error");
         return false;
         }
         }
         */
        return (queryResult > 0);
    }

    public boolean saveGrantsUserObject(WebBusinessObject userWbo, WebBusinessObject wbo) throws NoUserInSessionException {

        if (wbo == null) {
            System.out.println("null object is passed");
        } else {
            System.out.println("the object is just fine");
        }

        StringValue grantUserID = new StringValue(UniqueIDGen.getNextID());
        WebAppUser user = (WebAppUser) userWbo;
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(grantUserID);
        params.addElement(new StringValue((String) wbo.getAttribute("id")));
        params.addElement(new StringValue(getUserID()));

        //        Connection connection = null;
        try {
            //transConnection = dataSource.getConnection();
            //transConnection.setAutoCommit(false);
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertGrantUser").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            try {
                Thread.sleep(200);
            } catch (InterruptedException ex) {
                ex.printStackTrace();
            }
            System.out.println("reight insertion");
        } catch (SQLException se) {
            System.out.println(se.getMessage());
            return false;
        }
        /*
         finally
         {
         try
         {
         connection.close();
         }
         catch(SQLException ex)
         {
         System.out.println("Close Error");
         return false;
         }
         }
         */
        return (queryResult > 0);
    }

    public boolean updateGrantsUserObject(WebBusinessObject userWbo, WebBusinessObject wbo) throws NoUserInSessionException {

        if (wbo == null) {
            System.out.println("null object is passed");
        } else {
            System.out.println("the object is just fine");
        }

        StringValue grantUserID = new StringValue(UniqueIDGen.getNextID());
        WebBusinessObject user = (WebBusinessObject) userWbo;
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(grantUserID);
        params.addElement(new StringValue((String) wbo.getAttribute("id")));
        params.addElement(new StringValue((String) user.getAttribute("userId")));

        //        Connection connection = null;
        try {
            //transConnection = dataSource.getConnection();
            //transConnection.setAutoCommit(false);
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertGrantUser").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            try {
                Thread.sleep(200);
            } catch (InterruptedException ex) {
                ex.printStackTrace();
            }
            System.out.println("reight insertion");
        } catch (SQLException se) {
            System.out.println(se.getMessage());
            return false;
        }
        /*
         finally
         {
         try
         {
         connection.close();
         }
         catch(SQLException ex)
         {
         System.out.println("Close Error");
         return false;
         }
         }
         */
        return (queryResult > 0);
    }

    public boolean UpdateUserTradeObject(WebBusinessObject userWbo, WebBusinessObject wbo) throws NoUserInSessionException {

        if (wbo == null) {
            System.out.println("null object is passed");
        } else {
            System.out.println("the object is just fine");
        }

        StringValue userTradeID = new StringValue(UniqueIDGen.getNextID());
        WebBusinessObject user = (WebBusinessObject) userWbo;
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(userTradeID);
        params.addElement(new StringValue((String) wbo.getAttribute("tradeId")));
        params.addElement(new StringValue((String) wbo.getAttribute("tradeName")));
        params.addElement(new StringValue((String) user.getAttribute("userId")));
        params.addElement(new StringValue((String) user.getAttribute("userName")));

        //        Connection connection = null;
        try {
            transConnection = dataSource.getConnection();
            //transConnection.setAutoCommit(false);
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertUserTrade").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            try {
                Thread.sleep(200);
            } catch (InterruptedException ex) {
                ex.printStackTrace();
            }
            System.out.println("reight insertion");
        } catch (SQLException se) {
            System.out.println(se.getMessage());
            return false;
        }
        /*
         finally
         {
         try
         {
         connection.close();
         }
         catch(SQLException ex)
         {
         System.out.println("Close Error");
         return false;
         }
         }
         */
        return (queryResult > 0);
    }

    public WebBusinessObject getUser(HttpServletRequest req) throws SQLException, Exception {
        return null;
    }

    public ArrayList getCashedTableAsArrayList() {
        cashedData = new ArrayList();
        WebBusinessObject wbo = null;
        
        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            // System.out.println("my name is " + (String) wbo.getAttribute("userName"));
            cashedData.add((String) wbo.getAttribute("userName"));
        }

        return cashedData;
    }

    public ArrayList getCashedTableUserAsArrayList() {
        cashedData = new ArrayList<WebBusinessObject>();
        WebBusinessObject wbo = null;
        cashData();

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            // System.out.println("my name is " + (String) wbo.getAttribute("userName"));
            cashedData.add(wbo);
        }

        return cashedData;
    }

    public void saveUserGroups(WebBusinessObject wbo, ArrayList al, String defaultGroup, String mode) throws SQLException, Exception {
        ListIterator li = al.listIterator();

        while (li.hasNext()) {
            try {
                if (mode.equalsIgnoreCase("insert")) {
                    saveUserGroupObject(wbo, (WebBusinessObject) li.next(), defaultGroup);
                } else {
                    saveByUpdateUserGroupObject(wbo, (WebBusinessObject) li.next(), defaultGroup);
                }
            } catch (Exception ex) {
                throw new SQLException("Unable to save user group");
            }
        }
    }

    public void saveUserTrades(WebBusinessObject wbo, ArrayList al, String mode) throws SQLException, Exception {
        ListIterator li = al.listIterator();

        while (li.hasNext()) {
            try {
                if (mode.equalsIgnoreCase("insert")) {
                    saveUserTradeObject(wbo, (WebBusinessObject) li.next());
                } else {
                    updateUserGroupObject(wbo, (WebBusinessObject) li.next());
                }
            } catch (Exception ex) {
                throw new SQLException("Unable to save user group");
            }
        }
    }

    public void save(WebBusinessObject wbo, ArrayList al, String defaultGroup, HttpSession s) {
        try {
            //   beginTransaction();
            transConnection = dataSource.getConnection();
            saveObject(wbo, s);
            saveUserGroups(wbo, al, defaultGroup, "insert");
            //saveUserTrades(wbo,trade,"insert");
            this.cashData();
        } catch (SQLException ex) {
            try {
                System.out.println("SQL Error .Rollback. Insertion User Groups = " + ex.getMessage());
                //                transConnection.setAutoCommit(false);
                transConnection.rollback();
            } catch (SQLException sex) {
                System.out.println("Execption on RollBack connection " + sex.getMessage());
            }
        } catch (Exception ex) {
            System.out.println("User-Group error " + ex.getMessage());
        } finally {
            //   endTransaction();
        }
    }

    public void updateUserAndGroups(WebBusinessObject wbo, ArrayList al, String defaultGroup, HttpSession s) {
        try {
            for (int i = 0; i < al.size(); i++) {
                System.out.println("from manager: " + al.get(i));
            }
            beginTransaction();
            updateUser(wbo, s);
            saveUserGroups(wbo, al, defaultGroup, "update");
            this.cashData();
        } catch (SQLException ex) {
            try {
                System.out.println("SQL Error .Rollback. Insertion User Groups = " + ex.getMessage());
                //                transConnection.setAutoCommit(false);
                transConnection.rollback();
            } catch (SQLException sex) {
                System.out.println("Execption on RollBack connection " + sex.getMessage());
            }
        } catch (Exception ex) {
            System.out.println("User-Group error " + ex.getMessage());
        } finally {

            endTransaction();
        }
    }

    public void updateBaidData(WebBusinessObject wbo, String defaultGroup, HttpSession s) {
        try {
            beginTransaction();
            updateBasicDataOfUser(wbo, s);
            editBasicDateOfUserByGroup(wbo);
            editUserNameWithinOtherTables(wbo);
            this.cashData();
        } catch (SQLException ex) {
            try {
                System.out.println("SQL Error .Rollback. Insertion User Groups = " + ex.getMessage());
                transConnection.rollback();
            } catch (SQLException sex) {
                System.out.println("Execption on RollBack connection " + sex.getMessage());
            }
        } catch (Exception ex) {
            System.out.println("User-Group error " + ex.getMessage());
        } finally {
            endTransaction();
        }
    }

    public void updatePassword(WebBusinessObject wbo, String defaultGroup, HttpSession s) {
        try {

            beginTransaction();
            updatePasswordOfUser(wbo, s);
            editPasswordOfUserByGroup(wbo);
            this.cashData();
        } catch (SQLException ex) {
            try {
                System.out.println("SQL Error .Rollback. Insertion User Groups = " + ex.getMessage());
                //                transConnection.setAutoCommit(false);
                transConnection.rollback();
            } catch (SQLException sex) {
                System.out.println("Execption on RollBack connection " + sex.getMessage());
            }
        } catch (Exception ex) {
            System.out.println("User-Group error " + ex.getMessage());
        } finally {

            endTransaction();
        }
    }

    public String getUserByID(String id) {
        ArrayList users = this.getCashedTableAsBusObjects();
        WebBusinessObject wbo = null;
        String userName = null;

        for (int i = 0; i < users.size(); i++) {
            wbo = (WebBusinessObject) users.get(i);
            if (wbo.getAttribute("userId").equals(id)) {
                userName = (String) wbo.getAttribute("userName");
            }
        }

        return userName;
    }

    public void checkUserDirs() {

        String userHome = (String) currentUser.getAttribute("userHome");
        String frontPath = imageDirPath + "/" + userHome;
        String backPath = webInfPath + "/usr" + "/" + userHome;

        System.out.println("PPPPPPPPPPP " + backPath);

        File frontHomeDir = new File(frontPath);

        if (!frontHomeDir.exists()) {
            frontHomeDir.mkdir();
        } else {
            File[] frontList = frontHomeDir.listFiles();
            for (int i = 0; i < frontList.length; i++) {
                frontList[i].delete();
            }
        }

        File backHomeDir = new File(backPath);
        if (!backHomeDir.exists()) {
            backHomeDir.mkdir();
        } else {
            File[] backList = backHomeDir.listFiles();
            for (int i = 0; i < backList.length; i++) {
                backList[i].delete();
            }
        }
    }

    public boolean updateUserCompany(String userId, String companyId, String companyName, String loggedUser) throws NoUserInSessionException {
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        Connection connection = null;

        String ID = UniqueIDGen.getNextID();
        
        params.addElement(new StringValue(ID));
        params.addElement(new StringValue(userId));
        params.addElement(new StringValue(companyId));
        params.addElement(new StringValue(companyName));
        params.addElement(new StringValue(loggedUser));

        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertUserCompany").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            System.out.println("reight insertion");
        } catch (SQLException se) {
            System.out.println(se.getMessage());
            return false;
        }

        return (queryResult > 0);
    }

    public boolean editBasicDateOfUserByGroup(WebBusinessObject userWbo) throws NoUserInSessionException {

        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue((String) userWbo.getAttribute("userName")));
        params.addElement(new StringValue((String) userWbo.getAttribute("email")));
        params.addElement(new StringValue((String) userWbo.getAttribute("userId")));

        try {

            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(sqlMgr.getSql("editBasicDateOfUserByGroup").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            try {
                Thread.sleep(200);
            } catch (InterruptedException ex) {
                logger.error(ex.getMessage());
            }
            System.out.println("reight insertion");
        } catch (SQLException se) {
            System.out.println(se.getMessage());
            return false;
        }

        return (queryResult > 0);
    }

    public boolean editPasswordOfUserByGroup(WebBusinessObject userWbo) throws NoUserInSessionException {

        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

//        params.addElement(new StringValue((String) userWbo.getAttribute("userName")));       
        params.addElement(new StringValue((String) userWbo.getAttribute("password")));
        params.addElement(new StringValue((String) userWbo.getAttribute("userId")));

        try {

            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(sqlMgr.getSql("editPasswordOfUserByGroup").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            try {
                Thread.sleep(200);
            } catch (InterruptedException ex) {
                logger.error(ex.getMessage());
            }
            System.out.println("reight insertion");
        } catch (SQLException se) {
            System.out.println(se.getMessage());
            return false;
        }

        return (queryResult > 0);
    }

    public boolean saveByUpdateUserGroupObject(WebBusinessObject userWbo, WebBusinessObject wbo, String defaultGroup) throws NoUserInSessionException {

        if (wbo == null) {
            System.out.println("null object is passed");
        } else {
            System.out.println("the object is just fine");
        }

        GroupMgr groupMgr = GroupMgr.getInstance();
        WebBusinessObject groupWbo = new WebBusinessObject();
        groupWbo = groupMgr.getOnSingleKey(wbo.getAttribute("groupID").toString());

        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        String groupMenu = (String) wbo.getAttribute("groupMenu");
        byte[] groupMenuByte = groupMenu.getBytes();
        ByteArrayInputStream byteInputStream = new ByteArrayInputStream(groupMenuByte);

        params.addElement(new StringValue((String) wbo.getAttribute("groupName")));
        params.addElement(new StringValue((String) wbo.getAttribute("groupID")));
        params.addElement(new StringValue((String) userWbo.getAttribute("userId")));
        params.addElement(new StringValue((String) userWbo.getAttribute("userName")));
        params.addElement(new StringValue("u" + (String) userWbo.getAttribute("userId")));
        params.addElement(new StringValue((String) userWbo.getAttribute("password")));
        params.addElement(new StringValue(getSessionUser()));
        params.addElement(new StringValue((String) groupWbo.getAttribute("defaultPage")));
        params.addElement(new StringValue((String) groupWbo.getAttribute("defaultPage")));
        params.addElement(new StringValue((String) userWbo.getAttribute("email")));
        params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue((String) userWbo.getAttribute("siteId")));
        params.addElement(new StringValue((String) userWbo.getAttribute("searchBy")));
        params.addElement(new ImageValue(byteInputStream, groupMenuByte.length));
//        if (defaultGroup.equals(wbo.getAttribute("groupID").toString())){
//        params.addElement(new StringValue(defaultGroup));
//        }

        //        Connection connection = null;
        try {
            //transConnection = dataSource.getConnection();
            //transConnection.setAutoCommit(false);
            forInsert.setConnection(transConnection);
            if (defaultGroup.equals(wbo.getAttribute("groupID").toString())) {
                forInsert.setSQLQuery(sqlMgr.getSql("insertUserGroupByDefault").trim());
            } else {
                forInsert.setSQLQuery(sqlMgr.getSql("insertUserGroup").trim());
            }
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            try {
                Thread.sleep(200);
            } catch (InterruptedException ex) {
                logger.error(ex.getMessage());
            }
            System.out.println("reight insertion");
        } catch (SQLException se) {
            System.out.println(se.getMessage());
            return false;
        }
        /*
         finally
         {
         try
         {
         connection.close();
         }
         catch(SQLException ex)
         {
         System.out.println("Close Error");
         return false;
         }
         }
         */
        return (queryResult > 0);
    }

    // created by yasser
    public boolean saveCompleteUser(HttpServletRequest request, HttpSession session, WebAppUser webUser) {
        Connection connection = null;
        TradeMgr tradeMgr = TradeMgr.getInstance();

        try {
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            Vector params = new Vector();
            SQLCommandBean forInsert = new SQLCommandBean();
            int queryResult = -1000;
            int index;

            // set forInsert by connection
            forInsert.setConnection(connection);

            String searchBy = (String) request.getParameter("searchBy");
            String userTrades = (String) request.getParameter("userTrades");

            String isDefaultGroup = request.getParameter("isDefaultGroup");
            String isDefaultProjects = request.getParameter("isDefaultProject");

            String[] userGrants = request.getParameterValues("grantUser");
            String[] siteNames = request.getParameterValues("projectName");
            String[] siteCodes = request.getParameterValues("projectCode");
            String[] checkGroup = request.getParameterValues("checkGroup");
            String[] checkProjects = request.getParameterValues("checkProject");

            String[] userGroups = request.getParameterValues("userGroups");
            Vector<WebBusinessObject> subsetGroups = getActualGroups(checkGroup, userGroups);

            webUser.setAttribute("siteId", isDefaultProjects);
            webUser.setAttribute("searchBy", searchBy);

            // start to save
            setUserID();
            setSessionUser(session);

            WebAppUser user = (WebAppUser) webUser;
            // temp
            user.setAttribute("userId", getUserID());

            // saver user
            if (this.createUserHomeDir() && this.createUserImageDir()) {
                params.addElement(new StringValue(getUserID()));
                params.addElement(new StringValue(user.getUserName()));
                params.addElement(new StringValue(user.getPassword()));
                params.addElement(new StringValue("u" + getUserID()));
                params.addElement(new StringValue(getSessionUser()));
                params.addElement(new StringValue(user.getEmail()));
                params.addElement(new StringValue(user.getIsSuperUser()));
                params.addElement(new StringValue(user.getFullName()));
                params.addElement(new StringValue(user.getIsManager()));
                forInsert.setSQLQuery(sqlMgr.getSql("insertUser").trim());
                forInsert.setparams(params);
                queryResult = forInsert.executeUpdate();

                if (queryResult < 0) {
                    connection.rollback();
                    return false;
                }
            } else {
                return false;
            }
            String groupMenu;
            byte[] groupMenuByte;
            ByteArrayInputStream byteInputStream;

            // save group
            for (WebBusinessObject wbo : subsetGroups) {
                queryResult = -1000;
                params = new Vector();
                groupMenu = (String) wbo.getAttribute("groupMenu");
                groupMenuByte = groupMenu.getBytes();
                byteInputStream = new ByteArrayInputStream(groupMenuByte);

                params.addElement(new StringValue((String) wbo.getAttribute("groupName")));
                params.addElement(new StringValue((String) wbo.getAttribute("groupID")));
                params.addElement(new StringValue(getUserID()));
                params.addElement(new StringValue(user.getUserName()));
                params.addElement(new StringValue("u" + getUserID()));
                params.addElement(new StringValue(user.getPassword()));
                params.addElement(new StringValue(getSessionUser()));
                params.addElement(new StringValue((String) user.getEmail()));
                params.addElement(new StringValue(UniqueIDGen.getNextID()));
                params.addElement(new StringValue((String) user.getAttribute("siteId")));
                params.addElement(new StringValue((String) user.getAttribute("searchBy")));
                params.addElement(new ImageValue(byteInputStream, groupMenuByte.length));

                if (isDefaultGroup.equals(wbo.getAttribute("groupID").toString())) {
                    forInsert.setSQLQuery(sqlMgr.getSql("insertUserGroupByDefault").trim());
                } else {
                    forInsert.setSQLQuery(sqlMgr.getSql("insertUserGroup").trim());
                }

                forInsert.setparams(params);
                queryResult = forInsert.executeUpdate();
                if (queryResult < 0) {
                    connection.rollback();
                    return false;
                }
                try {
                    Thread.sleep(100);
                } catch (InterruptedException ex) {
                    logger.error(ex.getMessage());
                }
            }

            // save grants
            forInsert.setSQLQuery(sqlMgr.getSql("insertGrantUser").trim());
            for (int i = 0; i < userGrants.length; i++) {
                queryResult = -1000;
                params = new Vector();

                params.addElement(new StringValue(UniqueIDGen.getNextID()));
                params.addElement(new StringValue(userGrants[i]));
                params.addElement(new StringValue(getUserID()));

                forInsert.setparams(params);
                queryResult = forInsert.executeUpdate();

                if (queryResult < 0) {
                    connection.rollback();
                    return false;
                }

                try {
                    Thread.sleep(100);
                } catch (InterruptedException ex) {
                    logger.error(ex.getMessage());
                }
            }

            // save projects
            forInsert.setSQLQuery(sqlMgr.getSql("insertUserProject").trim());

            for (int j = 0; j < checkProjects.length; j++) {
                queryResult = -1000;
                params = new Vector();

                index = Integer.valueOf(checkProjects[j]).intValue();

                params.addElement(new StringValue(UniqueIDGen.getNextID()));
                params.addElement(new StringValue(webUser.getUserId()));
                params.addElement(new StringValue(siteCodes[index]));
                params.addElement(new StringValue(siteNames[index]));

                if (isDefaultProjects != null && isDefaultProjects.equalsIgnoreCase(siteCodes[index])) {
                    params.addElement(new StringValue("1"));
                } else {
                    params.addElement(new StringValue("0"));
                }

                params.addElement(new StringValue(getSessionUser()));
                forInsert.setparams(params);

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

            //insert total_tickets row
            forInsert.setSQLQuery(sqlMgr.getSql("insertUserTicketsCount").trim());
            int x = 0;
            params = new Vector();
            params.addElement(new StringValue(getUserID()));

            forInsert.setparams(params);

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

            // to save default el edara el fania
//            WebBusinessObject wboTrade;
//            wboTrade = tradeMgr.getOnSingleKey(userTrades);
//
//            String sql = sqlMgr.getSql("insertUserTrade").trim();
//            forInsert.setSQLQuery(sql);
//            queryResult = -1000;
//            params = new Vector();
//
//            params.addElement(new StringValue(UniqueIDGen.getNextID()));
//            params.addElement(new StringValue((String) wboTrade.getAttribute("tradeId")));
//            params.addElement(new StringValue((String) wboTrade.getAttribute("tradeName")));
//            params.addElement(new StringValue(getUserID()));
//            params.addElement(new StringValue(user.getUserName()));
//            forInsert.setparams(params);
//
//            queryResult = forInsert.executeUpdate();
//
//            if (queryResult <= 0) {
//                connection.rollback();
//                return false;
//            }
        } catch (Exception ex) {
            try {
                logger.error(ex.getMessage());
                connection.rollback();
            } catch (SQLException ex1) {
                logger.error(ex1.getMessage());
            }
            return false;
        } finally {
            try {
                connection.commit();
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        return true;
    }

    public String saveCompleteUser2(HttpServletRequest request, HttpSession session, WebAppUser webUser) {
        Connection connection = null;
        TradeMgr tradeMgr = TradeMgr.getInstance();
        String userID = UniqueIDGen.getNextID();
        try {
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            Vector params = new Vector();
            SQLCommandBean forInsert = new SQLCommandBean();
            int queryResult = -1000;
            int index;

            // set forInsert by connection
            forInsert.setConnection(connection);

            String searchBy = (String) request.getParameter("searchBy");
            String userTrades = (String) request.getParameter("userTrades");

            String isDefaultGroup = request.getParameter("isDefaultGroup");
            String isDefaultProjects = request.getParameter("isDefaultProject");

            String[] userGrants = request.getParameterValues("grantUser");
            String[] siteNames = request.getParameterValues("projectName");
            String[] siteCodes = request.getParameterValues("projectCode");
            String[] checkGroup = request.getParameterValues("checkGroup");
            String[] checkProjects = request.getParameterValues("checkProject");

            String[] userGroups = request.getParameterValues("userGroups");
            Vector<WebBusinessObject> subsetGroups = getActualGroups(checkGroup, userGroups);

            webUser.setAttribute("siteId", isDefaultProjects);
            webUser.setAttribute("searchBy", searchBy);

            // start to save
            setUserID();
            setSessionUser(session);

            WebAppUser user = (WebAppUser) webUser;
            // temp

            user.setAttribute("userId", userID);

            // saver user
            if (this.createUserHomeDir() && this.createUserImageDir()) {
                params.addElement(new StringValue(userID));
                params.addElement(new StringValue(user.getUserName()));
                params.addElement(new StringValue(user.getPassword()));
                params.addElement(new StringValue("u" + userID));
                params.addElement(new StringValue(getSessionUser()));
                params.addElement(new StringValue(user.getEmail()));
                params.addElement(new StringValue(user.getIsSuperUser()));
                params.addElement(new StringValue(user.getFullName()));
                params.addElement(new StringValue(request.getParameter("SIPID")));// Field name CAN_SEND_EMAIL
                params.addElement(new StringValue(user.getIsManager()));
                forInsert.setSQLQuery(sqlMgr.getSql("insertUser").trim());
                forInsert.setparams(params);
                queryResult = forInsert.executeUpdate();

                if (queryResult < 0) {
                    connection.rollback();
                    return null;
                }
            } else {
                return null;
            }
            String groupMenu;
            byte[] groupMenuByte;
            ByteArrayInputStream byteInputStream;

            // save group
            for (WebBusinessObject wbo : subsetGroups) {
                queryResult = -1000;
                params = new Vector();
                groupMenu = (String) wbo.getAttribute("groupMenu");
                groupMenuByte = groupMenu.getBytes();
                byteInputStream = new ByteArrayInputStream(groupMenuByte);

                params.addElement(new StringValue((String) wbo.getAttribute("groupName")));
                params.addElement(new StringValue((String) wbo.getAttribute("groupID")));
                params.addElement(new StringValue(userID));
                params.addElement(new StringValue(user.getUserName()));
                params.addElement(new StringValue("u" + userID));
                params.addElement(new StringValue(user.getPassword()));
                params.addElement(new StringValue(getSessionUser()));

                UserGroupMgr userGroupMgr = UserGroupMgr.getInstance();
                WebBusinessObject wbo2 = new WebBusinessObject();
                String defaultPage = "UPDATE_LATEER";
                wbo2 = userGroupMgr.getOnSingleKey("key7", (String) wbo.getAttribute("groupID"));
                if (wbo2 != null) {
                    defaultPage = (String) wbo2.getAttribute("defaultPage");

                }
                params.addElement(new StringValue(defaultPage));
                params.addElement(new StringValue(defaultPage));
                params.addElement(new StringValue((String) user.getEmail()));
                params.addElement(new StringValue(UniqueIDGen.getNextID()));
                params.addElement(new StringValue((String) user.getAttribute("siteId")));
                params.addElement(new StringValue((String) user.getAttribute("searchBy")));
                params.addElement(new ImageValue(byteInputStream, groupMenuByte.length));

                if (isDefaultGroup.equals(wbo.getAttribute("groupID").toString())) {
                    forInsert.setSQLQuery(sqlMgr.getSql("insertUserGroupByDefault").trim());
                } else {
                    forInsert.setSQLQuery(sqlMgr.getSql("insertUserGroup").trim());
                }

                forInsert.setparams(params);
                queryResult = forInsert.executeUpdate();
                if (queryResult < 0) {
                    connection.rollback();
                    return null;
                }
                try {
                    Thread.sleep(100);
                } catch (InterruptedException ex) {
                    logger.error(ex.getMessage());
                }
            }

            // save grants
            forInsert.setSQLQuery(sqlMgr.getSql("insertGrantUser").trim());
            for (int i = 0; i < userGrants.length; i++) {
                queryResult = -1000;
                params = new Vector();

                params.addElement(new StringValue(UniqueIDGen.getNextID()));
                params.addElement(new StringValue(userGrants[i]));
                params.addElement(new StringValue(userID));

                forInsert.setparams(params);
                queryResult = forInsert.executeUpdate();

                if (queryResult < 0) {
                    connection.rollback();
                    return null;
                }

                try {
                    Thread.sleep(100);
                } catch (InterruptedException ex) {
                    logger.error(ex.getMessage());
                }
            }

            // save projects
            forInsert.setSQLQuery(sqlMgr.getSql("insertUserProject").trim());

            for (int j = 0; j < checkProjects.length; j++) {
                queryResult = -1000;
                params = new Vector();

                index = Integer.valueOf(checkProjects[j]).intValue();

                params.addElement(new StringValue(UniqueIDGen.getNextID()));
                params.addElement(new StringValue(webUser.getUserId()));
                params.addElement(new StringValue(siteCodes[index]));
                params.addElement(new StringValue(siteNames[index]));

                if (isDefaultProjects != null && isDefaultProjects.equalsIgnoreCase(siteCodes[index])) {
                    params.addElement(new StringValue("1"));
                } else {
                    params.addElement(new StringValue("0"));
                }

                params.addElement(new StringValue(getSessionUser()));
                forInsert.setparams(params);

                queryResult = forInsert.executeUpdate();

                if (queryResult <= 0) {
                    connection.rollback();
                    return null;
                }

                try {
                    Thread.sleep(100);
                } catch (InterruptedException ex) {
                    logger.error(ex.getMessage());
                }
            }

            //insert total_tickets row
            forInsert.setSQLQuery(sqlMgr.getSql("insertUserTicketsCount").trim());
            int x = 0;
            params = new Vector();
            params.addElement(new StringValue(userID));

            forInsert.setparams(params);

            queryResult = forInsert.executeUpdate();

            if (queryResult <= 0) {
                connection.rollback();
                return null;
            }

            try {
                Thread.sleep(100);
            } catch (InterruptedException ex) {
                logger.error(ex.getMessage());
            }

            //insert user status
            params = new Vector();
            params.addElement(new StringValue(UniqueIDGen.getNextID()));
            params.addElement(new StringValue(userID));
            params.addElement(new StringValue(getSessionUser()));
            forInsert.setSQLQuery(getQuery("insertUserStatus").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();

            if (queryResult < 0) {
                connection.rollback();
                return null;
            }

        } catch (Exception ex) {
            try {
                logger.error(ex.getMessage());
                connection.rollback();
            } catch (SQLException ex1) {
                logger.error(ex1.getMessage());
            }
            return null;
        } finally {
            try {
                connection.commit();
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        return userID;
    }

    public ArrayList<WebBusinessObject> getUserList() {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> result = null;

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(sqlMgr.getSql("getUserList").trim());
            result = command.executeQuery();

            ArrayList<WebBusinessObject> users = new ArrayList<WebBusinessObject>();
            for (Row row : result) {
                users.add(fabricateBusObj(row));
            }
            return users;
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

        return new ArrayList<WebBusinessObject>();
    }

    public boolean isUserNameExist(String userName) {
        Vector userVec = new Vector();

        try {
            userVec = USER_MGR.getOnArbitraryKey(userName, "key1");
        } catch (Exception ex) {
            logger.error(ex.getMessage());
        }

        return (userVec.size() > 0);
    }

    private void setSessionUser(HttpSession s) {
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        //waUser.printSelf();
        sessionUserId = (String) waUser.getAttribute("userId");
    }

    private String getSessionUser() {
        return sessionUserId;
    }

    private void setUserID() {
        generatedUserId = UniqueIDGen.getNextID();
    }

    private String getUserID() {
        return generatedUserId;
    }

    private boolean createUserHomeDir() {

        String userHome = this.webInfPath + "/usr/" + "u" + this.getUserID() + "/";
        File homeDir = new File(userHome);
        return homeDir.mkdir();

    }

    private boolean createUserImageDir() {

        String path = imageDirPath + "/" + "u" + this.getUserID();
        File imageDir = new File(path);

        return imageDir.mkdir();
    }

    private Vector<WebBusinessObject> getActualGroups(String[] realIndex, String[] list) {
        Vector<WebBusinessObject> resault = new Vector<WebBusinessObject>();
        GroupMgr groupMgr = GroupMgr.getInstance();
        int index;
        try {
            for (int i = 0; i < realIndex.length; i++) {
                index = Integer.valueOf(realIndex[i]).intValue();
                resault.addElement(groupMgr.getOnSingleKey(list[index]));
            }

        } catch (Exception ex) {
            logger.error(ex.getMessage());
        }

        return resault;
    }

    public String getIsSuperUser(String userId) {
        try {
            return USER_MGR.getOnSingleKey(userId).getAttribute("isSuperUser").toString();
        } catch (Exception ex) {
        }
        return "0";
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
    
    public Vector getAllEmps() throws SQLException {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        String query = null;
        Vector queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();

        query = sqlMgr.getSql("getAllEmps").trim();

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

    public ArrayList<WebBusinessObject> getManagers() {
        ArrayList<WebBusinessObject> arrayOfManagers = new ArrayList<WebBusinessObject>();
        Connection connection = null;
        String query = null;
        Vector<Row> queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();

        query = sqlMgr.getSql("getAllManagers").trim();
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
            try {
                connection.close();
            } catch (SQLException ex) {
                Logger.getLogger(UserMgr.class.getName()).log(Level.SEVERE, null, ex);
            }

        }

        for (Row r : queryResult) {
            WebBusinessObject temp = new WebBusinessObject();
            try {
                temp.setAttribute("userid", r.getString("USER_ID"));
                temp.setAttribute("username", r.getString("USER_NAME"));
                temp.setAttribute("managerCount", r.getString("managerCount"));
                arrayOfManagers.add(temp);
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(AllMaintenanceInfoMgr.class.getName()).log(Level.SEVERE, null, ex);
            }

        }
        return arrayOfManagers;
    }

    public Vector getSalesManagerUsers() throws SQLException {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        String query = null;
        Vector<Row> queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();

        query = sqlMgr.getSql("getSalesManagerUsers").trim();
//        query = query.replaceAll("username", username);

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

//        Row r = null;
//        Enumeration e = queryResult.elements();
        Vector data = new Vector();
        for (Row r : queryResult) {
            WebBusinessObject temp = new WebBusinessObject();
            try {
                temp.setAttribute("groupName", r.getString("GROUP_NAME"));
                temp.setAttribute("username", r.getString("USER_NAME"));
//                temp.setAttribute("creationTime", r.getString("CREATION_TIME"));
                temp.setAttribute("email", r.getString("EMAIL"));
                temp.setAttribute("fullname", r.getString("FULL_NAME"));
                data.add(temp);
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(AllMaintenanceInfoMgr.class.getName()).log(Level.SEVERE, null, ex);
            }

        }
        return data;

    }

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
    }

    public String getFullName(String userId) {
        WebBusinessObject user = USER_MGR.getOnSingleKey(userId);

        try {
            return (String) user.getAttribute("fullName");
        } catch (Exception ex) {
            logger.error(ex.getMessage());
            return null;
        }
    }

    public boolean getAction(String prvlgName, String userId, String compId, String statusCode) {
        try {
            return getPrvlg(prvlgName, userId, compId, statusCode);
        } catch (SQLException ex) {
            Logger.getLogger(UserMgr.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        }

    }

    public boolean getAction(String prvlgName, String userId) {
        try {
            return getPrvlg(prvlgName, userId);
        } catch (SQLException ex) {
            Logger.getLogger(UserMgr.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        }

    }

    public boolean getAction(String prvlgName, String userId, String statusCode) {
        try {
            return getPrvlg(prvlgName, userId, statusCode);
        } catch (SQLException ex) {
            Logger.getLogger(UserMgr.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        }

    }

    private boolean getPrvlg(String prvlgName, String userId, String compId, String statusCode) throws SQLException {

        UserStoresMgr userStoresMgr = UserStoresMgr.getInstance();
        GroupPrevMgr groupPrevMgr = GroupPrevMgr.getInstance();
        Vector groupPrev = new Vector();
        String originalUserId = null;
        String ownerId = null;
//        String dd = (String) userWbo.getAttribute("groupID");
//        groupPrev = groupPrevMgr.getOnArbitraryKey(userWbo.getAttribute("groupID").toString(), "key1");
        ClientComplaintsMgr complaintsMgr = ClientComplaintsMgr.getInstance();
        WebBusinessObject wbo = new WebBusinessObject();
        try {
            wbo = complaintsMgr.getOriginalOwner(compId);

            originalUserId = (String) wbo.getAttribute("userId");
            wbo = new WebBusinessObject();
            wbo = complaintsMgr.getCurrentOwner(compId);
            ownerId = (String) wbo.getAttribute("userId");
        } catch (NoSuchColumnException ex) {
            Logger.getLogger(UserMgr.class.getName()).log(Level.SEVERE, null, ex);
        }
        Vector userPrev = new Vector();
        try {
            userPrev = userStoresMgr.getOnArbitraryKey(userId, "key1");
        } catch (Exception ex) {
            Logger.getLogger(UserMgr.class.getName()).log(Level.SEVERE, null, ex);
        }
        UserPrev userPrevObj = new UserPrev();
        WebBusinessObject userPrevWbo = null;
//        userPrevObj.setUserId(userWbo.getAttribute("userId").toString());
//        if (groupPrev.size() > 0) {
//            for (int x = 0; x < groupPrev.size(); x++) {
//                userPrevWbo = new WebBusinessObject();
//                userPrevWbo = (WebBusinessObject) groupPrev.get(x);
//                if (userPrevWbo.getAttribute("prevCode").equals("COMMENT")) {
//                    userPrevObj.setComment(true);
//                } else if (userPrevWbo.getAttribute("prevCode").equals("FORWARD")) {
//                    userPrevObj.setForward(true);
//                } else if (userPrevWbo.getAttribute("prevCode").equals("CLOSE")) {
//                    userPrevObj.setClose(true);
//                } else if (userPrevWbo.getAttribute("prevCode").equals("FINISHED")) {
//                    userPrevObj.setFinish(true);
//                } else if (userPrevWbo.getAttribute("prevCode").equals("BOOKMARK")) {
//                    userPrevObj.setBookmark(true);
//                }
//            }
//        } else {
//        for (int x = 0; x < userPrev.size(); x++) {
        userPrevWbo = new WebBusinessObject();

        if (prvlgName.equals("COMMENT")) {
            userPrevObj.setComment(true);
            return true;
        } else if (prvlgName.equals("FORWARD") & (userId.equals(originalUserId))) {
            userPrevObj.setForward(true);
            return true;
        } else if ((prvlgName.equals("CLOSE")) & (userId.equals(originalUserId))) {
            userPrevObj.setClose(true);
            return true;
        } else if (prvlgName.equals("FINISHED") & (userId.equals(ownerId)) & (!userId.equals(originalUserId))) {
            userPrevObj.setFinish(true);
            return true;
        } else if (prvlgName.equals("BOOKMARK")) {
            userPrevObj.setBookmark(true);
            return true;
        } else if (prvlgName.equals("ASSIGN")) {
            userPrevObj.setBookmark(true);
            return true;
        } else {
            return false;
        }
//        }
//        }

    }

    private boolean getPrvlg(String prvlgName, String userId) throws SQLException {

        UserStoresMgr userStoresMgr = UserStoresMgr.getInstance();
        GroupPrevMgr groupPrevMgr = GroupPrevMgr.getInstance();
        Vector groupPrev = new Vector();
        String originalUserId = null;
        String ownerId = null;
//        String dd = (String) userWbo.getAttribute("groupID");
//        groupPrev = groupPrevMgr.getOnArbitraryKey(userWbo.getAttribute("groupID").toString(), "key1");
        ClientComplaintsMgr complaintsMgr = ClientComplaintsMgr.getInstance();
        WebBusinessObject wbo = new WebBusinessObject();

//            wbo = complaintsMgr.getOriginalOwner(compId);
        originalUserId = (String) wbo.getAttribute("userId");
        wbo = new WebBusinessObject();
//            wbo = complaintsMgr.getCurrentOwner(compId);
        ownerId = (String) wbo.getAttribute("userId");

        Vector userPrev = new Vector();
        try {
            userPrev = userStoresMgr.getOnArbitraryKey(userId, "key1");
        } catch (Exception ex) {
            Logger.getLogger(UserMgr.class.getName()).log(Level.SEVERE, null, ex);
        }
        UserPrev userPrevObj = new UserPrev();
        WebBusinessObject userPrevWbo = null;

        userPrevWbo = new WebBusinessObject();

        if (prvlgName.equals("COMMENT")) {
            userPrevObj.setComment(true);
            return true;
        } else if (prvlgName.equals("FORWARD")) {
            userPrevObj.setForward(true);
            return true;
        } else if ((prvlgName.equals("CLOSE"))) {
            userPrevObj.setClose(true);
            return true;
        } else if (prvlgName.equals("FINISHED")) {
            userPrevObj.setFinish(true);
            return true;
        } else if (prvlgName.equals("BOOKMARK")) {
            userPrevObj.setBookmark(true);
            return true;
        } else if (prvlgName.equals("ASSIGN")) {
            userPrevObj.setBookmark(true);
            return true;
        } else {
            return false;
        }
//        }
//        }

    }

    private boolean getPrvlg(String prvlgName, String userId, String statusCode) throws SQLException {

        UserStoresMgr userStoresMgr = UserStoresMgr.getInstance();
        GroupPrevMgr groupPrevMgr = GroupPrevMgr.getInstance();
        Vector groupPrev = new Vector();
        String originalUserId = null;
        String ownerId = null;
//        String dd = (String) userWbo.getAttribute("groupID");
//        groupPrev = groupPrevMgr.getOnArbitraryKey(userWbo.getAttribute("groupID").toString(), "key1");
        ClientComplaintsMgr complaintsMgr = ClientComplaintsMgr.getInstance();
        WebBusinessObject wbo = new WebBusinessObject();

//            wbo = complaintsMgr.getOriginalOwner(compId);
        originalUserId = (String) wbo.getAttribute("userId");
        wbo = new WebBusinessObject();
//            wbo = complaintsMgr.getCurrentOwner(compId);
        ownerId = (String) wbo.getAttribute("userId");

        Vector userPrev = new Vector();
        try {
            userPrev = userStoresMgr.getOnArbitraryKey(userId, "key1");
        } catch (Exception ex) {
            Logger.getLogger(UserMgr.class.getName()).log(Level.SEVERE, null, ex);
        }
        UserPrev userPrevObj = new UserPrev();
        WebBusinessObject userPrevWbo = null;

        userPrevWbo = new WebBusinessObject();

        if (prvlgName.equals("COMMENT")) {
            userPrevObj.setComment(true);
            return true;
        } else if (prvlgName.equals("FORWARD") & !statusCode.equals("4")) {
            userPrevObj.setForward(true);
            return true;
        } else if ((prvlgName.equals("CLOSE") & !statusCode.equals("7"))) {
            userPrevObj.setClose(true);
            return true;
        } else if (prvlgName.equals("FINISHED") & !statusCode.equals("6")) {
            userPrevObj.setFinish(true);
            return true;
        } else if (prvlgName.equals("BOOKMARK")) {
            userPrevObj.setBookmark(true);
            return true;
        } else if (prvlgName.equals("ASSIGN") & !statusCode.equals("4")) {
            userPrevObj.setBookmark(true);
            return true;
        } else {
            return false;
        }
//        }
//        }

    }

    public boolean getAction2(String prvlgName, String userId) {
        try {
            return getPrvlg2(prvlgName, userId);
        } catch (SQLException ex) {
            Logger.getLogger(UserMgr.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        }

    }

    private boolean getPrvlg2(String prvlgName, String userId) throws SQLException {

        UserStoresMgr userStoresMgr = UserStoresMgr.getInstance();
        GroupPrevMgr groupPrevMgr = GroupPrevMgr.getInstance();
        Vector groupPrev = new Vector();
        String originalUserId = null;
        String ownerId = null;
//        String dd = (String) userWbo.getAttribute("groupID");
//        groupPrev = groupPrevMgr.getOnArbitraryKey(userWbo.getAttribute("groupID").toString(), "key1");
        ClientComplaintsMgr complaintsMgr = ClientComplaintsMgr.getInstance();
        WebBusinessObject wbo = new WebBusinessObject();

//            wbo = complaintsMgr.getOriginalOwner(compId);
//        originalUserId = (String) wbo.getAttribute("userId");
////            wbo = new WebBusinessObject();
////            wbo = complaintsMgr.getCurrentOwner(compId);
//        ownerId = (String) wbo.getAttribute("userId");
        Vector userPrev = new Vector();
        try {
            userPrev = userStoresMgr.getOnArbitraryKey(userId, "key1");
        } catch (Exception ex) {
            Logger.getLogger(UserMgr.class.getName()).log(Level.SEVERE, null, ex);
        }
        UserPrev userPrevObj = new UserPrev();
        WebBusinessObject userPrevWbo = null;

        userPrevWbo = new WebBusinessObject();

        if (prvlgName.equals("attached file")) {
            userPrevObj.setComment(true);
            return true;
        } else if (prvlgName.equals("email")) {
            userPrevObj.setForward(true);
            return true;
        } else if ((prvlgName.equals("sms"))) {
            userPrevObj.setClose(true);
            return true;
        } else if (prvlgName.equals("pointment")) {
            userPrevObj.setFinish(true);
            return true;
        } else if (prvlgName.equals("comment")) {
            userPrevObj.setBookmark(true);
            return true;
        } else if (prvlgName.equals("financial")) {
            userPrevObj.setBookmark(true);
            return true;
        } else {
            return false;
        }
//        }
//        }

    }

    // button security 
    public void userPrevClient(HttpServletRequest request, HttpServletResponse response) {
        try {
            SecurityUser securityUser = (SecurityUser) request.getSession().getAttribute("securityUser");
            WebBusinessObject waUser = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
            String userId = (String) waUser.getAttribute("userId");
            ArrayList userPrev = new ArrayList();
            UserStoresMgr userStoresMgr = UserStoresMgr.getInstance();

            userPrev = userStoresMgr.getUserPrivligesByType("2", userId);

            UserGroupMgr userGroupMgr = UserGroupMgr.getInstance();
            WebBusinessObject wbo = new WebBusinessObject();
            wbo = userGroupMgr.getOnSingleKey("key6", userId);
            String groupId = (String) wbo.getAttribute("groupID");
            ArrayList groupPrv = new ArrayList();
            GroupPrevMgr groupPrevMgr = GroupPrevMgr.getInstance();
            groupPrv = groupPrevMgr.getGroupPrivligesByType("2", groupId);
            if (userPrev.isEmpty() || userPrev.size() <= 0) {
                securityUser.setClientMenuBtn(groupPrv);
            } else {
                securityUser.setClientMenuBtn(userPrev);
            }
        } catch (SQLException ex) {
            Logger.getLogger(TrackerLoginServlet.class.getName()).log(Level.SEVERE, null, ex);
        } catch (Exception ex) {
            Logger.getLogger(TrackerLoginServlet.class.getName()).log(Level.SEVERE, null, ex);
        }

    }

    // get user prev type 1 (complaint)
    public void userPrevComplaint(HttpServletRequest request, HttpServletResponse response) {
        try {
            SecurityUser securityUser = (SecurityUser) request.getSession().getAttribute("securityUser");
            WebBusinessObject waUser = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
            String userId = (String) waUser.getAttribute("userId");
            ArrayList userPrevList = new ArrayList();
            UserStoresMgr userStoresMgr = UserStoresMgr.getInstance();

//            userPrev = userStoresMgr.getUserPrivligesByType("1", userId);
            UserGroupMgr userGroupMgr = UserGroupMgr.getInstance();
            ArrayList<WebBusinessObject> userGroupList = userGroupMgr.getOnArbitraryKey2(userId, "key6");
            securityUser.setComplaintMenuBtn(new ArrayList<WebBusinessObject>());
            for (WebBusinessObject wbo : userGroupList) {
                String groupId = (String) wbo.getAttribute("groupID");
                ArrayList<WebBusinessObject> groupPrvList = new ArrayList();
                GroupPrevMgr groupPrevMgr = GroupPrevMgr.getInstance();
                groupPrvList = groupPrevMgr.getOnArbitraryKey2(groupId, "key1");//GroupPrivligesByType("1", groupId);
                ArrayList<WebBusinessObject> existsPrev = securityUser.getComplaintMenuBtn();
                for (WebBusinessObject groupPrv : groupPrvList) {
                    boolean exists = false;
                    for (WebBusinessObject existWbo : existsPrev) {
                        if (((String) existWbo.getAttribute("prevCode")).equals((String) groupPrv.getAttribute("prevCode"))) {
                            exists = true;
                            break;
                        }
                    }
                    if (!exists) {
                        existsPrev.add(groupPrv);
                    }
                }
            }
//        } catch (SQLException ex) {
//            Logger.getLogger(TrackerLoginServlet.class.getName()).log(Level.SEVERE, null, ex);
        } catch (Exception ex) {
            Logger.getLogger(TrackerLoginServlet.class.getName()).log(Level.SEVERE, null, ex);
        }

    }
    // end button security

    public void setLastLogin(HttpServletRequest request, HttpServletResponse response) throws SQLException {
        WebBusinessObject waUser = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
        SecurityUser securityUser = (SecurityUser) request.getSession().getAttribute("securityUser");
        String userId = (String) waUser.getAttribute("userId");
        Connection connection = null;
        String query = null;
        WebBusinessObject wbo = new WebBusinessObject();
        wbo = totalTicketsMgr.getOnSingleKey(userId);
        String lastLogin = (String) wbo.getAttribute("lastLogin");
        securityUser.setLoginDate(lastLogin);
        Vector queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        queryResult.addElement(new StringValue(userId));
        query = sqlMgr.getSql("updateLastLogin").trim();
        int result = 0;

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            forQuery.setparams(queryResult);
            result = forQuery.executeUpdate();
            if (result < 0) {
                connection.rollback();
            }
        } catch (Exception ex) {
            logger.error("SQL Exception  " + ex.getMessage());

        } finally {

            connection.close();

        }

    }

    public boolean isUserNameExist(String userId, String userName) {
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;
        Vector queryResult = null;
        Vector parameters = new Vector();

        parameters.addElement(new StringValue(userId));
        parameters.addElement(new StringValue(userName));

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("isUserNameExist").trim());
            forQuery.setparams(parameters);

            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }

        return ((queryResult != null) && !queryResult.isEmpty());
    }

    public ArrayList<WebBusinessObject> getUsersLike(String value) throws SQLException {
        Connection connection = null;
        String query = getQuery("searchUsersLike").trim();
        Vector<Row> queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.replaceFirst("userName", value));
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            connection.close();
        }
        ArrayList<WebBusinessObject> data = new ArrayList<WebBusinessObject>();
        for (Row r : queryResult) {
            WebBusinessObject temp = fabricateBusObj(r);
            data.add(temp);
        }
        return data;
    }

    public List<WebBusinessObject> getUsersByProjectAndGroup(String projectId, String groupId) throws SQLException {
        Connection connection = null;
        Vector<Row> queryResult = new Vector();
        SQLCommandBean command = new SQLCommandBean();
        Vector parameters = new Vector();

        parameters.addElement(new StringValue(projectId));
        parameters.addElement(new StringValue(groupId));
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setparams(parameters);
            command.setSQLQuery(getQuery("getUsersByProjectAndGroup").trim());
            queryResult = command.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            connection.close();
        }
        List<WebBusinessObject> users = new ArrayList<WebBusinessObject>();
        for (Row r : queryResult) {
            WebBusinessObject temp = fabricateBusObj(r);
            users.add(temp);
        }
        return users;
    }

    public List<WebBusinessObject> getUsersByGroup(String groupId) throws SQLException {
        Connection connection = null;
        Vector<Row> queryResult = new Vector();
        SQLCommandBean command = new SQLCommandBean();
        Vector parameters = new Vector();

        parameters.addElement(new StringValue(groupId));
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setparams(parameters);
            command.setSQLQuery(getQuery("getUsersByGroup").trim());
            queryResult = command.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            connection.close();
        }
        List<WebBusinessObject> users = new ArrayList<WebBusinessObject>();
        for (Row r : queryResult) {
            WebBusinessObject temp = fabricateBusObj(r);
            users.add(temp);
        }
        return users;
    }
    
    
    public List<WebBusinessObject> getUsersByGroup2(String groupId) throws SQLException {
        Connection connection = null;
        Vector<Row> queryResult = new Vector();
        SQLCommandBean command = new SQLCommandBean();
        Vector parameters =  new Vector();

        parameters.addElement(new StringValue(groupId));
        //SimpleDateFormat in = new SimpleDateFormat("E MMM dd");
        Date fromDateD,toDateD;
        
        //parameters.addElement(new StringValue(fromDate));
        //parameters.addElement(new StringValue(toDate));
        
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setparams(parameters);
            command.setSQLQuery(getQuery("getUsersByGroup2").trim());
            queryResult = command.executeQuery();
        } catch (Exception ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } finally {
            connection.close();
        }
        List<WebBusinessObject> users = new ArrayList<WebBusinessObject>();
        for (Row r : queryResult) {
            WebBusinessObject temp = fabricateBusObj(r);
            users.add(temp);
        }
        return users;
    }

    public ArrayList<WebBusinessObject> getUserWithoutManagers() {
        ArrayList<WebBusinessObject> arrayOfUsers = new ArrayList<WebBusinessObject>();
        Connection connection = null;
        String query;
        Vector<Row> queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        query = getQuery("getUsersWithoutManagers").trim();
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
            try {
                connection.close();
            } catch (SQLException ex) {
                Logger.getLogger(UserMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        for (Row r : queryResult) {
            arrayOfUsers.add(fabricateBusObj(r));
        }
        return arrayOfUsers;
    }

    public Vector getUserWithStatus(String userStatus) {
        Vector arrayOfUsers = new Vector();
        Connection connection = null;
        String query;
        StringBuilder where = new StringBuilder();
        if(null != userStatus) switch (userStatus) {
            case "active":
                where.append(" AND i.STATUS_NAME = '21'");
                break;
            case "inactive":
                where.append(" AND (i.STATUS_NAME <> '21' or i.STATUS_NAME is null)");
                break;
        }
        Vector<Row> queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        query = getQuery("selectUsersWithRowNoAndStatus").trim();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query + where.toString());
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                Logger.getLogger(UserMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        WebBusinessObject wbo;
        for (Row r : queryResult) {
            try {
                wbo = fabricateBusObj(r);
                if (r.getString("STATUS_NAME") != null) {
                    wbo.setAttribute("statusCode", r.getString("STATUS_NAME"));
                }
                arrayOfUsers.add(wbo);
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(UserMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return arrayOfUsers;
    }

    public ArrayList<WebBusinessObject> getEmployeeByDepartmentId(String departmentId, String fromDate, String toDate) {
        SQLCommandBean command = new SQLCommandBean();
        Connection  connection = null;
        Vector parameters = new Vector();
        Vector<Row> result = new Vector();
        ArrayList<WebBusinessObject> list = new ArrayList();
        StringBuilder dateCon = new StringBuilder();
        
//        parameters.add(new StringValue(departmentId));
//        parameters.add(new StringValue(departmentId));
        
        if(fromDate != null){
            dateCon.append("and TRUNC(CREATION_TIME) >= to_date(?,'yyyy/mm/dd')");
            parameters.addElement(new StringValue(fromDate));
        }
        if(toDate != null){
            dateCon.append("and TRUNC(CREATION_TIME) <= to_date(?,'yyyy/mm/dd')");
            parameters.addElement(new StringValue(toDate));
        }
        if (departmentId == null) {
            departmentId = "";
        } else if (!departmentId.contains("'")) {
            departmentId = "\'" + departmentId + "\'";
        }

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setparams(parameters);
            command.setSQLQuery(getQuery("getEmployeeByDepartmentId").replaceAll("departmentID", departmentId).trim()
                    + dateCon.toString());
            result = command.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("***** " + ex.getMessage());
            }
        }

        for (Row row : result) {
            list.add(fabricateBusObj(row));
        }
        return list;
    }

    public String getIsManager(String userId) {
        try {
            return USER_MGR.getOnSingleKey(userId).getAttribute("userType").toString();
        } catch (Exception ex) {
        }
        return "0";
    }

    public List<WebBusinessObject> getAllEngineers() {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> result = new Vector();
        List<WebBusinessObject> list = new ArrayList();
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getAllEngineers").trim());
            result = command.executeQuery();
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
                logger.error("***** " + ex.getMessage());
            }
        }
        for (Row row : result) {
            list.add(fabricateBusObj(row));
        }
        return list;
    }

    private boolean editUserNameWithinOtherTables(WebBusinessObject userWbo) throws NoUserInSessionException {
        Vector params = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        params.addElement(new StringValue((String) userWbo.getAttribute("userName")));
        params.addElement(new StringValue((String) userWbo.getAttribute("userId")));
        try {
            // Update user name in table DOCUMENT
            forUpdate.setConnection(transConnection);
            forUpdate.setSQLQuery(getQuery("updateUserNameInDocument").trim());
            forUpdate.setparams(params);
            forUpdate.executeUpdate();
            // Update user name in table EMPLYEE_DOC
            forUpdate = new SQLCommandBean();
            forUpdate.setConnection(transConnection);
            forUpdate.setSQLQuery(getQuery("updateUserNameInEmployeeDoc").trim());
            forUpdate.setparams(params);
            forUpdate.executeUpdate();
            // Update user name in table ISSUE_DOCUMENT
            forUpdate = new SQLCommandBean();
            forUpdate.setConnection(transConnection);
            forUpdate.setSQLQuery(getQuery("updateUserNameInIssueDocument").trim());
            forUpdate.setparams(params);
            forUpdate.executeUpdate();
            // Update user name in table MNTNBLE_UNIT_DOC
            forUpdate = new SQLCommandBean();
            forUpdate.setConnection(transConnection);
            forUpdate.setSQLQuery(getQuery("updateUserNameInMntnbleUnitDoc").trim());
            forUpdate.setparams(params);
            forUpdate.executeUpdate();
            // Update user name in table WF_TASK_DOC
            forUpdate = new SQLCommandBean();
            forUpdate.setConnection(transConnection);
            forUpdate.setSQLQuery(getQuery("updateUserNameInWfTaskDoc").trim());
            forUpdate.setparams(params);
            forUpdate.executeUpdate();
            // Update user name in table USER_TRADE
            forUpdate = new SQLCommandBean();
            forUpdate.setConnection(transConnection);
            forUpdate.setSQLQuery(getQuery("updateUserNameInUserTrade").trim());
            forUpdate.setparams(params);
            forUpdate.executeUpdate();
            // Update user name in table CLIENT_COMPLAINTS
            forUpdate = new SQLCommandBean();
            forUpdate.setConnection(transConnection);
            forUpdate.setSQLQuery(getQuery("updateUserNameInClientComplaints").trim());
            forUpdate.setparams(params);
            forUpdate.executeUpdate();
            try {
                Thread.sleep(200);
            } catch (InterruptedException ex) {
                logger.error(ex.getMessage());
            }
        } catch (SQLException se) {
            System.out.println(se.getMessage());
            return false;
        }
        return true;
    }

    public WebBusinessObject getManagerByEmployeeID(String userCode) {
        WebBusinessObject wbo = null;
        Connection connection = null;
        Vector SQLparams = new Vector();
        Vector queryResult = null;

        SQLCommandBean forQuery = new SQLCommandBean();
        SQLparams.addElement(new StringValue(userCode));
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getManagerByEmployee").trim());
            forQuery.setparams(SQLparams);
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

//        ArrayList resultBusObjs = new ArrayList();
        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
//            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
        }
        return wbo;
    }
    
    
    
    

    public ArrayList<WebBusinessObject> getEmployeesByDepartmentCode(String departmentCode) {
        WebBusinessObject wbo;
        Connection connection = null;
        Vector SQLparams = new Vector();
        Vector queryResult = null;

        SQLCommandBean forQuery = new SQLCommandBean();
        SQLparams.addElement(new StringValue(departmentCode));
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getEmployeesByDepartmentCode").trim());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        ArrayList resultBusObjs = new ArrayList();
        Row r;
        if (queryResult != null) {
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = fabricateBusObj(r);
                resultBusObjs.add(wbo);
            }
        }
        return resultBusObjs;
    }

    public ArrayList<WebBusinessObject> getAllTechnicians() {
        WebBusinessObject wbo;
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getAllTechnicians").trim());
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        ArrayList resultBusObjs = new ArrayList();
        Row r;
        if (queryResult != null) {
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = fabricateBusObj(r);
                resultBusObjs.add(wbo);
            }
        }
        return resultBusObjs;
    }

    public ArrayList<WebBusinessObject> getAllActiveUsers() {
        WebBusinessObject wbo;
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getAllActiveUsers").trim());
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }
        ArrayList resultBusObjs = new ArrayList();
        Row r;
        if (queryResult != null) {
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = fabricateBusObj(r);
                resultBusObjs.add(wbo);
            }
        }
        return resultBusObjs;
    }

    public ArrayList<WebBusinessObject> getEmployeesByManager(String managerID) {
        Connection connection = null;
        Vector queryResult = null;
        Vector params = new Vector();
        params.addElement(new StringValue(managerID));
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getEmployeesByManager").trim());
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }
        ArrayList results = new ArrayList();
        Row r;
        if (queryResult != null) {
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                results.add(fabricateBusObj(r));
            }
        }
        return results;
    }

    public ArrayList<WebBusinessObject> getAllUpperManagers() {
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getAllUpperManagers").trim());
            queryResult = forQuery.executeQuery();
        } catch (SQLException | UnsupportedTypeException se) {
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }
        ArrayList results = new ArrayList();
        Row r;
        if (queryResult != null) {
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                results.add(fabricateBusObj(r));
            }
        }
        return results;
    }
    
    public ArrayList<WebBusinessObject> getUsersInMyReportDepartments(String userID) {
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();
        params.addElement(new StringValue(userID));
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getUsersInMyReportDepartments").trim());
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (SQLException | UnsupportedTypeException se) {
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }
        ArrayList results = new ArrayList();
        Row r;
        if (queryResult != null) {
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                results.add(fabricateBusObj(r));
            }
        }
        return results;
    }
    
    public List<WebBusinessObject> getUsersByGroupAndBranch(String groupID, String[] branchID) throws SQLException {
        Connection connection = null;
        Vector<Row> queryResult = new Vector();
        SQLCommandBean command = new SQLCommandBean();
        Vector parameters = new Vector();

	StringBuilder prjID = new StringBuilder();
	
        parameters.addElement(new StringValue(groupID));
	
	prjID.append(" IN ( ");
	
	for (int i = 0; i < branchID.length; i++) {
	    prjID.append(branchID[i]);
	    
	    if(i < branchID.length-1){
		prjID.append(", ");
	    }
	}
        
	prjID.append(" ) ");
	
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setparams(parameters);
            command.setSQLQuery(getQuery("getUsersByGroupAndBranch").replaceAll("prjID", prjID.toString()).trim());
            queryResult = command.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            connection.close();
        }
        List<WebBusinessObject> users = new ArrayList<WebBusinessObject>();
        for (Row r : queryResult) {
            WebBusinessObject temp = fabricateBusObj(r);
            users.add(temp);
        }
        return users;
    }
    
    public List<WebBusinessObject> getUsersByBranch(String branchID) throws SQLException {
        Connection connection = null;
        Vector<Row> queryResult = new Vector();
        SQLCommandBean command = new SQLCommandBean();
        Vector parameters = new Vector();

        parameters.addElement(new StringValue(branchID));
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setparams(parameters);
            command.setSQLQuery(getQuery("getUsersByBranch").trim());
            queryResult = command.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            connection.close();
        }
        List<WebBusinessObject> users = new ArrayList<WebBusinessObject>();
        for (Row r : queryResult) {
            WebBusinessObject temp = fabricateBusObj(r);
            users.add(temp);
        }
        return users;
    }
    
    public ArrayList<WebBusinessObject> getAllDistributionUsers(String userID) {
        Connection connection = null;
        Vector<Row> queryResult = new Vector();
        SQLCommandBean command = new SQLCommandBean();
        Vector parameters = new Vector();
        parameters.addElement(new StringValue(userID));
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setparams(parameters);
            command.setSQLQuery(getQuery("getAllDistributionUsers").trim());
            queryResult = command.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                Logger.getLogger(UserMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        ArrayList<WebBusinessObject> users = new ArrayList<>();
        WebBusinessObject wbo;
        for (Row r : queryResult) {
            wbo = fabricateBusObj(r);
            users.add(wbo);
        }
        return users;
    }
    
    public WebBusinessObject getConsolidatedActivities(String userID, java.sql.Date inDate) {
        WebBusinessObject wbo = new WebBusinessObject();
        Row r;
        Enumeration e;
        Connection connection = null;
        Vector SQLparams = new Vector();
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        SQLparams.addElement(new StringValue(userID));
        SQLparams.addElement(new DateValue(inDate));
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            // for Comments
            forQuery.setSQLQuery(getQuery("getUserCommentsCount").trim());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
            e = queryResult.elements();
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                if(r.getString("COMMENTS_COUNT") != null) {
                    wbo.setAttribute("commentsCount", r.getString("COMMENTS_COUNT"));
                }
            }
            // for Calls
            forQuery.setSQLQuery(getQuery("getUserCallsCount").trim());
            queryResult = forQuery.executeQuery();
            e = queryResult.elements();
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                if(r.getString("CALLS_COUNT") != null) {
                    wbo.setAttribute("callsCount", r.getString("CALLS_COUNT"));
                }
            }
            // for Answered Calls
            forQuery.setSQLQuery(getQuery("getUserAnsweredCallsCount").trim());
            queryResult = forQuery.executeQuery();
            e = queryResult.elements();
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                if(r.getString("CALLS_COUNT") != null) {
                    wbo.setAttribute("answeredCallsCount", r.getString("CALLS_COUNT"));
                }
            }
            // for Not Answered Calls
            forQuery.setSQLQuery(getQuery("getUserNotAnsweredCallsCount").trim());
            queryResult = forQuery.executeQuery();
            e = queryResult.elements();
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                if(r.getString("CALLS_COUNT") != null) {
                    wbo.setAttribute("notAnsweredCallsCount", r.getString("CALLS_COUNT"));
                }
            }
            // for Meetings
            forQuery.setSQLQuery(getQuery("getUserMeetingsCount").trim());
            queryResult = forQuery.executeQuery();
            e = queryResult.elements();
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                if(r.getString("MEETINGS_COUNT") != null) {
                    wbo.setAttribute("meetingsCount", r.getString("MEETINGS_COUNT"));
                }
            }
            // for Attended Meetings
            forQuery.setSQLQuery(getQuery("getUserAttendedMeetingsCount").trim());
            queryResult = forQuery.executeQuery();
            e = queryResult.elements();
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                if(r.getString("MEETINGS_COUNT") != null) {
                    wbo.setAttribute("attendedMeetingsCount", r.getString("MEETINGS_COUNT"));
                }
            }
            // for not Attended Meetings
            forQuery.setSQLQuery(getQuery("getUserNotAttendedMeetingsCount").trim());
            queryResult = forQuery.executeQuery();
            e = queryResult.elements();
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                if(r.getString("MEETINGS_COUNT") != null) {
                    wbo.setAttribute("notAttendedMeetingsCount", r.getString("MEETINGS_COUNT"));
                }
            }
            // for Closure
            forQuery.setSQLQuery(getQuery("getUserClosureCount").trim());
            queryResult = forQuery.executeQuery();
            e = queryResult.elements();
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                if(r.getString("CLOSURE_COUNT") != null) {
                    wbo.setAttribute("closureCount", r.getString("CLOSURE_COUNT"));
                }
            }
            // for Finish
            forQuery.setSQLQuery(getQuery("getUserFinishCount").trim());
            queryResult = forQuery.executeQuery();
            e = queryResult.elements();
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                if(r.getString("FINISH_COUNT") != null) {
                    wbo.setAttribute("finishCount", r.getString("FINISH_COUNT"));
                }
            }
            // for Emails
            forQuery.setSQLQuery(getQuery("getUserEmailsCount").trim());
            queryResult = forQuery.executeQuery();
            e = queryResult.elements();
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                if(r.getString("EMAIL_COUNT") != null) {
                    wbo.setAttribute("emailsCount", r.getString("EMAIL_COUNT"));
                }
            }
            // for Reservations
            forQuery.setSQLQuery(getQuery("getUserReservationCount").trim());
            queryResult = forQuery.executeQuery();
            e = queryResult.elements();
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                if(r.getString("RESERVATION_COUNT") != null) {
                    wbo.setAttribute("reservationCount", r.getString("RESERVATION_COUNT"));
                }
            }
            // for Reservations
            forQuery.setSQLQuery(getQuery("getClientsCount").trim());
            queryResult = forQuery.executeQuery();
            e = queryResult.elements();
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                if(r.getString("CLIENTS_COUNT") != null) {
                    wbo.setAttribute("clientsCount", r.getString("CLIENTS_COUNT"));
                }
            }
            
            // for Editing on Comments
            int appCmntCount = 0;
            SQLparams = new Vector();
            SQLparams.addElement(new StringValue(userID));
            DateFormat df = new SimpleDateFormat("dd/MM/yyyy");
            String inDateStr = df.format(inDate);
            forQuery.setparams(SQLparams);
            forQuery.setSQLQuery(getQuery("getUserEditCommentsCount").replaceAll("dateStr", inDateStr).trim());
            queryResult = forQuery.executeQuery();
            e = queryResult.elements();
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                if(r.getString("APP_COMMENTS_COUNT") != null) {
                    appCmntCount += Integer.parseInt(r.getString("APP_COMMENTS_COUNT"));
                }
            }
            wbo.setAttribute("appCmntCount", appCmntCount);
            // for Editing on Comments
            appCmntCount = 0;
            forQuery.setSQLQuery(getQuery("getUserAnsweredEditCommentsCount").replaceAll("dateStr", inDateStr).trim());
            queryResult = forQuery.executeQuery();
            e = queryResult.elements();
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                if(r.getString("APP_COMMENTS_COUNT") != null) {
                    appCmntCount += Integer.parseInt(r.getString("APP_COMMENTS_COUNT"));
                }
            }
            wbo.setAttribute("answeredAppointmentCount", appCmntCount);
            // for Editing on Comments
            appCmntCount = 0;
            forQuery.setSQLQuery(getQuery("getUserNotAnsweredEditCommentsCount").replaceAll("dateStr", inDateStr).trim());
            queryResult = forQuery.executeQuery();
            e = queryResult.elements();
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                if(r.getString("APP_COMMENTS_COUNT") != null) {
                    appCmntCount += Integer.parseInt(r.getString("APP_COMMENTS_COUNT"));
                }
            }
            wbo.setAttribute("notAnsweredAppointmentCount", appCmntCount);
        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } catch (NoSuchColumnException ex) {
            Logger.getLogger(UserMgr.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }
        return wbo;
    }
    
    
    public List<WebBusinessObject> getAllUsers() throws SQLException {
        Connection connection = null;
        Vector<Row> queryResult = new Vector();
        SQLCommandBean command = new SQLCommandBean();
        Vector parameters = new Vector();

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setparams(parameters);
            command.setSQLQuery(getQuery("getAllUsers").trim());
            queryResult = command.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            connection.close();
        }
        List<WebBusinessObject> users = new ArrayList<WebBusinessObject>();
        for (Row r : queryResult) {
            WebBusinessObject temp = fabricateBusObj(r);
            users.add(temp);
        }
        return users;
    }
    
    public Long getActiveUsersCount() throws SQLException {
        Connection connection = null;
        Vector<Row> queryResult = new Vector();
        SQLCommandBean command = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getActiveUsersCount").trim());
            queryResult = command.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            connection.close();
        }
        for (Row r : queryResult) {
            try {
                if(r.getBigDecimal("TOTAL") != null) {
                    return r.getBigDecimal("TOTAL").longValueExact();
                }
            } catch (NoSuchColumnException | UnsupportedConversionException ex) {
                Logger.getLogger(UserMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return 0L;
    }
    
    public List<WebBusinessObject> getUsersByDistributionGroup(String userID) throws SQLException {
        Connection connection = null;
        Vector<Row> queryResult = new Vector();
        SQLCommandBean command = new SQLCommandBean();
        Vector parameters = new Vector();
        parameters.addElement(new StringValue(userID));
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setparams(parameters);
            command.setSQLQuery(getQuery("getUsersByDistributionGroup").trim());
            queryResult = command.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            connection.close();
        }
        List<WebBusinessObject> users = new ArrayList<>();
        for (Row r : queryResult) {
            WebBusinessObject temp = fabricateBusObj(r);
            users.add(temp);
        }
        return users;
    }
    
    public String saveBrokerUser(HttpServletRequest request, HttpSession session) {
        Connection connection = null;
        String userID = UniqueIDGen.getNextID();
        try {
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            Vector params = new Vector();
            SQLCommandBean forInsert = new SQLCommandBean();
            int queryResult = -1000;
            // set forInsert by connection
            forInsert.setConnection(connection);
            setUserID();
            setSessionUser(session);
            String userName = (request.getParameter("fullName").split(" "))[0] + userID.substring(9);
            // saver user
            if (this.createUserHomeDir() && this.createUserImageDir()) {
                params.addElement(new StringValue(userID));
                params.addElement(new StringValue(userName));
                params.addElement(new StringValue("123"));
                params.addElement(new StringValue("u" + userID));
                params.addElement(new StringValue(getSessionUser()));
                params.addElement(new StringValue(request.getParameter("email")));
                params.addElement(new StringValue("0"));
                params.addElement(new StringValue(request.getParameter("fullName")));
                params.addElement(new StringValue(""));// Field name CAN_SEND_EMAIL
                params.addElement(new StringValue("1"));
                forInsert.setSQLQuery(sqlMgr.getSql("insertUser").trim());
                forInsert.setparams(params);
                queryResult = forInsert.executeUpdate();
                if (queryResult < 0) {
                    connection.rollback();
                    return null;
                }
            } else {
                return null;
            }
            String groupMenu;
            byte[] groupMenuByte;
            ByteArrayInputStream byteInputStream;
            // save group
            WebBusinessObject wbo = GroupMgr.getInstance().getOnSingleKey(CRMConstants.BROKER_GROUP_ID);
            queryResult = -1000;
            if (wbo != null) {
                params = new Vector();
                groupMenu = (String) wbo.getAttribute("groupMenu");
                groupMenuByte = groupMenu.getBytes();
                byteInputStream = new ByteArrayInputStream(groupMenuByte);
                params.addElement(new StringValue((String) wbo.getAttribute("groupName")));
                params.addElement(new StringValue((String) wbo.getAttribute("groupID")));
                params.addElement(new StringValue(userID));
                params.addElement(new StringValue(userName));
                params.addElement(new StringValue("u" + userID));
                params.addElement(new StringValue("123"));
                params.addElement(new StringValue(getSessionUser()));
                params.addElement(new StringValue((String) wbo.getAttribute("defaultPage")));
                params.addElement(new StringValue((String) wbo.getAttribute("defaultPage")));
                params.addElement(new StringValue(request.getParameter("email")));
                params.addElement(new StringValue(UniqueIDGen.getNextID()));
                params.addElement(new StringValue(""));
                params.addElement(new StringValue("bySite"));
                params.addElement(new ImageValue(byteInputStream, groupMenuByte.length));
                forInsert.setSQLQuery(sqlMgr.getSql("insertUserGroupByDefault").trim());
                forInsert.setparams(params);
                queryResult = forInsert.executeUpdate();
                if (queryResult < 0) {
                    connection.rollback();
                    return null;
                }
                try {
                    Thread.sleep(100);
                } catch (InterruptedException ex) {
                    logger.error(ex.getMessage());
                }
            }
            //insert total_tickets row
            forInsert.setSQLQuery(sqlMgr.getSql("insertUserTicketsCount").trim());
            int x = 0;
            params = new Vector();
            params.addElement(new StringValue(userID));
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            if (queryResult <= 0) {
                connection.rollback();
                return null;
            }
            try {
                Thread.sleep(100);
            } catch (InterruptedException ex) {
                logger.error(ex.getMessage());
            }
            //insert user status
            params = new Vector();
            params.addElement(new StringValue(UniqueIDGen.getNextID()));
            params.addElement(new StringValue(userID));
            params.addElement(new StringValue(getSessionUser()));
            forInsert.setSQLQuery(getQuery("insertUserStatus").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            if (queryResult < 0) {
                connection.rollback();
                return null;
            }
        } catch (SQLException ex) {
            try {
                logger.error(ex.getMessage());
                connection.rollback();
            } catch (SQLException ex1) {
                logger.error(ex1.getMessage());
            }
            return null;
        } finally {
            try {
                connection.commit();
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }
        return userID;
    }
    
    public Map<String, String> getUserStatusMap() {
        Connection connection = null;
        String query;
        Vector<Row> queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        query = getQuery("selectUsersWithRowNoAndStatus").trim();
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
            try {
                connection.close();
            } catch (SQLException ex) {
                Logger.getLogger(UserMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        Map<String, String> statusMap = new HashMap<>();
        for (Row r : queryResult) {
            try {
                if (r.getString("STATUS_NAME") != null) {
                    statusMap.put(r.getString("USER_ID"), r.getString("STATUS_NAME"));
                }
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(UserMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return statusMap;
    }
    
    public ArrayList<WebBusinessObject> getUsersManager() throws SQLException {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> rows;
        WebBusinessObject wbo;
        ArrayList<WebBusinessObject> results = new ArrayList<>();
                
        String query = new String();
        query = getQuery("getUserMgrSales").trim();
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(query);
            rows = command.executeQuery();
            for (Row row : rows) { 
                wbo = fabricateBusObj(row);
                
                if(row.getString("user_id") != null) {
                    wbo.setAttribute("user_id", row.getString("user_id"));
                }  
                if(row.getString("user_name") != null) {
                    wbo.setAttribute("user_name", row.getString("user_name"));
                }  
                results.add(wbo);
            }
        } catch (SQLException | UnsupportedTypeException | NoSuchColumnException ex) {
            Logger.getLogger("fahd");
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error("Close Error " + ex.getMessage());
            }
        }
        
        return results;
    }
}
