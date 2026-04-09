package com.unit.servlets;

import com.clients.db_access.ClientCommunicationMgr;
import com.clients.db_access.ClientMgr;
import com.clients.db_access.ClientProductMgr;
import com.clients.db_access.ReservationMgr;
import com.clients.db_access.ReservationNotificationMgr;
import com.clients.servlets.ClientServlet;
import com.crm.common.CRMConstants;
import com.crm.common.PDFTools;
import com.financials.db_access.FinancialTransactionMgr;
import com.maintenance.common.DateParser;
import com.maintenance.common.Tools;
import com.maintenance.common.UserDepartmentConfigMgr;
import com.maintenance.db_access.UnitDocMgr;
import com.maintenance.db_access.UserCompanyProjectsMgr;
import com.planning.db_access.PaymentPlanMgr;
import com.planning.db_access.StandardPaymentPlanMgr;
import com.silkworm.Exceptions.NoUserInSessionException;
import com.tracker.servlets.*;
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.silkworm.business_objects.*;
import com.silkworm.common.EmpRelationMgr;
import com.silkworm.common.MetaDataMgr;
import com.silkworm.db_access.PersistentSessionMgr;
import com.silkworm.logger.db_access.LoggerMgr;
import com.silkworm.persistence.relational.NoSuchColumnException;
import com.silkworm.persistence.relational.UniqueIDGen;
import com.silkworm.persistence.relational.UnsupportedConversionException;
import com.silkworm.persistence.relational.UnsupportedTypeException;
import static com.silkworm.servlets.swBaseServlet.getClientIpAddr;
import com.silkworm.util.DateAndTimeControl;
import com.tracker.common.ProjectConstants;
import com.tracker.db_access.CampaignMgr;
import com.tracker.db_access.ClientCampaignMgr;
import com.tracker.db_access.IssueStatusMgr;
import com.tracker.db_access.LocationTypeMgr;
import com.tracker.db_access.ProjectAccountingMgr;
import com.tracker.db_access.ProjectEntityMgr;
import com.tracker.db_access.ProjectMgr;
import com.tracker.db_access.ProjectPriceHistoryMgr;
import com.tracker.db_access.ProjectStageMgr;
import com.unit.db_access.ApartmentRuleMgr;
import com.unit.db_access.ArchDetailsMgr;
import com.unit.db_access.RentContractMgr;
import com.unit.db_access.UnitPriceMgr;
import com.unit.db_access.UnitTimelineMgr;
import com.unit.db_access.UnitTypeMgr;
import java.awt.image.BufferedImage;
import java.util.Date;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Vector;
import java.util.logging.Level;
import java.text.DecimalFormat;
import java.text.ParseException;
import javax.imageio.ImageIO;
import org.apache.log4j.Logger;
import java.util.Map;

public class UnitServlet extends TrackerBaseServlet {

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        logger = Logger.getLogger(UnitServlet.class);
    }

    @Override
    public void destroy() {
    }

    @Override
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        super.processRequest(request, response);
        HttpSession session = request.getSession();
        WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
        String loggegUserId = (String) loggedUser.getAttribute("userId");
        String remoteAccess = session.getId();
        WebBusinessObject persistentUser = (WebBusinessObject) PersistentSessionMgr.getInstance().getOnSingleKey(remoteAccess);
