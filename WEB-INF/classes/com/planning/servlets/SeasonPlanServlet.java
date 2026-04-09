/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.planning.servlets;

import com.planning.db_access.PlanMgr;
import com.planning.db_access.RecordSeasonMgr;
import com.planning.db_access.SeasonPlanMgr;
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
public class SeasonPlanServlet extends TrackerBaseServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        super.processRequest(request, response);
        HttpSession session = request.getSession();
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        PlanMgr planMgr = PlanMgr.getInstance();
        RecordSeasonMgr seasonMgr = RecordSeasonMgr.getInstance();
        SeasonPlanMgr seasonPlanMgr = SeasonPlanMgr.getInstance();
        
        switch (operation) {

            case 1:
                servedPage = "/docs/planning/attach_season.jsp";
                String planId = request.getParameter("planId");
                String seasonId = null;
                WebBusinessObject seasonPlanWbo = null;
                WebBusinessObject planWbo = null;
                WebBusinessObject seasonWbo = null;
                Vector seasonPlanVec = null;
                Vector seasonVec = null;

                planWbo = planMgr.getOnSingleKey(planId);

                try {
                    seasonPlanVec = seasonPlanMgr.getOnArbitraryKey(planId, "key2");

                } catch (SQLException ex) {
                    Logger.getLogger(SeasonPlanServlet.class.getName()).log(Level.SEVERE, null, ex);

                } catch (Exception ex) {
                    Logger.getLogger(SeasonPlanServlet.class.getName()).log(Level.SEVERE, null, ex);

                }

                if(seasonPlanVec != null) {
                    seasonVec = new Vector();
                    
                    for(int i = 0; i < seasonPlanVec.size(); i++) {
                        seasonPlanWbo = (WebBusinessObject) seasonPlanVec.get(i);
                        seasonId = (String) seasonPlanWbo.getAttribute("seasonId");
                        seasonWbo = seasonMgr.getOnSingleKey(seasonId);
                        seasonWbo.setAttribute("notes", (String) seasonPlanWbo.getAttribute("notes"));
                        seasonVec.add(seasonWbo);

                    }

                    request.setAttribute("seasonVec", seasonVec);

                }

                request.setAttribute("planId", (String) planWbo.getAttribute("planId"));
                request.setAttribute("planName", (String) planWbo.getAttribute("planName"));                
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 2:

                servedPage = "/docs/planning/attach_season.jsp";
                seasonPlanVec = null;
                seasonVec = null;
                planId = request.getParameter("planId");
                planWbo = planMgr.getOnSingleKey(planId);
                String[] seasonIdArr = request.getParameterValues("seasonId");
                String[] notesArr = request.getParameterValues("notes");

                if(seasonPlanMgr.saveMultiObject(planId,
                                seasonIdArr,
                                notesArr,
                                session)) {

                    request.setAttribute("Status", "OK");

                } else {
                    request.setAttribute("Status", "No");

                }

                try {
                    seasonPlanVec = seasonPlanMgr.getOnArbitraryKey(planId, "key2");

                } catch (SQLException ex) {
                    Logger.getLogger(SeasonPlanServlet.class.getName()).log(Level.SEVERE, null, ex);

                } catch (Exception ex) {
                    Logger.getLogger(SeasonPlanServlet.class.getName()).log(Level.SEVERE, null, ex);

                }

                if(seasonPlanVec != null) {
                    seasonVec = new Vector();
                    
                    for(int i = 0; i < seasonPlanVec.size(); i++) {
                        seasonPlanWbo = (WebBusinessObject) seasonPlanVec.get(i);
                        seasonId = (String) seasonPlanWbo.getAttribute("seasonId");
                        seasonWbo = seasonMgr.getOnSingleKey(seasonId);
                        seasonWbo.setAttribute("notes", (String) seasonPlanWbo.getAttribute("notes"));
                        seasonVec.add(seasonWbo);

                    }

                    request.setAttribute("seasonVec", seasonVec);

                }

                request.setAttribute("page", servedPage);
                request.setAttribute("planId", (String) planWbo.getAttribute("planId"));
                request.setAttribute("planName", (String) planWbo.getAttribute("planName"));                
                
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
        if (opName.equals("getAttachSeasonForm")) {
            return 1;
        }
        if (opName.equals("saveSeasonPlanAttachements")) {
            return 2;
        }
        
        return 0;
    }
}
