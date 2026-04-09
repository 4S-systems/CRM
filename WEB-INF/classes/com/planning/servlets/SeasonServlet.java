/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.planning.servlets;

import com.clients.db_access.ClientMgr;
import com.clients.db_access.ClientSeasonsMgr;
import com.maintenance.common.Tools;
import com.maintenance.db_access.UnitDocMgr;
import com.planning.db_access.RecordSeasonMgr;
import com.planning.db_access.SeasonMgr;
import com.planning.db_access.SeasonPlanMgr;
import com.silkworm.Exceptions.NoUserInSessionException;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.pagination.Filter;
import com.silkworm.pagination.FilterCondition;
import com.silkworm.pagination.Operations;
import com.tracker.db_access.CampaignMgr;
import com.tracker.db_access.ClientIncentiveMgr;
import com.tracker.db_access.IncentiveMgr;
import com.tracker.servlets.IncentiveServlet;
import com.tracker.servlets.ProjectServlet;
import com.tracker.servlets.TrackerBaseServlet;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.text.DateFormatSymbols;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
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
//@WebServlet(name = "SeasonServlet", urlPatterns = {"/SeasonServlet"})
public class SeasonServlet extends TrackerBaseServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        super.processRequest(request, response);
        HttpSession session = request.getSession();
        WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        SeasonMgr seasonMgr = SeasonMgr.getInstance();
        SeasonPlanMgr seasonPlanMgr = SeasonPlanMgr.getInstance();
        RecordSeasonMgr recordSeasonMgr = RecordSeasonMgr.getInstance();
        switch (operation) {
            case 1:
                servedPage = "/docs/Adminstration/new_Season.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 2:
                if (seasonMgr.saveSeason(request, session)) {
                    request.setAttribute("Status", "OK");
                } else {
                    request.setAttribute("Status", "NO");
                }
                servedPage = "/docs/Adminstration/new_Season.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 3:
                ArrayList getCodes = seasonMgr.getAllSeasonCodes();

                servedPage = "/docs/Adminstration/record_Season.jsp";
                request.setAttribute("allCodes", getCodes);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 4:
                String code = request.getParameter("code");

                ArrayList getCode = new ArrayList();
                WebBusinessObject Wbo = null;
                Wbo = seasonMgr.getOnSingleKey("key1", code);
                getCode.add(Wbo);
                servedPage = "/docs/Adminstration/Ajax_Code.jsp";
                request.setAttribute("code", getCode);
                request.setAttribute("page", servedPage);
                this.forward(servedPage, request, response);
                break;
            case 5:
                ArrayList getCodeS = seasonMgr.getAllSeasonCodes();
                if (recordSeasonMgr.recordSeason(request, session)) {
                    request.setAttribute("Status", "OK");
                } else {
                    request.setAttribute("Status", "NO");
                }
                servedPage = "/docs/Adminstration/record_Season.jsp";
                request.setAttribute("allCodes", getCodeS);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 6:
                servedPage = "/docs/Adminstration/Seasons_List.jsp";
                seasonMgr = SeasonMgr.getInstance();
                Vector seaVector = new Vector();
                seaVector = seasonMgr.getCashedTable();
                request.setAttribute("seaVector", seaVector);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 7:
                String seasonTypeId = request.getParameter("seasonTypeId");
                WebBusinessObject wboSeason = new WebBusinessObject();
                seasonMgr = SeasonMgr.getInstance();

                wboSeason = seasonMgr.getOnSingleKey(seasonTypeId);
                servedPage = "/docs/Adminstration/View_Season_Type.jsp";
                request.setAttribute("wboSeason", wboSeason);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 8:
                seasonTypeId = request.getParameter("seasonTypeId");
                wboSeason = new WebBusinessObject();
                seasonMgr = SeasonMgr.getInstance();

                wboSeason = seasonMgr.getOnSingleKey(seasonTypeId);
                servedPage = "/docs/Adminstration/Update_Season_Type.jsp";
                request.setAttribute("wboSeason", wboSeason);
                request.setAttribute("page", servedPage);

                this.forwardToServedPage(request, response);
                break;
            case 9:
                if (seasonMgr.updateSeason(request)) {
                    request.setAttribute("Status", "OK");
                } else {
                    request.setAttribute("Status", "NO");
                }
                wboSeason = new WebBusinessObject();
                seasonMgr = SeasonMgr.getInstance();
                seasonTypeId = request.getParameter("seasonTypeId");
                wboSeason = seasonMgr.getOnSingleKey(seasonTypeId);
                servedPage = "/docs/Adminstration/Update_Season_Type.jsp";
                request.setAttribute("wboSeason", wboSeason);
                request.setAttribute("page", servedPage);

                this.forwardToServedPage(request, response);
                break;
            case 10:
                seasonTypeId = request.getParameter("seasonTypeId");
                wboSeason = new WebBusinessObject();
                seasonMgr = SeasonMgr.getInstance();

                wboSeason = seasonMgr.getOnSingleKey(seasonTypeId);
                servedPage = "/docs/Adminstration/Confirm_Delete_Season_Type.jsp";
                request.setAttribute("wboSeason", wboSeason);
                request.setAttribute("totalClientNo", seasonMgr.getSeasonTotalClientsNo(seasonTypeId));
                request.setAttribute("page", servedPage);

                this.forwardToServedPage(request, response);
                break;
            case 11:
                seasonTypeId = request.getParameter("seasonTypeId");
                if (ClientMgr.getInstance().updateClientKnownUs(request.getParameter("seasonTypeId"), "UL")) {
                    seasonMgr.deleteOnSingleKey(seasonTypeId);
                }
                this.forward("SeasonServlet?op=listSeasons", request, response);
                break;
            case 12:
                servedPage = "/docs/Adminstration/Record_Seasons_List.jsp";
                recordSeasonMgr = RecordSeasonMgr.getInstance();
                seaVector = new Vector();
                seaVector = recordSeasonMgr.getCashedTable();
                request.setAttribute("seaVector", seaVector);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 13:
                seasonTypeId = request.getParameter("seasonTypeId");
                wboSeason = new WebBusinessObject();
                recordSeasonMgr = RecordSeasonMgr.getInstance();

                wboSeason = recordSeasonMgr.getOnSingleKey(seasonTypeId);
                servedPage = "/docs/Adminstration/View_Record_Season.jsp";
                request.setAttribute("wboSeason", wboSeason);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 14:
                seasonTypeId = request.getParameter("seasonTypeId");
                wboSeason = new WebBusinessObject();
                recordSeasonMgr = RecordSeasonMgr.getInstance();
                wboSeason = recordSeasonMgr.getOnSingleKey(seasonTypeId);
                request.setAttribute("wboSeason", wboSeason);
                 try {
                        request.setAttribute("seasonsList", new ArrayList<>(seasonMgr.getOnArbitraryKeyOracle("1", "key2")));
                    } catch (Exception ex) {
                        request.setAttribute("seasonsList", new ArrayList<>());
                    }
                servedPage = "/docs/Adminstration/Update_Record_Season.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 15:
                seasonTypeId = request.getParameter("id");
                String ChanelID=request.getParameter("ChanelID");
                WebBusinessObject chWbo=seasonMgr.getOnSingleKey("key", ChanelID);
                String chCode=(String)chWbo.getAttribute("type_code");
                request.setAttribute("chCode", chCode);
                recordSeasonMgr = RecordSeasonMgr.getInstance();
                if (recordSeasonMgr.updateRecordSeason(request)) {
                    request.setAttribute("Status", "OK");
                } else {
                    request.setAttribute("Status", "NO");
                }
                try {
                        request.setAttribute("seasonsList", new ArrayList<>(seasonMgr.getOnArbitraryKeyOracle("1", "key2")));
                    } catch (Exception ex) {
                        request.setAttribute("seasonsList", new ArrayList<>());
                    }
                wboSeason = recordSeasonMgr.getOnSingleKey(seasonTypeId);
                request.setAttribute("wboSeason", wboSeason);
                servedPage = "/docs/Adminstration/Update_Record_Season.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 16:
                seasonTypeId = request.getParameter("seasonTypeId");
                wboSeason = new WebBusinessObject();
                recordSeasonMgr = RecordSeasonMgr.getInstance();

                wboSeason = recordSeasonMgr.getOnSingleKey(seasonTypeId);
                servedPage = "/docs/Adminstration/Confirm_Delete_Record_Season.jsp";
                request.setAttribute("wboSeason", wboSeason);
                request.setAttribute("page", servedPage);

                this.forwardToServedPage(request, response);
                break;
            case 17:
                seasonTypeId = request.getParameter("seasonTypeId");
                recordSeasonMgr = RecordSeasonMgr.getInstance();
                recordSeasonMgr.deleteOnSingleKey(seasonTypeId);
                this.forward("SeasonServlet?op=listRecordSeasons", request, response);
                break;

            case 18:
                servedPage = "/docs/Adminstration/season_list.jsp";
                Filter filter = new com.silkworm.pagination.Filter();
                String selectionType = request.getParameter("selectionType");
                filter = Tools.getPaginationInfo(request, response);
                String formName = null;
                String attachedSeasonIds = null;
                String planId = request.getParameter("planId");
                List conditions = new ArrayList<FilterCondition>();
                List<WebBusinessObject> seasonList = new ArrayList<WebBusinessObject>(0);

                // add conditions
                try {
                    attachedSeasonIds = seasonPlanMgr.getAttachedSeasons(planId);

                    if (!attachedSeasonIds.equals("")) {
                        conditions.add(new FilterCondition("ID", attachedSeasonIds, Operations.NOTIN));

                    } else {
                        conditions.add(new FilterCondition("ID", "NULL", Operations.NOT_EQUAL));

                    }
                } catch (Exception e) {
                    System.out.println(e.getMessage());
                }

                filter.setConditions(conditions);

                try {
                    seasonList = recordSeasonMgr.paginationEntity(filter);

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
                request.setAttribute("seasonList", seasonList);
                this.forward(servedPage, request, response);
                break;

            case 19:
                servedPage = "/docs/Adminstration/plan_attachments.jsp";
                String seasonId = request.getParameter("seasonTypeId");
                Vector attachedPlanVec = seasonPlanMgr.getAttachedPlans(seasonId);
                request.setAttribute("planVec", attachedPlanVec);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 20:
                servedPage = "/docs/Adminstration/show_season_list2.jsp";
                try {
                    request.setAttribute("page", servedPage);
                    CampaignMgr campaignMgr = CampaignMgr.getInstance();
                    ArrayList<WebBusinessObject> campaignsList = new ArrayList<WebBusinessObject>(campaignMgr.getCashedTable());
                    HashMap<String, ArrayList> campaignToolsList = new HashMap<String, ArrayList>();
                    recordSeasonMgr = RecordSeasonMgr.getInstance();
                    for (int i = campaignsList.size() - 1; i >= 0; i--) {
                        WebBusinessObject campaignTemp = campaignsList.get(i);
                        String currentStatus = (String) campaignTemp.getAttribute("currentStatus");
                        if (!currentStatus.equalsIgnoreCase("20") && !currentStatus.equalsIgnoreCase("16")) {
                            campaignsList.remove(campaignTemp);
                        } else if (!currentStatus.equalsIgnoreCase("20")) {
                            campaignToolsList.put((String) campaignTemp.getAttribute("id"),
                                    recordSeasonMgr.getToolsForCampaign((String) campaignTemp.getAttribute("id")));
                        }
                    }
                    request.setAttribute("seasons", campaignsList);
                } catch (Exception ex) {
                    Logger.getLogger(ProjectServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                this.forward(servedPage, request, response);
                break;
            case 21:

                WebBusinessObject wbo = new WebBusinessObject();
                String userId = (String) loggedUser.getAttribute("userId");
                String clientId = request.getParameter("clientId");
                String seasonID = request.getParameter("seasonId");

                String seasonName = request.getParameter("seasonName");
                String seasonNotes = request.getParameter("seasonNotes");

                request.setAttribute("seasonId", seasonID);
                request.setAttribute("seasonName", seasonName);
                request.setAttribute("seasonNotes", seasonNotes);
                request.setAttribute("clientId", clientId);
                request.setAttribute("userId", userId);

                ClientSeasonsMgr clientSeasonsMgr = ClientSeasonsMgr.getInstance();
                try {

                    if (clientSeasonsMgr.saveClientSeasons(request, session)) {
                        wbo.setAttribute("status", "Ok");

                    } else {
                        wbo.setAttribute("status", "No");

                    }
                } catch (NoUserInSessionException ex) {
                    Logger.getLogger(SeasonServlet.class.getName()).log(Level.SEVERE, null, ex);
                } catch (SQLException ex) {
                    Logger.getLogger(SeasonServlet.class.getName()).log(Level.SEVERE, null, ex);
                }



                out.write(Tools.getJSONObjectAsString(wbo));
                break;
            case 22:
                out = response.getWriter();
                wbo = new WebBusinessObject();
                code = request.getParameter("code");
                WebBusinessObject data = new WebBusinessObject();
                seasonMgr = SeasonMgr.getInstance();
                wbo = seasonMgr.getOnSingleKey("key1", code);
                if (wbo != null) {
                    data.setAttribute("status", "Ok");

                } else {
                    data.setAttribute("status", "error");
                }

                out.write(Tools.getJSONObjectAsString(data));
                break;
                // FOR TEST PERPOSE -- COMING FROM IncentiveServlet
            case 23:
                servedPage = "/docs/incentive/show_incentive_list.jsp";
                clientId = request.getParameter("clientId");
                request.setAttribute("clientId", clientId);
                if (clientId != null && !clientId.isEmpty()) {
                    try {
                        ClientIncentiveMgr clientIncentiveMgr = ClientIncentiveMgr.getInstance();
                        ArrayList<WebBusinessObject> clientIncentivesList = clientIncentiveMgr.getIncentivesByClientList(clientId);
                        request.setAttribute("clientIncentivesList", clientIncentivesList);
                    } catch (Exception ex) {
                        Logger.getLogger(SeasonServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
                this.forward(servedPage, request, response);
                break;
                 case 24:
                servedPage = "/docs/incentive/new_incentive.jsp";
                System.out.println("new_incentive");
                ArrayList<WebBusinessObject> incentivesList = new ArrayList<WebBusinessObject>();
                clientId = request.getParameter("clientId");
                request.setAttribute("clientId", clientId);
                if (clientId != null && !clientId.isEmpty()) {
                    try {
                        IncentiveMgr incentiveMgr = IncentiveMgr.getInstance();
                        incentivesList = new ArrayList<WebBusinessObject>(incentiveMgr.getOnArbitraryKeyOracle("1", "key3"));
                    } catch (Exception ex) {
                        Logger.getLogger(IncentiveServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
                request.setAttribute("incentivesList", incentivesList);
                this.forward(servedPage, request, response);
                break;
                 case 25 :
                     servedPage = "/show_client_files.jsp";
                    String clientID = (String) request.getParameter("clientID");
                     UnitDocMgr unitDocMgr = UnitDocMgr.getInstance();
                    unitDocMgr = UnitDocMgr.getInstance();
                    Vector documents = new Vector();
                    documents = unitDocMgr.getListOnLIKE(request.getParameter("op"), clientID);
                    request.setAttribute("page", servedPage);
                    request.setAttribute("documents", documents);
                    this.forward(servedPage, request, response);
                    break;
            case 26:
                out = response.getWriter();
                String docID = request.getParameter("docID");
                data = new WebBusinessObject();
                unitDocMgr =  UnitDocMgr.getInstance();
                if (unitDocMgr.deleteOnSingleKey(docID)) {
                    data.setAttribute("status", "Ok");
                } else {
                    data.setAttribute("status", "error");
                }
                out.write(Tools.getJSONObjectAsString(data));
                break;
            case 27:
                servedPage = "/docs/campaign/tools_list.jsp";
                ArrayList<WebBusinessObject> toolsList;
                try {
                    toolsList = new ArrayList<>(recordSeasonMgr.getOnArbitraryKeyOracle(request.getParameter("code"), "key2"));
                } catch (Exception ex) {
                    toolsList = new ArrayList<>();
                }
                request.setAttribute("data", toolsList);
                this.forward(servedPage, request, response);
                break;
            case 28:
                servedPage = "/docs/campaign/tool_form.jsp";
                request.setAttribute("channelWbo", seasonMgr.getOnSingleKey(request.getParameter("id")));
                this.forward(servedPage, request, response);
                break;
            case 29:
                out = response.getWriter();
                data = new WebBusinessObject();
                if (recordSeasonMgr.recordSeason(request, session)) {
                    data.setAttribute("status", "ok");
                } else {
                    data.setAttribute("status", "fail");
                }
                out.write(Tools.getJSONObjectAsString(data));
                break;
            case 30:
                out = response.getWriter();
                data = new WebBusinessObject();
                if (seasonMgr.updateSeasonDisplayHide(request.getParameter("id"), request.getParameter("display"))) {
                    data.setAttribute("status", "ok");
                } else {
                    data.setAttribute("status", "fail");
                }
                out.write(Tools.getJSONObjectAsString(data));
                break;
                
            default:
                System.out.println("Case Not Found");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP
     * <code>GET</code> method.
     *
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
     * Handles the HTTP
     * <code>POST</code> method.
     *
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
     *
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
        if (opName.equals("insertSeason")) {
            return 1;
        }
        if (opName.equals("saveSeason")) {
            return 2;
        }
        if (opName.equals("recordSeason")) {
            return 3;
        }
        if (opName.equals("ajaxGetCode")) {
            return 4;
        }
        if (opName.equals("saveRecordSeason")) {
            return 5;
        }
        if (opName.equals("listSeasons")) {
            return 6;
        }
        if (opName.equals("ViewSeasonType")) {
            return 7;
        }
        if (opName.equals("UpdateSeasonType")) {
            return 8;
        }
        if (opName.equals("updateSeason")) {
            return 9;
        }
        if (opName.equals("ConfirmDeleteSeason")) {
            return 10;
        }
        if (opName.equals("deleteSeason")) {
            return 11;
        }
        if (opName.equals("listRecordSeasons")) {
            return 12;
        }
        if (opName.equals("ViewRecordSeason")) {
            return 13;
        }
        if (opName.equals("UpdateRecordSeason")) {
            return 14;
        }
        if (opName.equals("ExcuteUpdateRecordSeason")) {
            return 15;
        }
        if (opName.equals("ConfirmDeleteRecordSeason")) {
            return 16;
        }
        if (opName.equals("deleteRecordSeason")) {
            return 17;
        }
        if (opName.equals("getSeasonList")) {
            return 18;
        }
        if (opName.equals("getPlanAttachments")) {
            return 19;
        }
        if (opName.equals("showSeason")) {
            return 20;
        }
        if (opName.equals("saveClientSeason")) {
            return 21;
        }
        if (opName.equals("checkCode")) {
            return 22;
        }
        // This From Incentives
        if (opName.equals("showIncentives")) {
            return 23;
        }
         if (opName.equals("getIncentiveForm")) {
            return 24;
        }
         /**
          * This For Attachment Files --> Comes From EmailServlet
          */
         if (opName.equals("showAttachedFiles")) {
            return 25;
        }
        if (opName.equals("deleteDocument")) {
            return 26;
        }
        if (opName.equals("viewTools")) {
            return 27;
        }
        if (opName.equals("addTool")) {
            return 28;
        }
        if (opName.equals("saveToolAjax")) {
            return 29;
        }
        if (opName.equals("updateShowHideChannelAjax")) {
            return 30;
        }
        return 0;
    }
}
