package com.maintenance.servlets;

import com.SpareParts.db_access.TransactionMgr;
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
public class DataBaseControlServlet extends TrackerBaseServlet {

    MaintainableMgr unit = MaintainableMgr.getInstance();
    ItemCatsMgr itemCatsMgr = ItemCatsMgr.getInstance();
    CategoryMgr categoryMgr = CategoryMgr.getInstance();
    ExternalJobMgr externalJobMgr = ExternalJobMgr.getInstance();
    UnitScheduleByIssueMgr unitScheduleByIssueMgr = UnitScheduleByIssueMgr.getInstance();
    ItemMgr itemMgr = ItemMgr.getInstance();
    FailureCodeMgr failureCodeMgr = FailureCodeMgr.getInstance();
    ActualItemMgr actualItemMgr = ActualItemMgr.getInstance();
    QuantifiedMntenceMgr quantifiedMntenceMgr = QuantifiedMntenceMgr.getInstance();
    IssueStatusMgr issueStatusMgr = IssueStatusMgr.getInstance();
    IssueMgr issueMgr = IssueMgr.getInstance();
    ImageMgr imageMgr = ImageMgr.getInstance();
    InstMgr instMgr = InstMgr.getInstance();
    AttachedIssuesMgr attachedIssuesMgr = AttachedIssuesMgr.getInstance();
    DelayReasonsMgr delayReasonsMgr = DelayReasonsMgr.getInstance();
    IssueTasksComplaintMgr issueTasksComplaintMgr = IssueTasksComplaintMgr.getInstance();
    LaborComplaintsMgr laborComplaintsMgr = LaborComplaintsMgr.getInstance();
    
    UnitScheduleMgr unitScheduleMgr = UnitScheduleMgr.getInstance();
    AverageUnitMgr averageUnitMgr = AverageUnitMgr.getInstance();
    DataBaseControlMgr dataBaseControlMgr = DataBaseControlMgr.getInstance();
    ScheduleMgr scheduleMgr = ScheduleMgr.getInstance();
    TransactionMgr transactionMgr = TransactionMgr.getInstance();
    TransactionDetailsMgr transactionDetailsMgr = TransactionDetailsMgr.getInstance();
    WebBusinessObject wboTransaction = new WebBusinessObject();
    Vector transactionVec = new Vector();
    WebBusinessObject wboTransactionDetail = new WebBusinessObject();
    Vector transactionDetailVec = new Vector();
    ChangeDateHistoryMgr changeDateHistoryMgr = ChangeDateHistoryMgr.getInstance();
    WebBusinessObject wboChangeDate = new WebBusinessObject();
    Vector changeDateVec = new Vector();
    IssueTasksMgr issueTasksMgr = IssueTasksMgr.getInstance();
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
                servedPage = "/docs/schedule/del_All_Job_order.jsp";

