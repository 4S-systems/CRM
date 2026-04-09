package com.maintenance.servlets;

import java.io.*;
import java.util.*;

import javax.servlet.*;
import javax.servlet.http.*;

import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.Exceptions.*;
import com.tracker.servlets.TrackerBaseServlet;

import com.maintenance.db_access.*;

import com.contractor.db_access.MaintainableMgr;
public class EquipMaintenanceTypeServlet extends TrackerBaseServlet {

    MaintainableMgr unit = MaintainableMgr.getInstance();
    ItemCatsMgr itemCatsMgr = ItemCatsMgr.getInstance();
    CategoryMgr categoryMgr = CategoryMgr.getInstance();
    ItemMgr itemMgr = ItemMgr.getInstance();
    EquipMaintenanceTypeMgr equipMaintenanceTypeMgr = EquipMaintenanceTypeMgr.getInstance();
    CrewMissionMgr crewMissionMgr = CrewMissionMgr.getInstance();
    StaffCodeMgr staffCodeMgr = StaffCodeMgr.getInstance();
    String op = null;
    String filterName = null;
    String filterValue = null;
    String categoryId = null;
    Vector unitsList = null;
    ArrayList unitArr;
    ArrayList itemCategory;

    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    }

    public void destroy() {

    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        super.processRequest(request, response);
        HttpSession session = request.getSession();

        switch (operation) {
            case 1:
                String categoryId = request.getParameter("categoryID");
                servedPage = "/docs/Adminstration/new_equip_maintenance_type.jsp";

                request.setAttribute("categoryId", categoryId);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 2:


                categoryId = request.getParameter("categoryId");
                servedPage = "/docs/Adminstration/new_equip_maintenance_type.jsp";
                WebBusinessObject maintenanceType = new WebBusinessObject();
                maintenanceType.setAttribute("typeName", request.getParameter("typeName").toString());
                maintenanceType.setAttribute("categoryId", request.getParameter("categoryId").toString());


                try {

                    if (equipMaintenanceTypeMgr.saveObject(maintenanceType, session)) {
                        request.setAttribute("Status", "Ok");
                    } else {
                        request.setAttribute("Status", "No");
                    }

                } catch (NoUserInSessionException noUser) {
                    logger.error("Place Servlet: save place " + noUser);
                }

                request.setAttribute("categoryId", categoryId);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;


            case 3:

                categoryId = request.getParameter("categoryId");
                servedPage = "/docs/Adminstration/maintenance_type_list.jsp";
                request.setAttribute("categoryId", categoryId);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 4:
                String typeId = null;
                servedPage = "/docs/Adminstration/view_maintenance_type.jsp";
                typeId = request.getParameter("typeId");
                maintenanceType = equipMaintenanceTypeMgr.getOnSingleKey(typeId);
                request.setAttribute("maintenanceType", maintenanceType);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);

                break;

            case 5:
                categoryId = request.getParameter("categoryId");
                typeId = request.getParameter("typeId");
                maintenanceType = equipMaintenanceTypeMgr.getOnSingleKey(typeId);
                servedPage = "/docs/Adminstration/update_maintenance_type.jsp";

                request.setAttribute("maintenanceType", maintenanceType);
                request.setAttribute("typeId", typeId);
                request.setAttribute("categoryId", categoryId);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;


            case 6:
                typeId = request.getParameter("typeId");
                categoryId = request.getParameter("categoryId");
                servedPage = "/docs/Adminstration/update_maintenance_type.jsp";

                maintenanceType = new WebBusinessObject();
                maintenanceType.setAttribute("typeName", request.getParameter("typeName").toString());
                maintenanceType.setAttribute("categoryId", request.getParameter("categoryId").toString());

                maintenanceType.setAttribute("typeId", request.getParameter("typeId").toString());


                if (equipMaintenanceTypeMgr.updateMainType(maintenanceType, session)) {
                    request.setAttribute("Status", "Ok");
                } else {
                    request.setAttribute("Status", "No");

                }

                maintenanceType = equipMaintenanceTypeMgr.getOnSingleKey(request.getParameter("typeId"));
                request.setAttribute("typeId", typeId);
                request.setAttribute("categoryId", categoryId);
                request.setAttribute("maintenanceType", maintenanceType);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 7:
                categoryId = request.getParameter("categoryId");
                String MainType = request.getParameter("MainType");
                typeId = request.getParameter("typeId");

                servedPage = "/docs/Adminstration/confirm_delMainType.jsp";

                request.setAttribute("MainType", MainType);
                request.setAttribute("typeId", typeId);
                request.setAttribute("categoryId", categoryId);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 8:
                categoryId = request.getParameter("categoryId");
                typeId = request.getParameter("typeId");
                Vector mainType = equipMaintenanceTypeMgr.getCashedTable();
                equipMaintenanceTypeMgr.deleteOnSingleKey(request.getParameter("typeId"));
                equipMaintenanceTypeMgr.cashData();
//                
                mainType = equipMaintenanceTypeMgr.getCashedTable();
                servedPage = "/docs/Adminstration/maintenance_type_list.jsp";
                request.setAttribute("categoryId", categoryId);
                request.setAttribute("data", mainType);
                request.setAttribute("page", servedPage);

                this.forwardToServedPage(request, response);

                break;


            default:
                logger.info("No operation was matched");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    public String getServletInfo() {
        return "Search Servlet";
    }

    protected int getOpCode(String opName) {
        if (opName.indexOf("AddMaintenanceType") == 0) {
            return 1;
        }

        if (opName.indexOf("SaveMainType") == 0) {
            return 2;
        }

        if (opName.equals("ListMainType")) {
            return 3;
        }

        if (opName.equals("ViewMainType")) {
            return 4;
        }

        if (opName.equals("GetUpdateMainType")) {
            return 5;
        }

        if (opName.equals("UpdateMainType")) {
            return 6;
        }

        if (opName.equals("DeleteMainType")) {
            return 7;
        }

        if (opName.equals("Delete")) {
            return 8;
        }

        return 0;
    }
}

