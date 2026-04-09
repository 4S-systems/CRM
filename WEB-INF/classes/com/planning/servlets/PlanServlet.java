package com.planning.servlets;

import com.maintenance.common.DateParser;
import com.planning.db_access.PlanMgr;
import java.io.*;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.*;
import javax.servlet.http.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import com.tracker.business_objects.*;
import com.silkworm.servlets.*;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Vector;

public class PlanServlet extends swBaseServlet {

    PlanMgr planMgr = PlanMgr.getInstance();
    WebIssue wIssue = new WebIssue();
    WebBusinessObject plan = null;
    WebBusinessObject userObj = null;
    String viewOrigin = null;

    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        servedPage = "/docs/Adminstration/new_plan.jsp";
    }

    /** Destroys the servlet.
     */
    public void destroy() {

    }

    /** Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        super.processRequest(request, response);
        HttpSession session = request.getSession();
        userObj = (WebBusinessObject) session.getAttribute("loggedUser");

        String page = null;

        operation = getOpCode((String) request.getParameter("op"));

        switch (operation) {
            
            case 1:
                servedPage = "/docs/planning/new_plan.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 2:
                DateFormat dateFormatter = new SimpleDateFormat("yyyy/MM/dd");
                DateParser dateParser = new DateParser();
                WebBusinessObject plan = new WebBusinessObject();
                String planCode = request.getParameter("planCode");
                String planName = request.getParameter("planName");
                String planDesc = request.getParameter("planDesc");
                String planType = request.getParameter("planType");
                String beginDate = request.getParameter("beginDate");
                String endDate = request.getParameter("endDate");

                Vector planCodeVec = null;
                Vector planNameVec = null;

                boolean dupName = false;
                boolean dupCode = false;

                try {
                    planNameVec = planMgr.getOnArbitraryKey(planName, "key1");
                    planCodeVec = planMgr.getOnArbitraryKey(planCode, "key2");

                } catch (SQLException ex) {
                    Logger.getLogger(PlanServlet.class.getName()).log(Level.SEVERE, null, ex);

                } catch (Exception ex) {
                    Logger.getLogger(PlanServlet.class.getName()).log(Level.SEVERE, null, ex);
                    
                }
                
                dupName = !planNameVec.isEmpty();
                dupCode = !planCodeVec.isEmpty();
                
                plan.setAttribute("planCode", planCode);
                plan.setAttribute("planName", planName);
                plan.setAttribute("planDesc", planDesc);
                plan.setAttribute("planType", planType);
                plan.setAttribute("beginDate", dateParser.formatSqlDate(beginDate));
                plan.setAttribute("endDate", dateParser.formatSqlDate(endDate));

                try {
                    if (!dupCode) {

                        if (!dupName) {
                            if (planMgr.saveObject(plan, session)) {
                                request.setAttribute("Status", "Ok");
                            } else {
                                request.setAttribute("Status", "No");
                            }

                        } else {
                            request.setAttribute("Status", "No");
                            request.setAttribute("dupData", "name");
                        }
                        
                    } else {
                        request.setAttribute("Status", "No");
                        request.setAttribute("dupData", "code");
                    }

                } catch (NoUserInSessionException noUser) {
                    logger.error("Plan Servlet: save plan " + noUser);
                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }

                if(dupCode || dupName) {
                    request.setAttribute("planCode", planCode);
                    request.setAttribute("planName", planName);
                    request.setAttribute("planDesc", planDesc);
                    request.setAttribute("planType", planType);
                    
                    try {
                        request.setAttribute("beginDate", dateFormatter.parse(beginDate));
                        request.setAttribute("endDate", dateFormatter.parse(endDate));

                    } catch (ParseException ex) {
                        Logger.getLogger(PlanServlet.class.getName()).log(Level.SEVERE, null, ex);
                        
                    }
                    

                }

                servedPage = "/docs/planning/new_plan.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 3:
                servedPage = "/docs/planning/plan_list.jsp";
                request.setAttribute("planVec", planMgr.getCashedTable());
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 4:
                String planId = request.getParameter("planId");
                plan = planMgr.getOnSingleKey(planId);
                servedPage = "/docs/planning/view_plan.jsp";
                
                request.setAttribute("plan", plan);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);

                break;

            default:
                this.forwardToServedPage(request, response);

        }

    }

    /** Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /** Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /** Returns a short description of the servlet.
     */
    public String getServletInfo() {
        return "Plan Servlet";
    }

    protected int getOpCode(String opName) {

        if (opName.equalsIgnoreCase("getCreatePlanForm")) {
            return 1;
        }
        
        if (opName.equalsIgnoreCase("createPlan")) {
            return 2;
        }

        if (opName.equalsIgnoreCase("listPlans")) {
            return 3;
        }

        if (opName.equalsIgnoreCase("viewPlan")) {
            return 4;
        }

        return 0;
    }

}
