package com.tracker.servlets;

import com.docviewer.db_access.DocImgMgr;
import com.docviewer.db_access.ImageMgr;
import com.docviewer.db_access.QueryMgr;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.common.MetaDataMgr;
import com.silkworm.common.UserMgr;
import com.silkworm.servlets.*;
import com.tracker.db_access.*;
import com.silkworm.business_objects.secure_menu.TwoDimensionMenu;
import com.silkworm.common.GroupMgr;
import com.silkworm.common.SecurityUser;
import com.silkworm.international.TouristGuide;
import com.silkworm.common.UserGroupMgr;

import java.io.*;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.*;
import javax.servlet.http.*;

public class TrackerLoginServlet extends LoginServlet {

    IssueMgr issueMgr = IssueMgr.getInstance();
    MetaDataMgr mdMgr = MetaDataMgr.getInstance();
    ImageMgr imageMgr = ImageMgr.getInstance();
    UserMgr userMgr = UserMgr.getInstance();
    DocImgMgr diMgr = DocImgMgr.getInstance();

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    }

    @Override
    public void destroy() {
    }

    @Override
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        super.processRequest(request, response);

    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "DV Login servlet";
    }

    @Override
    protected void prepareDefaultSetting(HttpServletRequest request, HttpServletResponse response) {
        HttpSession session = request.getSession();

        WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
        SecurityUser securityUser = (SecurityUser) request.getSession().getAttribute("securityUser");
        QueryMgr qm = new QueryMgr(userObject);
        UserGroupMgr userGroupMgr = UserGroupMgr.getInstance();
        GroupMgr groupMgr = GroupMgr.getInstance();
        WebBusinessObject userGroup = userGroupMgr.getOnSingleKey(securityUser.getUserGroupId());
        WebBusinessObject group = groupMgr.getOnSingleKey(userGroup.getAttribute("groupID").toString());
        String defaultPage = (String) group.getAttribute("defaultPage");
        if (loggedUser == null) {
            servedPage = "/index.jsp";
            request.setAttribute("page", servedPage);
            this.forward(servedPage, request, response);
        } else {
            if (defaultPage == null || defaultPage.equals("")) {
                defaultPage = (String) securityUser.getDefaultPage();
            }
            imageMgr.setUser(userObject);
            imageMgr.setQueryMgr(qm);

            issueMgr.setUser(userObject);
            userMgr.setUser(userObject);
            try {
                userMgr.setLastLogin(request, response);
            } catch (SQLException ex) {
                Logger.getLogger(TrackerLoginServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
            userMgr.checkUserDirs();
            System.out.println("After call method checkUserDirs();");
            userMgr.userPrevClient(request, response);
            userMgr.userPrevComplaint(request, response);
            diMgr.setUser(userObject);
            System.out.println("After call method diMgr.setUser(userObject);");

            request.setAttribute("page", defaultPage);
            request.setAttribute("status", pageInit);

            System.out.println("Before call method forward();");
            try {
                if (!response.isCommitted()) {
                    response.sendRedirect("main.jsp");
                }
            } catch (IOException ex) {
                if (!response.isCommitted()) {
                    this.goToIndex(request, response);
                }
            }
            System.out.println("After call method forward();");
        }
    }

    @Override
    protected void installMenu(HttpServletRequest request, HttpServletResponse response) {

        HttpSession httpSession = request.getSession();

        servletContext = httpSession.getServletContext();
        TouristGuide touristGuide = new TouristGuide("/com/tracker/international/Menu");

        TwoDimensionMenu tdm = (TwoDimensionMenu) servletContext.getAttribute("myMenu");
        tdm.installMenu(touristGuide);
        touristGuide = new TouristGuide("/com/tracker/international/MenuHeader");
        tdm.installMenuHeaders(touristGuide);
    }
    // get user prev type 1 (client)
}
