package com.tracker.servlets;

import com.maintenance.db_access.TradeMgr;
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import java.util.*;
import java.sql.*;
import com.silkworm.logger.db_access.LoggerMgr;
import com.tracker.common.*;
import com.tracker.db_access.*;
import com.tracker.business_objects.*;
import com.silkworm.servlets.*;
import org.apache.log4j.Logger;

public class TradeServlet extends swBaseServlet {

    ProjectMgr projectMgr = ProjectMgr.getInstance();
    TradeMgr tradeMgr = TradeMgr.getInstance();
    IssueMgr issueMgr = IssueMgr.getInstance();
    LoggerMgr loggerMgr = LoggerMgr.getInstance();
    WebBusinessObject loggerWbo = new WebBusinessObject();
    WebIssue wIssue = new WebIssue();
    WebBusinessObject project = null;
    WebBusinessObject tradeWbo = null;
    WebBusinessObject userObj = null;
    String viewOrigin = null;

    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        servedPage = "/docs/Adminstration/new_project.jsp";
        logger = Logger.getLogger(TradeServlet.class);
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

                servedPage = "/docs/Adminstration/new_trade.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);


                break;

            case 2:
                String tradeName = request.getParameter("trade_name");
                String tradeNO = request.getParameter("tradeNO");
                //String pDescription = request.getParameter(ProjectConstants.PROJECT_DESC);

                WebBusinessObject tradeWbo = new WebBusinessObject();

                tradeWbo.setAttribute("tradeName", tradeName);
                tradeWbo.setAttribute("tradeNO", tradeNO);


                servedPage = "/docs/Adminstration/new_trade.jsp";
                try {
                    if (!tradeMgr.getDoubleName(request.getParameter("trade_name"))) {
                        if (tradeMgr.saveObject(tradeWbo, session)) {
                            request.setAttribute("Status", "Ok");
                        } else {
                            request.setAttribute("Status", "No");
                        }

                    } else {
                        request.setAttribute("Status", "No");
                        request.setAttribute("name", "Duplicate Name");
                    }
                } catch (NoUserInSessionException ex) {
                    logger.error(ex.getMessage());
                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }

                //request.setAttribute("data", issuesList);
                //request.setAttribute("status", "Unassigned");
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 3:
                Vector trades = tradeMgr.getCashedTable();
                servedPage = "/docs/Adminstration/trade_list.jsp";

                request.setAttribute("data", trades);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 4:
                tradeName = request.getParameter("tradeName");
                String tradeId = request.getParameter("tradeId");

                servedPage = "/docs/Adminstration/confirm_deltrade.jsp";

                request.setAttribute("tradeName", tradeName);
                request.setAttribute("tradeId", tradeId);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;


            case 5:
                servedPage = "/docs/Adminstration/view_trade.jsp";
                tradeId = request.getParameter("tradeId");

                tradeWbo = tradeMgr.getOnSingleKey(tradeId);
                request.setAttribute("tradeWbo", tradeWbo);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);

                break;

            case 6:
                tradeId = request.getParameter("tradeId");
                tradeWbo = tradeMgr.getOnSingleKey(tradeId);

                servedPage = "/docs/Adminstration/update_trade.jsp";

                request.setAttribute("tradeWbo", tradeWbo);

                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 7:
                String key = request.getParameter("tradeId").toString();
                String OldTradeName = request.getParameter("OldTradeName");
                tradeName = request.getParameter("tradeName");
                servedPage = "/docs/Adminstration/update_trade.jsp";

                // scrapeForm(request,"update");

                tradeWbo = new WebBusinessObject();
                tradeWbo.setAttribute("tradeName", request.getParameter("tradeName"));

                tradeWbo.setAttribute("tradeCode", request.getParameter("tradeNO"));
                tradeWbo.setAttribute("tradeId", request.getParameter("tradeId"));

                // do update
                try {
                    if (!tradeMgr.getDoubleNameforUpdate(key, request.getParameter("tradeName"))) {
                        if (tradeMgr.updateTrade(tradeWbo)) {
                            tradeMgr.UpdateUserTrade(tradeName, OldTradeName);
                            request.setAttribute("Status", "Ok");
                            request.setAttribute("tradeWbo", tradeWbo);
                            //shipBack("ok",request,response);
                        } else {
                            request.setAttribute("Status", "No");
                            request.setAttribute("tradeWbo", tradeWbo);
                            // shipBack("No",request,response);
                        }

                    } else {
                        request.setAttribute("Status", "No");
                        request.setAttribute("name", "Duplicate Name");
                        request.setAttribute("tradeWbo", tradeWbo);
                    }
                } catch (NoUserInSessionException ex) {
                    logger.error(ex.getMessage());
                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }

                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

