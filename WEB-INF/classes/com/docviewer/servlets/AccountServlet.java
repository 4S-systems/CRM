/*
 * AccountServlet.java
 *
 * Created on April 1, 2004, 7:50 AM
 */

package com.docviewer.servlets;

import com.silkworm.common.BookmarkMgr;
import com.silkworm.common.GroupMgr;
import java.io.*;
import java.sql.SQLException;
import javax.servlet.*;
import javax.servlet.http.*;

import com.silkworm.servlets.*;
import java.util.*;

import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.common.bus_admin.*;

import com.silkworm.Exceptions.*;
import com.docviewer.db_access.*;

// to-do this class should be moved out of this package - I put it here by mistake
import com.docviewer.db_access.AccountItemMgr;
/**
 *
 * @author  walid
 * @version
 */
public class AccountServlet extends swBaseServlet {
    
    /** Initializes the servlet.
     */
    WebBusinessObject wbo = new WebBusinessObject();
    Vector separators=null;
    AccountMgr accntMgr = AccountMgr.getInstance();
    FolderMgr fldrMgr = FolderMgr.getInstance();
    ImageMgr imgMgr = ImageMgr.getInstance();
    BookmarkMgr bookmarkMgr = BookmarkMgr.getInstance();
    AccountItemMgr accntItemMgr = AccountItemMgr.getInstance();
    Vector accntList = null;
    Vector fldrList = null;
    String key = null;
    WebBusinessObject accnt = null;
    boolean saveStatus = true;
    FolderGroupMgr folderGroupMgr = FolderGroupMgr.getInstance();
    
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
                
                servedPage = "/docs/bus_admin/new_account.jsp";
                
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 2:
                
                //scrapeForm(request);
                try {
                    saveStatus = fldrMgr.saveObject(request,session);
                    
                    if(saveStatus) {
                        request.setAttribute("status", "ok");
                        
                        Vector sysFolders = fldrMgr.getSystemFolders(request.getSession());
                        
                        
                        HttpSession   mySession = request.getSession();
                        mySession.removeAttribute("sysFolders");
                        mySession.setAttribute("sysFolders", sysFolders);
                        
                    } else {
                        request.setAttribute("status", "Error :Duplicate name");
                    }
                } catch(NoUserInSessionException noUser) {
                    
                    ;
                }
                
                
                
                servedPage = "/docs/bus_admin/new_account.jsp";
                
                
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 3:
                
                fldrMgr.cashData();
                fldrList = fldrMgr.getCashedTable();
                System.out.println("fldr List Size = "+fldrList.size());
                
                servedPage = "/docs/bus_admin/accnt_list.jsp";
                
                request.setAttribute("data", fldrList);
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 4:
                
                String fldrId = request.getParameter("docId");
                String fldrTitle = request.getParameter("docTitle");
                
                servedPage = "/docs/bus_admin/confirm_delfldr.jsp";
                
                request.setAttribute("fldrId",fldrId);
                request.setAttribute("fldrTitle",fldrTitle);
                
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 5:
                
                key = request.getParameter("fldrId");
                imgMgr.deleteRefIntegKey(key);
                bookmarkMgr.deleteRefIntegKey(key);
                Enumeration e = null;
                try {
                    separators= imgMgr.getOnArbitraryKey(key, "key1");
                    e= separators.elements();
                    while(e.hasMoreElements()) {
                        wbo = (WebBusinessObject) e.nextElement();
                        String sepId= (String) wbo.getAttribute("docID");
                        try {
                            imgMgr.deleteOnArbitraryKey(sepId, "key1");
                            bookmarkMgr.deleteOnArbitraryKey(sepId,"key2");
                        } catch (SQLException sex) {
                            System.out.println(sex.getMessage());
                        } catch (Exception ex) {
                            System.out.println(ex.getMessage());
                        }
                    }
                    imgMgr.deleteOnArbitraryKey(key, "key1");
                    folderGroupMgr.deleteOnSingleKey(key);
                    
                    
                } catch (SQLException sex) {
                    System.out.println(sex.getMessage());
                } catch (Exception ex) {
                    System.out.println(ex.getMessage());
                }
                fldrMgr.cashData();
                fldrList = fldrMgr.getCashedTable();
                
