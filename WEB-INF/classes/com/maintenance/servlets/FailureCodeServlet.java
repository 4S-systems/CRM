package com.maintenance.servlets;

import com.tracker.db_access.*;
import com.docviewer.db_access.*;
import java.io.*;
import java.sql.SQLException;
import java.util.*;

import javax.servlet.*;
import javax.servlet.http.*;

import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.Exceptions.*;
import com.tracker.servlets.TrackerBaseServlet;

import com.maintenance.db_access.*;

import com.contractor.db_access.MaintainableMgr;
public class FailureCodeServlet extends TrackerBaseServlet {

    MaintainableMgr unit = MaintainableMgr.getInstance();
    ItemCatsMgr itemCatsMgr = ItemCatsMgr.getInstance();
    CategoryMgr categoryMgr = CategoryMgr.getInstance();
    ItemMgr itemMgr = ItemMgr.getInstance();
    FailureCodeMgr failureCodeMgr = FailureCodeMgr.getInstance();
    ActualItemMgr actualItemMgr = ActualItemMgr.getInstance();
    QuantifiedMntenceMgr quantifiedMntenceMgr = QuantifiedMntenceMgr.getInstance();
    IssueStatusMgr issueStatusMgr = IssueStatusMgr.getInstance();
    IssueMgr issueMgr = IssueMgr.getInstance();
    FolderMgr folderMgr = FolderMgr.getInstance();
    InstMgr instMgr = InstMgr.getInstance();
    UnitScheduleMgr unitScheduleMgr = UnitScheduleMgr.getInstance();
    AverageUnitMgr averageUnitMgr = AverageUnitMgr.getInstance();
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
                servedPage = "/docs/Adminstration/new_failure_code.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 2:


                servedPage = "/docs/Adminstration/new_failure_code.jsp";
                WebBusinessObject failure = new WebBusinessObject();

                failure.setAttribute("tradeName", request.getParameter("tradeName").toString());
                failure.setAttribute("title", request.getParameter("title").toString());
                failure.setAttribute("description", request.getParameter("description").toString());


