/*
 * GetTaskTabs.java
 *
 * Created on January 12, 2008, 8:14 PM
 */

package com.maintenance.servlets;

import com.tracker.servlets.TrackerBaseServlet;
import java.io.*;
import java.net.*;

import javax.servlet.*;
import javax.servlet.http.*;

/**
 *
 * @author Dalia
 * @version
 */
public class GetTaskTabs  extends TrackerBaseServlet {
    
    /** Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     */
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    }
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        super.processRequest(request, response);
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        request.setAttribute( "periodicMntnce",request.getParameter("periodicMntnce"));
        request.setAttribute( "machineId",request.getParameter("machineId"));
         request.setAttribute( "scheduleId",request.getParameter("scheduleId"));
          request.setAttribute( "issueTitle",request.getParameter("issueTitle"));
        request.setAttribute( "opName",request.getParameter("op"));
      
          
        servedPage = "/docs/equipment/MachineTaps.jsp";
        
        request.setAttribute("page",servedPage);
        this.forwardToServedPage(request, response);
        out.close();
    }
    
    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
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
    // </editor-fold>
}
