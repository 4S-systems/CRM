package com.customization.servlets;

import com.customization.common.CustomizeEquipmentMgr;
import com.customization.common.CustomizeJOMgr;
import com.customization.common.CustomizeMgr;
import com.customization.model.Customization;
import com.silkworm.business_objects.WebBusinessObject;
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.tracker.servlets.TrackerBaseServlet;
import java.util.ArrayList;

public class CustomizationServlet extends TrackerBaseServlet {
    CustomizeJOMgr customizeJOMgr = CustomizeJOMgr.getInstance();
    CustomizeEquipmentMgr customizeEquipmentMgr = CustomizeEquipmentMgr.getInstance();

    private ArrayList allCustomization;

    @Override public void destroy() { }

    @Override protected void processRequest(HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException {
        
        super.processRequest(request, response);

        operation = getOpCode((String) request.getParameter("op"));

        switch (operation) {
            case 1:
                servedPage = "/docs/customize/customize_issue.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 2:
                Customization customizationShift = new Customization();
                Customization customizationTrade = new Customization();
                
                WebBusinessObject wboShift = new WebBusinessObject();
                WebBusinessObject wboTrade = new WebBusinessObject();

                allCustomization = new ArrayList();

                String checkShift = request.getParameter("checkShift");
                String checkTrade = request.getParameter("checkTrade");
                
                if(checkShift != null) { // when select shift CheckBox ie. hide Shit
                    customizationShift.setDisplay("no");
                } else {// when dose not select shift CheckBox ie. View Shift
                    customizationShift.setDisplay("yes");
                }
                
                // set wboShift by customizationShift and tagName Shift
                wboShift.setAttribute(CustomizeMgr.TAG_NAME_ATTRIBUTE, CustomizeJOMgr.SHIFT_ELEMENT);
                wboShift.setAttribute(CustomizeMgr.CUSTOMIZATION_ATTRIBUTE, customizationShift);

                allCustomization.add(wboShift);
                
                if(checkTrade != null){
                    customizationTrade.setDisplay("no");
                }else{
                    customizationTrade.setDisplay("yes");
                }

                wboTrade.setAttribute(CustomizeMgr.TAG_NAME_ATTRIBUTE, CustomizeJOMgr.TRADE_ELEMENT);
                wboTrade.setAttribute(CustomizeMgr.CUSTOMIZATION_ATTRIBUTE, customizationTrade);

                allCustomization.add(wboTrade);

                customizeJOMgr.updateCustomization(allCustomization);

                request.setAttribute("message", "saveComplete");
                servedPage = "/docs/customize/customize_issue.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 3:
                servedPage = "/docs/customize/customize_equipment.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 4:
                Customization productionLineCustomization = new Customization();

                WebBusinessObject wboProductionLine = new WebBusinessObject();

                allCustomization = new ArrayList();

                String checkProductionLine = request.getParameter("checkProductionLine");

                if(checkProductionLine != null) {
                    productionLineCustomization.setDisplay("no");
                } else {
                    productionLineCustomization.setDisplay("yes");
                }

                wboProductionLine.setAttribute(CustomizeMgr.TAG_NAME_ATTRIBUTE, CustomizeEquipmentMgr.PRODUCTION_LINE_ELEMENT);
                wboProductionLine.setAttribute(CustomizeMgr.CUSTOMIZATION_ATTRIBUTE, productionLineCustomization);

                allCustomization.add(wboProductionLine);
                customizeEquipmentMgr.updateCustomization(allCustomization);

                request.setAttribute("message", "saveComplete");
                servedPage = "/docs/customize/customize_equipment.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            default:
                this.forwardToServedPage(request, response);
        }


    }

    @Override protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override public String getServletInfo() {
        return "Place Servlet";
    }

    @Override protected int getOpCode(String opName) {

        if (opName.equalsIgnoreCase("issueForm")) {
            return 1;
        }
        if (opName.equalsIgnoreCase("saveIssueForm")) {
            return 2;
        }
        if (opName.equalsIgnoreCase("equipmentForm")) {
            return 3;
        }
        if (opName.equalsIgnoreCase("saveEquipmentForm")) {
            return 4;
        }

        return 0;
    }
}

