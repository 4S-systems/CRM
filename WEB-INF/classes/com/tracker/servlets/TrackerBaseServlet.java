package com.tracker.servlets;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.silkworm.servlets.*;
import java.util.*;
import com.silkworm.common.*;
import com.tracker.db_access.*;
import com.tracker.engine.AssignedIssueState;

public class TrackerBaseServlet extends swBaseServlet {

    protected String issueTitle = null;
    protected String issueState = null;
    protected UserMgr userMgr = UserMgr.getInstance();
    protected IssueMgr issueMgr = IssueMgr.getInstance();
    protected Vector searchResult = null;
    protected AssignedIssueState ais = null;
    protected String issueStatus = null;
    protected String destination = null;
    protected String viewOrigin = null;
    protected String filterName = null;
    protected String filterValue = null;
    protected PrintWriter out;

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    }

    @Override
    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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
        return "Short description";
    }

    @Override
    protected int getOpCode(String opName) {
        return 0;
    }
}
