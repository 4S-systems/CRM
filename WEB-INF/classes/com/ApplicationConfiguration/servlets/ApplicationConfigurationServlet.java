/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ApplicationConfiguration.servlets;

import com.ApplicationConfiguration.db_access.CompanyConfigMgr;
import com.ApplicationConfiguration.db_access.SystemImagesMgr;
import com.maintenance.common.AutomationConfigurationMgr;
import com.maintenance.common.PublicSettingsMgr;
import com.silkworm.Exceptions.IncorrectFileType;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.servlets.MultipartRequest;
import com.tracker.servlets.TrackerBaseServlet;
import java.io.IOException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class ApplicationConfigurationServlet extends TrackerBaseServlet {

    private WebBusinessObject wbo = null;
    private MultipartRequest mpr = null;

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    }

    @Override
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        super.processRequest(request, response);
        CompanyConfigMgr companyConfigMgr = CompanyConfigMgr.getInstance();
        SystemImagesMgr systemImagesMgr = SystemImagesMgr.getInstance();
        operation = getOpCode(request.getParameter("op"));
        switch (operation) {
            case 1:
                servedPage = "/docs/ApplicationConfiguration/config_form.jsp";
                request.setAttribute("companyConfig", companyConfigMgr.getOnSingleKey("1"));
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 2:
                wbo = new WebBusinessObject();
                wbo.setAttribute("arName", request.getParameter("companyNameAR"));
                wbo.setAttribute("enName", request.getParameter("companyNameEN"));
                request.getParameter("companyNameEN");
                companyConfigMgr.updateObject(wbo);
                this.forward("ApplicationConfigurationServlet?op=configurationForm", request, response);
                break;

            case 3:
                try {
                    mpr = new MultipartRequest(request, getServletContext().getRealPath("/images"));
                } catch (IncorrectFileType ex) {
                    Logger.getLogger(ApplicationConfigurationServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                systemImagesMgr.updateObject(mpr);
                this.forward("ApplicationConfigurationServlet?op=configurationForm", request, response);
                break;
            case 4:
                servedPage = "/docs/Adminstration/automation_configuration.jsp";
                ArrayList<String> elementsList = new ArrayList<>();
                elementsList.add("reservation-automation");
                elementsList.add("closed-client-complaints-automation");
                elementsList.add("defualt-refresh-pages");
                elementsList.add("batchQC-configuration");
                elementsList.add("calling-plan-configuration");
                elementsList.add("quality-plan-configuration");
                elementsList.add("authorization-configuration");
                elementsList.add("session-kill-automation");
                elementsList.add("contract-expire-notification");
                elementsList.add("closed-auto-withdraw");
                if(request.getParameter("save") != null) { // save
                    AutomationConfigurationMgr automationConfigurationMgr = AutomationConfigurationMgr.getCurrentInstance();
                    for(String element : elementsList) {
                        automationConfigurationMgr.setValue(element, "interval-value", request.getParameter(element));
                        automationConfigurationMgr.setValue(element, "description", request.getParameter(element + "Desc"));
                    }
                    automationConfigurationMgr.setValue("appointment-notification-alarm", "alarm-delay-interval", request.getParameter("alarm-delay-interval"));
                    automationConfigurationMgr.setValue("appointment-notification-alarm", "appointment-remaining-time", request.getParameter("appointment-remaining-time"));
                    automationConfigurationMgr.setValue("appointment-notification-alarm", "description", request.getParameter("appointment-notification-alarm-desc"));
                    automationConfigurationMgr.setValue("sla-notification-alarm", "alarm-delay-interval", request.getParameter("sla-alarm-delay-interval"));
                    automationConfigurationMgr.setValue("sla-notification-alarm", "sla-remaining-time", request.getParameter("sla-remaining-time"));
                    automationConfigurationMgr.setValue("sla-notification-alarm", "description", request.getParameter("sla-notification-alarm-desc"));
                    request.setAttribute("status", automationConfigurationMgr.saveDocument() ? "ok" : "fail");
                }
                request.setAttribute("elementsList", elementsList);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 5:
                servedPage = "/docs/Adminstration/public_settings.jsp";
                elementsList = new ArrayList<>();
                elementsList.add("reservation-default-period");
                if(request.getParameter("save") != null) { // save
                    PublicSettingsMgr publicSettingsMgr = PublicSettingsMgr.getCurrentInstance();
                    for(String element : elementsList) {
                        publicSettingsMgr.setValue(element, "value", request.getParameter(element));
                        publicSettingsMgr.setValue(element, "description", request.getParameter(element + "Desc"));
                    }
                    request.setAttribute("status", publicSettingsMgr.saveDocument() ? "ok" : "fail");
                }
                request.setAttribute("elementsList", elementsList);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            default:
                System.out.println("No operation was matched");
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
    protected int getOpCode(String opName) {
        if (opName.equalsIgnoreCase("configurationForm")) {
            return 1;
        }
        if (opName.equalsIgnoreCase("saveCompanyConfig")) {
            return 2;
        }
        if (opName.equalsIgnoreCase("saveSystemImages")) {
            return 3;
        }
        if (opName.equalsIgnoreCase("saveAutomationConfiguration")) {
            return 4;
        }
        if (opName.equalsIgnoreCase("updatePublicSettings")) {
            return 5;
        }
        return 0;
    }
}
