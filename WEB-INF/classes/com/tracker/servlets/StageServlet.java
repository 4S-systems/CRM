package com.tracker.servlets;

import com.maintenance.common.Tools;
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.silkworm.business_objects.*;
import org.apache.log4j.Logger;
import com.silkworm.db_access.PersistentSessionMgr;
import com.tracker.db_access.ProjectMgr;
import com.tracker.db_access.ProjectStageMgr;
import com.tracker.db_access.StageWorkItemMgr;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class StageServlet extends TrackerBaseServlet {

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        logger = Logger.getLogger(StageServlet.class);
    }

    @Override
    public void destroy() {
    }

    @Override
    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        super.processRequest(request, response);
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession();
        String remoteAccess = session.getId();
        WebBusinessObject persistentUser = (WebBusinessObject) PersistentSessionMgr.getInstance().getOnSingleKey(remoteAccess);
        switch (request.getParameter("op")) {
            case "getStageWorkItems":
                servedPage = "/docs/stage/stage_work_items.jsp";
                String stageID = request.getParameter("stageID");
                StageWorkItemMgr stageWorkItemMgr = StageWorkItemMgr.getInstance();
                ProjectMgr projectMgr = ProjectMgr.getInstance();
                if (request.getParameterValues("itemID") != null) { // save items
                    ArrayList<WebBusinessObject> saveList = new ArrayList<>();
                    WebBusinessObject wbo;
                    for (String itemID : request.getParameterValues("itemID")) {
                        wbo = new WebBusinessObject();
                        wbo.setAttribute("stageID", stageID);
                        wbo.setAttribute("workItemID", itemID);
                        wbo.setAttribute("quantity", request.getParameter("quantity" + itemID));
                        wbo.setAttribute("note", request.getParameter("note" + itemID));
                        wbo.setAttribute("createdBy", persistentUser.getAttribute("userId"));
                        wbo.setAttribute("option1", "UL");
                        wbo.setAttribute("option2", "UL");
                        wbo.setAttribute("option3", "UL");
                        wbo.setAttribute("option4", "UL");
                        wbo.setAttribute("option5", "UL");
                        wbo.setAttribute("option6", "UL");
                        saveList.add(wbo);
                    }
                    stageWorkItemMgr.saveMultiObjects(saveList);
                }
                request.setAttribute("stageItemsList", stageWorkItemMgr.getStageWorkItems(stageID));
                request.setAttribute("stageID", stageID);
                request.setAttribute("projectID", request.getParameter("projectID"));
                request.setAttribute("stageWbo", projectMgr.getOnSingleKey(stageID));
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case "getWorkItems":
                servedPage = "docs/stage/work_items.jsp";
                stageID = request.getParameter("stageID");
                stageWorkItemMgr = StageWorkItemMgr.getInstance();
                projectMgr = ProjectMgr.getInstance();
                ArrayList<WebBusinessObject> stageWorkItems = stageWorkItemMgr.getStageWorkItems(stageID);
                String ids = "";
                for (WebBusinessObject stageItem : stageWorkItems) {
                    ids += stageItem.getAttribute("workItemID") + ",";
                }
                ArrayList<WebBusinessObject> categoryList = new ArrayList<>(projectMgr.getAllEquipClass());
                Map<String, String> categoryMap = new HashMap<>();
                for (WebBusinessObject categoryWbo : categoryList) {
                    categoryMap.put((String) categoryWbo.getAttribute("projectID"), (String) categoryWbo.getAttribute("projectName"));
                }
                List<WebBusinessObject> items = projectMgr.getRequestsItems(ids.isEmpty() ? "-1" : ids.substring(0, ids.length() - 1));
                request.setAttribute("items", items);
                request.setAttribute("categoryMap", categoryMap);
                this.forward(servedPage, request, response);
                break;
            case "deleteStageItem":
                stageWorkItemMgr = StageWorkItemMgr.getInstance();
                WebBusinessObject wbo = new WebBusinessObject();
                if (stageWorkItemMgr.deleteOnSingleKey(request.getParameter("id"))) {
                    wbo.setAttribute("status", "Ok");
                } else {
                    wbo.setAttribute("status", "No");
                }
                out = response.getWriter();
                out.write(Tools.getJSONObjectAsString(wbo));
                break;
            case "getEditStageForm":
                servedPage = "/docs/projects/edit_eng_unit.jsp";
                projectMgr = ProjectMgr.getInstance();
                ProjectStageMgr projectStageMgr = ProjectStageMgr.getInstance();
                request.setAttribute("projectWbo", projectMgr.getOnSingleKey(request.getParameter("projectID")));
                request.setAttribute("unitWbo", projectMgr.getOnSingleKey(request.getParameter("stageID")));
                request.setAttribute("stageWbo", projectStageMgr.getOnSingleKey(request.getParameter("stageID")));
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case "updateEngUnitAsAjax":
                projectStageMgr = ProjectStageMgr.getInstance();
                projectStageMgr.deleteOnSingleKey(request.getParameter("stageID"));
                WebBusinessObject stageWbo = new WebBusinessObject();
                stageWbo.setAttribute("id", request.getParameter("stageID"));
                SimpleDateFormat sdfTemp = new SimpleDateFormat("yyyy/MM/dd");
                try {
                    stageWbo.setAttribute("estimatedFinishDate", new java.sql.Date(sdfTemp.parse(request.getParameter("estimatedFinishDate")).getTime()));
                } catch (ParseException ex) {
                    stageWbo.setAttribute("estimatedFinishDate", new java.sql.Date(Calendar.getInstance().getTimeInMillis()));
                }
                stageWbo.setAttribute("estimatedCost", request.getParameter("estimatedCost"));
                stageWbo.setAttribute("option1", "UL");
                stageWbo.setAttribute("option2", "UL");
                stageWbo.setAttribute("option3", "UL");
                stageWbo.setAttribute("option4", "UL");
                stageWbo.setAttribute("option5", "UL");
                stageWbo.setAttribute("option6", "UL");
                if (projectStageMgr.saveObject(stageWbo)) {
                    response.getWriter().write("ok");
                } else {
                    response.getWriter().write("fail");
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
        return "Stage Servlet";
    }

}
