package com.tracker.servlets;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import java.util.*;
import java.sql.*;
import com.silkworm.logger.db_access.LoggerMgr;
import com.tracker.common.*;
import com.tracker.db_access.*;
import com.tracker.business_objects.*;
import com.silkworm.servlets.*;
import org.apache.log4j.Logger;

public class DepartmentServlet extends swBaseServlet {

    DepartmentMgr departmentMgr = DepartmentMgr.getInstance();
    LoggerMgr loggerMgr = LoggerMgr.getInstance();
    WebBusinessObject loggerWbo = new WebBusinessObject();
    WebIssue wIssue = new WebIssue();
    WebBusinessObject department = null;
    WebBusinessObject userObj = null;
    String viewOrigin = null;

    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        servedPage = "/docs/Adminstration/new_department.jsp";
        logger = Logger.getLogger(DepartmentServlet.class);
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


        super.processRequest(request, response);
        HttpSession session = request.getSession();
        userObj = (WebBusinessObject) session.getAttribute("loggedUser");

        // issueMgr.setUser(userObj);

        String page = null;

        operation = getOpCode((String) request.getParameter("op"));

        switch (operation) {
            case 1:
                String issueId = request.getParameter(IssueConstants.ISSUEID);
                String issueTitle = request.getParameter(IssueConstants.ISSUETITLE);

                servedPage = "/docs/Adminstration/new_department.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);


                break;

            case 2:

                String dName = request.getParameter("department_name");
                String dDescription = request.getParameter("department_desc");

                WebBusinessObject department = new WebBusinessObject();

                department.setAttribute("departmentName", dName);
                department.setAttribute("departmentDesc", dDescription);

                servedPage = "/docs/Adminstration/new_department.jsp";
                try {
                    if (!departmentMgr.getDoubleName(request.getParameter("department_name"))) {
                        if (departmentMgr.saveObject(department, session)) {
                            request.setAttribute("Status", "Ok");
                        } else {
                            request.setAttribute("Status", "No");
                        }

                    } else {
                        request.setAttribute("Status", "No");
                        request.setAttribute("name", "Duplicate Name");
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
                Vector departments = departmentMgr.getCashedTable();
                servedPage = "/docs/Adminstration/department_list.jsp";

                request.setAttribute("data", departments);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 4:
                String departmentName = request.getParameter("departmentName");
                String departmentId = request.getParameter("departmentId");

                servedPage = "/docs/Adminstration/confirm_deldepartment.jsp";

                request.setAttribute("departmentName", departmentName);
                request.setAttribute("departmentId", departmentId);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;


            case 5:
                servedPage = "/docs/Adminstration/view_department.jsp";
                departmentId = request.getParameter("departmentId");

                department = departmentMgr.getOnSingleKey(departmentId);
                request.setAttribute("department", department);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);

                break;

            case 6:
                departmentId = request.getParameter("departmentId");
                department = departmentMgr.getOnSingleKey(departmentId);

                servedPage = "/docs/Adminstration/update_department.jsp";

                request.setAttribute("department", department);

                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 7:
                servedPage = "/docs/Adminstration/update_department.jsp";
                String key = request.getParameter("departmentID").toString();

                try {

                    scrapeForm(request, "update");

                    department = new WebBusinessObject();
                    department.setAttribute("departmentName", request.getParameter("departmentName"));
                    department.setAttribute("departmentDesc", request.getParameter("department_desc"));
                    department.setAttribute("departmentID", request.getParameter("departmentID"));

                    // do update
                    try {
                        if (!departmentMgr.getDoubleNameforUpdate(key, request.getParameter("departmentName"))) {
                            if (departmentMgr.updateDepartment(department)) {
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
                try {
                    IssueMgr issueMgr = IssueMgr.getInstance();
                    Integer iTemp = new Integer(issueMgr.hasData("Department_NAME", request.getParameter("departmentName")));
                    if (iTemp.intValue() > 0) {
                        servedPage = "/docs/Adminstration/cant_delete.jsp";
                        request.setAttribute("servlet", "DepartmentServlet");
                        request.setAttribute("list", "ListDepartments");
                        request.setAttribute("type", "Department");
                        request.setAttribute("name", request.getParameter("departmentName"));
                        request.setAttribute("no", iTemp.toString());
                        request.setAttribute("page", servedPage);
                    } else {
                        loggerWbo = new WebBusinessObject();
                        fillLoggerWbo(request, loggerWbo);
                        if (departmentMgr.deleteOnSingleKey(request.getParameter("departmentId"))) {
                            try {
                                loggerMgr.saveObject(loggerWbo);
                            } catch (SQLException ex) {
                                logger.error(ex);
                            }
                        }
                        departmentMgr.cashData();
                        departments = departmentMgr.getCashedTable();
                        servedPage = "/docs/Adminstration/department_list.jsp";

                        request.setAttribute("data", departments);
                        request.setAttribute("page", servedPage);
                    }
                    this.forwardToServedPage(request, response);
                } catch (NoUserInSessionException ne) {
                }

                break;



            default:
                this.forwardToServedPage(request, response);



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

        if (opName.equalsIgnoreCase("GetDepartmentForm")) {
            return 1;
        }
        if (opName.equalsIgnoreCase("create")) {
            return 2;
        }

        if (opName.equalsIgnoreCase("ListDepartments")) {
            return 3;
        }

        if (opName.equalsIgnoreCase("ConfirmDelete")) {
            return 4;
        }

        if (opName.equalsIgnoreCase("ViewDepartment")) {
            return 5;
        }

        if (opName.equalsIgnoreCase("GetUpdateForm")) {
            return 6;
        }

        if (opName.equalsIgnoreCase("UpdateDepartment")) {
            return 7;
        }

        if (opName.equalsIgnoreCase("Delete")) {
            return 8;
        }
//


        return 0;
    }

    private void scrapeForm(HttpServletRequest request, String mode) throws EmptyRequestException, EntryExistsException, SQLException, Exception {

        String departmentID = request.getParameter("departmentID");
        String departmentDesc = request.getParameter("department_desc");

        if (departmentID == null || departmentDesc.equals("")) {
            throw new EmptyRequestException(tGuide.getMessage("incompleteinput"));
        }

        if (departmentID.equals("") || departmentDesc.equals("")) {
            throw new EmptyRequestException(tGuide.getMessage("incompleteinput"));
        }

        if (mode.equalsIgnoreCase("insert")) {
            WebBusinessObject existingDepartment = departmentMgr.getOnSingleKey(departmentID);

            if (existingDepartment != null) {
                throw new EntryExistsException();
            }

        }
    }

    private void fillLoggerWbo(HttpServletRequest request, WebBusinessObject loggerWbo) {
        WebBusinessObject objectXml = departmentMgr.getOnSingleKey(request.getParameter("departmentId"));
        loggerWbo.setAttribute("objectXml", objectXml.getObjectAsXML());
        loggerWbo.setAttribute("realObjectId", request.getParameter("departmentId"));
        loggerWbo.setAttribute("userId", userObj.getAttribute("userId"));
        loggerWbo.setAttribute("objectName", "Department");
        loggerWbo.setAttribute("loggerMessage", "Department Deleted");
        loggerWbo.setAttribute("eventName", "Delete");
        loggerWbo.setAttribute("objectTypeId", "5");
        loggerWbo.setAttribute("eventTypeId", "2");
        loggerWbo.setAttribute("ipForClient", getClientIpAddr(request));
    }

    private void shipBack(String message, HttpServletRequest request, HttpServletResponse response) {
        department = departmentMgr.getOnSingleKey(request.getParameter("departmentID"));
        request.setAttribute("department", department);
        request.setAttribute("status", message);
        request.setAttribute("page", servedPage);
        this.forwardToServedPage(request, response);

    }
}
