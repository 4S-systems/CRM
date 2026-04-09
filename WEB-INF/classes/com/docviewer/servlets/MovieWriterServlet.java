/*
 * MovieWriterServlet.java
 *
 * Created on April 28, 2004, 11:38 AM
 */

package com.docviewer.servlets;

import javax.servlet.*;
import javax.servlet.http.*;
import com.silkworm.servlets.MultipartRequest;
import java.io.*;

import com.docviewer.db_access.ImageMgr;

/**
 *
 * @author  walid
 * @version
 */
public class MovieWriterServlet extends ImageHandlerServlet {
    
    /** Initializes the servlet.
     */
    private String clientName = null;
    private String docImageFilePath = null;
    
    ImageMgr imageMgr = ImageMgr.getInstance();
    
    public void init(){
        
        
        
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
        
        operation =  getOpCode( request.getParameter("op"));
        switch (operation) {
            case 1:
                
                servedPage = "/docs/doc_handling/moviedoc_create.jsp";
                
                
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;
                
                
                
            case 2:
                
   
                
                
                DocViewerMovieFileRenamePolicy ourPolicy = new DocViewerMovieFileRenamePolicy();
                //file limit size of five megabytes
                try {
                    MultipartRequest mpr = new  MultipartRequest(request,edatabase,(5 * 1024 * 1024 * 1024),ourPolicy);
                }
                catch(Exception e) {
                    servedPage = "/docs/doc_handling/moviedoc_create.jsp";
                    
                    request.setAttribute("status",tGuide.getMessage("notok"));
                    request.setAttribute("clientName", clientName);
                    request.setAttribute("page",servedPage);
                    this.forwardToServedPage(request, response);
                }
                
              
                
                File newFile = new File(estorage  +"/" +  DocViewerMovieFileRenamePolicy.getFileName());
                
                if(newFile.exists()) {
                    
                    System.out.println("Yarab : File exist   ");
                    docImageFilePath = DocViewerMovieFileRenamePolicy.getFileName();
                    
                    
                    servedPage = "/docs/doc_handling/moviedoc_create.jsp";
                    
                    request.setAttribute("imageStatus","attached");
                    request.setAttribute("clientName", clientName);
                    request.setAttribute("page",servedPage);
                    this.forwardToServedPage(request, response);
                    
                    break;
                }
                else {
                    servedPage = "/docs/doc_handling/moviedoc_create.jsp";
                    
                    request.setAttribute("clientName", clientName);
                    request.setAttribute("page",servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                }
                
            case 3:
                servedPage = "/docs/doc_handling/select_client.jsp";
                
                
                request.setAttribute("page",servedPage);
                request.setAttribute("destServlet","MovieWriterServlet");
                request.setAttribute("operation","GetDocForm");
                this.forwardToServedPage(request, response);
                break;
                
            case 4:
                
                clientName = request.getParameter("clientName");
                System.out.println("the client name is:  " + clientName);
                
                
                
                servedPage = "/docs/doc_handling/moviedoc_create.jsp";
                
                request.setAttribute("clientName", clientName);
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 5:
                
                if(docCount()== 20) {
                    request.setAttribute("status", "Demo Version Can not save more than 20 documents");
                    
                }
                else {
                    
                    
                    boolean result = imageMgr.saveMovie(request, session,docImageFilePath);
                    
                    if(result) {
                        
                        request.setAttribute("status", "ok");
                    }
                }
                servedPage = "/docs/doc_handling/moviedoc_create.jsp";
                
                request.setAttribute("clientName", clientName);
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;
            default:
                break;
        }
        
        
        
        
    }
    
    /** Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     */
    public void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, java.io.IOException {
        
        // throw new ServletException("GET method used with " + getClass().getName()+": POST method required.");
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
        return "Movie Writer Servlet";
    }
    
    
    public int getOpCode(String opName) {
        
        if(opName.equalsIgnoreCase("CreateDoc")) {
            return 1;
        }
        
        if(opName.equalsIgnoreCase("AttachMOV")) {
            return 2;
        }
        
        if(opName.equalsIgnoreCase("SelectClient")) {
            return 3;
        }
        
        if(opName.equalsIgnoreCase("GetDocForm")) {
            return 4;
        }
        if(opName.equalsIgnoreCase("SaveDoc")) {
            return 5;
        }
        
        
        return 0;
    }
    
    
}
