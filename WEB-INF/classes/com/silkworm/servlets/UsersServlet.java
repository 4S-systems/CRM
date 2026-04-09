package com.silkworm.servlets;

import com.clients.db_access.ClientComplaintsMgr;
import com.clients.db_access.ClientMgr;
import com.crm.common.CRMConstants;
import com.maintenance.common.ClosureConfigMgr;
import com.maintenance.common.UserGroupConfigMgr;
import com.maintenance.common.UserDepartmentConfigMgr;
import com.maintenance.common.Tools;
import com.maintenance.common.UserClosureConfigMgr;
import com.maintenance.db_access.DistributionListMgr;
import com.businessfw.hrs.db_access.EmployeeMgr;
import com.maintenance.common.UserCampaignConfigMgr;
import com.maintenance.db_access.IssueByComplaintMgr;
import com.maintenance.db_access.IssueDocumentMgr;
import com.maintenance.db_access.ItemFormListMgr;
import com.maintenance.db_access.StoresErpMgr;
import com.silkworm.db_access.GrantsMgr;
import com.maintenance.db_access.TradeMgr;
import com.maintenance.db_access.UserCompaniesMgr;
import com.maintenance.db_access.UserCompanyProjectsMgr;
import com.maintenance.db_access.UserDistrictsMgr;
import com.maintenance.db_access.UserProjectsMgr;
import com.maintenance.db_access.UserStoresMgr;
import com.maintenance.db_access.UserTradeMgr;
import com.planning.db_access.RecordSeasonMgr;
import com.planning.db_access.SeasonMgr;
import com.tracker.db_access.ProjectMgr;
import com.silkworm.common.*;
import com.silkworm.business_objects.*;
import com.silkworm.common.FilterQuery;
import com.silkworm.Exceptions.*;
import com.silkworm.business_objects.secure_menu.ThreeDimensionMenu;
import com.silkworm.db_access.CustomizationPanelMgr;
import com.silkworm.db_access.GrantUserMgr;
import com.silkworm.db_access.PersistentSessionMgr;
import com.silkworm.functional_security.db_access.UserBussinessOpMgr;
import com.silkworm.logger.db_access.LoggerMgr;
import com.silkworm.pagination.FilterCondition;
import com.silkworm.pagination.Operations;
import static com.silkworm.servlets.swBaseServlet.logger;
import com.silkworm.uploader.FileMeta;
import com.silkworm.uploader.MultipartRequestHandler;
import com.silkworm.util.EncryptUtil;
import com.tracker.db_access.ClientCampaignMgr;
import com.tracker.db_access.IssueMgr;
import com.tracker.db_access.IssueStatusMgr;
import com.tracker.db_access.PreviligesTypeMgr;
import flexjson.JSONSerializer;
import javax.servlet.*;
import javax.servlet.http.*;
import java.util.*;
import java.sql.*;
import java.util.ArrayList;
import java.io.*;
import java.text.SimpleDateFormat;
import org.apache.log4j.Logger;
import com.silkworm.servlets.MultipartRequest;
import com.tracker.db_access.CampaignMgr;
import java.util.logging.Level;
import javax.servlet.annotation.MultipartConfig;
@MultipartConfig(fileSizeThreshold=1024*1024*2, 
maxFileSize=1024*1024*10, 
maxRequestSize=1024*1024*50)
public class UsersServlet extends swBaseServlet {

