/*
 * HelpServlet.java
 *
 * Created on April 30, 2004, 7:58 AM
 */
package com.silkworm.servlets;

import com.crm.common.CRMConstants;
import com.maintenance.common.Tools;
import com.silkworm.automation.QuartzClosedClinetComplaintsAutomation;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.db_access.QuartzFinishSchedulerMgr;
import com.silkworm.db_access.QuartzSchedulerConfigurationMgr;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author walid
 * @version
 */
public class QuartzSchedulerConfigurationServlet extends swBaseServlet {

    private QuartzSchedulerConfigurationMgr quartzMgr;
    private QuartzFinishSchedulerMgr quartzFinishMgr;
    private List<WebBusinessObject> departments;
    private WebBusinessObject wbo;
    private PrintWriter out;
    private String quartzId;
    private String objectId;
    private String objectType;
    private String action;
    private String interval;
    private String runAfter;
    private String running;
    private String toSave;

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
     * @throws javax.servlet.ServletException
     * @throws java.io.IOException
     */
    @Override
    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        super.processRequest(request, response);
        HttpSession session = request.getSession();
        WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");

        this.quartzMgr = QuartzSchedulerConfigurationMgr.getInstance();
        this.quartzFinishMgr = QuartzFinishSchedulerMgr.getInstance();
        this.departments = new ArrayList<WebBusinessObject>();