//                catch(EmptyRequestException ere) {
//                    shipBack(ere.getMessage(),request,response);
//                    break;
//                }
//                
//                
//                catch(SQLException sqlEx) {
//                    shipBack(sqlEx.getMessage(),request,response);
//                    break;
//                } catch(NoUserInSessionException nouser) {
//                    shipBack(nouser.getMessage(),request,response);
//                    break;
//                }
//                
//                catch(Exception Ex) {
//                    shipBack(Ex.getMessage(),request,response);
//                    break;
//                }
            case 8:

                loggerWbo = new WebBusinessObject();
                WebBusinessObject objectXml = tradeMgr.getOnSingleKey(request.getParameter("tradeId"));
                loggerWbo.setAttribute("objectXml", objectXml.getObjectAsXML());
                if (tradeMgr.deleteOnSingleKey(request.getParameter("tradeId"))) {
                    loggerWbo.setAttribute("realObjectId", request.getParameter("tradeId"));
                    loggerWbo.setAttribute("userId", userObj.getAttribute("userId"));
                    loggerWbo.setAttribute("objectName", "Trade");
                    loggerWbo.setAttribute("loggerMessage", "Trade Deleted");
                    loggerWbo.setAttribute("eventName", "Delete");
                    loggerWbo.setAttribute("objectTypeId", "4");
                    loggerWbo.setAttribute("eventTypeId", "2");
                    loggerWbo.setAttribute("ipForClient", getClientIpAddr(request));
                    try {
                        loggerMgr.saveObject(loggerWbo);
                    } catch (SQLException ex) {
                        logger.error(ex);
                    }
                }
                tradeMgr.cashData();
                trades = tradeMgr.getCashedTable();
                servedPage = "/docs/Adminstration/trade_list.jsp";


                request.setAttribute("data", trades);
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
        return "Project Servlet";
    }

    protected int getOpCode(String opName) {

        if (opName.equalsIgnoreCase("GetTradeForm")) {
            return 1;
        }
        if (opName.equalsIgnoreCase("Create")) {
            return 2;
        }

        if (opName.equalsIgnoreCase("ListTrades")) {
            return 3;
        }

        if (opName.equalsIgnoreCase("ConfirmDelete")) {
            return 4;
        }

        if (opName.equalsIgnoreCase("ViewTrade")) {
            return 5;
        }

        if (opName.equalsIgnoreCase("GetUpdateForm")) {
            return 6;
        }

        if (opName.equalsIgnoreCase("UpdateTrade")) {
            return 7;
        }

        if (opName.equalsIgnoreCase("Delete")) {
            return 8;
        }
//


        return 0;
    }

    private void scrapeForm(HttpServletRequest request, String mode) throws EmptyRequestException, EntryExistsException, SQLException, Exception {

        String projectID = request.getParameter("projectID");
        String eqNO = request.getParameter("eqNO");
        String projectDesc = request.getParameter("projectDesc");

        if (projectID == null || projectDesc.equals("") || eqNO.equals("")) {
            throw new EmptyRequestException(tGuide.getMessage("incompleteinput"));
        }

        if (projectID.equals("") || projectDesc.equals("") || eqNO.equals("")) {
            throw new EmptyRequestException(tGuide.getMessage("incompleteinput"));
        }

        if (mode.equalsIgnoreCase("insert")) {
            WebBusinessObject existingProject = projectMgr.getOnSingleKey(projectID);

            if (existingProject != null) {
                throw new EntryExistsException();
            }

        }
    }

    private void shipBack(String message, HttpServletRequest request, HttpServletResponse response) {
        project = projectMgr.getOnSingleKey(request.getParameter("projectID"));
        request.setAttribute("project", project);
        request.setAttribute("status", message);
        request.setAttribute("page", servedPage);
        this.forwardToServedPage(request, response);

    }
}