                for (int i = 1; i < 13; i++) {
                    try {
                        dataBaseControlMgr.DelAllJobOrder(i);
                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                    }

                }
                request.setAttribute("Status", "Ok");
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);

                break;

            case 2:
                servedPage = "/docs/schedule/del_All_Configure.jsp";
                for (int i = 1; i < 9; i++) {
                    try {
//                        dataBaseControlMgr.DelScheduleConfigure(i);
                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                    }

                }

                request.setAttribute("Status", "Ok");
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);

                break;

            case 3:
                servedPage = "/docs/schedule/del_task_by_equip.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);

                break;

            case 4:
                String equipId = null;
                String equipName = null;
                String unitSchId = null;
                String issueId = null;
                String unitName = null;
                Vector unitSch = new Vector();
                WebBusinessObject unitWbo = new WebBusinessObject();
                //equipId = request.getParameter("unitId");
                equipId=issueMgr.getUnitId(request.getParameter("unitId"));
                servedPage = "/docs/schedule/del_task_by_equip.jsp";


                unitSch = dataBaseControlMgr.getAllUnitSheduleForEquip(equipId);
                unitName = unit.getUnitName(equipId);

                if (unitSch.size() == 0) {
                    request.setAttribute("Status", "NO");
                } else {
                    for (int i = 0; i < unitSch.size(); i++) {

                        unitWbo = (WebBusinessObject) unitSch.elementAt(i);
                        unitSchId = unitWbo.getAttribute("id").toString();

                        try {
                            issueId = dataBaseControlMgr.getAllUnitSheduleForIssue(unitSchId);
                            quantifiedMntenceMgr.deleteOnArbitraryKey(unitSchId, "key1");
                            imageMgr.deleteOnArbitraryKey(issueId, "key3");
                            issueStatusMgr.deleteOnArbitraryKey(issueId, "key2");
                            changeDateHistoryMgr.deleteOnArbitraryKey(issueId, "key2");
                            transactionVec = transactionMgr.getOnArbitraryKey(issueId, "key2");
                            if (transactionVec.size() > 0) {
                                wboTransaction = (WebBusinessObject) transactionVec.elementAt(0);
                                transactionDetailsMgr.deleteOnArbitraryKey(wboTransaction.getAttribute("transactionNO").toString(), "key2");
                                transactionMgr.deleteOnSingleKey(wboTransaction.getAttribute("id").toString());
                            }
                            issueTasksMgr.deleteOnArbitraryKey(issueId, "key1");
                            externalJobMgr.deleteOnArbitraryKey(issueId, "key2");
                            actualItemMgr.deleteOnArbitraryKey(unitSchId, "key1");
                            instMgr.deleteOnArbitraryKey(unitSchId, "key3");
                            attachedIssuesMgr.deleteOnArbitraryKey(issueId, "key1");
                            delayReasonsMgr.deleteOnArbitraryKey(issueId, "key1");
                            issueTasksComplaintMgr.deleteOnArbitraryKey(issueId, "key1");
                            laborComplaintsMgr.deleteOnArbitraryKey(issueId, "key1");
                            
                            issueMgr.deleteOnArbitraryKey(unitSchId, "key3");
                            unitScheduleMgr.deleteOnSingleKey(unitSchId);


                        } catch (SQLException ex) {
                            logger.error(ex.getMessage());
                        } catch (Exception ex) {
                            logger.error(ex.getMessage());
                        }

                    }
                    request.setAttribute("Status", "Ok");
                }

                request.setAttribute("unitName", unitName);
                request.setAttribute("page", servedPage);

                this.forwardToServedPage(request, response);

                break;

            case 5:
                servedPage = "/docs/schedule/del_All_Emg_Job_order.jsp";

                String docIssueId = null;
                issueId = null;
                Vector DocIssue = new Vector();
                Vector QuanMain = new Vector();
                WebBusinessObject QuanWbo = new WebBusinessObject();
                WebBusinessObject IssueWbo = new WebBusinessObject();

                QuanMain = dataBaseControlMgr.getUnitSchEmg();
                for (int i = 0; i < QuanMain.size(); i++) {

                    QuanWbo = (WebBusinessObject) QuanMain.elementAt(i);
                    issueId = QuanWbo.getAttribute("id").toString();
                    unitSchId = dataBaseControlMgr.getUnitSheduleForIssueId(issueId);

                    try {
                        if (dataBaseControlMgr.getActiveQuan(unitSchId)) {
                            dataBaseControlMgr.DelQuanEmg(unitSchId);
                        }

                    } catch (SQLException ex) {
                        logger.error(ex.getMessage());
                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                    }
                    try {
                        imageMgr.deleteOnArbitraryKey(issueId, "key3");

                    } catch (SQLException ex) {
                        logger.error(ex.getMessage());
                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                    }

                    try {
                        dataBaseControlMgr.DelStatusEmg(issueId);
                        changeDateHistoryMgr.deleteOnArbitraryKey(issueId, "key2");

                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                    }

                    try {
                        transactionVec = transactionMgr.getOnArbitraryKey(issueId, "key2");
                    } catch (SQLException ex) {
                        logger.error(ex.getMessage());
                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                    }
                    if (transactionVec.size() > 0) {
                        wboTransaction = (WebBusinessObject) transactionVec.elementAt(0);
                        try {
                            transactionDetailsMgr.deleteOnArbitraryKey(wboTransaction.getAttribute("transactionNO").toString(), "key2");
                        } catch (SQLException ex) {
                            logger.error(ex.getMessage());
                        } catch (Exception ex) {
                            logger.error(ex.getMessage());
                        }
                        transactionMgr.deleteOnSingleKey(wboTransaction.getAttribute("id").toString());
                    }
                    try {

                        issueTasksMgr.deleteOnArbitraryKey(issueId, "key1");
                        externalJobMgr.deleteOnArbitraryKey(issueId, "key2");
                        instMgr.deleteOnArbitraryKey(unitSchId, "key3");
                        attachedIssuesMgr.deleteOnArbitraryKey(issueId, "key1");
                        delayReasonsMgr.deleteOnArbitraryKey(issueId, "key1");
                        issueTasksComplaintMgr.deleteOnArbitraryKey(issueId, "key1");
                        laborComplaintsMgr.deleteOnArbitraryKey(issueId, "key1");
                    } catch (SQLException ex) {
                        logger.error(ex.getMessage());
                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                    }


                    try {

                        if (dataBaseControlMgr.getActiveAcut(unitSchId)) {
                            dataBaseControlMgr.DelAcualEmg(unitSchId);

                        }
                    } catch (SQLException ex) {
                        logger.error(ex.getMessage());
                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                    }





                    try {
                        issueMgr.deleteOnArbitraryKey(unitSchId, "key3");
                        unitScheduleMgr.deleteOnSingleKey(unitSchId);
                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                    }


                }


