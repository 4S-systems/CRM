package com.silkworm.servlets;

import com.android.common.LiteMetaDataMgr;
import com.maintenance.common.DateParser;
import com.maintenance.common.ParseSideMenu;
import com.maintenance.common.Store;
import com.maintenance.common.Tools;
import com.maintenance.db_access.TradeTempMgr;
import com.maintenance.db_access.UserCompaniesMgr;
import com.maintenance.db_access.UserProjectsMgr;
import com.maintenance.db_access.UserStoresMgr;
import com.tracker.db_access.ProjectMgr;
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.silkworm.common.*;
import java.util.*;
import java.sql.*;
import com.silkworm.util.*;
import com.silkworm.business_objects.*;
import com.silkworm.business_objects.secure_menu.*;
import com.maintenance.db_access.UserTradeMgr;
import com.silkworm.common.SecurityUser;
import com.silkworm.common.ApplicationSessionRegistery;
import com.silkworm.db_access.CustomizationPanelMgr;
import com.silkworm.db_access.GrantUserMgr;
import com.silkworm.db_access.LoginInformationMgr;
import com.tracker.db_access.TotalTicketsMgr;
import java.util.ArrayList;
import org.apache.log4j.Logger;
import com.silkworm.db_access.PersistentSessionMgr;

// draw from this servlet to keep the generic nature
public abstract class LoginServlet extends swBaseServlet {

    private final UserMgr userMgr = UserMgr.getInstance();
    private final UserGroupMgr userGroupMgr = UserGroupMgr.getInstance();
    private final UserTradeMgr userTradeMgr = UserTradeMgr.getInstance();
    private final ProjectMgr projectMgr = ProjectMgr.getInstance();
    private final GrantUserMgr grantUserMgr = GrantUserMgr.getInstance();
    private final UserStoresMgr userStoresMgr = UserStoresMgr.getInstance();
    private final UserProjectsMgr userProjectsMgr = UserProjectsMgr.getInstance();
    private final TotalTicketsMgr totalTicketsMgr = TotalTicketsMgr.getInstance();
    private final CustomizationPanelMgr customizationMgr = CustomizationPanelMgr.getInstance();
    private final LoginInformationMgr loginInformationMgr = LoginInformationMgr.getInstance();

    private final PersistentSessionMgr persistentSessionMgr = PersistentSessionMgr.getInstance();

    private final List userStoresList = new ArrayList();
    private final List userProjectsList = new ArrayList();
    private final List grantUserList = new ArrayList();
    private Vector grantUserVec = new Vector();
    private Vector userProjectsVec = new Vector();
    private Vector userStoresVec = new Vector();
    private Map<CustomizationPanelElement, String> userCustomization;
    protected WebBusinessObject userObject = null;
    protected String pageInit = null;

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        logger = Logger.getLogger(LoginServlet.class);
    }

    @Override
    public void destroy() {
    }

    protected abstract void prepareDefaultSetting(HttpServletRequest request, HttpServletResponse response);

    protected abstract void installMenu(HttpServletRequest request, HttpServletResponse response);

    @Override
    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        response.setHeader("Cache-Control", "no-cache");
        response.setHeader("Cache-Control", "no-store");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        HttpSession session = request.getSession();

        Vector tradesList = new Vector();
        ArrayList requestAsArray = ServletUtils.getRequestParams(request);
        ServletUtils.printRequest(requestAsArray);
        Vector userGroupVec = new Vector();
        WebBusinessObject userGroupWbo;

        String siteNameUser = null;
        String encryptedUserName = (String) request.getParameter("userName");
        String userName = Tools.getRealChar(encryptedUserName);

        String encryptedPassWord = (String) request.getParameter("password");
        String passWord = Tools.getRealChar(encryptedPassWord);
