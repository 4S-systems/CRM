/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.maintenance.servlets;

import com.contractor.db_access.MaintainableMgr;
import com.maintenance.db_access.MeasurementUnitsMgr;
import com.silkworm.Exceptions.NoUserInSessionException;
import com.silkworm.business_objects.WebBusinessObject;
import com.tracker.servlets.TrackerBaseServlet;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author khaled abdo
 */
public class MeasurementUnitsServlet extends TrackerBaseServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    MeasurementUnitsMgr unitsMgr = MeasurementUnitsMgr.getInstance();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            super.processRequest(request, response);
            HttpSession session = request.getSession();
            //UnitMgr unitMgr = UnitMgr.getInstance();
            MeasurementUnitsMgr measureMgr = MeasurementUnitsMgr.getInstance();
            MaintainableMgr maintainableMgr = MaintainableMgr.getInstance();
            switch (operation) {
                case 1:
                    servedPage = "/docs/Adminstration/new_measurement_unit.jsp";

                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 2:
                    try {
                        if (!unitsMgr.getDoubleName(request.getParameter("arabicname").toString(), "keyname") && !unitsMgr.getDoubleName(request.getParameter("englishname").toString(), "keyname1")) {
                            if (unitsMgr.saveObject(request, session)) {
                                request.setAttribute("status", "ok");
                            } else {
                                request.setAttribute("status", "no");
                            }
                        } else {
                            request.setAttribute("status", "no");
                            request.setAttribute("name", "Duplicate Name");
                        }
                    } catch (Exception ex) {
                        Logger.getLogger(MeasurementUnitsServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    servedPage = "/docs/Adminstration/new_measurement_unit.jsp";
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 3:
                    Vector units = new Vector();
                    //measureMgr.cashData();
                    units = measureMgr.getCashedTable();
                    servedPage = "/docs/Adminstration/measurement_unit_list.jsp";

                    request.setAttribute("data", units);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 4:
                    servedPage = "/docs/Adminstration/view_measurement_unit.jsp";
                    String unitID = request.getParameter("id");
                    WebBusinessObject unitslist = new WebBusinessObject();
                    unitslist = measureMgr.getOnSingleKey(unitID);
                    request.setAttribute("data", unitslist);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 5:
                    servedPage = "/docs/Adminstration/update_measurement_unit.jsp";
                    unitID = request.getParameter("id");
                    WebBusinessObject unitupdate = new WebBusinessObject();
                    unitupdate = measureMgr.getOnSingleKey(unitID);
                    request.setAttribute("data", unitupdate);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 6:
                    try {
                        if (unitsMgr.getOnSingleKey(request.getParameter("id").toString()) != null) {
                            if (unitsMgr.updateObject(request, session)) {
                                request.setAttribute("status", "ok");
                            } else {
                                request.setAttribute("status", "no");
                            }
                        } else {
                            request.setAttribute("status", "no");
                            request.setAttribute("name", "Not Found Name");
                        }
                    } catch (Exception ex) {
                        Logger.getLogger(MeasurementUnitsServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    servedPage = "/docs/Adminstration/update_measurement_unit.jsp";
                    request.setAttribute("data", unitsMgr.getOnSingleKey(request.getParameter("id").toString()));
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 7:
                    String unitName = request.getParameter("unitName");
                    unitID = request.getParameter("id");

                    servedPage = "/docs/Adminstration/confirm_del_measure_unit.jsp";

                    request.setAttribute("unitName", unitName);
                    request.setAttribute("unitID", unitID);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 8:
                    unitID = request.getParameter("unitID");
                    if (!unitsMgr.deleteOnSingleKey(unitID)) {
                        servedPage = "/docs/Adminstration/cant_del_measure_unit.jsp";
                        request.setAttribute("servlet", "MeasurementUnitsServlet");
                        request.setAttribute("list", "ListMeasuerUnits");
                        request.setAttribute("type", "Unit");
                        request.setAttribute("name", request.getParameter("unitName"));
                        request.setAttribute("page", servedPage);
                    } else {
                        units = unitsMgr.getCashedTable();
                        servedPage = "/docs/Adminstration/measurement_unit_list.jsp";

                        request.setAttribute("data", units);
                        request.setAttribute("page", servedPage);
                    }
                    this.forwardToServedPage(request, response);

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
        if (opName.indexOf("GetMeasuerUnitForm") == 0) {
            return 1;
        }

        if (opName.equalsIgnoreCase("SaveMeasuerUnit")) {
            return 2;
        }

        if (opName.equalsIgnoreCase("ListMeasuerUnits")) {
            return 3;
        }
        if (opName.equalsIgnoreCase("ViewUnit")) {
            return 4;
        }
        if (opName.equalsIgnoreCase("GetUpdateUnitForm")) {
            return 5;
        }
        if (opName.equalsIgnoreCase("saveUpdateUnit")) {
            return 6;
        }
        if (opName.equalsIgnoreCase("confirmDeleteMeasureUnit")) {
            return 7;
        }
        if (opName.equalsIgnoreCase("deleteMeasureUnit")) {
            return 8;
        }
        return 0;
    }
}
