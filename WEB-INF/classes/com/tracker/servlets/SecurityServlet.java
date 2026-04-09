/*
 * SecurityServlet.java
 *
 * Created on March 5, 2004, 4:19 PM
 */
package com.tracker.servlets;

import java.io.*;

import javax.servlet.*;
import javax.servlet.http.*;

import com.tracker.common.*;
import org.apache.log4j.Logger;


/**
 *
 * @author  walid
 * @version
 */
public class SecurityServlet extends TrackerBaseServlet {

    /** Initializes the servlet.
     */
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        logger = Logger.getLogger(SecurityServlet.class);

    }

    /** Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        super.processRequest(request, response);
        try {
            switch (operation) {
                case 1:

                    String projectname = request.getParameter("projectName");
                    //  issueStatus = request.getParameter("issueState");
                    // String issueId = request.getParameter("id");

                    // ais = IssueStatusFactory.getStateClass(issueStatus);
                    filterName = request.getParameter("filterName");
                    filterValue = request.getParameter("filterValue");
                    servedPage = "/docs/security/unauthorized_state_access.jsp";
                    //  viewOrigin = request.getParameter("viewOrigin");
                    //  ais.setCentralViewLink(AppConstants.getFullLink(viewOrigin));
                    //  ais.setViewOrigin(viewOrigin);

                    //  servedPage = "/docs/security/unauthorized_state_access.jsp";
                    //request.setAttribute("issueState", issueStatus);
                    //request.setAttribute("state",ais);
                    request.setAttribute("filterName", filterName);
                    request.setAttribute("filterValue", filterValue);
                    request.setAttribute("projectName", projectname);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 2:

                    break;
                case 3:


                    break;

                case 4:



                    break;

                default:
                    this.forwardToServedPage(request, response);
            }
        } catch (Exception e) {
            logger.error("Book mark sevlet exception " + e.getMessage());
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
        return "Security Servlet";
    }

    protected int getOpCode(String opName) {
        if (opName.equalsIgnoreCase(AppConstants.NOT_ISSUE_OWENER)) {
            return 1;
        }

        if (opName.equals("save")) {
            return 2;
        }

        if (opName.equals("delete")) {
            return 3;
        }

        if (opName.equals("view")) {
            return 4;
        }

        return 0;
    }
}
