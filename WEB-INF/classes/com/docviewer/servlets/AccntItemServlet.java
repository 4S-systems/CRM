/*
 * AccntItemServlet.java
 *
 * Created on April 1, 2004, 11:45 AM
 */

package com.docviewer.servlets;

/*
 * AccntItemServlet.java
 *
 * Created on April 2, 2004, 5:35 PM
 */



import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
//import com.docviewer.db_access.ImageMgr;
import com.silkworm.Exceptions.*;
import com.silkworm.servlets.swBaseServlet;
import com.silkworm.common.BookmarkMgr;
import com.silkworm.business_objects.WebBusinessObject;

import java.util.*;
import java.sql.*;
import com.docviewer.db_access.*;
import com.silkworm.db_access.FavoritesMgr;

/**
 *
 * @author  walid
 * @version
 */
public class AccntItemServlet extends swBaseServlet {
    
    boolean saveStatus = true;
    
    /** Initializes the servlet.
     */
    WebBusinessObject wbo = new WebBusinessObject();
    AccountItemMgr accntItemMgr = AccountItemMgr.getInstance();
    SeparatorMgr sptrMgr = SeparatorMgr.getInstance();
    FolderMgr fldrMgr = FolderMgr.getInstance();
    String folderID = null;
    WebBusinessObject folder = null;
    BookmarkMgr bookmarkMgr = BookmarkMgr.getInstance();
    ImageMgr imageMgr = ImageMgr.getInstance();
    
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
        
        
        operation =  getOpCode( request.getParameter("op"));
        switch (operation) {
            case 1:
                
                servedPage = "/docs/bus_admin/new_accntitem.jsp";
                
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 2:
                //scrapeForm(request);
                try {
                    //saveStatus = accntItemMgr.saveObject(wbo,session);
                    saveStatus = sptrMgr.saveObject(request,session);
                    
                    if(saveStatus)
                        request.setAttribute("status", "ok");
                    else
                        request.setAttribute("status", "Error: Duplicate name");
                } catch(NoUserInSessionException noUser) {
                    
                    ;
                }
                
                
                servedPage = "/docs/bus_admin/new_accntitem.jsp";
                
                
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 3:
                servedPage = "/docs/doc_handling/select_client.jsp";
                
                
                request.setAttribute("page",servedPage);
                request.setAttribute("destServlet","AccntItemServlet");
                request.setAttribute("operation","ListAccntItems");
                this.forwardToServedPage(request, response);
                break;
                
                
            case 4:
                
                folderID = request.getParameter("folderID");
                folder = imageMgr.getOnSingleKey(folderID);
                
                try {
                    Vector data = imageMgr.getOnArbitraryKey(folderID,"key1");
                    
                    servedPage = "/docs/bus_admin/accntitem_list.jsp";
                    
                    request.setAttribute("parentFolder",folder);
                    request.setAttribute("data", data);
                    request.setAttribute("page",servedPage);
                    this.forwardToServedPage(request, response);
                } catch(SQLException sex) {
                    
                    servedPage = "/docs/exception/database_error.jsp";
                    request.setAttribute("page",servedPage);
                    this.forwardToServedPage(request, response);
                } catch(Exception ex) {
                    servedPage = "/docs/exception/database_error.jsp";
                    request.setAttribute("page",servedPage);
                    this.forwardToServedPage(request, response);
                    
                }
                
                break;
                
            case 5:
                String docId = request.getParameter("docId");
                String parentID = request.getParameter("parentID");
                String separatorName=request.getParameter("docTitle");
                servedPage = "/docs/bus_admin/confirm_delsep.jsp";
                
                request.setAttribute("docId",docId);
                request.setAttribute("parentID",parentID);
                request.setAttribute("docTitle",separatorName);
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 6:
                
                servedPage = "/docs/doc_handling/select_client.jsp";
                
                request.setAttribute("page",servedPage);
                request.setAttribute("destServlet","AccntItemServlet");
                request.setAttribute("operation","ListFolderTree");
                this.forwardToServedPage(request, response);
                break;
                
                
            case 7:
                
                folderID = request.getParameter("folderID");
                folder = imageMgr.getOnSingleKey(folderID);
                
                try {
                    Vector data = imageMgr.getOnArbitraryKey(folderID,"key1");
                    
                    servedPage = "/docs/bus_admin/rev_folder_design.jsp";
                    
                    request.setAttribute("parentFolder",folder);
                    request.setAttribute("data", data);
                    request.setAttribute("page",servedPage);
                    this.forwardToServedPage(request, response);
                } catch(SQLException sex) {
                    
                    servedPage = "/docs/exception/database_error.jsp";
                    request.setAttribute("page",servedPage);
                    this.forwardToServedPage(request, response);
                } catch(Exception ex) {
                    servedPage = "/docs/exception/database_error.jsp";
                    request.setAttribute("page",servedPage);
                    this.forwardToServedPage(request, response);
                    
                }
                
                break;
                
            case 8:
//
//                fldrMgr.cashData();
//                Vector data = fldrMgr.getCashedTableAsBusObjVector();
//
//                servedPage = "/docs/bus_admin/group_folder_list.jsp";
//
//
//                request.setAttribute("data", data);
//                request.setAttribute("page",servedPage);
//                this.forwardToServedPage(request, response);
                FavoritesMgr fm = FavoritesMgr.getInstance();
                
                Vector cabinets = (Vector) fm.buildLinkedFavoritsTree();
                
                servedPage = "/docs/explorer/doc_explorer2.jsp";
                
                //     request.setAttribute("data", data);
                request.setAttribute("page",servedPage);
                forwardToServedPage(request,response);
                //       this.forward("/main.jsp",request, response);
                
                
                break;
            case 9:
                
                servedPage = "/docs/bus_admin/view_separator.jsp";
                docId =(String) request.getParameter("docId");
                WebBusinessObject separator = imageMgr.getOnSingleKey(docId);
                
                String parentId = (String) separator.getAttribute("parentID");
                WebBusinessObject parent = imageMgr.getOnSingleKey(parentId);
                String parentName = (String) parent.getAttribute("docTitle");
                
//separator = ;
                // separator.printSelf();
                if(null!=separator) {
                    request.setAttribute("parentName", parentName);
                    request.setAttribute("sepObj", separator);
                    request.setAttribute("page",servedPage);
                    this.forwardToServedPage(request,response);
                }
                break;
            case 10:
                servedPage = "/docs/bus_admin/edit_separator.jsp";
                String key = request.getParameter("docId");
                separator = imageMgr.getOnSingleKey(key);
                //separator.printSelf();
                request.setAttribute("sepObj",separator);
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 11:
                servedPage = "/docs/bus_admin/edit_separator.jsp";
                docId=request.getParameter("sepId");
                parentID=request.getParameter("folderID");
                System.out.println("parentID:"+parentID.toString());
                String sepName=request.getParameter("sepName");
                String sepDesc=request.getParameter("sepDesc");
                WebBusinessObject sep = new WebBusinessObject();
                sep.setAttribute("docID", docId);
                sep.setAttribute("docTitle",sepName);
                sep.setAttribute("description", sepDesc);
                sep.setAttribute("parentID", parentID);
                sep.printSelf();
                
                try{
                    imageMgr.updateFolder(sep, session);
                    
                    request.setAttribute("sepObj",sep);
                    request.setAttribute("page", servedPage);
                    request.setAttribute("message", "yasmeen");
                    this.forwardToServedPage(request, response);
                } catch (NoUserInSessionException nousr) {
                    System.out.println("No User In Session: ImageMgr" + nousr.getMessage());
                }
                break;
                
            case 12:
                key = request.getParameter("docId");
                parentID = request.getParameter("parentID");
                WebBusinessObject folderP = imageMgr.getOnSingleKey(parentID);
                
                try {
                    
                    imageMgr.deleteOnSingleKey(key);
                    
                    imageMgr.deleteOnArbitraryKey(key,"key1");
                    
                    System.out.println("before deleting bookmark");
                    bookmarkMgr.deleteOnArbitraryKey(key,"key2");
                    System.out.println("after deleting bookmark");
                    Vector data = new Vector();
                    if(request.getParameter("type") != null && request.getParameter("type").equalsIgnoreCase("ListAllAccntItems")) {
                        data = imageMgr.getListByFileType("FilterOnType", "sptr");
                        servedPage = "/docs/bus_admin/accntitem_list_all.jsp";
                    } else {
                        data = imageMgr.getOnArbitraryKey(parentID,"key1");
                        request.setAttribute("parentFolder",folderP);
                        servedPage = "/docs/bus_admin/accntitem_list.jsp";
                    }
                    
                    
                    request.setAttribute("data", data);
                    request.setAttribute("page",servedPage);
                    this.forwardToServedPage(request, response);
                } catch(SQLException sex) {
                    
                    servedPage = "/docs/exception/database_error.jsp";
                    request.setAttribute("page",servedPage);
                    this.forwardToServedPage(request, response);
                } catch(Exception ex) {
                    servedPage = "/docs/exception/database_error.jsp";
                    request.setAttribute("page",servedPage);
                    this.forwardToServedPage(request, response);
                    
                }
                break;
            case 13:
                servedPage = "/docs/bus_admin/move_separator.jsp";
                key = request.getParameter("docId");
                WebBusinessObject separatorData = imageMgr.getOnSingleKey(key);
                request.setAttribute("docId",key);
                request.setAttribute("sepObj",separatorData);
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 14:
                Vector data;
                servedPage = "/docs/bus_admin/move_separator.jsp";
                docId=request.getParameter("docId");
                parentID=request.getParameter("folderID");
                try{
                    data = imageMgr.getOnArbitraryKey(parentID,"docId");
                } catch(SQLException sex) {
                    
                    servedPage = "/docs/exception/database_error.jsp";
                    request.setAttribute("page",servedPage);
                    this.forwardToServedPage(request, response);
                } catch(Exception ex) {
                    servedPage = "/docs/exception/database_error.jsp";
                    request.setAttribute("page",servedPage);
                    this.forwardToServedPage(request, response);
                    
                }
                sep = new WebBusinessObject();
                sep.setAttribute("docID", docId);
                sep.setAttribute("parentID",parentID);
                
                try{
                    imageMgr.moveSeparator(sep,session);
                    imageMgr.updateDocuments(sep,session);
                    
                    request.setAttribute("sepObj",sep);
                    request.setAttribute("page", servedPage);
                    request.setAttribute("message", "yasmeen");
                    this.forwardToServedPage(request, response);
                } catch (NoUserInSessionException nousr) {
                    System.out.println("No User In Session: ImageMgr" + nousr.getMessage());
                }
                break;
            case 15:
                String sepId = (String) request.getParameter("docId");
                String fldrId = (String) request.getParameter("parentID");
                String sepTitle = (String) request.getParameter("docTitle");
                servedPage = "/docs/doc_handling/make_influence.jsp";
                
                request.setAttribute("page", servedPage);
                request.setAttribute("sepId", sepId);
                request.setAttribute("sepTitle", sepTitle);
                request.setAttribute("fldrId", fldrId);
                this.forwardToServedPage(request, response);
                break;
                
            case 16:
                break;
                
            case 17:
                try {
                    data = imageMgr.getListByFileType("FilterOnType", "sptr");
                    
                    servedPage = "/docs/bus_admin/accntitem_list_all.jsp";
                    request.setAttribute("parentFolder",folder);
                    request.setAttribute("data", data);
                    request.setAttribute("page",servedPage);
                    this.forwardToServedPage(request, response);
                } catch(Exception ex) {
                    servedPage = "/docs/exception/database_error.jsp";
                    request.setAttribute("page",servedPage);
                    this.forwardToServedPage(request, response);
                }
                break;
                
            case 18:
                String filter = null;
                String filterValue = null;
                String destination = null;
                filter = request.getParameter("filter");
                filterValue = request.getParameter("filterValue");
                docId = request.getParameter("docId");
                ImageMgr imageMgr = ImageMgr.getInstance();
                imageMgr.setObsolete(docId);
                destination = context + "/" + filter + "?op=" + filterValue + "&folderID=" + request.getParameter("folderID");
                forward(destination,request,response);
                
                break;
                
            default:
                
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
        return "Account Item Servlet";
    }
    
