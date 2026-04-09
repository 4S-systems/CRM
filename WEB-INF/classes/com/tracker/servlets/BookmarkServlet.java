/*
 * BookmarkServlet.java
 *
 * Created on February 25, 2004, 1:29 AM
 */
package com.tracker.servlets;

import com.maintenance.common.Tools;
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.silkworm.util.*;
import java.util.*;
import com.silkworm.business_objects.*;
import com.silkworm.common.*;
import org.apache.log4j.Logger;

/**
 *
 * @author walid
 * @version
 */
public class BookmarkServlet extends TrackerBaseServlet {

    /**
     * Initializes the servlet.
     */
    BookmarkMgr bookmarkMgr = BookmarkMgr.getInstance();
    WebBusinessObject bookmark = new WebBusinessObject();

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        logger = Logger.getLogger(BookmarkServlet.class);
    }

    /**
     * Destroys the servlet.
     */
    @Override
    public void destroy() {

    }

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        super.processRequest(request, response);
        HttpSession s = request.getSession();
        //        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        //        bookmarkMgr.setUser((WebAppUser) waUser);

        //Define page UTF-8
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        int operation = 0;

        operation = getOpCode((String) request.getParameter("op"));

        ArrayList requestAsArray = ServletUtils.getRequestParams(request);
        ServletUtils.printRequest(requestAsArray);

        try {
            switch (operation) {
                case 1:

                    issueStatus = request.getParameter("issueState");
                    String projectname = request.getParameter("projectName");

                    if (request.getParameter("case") != null) {
                        HttpSession session = request.getSession(true);
                        session.setAttribute("case", request.getParameter("case"));
                        session.setAttribute("title", request.getParameter("title"));
                        session.setAttribute("unitName", request.getParameter("unitName"));

                    }
                    //  String issueId = request.getParameter("id");
//                    ais = IssueStatusFactory.getStateClass(issueStatus);

//                    viewOrigin = request.getParameter("viewOrigin");
//                    ais.setCentralViewLink(AppConstants.getFullLink(viewOrigin));
//                    ais.setViewOrigin(viewOrigin);
                    servedPage = "/docs/issue/new_bookmark.jsp";
                    request.setAttribute("issueState", issueStatus);
//                    request.setAttribute("state",ais);
                    request.setAttribute("issueId", request.getParameter("issueId"));
                    request.setAttribute("issueTitle", request.getParameter("issueTitle"));
                    request.setAttribute("projectName", projectname);
                    request.setAttribute("issueType", request.getParameter("issueType"));
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 2:

                    //  issueState = request.getParameter("issueState");
                    //   ais = IssueStatusFactory.getStateClass(issueState);
//                    viewOrigin = request.getParameter("viewOrigin");
//                    destination = AppConstants.getFullLink(viewOrigin);
                    projectname = request.getParameter("projectName");
                    filterValue = request.getParameter("filterValue");
                    filterName = request.getParameter("filterName");

//                    destination = AppConstants.getFullLink(filterName, filterValue, projectname);
//                    if (request.getParameter("case") != null) {
//                        if (destination != null) {
//                            destination = destination.replaceFirst("StatusProjectListAll", "StatusProjctListTitle");
//                        } else {
//                            destination = "/SearchServlet?op=StatusProjctListTitle&filterValue=" + filterValue;
//                        }
//                        String addToURL = "&title=" + request.getParameter("title") + "&unitName=" + (String) request.getParameter("unitName");
//                        destination += addToURL;
//                        destination = destination.replace(' ', '+');
//                    }
                    scrapeForm(request);

                    if (!bookmarkMgr.saveObject(bookmark, s)) {
                        logger.info("False return");
                    }
                    destination = "/" + filterName + "?op=" +  filterValue;
                    forward(destination, request, response);

                    break;

                case 3:
                    projectname = request.getParameter("projectName");
                    String key = request.getParameter("key");
//                    viewOrigin = request.getParameter("viewOrigin");
//                    destination = AppConstants.getFullLink(viewOrigin);
                    //ais = IssueStatusFactory.getStateClass(request.getParameter("issueState"));
                    filterValue = request.getParameter("filterValue");
                    filterName = request.getParameter("filterName");

//                    destination = AppConstants.getFullLink(filterName, filterValue, projectname);
//                    if (request.getParameter("case") != null) {
//                        if (destination != null) {
//                            destination = destination.replaceFirst("StatusProjectListAll", "StatusProjctListTitle");
//                        } else {
//                            destination = "/SearchServlet?op=StatusProjctListTitle&filterValue=" + filterValue;
//                        }
//                        String addToURL = "&title=" + request.getParameter("title") + "&unitName=" + (String) request.getParameter("unitName");
//                        destination += addToURL;
//                        destination = destination.replace(' ', '+');
//                    }
                    destination = "/" + filterName + "?op=" +  filterValue;
                    if (bookmarkMgr.deleteOnSingleKey(key)) {
                        this.forward(destination, request, response);
                    }

                    break;

                case 4:

                    WebBusinessObject bookmark = null;
                    String bookmarkId = request.getParameter("key");
                    projectname = request.getParameter("projectName");
                    if (request.getParameter("case") != null) {
                        HttpSession session = request.getSession(true);
                        session.setAttribute("case", request.getParameter("case"));
                        session.setAttribute("title", request.getParameter("title"));
                        session.setAttribute("unitName", request.getParameter("unitName"));

                    }

//                    viewOrigin = request.getParameter("viewOrigin");
//                    ais = IssueStatusFactory.getStateClass(request.getParameter("issueState"));
//
//                    ais.setCentralViewLink(AppConstants.getFullLink(viewOrigin));
//                    ais.setViewOrigin(viewOrigin);
                    bookmark = bookmarkMgr.getOnSingleKey(bookmarkId);
                    if (null != bookmark) {

                        request.setAttribute("bookmark", bookmark);
//                        request.setAttribute("state", ais);

                        servedPage = "/docs/issue/view_bookmark.jsp";

                        request.setAttribute("projectName", projectname);
                        request.setAttribute("page", servedPage);

                        this.forwardToServedPage(request, response);
                    } else {
                        servedPage = "/docs/exception/database_error.jsp";
                        request.setAttribute("page", servedPage);
                        this.forwardToServedPage(request, response);
                    }

                    break;
                    
                case 5:
                    servedPage = "/docs/issue/bookmarks_list.jsp";
                    bookmarkMgr = BookmarkMgr.getInstance();
                    WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
                    Vector bookmarksList = new Vector();
                    if (waUser != null) {
                        bookmarksList = bookmarkMgr.getOnArbitraryKey((String) waUser.getAttribute("userId"), "key2");
                    }
                    request.setAttribute("data", bookmarksList);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                    
                case 6:
                    key = request.getParameter("key");
                    out = response.getWriter();
                    WebBusinessObject wbo = new WebBusinessObject();
                    if (bookmarkMgr.deleteOnSingleKey(key)) {
                        wbo.setAttribute("status", "ok");
                    } else {
                        wbo.setAttribute("status", "error");
                    }
                    out.write(Tools.getJSONObjectAsString(wbo));
                    break;
                    
                case 7:
                    scrapeForm(request);
                    out = response.getWriter();
                    wbo = new WebBusinessObject();
                    if (!bookmarkMgr.saveObject(this.bookmark, s)) {
                        wbo.setAttribute("status", "error");
                    } else {
                        wbo.setAttribute("bookmarkId", this.bookmark.getAttribute("bookmarkId"));
                        wbo.setAttribute("status", "ok");
                    }
                    out.write(Tools.getJSONObjectAsString(wbo));
                    break;
                case 8:
                    this.bookmark = new WebBusinessObject();
                    this.bookmark.setAttribute("bookmarkText", request.getParameter("note"));
                    this.bookmark.setAttribute("parentTitle", request.getParameter("title"));
                    this.bookmark.setAttribute("objType", "CLIENT_COMPLAINT");
                    String[] ids = request.getParameter("ids").split(",");
                    out = response.getWriter();
                    wbo = new WebBusinessObject();
                    wbo.setAttribute("status", "error");
                    for (String id : ids) {
                        this.bookmark.setAttribute("parentId", id);
                        if (bookmarkMgr.saveObject(this.bookmark, s)) {
                            wbo.setAttribute("status", "ok");
                        } else {
                            wbo.setAttribute("status", "error");
                        }
                    }
                    out.write(Tools.getJSONObjectAsString(wbo));
                    break;
                case 9:
                    this.bookmark = new WebBusinessObject();
                    this.bookmark.setAttribute("bookmarkText", request.getParameter("note"));
                    this.bookmark.setAttribute("parentTitle", request.getParameter("title"));
                    this.bookmark.setAttribute("objType", "CLIENT");
                    ids = request.getParameter("ids").split(",");
                    out = response.getWriter();
                    wbo = new WebBusinessObject();
                    wbo.setAttribute("status", "error");
                    for (String id : ids) {
                        this.bookmark.setAttribute("parentId", id);
                        if (bookmarkMgr.saveObject(this.bookmark, s)) {
                            wbo.setAttribute("status", "ok");
                        } else {
                            wbo.setAttribute("status", "error");
                        }
                    }
                    out.write(Tools.getJSONObjectAsString(wbo));
                    break;
                case 10:
                    servedPage = "/docs/issue/all_bookmarks_list.jsp";
                    bookmarkMgr = BookmarkMgr.getInstance();
                    request.setAttribute("data", bookmarkMgr.getAllBookmarks());
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                default:
                    this.forwardToServedPage(request, response);

            }
        } catch (Exception e) {
            e.printStackTrace();
            logger.error("Book mark sevlet exception " + e.getMessage());
        }

    }

    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     */
    public String getServletInfo() {
        return "Short description";
    }

    private void scrapeForm(HttpServletRequest request) {

        bookmark.setAttribute("parentId", request.getParameter("issueId"));
        bookmark.setAttribute("parentTitle", request.getParameter("issueTitle"));
        bookmark.setAttribute("objType", request.getParameter("issueType"));

        String bookmarkText = request.getParameter("bookmarkText");
        if (null == bookmarkText) {
            bookmarkText = new String("no note attached");
        }
        bookmark.setAttribute("bookmarkText", bookmarkText);

    }

    protected int getOpCode(String opName) {
        if (opName.equals("togol")) {
            return 1;
        }

        if (opName.equals("save")) {
            return 2;
        }

        if (opName.equals("delete")) {
            return 3;
        }

        if (opName.equals("view")) {
            return 4;
        }
        
        if (opName.equals("ViewBookmarks")) {
            return 5;
        }
        
        if (opName.equals("DeleteAjax")) {
            return 6;
        }
        
        if (opName.equals("CreateAjax")) {
            return 7;
        }
        
        if (opName.equals("bookmarkMultiComplaintsAjax")) {
            return 8;
        }
        if (opName.equals("bookmarkMultiClientsAjax")) {
            return 9;
        }
        if (opName.equals("getAllBookmarks")) {
            return 10;
        }

        return 0;
    }
}
