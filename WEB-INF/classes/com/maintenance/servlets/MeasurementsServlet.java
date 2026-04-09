/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.maintenance.servlets;

import com.contractor.db_access.MaintainableMgr;
import com.maintenance.common.Tools;
import com.maintenance.db_access.MainTypeMeasurementMgr;
import com.maintenance.db_access.MeasurementsMgr;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.pagination.Filter;
import com.silkworm.pagination.FilterCondition;
import com.silkworm.pagination.Operations;
import com.tracker.servlets.TrackerBaseServlet;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author khaled abdo
 */
public class MeasurementsServlet extends TrackerBaseServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
//    MeasurementsMgr measureMgr = MeasurementsMgr.getInstance();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            super.processRequest(request, response);
            HttpSession session = request.getSession();
            MaintainableMgr maintainableMgr = MaintainableMgr.getInstance();
            MeasurementsMgr measureMgr = MeasurementsMgr.getInstance();
            MainTypeMeasurementMgr mainTypeMeasurementMgr = MainTypeMeasurementMgr.getInstance();

            switch (operation) {
                case 1:
                    servedPage = "/docs/Adminstration/new_measurement.jsp";

                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 2:
                    try {
                        if (!measureMgr.getDoubleName(request.getParameter("code").toString(), "keyname") && !measureMgr.getDoubleName(request.getParameter("arDesc").toString(), "keyname1") && !measureMgr.getDoubleName(request.getParameter("enDesc").toString(), "keyname2")) {
                            if (measureMgr.saveObject(request, session)) {
                                request.setAttribute("status", "ok");
                            } else {
                                request.setAttribute("status", "no");
                            }
                        } else {
                            request.setAttribute("status", "no");
                            request.setAttribute("name", "Duplicate Name");
                        }
                    } catch (Exception ex) {
                        Logger.getLogger(MeasurementsServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    servedPage = "/docs/Adminstration/new_measurement.jsp";
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 3:
                    Vector units = new Vector();
                    //measureMgr.cashData();
                    units = measureMgr.getCashedTable();
                    servedPage = "/docs/Adminstration/measurement_list.jsp";

                    request.setAttribute("data", units);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 4:
                    servedPage = "/docs/Adminstration/view_measurement.jsp";
                    String unitID = request.getParameter("id");
                    WebBusinessObject unitslist = new WebBusinessObject();
                    unitslist = measureMgr.getOnSingleKey(unitID);
                    request.setAttribute("data", unitslist);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 5:
                    servedPage = "/docs/Adminstration/update_measurement.jsp";
                    unitID = request.getParameter("id");
                    WebBusinessObject unitupdate = new WebBusinessObject();
                    unitupdate = measureMgr.getOnSingleKey(unitID);
                    request.setAttribute("data", unitupdate);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 6:
                    try {
                        if (measureMgr.getOnSingleKey(request.getParameter("id").toString()) != null) {
                            if (measureMgr.updateObject(request, session)) {
                                request.setAttribute("status", "ok");
                            } else {
                                request.setAttribute("status", "no");
                            }
                        } else {
                            request.setAttribute("status", "no");
                            request.setAttribute("name", "Not Found Name");
                        }
                    } catch (Exception ex) {
                        Logger.getLogger(MeasurementsServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    servedPage = "/docs/Adminstration/update_measurement.jsp";
                    request.setAttribute("data", measureMgr.getOnSingleKey(request.getParameter("id").toString()));
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 7:
                    String unitName = request.getParameter("unitName");
                    unitID = request.getParameter("id");

                    servedPage = "/docs/Adminstration/confirm_del_measurement.jsp";

                    request.setAttribute("unitName", unitName);
                    request.setAttribute("unitID", unitID);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 8:
                    unitID = request.getParameter("unitID");
                    if (!measureMgr.deleteOnSingleKey(unitID)) {
                        servedPage = "/docs/Adminstration/cant_del_measurement.jsp";
                        request.setAttribute("servlet", "MeasurementsServlet");
                        request.setAttribute("list", "ListMeasurements");
                        request.setAttribute("type", "Measurement");
                        request.setAttribute("name", request.getParameter("unitName"));
                        request.setAttribute("page", servedPage);
                    } else {
                        units = measureMgr.getCashedTable();
                        servedPage = "/docs/Adminstration/measurement_list.jsp";

                        request.setAttribute("data", units);
                        request.setAttribute("page", servedPage);
                    }
                    this.forwardToServedPage(request, response);

                    break;

                case 9:                    
                    servedPage = "/docs/Adminstration/measurement_list.jsp";
                    Filter filter = new com.silkworm.pagination.Filter();
                    String selectionType = request.getParameter("selectionType");
                    filter = Tools.getPaginationInfo(request, response);
                    String formName = null;
                    String attachedMeasurementIds = null;
                    String mainTypeId = request.getParameter("mainTypeId");
                    List conditions = new ArrayList<FilterCondition>();
                    List<WebBusinessObject> measurementList = new ArrayList<WebBusinessObject>(0);

                    // add conditions
                    try {
                        attachedMeasurementIds = mainTypeMeasurementMgr.getAttachedMeasurements(mainTypeId);

                        if (!attachedMeasurementIds.equals("")) {
                            conditions.add(new FilterCondition("ID", attachedMeasurementIds, Operations.NOTIN));

                        } else {
                            conditions.add(new FilterCondition("ID", "NULL", Operations.NOT_EQUAL));

                        }
                    } catch (Exception e) {
                        System.out.println(e.getMessage());
                    }

                    filter.setConditions(conditions);

                    try {
                        measurementList = measureMgr.paginationEntity(filter);

                    } catch (Exception e) {
                        System.out.println(e);
                    }

                    if (selectionType == null) {
                            selectionType = "multi";
                    }

                    formName = (String) request.getParameter("formName");

                    if (formName == null) {
                            formName = "";
                    }


                    request.setAttribute("selectionType", selectionType);
                    request.setAttribute("filter", filter);
                    request.setAttribute("formName", formName);
                    request.setAttribute("measurementList", measurementList);
                    this.forward(servedPage, request, response);
                    break;

            }
        } finally {
            out.close();
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

    protected int getOpCode(String opName) {
        if (opName.indexOf("GetMeasurementForm") == 0) {
            return 1;
        }

        if (opName.equalsIgnoreCase("SaveMeasurement")) {
            return 2;
        }

        if (opName.equalsIgnoreCase("ListMeasurements")) {
            return 3;
        }
        if (opName.equalsIgnoreCase("ViewMeasurement")) {
            return 4;
        }
        if (opName.equalsIgnoreCase("GetUpdateMeasurementForm")) {
            return 5;
        }
        if (opName.equalsIgnoreCase("saveUpdateMeasurement")) {
            return 6;
        }
        if (opName.equalsIgnoreCase("confirmDeleteMeasurement")) {
            return 7;
        }
        if (opName.equalsIgnoreCase("deleteMeasurement")) {
            return 8;
        }
        if (opName.equalsIgnoreCase("getMeasurementList")) {
            return 9;
        }
        return 0;
    }
}
