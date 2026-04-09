package com.planning.servlets;

import com.planning.db_access.PlanIssueMgr;
import com.planning.db_access.PlanMgr;
import java.io.*;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.*;
import javax.servlet.http.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import com.tracker.business_objects.*;
import com.silkworm.servlets.*;
import com.tracker.db_access.IssueMgr;
import java.util.Arrays;
import java.util.Vector;
import org.apache.commons.lang.StringUtils;

public class PlanIssueServlet extends swBaseServlet {

    PlanMgr planMgr = PlanMgr.getInstance();
    IssueMgr issueMgr = IssueMgr.getInstance();
    WebIssue wIssue = new WebIssue();
    WebBusinessObject plan = null;
    WebBusinessObject userObj = null;
    String viewOrigin = null;

    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        servedPage = "/docs/Adminstration/new_plan_issue.jsp";
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
        PlanIssueMgr planIssueMgr = PlanIssueMgr.getInstance();

        String page = null;

        operation = getOpCode((String) request.getParameter("op"));

        switch (operation) {

            case 1:
                String issueIdList = request.getParameter("issueIdList");
                servedPage = "/docs/planning/save_issues_to_plan.jsp";

                String[] issueIdArr = request.getParameterValues("checkJO");
                request.setAttribute("issueIdList", Arrays.toString(issueIdArr));
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 2:
                
                String issueId = null;
                Vector planIssueVec = null;
                boolean dupIssue = false;
                String issueIdStr = null;


                issueIdList = request.getParameter("issueIdList");
                issueIdStr = StringUtils.substringBetween(issueIdList, "[", "]");
                issueIdArr = StringUtils.split(issueIdStr, ", ");
                String planId = request.getParameter("plan");
                
                // check whether issue(s) was already saved to selected plan
                for(int i = 0; i < issueIdArr.length; i++) {
                    issueId = issueIdArr[i];
                    
                    try {
                        planIssueVec = planIssueMgr.getOnArbitraryDoubleKey(planId, "key1", issueId, "key2");

                    } catch (SQLException ex) {
                        Logger.getLogger(PlanIssueServlet.class.getName()).log(Level.SEVERE, null, ex);

                    } catch (Exception ex) {
                        Logger.getLogger(PlanIssueServlet.class.getName()).log(Level.SEVERE, null, ex);
                        
                    }

                    if(!planIssueVec.isEmpty()) {
                        dupIssue = true;
                        break;

                    }                   
                }

                try {
                    if (!dupIssue) {

                        if (planIssueMgr.savePlanIssues(planId, issueIdArr, session)) {
                            request.setAttribute("Status", "Ok");

                        } else {
                            request.setAttribute("Status", "No");
                            
                        }

                    } else {
                        request.setAttribute("Status", "No");
                        request.setAttribute("dupIssue", "yes");
                    }

                } catch (NoUserInSessionException noUser) {
                    logger.error("Plan Servlet: save plan " + noUser);

                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                    
                }

                servedPage = "/docs/planning/save_issues_to_plan.jsp";
                request.setAttribute("issueIdList", issueIdList);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 3:
                planId = request.getParameter("planId");
                servedPage = "/docs/planning/issues_by_plan.jsp";
                WebBusinessObject planIssueWbo = null;
                WebBusinessObject issueWbo = null;
                Vector issueVec = null;
                Vector issuesByPlanVec = null;
                issueId = null;

                try {
                    issuesByPlanVec = planIssueMgr.getOnArbitraryKey(planId, "key1");
                } catch (SQLException ex) {
                    Logger.getLogger(PlanIssueServlet.class.getName()).log(Level.SEVERE, null, ex);
                } catch (Exception ex) {
                    Logger.getLogger(PlanIssueServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                if(!issuesByPlanVec.isEmpty()) {
                    issueVec = new Vector();

                    for(int i = 0; i < issuesByPlanVec.size(); i++) {
                        planIssueWbo = (WebBusinessObject) issuesByPlanVec.get(i);
                        issueId = (String) planIssueWbo.getAttribute("issueId");
                        issueWbo = issueMgr.getOnSingleKey(issueId);

                        issueVec.add(issueWbo);

                    }

                    request.setAttribute("issueVec", issueVec);

                }
                
                this.forward(servedPage, request, response);
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

        if (opName.equalsIgnoreCase("getPlanIssueForm")) {
            return 1;
        }

        if (opName.equalsIgnoreCase("savePlanIssues")) {
            return 2;
        }

        if (opName.equalsIgnoreCase("getIssuesByPlan")) {
            return 3;
        }

        return 0;
    }

}
