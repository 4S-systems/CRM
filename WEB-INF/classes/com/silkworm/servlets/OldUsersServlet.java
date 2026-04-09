package com.silkworm.servlets;

import java.io.*;
import java.net.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.silkworm.common.UserMgr;
import java.util.*;
import java.sql.*;
import com.silkworm.util.*;
import com.silkworm.business_objects.*;
import org.apache.log4j.Logger;

public class OldUsersServlet extends swBaseServlet {

    /** Initializes the servlet.
     */
    UserMgr userMgr = UserMgr.getInstance();
    WebAppUser webUser = new WebAppUser();

    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        logger = Logger.getLogger(OldUsersServlet.class);

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
        HttpSession s = request.getSession();

        ArrayList requestAsArray = ServletUtils.getRequestParams(request);
        ServletUtils.printRequest(requestAsArray);

        try {
            Vector v = userMgr.getSearchQueryResult(request);
            int count = v.size();

            if (v != null && count > 0) {
                request.setAttribute("AddResult", "invalid");
                forward("/new_suer.jsp", request, response);
            } else {
                request.setAttribute("AddResult", "valid");
                refineForm(request);
                userMgr.saveObject(webUser);
                forward("/new_suer.jsp", request, response);
            }
        } catch (SQLException sqlEx) {
            // forward to errot page
            logger.error(sqlEx.getMessage());
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
        webUser.setUserName((String) request.getParameter("userName"));
        webUser.setPassword((String) request.getParameter("password"));
    }
}