    UserMgr userMgr = UserMgr.getInstance();
    GroupMgr groupMgr = GroupMgr.getInstance();
    TradeMgr tradeMgr = TradeMgr.getInstance();
    GrantsMgr grantsMgr = GrantsMgr.getInstance();
    UserBussinessOpMgr bussinessOpMgr = UserBussinessOpMgr.getInstance();
    WebAppUser webUser = new WebAppUser();
    UserGroupMgr userGroupMgr = UserGroupMgr.getInstance();
    UserTradeMgr userTradeMgr = UserTradeMgr.getInstance();
    GrantUserMgr userGrantMgr = GrantUserMgr.getInstance();
    UserStoresMgr userStoreMgr = UserStoresMgr.getInstance();
    UserProjectsMgr userProjectsMgr = UserProjectsMgr.getInstance();
    ItemFormListMgr itemFormListMgr = ItemFormListMgr.getInstance();
    ProjectMgr projectMgr = ProjectMgr.getInstance();
    ClientMgr clientMgr = ClientMgr.getInstance();
    UserClientsMgr userClientsMgr = UserClientsMgr.getInstance();
    EmpRelationMgr empRelationMgr = EmpRelationMgr.getInstance();
    ClosureConfigMgr closureConfigMgr = ClosureConfigMgr.getInstance();
    UserClosureConfigMgr userClosureConfig = UserClosureConfigMgr.getInstance();
    UserGroupConfigMgr userGroupConfigMgr = UserGroupConfigMgr.getInstance();
    UserDepartmentConfigMgr userDeptsConfigMgr = UserDepartmentConfigMgr.getInstance();
    FilterQuery filterQuery;
    WebBusinessObjectsContainer wboc = null;
    WebBusinessObject tradeWbo = null;
    WebBusinessObject grantWbo = null;
    WebBusinessObject user = null;
    UserExtMgr userExtMgr =null;
    WebBusinessObject userTradeWbo, siteWbo, uGroupWbo, uClosureWbo;
    Vector userList = null;
    Vector userGroup = null;
    Vector closureConfigVec = null;
    Vector userClosure = null;
    Vector groupsVec = null;
    Vector userGroupsConfigVec = null;
    Vector repsGroups = null;
    Vector userDeptsConfVec = null;
    Vector userDepts = null;
    Vector<WebBusinessObject> branches;
    Vector<WebBusinessObject> projects;
    Vector<WebBusinessObject> stores;
    Vector<WebBusinessObject> groups;
    Vector<WebBusinessObject> grants;
    Vector<WebBusinessObject> userProjects;
    Vector<WebBusinessObject> userStores;
    Vector<WebBusinessObject> userGroups;
    Vector<WebBusinessObject> userGrants;
    Vector<WebBusinessObject> closures;
    List filterList = new ArrayList();
    ArrayList trades, sites, companies;
    HashMap tagValueList = new HashMap();
    String[] userGroupsArr = null;
    String[] userTradesArr = null;
    String[] userGrantsArr = null;
    String[] defaultGroupList = null;
    String[] userClosuresList = null;
    String[] repsGroupsList = null;
    String branchCode, isDefault, userId, searchBy, tradeId, grantId, defaultGroupCode, projectId;
    boolean viewIsDefualt;
    boolean result;
     private ClientCampaignMgr clientCampMgr;
    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
         clientCampMgr = ClientCampaignMgr.getInstance();
        logger = Logger.getLogger(UsersServlet.class);
    }

    @Override
    public void destroy() {
    }

    @Override
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            super.processRequest(request, response);
            HttpSession session = request.getSession();
            WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
            String remoteAccess = session.getId();
            WebBusinessObject persistentUser = (WebBusinessObject) PersistentSessionMgr.getInstance().getOnSingleKey(remoteAccess);
            userGroupMgr = UserGroupMgr.getInstance();
            operation = getOpCode((String) request.getParameter("op"));
            SecurityUser securityUser = new SecurityUser();
            securityUser = (SecurityUser) session.getAttribute("securityUser");

            switch (operation) {
                case 1:
                    servedPage = "/docs/user_security/new_user.jsp";

                    groups = groupMgr.getCashedTable();
                    trades = tradeMgr.getCashedTableAsBusObjects();
                    grants = grantsMgr.getCashedTable();

                    projectMgr = ProjectMgr.getInstance();
                    try {
//                        projects = projectMgr.getMainProjectsByUser(securityUser.getUserId());
                        projects = projectMgr.getCashedTable();
                    } catch (Exception ex) {
                        logger.error(ex);
                    }

                    tradeMgr = TradeMgr.getInstance();
                    Vector trades_ = tradeMgr.getOnArbitraryKey("0", "key3");
//                    projects = projectMgr.getOnArbitraryKey("0", "key2");

                    request.setAttribute("allTrades", trades_);
                    request.setAttribute("userId", userId);

                    //setRequestByProjectsForUser(request, securityUser.getUserId());
                    request.setAttribute("defaultLocationName", securityUser.getSiteName());
                    request.setAttribute("defaultSite", securityUser.getSiteId());
                    request.setAttribute("page", servedPage);
                    request.setAttribute("groups", groups);
                    request.setAttribute("allSites", projects);
                    request.setAttribute("trades", trades);
                    request.setAttribute("grants", grants);
                    request.setAttribute("groupID", request.getParameter("groupID"));
                    this.forwardToServedPage(request, response);
                    break;
                case 2:
                    servedPage = "/docs/user_security/new_user.jsp";

                    webUser.setFullName(request.getParameter("full_name"));
                    webUser.setUserName(request.getParameter("user_name"));
                    webUser.setPassword(request.getParameter("user_password"));
//                    webUser.setPassword(EncryptUtil.encryptString(request.getParameter("user_password"))); // for encryption
                    webUser.setEmail(request.getParameter("email"));
                    webUser.setIsSuperUser(request.getParameter("isSuperUser"));
                    webUser.setIsManager(request.getParameter("isManager"));
                    if (!userMgr.isUserNameExist(webUser.getUserName())) {
                        String userID = userMgr.saveCompleteUser2(request, session, webUser);
                        if (userID != null & !userID.equals("")) {
//                            securityUser = (SecurityUser) session.getAttribute("securityUser");
//                            userId = userID;
//                            isDefault = request.getParameter("isDefault");
//                            String[] checkTrade = request.getParameterValues("checkTrade");
//                            String[] tradeId = request.getParameterValues("tradeId");
//                            String[] tradeName = request.getParameterValues("tradeName");
//                            String[] tradeQual = request.getParameterValues("tradeQualification");
//                            String[] note = request.getParameterValues("notes");
//                            String[] realTradeId = null;
//                            WebBusinessObject userTradeWBO2;
//                            Vector userTrades2 = new Vector();
//                            TradeMgr tradeMgr = TradeMgr.getInstance();
//                            for (int i = 0; i < checkTrade.length; i++) {
//                                userTradeWBO2 = new WebBusinessObject();
//                                WebBusinessObject wbo = new WebBusinessObject();
//                                String id = checkTrade[i];
//                                userTradeWBO2 = tradeMgr.getOnSingleKey(id);
//                                wbo.setAttribute("tradeId", userTradeWBO2.getAttribute("tradeId"));
//                                wbo.setAttribute("tradeName", userTradeWBO2.getAttribute("tradeName"));
//                                wbo.setAttribute("tradeQualification", tradeQual[i]);
//                                wbo.setAttribute("notes", note[i]);
//                                if (checkTrade[i] != null && checkTrade[i].equalsIgnoreCase(isDefault)) {
////                            securityUser.setSiteId(tradeId[index]);
////                            securityUser.setSiteName(projectName[index]);
//                                    wbo.setAttribute("isDefault", "1");
//                                } else {
//                                    wbo.setAttribute("isDefault", "0");
//                                }
//                                userTrades2.add(wbo);
//
//                            }

//                            if (userTradeMgr.saveUserTrade(userId, userTrades2, isDefault, session)) {
                            shipBackToNewUser(request, response, "ok");
                        } else {
                            shipBackToNewUser(request, response, "error");
//                            }
                        }
                    } else {
                        shipBackToNewUser(request, response, "doubleName");
                    }
                    break;

                case 3:
                    String key = request.getParameter("userId");
                    EmployeeMgr empMgr = EmployeeMgr.getInstance();
                    DistributionListMgr distributionListMgr = DistributionListMgr.getInstance();
                    IssueMgr issueMgr = IssueMgr.getInstance();
                    if (issueMgr.getOnArbitraryKey(key, "key1").size() > 0
                            || distributionListMgr.getOnArbitraryKeyOracle(key, "key2").size() > 0
                            || distributionListMgr.getOnArbitraryKeyOracle(key, "key3").size() > 0) {
                        servedPage = "/docs/Adminstration/confirm_deluser.jsp";
                        request.setAttribute("userName", request.getParameter("userName"));
                        request.setAttribute("userId", key);
                        request.setAttribute("status", "dataExists");
                        request.setAttribute("issuesList", IssueByComplaintMgr.getInstance().getAllEmployeeComplaints(key, null, null, null));
                        request.setAttribute("usersList", new ArrayList<>(userMgr.getCashedTable()));
                    } else {
                        // delete from two tables
                        bussinessOpMgr.deleteOnArbitraryKey(key, "key1");
                        CustomizationPanelMgr customizationPanelMgr = CustomizationPanelMgr.getInstance();
                        customizationPanelMgr.deleteOnArbitraryKey(key, "key1");
                        userMgr.deleteOnSingleKey(key);
                        empMgr.disJoinEmp(key);
                        empMgr.disJoinMgr(key);
                        userList = securityUser.isSuperUser() ? userMgr.getUserWithStatus("all") : new Vector(userMgr.getEmployeesByManager((String) persistentUser.getAttribute("userId")));
                        servedPage = "/docs/Adminstration/user_list.jsp";
                        long number_of_users = userMgr.countAll();
                        request.setAttribute("numberOfUsers", number_of_users);
                        request.setAttribute("data", userList);
                        request.setAttribute("trades", new ArrayList(tradeMgr.getOnArbitraryKeyOracle("0", "key4")));
                    }
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 4:
                    String userName = request.getParameter("userName");
                    userId = request.getParameter("userId");
                    servedPage = "/docs/Adminstration/confirm_deluser.jsp";
                    request.setAttribute("userName", userName);
                    request.setAttribute("userId", userId);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 5:
                    servedPage = "/docs/user_security/view_user.jsp";
                    userId = request.getParameter("userId");
                    String statusCode = request.getParameter("statusCode");
                    String numberOfUsers_ = request.getParameter("numberOfUsers");
                    String index_ = request.getParameter("index");

                    user = userMgr.getOnSingleKey(userId);
                    setRequestByProjectsForUser(request, userId);
                    setRequestByStoreForUser(request, userId);
                    setRequestByGroupsForUser(request, userId);
                    setRequestByGrantsForUser(request, userId);

                    userTradeWbo = userTradeMgr.getOnSingleKey1(userId);

                    Tools.createUserSideMenu(userId, index_, numberOfUsers_, request);

                    if (userId != null) {
                        request.setAttribute("managerWbo", userMgr.getManagerByEmployeeID(userId));
                    }
                    request.setAttribute("statusCode", statusCode);
                    request.setAttribute("user", user);
                    request.setAttribute("trade", userTradeWbo);
                    request.setAttribute("index", request.getParameter("index"));
                    request.setAttribute("numberOfUsers", request.getParameter("numberOfUsers"));
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 6:
                    servedPage = "/docs/Adminstration/update_user.jsp";
                    userId = request.getParameter("userId");
                    numberOfUsers_ = request.getParameter("numberOfUsers");
                    index_ = request.getParameter("index");
                    Tools.createUserSideMenu(userId, index_, numberOfUsers_, request);
                    userGroupMgr = UserGroupMgr.getInstance();
                    userGroup = new Vector();
                    siteWbo = new WebBusinessObject();
                    projectMgr = ProjectMgr.getInstance();
                    user = userMgr.getOnSingleKey(userId);
                    try {
                        userGroup = userGroupMgr.getOnArbitraryKey(userId, "refintegkey");
                    } catch (SQLException ex) {
                        logger.error(ex.getMessage());
                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                    }
                    viewIsDefualt = false;
                    uGroupWbo = new WebBusinessObject();
                    if (userGroup.size() > 0) {
                        uGroupWbo = (WebBusinessObject) userGroup.get(0);
                        if (uGroupWbo.getAttribute("isDefault") != null) {
                            viewIsDefualt = true;
                        }
                    }
                    filterQuery = new FilterQuery();
                    tagValueList.clear();
                    filterList.clear();
                    tagValueList = filterQuery.getFilterList();
                    for (int i = 0; i < tagValueList.size(); i++) {
                        filterList.add(tagValueList.get(i));
                    }
                    request.setAttribute("filterList", filterList);

                    projectId = (String) uGroupWbo.getAttribute("projectID");
                    siteWbo = projectMgr.getOnSingleKey(projectId);
                    searchBy = uGroupWbo.getAttribute("searchBy").toString();
                    if (siteWbo != null) {
                        user.setAttribute("site", siteWbo.getAttribute("projectName").toString());
                        user.setAttribute("siteId", siteWbo.getAttribute("projectID").toString());
                    }
                    user.setAttribute("searchBy", searchBy);
                    sites = new ArrayList();
                    sites = projectMgr.getAllMngmntProjects();
                    request.setAttribute("userId", userId);
                    request.setAttribute("sites", sites);
                    request.setAttribute("user", user);
                    request.setAttribute("viewIsDefualt", viewIsDefualt);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 7:
                    servedPage = "/docs/Adminstration/update_user.jsp";
                    userTradesArr = (String[]) request.getParameterValues("userTrades");
                    try {
                        scrapeForm(request, "update");
                        defaultGroupList = (String[]) request.getParameterValues("isDefault");
                        defaultGroupCode = defaultGroupList[0];
                        // COMMENTED becaouse it fail by forgin keys in schedule
                        //now he didn't delete and update down (in user group table) insteade of delete then insert
                        //   if (userGroupMgr.deleteRefIntegKey(request.getParameter("userId"))) {
                        userTradeMgr.deleteRefIntegKey(request.getParameter("userId"));
//                        userGrantMgr.deleteOnArbitraryKey(request.getParameter("userId"), "key2");
                        //    }

                        filterQuery = new FilterQuery();
                        tagValueList.clear();
                        filterList.clear();
                        tagValueList = filterQuery.getFilterList();
                        for (int i = 0; i < tagValueList.size(); i++) {
                            filterList.add(tagValueList.get(i));
                        }
                        request.setAttribute("filterList", filterList);

                        user = (WebBusinessObject) userMgr.getOnSingleKey(request.getParameter("userId"));
                        user.setAttribute("password", request.getParameter("password"));
                        user.setAttribute("email", request.getParameter("email"));
                        user.setAttribute("fullName", request.getParameter("fullName"));
                        user.setAttribute("siteId", request.getParameter("siteId"));
                        user.setAttribute("searchBy", request.getParameter("searchBy"));
                        user.setAttribute("userId", user.getAttribute("userId").toString());
                        userGroupsArr = (String[]) request.getParameterValues("userGroups");
//                        userGrantsArr = (String[]) request.getParameterValues("grantUser");
                        ArrayList cashedGroups = groupMgr.getCashedTableAsBusObjects();
                        wboc = new WebBusinessObjectsContainer(cashedGroups);
                        ArrayList subsetGroups = wboc.getContainerSubset(userGroupsArr);
                        userGroupMgr.deleteOnArbitraryKey(user.getAttribute("userId").toString(), "refintegkey");
                        userMgr.updateUserAndGroups(user, subsetGroups, defaultGroupCode, session);
                        for (int i = 0; i < userTradesArr.length; i++) {
                            tradeId = userTradesArr[i];
                            tradeWbo = tradeMgr.getOnSingleKey(tradeId);
                            userMgr.UpdateUserTradeObject(user, tradeWbo);
                        }
//                        for (int i = 0; i < userGrantsArr.length; i++) {
//                            grantId = userGrantsArr[i];
//                            grantWbo = grantsMgr.getOnSingleKey(grantId);
//                            userMgr.updateGrantsUserObject(user, grantWbo);
//                        }
//
                        shipBack("ok", request, response);

                        break;
                    } catch (EmptyRequestException ere) {
                        shipBack(ere.getMessage(), request, response);
                        break;
                    } catch (EntryExistsException eee) {
                        shipBack(eee.getMessage(), request, response);
                        break;
                    } catch (SQLException sqlEx) {
                        shipBack(sqlEx.getMessage(), request, response);
                        break;
                    } catch (Exception Ex) {
                        shipBack(Ex.getMessage(), request, response);
                        break;
                    }

                    case 8:
                    servedPage = "/docs/user_security/edit_information.jsp";
                    userId = request.getParameter("userId");
                    userExtMgr = UserExtMgr.getInstance(); 
                    String delete = request.getParameter("delete");
                    String nameBrokerOld = request.getParameter("nameBrokerOld");
                     boolean test=userExtMgr.isExist(userId);
                     String test1=String.valueOf(test);
                     request.setAttribute("test",test1);
                    if (request.getParameter("CommercialRegister")!= null )
                       {
                      
                        //userExtMgr.deleteOnSingleKey(userId);
                        WebBusinessObject userExtWbo = new WebBusinessObject();
                        userExtWbo.setAttribute("userID",userId);
                        userExtWbo.setAttribute("nameBrokerOld", nameBrokerOld);
                        userExtWbo.setAttribute("nameBroker", request.getParameter("nameBroker"));
                        userExtWbo.setAttribute("email", request.getParameter("email"));
                        userExtWbo.setAttribute("CommercialRegister", request.getParameter("CommercialRegister"));
                        userExtWbo.setAttribute("TaxCardNumber", request.getParameter("TaxCardNumber"));
                        userExtWbo.setAttribute("RecordDate", request.getParameter("RecordDate"));
                        userExtWbo.setAttribute("AuthorizedPerson", request.getParameter("AuthorizedPerson"));
                        userExtWbo.setAttribute("companyAddress", request.getParameter("companyAddress"));
                        userExtWbo.setAttribute("phoneNumber", request.getParameter("phoneNumber"));
                        userExtWbo.setAttribute("noSales", request.getParameter("noSales"));
                   
                         userExtMgr.updateBoker(userExtWbo);
                       
                      
                      
                        /*request.setAttribute("status", userExtMgr.saveObject(userExtWbo) ? "ok" : "fail");
                          String imageName = request.getParameter("imageName");
                           if (imageName != null) {
                               IssueDocumentMgr documentMgr = IssueDocumentMgr.getInstance();
                               List<FileMeta> files = MultipartRequestHandler.uploadByJavaServletAPI(request);
                               documentMgr.saveDocuments(files, userId, request.getParameter("configType"),
                                       (String) loggedUser.getAttribute("userId"), request.getParameter("docType"));
                           }
                            WebBusinessObject userWbo = userMgr.getOnSingleKey(userId);
                        userWbo.setAttribute("email", request.getParameter("email"));
                        userWbo.setAttribute("canSendEmail", request.getParameter("SIPID"));
                        userMgr.updateBaidData(userWbo, defaultGroupCode, session);*/
                       }
                     if (delete != null) 
                       {   
                           CampaignMgr.getInstance().deleteOnArbitraryKey(nameBrokerOld,"key5");
                           RecordSeasonMgr.getInstance().deleteOnSingleKey(userId);
                            response.sendRedirect("UsersServlet?op=getBrokersList");
                            return;
                          
                       }
                    
                       request.setAttribute("userWbo", userId);
                                           
                       request.setAttribute("userExtWbo", RecordSeasonMgr.getInstance().getOnSingleKey(userId));
                         
                       request.setAttribute("page", servedPage);

                    this.forwardToServedPage(request, response);


                    break;
                case 10:
                    userList = userMgr.getCashedTable();
                    servedPage = "/docs/Adminstration/user_list.jsp";
                    request.setAttribute("data", userList);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 11:
                    securityUser = (SecurityUser) session.getAttribute("securityUser");
                    String lang = (String) request.getSession().getAttribute("currentMode");

                    String userStoresStr = "";
                    String userProjectsStr = "";

                    List userStoresList = securityUser.getUserStores();
                    List userProjectsList = securityUser.getUserProjects();

                    filterQuery = new FilterQuery();
                    tagValueList.clear();
                    filterList.clear();
                    tagValueList = filterQuery.getFilterList();
                    for (int i = 0; i < tagValueList.size(); i++) {
                        filterList.add(tagValueList.get(i));
                    }

                    WebBusinessObject wbo;
                    if (userStoresList != null && userStoresList.size() > 0) {
                        for (int i = 0; i < userStoresList.size(); i++) {
                            wbo = (WebBusinessObject) userStoresList.get(i);
                            userStoresStr += "* " + wbo.getAttribute("storeName" + lang) + "\n";
                        }
                    }

                    if (userProjectsList != null && userProjectsList.size() > 0) {
                        for (int i = 0; i < userProjectsList.size(); i++) {
                            wbo = (WebBusinessObject) userProjectsList.get(i);
                            userProjectsStr += "* " + wbo.getAttribute("projectName") + "\n";
                        }
                    }

                    if (securityUser.getUserId() != null) {
                        request.setAttribute("managerWbo", userMgr.getManagerByEmployeeID(securityUser.getUserId()));
                    }
                    request.setAttribute("filterList", filterList);
                    request.setAttribute("userStoresStr", userStoresStr);
                    request.setAttribute("userProjectsStr", userProjectsStr);
                    servedPage = "/docs/user_security/user_data.jsp";
                    request.setAttribute("page", servedPage);
                    this.forward(servedPage, request, response);
                    break;

                case 12:
                    servedPage = "/docs/user_security/assign_user_stores.jsp";
                    userId = request.getParameter("userId");
                    WebBusinessObject userWbo = userMgr.getOnSingleKey(userId);

                    ArrayList<String> userPrivilegeList
                            = userStoreMgr.getUserPrivilegeCodes(userId);
                    PreviligesTypeMgr previligesTypeMgr = PreviligesTypeMgr.getInstance();
                    Vector prevTypeV = previligesTypeMgr.getCashedTable();

                    userName = "";
                    if (user != null) {
                        userName = (String) userWbo.getAttribute("userName");
                    }
                    WebBusinessObject prevTypeWbo = (WebBusinessObject) prevTypeV.get(0);
                    userStoreMgr = UserStoresMgr.getInstance();
                    String prevType = (String) prevTypeWbo.getAttribute("id");
                    if (request.getParameter("prev_type") != null && !request.getParameter("prev_type").equals("")) {
                        prevType = (String) request.getParameter("prev_type");
                    }
                    Vector prevliges = userStoreMgr.getPrivliges(prevType);

//                    branches = userProjectsMgr.getOnArbitraryKey(userId, "key1");
//
//                    for (WebBusinessObject branch : branches) {
//                        branchCode = (String) branch.getAttribute("projectID");
//                        stores = itemFormListMgr.getStoreByBranch(branchCode);
//                        branch.setAttribute("stores", stores);
//                    }
                    // get stores for this
//                    setRequestByStoreForUser(request, userId);
                    request.setAttribute("prevliges", prevliges);
                    request.setAttribute("userPrivilegeList", userPrivilegeList);
//                    request.setAttribute("branches", branches);
                    request.setAttribute("userId", userId);
                    request.setAttribute("prevType", prevType);
                    request.setAttribute("userName", userName);
                    request.setAttribute("page", servedPage);
                    request.setAttribute("prevTypeV", prevTypeV);
                    this.forwardToServedPage(request, response);
                    break;

                case 13:
                    userId = request.getParameter("userId");
                    Vector Store = new Vector();
                    WebBusinessObject wboStore = null;
                    Vector StoreErpEn = new Vector();
                    Vector StoreErpAr = new Vector();
                    StoresErpMgr storesErpMgr = StoresErpMgr.getInstance();
                    String[] checkStore = request.getParameterValues("checkPrev");
                    String[] storeCodeArr = request.getParameterValues("prevCode");
                    String[] storeNameArArr = request.getParameterValues("prevNameAr");
                    String[] storeNameEnArr = request.getParameterValues("prevNameEn");

                    //String[] storeNameArr = request.getParameterValues("storeName");
                    userStores = new Vector();
                    WebBusinessObject userStoreWBO;
                    int index = 0;
                    for (int i = 0; i < checkStore.length; i++) {
                        index = Integer.parseInt(checkStore[i]);
                        userStoreWBO = new WebBusinessObject();

                        //  userStoreWBO.setAttribute("storeNameAr", StoreErpAr.get(index));
                        //   userStoreWBO.setAttribute("storeNameEn", StoreErpEn.get(index));
                        userStoreWBO.setAttribute("storeNameAr", storeNameArArr[index]);
                        userStoreWBO.setAttribute("storeNameEn", storeNameEnArr[index]);

                        userStoreWBO.setAttribute("storeCode", storeCodeArr[index]);
                        userStores.add(userStoreWBO);
                    }
//                    try {
                    // first, delete any existing stores for this user in the database
//                        userStoreMgr.deleteOnArbitraryKey(userId, "key1");
                    prevType = (String) request.getParameter("prev_type");
                    if (userStoreMgr.saveUserStores(userId, userStores, session, prevType)) {
                        request.setAttribute("Status", "ok");
                    } else {
                        request.setAttribute("Status", "no");
                    }

//                    } catch (NoUserInSessionException ex) {
//                        logger.error(ex.getMessage());
//                    }
                    servedPage = "UsersServlet?op=assignStores&userId=" + userId;
                    this.forward(servedPage, request, response);
                    break;

                case 14:
                    servedPage = "/docs/user_security/assign_user_projects.jsp";
                    userId = request.getParameter("userId");
                    userWbo = userMgr.getOnSingleKey(userId);
                    userName = "";
                    if (user != null) {
                        userName = (String) userWbo.getAttribute("userName");
                    }

                    projectMgr = ProjectMgr.getInstance();
                    projects = projectMgr.getCashedTable();
                    projects = projectMgr.getOnArbitraryKey("0", "key2");
                    Vector<WebBusinessObject> projectsV = new Vector<WebBusinessObject>();
                    Vector<String> projectsName = new Vector<String>();
                    try {
                        projectsV = userProjectsMgr.getOnArbitraryKey(userId, "key1");
                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                    }

                    for (WebBusinessObject wboProject : projectsV) {
                        projectsName.addElement((String) wboProject.getAttribute("projectID"));
                        if ("1".equalsIgnoreCase((String) wboProject.getAttribute("isDefault"))) {
                            isDefault = (String) wboProject.getAttribute("projectID");
                        }
                    }

                    request.setAttribute("projectsForUser", projectsName);
                    request.setAttribute("isDefaultProject", isDefault);
                    request.setAttribute("allProjects", projects);
                    request.setAttribute("userId", userId);
                    request.setAttribute("userName", userName);
                    request.setAttribute("page", servedPage);

                    this.forwardToServedPage(request, response);
                    break;

                case 15:
                    securityUser = (SecurityUser) session.getAttribute("securityUser");
                    userId = request.getParameter("userId");
                    isDefault = request.getParameter("isDefault");
                    String[] checkProject = request.getParameterValues("checkProject");
                    String[] projectCode = request.getParameterValues("projectCode");
                    String[] projectName = request.getParameterValues("projectName");
                    String[] newProjects = new String[checkProject.length];
                    String[] oldProjects,
                     differen;

                    Vector userProjects = new Vector();
                    WebBusinessObject userProjectsWBO;
                    index = 0;
                    for (int i = 0; i < checkProject.length; i++) {
                        index = Integer.parseInt(checkProject[i]);
                        userProjectsWBO = new WebBusinessObject();
                        userProjectsWBO.setAttribute("projectId", projectCode[index]);
                        userProjectsWBO.setAttribute("projectName", projectName[index]);

                        if (projectCode[index] != null && projectCode[index].equalsIgnoreCase(isDefault)) {
                            securityUser.setSiteId(projectCode[index]);
                            securityUser.setSiteName(projectName[index]);
                            userProjectsWBO.setAttribute("isDefault", "1");
                        } else {
                            userProjectsWBO.setAttribute("isDefault", "0");
                        }

                        userProjects.add(userProjectsWBO);

                        newProjects[i] = projectCode[index];
                    }

                    try {
                        // before delete any existing stores for this user in the database get current projects
                        oldProjects = userProjectsMgr.getProjectsIdForUser(userId);

                        // first, delete any existing stores for this user in the database
                        userProjectsMgr.deleteOnArbitraryKey(userId, "key1");

                        // delete all stores for any branch deleted
                        Vector<String> tmpDiff = Tools.getDifference(oldProjects, newProjects);
                        differen = new String[tmpDiff.size()];
                        for (int i = 0; i < tmpDiff.size(); i++) {
                            differen[i] = tmpDiff.get(i);
                        }
                        userStoreMgr.deleteUserStoresByBranches(userId, differen);

                        if (userProjectsMgr.saveUserProjects(userId, userProjects, isDefault, session)) {
                            request.setAttribute("Status", "ok");
                        } else {
                            request.setAttribute("Status", "no");
                        }

                    } catch (NoUserInSessionException ex) {
                        logger.error(ex.getMessage());
                    }
                    String backTo = request.getParameter("backTo");
                    //servedPage = "UsersServlet?op=assignProjects&userId=" + userId;
                    try {
                        if (backTo != null) {
                            servedPage = "UsersServlet?op=assignAdministrativeProjects&userId=" + userId;
                        } else {

                            servedPage = "UsersServlet?op=assignProjects&userId=" + userId;
                        }
                    } catch (Exception e) {
                    }
                    this.forward(servedPage, request, response);
                    break;

                case 16:
                    request.getSession().removeAttribute("sideMenuVec");
                    request.getSession().removeAttribute("currentUserID"); // remove current user ID from session
                    servedPage = null;
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 17:
                    String stringIndex = request.getParameter("index");
                    String directType = request.getParameter("directType");
                    String stringNumberOfUsers = request.getParameter("numberOfUsers");

                    long numberOfUsers = 0;
                    index = 0;
                    try {
                        index = Integer.valueOf(stringIndex).intValue();
                        numberOfUsers = Long.valueOf(stringNumberOfUsers).longValue();
                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                    }

                    if (directType != null && (directType.equalsIgnoreCase("prev") || directType.equalsIgnoreCase("next"))) {
                        if (directType.equalsIgnoreCase("next")) {
                            index++;
                            index = index % (Long.valueOf(numberOfUsers).intValue() + 1);
                            if (index < 1) {
                                index = 1;
                            }
                        } else {
                            index--;
                            if (index < 1) {
                                index = Long.valueOf(numberOfUsers).intValue();
                            }
                        }
                    }

                    userId = userMgr.getIdRecordByIndex(index);

                    userTradeWbo = userTradeMgr.getOnSingleKey1(userId);
                    while (userTradeWbo == null) {
                        if (directType.equalsIgnoreCase("next")) {
                            index++;
                            index = index % (Long.valueOf(numberOfUsers).intValue() + 1);
                            if (index < 1) {
                                index = 1;
                            }
                        } else {
                            index--;
                            if (index < 1) {
                                index = Long.valueOf(numberOfUsers).intValue();
                            }
                        }
                        userId = userMgr.getIdRecordByIndex(index);

                        userTradeWbo = userTradeMgr.getOnSingleKey1(userId);
                    }
                    if (!userId.isEmpty()) {
                        servedPage = "UsersServlet?op=ViewUser&userId=" + userId + "&index=" + index + "&numberOfUsers=" + stringNumberOfUsers;
                        this.forward(servedPage, request, response);
                    } else {
                        servedPage = "/docs/help/error.jsp";
                        request.setAttribute("page", servedPage);
                        this.forwardToServedPage(request, response);
                    }
                    break;
                case 18:
                    servedPage = "/docs/user_security/viewUser.jsp";
                    userId = request.getParameter("userId");
                    numberOfUsers_ = request.getParameter("numberOfUsers");
                    index_ = request.getParameter("index");

                    user = userMgr.getOnSingleKey(userId);
                    setRequestByProjectsForUser(request, userId);
                    setRequestByStoreForUser(request, userId);
                    setRequestByGroupsForUser(request, userId);
                    setRequestByGrantsForUser(request, userId);

                    userTradeWbo = userTradeMgr.getOnSingleKey1(userId);

                    Tools.createUserSideMenu(userId, index_, numberOfUsers_, request);

                    /*request.setAttribute("user", user);
                     request.setAttribute("trade", userTradeWbo);
                     request.setAttribute("index", request.getParameter("index"));
                     request.setAttribute("numberOfUsers", request.getParameter("numberOfUsers"));
                     request.setAttribute("page", servedPage);
                     this.forwardToServedPage(request, response);*/
                    WebBusinessObject user1 = (WebBusinessObject) request.getAttribute("user");
                    Vector<WebBusinessObject> groups = (Vector<WebBusinessObject>) request.getAttribute("groups");
                    Vector<WebBusinessObject> grants = (Vector<WebBusinessObject>) request.getAttribute("grants");
                    Vector<WebBusinessObject> projects = (Vector<WebBusinessObject>) request.getAttribute("projects");
                    Vector<WebBusinessObject> stores = (Vector<WebBusinessObject>) request.getAttribute("stores");

                    String isDefaultGroup = (String) request.getAttribute("isDefaultGroup");
                    String isDefaultProject = (String) request.getAttribute("isDefaultProject");

                    JSONSerializer serializer = new JSONSerializer();
                    Hashtable<String, Object> data = new Hashtable<String, Object>();

                    if (userTradeWbo != null) {
                        data.put("status", true);
                        data.put("user", user);
                        data.put("userName", userTradeWbo.getAttribute("userName"));

                        String email = null;
                        try {
                            email = (String) user.getAttribute("email");
                        } catch (Exception e) {
                            email = "";
                        }
                        String password = null;
                        try {
                            password = (String) user.getAttribute("password");
                        } catch (Exception e) {
                            password = "";
                        }

                        String tradeName = null;
                        try {
                            tradeName = (String) userTradeWbo.getAttribute("tradeName");
                        } catch (Exception e) {
                            tradeName = "";
                        }

                        if (email == null) {
                            email = "";
                        }
                        if (password == null) {
                            password = "";
                        }
                        if (tradeName == null) {
                            tradeName = "";
                        }

                        data.put("password", password);
                        data.put("email", email);
                        data.put("tradeName", tradeName);
                        data.put("index", index_);
                        data.put("numberOfUsers", numberOfUsers_);
                        data.put("isDefaultGroup", isDefaultGroup);
                        data.put("isDefaultProject", isDefaultProject);
                        data.put("trade", userTradeWbo);
                        data.put("numberOfUsers", request.getParameter("numberOfUsers"));
                    } else {
                        data.put("status", false);
                    }
                    response.setContentType("application/json");
                    response.setHeader("Cache-Control", "no-cache");
                    response.getWriter().write(serializer.serialize(data));
                    break;
                case 19:
                    servedPage = "/docs/user_security/viewUser.jsp";
                    userId = request.getParameter("userId");
                    numberOfUsers_ = request.getParameter("numberOfUsers");
                    index_ = request.getParameter("index");

                    user = userMgr.getOnSingleKey(userId);
                    setRequestByProjectsForUser(request, userId);
                    setRequestByStoreForUser(request, userId);
                    setRequestByGroupsForUser(request, userId);
                    setRequestByGrantsForUser(request, userId);

                    userTradeWbo = userTradeMgr.getOnSingleKey1(userId);

                    Tools.createUserSideMenu(userId, index_, numberOfUsers_, request);

                    request.setAttribute("user", user);
                    request.setAttribute("trade", userTradeWbo);
                    request.setAttribute("index", request.getParameter("index"));
                    request.setAttribute("numberOfUsers", request.getParameter("numberOfUsers"));
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 20:
                    stringIndex = request.getParameter("index");
                    directType = request.getParameter("directType");
                    stringNumberOfUsers = request.getParameter("numberOfUsers");

                    numberOfUsers = 0;
                    index = 0;
                    try {
                        index = Integer.valueOf(stringIndex).intValue();
                        numberOfUsers = Long.valueOf(stringNumberOfUsers).longValue();
                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                    }

                    if (directType != null && (directType.equalsIgnoreCase("prev") || directType.equalsIgnoreCase("next"))) {
                        if (directType.equalsIgnoreCase("next")) {
                            index++;
                            index = index % (Long.valueOf(numberOfUsers).intValue() + 1);
                            if (index < 1) {
                                index = 1;
                            }
                        } else {
                            index--;
                            if (index < 1) {
                                index = Long.valueOf(numberOfUsers).intValue();
                            }
                        }
                    }

                    userId = userMgr.getIdRecordByIndex(index);

                    userTradeWbo = userTradeMgr.getOnSingleKey1(userId);
                    while (userTradeWbo == null) {
                        if (directType.equalsIgnoreCase("next")) {
                            index++;
                            index = index % (Long.valueOf(numberOfUsers).intValue() + 1);
                            if (index < 1) {
                                index = 1;
                            }
                        } else {
                            index--;
                            if (index < 1) {
                                index = Long.valueOf(numberOfUsers).intValue();
                            }
                        }
                        userId = userMgr.getIdRecordByIndex(index);

                        userTradeWbo = userTradeMgr.getOnSingleKey1(userId);
                    }
                    if (!userId.isEmpty()) {
                        servedPage = "UsersServlet?op=ViewUserByAjax&userId=" + userId + "&index=" + index + "&numberOfUsers=" + stringNumberOfUsers;
                        this.forward(servedPage, request, response);
                    } else {
                        servedPage = "/docs/help/error.jsp";
                        request.setAttribute("page", servedPage);
                        this.forwardToServedPage(request, response);
                    }
                    break;
                case 21:
                    servedPage = "/docs/user_security/assign_user_administrative_projects.jsp";
                    userId = request.getParameter("userId");
                    userWbo = userMgr.getOnSingleKey(userId);
                    userName = "";
                    if (user != null) {
                        userName = (String) userWbo.getAttribute("userName");
                    }

                    projectMgr = ProjectMgr.getInstance();
                    projects = projectMgr.getCashedTable();
                    projects = projectMgr.getOnArbitraryKey("1", "key4");

                    request.setAttribute("allProjects", projects);
                    request.setAttribute("userId", userId);
                    request.setAttribute("userName", userName);
                    request.setAttribute("page", servedPage);

                    // get stores for this
                    setRequestByProjectsForUser(request, userId);

                    this.forwardToServedPage(request, response);
                    break;

                case 22:
                    servedPage = "docs/user_security/attach_clients_to_user.jsp";
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 23:
                    servedPage = "/docs/user_security/users_list.jsp";
                    com.silkworm.pagination.Filter filter = new com.silkworm.pagination.Filter();
                    ArrayList<FilterCondition> conditions = new ArrayList<FilterCondition>();

                    String fieldName = request.getParameter("fieldName");
                    String fieldValue = request.getParameter("fieldValue");

                    String selectionType = request.getParameter("selectionType");
                    filter = Tools.getPaginationInfo(request, response);
                    ArrayList usersList = new ArrayList<WebBusinessObject>(0);
                    userMgr = userMgr.getInstance();
                    Vector users = new Vector();
                    wbo = null;
                    String firstEmpId = request.getParameter("firstEmpId");

                    // add conditions
                    if (fieldValue != null && !fieldValue.equals("")) {
                        conditions.addAll(filter.getConditions());
                        fieldValue = Tools.getRealChar((String) fieldValue);
                        conditions.add(new FilterCondition("USER_NAME", fieldValue, Operations.LIKE));
                        filter.setConditions(conditions);
                    }

                    // grab usersList list
                    try {
                        usersList = (ArrayList) userMgr.paginationEntity(filter, "");
                        for (int i = 0; i < usersList.size(); i++) {
                            userWbo = (WebBusinessObject) usersList.get(i);
                            users = userClientsMgr.getOnArbitraryDoubleKey(
                                    firstEmpId,
                                    "key1",
                                    (String) userWbo.getAttribute("userId"),
                                    "key2");

                            if (users != null && !users.isEmpty()) {
                                wbo = (WebBusinessObject) users.get(0);
                                userWbo.setAttribute("comments",
                                        (String) wbo.getAttribute("comments"));

                            } else {
                                userWbo.setAttribute("comments", "Add comment");

                            }
                        }

                    } catch (Exception e) {
                        System.out.println(e);
                    }

                    if (selectionType == null) {
                        selectionType = "single";
                    }

                    String formName = (String) request.getParameter("formName");

                    if (formName == null) {
                        formName = "";
                    }

                    request.setAttribute("selectionType", selectionType);
                    request.setAttribute("filter", filter);
                    request.setAttribute("formName", formName);
                    request.setAttribute("usersList", usersList);
                    this.forward(servedPage, request, response);
                    break;

                case 24:
                    PrintWriter out = response.getWriter();
                    wbo = new WebBusinessObject();

                    firstEmpId = request.getParameter("userId");
                    String secondEmpId = request.getParameter("clientId");

                    String comments = request.getParameter("comments");
                    String fromDate = request.getParameter("fromDate");
                    String relationType = request.getParameter("relationType");
//                    WebBusinessObject firstEmpWbo = (WebBusinessObject) userMgr.
//                            getOnSingleKey(firstEmpId);
//                    
//                    WebBusinessObject secondEmpWbo = (WebBusinessObject) userMgr.
//                            getOnSingleKey(secondEmpId);
                    userWbo = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
                    wbo.setAttribute("createdBy", userWbo.getAttribute("userId"));
                    wbo.setAttribute("userId", firstEmpId);
                    wbo.setAttribute("clientId", secondEmpId);
                    wbo.setAttribute("comments", comments);
                    wbo.setAttribute("fromDate", fromDate);
                    wbo.setAttribute("relationType", relationType);

                    if (userClientsMgr.upsertUserClientRelation(wbo)) {
                        wbo.setAttribute("status", "Ok");

                    } else {
                        wbo.setAttribute("status", "No");

                    }

                    out.write(Tools.getJSONObjectAsString(wbo));
                    break;
                case 25:
                    servedPage = "/docs/user_security/unattached_clients_list.jsp";
                    filter = new com.silkworm.pagination.Filter();
                    selectionType = request.getParameter("selectionType");
                    filter = Tools.getPaginationInfo(request, response);

                    fieldName = request.getParameter("fieldName");
                    fieldValue = request.getParameter("fieldValue");

                    conditions = new ArrayList<FilterCondition>();
                    conditions.addAll(filter.getConditions());

                    // add conditions
                    if (fieldValue != null && !fieldValue.equals("")) {
                        fieldValue = Tools.getRealChar((String) fieldValue);
                        conditions.add(new FilterCondition("NAME", fieldValue, Operations.LIKE));

                    }

                    conditions.add(new FilterCondition("EM.ID", "", Operations.IS_NULL));
                    filter.setConditions(conditions);

                    ArrayList clientsList = new ArrayList<WebBusinessObject>(0);
                    WebBusinessObject clientWbo = new WebBusinessObject();
                    clientMgr = ClientMgr.getInstance();
                    users = new Vector();// AND EM.CLIENT_ID IS NULL
                    wbo = null;
                    firstEmpId = request.getParameter("userId");

                    // grab usersList list
                    try {
                        clientsList = (ArrayList) clientMgr.paginationEntity(filter, " LEFT JOIN USER_CLIENTS EM ON CLIENT.SYS_ID = EM.CLIENT_ID");
                        for (int i = 0; i < clientsList.size(); i++) {
                            clientWbo = (WebBusinessObject) clientsList.get(i);
                            users = userClientsMgr.getOnArbitraryDoubleKey(
                                    firstEmpId,
                                    "key1",
                                    (String) clientWbo.getAttribute("id"),
                                    "key2");

                            if (users != null && !users.isEmpty()) {
                                wbo = (WebBusinessObject) users.get(0);
                                clientWbo.setAttribute("comments",
                                        (String) wbo.getAttribute("comments"));
                                clientWbo.setAttribute("fromDate",
                                        (String) wbo.getAttribute("fromDate"));
                                clientWbo.setAttribute("relationType",
                                        (String) wbo.getAttribute("relationType"));

                            } else {
                                Calendar cal = Calendar.getInstance();
                                String jDateFormat = "yyyy/MM/dd";
                                SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
                                String nowTime = sdf.format(cal.getTime());
                                clientWbo.setAttribute("comments", "Add comment");
                                clientWbo.setAttribute("fromDate", nowTime);
                                clientWbo.setAttribute("relationType", "Select");

                            }
                        }

                    } catch (Exception e) {
                        System.out.println(e);
                    }

                    if (selectionType == null) {
                        selectionType = "single";
                    }

                    formName = (String) request.getParameter("formName");

                    if (formName == null) {
                        formName = "";
                    }

                    request.setAttribute("selectionType", selectionType);
                    request.setAttribute("filter", filter);
                    request.setAttribute("formName", formName);
                    request.setAttribute("clientsList", clientsList);
                    this.forward(servedPage, request, response);
                    break;

                case 26:
                    servedPage = "/docs/user_security/user_attached_clients_list.jsp";
                    filter = new com.silkworm.pagination.Filter();
                    selectionType = request.getParameter("selectionType");
                    filter = Tools.getPaginationInfo(request, response);

                    String user = request.getParameter("userId");

                    fieldName = request.getParameter("fieldName");
                    fieldValue = request.getParameter("fieldValue");

                    conditions = new ArrayList<FilterCondition>();
                    conditions.addAll(filter.getConditions());

                    // add conditions
                    if (fieldValue != null && !fieldValue.equals("")) {
                        fieldValue = Tools.getRealChar((String) fieldValue);
                        conditions.add(new FilterCondition("CLIENTS.NAME", fieldValue, Operations.LIKE));

                    }

                    conditions.add(new FilterCondition("S.USER_ID", user, Operations.EQUAL));
                    filter.setConditions(conditions);

                    usersList = new ArrayList<WebBusinessObject>(0);
                    users = new Vector();
                    wbo = null;
//                    firstEmpId = request.getParameter("firstEmpId");

                    // grab users list attached to this user list
                    clientsList = (ArrayList) clientMgr.paginationEntity(filter, " INNER JOIN USER_CLIENTS S ON CLIENT.SYS_ID = S.CLIENT_ID ");

                    for (int i = 0; i < clientsList.size(); i++) {
                        clientWbo = (WebBusinessObject) clientsList.get(i);
                        clientWbo.setAttribute("userId", user);
                    }
                    if (selectionType == null) {
                        selectionType = "single";
                    }

                    formName = (String) request.getParameter("formName");

                    if (formName == null) {
                        formName = "";
                    }

                    request.setAttribute("selectionType", selectionType);
                    request.setAttribute("filter", filter);
                    request.setAttribute("formName", formName);
                    request.setAttribute("clientsList", clientsList);
                    request.setAttribute("userId", user);

                    this.forward(servedPage, request, response);
                    break;

                case 27:
                    servedPage = "docs/user_security/attach_emp_to_mgr.jsp";
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 29:
                    wbo = new WebBusinessObject();

                    firstEmpId = request.getParameter("firstEmpId");
                    secondEmpId = request.getParameter("secondEmpId");

                    comments = request.getParameter("comments");

                    wbo.setAttribute("firstEmpId", firstEmpId);
                    wbo.setAttribute("secondEmpId", secondEmpId);
                    wbo.setAttribute("comments", comments);

                    if (empRelationMgr.upsertEmpRelation(wbo)) {
                        wbo.setAttribute("status", "Ok");

                    } else {
                        wbo.setAttribute("status", "No");

                    }
                    out = response.getWriter();
                    out.write(Tools.getJSONObjectAsString(wbo));
                    break;

                case 30:
                    servedPage = "/docs/user_security/unattached_employee_list.jsp";
                    filter = new com.silkworm.pagination.Filter();
                    selectionType = request.getParameter("selectionType");
                    filter = Tools.getPaginationInfo(request, response);

                    fieldName = request.getParameter("fieldName");
                    fieldValue = request.getParameter("fieldValue");

                    conditions = new ArrayList<FilterCondition>();
                    conditions.addAll(filter.getConditions());

                    // add conditions
                    if (fieldValue != null && !fieldValue.equals("")) {
                        fieldValue = Tools.getRealChar((String) fieldValue);
                        conditions.add(new FilterCondition("USER_NAME", fieldValue, Operations.LIKE));

                    }

                    conditions.add(new FilterCondition("EM.ID", "", Operations.IS_NULL));
                    conditions.add(new FilterCondition("USER_TYPE", "0", Operations.EQUAL));
                    filter.setConditions(conditions);

                    usersList = new ArrayList<WebBusinessObject>(0);
                    userMgr = userMgr.getInstance();
                    users = new Vector();
                    wbo = null;
                    firstEmpId = request.getParameter("firstEmpId");

                    // grab usersList list
                    try {
                        usersList = (ArrayList) userMgr.paginationEntity(filter, " LEFT JOIN EMP_MGR EM ON USER_ID = EM.EMP_ID ");
                        for (int i = 0; i < usersList.size(); i++) {
                            userWbo = (WebBusinessObject) usersList.get(i);
                            users = empRelationMgr.getOnArbitraryDoubleKey(
                                    firstEmpId,
                                    "key1",
                                    (String) userWbo.getAttribute("userId"),
                                    "key2");

                            if (users != null && !users.isEmpty()) {
                                wbo = (WebBusinessObject) users.get(0);
                                userWbo.setAttribute("comments",
                                        (String) wbo.getAttribute("comments"));

                            } else {
                                userWbo.setAttribute("comments", "Add comment");

                            }
                        }

                    } catch (Exception e) {
                        System.out.println(e);
                    }

                    if (selectionType == null) {
                        selectionType = "single";
                    }

                    formName = (String) request.getParameter("formName");

                    if (formName == null) {
                        formName = "";
                    }

                    request.setAttribute("selectionType", selectionType);
                    request.setAttribute("filter", filter);
                    request.setAttribute("formName", formName);
                    request.setAttribute("usersList", usersList);
                    this.forward(servedPage, request, response);
                    break;

                case 31:
                    servedPage = "/docs/user_security/user_attached_employee_list.jsp";
                    filter = new com.silkworm.pagination.Filter();
                    selectionType = request.getParameter("selectionType");
                    filter = Tools.getPaginationInfo(request, response);

                    WebBusinessObject waUser = (WebBusinessObject) session.getAttribute("loggedUser");

                    fieldName = request.getParameter("fieldName");
                    fieldValue = request.getParameter("fieldValue");

                    conditions = new ArrayList<FilterCondition>();
                    conditions.addAll(filter.getConditions());

                    // add conditions
                    if (fieldValue != null && !fieldValue.equals("")) {
                        fieldValue = Tools.getRealChar((String) fieldValue);
                        conditions.add(new FilterCondition("USER_NAME", fieldValue, Operations.LIKE));

                    }

                    conditions.add(new FilterCondition("MGR_ID", (String) waUser.getAttribute("userId"), Operations.EQUAL));
                    filter.setConditions(conditions);

                    usersList = new ArrayList<WebBusinessObject>(0);
                    users = new Vector();
                    wbo = null;
                    firstEmpId = request.getParameter("firstEmpId");

                    // grab users list attached to this user list
                    usersList = (ArrayList) userMgr.paginationEntity(filter, " INNER JOIN EMP_MGR ON EMP_ID = USER_ID ");

                    if (selectionType == null) {
                        selectionType = "single";
                    }

                    formName = (String) request.getParameter("formName");

                    if (formName == null) {
                        formName = "";
                    }

                    request.setAttribute("selectionType", selectionType);
                    request.setAttribute("filter", filter);
                    request.setAttribute("formName", formName);
                    request.setAttribute("usersList", usersList);
                    this.forward(servedPage, request, response);
                    break;

                case 32:
                    servedPage = "/docs/user_security/mgr_attached_employee_list.jsp";
                    filter = new com.silkworm.pagination.Filter();
                    selectionType = request.getParameter("selectionType");
                    filter = Tools.getPaginationInfo(request, response);

                    String mgr = request.getParameter("firstEmpId");

                    fieldName = request.getParameter("fieldName");
                    fieldValue = request.getParameter("fieldValue");

                    conditions = new ArrayList<FilterCondition>();
                    conditions.addAll(filter.getConditions());

                    // add conditions
                    if (fieldValue != null && !fieldValue.equals("")) {
                        fieldValue = Tools.getRealChar((String) fieldValue);
                        conditions.add(new FilterCondition("USER_NAME", fieldValue, Operations.LIKE));

                    }

                    conditions.add(new FilterCondition("MGR_ID", mgr, Operations.EQUAL));
                    filter.setConditions(conditions);

                    usersList = new ArrayList<WebBusinessObject>(0);
                    users = new Vector();
                    wbo = null;
//                    firstEmpId = request.getParameter("firstEmpId");

                    // grab users list attached to this user list
                    usersList = (ArrayList) userMgr.paginationEntity(filter, " INNER JOIN EMP_MGR ON EMP_ID = USER_ID ");

                    if (selectionType == null) {
                        selectionType = "single";
                    }

                    formName = (String) request.getParameter("formName");

                    if (formName == null) {
                        formName = "";
                    }

                    request.setAttribute("selectionType", selectionType);
                    request.setAttribute("filter", filter);
                    request.setAttribute("formName", formName);
                    request.setAttribute("usersList", usersList);
                    request.setAttribute("mgrId", mgr);

                    this.forward(servedPage, request, response);
                    break;

                case 33:
                    wbo = new WebBusinessObject();
//                    servedPage = "/docs/user_security/mgr_attached_employee_list.jsp";
                    String[] empToBeRemoved;
                    empToBeRemoved = request.getParameterValues("empIds");
                    String mgrID = request.getParameter("mgrId");

                    // for (int i = 0; i < empToBeRemoved.length; i++) {
                    String empId = empToBeRemoved[0];
                    empToBeRemoved = empId.split(",");
                    for (int i = 0; i < empToBeRemoved.length; i++) {
                        empId = empToBeRemoved[i];
                        if (!empId.equals("") && !empId.equals("0")) {
                            Vector empObjects = empRelationMgr.getOnArbitraryDoubleKey(empId, "key2", mgrID, "key1");
                            for (int j = 0; j < empObjects.size(); j++) {
                                wbo = (WebBusinessObject) empObjects.get(j);
                                if (empRelationMgr.deleteOnSingleKey(wbo.getAttribute("id").toString())) {
                                    wbo.setAttribute("status", "Ok");

                                } else {
                                    wbo.setAttribute("status", "No");

                                }
                            }
                        }
                    }
                    //  }
                    out = response.getWriter();

                    out.write(Tools.getJSONObjectAsString(wbo));
//                    this.forwardToServedPage(request, response);
                    break;

                case 34:
                    servedPage = "/docs/user_security/assign_user_roles.jsp";
                    userId = request.getParameter("userId");
                    userWbo = userMgr.getOnSingleKey(userId);

                    userName = "";
                    if (userWbo != null) {
                        userName = (String) userWbo.getAttribute("userName");
                    }

                    tradeMgr = TradeMgr.getInstance();
                    Vector trades = tradeMgr.getOnArbitraryKey("0", "key3");
//                    projects = projectMgr.getOnArbitraryKey("0", "key2");

                    request.setAttribute("allTrades", trades);
                    request.setAttribute("userId", userId);
                    request.setAttribute("userName", userName);
                    request.setAttribute("page", servedPage);

                    // get trades for this
                    setRequestByTradesForUser(request, userId);

                    this.forwardToServedPage(request, response);
                    break;

                case 35:
                    securityUser = (SecurityUser) session.getAttribute("securityUser");
                    userId = request.getParameter("userId");
                    isDefault = request.getParameter("isDefault");

                    String[] checkTrade = request.getParameterValues("checkTrade");
                    String[] tradeId = request.getParameterValues("tradeId");
                    String[] tradeName = request.getParameterValues("tradeName");
                    String[] tradeQual = request.getParameterValues("tradeQualification");
                    String[] note = request.getParameterValues("notes");
                    String[] realTradeId = null;
                    WebBusinessObject userTradeWBO2;
                    Vector userTrades2 = new Vector();
                    TradeMgr tradeMgr = TradeMgr.getInstance();
                    for (int i = 0; i < checkTrade.length; i++) {
                        userTradeWBO2 = new WebBusinessObject();
                        wbo = new WebBusinessObject();
                        String id = checkTrade[i];
                        userTradeWBO2 = tradeMgr.getOnSingleKey(id);
                        wbo.setAttribute("tradeId", userTradeWBO2.getAttribute("tradeId"));
                        wbo.setAttribute("tradeName", userTradeWBO2.getAttribute("tradeName"));
                        wbo.setAttribute("tradeQualification", tradeQual[i]);
                        wbo.setAttribute("notes", note[i]);
                        if (checkTrade[i] != null && checkTrade[i].equalsIgnoreCase(isDefault)) {
//                            securityUser.setSiteId(tradeId[index]);
//                            securityUser.setSiteName(projectName[index]);
                            wbo.setAttribute("isDefault", "1");
                        } else {
                            wbo.setAttribute("isDefault", "0");
                        }
                        userTrades2.add(wbo);

                    }

//                    Vector userTrades = new Vector();
//                    WebBusinessObject userTradeWBO;
//                    index = 0;
//                    for (int i = 0; i < checkTrade.length; i++) {
//                        //index = Integer.parseInt(checkTrade[i]);
//                        userTradeWBO = new WebBusinessObject();
//                        userTradeWBO.setAttribute("tradeId", checkTrade[i]);
//                        userTradeWBO.setAttribute("tradeName", tradeName[i]);
//                        userTradeWBO.setAttribute("tradeQualification", tradeQual[i]);
//                        userTradeWBO.setAttribute("notes", note[i]);
//                        if (checkTrade[i] != null && checkTrade[i].equalsIgnoreCase(isDefault)) {
////                            securityUser.setSiteId(tradeId[index]);
////                            securityUser.setSiteName(projectName[index]);
//                            userTradeWBO.setAttribute("isDefault", "1");
//                        } else {
//                            userTradeWBO.setAttribute("isDefault", "0");
//                        }
//
//                        userTrades.add(userTradeWBO);
//                    }
                    if (userTradeMgr.saveUserTrade(userId, userTrades2, isDefault, session)) {
                        request.setAttribute("Status", "ok");
                    } else {
                        request.setAttribute("Status", "no");
                    }
                    userWbo = userMgr.getOnSingleKey(userId);
                    userName = "";
                    if (userWbo != null) {
                        userName = (String) userWbo.getAttribute("userName");
                    }
                    request.setAttribute("userName", userName);
                    request.setAttribute("userId", userId);
                    tradeMgr = TradeMgr.getInstance();
                    trades = tradeMgr.getOnArbitraryKey("0", "key3");
                    request.setAttribute("allTrades", trades);
                    setRequestByTradesForUser(request, userId);
                    numberOfUsers = userMgr.countAll();
                    userList = userMgr.getCashedTable();
//                    servedPage = "/docs/Adminstration/user_list.jsp";
                    servedPage = "/docs/user_security/assign_user_roles.jsp";
//                    request.setAttribute("data", userList);
//                    request.setAttribute("numberOfUsers", numberOfUsers);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 36:

                    userMgr = UserMgr.getInstance();

                    Vector salesManagerUsers = userMgr.getSalesManagerUsers();

                    request.setAttribute("data", salesManagerUsers);
                    servedPage = "/docs/popup/sales_manager_users.jsp";
                    request.setAttribute("page", servedPage);
                    this.forward(servedPage, request, response);
                    break;
                case 37:
                    servedPage = "/docs/user_security/show_user_roles.jsp";
                    userId = request.getParameter("userId");
                    UserTradeMgr userTradeMgr1 = UserTradeMgr.getInstance();
                    trades_ = userTradeMgr.getOnArbitraryKey(userId, "key1");
                    userMgr = UserMgr.getInstance();
                    userWbo = userMgr.getOnSingleKey(userId);

                    userName = "";
                    if (userWbo != null) {
                        userName = (String) userWbo.getAttribute("userName");
                    }

                    userTradeMgr1 = userTradeMgr1.getInstance();
//                    Vector trades = userTradeMgr1.getCashedTable();
//                    projects = projectMgr.getOnArbitraryKey("0", "key2");

                    request.setAttribute("allTrades", trades_);
                    request.setAttribute("userId", userId);
                    request.setAttribute("userName", userName);
                    request.setAttribute("page", servedPage);

                    // get trades for this
                    setRequestByTradesForUser(request, userId);

                    this.forwardToServedPage(request, response);

                    break;

                case 38:
                    out = response.getWriter();
                    wbo = new WebBusinessObject();

                    firstEmpId = request.getParameter("userId");
                    secondEmpId = request.getParameter("clientId");

                    wbo.setAttribute("userId", firstEmpId);
                    wbo.setAttribute("clientId", secondEmpId);

                    if (userClientsMgr.deleteUserClientRelation(wbo)) {
                        wbo.setAttribute("status", "Ok");
                    } else {
                        wbo.setAttribute("status", "No");

                    }

                    out.write(Tools.getJSONObjectAsString(wbo));
                    break;

                case 39:
                    servedPage = "/docs/user_security/employee_list.jsp";
                    filter = new com.silkworm.pagination.Filter();
                    List<WebBusinessObject> employeeList = new ArrayList<WebBusinessObject>(0);
                    selectionType = null;
                    userMgr = UserMgr.getInstance();
                    conditions = new ArrayList<FilterCondition>();
                    String attachedEmployeesIds = null;
                    String itemNo = null;
                    String designation = null;
                    itemNo = request.getParameter("itemNo");
//                    if(itemNo!=null && !itemNo.equals("")){
//                        if(itemNo.equals("0")){
//                            designation="1";    
//                        }else if(itemNo.equals("1")){
//                            designation="3";    
//                        }else if(itemNo.equals("2")){
//                            designation="4";    
//                        }
//                    }
                    fieldName = request.getParameter("fieldName");
                    fieldValue = request.getParameter("fieldValue");

                    filter = Tools.getPaginationInfo(request, response);
                    conditions.addAll(filter.getConditions());

                    // add conditions
                    if (fieldValue != null && !fieldValue.equals("")) {
                        fieldValue = Tools.getRealChar((String) fieldValue);
                        conditions.add(new FilterCondition("USER_NAME", fieldValue, Operations.LIKE));
//                        if(designation!=null && !designation.equals("")){
//                            conditions.add(new FilterCondition("DESIGNATION", designation, Operations.EQUAL));
//                        }
                    }

                    try {
                        attachedEmployeesIds = userClientsMgr.getAttachedEmployees();

                        if (!attachedEmployeesIds.equals("")) {
                            conditions.add(new FilterCondition("USER_ID", attachedEmployeesIds, Operations.NOTIN));
//                            if(designation!=null && !designation.equals("")){
//                                conditions.add(new FilterCondition("DESIGNATION", designation, Operations.EQUAL));
//                            }
                        }
                    } catch (Exception e) {
                        System.out.println(e.getMessage());
                    }

                    filter.setConditions(conditions);

                    //grab scheduleList list
                    try {
                        employeeList = userMgr.paginationEntity(filter, "");

                    } catch (Exception e) {
                        System.out.println(e);

                    }

                    selectionType = request.getParameter("selectionType");

                    if (selectionType == null) {
                        selectionType = "single";
                    }
                    request.setAttribute("data", employeeList);
                    request.setAttribute("filter", filter);
                    request.setAttribute("itemNo", itemNo);
                    this.forward(servedPage, request, response);
                    break;
                case 40:
                    servedPage = "/docs/user_security/employee_list.jsp";
                    String tradeID = request.getParameter("tradeId");
                    UserTradeMgr userTradeMgr = UserTradeMgr.getInstance();
                    employeeList = new ArrayList<WebBusinessObject>(0);
                    Vector<WebBusinessObject> employee = new Vector();
                    userMgr = UserMgr.getInstance();
                    users = new Vector();
                    employee = userTradeMgr.getOnArbitraryKey(tradeID, "key2");
                    if (employee != null & !employee.isEmpty()) {
                        for (WebBusinessObject wbo2 : employee) {
                            empId = (String) wbo2.getAttribute("userId");
                            wbo = new WebBusinessObject();
                            wbo = userMgr.getOnSingleKey(empId);
                            employeeList.add(wbo);
                        }
                    }
                    filter = new com.silkworm.pagination.Filter();

                    selectionType = null;
                    userMgr = UserMgr.getInstance();
                    conditions = new ArrayList<FilterCondition>();
                    attachedEmployeesIds = null;
                    itemNo = null;
                    designation = null;
                    itemNo = request.getParameter("itemNo");
//                    if(itemNo!=null && !itemNo.equals("")){
//                        if(itemNo.equals("0")){
//                            designation="1";    
//                        }else if(itemNo.equals("1")){
//                            designation="3";    
//                        }else if(itemNo.equals("2")){
//                            designation="4";    
//                        }
//                    }
                    fieldName = request.getParameter("fieldName");
                    fieldValue = request.getParameter("fieldValue");

                    filter = Tools.getPaginationInfo(request, response);
                    conditions.addAll(filter.getConditions());

                    // add conditions
                    if (fieldValue != null && !fieldValue.equals("")) {
                        fieldValue = Tools.getRealChar((String) fieldValue);
                        conditions.add(new FilterCondition("USER_NAME", fieldValue, Operations.LIKE));
//                        if(designation!=null && !designation.equals("")){
//                            conditions.add(new FilterCondition("DESIGNATION", designation, Operations.EQUAL));
//                        }
                    }

                    try {
                        attachedEmployeesIds = userClientsMgr.getAttachedEmployees();

                        if (!attachedEmployeesIds.equals("")) {
                            conditions.add(new FilterCondition("USER_ID", attachedEmployeesIds, Operations.NOTIN));
//                            if(designation!=null && !designation.equals("")){
//                                conditions.add(new FilterCondition("DESIGNATION", designation, Operations.EQUAL));
//                            }
                        }
                    } catch (Exception e) {
                        System.out.println(e.getMessage());
                    }

                    filter.setConditions(conditions);

                    //grab scheduleList list
//                    try {
//                        employeeList = userMgr.paginationEntity(filter, "");
//
//                    } catch (Exception e) {
//                        System.out.println(e);
//
//                    }
                    selectionType = request.getParameter("selectionType");

                    if (selectionType == null) {
                        selectionType = "single";
                    }
                    request.setAttribute("data", employeeList);
                    request.setAttribute("filter", filter);
                    request.setAttribute("itemNo", itemNo);
                    this.forward(servedPage, request, response);
                    break;

                case 41:
                    servedPage = "docs/call_center/attach_manager_to_department.jsp";
                    Vector departments = new Vector();
                    String locationType = "div";
                    projectMgr = ProjectMgr.getInstance();
                    departments = projectMgr.getOnArbitraryKeyOrdered(locationType, "key6", "key3");

                    request.setAttribute("departments", departments);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 42:
                    servedPage = "/docs/user_security/manager_list.jsp";
                    String user_type = "1";//manager
                    employeeList = new ArrayList<WebBusinessObject>(0);
                    //Vector<WebBusinessObject> managers = new Vector();
                    userMgr = UserMgr.getInstance();
                    //users = new Vector();
//                    managers = userMgr.getOnArbitraryKey(user_type, "key2");
//                    if (managers != null & !managers.isEmpty()) {
//                        for (WebBusinessObject wbo2 : managers) {
//                            empId = (String) wbo2.getAttribute("userId");
//                            wbo = new WebBusinessObject();
//                            wbo = userMgr.getOnSingleKey(empId);
//                            employeeList.add(wbo);
//                        }
//                    }
                    filter = new com.silkworm.pagination.Filter();
                    selectionType = null;
                    userMgr = UserMgr.getInstance();
                    conditions = new ArrayList<FilterCondition>();
                    attachedEmployeesIds = null;
                    itemNo = null;
                    designation = null;
                    fieldName = request.getParameter("fieldName");
                    fieldValue = request.getParameter("fieldValue");

                    filter = Tools.getPaginationInfo(request, response);
                    conditions.addAll(filter.getConditions());
                    conditions.add(new FilterCondition("USER_TYPE", user_type, Operations.EQUAL));
                    // add conditions
                    if (fieldValue != null && !fieldValue.equals("")) {
                        fieldValue = Tools.getRealChar((String) fieldValue);
                        conditions.add(new FilterCondition("USER_NAME", fieldValue, Operations.LIKE));
                    }
                    filter.setConditions(conditions);
                    try {
                        employeeList = userMgr.paginationEntity(filter, "");
                        //attachedEmployeesIds = userClientsMgr.getAttachedEmployees();

                        //if (!attachedEmployeesIds.equals("")) {
                        //conditions.add(new FilterCondition("USER_ID", attachedEmployeesIds, Operations.NOTIN));
//                            if(designation!=null && !designation.equals("")){
//                                conditions.add(new FilterCondition("DESIGNATION", designation, Operations.EQUAL));
//                            }
                        //}
                    } catch (Exception e) {
                        System.out.println(e.getMessage());
                    }
                    selectionType = request.getParameter("selectionType");
                    if (selectionType == null) {
                        selectionType = "single";
                    }
                    request.setAttribute("data", employeeList);
                    request.setAttribute("filter", filter);
                    this.forward(servedPage, request, response);
                    break;
                case 43:
                    servedPage = "/docs/user_security/manager_list2.jsp";
                    List<WebBusinessObject> departmentss = new ArrayList<WebBusinessObject>();
                    locationType = "1363695825692";
                    projectMgr = ProjectMgr.getInstance();
                    employeeList = new ArrayList<WebBusinessObject>(0);
//                    userMgr = UserMgr.getInstance();
//                    departmentss = projectMgr.getOnArbitraryKey(main_proj_id, "key2");
//                    if (departmentss != null & !departmentss.isEmpty()) {
//                        for (WebBusinessObject wbo2 : departmentss) {
//                            empId = (String) wbo2.getAttribute("optionOne");
//                            String departmentName = (String) wbo2.getAttribute("projectName");
//                            wbo = new WebBusinessObject();
//                            wbo = userMgr.getOnSingleKey(empId);
//                            wbo.setAttribute("departmentName", departmentName);
//                            employeeList.add(wbo);
//                        }
//                    }
                    filter = new com.silkworm.pagination.Filter();

                    selectionType = null;
                    userMgr = UserMgr.getInstance();
                    conditions = new ArrayList<FilterCondition>();
                    attachedEmployeesIds = null;
                    itemNo = null;
                    designation = null;
                    itemNo = request.getParameter("itemNo");
//                    if(itemNo!=null && !itemNo.equals("")){
//                        if(itemNo.equals("0")){
//                            designation="1";    
//                        }else if(itemNo.equals("1")){
//                            designation="3";    
//                        }else if(itemNo.equals("2")){
//                            designation="4";    
//                        }
//                    }
                    fieldName = request.getParameter("fieldName");
                    fieldValue = request.getParameter("fieldValue");

                    filter = Tools.getPaginationInfo(request, response);
                    conditions.addAll(filter.getConditions());
                    conditions.add(new FilterCondition("MAIN_PTOJ_ID", locationType, Operations.LIKE));
                    // add conditions
                    if (fieldValue != null && !fieldValue.equals("")) {
                        fieldValue = Tools.getRealChar((String) fieldValue);
                        conditions.add(new FilterCondition("us.USER_NAME", fieldValue, Operations.LIKE));
//                        if(designation!=null && !designation.equals("")){
//                            conditions.add(new FilterCondition("DESIGNATION", designation, Operations.EQUAL));
//                        }
                    }
                    try {
                        departmentss = projectMgr.paginationEntity(filter, " LEFT JOIN USERS us ON OPTION_ONE = us.USER_ID");
                        if (departmentss != null & !departmentss.isEmpty()) {
                            for (WebBusinessObject wbo2 : departmentss) {
                                empId = (String) wbo2.getAttribute("optionOne");
                                String departmentName = (String) wbo2.getAttribute("projectName");
                                wbo = new WebBusinessObject();
                                wbo = userMgr.getOnSingleKey(empId);
                                wbo.setAttribute("departmentName", departmentName);
                                employeeList.add(wbo);
                            }
                        }
//                        attachedEmployeesIds = userClientsMgr.getAttachedEmployees();
//
//                        if (!attachedEmployeesIds.equals("")) {
//                            conditions.add(new FilterCondition("USER_ID", attachedEmployeesIds, Operations.NOTIN));
////                            if(designation!=null && !designation.equals("")){
////                                conditions.add(new FilterCondition("DESIGNATION", designation, Operations.EQUAL));
////                            }
//                        }
                    } catch (Exception e) {
                        System.out.println(e.getMessage());
                    }

                    filter.setConditions(conditions);

                    //grab scheduleList list
//                    try {
//                        employeeList = userMgr.paginationEntity(filter, "");
//
//                    } catch (Exception e) {
//                        System.out.println(e);
//
//                    }
                    selectionType = request.getParameter("selectionType");

                    if (selectionType == null) {
                        selectionType = "single";
                    }
                    request.setAttribute("data", employeeList);
                    request.setAttribute("filter", filter);
                    request.setAttribute("itemNo", itemNo);
		    
		    request.setAttribute("pgTyp", request.getParameter("pgTyp"));
		    request.setAttribute("empID", request.getParameter("empID"));
		    
                    this.forward(servedPage, request, response);
                    break;

                case 44:
                    servedPage = "/docs/Adminstration/update_basic_data.jsp";
                    userId = request.getParameter("userId");
                    numberOfUsers_ = request.getParameter("numberOfUsers");
                    index_ = request.getParameter("index");
                    Tools.createUserSideMenu(userId, index_, numberOfUsers_, request);
                    userGroupMgr = UserGroupMgr.getInstance();
                    userGroup = new Vector();
                    siteWbo = new WebBusinessObject();
                    projectMgr = ProjectMgr.getInstance();
                    userMgr = UserMgr.getInstance();
                    userWbo = userMgr.getOnSingleKey(userId);
                    try {
                        userGroup = userGroupMgr.getOnArbitraryKey(userId, "refintegkey");
                    } catch (SQLException ex) {
                        logger.error(ex.getMessage());
                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                    }
                    viewIsDefualt = false;
                    uGroupWbo = new WebBusinessObject();
                    if (userGroup.size() > 0) {
                        uGroupWbo = (WebBusinessObject) userGroup.get(0);
                        if (uGroupWbo.getAttribute("isDefault") != null) {
                            viewIsDefualt = true;
                        }
                    }
                    filterQuery = new FilterQuery();
                    tagValueList.clear();
                    filterList.clear();
                    tagValueList = filterQuery.getFilterList();
                    for (int i = 0; i < tagValueList.size(); i++) {
                        filterList.add(tagValueList.get(i));
                    }
                    request.setAttribute("filterList", filterList);

                    projectId = (String) uGroupWbo.getAttribute("projectID");
                    siteWbo = projectMgr.getOnSingleKey(projectId);
                    searchBy = uGroupWbo.getAttribute("searchBy").toString();
                    if (siteWbo != null) {
                        userWbo.setAttribute("site", siteWbo.getAttribute("projectName").toString());
                        userWbo.setAttribute("siteId", siteWbo.getAttribute("projectID").toString());
                    }
                    userWbo.setAttribute("searchBy", searchBy);
                    sites = new ArrayList();
                    sites = projectMgr.getAllMngmntProjects();
                    request.setAttribute("userId", userId);
                    request.setAttribute("sites", sites);
                    request.setAttribute("user", userWbo);
                    request.setAttribute("viewIsDefualt", viewIsDefualt);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 45:
                    servedPage = "/docs/Adminstration/update_basic_data.jsp";
                    userTradesArr = (String[]) request.getParameterValues("userTrades");
                    String isSuperUser = null;
                    if (request.getParameter("isSuperUser") != null && !request.getParameter("isSuperUser").equals("")) {
                        isSuperUser = "1";
                    } else {
                        isSuperUser = "0";
                    }
                    userMgr = UserMgr.getInstance();
                    userWbo = (WebBusinessObject) userMgr.getOnSingleKey(userId);
                    try {
                        if (!userMgr.isUserNameExist(userId, request.getParameter("userName"))) {
                            userWbo.setAttribute("userName", request.getParameter("userName"));
                            userWbo.setAttribute("email", request.getParameter("email"));
                            userWbo.setAttribute("fullName", request.getParameter("fullName"));
                            userWbo.setAttribute("userId", userWbo.getAttribute("userId").toString());
                            userWbo.setAttribute("isSuperUser", isSuperUser);
                            userWbo.setAttribute("isManager", request.getParameter("isManager"));
                            userWbo.setAttribute("canSendEmail", request.getParameter("SIPID"));
                            userMgr.updateBaidData(userWbo, defaultGroupCode, session);
                            request.setAttribute("status", "ok");
                        } else {
                            request.setAttribute("status", "no");
                            request.setAttribute("doubleName", "doubleName");
                        }
                    } catch (Exception ex) {
                        logger.error(ex);
                    }
                    request.setAttribute("user", userWbo);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 46:
                    servedPage = "/docs/Adminstration/update_password.jsp";
                    userId = request.getParameter("userId");
                    numberOfUsers_ = request.getParameter("numberOfUsers");
                    index_ = request.getParameter("index");
                   // Tools.createUserSideMenu(userId, index_, numberOfUsers_, request);
                    userGroupMgr = UserGroupMgr.getInstance();
                    userGroup = new Vector();
                    siteWbo = new WebBusinessObject();
                    projectMgr = ProjectMgr.getInstance();
                    userMgr = UserMgr.getInstance();
                    userWbo = userMgr.getOnSingleKey(userId);
                    try {
                        userGroup = userGroupMgr.getOnArbitraryKey(userId, "refintegkey");
                    } catch (SQLException ex) {
                        logger.error(ex.getMessage());
                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                    }
                    viewIsDefualt = false;
                    uGroupWbo = new WebBusinessObject();
                    if (userGroup.size() > 0) {
                        uGroupWbo = (WebBusinessObject) userGroup.get(0);
                        if (uGroupWbo.getAttribute("isDefault") != null) {
                            viewIsDefualt = true;
                        }
                    }
                    filterQuery = new FilterQuery();
                    tagValueList.clear();
                    filterList.clear();
                    tagValueList = filterQuery.getFilterList();
                    for (int i = 0; i < tagValueList.size(); i++) {
                        filterList.add(tagValueList.get(i));
                    }
                    request.setAttribute("filterList", filterList);

                    projectId = (String) uGroupWbo.getAttribute("projectID");
                    siteWbo = projectMgr.getOnSingleKey(projectId);
                    searchBy = uGroupWbo.getAttribute("searchBy").toString();
                    if (siteWbo != null) {
                        userWbo.setAttribute("site", siteWbo.getAttribute("projectName").toString());
                        userWbo.setAttribute("siteId", siteWbo.getAttribute("projectID").toString());
                    }
                    userWbo.setAttribute("searchBy", searchBy);
                    sites = new ArrayList();
                    sites = projectMgr.getAllMngmntProjects();
                    request.setAttribute("userId", userId);
                    request.setAttribute("sites", sites);
                    request.setAttribute("user", userWbo);
                    request.setAttribute("viewIsDefualt", viewIsDefualt);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 47:
                    servedPage = "/docs/Adminstration/update_password.jsp";
                    userTradesArr = (String[]) request.getParameterValues("userTrades");
                    try {
                        userTradeMgr = UserTradeMgr.getInstance();
                        userMgr = UserMgr.getInstance();

                        userWbo = (WebBusinessObject) userMgr.getOnSingleKey(request.getParameter("userId"));
                        userWbo.setAttribute("password", request.getParameter("password"));
//                        userWbo.setAttribute("password", EncryptUtil.encryptString(request.getParameter("password"))); // for encryption
                        userWbo.setAttribute("userId", userWbo.getAttribute("userId").toString());
                        userMgr.updatePassword(userWbo, defaultGroupCode, session);
                        request.setAttribute("user", userWbo);
                        request.setAttribute("status", "ok");
                        request.setAttribute("page", servedPage);
                        this.forwardToServedPage(request, response);

                    } catch (Exception Ex) {
                        shipBack(Ex.getMessage(), request, response);
                    }
                    break;

                case 48:
                    servedPage = "/docs/Adminstration/update_user_group.jsp";
                    userId = request.getParameter("userId");
                    numberOfUsers_ = request.getParameter("numberOfUsers");
                    index_ = request.getParameter("index");
                    Tools.createUserSideMenu(userId, index_, numberOfUsers_, request);
                    userGroupMgr = UserGroupMgr.getInstance();
                    userGroup = new Vector();
                    siteWbo = new WebBusinessObject();
                    projectMgr = ProjectMgr.getInstance();
                    userMgr = UserMgr.getInstance();
                    userWbo = userMgr.getOnSingleKey(userId);
                    try {
                        userGroup = userGroupMgr.getOnArbitraryKey(userId, "refintegkey");
                    } catch (SQLException ex) {
                        logger.error(ex.getMessage());
                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                    }
                    viewIsDefualt = false;
                    uGroupWbo = new WebBusinessObject();
                    if (userGroup.size() > 0) {
                        uGroupWbo = (WebBusinessObject) userGroup.get(0);
                        if (uGroupWbo.getAttribute("isDefault") != null) {
                            viewIsDefualt = true;
                        }
                    }
                    filterQuery = new FilterQuery();
                    tagValueList.clear();
                    filterList.clear();
                    tagValueList = filterQuery.getFilterList();
                    for (int i = 0; i < tagValueList.size(); i++) {
                        filterList.add(tagValueList.get(i));
                    }
                    request.setAttribute("filterList", filterList);

                    projectId = (String) uGroupWbo.getAttribute("projectID");
                    siteWbo = projectMgr.getOnSingleKey(projectId);
                    searchBy = (String) uGroupWbo.getAttribute("searchBy");
                    if (siteWbo != null) {
                        userWbo.setAttribute("site", siteWbo.getAttribute("projectName").toString());
                        userWbo.setAttribute("siteId", siteWbo.getAttribute("projectID").toString());
                    }
                    userWbo.setAttribute("searchBy", searchBy != null ? searchBy : "");
                    sites = new ArrayList();
                    sites = projectMgr.getAllMngmntProjects();
                    request.setAttribute("userId", userId);
                    request.setAttribute("sites", sites);
                    request.setAttribute("user", userWbo);
                    request.setAttribute("viewIsDefualt", viewIsDefualt);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 49:
                    servedPage = "/docs/Adminstration/update_user_group.jsp";
                    userTradesArr = (String[]) request.getParameterValues("userTrades");

                    defaultGroupList = (String[]) request.getParameterValues("isDefault");
                    defaultGroupCode = defaultGroupList[0];

                    filterQuery = new FilterQuery();
                    tagValueList.clear();
                    filterList.clear();
                    tagValueList = filterQuery.getFilterList();

                    request.setAttribute("filterList", filterList);
                    userMgr = UserMgr.getInstance();
                    userWbo = (WebBusinessObject) userMgr.getOnSingleKey(request.getParameter("userId"));
//                        userWbo.setAttribute("password", request.getParameter("password"));
//                        userWbo.setAttribute("email", request.getParameter("email"));
//                        userWbo.setAttribute("fullName", request.getParameter("fullName"));
                    userWbo.setAttribute("siteId", "UL");
                    userWbo.setAttribute("searchBy", "UL");
                    userWbo.setAttribute("userId", userWbo.getAttribute("userId").toString());
                    userGroupsArr = (String[]) request.getParameterValues("userGroups");
//                        userGrantsArr = (String[]) request.getParameterValues("grantUser");
                    ArrayList cashedGroups = groupMgr.getCashedTableAsBusObjects();
                    wboc = new WebBusinessObjectsContainer(cashedGroups);
                    ArrayList subsetGroups = wboc.getContainerSubset(userGroupsArr);
                    userGroupMgr.deleteOnArbitraryKey(userWbo.getAttribute("userId").toString(), "refintegkey");
                    userMgr.updateUserAndGroups(userWbo, subsetGroups, defaultGroupCode, session);

                    // Get Group Data  /
                    userGroupMgr = UserGroupMgr.getInstance();
                    userGroup = new Vector();
                    siteWbo = new WebBusinessObject();
                    projectMgr = ProjectMgr.getInstance();
                    userMgr = UserMgr.getInstance();
                    userWbo = userMgr.getOnSingleKey(userId);
                    try {
                        userGroup = userGroupMgr.getOnArbitraryKey(userId, "refintegkey");
                    } catch (SQLException ex) {
                        logger.error(ex.getMessage());
                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                    }
                    viewIsDefualt = false;
                    uGroupWbo = new WebBusinessObject();
                    if (userGroup.size() > 0) {
                        uGroupWbo = (WebBusinessObject) userGroup.get(0);
                        if (uGroupWbo.getAttribute("isDefault") != null) {
                            viewIsDefualt = true;
                        }
                    }
                    filterQuery = new FilterQuery();
                    tagValueList.clear();
                    filterList.clear();
                    tagValueList = filterQuery.getFilterList();
                    for (int i = 0; i < tagValueList.size(); i++) {
                        filterList.add(tagValueList.get(i));
                    }
                    request.setAttribute("filterList", filterList);

                    projectId = (String) uGroupWbo.getAttribute("projectID");
                    siteWbo = projectMgr.getOnSingleKey(projectId);
                    searchBy = uGroupWbo.getAttribute("searchBy").toString();
                    if (siteWbo != null) {
                        userWbo.setAttribute("site", siteWbo.getAttribute("projectName").toString());
                        userWbo.setAttribute("siteId", siteWbo.getAttribute("projectID").toString());
                    }
                    userWbo.setAttribute("searchBy", searchBy);
                    sites = new ArrayList();
                    sites = projectMgr.getAllMngmntProjects();
                    request.setAttribute("userId", userId);
                    request.setAttribute("sites", sites);
                    request.setAttribute("user", userWbo);
                    request.setAttribute("viewIsDefualt", viewIsDefualt);
                    request.setAttribute("status", "ok");
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);

                    ///////////
                    break;
                case 50:
                    out = response.getWriter();
                    wbo = new WebBusinessObject();
                    String groupId = request.getParameter("groupId");
                    try {
                        securityUser = (SecurityUser) session.getAttribute("securityUser");
                        loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                        wbo = groupMgr.getOnSingleKey(groupId);
                        securityUser.setUserGroupId(groupId);
                        loggedUser.setAttribute("groupID", groupId);
                        if (wbo != null) {
                            securityUser.setUserGroupName(wbo.getAttribute("groupName").toString());
                            com.silkworm.business_objects.secure_menu.MenuBuilder menuBuilder = new com.silkworm.business_objects.secure_menu.MenuBuilder();
                            menuBuilder.setXslFile(web_inf_path + "/menu.xsl");
                            securityUser.setMenuString(menuBuilder.buildMenu((String) wbo.getAttribute("groupMenu")));
                            menuBuilder.setXslFile(web_inf_path + "/menu_en.xsl");
                            securityUser.setMenuEnString(menuBuilder.buildMenu((String) wbo.getAttribute("groupMenu")));
                            loggedUser.setAttribute("groupName", wbo.getAttribute("groupName").toString());
                            servedPage = (String) wbo.getAttribute("defaultPage");
                        }

                        try {
                            servletContext = session.getServletContext();
                            String menu = groupMgr.getByKeyColumnValue(groupId, "key2");
                            ThreeDimensionMenu tdm = (ThreeDimensionMenu) servletContext.getAttribute("myMenu");
                            loggedUser.setAttribute("groupMenu", menu);
                            tdm.applySecurityPolicy(menu);
                            if (!tdm.isContextInitilaized()) {
                                tdm.insertContext();
                            }
                        } catch (Exception ex) {
                            logger.error(ex);
                        }

                        session.setAttribute("securityUser", securityUser);
                        session.setAttribute("loggedUser", loggedUser);
                        wbo.setAttribute("status", "ok");
                    } catch (Exception e) {
                        wbo.setAttribute("status", "failed");
                    }
                    out.write(Tools.getJSONObjectAsString(wbo));
                    break;

                case 51:
                    servedPage = "/docs/user_security/assign_user_company_projects.jsp";
                    userId = request.getParameter("userId");
                    userWbo = userMgr.getOnSingleKey(userId);
                    userName = "";
                    if (userWbo != null) {
                        userName = (String) userWbo.getAttribute("userName");
                    }

                    projectMgr = ProjectMgr.getInstance();
                    projects = projectMgr.getOnArbitraryKeyOracle("44", "key6");
                    projectsV = new Vector<WebBusinessObject>();
                    Vector companyProjectsName = new Vector<String>();
                    UserCompanyProjectsMgr userCompanyProjectsMgr = UserCompanyProjectsMgr.getInstance();
                    try {
                        projectsV = userCompanyProjectsMgr.getOnArbitraryKey(userId, "key1");
                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                    }

                    for (WebBusinessObject wboProject : projectsV) {
                        companyProjectsName.addElement((String) wboProject.getAttribute("projectID"));
                        if ("1".equalsIgnoreCase((String) wboProject.getAttribute("isDefault"))) {
                            isDefault = (String) wboProject.getAttribute("projectID");
                        }
                    }

                    tradeMgr = TradeMgr.getInstance();
                    request.setAttribute("trades", new ArrayList(tradeMgr.getOnArbitraryKeyOracle("0", "key4")));

                    request.setAttribute("companyProjectsForUser", companyProjectsName);
                    request.setAttribute("isDefaultProject", isDefault);
                    request.setAttribute("allProjects", projects);
                    request.setAttribute("userId", userId);
                    request.setAttribute("userName", userName);
                    request.setAttribute("page", servedPage);

                    this.forwardToServedPage(request, response);
                    break;

                case 52:
                    securityUser = (SecurityUser) session.getAttribute("securityUser");
                    userId = request.getParameter("userId");
                    isDefault = request.getParameter("isDefault");
                    checkProject = request.getParameterValues("checkProject");
                    projectCode = request.getParameterValues("projectCode");
                    projectName = request.getParameterValues("projectName");
                    String[] fromDay = request.getParameterValues("fromDay");
                    String[] toDay = request.getParameterValues("toDay");
                    String[] trade = request.getParameterValues("trade");
                    newProjects = new String[checkProject != null ? checkProject.length : 0];
                    oldProjects = null;
                    differen = null;

                    Vector userCompanyProjects = new Vector();
                    WebBusinessObject userCompanyProjectsWBO;