//        out = response.getWriter();
        ReservationNotificationMgr notification = ReservationNotificationMgr.getInstance();
        operation = getOpCode((String) request.getParameter("op"));
        switch (operation) {
            case 1:
                servedPage = "/docs/units/units_price.jsp";
                String buildingId = request.getParameter("buildingId");
                ProjectMgr projectMgr = ProjectMgr.getInstance();
                request.setAttribute("buildingId", buildingId);
                if (buildingId != null && !buildingId.isEmpty()) {
                    try {
                        EmpRelationMgr empRelationMgr = EmpRelationMgr.getInstance();
                        projectMgr = ProjectMgr.getInstance();
                        loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                        WebBusinessObject managerWbo = empRelationMgr.getOnSingleKey("key2", (String) loggedUser.getAttribute("userId"));
                        WebBusinessObject departmentWbo;
                        if (managerWbo != null) {
                            departmentWbo = projectMgr.getOnSingleKey("key5", (String) managerWbo.getAttribute("mgrId"));
                        } else {
                            departmentWbo = projectMgr.getOnSingleKey("key5", (String) loggedUser.getAttribute("userId"));
                        }

                        if (departmentWbo != null) {
                            ArrayList<WebBusinessObject> unitsList = projectMgr.getUnitsStatusByParent(buildingId, (String) departmentWbo.getAttribute("projectID"));
                            request.setAttribute("unitsList", unitsList);
                        }

                        WebBusinessObject buildingWbo = projectMgr.getOnSingleKey(buildingId);
                        request.setAttribute("buildingWbo", buildingWbo);
                    } catch (NoUserInSessionException ex) {
                        java.util.logging.Logger.getLogger(IncentiveServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }

                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 2:
                servedPage = "/docs/units/units_price.jsp";
                buildingId = request.getParameter("buildingId");
                projectMgr = ProjectMgr.getInstance();
                String[] unitIDs = request.getParameterValues("unitID");
                if (unitIDs != null && unitIDs.length > 0) {
                    boolean save = false;
                    UnitPriceMgr unitPriceMgr = UnitPriceMgr.getInstance();
                    for (String unitIdTemp : unitIDs) {
                        WebBusinessObject unitPriceWbo = new WebBusinessObject();
                        unitPriceWbo.setAttribute("unitID", unitIdTemp);
                        if (request.getParameter("minPrice" + unitIdTemp) != null && !request.getParameter("minPrice" + unitIdTemp).isEmpty()) {
                            unitPriceWbo.setAttribute("minPrice", request.getParameter("minPrice" + unitIdTemp));
                        } else {
                            unitPriceWbo.setAttribute("minPrice", "0");
                        }

                        if (request.getParameter("maxPrice" + unitIdTemp) != null && !request.getParameter("maxPrice" + unitIdTemp).isEmpty()) {
                            unitPriceWbo.setAttribute("maxPrice", request.getParameter("maxPrice" + unitIdTemp));
                        } else {
                            unitPriceWbo.setAttribute("maxPrice", "0");
                        }

                        if (request.getParameter("option1" + unitIdTemp) != null && !request.getParameter("option1" + unitIdTemp).isEmpty()) {
                            unitPriceWbo.setAttribute("option1", request.getParameter("option1" + unitIdTemp));
                        } else {
                            unitPriceWbo.setAttribute("option1", "0");
                        }

                        if (unitPriceMgr.saveObject(unitPriceWbo, loggedUser)) {
                            save = true;
                        }
                    }

                    request.setAttribute("status", save ? "ok" : "failed");
                }

                request.setAttribute("buildingId", buildingId);
                if (buildingId != null && !buildingId.isEmpty()) {
                    try {
                        EmpRelationMgr empRelationMgr = EmpRelationMgr.getInstance();
                        projectMgr = ProjectMgr.getInstance();
                        loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                        WebBusinessObject managerWbo = empRelationMgr.getOnSingleKey("key2", (String) loggedUser.getAttribute("userId"));
                        WebBusinessObject departmentWbo;
                        if (managerWbo != null) {
                            departmentWbo = projectMgr.getOnSingleKey("key5", (String) managerWbo.getAttribute("mgrId"));
                        } else {
                            departmentWbo = projectMgr.getOnSingleKey("key5", (String) loggedUser.getAttribute("userId"));
                        }

                        if (departmentWbo != null) {
                            ArrayList<WebBusinessObject> unitsList = projectMgr.getUnitsStatusByParent(buildingId, (String) departmentWbo.getAttribute("projectID"));
                            request.setAttribute("unitsList", unitsList);
                        }

                        WebBusinessObject buildingWbo = projectMgr.getOnSingleKey(buildingId);
                        request.setAttribute("buildingWbo", buildingWbo);
                    } catch (NoUserInSessionException ex) {
                        java.util.logging.Logger.getLogger(IncentiveServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }

                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 3:
                servedPage = "/docs/units/new_ResidentialModel.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 4:
                projectMgr = ProjectMgr.getInstance();
                String pName = request.getParameter(ProjectConstants.PROJECT_NAME);
                String eqNO = request.getParameter(ProjectConstants.EQ_NO);
                String pDescription = request.getParameter(ProjectConstants.PROJECT_DESC);
                String isMngmntStn = request.getParameter(ProjectConstants.IS_MNGMNT_STN);
                String isTrnsprtStn = request.getParameter(ProjectConstants.IS_TRNSPRT_STN);

                isMngmntStn = (isMngmntStn != null) ? "1" : "0";
                isTrnsprtStn = (isTrnsprtStn != null) ? "1" : "0";

                WebBusinessObject project = new WebBusinessObject();
                String mainProjectId = request.getParameter("mainProjectId");
                servedPage = "/docs/units/new_ResidentialModel.jsp";
                project.setAttribute(ProjectConstants.PROJECT_NAME, pName);
                project.setAttribute(ProjectConstants.EQ_NO, eqNO);
                project.setAttribute(ProjectConstants.PROJECT_DESC, pDescription);
                project.setAttribute(ProjectConstants.IS_MNGMNT_STN, isMngmntStn);
                project.setAttribute(ProjectConstants.IS_TRNSPRT_STN, isTrnsprtStn);
                if (mainProjectId == null) {
                    project.setAttribute("mainProjectId", "0");
                } else {
                    project.setAttribute("mainProjectId", mainProjectId);
                }

                project.setAttribute("futile", request.getParameter("futile"));
                project.setAttribute("location_type", request.getParameter("location_type"));
                // for ArchDetails
                project.setAttribute("category", request.getParameter("category"));
                project.setAttribute("rooms_no", request.getParameter("rooms_no"));
                project.setAttribute("kitchens_no", request.getParameter("kitchens_no"));
                project.setAttribute("pathroom_no", request.getParameter("pathroom_no"));
                project.setAttribute("balcony_no", request.getParameter("balcony_no"));
                project.setAttribute("total_area", request.getParameter("total_area"));
                project.setAttribute("net_area", request.getParameter("net_area"));

                String garageString = null;
                if (((String) request.getParameter("garage")) == null) {
                    garageString = "0";
                } else if (((String) request.getParameter("garage")).equals("on")) {
                    garageString = "1";
                }

                String elevatorString = null;
                if (((String) request.getParameter("elevator")) == null) {
                    elevatorString = "0";
                } else if (((String) request.getParameter("elevator")).equals("on")) {
                    elevatorString = "1";
                }

                String storageString = null;
                if (((String) request.getParameter("storage")) == null) {
                    storageString = "0";
                } else if (((String) request.getParameter("storage")).equals("on")) {
                    storageString = "1";
                }

                String clubString = null;
                if (((String) request.getParameter("club")) == null) {
                    clubString = "0";
                } else if (((String) request.getParameter("club")).equals("on")) {
                    clubString = "1";
                }

                project.setAttribute("garage", garageString);
                project.setAttribute("elevator", elevatorString);
                project.setAttribute("storage", storageString);
                project.setAttribute("club", clubString);
                project.setAttribute("min_price", request.getParameter("min_price"));
                project.setAttribute("max_price", request.getParameter("max_price"));

                ArchDetailsMgr archDetailsMgr = ArchDetailsMgr.getInstance();

                String ispressed = request.getParameter("ispressed");
                if (ispressed != null || !ispressed.isEmpty()) {
                    try {
                        if (!projectMgr.getDoubleName(pName, "key1") && !projectMgr.getDoubleName(eqNO, "key3")) {
                            if (archDetailsMgr.saveObject(project, session)) {
                                request.setAttribute("Status", "Ok");
                            } else {
                                request.setAttribute("Status", "No");
                            }
                        } else {
                            request.setAttribute("Status", "No");
                            request.setAttribute("name", "Duplicate Name");
                        }
                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                    }
                } else {
                    request.removeAttribute("Status");
                }

                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 5:
                servedPage = "/docs/units/reserved_units.jsp";
                if (request.getParameter("reserv") != null) {
                    request.setAttribute("reserv", request.getParameter("reserv"));
                } else if (request.getAttribute("reserv") != null) {
                    request.setAttribute("reserv", request.getAttribute("reserv"));
                }

                ReservationMgr reservationMgr = ReservationMgr.getInstance();
                try {
                    String fromDateS = request.getParameter("fromDate");
                    String toDateS = request.getParameter("toDate");
                    Calendar c = Calendar.getInstance();
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
                    if (toDateS == null) {
                        toDateS = sdf.format(c.getTime());
                    }

                    if (fromDateS == null) {
                        c.add(Calendar.MONTH, -1);
                        fromDateS = sdf.format(c.getTime());
                    }
                    ArrayList<WebBusinessObject> usrs = userMgr.getUserList();
                    DateParser dateParser = new DateParser();
                    String jsDateFormat = (String) loggedUser.getAttribute("jsDateFormat");
                    java.sql.Date fromDateD = dateParser.formatSqlDate(fromDateS, jsDateFormat);
                    java.sql.Date toDateD = dateParser.formatSqlDate(toDateS, jsDateFormat);
                    request.setAttribute("unitsList", reservationMgr.getReservedUnits(fromDateD, toDateD, null, null));
                    request.setAttribute("fromDate", fromDateS);
                    request.setAttribute("toDate", toDateS);
                    request.setAttribute("usrs", usrs);

                } catch (NoUserInSessionException ex) {
                    java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 6:
                servedPage = "/docs/units/residential_model_list.jsp";
                projectMgr = ProjectMgr.getInstance();
                UnitDocMgr docMgr = UnitDocMgr.getInstance();
                try {
                    ArrayList<WebBusinessObject> arrayOfProjects = projectMgr.getResidentialModelList();
                    for (int i = 0; i < arrayOfProjects.size(); i++) {
                        WebBusinessObject wbo = (WebBusinessObject) arrayOfProjects.get(i);
                        System.out.println(wbo.getObjectAsJSON2());
                        wbo.setAttribute("countImages", docMgr.getCountUnitDocs((String) wbo.getAttribute("Model_ID")));
                    }

                    request.setAttribute("allResidentials", arrayOfProjects);
                } catch (NoUserInSessionException ex) {
                    java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 7:
                servedPage = "/docs/units/view_ResidentialModel.jsp";
                archDetailsMgr = ArchDetailsMgr.getInstance();
                projectMgr = ProjectMgr.getInstance();
                String id = request.getParameter("id");
                WebBusinessObject modelWbo = archDetailsMgr.getOnSingleKey(id);
                WebBusinessObject projectWbo = projectMgr.getOnSingleKey(id);
                request.setAttribute("projectData", projectWbo);
                request.setAttribute("modelData", modelWbo);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 8:
                projectMgr = ProjectMgr.getInstance();
                pName = request.getParameter(ProjectConstants.PROJECT_NAME);
                eqNO = request.getParameter(ProjectConstants.EQ_NO);
                pDescription = request.getParameter(ProjectConstants.PROJECT_DESC);
                String projectID = request.getParameter("projectID");

                project = new WebBusinessObject();
                servedPage = "/docs/units/view_ResidentialModel.jsp";
                project.setAttribute(ProjectConstants.PROJECT_NAME, pName);
                project.setAttribute(ProjectConstants.EQ_NO, eqNO);
                project.setAttribute(ProjectConstants.PROJECT_DESC, pDescription);
                project.setAttribute("projectID", projectID);

                // for ArchDetails
                project.setAttribute("category", request.getParameter("category"));
                project.setAttribute("rooms_no", request.getParameter("rooms_no"));
                project.setAttribute("kitchens_no", request.getParameter("kitchens_no"));
                project.setAttribute("pathroom_no", request.getParameter("pathroom_no"));
                project.setAttribute("balcony_no", request.getParameter("balcony_no"));
                project.setAttribute("total_area", request.getParameter("total_area"));
                project.setAttribute("net_area", request.getParameter("net_area"));

                garageString = null;
                if (((String) request.getParameter("garage")) == null) {
                    garageString = "0";
                } else if (((String) request.getParameter("garage")).equals("on")) {
                    garageString = "1";
                }

                elevatorString = null;
                if (((String) request.getParameter("elevator")) == null) {
                    elevatorString = "0";
                } else if (((String) request.getParameter("elevator")).equals("on")) {
                    elevatorString = "1";
                }

                storageString = null;
                if (((String) request.getParameter("storage")) == null) {
                    storageString = "0";
                } else if (((String) request.getParameter("storage")).equals("on")) {
                    storageString = "1";
                }

                clubString = null;
                if (((String) request.getParameter("club")) == null) {
                    clubString = "0";
                } else if (((String) request.getParameter("club")).equals("on")) {
                    clubString = "1";
                }

                project.setAttribute("garage", garageString);
                project.setAttribute("elevator", elevatorString);
                project.setAttribute("storage", storageString);
                project.setAttribute("club", clubString);
                project.setAttribute("min_price", request.getParameter("min_price"));
                project.setAttribute("max_price", request.getParameter("max_price"));

                archDetailsMgr = ArchDetailsMgr.getInstance();
                try {
                    if (projectMgr.getDoubleName(pName, "key1") && projectMgr.getDoubleName(eqNO, "key3")) {
                        if (archDetailsMgr.updateObject(project, session)) {
                            request.setAttribute("Status", "Ok");
                        } else {
                            request.setAttribute("Status", "No");
                        }
                    } else {
                        request.setAttribute("Status", "No");
                        request.setAttribute("name", "Duplicate Name");
                    }
                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }

                modelWbo = archDetailsMgr.getOnSingleKey(projectID);
                projectWbo = projectMgr.getOnSingleKey(projectID);
                request.setAttribute("projectData", projectWbo);
                request.setAttribute("modelData", modelWbo);
                request.setAttribute("page", servedPage);

                this.forwardToServedPage(request, response);
                break;

            case 9:
                servedPage = "/docs/projects/new_apartment.jsp";
                projectMgr = ProjectMgr.getInstance();
                UnitTypeMgr unitTypeMgr = UnitTypeMgr.getInstance();
                ArrayList<WebBusinessObject> parents;
                try {
                    parents = new ArrayList<>(projectMgr.getOnArbitraryKeyOracle("44", "key6"));
                } catch (Exception ex) {
                    parents = new ArrayList<>();
                }

                request.setAttribute("projects", parents);
                WebBusinessObject locationWbo = LocationTypeMgr.getInstance().getOnSingleKey("key1", "RES-UNIT");
                try {
                    request.setAttribute("unitTypesList", new ArrayList<>(unitTypeMgr.getOnArbitraryKeyOracle((String) locationWbo.getAttribute("id"), "key1")));
                    request.setAttribute("levelsList", new ArrayList<>(projectMgr.getOnArbitraryKeyOracle("LVL", "key6")));
                    request.setAttribute("modelsList", new ArrayList<>(projectMgr.getOnArbitraryKeyOracle("RES-MODEL", "key6")));
                } catch (Exception ex) {
                    request.setAttribute("unitTypesList", new ArrayList<>());
                    request.setAttribute("levelsList", new ArrayList<>());
                }

                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 10:
                servedPage = "/docs/projects/new_apartment.jsp";
                projectMgr = ProjectMgr.getInstance();
                parents = new ArrayList<WebBusinessObject>(projectMgr.getAllProjects("1364111290870"));
                projectWbo = projectMgr.getOnSingleKey(request.getParameter("projectID"));
                WebBusinessObject unitWbo = new WebBusinessObject();
                unitWbo.setAttribute(ProjectConstants.PROJECT_NAME, ((String) projectWbo.getAttribute("projectName")) + " " + request.getParameter("unitNo"));
                unitWbo.setAttribute(ProjectConstants.EQ_NO, request.getParameter("modelID") != null && !request.getParameter("modelID").isEmpty() ? request.getParameter("modelID") : "UL");
                unitWbo.setAttribute(ProjectConstants.PROJECT_DESC, "UL");
                unitWbo.setAttribute("mainProjectId", request.getParameter("projectID"));
                unitWbo.setAttribute(ProjectConstants.LOCATION_TYPE, "RES-UNIT");
                unitWbo.setAttribute(ProjectConstants.FUTILE, "1");
                unitWbo.setAttribute(ProjectConstants.IS_TRNSPRT_STN, "1");
                unitWbo.setAttribute(ProjectConstants.IS_MNGMNT_STN, "1");
                unitWbo.setAttribute(ProjectConstants.COORDINATE, request.getParameter("projectID"));
                unitWbo.setAttribute("unitArea", request.getParameter("unitArea"));
                unitWbo.setAttribute("unitPrice", request.getParameter("unitPrice"));
                try {
                    if (projectMgr.saveAppartment(unitWbo, session)) {
                        request.setAttribute("Status", "Ok");
                    } else {
                        request.setAttribute("Status", "No");
                    }
                } catch (NoUserInSessionException ex) {
                    java.util.logging.Logger.getLogger(ProjectServlet.class.getName()).log(Level.SEVERE, null, ex);
                    request.setAttribute("Status", "No");
                }

                request.setAttribute("projects", parents);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 11:
                id = request.getParameter("id");
                projectMgr = ProjectMgr.getInstance();
                modelWbo = projectMgr.getOnSingleKey("key3", id);
                if (modelWbo != null) {
                    response.getWriter().write("update");
                } else {
                    response.getWriter().write("save");
                }
                break;

            case 12:
                servedPage = "/docs/units/list_apartments.jsp";
                projectMgr = ProjectMgr.getInstance();
                ArrayList<WebBusinessObject> apartmentsList = new ArrayList<WebBusinessObject>();
                String unitStatus = request.getParameter("unitStatus");
                if (unitStatus == null) {
                    unitStatus = "8";
                }

                try {
                    EmpRelationMgr empRelationMgr = EmpRelationMgr.getInstance();
                    loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                    WebBusinessObject managerWbo = empRelationMgr.getOnSingleKey("key2", (String) loggedUser.getAttribute("userId"));
                    WebBusinessObject departmentWbo;
                    if (managerWbo != null) {
                        departmentWbo = projectMgr.getOnSingleKey("key5", (String) managerWbo.getAttribute("mgrId"));
                    } else {
                        departmentWbo = projectMgr.getOnSingleKey("key5", (String) loggedUser.getAttribute("userId"));
                    }

                    if (departmentWbo != null) {
                        apartmentsList = new ArrayList<WebBusinessObject>(projectMgr.getAllUnitsWithPrice((String) departmentWbo.getAttribute("projectID"), unitStatus, request.getParameter("projectID")));
                    }
                } catch (NoUserInSessionException ex) {
                    java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                try {
                    request.setAttribute("projectsList", new ArrayList<>(projectMgr.getOnArbitraryKey("44", "key4")));
                } catch (Exception ex) {
                    //java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                    request.setAttribute("projectsList", new ArrayList<>());
                }

                request.setAttribute("projectID", request.getParameter("projectID"));

                request.setAttribute("apartmentsList", apartmentsList);
                request.setAttribute("page", servedPage);
                request.setAttribute("unitStatus", unitStatus);
                this.forwardToServedPage(request, response);
                break;

            case 13:
                projectMgr = ProjectMgr.getInstance();
                String apartmentName = request.getParameter("apartmentName");
                String apartmentId = request.getParameter("apartmentId");
                servedPage = "/docs/units/confirm_del_apartment.jsp";
                try {
                    if (apartmentName == null || apartmentName.equals("")) {
                        apartmentName = ((WebBusinessObject) projectMgr.getOnSingleKey(apartmentId)).getAttribute("projectName").toString();
                    }
                } catch (Exception e) {
                    apartmentName = ((WebBusinessObject) projectMgr.getOnSingleKey(apartmentId)).getAttribute("projectName").toString();
                }

                request.setAttribute("apartmentName", apartmentName);
                request.setAttribute("apartmentId", apartmentId);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 14:
                projectMgr = ProjectMgr.getInstance();
                ClientProductMgr clientProductMgr = ClientProductMgr.getInstance();
                IssueStatusMgr issueStatusMgr = IssueStatusMgr.getInstance();
                reservationMgr = ReservationMgr.getInstance();
                apartmentId = request.getParameter("apartmentId");
                try {
                    if (projectMgr.deleteOnSingleKey(apartmentId)) {
                        request.setAttribute("status", "ok");
                        clientProductMgr.deleteOnArbitraryKey(apartmentId, "key2");
                        issueStatusMgr.deleteOnArbitraryKey(apartmentId, "key1");
                        reservationMgr.deleteOnArbitraryKey(apartmentId, "key2");
                    } else {
                        request.setAttribute("status", "fail");
                    }
                } catch (Exception ex) {
                    java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                apartmentsList = new ArrayList<WebBusinessObject>();
                try {
                    EmpRelationMgr empRelationMgr = EmpRelationMgr.getInstance();
                    loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                    WebBusinessObject managerWbo = empRelationMgr.getOnSingleKey("key2", (String) loggedUser.getAttribute("userId"));
                    WebBusinessObject departmentWbo;
                    if (managerWbo != null) {
                        departmentWbo = projectMgr.getOnSingleKey("key5", (String) managerWbo.getAttribute("mgrId"));
                    } else {
                        departmentWbo = projectMgr.getOnSingleKey("key5", (String) loggedUser.getAttribute("userId"));
                    }

                    if (departmentWbo != null) {
                        apartmentsList = new ArrayList<WebBusinessObject>(projectMgr.getAllUnitsFromProject((String) departmentWbo.getAttribute("projectID"), null));
                    }
                } catch (NoUserInSessionException ex) {
                    java.util.logging.Logger.getLogger(ProjectServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                request.setAttribute("apartmentsList", apartmentsList);
                servedPage = "/docs/units/list_apartments.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 15:
                projectMgr = ProjectMgr.getInstance();
                projectWbo = projectMgr.getOnSingleKey(request.getParameter("projectID"));
                unitWbo = new WebBusinessObject();
                unitWbo.setAttribute(ProjectConstants.PROJECT_NAME, ((String) projectWbo.getAttribute("projectName")) + " " + request.getParameter("unitNo"));
                unitWbo.setAttribute(ProjectConstants.EQ_NO, request.getParameter("modelID") != null && !request.getParameter("modelID").isEmpty() ? request.getParameter("modelID") : "UL");
                unitWbo.setAttribute(ProjectConstants.PROJECT_DESC, request.getParameter("unitDesc"));
                unitWbo.setAttribute("mainProjectId", request.getParameter("projectID"));
                unitWbo.setAttribute(ProjectConstants.LOCATION_TYPE, "RES-UNIT");
                unitWbo.setAttribute(ProjectConstants.FUTILE, "1");
                unitWbo.setAttribute(ProjectConstants.IS_TRNSPRT_STN, "1");
                unitWbo.setAttribute(ProjectConstants.IS_MNGMNT_STN, "1");
                unitWbo.setAttribute(ProjectConstants.COORDINATE, request.getParameter("projectID"));
                unitWbo.setAttribute("unitTypeID", request.getParameter("unitTypeID"));
                unitWbo.setAttribute("option_three", request.getParameter("levelID"));
                unitWbo.setAttribute("unitArea", request.getParameter("unitArea") != null ? request.getParameter("unitArea") : "0");
                unitWbo.setAttribute("unitPrice", request.getParameter("unitPrice") != null ? request.getParameter("unitPrice") : "0");
                try {
                    Vector<WebBusinessObject> data = projectMgr.getOnArbitraryDoubleKeyOracle("RES-UNIT", "key4", (String) unitWbo.getAttribute(ProjectConstants.PROJECT_NAME), "key1");
                    if (data.isEmpty()) {
                        if (projectMgr.saveAppartment(unitWbo, session)) {
                            response.getWriter().write("OK");
                        } else {
                            response.getWriter().write("NO");
                        }
                    } else {
                        response.getWriter().write("duplicate#" + data.get(0).getAttribute("projectID"));
                    }
                } catch (Exception ex) {
                    java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                break;

            case 16:
                String numValue = "";
                DecimalFormat formatter = new DecimalFormat("#,###.00");

                String unitCode = request.getParameter("unitCode");
                String clientCode = request.getParameter("clientCode");
                String wboId = request.getParameter("id");
                projectMgr = ProjectMgr.getInstance();
                Vector data = new Vector();
                WebBusinessObject wbo = new WebBusinessObject();
                ArrayList<WebBusinessObject> arrayOfItem = projectMgr.getReservedUnitByUnitCodeAndClientCodeAndId(unitCode, clientCode, wboId);
                wbo.setAttribute("clientName", arrayOfItem.get(0).getAttribute("clientName"));
                wbo.setAttribute("clientAddress", arrayOfItem.get(0).getAttribute("address") == null ? "لا يوجد" : arrayOfItem.get(0).getAttribute("address"));
                wbo.setAttribute("clientJob", arrayOfItem.get(0).getAttribute("job") == null ? "لا يوجد" : arrayOfItem.get(0).getAttribute("job"));
                wbo.setAttribute("clientEmail", arrayOfItem.get(0).getAttribute("email") == null ? "لا يوجد" : arrayOfItem.get(0).getAttribute("email"));
                wbo.setAttribute("clientPhone2", arrayOfItem.get(0).getAttribute("mobile") == null ? "لا يوجد" : arrayOfItem.get(0).getAttribute("mobile"));
                wbo.setAttribute("clientPhone", arrayOfItem.get(0).getAttribute("phone") == null ? "لا يوجد" : arrayOfItem.get(0).getAttribute("phone"));
                wbo.setAttribute("clientNationalID", arrayOfItem.get(0).getAttribute("nationalID") == null ? "لا يوجد" : arrayOfItem.get(0).getAttribute("nationalID"));
                String producer = "";
                if (arrayOfItem.get(0).getAttribute("nationalID") != null) {
                    if (arrayOfItem.get(0).getAttribute("nationalID").toString().contains("-")) {
                        producer = arrayOfItem.get(0).getAttribute("nationalID").toString().substring(arrayOfItem.get(0).getAttribute("nationalID").toString().indexOf("-") + 1);
                    } else {
                        producer = "لا يوجد";
                    }
                }

                wbo.setAttribute("clientNIIDProducer", arrayOfItem.get(0).getAttribute("nationalID") == null ? "لا يوجد" : producer);
                wbo.setAttribute("clientNO", arrayOfItem.get(0).getAttribute("unitCode") == null ? "لا يوجد" : arrayOfItem.get(0).getAttribute("unitCode"));
                wbo.setAttribute("downPayment", arrayOfItem.get(0).getAttribute("budget") == null ? "لا يوجد" : arrayOfItem.get(0).getAttribute("budget"));
                wbo.setAttribute("period", arrayOfItem.get(0).getAttribute("period") == null ? "لا يوجد" : arrayOfItem.get(0).getAttribute("period"));
                wbo.setAttribute("projectName", arrayOfItem.get(0).getAttribute("projectName") == null ? "لا يوجد" : arrayOfItem.get(0).getAttribute("projectName"));

//                numValue = (String) arrayOfItem.get(0).getAttribute("unitValue");
//                double amount = Double.parseDouble(numValue.toString());
//                wbo.setAttribute("unitValue", arrayOfItem.get(0).getAttribute("unitValue") == null ? "" : formatter.format(amount));
                wbo.setAttribute("unitValue", arrayOfItem.get(0).getAttribute("unitValue") == null ? "" : formatter.format(Double.parseDouble((String) arrayOfItem.get(0).getAttribute("unitValue"))));

//                numValue = (String) arrayOfItem.get(0).getAttribute("reservationValue");
//                amount = Double.parseDouble((String)numValue);
//                wbo.setAttribute("reservationValue", arrayOfItem.get(0).getAttribute("reservationValue") == null ? "" : formatter.format(amount));
                wbo.setAttribute("reservationValue", arrayOfItem.get(0).getAttribute("reservationValue") == null ? "" : formatter.format(Double.parseDouble((String) arrayOfItem.get(0).getAttribute("reservationValue"))));

//                numValue = (String) arrayOfItem.get(0).getAttribute("contractValue");
//                amount = Double.parseDouble((String)numValue);
//                wbo.setAttribute("contractValue", arrayOfItem.get(0).getAttribute("contractValue") == null ? "" : formatter.format(amount));
                wbo.setAttribute("contractValue", arrayOfItem.get(0).getAttribute("contractValue") == null ? "" : formatter.format(Double.parseDouble((String) arrayOfItem.get(0).getAttribute("contractValue"))));

//                numValue = (String) arrayOfItem.get(0).getAttribute("beforeDis").toString();
//                amount = Double.parseDouble((String)numValue);
                wbo.setAttribute("beforeDis", arrayOfItem.get(0).getAttribute("beforeDis") == null ? "" : formatter.format(Double.parseDouble((String) arrayOfItem.get(0).getAttribute("beforeDis").toString())));

                wbo.setAttribute("plotArea", arrayOfItem.get(0).getAttribute("plotArea") == null ? "" : arrayOfItem.get(0).getAttribute("plotArea"));
                wbo.setAttribute("buildingArea", arrayOfItem.get(0).getAttribute("buildingArea") == null ? "" : arrayOfItem.get(0).getAttribute("buildingArea"));
                wbo.setAttribute("paymentSystem", arrayOfItem.get(0).getAttribute("paymentSystem") == null ? "" : arrayOfItem.get(0).getAttribute("paymentSystem"));
                wbo.setAttribute("comments", arrayOfItem.get(0).getAttribute("comments") == null ? "" : arrayOfItem.get(0).getAttribute("comments"));
                wbo.setAttribute("floorNo", arrayOfItem.get(0).getAttribute("floorNo") == null ? "" : arrayOfItem.get(0).getAttribute("floorNo"));
                wbo.setAttribute("modelNo", arrayOfItem.get(0).getAttribute("modelNo") == null ? "" : arrayOfItem.get(0).getAttribute("modelNo"));
                wbo.setAttribute("receiptNo", arrayOfItem.get(0).getAttribute("receiptNo") == null ? "" : arrayOfItem.get(0).getAttribute("receiptNo"));
                wbo.setAttribute("unitValueText", arrayOfItem.get(0).getAttribute("unitValueText") == null ? "" : arrayOfItem.get(0).getAttribute("unitValueText"));
                wbo.setAttribute("beforeDiscountText", arrayOfItem.get(0).getAttribute("beforeDiscountText") == null ? "" : arrayOfItem.get(0).getAttribute("beforeDiscountText"));
                wbo.setAttribute("reservationValueText", arrayOfItem.get(0).getAttribute("reservationValueText") == null ? "" : arrayOfItem.get(0).getAttribute("reservationValueText"));
                wbo.setAttribute("contractValueText", arrayOfItem.get(0).getAttribute("contractValueText") == null ? "" : arrayOfItem.get(0).getAttribute("contractValueText"));
                String reservationDate = arrayOfItem.get(0).getAttribute("reservationDate").toString();
                wbo.setAttribute("reservationDate", arrayOfItem.get(0).getAttribute("reservationDate") == null ? "" : reservationDate.substring(0, 10));
                wbo.setAttribute("employee", arrayOfItem.get(0).getAttribute("employee") == null ? "" : arrayOfItem.get(0).getAttribute("employee"));
                //String[] isBuildingOrVila = ((String) wbo.getAttribute("clientNO")).split("-");
                String[] isBuildingOrVila = ((String) wbo.getAttribute("clientNO")).split(" ");
                String buildingNumber = "";
                String unitNumber = "";

                String projID = arrayOfItem.get(0).getAttribute("mainProjectId").toString();
                String unitNo = wbo.getAttribute("clientNO").toString();
                int unitLen = unitNo.length();
                switch (projID) {
                    case "11": //زايد ديونز كومبلكس 1 - building
                        buildingNumber = unitNo.substring(unitLen - 4, unitLen - 2);
                        unitNumber = unitNo.substring(unitLen - 4);
                        break;

                    case "12": //زايد ديونز كومبلكس 2 - building
                        buildingNumber = unitNo.substring(unitLen - 4, unitLen - 2);
                        unitNumber = unitNo.substring(unitLen - 4);
                        break;

                    case "21": // زايد ديونز 1 - villa
                        buildingNumber = isBuildingOrVila[isBuildingOrVila.length - 1];
                        break;

                    case "22":  // زايد ديونز 2 - villa
                        buildingNumber = isBuildingOrVila[isBuildingOrVila.length - 1];
                        break;

                    case "1414239210597": //ريجينسى وحدات سكنية
                        buildingNumber = unitNo.substring(unitLen - 4, unitLen - 2);
                        unitNumber = unitNo.substring(unitLen - 4);
                        break;

                    case "1439722874359": //ريجينسى فيلات
                        buildingNumber = isBuildingOrVila[isBuildingOrVila.length - 1];
                        break;

                    default:
                        WebBusinessObject p = projectMgr.getOnSingleKey(projID);
                        String projectName = p.getAttribute("projectName").toString();
                        //   String newbuildingNumber = unitNo.substring(projectName.indexOf(projectName) + projectName.length()+1);
                        buildingNumber = unitNo; //newbuildingNumber.substring(0,newbuildingNumber.indexOf("-"));
                        unitNumber = unitNo;// newbuildingNumber.substring(newbuildingNumber.indexOf("-")+1);
                        break;
                }

//                if (isBuildingOrVila.length > 4) {
//                    buildingNumber = isBuildingOrVila[3];
//                    unitNumber = isBuildingOrVila[4];
//                } else {
//                    String number = isBuildingOrVila[0].substring(isBuildingOrVila[0].length() - 4, isBuildingOrVila[0].length());
//                    unitNumber = number.substring(0, 4);
//                    buildingNumber = number.substring(0, 2);
//                }
                wbo.setAttribute("buildingNumber", buildingNumber);
                wbo.setAttribute("unitNumber", unitNumber);

                WebBusinessObject mainProject = projectMgr.getOnSingleKey((String) arrayOfItem.get(0).getAttribute("mainProjectId"));
                String report = "clientUnitSheet";
                if (!((String) mainProject.getAttribute("optionOne")).equals("UL")) {
                    report = (String) mainProject.getAttribute("optionOne");
                }

                HashMap map = new HashMap();

                /*
                 To add The Logo
                 */
                UnitDocMgr unitDocMgr = UnitDocMgr.getInstance();
                ArrayList<WebBusinessObject> imagesList = unitDocMgr.getLogosWithProjectID((String) arrayOfItem.get(0).getAttribute("mainProjectId"));
                String absPath = "";
                if (!imagesList.isEmpty()) {
                    String random = UniqueIDGen.getNextID();
                    int len = random.length();

                    String randFileName = "ran" + random.substring(5, len) + ".jpeg";

                    String userHome = (String) loggedUser.getAttribute("userHome");
                    String imageDirPath = getServletContext().getRealPath("/images");
                    String userImageDir = imageDirPath + "/" + userHome;

                    String RIPath = userImageDir + "/" + randFileName;

                    absPath = "images/" + userHome + "/" + randFileName;
                    System.out.println(RIPath + " / " + absPath);
                    File docImage = new File(RIPath);
                    BufferedInputStream gifData = new BufferedInputStream(unitDocMgr.getImage((String) imagesList.get(0).getAttribute("docID")));
                    BufferedImage myImage = ImageIO.read(gifData);
                    ImageIO.write(myImage, "jpeg", docImage);
                    wbo.setAttribute("logo", RIPath);
                }

                data.add(wbo);
                Tools.createPdfReport(report, map, data, getServletConfig().getServletContext(), response, request);
//                Tools.createPdfBeanReport("ClientWithUnitReport", map , arrayOfItem, getServletConfig().getServletContext() , response, request);
                break;

            case 17:
                out = response.getWriter();
                WebBusinessObject statusWbo = new WebBusinessObject();
                statusWbo.setAttribute("status", "faild");
                projectMgr = ProjectMgr.getInstance();
                Calendar c = Calendar.getInstance();
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                wbo = projectMgr.getOnSingleKey(request.getParameter("id"));
                if (wbo != null) {
                    String newStatusCode = request.getParameter("newStatus");
                    statusWbo.setAttribute("statusCode", newStatusCode);
                    statusWbo.setAttribute("date", sdf.format(c.getTime()));
                    statusWbo.setAttribute("businessObjectId", request.getParameter("id"));
                    statusWbo.setAttribute("statusNote", "UL");
                    statusWbo.setAttribute("objectType", "Housing_Units");
                    statusWbo.setAttribute("parentId", "UL");
                    statusWbo.setAttribute("issueTitle", "UL");
                    statusWbo.setAttribute("cuseDescription", "UL");
                    statusWbo.setAttribute("actionTaken", "UL");
                    statusWbo.setAttribute("preventionTaken", "UL");
                    issueStatusMgr = IssueStatusMgr.getInstance();
                    try {
                        if (issueStatusMgr.changeStatus(statusWbo, persistentUser, null)) {
                            statusWbo.setAttribute("status", "Ok");
                        }
                    } catch (SQLException ex) {
                        java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }

                out.write(Tools.getJSONObjectAsString(statusWbo));
                break;

            case 18:
                servedPage = "/docs/units/apartments_rules.jsp";
                String[] statusTitles = new String[6];
                statusTitles[0] = "8";
                statusTitles[1] = "9";
                statusTitles[2] = "10";
                statusTitles[3] = "28";
                statusTitles[4] = "33";
                statusTitles[5] = "61";
                projectMgr = ProjectMgr.getInstance();
                ApartmentRuleMgr apartmentRuleMgr = ApartmentRuleMgr.getInstance();
                try {
                    ArrayList<WebBusinessObject> departmentsList = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKeyOracle("div", "key6"));
                    if (request.getParameter("toSave") != null) {
                        apartmentRuleMgr.deleteAllRules();
                        for (String status : statusTitles) {
                            for (WebBusinessObject department : departmentsList) {
                                if (request.getParameter(status + "_" + ((String) department.getAttribute("projectID"))) != null) {
                                    wbo = new WebBusinessObject();
                                    wbo.setAttribute("departmentID", department.getAttribute("projectID"));
                                    wbo.setAttribute("apartmentStatus", status);
                                    if (apartmentRuleMgr.saveObject(wbo, loggedUser)) {
                                        request.setAttribute("status", "ok");
                                    } else {
                                        request.setAttribute("status", "fail");
                                    }
                                }
                            }
                        }
                    }
                } catch (Exception ex) {
                    java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                try {
                    ArrayList<WebBusinessObject> apartmentsRules = apartmentRuleMgr.getApartmentsRules(statusTitles);
                    request.setAttribute("apartmentsRules", apartmentsRules);
                    request.setAttribute("statusTitles", statusTitles);
                } catch (Exception ex) {
                    java.util.logging.Logger.getLogger(this.getClass().getName()).log(Level.SEVERE, null, ex);
                }

                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 19:
                projectMgr = ProjectMgr.getInstance();
                String apartmentSelected = request.getParameter("apartmentSelected");
                String[] apartments = apartmentSelected.split("<!>");
                ArrayList<WebBusinessObject> arrayOfApartmentsToDelete = new ArrayList<WebBusinessObject>();
                String firstItemCode = null;
                String firstItemDesc = null;
                for (int i = 0; i < apartments.length; i++) {
                    WebBusinessObject wboApart = new WebBusinessObject();
                    if (i == 0) {
                        firstItemCode = apartments[i].contains(",") ? apartments[i].split(",")[1] : "";
                        if (firstItemCode.isEmpty()) {
                            this.forward("UnitServlet?op=listApartments", request, response);
                        }
                    } else if (i == apartments.length - 1) {
                        firstItemDesc = apartments[i].split(",")[0];

                        wboApart.setAttribute("apartmentId", firstItemCode);
                        if (firstItemDesc == null || firstItemDesc.equals("")) {
                            wboApart.setAttribute("apartmentName", ((WebBusinessObject) projectMgr.getOnSingleKey(firstItemCode)).getAttribute("projectName").toString());
                        } else {
                            wboApart.setAttribute("apartmentName", firstItemDesc);
                        }

                        arrayOfApartmentsToDelete.add(wboApart);
                    } else {
//                        WebBusinessObject wboApart = new WebBusinessObject();
                        wboApart.setAttribute("apartmentId", apartments[i].split(",")[1]);
                        if (apartments[i].split(",")[0] == null || apartments[i].split(",")[0].equals("")) {
                            wboApart.setAttribute("apartmentName", ((WebBusinessObject) projectMgr.getOnSingleKey(apartments[i].split(",")[1])).getAttribute("projectName").toString());
                        } else {
                            wboApart.setAttribute("apartmentName", apartments[i].split(",")[0]);

                        }

                        arrayOfApartmentsToDelete.add(wboApart);
                    }
//                    arrayOfApartmentsToDelete.add(wboApart);
                }

                servedPage = "/docs/Adminstration/confirmDeleteSomeUnits.jsp";

                request.setAttribute("data", arrayOfApartmentsToDelete);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 20:
                projectMgr = ProjectMgr.getInstance();
                clientProductMgr = ClientProductMgr.getInstance();
                issueStatusMgr = IssueStatusMgr.getInstance();
                reservationMgr = ReservationMgr.getInstance();
                String[] apartmentIDs = request.getParameterValues("apartmentID");
                if (apartmentIDs != null) {
                    for (int i = 0; i < apartmentIDs.length; i++) {
                        try {
                            if (projectMgr.deleteOnSingleKey(apartmentIDs[i])) {
                                request.setAttribute("status", "ok");
                                clientProductMgr.deleteOnArbitraryKey(apartmentIDs[i], "key2");
                                issueStatusMgr.deleteOnArbitraryKey(apartmentIDs[i], "key1");
                                reservationMgr.deleteOnArbitraryKey(apartmentIDs[i], "key2");
                            } else {
                                request.setAttribute("status", "fail");
                            }
                        } catch (Exception ex) {
                            java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    }
                }

                apartmentsList = new ArrayList<WebBusinessObject>();
                try {
                    EmpRelationMgr empRelationMgr = EmpRelationMgr.getInstance();
                    loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                    WebBusinessObject managerWbo = empRelationMgr.getOnSingleKey("key2", (String) loggedUser.getAttribute("userId"));
                    WebBusinessObject departmentWbo;
                    if (managerWbo != null) {
                        departmentWbo = projectMgr.getOnSingleKey("key5", (String) managerWbo.getAttribute("mgrId"));
                    } else {
                        departmentWbo = projectMgr.getOnSingleKey("key5", (String) loggedUser.getAttribute("userId"));
                    }

                    if (departmentWbo != null) {
                        apartmentsList = new ArrayList<WebBusinessObject>(projectMgr.getAllUnitsFromProject((String) departmentWbo.getAttribute("projectID"), null));
                    }
                } catch (NoUserInSessionException ex) {
                    java.util.logging.Logger.getLogger(ProjectServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                request.setAttribute("apartmentsList", apartmentsList);
                servedPage = "/docs/units/list_apartments.jsp";
                request.setAttribute("page", servedPage);
                this.forward("/UnitServlet?op=listApartments", request, response);
                break;

            case 21:
                String modelName = request.getParameter("modelName");
                String modelID = request.getParameter("modelID");
                projectMgr = ProjectMgr.getInstance();
                servedPage = "/docs/Adminstration/confirm_del_model.jsp";
                try {
                    if (modelName == null || modelName.equals("")) {
                        modelName = (String) ((WebBusinessObject) projectMgr.getOnSingleKey(modelID)).getAttribute("projectName");
                    }
                } catch (Exception e) {
                    modelName = (String) ((WebBusinessObject) projectMgr.getOnSingleKey(modelID)).getAttribute("projectName");
                }

                request.setAttribute("modelName", modelName);
                request.setAttribute("modelID", modelID);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 22:
                modelID = request.getParameter("modelID");
                projectMgr = ProjectMgr.getInstance();
                if (projectMgr.deleteModel(modelID)) {
                    request.setAttribute("status", "ok");
                    archDetailsMgr = ArchDetailsMgr.getInstance();
                    archDetailsMgr.deleteOnSingleKey(modelID);
                } else {
                    request.setAttribute("status", "fail");
                }

                servedPage = "/docs/units/residential_model_list.jsp";
                projectMgr = ProjectMgr.getInstance();
                try {
                    request.setAttribute("allResidentials", projectMgr.getResidentialModelList());
                } catch (NoUserInSessionException ex) {
                    java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 23:
                servedPage = "/docs/units/models_report.jsp";
                projectMgr = ProjectMgr.getInstance();
                try {
                    ArrayList<WebBusinessObject> modelsList = projectMgr.getResidentialModelList();
                    request.setAttribute("modelsList", modelsList);
                } catch (NoUserInSessionException ex) {
                    java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 24:
                out = response.getWriter();
                String unitCurrentStatus = request.getParameter("unitCurrentStatus");
                String eventName = "";
                statusWbo = new WebBusinessObject();
                statusWbo.setAttribute("status", "faild");
                reservationMgr = ReservationMgr.getInstance();
                issueStatusMgr = IssueStatusMgr.getInstance();
                c = Calendar.getInstance();
                sdf = new SimpleDateFormat("yyyy-MM-dd");
                WebBusinessObject reservationWbo = reservationMgr.getOnSingleKey(request.getParameter("id"));
                if (reservationWbo != null) {
                    String newStatusCode = request.getParameter("newStatus");
                    statusWbo.setAttribute("statusCode", newStatusCode);
                    statusWbo.setAttribute("date", sdf.format(c.getTime()));
                    statusWbo.setAttribute("businessObjectId", request.getParameter("id"));
                    statusWbo.setAttribute("statusNote", request.getParameter("notes") != null ? request.getParameter("notes") : "");
                    statusWbo.setAttribute("objectType", "RESERVATION");
                    statusWbo.setAttribute("parentId", "UL");
                    statusWbo.setAttribute("issueTitle", "UL");
                    statusWbo.setAttribute("cuseDescription", "UL");
                    statusWbo.setAttribute("actionTaken", "UL");
                    statusWbo.setAttribute("preventionTaken", "UL");
                    try {
                        if (issueStatusMgr.changeStatus(statusWbo, persistentUser, null) && reservationMgr.updateStatus(newStatusCode, request.getParameter("id"))) {
                            clientProductMgr = ClientProductMgr.getInstance();
                            try {
                                ArrayList<WebBusinessObject> onholdList = new ArrayList<>(clientProductMgr.getOnArbitraryDoubleKeyOracle("onhold", "key4",
                                        (String) reservationWbo.getAttribute("projectId"), "key2"));
                                boolean updateUnitStatus = (unitCurrentStatus != null && unitCurrentStatus.equals(CRMConstants.UNIT_STATUS_RESERVED))
                                        || onholdList.size() == 1 || (onholdList.size() > 1 && newStatusCode.equals(CRMConstants.RESERVATION_STATUS_CONFIRM)
                                        || newStatusCode.equals(CRMConstants.RESERVATION_STATUS_UNDER_RETRIEVE));
                                if (updateUnitStatus) {
                                    statusWbo = new WebBusinessObject();
                                    statusWbo.setAttribute("statusCode", newStatusCode.equals(CRMConstants.RESERVATION_STATUS_CONFIRM) ? "10" : "8");
                                    statusWbo.setAttribute("date", sdf.format(c.getTime()));
                                    statusWbo.setAttribute("businessObjectId", reservationWbo.getAttribute("projectId"));
                                    statusWbo.setAttribute("statusNote", "UL");
                                    statusWbo.setAttribute("objectType", "Housing_Units");
                                    statusWbo.setAttribute("parentId", "UL");
                                    statusWbo.setAttribute("issueTitle", "UL");
                                    statusWbo.setAttribute("cuseDescription", "UL");
                                    statusWbo.setAttribute("actionTaken", "UL");
                                    statusWbo.setAttribute("preventionTaken", "UL");
                                    //  issueStatusMgr.changeStatus(statusWbo, persistentUser, null);
                                }

                                switch (newStatusCode) {
                                    case CRMConstants.RESERVATION_STATUS_CONFIRM:
                                        try {
                                            ArrayList<WebBusinessObject> productsList = new ArrayList<>(
                                                    clientProductMgr.getOnArbitraryDoubleKeyOracle((String) reservationWbo.getAttribute("clientId"), "key1",
                                                            (String) reservationWbo.getAttribute("projectId"), "key2"));
                                            if (productsList.size() > 0) {
                                                clientProductMgr.updateProductStatus((String) productsList.get(0).getAttribute("id"), "purche");
                                            }

                                            if (onholdList.size() > 1) {
                                                clientProductMgr.deleteOnArbitraryDoubleKey("onhold", "key4", (String) reservationWbo.getAttribute("projectId"), "key2");
                                                ArrayList<WebBusinessObject> reservationList = new ArrayList<WebBusinessObject>(
                                                        reservationMgr.getOnArbitraryDoubleKeyOracle((String) reservationWbo.getAttribute("projectId"),
                                                                "key2", CRMConstants.RESERVATION_STATUS_PENDING, "key4"));
                                                for (WebBusinessObject tempWbo : reservationList) {
                                                    reservationMgr.updateStatus(CRMConstants.RESERVATION_STATUS_CANCEL, (String) tempWbo.getAttribute("id"));
                                                }
                                            }
                                        } catch (Exception ex) {
                                            java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                                        }
                                        if (MetaDataMgr.getInstance().getRealEstateWeb().equals("1")) {
                                            String wifiCurrentStatus = request.getParameter("unitCurrentStatus");
                                            statusWbo = new WebBusinessObject();
                                            statusWbo.setAttribute("status", "faild");
                                            reservationMgr = ReservationMgr.getInstance();
                                            issueStatusMgr = IssueStatusMgr.getInstance();
                                            c = Calendar.getInstance();
                                            sdf = new SimpleDateFormat("yyyy-MM-dd");

                                            String ReservCard_CodeClient = MetaDataMgr.getInstance().getAssetErpName();
                                            WebBusinessObject clientInfo = new WebBusinessObject();
                                            WebBusinessObject clientAotherPhone = new WebBusinessObject();
                                            clientInfo = ClientMgr.getInstance().getOnSingleKey((String) reservationWbo.getAttribute("clientId"));
                                            Vector<WebBusinessObject> clientAotherPhones = ClientCommunicationMgr.getInstance().getOnArbitraryDoubleKey((String) reservationWbo.getAttribute("clientId"), "key2", "phone", "key3");
                                            if (!clientAotherPhones.isEmpty()) {
                                                clientAotherPhone = clientAotherPhones.get(0);
                                            } else {
                                                clientAotherPhone = null;
                                            }
                                            WebBusinessObject dataRealEstate = new WebBusinessObject();
                                            ArrayList<WebBusinessObject> getClientCheck = null;
                                            try {
                                                getClientCheck = ClientMgr.getInstance().getClientCheckWiFi(clientInfo);
                                            } catch (SQLException ex) {
                                                java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                                            }
                                            String getClientChecks = "";
                                            for (WebBusinessObject webBusinessObject : getClientCheck) {
                                                getClientChecks = webBusinessObject.getAttribute("CLIENT_CODE").toString();
                                            }
                                            String getMaxClientIdStore = null;
                                            String getMaxClientId = null;
                                            if (getClientChecks == null || getClientChecks.equals("")) {
                                                try {
                                                    getMaxClientId = ClientMgr.getInstance().getMaxClientId();
                                                    getMaxClientIdStore = ClientMgr.getInstance().getMaxClientIdStore();
                                                    dataRealEstate = ClientProductMgr.getInstance().saveClientRealEsatate(getMaxClientId, getMaxClientIdStore, clientInfo);
                                                } catch (SQLException ex) {
                                                    java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                                                } catch (NoSuchColumnException ex) {
                                                    java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                                                } catch (InterruptedException ex) {
                                                    java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                                                }
                                            } else {
                                                getMaxClientId = getClientChecks;
                                            }
                                                String getUnitName = ClientMgr.getInstance().getUnitName((String) reservationWbo.getAttribute("projectId"));
                                                String getUnitId = ClientMgr.getInstance().getUnitId(getUnitName);
                                                String getUserCode = ClientMgr.getInstance().getUserCode((String) reservationWbo.getAttribute("createdBy"));
                                                String getInstProg = ClientMgr.getInstance().getInstProg((String) reservationWbo.getAttribute("projectId"));
                                                WebBusinessObject dataRealEstateWeb = new WebBusinessObject();
                                                dataRealEstateWeb = ClientProductMgr.getInstance().saveClientRealEsatateWebReserv(getUnitId, getUserCode, getMaxClientId, clientInfo, (String) reservationWbo.getAttribute("budget"),getInstProg);
                                                WebBusinessObject dataRealEstateWebAllCode = new WebBusinessObject();
                                                dataRealEstateWebAllCode = ClientProductMgr.getInstance().saveDataRealEstateWebAllCode(getUnitId, getUnitName);
                                                statusWbo.setAttribute("status", "Ok");
                                                eventName = "confirm";
                                                statusWbo.setAttribute("eventName", eventName);  // متاخد من switch فوق
                                            } else {
                                            boolean savedRe = false;
                                            String mainBuilding = request.getParameter("mainBuilding");
                                            String brokerInf = request.getParameter("brokerInf");
                                            String brokerInfName = request.getParameter("brokerInfName");
                                            String brokerInfPhone = request.getParameter("brokerInfPhone");
                                            projectMgr = ProjectMgr.getInstance();

                                            String productId = (String) reservationWbo.getAttribute("projectId");
                                            String projectDatabase = null;
                                            wbo = projectMgr.getOnSingleKey(productId);
                                            if (wbo != null) {
                                                projectDatabase = (String) wbo.getAttribute("optionThree");
                                            }
                                            String ReservCard_CodeClient = projectMgr.ReservCard_CodeClient(projectDatabase);
                                            WebBusinessObject clientInfo = new WebBusinessObject();
                                            WebBusinessObject clientAotherPhone = new WebBusinessObject();
                                            clientInfo = ClientMgr.getInstance().getOnSingleKey((String) reservationWbo.getAttribute("clientId"));
                                            Vector<WebBusinessObject> clientAotherPhones = ClientCommunicationMgr.getInstance().getOnArbitraryDoubleKey((String) reservationWbo.getAttribute("clientId"), "key2", "phone", "key3");
                                            if (!clientAotherPhones.isEmpty()) {
                                                clientAotherPhone = clientAotherPhones.get(0);
                                            } else {
                                                clientAotherPhone = null;
                                            }
                                            WebBusinessObject dataRealEstate = new WebBusinessObject();
                                            ArrayList<WebBusinessObject> getClientCheck = ClientMgr.getInstance().getClientCheck(clientInfo, projectDatabase);
                                            String getClientChecks = "";
                                            for (WebBusinessObject webBusinessObject : getClientCheck) {
                                                getClientChecks = webBusinessObject.getAttribute("CLIENT_CODE").toString();
                                            }
                                            if (getClientChecks == null || getClientChecks.equals("")) {
                                                dataRealEstate = clientProductMgr.saveInterestedProductRealEstat(ReservCard_CodeClient, clientInfo, projectDatabase, clientAotherPhone);
                                            } else {
                                                ReservCard_CodeClient = getClientChecks;
                                            }
                                            ArrayList<WebBusinessObject> dataUpdate = new ArrayList<WebBusinessObject>();
                                            dataUpdate = projectMgr.getTempForm((String) reservationWbo.getAttribute("clientId"), (String) reservationWbo.getAttribute("projectId"));
                                            WebBusinessObject singleWebBusinessObject = dataUpdate.get(0);
                                            WebBusinessObject wboRe = new WebBusinessObject();

                                            String ReservCard_Code = projectMgr.ReservCard_Code((String) singleWebBusinessObject.getAttribute("PROJECT"));

                                            wboRe.setAttribute("ReservCard_Code", ReservCard_Code);
                                            wboRe.setAttribute("RESERVE_FORM_DATE", singleWebBusinessObject.getAttribute("RESERVE_FORM_DATE"));
                                            wboRe.setAttribute("CLIENT_CODE", ReservCard_CodeClient);
                                            if (singleWebBusinessObject.getAttribute("STAGE_CODE").equals("3")) {
                                                wboRe.setAttribute("STAGE_CODE", "1");
                                            } else if (singleWebBusinessObject.getAttribute("STAGE_CODE").equals("4")) {
                                                wboRe.setAttribute("STAGE_CODE", "3");
                                            } else {
                                                wboRe.setAttribute("STAGE_CODE", singleWebBusinessObject.getAttribute("STAGE_CODE"));
                                            }
                                            wboRe.setAttribute("SECTION_CODE", singleWebBusinessObject.getAttribute("SECTION_CODE"));
                                            wboRe.setAttribute("SUBSTAGE_CODE", singleWebBusinessObject.getAttribute("SUBSTAGE_CODE"));
                                            wboRe.setAttribute("SAMPLE_CODE", singleWebBusinessObject.getAttribute("SAMPLE_CODE"));
                                            wboRe.setAttribute("BUILDING_CODE", singleWebBusinessObject.getAttribute("BUILDING_CODE"));
                                            wboRe.setAttribute("BUILDING_TYPE", singleWebBusinessObject.getAttribute("BUILDING_TYPE"));
                                            wboRe.setAttribute("UNIT_CODE", singleWebBusinessObject.getAttribute("UNIT_CODE"));
                                            wboRe.setAttribute("INSTALMENT_TYPE_CODE", singleWebBusinessObject.getAttribute("INSTALMENT_TYPE_CODE"));
                                            wboRe.setAttribute("DOWN_PAYMENT", singleWebBusinessObject.getAttribute("DOWN_PAYMENT"));
                                            wboRe.setAttribute("RECEIPT_NO", singleWebBusinessObject.getAttribute("RECEIPT_NO"));
                                            wboRe.setAttribute("PAYMENT_METHOD", singleWebBusinessObject.getAttribute("PAYMENT_METHOD"));
                                            wboRe.setAttribute("SOURCE", singleWebBusinessObject.getAttribute("SOURCE"));
                                            if (singleWebBusinessObject.getAttribute("SOURCE").equals("3")) {
                                                wboRe.setAttribute("brokerInfName", brokerInf);
                                            } else {
                                                wboRe.setAttribute("brokerInfName", "");
                                            }
                                            wboRe.setAttribute("UNIT_TYPE", singleWebBusinessObject.getAttribute("UNIT_TYPE"));
                                            wboRe.setAttribute("EXPIRATION_DATE", singleWebBusinessObject.getAttribute("EXPIRATION_DATE"));
                                            wboRe.setAttribute("UNIT_TOTAL", singleWebBusinessObject.getAttribute("UNIT_TOTAL"));
                                            wboRe.setAttribute("AREA", singleWebBusinessObject.getAttribute("AREA"));
                                            wboRe.setAttribute("PROJECT", singleWebBusinessObject.getAttribute("PROJECT"));
                                            if (mainBuilding == null) {
                                                wboRe.setAttribute("mainBuilding", "");
                                            } else {
                                                wboRe.setAttribute("mainBuilding", mainBuilding);
                                            }
                                            try {
                                                savedRe = projectMgr.saveObject4(wboRe, session);
                                            } catch (NoUserInSessionException ex) {
                                                java.util.logging.Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                                            }

                                        }
                                        //out.write(Tools.getJSONObjectAsString(statusWbo));
                                        
                                        break;

                                    case CRMConstants.RESERVATION_STATUS_CANCEL:
                                        try {
                                            clientProductMgr.deleteOnArbitraryDoubleKey((String) reservationWbo.getAttribute("clientId"), "key1",
                                                    (String) reservationWbo.getAttribute("projectId"), "key2");
                                            ArrayList<WebBusinessObject> productsList = new ArrayList<>(
                                                    clientProductMgr.getOnArbitraryDoubleKeyOracle((String) reservationWbo.getAttribute("clientId"), "key1", "purche", "key4"));
                                            productsList.addAll(clientProductMgr.getOnArbitraryDoubleKeyOracle((String) reservationWbo.getAttribute("clientId"), "key1", "reserved", "key4"));
                                            if (productsList.isEmpty()) {
                                                ClientMgr.getInstance().updateClientStatus((String) reservationWbo.getAttribute("clientId"), "12", persistentUser);
                                            }
                                        } catch (Exception ex) {
                                            java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                                        }

                                        eventName = "Cancel";
                                        break;

                                    case CRMConstants.RESERVATION_STATUS_UNDER_RETRIEVE:
                                        clientProductMgr.deleteOnArbitraryDoubleKey((String) reservationWbo.getAttribute("clientId"), "key1",
                                                (String) reservationWbo.getAttribute("projectId"), "key2");
                                        ArrayList<WebBusinessObject> productsList = new ArrayList<>(
                                                clientProductMgr.getOnArbitraryDoubleKeyOracle((String) reservationWbo.getAttribute("clientId"), "key1", "purche", "key4"));
                                        productsList.addAll(clientProductMgr.getOnArbitraryDoubleKeyOracle((String) reservationWbo.getAttribute("clientId"), "key1", "reserved", "key4"));
                                        if (productsList.isEmpty()) {
                                            ClientMgr.getInstance().updateClientStatus((String) reservationWbo.getAttribute("clientId"), "12", persistentUser);
                                        }
                                        eventName = "Under Retrieve";
                                        break;

                                    case CRMConstants.RESERVATION_STATUS_RETRIEVED:
                                        eventName = "Retrieved";
                                        break;
                                }
                            } catch (Exception ex) {
                                java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                            }

                            WebBusinessObject clientWbo = ClientMgr.getInstance().getOnSingleKey((String) reservationWbo.getAttribute("clientId"));
                            projectMgr = ProjectMgr.getInstance();
                            projectWbo = projectMgr.getOnSingleKey((String) reservationWbo.getAttribute("projectId"));
                            LoggerMgr loggerMgr = LoggerMgr.getInstance();
                            WebBusinessObject loggerWbo = new WebBusinessObject();
                            loggerWbo.setAttribute("objectXml", reservationWbo.getObjectAsXML());
                            loggerWbo.setAttribute("realObjectId", reservationWbo.getAttribute("id"));
                            loggerWbo.setAttribute("userId", persistentUser.getAttribute("userId"));
                            loggerWbo.setAttribute("objectName", clientWbo.getAttribute("name") + " - " + projectWbo.getAttribute("projectName"));
                            loggerWbo.setAttribute("loggerMessage", "Reservation");
                            loggerWbo.setAttribute("eventName", eventName);
                            loggerWbo.setAttribute("objectTypeId", "3");
                            loggerWbo.setAttribute("eventTypeId", "3");
                            loggerWbo.setAttribute("ipForClient", getClientIpAddr(request));
                            loggerMgr.saveObject(loggerWbo);
                        }
                    } catch (SQLException ex) {
                        java.util.logging.Logger.getLogger(CampaignServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
                out.write(Tools.getJSONObjectAsString(statusWbo));
                break;

            case 25:
                out = response.getWriter();
                List<WebBusinessObject> list = new ArrayList<WebBusinessObject>();
                List<WebBusinessObject> reserveds = notification.getReservation();
                for (WebBusinessObject reserved : reserveds) {
                    wbo = new WebBusinessObject();
                    wbo.setAttribute("id", (String) reserved.getAttribute("id"));
                    wbo.setAttribute("currentStatus", (String) reserved.getAttribute("currentStatus"));
                    wbo.setAttribute("timeRemainingSeconds", (String) reserved.getAttribute("timeRemainingSeconds"));
                    list.add(wbo);
                }

                out.write(Tools.getJSONArrayAsString(list));
                break;

            case 26:
                servedPage = "docs/units/units_list.jsp";
                projectMgr = ProjectMgr.getInstance();
                try {
                    request.setAttribute("unitsList", new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryDoubleKeyOracle(request.getParameter("projectID"), "key2", "ENG-UNIT", "key6")));
                } catch (NoUserInSessionException ex) {
                    java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                } catch (Exception ex) {
                    java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                this.forward(servedPage, request, response);
                break;

            case 27:
                unitIDs = request.getParameterValues("deleteThis");
                if (unitIDs != null && unitIDs.length > 0) {
                    boolean save = false;
                    UnitPriceMgr unitPriceMgr = UnitPriceMgr.getInstance();
                    ProjectPriceHistoryMgr projectPriceHistoryMgr = ProjectPriceHistoryMgr.getInstance();
                    // save unit price history
                    WebBusinessObject historyWbo = new WebBusinessObject();
                    historyWbo.setAttribute("createdBy", persistentUser.getAttribute("userId"));
                    historyWbo.setAttribute("option1", "UL");
                    historyWbo.setAttribute("option2", "UL");
                    historyWbo.setAttribute("option3", "UL");
                    historyWbo.setAttribute("option4", "UL");
                    historyWbo.setAttribute("option5", "UL");
                    historyWbo.setAttribute("option6", "UL");
                    //
                    for (String unitIdTemp : unitIDs) {
                        WebBusinessObject unitPriceWbo = new WebBusinessObject();
                        unitIdTemp = unitIdTemp.substring(0, unitIdTemp.indexOf("<!>"));
                        try {
                            unitPriceMgr.deleteOnArbitraryKey(unitIdTemp, "key1");
                        } catch (Exception ex) {
                            java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }

                        unitPriceWbo.setAttribute("unitID", unitIdTemp);
                        unitPriceWbo.setAttribute("minPrice", "0");
                        if (request.getParameter("unitArea" + unitIdTemp) != null && !request.getParameter("unitArea" + unitIdTemp).isEmpty()) {
                            unitPriceWbo.setAttribute("maxPrice", request.getParameter("unitArea" + unitIdTemp));
                        } else {
                            unitPriceWbo.setAttribute("maxPrice", "0");
                        }

                        if (request.getParameter("unitPrice" + unitIdTemp) != null && !request.getParameter("unitPrice" + unitIdTemp).isEmpty()) {
                            unitPriceWbo.setAttribute("option1", request.getParameter("unitPrice" + unitIdTemp));
                        } else {
                            unitPriceWbo.setAttribute("option1", "0");
                        }

                        if (unitPriceMgr.saveObject(unitPriceWbo, loggedUser)) {
                            historyWbo.setAttribute("projectID", unitIdTemp);
                            historyWbo.setAttribute("unitNum", request.getParameter("unitArea" + unitIdTemp)); // unitNum --> unit area
                            historyWbo.setAttribute("meterPrice", request.getParameter("unitPrice" + unitIdTemp)); // meterPrice --> unit price
                            projectPriceHistoryMgr.saveObject(historyWbo);
                            save = true;
                        }
                    }
                    request.setAttribute("statusUpdate", save ? "ok" : "failed");
                }

                this.forward("/UnitServlet?op=listApartments", request, response);
                break;

            case 28:
                servedPage = "/docs/units/list_available_apartments.jsp";
                projectMgr = ProjectMgr.getInstance();
                apartmentsList = new ArrayList<WebBusinessObject>();
                String fromDateS = request.getParameter("fromDate");
                String toDateS = request.getParameter("toDate");
                String clientID = request.getParameter("clientID");
                c = Calendar.getInstance();
                sdf = new SimpleDateFormat("yyyy/MM/dd");
                if (toDateS == null) {
                    toDateS = sdf.format(c.getTime());
                }

                if (fromDateS == null) {
                    c.add(Calendar.YEAR, -1);
                    fromDateS = sdf.format(c.getTime());
                }
                DateParser dateParser = new DateParser();
                String jsDateFormat = (String) loggedUser.getAttribute("jsDateFormat");
                java.sql.Date fromDateD = dateParser.formatSqlDate(fromDateS, jsDateFormat);
                java.sql.Date toDateD = dateParser.formatSqlDate(toDateS, jsDateFormat);
                boolean allProject = true;
                try {
                    UserCompanyProjectsMgr userCompanyProjectsMgr = UserCompanyProjectsMgr.getInstance();
                    Vector projectsListofuser = userCompanyProjectsMgr.getAllProjectsByUserId((String) persistentUser.getAttribute("userId"));
                    ArrayList projectlistofuser = new ArrayList(projectsListofuser);
                    if (!projectlistofuser.isEmpty()) {
                        request.setAttribute("projectsList", projectlistofuser);
                        allProject = false;
                    } else {
                        request.setAttribute("projectsList", new ArrayList<>(projectMgr.getOnArbitraryKey("44", "key4")));
                        allProject = true;
                    }
                } catch (Exception ex) {
                    java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                try {
                    EmpRelationMgr empRelationMgr = EmpRelationMgr.getInstance();
                    loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                    WebBusinessObject managerWbo = empRelationMgr.getOnSingleKey("key2", (String) loggedUser.getAttribute("userId"));
                    WebBusinessObject departmentWbo;
                    if (managerWbo != null) {
                        departmentWbo = projectMgr.getOnSingleKey("key5", (String) managerWbo.getAttribute("mgrId"));
                    } else {
                        departmentWbo = projectMgr.getOnSingleKey("key5", (String) loggedUser.getAttribute("userId"));
                    }

                    if (departmentWbo != null) {
                        apartmentsList = new ArrayList<WebBusinessObject>(projectMgr.getAllPricedUnits(clientID, (String) departmentWbo.getAttribute("projectID"),
                                fromDateD, toDateD, request.getParameter("unitAreaID") != null ? (String) request.getParameter("unitAreaID") : "",
                                request.getParameter("projectID") != null ? (String) request.getParameter("projectID") : "", allProject,
                                (String) persistentUser.getAttribute("userId")));
                    }
                } catch (NoUserInSessionException ex) {
                    java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                request.setAttribute("projectID", request.getParameter("projectID"));
                request.setAttribute("unitAreaID", request.getParameter("unitAreaID"));
                request.setAttribute("clientID", request.getParameter("clientID"));
                request.setAttribute("fromDate", fromDateS);
                request.setAttribute("toDate", toDateS);
                request.setAttribute("apartmentsList", apartmentsList);
                request.setAttribute("page", servedPage);
                request.setAttribute("fromDate", fromDateS);
                request.setAttribute("toDate", toDateS);

                /*projectMgr = ProjectMgr.getInstance();
                 ArrayList<WebBusinessObject> projectsList = new ArrayList<WebBusinessObject>();
                 try {
                 //WebBusinessObject wbo4 = (WebBusinessObject) (new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKey("PRODUCTS", "key3"))).get(0);
                 projectsList = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryDoubleKeyOracle("44", "key6", "66", "key9"));
                 } catch (Exception ex) {
                 java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                 }

                 request.setAttribute("projectsList", projectsList);
                 */
                this.forwardToServedPage(request, response);
                break;

            case 29:
                servedPage = "/docs/projects/new_eng_unit.jsp";
                projectMgr = ProjectMgr.getInstance();
                UserCompanyProjectsMgr userCompanyProjectsMgr = UserCompanyProjectsMgr.getInstance();
                parents = new ArrayList<WebBusinessObject>();
                try {
                    parents = new ArrayList<WebBusinessObject>(userCompanyProjectsMgr.getOnArbitraryKey(loggegUserId, "key1"));
                } catch (Exception ex) {
                    java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                request.setAttribute("projects", parents);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 30:
                projectMgr = ProjectMgr.getInstance();
                projectWbo = projectMgr.getOnSingleKey(request.getParameter("projectID"));
                unitWbo = new WebBusinessObject();
                unitWbo.setAttribute(ProjectConstants.PROJECT_NAME, ((String) projectWbo.getAttribute("projectName")) + " " + request.getParameter("unitNo"));
                unitWbo.setAttribute(ProjectConstants.EQ_NO, "UL");
                unitWbo.setAttribute(ProjectConstants.PROJECT_DESC, "UL");
                unitWbo.setAttribute("mainProjectId", request.getParameter("projectID"));
                unitWbo.setAttribute(ProjectConstants.LOCATION_TYPE, "ENG-UNIT");
                unitWbo.setAttribute(ProjectConstants.FUTILE, "1");
                unitWbo.setAttribute(ProjectConstants.IS_TRNSPRT_STN, "1");
                unitWbo.setAttribute(ProjectConstants.IS_MNGMNT_STN, "1");
                try {
                    if (projectMgr.saveEngUnit(unitWbo, session)) {
                        SimpleDateFormat sdfTemp = new SimpleDateFormat("yyyy/MM/dd");
                        try {
                            unitWbo.setAttribute("estimatedFinishDate", new java.sql.Date(sdfTemp.parse(request.getParameter("estimatedFinishDate")).getTime()));
                        } catch (ParseException ex) {
                            unitWbo.setAttribute("estimatedFinishDate", new java.sql.Date(Calendar.getInstance().getTimeInMillis()));
                        }
                        unitWbo.setAttribute("estimatedCost", request.getParameter("estimatedCost"));
                        unitWbo.setAttribute("option1", "UL");
                        unitWbo.setAttribute("option2", "UL");
                        unitWbo.setAttribute("option3", "UL");
                        unitWbo.setAttribute("option4", "UL");
                        unitWbo.setAttribute("option5", "UL");
                        unitWbo.setAttribute("option6", "UL");
                        ProjectStageMgr.getInstance().saveObject(unitWbo);
                        response.getWriter().write("OK");
                    } else {
                        response.getWriter().write("NO");
                    }
                } catch (NoUserInSessionException ex) {
                    java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                break;

            case 31:
                out = response.getWriter();
                wbo = new WebBusinessObject();
                UnitPriceMgr unitPriceMgr = UnitPriceMgr.getInstance();
                WebBusinessObject unitPriceWbo = null;
                try {
                    unitPriceWbo = unitPriceMgr.getOnSingleKey("key1", request.getParameter("unitID"));
                    unitPriceMgr.deleteOnArbitraryKey(request.getParameter("unitID"), "key1");
                } catch (Exception ex) {
                    java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                if (unitPriceWbo == null) {
                    unitPriceWbo = new WebBusinessObject();
                }

                unitPriceWbo.setAttribute("unitID", request.getParameter("unitID"));
                unitPriceWbo.setAttribute("minPrice", "0");
                if (request.getParameter("unitArea") != null && !request.getParameter("unitArea").isEmpty()) {
                    unitPriceWbo.setAttribute("maxPrice", request.getParameter("unitArea"));
                } else {
                    unitPriceWbo.setAttribute("maxPrice", "0");
                }

                if (request.getParameter("unitPrice") != null && !request.getParameter("unitPrice").isEmpty()) {
                    unitPriceWbo.setAttribute("option1", request.getParameter("unitPrice"));
                } else {
                    unitPriceWbo.setAttribute("option1", "0");
                }

                if (unitPriceMgr.saveObject(unitPriceWbo, loggedUser)) {
                    wbo.setAttribute("status", "Ok");
                } else {
                    wbo.setAttribute("status", "faild");
                }

                out.write(Tools.getJSONObjectAsString(wbo));
                break;

            case 32:
                servedPage = "/docs/units/edit_reservation.jsp";
                String reservationID = request.getParameter("reservationID");
                reservationMgr = ReservationMgr.getInstance();
                projectMgr = ProjectMgr.getInstance();
                clientProductMgr = ClientProductMgr.getInstance();
                reservationWbo = reservationMgr.getOnSingleKey(reservationID);
                try {
                    request.setAttribute("paymentPlace", new ArrayList<>(projectMgr.getOnArbitraryKey("1365240752318", "key2")));
                    ArrayList<WebBusinessObject> clientProductList = new ArrayList<>(clientProductMgr.getOnArbitraryDoubleKeyOracle((String) reservationWbo.getAttribute("clientId"),
                            "key1", (String) reservationWbo.getAttribute("projectId"), "key2"));
                    if (!clientProductList.isEmpty()) {
                        request.setAttribute("clientProductWbo", clientProductList.get(0));
                    }
                } catch (Exception ex) {
                    java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                if (reservationWbo != null) {
                    if (reservationWbo.getAttribute("projectId") != null) {
                        request.setAttribute("unitWbo", projectMgr.getOnSingleKey((String) reservationWbo.getAttribute("projectId")));
                    }

                    if (reservationWbo.getAttribute("createdBy") != null) {
                        request.setAttribute("salesUserWbo", userMgr.getOnSingleKey((String) reservationWbo.getAttribute("createdBy")));
                    }

                    if (reservationWbo.getAttribute("clientId") != null) {
                        request.setAttribute("clientWbo", ClientMgr.getInstance().getOnSingleKey((String) reservationWbo.getAttribute("clientId")));
                    }
                }

                request.setAttribute("reservationWbo", reservationWbo);
                request.setAttribute("reservationID", reservationID);
                this.forward(servedPage, request, response);
                break;

            case 33:
                servedPage = "/docs/units/edit_reservation.jsp";
                reservationID = request.getParameter("reservationID");
                reservationMgr = ReservationMgr.getInstance();
                projectMgr = ProjectMgr.getInstance();
                clientProductMgr = ClientProductMgr.getInstance();
                reservationWbo = new WebBusinessObject();
                //reservationWbo.setAttribute("budget", request.getParameter("budget"));
                reservationWbo.setAttribute("budget", "000");
                reservationWbo.setAttribute("period", request.getParameter("period"));
                reservationWbo.setAttribute("paymentSystem", request.getParameter("paymentSystem"));
                reservationWbo.setAttribute("paymentPlace", request.getParameter("addtions"));
                reservationWbo.setAttribute("reservationDate", request.getParameter("reservationDate"));
                reservationWbo.setAttribute("floorNo", request.getParameter("floorNo"));
                reservationWbo.setAttribute("modelNo", request.getParameter("modelNo"));
                reservationWbo.setAttribute("receiptNo", request.getParameter("receiptNo"));
                reservationWbo.setAttribute("beforeDiscountText", request.getParameter("beforeDiscountText"));
                reservationWbo.setAttribute("unitValueText", request.getParameter("unitValueText"));
                reservationWbo.setAttribute("contractValueText", request.getParameter("contractValueText"));
                reservationWbo.setAttribute("reservationValueText", request.getParameter("reservationValueText"));
                reservationWbo.setAttribute("reservationID", reservationID);
                if (reservationMgr.updateReservation(reservationWbo) && clientProductMgr.updateReservedUnit(request)) {
                    request.setAttribute("status", "ok");
                } else {
                    request.setAttribute("status", "failed");
                }

                reservationWbo = reservationMgr.getOnSingleKey(reservationID);
                try {
                    request.setAttribute("paymentPlace", new ArrayList<>(projectMgr.getOnArbitraryKey("1365240752318", "key2")));
                    ArrayList<WebBusinessObject> clientProductList = new ArrayList<>(clientProductMgr.getOnArbitraryDoubleKeyOracle((String) reservationWbo.getAttribute("clientId"),
                            "key1", (String) reservationWbo.getAttribute("projectId"), "key2"));
                    if (!clientProductList.isEmpty()) {
                        request.setAttribute("clientProductWbo", clientProductList.get(0));
                    }
                } catch (Exception ex) {
                    java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                if (reservationWbo != null) {
                    if (reservationWbo.getAttribute("projectId") != null) {
                        request.setAttribute("unitWbo", projectMgr.getOnSingleKey((String) reservationWbo.getAttribute("projectId")));
                    }

                    if (reservationWbo.getAttribute("createdBy") != null) {
                        request.setAttribute("salesUserWbo", userMgr.getOnSingleKey((String) reservationWbo.getAttribute("createdBy")));
                    }

                    if (reservationWbo.getAttribute("clientId") != null) {
                        request.setAttribute("clientWbo", ClientMgr.getInstance().getOnSingleKey((String) reservationWbo.getAttribute("clientId")));
                    }
                }

                request.setAttribute("reservationWbo", reservationWbo);
                request.setAttribute("reservationID", reservationID);
                this.forward(servedPage, request, response);
                break;

            case 34:
                servedPage = "/docs/units/my_reserved_units.jsp";
                fromDateS = request.getParameter("fromDate");
                toDateS = request.getParameter("toDate");
                c = Calendar.getInstance();
                sdf = new SimpleDateFormat("yyyy/MM/dd");
                if (toDateS == null) {
                    toDateS = sdf.format(c.getTime());
                }

                if (fromDateS == null) {
                    c.add(Calendar.MONTH, -1);
                    fromDateS = sdf.format(c.getTime());
                }

                dateParser = new DateParser();
                jsDateFormat = (String) loggedUser.getAttribute("jsDateFormat");
                fromDateD = dateParser.formatSqlDate(fromDateS, jsDateFormat);
                toDateD = dateParser.formatSqlDate(toDateS, jsDateFormat);
                reservationMgr = ReservationMgr.getInstance();
                request.setAttribute("unitsList", reservationMgr.getAllMyReservedUnits(session, fromDateD, toDateD));
                request.setAttribute("fromDate", fromDateS);
                request.setAttribute("toDate", toDateS);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 35:
                servedPage = "/docs/units/delete_reservation.jsp";
                request.setAttribute("id", request.getParameter("id"));
                request.setAttribute("unitName", request.getParameter("unitName"));
                request.setAttribute("clientName", request.getParameter("clientName"));
                this.forward(servedPage, request, response);
                break;

            case 36:
                wbo = new WebBusinessObject();
                try {
                    reservationMgr = ReservationMgr.getInstance();
                    if (reservationMgr.deleteOnSingleKey(request.getParameter("id"))) {
                        wbo.setAttribute("status", "ok");
                    } else {
                        wbo.setAttribute("status", "no");
                    }
                } catch (Exception ex) {
                    logger.error(ex);
                }

                out = response.getWriter();
                out.write(Tools.getJSONObjectAsString(wbo));
                break;

            case 37:
                servedPage = "/docs/units/sales_report.jsp";
                java.sql.Date fromDate = null;
                java.sql.Date toDate = null;
                sdf = new SimpleDateFormat("yyyy-MM-dd");
                try {
                    if (request.getParameter("fromDate") != null) {
                        fromDate = new java.sql.Date(sdf.parse(request.getParameter("fromDate")).getTime());
                    }

                    if (request.getParameter("toDate") != null) {
                        toDate = new java.sql.Date(sdf.parse(request.getParameter("toDate")).getTime());
                    }
                } catch (ParseException ex) {
                }

                reservationMgr = ReservationMgr.getInstance();
                request.setAttribute("dataList", reservationMgr.getSalesReport(fromDate, toDate));
                request.setAttribute("fromDate", request.getParameter("fromDate"));
                request.setAttribute("toDate", request.getParameter("toDate"));
                this.forward(servedPage, request, response);
                break;

            case 38:
                servedPage = "/docs/units/units_details.jsp";
                projectMgr = ProjectMgr.getInstance();
                apartmentsList = new ArrayList<>();
                buildingId = request.getParameter("buildingId");
                modelID = request.getParameter("modelID");
                String saveModel = request.getParameter("save");
                if (saveModel != null && !saveModel.isEmpty()) {
                    unitIDs = request.getParameterValues("unitID");
                    if (unitIDs != null && unitIDs.length > 0) {
                        boolean save = false;
                        for (String unitIDTemp : unitIDs) {
                            try {
                                if (projectMgr.updateUnitModel(modelID, unitIDTemp)) {
                                    save = true;
                                }
                            } catch (NoUserInSessionException ex) {
                                save = false;
                            }
                        }

                        request.setAttribute("status", save ? "ok" : "failed");
                    }
                }

                ArrayList<WebBusinessObject> projectsList = new ArrayList<>();
                ArrayList<WebBusinessObject> modelsList = new ArrayList<>();
                projectID = request.getParameter("projectID");
                try {
                    EmpRelationMgr empRelationMgr = EmpRelationMgr.getInstance();
                    loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                    WebBusinessObject managerWbo = empRelationMgr.getOnSingleKey("key2", (String) loggedUser.getAttribute("userId"));
                    WebBusinessObject departmentWbo;
                    if (managerWbo != null) {
                        departmentWbo = projectMgr.getOnSingleKey("key5", (String) managerWbo.getAttribute("mgrId"));
                    } else {
                        departmentWbo = projectMgr.getOnSingleKey("key5", (String) loggedUser.getAttribute("userId"));
                    }

                    projectsList = new ArrayList<>(projectMgr.getOnArbitraryKey("44", "key6"));
                    if (projectID == null && !projectsList.isEmpty()) {
                        projectID = (String) projectsList.get(0).getAttribute("projectID");
                    }

                    modelsList = new ArrayList<>(projectMgr.getOnArbitraryKeyOracle("RES-MODEL", "key4"));
                    if (projectID != null) {
                        modelsList.addAll(projectMgr.getOnArbitraryDoubleKeyOracle(projectID, "key2", "UNIT-MODEL", "key4"));
                        String[] tempArr = {projectID};
                        if (departmentWbo != null) {
                            apartmentsList = new ArrayList<>(projectMgr.getUnitsForProjects("1", "", (String) departmentWbo.getAttribute("projectID"), tempArr, null, request.getParameter("unitAreaID"), null));
                        }
                    }
                } catch (Exception ex) {
                    java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                request.setAttribute("unitAreaID", request.getParameter("unitAreaID"));
                request.setAttribute("apartmentsList", apartmentsList);
                request.setAttribute("projectsList", projectsList);
                request.setAttribute("modelsList", modelsList);
                request.setAttribute("projectID", projectID);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            //Kareem
            case 39:
                out = response.getWriter();
                wbo = new WebBusinessObject();
                //UnitPriceMgr unitPriceMgr1 = UnitPriceMgr.getInstance();
                projectMgr = ProjectMgr.getInstance();
                WebBusinessObject projectWbo1 = new WebBusinessObject();
                projectWbo1.setAttribute("projectID", request.getParameter("projectID"));
                if (request.getParameter("unitStatus") != null && !request.getParameter("unitStatus").isEmpty()) {
                    projectWbo1.setAttribute("newCode", request.getParameter("unitStatus"));
                } else {
                    projectWbo1.setAttribute("newCode", "UL");
                }
                if (projectMgr.updateRentType(projectWbo1)) {
                    wbo.setAttribute("status", "Ok");
                } else {
                    wbo.setAttribute("status", "faild");
                }

                out.write(Tools.getJSONObjectAsString(wbo));
                break;//Kareem end

            case 40:
                //servedPage = "/docs/units/rent_contract.jsp";
                servedPage = "/docs/units/Rent_Contract.jsp";
                ClientMgr clientMgr1 = ClientMgr.getInstance();
                ArrayList clientsList = null;
                projectMgr = ProjectMgr.getInstance();
                //WebBusinessObject projectWbo2 = new WebBusinessObject();
                //projectWbo2.setAttribute("projectID", request.getParameter("projectID"));
                String projectID2 = request.getParameter("projectID");
                String projectName = ((WebBusinessObject) projectMgr.getOnSingleKey(projectID2)).getAttribute("projectName").toString();
                request.setAttribute("page", servedPage);
                //this.forwardToServedPage(request, response);
                clientsList = clientMgr1.getAllClient();
                request.setAttribute("clientsList", clientsList);
                request.setAttribute("projectID", projectID2);
                request.setAttribute("projectName", projectName);
                this.forwardToServedPage(request, response);
                break;

            case 41:
                projectMgr = ProjectMgr.getInstance();
                ClientMgr clientMgr2 = ClientMgr.getInstance();
                //sequenceMgr = SequenceMgr.getInstance();
                //finTransaction2 = FinancialTransactionMgr2.getInstance();
                //finTransaction2=FinancialTransactionMgr2.getInstance();
                RentContractMgr rentCont = RentContractMgr.getInstance();

                WebBusinessObject savedWBO2 = new WebBusinessObject();
                //savedWBO2.setAttribute("contractNumber", request.getParameter("contractNumber"));
                savedWBO2.setAttribute("projectID", request.getParameter("projectID"));
                savedWBO2.setAttribute("clientID", request.getParameter("clientID"));
                savedWBO2.setAttribute("startDatee", request.getParameter("startDatee"));
                savedWBO2.setAttribute("endDatee", request.getParameter("endDatee"));
                savedWBO2.setAttribute("contractPeriod", request.getParameter("contractPeriod"));
                savedWBO2.setAttribute("monthlyRent", request.getParameter("monthlyRent"));
                savedWBO2.setAttribute("sponcer", request.getParameter("sponcer"));
                savedWBO2.setAttribute("paymentKind", request.getParameter("paymentKind"));
                try {
                    wbo = new WebBusinessObject();
                    sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
                    String newStatusCode = "61";
                    wbo.setAttribute("statusCode", newStatusCode);
                    wbo.setAttribute("date", DateAndTimeControl.getOracleDateTimeNowAsString());
                    //wbo.setAttribute("businessObjectId", request.getParameter("clientId"));
                    wbo.setAttribute("businessObjectId", request.getParameter("projectID"));
                    wbo.setAttribute("statusNote", "Rant Status");
                    wbo.setAttribute("objectType", "Housing_Units");
                    wbo.setAttribute("parentId", "UL");
                    wbo.setAttribute("issueTitle", "UL");
                    wbo.setAttribute("cuseDescription", "UL");
                    wbo.setAttribute("actionTaken", "UL");
                    wbo.setAttribute("preventionTaken", "UL");
                    IssueStatusMgr issueStatusMgr2 = IssueStatusMgr.getInstance();
                    // String status2=rentCont.saveRentContract(savedWBO2, persistentUser);

                    //if (status2.equalsIgnoreCase("ok")) {
                    if (rentCont.saveRentContract(savedWBO2, persistentUser).equalsIgnoreCase("ok") && issueStatusMgr2.changeStatus(wbo, persistentUser, null)
                            && clientMgr2.updateClientStatus(request.getParameter("clientID"), newStatusCode, (WebBusinessObject) session.getAttribute("loggedUser"))) {
                        request.setAttribute("status", "ok");
                    } else {
                        request.setAttribute("status", "no");
                    }

                    //try {
                    String projectID3 = request.getParameter("projectID");
                    String projectName1 = ((WebBusinessObject) projectMgr.getOnSingleKey(projectID3)).getAttribute("projectName").toString();
                    clientsList = clientMgr2.getAllClient();
                } catch (Exception ex) {
                    System.out.println("Exception : " + ex.getMessage());
                }

                //request.setAttribute("FAccountType", FAccountType);
                //request.setAttribute("purposeArrayList", purposeArrayList);
                //request.setAttribute("clientsList", clientsList);
                //request.setAttribute("businessID", businessID);
                String projectID3 = request.getParameter("projectID");
                String projectName1 = ((WebBusinessObject) projectMgr.getOnSingleKey(projectID3)).getAttribute("projectName").toString();
                request.setAttribute("projectID", projectID3);
                request.setAttribute("projectName", projectName1);
//                request.setAttribute("projectID", request.getParameter("projectID"));
                request.setAttribute("clientID", request.getParameter("clientID"));
                request.setAttribute("startDatee", request.getParameter("startDatee"));
                request.setAttribute("endDatee", request.getParameter("endDatee"));
                request.setAttribute("contractPeriod", request.getParameter("contractPeriod"));
                request.setAttribute("monthlyRent", request.getParameter("monthlyRent"));
                request.setAttribute("sponcer", request.getParameter("sponcer"));
                request.setAttribute("paymentKind", request.getParameter("paymentKind"));

                servedPage = "/docs/units/Rent_Contract.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 42:
                servedPage = "/docs/units/list_rented_units.jsp";
                projectMgr = ProjectMgr.getInstance();
                RentContractMgr rentCont1 = RentContractMgr.getInstance();
                apartmentsList = new ArrayList<WebBusinessObject>();
//                String fromDateS = request.getParameter("fromDate");
//                String toDateS = request.getParameter("toDate");
//                c = Calendar.getInstance();
//                sdf = new SimpleDateFormat("yyyy/MM/dd");
//                if (toDateS == null) {
//                    toDateS = sdf.format(c.getTime());
//                }
//                if (fromDateS == null) {
//                    c.add(Calendar.WEEK_OF_MONTH, -1);
//                    fromDateS = sdf.format(c.getTime());
//                }
//                DateParser dateParser = new DateParser();
//                String jsDateFormat = (String) loggedUser.getAttribute("jsDateFormat");
//                java.sql.Date fromDateD = dateParser.formatSqlDate(fromDateS, jsDateFormat);
//                java.sql.Date toDateD = dateParser.formatSqlDate(toDateS, jsDateFormat);
                try {
                    EmpRelationMgr empRelationMgr = EmpRelationMgr.getInstance();
                    loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                    WebBusinessObject managerWbo = empRelationMgr.getOnSingleKey("key2", (String) loggedUser.getAttribute("userId"));
                    WebBusinessObject departmentWbo;
                    if (managerWbo != null) {
                        departmentWbo = projectMgr.getOnSingleKey("key5", (String) managerWbo.getAttribute("mgrId"));
                    } else {
                        departmentWbo = projectMgr.getOnSingleKey("key5", (String) loggedUser.getAttribute("userId"));
                    }

                    if (departmentWbo != null) {
                        apartmentsList = new ArrayList<WebBusinessObject>(rentCont1.getAllRentedUnits());
                    }
                } catch (NoUserInSessionException ex) {
                    java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
//                request.setAttribute("fromDate", fromDateS);
//                request.setAttribute("toDate", toDateS);
                request.setAttribute("apartmentsList", apartmentsList);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 43:
                projectMgr = ProjectMgr.getInstance();

                data = new Vector();

                wbo = new WebBusinessObject();
                arrayOfItem = new ArrayList();

                numValue = "";
                formatter = new DecimalFormat("#,###.00");

                unitCode = request.getParameter("unitCode");
                clientCode = request.getParameter("clientCode");
                wboId = request.getParameter("id");

                arrayOfItem = projectMgr.getReservedUnitByUnitCodeAndClientCodeAndId(unitCode, clientCode, wboId);

                wbo.setAttribute("clientName", arrayOfItem.get(0).getAttribute("clientName"));
                wbo.setAttribute("clientAddress", arrayOfItem.get(0).getAttribute("address") == null ? "لا يوجد" : arrayOfItem.get(0).getAttribute("address"));
                wbo.setAttribute("clientJob", arrayOfItem.get(0).getAttribute("job") == null ? "لا يوجد" : arrayOfItem.get(0).getAttribute("job"));
                wbo.setAttribute("clientEmail", arrayOfItem.get(0).getAttribute("email") == null ? "لا يوجد" : arrayOfItem.get(0).getAttribute("email"));
                wbo.setAttribute("clientPhone2", arrayOfItem.get(0).getAttribute("mobile") == null ? "لا يوجد" : arrayOfItem.get(0).getAttribute("mobile"));
                wbo.setAttribute("clientPhone", arrayOfItem.get(0).getAttribute("phone") == null ? "لا يوجد" : arrayOfItem.get(0).getAttribute("phone"));
                wbo.setAttribute("clientNationalID", arrayOfItem.get(0).getAttribute("nationalID") == null ? "لا يوجد" : arrayOfItem.get(0).getAttribute("nationalID"));
                producer = "";
                if (arrayOfItem.get(0).getAttribute("nationalID") != null) {
                    if (arrayOfItem.get(0).getAttribute("nationalID").toString().contains("-")) {
                        producer = arrayOfItem.get(0).getAttribute("nationalID").toString().substring(arrayOfItem.get(0).getAttribute("nationalID").toString().indexOf("-") + 1);
                    } else {
                        producer = "لا يوجد";
                    }
                }

                wbo.setAttribute("clientNIIDProducer", arrayOfItem.get(0).getAttribute("nationalID") == null ? "لا يوجد" : producer);
                wbo.setAttribute("clientNO", arrayOfItem.get(0).getAttribute("unitCode") == null ? "لا يوجد" : arrayOfItem.get(0).getAttribute("unitCode"));
                wbo.setAttribute("downPayment", arrayOfItem.get(0).getAttribute("budget") == null ? "لا يوجد" : arrayOfItem.get(0).getAttribute("budget"));
                wbo.setAttribute("period", arrayOfItem.get(0).getAttribute("period") == null ? "لا يوجد" : arrayOfItem.get(0).getAttribute("period"));
                wbo.setAttribute("projectName", arrayOfItem.get(0).getAttribute("projectName") == null ? "لا يوجد" : arrayOfItem.get(0).getAttribute("projectName"));

//                numValue = (String) arrayOfItem.get(0).getAttribute("unitValue");
//                amount = Double.parseDouble(numValue);
                wbo.setAttribute("unitValue", arrayOfItem.get(0).getAttribute("unitValue") == null ? "" : formatter.format((String) arrayOfItem.get(0).getAttribute("unitValue")));

//                numValue = (String)arrayOfItem.get(0).getAttribute("reservationValue");
//                amount = Double.parseDouble(numValue);
                wbo.setAttribute("reservationValue", arrayOfItem.get(0).getAttribute("reservationValue") == null ? "" : formatter.format((String) arrayOfItem.get(0).getAttribute("reservationValue")));

//                numValue = (String) arrayOfItem.get(0).getAttribute("contractValue");
//                amount = Double.parseDouble(numValue);
                wbo.setAttribute("contractValue", arrayOfItem.get(0).getAttribute("contractValue") == null ? "" : formatter.format((String) arrayOfItem.get(0).getAttribute("contractValue")));

//                numValue = (String) arrayOfItem.get(0).getAttribute("beforeDis").toString();
//                amount = Double.parseDouble(numValue);
                wbo.setAttribute("beforeDis", arrayOfItem.get(0).getAttribute("beforeDis") == null ? "" : formatter.format((String) arrayOfItem.get(0).getAttribute("beforeDis").toString()));

                wbo.setAttribute("plotArea", arrayOfItem.get(0).getAttribute("plotArea") == null ? "" : arrayOfItem.get(0).getAttribute("plotArea"));
                wbo.setAttribute("buildingArea", arrayOfItem.get(0).getAttribute("buildingArea") == null ? "" : arrayOfItem.get(0).getAttribute("buildingArea"));
                wbo.setAttribute("paymentSystem", arrayOfItem.get(0).getAttribute("paymentSystem") == null ? "" : arrayOfItem.get(0).getAttribute("paymentSystem"));
                wbo.setAttribute("comments", arrayOfItem.get(0).getAttribute("comments") == null ? "" : arrayOfItem.get(0).getAttribute("comments"));
                wbo.setAttribute("floorNo", arrayOfItem.get(0).getAttribute("floorNo") == null ? "" : arrayOfItem.get(0).getAttribute("floorNo"));
                wbo.setAttribute("modelNo", arrayOfItem.get(0).getAttribute("modelNo") == null ? "" : arrayOfItem.get(0).getAttribute("modelNo"));
                wbo.setAttribute("receiptNo", arrayOfItem.get(0).getAttribute("receiptNo") == null ? "" : arrayOfItem.get(0).getAttribute("receiptNo"));
                wbo.setAttribute("unitValueText", arrayOfItem.get(0).getAttribute("unitValueText") == null ? "" : arrayOfItem.get(0).getAttribute("unitValueText"));
                wbo.setAttribute("beforeDiscountText", arrayOfItem.get(0).getAttribute("beforeDiscountText") == null ? "" : arrayOfItem.get(0).getAttribute("beforeDiscountText"));
                wbo.setAttribute("reservationValueText", arrayOfItem.get(0).getAttribute("reservationValueText") == null ? "" : arrayOfItem.get(0).getAttribute("reservationValueText"));
                wbo.setAttribute("contractValueText", arrayOfItem.get(0).getAttribute("contractValueText") == null ? "" : arrayOfItem.get(0).getAttribute("contractValueText"));
                reservationDate = arrayOfItem.get(0).getAttribute("reservationDate").toString();
                wbo.setAttribute("reservationDate", arrayOfItem.get(0).getAttribute("reservationDate") == null ? "" : reservationDate.substring(0, 10));
                wbo.setAttribute("employee", arrayOfItem.get(0).getAttribute("employee") == null ? "" : arrayOfItem.get(0).getAttribute("employee"));
                //String[] isBuildingOrVila = ((String) wbo.getAttribute("clientNO")).split("-");
                isBuildingOrVila = ((String) wbo.getAttribute("clientNO")).split(" ");
                buildingNumber = "";
                unitNumber = "";

                projID = arrayOfItem.get(0).getAttribute("mainProjectId").toString();
                unitNo = wbo.getAttribute("clientNO").toString();
                unitLen = unitNo.length();

                WebBusinessObject p = projectMgr.getOnSingleKey(projID);
                projectName = p.getAttribute("projectName").toString();
                buildingNumber = unitNo;
                unitNumber = unitNo;

                wbo.setAttribute("buildingNumber", buildingNumber);
                wbo.setAttribute("unitNumber", unitNumber);

                // yasmin - change to comapny caused an error on this point
                // for non - company customers
                mainProject = projectMgr.getOnSingleKey(request.getParameter("companyId").toString());
                report = "clientUnitSheet";
                /* if (!(mainProject.getAttribute("optionOne")).equals("UL")) {
                 report = (String) mainProject.getAttribute("optionOne");
                 }*/
                map = new HashMap();

                /*
                 To add The Logo
                 */
                unitDocMgr = UnitDocMgr.getInstance();
                imagesList = new ArrayList<WebBusinessObject>();
                imagesList = unitDocMgr.getLogosWithProjectID((String) arrayOfItem.get(0).getAttribute("mainProjectId"));
                absPath = "";
                if (!imagesList.isEmpty()) {
                    String random = UniqueIDGen.getNextID();
                    int len = random.length();

                    String randFileName = "ran" + random.substring(5, len) + ".jpeg";

                    String userHome = (String) loggedUser.getAttribute("userHome");
                    String imageDirPath = getServletContext().getRealPath("/images");
                    String userImageDir = imageDirPath + "/" + userHome;

                    String RIPath = userImageDir + "/" + randFileName;

                    absPath = "images/" + userHome + "/" + randFileName;
                    System.out.println(RIPath + " / " + absPath);
                    File docImage = new File(RIPath);
                    BufferedInputStream gifData = new BufferedInputStream(unitDocMgr.getImage((String) imagesList.get(0).getAttribute("docID")));
                    BufferedImage myImage = ImageIO.read(gifData);
                    ImageIO.write(myImage, "jpeg", docImage);
                    wbo.setAttribute("logo", RIPath);
                }

                data.add(wbo);
                Tools.createPdfReport(report, map, data, getServletConfig().getServletContext(), response, request);
                break;
            case 44:
                UnitTimelineMgr unitTimelineMgr = UnitTimelineMgr.getInstance();
                ArrayList<WebBusinessObject> timeLine = new ArrayList<WebBusinessObject>();
                String unitID = request.getParameter("projectId");
                if (unitID != null) {
                    boolean save = false;
                    try {
                        timeLine = new ArrayList<WebBusinessObject>(unitTimelineMgr.getOnArbitraryKey(unitID, "key1"));
                    } catch (Exception ex) {
                        java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }

                    request.setAttribute("timeLine", timeLine);
                    WebBusinessObject unitTimeWbo = new WebBusinessObject();
                    String ChoosenDate = request.getParameter("ChoosenDate");
                    String dateType = request.getParameter("dateType");
                    unitTimeWbo.setAttribute("UNIT_ID", unitID);
                    unitTimeWbo.setAttribute("UNIT_DATE", ChoosenDate);
                    unitTimeWbo.setAttribute("DATE_TYPE", dateType);
                    if (unitTimelineMgr.saveObject(unitTimeWbo, loggedUser)) {
                        save = true;
                    }

                    request.setAttribute("statusUpdate", save ? "ok" : "failed");
                }

                this.forward("/UnitServlet?op=listApartments", request, response);
                break;

            case 45:
                servedPage = "/docs/projects/view_unit_details.jsp";
                unitID = request.getParameter("projectID");
                unitTimelineMgr = UnitTimelineMgr.getInstance();
                String timeLineID = request.getParameter("timeLineID");
                if (timeLineID != null) {
                    boolean save = false;
                    if (unitTimelineMgr.deleteTimeLine(timeLineID)) {
                        save = true;
                    }
                    request.setAttribute("statusUpdate", save ? "ok" : "failed");
                }

                unitTimelineMgr = UnitTimelineMgr.getInstance();
                timeLine = new ArrayList<WebBusinessObject>();
                try {
                    timeLine = new ArrayList<WebBusinessObject>(unitTimelineMgr.getOnArbitraryKey(unitID, "key1"));
                } catch (Exception ex) {
                    java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                request.setAttribute("timeLine", timeLine);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 46:
                servedPage = "/docs/projects/view_unit_details.jsp";
                unitID = request.getParameter("projectID");
                WebBusinessObject unitTimeWbo = new WebBusinessObject();
                String ChoosenDate = request.getParameter("ChoosenDate");
                String dateType = request.getParameter("dateType");
                unitTimeWbo.setAttribute("UNIT_ID", unitID);
                unitTimeWbo.setAttribute("UNIT_DATE", ChoosenDate);
                unitTimeWbo.setAttribute("DATE_TYPE", dateType);
                unitTimelineMgr = UnitTimelineMgr.getInstance();
                timeLineID = request.getParameter("timeLineID");
                if (timeLineID != null) {
                    boolean save = false;
                    if (unitTimelineMgr.editTimeLine(timeLineID, unitTimeWbo, loggedUser)) {
                        save = true;
                    }

                    request.setAttribute("statusUpdate", save ? "ok" : "failed");
                }

                unitTimelineMgr = UnitTimelineMgr.getInstance();
                timeLine = new ArrayList<WebBusinessObject>();
                try {
                    timeLine = new ArrayList<WebBusinessObject>(unitTimelineMgr.getOnArbitraryKey(unitID, "key1"));
                } catch (Exception ex) {
                    java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                request.setAttribute("timeLine", timeLine);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 47:
                unitTimelineMgr = UnitTimelineMgr.getInstance();
                unitID = request.getParameter("unitID");
                unitTimeWbo = new WebBusinessObject();
                wbo = new WebBusinessObject();
                if (unitID != null) {
                    boolean save = true;
                    unitTimeWbo.setAttribute("UNIT_DATE", request.getParameter("unitTime"));
                    unitTimeWbo.setAttribute("DATE_TYPE", request.getParameter("dateType"));
                    for (String tempID : unitID.split(",")) {
                        unitTimeWbo.setAttribute("UNIT_ID", tempID);
                        save &= unitTimelineMgr.saveObject(unitTimeWbo, loggedUser);
                    }

                    wbo.setAttribute("status", save ? "ok" : "failed");
                }

                out = response.getWriter();
                out.write(Tools.getJSONObjectAsString(wbo));
                break;

            case 48:
                servedPage = "docs/units/payment_plan.jsp";

                projectMgr = ProjectMgr.getInstance();
                unitID = request.getParameter("unitID");
                String prjID = projectMgr.getOnSingleKey(unitID).getAttribute("mainProjId").toString();
                String typ = request.getParameter("typ");

                StandardPaymentPlanMgr standardPaymentPlanMgr = new StandardPaymentPlanMgr();

                ArrayList<WebBusinessObject> PaymentPlamsLst = new ArrayList<WebBusinessObject>();
                PaymentPlamsLst = standardPaymentPlanMgr.getPayPlansToProject(prjID, typ);

                request.setAttribute("PaymentPlamsLst", PaymentPlamsLst);

                projectMgr = ProjectMgr.getInstance();
                unitWbo = projectMgr.getOnSingleKey(unitID);

                projectWbo = projectMgr.getOnSingleKey((String) unitWbo.getAttribute("mainProjId"));
                ProjectAccountingMgr projectAccMgr = ProjectAccountingMgr.getInstance();
                ProjectEntityMgr projectEntityMgr = ProjectEntityMgr.getInstance();
                WebBusinessObject projectAcc = new WebBusinessObject();
                WebBusinessObject grageWbo = new WebBusinessObject();
                WebBusinessObject lockerWbo = new WebBusinessObject();
                try {
                    projectAcc = projectAccMgr.getProjectAccount((String) projectWbo.getAttribute("projectID"));
                } catch (UnsupportedConversionException ex) {
                    java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                if (projectAcc.getAttribute("garageNumber") != null && Integer.parseInt(projectAcc.getAttribute("garageNumber").toString()) > 0) {
                    try {
                        grageWbo = projectEntityMgr.getEntityByType((String) projectAcc.getAttribute("projectAccId"), "garage");
                    } catch (UnsupportedTypeException ex) {
                        java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }

                if (projectAcc.getAttribute("lockerNumber") != null && Integer.parseInt(projectAcc.getAttribute("lockerNumber").toString()) > 0) {
                    try {
                        lockerWbo = projectEntityMgr.getEntityByType((String) projectAcc.getAttribute("projectAccId"), "locker");
                    } catch (UnsupportedTypeException ex) {
                        java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }

                unitPriceWbo = UnitPriceMgr.getInstance().getLastPriceForUnit(unitID);

                unitTimelineMgr = UnitTimelineMgr.getInstance();
                WebBusinessObject datewbo = unitTimelineMgr.getSpecificUnitDate(unitID, "finishing");

                ClientMgr clientMgr = ClientMgr.getInstance();

                Vector client = new Vector();
                clientID = request.getParameter("clientID");
                try {
                    client = clientMgr.clientByName(clientID, "id");
                } catch (SQLException ex) {
                    java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                standardPaymentPlanMgr = StandardPaymentPlanMgr.getInstance();
                ArrayList<WebBusinessObject> sPayPlanLst = standardPaymentPlanMgr.getStandaredPayPlans(prjID, typ);

                request.setAttribute("typ", typ);
                request.setAttribute("sPayPlanLst", sPayPlanLst);
                request.setAttribute("unitWbo", unitWbo);
                request.setAttribute("projectWbo", projectWbo);
                request.setAttribute("unitPriceWbo", unitPriceWbo);
                request.setAttribute("grageWbo", grageWbo);
                request.setAttribute("lockerWbo", lockerWbo);
                request.setAttribute("datewbo", datewbo);
                request.setAttribute("client", client);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 49:
                servedPage = "docs/units/installments_plan.jsp";

                unitID = request.getParameter("unitID");
                clientID = request.getParameter("myClientID");
                String planName = request.getParameter("planID");   //planA planB...

                String resAmnt = request.getParameter("resID"); //reservation precentage
                String resDate = request.getParameter("resDate");

                String downPayAmnt = request.getParameter("downPayID"); //downpayment precentage
                String downDate = request.getParameter("downDate");

                String insPayAmntSys = request.getParameter("insPayID");   //monthly   Quarterly...
                String insDate = request.getParameter("insDate");
                String insNo = request.getParameter("insNumVal");   //installments Number

                String sPlanID = request.getParameter("sPlanID");   //planID
                String type = request.getParameter("typ");   //plan type

                String dis = request.getParameter("disID");

                loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");

                String insPayAmt = request.getParameter("insPriceCell");

                PaymentPlanMgr paymentPlanMgr = PaymentPlanMgr.getInstance();
                String planID = null;

                String finalPrice = request.getParameter("priceCellInsSys");

                String grageInfo = request.getParameter("grageInfo") != null ? request.getParameter("grageInfo") : "";
                String lockerInfo = request.getParameter("lockerInfo") != null ? request.getParameter("lockerInfo") : "";
                String entitiesInfo = new String();
                String str[] = null;
                if (grageInfo != null && !grageInfo.equals("")) {
                    entitiesInfo = grageInfo;
                    str = grageInfo.split("-");
                    request.setAttribute("garage", str[0]);
                    request.setAttribute("garagePrice", str[1]);
                }

                if (lockerInfo != null && !lockerInfo.equals("")) {
                    if (entitiesInfo.length() > 0) {
                        entitiesInfo = entitiesInfo + "/";
                    }

                    entitiesInfo = entitiesInfo + lockerInfo;
                    str = lockerInfo.split("-");
                    request.setAttribute("locker", str[0]);
                    request.setAttribute("lockerPrice", str[1]);
                }

                String exceedTolerance = request.getParameter("et");

                try {
                    planID = paymentPlanMgr.saveObject(unitID, clientID, planName, resAmnt, downPayAmnt, downDate, insPayAmntSys, insDate, insNo, dis, (String) loggedUser.getAttribute("userId"), finalPrice, entitiesInfo, sPlanID, exceedTolerance != null && exceedTolerance.equals("true") ? "et" : type);
                } catch (SQLException ex) {
                    java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                String resPrice = request.getParameter("resPriceCell");
                String downPayPrice = request.getParameter("downPayPriceCell");
                String payType = new String();
                try {
                    if (resPrice != null || !resPrice.equals("")) {
                        payType = "reservarion";
                        resDate = paymentPlanMgr.createInstallments(planID, resDate, 0, planName + " " + payType, resPrice, insPayAmntSys, (String) loggedUser.getAttribute("userId"), payType);
                    }

                    if (downPayPrice != null || !downPayPrice.equals("")) {
                        payType = "downPayment";
                        downDate = paymentPlanMgr.createInstallments(planID, downDate, 0, planName + " " + payType, downPayPrice, insPayAmntSys, (String) loggedUser.getAttribute("userId"), payType);
                    }

                    for (int i = 0; i < Integer.parseInt(insNo); i++) {
                        payType = "installment";
                        insDate = paymentPlanMgr.createInstallments(planID, insDate, i, planName + " " + payType + Integer.toString(i + 1), insPayAmt, insPayAmntSys, (String) loggedUser.getAttribute("userId"), payType);
                    }
                    if ("spp".equals(type)) {
                        paymentPlanMgr.approvePaymentPlan(planID, session);
                    }
                } catch (SQLException ex) {
                    java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                projectMgr = ProjectMgr.getInstance();
                unitWbo = projectMgr.getOnSingleKey(unitID);

                projectWbo = projectMgr.getOnSingleKey((String) unitWbo.getAttribute("mainProjId"));

                unitPriceWbo = UnitPriceMgr.getInstance().getLastPriceForUnit(unitID);

                unitTimelineMgr = UnitTimelineMgr.getInstance();
                datewbo = unitTimelineMgr.getSpecificUnitDate(unitID, "finishing");

                clientMgr = ClientMgr.getInstance();
                client = new Vector();
                try {
                    client = clientMgr.clientByName(clientID, "id");
                } catch (SQLException ex) {
                    java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                ArrayList<WebBusinessObject> insPlanLst = new ArrayList<WebBusinessObject>();
                try {
                    insPlanLst = paymentPlanMgr.getInstallmentPlan(planID);
                } catch (Exception ex) {
                    java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                request.setAttribute("projectWbo", projectWbo);
                request.setAttribute("unitWbo", unitWbo);

                request.setAttribute("priceCellInsSys", finalPrice);
                request.setAttribute("unitPriceWbo", unitPriceWbo);
                request.setAttribute("datewbo", datewbo);

                request.setAttribute("client", client);

                request.setAttribute("resPriceCell", resPrice);
                request.setAttribute("resDate", request.getParameter("resDate"));

                request.setAttribute("downPayPriceCell", downPayPrice);
                request.setAttribute("downDate", downDate);

                request.setAttribute("insPlanLst", insPlanLst);

                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 50:
                clientID = request.getParameter("clientID");
                planID = request.getParameter("planID");

                paymentPlanMgr = PaymentPlanMgr.getInstance();

                Boolean delete = false;
                try {
                    delete = paymentPlanMgr.detelePlan("PAYMENT_PLAN", planID);
                } catch (SQLException ex) {
                    java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                if (!delete) {
                    try {
                        delete = paymentPlanMgr.detelePlan("PAYMENT_PLAN_DETAILS", planID);
                    } catch (SQLException ex) {
                        java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
                this.forward("UnitServlet?op=displaypaymentPlans&clientID=" + clientID, request, response);
                break;

            case 51:
                servedPage = "docs/units/paymentPlanLst.jsp";

                clientID = request.getParameter("clientID");
                clientMgr = ClientMgr.getInstance();
                client = new Vector();
                try {
                    client = clientMgr.clientByName(clientID, "id");
                } catch (SQLException ex) {
                    java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                paymentPlanMgr = PaymentPlanMgr.getInstance();
                ArrayList<WebBusinessObject> planLst = new ArrayList<WebBusinessObject>();
                try {
                    planLst = paymentPlanMgr.getPayPlan(clientID);
                } catch (Exception ex) {
                    java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                projectMgr = ProjectMgr.getInstance();
                ArrayList<WebBusinessObject> unitLst = new ArrayList<>();
                for (int i = 0; i < planLst.size(); i++) {
                    unitWbo = projectMgr.getOnSingleKey((String) planLst.get(i).getAttribute("unitID"));
                    unitLst.add(unitWbo);
                }

                request.setAttribute("clientID", clientID);
                request.setAttribute("planLst", planLst);
                request.setAttribute("unitLst", unitLst);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 52:
                servedPage = "docs/units/installments_plan.jsp";

                clientID = request.getParameter("clientID");
                planID = request.getParameter("planID");

                unitID = new String();
                finalPrice = new String();
                paymentPlanMgr = PaymentPlanMgr.getInstance();
                try {
                    unitID = (String) paymentPlanMgr.getPayPlanDetails(planID).getAttribute("unitID");
                    finalPrice = (String) paymentPlanMgr.getPayPlanDetails(planID).getAttribute("finalPrice");
                } catch (Exception ex) {
                    java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                projectMgr = ProjectMgr.getInstance();
                unitWbo = projectMgr.getOnSingleKey(unitID);

                projectWbo = projectMgr.getOnSingleKey((String) unitWbo.getAttribute("mainProjId"));

                unitPriceWbo = UnitPriceMgr.getInstance().getLastPriceForUnit(unitID);

                unitTimelineMgr = UnitTimelineMgr.getInstance();
                datewbo = unitTimelineMgr.getSpecificUnitDate(unitID, "finishing");

                clientMgr = ClientMgr.getInstance();
                client = new Vector();
                try {
                    client = clientMgr.clientByName(clientID, "id");
                } catch (SQLException ex) {
                    java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                insPlanLst = new ArrayList<WebBusinessObject>();
                try {
                    insPlanLst = paymentPlanMgr.getInstallmentPlan(planID);
                } catch (Exception ex) {
                    java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                resPrice = new String();
                resDate = new String();
                downPayPrice = new String();
                downDate = new String();
                for (int i = 0; i < insPlanLst.size(); i++) {
                    if (insPlanLst.get(i).getAttribute("payType").equals("reservarion")) {
                        resPrice = (String) insPlanLst.get(i).getAttribute("insAMT");
                        resDate = (String) insPlanLst.get(i).getAttribute("insDate");
                    }

                    if (insPlanLst.get(i).getAttribute("payType").equals("downPayment")) {
                        downPayPrice = (String) insPlanLst.get(i).getAttribute("insAMT");
                        downDate = (String) insPlanLst.get(i).getAttribute("insDate");
                    }
                }

                request.setAttribute("projectWbo", projectWbo);
                request.setAttribute("unitWbo", unitWbo);
                request.setAttribute("priceCellInsSys", finalPrice);
                request.setAttribute("unitPriceWbo", unitPriceWbo);
                request.setAttribute("datewbo", datewbo);

                request.setAttribute("client", client);

                request.setAttribute("resPriceCell", resPrice);
                request.setAttribute("resDate", resDate);

                request.setAttribute("downPayPriceCell", downPayPrice);
                request.setAttribute("downDate", downDate);

                request.setAttribute("insPlanLst", insPlanLst);

                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 53:
                servedPage = "docs/units/PaymentPlanSystem.jsp";

                String save = request.getParameter("save");
                String saveC = "no";
                standardPaymentPlanMgr = new StandardPaymentPlanMgr();

                projectID = request.getParameter("projectID");
                planName = request.getParameter("planID");
                resAmnt = request.getParameter("resID");
                String resIDMin = request.getParameter("resIDMin");
                String resIDMax = request.getParameter("resIDMax");
                downPayAmnt = request.getParameter("downPayID");
                String downPayIDMin = request.getParameter("downPayIDMin");
                String downPayIDMax = request.getParameter("downPayIDMax");
                String downMnth = request.getParameter("downMonNum");
                insPayAmntSys = request.getParameter("insPayID");
                String insMnth = request.getParameter("insMonNum");
                insNo = request.getParameter("insNum");
                String insPayIDSelect = request.getParameter("insPayIDSelect");
                String insPayIDInput = request.getParameter("insPayIDInput");

                String insAmt = null;
                if (insPayIDInput != null && !insPayIDInput.equalsIgnoreCase("0") && !insPayIDInput.equalsIgnoreCase("") && !insPayIDInput.equalsIgnoreCase(" ")) {
                    insAmt = request.getParameter("insPayIDInput").toString().split("%")[0];
                } else if (insPayIDSelect != null && !insPayIDSelect.equalsIgnoreCase("0")) {
                    insAmt = request.getParameter("insPayIDSelect");
                }

                String insPayIDSelectMin = request.getParameter("insPayIDSelectMin");
                String insPayIDSelectMax = request.getParameter("insPayIDSelectMax");
                loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");

                planID = "";

                if (save != null && save.equals("yes")) {
                    save = "yes";

                    try {
                        planID = standardPaymentPlanMgr.saveObject(planName, resAmnt, downPayAmnt, downMnth, insPayAmntSys, insMnth, insNo, (String) loggedUser.getAttribute("userId"), insAmt, projectID, null, null, null);
                        if (standardPaymentPlanMgr.saveStndrPymntPlnRng(planID, resIDMin, resIDMax, downPayIDMin, downPayIDMax, insPayIDSelectMin, insPayIDSelectMax)) {
                            save = "yes";
                            saveC = "yes";
                            request.setAttribute("saveC", saveC);
                            this.forward("/UnitServlet?op=viewAllBasicPayPlns", request, response);
                            break;
                        } else {
                            save = "no";
                        }
                    } catch (SQLException ex) {
                        java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
                projectMgr = ProjectMgr.getInstance();
                 {
                    try {
                        ArrayList<WebBusinessObject> projectsLst = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKey("44", "key4"));
                        request.setAttribute("projectsLst", projectsLst);
                    } catch (Exception ex) {
                        java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
                request.setAttribute("save", save);

                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 54:
                String clientId = request.getParameter("clientId");
                String operation = request.getParameter("operation");

                projectMgr = ProjectMgr.getInstance();
                String json = new String();

                if (operation != null && operation.equals("save")) {
                    String floorNum = request.getParameter("floorNum") != null ? request.getParameter("floorNum") : " ";
                    String roomNum = request.getParameter("roomNum") != null ? request.getParameter("roomNum") : " ";
                    String model = request.getParameter("model") != null ? request.getParameter("model") : " ";
                    String optionOne = "Floor:" + floorNum + "Room:" + roomNum + "Model:" + model;

                    WebBusinessObject asset = new WebBusinessObject();
                    asset.setAttribute("projectName", request.getParameter("assetCod"));
                    asset.setAttribute("projectDesc", request.getParameter("assetTitle"));
                    asset.setAttribute("mainPrjID", request.getParameter("parentPrj"));
                    asset.setAttribute("optionOne", optionOne);
                    asset.setAttribute("equClassID", request.getParameter("equClassID"));

                    loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                    try {
                        if (projectMgr.addAsset(asset, (String) loggedUser.getAttribute("userId"))) {
                            json = "yes";
                        } else {
                            json = "no";
                        }
                    } catch (NoUserInSessionException ex) {
                        java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                        json = "no";
                    }

                    request.setAttribute("saveFlag", json);
                    servedPage = "docs/units/Add_Asset.jsp";
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                } else if (clientId != null && !clientId.equals("")) {
                    ArrayList<WebBusinessObject> projectLst = new ArrayList<>();

                    try {
                        projectLst = projectMgr.getAllProjectForClient(clientId);
                    } catch (Exception ex) {
                        java.util.logging.Logger.getLogger(SearchServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }

                    request.setAttribute("clientId", request.getParameter("clientId"));
                    out = response.getWriter();
                    json = Tools.getJSONArrayAsString(projectLst);
                    out.write(json);
                } else {
                    servedPage = "docs/units/Add_Asset.jsp";

                    clientMgr = ClientMgr.getInstance();

                    try {
                        clientsList = new ArrayList<>(clientMgr.getOwnerClients());
                    } catch (Exception ex) {
                        clientsList = new ArrayList<>();
                    }

                    request.setAttribute("clientsList", clientsList);

                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                }
                break;

            case 55:
                servedPage = "docs/units/assetreport.jsp";
                projectMgr = ProjectMgr.getInstance();
                if (request.getParameter("myOp") != null && request.getParameter("myOp").equals("up")) {
                    wbo = new WebBusinessObject();

                    String optionone = "Floor:" + request.getParameter("flo").toString() + "Room:" + request.getParameter("rom").toString() + "Model:" + request.getParameter("mod").toString();
                    //String optiontwo=request.getParameter("bbrr");
                    String classs = request.getParameter("sel");
                    String assetId = request.getParameter("id");

                    projectMgr = ProjectMgr.getInstance();
                    boolean isupdate = projectMgr.updateassets(optionone, null, classs, assetId);
                } else if (request.getParameter("myOp") != null && request.getParameter("myOp").equals("de")) {
                    wbo = new WebBusinessObject();
                    String assetID = request.getParameter("id");
                    projectMgr = ProjectMgr.getInstance();
                    boolean isdel = projectMgr.delasset(assetID);
                } else if (request.getParameter("myOp") != null && request.getParameter("myOp").equals("upBranch")) {
                    wbo = new WebBusinessObject();
                    String assetID = request.getParameter("id");
                    String optiontwo = request.getParameter("bbrr");

                    projectMgr = ProjectMgr.getInstance();
                    boolean isupdate = projectMgr.updateassets(null, optiontwo, null, assetID);
                }

                ArrayList<WebBusinessObject> rooo = (ArrayList<WebBusinessObject>) projectMgr.getassetreports();
                request.setAttribute("rowdata", rooo);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 56:
                servedPage = "/docs/units/deleteUnit.jsp";
                projectMgr = ProjectMgr.getInstance();
                delete = false;
                String flag = "";
                if (request.getParameter("del") != null && request.getParameter("del").equals("1")) {
                    String untIDs[] = request.getParameter("vals").split(",");
                    //String untIDsCheck[] = request.getParameterValues("deleteThis");
                    String checked = request.getParameter("action");
                    String checkedKey = "";
                    if (checked.equals("lock")) {
                        checkedKey = "Y";
                    } else if (checked.equals("unlock")) {
                        checkedKey = "N";
                    }

                    for (int i = 0; i < untIDs.length; i++) {
                        if (projectMgr.updateOnSingleKeyClose("key10", "key", checkedKey, untIDs[i])) {
                            request.setAttribute("status", "ok");
                        } else {
                            request.setAttribute("status", "fail");
                            break;
                        }
                    }
                }

                String mainPrj = request.getParameter("mainPrj");
                unitLst = projectMgr.getAllUnitInfo(mainPrj);

                request.setAttribute("unitLst", unitLst);
                request.setAttribute("mainPrj", mainPrj);
                try {
                    request.setAttribute("projctLst", new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKey("44", "key4")));
                } catch (Exception ex) {
                    java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                    request.setAttribute("projctLst", new ArrayList<WebBusinessObject>());
                }

                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 57:
                projectID = request.getParameter("projectID");
                modelsList = new ArrayList<>();
                projectMgr = ProjectMgr.getInstance();
                try {
                    modelsList = new ArrayList<>(projectMgr.getModels(projectID));
                } catch (Exception ex) {
                    logger.error(ex);
                }

                out = response.getWriter();
                wbo = new WebBusinessObject();
                wbo.setAttribute("test 1", "1");
                wbo.setAttribute("test 2", "2");
                wbo.setAttribute("test 3", "3");
                wbo.setAttribute("test 4", "4");
                json = Tools.getJSONArrayAsString(modelsList);
                System.out.println(json);
                out.write(json);
                break;

            case 58:
                projectMgr = ProjectMgr.getInstance();
                clientProductMgr = ClientProductMgr.getInstance();
                issueStatusMgr = IssueStatusMgr.getInstance();
                reservationMgr = ReservationMgr.getInstance();
                out = response.getWriter();
                wbo = new WebBusinessObject();
                wbo.setAttribute("status", "fail");
                unitID = request.getParameter("unitID");
                unitWbo = projectMgr.getOnSingleKey(unitID);
                try {
                    ArrayList<WebBusinessObject> clientUnitList = new ArrayList<>(clientProductMgr.getOnArbitraryKeyOracle(unitID, "key2"));
                    if (!clientUnitList.isEmpty()) {
                        if ("purche".equals(clientUnitList.get(0).getAttribute("productId"))) {
                            wbo.setAttribute("status", "purchase");
                        } else {
                            wbo.setAttribute("status", "reserved");
                        }
                    } else if (projectMgr.deleteOnSingleKey(unitID)) {
                        wbo.setAttribute("status", "ok");
                        clientProductMgr.deleteOnArbitraryKey(unitID, "key2");
                        issueStatusMgr.deleteOnArbitraryKey(unitID, "key1");
                        reservationMgr.deleteOnArbitraryKey(unitID, "key2");
                        if (unitWbo != null) {
                            LoggerMgr loggerMgr = LoggerMgr.getInstance();
                            WebBusinessObject loggerWbo = new WebBusinessObject();
                            loggerWbo.setAttribute("objectXml", unitWbo.getObjectAsXML());
                            loggerWbo.setAttribute("realObjectId", unitWbo.getAttribute("projectID"));
                            loggerWbo.setAttribute("userId", persistentUser.getAttribute("userId"));
                            loggerWbo.setAttribute("objectName", unitWbo.getAttribute("projectName"));
                            loggerWbo.setAttribute("loggerMessage", "Deleting Unit");
                            loggerWbo.setAttribute("eventName", "Delete Unit");
                            loggerWbo.setAttribute("objectTypeId", "8");
                            loggerWbo.setAttribute("eventTypeId", "1");
                            loggerWbo.setAttribute("ipForClient", getClientIpAddr(request));
                            loggerMgr.saveObject(loggerWbo);
                        }
                    }
                } catch (Exception ex) {
                    java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                out.write(Tools.getJSONObjectAsString(wbo));
                break;

            case 59:
                servedPage = "/docs/client/addPartners.jsp";

                String oClntID = request.getParameter("oClntID");
                unitCode = request.getParameter("unitCode");
                ArrayList<WebBusinessObject> clntLst = new ArrayList<WebBusinessObject>();

                String reserv = "no";
                if (request.getParameter("srch") != null && request.getParameter("srch").equals("1")) {
                    clientMgr = ClientMgr.getInstance();
                    clntLst = clientMgr.getPartnerClient(request.getParameter("vl").toString(), oClntID);
                } else if (request.getParameter("srch") != null && request.getParameter("srch").equals("0")) {
                    String clntIDLst[] = request.getParameterValues("slct");

                    clientProductMgr = ClientProductMgr.getInstance();
                    WebBusinessObject clientProductWbo = clientProductMgr.getReservedlientProduct(oClntID, unitCode);

                    loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                    loggegUserId = (String) loggedUser.getAttribute("userId");
                    clientProductWbo.setAttribute("createdBy", loggegUserId);

                    clientMgr = ClientMgr.getInstance();
                    issueStatusMgr = IssueStatusMgr.getInstance();

                    wbo = new WebBusinessObject();
                    sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
                    String newStatusCode = "11";
                    wbo.setAttribute("statusCode", newStatusCode);
                    wbo.setAttribute("date", sdf.format(Calendar.getInstance().getTime()));
                    wbo.setAttribute("statusNote", "Customer Status");
                    wbo.setAttribute("objectType", "client");
                    wbo.setAttribute("parentId", "UL");
                    wbo.setAttribute("issueTitle", "UL");
                    wbo.setAttribute("cuseDescription", "UL");
                    wbo.setAttribute("actionTaken", "UL");
                    wbo.setAttribute("preventionTaken", "UL");

                    persistentUser = (WebBusinessObject) PersistentSessionMgr.getInstance().getOnSingleKey(remoteAccess);
                    for (int i = 0; i < clntIDLst.length; i++) {
                        clientProductWbo.setAttribute("clientId", clntIDLst[i]);
                        wbo.setAttribute("businessObjectId", clntIDLst[i]);
                        if (clientProductMgr.saveClientProductPartner(clientProductWbo)) {
                            try {
                                if (issueStatusMgr.changeStatus(wbo, persistentUser, null) && clientMgr.updateClientStatus(clntIDLst[i], "11", loggedUser)) {
                                    reserv = "yes";
                                } else {
                                    break;
                                }
                            } catch (SQLException ex) {
                                break;
                            }
                        } else {
                            break;
                        }
                    }

                    request.setAttribute("clientProductWbo", clientProductWbo);
                }

                if (request.getParameter("srch") != null && request.getParameter("srch").equals("0")) {
                    request.setAttribute("reserv", reserv);
                    this.forward("/UnitServlet?op=reservedUnitsReport", request, response);
                } else {
                    request.setAttribute("oClntID", oClntID);
                    request.setAttribute("unitCode", unitCode);
                    request.setAttribute("srchVl", request.getParameter("vl"));
                    request.setAttribute("clntLst", clntLst);
                    request.setAttribute("page", servedPage);

                    this.forward(servedPage, request, response);
                }
                break;

            case 60:
                servedPage = "/docs/units/employee_reserved_units.jsp";
                reservationMgr = ReservationMgr.getInstance();
                try {
                    fromDateS = request.getParameter("fromDate");
                    toDateS = request.getParameter("toDate");
                    String userID = request.getParameter("userID");
                    String departmentID = request.getParameter("departmentID");
                    c = Calendar.getInstance();
                    sdf = new SimpleDateFormat("yyyy/MM/dd");
                    if (toDateS == null) {
                        toDateS = sdf.format(c.getTime());
                    }

                    if (fromDateS == null) {
                        c.add(Calendar.MONTH, -1);
                        fromDateS = sdf.format(c.getTime());
                    }

                    dateParser = new DateParser();
                    jsDateFormat = (String) loggedUser.getAttribute("jsDateFormat");
                    fromDateD = dateParser.formatSqlDate(fromDateS, jsDateFormat);
                    toDateD = dateParser.formatSqlDate(toDateS, jsDateFormat);
                    ArrayList<WebBusinessObject> departments = new ArrayList<>();
                    projectMgr = ProjectMgr.getInstance();
                    ArrayList<WebBusinessObject> userDepartments;
                    try {
                        userDepartments = new ArrayList<>(UserDepartmentConfigMgr.getInstance().getOnArbitraryKeyOracle((String) loggedUser.getAttribute("userId"), "key2"));
                        for (WebBusinessObject userDepartmentWbo : userDepartments) {
                            departments.add(projectMgr.getOnSingleKey((String) userDepartmentWbo.getAttribute("department_id")));
                        }

                        if (departments.isEmpty()) {
                            WebBusinessObject wboTemp = new WebBusinessObject();
                            wboTemp.setAttribute("projectName", "لا يوجد");
                            wboTemp.setAttribute("projectID", "none");
                            departments.add(wboTemp);
                            list = new ArrayList<>();
                        } else {
                            if (departmentID == null) {
                                departmentID = (String) departments.get(0).getAttribute("projectID");
                            }
                        }

                        request.setAttribute("departments", departments);
                    } catch (Exception ex) {
                        java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }

                    request.setAttribute("reservationsList", reservationMgr.getReservedUnits(fromDateD, toDateD, departmentID, userID));
                    request.setAttribute("fromDate", fromDateS);
                    request.setAttribute("toDate", toDateS);
                    request.setAttribute("userID", userID);
                    request.setAttribute("departmentID", departmentID);
                } catch (NoUserInSessionException ex) {
                    java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 61:
                servedPage = "/docs/units/viewMyPurchUnits.jsp";
                fromDateS = request.getParameter("fromDate");
                toDateS = request.getParameter("toDate");
                c = Calendar.getInstance();
                sdf = new SimpleDateFormat("yyyy/MM/dd");
                if (toDateS == null) {
                    toDateS = sdf.format(c.getTime());
                }

                if (fromDateS == null) {
                    c.add(Calendar.MONTH, -1);
                    fromDateS = sdf.format(c.getTime());
                }

                clientProductMgr = ClientProductMgr.getInstance();
                dateParser = new DateParser();
                jsDateFormat = (String) loggedUser.getAttribute("jsDateFormat");
                fromDateD = dateParser.formatSqlDate(fromDateS, jsDateFormat);
                toDateD = dateParser.formatSqlDate(toDateS, jsDateFormat);
                reservationMgr = ReservationMgr.getInstance();
                request.setAttribute("unitsList", clientProductMgr.viewMyPurchUnits(session, fromDateD, toDateD));
                request.setAttribute("fromDate", fromDateS);
                request.setAttribute("toDate", toDateS);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 62:
                servedPage = "/docs/units/viewSalesUnits.jsp";
                fromDateS = request.getParameter("fromDate");
                toDateS = request.getParameter("toDate");
                c = Calendar.getInstance();
                sdf = new SimpleDateFormat("yyyy/MM/dd");
                if (toDateS == null) {
                    toDateS = sdf.format(c.getTime());
                }

                if (fromDateS == null) {
                    c.add(Calendar.MONTH, -1);
                    fromDateS = sdf.format(c.getTime());
                }

                clientProductMgr = ClientProductMgr.getInstance();
                dateParser = new DateParser();
                jsDateFormat = (String) loggedUser.getAttribute("jsDateFormat");
                fromDateD = dateParser.formatSqlDate(fromDateS, jsDateFormat);
                toDateD = dateParser.formatSqlDate(toDateS, jsDateFormat);
                reservationMgr = ReservationMgr.getInstance();
                request.setAttribute("unitsList", clientProductMgr.viewSalesUnits(fromDateD, toDateD));
                request.setAttribute("fromDate", fromDateS);
                request.setAttribute("toDate", toDateS);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 63:
                servedPage = "/docs/units/list_payment_plans_of_project.jsp";
                prjID = request.getParameter("prjID");
                standardPaymentPlanMgr = new StandardPaymentPlanMgr();

                PaymentPlamsLst = new ArrayList<WebBusinessObject>();
                PaymentPlamsLst = standardPaymentPlanMgr.getPayPlansToProject(prjID, null);

                request.setAttribute("PaymentPlamsLst", PaymentPlamsLst);
                request.setAttribute("page", servedPage);
                this.forward(servedPage, request, response);

                break;

            case 64:
                clientID = request.getParameter("clientID");
                planID = request.getParameter("planID");

                paymentPlanMgr = PaymentPlanMgr.getInstance();

                Boolean cancel = false;
                try {
                    cancel = paymentPlanMgr.cancelPlan(planID, session);
                } catch (SQLException ex) {
                    java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                this.forward("UnitServlet?op=displaypaymentPlans&clientID=" + clientID, request, response);
                break;

            case 65:
                clientID = request.getParameter("clientID");
                planID = request.getParameter("planID");

                paymentPlanMgr = PaymentPlanMgr.getInstance();

                Boolean upStatus = false;
                try {
                    upStatus = paymentPlanMgr.requestPlanApproval(planID, session);
                } catch (SQLException ex) {
                    java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                this.forward("UnitServlet?op=displaypaymentPlans&clientID=" + clientID, request, response);
                break;

            case 66:
                servedPage = "/docs/units/approvePaymentPlans.jsp";
                String fromD = request.getParameter("fromD");
                String toD = request.getParameter("toD");
                String reqTyp = request.getParameter("reqTyp");

                paymentPlanMgr = PaymentPlanMgr.getInstance();
                planLst = new ArrayList<WebBusinessObject>();
                try {
                    planLst = paymentPlanMgr.getPayPlanToAllClients(fromD, toD, reqTyp);
                } catch (Exception ex) {
                    java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                projectMgr = ProjectMgr.getInstance();
                unitLst = new ArrayList<>();
                for (int i = 0; i < planLst.size(); i++) {
                    unitWbo = projectMgr.getOnSingleKey((String) planLst.get(i).getAttribute("unitID"));
                    unitLst.add(unitWbo);
                }

                request.setAttribute("unitLst", unitLst);
                request.setAttribute("planLst", planLst);
                request.setAttribute("fromDate", toD);
                request.setAttribute("toDate", fromD);
                request.setAttribute("reqTyp", reqTyp);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 67:
                clientID = request.getParameter("clientID");
                planID = request.getParameter("planID");

                paymentPlanMgr = PaymentPlanMgr.getInstance();

                upStatus = false;
                try {
                    upStatus = paymentPlanMgr.approvePaymentPlan(planID, session);
                } catch (SQLException ex) {
                    java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                this.forward("UnitServlet?op=approvePaymentPlans", request, response);
                break;

            case 68:
                clientID = request.getParameter("clientID");
                planID = request.getParameter("planID");

                paymentPlanMgr = PaymentPlanMgr.getInstance();

                upStatus = false;
                try {
                    upStatus = paymentPlanMgr.rejectPaymentPlan(planID, session);
                } catch (SQLException ex) {
                    java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                this.forward("UnitServlet?op=approvePaymentPlans", request, response);
                break;

            case 69:
                servedPage = "docs/units/getMyPaymentPlans.jsp";

                fromD = request.getParameter("fromD");
                toD = request.getParameter("toD");
                reqTyp = request.getParameter("reqTyp");
                Calendar cal = Calendar.getInstance();
                sdf = new SimpleDateFormat("yyyy/MM/dd");
                if (toD == null || toD.equals("")) {
                    toD = sdf.format(cal.getTime());
                }
                if (fromD == null || fromD.equals("")) {
                    cal.add(Calendar.MONTH, -1);
                    fromD = sdf.format(cal.getTime());
                }

                paymentPlanMgr = PaymentPlanMgr.getInstance();
                planLst = new ArrayList<WebBusinessObject>();
                try {
                    //planLst = paymentPlanMgr.getPayPlanToAllClients(fromD, toD, reqTyp);
                    planLst = paymentPlanMgr.getAllMyPayPlans(session, fromD, toD, reqTyp);
                } catch (Exception ex) {
                    java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                projectMgr = ProjectMgr.getInstance();
                unitLst = new ArrayList<>();
                for (int i = 0; i < planLst.size(); i++) {
                    unitWbo = projectMgr.getOnSingleKey((String) planLst.get(i).getAttribute("unitID"));
                    unitLst.add(unitWbo);
                }

                request.setAttribute("unitLst", unitLst);
                request.setAttribute("planLst", planLst);
                request.setAttribute("fromDate", toD);
                request.setAttribute("toDate", fromD);
                request.setAttribute("reqTyp", reqTyp);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 70:
                PDFTools pdfTolls = new PDFTools();

                StringBuilder plan_id = new StringBuilder();
                plan_id.append(request.getParameter("planID"));

                HashMap parameters = new HashMap();
                parameters.put("plan_id", plan_id);

                pdfTolls.generatePdfReport("paymentPlan", parameters, getServletContext(), response);
                break;
            case 71:
                out = response.getWriter();
                wbo = new WebBusinessObject();
                projectMgr = ProjectMgr.getInstance();
                wbo.setAttribute("isExists", projectMgr.getReservedUnitsByUnitCodeAndClientCode(request.getParameter("unitID"), request.getParameter("clientID")).isEmpty() ? "yes" : "no");
                out.write(Tools.getJSONObjectAsString(wbo));
                break;

            case 72:
                servedPage = "docs/units/viewAllBasicPayPlns.jsp";
                prjID = null;
                standardPaymentPlanMgr = new StandardPaymentPlanMgr();

                PaymentPlamsLst = new ArrayList<WebBusinessObject>();
                PaymentPlamsLst = standardPaymentPlanMgr.getPayPlansToProject(prjID, null);

                request.setAttribute("PaymentPlamsLst", PaymentPlamsLst);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 73:
                out = response.getWriter();
                wbo = new WebBusinessObject();
                paymentPlanMgr = PaymentPlanMgr.getInstance();
                wbo.setAttribute("status", "no");
                try {
                    ArrayList<WebBusinessObject> planList = new ArrayList<>(paymentPlanMgr.getOnArbitraryDoubleKeyOracle(request.getParameter("unitID"),
                            "key2", request.getParameter("clientID"), "key1"));
                    if (!planList.isEmpty()) {
                        wbo.setAttribute("status", "ok");
                        wbo.setAttribute("planID", planList.get(0).getAttribute("planID"));
                    }
                } catch (Exception ex) {
                    java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                out.write(Tools.getJSONObjectAsString(wbo));
                break;

            case 74:
                servedPage = "docs/units/detailedPaymentPlanSystem.jsp";

                save = request.getParameter("save");

                standardPaymentPlanMgr = new StandardPaymentPlanMgr();

                projectID = request.getParameter("projectID");
                planName = request.getParameter("planID");
                resAmnt = request.getParameter("resID");
                resIDMin = request.getParameter("resIDMin");
                resIDMax = request.getParameter("resIDMax");
                downPayAmnt = request.getParameter("downPayID");
                downPayIDMin = request.getParameter("downPayIDMin");
                downPayIDMax = request.getParameter("downPayIDMax");
                downMnth = request.getParameter("downMonNum");
                insPayAmntSys = request.getParameter("insPayNe");
                insMnth = request.getParameter("insMonNum");
                insNo = request.getParameter("insNum");
                //insAmt = request.getParameter("insPayIDSelect");
                insPayIDSelect = request.getParameter("insPayIDSelect");
                insPayIDInput = request.getParameter("insPayIDInput");
                insAmt = null;
                if (insPayIDInput != null && !insPayIDInput.equalsIgnoreCase("0") && !insPayIDInput.equalsIgnoreCase("") && !insPayIDInput.equalsIgnoreCase(" ")) {
                    insAmt = request.getParameter("insPayIDInput").toString().split("%")[0];
                } else if (insPayIDSelect != null && !insPayIDSelect.equalsIgnoreCase("0")) {
                    insAmt = request.getParameter("insPayIDSelect");
                }
                insPayIDSelectMin = request.getParameter("insPayIDSelectMin");
                insPayIDSelectMax = request.getParameter("insPayIDSelectMax");
                loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");

                String yearInsPayTyp = request.getParameter("yearInsPayID");
                String yearInsPayVal = request.getParameter("yearInsPayIDSelect");
                String yearMinInsPayVal = request.getParameter("yearinsNum");

                planID = "";

                if (save != null && save.equals("yes")) {
                    save = "yes";

                    try {
                        planID = standardPaymentPlanMgr.saveObject(planName, resAmnt, downPayAmnt, downMnth, insPayAmntSys, insMnth, insNo, (String) loggedUser.getAttribute("userId"), insAmt, projectID, yearInsPayTyp, yearInsPayVal, yearMinInsPayVal);
                        if (standardPaymentPlanMgr.saveStndrPymntPlnRng(planID, resIDMin, resIDMax, downPayIDMin, downPayIDMax, insPayIDSelectMin, insPayIDSelectMax)) {
                            save = "yes";
                            this.forward("/UnitServlet?op=viewAllBasicPayPlns", request, response);
                            break;
                        } else {
                            save = "no";
                        }
                    } catch (SQLException ex) {
                        java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
                projectMgr = ProjectMgr.getInstance();
                 {
                    try {
                        ArrayList<WebBusinessObject> projectsLst = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKey("44", "key4"));
                        request.setAttribute("projectsLst", projectsLst);
                    } catch (Exception ex) {
                        java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
                request.setAttribute("save", save);

                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 75:
                servedPage = "docs/units/dual_payment_plan.jsp";

                projectMgr = ProjectMgr.getInstance();
                unitID = request.getParameter("unitID");
                prjID = projectMgr.getOnSingleKey(unitID).getAttribute("mainProjId").toString();
                typ = request.getParameter("typ");

                standardPaymentPlanMgr = new StandardPaymentPlanMgr();

                PaymentPlamsLst = new ArrayList<WebBusinessObject>();
                PaymentPlamsLst = standardPaymentPlanMgr.getPayPlansToProject(prjID, typ);

                request.setAttribute("PaymentPlamsLst", PaymentPlamsLst);

                projectMgr = ProjectMgr.getInstance();
                unitWbo = projectMgr.getOnSingleKey(unitID);

                projectWbo = projectMgr.getOnSingleKey((String) unitWbo.getAttribute("mainProjId"));
                projectAccMgr = ProjectAccountingMgr.getInstance();
                projectEntityMgr = ProjectEntityMgr.getInstance();
                projectAcc = new WebBusinessObject();
                grageWbo = new WebBusinessObject();
                lockerWbo = new WebBusinessObject();
                try {
                    projectAcc = projectAccMgr.getProjectAccount((String) projectWbo.getAttribute("projectID"));
                } catch (UnsupportedConversionException ex) {
                    java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                if (projectAcc.getAttribute("garageNumber") != null && Integer.parseInt(projectAcc.getAttribute("garageNumber").toString()) > 0) {
                    try {
                        grageWbo = projectEntityMgr.getEntityByType((String) projectAcc.getAttribute("projectAccId"), "garage");
                    } catch (UnsupportedTypeException ex) {
                        java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }

                if (projectAcc.getAttribute("lockerNumber") != null && Integer.parseInt(projectAcc.getAttribute("lockerNumber").toString()) > 0) {
                    try {
                        lockerWbo = projectEntityMgr.getEntityByType((String) projectAcc.getAttribute("projectAccId"), "locker");
                    } catch (UnsupportedTypeException ex) {
                        java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }

                unitPriceWbo = UnitPriceMgr.getInstance().getLastPriceForUnit(unitID);

                unitTimelineMgr = UnitTimelineMgr.getInstance();
                datewbo = unitTimelineMgr.getSpecificUnitDate(unitID, "finishing");

                clientMgr = ClientMgr.getInstance();

                client = new Vector();
                clientID = request.getParameter("clientID");
                try {
                    client = clientMgr.clientByName(clientID, "id");
                } catch (SQLException ex) {
                    java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                standardPaymentPlanMgr = StandardPaymentPlanMgr.getInstance();
                sPayPlanLst = standardPaymentPlanMgr.getStandaredPayPlans(prjID, typ);

                request.setAttribute("typ", typ);
                request.setAttribute("sPayPlanLst", sPayPlanLst);
                request.setAttribute("unitWbo", unitWbo);
                request.setAttribute("projectWbo", projectWbo);
                request.setAttribute("unitPriceWbo", unitPriceWbo);
                request.setAttribute("grageWbo", grageWbo);
                request.setAttribute("lockerWbo", lockerWbo);
                request.setAttribute("datewbo", datewbo);
                request.setAttribute("client", client);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 76:
                servedPage = "/docs/units/apartments_pricing.jsp";
                projectMgr = ProjectMgr.getInstance();
                apartmentsList = new ArrayList<>();
                unitStatus = request.getParameter("unitStatus");
                if (unitStatus == null) {
                    unitStatus = "8";
                }
                EmpRelationMgr empRelationMgr = EmpRelationMgr.getInstance();
                WebBusinessObject managerWbo = empRelationMgr.getOnSingleKey("key2", (String) persistentUser.getAttribute("userId"));
                WebBusinessObject departmentWbo;
                if (managerWbo != null) {
                    departmentWbo = projectMgr.getOnSingleKey("key5", (String) managerWbo.getAttribute("mgrId"));
                } else {
                    departmentWbo = projectMgr.getOnSingleKey("key5", (String) persistentUser.getAttribute("userId"));
                }
                if (departmentWbo != null) {
                    apartmentsList = new ArrayList<>(projectMgr.getAllUnitsWithPriceAndDetails((String) departmentWbo.getAttribute("projectID"), unitStatus, request.getParameter("projectID")));
                }
                try {
                    request.setAttribute("projectsList", new ArrayList<>(projectMgr.getOnArbitraryKey("44", "key4")));
                } catch (Exception ex) {
                    request.setAttribute("projectsList", new ArrayList<>());
                }
                request.setAttribute("projectID", request.getParameter("projectID"));
                request.setAttribute("apartmentsList", apartmentsList);
                request.setAttribute("page", servedPage);
                request.setAttribute("unitStatus", unitStatus);
                this.forwardToServedPage(request, response);
                break;
            case 77:
                servedPage = "docs/units/simple_payment_plan.jsp";
                projectMgr = ProjectMgr.getInstance();
                try {
                    request.setAttribute("projectsLst", new ArrayList<>(projectMgr.getOnArbitraryKey("44", "key4")));
                } catch (Exception ex) {
                    java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 78:
                out = response.getWriter();
                standardPaymentPlanMgr = StandardPaymentPlanMgr.getInstance();
                wbo = standardPaymentPlanMgr.getOnSingleKey(request.getParameter("paymentPlanID"));
                out.write(Tools.getJSONObjectAsString(wbo));
                break;
            case 79:
                servedPage = "/docs/Adminstration/add_garages.jsp";
                projectMgr = ProjectMgr.getInstance();
                request.setAttribute("data", projectMgr.getVirtualBuildingsNo());
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 80:
                out = response.getWriter();
                wbo = new WebBusinessObject();
                String ReservationID = request.getParameter("ReservationID");
                clientID = request.getParameter("clientID");
                paymentPlanMgr = PaymentPlanMgr.getInstance();
                FinancialTransactionMgr financialTransactionMgr = FinancialTransactionMgr.getInstance();
                projectMgr = ProjectMgr.getInstance();
                float contractV = 0;
                float reserV = 0;
                float totalTrV = 0;
                String creation_time = "";
                ArrayList<WebBusinessObject> transactionsList = new ArrayList<WebBusinessObject>();
                wbo.setAttribute("PaymentExist", "no");
                try {
                    ArrayList<WebBusinessObject> planList = new ArrayList<>(paymentPlanMgr.getOnArbitraryDoubleKeyOracle(request.getParameter("unitID"),
                            "key2", request.getParameter("clientID"), "key1"));
                    if (!planList.isEmpty()) {
                        wbo.setAttribute("PaymentExist", "ok");
                    }
                } catch (Exception ex) {
                    java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                WebBusinessObject unitValues = projectMgr.getUnitResValusForClient(ReservationID);
                if (unitValues != null) {
                    contractV = Float.parseFloat(unitValues.getAttribute("contractV").toString());
                    reserV = Float.parseFloat(unitValues.getAttribute("reservationV").toString());
                    creation_time = unitValues.getAttribute("creationTime").toString();
                }
                String timeStamp = new SimpleDateFormat("YYYY/MM/dd").format(new Date());
                fromD = creation_time.split(" ")[0].replace("-", "/");
                try {
                    transactionsList = new ArrayList<WebBusinessObject>(financialTransactionMgr.getTransactionsList(clientID, fromD, timeStamp));
                    for (WebBusinessObject wboRes : transactionsList) {
                        totalTrV += Float.parseFloat(wboRes.getAttribute("transNetValue").toString());
                    }
                } catch (Exception ex) {
                    java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                if ((contractV + reserV) > totalTrV) {
                    wbo.setAttribute("elapsedM", "no");
                }

                out.write(Tools.getJSONObjectAsString(wbo));
                break;
            case 81:
                out = response.getWriter();
                wbo = new WebBusinessObject();
                String newUsr = request.getParameter("newUsr");
                String resvID = request.getParameter("resID");
                String[] updatedKeys = {"key5"};
                String[] updatedValues = {newUsr};
                reservationMgr = ReservationMgr.getInstance();
                if (reservationMgr.updateOnSingleKey(resvID, updatedKeys, updatedValues)) {
                    wbo.setAttribute("status", "ok");
                }

                out.write(Tools.getJSONObjectAsString(wbo));
                break;
            case 82:
                out = response.getWriter();
                wbo = new WebBusinessObject();
                String newBUsr = request.getParameter("newBUsr");
                String resvBID = request.getParameter("resBID");
                String[] updatedBKeys = {"key1"};
                String[] updatedBValues = {newBUsr};
                ClientCampaignMgr clientCampaignMgr = ClientCampaignMgr.getInstance();
                if (clientCampaignMgr.updateOnSingleKeyB(resvBID, updatedBKeys, updatedBValues)) {
                    wbo.setAttribute("status", "ok");
                }

                out.write(Tools.getJSONObjectAsString(wbo));
                break;

            case 83:
                out = response.getWriter();
                String wifiCurrentStatus = request.getParameter("unitCurrentStatus");
                String eventNameWifi = "";
                statusWbo = new WebBusinessObject();
                statusWbo.setAttribute("status", "faild");
                reservationMgr = ReservationMgr.getInstance();
                issueStatusMgr = IssueStatusMgr.getInstance();
                c = Calendar.getInstance();
                sdf = new SimpleDateFormat("yyyy-MM-dd");

                String ReservCard_CodeClient = MetaDataMgr.getInstance().getAssetErpName();
                WebBusinessObject clientInfo = new WebBusinessObject();
                WebBusinessObject clientAotherPhone = new WebBusinessObject();
                clientInfo = ClientMgr.getInstance().getOnSingleKey(request.getParameter("clientId"));
                String itemCode = request.getParameter("wifiId");
                String priceItem = request.getParameter("price");
                /*Vector<WebBusinessObject> clientAotherPhones = ClientCommunicationMgr.getInstance().getOnArbitraryDoubleKey((String) reservationWbo.getAttribute("clientId") , "key2", "phone", "key3");
                 if (!clientAotherPhones.isEmpty()) {
                 clientAotherPhone = clientAotherPhones.get(0);
                 } else {
                 clientAotherPhone = null;
                 }*/
                WebBusinessObject dataRealEstate = new WebBusinessObject();
                ArrayList<WebBusinessObject> getClientCheck = null;
                try {
                    getClientCheck = ClientMgr.getInstance().getClientCheckWiFi(clientInfo);
                } catch (SQLException ex) {
                    java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                String getClientChecks = "";
                for (WebBusinessObject webBusinessObject : getClientCheck) {
                    getClientChecks = webBusinessObject.getAttribute("CLIENT_CODE").toString();
                }
                if (getClientChecks == null || getClientChecks.equals("")) {
                    try {
                        String getMaxClientId = ClientMgr.getInstance().getMaxClientId();
                        String getMaxClientIdStore = ClientMgr.getInstance().getMaxClientIdStore();
                        String trnsNo = ClientMgr.getInstance().getMaxtrnsNo();
                        String storeNo = ClientMgr.getInstance().getMaxstoreNo();
                        dataRealEstate = ClientProductMgr.getInstance().saveInterestedProductRealEstatWifi(getMaxClientId, getMaxClientIdStore, clientInfo, trnsNo, storeNo, itemCode, priceItem);
                        statusWbo.setAttribute("status", "ok");
                        out.write(Tools.getJSONObjectAsString(statusWbo));
                    } catch (SQLException ex) {
                        java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                    } catch (NoSuchColumnException ex) {
                        java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                    } catch (InterruptedException ex) {
                        java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                } else {
                    ReservCard_CodeClient = getClientChecks;
                    statusWbo.setAttribute("status", "phone");
                    out.write(Tools.getJSONObjectAsString(statusWbo));
                }

                eventName = "Confirm";
                break;

        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Unit Servlet";
    }

    @Override
    protected int getOpCode(String opName) {
        if (opName.equalsIgnoreCase("getUnitPriceForm")) {
            return 1;
        } else if (opName.equalsIgnoreCase("saveUnitPrice")) {
            return 2;
        } else if (opName.equals("newResidentialModel")) {
            return 3;
        } else if (opName.equals("saveResidentialModel")) {
            return 4;
        } else if (opName.equalsIgnoreCase("reservedUnitsReport")) {
            return 5;
        } else if (opName.equalsIgnoreCase("listResidentialModel")) {
            return 6;
        } else if (opName.equalsIgnoreCase("viewResidentialModel")) {
            return 7;
        } else if (opName.equalsIgnoreCase("updateResidentialModel")) {
            return 8;
        } else if (opName.equals("newApartment")) {
            return 9;
        } else if (opName.equals("saveNewApartment")) {
            return 10;
        } else if (opName.equals("checkUnitAvailable")) {
            return 11;
        } else if (opName.equals("listApartments")) {
            return 12;
        } else if (opName.equals("ConfirmDeleteApartment")) {
            return 13;
        } else if (opName.equals("DeleteApartment")) {
            return 14;
        } else if (opName.equals("saveApartmentAsAjax")) {
            return 15;
        } else if (opName.equals("getUnitReservationPrint")) {
            return 16;
        } else if (opName.equals("changeApartmentStatusByAjax")) {
            return 17;
        } else if (opName.equals("updateApartmentsRules")) {
            return 18;
        } else if (opName.equals("ConfirmDeleteMoreApartment")) {
            return 19;
        } else if (opName.equals("deleteMoreApartments")) {
            return 20;
        } else if (opName.equals("confirmDeleteModel")) {
            return 21;
        } else if (opName.equals("deleteModel")) {
            return 22;
        } else if (opName.equals("modelsReport")) {
            return 23;
        } else if (opName.equals("changeReservationStatusByAjax")) {
            return 24;
        } else if (opName.equals("checkReservationByAjax")) {
            return 25;
        } else if (opName.equals("listUnitByProject")) {
            return 26;
        } else if (opName.equals("saveApartmentPrice")) {
            return 27;
        } else if (opName.equals("listAvailableApartments")) {
            return 28;
        } else if (opName.equals("newEngUnit")) {
            return 29;
        } else if (opName.equals("saveEngUnitAsAjax")) {
            return 30;
        } else if (opName.equals("editUnitPriceByAjax")) {
            return 31;
        } else if (opName.equals("getEditReservationForm")) {
            return 32;
        } else if (opName.equals("updateReservation")) {
            return 33;
        } else if (opName.equals("myReservedUnitsReport")) {
            return 34;
        } else if (opName.equals("getDeleteReservationDialog")) {
            return 35;
        } else if (opName.equals("deleteReservationByAjax")) {
            return 36;
        } else if (opName.equals("getSalesReport")) {
            return 37;
        } else if (opName.equals("getUnitsDetailsReport")) {
            return 38;
        } else if (opName.equals("editUnitRentTypeByAjax")) {//Kareem start
            return 39;
        } else if (opName.equals("viewRentContract")) {//Kareem
            return 40;
        } else if (opName.equalsIgnoreCase("saveRentContract")) {//Kareem
            return 41;
        } else if (opName.equalsIgnoreCase("listRentedUnits")) {//Kareem
            return 42;
        }//kareem end
        else if (opName.equalsIgnoreCase("getCompanyUnitReservationPrint")) {
            return 43;
        } else if (opName.equalsIgnoreCase("saveUnitTimeLine")) {
            return 44;
        } else if (opName.equalsIgnoreCase("deleteUnitTimeLine")) {
            return 45;
        } else if (opName.equalsIgnoreCase("editUnitTimeLine")) {
            return 46;
        } else if (opName.equalsIgnoreCase("saveMultiUnitTimeLine")) {
            return 47;
        } else if (opName.equalsIgnoreCase("paymentPlan")) {
            return 48;
        } else if (opName.equalsIgnoreCase("savePayPlan")) {
            return 49;
        } else if (opName.equalsIgnoreCase("deletePlan")) {
            return 50;
        } else if (opName.equalsIgnoreCase("displaypaymentPlans")) {
            return 51;
        } else if (opName.equalsIgnoreCase("showPaymentPlan")) {
            return 52;
        } else if (opName.equalsIgnoreCase("paymentPlanSystem")) {
            return 53;
        } else if (opName.equalsIgnoreCase("addAsset")) {
            return 54;
        } else if (opName.equalsIgnoreCase("getasset")) {
            return 55;
        } else if (opName.equalsIgnoreCase("deleteUnit")) {
            return 56;
        } else if (opName.equalsIgnoreCase("getModelsAjax")) {
            return 57;
        } else if (opName.equalsIgnoreCase("deleteUnitAjax")) {
            return 58;
        } else if (opName.equalsIgnoreCase("addPartner")) {
            return 59;
        } else if (opName.equalsIgnoreCase("employeeReservedUnits")) {
            return 60;
        } else if (opName.equalsIgnoreCase("viewMyPurchUnits")) {
            return 61;
        } else if (opName.equalsIgnoreCase("viewSalesUnits")) {
            return 62;
        } else if (opName.equalsIgnoreCase("getPaymentPlans")) {
            return 63;
        } else if (opName.equalsIgnoreCase("cancelPlan")) {
            return 64;
        } else if (opName.equalsIgnoreCase("requestApproval")) {
            return 65;
        } else if (opName.equalsIgnoreCase("approvePaymentPlans")) {
            return 66;
        } else if (opName.equalsIgnoreCase("approveRequest")) {
            return 67;
        } else if (opName.equalsIgnoreCase("rejectRequest")) {
            return 68;
        } else if (opName.equalsIgnoreCase("getMyPaymentPlans")) {
            return 69;
        } else if (opName.equalsIgnoreCase("showPaymentPlanPDF")) {
            return 70;
        } else if (opName.equalsIgnoreCase("isReservedAjax")) {
            return 71;
        } else if (opName.equalsIgnoreCase("viewAllBasicPayPlns")) {
            return 72;
        } else if (opName.equalsIgnoreCase("getPlanAjax")) {
            return 73;
        } else if (opName.equalsIgnoreCase("detailedPaymentPlanSystem")) {
            return 74;
        } else if (opName.equalsIgnoreCase("dualPaymentPlan")) {
            return 75;
        } else if (opName.equals("getApartmentsPricing")) {
            return 76;
        } else if (opName.equals("simplePaymentPlan")) {
            return 77;
        } else if (opName.equals("getPaymentPercentsAjax")) {
            return 78;
        } else if (opName.equals("addNewGarage")) {
            return 79;
        } else if (opName.equals("checksBeforConfirmation")) {
            return 80;
        } else if (opName.equals("updateSaleRepForUnitRes")) {
            return 81;
        } else if (opName.equals("updateSaleRepForUnitResB")) {
            return 82;
        } else if (opName.equals("updateWifi")) {
            return 83;
        }

        return 0;
    }
}
