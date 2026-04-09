package com.tracker.servlets;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import java.util.*;
import java.sql.*;
import com.tracker.common.*;
import com.tracker.db_access.*;
import com.tracker.business_objects.*;
import com.silkworm.servlets.*;
import org.apache.log4j.Logger;

public class MilestoneServlet extends swBaseServlet {

    MilestoneMgr milestoneMgr = MilestoneMgr.getInstance();
    WebIssue wIssue = new WebIssue();
    WebBusinessObject milestone = null;
    WebBusinessObject userObj = null;
    String viewOrigin = null;

    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        servedPage = "/docs/Adminstration/new_milestone.jsp";
        logger = Logger.getLogger(MilestoneServlet.class);
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

        // issueMgr.setUser(userObj);

        String page = null;

        operation = getOpCode((String) request.getParameter("op"));

        switch (operation) {
            case 1:
                String issueId = request.getParameter(IssueConstants.ISSUEID);
                String issueTitle = request.getParameter(IssueConstants.ISSUETITLE);

                servedPage = "/docs/Adminstration/new_milestone.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);


                break;

            case 2:

                String pName = request.getParameter("milestone_name");
                String pDescription = request.getParameter("milestone_desc");

                WebBusinessObject milestone = new WebBusinessObject();

                milestone.setAttribute("milestoneName", pName);
                milestone.setAttribute("milestoneDesc", pDescription);

                servedPage = "/docs/Adminstration/new_milestone.jsp";
                try {
                    if (milestoneMgr.saveObject(request, milestone, session)) {
                        request.setAttribute("Status", "Ok");
                    } else {
                        request.setAttribute("Status", "No");
                    }

                } catch (NoUserInSessionException noUser) {
                    logger.error("Milestone Servlet: save Milestone " + noUser);
                }

                //request.setAttribute("data", issuesList);
                //request.setAttribute("status", "Unassigned");
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 3:
                Vector milestones = milestoneMgr.getCashedTable();
                servedPage = "/docs/Adminstration/milestone_list.jsp";

                request.setAttribute("data", milestones);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 4:
                String milestoneName = request.getParameter("milestoneName");
                String milestoneId = request.getParameter("milestoneId");

                servedPage = "/docs/Adminstration/confirm_delmilestone.jsp";

                request.setAttribute("milestoneName", milestoneName);
                request.setAttribute("milestoneId", milestoneId);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;


            case 5:
                servedPage = "/docs/Adminstration/view_milestone.jsp";
                milestoneId = request.getParameter("milestoneId");

                milestone = milestoneMgr.getOnSingleKey(milestoneId);
                request.setAttribute("milestone", milestone);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);

                break;

            case 6:
                milestoneId = request.getParameter("milestoneId");
                milestone = milestoneMgr.getOnSingleKey(milestoneId);

                servedPage = "/docs/Adminstration/update_milestone.jsp";

                request.setAttribute("milestone", milestone);

                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 7:
                servedPage = "/docs/Adminstration/update_milestone.jsp";

                try {

                    scrapeForm(request, "update");

                    milestone = new WebBusinessObject();
                    milestone.setAttribute("milestoneDesc", request.getParameter("milestoneDesc"));
                    milestone.setAttribute("milestoneID", request.getParameter("milestoneID"));

                    // do update
                    milestoneMgr.updateMilestone(milestone);

                    // fetch the group again
                    shipBack("ok", request, response);
                    break;
                } catch (EmptyRequestException ere) {
                    shipBack(ere.getMessage(), request, response);
                    break;
                } catch (SQLException sqlEx) {
                    shipBack(sqlEx.getMessage(), request, response);
                    break;
                } catch (NoUserInSessionException nouser) {
                    shipBack(nouser.getMessage(), request, response);
                    break;
                } catch (Exception Ex) {
                    shipBack(Ex.getMessage(), request, response);
                    break;
                }
            case 8:
//                try{
//                    IssueMgr issueMgr = IssueMgr.getInstance();
//                    Integer iTemp = new Integer(issueMgr.hasData("MILESTONE_NAME", request.getParameter("milestoneName")));
//                    if(iTemp.intValue() > 0) {
//                        servedPage="/docs/Adminstration/cant_delete.jsp";
//                        request.setAttribute("servlet", "MilestoneServlet");
//                        request.setAttribute("list", "ListMilestones");
//                        request.setAttribute("type", "Milestone");
//                        request.setAttribute("name", request.getParameter("milestoneName"));
//                        request.setAttribute("no", iTemp.toString());
//                        request.setAttribute("page",servedPage);
//                    } else {
                milestoneMgr.deleteOnSingleKey(request.getParameter("milestoneId"));
                milestoneMgr.cashData();
                milestones = milestoneMgr.getCashedTable();
                servedPage = "/docs/Adminstration/milestone_list.jsp";

                request.setAttribute("data", milestones);
                request.setAttribute("page", servedPage);
//                    }
                this.forwardToServedPage(request, response);
//                } catch(NoUserInSessionException ne) {
//                }
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
        return "Milestone Servlet";
    }

    protected int getOpCode(String opName) {

        if (opName.equalsIgnoreCase("GetMilestoneForm")) {
            return 1;
        }
        if (opName.equalsIgnoreCase("create")) {
            return 2;
        }

        if (opName.equalsIgnoreCase("ListMilestone")) {
            return 3;
        }

        if (opName.equalsIgnoreCase("ConfirmDelete")) {
            return 4;
        }

        if (opName.equalsIgnoreCase("ViewMilestone")) {
            return 5;
        }

        if (opName.equalsIgnoreCase("GetUpdateForm")) {
            return 6;
        }

        if (opName.equalsIgnoreCase("UpdateMilestone")) {
            return 7;
        }

        if (opName.equalsIgnoreCase("Delete")) {
            return 8;
        }
//


        return 0;
    }

    private void scrapeForm(HttpServletRequest request, String mode) throws EmptyRequestException, EntryExistsException, SQLException, Exception {

        String milestoneID = request.getParameter("milestoneID");
        String milestoneDesc = request.getParameter("milestoneDesc");

        if (milestoneID == null || milestoneDesc.equals("")) {
            throw new EmptyRequestException(tGuide.getMessage("incompleteinput"));
        }

        if (milestoneID.equals("") || milestoneDesc.equals("")) {
            throw new EmptyRequestException(tGuide.getMessage("incompleteinput"));
        }

        if (mode.equalsIgnoreCase("insert")) {
            WebBusinessObject existingMilestone = milestoneMgr.getOnSingleKey(milestoneID);

            if (existingMilestone != null) {
                throw new EntryExistsException();
            }

        }
    }

    private void shipBack(String message, HttpServletRequest request, HttpServletResponse response) {
        milestone = milestoneMgr.getOnSingleKey(request.getParameter("milestoneID"));
        request.setAttribute("milestone", milestone);
        request.setAttribute("status", message);
        request.setAttribute("page", servedPage);
        this.forwardToServedPage(request, response);

    }
}