        operation = getOpCode((String) request.getParameter("op"));
        switch (operation) {
            case 1:
                servedPage = "/docs/quartz/client_compliant_closed_quartz.jsp";
                try {
                    departments = quartzMgr.getAllDepartments();
                } catch (Exception ex) {
                    logger.error(ex);
                }

                request.setAttribute("page", servedPage);
                request.setAttribute("departments", departments);
                this.forwardToServedPage(request, response);
                break;

            case 2:
                out = response.getWriter();
                toSave = request.getParameter("toSave");
                wbo = new WebBusinessObject();
                if ("1".equalsIgnoreCase(toSave)) {
                    quartzId = saveObject(request);
                    if (quartzId != null) {
                        wbo.setAttribute("status", "ok");
                        wbo.setAttribute("id", quartzId);

                        quartzMgr.addScheduler(QuartzClosedClinetComplaintsAutomation.generateScheduler(quartzMgr.getOnSingleKey(quartzId)));
                    } else {
                        wbo.setAttribute("status", "no");
                    }
                } else {
                    quartzId = request.getParameter("quartzId");
                    interval = request.getParameter("interval");
                    if (quartzMgr.updateInterval(quartzId, Integer.parseInt(interval))) {
                        wbo.setAttribute("status", "ok");
                        wbo.setAttribute("id", quartzId);
                    } else {
                        wbo.setAttribute("status", "no");
                    }
                }
                out.write(Tools.getJSONObjectAsString(wbo));
                break;

            case 3:
                out = response.getWriter();
                toSave = request.getParameter("toSave");
                wbo = new WebBusinessObject();
                if ("1".equalsIgnoreCase(toSave)) {
                    quartzId = saveObject(request);
                    if (quartzId != null) {
                        wbo.setAttribute("status", "ok");
                        wbo.setAttribute("id", quartzId);
                        quartzMgr.addScheduler(QuartzClosedClinetComplaintsAutomation.generateScheduler(quartzMgr.getOnSingleKey(quartzId)));
                    } else {
                        wbo.setAttribute("status", "no");
                    }
                } else {
                    quartzId = request.getParameter("quartzId");
                    running = request.getParameter("running");
                    if (quartzMgr.updateRunning(quartzId, running)) {
                        wbo.setAttribute("status", "ok");
                        wbo.setAttribute("id", quartzId);

                        if (!quartzMgr.isSchedulerExist(quartzId)) {
                            quartzMgr.addScheduler(QuartzClosedClinetComplaintsAutomation.generateScheduler(quartzMgr.getOnSingleKey(quartzId)));
                        } else if (CRMConstants.QUARTZ_ACTION_STATUS_RUNNING.equalsIgnoreCase(running)) {
                            quartzMgr.addScheduler(QuartzClosedClinetComplaintsAutomation.generateScheduler(quartzMgr.getOnSingleKey("quartzId")));
                        } else {
                            quartzMgr.removeScheduler(quartzId);
                        }
                    } else {
                        wbo.setAttribute("status", "no");
                    }
                }
                out.write(Tools.getJSONObjectAsString(wbo));
                break;
            case 4:
                servedPage = "/docs/quartz/client_compliant_finish_quartz.jsp";
                try {
                    departments = quartzFinishMgr.getAllDepartments();
                } catch (Exception ex) {
                    logger.error(ex);
                }
                request.setAttribute("page", servedPage);
                request.setAttribute("departments", departments);
                this.forwardToServedPage(request, response);
                break;
            case 5:
                out = response.getWriter();
                toSave = request.getParameter("toSave");
                wbo = new WebBusinessObject();
                if ("1".equalsIgnoreCase(toSave)) {
                    quartzId = saveFinisfObject(request);
                    if (quartzId != null) {
                        wbo.setAttribute("status", "ok");
                        wbo.setAttribute("id", quartzId);

                        quartzFinishMgr.addScheduler(QuartzClosedClinetComplaintsAutomation.generateScheduler(quartzMgr.getOnSingleKey(quartzId)));
                    } else {
                        wbo.setAttribute("status", "no");
                    }
                } else {
                    quartzId = request.getParameter("quartzId");
                    interval = request.getParameter("interval");
                    if (quartzFinishMgr.updateInterval(quartzId, Integer.parseInt(interval))) {
                        wbo.setAttribute("status", "ok");
                        wbo.setAttribute("id", quartzId);
                    } else {
                        wbo.setAttribute("status", "no");
                    }
                }
                out.write(Tools.getJSONObjectAsString(wbo));
                break;

            case 6:
                out = response.getWriter();
                toSave = request.getParameter("toSave");
                wbo = new WebBusinessObject();
                if ("1".equalsIgnoreCase(toSave)) {
                    quartzId = saveFinisfObject(request);
                    if (quartzId != null) {
                        wbo.setAttribute("status", "ok");
                        wbo.setAttribute("id", quartzId);
                        quartzFinishMgr.addScheduler(QuartzClosedClinetComplaintsAutomation.generateScheduler(quartzMgr.getOnSingleKey(quartzId)));
                    } else {
                        wbo.setAttribute("status", "no");
                    }
                } else {
                    quartzId = request.getParameter("quartzId");
                    running = request.getParameter("running");
                    if (quartzFinishMgr.updateRunning(quartzId, running)) {
                        wbo.setAttribute("status", "ok");
                        wbo.setAttribute("id", quartzId);

                        if (!quartzFinishMgr.isSchedulerExist(quartzId)) {
                            quartzFinishMgr.addScheduler(QuartzClosedClinetComplaintsAutomation.generateScheduler(quartzFinishMgr.getOnSingleKey(quartzId)));
                        } else if (CRMConstants.QUARTZ_ACTION_STATUS_RUNNING.equalsIgnoreCase(running)) {
                            quartzFinishMgr.addScheduler(QuartzClosedClinetComplaintsAutomation.generateScheduler(quartzFinishMgr.getOnSingleKey("quartzId")));
                        } else {
                            quartzFinishMgr.removeScheduler(quartzId);
                        }
                    } else {
                        wbo.setAttribute("status", "no");
                    }
                }
                out.write(Tools.getJSONObjectAsString(wbo));
                break;

            default:
                break;
        }
    }

    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws javax.servlet.ServletException
     * @throws java.io.IOException
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws javax.servlet.ServletException
     * @throws java.io.IOException
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return
     */
    @Override
    public String getServletInfo() {
        return "Help Servlet";
    }

    private String saveObject(HttpServletRequest request) {
        HttpSession session = request.getSession();
        WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
        String loggegUserId = (String) loggedUser.getAttribute("userId");
        objectId = request.getParameter("objectId");
        objectType = request.getParameter("objectType");
        action = request.getParameter("action");
        interval = request.getParameter("interval");
        runAfter = request.getParameter("runAfter");
        running = request.getParameter("running");
        return quartzMgr.saveObject(objectId, objectType, action, interval, runAfter, running, loggegUserId);
    }
    
    private String saveFinisfObject(HttpServletRequest request) {
        HttpSession session = request.getSession();
        WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
        String loggegUserId = (String) loggedUser.getAttribute("userId");
        objectId = request.getParameter("objectId");
        interval = request.getParameter("interval");
        running = request.getParameter("running");
        return quartzFinishMgr.saveObject(objectId, interval, running, loggegUserId);
    }

    @Override
    protected int getOpCode(String opName) {
        if (opName.equalsIgnoreCase("clientCompliantClosedQuartzForm")) {
            return 1;
        }
        if (opName.equalsIgnoreCase("clientCompliantClosedQuartzSave")) {
            return 2;
        }
        if (opName.equalsIgnoreCase("clientCompliantClosedQuartzUpdateRunning")) {
            return 3;
        }
        if (opName.equalsIgnoreCase("clientCompliantFinishQuartzForm")) {
            return 4;
        }
        if (opName.equalsIgnoreCase("clientCompliantFinishQuartzSave")) {
            return 5;
        }
        if (opName.equalsIgnoreCase("clientCompliantFinishQuartzUpdateRunning")) {
            return 6;
        }

        return 0;
    }
}
