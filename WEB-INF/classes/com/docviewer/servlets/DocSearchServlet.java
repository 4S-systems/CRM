/*
 * DocSearchServlet.java
 *
 * Created on March 8, 2005, 1:20 PM
 */

package com.docviewer.servlets;

import java.io.*;
import java.net.*;

import javax.servlet.*;
import javax.servlet.http.*;

import java.sql.*;
//import javax.sql.*;

import com.silkworm.util.*;
import java.util.*;
import com.docviewer.business_objects.Document;

import com.silkworm.persistence.relational.UniqueIDGen;
import com.silkworm.common.MetaDataMgr;

import com.silkworm.business_objects.*;
import com.docviewer.db_access.ImageMgr;

/**
 *
 * @author  Walid
 * @version
 */
public class DocSearchServlet extends ImageHandlerServlet {
    
    
    
    
    String docId = null;
    String filterValue = null;
    String filter = null;
    
    
    
    
    ImageMgr imageMgr = ImageMgr.getInstance();
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    // File docImage = null;
    
    
    
    
    Document doc = null;
    WebBusinessObject VO = new WebBusinessObject();
    Vector docsList = null;
    
    
    
    
    /** Initializes the servlet.
     */
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        
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
        super.processRequest(request,response);
        
        
        String op = (String) request.getParameter("op");
        operation = getOpCode(op);
        
        
        try {
            switch (operation) {
                case 1:
                    
                    
                    servedPage = "/docs/doc_handling/client_interval_search.jsp";
                    
                    
                    request.setAttribute("page",servedPage);
                    request.setAttribute("op", op);
                    this.forwardToServedPage(request, response);
                    break;
//                    String filterValue = request.getParameter("filterValue");
//                    
//                    if (null==filterValue)
//                        filterValue = buildFromDate(request) + ":" + buildToDate(request)+ ">" + request.getParameter("account");
//                    
//                    
//                    
//                    try {
//                        servedPage = "/docs/doc_handling/docs_list.jsp";
//                        docsList = imageMgr.getAccountDocsInRange(request.getParameter("op"),filterValue);
//                        
//                        request.setAttribute("data", docsList);
//                        
//                        request.setAttribute("page",servedPage);
//                        this.forwardToServedPage(request, response);
//                        break;
//                        
//                    }
//                    catch(SQLException sqlEx) {
//                        System.out.println(sqlEx.getMessage());
//                    }
//                    catch(Exception e) {
//                        System.out.println(e.getMessage());
//                    }
//                    
//                    break;
                    
                    
                    
                default:
                    
                    //  this.forwardToServedPage(request, response);
                    break;
            }
            
        }
        catch(Exception e) {
            System.out.println("Docs Search Servlet " + e.getMessage());
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
        return "Docs Search Servlet";
    }
    protected int getOpCode(String opName) {
        
        if(opName.equalsIgnoreCase("GroupAccountDocsInrange"))
            return 1;
        
        return 0;
    }
}