//               
                request.setAttribute("Status", "Ok");
                request.setAttribute("page", servedPage);

                this.forwardToServedPage(request, response);

                break;

            case 6:
                servedPage = "/docs/schedule/del_All_Exr_Job_order.jsp";

                QuanMain = dataBaseControlMgr.getUnitSchExr();
                for (int i = 0; i < QuanMain.size(); i++) {

                    QuanWbo = (WebBusinessObject) QuanMain.elementAt(i);
                    issueId = QuanWbo.getAttribute("id").toString();
                    unitSchId = dataBaseControlMgr.getUnitSheduleForIssueId(issueId);

                    try {
                        if (dataBaseControlMgr.getActiveQuan(unitSchId)) {
                            dataBaseControlMgr.DelQuanEmg(unitSchId);
                        }

                    } catch (SQLException ex) {
                        logger.error(ex.getMessage());
                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                    }
                    try {

                        if (dataBaseControlMgr.getActiveAcut(unitSchId)) {
                            dataBaseControlMgr.DelAcualEmg(unitSchId);
                        }

                    } catch (SQLException ex) {
                        logger.error(ex.getMessage());
                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                    }

                    try {

                        imageMgr.deleteOnArbitraryKey(issueId, "key3");

                    } catch (SQLException ex) {
                        logger.error(ex.getMessage());
                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                    }

                    try {
                        dataBaseControlMgr.DelStatusEmg(issueId);


                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                    }

                    try {
                        dataBaseControlMgr.DelExternalJob(issueId);
                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                    }

                    try {
                        dataBaseControlMgr.DelIssueEmg(issueId);
                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                    }

                    
                    try {

                        issueTasksMgr.deleteOnArbitraryKey(issueId, "key1");
                        externalJobMgr.deleteOnArbitraryKey(issueId, "key2");
                        instMgr.deleteOnArbitraryKey(unitSchId, "key3");
                        attachedIssuesMgr.deleteOnArbitraryKey(issueId, "key1");
                        delayReasonsMgr.deleteOnArbitraryKey(issueId, "key1");
                        issueTasksComplaintMgr.deleteOnArbitraryKey(issueId, "key1");
                        laborComplaintsMgr.deleteOnArbitraryKey(issueId, "key1");
                    } catch (SQLException ex) {
                        logger.error(ex.getMessage());
                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                    }
                    
                    
                    try {
                        dataBaseControlMgr.DelUnitSchEmg(unitSchId);
                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                    }
                }


