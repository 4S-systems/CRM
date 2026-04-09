/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.maintenance.servlets;

import com.maintenance.db_access.MainCategoryTypeMgr;
import com.maintenance.db_access.MainTypeMeasurementMgr;
import com.maintenance.db_access.MeasurementsMgr;
import com.silkworm.business_objects.WebBusinessObject;
import com.tracker.servlets.TrackerBaseServlet;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.text.DateFormatSymbols;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
//import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Waled
 */
public class MainTypeMeasurementServlet extends TrackerBaseServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        super.processRequest(request, response);
        HttpSession session = request.getSession();
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        MainCategoryTypeMgr mainCategoryTypeMgr = MainCategoryTypeMgr.getInstance();
        MeasurementsMgr measurementsMgr = MeasurementsMgr.getInstance();
        MainTypeMeasurementMgr mainTypeMeasurementMgr = MainTypeMeasurementMgr.getInstance();
        
        switch (operation) {

            case 1:
                servedPage = "/docs/equipment/attach_measurement.jsp";
                String mainTypeId = request.getParameter("mainTypeId");
                String measurementId = null;
                WebBusinessObject mainTypeMeasurementWbo = null;
                WebBusinessObject mainTypeWbo = null;
                WebBusinessObject measurementWbo = null;
                Vector mainTypeMeasurementVec = null;
                Vector measurementVec = null;

                mainTypeWbo = mainCategoryTypeMgr.getOnSingleKey(mainTypeId);

                try {
                    mainTypeMeasurementVec = mainTypeMeasurementMgr.getOnArbitraryKey(mainTypeId, "key1");

                } catch (SQLException ex) {
                    Logger.getLogger(MainTypeMeasurementServlet.class.getName()).log(Level.SEVERE, null, ex);

                } catch (Exception ex) {
                    Logger.getLogger(MainTypeMeasurementServlet.class.getName()).log(Level.SEVERE, null, ex);

                }

                if(mainTypeMeasurementVec != null) {
                    measurementVec = new Vector();
                    
                    for(int i = 0; i < mainTypeMeasurementVec.size(); i++) {
                        mainTypeMeasurementWbo = (WebBusinessObject) mainTypeMeasurementVec.get(i);
                        measurementId = (String) mainTypeMeasurementWbo.getAttribute("measurementId");
                        measurementWbo = measurementsMgr.getOnSingleKey(measurementId);
                        measurementWbo.setAttribute("notes", (String) mainTypeMeasurementWbo.getAttribute("notes"));
                        measurementVec.add(measurementWbo);

                    }

                    request.setAttribute("measurementVec", measurementVec);

                }

                request.setAttribute("mainTypeId", (String) mainTypeWbo.getAttribute("id"));
                request.setAttribute("mainTypeName", (String) mainTypeWbo.getAttribute("typeName"));
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 2:

                servedPage = "/docs/equipment/attach_measurement.jsp";
                mainTypeMeasurementVec = null;
                measurementVec = null;
                mainTypeId = request.getParameter("mainTypeId");
                mainTypeWbo = mainCategoryTypeMgr.getOnSingleKey(mainTypeId);
                String[] measurementIdArr = request.getParameterValues("measurementId");
                String[] notesArr = request.getParameterValues("notes");

                if(mainTypeMeasurementMgr.saveMultiObject(mainTypeId,
                                measurementIdArr,
                                notesArr,
                                session)) {

                    request.setAttribute("Status", "OK");

                } else {
                    request.setAttribute("Status", "No");

                }

                try {
                    mainTypeMeasurementVec = mainTypeMeasurementMgr.getOnArbitraryKey(mainTypeId, "key1");

                } catch (SQLException ex) {
                    Logger.getLogger(MainTypeMeasurementServlet.class.getName()).log(Level.SEVERE, null, ex);

                } catch (Exception ex) {
                    Logger.getLogger(MainTypeMeasurementServlet.class.getName()).log(Level.SEVERE, null, ex);

                }

                if(mainTypeMeasurementVec != null) {
                    measurementVec = new Vector();
                    
                    for(int i = 0; i < mainTypeMeasurementVec.size(); i++) {
                        mainTypeMeasurementWbo = (WebBusinessObject) mainTypeMeasurementVec.get(i);
                        measurementId = (String) mainTypeMeasurementWbo.getAttribute("measurementId");
                        measurementWbo = measurementsMgr.getOnSingleKey(measurementId);
                        measurementWbo.setAttribute("notes", (String) mainTypeMeasurementWbo.getAttribute("notes"));
                        measurementVec.add(measurementWbo);

                    }

                    request.setAttribute("measurementVec", measurementVec);

                }

                request.setAttribute("page", servedPage);
                request.setAttribute("mainTypeId", (String) mainTypeWbo.getAttribute("id"));
                request.setAttribute("mainTypeName", (String) mainTypeWbo.getAttribute("typeName"));
                
                this.forwardToServedPage(request, response);

                break;
            
            default:
                System.out.println("Case Not Found");
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
    public String getNameOfMonth(int monthNumber) {
        String monthName = "invalid";
        DateFormatSymbols dfs = new DateFormatSymbols();
        String[] months = dfs.getMonths();
        if (monthNumber >= 0 && monthNumber <= 11) {
            monthName = months[monthNumber];
        }
        return monthName;
    }

    protected int getOpCode(String opName) {
        if (opName.equals("getAttachMeasurementForm")) {
            return 1;
        }
        if (opName.equals("saveMainTypeMeasurementAttachements")) {
            return 2;
        }
        
        return 0;
    }
}