//        String pass = Tools.getRealChar(encryptedPassWord); // for encryption
//        String passWord = EncryptUtil.encryptString(pass); // for encryption
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        LiteMetaDataMgr liteMetaMgr = LiteMetaDataMgr.getInstance();

        userObject = null;
        pageInit = null;
        int userTotalTicketsCount;

        try {
            ApplicationSessionRegistery.AuthenticationType authentication = sessionRegistery.authentication(session.getId(), userName, passWord);
            if (ApplicationSessionRegistery.AuthenticationType.NotExistsEveryBody.equals(authentication)) {
                session.removeAttribute("securityUser");
                userGroupVec = userGroupMgr.getUserByName(userName);

                if (!userGroupVec.isEmpty()) {
                    for (int i = 0; i < userGroupVec.size(); i++) {
                        userGroupWbo = (WebBusinessObject) userGroupVec.get(i);
                        if (userGroupWbo.getAttribute("isDefault").toString().equals("1") || userGroupVec.size() == 1) {
                            request.removeAttribute("groupID");
                            request.setAttribute("groupID", (String) userGroupWbo.getAttribute("groupID"));
                        }
                    }
                } else {
                    authentication = ApplicationSessionRegistery.AuthenticationType.InvalidUserOrPassword;
                    request.setAttribute("authentication", authentication);
                    goToIndex(request, response);
                    return;
                }

                Vector userGroups = userGroupMgr.getSearchResult(request, passWord);
                if (userGroups != null && userGroups.size() > 0) {
                    // get the user from vector
                    userObject = (WebBusinessObject) userGroups.get(0);
                    //  persist session here

                    Long long_userLoginTime = session.getCreationTime();
                    String remoteAddress = request.getSession().getId();
                    String userId = (String) userObject.getAttribute("userId");
                    String managerId = "UL";
                    String ipAddress = request.getRemoteAddr();
                    WebBusinessObject departmentInfo = projectMgr.getManagerByEmployee(userId);
                    if ((departmentInfo != null) && (departmentInfo.getAttribute("optionOne") != null) && (departmentInfo.getAttribute("eqNO") != null)) {
                        managerId = (String) departmentInfo.getAttribute("optionOne");
                    }
                    //  String userName = userObje
                    persistentSessionMgr.deleteOnArbitraryKey(userId, "key1");
                    WebBusinessObject pres_SessionWbo = (WebBusinessObject) persistentSessionMgr.getOnSingleKey(remoteAddress);
                    if (remoteAddress == null) {
                        goToIndex(request, response);
                        System.out.println("session id is null");
                        return;
                    }
                    WebBusinessObject loginWbo = new WebBusinessObject();
                    loginWbo.setAttribute("userID", userId);
                    ArrayList<String> userLoggedIDs = persistentSessionMgr.getLoggedUsers();
                    if (!userLoggedIDs.contains(userId) && userLoggedIDs.size() == Long.parseLong(metaMgr.getMaxUsersNum(), 2)) {
                        authentication = ApplicationSessionRegistery.AuthenticationType.SessionsLimits;
                        request.setAttribute("authentication", authentication);
                        goToIndex(request, response);
                        return;
                    }
                    if (pres_SessionWbo != null) {
                        if (persistentSessionMgr.saveOrUpdateObject(remoteAddress, userId, userName, managerId, "U", ipAddress)) {
                            LoginHistoryMgr.getInstance().saveObject(loginWbo);
                        } else {
                            goToIndex(request, response);
                            return;
                        }
                    } else {
                        if (persistentSessionMgr.saveOrUpdateObject(remoteAddress, userId, userName, managerId, "I", ipAddress)) {
                            LoginHistoryMgr.getInstance().saveObject(loginWbo);
                        } else {
                            goToIndex(request, response);
                            return;
                        }
                    }

                    remoteAddress = request.getRemoteAddr();
                    //Get User Trade
                    Vector userTradeVec = userTradeMgr.getOnArbitraryKey(userObject.getAttribute("userId").toString(), "key1");
                    if (userTradeVec.size() > 0) {
                        for (int i = 0; i < userTradeVec.size(); i++) {
                            Hashtable trade = new Hashtable();
                            WebBusinessObject userTradeWBO = (WebBusinessObject) userTradeVec.elementAt(i);
                            trade.put("userTradeID", userTradeWBO.getAttribute("Id").toString());
                            trade.put("tradeId", userTradeWBO.getAttribute("tradeId").toString());
                            trade.put("tradeName", userTradeWBO.getAttribute("tradeName").toString());

                            WebBusinessObject wbo = new WebBusinessObject(trade);
                            tradesList.addElement(wbo);
                        }
                    }

                    // get the user from vector
                    userObject = (WebBusinessObject) userGroups.get(0);
                    userObject.setAttribute("sessionId", session.getId());
                    userObject.setAttribute("loginTime", long_userLoginTime.toString());
                    userObject.setAttribute("remoteAddress", remoteAddress);
                    userObject.setAttribute("userTrade", tradesList);
                    userObject.setAttribute("vecTradeList", userTradeVec);

                    //new
                    if (sessionRegistery.isAtLimit()) {
                        authentication = ApplicationSessionRegistery.AuthenticationType.SessionsLimits;
                        request.setAttribute("authentication", authentication);
                        goToIndex(request, response);
                        return;
                    }

                    session.setAttribute("loggedUser", userObject);
                    String lang = (String) session.getAttribute("currentMode");
                    // language setting by walid

                    if (lang != null) {
                        session.setAttribute("currentMode", session.getAttribute("currentMode").toString());
                    } else {
                        lang = "Ar";
                        session.setAttribute("currentMode", metaMgr.getDefaultLanguage());
                    }

                    ServletContext c = session.getServletContext();

                    ThreeDimensionMenu tdm = (ThreeDimensionMenu) c.getAttribute("myMenu");
                    tdm.applySecurityPolicy((String) userObject.getAttribute("groupMenu"));

                    if (!tdm.isContextInitilaized()) {
                        tdm.insertContext();
                    }

                    pageInit = (String) userObject.getAttribute("pageInit");

                    // initialize default view
                    // Set Security User........... Begin//
                    WebBusinessObject grantUserwbo;

                    grantUserList.clear();
                    SecurityUser securityUser = new SecurityUser();
                    session.setAttribute("securityUser", securityUser);
                    session.removeAttribute("securityUser");

                    grantUserVec = grantUserMgr.getOnArbitraryKey(userObject.getAttribute("userId").toString(), "key2");
                    logger.info("grantUserVec Size " + grantUserVec.size());
                    for (int i = 0; i < grantUserVec.size(); i++) {
                        grantUserwbo = (WebBusinessObject) grantUserVec.get(i);
                        grantUserList.add(grantUserwbo);
                    }

                    try {
                        this.userStoresList.clear();
                        userStoresVec = userStoresMgr.getOnArbitraryKey((String) userObject.getAttribute("userId"), "key1");
                        for (int i = 0; i < userStoresVec.size(); i++) {
                            this.userStoresList.add((WebBusinessObject) userStoresVec.get(i));
                        }

                        this.userProjectsList.clear();
                        this.userProjectsVec = userProjectsMgr.getOnArbitraryKey((String) userObject.getAttribute("userId"), "key1");
                        for (int i = 0; i < userProjectsVec.size(); i++) {
                            this.userProjectsList.add((WebBusinessObject) userProjectsVec.get(i));
                        }
                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                    }
                    String isManager = userMgr.getIsManager((String) userObject.getAttribute("userId"));
                    String departmentID = null;
                    if (isManager.equals("0")) {
                        EmpRelationMgr empRelationMgr = EmpRelationMgr.getInstance();
                        departmentID = empRelationMgr.getDepartmentByManager((String) userObject.getAttribute("userId"));
                    } else if (isManager.equals("1")) {
                        departmentID = projectMgr.getProjectCodeByManager((String) userObject.getAttribute("userId"));
                    }

                    try {
                        loginInformationMgr.update(userObject.getAttribute("userId").toString());
                    } catch (Exception ex) {
                        logger.error(ex);
                    }

                    // Add The User Company
                    String companyID = "";
                    String companyName = "";
                    UserCompaniesMgr usercompanyMgr = UserCompaniesMgr.getInstance();
                    WebBusinessObject userCompanyWbo = usercompanyMgr.getOnSingleKey("key1", userObject.getAttribute("userId").toString());
                    if (userCompanyWbo != null) {
                        companyID = userCompanyWbo.getAttribute("companyID").toString();
                        companyName = userCompanyWbo.getAttribute("companyName").toString();
                    } else {
                        companyID = "";
                        companyName = "";
                    }
                    userCustomization = customizationMgr.getCustomizationUser(userObject.getAttribute("userId").toString());
                    securityUser.setUserId(userObject.getAttribute("userId").toString());
                    securityUser.setCompanyId(companyID);
                    securityUser.setCompanyName(companyName);
                    securityUser.setSuperUser(userMgr.getIsSuperUser(securityUser.getUserId()));
                    securityUser.setUserName(userObject.getAttribute("userName").toString());
                    securityUser.setEncryptedUserName(encryptedUserName);
                    securityUser.setUserPassword(userObject.getAttribute("password").toString());
                    securityUser.setEncryptedUserPassword(encryptedPassWord);
                    securityUser.setSiteName(siteNameUser);
                    securityUser.setUserMail((String) userObject.getAttribute("email"));
                    securityUser.setSearchBy(userObject.getAttribute("searchBy").toString());
                    securityUser.setUserStores(this.userStoresList);
                    securityUser.setUserProjects(this.userProjectsList);
                    securityUser.setUserGroup(userGroupVec);
                    securityUser.setFullName(userMgr.getFullName(userObject.getAttribute("userId").toString()));
                    securityUser.setUserDivision(departmentID);
                    securityUser.setCustomizationValues(userCustomization, userObject);
                    if (grantUserList.size() > 0) {
                        securityUser.setUserAction(grantUserList);
                    }
                    securityUser.setLastLogin(loginInformationMgr.getLastLogin(userObject.getAttribute("userId").toString(), lang));
                    com.silkworm.business_objects.secure_menu.MenuBuilder menuBuilder = new com.silkworm.business_objects.secure_menu.MenuBuilder();
                    menuBuilder.setXslFile(web_inf_path + "/menu.xsl");
                    securityUser.setMenuString(menuBuilder.buildMenu((String) userObject.getAttribute("groupMenu")));
                    menuBuilder.setXslFile(web_inf_path + "/menu_en.xsl");
                    securityUser.setMenuEnString(menuBuilder.buildMenu((String) userObject.getAttribute("groupMenu")));
                    WebBusinessObject managerWbo = userMgr.getOnSingleKey(managerId);
                    if (managerWbo != null) {
                        securityUser.setManagerName((String) managerWbo.getAttribute("fullName"));
                    }
                    ArrayList<WebBusinessObject> departmentList = new ArrayList<>(projectMgr.getOnArbitraryKeyOracle(userId, "key5"));
                    if (departmentList.size() > 0) {
                        securityUser.setDepartmentName((String) departmentList.get(0).getAttribute("projectName"));
                    }
                    session.setAttribute("securityUser", securityUser);
//                    sessionRegistery.addSession(session, remoteAddress);
                    ///////////////// End  ////////////////////////
                    // Set Security User........... End//
                    if ("1".equals(MetaDataMgr.getInstance().getCheckAuthorization())) {
                        WebBusinessObject authorityWbo = TradeTempMgr.getInstance().getOnSingleKey("1");
                        if (authorityWbo == null || "0".equals(authorityWbo.getAttribute("isAuthorized"))) {
                            goToUnauthorized(request, response);
                            return;
                        } else if (authorityWbo != null) {
                            if ("1".equals(authorityWbo.getAttribute("isLocked"))) {
                                goToLocked(request, response);
                                return;
                            } else if ("0".equals(authorityWbo.getAttribute("isPaid"))) {
                                goToNotPaid(request, response);
                                return;
                            }
                        }
                    }
                    prepareDefaultSetting(request, response);
                } else {
                    authentication = ApplicationSessionRegistery.AuthenticationType.InvalidUserOrPassword;
                    request.setAttribute("authentication", authentication);
                    goToIndex(request, response);
                    return;
                }

                WebBusinessObject userTempWbo;

                //open Jar File
                metaMgr.setMetaData("xfile.jar");
                liteMetaMgr.setMetaData("xfile.jar");
                ParseSideMenu parseSideMenu = new ParseSideMenu();
                Hashtable logos;
                logos = parseSideMenu.getCompanyLogo("configration" + metaMgr.getCompanyName() + ".xml");

                /**
                 * ************ Read Date Format ***************
                 */
                DateParser dateParser = new DateParser();
                Hashtable dateFormats = dateParser.getDateFormat();

                String jsDateFormat = (String) dateFormats.get("jsDateFormat");
                String javaDateFormat = (String) dateFormats.get("javaDateFormat");

                userTempWbo = (WebBusinessObject) session.getAttribute("loggedUser");
                userTempWbo.setAttribute("jsDateFormat", jsDateFormat);
                userTempWbo.setAttribute("javaDateFormat", javaDateFormat);

                session.removeAttribute("loggedUser");
                session.setAttribute("loggedUser", userTempWbo);

                /**
                 * ************ End Of Read Date Format ********
                 */
                Hashtable siteData = parseSideMenu.getSiteData("configration" + metaMgr.getCompanyName() + ".xml");
                String siteName = siteData.get("siteName").toString();
                if (siteData.get("userType").toString().equalsIgnoreCase("single")) {
                    if (siteName != null && !siteName.equalsIgnoreCase("")) {
                        WebBusinessObject projectWbo;

                        Vector sites;
                        String projectId;
                        sites = projectMgr.getOnArbitraryKey(siteName, "key1");
                        if (sites.size() > 0) {

                            projectWbo = (WebBusinessObject) sites.get(0);
                            projectId = projectWbo.getAttribute("projectID").toString();

                            userTempWbo = (WebBusinessObject) session.getAttribute("loggedUser");
                            userTempWbo.setAttribute("projectID", projectId);
                            userTempWbo.setAttribute("projectName", siteName);

                            session.removeAttribute("loggedUser");
                            session.setAttribute("loggedUser", userTempWbo);
                        }
                    }
                }

                userTempWbo = (WebBusinessObject) session.getAttribute("loggedUser");
                userTempWbo.setAttribute("userType", siteData.get("userType").toString());

                /**
                 * ******* Get project Id then get Store **************
                 */
                //open Jar File
                metaMgr = MetaDataMgr.getInstance();
                liteMetaMgr = LiteMetaDataMgr.getInstance();
                metaMgr.setMetaData("xfile.jar");
                liteMetaMgr.setMetaData("xfile.jar");
                parseSideMenu = new ParseSideMenu();
                if (siteData.get("userType").toString().equalsIgnoreCase("multi")) {

                    String siteId = userTempWbo.getAttribute("projectID").toString();
                    Store store = parseSideMenu.getDefultStore(siteId);
                    if (store != null) {
                        userTempWbo.setAttribute("storeId", store.id);
                        userTempWbo.setAttribute("storeName", store.name);
                    } else {
                        userTempWbo.setAttribute("storeId", "nostore");
                        userTempWbo.setAttribute("storeName", "nostore");
                    }

                } else {
                    userTempWbo.setAttribute("storeId", "nostore");
                    userTempWbo.setAttribute("storeName", "nostore");
                }

                /**
                 * ************ End of get Store **********
                 */
                // get user total tickets count
                userTotalTicketsCount = totalTicketsMgr.getUserTotalTicketsCount((String) userTempWbo.getAttribute("userId"));
                userTempWbo.setAttribute("userTotalTicketsCount", userTotalTicketsCount);

                session.removeAttribute("loggedUser");
                session.setAttribute("loggedUser", userTempWbo);

                metaMgr.closeDataSource();
                liteMetaMgr.closeDataSource();
                session.setAttribute("logos", logos);

                userObject.getObjectAsXML();
                userObject.getObjectAsJSON();
            } else if (ApplicationSessionRegistery.AuthenticationType.AlreadyLogin.equals(authentication)) {
                userObject = (WebBusinessObject) session.getAttribute("loggedUser");
                prepareDefaultSetting(request, response);
            } else {
                request.setAttribute("authentication", authentication);
                goToIndex(request, response);
            }

        } catch (SQLException sqlEx) {
            // forward to errot page
            logger.error("Sql Exception: " + sqlEx.getMessage());
        } catch (Exception e) {
            // forward to error page
            logger.error("Exception: " + e.getMessage());
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}
