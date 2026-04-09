package com.unit.servlets;

import com.clients.db_access.ClientMgr;
import com.maintenance.common.Tools;
import com.maintenance.db_access.UnitDocMgr;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.common.MetaDataMgr;
import com.silkworm.persistence.relational.UniqueIDGen;
import com.tracker.db_access.LocationTypeMgr;
import com.tracker.db_access.ProjectMgr;
import com.tracker.servlets.TrackerBaseServlet;
import com.unit.db_access.UnitPriceMgr;
import java.awt.image.BufferedImage;
import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Vector;
import javax.imageio.ImageIO;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

public class UnitFinanceServlet extends TrackerBaseServlet {

    //define variables
    WebBusinessObject userObj = null;
    WebBusinessObject project = null;

    private String reqOp = null;
    String projectId = null;
    String userHome = null;
    String docID = null;
    String userImageDir = null;
    String RIPath = null;
    String absPath = null;
    String random = null;
    String randFileName = null;

    File docImage = null;

    ArrayList<WebBusinessObject> projectsList = null;

    JSONObject jsonMenu = null;
    JSONArray JsonList = null;

    //define managers
    ProjectMgr projectMgr = null;
    UnitPriceMgr unitPriceMgr = null;
    UnitDocMgr unitDocMgr = null;
    ClientMgr clientMgr = null;

    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    }

    public void destroy() {
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        userObj = (WebBusinessObject) session.getAttribute("loggedUser");
        super.processRequest(request, response);

        reqOp = request.getParameter("op");
        WebBusinessObject waUser = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
        String loggedUser = (String) waUser.getAttribute("userId");
        WebBusinessObject wbo;

        operation = getOpCode(reqOp);
        switch (operation) {
            case 1:
                servedPage = "/docs/UnitFinance/unit_detail.jsp";

                projectId = request.getParameter("projectId");
                //String fromPage = request.getParameter("fromPage");

                projectMgr = ProjectMgr.getInstance();
                unitPriceMgr = UnitPriceMgr.getInstance();
                unitDocMgr = UnitDocMgr.getInstance();

                project = projectMgr.getOnSingleKey(projectId);

                //Reading unit Images
                Vector imageList = unitDocMgr.getImagesList(projectId);
                Vector imagesPath = new Vector();
                int len = 0;
                BufferedInputStream gifData;
                BufferedImage myImage;

                userHome = (String) userObj.getAttribute("userHome");
                for (int i = 0; i < imageList.size(); i++) {
                    random = UniqueIDGen.getNextID();
                    len = random.length();
                    docID = (String) ((WebBusinessObject) imageList.get(i)).getAttribute("docID");
                    randFileName = "ran" + random.substring(5, len) + ".jpeg";
                    RIPath = userImageDir + "/" + randFileName;
                    absPath = "images/" + userHome + "/" + randFileName;
                    docImage = new File(RIPath);
                    gifData = new BufferedInputStream(unitDocMgr.getImage(docID));
                    myImage = ImageIO.read(gifData);
                    ImageIO.write(myImage, "jpeg", docImage);
                    imagesPath.add(absPath);
                }

                WebBusinessObject unitWbo = unitPriceMgr.getOnSingleKey("key1", projectId);

                int unitPrice = 0;
                if (unitWbo != null) {
                    unitPrice = new Integer(unitWbo.getAttribute("option1").toString());
                }

                projectsList = new ArrayList<>();
                getProjectTree(projectId);

                //Tools.createBuildingUnitSideMenu(projectId, project.getAttribute("mainProjId").toString(), loggedUser, request);
                //request.setAttribute("searchBy", request.getParameter("searchBy"));
                //request.setAttribute("searchValue", request.getParameter("searchValue"));
                //request.setAttribute("imagePath", imagesPath);
                //request.setAttribute("fromPage", fromPage);
                request.setAttribute("project", project);
                request.setAttribute("unitPrice", unitPrice);
                request.setAttribute("projectTree", projectsList);
                this.forward(servedPage, request, response);
                break;

            case 2:
                Tools.createPdfReport("unitInstallmentsReport", getServletContext(), response, request);
                break;

            case 3:
                servedPage = "/docs/UnitFinance/unit_InitialReservtion.jsp";

                projectId = request.getParameter("projectId");
                projectMgr = ProjectMgr.getInstance();
                project = projectMgr.getOnSingleKey(projectId);

                request.setAttribute("page", servedPage);
                request.setAttribute("project", project);
                this.forwardToServedPage(request, response);
                break;

            case 4:
                String clientCode = request.getParameter("clientCode");

                clientMgr = ClientMgr.getInstance();
                WebBusinessObject clientWbo = clientMgr.getOnSingleKey("clientNO", clientCode);

            case 5:
                servedPage = "/docs/UnitFinance/unit_tree.jsp";

                projectMgr = ProjectMgr.getInstance();

                try {
                    projectsList = new ArrayList<WebBusinessObject>();
                    Vector projects = projectMgr.getOnArbitraryKey("1364111290870", "key2");

                    for (int i = 0; i < projects.size(); i++) {
                        wbo = (WebBusinessObject) projects.get(i);
                        projectsList.add(wbo);
                    }
                } catch (Exception exc) {
                    System.out.println(exc.getMessage());
                }
                request.setAttribute("page", servedPage);
                request.setAttribute("prjects", projectsList);
                this.forwardToServedPage(request, response);
                break;

            case 6:
                projectMgr = ProjectMgr.getInstance();

                //define the json 
                JSONObject main = new JSONObject();
                JSONObject menu = new JSONObject();
                JSONArray menuItems = new JSONArray();
                MetaDataMgr metaMgr = new MetaDataMgr();

                this.jsonMenu = new JSONObject();
                this.JsonList = new JSONArray();

                //Define menu JSON Reader
                JSONParser parser = new JSONParser();
                try {
                    String path = getServletContext().getRealPath("/json");
                    FileReader fileReader = new FileReader(getServletContext().getRealPath("/json") + "/unitContextMenu.json");
                    this.jsonMenu = (JSONObject) parser.parse(fileReader);
                } catch (Exception ex) {
                    System.out.println("Parsing Error : " + ex.getMessage());
                    logger.error(ex.getMessage());
                }

                //get Project  Tree
                projectId = request.getParameter("projectId");
                project = projectMgr.getOnSingleKey(projectId);

                //Add main object to json
                String projectName = "";
                if (projectId.equals("1364111290870")) {
                    menu = (JSONObject) this.jsonMenu.get("VG");
                    projectName = project.getAttribute("projectName").toString();
                } else {
                    menu = (JSONObject) this.jsonMenu.get("44");
                    projectName = "Ù…Ø´Ø±ÙˆØ¹ " + project.getAttribute("projectName").toString();

                }
                String icon = (String) menu.get("icon");
                menuItems = (JSONArray) menu.get("menuItem");

                int currentID = this.JsonList.size();
                main.put("id", "0");
                main.put("projectID", projectId);
                main.put("parentid", "-1");
                main.put("text", projectName);
                main.put("icon", icon);
                main.put("type", project.getAttribute("location_type").toString());
                main.put("contextMenu", menuItems);
                JsonList.add(main);

                getChilds(projectId, currentID);

                try {
                } catch (Exception exc) {
                    System.out.println(exc.getMessage());
                }

                PrintWriter out = response.getWriter();
                out.write(JsonList.toJSONString());
                break;
            
            case 8:
                metaMgr = new MetaDataMgr();
                projectMgr = ProjectMgr.getInstance();

                //define general vars
                icon = new String();

                //define the json 
                main = new JSONObject();
                menu = new JSONObject();
                menuItems = new JSONArray();

                this.jsonMenu = new JSONObject();
                this.JsonList = new JSONArray();

                //Define menu JSON Reader
                parser = new JSONParser();

                try {
                    String path = getServletContext().getRealPath("/json");
                    System.out.println("Web Inf path = " + path);
                    FileReader fileReader = new FileReader(getServletContext().getRealPath("/json") + "/contextMenu.json");
                    this.jsonMenu = (JSONObject) parser.parse(fileReader);
                } catch (Exception ex) {
                    System.out.println("Parsing Error : " + ex.getMessage());
                    logger.error(ex.getMessage());
                }

                WebBusinessObject mainNodeWbo = projectMgr.getOnSingleKey(request.getParameter("projectId"));
                icon = (String) menu.get("icon");
                menuItems = (JSONArray) menu.get("menuItem");

                //Add the project in JsonArray
                currentID = this.JsonList.size();
                JSONObject mainProject = new JSONObject();
                mainProject.put("id", "0");
                mainProject.put("projectID", mainNodeWbo.getAttribute("projectID"));
                mainProject.put("parentid", "-1");
                mainProject.put("text", mainNodeWbo.getAttribute("projectName"));
                mainProject.put("icon", icon);
                mainProject.put("type", mainNodeWbo.getAttribute("location_type"));
                mainProject.put("contextMenu", menuItems);
                this.JsonList.add(mainProject);
                getChilds((String) mainNodeWbo.getAttribute("projectID"), currentID);
                try {
                } catch (Exception exc) {
                    System.out.println(exc.getMessage());
                }

                out = response.getWriter();
                out.write(JsonList.toJSONString());
                break;

            default:
                break;
        }
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, java.io.IOException {
        processRequest(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    public String getServletInfo() {
        return "Unit Finance Servlet";
    }

    public int getOpCode(String opName) {

        if (opName.equalsIgnoreCase("getUnitInstallments")) {
            return 1;
        }

        if (opName.equalsIgnoreCase("installmentsPDF")) {
            return 2;
        }

        if (opName.equalsIgnoreCase("InitialReservation")) {
            return 3;
        }

        if (opName.equalsIgnoreCase("getClientObject")) {
            return 4;
        }

        if (opName.equalsIgnoreCase("getUnitsTree")) {
            return 5;
        }

        if (opName.equalsIgnoreCase("buildUnitsTree")) {
            return 6;
        }
        return 0;
    }

    private void getProjectTree(String projectID) {
        ProjectMgr projectMgr = ProjectMgr.getInstance();
        LocationTypeMgr locationMgr = LocationTypeMgr.getInstance();

        WebBusinessObject wbo = new WebBusinessObject();
        WebBusinessObject projectWbo = new WebBusinessObject();

        projectWbo = projectMgr.getOnSingleKey(projectID);
        String mainProjectID = projectWbo.getAttribute("mainProjId").toString();

        if (projectWbo != null) {
            wbo.setAttribute("projectID", projectWbo.getAttribute("projectID").toString());
            wbo.setAttribute("projectName", projectWbo.getAttribute("projectName").toString());
            wbo.setAttribute("LocationType", projectWbo.getAttribute("location_type").toString());

            WebBusinessObject locationWbo = locationMgr.getOnSingleKey("key1", projectWbo.getAttribute("location_type").toString());
            if (locationWbo != null) {
                wbo.setAttribute("LocationTypeName", locationWbo.getAttribute("arDesc").toString());
            } else {
                wbo.setAttribute("LocationTypeName", "---");
            }

            this.projectsList.add(wbo);

            if (!mainProjectID.equals("0")) {
                getProjectTree(mainProjectID);
            }
        } else {
            wbo.setAttribute("projectID", "---");
            wbo.setAttribute("projectName", "---");
            wbo.setAttribute("LocationType", "---");
            wbo.setAttribute("LocationTypeName", "---");

            this.projectsList.add(wbo);
        }
    }

    private void getChilds(String projectParentID, int parentID) {
        try {
            String icon = "";
            String projectName = "";
            Vector childVec = new Vector();
            WebBusinessObject treeNodeWBO = new WebBusinessObject();

            JSONObject contextMenu = new JSONObject();
            JSONArray menuElements = new JSONArray();
            childVec = projectMgr.getOnArbitraryKey(projectParentID, "key2");

            if (childVec.size() > 0) {
                for (int i = 0; i < childVec.size(); i++) {

                    int currentID = this.JsonList.size();
                    JSONObject josnObj = new JSONObject();
                    treeNodeWBO = (WebBusinessObject) childVec.get(i);

                    contextMenu = (JSONObject) this.jsonMenu.get((String) treeNodeWBO.getAttribute("location_type"));
                    icon = (String) contextMenu.get("icon");
                    menuElements = (JSONArray) contextMenu.get("menuItem");

                    if (treeNodeWBO.getAttribute("location_type").toString().equals("CMPLX-UNIT")) {
                        projectName = "Ø¹Ù…Ø§Ø±Ø© Ø³ÙƒÙ†ÙŠØ© " + (String) treeNodeWBO.getAttribute("projectName");
                    }

                    if (treeNodeWBO.getAttribute("location_type").toString().equals("RES-MODEL")) {
                        projectName = "Ù†Ù…ÙˆØ°Ø¬ Ø³ÙƒÙ†ÙŠ " + (String) treeNodeWBO.getAttribute("projectName");
                    }

                    if (treeNodeWBO.getAttribute("location_type").toString().equals("RES-UNIT")) {
                        projectName = "ÙˆØ­Ø¯Ø© Ø³ÙƒÙ†ÙŠØ© " + (String) treeNodeWBO.getAttribute("projectName");
                    }

                    if (treeNodeWBO.getAttribute("location_type").toString().equals("44")) {
                        projectName = "Ù…Ø´Ø±ÙˆØ¹ " + (String) treeNodeWBO.getAttribute("projectName");
                    }

                    josnObj.put("id", new Integer(currentID).toString());
                    josnObj.put("projectID", (String) treeNodeWBO.getAttribute("projectID"));
                    josnObj.put("parentid", parentID);
                    josnObj.put("text", projectName);
                    josnObj.put("icon", icon);
                    josnObj.put("type", (String) treeNodeWBO.getAttribute("location_type"));
                    josnObj.put("contextMenu", menuElements);
                    this.JsonList.add(josnObj);

                    getChilds((String) treeNodeWBO.getAttribute("projectID"), currentID);
                }
            }
        } catch (Exception ex) {
            System.out.println("Error:" + ex.getMessage());
        }
    }
}
