/*
 * FolderServlet.java
 *
 * Created on April 14, 2005, 4:44 AM
 */

package com.docviewer.servlets;

import java.io.*;
import java.net.*;

import javax.servlet.*;
import javax.servlet.http.*;

import com.silkworm.servlets.swBaseServlet;
import com.docviewer.db_access.*;
import java.util.*;
/**
 *
 * @author Walid
 * @version
 */
public class FolderServlet extends swBaseServlet {
    
    /** Initializes the servlet.
     */
    ImageMgr imageMgr = ImageMgr.getInstance();
    Vector docsList = null;
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
        
        System.out.println("operation is: " + operation);
        //        System.out.println("Besmllah");
        //        ArrayList requestAsArray = ServletUtils.getRequestParams(request);
        //        System.out.println("Request Array Size is " + requestAsArray.size());
        //        ServletUtils.printRequest(requestAsArray);
        
        try {
            switch (operation) {
                case 1:
                    
                    String parentID = request.getParameter("parentID");
                    
                    docsList = imageMgr.getOnArbitraryKey(parentID,"key1");
                    
                    request.setAttribute("data", docsList);
                    request.setAttribute("chosenFolder",parentID);
                    
                    this.forward("/main.jsp",request,response);
                    break;
                case 2:
                    
                     parentID = request.getParameter("docID");
                    
                   
                    request.setAttribute("defDocID",parentID);
                    
                    this.forward("/main.jsp",request,response);
                    break;
                    
                default:
                    
                    
                    break;
            }
            
        } catch(Exception e) {
            System.out.println("Folder sevlet exception " + e.getMessage());
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
        return "Folder Servlet";
    }
    
    
    protected int getOpCode(String opName) {
        if(opName.equalsIgnoreCase("GetChildList"))
            return 1;
        
        if(opName.equalsIgnoreCase("GetChildList"))
            return 1;
        
        if(opName.equalsIgnoreCase("ReturnThisID"))
            return 2;
   
        
        
        
        
        return 0;
    }
}
