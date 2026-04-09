/*
 * FolderServlet.java
 *
 * Created on April 14, 2005, 4:44 AM
 */

package com.docviewer.servlets;

import java.io.*;

import javax.servlet.*;
import javax.servlet.http.*;

import com.silkworm.servlets.swBaseServlet;
import com.docviewer.db_access.*;
import java.util.*;
import com.silkworm.business_objects.*;

/**
 *
 * @author Walid
 * @version
 */
public class BusinessDocServlet extends swBaseServlet {
    
    /** Initializes the servlet.
     */
    
    private DocTypeMgr dtMgr = DocTypeMgr.getInstance();
    DocTypeMgr doctypeMgr = DocTypeMgr.getInstance();
    WebBusinessObject docType = null;
    // WebBusinessObject wbo = new WebBusinessObject();
    Vector docList = null;
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
        HttpSession session = request.getSession();
        
        
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
                    
                    servedPage = "/docs/bus_admin/new_doc_type.jsp";
                    request.setAttribute("page",servedPage);
                    this.forwardToServedPage(request,response);
                    
                    //                    String parentID = request.getParameter("parentID");
                    //
                    //                    docsList = imageMgr.getOnArbitraryKey(parentID,"key1");
                    //
                    //                    request.setAttribute("data", docsList);
                    //                    request.setAttribute("chosenFolder",parentID);
                    //
                    //                    this.forward("/main.jsp",request,response);
                    break;
                case 2:
                    
                    //                     parentID = request.getParameter("docID");
                    //
                    //
                    //                    request.setAttribute("defDocID",parentID);
                    //
                    //                    this.forward("/main.jsp",request,response);
                    try {
                        
                        boolean   saveStatus = dtMgr.saveObject(request,session);
                        
                        if(saveStatus) {
                            request.setAttribute("status", "ok");                           
                            
                        } else {
                            request.setAttribute("status", "Error :Duplicate name");
                        }
                    } catch(Exception ex) {
                        ;
                    }
                    
                    
                    
                    servedPage = "/docs/bus_admin/new_doc_type.jsp";
                    
                    
                    request.setAttribute("page",servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 3:
                    
//                    dtMgr.cashData();
//                    Vector docTypeList = dtMgr.getCashedTable();
                    Vector docTypeList = doctypeMgr.getCashedTable();
                    //System.out.println("fldr List Size = "+fldrList.size());
                    
                    servedPage = "/docs/bus_admin/doc_type_list.jsp";
                    
                    request.setAttribute("data", docTypeList);
                    request.setAttribute("page",servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                    
                    
                case 4:
                    
                    servedPage = "/docs/bus_admin/view_doctype_detl.jsp";
                    String docTypeID =(String) request.getParameter("docTypeID");
                    docType = dtMgr.getOnSingleKey(docTypeID);
                    // System.out.println(docTypeID);
                    
                    if(null!=docType) {
                        request.setAttribute("docTypeObj", docType);
                        request.setAttribute("page",servedPage);
                        this.forwardToServedPage(request,response);
                        
                    } else {
                        
                        System.out.println("It is null");
                    }
                    break;
                case 5:
                    servedPage = "/docs/Adminstration/update_document.jsp";
                    docTypeID =(String) request.getParameter("typeID");
                    docType = dtMgr.getOnSingleKey(docTypeID);
                    docType.printSelf();
                    
                    request.setAttribute("docTypeObj", docType);
                    request.setAttribute("page",servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 6:
                   
                    servedPage="/docs/Adminstration/update_document.jsp";
                    
                    try {
                        docTypeID= request.getParameter("docTypeID");
                        String typeName=request.getParameter("docType");
                        String description=request.getParameter("docDesc");
                        WebBusinessObject newObj= new WebBusinessObject();
                        
                        newObj.setAttribute("typeID", docTypeID);
                        newObj.setAttribute("typeName", typeName);
                        newObj.setAttribute("desc", description);
                        newObj.printSelf();
                        dtMgr.updateDocType(newObj, session);
                        
                        newObj=dtMgr.getOnSingleKey(docTypeID);
                        request.setAttribute("docTypeObj",newObj);
                        request.setAttribute("page", servedPage);
                        request.setAttribute("message", "yasmeen");
                        this.forwardToServedPage(request, response);                                                                 
                        
                    } catch(Exception e) {
                        // System.out.println("Folder sevlet exception " + e.getMessage());
                    }
                    break;
                case 7:
                    
                    docTypeID = request.getParameter("typeID");
                    docType = dtMgr.getOnSingleKey(docTypeID);
                    docType.printSelf();                 
                    servedPage = "/docs/bus_admin/confirm_deletedoc.jsp";
                    request.setAttribute("docTypeObj",docType);
                    request.setAttribute("typeID",docTypeID);
                    request.setAttribute("page",servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 8:
                    String key = request.getParameter("typeID");
                    dtMgr.deleteOnSingleKey(key);
                    dtMgr.cashData();
                    docList = dtMgr.getCashedTable();
                    servedPage = "/docs/bus_admin/doc_type_list.jsp";
                    request.setAttribute("data", docList);
                    request.setAttribute("page",servedPage);
                    this.forwardToServedPage(request, response);
                    break;
            }
        } catch(Exception e) {
            // System.out.println("Folder sevlet exception " + e.getMessage());
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
        return "Business Doc  Servlet";
    }
    
    
    protected int getOpCode(String opName) {
        if(opName.equalsIgnoreCase("NewDocClass"))
            return 1;
        
        if(opName.equalsIgnoreCase("SaveClass"))
            return 2;
        
        if(opName.equalsIgnoreCase("ListDocClass"))
            return 3;
        if(opName.equalsIgnoreCase("ViewDocType"))
            return 4;
        if(opName.equalsIgnoreCase("UpdateDocType"))
            return 5;
        if(opName.equalsIgnoreCase("Submit"))
            return 6;
        if(opName.equalsIgnoreCase("ConfirmDelete"))
            return 8;
        if(opName.equalsIgnoreCase("DeleteDocType"))
            return 7;
        
        
        
        return 0;
    }
}