    public int getOpCode(String opName) {
        
        if(opName.equalsIgnoreCase("NewItem")) {
            return 1;
        }
        
        if(opName.equalsIgnoreCase("SaveItem")) {
            return 2;
        }
        
        if(opName.equalsIgnoreCase("SelectClient")) {
            return 3;
        }
        
        if(opName.equalsIgnoreCase("ListAccntItems")) {
            return 4;
        }
        
        
        if(opName.equalsIgnoreCase("DeleteAccntItems")) {
            return 5;
        }
        
        if(opName.equalsIgnoreCase("RevFolderDesign")) {
            return 6;
        }
        
        if(opName.equalsIgnoreCase("ListFolderTree")) {
            return 7;
        }
        
        if(opName.equalsIgnoreCase("ViewSystemCabinet")) {
            return 8;
        }
        if(opName.equalsIgnoreCase("ViewAccntItems")) {
            return 9;
        }
        if(opName.equalsIgnoreCase("EditAccntItems")) {
            return 10;
        }
        if(opName.equalsIgnoreCase("Submit")) {
            return 11;
        }
        
        if(opName.equalsIgnoreCase("ConfirmDelete")) {
            return 12;
        }
        if(opName.equalsIgnoreCase("MoveAccntItems")) {
            return 13;
        }
        if(opName.equalsIgnoreCase("SubmitMove")) {
            return 14;
        }
        if(opName.equalsIgnoreCase("AddInfluence")) {
            return 15;
        }
        if(opName.equalsIgnoreCase("ConfirmInfluence")) {
            return 16;
        }
        if(opName.equalsIgnoreCase("ListAllAccntItems")) {
            return 17;
        }
        if(opName.equalsIgnoreCase("Obsolete")) {
            return 18;
        }
        return 0;
    }
    
    private void scrapeForm(HttpServletRequest request) {
        
        String desc = request.getParameter("description");
        
        if(desc.equals("")) {
            desc = new String("none was provided");
        }
        
        wbo.setAttribute("itemTitle", request.getParameter("itemTitle"));
        wbo.setAttribute("title", request.getParameter("title")); // ref account
        wbo.setAttribute("accntItemName", request.getParameter("accntItemName")); // ref classification
        
        wbo.setAttribute("description",desc);
    }
}