//                try {
//                    dataBaseControlMgr.DelStatusExr();
//                    
//                   
//                } catch (Exception ex) {

//                }
//
//                try {
//                    dataBaseControlMgr.DelIssueExr();
//                } catch (Exception ex) {

//                }
//
//                try {
//                    dataBaseControlMgr.DelUnitSchExr();
//                } catch (Exception ex) {

//                }

//               
                request.setAttribute("Status", "Ok");
                request.setAttribute("page", servedPage);

                this.forwardToServedPage(request, response);

                break;

            case 7:
                servedPage = "/docs/schedule/del_All_UnUsed_Task.jsp";

                QuanMain = dataBaseControlMgr.getUnitSchforUnAssign();

                if (QuanMain.size() == 0) {
                    request.setAttribute("Status", "none");
                } else {


                    for (int i = 0; i < QuanMain.size(); i++) {

                        QuanWbo = (WebBusinessObject) QuanMain.elementAt(i);
                        issueId = QuanWbo.getAttribute("id").toString();
                        unitSchId = dataBaseControlMgr.getUnitSheduleForIssueId(issueId);


                        try {
                            if (dataBaseControlMgr.getActiveQuan(unitSchId)) {
                                dataBaseControlMgr.DelQuanEmg(unitSchId);
                            }
                        } catch (Exception ex) {
                            logger.error(ex.getMessage());
                        }



                        try {

                            if (dataBaseControlMgr.getActiveDocIssue(issueId)) {
                                dataBaseControlMgr.DelDocEmg(issueId);

                            }

                        } catch (SQLException ex) {
                            logger.error(ex.getMessage());
                        } catch (Exception ex) {
                            logger.error(ex.getMessage());
                        }


                        try {

                            if (dataBaseControlMgr.getActiveIssuestatus(issueId)) {
                                dataBaseControlMgr.DelStatusUnAssignSch(issueId);
                            }

                        } catch (SQLException ex) {
                            logger.error(ex.getMessage());
                        } catch (Exception ex) {
                            logger.error(ex.getMessage());
                        }
                        try {

                            if (dataBaseControlMgr.getActiveIssue(issueId)) {
                                dataBaseControlMgr.DelIssueUnAssignSch(issueId);
                            }

                        } catch (SQLException ex) {
                            logger.error(ex.getMessage());
                        } catch (Exception ex) {
                            logger.error(ex.getMessage());
                        }
                        try {

                            if (dataBaseControlMgr.getActiveUnitSchedule(unitSchId)) {
                                dataBaseControlMgr.DelUnitSchIdforUnAssign(unitSchId);
                            }

                        } catch (SQLException ex) {
                            logger.error(ex.getMessage());
                        } catch (Exception ex) {
                            logger.error(ex.getMessage());
                        }
                        request.setAttribute("Status", "Ok");
                    }
                }


                request.setAttribute("page", servedPage);

                this.forwardToServedPage(request, response);

                break;

            case 8:
                servedPage = "/docs/schedule/del_EmgTask_by_equip.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);

                break;

            case 9:

                //equipId = request.getParameter("unitId");
               equipId=issueMgr.getUnitId(request.getParameter("unitId")); 
                servedPage = "/docs/schedule/del_EmgTask_by_equip.jsp";


                unitSch = unitScheduleByIssueMgr.getEmgUnitSheduleForEquip(equipId);
                unitName = unit.getUnitName(equipId);

                if (unitSch.size() == 0) {
                    request.setAttribute("Status", "NO");
                } else {
                    for (int i = 0; i < unitSch.size(); i++) {

                        unitWbo = (WebBusinessObject) unitSch.elementAt(i);
                        unitSchId = unitWbo.getAttribute("unitScheduleId").toString();

                        try {
                            actualItemMgr.deleteOnArbitraryKey(unitSchId, "key1");
                            quantifiedMntenceMgr.deleteOnArbitraryKey(unitSchId, "key1");
                            instMgr.deleteOnArbitraryKey(unitSchId, "key3");
                            issueId = dataBaseControlMgr.getAllUnitSheduleForEmgIssue(unitSchId);
                            imageMgr.deleteOnArbitraryKey(issueId, "key3");
                            issueTasksMgr.deleteOnArbitraryKey(issueId, "key1");
                            externalJobMgr.deleteOnArbitraryKey(issueId, "key2");
                            instMgr.deleteOnArbitraryKey(unitSchId, "key3");
                            attachedIssuesMgr.deleteOnArbitraryKey(issueId, "key1");
                            delayReasonsMgr.deleteOnArbitraryKey(issueId, "key1");
                            issueTasksComplaintMgr.deleteOnArbitraryKey(issueId, "key1");
                            laborComplaintsMgr.deleteOnArbitraryKey(issueId, "key1");
                            issueStatusMgr.deleteOnArbitraryKey(issueId, "key2");
                            issueMgr.deleteOnArbitraryKey(unitSchId, "key3");
                            unitScheduleMgr.deleteOnSingleKey(unitSchId);
//                        averageUnitMgr.deleteOnArbitraryKey(equipId,"key1");


                        } catch (SQLException ex) {
                            logger.error(ex.getMessage());
                        } catch (Exception ex) {
                            logger.error(ex.getMessage());
                        }

                    }

                    request.setAttribute("Status", "Ok");
                }

                request.setAttribute("unitName", unitName);
                request.setAttribute("page", servedPage);

                this.forwardToServedPage(request, response);

                break;

            case 10:
                servedPage = "/docs/schedule/del_ExrTask_by_equip.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);

                break;

            case 11:

                //equipId = request.getParameter("unitId");
                equipId=issueMgr.getUnitId(request.getParameter("unitId"));
                servedPage = "/docs/schedule/del_ExrTask_by_equip.jsp";


                unitSch = unitScheduleByIssueMgr.getExrUnitSheduleForEquip(equipId);
                unitName = unit.getUnitName(equipId);

                if (unitSch.size() == 0) {
                    request.setAttribute("Status", "NO");
                } else {
                    for (int i = 0; i < unitSch.size(); i++) {

                        unitWbo = (WebBusinessObject) unitSch.elementAt(i);
                        unitSchId = unitWbo.getAttribute("unitScheduleId").toString();

                        try {
                            actualItemMgr.deleteOnArbitraryKey(unitSchId, "key1");
                            quantifiedMntenceMgr.deleteOnArbitraryKey(unitSchId, "key1");
                            instMgr.deleteOnArbitraryKey(unitSchId, "key3");
                            issueId = dataBaseControlMgr.getAllUnitSheduleForExrIssue(unitSchId);
                            imageMgr.deleteOnArbitraryKey(issueId, "key3");
                            externalJobMgr.deleteOnArbitraryKey(issueId, "key2");
                            issueTasksMgr.deleteOnArbitraryKey(issueId, "key1");
                            attachedIssuesMgr.deleteOnArbitraryKey(issueId, "key1");
                            delayReasonsMgr.deleteOnArbitraryKey(issueId, "key1");
                            issueTasksComplaintMgr.deleteOnArbitraryKey(issueId, "key1");
                            laborComplaintsMgr.deleteOnArbitraryKey(issueId, "key1");
                            issueStatusMgr.deleteOnArbitraryKey(issueId, "key2");
                            issueMgr.deleteOnArbitraryKey(unitSchId, "key3");
                            unitScheduleMgr.deleteOnSingleKey(unitSchId);
//                        averageUnitMgr.deleteOnArbitraryKey(equipId,"key1");


                        } catch (SQLException ex) {
                            logger.error(ex.getMessage());
                        } catch (Exception ex) {
                            logger.error(ex.getMessage());
                        }

                    }
                    request.setAttribute("Status", "Ok");
                }

                request.setAttribute("unitName", unitName);
                request.setAttribute("page", servedPage);

                this.forwardToServedPage(request, response);

                break;

            case 12:
                servedPage = "/docs/schedule/del_All_Job_order.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);

                break;

            case 13:
                servedPage = "/docs/schedule/del_All_Emg_Job_order.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);

                break;

            case 14:
                servedPage = "/docs/schedule/del_All_Exr_Job_order.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);

                break;

            case 15:
                servedPage = "/docs/schedule/del_All_UnUsed_Task.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);

                break;

            case 16:
                servedPage = "/docs/schedule/del_Unused_Task_by_equip.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);

                break;

            case 17:

               // equipId = request.getParameter("unitId");
                equipId=issueMgr.getUnitId(request.getParameter("unitId"));
                unitName = request.getParameter("unitId");
                unitSch = dataBaseControlMgr.getEmgUnitSheduleForEquip(equipId);
                servedPage = "/docs/schedule/del_Unused_Task_by_equip.jsp";

                QuanMain = dataBaseControlMgr.getUnitSchforUnAssign();
                if (QuanMain.size() == 0) {
                    request.setAttribute("Status", "none");
                } else {
                    for (int i = 0; i < QuanMain.size(); i++) {

                        QuanWbo = (WebBusinessObject) QuanMain.elementAt(i);
                        issueId = QuanWbo.getAttribute("id").toString();
                        unitSchId = dataBaseControlMgr.getUnitSheduleForIssueId(issueId);
                        try {
                            if (dataBaseControlMgr.GetUnAssignSchId(unitSchId, equipId)) {
                                request.setAttribute("Status", "NO");
                            } else {

                                try {
                                    if (dataBaseControlMgr.getActiveQuan(unitSchId)) {
                                        dataBaseControlMgr.DelQuanEmg(unitSchId);
                                    }
                                } catch (Exception ex) {
                                    logger.error(ex.getMessage());
                                }



                                try {

                                    if (dataBaseControlMgr.getActiveDocIssue(issueId)) {
                                        dataBaseControlMgr.DelDocEmg(issueId);

                                    }

                                } catch (SQLException ex) {
                                    logger.error(ex.getMessage());
                                } catch (Exception ex) {
                                    logger.error(ex.getMessage());
                                }


                                try {

                                    if (dataBaseControlMgr.getActiveIssuestatus(issueId)) {
                                        dataBaseControlMgr.DelStatusUnAssignSch(issueId);
                                    }

                                } catch (SQLException ex) {
                                    logger.error(ex.getMessage());
                                } catch (Exception ex) {
                                    logger.error(ex.getMessage());
                                }
                                try {

                                    if (dataBaseControlMgr.getActiveIssue(issueId)) {
                                        dataBaseControlMgr.DelIssueUnAssignSch(issueId);
                                    }

                                } catch (SQLException ex) {
                                    logger.error(ex.getMessage());
                                } catch (Exception ex) {
                                    logger.error(ex.getMessage());
                                }
                                try {

                                    if (dataBaseControlMgr.getActiveUnitSchedule(unitSchId)) {
                                        dataBaseControlMgr.DelUnitSchIdforUnAssign(unitSchId);
                                    }

                                } catch (SQLException ex) {
                                    logger.error(ex.getMessage());
                                } catch (Exception ex) {
                                    logger.error(ex.getMessage());
                                }
                                request.setAttribute("Status", "Ok");
                            }
                        } catch (Exception ex) {
                            logger.error(ex.getMessage());
                        }

                    }
                }

                request.setAttribute("unitName", unitName);
                request.setAttribute("page", servedPage);

                this.forwardToServedPage(request, response);

                break;

            case 18:
                servedPage = "/docs/schedule/del_All_Configure.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 19:
                servedPage = "/docs/schedule/Separate_Schedule_from_equip.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);

                break;

            case 20:
                String taskId = null;
                String taskName = null;
