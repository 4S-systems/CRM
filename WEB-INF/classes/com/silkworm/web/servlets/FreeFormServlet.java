package com.silkworm.web.servlets;

import com.clients.db_access.ClientMgr;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.common.MetaDataMgr;
import com.silkworm.db_access.PersistentSessionMgr;
import com.silkworm.persistence.relational.UniqueIDGen;
import com.silkworm.web.util.WebXmlUtil;
import com.tracker.db_access.ProjectMgr;
import com.tracker.servlets.TrackerBaseServlet;
import java.io.*;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.logging.Level;
import javax.servlet.*;
import javax.servlet.http.*;
import org.apache.log4j.Logger;

public class FreeFormServlet extends TrackerBaseServlet {

    private Logger logger;
    private HttpSession session;
    private int operation;
    private String servedPage;
    private String web_inf_path = null;

    @Override
    public void init(ServletConfig config) throws ServletException {
        logger = Logger.getLogger(FreeFormServlet.class);
        web_inf_path = MetaDataMgr.getInstance().getWebInfPath();
    }

    @Override
    public void destroy() {
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        session = request.getSession();
        String remoteAccess = session.getId();
        WebBusinessObject persistentUser = (WebBusinessObject) PersistentSessionMgr.getInstance().getOnSingleKey(remoteAccess);
        session.setAttribute("currentMode", "Ar");
        operation = getOpCode((String) request.getParameter("op"));
        switch (operation) {
            case 1:
                servedPage = "/docs/web/free_form.jsp";
                ArrayList<WebBusinessObject> mainProjects = new ArrayList<WebBusinessObject>();
                ProjectMgr projectMgr = ProjectMgr.getInstance();
                try {
                    ArrayList<WebBusinessObject> products = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKey("PRODUCTS", "key3"));
                    WebBusinessObject wbo = (WebBusinessObject) products.get(0);
                    mainProjects = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKey((String) wbo.getAttribute("projectID"), "key2"));
                    for (int i = 0; i < mainProjects.size(); i++) {
                    }
                } catch (SQLException ex) {
                    logger.error(ex);
                } catch (Exception ex) {
                    logger.error(ex);
                }
                request.setAttribute("mainProjects", mainProjects);
                this.forward(servedPage, request, response);
                break;
            case 2:
                servedPage = "/docs/web/free_form.jsp";
                WebBusinessObject clientWbo = new WebBusinessObject();
                clientWbo.setAttribute("clientID", UniqueIDGen.getNextID());
                clientWbo.setAttribute("clientName", request.getParameter("clientName"));
                clientWbo.setAttribute("clientMobile", request.getParameter("clientMobile"));
                if (request.getParameter("clientPhone") == null) {
                    clientWbo.setAttribute("clientPhone", "UL");
                } else {
                    clientWbo.setAttribute("clientPhone", request.getParameter("clientPhone"));
                }
                clientWbo.setAttribute("email", request.getParameter("email"));
                clientWbo.setAttribute("email", request.getParameter("email"));
                String clientDesire = (String) request.getParameter("description") + System.lineSeparator() + "#Facebook" + " " + "Internet";
                clientWbo.setAttribute("description", clientDesire);
                String[] projectIDs = request.getParameterValues("projectId");
                HashMap<String, String> periods = new HashMap<String, String>();
                HashMap<String, String> paymentTypes = new HashMap<String, String>();
                HashMap<String, String> areas = new HashMap<String, String>();
                if (projectIDs != null) {
                    for (String projectID : projectIDs) {
                        periods.put(projectID, request.getParameter("period" + projectID));
                        paymentTypes.put(projectID, request.getParameter("paymentType" + projectID));
                        areas.put(projectID, request.getParameter("area" + projectID));
                    }
                }
                if (WebXmlUtil.createXmlForClient(MetaDataMgr.getInstance().getWebDirectoryPath(), clientWbo, projectIDs, periods, paymentTypes, areas, null, persistentUser != null ? (String) persistentUser.getAttribute("userId") : "1")) {
                    request.setAttribute("status", "ok");
                } else {
                    request.setAttribute("status", "fail");
                }
                mainProjects = new ArrayList<>();
                projectMgr = ProjectMgr.getInstance();
                try {
                    ArrayList<WebBusinessObject> products = new ArrayList<>(projectMgr.getOnArbitraryKey("PRODUCTS", "key3"));
                    WebBusinessObject wbo = (WebBusinessObject) products.get(0);
                    mainProjects = new ArrayList<>(projectMgr.getOnArbitraryKey((String) wbo.getAttribute("projectID"), "key2"));
                    for (int i = 0; i < mainProjects.size(); i++) {
                    }
                } catch (SQLException ex) {
                    logger.error(ex);
                } catch (Exception ex) {
                    logger.error(ex);
                }
                request.setAttribute("mainProjects", mainProjects);
                this.forward(servedPage, request, response);
                break;
            case 3:
                servedPage = "/docs/web/search_client_for_call_center_int.jsp";
                String phone = request.getParameter("phone");
                projectMgr = ProjectMgr.getInstance();
                ArrayList<WebBusinessObject> projectList = new ArrayList<WebBusinessObject>();
                ArrayList<WebBusinessObject> mainProject;
                ClientMgr clientMgr = ClientMgr.getInstance();
                try {
                    request.setAttribute("clientWbo", clientMgr.getClientByNoAndID(phone));
                    mainProject = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKey("PRODUCTS", "key3"));
                    projectList = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKey((String) mainProject.get(0).getAttribute("projectID"), "key2"));
                } catch (SQLException ex) {
                    logger.error(ex);
                } catch (Exception ex) {
                    logger.error(ex);
                }
                request.setAttribute("projectList", projectList);
                request.setAttribute("page", servedPage);
                this.forward(servedPage, request, response);
                break;
            case 4:
                clientWbo = new WebBusinessObject();
                clientWbo.setAttribute("clientID", UniqueIDGen.getNextID());
                clientWbo.setAttribute("clientName", request.getParameter("clientName"));
                clientWbo.setAttribute("clientMobile", request.getParameter("clientMobile"));
                clientWbo.setAttribute("clientPhone", request.getParameter("clientPhone"));
                clientWbo.setAttribute("email", request.getParameter("email"));
                String projectName = request.getParameter("projectName");
                projectIDs = null;
                periods = null;
                paymentTypes = null;
                areas = null;
                if (projectName != null && !projectName.isEmpty()) {
                    projectMgr = ProjectMgr.getInstance();
                    WebBusinessObject projectWbo = projectMgr.getOnSingleKey("key1", projectName);
                    if (projectWbo != null && projectWbo.getAttribute("projectID") != null) {
                        projectIDs = new String[1];
                        projectIDs[0] = (String) projectWbo.getAttribute("projectID");
                        periods = new HashMap<String, String>();
                        periods.put(projectIDs[0], "UL");
                        paymentTypes = new HashMap<String, String>();
                        paymentTypes.put(projectIDs[0], "UL");
                        areas = new HashMap<String, String>();
                        areas.put(projectIDs[0], "UL");
                    }
                }
                WebXmlUtil.createXmlForClient(MetaDataMgr.getInstance().getWebDirectoryPath(), clientWbo, projectIDs, periods, paymentTypes, areas, request.getParameter("campaignID"), (String) persistentUser.getAttribute("userId"));

                if (!response.isCommitted()) {
                    response.sendRedirect("http://www.metaweegroup.com/thank-you/");
                }
                break;
        }
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
        return "Free Form Servlet";
    }

    protected int getOpCode(String opName) {
        if (opName.equalsIgnoreCase("getFreeForm")) {
            return 1;
        }
        if (opName.equalsIgnoreCase("SaveClientData")) {
            return 2;
        }
        if (opName.equals("getSearchForCallCenter")) {
            return 3;
        }
        if (opName.equals("externalURL")) {
            return 4;
        }
        return 0;
    }

    protected void forward(String url, HttpServletRequest request, HttpServletResponse response) {
        try {
            RequestDispatcher rd = request.getRequestDispatcher(url);
            rd.forward(request, response);
        } catch (ServletException ex) {
            java.util.logging.Logger.getLogger(FreeFormServlet.class.getName()).log(Level.SEVERE, null, ex);
        } catch (IOException ex) {
            java.util.logging.Logger.getLogger(FreeFormServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}
