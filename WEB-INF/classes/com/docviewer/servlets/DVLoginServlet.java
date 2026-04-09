/*
 * DVLoginServlet.java
 *
 * Created on March 18, 2004, 10:16 PM
 */

package com.docviewer.servlets;

import com.maintenance.db_access.IssueEquipmentMgr;
import com.tracker.db_access.IssueMgr;
import java.io.*;

import javax.servlet.*;
import javax.servlet.http.*;

import com.silkworm.servlets.*;

import com.docviewer.db_access.ImageMgr;
import com.docviewer.db_access.QueryMgr;
import com.silkworm.db_access.FavoritesMgr;
import com.silkworm.business_objects.secure_menu.TwoDimensionMenu;
import com.silkworm.international.TouristGuide;

import java.util.*;
import com.silkworm.common.BookmarkMgr;
import com.docviewer.db_access.*;
import com.silkworm.persistence.relational.IQueryMgr;
import com.silkworm.common.UserMgr;
import com.silkworm.common.MetaDataMgr;



/**
 *
 * @author  walid
 * @version
 */

public class DVLoginServlet extends LoginServlet {
    
    /** Initializes the servlet.
     */
    ImageMgr imageMgr = ImageMgr.getInstance();
    DocImgMgr diMgr = DocImgMgr.getInstance();
    BookmarkMgr bmMgr = BookmarkMgr.getInstance();
    FavoritesMgr fvtsMgr = FavoritesMgr.getInstance();
    SeparatorMgr sptrMgr = SeparatorMgr.getInstance();
    IssueMgr issueMgr = IssueMgr.getInstance();
    IssueEquipmentMgr issueEquipmentMgr=IssueEquipmentMgr.getInstance();
    MetaDataMgr mdMgr = MetaDataMgr.getInstance();
    
    FolderMgr fldrMgr = FolderMgr.getInstance();
    UserMgr userMgr = UserMgr.getInstance();
    
    FavoritesBuilder myFavoritesBuilder = null;
    
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
        return "DV Login servlet";
    }
    
    protected void prepareDefaultSetting(HttpServletRequest request, HttpServletResponse response) {
        System.out.println( "Silkworm Software Inc Doc Viewer - Doc Depot Version1.0 Loging in - (DVLoginServlet) ");
        HttpSession session = request.getSession();
        
        String myLocale = mdMgr.getMyLocale();
        
        //if(!myLocale.equalsIgnoreCase("en"))
        //  installMenu(request, response);
        
        QueryMgr qm = new QueryMgr(userObject);
        
        imageMgr.setUser(userObject);
        imageMgr.setQueryMgr(qm);
        
        issueMgr.setUser(userObject);
        userMgr.setUser(userObject);
        userMgr.checkUserDirs();
        
        issueEquipmentMgr.setUser(userObject);
        
        diMgr.setUser(userObject);
        
        
        sptrMgr.setUser(userObject);
        sptrMgr.setQueryMgr((IQueryMgr)qm);
        
        bmMgr.setUser(userObject);
        
        fvtsMgr.setUser(userObject);
        myFavoritesBuilder = new FavoritesBuilder(userObject);
        
        fvtsMgr.setFavoritesBuilder(myFavoritesBuilder);
        fvtsMgr.buildUserFavorits();
        
        
        
        // ---------
        Vector sysFolders = fldrMgr.getSystemFolders(request.getSession());
        if(sysFolders!=null && sysFolders.size()>0) {
            
            session = request.getSession();
            
            session.setAttribute("sysFolders", sysFolders);
            // System.out.println("YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY");
            
        } else {
            
            // System.out.println("FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF");
        }
        
        
        
        //   Vector nodes = fvtsMgr.buildUserFavoritsNodes();
        //   session.setAttribute("fvts", nodes);
        
        //
        
        
        
        //     request.setAttribute("LinkedTree",cabinets);
        
        
        request.setAttribute("page", "splash.jsp");
        request.setAttribute("status", pageInit);
        forward("/main.jsp",request,response);
        
        
        
    }
    protected void installMenu(HttpServletRequest request, HttpServletResponse response) {
        
        HttpSession s = request.getSession();
        
        ServletContext c = s.getServletContext();
        TouristGuide tGuide = new TouristGuide("/com/docviewer/international/Menu");
        
        TwoDimensionMenu tdm = (TwoDimensionMenu) c.getAttribute("myMenu");
        tdm.installMenu(tGuide);
        tGuide = new TouristGuide("/com/docviewer/international/MenuHeader");
        tdm.installMenuHeaders(tGuide);
        
        
    }
}
