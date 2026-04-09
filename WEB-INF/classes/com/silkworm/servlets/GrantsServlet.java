package com.silkworm.servlets;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import java.util.*;
import java.sql.*;
import com.tracker.business_objects.*;
import com.silkworm.db_access.GrantsMgr;
import org.apache.log4j.Logger;

public class GrantsServlet extends swBaseServlet {

    GrantsMgr grantUserMgr = GrantsMgr.getInstance();
    WebIssue wIssue = new WebIssue();
    WebBusinessObject department = null;
    WebBusinessObject userObj = null;
    String viewOrigin = null;
    WebBusinessObject grantUserWbo = new WebBusinessObject();

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        logger = Logger.getLogger(GrantsServlet.class);
        servedPage = "/docs/Adminstration/new_department.jsp";
    }

    /** Destroys the servlet.
     */
    public void destroy() {

    }

    /** Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            super.processRequest(request, response);
            HttpSession session = request.getSession();
            userObj = (WebBusinessObject) session.getAttribute("loggedUser");
            // issueMgr.setUser(userObj);
            String page = null;
            operation = getOpCode((String) request.getParameter("op"));
            switch (operation) {
                case 1:
                    servedPage = "/docs/Adminstration/new_grantUser.jsp";
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 2:
                    String grantName = request.getParameter("grant_name");
                    String grantDesc = request.getParameter("grant_desc");
                    grantUserWbo = new WebBusinessObject();
                    grantUserWbo.setAttribute("grantName", grantName);
                    grantUserWbo.setAttribute("grantDesc", grantDesc);
                    servedPage = "/docs/Adminstration/new_grantUser.jsp";
                    try {
                        if (grantUserMgr.saveObject(grantUserWbo, session)) {
                            request.setAttribute("Status", "Ok");
                        } else {
                            request.setAttribute("Status", "No");
                        }
                    } catch (NoUserInSessionException ex) {
                        logger.error(ex.getMessage());
                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                    }
                    //request.setAttribute("data", issuesList);
                    //request.setAttribute("status", "Unassigned");
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 3:
                    Vector grantUsers = grantUserMgr.getAllgrants();
                    servedPage = "/docs/Adminstration/grantUser_list.jsp";
                    request.setAttribute("data", grantUsers);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 4:
                    grantName = request.getParameter("grant_name");
                    String grantId = request.getParameter("grant_id");
                    servedPage = "/docs/Adminstration/confirm_delGrantUser.jsp";
                    request.setAttribute("grantName", grantName);
                    request.setAttribute("grantId", grantId);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 5:
                    servedPage = "/docs/Adminstration/view_grantUser.jsp";
                    grantId = request.getParameter("grant_id");
                    grantUserWbo = grantUserMgr.getOnSingleKey(grantId);
                    request.setAttribute("grantUserWbo", grantUserWbo);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 6:
                    grantId = request.getParameter("grant_id");
                    grantUserWbo = grantUserMgr.getOnSingleKey(grantId);
                    servedPage = "/docs/Adminstration/update_grantUser.jsp";
                    request.setAttribute("grantUserWbo", grantUserWbo);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 7:
                    servedPage = "/docs/Adminstration/update_grantUser.jsp";
                    String key = request.getParameter("grant_id").toString();
                    try {
                        scrapeForm(request, "update");
                        grantUserWbo = new WebBusinessObject();
                        grantUserWbo.setAttribute("grantName", request.getParameter("grant_name"));
                        grantUserWbo.setAttribute("grantDesc", request.getParameter("grant_desc"));
                        grantUserWbo.setAttribute("grantId", request.getParameter("grant_id"));
                        // do update
                        try {
                            if (!grantUserMgr.getDoubleNameforUpdate(key, request.getParameter("grant_name"))) {
                                if (grantUserMgr.updateGrantUser(grantUserWbo)) {
                                    request.setAttribute("Status", "Ok");
                                    shipBack("ok", request, response);
                                } else {
                                    request.setAttribute("Status", "No");
                                    shipBack("No", request, response);
                                }
                            } else {
                                request.setAttribute("Status", "No");
                                request.setAttribute("name", "Duplicate Name");
                                shipBack("No", request, response);
                            }
                        } catch (NoUserInSessionException ex) {
                            logger.error(ex.getMessage());
                        } catch (Exception ex) {
                            logger.error(ex.getMessage());
                        }
                        // fetch the group again
                        break;
                    } catch (EmptyRequestException ere) {
                        shipBack(ere.getMessage(), request, response);
                        break;
                    } catch (SQLException sqlEx) {
                        shipBack(sqlEx.getMessage(), request, response);
                        break;
                    } catch (NoUserInSessionException nouser) {
                        shipBack(nouser.getMessage(), request, response);
                        break;
                    } catch (Exception Ex) {
                        shipBack(Ex.getMessage(), request, response);
                        break;
                    }
                case 8:
                    grantId = request.getParameter("grant_id");
                    Vector grants = new Vector();
                    grantUserMgr.deleteOnSingleKey(grantId);
                    try {
                        grants = grantUserMgr.getAllgrants();
                    } catch (SQLException ex) {
                        logger.error(ex);
                    }
                    servedPage = "/docs/Adminstration/grantUser_list.jsp";
                    request.setAttribute("data", grants);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                default:
                    this.forwardToServedPage(request, response);
            }
        } catch (SQLException ex) {
            logger.error(ex);
        }


    }

    /** Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /** Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /** Returns a short description of the servlet.
     */
    public String getServletInfo() {
        return "Department Servlet";
    }

    protected int getOpCode(String opName) {

        if (opName.equalsIgnoreCase("GetForm")) {
            return 1;
        }
        if (opName.equalsIgnoreCase("create")) {
            return 2;
        }

        if (opName.equalsIgnoreCase("ListGrants")) {
            return 3;
        }

        if (opName.equalsIgnoreCase("ConfirmDelete")) {
            return 4;
        }

        if (opName.equalsIgnoreCase("ViewGrant")) {
            return 5;
        }

        if (opName.equalsIgnoreCase("GetUpdateForm")) {
            return 6;
        }

        if (opName.equalsIgnoreCase("UpdateGrantUser")) {
            return 7;
        }

        if (opName.equalsIgnoreCase("Delete")) {
            return 8;
        }
//


        return 0;
    }

    private void scrapeForm(HttpServletRequest request, String mode) throws EmptyRequestException, EntryExistsException, SQLException, Exception {

        String grantId = request.getParameter("grant_id");
        String grantDesc = request.getParameter("grant_desc");

        if (grantId == null || grantDesc.equals("")) {
            throw new EmptyRequestException(tGuide.getMessage("incompleteinput"));
        }

        if (grantId.equals("") || grantDesc.equals("")) {
            throw new EmptyRequestException(tGuide.getMessage("incompleteinput"));
        }

        if (mode.equalsIgnoreCase("insert")) {
            WebBusinessObject existingDepartment = grantUserMgr.getOnSingleKey(grantId);

            if (existingDepartment != null) {
                throw new EntryExistsException();
            }

        }
    }

    private void shipBack(String message, HttpServletRequest request, HttpServletResponse response) {
        grantUserWbo = grantUserMgr.getOnSingleKey(request.getParameter("grant_id"));
        request.setAttribute("grantUserWbo", grantUserWbo);
        request.setAttribute("status", message);
        request.setAttribute("page", servedPage);
        this.forwardToServedPage(request, response);

    }
}