//                    String tempFrom;
//                    String tempTo;
//                    String tempTrade;
                    index = 0;
                    if (checkProject != null) {
                        for (int i = 0; i < checkProject.length; i++) {
                            index = Integer.parseInt(checkProject[i]) - 1;
                            userCompanyProjectsWBO = new WebBusinessObject();
                            userCompanyProjectsWBO.setAttribute("projectId", projectCode[index]);
                            userCompanyProjectsWBO.setAttribute("projectName", projectName[index]);
                            //                        tempFrom = request.getParameter("fromDay"+index);
                            //                        tempTo = request.getParameter("toDay"+index);
                            //                        tempTrade = request.getParameter("trade"+index);
                            if (projectCode[index] != null && projectCode[index].equalsIgnoreCase(isDefault)) {
                                //                            securityUser.setSiteId(projectCode[index]);
                                //                            securityUser.setSiteName(projectName[index]);
                                userCompanyProjectsWBO.setAttribute("isDefault", "1");
                            } else {
                                userCompanyProjectsWBO.setAttribute("isDefault", "0");
                            }
                            userCompanyProjectsWBO.setAttribute("relatedFrom", fromDay[index]);
                            userCompanyProjectsWBO.setAttribute("relatedTo", toDay[index]);
                            userCompanyProjectsWBO.setAttribute("trade", trade[index]);
                            userCompanyProjects.add(userCompanyProjectsWBO);

                            newProjects[i] = projectCode[index];
                        }
                    }
                    userCompanyProjectsMgr = UserCompanyProjectsMgr.getInstance();
                    try {
                        // before delete any existing stores for this user in the database get current projects
                        oldProjects = userCompanyProjectsMgr.getProjectsIdForUser(userId);

                        // first, delete any existing stores for this user in the database
                        userCompanyProjectsMgr.deleteOnArbitraryKey(userId, "key1");

                        // delete all stores for any branch deleted
                        Vector<String> tmpDiff = Tools.getDifference(oldProjects, newProjects);
                        differen = new String[tmpDiff.size()];
                        for (int i = 0; i < tmpDiff.size(); i++) {
                            differen[i] = tmpDiff.get(i);
                        }
//                        userStoreMgr.deleteUserStoresByBranches(userId, differen);

                        if (userCompanyProjectsMgr.saveUserProjects(userId, userCompanyProjects, isDefault, session)) {
                            request.setAttribute("Status", "ok");
                        } else if (checkProject == null) {
                            request.setAttribute("Status", "ok");
                        } else {
                            request.setAttribute("Status", "no");
                        }
                        tradeMgr = TradeMgr.getInstance();
                        request.setAttribute("trades", new ArrayList(tradeMgr.getOnArbitraryKeyOracle("0", "key4")));

                    } catch (NoUserInSessionException ex) {
                        logger.error(ex.getMessage());
                    }
                    backTo = request.getParameter("backTo");
                    //servedPage = "UsersServlet?op=assignProjects&userId=" + userId;
                    try {
                        if (backTo != null) {
                            servedPage = "UsersServlet?op=assignAdministrativeProjects&userId=" + userId;
                        } else {

                            servedPage = "UsersServlet?op=assignProjectOfCompany&userId=" + userId;
                        }
                    } catch (Exception e) {
                    }
                    this.forward(servedPage, request, response);
                    break;

                case 53:
                    out = response.getWriter();
                    wbo = new WebBusinessObject();
                    try {
                        securityUser = (SecurityUser) session.getAttribute("securityUser");
                        projectId = request.getParameter("projectId");
                        loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                        wbo = projectMgr.getOnSingleKey(projectId);
                        securityUser.setSiteId(projectId);
                        loggedUser.setAttribute("projectID", projectId);
                        if (wbo != null) {
                            securityUser.setSiteName(wbo.getAttribute("projectName").toString());
                            securityUser.setSiteId(projectId);
                            loggedUser.setAttribute("projectName", wbo.getAttribute("projectName").toString());
                            servedPage = (String) wbo.getAttribute("projectName");
                        }

                        session.setAttribute("securityUser", securityUser);
                        session.setAttribute("loggedUser", loggedUser);
                        wbo.setAttribute("status", "ok");
                    } catch (Exception e) {
                        wbo.setAttribute("status", "failed");
                    }
                    out.write(Tools.getJSONObjectAsString(wbo));
                    break;

                case 54:
                    out = response.getWriter();
                    wbo = new WebBusinessObject();
                    try {
                        securityUser = (SecurityUser) session.getAttribute("securityUser");
                        securityUser.setCanRunCampaignMode(!securityUser.isCanRunCampaignMode());

                        session.setAttribute("securityUser", securityUser);
                        wbo.setAttribute("status", "ok");
                    } catch (Exception e) {
                        wbo.setAttribute("status", "failed");
                    }
                    out.write(Tools.getJSONObjectAsString(wbo));
                    break;

                case 55:
                    out = response.getWriter();
                    WebBusinessObject campaignWbo = new WebBusinessObject();
                    securityUser = (SecurityUser) session.getAttribute("securityUser");
                    securityUser.setCallcenterMode(request.getParameter("modeValue"));
                    campaignWbo.setAttribute("status", "ok");
                    campaignWbo.setAttribute("callCenterMode", request.getParameter("modeValue"));
                    session.setAttribute("securityUser", securityUser);
                    out.write(Tools.getJSONObjectAsString(campaignWbo));
                    break;

                case 56:
                    out = response.getWriter();
                    securityUser = (SecurityUser) session.getAttribute("securityUser");
                    securityUser.setDefaultNewClientDistribution(request.getParameter("modeValue"));
                    wbo = new WebBusinessObject();
                    wbo.setAttribute("status", "ok");
                    session.setAttribute("securityUser", securityUser);
                    out.write(Tools.getJSONObjectAsString(wbo));
                    break;

                case 57:
                    out = response.getWriter();
                    userWbo = new WebBusinessObject();
                    long maxUsersNum = 250;
                    //try {
                    //    maxUsersNum = Long.parseLong(MetaDataMgr.getInstance().getMaxUsersNum(), 2);
                    //} catch (NumberFormatException nfe) {

                    //}
                    if (request.getParameter("newStatus").equals("22") || userMgr.getActiveUsersCount() < maxUsersNum) {
                        SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
                        IssueStatusMgr issueStatusMgr = IssueStatusMgr.getInstance();
                        userWbo.setAttribute("businessObjectId", request.getParameter("userID"));
                        userWbo.setAttribute("objectType", CRMConstants.OBJECT_TYPE_USER);
                        userWbo.setAttribute("statusCode", request.getParameter("newStatus"));
                        userWbo.setAttribute("date", sdf.format(Calendar.getInstance().getTime()));
                        userWbo.setAttribute("parentId", "UL");
                        userWbo.setAttribute("issueTitle", "UL");
                        userWbo.setAttribute("statusNote", "UL");
                        userWbo.setAttribute("cuseDescription", "UL");
                        userWbo.setAttribute("actionTaken", "UL");
                        userWbo.setAttribute("preventionTaken", "UL");
                        if (issueStatusMgr.changeStatus(userWbo, persistentUser, null)) {
                            userWbo.setAttribute("status", "Ok");
                        } else {
                            userWbo.setAttribute("status", "faild");
                        }
                    } else {
                        userWbo.setAttribute("status", "maxUserExceed");
                        userWbo.setAttribute("maxUsersNum", maxUsersNum + "");
                    }
                    out.write(Tools.getJSONObjectAsString(userWbo));
                    break;

                case 58:
                    out = response.getWriter();
                    securityUser = (SecurityUser) session.getAttribute("securityUser");
                    securityUser.setCanRunAutoPilotMode("1".equalsIgnoreCase(request.getParameter("modeValue")));
                    wbo = new WebBusinessObject();
                    wbo.setAttribute("status", "ok");
                    session.setAttribute("securityUser", securityUser);
                    out.write(Tools.getJSONObjectAsString(wbo));
                    break;

                case 59:
                    servedPage = "/docs/Adminstration/update_business_process.jsp";

                    userMgr = UserMgr.getInstance();
                    closureConfigMgr = ClosureConfigMgr.getInstance();
                    userClosureConfig = UserClosureConfigMgr.getInstance();

                    closureConfigVec = new Vector();
                    userClosure = new Vector();
                    closures = new Vector();

                    siteWbo = new WebBusinessObject();
                    projectMgr = ProjectMgr.getInstance();

                    //get request params
                    userId = request.getParameter("userId");
                    numberOfUsers_ = request.getParameter("numberOfUsers");
                    index_ = request.getParameter("index");

                    //Get Side Menu
                    Tools.createUserSideMenu(userId, index_, numberOfUsers_, request);

                    //Get User Wbo
                    userWbo = userMgr.getOnSingleKey(userId);

                    //Get Closure Config List
                    closureConfigVec = closureConfigMgr.getCashedTable();

                    if (closureConfigVec.size() > 0 && closureConfigVec != null) {
                        for (int i = 0; i < closureConfigVec.size(); i++) {
                            WebBusinessObject closureWbo = (WebBusinessObject) closureConfigVec.get(i);
                            WebBusinessObject userClosureWbo = userClosureConfig.getUserClosures(userId, closureWbo.getAttribute("id").toString());

                            if (userClosureWbo != null) {
                                closureWbo.setAttribute("isDefault", userClosureWbo.getAttribute("isDefault").toString());
                                closureWbo.setAttribute("included", "1");
                            } else {
                                closureWbo.setAttribute("isDefault", "0");
                                closureWbo.setAttribute("included", "0");
                            }

                            closures.add(closureWbo);
                        }
                    }

                    request.setAttribute("status", null);
                    request.setAttribute("user", userWbo);
                    request.setAttribute("closureConfigList", closures);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 60:
                    servedPage = "/docs/Adminstration/update_business_process.jsp";

                    filterQuery = new FilterQuery();
                    tagValueList.clear();
                    filterList.clear();
                    tagValueList = filterQuery.getFilterList();

                    request.setAttribute("filterList", filterList);
                    userMgr = UserMgr.getInstance();
                    userId = request.getParameter("userId");
                    String userMgrT = request.getParameter("requestType");
                    userWbo = (WebBusinessObject) userMgr.getOnSingleKey(request.getParameter("userId"));
                    userWbo.setAttribute("siteId", "UL");
                    userWbo.setAttribute("searchBy", "UL");
                    userWbo.setAttribute("userId", userWbo.getAttribute("userId").toString());

                    userClosureConfig.deleteOnArbitraryKey(userId, "key2");

                        WebBusinessObject userClosureWbo = new WebBusinessObject();
                        userClosureWbo.setAttribute("closureId", userMgrT);
                        userClosureWbo.setAttribute("userId", userId);
                        userClosureWbo.setAttribute("isDefualt", "1");

                        result = userClosureConfig.saveUserClosure(userClosureWbo);

                    if (result == true) {
                        request.setAttribute("status", "ok");
                    } else {
                        userClosureConfig.deleteOnArbitraryKey(userId, "key2");
                        request.setAttribute("status", "no");
                    }

                    request.setAttribute("user", userWbo);
                    request.setAttribute("closureConfigList", closures);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 61:
                    servedPage = "/docs/Adminstration/update_groups_reports.jsp";

                    userMgr = UserMgr.getInstance();
                    groupMgr = GroupMgr.getInstance();
                    userGroupConfigMgr = UserGroupConfigMgr.getInstance();

                    groupsVec = new Vector();
                    userGroupsConfigVec = new Vector();
                    repsGroups = new Vector();

                    //get request params
                    userId = request.getParameter("userId");
                    numberOfUsers_ = request.getParameter("numberOfUsers");
                    index_ = request.getParameter("index");

                    //Get Side Menu
                    Tools.createUserSideMenu(userId, index_, numberOfUsers_, request);

                    //Get User Wbo
                    userWbo = userMgr.getOnSingleKey(userId);

                    //Get Groups List
                    groupMgr.cashData();
                    groupsVec = groupMgr.getCashedTable();

                    if (groupsVec.size() > 0 && groupsVec != null) {
                        for (int i = 0; i < groupsVec.size(); i++) {
                            WebBusinessObject groupWbo = (WebBusinessObject) groupsVec.get(i);
                            WebBusinessObject userRepGroupWbo = userGroupConfigMgr.getUserGroupConfig(userId, groupWbo.getAttribute("groupID").toString());

                            if (userRepGroupWbo != null) {
                                groupWbo.setAttribute("isDefault", userRepGroupWbo.getAttribute("isDefault").toString());
                                groupWbo.setAttribute("included", "1");
                            } else {
                                groupWbo.setAttribute("isDefault", "0");
                                groupWbo.setAttribute("included", "0");
                            }

                            repsGroups.add(groupWbo);
                        }
                    }

                    request.setAttribute("status", null);
                    request.setAttribute("user", userWbo);
                    request.setAttribute("repsGroupsList", repsGroups);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 62:
                    servedPage = "/docs/Adminstration/update_groups_reports.jsp";

                    filterQuery = new FilterQuery();
                    tagValueList.clear();
                    filterList.clear();
                    tagValueList = filterQuery.getFilterList();

                    request.setAttribute("filterList", filterList);
                    userMgr = UserMgr.getInstance();
                    userId = request.getParameter("userId");
                    userWbo = (WebBusinessObject) userMgr.getOnSingleKey(request.getParameter("userId"));
                    userWbo.setAttribute("siteId", "UL");
                    userWbo.setAttribute("searchBy", "UL");
                    userWbo.setAttribute("userId", userWbo.getAttribute("userId").toString());

                    String[] repsGroupsList = (String[]) request.getParameterValues("isDefault");
                    defaultGroupCode = repsGroupsList[0];
                    userGroupsArr = (String[]) request.getParameterValues("userGroups");

                    userGroupConfigMgr.deleteOnArbitraryKey(userId, "key2");

                    for (int i = 0; i < userGroupsArr.length; i++) {
                        WebBusinessObject userGroupWbo = new WebBusinessObject();
                        userGroupWbo.setAttribute("groupId", userGroupsArr[i]);
                        userGroupWbo.setAttribute("userId", userId);
                        if (userGroupsArr[i].equals(defaultGroupCode)) {
                            userGroupWbo.setAttribute("isDefualt", "1");
                        } else {
                            userGroupWbo.setAttribute("isDefualt", "0");
                        }

                        result = userGroupConfigMgr.saveUserGroupsConfig(userGroupWbo);
                    }

                    if (result == true) {
                        request.setAttribute("status", "ok");
                    } else {
                        userClosureConfig.deleteOnArbitraryKey(userId, "key2");
                        request.setAttribute("status", "no");
                    }

                    userMgr = UserMgr.getInstance();
                    groupMgr = GroupMgr.getInstance();
                    userGroupConfigMgr = UserGroupConfigMgr.getInstance();

                    groupsVec = new Vector();
                    userGroupsConfigVec = new Vector();
                    repsGroups = new Vector();

                    //Get User Wbo
                    userWbo = userMgr.getOnSingleKey(userId);

                    //Get Groups List
                    groupMgr.cashData();
                    groupsVec = groupMgr.getCashedTable();

                    if (groupsVec.size() > 0 && groupsVec != null) {
                        for (int i = 0; i < groupsVec.size(); i++) {
                            WebBusinessObject groupWbo = (WebBusinessObject) groupsVec.get(i);
                            WebBusinessObject userRepGroupWbo = userGroupConfigMgr.getUserGroupConfig(userId, groupWbo.getAttribute("groupID").toString());

                            if (userRepGroupWbo != null) {
                                groupWbo.setAttribute("isDefault", userRepGroupWbo.getAttribute("isDefault").toString());
                                groupWbo.setAttribute("included", "1");
                            } else {
                                groupWbo.setAttribute("isDefault", "0");
                                groupWbo.setAttribute("included", "0");
                            }

                            repsGroups.add(groupWbo);
                        }
                    }

                    request.setAttribute("status", null);
                    request.setAttribute("user", userWbo);
                    request.setAttribute("repsGroupsList", repsGroups);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 63:
                    servedPage = "/docs/Adminstration/update_user_related_depts.jsp";

                    userMgr = UserMgr.getInstance();
                    projectMgr = ProjectMgr.getInstance();
                    userDeptsConfigMgr = UserDepartmentConfigMgr.getInstance();

                    projects = new Vector();
                    userDeptsConfVec = new Vector();
                    userDepts = new Vector();

                    //get request params
                    userId = request.getParameter("userId");
                    numberOfUsers_ = request.getParameter("numberOfUsers");
                    index_ = request.getParameter("index");

                    //Get Side Menu
                    Tools.createUserSideMenu(userId, index_, numberOfUsers_, request);

                    //Get User Wbo
                    userWbo = userMgr.getOnSingleKey(userId);

                    //Get departments
                    projects = projectMgr.getOnArbitraryKeyOracle("div", "key6");

                    if (projects.size() > 0 && projects != null) {
                        for (int i = 0; i < projects.size(); i++) {
                            WebBusinessObject projectWbo = (WebBusinessObject) projects.get(i);
                            WebBusinessObject userDeptsWbo = userDeptsConfigMgr.getUserDepts(userId, projectWbo.getAttribute("projectID").toString());

                            if (userDeptsWbo != null) {
                                projectWbo.setAttribute("isDefault", userDeptsWbo.getAttribute("isDefault").toString());
                                projectWbo.setAttribute("included", "1");
                            } else {
                                projectWbo.setAttribute("isDefault", "0");
                                projectWbo.setAttribute("included", "0");
                            }

                            userDepts.add(projectWbo);
                        }
                    }

                    request.setAttribute("status", null);
                    request.setAttribute("user", userWbo);
                    request.setAttribute("userDeptsList", userDepts);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 64:
                    servedPage = "/docs/Adminstration/update_user_related_depts.jsp";

                    filterQuery = new FilterQuery();
                    tagValueList.clear();
                    filterList.clear();
                    tagValueList = filterQuery.getFilterList();

                    request.setAttribute("filterList", filterList);
                    userMgr = UserMgr.getInstance();
                    userId = request.getParameter("userId");
                    userWbo = (WebBusinessObject) userMgr.getOnSingleKey(request.getParameter("userId"));
                    userWbo.setAttribute("siteId", "UL");
                    userWbo.setAttribute("searchBy", "UL");
                    userWbo.setAttribute("userId", userWbo.getAttribute("userId").toString());

                    String[] userDeptsList = (String[]) request.getParameterValues("isDefault");
                    defaultGroupCode = userDeptsList[0];
                    userGroupsArr = (String[]) request.getParameterValues("userGroups");

                    userDeptsConfigMgr.deleteOnArbitraryKey(userId, "key2");

                    for (int i = 0; i < userGroupsArr.length; i++) {
                        WebBusinessObject userDeptsWbo = new WebBusinessObject();
                        userDeptsWbo.setAttribute("deptId", userGroupsArr[i]);
                        userDeptsWbo.setAttribute("userId", userId);
                        if (userGroupsArr[i].equals(defaultGroupCode)) {
                            userDeptsWbo.setAttribute("isDefualt", "1");
                        } else {
                            userDeptsWbo.setAttribute("isDefualt", "0");
                        }

                        result = userDeptsConfigMgr.saveUserDeprtments(userDeptsWbo);
                    }

                    if (result == true) {
                        request.setAttribute("status", "ok");
                    } else {
                        userClosureConfig.deleteOnArbitraryKey(userId, "key2");
                        request.setAttribute("status", "no");
                    }

                    userMgr = UserMgr.getInstance();
                    projectMgr = ProjectMgr.getInstance();
                    userDeptsConfigMgr = UserDepartmentConfigMgr.getInstance();

                    projects = new Vector();
                    userDeptsConfVec = new Vector();
                    userDepts = new Vector();

                    //Get User Wbo
                    userWbo = userMgr.getOnSingleKey(userId);

                    //Get departments
                    projects = projectMgr.getOnArbitraryKeyOracle("div", "key6");

                    if (projects.size() > 0 && projects != null) {
                        for (int i = 0; i < projects.size(); i++) {
                            WebBusinessObject projectWbo = (WebBusinessObject) projects.get(i);
                            WebBusinessObject userDeptsWbo = userDeptsConfigMgr.getUserDepts(userId, projectWbo.getAttribute("projectID").toString());

                            if (userDeptsWbo != null) {
                                projectWbo.setAttribute("isDefault", userDeptsWbo.getAttribute("isDefault").toString());
                                projectWbo.setAttribute("included", "1");
                            } else {
                                projectWbo.setAttribute("isDefault", "0");
                                projectWbo.setAttribute("included", "0");
                            }

                            userDepts.add(projectWbo);
                        }
                    }

                    request.setAttribute("status", null);
                    request.setAttribute("user", userWbo);
                    request.setAttribute("userDeptsList", userDepts);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 65:
                    key = request.getParameter("userId");
                    servedPage = "/docs/Adminstration/confirm_deluser.jsp";
                    issueMgr = IssueMgr.getInstance();
                    if (request.getParameterValues("issueID") != null) {
                        for (String issueID : request.getParameterValues("issueID")) {
                            issueMgr.deleteAllIssueData(issueID);
                        }
                    }
                    request.setAttribute("userName", request.getParameter("userName"));
                    request.setAttribute("userId", key);
                    request.setAttribute("issuesList", IssueByComplaintMgr.getInstance().getAllEmployeeComplaints(key, null, null, null));
                    request.setAttribute("usersList", new ArrayList<>(userMgr.getCashedTable()));
                    request.setAttribute("status", "complaintsDeleted");
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 66:
                    key = request.getParameter("userId");
                    servedPage = "/docs/Adminstration/move_complaints.jsp";
                    ClientComplaintsMgr clientComplaintsMgr = ClientComplaintsMgr.getInstance();
                    distributionListMgr = DistributionListMgr.getInstance();
                    if (request.getParameterValues("clientComplaintID") != null && request.getParameter("ownerID") != null) {
                        userWbo = userMgr.getOnSingleKey(request.getParameter("ownerID"));
                        WebBusinessObject tempWbo = new WebBusinessObject();
                        index = 1;
                        for (String clientComplaintID : request.getParameterValues("clientComplaintID")) {
                            clientComplaintsMgr.changeCurrentOwner(clientComplaintID, request.getParameter("ownerID"),
                                    (String) userWbo.getAttribute("fullName"));
                            distributionListMgr.updateResponsible(clientComplaintID, request.getParameter("ownerID"));
                            tempWbo.setAttribute("ClientComplaintID_" + index, clientComplaintID);
                            index++;
                        }
                        request.setAttribute("status", "complaintsMoved");
                        //For logging Transfer Complaints
                        WebBusinessObject loggerWbo = new WebBusinessObject();
                        loggerWbo.setAttribute("objectXml", tempWbo.getObjectAsXML());
                        loggerWbo.setAttribute("realObjectId", persistentUser.getAttribute("userId"));
                        loggerWbo.setAttribute("userId", persistentUser.getAttribute("userId"));
                        loggerWbo.setAttribute("objectName", persistentUser.getAttribute("userName"));
                        loggerWbo.setAttribute("loggerMessage", "Transfer Complaints");
                        loggerWbo.setAttribute("eventName", "Transfer");
                        loggerWbo.setAttribute("objectTypeId", "1");
                        loggerWbo.setAttribute("eventTypeId", "6");
                        loggerWbo.setAttribute("ipForClient", getClientIpAddr(request));
                        LoggerMgr.getInstance().saveObject(loggerWbo);
                    }
                    fromDate = request.getParameter("fromDate");
                    String toDate = request.getParameter("toDate");
                    Calendar cal = Calendar.getInstance();
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
                    if (toDate == null) {
                        toDate = sdf.format(cal.getTime());
                    }
                    if (fromDate == null) {
                        cal.add(Calendar.MONTH, -1);
                        fromDate = sdf.format(cal.getTime());
                    }
                    String currentStatus = request.getParameter("currentStatus");
                    request.setAttribute("userName", request.getParameter("userName"));
                    request.setAttribute("userId", key);
                    request.setAttribute("issuesList", IssueByComplaintMgr.getInstance().getAllEmployeeComplaints(key, fromDate, toDate, currentStatus));
                    request.setAttribute("usersList", securityUser.isSuperUser() ? new ArrayList<>(userMgr.getCashedTable()) : userMgr.getEmployeesByManager((String) persistentUser.getAttribute("userId")));
                    request.setAttribute("fromDate", fromDate);
                    request.setAttribute("toDate", toDate);
                    request.setAttribute("currentStatus", currentStatus);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 67:
                    servedPage = "/docs/Adminstration/update_user_company.jsp";

                    userId = request.getParameter("userId");
                    numberOfUsers_ = request.getParameter("numberOfUsers");
                    index_ = request.getParameter("index");
                    Tools.createUserSideMenu(userId, index_, numberOfUsers_, request);

                    companies = new ArrayList();
                    companies = projectMgr.getOnArbitraryKey2("CO", "key6");
                    request.setAttribute("companies", companies);
                    request.setAttribute("userId", userId);

                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 68:
                    servedPage = "/docs/Adminstration/update_user_company.jsp";

                    projectMgr = ProjectMgr.getInstance();
                    UserCompaniesMgr userCompanyMgr = UserCompaniesMgr.getInstance();

                    waUser = (WebBusinessObject) request.getSession().getAttribute("loggedUser");

                    String companyID = request.getParameter("company");
                    userId = request.getParameter("userId");

                    if (companyID.equals("0")) {
                        if (userCompanyMgr.deleteOnArbitraryKey(userId, "key1") == 1) {
                            request.setAttribute("status", "ok");
                        } else {
                            request.setAttribute("status", "no");
                        }
                    } else {
                        WebBusinessObject userCompanyWbo = userCompanyMgr.getOnSingleKey("key1", userId);
                        WebBusinessObject companyWbo = projectMgr.getOnSingleKey(companyID);

                        try {
                            if (userCompanyWbo == null) {
                                if (userMgr.updateUserCompany(userId, companyID, companyWbo.getAttribute("projectName").toString(), waUser.getAttribute("userId").toString())) {
                                    request.setAttribute("status", "ok");
                                } else {
                                    request.setAttribute("status", "no");
                                }
                            } else {
                                request.setAttribute("status", "repeated");
                            }

                        } catch (Exception ex) {
                            logger.error(ex);
                        }
                    }

                    companies = new ArrayList();
                    companies = projectMgr.getOnArbitraryKey2("CO", "key6");
                    request.setAttribute("companies", companies);
                    request.setAttribute("userId", userId);

                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);

                    break;

                case 69:
                    servedPage = "/docs/Adminstration/update_user_district.jsp";

                    userId = request.getParameter("userId");
                    numberOfUsers_ = request.getParameter("numberOfUsers");
                    index_ = request.getParameter("index");
                    Tools.createUserSideMenu(userId, index_, numberOfUsers_, request);

                    ArrayList districts = projectMgr.getOnArbitraryKey2("garea", "key6");
                    request.setAttribute("districts", districts);
                    request.setAttribute("userId", userId);

                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 70:
                    servedPage = "/docs/Adminstration/update_user_district.jsp";

                    projectMgr = ProjectMgr.getInstance();
                    UserDistrictsMgr userDistrictsMgr = UserDistrictsMgr.getInstance();

                    waUser = (WebBusinessObject) request.getSession().getAttribute("loggedUser");

                    String districtID = request.getParameter("district");
                    userId = request.getParameter("userId");

                    if (districtID.equals("0")) {
                        if (userDistrictsMgr.deleteOnArbitraryKey(userId, "key1") >= 1) {
                            request.setAttribute("status", "ok");
                        } else {
                            request.setAttribute("status", "no");
                        }
                    } else {
                        WebBusinessObject userDistrictWbo = userDistrictsMgr.getOnSingleKey("key1", userId);
                        WebBusinessObject districtWbo = projectMgr.getOnSingleKey(districtID);

                        try {
                            if (userDistrictsMgr.updateUserDistrict(userId, districtID, districtWbo.getAttribute("projectName").toString(), waUser.getAttribute("userId").toString())) {
                                request.setAttribute("status", "ok");
                            } else {
                                request.setAttribute("status", "no");
                            }

//                            if (userDistrictWbo == null) {
//                                
//                            } else {
//                                request.setAttribute("status", "repeated");
//                            }
                        } catch (Exception ex) {
                            logger.error(ex);
                        }
                    }

                    districts = new ArrayList();
                    districts = projectMgr.getOnArbitraryKey2("garea", "key6");
                    request.setAttribute("districts", districts);
                    request.setAttribute("userId", userId);

                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);

                    break;
		    
		case 71:
		    empId = request.getParameter("empID");
		    String nwMgrID = request.getParameter("nwMgrID");
		    
		    WebBusinessObject mgrWbo = new WebBusinessObject();
		    
		    if (empId != null && !empId.equals("") && !empId.equals("0")) {
			mgrWbo = userMgr.getManagerByEmployeeID(empId);
			
			Vector empObjects = empRelationMgr.getOnArbitraryDoubleKey(empId, "key2", mgrWbo.getAttribute("userId").toString(), "key1");
			for (int j = 0; j < empObjects.size(); j++) {
			    wbo = (WebBusinessObject) empObjects.get(j);
			    if (empRelationMgr.deleteOnSingleKey(wbo.getAttribute("id").toString())) {
				wbo.setAttribute("firstEmpId", nwMgrID);
				wbo.setAttribute("secondEmpId", empId);
				wbo.setAttribute("oldMgr", mgrWbo.getAttribute("userId"));
				wbo.setAttribute("comments", request.getParameter("comments") != null ? request.getParameter("comments") : "");

				if (empRelationMgr.upsertEmpRelation(wbo)) {
				    distributionListMgr = DistributionListMgr.getInstance();
				    
				    if (distributionListMgr.updateMgr(wbo)) {
					wbo.setAttribute("updtMgr", "yes");
				    } else {
					wbo.setAttribute("updtMgr", "No");
				    }
				} else {
				    wbo.setAttribute("updtMgr", "No");
				}
			    } else {
				wbo.setAttribute("updtMgr", "No");
			    }
			}
		    }
                    this.forward("ListerServlet?op=ListUsers", request, response);
		    break;
                case 72:
                    out = response.getWriter();
                    userMgr = UserMgr.getInstance();
                    employeeList = userMgr.getUsersByGroup(request.getParameter("groupID"));
                    out.write(Tools.getJSONArrayAsString(employeeList));
                    break;
                case 73:
                    out = response.getWriter();
                    wbo = new WebBusinessObject();
                    wbo.setAttribute("status", projectMgr.updateProjectNameAndCode(request.getParameter("departmentID"),
                        request.getParameter("name"), request.getParameter("code")) ? "ok" : "fail");
                    out.write(Tools.getJSONObjectAsString(wbo));
                    break;
                case 74:
                    servedPage = "/docs/Adminstration/broker_statistics.jsp";
                    userExtMgr = UserExtMgr.getInstance();
                    request.setAttribute("brokersList", userExtMgr.getBrokersStatistics(UserCampaignConfigMgr.getInstance()
                            .getAllUserCampaignIDs((String) persistentUser.getAttribute("userId")).toArray(new String[0])));
                    request.setAttribute("brokerClientsCount", userExtMgr.getBrokerClientsCount());
                    request.setAttribute("brokerSoldCount", userExtMgr.getBrokerSoldCount());
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                    
                case 75:
                BufferedOutputStream output = new BufferedOutputStream(response.getOutputStream());
                String BokerID =  request.getParameter("userId");
                IssueDocumentMgr issueDocumentMgr = IssueDocumentMgr.getInstance();
                try {
                    issueDocumentMgr.getOnArbitraryDoubleKeyOracle(BokerID,
                            "key5", CRMConstants.DOCUMENT_TYPE_PERSONAL_PHOTO_ID, "key4");
                    List<WebBusinessObject> imageList = new ArrayList<>(issueDocumentMgr.getOnArbitraryDoubleKeyOracle2(BokerID,
                            "key5", CRMConstants.DOCUMENT_TYPE_PERSONAL_PHOTO_ID, "key4"));
                    boolean personalExists = false;
                    if (!imageList.isEmpty()) {
                        for ( int i=imageList.size()-1 ;i< imageList.size();i++) {
                            WebBusinessObject image=imageList.get(i);
                            if (((String) image.getAttribute("metaType")).contains("image")) {
                                InputStream input = issueDocumentMgr.getImage((String) image.getAttribute("documentID"));
                                try {
                                    byte[] buffer = new byte[8192];
                                    int length = 0;
                                    while ((length = input.read(buffer)) > 0) {
                                        output.write(buffer, 0, length);
                                    }
                                } finally {
                                    if (output != null) {
                                        try {
                                            output.close();
                                        } catch (IOException logOrIgnore) {
                                        }
                                    }{
                                        try {
                                            input.close();
                                        } catch (IOException logOrIgnore) {
                                        }
                                    }
                                }
                                personalExists = true;
                         break;
                            }
                        }
                    }

                    if (!personalExists) {
                        servletContext = getServletContext();
                        InputStream input = new FileInputStream(servletContext.getRealPath("/") + "/images/unknown-person.jpg");
                        try {
                            byte[] buffer = new byte[8192];
                            int length = 0;
                            while ((length = input.read(buffer)) > 0) {
                                output.write(buffer, 0, length);
                            }
                        } finally {
                            if (output != null) {
                                try {
                                    output.close();
                                } catch (IOException logOrIgnore) {
                                }
                            }
                            if (input != null) {
                                try {
                                    input.close();
                                } catch (IOException logOrIgnore) {
                                }
                            }
                        }
                    }
                } catch (Exception ex) {
                  //  Logger.getLogger(UsersServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                break;
                case 76:
                    servedPage = "/docs/Adminstration/update_user_campaign.jsp";
                    userMgr = UserMgr.getInstance();
                    UserCampaignConfigMgr userCampaignConfigMgr = UserCampaignConfigMgr.getInstance();
                    userId = request.getParameter("userId");
                    ArrayList<WebBusinessObject> campaignsUserList = userCampaignConfigMgr.getCampaignsForUser(userId);
                    userWbo = userMgr.getOnSingleKey(userId);
                    request.setAttribute("user", userWbo);
                    request.setAttribute("campaignsUserList", campaignsUserList);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 77:
                    servedPage = "/docs/Adminstration/update_user_campaign.jsp";
                    userMgr = UserMgr.getInstance();
                    userId = request.getParameter("userId");
                    userWbo = (WebBusinessObject) userMgr.getOnSingleKey(request.getParameter("userId"));
                    userCampaignConfigMgr = UserCampaignConfigMgr.getInstance();
                    userCampaignConfigMgr.deleteOnArbitraryKey(userId, "key2");
                    if (request.getParameterValues("campaignID") != null) {
                        if (userCampaignConfigMgr.saveUserCampaigns(request.getParameterValues("campaignID"), userId,
                                (String) persistentUser.getAttribute("userId"))) {
                            request.setAttribute("status", "ok");
                        } else {
                            userCampaignConfigMgr.deleteOnArbitraryKey(userId, "key2");
                            request.setAttribute("status", "no");
                        }
                    } else {
                        request.setAttribute("status", "ok");
                    }
                    userId = request.getParameter("userId");
                    campaignsUserList = userCampaignConfigMgr.getCampaignsForUser(userId);
                    userWbo = userMgr.getOnSingleKey(userId);
                    request.setAttribute("user", userWbo);
                    request.setAttribute("campaignsUserList", campaignsUserList);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 78:
                    servedPage = "/docs/Adminstration/new_broker.jsp";
                    String SeasonCode = "";
                    SeasonMgr seasonMgr = SeasonMgr.getInstance();
                    String EnglishName = "Brokers";
                    WebBusinessObject seasonTypeC = seasonMgr.getSpecificSeasonTypeCodes(EnglishName.toLowerCase());

                    if (seasonTypeC == null) {
                        request.setAttribute("status", "noChnl");
                    } else {
                        if (request.getParameter("fullName") != null) {
                            SeasonCode = (String) seasonTypeC.getAttribute("type_code");
                            //String userID = userMgr.saveBrokerUser(request, session);
                            userExtMgr = UserExtMgr.getInstance();
                            //if (userID != null & !userID.equals("")) {
                                WebBusinessObject userExtWbo = new WebBusinessObject();
                                //userExtWbo.setAttribute("userID", userID);
                                userExtWbo.setAttribute("CommercialRegister", request.getParameter("commercialRegister"));
                                userExtWbo.setAttribute("TaxCardNumber", request.getParameter("taxCardNumber"));
                                userExtWbo.setAttribute("RecordDate", request.getParameter("recordDate"));
                                userExtWbo.setAttribute("AuthorizedPerson", request.getParameter("authorizedPerson"));
                                userExtWbo.setAttribute("companyAddress", request.getParameter("companyAddress"));
                                userExtWbo.setAttribute("createdBy", (String) persistentUser.getAttribute("userId"));
                                userExtWbo.setAttribute("option1", "UL");
                                userExtWbo.setAttribute("phoneNumber", request.getParameter("phoneNumber"));
                                userExtWbo.setAttribute("option3", "UL");
                                userExtWbo.setAttribute("option4", "UL");
                                userExtWbo.setAttribute("option5", "UL");
                                userExtWbo.setAttribute("option6", "UL");
                                //userExtMgr.deleteOnSingleKey(userID);
                                //request.setAttribute("status", userExtMgr.saveObject(userExtWbo) ? "ok" : "fail");
                                RecordSeasonMgr recordSeasonMgr = RecordSeasonMgr.getInstance();
                                WebBusinessObject recordWbo = new WebBusinessObject();
                                recordWbo.setAttribute("code", SeasonCode);
                                recordWbo.setAttribute("enName", request.getParameter("fullName"));
                                recordWbo.setAttribute("arName", request.getParameter("email"));
                                recordWbo.setAttribute("CommercialRegister", request.getParameter("commercialRegister"));
                                recordWbo.setAttribute("TaxCardNumber", request.getParameter("taxCardNumber"));
                                recordWbo.setAttribute("RecordDate", request.getParameter("recordDate"));
                                recordWbo.setAttribute("AuthorizedPerson", request.getParameter("authorizedPerson"));
                                recordWbo.setAttribute("companyAddress", request.getParameter("companyAddress"));
                                recordWbo.setAttribute("isForever", request.getParameter("phoneNumber"));
                                recordWbo.setAttribute("userID", persistentUser.getAttribute("userId"));
                                recordWbo.setAttribute("createdBy", (String) persistentUser.getAttribute("userId"));
                                recordWbo.setAttribute("noSales", request.getParameter("noSales"));
                                recordSeasonMgr.saveObject(recordWbo);
                            //} 
                                request.setAttribute("status", "ok");
                        }
                         else {
                                request.setAttribute("status", "fail");
                            }
                        
                    }
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 79:
                    servedPage = "/docs/Adminstration/user_campaign_broker.jsp";
                    userCampaignConfigMgr = UserCampaignConfigMgr.getInstance();
                    request.setAttribute("usersList", userCampaignConfigMgr.getUserCampaigns());
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 80:
                    servedPage = "/docs/Adminstration/user_broker_form.jsp";
                    userMgr = UserMgr.getInstance();
                    CampaignMgr campaignMgr = CampaignMgr.getInstance();
                    userCampaignConfigMgr = UserCampaignConfigMgr.getInstance();
                    ArrayList<WebBusinessObject> usersTempList = new ArrayList<>(userMgr.getAllUsers());
                    ArrayList<WebBusinessObject> userCampaignList = userCampaignConfigMgr.getCampaignsForUser(request.getParameter("userID") != null
                            && !request.getParameter("userID").isEmpty() ? request.getParameter("userID")
                            : usersTempList != null && usersTempList.size() > 0 ? (String) usersTempList.get(0).getAttribute("userId") : "");
                    ArrayList<String> userCampaignIDsList = new ArrayList<>();
                    for (WebBusinessObject userCampaignWbo : userCampaignList) {
                        if (userCampaignWbo.getAttribute("id") != null) {
                            userCampaignIDsList.add((String) userCampaignWbo.getAttribute("campaignID"));
                        }
                    }
                    request.setAttribute("userID", request.getParameter("userID"));
                    request.setAttribute("userCampaignIDsList", userCampaignIDsList);
                    request.setAttribute("usersList", usersTempList);
                    request.setAttribute("brokersList", campaignMgr.getBrokersCampaigns());
                    request.setAttribute("page", servedPage);
                    this.forward(servedPage, request, response);
                    break;
                case 81:
                    out = response.getWriter();
                    userCampaignConfigMgr = UserCampaignConfigMgr.getInstance();
                    userId = request.getParameter("userID");
                    userCampaignConfigMgr.deleteOnArbitraryKey(userId, "key2");
                    wbo = new WebBusinessObject();
                    String brokerID = request.getParameter("brokerID");
                    if (brokerID != null) {
                        if (userCampaignConfigMgr.saveUserCampaigns(request.getParameter("brokerID").split(","), userId,
                                (String) persistentUser.getAttribute("userId"))) {
                            wbo.setAttribute("status", "ok");
                        } else {
                            userCampaignConfigMgr.deleteOnArbitraryKey(userId, "key2");
                            wbo.setAttribute("status", "no");
                        }
                    } else {
                        wbo.setAttribute("status", "ok");
                    }
                    out.write(Tools.getJSONObjectAsString(wbo));
                    break;
                case 82:
                    out = response.getWriter();
                    userCampaignConfigMgr = UserCampaignConfigMgr.getInstance();
                    userWbo = userMgr.getOnSingleKey(request.getParameter("userID"));
                    wbo = new WebBusinessObject();
                    if (userWbo != null) {
                        wbo.setAttribute("creationDate", ((String) userWbo.getAttribute("CREATION_TIME")).substring(0, 10));
                        WebBusinessObject creatorWbo = userMgr.getOnSingleKey((String) userWbo.getAttribute("createdBy"));
                        if (creatorWbo != null) {
                            wbo.setAttribute("createdByName", creatorWbo.getAttribute("fullName"));
                        }
                        wbo.setAttribute("status", "ok");
                    } else {
                        wbo.setAttribute("status", "no");
                    }
                    out.write(Tools.getJSONObjectAsString(wbo));
                    break;
                case 83:
                    out = response.getWriter();
                    wbo = new WebBusinessObject();
                    if (userExtMgr.deleteBroker(request.getParameter("brokerID"), request.getParameter("brokerName"))) {
                        wbo.setAttribute("status", "ok");
                    } else {
                        wbo.setAttribute("status", "no");
                    }
                    out.write(Tools.getJSONObjectAsString(wbo));
                    break;
                case 84:
                    servedPage = "/docs/Adminstration/broker_list.jsp";
                    userExtMgr = UserExtMgr.getInstance();
                    request.setAttribute("brokersList", userExtMgr.getBrokersList(UserCampaignConfigMgr.getInstance()
                            .getAllUserCampaignIDs((String) persistentUser.getAttribute("userId")).toArray(new String[0])));
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                    
            }
        } catch (SQLException ex) {
            logger.error(ex);
        } catch (Exception ex) {
            logger.error(ex);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Users Servlet";
    }

    private void shipBackToNewUser(HttpServletRequest request, HttpServletResponse response, String status) {
        request.setAttribute("status", status);
        servedPage = "UsersServlet?op=GetForm";
        this.forward(servedPage, request, response);
    }

    private void shipBackToViewUser(HttpServletRequest request, HttpServletResponse response, String status) {
        request.setAttribute("status", status);
        servedPage = "UsersServlet?op=ViewUser&userId=" + webUser.getUserId();
        this.forward(servedPage, request, response);
    }

    private void scrapeForm(HttpServletRequest request, String mode) throws EmptyRequestException, EntryExistsException, SQLException, Exception {

        String userName = (String) request.getParameter("userName");
        String password = (String) request.getParameter("password");
        String email = (String) request.getParameter("email");

        userGroupsArr = (String[]) request.getParameterValues("userGroups");
        if (userGroupsArr == null || userName == null || password == null) {
            throw new EmptyRequestException(tGuide.getMessage("incompleteinput"));
        }
        if (userName.equals("") || password.equals("") || userGroupsArr.equals("") || userGroupsArr.length == 0) {
            throw new EmptyRequestException(tGuide.getMessage("incompleteinput"));
        }

        if (mode.equals("insert")) {
            Vector v = userMgr.getSearchQueryResult(request);
            if (v == null) {
                throw new Exception("database or unknown exception");
            }

            if (v != null && v.size() > 0) {
                throw new EntryExistsException();
            }
        }
        webUser.setUserName(userName);
        webUser.setPassword(password);
        webUser.setEmail(email);
    }

    private void shipBack(String message, HttpServletRequest request, HttpServletResponse response) {

        userGroup = new Vector();
        siteWbo = new WebBusinessObject();
        uGroupWbo = new WebBusinessObject();

        user = (WebBusinessObject) userMgr.getOnSingleKey(request.getParameter("userId"));

        try {
            userGroup = userGroupMgr.getOnArbitraryKey(request.getParameter("userId"), "refintegkey");
        } catch (SQLException ex) {
            logger.error(ex.getMessage());
        } catch (Exception ex) {
            logger.error(ex.getMessage());
        }
        viewIsDefualt = false;
        if (userGroup.size() > 0) {
            uGroupWbo = (WebBusinessObject) userGroup.get(0);
            if (uGroupWbo.getAttribute("isDefault") != null) {
                viewIsDefualt = true;
            }
        }

        projectId = uGroupWbo.getAttribute("projectID").toString();
        siteWbo = projectMgr.getOnSingleKey(projectId);
        user.setAttribute("site", siteWbo.getAttribute("projectName").toString());
        user.setAttribute("siteId", siteWbo.getAttribute("projectID").toString());
        user.setAttribute("searchBy", request.getParameter("searchBy"));
        sites = projectMgr.getCashedTableAsBusObjects();

        request.setAttribute("sites", sites);
        request.setAttribute("userId", request.getParameter("userId").toString());
        request.setAttribute("user", user);
        request.setAttribute("status", message);
        request.setAttribute("viewIsDefualt", viewIsDefualt);
        request.setAttribute("page", servedPage);
        this.forwardToServedPage(request, response);

    }

    private void setRequestByStoreForUser(HttpServletRequest request, String userId) {
        UserStoresMgr userStoresMgr = UserStoresMgr.getInstance();
        Vector<String> storesName = new Vector<String>();
        stores = new Vector<WebBusinessObject>();

        try {
            stores = userStoresMgr.getOnArbitraryKey(userId, "key1");
        } catch (Exception ex) {
            logger.error(ex.getMessage());
        }

        for (WebBusinessObject wbo : stores) {
            storesName.addElement((String) wbo.getAttribute("storeCode"));
        }

        request.setAttribute("storesName", storesName);
        request.setAttribute("stores", stores);
    }

    private void setRequestByProjectsForUser(HttpServletRequest request, String userId) {
        isDefault = "";
        Vector<String> projectsName = new Vector<String>();
        projects = new Vector<WebBusinessObject>();

        try {
            projects = userProjectsMgr.getOnArbitraryKey(userId, "key1");
        } catch (Exception ex) {
            logger.error(ex.getMessage());
        }

        for (WebBusinessObject wbo : projects) {
            projectsName.addElement((String) wbo.getAttribute("projectID"));
            if ("1".equalsIgnoreCase((String) wbo.getAttribute("isDefault"))) {
                isDefault = (String) wbo.getAttribute("projectID");
            }
        }

        request.setAttribute("projectsForUser", projectsName);
        request.setAttribute("projects", projects);
        request.setAttribute("isDefaultProject", isDefault);
    }

    private void setRequestByTradesForUser(HttpServletRequest request, String userId) {
        isDefault = "";
        Vector<String> tradesName = new Vector<String>();
        projects = new Vector<WebBusinessObject>();

        try {
            projects = userTradeMgr.getOnArbitraryKey(userId, "key1");
        } catch (Exception ex) {
            logger.error(ex.getMessage());
        }

        for (WebBusinessObject wbo : projects) {
            tradesName.addElement((String) wbo.getAttribute("tradeId"));
            if ("1".equalsIgnoreCase((String) wbo.getAttribute("isDefault"))) {
                isDefault = (String) wbo.getAttribute("tradeId");
            }
        }

        request.setAttribute("tradesForUser", tradesName);
        request.setAttribute("userTrades", projects);
        request.setAttribute("isDefaultTrade", isDefault);
    }

    private void setRequestByGroupsForUser(HttpServletRequest request, String userId) {
        isDefault = "";
        groups = new Vector<WebBusinessObject>();

        try {
            groups = userGroupMgr.getOnArbitraryKey(userId, "refintegkey");
        } catch (Exception ex) {
            logger.error(ex.getMessage());
        }

        for (WebBusinessObject wbo : groups) {
            if ("1".equalsIgnoreCase((String) wbo.getAttribute("isDefault"))) {
                isDefault = (String) wbo.getAttribute("groupID");
                break;
            }
        }

        request.setAttribute("groups", groups);
        request.setAttribute("isDefaultGroup", isDefault);
    }

    private void setRequestByGrantsForUser(HttpServletRequest request, String userId) {
        grants = new Vector<WebBusinessObject>();

        try {
            grants = userGrantMgr.getOnArbitraryKey(userId, "key2");

            for (WebBusinessObject grant : grants) {
                grant.setAttribute("grantName", grantsMgr.getGrantName((String) grant.getAttribute("grantId")));
            }

        } catch (Exception ex) {
            logger.error(ex.getMessage());
        }

        request.setAttribute("grants", grants);
    }

    @Override
    protected int getOpCode(String opName) {
        if (opName.equalsIgnoreCase("GetForm")) {
            return 1;
        }
        if (opName.equalsIgnoreCase("SaveUser")) {
            return 2;
        }
        if (opName.equalsIgnoreCase("Delete")) {
            return 3;
        }
        if (opName.equalsIgnoreCase("ConfirmDelete")) {
            return 4;
        }
        if (opName.equalsIgnoreCase("ViewUser")) {
            return 5;
        }
        if (opName.equalsIgnoreCase("GetUpdateForm")) {
            return 6;
        }
        if (opName.equalsIgnoreCase("UpdateUser")) {
            return 7;
        }
          if (opName.equals("mediatorInformation")) {
            return 8;
        }
        if (opName.equalsIgnoreCase("ListAll")) {
            return 10;
        }
        if (opName.equalsIgnoreCase("userData")) {
            return 11;
        }
        if (opName.equalsIgnoreCase("assignStores")) {
            return 12;
        }
        if (opName.equalsIgnoreCase("saveUserStores")) {
            return 13;
        }
        if (opName.equalsIgnoreCase("assignProjects")) {
            return 14;
        }
        if (opName.equalsIgnoreCase("saveUserProjects")) {
            return 15;
        }
        if (opName.equalsIgnoreCase("closeSideMenu")) {
            return 16;
        }
        if (opName.equalsIgnoreCase("directTo")) {
            return 17;
        }
        if (opName.equalsIgnoreCase("ViewUserByAjax")) {
            return 18;
        }
        if (opName.equalsIgnoreCase("viewUserPage")) {
            return 19;
        }
        if (opName.equalsIgnoreCase("directToUser")) {
            return 20;
        }
        if (opName.equalsIgnoreCase("assignAdministrativeProjects")) {
            return 21;
        }
        if (opName.equalsIgnoreCase("assignClients")) {
            return 22;
        }
        if (opName.equalsIgnoreCase("usersList")) {
            return 23;
        }
        if (opName.equalsIgnoreCase("upsertUserClientsRelation")) {
            return 24;
        }
        if (opName.equalsIgnoreCase("listUnattachedClients")) {
            return 25;
        }
        if (opName.equalsIgnoreCase("listAttachedClients")) {
            return 26;
        }

        if (opName.equalsIgnoreCase("attachEmpToMgr")) {
            return 27;
        }
        if (opName.equalsIgnoreCase("usersList2")) {
            return 28;
        }
        if (opName.equalsIgnoreCase("upsertEmpRelation")) {
            return 29;
        }
        if (opName.equalsIgnoreCase("listUnattachedEmployees")) {
            return 30;
        }
        if (opName.equalsIgnoreCase("listUserAttachedEmployees")) {
            return 31;
        }
        if (opName.equalsIgnoreCase("listAttachedEmployees")) {
            return 32;
        }
        if (opName.equalsIgnoreCase("removeAttachedEmployees")) {
            return 33;
        }
        if (opName.equalsIgnoreCase("assignRoles")) {
            return 34;
        }
        if (opName.equalsIgnoreCase("saveUserRoles")) {
            return 35;
        }
        if (opName.equalsIgnoreCase("SalesManagerUsers")) {
            return 36;
        }
        if (opName.equalsIgnoreCase("showRoles")) {
            return 37;
        }
        if (opName.equalsIgnoreCase("deleteUserClientsRelation")) {
            return 38;
        }
        if (opName.equalsIgnoreCase("listUnattachedUsers")) {
            return 40;
        }
        if (opName.equalsIgnoreCase("assignManagerForDepartment")) {
            return 41;
        }
        if (opName.equalsIgnoreCase("listManager")) {
            return 42;
        }
        if (opName.equalsIgnoreCase("getManagerForDepartment")) {
            return 43;
        }

        if (opName.equalsIgnoreCase("editBasicData")) {
            return 44;
        }

        if (opName.equalsIgnoreCase("saveBasicData")) {
            return 45;
        }

        if (opName.equalsIgnoreCase("editPassword")) {
            return 46;
        }

        if (opName.equalsIgnoreCase("savePassword")) {
            return 47;
        }

        if (opName.equalsIgnoreCase("editGroups")) {
            return 48;
        }

        if (opName.equalsIgnoreCase("saveGroups")) {
            return 49;
        }
        if (opName.equalsIgnoreCase("changeDefaultGroup")) {
            return 50;
        }

        if (opName.equals("assignProjectOfCompany")) {
            return 51;
        }

        if (opName.equals("saveUserCompanyProjects")) {
            return 52;
        }

        if (opName.equals("changeDefaultBranch")) {
            return 53;
        }

        if (opName.equals("changeCampaignMode")) {
            return 54;
        }

        if (opName.equals("changeCallcenterMode")) {
            return 55;
        }

        if (opName.equals("autoPilotMode")) {
            return 56;
        }

        if (opName.equals("changeUserStatusByAjax")) {
            return 57;
        }

        if (opName.equals("changePilotMode")) {
            return 58;
        }

        if (opName.equals("editBusinessProcess")) {
            return 59;
        }

        if (opName.equals("saveBusinessProcess")) {
            return 60;
        }

        if (opName.equals("editUsersGroupsConfig")) {
            return 61;
        }

        if (opName.equals("saveUsersGroupsConfig")) {
            return 62;
        }

        if (opName.equals("editUsersDeptsConfig")) {
            return 63;
        }

        if (opName.equals("saveUsersDeptsConfig")) {
            return 64;
        }

        if (opName.equals("deleteSelectedComplaints")) {
            return 65;
        }

        if (opName.equals("moveSelectedComplaints")) {
            return 66;
        }

        if (opName.equals("updateUserCompanyForm")) {
            return 67;
        }

        if (opName.equals("saveCompany")) {
            return 68;
        }

        if (opName.equals("updateUserDistrictForm")) {
            return 69;
        }

        if (opName.equals("saveDistrict")) {
            return 70;
        }
	
	if (opName.equals("chngEmpMgr")) {
            return 71;
        }
	
	if (opName.equals("getGroupUsers")) {
            return 72;
        }
	
	if (opName.equals("updateDepartmentByAjax")) {
            return 73;
        }
	
	if (opName.equals("getBrokersStatistics")) {
            return 74;
        }
        if (opName.equals("viewPersonalPhoto")) {
            return 75;
        }
      
        if (opName.equals("editUserCampaignsConfig")) {
            return 76;
        }
      
        if (opName.equals("saveUserCampaignsConfig")) {
            return 77;
        }
      
        if (opName.equals("getBrokerForm")) {
            return 78;
        }
      
        if (opName.equals("getUserBrokers")) {
            return 79;
        }
        if (opName.equals("getUserBrokerForm")) {
            return 80;
        }
        if (opName.equals("saveUserBrokersAjax")) {
            return 81;
        }
        if (opName.equals("getUserInfoAjax")) {
            return 82;
        }
        if (opName.equals("deleteBroker")) {
            return 83;
        }
        if (opName.equals("getBrokersList")) {
            return 84;
        }
        
        return 0;
    }
}
