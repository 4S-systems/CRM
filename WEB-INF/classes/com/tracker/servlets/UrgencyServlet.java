package com.tracker.servlets;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.silkworm.business_objects.*;
import java.util.*;
import java.sql.*;
import com.silkworm.util.*;

import com.tracker.db_access.*;
import com.tracker.business_objects.*;
import com.silkworm.Exceptions.*;

import com.silkworm.servlets.*;
import org.apache.log4j.Logger;

public class UrgencyServlet extends swBaseServlet {

    UrgencyMgr urgencyMgr = UrgencyMgr.getInstance();
    WebUrgency wUrgent = new WebUrgency();
    WebBusinessObject urgency = null;

    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        servedPage = "/docs/Adminstration/new_urgency.jsp";
        logger = Logger.getLogger(UrgencyServlet.class);
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
        HttpSession s = request.getSession();
        String page = null;

        response.setContentType("text/html");

        try {
            if (this.requestHasNoParams(request)) {
                servedPage = "/docs/Adminstration/new_urgency.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
            } else {
                operation = getOpCode((String) request.getParameter("op"));

                switch (operation) {
                    case 1:
                        ArrayList requestAsArray = ServletUtils.getRequestParams(request);
                        ServletUtils.printRequest(requestAsArray);
                        servedPage = "/docs/Adminstration/new_urgency.jsp";

                        refineForm(request);
                        if (urgencyMgr.saveObject(wUrgent, s)) {
                            request.setAttribute("Status", "Ok");
                        } else {
                            request.setAttribute("Status", "No");
                        }

                        request.setAttribute("page", servedPage);
                        this.forwardToServedPage(request, response);
                        break;

                    case 2:
                        Vector urgencyLevel = urgencyMgr.getCashedTable();
                        servedPage = "/docs/Adminstration/urgency_list.jsp";

                        request.setAttribute("data", urgencyLevel);
                        request.setAttribute("page", servedPage);
                        this.forwardToServedPage(request, response);
                        break;

                    case 3:
                        String urgencyName = request.getParameter("urgencyName");

                        servedPage = "/docs/Adminstration/confirm_del_urgency.jsp";

                        request.setAttribute("urgencyName", urgencyName);
                        request.setAttribute("page", servedPage);
                        this.forwardToServedPage(request, response);
                        break;


                    case 4:
                        WebBusinessObject urgency = new WebBusinessObject();
                        servedPage = "/docs/Adminstration/view_urgency.jsp";
                        urgencyName = request.getParameter("urgencyName");

                        urgency = urgencyMgr.getOnSingleKey(urgencyName);
                        request.setAttribute("urgency", urgency);
                        request.setAttribute("page", servedPage);
                        this.forwardToServedPage(request, response);

                        break;

                    case 5:
                        urgencyName = request.getParameter("urgencyName");
                        urgency = urgencyMgr.getOnSingleKey(urgencyName);

                        servedPage = "/docs/Adminstration/update_urgency_level.jsp";

                        request.setAttribute("urgency", urgency);

                        request.setAttribute("page", servedPage);
                        this.forwardToServedPage(request, response);
                        break;
                    case 6:
                        servedPage = "/docs/Adminstration/update_urgency_level.jsp";

                        try {

                            scrapeForm(request, "update");

                            urgency = new WebBusinessObject();
                            urgency.setAttribute("urgencyDesc", request.getParameter("urgencyDesc"));
                            urgency.setAttribute("urgencyName", request.getParameter("urgencyName"));

                            // do update
                            urgencyMgr.updateUrgency(urgency);

                            // fetch the group again
                            shipBack("ok", request, response);
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
                    case 7:
                        try {
                            IssueMgr issueMgr = IssueMgr.getInstance();
                            Integer iTemp = new Integer(issueMgr.hasData("URGENCY_ID", request.getParameter("urgencyName")));
                            if (iTemp.intValue() > 0) {
                                servedPage = "/docs/Adminstration/cant_delete.jsp";
                                request.setAttribute("servlet", "UrgencyServlet");
                                request.setAttribute("list", "ListUrgencyLevels");
                                request.setAttribute("type", "Urgency Level");
                                request.setAttribute("name", request.getParameter("urgencyName"));
                                request.setAttribute("no", iTemp.toString());
                                request.setAttribute("page", servedPage);
                            } else {
                                urgencyMgr.deleteOnSingleKey(request.getParameter("urgencyName"));
                                urgencyMgr.cashData();
                                urgencyLevel = urgencyMgr.getCashedTable();
                                servedPage = "/docs/Adminstration/urgency_list.jsp";

                                request.setAttribute("data", urgencyLevel);
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
        } catch (Exception sqlEx) {
            // forward to error page
            logger.error(sqlEx.getMessage());
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
        return "Short description";
    }

    private void refineForm(HttpServletRequest request) {
        wUrgent.setUrgencyName(request.getParameter("urgencyName"));
        wUrgent.setUrgencyDesc(request.getParameter("urgencyDesc"));
    }

    protected int getOpCode(String opName) {

        if (opName.equalsIgnoreCase("SaveUrgency")) {
            return 1;
        }

        if (opName.equalsIgnoreCase("ListUrgencyLevels")) {
            return 2;
        }

        if (opName.equalsIgnoreCase("ConfirmDelete")) {
            return 3;
        }

        if (opName.equalsIgnoreCase("ViewUrgency")) {
            return 4;
        }

        if (opName.equalsIgnoreCase("GetUpdateForm")) {
            return 5;
        }

        if (opName.equalsIgnoreCase("UpdateUrgency")) {
            return 6;
        }

        if (opName.equalsIgnoreCase("Delete")) {
            return 7;
        }

        return 0;
    }

    private void scrapeForm(HttpServletRequest request, String mode) throws EmptyRequestException, EntryExistsException, SQLException, Exception {

        String urgencyName = request.getParameter("urgencyName");
        String urgencyDesc = request.getParameter("urgencyDesc");

        if (urgencyName == null || urgencyDesc.equals("")) {
            throw new EmptyRequestException(tGuide.getMessage("incompleteinput"));
        }

        if (urgencyName.equals("") || urgencyDesc.equals("")) {
            throw new EmptyRequestException(tGuide.getMessage("incompleteinput"));
        }

        if (mode.equalsIgnoreCase("insert")) {
            WebBusinessObject existingUrgency = urgencyMgr.getOnSingleKey(urgencyName);

            if (existingUrgency != null) {
                throw new EntryExistsException();
            }

        }
    }

    private void shipBack(String message, HttpServletRequest request, HttpServletResponse response) {
        urgency = urgencyMgr.getOnSingleKey(request.getParameter("urgencyName"));
        request.setAttribute("urgency", urgency);
        request.setAttribute("status", message);
        request.setAttribute("page", servedPage);
        this.forwardToServedPage(request, response);

    }
}
