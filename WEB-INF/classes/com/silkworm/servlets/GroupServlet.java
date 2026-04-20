/*
 * GroupServlet.java
 *
 * Created on January 16, 2004, 3:01 AM
 */
package com.silkworm.servlets;

import com.maintenance.common.Tools;
import com.maintenance.db_access.GroupPrevMgr;
import com.maintenance.db_access.ProjectsByGroupMgr;
import com.silkworm.persistence.relational.NoSuchColumnException;
import java.io.*;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.*;
import javax.servlet.http.*;

import com.silkworm.business_objects.secure_menu.*;
import com.silkworm.business_objects.*;

import java.util.*;
import java.sql.*;
import com.silkworm.common.*;

import com.silkworm.Exceptions.*;
import com.silkworm.db_access.PersistentSessionMgr;
import com.tracker.db_access.PreviligesTypeMgr;
import com.tracker.db_access.ProjectMgr;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.w3c.dom.*;
import org.xml.sax.SAXException;

/**
 *
 * @author walid
 * @version
 */
public class GroupServlet extends swBaseServlet {

    WebBusinessObject wbo = new WebBusinessObject();
    String[] activeOptions = null;
    ThreeDimensionMenu tdm = null;
    GroupMgr groupMgr = GroupMgr.getInstance();
    UserGroupMgr userGroupMgr = UserGroupMgr.getInstance();
    Vector groupList = null;
    WebBusinessObject group = null;
    protected PrintWriter out;
    private ServletContext c;

