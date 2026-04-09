package com.docviewer.servlets;

import com.docviewer.db_access.ImageMgr;
import com.docviewer.business_objects.Document;
import java.io.*;

import javax.servlet.*;
import javax.servlet.http.*;

import com.silkworm.servlets.*;

import com.silkworm.business_objects.*;
import java.util.*;

import com.docviewer.db_access.LockMgr;
import com.silkworm.db_access.FavoritesMgr;

public class LockServlet extends swBaseServlet {
    
    ImageMgr lockMgr = ImageMgr.getInstance();
    private ImageMgr imageMgr = ImageMgr.getInstance();
    WebBusinessObject lock = new WebBusinessObject();
    String filter = null;
    String filterValue = null;
    String docId = null;
    String docTitle = null;
    String destination = null;
    
    String lockId = null;
    FavoritesMgr fvtsMgr = FavoritesMgr.getInstance();
    
    
    
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
        
        operation = getOpCode((String) request.getParameter("op"));
        
        
        try {
            switch (operation) {
                case 1:
                    filter = request.getParameter("filter");
                    filterValue = request.getParameter("filterValue");
                    docId = request.getParameter("docId");
                    
                    //lock.setAttribute("docId",docId);
                    
                    if(!lockMgr.lockDocument(docId)) {
                        System.out.println("Can't save lock");
                        servedPage = "/docs/exception/database_error.jsp";
                        request.setAttribute("page",servedPage);
                        this.forwardToServedPage(request, response);
                        break;
                    }
                    destination = context + "/" + filter + "?op=" + filterValue + "&folderID=" + request.getParameter("folderID");;
                    forward(destination,request,response);
                    
                    break;
                    
                case 2:
                    filter = request.getParameter("filter");
                    filterValue = request.getParameter("filterValue");
                    WebBusinessObject waUser = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
                    docId = request.getParameter("docId");
                    
                    if(!lockMgr.unlockDocument(docId)) {
                        System.out.println("Can't save lock");
                        servedPage = "/docs/exception/database_error.jsp";
                        request.setAttribute("page",servedPage);
                        this.forwardToServedPage(request, response);
                        break;
                    }
                    destination = context + "/" + filter + "?op=" + filterValue + "&folderID=" + request.getParameter("folderID");;
                    forward(destination,request,response);
                    break;
                    
                default:
                    this.forwardToServedPage(request, response);
                    
            }
        } catch(Exception e) {
            System.out.println("Lock sevlet exception " + e.getMessage());
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
    
    protected int getOpCode(String opName) {
        if(opName.equalsIgnoreCase("SaveLock"))
            return 1;
        
        if(opName.equalsIgnoreCase("RemoveLock"))
            return 2;
        
        return 0;
    }
}