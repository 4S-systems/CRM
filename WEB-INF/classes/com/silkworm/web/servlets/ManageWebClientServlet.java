package com.silkworm.web.servlets;

import com.clients.db_access.ClientMgr;
import com.clients.db_access.ClientProductMgr;
import com.clients.servlets.ClientServlet;
import com.planning.db_access.SeasonMgr;
import com.silkworm.Exceptions.IncorrectFileType;
import com.silkworm.Exceptions.NoUserInSessionException;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.common.MetaDataMgr;
import com.silkworm.db_access.PersistentSessionMgr;
import com.silkworm.logger.db_access.LoggerMgr;
import com.silkworm.servlets.MultipartRequest;
import com.silkworm.web.util.WebXmlUtil;
import com.tracker.db_access.CampaignMgr;
import com.tracker.db_access.ClientCampaignMgr;
import com.tracker.db_access.ProjectMgr;
import com.tracker.servlets.*;
import java.io.*;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import javax.servlet.*;
import javax.servlet.http.*;
import org.apache.log4j.Logger;

public class ManageWebClientServlet extends TrackerBaseServlet {

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        logger = Logger.getLogger(ManageWebClientServlet.class);
    }

    @Override
    public void destroy() {
    }

    @Override
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        super.processRequest(request, response);
        HttpSession session = request.getSession();
        WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
        String remoteAccess = session.getId();
        WebBusinessObject persistentUser = (WebBusinessObject) PersistentSessionMgr.getInstance().getOnSingleKey(remoteAccess);
        operation = getOpCode((String) request.getParameter("op"));
        String path = MetaDataMgr.getInstance().getWebDirectoryPath();
        switch (operation) {
            case 1:
                servedPage = "/docs/web/clients_list.jsp";
                request.setAttribute("clientsList", WebXmlUtil.readClientsList(path + "/web/u" + persistentUser.getAttribute("userId") + "/"));
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 2:
                servedPage = "/docs/web/clients_list.jsp";
                String[] clientIDs = request.getParameterValues("clientID");
                if (clientIDs != null) {
                    ClientMgr clientMgr = ClientMgr.getInstance();
                    LoggerMgr loggerMgr = LoggerMgr.getInstance();
                    for (String clientFileID : clientIDs) {
                        File clientFile = new File(path + "/web/u" + persistentUser.getAttribute("userId") + "/" + clientFileID + ".xml");
                        if (clientFile.exists()) {
                            String clientName = request.getParameter("clientName" + clientFileID);
                            String mobile = request.getParameter("mobile" + clientFileID);
                            String phone = request.getParameter("phone" + clientFileID);
                            String email = request.getParameter("email" + clientFileID);
                            String campaignID = request.getParameter("campaignID" + clientFileID);
                            String sourceID = request.getParameter("sourceID" + clientFileID);
                            String season = request.getParameter("season" + clientFileID);
                            String description = request.getParameter("description" + clientFileID);
                            try {
                                WebBusinessObject clientWbo = null;
                                try {
                                    ArrayList<WebBusinessObject> tempList = new ArrayList<>(clientMgr.getOnArbitraryDoubleKeyOracle(clientName, "key8", mobile, "key4"));
                                    if (!tempList.isEmpty()) {
                                        clientWbo = tempList.get(0);
                                    } else {
                                        tempList = new ArrayList<>(clientMgr.getOnArbitraryDoubleKeyOracle(clientName, "key8", phone, "key10"));
                                        if (!tempList.isEmpty()) {
                                            clientWbo = tempList.get(0);
                                        }
                                    }
                                } catch (Exception ex) {
                                    java.util.logging.Logger.getLogger(ManageWebClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                                }
                                if (clientWbo == null) {
                                    clientWbo = clientMgr.saveWebClient(clientName, mobile, phone, email, description, session, persistentUser,season);
                                } else {
                                    WebBusinessObject loggerWbo = new WebBusinessObject();
                                    loggerWbo.setAttribute("objectXml", clientWbo.getObjectAsXML());
                                    loggerWbo.setAttribute("realObjectId", clientWbo.getAttribute("id"));
                                    loggerWbo.setAttribute("userId", loggedUser.getAttribute("userId"));
                                    loggerWbo.setAttribute("objectName", clientWbo.getAttribute("name"));
                                    loggerWbo.setAttribute("loggerMessage", "Existing Client");
                                    loggerWbo.setAttribute("eventName", "Inserting Existing Client");
                                    loggerWbo.setAttribute("objectTypeId", "1");
                                    loggerWbo.setAttribute("eventTypeId", "7");
                                    loggerWbo.setAttribute("ipForClient", getClientIpAddr(request));
                                    loggerMgr.saveObject(loggerWbo);
                                }
                                if (clientWbo != null) {
                                    request.setAttribute("status", "ok");
                                    String clientId = (String) (clientWbo.getAttribute("clientId") != null ? clientWbo.getAttribute("clientId") : clientWbo.getAttribute("id"));
                                    if (campaignID != null) {
                                        String[] campaignIDs = {campaignID};
                                        String[] emptyArray = {};
                                        ClientCampaignMgr clientCampaignMgr = ClientCampaignMgr.getInstance();
                                        clientCampaignMgr.saveCampaignsByClient(clientId, campaignIDs, emptyArray, emptyArray, emptyArray, session, false);
                                        clientCampaignMgr.saveSourceByClient(clientId, sourceID);
                                    }
                                    clientWbo = clientMgr.getOnSingleKey(clientId);
                                    WebBusinessObject loggerWbo = new WebBusinessObject();
                                    loggerWbo.setAttribute("objectXml", clientWbo.getObjectAsXML());
                                    loggerWbo.setAttribute("realObjectId", clientId);
                                    loggerWbo.setAttribute("userId", loggedUser.getAttribute("userId"));
                                    loggerWbo.setAttribute("objectName", clientWbo.getAttribute("name"));
                                    loggerWbo.setAttribute("loggerMessage", "Client Inserted from Web");
                                    loggerWbo.setAttribute("eventName", "Insert");
                                    loggerWbo.setAttribute("objectTypeId", "1");
                                    loggerWbo.setAttribute("eventTypeId", "4");
                                    loggerWbo.setAttribute("ipForClient", getClientIpAddr(request));
                                    loggerMgr.saveObject(loggerWbo);
                                    createProjectsForClient(path + "/web/u" + persistentUser.getAttribute("userId") + "/", clientId, clientFileID, session);
                                    WebXmlUtil.deleteClientFile(path + "/web/u" + persistentUser.getAttribute("userId") + "/", clientFileID);
                                } else {
                                    request.setAttribute("status", "fail");
                                }
                            } catch (NoUserInSessionException ex) {
                                java.util.logging.Logger.getLogger(ManageWebClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                            } catch (SQLException ex) {
                                java.util.logging.Logger.getLogger(ManageWebClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                            }
                        }
                    }
                }
                request.setAttribute("clientsList", WebXmlUtil.readClientsList(path + "/web/u" + persistentUser.getAttribute("userId") + "/"));
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 3:
                servedPage = "/docs/web/clients_list.jsp";
                clientIDs = request.getParameterValues("clientID");
                if (clientIDs != null) {
                    for (String clientFileID : clientIDs) {
                        File clientFile = new File(path + "/web/u" + persistentUser.getAttribute("userId") + "/" + clientFileID + ".xml");
                        if (clientFile.exists()) {
                            WebXmlUtil.deleteClientFile(path + "/web/u" + persistentUser.getAttribute("userId") + "/", clientFileID);
                            request.setAttribute("status", "deleted");
                        }
                    }
                }
                request.setAttribute("clientsList", WebXmlUtil.readClientsList(path + "/web/u" + persistentUser.getAttribute("userId") + "/"));
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 4:
                servedPage = "/docs/web/upload_clients.jsp";
                String userHome = (String) loggedUser.getAttribute("userHome");
                String userBackEndHome = web_inf_path + "/usr/" + userHome + "/";
                String season = request.getParameter("season");
                String campaignID = request.getParameter("campaignID");
                String sourceID = request.getParameter("sourceID");
                String projectID = request.getParameter("projectID");
                MultipartRequest multipartRequest = null;
                try {
                    multipartRequest = new MultipartRequest(request, userBackEndHome, "UTF-8");
                } catch (IncorrectFileType ex) {
                    logger.error(ex);
                } catch (IOException io) {
                    request.setAttribute("status", "Failed");
                    request.setAttribute("fileAttached", "no");
                }
                if (multipartRequest != null) {
                    File file = multipartRequest.getFile("uploadFile");
                    if (file != null) {
                        if (file.getName().toLowerCase().contains("xlsx")) {
                            request.setAttribute("status", WebXmlUtil.createXmlForClientFromExcel(file, path, campaignID, sourceID, season, projectID, (String) persistentUser.getAttribute("userId")) + "");
                        } else if (file.getName().toLowerCase().contains("csv")) {
                            request.setAttribute("status", WebXmlUtil.createXmlForClientFromCSV(file, path, campaignID,  sourceID,season,projectID, (String) persistentUser.getAttribute("userId")) + "");
                        }
                    }
                }
                CampaignMgr campaignMgr = CampaignMgr.getInstance();
                //ArrayList<WebBusinessObject> campaignsList = campaignMgr.getAllSubCampaigns();
                List<WebBusinessObject> campaignsList;
                try {
                    campaignsList = new ArrayList<>(campaignMgr.getOnArbitraryKeyOracle("16", "key4"));
                    campaignsList.addAll(campaignMgr.getOnArbitraryKeyOracle("20", "key4"));
//                    campaignsList.addAll(campaignMgr.getAllSubCampaigns());
                } catch (Exception ex) {
                    campaignsList = new ArrayList<>();
                }
                try {
    List<WebBusinessObject> sourceList = ClientMgr.getInstance().getSource();
    request.setAttribute("sourceList", sourceList);
                } catch (Exception ex) {
                    java.util.logging.Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                try {
    ArrayList<WebBusinessObject> seasonList = new ArrayList<>(SeasonMgr.getInstance().getOnArbitraryKeyOracle("1", "key2"));
    request.setAttribute("season", seasonList);
                } catch (Exception ex) {
                    java.util.logging.Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                ProjectMgr projectMgr = ProjectMgr.getInstance();
                try {
//                    campaignsList.addAll(campaignMgr.getOnArbitraryKeyOracle("16", "key4"));
//                    campaignsList.addAll(campaignMgr.getOnArbitraryKeyOracle("20", "key4"));
                    request.setAttribute("projectsList", new ArrayList<>(projectMgr.getOnArbitraryKey("44", "key4")));
                } catch (Exception ex) {
                    logger.error(ex);
                    request.setAttribute("projectsList", new ArrayList<WebBusinessObject>());
                }
                request.setAttribute("campaignsList", campaignsList);
                request.setAttribute("campaignID", campaignID == null ? "" : campaignID);
                request.setAttribute("projectID", projectID == null ? "" : projectID);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
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
        return "Manage Web Clients Servlet";
    }

    @Override
    protected int getOpCode(String opName) {
        if (opName.equalsIgnoreCase("ListClients")) {
            return 1;
        }
        if (opName.equalsIgnoreCase("SaveSelectedClients")) {
            return 2;
        }
        if (opName.equalsIgnoreCase("DeleteSelectedClients")) {
            return 3;
        }
        if (opName.equals("uploadClientsFromExcel")) {
            return 4;
        }
        return 0;
    }

    private boolean createProjectsForClient(String path, String clientID, String clientFileId, HttpSession session) {
        ArrayList<WebBusinessObject> projectsList = WebXmlUtil.getProjectsForClient(path, clientFileId);
        ClientProductMgr clientProductMgr = ClientProductMgr.getInstance();
        ProjectMgr projectMgr = ProjectMgr.getInstance();
        try {
            for (WebBusinessObject clientProjectWbo : projectsList) {
                WebBusinessObject projectWbo = projectMgr.getOnSingleKey((String) clientProjectWbo.getAttribute("projectID"));
                if (projectWbo != null) {
                    clientProjectWbo.setAttribute("clientID", clientID);
                    clientProjectWbo.setAttribute("productName", projectWbo.getAttribute("projectName"));
                    WebBusinessObject projectCategoryWbo = projectMgr.getOnSingleKey((String) projectWbo.getAttribute("mainProjId"));
                    clientProjectWbo.setAttribute("productCategoryId", (String) projectCategoryWbo.getAttribute("projectID"));
                    clientProjectWbo.setAttribute("productCategoryName", projectCategoryWbo.getAttribute("projectName"));
                    clientProductMgr.saveClientProduct(clientProjectWbo, session);
                }
            }
        } catch (NoUserInSessionException ex) {
            java.util.logging.Logger.getLogger(ManageWebClientServlet.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            java.util.logging.Logger.getLogger(ManageWebClientServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
        return true;
    }
}