    /**
     * Initializes the servlet.
     */
    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);

    }

    /**
     * Destroys the servlet.
     */
    @Override
    public void destroy() {
    }

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     */
    @Override
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        super.processRequest(request, response);
        HttpSession session = request.getSession();
        String remoteAccess = session.getId();
        WebBusinessObject persistentUser = (WebBusinessObject) PersistentSessionMgr.getInstance().getOnSingleKey(remoteAccess);
        operation = getOpCode((String) request.getParameter("op"));

        switch (operation) {
            case 1:

                servedPage = "/docs/Adminstration/new_group.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 2:

                try {

//                    scrapeForm(request, "insert");
                    String nnnn = (String) request.getParameter("total");
                    ServletContext c = session.getServletContext();

                    tdm = (ThreeDimensionMenu) c.getAttribute("myMenu");
                    wbo.setAttribute("groupName", request.getParameter("groupName"));
                    wbo.setAttribute("groupDesc", request.getParameter("groupDesc"));
                    wbo.setAttribute("groupMenu", readRequestToXML(request));
                    String type = request.getParameter("type");
                    String defaultPage = "";
                    if (type.equalsIgnoreCase("mgr")) {
                        defaultPage = "manager_agenda.jsp";
                    } else if (type.equalsIgnoreCase("emp")) {
                        defaultPage = "employee_agenda.jsp";
                    } else if (type.equalsIgnoreCase("call")) {
                        defaultPage = "call_center.jsp";
                    } else if (type.equalsIgnoreCase("admin")) {
                        defaultPage = "administrator.jsp";
                    } else if (type.equalsIgnoreCase("qa")) {
                        defaultPage = "quality_assurance.jsp";
                    } else if (type.equalsIgnoreCase("pm")) {
                        defaultPage = "project_manager.jsp";
                    } else if (type.equalsIgnoreCase("notification")) {
                        defaultPage = "notification_system.jsp";
                    } else if (type.equalsIgnoreCase("monitor")) {
                        defaultPage = "manager_monitor.jsp";
                    } else if (type.equalsIgnoreCase("secretary")) {
                        defaultPage = "secretary_agenda.jsp";
                    } else if (type.equalsIgnoreCase("units")) {
                        defaultPage = "marketing.jsp";
                    } else if (type.equalsIgnoreCase("subDivMonitor")) {
                        defaultPage = "sub_div_manager_monitor.jsp";
                    } else if (type.equalsIgnoreCase("contracts")) {
                        defaultPage = "contracts_agenda.jsp";
                    } else if (type.equalsIgnoreCase("globalNotifications")) {
                        defaultPage = "global_notify_agenda.jsp";
                    } else if (type.equalsIgnoreCase("purchase")) {
                        defaultPage = "purchase_agenda.jsp";
                    } else if (type.equalsIgnoreCase("generalTask")) {
                        defaultPage = "general_task_agenda.jsp";
                    } else if (type.equalsIgnoreCase("sla")) {
                        defaultPage = "sla_agenda.jsp";
                    } else if (type.equalsIgnoreCase("gsla")) {
                        defaultPage = "global_sla_agenda.jsp";
                    } else if (type.equalsIgnoreCase("quality")) {
                        defaultPage = "quality_agenda.jsp";
                    } else if (type.equalsIgnoreCase("qualityAssistant")) {
                        defaultPage = "quality_assistant_agenda.jsp";
                    } else if (type.equalsIgnoreCase("siteTechOffice")) {
                        defaultPage = "site_tech_office_agenda.jsp";
                    } else if (type.equalsIgnoreCase("techOfficeRequest")) {
                        defaultPage = "tech_office_request_agenda.jsp";
                    } else if (type.equalsIgnoreCase("nonDistributed")) {
                        defaultPage = "non_distributed_agenda.jsp";
                    } else if (type.equalsIgnoreCase("procurement")) {
                        defaultPage = "procurement_agenda.jsp";
                    } else if (type.equalsIgnoreCase("procurementRequests")) {
                        defaultPage = "procurement_requests.jsp";
                    } else if (type.equalsIgnoreCase("storeTransactions")) {
                        defaultPage = "store_transactions.jsp";
                    } else if (type.equalsIgnoreCase("generalComplaint")) {
                        defaultPage = "general_complaint_agenda.jsp";
                    } else if (type.equalsIgnoreCase("CSSecretary")) {
                        defaultPage = "customer_servies_agenda.jsp";
                    } else if (type.equalsIgnoreCase("CHD")) {
                        defaultPage = "CHD_agenda.jsp";
                    } else if (type.equalsIgnoreCase("CHDManager")) {
                        defaultPage = "CHD_Manager.jsp";
                    } else if (type.equalsIgnoreCase("customerJobOrderTrack")) {
                        defaultPage = "jobOrderTrack.jsp";
                    } else if (type.equalsIgnoreCase("jOQualityAssurance")) {
                        defaultPage = "jOQualityAssurance.jsp";
                    } else if (type.equalsIgnoreCase("em")) {
                        defaultPage = "EmployeeSheet.jsp";
                    } else if (type.equalsIgnoreCase("contractsNotifications")) {
                        defaultPage = "generic_contracts_agenda.jsp";
                    } else if (type.equalsIgnoreCase("departmentsContracts")) {
                        defaultPage = "dep_contracts_agenda.jsp";
                    } else if (type.equalsIgnoreCase("clientClassifications")) {
                        defaultPage = "client_class_2.jsp";
                    }
                    wbo.setAttribute("defaultPage", defaultPage);
                    String url = request.getParameter("url");
                    String[] pages;
                    pages = url.split(",");

                    if (!groupMgr.getDoubleName(request.getParameter("groupName"))) {
                        if (groupMgr.saveGroup(wbo, session, pages)) {
                            request.setAttribute("status", "ok");
                        } else {
                            request.setAttribute("Status", "No");
                        }

                    } else {
                        request.setAttribute("Status", "No");
                        request.setAttribute("name", "Duplicate Name");
                    }
                } catch (EmptyRequestException ere) {
                    request.setAttribute("status", ere.getMessage());
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                } catch (EntryExistsException eee) {
                    request.setAttribute("status", eee.getMessage());
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                } catch (SQLException sqlEx) {
                    request.setAttribute("status", sqlEx.getMessage());
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                } catch (NoUserInSessionException nouser) {
                    request.setAttribute("status", nouser.getMessage());
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                } catch (Exception Ex) {
                    request.setAttribute("status", Ex.getMessage());
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                }
                servedPage = "/docs/Adminstration/new_group.jsp";

                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 3:
                String key = request.getParameter("groupID");

                // delete from two tables
                userGroupMgr.deleteOnSingleKey(key);
                groupMgr.deleteOnSingleKey(key);

                groupMgr.cashData();

                groupList = groupMgr.getCashedTable();

                servedPage = "/docs/Adminstration/group_list.jsp";

                request.setAttribute("data", groupList);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 4:

                String groupID = request.getParameter("groupID");
                String userId = request.getParameter("userId");

                servedPage = "/docs/Adminstration/confirm_delgroup.jsp";
                WebBusinessObject g = (WebBusinessObject) groupMgr.getOnSingleKey(groupID);

                request.setAttribute("group", g);
                request.setAttribute("userId", userId);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 5:
                servedPage = "/docs/Adminstration/view_group.jsp";

                String groupViewID = request.getParameter("groupID");
                WebBusinessObject viewG = groupMgr.getOnSingleKey(groupViewID);

                if (viewG == null) {
                } else {

                    request.setAttribute("group", viewG);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                }

                break;
            case 6:

                String updateGroupID = request.getParameter("groupID");
                WebBusinessObject editG = groupMgr.getOnSingleKey(updateGroupID);

                servedPage = "/docs/Adminstration/update_group.jsp";

                request.setAttribute("group", editG);

                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 7:
                servedPage = "/docs/Adminstration/update_group.jsp";

                try {

//                    scrapeForm(request, "update");
//                    String newMenu = generateMenuString(activeOptions, ((new Integer(request.getParameter("total"))).intValue()));
                    c = session.getServletContext();

                    tdm = (ThreeDimensionMenu) c.getAttribute("myMenu");
                    wbo.setAttribute("groupName", request.getParameter("groupName"));
                    wbo.setAttribute("groupID", request.getParameter("groupID"));
                    wbo.setAttribute("groupDesc", request.getParameter("groupDesc"));
                    wbo.setAttribute("groupMenu", readRequestToXML(request));
                    String type = request.getParameter("type");
                    String defaultPage = "";
                    if (type.equalsIgnoreCase("mgr")) {
                        defaultPage = "manager_agenda.jsp";
                    } else if (type.equalsIgnoreCase("emp")) {
                        defaultPage = "employee_agenda.jsp";
                    } else if (type.equalsIgnoreCase("call")) {
                        defaultPage = "call_center.jsp";
                    } else if (type.equalsIgnoreCase("admin")) {
                        defaultPage = "administrator.jsp";
                    } else if (type.equalsIgnoreCase("super")) {
                        defaultPage = "supervisor_agenda.jsp";
                    } else if (type.equalsIgnoreCase("tech")) {
                        defaultPage = "technical_agenda.jsp";
                    } else if (type.equalsIgnoreCase("qa")) {
                        defaultPage = "quality_assurance.jsp";
                    } else if (type.equalsIgnoreCase("pm")) {
                        defaultPage = "project_manager.jsp";
                    } else if (type.equalsIgnoreCase("notification")) {
                        defaultPage = "notification_system.jsp";
                    } else if (type.equalsIgnoreCase("monitor")) {
                        defaultPage = "manager_monitor.jsp";
                    } else if (type.equalsIgnoreCase("sales")) {
                        defaultPage = "sales_market.jsp";
                    } else if (type.equalsIgnoreCase("secretary")) {
                        defaultPage = "secretary_agenda.jsp";
                    } else if (type.equalsIgnoreCase("units")) {
                        defaultPage = "marketing.jsp";
                    } else if (type.equalsIgnoreCase("subDivMonitor")) {
                        defaultPage = "sub_div_manager_monitor.jsp";
                    } else if (type.equalsIgnoreCase("contracts")) {
                        defaultPage = "contracts_agenda.jsp";
                    } else if (type.equalsIgnoreCase("globalNotifications")) {
                        defaultPage = "global_notify_agenda.jsp";
                    } else if (type.equalsIgnoreCase("purchase")) {
                        defaultPage = "purchase_agenda.jsp";
                    } else if (type.equalsIgnoreCase("generalTask")) {
                        defaultPage = "general_task_agenda.jsp";
                    } else if (type.equalsIgnoreCase("sla")) {
                        defaultPage = "sla_agenda.jsp";
                    } else if (type.equalsIgnoreCase("gsla")) {
                        defaultPage = "global_sla_agenda.jsp";
                    } else if (type.equalsIgnoreCase("quality")) {
                        defaultPage = "quality_agenda.jsp";
                    } else if (type.equalsIgnoreCase("qualityAssistant")) {
                        defaultPage = "quality_assistant_agenda.jsp";
                    } else if (type.equalsIgnoreCase("siteTechOffice")) {
                        defaultPage = "site_tech_office_agenda.jsp";
                    } else if (type.equalsIgnoreCase("techOfficeRequest")) {
                        defaultPage = "tech_office_request_agenda.jsp";
                    } else if (type.equalsIgnoreCase("nonDistributed")) {
                        defaultPage = "non_distributed_agenda.jsp";
                    } else if (type.equalsIgnoreCase("procurement")) {
                        defaultPage = "procurement_agenda.jsp";
                    } else if (type.equalsIgnoreCase("procurementRequests")) {
                        defaultPage = "procurement_requests.jsp";
                    } else if (type.equalsIgnoreCase("storeTransactions")) {
                        defaultPage = "store_transactions.jsp";
                    } else if (type.equalsIgnoreCase("generalComplaint")) {
                        defaultPage = "general_cimplaint_agenda.jsp";
                    } else if (type.equalsIgnoreCase("CSSecretary")) {
                        defaultPage = "customer_servies_agenda.jsp";
                    } else if (type.equalsIgnoreCase("CHD")) {
                        defaultPage = "CHD_agenda.jsp";
                    } else if (type.equalsIgnoreCase("CHDManager")) {
                        defaultPage = "CHD_Manager.jsp";
                    } else if (type.equalsIgnoreCase("customerJobOrderTrack")) {
                        defaultPage = "jobOrderTrack.jsp";
                    } else if (type.equalsIgnoreCase("jOQualityAssurance")) {
                        defaultPage = "jOQualityAssurance.jsp";
                    }  else if (type.equalsIgnoreCase("em")) {
                        defaultPage = "EmployeeSheet.jsp";
                    }  else if (type.equalsIgnoreCase("contractsNotifications")) {
                        defaultPage = "generic_contracts_agenda.jsp";
                    }  else if (type.equalsIgnoreCase("departmentsContracts")) {
                        defaultPage = "dep_contracts_agenda.jsp";
                    }  else if (type.equalsIgnoreCase("clientClassifications")) {
                        defaultPage = "client_class_2.jsp";
                    }
                    wbo.setAttribute("defaultPage", defaultPage);
                    String url = request.getParameter("url");
                    String[] pages;
                    pages = url.split(",");
                    // do update
                    if (groupMgr.updateGroup(wbo, session)) {
                        if (userGroupMgr.updateGroupPreviliges2(readRequestToXML(request), request.getParameter("groupName"), request.getParameter("groupID"), pages)) {
                            request.setAttribute("status", "ok");
                        } else {
                        }
                    } else {
                        request.setAttribute("status", "No");
                    }

                    // fetch the group again
                    shipBack("ok", request, response);
                    break;
//                } catch (EmptyRequestException ere) {
//                    shipBack(ere.getMessage(), request, response);
//                    break;
//                } catch (SQLException sqlEx) {
//                    shipBack(sqlEx.getMessage(), request, response);
//                    break;
                } catch (NoUserInSessionException nouser) {
                    shipBack(nouser.getMessage(), request, response);
                    break;
                } catch (Exception Ex) {
                    shipBack(Ex.getMessage(), request, response);
                    break;
                }

            case 10:
                groupMgr.cashData();

                groupList = groupMgr.getCashedTable();

                servedPage = "/docs/Adminstration/group_list.jsp";

                request.setAttribute("data", groupList);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 11:
                servedPage = "/docs/user_security/assign_group_previliges.jsp";
                String groupId = (String) request.getParameter("groupId");
                WebBusinessObject groupWbo = groupMgr.getOnSingleKey(groupId);
                GroupPrevMgr groupPrevMgr = GroupPrevMgr.getInstance();
                ArrayList<String> groupPrivilegeList
                        = groupPrevMgr.getGroupPrivilegeCodes(groupId);
                PreviligesTypeMgr previligesTypeMgr = PreviligesTypeMgr.getInstance();
                Vector prevTypeV = previligesTypeMgr.getCashedTable();
                Vector prevliges = new Vector();
                String groupName = (String) groupWbo.getAttribute("groupName");
                WebBusinessObject prevTypeWbo = (WebBusinessObject) prevTypeV.get(0);
                String prevType = (String) prevTypeWbo.getAttribute("id");
                if (request.getParameter("prevType") != null && !request.getParameter("prevType").isEmpty()) {
                    prevType = (String) request.getParameter("prevType");
                }
                try {
                    prevliges = groupPrevMgr.getPrivliges(prevType);
                } catch (SQLException | NoSuchColumnException ex) {
                    Logger.getLogger(GroupServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                request.setAttribute("prevliges", prevliges);
                request.setAttribute("groupPrivilegeList", groupPrivilegeList);
                request.setAttribute("groupId", groupId);
                request.setAttribute("prevType", prevType);
                request.setAttribute("groupName", groupName);
                request.setAttribute("page", servedPage);
                request.setAttribute("prevTypeV", prevTypeV);
                this.forwardToServedPage(request, response);
                break;

            case 12:
                groupId = request.getParameter("groupId");
                String[] checkStore = request.getParameterValues("checkPrev");
                String[] storeCodeArr = request.getParameterValues("prevCode");
                String[] prevTypeArr = request.getParameterValues("prevType");
                String[] storeNameArArr = request.getParameterValues("prevNameAr");
                String[] storeNameEnArr = request.getParameterValues("prevNameEn");
                Vector userStores = new Vector();
                WebBusinessObject userStoreWBO;
                int index;
                if (checkStore != null) {
                    for (String checkStore1 : checkStore) {
                        index = Integer.parseInt(checkStore1);
                        userStoreWBO = new WebBusinessObject();
                        userStoreWBO.setAttribute("storeNameAr", storeNameArArr[index]);
                        userStoreWBO.setAttribute("storeNameEn", storeNameEnArr[index]);
                        userStoreWBO.setAttribute("prevType", prevTypeArr[index]);
                        userStoreWBO.setAttribute("storeCode", storeCodeArr[index]);
                        userStores.add(userStoreWBO);
                    }
                }
                prevType = (String) request.getParameter("prevType");
                groupPrevMgr = GroupPrevMgr.getInstance();
                if (groupPrevMgr.saveGroupPreviliges(groupId, userStores, session, prevType)) {
                    UserMgr userMgr = UserMgr.getInstance();
                    userMgr.userPrevClient(request, response);
                    userMgr.userPrevComplaint(request, response);
                    request.setAttribute("Status", "ok");
                } else {
                    request.setAttribute("Status", "no");
                }
                servedPage = "GroupServlet?op=assignPrevliges&groupId=" + groupId;
                this.forward(servedPage, request, response);
                break;

            case 13:
                servedPage = "/docs/user_security/assign_project_by_group.jsp";
                groupId = (String) request.getParameter("groupId");
                groupWbo = groupMgr.getOnSingleKey(groupId);
                ProjectMgr projectMgr = ProjectMgr.getInstance();
                Vector mainProjectV = new Vector();
                mainProjectV = projectMgr.getAllMainProjects();
                groupName = (String) groupWbo.getAttribute("groupName");
                Vector projectsByGroupV = new Vector();
                ProjectsByGroupMgr projectsByGroupMgr = ProjectsByGroupMgr.getInstance();
                ArrayList<String> projectByGroupList = projectsByGroupMgr.getProjectByGroupList(groupId);
                try {
                    projectsByGroupV = projectsByGroupMgr.getOnArbitraryKey(groupId, "key1");
                } catch (SQLException ex) {
                    Logger.getLogger(GroupServlet.class.getName()).log(Level.SEVERE, null, ex);
                } catch (Exception ex) {
                    Logger.getLogger(GroupServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                // get stores for this
                request.setAttribute("projectByGroupList", projectByGroupList);
                request.setAttribute("mainProjectV", mainProjectV);
                request.setAttribute("groupId", groupId);
                request.setAttribute("groupName", groupName);
                request.setAttribute("groupWbo", groupWbo);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 14:
                groupId = request.getParameter("groupId");
                String[] checkProject = request.getParameterValues("checkPrev");
                String[] projectIdArr = request.getParameterValues("projectId");
                Vector projByGroupV = new Vector();
                projectsByGroupMgr = ProjectsByGroupMgr.getInstance();
                index = 0;
                WebBusinessObject projByGroupWBO = null;
                if (checkProject != null) {
                    for (int i = 0; i < checkProject.length; i++) {
                        index = Integer.parseInt(checkProject[i]);
                        projByGroupWBO = new WebBusinessObject();
                        projByGroupWBO.setAttribute("groupId", groupId);
                        projByGroupWBO.setAttribute("projectId", projectIdArr[index]);
                        projByGroupV.add(projByGroupWBO);
                    }

                    if (projectsByGroupMgr.saveProjectByGroup(groupId, projByGroupV, session)) {
                        request.setAttribute("Status", "ok");
                    } else {
                        request.setAttribute("Status", "no");
                    }
                } else {
                    projectsByGroupMgr.saveProjectByGroup(groupId, projByGroupV, session);
                    request.setAttribute("Status", "ok");
                }

                servedPage = "GroupServlet?op=assignProjectByGroup&groupId=" + groupId;
                this.forward(servedPage, request, response);
                break;
            case 15:
                servedPage = "/docs/user_security/manage_group_members.jsp";
                userGroupMgr = UserGroupMgr.getInstance();
                try {
                    request.setAttribute("userGroupList", UserMgr.getInstance().getUsersByGroup(request.getParameter("groupID")));
                    request.setAttribute("statusMap", UserMgr.getInstance().getUserStatusMap());
                } catch (SQLException ex) {
                    Logger.getLogger(GroupServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                request.setAttribute("groupID", request.getParameter("groupID"));
                this.forward(servedPage, request, response);
                break;

            case 16:
                out = response.getWriter();
                wbo = new WebBusinessObject();
                groupID = request.getParameter("groupID");
                String[] userIDsList = request.getParameterValues("userID");
                if (userIDsList != null) {
                    for (String id : userIDsList) {
                        try {
                            if (userGroupMgr.deleteOnArbitraryDoubleKey(groupID, "key", id, "key6") > 0) {
                                wbo.setAttribute("status", "Ok");
                            } else {
                                wbo.setAttribute("status", "faild");
                            }
                        } catch (Exception ex) {
                            Logger.getLogger(GroupServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    }
                }
                out.write(Tools.getJSONObjectAsString(wbo));
                break;

            case 17:
                servedPage = "/docs/Adminstration/All_Users.jsp";

                UserMgr usersMgr = UserMgr.getInstance();
                UserGroupMgr userGrpMgr = UserGroupMgr.getInstance();

                ArrayList<WebBusinessObject> usersList = new ArrayList<WebBusinessObject>();
                Vector usersIdVector = new Vector();
                WebBusinessObject userWbo = null;

                String grpId = request.getParameter("groupId").toString();

                try {
                    ArrayList<WebBusinessObject> users = usersMgr.getUserList();
                    usersIdVector = userGrpMgr.getGroupUsers(grpId);

                    if (users.size() > 0 && users != null) {
                        for (int i = 0; i < users.size(); i++) {
                            WebBusinessObject wbo = (WebBusinessObject) users.get(i);

                            userWbo = new WebBusinessObject();
                            userWbo.setAttribute("userId", wbo.getAttribute("userId").toString());
                            userWbo.setAttribute("userName", wbo.getAttribute("userName").toString());
                            if (usersIdVector.contains(wbo.getAttribute("userId").toString())) {
                                userWbo.setAttribute("exist", "yes");
                            } else {
                                userWbo.setAttribute("exist", "no");
                            }

                            usersList.add(userWbo);
                        }
                    }
                } catch (Exception ex) {
                    System.out.println("Exception -- Get All users Group " + ex.getMessage());
                }

                request.setAttribute("groupID", grpId);
                request.setAttribute("usersList", usersList);
                this.forward(servedPage, request, response);
                break;

            case 18:
                UserGroupMgr userGroupMgr = UserGroupMgr.getInstance();

                userGroupMgr.saveGroupUsers(request);

                servedPage = "/docs/Adminstration/All_Users.jsp";

                UserMgr userMgr = UserMgr.getInstance();
                UserGroupMgr usersGrpMgr = UserGroupMgr.getInstance();

                ArrayList<WebBusinessObject> UsersList = new ArrayList<WebBusinessObject>();
                Vector usersIdVect = new Vector();
                WebBusinessObject userWBO = null;

                String gropId = request.getParameter("groupID").toString();

                try {
                    ArrayList<WebBusinessObject> users = userMgr.getUserList();
                    usersIdVector = usersGrpMgr.getGroupUsers(gropId);

                    if (users.size() > 0 && users != null) {
                        for (int i = 0; i < users.size(); i++) {
                            WebBusinessObject wbo = (WebBusinessObject) users.get(i);

                            userWbo = new WebBusinessObject();
                            userWbo.setAttribute("userId", wbo.getAttribute("userId").toString());
                            userWbo.setAttribute("userName", wbo.getAttribute("userName").toString());
                            if (usersIdVector.contains(wbo.getAttribute("userId").toString())) {
                                userWbo.setAttribute("exist", "yes");
                            } else {
                                userWbo.setAttribute("exist", "no");
                            }

                            UsersList.add(userWbo);
                        }
                    }
                } catch (Exception ex) {
                    System.out.println("Exception -- Get All users Group " + ex.getMessage());
                }

                request.setAttribute("groupID", gropId);
                request.setAttribute("usersList", UsersList);
                this.forward(servedPage, request, response);
                break;
            //Kareem 
            case 19: 
                //groupMgr.cashData();
                 servedPage = "/docs/Adminstration/group_list_details.jsp";
                  userGroupMgr = UserGroupMgr.getInstance();

                try{
                    Vector groupUsersList = userGroupMgr.getAllGroupUsers();
                    request.setAttribute("data", groupUsersList);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                } catch (Exception ex) {}

                

                
                break;//Kareem end
            case 20:
                out = response.getWriter();
                wbo = new WebBusinessObject();
                groupWbo = new WebBusinessObject();
                groupWbo.setAttribute("groupID", request.getParameter("groupID"));
                groupWbo.setAttribute("groupName", request.getParameter("groupName"));
                groupWbo.setAttribute("userID", (String) persistentUser.getAttribute("userId"));
                try {
                    if (groupMgr.cloneGroup(groupWbo)) {
                        wbo.setAttribute("status", "ok");
                    } else {
                        wbo.setAttribute("status", "fail");
                    }
                } catch (Exception ex) {
                    Logger.getLogger(GroupServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                out.write(Tools.getJSONObjectAsString(wbo));
                break;

            default:
                break;
        }
    }

    public String getServletInfo() {
        return "Group Servlet";
    }

    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     */
    private void scrapeForm(HttpServletRequest request, String mode) throws EmptyRequestException, EntryExistsException, SQLException, Exception {

        String groupName = request.getParameter("groupName");
        String groupDesc = request.getParameter("groupDesc");

        activeOptions = (String[]) request.getParameterValues("mainMenu");
        System.out.print("Active Options 1 2 3 list size................." + activeOptions.length);
        for (int i = 0; i < activeOptions.length; i++) {
            System.out.print(activeOptions[i]);
        }
        if (activeOptions == null || groupName == null || groupDesc.equals("")) {
            throw new EmptyRequestException(tGuide.getMessage("incompleteinput"));
        }

        if (groupName.equals("") || groupDesc.equals("") || activeOptions.length == 0) {
            throw new EmptyRequestException(tGuide.getMessage("incompleteinput"));
        }

        if (mode.equalsIgnoreCase("insert")) {
            WebBusinessObject existingGroup = groupMgr.getOnSingleKey(groupName);

            if (existingGroup != null) {
                throw new EntryExistsException();
            }

        }
    }

    private void shipBack(String message, HttpServletRequest request, HttpServletResponse response) {
        group = groupMgr.getOnSingleKey(request.getParameter("groupID"));
        request.setAttribute("group", group);
        request.setAttribute("status", message);
        request.setAttribute("page", servedPage);
        this.forwardToServedPage(request, response);
    }

    @Override
    protected int getOpCode(String opName) {
        if (opName.equalsIgnoreCase("GetForm")) {
            return 1;
        }
        if (opName.equalsIgnoreCase("SaveGroup")) {
            return 2;
        }
        if (opName.equalsIgnoreCase("Delete")) {
            return 3;
        }
        if (opName.equalsIgnoreCase("ConfirmDelete")) {
            return 4;
        }
        if (opName.equalsIgnoreCase("ViewGroup")) {
            return 5;
        }
        if (opName.equalsIgnoreCase("GetUpdateForm")) {
            return 6;
        }
        if (opName.equalsIgnoreCase("UpdateGroup")) {
            return 7;
        }
        if (opName.equalsIgnoreCase("ListAll")) {
            return 10;
        }
        if (opName.equalsIgnoreCase("assignPrevliges")) {
            return 11;
        }
        if (opName.equalsIgnoreCase("savePrevliges")) {
            return 12;
        }
        if (opName.equalsIgnoreCase("assignProjectByGroup")) {
            return 13;
        }
        if (opName.equalsIgnoreCase("saveProjectByGroup")) {
            return 14;
        }
        if (opName.equalsIgnoreCase("manageGroupMembers")) {
            return 15;
        }
        if (opName.equalsIgnoreCase("removeUsersFromGroupByAjax")) {
            return 16;
        }

        if (opName.equalsIgnoreCase("GetAllUsers")) {
            return 17;
        }

        if (opName.equalsIgnoreCase("SaveUsersGroups")) {
            return 18;
        }
        if (opName.equalsIgnoreCase("ListAllDetails")) { //Kareem
            return 19;
        }//Kareem end
        if (opName.equalsIgnoreCase("cloneGroupAjax")) {
            return 20;
        }
        return 0;
    }

    private String generateMenuString(String[] menu, int iTotal) {
        System.out.print("Active Options.................");
        for (int i = 0; i < menu.length; i++) {
            System.out.print(menu[i]);
        }

        StringBuffer[] sBuffer = new StringBuffer[iTotal];
        for (int i = 0; i < iTotal; i++) {
            sBuffer[i] = new StringBuffer("0");
        }
        for (int i = 0; i < menu.length; i++) {
            int iTemp = (new Integer(menu[i])).intValue() - 1;
            sBuffer[iTemp] = new StringBuffer("1");
        }
        StringBuffer sTemp = new StringBuffer();
        for (int i = 0; i < iTotal; i++) {
            sTemp.append(sBuffer[i]);
        }
        return sTemp.toString();
    }

    public void printNodeElements(Node node) {

        System.out.println(node.getNodeName());
        NodeList children = node.getChildNodes();
        for (int i = 0; i < children.getLength(); i++) {
            Node child = children.item(i);
            if (child.getNodeType() == Node.ELEMENT_NODE) {
                System.out.println("*****************************************");
                printNodeElements(child);
            }
        }
    }

    /*	 * filter all elements whose tag name = filter	 */
    public void filterElements(Node parent, String filter) {
        NodeList children = parent.getChildNodes();
        for (int i = 0; i < children.getLength(); i++) {
            Node child = children.item(i);
            // only interested in elements
            if (child.getNodeType() == Node.ELEMENT_NODE) {
                // remove elements whose tag name  = filter
                // otherwise check its children for filtering with a recursive call
                if (child.getNodeName().equals(filter)) {
                    parent.removeChild(child);
                } else {
                    filterElements(child, filter);
                }
            }
        }
    }

    private String readRequestToXML(HttpServletRequest request) {
        try {
            MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
            DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
            DocumentBuilder dbBuilder = dbFactory.newDocumentBuilder();
            Document doc = dbBuilder.parse(metaDataMgr.getWebInfPath() + "/menu.xml");
            doc.getDocumentElement().normalize();
            NodeList nodeList = doc.getElementsByTagName("menu");
            for (int i = 0; i < nodeList.getLength(); i++) {
                Node nodeMenu = nodeList.item(i);
                String id = nodeMenu.getAttributes().getNamedItem("id").getNodeValue();
                NodeList childList = nodeMenu.getChildNodes();
                for (int j = 0; j < childList.getLength(); j++) {
                    Node nodeMenuChild = childList.item(j);
                    if (("display").equals(nodeMenuChild.getNodeName())) {
                        if (id != null && request.getParameter(id) != null) {
                            nodeMenuChild.setTextContent("1");
                        } else {
                            nodeMenuChild.setTextContent("0");
                        }
                    } else if (("sub_menu").equals(nodeMenuChild.getNodeName())) {
                        String submenuId = nodeMenuChild.getAttributes().getNamedItem("id").getNodeValue();
                        NodeList subMenuChildList = nodeMenuChild.getChildNodes();
                        for (int k = 0; k < subMenuChildList.getLength(); k++) {
                            Node nodeSubMenuChild = subMenuChildList.item(k);
                            if (("display").equals(nodeSubMenuChild.getNodeName())) {
                                if (submenuId != null && request.getParameter(submenuId) != null) {
                                    nodeSubMenuChild.setTextContent("1");
                                } else {
                                    nodeSubMenuChild.setTextContent("0");
                                }
                            } else if (("menu_element").equals(nodeSubMenuChild.getNodeName())) {
                                String elementId = nodeSubMenuChild.getAttributes().getNamedItem("id").getNodeValue();
                                NodeList elementChildList = nodeSubMenuChild.getChildNodes();
                                for (int l = 0; l < elementChildList.getLength(); l++) {
                                    Node nodeElementChild = elementChildList.item(l);
                                    if (("display").equals(nodeElementChild.getNodeName())) {
                                        if (elementId != null && request.getParameter(elementId) != null) {
                                            nodeElementChild.setTextContent("1");
                                        } else {
                                            nodeElementChild.setTextContent("0");
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            DOMSource domSource = new DOMSource(doc);
            StringWriter writer = new StringWriter();
            StreamResult result = new StreamResult(writer);
            TransformerFactory tf = TransformerFactory.newInstance();
            Transformer transformer = tf.newTransformer();
            transformer.transform(domSource, result);
            return writer.toString();
        } catch (ParserConfigurationException ex) {
            Logger.getLogger(GroupServlet.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SAXException ex) {
            Logger.getLogger(GroupServlet.class.getName()).log(Level.SEVERE, null, ex);
        } catch (IOException ex) {
            Logger.getLogger(GroupServlet.class.getName()).log(Level.SEVERE, null, ex);
        } catch (TransformerConfigurationException ex) {
            Logger.getLogger(GroupServlet.class.getName()).log(Level.SEVERE, null, ex);
        } catch (TransformerException ex) {
            Logger.getLogger(GroupServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
        return "";
    }

}
