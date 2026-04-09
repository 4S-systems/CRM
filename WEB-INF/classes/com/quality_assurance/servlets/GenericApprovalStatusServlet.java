package com.quality_assurance.servlets;

import com.contractor.db_access.MaintainableMgr;
import com.tracker.servlets.TrackerBaseServlet;
import java.io.IOException;

import javax.servlet.ServletException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.silkworm.business_objects.WebBusinessObject;
import com.maintenance.db_access.*;
import com.quality_assurance.db_accesss.GenericApprovalStatusMgr;

public class GenericApprovalStatusServlet extends TrackerBaseServlet {
    
    GenericApprovalStatusMgr genericApprovalStatusMgr;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            super.processRequest(request, response);


            switch (operation) {
                case 1:
                    String EquipmentId = request.getParameter("equipmentID");
                    WebBusinessObject maint = null;
                    genericApprovalStatusMgr = GenericApprovalStatusMgr.getInstance();
                    WebBusinessObject Approval = null;
                    MaintainableMgr maintainableMgr = MaintainableMgr.getInstance();
                    maint = maintainableMgr.getOnSingleKey(EquipmentId);
                    request.setAttribute("data", maint);
                    Approval = genericApprovalStatusMgr.getOnSingleKey1(request.getParameter("equipmentID"));
                    if (Approval != null) {
                        servedPage = "/docs/QualityAssurance/Print_Equipment_Approval.jsp";
                        request.setAttribute("Approval", Approval);
                        request.setAttribute("page", servedPage);
                        this.forward(servedPage, request, response);
                    } else {
                        servedPage = "/docs/QualityAssurance/Equipment_Approval.jsp";
                        request.setAttribute("page", servedPage);
                        this.forwardToServedPage(request, response);
                    }

                    break;

                //////////////////////////////////
                case 2:
                    servedPage = "/docs/QualityAssurance/Equipment_Approval.jsp";
                    MaintainableMgr maintainableMgr1 = MaintainableMgr.getInstance();
                    EquipmentId = request.getParameter("eqpId");
                    String Status = request.getParameter("Status");
                    String note = request.getParameter("note");
                    genericApprovalStatusMgr = GenericApprovalStatusMgr.getInstance();
                    boolean result = genericApprovalStatusMgr.save(EquipmentId, Status, note, "EQP");
                    if (result == true) {
                        request.setAttribute("Status", "ok");
                    } else {
                        request.setAttribute("Status", "no");
                    }
                    WebBusinessObject maintt = maintainableMgr1.getOnSingleKey(EquipmentId);
                    request.setAttribute("data", maintt);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                /////////////////////////////
                case 3:
                    servedPage = "/docs/QualityAssurance/Item_Approval.jsp";
                    String ItemId = request.getParameter("taskId");
                    WebBusinessObject task = null;
                    TaskMgr taskMgr = TaskMgr.getInstance();
                    task = taskMgr.getOnSingleKey(ItemId);
                    request.setAttribute("task", task);
                    genericApprovalStatusMgr = GenericApprovalStatusMgr.getInstance();
                    Approval = genericApprovalStatusMgr.getOnSingleKey1(request.getParameter("taskId"));
                    if (Approval != null) {

                        servedPage = "/docs/QualityAssurance/Print_Item_Approval.jsp";
                        request.setAttribute("Approval", Approval);

                        request.setAttribute("page", servedPage);
                        this.forward(servedPage, request, response);
                    } else {

                        servedPage = "/docs/QualityAssurance/Item_Approval.jsp";
                        request.setAttribute("page", servedPage);
                        this.forwardToServedPage(request, response);
                    }

                    break;
                ///////////////////////////////////
                case 4:
                    servedPage = "/docs/QualityAssurance/Item_Approval.jsp";
                    ItemId = request.getParameter("taskId");
                    note = request.getParameter("note");
                    Status = request.getParameter("Status");
                    taskMgr = TaskMgr.getInstance();
                    task = taskMgr.getOnSingleKey(ItemId);
                    genericApprovalStatusMgr = GenericApprovalStatusMgr.getInstance();
                    result = genericApprovalStatusMgr.save(ItemId, Status, note, "MI");
                    if (result == true) {
                        request.setAttribute("Status", "ok");
                    } else {
                        request.setAttribute("Status", "no");
                    }
                    request.setAttribute("task", task);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                //////////////////////////////////////////////////////////////    
                case 5:
                    servedPage = "/docs/QualityAssurance/Schedule_Approval.jsp";
                    String scheduleId = request.getParameter("periodicID");
                    note = request.getParameter("note");
                    Status = request.getParameter("Status");
                    ScheduleMgr scheduleMgr = ScheduleMgr.getInstance();
                    WebBusinessObject schedule = scheduleMgr.getOnSingleKey(scheduleId);
                    genericApprovalStatusMgr = GenericApprovalStatusMgr.getInstance();
                    request.setAttribute("schedule", schedule);
                    Approval = genericApprovalStatusMgr.getOnSingleKey1(request.getParameter("periodicID"));
                    if (Approval != null) {

                        servedPage = "/docs/QualityAssurance/Print_Schedule_Approval.jsp";
                        request.setAttribute("Approval", Approval);
                        request.setAttribute("flag", "true");
                        request.setAttribute("page", servedPage);
                        this.forward(servedPage, request, response);
                    } else {

                        servedPage = "/docs/QualityAssurance/Schedule_Approval.jsp";
                        request.setAttribute("flag", "false");
                        request.setAttribute("page", servedPage);
                        this.forwardToServedPage(request, response);
                    }
                    break;

                ///////////////////////////////
                case 6:
                    servedPage = "/docs/QualityAssurance/Schedule_Approval.jsp";
                    scheduleId = request.getParameter("periodicID");
                    note = request.getParameter("note");
                    Status = request.getParameter("Status");
                    scheduleMgr = ScheduleMgr.getInstance();
                    schedule = scheduleMgr.getOnSingleKey(scheduleId);
                    genericApprovalStatusMgr = GenericApprovalStatusMgr.getInstance();
                    result = genericApprovalStatusMgr.save(scheduleId, Status, note, "SCH");
                    if (result == true) {
                        request.setAttribute("Status", "ok");
                    } else {
                        request.setAttribute("Status", "no");
                    }
                    request.setAttribute("schedule", schedule);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 7:
                    servedPage = "/docs/QualityAssurance/Item_Approval.jsp";
                    ItemId = request.getParameter("taskId");
                    note = request.getParameter("note");
                    Status = request.getParameter("Status");
                    String type = request.getParameter("type");
                    taskMgr = TaskMgr.getInstance();
                    task = taskMgr.getOnSingleKey(ItemId);
                    genericApprovalStatusMgr = GenericApprovalStatusMgr.getInstance();
                    Approval = genericApprovalStatusMgr.getOnSingleKey1(ItemId);
                    if(Approval==null)
                    result = genericApprovalStatusMgr.save(ItemId, Status, note, type);
                    else
                    result = genericApprovalStatusMgr.update(ItemId, Status, note);
                    if (result == true) {
                        request.setAttribute("Status", "ok");
                    } else {
                        request.setAttribute("Status", "no");
                    }
                    request.setAttribute("task", task);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                //////////////////////////////////////////////////////////////  
                default:
                    logger.info("No operation was matched");
            }


        } catch (Exception ex) {
            logger.error(ex.getMessage());
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
        return "Short description";
    }

    protected int getOpCode(String opName) {
        if (opName.equals("EquipmentAppovalForm")) {
            return 1;
        }
        if (opName.equals("SaveEquipmentAppovalForm")) {
            return 2;
        }
        if (opName.equals("ItemAppovalForm")) {
            return 3;
        }
        if (opName.equals("SaveItemAppovalForm")) {
            return 4;
        }
        if (opName.equals("ScheduleAppovalForm")) {
            return 5;
        }
        if (opName.equals("SaveScheduleAppovalForm")) {
            return 6;
        }
        if (opName.equals("SaveScheduleAppoval")) {
            return 7;
        }
        return 0;
    }
}