//                String issueId=null;
//                String unitName = null;
//                Vector unitSch =new Vector();
//                WebBusinessObject unitWbo = new WebBusinessObject();
                taskId = request.getParameter("taskId");
               // equipId = request.getParameter("unitId");
                equipId=issueMgr.getUnitId(request.getParameter("unitId"));
                servedPage = "/docs/schedule/Separate_Schedule_from_equip.jsp";


                unitSch = dataBaseControlMgr.getUnitSheduleForEquipAndTask(equipId, taskId);
                unitName = unit.getUnitName(equipId);
                taskName = scheduleMgr.getTaskName(taskId);

                if (unitSch.size() == 0) {
                    request.setAttribute("Status", "NO");
                } else {
                    for (int i = 0; i < unitSch.size(); i++) {

                        unitWbo = (WebBusinessObject) unitSch.elementAt(i);
                        unitSchId = unitWbo.getAttribute("id").toString();

                        try {
                            issueId = dataBaseControlMgr.getAllUnitSheduleForIssue(unitSchId);
                            quantifiedMntenceMgr.deleteOnArbitraryKey(unitSchId, "key1");
                            imageMgr.deleteOnArbitraryKey(issueId, "key3");
                            issueStatusMgr.deleteOnArbitraryKey(issueId, "key2");
                            changeDateHistoryMgr.deleteOnArbitraryKey(issueId, "key2");
                            transactionVec = transactionMgr.getOnArbitraryKey(issueId, "key2");
                            if (transactionVec.size() > 0) {
                                wboTransaction = (WebBusinessObject) transactionVec.elementAt(0);
                                transactionDetailsMgr.deleteOnArbitraryKey(wboTransaction.getAttribute("transactionNO").toString(), "key2");
                                transactionMgr.deleteOnSingleKey(wboTransaction.getAttribute("id").toString());
                            }
                            issueTasksMgr.deleteOnArbitraryKey(issueId, "key1");
                            externalJobMgr.deleteOnArbitraryKey(issueId, "key2");
                            actualItemMgr.deleteOnArbitraryKey(unitSchId, "key1");
                            instMgr.deleteOnArbitraryKey(unitSchId, "key3");
                            attachedIssuesMgr.deleteOnArbitraryKey(issueId, "key1");
                            delayReasonsMgr.deleteOnArbitraryKey(issueId, "key1");
                            issueTasksComplaintMgr.deleteOnArbitraryKey(issueId, "key1");
                            laborComplaintsMgr.deleteOnArbitraryKey(issueId, "key1");
                            
                            issueMgr.deleteOnArbitraryKey(unitSchId, "key3");
                            unitScheduleMgr.deleteOnSingleKey(unitSchId);



                        } catch (SQLException ex) {
                            logger.error(ex.getMessage());
                        } catch (Exception ex) {
                            logger.error(ex.getMessage());
                        }

                    }
                    request.setAttribute("Status", "Ok");
                }

                request.setAttribute("taskName", taskName);
                request.setAttribute("equipName", unitName);
                request.setAttribute("page", servedPage);

                this.forwardToServedPage(request, response);

                break;

             case 21:
                equipName= request.getParameter("unitId");
                servedPage = "/docs/schedule/Separate_Schedule_from_equip.jsp";
                request.setAttribute("equipName", equipName);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);

                break;
            case 22:
                servedPage = "/docs/Adminstration/update_price.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 23:
                ItemsMgr itemsMgr = ItemsMgr.getInstance();
                WebBusinessObject wboQuantified,wboItem;
                Vector quantified = quantifiedMntenceMgr.getAllQuantified();

                String stPrice,itemId,quantifiedId;
                float price;
                int counterTrue = 0,counterFalse = 0;
                Vector falseIds = new Vector();

                for (int i = 0; i < quantified.size(); i++) {
                        try{
                        price = 0;
                        wboQuantified = (WebBusinessObject) quantified.get(i);
                        quantifiedId =(String) wboQuantified.getAttribute("id");
                        itemId = (String) wboQuantified.getAttribute("itemId");

                        wboItem = itemsMgr.getOnSingleKey(itemId);
                        if(wboItem != null){
                            counterTrue++;
                            stPrice = (String) wboItem.getAttribute("itemLastPrice");
                            if(stPrice != null && !stPrice.equals(""))
                                price = new Float(stPrice).floatValue();

                            quantifiedMntenceMgr.updatePrice(price, quantifiedId);
                        }else{
                            counterFalse++;
                            falseIds.addElement(itemId);
                        }
                        }catch(Exception ex){
                        System.out.println(ex.getMessage());
                    }
                }
                servedPage = "/docs/Adminstration/update_price.jsp";
                request.setAttribute("page", servedPage);
                request.setAttribute("message", "Update Completed Click Secondly...");
                this.forwardToServedPage(request, response);
                break;
            case 24:
                ConfigureMainTypeMgr configureMainTypeMgr = ConfigureMainTypeMgr.getInstance();
                itemsMgr = ItemsMgr.getInstance();
                WebBusinessObject wboConfig;
                Vector config = configureMainTypeMgr.getAllConfigureMainType();
                 counterTrue = 0;
                 counterFalse = 0;
                 falseIds = new Vector();

                for (int i = 0; i < config.size(); i++) {
                        try{
                        price = 0;
                        wboConfig = (WebBusinessObject) config.get(i);
                        quantifiedId =(String) wboConfig.getAttribute("id");
                        itemId = (String) wboConfig.getAttribute("itemId");

                        wboItem = itemsMgr.getOnSingleKey(itemId);
                        if(wboItem != null){
                            counterTrue++;
                            stPrice = (String) wboItem.getAttribute("itemLastPrice");
                            if(stPrice != null && !stPrice.equals(""))
                                price = new Float(stPrice).floatValue();

                            configureMainTypeMgr.updatePrice(price, quantifiedId);
                        }else{
                            counterFalse++;
                            falseIds.addElement(itemId);
                        }
                        }catch(Exception ex){
                        System.out.println(ex.getMessage());
                    }
                }
                servedPage = "/docs/Adminstration/update_price.jsp";
                request.setAttribute("page", servedPage);
                request.setAttribute("message", "Update Completed Finish...");
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


        if (opName.equals("DelAllJobOrder")) {
            return 1;
        }

        if (opName.equals("DelAllTask")) {
            return 2;
        }

        if (opName.equals("GetDelJoborderForEquip")) {
            return 3;
        }
        if (opName.equals("DelJoborderForEquip")) {
            return 4;
        }
        if (opName.equals("DelEmgJobOrder")) {
            return 5;
        }
        if (opName.equals("DelExrJobOrder")) {
            return 6;
        }
        if (opName.equals("DelUnAssignJobOrder")) {
            return 7;
        }
        if (opName.equals("GetDelEmgForEquip")) {
            return 8;
        }
        if (opName.equals("DelEmgForEquip")) {
            return 9;
        }
        if (opName.equals("GetDelExrForEquip")) {
            return 10;
        }
        if (opName.equals("DelExrForEquip")) {
            return 11;
        }
        if (opName.equals("GetDelAllJobOrder")) {
            return 12;
        }
        if (opName.equals("GetDelEmgJobOrder")) {
            return 13;
        }
        if (opName.equals("GetDelExrJobOrder")) {
            return 14;
        }
        if (opName.equals("GetDelUnAssignJobOrder")) {
            return 15;
        }
        if (opName.equals("GetDelUnAssignJobOrderforEquip")) {
            return 16;
        }
        if (opName.equals("DelUnAssignJobOrderforEquip")) {
            return 17;
        }
        if (opName.equals("GetDelAllTask")) {
            return 18;
        }
        if (opName.equals("GetSeparteSchForEquip")) {
            return 19;
        }
        if (opName.equals("SeparteSchForEquip")) {
            return 20;
        }
         if (opName.equals("RefreshSeparteSchForEquip")) {
            return 21;
        }
        if (opName.equals("updatePrice")) {
            return 22;
        }
        if (opName.equals("updateQuantifiedPrice")) {
            return 23;
        }
        if (opName.equals("updateConfigPrice")) {
            return 24;
        }
        
        return 0;
    }
}