                try {
                    if (!failureCodeMgr.getDoubleName(request.getParameter("title"))) {
                        if (failureCodeMgr.saveObject(failure, session)) {
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


                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;


            case 3:
                Vector failures = new Vector();
                failureCodeMgr.cashData();
                failures = failureCodeMgr.getAllItems();
                servedPage = "/docs/Adminstration/Failure_code_List.jsp";

                request.setAttribute("data", failures);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 4:
                String failureId = null;
                servedPage = "/docs/Adminstration/view_Failure_Code.jsp";
                failureId = request.getParameter("failureId");
                failure = failureCodeMgr.getOnSingleKey(failureId);
                request.setAttribute("failure", failure);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);

                break;

            case 5:

                failureId = request.getParameter("failureId");
                failure = failureCodeMgr.getOnSingleKey(failureId);
                servedPage = "/docs/Adminstration/update_failure_code.jsp";

                request.setAttribute("failure", failure);
                request.setAttribute("failureId", failureId);

                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;


            case 6:
                failureId = request.getParameter("failureId");

                servedPage = "/docs/Adminstration/update_failure_code.jsp";

                failure = new WebBusinessObject();
                failure.setAttribute("tradeName", request.getParameter("tradeName").toString());
                failure.setAttribute("title", request.getParameter("title").toString());
                failure.setAttribute("description", request.getParameter("description").toString());

                failure.setAttribute("failureId", request.getParameter("failureId").toString());

                try {
                    if (!failureCodeMgr.getDoubleNameforUpdate(failureId, request.getParameter("title"))) {
                        if (failureCodeMgr.updateFailureCode(failure, session)) {
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

                failure = failureCodeMgr.getOnSingleKey(request.getParameter("failureId"));
                request.setAttribute("failure", failure);
                request.setAttribute("failureId", failureId);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 7:
                String failureTitle = request.getParameter("failureTitle");
                failureId = request.getParameter("failureId");

                servedPage = "/docs/Adminstration/confirm_delfailure.jsp";

                request.setAttribute("failureTitle", failureTitle);
                request.setAttribute("failureId", failureId);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 8:
                failures = categoryMgr.getCashedTable();
                failureCodeMgr.deleteOnSingleKey(request.getParameter("failureId"));
                failureCodeMgr.cashData();
//                
                failures = failureCodeMgr.getCashedTable();
                servedPage = "/docs/Adminstration/Failure_code_List.jsp";

                request.setAttribute("data", failures);
                request.setAttribute("page", servedPage);

                this.forwardToServedPage(request, response);

                break;

            case 9:

                for (int i = 1; i < 9; i++) {
                    try {
                        failureCodeMgr.DelAllJobOrder(i);
                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                    }
//                request.setAttribute("page","main.jsp");
                }
                this.forwardToServedPage(request, response);

                break;

            case 10:

                for (int i = 1; i < 9; i++) {
                    try {
                        failureCodeMgr.DelScheduleConfigure(i);
                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                    }
//                request.setAttribute("page","main.jsp");
                }
                this.forwardToServedPage(request, response);

                break;

            case 11:
//                String equipId = null;
//                String unitId= null;
//                equipId = request.getParameter("id");
                servedPage = "/docs/schedule/del_task_by_equip.jsp";


//                unitId = failureCodeMgr.getAllUnitSheduleForEquip(equipId);

//                
//                failures = failureCodeMgr.getCashedTable();


//                request.setAttribute("data", failures);
                request.setAttribute("page", servedPage);

                this.forwardToServedPage(request, response);

                break;

            case 12:
                String equipId = null;
                String unitSchId = null;
                String issueId = null;

                Vector unitSch = new Vector();
                WebBusinessObject unitWbo = new WebBusinessObject();
                equipId = request.getParameter("unitId");
                servedPage = "/docs/schedule/del_task_by_equip.jsp";


                unitSch = failureCodeMgr.getAllUnitSheduleForEquip(equipId);
                for (int i = 0; i < unitSch.size(); i++) {

                    unitWbo = (WebBusinessObject) unitSch.elementAt(i);
                    unitSchId = unitWbo.getAttribute("id").toString();

                    try {
                        actualItemMgr.deleteOnArbitraryKey(unitSchId, "key1");
                        quantifiedMntenceMgr.deleteOnArbitraryKey(unitSchId, "key1");
                        instMgr.deleteOnArbitraryKey(unitSchId, "key3");
                        issueId = failureCodeMgr.getAllUnitSheduleForIssue(unitSchId);
                        folderMgr.deleteOnArbitraryKey(issueId, "key3");
                        issueStatusMgr.deleteOnArbitraryKey(issueId, "key2");
                        issueMgr.deleteOnArbitraryKey(unitSchId, "key3");
                        unitScheduleMgr.deleteOnSingleKey(unitSchId);
                        averageUnitMgr.deleteOnArbitraryKey(equipId, "key1");


                    } catch (SQLException ex) {
                        logger.error(ex.getMessage());
                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                    }

                }
//                
                failures = failureCodeMgr.getCashedTable();


//                request.setAttribute("data", failures);
                request.setAttribute("page", servedPage);

                this.forwardToServedPage(request, response);

                break;

            case 13:
                String docIssueId = null;

                Vector DocIssue = new Vector();
                Vector QuanMain = new Vector();
                WebBusinessObject QuanWbo = new WebBusinessObject();
                WebBusinessObject IssueWbo = new WebBusinessObject();
                issueMgr.getCashedTable();
                QuanMain = failureCodeMgr.getUnitSchEmg();
                for (int i = 0; i < QuanMain.size(); i++) {

                    QuanWbo = (WebBusinessObject) QuanMain.elementAt(i);
                    unitSchId = QuanWbo.getAttribute("unitScheduleID").toString();

                    try {

                        failureCodeMgr.DelQuanEmg(unitSchId);
                        failureCodeMgr.DelAcualEmg(unitSchId);


                    } catch (SQLException ex) {
                        logger.error(ex.getMessage());
                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                    }

                }

                DocIssue = failureCodeMgr.getIssueEmg();
                for (int i = 0; i < DocIssue.size(); i++) {

                    IssueWbo = (WebBusinessObject) DocIssue.elementAt(i);
                    docIssueId = IssueWbo.getAttribute("id").toString();

                    try {

                        failureCodeMgr.DelDocEmg(docIssueId);



                    } catch (SQLException ex) {
                        logger.error(ex.getMessage());
                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                    }

                }

                try {
                    failureCodeMgr.DelStatusEmg();


                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }

                try {
                    failureCodeMgr.DelIssueEmg();
                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }

                try {
                    failureCodeMgr.DelUnitSchEmg();
                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }

//               
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
        if (opName.indexOf("GetFailureCode") == 0) {
            return 1;
        }

        if (opName.indexOf("SaveFailure") == 0) {
            return 2;
        }

        if (opName.equals("ListFailureCode")) {
            return 3;
        }

        if (opName.equals("ViewFailure")) {
            return 4;
        }

        if (opName.equals("GetUpdateFailure")) {
            return 5;
        }

        if (opName.equals("UpdateFailure")) {
            return 6;
        }

        if (opName.equals("ConfirmDeleteFailure")) {
            return 7;
        }

        if (opName.equals("Delete")) {
            return 8;
        }

        if (opName.equals("DelAllJobOrder")) {
            return 9;
        }

        if (opName.equals("DelAllTask")) {
            return 10;
        }

        if (opName.equals("GetDelJoborderForEquip")) {
            return 11;
        }
        if (opName.equals("DelJoborderForEquip")) {
            return 12;
        }
        if (opName.equals("DelEmgJobOrder")) {
            return 13;
        }

        return 0;
    }
}