                servedPage = "/docs/bus_admin/accnt_list.jsp";
                
                request.setAttribute("data", fldrList);
                request.setAttribute("page",servedPage);
                
                
                
                Vector sysFolders = fldrMgr.getSystemFolders(request.getSession());
                
                
                HttpSession mySession = request.getSession();
                mySession.removeAttribute("sysFolders");
                mySession.setAttribute("sysFolders", sysFolders);
                
                this.forwardToServedPage(request, response);
                break;
                
            case 6:
                key = request.getParameter("docId");
                WebBusinessObject fldr = imgMgr.getOnSingleKey(key);
                servedPage = "/docs/bus_admin/fldr_details.jsp";
                request.setAttribute("page",servedPage);
                request.setAttribute("fldrObject", fldr);
                this.forwardToServedPage(request, response);
                break;
            case 7:
                System.out.println("in edit case");
                servedPage = "/docs/bus_admin/edit_account.jsp";
                key = request.getParameter("fldrId");
                fldr = imgMgr.getOnSingleKey(key);
                fldr.printSelf();
                request.setAttribute("fldrObject",fldr);
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 8:
                servedPage = "/docs/bus_admin/edit_account.jsp";
                fldrId=request.getParameter("fldrId");
                String fldrName=request.getParameter("fldrName");
                String fldrDesc=request.getParameter("fldrDesc");
                WebBusinessObject fldrObj= new WebBusinessObject();
                
                fldrObj.setAttribute("docID", fldrId);
                fldrObj.setAttribute("docTitle",fldrName);
                fldrObj.setAttribute("description", fldrDesc);
                fldrObj.printSelf();
                folderGroupMgr.deleteOnSingleKey(fldrId);
                try{
                    //FolderGroupMgr folderGroupMgr = FolderGroupMgr.getInstance();
                    GroupMgr groupMgr = GroupMgr.getInstance();
                    String[] folderGroups = null;
                    folderGroups = (String[]) request.getParameterValues("userGroups");
                    Vector vTemp = new Vector();
                    for(int i = 0; i < folderGroups.length; i++) {
                        System.out.println("Group at " + i + " = " + folderGroups[i]);
                        vTemp = groupMgr.getOnArbitraryKey(folderGroups[i], "key2");
                        folderGroupMgr.saveObject(request, session, vTemp, fldrId);
                    }
                    imgMgr.updateFolder(fldrObj, session);
                    
                    request.setAttribute("fldrObject",fldrObj);
                    request.setAttribute("page", servedPage);
                    request.setAttribute("message", "yasmeen");
                    sysFolders = fldrMgr.getSystemFolders(request.getSession());

                    mySession = request.getSession();
                    mySession.removeAttribute("sysFolders");
                    mySession.setAttribute("sysFolders", sysFolders);
                    this.forwardToServedPage(request, response);
                } catch (NoUserInSessionException nousr) {
                    System.out.println("No User In Session: ImageMgr" + nousr.getMessage());
                } catch(SQLException se) {
                    
                } catch(Exception ex) {
                    
                }
                break;
                
            default:
                break;
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
        return "Account Sevlet";
    }
    
    public int getOpCode(String opName) {
        
        if(opName.equalsIgnoreCase("NewAccount")) {
            return 1;
        }
        
        if(opName.equalsIgnoreCase("SaveAccount")) {
            return 2;
        }
        
        if(opName.equalsIgnoreCase("ListAll")) {
            return 3;
        }
        
        if(opName.equalsIgnoreCase("ConfirmDelete")) {
            return 4;
        }
        
        if(opName.equalsIgnoreCase("Delete"))
            return 5;
        
        if(opName.equalsIgnoreCase("ViewDetails"))
            return 6;
        if(opName.equalsIgnoreCase("Edit"))
            return 7;
        if(opName.equalsIgnoreCase("Submit"))
            return 8;
        
        
        return 0;
    }
    private void scrapeForm(HttpServletRequest request) {
        
        String desc = request.getParameter("accDesc");
        System.out.println("ddddddddddddddddddd " + desc);
        if(desc.equals("")) {
            desc = new String("none was provided");
        }
        
        wbo.setAttribute("accTitle", request.getParameter("accTitle"));
        wbo.setAttribute("accDesc",desc);
    }
    
}
